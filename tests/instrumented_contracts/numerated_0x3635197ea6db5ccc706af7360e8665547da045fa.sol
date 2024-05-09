1 pragma solidity ^0.4.0;
2 contract TestHello {
3     event logite(string name);
4 
5     /// Create a new ballot with $(_numProposals) different proposals.
6     function TestHello() public {
7         logite("HELLO_TestHello");
8     }
9 
10 
11     /// Delegate your vote to the voter $(to).
12     function logit() public {
13         logite("LOGIT_TestHello");
14     }
15 }