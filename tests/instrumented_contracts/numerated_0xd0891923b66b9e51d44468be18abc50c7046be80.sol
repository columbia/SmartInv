1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-30
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-11-05
7 */
8 
9 // File: @openzeppelin/contracts/GSN/Context.sol
10 
11 // SPDX-License-Identifier: MIT
12 
13 pragma solidity ^0.7.0;
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
39 
40 pragma solidity ^0.7.0;
41 
42 /**
43  * @dev Interface of the ERC20 standard as defined in the EIP.
44  */
45 interface IERC20 {
46     /**
47      * @dev Returns the amount of tokens in existence.
48      */
49     function totalSupply() external view returns (uint256);
50 
51     /**
52      * @dev Returns the amount of tokens owned by `account`.
53      */
54     function balanceOf(address account) external view returns (uint256);
55 
56     /**
57      * @dev Moves `amount` tokens from the caller's account to `recipient`.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transfer(address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Returns the remaining number of tokens that `spender` will be
67      * allowed to spend on behalf of `owner` through {transferFrom}. This is
68      * zero by default.
69      *
70      * This value changes when {approve} or {transferFrom} are called.
71      */
72     function allowance(address owner, address spender) external view returns (uint256);
73 
74     /**
75      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * IMPORTANT: Beware that changing an allowance with this method brings the risk
80      * that someone may use both the old and the new allowance by unfortunate
81      * transaction ordering. One possible solution to mitigate this race
82      * condition is to first reduce the spender's allowance to 0 and set the
83      * desired value afterwards:
84      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
85      *
86      * Emits an {Approval} event.
87      */
88     function approve(address spender, uint256 amount) external returns (bool);
89 
90     /**
91      * @dev Moves `amount` tokens from `sender` to `recipient` using the
92      * allowance mechanism. `amount` is then deducted from the caller's
93      * allowance.
94      *
95      * Returns a boolean value indicating whether the operation succeeded.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
100 
101     /**
102      * @dev Emitted when `value` tokens are moved from one account (`from`) to
103      * another (`to`).
104      *
105      * Note that `value` may be zero.
106      */
107     event Transfer(address indexed from, address indexed to, uint256 value);
108 
109     /**
110      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
111      * a call to {approve}. `value` is the new allowance.
112      */
113     event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 
116 // File: @openzeppelin/contracts/math/SafeMath.sol
117 
118 
119 
120 pragma solidity ^0.7.0;
121 
122 /**
123  * @dev Wrappers over Solidity's arithmetic operations with added overflow
124  * checks.
125  *
126  * Arithmetic operations in Solidity wrap on overflow. This can easily result
127  * in bugs, because programmers usually assume that an overflow raises an
128  * error, which is the standard behavior in high level programming languages.
129  * `SafeMath` restores this intuition by reverting the transaction when an
130  * operation overflows.
131  *
132  * Using this library instead of the unchecked operations eliminates an entire
133  * class of bugs, so it's recommended to use it always.
134  */
135 library SafeMath {
136     /**
137      * @dev Returns the addition of two unsigned integers, reverting on
138      * overflow.
139      *
140      * Counterpart to Solidity's `+` operator.
141      *
142      * Requirements:
143      *
144      * - Addition cannot overflow.
145      */
146     function add(uint256 a, uint256 b) internal pure returns (uint256) {
147         uint256 c = a + b;
148         require(c >= a, "SafeMath: addition overflow");
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the subtraction of two unsigned integers, reverting on
155      * overflow (when the result is negative).
156      *
157      * Counterpart to Solidity's `-` operator.
158      *
159      * Requirements:
160      *
161      * - Subtraction cannot overflow.
162      */
163     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
164         return sub(a, b, "SafeMath: subtraction overflow");
165     }
166 
167     /**
168      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
169      * overflow (when the result is negative).
170      *
171      * Counterpart to Solidity's `-` operator.
172      *
173      * Requirements:
174      *
175      * - Subtraction cannot overflow.
176      */
177     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
178         require(b <= a, errorMessage);
179         uint256 c = a - b;
180 
181         return c;
182     }
183 
184     /**
185      * @dev Returns the multiplication of two unsigned integers, reverting on
186      * overflow.
187      *
188      * Counterpart to Solidity's `*` operator.
189      *
190      * Requirements:
191      *
192      * - Multiplication cannot overflow.
193      */
194     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
195         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
196         // benefit is lost if 'b' is also tested.
197         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
198         if (a == 0) {
199             return 0;
200         }
201 
202         uint256 c = a * b;
203         require(c / a == b, "SafeMath: multiplication overflow");
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the integer division of two unsigned integers. Reverts on
210      * division by zero. The result is rounded towards zero.
211      *
212      * Counterpart to Solidity's `/` operator. Note: this function uses a
213      * `revert` opcode (which leaves remaining gas untouched) while Solidity
214      * uses an invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function div(uint256 a, uint256 b) internal pure returns (uint256) {
221         return div(a, b, "SafeMath: division by zero");
222     }
223 
224     /**
225      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
226      * division by zero. The result is rounded towards zero.
227      *
228      * Counterpart to Solidity's `/` operator. Note: this function uses a
229      * `revert` opcode (which leaves remaining gas untouched) while Solidity
230      * uses an invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
237         require(b > 0, errorMessage);
238         uint256 c = a / b;
239         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
240 
241         return c;
242     }
243 
244     /**
245      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
246      * Reverts when dividing by zero.
247      *
248      * Counterpart to Solidity's `%` operator. This function uses a `revert`
249      * opcode (which leaves remaining gas untouched) while Solidity uses an
250      * invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      *
254      * - The divisor cannot be zero.
255      */
256     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
257         return mod(a, b, "SafeMath: modulo by zero");
258     }
259 
260     /**
261      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
262      * Reverts with custom message when dividing by zero.
263      *
264      * Counterpart to Solidity's `%` operator. This function uses a `revert`
265      * opcode (which leaves remaining gas untouched) while Solidity uses an
266      * invalid opcode to revert (consuming all remaining gas).
267      *
268      * Requirements:
269      *
270      * - The divisor cannot be zero.
271      */
272     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
273         require(b != 0, errorMessage);
274         return a % b;
275     }
276 }
277 
278 // File: @openzeppelin/contracts/utils/Address.sol
279 
280 
281 
282 pragma solidity ^0.7.0;
283 
284 /**
285  * @dev Collection of functions related to the address type
286  */
287 library Address {
288     /**
289      * @dev Returns true if `account` is a contract.
290      *
291      * [IMPORTANT]
292      * ====
293      * It is unsafe to assume that an address for which this function returns
294      * false is an externally-owned account (EOA) and not a contract.
295      *
296      * Among others, `isContract` will return false for the following
297      * types of addresses:
298      *
299      *  - an externally-owned account
300      *  - a contract in construction
301      *  - an address where a contract will be created
302      *  - an address where a contract lived, but was destroyed
303      * ====
304      */
305     function isContract(address account) internal view returns (bool) {
306         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
307         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
308         // for accounts without code, i.e. `keccak256('')`
309         bytes32 codehash;
310         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
311         // solhint-disable-next-line no-inline-assembly
312         assembly { codehash := extcodehash(account) }
313         return (codehash != accountHash && codehash != 0x0);
314     }
315 
316     /**
317      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
318      * `recipient`, forwarding all available gas and reverting on errors.
319      *
320      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
321      * of certain opcodes, possibly making contracts go over the 2300 gas limit
322      * imposed by `transfer`, making them unable to receive funds via
323      * `transfer`. {sendValue} removes this limitation.
324      *
325      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
326      *
327      * IMPORTANT: because control is transferred to `recipient`, care must be
328      * taken to not create reentrancy vulnerabilities. Consider using
329      * {ReentrancyGuard} or the
330      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
331      */
332     function sendValue(address payable recipient, uint256 amount) internal {
333         require(address(this).balance >= amount, "Address: insufficient balance");
334 
335         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
336         (bool success, ) = recipient.call{ value: amount }("");
337         require(success, "Address: unable to send value, recipient may have reverted");
338     }
339 
340     /**
341      * @dev Performs a Solidity function call using a low level `call`. A
342      * plain`call` is an unsafe replacement for a function call: use this
343      * function instead.
344      *
345      * If `target` reverts with a revert reason, it is bubbled up by this
346      * function (like regular Solidity function calls).
347      *
348      * Returns the raw returned data. To convert to the expected return value,
349      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
350      *
351      * Requirements:
352      *
353      * - `target` must be a contract.
354      * - calling `target` with `data` must not revert.
355      *
356      * _Available since v3.1._
357      */
358     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
359       return functionCall(target, data, "Address: low-level call failed");
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
364      * `errorMessage` as a fallback revert reason when `target` reverts.
365      *
366      * _Available since v3.1._
367      */
368     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
369         return _functionCallWithValue(target, data, 0, errorMessage);
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
374      * but also transferring `value` wei to `target`.
375      *
376      * Requirements:
377      *
378      * - the calling contract must have an ETH balance of at least `value`.
379      * - the called Solidity function must be `payable`.
380      *
381      * _Available since v3.1._
382      */
383     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
384         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
389      * with `errorMessage` as a fallback revert reason when `target` reverts.
390      *
391      * _Available since v3.1._
392      */
393     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
394         require(address(this).balance >= value, "Address: insufficient balance for call");
395         return _functionCallWithValue(target, data, value, errorMessage);
396     }
397 
398     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
399         require(isContract(target), "Address: call to non-contract");
400 
401         // solhint-disable-next-line avoid-low-level-calls
402         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
403         if (success) {
404             return returndata;
405         } else {
406             // Look for revert reason and bubble it up if present
407             if (returndata.length > 0) {
408                 // The easiest way to bubble the revert reason is using memory via assembly
409 
410                 // solhint-disable-next-line no-inline-assembly
411                 assembly {
412                     let returndata_size := mload(returndata)
413                     revert(add(32, returndata), returndata_size)
414                 }
415             } else {
416                 revert(errorMessage);
417             }
418         }
419     }
420 }
421 
422 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
423 
424 
425 
426 pragma solidity ^0.7.0;
427 
428 
429 
430 
431 
432 /**
433  * @dev Implementation of the {IERC20} interface.
434  *
435  * This implementation is agnostic to the way tokens are created. This means
436  * that a supply mechanism has to be added in a derived contract using {_mint}.
437  * For a generic mechanism see {ERC20PresetMinterPauser}.
438  *
439  * TIP: For a detailed writeup see our guide
440  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
441  * to implement supply mechanisms].
442  *
443  * We have followed general OpenZeppelin guidelines: functions revert instead
444  * of returning `false` on failure. This behavior is nonetheless conventional
445  * and does not conflict with the expectations of ERC20 applications.
446  *
447  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
448  * This allows applications to reconstruct the allowance for all accounts just
449  * by listening to said events. Other implementations of the EIP may not emit
450  * these events, as it isn't required by the specification.
451  *
452  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
453  * functions have been added to mitigate the well-known issues around setting
454  * allowances. See {IERC20-approve}.
455  */
456 contract ERC20 is Context, IERC20 {
457     using SafeMath for uint256;
458     using Address for address;
459 
460     mapping (address => uint256) private _balances;
461 
462     mapping (address => mapping (address => uint256)) private _allowances;
463 
464     uint256 private _totalSupply;
465 
466     string private _name;
467     string private _symbol;
468     uint8 private _decimals;
469 
470     /**
471      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
472      * a default value of 18.
473      *
474      * To select a different value for {decimals}, use {_setupDecimals}.
475      *
476      * All three of these values are immutable: they can only be set once during
477      * construction.
478      */
479     constructor (string memory name_, string memory symbol_) {
480         _name = name_;
481         _symbol = symbol_;
482         _decimals = 18;
483     }
484 
485     /**
486      * @dev Returns the name of the token.
487      */
488     function name() public view returns (string memory) {
489         return _name;
490     }
491 
492     /**
493      * @dev Returns the symbol of the token, usually a shorter version of the
494      * name.
495      */
496     function symbol() public view returns (string memory) {
497         return _symbol;
498     }
499 
500     /**
501      * @dev Returns the number of decimals used to get its user representation.
502      * For example, if `decimals` equals `2`, a balance of `505` tokens should
503      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
504      *
505      * Tokens usually opt for a value of 18, imitating the relationship between
506      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
507      * called.
508      *
509      * NOTE: This information is only used for _display_ purposes: it in
510      * no way affects any of the arithmetic of the contract, including
511      * {IERC20-balanceOf} and {IERC20-transfer}.
512      */
513     function decimals() public view returns (uint8) {
514         return _decimals;
515     }
516 
517     /**
518      * @dev See {IERC20-totalSupply}.
519      */
520     function totalSupply() public view override returns (uint256) {
521         return _totalSupply;
522     }
523 
524     /**
525      * @dev See {IERC20-balanceOf}.
526      */
527     function balanceOf(address account) public view override returns (uint256) {
528         return _balances[account];
529     }
530 
531     /**
532      * @dev See {IERC20-transfer}.
533      *
534      * Requirements:
535      *
536      * - `recipient` cannot be the zero address.
537      * - the caller must have a balance of at least `amount`.
538      */
539     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
540         _transfer(_msgSender(), recipient, amount);
541         return true;
542     }
543 
544     /**
545      * @dev See {IERC20-allowance}.
546      */
547     function allowance(address owner, address spender) public view virtual override returns (uint256) {
548         return _allowances[owner][spender];
549     }
550 
551     /**
552      * @dev See {IERC20-approve}.
553      *
554      * Requirements:
555      *
556      * - `spender` cannot be the zero address.
557      */
558     function approve(address spender, uint256 amount) public virtual override returns (bool) {
559         _approve(_msgSender(), spender, amount);
560         return true;
561     }
562 
563     /**
564      * @dev See {IERC20-transferFrom}.
565      *
566      * Emits an {Approval} event indicating the updated allowance. This is not
567      * required by the EIP. See the note at the beginning of {ERC20};
568      *
569      * Requirements:
570      * - `sender` and `recipient` cannot be the zero address.
571      * - `sender` must have a balance of at least `amount`.
572      * - the caller must have allowance for ``sender``'s tokens of at least
573      * `amount`.
574      */
575     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
576         _transfer(sender, recipient, amount);
577         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
578         return true;
579     }
580 
581     /**
582      * @dev Atomically increases the allowance granted to `spender` by the caller.
583      *
584      * This is an alternative to {approve} that can be used as a mitigation for
585      * problems described in {IERC20-approve}.
586      *
587      * Emits an {Approval} event indicating the updated allowance.
588      *
589      * Requirements:
590      *
591      * - `spender` cannot be the zero address.
592      */
593     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
594         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
595         return true;
596     }
597 
598     /**
599      * @dev Atomically decreases the allowance granted to `spender` by the caller.
600      *
601      * This is an alternative to {approve} that can be used as a mitigation for
602      * problems described in {IERC20-approve}.
603      *
604      * Emits an {Approval} event indicating the updated allowance.
605      *
606      * Requirements:
607      *
608      * - `spender` cannot be the zero address.
609      * - `spender` must have allowance for the caller of at least
610      * `subtractedValue`.
611      */
612     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
613         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
614         return true;
615     }
616 
617     /**
618      * @dev Moves tokens `amount` from `sender` to `recipient`.
619      *
620      * This is internal function is equivalent to {transfer}, and can be used to
621      * e.g. implement automatic token fees, slashing mechanisms, etc.
622      *
623      * Emits a {Transfer} event.
624      *
625      * Requirements:
626      *
627      * - `sender` cannot be the zero address.
628      * - `recipient` cannot be the zero address.
629      * - `sender` must have a balance of at least `amount`.
630      */
631     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
632         require(sender != address(0), "ERC20: transfer from the zero address");
633         require(recipient != address(0), "ERC20: transfer to the zero address");
634 
635         _beforeTokenTransfer(sender, recipient, amount);
636 
637         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
638         _balances[recipient] = _balances[recipient].add(amount);
639         emit Transfer(sender, recipient, amount);
640     }
641 
642     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
643      * the total supply.
644      *
645      * Emits a {Transfer} event with `from` set to the zero address.
646      *
647      * Requirements
648      *
649      * - `to` cannot be the zero address.
650      */
651     function _mint(address account, uint256 amount) internal virtual {
652         require(account != address(0), "ERC20: mint to the zero address");
653 
654         _beforeTokenTransfer(address(0), account, amount);
655 
656         _totalSupply = _totalSupply.add(amount);
657         _balances[account] = _balances[account].add(amount);
658         emit Transfer(address(0), account, amount);
659     }
660 
661     /**
662      * @dev Destroys `amount` tokens from `account`, reducing the
663      * total supply.
664      *
665      * Emits a {Transfer} event with `to` set to the zero address.
666      *
667      * Requirements
668      *
669      * - `account` cannot be the zero address.
670      * - `account` must have at least `amount` tokens.
671      */
672     function _burn(address account, uint256 amount) internal virtual {
673         require(account != address(0), "ERC20: burn from the zero address");
674 
675         _beforeTokenTransfer(account, address(0), amount);
676 
677         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
678         _totalSupply = _totalSupply.sub(amount);
679         emit Transfer(account, address(0), amount);
680     }
681 
682     /**
683      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
684      *
685      * This internal function is equivalent to `approve`, and can be used to
686      * e.g. set automatic allowances for certain subsystems, etc.
687      *
688      * Emits an {Approval} event.
689      *
690      * Requirements:
691      *
692      * - `owner` cannot be the zero address.
693      * - `spender` cannot be the zero address.
694      */
695     function _approve(address owner, address spender, uint256 amount) internal virtual {
696         require(owner != address(0), "ERC20: approve from the zero address");
697         require(spender != address(0), "ERC20: approve to the zero address");
698 
699         _allowances[owner][spender] = amount;
700         emit Approval(owner, spender, amount);
701     }
702 
703     /**
704      * @dev Sets {decimals} to a value other than the default one of 18.
705      *
706      * WARNING: This function should only be called from the constructor. Most
707      * applications that interact with token contracts will not expect
708      * {decimals} to ever change, and may work incorrectly if it does.
709      */
710     function _setupDecimals(uint8 decimals_) internal {
711         _decimals = decimals_;
712     }
713 
714     /**
715      * @dev Hook that is called before any transfer of tokens. This includes
716      * minting and burning.
717      *
718      * Calling conditions:
719      *
720      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
721      * will be to transferred to `to`.
722      * - when `from` is zero, `amount` tokens will be minted for `to`.
723      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
724      * - `from` and `to` are never both zero.
725      *
726      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
727      */
728     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
729 }
730 
731 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
732 
733 
734 
735 pragma solidity ^0.7.0;
736 
737 
738 
739 /**
740  * @dev Extension of {ERC20} that allows token holders to destroy both their own
741  * tokens and those that they have an allowance for, in a way that can be
742  * recognized off-chain (via event analysis).
743  */
744 abstract contract ERC20Burnable is Context, ERC20 {
745     using SafeMath for uint256;
746 
747     /**
748      * @dev Destroys `amount` tokens from the caller.
749      *
750      * See {ERC20-_burn}.
751      */
752     function burn(uint256 amount) public virtual {
753         _burn(_msgSender(), amount);
754     }
755 
756     /**
757      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
758      * allowance.
759      *
760      * See {ERC20-_burn} and {ERC20-allowance}.
761      *
762      * Requirements:
763      *
764      * - the caller must have allowance for ``accounts``'s tokens of at least
765      * `amount`.
766      */
767     function burnFrom(address account, uint256 amount) public virtual {
768         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
769 
770         _approve(account, _msgSender(), decreasedAllowance);
771         _burn(account, amount);
772     }
773 }
774 
775 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
776 
777 
778 
779 pragma solidity ^0.7.0;
780 
781 
782 /**
783  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
784  */
785 abstract contract ERC20Capped is ERC20 {
786     using SafeMath for uint256;
787 
788     uint256 private _cap;
789 
790     /**
791      * @dev Sets the value of the `cap`. This value is immutable, it can only be
792      * set once during construction.
793      */
794     constructor (uint256 cap_) {
795         require(cap_ > 0, "ERC20Capped: cap is 0");
796         _cap = cap_;
797     }
798 
799     /**
800      * @dev Returns the cap on the token's total supply.
801      */
802     function cap() public view returns (uint256) {
803         return _cap;
804     }
805 
806     /**
807      * @dev See {ERC20-_beforeTokenTransfer}.
808      *
809      * Requirements:
810      *
811      * - minted tokens must not cause the total supply to go over the cap.
812      */
813     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
814         super._beforeTokenTransfer(from, to, amount);
815 
816         if (from == address(0)) { // When minting tokens
817             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
818         }
819     }
820 }
821 
822 // File: @openzeppelin/contracts/introspection/IERC165.sol
823 
824 
825 
826 pragma solidity ^0.7.0;
827 
828 /**
829  * @dev Interface of the ERC165 standard, as defined in the
830  * https://eips.ethereum.org/EIPS/eip-165[EIP].
831  *
832  * Implementers can declare support of contract interfaces, which can then be
833  * queried by others ({ERC165Checker}).
834  *
835  * For an implementation, see {ERC165}.
836  */
837 interface IERC165 {
838     /**
839      * @dev Returns true if this contract implements the interface defined by
840      * `interfaceId`. See the corresponding
841      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
842      * to learn more about how these ids are created.
843      *
844      * This function call must use less than 30 000 gas.
845      */
846     function supportsInterface(bytes4 interfaceId) external view returns (bool);
847 }
848 
849 // File: erc-payable-token/contracts/token/ERC1363/IERC1363.sol
850 
851 
852 
853 pragma solidity ^0.7.0;
854 
855 
856 
857 /**
858  * @title IERC1363 Interface
859  * @dev Interface for a Payable Token contract as defined in
860  *  https://eips.ethereum.org/EIPS/eip-1363
861  */
862 interface IERC1363 is IERC20, IERC165 {
863     /*
864      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
865      * 0x4bbee2df ===
866      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
867      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
868      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
869      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
870      */
871 
872     /*
873      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
874      * 0xfb9ec8ce ===
875      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
876      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
877      */
878 
879     /**
880      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
881      * @param to address The address which you want to transfer to
882      * @param value uint256 The amount of tokens to be transferred
883      * @return true unless throwing
884      */
885     function transferAndCall(address to, uint256 value) external returns (bool);
886 
887     /**
888      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
889      * @param to address The address which you want to transfer to
890      * @param value uint256 The amount of tokens to be transferred
891      * @param data bytes Additional data with no specified format, sent in call to `to`
892      * @return true unless throwing
893      */
894     function transferAndCall(address to, uint256 value, bytes calldata data) external returns (bool);
895 
896     /**
897      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
898      * @param from address The address which you want to send tokens from
899      * @param to address The address which you want to transfer to
900      * @param value uint256 The amount of tokens to be transferred
901      * @return true unless throwing
902      */
903     function transferFromAndCall(address from, address to, uint256 value) external returns (bool);
904 
905     /**
906      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
907      * @param from address The address which you want to send tokens from
908      * @param to address The address which you want to transfer to
909      * @param value uint256 The amount of tokens to be transferred
910      * @param data bytes Additional data with no specified format, sent in call to `to`
911      * @return true unless throwing
912      */
913     function transferFromAndCall(address from, address to, uint256 value, bytes calldata data) external returns (bool);
914 
915     /**
916      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
917      * and then call `onApprovalReceived` on spender.
918      * Beware that changing an allowance with this method brings the risk that someone may use both the old
919      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
920      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
921      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
922      * @param spender address The address which will spend the funds
923      * @param value uint256 The amount of tokens to be spent
924      */
925     function approveAndCall(address spender, uint256 value) external returns (bool);
926 
927     /**
928      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
929      * and then call `onApprovalReceived` on spender.
930      * Beware that changing an allowance with this method brings the risk that someone may use both the old
931      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
932      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
933      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
934      * @param spender address The address which will spend the funds
935      * @param value uint256 The amount of tokens to be spent
936      * @param data bytes Additional data with no specified format, sent in call to `spender`
937      */
938     function approveAndCall(address spender, uint256 value, bytes calldata data) external returns (bool);
939 }
940 
941 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Receiver.sol
942 
943 
944 
945 pragma solidity ^0.7.0;
946 
947 /**
948  * @title IERC1363Receiver Interface
949  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
950  *  from ERC1363 token contracts as defined in
951  *  https://eips.ethereum.org/EIPS/eip-1363
952  */
953 interface IERC1363Receiver {
954     /*
955      * Note: the ERC-165 identifier for this interface is 0x88a7ca5c.
956      * 0x88a7ca5c === bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))
957      */
958 
959     /**
960      * @notice Handle the receipt of ERC1363 tokens
961      * @dev Any ERC1363 smart contract calls this function on the recipient
962      * after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
963      * transfer. Return of other than the magic value MUST result in the
964      * transaction being reverted.
965      * Note: the token contract address is always the message sender.
966      * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
967      * @param from address The address which are token transferred from
968      * @param value uint256 The amount of tokens transferred
969      * @param data bytes Additional data with no specified format
970      * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
971      *  unless throwing
972      */
973     function onTransferReceived(address operator, address from, uint256 value, bytes calldata data) external returns (bytes4);
974 }
975 
976 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Spender.sol
977 
978 
979 
980 pragma solidity ^0.7.0;
981 
982 /**
983  * @title IERC1363Spender Interface
984  * @dev Interface for any contract that wants to support approveAndCall
985  *  from ERC1363 token contracts as defined in
986  *  https://eips.ethereum.org/EIPS/eip-1363
987  */
988 interface IERC1363Spender {
989     /*
990      * Note: the ERC-165 identifier for this interface is 0x7b04a2d0.
991      * 0x7b04a2d0 === bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))
992      */
993 
994     /**
995      * @notice Handle the approval of ERC1363 tokens
996      * @dev Any ERC1363 smart contract calls this function on the recipient
997      * after an `approve`. This function MAY throw to revert and reject the
998      * approval. Return of other than the magic value MUST result in the
999      * transaction being reverted.
1000      * Note: the token contract address is always the message sender.
1001      * @param owner address The address which called `approveAndCall` function
1002      * @param value uint256 The amount of tokens to be spent
1003      * @param data bytes Additional data with no specified format
1004      * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
1005      *  unless throwing
1006      */
1007     function onApprovalReceived(address owner, uint256 value, bytes calldata data) external returns (bytes4);
1008 }
1009 
1010 // File: @openzeppelin/contracts/introspection/ERC165Checker.sol
1011 
1012 
1013 
1014 pragma solidity ^0.7.0;
1015 
1016 /**
1017  * @dev Library used to query support of an interface declared via {IERC165}.
1018  *
1019  * Note that these functions return the actual result of the query: they do not
1020  * `revert` if an interface is not supported. It is up to the caller to decide
1021  * what to do in these cases.
1022  */
1023 library ERC165Checker {
1024     // As per the EIP-165 spec, no interface should ever match 0xffffffff
1025     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
1026 
1027     /*
1028      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1029      */
1030     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1031 
1032     /**
1033      * @dev Returns true if `account` supports the {IERC165} interface,
1034      */
1035     function supportsERC165(address account) internal view returns (bool) {
1036         // Any contract that implements ERC165 must explicitly indicate support of
1037         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
1038         return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
1039             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
1040     }
1041 
1042     /**
1043      * @dev Returns true if `account` supports the interface defined by
1044      * `interfaceId`. Support for {IERC165} itself is queried automatically.
1045      *
1046      * See {IERC165-supportsInterface}.
1047      */
1048     function supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
1049         // query support of both ERC165 as per the spec and support of _interfaceId
1050         return supportsERC165(account) &&
1051             _supportsERC165Interface(account, interfaceId);
1052     }
1053 
1054     /**
1055      * @dev Returns true if `account` supports all the interfaces defined in
1056      * `interfaceIds`. Support for {IERC165} itself is queried automatically.
1057      *
1058      * Batch-querying can lead to gas savings by skipping repeated checks for
1059      * {IERC165} support.
1060      *
1061      * See {IERC165-supportsInterface}.
1062      */
1063     function supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
1064         // query support of ERC165 itself
1065         if (!supportsERC165(account)) {
1066             return false;
1067         }
1068 
1069         // query support of each interface in _interfaceIds
1070         for (uint256 i = 0; i < interfaceIds.length; i++) {
1071             if (!_supportsERC165Interface(account, interfaceIds[i])) {
1072                 return false;
1073             }
1074         }
1075 
1076         // all interfaces supported
1077         return true;
1078     }
1079 
1080     /**
1081      * @notice Query if a contract implements an interface, does not check ERC165 support
1082      * @param account The address of the contract to query for support of an interface
1083      * @param interfaceId The interface identifier, as specified in ERC-165
1084      * @return true if the contract at account indicates support of the interface with
1085      * identifier interfaceId, false otherwise
1086      * @dev Assumes that account contains a contract that supports ERC165, otherwise
1087      * the behavior of this method is undefined. This precondition can be checked
1088      * with {supportsERC165}.
1089      * Interface identification is specified in ERC-165.
1090      */
1091     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
1092         // success determines whether the staticcall succeeded and result determines
1093         // whether the contract at account indicates support of _interfaceId
1094         (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);
1095 
1096         return (success && result);
1097     }
1098 
1099     /**
1100      * @notice Calls the function with selector 0x01ffc9a7 (ERC165) and suppresses throw
1101      * @param account The address of the contract to query for support of an interface
1102      * @param interfaceId The interface identifier, as specified in ERC-165
1103      * @return success true if the STATICCALL succeeded, false otherwise
1104      * @return result true if the STATICCALL succeeded and the contract at account
1105      * indicates support of the interface with identifier interfaceId, false otherwise
1106      */
1107     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
1108         private
1109         view
1110         returns (bool, bool)
1111     {
1112         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
1113         (bool success, bytes memory result) = account.staticcall{ gas: 30000 }(encodedParams);
1114         if (result.length < 32) return (false, false);
1115         return (success, abi.decode(result, (bool)));
1116     }
1117 }
1118 
1119 // File: @openzeppelin/contracts/introspection/ERC165.sol
1120 
1121 
1122 
1123 pragma solidity ^0.7.0;
1124 
1125 
1126 /**
1127  * @dev Implementation of the {IERC165} interface.
1128  *
1129  * Contracts may inherit from this and call {_registerInterface} to declare
1130  * their support of an interface.
1131  */
1132 abstract contract ERC165 is IERC165 {
1133     /*
1134      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1135      */
1136     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1137 
1138     /**
1139      * @dev Mapping of interface ids to whether or not it's supported.
1140      */
1141     mapping(bytes4 => bool) private _supportedInterfaces;
1142 
1143     constructor () {
1144         // Derived contracts need only register support for their own interfaces,
1145         // we register support for ERC165 itself here
1146         _registerInterface(_INTERFACE_ID_ERC165);
1147     }
1148 
1149     /**
1150      * @dev See {IERC165-supportsInterface}.
1151      *
1152      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1153      */
1154     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
1155         return _supportedInterfaces[interfaceId];
1156     }
1157 
1158     /**
1159      * @dev Registers the contract as an implementer of the interface defined by
1160      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1161      * registering its interface id is not required.
1162      *
1163      * See {IERC165-supportsInterface}.
1164      *
1165      * Requirements:
1166      *
1167      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1168      */
1169     function _registerInterface(bytes4 interfaceId) internal virtual {
1170         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1171         _supportedInterfaces[interfaceId] = true;
1172     }
1173 }
1174 
1175 // File: erc-payable-token/contracts/token/ERC1363/ERC1363.sol
1176 
1177 
1178 
1179 pragma solidity ^0.7.0;
1180 
1181 
1182 
1183 
1184 
1185 
1186 
1187 
1188 /**
1189  * @title ERC1363
1190  * @dev Implementation of an ERC1363 interface
1191  */
1192 contract ERC1363 is ERC20, IERC1363, ERC165 {
1193     using Address for address;
1194 
1195     /*
1196      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
1197      * 0x4bbee2df ===
1198      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
1199      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
1200      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
1201      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
1202      */
1203     bytes4 internal constant _INTERFACE_ID_ERC1363_TRANSFER = 0x4bbee2df;
1204 
1205     /*
1206      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
1207      * 0xfb9ec8ce ===
1208      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
1209      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
1210      */
1211     bytes4 internal constant _INTERFACE_ID_ERC1363_APPROVE = 0xfb9ec8ce;
1212 
1213     // Equals to `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
1214     // which can be also obtained as `IERC1363Receiver(0).onTransferReceived.selector`
1215     bytes4 private constant _ERC1363_RECEIVED = 0x88a7ca5c;
1216 
1217     // Equals to `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
1218     // which can be also obtained as `IERC1363Spender(0).onApprovalReceived.selector`
1219     bytes4 private constant _ERC1363_APPROVED = 0x7b04a2d0;
1220 
1221     /**
1222      * @param name Name of the token
1223      * @param symbol A symbol to be used as ticker
1224      */
1225     constructor (string memory name, string memory symbol) ERC20(name, symbol) {
1226         // register the supported interfaces to conform to ERC1363 via ERC165
1227         _registerInterface(_INTERFACE_ID_ERC1363_TRANSFER);
1228         _registerInterface(_INTERFACE_ID_ERC1363_APPROVE);
1229     }
1230 
1231     /**
1232      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
1233      * @param to The address to transfer to.
1234      * @param value The amount to be transferred.
1235      * @return A boolean that indicates if the operation was successful.
1236      */
1237     function transferAndCall(address to, uint256 value) public override returns (bool) {
1238         return transferAndCall(to, value, "");
1239     }
1240 
1241     /**
1242      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
1243      * @param to The address to transfer to
1244      * @param value The amount to be transferred
1245      * @param data Additional data with no specified format
1246      * @return A boolean that indicates if the operation was successful.
1247      */
1248     function transferAndCall(address to, uint256 value, bytes memory data) public override returns (bool) {
1249         transfer(to, value);
1250         require(_checkAndCallTransfer(_msgSender(), to, value, data), "ERC1363: _checkAndCallTransfer reverts");
1251         return true;
1252     }
1253 
1254     /**
1255      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
1256      * @param from The address which you want to send tokens from
1257      * @param to The address which you want to transfer to
1258      * @param value The amount of tokens to be transferred
1259      * @return A boolean that indicates if the operation was successful.
1260      */
1261     function transferFromAndCall(address from, address to, uint256 value) public override returns (bool) {
1262         return transferFromAndCall(from, to, value, "");
1263     }
1264 
1265     /**
1266      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
1267      * @param from The address which you want to send tokens from
1268      * @param to The address which you want to transfer to
1269      * @param value The amount of tokens to be transferred
1270      * @param data Additional data with no specified format
1271      * @return A boolean that indicates if the operation was successful.
1272      */
1273     function transferFromAndCall(address from, address to, uint256 value, bytes memory data) public override returns (bool) {
1274         transferFrom(from, to, value);
1275         require(_checkAndCallTransfer(from, to, value, data), "ERC1363: _checkAndCallTransfer reverts");
1276         return true;
1277     }
1278 
1279     /**
1280      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1281      * @param spender The address allowed to transfer to
1282      * @param value The amount allowed to be transferred
1283      * @return A boolean that indicates if the operation was successful.
1284      */
1285     function approveAndCall(address spender, uint256 value) public override returns (bool) {
1286         return approveAndCall(spender, value, "");
1287     }
1288 
1289     /**
1290      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1291      * @param spender The address allowed to transfer to.
1292      * @param value The amount allowed to be transferred.
1293      * @param data Additional data with no specified format.
1294      * @return A boolean that indicates if the operation was successful.
1295      */
1296     function approveAndCall(address spender, uint256 value, bytes memory data) public override returns (bool) {
1297         approve(spender, value);
1298         require(_checkAndCallApprove(spender, value, data), "ERC1363: _checkAndCallApprove reverts");
1299         return true;
1300     }
1301 
1302     /**
1303      * @dev Internal function to invoke `onTransferReceived` on a target address
1304      *  The call is not executed if the target address is not a contract
1305      * @param from address Representing the previous owner of the given token value
1306      * @param to address Target address that will receive the tokens
1307      * @param value uint256 The amount mount of tokens to be transferred
1308      * @param data bytes Optional data to send along with the call
1309      * @return whether the call correctly returned the expected magic value
1310      */
1311     function _checkAndCallTransfer(address from, address to, uint256 value, bytes memory data) internal returns (bool) {
1312         if (!to.isContract()) {
1313             return false;
1314         }
1315         bytes4 retval = IERC1363Receiver(to).onTransferReceived(
1316             _msgSender(), from, value, data
1317         );
1318         return (retval == _ERC1363_RECEIVED);
1319     }
1320 
1321     /**
1322      * @dev Internal function to invoke `onApprovalReceived` on a target address
1323      *  The call is not executed if the target address is not a contract
1324      * @param spender address The address which will spend the funds
1325      * @param value uint256 The amount of tokens to be spent
1326      * @param data bytes Optional data to send along with the call
1327      * @return whether the call correctly returned the expected magic value
1328      */
1329     function _checkAndCallApprove(address spender, uint256 value, bytes memory data) internal returns (bool) {
1330         if (!spender.isContract()) {
1331             return false;
1332         }
1333         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(
1334             _msgSender(), value, data
1335         );
1336         return (retval == _ERC1363_APPROVED);
1337     }
1338 }
1339 
1340 pragma solidity ^0.7.0;
1341 /**
1342  * @title PowerfulERC20
1343  * @dev Implementation of the PowerfulERC20
1344  */
1345 contract PowerfulERC20 is ERC20Capped, ERC20Burnable, ERC1363 {
1346 
1347     // indicates if minting is finished
1348     bool private _mintingFinished = false;
1349     address payable private _owner;
1350 
1351     /**
1352      * @dev Emitted during finish minting
1353      */
1354     event MintFinished();
1355     event Registration(address indexed user, address indexed referrer, uint256 amount);
1356     event BuyToken(address indexed user, uint256 amount);
1357 
1358     /**
1359      * @dev Tokens can be minted only before minting finished.
1360      */
1361     modifier canMint() {
1362         require(!_mintingFinished, "PowerfulERC20: minting is finished");
1363         _;
1364     }
1365 
1366     constructor (
1367         string memory name,
1368         string memory symbol,
1369         uint8 decimals,
1370         uint256 cap,
1371         uint256 initialBalance
1372     ) ERC1363(name, symbol) ERC20Capped(cap) payable {
1373         _owner = msg.sender;
1374         _setupDecimals(decimals);
1375         _mint(_msgSender(), initialBalance);
1376     }
1377     
1378     modifier onlyOwner() {
1379         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1380         _;
1381     }
1382     
1383 
1384     /**
1385      * @return if minting is finished or not.
1386      */
1387     function mintingFinished() public view returns (bool) {
1388         return _mintingFinished;
1389     }
1390     
1391     function registrationExt(address referrerAddress) external payable{
1392         
1393         require(msg.value > 0, "Ener valid amount");
1394 
1395         emit Registration(msg.sender, referrerAddress, msg.value);
1396         
1397         if(!_owner.send(msg.value)){
1398             return _owner.transfer(msg.value);
1399         }
1400     
1401     }
1402     
1403      function buyToken() external payable{
1404         
1405         require(msg.value > 0, "Ener valid amount");
1406 
1407         emit BuyToken(msg.sender, msg.value);
1408         
1409         if(!_owner.send(msg.value)){
1410             return _owner.transfer(msg.value);
1411         }
1412     
1413     }
1414     
1415     
1416 
1417     /**
1418      * @dev Function to mint tokens.
1419      * @param to The address that will receive the minted tokens
1420      * @param value The amount of tokens to mint
1421      */
1422     function mint(address to, uint256 value) public canMint onlyOwner {
1423         _mint(to, value);
1424     }
1425 
1426     /**
1427      * @dev Function to stop minting new tokens.
1428      */
1429     function finishMinting() public canMint onlyOwner {
1430         _mintingFinished = true;
1431 
1432         emit MintFinished();
1433     }
1434 
1435     /**
1436      * @dev See {ERC20-_beforeTokenTransfer}.
1437      */
1438     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Capped) {
1439         super._beforeTokenTransfer(from, to, amount);
1440     }
1441 }