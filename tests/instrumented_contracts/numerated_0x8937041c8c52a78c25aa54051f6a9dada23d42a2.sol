1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // Sample token contract
5 //
6 // Symbol        : MCDC
7 // Name          : McDonaldsCoin
8 // Total supply  : 3700000000
9 // Decimals      : 2
10 // Owner Account : 0x5b05140C34e9F46B059a95054dE6bec9a213E9F9
11 //
12 // ----------------------------------------------------------------------------
13 
14 
15 // ----------------------------------------------------------------------------
16 // Lib: Safe Math
17 // ----------------------------------------------------------------------------
18 contract SafeMath {
19 
20     function safeAdd(uint a, uint b) public pure returns (uint c) {
21         c = a + b;
22         require(c >= a);
23     }
24 
25     function safeSub(uint a, uint b) public pure returns (uint c) {
26         require(b <= a);
27         c = a - b;
28     }
29 
30     function safeMul(uint a, uint b) public pure returns (uint c) {
31         c = a * b;
32         require(a == 0 || c / a == b);
33     }
34 
35     function safeDiv(uint a, uint b) public pure returns (uint c) {
36         require(b > 0);
37         c = a / b;
38     }
39 }
40 
41 
42 /**
43 ERC Token Standard #20 Interface
44 https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
45 */
46 contract ERC20Interface {
47     function totalSupply() public constant returns (uint);
48     function balanceOf(address tokenOwner) public constant returns (uint balance);
49     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
50     function transfer(address to, uint tokens) public returns (bool success);
51     function approve(address spender, uint tokens) public returns (bool success);
52     function transferFrom(address from, address to, uint tokens) public returns (bool success);
53 
54     event Transfer(address indexed from, address indexed to, uint tokens);
55     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
56 }
57 
58 
59 /**
60 Contract function to receive approval and execute function in one call
61 Borrowed from MiniMeToken
62 */
63 contract ApproveAndCallFallBack {
64     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
65 }
66 
67 /**
68 ERC20 Token, with the addition of symbol, name and decimals and assisted token transfers
69 */
70 contract MCDCToken is ERC20Interface, SafeMath {
71     string public symbol;
72     string public  name;
73     uint8 public decimals;
74     uint public _totalSupply;
75 
76     mapping(address => uint) balances;
77     mapping(address => mapping(address => uint)) allowed;
78 
79 
80     // ------------------------------------------------------------------------
81     // Constructor
82     // ------------------------------------------------------------------------
83     constructor() public {
84         symbol = "MCDC";
85         name = "McDonaldsCoin";
86         decimals = 2;
87         _totalSupply = 3700000000;
88         balances[0x5b05140C34e9F46B059a95054dE6bec9a213E9F9] = _totalSupply;
89         emit Transfer(address(0), 0x5b05140C34e9F46B059a95054dE6bec9a213E9F9, _totalSupply);
90     }
91 
92 
93     // ------------------------------------------------------------------------
94     // Total supply
95     // ------------------------------------------------------------------------
96     function totalSupply() public constant returns (uint) {
97         return _totalSupply  - balances[address(0)];
98     }
99 
100 
101     // ------------------------------------------------------------------------
102     // Get the token balance for account tokenOwner
103     // ------------------------------------------------------------------------
104     function balanceOf(address tokenOwner) public constant returns (uint balance) {
105         return balances[tokenOwner];
106     }
107 
108 
109     // ------------------------------------------------------------------------
110     // Transfer the balance from token owner's account to to account
111     // - Owner's account must have sufficient balance to transfer
112     // - 0 value transfers are allowed
113     // ------------------------------------------------------------------------
114     function transfer(address to, uint tokens) public returns (bool success) {
115         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
116         balances[to] = safeAdd(balances[to], tokens);
117         emit Transfer(msg.sender, to, tokens);
118         return true;
119     }
120 
121 
122     // ------------------------------------------------------------------------
123     // Token owner can approve for spender to transferFrom(...) tokens
124     // from the token owner's account
125     //
126     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
127     // recommends that there are no checks for the approval double-spend attack
128     // as this should be implemented in user interfaces 
129     // ------------------------------------------------------------------------
130     function approve(address spender, uint tokens) public returns (bool success) {
131         allowed[msg.sender][spender] = tokens;
132         emit Approval(msg.sender, spender, tokens);
133         return true;
134     }
135 
136 
137     // ------------------------------------------------------------------------
138     // Transfer tokens from the from account to the to account
139     // 
140     // The calling account must already have sufficient tokens approve(...)-d
141     // for spending from the from account and
142     // - From account must have sufficient balance to transfer
143     // - Spender must have sufficient allowance to transfer
144     // - 0 value transfers are allowed
145     // ------------------------------------------------------------------------
146     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
147         balances[from] = safeSub(balances[from], tokens);
148         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
149         balances[to] = safeAdd(balances[to], tokens);
150         emit Transfer(from, to, tokens);
151         return true;
152     }
153 
154 
155     // ------------------------------------------------------------------------
156     // Returns the amount of tokens approved by the owner that can be
157     // transferred to the spender's account
158     // ------------------------------------------------------------------------
159     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
160         return allowed[tokenOwner][spender];
161     }
162 
163 
164     // ------------------------------------------------------------------------
165     // Token owner can approve for spender to transferFrom(...) tokens
166     // from the token owner's account. The spender contract function
167     // receiveApproval(...) is then executed
168     // ------------------------------------------------------------------------
169     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
170         allowed[msg.sender][spender] = tokens;
171         emit Approval(msg.sender, spender, tokens);
172         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
173         return true;
174     }
175 
176 
177     // ------------------------------------------------------------------------
178     // Don't accept ETH
179     // ------------------------------------------------------------------------
180     function () public payable {
181         revert();
182     }
183 }