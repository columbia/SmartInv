1 pragma solidity ^0.5.0;
2 
3 // SPDX-License-Identifier: MIT
4 
5 contract ERC20Interface {
6     function totalSupply() public view returns (uint);
7     function balanceOf(address tokenOwner) public view returns (uint balance);
8     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
9     function transfer(address to, uint tokens) public returns (bool success);
10     function approve(address spender, uint tokens) public returns (bool success);
11     function transferFrom(address from, address to, uint tokens) public returns (bool success);
12 
13     event Transfer(address indexed from, address indexed to, uint tokens);
14     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
15 }
16 
17 contract SafeMath {
18     function safeAdd(uint a, uint b) public pure returns (uint c) {
19         c = a + b;
20         require(c >= a);
21     }
22     function safeSub(uint a, uint b) public pure returns (uint c) {
23         require(b <= a); c = a - b; } function safeMul(uint a, uint b) public pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); } function safeDiv(uint a, uint b) public pure returns (uint c) { require(b > 0);
24         c = a / b;
25     }
26 }
27 
28 
29 contract Truedoge is ERC20Interface, SafeMath {
30     string public name;
31     string public symbol;
32     uint8 public decimals; // 18 decimals is the strongly suggested default, avoid changing it
33 
34     uint256 public _totalSupply;
35 
36     mapping(address => uint) balances;
37     mapping(address => mapping(address => uint)) allowed;
38 
39     /**
40      * Constrctor function
41      *
42      * Initializes contract with initial supply tokens to the creator of the contract
43      */
44     constructor() public {
45         name = "Truedoge";
46         symbol = "TRUDOGE";
47         decimals = 9;
48         _totalSupply = 100000000000000000000;
49 
50         balances[msg.sender] = _totalSupply;
51         emit Transfer(address(0), msg.sender, _totalSupply);
52     }
53 
54     function totalSupply() public view returns (uint) {
55         return _totalSupply  - balances[address(0)];
56     }
57 
58     function balanceOf(address tokenOwner) public view returns (uint balance) {
59         return balances[tokenOwner];
60     }
61 
62     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
63         return allowed[tokenOwner][spender];
64     }
65 
66     function approve(address spender, uint tokens) public returns (bool success) {
67         allowed[msg.sender][spender] = tokens;
68         emit Approval(msg.sender, spender, tokens);
69         return true;
70     }
71 
72     function transfer(address to, uint tokens) public returns (bool success) {
73         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
74         balances[to] = safeAdd(balances[to], tokens);
75         emit Transfer(msg.sender, to, tokens);
76         return true;
77     }
78 
79     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
80         balances[from] = safeSub(balances[from], tokens);
81         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
82         balances[to] = safeAdd(balances[to], tokens);
83         emit Transfer(from, to, tokens);
84         return true;
85         
86     }
87 }