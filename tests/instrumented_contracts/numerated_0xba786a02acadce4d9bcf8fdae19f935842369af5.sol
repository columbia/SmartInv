1 /**
2 
3 *Submitted for verification at Etherscan.io on 2020-09-16
4 
5 */
6 
7 
8 // SPDX-License-Identifier: MIT
9 
10 
11 pragma solidity ^0.6.0;
12 
13 
14 
15 abstract contract Context {
16 
17 function _msgSender() internal view virtual returns (address payable) {
18 
19 return msg.sender;
20 
21 }
22 
23 
24 function _msgData() internal view virtual returns (bytes memory) {
25 
26 this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27 
28 return msg.data;
29 
30 }
31 
32 }
33 
34 
35 
36 
37 
38 library SafeMath {
39 
40 
41 function add(uint256 a, uint256 b) internal pure returns (uint256) {
42 
43 uint256 c = a + b;
44 
45 require(c >= a, "SafeMath: addition overflow");
46 
47 
48 return c;
49 
50 }
51 
52 
53 
54 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55 
56 return sub(a, b, "SafeMath: subtraction overflow");
57 
58 }
59 
60 
61 
62 function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63 
64 require(b <= a, errorMessage);
65 
66 uint256 c = a - b;
67 
68 
69 return c;
70 
71 }
72 
73 
74 
75 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76 
77 
78 if (a == 0) {
79 
80 return 0;
81 
82 }
83 
84 
85 uint256 c = a * b;
86 
87 require(c / a == b, "SafeMath: multiplication overflow");
88 
89 
90 return c;
91 
92 }
93 
94 
95 
96 function div(uint256 a, uint256 b) internal pure returns (uint256) {
97 
98 return div(a, b, "SafeMath: division by zero");
99 
100 }
101 
102 
103 
104 function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
105 
106 require(b > 0, errorMessage);
107 
108 uint256 c = a / b;
109 
110 // assert(a == b * c + a % b); // There is no case in which this doesn't hold
111 
112 
113 return c;
114 
115 }
116 
117 
118 
119 function mod(uint256 a, uint256 b) internal pure returns (uint256) {
120 
121 return mod(a, b, "SafeMath: modulo by zero");
122 
123 }
124 
125 
126 function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
127 
128 require(b != 0, errorMessage);
129 
130 return a % b;
131 
132 }
133 
134 }
135 
136 
137 
138 
139 contract Pausable is Context {
140 
141 
142 event Paused(address account);
143 
144 
145 event Unpaused(address account);
146 
147 
148 bool private _paused;
149 
150 
151 constructor () internal {
152 
153 _paused = false;
154 
155 }
156 
157 
158 
159 function paused() public view returns (bool) {
160 
161 return _paused;
162 
163 }
164 
165 
166 modifier whenNotPaused() {
167 
168 require(!_paused, "Pausable: paused");
169 
170 _;
171 
172 }
173 
174 
175 modifier whenPaused() {
176 
177 require(_paused, "Pausable: not paused");
178 
179 _;
180 
181 }
182 
183 
184 function _pause() internal virtual whenNotPaused {
185 
186 _paused = true;
187 
188 emit Paused(_msgSender());
189 
190 }
191 
192 
193 function _unpause() internal virtual whenPaused {
194 
195 _paused = false;
196 
197 emit Unpaused(_msgSender());
198 
199 }
200 
201 }
202 
203 
204 
205 interface IERC20 {
206 
207 
208 function totalSupply() external view returns (uint256);
209 
210 
211 function balanceOf(address account) external view returns (uint256);
212 
213 
214 
215 function transfer(address recipient, uint256 amount) external returns (bool);
216 
217 
218 function allowance(address owner, address spender) external view returns (uint256);
219 
220 
221 
222 function approve(address spender, uint256 amount) external returns (bool);
223 
224 
225 
226 function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
227 
228 
229 event Transfer(address indexed from, address indexed to, uint256 value);
230 
231 
232 event Approval(address indexed owner, address indexed spender, uint256 value);
233 
234 }
235 
236 
237 
238 pragma solidity ^0.6.0;
239 
240 contract Ownable is Context {
241 
242 address private _owner;
243 
244 
245 event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
246 
247 
248 
249 constructor () internal {
250 
251 address msgSender = _msgSender();
252 
253 _owner = msgSender;
254 
255 emit OwnershipTransferred(address(0), msgSender);
256 
257 }
258 
259 
260 
261 function owner() public view returns (address) {
262 
263 return _owner;
264 
265 }
266 
267 
268 
269 modifier onlyOwner() {
270 
271 require(_owner == _msgSender(), "Ownable: caller is not the owner");
272 
273 _;
274 
275 }
276 
277 
278 
279 
280 function transferOwnership(address newOwner) public virtual onlyOwner {
281 
282 require(newOwner != address(0), "Ownable: new owner is the zero address");
283 
284 emit OwnershipTransferred(_owner, newOwner);
285 
286 _owner = newOwner;
287 
288 }
289 
290 }
291 
292 
293 
294 contract ERC20 is Context, IERC20, Pausable,Ownable {
295 
296 using SafeMath for uint256;
297 
298 mapping (address => uint256) public blackList;
299 
300 mapping (address => uint256) private _balances;
301 
302 mapping (address => mapping (address => uint256)) private _allowances;
303 
304 event Transfer(address indexed from, address indexed to, uint value);
305 
306 event Blacklisted(address indexed target);
307 
308 event DeleteFromBlacklist(address indexed target);
309 
310 event RejectedPaymentToBlacklistedAddr(address indexed from, address indexed to, uint value);
311 
312 event RejectedPaymentFromBlacklistedAddr(address indexed from, address indexed to, uint value);
313 
314 
315 uint256 private _totalSupply;
316 
317 string private _name;
318 
319 string private _symbol;
320 
321 uint8 private _decimals;
322 
323 
324 constructor (string memory name, string memory symbol) public {
325 
326 _name = name;
327 
328 _symbol = symbol;
329 
330 _decimals = 18;
331 
332 }
333 
334 
335 function blacklisting(address _addr) onlyOwner() public{
336 
337 blackList[_addr] = 1;
338 
339 Blacklisted(_addr);
340 
341 }
342 
343 
344 function deleteFromBlacklist(address _addr) onlyOwner() public{
345 
346 blackList[_addr] = 0;
347 
348 DeleteFromBlacklist(_addr);
349 
350 }
351 
352 
353 function name() public view returns (string memory) {
354 
355 return _name;
356 
357 }
358 
359 
360 function symbol() public view returns (string memory) {
361 
362 return _symbol;
363 
364 }
365 
366 
367 
368 function decimals() public view returns (uint8) {
369 
370 return _decimals;
371 
372 }
373 
374 
375 function totalSupply() public view override returns (uint256) {
376 
377 return _totalSupply;
378 
379 }
380 
381 
382 function balanceOf(address account) public view override returns (uint256) {
383 
384 return _balances[account];
385 
386 }
387 
388 
389 function transfer(address recipient, uint256 amount) public virtual whenNotPaused() override returns (bool) {
390 
391 _transfer(_msgSender(), recipient, amount);
392 
393 return true;
394 
395 }
396 
397 
398 
399 function allowance(address owner, address spender) public view virtual override returns (uint256) {
400 
401 return _allowances[owner][spender];
402 
403 }
404 
405 
406 
407 function approve(address spender, uint256 amount) public virtual override returns (bool) {
408 
409 _approve(_msgSender(), spender, amount);
410 
411 return true;
412 
413 }
414 
415 
416 function transferFrom(address sender, address recipient, uint256 amount) public virtual whenNotPaused() override returns (bool) {
417 
418 _transfer(sender, recipient, amount);
419 
420 _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
421 
422 return true;
423 
424 }
425 
426 
427 function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
428 
429 _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
430 
431 return true;
432 
433 }
434 
435 
436 function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
437 
438 _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
439 
440 return true;
441 
442 }
443 
444 
445 function _transfer(address sender, address recipient, uint256 amount) internal virtual {
446 
447 require(sender != address(0), "ERC20: transfer from the zero address");
448 
449 require(recipient != address(0), "ERC20: transfer to the zero address");
450 
451 if(blackList[msg.sender] == 1){
452 
453 RejectedPaymentFromBlacklistedAddr(msg.sender, recipient, amount);
454 
455 require(false,"You are BlackList");
456 
457 }
458 
459 else if(blackList[recipient] == 1){
460 
461 RejectedPaymentToBlacklistedAddr(msg.sender, recipient, amount);
462 
463 require(false,"recipient are BlackList");
464 
465 }
466 
467 else{
468 
469 _beforeTokenTransfer(sender, recipient, amount);
470 
471 
472 _balances[sender] = _balances[sender].sub(amount, "transfer amount exceeds balance");
473 
474 _balances[recipient] = _balances[recipient].add(amount);
475 
476 emit Transfer(sender, recipient, amount);
477 
478 }
479 
480 }
481 
482 
483 function _mint(address account, uint256 amount) internal virtual {
484 
485 require(account != address(0), "ERC20: mint to the zero address");
486 
487 
488 _beforeTokenTransfer(address(0), account, amount);
489 
490 
491 _totalSupply = _totalSupply.add(amount);
492 
493 _balances[account] = _balances[account].add(amount);
494 
495 emit Transfer(address(0), account, amount);
496 
497 }
498 
499 
500 function _burn(address account, uint256 amount) internal virtual {
501 
502 require(account != address(0), "ERC20: burn from the zero address");
503 
504 
505 _beforeTokenTransfer(account, address(0), amount);
506 
507 
508 _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
509 
510 _totalSupply = _totalSupply.sub(amount);
511 
512 emit Transfer(account, address(0), amount);
513 
514 }
515 
516 
517 function _approve(address owner, address spender, uint256 amount) internal virtual {
518 
519 require(owner != address(0), "ERC20: approve from the zero address");
520 
521 require(spender != address(0), "ERC20: approve to the zero address");
522 
523 
524 _allowances[owner][spender] = amount;
525 
526 emit Approval(owner, spender, amount);
527 
528 }
529 
530 
531 function _setupDecimals(uint8 decimals_) internal {
532 
533 _decimals = decimals_;
534 
535 }
536 
537 
538 function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
539 
540 }
541 
542 
543 
544 abstract contract ERC20Burnable is Context, ERC20 {
545 
546 
547 function burn(uint256 amount) public virtual {
548 
549 _burn(_msgSender(), amount);
550 
551 }
552 
553 
554 function burnFrom(address account, uint256 amount) public virtual {
555 
556 uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
557 
558 
559 _approve(account, _msgSender(), decreasedAllowance);
560 
561 _burn(account, amount);
562 
563 }
564 
565 }
566 
567 
568 
569 
570 contract SuperVirusKillerToken is ERC20,ERC20Burnable {
571 
572 constructor(uint256 initialSupply) public ERC20("Super Virus Killer", "SVK") {
573 
574 _mint(msg.sender, initialSupply);
575 
576 }
577 
578 function mint(uint256 initialSupply) onlyOwner() public {
579 
580 _mint(msg.sender, initialSupply);
581 
582 }
583 
584 
585 function pause() onlyOwner() public {
586 
587 _pause();
588 
589 }
590 
591 function unpause() onlyOwner() public {
592 
593 _unpause();
594 
595 }
596 
597 }