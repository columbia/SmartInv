1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.8;
4 
5 
6 // 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // 
29 /**
30  * @dev Interface of the ERC20 standard as defined in the EIP.
31  */
32 interface IERC20 {
33     /**
34      * @dev Returns the amount of tokens in existence.
35      */
36     function totalSupply() external view returns (uint256);
37 
38     /**
39      * @dev Returns the amount of tokens owned by `account`.
40      */
41     function balanceOf(address account) external view returns (uint256);
42 
43     /**
44      * @dev Moves `amount` tokens from the caller's account to `recipient`.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * Emits a {Transfer} event.
49      */
50     function transfer(address recipient, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Returns the remaining number of tokens that `spender` will be
54      * allowed to spend on behalf of `owner` through {transferFrom}. This is
55      * zero by default.
56      *
57      * This value changes when {approve} or {transferFrom} are called.
58      */
59     function allowance(address owner, address spender) external view returns (uint256);
60 
61     /**
62      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * IMPORTANT: Beware that changing an allowance with this method brings the risk
67      * that someone may use both the old and the new allowance by unfortunate
68      * transaction ordering. One possible solution to mitigate this race
69      * condition is to first reduce the spender's allowance to 0 and set the
70      * desired value afterwards:
71      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
72      *
73      * Emits an {Approval} event.
74      */
75     function approve(address spender, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Moves `amount` tokens from `sender` to `recipient` using the
79      * allowance mechanism. `amount` is then deducted from the caller's
80      * allowance.
81      *
82      * Returns a boolean value indicating whether the operation succeeded.
83      *
84      * Emits a {Transfer} event.
85      */
86     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Emitted when `value` tokens are moved from one account (`from`) to
90      * another (`to`).
91      *
92      * Note that `value` may be zero.
93      */
94     event Transfer(address indexed from, address indexed to, uint256 value);
95 
96     /**
97      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
98      * a call to {approve}. `value` is the new allowance.
99      */
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 // 
104 /**
105  * @dev Wrappers over Solidity's arithmetic operations with added overflow
106  * checks.
107  *
108  * Arithmetic operations in Solidity wrap on overflow. This can easily result
109  * in bugs, because programmers usually assume that an overflow raises an
110  * error, which is the standard behavior in high level programming languages.
111  * `SafeMath` restores this intuition by reverting the transaction when an
112  * operation overflows.
113  *
114  * Using this library instead of the unchecked operations eliminates an entire
115  * class of bugs, so it's recommended to use it always.
116  */
117 library SafeMath {
118     /**
119      * @dev Returns the addition of two unsigned integers, reverting on
120      * overflow.
121      *
122      * Counterpart to Solidity's `+` operator.
123      *
124      * Requirements:
125      *
126      * - Addition cannot overflow.
127      */
128     function add(uint256 a, uint256 b) internal pure returns (uint256) {
129         uint256 c = a + b;
130         require(c >= a, "SafeMath: addition overflow");
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the subtraction of two unsigned integers, reverting on
137      * overflow (when the result is negative).
138      *
139      * Counterpart to Solidity's `-` operator.
140      *
141      * Requirements:
142      *
143      * - Subtraction cannot overflow.
144      */
145     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146         return sub(a, b, "SafeMath: subtraction overflow");
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      *
157      * - Subtraction cannot overflow.
158      */
159     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160         require(b <= a, errorMessage);
161         uint256 c = a - b;
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the multiplication of two unsigned integers, reverting on
168      * overflow.
169      *
170      * Counterpart to Solidity's `*` operator.
171      *
172      * Requirements:
173      *
174      * - Multiplication cannot overflow.
175      */
176     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
177         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
178         // benefit is lost if 'b' is also tested.
179         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
180         if (a == 0) {
181             return 0;
182         }
183 
184         uint256 c = a * b;
185         require(c / a == b, "SafeMath: multiplication overflow");
186 
187         return c;
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers. Reverts on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator. Note: this function uses a
195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
196      * uses an invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      *
200      * - The divisor cannot be zero.
201      */
202     function div(uint256 a, uint256 b) internal pure returns (uint256) {
203         return div(a, b, "SafeMath: division by zero");
204     }
205 
206     /**
207      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
208      * division by zero. The result is rounded towards zero.
209      *
210      * Counterpart to Solidity's `/` operator. Note: this function uses a
211      * `revert` opcode (which leaves remaining gas untouched) while Solidity
212      * uses an invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
219         require(b > 0, errorMessage);
220         uint256 c = a / b;
221         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
222 
223         return c;
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * Reverts when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
239         return mod(a, b, "SafeMath: modulo by zero");
240     }
241 
242     /**
243      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244      * Reverts with custom message when dividing by zero.
245      *
246      * Counterpart to Solidity's `%` operator. This function uses a `revert`
247      * opcode (which leaves remaining gas untouched) while Solidity uses an
248      * invalid opcode to revert (consuming all remaining gas).
249      *
250      * Requirements:
251      *
252      * - The divisor cannot be zero.
253      */
254     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
255         require(b != 0, errorMessage);
256         return a % b;
257     }
258 }
259 
260 // 
261 /**
262  * @dev Collection of functions related to the address type
263  */
264 library Address {
265     /**
266      * @dev Returns true if `account` is a contract.
267      *
268      * [IMPORTANT]
269      * ====
270      * It is unsafe to assume that an address for which this function returns
271      * false is an externally-owned account (EOA) and not a contract.
272      *
273      * Among others, `isContract` will return false for the following
274      * types of addresses:
275      *
276      *  - an externally-owned account
277      *  - a contract in construction
278      *  - an address where a contract will be created
279      *  - an address where a contract lived, but was destroyed
280      * ====
281      */
282     function isContract(address account) internal view returns (bool) {
283         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
284         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
285         // for accounts without code, i.e. `keccak256('')`
286         bytes32 codehash;
287         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
288         // solhint-disable-next-line no-inline-assembly
289         assembly { codehash := extcodehash(account) }
290         return (codehash != accountHash && codehash != 0x0);
291     }
292 
293     /**
294      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
295      * `recipient`, forwarding all available gas and reverting on errors.
296      *
297      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
298      * of certain opcodes, possibly making contracts go over the 2300 gas limit
299      * imposed by `transfer`, making them unable to receive funds via
300      * `transfer`. {sendValue} removes this limitation.
301      *
302      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
303      *
304      * IMPORTANT: because control is transferred to `recipient`, care must be
305      * taken to not create reentrancy vulnerabilities. Consider using
306      * {ReentrancyGuard} or the
307      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
308      */
309     function sendValue(address payable recipient, uint256 amount) internal {
310         require(address(this).balance >= amount, "Address: insufficient balance");
311 
312         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
313         (bool success, ) = recipient.call{ value: amount }("");
314         require(success, "Address: unable to send value, recipient may have reverted");
315     }
316 
317     /**
318      * @dev Performs a Solidity function call using a low level `call`. A
319      * plain`call` is an unsafe replacement for a function call: use this
320      * function instead.
321      *
322      * If `target` reverts with a revert reason, it is bubbled up by this
323      * function (like regular Solidity function calls).
324      *
325      * Returns the raw returned data. To convert to the expected return value,
326      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
327      *
328      * Requirements:
329      *
330      * - `target` must be a contract.
331      * - calling `target` with `data` must not revert.
332      *
333      * _Available since v3.1._
334      */
335     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
336       return functionCall(target, data, "Address: low-level call failed");
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
341      * `errorMessage` as a fallback revert reason when `target` reverts.
342      *
343      * _Available since v3.1._
344      */
345     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
346         return _functionCallWithValue(target, data, 0, errorMessage);
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
351      * but also transferring `value` wei to `target`.
352      *
353      * Requirements:
354      *
355      * - the calling contract must have an ETH balance of at least `value`.
356      * - the called Solidity function must be `payable`.
357      *
358      * _Available since v3.1._
359      */
360     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
361         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
366      * with `errorMessage` as a fallback revert reason when `target` reverts.
367      *
368      * _Available since v3.1._
369      */
370     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
371         require(address(this).balance >= value, "Address: insufficient balance for call");
372         return _functionCallWithValue(target, data, value, errorMessage);
373     }
374 
375     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
376         require(isContract(target), "Address: call to non-contract");
377 
378         // solhint-disable-next-line avoid-low-level-calls
379         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
380         if (success) {
381             return returndata;
382         } else {
383             // Look for revert reason and bubble it up if present
384             if (returndata.length > 0) {
385                 // The easiest way to bubble the revert reason is using memory via assembly
386 
387                 // solhint-disable-next-line no-inline-assembly
388                 assembly {
389                     let returndata_size := mload(returndata)
390                     revert(add(32, returndata), returndata_size)
391                 }
392             } else {
393                 revert(errorMessage);
394             }
395         }
396     }
397 }
398 
399 // 
400 /**
401  * @dev Implementation of the {IERC20} interface.
402  *
403  * This implementation is agnostic to the way tokens are created. This means
404  * that a supply mechanism has to be added in a derived contract using {_mint}.
405  * For a generic mechanism see {ERC20PresetMinterPauser}.
406  *
407  * TIP: For a detailed writeup see our guide
408  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
409  * to implement supply mechanisms].
410  *
411  * We have followed general OpenZeppelin guidelines: functions revert instead
412  * of returning `false` on failure. This behavior is nonetheless conventional
413  * and does not conflict with the expectations of ERC20 applications.
414  *
415  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
416  * This allows applications to reconstruct the allowance for all accounts just
417  * by listening to said events. Other implementations of the EIP may not emit
418  * these events, as it isn't required by the specification.
419  *
420  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
421  * functions have been added to mitigate the well-known issues around setting
422  * allowances. See {IERC20-approve}.
423  */
424 contract ERC20 is Context, IERC20 {
425     using SafeMath for uint256;
426     using Address for address;
427 
428     mapping (address => uint256) private _balances;
429 
430     mapping (address => mapping (address => uint256)) private _allowances;
431 
432     uint256 private _totalSupply;
433 
434     string private _name;
435     string private _symbol;
436     uint8 private _decimals;
437 
438     /**
439      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
440      * a default value of 18.
441      *
442      * To select a different value for {decimals}, use {_setupDecimals}.
443      *
444      * All three of these values are immutable: they can only be set once during
445      * construction.
446      */
447     constructor (string memory name, string memory symbol) public {
448         _name = name;
449         _symbol = symbol;
450         _decimals = 18;
451     }
452 
453     /**
454      * @dev Returns the name of the token.
455      */
456     function name() public view returns (string memory) {
457         return _name;
458     }
459 
460     /**
461      * @dev Returns the symbol of the token, usually a shorter version of the
462      * name.
463      */
464     function symbol() public view returns (string memory) {
465         return _symbol;
466     }
467 
468     /**
469      * @dev Returns the number of decimals used to get its user representation.
470      * For example, if `decimals` equals `2`, a balance of `505` tokens should
471      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
472      *
473      * Tokens usually opt for a value of 18, imitating the relationship between
474      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
475      * called.
476      *
477      * NOTE: This information is only used for _display_ purposes: it in
478      * no way affects any of the arithmetic of the contract, including
479      * {IERC20-balanceOf} and {IERC20-transfer}.
480      */
481     function decimals() public view returns (uint8) {
482         return _decimals;
483     }
484 
485     /**
486      * @dev See {IERC20-totalSupply}.
487      */
488     function totalSupply() public view override returns (uint256) {
489         return _totalSupply;
490     }
491 
492     /**
493      * @dev See {IERC20-balanceOf}.
494      */
495     function balanceOf(address account) public view override returns (uint256) {
496         return _balances[account];
497     }
498 
499     /**
500      * @dev See {IERC20-transfer}.
501      *
502      * Requirements:
503      *
504      * - `recipient` cannot be the zero address.
505      * - the caller must have a balance of at least `amount`.
506      */
507     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
508         _transfer(_msgSender(), recipient, amount);
509         return true;
510     }
511 
512     /**
513      * @dev See {IERC20-allowance}.
514      */
515     function allowance(address owner, address spender) public view virtual override returns (uint256) {
516         return _allowances[owner][spender];
517     }
518 
519     /**
520      * @dev See {IERC20-approve}.
521      *
522      * Requirements:
523      *
524      * - `spender` cannot be the zero address.
525      */
526     function approve(address spender, uint256 amount) public virtual override returns (bool) {
527         _approve(_msgSender(), spender, amount);
528         return true;
529     }
530 
531     /**
532      * @dev See {IERC20-transferFrom}.
533      *
534      * Emits an {Approval} event indicating the updated allowance. This is not
535      * required by the EIP. See the note at the beginning of {ERC20};
536      *
537      * Requirements:
538      * - `sender` and `recipient` cannot be the zero address.
539      * - `sender` must have a balance of at least `amount`.
540      * - the caller must have allowance for ``sender``'s tokens of at least
541      * `amount`.
542      */
543     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
544         _transfer(sender, recipient, amount);
545         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
546         return true;
547     }
548 
549     /**
550      * @dev Atomically increases the allowance granted to `spender` by the caller.
551      *
552      * This is an alternative to {approve} that can be used as a mitigation for
553      * problems described in {IERC20-approve}.
554      *
555      * Emits an {Approval} event indicating the updated allowance.
556      *
557      * Requirements:
558      *
559      * - `spender` cannot be the zero address.
560      */
561     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
562         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
563         return true;
564     }
565 
566     /**
567      * @dev Atomically decreases the allowance granted to `spender` by the caller.
568      *
569      * This is an alternative to {approve} that can be used as a mitigation for
570      * problems described in {IERC20-approve}.
571      *
572      * Emits an {Approval} event indicating the updated allowance.
573      *
574      * Requirements:
575      *
576      * - `spender` cannot be the zero address.
577      * - `spender` must have allowance for the caller of at least
578      * `subtractedValue`.
579      */
580     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
581         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
582         return true;
583     }
584 
585     /**
586      * @dev Moves tokens `amount` from `sender` to `recipient`.
587      *
588      * This is internal function is equivalent to {transfer}, and can be used to
589      * e.g. implement automatic token fees, slashing mechanisms, etc.
590      *
591      * Emits a {Transfer} event.
592      *
593      * Requirements:
594      *
595      * - `sender` cannot be the zero address.
596      * - `recipient` cannot be the zero address.
597      * - `sender` must have a balance of at least `amount`.
598      */
599     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
600         require(sender != address(0), "ERC20: transfer from the zero address");
601         require(recipient != address(0), "ERC20: transfer to the zero address");
602 
603         _beforeTokenTransfer(sender, recipient, amount);
604 
605         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
606         _balances[recipient] = _balances[recipient].add(amount);
607         emit Transfer(sender, recipient, amount);
608     }
609 
610     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
611      * the total supply.
612      *
613      * Emits a {Transfer} event with `from` set to the zero address.
614      *
615      * Requirements
616      *
617      * - `to` cannot be the zero address.
618      */
619     function _mint(address account, uint256 amount) internal virtual {
620         require(account != address(0), "ERC20: mint to the zero address");
621 
622         _beforeTokenTransfer(address(0), account, amount);
623 
624         _totalSupply = _totalSupply.add(amount);
625         _balances[account] = _balances[account].add(amount);
626         emit Transfer(address(0), account, amount);
627     }
628 
629     /**
630      * @dev Destroys `amount` tokens from `account`, reducing the
631      * total supply.
632      *
633      * Emits a {Transfer} event with `to` set to the zero address.
634      *
635      * Requirements
636      *
637      * - `account` cannot be the zero address.
638      * - `account` must have at least `amount` tokens.
639      */
640     function _burn(address account, uint256 amount) internal virtual {
641         require(account != address(0), "ERC20: burn from the zero address");
642 
643         _beforeTokenTransfer(account, address(0), amount);
644 
645         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
646         _totalSupply = _totalSupply.sub(amount);
647         emit Transfer(account, address(0), amount);
648     }
649 
650     /**
651      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
652      *
653      * This is internal function is equivalent to `approve`, and can be used to
654      * e.g. set automatic allowances for certain subsystems, etc.
655      *
656      * Emits an {Approval} event.
657      *
658      * Requirements:
659      *
660      * - `owner` cannot be the zero address.
661      * - `spender` cannot be the zero address.
662      */
663     function _approve(address owner, address spender, uint256 amount) internal virtual {
664         require(owner != address(0), "ERC20: approve from the zero address");
665         require(spender != address(0), "ERC20: approve to the zero address");
666 
667         _allowances[owner][spender] = amount;
668         emit Approval(owner, spender, amount);
669     }
670 
671     /**
672      * @dev Sets {decimals} to a value other than the default one of 18.
673      *
674      * WARNING: This function should only be called from the constructor. Most
675      * applications that interact with token contracts will not expect
676      * {decimals} to ever change, and may work incorrectly if it does.
677      */
678     function _setupDecimals(uint8 decimals_) internal {
679         _decimals = decimals_;
680     }
681 
682     /**
683      * @dev Hook that is called before any transfer of tokens. This includes
684      * minting and burning.
685      *
686      * Calling conditions:
687      *
688      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
689      * will be to transferred to `to`.
690      * - when `from` is zero, `amount` tokens will be minted for `to`.
691      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
692      * - `from` and `to` are never both zero.
693      *
694      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
695      */
696     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
697 }
698 
699 // 
700 /**
701  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
702  */
703 abstract contract ERC20Capped is ERC20 {
704     uint256 private _cap;
705 
706     /**
707      * @dev Sets the value of the `cap`. This value is immutable, it can only be
708      * set once during construction.
709      */
710     constructor (uint256 cap) public {
711         require(cap > 0, "ERC20Capped: cap is 0");
712         _cap = cap;
713     }
714 
715     /**
716      * @dev Returns the cap on the token's total supply.
717      */
718     function cap() public view returns (uint256) {
719         return _cap;
720     }
721 
722     /**
723      * @dev See {ERC20-_beforeTokenTransfer}.
724      *
725      * Requirements:
726      *
727      * - minted tokens must not cause the total supply to go over the cap.
728      */
729     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
730         super._beforeTokenTransfer(from, to, amount);
731 
732         if (from == address(0)) { // When minting tokens
733             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
734         }
735     }
736 }
737 
738 // 
739 /**
740  * @dev ACoconut token.
741  * Credits:
742  * https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
743  * https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
744  */
745 contract ACoconut is ERC20Capped {
746     event MinterUpdated(address indexed account, bool allowed);
747     
748     address public governance;
749     mapping(address => bool) public minters;
750 
751     /// @notice A record of each accounts delegate
752     mapping (address => address) internal _delegates;
753 
754     /// @notice A checkpoint for marking number of votes from a given block
755     struct Checkpoint {
756         uint32 fromBlock;
757         uint256 votes;
758     }
759 
760     /// @notice A record of votes checkpoints for each account, by index
761     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
762 
763     /// @notice The number of checkpoints for each account
764     mapping (address => uint32) public numCheckpoints;
765 
766     /// @notice The EIP-712 typehash for the contract's domain
767     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
768 
769     /// @notice The EIP-712 typehash for the delegation struct used by the contract
770     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
771 
772     /// @notice A record of states for signing / validating signatures
773     mapping (address => uint256) public nonces;
774 
775       /// @notice An event thats emitted when an account changes its delegate
776     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
777 
778     /// @notice An event thats emitted when a delegate account's vote balance changes
779     event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);
780 
781     constructor() public ERC20("ACoconut", "AC") ERC20Capped(21000000 * 10 ** 18) {
782         governance = msg.sender;
783     }
784 
785     /**
786      * @dev Updates the govenance address.
787      */
788     function setGovernance(address _governance) public {
789         require(msg.sender == governance, "not governance");
790         governance = _governance;
791     }
792 
793     /**
794      * @dev Sets minter for AC token. Only minter can mint AC tokens.
795      * @param _user Address of the minter.
796      * @param _allowed Whether the user is accepted as a minter or not.
797      */
798     function setMinter(address _user, bool _allowed) public {
799         require(msg.sender == governance, "not governance");
800         minters[_user] = _allowed;
801 
802         emit MinterUpdated(_user, _allowed);
803     }
804 
805     /**
806      * @dev Mints new AC tokens.
807      * @param _user Recipient of the minted AC token.
808      * @param _amount Amount of AC token to mint.
809      */
810     function mint(address _user, uint256 _amount) public {
811         require(minters[msg.sender], "not minter");
812         _mint(_user, _amount);
813         _moveDelegates(address(0), _delegates[_user], _amount);
814     }
815 
816     /**
817      * @dev Burns AC token from the caller's account.
818      * @param _amount Amount of AC token to burn.
819      */
820     function burn(uint256 _amount) public {
821         _burn(msg.sender, _amount);
822         _moveDelegates(_delegates[msg.sender], address(0), _amount);
823     }
824 
825     /**
826      * @dev Transfers AC token to another address.
827      * @param _recipient Receiver address for the AC token.
828      * @param _amount Amount of token to transfer.
829      */
830     function transfer(address _recipient, uint256 _amount) public override returns (bool) {
831         super.transfer(_recipient, _amount);
832         _moveDelegates(_delegates[msg.sender], _delegates[_recipient], _amount);
833         return true;
834     }
835 
836     /**
837      * @dev Transfers AC token from one account to another address. Caller must have sufficient allowance from the sender account.
838      * @param _sender Sender address for the AC token.
839      * @param _recipient Receiver address for the AC token.
840      * @param _amount Amount of token to transfer.
841      */
842     function transferFrom(address _sender, address _recipient, uint256 _amount) public override returns (bool) {
843         super.transferFrom(_sender, _recipient, _amount);
844         _moveDelegates(_delegates[_sender], _delegates[_recipient], _amount);
845         return true;
846     }
847 
848     /**
849      * @notice Delegate votes from `msg.sender` to `delegatee`
850      * @param delegator The address to get delegatee for
851      */
852     function delegates(address delegator)
853         external
854         view
855         returns (address)
856     {
857         return _delegates[delegator];
858     }
859 
860    /**
861     * @notice Delegate votes from `msg.sender` to `delegatee`
862     * @param delegatee The address to delegate votes to
863     */
864     function delegate(address delegatee) external {
865         return _delegate(msg.sender, delegatee);
866     }
867 
868     /**
869      * @notice Delegates votes from signatory to `delegatee`
870      * @param delegatee The address to delegate votes to
871      * @param nonce The contract state required to match the signature
872      * @param expiry The time at which to expire the signature
873      * @param v The recovery byte of the signature
874      * @param r Half of the ECDSA signature pair
875      * @param s Half of the ECDSA signature pair
876      */
877     function delegateBySig(
878         address delegatee,
879         uint nonce,
880         uint expiry,
881         uint8 v,
882         bytes32 r,
883         bytes32 s
884     )
885         external
886     {
887         bytes32 domainSeparator = keccak256(
888             abi.encode(
889                 DOMAIN_TYPEHASH,
890                 keccak256(bytes(name())),
891                 getChainId(),
892                 address(this)
893             )
894         );
895 
896         bytes32 structHash = keccak256(
897             abi.encode(
898                 DELEGATION_TYPEHASH,
899                 delegatee,
900                 nonce,
901                 expiry
902             )
903         );
904 
905         bytes32 digest = keccak256(
906             abi.encodePacked(
907                 "\x19\x01",
908                 domainSeparator,
909                 structHash
910             )
911         );
912 
913         address signatory = ecrecover(digest, v, r, s);
914         require(signatory != address(0), "delegateBySig: invalid signature");
915         require(nonce == nonces[signatory]++, "delegateBySig: invalid nonce");
916         require(now <= expiry, "delegateBySig: signature expired");
917         return _delegate(signatory, delegatee);
918     }
919 
920     /**
921      * @notice Gets the current votes balance for `account`
922      * @param account The address to get votes balance
923      * @return The number of current votes for `account`
924      */
925     function getCurrentVotes(address account)
926         external
927         view
928         returns (uint256)
929     {
930         uint32 nCheckpoints = numCheckpoints[account];
931         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
932     }
933 
934     /**
935      * @notice Determine the prior number of votes for an account as of a block number
936      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
937      * @param account The address of the account to check
938      * @param blockNumber The block number to get the vote balance at
939      * @return The number of votes the account had as of the given block
940      */
941     function getPriorVotes(address account, uint blockNumber)
942         external
943         view
944         returns (uint256)
945     {
946         require(blockNumber < block.number, "getPriorVotes: not yet determined");
947 
948         uint32 nCheckpoints = numCheckpoints[account];
949         if (nCheckpoints == 0) {
950             return 0;
951         }
952 
953         // First check most recent balance
954         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
955             return checkpoints[account][nCheckpoints - 1].votes;
956         }
957 
958         // Next check implicit zero balance
959         if (checkpoints[account][0].fromBlock > blockNumber) {
960             return 0;
961         }
962 
963         uint32 lower = 0;
964         uint32 upper = nCheckpoints - 1;
965         while (upper > lower) {
966             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
967             Checkpoint memory cp = checkpoints[account][center];
968             if (cp.fromBlock == blockNumber) {
969                 return cp.votes;
970             } else if (cp.fromBlock < blockNumber) {
971                 lower = center;
972             } else {
973                 upper = center - 1;
974             }
975         }
976         return checkpoints[account][lower].votes;
977     }
978 
979     function _delegate(address delegator, address delegatee)
980         internal
981     {
982         address currentDelegate = _delegates[delegator];
983         uint256 delegatorBalance = balanceOf(delegator);
984         _delegates[delegator] = delegatee;
985 
986         emit DelegateChanged(delegator, currentDelegate, delegatee);
987 
988         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
989     }
990 
991     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
992         if (srcRep != dstRep && amount > 0) {
993             if (srcRep != address(0)) {
994                 // decrease old representative
995                 uint32 srcRepNum = numCheckpoints[srcRep];
996                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
997                 uint256 srcRepNew = srcRepOld.sub(amount);
998                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
999             }
1000 
1001             if (dstRep != address(0)) {
1002                 // increase new representative
1003                 uint32 dstRepNum = numCheckpoints[dstRep];
1004                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1005                 uint256 dstRepNew = dstRepOld.add(amount);
1006                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1007             }
1008         }
1009     }
1010 
1011     function _writeCheckpoint(
1012         address delegatee,
1013         uint32 nCheckpoints,
1014         uint256 oldVotes,
1015         uint256 newVotes
1016     )
1017         internal
1018     {
1019         uint32 blockNumber = safe32(block.number, "_writeCheckpoint: block number exceeds 32 bits");
1020 
1021         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1022             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1023         } else {
1024             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1025             numCheckpoints[delegatee] = nCheckpoints + 1;
1026         }
1027 
1028         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1029     }
1030 
1031     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1032         require(n < 2**32, errorMessage);
1033         return uint32(n);
1034     }
1035 
1036     function getChainId() internal pure returns (uint256) {
1037         uint256 chainId;
1038         assembly { chainId := chainid() }
1039         return chainId;
1040     }
1041 }