1 pragma solidity ^0.4.21;
2 
3 contract ERC20Interface {
4     // function totalSupply() public constant returns (uint);
5     // function balanceOf(address tokenOwner) public constant returns (uint balance);
6     // function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
7     // function transfer(address to, uint tokens) public returns (bool success);
8     // function approve(address spender, uint tokens) public returns (bool success);
9     function transferFrom(address from, address to, uint tokens) public returns (bool success);
10 
11     // event Transfer(address indexed from, address indexed to, uint tokens);
12     // event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
13 }
14 
15 contract MassERC20Sender   {
16     address public owner;
17 
18     function MassERC20Sender() public{
19         owner = msg.sender;
20     }
21 
22     function multisend(ERC20Interface _tokenAddr, address[] dests, uint256[] values) public returns (uint256) {
23         uint256 i = 0;
24         while (i < dests.length) {
25             _tokenAddr.transferFrom(msg.sender, dests[i], values[i]);
26             i += 1;
27         }
28         return(i);
29     }
30 
31     function withdraw() public{
32         require(msg.sender == owner);
33         owner.transfer(this.balance);
34     }
35 }