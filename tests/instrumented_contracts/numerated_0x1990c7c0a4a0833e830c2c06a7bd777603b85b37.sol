1 pragma solidity ^0.4.19;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic 
11 {
12 
13   function allowance(address owner, address spender) public view returns (uint256);
14   function transferFrom(address from, address to, uint256 value) public returns (bool);
15   function approve(address spender, uint256 value) public returns (bool);
16   event Approval(address indexed owner, address indexed spender, uint256 value);
17   
18 }
19 
20 contract Airdroplet
21 {
22 
23     ERC20 public token;
24 
25     function airdropExecute(address source, address[] recipents, uint256 amount) public
26     {
27 
28         uint x = 0;
29         token = ERC20(source);
30 
31         while(x < recipents.length)
32         {
33 
34           token.transferFrom(msg.sender, recipents[x], amount);
35           x++;
36 
37         }
38 
39     }
40 
41 
42 }