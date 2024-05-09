1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 contract SafeMath {
7     function safeAdd(uint a, uint b) public pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function safeSub(uint a, uint b) public pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function safeMul(uint a, uint b) public pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function safeDiv(uint a, uint b) public pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 
26 // ----------------------------------------------------------------------------
27 // ERC Token Standard #20 Interface
28 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
29 // ----------------------------------------------------------------------------
30 contract ERC20Interface {
31     function totalSupply() public constant returns (uint);
32     function balanceOf(address tokenOwner) public constant returns (uint balance);
33     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
34     function transfer(address to, uint tokens) public returns (bool success);
35     function approve(address spender, uint tokens) public returns (bool success);
36     function transferFrom(address from, address to, uint tokens) public returns (bool success);
37 
38     event Transfer(address indexed from, address indexed to, uint tokens);
39     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
40 }
41 
42 
43 // ----------------------------------------------------------------------------
44 // Contract function to receive approval and execute function in one call
45 //
46 // ----------------------------------------------------------------------------
47 contract ApproveAndCallFallBack {
48     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
49 }
50 
51 
52 // ----------------------------------------------------------------------------
53 // ERC20 Token, with the addition of symbol, name and decimals and assisted
54 // token transfers
55 // ----------------------------------------------------------------------------
56 contract AST is ERC20Interface, SafeMath {
57     string public symbol;
58     string public  name;
59     uint8 public decimals;
60     uint public _totalSupply;
61 
62     mapping(address => uint) balances;
63     mapping(address => mapping(address => uint)) allowed;
64 
65 
66     // ------------------------------------------------------------------------
67     // Constructor
68     // ------------------------------------------------------------------------
69     function AST() public {
70         symbol = "AST";
71         name = "Asia Token";
72         decimals = 18;
73         _totalSupply = 1000000000000000000000000000;
74         balances[0xb5F1675a1dee34A276D2AaCfD97D134e6569C620] = _totalSupply;
75         Transfer(address(0), 0xb5F1675a1dee34A276D2AaCfD97D134e6569C620, _totalSupply);
76     }
77 
78 
79     // ------------------------------------------------------------------------
80     // Total supply
81     // ------------------------------------------------------------------------
82     function totalSupply() public constant returns (uint) {
83         return _totalSupply  - balances[address(0)];
84     }
85 
86 
87     // ------------------------------------------------------------------------
88     // Get the token balance for account tokenOwner
89     // ------------------------------------------------------------------------
90     function balanceOf(address tokenOwner) public constant returns (uint balance) {
91         return balances[tokenOwner];
92     }
93 
94 
95     // ------------------------------------------------------------------------
96     // Transfer the balance from token owner's account to to account
97     // - Owner's account must have sufficient balance to transfer
98     // - 0 value transfers are allowed
99     // ------------------------------------------------------------------------
100     function transfer(address to, uint tokens) public returns (bool success) {
101         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
102         balances[to] = safeAdd(balances[to], tokens);
103         Transfer(msg.sender, to, tokens);
104         return true;
105     }
106 
107 
108     // ------------------------------------------------------------------------
109     // Token owner can approve for spender to transferFrom(...) tokens
110     // from the token owner's account
111     //
112     // recommends that there are no checks for the approval double-spend attack
113     // as this should be implemented in user interfaces 
114     // ------------------------------------------------------------------------
115     function approve(address spender, uint tokens) public returns (bool success) {
116         allowed[msg.sender][spender] = tokens;
117         Approval(msg.sender, spender, tokens);
118         return true;
119     }
120 
121 
122     // ------------------------------------------------------------------------
123     // Transfer tokens from the from account to the to account
124     // 
125     // The calling account must already have sufficient tokens approve(...)-d
126     // for spending from the from account and
127     // - From account must have sufficient balance to transfer
128     // - Spender must have sufficient allowance to transfer
129     // - 0 value transfers are allowed
130     // ------------------------------------------------------------------------
131     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
132         balances[from] = safeSub(balances[from], tokens);
133         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
134         balances[to] = safeAdd(balances[to], tokens);
135         Transfer(from, to, tokens);
136         return true;
137     }
138 
139 
140     // ------------------------------------------------------------------------
141     // Returns the amount of tokens approved by the owner that can be
142     // transferred to the spender's account
143     // ------------------------------------------------------------------------
144     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
145         return allowed[tokenOwner][spender];
146     }
147 
148 
149     // ------------------------------------------------------------------------
150     // Token owner can approve for spender to transferFrom(...) tokens
151     // from the token owner's account. The spender contract function
152     // receiveApproval(...) is then executed
153     // ------------------------------------------------------------------------
154     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
155         allowed[msg.sender][spender] = tokens;
156         Approval(msg.sender, spender, tokens);
157         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
158         return true;
159     }
160 
161 
162     // ------------------------------------------------------------------------
163     // Don't accept ETH
164     // ------------------------------------------------------------------------
165     function () public payable {
166         revert();
167     }
168 
169 }