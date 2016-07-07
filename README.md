These files are a part of the Kaggle competition conducted as a part of MIT's MOOC - Analytics Edge 2016.

It is based on the data of users of Show of Hands, an informal polling platform in US. This polling platform for use on mobile devices and the web, to see what aspects and characteristics of people's lives predict how they will be voting for the presidential election.
It is a binary classification problem with total 108 variables. The dependent variable is Party variable with two responses, "Democrat" and "Republican".

The challenges faced while solving this problem is to treat missing values as almost 40% of the values are missing in this dataset, and identifying the useful variables which might help in classifying the result.

Interpretation of the question can be broke down in really classifying result into a liberal and conservative, where liberal will incline towards Democrats and conservative towards Republican.

A lot of questions (variables) can intuitively be selected from the list based on the judgement on the responses of the people on certain questions.

My best result was obtained using random forest library with 5 fold cross validation on the training data set. I have imputed all the missing value after converting the data into a model matrix.

All the variables selected to create the model were based on intuition and the common knowledge of the US politics.
