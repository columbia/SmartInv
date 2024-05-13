1 1 pragma solidity ^0.4.24;
2 
3 2 contract SafeMath {
4 
5 3     function safeAdd(uint a, uint b) public pure returns (uint c) {
6 4         c = a + b;
7 5         require(c >= a);
8 6     }
9 
10 7     function safeSub(uint a, uint b) public pure returns (uint c) {
11 8         require(b <= a);
12 9         c = a - b;
13 10     }
14 
15 11     function safeMul(uint a, uint b) public pure returns (uint c) {
16 12         c = a * b;
17 13         require(a == 0 || c / a == b);
18 14     }
19 
20 15     function safeDiv(uint a, uint b) public pure returns (uint c) {
21 16         require(b > 0);
22 17         c = a / b;
23 18     }
24 19 }
25 
26 
27 20 /**
28 21 ERC Token Standard #20 Interface
29 22 https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
30 23 */
31 24 contract ERC20Interface {
32 25     function totalSupply() public constant returns (uint);
33 26     function balanceOf(address tokenOwner) public constant returns (uint balance);
34 27     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
35 28     function transfer(address to, uint tokens) public returns (bool success);
36 29     function approve(address spender, uint tokens) public returns (bool success);
37 30     function transferFrom(address from, address to, uint tokens) public returns (bool success);
38 
39 31     event Transfer(address indexed from, address indexed to, uint tokens);
40 32     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
41 33 }
42 
43 
44 34 /**
45 35 Contract function to receive approval and execute function in one call
46 
47 36 Borrowed from MiniMeToken
48 37 */
49 38 contract ApproveAndCallFallBack {
50 39     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
51 40 }
52 
53 41 /**
54 42 ERC20 Token, with the addition of symbol, name and decimals and assisted token transfers
55 43 */
56 44 contract SANTAToken is ERC20Interface, SafeMath {
57 45     string public symbol;
58 46     string public  name;
59 47     uint8 public decimals;
60 48     uint public _totalSupply;
61 
62 49     mapping(address => uint) balances;
63 50     mapping(address => mapping(address => uint)) allowed;
64 
65 
66 
67 51     constructor() public {
68 52         symbol = "SANTA";
69 53         name = "santa.investments";
70 54         decimals = 0;
71 55         _totalSupply = 100000000;
72 56         balances[0x4a1D652Dfb96eec4cF8b7245A278296d6FdE632A] = _totalSupply;
73 57         emit Transfer(address(0), 0x4a1D652Dfb96eec4cF8b7245A278296d6FdE632A, _totalSupply);
74 58     }
75 
76 
77 59     function totalSupply() public constant returns (uint) {
78 60         return _totalSupply  - balances[address(0)];
79 61     }
80 
81 
82 62     function balanceOf(address tokenOwner) public constant returns (uint balance) {
83 63         return balances[tokenOwner];
84 64     }
85 
86 
87    
88 65     function transfer(address to, uint tokens) public returns (bool success) {
89 66         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
90 67         balances[to] = safeAdd(balances[to], tokens);
91 68         emit Transfer(msg.sender, to, tokens);
92 69         return true;
93 70     }
94 
95 
96 
97 71     function approve(address spender, uint tokens) public returns (bool success) {
98 72         allowed[msg.sender][spender] = tokens;
99 73         emit Approval(msg.sender, spender, tokens);
100 74         return true;
101 75     }
102 
103 
104 76     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
105 77         balances[from] = safeSub(balances[from], tokens);
106 78         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
107 79         balances[to] = safeAdd(balances[to], tokens);
108 80         emit Transfer(from, to, tokens);
109 81         return true;
110 82     }
111 
112 83     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
113 84         return allowed[tokenOwner][spender];
114 85     }
115 
116 
117 86     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
118 87         allowed[msg.sender][spender] = tokens;
119 88         emit Approval(msg.sender, spender, tokens);
120 89         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
121 90         return true;
122 91     }
123 
124 
125 
126 92     function () public payable {
127 93         revert();
128 94     }
129 95 }