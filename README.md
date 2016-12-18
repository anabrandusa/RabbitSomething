# rabbitGUI

## A Graphical User Interface (GUI) to Visualize Genomic Classifiers 

**rabbitGUI** is a friendly user interface for the visual analysis of biomarkers in transcriptomic data with [Rabbit](https://github.com/jperezrogers/rabbit). The biomarker statistics are represented using density, Area Under the Receiver Operator Curve (ROC AUC) and box and whiskers plots. rabbitGUI is developed in **R**, and requires R to be installed.

To run rabbitGUI, first install the latest available version of the following R packages:

* shiny
* DT
* pROC
* ROCR
* markdown
* gplots

Then, execute the file *runRabbit.bat*.

rabbitGUI consists of two main panels. The first panel (*Prediction Scores*) shows the biomarker classification models sorted by Area Under the Curve (AUC) in descending order. These models can be selected by AUC order (*Model combination*) or by label (*Model description*).

![Prediction Scores](images/prediction_scores.png)

*Prediction Scores* consists of two plots: the distribution of test samples per prediction score and the Area Under the Receiver Operator Curve (ROC AUC) of the selected classification model.

| Density plot | ROC plot |
| ------------ | -------- |
| ![Density plot](images/density.png)|![ROC plot](images/roc.png)|

The second panel (*Model selection*) displays a classification of the models according to each feature. 
![Prediction Scores](images/model_selection.png)
*Model selection* contains a box and whiskers plot on the mean Area Under the Curve (AUC) of all models. In this plot, the best groups of models (i.e., those that there does not exist any significantly better model) are highlighted in red.
![Box and whiskers plot](images/boxplot.png)
Below, two tables with the statistics of the selected model classification (top) and the results from the Tukey test used to discriminate the best groups (bottom) are included.
![Summary table](images/summary.png)
![Tukey table](images/tukey.png)
