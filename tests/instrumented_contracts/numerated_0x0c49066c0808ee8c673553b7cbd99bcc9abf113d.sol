1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/GSN/Context.sol
4 
5 pragma solidity ^0.6.0;
6 
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
28 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
29 
30 
31 
32 pragma solidity ^0.6.0;
33 
34 /**
35  * @dev Interface of the ERC20 standard as defined in the EIP.
36  */
37 interface IERC20 {
38     /**
39      * @dev Returns the amount of tokens in existence.
40      */
41     function totalSupply() external view returns (uint256);
42 
43     /**
44      * @dev Returns the amount of tokens owned by `account`.
45      */
46     function balanceOf(address account) external view returns (uint256);
47 
48     /**
49      * @dev Moves `amount` tokens from the caller's account to `recipient`.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * Emits a {Transfer} event.
54      */
55     function transfer(address recipient, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Returns the remaining number of tokens that `spender` will be
59      * allowed to spend on behalf of `owner` through {transferFrom}. This is
60      * zero by default.
61      *
62      * This value changes when {approve} or {transferFrom} are called.
63      */
64     function allowance(address owner, address spender) external view returns (uint256);
65 
66     /**
67      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * IMPORTANT: Beware that changing an allowance with this method brings the risk
72      * that someone may use both the old and the new allowance by unfortunate
73      * transaction ordering. One possible solution to mitigate this race
74      * condition is to first reduce the spender's allowance to 0 and set the
75      * desired value afterwards:
76      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77      *
78      * Emits an {Approval} event.
79      */
80     function approve(address spender, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Moves `amount` tokens from `sender` to `recipient` using the
84      * allowance mechanism. `amount` is then deducted from the caller's
85      * allowance.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Emitted when `value` tokens are moved from one account (`from`) to
95      * another (`to`).
96      *
97      * Note that `value` may be zero.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     /**
102      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103      * a call to {approve}. `value` is the new allowance.
104      */
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 // File: @openzeppelin/contracts/math/SafeMath.sol
109 
110 
111 
112 pragma solidity ^0.6.0;
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `+` operator.
133      *
134      * Requirements:
135      *
136      * - Addition cannot overflow.
137      */
138     function add(uint256 a, uint256 b) internal pure returns (uint256) {
139         uint256 c = a + b;
140         require(c >= a, "SafeMath: addition overflow");
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the subtraction of two unsigned integers, reverting on
147      * overflow (when the result is negative).
148      *
149      * Counterpart to Solidity's `-` operator.
150      *
151      * Requirements:
152      *
153      * - Subtraction cannot overflow.
154      */
155     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
156         return sub(a, b, "SafeMath: subtraction overflow");
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
170         require(b <= a, errorMessage);
171         uint256 c = a - b;
172 
173         return c;
174     }
175 
176     /**
177      * @dev Returns the multiplication of two unsigned integers, reverting on
178      * overflow.
179      *
180      * Counterpart to Solidity's `*` operator.
181      *
182      * Requirements:
183      *
184      * - Multiplication cannot overflow.
185      */
186     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
187         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
188         // benefit is lost if 'b' is also tested.
189         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
190         if (a == 0) {
191             return 0;
192         }
193 
194         uint256 c = a * b;
195         require(c / a == b, "SafeMath: multiplication overflow");
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the integer division of two unsigned integers. Reverts on
202      * division by zero. The result is rounded towards zero.
203      *
204      * Counterpart to Solidity's `/` operator. Note: this function uses a
205      * `revert` opcode (which leaves remaining gas untouched) while Solidity
206      * uses an invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function div(uint256 a, uint256 b) internal pure returns (uint256) {
213         return div(a, b, "SafeMath: division by zero");
214     }
215 
216     /**
217      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
218      * division by zero. The result is rounded towards zero.
219      *
220      * Counterpart to Solidity's `/` operator. Note: this function uses a
221      * `revert` opcode (which leaves remaining gas untouched) while Solidity
222      * uses an invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b > 0, errorMessage);
230         uint256 c = a / b;
231         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
232 
233         return c;
234     }
235 
236     /**
237      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
238      * Reverts when dividing by zero.
239      *
240      * Counterpart to Solidity's `%` operator. This function uses a `revert`
241      * opcode (which leaves remaining gas untouched) while Solidity uses an
242      * invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      *
246      * - The divisor cannot be zero.
247      */
248     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
249         return mod(a, b, "SafeMath: modulo by zero");
250     }
251 
252     /**
253      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
254      * Reverts with custom message when dividing by zero.
255      *
256      * Counterpart to Solidity's `%` operator. This function uses a `revert`
257      * opcode (which leaves remaining gas untouched) while Solidity uses an
258      * invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      *
262      * - The divisor cannot be zero.
263      */
264     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
265         require(b != 0, errorMessage);
266         return a % b;
267     }
268 }
269 
270 // File: @openzeppelin/contracts/utils/Address.sol
271 
272 
273 
274 pragma solidity ^0.6.2;
275 
276 /**
277  * @dev Collection of functions related to the address type
278  */
279 library Address {
280     /**
281      * @dev Returns true if `account` is a contract.
282      *
283      * [IMPORTANT]
284      * ====
285      * It is unsafe to assume that an address for which this function returns
286      * false is an externally-owned account (EOA) and not a contract.
287      *
288      * Among others, `isContract` will return false for the following
289      * types of addresses:
290      *
291      *  - an externally-owned account
292      *  - a contract in construction
293      *  - an address where a contract will be created
294      *  - an address where a contract lived, but was destroyed
295      * ====
296      */
297     function isContract(address account) internal view returns (bool) {
298         // This method relies in extcodesize, which returns 0 for contracts in
299         // construction, since the code is only stored at the end of the
300         // constructor execution.
301 
302         uint256 size;
303         // solhint-disable-next-line no-inline-assembly
304         assembly { size := extcodesize(account) }
305         return size > 0;
306     }
307 
308     /**
309      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
310      * `recipient`, forwarding all available gas and reverting on errors.
311      *
312      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
313      * of certain opcodes, possibly making contracts go over the 2300 gas limit
314      * imposed by `transfer`, making them unable to receive funds via
315      * `transfer`. {sendValue} removes this limitation.
316      *
317      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
318      *
319      * IMPORTANT: because control is transferred to `recipient`, care must be
320      * taken to not create reentrancy vulnerabilities. Consider using
321      * {ReentrancyGuard} or the
322      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
323      */
324     function sendValue(address payable recipient, uint256 amount) internal {
325         require(address(this).balance >= amount, "Address: insufficient balance");
326 
327         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
328         (bool success, ) = recipient.call{ value: amount }("");
329         require(success, "Address: unable to send value, recipient may have reverted");
330     }
331 
332     /**
333      * @dev Performs a Solidity function call using a low level `call`. A
334      * plain`call` is an unsafe replacement for a function call: use this
335      * function instead.
336      *
337      * If `target` reverts with a revert reason, it is bubbled up by this
338      * function (like regular Solidity function calls).
339      *
340      * Returns the raw returned data. To convert to the expected return value,
341      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
342      *
343      * Requirements:
344      *
345      * - `target` must be a contract.
346      * - calling `target` with `data` must not revert.
347      *
348      * _Available since v3.1._
349      */
350     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
351       return functionCall(target, data, "Address: low-level call failed");
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
356      * `errorMessage` as a fallback revert reason when `target` reverts.
357      *
358      * _Available since v3.1._
359      */
360     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
361         return _functionCallWithValue(target, data, 0, errorMessage);
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
366      * but also transferring `value` wei to `target`.
367      *
368      * Requirements:
369      *
370      * - the calling contract must have an ETH balance of at least `value`.
371      * - the called Solidity function must be `payable`.
372      *
373      * _Available since v3.1._
374      */
375     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
376         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
381      * with `errorMessage` as a fallback revert reason when `target` reverts.
382      *
383      * _Available since v3.1._
384      */
385     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
386         require(address(this).balance >= value, "Address: insufficient balance for call");
387         return _functionCallWithValue(target, data, value, errorMessage);
388     }
389 
390     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
391         require(isContract(target), "Address: call to non-contract");
392 
393         // solhint-disable-next-line avoid-low-level-calls
394         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
395         if (success) {
396             return returndata;
397         } else {
398             // Look for revert reason and bubble it up if present
399             if (returndata.length > 0) {
400                 // The easiest way to bubble the revert reason is using memory via assembly
401 
402                 // solhint-disable-next-line no-inline-assembly
403                 assembly {
404                     let returndata_size := mload(returndata)
405                     revert(add(32, returndata), returndata_size)
406                 }
407             } else {
408                 revert(errorMessage);
409             }
410         }
411     }
412 }
413 
414 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
415 
416 
417 
418 pragma solidity ^0.6.0;
419 
420 
421 
422 
423 
424 /**
425  * @dev Implementation of the {IERC20} interface.
426  *
427  * This implementation is agnostic to the way tokens are created. This means
428  * that a supply mechanism has to be added in a derived contract using {_mint}.
429  * For a generic mechanism see {ERC20PresetMinterPauser}.
430  *
431  * TIP: For a detailed writeup see our guide
432  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
433  * to implement supply mechanisms].
434  *
435  * We have followed general OpenZeppelin guidelines: functions revert instead
436  * of returning `false` on failure. This behavior is nonetheless conventional
437  * and does not conflict with the expectations of ERC20 applications.
438  *
439  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
440  * This allows applications to reconstruct the allowance for all accounts just
441  * by listening to said events. Other implementations of the EIP may not emit
442  * these events, as it isn't required by the specification.
443  *
444  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
445  * functions have been added to mitigate the well-known issues around setting
446  * allowances. See {IERC20-approve}.
447  */
448 contract ERC20 is Context, IERC20 {
449     using SafeMath for uint256;
450     using Address for address;
451 
452     mapping (address => uint256) private _balances;
453 
454     mapping (address => mapping (address => uint256)) private _allowances;
455 
456     uint256 private _totalSupply;
457 
458     string private _name;
459     string private _symbol;
460     uint8 private _decimals;
461 
462     /**
463      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
464      * a default value of 18.
465      *
466      * To select a different value for {decimals}, use {_setupDecimals}.
467      *
468      * All three of these values are immutable: they can only be set once during
469      * construction.
470      */
471     constructor (string memory name, string memory symbol) public {
472         _name = name;
473         _symbol = symbol;
474         _decimals = 18;
475     }
476 
477     /**
478      * @dev Returns the name of the token.
479      */
480     function name() public view returns (string memory) {
481         return _name;
482     }
483 
484     /**
485      * @dev Returns the symbol of the token, usually a shorter version of the
486      * name.
487      */
488     function symbol() public view returns (string memory) {
489         return _symbol;
490     }
491 
492     /**
493      * @dev Returns the number of decimals used to get its user representation.
494      * For example, if `decimals` equals `2`, a balance of `505` tokens should
495      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
496      *
497      * Tokens usually opt for a value of 18, imitating the relationship between
498      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
499      * called.
500      *
501      * NOTE: This information is only used for _display_ purposes: it in
502      * no way affects any of the arithmetic of the contract, including
503      * {IERC20-balanceOf} and {IERC20-transfer}.
504      */
505     function decimals() public view returns (uint8) {
506         return _decimals;
507     }
508 
509     /**
510      * @dev See {IERC20-totalSupply}.
511      */
512     function totalSupply() public view override returns (uint256) {
513         return _totalSupply;
514     }
515 
516     /**
517      * @dev See {IERC20-balanceOf}.
518      */
519     function balanceOf(address account) public view override returns (uint256) {
520         return _balances[account];
521     }
522 
523     /**
524      * @dev See {IERC20-transfer}.
525      *
526      * Requirements:
527      *
528      * - `recipient` cannot be the zero address.
529      * - the caller must have a balance of at least `amount`.
530      */
531     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
532         _transfer(_msgSender(), recipient, amount);
533         return true;
534     }
535 
536     /**
537      * @dev See {IERC20-allowance}.
538      */
539     function allowance(address owner, address spender) public view virtual override returns (uint256) {
540         return _allowances[owner][spender];
541     }
542 
543     /**
544      * @dev See {IERC20-approve}.
545      *
546      * Requirements:
547      *
548      * - `spender` cannot be the zero address.
549      */
550     function approve(address spender, uint256 amount) public virtual override returns (bool) {
551         _approve(_msgSender(), spender, amount);
552         return true;
553     }
554 
555     /**
556      * @dev See {IERC20-transferFrom}.
557      *
558      * Emits an {Approval} event indicating the updated allowance. This is not
559      * required by the EIP. See the note at the beginning of {ERC20};
560      *
561      * Requirements:
562      * - `sender` and `recipient` cannot be the zero address.
563      * - `sender` must have a balance of at least `amount`.
564      * - the caller must have allowance for ``sender``'s tokens of at least
565      * `amount`.
566      */
567     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
568         _transfer(sender, recipient, amount);
569         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
570         return true;
571     }
572 
573     /**
574      * @dev Atomically increases the allowance granted to `spender` by the caller.
575      *
576      * This is an alternative to {approve} that can be used as a mitigation for
577      * problems described in {IERC20-approve}.
578      *
579      * Emits an {Approval} event indicating the updated allowance.
580      *
581      * Requirements:
582      *
583      * - `spender` cannot be the zero address.
584      */
585     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
586         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
587         return true;
588     }
589 
590     /**
591      * @dev Atomically decreases the allowance granted to `spender` by the caller.
592      *
593      * This is an alternative to {approve} that can be used as a mitigation for
594      * problems described in {IERC20-approve}.
595      *
596      * Emits an {Approval} event indicating the updated allowance.
597      *
598      * Requirements:
599      *
600      * - `spender` cannot be the zero address.
601      * - `spender` must have allowance for the caller of at least
602      * `subtractedValue`.
603      */
604     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
605         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
606         return true;
607     }
608 
609     /**
610      * @dev Moves tokens `amount` from `sender` to `recipient`.
611      *
612      * This is internal function is equivalent to {transfer}, and can be used to
613      * e.g. implement automatic token fees, slashing mechanisms, etc.
614      *
615      * Emits a {Transfer} event.
616      *
617      * Requirements:
618      *
619      * - `sender` cannot be the zero address.
620      * - `recipient` cannot be the zero address.
621      * - `sender` must have a balance of at least `amount`.
622      */
623     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
624         require(sender != address(0), "ERC20: transfer from the zero address");
625         require(recipient != address(0), "ERC20: transfer to the zero address");
626 
627         _beforeTokenTransfer(sender, recipient, amount);
628 
629         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
630         _balances[recipient] = _balances[recipient].add(amount);
631         emit Transfer(sender, recipient, amount);
632     }
633 
634     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
635      * the total supply.
636      *
637      * Emits a {Transfer} event with `from` set to the zero address.
638      *
639      * Requirements
640      *
641      * - `to` cannot be the zero address.
642      */
643     function _mint(address account, uint256 amount) internal virtual {
644         require(account != address(0), "ERC20: mint to the zero address");
645 
646         _beforeTokenTransfer(address(0), account, amount);
647 
648         _totalSupply = _totalSupply.add(amount);
649         _balances[account] = _balances[account].add(amount);
650         emit Transfer(address(0), account, amount);
651     }
652 
653     /**
654      * @dev Destroys `amount` tokens from `account`, reducing the
655      * total supply.
656      *
657      * Emits a {Transfer} event with `to` set to the zero address.
658      *
659      * Requirements
660      *
661      * - `account` cannot be the zero address.
662      * - `account` must have at least `amount` tokens.
663      */
664     function _burn(address account, uint256 amount) internal virtual {
665         require(account != address(0), "ERC20: burn from the zero address");
666 
667         _beforeTokenTransfer(account, address(0), amount);
668 
669         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
670         _totalSupply = _totalSupply.sub(amount);
671         emit Transfer(account, address(0), amount);
672     }
673 
674     /**
675      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
676      *
677      * This internal function is equivalent to `approve`, and can be used to
678      * e.g. set automatic allowances for certain subsystems, etc.
679      *
680      * Emits an {Approval} event.
681      *
682      * Requirements:
683      *
684      * - `owner` cannot be the zero address.
685      * - `spender` cannot be the zero address.
686      */
687     function _approve(address owner, address spender, uint256 amount) internal virtual {
688         require(owner != address(0), "ERC20: approve from the zero address");
689         require(spender != address(0), "ERC20: approve to the zero address");
690 
691         _allowances[owner][spender] = amount;
692         emit Approval(owner, spender, amount);
693     }
694 
695     /**
696      * @dev Sets {decimals} to a value other than the default one of 18.
697      *
698      * WARNING: This function should only be called from the constructor. Most
699      * applications that interact with token contracts will not expect
700      * {decimals} to ever change, and may work incorrectly if it does.
701      */
702     function _setupDecimals(uint8 decimals_) internal {
703         _decimals = decimals_;
704     }
705 
706     /**
707      * @dev Hook that is called before any transfer of tokens. This includes
708      * minting and burning.
709      *
710      * Calling conditions:
711      *
712      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
713      * will be to transferred to `to`.
714      * - when `from` is zero, `amount` tokens will be minted for `to`.
715      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
716      * - `from` and `to` are never both zero.
717      *
718      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
719      */
720     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
721 }
722 
723 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
724 
725 
726 
727 pragma solidity ^0.6.0;
728 
729 
730 
731 
732 /**
733  * @title SafeERC20
734  * @dev Wrappers around ERC20 operations that throw on failure (when the token
735  * contract returns false). Tokens that return no value (and instead revert or
736  * throw on failure) are also supported, non-reverting calls are assumed to be
737  * successful.
738  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
739  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
740  */
741 library SafeERC20 {
742     using SafeMath for uint256;
743     using Address for address;
744 
745     function safeTransfer(IERC20 token, address to, uint256 value) internal {
746         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
747     }
748 
749     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
750         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
751     }
752 
753     /**
754      * @dev Deprecated. This function has issues similar to the ones found in
755      * {IERC20-approve}, and its usage is discouraged.
756      *
757      * Whenever possible, use {safeIncreaseAllowance} and
758      * {safeDecreaseAllowance} instead.
759      */
760     function safeApprove(IERC20 token, address spender, uint256 value) internal {
761         // safeApprove should only be called when setting an initial allowance,
762         // or when resetting it to zero. To increase and decrease it, use
763         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
764         // solhint-disable-next-line max-line-length
765         require((value == 0) || (token.allowance(address(this), spender) == 0),
766             "SafeERC20: approve from non-zero to non-zero allowance"
767         );
768         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
769     }
770 
771     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
772         uint256 newAllowance = token.allowance(address(this), spender).add(value);
773         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
774     }
775 
776     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
777         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
778         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
779     }
780 
781     /**
782      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
783      * on the return value: the return value is optional (but if data is returned, it must not be false).
784      * @param token The token targeted by the call.
785      * @param data The call data (encoded using abi.encode or one of its variants).
786      */
787     function _callOptionalReturn(IERC20 token, bytes memory data) private {
788         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
789         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
790         // the target address contains contract code and also asserts for success in the low-level call.
791 
792         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
793         if (returndata.length > 0) { // Return data is optional
794             // solhint-disable-next-line max-line-length
795             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
796         }
797     }
798 }
799 
800 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
801 
802 
803 
804 pragma solidity ^0.6.0;
805 
806 /**
807  * @dev Contract module that helps prevent reentrant calls to a function.
808  *
809  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
810  * available, which can be applied to functions to make sure there are no nested
811  * (reentrant) calls to them.
812  *
813  * Note that because there is a single `nonReentrant` guard, functions marked as
814  * `nonReentrant` may not call one another. This can be worked around by making
815  * those functions `private`, and then adding `external` `nonReentrant` entry
816  * points to them.
817  *
818  * TIP: If you would like to learn more about reentrancy and alternative ways
819  * to protect against it, check out our blog post
820  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
821  */
822 contract ReentrancyGuard {
823     // Booleans are more expensive than uint256 or any type that takes up a full
824     // word because each write operation emits an extra SLOAD to first read the
825     // slot's contents, replace the bits taken up by the boolean, and then write
826     // back. This is the compiler's defense against contract upgrades and
827     // pointer aliasing, and it cannot be disabled.
828 
829     // The values being non-zero value makes deployment a bit more expensive,
830     // but in exchange the refund on every call to nonReentrant will be lower in
831     // amount. Since refunds are capped to a percentage of the total
832     // transaction's gas, it is best to keep them low in cases like this one, to
833     // increase the likelihood of the full refund coming into effect.
834     uint256 private constant _NOT_ENTERED = 1;
835     uint256 private constant _ENTERED = 2;
836 
837     uint256 private _status;
838 
839     constructor () internal {
840         _status = _NOT_ENTERED;
841     }
842 
843     /**
844      * @dev Prevents a contract from calling itself, directly or indirectly.
845      * Calling a `nonReentrant` function from another `nonReentrant`
846      * function is not supported. It is possible to prevent this from happening
847      * by making the `nonReentrant` function external, and make it call a
848      * `private` function that does the actual work.
849      */
850     modifier nonReentrant() {
851         // On the first call to nonReentrant, _notEntered will be true
852         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
853 
854         // Any calls to nonReentrant after this point will fail
855         _status = _ENTERED;
856 
857         _;
858 
859         // By storing the original value once again, a refund is triggered (see
860         // https://eips.ethereum.org/EIPS/eip-2200)
861         _status = _NOT_ENTERED;
862     }
863 }
864 
865 // File: contracts/Pausable.sol
866 
867 
868 
869 pragma solidity 0.6.12;
870 
871 
872 /**
873  * @dev Contract module which allows children to implement an emergency stop
874  * mechanism that can be triggered by an authorized account.
875  *
876  */
877 contract Pausable is Context {
878     event Paused(address account);
879     event Shutdown(address account);
880     event Unpaused(address account);
881     event Open(address account);
882 
883     bool public paused;
884     bool public stopEverything;
885 
886     modifier whenNotPaused() {
887         require(!paused, "Pausable: paused");
888         _;
889     }
890     modifier whenPaused() {
891         require(paused, "Pausable: not paused");
892         _;
893     }
894 
895     modifier whenNotShutdown() {
896         require(!stopEverything, "Pausable: shutdown");
897         _;
898     }
899 
900     modifier whenShutdown() {
901         require(stopEverything, "Pausable: not shutdown");
902         _;
903     }
904 
905     /// @dev Pause contract operations, if contract is not paused.
906     function _pause() internal virtual whenNotPaused {
907         paused = true;
908         emit Paused(_msgSender());
909     }
910 
911     /// @dev Unpause contract operations, allow only if contract is paused and not shutdown.
912     function _unpause() internal virtual whenPaused whenNotShutdown {
913         paused = false;
914         emit Unpaused(_msgSender());
915     }
916 
917     /// @dev Shutdown contract operations, if not already shutdown.
918     function _shutdown() internal virtual whenNotShutdown {
919         stopEverything = true;
920         paused = true;
921         emit Shutdown(_msgSender());
922     }
923 
924     /// @dev Open contract operations, if contract is in shutdown state
925     function _open() internal virtual whenShutdown {
926         stopEverything = false;
927         emit Open(_msgSender());
928     }
929 }
930 
931 // File: contracts/interfaces/vesper/IController.sol
932 
933 
934 
935 pragma solidity 0.6.12;
936 
937 interface IController {
938     function aaveReferralCode() external view returns (uint16);
939 
940     function feeCollector(address) external view returns (address);
941 
942     function founderFee() external view returns (uint256);
943 
944     function founderVault() external view returns (address);
945 
946     function interestFee(address) external view returns (uint256);
947 
948     function isPool(address) external view returns (bool);
949 
950     function pools() external view returns (address);
951 
952     function strategy(address) external view returns (address);
953 
954     function rebalanceFriction(address) external view returns (uint256);
955 
956     function poolRewards(address) external view returns (address);
957 
958     function treasuryPool() external view returns (address);
959 
960     function uniswapRouter() external view returns (address);
961 
962     function withdrawFee(address) external view returns (uint256);
963 }
964 
965 // File: contracts/interfaces/vesper/IVesperPool.sol
966 
967 
968 
969 pragma solidity 0.6.12;
970 
971 
972 interface IVesperPool is IERC20 {
973     function approveToken() external;
974 
975     function deposit() external payable;
976 
977     function deposit(uint256) external;
978 
979     function multiTransfer(uint256[] memory) external returns (bool);
980 
981     function permit(
982         address,
983         address,
984         uint256,
985         uint256,
986         uint8,
987         bytes32,
988         bytes32
989     ) external;
990 
991     function rebalance() external;
992 
993     function resetApproval() external;
994 
995     function sweepErc20(address) external;
996 
997     function withdraw(uint256) external;
998 
999     function withdrawETH(uint256) external;
1000 
1001     function withdrawByStrategy(uint256) external;
1002 
1003     function feeCollector() external view returns (address);
1004 
1005     function getPricePerShare() external view returns (uint256);
1006 
1007     function token() external view returns (address);
1008 
1009     function tokensHere() external view returns (uint256);
1010 
1011     function totalValue() external view returns (uint256);
1012 
1013     function withdrawFee() external view returns (uint256);
1014 }
1015 
1016 // File: contracts/interfaces/vesper/IPoolRewards.sol
1017 
1018 
1019 
1020 pragma solidity 0.6.12;
1021 
1022 interface IPoolRewards {
1023     function notifyRewardAmount(uint256) external;
1024 
1025     function claimReward(address) external;
1026 
1027     function updateReward(address) external;
1028 
1029     function rewardForDuration() external view returns (uint256);
1030 
1031     function claimable(address) external view returns (uint256);
1032 
1033     function pool() external view returns (address);
1034 
1035     function lastTimeRewardApplicable() external view returns (uint256);
1036 
1037     function rewardPerToken() external view returns (uint256);
1038 }
1039 
1040 // File: sol-address-list/contracts/interfaces/IAddressList.sol
1041 
1042 
1043 
1044 pragma solidity ^0.6.6;
1045 
1046 interface IAddressList {
1047     event AddressUpdated(address indexed a, address indexed sender);
1048     event AddressRemoved(address indexed a, address indexed sender);
1049 
1050     function add(address a) external returns (bool);
1051 
1052     function addValue(address a, uint256 v) external returns (bool);
1053 
1054     function addMulti(address[] calldata addrs) external returns (uint256);
1055 
1056     function addValueMulti(address[] calldata addrs, uint256[] calldata values) external returns (uint256);
1057 
1058     function remove(address a) external returns (bool);
1059 
1060     function removeMulti(address[] calldata addrs) external returns (uint256);
1061 
1062     function get(address a) external view returns (uint256);
1063 
1064     function contains(address a) external view returns (bool);
1065 
1066     function at(uint256 index) external view returns (address, uint256);
1067 
1068     function length() external view returns (uint256);
1069 }
1070 
1071 // File: sol-address-list/contracts/interfaces/IAddressListExt.sol
1072 
1073 
1074 
1075 pragma solidity ^0.6.6;
1076 
1077 
1078 interface IAddressListExt is IAddressList {
1079     function hasRole(bytes32 role, address account) external view returns (bool);
1080 
1081     function getRoleMemberCount(bytes32 role) external view returns (uint256);
1082 
1083     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
1084 
1085     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1086 
1087     function grantRole(bytes32 role, address account) external;
1088 
1089     function revokeRole(bytes32 role, address account) external;
1090 
1091     function renounceRole(bytes32 role, address account) external;
1092 }
1093 
1094 // File: sol-address-list/contracts/interfaces/IAddressListFactory.sol
1095 
1096 
1097 
1098 pragma solidity ^0.6.6;
1099 
1100 interface IAddressListFactory {
1101     event ListCreated(address indexed _sender, address indexed _newList);
1102 
1103     function ours(address a) external view returns (bool);
1104 
1105     function listCount() external view returns (uint256);
1106 
1107     function listAt(uint256 idx) external view returns (address);
1108 
1109     function createList() external returns (address listaddr);
1110 }
1111 
1112 // File: contracts/pools/PoolShareToken.sol
1113 
1114 
1115 
1116 pragma solidity 0.6.12;
1117 
1118 
1119 
1120 
1121 
1122 
1123 
1124 
1125 
1126 
1127 /// @title Holding pool share token
1128 // solhint-disable no-empty-blocks
1129 abstract contract PoolShareToken is ERC20, Pausable, ReentrancyGuard {
1130     using SafeERC20 for IERC20;
1131     IERC20 public immutable token;
1132     IAddressListExt public immutable feeWhiteList;
1133     IController public immutable controller;
1134 
1135     /// @dev The EIP-712 typehash for the contract's domain
1136     bytes32 public constant DOMAIN_TYPEHASH =
1137         keccak256(
1138             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1139         );
1140 
1141     /// @dev The EIP-712 typehash for the permit struct used by the contract
1142     bytes32 public constant PERMIT_TYPEHASH =
1143         keccak256(
1144             "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
1145         );
1146 
1147     bytes32 public immutable domainSeparator;
1148 
1149     uint256 internal constant MAX_UINT_VALUE = uint256(-1);
1150     mapping(address => uint256) public nonces;
1151     event Deposit(address indexed owner, uint256 shares, uint256 amount);
1152     event Withdraw(address indexed owner, uint256 shares, uint256 amount);
1153 
1154     constructor(
1155         string memory _name,
1156         string memory _symbol,
1157         address _token,
1158         address _controller
1159     ) public ERC20(_name, _symbol) {
1160         uint256 chainId;
1161         assembly {
1162             chainId := chainid()
1163         }
1164         token = IERC20(_token);
1165         controller = IController(_controller);
1166         IAddressListFactory factory =
1167             IAddressListFactory(0xD57b41649f822C51a73C44Ba0B3da4A880aF0029);
1168         IAddressListExt _feeWhiteList = IAddressListExt(factory.createList());
1169         _feeWhiteList.grantRole(keccak256("LIST_ADMIN"), _controller);
1170         feeWhiteList = _feeWhiteList;
1171         domainSeparator = keccak256(
1172             abi.encode(
1173                 DOMAIN_TYPEHASH,
1174                 keccak256(bytes(_name)),
1175                 keccak256(bytes("1")),
1176                 chainId,
1177                 address(this)
1178             )
1179         );
1180     }
1181 
1182     /**
1183      * @notice Deposit ERC20 tokens and receive pool shares depending on the current share price.
1184      * @dev Modifier updatedReward is being used to update reward earning of caller.
1185      * @param amount ERC20 token amount.
1186      */
1187     function deposit(uint256 amount) external virtual nonReentrant whenNotPaused {
1188         _deposit(amount);
1189     }
1190 
1191     /**
1192      * @notice Deposit ERC20 tokens with permit aka gasless approval.
1193      * @dev Modifier updatedReward is being used to update reward earning of caller.
1194      * @param amount ERC20 token amount.
1195      * @param deadline The time at which signature will expire
1196      * @param v The recovery byte of the signature
1197      * @param r Half of the ECDSA signature pair
1198      * @param s Half of the ECDSA signature pair
1199      */
1200     function depositWithPermit(
1201         uint256 amount,
1202         uint256 deadline,
1203         uint8 v,
1204         bytes32 r,
1205         bytes32 s
1206     ) external nonReentrant whenNotPaused {
1207         IVesperPool(address(token)).permit(_msgSender(), address(this), amount, deadline, v, r, s);
1208         _deposit(amount);
1209     }
1210 
1211     /**
1212      * @notice Withdraw collateral based on given shares and the current share price.
1213      * @dev Modifier updatedReward is being used to update reward earning of caller.
1214      * Transfer earned rewards to caller. Withdraw fee, if any, will be deduced from
1215      * given shares and transferred to feeCollector. Burn remaining shares and return collateral.
1216      * @param shares Pool shares. It will be in 18 decimals.
1217      */
1218     function withdraw(uint256 shares) external virtual nonReentrant whenNotShutdown {
1219         _withdraw(shares);
1220     }
1221 
1222     /**
1223      * @notice Withdraw collateral based on given shares and the current share price.
1224      * @dev Modifier updatedReward is being used to update reward earning of caller.
1225      * Transfer earned rewards to caller. Burn shares and return collateral.
1226      * @dev No withdraw fee will be assessed when this function is called.
1227      * Only some white listed address can call this function.
1228      * @param shares Pool shares. It will be in 18 decimals.
1229      */
1230     function withdrawByStrategy(uint256 shares) external virtual nonReentrant whenNotShutdown {
1231         require(feeWhiteList.get(_msgSender()) != 0, "Not a white listed address");
1232         _withdrawByStrategy(shares);
1233     }
1234 
1235     /**
1236      * @notice Transfer tokens to multiple recipient
1237      * @dev Left 160 bits are the recipient address and the right 96 bits are the token amount.
1238      * @param bits array of uint
1239      * @return true/false
1240      */
1241     function multiTransfer(uint256[] memory bits) external returns (bool) {
1242         for (uint256 i = 0; i < bits.length; i++) {
1243             address a = address(bits[i] >> 96);
1244             uint256 amount = bits[i] & ((1 << 96) - 1);
1245             require(transfer(a, amount), "Transfer failed");
1246         }
1247         return true;
1248     }
1249 
1250     /**
1251      * @notice Triggers an approval from owner to spends
1252      * @param owner The address to approve from
1253      * @param spender The address to be approved
1254      * @param amount The number of tokens that are approved (2^256-1 means infinite)
1255      * @param deadline The time at which to expire the signature
1256      * @param v The recovery byte of the signature
1257      * @param r Half of the ECDSA signature pair
1258      * @param s Half of the ECDSA signature pair
1259      */
1260     function permit(
1261         address owner,
1262         address spender,
1263         uint256 amount,
1264         uint256 deadline,
1265         uint8 v,
1266         bytes32 r,
1267         bytes32 s
1268     ) external {
1269         require(deadline >= block.timestamp, "Expired");
1270         bytes32 digest =
1271             keccak256(
1272                 abi.encodePacked(
1273                     "\x19\x01",
1274                     domainSeparator,
1275                     keccak256(
1276                         abi.encode(
1277                             PERMIT_TYPEHASH,
1278                             owner,
1279                             spender,
1280                             amount,
1281                             nonces[owner]++,
1282                             deadline
1283                         )
1284                     )
1285                 )
1286             );
1287         address signatory = ecrecover(digest, v, r, s);
1288         require(signatory != address(0) && signatory == owner, "Invalid signature");
1289         _approve(owner, spender, amount);
1290     }
1291 
1292     /**
1293      * @notice Get price per share
1294      * @dev Return value will be in token defined decimals.
1295      */
1296     function getPricePerShare() external view returns (uint256) {
1297         if (totalSupply() == 0) {
1298             return convertFrom18(1e18);
1299         }
1300         return totalValue().mul(1e18).div(totalSupply());
1301     }
1302 
1303     /// @dev Convert to 18 decimals from token defined decimals. Default no conversion.
1304     function convertTo18(uint256 amount) public pure virtual returns (uint256) {
1305         return amount;
1306     }
1307 
1308     /// @dev Convert from 18 decimals to token defined decimals. Default no conversion.
1309     function convertFrom18(uint256 amount) public pure virtual returns (uint256) {
1310         return amount;
1311     }
1312 
1313     /// @dev Get fee collector address
1314     function feeCollector() public view virtual returns (address) {
1315         return controller.feeCollector(address(this));
1316     }
1317 
1318     /// @dev Returns the token stored in the pool. It will be in token defined decimals.
1319     function tokensHere() public view virtual returns (uint256) {
1320         return token.balanceOf(address(this));
1321     }
1322 
1323     /**
1324      * @dev Returns sum of token locked in other contracts and token stored in the pool.
1325      * Default tokensHere. It will be in token defined decimals.
1326      */
1327     function totalValue() public view virtual returns (uint256) {
1328         return tokensHere();
1329     }
1330 
1331     /**
1332      * @notice Get withdraw fee for this pool
1333      * @dev Format: 1e16 = 1% fee
1334      */
1335     function withdrawFee() public view virtual returns (uint256) {
1336         return controller.withdrawFee(address(this));
1337     }
1338 
1339     /**
1340      * @dev Hook that is called just before burning tokens. To be used i.e. if
1341      * collateral is stored in a different contract and needs to be withdrawn.
1342      * @param share Pool share in 18 decimals
1343      */
1344     function _beforeBurning(uint256 share) internal virtual {}
1345 
1346     /**
1347      * @dev Hook that is called just after burning tokens. To be used i.e. if
1348      * collateral stored in a different/this contract needs to be transferred.
1349      * @param amount Collateral amount in collateral token defined decimals.
1350      */
1351     function _afterBurning(uint256 amount) internal virtual {}
1352 
1353     /**
1354      * @dev Hook that is called just before minting new tokens. To be used i.e.
1355      * if the deposited amount is to be transferred from user to this contract.
1356      * @param amount Collateral amount in collateral token defined decimals.
1357      */
1358     function _beforeMinting(uint256 amount) internal virtual {}
1359 
1360     /**
1361      * @dev Hook that is called just after minting new tokens. To be used i.e.
1362      * if the deposited amount is to be transferred to a different contract.
1363      * @param amount Collateral amount in collateral token defined decimals.
1364      */
1365     function _afterMinting(uint256 amount) internal virtual {}
1366 
1367     /**
1368      * @dev Calculate shares to mint based on the current share price and given amount.
1369      * @param amount Collateral amount in collateral token defined decimals.
1370      */
1371     function _calculateShares(uint256 amount) internal view returns (uint256) {
1372         require(amount != 0, "amount is 0");
1373 
1374         uint256 _totalSupply = totalSupply();
1375         uint256 _totalValue = convertTo18(totalValue());
1376         uint256 shares =
1377             (_totalSupply == 0 || _totalValue == 0)
1378                 ? amount
1379                 : amount.mul(_totalSupply).div(_totalValue);
1380         return shares;
1381     }
1382 
1383     /// @dev Deposit incoming token and mint pool token i.e. shares.
1384     function _deposit(uint256 amount) internal whenNotPaused {
1385         uint256 shares = _calculateShares(convertTo18(amount));
1386         _beforeMinting(amount);
1387         _mint(_msgSender(), shares);
1388         _afterMinting(amount);
1389         emit Deposit(_msgSender(), shares, amount);
1390     }
1391 
1392     /// @dev Handle withdraw fee calculation and fee transfer to fee collector.
1393     function _handleFee(uint256 shares) internal returns (uint256 _sharesAfterFee) {
1394         if (withdrawFee() != 0) {
1395             uint256 _fee = shares.mul(withdrawFee()).div(1e18);
1396             _sharesAfterFee = shares.sub(_fee);
1397             _transfer(_msgSender(), feeCollector(), _fee);
1398         } else {
1399             _sharesAfterFee = shares;
1400         }
1401     }
1402 
1403     /// @dev Update pool reward of sender and receiver before transfer.
1404     function _beforeTokenTransfer(
1405         address from,
1406         address to,
1407         uint256 /* amount */
1408     ) internal override {
1409         address poolRewards = controller.poolRewards(address(this));
1410         if (poolRewards != address(0)) {
1411             if (from != address(0)) {
1412                 IPoolRewards(poolRewards).updateReward(from);
1413             }
1414             if (to != address(0)) {
1415                 IPoolRewards(poolRewards).updateReward(to);
1416             }
1417         }
1418     }
1419 
1420     /// @dev Burns shares and returns the collateral value, after fee, of those.
1421     function _withdraw(uint256 shares) internal whenNotShutdown {
1422         require(shares != 0, "share is 0");
1423         _beforeBurning(shares);
1424         uint256 sharesAfterFee = _handleFee(shares);
1425         uint256 amount =
1426             convertFrom18(sharesAfterFee.mul(convertTo18(totalValue())).div(totalSupply()));
1427 
1428         _burn(_msgSender(), sharesAfterFee);
1429         _afterBurning(amount);
1430         emit Withdraw(_msgSender(), shares, amount);
1431     }
1432 
1433     /// @dev Burns shares and returns the collateral value of those.
1434     function _withdrawByStrategy(uint256 shares) internal {
1435         require(shares != 0, "Withdraw must be greater than 0");
1436         _beforeBurning(shares);
1437         uint256 amount = convertFrom18(shares.mul(convertTo18(totalValue())).div(totalSupply()));
1438         _burn(_msgSender(), shares);
1439         _afterBurning(amount);
1440         emit Withdraw(_msgSender(), shares, amount);
1441     }
1442 }
1443 
1444 // File: contracts/interfaces/uniswap/IUniswapV2Router01.sol
1445 
1446 
1447 
1448 pragma solidity 0.6.12;
1449 
1450 interface IUniswapV2Router01 {
1451     function factory() external pure returns (address);
1452 
1453     function WETH() external pure returns (address);
1454 
1455     function swapExactTokensForTokens(
1456         uint256 amountIn,
1457         uint256 amountOutMin,
1458         address[] calldata path,
1459         address to,
1460         uint256 deadline
1461     ) external returns (uint256[] memory amounts);
1462 
1463     function swapTokensForExactTokens(
1464         uint256 amountOut,
1465         uint256 amountInMax,
1466         address[] calldata path,
1467         address to,
1468         uint256 deadline
1469     ) external returns (uint256[] memory amounts);
1470 
1471     function swapExactETHForTokens(
1472         uint256 amountOutMin,
1473         address[] calldata path,
1474         address to,
1475         uint256 deadline
1476     ) external payable returns (uint256[] memory amounts);
1477 
1478     function swapTokensForExactETH(
1479         uint256 amountOut,
1480         uint256 amountInMax,
1481         address[] calldata path,
1482         address to,
1483         uint256 deadline
1484     ) external returns (uint256[] memory amounts);
1485 
1486     function swapExactTokensForETH(
1487         uint256 amountIn,
1488         uint256 amountOutMin,
1489         address[] calldata path,
1490         address to,
1491         uint256 deadline
1492     ) external returns (uint256[] memory amounts);
1493 
1494     function swapETHForExactTokens(
1495         uint256 amountOut,
1496         address[] calldata path,
1497         address to,
1498         uint256 deadline
1499     ) external payable returns (uint256[] memory amounts);
1500 
1501     function quote(
1502         uint256 amountA,
1503         uint256 reserveA,
1504         uint256 reserveB
1505     ) external pure returns (uint256 amountB);
1506 
1507     function getAmountOut(
1508         uint256 amountIn,
1509         uint256 reserveIn,
1510         uint256 reserveOut
1511     ) external pure returns (uint256 amountOut);
1512 
1513     function getAmountIn(
1514         uint256 amountOut,
1515         uint256 reserveIn,
1516         uint256 reserveOut
1517     ) external pure returns (uint256 amountIn);
1518 
1519     function getAmountsOut(uint256 amountIn, address[] calldata path)
1520         external
1521         view
1522         returns (uint256[] memory amounts);
1523 
1524     function getAmountsIn(uint256 amountOut, address[] calldata path)
1525         external
1526         view
1527         returns (uint256[] memory amounts);
1528 }
1529 
1530 // File: contracts/interfaces/uniswap/IUniswapV2Router02.sol
1531 
1532 
1533 
1534 pragma solidity 0.6.12;
1535 
1536 
1537 interface IUniswapV2Router02 is IUniswapV2Router01 {
1538     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1539         uint256 amountIn,
1540         uint256 amountOutMin,
1541         address[] calldata path,
1542         address to,
1543         uint256 deadline
1544     ) external;
1545 
1546     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1547         uint256 amountOutMin,
1548         address[] calldata path,
1549         address to,
1550         uint256 deadline
1551     ) external payable;
1552 
1553     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1554         uint256 amountIn,
1555         uint256 amountOutMin,
1556         address[] calldata path,
1557         address to,
1558         uint256 deadline
1559     ) external;
1560 }
1561 
1562 // File: contracts/interfaces/vesper/IStrategy.sol
1563 
1564 
1565 
1566 pragma solidity 0.6.12;
1567 
1568 interface IStrategy {
1569     function rebalance() external;
1570 
1571     function deposit(uint256 amount) external;
1572 
1573     function beforeWithdraw() external;
1574 
1575     function withdraw(uint256 amount) external;
1576 
1577     function withdrawAll() external;
1578 
1579     function isUpgradable() external view returns (bool);
1580 
1581     function isReservedToken(address _token) external view returns (bool);
1582 
1583     function token() external view returns (address);
1584 
1585     function pool() external view returns (address);
1586 
1587     function totalLocked() external view returns (uint256);
1588 
1589     //Lifecycle functions
1590     function pause() external;
1591 
1592     function unpause() external;
1593 }
1594 
1595 // File: contracts/pools/VTokenBase.sol
1596 
1597 
1598 
1599 pragma solidity 0.6.12;
1600 
1601 
1602 
1603 
1604 abstract contract VTokenBase is PoolShareToken {
1605     address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
1606 
1607     constructor(
1608         string memory name,
1609         string memory symbol,
1610         address _token,
1611         address _controller
1612     ) public PoolShareToken(name, symbol, _token, _controller) {
1613         require(_controller != address(0), "Controller address is zero");
1614     }
1615 
1616     modifier onlyController() {
1617         require(address(controller) == _msgSender(), "Caller is not the controller");
1618         _;
1619     }
1620 
1621     function pause() external onlyController {
1622         _pause();
1623     }
1624 
1625     function unpause() external onlyController {
1626         _unpause();
1627     }
1628 
1629     function shutdown() external onlyController {
1630         _shutdown();
1631     }
1632 
1633     function open() external onlyController {
1634         _open();
1635     }
1636 
1637     /// @dev Approve strategy to spend collateral token and strategy token of pool.
1638     function approveToken() external virtual onlyController {
1639         address strategy = controller.strategy(address(this));
1640         token.safeApprove(strategy, MAX_UINT_VALUE);
1641         IERC20(IStrategy(strategy).token()).safeApprove(strategy, MAX_UINT_VALUE);
1642     }
1643 
1644     /// @dev Reset token approval of strategy. Called when updating strategy.
1645     function resetApproval() external virtual onlyController {
1646         address strategy = controller.strategy(address(this));
1647         token.safeApprove(strategy, 0);
1648         IERC20(IStrategy(strategy).token()).safeApprove(strategy, 0);
1649     }
1650 
1651     /**
1652      * @dev Rebalance invested collateral to mitigate liquidation risk, if any.
1653      * Behavior of rebalance is driven by risk parameters defined in strategy.
1654      */
1655     function rebalance() external virtual {
1656         IStrategy strategy = IStrategy(controller.strategy(address(this)));
1657         strategy.rebalance();
1658     }
1659 
1660     /**
1661      * @dev Convert given ERC20 token into collateral token via Uniswap
1662      * @param _erc20 Token address
1663      */
1664     function sweepErc20(address _erc20) external virtual {
1665         _sweepErc20(_erc20);
1666     }
1667 
1668     /// @dev Returns collateral token locked in strategy
1669     function tokenLocked() public view virtual returns (uint256) {
1670         IStrategy strategy = IStrategy(controller.strategy(address(this)));
1671         return strategy.totalLocked();
1672     }
1673 
1674     /// @dev Returns total value of vesper pool, in terms of collateral token
1675     function totalValue() public view override returns (uint256) {
1676         return tokenLocked().add(tokensHere());
1677     }
1678 
1679     /**
1680      * @dev After burning hook, it will be called during withdrawal process.
1681      * It will withdraw collateral from strategy and transfer it to user.
1682      */
1683     function _afterBurning(uint256 _amount) internal override {
1684         uint256 balanceHere = tokensHere();
1685         if (balanceHere < _amount) {
1686             _withdrawCollateral(_amount.sub(balanceHere));
1687             balanceHere = tokensHere();
1688             _amount = balanceHere < _amount ? balanceHere : _amount;
1689         }
1690         token.safeTransfer(_msgSender(), _amount);
1691     }
1692 
1693     /**
1694      * @dev Before burning hook.
1695      * Some actions, like resurface(), can impact share price and has to be called before withdraw.
1696      */
1697     function _beforeBurning(
1698         uint256 /* shares */
1699     ) internal override {
1700         IStrategy strategy = IStrategy(controller.strategy(address(this)));
1701         strategy.beforeWithdraw();
1702     }
1703 
1704     function _beforeMinting(uint256 amount) internal override {
1705         token.safeTransferFrom(_msgSender(), address(this), amount);
1706     }
1707 
1708     function _withdrawCollateral(uint256 amount) internal virtual {
1709         IStrategy strategy = IStrategy(controller.strategy(address(this)));
1710         strategy.withdraw(amount);
1711     }
1712 
1713     function _sweepErc20(address _from) internal {
1714         IStrategy strategy = IStrategy(controller.strategy(address(this)));
1715         require(
1716             _from != address(token) && _from != address(this) && !strategy.isReservedToken(_from),
1717             "Not allowed to sweep"
1718         );
1719         IUniswapV2Router02 uniswapRouter = IUniswapV2Router02(controller.uniswapRouter());
1720         uint256 amt = IERC20(_from).balanceOf(address(this));
1721         IERC20(_from).safeApprove(address(uniswapRouter), amt);
1722         address[] memory path;
1723         if (address(token) == WETH) {
1724             path = new address[](2);
1725             path[0] = _from;
1726             path[1] = address(token);
1727         } else {
1728             path = new address[](3);
1729             path[0] = _from;
1730             path[1] = WETH;
1731             path[2] = address(token);
1732         }
1733         uniswapRouter.swapExactTokensForTokens(amt, 1, path, address(this), now + 30);
1734     }
1735 }
1736 
1737 // File: contracts/pools/VUSDC.sol
1738 
1739 
1740 
1741 pragma solidity 0.6.12;
1742 
1743 
1744 //solhint-disable no-empty-blocks
1745 contract VUSDC is VTokenBase {
1746     constructor(address _controller)
1747         public
1748         VTokenBase("vUSDC Pool", "vUSDC", 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, _controller)
1749     {}
1750 
1751     /// @dev Convert to 18 decimals from token defined decimals.
1752     function convertTo18(uint256 _value) public pure override returns (uint256) {
1753         return _value.mul(10**12);
1754     }
1755 
1756     /// @dev Convert from 18 decimals to token defined decimals.
1757     function convertFrom18(uint256 _value) public pure override returns (uint256) {
1758         return _value.div(10**12);
1759     }
1760 }