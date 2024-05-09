1 // SPDX-License-Identifier: GPL-3.0
2 pragma solidity 0.6.2;
3 
4 contract ERC20 {
5 
6     string public constant name = "VentiSwap Token";
7     string public constant symbol = "VST";
8     uint8 public constant decimals = 18;  
9     uint256 public constant totalSupply = 100000000000000000000000000;
10 
11  
12     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
13     event Transfer(address indexed from, address indexed to, uint tokens);
14 
15 
16     mapping(address => uint256) balances;
17 
18     mapping(address => mapping (address => uint256)) allowed;
19     
20    constructor() public {  
21 	balances[msg.sender] = 100000000000000000000000000;
22     }  
23 
24  
25     function balanceOf(address tokenOwner) external view returns (uint) {
26         return balances[tokenOwner];
27     }
28      function tokenRemaning(address token) external view returns (uint) {
29         return balances[token];
30 }
31     function transfer(address receiver, uint numTokens) public returns (bool) {
32        uint OwnerBalance=balances[msg.sender];
33         require(numTokens <= OwnerBalance ,"Don't have enough Tokens...");
34         
35         balances[msg.sender] = OwnerBalance-numTokens;
36         balances[receiver]+=numTokens;
37         emit Transfer(msg.sender, receiver, numTokens);
38         return true;
39     }
40 
41     function approve(address delegate, uint numTokens) external returns (bool) {
42         allowed[msg.sender][delegate] = numTokens;
43         Approval(msg.sender, delegate, numTokens);
44         return true;
45     }
46 
47     function allowance(address owner, address delegate) external view returns (uint) {
48         return allowed[owner][delegate];
49     }
50 
51     function transferFrom(address owner, address buyer, uint numTokens) public returns (bool) {
52        uint OwnerBalance=balances[owner];
53        uint AlowedOwner=allowed[owner][msg.sender];
54 
55         require(numTokens <= OwnerBalance,"Don't have enough Tokens...");    
56         require(numTokens <= AlowedOwner);
57     
58         balances[owner] = OwnerBalance-numTokens;
59         allowed[owner][msg.sender] =AlowedOwner-numTokens;
60         balances[buyer] +=numTokens;
61         emit Transfer(owner, buyer, numTokens);
62         return true;
63     }
64 }