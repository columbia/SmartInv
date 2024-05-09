1 // Dependency file: @openzeppelin/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 // pragma solidity ^0.6.0;
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
28 
29 // Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol
30 
31 
32 // pragma solidity ^0.6.0;
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
71      * // importANT: Beware that changing an allowance with this method brings the risk
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
108 
109 // Dependency file: @openzeppelin/contracts/math/SafeMath.sol
110 
111 
112 // pragma solidity ^0.6.0;
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
270 
271 // Dependency file: @openzeppelin/contracts/utils/Address.sol
272 
273 
274 // pragma solidity ^0.6.2;
275 
276 /**
277  * @dev Collection of functions related to the address type
278  */
279 library Address {
280     /**
281      * @dev Returns true if `account` is a contract.
282      *
283      * [// importANT]
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
319      * // importANT: because control is transferred to `recipient`, care must be
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
414 
415 // Dependency file: @openzeppelin/contracts/token/ERC20/ERC20.sol
416 
417 
418 // pragma solidity ^0.6.0;
419 
420 // import "@openzeppelin/contracts/GSN/Context.sol";
421 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
422 // import "@openzeppelin/contracts/math/SafeMath.sol";
423 // import "@openzeppelin/contracts/utils/Address.sol";
424 
425 /**
426  * @dev Implementation of the {IERC20} interface.
427  *
428  * This implementation is agnostic to the way tokens are created. This means
429  * that a supply mechanism has to be added in a derived contract using {_mint}.
430  * For a generic mechanism see {ERC20PresetMinterPauser}.
431  *
432  * TIP: For a detailed writeup see our guide
433  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
434  * to implement supply mechanisms].
435  *
436  * We have followed general OpenZeppelin guidelines: functions revert instead
437  * of returning `false` on failure. This behavior is nonetheless conventional
438  * and does not conflict with the expectations of ERC20 applications.
439  *
440  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
441  * This allows applications to reconstruct the allowance for all accounts just
442  * by listening to said events. Other implementations of the EIP may not emit
443  * these events, as it isn't required by the specification.
444  *
445  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
446  * functions have been added to mitigate the well-known issues around setting
447  * allowances. See {IERC20-approve}.
448  */
449 contract ERC20 is Context, IERC20 {
450     using SafeMath for uint256;
451     using Address for address;
452 
453     mapping (address => uint256) private _balances;
454 
455     mapping (address => mapping (address => uint256)) private _allowances;
456 
457     uint256 private _totalSupply;
458 
459     string private _name;
460     string private _symbol;
461     uint8 private _decimals;
462 
463     /**
464      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
465      * a default value of 18.
466      *
467      * To select a different value for {decimals}, use {_setupDecimals}.
468      *
469      * All three of these values are immutable: they can only be set once during
470      * construction.
471      */
472     constructor (string memory name, string memory symbol) public {
473         _name = name;
474         _symbol = symbol;
475         _decimals = 18;
476     }
477 
478     /**
479      * @dev Returns the name of the token.
480      */
481     function name() public view returns (string memory) {
482         return _name;
483     }
484 
485     /**
486      * @dev Returns the symbol of the token, usually a shorter version of the
487      * name.
488      */
489     function symbol() public view returns (string memory) {
490         return _symbol;
491     }
492 
493     /**
494      * @dev Returns the number of decimals used to get its user representation.
495      * For example, if `decimals` equals `2`, a balance of `505` tokens should
496      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
497      *
498      * Tokens usually opt for a value of 18, imitating the relationship between
499      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
500      * called.
501      *
502      * NOTE: This information is only used for _display_ purposes: it in
503      * no way affects any of the arithmetic of the contract, including
504      * {IERC20-balanceOf} and {IERC20-transfer}.
505      */
506     function decimals() public view returns (uint8) {
507         return _decimals;
508     }
509 
510     /**
511      * @dev See {IERC20-totalSupply}.
512      */
513     function totalSupply() public view override returns (uint256) {
514         return _totalSupply;
515     }
516 
517     /**
518      * @dev See {IERC20-balanceOf}.
519      */
520     function balanceOf(address account) public view override returns (uint256) {
521         return _balances[account];
522     }
523 
524     /**
525      * @dev See {IERC20-transfer}.
526      *
527      * Requirements:
528      *
529      * - `recipient` cannot be the zero address.
530      * - the caller must have a balance of at least `amount`.
531      */
532     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
533         _transfer(_msgSender(), recipient, amount);
534         return true;
535     }
536 
537     /**
538      * @dev See {IERC20-allowance}.
539      */
540     function allowance(address owner, address spender) public view virtual override returns (uint256) {
541         return _allowances[owner][spender];
542     }
543 
544     /**
545      * @dev See {IERC20-approve}.
546      *
547      * Requirements:
548      *
549      * - `spender` cannot be the zero address.
550      */
551     function approve(address spender, uint256 amount) public virtual override returns (bool) {
552         _approve(_msgSender(), spender, amount);
553         return true;
554     }
555 
556     /**
557      * @dev See {IERC20-transferFrom}.
558      *
559      * Emits an {Approval} event indicating the updated allowance. This is not
560      * required by the EIP. See the note at the beginning of {ERC20};
561      *
562      * Requirements:
563      * - `sender` and `recipient` cannot be the zero address.
564      * - `sender` must have a balance of at least `amount`.
565      * - the caller must have allowance for ``sender``'s tokens of at least
566      * `amount`.
567      */
568     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
569         _transfer(sender, recipient, amount);
570         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
571         return true;
572     }
573 
574     /**
575      * @dev Atomically increases the allowance granted to `spender` by the caller.
576      *
577      * This is an alternative to {approve} that can be used as a mitigation for
578      * problems described in {IERC20-approve}.
579      *
580      * Emits an {Approval} event indicating the updated allowance.
581      *
582      * Requirements:
583      *
584      * - `spender` cannot be the zero address.
585      */
586     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
587         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
588         return true;
589     }
590 
591     /**
592      * @dev Atomically decreases the allowance granted to `spender` by the caller.
593      *
594      * This is an alternative to {approve} that can be used as a mitigation for
595      * problems described in {IERC20-approve}.
596      *
597      * Emits an {Approval} event indicating the updated allowance.
598      *
599      * Requirements:
600      *
601      * - `spender` cannot be the zero address.
602      * - `spender` must have allowance for the caller of at least
603      * `subtractedValue`.
604      */
605     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
606         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
607         return true;
608     }
609 
610     /**
611      * @dev Moves tokens `amount` from `sender` to `recipient`.
612      *
613      * This is internal function is equivalent to {transfer}, and can be used to
614      * e.g. implement automatic token fees, slashing mechanisms, etc.
615      *
616      * Emits a {Transfer} event.
617      *
618      * Requirements:
619      *
620      * - `sender` cannot be the zero address.
621      * - `recipient` cannot be the zero address.
622      * - `sender` must have a balance of at least `amount`.
623      */
624     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
625         require(sender != address(0), "ERC20: transfer from the zero address");
626         require(recipient != address(0), "ERC20: transfer to the zero address");
627 
628         _beforeTokenTransfer(sender, recipient, amount);
629 
630         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
631         _balances[recipient] = _balances[recipient].add(amount);
632         emit Transfer(sender, recipient, amount);
633     }
634 
635     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
636      * the total supply.
637      *
638      * Emits a {Transfer} event with `from` set to the zero address.
639      *
640      * Requirements
641      *
642      * - `to` cannot be the zero address.
643      */
644     function _mint(address account, uint256 amount) internal virtual {
645         require(account != address(0), "ERC20: mint to the zero address");
646 
647         _beforeTokenTransfer(address(0), account, amount);
648 
649         _totalSupply = _totalSupply.add(amount);
650         _balances[account] = _balances[account].add(amount);
651         emit Transfer(address(0), account, amount);
652     }
653 
654     /**
655      * @dev Destroys `amount` tokens from `account`, reducing the
656      * total supply.
657      *
658      * Emits a {Transfer} event with `to` set to the zero address.
659      *
660      * Requirements
661      *
662      * - `account` cannot be the zero address.
663      * - `account` must have at least `amount` tokens.
664      */
665     function _burn(address account, uint256 amount) internal virtual {
666         require(account != address(0), "ERC20: burn from the zero address");
667 
668         _beforeTokenTransfer(account, address(0), amount);
669 
670         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
671         _totalSupply = _totalSupply.sub(amount);
672         emit Transfer(account, address(0), amount);
673     }
674 
675     /**
676      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
677      *
678      * This internal function is equivalent to `approve`, and can be used to
679      * e.g. set automatic allowances for certain subsystems, etc.
680      *
681      * Emits an {Approval} event.
682      *
683      * Requirements:
684      *
685      * - `owner` cannot be the zero address.
686      * - `spender` cannot be the zero address.
687      */
688     function _approve(address owner, address spender, uint256 amount) internal virtual {
689         require(owner != address(0), "ERC20: approve from the zero address");
690         require(spender != address(0), "ERC20: approve to the zero address");
691 
692         _allowances[owner][spender] = amount;
693         emit Approval(owner, spender, amount);
694     }
695 
696     /**
697      * @dev Sets {decimals} to a value other than the default one of 18.
698      *
699      * WARNING: This function should only be called from the constructor. Most
700      * applications that interact with token contracts will not expect
701      * {decimals} to ever change, and may work incorrectly if it does.
702      */
703     function _setupDecimals(uint8 decimals_) internal {
704         _decimals = decimals_;
705     }
706 
707     /**
708      * @dev Hook that is called before any transfer of tokens. This includes
709      * minting and burning.
710      *
711      * Calling conditions:
712      *
713      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
714      * will be to transferred to `to`.
715      * - when `from` is zero, `amount` tokens will be minted for `to`.
716      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
717      * - `from` and `to` are never both zero.
718      *
719      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
720      */
721     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
722 }
723 
724 
725 // Dependency file: @openzeppelin/contracts/access/Ownable.sol
726 
727 
728 // pragma solidity ^0.6.0;
729 
730 // import "@openzeppelin/contracts/GSN/Context.sol";
731 /**
732  * @dev Contract module which provides a basic access control mechanism, where
733  * there is an account (an owner) that can be granted exclusive access to
734  * specific functions.
735  *
736  * By default, the owner account will be the one that deploys the contract. This
737  * can later be changed with {transferOwnership}.
738  *
739  * This module is used through inheritance. It will make available the modifier
740  * `onlyOwner`, which can be applied to your functions to restrict their use to
741  * the owner.
742  */
743 contract Ownable is Context {
744     address private _owner;
745 
746     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
747 
748     /**
749      * @dev Initializes the contract setting the deployer as the initial owner.
750      */
751     constructor () internal {
752         address msgSender = _msgSender();
753         _owner = msgSender;
754         emit OwnershipTransferred(address(0), msgSender);
755     }
756 
757     /**
758      * @dev Returns the address of the current owner.
759      */
760     function owner() public view returns (address) {
761         return _owner;
762     }
763 
764     /**
765      * @dev Throws if called by any account other than the owner.
766      */
767     modifier onlyOwner() {
768         require(_owner == _msgSender(), "Ownable: caller is not the owner");
769         _;
770     }
771 
772     /**
773      * @dev Leaves the contract without owner. It will not be possible to call
774      * `onlyOwner` functions anymore. Can only be called by the current owner.
775      *
776      * NOTE: Renouncing ownership will leave the contract without an owner,
777      * thereby removing any functionality that is only available to the owner.
778      */
779     function renounceOwnership() public virtual onlyOwner {
780         emit OwnershipTransferred(_owner, address(0));
781         _owner = address(0);
782     }
783 
784     /**
785      * @dev Transfers ownership of the contract to a new account (`newOwner`).
786      * Can only be called by the current owner.
787      */
788     function transferOwnership(address newOwner) public virtual onlyOwner {
789         require(newOwner != address(0), "Ownable: new owner is the zero address");
790         emit OwnershipTransferred(_owner, newOwner);
791         _owner = newOwner;
792     }
793 }
794 
795 
796 // Root file: src/AergoErc20.sol
797 
798 pragma solidity ^0.6.0;
799 
800 // import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
801 // import "@openzeppelin/contracts/access/Ownable.sol";
802 
803 
804 /**
805  * @title AergoErc20
806  */
807 contract AergoErc20 is ERC20, Ownable {
808     bool public paused;
809     mapping(address => bool) public blacklist;
810 
811     event AddedToBlacklist(address indexed account);
812     event RemovedFromBlacklist(address indexed account);
813     event Pause();
814     event Unpause();
815 
816 
817     /**
818      * Modifiers
819      */
820 
821     /**
822     * @dev Modifier to make a function callable only when the contract is not paused.
823     */
824     modifier whenNotPaused() {
825         require(!paused || (msg.sender == owner()));
826         _;
827     }
828 
829     /**
830     * @dev called by the owner to pause, triggers stopped state
831     */
832     function pause() public onlyOwner {
833         paused = true;
834         emit Pause();
835     }
836 
837     /**
838     * @dev called by the owner to unpause, returns to normal state
839     */
840     function unpause() public onlyOwner {
841         paused = false;
842         emit Unpause();
843     }
844 
845     /**
846      * @dev Return true if the address is in the blacklist
847      */
848     function isBlacklisted(address _address) public view returns(bool) {
849         return blacklist[_address];
850     }
851 
852     /**
853      * @dev Add the addess to the blacklist (set to true)
854      */
855     function addToBlacklist(address _address) public virtual onlyOwner {
856         blacklist[_address] = true;
857         emit AddedToBlacklist(_address);
858     }
859 
860     /**
861      * @dev Remove the addess from the blacklist (set to false)
862      */
863     function removeFromBlacklist(address _address) public virtual onlyOwner {
864         blacklist[_address] = false;
865         emit RemovedFromBlacklist(_address);
866     }
867 
868     /**
869      * Constructor
870      */
871     constructor() ERC20("Aergo", "AERGO") public {
872         paused = false;
873         _mint(msg.sender, 500 * (10**6) * 10**18);
874     }
875 
876     /**
877      * Functions overridden so that when the contract is paused, they are not callable by anyone except the owner.
878      */
879 
880     function transfer(address recipient, uint256 amount) public override whenNotPaused returns (bool) {
881         require(!isBlacklisted(_msgSender()), "Sender is blacklisted");
882         require(!isBlacklisted(recipient), "Recipient is blacklisted");
883         return super.transfer(recipient, amount);
884     }
885 
886     function transferFrom(address sender, address recipient, uint256 amount) public override whenNotPaused returns (bool) {
887         require(!isBlacklisted(sender), "Sender is blacklisted");
888         require(!isBlacklisted(recipient), "Recipient is blacklisted");
889         return super.transferFrom(sender, recipient, amount);
890     }
891 
892     function approve(address spender, uint256 value) public override whenNotPaused returns (bool) {
893         require(!isBlacklisted(_msgSender()), "Sender is blacklisted");
894         require(!isBlacklisted(spender), "Spender is blacklisted");
895         return super.approve(spender, value);
896     }
897 
898     function increaseAllowance(address spender, uint addedValue) public override whenNotPaused returns (bool) {
899         require(!isBlacklisted(_msgSender()), "Sender is blacklisted");
900         require(!isBlacklisted(spender), "Spender is blacklisted");
901         return super.increaseAllowance(spender, addedValue);
902     }
903 
904     function decreaseAllowance(address spender, uint subtractedValue) public override whenNotPaused returns (bool) {
905         require(!isBlacklisted(_msgSender()), "Sender is blacklisted");
906         require(!isBlacklisted(spender), "Spender is blacklisted");
907         return super.decreaseAllowance(spender, subtractedValue);
908     }
909 }