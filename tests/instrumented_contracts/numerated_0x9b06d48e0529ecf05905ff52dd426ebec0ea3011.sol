1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-19
3 */
4 
5 // File: @openzeppelin/contracts/GSN/Context.sol
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity ^0.6.0;
10 
11 /*
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with GSN meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address payable) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes memory) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
33 
34 
35 pragma solidity ^0.6.0;
36 
37 /**
38  * @dev Interface of the ERC20 standard as defined in the EIP.
39  */
40 interface IERC20 {
41     /**
42      * @dev Returns the amount of tokens in existence.
43      */
44     function totalSupply() external view returns (uint256);
45 
46     /**
47      * @dev Returns the amount of tokens owned by `account`.
48      */
49     function balanceOf(address account) external view returns (uint256);
50 
51     /**
52      * @dev Moves `amount` tokens from the caller's account to `recipient`.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * Emits a {Transfer} event.
57      */
58     function transfer(address recipient, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Returns the remaining number of tokens that `spender` will be
62      * allowed to spend on behalf of `owner` through {transferFrom}. This is
63      * zero by default.
64      *
65      * This value changes when {approve} or {transferFrom} are called.
66      */
67     function allowance(address owner, address spender) external view returns (uint256);
68 
69     /**
70      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * IMPORTANT: Beware that changing an allowance with this method brings the risk
75      * that someone may use both the old and the new allowance by unfortunate
76      * transaction ordering. One possible solution to mitigate this race
77      * condition is to first reduce the spender's allowance to 0 and set the
78      * desired value afterwards:
79      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
80      *
81      * Emits an {Approval} event.
82      */
83     function approve(address spender, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Moves `amount` tokens from `sender` to `recipient` using the
87      * allowance mechanism. `amount` is then deducted from the caller's
88      * allowance.
89      *
90      * Returns a boolean value indicating whether the operation succeeded.
91      *
92      * Emits a {Transfer} event.
93      */
94     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
95 
96     /**
97      * @dev Emitted when `value` tokens are moved from one account (`from`) to
98      * another (`to`).
99      *
100      * Note that `value` may be zero.
101      */
102     event Transfer(address indexed from, address indexed to, uint256 value);
103 
104     /**
105      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
106      * a call to {approve}. `value` is the new allowance.
107      */
108     event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 // File: @openzeppelin/contracts/math/SafeMath.sol
112 
113 
114 
115 pragma solidity ^0.6.0;
116 
117 /**
118  * @dev Wrappers over Solidity's arithmetic operations with added overflow
119  * checks.
120  *
121  * Arithmetic operations in Solidity wrap on overflow. This can easily result
122  * in bugs, because programmers usually assume that an overflow raises an
123  * error, which is the standard behavior in high level programming languages.
124  * `SafeMath` restores this intuition by reverting the transaction when an
125  * operation overflows.
126  *
127  * Using this library instead of the unchecked operations eliminates an entire
128  * class of bugs, so it's recommended to use it always.
129  */
130 library SafeMath {
131     /**
132      * @dev Returns the addition of two unsigned integers, reverting on
133      * overflow.
134      *
135      * Counterpart to Solidity's `+` operator.
136      *
137      * Requirements:
138      *
139      * - Addition cannot overflow.
140      */
141     function add(uint256 a, uint256 b) internal pure returns (uint256) {
142         uint256 c = a + b;
143         require(c >= a, "SafeMath: addition overflow");
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the subtraction of two unsigned integers, reverting on
150      * overflow (when the result is negative).
151      *
152      * Counterpart to Solidity's `-` operator.
153      *
154      * Requirements:
155      *
156      * - Subtraction cannot overflow.
157      */
158     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
159         return sub(a, b, "SafeMath: subtraction overflow");
160     }
161 
162     /**
163      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
164      * overflow (when the result is negative).
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
173         require(b <= a, errorMessage);
174         uint256 c = a - b;
175 
176         return c;
177     }
178 
179     /**
180      * @dev Returns the multiplication of two unsigned integers, reverting on
181      * overflow.
182      *
183      * Counterpart to Solidity's `*` operator.
184      *
185      * Requirements:
186      *
187      * - Multiplication cannot overflow.
188      */
189     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
190         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
191         // benefit is lost if 'b' is also tested.
192         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
193         if (a == 0) {
194             return 0;
195         }
196 
197         uint256 c = a * b;
198         require(c / a == b, "SafeMath: multiplication overflow");
199 
200         return c;
201     }
202 
203     /**
204      * @dev Returns the integer division of two unsigned integers. Reverts on
205      * division by zero. The result is rounded towards zero.
206      *
207      * Counterpart to Solidity's `/` operator. Note: this function uses a
208      * `revert` opcode (which leaves remaining gas untouched) while Solidity
209      * uses an invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      *
213      * - The divisor cannot be zero.
214      */
215     function div(uint256 a, uint256 b) internal pure returns (uint256) {
216         return div(a, b, "SafeMath: division by zero");
217     }
218 
219     /**
220      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
221      * division by zero. The result is rounded towards zero.
222      *
223      * Counterpart to Solidity's `/` operator. Note: this function uses a
224      * `revert` opcode (which leaves remaining gas untouched) while Solidity
225      * uses an invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
232         require(b > 0, errorMessage);
233         uint256 c = a / b;
234         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
235 
236         return c;
237     }
238 
239     /**
240      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
241      * Reverts when dividing by zero.
242      *
243      * Counterpart to Solidity's `%` operator. This function uses a `revert`
244      * opcode (which leaves remaining gas untouched) while Solidity uses an
245      * invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      *
249      * - The divisor cannot be zero.
250      */
251     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
252         return mod(a, b, "SafeMath: modulo by zero");
253     }
254 
255     /**
256      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
257      * Reverts with custom message when dividing by zero.
258      *
259      * Counterpart to Solidity's `%` operator. This function uses a `revert`
260      * opcode (which leaves remaining gas untouched) while Solidity uses an
261      * invalid opcode to revert (consuming all remaining gas).
262      *
263      * Requirements:
264      *
265      * - The divisor cannot be zero.
266      */
267     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
268         require(b != 0, errorMessage);
269         return a % b;
270     }
271 }
272 
273 // File: @openzeppelin/contracts/utils/Address.sol
274 
275 
276 
277 pragma solidity ^0.6.2;
278 
279 /**
280  * @dev Collection of functions related to the address type
281  */
282 library Address {
283     /**
284      * @dev Returns true if `account` is a contract.
285      *
286      * [IMPORTANT]
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
322      * IMPORTANT: because control is transferred to `recipient`, care must be
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
417 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
418 
419 
420 
421 pragma solidity ^0.6.0;
422 
423 
424 
425 
426 
427 /**
428  * @dev Implementation of the {IERC20} interface.
429  *
430  * This implementation is agnostic to the way tokens are created. This means
431  * that a supply mechanism has to be added in a derived contract using {_mint}.
432  * For a generic mechanism see {ERC20PresetMinterPauser}.
433  *
434  * TIP: For a detailed writeup see our guide
435  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
436  * to implement supply mechanisms].
437  *
438  * We have followed general OpenZeppelin guidelines: functions revert instead
439  * of returning `false` on failure. This behavior is nonetheless conventional
440  * and does not conflict with the expectations of ERC20 applications.
441  *
442  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
443  * This allows applications to reconstruct the allowance for all accounts just
444  * by listening to said events. Other implementations of the EIP may not emit
445  * these events, as it isn't required by the specification.
446  *
447  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
448  * functions have been added to mitigate the well-known issues around setting
449  * allowances. See {IERC20-approve}.
450  */
451 contract ERC20 is Context, IERC20 {
452     using SafeMath for uint256;
453     using Address for address;
454 
455     mapping (address => uint256) private _balances;
456 
457     mapping (address => mapping (address => uint256)) private _allowances;
458 
459     uint256 private _totalSupply;
460 
461     string private _name;
462     string private _symbol;
463     uint8 private _decimals;
464 
465     /**
466      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
467      * a default value of 18.
468      *
469      * To select a different value for {decimals}, use {_setupDecimals}.
470      *
471      * All three of these values are immutable: they can only be set once during
472      * construction.
473      */
474     constructor (string memory name, string memory symbol) public {
475         _name = name;
476         _symbol = symbol;
477         _decimals = 18;
478     }
479 
480     /**
481      * @dev Returns the name of the token.
482      */
483     function name() public view returns (string memory) {
484         return _name;
485     }
486 
487     /**
488      * @dev Returns the symbol of the token, usually a shorter version of the
489      * name.
490      */
491     function symbol() public view returns (string memory) {
492         return _symbol;
493     }
494 
495     /**
496      * @dev Returns the number of decimals used to get its user representation.
497      * For example, if `decimals` equals `2`, a balance of `505` tokens should
498      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
499      *
500      * Tokens usually opt for a value of 18, imitating the relationship between
501      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
502      * called.
503      *
504      * NOTE: This information is only used for _display_ purposes: it in
505      * no way affects any of the arithmetic of the contract, including
506      * {IERC20-balanceOf} and {IERC20-transfer}.
507      */
508     function decimals() public view returns (uint8) {
509         return _decimals;
510     }
511 
512     /**
513      * @dev See {IERC20-totalSupply}.
514      */
515     function totalSupply() public view override returns (uint256) {
516         return _totalSupply;
517     }
518 
519     /**
520      * @dev See {IERC20-balanceOf}.
521      */
522     function balanceOf(address account) public view override returns (uint256) {
523         return _balances[account];
524     }
525 
526     /**
527      * @dev See {IERC20-transfer}.
528      *
529      * Requirements:
530      *
531      * - `recipient` cannot be the zero address.
532      * - the caller must have a balance of at least `amount`.
533      */
534     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
535         _transfer(_msgSender(), recipient, amount);
536         return true;
537     }
538 
539     /**
540      * @dev See {IERC20-allowance}.
541      */
542     function allowance(address owner, address spender) public view virtual override returns (uint256) {
543         return _allowances[owner][spender];
544     }
545 
546     /**
547      * @dev See {IERC20-approve}.
548      *
549      * Requirements:
550      *
551      * - `spender` cannot be the zero address.
552      */
553     function approve(address spender, uint256 amount) public virtual override returns (bool) {
554         _approve(_msgSender(), spender, amount);
555         return true;
556     }
557 
558     /**
559      * @dev See {IERC20-transferFrom}.
560      *
561      * Emits an {Approval} event indicating the updated allowance. This is not
562      * required by the EIP. See the note at the beginning of {ERC20};
563      *
564      * Requirements:
565      * - `sender` and `recipient` cannot be the zero address.
566      * - `sender` must have a balance of at least `amount`.
567      * - the caller must have allowance for ``sender``'s tokens of at least
568      * `amount`.
569      */
570     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
571         _transfer(sender, recipient, amount);
572         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
573         return true;
574     }
575 
576     /**
577      * @dev Atomically increases the allowance granted to `spender` by the caller.
578      *
579      * This is an alternative to {approve} that can be used as a mitigation for
580      * problems described in {IERC20-approve}.
581      *
582      * Emits an {Approval} event indicating the updated allowance.
583      *
584      * Requirements:
585      *
586      * - `spender` cannot be the zero address.
587      */
588     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
589         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
590         return true;
591     }
592 
593     /**
594      * @dev Atomically decreases the allowance granted to `spender` by the caller.
595      *
596      * This is an alternative to {approve} that can be used as a mitigation for
597      * problems described in {IERC20-approve}.
598      *
599      * Emits an {Approval} event indicating the updated allowance.
600      *
601      * Requirements:
602      *
603      * - `spender` cannot be the zero address.
604      * - `spender` must have allowance for the caller of at least
605      * `subtractedValue`.
606      */
607     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
608         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
609         return true;
610     }
611 
612     /**
613      * @dev Moves tokens `amount` from `sender` to `recipient`.
614      *
615      * This is internal function is equivalent to {transfer}, and can be used to
616      * e.g. implement automatic token fees, slashing mechanisms, etc.
617      *
618      * Emits a {Transfer} event.
619      *
620      * Requirements:
621      *
622      * - `sender` cannot be the zero address.
623      * - `recipient` cannot be the zero address.
624      * - `sender` must have a balance of at least `amount`.
625      */
626     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
627         require(sender != address(0), "ERC20: transfer from the zero address");
628         require(recipient != address(0), "ERC20: transfer to the zero address");
629 
630         _beforeTokenTransfer(sender, recipient, amount);
631 
632         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
633         _balances[recipient] = _balances[recipient].add(amount);
634         emit Transfer(sender, recipient, amount);
635     }
636 
637     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
638      * the total supply.
639      *
640      * Emits a {Transfer} event with `from` set to the zero address.
641      *
642      * Requirements
643      *
644      * - `to` cannot be the zero address.
645      */
646     function _mint(address account, uint256 amount) internal virtual {
647         require(account != address(0), "ERC20: mint to the zero address");
648 
649         _beforeTokenTransfer(address(0), account, amount);
650 
651         _totalSupply = _totalSupply.add(amount);
652         _balances[account] = _balances[account].add(amount);
653         emit Transfer(address(0), account, amount);
654     }
655 
656     /**
657      * @dev Destroys `amount` tokens from `account`, reducing the
658      * total supply.
659      *
660      * Emits a {Transfer} event with `to` set to the zero address.
661      *
662      * Requirements
663      *
664      * - `account` cannot be the zero address.
665      * - `account` must have at least `amount` tokens.
666      */
667     function _burn(address account, uint256 amount) internal virtual {
668         require(account != address(0), "ERC20: burn from the zero address");
669 
670         _beforeTokenTransfer(account, address(0), amount);
671 
672         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
673         _totalSupply = _totalSupply.sub(amount);
674         emit Transfer(account, address(0), amount);
675     }
676 
677     /**
678      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
679      *
680      * This is internal function is equivalent to `approve`, and can be used to
681      * e.g. set automatic allowances for certain subsystems, etc.
682      *
683      * Emits an {Approval} event.
684      *
685      * Requirements:
686      *
687      * - `owner` cannot be the zero address.
688      * - `spender` cannot be the zero address.
689      */
690     function _approve(address owner, address spender, uint256 amount) internal virtual {
691         require(owner != address(0), "ERC20: approve from the zero address");
692         require(spender != address(0), "ERC20: approve to the zero address");
693 
694         _allowances[owner][spender] = amount;
695         emit Approval(owner, spender, amount);
696     }
697 
698     /**
699      * @dev Sets {decimals} to a value other than the default one of 18.
700      *
701      * WARNING: This function should only be called from the constructor. Most
702      * applications that interact with token contracts will not expect
703      * {decimals} to ever change, and may work incorrectly if it does.
704      */
705     function _setupDecimals(uint8 decimals_) internal {
706         _decimals = decimals_;
707     }
708 
709     /**
710      * @dev Hook that is called before any transfer of tokens. This includes
711      * minting and burning.
712      *
713      * Calling conditions:
714      *
715      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
716      * will be to transferred to `to`.
717      * - when `from` is zero, `amount` tokens will be minted for `to`.
718      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
719      * - `from` and `to` are never both zero.
720      *
721      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
722      */
723     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
724 }
725 
726 // File: @openzeppelin/contracts/access/Ownable.sol
727 
728 
729 
730 pragma solidity ^0.6.0;
731 
732 /**
733  * @dev Contract module which provides a basic access control mechanism, where
734  * there is an account (an owner) that can be granted exclusive access to
735  * specific functions.
736  *
737  * By default, the owner account will be the one that deploys the contract. This
738  * can later be changed with {transferOwnership}.
739  *
740  * This module is used through inheritance. It will make available the modifier
741  * `onlyOwner`, which can be applied to your functions to restrict their use to
742  * the owner.
743  */
744 contract Ownable is Context {
745     address private _owner;
746 
747     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
748 
749     /**
750      * @dev Initializes the contract setting the deployer as the initial owner.
751      */
752     constructor () internal {
753         address msgSender = _msgSender();
754         _owner = msgSender;
755         emit OwnershipTransferred(address(0), msgSender);
756     }
757 
758     /**
759      * @dev Returns the address of the current owner.
760      */
761     function owner() public view returns (address) {
762         return _owner;
763     }
764 
765     /**
766      * @dev Throws if called by any account other than the owner.
767      */
768     modifier onlyOwner() {
769         require(_owner == _msgSender(), "Ownable: caller is not the owner");
770         _;
771     }
772 
773     /**
774      * @dev Leaves the contract without owner. It will not be possible to call
775      * `onlyOwner` functions anymore. Can only be called by the current owner.
776      *
777      * NOTE: Renouncing ownership will leave the contract without an owner,
778      * thereby removing any functionality that is only available to the owner.
779      */
780     function renounceOwnership() public virtual onlyOwner {
781         emit OwnershipTransferred(_owner, address(0));
782         _owner = address(0);
783     }
784 
785     /**
786      * @dev Transfers ownership of the contract to a new account (`newOwner`).
787      * Can only be called by the current owner.
788      */
789     function transferOwnership(address newOwner) public virtual onlyOwner {
790         require(newOwner != address(0), "Ownable: new owner is the zero address");
791         emit OwnershipTransferred(_owner, newOwner);
792         _owner = newOwner;
793     }
794 }
795 
796 // File: contracts/XSwap.sol
797 
798 pragma solidity 0.6.12;
799 
800 
801 
802 
803 // XSwap with Governance.
804 contract XSwap is ERC20("XSwap", "XSP"), Ownable {
805     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
806     function mint(address _to, uint256 _amount) public onlyOwner {
807         _mint(_to, _amount);
808         _moveDelegates(address(0), _delegates[_to], _amount);
809     }
810 
811     // Copied and modified from YAM code:
812     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
813     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
814     // Which is copied and modified from COMPOUND:
815     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
816 
817     /// @notice A record of each accounts delegate
818     mapping (address => address) internal _delegates;
819 
820     /// @notice A checkpoint for marking number of votes from a given block
821     struct Checkpoint {
822         uint32 fromBlock;
823         uint256 votes;
824     }
825 
826     /// @notice A record of votes checkpoints for each account, by index
827     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
828 
829     /// @notice The number of checkpoints for each account
830     mapping (address => uint32) public numCheckpoints;
831 
832     /// @notice The EIP-712 typehash for the contract's domain
833     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
834 
835     /// @notice The EIP-712 typehash for the delegation struct used by the contract
836     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
837 
838     /// @notice A record of states for signing / validating signatures
839     mapping (address => uint) public nonces;
840 
841       /// @notice An event thats emitted when an account changes its delegate
842     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
843 
844     /// @notice An event thats emitted when a delegate account's vote balance changes
845     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
846 
847     /**
848      * @notice Delegate votes from `msg.sender` to `delegatee`
849      * @param delegator The address to get delegatee for
850      */
851     function delegates(address delegator)
852         external
853         view
854         returns (address)
855     {
856         return _delegates[delegator];
857     }
858 
859    /**
860     * @notice Delegate votes from `msg.sender` to `delegatee`
861     * @param delegatee The address to delegate votes to
862     */
863     function delegate(address delegatee) external {
864         return _delegate(msg.sender, delegatee);
865     }
866 
867     /**
868      * @notice Delegates votes from signatory to `delegatee`
869      * @param delegatee The address to delegate votes to
870      * @param nonce The contract state required to match the signature
871      * @param expiry The time at which to expire the signature
872      * @param v The recovery byte of the signature
873      * @param r Half of the ECDSA signature pair
874      * @param s Half of the ECDSA signature pair
875      */
876     function delegateBySig(
877         address delegatee,
878         uint nonce,
879         uint expiry,
880         uint8 v,
881         bytes32 r,
882         bytes32 s
883     )
884         external
885     {
886         bytes32 domainSeparator = keccak256(
887             abi.encode(
888                 DOMAIN_TYPEHASH,
889                 keccak256(bytes(name())),
890                 getChainId(),
891                 address(this)
892             )
893         );
894 
895         bytes32 structHash = keccak256(
896             abi.encode(
897                 DELEGATION_TYPEHASH,
898                 delegatee,
899                 nonce,
900                 expiry
901             )
902         );
903 
904         bytes32 digest = keccak256(
905             abi.encodePacked(
906                 "\x19\x01",
907                 domainSeparator,
908                 structHash
909             )
910         );
911 
912         address signatory = ecrecover(digest, v, r, s);
913         require(signatory != address(0), "XSwap::delegateBySig: invalid signature");
914         require(nonce == nonces[signatory]++, "XSwap::delegateBySig: invalid nonce");
915         require(now <= expiry, "XSwap::delegateBySig: signature expired");
916         return _delegate(signatory, delegatee);
917     }
918 
919     /**
920      * @notice Gets the current votes balance for `account`
921      * @param account The address to get votes balance
922      * @return The number of current votes for `account`
923      */
924     function getCurrentVotes(address account)
925         external
926         view
927         returns (uint256)
928     {
929         uint32 nCheckpoints = numCheckpoints[account];
930         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
931     }
932 
933     /**
934      * @notice Determine the prior number of votes for an account as of a block number
935      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
936      * @param account The address of the account to check
937      * @param blockNumber The block number to get the vote balance at
938      * @return The number of votes the account had as of the given block
939      */
940     function getPriorVotes(address account, uint blockNumber)
941         external
942         view
943         returns (uint256)
944     {
945         require(blockNumber < block.number, "XSwap::getPriorVotes: not yet determined");
946 
947         uint32 nCheckpoints = numCheckpoints[account];
948         if (nCheckpoints == 0) {
949             return 0;
950         }
951 
952         // First check most recent balance
953         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
954             return checkpoints[account][nCheckpoints - 1].votes;
955         }
956 
957         // Next check implicit zero balance
958         if (checkpoints[account][0].fromBlock > blockNumber) {
959             return 0;
960         }
961 
962         uint32 lower = 0;
963         uint32 upper = nCheckpoints - 1;
964         while (upper > lower) {
965             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
966             Checkpoint memory cp = checkpoints[account][center];
967             if (cp.fromBlock == blockNumber) {
968                 return cp.votes;
969             } else if (cp.fromBlock < blockNumber) {
970                 lower = center;
971             } else {
972                 upper = center - 1;
973             }
974         }
975         return checkpoints[account][lower].votes;
976     }
977 
978     function _delegate(address delegator, address delegatee)
979         internal
980     {
981         address currentDelegate = _delegates[delegator];
982         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying XSwaps (not scaled);
983         _delegates[delegator] = delegatee;
984 
985         emit DelegateChanged(delegator, currentDelegate, delegatee);
986 
987         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
988     }
989 
990     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
991         if (srcRep != dstRep && amount > 0) {
992             if (srcRep != address(0)) {
993                 // decrease old representative
994                 uint32 srcRepNum = numCheckpoints[srcRep];
995                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
996                 uint256 srcRepNew = srcRepOld.sub(amount);
997                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
998             }
999 
1000             if (dstRep != address(0)) {
1001                 // increase new representative
1002                 uint32 dstRepNum = numCheckpoints[dstRep];
1003                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1004                 uint256 dstRepNew = dstRepOld.add(amount);
1005                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1006             }
1007         }
1008     }
1009 
1010     function _writeCheckpoint(
1011         address delegatee,
1012         uint32 nCheckpoints,
1013         uint256 oldVotes,
1014         uint256 newVotes
1015     )
1016         internal
1017     {
1018         uint32 blockNumber = safe32(block.number, "XSwap::_writeCheckpoint: block number exceeds 32 bits");
1019 
1020         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1021             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1022         } else {
1023             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1024             numCheckpoints[delegatee] = nCheckpoints + 1;
1025         }
1026 
1027         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1028     }
1029 
1030     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1031         require(n < 2**32, errorMessage);
1032         return uint32(n);
1033     }
1034 
1035     function getChainId() internal pure returns (uint) {
1036         uint256 chainId;
1037         assembly { chainId := chainid() }
1038         return chainId;
1039     }
1040 }