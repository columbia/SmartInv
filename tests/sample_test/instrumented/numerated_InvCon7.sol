1 1 pragma solidity ^0.4.24;
2 
3 
4 2 contract SafeMath {
5 
6 3     function safeAdd(uint a, uint b) public pure returns (uint c) {
7 4         c = a + b;
8 5         require(c >= a);
9 6     }
10 
11 7     function safeSub(uint a, uint b) public pure returns (uint c) {
12 8         require(b <= a);
13 9         c = a - b;
14 10     }
15 
16 11     function safeMul(uint a, uint b) public pure returns (uint c) {
17 12         c = a * b;
18 13         require(a == 0 || c / a == b);
19 14     }
20 
21 15     function safeDiv(uint a, uint b) public pure returns (uint c) {
22 16         require(b > 0);
23 17         c = a / b;
24 18     }
25 19 }
26 
27 20 contract ERC20Interface {
28 21     function totalSupply() public constant returns (uint);
29 22     function balanceOf(address tokenOwner) public constant returns (uint balance);
30 23     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
31 24     function transfer(address to, uint tokens) public returns (bool success);
32 25     function approve(address spender, uint tokens) public returns (bool success);
33 26     function transferFrom(address from, address to, uint tokens) public returns (bool success);
34 
35 27     event Transfer(address indexed from, address indexed to, uint tokens);
36 28     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
37 29 }
38 
39 
40 
41 30 contract ApproveAndCallFallBack {
42 31     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
43 32 }
44 
45 
46 33 contract IAMToken is ERC20Interface, SafeMath {
47 34     string public symbol;
48 35     string public  name;
49 36     uint8 public decimals;
50 37     uint public _totalSupply;
51 
52 38     mapping(address => uint) balances;
53 39     mapping(address => mapping(address => uint)) allowed;
54 
55 
56 40     constructor() public {
57 41         symbol = "IAM";
58 42         name = "IAMEMILIANO";
59 43         decimals = 2;
60 44         _totalSupply = 100000000000;
61 45         balances[0x4a460B1Be30c04EB904868fA5292ba8f6Ae2B740] = _totalSupply;
62 46         emit Transfer(address(0), 0x4a460B1Be30c04EB904868fA5292ba8f6Ae2B740, _totalSupply);
63 47     }
64 
65 
66 
67 48     function totalSupply() public constant returns (uint) {
68 49         return _totalSupply  - balances[address(0)];
69 50     }
70 
71 
72 
73 51     function balanceOf(address tokenOwner) public constant returns (uint balance) {
74 52         return balances[tokenOwner];
75 53     }
76 
77 
78 54     function transfer(address to, uint tokens) public returns (bool success) {
79 55         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
80 56         balances[to] = safeAdd(balances[to], tokens);
81 57         emit Transfer(msg.sender, to, tokens);
82 58         return true;
83 59     }
84 
85 
86 
87 60     function approve(address spender, uint tokens) public returns (bool success) {
88 61         allowed[msg.sender][spender] = tokens;
89 62         emit Approval(msg.sender, spender, tokens);
90 63         return true;
91 64     }
92 
93 
94 
95 65     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
96 66         balances[from] = safeSub(balances[from], tokens);
97 67         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
98 68         balances[to] = safeAdd(balances[to], tokens);
99 69         emit Transfer(from, to, tokens);
100 70         return true;
101 71     }
102 
103 
104 
105 72     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
106 73         return allowed[tokenOwner][spender];
107 74     }
108 
109 
110 75     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
111 76         allowed[msg.sender][spender] = tokens;
112 77         emit Approval(msg.sender, spender, tokens);
113 78         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
114 79         return true;
115 80     }