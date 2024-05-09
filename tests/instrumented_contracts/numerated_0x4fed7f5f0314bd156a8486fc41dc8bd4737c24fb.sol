1 pragma solidity ^0.4.19;
2 
3 contract Ownable {
4     address public owner;
5     
6     function Ownable() public {
7         owner = msg.sender;
8     }
9     
10     modifier onlyOwner() {
11         require(msg.sender == owner);
12         _;
13     }
14 }
15 
16 contract StakeholderInc is Ownable {
17     address public owner;
18 
19     uint public largestStake;
20 
21     function purchaseStake() public payable {
22         // if you own a largest stake in a company, you own a company
23         if (msg.value > largestStake) {
24             owner = msg.sender;
25             largestStake = msg.value;
26         }
27     }
28 
29     function withdraw() public onlyOwner {
30         // only owner can withdraw funds
31         msg.sender.transfer(this.balance);
32     }
33 }