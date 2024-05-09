1 pragma solidity ^0.4.23;
2 
3 // ----------------------------------------------------------------------------
4 // ZooblinToken CROWDSALE token contract
5 //
6 // Deployed by : 0x9D926842F6D40c3AF314992f7865Bc5be17e8676
7 // Symbol      : ZBN
8 // Name        : ZooblinToken
9 // Total supply: 600000000
10 // Decimals    : 18
11 //
12 // ----------------------------------------------------------------------------
13 
14 
15 // ----------------------------------------------------------------------------
16 // Safe maths
17 // ----------------------------------------------------------------------------
18 contract SafeMath {
19     function safeAdd(uint a, uint b) internal pure returns (uint c) {
20         c = a + b;
21         require(c >= a);
22     }
23 
24     function safeSub(uint a, uint b) internal pure returns (uint c) {
25         require(b <= a);
26         c = a - b;
27     }
28 
29     function zeroSub(uint a, uint b) internal pure returns (uint c) {
30         if (a >= b) {
31             c = safeSub(a, b);
32         } else {
33             c = 0;
34         }
35     }
36 
37     function safeMul(uint a, uint b) internal pure returns (uint c) {
38         c = a * b;
39         require(a == 0 || c / a == b);
40     }
41 
42     function safeDiv(uint a, uint b) internal pure returns (uint c) {
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
97 
98     function acceptOwnership() public {
99         require(msg.sender == newOwner);
100         emit OwnershipTransferred(owner, newOwner);
101         owner = newOwner;
102         newOwner = address(0);
103     }
104 }
105 
106 
107 // ----------------------------------------------------------------------------
108 // ERC20 Token, with the addition of symbol, name and decimals and assisted
109 // token transfers
110 // ----------------------------------------------------------------------------
111 contract ZooblinToken is ERC20Interface, Owned, SafeMath {
112     string public symbol;
113     string public  name;
114     uint8 public decimals;
115     uint public _totalSupply;
116 
117     uint public startDate;
118 
119     uint public preSaleAmount;
120     uint private preSaleFrom;
121     uint private preSaleUntil;
122 
123     uint public roundOneAmount;
124     uint private roundOneFrom;
125     uint private roundOneUntil;
126 
127     uint public roundTwoAmount;
128     uint private roundTwoFrom;
129     uint private roundTwoUntil;
130 
131     uint public roundThreeAmount;
132     uint private roundThreeFrom;
133     uint private roundThreeUntil;
134 
135     mapping(address => uint) balances;
136     mapping(address => mapping(address => uint)) allowed;
137 
138 
139     // ------------------------------------------------------------------------
140     // Constructor
141     // ------------------------------------------------------------------------
142     constructor() public {
143         symbol = "ZBN";
144         name = "Zooblin Token";
145         decimals = 18;
146         _totalSupply = 300000000000000000000000000;
147 
148         balances[0x9D926842F6D40c3AF314992f7865Bc5be17e8676] = _totalSupply;
149         emit Transfer(address(0), 0x9D926842F6D40c3AF314992f7865Bc5be17e8676, _totalSupply);
150 
151         startDate       = 1525564800; // Sunday, May 6, 2018 12:00:00 AM
152 
153         preSaleAmount   = 20000000000000000000000000;
154         roundOneAmount  = 150000000000000000000000000;
155         roundTwoAmount  = 80000000000000000000000000;
156         roundThreeAmount= 50000000000000000000000000;
157 
158         preSaleFrom     = 1527811200; // Friday, June 1, 2018 12:00:00 AM
159         preSaleUntil    = 1531699199; // Sunday, July 15, 2018 11:59:59 PM
160 
161         roundOneFrom    = 1533081600; // Wednesday, August 1, 2018 12:00:00 AM
162         roundOneUntil   = 1535759999; // Friday, August 31, 2018 11:59:59 PM
163 
164         roundTwoFrom    = 1535760000; // Saturday, September 1, 2018 12:00:00 AM
165         roundTwoUntil   = 1538351999; // Sunday, September 30, 2018 11:59:59 PM
166 
167         roundThreeFrom  = 1538352000; // Monday, October 1, 2018 12:00:00 AM
168         roundThreeUntil = 1541030399; // Wednesday, October 31, 2018 11:59:59 PM
169     }
170 
171 
172     // ------------------------------------------------------------------------
173     // Total supply
174     // ------------------------------------------------------------------------
175     function totalSupply() public constant returns (uint) {
176         return _totalSupply;
177     }
178 
179     // ------------------------------------------------------------------------
180     // Pre-sale Period
181     // ------------------------------------------------------------------------
182     function isPreSalePeriod(uint date) public constant returns (bool) {
183         return date >= preSaleFrom && date <= preSaleUntil && preSaleAmount > 0;
184     }
185 
186     // ------------------------------------------------------------------------
187     // Round One Sale Period
188     // ------------------------------------------------------------------------
189     function isRoundOneSalePeriod(uint date) public constant returns (bool) {
190         return date >= roundOneFrom && date <= roundOneUntil && roundOneAmount > 0;
191     }
192 
193     // ------------------------------------------------------------------------
194     // Round Two Sale Period
195     // ------------------------------------------------------------------------
196     function isRoundTwoSalePeriod(uint date) public constant returns (bool) {
197         return date >= roundTwoFrom && date <= roundTwoUntil && roundTwoAmount > 0;
198     }
199 
200     // ------------------------------------------------------------------------
201     // Round Three Sale Period
202     // ------------------------------------------------------------------------
203     function isRoundThreeSalePeriod(uint date) public constant returns (bool) {
204         return date >= roundThreeFrom && date <= roundThreeUntil && roundThreeAmount > 0;
205     }
206 
207     // ------------------------------------------------------------------------
208     // Get the token balance for account `tokenOwner`
209     // ------------------------------------------------------------------------
210     function balanceOf(address tokenOwner) public constant returns (uint balance) {
211         return balances[tokenOwner];
212     }
213 
214 
215     // ------------------------------------------------------------------------
216     // Transfer the balance from token owner's account to `to` account
217     // - Owner's account must have sufficient balance to transfer
218     // - 0 value transfers are allowed
219     // ------------------------------------------------------------------------
220     function transfer(address to, uint tokens) public returns (bool success) {
221         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
222         balances[to] = safeAdd(balances[to], tokens);
223         emit Transfer(msg.sender, to, tokens);
224         return true;
225     }
226 
227 
228     // ------------------------------------------------------------------------
229     // Token owner can approve for `spender` to transferFrom(...) `tokens`
230     // from the token owner's account
231     //
232     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
233     // recommends that there are no checks for the approval double-spend attack
234     // as this should be implemented in user interfaces
235     // ------------------------------------------------------------------------
236     function approve(address spender, uint tokens) public returns (bool success) {
237         allowed[msg.sender][spender] = tokens;
238         emit Approval(msg.sender, spender, tokens);
239         return true;
240     }
241 
242 
243     // ------------------------------------------------------------------------
244     // Transfer `tokens` from the `from` account to the `to` account
245     //
246     // The calling account must already have sufficient tokens approve(...)-d
247     // for spending from the `from` account and
248     // - From account must have sufficient balance to transfer
249     // - Spender must have sufficient allowance to transfer
250     // - 0 value transfers are allowed
251     // ------------------------------------------------------------------------
252     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
253         balances[from] = safeSub(balances[from], tokens);
254         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
255         balances[to] = safeAdd(balances[to], tokens);
256         emit Transfer(from, to, tokens);
257         return true;
258     }
259 
260 
261     // ------------------------------------------------------------------------
262     // Returns the amount of tokens approved by the owner that can be
263     // transferred to the spender's account
264     // ------------------------------------------------------------------------
265     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
266         return allowed[tokenOwner][spender];
267     }
268 
269 
270     // ------------------------------------------------------------------------
271     // Token owner can approve for `spender` to transferFrom(...) `tokens`
272     // from the token owner's account. The `spender` contract function
273     // `receiveApproval(...)` is then executed
274     // ------------------------------------------------------------------------
275     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
276         allowed[msg.sender][spender] = tokens;
277         emit Approval(msg.sender, spender, tokens);
278         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
279         return true;
280     }
281 
282     // ------------------------------------------------------------------------
283     // 10,000 ZBN Tokens per 1 ETH
284     // ------------------------------------------------------------------------
285     function () public payable {
286         require(now >= startDate && msg.value >= 1000000000000000000);
287 
288         uint tokens = 0;
289 
290         if (isPreSalePeriod(now)) {
291             tokens = msg.value * 13000;
292             preSaleAmount = zeroSub(preSaleAmount, tokens);
293         }
294 
295         if (isRoundOneSalePeriod(now)) {
296             tokens = msg.value * 11500;
297             roundOneAmount = zeroSub(roundOneAmount, tokens);
298         }
299 
300         if (isRoundTwoSalePeriod(now)) {
301             tokens = msg.value * 11000;
302             roundTwoAmount = zeroSub(roundTwoAmount, tokens);
303         }
304 
305         if (isRoundThreeSalePeriod(now)) {
306             tokens = msg.value * 10500;
307             roundThreeAmount = zeroSub(roundThreeAmount, tokens);
308         }
309 
310         require(tokens > 0);
311         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
312         _totalSupply = safeAdd(_totalSupply, tokens);
313         emit Transfer(address(0), msg.sender, tokens);
314         owner.transfer(msg.value);
315     }
316 
317     // ------------------------------------------------------------------------
318     // Owner can transfer out any accidentally sent ERC20 tokens
319     // ------------------------------------------------------------------------
320     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
321         return ERC20Interface(tokenAddress).transfer(owner, tokens);
322     }
323 }