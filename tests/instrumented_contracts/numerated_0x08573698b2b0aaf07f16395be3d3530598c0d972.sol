1 pragma solidity ^0.4.11;
2 
3 contract PiggyBank
4 {
5     address creator;
6     uint deposits;
7     uint unlockTime;
8 
9     /* Constructor */
10     function PiggyBank() public
11     {
12         creator = msg.sender;
13         deposits = 0;
14         unlockTime = now + 10 minutes;
15     }
16 
17     function() payable
18     {
19         deposit();
20     }
21 
22     function deposit() payable returns (uint)
23     {
24         if( msg.value > 0 )
25             deposits = deposits + 1;
26 
27         return getNumberOfDeposits();
28     }
29 
30     function getNumberOfDeposits() constant returns (uint)
31     {
32         return deposits;
33     }
34 
35     function getUnlockTime() constant returns (uint)
36     {
37         return unlockTime;
38     }
39 
40     function kill()
41     {
42         if( msg.sender == creator && now >= unlockTime )
43             selfdestruct(creator);
44     }
45 }