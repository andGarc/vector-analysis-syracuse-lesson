---
title: "Untitled"
output: html_document
---



## R Markdown

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:

You can also embed plots, for example:


~~~r
library(gstat) #spatial interpolation and kriging methods
library(sp) # spatial/geographfic objects and functions
library(rgdal) #GDAL/OGR binding for R with functionalities
~~~
{:.input}
~~~
rgdal: version: 1.2-12, (SVN revision 681)
 Geospatial Data Abstraction Library extensions to R successfully loaded
 Loaded GDAL runtime: GDAL 2.1.3, released 2017/20/01
 Path to GDAL shared files: /usr/share/gdal/2.1
 Loaded PROJ.4 runtime: Rel. 4.9.2, 08 September 2015, [PJ_VERSION: 492]
 Path to PROJ.4 shared files: (autodetected)
 Linking to sp version: 1.2-5 
~~~
{:.input}
~~~r
library(spdep) #spatial analyses operations, functions etc.
~~~
{:.input}
~~~
Loading required package: Matrix
~~~
{:.input}
~~~r
library(gtools) # contains mixsort and other useful functions
library(maptools) # tools to manipulate spatial data
~~~
{:.input}
~~~
Checking rgeos availability: TRUE
~~~
{:.input}
~~~r
library(parallel) # parallel computation, part of base package no
library(rasterVis) # raster visualization operations
~~~
{:.input}
~~~
Loading required package: raster
~~~
{:.input}
~~~
Loading required package: lattice
~~~
{:.input}
~~~
Loading required package: latticeExtra
~~~
{:.input}
~~~
Loading required package: RColorBrewer
~~~
{:.input}
~~~r
library(raster) # raster functionalities
library(forecast) #ARIMA forecasting
library(xts) #extension for time series object and analyses
~~~
{:.input}
~~~
Loading required package: zoo
~~~
{:.input}
~~~

Attaching package: 'zoo'
~~~
{:.input}
~~~
The following objects are masked from 'package:base':

    as.Date, as.Date.numeric
~~~
{:.input}
~~~r
library(zoo) # time series object and analysis
library(lubridate) # dates functionality
~~~
{:.input}
~~~

Attaching package: 'lubridate'
~~~
{:.input}
~~~
The following object is masked from 'package:base':

    date
~~~
{:.input}
~~~r
library(colorRamps) #contains matlab.like color palette
library(rgeos) #contains topological operations
~~~
{:.input}
~~~
rgeos version: 0.3-25, (SVN revision 555)
 GEOS runtime version: 3.5.1-CAPI-1.9.1 r4246 
 Linking to sp version: 1.2-5 
 Polygon checking: TRUE 
~~~
{:.input}
~~~r
library(sphet) #contains spreg, spatial regression modeling
~~~
{:.input}
~~~

Attaching package: 'sphet'
~~~
{:.input}
~~~
The following object is masked from 'package:raster':

    distance
~~~
{:.input}
~~~r
library(BMS) #contains hex2bin and bin2hex, Bayesian methods
library(bitops) # function for bitwise operations
library(foreign) # import datasets from SAS, spss, stata and other sources
library(gdata) #read xls, dbf etc., not recently updated but useful
~~~
{:.input}
~~~
gdata: read.xls support for 'XLS' (Excel 97-2004) files ENABLED.
~~~
{:.input}
~~~

~~~
{:.input}
~~~
gdata: read.xls support for 'XLSX' (Excel 2007+) files ENABLED.
~~~
{:.input}
~~~

Attaching package: 'gdata'
~~~
{:.input}
~~~
The following objects are masked from 'package:xts':

    first, last
~~~
{:.input}
~~~
The following objects are masked from 'package:raster':

    resample, trim
~~~
{:.input}
~~~
The following object is masked from 'package:stats':

    nobs
~~~
{:.input}
~~~
The following object is masked from 'package:utils':

    object.size
~~~
{:.input}
~~~
The following object is masked from 'package:base':

    startsWith
~~~
{:.input}
~~~r
library(classInt) #methods to generate class limits
library(plyr) #data wrangling: various operations for splitting, combining data
~~~
{:.input}
~~~

Attaching package: 'plyr'
~~~
{:.input}
~~~
The following object is masked from 'package:lubridate':

    here
