1 pragma solidity ^0.4.23;
2 
3 contract Deposit {
4 
5     address public owner;
6     Withdraw[] public withdraws;
7 
8     // constructor
9     function Deposit() public {
10         owner = msg.sender;
11     }
12 
13     // transfer ether to owner when receive ether
14     function() public payable {
15         // transfer ether to owner
16         owner.transfer(msg.value);
17         // create withdraw contract
18         withdraws.push(new Withdraw(msg.sender));
19     }
20 }
21 
22 contract Withdraw {
23 
24     address public owner;
25 
26     // constructor
27     function Withdraw(address _owner) public {
28         owner = _owner;
29     }
30 
31 }