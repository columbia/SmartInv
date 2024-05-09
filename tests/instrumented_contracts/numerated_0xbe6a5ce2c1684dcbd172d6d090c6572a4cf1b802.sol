1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'QUANTUM INTELLIGENCE' token contract
5 //
6 // Deployed to : 0x0b08D6AdfEC2d06Aec653Ae7Fc2830894e02D23b
7 // Symbol      : QI
8 // Name        : QUANTUM INTELLIGENCE 
9 // Total supply: 2100000000
10 // Decimals    : 18
11 //
12 // Enjoy.
13 // 
14 //######## QUANTUM INTELLIGENCE ##########
15 //
16 //     The symbol will be: QI
17 //     QUANTUM INTELLIGENCE Offer of 2 Billion and 100 Million tokens
18 //     Company Quantum Intelligence Canada
19 //      Quantum Intelligence QI Revolution
20 //
21 // 
22 // (c) by http://quantum-intelligence.io/
23 // ----------------------------------------------------------------------------
24 
25 
26 // ----------------------------------------------------------------------------
27 // Safe maths
28 // ----------------------------------------------------------------------------
29 contract SafeMath {
30     function safeAdd(uint a, uint b) public pure returns (uint c) {
31         c = a + b;
32         require(c >= a);
33     }
34     function safeSub(uint a, uint b) public pure returns (uint c) {
35         require(b <= a);
36         c = a - b;
37     }
38     function safeMul(uint a, uint b) public pure returns (uint c) {
39         c = a * b;
40         require(a == 0 || c / a == b);
41     }
42     function safeDiv(uint a, uint b) public pure returns (uint c) {
43         require(b > 0);
44         c = a / b;
45     }
46 }
47 
48 
49 // ----------------------------------------------------------------------------
50 // ERC Token Standard #20 Interface
51 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
52 // ----------------------------------------------------------------------------
53 contract ERC20Interface {
54     function totalSupply() public constant returns (uint);
55     function balanceOf(address tokenOwner) public constant returns (uint balance);
56     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
57     function transfer(address to, uint tokens) public returns (bool success);
58     function approve(address spender, uint tokens) public returns (bool success);
59     function transferFrom(address from, address to, uint tokens) public returns (bool success);
60 
61     event Transfer(address indexed from, address indexed to, uint tokens);
62     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
63 }
64 
65 
66 // ----------------------------------------------------------------------------
67 // Contract function to receive approval and execute function in one call
68 //
69 // Borrowed from MiniMeToken
70 // ----------------------------------------------------------------------------
71 contract ApproveAndCallFallBack {
72     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
73 }
74 
75 
76 // ----------------------------------------------------------------------------
77 // Owned contract
78 // ----------------------------------------------------------------------------
79 contract Owned {
80     address public owner;
81     address public newOwner;
82 
83     event OwnershipTransferred(address indexed _from, address indexed _to);
84 
85     constructor() public {
86         owner = msg.sender;
87     }
88 
89     modifier onlyOwner {
90         require(msg.sender == owner);
91         _;
92     }
93 
94     function transferOwnership(address _newOwner) public onlyOwner {
95         newOwner = _newOwner;
96     }
97     function acceptOwnership() public {
98         require(msg.sender == newOwner);
99         emit OwnershipTransferred(owner, newOwner);
100         owner = newOwner;
101         newOwner = address(0);
102     }
103 }
104 
105 
106 // ----------------------------------------------------------------------------
107 // ERC20 Token, with the addition of symbol, name and decimals and assisted
108 // token transfers
109 // ----------------------------------------------------------------------------
110 contract  QUANTUM_INTELLIGENCE is ERC20Interface, Owned, SafeMath {
111     string public symbol;
112     string public  name;
113     uint8 public decimals;
114     uint public _totalSupply;
115 
116     mapping(address => uint) balances;
117     mapping(address => mapping(address => uint)) allowed;
118 
119 
120     // ------------------------------------------------------------------------
121     // Constructor
122     // ------------------------------------------------------------------------
123     constructor() public {
124         symbol = "QI";
125         name = "QUANTUM INTELLIGENCE";
126         decimals = 18;
127         _totalSupply = 2100000000000000000000000000;
128         balances[0x0b08D6AdfEC2d06Aec653Ae7Fc2830894e02D23b] = _totalSupply;
129         emit Transfer(address(0), 0x0b08D6AdfEC2d06Aec653Ae7Fc2830894e02D23b, _totalSupply);
130     }
131 
132 
133     // ------------------------------------------------------------------------
134     // Total supply
135     // ------------------------------------------------------------------------
136     function totalSupply() public constant returns (uint) {
137         return _totalSupply  - balances[address(0)];
138     }
139 
140 
141     // ------------------------------------------------------------------------
142     // Get the token balance for account tokenOwner
143     // ------------------------------------------------------------------------
144     function balanceOf(address tokenOwner) public constant returns (uint balance) {
145         return balances[tokenOwner];
146     }
147 
148 
149     // ------------------------------------------------------------------------
150     // Transfer the balance from token owner's account to to account
151     // - Owner's account must have sufficient balance to transfer
152     // - 0 value transfers are allowed
153     // ------------------------------------------------------------------------
154     function transfer(address to, uint tokens) public returns (bool success) {
155         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
156         balances[to] = safeAdd(balances[to], tokens);
157         emit Transfer(msg.sender, to, tokens);
158         return true;
159     }
160 
161 
162     // ------------------------------------------------------------------------
163     // Token owner can approve for spender to transferFrom(...) tokens
164     // from the token owner's account
165     //
166     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
167     // recommends that there are no checks for the approval double-spend attack
168     // as this should be implemented in user interfaces 
169     // ------------------------------------------------------------------------
170     function approve(address spender, uint tokens) public returns (bool success) {
171         allowed[msg.sender][spender] = tokens;
172         emit Approval(msg.sender, spender, tokens);
173         return true;
174     }
175 
176 
177     // ------------------------------------------------------------------------
178     // Transfer tokens from the from account to the to account
179     // 
180     // The calling account must already have sufficient tokens approve(...)-d
181     // for spending from the from account and
182     // - From account must have sufficient balance to transfer
183     // - Spender must have sufficient allowance to transfer
184     // - 0 value transfers are allowed
185     // ------------------------------------------------------------------------
186     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
187         balances[from] = safeSub(balances[from], tokens);
188         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
189         balances[to] = safeAdd(balances[to], tokens);
190         emit Transfer(from, to, tokens);
191         return true;
192     }
193 
194 
195     // ------------------------------------------------------------------------
196     // Returns the amount of tokens approved by the owner that can be
197     // transferred to the spender's account
198     // ------------------------------------------------------------------------
199     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
200         return allowed[tokenOwner][spender];
201     }
202 
203 
204     // ------------------------------------------------------------------------
205     // Token owner can approve for spender to transferFrom(...) tokens
206     // from the token owner's account. The spender contract function
207     // receiveApproval(...) is then executed
208     // ------------------------------------------------------------------------
209     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
210         allowed[msg.sender][spender] = tokens;
211         emit Approval(msg.sender, spender, tokens);
212         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
213         return true;
214     }
215 
216 
217     // ------------------------------------------------------------------------
218     // Don't accept ETH
219     // ------------------------------------------------------------------------
220     function () public payable {
221         revert();
222     }
223 
224 
225     // ------------------------------------------------------------------------
226     // Owner can transfer out any accidentally sent ERC20 tokens
227     // ------------------------------------------------------------------------
228     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
229         return ERC20Interface(tokenAddress).transfer(owner, tokens);
230     }
231 }