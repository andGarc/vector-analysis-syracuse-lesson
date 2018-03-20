---
editor_options: 
  chunk_output_type: console
---

## Import Clarity


~~~r
library('modules')
~~~
{:.text-document title="{{ site.handouts[0] }}"}

## Features


~~~r
sf <- import('sf')

lead <- read.csv('data/Soil_PB.csv')
lead[['geometry']] <- sf$st_sfc(
  sf$st_point(),
  crs = 32618)
~~~
{:.text-document title="{{ site.handouts[0] }}"}


~~~r
head(lead)
~~~
{:.input}
~~~
         x       y ID      ppm    geometry
1 408164.3 4762321  0 3.890648 POINT EMPTY
2 405914.9 4767394  1 4.899391 POINT EMPTY
3 405724.0 4767706  2 4.434912 POINT EMPTY
4 406702.8 4769201  3 5.285548 POINT EMPTY
5 405392.3 4765598  4 5.295919 POINT EMPTY
6 405644.1 4762037  5 4.681277 POINT EMPTY
~~~
{:.output}

===

simple feature geometry | description
`st_point` | a single point
`st_linestring` | sequence of points connected by straight, non-self intersecting line pieces
`st_polygon` | one or more sequences of points in a closed, non-self intersecting ring; the first ring denotes the exterior ring, zero or more subsequent rings denote holes in this exterior ring
`st_multi*` | set of points/linestrings/polygongs; a MULTIPOINT is simple if no two Points in the MULTIPOINT are equal

===

Each element of the simple feature column is a simple feature geometry, here
created from the "x" and "y" elements of a given feature.


~~~r
lead[[1, 'geometry']] <- sf$st_point(
  c(x = lead[[1, 'x']], y = lead[[1, 'y']]),
  dim = 'XY')
~~~
{:.text-document title="{{ site.handouts[0] }}"}


~~~r
head(lead)
~~~
{:.input}
~~~
         x       y ID      ppm                 geometry
1 408164.3 4762321  0 3.890648 POINT (408164.3 4762321)
2 405914.9 4767394  1 4.899391              POINT EMPTY
3 405724.0 4767706  2 4.434912              POINT EMPTY
4 406702.8 4769201  3 5.285548              POINT EMPTY
5 405392.3 4765598  4 5.295919              POINT EMPTY
6 405644.1 4762037  5 4.681277              POINT EMPTY
~~~
{:.output}

===

The whole data frame must be cast to a simple feature object, which causes
functions like `print` and `plot` to use methods introduced by the `sf` library.


~~~r
lead <- sf$st_sf(lead)
~~~
{:.text-document title="{{ site.handouts[0] }}"}

===

Naturally, there is a shortcut to creating an `sf` object from a data frame with
point coordinates. The CRS must be specified, via EPSG integer or proj4 string.


~~~r
lead <- read.csv('data/Soil_PB.csv')
lead <- sf$st_as_sf(lead,
  coords = c('x', 'y'),
  crs = 32618)
~~~
{:.text-document title="{{ site.handouts[0] }}"}


~~~r
lead
~~~
{:.input}
~~~
Simple feature collection with 3149 features and 2 fields
geometry type:  POINT
dimension:      XY
bbox:           xmin: 401993 ymin: 4759765 xmax: 412469 ymax: 4770955
epsg (SRID):    32618
proj4string:    +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs
First 10 features:
   ID      ppm                 geometry
1   0 3.890648 POINT (408164.3 4762321)
2   1 4.899391 POINT (405914.9 4767394)
3   2 4.434912   POINT (405724 4767706)
4   3 5.285548 POINT (406702.8 4769201)
5   4 5.295919 POINT (405392.3 4765598)
6   5 4.681277 POINT (405644.1 4762037)
7   6 3.364148 POINT (409183.1 4763057)
8   7 4.096946 POINT (407945.4 4770014)
9   8 4.689880 POINT (406341.4 4762603)
10  9 5.422257 POINT (404638.1 4767636)
~~~
{:.output}

===

Now that table is an `sf` object, the data are easilly displayed as a map.


~~~r
plot(lead['ppm'])
~~~
{:.text-document title="{{ site.handouts[0] }}"}

![plot of chunk unnamed-chunk-9]({{ site.baseurl }}/images/unnamed-chunk-9-1.png)
{:.captioned}

===

## Feature Collections == Tabular Data

More complicated geometries are usually not stored in CSV files, but they are
usually still read as tabular data. We will see that the similarity of feature
collections to non-spatial tabular data goes quite far; the usual data
manipulations done on tabular data work just as well on `sf` objects.
{:.notes}


~~~r
blockgroups <- sf$read_sf('data/bg_00.shp')
~~~
{:.text-document title="{{ site.handouts[0] }}"}

===

Confirm that the coordinates in the geometry column could be in UTM.


