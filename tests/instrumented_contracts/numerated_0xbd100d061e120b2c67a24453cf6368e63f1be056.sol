1 // SPDX-License-Identifier: BSD-3-Clause
2 // File: @openzeppelin/contracts/GSN/Context.sol
3 
4 
5 
6 pragma solidity ^0.6.0;
7 
8 /*
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with GSN meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
30 
31 
32 
33 pragma solidity ^0.6.0;
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
72      * IMPORTANT: Beware that changing an allowance with this method brings the risk
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
109 // File: @openzeppelin/contracts/math/SafeMath.sol
110 
111 
112 
113 pragma solidity ^0.6.0;
114 
115 /**
116  * @dev Wrappers over Solidity's arithmetic operations with added overflow
117  * checks.
118  *
119  * Arithmetic operations in Solidity wrap on overflow. This can easily result
120  * in bugs, because programmers usually assume that an overflow raises an
121  * error, which is the standard behavior in high level programming languages.
122  * `SafeMath` restores this intuition by reverting the transaction when an
123  * operation overflows.
124  *
125  * Using this library instead of the unchecked operations eliminates an entire
126  * class of bugs, so it's recommended to use it always.
127  */
128 library SafeMath {
129     /**
130      * @dev Returns the addition of two unsigned integers, reverting on
131      * overflow.
132      *
133      * Counterpart to Solidity's `+` operator.
134      *
135      * Requirements:
136      *
137      * - Addition cannot overflow.
138      */
139     function add(uint256 a, uint256 b) internal pure returns (uint256) {
140         uint256 c = a + b;
141         require(c >= a, "SafeMath: addition overflow");
142 
143         return c;
144     }
145 
146     /**
147      * @dev Returns the subtraction of two unsigned integers, reverting on
148      * overflow (when the result is negative).
149      *
150      * Counterpart to Solidity's `-` operator.
151      *
152      * Requirements:
153      *
154      * - Subtraction cannot overflow.
155      */
156     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
157         return sub(a, b, "SafeMath: subtraction overflow");
158     }
159 
160     /**
161      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
162      * overflow (when the result is negative).
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
171         require(b <= a, errorMessage);
172         uint256 c = a - b;
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the multiplication of two unsigned integers, reverting on
179      * overflow.
180      *
181      * Counterpart to Solidity's `*` operator.
182      *
183      * Requirements:
184      *
185      * - Multiplication cannot overflow.
186      */
187     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
188         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
189         // benefit is lost if 'b' is also tested.
190         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
191         if (a == 0) {
192             return 0;
193         }
194 
195         uint256 c = a * b;
196         require(c / a == b, "SafeMath: multiplication overflow");
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the integer division of two unsigned integers. Reverts on
203      * division by zero. The result is rounded towards zero.
204      *
205      * Counterpart to Solidity's `/` operator. Note: this function uses a
206      * `revert` opcode (which leaves remaining gas untouched) while Solidity
207      * uses an invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function div(uint256 a, uint256 b) internal pure returns (uint256) {
214         return div(a, b, "SafeMath: division by zero");
215     }
216 
217     /**
218      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
219      * division by zero. The result is rounded towards zero.
220      *
221      * Counterpart to Solidity's `/` operator. Note: this function uses a
222      * `revert` opcode (which leaves remaining gas untouched) while Solidity
223      * uses an invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         require(b > 0, errorMessage);
231         uint256 c = a / b;
232         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
233 
234         return c;
235     }
236 
237     /**
238      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
239      * Reverts when dividing by zero.
240      *
241      * Counterpart to Solidity's `%` operator. This function uses a `revert`
242      * opcode (which leaves remaining gas untouched) while Solidity uses an
243      * invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      *
247      * - The divisor cannot be zero.
248      */
249     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
250         return mod(a, b, "SafeMath: modulo by zero");
251     }
252 
253     /**
254      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
255      * Reverts with custom message when dividing by zero.
256      *
257      * Counterpart to Solidity's `%` operator. This function uses a `revert`
258      * opcode (which leaves remaining gas untouched) while Solidity uses an
259      * invalid opcode to revert (consuming all remaining gas).
260      *
261      * Requirements:
262      *
263      * - The divisor cannot be zero.
264      */
265     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
266         require(b != 0, errorMessage);
267         return a % b;
268     }
269 }
270 
271 // File: @openzeppelin/contracts/utils/Address.sol
272 
273 
274 
275 pragma solidity ^0.6.2;
276 
277 /**
278  * @dev Collection of functions related to the address type
279  */
280 library Address {
281     /**
282      * @dev Returns true if `account` is a contract.
283      *
284      * [IMPORTANT]
285      * ====
286      * It is unsafe to assume that an address for which this function returns
287      * false is an externally-owned account (EOA) and not a contract.
288      *
289      * Among others, `isContract` will return false for the following
290      * types of addresses:
291      *
292      *  - an externally-owned account
293      *  - a contract in construction
294      *  - an address where a contract will be created
295      *  - an address where a contract lived, but was destroyed
296      * ====
297      */
298     function isContract(address account) internal view returns (bool) {
299         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
300         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
301         // for accounts without code, i.e. `keccak256('')`
302         bytes32 codehash;
303         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
304         // solhint-disable-next-line no-inline-assembly
305         assembly { codehash := extcodehash(account) }
306         return (codehash != accountHash && codehash != 0x0);
307     }
308 
309     /**
310      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
311      * `recipient`, forwarding all available gas and reverting on errors.
312      *
313      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
314      * of certain opcodes, possibly making contracts go over the 2300 gas limit
315      * imposed by `transfer`, making them unable to receive funds via
316      * `transfer`. {sendValue} removes this limitation.
317      *
318      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
319      *
320      * IMPORTANT: because control is transferred to `recipient`, care must be
321      * taken to not create reentrancy vulnerabilities. Consider using
322      * {ReentrancyGuard} or the
323      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
324      */
325     function sendValue(address payable recipient, uint256 amount) internal {
326         require(address(this).balance >= amount, "Address: insufficient balance");
327 
328         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
329         (bool success, ) = recipient.call{ value: amount }("");
330         require(success, "Address: unable to send value, recipient may have reverted");
331     }
332 
333     /**
334      * @dev Performs a Solidity function call using a low level `call`. A
335      * plain`call` is an unsafe replacement for a function call: use this
336      * function instead.
337      *
338      * If `target` reverts with a revert reason, it is bubbled up by this
339      * function (like regular Solidity function calls).
340      *
341      * Returns the raw returned data. To convert to the expected return value,
342      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
343      *
344      * Requirements:
345      *
346      * - `target` must be a contract.
347      * - calling `target` with `data` must not revert.
348      *
349      * _Available since v3.1._
350      */
351     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
352       return functionCall(target, data, "Address: low-level call failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
357      * `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
362         return _functionCallWithValue(target, data, 0, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but also transferring `value` wei to `target`.
368      *
369      * Requirements:
370      *
371      * - the calling contract must have an ETH balance of at least `value`.
372      * - the called Solidity function must be `payable`.
373      *
374      * _Available since v3.1._
375      */
376     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
377         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
382      * with `errorMessage` as a fallback revert reason when `target` reverts.
383      *
384      * _Available since v3.1._
385      */
386     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
387         require(address(this).balance >= value, "Address: insufficient balance for call");
388         return _functionCallWithValue(target, data, value, errorMessage);
389     }
390 
391     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
392         require(isContract(target), "Address: call to non-contract");
393 
394         // solhint-disable-next-line avoid-low-level-calls
395         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
396         if (success) {
397             return returndata;
398         } else {
399             // Look for revert reason and bubble it up if present
400             if (returndata.length > 0) {
401                 // The easiest way to bubble the revert reason is using memory via assembly
402 
403                 // solhint-disable-next-line no-inline-assembly
404                 assembly {
405                     let returndata_size := mload(returndata)
406                     revert(add(32, returndata), returndata_size)
407                 }
408             } else {
409                 revert(errorMessage);
410             }
411         }
412     }
413 }
414 
415 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
416 
417 
418 
419 pragma solidity ^0.6.0;
420 
421 
422 
423 
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
676      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
677      *
678      * This is internal function is equivalent to `approve`, and can be used to
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
724 // File: @openzeppelin/contracts/access/Ownable.sol
725 
726 
727 
728 pragma solidity ^0.6.0;
729 
730 /**
731  * @dev Contract module which provides a basic access control mechanism, where
732  * there is an account (an owner) that can be granted exclusive access to
733  * specific functions.
734  *
735  * By default, the owner account will be the one that deploys the contract. This
736  * can later be changed with {transferOwnership}.
737  *
738  * This module is used through inheritance. It will make available the modifier
739  * `onlyOwner`, which can be applied to your functions to restrict their use to
740  * the owner.
741  */
742 contract Ownable is Context {
743     address private _owner;
744 
745     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
746 
747     /**
748      * @dev Initializes the contract setting the deployer as the initial owner.
749      */
750     constructor () internal {
751         address msgSender = _msgSender();
752         _owner = msgSender;
753         emit OwnershipTransferred(address(0), msgSender);
754     }
755 
756     /**
757      * @dev Returns the address of the current owner.
758      */
759     function owner() public view returns (address) {
760         return _owner;
761     }
762 
763     /**
764      * @dev Throws if called by any account other than the owner.
765      */
766     modifier onlyOwner() {
767         require(_owner == _msgSender(), "Ownable: caller is not the owner");
768         _;
769     }
770 
771     /**
772      * @dev Leaves the contract without owner. It will not be possible to call
773      * `onlyOwner` functions anymore. Can only be called by the current owner.
774      *
775      * NOTE: Renouncing ownership will leave the contract without an owner,
776      * thereby removing any functionality that is only available to the owner.
777      */
778     function renounceOwnership() public virtual onlyOwner {
779         emit OwnershipTransferred(_owner, address(0));
780         _owner = address(0);
781     }
782 
783     /**
784      * @dev Transfers ownership of the contract to a new account (`newOwner`).
785      * Can only be called by the current owner.
786      */
787     function transferOwnership(address newOwner) public virtual onlyOwner {
788         require(newOwner != address(0), "Ownable: new owner is the zero address");
789         emit OwnershipTransferred(_owner, newOwner);
790         _owner = newOwner;
791     }
792 }
793 
794 // File: contracts/iDeFiYieldProtocol.sol
795 
796 pragma solidity 0.6.12;
797 
798 
799 // iDeFiYieldProtocol with Governance.
800 contract iDeFiYieldProtocol is ERC20("iDeFiYieldProtocol", "iDYP"), Ownable {
801     /// @notice Creates total supply of 300.000.000 iDYP
802     constructor() public {
803         _mint(msg.sender, 300000000000000000000000000);
804     }
805 
806     /// @dev A record of each accounts delegate
807     mapping (address => address) internal _delegates;
808 
809     /// @notice A checkpoint for marking number of votes from a given block
810     struct Checkpoint {
811         uint32 fromBlock;
812         uint256 votes;
813     }
814 
815     /// @notice A record of votes checkpoints for each account, by index
816     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
817 
818     /// @notice The number of checkpoints for each account
819     mapping (address => uint32) public numCheckpoints;
820 
821     /// @notice The EIP-712 typehash for the contract's domain
822     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
823 
824     /// @notice The EIP-712 typehash for the delegation struct used by the contract
825     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
826 
827     /// @notice A record of states for signing / validating signatures
828     mapping (address => uint) public nonces;
829 
830       /// @notice An event thats emitted when an account changes its delegate
831     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
832 
833     /// @notice An event thats emitted when a delegate account's vote balance changes
834     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
835 
836     /**
837      * @notice Delegate votes from `msg.sender` to `delegatee`
838      * @param delegator The address to get delegatee for
839      */
840     function delegates(address delegator)
841         external
842         view
843         returns (address)
844     {
845         return _delegates[delegator];
846     }
847 
848    /**
849     * @notice Delegate votes from `msg.sender` to `delegatee`
850     * @param delegatee The address to delegate votes to
851     */
852     function delegate(address delegatee) external {
853         return _delegate(msg.sender, delegatee);
854     }
855 
856     /**
857      * @notice Delegates votes from signatory to `delegatee`
858      * @param delegatee The address to delegate votes to
859      * @param nonce The contract state required to match the signature
860      * @param expiry The time at which to expire the signature
861      * @param v The recovery byte of the signature
862      * @param r Half of the ECDSA signature pair
863      * @param s Half of the ECDSA signature pair
864      */
865     function delegateBySig(
866         address delegatee,
867         uint nonce,
868         uint expiry,
869         uint8 v,
870         bytes32 r,
871         bytes32 s
872     )
873         external
874     {
875         bytes32 domainSeparator = keccak256(
876             abi.encode(
877                 DOMAIN_TYPEHASH,
878                 keccak256(bytes(name())),
879                 getChainId(),
880                 address(this)
881             )
882         );
883 
884         bytes32 structHash = keccak256(
885             abi.encode(
886                 DELEGATION_TYPEHASH,
887                 delegatee,
888                 nonce,
889                 expiry
890             )
891         );
892 
893         bytes32 digest = keccak256(
894             abi.encodePacked(
895                 "\x19\x01",
896                 domainSeparator,
897                 structHash
898             )
899         );
900 
901         address signatory = ecrecover(digest, v, r, s);
902         require(signatory != address(0), "iDYP::delegateBySig: invalid signature");
903         require(nonce == nonces[signatory]++, "iDYP::delegateBySig: invalid nonce");
904         require(now <= expiry, "iDYP::delegateBySig: signature expired");
905         return _delegate(signatory, delegatee);
906     }
907 
908     /**
909      * @notice Gets the current votes balance for `account`
910      * @param account The address to get votes balance
911      * @return The number of current votes for `account`
912      */
913     function getCurrentVotes(address account)
914         external
915         view
916         returns (uint256)
917     {
918         uint32 nCheckpoints = numCheckpoints[account];
919         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
920     }
921 
922     /**
923      * @notice Determine the prior number of votes for an account as of a block number
924      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
925      * @param account The address of the account to check
926      * @param blockNumber The block number to get the vote balance at
927      * @return The number of votes the account had as of the given block
928      */
929     function getPriorVotes(address account, uint blockNumber)
930         external
931         view
932         returns (uint256)
933     {
934         require(blockNumber < block.number, "iDYP::getPriorVotes: not yet determined");
935 
936         uint32 nCheckpoints = numCheckpoints[account];
937         if (nCheckpoints == 0) {
938             return 0;
939         }
940 
941         // First check most recent balance
942         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
943             return checkpoints[account][nCheckpoints - 1].votes;
944         }
945 
946         // Next check implicit zero balance
947         if (checkpoints[account][0].fromBlock > blockNumber) {
948             return 0;
949         }
950 
951         uint32 lower = 0;
952         uint32 upper = nCheckpoints - 1;
953         while (upper > lower) {
954             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
955             Checkpoint memory cp = checkpoints[account][center];
956             if (cp.fromBlock == blockNumber) {
957                 return cp.votes;
958             } else if (cp.fromBlock < blockNumber) {
959                 lower = center;
960             } else {
961                 upper = center - 1;
962             }
963         }
964         return checkpoints[account][lower].votes;
965     }
966 
967     function _delegate(address delegator, address delegatee)
968         internal
969     {
970         address currentDelegate = _delegates[delegator];
971         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying iDYPs (not scaled);
972         _delegates[delegator] = delegatee;
973 
974         emit DelegateChanged(delegator, currentDelegate, delegatee);
975 
976         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
977     }
978 
979     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
980         if (srcRep != dstRep && amount > 0) {
981             if (srcRep != address(0)) {
982                 // decrease old representative
983                 uint32 srcRepNum = numCheckpoints[srcRep];
984                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
985                 uint256 srcRepNew = srcRepOld.sub(amount);
986                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
987             }
988 
989             if (dstRep != address(0)) {
990                 // increase new representative
991                 uint32 dstRepNum = numCheckpoints[dstRep];
992                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
993                 uint256 dstRepNew = dstRepOld.add(amount);
994                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
995             }
996         }
997     }
998 
999     function _writeCheckpoint(
1000         address delegatee,
1001         uint32 nCheckpoints,
1002         uint256 oldVotes,
1003         uint256 newVotes
1004     )
1005         internal
1006     {
1007         uint32 blockNumber = safe32(block.number, "iDYP::_writeCheckpoint: block number exceeds 32 bits");
1008 
1009         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1010             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1011         } else {
1012             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1013             numCheckpoints[delegatee] = nCheckpoints + 1;
1014         }
1015 
1016         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1017     }
1018 
1019     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1020         require(n < 2**32, errorMessage);
1021         return uint32(n);
1022     }
1023 
1024     function getChainId() internal pure returns (uint) {
1025         uint256 chainId;
1026         assembly { chainId := chainid() }
1027         return chainId;
1028     }
1029 }