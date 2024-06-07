return {
    Compile = {
        c = "gcc -fsanitize=undefined % -o #@ && #@",
        cpp = "g++ % -o #@ -Ofast -std=c++17 && #@",
        rust = "rustc % -o #@ && #@",
        ocaml = "ocamlc % -o #@ && #@",
        go = "go build -o #@ % && #@"
    },
    Interpret = {
        ocaml = "ocaml %",
        typescript = "ts-node %",
        javascript = "node %",
        go = "go run %",
        php = "php %",
        python = "python3 %",
        lua = "lua %",
        sh = "sh %",
        ruby = "ruby %",
        html = "open %"
    },
    Project = {
        ocaml = "dune exec ^",
        javascript = "node ^",
        c = "gcc -fsanitize=undefined ^ % -o #@ && #@",
        cpp = "g++ % ^ -o #@ && #@"
    }
}
