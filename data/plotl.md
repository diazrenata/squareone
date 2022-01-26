# plotl.csv

The main data for analysis: energy use by all granivores, kangaroo rats, and C. baileyi on 9 long-term exclosure and control plots from 1988-2020. Downloaded from the Portal Data repo using `portalr` and helper functions in `soar`.

The variables used in these analyses, and their definitions.

- `period`: The monthly census period number for each census. Numeric.
- `censusdate`: The date of the monthly census. Date/character.
- `era`: The "time period", as described in the text. Character, one of `a_pre_pb` (first time period, before *C. baileyi* arrived at the site), `b_pre_reorg` (second time period, after *C. baileyi* established but before the most recent reorganization event), or `c_post_reorg` (third time period, after the last reorganization event).
- `oera`: `era` as an ordered factor, for modeling. Ordered factor; R loads as character.
- `plot`: The plot. Of the 24 in the Portal Project, 9 are included in these data. 
- `plot_type`: The treatment, either `CC` for control or `EE` for exclosure. Character.
- `total_e`: Total energy use by all granivores on that plot in that census period. Numeric.
- `dipo_e`: Energy use by kangaroo rats (*Dipodomys spectabilis*, *D. ordii*, *D. merriami*) on that plot in that census period.  Numeric.
- `smgran_e`: Energy use by granivores other than kangaroo rats (*Baiomys taylori*, *C. baileyi*, *Chaetodipus hispidus*, *Chaetodipus intermedius*, *Chaetodipus penicillatus*, *Perognathus flavus*, *Peromyscus eremicus*, *Peromyscus leucopus*, *Peromyscus maniculatus*, *Reithrodontomys fulvescens*, *Reithrodontomys megalotis*, and *Reithrodontomys montanus*) on that plot in that census period. Numeric.
- `pb_e`: Energy use by *C. baileyi* (whose species code in these data is PB) on that plot in that census period. Numeric.
- `pp_e`: Energy use by *C. penicillatus* on that plot in that census period; not used in these analyses. Numeric.
- `tinygran_e`: Energy use by small granivores other than *C. baileyi* on that plot in that census period; not used in these analyses. Numeric.
- `oplottype`: `plot_type` as an ordered factor, for modeling. Ordered factor, R loads as character.
- `fplottype`: `plot_type` as a factor. R loads as character. Not used.
- `fplot`: `plot` as a factor. R loads as an integer.
- `total_e_ma`, `dipo_e_ma`, `smgran_e_ma`, `pb_e_ma`, `pp_e_ma`, `tinygran_e_ma`: 6-month averages of the corresponding columns. Numeric.
