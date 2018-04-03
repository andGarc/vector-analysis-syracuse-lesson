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
-1.002799 -0.212714  0.074072  0.235047  0.870624 

Type: lag 
Coefficients: (asymptotic standard errors) 
            Estimate Std. Error z value Pr(>|z|)
(Intercept)  1.10395    0.45580  2.4220  0.01544
perc_hispa   1.27550    0.99076  1.2874  0.19795

Rho: 0.76278, LR test value: 23.183, p-value: 1.473e-06
Asymptotic standard error: 0.092139
    z-value: 8.2786, p-value: 2.2204e-16
Wald statistic: 68.535, p-value: < 2.22e-16

Log likelihood: -31.49178 for lag model
ML residual variance (sigma squared): 0.15101, (sigma: 0.3886)
Number of observations: 57 
Number of parameters estimated: 4 
AIC: 70.984, (AIC for lm: 92.166)
LM test for residual autocorrelation
test value: 5.5923, p-value: 0.01804
~~~
{:.output}



