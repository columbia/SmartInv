1 pragma solidity ^0.4.18;
2 
3 
4 
5 
6 // ----------------------------------------------------------------------------
7 
8 // 'PlusPayLite' token contract
9 
10 //
11 
12 // Deployed to : 0xDaff7505FbdA5Fbbf39d2705eFDcaDde080fCE79
13 
14 // Symbol      : PlusPayLite
15 
16 // Name        : Plus Pay Lite
17 
18 // Total supply: 1 000 000 000
19 
20 // Decimals    : 18
21 
22 //
23 
24 // Enjoy.
25 
26 
27 
28 
29 
30 // ----------------------------------------------------------------------------
31 
32 
33 
34 
35 
36 
37 
38 // ----------------------------------------------------------------------------
39 
40 // Safe maths
41 
42 // ----------------------------------------------------------------------------
43 
44 contract SafeMath {
45 
46     function safeAdd(uint a, uint b) public pure returns (uint c) {
47 
48         c = a + b;
49 
50         require(c >= a);
51 
52     }
53 
54     function safeSub(uint a, uint b) public pure returns (uint c) {
55 
56         require(b <= a);
57 
58         c = a - b;
59 
60     }
61 
62     function safeMul(uint a, uint b) public pure returns (uint c) {
63 
64         c = a * b;
65 
66         require(a == 0 || c / a == b);
67 
68     }
69 
70     function safeDiv(uint a, uint b) public pure returns (uint c) {
71 
72         require(b > 0);
73 
74         c = a / b;
75 
76     }
77 
78 }
79 
80 
81 
82 
83 
84 
85 
86 // ----------------------------------------------------------------------------
87 
88 // ERC Token Standard #20 Interface
89 
90 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
91 
92 // ----------------------------------------------------------------------------
93 
94 contract ERC20Interface {
95 
96     function totalSupply() public constant returns (uint);
97 
98     function balanceOf(address tokenOwner) public constant returns (uint balance);
99 
100     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
101 
102     function transfer(address to, uint tokens) public returns (bool success);
103 
104     function approve(address spender, uint tokens) public returns (bool success);
105 
106     function transferFrom(address from, address to, uint tokens) public returns (bool success);
107 
108 
109 
110 
111     event Transfer(address indexed from, address indexed to, uint tokens);
112 
113     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
114 
115 }
116 
117 
118 
119 
120 
121 
122 
123 // ----------------------------------------------------------------------------
124 
125 // Contract function to receive approval and execute function in one call
126 
127 //
128 
129 // Borrowed from MiniMeToken
130 
131 // ----------------------------------------------------------------------------
132 
133 contract ApproveAndCallFallBack {
134 
135     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
136 
137 }
138 
139 
140 
141 
142 
143 
144 
145 // ----------------------------------------------------------------------------
146 
147 // Owned contract
148 
149 // ----------------------------------------------------------------------------
150 
151 contract Owned {
152 
153     address public owner;
154 
155     address public newOwner;
156 
157 
158 
159 
160     event OwnershipTransferred(address indexed _from, address indexed _to);
161 
162 
163 
164 
165     function Owned() public {
166 
167         owner = msg.sender;
168 
169     }
170 
171 
172 
173 
174     modifier onlyOwner {
175 
176         require(msg.sender == owner);
177 
178         _;
179 
180     }
181 
182 
183 
184 
185     function transferOwnership(address _newOwner) public onlyOwner {
186 
187         newOwner = _newOwner;
188 
189     }
190 
191     function acceptOwnership() public {
192 
193         require(msg.sender == newOwner);
194 
195         OwnershipTransferred(owner, newOwner);
196 
197         owner = newOwner;
198 
199         newOwner = address(0);
200 
201     }
202 
203 }
204 
205 
206 
207 
208 
209 
210 
211 // ----------------------------------------------------------------------------
212 
213 // ERC20 Token, with the addition of symbol, name and decimals and assisted
214 
215 // token transfers
216 
217 // ----------------------------------------------------------------------------
218 
219 contract PlusPayLite is ERC20Interface, Owned, SafeMath {
220 
221     string public symbol;
222 
223     string public  name;
224 
225     uint8 public decimals;
226 
227     uint public _totalSupply;
228 
229 
230 
231 
232     mapping(address => uint) balances;
233 
234     mapping(address => mapping(address => uint)) allowed;
235 
236 
237 
238 
239 
240 
241 
242     // ------------------------------------------------------------------------
243 
244     // Constructor
245 
246     // ------------------------------------------------------------------------
247 
248     function PlusPayLite() public {
249 
250         symbol = "PlusPayLite";
251 
252         name = "PlusPayLite";
253 
254         decimals = 18;
255 
256         _totalSupply = 1000000000000000000000000000;
257 
258         balances[0xDaff7505FbdA5Fbbf39d2705eFDcaDde080fCE79] = _totalSupply;
259 
260         Transfer(address(0), 0xDaff7505FbdA5Fbbf39d2705eFDcaDde080fCE79, _totalSupply);
261 
262     }
263 
264 
265 
266 
267 
268 
269 
270     // ------------------------------------------------------------------------
271 
272     // Total supply
273 
274     // ------------------------------------------------------------------------
275 
276     function totalSupply() public constant returns (uint) {
277 
278         return _totalSupply  - balances[address(0)];
279 
280     }
281 
282 
283 
284 
285 
286 
287 
288     // ------------------------------------------------------------------------
289 
290     // Get the token balance for account tokenOwner
291 
292     // ------------------------------------------------------------------------
293 
294     function balanceOf(address tokenOwner) public constant returns (uint balance) {
295 
296         return balances[tokenOwner];
297 
298     }
299 
300 
301 
302 
303 
304 
305 
306     // ------------------------------------------------------------------------
307 
308     // Transfer the balance from token owner's account to to account
309 
310     // - Owner's account must have sufficient balance to transfer
311 
312     // - 0 value transfers are allowed
313 
314     // ------------------------------------------------------------------------
315 
316     function transfer(address to, uint tokens) public returns (bool success) {
317 
318         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
319 
320         balances[to] = safeAdd(balances[to], tokens);
321 
322         Transfer(msg.sender, to, tokens);
323 
324         return true;
325 
326     }
327 
328 
329 
330 
331 
332 
333 
334     // ------------------------------------------------------------------------
335 
336     // Token owner can approve for spender to transferFrom(...) tokens
337 
338     // from the token owner's account
339 
340     //
341 
342     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
343 
344     // recommends that there are no checks for the approval double-spend attack
345 
346     // as this should be implemented in user interfaces 
347 
348     // ------------------------------------------------------------------------
349 
350     function approve(address spender, uint tokens) public returns (bool success) {
351 
352         allowed[msg.sender][spender] = tokens;
353 
354         Approval(msg.sender, spender, tokens);
355 
356         return true;
357 
358     }
359 
360 
361 
362 
363 
364 
365 
366     // ------------------------------------------------------------------------
367 
368     // Transfer tokens from the from account to the to account
369 
370     // 
371 
372     // The calling account must already have sufficient tokens approve(...)-d
373 
374     // for spending from the from account and
375 
376     // - From account must have sufficient balance to transfer
377 
378     // - Spender must have sufficient allowance to transfer
379 
380     // - 0 value transfers are allowed
381 
382     // ------------------------------------------------------------------------
383 
384     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
385 
386         balances[from] = safeSub(balances[from], tokens);
387 
388         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
389 
390         balances[to] = safeAdd(balances[to], tokens);
391 
392         Transfer(from, to, tokens);
393 
394         return true;
395 
396     }
397 
398 
399 
400 
401 
402 
403 
404     // ------------------------------------------------------------------------
405 
406     // Returns the amount of tokens approved by the owner that can be
407 
408     // transferred to the spender's account
409 
410     // ------------------------------------------------------------------------
411 
412     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
413 
414         return allowed[tokenOwner][spender];
415 
416     }
417 
418 
419 
420 
421 
422 
423 
424     // ------------------------------------------------------------------------
425 
426     // Token owner can approve for spender to transferFrom(...) tokens
427 
428     // from the token owner's account. The spender contract function
429 
430     // receiveApproval(...) is then executed
431 
432     // ------------------------------------------------------------------------
433 
434     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
435 
436         allowed[msg.sender][spender] = tokens;
437 
438         Approval(msg.sender, spender, tokens);
439 
440         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
441 
442         return true;
443 
444     }
445 
446 
447 
448 
449 
450 
451 
452     // ------------------------------------------------------------------------
453 
454     // Don't accept ETH
455 
456     // ------------------------------------------------------------------------
457 
458     function () public payable {
459 
460         revert();
461 
462     }
463 
464 
465 
466 
467 
468 
469 
470     // ------------------------------------------------------------------------
471 
472     // Owner can transfer out any accidentally sent ERC20 tokens
473 
474     // ------------------------------------------------------------------------
475 
476     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
477 
478         return ERC20Interface(tokenAddress).transfer(owner, tokens);
479 
480     }
481 
482 }