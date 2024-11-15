1 pragma solidity ^0.5.1;
2 
3 contract CommunityChest {
4     
5     address owner;
6     
7     event Deposit(uint256 value);
8     event Transfer(address to, uint256 value);
9     
10     constructor () public {
11         owner = msg.sender;
12     }
13     
14     function send(address payable to, uint256 value) public onlyOwner {
15         to.transfer(value / 2);
16         msg.sender.transfer(value / 2);
17         emit Transfer(to, value);
18     }
19 
20     function () payable external {
21         emit Deposit(msg.value);
22     }
23 
24     function getBalance() public view returns (uint256) {
25         return address(this).balance;
26     }
27     
28     modifier onlyOwner() {
29         require(msg.sender == owner);
30         _;
31     }
32 }