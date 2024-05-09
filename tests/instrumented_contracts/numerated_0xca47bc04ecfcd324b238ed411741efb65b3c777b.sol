1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // Lib: Safe Math
5 // ----------------------------------------------------------------------------
6 contract SafeMath {
7 
8     function safeAdd(uint a, uint b) public pure returns (uint c) {
9         c = a + b;
10         require(c >= a);
11     }
12 
13     function safeSub(uint a, uint b) public pure returns (uint c) {
14         require(b <= a);
15         c = a - b;
16     }
17 
18     function safeMul(uint a, uint b) public pure returns (uint c) {
19         c = a * b;
20         require(a == 0 || c / a == b);
21     }
22 
23     function safeDiv(uint a, uint b) public pure returns (uint c) {
24         require(b > 0);
25         c = a / b;
26     }
27 }
28 
29 
30 /**
31 ERC Token Standard #20 Interface
32 https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
33 */
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
46 
47 /**
48 Contract function to receive approval and execute function in one call
49 */
50 contract ApproveAndCallFallBack {
51     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
52 }
53 
54 /**
55 ERC20 Token, with the addition of symbol, name and decimals and assisted token transfers
56 */
57 contract EcoinNetworkToken is ERC20Interface, SafeMath {
58     string public symbol;
59     string public  name;
60     uint8 public decimals;
61     uint public _totalSupply;
62 
63     mapping(address => uint) balances;
64     mapping(address => mapping(address => uint)) allowed;
65 
66 
67     // ------------------------------------------------------------------------
68     // Constructor
69     // ------------------------------------------------------------------------
70     constructor() public {
71         symbol = "ECN";
72         name = "ECOIN NETWORK";
73         decimals = 8;
74         _totalSupply = 27000000000000000;
75         balances[0xd90fCAb452F65C97d23bB91a7406A85cD3F75Fd6] = _totalSupply;
76         emit Transfer(address(0), 0xd90fCAb452F65C97d23bB91a7406A85cD3F75Fd6, _totalSupply);
77     }
78 
79 
80     // ------------------------------------------------------------------------
81     // Total supply
82     // ------------------------------------------------------------------------
83     function totalSupply() public constant returns (uint) {
84         return _totalSupply  - balances[address(0)];
85     }
86 
87 
88     // ------------------------------------------------------------------------
89     // Get the token balance for account tokenOwner
90     // ------------------------------------------------------------------------
91     function balanceOf(address tokenOwner) public constant returns (uint balance) {
92         return balances[tokenOwner];
93     }
94 
95 
96     // ------------------------------------------------------------------------
97     // Transfer the balance from token owner's account to to account
98     // - Owner's account must have sufficient balance to transfer
99     // - 0 value transfers are allowed
100     // ------------------------------------------------------------------------
101     function transfer(address to, uint tokens) public returns (bool success) {
102         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
103         balances[to] = safeAdd(balances[to], tokens);
104         emit Transfer(msg.sender, to, tokens);
105         return true;
106     }
107 
108 
109     // ------------------------------------------------------------------------
110     // Token owner can approve for spender to transferFrom(...) tokens
111     // from the token owner's account
112     //
113     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
114     // recommends that there are no checks for the approval double-spend attack
115     // as this should be implemented in user interfaces
116     // ------------------------------------------------------------------------
117     function approve(address spender, uint tokens) public returns (bool success) {
118         allowed[msg.sender][spender] = tokens;
119         emit Approval(msg.sender, spender, tokens);
120         return true;
121     }
122 
123 
124     // ------------------------------------------------------------------------
125     // Transfer tokens from the from account to the to account
126     //
127     // The calling account must already have sufficient tokens approve(...)-d
128     // for spending from the from account and
129     // - From account must have sufficient balance to transfer
130     // - Spender must have sufficient allowance to transfer
131     // - 0 value transfers are allowed
132     // ------------------------------------------------------------------------
133     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
134         balances[from] = safeSub(balances[from], tokens);
135         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
136         balances[to] = safeAdd(balances[to], tokens);
137         emit Transfer(from, to, tokens);
138         return true;
139     }
140 
141 
142     // ------------------------------------------------------------------------
143     // Returns the amount of tokens approved by the owner that can be
144     // transferred to the spender's account
145     // ------------------------------------------------------------------------
146     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
147         return allowed[tokenOwner][spender];
148     }
149 
150 
151     // ------------------------------------------------------------------------
152     // Token owner can approve for spender to transferFrom(...) tokens
153     // from the token owner's account. The spender contract function
154     // receiveApproval(...) is then executed
155     // ------------------------------------------------------------------------
156     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
157         allowed[msg.sender][spender] = tokens;
158         emit Approval(msg.sender, spender, tokens);
159         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
160         return true;
161     }
162 
163 
164     // ------------------------------------------------------------------------
165     // Don't accept ETH
166     // ------------------------------------------------------------------------
167     function () public payable {
168         revert();
169     }
170 }