# Show 10

![](https://is1-ssl.mzstatic.com/image/thumb/Purple211/v4/26/cf/83/26cf839d-d9b6-e541-2590-60b4f5ef3d2b/AppIcon-0-0-1x_U007emarketing-0-11-0-85-220.png/1200x630wa.png)

A Swift app designed for iPhone that shows 10 restaurants nearby given a UK postcode using the Just Eat API.

## Getting Started

You will need Xcode to run this app on your local machine. The app was developed using Xcode 16.2 on a Macbook Pro running macOS 15.3.2.

### Prerequisites

You will need the following things to run the application:

- Xcode running on a Mac
- Internet connection
- **[Optional]** Test iOS device

You will then need to:

1. Clone the repository to your local machine
2. Open the repository in Xcode

### Installing

1. Select either a test iOS device as the build target or generic iOS device (eg. iPhone 16)
2. Build the app using the ► button in the top of Xcode

The app should load onto the build device for you to use.

## Using the app

To use the app, simply open the application on your iOS device, choose whether you want the first 10 results of the API or the closest 10 results to the postcode, type in a UK postcode to the search field. Push the magnifying glass and if the API finds results, you will be taken to the 10 restauranst.

## Future Work

There are many improvements I've been unable to complete yet due to limited time or knowledge.

### Re-enter postcode for new results

My original vision for the app involved having both a TextField and the back button in the PostcodeSearchBar in ResultsView. This could allow users to retype the entered postcode and immediately get taken to the new results instead of returning to the PostcodeEntry view.

However, in development it became clear there wasn't a reliable way to get the Map to update without completely redrawing it or using MKCoordinateRegion and creating a cameraView but I haven't worked with that before and wasn't comfortable exploring this in the limited time. I therefore adapted the PostcodeSearchBar to morph into a back button forcing users to search for postcodes one at a time.

### API results questions

When the API is queried with a postcode, it returns a large amount of restaurants around that area in (seemingly) no particular order. Therefore I was unsure whether to build the app to get strictly the 'first' 10 results from the API or sort the results and get the closest in driving terms to the postcode.

In order to stay safe, I added a toggle for the user. By default strictly the first 10 results the API responds with are listed. But the user can switch to get the closeset 10 if preferred.

In the future, further clarification of the purporse of the app could remove this toggle completely simplifying the app.

### Cuisine Tags

My original vision for the app had the individual cuisine tags wrap around the restaurant container limitlessly. I knew I had to prepare a design that worked for an unlimited amount of cuisines of an undefined character limit and felt this wrap design worked best.

However, in development I found there wasn't an easy way to do this nateively in Swift. My research led me to FlowLayout but I didn't feel confident trying this for the first time in this app. Therefore, I implimented a simple ScrollView to hold the tags. This allows all tags to show no matter the cuisine string lenght nor amount of cuisines per restauaant.

The only downside is that now the user has two different horizontally scrolling UI views. A TabView holding restauarnats and a ScrollView on each restaruarnt for the cuisines.

I attempted using .rotationEffect() on the TabView and then rotating individual restaurants to produce a veritcally scrolling restaurrant with horizontally scrolling cuisines. But because this is 'faking' the verticality, when you scroll to the end of a Cuisine ScrollView the TabView would move with the residual force of the scroll which felt wrong.

Given more time, I could redesign the restuarant container or look into FlowLayout to get a permanant solution.

## Bugs

### Z-Index Annotations
There seems to be no easy way to give the map annotations a Z-Index value or group annotations if they will be 'collide'. As a result, the numbered placemenet tags on the map sometimes occlude each other. If a user swipes through the restaurant cards, the selected restauarrnt's annotation is enlarged but sometimes remains occluded behind other annotations. However, if a directly user taps on an map annotation, the larger annotation is drawn and it does consistenetly comes to the front. Only swiping through the cards has this problem on the map.

Further investigation is needed to find a work around this.

### Linear Gradient Animation
The animated background of PostcodeEntry uses some of the JET-recommended brand colors to produce a modern animated background but it seems to stutter for a second upon first-load of the app.

I know it's possible to preload animations, this could improve performance but I don't have the experience yet to do this so haven't implimented here. Alternatively, I could render the background as a video and compare performance of having a video background instead. This would, of course, increase the size of the app.

## Acknowledgments

**Maria Harris (Early Careers Lead @ JET)** - For responding quickly to my questions.
**[Just Eat Brand Box](https://brand-box.marketing.just-eat.com "Just Eat Brand Box")** - For providing the Just Eat color hex values and general brand guidance.
**Just Eat Takeaway** - For providing the API used for search queries & app logo.