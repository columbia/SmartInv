1 pragma solidity ^0.4.13;
2 
3 interface EtherShare {
4     function allShare(uint ShareID, uint ReplyID) returns (address,string,uint,bool,string);
5 }
6 
7 // Enable users to reward authors from EtherShare and record the reward
8 contract EtherShareReward {
9     EtherShare ES = EtherShare(0xc86bdf9661c62646194ef29b1b8f5fe226e8c97e);
10     
11     struct oneReward {
12         address from;
13         uint value;
14     }
15     mapping(uint => mapping(uint => oneReward[])) public allRewards;
16     
17     function Reward(uint ShareID, uint ReplyID) payable public {
18         address to;
19         (to,,,,) = ES.allShare(ShareID,ReplyID); // get the author
20         to.transfer(msg.value);
21         allRewards[ShareID][ReplyID].push(oneReward(msg.sender, msg.value)); // record the reward
22     }
23 
24     function getSum(uint ShareID, uint ReplyID) view public returns (uint) {
25         uint sum = 0;
26         for (uint i=0; i<allRewards[ShareID][ReplyID].length; ++i)
27             sum += allRewards[ShareID][ReplyID][i].value;
28         return sum;
29     }
30 }