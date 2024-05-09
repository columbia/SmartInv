1 pragma solidity ^0.4.18;
2 
3 
4 
5 
6 // ----------------------------------------------------------------------------
7 // 'BBG' token contract
8 //
9 // Deployed to : 0x6F6609ee9212477B6Ea9A39D12fab6f80589F084
10 // Symbol : BBG
11 // Name : BeeBitGold
12 // Total supply: 50000000000
13 // Decimals : 18
14 //
15 //
16 // (c) by Yeuntaek Lim with IMBLOCK / Au 2017. The MIT Licence.
17 // ----------------------------------------------------------------------------
18 
19 
20 
21 
22 // ----------------------------------------------------------------------------
23 // Safe maths
24 // ----------------------------------------------------------------------------
25 contract SafeMath {
26 function safeAdd(uint a, uint b) public pure returns (uint c) {
27 c = a + b;
28 require(c >= a);
29 }
30 function safeSub(uint a, uint b) public pure returns (uint c) {
31 require(b <= a);
32 c = a - b;
33 }
34 function safeMul(uint a, uint b) public pure returns (uint c) {
35 c = a * b;
36 require(a == 0 || c / a == b);
37 }
38 function safeDiv(uint a, uint b) public pure returns (uint c) {
39 require(b > 0);
40 c = a / b;
41 }
42 }
43 
44 
45 
46 
47 // ----------------------------------------------------------------------------
48 // ERC Token Standard #20 Interface
49 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
50 // ----------------------------------------------------------------------------
51 contract ERC20Interface {
52 function totalSupply() public constant returns (uint);
53 function balanceOf(address tokenOwner) public constant returns (uint balance);
54 function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
55 function transfer(address to, uint tokens) public returns (bool success);
56 function approve(address spender, uint tokens) public returns (bool success);
57 function transferFrom(address from, address to, uint tokens) public returns (bool success);
58 
59 
60 
61 
62 event Transfer(address indexed from, address indexed to, uint tokens);
63 event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
64 }
65 
66 
67 
68 
69 // ----------------------------------------------------------------------------
70 // Contract function to receive approval and execute function in one call
71 //
72 // Borrowed from MiniMeToken
73 // ----------------------------------------------------------------------------
74 contract ApproveAndCallFallBack {
75 function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
76 }
77 
78 
79 
80 
81 // ----------------------------------------------------------------------------
82 // Owned contract
83 // ----------------------------------------------------------------------------
84 contract Owned {
85 address public owner;
86 address public newOwner;
87 
88 
89 
90 
91 event OwnershipTransferred(address indexed _from, address indexed _to);
92 
93 
94 
95 
96 function Owned() public {
97 owner = msg.sender;
98 }
99 
100 
101 
102 
103 modifier onlyOwner {
104 require(msg.sender == owner);
105 _;
106 }
107 
108 
109 
110 
111 function transferOwnership(address _newOwner) public onlyOwner {
112 newOwner = _newOwner;
113 }
114 function acceptOwnership() public {
115 require(msg.sender == newOwner);
116 OwnershipTransferred(owner, newOwner);
117 owner = newOwner;
118 newOwner = address(0);
119 }
120 }
121 
122 
123 
124 
125 // ----------------------------------------------------------------------------
126 // ERC20 Token, with the addition of symbol, name and decimals and assisted
127 // token transfers
128 // ----------------------------------------------------------------------------
129 contract BeeBitGold is ERC20Interface, Owned, SafeMath {
130 string public symbol;
131 string public name;
132 uint8 public decimals;
133 uint public _totalSupply;
134 
135 
136 
137 
138 mapping(address => uint) balances;
139 mapping(address => mapping(address => uint)) allowed;
140 
141 
142 
143 
144 
145 
146 
147 
148 // ------------------------------------------------------------------------
149 // Constructor
150 // ------------------------------------------------------------------------
151 function BeeBitGold() public {
152 symbol = "BBG";
153 name = "BeeBitGold";
154 decimals = 18;
155 _totalSupply = 50000000000000000000000000000;
156 balances[0x6F6609ee9212477B6Ea9A39D12fab6f80589F084] = _totalSupply;
157 Transfer(address(0), 0x6F6609ee9212477B6Ea9A39D12fab6f80589F084, _totalSupply);
158 }
159 
160 
161 
162 
163 
164 
165 
166 
167 // ------------------------------------------------------------------------
168 // Total supply
169 // ------------------------------------------------------------------------
170 function totalSupply() public constant returns (uint) {
171 return _totalSupply-balances[address(0)];
172 }
173 
174 
175 
176 
177 
178 
179 
180 
181 // ------------------------------------------------------------------------
182 // Get the token balance for account tokenOwner
183 // ------------------------------------------------------------------------
184 function balanceOf(address tokenOwner) public constant returns (uint balance) {
185 return balances[tokenOwner];
186 }
187 
188 
189 
190 
191 
192 
193 
194 
195 // ------------------------------------------------------------------------
196 // Transfer the balance from token owner's account to to account
197 // - Owner's account must have sufficient balance to transfer
198 // - 0 value transfers are allowed
199 // ------------------------------------------------------------------------
200 function transfer(address to, uint tokens) public returns (bool success) {
201 balances[msg.sender] = safeSub(balances[msg.sender], tokens);
202 balances[to] = safeAdd(balances[to], tokens);
203 Transfer(msg.sender, to, tokens);
204 return true;
205 }
206 
207 
208 
209 
210 
211 
212 
213 
214 // ------------------------------------------------------------------------
215 // Token owner can approve for spender to transferFrom(...) tokens
216 // from the token owner's account
217 //
218 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
219 // recommends that there are no checks for the approval double-spend attack
220 // as this should be implemented in user interfaces 
221 // ------------------------------------------------------------------------
222 function approve(address spender, uint tokens) public returns (bool success) {
223 allowed[msg.sender][spender] = tokens;
224 Approval(msg.sender, spender, tokens);
225 return true;
226 }
227 
228 
229 
230 
231 
232 
233 
234 
235 // ------------------------------------------------------------------------
236 // Transfer tokens from the from account to the to account
237 // 
238 // The calling account must already have sufficient tokens approve(...)-d
239 // for spending from the from account and
240 // - From account must have sufficient balance to transfer
241 // - Spender must have sufficient allowance to transfer
242 // - 0 value transfers are allowed
243 // ------------------------------------------------------------------------
244 function transferFrom(address from, address to, uint tokens) public returns (bool success) {
245 balances[from] = safeSub(balances[from], tokens);
246 allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
247 balances[to] = safeAdd(balances[to], tokens);
248 Transfer(from, to, tokens);
249 return true;
250 }
251 
252 
253 
254 
255 
256 
257 
258 
259 // ------------------------------------------------------------------------
260 // Returns the amount of tokens approved by the owner that can be
261 // transferred to the spender's account
262 // ------------------------------------------------------------------------
263 function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
264 return allowed[tokenOwner][spender];
265 }
266 
267 
268 
269 
270 
271 
272 
273 
274 // ------------------------------------------------------------------------
275 // Token owner can approve for spender to transferFrom(...) tokens
276 // from the token owner's account. The spender contract function
277 // receiveApproval(...) is then executed
278 // ------------------------------------------------------------------------
279 function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
280 allowed[msg.sender][spender] = tokens;
281 Approval(msg.sender, spender, tokens);
282 ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
283 return true;
284 }
285 
286 
287 
288 
289 
290 
291 
292 
293 // ------------------------------------------------------------------------
294 // Don't accept ETH
295 // ------------------------------------------------------------------------
296 function () public payable {
297 revert();
298 }
299 
300 
301 
302 
303 
304 
305 
306 
307 // ------------------------------------------------------------------------
308 // Owner can transfer out any accidentally sent ERC20 tokens
309 // ------------------------------------------------------------------------
310 function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
311 return ERC20Interface(tokenAddress).transfer(owner, tokens);
312 }
313 }