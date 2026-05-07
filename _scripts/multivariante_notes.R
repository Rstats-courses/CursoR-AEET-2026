#This scripts introduce multivariate analysis

library(vegan)
library(mvabund)
#install.packages(gllvm)
library("gllvm")

#PCA----
data(iris)
head(iris)

#prepare and explore the data
ir <- iris[, 1:4]
ir_species <- iris[, 5]
pairs(ir)
cor(ir)
#run pca
#princomp
pca <- prcomp(ir, center = TRUE,
                 scale. = TRUE)
pca
summary(pca)
plot(pca, type = "l")
biplot(pca)
#or nicer:
#library(devtools)
#install_github("vqv/ggbiplot")
library(ggbiplot)
g <- ggbiplot(pca, obs.scale = 1, var.scale = 1,
              groups = ir_species, ellipse = TRUE,
              circle = TRUE)
g <- g + scale_color_discrete(name = '')
g <- g + theme(legend.direction = 'horizontal',
               legend.position = 'top')
print(g)
#more tricks
predict(pca, newdata=(tail(ir, 2)))

#NMDS and PERMANOVA----
#The data
Herb <- read.csv(file = "data/Herbivore_specialisation.csv", header = TRUE, row.names = 1)
head(Herb)

#Get the community matrix
library(reshape2)
Herbivores <- dcast(data = Herb, formula = Habitat + DayNight + Replicate + Mass ~ species,
                    fun.aggregate = sum, value.var = "abundance")
head(Herbivores)

#simplify objects to use
Habitat <- Herbivores$Habitat
DayNight <- Herbivores$DayNight
Herb_community <- Herbivores[,5:11]

#The basic is the distance measure you use:
#distance selection!----
?dist
?vegdist
?betadiver

test1 <- c(2,4,8)
test2 <- c(4,8,16)
test3 <- c(20,40,80)
test4 <- c(40,80,160)

comm <- rbind(test1, test2, test3, test4)

vegdist(comm, method = "bray")
vegdist(comm, method = "morisita")
vegdist(comm, method = "horn")
vegdist(comm, method = "kulczynski")

#NMDS
Herb_community.mds <- metaMDS(comm = Herb_community,
                              distance = "bray",
                              trace = FALSE, autotransform = FALSE)
Habitat <- as.factor(Habitat)
plot(Herb_community.mds$points, col = Habitat, pch = 16)

plot(Herb_community.mds$points, col = Habitat, pch = 16)
Habitat.uni <- unique(Habitat)
legend(x = -2.5, y = -1.5, Habitat.uni, pch=16, col = 1:5, cex = 0.8)

DayNight <- as.factor(DayNight)
plot(Herb_community.mds$points, col = DayNight, pch = 16)
legend(x = -2.5, y = -1.5, c("Day","Night"), pch=16, col = 1:5, cex = 0.8)

#assumptions:
Herb_community.mds$stress

#If the stress value is greater than 0.2, it is advisable to include an
#additional dimension, but remember that human brains are not very well
#equipped to visualise objects in more than 2-dimensions.

#Transformation and standardisation. Transforming data sets prior to
#creating a MDS plot is often desirable, not to meet assumptions of normality,
#but to reduce the influence of extreme values. For example,

Herb_community.sq <- sqrt(Herb_community)
Herb_community.sq.mds <- metaMDS(comm = Herb_community.sq,
                                 distance = "bray", trace = FALSE)
plot(Herb_community.sq.mds$points, col = Habitat, pch = 16)

#alternative plot
ordiplot(Herb_community.mds,type="n")
ordihull(Herb_community.mds,groups=Habitat,draw="polygon",col="grey90",
         label=FALSE)
orditorp(Herb_community.mds,display="species",col="red",air=0.01)

#Testing hypothesis PERMANOVA----
#First test: Are centroids different?
adonis2(Herb_community ~ Habitat, method = "bray")
adonis2(Herb_community ~ DayNight, method = "bray")

adonis2(Herb_community ~ Habitat + DayNight, method = "bray", by = "terms") #by evaluates all predictors sequentially.
adonis2(Herb_community ~ Habitat + DayNight, method = "bray", by = "margin") #by evaluates all predictors simulateously.
adonis2(Herb_community ~ Habitat + DayNight, method = "bray", by = "onedf") #or factors of all predictors

#you can explore parameter `strata` to constrain the groups on which the permutations are performed.
#you can think of this as adding a random factor.

#Second test: Is the spread different?
b <- betadisper(vegdist(Herb_community, method = "bray"), group = Habitat)
anova(b)
boxplot(b)
TukeyHSD(b)

b <- betadisper(vegdist(Herb_community, method = "bray"), group = DayNight)
anova(b)
boxplot(b)
TukeyHSD(b)

#The modern approach:
#There are a couple of problems with these kinds of analysis.
#First, their statistical power is very low, except for variables
#with high variance. This means that for variables which are less
#variable, the analyses are less likely to detect a treatment effect.
#Second, they do not account for a very important property of
#multivariate data, which is the mean-variance relationship.
#Typically, in multivariate datasets like species-abundance data
#sets, counts for rare species will have many zeros with little
#variance, and the higher counts for more abundant species will
#be more variable.

#The mvabund approach improves power across a range of species
#with different variances and includes an assumption of a mean-variance
#relationship. It does this by fitting a single generalised linear
#model (GLM) to each response variable with a common set of predictor
#variables. We can then use resampling to test for significant community
#level or species level responses to our predictors.

#mvabund way----
#create a mvabund object (similar to a data.frame)
Herb_spp <- mvabund(Herbivores[,5:11])
#explore data
boxplot(Herbivores[,5:11],horizontal = TRUE,las=2, main="Abundance")
meanvar.plot(Herb_spp, xlab = "mean", ylab = "variance")

#model ALL species at once fitting many GLM's that share error structure.
mod1 <- manyglm(Herb_spp ~ Herbivores$Habitat, family="poisson")
#check assumptions
plot(mod1)
#refit
mod2 <- manyglm(Herb_spp ~ Herbivores$Habitat, family="negative_binomial")
plot(mod2)
#test
anova(mod2) #slow
#See which species differ where
anova(mod2, p.uni="adjusted")
#Allows for model complexity
mod3 <- manyglm(Herb_spp ~ Herbivores$Habitat*Herbivores$DayNight,
                family="negative_binomial")
anova(mod3)

#gllvm-----

#more flexible:
fitp <- gllvm(y = Herb_community, family = poisson(), num.lv = 2)
fitnb <- gllvm(y = Herb_community, family = "negative.binomial", num.lv = 2)
par(mfrow = c(1,2))
plot(fitp, which = 2:3)
plot(fitnb, which = 2:3)
AIC(fitp)
AIC(fitnb)
par(mfrow = c(1,1))

coef(fitnb) #Phi is the overdispersion parameters for model checking.
confint(fitnb)
ordiplot.gllvm(fitnb, s.colors = as.numeric(as.factor(Habitat)),
         symbols = T)

fitnb <- gllvm(y = Herb_community, X = data.frame(Habitat, DayNight), family = "negative.binomial", num.lv = 2)
par(mfrow = c(1,2))
plot(fitnb, which = 2:3)
par(mfrow = c(1,1))
coef(fitnb)
coefplot.gllvm(fitnb, cex.ylab = 0.7, mar = c(4, 9, 2, 1), mfrow=c(2,3),
         xlim.list = list(c(-10,10), c(-10,10), c(-10,10), c(-10,10), c(-2,2)))


