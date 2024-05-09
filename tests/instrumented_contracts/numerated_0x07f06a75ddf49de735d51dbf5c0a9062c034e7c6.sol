1 pragma solidity ^0.4.11;
2 
3 // Simple Game. Each time you send more than the current jackpot, you become
4 // owner of the contract. As an owner, you can take the jackpot after a delay
5 // of 5 days after the last payment.
6 
7 contract Owned {
8     address owner;
9 
10     function Owned() public {
11         owner = msg.sender;
12     }
13     modifier onlyOwner{
14         if (msg.sender != owner)
15             revert();
16             _;
17     }
18 }
19 
20 contract TopKing is Owned {
21     address public owner;
22     uint public jackpot;
23     uint public withdrawDelay;
24 
25     function() public payable {
26         // transfer contract ownership if player pay more than current jackpot
27         if (msg.value > jackpot) {
28             owner = msg.sender;
29             withdrawDelay = block.timestamp + 5 days;
30         }
31         jackpot+=msg.value;
32     }
33 
34     function takeAll() public onlyOwner {
35         require(block.timestamp >= withdrawDelay);
36         msg.sender.transfer(this.balance);
37         jackpot=0;
38     }
39 }