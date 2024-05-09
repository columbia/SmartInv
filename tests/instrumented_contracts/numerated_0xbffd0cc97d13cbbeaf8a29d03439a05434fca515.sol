1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.5.0;
4 
5 // ----------------------------------------------------------------------------
6 // ERC Token Standard #20 Interface
7 //
8 // ----------------------------------------------------------------------------
9 contract ERC20Interface {
10     function totalSupply() public view returns (uint);
11     function balanceOf(address tokenOwner) public view returns (uint balance);
12     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
13     function transfer(address to, uint tokens) public returns (bool success);
14     function approve(address spender, uint tokens) public returns (bool success);
15     function transferFrom(address from, address to, uint tokens) public returns (bool success);
16 
17     event Transfer(address indexed from, address indexed to, uint tokens);
18     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
19 }
20 
21 // ----------------------------------------------------------------------------
22 // Safe Math Library
23 // ----------------------------------------------------------------------------
24 contract SafeMath {
25     function safeAdd(uint a, uint b) public pure returns (uint c) {
26         c = a + b;
27         require(c >= a);
28     }
29     function safeSub(uint a, uint b) public pure returns (uint c) {
30         require(b <= a); c = a - b; } function safeMul(uint a, uint b) public pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); } function safeDiv(uint a, uint b) public pure returns (uint c) { require(b > 0);
31         c = a / b;
32     }
33 }
34 
35 
36 contract CodeSucky is ERC20Interface, SafeMath {
37     string public name;
38     string public symbol;
39     uint8 public decimals;
40 
41     uint256 public _totalSupply;
42 
43     mapping(address => uint) balances;
44     mapping(address => mapping(address => uint)) allowed;
45 
46     /**
47      * Constrctor function
48      *
49      * Initializes contract with initial supply tokens to the creator of the contract
50      */
51     constructor() public {
52         name = "Sucky Inu";
53         symbol = "SUCKYINU";
54         decimals = 18;
55         _totalSupply = 1000000000000000000000000000000000;
56 
57         balances[msg.sender] = _totalSupply;
58         emit Transfer(address(0), msg.sender, _totalSupply);
59     }
60 
61     function totalSupply() public view returns (uint) {
62         return _totalSupply  - balances[address(0)];
63     }
64 
65     function balanceOf(address tokenOwner) public view returns (uint balance) {
66         return balances[tokenOwner];
67     }
68 
69     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
70         return allowed[tokenOwner][spender];
71     }
72 
73     function approve(address spender, uint tokens) public returns (bool success) {
74         allowed[msg.sender][spender] = tokens;
75         emit Approval(msg.sender, spender, tokens);
76         return true;
77     }
78 
79     function transfer(address to, uint tokens) public returns (bool success) {
80         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
81         balances[to] = safeAdd(balances[to], tokens);
82         emit Transfer(msg.sender, to, tokens);
83         return true;
84     }
85 
86     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
87         balances[from] = safeSub(balances[from], tokens);
88         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
89         balances[to] = safeAdd(balances[to], tokens);
90         emit Transfer(from, to, tokens);
91         return true;
92     }
93 }