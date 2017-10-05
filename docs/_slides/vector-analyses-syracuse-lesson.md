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
rgdal: version: 1.2-7, (SVN revision 660)
 Geospatial Data Abstraction Library extensions to R successfully loaded
 Loaded GDAL runtime: GDAL 1.11.3, released 2015/09/16
 Path to GDAL shared files: /usr/share/gdal/1.11
 Loaded PROJ.4 runtime: Rel. 4.9.2, 08 September 2015, [PJ_VERSION: 492]
 Path to PROJ.4 shared files: (autodetected)
 Linking to sp version: 1.2-4 
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
~~~
{:.input}
~~~
Error in library(colorRamps): there is no package called 'colorRamps'
~~~
{:.input}
~~~r
library(rgeos) #contains topological operations
~~~
{:.input}
~~~
rgeos version: 0.3-23, (SVN revision 546)
 GEOS runtime version: 3.5.0-CAPI-1.9.0 r4084 
 Linking to sp version: 1.2-4 
 Polygon checking: TRUE 
~~~
{:.input}
~~~r
library(sphet) #contains spreg, spatial regression modeling
~~~
{:.input}
~~~
Error in library(sphet): there is no package called 'sphet'
~~~
{:.input}
~~~r
library(BMS) #contains hex2bin and bin2hex, Bayesian methods
~~~
{:.input}
~~~
Error in library(BMS): there is no package called 'BMS'
~~~
{:.input}
~~~r
library(bitops) # function for bitwise operations
~~~
{:.input}
~~~
Error in library(bitops): there is no package called 'bitops'
~~~
{:.input}
~~~r
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
Error in library(sf): there is no package called 'sf'
~~~
{:.input}
~~~r
#library(spacetime)

###### Functions used in this script

