1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT
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
723 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
724 
725 
726 
727 pragma solidity ^0.6.0;
728 
729 /**
730  * @dev Library for managing
731  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
732  * types.
733  *
734  * Sets have the following properties:
735  *
736  * - Elements are added, removed, and checked for existence in constant time
737  * (O(1)).
738  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
739  *
740  * ```
741  * contract Example {
742  *     // Add the library methods
743  *     using EnumerableSet for EnumerableSet.AddressSet;
744  *
745  *     // Declare a set state variable
746  *     EnumerableSet.AddressSet private mySet;
747  * }
748  * ```
749  *
750  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
751  * (`UintSet`) are supported.
752  */
753 library EnumerableSet {
754     // To implement this library for multiple types with as little code
755     // repetition as possible, we write it in terms of a generic Set type with
756     // bytes32 values.
757     // The Set implementation uses private functions, and user-facing
758     // implementations (such as AddressSet) are just wrappers around the
759     // underlying Set.
760     // This means that we can only create new EnumerableSets for types that fit
761     // in bytes32.
762 
763     struct Set {
764         // Storage of set values
765         bytes32[] _values;
766 
767         // Position of the value in the `values` array, plus 1 because index 0
768         // means a value is not in the set.
769         mapping (bytes32 => uint256) _indexes;
770     }
771 
772     /**
773      * @dev Add a value to a set. O(1).
774      *
775      * Returns true if the value was added to the set, that is if it was not
776      * already present.
777      */
778     function _add(Set storage set, bytes32 value) private returns (bool) {
779         if (!_contains(set, value)) {
780             set._values.push(value);
781             // The value is stored at length-1, but we add 1 to all indexes
782             // and use 0 as a sentinel value
783             set._indexes[value] = set._values.length;
784             return true;
785         } else {
786             return false;
787         }
788     }
789 
790     /**
791      * @dev Removes a value from a set. O(1).
792      *
793      * Returns true if the value was removed from the set, that is if it was
794      * present.
795      */
796     function _remove(Set storage set, bytes32 value) private returns (bool) {
797         // We read and store the value's index to prevent multiple reads from the same storage slot
798         uint256 valueIndex = set._indexes[value];
799 
800         if (valueIndex != 0) { // Equivalent to contains(set, value)
801             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
802             // the array, and then remove the last element (sometimes called as 'swap and pop').
803             // This modifies the order of the array, as noted in {at}.
804 
805             uint256 toDeleteIndex = valueIndex - 1;
806             uint256 lastIndex = set._values.length - 1;
807 
808             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
809             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
810 
811             bytes32 lastvalue = set._values[lastIndex];
812 
813             // Move the last value to the index where the value to delete is
814             set._values[toDeleteIndex] = lastvalue;
815             // Update the index for the moved value
816             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
817 
818             // Delete the slot where the moved value was stored
819             set._values.pop();
820 
821             // Delete the index for the deleted slot
822             delete set._indexes[value];
823 
824             return true;
825         } else {
826             return false;
827         }
828     }
829 
830     /**
831      * @dev Returns true if the value is in the set. O(1).
832      */
833     function _contains(Set storage set, bytes32 value) private view returns (bool) {
834         return set._indexes[value] != 0;
835     }
836 
837     /**
838      * @dev Returns the number of values on the set. O(1).
839      */
840     function _length(Set storage set) private view returns (uint256) {
841         return set._values.length;
842     }
843 
844    /**
845     * @dev Returns the value stored at position `index` in the set. O(1).
846     *
847     * Note that there are no guarantees on the ordering of values inside the
848     * array, and it may change when more values are added or removed.
849     *
850     * Requirements:
851     *
852     * - `index` must be strictly less than {length}.
853     */
854     function _at(Set storage set, uint256 index) private view returns (bytes32) {
855         require(set._values.length > index, "EnumerableSet: index out of bounds");
856         return set._values[index];
857     }
858 
859     // AddressSet
860 
861     struct AddressSet {
862         Set _inner;
863     }
864 
865     /**
866      * @dev Add a value to a set. O(1).
867      *
868      * Returns true if the value was added to the set, that is if it was not
869      * already present.
870      */
871     function add(AddressSet storage set, address value) internal returns (bool) {
872         return _add(set._inner, bytes32(uint256(value)));
873     }
874 
875     /**
876      * @dev Removes a value from a set. O(1).
877      *
878      * Returns true if the value was removed from the set, that is if it was
879      * present.
880      */
881     function remove(AddressSet storage set, address value) internal returns (bool) {
882         return _remove(set._inner, bytes32(uint256(value)));
883     }
884 
885     /**
886      * @dev Returns true if the value is in the set. O(1).
887      */
888     function contains(AddressSet storage set, address value) internal view returns (bool) {
889         return _contains(set._inner, bytes32(uint256(value)));
890     }
891 
892     /**
893      * @dev Returns the number of values in the set. O(1).
894      */
895     function length(AddressSet storage set) internal view returns (uint256) {
896         return _length(set._inner);
897     }
898 
899    /**
900     * @dev Returns the value stored at position `index` in the set. O(1).
901     *
902     * Note that there are no guarantees on the ordering of values inside the
903     * array, and it may change when more values are added or removed.
904     *
905     * Requirements:
906     *
907     * - `index` must be strictly less than {length}.
908     */
909     function at(AddressSet storage set, uint256 index) internal view returns (address) {
910         return address(uint256(_at(set._inner, index)));
911     }
912 
913 
914     // UintSet
915 
916     struct UintSet {
917         Set _inner;
918     }
919 
920     /**
921      * @dev Add a value to a set. O(1).
922      *
923      * Returns true if the value was added to the set, that is if it was not
924      * already present.
925      */
926     function add(UintSet storage set, uint256 value) internal returns (bool) {
927         return _add(set._inner, bytes32(value));
928     }
929 
930     /**
931      * @dev Removes a value from a set. O(1).
932      *
933      * Returns true if the value was removed from the set, that is if it was
934      * present.
935      */
936     function remove(UintSet storage set, uint256 value) internal returns (bool) {
937         return _remove(set._inner, bytes32(value));
938     }
939 
940     /**
941      * @dev Returns true if the value is in the set. O(1).
942      */
943     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
944         return _contains(set._inner, bytes32(value));
945     }
946 
947     /**
948      * @dev Returns the number of values on the set. O(1).
949      */
950     function length(UintSet storage set) internal view returns (uint256) {
951         return _length(set._inner);
952     }
953 
954    /**
955     * @dev Returns the value stored at position `index` in the set. O(1).
956     *
957     * Note that there are no guarantees on the ordering of values inside the
958     * array, and it may change when more values are added or removed.
959     *
960     * Requirements:
961     *
962     * - `index` must be strictly less than {length}.
963     */
964     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
965         return uint256(_at(set._inner, index));
966     }
967 }
968 
969 // File: @openzeppelin/contracts/access/AccessControl.sol
970 
971 
972 
973 pragma solidity ^0.6.0;
974 
975 
976 
977 
978 /**
979  * @dev Contract module that allows children to implement role-based access
980  * control mechanisms.
981  *
982  * Roles are referred to by their `bytes32` identifier. These should be exposed
983  * in the external API and be unique. The best way to achieve this is by
984  * using `public constant` hash digests:
985  *
986  * ```
987  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
988  * ```
989  *
990  * Roles can be used to represent a set of permissions. To restrict access to a
991  * function call, use {hasRole}:
992  *
993  * ```
994  * function foo() public {
995  *     require(hasRole(MY_ROLE, msg.sender));
996  *     ...
997  * }
998  * ```
999  *
1000  * Roles can be granted and revoked dynamically via the {grantRole} and
1001  * {revokeRole} functions. Each role has an associated admin role, and only
1002  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1003  *
1004  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1005  * that only accounts with this role will be able to grant or revoke other
1006  * roles. More complex role relationships can be created by using
1007  * {_setRoleAdmin}.
1008  *
1009  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1010  * grant and revoke this role. Extra precautions should be taken to secure
1011  * accounts that have been granted it.
1012  */
1013 abstract contract AccessControl is Context {
1014     using EnumerableSet for EnumerableSet.AddressSet;
1015     using Address for address;
1016 
1017     struct RoleData {
1018         EnumerableSet.AddressSet members;
1019         bytes32 adminRole;
1020     }
1021 
1022     mapping (bytes32 => RoleData) private _roles;
1023 
1024     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1025 
1026     /**
1027      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1028      *
1029      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1030      * {RoleAdminChanged} not being emitted signaling this.
1031      *
1032      * _Available since v3.1._
1033      */
1034     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1035 
1036     /**
1037      * @dev Emitted when `account` is granted `role`.
1038      *
1039      * `sender` is the account that originated the contract call, an admin role
1040      * bearer except when using {_setupRole}.
1041      */
1042     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1043 
1044     /**
1045      * @dev Emitted when `account` is revoked `role`.
1046      *
1047      * `sender` is the account that originated the contract call:
1048      *   - if using `revokeRole`, it is the admin role bearer
1049      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1050      */
1051     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1052 
1053     /**
1054      * @dev Returns `true` if `account` has been granted `role`.
1055      */
1056     function hasRole(bytes32 role, address account) public view returns (bool) {
1057         return _roles[role].members.contains(account);
1058     }
1059 
1060     /**
1061      * @dev Returns the number of accounts that have `role`. Can be used
1062      * together with {getRoleMember} to enumerate all bearers of a role.
1063      */
1064     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1065         return _roles[role].members.length();
1066     }
1067 
1068     /**
1069      * @dev Returns one of the accounts that have `role`. `index` must be a
1070      * value between 0 and {getRoleMemberCount}, non-inclusive.
1071      *
1072      * Role bearers are not sorted in any particular way, and their ordering may
1073      * change at any point.
1074      *
1075      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1076      * you perform all queries on the same block. See the following
1077      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1078      * for more information.
1079      */
1080     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1081         return _roles[role].members.at(index);
1082     }
1083 
1084     /**
1085      * @dev Returns the admin role that controls `role`. See {grantRole} and
1086      * {revokeRole}.
1087      *
1088      * To change a role's admin, use {_setRoleAdmin}.
1089      */
1090     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1091         return _roles[role].adminRole;
1092     }
1093 
1094     /**
1095      * @dev Grants `role` to `account`.
1096      *
1097      * If `account` had not been already granted `role`, emits a {RoleGranted}
1098      * event.
1099      *
1100      * Requirements:
1101      *
1102      * - the caller must have ``role``'s admin role.
1103      */
1104     function grantRole(bytes32 role, address account) public virtual {
1105         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1106 
1107         _grantRole(role, account);
1108     }
1109 
1110     /**
1111      * @dev Revokes `role` from `account`.
1112      *
1113      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1114      *
1115      * Requirements:
1116      *
1117      * - the caller must have ``role``'s admin role.
1118      */
1119     function revokeRole(bytes32 role, address account) public virtual {
1120         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1121 
1122         _revokeRole(role, account);
1123     }
1124 
1125     /**
1126      * @dev Revokes `role` from the calling account.
1127      *
1128      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1129      * purpose is to provide a mechanism for accounts to lose their privileges
1130      * if they are compromised (such as when a trusted device is misplaced).
1131      *
1132      * If the calling account had been granted `role`, emits a {RoleRevoked}
1133      * event.
1134      *
1135      * Requirements:
1136      *
1137      * - the caller must be `account`.
1138      */
1139     function renounceRole(bytes32 role, address account) public virtual {
1140         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1141 
1142         _revokeRole(role, account);
1143     }
1144 
1145     /**
1146      * @dev Grants `role` to `account`.
1147      *
1148      * If `account` had not been already granted `role`, emits a {RoleGranted}
1149      * event. Note that unlike {grantRole}, this function doesn't perform any
1150      * checks on the calling account.
1151      *
1152      * [WARNING]
1153      * ====
1154      * This function should only be called from the constructor when setting
1155      * up the initial roles for the system.
1156      *
1157      * Using this function in any other way is effectively circumventing the admin
1158      * system imposed by {AccessControl}.
1159      * ====
1160      */
1161     function _setupRole(bytes32 role, address account) internal virtual {
1162         _grantRole(role, account);
1163     }
1164 
1165     /**
1166      * @dev Sets `adminRole` as ``role``'s admin role.
1167      *
1168      * Emits a {RoleAdminChanged} event.
1169      */
1170     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1171         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1172         _roles[role].adminRole = adminRole;
1173     }
1174 
1175     function _grantRole(bytes32 role, address account) private {
1176         if (_roles[role].members.add(account)) {
1177             emit RoleGranted(role, account, _msgSender());
1178         }
1179     }
1180 
1181     function _revokeRole(bytes32 role, address account) private {
1182         if (_roles[role].members.remove(account)) {
1183             emit RoleRevoked(role, account, _msgSender());
1184         }
1185     }
1186 }
1187 
1188 // File: contracts/interfaces/IToken.sol
1189 
1190 
1191 
1192 pragma solidity ^0.6.0;
1193 
1194 interface IToken {
1195     function mint(address to, uint256 amount) external;
1196 
1197     function burn(address from, uint256 amount) external;
1198 }
1199 
1200 // File: contracts/Token.sol
1201 
1202 
1203 
1204 pragma solidity >=0.4.25 <0.7.0;
1205 
1206 
1207 
1208 
1209 
1210 contract Token is IToken, ERC20, AccessControl {
1211     using SafeMath for uint256;
1212 
1213     bytes32 private constant MINTER_ROLE = keccak256("MINTER_ROLE");
1214     bytes32 private constant SWAPPER_ROLE = keccak256("SWAPPER_ROLE");
1215     bytes32 private constant SETTER_ROLE = keccak256("SETTER_ROLE");
1216 
1217     IERC20 private swapToken;
1218     bool private swapIsOver;
1219     uint256 private swapTokenBalance;
1220 
1221     modifier onlyMinter() {
1222         require(hasRole(MINTER_ROLE, _msgSender()), "Caller is not a minter");
1223         _;
1224     }
1225 
1226     modifier onlySetter() {
1227         require(hasRole(SETTER_ROLE, _msgSender()), "Caller is not a setter");
1228         _;
1229     }
1230 
1231     modifier onlySwapper() {
1232         require(hasRole(SWAPPER_ROLE, _msgSender()), "Caller is not a swapper");
1233         _;
1234     }
1235 
1236     constructor(
1237         string memory _name,
1238         string memory _symbol,
1239         address _swapToken,
1240         address _swapper,
1241         address _setter
1242     ) public ERC20(_name, _symbol) {
1243         _setupRole(SWAPPER_ROLE, _swapper);
1244         _setupRole(SETTER_ROLE, _setter);
1245         swapToken = IERC20(_swapToken);
1246         swapIsOver = false;
1247     }
1248 
1249     function init(address[] calldata instances) external onlySetter {
1250         require(instances.length == 6, "NativeSwap: wrong instances number");
1251 
1252         for (uint256 index = 0; index < instances.length; index++) {
1253             _setupRole(MINTER_ROLE, instances[index]);
1254         }
1255         renounceRole(SETTER_ROLE, _msgSender());
1256         swapIsOver = true;
1257     }
1258 
1259     function getMinterRole() external pure returns (bytes32) {
1260         return MINTER_ROLE;
1261     }
1262 
1263     function getSwapperRole() external pure returns (bytes32) {
1264         return SWAPPER_ROLE;
1265     }
1266 
1267     function getSetterRole() external pure returns (bytes32) {
1268         return SETTER_ROLE;
1269     }
1270 
1271     function getSwapTOken() external view returns (IERC20) {
1272         return swapToken;
1273     }
1274 
1275     function getSwapTokenBalance(uint256) external view returns (uint256) {
1276         return swapTokenBalance;
1277     }
1278 
1279     function initDeposit(uint256 _amount) external onlySwapper {
1280         require(
1281             swapToken.transferFrom(_msgSender(), address(this), _amount),
1282             "Token: transferFrom error"
1283         );
1284         swapTokenBalance = swapTokenBalance.add(_amount);
1285     }
1286 
1287     function initWithdraw(uint256 _amount) external onlySwapper {
1288         require(_amount <= swapTokenBalance, "amount > balance");
1289         swapTokenBalance = swapTokenBalance.sub(_amount);
1290         swapToken.transfer(_msgSender(), _amount);
1291     }
1292 
1293     function initSwap() external onlySwapper {
1294         require(!swapIsOver, "swap is over");
1295         uint256 balance = swapTokenBalance;
1296         swapTokenBalance = 0;
1297         require(balance > 0, "balance <= 0");
1298         _mint(_msgSender(), balance);
1299     }
1300 
1301     function mint(address to, uint256 amount) external override onlyMinter {
1302         _mint(to, amount);
1303     }
1304 
1305     function burn(address from, uint256 amount) external override onlyMinter {
1306         _burn(from, amount);
1307     }
1308 
1309     // Helpers
1310     function getNow() external view returns (uint256) {
1311         return now;
1312     }
1313 }