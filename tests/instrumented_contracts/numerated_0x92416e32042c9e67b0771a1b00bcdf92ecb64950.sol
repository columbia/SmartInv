1 /*
2 
3 $BDOG
4 https://www.bulldogtoken.com/
5 
6 
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
38 // SPDX-License-Identifier: MIT
39 
40 pragma solidity ^0.6.0;
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
118 // SPDX-License-Identifier: MIT
119 
120 pragma solidity ^0.6.0;
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
280 // SPDX-License-Identifier: MIT
281 
282 pragma solidity ^0.6.2;
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
306         // This method relies in extcodesize, which returns 0 for contracts in
307         // construction, since the code is only stored at the end of the
308         // constructor execution.
309 
310         uint256 size;
311         // solhint-disable-next-line no-inline-assembly
312         assembly { size := extcodesize(account) }
313         return size > 0;
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
424 // SPDX-License-Identifier: MIT
425 
426 pragma solidity ^0.6.0;
427 
428 /**
429  * @dev Implementation of the {IERC20} interface.
430  *
431  * This implementation is agnostic to the way tokens are created. This means
432  * that a supply mechanism has to be added in a derived contract using {_mint}.
433  * For a generic mechanism see {ERC20PresetMinterPauser}.
434  *
435  * TIP: For a detailed writeup see our guide
436  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
437  * to implement supply mechanisms].
438  *
439  * We have followed general OpenZeppelin guidelines: functions revert instead
440  * of returning `false` on failure. This behavior is nonetheless conventional
441  * and does not conflict with the expectations of ERC20 applications.
442  *
443  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
444  * This allows applications to reconstruct the allowance for all accounts just
445  * by listening to said events. Other implementations of the EIP may not emit
446  * these events, as it isn't required by the specification.
447  *
448  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
449  * functions have been added to mitigate the well-known issues around setting
450  * allowances. See {IERC20-approve}.
451  */
452 contract ERC20 is Context, IERC20 {
453     using SafeMath for uint256;
454     using Address for address;
455 
456     mapping (address => uint256) private _balances;
457 
458     mapping (address => mapping (address => uint256)) private _allowances;
459 
460     uint256 private _totalSupply;
461 
462     string private _name;
463     string private _symbol;
464     uint8 private _decimals;
465 
466     /**
467      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
468      * a default value of 18.
469      *
470      * To select a different value for {decimals}, use {_setupDecimals}.
471      *
472      * All three of these values are immutable: they can only be set once during
473      * construction.
474      */
475     constructor (string memory name, string memory symbol) public {
476         _name = name;
477         _symbol = symbol;
478         _decimals = 18;
479     }
480 
481     /**
482      * @dev Returns the name of the token.
483      */
484     function name() public view returns (string memory) {
485         return _name;
486     }
487 
488     /**
489      * @dev Returns the symbol of the token, usually a shorter version of the
490      * name.
491      */
492     function symbol() public view returns (string memory) {
493         return _symbol;
494     }
495 
496     /**
497      * @dev Returns the number of decimals used to get its user representation.
498      * For example, if `decimals` equals `2`, a balance of `505` tokens should
499      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
500      *
501      * Tokens usually opt for a value of 18, imitating the relationship between
502      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
503      * called.
504      *
505      * NOTE: This information is only used for _display_ purposes: it in
506      * no way affects any of the arithmetic of the contract, including
507      * {IERC20-balanceOf} and {IERC20-transfer}.
508      */
509     function decimals() public view returns (uint8) {
510         return _decimals;
511     }
512 
513     /**
514      * @dev See {IERC20-totalSupply}.
515      */
516     function totalSupply() public view override returns (uint256) {
517         return _totalSupply;
518     }
519 
520     /**
521      * @dev See {IERC20-balanceOf}.
522      */
523     function balanceOf(address account) public view override returns (uint256) {
524         return _balances[account];
525     }
526 
527     /**
528      * @dev See {IERC20-transfer}.
529      *
530      * Requirements:
531      *
532      * - `recipient` cannot be the zero address.
533      * - the caller must have a balance of at least `amount`.
534      */
535     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
536         _transfer(_msgSender(), recipient, amount);
537         return true;
538     }
539 
540     /**
541      * @dev See {IERC20-allowance}.
542      */
543     function allowance(address owner, address spender) public view virtual override returns (uint256) {
544         return _allowances[owner][spender];
545     }
546 
547     /**
548      * @dev See {IERC20-approve}.
549      *
550      * Requirements:
551      *
552      * - `spender` cannot be the zero address.
553      */
554     function approve(address spender, uint256 amount) public virtual override returns (bool) {
555         _approve(_msgSender(), spender, amount);
556         return true;
557     }
558 
559     /**
560      * @dev See {IERC20-transferFrom}.
561      *
562      * Emits an {Approval} event indicating the updated allowance. This is not
563      * required by the EIP. See the note at the beginning of {ERC20};
564      *
565      * Requirements:
566      * - `sender` and `recipient` cannot be the zero address.
567      * - `sender` must have a balance of at least `amount`.
568      * - the caller must have allowance for ``sender``'s tokens of at least
569      * `amount`.
570      */
571     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
572         _transfer(sender, recipient, amount);
573         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
574         return true;
575     }
576 
577     /**
578      * @dev Atomically increases the allowance granted to `spender` by the caller.
579      *
580      * This is an alternative to {approve} that can be used as a mitigation for
581      * problems described in {IERC20-approve}.
582      *
583      * Emits an {Approval} event indicating the updated allowance.
584      *
585      * Requirements:
586      *
587      * - `spender` cannot be the zero address.
588      */
589     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
590         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
591         return true;
592     }
593 
594     /**
595      * @dev Atomically decreases the allowance granted to `spender` by the caller.
596      *
597      * This is an alternative to {approve} that can be used as a mitigation for
598      * problems described in {IERC20-approve}.
599      *
600      * Emits an {Approval} event indicating the updated allowance.
601      *
602      * Requirements:
603      *
604      * - `spender` cannot be the zero address.
605      * - `spender` must have allowance for the caller of at least
606      * `subtractedValue`.
607      */
608     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
609         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
610         return true;
611     }
612 
613     /**
614      * @dev Moves tokens `amount` from `sender` to `recipient`.
615      *
616      * This is internal function is equivalent to {transfer}, and can be used to
617      * e.g. implement automatic token fees, slashing mechanisms, etc.
618      *
619      * Emits a {Transfer} event.
620      *
621      * Requirements:
622      *
623      * - `sender` cannot be the zero address.
624      * - `recipient` cannot be the zero address.
625      * - `sender` must have a balance of at least `amount`.
626      */
627     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
628         require(sender != address(0), "ERC20: transfer from the zero address");
629         require(recipient != address(0), "ERC20: transfer to the zero address");
630 
631         _beforeTokenTransfer(sender, recipient, amount);
632 
633         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
634         _balances[recipient] = _balances[recipient].add(amount);
635         emit Transfer(sender, recipient, amount);
636     }
637 
638     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
639      * the total supply.
640      *
641      * Emits a {Transfer} event with `from` set to the zero address.
642      *
643      * Requirements
644      *
645      * - `to` cannot be the zero address.
646      */
647     function _mint(address account, uint256 amount) internal virtual {
648         require(account != address(0), "ERC20: mint to the zero address");
649 
650         _beforeTokenTransfer(address(0), account, amount);
651 
652         _totalSupply = _totalSupply.add(amount);
653         _balances[account] = _balances[account].add(amount);
654         emit Transfer(address(0), account, amount);
655     }
656 
657     /**
658      * @dev Destroys `amount` tokens from `account`, reducing the
659      * total supply.
660      *
661      * Emits a {Transfer} event with `to` set to the zero address.
662      *
663      * Requirements
664      *
665      * - `account` cannot be the zero address.
666      * - `account` must have at least `amount` tokens.
667      */
668     function _burn(address account, uint256 amount) internal virtual {
669         require(account != address(0), "ERC20: burn from the zero address");
670 
671         _beforeTokenTransfer(account, address(0), amount);
672 
673         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
674         _totalSupply = _totalSupply.sub(amount);
675         emit Transfer(account, address(0), amount);
676     }
677 
678     /**
679      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
680      *
681      * This internal function is equivalent to `approve`, and can be used to
682      * e.g. set automatic allowances for certain subsystems, etc.
683      *
684      * Emits an {Approval} event.
685      *
686      * Requirements:
687      *
688      * - `owner` cannot be the zero address.
689      * - `spender` cannot be the zero address.
690      */
691     function _approve(address owner, address spender, uint256 amount) internal virtual {
692         require(owner != address(0), "ERC20: approve from the zero address");
693         require(spender != address(0), "ERC20: approve to the zero address");
694 
695         _allowances[owner][spender] = amount;
696         emit Approval(owner, spender, amount);
697     }
698 
699     /**
700      * @dev Sets {decimals} to a value other than the default one of 18.
701      *
702      * WARNING: This function should only be called from the constructor. Most
703      * applications that interact with token contracts will not expect
704      * {decimals} to ever change, and may work incorrectly if it does.
705      */
706     function _setupDecimals(uint8 decimals_) internal {
707         _decimals = decimals_;
708     }
709 
710     /**
711      * @dev Hook that is called before any transfer of tokens. This includes
712      * minting and burning.
713      *
714      * Calling conditions:
715      *
716      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
717      * will be to transferred to `to`.
718      * - when `from` is zero, `amount` tokens will be minted for `to`.
719      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
720      * - `from` and `to` are never both zero.
721      *
722      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
723      */
724     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
725 }
726 
727 pragma solidity ^0.6.2;
728 
729 contract BullDog is ERC20("BULLDOG", "BDOG") {
730   constructor() public {
731         _mint(0x336e1c90b1604811D9673D487876A891E3220464, 100000000000000000000000000);
732   }
733 }