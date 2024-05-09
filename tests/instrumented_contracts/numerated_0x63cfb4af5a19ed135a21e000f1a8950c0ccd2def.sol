1 pragma solidity ^0.4.18;
2 
3 
4 // ----------------------------------------------------------------------------
5 
6 // IronCoin extended ERC20 token contract created on January the 28th, 2018 by Iron Bank of Braavos
7 
8 //
9 
10 // Symbol      : IRC
11 
12 // Name        : IronCoin
13 
14 // Total supply: 3,000,000,000,000
15 
16 // Decimals    : 0
17 
18 //
19 
20 // ----------------------------------------------------------------------------
21 
22 
23 
24 // ----------------------------------------------------------------------------
25 
26 // Safe maths
27 
28 // ----------------------------------------------------------------------------
29 
30 library SafeMath {
31 
32     function add(uint a, uint b) internal pure returns (uint c) {
33 
34         c = a + b;
35 
36         require(c >= a);
37 
38     }
39 
40     function sub(uint a, uint b) internal pure returns (uint c) {
41 
42         require(b <= a);
43 
44         c = a - b;
45 
46     }
47 
48     function mul(uint a, uint b) internal pure returns (uint c) {
49 
50         c = a * b;
51 
52         require(a == 0 || c / a == b);
53 
54     }
55 
56     function div(uint a, uint b) internal pure returns (uint c) {
57 
58         require(b > 0);
59 
60         c = a / b;
61 
62     }
63 
64 }
65 
66 
67 
68 // ----------------------------------------------------------------------------
69 
70 // ERC Token Standard #20 Interface
71 
72 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
73 
74 // ----------------------------------------------------------------------------
75 
76 contract ERC20Interface {
77 
78     function totalSupply() public constant returns (uint);
79 
80     function balanceOf(address tokenOwner) public constant returns (uint balance);
81 
82     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
83 
84     function transfer(address to, uint tokens) public returns (bool success);
85 
86     function approve(address spender, uint tokens) public returns (bool success);
87 
88     function transferFrom(address from, address to, uint tokens) public returns (bool success);
89 
90 
91     event Transfer(address indexed from, address indexed to, uint tokens);
92 
93     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
94 
95 }
96 
97 
98 
99 // ----------------------------------------------------------------------------
100 
101 // Contract function to receive approval and execute function in one call
102 
103 //
104 
105 // Borrowed from MiniMeToken
106 
107 // ----------------------------------------------------------------------------
108 
109 contract ApproveAndCallFallBack {
110 
111     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
112 
113 }
114 
115 
116 
117 // ----------------------------------------------------------------------------
118 
119 // Owned contract
120 
121 // ----------------------------------------------------------------------------
122 
123 contract Owned {
124 
125     address public owner;
126 
127     address public newOwner;
128 
129 
130     event OwnershipTransferred(address indexed _from, address indexed _to);
131 
132 
133     function Owned() public {
134 
135         owner = msg.sender;
136 
137     }
138 
139 
140     modifier onlyOwner {
141 
142         require(msg.sender == owner);
143 
144         _;
145 
146     }
147 
148 
149     function transferOwnership(address _newOwner) public onlyOwner {
150 
151         newOwner = _newOwner;
152 
153     }
154 
155     function acceptOwnership() public {
156 
157         require(msg.sender == newOwner);
158 
159         OwnershipTransferred(owner, newOwner);
160 
161         owner = newOwner;
162 
163         newOwner = address(0);
164 
165     }
166 
167 }
168 
169 
170 
171 // ----------------------------------------------------------------------------
172 
173 // ERC20 Token, with the addition of symbol, name and decimals and an
174 
175 // initial fixed supply
176 
177 // ----------------------------------------------------------------------------
178 
179 contract IronCoin is ERC20Interface, Owned {
180 
181     using SafeMath for uint;
182 
183 
184     string public symbol;
185 
186     string public  name;
187 
188     uint8 public decimals;
189 
190     uint public _totalSupply;
191 
192 
193     mapping(address => uint) balances;
194 
195     mapping(address => mapping(address => uint)) allowed;
196 
197 
198 
199     // ------------------------------------------------------------------------
200 
201     // Constructor
202 
203     // ------------------------------------------------------------------------
204 
205     function IronCoin() public {
206 
207         symbol = "IRC";
208 
209         name = "IronCoin";
210 
211         decimals = 0;
212 
213         _totalSupply = 3000000000 * 10**uint(decimals);
214 
215         balances[owner] = _totalSupply;
216 
217         Transfer(address(0), owner, _totalSupply);
218 
219     }
220 
221 
222 
223     // ------------------------------------------------------------------------
224 
225     // Total supply
226 
227     // ------------------------------------------------------------------------
228 
229     function totalSupply() public constant returns (uint) {
230 
231         return _totalSupply  - balances[address(0)];
232 
233     }
234 
235 
236 
237     // ------------------------------------------------------------------------
238 
239     // Get the token balance for account `tokenOwner`
240 
241     // ------------------------------------------------------------------------
242 
243     function balanceOf(address tokenOwner) public constant returns (uint balance) {
244 
245         return balances[tokenOwner];
246 
247     }
248 
249 
250 
251     // ------------------------------------------------------------------------
252 
253     // Transfer the balance from token owner's account to `to` account
254 
255     // - Owner's account must have sufficient balance to transfer
256 
257     // - 0 value transfers are allowed
258 
259     // ------------------------------------------------------------------------
260 
261     function transfer(address to, uint tokens) public returns (bool success) {
262 
263         balances[msg.sender] = balances[msg.sender].sub(tokens);
264 
265         balances[to] = balances[to].add(tokens);
266 
267         Transfer(msg.sender, to, tokens);
268 
269         return true;
270 
271     }
272 
273 
274 
275     // ------------------------------------------------------------------------
276 
277     // Token owner can approve for `spender` to transferFrom(...) `tokens`
278 
279     // from the token owner's account
280 
281     //
282 
283     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
284 
285     // recommends that there are no checks for the approval double-spend attack
286 
287     // as this should be implemented in user interfaces 
288 
289     // ------------------------------------------------------------------------
290 
291     function approve(address spender, uint tokens) public returns (bool success) {
292 
293         allowed[msg.sender][spender] = tokens;
294 
295         Approval(msg.sender, spender, tokens);
296 
297         return true;
298 
299     }
300 
301 
302 
303     // ------------------------------------------------------------------------
304 
305     // Transfer `tokens` from the `from` account to the `to` account
306 
307     // 
308 
309     // The calling account must already have sufficient tokens approve(...)-d
310 
311     // for spending from the `from` account and
312 
313     // - From account must have sufficient balance to transfer
314 
315     // - Spender must have sufficient allowance to transfer
316 
317     // - 0 value transfers are allowed
318 
319     // ------------------------------------------------------------------------
320 
321     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
322 
323         balances[from] = balances[from].sub(tokens);
324 
325         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
326 
327         balances[to] = balances[to].add(tokens);
328 
329         Transfer(from, to, tokens);
330 
331         return true;
332 
333     }
334 
335 
336 
337     // ------------------------------------------------------------------------
338 
339     // Returns the amount of tokens approved by the owner that can be
340 
341     // transferred to the spender's account
342 
343     // ------------------------------------------------------------------------
344 
345     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
346 
347         return allowed[tokenOwner][spender];
348 
349     }
350 
351 
352 
353     // ------------------------------------------------------------------------
354 
355     // Token owner can approve for `spender` to transferFrom(...) `tokens`
356 
357     // from the token owner's account. The `spender` contract function
358 
359     // `receiveApproval(...)` is then executed
360 
361     // ------------------------------------------------------------------------
362 
363     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
364 
365         allowed[msg.sender][spender] = tokens;
366 
367         Approval(msg.sender, spender, tokens);
368 
369         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
370 
371         return true;
372 
373     }
374 
375 
376 
377     // ------------------------------------------------------------------------
378 
379     // Don't accept ETH
380 
381     // ------------------------------------------------------------------------
382 
383     function () public payable {
384 
385         revert();
386 
387     }
388 
389 
390 
391     // ------------------------------------------------------------------------
392 
393     // Owner can transfer out any accidentally sent ERC20 tokens
394 
395     // ------------------------------------------------------------------------
396 
397     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
398 
399         return ERC20Interface(tokenAddress).transfer(owner, tokens);
400 
401     }
402 
403 }