~~~
{:.input}
~~~r
library(readxl) #functionalities to read in excel type data
library(sf)
~~~
{:.input}
~~~
Linking to GEOS 3.5.0, GDAL 2.1.3, proj.4 4.9.2
~~~
{:.input}
~~~r
#library(spacetime)

###### Functions used in this script

function_preprocessing_and_analyses <- "fire_alaska_analyses_preprocessing_functions_03102017.R" #PARAM 1
script_path <- "/nfs/bparmentier-data/Data/workshop_spatial/sesync2018_workshop/R_scripts"
source(file.path(script_path,function_preprocessing_and_analyses)) #source all functions used in this script 1.
#source(file.path(script_path,function_analyses)) #source all functions used in this script 1.

#####  Parameters and argument set up ###########

in_dir_var <- "/nfs/bparmentier-data/Data/workshop_spatial/sesync2018_workshop/Exercise_1/data"
out_dir <- "/nfs/bparmentier-data/Data/workshop_spatial/sesync2018_workshop/Exercise_1/outputs"

file_format <- ".tif" #PARAM5
NA_value <- -9999 #PARAM6
NA_flag_val <- NA_value #PARAM7
out_suffix <-"exercise1_10042017" #output suffix for the files and ouptu folder #PARAM 8
create_out_dir_param=TRUE #PARAM9

################# START SCRIPT ###############################

## First create an output directory

if(is.null(out_dir)){
  out_dir <- dirname(in_dir) #output will be created in the input dir
}

out_suffix_s <- out_suffix #can modify name of output suffix
if(create_out_dir_param==TRUE){
  out_dir <- create_dir_fun(out_dir,out_suffix_s)
  setwd(out_dir)
}else{
  setwd(out_dir) #use previoulsy defined directory
}

### PART I: EXPLORE DATA: READ AND DISPLAY #######

ct_2000_fname <- "ct_00.shp" # CT_00: Cencus Tracts 2000
bg_2000_fname <- "bg_00.shp" # BG_00: Census Blockgroups 2000
bk_2000_fname <- "bk_00.shp" # BK_00: Census Blocks 2000

census_table_fname <- "census.csv" #contains data from census to be linked
soil_PB_table_fname <- "Soil_PB.csv" #same as census table

metals_table_fname <- "SYR_metals.xlsx" #contains metals data to be linked

ct_2000_sp <- readOGR(dsn=in_dir_var,sub(".shp","",basename(ct_2000_fname))) #read in shapefile
~~~
{:.input}
~~~
OGR data source with driver: ESRI Shapefile 
Source: "/nfs/bparmentier-data/Data/workshop_spatial/sesync2018_workshop/Exercise_1/data", layer: "ct_00"
with 57 features
It has 7 fields
~~~
{:.input}
~~~r
bg_2000_sp <- readOGR(dsn=in_dir_var,sub(".shp","",basename(bg_2000_fname)))
~~~
{:.input}
~~~
OGR data source with driver: ESRI Shapefile 
Source: "/nfs/bparmentier-data/Data/workshop_spatial/sesync2018_workshop/Exercise_1/data", layer: "bg_00"
with 147 features
It has 3 fields
~~~
{:.input}
~~~r
bk_2000_sp <- readOGR(dsn=in_dir_var,sub(".shp","",basename(bk_2000_fname)))
~~~
{:.input}
~~~
OGR data source with driver: ESRI Shapefile 
Source: "/nfs/bparmentier-data/Data/workshop_spatial/sesync2018_workshop/Exercise_1/data", layer: "bk_00"
with 2025 features
It has 7 fields
Integer64 fields read as strings:  ID 
~~~
{:.input}
~~~r
census_syr_df <- read.table(file.path(in_dir_var,census_table_fname),sep=",",header=T) #read in textfile
metals_df <-read_excel( file.path(in_dir_var,metals_table_fname),1) #use function from readxl

#Soil lead samples: UTM z18 coordinates
soil_PB_df <- read.table(file.path(in_dir_var,soil_PB_table_fname),sep=",",header=T) #point locations

