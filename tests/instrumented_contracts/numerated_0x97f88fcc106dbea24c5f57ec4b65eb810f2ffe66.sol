1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // Sample token contract
5 //
6 // Symbol        : IEC
7 // Name          : Island Economics
8 // Total supply  : 30000000000000000
9 // Decimals      : 10
10 // Owner Account : 0x6e1A3b3c1FAF05b50A2c6d72140830E1c2bBc938
11 //
12 //
13 // ----------------------------------------------------------------------------
14 
15 
16 // ----------------------------------------------------------------------------
17 // Lib: Safe Math
18 // ----------------------------------------------------------------------------
19 contract SafeMath {
20 
21     function safeAdd(uint a, uint b) public pure returns (uint c) {
22         c = a + b;
23         require(c >= a);
24     }
25 
26     function safeSub(uint a, uint b) public pure returns (uint c) {
27         require(b <= a);
28         c = a - b;
29     }
30 
31     function safeMul(uint a, uint b) public pure returns (uint c) {
32         c = a * b;
33         require(a == 0 || c / a == b);
34     }
35 
36     function safeDiv(uint a, uint b) public pure returns (uint c) {
37         require(b > 0);
38         c = a / b;
39     }
40 }
41 
42 
43 /**
44 ERC Token Standard #20 Interface
45 https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
46 */
47 contract ERC20Interface {
48     function totalSupply() public constant returns (uint);
49     function balanceOf(address tokenOwner) public constant returns (uint balance);
50     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
51     function transfer(address to, uint tokens) public returns (bool success);
52     function approve(address spender, uint tokens) public returns (bool success);
53     function transferFrom(address from, address to, uint tokens) public returns (bool success);
54 
55     event Transfer(address indexed from, address indexed to, uint tokens);
56     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
57 }
58 
59 
60 /**
61 Contract function to receive approval and execute function in one call
62 Borrowed from MiniMeToken
63 */
64 contract ApproveAndCallFallBack {
65     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
66 }
67 
68 /**
69 ERC20 Token, with the addition of symbol, name and decimals and assisted token transfers
70 */
71 contract IECToken is ERC20Interface, SafeMath {
72     string public symbol;
73     string public  name;
74     uint8 public decimals;
75     uint public _totalSupply;
76 
77     mapping(address => uint) balances;
78     mapping(address => mapping(address => uint)) allowed;
79 
80 
81     // ------------------------------------------------------------------------
82     // Constructor
83     // ------------------------------------------------------------------------
84     constructor() public {
85         symbol = "IEC";
86         name = "Island Economics";
87         decimals = 10;
88         _totalSupply = 30000000000000000;
89         balances[0x6e1A3b3c1FAF05b50A2c6d72140830E1c2bBc938] = _totalSupply;
90         emit Transfer(address(0), 0x6e1A3b3c1FAF05b50A2c6d72140830E1c2bBc938, _totalSupply);
91     }
92 
93 
94     // ------------------------------------------------------------------------
95     // Total supply
96     // ------------------------------------------------------------------------
97     function totalSupply() public constant returns (uint) {
98         return _totalSupply  - balances[address(0)];
99     }
100 
101 
102     // ------------------------------------------------------------------------
103     // Get the token balance for account tokenOwner
104     // ------------------------------------------------------------------------
105     function balanceOf(address tokenOwner) public constant returns (uint balance) {
106         return balances[tokenOwner];
107     }
108 
109 
110     // ------------------------------------------------------------------------
111     // Transfer the balance from token owner's account to to account
112     // - Owner's account must have sufficient balance to transfer
113     // - 0 value transfers are allowed
114     // ------------------------------------------------------------------------
115     function transfer(address to, uint tokens) public returns (bool success) {
116         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
117         balances[to] = safeAdd(balances[to], tokens);
118         emit Transfer(msg.sender, to, tokens);
119         return true;
120     }
121 
122 
123     // ------------------------------------------------------------------------
124     // Token owner can approve for spender to transferFrom(...) tokens
125     // from the token owner's account
126     //
127     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
128     // recommends that there are no checks for the approval double-spend attack
129     // as this should be implemented in user interfaces 
130     // ------------------------------------------------------------------------
131     function approve(address spender, uint tokens) public returns (bool success) {
132         allowed[msg.sender][spender] = tokens;
133         emit Approval(msg.sender, spender, tokens);
134         return true;
135     }
136 
137 
138     // ------------------------------------------------------------------------
139     // Transfer tokens from the from account to the to account
140     // 
141     // The calling account must already have sufficient tokens approve(...)-d
142     // for spending from the from account and
143     // - From account must have sufficient balance to transfer
144     // - Spender must have sufficient allowance to transfer
145     // - 0 value transfers are allowed
146     // ------------------------------------------------------------------------
147     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
148         balances[from] = safeSub(balances[from], tokens);
149         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
150         balances[to] = safeAdd(balances[to], tokens);
151         emit Transfer(from, to, tokens);
152         return true;
153     }
154 
155 
156     // ------------------------------------------------------------------------
157     // Returns the amount of tokens approved by the owner that can be
158     // transferred to the spender's account
159     // ------------------------------------------------------------------------
160     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
161         return allowed[tokenOwner][spender];
162     }
163 
164 
165     // ------------------------------------------------------------------------
166     // Token owner can approve for spender to transferFrom(...) tokens
167     // from the token owner's account. The spender contract function
168     // receiveApproval(...) is then executed
169     // ------------------------------------------------------------------------
170     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
171         allowed[msg.sender][spender] = tokens;
172         emit Approval(msg.sender, spender, tokens);
173         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
174         return true;
175     }
176 
177 
178     // ------------------------------------------------------------------------
179     // Don't accept ETH
180     // ------------------------------------------------------------------------
181     function () public payable {
182         revert();
183     }
184 }