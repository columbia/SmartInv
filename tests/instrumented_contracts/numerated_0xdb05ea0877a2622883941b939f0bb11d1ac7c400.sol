1 pragma solidity ^0.7.0;
2 
3 
4 // SPDX-License-Identifier: MIT
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 
27 /**
28  * @dev Interface of the ERC20 standard as defined in the EIP.
29  */
30 interface IERC20 {
31     /**
32      * @dev Returns the amount of tokens in existence.
33      */
34     function totalSupply() external view returns (uint256);
35 
36     /**
37      * @dev Returns the amount of tokens owned by `account`.
38      */
39     function balanceOf(address account) external view returns (uint256);
40 
41     /**
42      * @dev Moves `amount` tokens from the caller's account to `recipient`.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * Emits a {Transfer} event.
47      */
48     function transfer(address recipient, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Returns the remaining number of tokens that `spender` will be
52      * allowed to spend on behalf of `owner` through {transferFrom}. This is
53      * zero by default.
54      *
55      * This value changes when {approve} or {transferFrom} are called.
56      */
57     function allowance(address owner, address spender) external view returns (uint256);
58 
59     /**
60      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * IMPORTANT: Beware that changing an allowance with this method brings the risk
65      * that someone may use both the old and the new allowance by unfortunate
66      * transaction ordering. One possible solution to mitigate this race
67      * condition is to first reduce the spender's allowance to 0 and set the
68      * desired value afterwards:
69      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
70      *
71      * Emits an {Approval} event.
72      */
73     function approve(address spender, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Moves `amount` tokens from `sender` to `recipient` using the
77      * allowance mechanism. `amount` is then deducted from the caller's
78      * allowance.
79      *
80      * Returns a boolean value indicating whether the operation succeeded.
81      *
82      * Emits a {Transfer} event.
83      */
84     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
85 
86     /**
87      * @dev Emitted when `value` tokens are moved from one account (`from`) to
88      * another (`to`).
89      *
90      * Note that `value` may be zero.
91      */
92     event Transfer(address indexed from, address indexed to, uint256 value);
93 
94     /**
95      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
96      * a call to {approve}. `value` is the new allowance.
97      */
98     event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 
102 /**
103  * @dev Wrappers over Solidity's arithmetic operations with added overflow
104  * checks.
105  *
106  * Arithmetic operations in Solidity wrap on overflow. This can easily result
107  * in bugs, because programmers usually assume that an overflow raises an
108  * error, which is the standard behavior in high level programming languages.
109  * `SafeMath` restores this intuition by reverting the transaction when an
110  * operation overflows.
111  *
112  * Using this library instead of the unchecked operations eliminates an entire
113  * class of bugs, so it's recommended to use it always.
114  */
115 library SafeMath {
116     /**
117      * @dev Returns the addition of two unsigned integers, reverting on
118      * overflow.
119      *
120      * Counterpart to Solidity's `+` operator.
121      *
122      * Requirements:
123      *
124      * - Addition cannot overflow.
125      */
126     function add(uint256 a, uint256 b) internal pure returns (uint256) {
127         uint256 c = a + b;
128         require(c >= a, "SafeMath: addition overflow");
129 
130         return c;
131     }
132 
133     /**
134      * @dev Returns the subtraction of two unsigned integers, reverting on
135      * overflow (when the result is negative).
136      *
137      * Counterpart to Solidity's `-` operator.
138      *
139      * Requirements:
140      *
141      * - Subtraction cannot overflow.
142      */
143     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
144         return sub(a, b, "SafeMath: subtraction overflow");
145     }
146 
147     /**
148      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
149      * overflow (when the result is negative).
150      *
151      * Counterpart to Solidity's `-` operator.
152      *
153      * Requirements:
154      *
155      * - Subtraction cannot overflow.
156      */
157     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b <= a, errorMessage);
159         uint256 c = a - b;
160 
161         return c;
162     }
163 
164     /**
165      * @dev Returns the multiplication of two unsigned integers, reverting on
166      * overflow.
167      *
168      * Counterpart to Solidity's `*` operator.
169      *
170      * Requirements:
171      *
172      * - Multiplication cannot overflow.
173      */
174     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
175         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
176         // benefit is lost if 'b' is also tested.
177         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
178         if (a == 0) {
179             return 0;
180         }
181 
182         uint256 c = a * b;
183         require(c / a == b, "SafeMath: multiplication overflow");
184 
185         return c;
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      *
198      * - The divisor cannot be zero.
199      */
200     function div(uint256 a, uint256 b) internal pure returns (uint256) {
201         return div(a, b, "SafeMath: division by zero");
202     }
203 
204     /**
205      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
206      * division by zero. The result is rounded towards zero.
207      *
208      * Counterpart to Solidity's `/` operator. Note: this function uses a
209      * `revert` opcode (which leaves remaining gas untouched) while Solidity
210      * uses an invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
217         require(b > 0, errorMessage);
218         uint256 c = a / b;
219         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
220 
221         return c;
222     }
223 
224     /**
225      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
226      * Reverts when dividing by zero.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
237         return mod(a, b, "SafeMath: modulo by zero");
238     }
239 
240     /**
241      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
242      * Reverts with custom message when dividing by zero.
243      *
244      * Counterpart to Solidity's `%` operator. This function uses a `revert`
245      * opcode (which leaves remaining gas untouched) while Solidity uses an
246      * invalid opcode to revert (consuming all remaining gas).
247      *
248      * Requirements:
249      *
250      * - The divisor cannot be zero.
251      */
252     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
253         require(b != 0, errorMessage);
254         return a % b;
255     }
256 }
257 
258 
259 /**
260  * @dev Collection of functions related to the address type
261  */
262 library Address {
263     /**
264      * @dev Returns true if `account` is a contract.
265      *
266      * [IMPORTANT]
267      * ====
268      * It is unsafe to assume that an address for which this function returns
269      * false is an externally-owned account (EOA) and not a contract.
270      *
271      * Among others, `isContract` will return false for the following
272      * types of addresses:
273      *
274      *  - an externally-owned account
275      *  - a contract in construction
276      *  - an address where a contract will be created
277      *  - an address where a contract lived, but was destroyed
278      * ====
279      */
280     function isContract(address account) internal view returns (bool) {
281         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
282         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
283         // for accounts without code, i.e. `keccak256('')`
284         bytes32 codehash;
285         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
286         // solhint-disable-next-line no-inline-assembly
287         assembly { codehash := extcodehash(account) }
288         return (codehash != accountHash && codehash != 0x0);
289     }
290 
291     /**
292      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
293      * `recipient`, forwarding all available gas and reverting on errors.
294      *
295      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
296      * of certain opcodes, possibly making contracts go over the 2300 gas limit
297      * imposed by `transfer`, making them unable to receive funds via
298      * `transfer`. {sendValue} removes this limitation.
299      *
300      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
301      *
302      * IMPORTANT: because control is transferred to `recipient`, care must be
303      * taken to not create reentrancy vulnerabilities. Consider using
304      * {ReentrancyGuard} or the
305      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
306      */
307     function sendValue(address payable recipient, uint256 amount) internal {
308         require(address(this).balance >= amount, "Address: insufficient balance");
309 
310         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
311         (bool success, ) = recipient.call{ value: amount }("");
312         require(success, "Address: unable to send value, recipient may have reverted");
313     }
314 
315     /**
316      * @dev Performs a Solidity function call using a low level `call`. A
317      * plain`call` is an unsafe replacement for a function call: use this
318      * function instead.
319      *
320      * If `target` reverts with a revert reason, it is bubbled up by this
321      * function (like regular Solidity function calls).
322      *
323      * Returns the raw returned data. To convert to the expected return value,
324      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
325      *
326      * Requirements:
327      *
328      * - `target` must be a contract.
329      * - calling `target` with `data` must not revert.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
334       return functionCall(target, data, "Address: low-level call failed");
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
339      * `errorMessage` as a fallback revert reason when `target` reverts.
340      *
341      * _Available since v3.1._
342      */
343     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
344         return _functionCallWithValue(target, data, 0, errorMessage);
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
349      * but also transferring `value` wei to `target`.
350      *
351      * Requirements:
352      *
353      * - the calling contract must have an ETH balance of at least `value`.
354      * - the called Solidity function must be `payable`.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
359         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
364      * with `errorMessage` as a fallback revert reason when `target` reverts.
365      *
366      * _Available since v3.1._
367      */
368     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
369         require(address(this).balance >= value, "Address: insufficient balance for call");
370         return _functionCallWithValue(target, data, value, errorMessage);
371     }
372 
373     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
374         require(isContract(target), "Address: call to non-contract");
375 
376         // solhint-disable-next-line avoid-low-level-calls
377         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
378         if (success) {
379             return returndata;
380         } else {
381             // Look for revert reason and bubble it up if present
382             if (returndata.length > 0) {
383                 // The easiest way to bubble the revert reason is using memory via assembly
384 
385                 // solhint-disable-next-line no-inline-assembly
386                 assembly {
387                     let returndata_size := mload(returndata)
388                     revert(add(32, returndata), returndata_size)
389                 }
390             } else {
391                 revert(errorMessage);
392             }
393         }
394     }
395 }
396 
397 
398 /**
399  * @dev Implementation of the {IERC20} interface.
400  *
401  * This implementation is agnostic to the way tokens are created. This means
402  * that a supply mechanism has to be added in a derived contract using {_mint}.
403  * For a generic mechanism see {ERC20PresetMinterPauser}.
404  *
405  * TIP: For a detailed writeup see our guide
406  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
407  * to implement supply mechanisms].
408  *
409  * We have followed general OpenZeppelin guidelines: functions revert instead
410  * of returning `false` on failure. This behavior is nonetheless conventional
411  * and does not conflict with the expectations of ERC20 applications.
412  *
413  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
414  * This allows applications to reconstruct the allowance for all accounts just
415  * by listening to said events. Other implementations of the EIP may not emit
416  * these events, as it isn't required by the specification.
417  *
418  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
419  * functions have been added to mitigate the well-known issues around setting
420  * allowances. See {IERC20-approve}.
421  */
422 contract ERC20 is Context, IERC20 {
423     using SafeMath for uint256;
424     using Address for address;
425 
426     mapping (address => uint256) private _balances;
427 
428     mapping (address => mapping (address => uint256)) private _allowances;
429 
430     uint256 private _totalSupply;
431 
432     string private _name;
433     string private _symbol;
434     uint8 private _decimals;
435 
436     /**
437      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
438      * a default value of 18.
439      *
440      * To select a different value for {decimals}, use {_setupDecimals}.
441      *
442      * All three of these values are immutable: they can only be set once during
443      * construction.
444      */
445     constructor (string memory name, string memory symbol) {
446         _name = name;
447         _symbol = symbol;
448         _decimals = 18;
449     }
450 
451     /**
452      * @dev Returns the name of the token.
453      */
454     function name() public view returns (string memory) {
455         return _name;
456     }
457 
458     /**
459      * @dev Returns the symbol of the token, usually a shorter version of the
460      * name.
461      */
462     function symbol() public view returns (string memory) {
463         return _symbol;
464     }
465 
466     /**
467      * @dev Returns the number of decimals used to get its user representation.
468      * For example, if `decimals` equals `2`, a balance of `505` tokens should
469      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
470      *
471      * Tokens usually opt for a value of 18, imitating the relationship between
472      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
473      * called.
474      *
475      * NOTE: This information is only used for _display_ purposes: it in
476      * no way affects any of the arithmetic of the contract, including
477      * {IERC20-balanceOf} and {IERC20-transfer}.
478      */
479     function decimals() public view returns (uint8) {
480         return _decimals;
481     }
482 
483     /**
484      * @dev See {IERC20-totalSupply}.
485      */
486     function totalSupply() public view override returns (uint256) {
487         return _totalSupply;
488     }
489 
490     /**
491      * @dev See {IERC20-balanceOf}.
492      */
493     function balanceOf(address account) public view override returns (uint256) {
494         return _balances[account];
495     }
496 
497     /**
498      * @dev See {IERC20-transfer}.
499      *
500      * Requirements:
501      *
502      * - `recipient` cannot be the zero address.
503      * - the caller must have a balance of at least `amount`.
504      */
505     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
506         _transfer(_msgSender(), recipient, amount);
507         return true;
508     }
509 
510     /**
511      * @dev See {IERC20-allowance}.
512      */
513     function allowance(address owner, address spender) public view virtual override returns (uint256) {
514         return _allowances[owner][spender];
515     }
516 
517     /**
518      * @dev See {IERC20-approve}.
519      *
520      * Requirements:
521      *
522      * - `spender` cannot be the zero address.
523      */
524     function approve(address spender, uint256 amount) public virtual override returns (bool) {
525         _approve(_msgSender(), spender, amount);
526         return true;
527     }
528 
529     /**
530      * @dev See {IERC20-transferFrom}.
531      *
532      * Emits an {Approval} event indicating the updated allowance. This is not
533      * required by the EIP. See the note at the beginning of {ERC20};
534      *
535      * Requirements:
536      * - `sender` and `recipient` cannot be the zero address.
537      * - `sender` must have a balance of at least `amount`.
538      * - the caller must have allowance for ``sender``'s tokens of at least
539      * `amount`.
540      */
541     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
542         _transfer(sender, recipient, amount);
543         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
544         return true;
545     }
546 
547     /**
548      * @dev Atomically increases the allowance granted to `spender` by the caller.
549      *
550      * This is an alternative to {approve} that can be used as a mitigation for
551      * problems described in {IERC20-approve}.
552      *
553      * Emits an {Approval} event indicating the updated allowance.
554      *
555      * Requirements:
556      *
557      * - `spender` cannot be the zero address.
558      */
559     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
560         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
561         return true;
562     }
563 
564     /**
565      * @dev Atomically decreases the allowance granted to `spender` by the caller.
566      *
567      * This is an alternative to {approve} that can be used as a mitigation for
568      * problems described in {IERC20-approve}.
569      *
570      * Emits an {Approval} event indicating the updated allowance.
571      *
572      * Requirements:
573      *
574      * - `spender` cannot be the zero address.
575      * - `spender` must have allowance for the caller of at least
576      * `subtractedValue`.
577      */
578     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
579         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
580         return true;
581     }
582 
583     /**
584      * @dev Moves tokens `amount` from `sender` to `recipient`.
585      *
586      * This is internal function is equivalent to {transfer}, and can be used to
587      * e.g. implement automatic token fees, slashing mechanisms, etc.
588      *
589      * Emits a {Transfer} event.
590      *
591      * Requirements:
592      *
593      * - `sender` cannot be the zero address.
594      * - `recipient` cannot be the zero address.
595      * - `sender` must have a balance of at least `amount`.
596      */
597     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
598         require(sender != address(0), "ERC20: transfer from the zero address");
599         require(recipient != address(0), "ERC20: transfer to the zero address");
600 
601         _beforeTokenTransfer(sender, recipient, amount);
602 
603         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
604         _balances[recipient] = _balances[recipient].add(amount);
605         emit Transfer(sender, recipient, amount);
606     }
607 
608     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
609      * the total supply.
610      *
611      * Emits a {Transfer} event with `from` set to the zero address.
612      *
613      * Requirements
614      *
615      * - `to` cannot be the zero address.
616      */
617     function _mint(address account, uint256 amount) internal virtual {
618         require(account != address(0), "ERC20: mint to the zero address");
619 
620         _beforeTokenTransfer(address(0), account, amount);
621 
622         _totalSupply = _totalSupply.add(amount);
623         _balances[account] = _balances[account].add(amount);
624         emit Transfer(address(0), account, amount);
625     }
626 
627     /**
628      * @dev Destroys `amount` tokens from `account`, reducing the
629      * total supply.
630      *
631      * Emits a {Transfer} event with `to` set to the zero address.
632      *
633      * Requirements
634      *
635      * - `account` cannot be the zero address.
636      * - `account` must have at least `amount` tokens.
637      */
638     function _burn(address account, uint256 amount) internal virtual {
639         require(account != address(0), "ERC20: burn from the zero address");
640 
641         _beforeTokenTransfer(account, address(0), amount);
642 
643         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
644         _totalSupply = _totalSupply.sub(amount);
645         emit Transfer(account, address(0), amount);
646     }
647 
648     /**
649      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
650      *
651      * This is internal function is equivalent to `approve`, and can be used to
652      * e.g. set automatic allowances for certain subsystems, etc.
653      *
654      * Emits an {Approval} event.
655      *
656      * Requirements:
657      *
658      * - `owner` cannot be the zero address.
659      * - `spender` cannot be the zero address.
660      */
661     function _approve(address owner, address spender, uint256 amount) internal virtual {
662         require(owner != address(0), "ERC20: approve from the zero address");
663         require(spender != address(0), "ERC20: approve to the zero address");
664 
665         _allowances[owner][spender] = amount;
666         emit Approval(owner, spender, amount);
667     }
668 
669     /**
670      * @dev Sets {decimals} to a value other than the default one of 18.
671      *
672      * WARNING: This function should only be called from the constructor. Most
673      * applications that interact with token contracts will not expect
674      * {decimals} to ever change, and may work incorrectly if it does.
675      */
676     function _setupDecimals(uint8 decimals_) internal {
677         _decimals = decimals_;
678     }
679 
680     /**
681      * @dev Hook that is called before any transfer of tokens. This includes
682      * minting and burning.
683      *
684      * Calling conditions:
685      *
686      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
687      * will be to transferred to `to`.
688      * - when `from` is zero, `amount` tokens will be minted for `to`.
689      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
690      * - `from` and `to` are never both zero.
691      *
692      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
693      */
694     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
695 }
696 
697 
698 /**
699  * @dev Extension of {ERC20} that allows token holders to destroy both their own
700  * tokens and those that they have an allowance for, in a way that can be
701  * recognized off-chain (via event analysis).
702  */
703 abstract contract ERC20Burnable is Context, ERC20 {
704     using SafeMath for uint256;
705 
706     /**
707      * @dev Destroys `amount` tokens from the caller.
708      *
709      * See {ERC20-_burn}.
710      */
711     function burn(uint256 amount) public virtual {
712         _burn(_msgSender(), amount);
713     }
714 
715     /**
716      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
717      * allowance.
718      *
719      * See {ERC20-_burn} and {ERC20-allowance}.
720      *
721      * Requirements:
722      *
723      * - the caller must have allowance for ``accounts``'s tokens of at least
724      * `amount`.
725      */
726     function burnFrom(address account, uint256 amount) public virtual {
727         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
728 
729         _approve(account, _msgSender(), decreasedAllowance);
730         _burn(account, amount);
731     }
732 }
733 
734 
735 /**
736  * @dev Library for managing
737  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
738  * types.
739  *
740  * Sets have the following properties:
741  *
742  * - Elements are added, removed, and checked for existence in constant time
743  * (O(1)).
744  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
745  *
746  * ```
747  * contract Example {
748  *     // Add the library methods
749  *     using EnumerableSet for EnumerableSet.AddressSet;
750  *
751  *     // Declare a set state variable
752  *     EnumerableSet.AddressSet private mySet;
753  * }
754  * ```
755  *
756  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
757  * (`UintSet`) are supported.
758  */
759 library EnumerableSet {
760     // To implement this library for multiple types with as little code
761     // repetition as possible, we write it in terms of a generic Set type with
762     // bytes32 values.
763     // The Set implementation uses private functions, and user-facing
764     // implementations (such as AddressSet) are just wrappers around the
765     // underlying Set.
766     // This means that we can only create new EnumerableSets for types that fit
767     // in bytes32.
768 
769     struct Set {
770         // Storage of set values
771         bytes32[] _values;
772 
773         // Position of the value in the `values` array, plus 1 because index 0
774         // means a value is not in the set.
775         mapping (bytes32 => uint256) _indexes;
776     }
777 
778     /**
779      * @dev Add a value to a set. O(1).
780      *
781      * Returns true if the value was added to the set, that is if it was not
782      * already present.
783      */
784     function _add(Set storage set, bytes32 value) private returns (bool) {
785         if (!_contains(set, value)) {
786             set._values.push(value);
787             // The value is stored at length-1, but we add 1 to all indexes
788             // and use 0 as a sentinel value
789             set._indexes[value] = set._values.length;
790             return true;
791         } else {
792             return false;
793         }
794     }
795 
796     /**
797      * @dev Removes a value from a set. O(1).
798      *
799      * Returns true if the value was removed from the set, that is if it was
800      * present.
801      */
802     function _remove(Set storage set, bytes32 value) private returns (bool) {
803         // We read and store the value's index to prevent multiple reads from the same storage slot
804         uint256 valueIndex = set._indexes[value];
805 
806         if (valueIndex != 0) { // Equivalent to contains(set, value)
807             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
808             // the array, and then remove the last element (sometimes called as 'swap and pop').
809             // This modifies the order of the array, as noted in {at}.
810 
811             uint256 toDeleteIndex = valueIndex - 1;
812             uint256 lastIndex = set._values.length - 1;
813 
814             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
815             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
816 
817             bytes32 lastvalue = set._values[lastIndex];
818 
819             // Move the last value to the index where the value to delete is
820             set._values[toDeleteIndex] = lastvalue;
821             // Update the index for the moved value
822             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
823 
824             // Delete the slot where the moved value was stored
825             set._values.pop();
826 
827             // Delete the index for the deleted slot
828             delete set._indexes[value];
829 
830             return true;
831         } else {
832             return false;
833         }
834     }
835 
836     /**
837      * @dev Returns true if the value is in the set. O(1).
838      */
839     function _contains(Set storage set, bytes32 value) private view returns (bool) {
840         return set._indexes[value] != 0;
841     }
842 
843     /**
844      * @dev Returns the number of values on the set. O(1).
845      */
846     function _length(Set storage set) private view returns (uint256) {
847         return set._values.length;
848     }
849 
850    /**
851     * @dev Returns the value stored at position `index` in the set. O(1).
852     *
853     * Note that there are no guarantees on the ordering of values inside the
854     * array, and it may change when more values are added or removed.
855     *
856     * Requirements:
857     *
858     * - `index` must be strictly less than {length}.
859     */
860     function _at(Set storage set, uint256 index) private view returns (bytes32) {
861         require(set._values.length > index, "EnumerableSet: index out of bounds");
862         return set._values[index];
863     }
864 
865     // AddressSet
866 
867     struct AddressSet {
868         Set _inner;
869     }
870 
871     /**
872      * @dev Add a value to a set. O(1).
873      *
874      * Returns true if the value was added to the set, that is if it was not
875      * already present.
876      */
877     function add(AddressSet storage set, address value) internal returns (bool) {
878         return _add(set._inner, bytes32(uint256(value)));
879     }
880 
881     /**
882      * @dev Removes a value from a set. O(1).
883      *
884      * Returns true if the value was removed from the set, that is if it was
885      * present.
886      */
887     function remove(AddressSet storage set, address value) internal returns (bool) {
888         return _remove(set._inner, bytes32(uint256(value)));
889     }
890 
891     /**
892      * @dev Returns true if the value is in the set. O(1).
893      */
894     function contains(AddressSet storage set, address value) internal view returns (bool) {
895         return _contains(set._inner, bytes32(uint256(value)));
896     }
897 
898     /**
899      * @dev Returns the number of values in the set. O(1).
900      */
901     function length(AddressSet storage set) internal view returns (uint256) {
902         return _length(set._inner);
903     }
904 
905    /**
906     * @dev Returns the value stored at position `index` in the set. O(1).
907     *
908     * Note that there are no guarantees on the ordering of values inside the
909     * array, and it may change when more values are added or removed.
910     *
911     * Requirements:
912     *
913     * - `index` must be strictly less than {length}.
914     */
915     function at(AddressSet storage set, uint256 index) internal view returns (address) {
916         return address(uint256(_at(set._inner, index)));
917     }
918 
919 
920     // UintSet
921 
922     struct UintSet {
923         Set _inner;
924     }
925 
926     /**
927      * @dev Add a value to a set. O(1).
928      *
929      * Returns true if the value was added to the set, that is if it was not
930      * already present.
931      */
932     function add(UintSet storage set, uint256 value) internal returns (bool) {
933         return _add(set._inner, bytes32(value));
934     }
935 
936     /**
937      * @dev Removes a value from a set. O(1).
938      *
939      * Returns true if the value was removed from the set, that is if it was
940      * present.
941      */
942     function remove(UintSet storage set, uint256 value) internal returns (bool) {
943         return _remove(set._inner, bytes32(value));
944     }
945 
946     /**
947      * @dev Returns true if the value is in the set. O(1).
948      */
949     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
950         return _contains(set._inner, bytes32(value));
951     }
952 
953     /**
954      * @dev Returns the number of values on the set. O(1).
955      */
956     function length(UintSet storage set) internal view returns (uint256) {
957         return _length(set._inner);
958     }
959 
960    /**
961     * @dev Returns the value stored at position `index` in the set. O(1).
962     *
963     * Note that there are no guarantees on the ordering of values inside the
964     * array, and it may change when more values are added or removed.
965     *
966     * Requirements:
967     *
968     * - `index` must be strictly less than {length}.
969     */
970     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
971         return uint256(_at(set._inner, index));
972     }
973 }
974 
975 
976 /**
977  * @dev Contract module that allows children to implement role-based access
978  * control mechanisms.
979  *
980  * Roles are referred to by their `bytes32` identifier. These should be exposed
981  * in the external API and be unique. The best way to achieve this is by
982  * using `public constant` hash digests:
983  *
984  * ```
985  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
986  * ```
987  *
988  * Roles can be used to represent a set of permissions. To restrict access to a
989  * function call, use {hasRole}:
990  *
991  * ```
992  * function foo() public {
993  *     require(hasRole(MY_ROLE, msg.sender));
994  *     ...
995  * }
996  * ```
997  *
998  * Roles can be granted and revoked dynamically via the {grantRole} and
999  * {revokeRole} functions. Each role has an associated admin role, and only
1000  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1001  *
1002  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1003  * that only accounts with this role will be able to grant or revoke other
1004  * roles. More complex role relationships can be created by using
1005  * {_setRoleAdmin}.
1006  *
1007  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1008  * grant and revoke this role. Extra precautions should be taken to secure
1009  * accounts that have been granted it.
1010  */
1011 abstract contract AccessControl is Context {
1012     using EnumerableSet for EnumerableSet.AddressSet;
1013     using Address for address;
1014 
1015     struct RoleData {
1016         EnumerableSet.AddressSet members;
1017         bytes32 adminRole;
1018     }
1019 
1020     mapping (bytes32 => RoleData) private _roles;
1021 
1022     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1023 
1024     /**
1025      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1026      *
1027      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1028      * {RoleAdminChanged} not being emitted signaling this.
1029      *
1030      * _Available since v3.1._
1031      */
1032     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1033 
1034     /**
1035      * @dev Emitted when `account` is granted `role`.
1036      *
1037      * `sender` is the account that originated the contract call, an admin role
1038      * bearer except when using {_setupRole}.
1039      */
1040     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1041 
1042     /**
1043      * @dev Emitted when `account` is revoked `role`.
1044      *
1045      * `sender` is the account that originated the contract call:
1046      *   - if using `revokeRole`, it is the admin role bearer
1047      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1048      */
1049     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1050 
1051     /**
1052      * @dev Returns `true` if `account` has been granted `role`.
1053      */
1054     function hasRole(bytes32 role, address account) public view returns (bool) {
1055         return _roles[role].members.contains(account);
1056     }
1057 
1058     /**
1059      * @dev Returns the number of accounts that have `role`. Can be used
1060      * together with {getRoleMember} to enumerate all bearers of a role.
1061      */
1062     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1063         return _roles[role].members.length();
1064     }
1065 
1066     /**
1067      * @dev Returns one of the accounts that have `role`. `index` must be a
1068      * value between 0 and {getRoleMemberCount}, non-inclusive.
1069      *
1070      * Role bearers are not sorted in any particular way, and their ordering may
1071      * change at any point.
1072      *
1073      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1074      * you perform all queries on the same block. See the following
1075      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1076      * for more information.
1077      */
1078     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1079         return _roles[role].members.at(index);
1080     }
1081 
1082     /**
1083      * @dev Returns the admin role that controls `role`. See {grantRole} and
1084      * {revokeRole}.
1085      *
1086      * To change a role's admin, use {_setRoleAdmin}.
1087      */
1088     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1089         return _roles[role].adminRole;
1090     }
1091 
1092     /**
1093      * @dev Grants `role` to `account`.
1094      *
1095      * If `account` had not been already granted `role`, emits a {RoleGranted}
1096      * event.
1097      *
1098      * Requirements:
1099      *
1100      * - the caller must have ``role``'s admin role.
1101      */
1102     function grantRole(bytes32 role, address account) public virtual {
1103         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1104 
1105         _grantRole(role, account);
1106     }
1107 
1108     /**
1109      * @dev Revokes `role` from `account`.
1110      *
1111      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1112      *
1113      * Requirements:
1114      *
1115      * - the caller must have ``role``'s admin role.
1116      */
1117     function revokeRole(bytes32 role, address account) public virtual {
1118         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1119 
1120         _revokeRole(role, account);
1121     }
1122 
1123     /**
1124      * @dev Revokes `role` from the calling account.
1125      *
1126      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1127      * purpose is to provide a mechanism for accounts to lose their privileges
1128      * if they are compromised (such as when a trusted device is misplaced).
1129      *
1130      * If the calling account had been granted `role`, emits a {RoleRevoked}
1131      * event.
1132      *
1133      * Requirements:
1134      *
1135      * - the caller must be `account`.
1136      */
1137     function renounceRole(bytes32 role, address account) public virtual {
1138         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1139 
1140         _revokeRole(role, account);
1141     }
1142 
1143     /**
1144      * @dev Grants `role` to `account`.
1145      *
1146      * If `account` had not been already granted `role`, emits a {RoleGranted}
1147      * event. Note that unlike {grantRole}, this function doesn't perform any
1148      * checks on the calling account.
1149      *
1150      * [WARNING]
1151      * ====
1152      * This function should only be called from the constructor when setting
1153      * up the initial roles for the system.
1154      *
1155      * Using this function in any other way is effectively circumventing the admin
1156      * system imposed by {AccessControl}.
1157      * ====
1158      */
1159     function _setupRole(bytes32 role, address account) internal virtual {
1160         _grantRole(role, account);
1161     }
1162 
1163     /**
1164      * @dev Sets `adminRole` as ``role``'s admin role.
1165      *
1166      * Emits a {RoleAdminChanged} event.
1167      */
1168     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1169         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1170         _roles[role].adminRole = adminRole;
1171     }
1172 
1173     function _grantRole(bytes32 role, address account) private {
1174         if (_roles[role].members.add(account)) {
1175             emit RoleGranted(role, account, _msgSender());
1176         }
1177     }
1178 
1179     function _revokeRole(bytes32 role, address account) private {
1180         if (_roles[role].members.remove(account)) {
1181             emit RoleRevoked(role, account, _msgSender());
1182         }
1183     }
1184 }
1185 
1186 
1187 /**
1188  * @dev Contract module which allows children to implement an emergency stop
1189  * mechanism that can be triggered by an authorized account.
1190  *
1191  * This module is used through inheritance. It will make available the
1192  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1193  * the functions of your contract. Note that they will not be pausable by
1194  * simply including this module, only once the modifiers are put in place.
1195  */
1196 contract Pausable is Context {
1197     /**
1198      * @dev Emitted when the pause is triggered by `account`.
1199      */
1200     event Paused(address account);
1201 
1202     /**
1203      * @dev Emitted when the pause is lifted by `account`.
1204      */
1205     event Unpaused(address account);
1206 
1207     bool private _paused;
1208 
1209     /**
1210      * @dev Initializes the contract in unpaused state.
1211      */
1212     constructor () {
1213         _paused = false;
1214     }
1215 
1216     /**
1217      * @dev Returns true if the contract is paused, and false otherwise.
1218      */
1219     function paused() public view returns (bool) {
1220         return _paused;
1221     }
1222 
1223     /**
1224      * @dev Modifier to make a function callable only when the contract is not paused.
1225      *
1226      * Requirements:
1227      *
1228      * - The contract must not be paused.
1229      */
1230     modifier whenNotPaused() {
1231         require(!_paused, "Pausable: paused");
1232         _;
1233     }
1234 
1235     /**
1236      * @dev Modifier to make a function callable only when the contract is paused.
1237      *
1238      * Requirements:
1239      *
1240      * - The contract must be paused.
1241      */
1242     modifier whenPaused() {
1243         require(_paused, "Pausable: not paused");
1244         _;
1245     }
1246 
1247     /**
1248      * @dev Triggers stopped state.
1249      *
1250      * Requirements:
1251      *
1252      * - The contract must not be paused.
1253      */
1254     function _pause() internal virtual whenNotPaused {
1255         _paused = true;
1256         emit Paused(_msgSender());
1257     }
1258 
1259     /**
1260      * @dev Returns to normal state.
1261      *
1262      * Requirements:
1263      *
1264      * - The contract must be paused.
1265      */
1266     function _unpause() internal virtual whenPaused {
1267         _paused = false;
1268         emit Unpaused(_msgSender());
1269     }
1270 }
1271 
1272 
1273 /**
1274  * @dev ERC20 token with pausable token transfers, minting and burning.
1275  *
1276  * Useful for scenarios such as preventing trades until the end of an evaluation
1277  * period, or having an emergency switch for freezing all token transfers in the
1278  * event of a large bug.
1279  */
1280 abstract contract ERC20Pausable is ERC20, Pausable {
1281     /**
1282      * @dev See {ERC20-_beforeTokenTransfer}.
1283      *
1284      * Requirements:
1285      *
1286      * - the contract must not be paused.
1287      */
1288     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1289         super._beforeTokenTransfer(from, to, amount);
1290 
1291         require(!paused(), "ERC20Pausable: token transfer while paused");
1292     }
1293 }
1294 
1295 
1296 /**
1297  * @dev {ERC20} token, including:
1298  *
1299  * - a pauser role that allows to stop all token transfers
1300  *
1301  * This contract uses {AccessControl} to lock permissioned functions using the
1302  * different roles - head to its documentation for details.
1303  *
1304  * The account that deploys the contract will be granted the pauser role, as
1305  * well as the default admin role, which will let it grant pauser roles to other
1306  * accounts
1307  */
1308 abstract contract ERC20PresetPauser is Context, AccessControl, ERC20Pausable {
1309 	bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1310 
1311 	/**
1312 	 * @dev Grants `DEFAULT_ADMIN_ROLE` and `PAUSER_ROLE` to the
1313 	 * account that deploys the contract.
1314 	 *
1315 	 * See {ERC20-constructor}.
1316 	 */
1317 	constructor(string memory name, string memory symbol) ERC20(name, symbol) {
1318 		_setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1319 
1320 		_setupRole(PAUSER_ROLE, _msgSender());
1321 	}
1322 
1323 	/**
1324 	 * @dev Pauses all token transfers.
1325 	 *
1326 	 * See {ERC20Pausable} and {Pausable-_pause}.
1327 	 *
1328 	 * Requirements:
1329 	 *
1330 	 * - the caller must have the `PAUSER_ROLE`.
1331 	 */
1332 	function pause() public {
1333 		require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20AccessControlPauser: must have pauser role to pause");
1334 		_pause();
1335 	}
1336 
1337 	/**
1338 	 * @dev Unpauses all token transfers.
1339 	 *
1340 	 * See {ERC20Pausable} and {Pausable-_unpause}.
1341 	 *
1342 	 * Requirements:
1343 	 *
1344 	 * - the caller must have the `PAUSER_ROLE`.
1345 	 */
1346 	function unpause() public {
1347 		require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20AccessControlPauser: must have pauser role to unpause");
1348 		_unpause();
1349 	}
1350 
1351 	function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20Pausable) {
1352 		super._beforeTokenTransfer(from, to, amount);
1353 	}
1354 }
1355 
1356 
1357 contract OPCT is ERC20, ERC20Burnable, ERC20PresetPauser {
1358 	constructor(uint256 initialSupply) ERC20PresetPauser("Opacity", "OPCT")
1359 	{
1360 		_mint(msg.sender, initialSupply);
1361 	}
1362 
1363 	/**
1364 	 * @dev Hook that is called before any transfer of tokens.
1365 	 */
1366 	function _beforeTokenTransfer(address from, address to, uint256 amount) internal override(ERC20, ERC20PresetPauser) {
1367 		super._beforeTokenTransfer(from, to, amount);
1368 	}
1369 }