---
editor_options: 
  chunk_output_type: console
---
    
## The Semivariogram

A semivariogram quantifies the effect of distance on the correlation between
values from different locations. On **average**, measurements of the same variable
at two nearby locations are more similar (lower variance) than when those locations
are distant.
{:.notes}

The [gstat](){:.Rpkg} library, a geospatial analogue to the [stats](){:.Rpkg}
library provides variogram estimation among several additional tools.


~~~r
g <- import('gstat')

lead_xy <- read.csv('data/Soil_PB.csv')
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
Kriging. The steps to perform Kriging with the [gstat](){:.Rpkg} library are

- [x] Generate a modeled semivariogram
- [ ] Generate new locations for "predicted" values
- [ ] Call `krige` with the data, locations, and semivariogram

===

Generate a low resolution (for demonstration) grid of points overlaying the
bounding box for the lead data and trim it down to the polygons of interest.
Remember, that goal is aggregating lead concentrations within each census tract.


~~~r
pred_ppm <- sf$st_make_grid(
  lead, cellsize = 400,
  what = 'centers')
idx <- unlist(sf$st_intersects(census_tracts, pred_ppm))
pred_ppm <- pred_ppm[idx]
~~~
{:.text-document title="{{ site.handouts[0] }}"}

===

Map the result to verify generated points.


~~~r
plot(census_tracts['POP2000'], pal = cm.colors)
plot(pred_ppm, pch = '.', add = TRUE)
~~~
{:.input}

![plot of chunk unnamed-chunk-5]({{ site.baseurl }}/images/unnamed-chunk-5-1.png)
{:.captioned}

===

Like the `gstat` function, the `krige` function doesn't work seemlessly with
`sf` objects, so again create a data frame with coordinates.


~~~r
pred_ppm_xy <- data.frame(do.call(rbind, pred_ppm))
names(pred_ppm_xy) <- c('x', 'y')
~~~
{:.text-document title="{{ site.handouts[0] }}"}

===

Almost dones ...

- [x] Generate a modeled semivariogram
- [x] Generate new locations for "predicted" values
- [ ] Call `krige` with the data, locations, and semivariogram

===

The first argument specifies the model for the means, which is constant according to our 
formula for lead concentrations. The resuly, like the input for locations, is
a data frame with coordinates and a prediction for lead concentrations.


~~~r
pred_ppm_xy <- g$krige(
  ppm ~ 1,
  locations = ~ x + y,
  data = lead_xy,
  newdata = pred_ppm_xy,
  model = v_ppm_fit)
~~~

~~~
[using ordinary kriging]
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
pred_ppm_tracts <- pred_ppm %>%
  sf$st_join(census_tracts) %>%
  sf$st_set_geometry(NULL) %>%
  group_by(TRACT) %>%
  summarise(pred_ppm = mean(var1.pred))
~~~

~~~
Error in group_by(., TRACT): could not find function "group_by"
~~~

~~~r
census_lead_pred_tracts <- census_lead_tracts %>%
    inner_join(pred_ppm_tracts)
~~~

~~~
Error in eval(lhs, parent, parent): object 'census_lead_tracts' not found
~~~
{:.text-document title="{{ site.handouts[0] }}"}

===


~~~r
plot(census_lead_pred_tracts[
  c('pred_ppm', 'avg_ppm')],
  pal = heat.colors)
~~~

~~~
Error in plot(census_lead_pred_tracts[c("pred_ppm", "avg_ppm")], pal = heat.colors): object 'census_lead_pred_tracts' not found
~~~
{:.text-document title="{{ site.handouts[0] }}"}

===

The effect of paying attention to autocorrelation is subtle, but it is noticable and had the expected effect in tract 5800.


~~~r
census_lead_pred_tracts[52,]
~~~
{:.input}
~~~
Error in eval(expr, envir, enclos): object 'census_lead_pred_tracts' not found
~~~
{:.output}
