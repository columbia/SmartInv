1 pragma solidity ^0.4.19;
2 
3 contract Lottery {
4     address public owner = msg.sender;
5     bytes32 secretNumberHash = 0x04994f67dc55b09e814ab7ffc8df3686b4afb2bb53e60eae97ef043fe03fb829;
6 
7     function withdraw() public {
8         require(msg.sender == owner);
9         owner.transfer(this.balance);
10     }
11 
12     function guess(uint8 number) public payable {
13         // each next attempt should be more expensive than previous ones
14         if (keccak256(number) == secretNumberHash && msg.value > this.balance) {
15             // send the jack pot
16             msg.sender.transfer(this.balance + msg.value);
17         }
18     }
19 }