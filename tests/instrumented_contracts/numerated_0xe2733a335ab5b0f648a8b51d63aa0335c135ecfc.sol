1 // Sources flattened with hardhat v2.8.2 https://hardhat.org
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
31 // File @openzeppelin/contracts/access/Ownable.sol@v3.2.0
32 
33 pragma solidity ^0.6.0;
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * By default, the owner account will be the one that deploys the contract. This
41  * can later be changed with {transferOwnership}.
42  *
43  * This module is used through inheritance. It will make available the modifier
44  * `onlyOwner`, which can be applied to your functions to restrict their use to
45  * the owner.
46  */
47 contract Ownable is Context {
48     address private _owner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     /**
53      * @dev Initializes the contract setting the deployer as the initial owner.
54      */
55     constructor () internal {
56         address msgSender = _msgSender();
57         _owner = msgSender;
58         emit OwnershipTransferred(address(0), msgSender);
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(_owner == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public virtual onlyOwner {
84         emit OwnershipTransferred(_owner, address(0));
85         _owner = address(0);
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         emit OwnershipTransferred(_owner, newOwner);
95         _owner = newOwner;
96     }
97 }
98 
99 
100 // File contracts/TeleportAdmin.sol
101 
102 pragma solidity 0.6.12;
103 
104 /**
105  * @dev Contract module which provides a basic access control mechanism, where
106  * there are multiple accounts (admins) that can be granted exclusive access to
107  * specific functions.
108  *
109  * This module is used through inheritance. It will make available the modifier
110  * `consumeAuthorization`, which can be applied to your functions to restrict
111  * their use to the admins.
112  */
113 contract TeleportAdmin is Ownable {
114   // Marks that the contract is frozen or unfrozen (safety kill-switch)
115   bool private _isFrozen;
116 
117   mapping(address => uint256) private _allowedAmount;
118 
119   event AdminUpdated(address indexed account, uint256 allowedAmount);
120 
121   // Modifiers
122 
123   /**
124     * @dev Throw if contract is currently frozen.
125     */
126   modifier notFrozen() {
127     require(
128       !_isFrozen,
129       "TeleportAdmin: contract is frozen by owner"
130     );
131 
132     _;
133   }
134 
135   /**
136     * @dev Throw if caller does not have sufficient authorized amount.
137     */
138   modifier consumeAuthorization(uint256 amount) {
139     address sender = _msgSender();
140     require(
141       allowedAmount(sender) >= amount,
142       "TeleportAdmin: caller does not have sufficient authorization"
143     );
144 
145     _;
146 
147     // reduce authorization amount. Underflow cannot occur because we have
148     // already checked that admin has sufficient allowed amount.
149     _allowedAmount[sender] -= amount;
150     emit AdminUpdated(sender, _allowedAmount[sender]);
151   }
152 
153   /**
154     * @dev Checks the authorized amount of an admin account.
155     */
156   function allowedAmount(address account)
157     public
158     view
159     returns (uint256)
160   {
161     return _allowedAmount[account];
162   }
163 
164   /**
165     * @dev Returns if the contract is currently frozen.
166     */
167   function isFrozen()
168     public
169     view
170     returns (bool)
171   {
172     return _isFrozen;
173   }
174 
175   /**
176     * @dev Owner freezes the contract.
177     */
178   function freeze()
179     public
180     onlyOwner
181   {
182     _isFrozen = true;
183   }
184 
185   /**
186     * @dev Owner unfreezes the contract.
187     */
188   function unfreeze()
189     public
190     onlyOwner
191   {
192     _isFrozen = false;
193   }
194 
195   /**
196     * @dev Updates the admin status of an account.
197     * Can only be called by the current owner.
198     */
199   function updateAdmin(address account, uint256 allowedAmount)
200     public
201     virtual
202     onlyOwner
203   {
204     emit AdminUpdated(account, allowedAmount);
205     _allowedAmount[account] = allowedAmount;
206   }
207 
208   /**
209     * @dev Overrides the inherited method from Ownable.
210     * Disable ownership resounce.
211     */
212   function renounceOwnership()
213     public
214     override
215     onlyOwner
216   {
217     revert("TeleportAdmin: ownership cannot be renounced");
218   }
219 }
220 
221 
222 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.2.0
223 
224 pragma solidity ^0.6.0;
225 
226 /**
227  * @dev Interface of the ERC20 standard as defined in the EIP.
228  */
229 interface IERC20 {
230     /**
231      * @dev Returns the amount of tokens in existence.
232      */
233     function totalSupply() external view returns (uint256);
234 
235     /**
236      * @dev Returns the amount of tokens owned by `account`.
237      */
238     function balanceOf(address account) external view returns (uint256);
239 
240     /**
241      * @dev Moves `amount` tokens from the caller's account to `recipient`.
242      *
243      * Returns a boolean value indicating whether the operation succeeded.
244      *
245      * Emits a {Transfer} event.
246      */
247     function transfer(address recipient, uint256 amount) external returns (bool);
248 
249     /**
250      * @dev Returns the remaining number of tokens that `spender` will be
251      * allowed to spend on behalf of `owner` through {transferFrom}. This is
252      * zero by default.
253      *
254      * This value changes when {approve} or {transferFrom} are called.
255      */
256     function allowance(address owner, address spender) external view returns (uint256);
257 
258     /**
259      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
260      *
261      * Returns a boolean value indicating whether the operation succeeded.
262      *
263      * IMPORTANT: Beware that changing an allowance with this method brings the risk
264      * that someone may use both the old and the new allowance by unfortunate
265      * transaction ordering. One possible solution to mitigate this race
266      * condition is to first reduce the spender's allowance to 0 and set the
267      * desired value afterwards:
268      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
269      *
270      * Emits an {Approval} event.
271      */
272     function approve(address spender, uint256 amount) external returns (bool);
273 
274     /**
275      * @dev Moves `amount` tokens from `sender` to `recipient` using the
276      * allowance mechanism. `amount` is then deducted from the caller's
277      * allowance.
278      *
279      * Returns a boolean value indicating whether the operation succeeded.
280      *
281      * Emits a {Transfer} event.
282      */
283     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
284 
285     /**
286      * @dev Emitted when `value` tokens are moved from one account (`from`) to
287      * another (`to`).
288      *
289      * Note that `value` may be zero.
290      */
291     event Transfer(address indexed from, address indexed to, uint256 value);
292 
293     /**
294      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
295      * a call to {approve}. `value` is the new allowance.
296      */
297     event Approval(address indexed owner, address indexed spender, uint256 value);
298 }
299 
300 
301 // File @openzeppelin/contracts/math/SafeMath.sol@v3.2.0
302 
303 pragma solidity ^0.6.0;
304 
305 /**
306  * @dev Wrappers over Solidity's arithmetic operations with added overflow
307  * checks.
308  *
309  * Arithmetic operations in Solidity wrap on overflow. This can easily result
310  * in bugs, because programmers usually assume that an overflow raises an
311  * error, which is the standard behavior in high level programming languages.
312  * `SafeMath` restores this intuition by reverting the transaction when an
313  * operation overflows.
314  *
315  * Using this library instead of the unchecked operations eliminates an entire
316  * class of bugs, so it's recommended to use it always.
317  */
318 library SafeMath {
319     /**
320      * @dev Returns the addition of two unsigned integers, reverting on
321      * overflow.
322      *
323      * Counterpart to Solidity's `+` operator.
324      *
325      * Requirements:
326      *
327      * - Addition cannot overflow.
328      */
329     function add(uint256 a, uint256 b) internal pure returns (uint256) {
330         uint256 c = a + b;
331         require(c >= a, "SafeMath: addition overflow");
332 
333         return c;
334     }
335 
336     /**
337      * @dev Returns the subtraction of two unsigned integers, reverting on
338      * overflow (when the result is negative).
339      *
340      * Counterpart to Solidity's `-` operator.
341      *
342      * Requirements:
343      *
344      * - Subtraction cannot overflow.
345      */
346     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
347         return sub(a, b, "SafeMath: subtraction overflow");
348     }
349 
350     /**
351      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
352      * overflow (when the result is negative).
353      *
354      * Counterpart to Solidity's `-` operator.
355      *
356      * Requirements:
357      *
358      * - Subtraction cannot overflow.
359      */
360     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
361         require(b <= a, errorMessage);
362         uint256 c = a - b;
363 
364         return c;
365     }
366 
367     /**
368      * @dev Returns the multiplication of two unsigned integers, reverting on
369      * overflow.
370      *
371      * Counterpart to Solidity's `*` operator.
372      *
373      * Requirements:
374      *
375      * - Multiplication cannot overflow.
376      */
377     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
378         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
379         // benefit is lost if 'b' is also tested.
380         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
381         if (a == 0) {
382             return 0;
383         }
384 
385         uint256 c = a * b;
386         require(c / a == b, "SafeMath: multiplication overflow");
387 
388         return c;
389     }
390 
391     /**
392      * @dev Returns the integer division of two unsigned integers. Reverts on
393      * division by zero. The result is rounded towards zero.
394      *
395      * Counterpart to Solidity's `/` operator. Note: this function uses a
396      * `revert` opcode (which leaves remaining gas untouched) while Solidity
397      * uses an invalid opcode to revert (consuming all remaining gas).
398      *
399      * Requirements:
400      *
401      * - The divisor cannot be zero.
402      */
403     function div(uint256 a, uint256 b) internal pure returns (uint256) {
404         return div(a, b, "SafeMath: division by zero");
405     }
406 
407     /**
408      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
409      * division by zero. The result is rounded towards zero.
410      *
411      * Counterpart to Solidity's `/` operator. Note: this function uses a
412      * `revert` opcode (which leaves remaining gas untouched) while Solidity
413      * uses an invalid opcode to revert (consuming all remaining gas).
414      *
415      * Requirements:
416      *
417      * - The divisor cannot be zero.
418      */
419     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
420         require(b > 0, errorMessage);
421         uint256 c = a / b;
422         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
423 
424         return c;
425     }
426 
427     /**
428      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
429      * Reverts when dividing by zero.
430      *
431      * Counterpart to Solidity's `%` operator. This function uses a `revert`
432      * opcode (which leaves remaining gas untouched) while Solidity uses an
433      * invalid opcode to revert (consuming all remaining gas).
434      *
435      * Requirements:
436      *
437      * - The divisor cannot be zero.
438      */
439     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
440         return mod(a, b, "SafeMath: modulo by zero");
441     }
442 
443     /**
444      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
445      * Reverts with custom message when dividing by zero.
446      *
447      * Counterpart to Solidity's `%` operator. This function uses a `revert`
448      * opcode (which leaves remaining gas untouched) while Solidity uses an
449      * invalid opcode to revert (consuming all remaining gas).
450      *
451      * Requirements:
452      *
453      * - The divisor cannot be zero.
454      */
455     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
456         require(b != 0, errorMessage);
457         return a % b;
458     }
459 }
460 
461 
462 // File @openzeppelin/contracts/utils/Address.sol@v3.2.0
463 
464 pragma solidity ^0.6.2;
465 
466 /**
467  * @dev Collection of functions related to the address type
468  */
469 library Address {
470     /**
471      * @dev Returns true if `account` is a contract.
472      *
473      * [IMPORTANT]
474      * ====
475      * It is unsafe to assume that an address for which this function returns
476      * false is an externally-owned account (EOA) and not a contract.
477      *
478      * Among others, `isContract` will return false for the following
479      * types of addresses:
480      *
481      *  - an externally-owned account
482      *  - a contract in construction
483      *  - an address where a contract will be created
484      *  - an address where a contract lived, but was destroyed
485      * ====
486      */
487     function isContract(address account) internal view returns (bool) {
488         // This method relies in extcodesize, which returns 0 for contracts in
489         // construction, since the code is only stored at the end of the
490         // constructor execution.
491 
492         uint256 size;
493         // solhint-disable-next-line no-inline-assembly
494         assembly { size := extcodesize(account) }
495         return size > 0;
496     }
497 
498     /**
499      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
500      * `recipient`, forwarding all available gas and reverting on errors.
501      *
502      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
503      * of certain opcodes, possibly making contracts go over the 2300 gas limit
504      * imposed by `transfer`, making them unable to receive funds via
505      * `transfer`. {sendValue} removes this limitation.
506      *
507      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
508      *
509      * IMPORTANT: because control is transferred to `recipient`, care must be
510      * taken to not create reentrancy vulnerabilities. Consider using
511      * {ReentrancyGuard} or the
512      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
513      */
514     function sendValue(address payable recipient, uint256 amount) internal {
515         require(address(this).balance >= amount, "Address: insufficient balance");
516 
517         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
518         (bool success, ) = recipient.call{ value: amount }("");
519         require(success, "Address: unable to send value, recipient may have reverted");
520     }
521 
522     /**
523      * @dev Performs a Solidity function call using a low level `call`. A
524      * plain`call` is an unsafe replacement for a function call: use this
525      * function instead.
526      *
527      * If `target` reverts with a revert reason, it is bubbled up by this
528      * function (like regular Solidity function calls).
529      *
530      * Returns the raw returned data. To convert to the expected return value,
531      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
532      *
533      * Requirements:
534      *
535      * - `target` must be a contract.
536      * - calling `target` with `data` must not revert.
537      *
538      * _Available since v3.1._
539      */
540     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
541       return functionCall(target, data, "Address: low-level call failed");
542     }
543 
544     /**
545      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
546      * `errorMessage` as a fallback revert reason when `target` reverts.
547      *
548      * _Available since v3.1._
549      */
550     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
551         return _functionCallWithValue(target, data, 0, errorMessage);
552     }
553 
554     /**
555      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
556      * but also transferring `value` wei to `target`.
557      *
558      * Requirements:
559      *
560      * - the calling contract must have an ETH balance of at least `value`.
561      * - the called Solidity function must be `payable`.
562      *
563      * _Available since v3.1._
564      */
565     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
566         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
567     }
568 
569     /**
570      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
571      * with `errorMessage` as a fallback revert reason when `target` reverts.
572      *
573      * _Available since v3.1._
574      */
575     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
576         require(address(this).balance >= value, "Address: insufficient balance for call");
577         return _functionCallWithValue(target, data, value, errorMessage);
578     }
579 
580     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
581         require(isContract(target), "Address: call to non-contract");
582 
583         // solhint-disable-next-line avoid-low-level-calls
584         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
585         if (success) {
586             return returndata;
587         } else {
588             // Look for revert reason and bubble it up if present
589             if (returndata.length > 0) {
590                 // The easiest way to bubble the revert reason is using memory via assembly
591 
592                 // solhint-disable-next-line no-inline-assembly
593                 assembly {
594                     let returndata_size := mload(returndata)
595                     revert(add(32, returndata), returndata_size)
596                 }
597             } else {
598                 revert(errorMessage);
599             }
600         }
601     }
602 }
603 
604 
605 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.2.0
606 
607 pragma solidity ^0.6.0;
608 
609 
610 
611 
612 /**
613  * @dev Implementation of the {IERC20} interface.
614  *
615  * This implementation is agnostic to the way tokens are created. This means
616  * that a supply mechanism has to be added in a derived contract using {_mint}.
617  * For a generic mechanism see {ERC20PresetMinterPauser}.
618  *
619  * TIP: For a detailed writeup see our guide
620  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
621  * to implement supply mechanisms].
622  *
623  * We have followed general OpenZeppelin guidelines: functions revert instead
624  * of returning `false` on failure. This behavior is nonetheless conventional
625  * and does not conflict with the expectations of ERC20 applications.
626  *
627  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
628  * This allows applications to reconstruct the allowance for all accounts just
629  * by listening to said events. Other implementations of the EIP may not emit
630  * these events, as it isn't required by the specification.
631  *
632  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
633  * functions have been added to mitigate the well-known issues around setting
634  * allowances. See {IERC20-approve}.
635  */
636 contract ERC20 is Context, IERC20 {
637     using SafeMath for uint256;
638     using Address for address;
639 
640     mapping (address => uint256) private _balances;
641 
642     mapping (address => mapping (address => uint256)) private _allowances;
643 
644     uint256 private _totalSupply;
645 
646     string private _name;
647     string private _symbol;
648     uint8 private _decimals;
649 
650     /**
651      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
652      * a default value of 18.
653      *
654      * To select a different value for {decimals}, use {_setupDecimals}.
655      *
656      * All three of these values are immutable: they can only be set once during
657      * construction.
658      */
659     constructor (string memory name, string memory symbol) public {
660         _name = name;
661         _symbol = symbol;
662         _decimals = 18;
663     }
664 
665     /**
666      * @dev Returns the name of the token.
667      */
668     function name() public view returns (string memory) {
669         return _name;
670     }
671 
672     /**
673      * @dev Returns the symbol of the token, usually a shorter version of the
674      * name.
675      */
676     function symbol() public view returns (string memory) {
677         return _symbol;
678     }
679 
680     /**
681      * @dev Returns the number of decimals used to get its user representation.
682      * For example, if `decimals` equals `2`, a balance of `505` tokens should
683      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
684      *
685      * Tokens usually opt for a value of 18, imitating the relationship between
686      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
687      * called.
688      *
689      * NOTE: This information is only used for _display_ purposes: it in
690      * no way affects any of the arithmetic of the contract, including
691      * {IERC20-balanceOf} and {IERC20-transfer}.
692      */
693     function decimals() public view returns (uint8) {
694         return _decimals;
695     }
696 
697     /**
698      * @dev See {IERC20-totalSupply}.
699      */
700     function totalSupply() public view override returns (uint256) {
701         return _totalSupply;
702     }
703 
704     /**
705      * @dev See {IERC20-balanceOf}.
706      */
707     function balanceOf(address account) public view override returns (uint256) {
708         return _balances[account];
709     }
710 
711     /**
712      * @dev See {IERC20-transfer}.
713      *
714      * Requirements:
715      *
716      * - `recipient` cannot be the zero address.
717      * - the caller must have a balance of at least `amount`.
718      */
719     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
720         _transfer(_msgSender(), recipient, amount);
721         return true;
722     }
723 
724     /**
725      * @dev See {IERC20-allowance}.
726      */
727     function allowance(address owner, address spender) public view virtual override returns (uint256) {
728         return _allowances[owner][spender];
729     }
730 
731     /**
732      * @dev See {IERC20-approve}.
733      *
734      * Requirements:
735      *
736      * - `spender` cannot be the zero address.
737      */
738     function approve(address spender, uint256 amount) public virtual override returns (bool) {
739         _approve(_msgSender(), spender, amount);
740         return true;
741     }
742 
743     /**
744      * @dev See {IERC20-transferFrom}.
745      *
746      * Emits an {Approval} event indicating the updated allowance. This is not
747      * required by the EIP. See the note at the beginning of {ERC20};
748      *
749      * Requirements:
750      * - `sender` and `recipient` cannot be the zero address.
751      * - `sender` must have a balance of at least `amount`.
752      * - the caller must have allowance for ``sender``'s tokens of at least
753      * `amount`.
754      */
755     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
756         _transfer(sender, recipient, amount);
757         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
758         return true;
759     }
760 
761     /**
762      * @dev Atomically increases the allowance granted to `spender` by the caller.
763      *
764      * This is an alternative to {approve} that can be used as a mitigation for
765      * problems described in {IERC20-approve}.
766      *
767      * Emits an {Approval} event indicating the updated allowance.
768      *
769      * Requirements:
770      *
771      * - `spender` cannot be the zero address.
772      */
773     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
774         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
775         return true;
776     }
777 
778     /**
779      * @dev Atomically decreases the allowance granted to `spender` by the caller.
780      *
781      * This is an alternative to {approve} that can be used as a mitigation for
782      * problems described in {IERC20-approve}.
783      *
784      * Emits an {Approval} event indicating the updated allowance.
785      *
786      * Requirements:
787      *
788      * - `spender` cannot be the zero address.
789      * - `spender` must have allowance for the caller of at least
790      * `subtractedValue`.
791      */
792     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
793         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
794         return true;
795     }
796 
797     /**
798      * @dev Moves tokens `amount` from `sender` to `recipient`.
799      *
800      * This is internal function is equivalent to {transfer}, and can be used to
801      * e.g. implement automatic token fees, slashing mechanisms, etc.
802      *
803      * Emits a {Transfer} event.
804      *
805      * Requirements:
806      *
807      * - `sender` cannot be the zero address.
808      * - `recipient` cannot be the zero address.
809      * - `sender` must have a balance of at least `amount`.
810      */
811     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
812         require(sender != address(0), "ERC20: transfer from the zero address");
813         require(recipient != address(0), "ERC20: transfer to the zero address");
814 
815         _beforeTokenTransfer(sender, recipient, amount);
816 
817         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
818         _balances[recipient] = _balances[recipient].add(amount);
819         emit Transfer(sender, recipient, amount);
820     }
821 
822     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
823      * the total supply.
824      *
825      * Emits a {Transfer} event with `from` set to the zero address.
826      *
827      * Requirements
828      *
829      * - `to` cannot be the zero address.
830      */
831     function _mint(address account, uint256 amount) internal virtual {
832         require(account != address(0), "ERC20: mint to the zero address");
833 
834         _beforeTokenTransfer(address(0), account, amount);
835 
836         _totalSupply = _totalSupply.add(amount);
837         _balances[account] = _balances[account].add(amount);
838         emit Transfer(address(0), account, amount);
839     }
840 
841     /**
842      * @dev Destroys `amount` tokens from `account`, reducing the
843      * total supply.
844      *
845      * Emits a {Transfer} event with `to` set to the zero address.
846      *
847      * Requirements
848      *
849      * - `account` cannot be the zero address.
850      * - `account` must have at least `amount` tokens.
851      */
852     function _burn(address account, uint256 amount) internal virtual {
853         require(account != address(0), "ERC20: burn from the zero address");
854 
855         _beforeTokenTransfer(account, address(0), amount);
856 
857         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
858         _totalSupply = _totalSupply.sub(amount);
859         emit Transfer(account, address(0), amount);
860     }
861 
862     /**
863      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
864      *
865      * This internal function is equivalent to `approve`, and can be used to
866      * e.g. set automatic allowances for certain subsystems, etc.
867      *
868      * Emits an {Approval} event.
869      *
870      * Requirements:
871      *
872      * - `owner` cannot be the zero address.
873      * - `spender` cannot be the zero address.
874      */
875     function _approve(address owner, address spender, uint256 amount) internal virtual {
876         require(owner != address(0), "ERC20: approve from the zero address");
877         require(spender != address(0), "ERC20: approve to the zero address");
878 
879         _allowances[owner][spender] = amount;
880         emit Approval(owner, spender, amount);
881     }
882 
883     /**
884      * @dev Sets {decimals} to a value other than the default one of 18.
885      *
886      * WARNING: This function should only be called from the constructor. Most
887      * applications that interact with token contracts will not expect
888      * {decimals} to ever change, and may work incorrectly if it does.
889      */
890     function _setupDecimals(uint8 decimals_) internal {
891         _decimals = decimals_;
892     }
893 
894     /**
895      * @dev Hook that is called before any transfer of tokens. This includes
896      * minting and burning.
897      *
898      * Calling conditions:
899      *
900      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
901      * will be to transferred to `to`.
902      * - when `from` is zero, `amount` tokens will be minted for `to`.
903      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
904      * - `from` and `to` are never both zero.
905      *
906      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
907      */
908     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
909 }
910 
911 
912 // File contracts/TeleportCustody.sol
913 
914 pragma solidity 0.6.12;
915 
916 
917 /**
918  * @dev Implementation of the TeleportCustody contract.
919  *
920  * There are two priviledged roles for the contract: "owner" and "admin".
921  *
922  * Owner: Has the ultimate control of the contract and the funds stored inside the
923  *        contract. Including:
924  *     1) "freeze" and "unfreeze" the contract: when the TeleportCustody is frozen,
925  *        all deposits and withdrawals with the TeleportCustody is disabled. This
926  *        should only happen when a major security risk is spotted or if admin access
927  *        is comprimised.
928  *     2) assign "admins": owner has the authority to grant "unlock" permission to
929  *        "admins" and set proper "unlock limit" for each "admin".
930  *
931  * Admin: Has the authority to "unlock" specific amount to tokens to receivers.
932  */
933 contract TeleportCustody is TeleportAdmin {
934   // wFLOW
935   ERC20 internal _tokenContract = ERC20(0x5c147e74D63B1D31AA3Fd78Eb229B65161983B2b);
936 
937   // Records that an unlock transaction has been executed
938   mapping(bytes32 => bool) internal _unlocked;
939 
940   // Emmitted when user locks token and initiates teleport
941   event Locked(uint256 amount, bytes8 indexed flowAddress, address indexed ethereumAddress);
942 
943   // Emmitted when teleport completes and token gets unlocked
944   event Unlocked(uint256 amount, address indexed ethereumAddress, bytes32 indexed flowHash);
945 
946   /**
947     * @dev User locks token and initiates teleport request.
948     */
949   function lock(uint256 amount, bytes8 flowAddress)
950     public
951     notFrozen
952   {
953     address sender = _msgSender();
954 
955     bool result = _tokenContract.transferFrom(sender, address(this), amount);
956     require(result, "TeleportCustody: transferFrom returns falsy value");
957 
958     emit Locked(amount, flowAddress, sender);
959   }
960 
961   // Admin methods
962 
963   /**
964     * @dev TeleportAdmin unlocks token upon receiving teleport request from Flow.
965     */
966   function unlock(uint256 amount, address ethereumAddress, bytes32 flowHash)
967     public
968     notFrozen
969     consumeAuthorization(amount)
970   {
971     _unlock(amount, ethereumAddress, flowHash);
972   }
973 
974   // Owner methods
975 
976   /**
977     * @dev Owner unlocks token upon receiving teleport request from Flow.
978     * There is no unlock limit for owner.
979     */
980   function unlockByOwner(uint256 amount, address ethereumAddress, bytes32 flowHash)
981     public
982     notFrozen
983     onlyOwner
984   {
985     _unlock(amount, ethereumAddress, flowHash);
986   }
987 
988   // Internal methods
989 
990   /**
991     * @dev Internal function for processing unlock requests.
992     *
993     * There is no way TeleportCustody can check the validity of the target address
994     * beforehand so user and admin should always make sure the provided information
995     * is correct.
996     */
997   function _unlock(uint256 amount, address ethereumAddress, bytes32 flowHash)
998     internal
999   {
1000     require(ethereumAddress != address(0), "TeleportCustody: ethereumAddress is the zero address");
1001     require(!_unlocked[flowHash], "TeleportCustody: same unlock hash has been executed");
1002 
1003     _unlocked[flowHash] = true;
1004 
1005     bool result = _tokenContract.transfer(ethereumAddress, amount);
1006     require(result, "TeleportCustody: transfer returns falsy value");
1007 
1008     emit Unlocked(amount, ethereumAddress, flowHash);
1009   }
1010 }