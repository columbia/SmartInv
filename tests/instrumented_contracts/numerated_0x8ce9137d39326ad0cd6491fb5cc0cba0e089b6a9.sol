1 pragma solidity ^0.5.0;
2 
3 
4 // ----------------------------------------------------------------------------
5 
6 // 'SXP' 'Swipe' token contract
7 
8 //
9 
10 // Symbol      : SXP
11 
12 // Name        : Swipe
13 
14 // Total supply: 300,000,000.000000000000000000
15 
16 // Decimals    : 18
17 
18 // Website     : https://swipe.io
19 
20 
21 //
22 
23 
24 // ----------------------------------------------------------------------------
25 
26 
27 
28 // ----------------------------------------------------------------------------
29 
30 // Safe maths
31 
32 // ----------------------------------------------------------------------------
33 
34 library SafeMath {
35 
36     function add(uint a, uint b) internal pure returns (uint c) {
37 
38         c = a + b;
39 
40         require(c >= a);
41 
42     }
43 
44     function sub(uint a, uint b) internal pure returns (uint c) {
45 
46         require(b <= a);
47 
48         c = a - b;
49 
50     }
51 
52     function mul(uint a, uint b) internal pure returns (uint c) {
53 
54         c = a * b;
55 
56         require(a == 0 || c / a == b);
57 
58     }
59 
60     function div(uint a, uint b) internal pure returns (uint c) {
61 
62         require(b > 0);
63 
64         c = a / b;
65 
66     }
67 
68 }
69 
70 
71 
72 // ----------------------------------------------------------------------------
73 
74 // ERC Token Standard #20 Interface
75 
76 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
77 
78 // ----------------------------------------------------------------------------
79 
80 contract ERC20Interface {
81 
82     function totalSupply() public view returns (uint);
83 
84     function balanceOf(address tokenOwner) public view returns (uint balance);
85 
86     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
87 
88     function transfer(address to, uint tokens) public returns (bool success);
89 
90     function approve(address spender, uint tokens) public returns (bool success);
91 
92     function transferFrom(address from, address to, uint tokens) public returns (bool success);
93 
94 
95     event Transfer(address indexed from, address indexed to, uint tokens);
96 
97     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
98 
99 }
100 
101 
102 
103 // ----------------------------------------------------------------------------
104 
105 // Contract function to receive approval and execute function in one call
106 
107 //
108 
109 // Borrowed from MiniMeToken
110 
111 // ----------------------------------------------------------------------------
112 
113 contract ApproveAndCallFallBack {
114 
115     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
116 
117 }
118 
119 
120 
121 // ----------------------------------------------------------------------------
122 
123 // Owned contract
124 
125 // ----------------------------------------------------------------------------
126 
127 contract Owned {
128 
129     address public owner;
130 
131     event OwnershipTransferred(address indexed _from, address indexed _to);
132 
133 
134     constructor() public {
135 
136         owner = msg.sender;
137 
138     }
139 
140 
141     modifier onlyOwner {
142 
143         require(msg.sender == owner);
144 
145         _;
146 
147     }
148 
149 
150     function transferOwnership(address newOwner) public onlyOwner {
151 
152         owner = newOwner;
153         emit OwnershipTransferred(owner, newOwner);
154 
155     }
156 
157 }
158 
159 // ----------------------------------------------------------------------------
160 
161 // Tokenlock contract
162 
163 // ----------------------------------------------------------------------------
164 contract Tokenlock is Owned {
165     
166     uint8 isLocked = 0;       //flag indicates if token is locked
167 
168     event Freezed();
169     event UnFreezed();
170 
171     modifier validLock {
172         require(isLocked == 0);
173         _;
174     }
175     
176     function freeze() public onlyOwner {
177         isLocked = 1;
178         
179         emit Freezed();
180     }
181 
182     function unfreeze() public onlyOwner {
183         isLocked = 0;
184         
185         emit UnFreezed();
186     }
187 }
188 
189 // ----------------------------------------------------------------------------
190 
191 // Limit users in blacklist
192 
193 // ----------------------------------------------------------------------------
194 contract UserLock is Owned {
195     
196     mapping(address => bool) blacklist;
197         
198     event LockUser(address indexed who);
199     event UnlockUser(address indexed who);
200 
201     modifier permissionCheck {
202         require(!blacklist[msg.sender]);
203         _;
204     }
205     
206     function lockUser(address who) public onlyOwner {
207         blacklist[who] = true;
208         
209         emit LockUser(who);
210     }
211 
212     function unlockUser(address who) public onlyOwner {
213         blacklist[who] = false;
214         
215         emit UnlockUser(who);
216     }
217 }
218 
219 
220 // ----------------------------------------------------------------------------
221 
222 // ERC20 Token, with the addition of symbol, name and decimals and a
223 
224 // fixed supply
225 
226 // ----------------------------------------------------------------------------
227 
228 contract SwipeToken is ERC20Interface, Tokenlock, UserLock {
229 
230     using SafeMath for uint;
231 
232 
233     string public symbol;
234 
235     string public  name;
236 
237     uint8 public decimals;
238 
239     uint _totalSupply;
240 
241 
242     mapping(address => uint) balances;
243 
244     mapping(address => mapping(address => uint)) allowed;
245 
246 
247 
248     // ------------------------------------------------------------------------
249 
250     // Constructor
251 
252     // ------------------------------------------------------------------------
253 
254     constructor() public {
255 
256         symbol = "SXP";
257 
258         name = "Swipe";
259 
260         decimals = 18;
261 
262         _totalSupply = 300000000 * 10**uint(decimals);
263 
264         balances[owner] = _totalSupply;
265 
266         emit Transfer(address(0), owner, _totalSupply);
267 
268     }
269 
270 
271 
272     // ------------------------------------------------------------------------
273 
274     // Total supply
275 
276     // ------------------------------------------------------------------------
277 
278     function totalSupply() public view returns (uint) {
279 
280         return _totalSupply.sub(balances[address(0)]);
281 
282     }
283 
284 
285 
286     // ------------------------------------------------------------------------
287 
288     // Get the token balance for account `tokenOwner`
289 
290     // ------------------------------------------------------------------------
291 
292     function balanceOf(address tokenOwner) public view returns (uint balance) {
293 
294         return balances[tokenOwner];
295 
296     }
297 
298 
299 
300     // ------------------------------------------------------------------------
301 
302     // Transfer the balance from token owner's account to `to` account
303 
304     // - Owner's account must have sufficient balance to transfer
305 
306     // - 0 value transfers are allowed
307 
308     // ------------------------------------------------------------------------
309 
310     function transfer(address to, uint tokens) public validLock permissionCheck returns (bool success) {
311 
312         balances[msg.sender] = balances[msg.sender].sub(tokens);
313 
314         balances[to] = balances[to].add(tokens);
315 
316         emit Transfer(msg.sender, to, tokens);
317 
318         return true;
319 
320     }
321 
322 
323 
324     // ------------------------------------------------------------------------
325 
326     // Token owner can approve for `spender` to transferFrom(...) `tokens`
327 
328     // from the token owner's account
329 
330     //
331 
332     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
333 
334     // recommends that there are no checks for the approval double-spend attack
335 
336     // as this should be implemented in user interfaces
337 
338     // ------------------------------------------------------------------------
339 
340     function approve(address spender, uint tokens) public validLock permissionCheck returns (bool success) {
341 
342         allowed[msg.sender][spender] = tokens;
343 
344         emit Approval(msg.sender, spender, tokens);
345 
346         return true;
347 
348     }
349 
350 
351 
352     // ------------------------------------------------------------------------
353 
354     // Transfer `tokens` from the `from` account to the `to` account
355 
356     //
357 
358     // The calling account must already have sufficient tokens approve(...)-d
359 
360     // for spending from the `from` account and
361 
362     // - From account must have sufficient balance to transfer
363 
364     // - Spender must have sufficient allowance to transfer
365 
366     // - 0 value transfers are allowed
367 
368     // ------------------------------------------------------------------------
369 
370     function transferFrom(address from, address to, uint tokens) public validLock permissionCheck returns (bool success) {
371 
372         balances[from] = balances[from].sub(tokens);
373 
374         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
375 
376         balances[to] = balances[to].add(tokens);
377 
378         emit Transfer(from, to, tokens);
379 
380         return true;
381 
382     }
383 
384 
385 
386     // ------------------------------------------------------------------------
387 
388     // Returns the amount of tokens approved by the owner that can be
389 
390     // transferred to the spender's account
391 
392     // ------------------------------------------------------------------------
393 
394     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
395 
396         return allowed[tokenOwner][spender];
397 
398     }
399 
400 
401      // ------------------------------------------------------------------------
402      // Destroys `amount` tokens from `account`, reducing the
403      // total supply.
404      
405      // Emits a `Transfer` event with `to` set to the zero address.
406      
407      // Requirements
408      
409      // - `account` cannot be the zero address.
410      // - `account` must have at least `amount` tokens.
411      
412      // ------------------------------------------------------------------------
413     function burn(uint256 value) public validLock permissionCheck returns (bool success) {
414         require(msg.sender != address(0), "ERC20: burn from the zero address");
415 
416         _totalSupply = _totalSupply.sub(value);
417         balances[msg.sender] = balances[msg.sender].sub(value);
418         emit Transfer(msg.sender, address(0), value);
419         return true;
420     }
421 
422     // ------------------------------------------------------------------------
423 
424     // Token owner can approve for `spender` to transferFrom(...) `tokens`
425 
426     // from the token owner's account. The `spender` contract function
427 
428     // `receiveApproval(...)` is then executed
429 
430     // ------------------------------------------------------------------------
431 
432     function approveAndCall(address spender, uint tokens, bytes memory data) public validLock permissionCheck returns (bool success) {
433 
434         allowed[msg.sender][spender] = tokens;
435 
436         emit Approval(msg.sender, spender, tokens);
437 
438         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
439 
440         return true;
441 
442     }
443 
444 
445     // ------------------------------------------------------------------------
446     // Destoys `amount` tokens from `account`.`amount` is then deducted
447     // from the caller's allowance.
448     
449     //  See `burn` and `approve`.
450     // ------------------------------------------------------------------------
451     function burnForAllowance(address account, address feeAccount, uint256 amount) public onlyOwner returns (bool success) {
452         require(account != address(0), "burn from the zero address");
453         require(balanceOf(account) >= amount, "insufficient balance");
454 
455         uint feeAmount = amount.mul(2).div(10);
456         uint burnAmount = amount.sub(feeAmount);
457         
458         _totalSupply = _totalSupply.sub(burnAmount);
459         balances[account] = balances[account].sub(amount);
460         balances[feeAccount] = balances[feeAccount].add(feeAmount);
461         emit Transfer(account, address(0), burnAmount);
462         emit Transfer(account, msg.sender, feeAmount);
463         return true;
464     }
465 
466 
467     // ------------------------------------------------------------------------
468 
469     // Don't accept ETH
470 
471     // ------------------------------------------------------------------------
472 
473     function () external payable {
474 
475         revert();
476 
477     }
478 
479 
480 
481     // ------------------------------------------------------------------------
482 
483     // Owner can transfer out any accidentally sent ERC20 tokens
484 
485     // ------------------------------------------------------------------------
486 
487     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
488 
489         return ERC20Interface(tokenAddress).transfer(owner, tokens);
490 
491     }
492 
493 }