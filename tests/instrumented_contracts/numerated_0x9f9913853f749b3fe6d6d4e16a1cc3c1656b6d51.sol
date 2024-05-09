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
723 // File: @openzeppelin/contracts/math/Math.sol
724 
725 // SPDX-License-Identifier: MIT
726 
727 pragma solidity ^0.6.0;
728 
729 /**
730  * @dev Standard math utilities missing in the Solidity language.
731  */
732 library Math {
733     /**
734      * @dev Returns the largest of two numbers.
735      */
736     function max(uint256 a, uint256 b) internal pure returns (uint256) {
737         return a >= b ? a : b;
738     }
739 
740     /**
741      * @dev Returns the smallest of two numbers.
742      */
743     function min(uint256 a, uint256 b) internal pure returns (uint256) {
744         return a < b ? a : b;
745     }
746 
747     /**
748      * @dev Returns the average of two numbers. The result is rounded towards
749      * zero.
750      */
751     function average(uint256 a, uint256 b) internal pure returns (uint256) {
752         // (a + b) / 2 can overflow, so we distribute
753         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
754     }
755 }
756 
757 // File: @openzeppelin/contracts/utils/Arrays.sol
758 
759 // SPDX-License-Identifier: MIT
760 
761 pragma solidity ^0.6.0;
762 
763 
764 /**
765  * @dev Collection of functions related to array types.
766  */
767 library Arrays {
768    /**
769      * @dev Searches a sorted `array` and returns the first index that contains
770      * a value greater or equal to `element`. If no such index exists (i.e. all
771      * values in the array are strictly less than `element`), the array length is
772      * returned. Time complexity O(log n).
773      *
774      * `array` is expected to be sorted in ascending order, and to contain no
775      * repeated elements.
776      */
777     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
778         if (array.length == 0) {
779             return 0;
780         }
781 
782         uint256 low = 0;
783         uint256 high = array.length;
784 
785         while (low < high) {
786             uint256 mid = Math.average(low, high);
787 
788             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
789             // because Math.average rounds down (it does integer division with truncation).
790             if (array[mid] > element) {
791                 high = mid;
792             } else {
793                 low = mid + 1;
794             }
795         }
796 
797         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
798         if (low > 0 && array[low - 1] == element) {
799             return low - 1;
800         } else {
801             return low;
802         }
803     }
804 }
805 
806 // File: @openzeppelin/contracts/utils/Counters.sol
807 
808 // SPDX-License-Identifier: MIT
809 
810 pragma solidity ^0.6.0;
811 
812 
813 /**
814  * @title Counters
815  * @author Matt Condon (@shrugs)
816  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
817  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
818  *
819  * Include with `using Counters for Counters.Counter;`
820  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
821  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
822  * directly accessed.
823  */
824 library Counters {
825     using SafeMath for uint256;
826 
827     struct Counter {
828         // This variable should never be directly accessed by users of the library: interactions must be restricted to
829         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
830         // this feature: see https://github.com/ethereum/solidity/issues/4637
831         uint256 _value; // default: 0
832     }
833 
834     function current(Counter storage counter) internal view returns (uint256) {
835         return counter._value;
836     }
837 
838     function increment(Counter storage counter) internal {
839         // The {SafeMath} overflow check can be skipped here, see the comment at the top
840         counter._value += 1;
841     }
842 
843     function decrement(Counter storage counter) internal {
844         counter._value = counter._value.sub(1);
845     }
846 }
847 
848 // File: @openzeppelin/contracts/token/ERC20/ERC20Snapshot.sol
849 
850 // SPDX-License-Identifier: MIT
851 
852 pragma solidity ^0.6.0;
853 
854 
855 
856 
857 
858 /**
859  * @dev This contract extends an ERC20 token with a snapshot mechanism. When a snapshot is created, the balances and
860  * total supply at the time are recorded for later access.
861  *
862  * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.
863  * In naive implementations it's possible to perform a "double spend" attack by reusing the same balance from different
864  * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be
865  * used to create an efficient ERC20 forking mechanism.
866  *
867  * Snapshots are created by the internal {_snapshot} function, which will emit the {Snapshot} event and return a
868  * snapshot id. To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with the snapshot
869  * id. To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with the snapshot id
870  * and the account address.
871  *
872  * ==== Gas Costs
873  *
874  * Snapshots are efficient. Snapshot creation is _O(1)_. Retrieval of balances or total supply from a snapshot is _O(log
875  * n)_ in the number of snapshots that have been created, although _n_ for a specific account will generally be much
876  * smaller since identical balances in subsequent snapshots are stored as a single entry.
877  *
878  * There is a constant overhead for normal ERC20 transfers due to the additional snapshot bookkeeping. This overhead is
879  * only significant for the first transfer that immediately follows a snapshot for a particular account. Subsequent
880  * transfers will have normal cost until the next snapshot, and so on.
881  */
882 abstract contract ERC20Snapshot is ERC20 {
883     // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
884     // https://github.com/Giveth/minimd/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
885 
886     using SafeMath for uint256;
887     using Arrays for uint256[];
888     using Counters for Counters.Counter;
889 
890     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
891     // Snapshot struct, but that would impede usage of functions that work on an array.
892     struct Snapshots {
893         uint256[] ids;
894         uint256[] values;
895     }
896 
897     mapping (address => Snapshots) private _accountBalanceSnapshots;
898     Snapshots private _totalSupplySnapshots;
899 
900     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
901     Counters.Counter private _currentSnapshotId;
902 
903     /**
904      * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
905      */
906     event Snapshot(uint256 id);
907 
908     /**
909      * @dev Creates a new snapshot and returns its snapshot id.
910      *
911      * Emits a {Snapshot} event that contains the same id.
912      *
913      * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
914      * set of accounts, for example using {AccessControl}, or it may be open to the public.
915      *
916      * [WARNING]
917      * ====
918      * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
919      * you must consider that it can potentially be used by attackers in two ways.
920      *
921      * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
922      * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
923      * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
924      * section above.
925      *
926      * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
927      * ====
928      */
929     function _snapshot() internal virtual returns (uint256) {
930         _currentSnapshotId.increment();
931 
932         uint256 currentId = _currentSnapshotId.current();
933         emit Snapshot(currentId);
934         return currentId;
935     }
936 
937     /**
938      * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
939      */
940     function balanceOfAt(address account, uint256 snapshotId) public view returns (uint256) {
941         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
942 
943         return snapshotted ? value : balanceOf(account);
944     }
945 
946     /**
947      * @dev Retrieves the total supply at the time `snapshotId` was created.
948      */
949     function totalSupplyAt(uint256 snapshotId) public view returns(uint256) {
950         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
951 
952         return snapshotted ? value : totalSupply();
953     }
954 
955     // _transfer, _mint and _burn are the only functions where the balances are modified, so it is there that the
956     // snapshots are updated. Note that the update happens _before_ the balance change, with the pre-modified value.
957     // The same is true for the total supply and _mint and _burn.
958     function _transfer(address from, address to, uint256 value) internal virtual override {
959         _updateAccountSnapshot(from);
960         _updateAccountSnapshot(to);
961 
962         super._transfer(from, to, value);
963     }
964 
965     function _mint(address account, uint256 value) internal virtual override {
966         _updateAccountSnapshot(account);
967         _updateTotalSupplySnapshot();
968 
969         super._mint(account, value);
970     }
971 
972     function _burn(address account, uint256 value) internal virtual override {
973         _updateAccountSnapshot(account);
974         _updateTotalSupplySnapshot();
975 
976         super._burn(account, value);
977     }
978 
979     function _valueAt(uint256 snapshotId, Snapshots storage snapshots)
980         private view returns (bool, uint256)
981     {
982         require(snapshotId > 0, "ERC20Snapshot: id is 0");
983         // solhint-disable-next-line max-line-length
984         require(snapshotId <= _currentSnapshotId.current(), "ERC20Snapshot: nonexistent id");
985 
986         // When a valid snapshot is queried, there are three possibilities:
987         //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
988         //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
989         //  to this id is the current one.
990         //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
991         //  requested id, and its value is the one to return.
992         //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
993         //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
994         //  larger than the requested one.
995         //
996         // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
997         // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
998         // exactly this.
999 
1000         uint256 index = snapshots.ids.findUpperBound(snapshotId);
1001 
1002         if (index == snapshots.ids.length) {
1003             return (false, 0);
1004         } else {
1005             return (true, snapshots.values[index]);
1006         }
1007     }
1008 
1009     function _updateAccountSnapshot(address account) private {
1010         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
1011     }
1012 
1013     function _updateTotalSupplySnapshot() private {
1014         _updateSnapshot(_totalSupplySnapshots, totalSupply());
1015     }
1016 
1017     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
1018         uint256 currentId = _currentSnapshotId.current();
1019         if (_lastSnapshotId(snapshots.ids) < currentId) {
1020             snapshots.ids.push(currentId);
1021             snapshots.values.push(currentValue);
1022         }
1023     }
1024 
1025     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
1026         if (ids.length == 0) {
1027             return 0;
1028         } else {
1029             return ids[ids.length - 1];
1030         }
1031     }
1032 }
1033 
1034 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
1035 
1036 // SPDX-License-Identifier: MIT
1037 
1038 pragma solidity ^0.6.0;
1039 
1040 
1041 
1042 /**
1043  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1044  * tokens and those that they have an allowance for, in a way that can be
1045  * recognized off-chain (via event analysis).
1046  */
1047 abstract contract ERC20Burnable is Context, ERC20 {
1048     /**
1049      * @dev Destroys `amount` tokens from the caller.
1050      *
1051      * See {ERC20-_burn}.
1052      */
1053     function burn(uint256 amount) public virtual {
1054         _burn(_msgSender(), amount);
1055     }
1056 
1057     /**
1058      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1059      * allowance.
1060      *
1061      * See {ERC20-_burn} and {ERC20-allowance}.
1062      *
1063      * Requirements:
1064      *
1065      * - the caller must have allowance for ``accounts``'s tokens of at least
1066      * `amount`.
1067      */
1068     function burnFrom(address account, uint256 amount) public virtual {
1069         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1070 
1071         _approve(account, _msgSender(), decreasedAllowance);
1072         _burn(account, amount);
1073     }
1074 }
1075 
1076 // File: contracts/BITTOKEN.sol
1077 
1078 // contracts/BITTOKEN.sol
1079 // SPDX-License-Identifier: MIT
1080 pragma solidity ^0.6.0;
1081 
1082 
1083 
1084 
1085 
1086 contract BITTOKEN is ERC20Burnable, ERC20Snapshot {
1087 
1088     using SafeMath for uint256;
1089      // timestamp for next snapshot
1090     uint256 private _snapshotTimestamp;
1091 
1092     uint256 private _currentSnapshotId;
1093 
1094     constructor() public ERC20("BITTOKEN", "BITT") {
1095         _snapshotTimestamp = block.timestamp;
1096         // Contract 
1097         _mint(0xf57e2D18513869b375Ce2a86CB7c325aa716f294, 42000000*10**18);
1098     }
1099 
1100     /**
1101     * @dev Do snapshot each 30 days if triggered. Snapshots are used for governance and rewards distribution
1102     */
1103     function doSnapshot() public returns (uint256) {
1104         // solhint-disable-next-line not-rely-on-time
1105         require(block.timestamp >= _snapshotTimestamp + 30 days, "Not passed 30 days yet");
1106         // update snapshot timestamp with new time
1107         _snapshotTimestamp = block.timestamp;
1108 
1109         _currentSnapshotId = _snapshot();
1110         return _currentSnapshotId;
1111     }
1112 
1113     /**
1114     * @dev Return current snapshot id
1115     */
1116     function currentSnapshotId() public view returns (uint256) {
1117         return _currentSnapshotId;
1118 
1119     }
1120 
1121       /**
1122      * @dev Destroys `amount` tokens from `account`, reducing the
1123      * total supply.
1124      *
1125      * Emits a {Transfer} event with `to` set to the zero address.
1126      *
1127      * Requirements
1128      *
1129      * - `account` cannot be the zero address.
1130      * - `account` must have at least `amount` tokens.
1131      */
1132     function _burn(address account, uint256 amount) internal virtual override(ERC20, ERC20Snapshot){
1133         super._burn(account, amount);
1134     }
1135 
1136     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1137      * the total supply.
1138      *
1139      * Emits a {Transfer} event with `from` set to the zero address.
1140      *
1141      * Requirements
1142      *
1143      * - `to` cannot be the zero address.
1144      */
1145     function _mint(address account, uint256 amount) internal virtual override(ERC20, ERC20Snapshot){
1146          super._mint(account, amount);
1147     }
1148 
1149      /**
1150      * @dev Moves tokens `amount` from `sender` to `recipient`.
1151      *
1152      * This is internal function is equivalent to {transfer}, and can be used to
1153      * e.g. implement automatic token fees, slashing mechanisms, etc.
1154      *
1155      * Emits a {Transfer} event.
1156      *
1157      * Requirements:
1158      *
1159      * - `sender` cannot be the zero address.
1160      * - `recipient` cannot be the zero address.
1161      * - `sender` must have a balance of at least `amount`.
1162      */
1163     function _transfer(address sender, address recipient, uint256 amount) internal virtual override(ERC20, ERC20Snapshot){
1164          super._transfer(sender, recipient, amount);
1165     }
1166 }
