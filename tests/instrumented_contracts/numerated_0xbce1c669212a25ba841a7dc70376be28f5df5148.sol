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
15         to.transfer(value);
16         emit Transfer(to, value);
17     }
18 
19     function deposit() payable public {
20         emit Deposit(msg.value);
21     }
22 
23     function getBalance() public view returns (uint256) {
24         return address(this).balance;
25     }
26     
27     modifier onlyOwner() {
28         require(msg.sender == owner);
29         _;
30     }
31 }