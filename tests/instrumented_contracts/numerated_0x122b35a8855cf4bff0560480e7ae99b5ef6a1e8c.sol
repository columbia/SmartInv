1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // token contract
5 //
6 // Symbol        : BBG
7 // Name          : BASEBALLGAME
8 // Total supply  : 1000000000
9 // Decimals      : 12
10 // Owner Account : 0x4C3d9D627C350C8944c39f2bBb0E7eB8715ace5C
11 //
12 // Enjoy.
13 //
14 // (c) by Idea Inven Doohee 2021. DM Licence.
15 // ----------------------------------------------------------------------------
16 
17 
18 // ----------------------------------------------------------------------------
19 // Lib: Safe Math
20 // ----------------------------------------------------------------------------
21 contract SafeMath {
22 
23     function safeAdd(uint a, uint b) public pure returns (uint c) {
24         c = a + b;
25         require(c >= a);
26     }
27 
28     function safeSub(uint a, uint b) public pure returns (uint c) {
29         require(b <= a);
30         c = a - b;
31     }
32 
33     function safeMul(uint a, uint b) public pure returns (uint c) {
34         c = a * b;
35         require(a == 0 || c / a == b);
36     }
37 
38     function safeDiv(uint a, uint b) public pure returns (uint c) {
39         require(b > 0);
40         c = a / b;
41     }
42 }
43 
44 
45 /**
46 ERC Token Standard #20 Interface
47 https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
48 */
49 contract ERC20Interface {
50     function totalSupply() public constant returns (uint);
51     function balanceOf(address tokenOwner) public constant returns (uint balance);
52     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
53     function transfer(address to, uint tokens) public returns (bool success);
54     function approve(address spender, uint tokens) public returns (bool success);
55     function transferFrom(address from, address to, uint tokens) public returns (bool success);
56 
57     event Transfer(address indexed from, address indexed to, uint tokens);
58     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
59 }
60 
61 
62 /**
63 Contract function to receive approval and execute function in one call
64 Borrowed from MiniMeToken
65 */
66 contract ApproveAndCallFallBack {
67     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
68 }
69 
70 /**
71 ERC20 Token, with the addition of symbol, name and decimals and assisted token transfers
72 */
73 contract BBGToken is ERC20Interface, SafeMath {
74     string public symbol;
75     string public  name;
76     uint8 public decimals;
77     uint public _totalSupply;
78 
79     mapping(address => uint) balances;
80     mapping(address => mapping(address => uint)) allowed;
81 
82 
83     // ------------------------------------------------------------------------
84     // Constructor
85     // ------------------------------------------------------------------------
86     constructor() public {
87         symbol = "BBG";
88         name = "BASEBALLGAME";
89         decimals = 12;
90         _totalSupply = 1000000000000000000000;
91         balances[0x4C3d9D627C350C8944c39f2bBb0E7eB8715ace5C] = _totalSupply;
92         emit Transfer(address(0), 0x4C3d9D627C350C8944c39f2bBb0E7eB8715ace5C, _totalSupply);
93     }
94 
95 
96     // ------------------------------------------------------------------------
97     // Total supply
98     // ------------------------------------------------------------------------
99     function totalSupply() public constant returns (uint) {
100         return _totalSupply  - balances[address(0)];
101     }
102 
103 
104     // ------------------------------------------------------------------------
105     // Get the token balance for account tokenOwner
106     // ------------------------------------------------------------------------
107     function balanceOf(address tokenOwner) public constant returns (uint balance) {
108         return balances[tokenOwner];
109     }
110 
111 
112     // ------------------------------------------------------------------------
113     // Transfer the balance from token owner's account to to account
114     // - Owner's account must have sufficient balance to transfer
115     // - 0 value transfers are allowed
116     // ------------------------------------------------------------------------
117     function transfer(address to, uint tokens) public returns (bool success) {
118         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
119         balances[to] = safeAdd(balances[to], tokens);
120         emit Transfer(msg.sender, to, tokens);
121         return true;
122     }
123 
124 
125     // ------------------------------------------------------------------------
126     // Token owner can approve for spender to transferFrom(...) tokens
127     // from the token owner's account
128     //
129     // recommends that there are no checks for the approval double-spend attack
130     // as this should be implemented in user interfaces 
131     // ------------------------------------------------------------------------
132     function approve(address spender, uint tokens) public returns (bool success) {
133         allowed[msg.sender][spender] = tokens;
134         emit Approval(msg.sender, spender, tokens);
135         return true;
136     }
137 
138 
139     // ------------------------------------------------------------------------
140     // Transfer tokens from the from account to the to account
141     // 
142     // The calling account must already have sufficient tokens approve(...)-d
143     // for spending from the from account and
144     // - From account must have sufficient balance to transfer
145     // - Spender must have sufficient allowance to transfer
146     // - 0 value transfers are allowed
147     // ------------------------------------------------------------------------
148     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
149         balances[from] = safeSub(balances[from], tokens);
150         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
151         balances[to] = safeAdd(balances[to], tokens);
152         emit Transfer(from, to, tokens);
153         return true;
154     }
155 
156 
157     // ------------------------------------------------------------------------
158     // Returns the amount of tokens approved by the owner that can be
159     // transferred to the spender's account
160     // ------------------------------------------------------------------------
161     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
162         return allowed[tokenOwner][spender];
163     }
164 
165 
166     // ------------------------------------------------------------------------
167     // Token owner can approve for spender to transferFrom(...) tokens
168     // from the token owner's account. The spender contract function
169     // receiveApproval(...) is then executed
170     // ------------------------------------------------------------------------
171     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
172         allowed[msg.sender][spender] = tokens;
173         emit Approval(msg.sender, spender, tokens);
174         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
175         return true;
176     }
177 
178 
179     // ------------------------------------------------------------------------
180     // Don't accept ETH
181     // ------------------------------------------------------------------------
182     function () public payable {
183         revert();
184     }
185 }