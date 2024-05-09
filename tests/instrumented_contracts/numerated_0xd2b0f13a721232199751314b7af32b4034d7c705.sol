1 pragma solidity ^0.4.4;
2 
3 contract Deposit {
4 
5     address public owner;
6 
7     // constructor
8     function Deposit() public {
9         owner = msg.sender;
10     }
11 
12     // transfer ether to owner when receive ether
13     function() public payable {
14         _transter(msg.value);
15     }
16 
17     // transfer
18     function _transter(uint balance) internal {
19         owner.transfer(balance);
20     }
21 }