function_preprocessing_and_analyses <- "fire_alaska_analyses_preprocessing_functions_03102017.R" #PARAM 1
script_path <- "/nfs/bparmentier-data/Data/workshop_spatial/sesync2018_workshop/R_scripts"
source(file.path(script_path,function_preprocessing_and_analyses)) #source all functions used in this script 1.
~~~
{:.input}
~~~
Warning in file(filename, "r", encoding = encoding): cannot open file '/
nfs/bparmentier-data/Data/workshop_spatial/sesync2018_workshop/R_scripts/
fire_alaska_analyses_preprocessing_functions_03102017.R': No such file or
directory
~~~
{:.input}
~~~
Error in file(filename, "r", encoding = encoding): cannot open the connection
~~~
{:.input}
~~~r
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
~~~
{:.input}
~~~
Error in create_dir_fun(out_dir, out_suffix_s): could not find function "create_dir_fun"
~~~
{:.input}
~~~r
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
Error in ogrInfo(dsn = dsn, layer = layer, encoding = encoding, use_iconv = use_iconv, : Cannot open file
~~~
{:.input}
~~~r
bg_2000_sp <- readOGR(dsn=in_dir_var,sub(".shp","",basename(bg_2000_fname)))
~~~
{:.input}
~~~
Error in ogrInfo(dsn = dsn, layer = layer, encoding = encoding, use_iconv = use_iconv, : Cannot open file
~~~
{:.input}
~~~r
bk_2000_sp <- readOGR(dsn=in_dir_var,sub(".shp","",basename(bk_2000_fname)))
~~~
{:.input}
~~~
Error in ogrInfo(dsn = dsn, layer = layer, encoding = encoding, use_iconv = use_iconv, : Cannot open file
~~~
{:.input}
~~~r
census_syr_df <- read.table(file.path(in_dir_var,census_table_fname),sep=",",header=T) #read in textfile
~~~
{:.input}
~~~
Warning in file(file, "rt"): cannot open file '/nfs/bparmentier-data/Data/
workshop_spatial/sesync2018_workshop/Exercise_1/data/census.csv': No such
file or directory
~~~
{:.input}
~~~
Error in file(file, "rt"): cannot open the connection
~~~
{:.input}
~~~r
metals_df <-read_excel( file.path(in_dir_var,metals_table_fname),1) #use function from readxl
~~~
{:.input}
~~~
Error in read_fun(path = path, sheet = sheet, limits = limits, shim = shim, : zip file '/nfs/bparmentier-data/Data/workshop_spatial/sesync2018_workshop/Exercise_1/data/SYR_metals.xlsx' cannot be opened
~~~
{:.input}
~~~r
#Soil lead samples: UTM z18 coordinates
soil_PB_df <- read.table(file.path(in_dir_var,soil_PB_table_fname),sep=",",header=T) #point locations
~~~
{:.input}
~~~
Warning in file(file, "rt"): cannot open file '/nfs/bparmentier-data/Data/
workshop_spatial/sesync2018_workshop/Exercise_1/data/Soil_PB.csv': No such
file or directory
~~~
{:.input}
~~~
Error in file(file, "rt"): cannot open the connection
~~~
{:.input}
~~~r
dim(census_syr_df) #47 spatial entities
~~~
{:.input}
~~~
Error in eval(expr, envir, enclos): object 'census_syr_df' not found
~~~
{:.input}
~~~r
dim(ct_2000_sp) #47 spatial entities
~~~
{:.input}
~~~
Error in eval(expr, envir, enclos): object 'ct_2000_sp' not found
~~~
{:.input}
~~~r
dim(metals_df) #47 entities
~~~
{:.input}
~~~
Error in eval(expr, envir, enclos): object 'metals_df' not found
~~~
{:.input}
~~~r
dim(bg_2000_sp) #147 spatial entities
~~~
{:.input}
~~~
Error in eval(expr, envir, enclos): object 'bg_2000_sp' not found
~~~
{:.input}
~~~r
###PRODUCE MAPS OF 2000 Population #########

#First need to link it.

names(bg_2000_sp) #missing census data
~~~
{:.input}
~~~
Error in eval(expr, envir, enclos): object 'bg_2000_sp' not found
~~~
{:.input}
~~~r
names(census_syr_df)
~~~
{:.input}
~~~
Error in eval(expr, envir, enclos): object 'census_syr_df' not found
~~~
{:.input}
~~~r
#key is "TRACT" but with a different format.
#First fix the format
head(bg_2000_sp)
~~~
{:.input}
~~~
Error in head(bg_2000_sp): object 'bg_2000_sp' not found
~~~
{:.input}
~~~r
head(census_syr_df$BKG_KEY)
~~~
{:.input}
~~~
Error in head(census_syr_df$BKG_KEY): object 'census_syr_df' not found
~~~
{:.input}
~~~r
#as.numeric(as.character(ct_2000_sp$TRACT))
ct_2000_sp$TRACT <- as.numeric(as.character(ct_2000_sp$TRACT)) 
~~~
{:.input}
~~~
Error in eval(expr, envir, enclos): object 'ct_2000_sp' not found
~~~
{:.input}
~~~r
## Join based on common key id
bg_2000_sp <- merge(bg_2000_sp,census_syr_df,by="BKG_KEY") #Join 
~~~
{:.input}
~~~
Error in merge(bg_2000_sp, census_syr_df, by = "BKG_KEY"): object 'bg_2000_sp' not found
~~~
{:.input}
~~~r
#Plot the spatial object
spplot(bg_2000_sp,"POP2000",main="POP2000") #quick visualization of population 
~~~
{:.input}
~~~
Error in spplot(bg_2000_sp, "POP2000", main = "POP2000"): object 'bg_2000_sp' not found
~~~
{:.input}
~~~r
##Aggregate data from block group to census

### Summarize by census track
census_2000_sp <- aggregate(bg_2000_sp , by="TRACT",FUN=sum)
~~~
{:.input}
~~~
Error in aggregate(bg_2000_sp, by = "TRACT", FUN = sum): object 'bg_2000_sp' not found
~~~
{:.input}
~~~r
### Check if the new geometry of entities is the same as census
plot(census_2000_sp)
~~~
{:.input}
~~~
Error in plot(census_2000_sp): object 'census_2000_sp' not found
~~~
{:.input}
~~~r
plot(ct_2000_sp,border="red",add=T)
~~~
{:.input}
~~~
Error in plot(ct_2000_sp, border = "red", add = T): object 'ct_2000_sp' not found
~~~
{:.input}
~~~r
nrow(census_2000_sp)==nrow(ct_2000_sp)
~~~
{:.input}
~~~
Error in nrow(census_2000_sp): object 'census_2000_sp' not found
~~~
{:.input}
~~~r
df_summary_by_census <- aggregate(. ~ TRACT, bg_2000_sp , FUN=sum) #aggregate all variables from the data.frame
~~~
{:.input}
~~~
Error in eval(m$data, parent.frame()): object 'bg_2000_sp' not found
~~~
{:.input}
~~~r
##Join by key table id:
dim(ct_2000_sp)
~~~
{:.input}
~~~
Error in eval(expr, envir, enclos): object 'ct_2000_sp' not found
~~~
{:.input}
~~~r
ct_2000_sp <- merge(ct_2000_sp,df_summary_by_census,by="TRACT")
~~~
{:.input}
~~~
Error in merge(ct_2000_sp, df_summary_by_census, by = "TRACT"): object 'ct_2000_sp' not found
~~~
{:.input}
~~~r
dim(ct_2000_sp)
~~~
{:.input}
~~~
Error in eval(expr, envir, enclos): object 'ct_2000_sp' not found
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
Error in eval(expr, envir, enclos): object 'ct_2000_sp' not found
~~~
{:.input}
~~~r
col_palette <- matlab.like(256)
~~~
{:.input}
~~~
Error in matlab.like(256): could not find function "matlab.like"
~~~
{:.input}
~~~r
## 9 classes with fixed and constant break
break_seq <- seq(0,9000,1000)
breaks.qt <- classIntervals(ct_2000_sp$POP2000, n=length(break_seq), 
                            style="fixed", fixedBreaks=break_seq, intervalClosure='right')
~~~
{:.input}
~~~
Error in is.factor(var): object 'ct_2000_sp' not found
~~~
{:.input}
~~~r
## generate plot using sp function:
p_plot_pop2000_ct <- spplot(ct_2000_sp,
                            "POP2000",
                            col="transparent", #transprent color boundaries for polygons
                            col.regions = col_palette ,
                            main=title_str,
                            at = breaks.qt$brks)
~~~
{:.input}
~~~
Error in spplot(ct_2000_sp, "POP2000", col = "transparent", col.regions = col_palette, : object 'ct_2000_sp' not found
~~~
{:.input}
~~~r
print(p_plot_pop2000_ct)
~~~
{:.input}
~~~
Error in print(p_plot_pop2000_ct): object 'p_plot_pop2000_ct' not found
~~~
{:.input}
~~~r
### Another map with different class intervals

breaks.qt <- classIntervals(ct_2000_sp$POP2000, n = 6, style = "quantile", intervalClosure = "right")
~~~
{:.input}
~~~
Error in is.factor(var): object 'ct_2000_sp' not found
~~~
{:.input}
~~~r
p_plot_pop2000_ct <- spplot(ct_2000_sp,
                            "POP2000",
                            col="transparent", #transprent color boundaries for polygons
                            col.regions = col_palette,
                            main=title_str,
                            at = breaks.qt$brks)
~~~
{:.input}
~~~
Error in spplot(ct_2000_sp, "POP2000", col = "transparent", col.regions = col_palette, : object 'ct_2000_sp' not found
~~~
{:.input}
~~~r
print(p_plot_pop2000_ct)
~~~
{:.input}
~~~
Error in print(p_plot_pop2000_ct): object 'p_plot_pop2000_ct' not found
~~~
{:.input}
~~~r
####### PART II: SPATIAL QUERY #############

## Join metals to census track 
## Join lead (pb) measurements to census tracks

#metals_df <- read.xls(file.path(in_dir_var,metals_table_fname),sep=",",header=T)
metals_df <-read_excel( file.path(in_dir_var,metals_table_fname),1) #use function from readxl
~~~
{:.input}
~~~
Error in read_fun(path = path, sheet = sheet, limits = limits, shim = shim, : zip file '/nfs/bparmentier-data/Data/workshop_spatial/sesync2018_workshop/Exercise_1/data/SYR_metals.xlsx' cannot be opened
~~~
{:.input}
~~~r
#View(soil_PB_df)
head(metals_df)
~~~
{:.input}
~~~
Error in head(metals_df): object 'metals_df' not found
~~~
{:.input}
~~~r
##This suggests matching to the following spatial entities
nrow(metals_df)==nrow(ct_2000_sp)
~~~
{:.input}
~~~
Error in nrow(metals_df): object 'metals_df' not found
~~~
{:.input}
~~~r
#nrow(soil_PB_df)==nrow(bg_2000_sp)

#dim(bg_2000_sp)
metals_df$TRACT <- metals_df$ID
~~~
{:.input}
~~~
Error in eval(expr, envir, enclos): object 'metals_df' not found
~~~
{:.input}
~~~r
census_metals_sp <- merge(ct_2000_sp,metals_df,by="TRACT")
~~~
{:.input}
~~~
Error in merge(ct_2000_sp, metals_df, by = "TRACT"): object 'ct_2000_sp' not found
~~~
{:.input}
~~~r
########processing lead data
### Now let's plot lead data 
#Soil lead samples: UTM z18 coordinates
soil_PB_df <- read.table(file.path(in_dir_var,soil_PB_table_fname),sep=",",header=T) #point locations
~~~
{:.input}
~~~
Warning in file(file, "rt"): cannot open file '/nfs/bparmentier-data/Data/
workshop_spatial/sesync2018_workshop/Exercise_1/data/Soil_PB.csv': No such
file or directory
~~~
{:.input}
~~~
Error in file(file, "rt"): cannot open the connection
~~~
{:.input}
~~~r
proj4string(census_metals_sp) #
~~~
{:.input}
~~~
Error in proj4string(census_metals_sp): object 'census_metals_sp' not found
~~~
{:.input}
~~~r
names(soil_PB_df)
~~~
{:.input}
~~~
Error in eval(expr, envir, enclos): object 'soil_PB_df' not found
~~~
{:.input}
~~~r
names(soil_PB_df) <- c("x","y","ID","ppm") 
~~~
{:.input}
~~~
Error in names(soil_PB_df) <- c("x", "y", "ID", "ppm"): object 'soil_PB_df' not found
~~~
{:.input}
~~~r
soil_PB_sp <- soil_PB_df
~~~
{:.input}
~~~
Error in eval(expr, envir, enclos): object 'soil_PB_df' not found
~~~
{:.input}
~~~r
class(soil_PB_df)
~~~
{:.input}
~~~
Error in eval(expr, envir, enclos): object 'soil_PB_df' not found
~~~
{:.input}
~~~r
coordinates(soil_PB_sp) <- soil_PB_sp[,c("x","y")]
~~~
{:.input}
~~~
Error in eval(expr, envir, enclos): object 'soil_PB_sp' not found
~~~
{:.input}
~~~r
class(soil_PB_sp)
~~~
{:.input}
~~~
Error in eval(expr, envir, enclos): object 'soil_PB_sp' not found
~~~
{:.input}
~~~r
proj4string(soil_PB_sp) <- proj4string(census_metals_sp)
~~~
{:.input}
~~~
Error in proj4string(census_metals_sp): object 'census_metals_sp' not found
~~~
{:.input}
~~~r
dim(soil_PB_sp)
~~~
{:.input}
~~~
Error in eval(expr, envir, enclos): object 'soil_PB_sp' not found
~~~
{:.input}
~~~r
soil_PB_sp <- soil_PB_sp[,c("ID","ppm","x","y")]
~~~
{:.input}
~~~
Error in eval(expr, envir, enclos): object 'soil_PB_sp' not found
~~~
{:.input}
~~~r
#View(soil_PB_sp)
head(soil_PB_sp)
~~~
{:.input}
~~~
Error in head(soil_PB_sp): object 'soil_PB_sp' not found
~~~
{:.input}
~~~r
plot(census_metals_sp)
~~~
{:.input}
~~~
Error in plot(census_metals_sp): object 'census_metals_sp' not found
~~~
{:.input}
~~~r
plot(soil_PB_sp,add=T)
~~~
{:.input}
~~~
Error in plot(soil_PB_sp, add = T): object 'soil_PB_sp' not found
~~~
{:.input}
~~~r
###### Spatial query: associate points of pb measurements to each census tract
### Get the ID and 

soil_tract_id_df <- over(soil_PB_sp,census_2000_sp,fn=mean)
~~~
{:.input}
~~~
Error in over(soil_PB_sp, census_2000_sp, fn = mean): object 'soil_PB_sp' not found
~~~
{:.input}
~~~r
soil_PB_sp <- raster::intersect(soil_PB_sp,census_2000_sp)
~~~
{:.input}
~~~
Error in raster::intersect(soil_PB_sp, census_2000_sp): object 'soil_PB_sp' not found
~~~
{:.input}
~~~r
head(soil_PB_sp$ID)==head(soil_PB_sp$ID)
~~~
{:.input}
~~~
Error in head(soil_PB_sp$ID): object 'soil_PB_sp' not found
~~~
{:.input}
~~~r
names(soil_PB_sp)
~~~
{:.input}
~~~
Error in eval(expr, envir, enclos): object 'soil_PB_sp' not found
~~~
{:.input}
~~~r
#soil_PB_sp <- rename(soil_PB_sp, c("d"="TRACT")) #from package plyr
soil_PB_sp$TRACT <- soil_PB_sp$d
~~~
{:.input}
~~~
Error in eval(expr, envir, enclos): object 'soil_PB_sp' not found
~~~
{:.input}
~~~r
census_pb_avg <- aggregate(ppm ~ TRACT,(soil_PB_sp),FUN=mean)
~~~
{:.input}
~~~
Error in eval(m$data, parent.frame()): object 'soil_PB_sp' not found
~~~
{:.input}
~~~r
#census_pb_avg <- rename(census_pb_avg,c("ppm"="pb_ppm"))
census_pb_avg$pb_ppm <- census_pb_avg$ppm
~~~
{:.input}
~~~
Error in eval(expr, envir, enclos): object 'census_pb_avg' not found
~~~
{:.input}
~~~r
##Now join
census_metals_pb_sp <- merge(census_metals_sp,census_pb_avg,by="TRACT")
~~~
{:.input}
~~~
Error in merge(census_metals_sp, census_pb_avg, by = "TRACT"): object 'census_metals_sp' not found
~~~
{:.input}
~~~r
### write out final table and shapefile

outfile<-paste("census_metals_pb_sp","_",
               out_suffix,sep="")
writeOGR(census_metals_pb_sp,dsn= out_dir,layer= outfile, driver="ESRI Shapefile",overwrite_layer=TRUE)
~~~
{:.input}
~~~
Error in inherits(obj, "Spatial"): object 'census_metals_pb_sp' not found
~~~
{:.input}
~~~r
outfile_df_name <- file.path(out_dir,paste0(outfile,".txt"))
write.table(as.data.frame(census_metals_pb_sp),file=outfile_df_name,sep=",")
~~~
{:.input}
~~~
Error in as.data.frame(census_metals_pb_sp): object 'census_metals_pb_sp' not found
~~~
{:.input}
~~~r
########### PART III: RASTER FROM KRIGING                 ######################
#Generating raster lead surface from point and comparing aggregation ###################

#Now generate a raster image to create grid of cell for kriging
extent_reg <- extent(census_metals_pb_sp)
~~~
{:.input}
~~~
Error in extent(census_metals_pb_sp): object 'census_metals_pb_sp' not found
~~~
{:.input}
~~~r
plot(extent_reg)
~~~
{:.input}
~~~
Error in plot(extent_reg): object 'extent_reg' not found
~~~
{:.input}
~~~r
plot(census_metals_pb_sp,add=T)
~~~
{:.input}
~~~
Error in plot(census_metals_pb_sp, add = T): object 'census_metals_pb_sp' not found
~~~
{:.input}
~~~r
extent_matrix <- as.matrix(extent_reg)
~~~
{:.input}
~~~
Error in as.matrix(extent_reg): object 'extent_reg' not found
~~~
{:.input}
~~~r
extent_matrix
~~~
{:.input}
~~~
Error in eval(expr, envir, enclos): object 'extent_matrix' not found
~~~
{:.input}
~~~r
x_length_reg <- extent_matrix[1,2] - extent_matrix[1,1] 
~~~
{:.input}
~~~
Error in eval(expr, envir, enclos): object 'extent_matrix' not found
~~~
{:.input}
~~~r
y_length_reg <- extent_matrix[2,2] - extent_matrix[2,1] 
~~~
{:.input}
~~~
Error in eval(expr, envir, enclos): object 'extent_matrix' not found
~~~
{:.input}
~~~r
print(c(x_length_reg,y_length_reg))
~~~
{:.input}
~~~
Error in print(c(x_length_reg, y_length_reg)): object 'x_length_reg' not found
~~~
{:.input}
~~~r
## Based on the size of the extent, let's set the size for our new raster layer: 
#we don't want too fine as resolution: let's do 100m, it will keep the grid small

res_val <- 100
r = raster(ext=extent_reg, res=res_val)
~~~
{:.input}
~~~
Error in .local(...): object 'extent_reg' not found
~~~
{:.input}
~~~r
dim(r)
~~~
{:.input}
~~~
Error in eval(expr, envir, enclos): object 'r' not found
~~~
{:.input}
~~~r
values(r) <- 1:ncell(r) # Assign values to raster, ID for each pixel
~~~
{:.input}
~~~
Error in ncell(r): object 'r' not found
~~~
{:.input}
~~~r
#assign projection system
projection(r) <- proj4string(census_metals_pb_sp)
~~~
{:.input}
~~~
Error in proj4string(census_metals_pb_sp): object 'census_metals_pb_sp' not found
~~~
{:.input}
~~~r
######Visualize the data first

plot(r)
~~~
{:.input}
~~~
Error in plot(r): object 'r' not found
~~~
{:.input}
~~~r
#generate grid from raster as poly for visualization
r_poly<- rasterToPolygons(r)
~~~
{:.input}
~~~
Error in nlayers(x): object 'r' not found
~~~
{:.input}
~~~r
plot(extent_reg,add=T,col="red")
~~~
{:.input}
~~~
Error in plot(extent_reg, add = T, col = "red"): object 'extent_reg' not found
~~~
{:.input}
~~~r
plot(census_metals_pb_sp,border="blue",add=T)
~~~
{:.input}
~~~
Error in plot(census_metals_pb_sp, border = "blue", add = T): object 'census_metals_pb_sp' not found
~~~
{:.input}
~~~r
### Let's show the grid first
plot(r_poly,add=T)
~~~
{:.input}
~~~
Error in plot(r_poly, add = T): object 'r_poly' not found
~~~
{:.input}
~~~r
## Transform the raster layer into a sp Grid object for kriging
r_sgdf <- as(r, 'SpatialGridDataFrame')
~~~
{:.input}
~~~
Error in .class1(object): object 'r' not found
~~~
{:.input}
~~~r
class(r_sgdf)
~~~
{:.input}
~~~
Error in eval(expr, envir, enclos): object 'r_sgdf' not found
~~~
{:.input}
~~~r
## Generate and plot a sample variogram from lead data
v_ppm <- variogram(ppm ~ 1,soil_PB_sp)
~~~
{:.input}
~~~
Error in is(locations, "ST"): object 'soil_PB_sp' not found
~~~
{:.input}
~~~r
plot(v_ppm)
~~~
{:.input}
~~~
Error in plot(v_ppm): object 'v_ppm' not found
~~~
{:.input}
~~~r
## Fit a variogram model from lead data

v_ppm_fit <- fit.variogram(v_ppm,model=vgm(1,"Sph",900,1))
~~~
{:.input}
~~~
Error in inherits(object, "gstatVariogram"): object 'v_ppm' not found
~~~
{:.input}
~~~r
plot(v_ppm,v_ppm_fit)
~~~
{:.input}
~~~
Error in plot(v_ppm, v_ppm_fit): object 'v_ppm' not found
~~~
{:.input}
~~~r
##Generate a kriging surface using data and modeled variogram: this may take more than 3 minutes
ppm_lead_spg <- krige(ppm ~ 1, soil_PB_sp, r_sgdf, model=v_ppm_fit)
~~~
{:.input}
~~~
Error in krige(ppm ~ 1, soil_PB_sp, r_sgdf, model = v_ppm_fit): object 'soil_PB_sp' not found
~~~
{:.input}
~~~r
class(ppm_lead_spg)
~~~
{:.input}
~~~
Error in eval(expr, envir, enclos): object 'ppm_lead_spg' not found
~~~
{:.input}
~~~r
r_lead <- raster(ppm_lead_spg)
~~~
{:.input}
~~~
Error in raster(ppm_lead_spg): object 'ppm_lead_spg' not found
~~~
{:.input}
~~~r
rm(ppm_lead_spg) #remove grid object from memory
~~~
{:.input}
~~~
Warning in rm(ppm_lead_spg): object 'ppm_lead_spg' not found
~~~
{:.input}
~~~r
r_lead #examine new layer
~~~
{:.input}
~~~
Error in eval(expr, envir, enclos): object 'r_lead' not found
~~~
{:.input}
~~~r
col_palette <- matlab.like(256)
~~~
{:.input}
~~~
Error in matlab.like(256): could not find function "matlab.like"
~~~
{:.input}
~~~r
plot(r_lead,col=col_palette)
~~~
{:.input}
~~~
Error in plot(r_lead, col = col_palette): object 'r_lead' not found
~~~
{:.input}
~~~r
plot(census_metals_pb_sp,border="blue",add=T)
~~~
{:.input}
~~~
Error in plot(census_metals_pb_sp, border = "blue", add = T): object 'census_metals_pb_sp' not found
~~~
{:.input}
~~~r
## Save raster layers produced from kriging
raster_name <- file.path(out_dir,paste0("r_lead",out_suffix,file_format))
writeRaster(r_lead,filename = raster_name,overwrite=T)
~~~
{:.input}
~~~
Error in writeRaster(r_lead, filename = raster_name, overwrite = T): object 'r_lead' not found
~~~
{:.input}
~~~r
#### Comparison of aggregations ###
## Compare values from averages from kriging surface and averages from block groups

census_lead_sp <- extract(r_lead,census_metals_pb_sp,sp=T,fun=mean) #extract average values by census track
~~~
{:.input}
~~~
Error in extract(r_lead, census_metals_pb_sp, sp = T, fun = mean): object 'r_lead' not found
~~~
{:.input}
~~~r
spplot(census_metals_pb_sp,"pb_ppm",col.regions=col_palette,main="Averaged from blockgroups") #
~~~
{:.input}
~~~
Error in spplot(census_metals_pb_sp, "pb_ppm", col.regions = col_palette, : object 'census_metals_pb_sp' not found
~~~
{:.input}
~~~r
spplot(census_lead_sp,"var1.pred",col.regions=col_palette,main="Averaged from kriging ") 
~~~
{:.input}
~~~
Error in spplot(census_lead_sp, "var1.pred", col.regions = col_palette, : object 'census_lead_sp' not found
~~~
{:.input}
~~~r
census_lead_sp$diff <- census_metals_pb_sp$pb_ppm - census_lead_sp$var1.pred #comparing the averages
~~~
{:.input}
~~~
Error in eval(expr, envir, enclos): object 'census_metals_pb_sp' not found
~~~
{:.input}
~~~r
hist(census_lead_sp$diff)
~~~
{:.input}
~~~
Error in hist(census_lead_sp$diff): object 'census_lead_sp' not found
~~~
{:.input}
~~~r
spplot(census_lead_sp,"diff",col.regions=col_palette,main="Difference in averages")
~~~
{:.input}
~~~
Error in spplot(census_lead_sp, "diff", col.regions = col_palette, main = "Difference in averages"): object 'census_lead_sp' not found
~~~
{:.input}
~~~r
##### PART IV: Spatial autocrrelation and regression #############
## Examine spatial autocorrelation
#Examine the relationship between metals, Pb and vulnerable populations in Syracuse

list_nb <- poly2nb(census_lead_sp) #generate neighbours based on polygons
~~~
{:.input}
~~~
Error in extends(class(pl), "SpatialPolygons"): object 'census_lead_sp' not found
~~~
{:.input}
~~~r
summary(list_nb)
~~~
{:.input}
~~~
Error in summary(list_nb): object 'list_nb' not found
~~~
{:.input}
~~~r
plot(census_lead_sp,border="blue")
~~~
{:.input}
~~~
Error in plot(census_lead_sp, border = "blue"): object 'census_lead_sp' not found
~~~
{:.input}
~~~r
plot.nb(list_nb,coordinates(census_lead_sp),add=T)
~~~
{:.input}
~~~
Error in plot.nb(list_nb, coordinates(census_lead_sp), add = T): object 'list_nb' not found
~~~
{:.input}
~~~r
#generate weights
#nb2listw
list_w <- nb2listw(list_nb, glist=NULL, style="W", zero.policy=NULL) #use row standardized
~~~
{:.input}
~~~
Error in inherits(neighbours, "nb"): object 'list_nb' not found
~~~
{:.input}
~~~r
can.be.simmed(list_w)
~~~
{:.input}
~~~
Error in inherits(nb, "nb"): object 'list_w' not found
~~~
{:.input}
~~~r
summary(list_w)
~~~
{:.input}
~~~
Error in summary(list_w): object 'list_w' not found
~~~
{:.input}
~~~r
## Compute Moran's I and display it
moran(census_lead_sp$pb_ppm,list_w,n=nrow(census_lead_sp), Szero(list_w))
~~~
{:.input}
~~~
Error in moran(census_lead_sp$pb_ppm, list_w, n = nrow(census_lead_sp), : object 'list_w' not found
~~~
{:.input}
~~~r
moran.plot(census_lead_sp$pb_ppm, list_w,
           labels=as.character(census_lead_sp$TRACT), pch=19)
~~~
{:.input}
~~~
Error in inherits(listw, "listw"): object 'list_w' not found
~~~
{:.input}
~~~r
##### Now do a spatial regression

## Is there are relationship between minorities and high level of lead?
# As a way to explore use, perc_hispa as explanatory variable

#linear model without taking into account spatial autocorrelation
mod_lm <- lm(pb_ppm ~ perc_hispa, data=census_lead_sp)
~~~
{:.input}
~~~
Error in is.data.frame(data): object 'census_lead_sp' not found
~~~
{:.input}
~~~r
#autoregressive model
mod_lag <- lagsarlm(pb_ppm ~ perc_hispa, data=census_lead_sp, list_w, tol.solve=1.0e-30)
~~~
{:.input}
~~~
Error in terms.formula(formula, data = data): object 'census_lead_sp' not found
~~~
{:.input}
~~~r
### Checking for autocorrelation in residuals
moran.test(mod_lm$residuals,list_w)
~~~
{:.input}
~~~
Error in inherits(listw, "listw"): object 'list_w' not found
~~~
{:.input}
~~~r
moran.test(mod_lag$residuals,list_w) #Note that Moran'sI is close to zero in the lag model
~~~
{:.input}
~~~
Error in moran.test(mod_lag$residuals, list_w): object 'list_w' not found
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
Error in Moran(r_lead, f): object 'r_lead' not found
~~~
{:.input}
~~~r
r_moran <- MoranLocal(r_lead)
~~~
{:.input}
~~~
Error in MoranLocal(r_lead): object 'r_lead' not found
~~~
{:.input}
~~~r
plot(r_moran) # hotspots?
~~~
{:.input}
~~~
Error in plot(r_moran): object 'r_moran' not found
~~~
{:.input}
~~~r
################### END OF SCRIPT ##########################
~~~
{:.output}

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.
