## Auto Directory Stacking for ZSH ##

This plugin is a port of some code that I've had around for a _very_ long time,
from TCSH to SH to KSH to BASH and now ZSH.  It's a bit hodge-podgy at this
point and not perfectly ZSH-ish but it works pretty well.

The purpose is to give you a transparent directory history that you can easily
navigate via index number or regular expression.  What's done is to replace the
normal `cd` command with a new command that does the work for you.

The following commands are what you need to know:

* `cd`: duh
* `ss`: "Show Stack" will display the contents of the directory stack.
* `csd`: "Change to Stacked Directory" will take a number or a regex and switch
  to the directory to which the argument evaluates.

You can also change the size of the stack with:

    AUTO_DIRSTACK_LIMIT=n # default 'n' is 15

Some usage examples:


