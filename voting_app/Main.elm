module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random


type alias Model =
    { products : List Product
    }


type alias Product =
    { id : Int
    , title : String
    , description : String
    , url : String
    , votes : Int
    , submitter_avatar_url : String
    , product_image_url : String
    }


type Msg
    = UpVote Int
    | RandomVotes (List Int)


init : ( Model, Cmd Msg )
init =
    ( { products =
            [ { id = 1
              , title = "Yellow Pail"
              , description = "On-demand sand castle construction expertise."
              , url = "#"
              , votes = 0
              , submitter_avatar_url = "images/avatars/daniel.jpg"
              , product_image_url = "images/products/image-aqua.png"
              }
            , { id = 2
              , title = "Supermajority: The Fantasy Congress League"
              , description = "Earn points when your favorite politicians pass legislation."
              , url = "#"
              , votes = 0
              , submitter_avatar_url = "images/avatars/kristy.png"
              , product_image_url = "images/products/image-rose.png"
              }
            , { id = 3
              , title = "Tinfoild: Tailored tinfoil hats"
              , description = "We already have your measurements and shipping address."
              , url = "#"
              , votes = 0
              , submitter_avatar_url = "images/avatars/veronika.jpg"
              , product_image_url = "images/products/image-steel.png"
              }
            , { id = 4
              , title = "Haught or Naught"
              , description = "High-minded or absent-minded? You decide."
              , url = "#"
              , votes = 0
              , submitter_avatar_url = "images/avatars/molly.png"
              , product_image_url = "images/products/image-yellow.png"
              }
            ]
      }
    , Random.generate RandomVotes (Random.list 4 (Random.int 15 65))
    )


view : Model -> Html Msg
view model =
    productList model


productList : Model -> Html Msg
productList model =
    div [ class "ui items" ]
        (List.map
            product
            model.products
        )


product : Product -> Html Msg
product info =
    div [ class "item" ]
        [ div [ class "image" ]
            [ img [ src info.product_image_url ] [] ]
        , div [ class "middle aligned content" ]
            [ div [ class "ui grid" ]
                [ div [ class "three wide column" ]
                    [ div [ class "ui basic center aligned segment" ]
                        [ a [ onClick (UpVote info.id) ]
                            [ i [ class "large caret up icon" ]
                                []
                            ]
                        , p []
                            [ b [] [ text (toString info.votes) ] ]
                        ]
                    ]
                , div [ class "twelve wide column" ]
                    [ div [ class "header" ]
                        [ a [ href info.url ]
                            [ text info.title ]
                        ]
                    , div [ class "meta" ] [ span [] [] ]
                    , div [ class "description" ] [ p [] [ text info.description ] ]
                    , div [ class "extra" ]
                        [ span [] [ text "Submitted by:" ]
                        , img [ class "ui avatar image", src info.submitter_avatar_url ] []
                        ]
                    ]
                ]
            ]
        ]


productComparison : Product -> Product -> Order
productComparison a b =
    if a.votes < b.votes then
        GT
    else if a.votes > b.votes then
        LT
    else
        EQ


sortProducts : List Product -> List Product
sortProducts products =
    List.sortWith productComparison products


upvoteProduct : Int -> Product -> Product
upvoteProduct id product =
    if product.id == id then
        { product | votes = product.votes + 1 }
    else
        product


upvote : List Product -> Int -> List Product
upvote products id =
    List.map (upvoteProduct id) products


assignVotes : List Product -> List Int -> List Product
assignVotes products votes =
    List.map2 (\product voteCount -> { product | votes = voteCount }) products votes


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpVote id ->
            ( { model | products = (upvote model.products id) |> sortProducts }, Cmd.none )

        RandomVotes votes ->
            ( { model | products = (assignVotes model.products votes) |> sortProducts }, Cmd.none )


main : Program Never Model Msg
main =
    Html.program
        { view = view, init = init, update = update, subscriptions = (\_ -> Sub.none) }
