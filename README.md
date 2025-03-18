# R Course Final assignment – Summarizing Document 

### The Dataset (A1)
This is a dataset from an experiment testing perception of emotional valence during exposure to emotional audio stimuli. 200 Online participants from the UK rated how they felt while listening to 60 emotional sound effects on SAM scales, 9-point likert scales with emoticons expressing valence, ranging from 1 (very negative) to 9 (very positive). The sound effects were taken from the International Affective Digitized Sounds (IADS) system, and all have norm valence ratings. They also completed two questionnaires: The OCI-R – Obsessive Compulsive Inventory Revised: An 18-items questionnaire measuring obsessive compulsive (OC) symptoms; and the DASS-21 anxiety and depression subscales.
I chose to work on this dataset because I collaborated on the experiment as a research assistant to Prof. Ruvi Dar. I was both interested in how emotion and emotion recognition are affected by symptoms of OCD, depression and anxiety, and concluded that this assignment can be a good opportunity to do exploratory work on our data. 

### Data Processing (B2, and B3 / B4 – I will note where they’re relevant)
See part1_data_processing.R.
In this script, I processed the collected data into a dataset that’s ready for exploratory work and analysis.  
- Excluded irrelevant data (like metadata automatically added by qualtrics) by selecting only relevant columns.
- Did some cleaning and adjustments for clarity and precision.
- Unified the experiment data and the demographic data. <br/><br/>
After arranging the raw data, I calculated potential variables to exploratorily examine in section A2: <br/><br/> 
- Calculated the distances between participants’ valence ratings and the IADS standard ratings.
  - I used a function I wrote (B3 – see function in part2_function.R).
- Tried using the “rex” package as a more readable/intuitive alternative to grepl (which might constitute for B4).  
- Calculated OCI-R, DASS-anxiety, and DASS-depression scores.
- Calculated means and variances of both the valence ratings and the distances. I also calculated mean ratings for positive and negative stimuli separately.
  - I used a function I wrote (B3 – see function in part2_function.R).
- Created a measure of the rate of responses that were of extreme distance from the norm. An extreme response was defined as an absolute distance larger than the mean + sd of all absolute distances from the relevant sound’s norm rating. This method was 
- Filtered out responses from participants who failed attention checks. There were two attention checks for the sounds, where participants were asked to mark a certain number on the SAM scale; And each questionnaire included two infrequency items – nonsensical items meant to detect inattentive responders.

### Exploratory Presentation of the Data (A2)
See part3_exploratory_visualization.R.





## The Research Question (A3)
Are symptoms of OCD, depression or anxiety related to the reported emotional valence felt during exposure to emotional audio stimuli, and to the degree to which individuals deviate from norms in their reports? 

### The Variables (B1)

- Obsessive compulsive symptoms – OCI_R: The score in the OCI-R questionnaire. <br/><br/>
- Anxiety symptoms – DASS_anxiety: The score in the DASS anxiety subset. <br/><br/>
- Depression symptoms – DASS_depression: The score in the DASS depression subset. <br/><br/>
- Mean emotional valence categories: a binary negative/positive mean rating variable – low_valence_group. (1) notes belonging to the group that gave low, meaning negative, ratings on average, and (0) notes belonging to the group that gave high, meaning positive, ratings on average. 
<br/><br/> Initially, I intended to divide the sample by a cutoff score of the mean of IADS norm ratings, but after looking at the data, the distinction between consistently negative/positive raters did not seem sharp enough that way. 
<br/><br/>
Therefore, I decided on an alternative approach (see part4_additional_processing.R). I divided the sample into 4 mean valence quartiles. I then selected the bottom quartile as the group of negative raters, and the top quartile as the group of positive raters. The logistic regression relied exclusively on data from participants in these quartiles (N = 86).  <br/><br/>
- Deviation variable: Mean absolute distance from the standard IADS norm ratings –  mean_dis. This variable is meant to represent subjects’ tendency (or lack thereof) to deviate from the norm in perception of emotional valence. Mean absolute distance from norm ratings of emotional stimuli has been used in previous literature to represent this construct (Lazarov et al., 2020). 



### Analysis (C)
see part_5_analysis.R <br/><br/>
c1) 
I conducted a logistic regression examining the effects of OCI-R, DASS-anxiety and DASS-depression scores on mean reported emotional valence in response to emotional audio stimuli. The dependent variable was coded as 0 = positive mean valence, 1 = negative mean valence. No evidence for any of the effects was found. 
 <br/><br/>
A linear regression was conducted in order to examine the effects of OCI-R, DASS-anxiety and DASS-depression scores on mean absolute distance from norm valence ratings. Prior to the analysis, I scaled the variables (see part4_additional_processing.R) in order to receive more intuitively interpretable coefficients. R2 for the model was _. No evidence was found for the effects of symptoms of anxiety or depression. However, a positive effect of obsessive compulsive symptoms was found ().  
<br/><br/>

c2) 
The logistic regression provided no evidence of effects of OC, anxiety, or depression symptoms on the emotional valence. This means that I found no evidence showing that an increase in any of the symptoms of interest increases the odds of reporting negative valence during exposure to emotional audio stimuli. Moreover, the non-significant estimates were miniscule. It should be noted the model was weak (AUC = 0.6). 

However, I did find evidence that a unit increase in OC symptoms leads to a _ units increase in deviation from norm ratings of emotional valence, reported while listening to emotional sounds. Albeit, the analysis yielded no evidence that symptoms of depression or anxiety relate in any way to a deviation from norm ratings. One interpretation of the effect of OC symptoms can be that OC symptoms are related to a deviation from norms in terms of truly felt emotional valence. An alternative explanation might arise from the Seeking Proxies for Internal States theory. The theory posits that obsessions and compulsions derive from a difficulty in accessing internal states, which includes emotional states, and has received empirical support (Liberman et al., 2023). Drawing from this theory, perhaps OC symptoms are not related to a tendency to truly experience emotional stimuli differently, but to a difficulty in realizing what you feel, resulting in less accurate reports. The idea that OCD relates to worse emotional valence recognition has support in the existing literature (Lazarov et al., 2020).  


This might be surprising in light of previous findings, 

<br/><br/>


 
c3) 



**A** <br/><br/>

**B** <br/><br/>

**C** <br/><br/>

Figure _. Illustrating the linear regression where (A) OC, (B) anxiety, and (C) depression symptoms served as predictors of emotional valence categories (0 - positive, 1 - negative). They did not significantly predict the outcome. 
<br/><br/>

<br/><br/> 

**A** <br/><br/>

**B** <br/><br/>

**C** <br/><br/>


Figure _.  (A) Illustrating that the higher OC symptoms are, the higher the deviation from norm valence ratings is. (B) Illustrating the non-significant relationship between anxiety symptoms and the deviation from norm valence ratings.  (C) Illustrating the non-significant relationship between depression symptoms and  the deviation from norm valence ratings.


c4) <br/><br/>
![image](https://github.com/user-attachments/assets/7b0f439f-d43a-44c8-a577-c838b13f5f42)

Figure _: ROC curve. 

### References 

Lazarov, A., Friedman, A., Comay, O., Liberman, N., & Dar, R. (2020). Obsessive-compulsive symptoms are related to reduced awareness of emotional valence. Journal of Affective Disorders, 272, 28–37. https://doi.org/10.1016/j.jad.2020.03.129

Liberman, N., Lazarov, A., & Dar, R. (2023). Obsessive-Compulsive Disorder: The Underlying Role of Diminished Access to Internal States. Current Directions in Psychological Science. https://doi.org/10.1177/09637214221128560

