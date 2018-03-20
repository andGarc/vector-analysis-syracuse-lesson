---
---

## Objectives for this lesson

- Dive into scripting vector data operations
- Learn to handle feature collections like tables
- Address autocorrelation in point data
- Glimpse a spatial regression framework

===

## Specific achievements

- Read CSVs and shapefiles
- Intersect and dissolve geometries
- Smooth point data with Kriging
- Include autocorrelation in a regression

===

## Import Clarification

Packages or libraries expand the vocabulary of the R interpreter, sometimes too
quickly for a user's comfort. The [modules](){:.rlib} library provides an `import`
command, used throughout this lesson, to help keep tabs the many new commands we
import.


~~~r
library('modules')
import('magrittr', '%>%')
~~~
{:.text-document title="{{ site.handouts[0] }}"}
