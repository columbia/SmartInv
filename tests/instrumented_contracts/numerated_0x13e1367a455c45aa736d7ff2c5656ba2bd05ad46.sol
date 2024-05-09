1 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
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
28 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
29 
30 // SPDX-License-Identifier: MIT
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
108 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
109 
110 // SPDX-License-Identifier: MIT
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
270 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
271 
272 // SPDX-License-Identifier: MIT
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
416 // SPDX-License-Identifier: MIT
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
723 // File: @openzeppelin\contracts\math\SafeMath.sol
724 
725 // SPDX-License-Identifier: MIT
726 
727 pragma solidity ^0.6.0;
728 
729 // File: @openzeppelin\contracts\access\Ownable.sol
730 
731 // SPDX-License-Identifier: MIT
732 
733 pragma solidity ^0.6.0;
734 
735 /**
736  * @dev Contract module which provides a basic access control mechanism, where
737  * there is an account (an owner) that can be granted exclusive access to
738  * specific functions.
739  *
740  * By default, the owner account will be the one that deploys the contract. This
741  * can later be changed with {transferOwnership}.
742  *
743  * This module is used through inheritance. It will make available the modifier
744  * `onlyOwner`, which can be applied to your functions to restrict their use to
745  * the owner.
746  */
747 contract Ownable is Context {
748     address private _owner;
749 
750     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
751 
752     /**
753      * @dev Initializes the contract setting the deployer as the initial owner.
754      */
755     constructor () internal {
756         address msgSender = _msgSender();
757         _owner = msgSender;
758         emit OwnershipTransferred(address(0), msgSender);
759     }
760 
761     /**
762      * @dev Returns the address of the current owner.
763      */
764     function owner() public view returns (address) {
765         return _owner;
766     }
767 
768     /**
769      * @dev Throws if called by any account other than the owner.
770      */
771     modifier onlyOwner() {
772         require(_owner == _msgSender(), "Ownable: caller is not the owner");
773         _;
774     }
775 
776     /**
777      * @dev Leaves the contract without owner. It will not be possible to call
778      * `onlyOwner` functions anymore. Can only be called by the current owner.
779      *
780      * NOTE: Renouncing ownership will leave the contract without an owner,
781      * thereby removing any functionality that is only available to the owner.
782      */
783     function renounceOwnership() public virtual onlyOwner {
784         emit OwnershipTransferred(_owner, address(0));
785         _owner = address(0);
786     }
787 
788     /**
789      * @dev Transfers ownership of the contract to a new account (`newOwner`).
790      * Can only be called by the current owner.
791      */
792     function transferOwnership(address newOwner) public virtual onlyOwner {
793         require(newOwner != address(0), "Ownable: new owner is the zero address");
794         emit OwnershipTransferred(_owner, newOwner);
795         _owner = newOwner;
796     }
797 }
798 
799 // File: contracts\TokenStake.sol
800 
801 pragma solidity ^0.6.0;
802 
803 
804 
805 
806 contract TokenStake is Ownable{
807 
808     using SafeMath for uint256;
809 
810     ERC20 public token; // Address of token contract
811     address public tokenOperator; // Address to manage the Stake 
812 
813     uint256 public maxMigrationBlocks; // Block numbers to complete the migration
814 
815     mapping (address => uint256) public balances; // Useer Token balance in the contract
816 
817     uint256 public currentStakeMapIndex; // Current Stake Index to avoid math calc in all methods
818 
819     struct StakeInfo {
820         bool exist;
821         uint256 pendingForApprovalAmount;
822         uint256 approvedAmount;
823         uint256 rewardComputeIndex;
824 
825         mapping (uint256 => uint256) claimableAmount;
826     }
827 
828     // Staking period timestamp (Debatable on timestamp vs blocknumber - went with timestamp)
829     struct StakePeriod {
830         uint256 startPeriod;
831         uint256 submissionEndPeriod;
832         uint256 approvalEndPeriod;
833         uint256 requestWithdrawStartPeriod;
834         uint256 endPeriod;
835 
836         uint256 minStake;
837 
838         bool openForExternal;
839 
840         uint256 windowRewardAmount;
841         
842     }
843 
844     mapping (uint256 => StakePeriod) public stakeMap;
845 
846     // List of Stake Holders
847     address[] stakeHolders; 
848 
849     // All Stake Holders
850     //mapping(address => mapping(uint256 => StakeInfo)) stakeHolderInfo;
851     mapping(address => StakeInfo) stakeHolderInfo;
852 
853     // To store the total stake in a window
854     uint256 public windowTotalStake;
855 
856     // Events
857     event NewOperator(address tokenOperator);
858 
859     event WithdrawToken(address indexed tokenOperator, uint256 amount);
860 
861     event OpenForStake(uint256 indexed stakeIndex, address indexed tokenOperator, uint256 startPeriod, uint256 endPeriod, uint256 approvalEndPeriod, uint256 rewardAmount);
862     event SubmitStake(uint256 indexed stakeIndex, address indexed staker, uint256 stakeAmount);
863     event RequestForClaim(uint256 indexed stakeIndex, address indexed staker, bool autoRenewal);
864     event ClaimStake(uint256 indexed stakeIndex, address indexed staker, uint256 totalAmount);   
865     event RejectStake(uint256 indexed stakeIndex, address indexed staker, address indexed tokenOperator, uint256 returnAmount);
866     event AddReward(address indexed staker, uint256 indexed stakeIndex, address tokenOperator, uint256 totalStakeAmount, uint256 rewardAmount, uint256 windowTotalStake);
867     event WithdrawStake(uint256 indexed stakeIndex, address indexed staker, uint256 stakeAmount);
868 
869 
870 
871     // Modifiers
872     modifier onlyOperator() {
873         require(
874             msg.sender == tokenOperator,
875             "Only operator can call this function."
876         );
877         _;
878     }
879 
880     // Token Operator should be able to do auto renewal
881     modifier allowSubmission() {        
882         require(
883             now >= stakeMap[currentStakeMapIndex].startPeriod && 
884             now <= stakeMap[currentStakeMapIndex].submissionEndPeriod && 
885             stakeMap[currentStakeMapIndex].openForExternal == true, 
886             "Staking at this point not allowed"
887         );
888         _;
889     }
890 
891     modifier validStakeLimit(address staker, uint256 stakeAmount) {
892 
893         uint256 stakerTotalStake;
894         stakerTotalStake = stakeAmount.add(stakeHolderInfo[staker].pendingForApprovalAmount);
895         stakerTotalStake = stakerTotalStake.add(stakeHolderInfo[staker].approvedAmount);
896 
897         // Check for Min Stake
898         require(
899             stakeAmount > 0 && 
900             stakerTotalStake >= stakeMap[currentStakeMapIndex].minStake,
901             "Need to have min stake"
902         );
903         _;
904 
905     }
906 
907     // Check for auto renewal flag update
908     modifier canRequestForClaim(uint256 stakeMapIndex) {
909         require(
910             (stakeHolderInfo[msg.sender].approvedAmount > 0 || stakeHolderInfo[msg.sender].claimableAmount[stakeMapIndex] > 0) &&  
911             now >= stakeMap[stakeMapIndex].requestWithdrawStartPeriod &&
912             now <= stakeMap[stakeMapIndex].endPeriod, 
913             "Update to auto renewal at this point not allowed"
914         );
915         _;
916     }
917 
918     // Check for claim - after the end period when opted out OR after grace period when no more stake windows
919     modifier allowClaimStake(uint256 stakeMapIndex) {
920 
921         uint256 graceTime;
922         graceTime = stakeMap[stakeMapIndex].endPeriod.sub(stakeMap[stakeMapIndex].requestWithdrawStartPeriod);
923 
924         require(
925             (now > stakeMap[stakeMapIndex].endPeriod && stakeHolderInfo[msg.sender].claimableAmount[stakeMapIndex] > 0) ||
926             (now > stakeMap[stakeMapIndex].endPeriod.add(graceTime) && stakeHolderInfo[msg.sender].approvedAmount > 0), "Invalid claim request"
927         );
928         _;
929 
930     }
931 
932     constructor(address _token, uint256 _maxMigrationBlocks)
933     public
934     {
935         token = ERC20(_token);
936         tokenOperator = msg.sender;
937         currentStakeMapIndex = 0;
938         windowTotalStake = 0;
939         maxMigrationBlocks = _maxMigrationBlocks.add(block.number); 
940     }
941 
942     function updateOperator(address newOperator) public onlyOwner {
943 
944         require(newOperator != address(0), "Invalid operator address");
945         
946         tokenOperator = newOperator;
947 
948         emit NewOperator(newOperator);
949     }
950     
951     function withdrawToken(uint256 value) public onlyOperator
952     {
953 
954         // Check if contract is having required balance 
955         require(token.balanceOf(address(this)) >= value, "Not enough balance in the contract");
956         require(token.transfer(msg.sender, value), "Unable to transfer token to the operator account");
957 
958         emit WithdrawToken(tokenOperator, value);
959         
960     }
961 
962     function openForStake(uint256 _startPeriod, uint256 _submissionEndPeriod,  uint256 _approvalEndPeriod, uint256 _requestWithdrawStartPeriod, uint256 _endPeriod, uint256 _windowRewardAmount, uint256 _minStake, bool _openForExternal) public onlyOperator {
963 
964         // Check Input Parameters
965         require(_startPeriod >= now && _startPeriod < _submissionEndPeriod && _submissionEndPeriod < _approvalEndPeriod && _approvalEndPeriod < _requestWithdrawStartPeriod && _requestWithdrawStartPeriod < _endPeriod, "Invalid stake period");
966         require(_windowRewardAmount > 0 && _minStake > 0, "Invalid inputs" );
967 
968         // Check Stake in Progress
969         require(currentStakeMapIndex == 0 || (now > stakeMap[currentStakeMapIndex].approvalEndPeriod && _startPeriod >= stakeMap[currentStakeMapIndex].requestWithdrawStartPeriod), "Cannot have more than one stake request at a time");
970 
971         // Move the staking period to next one
972         currentStakeMapIndex = currentStakeMapIndex + 1;
973         StakePeriod memory stakePeriod;
974 
975         // Set Staking attributes
976         stakePeriod.startPeriod = _startPeriod;
977         stakePeriod.submissionEndPeriod = _submissionEndPeriod;
978         stakePeriod.approvalEndPeriod = _approvalEndPeriod;
979         stakePeriod.requestWithdrawStartPeriod = _requestWithdrawStartPeriod;
980         stakePeriod.endPeriod = _endPeriod;
981         stakePeriod.windowRewardAmount = _windowRewardAmount;
982         stakePeriod.minStake = _minStake;        
983         stakePeriod.openForExternal = _openForExternal;
984 
985         stakeMap[currentStakeMapIndex] = stakePeriod;
986 
987         // Add the current window reward to the window total stake 
988         windowTotalStake = windowTotalStake.add(_windowRewardAmount);
989 
990         emit OpenForStake(currentStakeMapIndex, msg.sender, _startPeriod, _endPeriod, _approvalEndPeriod, _windowRewardAmount);
991 
992     }
993 
994     // To add the Stake Holder
995     function _createStake(address staker, uint256 stakeAmount) internal returns(bool) {
996 
997         StakeInfo storage stakeInfo = stakeHolderInfo[staker];
998 
999         // Check if the user already staked in the past
1000         if(stakeInfo.exist) {
1001 
1002             stakeInfo.pendingForApprovalAmount = stakeInfo.pendingForApprovalAmount.add(stakeAmount);
1003 
1004         } else {
1005 
1006             StakeInfo memory req;
1007 
1008             // Create a new stake request
1009             req.exist = true;
1010             req.pendingForApprovalAmount = stakeAmount;
1011             req.approvedAmount = 0;
1012             req.rewardComputeIndex = 0;
1013 
1014             // Add to the Stake Holders List
1015             stakeHolderInfo[staker] = req;
1016 
1017             // Add to the Stake Holders List
1018             stakeHolders.push(staker);
1019 
1020         }
1021 
1022         return true;
1023 
1024     }
1025 
1026 
1027     // To submit a new stake for the current window
1028     function submitStake(uint256 stakeAmount) public allowSubmission validStakeLimit(msg.sender, stakeAmount) {
1029 
1030         // Transfer the Tokens to Contract
1031         require(token.transferFrom(msg.sender, address(this), stakeAmount), "Unable to transfer token to the contract");
1032 
1033         _createStake(msg.sender, stakeAmount);
1034 
1035         // Update the User balance
1036         balances[msg.sender] = balances[msg.sender].add(stakeAmount);
1037 
1038         // Update current stake period total stake - For Auto Approvals
1039         windowTotalStake = windowTotalStake.add(stakeAmount); 
1040        
1041         emit SubmitStake(currentStakeMapIndex, msg.sender, stakeAmount);
1042 
1043     }
1044 
1045     // To withdraw stake during submission phase
1046     function withdrawStake(uint256 stakeMapIndex, uint256 stakeAmount) public {
1047 
1048         require(
1049             (now >= stakeMap[stakeMapIndex].startPeriod && now <= stakeMap[stakeMapIndex].submissionEndPeriod),
1050             "Stake withdraw at this point is not allowed"
1051         );
1052 
1053         StakeInfo storage stakeInfo = stakeHolderInfo[msg.sender];
1054 
1055         // Validate the input Stake Amount
1056         require(stakeAmount > 0 &&
1057         stakeInfo.pendingForApprovalAmount >= stakeAmount,
1058         "Cannot withdraw beyond stake amount");
1059 
1060         // Allow withdaw not less than minStake or Full Amount
1061         require(
1062             stakeInfo.pendingForApprovalAmount.sub(stakeAmount) >= stakeMap[stakeMapIndex].minStake || 
1063             stakeInfo.pendingForApprovalAmount == stakeAmount,
1064             "Can withdraw full amount or partial amount maintaining min stake"
1065         );
1066 
1067         // Update the staker balance in the staking window
1068         stakeInfo.pendingForApprovalAmount = stakeInfo.pendingForApprovalAmount.sub(stakeAmount);
1069 
1070         // Update the User balance
1071         balances[msg.sender] = balances[msg.sender].sub(stakeAmount);
1072 
1073         // Update current stake period total stake - For Auto Approvals
1074         windowTotalStake = windowTotalStake.sub(stakeAmount); 
1075 
1076         // Return to User Wallet
1077         require(token.transfer(msg.sender, stakeAmount), "Unable to transfer token to the account");
1078 
1079         emit WithdrawStake(stakeMapIndex, msg.sender, stakeAmount);
1080     }
1081 
1082     // Reject the stake in the Current Window
1083     function rejectStake(uint256 stakeMapIndex, address staker) public onlyOperator {
1084 
1085         // Allow for rejection after approval period as well
1086         require(now > stakeMap[stakeMapIndex].submissionEndPeriod && currentStakeMapIndex == stakeMapIndex, "Rejection at this point is not allowed");
1087 
1088         StakeInfo storage stakeInfo = stakeHolderInfo[staker];
1089 
1090         // In case of if there are auto renewals reject should not be allowed
1091         require(stakeInfo.pendingForApprovalAmount > 0, "No staking request found");
1092 
1093         uint256 returnAmount;
1094         returnAmount = stakeInfo.pendingForApprovalAmount;
1095 
1096         // transfer back the stake to user account
1097         require(token.transfer(staker, stakeInfo.pendingForApprovalAmount), "Unable to transfer token back to the account");
1098 
1099         // Update the User Balance
1100         balances[staker] = balances[staker].sub(stakeInfo.pendingForApprovalAmount);
1101 
1102         // Update current stake period total stake - For Auto Approvals
1103         windowTotalStake = windowTotalStake.sub(stakeInfo.pendingForApprovalAmount);
1104 
1105         // Update the Pending Amount
1106         stakeInfo.pendingForApprovalAmount = 0;
1107 
1108         emit RejectStake(stakeMapIndex, staker, msg.sender, returnAmount);
1109 
1110     }
1111 
1112     // To update the Auto Renewal - OptIn or OptOut for next stake window
1113     function requestForClaim(uint256 stakeMapIndex, bool autoRenewal) public canRequestForClaim(stakeMapIndex) {
1114 
1115         StakeInfo storage stakeInfo = stakeHolderInfo[msg.sender];
1116 
1117         // Check for the claim amount
1118         require((autoRenewal == true && stakeInfo.claimableAmount[stakeMapIndex] > 0) || (autoRenewal == false && stakeInfo.approvedAmount > 0), "Invalid auto renew request");
1119 
1120         if(autoRenewal) {
1121 
1122             // Update current stake period total stake - For Auto Approvals
1123             windowTotalStake = windowTotalStake.add(stakeInfo.claimableAmount[stakeMapIndex]);
1124 
1125             stakeInfo.approvedAmount = stakeInfo.claimableAmount[stakeMapIndex];
1126             stakeInfo.claimableAmount[stakeMapIndex] = 0;
1127 
1128         } else {
1129 
1130             // Update current stake period total stake - For Auto Approvals
1131             windowTotalStake = windowTotalStake.sub(stakeInfo.approvedAmount);
1132 
1133             stakeInfo.claimableAmount[stakeMapIndex] = stakeInfo.approvedAmount;
1134             stakeInfo.approvedAmount = 0;
1135 
1136         }
1137 
1138         emit RequestForClaim(stakeMapIndex, msg.sender, autoRenewal);
1139 
1140     }
1141 
1142 
1143     function _calculateRewardAmount(uint256 stakeMapIndex, uint256 stakeAmount) internal view returns(uint256) {
1144 
1145         uint256 calcRewardAmount;
1146         calcRewardAmount = stakeAmount.mul(stakeMap[stakeMapIndex].windowRewardAmount).div(windowTotalStake.sub(stakeMap[stakeMapIndex].windowRewardAmount));
1147         return calcRewardAmount;
1148     }
1149 
1150 
1151     // Update reward for staker in the respective stake window
1152     function computeAndAddReward(uint256 stakeMapIndex, address staker) 
1153     public 
1154     onlyOperator
1155     returns(bool)
1156     {
1157 
1158         // Check for the Incubation Period
1159         require(
1160             now > stakeMap[stakeMapIndex].approvalEndPeriod && 
1161             now < stakeMap[stakeMapIndex].requestWithdrawStartPeriod, 
1162             "Reward cannot be added now"
1163         );
1164 
1165         StakeInfo storage stakeInfo = stakeHolderInfo[staker];
1166 
1167         // Check if reward already computed
1168         require((stakeInfo.approvedAmount > 0 || stakeInfo.pendingForApprovalAmount > 0 ) && stakeInfo.rewardComputeIndex != stakeMapIndex, "Invalid reward request");
1169 
1170 
1171         // Calculate the totalAmount
1172         uint256 totalAmount;
1173         uint256 rewardAmount;
1174 
1175         // Calculate the reward amount for the current window - Need to consider pendingForApprovalAmount for Auto Approvals
1176         totalAmount = stakeInfo.approvedAmount.add(stakeInfo.pendingForApprovalAmount);
1177         rewardAmount = _calculateRewardAmount(stakeMapIndex, totalAmount);
1178         totalAmount = totalAmount.add(rewardAmount);
1179 
1180         // Add the reward amount and update pendingForApprovalAmount
1181         stakeInfo.approvedAmount = totalAmount;
1182         stakeInfo.pendingForApprovalAmount = 0;
1183 
1184         // Update the reward compute index to avoid mulitple addition
1185         stakeInfo.rewardComputeIndex = stakeMapIndex;
1186 
1187         // Update the User Balance
1188         balances[staker] = balances[staker].add(rewardAmount);
1189 
1190         emit AddReward(staker, stakeMapIndex, tokenOperator, totalAmount, rewardAmount, windowTotalStake);
1191 
1192         return true;
1193     }
1194 
1195     function updateRewards(uint256 stakeMapIndex, address[] calldata staker) 
1196     external 
1197     onlyOperator
1198     {
1199         for(uint256 indx = 0; indx < staker.length; indx++) {
1200             require(computeAndAddReward(stakeMapIndex, staker[indx]));
1201         }
1202     }
1203 
1204     // To claim from the stake window
1205     function claimStake(uint256 stakeMapIndex) public allowClaimStake(stakeMapIndex) {
1206 
1207         StakeInfo storage stakeInfo = stakeHolderInfo[msg.sender];
1208 
1209         uint256 stakeAmount;
1210         
1211         // General claim
1212         if(stakeInfo.claimableAmount[stakeMapIndex] > 0) {
1213             
1214             stakeAmount = stakeInfo.claimableAmount[stakeMapIndex];
1215             stakeInfo.claimableAmount[stakeMapIndex] = 0;
1216 
1217         } else {
1218             
1219             // No more stake windows & beyond grace period
1220             stakeAmount = stakeInfo.approvedAmount;
1221             stakeInfo.approvedAmount = 0;
1222 
1223             // Update current stake period total stake
1224             windowTotalStake = windowTotalStake.sub(stakeAmount);
1225         }
1226 
1227         // Check for balance in the contract
1228         require(token.balanceOf(address(this)) >= stakeAmount, "Not enough balance in the contract");
1229 
1230         // Update the User Balance
1231         balances[msg.sender] = balances[msg.sender].sub(stakeAmount);
1232 
1233         // Call the transfer function
1234         require(token.transfer(msg.sender, stakeAmount), "Unable to transfer token back to the account");
1235 
1236         emit ClaimStake(stakeMapIndex, msg.sender, stakeAmount);
1237 
1238     }
1239 
1240 
1241     // Migration - Load existing Stake Windows & Stakers
1242     function migrateStakeWindow(uint256 _startPeriod, uint256 _submissionEndPeriod,  uint256 _approvalEndPeriod, uint256 _requestWithdrawStartPeriod, uint256 _endPeriod, uint256 _windowRewardAmount, uint256 _minStake, bool _openForExternal) public onlyOperator {
1243 
1244         // Add check for Block Number to restrict migration after certain block number
1245         require(block.number < maxMigrationBlocks, "Exceeds migration phase");
1246 
1247         // Check Input Parameters for past stake windows
1248         require(now > _startPeriod && _startPeriod < _submissionEndPeriod && _submissionEndPeriod < _approvalEndPeriod && _approvalEndPeriod < _requestWithdrawStartPeriod && _requestWithdrawStartPeriod < _endPeriod, "Invalid stake period");
1249         require(_windowRewardAmount > 0 && _minStake > 0, "Invalid inputs" );
1250 
1251         // Move the staking period to next one
1252         currentStakeMapIndex = currentStakeMapIndex + 1;
1253         StakePeriod memory stakePeriod;
1254 
1255         // Set Staking attributes
1256         stakePeriod.startPeriod = _startPeriod;
1257         stakePeriod.submissionEndPeriod = _submissionEndPeriod;
1258         stakePeriod.approvalEndPeriod = _approvalEndPeriod;
1259         stakePeriod.requestWithdrawStartPeriod = _requestWithdrawStartPeriod;
1260         stakePeriod.endPeriod = _endPeriod;
1261         stakePeriod.windowRewardAmount = _windowRewardAmount;
1262         stakePeriod.minStake = _minStake;        
1263         stakePeriod.openForExternal = _openForExternal;
1264 
1265         stakeMap[currentStakeMapIndex] = stakePeriod;
1266 
1267 
1268     }
1269 
1270 
1271     // Migration - Load existing stakes along with computed reward
1272     function migrateStakes(uint256 stakeMapIndex, address[] calldata staker, uint256[] calldata stakeAmount) external onlyOperator {
1273 
1274         // Add check for Block Number to restrict migration after certain block number
1275         require(block.number < maxMigrationBlocks, "Exceeds migration phase");
1276 
1277         // Check Input Parameters
1278         require(staker.length == stakeAmount.length, "Invalid Input Arrays");
1279 
1280         // Stakers should be for current window
1281         require(currentStakeMapIndex == stakeMapIndex, "Invalid Stake Window Index");
1282 
1283         for(uint256 indx = 0; indx < staker.length; indx++) {
1284 
1285             StakeInfo memory req;
1286 
1287             // Create a stake request with approvedAmount
1288             req.exist = true;
1289             req.pendingForApprovalAmount = 0;
1290             req.approvedAmount = stakeAmount[indx];
1291             req.rewardComputeIndex = stakeMapIndex;
1292 
1293             // Add to the Stake Holders List
1294             stakeHolderInfo[staker[indx]] = req;
1295 
1296             // Add to the Stake Holders List
1297             stakeHolders.push(staker[indx]);
1298 
1299             // Update the User balance
1300             balances[staker[indx]] = stakeAmount[indx];
1301 
1302             // Update current stake period total stake - Along with Reward
1303             windowTotalStake = windowTotalStake.add(stakeAmount[indx]);
1304 
1305         }
1306 
1307     }
1308 
1309 
1310     // Getter Functions    
1311     function getStakeHolders() public view returns(address[] memory) {
1312         return stakeHolders;
1313     }
1314 
1315     function getStakeInfo(uint256 stakeMapIndex, address staker) 
1316     public 
1317     view
1318     returns (bool found, uint256 approvedAmount, uint256 pendingForApprovalAmount, uint256 rewardComputeIndex, uint256 claimableAmount) 
1319     {
1320 
1321         StakeInfo storage stakeInfo = stakeHolderInfo[staker];
1322         
1323         found = false;
1324         if(stakeInfo.exist) {
1325             found = true;
1326         }
1327 
1328         pendingForApprovalAmount = stakeInfo.pendingForApprovalAmount;
1329         approvedAmount = stakeInfo.approvedAmount;
1330         rewardComputeIndex = stakeInfo.rewardComputeIndex;
1331         claimableAmount = stakeInfo.claimableAmount[stakeMapIndex];
1332 
1333     }
1334 
1335 
1336 }