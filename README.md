# Untoxicated
## [![Watch the video](https://img.youtube.com/vi/eidr7eI99AQ/0.jpg)](https://youtu.be/eidr7eI99AQ)
# Inspiration
As soon to be college students, we remembered how alcohol and drugs typically tend to be major parts of our next adventures. Although they serve as social lubricants, they can also be incredibly dangerous as decision making becomes hindered. Even though we all have grown up learning to never drink and drive, incidents still occur as people don't think straight while drunk. We wanted to help combat this issue by creating resistance for drunk driving while also making it easier for the user to have a third party explain that they are not in fit condition. 

## What it does
Untoxicated allows intoxicated individuals to test just how drunk they are. After three unique, intensive, sobriety tests, the app will declare the user as drunk or not. Our first test will check the user's ability to perceive the passage of time. Intoxication often results in skewed time perception, therefore, by asking our users to estimate a certain amount of time, we can see if their perception is accurate or couple be skewed due to alcohol. Our second test will ask the user to spin around three times, making them dizzy, and then using EchoAR they will need to find an object randomly placed near them, and then name the object out loud. Using NLP Speech Recognition, we will be able to determine whether the user accurately named the object or may be under the influence. Our final test uses Apple's CoreML Machine Learning framework to see if the user's pupil is dilated. If the user fails these tests and is strongly under the influence, Untoxicatied will notify them to contact a friend helping deter risky behavior after alcohol consumption.  We would like users to eventually instinctually open the app after any night out to ensure they check take a moment, pause, and check themselves to be of sound mind.

## How we built it
The framework for our iOS application was built in Xcode using Swift. In order to fulfill the different sobriety tests that we created, we implemented a speech recognition library to handle the main NLP analysis. On top of this, we trained and tested our own pupil dilation machine learning model using CoreML, surpassing our expectations on the tests that we ran.

## Challenges we ran into
One of the largest challenges we ran into was resizing and randomly generating a location for our EchoAR nodes in one of our tests. Figuring out SCNMatrices, ARSCNViews, and reviewing matrix multiplication was time-intensive, but thanks to StackOverflow and the EchoAR slack support channel, we were able to tinker around with our code to fit our needs.

## Accomplishments that we're proud of
We are most notably proud of our EchoAR experience working together with NLP (natural language processing) to see how well our drunk user can quickly identify objects. In addition, we are proud of our ability to use Machine Learning via a CoreML model that classifies whether pupil dilation is present. We are also rather proud of our timeless minimal UI which we believe will allow any user of any technological proficiency to make use of our app.

## What we learned
We learned a lot about time management and how to quickly break up a complex idea into actionable and accountable segments. We also had quite a bit of fun exploring various iOS frameworks such as CoreML and EchoAR. We also analyzed and learned about various design mockups before adopting the minimalist style you see in our final product.

## What's next for Untoxicated
First and foremost, we would also love to continue improving the quality/quantity of our tests. Whether it be a gyroscopic test to see if the user can walk in a straight line, simply adding more objects in our dizzy object detection test, or bettering our machine learning model for pupil dilation detection, the more we improve our tests, the more accurate our provided answer to just how drunk our users are. Next, we would love to implement engine deterrence using an iPhone's microphone in conjunction with a partner accountability system.  In November 2017, MIT researchers wrote up a paper titled "Air filter particulate loading detection using smartphone audio and optimized ensemble classification". The paper cited previous work that shows neural networks to be able to use microphone sound and display engine troubles with an accuracy exceeding 95%. Our team would like to dumb this technology down to listen for an engine running and further hinder the user from driving home alone. Rather they should coordinate with a trusted contact who has a one-time password that they will only give to the drunk user when they know a safe method of transportation has been arranged. 
