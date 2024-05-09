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
351         return functionCall(target, data, "Address: low-level call failed");
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
723 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
724 
725 
726 
727 pragma solidity ^0.6.0;
728 
729 
730 
731 /**
732  * @dev Extension of {ERC20} that allows token holders to destroy both their own
733  * tokens and those that they have an allowance for, in a way that can be
734  * recognized off-chain (via event analysis).
735  */
736 abstract contract ERC20Burnable is Context, ERC20 {
737     /**
738      * @dev Destroys `amount` tokens from the caller.
739      *
740      * See {ERC20-_burn}.
741      */
742     function burn(uint256 amount) public virtual {
743         _burn(_msgSender(), amount);
744     }
745 
746     /**
747      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
748      * allowance.
749      *
750      * See {ERC20-_burn} and {ERC20-allowance}.
751      *
752      * Requirements:
753      *
754      * - the caller must have allowance for ``accounts``'s tokens of at least
755      * `amount`.
756      */
757     function burnFrom(address account, uint256 amount) public virtual {
758         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
759 
760         _approve(account, _msgSender(), decreasedAllowance);
761         _burn(account, amount);
762     }
763 }
764 
765 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
766 
767 
768 
769 pragma solidity ^0.6.0;
770 
771 /**
772  * @dev Library for managing
773  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
774  * types.
775  *
776  * Sets have the following properties:
777  *
778  * - Elements are added, removed, and checked for existence in constant time
779  * (O(1)).
780  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
781  *
782  * ```
783  * contract Example {
784  *     // Add the library methods
785  *     using EnumerableSet for EnumerableSet.AddressSet;
786  *
787  *     // Declare a set state variable
788  *     EnumerableSet.AddressSet private mySet;
789  * }
790  * ```
791  *
792  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
793  * (`UintSet`) are supported.
794  */
795 library EnumerableSet {
796     // To implement this library for multiple types with as little code
797     // repetition as possible, we write it in terms of a generic Set type with
798     // bytes32 values.
799     // The Set implementation uses private functions, and user-facing
800     // implementations (such as AddressSet) are just wrappers around the
801     // underlying Set.
802     // This means that we can only create new EnumerableSets for types that fit
803     // in bytes32.
804 
805     struct Set {
806         // Storage of set values
807         bytes32[] _values;
808 
809         // Position of the value in the `values` array, plus 1 because index 0
810         // means a value is not in the set.
811         mapping (bytes32 => uint256) _indexes;
812     }
813 
814     /**
815      * @dev Add a value to a set. O(1).
816      *
817      * Returns true if the value was added to the set, that is if it was not
818      * already present.
819      */
820     function _add(Set storage set, bytes32 value) private returns (bool) {
821         if (!_contains(set, value)) {
822             set._values.push(value);
823             // The value is stored at length-1, but we add 1 to all indexes
824             // and use 0 as a sentinel value
825             set._indexes[value] = set._values.length;
826             return true;
827         } else {
828             return false;
829         }
830     }
831 
832     /**
833      * @dev Removes a value from a set. O(1).
834      *
835      * Returns true if the value was removed from the set, that is if it was
836      * present.
837      */
838     function _remove(Set storage set, bytes32 value) private returns (bool) {
839         // We read and store the value's index to prevent multiple reads from the same storage slot
840         uint256 valueIndex = set._indexes[value];
841 
842         if (valueIndex != 0) { // Equivalent to contains(set, value)
843             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
844             // the array, and then remove the last element (sometimes called as 'swap and pop').
845             // This modifies the order of the array, as noted in {at}.
846 
847             uint256 toDeleteIndex = valueIndex - 1;
848             uint256 lastIndex = set._values.length - 1;
849 
850             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
851             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
852 
853             bytes32 lastvalue = set._values[lastIndex];
854 
855             // Move the last value to the index where the value to delete is
856             set._values[toDeleteIndex] = lastvalue;
857             // Update the index for the moved value
858             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
859 
860             // Delete the slot where the moved value was stored
861             set._values.pop();
862 
863             // Delete the index for the deleted slot
864             delete set._indexes[value];
865 
866             return true;
867         } else {
868             return false;
869         }
870     }
871 
872     /**
873      * @dev Returns true if the value is in the set. O(1).
874      */
875     function _contains(Set storage set, bytes32 value) private view returns (bool) {
876         return set._indexes[value] != 0;
877     }
878 
879     /**
880      * @dev Returns the number of values on the set. O(1).
881      */
882     function _length(Set storage set) private view returns (uint256) {
883         return set._values.length;
884     }
885 
886     /**
887      * @dev Returns the value stored at position `index` in the set. O(1).
888      *
889      * Note that there are no guarantees on the ordering of values inside the
890      * array, and it may change when more values are added or removed.
891      *
892      * Requirements:
893      *
894      * - `index` must be strictly less than {length}.
895      */
896     function _at(Set storage set, uint256 index) private view returns (bytes32) {
897         require(set._values.length > index, "EnumerableSet: index out of bounds");
898         return set._values[index];
899     }
900 
901     // AddressSet
902 
903     struct AddressSet {
904         Set _inner;
905     }
906 
907     /**
908      * @dev Add a value to a set. O(1).
909      *
910      * Returns true if the value was added to the set, that is if it was not
911      * already present.
912      */
913     function add(AddressSet storage set, address value) internal returns (bool) {
914         return _add(set._inner, bytes32(uint256(value)));
915     }
916 
917     /**
918      * @dev Removes a value from a set. O(1).
919      *
920      * Returns true if the value was removed from the set, that is if it was
921      * present.
922      */
923     function remove(AddressSet storage set, address value) internal returns (bool) {
924         return _remove(set._inner, bytes32(uint256(value)));
925     }
926 
927     /**
928      * @dev Returns true if the value is in the set. O(1).
929      */
930     function contains(AddressSet storage set, address value) internal view returns (bool) {
931         return _contains(set._inner, bytes32(uint256(value)));
932     }
933 
934     /**
935      * @dev Returns the number of values in the set. O(1).
936      */
937     function length(AddressSet storage set) internal view returns (uint256) {
938         return _length(set._inner);
939     }
940 
941     /**
942      * @dev Returns the value stored at position `index` in the set. O(1).
943      *
944      * Note that there are no guarantees on the ordering of values inside the
945      * array, and it may change when more values are added or removed.
946      *
947      * Requirements:
948      *
949      * - `index` must be strictly less than {length}.
950      */
951     function at(AddressSet storage set, uint256 index) internal view returns (address) {
952         return address(uint256(_at(set._inner, index)));
953     }
954 
955 
956     // UintSet
957 
958     struct UintSet {
959         Set _inner;
960     }
961 
962     /**
963      * @dev Add a value to a set. O(1).
964      *
965      * Returns true if the value was added to the set, that is if it was not
966      * already present.
967      */
968     function add(UintSet storage set, uint256 value) internal returns (bool) {
969         return _add(set._inner, bytes32(value));
970     }
971 
972     /**
973      * @dev Removes a value from a set. O(1).
974      *
975      * Returns true if the value was removed from the set, that is if it was
976      * present.
977      */
978     function remove(UintSet storage set, uint256 value) internal returns (bool) {
979         return _remove(set._inner, bytes32(value));
980     }
981 
982     /**
983      * @dev Returns true if the value is in the set. O(1).
984      */
985     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
986         return _contains(set._inner, bytes32(value));
987     }
988 
989     /**
990      * @dev Returns the number of values on the set. O(1).
991      */
992     function length(UintSet storage set) internal view returns (uint256) {
993         return _length(set._inner);
994     }
995 
996     /**
997      * @dev Returns the value stored at position `index` in the set. O(1).
998      *
999      * Note that there are no guarantees on the ordering of values inside the
1000      * array, and it may change when more values are added or removed.
1001      *
1002      * Requirements:
1003      *
1004      * - `index` must be strictly less than {length}.
1005      */
1006     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1007         return uint256(_at(set._inner, index));
1008     }
1009 }
1010 
1011 // File: @openzeppelin/contracts/access/AccessControl.sol
1012 
1013 
1014 
1015 pragma solidity ^0.6.0;
1016 
1017 
1018 
1019 
1020 /**
1021  * @dev Contract module that allows children to implement role-based access
1022  * control mechanisms.
1023  *
1024  * Roles are referred to by their `bytes32` identifier. These should be exposed
1025  * in the external API and be unique. The best way to achieve this is by
1026  * using `public constant` hash digests:
1027  *
1028  * ```
1029  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1030  * ```
1031  *
1032  * Roles can be used to represent a set of permissions. To restrict access to a
1033  * function call, use {hasRole}:
1034  *
1035  * ```
1036  * function foo() public {
1037  *     require(hasRole(MY_ROLE, msg.sender));
1038  *     ...
1039  * }
1040  * ```
1041  *
1042  * Roles can be granted and revoked dynamically via the {grantRole} and
1043  * {revokeRole} functions. Each role has an associated admin role, and only
1044  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1045  *
1046  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1047  * that only accounts with this role will be able to grant or revoke other
1048  * roles. More complex role relationships can be created by using
1049  * {_setRoleAdmin}.
1050  *
1051  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1052  * grant and revoke this role. Extra precautions should be taken to secure
1053  * accounts that have been granted it.
1054  */
1055 abstract contract AccessControl is Context {
1056     using EnumerableSet for EnumerableSet.AddressSet;
1057     using Address for address;
1058 
1059     struct RoleData {
1060         EnumerableSet.AddressSet members;
1061         bytes32 adminRole;
1062     }
1063 
1064     mapping (bytes32 => RoleData) private _roles;
1065 
1066     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1067 
1068     /**
1069      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1070      *
1071      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1072      * {RoleAdminChanged} not being emitted signaling this.
1073      *
1074      * _Available since v3.1._
1075      */
1076     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1077 
1078     /**
1079      * @dev Emitted when `account` is granted `role`.
1080      *
1081      * `sender` is the account that originated the contract call, an admin role
1082      * bearer except when using {_setupRole}.
1083      */
1084     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1085 
1086     /**
1087      * @dev Emitted when `account` is revoked `role`.
1088      *
1089      * `sender` is the account that originated the contract call:
1090      *   - if using `revokeRole`, it is the admin role bearer
1091      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1092      */
1093     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1094 
1095     /**
1096      * @dev Returns `true` if `account` has been granted `role`.
1097      */
1098     function hasRole(bytes32 role, address account) public view returns (bool) {
1099         return _roles[role].members.contains(account);
1100     }
1101 
1102     /**
1103      * @dev Returns the number of accounts that have `role`. Can be used
1104      * together with {getRoleMember} to enumerate all bearers of a role.
1105      */
1106     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1107         return _roles[role].members.length();
1108     }
1109 
1110     /**
1111      * @dev Returns one of the accounts that have `role`. `index` must be a
1112      * value between 0 and {getRoleMemberCount}, non-inclusive.
1113      *
1114      * Role bearers are not sorted in any particular way, and their ordering may
1115      * change at any point.
1116      *
1117      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1118      * you perform all queries on the same block. See the following
1119      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1120      * for more information.
1121      */
1122     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1123         return _roles[role].members.at(index);
1124     }
1125 
1126     /**
1127      * @dev Returns the admin role that controls `role`. See {grantRole} and
1128      * {revokeRole}.
1129      *
1130      * To change a role's admin, use {_setRoleAdmin}.
1131      */
1132     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1133         return _roles[role].adminRole;
1134     }
1135 
1136     /**
1137      * @dev Grants `role` to `account`.
1138      *
1139      * If `account` had not been already granted `role`, emits a {RoleGranted}
1140      * event.
1141      *
1142      * Requirements:
1143      *
1144      * - the caller must have ``role``'s admin role.
1145      */
1146     function grantRole(bytes32 role, address account) public virtual {
1147         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1148 
1149         _grantRole(role, account);
1150     }
1151 
1152     /**
1153      * @dev Revokes `role` from `account`.
1154      *
1155      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1156      *
1157      * Requirements:
1158      *
1159      * - the caller must have ``role``'s admin role.
1160      */
1161     function revokeRole(bytes32 role, address account) public virtual {
1162         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1163 
1164         _revokeRole(role, account);
1165     }
1166 
1167     /**
1168      * @dev Revokes `role` from the calling account.
1169      *
1170      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1171      * purpose is to provide a mechanism for accounts to lose their privileges
1172      * if they are compromised (such as when a trusted device is misplaced).
1173      *
1174      * If the calling account had been granted `role`, emits a {RoleRevoked}
1175      * event.
1176      *
1177      * Requirements:
1178      *
1179      * - the caller must be `account`.
1180      */
1181     function renounceRole(bytes32 role, address account) public virtual {
1182         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1183 
1184         _revokeRole(role, account);
1185     }
1186 
1187     /**
1188      * @dev Grants `role` to `account`.
1189      *
1190      * If `account` had not been already granted `role`, emits a {RoleGranted}
1191      * event. Note that unlike {grantRole}, this function doesn't perform any
1192      * checks on the calling account.
1193      *
1194      * [WARNING]
1195      * ====
1196      * This function should only be called from the constructor when setting
1197      * up the initial roles for the system.
1198      *
1199      * Using this function in any other way is effectively circumventing the admin
1200      * system imposed by {AccessControl}.
1201      * ====
1202      */
1203     function _setupRole(bytes32 role, address account) internal virtual {
1204         _grantRole(role, account);
1205     }
1206 
1207     /**
1208      * @dev Sets `adminRole` as ``role``'s admin role.
1209      *
1210      * Emits a {RoleAdminChanged} event.
1211      */
1212     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1213         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1214         _roles[role].adminRole = adminRole;
1215     }
1216 
1217     function _grantRole(bytes32 role, address account) private {
1218         if (_roles[role].members.add(account)) {
1219             emit RoleGranted(role, account, _msgSender());
1220         }
1221     }
1222 
1223     function _revokeRole(bytes32 role, address account) private {
1224         if (_roles[role].members.remove(account)) {
1225             emit RoleRevoked(role, account, _msgSender());
1226         }
1227     }
1228 }
1229 
1230 // File: contracts/RIOToken.sol
1231 
1232 pragma solidity ^0.6.0;
1233 
1234 
1235 
1236 
1237 
1238 /**
1239  * @dev {ERC20} token, including:
1240  *
1241  *  - ability for holders to burn (destroy) their tokens
1242  *  - a minter role that allows for token minting (creation)
1243  *  - a pauser role that allows to stop all token transfers
1244  *
1245  * This contract uses {AccessControl} to lock permissioned functions using the
1246  * different roles - head to its documentation for details.
1247  *
1248  * The account that deploys the contract will be granted the minter and pauser
1249  * roles, as well as the default admin role, which will let it grant both minter
1250  * and pauser roles to other accounts.
1251  */
1252 contract RIOToken is Context, AccessControl, ERC20Burnable {
1253     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1254     bool private _isMintLocked = false;
1255 
1256     /**
1257      * @dev Grants `DEFAULT_ADMIN_ROLE`, and `MINTER_ROLE` to the
1258      * account that deploys the contract.
1259      *
1260      * See {ERC20-constructor}.
1261      */
1262     constructor() public ERC20("Realio Network", "RIO") {
1263         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1264 
1265         _setupRole(MINTER_ROLE, _msgSender());
1266 
1267         mint(msg.sender, 100000000000000000000000000);
1268 
1269         _lockMinting();
1270     }
1271 
1272     /**
1273      * @dev Creates `amount` new tokens for `to`.
1274      *
1275      * See {ERC20-_mint}.
1276      *
1277      * Requirements:
1278      *
1279      * - the caller must have the `MINTER_ROLE`.
1280      */
1281     function mint(address to, uint256 amount) public virtual {
1282         require(hasRole(MINTER_ROLE, _msgSender()), "RIOToken: must have minter role to mint");
1283         require(!getIsMintLocked(), "RIOToken: mint is locked");
1284         _mint(to, amount);
1285     }
1286 
1287     /**
1288     * Set mint lock
1289     */
1290     function _lockMinting() internal {
1291         require(!getIsMintLocked(), "RIOToken: mint is locked");
1292         _isMintLocked = true;
1293     }
1294 
1295     function getIsMintLocked() public view returns (bool isMintLocked) {
1296         return _isMintLocked;
1297     }
1298 }