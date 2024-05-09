1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2020-09-05
5 */
6 
7 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
8 
9 pragma solidity ^0.6.0;
10 
11 /**
12  * @dev Interface of the ERC20 standard as defined in the EIP.
13  */
14 interface IERC20 {
15     /**
16      * @dev Returns the amount of tokens in existence.
17      */
18     function totalSupply() external view returns (uint256);
19 
20     /**
21      * @dev Returns the amount of tokens owned by `account`.
22      */
23     function balanceOf(address account) external view returns (uint256);
24 
25     /**
26      * @dev Moves `amount` tokens from the caller's account to `recipient`.
27      *
28      * Returns a boolean value indicating whether the operation succeeded.
29      *
30      * Emits a {Transfer} event.
31      */
32     function transfer(address recipient, uint256 amount) external returns (bool);
33 
34     /**
35      * @dev Returns the remaining number of tokens that `spender` will be
36      * allowed to spend on behalf of `owner` through {transferFrom}. This is
37      * zero by default.
38      *
39      * This value changes when {approve} or {transferFrom} are called.
40      */
41     function allowance(address owner, address spender) external view returns (uint256);
42 
43     /**
44      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * IMPORTANT: Beware that changing an allowance with this method brings the risk
49      * that someone may use both the old and the new allowance by unfortunate
50      * transaction ordering. One possible solution to mitigate this race
51      * condition is to first reduce the spender's allowance to 0 and set the
52      * desired value afterwards:
53      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
54      *
55      * Emits an {Approval} event.
56      */
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Moves `amount` tokens from `sender` to `recipient` using the
61      * allowance mechanism. `amount` is then deducted from the caller's
62      * allowance.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a {Transfer} event.
67      */
68     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Emitted when `value` tokens are moved from one account (`from`) to
72      * another (`to`).
73      *
74      * Note that `value` may be zero.
75      */
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     /**
79      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
80      * a call to {approve}. `value` is the new allowance.
81      */
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 // File: @openzeppelin/contracts/GSN/Context.sol
86 
87 
88 
89 pragma solidity ^0.6.0;
90 
91 /*
92  * @dev Provides information about the current execution context, including the
93  * sender of the transaction and its data. While these are generally available
94  * via msg.sender and msg.data, they should not be accessed in such a direct
95  * manner, since when dealing with GSN meta-transactions the account sending and
96  * paying for execution may not be the actual sender (as far as an application
97  * is concerned).
98  *
99  * This contract is only required for intermediate, library-like contracts.
100  */
101 abstract contract Context {
102     function _msgSender() internal view virtual returns (address payable) {
103         return msg.sender;
104     }
105 
106     function _msgData() internal view virtual returns (bytes memory) {
107         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
108         return msg.data;
109     }
110 }
111 
112 // File: @openzeppelin/contracts/math/SafeMath.sol
113 
114 
115 
116 pragma solidity ^0.6.0;
117 
118 /**
119  * @dev Wrappers over Solidity's arithmetic operations with added overflow
120  * checks.
121  *
122  * Arithmetic operations in Solidity wrap on overflow. This can easily result
123  * in bugs, because programmers usually assume that an overflow raises an
124  * error, which is the standard behavior in high level programming languages.
125  * `SafeMath` restores this intuition by reverting the transaction when an
126  * operation overflows.
127  *
128  * Using this library instead of the unchecked operations eliminates an entire
129  * class of bugs, so it's recommended to use it always.
130  */
131 library SafeMath {
132     /**
133      * @dev Returns the addition of two unsigned integers, reverting on
134      * overflow.
135      *
136      * Counterpart to Solidity's `+` operator.
137      *
138      * Requirements:
139      *
140      * - Addition cannot overflow.
141      */
142     function add(uint256 a, uint256 b) internal pure returns (uint256) {
143         uint256 c = a + b;
144         require(c >= a, "SafeMath: addition overflow");
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      *
157      * - Subtraction cannot overflow.
158      */
159     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
160         return sub(a, b, "SafeMath: subtraction overflow");
161     }
162 
163     /**
164      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
165      * overflow (when the result is negative).
166      *
167      * Counterpart to Solidity's `-` operator.
168      *
169      * Requirements:
170      *
171      * - Subtraction cannot overflow.
172      */
173     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
174         require(b <= a, errorMessage);
175         uint256 c = a - b;
176 
177         return c;
178     }
179 
180     /**
181      * @dev Returns the multiplication of two unsigned integers, reverting on
182      * overflow.
183      *
184      * Counterpart to Solidity's `*` operator.
185      *
186      * Requirements:
187      *
188      * - Multiplication cannot overflow.
189      */
190     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
191         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
192         // benefit is lost if 'b' is also tested.
193         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
194         if (a == 0) {
195             return 0;
196         }
197 
198         uint256 c = a * b;
199         require(c / a == b, "SafeMath: multiplication overflow");
200 
201         return c;
202     }
203 
204     /**
205      * @dev Returns the integer division of two unsigned integers. Reverts on
206      * division by zero. The result is rounded towards zero.
207      *
208      * Counterpart to Solidity's `/` operator. Note: this function uses a
209      * `revert` opcode (which leaves remaining gas untouched) while Solidity
210      * uses an invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function div(uint256 a, uint256 b) internal pure returns (uint256) {
217         return div(a, b, "SafeMath: division by zero");
218     }
219 
220     /**
221      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
222      * division by zero. The result is rounded towards zero.
223      *
224      * Counterpart to Solidity's `/` operator. Note: this function uses a
225      * `revert` opcode (which leaves remaining gas untouched) while Solidity
226      * uses an invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      *
230      * - The divisor cannot be zero.
231      */
232     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
233         require(b > 0, errorMessage);
234         uint256 c = a / b;
235         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
236 
237         return c;
238     }
239 
240     /**
241      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
242      * Reverts when dividing by zero.
243      *
244      * Counterpart to Solidity's `%` operator. This function uses a `revert`
245      * opcode (which leaves remaining gas untouched) while Solidity uses an
246      * invalid opcode to revert (consuming all remaining gas).
247      *
248      * Requirements:
249      *
250      * - The divisor cannot be zero.
251      */
252     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
253         return mod(a, b, "SafeMath: modulo by zero");
254     }
255 
256     /**
257      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
258      * Reverts with custom message when dividing by zero.
259      *
260      * Counterpart to Solidity's `%` operator. This function uses a `revert`
261      * opcode (which leaves remaining gas untouched) while Solidity uses an
262      * invalid opcode to revert (consuming all remaining gas).
263      *
264      * Requirements:
265      *
266      * - The divisor cannot be zero.
267      */
268     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
269         require(b != 0, errorMessage);
270         return a % b;
271     }
272 }
273 
274 // File: @openzeppelin/contracts/utils/Address.sol
275 
276 
277 
278 pragma solidity ^0.6.2;
279 
280 /**
281  * @dev Collection of functions related to the address type
282  */
283 library Address {
284     /**
285      * @dev Returns true if `account` is a contract.
286      *
287      * [IMPORTANT]
288      * ====
289      * It is unsafe to assume that an address for which this function returns
290      * false is an externally-owned account (EOA) and not a contract.
291      *
292      * Among others, `isContract` will return false for the following
293      * types of addresses:
294      *
295      *  - an externally-owned account
296      *  - a contract in construction
297      *  - an address where a contract will be created
298      *  - an address where a contract lived, but was destroyed
299      * ====
300      */
301     function isContract(address account) internal view returns (bool) {
302         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
303         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
304         // for accounts without code, i.e. `keccak256('')`
305         bytes32 codehash;
306         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
307         // solhint-disable-next-line no-inline-assembly
308         assembly { codehash := extcodehash(account) }
309         return (codehash != accountHash && codehash != 0x0);
310     }
311 
312     /**
313      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
314      * `recipient`, forwarding all available gas and reverting on errors.
315      *
316      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
317      * of certain opcodes, possibly making contracts go over the 2300 gas limit
318      * imposed by `transfer`, making them unable to receive funds via
319      * `transfer`. {sendValue} removes this limitation.
320      *
321      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
322      *
323      * IMPORTANT: because control is transferred to `recipient`, care must be
324      * taken to not create reentrancy vulnerabilities. Consider using
325      * {ReentrancyGuard} or the
326      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
327      */
328     function sendValue(address payable recipient, uint256 amount) internal {
329         require(address(this).balance >= amount, "Address: insufficient balance");
330 
331         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
332         (bool success, ) = recipient.call{ value: amount }("");
333         require(success, "Address: unable to send value, recipient may have reverted");
334     }
335 
336     /**
337      * @dev Performs a Solidity function call using a low level `call`. A
338      * plain`call` is an unsafe replacement for a function call: use this
339      * function instead.
340      *
341      * If `target` reverts with a revert reason, it is bubbled up by this
342      * function (like regular Solidity function calls).
343      *
344      * Returns the raw returned data. To convert to the expected return value,
345      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
346      *
347      * Requirements:
348      *
349      * - `target` must be a contract.
350      * - calling `target` with `data` must not revert.
351      *
352      * _Available since v3.1._
353      */
354     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
355       return functionCall(target, data, "Address: low-level call failed");
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
360      * `errorMessage` as a fallback revert reason when `target` reverts.
361      *
362      * _Available since v3.1._
363      */
364     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
365         return _functionCallWithValue(target, data, 0, errorMessage);
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
370      * but also transferring `value` wei to `target`.
371      *
372      * Requirements:
373      *
374      * - the calling contract must have an ETH balance of at least `value`.
375      * - the called Solidity function must be `payable`.
376      *
377      * _Available since v3.1._
378      */
379     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
380         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
385      * with `errorMessage` as a fallback revert reason when `target` reverts.
386      *
387      * _Available since v3.1._
388      */
389     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
390         require(address(this).balance >= value, "Address: insufficient balance for call");
391         return _functionCallWithValue(target, data, value, errorMessage);
392     }
393 
394     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
395         require(isContract(target), "Address: call to non-contract");
396 
397         // solhint-disable-next-line avoid-low-level-calls
398         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
399         if (success) {
400             return returndata;
401         } else {
402             // Look for revert reason and bubble it up if present
403             if (returndata.length > 0) {
404                 // The easiest way to bubble the revert reason is using memory via assembly
405 
406                 // solhint-disable-next-line no-inline-assembly
407                 assembly {
408                     let returndata_size := mload(returndata)
409                     revert(add(32, returndata), returndata_size)
410                 }
411             } else {
412                 revert(errorMessage);
413             }
414         }
415     }
416 }
417 
418 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
419 
420 
421 
422 pragma solidity ^0.6.0;
423 
424 
425 
426 
427 
428 /**
429  * @dev Implementation of the {IERC20} interface.
430  *
431  * This implementation is agnostic to the way tokens are created. This means
432  * that a supply mechanism has to be added in a derived contract using {_mint}.
433  * For a generic mechanism see {ERC20PresetMinterPauser}.
434  *
435  * TIP: For a detailed writeup see our guide
436  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
437  * to implement supply mechanisms].
438  *
439  * We have followed general OpenZeppelin guidelines: functions revert instead
440  * of returning `false` on failure. This behavior is nonetheless conventional
441  * and does not conflict with the expectations of ERC20 applications.
442  *
443  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
444  * This allows applications to reconstruct the allowance for all accounts just
445  * by listening to said events. Other implementations of the EIP may not emit
446  * these events, as it isn't required by the specification.
447  *
448  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
449  * functions have been added to mitigate the well-known issues around setting
450  * allowances. See {IERC20-approve}.
451  */
452 contract ERC20 is Context, IERC20 {
453     using SafeMath for uint256;
454     using Address for address;
455 
456     mapping (address => uint256) private _balances;
457 
458     mapping (address => mapping (address => uint256)) private _allowances;
459 
460     uint256 private _totalSupply;
461 
462     string private _name;
463     string private _symbol;
464     uint8 private _decimals;
465 
466     /**
467      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
468      * a default value of 18.
469      *
470      * To select a different value for {decimals}, use {_setupDecimals}.
471      *
472      * All three of these values are immutable: they can only be set once during
473      * construction.
474      */
475     constructor (string memory name, string memory symbol) public {
476         _name = name;
477         _symbol = symbol;
478         _decimals = 18;
479     }
480 
481     /**
482      * @dev Returns the name of the token.
483      */
484     function name() public view returns (string memory) {
485         return _name;
486     }
487 
488     /**
489      * @dev Returns the symbol of the token, usually a shorter version of the
490      * name.
491      */
492     function symbol() public view returns (string memory) {
493         return _symbol;
494     }
495 
496     /**
497      * @dev Returns the number of decimals used to get its user representation.
498      * For example, if `decimals` equals `2`, a balance of `505` tokens should
499      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
500      *
501      * Tokens usually opt for a value of 18, imitating the relationship between
502      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
503      * called.
504      *
505      * NOTE: This information is only used for _display_ purposes: it in
506      * no way affects any of the arithmetic of the contract, including
507      * {IERC20-balanceOf} and {IERC20-transfer}.
508      */
509     function decimals() public view returns (uint8) {
510         return _decimals;
511     }
512 
513     /**
514      * @dev See {IERC20-totalSupply}.
515      */
516     function totalSupply() public view override returns (uint256) {
517         return _totalSupply;
518     }
519 
520     /**
521      * @dev See {IERC20-balanceOf}.
522      */
523     function balanceOf(address account) public view override returns (uint256) {
524         return _balances[account];
525     }
526 
527     /**
528      * @dev See {IERC20-transfer}.
529      *
530      * Requirements:
531      *
532      * - `recipient` cannot be the zero address.
533      * - the caller must have a balance of at least `amount`.
534      */
535     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
536         _transfer(_msgSender(), recipient, amount);
537         return true;
538     }
539 
540     /**
541      * @dev See {IERC20-allowance}.
542      */
543     function allowance(address owner, address spender) public view virtual override returns (uint256) {
544         return _allowances[owner][spender];
545     }
546 
547     /**
548      * @dev See {IERC20-approve}.
549      *
550      * Requirements:
551      *
552      * - `spender` cannot be the zero address.
553      */
554     function approve(address spender, uint256 amount) public virtual override returns (bool) {
555         _approve(_msgSender(), spender, amount);
556         return true;
557     }
558 
559     /**
560      * @dev See {IERC20-transferFrom}.
561      *
562      * Emits an {Approval} event indicating the updated allowance. This is not
563      * required by the EIP. See the note at the beginning of {ERC20};
564      *
565      * Requirements:
566      * - `sender` and `recipient` cannot be the zero address.
567      * - `sender` must have a balance of at least `amount`.
568      * - the caller must have allowance for ``sender``'s tokens of at least
569      * `amount`.
570      */
571     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
572         _transfer(sender, recipient, amount);
573         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
574         return true;
575     }
576 
577     /**
578      * @dev Atomically increases the allowance granted to `spender` by the caller.
579      *
580      * This is an alternative to {approve} that can be used as a mitigation for
581      * problems described in {IERC20-approve}.
582      *
583      * Emits an {Approval} event indicating the updated allowance.
584      *
585      * Requirements:
586      *
587      * - `spender` cannot be the zero address.
588      */
589     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
590         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
591         return true;
592     }
593 
594     /**
595      * @dev Atomically decreases the allowance granted to `spender` by the caller.
596      *
597      * This is an alternative to {approve} that can be used as a mitigation for
598      * problems described in {IERC20-approve}.
599      *
600      * Emits an {Approval} event indicating the updated allowance.
601      *
602      * Requirements:
603      *
604      * - `spender` cannot be the zero address.
605      * - `spender` must have allowance for the caller of at least
606      * `subtractedValue`.
607      */
608     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
609         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
610         return true;
611     }
612 
613     /**
614      * @dev Moves tokens `amount` from `sender` to `recipient`.
615      *
616      * This is internal function is equivalent to {transfer}, and can be used to
617      * e.g. implement automatic token fees, slashing mechanisms, etc.
618      *
619      * Emits a {Transfer} event.
620      *
621      * Requirements:
622      *
623      * - `sender` cannot be the zero address.
624      * - `recipient` cannot be the zero address.
625      * - `sender` must have a balance of at least `amount`.
626      */
627     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
628         require(sender != address(0), "ERC20: transfer from the zero address");
629         require(recipient != address(0), "ERC20: transfer to the zero address");
630 
631         _beforeTokenTransfer(sender, recipient, amount);
632 
633         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
634         _balances[recipient] = _balances[recipient].add(amount);
635         emit Transfer(sender, recipient, amount);
636     }
637 
638     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
639      * the total supply.
640      *
641      * Emits a {Transfer} event with `from` set to the zero address.
642      *
643      * Requirements
644      *
645      * - `to` cannot be the zero address.
646      */
647     function _mint(address account, uint256 amount) internal virtual {
648         require(account != address(0), "ERC20: mint to the zero address");
649 
650         _beforeTokenTransfer(address(0), account, amount);
651 
652         _totalSupply = _totalSupply.add(amount);
653         _balances[account] = _balances[account].add(amount);
654         emit Transfer(address(0), account, amount);
655     }
656 
657     /**
658      * @dev Destroys `amount` tokens from `account`, reducing the
659      * total supply.
660      *
661      * Emits a {Transfer} event with `to` set to the zero address.
662      *
663      * Requirements
664      *
665      * - `account` cannot be the zero address.
666      * - `account` must have at least `amount` tokens.
667      */
668     function _burn(address account, uint256 amount) internal virtual {
669         require(account != address(0), "ERC20: burn from the zero address");
670 
671         _beforeTokenTransfer(account, address(0), amount);
672 
673         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
674         _totalSupply = _totalSupply.sub(amount);
675         emit Transfer(account, address(0), amount);
676     }
677 
678     /**
679      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
680      *
681      * This is internal function is equivalent to `approve`, and can be used to
682      * e.g. set automatic allowances for certain subsystems, etc.
683      *
684      * Emits an {Approval} event.
685      *
686      * Requirements:
687      *
688      * - `owner` cannot be the zero address.
689      * - `spender` cannot be the zero address.
690      */
691     function _approve(address owner, address spender, uint256 amount) internal virtual {
692         require(owner != address(0), "ERC20: approve from the zero address");
693         require(spender != address(0), "ERC20: approve to the zero address");
694 
695         _allowances[owner][spender] = amount;
696         emit Approval(owner, spender, amount);
697     }
698 
699     /**
700      * @dev Sets {decimals} to a value other than the default one of 18.
701      *
702      * WARNING: This function should only be called from the constructor. Most
703      * applications that interact with token contracts will not expect
704      * {decimals} to ever change, and may work incorrectly if it does.
705      */
706     function _setupDecimals(uint8 decimals_) internal {
707         _decimals = decimals_;
708     }
709 
710     /**
711      * @dev Hook that is called before any transfer of tokens. This includes
712      * minting and burning.
713      *
714      * Calling conditions:
715      *
716      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
717      * will be to transferred to `to`.
718      * - when `from` is zero, `amount` tokens will be minted for `to`.
719      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
720      * - `from` and `to` are never both zero.
721      *
722      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
723      */
724     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
725 }
726 
727 // Forked from: contracts/SushiBar.sol
728 
729 pragma solidity 0.6.8;
730 contract XXMON is ERC20("XXMON", "xXMON"){
731 
732     using SafeMath for uint256;
733     IERC20 public xmon;
734 
735     constructor(IERC20 _xmon) public {
736         xmon = _xmon;
737     }
738 
739     // Wrap XMON to xXMON
740     function enter(uint256 _amount) public {
741         uint256 totalSushi = xmon.balanceOf(address(this));
742         uint256 totalShares = totalSupply();
743         if (totalShares == 0 || totalSushi == 0) {
744             _mint(msg.sender, _amount);
745         } else {
746             uint256 what = _amount.mul(totalShares).div(totalSushi);
747             _mint(msg.sender, what);
748         }
749         xmon.transferFrom(msg.sender, address(this), _amount);
750     }
751 
752     // Unwrap XMON to xXMON
753     function leave(uint256 _share) public {
754         uint256 totalShares = totalSupply();
755         uint256 what = _share.mul(xmon.balanceOf(address(this))).div(totalShares);
756         _burn(msg.sender, _share);
757         xmon.transfer(msg.sender, what);
758     }
759 
760     // Calculates amount received if leaves
761     function exchangeRate(uint256 amount) public view returns(uint256) {
762       uint256 totalShares = totalSupply();
763       uint256 what = amount.mul(xmon.balanceOf(address(this))).div(totalShares);
764       return what;
765     }
766 }