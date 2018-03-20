---
editor_options: 
  chunk_output_type: console
---

## Summary

Rapid tour of packages providing tools for manipulation and analysis of
vector data in R.

- [sf](){:.Rpkg}
  - st_sf: make a simple features data frame
  - read_sf: read a file into a simple features data frame
  - st_join: match tables on their geometry columns
- [gstat](){:.Rpkg}
  - variogram: distance lagged correlation for points
  - fit.variogram: autocorrelation model
  - krige: smooth interpolation over points
- [sp](){:.Rpkg}
  - a low level package with useful `Spatial*` class objects
- [spdep](){:.Rpkg}
  - poly2nb, nb2listw: calculate spatial neighbors and their weights
  - moran.plot: infer autocorrelation from residual scatter plots
  - lagsarlm: SAR model estimation