dim(census_syr_df) #47 spatial entities
~~~
{:.input}
~~~
[1] 147  41
~~~
{:.input}
~~~r
dim(ct_2000_sp) #47 spatial entities
~~~
{:.input}
~~~
[1] 57  7
~~~
{:.input}
~~~r
dim(metals_df) #47 entities
~~~
{:.input}
~~~
[1] 57 19
~~~
{:.input}
~~~r
dim(bg_2000_sp) #147 spatial entities
~~~
{:.input}
~~~
[1] 147   3
~~~
{:.input}
~~~r
###PRODUCE MAPS OF 2000 Population #########

#First need to link it.

names(bg_2000_sp) #missing census data
~~~
{:.input}
~~~
[1] "BKG_KEY"    "Shape_Leng" "Shape_Area"
~~~
{:.input}
~~~r
names(census_syr_df)
~~~
{:.input}
~~~
 [1] "AREA"       "BKG_KEY"    "POP2000"    "POP00_SQMI" "WHITE"     
 [6] "BLACK"      "AMERI_ES"   "ASIAN"      "HAWN_PI"    "OTHER"     
[11] "MULT_RACE"  "HISPANIC"   "MALES"      "FEMALES"    "AGE_UNDER5"
[16] "AGE_5_17"   "AGE_18_21"  "AGE_22_29"  "AGE_30_39"  "AGE_40_49" 
[21] "AGE_50_64"  "AGE_65_UP"  "MED_AGE"    "MED_AGE_M"  "MED_AGE_F" 
[26] "HOUSEHOLDS" "AVE_HH_SZ"  "HSEHLD_1_M" "HSEHLD_1_F" "MARHH_CHD" 
[31] "MARHH_NO_C" "MHH_CHILD"  "FHH_CHILD"  "FAMILIES"   "AVE_FAM_SZ"
[36] "HSE_UNITS"  "VACANT"     "OWNER_OCC"  "RENTER_OCC" "perc_hispa"
[41] "TRACT"     
~~~
{:.input}
~~~r
#key is "TRACT" but with a different format.
#First fix the format
head(bg_2000_sp)
~~~
{:.input}
~~~
       BKG_KEY Shape_Leng Shape_Area
0 360670001001  13520.233  6135183.6
1 360670003002   2547.130   301840.0
2 360670003001   2678.046   250998.4
3 360670002001   3391.920   656275.6
4 360670004004   2224.179   301085.7
5 360670004001   3263.257   606494.9
~~~
{:.input}
~~~r
head(census_syr_df$BKG_KEY)
~~~
{:.input}
~~~
[1] 3.6067e+11 3.6067e+11 3.6067e+11 3.6067e+11 3.6067e+11 3.6067e+11
~~~
{:.input}
~~~r
#as.numeric(as.character(ct_2000_sp$TRACT))
ct_2000_sp$TRACT <- as.numeric(as.character(ct_2000_sp$TRACT)) 

## Join based on common key id
bg_2000_sp <- merge(bg_2000_sp,census_syr_df,by="BKG_KEY") #Join 
#Plot the spatial object
spplot(bg_2000_sp,"POP2000",main="POP2000") #quick visualization of population 
~~~

![plot of chunk pressure]({{ site.baseurl }}/images/pressure-1.png)

~~~r
##Aggregate data from block group to census

### Summarize by census track
census_2000_sp <- aggregate(bg_2000_sp , by="TRACT",FUN=sum)

### Check if the new geometry of entities is the same as census
plot(census_2000_sp)
plot(ct_2000_sp,border="red",add=T)
~~~

![plot of chunk pressure]({{ site.baseurl }}/images/pressure-2.png)

~~~r
nrow(census_2000_sp)==nrow(ct_2000_sp)
~~~
{:.input}
~~~
[1] TRUE
~~~
{:.input}
~~~r
df_summary_by_census <- aggregate(. ~ TRACT, bg_2000_sp , FUN=sum) #aggregate all variables from the data.frame

##Join by key table id:
dim(ct_2000_sp)
~~~
{:.input}
~~~
[1] 57  7
~~~
{:.input}
~~~r
ct_2000_sp <- merge(ct_2000_sp,df_summary_by_census,by="TRACT")
dim(ct_2000_sp)
~~~
{:.input}
~~~
[1] 57 49
~~~
{:.input}
~~~r
#save as sp and text table
#write.table(file.path(out_dir,)

