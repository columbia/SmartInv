1 // SPDX-License-Identifier: MIT
2 
3 
4 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
5 
6 
7 
8 pragma solidity ^0.6.0;
9 
10 /**
11  * @dev Interface of the ERC20 standard as defined in the EIP.
12  */
13 interface IERC20 {
14     /**
15      * @dev Returns the amount of tokens in existence.
16      */
17     function totalSupply() external view returns (uint256);
18 
19     /**
20      * @dev Returns the amount of tokens owned by `account`.
21      */
22     function balanceOf(address account) external view returns (uint256);
23 
24     /**
25      * @dev Moves `amount` tokens from the caller's account to `recipient`.
26      *
27      * Returns a boolean value indicating whether the operation succeeded.
28      *
29      * Emits a {Transfer} event.
30      */
31     function transfer(address recipient, uint256 amount) external returns (bool);
32 
33     /**
34      * @dev Returns the remaining number of tokens that `spender` will be
35      * allowed to spend on behalf of `owner` through {transferFrom}. This is
36      * zero by default.
37      *
38      * This value changes when {approve} or {transferFrom} are called.
39      */
40     function allowance(address owner, address spender) external view returns (uint256);
41 
42     /**
43      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * IMPORTANT: Beware that changing an allowance with this method brings the risk
48      * that someone may use both the old and the new allowance by unfortunate
49      * transaction ordering. One possible solution to mitigate this race
50      * condition is to first reduce the spender's allowance to 0 and set the
51      * desired value afterwards:
52      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53      *
54      * Emits an {Approval} event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `sender` to `recipient` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Emitted when `value` tokens are moved from one account (`from`) to
71      * another (`to`).
72      *
73      * Note that `value` may be zero.
74      */
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 
77     /**
78      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
79      * a call to {approve}. `value` is the new allowance.
80      */
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 // File: @openzeppelin/contracts/GSN/Context.sol
85 
86 
87 
88 pragma solidity ^0.6.0;
89 
90 /*
91  * @dev Provides information about the current execution context, including the
92  * sender of the transaction and its data. While these are generally available
93  * via msg.sender and msg.data, they should not be accessed in such a direct
94  * manner, since when dealing with GSN meta-transactions the account sending and
95  * paying for execution may not be the actual sender (as far as an application
96  * is concerned).
97  *
98  * This contract is only required for intermediate, library-like contracts.
99  */
100 abstract contract Context {
101     function _msgSender() internal view virtual returns (address payable) {
102         return msg.sender;
103     }
104 
105     function _msgData() internal view virtual returns (bytes memory) {
106         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
107         return msg.data;
108     }
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
726 
727 pragma solidity 0.6.12;
728 
729 
730 
731 
732 
733 contract Standard is ERC20("Standard", "xMARK"){
734     using SafeMath for uint256;
735     IERC20 public mark;
736 
737     constructor(IERC20 _mark) public {
738         mark = _mark;
739         _setupDecimals(9);
740     }
741 
742     function enter(uint256 _amount) public {
743         uint256 totalMark = mark.balanceOf(address(this));
744         uint256 totalShares = totalSupply();
745         if (totalShares == 0 || totalMark == 0) {
746             _mint(msg.sender, _amount);
747         } else {
748             uint256 what = _amount.mul(totalShares).div(totalMark);
749             _mint(msg.sender, what);
750         }
751         mark.transferFrom(msg.sender, address(this), _amount);
752     }
753 
754     function leave(uint256 _share) public {
755         uint256 totalShares = totalSupply();
756         uint256 what = _share.mul(mark.balanceOf(address(this))).div(totalShares);
757         _burn(msg.sender, _share);
758         mark.transfer(msg.sender, what);
759     }
760 }