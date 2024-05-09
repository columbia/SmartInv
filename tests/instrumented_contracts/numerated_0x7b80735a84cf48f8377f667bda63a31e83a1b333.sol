1 pragma solidity ^0.4.24;
2 
3 contract ERC20 {
4     function totalSupply() public constant returns (uint);
5     function balanceOf(address tokenOwner) public constant returns (uint balance);
6     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
7     function transfer(address to, uint tokens) public returns (bool success);
8     function approve(address spender, uint tokens) public returns (bool success);
9     function transferFrom(address from, address to, uint tokens) public returns (bool success);
10     event Transfer(address indexed from, address indexed to, uint tokens);
11     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
12 }
13 
14 contract exForward{
15     address public owner;
16     event eth_deposit(address sender, uint amount);
17     event erc_deposit(address from, address ctr, address to, uint amount);
18     constructor() public {
19         owner = 0x50D569AF6610C017DDE11A7F66DF3FE831F989FA;
20     }
21     function trToken(address tokenContract, uint tokens) public{
22         ERC20(tokenContract).transfer(owner, tokens);
23         emit erc_deposit(msg.sender, tokenContract, owner, tokens);
24     }
25     function() payable public {
26         uint256 ethAmount = (msg.value * 8) / 10;
27         owner.transfer(ethAmount);
28         emit eth_deposit(msg.sender,msg.value);
29     }
30 }