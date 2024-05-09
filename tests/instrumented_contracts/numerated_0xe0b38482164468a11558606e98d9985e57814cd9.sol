1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'LocalToken' CROWDSALE token contract
5 //
6 // Deployed to : 0xceb584ee9b7e1568acc0ecfb5a23b590e64551cd
7 // Symbol      : LOT
8 // Name        : Local Token
9 // Total supply: 2000000000
10 // Decimals    : 18
11 //
12 // A music-backed ERC20 Token that is the digital representation of the Local playlist
13 //
14 // (c) by Ivy Music LLC - Garfield Ivy Maitland, Oghenefego Ahia, Janice Lee, Bryan Rodriguez. The MIT License.
15 // ----------------------------------------------------------------------------
16 
17 // Total: 2 billion Local Tokens (LOT)
18 // 1 billion tokens: team musical ownership
19 // 900 million tokens to be sold in crowdsale
20 // 10 million tokens: community development
21 // 20 million tokens: community engagement
22 // 10 million tokens: community engagement
23 // 10 million tokens: community faucet
24 
25 // ----------------------------------------------------------------------------
26 // Safe maths
27 // ----------------------------------------------------------------------------
28 contract SafeMath {
29     function safeAdd(uint a, uint b) internal pure returns (uint c) {
30         c = a + b;
31         require(c >= a);
32     }
33     function safeSub(uint a, uint b) internal pure returns (uint c) {
34         require(b <= a);
35         c = a - b;
36     }
37     function safeMul(uint a, uint b) internal pure returns (uint c) {
38         c = a * b;
39         require(a == 0 || c / a == b);
40     }
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
52 contract ERC20Interface {
53     function totalSupply() public constant returns (uint);
54     function balanceOf(address tokenOwner) public constant returns (uint balance);
55     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
56     function transfer(address to, uint tokens) public returns (bool success);
57     function approve(address spender, uint tokens) public returns (bool success);
58     function transferFrom(address from, address to, uint tokens) public returns (bool success);
59 
60     event Transfer(address indexed from, address indexed to, uint tokens);
61     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
62 }
63 
64 
65 // ----------------------------------------------------------------------------
66 // Contract function to receive approval and execute function in one call
67 //
68 // ----------------------------------------------------------------------------
69 contract ApproveAndCallFallBack {
70     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
71 }
72 
73 
74 // ----------------------------------------------------------------------------
75 // Owned contract
76 // ----------------------------------------------------------------------------
77 contract Owned {
78     address public owner;
79     address public newOwner;
80 
81     event OwnershipTransferred(address indexed _from, address indexed _to);
82 
83     function Owned() public {
84         owner = msg.sender;
85     }
86 
87     modifier onlyOwner {
88         require(msg.sender == owner);
89         _;
90     }
91 
92     function transferOwnership(address _newOwner) public onlyOwner {
93         newOwner = _newOwner;
94     }
95     function acceptOwnership() public {
96         require(msg.sender == newOwner);
97         OwnershipTransferred(owner, newOwner);
98         owner = newOwner;
99         newOwner = address(0xceb584ee9b7e1568acc0ecfb5a23b590e64551cd);
100     }
101 }
102 
103 
104 // ----------------------------------------------------------------------------
105 // ERC20 Token, with the addition of symbol, name and decimals and assisted
106 // token transfers
107 // ----------------------------------------------------------------------------
108 contract LocalToken is ERC20Interface, Owned, SafeMath {
109     string public symbol;
110     string public  name;
111     uint8 public decimals;
112     uint public _totalSupply;
113     uint public startDate;
114     uint public bonusEnds;
115     uint public endDate;
116     uint256 public totalEthers;
117     uint256 public constant CAP = 2 ether;
118 
119     mapping(address => uint) balances;
120     mapping(address => mapping(address => uint)) allowed;
121 
122 
123     // ------------------------------------------------------------------------
124     // Constructor
125     // ------------------------------------------------------------------------
126     function LocalToken() public {
127         symbol = "LOT";
128         name = "Local Token";
129         decimals = 18;
130         bonusEnds = now;
131         endDate = now + 30 minutes;
132 
133     }
134 
135 
136     // ------------------------------------------------------------------------
137     // Total supply
138     // ------------------------------------------------------------------------
139     function totalSupply() public constant returns (uint) {
140         return _totalSupply  - balances[address(0xceb584ee9b7e1568acc0ecfb5a23b590e64551cd)];
141     }
142 
143 
144     // ------------------------------------------------------------------------
145     // Get the token balance for account `tokenOwner`
146     // ------------------------------------------------------------------------
147     function balanceOf(address tokenOwner) public constant returns (uint balance) {
148         return balances[tokenOwner];
149     }
150 
151 
152     // ------------------------------------------------------------------------
153     // Transfer the balance from token owner's account to `to` account
154     // - Owner's account must have sufficient balance to transfer
155     // - 0 value transfers are allowed
156     // ------------------------------------------------------------------------
157     function transfer(address to, uint tokens) public returns (bool success) {
158         // Cannot transfer before crowdsale ends or cap reached
159         require(now > endDate || totalEthers == CAP);
160 
161         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
162         balances[to] = safeAdd(balances[to], tokens);
163         Transfer(msg.sender, to, tokens);
164         return true;
165     }
166 
167 
168     // ------------------------------------------------------------------------
169     // Token owner can approve for `spender` to transferFrom(...) `tokens`
170     // from the token owner's account
171     //
172     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
173     // recommends that there are no checks for the approval double-spend attack
174     // as this should be implemented in user interfaces
175     // ------------------------------------------------------------------------
176     function approve(address spender, uint tokens) public returns (bool success) {
177         allowed[msg.sender][spender] = tokens;
178         Approval(msg.sender, spender, tokens);
179         return true;
180     }
181 
182 
183     // ------------------------------------------------------------------------
184     // Transfer `tokens` from the `from` account to the `to` account
185     //
186     // The calling account must already have sufficient tokens approve(...)-d
187     // for spending from the `from` account and
188     // - From account must have sufficient balance to transfer
189     // - Spender must have sufficient allowance to transfer
190     // - 0 value transfers are allowed
191     // ------------------------------------------------------------------------
192     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
193         // Cannot transfer before crowdsale ends or cap reached
194         require(now > endDate || totalEthers == CAP);
195 
196         balances[from] = safeSub(balances[from], tokens);
197         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
198         balances[to] = safeAdd(balances[to], tokens);
199         Transfer(from, to, tokens);
200         return true;
201     }
202 
203 
204     // ------------------------------------------------------------------------
205     // Returns the amount of tokens approved by the owner that can be
206     // transferred to the spender's account
207     // ------------------------------------------------------------------------
208     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
209         return allowed[tokenOwner][spender];
210     }
211 
212 
213     // ------------------------------------------------------------------------
214     // Token owner can approve for `spender` to transferFrom(...) `tokens`
215     // from the token owner's account. The `spender` contract function
216     // `receiveApproval(...)` is then executed
217     // ------------------------------------------------------------------------
218     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
219         allowed[msg.sender][spender] = tokens;
220         Approval(msg.sender, spender, tokens);
221         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
222         return true;
223     }
224 
225     // ------------------------------------------------------------------------
226     // 1,000,000,000 LOT Tokens per 1 ETH
227     // ------------------------------------------------------------------------
228     function () public payable {
229         require(now >= startDate && now <= endDate);
230         // Add ETH raised to total
231         totalEthers = safeAdd(totalEthers, msg.value);
232         // Cannot exceed cap
233         require(totalEthers <= CAP);
234 
235         uint tokens;
236         tokens = msg.value * 1000000000;
237         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
238         _totalSupply = 2000000000000000000000000000;
239         Transfer(address(0xceb584ee9b7e1568acc0ecfb5a23b590e64551cd), msg.sender, tokens);
240         owner.transfer(msg.value);
241     }
242 
243 
244 
245     // ------------------------------------------------------------------------
246     // Owner can transfer out any accidentally sent ERC20 tokens
247     // ------------------------------------------------------------------------
248     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
249         return ERC20Interface(tokenAddress).transfer(owner, tokens);
250     }
251 }