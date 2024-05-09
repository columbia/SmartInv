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
32 
33 // pragma solidity ^0.6.0;
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP.
37  */
38 interface IERC20 {
39     /**
40      * @dev Returns the amount of tokens in existence.
41      */
42     function totalSupply() external view returns (uint256);
43 
44     /**
45      * @dev Returns the amount of tokens owned by `account`.
46      */
47     function balanceOf(address account) external view returns (uint256);
48 
49     /**
50      * @dev Moves `amount` tokens from the caller's account to `recipient`.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * Emits a {Transfer} event.
55      */
56     function transfer(address recipient, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Returns the remaining number of tokens that `spender` will be
60      * allowed to spend on behalf of `owner` through {transferFrom}. This is
61      * zero by default.
62      *
63      * This value changes when {approve} or {transferFrom} are called.
64      */
65     function allowance(address owner, address spender) external view returns (uint256);
66 
67     /**
68      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * // importANT: Beware that changing an allowance with this method brings the risk
73      * that someone may use both the old and the new allowance by unfortunate
74      * transaction ordering. One possible solution to mitigate this race
75      * condition is to first reduce the spender's allowance to 0 and set the
76      * desired value afterwards:
77      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
78      *
79      * Emits an {Approval} event.
80      */
81     function approve(address spender, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Moves `amount` tokens from `sender` to `recipient` using the
85      * allowance mechanism. `amount` is then deducted from the caller's
86      * allowance.
87      *
88      * Returns a boolean value indicating whether the operation succeeded.
89      *
90      * Emits a {Transfer} event.
91      */
92     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
93 
94     /**
95      * @dev Emitted when `value` tokens are moved from one account (`from`) to
96      * another (`to`).
97      *
98      * Note that `value` may be zero.
99      */
100     event Transfer(address indexed from, address indexed to, uint256 value);
101 
102     /**
103      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
104      * a call to {approve}. `value` is the new allowance.
105      */
106     event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 
110 // Dependency file: @openzeppelin/contracts/math/SafeMath.sol
111 
112 
113 
114 // pragma solidity ^0.6.0;
115 
116 /**
117  * @dev Wrappers over Solidity's arithmetic operations with added overflow
118  * checks.
119  *
120  * Arithmetic operations in Solidity wrap on overflow. This can easily result
121  * in bugs, because programmers usually assume that an overflow raises an
122  * error, which is the standard behavior in high level programming languages.
123  * `SafeMath` restores this intuition by reverting the transaction when an
124  * operation overflows.
125  *
126  * Using this library instead of the unchecked operations eliminates an entire
127  * class of bugs, so it's recommended to use it always.
128  */
129 library SafeMath {
130     /**
131      * @dev Returns the addition of two unsigned integers, reverting on
132      * overflow.
133      *
134      * Counterpart to Solidity's `+` operator.
135      *
136      * Requirements:
137      *
138      * - Addition cannot overflow.
139      */
140     function add(uint256 a, uint256 b) internal pure returns (uint256) {
141         uint256 c = a + b;
142         require(c >= a, "SafeMath: addition overflow");
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the subtraction of two unsigned integers, reverting on
149      * overflow (when the result is negative).
150      *
151      * Counterpart to Solidity's `-` operator.
152      *
153      * Requirements:
154      *
155      * - Subtraction cannot overflow.
156      */
157     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
158         return sub(a, b, "SafeMath: subtraction overflow");
159     }
160 
161     /**
162      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
163      * overflow (when the result is negative).
164      *
165      * Counterpart to Solidity's `-` operator.
166      *
167      * Requirements:
168      *
169      * - Subtraction cannot overflow.
170      */
171     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
172         require(b <= a, errorMessage);
173         uint256 c = a - b;
174 
175         return c;
176     }
177 
178     /**
179      * @dev Returns the multiplication of two unsigned integers, reverting on
180      * overflow.
181      *
182      * Counterpart to Solidity's `*` operator.
183      *
184      * Requirements:
185      *
186      * - Multiplication cannot overflow.
187      */
188     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
189         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
190         // benefit is lost if 'b' is also tested.
191         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
192         if (a == 0) {
193             return 0;
194         }
195 
196         uint256 c = a * b;
197         require(c / a == b, "SafeMath: multiplication overflow");
198 
199         return c;
200     }
201 
202     /**
203      * @dev Returns the integer division of two unsigned integers. Reverts on
204      * division by zero. The result is rounded towards zero.
205      *
206      * Counterpart to Solidity's `/` operator. Note: this function uses a
207      * `revert` opcode (which leaves remaining gas untouched) while Solidity
208      * uses an invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function div(uint256 a, uint256 b) internal pure returns (uint256) {
215         return div(a, b, "SafeMath: division by zero");
216     }
217 
218     /**
219      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
220      * division by zero. The result is rounded towards zero.
221      *
222      * Counterpart to Solidity's `/` operator. Note: this function uses a
223      * `revert` opcode (which leaves remaining gas untouched) while Solidity
224      * uses an invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
231         require(b > 0, errorMessage);
232         uint256 c = a / b;
233         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
234 
235         return c;
236     }
237 
238     /**
239      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
240      * Reverts when dividing by zero.
241      *
242      * Counterpart to Solidity's `%` operator. This function uses a `revert`
243      * opcode (which leaves remaining gas untouched) while Solidity uses an
244      * invalid opcode to revert (consuming all remaining gas).
245      *
246      * Requirements:
247      *
248      * - The divisor cannot be zero.
249      */
250     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
251         return mod(a, b, "SafeMath: modulo by zero");
252     }
253 
254     /**
255      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
256      * Reverts with custom message when dividing by zero.
257      *
258      * Counterpart to Solidity's `%` operator. This function uses a `revert`
259      * opcode (which leaves remaining gas untouched) while Solidity uses an
260      * invalid opcode to revert (consuming all remaining gas).
261      *
262      * Requirements:
263      *
264      * - The divisor cannot be zero.
265      */
266     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
267         require(b != 0, errorMessage);
268         return a % b;
269     }
270 }
271 
272 
273 // Dependency file: @openzeppelin/contracts/utils/Address.sol
274 
275 
276 
277 // pragma solidity ^0.6.2;
278 
279 /**
280  * @dev Collection of functions related to the address type
281  */
282 library Address {
283     /**
284      * @dev Returns true if `account` is a contract.
285      *
286      * [// importANT]
287      * ====
288      * It is unsafe to assume that an address for which this function returns
289      * false is an externally-owned account (EOA) and not a contract.
290      *
291      * Among others, `isContract` will return false for the following
292      * types of addresses:
293      *
294      *  - an externally-owned account
295      *  - a contract in construction
296      *  - an address where a contract will be created
297      *  - an address where a contract lived, but was destroyed
298      * ====
299      */
300     function isContract(address account) internal view returns (bool) {
301         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
302         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
303         // for accounts without code, i.e. `keccak256('')`
304         bytes32 codehash;
305         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
306         // solhint-disable-next-line no-inline-assembly
307         assembly { codehash := extcodehash(account) }
308         return (codehash != accountHash && codehash != 0x0);
309     }
310 
311     /**
312      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
313      * `recipient`, forwarding all available gas and reverting on errors.
314      *
315      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
316      * of certain opcodes, possibly making contracts go over the 2300 gas limit
317      * imposed by `transfer`, making them unable to receive funds via
318      * `transfer`. {sendValue} removes this limitation.
319      *
320      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
321      *
322      * // importANT: because control is transferred to `recipient`, care must be
323      * taken to not create reentrancy vulnerabilities. Consider using
324      * {ReentrancyGuard} or the
325      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
326      */
327     function sendValue(address payable recipient, uint256 amount) internal {
328         require(address(this).balance >= amount, "Address: insufficient balance");
329 
330         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
331         (bool success, ) = recipient.call{ value: amount }("");
332         require(success, "Address: unable to send value, recipient may have reverted");
333     }
334 
335     /**
336      * @dev Performs a Solidity function call using a low level `call`. A
337      * plain`call` is an unsafe replacement for a function call: use this
338      * function instead.
339      *
340      * If `target` reverts with a revert reason, it is bubbled up by this
341      * function (like regular Solidity function calls).
342      *
343      * Returns the raw returned data. To convert to the expected return value,
344      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
345      *
346      * Requirements:
347      *
348      * - `target` must be a contract.
349      * - calling `target` with `data` must not revert.
350      *
351      * _Available since v3.1._
352      */
353     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
354       return functionCall(target, data, "Address: low-level call failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
359      * `errorMessage` as a fallback revert reason when `target` reverts.
360      *
361      * _Available since v3.1._
362      */
363     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
364         return _functionCallWithValue(target, data, 0, errorMessage);
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
369      * but also transferring `value` wei to `target`.
370      *
371      * Requirements:
372      *
373      * - the calling contract must have an ETH balance of at least `value`.
374      * - the called Solidity function must be `payable`.
375      *
376      * _Available since v3.1._
377      */
378     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
379         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
384      * with `errorMessage` as a fallback revert reason when `target` reverts.
385      *
386      * _Available since v3.1._
387      */
388     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
389         require(address(this).balance >= value, "Address: insufficient balance for call");
390         return _functionCallWithValue(target, data, value, errorMessage);
391     }
392 
393     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
394         require(isContract(target), "Address: call to non-contract");
395 
396         // solhint-disable-next-line avoid-low-level-calls
397         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
398         if (success) {
399             return returndata;
400         } else {
401             // Look for revert reason and bubble it up if present
402             if (returndata.length > 0) {
403                 // The easiest way to bubble the revert reason is using memory via assembly
404 
405                 // solhint-disable-next-line no-inline-assembly
406                 assembly {
407                     let returndata_size := mload(returndata)
408                     revert(add(32, returndata), returndata_size)
409                 }
410             } else {
411                 revert(errorMessage);
412             }
413         }
414     }
415 }
416 
417 
418 // Dependency file: @openzeppelin/contracts/token/ERC20/ERC20.sol
419 
420 
421 
422 // pragma solidity ^0.6.0;
423 
424 // import "@openzeppelin/contracts/GSN/Context.sol";
425 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
426 // import "@openzeppelin/contracts/math/SafeMath.sol";
427 // import "@openzeppelin/contracts/utils/Address.sol";
428 
429 /**
430  * @dev Implementation of the {IERC20} interface.
431  *
432  * This implementation is agnostic to the way tokens are created. This means
433  * that a supply mechanism has to be added in a derived contract using {_mint}.
434  * For a generic mechanism see {ERC20PresetMinterPauser}.
435  *
436  * TIP: For a detailed writeup see our guide
437  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
438  * to implement supply mechanisms].
439  *
440  * We have followed general OpenZeppelin guidelines: functions revert instead
441  * of returning `false` on failure. This behavior is nonetheless conventional
442  * and does not conflict with the expectations of ERC20 applications.
443  *
444  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
445  * This allows applications to reconstruct the allowance for all accounts just
446  * by listening to said events. Other implementations of the EIP may not emit
447  * these events, as it isn't required by the specification.
448  *
449  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
450  * functions have been added to mitigate the well-known issues around setting
451  * allowances. See {IERC20-approve}.
452  */
453 contract ERC20 is Context, IERC20 {
454     using SafeMath for uint256;
455     using Address for address;
456 
457     mapping (address => uint256) private _balances;
458 
459     mapping (address => mapping (address => uint256)) private _allowances;
460 
461     uint256 private _totalSupply;
462 
463     string private _name;
464     string private _symbol;
465     uint8 private _decimals;
466 
467     /**
468      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
469      * a default value of 18.
470      *
471      * To select a different value for {decimals}, use {_setupDecimals}.
472      *
473      * All three of these values are immutable: they can only be set once during
474      * construction.
475      */
476     constructor (string memory name, string memory symbol) public {
477         _name = name;
478         _symbol = symbol;
479         _decimals = 18;
480     }
481 
482     /**
483      * @dev Returns the name of the token.
484      */
485     function name() public view returns (string memory) {
486         return _name;
487     }
488 
489     /**
490      * @dev Returns the symbol of the token, usually a shorter version of the
491      * name.
492      */
493     function symbol() public view returns (string memory) {
494         return _symbol;
495     }
496 
497     /**
498      * @dev Returns the number of decimals used to get its user representation.
499      * For example, if `decimals` equals `2`, a balance of `505` tokens should
500      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
501      *
502      * Tokens usually opt for a value of 18, imitating the relationship between
503      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
504      * called.
505      *
506      * NOTE: This information is only used for _display_ purposes: it in
507      * no way affects any of the arithmetic of the contract, including
508      * {IERC20-balanceOf} and {IERC20-transfer}.
509      */
510     function decimals() public view returns (uint8) {
511         return _decimals;
512     }
513 
514     /**
515      * @dev See {IERC20-totalSupply}.
516      */
517     function totalSupply() public view override returns (uint256) {
518         return _totalSupply;
519     }
520 
521     /**
522      * @dev See {IERC20-balanceOf}.
523      */
524     function balanceOf(address account) public view override returns (uint256) {
525         return _balances[account];
526     }
527 
528     /**
529      * @dev See {IERC20-transfer}.
530      *
531      * Requirements:
532      *
533      * - `recipient` cannot be the zero address.
534      * - the caller must have a balance of at least `amount`.
535      */
536     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
537         _transfer(_msgSender(), recipient, amount);
538         return true;
539     }
540 
541     /**
542      * @dev See {IERC20-allowance}.
543      */
544     function allowance(address owner, address spender) public view virtual override returns (uint256) {
545         return _allowances[owner][spender];
546     }
547 
548     /**
549      * @dev See {IERC20-approve}.
550      *
551      * Requirements:
552      *
553      * - `spender` cannot be the zero address.
554      */
555     function approve(address spender, uint256 amount) public virtual override returns (bool) {
556         _approve(_msgSender(), spender, amount);
557         return true;
558     }
559 
560     /**
561      * @dev See {IERC20-transferFrom}.
562      *
563      * Emits an {Approval} event indicating the updated allowance. This is not
564      * required by the EIP. See the note at the beginning of {ERC20};
565      *
566      * Requirements:
567      * - `sender` and `recipient` cannot be the zero address.
568      * - `sender` must have a balance of at least `amount`.
569      * - the caller must have allowance for ``sender``'s tokens of at least
570      * `amount`.
571      */
572     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
573         _transfer(sender, recipient, amount);
574         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
575         return true;
576     }
577 
578     /**
579      * @dev Atomically increases the allowance granted to `spender` by the caller.
580      *
581      * This is an alternative to {approve} that can be used as a mitigation for
582      * problems described in {IERC20-approve}.
583      *
584      * Emits an {Approval} event indicating the updated allowance.
585      *
586      * Requirements:
587      *
588      * - `spender` cannot be the zero address.
589      */
590     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
591         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
592         return true;
593     }
594 
595     /**
596      * @dev Atomically decreases the allowance granted to `spender` by the caller.
597      *
598      * This is an alternative to {approve} that can be used as a mitigation for
599      * problems described in {IERC20-approve}.
600      *
601      * Emits an {Approval} event indicating the updated allowance.
602      *
603      * Requirements:
604      *
605      * - `spender` cannot be the zero address.
606      * - `spender` must have allowance for the caller of at least
607      * `subtractedValue`.
608      */
609     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
610         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
611         return true;
612     }
613 
614     /**
615      * @dev Moves tokens `amount` from `sender` to `recipient`.
616      *
617      * This is internal function is equivalent to {transfer}, and can be used to
618      * e.g. implement automatic token fees, slashing mechanisms, etc.
619      *
620      * Emits a {Transfer} event.
621      *
622      * Requirements:
623      *
624      * - `sender` cannot be the zero address.
625      * - `recipient` cannot be the zero address.
626      * - `sender` must have a balance of at least `amount`.
627      */
628     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
629         require(sender != address(0), "ERC20: transfer from the zero address");
630         require(recipient != address(0), "ERC20: transfer to the zero address");
631 
632         _beforeTokenTransfer(sender, recipient, amount);
633 
634         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
635         _balances[recipient] = _balances[recipient].add(amount);
636         emit Transfer(sender, recipient, amount);
637     }
638 
639     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
640      * the total supply.
641      *
642      * Emits a {Transfer} event with `from` set to the zero address.
643      *
644      * Requirements
645      *
646      * - `to` cannot be the zero address.
647      */
648     function _mint(address account, uint256 amount) internal virtual {
649         require(account != address(0), "ERC20: mint to the zero address");
650 
651         _beforeTokenTransfer(address(0), account, amount);
652 
653         _totalSupply = _totalSupply.add(amount);
654         _balances[account] = _balances[account].add(amount);
655         emit Transfer(address(0), account, amount);
656     }
657 
658     /**
659      * @dev Destroys `amount` tokens from `account`, reducing the
660      * total supply.
661      *
662      * Emits a {Transfer} event with `to` set to the zero address.
663      *
664      * Requirements
665      *
666      * - `account` cannot be the zero address.
667      * - `account` must have at least `amount` tokens.
668      */
669     function _burn(address account, uint256 amount) internal virtual {
670         require(account != address(0), "ERC20: burn from the zero address");
671 
672         _beforeTokenTransfer(account, address(0), amount);
673 
674         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
675         _totalSupply = _totalSupply.sub(amount);
676         emit Transfer(account, address(0), amount);
677     }
678 
679     /**
680      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
681      *
682      * This is internal function is equivalent to `approve`, and can be used to
683      * e.g. set automatic allowances for certain subsystems, etc.
684      *
685      * Emits an {Approval} event.
686      *
687      * Requirements:
688      *
689      * - `owner` cannot be the zero address.
690      * - `spender` cannot be the zero address.
691      */
692     function _approve(address owner, address spender, uint256 amount) internal virtual {
693         require(owner != address(0), "ERC20: approve from the zero address");
694         require(spender != address(0), "ERC20: approve to the zero address");
695 
696         _allowances[owner][spender] = amount;
697         emit Approval(owner, spender, amount);
698     }
699 
700     /**
701      * @dev Sets {decimals} to a value other than the default one of 18.
702      *
703      * WARNING: This function should only be called from the constructor. Most
704      * applications that interact with token contracts will not expect
705      * {decimals} to ever change, and may work incorrectly if it does.
706      */
707     function _setupDecimals(uint8 decimals_) internal {
708         _decimals = decimals_;
709     }
710 
711     /**
712      * @dev Hook that is called before any transfer of tokens. This includes
713      * minting and burning.
714      *
715      * Calling conditions:
716      *
717      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
718      * will be to transferred to `to`.
719      * - when `from` is zero, `amount` tokens will be minted for `to`.
720      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
721      * - `from` and `to` are never both zero.
722      *
723      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
724      */
725     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
726 }
727 
728 
729 // Root file: contracts/BaskBond.sol
730 
731 pragma solidity =0.6.11;
732 
733 
734 contract BaskBOND is ERC20 {
735     constructor () ERC20("BASK Bond", "BASKBond") public {
736         _mint(msg.sender, 70253694259365537760000);
737     }
738 }