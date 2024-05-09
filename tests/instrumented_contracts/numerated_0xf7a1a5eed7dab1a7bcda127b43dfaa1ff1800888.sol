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
15     function deposit() payable returns (uint)
16     {
17         if( msg.value > 0 )
18             deposits = deposits + 1;
19 
20         return getNumberOfDeposits();
21     }
22 
23     function getNumberOfDeposits() constant returns (uint)
24     {
25         return deposits;
26     }
27 
28     function kill()
29     {
30         if( msg.sender == creator )
31             selfdestruct(creator);
32     }
33 }