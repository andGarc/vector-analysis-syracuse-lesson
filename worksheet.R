## Import Clarification

library('modules')
import('magrittr', '%>%')

## Simple Features

sf <- import(...)

lead <- read.csv('data/SYR_soil_PB.csv')
lead[['geometry']] <- sf$st_sfc(
  ...
  crs = 32618)

lead[[1, 'geometry']] <- ...(
  c(...),
  dim = 'XY')

lead <- ...

lead <- read.csv('data/SYR_soil_PB.csv')
lead <- ...(lead,
  ...,
  crs = 32618)

plot(lead['ppm'])

## Feature Collections

blockgroups <- ...('data/bg_00')

## Table Operations

census <- ...('data/SYR_census.csv')
census$BKG_KEY <- factor(census$BKG_KEY)

import('dplyr', 
  'inner_join', 'group_by', 'summarise')

census_blockgroups <- ...(
  ...
  by = c('BKG_KEY'))

...

census_tracts <- census_blockgroups %>%
  ... %>%
  ...(
    POP2000 = sum(POP2000),
    perc_hispa = sum(HISPANIC) / sum(POP2000))

tracts <- ...('data/ct_00')
plot(census_tracts['POP2000'])
plot(..., border = 'red', add = TRUE)

## Spatial Join

plot(...,
  pal = cm.colors)
plot(...,
  pch = '.', ...)

lead_tracts <- lead %>%
    ... %>%
    ...

lead_tracts <- lead %>%
    sf$st_join(census_tracts) %>%
    sf$st_set_geometry(NULL) %>%
    ... %>%
    ...

census_lead_tracts <- census_tracts %>%
  inner_join(...)
plot(census_lead_tracts['avg_ppm'],
  pal = heat.colors)

## The Semivariogram

g <- import(...)

lead_xy <- read.csv('data/SYR_soil_PB.csv')

v_ppm <- ...(
  ppm ~ 1,
  locations = ~ x + y,
  data = lead_xy)
plot(v_ppm)

v_ppm_fit <- ...(
  v_ppm,
  model = ...)
plot(v_ppm, v_ppm_fit)

## Kriging

pred_ppm <- ...(
  lead, cellsize = 400,
  what = 'centers')
idx <- unlist(
  ...(census_tracts, pred_ppm))
pred_ppm <- ...

plot(census_tracts['POP2000'],
  pal = cm.colors)
plot(pred_ppm,
  pch = '.', ...)

pred_ppm_xy <- data.frame(
  ...)
names(pred_ppm_xy) <- c('x', 'y')

pred_ppm_xy <- ...(
  ppm ~ 1,
  locations = ~ x + y,
  data = lead_xy,
  ...,
  model = v_ppm_fit)

pred_ppm <- ...(
  ...,
  coords = c('x', 'y'),
  crs = sf$st_crs(lead))

pred_ppm_tracts <-
  pred_ppm %>%
  ...(census_tracts) %>%
  sf$st_set_geometry(NULL) %>%
  group_by(TRACT) %>%
  summarise(...)
census_lead_tracts <- 
  census_lead_tracts %>%
  ...(pred_ppm_tracts)

plot(...[
  c('pred_ppm', 'avg_ppm')],
  pal = heat.colors)

## Regression

ppm.lm <- ...(pred_ppm ~ perc_hispa,
  census_lead_tracts)

census_lead_tracts['lm.resid'] <- ...
plot(census_lead_tracts['lm.resid'])

sp <- import(...)
sd <- import(...)
tracts <- as(
  sf$st_geometry(census_tracts), 'Spatial')
tracts_nb <- ...(tracts)

plot(census_lead_tracts['lm.resid'])
sd$plot.nb(tracts_nb,
  sp$coordinates(tracts), add = TRUE)

tracts_weight <- ...(tracts_nb)

...(
  census_lead_tracts[['lm.resid']],
  ...,
  labels = census_lead_tracts[['TRACT']],
  pch = 19)

ppm.sarlm <- ...(
  pred_ppm ~ perc_hispa,
  data = census_lead_tracts,
  tracts_weight,
  tol.solve = 1.0e-30)

sd$moran.plot(
  ...,
  tracts_weight,
  labels = census_lead_tracts[['TRACT']],
  pch = 19)
