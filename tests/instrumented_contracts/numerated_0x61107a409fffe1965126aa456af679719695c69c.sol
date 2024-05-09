1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 //
5 // Symbol        : UMI
6 // Name          : UmiToken
7 // Total supply  : 33000000000000000000000000000
8 // Decimals      : 18
9 // Owner Account : 0x7EC37858e826D95eBC75574957371Dd90c2A2BFa
10 //
11 // NFTs to the moon.
12 //
13 // (c) by Umi Digital 2021 
14 // ----------------------------------------------------------------------------
15 
16 
17 // ----------------------------------------------------------------------------
18 // Lib: Safe Math
19 // ----------------------------------------------------------------------------
20 contract SafeMath {
21 
22     function safeAdd(uint a, uint b) public pure returns (uint c) {
23         c = a + b;
24         require(c >= a);
25     }
26 
27     function safeSub(uint a, uint b) public pure returns (uint c) {
28         require(b <= a);
29         c = a - b;
30     }
31 
32     function safeMul(uint a, uint b) public pure returns (uint c) {
33         c = a * b;
34         require(a == 0 || c / a == b);
35     }
36 
37     function safeDiv(uint a, uint b) public pure returns (uint c) {
38         require(b > 0);
39         c = a / b;
40     }
41 }
42 
43 
44 /**
45 ERC Token Standard #20 Interface
46 https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
47 */
48 contract ERC20Interface {
49     function totalSupply() public constant returns (uint);
50     function balanceOf(address tokenOwner) public constant returns (uint balance);
51     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
52     function transfer(address to, uint tokens) public returns (bool success);
53     function approve(address spender, uint tokens) public returns (bool success);
54     function transferFrom(address from, address to, uint tokens) public returns (bool success);
55 
56     event Transfer(address indexed from, address indexed to, uint tokens);
57     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
58 }
59 
60 
61 /**
62 Contract function to receive approval and execute function in one call
63 
64 Borrowed from MiniMeToken
65 */
66 contract ApproveAndCallFallBack {
67     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
68 }
69 
70 /**
71 ERC20 Token, with the addition of symbol, name and decimals and assisted token transfers
72 */
73 contract UMIToken is ERC20Interface, SafeMath {
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
87         symbol = "UMI";
88         name = "UmiToken";
89         decimals = 18;
90         _totalSupply = 33000000000000000000000000000;
91         balances[0x7EC37858e826D95eBC75574957371Dd90c2A2BFa] = _totalSupply;
92         emit Transfer(address(0), 0x7EC37858e826D95eBC75574957371Dd90c2A2BFa, _totalSupply);
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
129     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
130     // recommends that there are no checks for the approval double-spend attack
131     // as this should be implemented in user interfaces 
132     // ------------------------------------------------------------------------
133     function approve(address spender, uint tokens) public returns (bool success) {
134         allowed[msg.sender][spender] = tokens;
135         emit Approval(msg.sender, spender, tokens);
136         return true;
137     }
138 
139 
140     // ------------------------------------------------------------------------
141     // Transfer tokens from the from account to the to account
142     // 
143     // The calling account must already have sufficient tokens approve(...)-d
144     // for spending from the from account and
145     // - From account must have sufficient balance to transfer
146     // - Spender must have sufficient allowance to transfer
147     // - 0 value transfers are allowed
148     // ------------------------------------------------------------------------
149     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
150         balances[from] = safeSub(balances[from], tokens);
151         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
152         balances[to] = safeAdd(balances[to], tokens);
153         emit Transfer(from, to, tokens);
154         return true;
155     }
156 
157 
158     // ------------------------------------------------------------------------
159     // Returns the amount of tokens approved by the owner that can be
160     // transferred to the spender's account
161     // ------------------------------------------------------------------------
162     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
163         return allowed[tokenOwner][spender];
164     }
165 
166 
167     // ------------------------------------------------------------------------
168     // Token owner can approve for spender to transferFrom(...) tokens
169     // from the token owner's account. The spender contract function
170     // receiveApproval(...) is then executed
171     // ------------------------------------------------------------------------
172     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
173         allowed[msg.sender][spender] = tokens;
174         emit Approval(msg.sender, spender, tokens);
175         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
176         return true;
177     }
178 
179 
180     // ------------------------------------------------------------------------
181     // Don't accept ETH
182     // ------------------------------------------------------------------------
183     function () public payable {
184         revert();
185     }
186 }