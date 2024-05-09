1 pragma solidity ^0.4.18;
2 
3 
4 
5 // ----------------------------------------------------------------------------
6 
7 // 'Weekycoin' token contract
8 
9 //
10 
11 // Deployed to : 0x6d38A436a5241BA6Ea732dd86e2f1728d281Ba6f
12 
13 // Symbol      : WEEKY
14 
15 // Name        : Weekycoin
16 
17 // Total supply: 1000000000
18 
19 // Decimals    : 18
20 
21 //
22 
23 // Enjoy.
24 
25 //
26 
27 // (c) by Moritz Neto with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
28 
29 // ----------------------------------------------------------------------------
30 
31 
32 
33 
34 
35 // ----------------------------------------------------------------------------
36 
37 // Safe maths
38 
39 // ----------------------------------------------------------------------------
40 
41 contract SafeMath {
42 
43     function safeAdd(uint a, uint b) public pure returns (uint c) {
44 
45         c = a + b;
46 
47         require(c >= a);
48 
49     }
50 
51     function safeSub(uint a, uint b) public pure returns (uint c) {
52 
53         require(b <= a);
54 
55         c = a - b;
56 
57     }
58 
59     function safeMul(uint a, uint b) public pure returns (uint c) {
60 
61         c = a * b;
62 
63         require(a == 0 || c / a == b);
64 
65     }
66 
67     function safeDiv(uint a, uint b) public pure returns (uint c) {
68 
69         require(b > 0);
70 
71         c = a / b;
72 
73     }
74 
75 }
76 
77 
78 
79 
80 
81 // ----------------------------------------------------------------------------
82 
83 // ERC Token Standard #20 Interface
84 
85 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
86 
87 // ----------------------------------------------------------------------------
88 
89 contract ERC20Interface {
90 
91     function totalSupply() public constant returns (uint);
92 
93     function balanceOf(address tokenOwner) public constant returns (uint balance);
94 
95     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
96 
97     function transfer(address to, uint tokens) public returns (bool success);
98 
99     function approve(address spender, uint tokens) public returns (bool success);
100 
101     function transferFrom(address from, address to, uint tokens) public returns (bool success);
102 
103 
104 
105     event Transfer(address indexed from, address indexed to, uint tokens);
106 
107     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
108 
109 }
110 
111 
112 
113 
114 
115 // ----------------------------------------------------------------------------
116 
117 // Contract function to receive approval and execute function in one call
118 
119 //
120 
121 // Borrowed from MiniMeToken
122 
123 // ----------------------------------------------------------------------------
124 
125 contract ApproveAndCallFallBack {
126 
127     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
128 
129 }
130 
131 
132 
133 
134 
135 // ----------------------------------------------------------------------------
136 
137 // Owned contract
138 
139 // ----------------------------------------------------------------------------
140 
141 contract Owned {
142 
143     address public owner;
144 
145     address public newOwner;
146 
147 
148 
149     event OwnershipTransferred(address indexed _from, address indexed _to);
150 
151 
152 
153     function Owned() public {
154 
155         owner = msg.sender;
156 
157     }
158 
159 
160 
161     modifier onlyOwner {
162 
163         require(msg.sender == owner);
164 
165         _;
166 
167     }
168 
169 
170 
171     function transferOwnership(address _newOwner) public onlyOwner {
172 
173         newOwner = _newOwner;
174 
175     }
176 
177     function acceptOwnership() public {
178 
179         require(msg.sender == newOwner);
180 
181         OwnershipTransferred(owner, newOwner);
182 
183         owner = newOwner;
184 
185         newOwner = address(0);
186 
187     }
188 
189 }
190 
191 
192 
193 
194 
195 // ----------------------------------------------------------------------------
196 
197 // ERC20 Token, with the addition of symbol, name and decimals and assisted
198 
199 // token transfers
200 
201 // ----------------------------------------------------------------------------
202 
203 contract Weekycoin is ERC20Interface, Owned, SafeMath {
204 
205     string public symbol;
206 
207     string public  name;
208 
209     uint8 public decimals;
210 
211     uint public _totalSupply;
212 
213 
214 
215     mapping(address => uint) balances;
216 
217     mapping(address => mapping(address => uint)) allowed;
218 
219 
220 
221 
222 
223     // ------------------------------------------------------------------------
224 
225     // Constructor
226 
227     // ------------------------------------------------------------------------
228 
229     function Weekycoin() public {
230 
231         symbol = "WEEKY";
232 
233         name = "Weekycoin";
234 
235         decimals = 18;
236 
237         _totalSupply = 1000000000000000000000000000;
238 
239         balances[0x6d38A436a5241BA6Ea732dd86e2f1728d281Ba6f] = _totalSupply;
240 
241         Transfer(address(0), 0x6d38A436a5241BA6Ea732dd86e2f1728d281Ba6f, _totalSupply);
242 
243     }
244 
245 
246 
247 
248 
249     // ------------------------------------------------------------------------
250 
251     // Total supply
252 
253     // ------------------------------------------------------------------------
254 
255     function totalSupply() public constant returns (uint) {
256 
257         return _totalSupply  - balances[address(0)];
258 
259     }
260 
261 
262 
263 
264 
265     // ------------------------------------------------------------------------
266 
267     // Get the token balance for account tokenOwner
268 
269     // ------------------------------------------------------------------------
270 
271     function balanceOf(address tokenOwner) public constant returns (uint balance) {
272 
273         return balances[tokenOwner];
274 
275     }
276 
277 
278 
279 
280 
281     // ------------------------------------------------------------------------
282 
283     // Transfer the balance from token owner's account to to account
284 
285     // - Owner's account must have sufficient balance to transfer
286 
287     // - 0 value transfers are allowed
288 
289     // ------------------------------------------------------------------------
290 
291     function transfer(address to, uint tokens) public returns (bool success) {
292 
293         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
294 
295         balances[to] = safeAdd(balances[to], tokens);
296 
297         Transfer(msg.sender, to, tokens);
298 
299         return true;
300 
301     }
302 
303 
304 
305 
306 
307     // ------------------------------------------------------------------------
308 
309     // Token owner can approve for spender to transferFrom(...) tokens
310 
311     // from the token owner's account
312 
313     //
314 
315     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
316 
317     // recommends that there are no checks for the approval double-spend attack
318 
319     // as this should be implemented in user interfaces 
320 
321     // ------------------------------------------------------------------------
322 
323     function approve(address spender, uint tokens) public returns (bool success) {
324 
325         allowed[msg.sender][spender] = tokens;
326 
327         Approval(msg.sender, spender, tokens);
328 
329         return true;
330 
331     }
332 
333 
334 
335 
336 
337     // ------------------------------------------------------------------------
338 
339     // Transfer tokens from the from account to the to account
340 
341     // 
342 
343     // The calling account must already have sufficient tokens approve(...)-d
344 
345     // for spending from the from account and
346 
347     // - From account must have sufficient balance to transfer
348 
349     // - Spender must have sufficient allowance to transfer
350 
351     // - 0 value transfers are allowed
352 
353     // ------------------------------------------------------------------------
354 
355     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
356 
357         balances[from] = safeSub(balances[from], tokens);
358 
359         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
360 
361         balances[to] = safeAdd(balances[to], tokens);
362 
363         Transfer(from, to, tokens);
364 
365         return true;
366 
367     }
368 
369 
370 
371 
372 
373     // ------------------------------------------------------------------------
374 
375     // Returns the amount of tokens approved by the owner that can be
376 
377     // transferred to the spender's account
378 
379     // ------------------------------------------------------------------------
380 
381     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
382 
383         return allowed[tokenOwner][spender];
384 
385     }
386 
387 
388 
389 
390 
391     // ------------------------------------------------------------------------
392 
393     // Token owner can approve for spender to transferFrom(...) tokens
394 
395     // from the token owner's account. The spender contract function
396 
397     // receiveApproval(...) is then executed
398 
399     // ------------------------------------------------------------------------
400 
401     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
402 
403         allowed[msg.sender][spender] = tokens;
404 
405         Approval(msg.sender, spender, tokens);
406 
407         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
408 
409         return true;
410 
411     }
412 
413 
414 
415 
416 
417     // ------------------------------------------------------------------------
418 
419     // Don't accept ETH
420 
421     // ------------------------------------------------------------------------
422 
423     function () public payable {
424 
425         revert();
426 
427     }
428 
429 
430 
431 
432 
433     // ------------------------------------------------------------------------
434 
435     // Owner can transfer out any accidentally sent ERC20 tokens
436 
437     // ------------------------------------------------------------------------
438 
439     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
440 
441         return ERC20Interface(tokenAddress).transfer(owner, tokens);
442 
443     }
444 
445 }