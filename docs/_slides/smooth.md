---
editor_options: 
  chunk_output_type: console
---
    
## The Semivariogram

A semivariogram quantifies the effect of distance on the correlation between
values from different locations. *On average*, measurements of the same variable
at two nearby locations are more similar (lower variance) than when those locations
are distant.
{:.notes}

The [gstat](){:.rlib} library, a geospatial analogue to the [stats](){:.rlib}
library provides variogram estimation among several additional tools.


~~~r
g <- import('gstat')

lead_xy <- read.csv('data/SYR_soil_PB.csv')
~~~
{:.text-document title="{{ site.handouts[0] }}"}

===

The empirical semivariogram shown below is a windowed average of the squared
difference in lead concentrations beween sample points.


~~~r
v_ppm <- g$variogram(
  ppm ~ 1,
  locations = ~ x + y,
  data = lead_xy)
plot(v_ppm)
~~~
{:.text-document title="{{ site.handouts[0] }}"}

![plot of chunk unnamed-chunk-2]({{ site.baseurl }}/images/unnamed-chunk-2-1.png)
{:.captioned}

===

Fitting a model semivariogram tidies up the information about autocorrelation
in the data, so we can use it for interpolation.


~~~r
v_ppm_fit <- g$fit.variogram(
  v_ppm,
  model = g$vgm(1, "Sph", 900, 1))
plot(v_ppm, v_ppm_fit)
~~~
{:.text-document title="{{ site.handouts[0] }}"}

![plot of chunk unnamed-chunk-3]({{ site.baseurl }}/images/unnamed-chunk-3-1.png)
{:.captioned}

===

## Kriging

The modeled semivariogram acts as a parameter for fitting a Guassian process, or
Kriging. The steps to perform Kriging with the [gstat](){:.rlib} library are

1. Generate a modeled semivariogram
1. Generate new locations for "predicted" values
1. Call `krige` with the data, locations, and semivariogram

===

Generate a low resolution (for demonstration) grid of points overlaying the
bounding box for the lead data and trim it down to the polygons of interest.
Remember, that goal is aggregating lead concentrations within each census tract.


~~~r
pred_ppm <- sf$st_make_grid(
  lead, cellsize = 400,
  what = 'centers')
idx <- unlist(
  sf$st_intersects(census_tracts, pred_ppm))
pred_ppm <- pred_ppm[idx]
~~~
{:.text-document title="{{ site.handouts[0] }}"}

===

Map the result to verify generated points.


~~~r
plot(census_tracts['POP2000'],
  pal = cm.colors)
plot(pred_ppm,
  pch = '.', add = TRUE)
~~~
{:.text-document title="{{ site.handouts[0] }}"}

![plot of chunk unnamed-chunk-5]({{ site.baseurl }}/images/unnamed-chunk-5-1.png)
{:.captioned}

===

Like the `gstat` function, the `krige` function doesn't work seemlessly with
`sf` objects, so again create a data frame with coordinates.


~~~r
pred_ppm_xy <- data.frame(
  do.call(rbind, pred_ppm))
names(pred_ppm_xy) <- c('x', 'y')
~~~
{:.text-document title="{{ site.handouts[0] }}"}

===

Almost done ...

1. Generate a modeled semivariogram
1. Generate new locations for "predicted" values
1. Call `krige` with the data, locations, and semivariogram

===

The first argument specifies the model for the means, which is constant according to our 
formula for lead concentrations. The result, like the input for locations, is
a data frame with coordinates and a prediction for lead concentrations.


~~~r
pred_ppm_xy <- g$krige(
  ppm ~ 1,
  locations = ~ x + y,
  data = lead_xy,
  newdata = pred_ppm_xy,
  model = v_ppm_fit)
~~~
{:.text-document title="{{ site.handouts[0] }}"}

===

The same commands that created the `sf` table for lead apply to creating a `sf`
table for the predicted concentrations.


~~~r
pred_ppm <- sf$st_as_sf(
  pred_ppm_xy,
  coords = c('x', 'y'),
  crs = sf$st_crs(lead))
~~~
{:.text-document title="{{ site.handouts[0] }}"}

===

And the same commands that joined lead concentrations to census tracts apply to
joining the predicted concentrations in too.


~~~r
pred_ppm_tracts <-
  pred_ppm %>%
  sf$st_join(census_tracts) %>%
  sf$st_set_geometry(NULL) %>%
  group_by(TRACT) %>%
  summarise(pred_ppm = mean(var1.pred))
census_lead_tracts <- 
  census_lead_tracts %>%
  inner_join(pred_ppm_tracts)
~~~
{:.text-document title="{{ site.handouts[0] }}"}

===


~~~r
plot(census_lead_tracts[
  c('pred_ppm', 'avg_ppm')],
  pal = heat.colors)
~~~
{:.text-document title="{{ site.handouts[0] }}"}

![plot of chunk unnamed-chunk-10]({{ site.baseurl }}/images/unnamed-chunk-10-1.png)
{:.captioned}

===

The effect of paying attention to autocorrelation is subtle, but it is noticable and had the expected effect in tract 5800.


~~~r
census_lead_tracts[52,]
~~~
{:.input}
~~~
Simple feature collection with 1 feature and 5 fields
geometry type:  POLYGON
dimension:      XY
bbox:           xmin: 405633.1 ymin: 4762867 xmax: 406445.9 ymax: 4764711
epsg (SRID):    32618
proj4string:    +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs
# A tibble: 1 x 6
  TRACT POP2000 perc_hispa avg_ppm pred_ppm                       geometry
  <int>   <int>      <dbl>   <dbl>    <dbl>                  <POLYGON [m]>
1  5800    2715     0.0302    5.44     5.53 ((406445.9 4762893, 406017.5 ~
~~~
{:.output}
