/* Grammar Class 
 * Grammar classes are used by the Tokenizer class to create tokens
 * This special Grammar class is used to tokenize Grammar definition files
 */
import std.conv;
import std.string;
import std.array;
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
            init_default();
        }
	    this(bool init)
	    {
		    if(init)
			    init_default();
	    }
        void init_default()
        {
            token_type_regexps = [
                "ws":r"\s",
                "not_ws":r"\S",
                "comment":r"//.*", // Comment to the end of the line
                "comment_start":r"/\*",
                "comment_end":r"\*/",
                "name":r"[a-z_]+",
                "value":`"[^"\\]*(?:\\.[^"\\]*)*"`,
                "or":r"\|",
                "eor":";",
                "defined_as":"::=",
                "open_bracket":r"\[",
                "close_bracket":r"\]",
                "header_name":r"[A-Za-z\-_ ]+"
                ];
            search_type_group_priority = [
                "default",
                ];
            search_type_priority["default"] = [
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
        string toString()
        {
            auto retval = appender!string();
            retval.put("token_type_regexps:\n");
            foreach(k, v; token_type_regexps)
                retval.put(format("    %s:%s\n", k, v));
            retval.put("search_type_group_priority:\n");
            foreach(k, v; search_type_group_priority)
                retval.put(format("    %s:%s\n", k, v));
            retval.put("search_type_priority:\n");
            foreach(k, v; search_type_priority)
                retval.put(format("    %s:%s\n", k, v));
            retval.put("Done with Grammar\n");
            return retval.data;
        }
}

/*
# vim: set syntax=d :
*/
