`elm-live Main.elm --output elm.js --open --pushstate`


## Lessons learned
- functional way of removing element by index:  
`[
        ...state.messages.slice(0, action.index),
        ...state.messages.slice(
          action.index + 1, state.messages.length
        )
]`  
vs  
`
(List.take index model.messages) ++ (List.drop (index + 1) model.messages)
`  
- When splitting update function by fields (like in the redux examples) we loose
check for unused message types
- I prefer update function split by message over split by model field (redux like reducer composition)
- In Redux we have container and presentational components and some container components subscribe to store changes
- In Elm it's much simpler. Top level view that we plug into main function always gets full model and we decide
how much of the model we pass down to helper view functions (as function arguments)
- When should records used as input params be type aliased?
