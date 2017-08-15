# Research Plan    

Authors: Dan Hahn and Andrew Nguyen

Start Date: 2017-08-14   
End Date/Last Modified:    

### Objectives   

* Characterize the functional diversity in seasonal timing patterns that lead to incipient speciation.  

### Questions:  
* How do different races of Rhagoletis shift their seasonal timing? 
* How do parasitoids match their phenological strategies with rhagoletis? 

### Hypotheses and Predictions:    

1. Different races of Rhagoletis modulate their intrinsic activity patterns to match seasonal ones.   
	* Circadian rhythms should postively match the ability to exit diapause and diapause depth.   
		* Amplitude or Tau  to rep circ rhythm, but data could be messy, consider area under curve? 
	* 
2. Parasitoids shift their activity patterns alongside their host of different Rhagoletis faces.   
	* positive relationship in Tau, or amplitude

### Experimental approach : 

To estimate circadian rhtyms, daily activities follow a wave and the curve will be summarized by the maximum activity (amplitude) and distance of the max activity (Tau, free run period).  Activity patterns themselves will be measured with a trikinetics system:  

1. Collect apples and haws, acclimate for 1 month? 
2. Put in fridge (4C) to induce diapause for 4 months. 


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

**There is an offset between race and apple such that apples are just overall higher in diapause duration and tau.** 

red line is apple 

![](https://user-images.githubusercontent.com/4654474/29323684-a1ac20f4-81af-11e7-959e-b91af5250053.png)



### Potential Conclusions:    



