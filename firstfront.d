import std.stdio;
import std.string;

import Grammar;
import Tokenizer;

int main(string[] args)
{
    if(args.length < 2)
    {
        stderr.writef("Please provide at least 1 .ini file as arg2 %d\n", args.length);
        return 1;
    }
    auto infile = File(args[1], "r");
    auto tokenizer = new Tokenizer(args[1]);
    while(tokenizer.ct.lexeme != "EOT")
    {
        writef("%s\n", tokenizer.ct);
        tokenizer.nextToken();
    }
    return 0;
}
