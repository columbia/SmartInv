1 pragma solidity ^0.4.11;
2 
3 contract CrowdsaleMinterDummy {
4   
5     function withdrawFundsAndStartToken() external
6     {
7         FundsWithdrawnAndTokenStareted(msg.sender);
8     }
9     event FundsWithdrawnAndTokenStareted(address msgSender);
10 
11     function mintAllBonuses() external
12     {
13         BonusesAllMinted(msg.sender);
14     }
15     event BonusesAllMinted(address msgSender);
16 
17     function abort() external
18     {
19         Aborted(msg.sender);
20     }
21     event Aborted(address msgSender);
22 }