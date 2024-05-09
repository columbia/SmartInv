1 pragma solidity 0.4.24;
2 contract CoinbaseTest {
3     address owner;
4     
5     constructor() public {
6         owner = msg.sender;
7     }
8     
9     function () public payable {
10     }
11     
12     function withdraw() public {
13         require(msg.sender == owner);
14         msg.sender.transfer(this.balance);
15     }
16 
17 }