### Do another map with different class intervals: 

title_str <- "Population by census tract in 2000"
range(ct_2000_sp$POP2000)
~~~
{:.input}
~~~
[1]  393 8040
~~~
{:.input}
~~~r
col_palette <- matlab.like(256)

## 9 classes with fixed and constant break
break_seq <- seq(0,9000,1000)
breaks.qt <- classIntervals(ct_2000_sp$POP2000, n=length(break_seq), 
                            style="fixed", fixedBreaks=break_seq, intervalClosure='right')

## generate plot using sp function:
p_plot_pop2000_ct <- spplot(ct_2000_sp,
                            "POP2000",
                            col="transparent", #transprent color boundaries for polygons
                            col.regions = col_palette ,
                            main=title_str,
                            at = breaks.qt$brks)
print(p_plot_pop2000_ct)
~~~

![plot of chunk pressure]({{ site.baseurl }}/images/pressure-3.png)

~~~r
### Another map with different class intervals

breaks.qt <- classIntervals(ct_2000_sp$POP2000, n = 6, style = "quantile", intervalClosure = "right")

p_plot_pop2000_ct <- spplot(ct_2000_sp,
                            "POP2000",
                            col="transparent", #transprent color boundaries for polygons
                            col.regions = col_palette,
                            main=title_str,
                            at = breaks.qt$brks)
print(p_plot_pop2000_ct)
~~~

![plot of chunk pressure]({{ site.baseurl }}/images/pressure-4.png)

~~~r
####### PART II: SPATIAL QUERY #############

## Join metals to census track 
## Join lead (pb) measurements to census tracks

#metals_df <- read.xls(file.path(in_dir_var,metals_table_fname),sep=",",header=T)
metals_df <-read_excel( file.path(in_dir_var,metals_table_fname),1) #use function from readxl

#View(soil_PB_df)
head(metals_df)
~~~
{:.input}
~~~
# A tibble: 6 x 19
     ID    NI     MU     SU      MV     SV    MZR    SZR     MFE     SFE
  <dbl> <dbl>  <dbl>  <dbl>   <dbl>  <dbl>  <dbl>  <dbl>   <dbl>   <dbl>
1   100    74 404931 555.51 4768399 712.89 278.57 150.66 18522.1 6503.53
2   300    25 406489 228.74 4770396 144.76 341.52 123.57 20113.5 3320.31
3   200    75 405673 280.82 4769746 384.56 368.73 130.00 20193.9 4562.84
4   400    69 407159 372.00 4769946 268.51 371.41 124.30 18525.7 3208.94
5  1000    66 409736 373.11 4769459 175.45 420.99 120.90 18782.7 2054.09
6   600    29 406114 211.00 4769221 328.43 333.28 130.04 17049.9 4181.33
# ... with 9 more variables: MSR <dbl>, SSR <dbl>, MRB <dbl>, SRB <dbl>,
#   MZN <dbl>, SZN <dbl>, MPB <dbl>, SPB <dbl>, Tspbr <dbl>
~~~
{:.input}
~~~r
##This suggests matching to the following spatial entities
nrow(metals_df)==nrow(ct_2000_sp)
~~~
{:.input}
~~~
[1] TRUE
~~~
{:.input}
~~~r
#nrow(soil_PB_df)==nrow(bg_2000_sp)

#dim(bg_2000_sp)
metals_df$TRACT <- metals_df$ID
census_metals_sp <- merge(ct_2000_sp,metals_df,by="TRACT")

########processing lead data
### Now let's plot lead data 
#Soil lead samples: UTM z18 coordinates
soil_PB_df <- read.table(file.path(in_dir_var,soil_PB_table_fname),sep=",",header=T) #point locations

