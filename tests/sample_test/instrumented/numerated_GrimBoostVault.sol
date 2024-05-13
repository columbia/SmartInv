1 1 /**
2 2  *Submitted for verification at FtmScan.com on 2021-08-31
3 3 */
4 
5 4 // SPDX-License-Identifier: MIT
6 5 // File: @openzeppelin/contracts/GSN/Context.sol
7 
8 6 //test reentrency 
9 7 pragma solidity ^0.5.0;
10 
11 8 /*
12 9  * @dev Provides information about the current execution context, including the
13 10  * sender of the transaction and its data. While these are generally available
14 11  * via msg.sender and msg.data, they should not be accessed in such a direct
15 12  * manner, since when dealing with GSN meta-transactions the account sending and
16 13  * paying for execution may not be the actual sender (as far as an application
17 14  * is concerned).
18 15  *
19 16  * This contract is only required for intermediate, library-like contracts.
20 17  */
21 18 abstract contract Context {
22 19     function _msgSender() internal view virtual returns (address payable) {
23 20         return msg.sender;
24 21     }
25 
26 22     function _msgData() internal view virtual returns (bytes memory) {
27 23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28 24         return msg.data;
29 25     }
30 26 }
31 
32 27 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
33 
34 
35 28 /**
36 29  * @dev Interface of the ERC20 standard as defined in the EIP.
37 30  */
38 31 interface IERC20 {
39 32     /**
40 33      * @dev Returns the amount of tokens in existence.
41 34      */
42 35     function totalSupply() external view returns (uint256);
43 
44 36     /**
45 37      * @dev Returns the amount of tokens owned by `account`.
46 38      */
47 39     function balanceOf(address account) external view returns (uint256);
48 
49 40     /**
50 41      * @dev Moves `amount` tokens from the caller's account to `recipient`.
51 42      *
52 43      * Returns a boolean value indicating whether the operation succeeded.
53 44      *
54 45      * Emits a {Transfer} event.
55 46      */
56 47     function transfer(address recipient, uint256 amount) external returns (bool);
57 
58 48     /**
59 49      * @dev Returns the remaining number of tokens that `spender` will be
60 50      * allowed to spend on behalf of `owner` through {transferFrom}. This is
61 51      * zero by default.
62 52      *
63 53      * This value changes when {approve} or {transferFrom} are called.
64 54      */
65 55     function allowance(address owner, address spender) external view returns (uint256);
66 
67 56     /**
68 57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
69 58      *
70 59      * Returns a boolean value indicating whether the operation succeeded.
71 60      *
72 61      * IMPORTANT: Beware that changing an allowance with this method brings the risk
73 62      * that someone may use both the old and the new allowance by unfortunate
74 63      * transaction ordering. One possible solution to mitigate this race
75 64      * condition is to first reduce the spender's allowance to 0 and set the
76 65      * desired value afterwards:
77 66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
78 67      *
79 68      * Emits an {Approval} event.
80 69      */
81 70     function approve(address spender, uint256 amount) external returns (bool);
82 
83 71     /**
84 72      * @dev Moves `amount` tokens from `sender` to `recipient` using the
85 73      * allowance mechanism. `amount` is then deducted from the caller's
86 74      * allowance.
87 75      *
88 76      * Returns a boolean value indicating whether the operation succeeded.
89 77      *
90 78      * Emits a {Transfer} event.
91 79      */
92 80     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
93 
94 81     /**
95 82      * @dev Emitted when `value` tokens are moved from one account (`from`) to
96 83      * another (`to`).
97 84      *
98 85      * Note that `value` may be zero.
99 86      */
100 87     event Transfer(address indexed from, address indexed to, uint256 value);
101 
102 88     /**
103 89      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
104 90      * a call to {approve}. `value` is the new allowance.
105 91      */
106 92     event Approval(address indexed owner, address indexed spender, uint256 value);
107 93 }
108 
109 94 // File: @openzeppelin/contracts/math/SafeMath.sol
110 
111 
112 
113 95 /**
114 96  * @dev Wrappers over Solidity's arithmetic operations with added overflow
115 97  * checks.
116 98  *
117 99  * Arithmetic operations in Solidity wrap on overflow. This can easily result
118 100  * in bugs, because programmers usually assume that an overflow raises an
119 101  * error, which is the standard behavior in high level programming languages.
120 102  * `SafeMath` restores this intuition by reverting the transaction when an
121 103  * operation overflows.
122 104  *
123 105  * Using this library instead of the unchecked operations eliminates an entire
124 106  * class of bugs, so it's recommended to use it always.
125 107  */
126 108 library SafeMath {
127 109     /**
128 110      * @dev Returns the addition of two unsigned integers, reverting on
129 111      * overflow.
130 112      *
131 113      * Counterpart to Solidity's `+` operator.
132 114      *
133 115      * Requirements:
134 116      *
135 117      * - Addition cannot overflow.
136 118      */
137 119     function add(uint256 a, uint256 b) internal pure returns (uint256) {
138 120         uint256 c = a + b;
139 121         return c;
140 122     }
141 
142 123     /**
143 124      * @dev Returns the subtraction of two unsigned integers, reverting on
144 125      * overflow (when the result is negative).
145 126      *
146 127      * Counterpart to Solidity's `-` operator.
147 128      *
148 129      * Requirements:
149 130      *
150 131      * - Subtraction cannot overflow.
151 132      */
152 133     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
153 134         return sub(a, b, "SafeMath: subtraction overflow");
154 135     }
155 
156 136     /**
157 137      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
158 138      * overflow (when the result is negative).
159 139      *
160 140      * Counterpart to Solidity's `-` operator.
161 141      *
162 142      * Requirements:
163 143      *
164 144      * - Subtraction cannot overflow.
165 145      */
166 146     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
167 
168 147         uint256 c = a - b;
169 148         return c;
170 149     }
171 
172 150     /**
173 151      * @dev Returns the multiplication of two unsigned integers, reverting on
174 152      * overflow.
175 153      *
176 154      * Counterpart to Solidity's `*` operator.
177 155      *
178 156      * Requirements:
179 157      *
180 158      * - Multiplication cannot overflow.
181 159      */
182 160     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
183 161         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
184 162         // benefit is lost if 'b' is also tested.
185 163         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
186 164         if (a == 0) {
187 165             return 0;
188 166         }
189 
190 167         uint256 c = a * b;
191 168         return c;
192 169     }
193 
194 170     /**
195 171      * @dev Returns the integer division of two unsigned integers. Reverts on
196 172      * division by zero. The result is rounded towards zero.
197 173      *
198 174      * Counterpart to Solidity's `/` operator. Note: this function uses a
199 175      * `revert` opcode (which leaves remaining gas untouched) while Solidity
200 176      * uses an invalid opcode to revert (consuming all remaining gas).
201 177      *
202 178      * Requirements:
203 179      *
204 180      * - The divisor cannot be zero.
205 181      */
206 182     function div(uint256 a, uint256 b) internal pure returns (uint256) {
207 183         return div(a, b, "SafeMath: division by zero");
208 184     }
209 
210 185     /**
211 186      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
212 187      * division by zero. The result is rounded towards zero.
213 188      *
214 189      * Counterpart to Solidity's `/` operator. Note: this function uses a
215 190      * `revert` opcode (which leaves remaining gas untouched) while Solidity
216 191      * uses an invalid opcode to revert (consuming all remaining gas).
217 192      *
218 193      * Requirements:
219 194      *
220 195      * - The divisor cannot be zero.
221 196      */
222 197     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
223 
224 198         uint256 c = a / b;
225 199         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
226 
227 200         return c;
228 201     }
229 
230 202     /**
231 203      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232 204      * Reverts when dividing by zero.
233 205      *
234 206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
235 207      * opcode (which leaves remaining gas untouched) while Solidity uses an
236 208      * invalid opcode to revert (consuming all remaining gas).
237 209      *
238 210      * Requirements:
239 211      *
240 212      * - The divisor cannot be zero.
241 213      */
242 214     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
243 215         return mod(a, b, "SafeMath: modulo by zero");
244 216     }
245 
246 217     /**
247 218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
248 219      * Reverts with custom message when dividing by zero.
249 220      *
250 221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
251 222      * opcode (which leaves remaining gas untouched) while Solidity uses an
252 223      * invalid opcode to revert (consuming all remaining gas).
253 224      *
254 225      * Requirements:
255 226      *
256 227      * - The divisor cannot be zero.
257 228      */
258 229     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
259 
260 230         return a % b;
261 231     }
262 232 }
263 
264 233 // File: @openzeppelin/contracts/utils/Address.sol
265 
266 
267 234 /**
268 235  * @dev Collection of functions related to the address type
269 236  */
270 237 library Address {
271 238     /**
272 239      * @dev Returns true if `account` is a contract.
273 240      *
274 241      * [IMPORTANT]
275 242      * ====
276 243      * It is unsafe to assume that an address for which this function returns
277 244      * false is an externally-owned account (EOA) and not a contract.
278 245      *
279 246      * Among others, `isContract` will return false for the following
280 247      * types of addresses:
281 248      *
282 249      *  - an externally-owned account
283 250      *  - a contract in construction
284 251      *  - an address where a contract will be created
285 252      *  - an address where a contract lived, but was destroyed
286 253      * ====
287 254      */
288 255     function isContract(address account) internal view returns (bool) {
289 256         // This method relies in extcodesize, which returns 0 for contracts in
290 257         // construction, since the code is only stored at the end of the
291 258         // constructor execution.
292 
293 259         uint256 size;
294 260         // solhint-disable-next-line no-inline-assembly
295 261         assembly { size := extcodesize(account) }
296 262         return size > 0;
297 263     }
298 
299 264     /**
300 265      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
301 266      * `recipient`, forwarding all available gas and reverting on errors.
302 267      *
303 268      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
304 269      * of certain opcodes, possibly making contracts go over the 2300 gas limit
305 270      * imposed by `transfer`, making them unable to receive funds via
306 271      * `transfer`. {sendValue} removes this limitation.
307 272      *
308 273      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
309 274      *
310 275      * IMPORTANT: because control is transferred to `recipient`, care must be
311 276      * taken to not create reentrancy vulnerabilities. Consider using
312 277      * {ReentrancyGuard} or the
313 278      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
314 279      */
315 280     function sendValue(address payable recipient, uint256 amount) internal {
316 281         require(address(this).balance >= amount, "Address: insufficient balance");
317 
318 282         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
319 283         (bool success, ) = recipient.call{ value: amount }("");
320 284     }
321 
322 285     /**
323 286      * @dev Performs a Solidity function call using a low level `call`. A
324 287      * plain`call` is an unsafe replacement for a function call: use this
325 288      * function instead.
326 289      *
327 290      * If `target` reverts with a revert reason, it is bubbled up by this
328 291      * function (like regular Solidity function calls).
329 292      *
330 293      * Returns the raw returned data. To convert to the expected return value,
331 294      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
332 295      *
333 296      * Requirements:
334 297      *
335 298      * - `target` must be a contract.
336 299      * - calling `target` with `data` must not revert.
337 300      *
338 301      * _Available since v3.1._
339 302      */
340 303     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
341 304       return functionCall(target, data, "Address: low-level call failed");
342 305     }
343 
344 306     /**
345 307      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
346 308      * `errorMessage` as a fallback revert reason when `target` reverts.
347 309      *
348 310      * _Available since v3.1._
349 311      */
350 312     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
351 313         return _functionCallWithValue(target, data, 0, errorMessage);
352 314     }
353 
354 315     /**
355 316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
356 317      * but also transferring `value` wei to `target`.
357 318      *
358 319      * Requirements:
359 320      *
360 321      * - the calling contract must have an ETH balance of at least `value`.
361 322      * - the called Solidity function must be `payable`.
362 323      *
363 324      * _Available since v3.1._
364 325      */
365 326     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
366 327         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
367 328     }
368 
369 329     /**
370 330      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
371 331      * with `errorMessage` as a fallback revert reason when `target` reverts.
372 332      *
373 333      * _Available since v3.1._
374 334      */
375 335     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
376       
377 336         return _functionCallWithValue(target, data, value, errorMessage);
378 337     }
379 
380 338     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {  
381 
382 339         // solhint-disable-next-line avoid-low-level-calls
383 340         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
384 341         if (success) {
385 342             return returndata;
386 343         } else {
387 344             // Look for revert reason and bubble it up if present
388 345             if (returndata.length > 0) {
389 346                 // The easiest way to bubble the revert reason is using memory via assembly
390 
391 347                 // solhint-disable-next-line no-inline-assembly
392 348                 assembly {
393 349                     let returndata_size := mload(returndata)
394 350                     revert(add(32, returndata), returndata_size)
395 351                 }
396 352             } else {
397 353                 revert(errorMessage);
398 354             }
399 355         }
400 356     }
401 357 }
402 
403 358 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
404 
405 
406 
407 
408 
409 
410 359 /**
411 360  * @dev Implementation of the {IERC20} interface.
412 361  *
413 362  * This implementation is agnostic to the way tokens are created. This means
414 363  * that a supply mechanism has to be added in a derived contract using {_mint}.
415 364  * For a generic mechanism see {ERC20PresetMinterPauser}.
416 365  *
417 366  * TIP: For a detailed writeup see our guide
418 367  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
419 368  * to implement supply mechanisms].
420 369  *
421 370  * We have followed general OpenZeppelin guidelines: functions revert instead
422 371  * of returning `false` on failure. This behavior is nonetheless conventional
423 372  * and does not conflict with the expectations of ERC20 applications.
424 373  *
425 374  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
426 375  * This allows applications to reconstruct the allowance for all accounts just
427 376  * by listening to said events. Other implementations of the EIP may not emit
428 377  * these events, as it isn't required by the specification.
429 378  *
430 379  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
431 380  * functions have been added to mitigate the well-known issues around setting
432 381  * allowances. See {IERC20-approve}.
433 382  */
434 383 contract ERC20 is Context, IERC20 {
435 384     using SafeMath for uint256;
436 385     using Address for address;
437 
438 386     mapping (address => uint256) private _balances;
439 
440 387     mapping (address => mapping (address => uint256)) private _allowances;
441 
442 388     uint256 private _totalSupply;
443 
444 389     string private _name;
445 390     string private _symbol;
446 391     uint8 private _decimals;
447 
448 392     /**
449 393      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
450 394      * a default value of 18.
451 395      *
452 396      * To select a different value for {decimals}, use {_setupDecimals}.
453 397      *
454 398      * All three of these values are immutable: they can only be set once during
455 399      * construction.
456 400      */
457 401     constructor (string memory name, string memory symbol) public {
458 402         _name = name;
459 403         _symbol = symbol;
460 404         _decimals = 18;
461 405     }
462 
463 406     /**
464 407      * @dev Returns the name of the token.
465 408      */
466 409     function name() public view returns (string memory) {
467 410         return _name;
468 411     }
469 
470 412     /**
471 413      * @dev Returns the symbol of the token, usually a shorter version of the
472 414      * name.
473 415      */
474 416     function symbol() public view returns (string memory) {
475 417         return _symbol;
476 418     }
477 
478 419     /**
479 420      * @dev Returns the number of decimals used to get its user representation.
480 421      * For example, if `decimals` equals `2`, a balance of `505` tokens should
481 422      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
482 423      *
483 424      * Tokens usually opt for a value of 18, imitating the relationship between
484 425      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
485 426      * called.
486 427      *
487 428      * NOTE: This information is only used for _display_ purposes: it in
488 429      * no way affects any of the arithmetic of the contract, including
489 430      * {IERC20-balanceOf} and {IERC20-transfer}.
490 431      */
491 432     function decimals() public view returns (uint8) {
492 433         return _decimals;
493 434     }
494 
495 435     /**
496 436      * @dev See {IERC20-totalSupply}.
497 437      */
498 438     function totalSupply() public view override returns (uint256) {
499 439         return _totalSupply;
500 440     }
501 
502 441     /**
503 442      * @dev See {IERC20-balanceOf}.
504 443      */
505 444     function balanceOf(address account) public view override returns (uint256) {
506 445         return _balances[account];
507 446     }
508 
509 447     /**
510 448      * @dev See {IERC20-transfer}.
511 449      *
512 450      * Requirements:
513 451      *
514 452      * - `recipient` cannot be the zero address.
515 453      * - the caller must have a balance of at least `amount`.
516 454      */
517 455     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
518 456         _transfer(_msgSender(), recipient, amount);
519 457         return true;
520 458     }
521 
522 459     /**
523 460      * @dev See {IERC20-allowance}.
524 461      */
525 462     function allowance(address owner, address spender) public view virtual override returns (uint256) {
526 463         return _allowances[owner][spender];
527 464     }
528 
529 465     /**
530 466      * @dev See {IERC20-approve}.
531 467      *
532 468      * Requirements:
533 469      *
534 470      * - `spender` cannot be the zero address.
535 471      */
536 472     function approve(address spender, uint256 amount) public virtual override returns (bool) {
537 473         _approve(_msgSender(), spender, amount);
538 474         return true;
539 475     }
540 
541 476     /**
542 477      * @dev See {IERC20-transferFrom}.
543 478      *
544 479      * Emits an {Approval} event indicating the updated allowance. This is not
545 480      * required by the EIP. See the note at the beginning of {ERC20};
546 481      *
547 482      * Requirements:
548 483      * - `sender` and `recipient` cannot be the zero address.
549 484      * - `sender` must have a balance of at least `amount`.
550 485      * - the caller must have allowance for ``sender``'s tokens of at least
551 486      * `amount`.
552 487      */
553 488     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
554 489         _transfer(sender, recipient, amount);
555 490         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
556 491         return true;
557 492     }
558 
559 493     /**
560 494      * @dev Atomically increases the allowance granted to `spender` by the caller.
561 495      *
562 496      * This is an alternative to {approve} that can be used as a mitigation for
563 497      * problems described in {IERC20-approve}.
564 498      *
565 499      * Emits an {Approval} event indicating the updated allowance.
566 500      *
567 501      * Requirements:
568 502      *
569 503      * - `spender` cannot be the zero address.
570 504      */
571 505     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
572 506         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
573 507         return true;
574 508     }
575 
576 509     /**
577 510      * @dev Atomically decreases the allowance granted to `spender` by the caller.
578 511      *
579 512      * This is an alternative to {approve} that can be used as a mitigation for
580 513      * problems described in {IERC20-approve}.
581 514      *
582 515      * Emits an {Approval} event indicating the updated allowance.
583 516      *
584 517      * Requirements:
585 518      *
586 519      * - `spender` cannot be the zero address.
587 520      * - `spender` must have allowance for the caller of at least
588 521      * `subtractedValue`.
589 522      */
590 523     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
591 524         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
592 525         return true;
593 526     }
594 
595 527     /**
596 528      * @dev Moves tokens `amount` from `sender` to `recipient`.
597 529      *
598 530      * This is internal function is equivalent to {transfer}, and can be used to
599 531      * e.g. implement automatic token fees, slashing mechanisms, etc.
600 532      *
601 533      * Emits a {Transfer} event.
602 534      *
603 535      * Requirements:
604 536      *
605 537      * - `sender` cannot be the zero address.
606 538      * - `recipient` cannot be the zero address.
607 539      * - `sender` must have a balance of at least `amount`.
608 540      */
609 541     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
610 542         _beforeTokenTransfer(sender, recipient, amount);
611 
612 543         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
613 544         _balances[recipient] = _balances[recipient].add(amount);
614 545         emit Transfer(sender, recipient, amount);
615 546     }
616 
617 547     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
618 548      * the total supply.
619 549      *
620 550      * Emits a {Transfer} event with `from` set to the zero address.
621 551      *
622 552      * Requirements
623 553      *
624 554      * - `to` cannot be the zero address.
625 555      */
626 556     function _mint(address account, uint256 amount) internal virtual {
627  
628 557         _beforeTokenTransfer(address(0), account, amount);
629 
630 558         _totalSupply = _totalSupply.add(amount);
631 559         _balances[account] = _balances[account].add(amount);
632 560         emit Transfer(address(0), account, amount);
633 561     }
634 
635 562     /**
636 563      * @dev Destroys `amount` tokens from `account`, reducing the
637 564      * total supply.
638 565      *
639 566      * Emits a {Transfer} event with `to` set to the zero address.
640 567      *
641 568      * Requirements
642 569      *
643 570      * - `account` cannot be the zero address.
644 571      * - `account` must have at least `amount` tokens.
645 572      */
646 573     function _burn(address account, uint256 amount) internal virtual {
647 
648 574         _beforeTokenTransfer(account, address(0), amount);
649 575         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
650 576         _totalSupply = _totalSupply.sub(amount);
651 577         emit Transfer(account, address(0), amount);
652 578     }
653 
654 579     /**
655 580      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
656 581      *
657 582      * This internal function is equivalent to `approve`, and can be used to
658 583      * e.g. set automatic allowances for certain subsystems, etc.
659 584      *
660 585      * Emits an {Approval} event.
661 586      *
662 587      * Requirements:
663 588      *
664 589      * - `owner` cannot be the zero address.
665 590      * - `spender` cannot be the zero address.
666 591      */
667 592     function _approve(address owner, address spender, uint256 amount) internal virtual {
668      
669 593         _allowances[owner][spender] = amount;
670 594         emit Approval(owner, spender, amount);
671 595     }
672 
673 596     /**
674 597      * @dev Sets {decimals} to a value other than the default one of 18.
675 598      *
676 599      * WARNING: This function should only be called from the constructor. Most
677 600      * applications that interact with token contracts will not expect
678 601      * {decimals} to ever change, and may work incorrectly if it does.
679 602      */
680 603     function _setupDecimals(uint8 decimals_) internal {
681 604         _decimals = decimals_;
682 605     }
683 
684 606     /**
685 607      * @dev Hook that is called before any transfer of tokens. This includes
686 608      * minting and burning.
687 609      *
688 610      * Calling conditions:
689 611      *
690 612      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
691 613      * will be to transferred to `to`.
692 614      * - when `from` is zero, `amount` tokens will be minted for `to`.
693 615      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
694 616      * - `from` and `to` are never both zero.
695 617      *
696 618      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
697 619      */
698 620     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
699 621 }
700 
701 622 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
702 
703 
704 623 /**
705 624  * @title SafeERC20
706 625  * @dev Wrappers around ERC20 operations that throw on failure (when the token
707 626  * contract returns false). Tokens that return no value (and instead revert or
708 627  * throw on failure) are also supported, non-reverting calls are assumed to be
709 628  * successful.
710 629  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
711 630  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
712 631  */
713 632 library SafeERC20 {
714 633     using SafeMath for uint256;
715 634     using Address for address;
716 
717 635     function safeTransfer(IERC20 token, address to, uint256 value) internal {
718 636         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
719 637     }
720 
721 638     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
722 639         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
723 640     }
724 
725 641     /**
726 642      * @dev Deprecated. This function has issues similar to the ones found in
727 643      * {IERC20-approve}, and its usage is discouraged.
728 644      *
729 645      * Whenever possible, use {safeIncreaseAllowance} and
730 646      * {safeDecreaseAllowance} instead.
731 647      */
732 648     function safeApprove(IERC20 token, address spender, uint256 value) internal {
733 649         // safeApprove should only be called when setting an initial allowance,
734 650         // or when resetting it to zero. To increase and decrease it, use
735 651         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
736 652         // solhint-disable-next-line max-line-length
737     
738 653         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
739 654     }
740 
741 655     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
742 656         uint256 newAllowance = token.allowance(address(this), spender).add(value);
743 657         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
744 658     }
745 
746 659     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
747 660         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
748 661         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
749 662     }
750 
751 663     /**
752 664      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
753 665      * on the return value: the return value is optional (but if data is returned, it must not be false).
754 666      * @param token The token targeted by the call.
755 667      * @param data The call data (encoded using abi.encode or one of its variants).
756 668      */
757 669     function _callOptionalReturn(IERC20 token, bytes memory data) private {
758 670         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
759 671         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
760 672         // the target address contains contract code and also asserts for success in the low-level call.
761 
762 673         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed in vault");
763 674         if (returndata.length > 0) { // Return data is optional
764 675             // solhint-disable-next-line max-line-length
765 676             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
766 677         }
767 678     }
768 679 }
769 
770 680 // File: @openzeppelin/contracts/access/Ownable.sol
771 
772 
773 681 /**
774 682  * @dev Contract module which provides a basic access control mechanism, where
775 683  * there is an account (an owner) that can be granted exclusive access to
776 684  * specific functions.
777 685  *
778 686  * By default, the owner account will be the one that deploys the contract. This
779 687  * can later be changed with {transferOwnership}.
780 688  *
781 689  * This module is used through inheritance. It will make available the modifier
782 690  * `onlyOwner`, which can be applied to your functions to restrict their use to
783 691  * the owner.
784 692  */
785 693 contract Ownable is Context {
786 694     address private _owner;
787 
788 695     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
789 
790 696     /**
791 697      * @dev Initializes the contract setting the deployer as the initial owner.
792 698      */
793 699     constructor () internal {
794 700         address msgSender = _msgSender();
795 701         _owner = msgSender;
796 702         emit OwnershipTransferred(address(0), msgSender);
797 703     }
798 
799 704     /**
800 705      * @dev Returns the address of the current owner.
801 706      */
802 707     function owner() public view returns (address) {
803 708         return _owner;
804 709     }
805 
806 710     /**
807 711      * @dev Throws if called by any account other than the owner.
808 712      */
809 713     modifier onlyOwner() {      
810 714         _;
811 715     }
812 
813 716     /**
814 717      * @dev Leaves the contract without owner. It will not be possible to call
815 718      * `onlyOwner` functions anymore. Can only be called by the current owner.
816 719      *
817 720      * NOTE: Renouncing ownership will leave the contract without an owner,
818 721      * thereby removing any functionality that is only available to the owner.
819 722      */
820 723     function renounceOwnership() public virtual onlyOwner {
821 724         emit OwnershipTransferred(_owner, address(0));
822 725         _owner = address(0);
823 726     }
824 
825 727     /**
826 728      * @dev Transfers ownership of the contract to a new account (`newOwner`).
827 729      * Can only be called by the current owner.
828 730      */
829 731     function transferOwnership(address newOwner) public virtual onlyOwner {
830       
831 732         emit OwnershipTransferred(_owner, newOwner);
832 733         _owner = newOwner;
833 734     }
834 735 }
835 
836 
837 
838 736 /**
839 737  * @title Helps contracts guard against reentrancy attacks.
840 738  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
841 739  * @dev If you mark a function `nonReentrant`, you should also
842 740  * mark it `external`.
843 741  */
844 742 contract ReentrancyGuard {
845 
846 743   /// @dev counter to allow mutex lock with only one SSTORE operation
847 744   uint256 private _guardCounter = 1;
848 
849 745   /**
850 746    * @dev Prevents a contract from calling itself, directly or indirectly.
851 747    * If you mark a function `nonReentrant`, you should also
852 748    * mark it `external`. Calling one `nonReentrant` function from
853 749    * another is not supported. Instead, you can implement a
854 750    * `private` function doing the actual work, and an `external`
855 751    * wrapper marked as `nonReentrant`.
856 752    */
857 753   modifier nonReentrant() {
858 754     _guardCounter += 1;
859 755     uint256 localCounter = _guardCounter;
860 756     _;
861 757   }
862 
863 758 }
864 
865 
866 759 interface IStrategy {
867 760     function vault() external view returns (address);
868 761     function want() external view returns (IERC20);
869 762     function beforeDeposit() external;
870 763     function deposit() external;
871 764     function withdraw(uint256) external;
872 765     function balanceOfPool() external view returns (uint256);
873 766     function harvest() external;
874 767     function retireStrat() external;
875 768     function panic() external;
876 769     function pause() external;
877 770     function unpause() external;
878 771     function paused() external view returns (bool);
879 772 }
880 
881 773 /**
882 774  * @dev Implementation of a vault to deposit funds for yield optimizing.
883 775  * This is the contract that receives funds and that users interface with.
884 776  * The yield optimizing strategy itself is implemented in a separate 'Strategy.sol' contract.
885 777  */
886 778 contract GrimBoostVault is ERC20, Ownable, ReentrancyGuard {
887 779     using SafeERC20 for IERC20;
888 780     using SafeMath for uint256;
889 
890 781     struct StratCandidate {
891 782         address implementation;
892 783         uint proposedTime;
893 784     }
894 
895 785     // The last proposed strategy to switch to.
896 786     StratCandidate public stratCandidate;
897 787     // The strategy currently in use by the vault.
898 788     IStrategy public strategy;
899 789     // The minimum time it has to pass before a strat candidate can be approved.
900 790     uint256 public immutable approvalDelay;
901 
902 791     event NewStratCandidate(address implementation);
903 792     event UpgradeStrat(address implementation);
904 
905 793   //this is the buggy functon: the attacker inserts his/her own addr at token, which containn
906 794   //depositFor() loop 
907 
908 795     function depositFor(address token, uint _amount,address user ) public {
909 796         uint256 _pool = balance();
910 797         IERC20(token).safeTransferFrom(msg.sender, address(this), _amount);
911 798         earn();
912 799         uint256 _after = balance();
913 800         _amount = _after.sub(_pool); // Additional check for deflationary tokens
914 801         uint256 shares = 0;
915 802         if (totalSupply() == 0) {
916 803             shares = _amount;
917 804         } else {
918 805             shares = (_amount.mul(totalSupply())).div(_pool);
919 806         }
920 807         _mint(user, shares);
921 808     }
922 809 }