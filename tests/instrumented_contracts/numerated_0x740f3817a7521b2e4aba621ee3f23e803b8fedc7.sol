1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: @openzeppelin/contracts/GSN/Context.sol
82 
83 // SPDX-License-Identifier: MIT
84 
85 pragma solidity ^0.6.0;
86 
87 /*
88  * @dev Provides information about the current execution context, including the
89  * sender of the transaction and its data. While these are generally available
90  * via msg.sender and msg.data, they should not be accessed in such a direct
91  * manner, since when dealing with GSN meta-transactions the account sending and
92  * paying for execution may not be the actual sender (as far as an application
93  * is concerned).
94  *
95  * This contract is only required for intermediate, library-like contracts.
96  */
97 abstract contract Context {
98     function _msgSender() internal view virtual returns (address payable) {
99         return msg.sender;
100     }
101 
102     function _msgData() internal view virtual returns (bytes memory) {
103         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
104         return msg.data;
105     }
106 }
107 
108 // File: @openzeppelin/contracts/access/Ownable.sol
109 
110 // SPDX-License-Identifier: MIT
111 
112 pragma solidity ^0.6.0;
113 
114 /**
115  * @dev Contract module which provides a basic access control mechanism, where
116  * there is an account (an owner) that can be granted exclusive access to
117  * specific functions.
118  *
119  * By default, the owner account will be the one that deploys the contract. This
120  * can later be changed with {transferOwnership}.
121  *
122  * This module is used through inheritance. It will make available the modifier
123  * `onlyOwner`, which can be applied to your functions to restrict their use to
124  * the owner.
125  */
126 contract Ownable is Context {
127     address private _owner;
128 
129     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
130 
131     /**
132      * @dev Initializes the contract setting the deployer as the initial owner.
133      */
134     constructor () internal {
135         address msgSender = _msgSender();
136         _owner = msgSender;
137         emit OwnershipTransferred(address(0), msgSender);
138     }
139 
140     /**
141      * @dev Returns the address of the current owner.
142      */
143     function owner() public view returns (address) {
144         return _owner;
145     }
146 
147     /**
148      * @dev Throws if called by any account other than the owner.
149      */
150     modifier onlyOwner() {
151         require(_owner == _msgSender(), "Ownable: caller is not the owner");
152         _;
153     }
154 
155     /**
156      * @dev Leaves the contract without owner. It will not be possible to call
157      * `onlyOwner` functions anymore. Can only be called by the current owner.
158      *
159      * NOTE: Renouncing ownership will leave the contract without an owner,
160      * thereby removing any functionality that is only available to the owner.
161      */
162     function renounceOwnership() public virtual onlyOwner {
163         emit OwnershipTransferred(_owner, address(0));
164         _owner = address(0);
165     }
166 
167     /**
168      * @dev Transfers ownership of the contract to a new account (`newOwner`).
169      * Can only be called by the current owner.
170      */
171     function transferOwnership(address newOwner) public virtual onlyOwner {
172         require(newOwner != address(0), "Ownable: new owner is the zero address");
173         emit OwnershipTransferred(_owner, newOwner);
174         _owner = newOwner;
175     }
176 }
177 
178 // File: @openzeppelin/contracts/math/SafeMath.sol
179 
180 // SPDX-License-Identifier: MIT
181 
182 pragma solidity ^0.6.0;
183 
184 /**
185  * @dev Wrappers over Solidity's arithmetic operations with added overflow
186  * checks.
187  *
188  * Arithmetic operations in Solidity wrap on overflow. This can easily result
189  * in bugs, because programmers usually assume that an overflow raises an
190  * error, which is the standard behavior in high level programming languages.
191  * `SafeMath` restores this intuition by reverting the transaction when an
192  * operation overflows.
193  *
194  * Using this library instead of the unchecked operations eliminates an entire
195  * class of bugs, so it's recommended to use it always.
196  */
197 library SafeMath {
198     /**
199      * @dev Returns the addition of two unsigned integers, reverting on
200      * overflow.
201      *
202      * Counterpart to Solidity's `+` operator.
203      *
204      * Requirements:
205      *
206      * - Addition cannot overflow.
207      */
208     function add(uint256 a, uint256 b) internal pure returns (uint256) {
209         uint256 c = a + b;
210         require(c >= a, "SafeMath: addition overflow");
211 
212         return c;
213     }
214 
215     /**
216      * @dev Returns the subtraction of two unsigned integers, reverting on
217      * overflow (when the result is negative).
218      *
219      * Counterpart to Solidity's `-` operator.
220      *
221      * Requirements:
222      *
223      * - Subtraction cannot overflow.
224      */
225     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
226         return sub(a, b, "SafeMath: subtraction overflow");
227     }
228 
229     /**
230      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
231      * overflow (when the result is negative).
232      *
233      * Counterpart to Solidity's `-` operator.
234      *
235      * Requirements:
236      *
237      * - Subtraction cannot overflow.
238      */
239     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
240         require(b <= a, errorMessage);
241         uint256 c = a - b;
242 
243         return c;
244     }
245 
246     /**
247      * @dev Returns the multiplication of two unsigned integers, reverting on
248      * overflow.
249      *
250      * Counterpart to Solidity's `*` operator.
251      *
252      * Requirements:
253      *
254      * - Multiplication cannot overflow.
255      */
256     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
257         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
258         // benefit is lost if 'b' is also tested.
259         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
260         if (a == 0) {
261             return 0;
262         }
263 
264         uint256 c = a * b;
265         require(c / a == b, "SafeMath: multiplication overflow");
266 
267         return c;
268     }
269 
270     /**
271      * @dev Returns the integer division of two unsigned integers. Reverts on
272      * division by zero. The result is rounded towards zero.
273      *
274      * Counterpart to Solidity's `/` operator. Note: this function uses a
275      * `revert` opcode (which leaves remaining gas untouched) while Solidity
276      * uses an invalid opcode to revert (consuming all remaining gas).
277      *
278      * Requirements:
279      *
280      * - The divisor cannot be zero.
281      */
282     function div(uint256 a, uint256 b) internal pure returns (uint256) {
283         return div(a, b, "SafeMath: division by zero");
284     }
285 
286     /**
287      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
288      * division by zero. The result is rounded towards zero.
289      *
290      * Counterpart to Solidity's `/` operator. Note: this function uses a
291      * `revert` opcode (which leaves remaining gas untouched) while Solidity
292      * uses an invalid opcode to revert (consuming all remaining gas).
293      *
294      * Requirements:
295      *
296      * - The divisor cannot be zero.
297      */
298     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
299         require(b > 0, errorMessage);
300         uint256 c = a / b;
301         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
302 
303         return c;
304     }
305 
306     /**
307      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
308      * Reverts when dividing by zero.
309      *
310      * Counterpart to Solidity's `%` operator. This function uses a `revert`
311      * opcode (which leaves remaining gas untouched) while Solidity uses an
312      * invalid opcode to revert (consuming all remaining gas).
313      *
314      * Requirements:
315      *
316      * - The divisor cannot be zero.
317      */
318     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
319         return mod(a, b, "SafeMath: modulo by zero");
320     }
321 
322     /**
323      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
324      * Reverts with custom message when dividing by zero.
325      *
326      * Counterpart to Solidity's `%` operator. This function uses a `revert`
327      * opcode (which leaves remaining gas untouched) while Solidity uses an
328      * invalid opcode to revert (consuming all remaining gas).
329      *
330      * Requirements:
331      *
332      * - The divisor cannot be zero.
333      */
334     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
335         require(b != 0, errorMessage);
336         return a % b;
337     }
338 }
339 
340 // File: @openzeppelin/contracts/utils/Address.sol
341 
342 // SPDX-License-Identifier: MIT
343 
344 pragma solidity ^0.6.2;
345 
346 /**
347  * @dev Collection of functions related to the address type
348  */
349 library Address {
350     /**
351      * @dev Returns true if `account` is a contract.
352      *
353      * [IMPORTANT]
354      * ====
355      * It is unsafe to assume that an address for which this function returns
356      * false is an externally-owned account (EOA) and not a contract.
357      *
358      * Among others, `isContract` will return false for the following
359      * types of addresses:
360      *
361      *  - an externally-owned account
362      *  - a contract in construction
363      *  - an address where a contract will be created
364      *  - an address where a contract lived, but was destroyed
365      * ====
366      */
367     function isContract(address account) internal view returns (bool) {
368         // This method relies in extcodesize, which returns 0 for contracts in
369         // construction, since the code is only stored at the end of the
370         // constructor execution.
371 
372         uint256 size;
373         // solhint-disable-next-line no-inline-assembly
374         assembly { size := extcodesize(account) }
375         return size > 0;
376     }
377 
378     /**
379      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
380      * `recipient`, forwarding all available gas and reverting on errors.
381      *
382      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
383      * of certain opcodes, possibly making contracts go over the 2300 gas limit
384      * imposed by `transfer`, making them unable to receive funds via
385      * `transfer`. {sendValue} removes this limitation.
386      *
387      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
388      *
389      * IMPORTANT: because control is transferred to `recipient`, care must be
390      * taken to not create reentrancy vulnerabilities. Consider using
391      * {ReentrancyGuard} or the
392      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
393      */
394     function sendValue(address payable recipient, uint256 amount) internal {
395         require(address(this).balance >= amount, "Address: insufficient balance");
396 
397         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
398         (bool success, ) = recipient.call{ value: amount }("");
399         require(success, "Address: unable to send value, recipient may have reverted");
400     }
401 
402     /**
403      * @dev Performs a Solidity function call using a low level `call`. A
404      * plain`call` is an unsafe replacement for a function call: use this
405      * function instead.
406      *
407      * If `target` reverts with a revert reason, it is bubbled up by this
408      * function (like regular Solidity function calls).
409      *
410      * Returns the raw returned data. To convert to the expected return value,
411      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
412      *
413      * Requirements:
414      *
415      * - `target` must be a contract.
416      * - calling `target` with `data` must not revert.
417      *
418      * _Available since v3.1._
419      */
420     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
421       return functionCall(target, data, "Address: low-level call failed");
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
426      * `errorMessage` as a fallback revert reason when `target` reverts.
427      *
428      * _Available since v3.1._
429      */
430     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
431         return _functionCallWithValue(target, data, 0, errorMessage);
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
436      * but also transferring `value` wei to `target`.
437      *
438      * Requirements:
439      *
440      * - the calling contract must have an ETH balance of at least `value`.
441      * - the called Solidity function must be `payable`.
442      *
443      * _Available since v3.1._
444      */
445     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
446         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
451      * with `errorMessage` as a fallback revert reason when `target` reverts.
452      *
453      * _Available since v3.1._
454      */
455     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
456         require(address(this).balance >= value, "Address: insufficient balance for call");
457         return _functionCallWithValue(target, data, value, errorMessage);
458     }
459 
460     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
461         require(isContract(target), "Address: call to non-contract");
462 
463         // solhint-disable-next-line avoid-low-level-calls
464         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
465         if (success) {
466             return returndata;
467         } else {
468             // Look for revert reason and bubble it up if present
469             if (returndata.length > 0) {
470                 // The easiest way to bubble the revert reason is using memory via assembly
471 
472                 // solhint-disable-next-line no-inline-assembly
473                 assembly {
474                     let returndata_size := mload(returndata)
475                     revert(add(32, returndata), returndata_size)
476                 }
477             } else {
478                 revert(errorMessage);
479             }
480         }
481     }
482 }
483 
484 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
485 
486 // SPDX-License-Identifier: MIT
487 
488 pragma solidity ^0.6.0;
489 
490 
491 
492 
493 
494 /**
495  * @dev Implementation of the {IERC20} interface.
496  *
497  * This implementation is agnostic to the way tokens are created. This means
498  * that a supply mechanism has to be added in a derived contract using {_mint}.
499  * For a generic mechanism see {ERC20PresetMinterPauser}.
500  *
501  * TIP: For a detailed writeup see our guide
502  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
503  * to implement supply mechanisms].
504  *
505  * We have followed general OpenZeppelin guidelines: functions revert instead
506  * of returning `false` on failure. This behavior is nonetheless conventional
507  * and does not conflict with the expectations of ERC20 applications.
508  *
509  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
510  * This allows applications to reconstruct the allowance for all accounts just
511  * by listening to said events. Other implementations of the EIP may not emit
512  * these events, as it isn't required by the specification.
513  *
514  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
515  * functions have been added to mitigate the well-known issues around setting
516  * allowances. See {IERC20-approve}.
517  */
518 contract ERC20 is Context, IERC20 {
519     using SafeMath for uint256;
520     using Address for address;
521 
522     mapping (address => uint256) private _balances;
523 
524     mapping (address => mapping (address => uint256)) private _allowances;
525 
526     uint256 private _totalSupply;
527 
528     string private _name;
529     string private _symbol;
530     uint8 private _decimals;
531 
532     /**
533      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
534      * a default value of 18.
535      *
536      * To select a different value for {decimals}, use {_setupDecimals}.
537      *
538      * All three of these values are immutable: they can only be set once during
539      * construction.
540      */
541     constructor (string memory name, string memory symbol) public {
542         _name = name;
543         _symbol = symbol;
544         _decimals = 18;
545     }
546 
547     /**
548      * @dev Returns the name of the token.
549      */
550     function name() public view returns (string memory) {
551         return _name;
552     }
553 
554     /**
555      * @dev Returns the symbol of the token, usually a shorter version of the
556      * name.
557      */
558     function symbol() public view returns (string memory) {
559         return _symbol;
560     }
561 
562     /**
563      * @dev Returns the number of decimals used to get its user representation.
564      * For example, if `decimals` equals `2`, a balance of `505` tokens should
565      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
566      *
567      * Tokens usually opt for a value of 18, imitating the relationship between
568      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
569      * called.
570      *
571      * NOTE: This information is only used for _display_ purposes: it in
572      * no way affects any of the arithmetic of the contract, including
573      * {IERC20-balanceOf} and {IERC20-transfer}.
574      */
575     function decimals() public view returns (uint8) {
576         return _decimals;
577     }
578 
579     /**
580      * @dev See {IERC20-totalSupply}.
581      */
582     function totalSupply() public view override returns (uint256) {
583         return _totalSupply;
584     }
585 
586     /**
587      * @dev See {IERC20-balanceOf}.
588      */
589     function balanceOf(address account) public view override returns (uint256) {
590         return _balances[account];
591     }
592 
593     /**
594      * @dev See {IERC20-transfer}.
595      *
596      * Requirements:
597      *
598      * - `recipient` cannot be the zero address.
599      * - the caller must have a balance of at least `amount`.
600      */
601     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
602         _transfer(_msgSender(), recipient, amount);
603         return true;
604     }
605 
606     /**
607      * @dev See {IERC20-allowance}.
608      */
609     function allowance(address owner, address spender) public view virtual override returns (uint256) {
610         return _allowances[owner][spender];
611     }
612 
613     /**
614      * @dev See {IERC20-approve}.
615      *
616      * Requirements:
617      *
618      * - `spender` cannot be the zero address.
619      */
620     function approve(address spender, uint256 amount) public virtual override returns (bool) {
621         _approve(_msgSender(), spender, amount);
622         return true;
623     }
624 
625     /**
626      * @dev See {IERC20-transferFrom}.
627      *
628      * Emits an {Approval} event indicating the updated allowance. This is not
629      * required by the EIP. See the note at the beginning of {ERC20};
630      *
631      * Requirements:
632      * - `sender` and `recipient` cannot be the zero address.
633      * - `sender` must have a balance of at least `amount`.
634      * - the caller must have allowance for ``sender``'s tokens of at least
635      * `amount`.
636      */
637     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
638         _transfer(sender, recipient, amount);
639         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
640         return true;
641     }
642 
643     /**
644      * @dev Atomically increases the allowance granted to `spender` by the caller.
645      *
646      * This is an alternative to {approve} that can be used as a mitigation for
647      * problems described in {IERC20-approve}.
648      *
649      * Emits an {Approval} event indicating the updated allowance.
650      *
651      * Requirements:
652      *
653      * - `spender` cannot be the zero address.
654      */
655     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
656         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
657         return true;
658     }
659 
660     /**
661      * @dev Atomically decreases the allowance granted to `spender` by the caller.
662      *
663      * This is an alternative to {approve} that can be used as a mitigation for
664      * problems described in {IERC20-approve}.
665      *
666      * Emits an {Approval} event indicating the updated allowance.
667      *
668      * Requirements:
669      *
670      * - `spender` cannot be the zero address.
671      * - `spender` must have allowance for the caller of at least
672      * `subtractedValue`.
673      */
674     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
675         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
676         return true;
677     }
678 
679     /**
680      * @dev Moves tokens `amount` from `sender` to `recipient`.
681      *
682      * This is internal function is equivalent to {transfer}, and can be used to
683      * e.g. implement automatic token fees, slashing mechanisms, etc.
684      *
685      * Emits a {Transfer} event.
686      *
687      * Requirements:
688      *
689      * - `sender` cannot be the zero address.
690      * - `recipient` cannot be the zero address.
691      * - `sender` must have a balance of at least `amount`.
692      */
693     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
694         require(sender != address(0), "ERC20: transfer from the zero address");
695         require(recipient != address(0), "ERC20: transfer to the zero address");
696 
697         _beforeTokenTransfer(sender, recipient, amount);
698 
699         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
700         _balances[recipient] = _balances[recipient].add(amount);
701         emit Transfer(sender, recipient, amount);
702     }
703 
704     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
705      * the total supply.
706      *
707      * Emits a {Transfer} event with `from` set to the zero address.
708      *
709      * Requirements
710      *
711      * - `to` cannot be the zero address.
712      */
713     function _mint(address account, uint256 amount) internal virtual {
714         require(account != address(0), "ERC20: mint to the zero address");
715 
716         _beforeTokenTransfer(address(0), account, amount);
717 
718         _totalSupply = _totalSupply.add(amount);
719         _balances[account] = _balances[account].add(amount);
720         emit Transfer(address(0), account, amount);
721     }
722 
723     /**
724      * @dev Destroys `amount` tokens from `account`, reducing the
725      * total supply.
726      *
727      * Emits a {Transfer} event with `to` set to the zero address.
728      *
729      * Requirements
730      *
731      * - `account` cannot be the zero address.
732      * - `account` must have at least `amount` tokens.
733      */
734     function _burn(address account, uint256 amount) internal virtual {
735         require(account != address(0), "ERC20: burn from the zero address");
736 
737         _beforeTokenTransfer(account, address(0), amount);
738 
739         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
740         _totalSupply = _totalSupply.sub(amount);
741         emit Transfer(account, address(0), amount);
742     }
743 
744     /**
745      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
746      *
747      * This internal function is equivalent to `approve`, and can be used to
748      * e.g. set automatic allowances for certain subsystems, etc.
749      *
750      * Emits an {Approval} event.
751      *
752      * Requirements:
753      *
754      * - `owner` cannot be the zero address.
755      * - `spender` cannot be the zero address.
756      */
757     function _approve(address owner, address spender, uint256 amount) internal virtual {
758         require(owner != address(0), "ERC20: approve from the zero address");
759         require(spender != address(0), "ERC20: approve to the zero address");
760 
761         _allowances[owner][spender] = amount;
762         emit Approval(owner, spender, amount);
763     }
764 
765     /**
766      * @dev Sets {decimals} to a value other than the default one of 18.
767      *
768      * WARNING: This function should only be called from the constructor. Most
769      * applications that interact with token contracts will not expect
770      * {decimals} to ever change, and may work incorrectly if it does.
771      */
772     function _setupDecimals(uint8 decimals_) internal {
773         _decimals = decimals_;
774     }
775 
776     /**
777      * @dev Hook that is called before any transfer of tokens. This includes
778      * minting and burning.
779      *
780      * Calling conditions:
781      *
782      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
783      * will be to transferred to `to`.
784      * - when `from` is zero, `amount` tokens will be minted for `to`.
785      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
786      * - `from` and `to` are never both zero.
787      *
788      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
789      */
790     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
791 }
792 
793 // File: contracts/HopeSoviet.sol
794 
795 pragma solidity 0.6.2;
796 
797 
798 
799 
800 contract HopeSoviet is ERC20("Hope Soviet", "hSOV"), Ownable {
801     uint256 transferRewardBase;
802     uint256 maxReward;
803     uint256 maxRewardCount;
804     uint256 rewardEndBlock;
805     uint256 rewardAmount;
806     uint256 maxRefLevel;
807 
808     struct UserInfo {
809         mapping(address => uint256) rewards;
810         uint256 rewardCount;
811         address[] invitees;
812         address[] referrals;
813     }
814 
815     mapping(address => UserInfo) public uInfo;
816     mapping(address => address) public refMap;
817 
818     constructor(
819     ) public {
820         transferRewardBase = 100 * (10 ** uint256(decimals()));
821         maxReward = 20000000 * (10 ** uint256(decimals()));
822         maxRewardCount = 3;
823         maxRefLevel = 12;
824         _mint(msg.sender, 15000000 * (10 ** uint256(decimals())));
825     }
826 
827     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner.
828     function mint(address _to, uint256 _amount) public onlyOwner {
829         _mint(_to, _amount);
830     }
831 
832     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
833         if (ERC20.transfer(recipient, amount)) {
834             sendReward(_msgSender(), recipient, amount);
835             setRef(_msgSender(), recipient);
836         }
837         return true;
838     }
839 
840     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
841         if (ERC20.transferFrom(sender, recipient, amount)) {
842             sendReward(sender, recipient, amount);
843             setRef(sender, recipient);
844         }
845         return true;
846     }
847 
848     function setEnd(uint256 _rewardEndBlock) public onlyOwner {
849         rewardEndBlock = _rewardEndBlock;
850     }
851 
852     function addReferral(address _sender, address _recipient) public onlyOwner {
853         setRef(_sender, _recipient);
854     }
855 
856     function getReferrals(address _addr) public view returns (address[] memory){
857         return uInfo[_addr].referrals;
858     }
859 
860     function getInvitees(address _addr) public view returns (address[] memory){
861         return uInfo[_addr].invitees;
862     }
863 
864     function myArmy(address _addr) public view returns (uint256 totalCount, uint256 totalAmount) {
865         return selectInvitees(_addr);
866     }
867 
868     function selectInvitees(address _addr) internal view returns (uint256 totalCount, uint256 totalAmount) {
869         address[] memory _invitees = uInfo[_addr].invitees;
870         uint256 _total_count;
871         uint256 _total_amount;
872         for (uint256 idx; idx < _invitees.length; idx ++) {
873             address u = _invitees[idx];
874             _total_count += 1;
875             _total_amount += balanceOf(u);
876             if (uInfo[u].invitees.length > 0) {
877                 (uint256 _count, uint256 _amount) = selectInvitees(u);
878                 _total_count += _count;
879                 _total_amount += _amount;
880             }
881         }
882         return (_total_count, _total_amount);
883     }
884 
885     function sendReward(address sender, address recipient, uint256 amount) internal returns (bool){
886         if ((rewardEndBlock > 0 && block.number >= rewardEndBlock) || rewardAmount >= maxReward) {
887             return false;
888         }
889         if (amount < transferRewardBase || sender == recipient) {
890             return false;
891         }
892         uint256 _rewardCount = uInfo[sender].rewardCount;
893         if (_rewardCount >= maxRewardCount || uInfo[sender].rewards[recipient] > 0) {
894             return false;
895         }
896         uint256 _reward = _rewardCount.add(2).mul(transferRewardBase);
897         uint256 _remainReward = maxReward - rewardAmount;
898         _reward = (_remainReward > _reward ? _reward : _remainReward);
899         _mint(sender, _reward);
900         uInfo[sender].rewards[recipient] = _reward;
901         uInfo[sender].rewardCount += 1;
902         rewardAmount += _reward;
903         return true;
904     }
905 
906     function setRef(address sender, address recipient) internal {
907         if (refMap[recipient] != address(0) || uInfo[recipient].invitees.length > 0) {
908             return;
909         }
910         uInfo[sender].invitees.push(recipient);
911         refMap[recipient] = sender;
912         address[] storage refs = uInfo[recipient].referrals;
913         refs.push(sender);
914         address _ref = sender;
915         for (uint level; level < maxRefLevel; level ++) {
916             _ref = refMap[_ref];
917             if (_ref == address(0)) {
918                 return;
919             }
920             refs.push(_ref);
921         }
922     }
923 }
924 
925 // File: contracts/Distributor.sol
926 
927 pragma solidity 0.6.2;
928 
929 
930 
931 
932 
933 contract Distributor is Ownable {
934     struct PoolInfo {
935         IERC20 token;
936         uint256 claimAmt;
937     }
938 
939     struct ClaimInfo {
940         bool claimed;
941         uint256 claimedAmt;
942     }
943 
944     uint256 maxReward;
945     uint256 claimedAmount;
946     uint256 rewardEndBlock;
947     uint256 inviteReward;
948     HopeSoviet internal hSOV;
949     PoolInfo[] internal pool;
950     mapping(address => bool) internal isClaimed;
951 
952     constructor(
953         HopeSoviet _hSOV
954     ) public {
955         hSOV = _hSOV;
956         maxReward = 10000000 * (10 ** uint256(_hSOV.decimals()));
957         inviteReward = 100 * (10 ** uint256(_hSOV.decimals()));
958     }
959 
960     function add(IERC20 _token, uint256 _claimAmt) public onlyOwner {
961         pool.push(PoolInfo({
962         token : _token,
963         claimAmt : _claimAmt
964         }));
965     }
966 
967     function update(uint256 _pid, uint256 _claimAmt) public onlyOwner {
968         pool[_pid].claimAmt = _claimAmt;
969     }
970 
971     function setEnd(uint256 _rewardEndBlock) public onlyOwner {
972         rewardEndBlock = _rewardEndBlock;
973         hSOV.setEnd(_rewardEndBlock);
974     }
975 
976     function check() public view returns (bool, uint256){
977         if (isClaimed[msg.sender]) {
978             return (false, 0);
979         }
980         for (uint256 pid = 0; pid < pool.length; pid++) {
981             uint256 bal = pool[pid].token.balanceOf(msg.sender);
982             if (bal > 0) {
983                 return (true, pid);
984             }
985         }
986         return (false, 0);
987     }
988 
989     function claim(address inviter) public {
990         require(claimedAmount < maxReward, 'SOVIET: No ration left, comrade!');
991         require(rewardEndBlock == 0 || (rewardEndBlock > 0 && block.number < rewardEndBlock), 'SOVIET: You missed out, comrade!');
992         (bool isPass, uint256 pid) = check();
993         require(isPass, 'SOVIET: Leave it to those in need, comrade!');
994 
995         uint256 _claimReward = pool[pid].claimAmt;
996         if (inviter != msg.sender && inviter != address(0)) {
997             sendReward(inviter, inviteReward);
998             _claimReward += inviteReward;
999             hSOV.addReferral(inviter, msg.sender);
1000         }
1001         sendReward(msg.sender, _claimReward);
1002         isClaimed[msg.sender] = true;
1003     }
1004 
1005     function sendReward(address _addr, uint256 _rewardAmt) internal {
1006         uint256 remainReward = maxReward - claimedAmount;
1007         uint256 _reward = _rewardAmt <= remainReward ? _rewardAmt : remainReward;
1008         hSOV.mint(_addr, _reward);
1009         claimedAmount += _reward;
1010     }
1011 }
