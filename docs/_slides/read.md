---
editor_options: 
  chunk_output_type: console
---

## Simple Features

A standardized set of geometric shapes are the essense of vector data, but these are next to useless outside a tabular structure.


~~~r
sf <- import('sf')

lead <- read.csv('data/SYR_soil_PB.csv')
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

| geometry | description |
|----------+-------------|
| `st_point` | a single point |
| `st_linestring` | sequence of points connected by straight, non-self intersecting line pieces |
| `st_polygon` | one [or more] sequences of points in a closed, non-self intersecting ring [with holes] |
| `st_multi*` | sequence of `*`, either `point`, `linestring`, or `polygon` |

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

For example, the `print` method automatically shows the CRS and truncates the
number of records displayed.


~~~r
lead
~~~
{:.input}
~~~
Simple feature collection with 3149 features and 4 fields (with 3149 geometries empty)
geometry type:  POINT
dimension:      XY
bbox:           xmin: 408164.3 ymin: 4762321 xmax: 408164.3 ymax: 4762321
epsg (SRID):    32618
proj4string:    +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs
First 10 features:
          x       y ID      ppm                 geometry
1  408164.3 4762321  0 3.890648 POINT (408164.3 4762321)
2  405914.9 4767394  1 4.899391              POINT EMPTY
3  405724.0 4767706  2 4.434912              POINT EMPTY
4  406702.8 4769201  3 5.285548              POINT EMPTY
5  405392.3 4765598  4 5.295919              POINT EMPTY
6  405644.1 4762037  5 4.681277              POINT EMPTY
7  409183.1 4763057  6 3.364148              POINT EMPTY
8  407945.4 4770014  7 4.096946              POINT EMPTY
9  406341.4 4762603  8 4.689880              POINT EMPTY
10 404638.1 4767636  9 5.422257              POINT EMPTY
~~~
{:.output}

===

Naturally, there is a shortcut to creating an `sf` object from a data frame with
point coordinates. The CRS must be specified via EPSG integer or proj4 string.


~~~r
lead <- read.csv('data/SYR_soil_PB.csv')
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

## Feature Collections

More complicated geometries are usually not stored in CSV files, but they are
usually still read as tabular data. We will see that the similarity of feature
collections to non-spatial tabular data goes quite far; the usual data
manipulations done on tabular data work just as well on `sf` objects.
{:.notes}


~~~r
blockgroups <- sf$read_sf('data/bg_00')
~~~
{:.text-document title="{{ site.handouts[0] }}"}

===

Confirm that the coordinates in the geometry column are the correct UTMs.


~~~r
blockgroups
~~~
{:.input}
~~~
Simple feature collection with 147 features and 6 fields
geometry type:  POLYGON
dimension:      XY
bbox:           xmin: 401938.3 ymin: 4759734 xmax: 412486.4 ymax: 4771049
epsg (SRID):    32618
proj4string:    +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs
# A tibble: 147 x 7
   BKG_KEY      Shape_Leng Shape_Area BKG_KEY_1    Shape_Le_1 Shape_Ar_1
   <chr>             <dbl>      <dbl> <chr>             <dbl>      <dbl>
 1 360670001001     13520.   6135184. 360670001001     13520.   6135184.
 2 360670003002      2547.    301840. 360670003002      2547.    301840.
 3 360670003001      2678.    250998. 360670003001      2678.    250998.
 4 360670002001      3392.    656276. 360670002001      3392.    656276.
 5 360670004004      2224.    301086. 360670004004      2224.    301086.
 6 360670004001      3263.    606495. 360670004001      3263.    606495.
 7 360670004003      2878.    274532. 360670004003      2878.    274532.
 8 360670004002      3606.    331035. 360670004002      3606.    331035.
 9 360670010001      2951.    376786. 360670010001      2951.    376786.
10 360670010003      2868.    265836. 360670010003      2868.    265836.
# ... with 137 more rows, and 1 more variable: geometry <sf_geometry [m]>
~~~
{:.output}

Note the table dimensions show 147 features in the collection.


~~~r
dim(blockgroups)
~~~
{:.input}
~~~
[1] 147   7
~~~
{:.output}

===

Simple feature collections are data frames.


~~~r
class(blockgroups)
~~~
{:.input}
~~~
[1] "sf"         "tbl_df"     "tbl"        "data.frame"
~~~
{:.output}

===

The `blockgroups` object is a `data.frame`, but it also has the class attribute
of `sf`. This additional class extends the `data.frame` class in ways useful for
feature collection. For instance, the geometry column becomes "sticky" in most
table operations, like subsetting.
{:.notes}


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

## Table Operations

- plot
- merge or join
- "split-apply-combine" or group-by and summarize

===

In the `plot` method for feature collections, the "x" in the usual `plot(x,
y, ...)` automatically takes the sticky "geometry" column and the type of plot
is assumed to be a map. Only the "y" needs to be specified.


~~~r
plot(blockgroups['Shape_Area'])
~~~
{:.input}

![plot of chunk unnamed-chunk-15]({{ site.baseurl }}/images/unnamed-chunk-15-1.png)
{:.captioned}

===

Merging with a regular data frame is done by normal merging non-spatial columns
found in both tables.


~~~r
census <- read.csv('data/SYR_census.csv')
census$BKG_KEY <- factor(census$BKG_KEY)
~~~
{:.text-document title="{{ site.handouts[0] }}"}

As usual, there's the difficulty that CSV files do not include metadata on data
types, which have to be set manually.
{:.notes}

===

Merge tables on a unique identifier (our primary key is "BKG_KEY"), but let the
"sf" object come first or is special attributes get lost.


~~~r
import('dplyr', 
  'inner_join', 'group_by', 'summarise')

census_blockgroups <- inner_join(
  blockgroups, census,
  by = c('BKG_KEY'))
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

![plot of chunk unnamed-chunk-19]({{ site.baseurl }}/images/unnamed-chunk-19-1.png)
{:.captioned}

===

Feature collections also cooperate with the common "split-apply-combine" sequence of steps in data manipulation.

- *split* -- group the features by some factor
- *apply* -- apply a function that summarizes each subset, including their geometries
- *combine* -- return the results as columns of a new feature collection

===


~~~r
census_tracts <- census_blockgroups %>%
  group_by(TRACT) %>%
  summarise(
    POP2000 = sum(POP2000),
    perc_hispa = sum(HISPANIC) / sum(POP2000))
~~~
{:.text-document title="{{ site.handouts[0] }}"}

===

Read in the census tracts from a separate shapefile to confirm that the
boundaries were dissolved as expected.


~~~r
tracts <- sf$read_sf('data/ct_00')
plot(census_tracts['POP2000'])
plot(sf$st_geometry(tracts), border = 'red', add = TRUE)
~~~
{:.text-document title="{{ site.handouts[0] }}"}

![plot of chunk unnamed-chunk-21]({{ site.baseurl }}/images/unnamed-chunk-21-1.png)
{:.captioned}

===

By default, the sticky geometries are summarized with `st_union`. The
alternative `st_combine` does not dissolve internal boundaries. Check
`?summarise.sf` for more details.
