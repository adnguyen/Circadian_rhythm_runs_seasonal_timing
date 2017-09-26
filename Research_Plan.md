# Research Plan    

Authors: Dan Hahn and Andrew Nguyen

Start Date: 2017-08-14   
End Date/Last Modified: 2017-08-18   

### Objectives   

* Characterize the functional diversity in seasonal timing patterns that lead to incipient speciation.  Kylie was here!!!

### Questions:

* How do different races of Rhagoletis shift their seasonal timing? 
* How do parasitoids match their phenological strategies with rhagoletis? 

### Hypotheses and Predictions:    

1. Different races of Rhagoletis modulate their intrinsic activity patterns to match seasonal ones.   
  * Circadian rhythms should postively match the ability to exit diapause and diapause depth.   
    * Amplitude or Tau  to rep circ rhythm, but data could be messy, consider area under curve? 
  * ​
2. Parasitoids shift their activity patterns alongside their host Rhagoletis race.   
  * positive relationship in Tau, or amplitude

### Experimental approach : 

To estimate circadian rhtyms, daily activities follow a wave and the curve will be summarized by the maximum activity (amplitude) and distance of the max activity (Tau, free run period).  Activity patterns themselves will be measured with a trikinetics system:  

**Overall workflow-**

![](https://user-images.githubusercontent.com/4654474/29463033-3ec15cd2-83ff-11e7-991d-98b375744f44.png)



### Expected outcomes:   

**Diapause duration is positively related to tau.**   

![](https://user-images.githubusercontent.com/4654474/29323325-88e42040-81ae-11e7-8c1e-872f227cef13.png)

```R
tau<-seq(22,26,length.out=150)
diapause<-seq(20,150,length.out=150)

dat<-data.frame(tau,diapause)

dat$class<-c(rep("ND",50),rep("SD",50),rep("Long",50))

ggplot(dat,aes(x=jitter(tau,factor=100),y=jitter(diapause,factor=100)))+
  geom_point(aes(colour=class),size=10)+xlab("Tau")+ylab("Diapause Duration")+stat_smooth(method="lm",group=1,se=FALSE,colour="black")

```

The "classing" is intrinsic to the diapause duration, so probably unnecessary to show this. Probably shouldn't be classing based on 1 metric. It is better to class with a classification tree or discriminant analysis. 

**There is an offset between race and apple such that apples are just overall higher in diapause duration and tau.** 

red line is apple 

![](https://user-images.githubusercontent.com/4654474/29323684-a1ac20f4-81af-11e7-959e-b91af5250053.png)

**Wasps circ rhythm is positively related to maggot flies.**    

### Potential Conclusions:    



Thoughts: 

WOuld be interesting to investigate the relationship between short term and long term activity within a phylogenetic context. For example, taking 30-40 species of rhagoletis with 10-20 animal replicates and measuring diapause duration and circ rhythm.  


