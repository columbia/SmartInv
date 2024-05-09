1 // File: ..\..\..\node_modules\@openzeppelin\contracts\GSN\Context.sol
2 
3 // SPDX-License-Identifier: MIT AND UNLICENSED
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
28 // File: ..\..\..\node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
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
108 // File: ..\..\..\node_modules\@openzeppelin\contracts\math\SafeMath.sol
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
270 // File: ..\..\..\node_modules\@openzeppelin\contracts\utils\Address.sol
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
414 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
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
723 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
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
800 
801 
802 // File: @openzeppelin\contracts\utils\EnumerableSet.sol
803 
804 
805 
806 pragma solidity ^0.6.0;
807 
808 /**
809  * @dev Library for managing
810  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
811  * types.
812  *
813  * Sets have the following properties:
814  *
815  * - Elements are added, removed, and checked for existence in constant time
816  * (O(1)).
817  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
818  *
819  * ```
820  * contract Example {
821  *     // Add the library methods
822  *     using EnumerableSet for EnumerableSet.AddressSet;
823  *
824  *     // Declare a set state variable
825  *     EnumerableSet.AddressSet private mySet;
826  * }
827  * ```
828  *
829  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
830  * (`UintSet`) are supported.
831  */
832 library EnumerableSet {
833     // To implement this library for multiple types with as little code
834     // repetition as possible, we write it in terms of a generic Set type with
835     // bytes32 values.
836     // The Set implementation uses private functions, and user-facing
837     // implementations (such as AddressSet) are just wrappers around the
838     // underlying Set.
839     // This means that we can only create new EnumerableSets for types that fit
840     // in bytes32.
841 
842     struct Set {
843         // Storage of set values
844         bytes32[] _values;
845 
846         // Position of the value in the `values` array, plus 1 because index 0
847         // means a value is not in the set.
848         mapping (bytes32 => uint256) _indexes;
849     }
850 
851     /**
852      * @dev Add a value to a set. O(1).
853      *
854      * Returns true if the value was added to the set, that is if it was not
855      * already present.
856      */
857     function _add(Set storage set, bytes32 value) private returns (bool) {
858         if (!_contains(set, value)) {
859             set._values.push(value);
860             // The value is stored at length-1, but we add 1 to all indexes
861             // and use 0 as a sentinel value
862             set._indexes[value] = set._values.length;
863             return true;
864         } else {
865             return false;
866         }
867     }
868 
869     /**
870      * @dev Removes a value from a set. O(1).
871      *
872      * Returns true if the value was removed from the set, that is if it was
873      * present.
874      */
875     function _remove(Set storage set, bytes32 value) private returns (bool) {
876         // We read and store the value's index to prevent multiple reads from the same storage slot
877         uint256 valueIndex = set._indexes[value];
878 
879         if (valueIndex != 0) { // Equivalent to contains(set, value)
880             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
881             // the array, and then remove the last element (sometimes called as 'swap and pop').
882             // This modifies the order of the array, as noted in {at}.
883 
884             uint256 toDeleteIndex = valueIndex - 1;
885             uint256 lastIndex = set._values.length - 1;
886 
887             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
888             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
889 
890             bytes32 lastvalue = set._values[lastIndex];
891 
892             // Move the last value to the index where the value to delete is
893             set._values[toDeleteIndex] = lastvalue;
894             // Update the index for the moved value
895             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
896 
897             // Delete the slot where the moved value was stored
898             set._values.pop();
899 
900             // Delete the index for the deleted slot
901             delete set._indexes[value];
902 
903             return true;
904         } else {
905             return false;
906         }
907     }
908 
909     /**
910      * @dev Returns true if the value is in the set. O(1).
911      */
912     function _contains(Set storage set, bytes32 value) private view returns (bool) {
913         return set._indexes[value] != 0;
914     }
915 
916     /**
917      * @dev Returns the number of values on the set. O(1).
918      */
919     function _length(Set storage set) private view returns (uint256) {
920         return set._values.length;
921     }
922 
923    /**
924     * @dev Returns the value stored at position `index` in the set. O(1).
925     *
926     * Note that there are no guarantees on the ordering of values inside the
927     * array, and it may change when more values are added or removed.
928     *
929     * Requirements:
930     *
931     * - `index` must be strictly less than {length}.
932     */
933     function _at(Set storage set, uint256 index) private view returns (bytes32) {
934         require(set._values.length > index, "EnumerableSet: index out of bounds");
935         return set._values[index];
936     }
937 
938     // AddressSet
939 
940     struct AddressSet {
941         Set _inner;
942     }
943 
944     /**
945      * @dev Add a value to a set. O(1).
946      *
947      * Returns true if the value was added to the set, that is if it was not
948      * already present.
949      */
950     function add(AddressSet storage set, address value) internal returns (bool) {
951         return _add(set._inner, bytes32(uint256(value)));
952     }
953 
954     /**
955      * @dev Removes a value from a set. O(1).
956      *
957      * Returns true if the value was removed from the set, that is if it was
958      * present.
959      */
960     function remove(AddressSet storage set, address value) internal returns (bool) {
961         return _remove(set._inner, bytes32(uint256(value)));
962     }
963 
964     /**
965      * @dev Returns true if the value is in the set. O(1).
966      */
967     function contains(AddressSet storage set, address value) internal view returns (bool) {
968         return _contains(set._inner, bytes32(uint256(value)));
969     }
970 
971     /**
972      * @dev Returns the number of values in the set. O(1).
973      */
974     function length(AddressSet storage set) internal view returns (uint256) {
975         return _length(set._inner);
976     }
977 
978    /**
979     * @dev Returns the value stored at position `index` in the set. O(1).
980     *
981     * Note that there are no guarantees on the ordering of values inside the
982     * array, and it may change when more values are added or removed.
983     *
984     * Requirements:
985     *
986     * - `index` must be strictly less than {length}.
987     */
988     function at(AddressSet storage set, uint256 index) internal view returns (address) {
989         return address(uint256(_at(set._inner, index)));
990     }
991 
992 
993     // UintSet
994 
995     struct UintSet {
996         Set _inner;
997     }
998 
999     /**
1000      * @dev Add a value to a set. O(1).
1001      *
1002      * Returns true if the value was added to the set, that is if it was not
1003      * already present.
1004      */
1005     function add(UintSet storage set, uint256 value) internal returns (bool) {
1006         return _add(set._inner, bytes32(value));
1007     }
1008 
1009     /**
1010      * @dev Removes a value from a set. O(1).
1011      *
1012      * Returns true if the value was removed from the set, that is if it was
1013      * present.
1014      */
1015     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1016         return _remove(set._inner, bytes32(value));
1017     }
1018 
1019     /**
1020      * @dev Returns true if the value is in the set. O(1).
1021      */
1022     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1023         return _contains(set._inner, bytes32(value));
1024     }
1025 
1026     /**
1027      * @dev Returns the number of values on the set. O(1).
1028      */
1029     function length(UintSet storage set) internal view returns (uint256) {
1030         return _length(set._inner);
1031     }
1032 
1033    /**
1034     * @dev Returns the value stored at position `index` in the set. O(1).
1035     *
1036     * Note that there are no guarantees on the ordering of values inside the
1037     * array, and it may change when more values are added or removed.
1038     *
1039     * Requirements:
1040     *
1041     * - `index` must be strictly less than {length}.
1042     */
1043     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1044         return uint256(_at(set._inner, index));
1045     }
1046 }
1047 
1048 // File: @openzeppelin\contracts\access\Ownable.sol
1049 
1050 
1051 
1052 pragma solidity ^0.6.0;
1053 
1054 /**
1055  * @dev Contract module which provides a basic access control mechanism, where
1056  * there is an account (an owner) that can be granted exclusive access to
1057  * specific functions.
1058  *
1059  * By default, the owner account will be the one that deploys the contract. This
1060  * can later be changed with {transferOwnership}.
1061  *
1062  * This module is used through inheritance. It will make available the modifier
1063  * `onlyOwner`, which can be applied to your functions to restrict their use to
1064  * the owner.
1065  */
1066 contract Ownable is Context {
1067     address private _owner;
1068 
1069     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1070 
1071     /**
1072      * @dev Initializes the contract setting the deployer as the initial owner.
1073      */
1074     constructor () internal {
1075         address msgSender = _msgSender();
1076         _owner = msgSender;
1077         emit OwnershipTransferred(address(0), msgSender);
1078     }
1079 
1080     /**
1081      * @dev Returns the address of the current owner.
1082      */
1083     function owner() public view returns (address) {
1084         return _owner;
1085     }
1086 
1087     /**
1088      * @dev Throws if called by any account other than the owner.
1089      */
1090     modifier onlyOwner() {
1091         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1092         _;
1093     }
1094 
1095     /**
1096      * @dev Leaves the contract without owner. It will not be possible to call
1097      * `onlyOwner` functions anymore. Can only be called by the current owner.
1098      *
1099      * NOTE: Renouncing ownership will leave the contract without an owner,
1100      * thereby removing any functionality that is only available to the owner.
1101      */
1102     function renounceOwnership() public virtual onlyOwner {
1103         emit OwnershipTransferred(_owner, address(0));
1104         _owner = address(0);
1105     }
1106 
1107     /**
1108      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1109      * Can only be called by the current owner.
1110      */
1111     function transferOwnership(address newOwner) public virtual onlyOwner {
1112         require(newOwner != address(0), "Ownable: new owner is the zero address");
1113         emit OwnershipTransferred(_owner, newOwner);
1114         _owner = newOwner;
1115     }
1116 }
1117 
1118 // File: contracts\kSeedToken.sol
1119 
1120 
1121 pragma solidity ^0.6.6;
1122 
1123 
1124 
1125 
1126 
1127 
1128 contract kSeedToken is ERC20 {
1129     
1130     using SafeERC20 for IERC20;
1131     using SafeMath for uint256;
1132  
1133     /// @notice The EIP-712 typehash for the contract's domain
1134     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1135     /// @notice A record of states for signing / validating signatures
1136     mapping (address => uint) public nonces;
1137 
1138     address owner;
1139     address private fundVotingAddress;
1140     IERC20 private kKush;
1141     bool private isSendingFunds;
1142     uint256 private lastBlockSent;
1143 
1144     modifier _onlyOwner() {
1145         require(msg.sender == owner);
1146         _;
1147     }
1148     
1149     constructor() public payable ERC20("KUSH.FINANCE", "kSEED") {
1150         owner = msg.sender;
1151         uint256 supply = 420000;
1152         _mint(msg.sender, supply.mul(10 ** 18));
1153         lastBlockSent = block.number;
1154     }
1155     
1156    function setKushAddress(address kKushAddress) public _onlyOwner {
1157        kKush = IERC20(kKushAddress);
1158    }    
1159     
1160    function setFundingAddress(address fundingContract) public _onlyOwner {
1161        fundVotingAddress = fundingContract;
1162    }
1163    
1164    function startFundingBool() public _onlyOwner {
1165        isSendingFunds = true;
1166    }
1167    
1168    function getFundingPoolAmount() public view returns(uint256) {
1169        kKush.balanceOf(owner);
1170    }
1171    
1172    function triggerTransfer(uint256 amount) public {
1173        require((block.number - lastBlockSent) > 21600, "Too early to transfer");
1174        kKush.safeTransfer(fundVotingAddress, amount);
1175    }
1176 }