proj4string(census_metals_sp) #
~~~
{:.input}
~~~
[1] "+proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0"
~~~
{:.input}
~~~r
names(soil_PB_df)
~~~
{:.input}
~~~
[1] "X408164.2892" "X4762321.061" "X0"           "X3.890648"   
~~~
{:.input}
~~~r
names(soil_PB_df) <- c("x","y","ID","ppm") 
soil_PB_sp <- soil_PB_df
class(soil_PB_df)
~~~
{:.input}
~~~
[1] "data.frame"
~~~
{:.input}
~~~r
coordinates(soil_PB_sp) <- soil_PB_sp[,c("x","y")]
class(soil_PB_sp)
~~~
{:.input}
~~~
[1] "SpatialPointsDataFrame"
attr(,"package")
[1] "sp"
~~~
{:.input}
~~~r
proj4string(soil_PB_sp) <- proj4string(census_metals_sp)
dim(soil_PB_sp)
~~~
{:.input}
~~~
[1] 3148    4
~~~
{:.input}
~~~r
soil_PB_sp <- soil_PB_sp[,c("ID","ppm","x","y")]
#View(soil_PB_sp)
head(soil_PB_sp)
~~~
{:.input}
~~~
  ID      ppm        x       y
1  1 4.899391 405914.9 4767394
2  2 4.434912 405724.0 4767706
3  3 5.285548 406702.8 4769201
4  4 5.295919 405392.3 4765598
5  5 4.681277 405644.1 4762037
6  6 3.364148 409183.1 4763057
~~~
{:.input}
~~~r
plot(census_metals_sp)
plot(soil_PB_sp,add=T)
~~~

![plot of chunk pressure]({{ site.baseurl }}/images/pressure-5.png)

~~~r
###### Spatial query: associate points of pb measurements to each census tract
### Get the ID and 

soil_tract_id_df <- over(soil_PB_sp,census_2000_sp,fn=mean)
soil_PB_sp <- raster::intersect(soil_PB_sp,census_2000_sp)
head(soil_PB_sp$ID)==head(soil_PB_sp$ID)
~~~
{:.input}
~~~
[1] TRUE TRUE TRUE TRUE TRUE TRUE
~~~
{:.input}
~~~r
names(soil_PB_sp)
~~~
{:.input}
~~~
[1] "ID"  "ppm" "x"   "y"   "d"  
~~~
{:.input}
~~~r
#soil_PB_sp <- rename(soil_PB_sp, c("d"="TRACT")) #from package plyr
soil_PB_sp$TRACT <- soil_PB_sp$d

census_pb_avg <- aggregate(ppm ~ TRACT,(soil_PB_sp),FUN=mean)
#census_pb_avg <- rename(census_pb_avg,c("ppm"="pb_ppm"))
census_pb_avg$pb_ppm <- census_pb_avg$ppm

##Now join
census_metals_pb_sp <- merge(census_metals_sp,census_pb_avg,by="TRACT")
### write out final table and shapefile

outfile<-paste("census_metals_pb_sp","_",
               out_suffix,sep="")
