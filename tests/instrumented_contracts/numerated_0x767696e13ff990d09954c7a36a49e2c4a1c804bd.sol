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
723 // File: @openzeppelin/contracts/utils/SafeCast.sol
724 
725 // SPDX-License-Identifier: MIT
726 
727 pragma solidity ^0.6.0;
728 
729 
730 /**
731  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
732  * checks.
733  *
734  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
735  * easily result in undesired exploitation or bugs, since developers usually
736  * assume that overflows raise errors. `SafeCast` restores this intuition by
737  * reverting the transaction when such an operation overflows.
738  *
739  * Using this library instead of the unchecked operations eliminates an entire
740  * class of bugs, so it's recommended to use it always.
741  *
742  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
743  * all math on `uint256` and `int256` and then downcasting.
744  */
745 library SafeCast {
746 
747     /**
748      * @dev Returns the downcasted uint128 from uint256, reverting on
749      * overflow (when the input is greater than largest uint128).
750      *
751      * Counterpart to Solidity's `uint128` operator.
752      *
753      * Requirements:
754      *
755      * - input must fit into 128 bits
756      */
757     function toUint128(uint256 value) internal pure returns (uint128) {
758         require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
759         return uint128(value);
760     }
761 
762     /**
763      * @dev Returns the downcasted uint64 from uint256, reverting on
764      * overflow (when the input is greater than largest uint64).
765      *
766      * Counterpart to Solidity's `uint64` operator.
767      *
768      * Requirements:
769      *
770      * - input must fit into 64 bits
771      */
772     function toUint64(uint256 value) internal pure returns (uint64) {
773         require(value < 2**64, "SafeCast: value doesn\'t fit in 64 bits");
774         return uint64(value);
775     }
776 
777     /**
778      * @dev Returns the downcasted uint32 from uint256, reverting on
779      * overflow (when the input is greater than largest uint32).
780      *
781      * Counterpart to Solidity's `uint32` operator.
782      *
783      * Requirements:
784      *
785      * - input must fit into 32 bits
786      */
787     function toUint32(uint256 value) internal pure returns (uint32) {
788         require(value < 2**32, "SafeCast: value doesn\'t fit in 32 bits");
789         return uint32(value);
790     }
791 
792     /**
793      * @dev Returns the downcasted uint16 from uint256, reverting on
794      * overflow (when the input is greater than largest uint16).
795      *
796      * Counterpart to Solidity's `uint16` operator.
797      *
798      * Requirements:
799      *
800      * - input must fit into 16 bits
801      */
802     function toUint16(uint256 value) internal pure returns (uint16) {
803         require(value < 2**16, "SafeCast: value doesn\'t fit in 16 bits");
804         return uint16(value);
805     }
806 
807     /**
808      * @dev Returns the downcasted uint8 from uint256, reverting on
809      * overflow (when the input is greater than largest uint8).
810      *
811      * Counterpart to Solidity's `uint8` operator.
812      *
813      * Requirements:
814      *
815      * - input must fit into 8 bits.
816      */
817     function toUint8(uint256 value) internal pure returns (uint8) {
818         require(value < 2**8, "SafeCast: value doesn\'t fit in 8 bits");
819         return uint8(value);
820     }
821 
822     /**
823      * @dev Converts a signed int256 into an unsigned uint256.
824      *
825      * Requirements:
826      *
827      * - input must be greater than or equal to 0.
828      */
829     function toUint256(int256 value) internal pure returns (uint256) {
830         require(value >= 0, "SafeCast: value must be positive");
831         return uint256(value);
832     }
833 
834     /**
835      * @dev Returns the downcasted int128 from int256, reverting on
836      * overflow (when the input is less than smallest int128 or
837      * greater than largest int128).
838      *
839      * Counterpart to Solidity's `int128` operator.
840      *
841      * Requirements:
842      *
843      * - input must fit into 128 bits
844      *
845      * _Available since v3.1._
846      */
847     function toInt128(int256 value) internal pure returns (int128) {
848         require(value >= -2**127 && value < 2**127, "SafeCast: value doesn\'t fit in 128 bits");
849         return int128(value);
850     }
851 
852     /**
853      * @dev Returns the downcasted int64 from int256, reverting on
854      * overflow (when the input is less than smallest int64 or
855      * greater than largest int64).
856      *
857      * Counterpart to Solidity's `int64` operator.
858      *
859      * Requirements:
860      *
861      * - input must fit into 64 bits
862      *
863      * _Available since v3.1._
864      */
865     function toInt64(int256 value) internal pure returns (int64) {
866         require(value >= -2**63 && value < 2**63, "SafeCast: value doesn\'t fit in 64 bits");
867         return int64(value);
868     }
869 
870     /**
871      * @dev Returns the downcasted int32 from int256, reverting on
872      * overflow (when the input is less than smallest int32 or
873      * greater than largest int32).
874      *
875      * Counterpart to Solidity's `int32` operator.
876      *
877      * Requirements:
878      *
879      * - input must fit into 32 bits
880      *
881      * _Available since v3.1._
882      */
883     function toInt32(int256 value) internal pure returns (int32) {
884         require(value >= -2**31 && value < 2**31, "SafeCast: value doesn\'t fit in 32 bits");
885         return int32(value);
886     }
887 
888     /**
889      * @dev Returns the downcasted int16 from int256, reverting on
890      * overflow (when the input is less than smallest int16 or
891      * greater than largest int16).
892      *
893      * Counterpart to Solidity's `int16` operator.
894      *
895      * Requirements:
896      *
897      * - input must fit into 16 bits
898      *
899      * _Available since v3.1._
900      */
901     function toInt16(int256 value) internal pure returns (int16) {
902         require(value >= -2**15 && value < 2**15, "SafeCast: value doesn\'t fit in 16 bits");
903         return int16(value);
904     }
905 
906     /**
907      * @dev Returns the downcasted int8 from int256, reverting on
908      * overflow (when the input is less than smallest int8 or
909      * greater than largest int8).
910      *
911      * Counterpart to Solidity's `int8` operator.
912      *
913      * Requirements:
914      *
915      * - input must fit into 8 bits.
916      *
917      * _Available since v3.1._
918      */
919     function toInt8(int256 value) internal pure returns (int8) {
920         require(value >= -2**7 && value < 2**7, "SafeCast: value doesn\'t fit in 8 bits");
921         return int8(value);
922     }
923 
924     /**
925      * @dev Converts an unsigned uint256 into a signed int256.
926      *
927      * Requirements:
928      *
929      * - input must be less than or equal to maxInt256.
930      */
931     function toInt256(uint256 value) internal pure returns (int256) {
932         require(value < 2**255, "SafeCast: value doesn't fit in an int256");
933         return int256(value);
934     }
935 }
936 
937 // File: contracts/Interfaces/PriceCalculatorInterface.sol
938 
939 pragma solidity >=0.6.6;
940 
941 interface PriceCalculatorInterface {
942     function calculatePrice(
943         uint256 buyAmount,
944         uint256 buyAmountLimit,
945         uint256 sellAmount,
946         uint256 sellAmountLimit,
947         uint256 baseTokenPool,
948         uint256 settlementTokenPool
949     ) external view returns (uint256[5] memory);
950 }
951 
952 // File: contracts/Libraries/Enums.sol
953 
954 pragma solidity >=0.6.6;
955 
956 enum Token {TOKEN0, TOKEN1}
957 
958 // FLEX_0_1 => Swap TOKEN0 to TOKEN1, slippage is tolerate to 5%
959 // FLEX_1_0 => Swap TOKEN1 to TOKEN0, slippage is tolerate to 5%
960 // STRICT_0_1 => Swap TOKEN0 to TOKEN1, slippage is limited in 0.1%
961 // STRICT_1_0 => Swap TOKEN1 to TOKEN0, slippage is limited in 0.1%
962 enum OrderType {FLEX_0_1, FLEX_1_0, STRICT_0_1, STRICT_1_0}
963 
964 library TokenLibrary {
965     function another(Token self) internal pure returns (Token) {
966         if (self == Token.TOKEN0) {
967             return Token.TOKEN1;
968         } else {
969             return Token.TOKEN0;
970         }
971     }
972 }
973 
974 library OrderTypeLibrary {
975     function inToken(OrderType self) internal pure returns (Token) {
976         if (self == OrderType.FLEX_0_1 || self == OrderType.STRICT_0_1) {
977             return Token.TOKEN0;
978         } else {
979             return Token.TOKEN1;
980         }
981     }
982 
983     function isFlex(OrderType self) internal pure returns (bool) {
984         return self == OrderType.FLEX_0_1 || self == OrderType.FLEX_1_0;
985     }
986 
987     function isStrict(OrderType self) internal pure returns (bool) {
988         return !isFlex(self);
989     }
990 
991     function next(OrderType self) internal pure returns (OrderType) {
992         return OrderType((uint256(self) + 1) % 4);
993     }
994 
995     function isBuy(OrderType self) internal pure returns (bool) {
996         return (self == OrderType.FLEX_0_1 || self == OrderType.STRICT_0_1);
997     }
998 }
999 
1000 // File: contracts/Libraries/RateMath.sol
1001 
1002 pragma solidity >=0.6.6;
1003 
1004 
1005 library RateMath {
1006     using SafeMath for uint256;
1007     uint256 public constant RATE_POINT_MULTIPLIER = 1000000000000000000; // 10^18
1008 
1009     function getRate(uint256 a, uint256 b) internal pure returns (uint256) {
1010         return a.mul(RATE_POINT_MULTIPLIER).div(b);
1011     }
1012 
1013     function divByRate(uint256 self, uint256 rate)
1014         internal
1015         pure
1016         returns (uint256)
1017     {
1018         return self.mul(RATE_POINT_MULTIPLIER).div(rate);
1019     }
1020 
1021     function mulByRate(uint256 self, uint256 rate)
1022         internal
1023         pure
1024         returns (uint256)
1025     {
1026         return self.mul(rate).div(RATE_POINT_MULTIPLIER);
1027     }
1028 }
1029 
1030 // File: contracts/Libraries/ExecutionStatus.sol
1031 
1032 pragma solidity >=0.6.6;
1033 
1034 
1035 
1036 struct BoxExecutionStatus {
1037     OrderType partiallyRefundOrderType;
1038     uint64 partiallyRefundRate; // refundAmount/inAmount
1039     uint128 rate; // Token0/Token1
1040     uint32 boxNumber;
1041     bool onGoing;
1042 }
1043 
1044 struct BookExecutionStatus {
1045     OrderType executingOrderType;
1046     uint256 nextIndex;
1047 }
1048 
1049 library BoxExecutionStatusLibrary {
1050     using OrderTypeLibrary for OrderType;
1051 
1052     function refundRate(BoxExecutionStatus memory self, OrderType orderType)
1053         internal
1054         pure
1055         returns (uint256)
1056     {
1057         // inToken is different from refundOrderType
1058         if (self.partiallyRefundOrderType.inToken() != orderType.inToken()) {
1059             return 0;
1060         }
1061 
1062         // inToken is the same as refundOrderType
1063         // refund all of strict order and some of flex order
1064         if (self.partiallyRefundOrderType.isFlex()) {
1065             // orderType is flex
1066             if (orderType.isFlex()) {
1067                 return self.partiallyRefundRate;
1068             }
1069             // orderType is strict
1070             return RateMath.RATE_POINT_MULTIPLIER;
1071         }
1072 
1073         // refund some of strict order
1074         if (orderType.isStrict()) {
1075             return self.partiallyRefundRate;
1076         }
1077         return 0;
1078     }
1079 }
1080 
1081 // File: contracts/Libraries/OrderBox.sol
1082 
1083 pragma solidity >=0.6.6;
1084 
1085 
1086 
1087 
1088 struct OrderBox {
1089     mapping(OrderType => OrderBook) orderBooks;
1090     uint128 spreadRate;
1091     uint128 expireAt;
1092 }
1093 
1094 struct OrderBook {
1095     mapping(address => uint256) inAmounts;
1096     address[] recipients;
1097     uint256 totalInAmount;
1098 }
1099 
1100 library OrderBoxLibrary {
1101     using RateMath for uint256;
1102     using SafeMath for uint256;
1103     using TokenLibrary for Token;
1104 
1105     function newOrderBox(uint128 spreadRate, uint128 expireAt)
1106         internal
1107         pure
1108         returns (OrderBox memory)
1109     {
1110         return OrderBox({spreadRate: spreadRate, expireAt: expireAt});
1111     }
1112 
1113     function addOrder(
1114         OrderBox storage self,
1115         OrderType orderType,
1116         uint256 inAmount,
1117         address recipient
1118     ) internal {
1119         OrderBook storage orderBook = self.orderBooks[orderType];
1120         if (orderBook.inAmounts[recipient] == 0) {
1121             orderBook.recipients.push(recipient);
1122         }
1123         orderBook.inAmounts[recipient] = orderBook.inAmounts[recipient].add(
1124             inAmount
1125         );
1126         orderBook.totalInAmount = orderBook.totalInAmount.add(inAmount);
1127     }
1128 }
1129 
1130 library OrderBookLibrary {
1131     function numOfOrder(OrderBook memory self) internal pure returns (uint256) {
1132         return self.recipients.length;
1133     }
1134 }
1135 
1136 // File: contracts/BoxExchange/BoxExchange.sol
1137 
1138 pragma solidity ^0.6.6;
1139 
1140 abstract contract BoxExchange is ERC20 {
1141     using BoxExecutionStatusLibrary for BoxExecutionStatus;
1142     using OrderBoxLibrary for OrderBox;
1143     using OrderBookLibrary for OrderBook;
1144     using OrderTypeLibrary for OrderType;
1145     using TokenLibrary for Token;
1146     using RateMath for uint256;
1147     using SafeMath for uint256;
1148     using SafeCast for uint256;
1149 
1150     uint256 internal constant MARKET_FEE_RATE = 200000000000000000; // market fee taker takes 20% of spread
1151 
1152     address internal immutable factory;
1153 
1154     address internal immutable marketFeeTaker; // Address that receives market fee (i.e. Lien Token)
1155     uint128 public marketFeePool0; // Total market fee in TOKEN0
1156     uint128 public marketFeePool1; // Total market fee in TOKEN1
1157 
1158     uint128 internal reserve0; // Total Liquidity of TOKEN0
1159     uint128 internal reserve1; // Total Liquidity of TOKEN1
1160     OrderBox[] internal orderBoxes; // Array of OrderBox
1161     PriceCalculatorInterface internal immutable priceCalc; // Price Calculator
1162     BoxExecutionStatus internal boxExecutionStatus; // Struct that has information about execution of current executing OrderBox
1163     BookExecutionStatus internal bookExecutionStatus; // Struct that has information about execution of current executing OrderBook
1164 
1165     event AcceptOrders(
1166         address indexed recipient,
1167         bool indexed isBuy, // if true, this order is exchange from TOKEN0 to TOKEN1
1168         uint32 indexed boxNumber,
1169         bool isLimit, // if true, this order is STRICT order
1170         uint256 tokenIn
1171     );
1172 
1173     event MoveLiquidity(
1174         address indexed liquidityProvider,
1175         bool indexed isAdd, // if true, this order is addtion of liquidity
1176         uint256 movedToken0Amount,
1177         uint256 movedToken1Amount,
1178         uint256 sharesMoved // Amount of share that is minted or burned
1179     );
1180 
1181     event Execution(
1182         bool indexed isBuy, // if true, this order is exchange from TOKEN0 to TOKEN1
1183         uint32 indexed boxNumber,
1184         address indexed recipient,
1185         uint256 orderAmount, // Amount of token that is transferred when this order is added
1186         uint256 refundAmount, // In the same token as orderAmount
1187         uint256 outAmount // In the other token than orderAmount
1188     );
1189 
1190     event UpdateReserve(uint128 reserve0, uint128 reserve1, uint256 totalShare);
1191 
1192     event PayMarketFee(uint256 amount0, uint256 amount1);
1193 
1194     event ExecutionSummary(
1195         uint32 indexed boxNumber,
1196         uint8 partiallyRefundOrderType,
1197         uint256 rate,
1198         uint256 partiallyRefundRate,
1199         uint256 totalInAmountFLEX_0_1,
1200         uint256 totalInAmountFLEX_1_0,
1201         uint256 totalInAmountSTRICT_0_1,
1202         uint256 totalInAmountSTRICT_1_0
1203     );
1204 
1205     modifier isAmountSafe(uint256 amount) {
1206         require(amount != 0, "Amount should be bigger than 0");
1207         _;
1208     }
1209 
1210     modifier isInTime(uint256 timeout) {
1211         require(timeout > _currentOpenBoxId(), "Time out");
1212         _;
1213     }
1214 
1215     constructor(
1216         PriceCalculatorInterface _priceCalc,
1217         address _marketFeeTaker,
1218         string memory _name
1219     ) public ERC20(_name, "share") {
1220         factory = msg.sender;
1221         priceCalc = _priceCalc;
1222         marketFeeTaker = _marketFeeTaker;
1223         _setupDecimals(8); // Decimal of share token is the same as iDOL, LBT, and Lien Token
1224     }
1225 
1226     /**
1227      * @notice Shows how many boxes and orders exist before the specific order
1228      * @dev If this order does not exist, return (false, 0, 0)
1229      * @dev If this order is already executed, return (true, 0, 0)
1230      * @param recipient Recipient of this order
1231      * @param boxNumber Box ID where the order exists
1232      * @param isExecuted If true, the order is already executed
1233      * @param boxCount Counter of boxes before this order. If current executing box number is the same as boxNumber, return 1 (i.e. indexing starts from 1)
1234      * @param orderCount Counter of orders before this order. If this order is on n-th top of the queue, return n (i.e. indexing starts from 1)
1235      **/
1236     function whenToExecute(
1237         address recipient,
1238         uint256 boxNumber,
1239         bool isBuy,
1240         bool isLimit
1241     )
1242         external
1243         view
1244         returns (
1245             bool isExecuted,
1246             uint256 boxCount,
1247             uint256 orderCount
1248         )
1249     {
1250         return
1251             _whenToExecute(recipient, _getOrderType(isBuy, isLimit), boxNumber);
1252     }
1253 
1254     /**
1255      * @notice Returns summary of current exchange status
1256      * @param boxNumber Current open box ID
1257      * @param _reserve0 Current reserve of TOKEN0
1258      * @param _reserve1 Current reserve of TOKEN1
1259      * @param totalShare Total Supply of share token
1260      * @param latestSpreadRate Spread Rate in latest OrderBox
1261      * @param token0PerShareE18 Amount of TOKEN0 per 1 share token and has 18 decimal
1262      * @param token1PerShareE18 Amount of TOKEN1 per 1 share token and has 18 decimal
1263      **/
1264     function getExchangeData()
1265         external
1266         virtual
1267         view
1268         returns (
1269             uint256 boxNumber,
1270             uint256 _reserve0,
1271             uint256 _reserve1,
1272             uint256 totalShare,
1273             uint256 latestSpreadRate,
1274             uint256 token0PerShareE18,
1275             uint256 token1PerShareE18
1276         )
1277     {
1278         boxNumber = _currentOpenBoxId();
1279         (_reserve0, _reserve1) = _getReserves();
1280         latestSpreadRate = orderBoxes[boxNumber].spreadRate;
1281         totalShare = totalSupply();
1282         token0PerShareE18 = RateMath.getRate(_reserve0, totalShare);
1283         token1PerShareE18 = RateMath.getRate(_reserve1, totalShare);
1284     }
1285 
1286     /**
1287      * @notice Gets summary of Current box information (Total order amount of each OrderTypes)
1288      * @param executionStatusNumber Status of execution of this box
1289      * @param boxNumber ID of target box.
1290      **/
1291     function getBoxSummary(uint256 boxNumber)
1292         public
1293         view
1294         returns (
1295             uint256 executionStatusNumber,
1296             uint256 flexToken0InAmount,
1297             uint256 strictToken0InAmount,
1298             uint256 flexToken1InAmount,
1299             uint256 strictToken1InAmount
1300         )
1301     {
1302         // `executionStatusNumber`
1303         // 0 => This box has not been executed
1304         // 1 => This box is currently executing. (Reserves and market fee pools have already been updated)
1305         // 2 => This box has already been executed
1306         uint256 nextExecutingBoxId = boxExecutionStatus.boxNumber;
1307         flexToken0InAmount = orderBoxes[boxNumber].orderBooks[OrderType
1308             .FLEX_0_1]
1309             .totalInAmount;
1310         strictToken0InAmount = orderBoxes[boxNumber].orderBooks[OrderType
1311             .STRICT_0_1]
1312             .totalInAmount;
1313         flexToken1InAmount = orderBoxes[boxNumber].orderBooks[OrderType
1314             .FLEX_1_0]
1315             .totalInAmount;
1316         strictToken1InAmount = orderBoxes[boxNumber].orderBooks[OrderType
1317             .STRICT_1_0]
1318             .totalInAmount;
1319         if (boxNumber < nextExecutingBoxId) {
1320             executionStatusNumber = 2;
1321         } else if (
1322             boxNumber == nextExecutingBoxId && boxExecutionStatus.onGoing
1323         ) {
1324             executionStatusNumber = 1;
1325         }
1326     }
1327 
1328     /**
1329      * @notice Gets amount of order in current open box
1330      * @param account Target Address
1331      * @param orderType OrderType of target order
1332      * @return Amount of target order
1333      **/
1334     function getOrderAmount(address account, OrderType orderType)
1335         public
1336         view
1337         returns (uint256)
1338     {
1339         return
1340             orderBoxes[_currentOpenBoxId()].orderBooks[orderType]
1341                 .inAmounts[account];
1342     }
1343 
1344     // abstract functions
1345     function _feeRate() internal virtual returns (uint128);
1346 
1347     function _receiveTokens(
1348         Token token,
1349         address from,
1350         uint256 amount
1351     ) internal virtual;
1352 
1353     function _sendTokens(
1354         Token token,
1355         address to,
1356         uint256 amount
1357     ) internal virtual;
1358 
1359     function _payForOrderExecution(
1360         Token token,
1361         address to,
1362         uint256 amount
1363     ) internal virtual;
1364 
1365     function _payMarketFee(
1366         address _marketFeeTaker,
1367         uint256 amount0,
1368         uint256 amount1
1369     ) internal virtual;
1370 
1371     function _isCurrentOpenBoxExpired() internal virtual view returns (bool) {}
1372 
1373     /**
1374      * @notice User can determine the amount of share token to mint.
1375      * @dev This function can be executed only by factory
1376      * @param amount0 The amount of TOKEN0 to invest
1377      * @param amount1 The amount of TOKEN1 to invest
1378      * @param initialShare The amount of share token to mint. This defines approximate value of share token.
1379      **/
1380     function _init(
1381         uint128 amount0,
1382         uint128 amount1,
1383         uint256 initialShare
1384     ) internal virtual {
1385         require(totalSupply() == 0, "Already initialized");
1386         require(msg.sender == factory);
1387         _updateReserve(amount0, amount1);
1388         _mint(msg.sender, initialShare);
1389         _receiveTokens(Token.TOKEN0, msg.sender, amount0);
1390         _receiveTokens(Token.TOKEN1, msg.sender, amount1);
1391         _openNewBox();
1392     }
1393 
1394     /**
1395      * @dev Amount of share to mint is determined by `amount`
1396      * @param tokenType Type of token which the amount of share the LP get is calculated based on `amount`
1397      * @param amount The amount of token type of `tokenType`
1398      **/
1399     function _addLiquidity(
1400         uint256 _reserve0,
1401         uint256 _reserve1,
1402         uint256 amount,
1403         uint256 minShare,
1404         Token tokenType
1405     ) internal virtual {
1406         (uint256 amount0, uint256 amount1, uint256 share) = _calculateAmounts(
1407             amount,
1408             _reserve0,
1409             _reserve1,
1410             tokenType
1411         );
1412         require(share >= minShare, "You can't receive enough shares");
1413         _receiveTokens(Token.TOKEN0, msg.sender, amount0);
1414         _receiveTokens(Token.TOKEN1, msg.sender, amount1);
1415         _updateReserve(
1416             _reserve0.add(amount0).toUint128(),
1417             _reserve1.add(amount1).toUint128()
1418         );
1419         _mint(msg.sender, share);
1420         emit MoveLiquidity(msg.sender, true, amount0, amount1, share);
1421     }
1422 
1423     /**
1424      * @dev Amount of TOKEN0 and TOKEN1 is determined by amount of share to be burned
1425      * @param minAmount0 Minimum amount of TOKEN0 to return. If returned TOKEN0 is less than this value, revert transaction
1426      * @param minAmount1 Minimum amount of TOKEN1 to return. If returned TOKEN1 is less than this value, revert transaction
1427      * @param share Amount of share token to be burned
1428      **/
1429     function _removeLiquidity(
1430         uint256 minAmount0,
1431         uint256 minAmount1,
1432         uint256 share
1433     ) internal virtual {
1434         (uint256 _reserve0, uint256 _reserve1) = _getReserves(); // gas savings
1435         uint256 _totalSupply = totalSupply();
1436         uint256 amount0 = _reserve0.mul(share).div(_totalSupply);
1437         uint256 amount1 = _reserve1.mul(share).div(_totalSupply);
1438         require(
1439             amount0 >= minAmount0 && amount1 >= minAmount1,
1440             "You can't receive enough tokens"
1441         );
1442         _updateReserve(
1443             _reserve0.sub(amount0).toUint128(),
1444             _reserve1.sub(amount1).toUint128()
1445         );
1446         _burn(msg.sender, share);
1447         _sendTokens(Token.TOKEN0, msg.sender, amount0);
1448         _sendTokens(Token.TOKEN1, msg.sender, amount1);
1449         emit MoveLiquidity(msg.sender, false, amount0, amount1, share);
1450     }
1451 
1452     /**
1453      * @dev If there is some OrderBox to be executed, try execute 5 orders
1454      * @dev If currentBox has expired, open new box
1455      * @param orderType Type of order
1456      * @param inAmount Amount of token to be exchanged
1457      * @param recipient Recipient of swapped token. If this value is address(0), msg.sender is the recipient
1458      **/
1459     function _addOrder(
1460         OrderType orderType,
1461         uint256 inAmount,
1462         address recipient
1463     ) internal virtual {
1464         _rotateBox();
1465         uint256 _currentOpenBoxId = _currentOpenBoxId();
1466         _executeOrders(5, _currentOpenBoxId);
1467         if (recipient == address(0)) {
1468             recipient = msg.sender;
1469         }
1470         _receiveTokens(orderType.inToken(), msg.sender, inAmount);
1471         orderBoxes[_currentOpenBoxId].addOrder(orderType, inAmount, recipient);
1472         emit AcceptOrders(
1473             recipient,
1474             orderType.isBuy(),
1475             uint32(_currentOpenBoxId),
1476             orderType.isStrict(),
1477             inAmount
1478         );
1479     }
1480 
1481     /**
1482      * @dev Triggers executeOrders()
1483      * @param maxOrderNum Number of orders to execute (if no order is left, stop execution)
1484      **/
1485     function _triggerExecuteOrders(uint8 maxOrderNum) internal virtual {
1486         _executeOrders(maxOrderNum, _currentOpenBoxId());
1487     }
1488 
1489     /**
1490      * @dev Triggers PayMarketFee() and update marketFeePool to 0
1491      **/
1492     function _triggerPayMarketFee() internal virtual {
1493         (
1494             uint256 _marketFeePool0,
1495             uint256 _marketFeePool1
1496         ) = _getMarketFeePools();
1497         _updateMarketFeePool(0, 0);
1498 
1499         emit PayMarketFee(_marketFeePool0, _marketFeePool1);
1500         _payMarketFee(marketFeeTaker, _marketFeePool0, _marketFeePool1);
1501     }
1502 
1503     // When open new box, creates new OrderBox with spreadRate and block number of expiretion, then pushes it to orderBoxes
1504     function _openNewBox() internal virtual {
1505         orderBoxes.push(
1506             OrderBoxLibrary.newOrderBox(
1507                 _feeRate(),
1508                 (block.number + 2).toUint32()
1509             )
1510         );
1511     }
1512 
1513     function _rotateBox() private {
1514         // if current open box has expired
1515         if (_isCurrentOpenBoxExpired()) {
1516             _openNewBox();
1517         }
1518     }
1519 
1520     /**
1521      * @param maxOrderNum Number of orders to execute (if no order is left, stoppes execution)
1522      * @param _currentOpenBoxId Current box ID (_currentOpenBoxID() is already run in _addOrder() or _triggerExecuteOrders()
1523      **/
1524     function _executeOrders(uint256 maxOrderNum, uint256 _currentOpenBoxId)
1525         private
1526     {
1527         BoxExecutionStatus memory _boxExecutionStatus = boxExecutionStatus;
1528         BookExecutionStatus memory _bookExecutionStatus = bookExecutionStatus;
1529         // if _boxExecutionStatus.boxNumber is current open and not expired box, won't execute.
1530         // if _boxExecutionStatus.boxNumber is more than currentOpenBoxId, the newest box is already executed.
1531         if (
1532             _boxExecutionStatus.boxNumber >= _currentOpenBoxId &&
1533             (!_isCurrentOpenBoxExpired() ||
1534                 _boxExecutionStatus.boxNumber > _currentOpenBoxId)
1535         ) {
1536             return;
1537         }
1538         if (!_boxExecutionStatus.onGoing) {
1539             // get rates and start new box execution
1540             // before start new box execution, updates reserves.
1541             {
1542                 (
1543                     OrderType partiallyRefundOrderType,
1544                     uint256 partiallyRefundRate,
1545                     uint256 rate
1546                 ) = _getExecutionRatesAndUpdateReserve(
1547                     _boxExecutionStatus.boxNumber
1548                 );
1549                 _boxExecutionStatus
1550                     .partiallyRefundOrderType = partiallyRefundOrderType;
1551                 _boxExecutionStatus.partiallyRefundRate = partiallyRefundRate
1552                     .toUint64();
1553                 _boxExecutionStatus.rate = rate.toUint128();
1554                 _boxExecutionStatus.onGoing = true;
1555                 _bookExecutionStatus.executingOrderType = OrderType(0);
1556                 _bookExecutionStatus.nextIndex = 0;
1557             }
1558         }
1559         // execute orders in one book
1560         // reducing maxOrderNum to avoid stack to deep
1561         while (maxOrderNum != 0) {
1562             OrderBook storage executionBook = orderBoxes[_boxExecutionStatus
1563                 .boxNumber]
1564                 .orderBooks[_bookExecutionStatus.executingOrderType];
1565             (
1566                 bool isBookFinished,
1567                 uint256 nextIndex,
1568                 uint256 executedOrderNum
1569             ) = _executeOrdersInBook(
1570                 executionBook,
1571                 _bookExecutionStatus.executingOrderType.inToken(),
1572                 _bookExecutionStatus.nextIndex,
1573                 _boxExecutionStatus.refundRate(
1574                     _bookExecutionStatus.executingOrderType
1575                 ),
1576                 _boxExecutionStatus.rate,
1577                 orderBoxes[_boxExecutionStatus.boxNumber].spreadRate,
1578                 maxOrderNum
1579             );
1580             if (isBookFinished) {
1581                 bool isBoxFinished = _isBoxFinished(
1582                     orderBoxes[_boxExecutionStatus.boxNumber],
1583                     _bookExecutionStatus.executingOrderType
1584                 );
1585                 delete orderBoxes[_boxExecutionStatus.boxNumber]
1586                     .orderBooks[_bookExecutionStatus.executingOrderType];
1587 
1588                 // update book execution status and box execution status
1589                 if (isBoxFinished) {
1590                     _boxExecutionStatus.boxNumber += 1;
1591                     _boxExecutionStatus.onGoing = false;
1592                     boxExecutionStatus = _boxExecutionStatus;
1593 
1594                     return; // no need to update bookExecutionStatus;
1595                 }
1596                 _bookExecutionStatus.executingOrderType = _bookExecutionStatus
1597                     .executingOrderType
1598                     .next();
1599             }
1600             _bookExecutionStatus.nextIndex = nextIndex.toUint32();
1601             maxOrderNum -= executedOrderNum;
1602         }
1603         boxExecutionStatus = _boxExecutionStatus;
1604         bookExecutionStatus = _bookExecutionStatus;
1605     }
1606 
1607     /**
1608      * @notice Executes each OrderBook
1609      * @param orderBook Target OrderBook
1610      * @param rate Rate of swap
1611      * @param refundRate Refund rate in this OrderType
1612      * @param maxOrderNum Max number of orders to execute in this book
1613      * @return If execution is finished, return true
1614      * @return Next index to execute. If execution is finished, return 0
1615      * @return Number of orders executed
1616      **/
1617     function _executeOrdersInBook(
1618         OrderBook storage orderBook,
1619         Token inToken,
1620         uint256 initialIndex,
1621         uint256 refundRate,
1622         uint256 rate,
1623         uint256 spreadRate,
1624         uint256 maxOrderNum
1625     )
1626         private
1627         returns (
1628             bool,
1629             uint256,
1630             uint256
1631         )
1632     {
1633         uint256 index;
1634         uint256 numOfOrder = orderBook.numOfOrder();
1635         for (
1636             index = initialIndex;
1637             index - initialIndex < maxOrderNum;
1638             index++
1639         ) {
1640             if (index >= numOfOrder) {
1641                 return (true, 0, index - initialIndex);
1642             }
1643             address recipient = orderBook.recipients[index];
1644             _executeOrder(
1645                 inToken,
1646                 recipient,
1647                 orderBook.inAmounts[recipient],
1648                 refundRate,
1649                 rate,
1650                 spreadRate
1651             );
1652         }
1653         if (index >= numOfOrder) {
1654             return (true, 0, index - initialIndex);
1655         }
1656         return (false, index, index - initialIndex);
1657     }
1658 
1659     /**
1660      * @dev Executes each order
1661      * @param inToken type of token
1662      * @param recipient Recipient of Token
1663      * @param inAmount Amount of token
1664      * @param refundRate Refund rate in this OrderType
1665      * @param rate Rate of swap
1666      * @param spreadRate Spread rate in this box
1667      **/
1668     function _executeOrder(
1669         Token inToken,
1670         address recipient,
1671         uint256 inAmount,
1672         uint256 refundRate,
1673         uint256 rate,
1674         uint256 spreadRate
1675     ) internal {
1676         Token outToken = inToken.another();
1677         // refundAmount = inAmount * refundRate
1678         uint256 refundAmount = inAmount.mulByRate(refundRate);
1679         // executingInAmountWithoutSpread = (inAmount - refundAmount) / (1+spreadRate)
1680         uint256 executingInAmountWithoutSpread = inAmount
1681             .sub(refundAmount)
1682             .divByRate(RateMath.RATE_POINT_MULTIPLIER.add(spreadRate));
1683         // spread = executingInAmountWithoutSpread * spreadRate
1684         // = (inAmount - refundAmount ) * ( 1 - 1 /( 1 + spreadRate))
1685         uint256 outAmount = _otherAmountBasedOnRate(
1686             inToken,
1687             executingInAmountWithoutSpread,
1688             rate
1689         );
1690         _payForOrderExecution(inToken, recipient, refundAmount);
1691         _payForOrderExecution(outToken, recipient, outAmount);
1692         emit Execution(
1693             (inToken == Token.TOKEN0),
1694             uint32(_currentOpenBoxId()),
1695             recipient,
1696             inAmount,
1697             refundAmount,
1698             outAmount
1699         );
1700     }
1701 
1702     /**
1703      * @notice Updates reserves and market fee pools
1704      * @param spreadRate Spread rate in the box
1705      * @param executingAmount0WithoutSpread Executed amount of TOKEN0 in this box
1706      * @param executingAmount1WithoutSpread Executed amount of TOKEN1 in this box
1707      * @param rate Rate of swap
1708      **/
1709     function _updateReservesAndMarketFeePoolByExecution(
1710         uint256 spreadRate,
1711         uint256 executingAmount0WithoutSpread,
1712         uint256 executingAmount1WithoutSpread,
1713         uint256 rate
1714     ) internal virtual {
1715         uint256 newReserve0;
1716         uint256 newReserve1;
1717         uint256 newMarketFeePool0;
1718         uint256 newMarketFeePool1;
1719         {
1720             (
1721                 uint256 differenceOfReserve,
1722                 uint256 differenceOfMarketFee
1723             ) = _calculateNewReserveAndMarketFeePool(
1724                 spreadRate,
1725                 executingAmount0WithoutSpread,
1726                 executingAmount1WithoutSpread,
1727                 rate,
1728                 Token.TOKEN0
1729             );
1730             newReserve0 = reserve0 + differenceOfReserve;
1731             newMarketFeePool0 = marketFeePool0 + differenceOfMarketFee;
1732         }
1733         {
1734             (
1735                 uint256 differenceOfReserve,
1736                 uint256 differenceOfMarketFee
1737             ) = _calculateNewReserveAndMarketFeePool(
1738                 spreadRate,
1739                 executingAmount1WithoutSpread,
1740                 executingAmount0WithoutSpread,
1741                 rate,
1742                 Token.TOKEN1
1743             );
1744             newReserve1 = reserve1 + differenceOfReserve;
1745             newMarketFeePool1 = marketFeePool1 + differenceOfMarketFee;
1746         }
1747         _updateReserve(newReserve0.toUint128(), newReserve1.toUint128());
1748         _updateMarketFeePool(
1749             newMarketFeePool0.toUint128(),
1750             newMarketFeePool1.toUint128()
1751         );
1752     }
1753 
1754     function _whenToExecute(
1755         address recipient,
1756         uint256 orderTypeCount,
1757         uint256 boxNumber
1758     )
1759         internal
1760         view
1761         returns (
1762             bool isExecuted,
1763             uint256 boxCount,
1764             uint256 orderCount
1765         )
1766     {
1767         if (boxNumber > _currentOpenBoxId()) {
1768             return (false, 0, 0);
1769         }
1770         OrderBox storage yourOrderBox = orderBoxes[boxNumber];
1771         address[] memory recipients = yourOrderBox.orderBooks[OrderType(
1772             orderTypeCount
1773         )]
1774             .recipients;
1775         uint256 nextExecutingBoxId = boxExecutionStatus.boxNumber;
1776         uint256 nextIndex = bookExecutionStatus.nextIndex;
1777         uint256 nextType = uint256(bookExecutionStatus.executingOrderType);
1778         bool onGoing = boxExecutionStatus.onGoing;
1779         bool isExist;
1780         uint256 place;
1781         for (uint256 j = 0; j != recipients.length; j++) {
1782             if (recipients[j] == recipient) {
1783                 isExist = true;
1784                 place = j;
1785                 break;
1786             }
1787         }
1788 
1789         // If current box number exceeds boxNumber, the target box has already been executed
1790         // If current box number is equal to boxNumber, and OrderType or index exceeds that of the target order, the target box has already been executed
1791         if (
1792             (boxNumber < nextExecutingBoxId) ||
1793             ((onGoing && (boxNumber == nextExecutingBoxId)) &&
1794                 ((orderTypeCount < nextType) ||
1795                     ((orderTypeCount == nextType) && (place < nextIndex))))
1796         ) {
1797             return (true, 0, 0);
1798         }
1799 
1800         if (!isExist) {
1801             return (false, 0, 0);
1802         }
1803 
1804         // Total number of orders before the target OrderType
1805         uint256 counts;
1806         if (boxNumber == nextExecutingBoxId && onGoing) {
1807             for (uint256 i = nextType; i < orderTypeCount; i++) {
1808                 counts += yourOrderBox.orderBooks[OrderType(i)].numOfOrder();
1809             }
1810             boxCount = 1;
1811             orderCount = counts.add(place).sub(nextIndex) + 1;
1812         } else {
1813             for (uint256 i = 0; i != orderTypeCount; i++) {
1814                 counts += yourOrderBox.orderBooks[OrderType(i)].numOfOrder();
1815             }
1816             boxCount = boxNumber.sub(nextExecutingBoxId) + 1;
1817             orderCount = counts.add(place) + 1;
1818         }
1819     }
1820 
1821     function _getReserves()
1822         internal
1823         view
1824         returns (uint256 _reserve0, uint256 _reserve1)
1825     {
1826         _reserve0 = reserve0;
1827         _reserve1 = reserve1;
1828     }
1829 
1830     function _getMarketFeePools()
1831         internal
1832         view
1833         returns (uint256 _marketFeePool0, uint256 _marketFeePool1)
1834     {
1835         _marketFeePool0 = marketFeePool0;
1836         _marketFeePool1 = marketFeePool1;
1837     }
1838 
1839     function _updateReserve(uint128 newReserve0, uint128 newReserve1) internal {
1840         reserve0 = newReserve0;
1841         reserve1 = newReserve1;
1842         emit UpdateReserve(newReserve0, newReserve1, totalSupply());
1843     }
1844 
1845     function _calculatePriceWrapper(
1846         uint256 flexToken0InWithoutSpread,
1847         uint256 strictToken0InWithoutSpread,
1848         uint256 flexToken1InWithoutSpread,
1849         uint256 strictToken1InWithoutSpread,
1850         uint256 _reserve0,
1851         uint256 _reserve1
1852     )
1853         internal
1854         view
1855         returns (
1856             uint256 rate,
1857             uint256 refundStatus,
1858             uint256 partiallyRefundRate,
1859             uint256 executingAmount0,
1860             uint256 executingAmount1
1861         )
1862     {
1863         uint256[5] memory data = priceCalc.calculatePrice(
1864             flexToken0InWithoutSpread,
1865             strictToken0InWithoutSpread,
1866             flexToken1InWithoutSpread,
1867             strictToken1InWithoutSpread,
1868             _reserve0,
1869             _reserve1
1870         );
1871         return (data[0], data[1], data[2], data[3], data[4]);
1872     }
1873 
1874     /**
1875      * @param rate0Per1 Token0 / Token1 * RATE_POINT_MULTIPLIER
1876      */
1877     function _otherAmountBasedOnRate(
1878         Token token,
1879         uint256 amount,
1880         uint256 rate0Per1
1881     ) internal pure returns (uint256) {
1882         if (token == Token.TOKEN0) {
1883             return amount.mulByRate(rate0Per1);
1884         } else {
1885             return amount.divByRate(rate0Per1);
1886         }
1887     }
1888 
1889     function _currentOpenBoxId() internal view returns (uint256) {
1890         return orderBoxes.length - 1;
1891     }
1892 
1893     /**
1894      * @notice Gets OrderType in uint
1895      **/
1896     function _getOrderType(bool isBuy, bool isLimit)
1897         internal
1898         pure
1899         returns (uint256 orderTypeCount)
1900     {
1901         if (isBuy && isLimit) {
1902             orderTypeCount = 2;
1903         } else if (!isBuy) {
1904             if (isLimit) {
1905                 orderTypeCount = 3;
1906             } else {
1907                 orderTypeCount = 1;
1908             }
1909         }
1910     }
1911 
1912     function _updateMarketFeePool(
1913         uint128 newMarketFeePool0,
1914         uint128 newMarketFeePool1
1915     ) private {
1916         marketFeePool0 = newMarketFeePool0;
1917         marketFeePool1 = newMarketFeePool1;
1918     }
1919 
1920     function _calculateAmounts(
1921         uint256 amount,
1922         uint256 _reserve0,
1923         uint256 _reserve1,
1924         Token tokenType
1925     )
1926         private
1927         view
1928         returns (
1929             uint256,
1930             uint256,
1931             uint256
1932         )
1933     {
1934         if (tokenType == Token.TOKEN0) {
1935             return (
1936                 amount,
1937                 amount.mul(_reserve1).div(_reserve0),
1938                 amount.mul(totalSupply()).div(_reserve0)
1939             );
1940         } else {
1941             return (
1942                 amount.mul(_reserve0).div(_reserve1),
1943                 amount,
1944                 amount.mul(totalSupply()).div(_reserve1)
1945             );
1946         }
1947     }
1948 
1949     function _priceCalculateRates(
1950         OrderBox storage orderBox,
1951         uint256 totalInAmountFLEX_0_1,
1952         uint256 totalInAmountFLEX_1_0,
1953         uint256 totalInAmountSTRICT_0_1,
1954         uint256 totalInAmountSTRICT_1_0
1955     )
1956         private
1957         view
1958         returns (
1959             uint256 rate,
1960             uint256 refundStatus,
1961             uint256 partiallyRefundRate,
1962             uint256 executingAmount0,
1963             uint256 executingAmount1
1964         )
1965     {
1966         uint256 withoutSpreadRate = RateMath.RATE_POINT_MULTIPLIER +
1967             orderBox.spreadRate;
1968         return
1969             _calculatePriceWrapper(
1970                 totalInAmountFLEX_0_1.divByRate(withoutSpreadRate),
1971                 totalInAmountSTRICT_0_1.divByRate(withoutSpreadRate),
1972                 totalInAmountFLEX_1_0.divByRate(withoutSpreadRate),
1973                 totalInAmountSTRICT_1_0.divByRate(withoutSpreadRate),
1974                 reserve0,
1975                 reserve1
1976             );
1977     }
1978 
1979     function _getExecutionRatesAndUpdateReserve(uint32 boxNumber)
1980         private
1981         returns (
1982             OrderType partiallyRefundOrderType,
1983             uint256 partiallyRefundRate,
1984             uint256 rate
1985         )
1986     {
1987         OrderBox storage orderBox = orderBoxes[boxNumber];
1988         // `refundStatus`
1989         // 0 => no_refund
1990         // 1 => refund some of strictToken0
1991         // 2 => refund all strictToken0 and some of flexToken0
1992         // 3 => refund some of strictToken1
1993         // 4 => refund all strictToken1 and some of flexToken1
1994         uint256 refundStatus;
1995         uint256 executingAmount0WithoutSpread;
1996         uint256 executingAmount1WithoutSpread;
1997         uint256 totalInAmountFLEX_0_1 = orderBox.orderBooks[OrderType.FLEX_0_1]
1998             .totalInAmount;
1999         uint256 totalInAmountFLEX_1_0 = orderBox.orderBooks[OrderType.FLEX_1_0]
2000             .totalInAmount;
2001         uint256 totalInAmountSTRICT_0_1 = orderBox.orderBooks[OrderType
2002             .STRICT_0_1]
2003             .totalInAmount;
2004         uint256 totalInAmountSTRICT_1_0 = orderBox.orderBooks[OrderType
2005             .STRICT_1_0]
2006             .totalInAmount;
2007         (
2008             rate,
2009             refundStatus,
2010             partiallyRefundRate,
2011             executingAmount0WithoutSpread,
2012             executingAmount1WithoutSpread
2013         ) = _priceCalculateRates(
2014             orderBox,
2015             totalInAmountFLEX_0_1,
2016             totalInAmountFLEX_1_0,
2017             totalInAmountSTRICT_0_1,
2018             totalInAmountSTRICT_1_0
2019         );
2020 
2021         {
2022             if (refundStatus == 0) {
2023                 partiallyRefundOrderType = OrderType.STRICT_0_1;
2024                 //refundRate = 0;
2025             } else if (refundStatus == 1) {
2026                 partiallyRefundOrderType = OrderType.STRICT_0_1;
2027             } else if (refundStatus == 2) {
2028                 partiallyRefundOrderType = OrderType.FLEX_0_1;
2029             } else if (refundStatus == 3) {
2030                 partiallyRefundOrderType = OrderType.STRICT_1_0;
2031             } else if (refundStatus == 4) {
2032                 partiallyRefundOrderType = OrderType.FLEX_1_0;
2033             }
2034         }
2035         emit ExecutionSummary(
2036             boxNumber,
2037             uint8(partiallyRefundOrderType),
2038             rate,
2039             partiallyRefundRate,
2040             totalInAmountFLEX_0_1,
2041             totalInAmountFLEX_1_0,
2042             totalInAmountSTRICT_0_1,
2043             totalInAmountSTRICT_1_0
2044         );
2045         _updateReservesAndMarketFeePoolByExecution(
2046             orderBox.spreadRate,
2047             executingAmount0WithoutSpread,
2048             executingAmount1WithoutSpread,
2049             rate
2050         );
2051     }
2052 
2053     /**
2054      * @notice Detects if this OrderBox is finished
2055      * @param orders Target OrderBox
2056      * @param lastFinishedOrderType Latest OrderType which is executed
2057      **/
2058     function _isBoxFinished(
2059         OrderBox storage orders,
2060         OrderType lastFinishedOrderType
2061     ) private view returns (bool) {
2062         // If orderType is STRICT_1_0, no book is left
2063         if (lastFinishedOrderType == OrderType.STRICT_1_0) {
2064             return true;
2065         }
2066         for (uint256 i = uint256(lastFinishedOrderType.next()); i != 4; i++) {
2067             OrderBook memory book = orders.orderBooks[OrderType(i)];
2068             // If OrderBook has some order return false
2069             if (book.numOfOrder() != 0) {
2070                 return false;
2071             }
2072         }
2073         return true;
2074     }
2075 
2076     function _calculateNewReserveAndMarketFeePool(
2077         uint256 spreadRate,
2078         uint256 executingAmountWithoutSpread,
2079         uint256 anotherExecutingAmountWithoutSpread,
2080         uint256 rate,
2081         Token tokenType
2082     ) internal returns (uint256, uint256) {
2083         uint256 totalSpread = executingAmountWithoutSpread.mulByRate(
2084             spreadRate
2085         );
2086         uint256 marketFee = totalSpread.mulByRate(MARKET_FEE_RATE);
2087         uint256 newReserve = executingAmountWithoutSpread +
2088             (totalSpread - marketFee) -
2089             _otherAmountBasedOnRate(
2090                 tokenType.another(),
2091                 anotherExecutingAmountWithoutSpread,
2092                 rate
2093             );
2094         return (newReserve, marketFee);
2095     }
2096 
2097     function _getTokenType(bool isBuy, bool isStrict)
2098         internal
2099         pure
2100         returns (OrderType)
2101     {
2102         if (isBuy) {
2103             if (isStrict) {
2104                 return OrderType.STRICT_0_1;
2105             } else {
2106                 return OrderType.FLEX_0_1;
2107             }
2108         } else {
2109             if (isStrict) {
2110                 return OrderType.STRICT_1_0;
2111             } else {
2112                 return OrderType.FLEX_1_0;
2113             }
2114         }
2115     }
2116 }
2117 
2118 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
2119 
2120 // SPDX-License-Identifier: MIT
2121 
2122 pragma solidity ^0.6.0;
2123 
2124 
2125 
2126 
2127 /**
2128  * @title SafeERC20
2129  * @dev Wrappers around ERC20 operations that throw on failure (when the token
2130  * contract returns false). Tokens that return no value (and instead revert or
2131  * throw on failure) are also supported, non-reverting calls are assumed to be
2132  * successful.
2133  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
2134  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
2135  */
2136 library SafeERC20 {
2137     using SafeMath for uint256;
2138     using Address for address;
2139 
2140     function safeTransfer(IERC20 token, address to, uint256 value) internal {
2141         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
2142     }
2143 
2144     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
2145         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
2146     }
2147 
2148     /**
2149      * @dev Deprecated. This function has issues similar to the ones found in
2150      * {IERC20-approve}, and its usage is discouraged.
2151      *
2152      * Whenever possible, use {safeIncreaseAllowance} and
2153      * {safeDecreaseAllowance} instead.
2154      */
2155     function safeApprove(IERC20 token, address spender, uint256 value) internal {
2156         // safeApprove should only be called when setting an initial allowance,
2157         // or when resetting it to zero. To increase and decrease it, use
2158         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
2159         // solhint-disable-next-line max-line-length
2160         require((value == 0) || (token.allowance(address(this), spender) == 0),
2161             "SafeERC20: approve from non-zero to non-zero allowance"
2162         );
2163         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
2164     }
2165 
2166     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
2167         uint256 newAllowance = token.allowance(address(this), spender).add(value);
2168         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2169     }
2170 
2171     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
2172         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
2173         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2174     }
2175 
2176     /**
2177      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
2178      * on the return value: the return value is optional (but if data is returned, it must not be false).
2179      * @param token The token targeted by the call.
2180      * @param data The call data (encoded using abi.encode or one of its variants).
2181      */
2182     function _callOptionalReturn(IERC20 token, bytes memory data) private {
2183         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
2184         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
2185         // the target address contains contract code and also asserts for success in the low-level call.
2186 
2187         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
2188         if (returndata.length > 0) { // Return data is optional
2189             // solhint-disable-next-line max-line-length
2190             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
2191         }
2192     }
2193 }
2194 
2195 // File: contracts/Interfaces/ERC20Interface.sol
2196 
2197 pragma solidity >=0.6.6;
2198 
2199 
2200 interface ERC20Interface is IERC20 {
2201     function name() external view returns (string memory);
2202 }
2203 
2204 // File: contracts/Interfaces/OracleInterface.sol
2205 
2206 pragma solidity >=0.6.6;
2207 
2208 interface OracleInterface {
2209     function latestPrice() external returns (uint256);
2210 
2211     function getVolatility() external returns (uint256);
2212 
2213     function latestId() external returns (uint256);
2214 }
2215 
2216 // File: contracts/Interfaces/SpreadCalculatorInterface.sol
2217 
2218 pragma solidity >=0.6.6;
2219 
2220 
2221 interface SpreadCalculatorInterface {
2222     function calculateCurrentSpread(
2223         uint256 _maturity,
2224         uint256 _strikePrice,
2225         OracleInterface oracle
2226     ) external returns (uint128);
2227 
2228     function calculateSpreadByAssetVolatility(OracleInterface oracle)
2229         external
2230         returns (uint128);
2231 }
2232 
2233 // File: contracts/BoxExchange/ETHBoxExchange/ETHBoxExchange.sol
2234 
2235 pragma solidity >=0.6.6;
2236 
2237 
2238 
2239 
2240 
2241 
2242 abstract contract ETHBoxExchange is BoxExchange {
2243     using SafeERC20 for ERC20Interface;
2244 
2245     ERC20Interface public immutable token; // token0
2246     // ETH is token1
2247     SpreadCalculatorInterface internal immutable spreadCalc;
2248     OracleInterface internal immutable oracle;
2249 
2250     mapping(address => uint256) internal ethBalances; // This balance increased by execution or refund
2251 
2252     event SpreadRate(uint128 indexed boxNumber, uint128 spreadRate);
2253 
2254     /**
2255      * @param _token ERC20 contract
2256      * @param _priceCalc Price Calculator contract
2257      * @param _marketFeeTaker Address of market fee taker (i.e. Lien Token)
2258      * @param _spreadCalc Spread Calculator contract
2259      * @param _oracle Oracle contract of token/ETH
2260      * @param _name Name of share token
2261      **/
2262 
2263     constructor(
2264         ERC20Interface _token,
2265         PriceCalculatorInterface _priceCalc,
2266         address _marketFeeTaker,
2267         SpreadCalculatorInterface _spreadCalc,
2268         OracleInterface _oracle,
2269         string memory _name
2270     ) public BoxExchange(_priceCalc, _marketFeeTaker, _name) {
2271         token = _token;
2272         spreadCalc = _spreadCalc;
2273         oracle = _oracle;
2274     }
2275 
2276     /**
2277      * @notice User can decide first supply of Share token
2278      **/
2279     function initializeExchange(uint256 tokenAmount, uint256 initialShare)
2280         external
2281         payable
2282     {
2283         _init(uint128(tokenAmount), uint128(msg.value), initialShare);
2284     }
2285 
2286     /**
2287      * @param timeout Revert if nextBoxNumber exceeds `timeout`
2288      * @param recipient Recipient of swapped token. If recipient == address(0), recipient is msg.sender
2289      * @param isLimit Whether the order restricts a large slippage.
2290      * @dev if isLimit is true and reserve0/reserve1 * 0.999 < rate, the order will be executed, otherwise ETH will be refunded
2291      * @dev if isLimit is false and reserve0/reserve1 * 0.95 < rate, the order will be executed, otherwise ETH will be refunded
2292      **/
2293     function orderEthToToken(
2294         uint256 timeout,
2295         address recipient,
2296         bool isLimit
2297     ) external payable isAmountSafe(msg.value) isInTime(timeout) {
2298         OrderType orderType = _getTokenType(false, isLimit);
2299         _addOrder(orderType, msg.value, recipient);
2300     }
2301 
2302     /**
2303      * @param timeout Revert if nextBoxNumber exceeds timeout
2304      * @param recipient Recipient of swapped token. If recipient == address(0), recipient is msg.sender
2305      * @param tokenAmount Amount of token that should be approved before executing this function
2306      * @param isLimit Whether the order restricts a large slippage.
2307      * @dev if isLimit is true and reserve0/reserve1 * 1.001 >  `rate`, the order will be executed, otherwise token will be refunded
2308      * @dev if isLimit is false and reserve0/reserve1 * 1.05 > `rate`, the order will be executed, otherwise token will be refunded
2309      **/
2310     function orderTokenToEth(
2311         uint256 timeout,
2312         address recipient,
2313         uint256 tokenAmount,
2314         bool isLimit
2315     ) external isAmountSafe(tokenAmount) isInTime(timeout) {
2316         OrderType orderType = _getTokenType(true, isLimit);
2317         _addOrder(orderType, tokenAmount, recipient);
2318     }
2319 
2320     /**
2321      * @notice LP provides liquidity and receives share token.
2322      * @notice iDOL required is calculated based on msg.value
2323      * @param timeout Revert if nextBoxNumber exceeds `timeout`
2324      * @param _minShares Minimum amount of share token LP will receive. If amount of share token is less than  `_minShares`, revert the transaction
2325      **/
2326     function addLiquidity(uint256 timeout, uint256 _minShares)
2327         external
2328         payable
2329         isAmountSafe(msg.value)
2330         isInTime(timeout)
2331     {
2332         (uint256 _reserve0, uint256 _reserve1) = _getReserves(); // gas savings
2333         _addLiquidity(
2334             _reserve0,
2335             _reserve1,
2336             msg.value,
2337             _minShares,
2338             Token.TOKEN1
2339         );
2340     }
2341 
2342     /**
2343      * @notice LP burns share token and receives ERC20 token and ETH.
2344      * @param timeout Revert if nextBoxNumber exceeds `timeout`
2345      * @param minEth Minimum amount of ETH LP will receive. If amount of ERC20 token is less than `minEth`, revert the transaction
2346      * @param minTokens Minimum amount of ERC20 token  LP will receive. If amount of LBT is less than `minTokens`, revert the transaction
2347      * @param sharesBurned Amount of share token to be burned
2348      **/
2349     function removeLiquidity(
2350         uint256 timeout,
2351         uint256 minEth,
2352         uint256 minTokens,
2353         uint256 sharesBurned
2354     ) external isInTime(timeout) {
2355         _removeLiquidity(minTokens, minEth, sharesBurned);
2356     }
2357 
2358     /**
2359      * @notice Executes orders that are unexecuted
2360      * @param maxOrderNum Max number of orders to be executed
2361      **/
2362     function executeUnexecutedBox(uint8 maxOrderNum) external {
2363         _triggerExecuteOrders(maxOrderNum);
2364     }
2365 
2366     /**
2367      * @notice Sends market fee to Lien Token
2368      **/
2369     function sendMarketFeeToLien() external {
2370         _triggerPayMarketFee();
2371     }
2372 
2373     // definitions of unique functions
2374     /**
2375      * @notice Withdraws ETH in ethBalances and set ethBalance of msg.sender to 0
2376      **/
2377     function withdrawETH() external {
2378         uint256 ethBalance = ethBalances[msg.sender];
2379         ethBalances[msg.sender] = 0;
2380         _transferEth(msg.sender, ethBalance);
2381     }
2382 
2383     /**
2384      * @notice Gets ethBalance of `recipient`
2385      * @param recipient Target address
2386      **/
2387     function getETHBalance(address recipient) external view returns (uint256) {
2388         return ethBalances[recipient];
2389     }
2390 
2391     // definition of abstract functions
2392     function _feeRate() internal override returns (uint128) {
2393         return spreadCalc.calculateSpreadByAssetVolatility(oracle);
2394     }
2395 
2396     function _receiveTokens(
2397         Token tokenType,
2398         address from,
2399         uint256 amount
2400     ) internal override {
2401         if (tokenType == Token.TOKEN0) {
2402             token.safeTransferFrom(from, address(this), amount);
2403         } else {
2404             require(msg.value == amount, "Incorrect ETH amount");
2405         }
2406     }
2407 
2408     function _sendTokens(
2409         Token tokenType,
2410         address to,
2411         uint256 amount
2412     ) internal override {
2413         if (tokenType == Token.TOKEN0) {
2414             token.safeTransfer(to, amount);
2415         } else {
2416             _transferEth(to, amount);
2417         }
2418     }
2419 
2420     function _payMarketFee(
2421         address _marketFeeTaker,
2422         uint256 amount0,
2423         uint256 amount1
2424     ) internal override {
2425         if (amount0 != 0) {
2426             token.safeTransfer(_marketFeeTaker, amount0);
2427         }
2428         if (amount1 != 0) {
2429             _transferEth(_marketFeeTaker, amount1);
2430         }
2431     }
2432 
2433     function _payForOrderExecution(
2434         Token tokenType,
2435         address to,
2436         uint256 amount
2437     ) internal override {
2438         if (tokenType == Token.TOKEN0) {
2439             token.safeTransfer(to, amount);
2440         } else {
2441             ethBalances[to] += amount;
2442         }
2443     }
2444 
2445     function _isCurrentOpenBoxExpired() internal override view returns (bool) {
2446         return block.number >= orderBoxes[_currentOpenBoxId()].expireAt;
2447     }
2448 
2449     function _openNewBox() internal override {
2450         super._openNewBox();
2451         uint256 _boxNumber = _currentOpenBoxId();
2452         emit SpreadRate(
2453             _boxNumber.toUint128(),
2454             orderBoxes[_boxNumber].spreadRate
2455         );
2456     }
2457 
2458     function _transferEth(address to, uint256 amount) internal {
2459         // solhint-disable-next-line avoid-low-level-calls
2460         (bool success, ) = to.call{value: amount}("");
2461         require(success, "Transfer failed.");
2462     }
2463 }
2464 
2465 // File: contracts/BoxExchange/ETHBoxExchange/IDOLvsETH/IDOLvsETHBoxExchange.sol
2466 
2467 pragma solidity >=0.6.6;
2468 
2469 
2470 contract IDOLvsETHBoxExchange is ETHBoxExchange {
2471     /**
2472      * @param _token ERC20 token contract
2473      * @param _priceCalc Price Calculator contract
2474      * @param _marketFeeTaker Address of market fee taker (i.e. Lien Token)
2475      * @param _spreadCalc Spread Calculator contract
2476      * @param _oracle Oracle contract of ETH/USD
2477      * @param _name Name of share token
2478      **/
2479     constructor(
2480         ERC20Interface _token,
2481         PriceCalculatorInterface _priceCalc,
2482         address _marketFeeTaker,
2483         SpreadCalculatorInterface _spreadCalc,
2484         OracleInterface _oracle,
2485         string memory _name
2486     )
2487         public
2488         ETHBoxExchange(
2489             _token,
2490             _priceCalc,
2491             _marketFeeTaker,
2492             _spreadCalc,
2493             _oracle,
2494             _name
2495         )
2496     {}
2497 }