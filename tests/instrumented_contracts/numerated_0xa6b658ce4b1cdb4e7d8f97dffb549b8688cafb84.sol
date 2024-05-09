1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 
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
800 // File: @openzeppelin/contracts/utils/Pausable.sol
801 
802 
803 
804 pragma solidity ^0.6.0;
805 
806 
807 /**
808  * @dev Contract module which allows children to implement an emergency stop
809  * mechanism that can be triggered by an authorized account.
810  *
811  * This module is used through inheritance. It will make available the
812  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
813  * the functions of your contract. Note that they will not be pausable by
814  * simply including this module, only once the modifiers are put in place.
815  */
816 contract Pausable is Context {
817     /**
818      * @dev Emitted when the pause is triggered by `account`.
819      */
820     event Paused(address account);
821 
822     /**
823      * @dev Emitted when the pause is lifted by `account`.
824      */
825     event Unpaused(address account);
826 
827     bool private _paused;
828 
829     /**
830      * @dev Initializes the contract in unpaused state.
831      */
832     constructor () internal {
833         _paused = false;
834     }
835 
836     /**
837      * @dev Returns true if the contract is paused, and false otherwise.
838      */
839     function paused() public view returns (bool) {
840         return _paused;
841     }
842 
843     /**
844      * @dev Modifier to make a function callable only when the contract is not paused.
845      *
846      * Requirements:
847      *
848      * - The contract must not be paused.
849      */
850     modifier whenNotPaused() {
851         require(!_paused, "Pausable: paused");
852         _;
853     }
854 
855     /**
856      * @dev Modifier to make a function callable only when the contract is paused.
857      *
858      * Requirements:
859      *
860      * - The contract must be paused.
861      */
862     modifier whenPaused() {
863         require(_paused, "Pausable: not paused");
864         _;
865     }
866 
867     /**
868      * @dev Triggers stopped state.
869      *
870      * Requirements:
871      *
872      * - The contract must not be paused.
873      */
874     function _pause() internal virtual whenNotPaused {
875         _paused = true;
876         emit Paused(_msgSender());
877     }
878 
879     /**
880      * @dev Returns to normal state.
881      *
882      * Requirements:
883      *
884      * - The contract must be paused.
885      */
886     function _unpause() internal virtual whenPaused {
887         _paused = false;
888         emit Unpaused(_msgSender());
889     }
890 }
891 
892 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
893 
894 
895 
896 pragma solidity ^0.6.0;
897 
898 /**
899  * @dev Contract module that helps prevent reentrant calls to a function.
900  *
901  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
902  * available, which can be applied to functions to make sure there are no nested
903  * (reentrant) calls to them.
904  *
905  * Note that because there is a single `nonReentrant` guard, functions marked as
906  * `nonReentrant` may not call one another. This can be worked around by making
907  * those functions `private`, and then adding `external` `nonReentrant` entry
908  * points to them.
909  *
910  * TIP: If you would like to learn more about reentrancy and alternative ways
911  * to protect against it, check out our blog post
912  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
913  */
914 contract ReentrancyGuard {
915     // Booleans are more expensive than uint256 or any type that takes up a full
916     // word because each write operation emits an extra SLOAD to first read the
917     // slot's contents, replace the bits taken up by the boolean, and then write
918     // back. This is the compiler's defense against contract upgrades and
919     // pointer aliasing, and it cannot be disabled.
920 
921     // The values being non-zero value makes deployment a bit more expensive,
922     // but in exchange the refund on every call to nonReentrant will be lower in
923     // amount. Since refunds are capped to a percentage of the total
924     // transaction's gas, it is best to keep them low in cases like this one, to
925     // increase the likelihood of the full refund coming into effect.
926     uint256 private constant _NOT_ENTERED = 1;
927     uint256 private constant _ENTERED = 2;
928 
929     uint256 private _status;
930 
931     constructor () internal {
932         _status = _NOT_ENTERED;
933     }
934 
935     /**
936      * @dev Prevents a contract from calling itself, directly or indirectly.
937      * Calling a `nonReentrant` function from another `nonReentrant`
938      * function is not supported. It is possible to prevent this from happening
939      * by making the `nonReentrant` function external, and make it call a
940      * `private` function that does the actual work.
941      */
942     modifier nonReentrant() {
943         // On the first call to nonReentrant, _notEntered will be true
944         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
945 
946         // Any calls to nonReentrant after this point will fail
947         _status = _ENTERED;
948 
949         _;
950 
951         // By storing the original value once again, a refund is triggered (see
952         // https://eips.ethereum.org/EIPS/eip-2200)
953         _status = _NOT_ENTERED;
954     }
955 }
956 
957 // File: @openzeppelin/contracts/access/Ownable.sol
958 
959 
960 
961 pragma solidity ^0.6.0;
962 
963 /**
964  * @dev Contract module which provides a basic access control mechanism, where
965  * there is an account (an owner) that can be granted exclusive access to
966  * specific functions.
967  *
968  * By default, the owner account will be the one that deploys the contract. This
969  * can later be changed with {transferOwnership}.
970  *
971  * This module is used through inheritance. It will make available the modifier
972  * `onlyOwner`, which can be applied to your functions to restrict their use to
973  * the owner.
974  */
975  
976 contract Ownable is Context {
977     address private _owner;
978 
979     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
980 
981     /**
982      * @dev Initializes the contract setting the deployer as the initial owner.
983      */
984     constructor () internal {
985         address msgSender = _msgSender();
986         _owner = msgSender;
987         emit OwnershipTransferred(address(0), msgSender);
988     }
989 
990     /**
991      * @dev Returns the address of the current owner.
992      */
993     function owner() public view returns (address) {
994         return _owner;
995     }
996 
997     /**
998      * @dev Throws if called by any account other than the owner.
999      */
1000     modifier onlyOwner() {
1001         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1002         _;
1003     }
1004 
1005     /**
1006      * @dev Leaves the contract without owner. It will not be possible to call
1007      * `onlyOwner` functions anymore. Can only be called by the current owner.
1008      *
1009      * NOTE: Renouncing ownership will leave the contract without an owner,
1010      * thereby removing any functionality that is only available to the owner.
1011      */
1012     function renounceOwnership() public virtual onlyOwner {
1013         emit OwnershipTransferred(_owner, address(0));
1014         _owner = address(0);
1015     }
1016 
1017     /**
1018      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1019      * Can only be called by the current owner.
1020      */
1021     function transferOwnership(address newOwner) public virtual onlyOwner {
1022         require(newOwner != address(0), "Ownable: new owner is the zero address");
1023         emit OwnershipTransferred(_owner, newOwner);
1024         _owner = newOwner;
1025     }
1026 }
1027 
1028 // File: contracts/CapitalConverter.sol
1029 
1030 /**
1031  * @dev a contract for convert eth to nETH or token to nToken.
1032  *   
1033  * @notice  there would be a ratio between Token and nToken when emit a claim event.
1034  */
1035 
1036 
1037 
1038 
1039 
1040 
1041 
1042 
1043 pragma solidity ^0.6.0;
1044 
1045 contract CapitalConverter is ERC20, Ownable, Pausable, ReentrancyGuard {
1046     using SafeMath for uint256;
1047     using SafeERC20 for IERC20;
1048 
1049     address public constant ETHEREUM = address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
1050 
1051     uint256 public maxConvert = 10000e18;
1052     address public token;
1053     uint256 public tokenDecimal;
1054 
1055     address public operator;
1056 
1057     mapping (address => uint256) public depositAt; // in case of flashloan attacks
1058 
1059     constructor(address _token, uint256 _tokenDecimal,string memory name,string memory symbol) public  ERC20(name,symbol)
1060     {
1061         token           = _token;
1062         tokenDecimal    = _tokenDecimal;
1063     }
1064 
1065     receive() external payable {
1066         revert();
1067     }
1068 
1069 
1070     function smartBalance() public view returns (uint256) {
1071         if (token == ETHEREUM) {
1072             return address(this).balance;
1073         }
1074 
1075         return IERC20(token).balanceOf(address(this));
1076     }
1077 
1078     function calculateMintAmount(uint256 _depositAmount) internal view returns (uint256) {
1079         if (totalSupply() == 0) {
1080             uint256 value = _depositAmount.mul(uint256(1e18)).div(10**tokenDecimal);
1081             return value;
1082         }
1083 
1084         uint256 initialBalance = smartBalance().sub(_depositAmount);
1085         return _depositAmount.mul(totalSupply()).div(initialBalance);
1086     }
1087     
1088     // convert ETH or USDx to nETH/nUSDx
1089     function convert(uint256 _amount) external payable nonReentrant whenNotPaused {
1090         require(_amount > 0, "CapitalConverter: Cannot stake 0.");
1091         require(_amount <= maxConvert, "exceeding the maximum limit");
1092 
1093         depositAt[msg.sender] = block.number;
1094 
1095         if (token != ETHEREUM) {
1096             require(msg.value == 0, "CapitalConverter: Should not allow ETH deposits.");
1097             IERC20(token).safeTransferFrom(_msgSender(), address(this), _amount);
1098         } else {
1099             require(_amount == msg.value, "CapitalConverter: Incorrect eth amount.");
1100         }
1101 
1102         uint256 value = calculateMintAmount(_amount);
1103         _mint(_msgSender(), value);
1104         
1105         // emit event
1106         emit eMint(_msgSender(), _amount, value);
1107     }
1108 
1109     // withdraw the ETH or USDx
1110     function exit(uint256 _value) external nonReentrant whenNotPaused {
1111         require(balanceOf(_msgSender()) >= _value && _value > 0, 
1112                 "CapitalConverter: insufficient assets");
1113 
1114         require(depositAt[msg.sender] > 0, "No deposit history");
1115         require(depositAt[msg.sender] < block.number, "Reject flashloan");
1116 
1117         uint256 value = _value.mul(smartBalance()).div(totalSupply());
1118         if (token != ETHEREUM) {
1119             IERC20(token).safeTransfer(_msgSender(), value);
1120         } else {
1121             _msgSender().transfer(value);
1122         }
1123 
1124         _burn(_msgSender(), _value);
1125         
1126         // emit event
1127         emit eBurn(_msgSender(), _value, value);
1128     }
1129 
1130     function payouts(address payable _to, uint256 _amount) external onlyOperator {
1131         require(_to != address(0),"_to is zero");
1132         if (token != ETHEREUM) {
1133             IERC20(token).safeTransfer(_to, _amount);
1134         } else {
1135             _to.transfer(_amount);
1136         }
1137 
1138         emit ePayouts(_to, _amount);
1139     }
1140 
1141     modifier onlyOperator() {
1142         require(msg.sender == operator, "not operator");
1143         _;
1144     }
1145 
1146     function setOperator(address _operator) external onlyOwner {
1147         require(_operator != address(0),"_operator is zero");
1148         operator = _operator;
1149         emit eSetOperator(_operator);
1150     }
1151 
1152     function setMaxConvert(uint256 _max) external onlyOwner {
1153         maxConvert = _max;
1154         emit eSetMaxConvert(_max);
1155     }
1156 
1157 
1158     event eMint(address indexed sender, uint256 input, uint256 amount);
1159     event eBurn(address indexed sender, uint256 amount, uint256 output);
1160     event ePayouts(address indexed to, uint256 amount);
1161     event eSetOperator(address indexed operator);
1162     event eSetMaxConvert(uint256 max);
1163 }