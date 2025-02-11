# Learn functional programming by building tic-tac-toe in Elm

[Start here](https://ellie-app.com/tBPjVj9q4Fna1)

You can find the completed game [here](https://ellie-app.com/tBPqQ7YDykka1).

## Introduction

This is a short introduction to functional programming aimed at students who are already somewhat familiar with
programming already (perhaps in another paradigm).

### What is functional programming?

I don't want to spend much time on theory. And "functional programming" is notoriously hard to define.

"I can only approach you by particular examples and let you infer what it is" (Richard Hamming)

I will use the "toolbox" as defined by Eric Normand in Grokking Simplicity:

1. Actions, Calculations, and Data
2. Higher-order functions
   * `filter`
   * `map`
   * `reduce`

### What is Elm?

A strongly-typed, functional programming language for web applications. It compiles to Javascript to run in a web browser.

#### Elm syntax

This can be demonstrated in a repl.

```elm
5 + 3
```

You can read the result as "8 which has the type of number".

Elm programs are a set of definitions that look (and you can accurately think of them ...) like equations.
For example:

```elm
myValue = 42
```

This defines a name, "myValue". This is sometimes called a binding. The value 42 is now bound to the name, "myValue".

Functions are defined in the same way. For example,

```elm
greet name =
    "Hello, " ++ name
```

This defines a function called, "greet" that takes a single argument called "name". Calling this function looks like this:

```elm
greet "James"
```

That's all the syntax we need to get started. I'll introduce more to you as we need it to build the tic-tac-toe game.

### Producing HTML

In the starting template you will see a binding called "main". This is the program entry point. All it does at the moment
is call the `text` function. This function was imported from a module called `html`. Let's have a look at the documentation
for this module to find out what else it can help us with. Eventually, let't try to draw the grid (using the supplied CSS
rules).

```elm
div [ class "board" ]
    [ div [ class "cell" ] []
    , div [ class "cell" ] []
    , div [ class "cell" ] []
    , div [ class "cell" ] []
    , div [ class "cell" ] []
    , div [ class "cell" ] []
    , div [ class "cell" ] []
    , div [ class "cell" ] []
    , div [ class "cell" ] []
    ]
```

## Interactivity

### The Elm Architecture

Go to [this website](https://guide.elm-lang.org/architecture/).

The Elm architecture consists of 3 parts:
1. The view. You have already built the basic view.
2. The model. This is a representation of the current state of your program. It it _immutable_.
3. The `update` function. This is a function that creates a new state representation when an action happens (e.g. a mouse click).

We can use the `sandbox` function to tie all of these together. First, rename the `main` definition you already have to `view`. Then
you can write a main that looks like this:

```elm
main =
  Browser.sandbox
    { init = 1 -- just a placeholder for now. This is where you initialize your model.
    , view = always view
    , update = always identity
    }
```

So what are the `always` and `identity` functions? These are functions that you might consider useless. You can define them in
$favourite language like so:

```javascript
function always(a, b) {
  return a;
}

function identity(a) {
  return a;
}
```

`always` always returns its first argument, and `identity` just returns its argument without doing anything to it. We use them here
because `view` should be a function that accepts a model argument but our `view` takes no arguments. `always view` makes it line up:
the model argument is discarded. The `update` function is expected to accept 2 arguments: some action that triggered it (called a
message in Elm), and the "old" model (which you generally use to build the new model).

### What's next?

At this point the program should do the same as what it did with just a view function. Now let's start trying to model the domain
so that we have something to change (or we can quickly draw the number and update that as a counter to make sure everything is working).

### Domain Modeling

{{0}}What do we need to represent?
- Naughts and crosses in a 3x3 grid.
- The current player naught or cross.
- A player (O|X)
- Whether the game is ongoing, someone has won, or there was a tie.

{{1}}Options for representing the grid:
- List ?
- List (List ?)
- Array ?
- Record ?
- Tuple (Tuple ? ? ?) (Tuple ? ? ?) (Tuple ? ? ?)

{{2}}Why pick one representation over the others?
- Ease of working with it
- Correctness

!?["Make impossible states impossible"](https://youtu.be/IcgmSRJHu_8)

#### Types

{{0}} Sum types: either this or that, not both. Number of possible values is the _sum_ of the variants. e.g. `Maybe`

```elm
type Player = O | X  -- There are 2 possible states from 2 constructors
```

{{1}} Product types: collections of values, records, tuples. Number of possible values is the _product_ of the entries. e.g. `Tuple`

```elm
type alias Row = (Player, Player, Player) -- A three-tuple of Player s. There are 8 possible states
```

{{2}}For now it doesn't matter too much wat we pick. It's very easy to come back and change the representation later if we decide we've made a mistake.

#### Rendering the model

Now it's time to modify the `view` function so that it reacts to the model.

Once you do this, set up init and make changes, reload, and convince yourself that `view` is correct.

Then, **finally** you can add `onClick Msg` to each cell.

#### React to clicks

Write the `update` function.


### Finishing the game

Detect the winner or a tie. Decide what to display in win or tie.


### Extensions

1. Add a "new game" button.
2. Add "undo" and "redo".
3. Implement a computer controlled opponent.
4. Add a win streak scoreboard.
5. Add a countdown timer for each turn.
6. Alternative board sizes (3x3, 4x4 or 5x5).
