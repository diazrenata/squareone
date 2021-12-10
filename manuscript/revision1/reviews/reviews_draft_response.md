# Reviews

## Editor:

The reviewers and I appreciate the work you have accomplished. We are willing to consider a revised version for publication in the journal, assuming that you are able to modify the manuscript according to the recommendations.

Your revisions should address the specific points made by each reviewer.  Both provide constructive suggestions to improve the ms.  I agree that an explanation of mathematical procedures will avoid confusion over the R code, as suggested by Rev #1, and that a figure of body mass of the rodents involved in this study would be very useful, as suggested by Rev #2.

## Reviewer Comments to Author: Reviewer: 1

Comments to the Author

This manuscript studies the link between community function and structure by measuring the changes of a desert rodent community in Arizona. An interesting feature of this study is the long time series (over 30 years) gathered on these desert rodents within an experimental setting that includes exclosures.

I found the manuscript interesting and well written. Overall, I have only minor concerns that need to be addressed about the manuscript.

1 - Make sure all acronyms used on the manuscript are defined. For example, “SG” is never defined. *Sure, we can expand the definitions.*

2 - L39: Define “community function” *Sure. (Probably in the next sentence for readability).*


3 - L104-105: “...the habitat at the study site has transitioned from desert grassland to scrub...”
Why? Is it because of the rodent community or because of other environmental constraints? Please give more details. This information is important because if it is caused by the rodent species themselves, it could have important implication for the rodent community structure. *This is a good point. In this system, the habitat transition was driven by shifting environmental conditions (particularly several seasons of high rainfall associated with the early 1990s La Nina cycle that facilitated shrub encroachment; Ernest/Brown ref).*


4 - L111-112: Move this small paragraph to the end of the Method section. *Sure.*


