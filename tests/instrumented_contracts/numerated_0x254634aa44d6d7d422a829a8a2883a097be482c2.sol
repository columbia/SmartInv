1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract MyBank {
4     uint256 balance;
5     address owner;
6 
7     constructor () public {
8         owner = msg.sender;
9     }
10     
11     function deposit() public payable {
12         balance = msg.value;
13     }
14     
15     function withdraw(uint256 valueToRetrieve) public {
16         require(msg.sender == owner);
17         msg.sender.transfer(valueToRetrieve);
18     }
19 }