1 pragma solidity ^0.4.18;
2 
3 // Simple Game. Each time you send more than the current jackpot, you become
4 // owner of the contract. As an owner, you can take the jackpot after a delay
5 // of 5 days after the last payment.
6 
7 contract Owned {
8     address public owner;
9 
10     function Owned() {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner{
15         if (msg.sender != owner)
16             revert();
17         _;
18     }
19 }
20 
21 contract RichestTakeAll is Owned {
22     address public owner;
23     uint public jackpot;
24     uint public withdrawDelay;
25 
26     function() public payable {
27         // transfer contract ownership if player pay more than current jackpot
28         if (msg.value >= jackpot) {
29             owner = msg.sender;
30             withdrawDelay = block.timestamp + 5 days;
31         }
32 
33         jackpot += msg.value;
34     }
35 
36     function takeAll() public onlyOwner {
37         require(block.timestamp >= withdrawDelay);
38 
39         msg.sender.transfer(jackpot);
40 
41         // restart
42         jackpot = 0;
43     }
44 }