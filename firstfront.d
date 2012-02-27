import std.stdio;
import std.string;
import std.array;

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
    string last_group = "default";
    new_grammar.search_type_priority[last_group] = [];
    string last_type;
    while(tokenizer.ct.lexeme != "EOT")
    {
        writef("%s\n", tokenizer.ct);
        if(tokenizer.ct.type == "name")
        {
            last_type = tokenizer.ct.lexeme;
            new_grammar.search_type_priority[last_group] ~= tokenizer.ct.lexeme;
        }
        if(tokenizer.ct.type == "value")
        {
            new_grammar.token_type_regexps[last_type] ~= tokenizer.ct.lexeme;
        }
        if(tokenizer.ct.type == "or")
        {
            new_grammar.token_type_regexps[last_type] ~= "|";
        }
        tokenizer.nextToken();
    }
    new_grammar.search_type_group_priority = [last_group];
    return new_grammar;
}

/*
# vim: set syntax=d :
*/
