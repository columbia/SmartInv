1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.11;
3 
4 contract ERC20Token {
5 
6     using SafeMath for uint256;
7 
8     string public name;
9     string public symbol;
10     uint8 public decimals;
11     uint256 public totalSupply;
12 
13     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
14     event Transfer(address indexed from, address indexed to, uint256 tokens);
15 
16     mapping(address => uint256) balances;
17     mapping(address => mapping (address => uint256)) allowed;
18 
19     constructor(string memory initName, string memory initSymbol, uint8 initDecimal, uint256 initialSupply) public{
20 
21         name = initName;
22         symbol = initSymbol;
23         decimals = initDecimal;
24         
25         totalSupply = initialSupply * 10 ** uint256(decimals);
26 	    balances[msg.sender] = totalSupply;
27     }
28 
29     function balanceOf(address tokenOwner) public view returns (uint256) {
30         return balances[tokenOwner];
31     }
32 
33     function transfer(address receiver, uint256 numTokens) public returns (bool) {
34         require(numTokens <= balances[msg.sender], "Not Enough Tokens");
35         balances[msg.sender] = balances[msg.sender].sub(numTokens);
36         balances[receiver] = balances[receiver].add(numTokens);
37         emit Transfer(msg.sender, receiver, numTokens);
38         return true;
39     }
40 
41     function approve(address delegate, uint256 numTokens) public returns (bool) {
42         allowed[msg.sender][delegate] = numTokens;
43         emit Approval(msg.sender, delegate, numTokens);
44         return true;
45     }
46 
47     function allowance(address owner, address delegate) public view returns (uint256) {
48         return allowed[owner][delegate];
49     }
50 
51     function transferFrom(address owner, address buyer, uint256 numTokens) public returns (bool) {
52         require(numTokens <= balances[owner], "Not Enough Tokens");
53         require(numTokens <= allowed[owner][msg.sender], "Not Enough Tokens");
54 
55         balances[owner] = balances[owner].sub(numTokens);
56         allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
57         balances[buyer] = balances[buyer].add(numTokens);
58         emit Transfer(owner, buyer, numTokens);
59         return true;
60     }
61 }
62 
63 library SafeMath {
64     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65       assert(b <= a);
66       return a - b;
67     }
68 
69     function add(uint256 a, uint256 b) internal pure returns (uint256) {
70       uint256 c = a + b;
71       assert(c >= a);
72       return c;
73     }
74 }