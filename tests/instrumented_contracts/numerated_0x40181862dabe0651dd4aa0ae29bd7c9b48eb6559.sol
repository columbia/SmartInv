1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-24
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-09-09
7 */
8 
9 // File: @openzeppelin/contracts/GSN/Context.sol
10 
11 // SPDX-License-Identifier: MIT
12 
13 pragma solidity ^0.6.0;
14 
15 /*
16  * @dev Provides information about the current execution context, including the
17  * sender of the transaction and its data. While these are generally available
18  * via msg.sender and msg.data, they should not be accessed in such a direct
19  * manner, since when dealing with GSN meta-transactions the account sending and
20  * paying for execution may not be the actual sender (as far as an application
21  * is concerned).
22  *
23  * This contract is only required for intermediate, library-like contracts.
24  */
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address payable) {
27         return msg.sender;
28     }
29 
30     function _msgData() internal view virtual returns (bytes memory) {
31         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
32         return msg.data;
33     }
34 }
35 
36 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
37 
38 
39 pragma solidity ^0.6.0;
40 
41 /**
42  * @dev Interface of the ERC20 standard as defined in the EIP.
43  */
44 interface IERC20 {
45     /**
46      * @dev Returns the amount of tokens in existence.
47      */
48     function totalSupply() external view returns (uint256);
49 
50     /**
51      * @dev Returns the amount of tokens owned by `account`.
52      */
53     function balanceOf(address account) external view returns (uint256);
54 
55     /**
56      * @dev Moves `amount` tokens from the caller's account to `recipient`.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transfer(address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Returns the remaining number of tokens that `spender` will be
66      * allowed to spend on behalf of `owner` through {transferFrom}. This is
67      * zero by default.
68      *
69      * This value changes when {approve} or {transferFrom} are called.
70      */
71     function allowance(address owner, address spender) external view returns (uint256);
72 
73     /**
74      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * IMPORTANT: Beware that changing an allowance with this method brings the risk
79      * that someone may use both the old and the new allowance by unfortunate
80      * transaction ordering. One possible solution to mitigate this race
81      * condition is to first reduce the spender's allowance to 0 and set the
82      * desired value afterwards:
83      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
84      *
85      * Emits an {Approval} event.
86      */
87     function approve(address spender, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Moves `amount` tokens from `sender` to `recipient` using the
91      * allowance mechanism. `amount` is then deducted from the caller's
92      * allowance.
93      *
94      * Returns a boolean value indicating whether the operation succeeded.
95      *
96      * Emits a {Transfer} event.
97      */
98     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
99 
100     /**
101      * @dev Emitted when `value` tokens are moved from one account (`from`) to
102      * another (`to`).
103      *
104      * Note that `value` may be zero.
105      */
106     event Transfer(address indexed from, address indexed to, uint256 value);
107 
108     /**
109      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
110      * a call to {approve}. `value` is the new allowance.
111      */
112     event Approval(address indexed owner, address indexed spender, uint256 value);
113 }
114 
115 // File: @openzeppelin/contracts/math/SafeMath.sol
116 
117 
118 
119 pragma solidity ^0.6.0;
120 
121 /**
122  * @dev Wrappers over Solidity's arithmetic operations with added overflow
123  * checks.
124  *
125  * Arithmetic operations in Solidity wrap on overflow. This can easily result
126  * in bugs, because programmers usually assume that an overflow raises an
127  * error, which is the standard behavior in high level programming languages.
128  * `SafeMath` restores this intuition by reverting the transaction when an
129  * operation overflows.
130  *
131  * Using this library instead of the unchecked operations eliminates an entire
132  * class of bugs, so it's recommended to use it always.
133  */
134 library SafeMath {
135     /**
136      * @dev Returns the addition of two unsigned integers, reverting on
137      * overflow.
138      *
139      * Counterpart to Solidity's `+` operator.
140      *
141      * Requirements:
142      *
143      * - Addition cannot overflow.
144      */
145     function add(uint256 a, uint256 b) internal pure returns (uint256) {
146         uint256 c = a + b;
147         require(c >= a, "SafeMath: addition overflow");
148 
149         return c;
150     }
151 
152     /**
153      * @dev Returns the subtraction of two unsigned integers, reverting on
154      * overflow (when the result is negative).
155      *
156      * Counterpart to Solidity's `-` operator.
157      *
158      * Requirements:
159      *
160      * - Subtraction cannot overflow.
161      */
162     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
163         return sub(a, b, "SafeMath: subtraction overflow");
164     }
165 
166     /**
167      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
168      * overflow (when the result is negative).
169      *
170      * Counterpart to Solidity's `-` operator.
171      *
172      * Requirements:
173      *
174      * - Subtraction cannot overflow.
175      */
176     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
177         require(b <= a, errorMessage);
178         uint256 c = a - b;
179 
180         return c;
181     }
182 
183     /**
184      * @dev Returns the multiplication of two unsigned integers, reverting on
185      * overflow.
186      *
187      * Counterpart to Solidity's `*` operator.
188      *
189      * Requirements:
190      *
191      * - Multiplication cannot overflow.
192      */
193     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
194         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
195         // benefit is lost if 'b' is also tested.
196         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
197         if (a == 0) {
198             return 0;
199         }
200 
201         uint256 c = a * b;
202         require(c / a == b, "SafeMath: multiplication overflow");
203 
204         return c;
205     }
206 
207     /**
208      * @dev Returns the integer division of two unsigned integers. Reverts on
209      * division by zero. The result is rounded towards zero.
210      *
211      * Counterpart to Solidity's `/` operator. Note: this function uses a
212      * `revert` opcode (which leaves remaining gas untouched) while Solidity
213      * uses an invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function div(uint256 a, uint256 b) internal pure returns (uint256) {
220         return div(a, b, "SafeMath: division by zero");
221     }
222 
223     /**
224      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
225      * division by zero. The result is rounded towards zero.
226      *
227      * Counterpart to Solidity's `/` operator. Note: this function uses a
228      * `revert` opcode (which leaves remaining gas untouched) while Solidity
229      * uses an invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
236         require(b > 0, errorMessage);
237         uint256 c = a / b;
238         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
239 
240         return c;
241     }
242 
243     /**
244      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
245      * Reverts when dividing by zero.
246      *
247      * Counterpart to Solidity's `%` operator. This function uses a `revert`
248      * opcode (which leaves remaining gas untouched) while Solidity uses an
249      * invalid opcode to revert (consuming all remaining gas).
250      *
251      * Requirements:
252      *
253      * - The divisor cannot be zero.
254      */
255     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
256         return mod(a, b, "SafeMath: modulo by zero");
257     }
258 
259     /**
260      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
261      * Reverts with custom message when dividing by zero.
262      *
263      * Counterpart to Solidity's `%` operator. This function uses a `revert`
264      * opcode (which leaves remaining gas untouched) while Solidity uses an
265      * invalid opcode to revert (consuming all remaining gas).
266      *
267      * Requirements:
268      *
269      * - The divisor cannot be zero.
270      */
271     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
272         require(b != 0, errorMessage);
273         return a % b;
274     }
275 }
276 
277 // File: @openzeppelin/contracts/utils/Address.sol
278 
279 
280 
281 pragma solidity ^0.6.2;
282 
283 /**
284  * @dev Collection of functions related to the address type
285  */
286 library Address {
287     /**
288      * @dev Returns true if `account` is a contract.
289      *
290      * [IMPORTANT]
291      * ====
292      * It is unsafe to assume that an address for which this function returns
293      * false is an externally-owned account (EOA) and not a contract.
294      *
295      * Among others, `isContract` will return false for the following
296      * types of addresses:
297      *
298      *  - an externally-owned account
299      *  - a contract in construction
300      *  - an address where a contract will be created
301      *  - an address where a contract lived, but was destroyed
302      * ====
303      */
304     function isContract(address account) internal view returns (bool) {
305         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
306         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
307         // for accounts without code, i.e. `keccak256('')`
308         bytes32 codehash;
309         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
310         // solhint-disable-next-line no-inline-assembly
311         assembly { codehash := extcodehash(account) }
312         return (codehash != accountHash && codehash != 0x0);
313     }
314 
315     /**
316      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
317      * `recipient`, forwarding all available gas and reverting on errors.
318      *
319      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
320      * of certain opcodes, possibly making contracts go over the 2300 gas limit
321      * imposed by `transfer`, making them unable to receive funds via
322      * `transfer`. {sendValue} removes this limitation.
323      *
324      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
325      *
326      * IMPORTANT: because control is transferred to `recipient`, care must be
327      * taken to not create reentrancy vulnerabilities. Consider using
328      * {ReentrancyGuard} or the
329      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
330      */
331     function sendValue(address payable recipient, uint256 amount) internal {
332         require(address(this).balance >= amount, "Address: insufficient balance");
333 
334         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
335         (bool success, ) = recipient.call{ value: amount }("");
336         require(success, "Address: unable to send value, recipient may have reverted");
337     }
338 
339     /**
340      * @dev Performs a Solidity function call using a low level `call`. A
341      * plain`call` is an unsafe replacement for a function call: use this
342      * function instead.
343      *
344      * If `target` reverts with a revert reason, it is bubbled up by this
345      * function (like regular Solidity function calls).
346      *
347      * Returns the raw returned data. To convert to the expected return value,
348      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
349      *
350      * Requirements:
351      *
352      * - `target` must be a contract.
353      * - calling `target` with `data` must not revert.
354      *
355      * _Available since v3.1._
356      */
357     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
358       return functionCall(target, data, "Address: low-level call failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
363      * `errorMessage` as a fallback revert reason when `target` reverts.
364      *
365      * _Available since v3.1._
366      */
367     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
368         return _functionCallWithValue(target, data, 0, errorMessage);
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
373      * but also transferring `value` wei to `target`.
374      *
375      * Requirements:
376      *
377      * - the calling contract must have an ETH balance of at least `value`.
378      * - the called Solidity function must be `payable`.
379      *
380      * _Available since v3.1._
381      */
382     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
383         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
388      * with `errorMessage` as a fallback revert reason when `target` reverts.
389      *
390      * _Available since v3.1._
391      */
392     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
393         require(address(this).balance >= value, "Address: insufficient balance for call");
394         return _functionCallWithValue(target, data, value, errorMessage);
395     }
396 
397     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
398         require(isContract(target), "Address: call to non-contract");
399 
400         // solhint-disable-next-line avoid-low-level-calls
401         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
402         if (success) {
403             return returndata;
404         } else {
405             // Look for revert reason and bubble it up if present
406             if (returndata.length > 0) {
407                 // The easiest way to bubble the revert reason is using memory via assembly
408 
409                 // solhint-disable-next-line no-inline-assembly
410                 assembly {
411                     let returndata_size := mload(returndata)
412                     revert(add(32, returndata), returndata_size)
413                 }
414             } else {
415                 revert(errorMessage);
416             }
417         }
418     }
419 }
420 
421 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
422 
423 
424 
425 pragma solidity ^0.6.0;
426 
427 
428 
429 
430 
431 /**
432  * @dev Implementation of the {IERC20} interface.
433  *
434  * This implementation is agnostic to the way tokens are created. This means
435  * that a supply mechanism has to be added in a derived contract using {_mint}.
436  * For a generic mechanism see {ERC20PresetMinterPauser}.
437  *
438  * TIP: For a detailed writeup see our guide
439  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
440  * to implement supply mechanisms].
441  *
442  * We have followed general OpenZeppelin guidelines: functions revert instead
443  * of returning `false` on failure. This behavior is nonetheless conventional
444  * and does not conflict with the expectations of ERC20 applications.
445  *
446  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
447  * This allows applications to reconstruct the allowance for all accounts just
448  * by listening to said events. Other implementations of the EIP may not emit
449  * these events, as it isn't required by the specification.
450  *
451  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
452  * functions have been added to mitigate the well-known issues around setting
453  * allowances. See {IERC20-approve}.
454  */
455 contract ERC20 is Context, IERC20 {
456     using SafeMath for uint256;
457     using Address for address;
458 
459     mapping (address => uint256) private _balances;
460 
461     mapping (address => mapping (address => uint256)) private _allowances;
462 
463     uint256 private _totalSupply;
464 
465     string private _name;
466     string private _symbol;
467     uint8 private _decimals;
468 
469     /**
470      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
471      * a default value of 18.
472      *
473      * To select a different value for {decimals}, use {_setupDecimals}.
474      *
475      * All three of these values are immutable: they can only be set once during
476      * construction.
477      */
478     constructor (string memory name, string memory symbol) public {
479         _name = name;
480         _symbol = symbol;
481         _decimals = 18;
482     }
483 
484     /**
485      * @dev Returns the name of the token.
486      */
487     function name() public view returns (string memory) {
488         return _name;
489     }
490 
491     /**
492      * @dev Returns the symbol of the token, usually a shorter version of the
493      * name.
494      */
495     function symbol() public view returns (string memory) {
496         return _symbol;
497     }
498 
499     /**
500      * @dev Returns the number of decimals used to get its user representation.
501      * For example, if `decimals` equals `2`, a balance of `505` tokens should
502      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
503      *
504      * Tokens usually opt for a value of 18, imitating the relationship between
505      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
506      * called.
507      *
508      * NOTE: This information is only used for _display_ purposes: it in
509      * no way affects any of the arithmetic of the contract, including
510      * {IERC20-balanceOf} and {IERC20-transfer}.
511      */
512     function decimals() public view returns (uint8) {
513         return _decimals;
514     }
515 
516     /**
517      * @dev See {IERC20-totalSupply}.
518      */
519     function totalSupply() public view override returns (uint256) {
520         return _totalSupply;
521     }
522 
523     /**
524      * @dev See {IERC20-balanceOf}.
525      */
526     function balanceOf(address account) public view override returns (uint256) {
527         return _balances[account];
528     }
529 
530     /**
531      * @dev See {IERC20-transfer}.
532      *
533      * Requirements:
534      *
535      * - `recipient` cannot be the zero address.
536      * - the caller must have a balance of at least `amount`.
537      */
538     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
539         _transfer(_msgSender(), recipient, amount);
540         return true;
541     }
542 
543     /**
544      * @dev See {IERC20-allowance}.
545      */
546     function allowance(address owner, address spender) public view virtual override returns (uint256) {
547         return _allowances[owner][spender];
548     }
549 
550     /**
551      * @dev See {IERC20-approve}.
552      *
553      * Requirements:
554      *
555      * - `spender` cannot be the zero address.
556      */
557     function approve(address spender, uint256 amount) public virtual override returns (bool) {
558         _approve(_msgSender(), spender, amount);
559         return true;
560     }
561 
562     /**
563      * @dev See {IERC20-transferFrom}.
564      *
565      * Emits an {Approval} event indicating the updated allowance. This is not
566      * required by the EIP. See the note at the beginning of {ERC20};
567      *
568      * Requirements:
569      * - `sender` and `recipient` cannot be the zero address.
570      * - `sender` must have a balance of at least `amount`.
571      * - the caller must have allowance for ``sender``'s tokens of at least
572      * `amount`.
573      */
574     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
575         _transfer(sender, recipient, amount);
576         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
577         return true;
578     }
579 
580     /**
581      * @dev Atomically increases the allowance granted to `spender` by the caller.
582      *
583      * This is an alternative to {approve} that can be used as a mitigation for
584      * problems described in {IERC20-approve}.
585      *
586      * Emits an {Approval} event indicating the updated allowance.
587      *
588      * Requirements:
589      *
590      * - `spender` cannot be the zero address.
591      */
592     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
593         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
594         return true;
595     }
596 
597     /**
598      * @dev Atomically decreases the allowance granted to `spender` by the caller.
599      *
600      * This is an alternative to {approve} that can be used as a mitigation for
601      * problems described in {IERC20-approve}.
602      *
603      * Emits an {Approval} event indicating the updated allowance.
604      *
605      * Requirements:
606      *
607      * - `spender` cannot be the zero address.
608      * - `spender` must have allowance for the caller of at least
609      * `subtractedValue`.
610      */
611     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
612         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
613         return true;
614     }
615 
616     /**
617      * @dev Moves tokens `amount` from `sender` to `recipient`.
618      *
619      * This is internal function is equivalent to {transfer}, and can be used to
620      * e.g. implement automatic token fees, slashing mechanisms, etc.
621      *
622      * Emits a {Transfer} event.
623      *
624      * Requirements:
625      *
626      * - `sender` cannot be the zero address.
627      * - `recipient` cannot be the zero address.
628      * - `sender` must have a balance of at least `amount`.
629      */
630     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
631         require(sender != address(0), "ERC20: transfer from the zero address");
632         require(recipient != address(0), "ERC20: transfer to the zero address");
633 
634         _beforeTokenTransfer(sender, recipient, amount);
635 
636         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
637         _balances[recipient] = _balances[recipient].add(amount);
638         emit Transfer(sender, recipient, amount);
639     }
640 
641     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
642      * the total supply.
643      *
644      * Emits a {Transfer} event with `from` set to the zero address.
645      *
646      * Requirements
647      *
648      * - `to` cannot be the zero address.
649      */
650     function _mint(address account, uint256 amount) internal virtual {
651         require(account != address(0), "ERC20: mint to the zero address");
652 
653         _beforeTokenTransfer(address(0), account, amount);
654 
655         _totalSupply = _totalSupply.add(amount);
656         _balances[account] = _balances[account].add(amount);
657         emit Transfer(address(0), account, amount);
658     }
659 
660     /**
661      * @dev Destroys `amount` tokens from `account`, reducing the
662      * total supply.
663      *
664      * Emits a {Transfer} event with `to` set to the zero address.
665      *
666      * Requirements
667      *
668      * - `account` cannot be the zero address.
669      * - `account` must have at least `amount` tokens.
670      */
671     function _burn(address account, uint256 amount) internal virtual {
672         require(account != address(0), "ERC20: burn from the zero address");
673 
674         _beforeTokenTransfer(account, address(0), amount);
675 
676         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
677         _totalSupply = _totalSupply.sub(amount);
678         emit Transfer(account, address(0), amount);
679     }
680 
681     /**
682      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
683      *
684      * This is internal function is equivalent to `approve`, and can be used to
685      * e.g. set automatic allowances for certain subsystems, etc.
686      *
687      * Emits an {Approval} event.
688      *
689      * Requirements:
690      *
691      * - `owner` cannot be the zero address.
692      * - `spender` cannot be the zero address.
693      */
694     function _approve(address owner, address spender, uint256 amount) internal virtual {
695         require(owner != address(0), "ERC20: approve from the zero address");
696         require(spender != address(0), "ERC20: approve to the zero address");
697 
698         _allowances[owner][spender] = amount;
699         emit Approval(owner, spender, amount);
700     }
701 
702     /**
703      * @dev Sets {decimals} to a value other than the default one of 18.
704      *
705      * WARNING: This function should only be called from the constructor. Most
706      * applications that interact with token contracts will not expect
707      * {decimals} to ever change, and may work incorrectly if it does.
708      */
709     function _setupDecimals(uint8 decimals_) internal {
710         _decimals = decimals_;
711     }
712 
713     /**
714      * @dev Hook that is called before any transfer of tokens. This includes
715      * minting and burning.
716      *
717      * Calling conditions:
718      *
719      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
720      * will be to transferred to `to`.
721      * - when `from` is zero, `amount` tokens will be minted for `to`.
722      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
723      * - `from` and `to` are never both zero.
724      *
725      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
726      */
727     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
728 }
729 
730 // File: @openzeppelin/contracts/access/Ownable.sol
731 
732 
733 
734 pragma solidity ^0.6.0;
735 
736 /**
737  * @dev Contract module which provides a basic access control mechanism, where
738  * there is an account (an owner) that can be granted exclusive access to
739  * specific functions.
740  *
741  * By default, the owner account will be the one that deploys the contract. This
742  * can later be changed with {transferOwnership}.
743  *
744  * This module is used through inheritance. It will make available the modifier
745  * `onlyOwner`, which can be applied to your functions to restrict their use to
746  * the owner.
747  */
748 contract Ownable is Context {
749     address private _owner;
750 
751     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
752 
753     /**
754      * @dev Initializes the contract setting the deployer as the initial owner.
755      */
756     constructor () internal {
757         address msgSender = _msgSender();
758         _owner = msgSender;
759         emit OwnershipTransferred(address(0), msgSender);
760     }
761 
762     /**
763      * @dev Returns the address of the current owner.
764      */
765     function owner() public view returns (address) {
766         return _owner;
767     }
768 
769     /**
770      * @dev Throws if called by any account other than the owner.
771      */
772     modifier onlyOwner() {
773         require(_owner == _msgSender(), "Ownable: caller is not the owner");
774         _;
775     }
776 
777     /**
778      * @dev Leaves the contract without owner. It will not be possible to call
779      * `onlyOwner` functions anymore. Can only be called by the current owner.
780      *
781      * NOTE: Renouncing ownership will leave the contract without an owner,
782      * thereby removing any functionality that is only available to the owner.
783      */
784     function renounceOwnership() public virtual onlyOwner {
785         emit OwnershipTransferred(_owner, address(0));
786         _owner = address(0);
787     }
788 
789     /**
790      * @dev Transfers ownership of the contract to a new account (`newOwner`).
791      * Can only be called by the current owner.
792      */
793     function transferOwnership(address newOwner) public virtual onlyOwner {
794         require(newOwner != address(0), "Ownable: new owner is the zero address");
795         emit OwnershipTransferred(_owner, newOwner);
796         _owner = newOwner;
797     }
798 }
799 
800 // File: contracts/CatToken.sol
801 
802 pragma solidity 0.6.12;
803 
804 
805 
806 
807 // CatToken with Governance.
808 contract CatToken is ERC20("CatToken", "CAT"), Ownable {
809     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
810     
811     function mint(address _to, uint256 _amount) public onlyOwner {
812         _mint(_to, _amount);
813         _moveDelegates(address(0), _delegates[_to], _amount);
814     }
815 
816     // Copied and modified from YAM code:
817     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
818     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
819     // Which is copied and modified from COMPOUND:
820     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
821 
822     /// @notice A record of each accounts delegate
823     mapping (address => address) internal _delegates;
824 
825     /// @notice A checkpoint for marking number of votes from a given block
826     struct Checkpoint {
827         uint32 fromBlock;
828         uint256 votes;
829     }
830 
831     /// @notice A record of votes checkpoints for each account, by index
832     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
833 
834     /// @notice The number of checkpoints for each account
835     mapping (address => uint32) public numCheckpoints;
836 
837     /// @notice The EIP-712 typehash for the contract's domain
838     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
839 
840     /// @notice The EIP-712 typehash for the delegation struct used by the contract
841     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
842 
843     /// @notice A record of states for signing / validating signatures
844     mapping (address => uint) public nonces;
845 
846       /// @notice An event thats emitted when an account changes its delegate
847     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
848 
849     /// @notice An event thats emitted when a delegate account's vote balance changes
850     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
851 
852     /**
853      * @notice Delegate votes from `msg.sender` to `delegatee`
854      * @param delegator The address to get delegatee for
855      */
856     function delegates(address delegator)
857         external
858         view
859         returns (address)
860     {
861         return _delegates[delegator];
862     }
863 
864    /**
865     * @notice Delegate votes from `msg.sender` to `delegatee`
866     * @param delegatee The address to delegate votes to
867     */
868     function delegate(address delegatee) external {
869         return _delegate(msg.sender, delegatee);
870     }
871 
872     /**
873      * @notice Delegates votes from signatory to `delegatee`
874      * @param delegatee The address to delegate votes to
875      * @param nonce The contract state required to match the signature
876      * @param expiry The time at which to expire the signature
877      * @param v The recovery byte of the signature
878      * @param r Half of the ECDSA signature pair
879      * @param s Half of the ECDSA signature pair
880      */
881     function delegateBySig(
882         address delegatee,
883         uint nonce,
884         uint expiry,
885         uint8 v,
886         bytes32 r,
887         bytes32 s
888     )
889         external
890     {
891         bytes32 domainSeparator = keccak256(
892             abi.encode(
893                 DOMAIN_TYPEHASH,
894                 keccak256(bytes(name())),
895                 getChainId(),
896                 address(this)
897             )
898         );
899 
900         bytes32 structHash = keccak256(
901             abi.encode(
902                 DELEGATION_TYPEHASH,
903                 delegatee,
904                 nonce,
905                 expiry
906             )
907         );
908 
909         bytes32 digest = keccak256(
910             abi.encodePacked(
911                 "\x19\x01",
912                 domainSeparator,
913                 structHash
914             )
915         );
916 
917         address signatory = ecrecover(digest, v, r, s);
918         require(signatory != address(0), "CAT::delegateBySig: invalid signature");
919         require(nonce == nonces[signatory]++, "CAT::delegateBySig: invalid nonce");
920         require(now <= expiry, "CAT::delegateBySig: signature expired");
921         return _delegate(signatory, delegatee);
922     }
923 
924     /**
925      * @notice Gets the current votes balance for `account`
926      * @param account The address to get votes balance
927      * @return The number of current votes for `account`
928      */
929     function getCurrentVotes(address account)
930         external
931         view
932         returns (uint256)
933     {
934         uint32 nCheckpoints = numCheckpoints[account];
935         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
936     }
937 
938     /**
939      * @notice Determine the prior number of votes for an account as of a block number
940      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
941      * @param account The address of the account to check
942      * @param blockNumber The block number to get the vote balance at
943      * @return The number of votes the account had as of the given block
944      */
945     function getPriorVotes(address account, uint blockNumber)
946         external
947         view
948         returns (uint256)
949     {
950         require(blockNumber < block.number, "CAT::getPriorVotes: not yet determined");
951 
952         uint32 nCheckpoints = numCheckpoints[account];
953         if (nCheckpoints == 0) {
954             return 0;
955         }
956 
957         // First check most recent balance
958         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
959             return checkpoints[account][nCheckpoints - 1].votes;
960         }
961 
962         // Next check implicit zero balance
963         if (checkpoints[account][0].fromBlock > blockNumber) {
964             return 0;
965         }
966 
967         uint32 lower = 0;
968         uint32 upper = nCheckpoints - 1;
969         while (upper > lower) {
970             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
971             Checkpoint memory cp = checkpoints[account][center];
972             if (cp.fromBlock == blockNumber) {
973                 return cp.votes;
974             } else if (cp.fromBlock < blockNumber) {
975                 lower = center;
976             } else {
977                 upper = center - 1;
978             }
979         }
980         return checkpoints[account][lower].votes;
981     }
982 
983     function _delegate(address delegator, address delegatee)
984         internal
985     {
986         address currentDelegate = _delegates[delegator];
987         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying SASHIMIs (not scaled);
988         _delegates[delegator] = delegatee;
989 
990         emit DelegateChanged(delegator, currentDelegate, delegatee);
991 
992         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
993     }
994 
995     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
996         if (srcRep != dstRep && amount > 0) {
997             if (srcRep != address(0)) {
998                 // decrease old representative
999                 uint32 srcRepNum = numCheckpoints[srcRep];
1000                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1001                 uint256 srcRepNew = srcRepOld.sub(amount);
1002                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1003             }
1004 
1005             if (dstRep != address(0)) {
1006                 // increase new representative
1007                 uint32 dstRepNum = numCheckpoints[dstRep];
1008                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1009                 uint256 dstRepNew = dstRepOld.add(amount);
1010                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1011             }
1012         }
1013     }
1014 
1015     function _writeCheckpoint(
1016         address delegatee,
1017         uint32 nCheckpoints,
1018         uint256 oldVotes,
1019         uint256 newVotes
1020     )
1021         internal
1022     {
1023         uint32 blockNumber = safe32(block.number, "CAT::_writeCheckpoint: block number exceeds 32 bits");
1024 
1025         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1026             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1027         } else {
1028             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1029             numCheckpoints[delegatee] = nCheckpoints + 1;
1030         }
1031 
1032         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1033     }
1034 
1035     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1036         require(n < 2**32, errorMessage);
1037         return uint32(n);
1038     }
1039 
1040     function getChainId() internal pure returns (uint) {
1041         uint256 chainId;
1042         assembly { chainId := chainid() }
1043         return chainId;
1044     }
1045 }