module Navbar exposing (Model, Msg, init, subscriptions, update, view)

import Book.Ports as Ports
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)


main : Program Model Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { title : String
    , themes : List String
    }


init : Model -> ( Model, Cmd Msg )
init initialModel =
    ( initialModel, Cmd.none )


type Msg
    = NoOp
    | ForwardSidebarMsg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        ForwardSidebarMsg ->
            ( model, Ports.forwardSidebarRequest () )


view : Model -> Html Msg
view model =
    nav
        [ class "navbar"
        , style "position" "fixed"
        , style "top" "0"
        , style "width" "100%"
        ]
        [ div
            [ class "navbar-brand" ]
            -- themes and search goes here
            [ a [ class "navbar-item book-title" ] [ text model.title ]
            ]
        ]


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


