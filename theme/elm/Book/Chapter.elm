module Book.Chapter exposing
    ( Chapter, decoder )

import Json.Decode as Decode exposing (Decoder)


{-| Each chapter entry in a book.

See <https://rust-lang.github.io/mdBook/format/theme/index-hbs.html#data>.

-}
type alias Chapter =
    { section : String
    , name : String
    , path : String
    }


decoder : Decoder Chapter
decoder =
    Decode.map3 Chapter
        (Decode.field "section" Decode.string)
        (Decode.field "name" Decode.string)
        (Decode.field "path" Decode.string)