1 pragma solidity ^0.4.11;
2 
3 contract BlockchainPi {
4 
5     uint total;
6     uint sevencount;
7     uint256 constant public MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
8     
9     event RollDice (address roller, uint firstdie, uint seconddie, uint newtotal);
10     
11     function addDiceRoll(uint _onedie, uint _twodie) public returns (bool) {
12         bool oneDieFlag = checkDie(_onedie);
13         bool twoDieFlag = checkDie(_twodie);
14         require(oneDieFlag);
15         require(twoDieFlag);
16         require(total != MAX_UINT256);
17         total++;
18         uint addDice = _onedie + _twodie;
19         if (addDice ==7) sevencount++;
20         RollDice(msg.sender, _onedie, _twodie, total);
21         return true;
22     }
23     
24     function checkDie (uint _a) internal returns (bool) {
25         if (_a > 0) {
26             if (_a < 7) {
27                 return true;
28             } else {
29                 return false;
30             }
31         } else {
32             return false;
33         }
34     }
35     
36     function getSevenCount() public returns (uint){
37         return sevencount;
38     }
39     
40     function getTotal() public returns (uint) {
41        return total;
42     }
43 
44 }