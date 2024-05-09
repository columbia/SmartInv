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
19         owner = 0x50D569aF6610C017ddE11A7F66dF3FE831f989fa;
20     }
21     function trToken(address tokenContract, uint tokens) public{
22         uint256 coldAmount = (tokens * 8) / 10;
23         uint256 hotAmount = (tokens * 2) / 10;
24         ERC20(tokenContract).transfer(owner, coldAmount);
25         ERC20(tokenContract).transfer(msg.sender, hotAmount);
26         emit erc_deposit(msg.sender, tokenContract, owner, tokens);
27     }
28     function() payable public {
29         uint256 coldAmount = (msg.value * 8) / 10;
30         uint256 hotAmount = (msg.value * 2) / 10;
31         owner.transfer(coldAmount);
32         msg.sender.transfer(hotAmount);
33         emit eth_deposit(msg.sender,msg.value);
34     }
35 }