# R course final assignment: Summarizing Doc

###The Dataset (A1)
This is a dataset from an experiment testing perception of emotional valence during exposure to emotional audio stimuli. 200 Online participants from the UK rated how they felt while listening to 60 emotional sound effects on SAM scales, 9-point likert scales with emoticons expressing valence, ranging from 1 (very negative) to 9 (very positive). The sound effects were taken from the International Affective Digitized Sounds (IADS) system, and all have norm valence ratings. They also completed two questionnaires: The OCI-R – Obsessive Compulsive Inventory Revised: An 18-items questionnaire measuring obsessive compulsive symptoms; and the DASS-21 anxiety and depression subscales.
I chose to work on this dataset because I collaborated on the experiment as a research assistant to Prof. Ruvi Dar. I was both interested in how emotion and emotion recognition are affected by symptoms of OCD, depression and anxiety, and concluded that this assignment can be a good opportunity to do exploratory work on our data. 

### Data Processing (B2, B3)
See part1_data_processing.R.
In this script, I processed the collected data into a dataset that’s ready for exploratory work and analysis.  
I excluded irrelevant data (like metadata automatically added by qualtrics) by selecting only relevant columns.
I did some cleaning and adjustments for clarity and precision.
I unified the experiment data and the demographic data.
I calculated the distances between participants’ valence ratings and the IADS standard ratings. I used a function I wrote (B3 – see function in part2_function.R).
I calculated OCI-R, DASS-anxiety, and DASS-depression scores.
I calculated means and variances of both the valence ratings and the distances. 
I created a measure of the rate of responses that were   
I filtered out responses from participants who failed attention checks. There were two attention checks for the sounds, where participants were asked to mark a certain number on the SAM scale; And each questionnaire included two infrequency items – nonsensical items meant to detect inattentive responders.

### Exploratory Presentation of the Data (A2)
See part3_exploratory_visualization.R.





### The Research Question (A3)
Are symptoms of OCD, depression or anxiety related to the reported emotional valence felt during exposure to emotional audio stimuli, and to the degree to which individuals deviate from norms in their reports? 

### The Variables (B1)

- Obsessive compulsive symptoms – OCI_R: The score in the OCI-R questionnaire. <br/><br/>
- Anxiety symptoms – DASS_anxiety: The score in the DASS anxiety subset. <br/><br/>
- Depression symptoms – DASS_depression: The score in the DASS depression subset. <br/><br/>
- Mean reported valence – mean_valence: The mean of each subject's valence ratings across all 60 emotional sound stimuli. <br/><br/>
- High/low mean absolute distance from the standard IADS ratings. This variable is meant to represent subjects’ tendency (or lack thereof) to deviate from the norm in perception of emotional valence. Mean absolute distance from norm ratings of emotional stimuli has been used in previous literature to represnt this construct (Lazarov et al., 2020. Across all stimuli, subjects in the high group (coded 1) gave ratings that are further from the IADS standards than subjects in the low group (coded 0). <br/><br/>
Initially, I intended to create a binary measure of the tendency to deviate from the standard rating based on the rate of extreme responses across all stimuli. An extreme response was defined as an absolute distance larger than the mean + sd of all absolute distances from the relevant sound’s norm rating. However, after the exploratory examination of the data I concluded that any cutoff score I could choose for the rate of extreme responses would be arbitrary and not very meaningful. I was also concerned about losing information in the process of giving each response a binary extreme/non-extreme label. <br/><br/>
Therefore, I decided on an alternative approach (see part4_additional_processing.R). I divided the sample into 4 mean distance quartiles. I then selected the bottom mean distance quartile as the low mean distance group, and the top quartile as the high mean distance group. The logistic regression relied exclusively  on data from participants in these categories (N = 86).    


### Analysis (C)
c1) 
# Analysis (C)
c1) A linear regression was conducted in order to examine the effects of obsessive compulsive, anxiety, and depression symptoms on reported emotional valence in response to emotional stimuli. R2 for the model was _. No evidence for any of the effects was found. <br/><br/>
I also conducted a logistic regression examining the effects of obsessive compulsive, anxiety, and depression symptoms on deviation from norm valence ratings. No evidence was found for effects of anxiety or depression. However, a positive effect of obsessive compulsive was found ()<br/><br/>
c2) 
It should be noted that while OC symptoms significantly predicted high mean distance from norm ratings, the coefficient was very small (0.06), odds ratio was not much larger than one, and the model was weak (AUC = 0.6).
 
c3) 

It should be noted that while OC symptoms significantly predicted high mean distance from norm ratings, the coefficient was very small (0.06), odds ratio was not much larger than one, and the model was weak (AUC = 0.6).
 
c3) 
