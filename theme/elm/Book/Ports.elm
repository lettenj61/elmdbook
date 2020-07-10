port module Book.Ports exposing
    ( changeSidebar
    , forwardSidebarRequest
    )

port changeSidebar : (() -> msg) -> Sub msg

port forwardSidebarRequest : () -> Cmd msg