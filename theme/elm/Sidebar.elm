module Sidebar exposing (main)

import Book.Chapter as Chapter exposing (Chapter)
import Book.Ports as Ports
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode exposing (Value)


main : Program Value Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type Model
    = BadFlags
    | Loaded String (List Chapter) Bool


init : Value -> ( Model, Cmd Msg )
init json =
    let
        decoder =
            Decode.map2 (\a b -> Loaded a b True)
                (Decode.field "current" Decode.string)
                (Decode.field "chapters" <| Decode.list Chapter.decoder)
    in
    case json |> Decode.decodeValue decoder of
        Ok model ->
            ( model, Cmd.none )

        Err _ ->
            ( BadFlags, Cmd.none )



-- UPDATE


type Msg
    = NoOp
    | ChangeVisibility


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        ChangeVisibility ->
            ( model |> updateIfLoaded
            , Cmd.none
            )


updateIfLoaded : Model -> Model
updateIfLoaded model =
    case model of
        Loaded current chapters visible ->
            Loaded current chapters (not visible)

        _ ->
            model


-- VIEW


view : Model -> Html Msg
view model =
    case model of
        Loaded current chapters visible ->
            viewMenuList visible current chapters

        BadFlags ->
            aside
                []
                [ text << String.join "" <|
                    [ "Elm could not decode chapter data from mdBook output."
                    , "This is likely to be a bug of the theme. Please fill in an "
                    , "issue to theme's repository."
                    ]
                ]



viewMenuList : Bool -> String -> List Chapter -> Html msg
viewMenuList visible current chapters =
    let
        attrsByVisibility =
            if visible then
                [ class "" ]
            else
                [ attribute "aria-hidden" "true" ]

        merge =
            (++)
    in
    aside
        ( merge
            [ class "menu sidebar is-fullheight"
            , style "position" "fixed"
            ]
            attrsByVisibility
        )
        [ ul [ class "menu-list" ]
            (List.map (viewChapterLink current) chapters)
        ]


viewChapterLink : String -> Chapter -> Html msg
viewChapterLink path chapter =
    li
        [ class <| if path == chapter.path then "is-active" else ""
        ]
        [ a
            [ href chapter.path ]
            [ text <|
                chapter.section ++ " " ++ chapter.name
            ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        Loaded _ _ _ ->
            Ports.changeSidebar (always ChangeVisibility)

        _ ->
            Sub.none

