---
editor_options: 
  chunk_output_type: console
---

## Regression

Continuing the theme that vector data *is* tabular data, the natural
progression in statistical analysis is toward regression. Building a regression
model requires making good assumptions about relationships in your data:

- between *columns* as independent and dependent variables
- between *rows* as more-or-less independent observations

===

The following model assumes an association (in the linear least-squares sense),
between the hispanic population and lead concentrations and assumes independence
of every census tract (i.e. row).


~~~r
ppm.lm <- lm(pred_ppm ~ perc_hispa,
  census_lead_tracts)
~~~
{:.text-document title="{{ site.handouts[0] }}"}

===

Is that model any good?


~~~r
census_lead_tracts['lm.resid'] <- resid(ppm.lm)
plot(census_lead_tracts['lm.resid'])
~~~
{:.text-document title="{{ site.handouts[0] }}"}

![plot of chunk unnamed-chunk-2]({{ site.baseurl }}/images/unnamed-chunk-2-1.png)
{:.captioned}

===

Polygons close to eachother tend to have similar residuals: there is
autocorrelation. It is tempting to ask for a semivariogram plot of the
residuals, but that requires a precise definition of the distance between
polygons. A favored alternative for quantifying autoregression in non-point
feature collections is Moran's I. This analog to Pearson's correlation
coeficient quantifies autocorrelation rather than cross-correlation.
{:.notes}

Moran's I is the correlation between all pairs of features, weighted to
emphasize features that are close together. It does not dodge the problem of
distance weighting, it actually adds flexibility, along with some norms.


~~~r
sp <- import('sp')
sd <- import('spdep')
tracts <- as(
  sf$st_geometry(census_tracts), 'Spatial')
tracts_nb <- sd$poly2nb(tracts)
~~~
{:.text-document title="{{ site.handouts[0] }}"}

===

The `neighbors` variable is the network of features sharing a boundary point.


~~~r
plot(census_lead_tracts['lm.resid'])
sd$plot.nb(tracts_nb,
  sp$coordinates(tracts), add = TRUE)
~~~
{:.text-document title="{{ site.handouts[0] }}"}

![plot of chunk unnamed-chunk-4]({{ site.baseurl }}/images/unnamed-chunk-4-1.png)
{:.captioned}

===

Reshape the adjacency matrix into a list of neighbors with associated weights.


~~~r
tracts_weight <- sd$nb2listw(tracts_nb)
~~~
{:.text-document title="{{ site.handouts[0] }}"}

===

Visualize correlation between the residuals and the weighted average of their
neighbors with `moran.plot` from the [spdep](){:.rlib}


~~~r
sd$moran.plot(
  census_lead_tracts[['lm.resid']],
  tracts_weight,
  labels = census_lead_tracts[['TRACT']],
  pch = 19)
~~~
{:.text-document title="{{ site.handouts[0] }}"}

![plot of chunk unnamed-chunk-6]({{ site.baseurl }}/images/unnamed-chunk-6-1.png)
{:.captioned}

===

There are many ways to use geospatial information about tracts to impose
assumptions about non-independence between observations in the regression. One
approach is a Spatial Auto-Regressive (SAR) model, which regresses each value against
the weighted average of neighbors.



~~~r
ppm.sarlm <- sd$lagsarlm(
  pred_ppm ~ perc_hispa,
  data = census_lead_tracts,
  tracts_weight,
  tol.solve = 1.0e-30)
~~~
{:.text-document title="{{ site.handouts[0] }}"}

===

The Moran's I plot of residuals shows less correlation; which means the SAR
model's assumption about spatial autocorrelation (i.e. between table rows) makes
the rest of the model more plausible.


~~~r
sd$moran.plot(
  resid(ppm.sarlm),
  tracts_weight,
  labels = census_lead_tracts[['TRACT']],
  pch = 19)
~~~
{:.text-document title="{{ site.handouts[0] }}"}

![plot of chunk unnamed-chunk-9]({{ site.baseurl }}/images/unnamed-chunk-9-1.png)
{:.captioned}

===

Feeling more confident in the model, we can now take a look at the regression
coefficients.


~~~r
summary(ppm.sarlm)
~~~
{:.input}
~~~

Call:
sd$lagsarlm(formula = pred_ppm ~ perc_hispa, data = census_lead_tracts, 
    listw = tracts_weight, tol.solve = 1e-30)

Residuals:
      Min        1Q    Median        3Q       Max 
-0.992669 -0.210942  0.037845  0.246989  0.888440 

Type: lag 
Coefficients: (asymptotic standard errors) 
            Estimate Std. Error z value Pr(>|z|)
(Intercept)  1.16047    0.46978  2.4702   0.0135
perc_hispa   1.45285    0.95717  1.5179   0.1291

Rho: 0.7499, LR test value: 22.434, p-value: 2.175e-06
Asymptotic standard error: 0.095079
    z-value: 7.8871, p-value: 3.1086e-15
Wald statistic: 62.207, p-value: 3.1086e-15

Log likelihood: -29.16485 for lag model
ML residual variance (sigma squared): 0.14018, (sigma: 0.37441)
Number of observations: 57 
Number of parameters estimated: 4 
AIC: 66.33, (AIC for lm: 86.764)
LM test for residual autocorrelation
test value: 4.5564, p-value: 0.032797
~~~
{:.output}


