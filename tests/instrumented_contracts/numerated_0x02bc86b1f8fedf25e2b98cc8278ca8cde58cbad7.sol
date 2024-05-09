1 pragma solidity 0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // DRIFE token contract
5 //
6 // Symbol      : DRF
7 // Name        : DRIFE Token
8 // Total supply: 325000000
9 // Decimals    : 18
10 //
11 // ----------------------------------------------------------------------------
12 
13 
14 // ----------------------------------------------------------------------------
15 // Safe maths
16 // ----------------------------------------------------------------------------
17 contract SafeMath {
18     function safeAdd(uint a, uint b) public pure returns (uint c) {
19         c = a + b;
20         require(c >= a);
21     }
22     function safeSub(uint a, uint b) public pure returns (uint c) {
23         require(b <= a);
24         c = a - b;
25     }
26     function safeMul(uint a, uint b) public pure returns (uint c) {
27         c = a * b;
28         require(a == 0 || c / a == b);
29     }
30     function safeDiv(uint a, uint b) public pure returns (uint c) {
31         require(b > 0);
32         c = a / b;
33     }
34 }
35 
36 
37 // ----------------------------------------------------------------------------
38 // ERC Token Standard #20 Interface
39 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
40 // ----------------------------------------------------------------------------
41 contract ERC20Interface {
42 
43     function totalSupply() public view returns (uint);
44     function balanceOf(address tokenOwner) public view returns (uint balance);
45     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
46     function transfer(address to, uint tokens) public returns (bool success);
47     function approve(address spender, uint tokens) public returns (bool success);
48     function transferFrom(address from, address to, uint tokens) public returns (bool success);
49 
50     event Transfer(address indexed from, address indexed to, uint tokens);
51     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
52 }
53 
54 
55 // ----------------------------------------------------------------------------
56 // Contract function to receive approval and execute function in one call
57 // ----------------------------------------------------------------------------
58 contract ApproveAndCallFallBack {
59     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
60 }
61 
62 
63 // ----------------------------------------------------------------------------
64 // DRIFE ERC20 Token
65 // ----------------------------------------------------------------------------
66 contract DrifeToken is ERC20Interface, SafeMath {
67     string public symbol;
68     string public  name;
69     uint8 public decimals;
70     uint public _totalSupply;
71 
72     mapping(address => uint) public balances;
73     mapping(address => mapping(address => uint)) public allowed;
74 
75 
76     // ------------------------------------------------------------------------
77     // Constructor
78     // ------------------------------------------------------------------------
79     constructor() public {
80         symbol = "DRF";
81         name = "DRIFE";
82         decimals = 18;
83         _totalSupply = 325000000000000000000000000;
84         balances[msg.sender] = _totalSupply;
85     }
86 
87 
88     // ------------------------------------------------------------------------
89     // Total supply
90     // ------------------------------------------------------------------------
91     function totalSupply() public view returns (uint) {
92         return _totalSupply  - balances[address(0)];
93     }
94 
95 
96     // ------------------------------------------------------------------------
97     // Get the token balance for account tokenOwner
98     // ------------------------------------------------------------------------
99     function balanceOf(address tokenOwner) public view returns (uint balance) {
100         return balances[tokenOwner];
101     }
102 
103 
104     // ------------------------------------------------------------------------
105     // Transfer the balance from token owner's account to 'to' account
106     // - Owner's account must have sufficient balance to transfer
107     // - 0 value transfers are allowed
108     // ------------------------------------------------------------------------
109     function transfer(address to, uint tokens) public returns (bool success) {
110         require(to != address(0));
111         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
112         balances[to] = safeAdd(balances[to], tokens);
113         emit Transfer(msg.sender, to, tokens);
114         return true;
115     }
116 
117 
118     // ------------------------------------------------------------------------
119     // Token owner can approve for spender to transferFrom(...) tokens
120     // from the token owner's account
121     //
122     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
123     // recommends that there are no checks for the approval double-spend attack
124     // as this should be implemented in user interfaces 
125     // ------------------------------------------------------------------------
126     function approve(address spender, uint tokens) public returns (bool success) {
127         require(spender != address(0));
128         require(tokens <= balances[msg.sender]);
129         allowed[msg.sender][spender] = tokens;
130         emit Approval(msg.sender, spender, tokens);
131         return true;
132     }
133 
134 
135     // ------------------------------------------------------------------------
136     // Transfer tokens  from the 'from' account to the 'to' account
137     // 
138     // NOTE: The calling account must already have sufficient tokens approve(...)-d
139     // for spending from the 'from' account and
140     // - 'From' account must have sufficient balance to transfer
141     // - Spender must have sufficient allowance to transfer
142     // - 0 value transfers are allowed
143     // ------------------------------------------------------------------------
144     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
145         require(from != address(0));
146         require(to != address(0));        
147         require(tokens <= balances[from]);
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
160     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
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
171         require(spender != address(0));
172         require(tokens <= balances[msg.sender]);
173         allowed[msg.sender][spender] = tokens;
174         emit Approval(msg.sender, spender, tokens);
175         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
176         return true;
177     }
178 
179     // ------------------------------------------------------------------------
180     // Fallback function - Don't accept ETH, revert txn
181     // ------------------------------------------------------------------------
182     function () public payable {
183         revert();
184     }
185 
186 }