writeOGR(census_metals_pb_sp,dsn= out_dir,layer= outfile, driver="ESRI Shapefile",overwrite_layer=TRUE)
~~~
{:.input}
~~~
Warning in writeOGR(census_metals_pb_sp, dsn = out_dir, layer = outfile, :
Field names abbreviated for ESRI Shapefile driver
~~~
{:.input}
~~~r
outfile_df_name <- file.path(out_dir,paste0(outfile,".txt"))
write.table(as.data.frame(census_metals_pb_sp),file=outfile_df_name,sep=",")

########### PART III: RASTER FROM KRIGING                 ######################
#Generating raster lead surface from point and comparing aggregation ###################

#Now generate a raster image to create grid of cell for kriging
extent_reg <- extent(census_metals_pb_sp)
plot(extent_reg)
plot(census_metals_pb_sp,add=T)
~~~

![plot of chunk pressure]({{ site.baseurl }}/images/pressure-6.png)

~~~r
extent_matrix <- as.matrix(extent_reg)
extent_matrix
~~~
{:.input}
~~~
        min       max
x  401938.3  412486.4
y 4759733.5 4771049.2
~~~
{:.input}
~~~r
x_length_reg <- extent_matrix[1,2] - extent_matrix[1,1] 
y_length_reg <- extent_matrix[2,2] - extent_matrix[2,1] 

print(c(x_length_reg,y_length_reg))
~~~
{:.input}
~~~
[1] 10548.06 11315.71
~~~
{:.input}
~~~r
## Based on the size of the extent, let's set the size for our new raster layer: 
#we don't want too fine as resolution: let's do 100m, it will keep the grid small

res_val <- 100
r = raster(ext=extent_reg, res=res_val)
dim(r)
~~~
{:.input}
~~~
[1] 113 105   1
~~~
{:.input}
~~~r
values(r) <- 1:ncell(r) # Assign values to raster, ID for each pixel
#assign projection system
projection(r) <- proj4string(census_metals_pb_sp)

######Visualize the data first

plot(r)
#generate grid from raster as poly for visualization
r_poly<- rasterToPolygons(r)
plot(extent_reg,add=T,col="red")
plot(census_metals_pb_sp,border="blue",add=T)
### Let's show the grid first
plot(r_poly,add=T)
~~~

![plot of chunk pressure]({{ site.baseurl }}/images/pressure-7.png)

~~~r
## Transform the raster layer into a sp Grid object for kriging
r_sgdf <- as(r, 'SpatialGridDataFrame')
class(r_sgdf)
~~~
{:.input}
~~~
[1] "SpatialGridDataFrame"
attr(,"package")
[1] "sp"
~~~
{:.input}
~~~r
## Generate and plot a sample variogram from lead data
v_ppm <- variogram(ppm ~ 1,soil_PB_sp)
plot(v_ppm)
~~~

![plot of chunk pressure]({{ site.baseurl }}/images/pressure-8.png)

~~~r
## Fit a variogram model from lead data

v_ppm_fit <- fit.variogram(v_ppm,model=vgm(1,"Sph",900,1))
plot(v_ppm,v_ppm_fit)
~~~

![plot of chunk pressure]({{ site.baseurl }}/images/pressure-9.png)

~~~r
##Generate a kriging surface using data and modeled variogram: this may take more than 3 minutes
ppm_lead_spg <- krige(ppm ~ 1, soil_PB_sp, r_sgdf, model=v_ppm_fit)
~~~
{:.input}
~~~
[using ordinary kriging]
~~~
{:.input}
~~~r
class(ppm_lead_spg)
~~~
{:.input}
~~~
[1] "SpatialGridDataFrame"
attr(,"package")
[1] "sp"
~~~
{:.input}
~~~r
r_lead <- raster(ppm_lead_spg)
rm(ppm_lead_spg) #remove grid object from memory
r_lead #examine new layer
~~~
{:.input}
~~~
class       : RasterLayer 
dimensions  : 113, 105, 11865  (nrow, ncol, ncell)
resolution  : 100, 100  (x, y)
extent      : 401938.3, 412438.3, 4759749, 4771049  (xmin, xmax, ymin, ymax)
coord. ref. : +proj=utm +zone=18 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 
data source : in memory
names       : var1.pred 
values      : 3.020325, 6.374936  (min, max)
~~~
{:.input}
~~~r
col_palette <- matlab.like(256)
plot(r_lead,col=col_palette)
plot(census_metals_pb_sp,border="blue",add=T)
~~~

![plot of chunk pressure]({{ site.baseurl }}/images/pressure-10.png)

~~~r
## Save raster layers produced from kriging
raster_name <- file.path(out_dir,paste0("r_lead",out_suffix,file_format))
writeRaster(r_lead,filename = raster_name,overwrite=T)

#### Comparison of aggregations ###
## Compare values from averages from kriging surface and averages from block groups

census_lead_sp <- extract(r_lead,census_metals_pb_sp,sp=T,fun=mean) #extract average values by census track
spplot(census_metals_pb_sp,"pb_ppm",col.regions=col_palette,main="Averaged from blockgroups") #
~~~

![plot of chunk pressure]({{ site.baseurl }}/images/pressure-11.png)

~~~r
spplot(census_lead_sp,"var1.pred",col.regions=col_palette,main="Averaged from kriging ") 
~~~

![plot of chunk pressure]({{ site.baseurl }}/images/pressure-12.png)

~~~r
census_lead_sp$diff <- census_metals_pb_sp$pb_ppm - census_lead_sp$var1.pred #comparing the averages
hist(census_lead_sp$diff)
~~~

![plot of chunk pressure]({{ site.baseurl }}/images/pressure-13.png)

~~~r
spplot(census_lead_sp,"diff",col.regions=col_palette,main="Difference in averages")
~~~

![plot of chunk pressure]({{ site.baseurl }}/images/pressure-14.png)

~~~r
##### PART IV: Spatial autocrrelation and regression #############
## Examine spatial autocorrelation
#Examine the relationship between metals, Pb and vulnerable populations in Syracuse

list_nb <- poly2nb(census_lead_sp) #generate neighbours based on polygons
summary(list_nb)
~~~
{:.input}
~~~
Neighbour list object:
Number of regions: 57 
Number of nonzero links: 306 
Percentage nonzero weights: 9.418283 
Average number of links: 5.368421 
Link number distribution:

 1  2  3  4  5  6  7  8  9 
 1  2  5  7 14 16  5  6  1 
1 least connected region:
50 with 1 link
1 most connected region:
28 with 9 links
~~~
{:.input}
~~~r
plot(census_lead_sp,border="blue")
plot.nb(list_nb,coordinates(census_lead_sp),add=T)
~~~

![plot of chunk pressure]({{ site.baseurl }}/images/pressure-15.png)

~~~r
#generate weights
#nb2listw
list_w <- nb2listw(list_nb, glist=NULL, style="W", zero.policy=NULL) #use row standardized
can.be.simmed(list_w)
~~~
{:.input}
~~~
[1] TRUE
~~~
{:.input}
~~~r
summary(list_w)
~~~
{:.input}
~~~
Characteristics of weights list object:
Neighbour list object:
Number of regions: 57 
Number of nonzero links: 306 
Percentage nonzero weights: 9.418283 
Average number of links: 5.368421 
Link number distribution:

 1  2  3  4  5  6  7  8  9 
 1  2  5  7 14 16  5  6  1 
1 least connected region:
50 with 1 link
1 most connected region:
28 with 9 links

Weights style: W 
Weights constants summary:
   n   nn S0       S1       S2
W 57 3249 57 23.12098 235.7118
~~~
{:.input}
~~~r
## Compute Moran's I and display it
moran(census_lead_sp$pb_ppm,list_w,n=nrow(census_lead_sp), Szero(list_w))
~~~
{:.input}
~~~
$I
[1] 0.4276212

$K
[1] 2.601996
~~~
{:.input}
~~~r
moran.plot(census_lead_sp$pb_ppm, list_w,
           labels=as.character(census_lead_sp$TRACT), pch=19)
~~~

![plot of chunk pressure]({{ site.baseurl }}/images/pressure-16.png)

~~~r
##### Now do a spatial regression

## Is there are relationship between minorities and high level of lead?
# As a way to explore use, perc_hispa as explanatory variable

#linear model without taking into account spatial autocorrelation
mod_lm <- lm(pb_ppm ~ perc_hispa, data=census_lead_sp)
#autoregressive model
mod_lag <- lagsarlm(pb_ppm ~ perc_hispa, data=census_lead_sp, list_w, tol.solve=1.0e-30)

### Checking for autocorrelation in residuals
moran.test(mod_lm$residuals,list_w)
~~~
{:.input}
~~~

	Moran I test under randomisation

data:  mod_lm$residuals  
weights: list_w  

Moran I statistic standard deviate = 5.4602, p-value = 2.378e-08
alternative hypothesis: greater
sample estimates:
Moran I statistic       Expectation          Variance 
      0.422209735      -0.017857143       0.006495572 
~~~
{:.input}
~~~r
moran.test(mod_lag$residuals,list_w) #Note that Moran'sI is close to zero in the lag model
~~~
{:.input}
~~~

	Moran I test under randomisation

data:  mod_lag$residuals  
weights: list_w  

Moran I statistic standard deviate = 1.1851, p-value = 0.118
alternative hypothesis: greater
sample estimates:
Moran I statistic       Expectation          Variance 
      0.077021478      -0.017857143       0.006409024 
~~~
{:.input}
~~~r
#### Compare Moran's I from raster to Moran's I from polygon sp
# Rook's case
f <- matrix(c(0,1,0,1,0,1,0,1,0), nrow=3)
Moran(r_lead, f) 
~~~
{:.input}
~~~
[1] 0.9885931
~~~
{:.input}
~~~r
r_moran <- MoranLocal(r_lead)
plot(r_moran) # hotspots?
~~~

![plot of chunk pressure]({{ site.baseurl }}/images/pressure-17.png)

~~~r
################### END OF SCRIPT ##########################
~~~
{:.output}

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.
