---
editor_options: 
  chunk_output_type: console
---

## Spatial Join

The data about lead contamination in soils is at points; the census information
is for polygons. One way to join these pieces of information together involves
finding out which polygon encompases each point.
{:.notes}


~~~r
plot(census_tracts['POP2000'], pal = cm.colors)
plot(sf$st_geometry(lead), pch = '.', add = TRUE)
~~~
{:.text-document title="{{ site.handouts[0] }}"}

![plot of chunk unnamed-chunk-1]({{ site.baseurl }}/images/unnamed-chunk-1-1.png)
{:.captioned}

===

In the previous section, we performed a table join using a non-spatial
data type. More specifically, we performed an equality join: records were merged
wherever the join variable in the "left table" equalled the variable in the
"right table". Spatial joins operate on the "geometry" column and require
expanding on the basic equality join to allow several different kinds of matching.
{:.notes}

![]({{ site.baseurl }}/images/atlassian_workflow.svg){:width="50%"}  
*[Image][geometry-predicates] by Kraus / [CC BY]*

===

Before doing any spatial join, it is essential that both tables share a common
CRS.


~~~r
sf$st_crs(lead)
~~~

~~~
Coordinate Reference System:
  EPSG: 32618 
  proj4string: "+proj=utm +zone=18 +datum=WGS84 +units=m +no_defs"
~~~

~~~r
sf$st_crs(census_tracts)
~~~

~~~
Coordinate Reference System:
  EPSG: 32618 
  proj4string: "+proj=utm +zone=18 +datum=WGS84 +units=m +no_defs"
~~~
{:.text-document title="{{ site.handouts[0] }}"}

===

The `st_join` function performs a left join using the geometries of the two
simple feature collections.


~~~r
sf$st_join(lead, census_tracts)
~~~
{:.input}
~~~
Simple feature collection with 3149 features and 5 fields
geometry type:  POINT
dimension:      XY
bbox:           xmin: 401993 ymin: 4759765 xmax: 412469 ymax: 4770955
epsg (SRID):    32618
proj4string:    +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs
First 10 features:
   ID      ppm TRACT POP2000 perc_hispa                 geometry
1   0 3.890648  6102    2154 0.01578459 POINT (408164.3 4762321)
2   1 4.899391  3200    2444 0.10515548 POINT (405914.9 4767394)
3   2 4.434912   100     393 0.03053435   POINT (405724 4767706)
4   3 5.285548   700    1630 0.03190184 POINT (406702.8 4769201)
5   4 5.295919  3900    4405 0.23541430 POINT (405392.3 4765598)
6   5 4.681277  6000    3774 0.04027557 POINT (405644.1 4762037)
7   6 3.364148  5602    2212 0.08318264 POINT (409183.1 4763057)
8   7 4.096946   400    3630 0.01019284 POINT (407945.4 4770014)
9   8 4.689880  6000    3774 0.04027557 POINT (406341.4 4762603)
10  9 5.422257  2100    1734 0.09169550 POINT (404638.1 4767636)
~~~
{:.output}

===

- Only the "left" geometry is preserved in the output
- Matching defaults to `st_intersects` but permits any predicate function


~~~r
sf$st_join(lead, census_tracts, join = st_touches)
~~~
{:.input}
~~~
Simple feature collection with 3149 features and 5 fields
geometry type:  POINT
dimension:      XY
bbox:           xmin: 401993 ymin: 4759765 xmax: 412469 ymax: 4770955
epsg (SRID):    32618
proj4string:    +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs
First 10 features:
   ID      ppm TRACT POP2000 perc_hispa                 geometry
1   0 3.890648    NA      NA         NA POINT (408164.3 4762321)
2   1 4.899391    NA      NA         NA POINT (405914.9 4767394)
3   2 4.434912    NA      NA         NA   POINT (405724 4767706)
4   3 5.285548    NA      NA         NA POINT (406702.8 4769201)
5   4 5.295919    NA      NA         NA POINT (405392.3 4765598)
6   5 4.681277    NA      NA         NA POINT (405644.1 4762037)
7   6 3.364148    NA      NA         NA POINT (409183.1 4763057)
8   7 4.096946    NA      NA         NA POINT (407945.4 4770014)
9   8 4.689880    NA      NA         NA POINT (406341.4 4762603)
10  9 5.422257    NA      NA         NA POINT (404638.1 4767636)
~~~
{:.output}

===

The population data is at the coarser scale, so the lead ought to be averaged
within a census tract. Once each lead measurement is joined to a "TRACT" id, the
spatial data can by dropped.


~~~r
lead_tracts <- lead %>%
    sf$st_join(census_tracts) %>%
    sf$st_set_geometry(NULL)
~~~
{:.text-document title="{{ site.handouts[0] }}"}

===

Two more steps to group the data by TRACT and average the lead concentrations within each TRACT


~~~r
lead_tracts <- lead %>%
    sf$st_join(census_tracts) %>%
    sf$st_set_geometry(NULL) %>%
    group_by(TRACT) %>%
    summarise(avg_ppm = mean(ppm))
~~~

~~~
Error in group_by(., TRACT): could not find function "group_by"
~~~
{:.text-document title="{{ site.handouts[0] }}"}

===

To visualize the average lead concentration from soil samples within each cencus tract, merge the data frame to the `sf` object on the TRACT id.


~~~r
census_lead_tracts <- census_tracts %>%
    inner_join(lead_tracts)
~~~

~~~
Error in inner_join(., lead_tracts): could not find function "inner_join"
~~~

~~~r
plot(census_lead_tracts['avg_ppm'], pal = heat.colors)
~~~

~~~
Error in plot(census_lead_tracts["avg_ppm"], pal = heat.colors): object 'census_lead_tracts' not found
~~~
{:.text-document title="{{ site.handouts[0] }}"}

===

A problem with this approach to aggregation is that it ignores autocorrelation. Points close to eachother tend to have similar values and shouldn't be given equal weight in averages within a polygon.

===

Take a closer look at tract 5800 (in row 52), and notice that several low values are nearly
stacked on top of eachother.


~~~r
m <- import('mapview')
m$mapview(sf$st_geometry(census_tracts)) +
  m$mapview(lead['ppm'])
~~~
{:.input}
~~~
PhantomJS not found. You can install it with webshot::install_phantomjs(). If it is installed, please make sure the phantomjs executable can be found via the PATH variable.
~~~
{:.input}
~~~
Warning in normalizePath(f2): path[1]="./webshot26a45f3c5212.png": No such
file or directory
~~~
{:.input}
~~~
Warning in file(con, "rb"): cannot open file './webshot26a45f3c5212.png':
No such file or directory
~~~
{:.input}
~~~
Error in file(con, "rb"): cannot open the connection
~~~
{:.output}

[geometry-predicates]: https://en.wikipedia.org/wiki/DE-9IM
[CC BY]: https://creativecommons.org/licenses/by-sa/3.0/