~~~r
head(blockgroups)
~~~
{:.input}
~~~
Simple feature collection with 6 features and 6 fields
geometry type:  POLYGON
dimension:      XY
bbox:           xmin: 402304.2 ymin: 4767421 xmax: 408399.3 ymax: 4771049
epsg (SRID):    32618
proj4string:    +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs
# A tibble: 6 x 7
  BKG_KEY      Shape_Leng Shape_Area BKG_KEY_1    Shape_Le_1 Shape_Ar_1
  <chr>             <dbl>      <dbl> <chr>             <dbl>      <dbl>
1 360670001001     13520.   6135184. 360670001001     13520.   6135184.
2 360670003002      2547.    301840. 360670003002      2547.    301840.
3 360670003001      2678.    250998. 360670003001      2678.    250998.
4 360670002001      3392.    656276. 360670002001      3392.    656276.
5 360670004004      2224.    301086. 360670004004      2224.    301086.
6 360670004001      3263.    606495. 360670004001      3263.    606495.
# ... with 1 more variable: geometry <sf_geometry [m]>
~~~
{:.output}

The table dimensions show 147 features in the collection.


~~~r
dim(blockgroups)
~~~
{:.input}
~~~
[1] 147   7
~~~
{:.output}

===

The `blockgroups` object is a `data.frame`, but it also has the class attribute
of `sf`. This includes some natural extensions, including some variations on
subsetting. The geometry column is "sticky".


~~~r
blockgroups[1:5, 'BKG_KEY']
~~~
{:.input}
~~~
Simple feature collection with 5 features and 1 field
geometry type:  POLYGON
dimension:      XY
bbox:           xmin: 402304.2 ymin: 4767421 xmax: 407469 ymax: 4771049
epsg (SRID):    32618
proj4string:    +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs
# A tibble: 5 x 2
  BKG_KEY                            geometry
  <chr>                     <sf_geometry [m]>
1 360670001001 POLYGON ((403476.4 4767682,...
2 360670003002 POLYGON ((406271.7 4770188,...
3 360670003001 POLYGON ((406730.3 4770235,...
4 360670002001 POLYGON ((406436.1 4770029,...
5 360670004004 POLYGON ((407469 4770033, 4...
~~~
{:.output}

===

## Common Table Operations

- scatter plot
- "merge" or "join"
- "split-apply-combine" or "group-by and summarize"

===

The "x" in the usual `plot(x, y, ...)` essentially becomes the "geometry" column
that sticks around for all `sf` objects. Only the "y" needs to be specified.


~~~r
plot(blockgroups['Shape_Area'])
~~~
{:.input}

![plot of chunk unnamed-chunk-14]({{ site.baseurl }}/images/unnamed-chunk-14-1.png)
{:.captioned}

===

Merging with non-spatial data is done by non-spatial columns in both data frames.
As usual, there's the difficulty that CSV files do not include metadata on data types,
which have to be set manually.


~~~r
census <- read.csv('data/census.csv')
census$BKG_KEY <- factor(census$BKG_KEY)
~~~
{:.text-document title="{{ site.handouts[0] }}"}

===

Merge tables on unique identifier (primary key is "BKG_KEY"). Keep the "sf"
object first, or the class attribute gets lost.


~~~r
import('dplyr', 
  'inner_join', 'group_by', 'summarise')

census_blockgroups <- inner_join(blockgroups, census, by = c('BKG_KEY'))
~~~

~~~
Warning: Column `BKG_KEY` joining character vector and factor, coercing
into character vector
~~~
{:.text-document title="{{ site.handouts[0] }}"}


~~~r
class(census_blockgroups)
~~~
{:.input}
~~~
[1] "sf"         "tbl_df"     "tbl"        "data.frame"
~~~
{:.output}

===

The census data is now easily vizualized as a map.


~~~r
plot(census_blockgroups['POP2000'])
~~~
{:.text-document title="{{ site.handouts[0] }}"}

![plot of chunk unnamed-chunk-18]({{ site.baseurl }}/images/unnamed-chunk-18-1.png)
{:.captioned}

===


~~~r
import('magrittr', '%>%')

census_tracts <- census_blockgroups %>%
  group_by(TRACT) %>%
  summarise(
    POP2000 = sum(POP2000),
    perc_hispa = sum(HISPANIC) / sum(POP2000))
plot(census_tracts['POP2000'])
~~~
{:.text-document title="{{ site.handouts[0] }}"}

![plot of chunk unnamed-chunk-19]({{ site.baseurl }}/images/unnamed-chunk-19-1.png)
{:.captioned}

===

Read in the census tracts from a separate shapefile to confirm that the
boundaries were dissolved as expected.


~~~r
tracts <- sf$read_sf('data/ct_00.shp')
plot(sf$st_geometry(tracts), border = 'red', add = TRUE)
~~~

~~~
Error in polypath(p_bind(x[[i]]), border = border[i], lty = lty[i], lwd = lwd[i], : plot.new has not been called yet
~~~
{:.text-document title="{{ site.handouts[0] }}"}

===

By default, the sticky geometries are summarized with `st_union`. The
alternative `st_combine` does not dissolve internal boundaries. Check
`?summarise.sf` for more details.

===

