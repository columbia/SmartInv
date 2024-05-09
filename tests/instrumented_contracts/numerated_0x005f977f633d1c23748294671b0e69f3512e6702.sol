1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'TRYL' Stablecoin Contract
5 //
6 // Symbol      : TRYL
7 // Name        : LIRASIS TRY
8 // Total supply: 354,261,980.00
9 // Decimals    : 2
10 // Website     : https://lirasis.com
11 // Email       : support(@)lirasis.com
12 //
13 // ----------------------------------------------------------------------------
14 
15 contract SafeMath {
16     function safeAdd(uint a, uint b) public pure returns (uint c) {
17         c = a + b;
18         require(c >= a);
19     }
20     function safeSub(uint a, uint b) public pure returns (uint c) {
21         require(b <= a);
22         c = a - b;
23     }
24     function safeMul(uint a, uint b) public pure returns (uint c) {
25         c = a * b;
26         require(a == 0 || c / a == b);
27     }
28     function safeDiv(uint a, uint b) public pure returns (uint c) {
29         require(b > 0);
30         c = a / b;
31     }
32 }
33 
34 contract ERC20Interface {
35     function totalSupply() public constant returns (uint);
36     function balanceOf(address tokenOwner) public constant returns (uint balance);
37     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
38     function transfer(address to, uint tokens) public returns (bool success);
39     function approve(address spender, uint tokens) public returns (bool success);
40     function transferFrom(address from, address to, uint tokens) public returns (bool success);
41 
42     event Transfer(address indexed from, address indexed to, uint tokens);
43     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
44 }
45 
46 contract ApproveAndCallFallBack {
47     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
48 }
49 
50 contract Owned {
51     address public owner;
52     address public newOwner;
53 
54     event OwnershipTransferred(address indexed _from, address indexed _to);
55 
56     constructor() public {
57         owner = msg.sender;
58     }
59 
60     modifier onlyOwner {
61         require(msg.sender == owner);
62         _;
63     }
64 
65     function transferOwnership(address _newOwner) public onlyOwner {
66         newOwner = _newOwner;
67     }
68     function acceptOwnership() public {
69         require(msg.sender == newOwner);
70         emit OwnershipTransferred(owner, newOwner);
71         owner = newOwner;
72         newOwner = address(0);
73     }
74 }
75 
76 contract TRYLToken is ERC20Interface, Owned, SafeMath {
77     string public symbol;
78     string public  name;
79     uint8 public decimals;
80     uint public _totalSupply;
81 
82     mapping(address => uint) balances;
83     mapping(address => mapping(address => uint)) allowed;
84 
85     constructor() public {
86         symbol = "TRYL";
87         name = "LIRASIS TRY";
88         decimals = 2;
89         _totalSupply = 35426198000;
90         balances[0xe76E7B5E1b8510D5bFDA14D5988BfF82C6a1F16C] = _totalSupply;
91         emit Transfer(address(0), 0xe76E7B5E1b8510D5bFDA14D5988BfF82C6a1F16C, _totalSupply);
92     }
93 
94     function totalSupply() public constant returns (uint) {
95         return _totalSupply  - balances[address(0)];
96     }
97 
98     function balanceOf(address tokenOwner) public constant returns (uint balance) {
99         return balances[tokenOwner];
100     }
101 
102     function transfer(address to, uint tokens) public returns (bool success) {
103         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
104         balances[to] = safeAdd(balances[to], tokens);
105         emit Transfer(msg.sender, to, tokens);
106         return true;
107     }
108 
109     function approve(address spender, uint tokens) public returns (bool success) {
110         allowed[msg.sender][spender] = tokens;
111         emit Approval(msg.sender, spender, tokens);
112         return true;
113     }
114 
115     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
116         balances[from] = safeSub(balances[from], tokens);
117         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
118         balances[to] = safeAdd(balances[to], tokens);
119         emit Transfer(from, to, tokens);
120         return true;
121     }
122 
123     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
124         return allowed[tokenOwner][spender];
125     }
126 
127     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
128         allowed[msg.sender][spender] = tokens;
129         emit Approval(msg.sender, spender, tokens);
130         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
131         return true;
132     }
133 
134     function () public payable {
135         revert();
136     }
137 
138     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
139         return ERC20Interface(tokenAddress).transfer(owner, tokens);
140     }
141 }