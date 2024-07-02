# Device-Agnostic Design Course Project I - 41eaf3b5-4c52-4dfc-9c85-de4d00120fac

# Quiz App

Quiz App is a simple Quiz application written in Flutter. It lets users interact with a series of questions on a variety of topics retreived from a [quiz API](https://dad-quiz-api.deno.dev/) and displays persistent all-time statistics on the user's progress. Please keep in mind that the app is currently optimized for **mobile screen sizes only**. You can play with it [here](https://philipmuller.github.io/QuizApp/). 

## Key challenges

1. **Project organization**: as the complexity of the app kept growing, it was challenging to understand how to best organize the project.
2. **Dealing with futures in the UI**: while not a challenge in of itself, handling futures in the UI took some getting used to due to the significant wrapping necessitated by FutureBuilder.
3. **Efficient data transfer between screens**: passing data between screens using go_router involved some research. This obstacle was mostly self imposed, as the project only necessitated route variable usage, but I didn't like how the API wrapper felt when used that way and I needed more info on the topic for personal design decisions.

## Key learnings

1. **Writing the API wrapper**: this was the first challenge I tackled. I learned a lot thinking like a local API developer, trying to understand how to package the web API in the most ergonomic way for future development usage. In particular, I found it very interesting to think about object responsabilities. For instance, the initial approach to check if a question was answered correctly was built into the question object itself. Similarly, I thought the topic object could be responsible for getting a random question for that topic. This felt natural at the start, but I quickly realized that these objects should exist as pure data models. This handed the responsabilities back to Question Service.
2. **Dealing with state**: while state management with riverpod is not particularly complex, before tackling this project I didn't have a great feel for provider management. I didn't exactly know where providers should be placed in a project, since the course examples all worked with single widgets. Creating a more complex app with multiple state requirements gave me a better sense on how to handle providers and consumers and strenghtened my mental models.
3. **Component structure and organization**: one of the most fatiguing aspects of flutter is the significant widget nesting and boilerplate required. During the development, I got a much better sense on how to break down bigger widget trees into more managable pieces, both within a widget and into external widgets. The PageWrapper component was a particularly effective widget and showcased the power in flutter composability: when building links to the statistics page, it was trivially easy to apply that functionality to every screen.

## Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.2
  http: ^1.1.0
  flutter_riverpod: ^2.4.4
  google_fonts: ^6.1.0
  go_router: ^12.0.0
  shared_preferences: ^2.2.2
  pie_chart: ^5.3.2

dev_dependencies:
  flutter_test:
    sdk: flutter

  flutter_lints: ^2.0.0
  ```
