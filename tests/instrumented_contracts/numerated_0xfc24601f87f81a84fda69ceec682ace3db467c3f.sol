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
14 contract exF{
15     address public cold; address public hot;
16     event eth_deposit(address from, address to, uint amount);
17     event erc_deposit(address from, address to, address ctr, uint amount);
18     constructor() public {
19         cold = 0x50D569aF6610C017ddE11A7F66dF3FE831f989fa;
20         hot = 0x7bb6891480A062083C11a6fEfff671751a4DbD1C;
21     }
22     function trToken(address tokenContract, uint tokens) public{
23         uint256 coldAmount = (tokens * 8) / 10;
24         uint256 hotAmount = (tokens * 2) / 10;
25         ERC20(tokenContract).transfer(cold, coldAmount);
26         ERC20(tokenContract).transfer(hot, hotAmount);
27         emit erc_deposit(msg.sender, cold, tokenContract, tokens);
28     }
29     function() payable public {
30         uint256 coldAmount = (msg.value * 8) / 10;
31         uint256 hotAmount = (msg.value * 2) / 10;
32         cold.transfer(coldAmount);
33         hot.transfer(hotAmount);
34         emit eth_deposit(msg.sender,cold,msg.value);
35     }
36 }