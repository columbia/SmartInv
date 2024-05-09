1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.7.0;
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
32 pragma solidity ^0.7.0;
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
112 pragma solidity ^0.7.0;
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
274 pragma solidity ^0.7.0;
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
416 
417 
418 pragma solidity ^0.7.0;
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
471     constructor (string memory name_, string memory symbol_) {
472         _name = name_;
473         _symbol = symbol_;
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
723 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
724 
725 
726 
727 pragma solidity ^0.7.0;
728 
729 
730 
731 /**
732  * @dev Extension of {ERC20} that allows token holders to destroy both their own
733  * tokens and those that they have an allowance for, in a way that can be
734  * recognized off-chain (via event analysis).
735  */
736 abstract contract ERC20Burnable is Context, ERC20 {
737     using SafeMath for uint256;
738 
739     /**
740      * @dev Destroys `amount` tokens from the caller.
741      *
742      * See {ERC20-_burn}.
743      */
744     function burn(uint256 amount) public virtual {
745         _burn(_msgSender(), amount);
746     }
747 
748     /**
749      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
750      * allowance.
751      *
752      * See {ERC20-_burn} and {ERC20-allowance}.
753      *
754      * Requirements:
755      *
756      * - the caller must have allowance for ``accounts``'s tokens of at least
757      * `amount`.
758      */
759     function burnFrom(address account, uint256 amount) public virtual {
760         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
761 
762         _approve(account, _msgSender(), decreasedAllowance);
763         _burn(account, amount);
764     }
765 }
766 
767 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
768 
769 
770 
771 pragma solidity ^0.7.0;
772 
773 
774 /**
775  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
776  */
777 abstract contract ERC20Capped is ERC20 {
778     using SafeMath for uint256;
779 
780     uint256 private _cap;
781 
782     /**
783      * @dev Sets the value of the `cap`. This value is immutable, it can only be
784      * set once during construction.
785      */
786     constructor (uint256 cap_) {
787         require(cap_ > 0, "ERC20Capped: cap is 0");
788         _cap = cap_;
789     }
790 
791     /**
792      * @dev Returns the cap on the token's total supply.
793      */
794     function cap() public view returns (uint256) {
795         return _cap;
796     }
797 
798     /**
799      * @dev See {ERC20-_beforeTokenTransfer}.
800      *
801      * Requirements:
802      *
803      * - minted tokens must not cause the total supply to go over the cap.
804      */
805     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
806         super._beforeTokenTransfer(from, to, amount);
807 
808         if (from == address(0)) { // When minting tokens
809             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
810         }
811     }
812 }
813 
814 // File: @openzeppelin/contracts/introspection/IERC165.sol
815 
816 
817 
818 pragma solidity ^0.7.0;
819 
820 /**
821  * @dev Interface of the ERC165 standard, as defined in the
822  * https://eips.ethereum.org/EIPS/eip-165[EIP].
823  *
824  * Implementers can declare support of contract interfaces, which can then be
825  * queried by others ({ERC165Checker}).
826  *
827  * For an implementation, see {ERC165}.
828  */
829 interface IERC165 {
830     /**
831      * @dev Returns true if this contract implements the interface defined by
832      * `interfaceId`. See the corresponding
833      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
834      * to learn more about how these ids are created.
835      *
836      * This function call must use less than 30 000 gas.
837      */
838     function supportsInterface(bytes4 interfaceId) external view returns (bool);
839 }
840 
841 // File: erc-payable-token/contracts/token/ERC1363/IERC1363.sol
842 
843 
844 
845 pragma solidity ^0.7.0;
846 
847 
848 
849 /**
850  * @title IERC1363 Interface
851  * @dev Interface for a Payable Token contract as defined in
852  *  https://eips.ethereum.org/EIPS/eip-1363
853  */
854 interface IERC1363 is IERC20, IERC165 {
855     /*
856      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
857      * 0x4bbee2df ===
858      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
859      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
860      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
861      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
862      */
863 
864     /*
865      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
866      * 0xfb9ec8ce ===
867      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
868      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
869      */
870 
871     /**
872      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
873      * @param to address The address which you want to transfer to
874      * @param value uint256 The amount of tokens to be transferred
875      * @return true unless throwing
876      */
877     function transferAndCall(address to, uint256 value) external returns (bool);
878 
879     /**
880      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
881      * @param to address The address which you want to transfer to
882      * @param value uint256 The amount of tokens to be transferred
883      * @param data bytes Additional data with no specified format, sent in call to `to`
884      * @return true unless throwing
885      */
886     function transferAndCall(address to, uint256 value, bytes calldata data) external returns (bool);
887 
888     /**
889      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
890      * @param from address The address which you want to send tokens from
891      * @param to address The address which you want to transfer to
892      * @param value uint256 The amount of tokens to be transferred
893      * @return true unless throwing
894      */
895     function transferFromAndCall(address from, address to, uint256 value) external returns (bool);
896 
897     /**
898      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
899      * @param from address The address which you want to send tokens from
900      * @param to address The address which you want to transfer to
901      * @param value uint256 The amount of tokens to be transferred
902      * @param data bytes Additional data with no specified format, sent in call to `to`
903      * @return true unless throwing
904      */
905     function transferFromAndCall(address from, address to, uint256 value, bytes calldata data) external returns (bool);
906 
907     /**
908      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
909      * and then call `onApprovalReceived` on spender.
910      * Beware that changing an allowance with this method brings the risk that someone may use both the old
911      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
912      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
913      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
914      * @param spender address The address which will spend the funds
915      * @param value uint256 The amount of tokens to be spent
916      */
917     function approveAndCall(address spender, uint256 value) external returns (bool);
918 
919     /**
920      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
921      * and then call `onApprovalReceived` on spender.
922      * Beware that changing an allowance with this method brings the risk that someone may use both the old
923      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
924      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
925      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
926      * @param spender address The address which will spend the funds
927      * @param value uint256 The amount of tokens to be spent
928      * @param data bytes Additional data with no specified format, sent in call to `spender`
929      */
930     function approveAndCall(address spender, uint256 value, bytes calldata data) external returns (bool);
931 }
932 
933 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Receiver.sol
934 
935 
936 
937 pragma solidity ^0.7.0;
938 
939 /**
940  * @title IERC1363Receiver Interface
941  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
942  *  from ERC1363 token contracts as defined in
943  *  https://eips.ethereum.org/EIPS/eip-1363
944  */
945 interface IERC1363Receiver {
946     /*
947      * Note: the ERC-165 identifier for this interface is 0x88a7ca5c.
948      * 0x88a7ca5c === bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))
949      */
950 
951     /**
952      * @notice Handle the receipt of ERC1363 tokens
953      * @dev Any ERC1363 smart contract calls this function on the recipient
954      * after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
955      * transfer. Return of other than the magic value MUST result in the
956      * transaction being reverted.
957      * Note: the token contract address is always the message sender.
958      * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
959      * @param from address The address which are token transferred from
960      * @param value uint256 The amount of tokens transferred
961      * @param data bytes Additional data with no specified format
962      * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
963      *  unless throwing
964      */
965     function onTransferReceived(address operator, address from, uint256 value, bytes calldata data) external returns (bytes4);
966 }
967 
968 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Spender.sol
969 
970 
971 
972 pragma solidity ^0.7.0;
973 
974 /**
975  * @title IERC1363Spender Interface
976  * @dev Interface for any contract that wants to support approveAndCall
977  *  from ERC1363 token contracts as defined in
978  *  https://eips.ethereum.org/EIPS/eip-1363
979  */
980 interface IERC1363Spender {
981     /*
982      * Note: the ERC-165 identifier for this interface is 0x7b04a2d0.
983      * 0x7b04a2d0 === bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))
984      */
985 
986     /**
987      * @notice Handle the approval of ERC1363 tokens
988      * @dev Any ERC1363 smart contract calls this function on the recipient
989      * after an `approve`. This function MAY throw to revert and reject the
990      * approval. Return of other than the magic value MUST result in the
991      * transaction being reverted.
992      * Note: the token contract address is always the message sender.
993      * @param owner address The address which called `approveAndCall` function
994      * @param value uint256 The amount of tokens to be spent
995      * @param data bytes Additional data with no specified format
996      * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
997      *  unless throwing
998      */
999     function onApprovalReceived(address owner, uint256 value, bytes calldata data) external returns (bytes4);
1000 }
1001 
1002 // File: @openzeppelin/contracts/introspection/ERC165Checker.sol
1003 
1004 
1005 
1006 pragma solidity ^0.7.0;
1007 
1008 /**
1009  * @dev Library used to query support of an interface declared via {IERC165}.
1010  *
1011  * Note that these functions return the actual result of the query: they do not
1012  * `revert` if an interface is not supported. It is up to the caller to decide
1013  * what to do in these cases.
1014  */
1015 library ERC165Checker {
1016     // As per the EIP-165 spec, no interface should ever match 0xffffffff
1017     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
1018 
1019     /*
1020      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1021      */
1022     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1023 
1024     /**
1025      * @dev Returns true if `account` supports the {IERC165} interface,
1026      */
1027     function supportsERC165(address account) internal view returns (bool) {
1028         // Any contract that implements ERC165 must explicitly indicate support of
1029         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
1030         return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
1031             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
1032     }
1033 
1034     /**
1035      * @dev Returns true if `account` supports the interface defined by
1036      * `interfaceId`. Support for {IERC165} itself is queried automatically.
1037      *
1038      * See {IERC165-supportsInterface}.
1039      */
1040     function supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
1041         // query support of both ERC165 as per the spec and support of _interfaceId
1042         return supportsERC165(account) &&
1043             _supportsERC165Interface(account, interfaceId);
1044     }
1045 
1046     /**
1047      * @dev Returns true if `account` supports all the interfaces defined in
1048      * `interfaceIds`. Support for {IERC165} itself is queried automatically.
1049      *
1050      * Batch-querying can lead to gas savings by skipping repeated checks for
1051      * {IERC165} support.
1052      *
1053      * See {IERC165-supportsInterface}.
1054      */
1055     function supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
1056         // query support of ERC165 itself
1057         if (!supportsERC165(account)) {
1058             return false;
1059         }
1060 
1061         // query support of each interface in _interfaceIds
1062         for (uint256 i = 0; i < interfaceIds.length; i++) {
1063             if (!_supportsERC165Interface(account, interfaceIds[i])) {
1064                 return false;
1065             }
1066         }
1067 
1068         // all interfaces supported
1069         return true;
1070     }
1071 
1072     /**
1073      * @notice Query if a contract implements an interface, does not check ERC165 support
1074      * @param account The address of the contract to query for support of an interface
1075      * @param interfaceId The interface identifier, as specified in ERC-165
1076      * @return true if the contract at account indicates support of the interface with
1077      * identifier interfaceId, false otherwise
1078      * @dev Assumes that account contains a contract that supports ERC165, otherwise
1079      * the behavior of this method is undefined. This precondition can be checked
1080      * with {supportsERC165}.
1081      * Interface identification is specified in ERC-165.
1082      */
1083     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
1084         // success determines whether the staticcall succeeded and result determines
1085         // whether the contract at account indicates support of _interfaceId
1086         (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);
1087 
1088         return (success && result);
1089     }
1090 
1091     /**
1092      * @notice Calls the function with selector 0x01ffc9a7 (ERC165) and suppresses throw
1093      * @param account The address of the contract to query for support of an interface
1094      * @param interfaceId The interface identifier, as specified in ERC-165
1095      * @return success true if the STATICCALL succeeded, false otherwise
1096      * @return result true if the STATICCALL succeeded and the contract at account
1097      * indicates support of the interface with identifier interfaceId, false otherwise
1098      */
1099     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
1100         private
1101         view
1102         returns (bool, bool)
1103     {
1104         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
1105         (bool success, bytes memory result) = account.staticcall{ gas: 30000 }(encodedParams);
1106         if (result.length < 32) return (false, false);
1107         return (success, abi.decode(result, (bool)));
1108     }
1109 }
1110 
1111 // File: @openzeppelin/contracts/introspection/ERC165.sol
1112 
1113 
1114 
1115 pragma solidity ^0.7.0;
1116 
1117 
1118 /**
1119  * @dev Implementation of the {IERC165} interface.
1120  *
1121  * Contracts may inherit from this and call {_registerInterface} to declare
1122  * their support of an interface.
1123  */
1124 abstract contract ERC165 is IERC165 {
1125     /*
1126      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1127      */
1128     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1129 
1130     /**
1131      * @dev Mapping of interface ids to whether or not it's supported.
1132      */
1133     mapping(bytes4 => bool) private _supportedInterfaces;
1134 
1135     constructor () {
1136         // Derived contracts need only register support for their own interfaces,
1137         // we register support for ERC165 itself here
1138         _registerInterface(_INTERFACE_ID_ERC165);
1139     }
1140 
1141     /**
1142      * @dev See {IERC165-supportsInterface}.
1143      *
1144      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1145      */
1146     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
1147         return _supportedInterfaces[interfaceId];
1148     }
1149 
1150     /**
1151      * @dev Registers the contract as an implementer of the interface defined by
1152      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1153      * registering its interface id is not required.
1154      *
1155      * See {IERC165-supportsInterface}.
1156      *
1157      * Requirements:
1158      *
1159      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1160      */
1161     function _registerInterface(bytes4 interfaceId) internal virtual {
1162         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1163         _supportedInterfaces[interfaceId] = true;
1164     }
1165 }
1166 
1167 // File: erc-payable-token/contracts/token/ERC1363/ERC1363.sol
1168 
1169 
1170 
1171 pragma solidity ^0.7.0;
1172 
1173 
1174 
1175 
1176 
1177 
1178 
1179 
1180 /**
1181  * @title ERC1363
1182  * @dev Implementation of an ERC1363 interface
1183  */
1184 contract ERC1363 is ERC20, IERC1363, ERC165 {
1185     using Address for address;
1186 
1187     /*
1188      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
1189      * 0x4bbee2df ===
1190      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
1191      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
1192      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
1193      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
1194      */
1195     bytes4 internal constant _INTERFACE_ID_ERC1363_TRANSFER = 0x4bbee2df;
1196 
1197     /*
1198      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
1199      * 0xfb9ec8ce ===
1200      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
1201      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
1202      */
1203     bytes4 internal constant _INTERFACE_ID_ERC1363_APPROVE = 0xfb9ec8ce;
1204 
1205     // Equals to `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
1206     // which can be also obtained as `IERC1363Receiver(0).onTransferReceived.selector`
1207     bytes4 private constant _ERC1363_RECEIVED = 0x88a7ca5c;
1208 
1209     // Equals to `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
1210     // which can be also obtained as `IERC1363Spender(0).onApprovalReceived.selector`
1211     bytes4 private constant _ERC1363_APPROVED = 0x7b04a2d0;
1212 
1213     /**
1214      * @param name Name of the token
1215      * @param symbol A symbol to be used as ticker
1216      */
1217     constructor (string memory name, string memory symbol) ERC20(name, symbol) {
1218         // register the supported interfaces to conform to ERC1363 via ERC165
1219         _registerInterface(_INTERFACE_ID_ERC1363_TRANSFER);
1220         _registerInterface(_INTERFACE_ID_ERC1363_APPROVE);
1221     }
1222 
1223     /**
1224      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
1225      * @param to The address to transfer to.
1226      * @param value The amount to be transferred.
1227      * @return A boolean that indicates if the operation was successful.
1228      */
1229     function transferAndCall(address to, uint256 value) public override returns (bool) {
1230         return transferAndCall(to, value, "");
1231     }
1232 
1233     /**
1234      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
1235      * @param to The address to transfer to
1236      * @param value The amount to be transferred
1237      * @param data Additional data with no specified format
1238      * @return A boolean that indicates if the operation was successful.
1239      */
1240     function transferAndCall(address to, uint256 value, bytes memory data) public override returns (bool) {
1241         transfer(to, value);
1242         require(_checkAndCallTransfer(_msgSender(), to, value, data), "ERC1363: _checkAndCallTransfer reverts");
1243         return true;
1244     }
1245 
1246     /**
1247      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
1248      * @param from The address which you want to send tokens from
1249      * @param to The address which you want to transfer to
1250      * @param value The amount of tokens to be transferred
1251      * @return A boolean that indicates if the operation was successful.
1252      */
1253     function transferFromAndCall(address from, address to, uint256 value) public override returns (bool) {
1254         return transferFromAndCall(from, to, value, "");
1255     }
1256 
1257     /**
1258      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
1259      * @param from The address which you want to send tokens from
1260      * @param to The address which you want to transfer to
1261      * @param value The amount of tokens to be transferred
1262      * @param data Additional data with no specified format
1263      * @return A boolean that indicates if the operation was successful.
1264      */
1265     function transferFromAndCall(address from, address to, uint256 value, bytes memory data) public override returns (bool) {
1266         transferFrom(from, to, value);
1267         require(_checkAndCallTransfer(from, to, value, data), "ERC1363: _checkAndCallTransfer reverts");
1268         return true;
1269     }
1270 
1271     /**
1272      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1273      * @param spender The address allowed to transfer to
1274      * @param value The amount allowed to be transferred
1275      * @return A boolean that indicates if the operation was successful.
1276      */
1277     function approveAndCall(address spender, uint256 value) public override returns (bool) {
1278         return approveAndCall(spender, value, "");
1279     }
1280 
1281     /**
1282      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1283      * @param spender The address allowed to transfer to.
1284      * @param value The amount allowed to be transferred.
1285      * @param data Additional data with no specified format.
1286      * @return A boolean that indicates if the operation was successful.
1287      */
1288     function approveAndCall(address spender, uint256 value, bytes memory data) public override returns (bool) {
1289         approve(spender, value);
1290         require(_checkAndCallApprove(spender, value, data), "ERC1363: _checkAndCallApprove reverts");
1291         return true;
1292     }
1293 
1294     /**
1295      * @dev Internal function to invoke `onTransferReceived` on a target address
1296      *  The call is not executed if the target address is not a contract
1297      * @param from address Representing the previous owner of the given token value
1298      * @param to address Target address that will receive the tokens
1299      * @param value uint256 The amount mount of tokens to be transferred
1300      * @param data bytes Optional data to send along with the call
1301      * @return whether the call correctly returned the expected magic value
1302      */
1303     function _checkAndCallTransfer(address from, address to, uint256 value, bytes memory data) internal returns (bool) {
1304         if (!to.isContract()) {
1305             return false;
1306         }
1307         bytes4 retval = IERC1363Receiver(to).onTransferReceived(
1308             _msgSender(), from, value, data
1309         );
1310         return (retval == _ERC1363_RECEIVED);
1311     }
1312 
1313     /**
1314      * @dev Internal function to invoke `onApprovalReceived` on a target address
1315      *  The call is not executed if the target address is not a contract
1316      * @param spender address The address which will spend the funds
1317      * @param value uint256 The amount of tokens to be spent
1318      * @param data bytes Optional data to send along with the call
1319      * @return whether the call correctly returned the expected magic value
1320      */
1321     function _checkAndCallApprove(address spender, uint256 value, bytes memory data) internal returns (bool) {
1322         if (!spender.isContract()) {
1323             return false;
1324         }
1325         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(
1326             _msgSender(), value, data
1327         );
1328         return (retval == _ERC1363_APPROVED);
1329     }
1330 }
1331 
1332 // File: @openzeppelin/contracts/access/Ownable.sol
1333 
1334 
1335 
1336 pragma solidity ^0.7.0;
1337 
1338 /**
1339  * @dev Contract module which provides a basic access control mechanism, where
1340  * there is an account (an owner) that can be granted exclusive access to
1341  * specific functions.
1342  *
1343  * By default, the owner account will be the one that deploys the contract. This
1344  * can later be changed with {transferOwnership}.
1345  *
1346  * This module is used through inheritance. It will make available the modifier
1347  * `onlyOwner`, which can be applied to your functions to restrict their use to
1348  * the owner.
1349  */
1350 abstract contract Ownable is Context {
1351     address private _owner;
1352 
1353     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1354 
1355     /**
1356      * @dev Initializes the contract setting the deployer as the initial owner.
1357      */
1358     constructor () {
1359         address msgSender = _msgSender();
1360         _owner = msgSender;
1361         emit OwnershipTransferred(address(0), msgSender);
1362     }
1363 
1364     /**
1365      * @dev Returns the address of the current owner.
1366      */
1367     function owner() public view returns (address) {
1368         return _owner;
1369     }
1370 
1371     /**
1372      * @dev Throws if called by any account other than the owner.
1373      */
1374     modifier onlyOwner() {
1375         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1376         _;
1377     }
1378 
1379     /**
1380      * @dev Leaves the contract without owner. It will not be possible to call
1381      * `onlyOwner` functions anymore. Can only be called by the current owner.
1382      *
1383      * NOTE: Renouncing ownership will leave the contract without an owner,
1384      * thereby removing any functionality that is only available to the owner.
1385      */
1386     function renounceOwnership() public virtual onlyOwner {
1387         emit OwnershipTransferred(_owner, address(0));
1388         _owner = address(0);
1389     }
1390 
1391     /**
1392      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1393      * Can only be called by the current owner.
1394      */
1395     function transferOwnership(address newOwner) public virtual onlyOwner {
1396         require(newOwner != address(0), "Ownable: new owner is the zero address");
1397         emit OwnershipTransferred(_owner, newOwner);
1398         _owner = newOwner;
1399     }
1400 }
1401 
1402 // File: eth-token-recover/contracts/TokenRecover.sol
1403 
1404 
1405 
1406 pragma solidity ^0.7.0;
1407 
1408 
1409 
1410 /**
1411  * @title TokenRecover
1412  * @dev Allow to recover any ERC20 sent into the contract for error
1413  */
1414 contract TokenRecover is Ownable {
1415 
1416     /**
1417      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
1418      * @param tokenAddress The token contract address
1419      * @param tokenAmount Number of tokens to be sent
1420      */
1421     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
1422         IERC20(tokenAddress).transfer(owner(), tokenAmount);
1423     }
1424 }
1425 
1426 // File: contracts/service/ServiceReceiver.sol
1427 
1428 
1429 
1430 pragma solidity ^0.7.0;
1431 
1432 
1433 /**
1434  * @title ServiceReceiver
1435  * @dev Implementation of the ServiceReceiver
1436  */
1437 contract ServiceReceiver is TokenRecover {
1438 
1439     mapping (bytes32 => uint256) private _prices;
1440 
1441     event Created(string serviceName, address indexed serviceAddress);
1442 
1443     function pay(string memory serviceName) public payable {
1444         require(msg.value == _prices[_toBytes32(serviceName)], "ServiceReceiver: incorrect price");
1445 
1446         emit Created(serviceName, _msgSender());
1447     }
1448 
1449     function getPrice(string memory serviceName) public view returns (uint256) {
1450         return _prices[_toBytes32(serviceName)];
1451     }
1452 
1453     function setPrice(string memory serviceName, uint256 amount) public onlyOwner {
1454         _prices[_toBytes32(serviceName)] = amount;
1455     }
1456 
1457     function withdraw(uint256 amount) public onlyOwner {
1458         payable(owner()).transfer(amount);
1459     }
1460 
1461     function _toBytes32(string memory serviceName) private pure returns (bytes32) {
1462         return keccak256(abi.encode(serviceName));
1463     }
1464 }
1465 
1466 // File: contracts/service/ServicePayer.sol
1467 
1468 
1469 
1470 pragma solidity ^0.7.0;
1471 
1472 
1473 /**
1474  * @title ServicePayer
1475  * @dev Implementation of the ServicePayer
1476  */
1477 contract ServicePayer {
1478 
1479     constructor (address payable receiver, string memory serviceName) payable {
1480         ServiceReceiver(receiver).pay{value: msg.value}(serviceName);
1481     }
1482 }
1483 
1484 // File: contracts/token/ERC20/PowerfulERC20.sol
1485 
1486 
1487 
1488 pragma solidity ^0.7.0;
1489 
1490 
1491 
1492 
1493 
1494 
1495 /**
1496  * @title PowerfulERC20
1497  * @dev Implementation of the PowerfulERC20
1498  */
1499 contract PowerfulERC20 is ERC20Capped, ERC20Burnable, ERC1363, TokenRecover, ServicePayer {
1500 
1501     // indicates if minting is finished
1502     bool private _mintingFinished = false;
1503 
1504     /**
1505      * @dev Emitted during finish minting
1506      */
1507     event MintFinished();
1508 
1509     /**
1510      * @dev Tokens can be minted only before minting finished.
1511      */
1512     modifier canMint() {
1513         require(!_mintingFinished, "PowerfulERC20: minting is finished");
1514         _;
1515     }
1516 
1517     constructor (
1518         string memory name,
1519         string memory symbol,
1520         uint8 decimals,
1521         uint256 cap,
1522         uint256 initialBalance,
1523         address payable feeReceiver
1524     ) ERC1363(name, symbol) ERC20Capped(cap) ServicePayer(feeReceiver, "PowerfulERC20") payable {
1525         _setupDecimals(decimals);
1526 
1527         _mint(_msgSender(), initialBalance);
1528     }
1529 
1530     /**
1531      * @return if minting is finished or not.
1532      */
1533     function mintingFinished() public view returns (bool) {
1534         return _mintingFinished;
1535     }
1536 
1537     /**
1538      * @dev Function to mint tokens.
1539      * @param to The address that will receive the minted tokens
1540      * @param value The amount of tokens to mint
1541      */
1542     function mint(address to, uint256 value) public canMint onlyOwner {
1543         _mint(to, value);
1544     }
1545 
1546     /**
1547      * @dev Function to stop minting new tokens.
1548      */
1549     function finishMinting() public canMint onlyOwner {
1550         _mintingFinished = true;
1551 
1552         emit MintFinished();
1553     }
1554 
1555     /**
1556      * @dev See {ERC20-_beforeTokenTransfer}.
1557      */
1558     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Capped) {
1559         super._beforeTokenTransfer(from, to, amount);
1560     }
1561 }