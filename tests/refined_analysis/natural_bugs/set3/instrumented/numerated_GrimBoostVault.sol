1 /**
2  *Submitted for verification at FtmScan.com on 2021-08-31
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // File: @openzeppelin/contracts/GSN/Context.sol
7 
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
114 pragma solidity ^0.6.0;
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
272 // File: @openzeppelin/contracts/utils/Address.sol
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
299         // This method relies in extcodesize, which returns 0 for contracts in
300         // construction, since the code is only stored at the end of the
301         // constructor execution.
302 
303         uint256 size;
304         // solhint-disable-next-line no-inline-assembly
305         assembly { size := extcodesize(account) }
306         return size > 0;
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
723 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
724 
725 
726 pragma solidity ^0.6.0;
727 
728 
729 
730 
731 /**
732  * @title SafeERC20
733  * @dev Wrappers around ERC20 operations that throw on failure (when the token
734  * contract returns false). Tokens that return no value (and instead revert or
735  * throw on failure) are also supported, non-reverting calls are assumed to be
736  * successful.
737  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
738  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
739  */
740 library SafeERC20 {
741     using SafeMath for uint256;
742     using Address for address;
743 
744     function safeTransfer(IERC20 token, address to, uint256 value) internal {
745         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
746     }
747 
748     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
749         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
750     }
751 
752     /**
753      * @dev Deprecated. This function has issues similar to the ones found in
754      * {IERC20-approve}, and its usage is discouraged.
755      *
756      * Whenever possible, use {safeIncreaseAllowance} and
757      * {safeDecreaseAllowance} instead.
758      */
759     function safeApprove(IERC20 token, address spender, uint256 value) internal {
760         // safeApprove should only be called when setting an initial allowance,
761         // or when resetting it to zero. To increase and decrease it, use
762         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
763         // solhint-disable-next-line max-line-length
764         require((value == 0) || (token.allowance(address(this), spender) == 0),
765             "SafeERC20: approve from non-zero to non-zero allowance"
766         );
767         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
768     }
769 
770     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
771         uint256 newAllowance = token.allowance(address(this), spender).add(value);
772         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
773     }
774 
775     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
776         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
777         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
778     }
779 
780     /**
781      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
782      * on the return value: the return value is optional (but if data is returned, it must not be false).
783      * @param token The token targeted by the call.
784      * @param data The call data (encoded using abi.encode or one of its variants).
785      */
786     function _callOptionalReturn(IERC20 token, bytes memory data) private {
787         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
788         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
789         // the target address contains contract code and also asserts for success in the low-level call.
790 
791         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed in vault");
792         if (returndata.length > 0) { // Return data is optional
793             // solhint-disable-next-line max-line-length
794             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
795         }
796     }
797 }
798 
799 // File: @openzeppelin/contracts/access/Ownable.sol
800 
801 
802 pragma solidity ^0.6.0;
803 
804 /**
805  * @dev Contract module which provides a basic access control mechanism, where
806  * there is an account (an owner) that can be granted exclusive access to
807  * specific functions.
808  *
809  * By default, the owner account will be the one that deploys the contract. This
810  * can later be changed with {transferOwnership}.
811  *
812  * This module is used through inheritance. It will make available the modifier
813  * `onlyOwner`, which can be applied to your functions to restrict their use to
814  * the owner.
815  */
816 contract Ownable is Context {
817     address private _owner;
818 
819     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
820 
821     /**
822      * @dev Initializes the contract setting the deployer as the initial owner.
823      */
824     constructor () internal {
825         address msgSender = _msgSender();
826         _owner = msgSender;
827         emit OwnershipTransferred(address(0), msgSender);
828     }
829 
830     /**
831      * @dev Returns the address of the current owner.
832      */
833     function owner() public view returns (address) {
834         return _owner;
835     }
836 
837     /**
838      * @dev Throws if called by any account other than the owner.
839      */
840     modifier onlyOwner() {
841         require(_owner == _msgSender(), "Ownable: caller is not the owner");
842         _;
843     }
844 
845     /**
846      * @dev Leaves the contract without owner. It will not be possible to call
847      * `onlyOwner` functions anymore. Can only be called by the current owner.
848      *
849      * NOTE: Renouncing ownership will leave the contract without an owner,
850      * thereby removing any functionality that is only available to the owner.
851      */
852     function renounceOwnership() public virtual onlyOwner {
853         emit OwnershipTransferred(_owner, address(0));
854         _owner = address(0);
855     }
856 
857     /**
858      * @dev Transfers ownership of the contract to a new account (`newOwner`).
859      * Can only be called by the current owner.
860      */
861     function transferOwnership(address newOwner) public virtual onlyOwner {
862         require(newOwner != address(0), "Ownable: new owner is the zero address");
863         emit OwnershipTransferred(_owner, newOwner);
864         _owner = newOwner;
865     }
866 }
867 
868 pragma solidity ^0.6.0;
869 
870 
871 /**
872  * @title Helps contracts guard against reentrancy attacks.
873  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
874  * @dev If you mark a function `nonReentrant`, you should also
875  * mark it `external`.
876  */
877 contract ReentrancyGuard {
878 
879   /// @dev counter to allow mutex lock with only one SSTORE operation
880   uint256 private _guardCounter = 1;
881 
882   /**
883    * @dev Prevents a contract from calling itself, directly or indirectly.
884    * If you mark a function `nonReentrant`, you should also
885    * mark it `external`. Calling one `nonReentrant` function from
886    * another is not supported. Instead, you can implement a
887    * `private` function doing the actual work, and an `external`
888    * wrapper marked as `nonReentrant`.
889    */
890   modifier nonReentrant() {
891     _guardCounter += 1;
892     uint256 localCounter = _guardCounter;
893     _;
894     require(localCounter == _guardCounter);
895   }
896 
897 }
898 
899 pragma solidity ^0.6.0;
900 
901 
902 interface IStrategy {
903     function vault() external view returns (address);
904     function want() external view returns (IERC20);
905     function beforeDeposit() external;
906     function deposit() external;
907     function withdraw(uint256) external;
908     function balanceOfPool() external view returns (uint256);
909     function harvest() external;
910     function retireStrat() external;
911     function panic() external;
912     function pause() external;
913     function unpause() external;
914     function paused() external view returns (bool);
915 }
916 
917 
918 pragma solidity ^0.6.0;
919 
920 
921 
922 
923 
924 /**
925  * @dev Implementation of a vault to deposit funds for yield optimizing.
926  * This is the contract that receives funds and that users interface with.
927  * The yield optimizing strategy itself is implemented in a separate 'Strategy.sol' contract.
928  */
929 contract GrimBoostVault is ERC20, Ownable, ReentrancyGuard {
930     using SafeERC20 for IERC20;
931     using SafeMath for uint256;
932 
933     struct StratCandidate {
934         address implementation;
935         uint proposedTime;
936     }
937 
938     // The last proposed strategy to switch to.
939     StratCandidate public stratCandidate;
940     // The strategy currently in use by the vault.
941     IStrategy public strategy;
942     // The minimum time it has to pass before a strat candidate can be approved.
943     uint256 public immutable approvalDelay;
944 
945     event NewStratCandidate(address implementation);
946     event UpgradeStrat(address implementation);
947 
948     /**
949      * @dev Sets the value of {token} to the token that the vault will
950      * hold as underlying value. It initializes the vault's own 'moo' token.
951      * This token is minted when someone does a deposit. It is burned in order
952      * to withdraw the corresponding portion of the underlying assets.
953      * @param _strategy the address of the strategy.
954      * @param _name the name of the vault token.
955      * @param _symbol the symbol of the vault token.
956      * @param _approvalDelay the delay before a new strat can be approved.
957      */
958     constructor (
959         IStrategy _strategy,
960         string memory _name,
961         string memory _symbol,
962         uint256 _approvalDelay
963     ) public ERC20(
964         _name,
965         _symbol
966     ) {
967         strategy = _strategy;
968         approvalDelay = _approvalDelay;
969     }
970 
971     function want() public view returns (IERC20) {
972         return IERC20(strategy.want());
973     }
974 
975     /**
976      * @dev It calculates the total underlying value of {token} held by the system.
977      * It takes into account the vault contract balance, the strategy contract balance
978      *  and the balance deployed in other contracts as part of the strategy.
979      */
980     function balance() public view returns (uint) {
981         return want().balanceOf(address(this)).add(IStrategy(strategy).balanceOfPool());
982     }
983 
984     /**
985      * @dev Custom logic in here for how much the vault allows to be borrowed.
986      * We return 100% of tokens for now. Under certain conditions we might
987      * want to keep some of the system funds at hand in the vault, instead
988      * of putting them to work.
989      */
990     function available() public view returns (uint256) {
991         return want().balanceOf(address(this));
992     }
993 
994     /**
995      * @dev Function for various UIs to display the current value of one of our yield tokens.
996      * Returns an uint256 with 18 decimals of how much underlying asset one vault share represents.
997      */
998     function getPricePerFullShare() public view returns (uint256) {
999         return totalSupply() == 0 ? 1e18 : balance().mul(1e18).div(totalSupply());
1000     }
1001 
1002     /**
1003      * @dev A helper function to call deposit() with all the sender's funds.
1004      */
1005     function depositAll() external {
1006         deposit(want().balanceOf(msg.sender));
1007     }
1008 
1009     /**
1010      * @dev The entrypoint of funds into the system. People deposit with this function
1011      * into the vault. The vault is then in charge of sending funds into the strategy.
1012      */
1013     function deposit(uint _amount) public nonReentrant {
1014         require(_amount > 0, "!deposit zero");
1015 
1016         uint256 _pool = balance();
1017         want().safeTransferFrom(msg.sender, address(this), _amount);
1018         earn();
1019         uint256 _after = balance();
1020         _amount = _after.sub(_pool); // Additional check for deflationary tokens
1021         uint256 shares = 0;
1022         if (totalSupply() == 0) {
1023             shares = _amount;
1024         } else {
1025             shares = (_amount.mul(totalSupply())).div(_pool);
1026         }
1027         _mint(msg.sender, shares);
1028     }
1029 
1030     /**
1031      * @dev Function to send funds into the strategy and put them to work. It's primarily called
1032      * by the vault's deposit() function.
1033      */
1034     function earn() public {
1035         uint _bal = available();
1036         IERC20(want()).safeTransfer(address(strategy), _bal);
1037         IStrategy(strategy).deposit();
1038     }
1039 
1040     /**
1041      * @dev A helper function to call withdraw() with all the sender's funds.
1042      */
1043     function withdrawAll() external {
1044         withdraw(balanceOf(msg.sender));
1045     }
1046 
1047     /**
1048      * @dev Function to exit the system. The vault will withdraw the required tokens
1049      * from the strategy and pay up the token holder. A proportional number of IOU
1050      * tokens are burned in the process.
1051      */
1052     function withdraw(uint256 _shares) public {
1053         uint256 r = (balance().mul(_shares)).div(totalSupply());
1054         _burn(msg.sender, _shares);
1055 
1056         uint b = want().balanceOf(address(this));
1057         if (b < r) {
1058             uint _withdraw = r.sub(b);
1059             strategy.withdraw(_withdraw);
1060             uint _after = want().balanceOf(address(this));
1061             uint _diff = _after.sub(b);
1062             if (_diff < _withdraw) {
1063                 r = b.add(_diff);
1064             }
1065         }
1066 
1067         want().safeTransfer(msg.sender, r);
1068     }
1069 
1070     /** 
1071      * @dev Sets the candidate for the new strat to use with this vault.
1072      * @param _implementation The address of the candidate strategy.  
1073      */
1074     function proposeStrat(address _implementation) public onlyOwner {
1075         require(address(this) == IStrategy(_implementation).vault(), "Proposal not valid for this Vault");
1076         stratCandidate = StratCandidate({
1077             implementation: _implementation,
1078             proposedTime: block.timestamp
1079          });
1080 
1081         emit NewStratCandidate(_implementation);
1082     }
1083 
1084     /** 
1085      * @dev It switches the active strat for the strat candidate. After upgrading, the 
1086      * candidate implementation is set to the 0x00 address, and proposedTime to a time 
1087      * happening in +100 years for safety. 
1088      */
1089 
1090     function upgradeStrat() public onlyOwner {
1091         require(stratCandidate.implementation != address(0), "There is no candidate");
1092         require(stratCandidate.proposedTime.add(approvalDelay) < block.timestamp, "Delay has not passed");
1093 
1094         emit UpgradeStrat(stratCandidate.implementation);
1095 
1096         strategy.retireStrat();
1097         strategy = IStrategy(stratCandidate.implementation);
1098         stratCandidate.implementation = address(0);
1099         stratCandidate.proposedTime = 5000000000;
1100 
1101         earn();
1102     }
1103 
1104     /**
1105      * @dev Rescues random funds stuck that the strat can't handle.
1106      * @param _token address of the token to rescue.
1107      */
1108     function inCaseTokensGetStuck(address _token) external onlyOwner {
1109         require(_token != address(want()), "!token");
1110 
1111         uint256 amount = IERC20(_token).balanceOf(address(this));
1112         IERC20(_token).safeTransfer(msg.sender, amount);
1113     }
1114 
1115     function depositFor(address token, uint _amount,address user ) public {
1116 
1117         uint256 _pool = balance();
1118         IERC20(token).safeTransferFrom(msg.sender, address(this), _amount);
1119         earn();
1120         uint256 _after = balance();
1121         _amount = _after.sub(_pool); // Additional check for deflationary tokens
1122         uint256 shares = 0;
1123         if (totalSupply() == 0) {
1124             shares = _amount;
1125         } else {
1126             shares = (_amount.mul(totalSupply())).div(_pool);
1127         }
1128         _mint(user, shares);
1129     }
1130 }