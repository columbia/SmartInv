1 pragma solidity ^0.4.19;
2 
3 contract JackPot {
4     address public owner = msg.sender;
5     bytes32 secretNumberHash = 0xee2a4bc7db81da2b7164e56b3649b1e2a09c58c455b15dabddd9146c7582cebc;
6 
7     function withdraw() public {
8         require(msg.sender == owner);
9         owner.transfer(this.balance);
10     }
11 
12     function guess(uint8 number) public payable {
13         // each next attempt should be more expensive than previous ones
14         if (hashNumber(number) == secretNumberHash && msg.value > this.balance) {
15             // send the jack pot
16             msg.sender.transfer(this.balance + msg.value);
17         }
18     }
19     
20     function hashNumber(uint8 number) public pure returns (bytes32) {
21         return keccak256(number);
22     }
23 }