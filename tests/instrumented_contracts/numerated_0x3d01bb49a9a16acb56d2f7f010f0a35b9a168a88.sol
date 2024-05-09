1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'subsistancetoken' CROWDSALE token contract
5 //
6 // Deployed to : 0x5d249e86a41742836c8bb1231a596615aF70DCD9
7 // Symbol      : SBT
8 // Name        : subsistance Token
9 // Total supply: 100,000,000,000
10 // Decimals    : 18
11 //
12 // Enjoy.
13 //
14 // (c) by Moritz Neto & Daniel Bar with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
15 // ----------------------------------------------------------------------------
16 
17 
18 // ----------------------------------------------------------------------------
19 // Safe maths
20 // ----------------------------------------------------------------------------
21 contract SafeMath 
22 {
23     function safeAdd(uint a, uint b) internal pure returns (uint c) 
24     {
25         c = a + b;
26         require(c >= a);
27     }
28     
29     function safeSub(uint a, uint b) internal pure returns (uint c) 
30     {
31         require(b <= a);
32         c = a - b;
33     }
34     
35     function safeMul(uint a, uint b) internal pure returns (uint c) 
36     {
37         c = a * b;
38         require(a == 0 || c / a == b);
39     }
40     
41     function safeDiv(uint a, uint b) internal pure returns (uint c) {
42         require(b > 0);
43         c = a / b;
44     }
45 }
46 
47 
48 // ----------------------------------------------------------------------------
49 // ERC Token Standard #20 Interface
50 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
51 // ----------------------------------------------------------------------------
52 contract ERC20Interface 
53 {
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
71 contract ApproveAndCallFallBack 
72 {
73     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
74 }
75 
76 
77 // ----------------------------------------------------------------------------
78 // Owned contract
79 // ----------------------------------------------------------------------------
80 contract Owned 
81 {
82     address public owner;
83     address public newOwner;
84 
85     event OwnershipTransferred(address indexed _from, address indexed _to);
86 
87     function Owned() public 
88     {
89         owner = msg.sender;
90     }
91 
92     modifier onlyOwner 
93     {
94         require(msg.sender == owner);
95         _;
96     }
97 
98     function transferOwnership(address _newOwner) public onlyOwner 
99     {
100         newOwner = _newOwner;
101     }
102     
103     function acceptOwnership() public 
104     {
105         require(msg.sender == newOwner);
106         OwnershipTransferred(owner, newOwner);
107         owner = newOwner;
108         newOwner = address(0);
109     }
110 }
111 
112 
113 // ----------------------------------------------------------------------------
114 // ERC20 Token, with the addition of symbol, name and decimals and assisted
115 // token transfers
116 // ----------------------------------------------------------------------------
117 contract subsistanceToken is ERC20Interface, Owned, SafeMath 
118 {
119     string public symbol;
120     string public  name;
121     uint8 public decimals;
122     uint public _totalSupply;
123     uint public startDate;
124     uint public bonusEnds;
125     uint public endDate;
126 
127     mapping(address => uint) balances;
128     mapping(address => mapping(address => uint)) allowed;
129 
130 
131     // ------------------------------------------------------------------------
132     // Constructor
133     // ------------------------------------------------------------------------
134     // Code manpualtion block
135     function subsistanceToken() public 
136     {
137         symbol = "SBT";
138         name = "subsistance Token";
139         decimals = 18;
140         bonusEnds = now + 8 weeks;
141         endDate = now + 16 weeks;
142 
143     }
144 
145 
146     // ------------------------------------------------------------------------
147     // Total supply
148     // ------------------------------------------------------------------------
149     function totalSupply() public constant returns (uint) 
150     {
151         return _totalSupply  - balances[address(0)];
152     }
153 
154 
155     // ------------------------------------------------------------------------
156     // Get the token balance for account `tokenOwner`
157     // ------------------------------------------------------------------------
158     function balanceOf(address tokenOwner) public constant returns (uint balance) 
159     {
160         return balances[tokenOwner];
161     }
162 
163 
164     // ------------------------------------------------------------------------
165     // Transfer the balance from token owner's account to `to` account
166     // - Owner's account must have sufficient balance to transfer
167     // - 0 value transfers are allowed
168     // ------------------------------------------------------------------------
169     function transfer(address to, uint tokens) public returns (bool success) 
170     {
171         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
172         balances[to] = safeAdd(balances[to], tokens);
173         Transfer(msg.sender, to, tokens);
174         return true;
175     }
176 
177 
178     // ------------------------------------------------------------------------
179     // Token owner can approve for `spender` to transferFrom(...) `tokens`
180     // from the token owner's account
181     //
182     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
183     // recommends that there are no checks for the approval double-spend attack
184     // as this should be implemented in user interfaces
185     // ------------------------------------------------------------------------
186     function approve(address spender, uint tokens) public returns (bool success) 
187     {
188         allowed[msg.sender][spender] = tokens;
189         Approval(msg.sender, spender, tokens);
190         return true;
191     }
192 
193 
194     // ------------------------------------------------------------------------
195     // Transfer `tokens` from the `from` account to the `to` account
196     //
197     // The calling account must already have sufficient tokens approve(...)-d
198     // for spending from the `from` account and
199     // - From account must have sufficient balance to transfer
200     // - Spender must have sufficient allowance to transfer
201     // - 0 value transfers are allowed
202     // ------------------------------------------------------------------------
203     function transferFrom(address from, address to, uint tokens) public returns (bool success) 
204     {
205         balances[from] = safeSub(balances[from], tokens);
206         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
207         balances[to] = safeAdd(balances[to], tokens);
208         Transfer(from, to, tokens);
209         return true;
210     }
211 
212 
213     // ------------------------------------------------------------------------
214     // Returns the amount of tokens approved by the owner that can be
215     // transferred to the spender's account
216     // ------------------------------------------------------------------------
217     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) 
218     {
219         return allowed[tokenOwner][spender];
220     }
221 
222 
223     // ------------------------------------------------------------------------
224     // Token owner can approve for `spender` to transferFrom(...) `tokens`
225     // from the token owner's account. The `spender` contract function
226     // `receiveApproval(...)` is then executed
227     // ------------------------------------------------------------------------
228     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) 
229     {
230         allowed[msg.sender][spender] = tokens;
231         Approval(msg.sender, spender, tokens);
232         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
233         return true;
234     }
235 
236     // ------------------------------------------------------------------------
237     // 100,000,000,000 FWD Tokens per 1 ETH
238     // ------------------------------------------------------------------------
239     function () public payable 
240     {
241         require(now >= startDate && now <= endDate);
242         uint tokens;
243         if (now <= bonusEnds) {
244             tokens = msg.value * 150000000000;
245         } else {
246             tokens = msg.value * 100000000000;
247         }
248         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
249         _totalSupply = safeAdd(_totalSupply, tokens);
250         Transfer(address(0), msg.sender, tokens);
251         owner.transfer(msg.value);
252     }
253 
254 
255 
256     // ------------------------------------------------------------------------
257     // Owner can transfer out any accidentally sent ERC20 tokens
258     // ------------------------------------------------------------------------
259     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) 
260     {
261         return ERC20Interface(tokenAddress).transfer(owner, tokens);
262     }
263 }