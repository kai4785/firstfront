import std.stdio;
import std.string;

import Grammar;
import Tokenizer;

int main(string[] args)
{
    if(args.length < 2)
    {
        stderr.writef("Please provide at least 1 .def file as arg2 %d\n", args.length);
        return 1;
    }
    Tokenizer tokenizer = new Tokenizer(args[1]);
    Grammar grammar = generate_grammar(tokenizer);
    writef("Grammar: %s\n", grammar);
    return 0;
}

Grammar generate_grammar(Tokenizer tokenizer)
{
    Grammar new_grammar = new Grammar(false);
    while(tokenizer.ct.lexeme != "EOT")
    {
        writef("%s\n", tokenizer.ct);
        tokenizer.nextToken();
    }
    return new_grammar;
}

/*
# vim: set syntax=d :
*/
