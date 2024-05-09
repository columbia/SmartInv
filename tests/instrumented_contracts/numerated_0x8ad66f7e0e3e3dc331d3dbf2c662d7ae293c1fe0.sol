1 // Sources flattened with hardhat v2.0.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/GSN/Context.sol@v3.2.0
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.6.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.2.0
32 
33 
34 pragma solidity ^0.6.0;
35 
36 /**
37  * @dev Interface of the ERC20 standard as defined in the EIP.
38  */
39 interface IERC20 {
40     /**
41      * @dev Returns the amount of tokens in existence.
42      */
43     function totalSupply() external view returns (uint256);
44 
45     /**
46      * @dev Returns the amount of tokens owned by `account`.
47      */
48     function balanceOf(address account) external view returns (uint256);
49 
50     /**
51      * @dev Moves `amount` tokens from the caller's account to `recipient`.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transfer(address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     /**
69      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * IMPORTANT: Beware that changing an allowance with this method brings the risk
74      * that someone may use both the old and the new allowance by unfortunate
75      * transaction ordering. One possible solution to mitigate this race
76      * condition is to first reduce the spender's allowance to 0 and set the
77      * desired value afterwards:
78      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79      *
80      * Emits an {Approval} event.
81      */
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Moves `amount` tokens from `sender` to `recipient` using the
86      * allowance mechanism. `amount` is then deducted from the caller's
87      * allowance.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Emitted when `value` tokens are moved from one account (`from`) to
97      * another (`to`).
98      *
99      * Note that `value` may be zero.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     /**
104      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
105      * a call to {approve}. `value` is the new allowance.
106      */
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 
111 // File @openzeppelin/contracts/math/SafeMath.sol@v3.2.0
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
272 
273 // File @openzeppelin/contracts/utils/Address.sol@v3.2.0
274 
275 
276 pragma solidity ^0.6.2;
277 
278 /**
279  * @dev Collection of functions related to the address type
280  */
281 library Address {
282     /**
283      * @dev Returns true if `account` is a contract.
284      *
285      * [IMPORTANT]
286      * ====
287      * It is unsafe to assume that an address for which this function returns
288      * false is an externally-owned account (EOA) and not a contract.
289      *
290      * Among others, `isContract` will return false for the following
291      * types of addresses:
292      *
293      *  - an externally-owned account
294      *  - a contract in construction
295      *  - an address where a contract will be created
296      *  - an address where a contract lived, but was destroyed
297      * ====
298      */
299     function isContract(address account) internal view returns (bool) {
300         // This method relies in extcodesize, which returns 0 for contracts in
301         // construction, since the code is only stored at the end of the
302         // constructor execution.
303 
304         uint256 size;
305         // solhint-disable-next-line no-inline-assembly
306         assembly { size := extcodesize(account) }
307         return size > 0;
308     }
309 
310     /**
311      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
312      * `recipient`, forwarding all available gas and reverting on errors.
313      *
314      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
315      * of certain opcodes, possibly making contracts go over the 2300 gas limit
316      * imposed by `transfer`, making them unable to receive funds via
317      * `transfer`. {sendValue} removes this limitation.
318      *
319      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
320      *
321      * IMPORTANT: because control is transferred to `recipient`, care must be
322      * taken to not create reentrancy vulnerabilities. Consider using
323      * {ReentrancyGuard} or the
324      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
325      */
326     function sendValue(address payable recipient, uint256 amount) internal {
327         require(address(this).balance >= amount, "Address: insufficient balance");
328 
329         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
330         (bool success, ) = recipient.call{ value: amount }("");
331         require(success, "Address: unable to send value, recipient may have reverted");
332     }
333 
334     /**
335      * @dev Performs a Solidity function call using a low level `call`. A
336      * plain`call` is an unsafe replacement for a function call: use this
337      * function instead.
338      *
339      * If `target` reverts with a revert reason, it is bubbled up by this
340      * function (like regular Solidity function calls).
341      *
342      * Returns the raw returned data. To convert to the expected return value,
343      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
344      *
345      * Requirements:
346      *
347      * - `target` must be a contract.
348      * - calling `target` with `data` must not revert.
349      *
350      * _Available since v3.1._
351      */
352     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
353       return functionCall(target, data, "Address: low-level call failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
358      * `errorMessage` as a fallback revert reason when `target` reverts.
359      *
360      * _Available since v3.1._
361      */
362     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
363         return _functionCallWithValue(target, data, 0, errorMessage);
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
368      * but also transferring `value` wei to `target`.
369      *
370      * Requirements:
371      *
372      * - the calling contract must have an ETH balance of at least `value`.
373      * - the called Solidity function must be `payable`.
374      *
375      * _Available since v3.1._
376      */
377     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
378         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
383      * with `errorMessage` as a fallback revert reason when `target` reverts.
384      *
385      * _Available since v3.1._
386      */
387     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
388         require(address(this).balance >= value, "Address: insufficient balance for call");
389         return _functionCallWithValue(target, data, value, errorMessage);
390     }
391 
392     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
393         require(isContract(target), "Address: call to non-contract");
394 
395         // solhint-disable-next-line avoid-low-level-calls
396         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
397         if (success) {
398             return returndata;
399         } else {
400             // Look for revert reason and bubble it up if present
401             if (returndata.length > 0) {
402                 // The easiest way to bubble the revert reason is using memory via assembly
403 
404                 // solhint-disable-next-line no-inline-assembly
405                 assembly {
406                     let returndata_size := mload(returndata)
407                     revert(add(32, returndata), returndata_size)
408                 }
409             } else {
410                 revert(errorMessage);
411             }
412         }
413     }
414 }
415 
416 
417 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.2.0
418 
419 
420 pragma solidity ^0.6.0;
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
676      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
677      *
678      * This internal function is equivalent to `approve`, and can be used to
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
724 
725 // File contracts/v612/FANNY/MerchToken.sol
726 
727 
728 pragma solidity ^0.6.12;
729 pragma experimental ABIEncoderV2;
730 
731 interface ICOREGlobals {
732     function TransferHandler() external returns (address);
733 }
734 interface ICORETransferHandler{
735     function handleRestrictedTokenTransfer(address, address, uint256) external;
736 }
737 
738 /**
739  * You find yourself deep in the forest
740  * You're lost, your flashlight is running out of batteries
741  * It barely shines anymore...
742  * You barely see a large figure approaching you
743  * its moving towards you fast
744  * there is no way you can run
745  * just in the field of vision of your feint flashlight
746  * appears a smiling face, its a 6'4" muscule bound male
747  * he says with a gravel like voice 
748  * "I thikn your flashlight is out of battery, here take my spare"
749  * He reaches inside a fanny pack and hands you 3 AAA batteries
750  * "Are you lost? I'm X3"
751  */
752 
753 contract FANNY is ERC20 ("cVault.finance/FANNY", "FANNY")  {
754 
755     ICOREGlobals public coreGlobals;
756     Claim [] public   allClaims;
757     mapping (address => Claim[]) public claimsByPerson;
758 
759     event Claimed(uint256 indexed claimID, address indexed claimer, uint256 timestamp);
760 
761     constructor() public {
762         coreGlobals = ICOREGlobals(0x255CA4596A963883Afe0eF9c85EA071Cc050128B);
763         _mint(msg.sender, 300 ether);
764     }
765 
766     struct Claim {
767         uint256 id;
768         uint256 timestamp;
769         address claimerAddress;
770     }
771 
772     // Front end helper
773     function allClaimsForAnAddress(address guy) public view returns (Claim[] memory claims) {
774         claims = claimsByPerson[guy];
775     }
776 
777     function claimFanny() public {
778         require(msg.sender == tx.origin, "Only dumb wallets.");
779         _burn(msg.sender, 1e18);
780 
781         uint256 claimID = allClaims.length;
782         claimsByPerson[msg.sender].push(
783             Claim ({
784                 id : claimID,
785                 timestamp : block.timestamp,
786                 claimerAddress : msg.sender
787             })
788         );
789 
790         allClaims.push(
791             Claim ({
792                 id : allClaims.length,
793                 timestamp : block.timestamp,
794                 claimerAddress : msg.sender
795 
796             })
797         );
798 
799         emit Claimed(claimID, msg.sender, block.timestamp);
800     }
801 
802     function _beforeTokenTransfer(address from, address to, uint256 amount) internal  virtual override {
803         ICORETransferHandler(coreGlobals.TransferHandler()).handleRestrictedTokenTransfer(from, to, amount);
804     }
805 
806 }