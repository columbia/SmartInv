1 pragma solidity ^0.4.24;
2 
3 contract Expirable {
4     uint public expireAfter;
5 
6     function isExpired() public view returns (bool expire) {
7         /* solium-disable-next-line */
8         return block.timestamp > expireAfter;
9     }
10 }
11 
12 // ----------------------------------------------------------------------------
13 // Safe maths
14 // ----------------------------------------------------------------------------
15 contract SafeMath {
16     function safeAdd(uint a, uint b) public pure returns (uint c) {
17         c = a + b;
18         require(c >= a, "Safe ADD check");
19     }
20     function safeSub(uint a, uint b) public pure returns (uint c) {
21         require(b <= a, "Safe SUB check");
22         c = a - b;
23     }
24     function safeMul(uint a, uint b) public pure returns (uint c) {
25         c = a * b;
26         require(a == 0 || c / a == b, "Safe MUL check");
27     }
28     function safeDiv(uint a, uint b) public pure returns (uint c) {
29         require(b > 0, "Safe DIV check");
30         c = a / b;
31     }
32 }
33 
34 
35 // ----------------------------------------------------------------------------
36 // Contract function to receive approval and execute function in one call
37 //
38 // Borrowed from MiniMeToken
39 // ----------------------------------------------------------------------------
40 contract ApproveAndCallFallback {
41     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
42 }
43 
44 
45 
46 // ----------------------------------------------------------------------------
47 // Owned contract
48 // ----------------------------------------------------------------------------
49 contract Owned {
50     address public owner;
51     address public newOwner;
52 
53     event OwnershipTransferred(address indexed _from, address indexed _to);
54 
55     constructor() public {
56         owner = msg.sender;
57     }
58 
59     modifier onlyOwner {
60         require(msg.sender == owner, "Only owner allowed");
61         _;
62     }
63 
64     function transferOwnership(address _newOwner) public onlyOwner {
65         newOwner = _newOwner;
66     }
67 
68     function acceptOwnership() public {
69         require(msg.sender == newOwner, "Only owner allowed");
70         emit OwnershipTransferred(owner, newOwner);
71         owner = newOwner;
72         newOwner = address(0);
73     }
74 }
75 
76 
77 // ----------------------------------------------------------------------------
78 // ERC Token Standard #20 Interface
79 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
80 // ----------------------------------------------------------------------------
81 contract ERC20Interface {
82     function totalSupply() public view returns (uint);
83     function balanceOf(address tokenOwner) public view returns (uint balance);
84     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
85     function transfer(address to, uint tokens) public returns (bool success);
86     function approve(address spender, uint tokens) public returns (bool success);
87     function transferFrom(address from, address to, uint tokens) public returns (bool success);
88 
89     event Transfer(address indexed from, address indexed to, uint tokens);
90     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
91 }
92 
93 
94 // ----------------------------------------------------------------------------
95 // 'EcoToken' token contract
96 //
97 // Deployed to : 0x37efd6a702E171218380cf6B1f898A07632A7d60
98 // Symbol      : ECO
99 // Name        : ECO Token for NEC2018
100 // Total supply: 100000000
101 // Decimals    : 0
102 //
103 // Enjoy.
104 //
105 // (c) by Moritz Neto with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
106 // (c) by Rakuraku Jyo
107 // ----------------------------------------------------------------------------
108 
109 
110 
111 
112 
113 
114 
115 
116 // ----------------------------------------------------------------------------
117 // ERC20 Token, with the addition of symbol, name and decimals and assisted
118 // token transfers
119 // ----------------------------------------------------------------------------
120 contract EcoToken is ERC20Interface, Owned, SafeMath, Expirable {
121     string public symbol;
122     string public name;
123     uint8 public decimals;
124     uint public _totalSupply;
125 
126     mapping(address => uint) balances;
127     mapping(address => mapping(address => uint)) allowed;
128 
129 
130     // ------------------------------------------------------------------------
131     // Constructor
132     // ------------------------------------------------------------------------
133     constructor() public {
134         symbol = "ECO";
135         name = "ECO Token for NEC2018";
136         decimals = 2;
137         uint base = 10;
138         _totalSupply = 100000000 * (base ** decimals);
139         /* solium-disable-next-line */
140         expireAfter = block.timestamp + 86400 * 30; // valid for 30 days
141 
142         balances[msg.sender] = _totalSupply;
143         emit Transfer(address(0), msg.sender, _totalSupply);
144     }
145 
146 
147     // ------------------------------------------------------------------------
148     // Total supply
149     // ------------------------------------------------------------------------
150     function totalSupply() public view returns (uint) {
151         return _totalSupply - balances[address(0)];
152     }
153 
154 
155     // ------------------------------------------------------------------------
156     // Get the token balance for account tokenOwner
157     // ------------------------------------------------------------------------
158     function balanceOf(address tokenOwner) public view returns (uint balance) {
159         return balances[tokenOwner];
160     }
161 
162 
163     // ------------------------------------------------------------------------
164     // Transfer the balance from token owner's account to to account
165     // - Owner's account must have sufficient balance to transfer
166     // - 0 value transfers are allowed
167     // ------------------------------------------------------------------------
168     function transfer(address to, uint tokens) public returns (bool success) {
169         require(!isExpired(), "The token is expired");
170         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
171         balances[to] = safeAdd(balances[to], tokens);
172         emit Transfer(msg.sender, to, tokens);
173         return true;
174     }
175 
176 
177     // ------------------------------------------------------------------------
178     // Token owner can approve for spender to transferFrom(...) tokens
179     // from the token owner's account
180     //
181     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
182     // recommends that there are no checks for the approval double-spend attack
183     // as this should be implemented in user interfaces
184     // ------------------------------------------------------------------------
185     function approve(address spender, uint tokens) public returns (bool success) {
186         allowed[msg.sender][spender] = tokens;
187         emit Approval(msg.sender, spender, tokens);
188         return true;
189     }
190 
191 
192     // ------------------------------------------------------------------------
193     // Transfer tokens from the from account to the to account
194     //
195     // The calling account must already have sufficient tokens approve(...)-d
196     // for spending from the from account and
197     // - From account must have sufficient balance to transfer
198     // - Spender must have sufficient allowance to transfer
199     // - 0 value transfers are allowed
200     // ------------------------------------------------------------------------
201     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
202         balances[from] = safeSub(balances[from], tokens);
203         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
204         balances[to] = safeAdd(balances[to], tokens);
205         emit Transfer(from, to, tokens);
206         return true;
207     }
208 
209 
210     // ------------------------------------------------------------------------
211     // Returns the amount of tokens approved by the owner that can be
212     // transferred to the spender's account
213     // ------------------------------------------------------------------------
214     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
215         return allowed[tokenOwner][spender];
216     }
217 
218 
219     // ------------------------------------------------------------------------
220     // Token owner can approve for spender to transferFrom(...) tokens
221     // from the token owner's account. The spender contract function
222     // receiveApproval(...) is then executed
223     // ------------------------------------------------------------------------
224     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
225         allowed[msg.sender][spender] = tokens;
226         emit Approval(msg.sender, spender, tokens);
227         ApproveAndCallFallback(spender).receiveApproval(msg.sender, tokens, this, data);
228         return true;
229     }
230 
231 
232     // ------------------------------------------------------------------------
233     // Don't accept ETH
234     // ------------------------------------------------------------------------
235     function () public payable {
236         revert("ETH not acceptable");
237     }
238 
239 
240     // ------------------------------------------------------------------------
241     // Owner can transfer out any accidentally sent ERC20 tokens
242     // ------------------------------------------------------------------------
243     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
244         return ERC20Interface(tokenAddress).transfer(owner, tokens);
245     }
246 }