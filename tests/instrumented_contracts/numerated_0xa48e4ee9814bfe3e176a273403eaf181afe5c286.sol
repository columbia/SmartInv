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
1140 
1141 abstract contract BoxExchange is ERC20 {
1142     using BoxExecutionStatusLibrary for BoxExecutionStatus;
1143     using OrderBoxLibrary for OrderBox;
1144     using OrderBookLibrary for OrderBook;
1145     using OrderTypeLibrary for OrderType;
1146     using TokenLibrary for Token;
1147     using RateMath for uint256;
1148     using SafeMath for uint256;
1149     using SafeCast for uint256;
1150 
1151     uint256 internal constant MARKET_FEE_RATE = 200000000000000000; // market fee taker takes 20% of spread
1152 
1153     address internal immutable factory;
1154 
1155     address internal immutable marketFeeTaker; // Address that receives market fee (i.e. Lien Token)
1156     uint128 public marketFeePool0; // Total market fee in TOKEN0
1157     uint128 public marketFeePool1; // Total market fee in TOKEN1
1158 
1159     uint128 internal reserve0; // Total Liquidity of TOKEN0
1160     uint128 internal reserve1; // Total Liquidity of TOKEN1
1161     OrderBox[] internal orderBoxes; // Array of OrderBox
1162     PriceCalculatorInterface internal immutable priceCalc; // Price Calculator
1163     BoxExecutionStatus internal boxExecutionStatus; // Struct that has information about execution of current executing OrderBox
1164     BookExecutionStatus internal bookExecutionStatus; // Struct that has information about execution of current executing OrderBook
1165 
1166     event AcceptOrders(
1167         address indexed recipient,
1168         bool indexed isBuy, // if true, this order is exchange from TOKEN0 to TOKEN1
1169         uint32 indexed boxNumber,
1170         bool isLimit, // if true, this order is STRICT order
1171         uint256 tokenIn
1172     );
1173 
1174     event MoveLiquidity(
1175         address indexed liquidityProvider,
1176         bool indexed isAdd, // if true, this order is addtion of liquidity
1177         uint256 movedToken0Amount,
1178         uint256 movedToken1Amount,
1179         uint256 sharesMoved // Amount of share that is minted or burned
1180     );
1181 
1182     event Execution(
1183         bool indexed isBuy, // if true, this order is exchange from TOKEN0 to TOKEN1
1184         uint32 indexed boxNumber,
1185         address indexed recipient,
1186         uint256 orderAmount, // Amount of token that is transferred when this order is added
1187         uint256 refundAmount, // In the same token as orderAmount
1188         uint256 outAmount // In the other token than orderAmount
1189     );
1190 
1191     event UpdateReserve(uint128 reserve0, uint128 reserve1, uint256 totalShare);
1192 
1193     event PayMarketFee(uint256 amount0, uint256 amount1);
1194 
1195     event ExecutionSummary(
1196         uint32 indexed boxNumber,
1197         uint8 partiallyRefundOrderType,
1198         uint256 rate,
1199         uint256 partiallyRefundRate,
1200         uint256 totalInAmountFLEX_0_1,
1201         uint256 totalInAmountFLEX_1_0,
1202         uint256 totalInAmountSTRICT_0_1,
1203         uint256 totalInAmountSTRICT_1_0
1204     );
1205 
1206     modifier isAmountSafe(uint256 amount) {
1207         require(amount != 0, "Amount should be bigger than 0");
1208         _;
1209     }
1210 
1211     modifier isInTime(uint256 timeout) {
1212         require(timeout > _currentOpenBoxId(), "Time out");
1213         _;
1214     }
1215 
1216     constructor(
1217         PriceCalculatorInterface _priceCalc,
1218         address _marketFeeTaker,
1219         string memory _name
1220     ) public ERC20(_name, "share") {
1221         factory = msg.sender;
1222         priceCalc = _priceCalc;
1223         marketFeeTaker = _marketFeeTaker;
1224         _setupDecimals(8); // Decimal of share token is the same as iDOL, LBT, and Lien Token
1225     }
1226 
1227     /**
1228      * @notice Shows how many boxes and orders exist before the specific order
1229      * @dev If this order does not exist, return (false, 0, 0)
1230      * @dev If this order is already executed, return (true, 0, 0)
1231      * @param recipient Recipient of this order
1232      * @param boxNumber Box ID where the order exists
1233      * @param isExecuted If true, the order is already executed
1234      * @param boxCount Counter of boxes before this order. If current executing box number is the same as boxNumber, return 1 (i.e. indexing starts from 1)
1235      * @param orderCount Counter of orders before this order. If this order is on n-th top of the queue, return n (i.e. indexing starts from 1)
1236      **/
1237     function whenToExecute(
1238         address recipient,
1239         uint256 boxNumber,
1240         bool isBuy,
1241         bool isLimit
1242     )
1243         external
1244         view
1245         returns (
1246             bool isExecuted,
1247             uint256 boxCount,
1248             uint256 orderCount
1249         )
1250     {
1251         return
1252             _whenToExecute(recipient, _getOrderType(isBuy, isLimit), boxNumber);
1253     }
1254 
1255     /**
1256      * @notice Returns summary of current exchange status
1257      * @param boxNumber Current open box ID
1258      * @param _reserve0 Current reserve of TOKEN0
1259      * @param _reserve1 Current reserve of TOKEN1
1260      * @param totalShare Total Supply of share token
1261      * @param latestSpreadRate Spread Rate in latest OrderBox
1262      * @param token0PerShareE18 Amount of TOKEN0 per 1 share token and has 18 decimal
1263      * @param token1PerShareE18 Amount of TOKEN1 per 1 share token and has 18 decimal
1264      **/
1265     function getExchangeData()
1266         external
1267         virtual
1268         view
1269         returns (
1270             uint256 boxNumber,
1271             uint256 _reserve0,
1272             uint256 _reserve1,
1273             uint256 totalShare,
1274             uint256 latestSpreadRate,
1275             uint256 token0PerShareE18,
1276             uint256 token1PerShareE18
1277         )
1278     {
1279         boxNumber = _currentOpenBoxId();
1280         (_reserve0, _reserve1) = _getReserves();
1281         latestSpreadRate = orderBoxes[boxNumber].spreadRate;
1282         totalShare = totalSupply();
1283         token0PerShareE18 = RateMath.getRate(_reserve0, totalShare);
1284         token1PerShareE18 = RateMath.getRate(_reserve1, totalShare);
1285     }
1286 
1287     /**
1288      * @notice Gets summary of Current box information (Total order amount of each OrderTypes)
1289      * @param executionStatusNumber Status of execution of this box
1290      * @param boxNumber ID of target box.
1291      **/
1292     function getBoxSummary(uint256 boxNumber)
1293         public
1294         view
1295         returns (
1296             uint256 executionStatusNumber,
1297             uint256 flexToken0InAmount,
1298             uint256 strictToken0InAmount,
1299             uint256 flexToken1InAmount,
1300             uint256 strictToken1InAmount
1301         )
1302     {
1303         // `executionStatusNumber`
1304         // 0 => This box has not been executed
1305         // 1 => This box is currently executing. (Reserves and market fee pools have already been updated)
1306         // 2 => This box has already been executed
1307         uint256 nextExecutingBoxId = boxExecutionStatus.boxNumber;
1308         flexToken0InAmount = orderBoxes[boxNumber].orderBooks[OrderType
1309             .FLEX_0_1]
1310             .totalInAmount;
1311         strictToken0InAmount = orderBoxes[boxNumber].orderBooks[OrderType
1312             .STRICT_0_1]
1313             .totalInAmount;
1314         flexToken1InAmount = orderBoxes[boxNumber].orderBooks[OrderType
1315             .FLEX_1_0]
1316             .totalInAmount;
1317         strictToken1InAmount = orderBoxes[boxNumber].orderBooks[OrderType
1318             .STRICT_1_0]
1319             .totalInAmount;
1320         if (boxNumber < nextExecutingBoxId) {
1321             executionStatusNumber = 2;
1322         } else if (
1323             boxNumber == nextExecutingBoxId && boxExecutionStatus.onGoing
1324         ) {
1325             executionStatusNumber = 1;
1326         }
1327     }
1328 
1329     /**
1330      * @notice Gets amount of order in current open box
1331      * @param account Target Address
1332      * @param orderType OrderType of target order
1333      * @return Amount of target order
1334      **/
1335     function getOrderAmount(address account, OrderType orderType)
1336         public
1337         view
1338         returns (uint256)
1339     {
1340         return
1341             orderBoxes[_currentOpenBoxId()].orderBooks[orderType]
1342                 .inAmounts[account];
1343     }
1344 
1345     // abstract functions
1346     function _feeRate() internal virtual returns (uint128);
1347 
1348     function _receiveTokens(
1349         Token token,
1350         address from,
1351         uint256 amount
1352     ) internal virtual;
1353 
1354     function _sendTokens(
1355         Token token,
1356         address to,
1357         uint256 amount
1358     ) internal virtual;
1359 
1360     function _payForOrderExecution(
1361         Token token,
1362         address to,
1363         uint256 amount
1364     ) internal virtual;
1365 
1366     function _payMarketFee(
1367         address _marketFeeTaker,
1368         uint256 amount0,
1369         uint256 amount1
1370     ) internal virtual;
1371 
1372     function _isCurrentOpenBoxExpired() internal virtual view returns (bool) {}
1373 
1374     /**
1375      * @notice User can determine the amount of share token to mint.
1376      * @dev This function can be executed only by factory
1377      * @param amount0 The amount of TOKEN0 to invest
1378      * @param amount1 The amount of TOKEN1 to invest
1379      * @param initialShare The amount of share token to mint. This defines approximate value of share token.
1380      **/
1381     function _init(
1382         uint128 amount0,
1383         uint128 amount1,
1384         uint256 initialShare
1385     ) internal virtual {
1386         require(totalSupply() == 0, "Already initialized");
1387         require(msg.sender == factory);
1388         _updateReserve(amount0, amount1);
1389         _mint(msg.sender, initialShare);
1390         _receiveTokens(Token.TOKEN0, msg.sender, amount0);
1391         _receiveTokens(Token.TOKEN1, msg.sender, amount1);
1392         _openNewBox();
1393     }
1394 
1395     /**
1396      * @dev Amount of share to mint is determined by `amount`
1397      * @param tokenType Type of token which the amount of share the LP get is calculated based on `amount`
1398      * @param amount The amount of token type of `tokenType`
1399      **/
1400     function _addLiquidity(
1401         uint256 _reserve0,
1402         uint256 _reserve1,
1403         uint256 amount,
1404         uint256 minShare,
1405         Token tokenType
1406     ) internal virtual {
1407         (uint256 amount0, uint256 amount1, uint256 share) = _calculateAmounts(
1408             amount,
1409             _reserve0,
1410             _reserve1,
1411             tokenType
1412         );
1413         require(share >= minShare, "You can't receive enough shares");
1414         _receiveTokens(Token.TOKEN0, msg.sender, amount0);
1415         _receiveTokens(Token.TOKEN1, msg.sender, amount1);
1416         _updateReserve(
1417             _reserve0.add(amount0).toUint128(),
1418             _reserve1.add(amount1).toUint128()
1419         );
1420         _mint(msg.sender, share);
1421         emit MoveLiquidity(msg.sender, true, amount0, amount1, share);
1422     }
1423 
1424     /**
1425      * @dev Amount of TOKEN0 and TOKEN1 is determined by amount of share to be burned
1426      * @param minAmount0 Minimum amount of TOKEN0 to return. If returned TOKEN0 is less than this value, revert transaction
1427      * @param minAmount1 Minimum amount of TOKEN1 to return. If returned TOKEN1 is less than this value, revert transaction
1428      * @param share Amount of share token to be burned
1429      **/
1430     function _removeLiquidity(
1431         uint256 minAmount0,
1432         uint256 minAmount1,
1433         uint256 share
1434     ) internal virtual {
1435         (uint256 _reserve0, uint256 _reserve1) = _getReserves(); // gas savings
1436         uint256 _totalSupply = totalSupply();
1437         uint256 amount0 = _reserve0.mul(share).div(_totalSupply);
1438         uint256 amount1 = _reserve1.mul(share).div(_totalSupply);
1439         require(
1440             amount0 >= minAmount0 && amount1 >= minAmount1,
1441             "You can't receive enough tokens"
1442         );
1443         _updateReserve(
1444             _reserve0.sub(amount0).toUint128(),
1445             _reserve1.sub(amount1).toUint128()
1446         );
1447         _burn(msg.sender, share);
1448         _sendTokens(Token.TOKEN0, msg.sender, amount0);
1449         _sendTokens(Token.TOKEN1, msg.sender, amount1);
1450         emit MoveLiquidity(msg.sender, false, amount0, amount1, share);
1451     }
1452 
1453     /**
1454      * @dev If there is some OrderBox to be executed, try execute 5 orders
1455      * @dev If currentBox has expired, open new box
1456      * @param orderType Type of order
1457      * @param inAmount Amount of token to be exchanged
1458      * @param recipient Recipient of swapped token. If this value is address(0), msg.sender is the recipient
1459      **/
1460     function _addOrder(
1461         OrderType orderType,
1462         uint256 inAmount,
1463         address recipient
1464     ) internal virtual {
1465         _rotateBox();
1466         uint256 _currentOpenBoxId = _currentOpenBoxId();
1467         _executeOrders(5, _currentOpenBoxId);
1468         if (recipient == address(0)) {
1469             recipient = msg.sender;
1470         }
1471         _receiveTokens(orderType.inToken(), msg.sender, inAmount);
1472         orderBoxes[_currentOpenBoxId].addOrder(orderType, inAmount, recipient);
1473         emit AcceptOrders(
1474             recipient,
1475             orderType.isBuy(),
1476             uint32(_currentOpenBoxId),
1477             orderType.isStrict(),
1478             inAmount
1479         );
1480     }
1481 
1482     /**
1483      * @dev Triggers executeOrders()
1484      * @param maxOrderNum Number of orders to execute (if no order is left, stop execution)
1485      **/
1486     function _triggerExecuteOrders(uint8 maxOrderNum) internal virtual {
1487         _executeOrders(maxOrderNum, _currentOpenBoxId());
1488     }
1489 
1490     /**
1491      * @dev Triggers PayMarketFee() and update marketFeePool to 0
1492      **/
1493     function _triggerPayMarketFee() internal virtual {
1494         (
1495             uint256 _marketFeePool0,
1496             uint256 _marketFeePool1
1497         ) = _getMarketFeePools();
1498         _updateMarketFeePool(0, 0);
1499 
1500         emit PayMarketFee(_marketFeePool0, _marketFeePool1);
1501         _payMarketFee(marketFeeTaker, _marketFeePool0, _marketFeePool1);
1502     }
1503 
1504     // When open new box, creates new OrderBox with spreadRate and block number of expiretion, then pushes it to orderBoxes
1505     function _openNewBox() internal virtual {
1506         orderBoxes.push(
1507             OrderBoxLibrary.newOrderBox(
1508                 _feeRate(),
1509                 (block.number + 2).toUint32()
1510             )
1511         );
1512     }
1513 
1514     function _rotateBox() private {
1515         // if current open box has expired
1516         if (_isCurrentOpenBoxExpired()) {
1517             _openNewBox();
1518         }
1519     }
1520 
1521     /**
1522      * @param maxOrderNum Number of orders to execute (if no order is left, stoppes execution)
1523      * @param _currentOpenBoxId Current box ID (_currentOpenBoxID() is already run in _addOrder() or _triggerExecuteOrders()
1524      **/
1525     function _executeOrders(uint256 maxOrderNum, uint256 _currentOpenBoxId)
1526         private
1527     {
1528         BoxExecutionStatus memory _boxExecutionStatus = boxExecutionStatus;
1529         BookExecutionStatus memory _bookExecutionStatus = bookExecutionStatus;
1530         // if _boxExecutionStatus.boxNumber is current open and not expired box, won't execute.
1531         // if _boxExecutionStatus.boxNumber is more than currentOpenBoxId, the newest box is already executed.
1532         if (
1533             _boxExecutionStatus.boxNumber >= _currentOpenBoxId &&
1534             (!_isCurrentOpenBoxExpired() ||
1535                 _boxExecutionStatus.boxNumber > _currentOpenBoxId)
1536         ) {
1537             return;
1538         }
1539         if (!_boxExecutionStatus.onGoing) {
1540             // get rates and start new box execution
1541             // before start new box execution, updates reserves.
1542             {
1543                 (
1544                     OrderType partiallyRefundOrderType,
1545                     uint256 partiallyRefundRate,
1546                     uint256 rate
1547                 ) = _getExecutionRatesAndUpdateReserve(
1548                     _boxExecutionStatus.boxNumber
1549                 );
1550                 _boxExecutionStatus
1551                     .partiallyRefundOrderType = partiallyRefundOrderType;
1552                 _boxExecutionStatus.partiallyRefundRate = partiallyRefundRate
1553                     .toUint64();
1554                 _boxExecutionStatus.rate = rate.toUint128();
1555                 _boxExecutionStatus.onGoing = true;
1556                 _bookExecutionStatus.executingOrderType = OrderType(0);
1557                 _bookExecutionStatus.nextIndex = 0;
1558             }
1559         }
1560         // execute orders in one book
1561         // reducing maxOrderNum to avoid stack to deep
1562         while (maxOrderNum != 0) {
1563             OrderBook storage executionBook = orderBoxes[_boxExecutionStatus
1564                 .boxNumber]
1565                 .orderBooks[_bookExecutionStatus.executingOrderType];
1566             (
1567                 bool isBookFinished,
1568                 uint256 nextIndex,
1569                 uint256 executedOrderNum
1570             ) = _executeOrdersInBook(
1571                 executionBook,
1572                 _bookExecutionStatus.executingOrderType.inToken(),
1573                 _bookExecutionStatus.nextIndex,
1574                 _boxExecutionStatus.refundRate(
1575                     _bookExecutionStatus.executingOrderType
1576                 ),
1577                 _boxExecutionStatus.rate,
1578                 orderBoxes[_boxExecutionStatus.boxNumber].spreadRate,
1579                 maxOrderNum
1580             );
1581             if (isBookFinished) {
1582                 bool isBoxFinished = _isBoxFinished(
1583                     orderBoxes[_boxExecutionStatus.boxNumber],
1584                     _bookExecutionStatus.executingOrderType
1585                 );
1586                 delete orderBoxes[_boxExecutionStatus.boxNumber]
1587                     .orderBooks[_bookExecutionStatus.executingOrderType];
1588 
1589                 // update book execution status and box execution status
1590                 if (isBoxFinished) {
1591                     _boxExecutionStatus.boxNumber += 1;
1592                     _boxExecutionStatus.onGoing = false;
1593                     boxExecutionStatus = _boxExecutionStatus;
1594 
1595                     return; // no need to update bookExecutionStatus;
1596                 }
1597                 _bookExecutionStatus.executingOrderType = _bookExecutionStatus
1598                     .executingOrderType
1599                     .next();
1600             }
1601             _bookExecutionStatus.nextIndex = nextIndex.toUint32();
1602             maxOrderNum -= executedOrderNum;
1603         }
1604         boxExecutionStatus = _boxExecutionStatus;
1605         bookExecutionStatus = _bookExecutionStatus;
1606     }
1607 
1608     /**
1609      * @notice Executes each OrderBook
1610      * @param orderBook Target OrderBook
1611      * @param rate Rate of swap
1612      * @param refundRate Refund rate in this OrderType
1613      * @param maxOrderNum Max number of orders to execute in this book
1614      * @return If execution is finished, return true
1615      * @return Next index to execute. If execution is finished, return 0
1616      * @return Number of orders executed
1617      **/
1618     function _executeOrdersInBook(
1619         OrderBook storage orderBook,
1620         Token inToken,
1621         uint256 initialIndex,
1622         uint256 refundRate,
1623         uint256 rate,
1624         uint256 spreadRate,
1625         uint256 maxOrderNum
1626     )
1627         private
1628         returns (
1629             bool,
1630             uint256,
1631             uint256
1632         )
1633     {
1634         uint256 index;
1635         uint256 numOfOrder = orderBook.numOfOrder();
1636         for (
1637             index = initialIndex;
1638             index - initialIndex < maxOrderNum;
1639             index++
1640         ) {
1641             if (index >= numOfOrder) {
1642                 return (true, 0, index - initialIndex);
1643             }
1644             address recipient = orderBook.recipients[index];
1645             _executeOrder(
1646                 inToken,
1647                 recipient,
1648                 orderBook.inAmounts[recipient],
1649                 refundRate,
1650                 rate,
1651                 spreadRate
1652             );
1653         }
1654         if (index >= numOfOrder) {
1655             return (true, 0, index - initialIndex);
1656         }
1657         return (false, index, index - initialIndex);
1658     }
1659 
1660     /**
1661      * @dev Executes each order
1662      * @param inToken type of token
1663      * @param recipient Recipient of Token
1664      * @param inAmount Amount of token
1665      * @param refundRate Refund rate in this OrderType
1666      * @param rate Rate of swap
1667      * @param spreadRate Spread rate in this box
1668      **/
1669     function _executeOrder(
1670         Token inToken,
1671         address recipient,
1672         uint256 inAmount,
1673         uint256 refundRate,
1674         uint256 rate,
1675         uint256 spreadRate
1676     ) internal {
1677         Token outToken = inToken.another();
1678         // refundAmount = inAmount * refundRate
1679         uint256 refundAmount = inAmount.mulByRate(refundRate);
1680         // executingInAmountWithoutSpread = (inAmount - refundAmount) / (1+spreadRate)
1681         uint256 executingInAmountWithoutSpread = inAmount
1682             .sub(refundAmount)
1683             .divByRate(RateMath.RATE_POINT_MULTIPLIER.add(spreadRate));
1684         // spread = executingInAmountWithoutSpread * spreadRate
1685         // = (inAmount - refundAmount ) * ( 1 - 1 /( 1 + spreadRate))
1686         uint256 outAmount = _otherAmountBasedOnRate(
1687             inToken,
1688             executingInAmountWithoutSpread,
1689             rate
1690         );
1691         _payForOrderExecution(inToken, recipient, refundAmount);
1692         _payForOrderExecution(outToken, recipient, outAmount);
1693         emit Execution(
1694             (inToken == Token.TOKEN0),
1695             uint32(_currentOpenBoxId()),
1696             recipient,
1697             inAmount,
1698             refundAmount,
1699             outAmount
1700         );
1701     }
1702 
1703     /**
1704      * @notice Updates reserves and market fee pools
1705      * @param spreadRate Spread rate in the box
1706      * @param executingAmount0WithoutSpread Executed amount of TOKEN0 in this box
1707      * @param executingAmount1WithoutSpread Executed amount of TOKEN1 in this box
1708      * @param rate Rate of swap
1709      **/
1710     function _updateReservesAndMarketFeePoolByExecution(
1711         uint256 spreadRate,
1712         uint256 executingAmount0WithoutSpread,
1713         uint256 executingAmount1WithoutSpread,
1714         uint256 rate
1715     ) internal virtual {
1716         uint256 newReserve0;
1717         uint256 newReserve1;
1718         uint256 newMarketFeePool0;
1719         uint256 newMarketFeePool1;
1720         {
1721             (
1722                 uint256 differenceOfReserve,
1723                 uint256 differenceOfMarketFee
1724             ) = _calculateNewReserveAndMarketFeePool(
1725                 spreadRate,
1726                 executingAmount0WithoutSpread,
1727                 executingAmount1WithoutSpread,
1728                 rate,
1729                 Token.TOKEN0
1730             );
1731             newReserve0 = reserve0 + differenceOfReserve;
1732             newMarketFeePool0 = marketFeePool0 + differenceOfMarketFee;
1733         }
1734         {
1735             (
1736                 uint256 differenceOfReserve,
1737                 uint256 differenceOfMarketFee
1738             ) = _calculateNewReserveAndMarketFeePool(
1739                 spreadRate,
1740                 executingAmount1WithoutSpread,
1741                 executingAmount0WithoutSpread,
1742                 rate,
1743                 Token.TOKEN1
1744             );
1745             newReserve1 = reserve1 + differenceOfReserve;
1746             newMarketFeePool1 = marketFeePool1 + differenceOfMarketFee;
1747         }
1748         _updateReserve(newReserve0.toUint128(), newReserve1.toUint128());
1749         _updateMarketFeePool(
1750             newMarketFeePool0.toUint128(),
1751             newMarketFeePool1.toUint128()
1752         );
1753     }
1754 
1755     function _whenToExecute(
1756         address recipient,
1757         uint256 orderTypeCount,
1758         uint256 boxNumber
1759     )
1760         internal
1761         view
1762         returns (
1763             bool isExecuted,
1764             uint256 boxCount,
1765             uint256 orderCount
1766         )
1767     {
1768         if (boxNumber > _currentOpenBoxId()) {
1769             return (false, 0, 0);
1770         }
1771         OrderBox storage yourOrderBox = orderBoxes[boxNumber];
1772         address[] memory recipients = yourOrderBox.orderBooks[OrderType(
1773             orderTypeCount
1774         )]
1775             .recipients;
1776         uint256 nextExecutingBoxId = boxExecutionStatus.boxNumber;
1777         uint256 nextIndex = bookExecutionStatus.nextIndex;
1778         uint256 nextType = uint256(bookExecutionStatus.executingOrderType);
1779         bool onGoing = boxExecutionStatus.onGoing;
1780         bool isExist;
1781         uint256 place;
1782         for (uint256 j = 0; j != recipients.length; j++) {
1783             if (recipients[j] == recipient) {
1784                 isExist = true;
1785                 place = j;
1786                 break;
1787             }
1788         }
1789 
1790         // If current box number exceeds boxNumber, the target box has already been executed
1791         // If current box number is equal to boxNumber, and OrderType or index exceeds that of the target order, the target box has already been executed
1792         if (
1793             (boxNumber < nextExecutingBoxId) ||
1794             ((onGoing && (boxNumber == nextExecutingBoxId)) &&
1795                 ((orderTypeCount < nextType) ||
1796                     ((orderTypeCount == nextType) && (place < nextIndex))))
1797         ) {
1798             return (true, 0, 0);
1799         }
1800 
1801         if (!isExist) {
1802             return (false, 0, 0);
1803         }
1804 
1805         // Total number of orders before the target OrderType
1806         uint256 counts;
1807         if (boxNumber == nextExecutingBoxId && onGoing) {
1808             for (uint256 i = nextType; i < orderTypeCount; i++) {
1809                 counts += yourOrderBox.orderBooks[OrderType(i)].numOfOrder();
1810             }
1811             boxCount = 1;
1812             orderCount = counts.add(place).sub(nextIndex) + 1;
1813         } else {
1814             for (uint256 i = 0; i != orderTypeCount; i++) {
1815                 counts += yourOrderBox.orderBooks[OrderType(i)].numOfOrder();
1816             }
1817             boxCount = boxNumber.sub(nextExecutingBoxId) + 1;
1818             orderCount = counts.add(place) + 1;
1819         }
1820     }
1821 
1822     function _getReserves()
1823         internal
1824         view
1825         returns (uint256 _reserve0, uint256 _reserve1)
1826     {
1827         _reserve0 = reserve0;
1828         _reserve1 = reserve1;
1829     }
1830 
1831     function _getMarketFeePools()
1832         internal
1833         view
1834         returns (uint256 _marketFeePool0, uint256 _marketFeePool1)
1835     {
1836         _marketFeePool0 = marketFeePool0;
1837         _marketFeePool1 = marketFeePool1;
1838     }
1839 
1840     function _updateReserve(uint128 newReserve0, uint128 newReserve1) internal {
1841         reserve0 = newReserve0;
1842         reserve1 = newReserve1;
1843         emit UpdateReserve(newReserve0, newReserve1, totalSupply());
1844     }
1845 
1846     function _calculatePriceWrapper(
1847         uint256 flexToken0InWithoutSpread,
1848         uint256 strictToken0InWithoutSpread,
1849         uint256 flexToken1InWithoutSpread,
1850         uint256 strictToken1InWithoutSpread,
1851         uint256 _reserve0,
1852         uint256 _reserve1
1853     )
1854         internal
1855         view
1856         returns (
1857             uint256 rate,
1858             uint256 refundStatus,
1859             uint256 partiallyRefundRate,
1860             uint256 executingAmount0,
1861             uint256 executingAmount1
1862         )
1863     {
1864         uint256[5] memory data = priceCalc.calculatePrice(
1865             flexToken0InWithoutSpread,
1866             strictToken0InWithoutSpread,
1867             flexToken1InWithoutSpread,
1868             strictToken1InWithoutSpread,
1869             _reserve0,
1870             _reserve1
1871         );
1872         return (data[0], data[1], data[2], data[3], data[4]);
1873     }
1874 
1875     /**
1876      * @param rate0Per1 Token0 / Token1 * RATE_POINT_MULTIPLIER
1877      */
1878     function _otherAmountBasedOnRate(
1879         Token token,
1880         uint256 amount,
1881         uint256 rate0Per1
1882     ) internal pure returns (uint256) {
1883         if (token == Token.TOKEN0) {
1884             return amount.mulByRate(rate0Per1);
1885         } else {
1886             return amount.divByRate(rate0Per1);
1887         }
1888     }
1889 
1890     function _currentOpenBoxId() internal view returns (uint256) {
1891         return orderBoxes.length - 1;
1892     }
1893 
1894     /**
1895      * @notice Gets OrderType in uint
1896      **/
1897     function _getOrderType(bool isBuy, bool isLimit)
1898         internal
1899         pure
1900         returns (uint256 orderTypeCount)
1901     {
1902         if (isBuy && isLimit) {
1903             orderTypeCount = 2;
1904         } else if (!isBuy) {
1905             if (isLimit) {
1906                 orderTypeCount = 3;
1907             } else {
1908                 orderTypeCount = 1;
1909             }
1910         }
1911     }
1912 
1913     function _updateMarketFeePool(
1914         uint128 newMarketFeePool0,
1915         uint128 newMarketFeePool1
1916     ) private {
1917         marketFeePool0 = newMarketFeePool0;
1918         marketFeePool1 = newMarketFeePool1;
1919     }
1920 
1921     function _calculateAmounts(
1922         uint256 amount,
1923         uint256 _reserve0,
1924         uint256 _reserve1,
1925         Token tokenType
1926     )
1927         private
1928         view
1929         returns (
1930             uint256,
1931             uint256,
1932             uint256
1933         )
1934     {
1935         if (tokenType == Token.TOKEN0) {
1936             return (
1937                 amount,
1938                 amount.mul(_reserve1).div(_reserve0),
1939                 amount.mul(totalSupply()).div(_reserve0)
1940             );
1941         } else {
1942             return (
1943                 amount.mul(_reserve0).div(_reserve1),
1944                 amount,
1945                 amount.mul(totalSupply()).div(_reserve1)
1946             );
1947         }
1948     }
1949 
1950     function _priceCalculateRates(
1951         OrderBox storage orderBox,
1952         uint256 totalInAmountFLEX_0_1,
1953         uint256 totalInAmountFLEX_1_0,
1954         uint256 totalInAmountSTRICT_0_1,
1955         uint256 totalInAmountSTRICT_1_0
1956     )
1957         private
1958         view
1959         returns (
1960             uint256 rate,
1961             uint256 refundStatus,
1962             uint256 partiallyRefundRate,
1963             uint256 executingAmount0,
1964             uint256 executingAmount1
1965         )
1966     {
1967         uint256 withoutSpreadRate = RateMath.RATE_POINT_MULTIPLIER +
1968             orderBox.spreadRate;
1969         return
1970             _calculatePriceWrapper(
1971                 totalInAmountFLEX_0_1.divByRate(withoutSpreadRate),
1972                 totalInAmountSTRICT_0_1.divByRate(withoutSpreadRate),
1973                 totalInAmountFLEX_1_0.divByRate(withoutSpreadRate),
1974                 totalInAmountSTRICT_1_0.divByRate(withoutSpreadRate),
1975                 reserve0,
1976                 reserve1
1977             );
1978     }
1979 
1980     function _getExecutionRatesAndUpdateReserve(uint32 boxNumber)
1981         private
1982         returns (
1983             OrderType partiallyRefundOrderType,
1984             uint256 partiallyRefundRate,
1985             uint256 rate
1986         )
1987     {
1988         OrderBox storage orderBox = orderBoxes[boxNumber];
1989         // `refundStatus`
1990         // 0 => no_refund
1991         // 1 => refund some of strictToken0
1992         // 2 => refund all strictToken0 and some of flexToken0
1993         // 3 => refund some of strictToken1
1994         // 4 => refund all strictToken1 and some of flexToken1
1995         uint256 refundStatus;
1996         uint256 executingAmount0WithoutSpread;
1997         uint256 executingAmount1WithoutSpread;
1998         uint256 totalInAmountFLEX_0_1 = orderBox.orderBooks[OrderType.FLEX_0_1]
1999             .totalInAmount;
2000         uint256 totalInAmountFLEX_1_0 = orderBox.orderBooks[OrderType.FLEX_1_0]
2001             .totalInAmount;
2002         uint256 totalInAmountSTRICT_0_1 = orderBox.orderBooks[OrderType
2003             .STRICT_0_1]
2004             .totalInAmount;
2005         uint256 totalInAmountSTRICT_1_0 = orderBox.orderBooks[OrderType
2006             .STRICT_1_0]
2007             .totalInAmount;
2008         (
2009             rate,
2010             refundStatus,
2011             partiallyRefundRate,
2012             executingAmount0WithoutSpread,
2013             executingAmount1WithoutSpread
2014         ) = _priceCalculateRates(
2015             orderBox,
2016             totalInAmountFLEX_0_1,
2017             totalInAmountFLEX_1_0,
2018             totalInAmountSTRICT_0_1,
2019             totalInAmountSTRICT_1_0
2020         );
2021 
2022         {
2023             if (refundStatus == 0) {
2024                 partiallyRefundOrderType = OrderType.STRICT_0_1;
2025                 //refundRate = 0;
2026             } else if (refundStatus == 1) {
2027                 partiallyRefundOrderType = OrderType.STRICT_0_1;
2028             } else if (refundStatus == 2) {
2029                 partiallyRefundOrderType = OrderType.FLEX_0_1;
2030             } else if (refundStatus == 3) {
2031                 partiallyRefundOrderType = OrderType.STRICT_1_0;
2032             } else if (refundStatus == 4) {
2033                 partiallyRefundOrderType = OrderType.FLEX_1_0;
2034             }
2035         }
2036         emit ExecutionSummary(
2037             boxNumber,
2038             uint8(partiallyRefundOrderType),
2039             rate,
2040             partiallyRefundRate,
2041             totalInAmountFLEX_0_1,
2042             totalInAmountFLEX_1_0,
2043             totalInAmountSTRICT_0_1,
2044             totalInAmountSTRICT_1_0
2045         );
2046         _updateReservesAndMarketFeePoolByExecution(
2047             orderBox.spreadRate,
2048             executingAmount0WithoutSpread,
2049             executingAmount1WithoutSpread,
2050             rate
2051         );
2052     }
2053 
2054     /**
2055      * @notice Detects if this OrderBox is finished
2056      * @param orders Target OrderBox
2057      * @param lastFinishedOrderType Latest OrderType which is executed
2058      **/
2059     function _isBoxFinished(
2060         OrderBox storage orders,
2061         OrderType lastFinishedOrderType
2062     ) private view returns (bool) {
2063         // If orderType is STRICT_1_0, no book is left
2064         if (lastFinishedOrderType == OrderType.STRICT_1_0) {
2065             return true;
2066         }
2067         for (uint256 i = uint256(lastFinishedOrderType.next()); i != 4; i++) {
2068             OrderBook memory book = orders.orderBooks[OrderType(i)];
2069             // If OrderBook has some order return false
2070             if (book.numOfOrder() != 0) {
2071                 return false;
2072             }
2073         }
2074         return true;
2075     }
2076 
2077     function _calculateNewReserveAndMarketFeePool(
2078         uint256 spreadRate,
2079         uint256 executingAmountWithoutSpread,
2080         uint256 anotherExecutingAmountWithoutSpread,
2081         uint256 rate,
2082         Token tokenType
2083     ) internal returns (uint256, uint256) {
2084         uint256 totalSpread = executingAmountWithoutSpread.mulByRate(
2085             spreadRate
2086         );
2087         uint256 marketFee = totalSpread.mulByRate(MARKET_FEE_RATE);
2088         uint256 newReserve = executingAmountWithoutSpread +
2089             (totalSpread - marketFee) -
2090             _otherAmountBasedOnRate(
2091                 tokenType.another(),
2092                 anotherExecutingAmountWithoutSpread,
2093                 rate
2094             );
2095         return (newReserve, marketFee);
2096     }
2097 
2098     function _getTokenType(bool isBuy, bool isStrict)
2099         internal
2100         pure
2101         returns (OrderType)
2102     {
2103         if (isBuy) {
2104             if (isStrict) {
2105                 return OrderType.STRICT_0_1;
2106             } else {
2107                 return OrderType.FLEX_0_1;
2108             }
2109         } else {
2110             if (isStrict) {
2111                 return OrderType.STRICT_1_0;
2112             } else {
2113                 return OrderType.FLEX_1_0;
2114             }
2115         }
2116     }
2117 }
2118 
2119 // File: contracts/Interfaces/ERC20Interface.sol
2120 
2121 pragma solidity >=0.6.6;
2122 
2123 
2124 interface ERC20Interface is IERC20 {
2125     function name() external view returns (string memory);
2126 }
2127 
2128 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
2129 
2130 // SPDX-License-Identifier: MIT
2131 
2132 pragma solidity ^0.6.0;
2133 
2134 
2135 
2136 
2137 /**
2138  * @title SafeERC20
2139  * @dev Wrappers around ERC20 operations that throw on failure (when the token
2140  * contract returns false). Tokens that return no value (and instead revert or
2141  * throw on failure) are also supported, non-reverting calls are assumed to be
2142  * successful.
2143  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
2144  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
2145  */
2146 library SafeERC20 {
2147     using SafeMath for uint256;
2148     using Address for address;
2149 
2150     function safeTransfer(IERC20 token, address to, uint256 value) internal {
2151         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
2152     }
2153 
2154     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
2155         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
2156     }
2157 
2158     /**
2159      * @dev Deprecated. This function has issues similar to the ones found in
2160      * {IERC20-approve}, and its usage is discouraged.
2161      *
2162      * Whenever possible, use {safeIncreaseAllowance} and
2163      * {safeDecreaseAllowance} instead.
2164      */
2165     function safeApprove(IERC20 token, address spender, uint256 value) internal {
2166         // safeApprove should only be called when setting an initial allowance,
2167         // or when resetting it to zero. To increase and decrease it, use
2168         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
2169         // solhint-disable-next-line max-line-length
2170         require((value == 0) || (token.allowance(address(this), spender) == 0),
2171             "SafeERC20: approve from non-zero to non-zero allowance"
2172         );
2173         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
2174     }
2175 
2176     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
2177         uint256 newAllowance = token.allowance(address(this), spender).add(value);
2178         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2179     }
2180 
2181     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
2182         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
2183         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2184     }
2185 
2186     /**
2187      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
2188      * on the return value: the return value is optional (but if data is returned, it must not be false).
2189      * @param token The token targeted by the call.
2190      * @param data The call data (encoded using abi.encode or one of its variants).
2191      */
2192     function _callOptionalReturn(IERC20 token, bytes memory data) private {
2193         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
2194         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
2195         // the target address contains contract code and also asserts for success in the low-level call.
2196 
2197         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
2198         if (returndata.length > 0) { // Return data is optional
2199             // solhint-disable-next-line max-line-length
2200             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
2201         }
2202     }
2203 }
2204 
2205 // File: contracts/Interfaces/OracleInterface.sol
2206 
2207 pragma solidity >=0.6.6;
2208 
2209 interface OracleInterface {
2210     function latestPrice() external returns (uint256);
2211 
2212     function getVolatility() external returns (uint256);
2213 
2214     function latestId() external returns (uint256);
2215 }
2216 
2217 // File: contracts/Interfaces/SpreadCalculatorInterface.sol
2218 
2219 pragma solidity >=0.6.6;
2220 
2221 
2222 interface SpreadCalculatorInterface {
2223     function calculateCurrentSpread(
2224         uint256 _maturity,
2225         uint256 _strikePrice,
2226         OracleInterface oracle
2227     ) external returns (uint128);
2228 
2229     function calculateSpreadByAssetVolatility(OracleInterface oracle)
2230         external
2231         returns (uint128);
2232 }
2233 
2234 // File: contracts/BoxExchange/TokenBoxExchange/TokenBoxExchange.sol
2235 
2236 pragma solidity >=0.6.6;
2237 
2238 
2239 
2240 
2241 
2242 
2243 abstract contract TokenBoxExchange is BoxExchange {
2244     using SafeERC20 for ERC20Interface;
2245 
2246     ERC20Interface public immutable idol; // token0
2247     ERC20Interface public immutable token;
2248     SpreadCalculatorInterface internal immutable spreadCalc;
2249     OracleInterface internal immutable oracle;
2250 
2251     event SpreadRate(uint128 indexed boxNumber, uint128 spreadRate);
2252 
2253     /**
2254      * @param _idol iDOL contract
2255      * @param _token ERC20 contract
2256      * @param _priceCalc Price Calculator contract
2257      * @param _marketFeeTaker Address of market fee taker (i.e. Lien Token)
2258      * @param _spreadCalc Spread Calculator contract
2259      * @param _oracle Oracle contract
2260      * @param _name Name of share token
2261      **/
2262     constructor(
2263         ERC20Interface _idol,
2264         ERC20Interface _token,
2265         PriceCalculatorInterface _priceCalc,
2266         address _marketFeeTaker,
2267         SpreadCalculatorInterface _spreadCalc,
2268         OracleInterface _oracle,
2269         string memory _name
2270     ) public BoxExchange(_priceCalc, _marketFeeTaker, _name) {
2271         idol = _idol;
2272         token = _token;
2273         spreadCalc = _spreadCalc;
2274         oracle = _oracle;
2275     }
2276 
2277     /**
2278      * @param IDOLAmount Amount of initial liquidity of iDOL to be provided
2279      * @param settlementTokenAmount Amount of initial liquidity of the other token to be provided
2280      * @param initialShare Initial amount of share token
2281      **/
2282     function initializeExchange(
2283         uint256 IDOLAmount,
2284         uint256 settlementTokenAmount,
2285         uint256 initialShare
2286     ) external {
2287         _init(
2288             uint128(IDOLAmount),
2289             uint128(settlementTokenAmount),
2290             initialShare
2291         );
2292     }
2293 
2294     /**
2295      * @param timeout Revert if nextBoxNumber exceeds `timeout`
2296      * @param recipient Recipient of swapped token. If `recipient` == address(0), recipient is msg.sender
2297      * @param IDOLAmount Amount of token that should be approved before executing this function
2298      * @param isLimit Whether the order restricts a large slippage
2299      * @dev if isLimit is true and reserve0/reserve1 * 1.001 >  `rate`, the order will be executed, otherwise token will be refunded
2300      * @dev if isLimit is false and reserve0/reserve1 * 1.05 > `rate`, the order will be executed, otherwise token will be refunded
2301      **/
2302     function orderBaseToSettlement(
2303         uint256 timeout,
2304         address recipient,
2305         uint256 IDOLAmount,
2306         bool isLimit
2307     ) external isAmountSafe(IDOLAmount) isInTime(timeout) {
2308         OrderType orderType = _getTokenType(true, isLimit);
2309         _addOrder(orderType, IDOLAmount, recipient);
2310     }
2311 
2312     /**
2313      * @param timeout Revert if nextBoxNumber exceeds `timeout`
2314      * @param recipient Recipient of swapped token. If `recipient` == address(0), recipient is msg.sender
2315      * @param settlementTokenAmount Amount of token that should be approved before executing this function
2316      * @param isLimit Whether the order restricts a large slippage
2317      * @dev if isLimit is true and reserve0/reserve1 * 0.999 > `rate`, the order will be executed, otherwise token will be refunded
2318      * @dev if isLimit is false and reserve0/reserve1 * 0.95 > `rate`, the order will be executed, otherwise token will be refunded
2319      **/
2320     function orderSettlementToBase(
2321         uint256 timeout,
2322         address recipient,
2323         uint256 settlementTokenAmount,
2324         bool isLimit
2325     ) external isAmountSafe(settlementTokenAmount) isInTime(timeout) {
2326         OrderType orderType = _getTokenType(false, isLimit);
2327         _addOrder(orderType, settlementTokenAmount, recipient);
2328     }
2329 
2330     /**
2331      * @notice LP provides liquidity and receives share token
2332      * @param timeout Revert if nextBoxNumber exceeds `timeout`
2333      * @param IDOLAmount Amount of iDOL to be provided. The amount of the other token required is calculated based on this amount
2334      * @param minShares Minimum amount of share token LP will receive. If amount of share token is less than `minShares`, revert the transaction
2335      **/
2336     function addLiquidity(
2337         uint256 timeout,
2338         uint256 IDOLAmount,
2339         uint256 settlementTokenAmount,
2340         uint256 minShares
2341     )
2342         external
2343         isAmountSafe(IDOLAmount)
2344         isAmountSafe(settlementTokenAmount)
2345         isInTime(timeout)
2346     {
2347         require(timeout > _currentOpenBoxId(), "Time out");
2348         (uint256 _reserve0, uint256 _reserve1) = _getReserves(); // gas savings
2349         uint256 settlementAmountInBase = settlementTokenAmount
2350             .mul(_reserve0)
2351             .div(_reserve1);
2352         if (IDOLAmount <= settlementAmountInBase) {
2353             _addLiquidity(
2354                 _reserve0,
2355                 _reserve1,
2356                 IDOLAmount,
2357                 minShares,
2358                 Token.TOKEN0
2359             );
2360         } else {
2361             _addLiquidity(
2362                 _reserve0,
2363                 _reserve1,
2364                 settlementTokenAmount,
2365                 minShares,
2366                 Token.TOKEN1
2367             );
2368         }
2369     }
2370 
2371     /**
2372      * @notice LP burns share token and receives iDOL and the other token
2373      * @param timeout Revert if nextBoxNumber exceeds `timeout`
2374      * @param minBaseTokens Minimum amount of iDOL LP will receive. If amount of iDOL is less than `minBaseTokens`, revert the transaction
2375      * @param minSettlementTokens Minimum amount of the other token LP will get. If amount is less than `minSettlementTokens`, revert the transaction
2376      * @param sharesBurned Amount of share token to be burned
2377      **/
2378     function removeLiquidity(
2379         uint256 timeout,
2380         uint256 minBaseTokens,
2381         uint256 minSettlementTokens,
2382         uint256 sharesBurned
2383     ) external isInTime(timeout) {
2384         require(timeout > _currentOpenBoxId(), "Time out");
2385         _removeLiquidity(minBaseTokens, minSettlementTokens, sharesBurned);
2386     }
2387 
2388     /**
2389      * @notice Executes orders that are unexecuted
2390      * @param maxOrderNum Max number of orders to be executed
2391      **/
2392     function executeUnexecutedBox(uint8 maxOrderNum) external {
2393         _triggerExecuteOrders(maxOrderNum);
2394     }
2395 
2396     /**
2397      * @notice Sends market fee to Lien Token
2398      **/
2399     function sendMarketFeeToLien() external {
2400         _triggerPayMarketFee();
2401     }
2402 
2403     // definition of abstract functions
2404 
2405     function _receiveTokens(
2406         Token tokenType,
2407         address from,
2408         uint256 amount
2409     ) internal override {
2410         _IERC20(tokenType).safeTransferFrom(from, address(this), amount);
2411     }
2412 
2413     function _sendTokens(
2414         Token tokenType,
2415         address to,
2416         uint256 amount
2417     ) internal override {
2418         _IERC20(tokenType).safeTransfer(to, amount);
2419     }
2420 
2421     function _payForOrderExecution(
2422         Token tokenType,
2423         address to,
2424         uint256 amount
2425     ) internal override {
2426         _IERC20(tokenType).safeTransfer(to, amount);
2427     }
2428 
2429     function _isCurrentOpenBoxExpired() internal override view returns (bool) {
2430         return block.number >= orderBoxes[_currentOpenBoxId()].expireAt;
2431     }
2432 
2433     function _openNewBox() internal override(BoxExchange) {
2434         super._openNewBox();
2435         uint256 _boxNumber = _currentOpenBoxId();
2436         emit SpreadRate(
2437             _boxNumber.toUint128(),
2438             orderBoxes[_boxNumber].spreadRate
2439         );
2440     }
2441 
2442     function _IERC20(Token tokenType) internal view returns (ERC20Interface) {
2443         if (tokenType == Token.TOKEN0) {
2444             return idol;
2445         }
2446         return token;
2447     }
2448 }
2449 
2450 // File: contracts/BoxExchange/TokenBoxExchange/IDOLvsERC20/ERC20BoxExchange.sol
2451 
2452 pragma solidity >=0.6.6;
2453 
2454 
2455 contract ERC20BoxExchange is TokenBoxExchange {
2456     /**
2457      * @param _idol iDOL contract
2458      * @param _token ERC20 contract
2459      * @param _priceCalc Price Calculator contract
2460      * @param _marketFeeTaker Address of market fee taker (i.e. Lien Token)
2461      * @param _spreadCalc Spread Calculator contract
2462      * @param _oracle Oracle contract
2463      * @param _name Name of share token
2464      **/
2465     constructor(
2466         ERC20Interface _idol,
2467         ERC20Interface _token,
2468         PriceCalculatorInterface _priceCalc,
2469         address _marketFeeTaker,
2470         SpreadCalculatorInterface _spreadCalc,
2471         OracleInterface _oracle,
2472         string memory _name
2473     )
2474         public
2475         TokenBoxExchange(
2476             _idol,
2477             _token,
2478             _priceCalc,
2479             _marketFeeTaker,
2480             _spreadCalc,
2481             _oracle,
2482             _name
2483         )
2484     {}
2485 
2486     // definition of abstract functions
2487     function _feeRate() internal override returns (uint128) {
2488         return spreadCalc.calculateSpreadByAssetVolatility(oracle);
2489     }
2490 
2491     function _payMarketFee(
2492         address _marketFeeTaker,
2493         uint256 amount0,
2494         uint256 amount1
2495     ) internal override {
2496         if (amount0 != 0) {
2497             idol.safeTransfer(_marketFeeTaker, amount0);
2498         }
2499     }
2500 
2501     /**
2502      * @notice Updates reserves and market fee pools
2503      * @param spreadRate Spread rate in the box
2504      * @param executingAmount0WithoutSpread Executed amount of TOKEN0 in this box
2505      * @param executingAmount1WithoutSpread Executed amount of TOKEN1 in this box
2506      * @param rate Rate of swap
2507      **/
2508     function _updateReservesAndMarketFeePoolByExecution(
2509         uint256 spreadRate,
2510         uint256 executingAmount0WithoutSpread,
2511         uint256 executingAmount1WithoutSpread,
2512         uint256 rate
2513     ) internal virtual override {
2514         uint256 newReserve0;
2515         uint256 newReserve1;
2516         uint256 newMarketFeePool0;
2517         uint256 marketFee1;
2518         {
2519             (
2520                 uint256 differenceOfReserve,
2521                 uint256 differenceOfMarketFee
2522             ) = _calculateNewReserveAndMarketFeePool(
2523                 spreadRate,
2524                 executingAmount0WithoutSpread,
2525                 executingAmount1WithoutSpread,
2526                 rate,
2527                 Token.TOKEN0
2528             );
2529             newReserve0 = reserve0 + differenceOfReserve;
2530             newMarketFeePool0 = marketFeePool0 + differenceOfMarketFee;
2531         }
2532         {
2533             (newReserve1, marketFee1) = _calculateNewReserveAndMarketFeePool(
2534                 spreadRate,
2535                 executingAmount1WithoutSpread,
2536                 executingAmount0WithoutSpread,
2537                 rate,
2538                 Token.TOKEN1
2539             );
2540             newReserve1 = newReserve1 + reserve1;
2541         }
2542 
2543         {
2544             uint256 convertedSpread1to0 = marketFee1
2545                 .mulByRate(newReserve0.divByRate(newReserve1.add(marketFee1)))
2546                 .divByRate(RateMath.RATE_POINT_MULTIPLIER);
2547             newReserve1 = newReserve1 + marketFee1;
2548             newReserve0 = newReserve0 - convertedSpread1to0;
2549             newMarketFeePool0 = newMarketFeePool0 + convertedSpread1to0;
2550         }
2551         _updateReserve(newReserve0.toUint128(), newReserve1.toUint128());
2552         _updateMarketFeePool(newMarketFeePool0.toUint128());
2553     }
2554 
2555     /**
2556      * updates only pool0
2557      */
2558     function _updateMarketFeePool(uint256 newMarketFeePool0) internal {
2559         marketFeePool0 = newMarketFeePool0.toUint128();
2560     }
2561 }
2562 
2563 // File: @openzeppelin/contracts/math/Math.sol
2564 
2565 // SPDX-License-Identifier: MIT
2566 
2567 pragma solidity ^0.6.0;
2568 
2569 /**
2570  * @dev Standard math utilities missing in the Solidity language.
2571  */
2572 library Math {
2573     /**
2574      * @dev Returns the largest of two numbers.
2575      */
2576     function max(uint256 a, uint256 b) internal pure returns (uint256) {
2577         return a >= b ? a : b;
2578     }
2579 
2580     /**
2581      * @dev Returns the smallest of two numbers.
2582      */
2583     function min(uint256 a, uint256 b) internal pure returns (uint256) {
2584         return a < b ? a : b;
2585     }
2586 
2587     /**
2588      * @dev Returns the average of two numbers. The result is rounded towards
2589      * zero.
2590      */
2591     function average(uint256 a, uint256 b) internal pure returns (uint256) {
2592         // (a + b) / 2 can overflow, so we distribute
2593         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
2594     }
2595 }
2596 
2597 // File: @openzeppelin/contracts/utils/Arrays.sol
2598 
2599 // SPDX-License-Identifier: MIT
2600 
2601 pragma solidity ^0.6.0;
2602 
2603 
2604 /**
2605  * @dev Collection of functions related to array types.
2606  */
2607 library Arrays {
2608    /**
2609      * @dev Searches a sorted `array` and returns the first index that contains
2610      * a value greater or equal to `element`. If no such index exists (i.e. all
2611      * values in the array are strictly less than `element`), the array length is
2612      * returned. Time complexity O(log n).
2613      *
2614      * `array` is expected to be sorted in ascending order, and to contain no
2615      * repeated elements.
2616      */
2617     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
2618         if (array.length == 0) {
2619             return 0;
2620         }
2621 
2622         uint256 low = 0;
2623         uint256 high = array.length;
2624 
2625         while (low < high) {
2626             uint256 mid = Math.average(low, high);
2627 
2628             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
2629             // because Math.average rounds down (it does integer division with truncation).
2630             if (array[mid] > element) {
2631                 high = mid;
2632             } else {
2633                 low = mid + 1;
2634             }
2635         }
2636 
2637         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
2638         if (low > 0 && array[low - 1] == element) {
2639             return low - 1;
2640         } else {
2641             return low;
2642         }
2643     }
2644 }
2645 
2646 // File: @openzeppelin/contracts/utils/Counters.sol
2647 
2648 // SPDX-License-Identifier: MIT
2649 
2650 pragma solidity ^0.6.0;
2651 
2652 
2653 /**
2654  * @title Counters
2655  * @author Matt Condon (@shrugs)
2656  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
2657  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
2658  *
2659  * Include with `using Counters for Counters.Counter;`
2660  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
2661  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
2662  * directly accessed.
2663  */
2664 library Counters {
2665     using SafeMath for uint256;
2666 
2667     struct Counter {
2668         // This variable should never be directly accessed by users of the library: interactions must be restricted to
2669         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
2670         // this feature: see https://github.com/ethereum/solidity/issues/4637
2671         uint256 _value; // default: 0
2672     }
2673 
2674     function current(Counter storage counter) internal view returns (uint256) {
2675         return counter._value;
2676     }
2677 
2678     function increment(Counter storage counter) internal {
2679         // The {SafeMath} overflow check can be skipped here, see the comment at the top
2680         counter._value += 1;
2681     }
2682 
2683     function decrement(Counter storage counter) internal {
2684         counter._value = counter._value.sub(1);
2685     }
2686 }
2687 
2688 // File: @openzeppelin/contracts/token/ERC20/ERC20Snapshot.sol
2689 
2690 // SPDX-License-Identifier: MIT
2691 
2692 pragma solidity ^0.6.0;
2693 
2694 
2695 
2696 
2697 
2698 /**
2699  * @dev This contract extends an ERC20 token with a snapshot mechanism. When a snapshot is created, the balances and
2700  * total supply at the time are recorded for later access.
2701  *
2702  * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.
2703  * In naive implementations it's possible to perform a "double spend" attack by reusing the same balance from different
2704  * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be
2705  * used to create an efficient ERC20 forking mechanism.
2706  *
2707  * Snapshots are created by the internal {_snapshot} function, which will emit the {Snapshot} event and return a
2708  * snapshot id. To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with the snapshot
2709  * id. To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with the snapshot id
2710  * and the account address.
2711  *
2712  * ==== Gas Costs
2713  *
2714  * Snapshots are efficient. Snapshot creation is _O(1)_. Retrieval of balances or total supply from a snapshot is _O(log
2715  * n)_ in the number of snapshots that have been created, although _n_ for a specific account will generally be much
2716  * smaller since identical balances in subsequent snapshots are stored as a single entry.
2717  *
2718  * There is a constant overhead for normal ERC20 transfers due to the additional snapshot bookkeeping. This overhead is
2719  * only significant for the first transfer that immediately follows a snapshot for a particular account. Subsequent
2720  * transfers will have normal cost until the next snapshot, and so on.
2721  */
2722 abstract contract ERC20Snapshot is ERC20 {
2723     // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
2724     // https://github.com/Giveth/minimd/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
2725 
2726     using SafeMath for uint256;
2727     using Arrays for uint256[];
2728     using Counters for Counters.Counter;
2729 
2730     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
2731     // Snapshot struct, but that would impede usage of functions that work on an array.
2732     struct Snapshots {
2733         uint256[] ids;
2734         uint256[] values;
2735     }
2736 
2737     mapping (address => Snapshots) private _accountBalanceSnapshots;
2738     Snapshots private _totalSupplySnapshots;
2739 
2740     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
2741     Counters.Counter private _currentSnapshotId;
2742 
2743     /**
2744      * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
2745      */
2746     event Snapshot(uint256 id);
2747 
2748     /**
2749      * @dev Creates a new snapshot and returns its snapshot id.
2750      *
2751      * Emits a {Snapshot} event that contains the same id.
2752      *
2753      * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
2754      * set of accounts, for example using {AccessControl}, or it may be open to the public.
2755      *
2756      * [WARNING]
2757      * ====
2758      * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
2759      * you must consider that it can potentially be used by attackers in two ways.
2760      *
2761      * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
2762      * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
2763      * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
2764      * section above.
2765      *
2766      * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
2767      * ====
2768      */
2769     function _snapshot() internal virtual returns (uint256) {
2770         _currentSnapshotId.increment();
2771 
2772         uint256 currentId = _currentSnapshotId.current();
2773         emit Snapshot(currentId);
2774         return currentId;
2775     }
2776 
2777     /**
2778      * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
2779      */
2780     function balanceOfAt(address account, uint256 snapshotId) public view returns (uint256) {
2781         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
2782 
2783         return snapshotted ? value : balanceOf(account);
2784     }
2785 
2786     /**
2787      * @dev Retrieves the total supply at the time `snapshotId` was created.
2788      */
2789     function totalSupplyAt(uint256 snapshotId) public view returns(uint256) {
2790         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
2791 
2792         return snapshotted ? value : totalSupply();
2793     }
2794 
2795     // _transfer, _mint and _burn are the only functions where the balances are modified, so it is there that the
2796     // snapshots are updated. Note that the update happens _before_ the balance change, with the pre-modified value.
2797     // The same is true for the total supply and _mint and _burn.
2798     function _transfer(address from, address to, uint256 value) internal virtual override {
2799         _updateAccountSnapshot(from);
2800         _updateAccountSnapshot(to);
2801 
2802         super._transfer(from, to, value);
2803     }
2804 
2805     function _mint(address account, uint256 value) internal virtual override {
2806         _updateAccountSnapshot(account);
2807         _updateTotalSupplySnapshot();
2808 
2809         super._mint(account, value);
2810     }
2811 
2812     function _burn(address account, uint256 value) internal virtual override {
2813         _updateAccountSnapshot(account);
2814         _updateTotalSupplySnapshot();
2815 
2816         super._burn(account, value);
2817     }
2818 
2819     function _valueAt(uint256 snapshotId, Snapshots storage snapshots)
2820         private view returns (bool, uint256)
2821     {
2822         require(snapshotId > 0, "ERC20Snapshot: id is 0");
2823         // solhint-disable-next-line max-line-length
2824         require(snapshotId <= _currentSnapshotId.current(), "ERC20Snapshot: nonexistent id");
2825 
2826         // When a valid snapshot is queried, there are three possibilities:
2827         //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
2828         //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
2829         //  to this id is the current one.
2830         //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
2831         //  requested id, and its value is the one to return.
2832         //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
2833         //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
2834         //  larger than the requested one.
2835         //
2836         // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
2837         // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
2838         // exactly this.
2839 
2840         uint256 index = snapshots.ids.findUpperBound(snapshotId);
2841 
2842         if (index == snapshots.ids.length) {
2843             return (false, 0);
2844         } else {
2845             return (true, snapshots.values[index]);
2846         }
2847     }
2848 
2849     function _updateAccountSnapshot(address account) private {
2850         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
2851     }
2852 
2853     function _updateTotalSupplySnapshot() private {
2854         _updateSnapshot(_totalSupplySnapshots, totalSupply());
2855     }
2856 
2857     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
2858         uint256 currentId = _currentSnapshotId.current();
2859         if (_lastSnapshotId(snapshots.ids) < currentId) {
2860             snapshots.ids.push(currentId);
2861             snapshots.values.push(currentValue);
2862         }
2863     }
2864 
2865     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
2866         if (ids.length == 0) {
2867             return 0;
2868         } else {
2869             return ids[ids.length - 1];
2870         }
2871     }
2872 }
2873 
2874 // File: contracts/Interfaces/LienTokenInterface.sol
2875 
2876 pragma solidity >=0.6.6;
2877 
2878 
2879 interface LienTokenInterface is IERC20 {
2880     function currentTerm() external view returns (uint256);
2881 
2882     function expiration() external view returns (uint256);
2883 
2884     function receiveDividend(address token, address recipient) external;
2885 
2886     function dividendAt(
2887         address token,
2888         address account,
2889         uint256 term
2890     ) external view returns (uint256);
2891 }
2892 
2893 // File: contracts/BoxExchange/TokenBoxExchange/IDOLvsERC20/IDOLvsLien/ERC20Redistribution.sol
2894 
2895 pragma solidity >=0.6.6;
2896 
2897 
2898 
2899 
2900 
2901 
2902 abstract contract ERC20Redistribution is ERC20Snapshot {
2903     using SafeERC20 for ERC20Interface;
2904 
2905     struct Dividend {
2906         mapping(ERC20Interface => uint256) tokens;
2907         uint256 eth;
2908     }
2909 
2910     LienTokenInterface public lien;
2911     mapping(uint256 => uint256) private snapshotsOfTermEnd;
2912     mapping(uint256 => Dividend) private totalDividendsAt;
2913     mapping(address => mapping(ERC20Interface => uint256))
2914         private lastReceivedTermsOfTokens;
2915     mapping(address => uint256) private lastReceivedTermsOfEth;
2916 
2917     event ReceiveDividendETH(address indexed recipient, uint256 amount);
2918     event ReceiveDividendToken(
2919         address indexed recipient,
2920         address indexed tokenAddress,
2921         uint256 amount
2922     );
2923 
2924     modifier termValidation(uint256 _term) {
2925         require(_term > 0, "0 is invalid value as term");
2926         _;
2927     }
2928 
2929     receive() external payable {}
2930 
2931     constructor(LienTokenInterface _lien) public {
2932         lien = _lien;
2933     }
2934 
2935     /**
2936      * @notice Transfers ERC20 token dividend to Liquidity Provider
2937      * @notice Before transfer dividend, this exchange withdraws dividend in this ERC20 token from Lien Token
2938      * @param token Target ERC20 token to be received
2939      */
2940     function receiveDividendToken(ERC20Interface token) public {
2941         uint256 _currentTerm = currentTerm();
2942         if (_currentTerm == 1) {
2943             return;
2944         }
2945         _moveDividendTokenFromLIEN(token, _currentTerm);
2946         uint256 lastReceivedTerm = lastReceivedTermsOfTokens[msg.sender][token];
2947         lastReceivedTermsOfTokens[msg.sender][token] = _currentTerm - 1;
2948         uint256 dividend;
2949         for (uint256 term = lastReceivedTerm + 1; term < _currentTerm; term++) {
2950             dividend += dividendTokenAt(msg.sender, token, term);
2951         }
2952         emit ReceiveDividendToken(msg.sender, address(token), dividend);
2953         token.safeTransfer(msg.sender, dividend);
2954     }
2955 
2956     /**
2957      * @notice Transfers ETH dividend to Liquidity Provider
2958      * @notice Before transfer dividend, this exchange withdraws dividend in ETH from Lien Token
2959      */
2960     function receiveDividendEth() public {
2961         uint256 _currentTerm = currentTerm();
2962         if (_currentTerm == 1) {
2963             return;
2964         }
2965         _moveDividendEthFromLIEN(_currentTerm);
2966         uint256 lastReceivedTerm = lastReceivedTermsOfEth[msg.sender];
2967         lastReceivedTermsOfEth[msg.sender] = _currentTerm - 1;
2968         uint256 dividend;
2969         for (uint256 term = lastReceivedTerm + 1; term < _currentTerm; term++) {
2970             dividend += dividendEthAt(msg.sender, term);
2971         }
2972         emit ReceiveDividendETH(msg.sender, dividend);
2973         // solhint-disable-next-line avoid-low-level-calls
2974         (bool success, ) = msg.sender.call{value: dividend}("");
2975         require(success, "ETH transfer failed");
2976     }
2977 
2978     /**
2979      * @notice Gets current term in Lien Token
2980      **/
2981     function currentTerm() public view returns (uint256) {
2982         return lien.currentTerm();
2983     }
2984 
2985     /**
2986      * @notice Gets amount of ERC20 token dividend LP can get in the `term`
2987      * @param account Target account
2988      * @param token Target ERC20 token
2989      * @param term Target term
2990      **/
2991     function dividendTokenAt(
2992         address account,
2993         ERC20Interface token,
2994         uint256 term
2995     ) public view returns (uint256) {
2996         uint256 balanceAtTermEnd = balanceOfAtTermEnd(account, term);
2997         uint256 totalSupplyAtTermEnd = totalSupplyAtTermEnd(term);
2998         uint256 totalDividend = totalDividendTokenAt(token, term);
2999         return totalDividend.mul(balanceAtTermEnd).div(totalSupplyAtTermEnd);
3000     }
3001 
3002     /**
3003      * @notice Gets Amount of ETH dividend LP can get in the `term`
3004      * @param account Target account
3005      * @param term Target term
3006      **/
3007     function dividendEthAt(address account, uint256 term)
3008         public
3009         view
3010         returns (uint256)
3011     {
3012         uint256 balanceAtTermEnd = balanceOfAtTermEnd(account, term);
3013         uint256 totalSupplyAtTermEnd = totalSupplyAtTermEnd(term);
3014         uint256 totalDividend = totalDividendEthAt(term);
3015         return totalDividend.mul(balanceAtTermEnd).div(totalSupplyAtTermEnd);
3016     }
3017 
3018     /**
3019      * @notice Gets total amount of ERC20 token dividend this exchange received in the `term`
3020      * @param token Target ERC20 token
3021      * @param term Target term
3022      **/
3023     function totalDividendTokenAt(ERC20Interface token, uint256 term)
3024         public
3025         view
3026         returns (uint256)
3027     {
3028         return totalDividendsAt[term].tokens[token];
3029     }
3030 
3031     /**
3032      * @notice Gets total amount of ETH dividend this exchange received in the `term`
3033      * @param term Target term
3034      **/
3035     function totalDividendEthAt(uint256 term) public view returns (uint256) {
3036         return totalDividendsAt[term].eth;
3037     }
3038 
3039     /**
3040      * @notice Retrieves the balance of `account` at the end of the term `term`
3041      * @param account Target account
3042      * @param term Target term
3043      */
3044     function balanceOfAtTermEnd(address account, uint256 term)
3045         public
3046         view
3047         termValidation(term)
3048         returns (uint256)
3049     {
3050         uint256 _currentTerm = currentTerm();
3051         for (uint256 i = term; i < _currentTerm; i++) {
3052             if (_isSnapshottedOnTermEnd(i)) {
3053                 return balanceOfAt(account, snapshotsOfTermEnd[i]);
3054             }
3055         }
3056         return balanceOf(account);
3057     }
3058 
3059     /**
3060      * @notice Retrieves the total supply at the end of the term `term`
3061      * @param term Target term
3062      */
3063     function totalSupplyAtTermEnd(uint256 term)
3064         public
3065         view
3066         termValidation(term)
3067         returns (uint256)
3068     {
3069         uint256 _currentTerm = currentTerm();
3070         for (uint256 i = term; i < _currentTerm; i++) {
3071             if (_isSnapshottedOnTermEnd(i)) {
3072                 return totalSupplyAt(snapshotsOfTermEnd[i]);
3073             }
3074         }
3075         return totalSupply();
3076     }
3077 
3078     function _transfer(
3079         address from,
3080         address to,
3081         uint256 value
3082     ) internal virtual override {
3083         _snapshotOnTermEnd();
3084         super._transfer(from, to, value);
3085     }
3086 
3087     function _mint(address account, uint256 value) internal virtual override {
3088         _snapshotOnTermEnd();
3089         super._mint(account, value);
3090     }
3091 
3092     function _burn(address account, uint256 value) internal virtual override {
3093         _snapshotOnTermEnd();
3094         super._burn(account, value);
3095     }
3096 
3097     function _snapshotOnTermEnd() private {
3098         uint256 _currentTerm = currentTerm();
3099         if (_currentTerm > 1 && !_isSnapshottedOnTermEnd(_currentTerm - 1)) {
3100             snapshotsOfTermEnd[_currentTerm - 1] = _snapshot();
3101         }
3102     }
3103 
3104     function _isSnapshottedOnTermEnd(uint256 term) private view returns (bool) {
3105         return snapshotsOfTermEnd[term] != 0;
3106     }
3107 
3108     /**
3109      * @notice Withdraws dividends in ETH and iDOL from Lien Token
3110      * @dev At first, this function registers amount of dividends from Lien Token, and thereafter withdraws it
3111      **/
3112     function _moveDividendTokenFromLIEN(
3113         ERC20Interface token,
3114         uint256 _currentTerm
3115     ) private {
3116         uint256 expiration = lien.expiration();
3117         uint256 start;
3118         uint256 totalNewDividend;
3119         if (_currentTerm > expiration) {
3120             start = _currentTerm - expiration;
3121         } else {
3122             start = 1;
3123         }
3124         //get and register dividend amount in the exchange from Lien Token contract
3125         for (uint256 i = _currentTerm - 1; i >= start; i--) {
3126             if (totalDividendsAt[i].tokens[token] != 0) {
3127                 break;
3128             }
3129             uint256 dividend = lien.dividendAt(
3130                 address(token),
3131                 address(this),
3132                 i
3133             );
3134             totalDividendsAt[i].tokens[token] = dividend;
3135             totalNewDividend += dividend;
3136         }
3137         if (totalNewDividend == 0) {
3138             return;
3139         }
3140         lien.receiveDividend(address(token), address(this));
3141     }
3142 
3143     /**
3144      * @notice Withdraws dividends in ETH and iDOL from lienToken
3145      * @dev At first, this function registers amount of dividend from Lien Token, and thereafter withdraws it
3146      **/
3147     function _moveDividendEthFromLIEN(uint256 _currentTerm) private {
3148         uint256 expiration = lien.expiration();
3149         uint256 start;
3150         uint256 totalNewDividend;
3151         if (_currentTerm > expiration) {
3152             start = _currentTerm - expiration;
3153         } else {
3154             start = 1;
3155         }
3156         //get and register dividend amount in the exchange from Lien Token contract
3157         for (uint256 i = _currentTerm - 1; i >= start; i--) {
3158             if (totalDividendsAt[i].eth != 0) {
3159                 break;
3160             }
3161             uint256 dividend = lien.dividendAt(address(0), address(this), i);
3162             totalDividendsAt[i].eth = dividend;
3163             totalNewDividend += dividend;
3164         }
3165         if (totalNewDividend == 0) {
3166             return;
3167         }
3168         lien.receiveDividend(address(0), address(this));
3169     }
3170 }
3171 
3172 // File: contracts/BoxExchange/TokenBoxExchange/IDOLvsERC20/IDOLvsLien/LienBoxExchange.sol
3173 
3174 pragma solidity >=0.6.6;
3175 
3176 
3177 
3178 contract LienBoxExchange is ERC20BoxExchange, ERC20Redistribution {
3179     /**
3180      * @param _idol iDOL contract
3181      * @param _priceCalc Price Calculator contract
3182      * @param _lien Lien Token contract
3183      * @param _spreadCalc Spread Calculator contract
3184      * @param _name Name of share token
3185      **/
3186     constructor(
3187         ERC20Interface _idol,
3188         PriceCalculatorInterface _priceCalc,
3189         LienTokenInterface _lien,
3190         SpreadCalculatorInterface _spreadCalc,
3191         string memory _name
3192     )
3193         public
3194         ERC20Redistribution(_lien)
3195         ERC20BoxExchange(
3196             _idol,
3197             ERC20Interface(address(_lien)),
3198             _priceCalc,
3199             address(_lien),
3200             _spreadCalc,
3201             OracleInterface(address(0)),
3202             _name
3203         )
3204     {}
3205 
3206     // overriding ERC20 functions
3207     function _transfer(
3208         address from,
3209         address to,
3210         uint256 value
3211     ) internal override(ERC20, ERC20Redistribution) {
3212         ERC20Redistribution._transfer(from, to, value);
3213     }
3214 
3215     function _burn(address account, uint256 value)
3216         internal
3217         override(ERC20, ERC20Redistribution)
3218     {
3219         ERC20Redistribution._burn(account, value);
3220     }
3221 
3222     function _mint(address account, uint256 value)
3223         internal
3224         override(ERC20, ERC20Redistribution)
3225     {
3226         ERC20Redistribution._mint(account, value);
3227     }
3228 }