5 - L114-120: Could the exclosure with small holes prevent other species (e.g. larger predators of rodents) to enter in the exclosure thus influencing the dynamic of the rodent community and potentially the environment (see my comments above)? Please explain. *I'm sure this has come up before. I don't have perfect language for this off the top, but my instinct is to acknowledge this in the text as part of a slightly expanded description of the Portal methodology (see also response to R2.6), and then move on. (I'll research this specifically in the Portal lit, but my prior is that the main predators to rodents in this system are birds, coyotes, and snakes. Birds and coyotes are likely minimally affected by the (low - 0.5m high) fences; and any behavioral effects of the fences should not depend on the gate sizes. The most significant experimental artifact regarding predation possible would be effects on snakes, and specifically on snakes that are too large to fit through the small gates, but small enough to fit through the large gates. Which is...a very specific set of snakes.)*


6 - L126-130: On these lines a description of the time periods used for comparison are presented. This description should explain in details why the boundaries of each time period was selected as they were. *I'm a little confused by this one but can 1) add additional explanation of the boundaries; 2) explain more fully to the reviewer; 3) explore sensitivity, e.g. +/- 3 to 6 months around the boundaries...*


7 - L131: “5.69 * (m^0.75)”. In the context of the study, it is important to explain the meaning of this equation and of the different values in this equation. *Sure. I take this as another clause along the lines of "using the scaling relationship between body mass and energy use previously described in X Y and Z..."*


8 - L153: “... using the form response ~ time period + CORCAR1(census period)...”
What does this mean exactly? Especially the CORCAR1() part. This would be clearer if mathematical equations were used to describe the model instead of R code. *Looks like including pseudocode is not landing with this audience, so my inclination is to link clearly to the repo (for the R nerds) and explain in words here. I'll have to look up how to talk about CORCAR1 in words. It's been used before in Portal papers.*


9 – Following up on comment 8, I strongly believe that presenting pseudo-code (or R code) in a manuscript as was done here may lead to confusion and result in misunderstanding of the model that was actually used and as such I recommend using mathematical equation instead. For example, in the explanation giving prior to the pseudo-code presented on L164-165 (response ~ time period * treatment), it is not clear what the relationship between the different parts of the explanatory variable in model. In R, the code presented means that the “response” is modelled with the “time period” variable, the “treatment” variable and the interaction between “time period” and “treatment”, while in the explanation given, the text seems to imply (although this is not clear) that only “time period” and “treatment” are interacting. Obviously, this has important implication in the results and the interpretation given to the model. Note that if only the interacting terms were to be considered, “:” should be used instead of “*” in R.
In any case, this needs to be clarified.

*Definitely. See above on switching to verbal vs. pseudocode.* 

*Also, in this specific model: this was a point of internal debate for me. My POV was that it makes biological sense a priori to include the interaction term in the model. The interaction term does not come out significant and doesn't have much of an effect on the estimates. There's some philosophical debate about whether, in that situation, it's better to leave the biologically-relevant-but-not-important term in or to remove it (i.e. stepwise selection). I left it in and moved on to save a rabbit hole, but removing it has absolutely no qualitative effect on the results.* 

*Given this reviewer's perspective, my instinct is to present the model without the interaction in the text and explain the internal-debate and decision to switch to the reviewer.*

10 - L159 and L164: “quasibinomial”. Explain why a quasibinomial link model was used instead of the more traditional binomial model... or any other model for that matter. *As I recall I used the quasibinomial because some of the treatment-timeperiods have a lot of 0's, and I think this was affecting the confidence intervals in implausible ways. TBH it might also have been because R complains at you if you use proportion data with a binomial GLM, and I was intimidated. Doesn't matter either way, because the effects are so clear cut.*


## Reviewer: 2

Comments to the Author

This manuscript provides important updates to the long-term results from a rigorous experiment that excluded functionally-important rodents, kangaroo rats. First, it finds that the previously reported functional compensation by the pocket mouse has substantially decreased in the past decade, after a community reorganization event. Second, it finds that the kangaroo rat energy use has also decreased in the past two decades. Together, these results demonstrate the importance of long-term experiments, and how species colonization and fluctuations can alter ecosystem functioning and the ability of remaining or colonizing species to functionally compensate for lost species. I agree with the authors that 'this type of temporary, context-dependent compensation may be common.' I have only one main suggestion, as well as many specific suggestions that I hope will help further improve this manuscript, which is already strong. *MEEP!!!!*


1 - To help compare with other studies, I recommend including a figure, even if only in the supplement, presenting raw rodent body mass in grams. Although I am not questioning the importance of these metabolic and energetic calculations, many other theoretical and experimental studies considering biodiversity and ecosystem functioning have reported the biomass of various trophic levels and functional groups of species. In addition to these metabolic rate and energetic estimates, which are a nonlinear function of measured body mass (as shown on L131) and which depend on the combinations of body mass and numbers of individuals, a broad readership would also be interested in the raw body mass results for the treatments and key species. How does rodent biomass compare between treatments and change over time? This question seems relevant to the framing of the paper. *Definitely on including a look at biomass in addition to energy use. A quick look tells me that the results for biomass are qualitatively the same as for energy use, so my inclination is to put this in the supplement.*

Additional specific recommendations:

Abstract

2 - L23-24: The main results statements would be stronger if the words 'changed' and 'changes' are avoided and replaced by directional statements. For example, rather than stating that the degree of functional redundancy changed on L24, it is much clearer to state that there was decreased functional overlap, as nicely stated on L27. *Sure.*

3 - L32: I recommend removing 'zero-sum constraints' from this sentence in the abstract because the results do not support this assumption, as explained in the discussion. Including this here, without further explanation, might suggest the opposite to readers. *Sure.*

Introduction

4 - L42: I believe 'have similar functional traits' is too specific here, given that ecosystem functioning depends not only on functional composition and traits, but also on species interactions, the latter of which are often poorly predicted by functional traits. The results of hundreds of randomized biodiversity experiments tend to show large effects of species richness on ecosystem functioning, even when all the same species and traits are present at different levels of species richness (i.e., to study effects of richness independent of changes in composition). Thus, when a species is lost from a community, two things change: species composition (which species and traits are present) and species richness (how many species and what variation in traits are present). Perhaps you are focused on the special case, though, where the lost species is replaced, and thus composition and traits shift, without a change in richness? How did rodent richness change between treatments and over time? *I suggest finessing this language to acknowledge the complexity of the composition/richness/traits relationship. A guardrail here, I don't think this wants to stray too deeply in a BEF direction.*

5 - L58: Perhaps begin a new paragraph with the sentence beginning 'Even without...' because you make two very important points in this paragraph (shifts in composition and shifts in functional redundancy). *Sure.*

Methods

6 - L110: Somewhere in the methods, it would be good to describe the measurements. For example, how and how often were body mass measurements made? *Sure.*

7 - L115: I appreciate the land acknowledgement. *:)*

