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
- when splitting update function by fields (like in the redux examples) we loose
check for unused message types
