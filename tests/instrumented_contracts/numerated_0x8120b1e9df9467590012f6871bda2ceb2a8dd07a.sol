1 pragma solidity ^0.4.18;
2 
3  
4 
5 // ----------------------------------------------------------------------------
6 
7 // 'FLC' 'FREE Crypto Ltd
8 
9 //
10 
11 // Symbol      : FCL
12 
13 // Name        : FCL Token
14 
15 // Total supply: 10,000,000.000000000000000000
16 
17 // Decimals    : 18
18 
19 //
20 
21 // Enjoy.
22 
23 //
24 
25 // www.FREECryptoLtd.com
26 
27 // ----------------------------------------------------------------------------
28 
29  
30 
31  
32 
33 // ----------------------------------------------------------------------------
34 
35 // Safe maths
36 
37 // ----------------------------------------------------------------------------
38 
39 library SafeMath {
40 
41     function add(uint a, uint b) internal pure returns (uint c) {
42 
43         c = a + b;
44 
45         require(c >= a);
46 
47     }
48 
49     function sub(uint a, uint b) internal pure returns (uint c) {
50 
51         require(b <= a);
52 
53         c = a - b;
54 
55     }
56 
57     function mul(uint a, uint b) internal pure returns (uint c) {
58 
59         c = a * b;
60 
61         require(a == 0 || c / a == b);
62 
63     }
64 
65     function div(uint a, uint b) internal pure returns (uint c) {
66 
67         require(b > 0);
68 
69         c = a / b;
70 
71     }
72 
73 }
74 
75  
76 
77  
78 
79 // ----------------------------------------------------------------------------
80 
81 // ERC Token Standard #20 Interface
82 
83 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
84 
85 // ----------------------------------------------------------------------------
86 
87 contract ERC20Interface {
88 
89     function totalSupply() public constant returns (uint);
90 
91     function balanceOf(address tokenOwner) public constant returns (uint balance);
92 
93     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
94 
95     function transfer(address to, uint tokens) public returns (bool success);
96 
97     function approve(address spender, uint tokens) public returns (bool success);
98 
99     function transferFrom(address from, address to, uint tokens) public returns (bool success);
100 
101  
102 
103     event Transfer(address indexed from, address indexed to, uint tokens);
104 
105     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
106 
107 }
108 
109  
110 
111  
112 
113 // ----------------------------------------------------------------------------
114 
115 // Contract function to receive approval and execute function in one call
116 
117 //
118 
119 // 
120 
121 // ----------------------------------------------------------------------------
122 
123 contract ApproveAndCallFallBack {
124 
125     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
126 
127 }
128 
129  
130 
131  
132 
133 // ----------------------------------------------------------------------------
134 
135 // Owned contract
136 
137 // ----------------------------------------------------------------------------
138 
139 contract Owned {
140 
141     address public owner;
142 
143     address public newOwner;
144 
145  
146 
147     event OwnershipTransferred(address indexed _from, address indexed _to);
148 
149  
150 
151     function Owned() public {
152 
153         owner = msg.sender;
154 
155     }
156 
157  
158 
159     modifier onlyOwner {
160 
161         require(msg.sender == owner);
162 
163         _;
164 
165     }
166 
167  
168 
169     function transferOwnership(address _newOwner) public onlyOwner {
170 
171         newOwner = _newOwner;
172 
173     }
174 
175     function acceptOwnership() public {
176 
177         require(msg.sender == newOwner);
178 
179         OwnershipTransferred(owner, newOwner);
180 
181         owner = newOwner;
182 
183         newOwner = address(0);
184 
185     }
186 
187 }
188 
189  
190 
191  
192 
193 // ----------------------------------------------------------------------------
194 
195 // ERC20 Token, with the addition of symbol, name and decimals and an
196 
197 // initial fixed supply
198 
199 // ----------------------------------------------------------------------------
200 
201 contract FCLToken is ERC20Interface, Owned {
202 
203     using SafeMath for uint;
204 
205  
206 
207     string public symbol;
208 
209     string public  name;
210 
211     uint8 public decimals;
212 
213     uint public _totalSupply;
214 
215  
216 
217     mapping(address => uint) balances;
218 
219     mapping(address => mapping(address => uint)) allowed;
220 
221  
222 
223  
224 
225     // ------------------------------------------------------------------------
226 
227     // Constructor
228 
229     // ------------------------------------------------------------------------
230 
231     function FCLToken() public {
232 
233         symbol = "FCL";
234 
235         name = "FREE Crypto Ltd Coin";
236 
237         decimals = 18;
238 
239         _totalSupply = 10000000 * 10**uint(decimals);
240 
241         balances[owner] = _totalSupply;
242 
243         Transfer(address(0), owner, _totalSupply);
244 
245     }
246 
247  
248 
249  
250 
251     // ------------------------------------------------------------------------
252 
253     // Total supply
254 
255     // ------------------------------------------------------------------------
256 
257     function totalSupply() public constant returns (uint) {
258 
259         return _totalSupply  - balances[address(0)];
260 
261     }
262 
263  
264 
265  
266 
267     // ------------------------------------------------------------------------
268 
269     // Get the token balance for account `tokenOwner`
270 
271     // ------------------------------------------------------------------------
272 
273     function balanceOf(address tokenOwner) public constant returns (uint balance) {
274 
275         return balances[tokenOwner];
276 
277     }
278 
279  
280 
281  
282 
283     // ------------------------------------------------------------------------
284 
285     // Transfer the balance from token owner's account to `to` account
286 
287     // - Owner's account must have sufficient balance to transfer
288 
289     // - 0 value transfers are allowed
290 
291     // ------------------------------------------------------------------------
292 
293     function transfer(address to, uint tokens) public returns (bool success) {
294 
295         balances[msg.sender] = balances[msg.sender].sub(tokens);
296 
297         balances[to] = balances[to].add(tokens);
298 
299         Transfer(msg.sender, to, tokens);
300 
301         return true;
302 
303     }
304 
305  
306 
307  
308 
309     // ------------------------------------------------------------------------
310 
311     // Token owner can approve for `spender` to transferFrom(...) `tokens`
312 
313     // from the token owner's account
314 
315     //
316 
317     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
318 
319     // recommends that there are no checks for the approval double-spend attack
320 
321     // as this should be implemented in user interfaces
322 
323     // ------------------------------------------------------------------------
324 
325     function approve(address spender, uint tokens) public returns (bool success) {
326 
327         allowed[msg.sender][spender] = tokens;
328 
329         Approval(msg.sender, spender, tokens);
330 
331         return true;
332 
333     }
334 
335  
336 
337  
338 
339     // ------------------------------------------------------------------------
340 
341     // Transfer `tokens` from the `from` account to the `to` account
342 
343     //
344 
345     // The calling account must already have sufficient tokens approve(...)-d
346 
347     // for spending from the `from` account and
348 
349     // - From account must have sufficient balance to transfer
350 
351     // - Spender must have sufficient allowance to transfer
352 
353     // - 0 value transfers are allowed
354 
355     // ------------------------------------------------------------------------
356 
357     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
358 
359         balances[from] = balances[from].sub(tokens);
360 
361         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
362 
363         balances[to] = balances[to].add(tokens);
364 
365         Transfer(from, to, tokens);
366 
367         return true;
368 
369     }
370 
371  
372 
373  
374 
375     // ------------------------------------------------------------------------
376 
377     // Returns the amount of tokens approved by the owner that can be
378 
379     // transferred to the spender's account
380 
381     // ------------------------------------------------------------------------
382 
383     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
384 
385         return allowed[tokenOwner][spender];
386 
387     }
388 
389  
390 
391  
392 
393     // ------------------------------------------------------------------------
394 
395     // Token owner can approve for `spender` to transferFrom(...) `tokens`
396 
397     // from the token owner's account. The `spender` contract function
398 
399     // `receiveApproval(...)` is then executed
400 
401     // ------------------------------------------------------------------------
402 
403     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
404 
405         allowed[msg.sender][spender] = tokens;
406 
407         Approval(msg.sender, spender, tokens);
408 
409         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
410 
411         return true;
412 
413     }
414 
415  
416 
417  
418 
419     // ------------------------------------------------------------------------
420 
421     // Don't accept ETH
422 
423     // ------------------------------------------------------------------------
424 
425     function () public payable {
426 
427         revert();
428 
429     }
430 
431  
432 
433  
434 
435     // ------------------------------------------------------------------------
436 
437     // Owner can transfer out any accidentally sent ERC20 tokens
438 
439     // ------------------------------------------------------------------------
440 
441     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
442 
443         return ERC20Interface(tokenAddress).transfer(owner, tokens);
444 
445     }
446 
447 }