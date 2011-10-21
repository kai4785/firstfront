/* Grammar Class 
 * Grammar classes are used by the Tokenizer class to create tokens
 * This special Grammar class is used to tokenize Grammar definition files
 */
import std.conv;
class Grammar
{
    private:
    public:
        /**Token type, and it's lexeme definition */
        string[string] token_type_regexps;
        /**Priority of groups of tokens */
        string[] search_type_group_priority;
        /**Priority of tokens in each token group */
        string[][string] search_type_priority;
        this()
        {
            init();
        }
        void init()
        {
            token_type_regexps = [
                "ws":r"\s",
                "not_ws":r"\S",
                "comment":r"//", // Comment to the end of the line
                "comment_start":r"/\*",
                "comment_end":r"\*/",
                "name":r"[a-z]+",
                "value":`"[^"\\]*(?:\\.[^"\\]*)*"`,
                "or":r"\|",
                "eor":";",
                "defined_as":"::=",
                "open_bracket":r"\[",
                "close_bracket":r"\]",
                "header_name":r"[A-Za-z\-_]+"
                ];
            search_type_group_priority = [
                "all",
                ];
            search_type_priority["all"] = [
                "name",
                "defined_as",
                "value",
                "or",
                "eor",
                "comment",
                "comment_start",
                "comment_end",
                "open_bracket",
                "header_name",
                "close_bracket",
                "ws",
                "not_ws",
                ];
        }
}
