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
108 // File: @openzeppelin/contracts/math/SafeMath.sol
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
270 // File: @openzeppelin/contracts/utils/Address.sol
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
298         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
299         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
300         // for accounts without code, i.e. `keccak256('')`
301         bytes32 codehash;
302         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
303         // solhint-disable-next-line no-inline-assembly
304         assembly { codehash := extcodehash(account) }
305         return (codehash != accountHash && codehash != 0x0);
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
675      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
676      *
677      * This is internal function is equivalent to `approve`, and can be used to
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
723 // File: @openzeppelin/contracts/introspection/IERC165.sol
724 
725 // SPDX-License-Identifier: MIT
726 
727 pragma solidity ^0.6.0;
728 
729 /**
730  * @dev Interface of the ERC165 standard, as defined in the
731  * https://eips.ethereum.org/EIPS/eip-165[EIP].
732  *
733  * Implementers can declare support of contract interfaces, which can then be
734  * queried by others ({ERC165Checker}).
735  *
736  * For an implementation, see {ERC165}.
737  */
738 interface IERC165 {
739     /**
740      * @dev Returns true if this contract implements the interface defined by
741      * `interfaceId`. See the corresponding
742      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
743      * to learn more about how these ids are created.
744      *
745      * This function call must use less than 30 000 gas.
746      */
747     function supportsInterface(bytes4 interfaceId) external view returns (bool);
748 }
749 
750 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
751 
752 // SPDX-License-Identifier: MIT
753 
754 pragma solidity ^0.6.0;
755 
756 
757 /**
758  * _Available since v3.1._
759  */
760 interface IERC1155Receiver is IERC165 {
761 
762     /**
763         @dev Handles the receipt of a single ERC1155 token type. This function is
764         called at the end of a `safeTransferFrom` after the balance has been updated.
765         To accept the transfer, this must return
766         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
767         (i.e. 0xf23a6e61, or its own function selector).
768         @param operator The address which initiated the transfer (i.e. msg.sender)
769         @param from The address which previously owned the token
770         @param id The ID of the token being transferred
771         @param value The amount of tokens being transferred
772         @param data Additional data with no specified format
773         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
774     */
775     function onERC1155Received(
776         address operator,
777         address from,
778         uint256 id,
779         uint256 value,
780         bytes calldata data
781     )
782         external
783         returns(bytes4);
784 
785     /**
786         @dev Handles the receipt of a multiple ERC1155 token types. This function
787         is called at the end of a `safeBatchTransferFrom` after the balances have
788         been updated. To accept the transfer(s), this must return
789         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
790         (i.e. 0xbc197c81, or its own function selector).
791         @param operator The address which initiated the batch transfer (i.e. msg.sender)
792         @param from The address which previously owned the token
793         @param ids An array containing ids of each token being transferred (order and length must match values array)
794         @param values An array containing amounts of each token being transferred (order and length must match ids array)
795         @param data Additional data with no specified format
796         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
797     */
798     function onERC1155BatchReceived(
799         address operator,
800         address from,
801         uint256[] calldata ids,
802         uint256[] calldata values,
803         bytes calldata data
804     )
805         external
806         returns(bytes4);
807 }
808 
809 // File: @openzeppelin/contracts/introspection/ERC165.sol
810 
811 // SPDX-License-Identifier: MIT
812 
813 pragma solidity ^0.6.0;
814 
815 
816 /**
817  * @dev Implementation of the {IERC165} interface.
818  *
819  * Contracts may inherit from this and call {_registerInterface} to declare
820  * their support of an interface.
821  */
822 contract ERC165 is IERC165 {
823     /*
824      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
825      */
826     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
827 
828     /**
829      * @dev Mapping of interface ids to whether or not it's supported.
830      */
831     mapping(bytes4 => bool) private _supportedInterfaces;
832 
833     constructor () internal {
834         // Derived contracts need only register support for their own interfaces,
835         // we register support for ERC165 itself here
836         _registerInterface(_INTERFACE_ID_ERC165);
837     }
838 
839     /**
840      * @dev See {IERC165-supportsInterface}.
841      *
842      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
843      */
844     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
845         return _supportedInterfaces[interfaceId];
846     }
847 
848     /**
849      * @dev Registers the contract as an implementer of the interface defined by
850      * `interfaceId`. Support of the actual ERC165 interface is automatic and
851      * registering its interface id is not required.
852      *
853      * See {IERC165-supportsInterface}.
854      *
855      * Requirements:
856      *
857      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
858      */
859     function _registerInterface(bytes4 interfaceId) internal virtual {
860         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
861         _supportedInterfaces[interfaceId] = true;
862     }
863 }
864 
865 // File: @openzeppelin/contracts/token/ERC1155/ERC1155Receiver.sol
866 
867 // SPDX-License-Identifier: MIT
868 
869 pragma solidity ^0.6.0;
870 
871 
872 
873 /**
874  * @dev _Available since v3.1._
875  */
876 abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {
877     constructor() public {
878         _registerInterface(
879             ERC1155Receiver(0).onERC1155Received.selector ^
880             ERC1155Receiver(0).onERC1155BatchReceived.selector
881         );
882     }
883 }
884 
885 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
886 
887 // SPDX-License-Identifier: MIT
888 
889 pragma solidity ^0.6.2;
890 
891 
892 /**
893  * @dev Required interface of an ERC1155 compliant contract, as defined in the
894  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
895  *
896  * _Available since v3.1._
897  */
898 interface IERC1155 is IERC165 {
899     /**
900      * @dev Emitted when `value` tokens of token type `id` are transfered from `from` to `to` by `operator`.
901      */
902     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
903 
904     /**
905      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
906      * transfers.
907      */
908     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
909 
910     /**
911      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
912      * `approved`.
913      */
914     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
915 
916     /**
917      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
918      *
919      * If an {URI} event was emitted for `id`, the standard
920      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
921      * returned by {IERC1155MetadataURI-uri}.
922      */
923     event URI(string value, uint256 indexed id);
924 
925     /**
926      * @dev Returns the amount of tokens of token type `id` owned by `account`.
927      *
928      * Requirements:
929      *
930      * - `account` cannot be the zero address.
931      */
932     function balanceOf(address account, uint256 id) external view returns (uint256);
933 
934     /**
935      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
936      *
937      * Requirements:
938      *
939      * - `accounts` and `ids` must have the same length.
940      */
941     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
942 
943     /**
944      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
945      *
946      * Emits an {ApprovalForAll} event.
947      *
948      * Requirements:
949      *
950      * - `operator` cannot be the caller.
951      */
952     function setApprovalForAll(address operator, bool approved) external;
953 
954     /**
955      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
956      *
957      * See {setApprovalForAll}.
958      */
959     function isApprovedForAll(address account, address operator) external view returns (bool);
960 
961     /**
962      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
963      *
964      * Emits a {TransferSingle} event.
965      *
966      * Requirements:
967      *
968      * - `to` cannot be the zero address.
969      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
970      * - `from` must have a balance of tokens of type `id` of at least `amount`.
971      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
972      * acceptance magic value.
973      */
974     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
975 
976     /**
977      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
978      *
979      * Emits a {TransferBatch} event.
980      *
981      * Requirements:
982      *
983      * - `ids` and `amounts` must have the same length.
984      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
985      * acceptance magic value.
986      */
987     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
988 }
989 
990 // File: contracts/IShareToken.sol
991 
992 pragma solidity ^0.6.2;
993 
994 
995 interface IShareToken is IERC1155 {
996     function claimTradingProceeds(
997         address _market,
998         address _shareHolder,
999         bytes32 _fingerprint
1000     ) external returns (uint256[] memory _outcomeFees);
1001 
1002     function getTokenId(address _market, uint256 _outcome)
1003         external
1004         pure
1005         returns (uint256 _tokenId);
1006 
1007     function getMarket(uint256 _tokenId)
1008         external
1009         view
1010         returns (address _marketAddress);
1011 }
1012 
1013 // File: contracts/ERC20Wrapper.sol
1014 
1015 pragma solidity ^0.6.2;
1016 
1017 
1018 
1019 
1020 /**
1021  * @dev This is an Wrapper around ERC1155 shareTokens generated by Augur
1022  * @author yashnaman
1023  * as shares on a outcome of a market.
1024  * For every outcome there will be one wrapper.
1025  * The approch here is simple. It gets ERC1155 token and mints ERC20.
1026  * It burns ERC20s and gives back the ERC11555s.
1027  * AugurFoundry passed in the constructor has special permission to mint and burn.
1028  */
1029 contract ERC20Wrapper is ERC20, ERC1155Receiver {
1030     uint256 public tokenId;
1031     IShareToken public shareToken;
1032     IERC20 public cash;
1033     address public augurFoundry;
1034 
1035     /**
1036      * @dev sets values for
1037      * @param _augurFoundry A trusted factory contract so that users can wrap multiple tokens in one
1038      * transaction without giving individual approvals
1039      * @param _shareToken address of shareToken for which this wrapper is for
1040      * @param _cash DAI
1041      * @param _tokenId id of market outcome this wrapper is for
1042      * @param _name a descriptive name mentioning market and outcome
1043      * @param _symbol symbol
1044      * @param _decimals decimals
1045      */
1046     constructor(
1047         address _augurFoundry,
1048         IShareToken _shareToken,
1049         IERC20 _cash,
1050         uint256 _tokenId,
1051         string memory _name,
1052         string memory _symbol,
1053         uint8 _decimals
1054     ) public ERC20(_name, _symbol) {
1055         _setupDecimals(_decimals);
1056         augurFoundry = _augurFoundry;
1057         tokenId = _tokenId;
1058         shareToken = _shareToken;
1059         cash = _cash;
1060     }
1061 
1062     /**@dev A function that gets ERC1155s and mints ERC20s
1063      * Requirements:
1064      *
1065      * - if the msg.sender is not augurFoundry then it needs to have given setApprovalForAll
1066      *  to this contract (if the msg.sender is augur foundry then we trust it and know that
1067      *  it would have transferred the ERC1155s to this contract before calling it)
1068      * @param _account account the newly minted ERC20s will go to
1069      * @param _amount amount of tokens to be wrapped
1070      */
1071     function wrapTokens(address _account, uint256 _amount) public {
1072         if (msg.sender != augurFoundry) {
1073             shareToken.safeTransferFrom(
1074                 msg.sender,
1075                 address(this),
1076                 tokenId,
1077                 _amount,
1078                 ""
1079             );
1080         }
1081         _mint(_account, _amount);
1082     }
1083 
1084     /**@dev A function that burns ERC20s and gives back ERC1155s
1085      * Requirements:
1086      *
1087      * - if the msg.sender is not augurFoundry or _account then the caller must have allowance for ``_account``'s tokens of at least
1088      * `amount`.
1089      * - if the market has finalized then claim() function should be called.
1090      * @param _account account the newly minted ERC20s will go to
1091      * @param _amount amount of tokens to be unwrapped
1092      */
1093     function unWrapTokens(address _account, uint256 _amount) public {
1094         if (msg.sender != _account && msg.sender != augurFoundry) {
1095             uint256 decreasedAllowance = allowance(_account, msg.sender).sub(
1096                 _amount,
1097                 "ERC20: burn amount exceeds allowance"
1098             );
1099             _approve(_account, msg.sender, decreasedAllowance);
1100         }
1101         _burn(_account, _amount);
1102 
1103         shareToken.safeTransferFrom(
1104             address(this),
1105             _account,
1106             tokenId,
1107             _amount,
1108             ""
1109         );
1110     }
1111 
1112     /**@dev A function that burns ERC20s and gives back DAI
1113      * It will return _account DAI if the outcome for which this wrapper is for
1114      * is a winning outcome.
1115      * Requirements:
1116      *  - if msg.sender is not {_account} then {_account} should have given allowance to msg.sender
1117      * of at least balanceOf(_account)
1118      * This is to prevent cases where an unknowing contract has the balance and someone claims
1119      * winning for them.
1120      * - Not really a requirement but...
1121      *  it makes more sense to call it when the market has finalized.
1122      *
1123      * @param _account account for which DAI is being claimed
1124      */
1125     function claim(address _account) public {
1126         /**@notice checks if the proceeds were claimed before. If not then claims the proceeds */
1127         if (shareToken.balanceOf(address(this), tokenId) != 0) {
1128             shareToken.claimTradingProceeds(
1129                 shareToken.getMarket(tokenId),
1130                 address(this),
1131                 ""
1132             );
1133         }
1134         uint256 cashBalance = cash.balanceOf(address(this));
1135         /**@notice If this is a winning outcome then give the user thier share of DAI */
1136         if (cashBalance != 0) {
1137             uint256 userShare = (cashBalance.mul(balanceOf(_account))).div(
1138                 totalSupply()
1139             );
1140             if (msg.sender != _account) {
1141                 uint256 decreasedAllowance = allowance(_account, msg.sender)
1142                     .sub(
1143                     balanceOf(_account),
1144                     "ERC20: burn amount exceeds allowance"
1145                 );
1146                 _approve(_account, msg.sender, decreasedAllowance);
1147             }
1148             _burn(_account, balanceOf(_account));
1149             require(cash.transfer(_account, userShare));
1150         }
1151     }
1152 
1153     /**
1154         @dev Handles the receipt of a single ERC1155 token type. This function is
1155         called at the end of a `safeTransferFrom` after the balance has been updated.
1156         To accept the transfer, this must return
1157         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
1158         (i.e. 0xf23a6e61, or its own function selector).
1159         @param operator The address which initiated the transfer (i.e. msg.sender)
1160         @param from The address which previously owned the token
1161         @param id The ID of the token being transferred
1162         @param value The amount of tokens being transferred
1163         @param data Additional data with no specified format
1164         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
1165     */
1166     function onERC1155Received(
1167         address operator,
1168         address from,
1169         uint256 id,
1170         uint256 value,
1171         bytes calldata data
1172     ) external override returns (bytes4) {
1173         /**@notice To make sure that no other tokenId other than what this ERC20 is a wrapper for is sent here*/
1174         require(id == tokenId, "Not acceptable");
1175         return (
1176             bytes4(
1177                 keccak256(
1178                     "onERC1155Received(address,address,uint256,uint256,bytes)"
1179                 )
1180             )
1181         );
1182     }
1183 
1184     /**
1185         @dev Handles the receipt of a multiple ERC1155 token types. This function
1186         is called at the end of a `safeBatchTransferFrom` after the balances have
1187         been updated. To accept the transfer(s), this must return
1188         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
1189         (i.e. 0xbc197c81, or its own function selector).
1190         @param operator The address which initiated the batch transfer (i.e. msg.sender)
1191         @param from The address which previously owned the token
1192         @param ids An array containing ids of each token being transferred (order and length must match values array)
1193         @param values An array containing amounts of each token being transferred (order and length must match ids array)
1194         @param data Additional data with no specified format
1195         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
1196     */
1197     function onERC1155BatchReceived(
1198         address operator,
1199         address from,
1200         uint256[] calldata ids,
1201         uint256[] calldata values,
1202         bytes calldata data
1203     ) external override returns (bytes4) {
1204         /**@notice This is not allowed. Just transfer one predefined id here */
1205         return "";
1206     }
1207 }
1208 
1209 // File: contracts/AugurFoundry.sol
1210 
1211 pragma solidity ^0.6.2;
1212 
1213 
1214 pragma experimental ABIEncoderV2;
1215 
1216 /**
1217  * @dev This is a factory that creates Wrappers around ERC1155 shareTokens generated by Augur
1218  * @author yashnaman
1219  * as shares on outcomes of a markets.
1220  * For every outcome there will be one wrapper.
1221  */
1222 contract AugurFoundry {
1223     IShareToken public shareToken;
1224     IERC20 public cash;
1225 
1226     mapping(uint256 => address) public wrappers;
1227 
1228     event WrapperCreated(uint256 indexed tokenId, address tokenAddress);
1229 
1230     /**@dev sets value for {shareToken} and {cash}
1231      * @param _shareToken address of shareToken associated with a augur universe
1232      *@param _cash DAI
1233      */
1234     constructor(IShareToken _shareToken, IERC20 _cash) public {
1235         cash = _cash;
1236         shareToken = _shareToken;
1237     }
1238 
1239     /**@dev creates new ERC20 wrappers for a outcome of a market
1240      *@param _tokenId token id associated with a outcome of a market
1241      *@param _name a descriptive name mentioning market and outcome
1242      *@param _symbol symbol for the ERC20 wrapper
1243      *@param decimals decimals for the ERC20 wrapper
1244      */
1245     function newERC20Wrapper(
1246         uint256 _tokenId,
1247         string memory _name,
1248         string memory _symbol,
1249         uint8 _decimals
1250     ) public {
1251         require(wrappers[_tokenId] == address(0), "Wrapper already created");
1252         ERC20Wrapper erc20Wrapper = new ERC20Wrapper(
1253             address(this),
1254             shareToken,
1255             cash,
1256             _tokenId,
1257             _name,
1258             _symbol,
1259             _decimals
1260         );
1261         wrappers[_tokenId] = address(erc20Wrapper);
1262         emit WrapperCreated(_tokenId, address(erc20Wrapper));
1263     }
1264 
1265     /**@dev creates new ERC20 wrappers for multiple tokenIds*/
1266     function newERC20Wrappers(
1267         uint256[] memory _tokenIds,
1268         string[] memory _names,
1269         string[] memory _symbols,
1270         uint8[] memory _decimals
1271     ) public {
1272         require(
1273             _tokenIds.length == _names.length &&
1274                 _tokenIds.length == _symbols.length
1275         );
1276         for (uint256 i = 0; i < _tokenIds.length; i++) {
1277             newERC20Wrapper(_tokenIds[i], _names[i], _symbols[i], _decimals[i]);
1278         }
1279     }
1280 
1281     /**@dev A function that wraps ERC1155s shareToken into ERC20s
1282      * Requirements:
1283      *
1284      * -  msg.sender has setApprovalForAll to this contract
1285      * @param _tokenId token id associated with a outcome of a market
1286      * @param _account account the newly minted ERC20s will go to
1287      * @param _amount  amount of tokens to be wrapped
1288      */
1289     function wrapTokens(
1290         uint256 _tokenId,
1291         address _account,
1292         uint256 _amount
1293     ) public {
1294         ERC20Wrapper erc20Wrapper = ERC20Wrapper(wrappers[_tokenId]);
1295         shareToken.safeTransferFrom(
1296             msg.sender,
1297             address(erc20Wrapper),
1298             _tokenId,
1299             _amount,
1300             ""
1301         );
1302         erc20Wrapper.wrapTokens(_account, _amount);
1303     }
1304 
1305     /**@dev A function that burns ERC20s and gives back ERC1155s
1306      * Requirements:
1307      *
1308      * - msg.sender has more than _amount of ERC20 tokens associated with _tokenId.
1309      * - if the market has finalized then it is  advised that you call claim() on ERC20Wrapper
1310      * contract associated with the winning outcome
1311      * @param _tokenId token id associated with a outcome of a market
1312      * @param _amount amount of tokens to be unwrapped
1313      */
1314     function unWrapTokens(uint256 _tokenId, uint256 _amount) public {
1315         ERC20Wrapper erc20Wrapper = ERC20Wrapper(wrappers[_tokenId]);
1316         erc20Wrapper.unWrapTokens(msg.sender, _amount);
1317     }
1318 
1319     /**@dev wraps multiple tokens */
1320     function wrapMultipleTokens(
1321         uint256[] memory _tokenIds,
1322         address _account,
1323         uint256[] memory _amounts
1324     ) public {
1325         for (uint256 i = 0; i < _tokenIds.length; i++) {
1326             wrapTokens(_tokenIds[i], _account, _amounts[i]);
1327         }
1328     }
1329 
1330     /**@dev unwraps multiple tokens */
1331     function unWrapMultipleTokens(
1332         uint256[] memory _tokenIds,
1333         uint256[] memory _amounts
1334     ) public {
1335         for (uint256 i = 0; i < _tokenIds.length; i++) {
1336             unWrapTokens(_tokenIds[i], _amounts[i]);
1337         }
1338     }
1339 }