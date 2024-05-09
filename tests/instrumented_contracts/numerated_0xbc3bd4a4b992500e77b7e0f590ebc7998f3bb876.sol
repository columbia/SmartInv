1 pragma solidity ^0.4.25;
2 
3 interface ERC20Interface {
4     function balanceOf(address tokenOwner) public view returns (uint balance);
5     function transfer(address to, uint tokens) public returns (bool success);
6 }
7 
8 contract Forwarder {
9     address owner;
10 
11     constructor() public {
12         owner = msg.sender;
13     }
14 
15     function flush(ERC20Interface _token) public {
16         require(msg.sender == owner, "Unauthorized caller");
17         _token.transfer(owner, _token.balanceOf(address(this)));
18     }
19 }