8 - L122, L136: Given the small and unbalanced sample sizes (4 controls and 5 exclosures), it makes me uncomfortable that the data were combined across all plots within treatments. Note that there may be effects of the number of fluctuating variables (plots in this case) on the temporal mean and variance (Yachi and Loreau 1999 PNAS). I recommend randomly choosing 4 of the 5 exclosures to ensure a balanced design and that any treatment differences are not due to differences in sample sizes. *Happy to do this.*

9 - L151-154: Given that results for all variables were combined across plots within treatments (as stated on L136), was there any replication for these repeated measures analyses? What sources of variation are included or excluded in the 95% confidence and credible intervals in Fig. 1? It would help to clarify this in the Methods. *I'm not completely sure I understand this at first read, but picking up on a discomfort with the treatment-level aggregation. I can explain my thinking more fully on the temporal autocorrelation term (which also doesn't affect the results). These models do not incorporate the plot at all - everything is a treatment level mean, for consistency with compensation. I would argue for keeping it this way in the text, but could explore and provide to this reviewer a report of models that do incorporate plot  for the currencies for which that is possible.*

*One possibility there would be to do all the plot level currencies with plot properly incorporated. Then calculate compensation at the plot level using the treatment-level mean for the "control" value and do a compensation incorporating plot. That's not ideal, but it does allow you to look at the plot a little bit. I've done a lot of things along these lines...*

*Update - I just implemented the above, a little hackily. Nearly everything sorts out the same, _unless_ you start removing plots. Then, _if you remove plot 19_, you get a significant contrast between a and c for compensation - still not enough of an increase to look like it matches the increase in total energy ratio. Not sure if this is something for the supplement or just the reviewer - I'm inclined to put it in the supplement.*

Results

10 - L173: It would help to add a few words clarifying what 19% and 55% are in reference to. If I understand correctly, then these are the percentages of KR energy use in control plots during these respective periods. Is this correct? *Sure, and correct. Always a balance how much to explain these kind of long-winded quantities in words.*

Discussion

11 - L206: I recommend changing 'substantially' to 'partly' or 'incompletely' because the energetic compensation shown in Fig. 1B is very far from complete, even during the middle period of time. *Sure.*

12 - L208: As noted in the preceding comment, the results in Fig. 1B do not suggest that C. baileyi was able to fully compensate for KR. Thus, it seems overstated to refer to C. baileyi as a 'functional replacement' for KR. *Sure.*

13 - L267-270: Yes, and there is considerable evidence that different sets of plant species promote an ecosystem function at different times and places, and under different global changes (Isbell et al. 2011 Nature). This is consistent with your results and suggests that we should not think of species' contributions to ecosystem functioning in a static sense. *Sure. This might be a prod to cite Isbell.?*

14 - L271-272: This is a strong statement, which is fully-supported by the results: 'this type of temporary, context- dependent compensation may be common.' It might help to include a clear statement such as this one in the Abstract. *Thank you! Will explore working that in. (meep!)*

