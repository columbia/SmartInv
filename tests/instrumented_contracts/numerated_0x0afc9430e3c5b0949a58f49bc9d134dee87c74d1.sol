1 pragma solidity ^0.4.11;
2 
3 contract PiggyBank
4 {
5     address creator;
6     uint deposits;
7 
8     /* Constructor */
9     function PiggyBank() public
10     {
11         creator = msg.sender;
12         deposits = 0;
13     }
14 
15     function() payable
16     {
17         deposit();
18     }
19 
20     function deposit() payable returns (uint)
21     {
22         if( msg.value > 0 )
23             deposits = deposits + 1;
24 
25         return getNumberOfDeposits();
26     }
27 
28     function getNumberOfDeposits() constant returns (uint)
29     {
30         return deposits;
31     }
32 
33     function kill()
34     {
35         if( msg.sender == creator )
36             selfdestruct(creator);
37     }
38 }