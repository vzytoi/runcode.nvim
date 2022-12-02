return {
    compile = {
        c = "gcc % -o #@ && #@",
        rust = "rustc % -o #@ && #@",
        ocaml = "ocamlc % -o #@ && #@",
        go = "go build -o #@ % && #@"
    },
    interpret = {
        ocaml = "ocaml %",
        typescript = "ts-node %",
        javascript = "node %",
        go = "go run %",
        php = "php %",
        python = "python3 %",
        lua = "lua %",
    }
}
