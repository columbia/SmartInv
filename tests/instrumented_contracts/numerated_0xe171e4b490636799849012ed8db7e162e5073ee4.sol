1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // Web           : www.swaprol.com
5 // Symbol        : SWPRL
6 // Name          : Swaprol Token
7 // Max supply  : 100.000.000 SWPRL
8 // Decimals      : 18
9 // ----------------------------------------------------------------------------
10 // Swaprol Arbitrage Center for Cryptocurrency
11 // ----------------------------------------------------------------------------
12 contract SafeMath {
13 
14     function safeAdd(uint a, uint b) public pure returns (uint c) {
15         c = a + b;
16         require(c >= a);
17     }
18 
19     function safeSub(uint a, uint b) public pure returns (uint c) {
20         require(b <= a);
21         c = a - b;
22     }
23 
24     function safeMul(uint a, uint b) public pure returns (uint c) {
25         c = a * b;
26         require(a == 0 || c / a == b);
27     }
28 
29     function safeDiv(uint a, uint b) public pure returns (uint c) {
30         require(b > 0);
31         c = a / b;
32     }
33 }
34 
35 
36 /**
37 Swaprol Token Contract
38 */
39 contract ERC20Interface {
40     function totalSupply() public constant returns (uint);
41     function balanceOf(address tokenOwner) public constant returns (uint balance);
42     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
43     function transfer(address to, uint tokens) public returns (bool success);
44     function approve(address spender, uint tokens) public returns (bool success);
45     function transferFrom(address from, address to, uint tokens) public returns (bool success);
46 
47     event Transfer(address indexed from, address indexed to, uint tokens);
48     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
49 }
50 
51 
52 /**
53 Contract function to receive approval and execute function in one call
54 
55 */
56 contract ApproveAndCallFallBack {
57     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
58 }
59 
60 /**
61 ERC20 Token, with the addition of symbol, name and decimals and assisted token transfers
62 */
63 contract SWPRLToken is ERC20Interface, SafeMath {
64     string public symbol;
65     string public  name;
66     uint8 public decimals;
67     uint public _totalSupply;
68 
69     mapping(address => uint) balances;
70     mapping(address => mapping(address => uint)) allowed;
71 
72 
73     // ------------------------------------------------------------------------
74     // Constructor
75     // ------------------------------------------------------------------------
76     constructor() public {
77         symbol = "SWPRL";
78         name = "Swaprol Token";
79         decimals = 18;
80         _totalSupply = 100000000000000000000000000;
81         balances[0x6A0bBDAEBf82cEb3dBfF7Fc985B915e08D537822] = _totalSupply;
82         emit Transfer(address(0), 0x6A0bBDAEBf82cEb3dBfF7Fc985B915e08D537822, _totalSupply);
83     }
84 
85 
86     // ------------------------------------------------------------------------
87     // Total supply
88     // ------------------------------------------------------------------------
89     function totalSupply() public constant returns (uint) {
90         return _totalSupply  - balances[address(0)];
91     }
92 
93 
94     // ------------------------------------------------------------------------
95     // Get the token balance for account tokenOwner
96     // ------------------------------------------------------------------------
97     function balanceOf(address tokenOwner) public constant returns (uint balance) {
98         return balances[tokenOwner];
99     }
100 
101 
102     // ------------------------------------------------------------------------
103     // Transfer the balance from token owner's account to to account
104     // - Owner's account must have sufficient balance to transfer
105     // - 0 value transfers are allowed
106     // ------------------------------------------------------------------------
107     function transfer(address to, uint tokens) public returns (bool success) {
108         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
109         balances[to] = safeAdd(balances[to], tokens);
110         emit Transfer(msg.sender, to, tokens);
111         return true;
112     }
113 
114 
115     // ------------------------------------------------------------------------
116     // Token owner can approve for spender to transferFrom(...) tokens
117     // from the token owner's account
118     //
119     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
120     // recommends that there are no checks for the approval double-spend attack
121     // as this should be implemented in user interfaces 
122     // ------------------------------------------------------------------------
123     function approve(address spender, uint tokens) public returns (bool success) {
124         allowed[msg.sender][spender] = tokens;
125         emit Approval(msg.sender, spender, tokens);
126         return true;
127     }
128 
129 
130     // ------------------------------------------------------------------------
131     // Transfer tokens from the from account to the to account
132     // 
133     // The calling account must already have sufficient tokens approve(...)-d
134     // for spending from the from account and
135     // - From account must have sufficient balance to transfer
136     // - Spender must have sufficient allowance to transfer
137     // - 0 value transfers are allowed
138     // ------------------------------------------------------------------------
139     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
140         balances[from] = safeSub(balances[from], tokens);
141         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
142         balances[to] = safeAdd(balances[to], tokens);
143         emit Transfer(from, to, tokens);
144         return true;
145     }
146 
147 
148     // ------------------------------------------------------------------------
149     // Returns the amount of tokens approved by the owner that can be
150     // transferred to the spender's account
151     // ------------------------------------------------------------------------
152     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
153         return allowed[tokenOwner][spender];
154     }
155 
156 
157     // ------------------------------------------------------------------------
158     // Token owner can approve for spender to transferFrom(...) tokens
159     // from the token owner's account. The spender contract function
160     // receiveApproval(...) is then executed
161     // ------------------------------------------------------------------------
162     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
163         allowed[msg.sender][spender] = tokens;
164         emit Approval(msg.sender, spender, tokens);
165         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
166         return true;
167     }
168 
169 
170     // ------------------------------------------------------------------------
171     // Don't accept Ethereum
172     // ------------------------------------------------------------------------
173     function () public payable {
174         revert();
175     }
176 }