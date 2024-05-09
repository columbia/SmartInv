1 // ETHY is a deflationary currency, designed to reward holders, pump price and discourage bots.
2 // ETHY is designed to be managed by the ETHYVault.
3 
4 // Partial License: MIT
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
29 
30 // Partial License: MIT
31 
32 pragma solidity ^0.6.0;
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
108 
109 // Partial License: MIT
110 
111 pragma solidity ^0.6.0;
112 
113 /**
114  * @dev Wrappers over Solidity's arithmetic operations with added overflow
115  * checks.
116  *
117  * Arithmetic operations in Solidity wrap on overflow. This can easily result
118  * in bugs, because programmers usually assume that an overflow raises an
119  * error, which is the standard behavior in high level programming languages.
120  * `SafeMath` restores this intuition by reverting the transaction when an
121  * operation overflows.
122  *
123  * Using this library instead of the unchecked operations eliminates an entire
124  * class of bugs, so it's recommended to use it always.
125  */
126 library SafeMath {
127     /**
128      * @dev Returns the addition of two unsigned integers, reverting on
129      * overflow.
130      *
131      * Counterpart to Solidity's `+` operator.
132      *
133      * Requirements:
134      *
135      * - Addition cannot overflow.
136      */
137     function add(uint256 a, uint256 b) internal pure returns (uint256) {
138         uint256 c = a + b;
139         require(c >= a, "SafeMath: addition overflow");
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      *
152      * - Subtraction cannot overflow.
153      */
154     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
155         return sub(a, b, "SafeMath: subtraction overflow");
156     }
157 
158     /**
159      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
160      * overflow (when the result is negative).
161      *
162      * Counterpart to Solidity's `-` operator.
163      *
164      * Requirements:
165      *
166      * - Subtraction cannot overflow.
167      */
168     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
169         require(b <= a, errorMessage);
170         uint256 c = a - b;
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the multiplication of two unsigned integers, reverting on
177      * overflow.
178      *
179      * Counterpart to Solidity's `*` operator.
180      *
181      * Requirements:
182      *
183      * - Multiplication cannot overflow.
184      */
185     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
186         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
187         // benefit is lost if 'b' is also tested.
188         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
189         if (a == 0) {
190             return 0;
191         }
192 
193         uint256 c = a * b;
194         require(c / a == b, "SafeMath: multiplication overflow");
195 
196         return c;
197     }
198 
199     /**
200      * @dev Returns the integer division of two unsigned integers. Reverts on
201      * division by zero. The result is rounded towards zero.
202      *
203      * Counterpart to Solidity's `/` operator. Note: this function uses a
204      * `revert` opcode (which leaves remaining gas untouched) while Solidity
205      * uses an invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      *
209      * - The divisor cannot be zero.
210      */
211     function div(uint256 a, uint256 b) internal pure returns (uint256) {
212         return div(a, b, "SafeMath: division by zero");
213     }
214 
215     /**
216      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
217      * division by zero. The result is rounded towards zero.
218      *
219      * Counterpart to Solidity's `/` operator. Note: this function uses a
220      * `revert` opcode (which leaves remaining gas untouched) while Solidity
221      * uses an invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
228         require(b > 0, errorMessage);
229         uint256 c = a / b;
230         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * Reverts when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      *
245      * - The divisor cannot be zero.
246      */
247     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
248         return mod(a, b, "SafeMath: modulo by zero");
249     }
250 
251     /**
252      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
253      * Reverts with custom message when dividing by zero.
254      *
255      * Counterpart to Solidity's `%` operator. This function uses a `revert`
256      * opcode (which leaves remaining gas untouched) while Solidity uses an
257      * invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      *
261      * - The divisor cannot be zero.
262      */
263     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264         require(b != 0, errorMessage);
265         return a % b;
266     }
267 }
268 
269 
270 // Partial License: MIT
271 
272 pragma solidity ^0.6.2;
273 
274 /**
275  * @dev Collection of functions related to the address type
276  */
277 library Address {
278     /**
279      * @dev Returns true if `account` is a contract.
280      *
281      * [IMPORTANT]
282      * ====
283      * It is unsafe to assume that an address for which this function returns
284      * false is an externally-owned account (EOA) and not a contract.
285      *
286      * Among others, `isContract` will return false for the following
287      * types of addresses:
288      *
289      *  - an externally-owned account
290      *  - a contract in construction
291      *  - an address where a contract will be created
292      *  - an address where a contract lived, but was destroyed
293      * ====
294      */
295     function isContract(address account) internal view returns (bool) {
296         // This method relies in extcodesize, which returns 0 for contracts in
297         // construction, since the code is only stored at the end of the
298         // constructor execution.
299 
300         uint256 size;
301         // solhint-disable-next-line no-inline-assembly
302         assembly { size := extcodesize(account) }
303         return size > 0;
304     }
305 
306     /**
307      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
308      * `recipient`, forwarding all available gas and reverting on errors.
309      *
310      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
311      * of certain opcodes, possibly making contracts go over the 2300 gas limit
312      * imposed by `transfer`, making them unable to receive funds via
313      * `transfer`. {sendValue} removes this limitation.
314      *
315      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
316      *
317      * IMPORTANT: because control is transferred to `recipient`, care must be
318      * taken to not create reentrancy vulnerabilities. Consider using
319      * {ReentrancyGuard} or the
320      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
321      */
322     function sendValue(address payable recipient, uint256 amount) internal {
323         require(address(this).balance >= amount, "Address: insufficient balance");
324 
325         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
326         (bool success, ) = recipient.call{ value: amount }("");
327         require(success, "Address: unable to send value, recipient may have reverted");
328     }
329 
330     /**
331      * @dev Performs a Solidity function call using a low level `call`. A
332      * plain`call` is an unsafe replacement for a function call: use this
333      * function instead.
334      *
335      * If `target` reverts with a revert reason, it is bubbled up by this
336      * function (like regular Solidity function calls).
337      *
338      * Returns the raw returned data. To convert to the expected return value,
339      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
340      *
341      * Requirements:
342      *
343      * - `target` must be a contract.
344      * - calling `target` with `data` must not revert.
345      *
346      * _Available since v3.1._
347      */
348     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
349       return functionCall(target, data, "Address: low-level call failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
354      * `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
359         return _functionCallWithValue(target, data, 0, errorMessage);
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
364      * but also transferring `value` wei to `target`.
365      *
366      * Requirements:
367      *
368      * - the calling contract must have an ETH balance of at least `value`.
369      * - the called Solidity function must be `payable`.
370      *
371      * _Available since v3.1._
372      */
373     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
374         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
379      * with `errorMessage` as a fallback revert reason when `target` reverts.
380      *
381      * _Available since v3.1._
382      */
383     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
384         require(address(this).balance >= value, "Address: insufficient balance for call");
385         return _functionCallWithValue(target, data, value, errorMessage);
386     }
387 
388     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
389         require(isContract(target), "Address: call to non-contract");
390 
391         // solhint-disable-next-line avoid-low-level-calls
392         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
393         if (success) {
394             return returndata;
395         } else {
396             // Look for revert reason and bubble it up if present
397             if (returndata.length > 0) {
398                 // The easiest way to bubble the revert reason is using memory via assembly
399 
400                 // solhint-disable-next-line no-inline-assembly
401                 assembly {
402                     let returndata_size := mload(returndata)
403                     revert(add(32, returndata), returndata_size)
404                 }
405             } else {
406                 revert(errorMessage);
407             }
408         }
409     }
410 }
411 
412 
413 // Partial License: MIT
414 
415 pragma solidity ^0.6.0;
416 
417 
418 /**
419  * @dev Contract module which provides a basic access control mechanism, where
420  * there is an account (an owner) that can be granted exclusive access to
421  * specific functions.
422  *
423  * By default, the owner account will be the one that deploys the contract. This
424  * can later be changed with {transferOwnership}.
425  *
426  * This module is used through inheritance. It will make available the modifier
427  * `onlyOwner`, which can be applied to your functions to restrict their use to
428  * the owner.
429  */
430 contract Ownable is Context {
431     address private _owner;
432 
433     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
434 
435     /**
436      * @dev Initializes the contract setting the deployer as the initial owner.
437      */
438     constructor () internal {
439         address msgSender = _msgSender();
440         _owner = msgSender;
441         emit OwnershipTransferred(address(0), msgSender);
442     }
443 
444     /**
445      * @dev Returns the address of the current owner.
446      */
447     function owner() public view returns (address) {
448         return _owner;
449     }
450 
451     /**
452      * @dev Throws if called by any account other than the owner.
453      */
454     modifier onlyOwner() {
455         require(_owner == _msgSender(), "Ownable: caller is not the owner");
456         _;
457     }
458 
459     /**
460      * @dev Leaves the contract without owner. It will not be possible to call
461      * `onlyOwner` functions anymore. Can only be called by the current owner.
462      *
463      * NOTE: Renouncing ownership will leave the contract without an owner,
464      * thereby removing any functionality that is only available to the owner.
465      */
466     function renounceOwnership() public virtual onlyOwner {
467         emit OwnershipTransferred(_owner, address(0));
468         _owner = address(0);
469     }
470 
471     /**
472      * @dev Transfers ownership of the contract to a new account (`newOwner`).
473      * Can only be called by the current owner.
474      */
475     function transferOwnership(address newOwner) public virtual onlyOwner {
476         require(newOwner != address(0), "Ownable: new owner is the zero address");
477         emit OwnershipTransferred(_owner, newOwner);
478         _owner = newOwner;
479     }
480 }
481 
482 
483 /**
484  * We have made some light modifications to the openzeppelin ER20
485  * located here "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol".
486  * Please read below for a quick overview of what has been changed:
487  *
488  * We have changed one function:
489  * - `_transfer` [line 293] to apply a transfer fee
490  *
491  * We have added 5 variables
492  * - `txFee` [line 78] the transaction fee to be applied.
493  * - `feeDistributor` [line 79] the contract address to recieve the fees.
494  * - `feelessSender` [line 82] map containing senders who will not have txFees applied.
495  * - `feelessReciever` [line 83] map containing recipients who will not have txFee applied.
496  * - `canWhitelist` [line 85] map containing recipients who will not have txFee applied.
497  *
498  * We have added 6 simple functions
499  * - `setFee` [line 235] set new transaction fee.
500  * - `setFeeDistributor` [line 240] sets new address to recieve txFees
501  * - `setFeelessSender` [line 245] to enable/disable fees for a given sender.
502  * - `setFeelessReciever` [line 251] to enable/disable fees for a given recipient.
503  * - `renounceWhitelist` [line 257] disables adding to whitelist forever.
504  * - `calculateAmountsAfterFee` [line 262] to caclulate the amounts after fees have been applied.
505  *
506  * We have updated this contract to implement the openzeppelin Ownable standard.
507  * We have updated the contract from 0.6.0 to 0.6.6;
508  */
509 
510 
511 // Partial License: MIT
512 
513 pragma solidity ^0.6.6;
514 
515 
516 
517 
518 
519 
520 
521 
522 /**
523  * @dev Implementation of the {IERC20} interface.
524  *
525  * This implementation is agnostic to the way tokens are created. This means
526  * that a supply mechanism has to be added in a derived contract using {_mint}.
527  * For a generic mechanism see {ERC20PresetMinterPauser}.
528  *
529  * TIP: For a detailed writeup see our guide
530  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
531  * to implement supply mechanisms].
532  *
533  * We have followed general OpenZeppelin guidelines: functions revert instead
534  * of returning `false` on failure. This behavior is nonetheless conventional
535  * and does not conflict with the expectations of ERC20 applications.
536  *
537  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
538  * This allows applications to reconstruct the allowance for all accounts just
539  * by listening to said events. Other implementations of the EIP may not emit
540  * these events, as it isn't required by the specification.
541  *
542  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
543  * functions have been added to mitigate the well-known issues around setting
544  * allowances. See {IERC20-approve}.
545  */
546 contract DeflationaryERC20 is Context, IERC20, Ownable {
547     using SafeMath for uint256;
548     using Address for address;
549 
550     mapping (address => uint256) private _balances;
551     mapping (address => mapping (address => uint256)) private _allowances;
552 
553     uint256 private _totalSupply;
554 
555     string private _name;
556     string private _symbol;
557     uint8 private _decimals;
558 
559     // Transaction Fees:
560     uint8 public txFee = 50; // artifical cap of 255 e.g. 25.5%
561     address public feeDistributor; // fees are sent to fee distributer
562 
563     // Fee Whitelist
564     mapping(address => bool) public feelessSender;
565     mapping(address => bool) public feelessReciever;
566     // if this equals false whitelist can nolonger be added to.
567     bool public canWhitelist = true;
568 
569     /**
570      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
571      * a default value of 18.
572      *
573      * To select a different value for {decimals}, use {_setupDecimals}.
574      *
575      * All three of these values are immutable: they can only be set once during
576      * construction.
577      */
578     constructor (string memory name, string memory symbol) public {
579         _name = name;
580         _symbol = symbol;
581         _decimals = 18;
582     }
583 
584     /**
585      * @dev Returns the name of the token.
586      */
587     function name() public view returns (string memory) {
588         return _name;
589     }
590 
591     /**
592      * @dev Returns the symbol of the token, usually a shorter version of the
593      * name.
594      */
595     function symbol() public view returns (string memory) {
596         return _symbol;
597     }
598 
599     /**
600      * @dev Returns the number of decimals used to get its user representation.
601      * For example, if `decimals` equals `2`, a balance of `505` tokens should
602      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
603      *
604      * Tokens usually opt for a value of 18, imitating the relationship between
605      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
606      * called.
607      *
608      * NOTE: This information is only used for _display_ purposes: it in
609      * no way affects any of the arithmetic of the contract, including
610      * {IERC20-balanceOf} and {IERC20-transfer}.
611      */
612     function decimals() public view returns (uint8) {
613         return _decimals;
614     }
615 
616     /**
617      * @dev See {IERC20-totalSupply}.
618      */
619     function totalSupply() public view override returns (uint256) {
620         return _totalSupply;
621     }
622 
623     /**
624      * @dev See {IERC20-balanceOf}.
625      */
626     function balanceOf(address account) public view override returns (uint256) {
627         return _balances[account];
628     }
629 
630     /**
631      * @dev See {IERC20-transfer}.
632      *
633      * Requirements:
634      *
635      * - `recipient` cannot be the zero address.
636      * - the caller must have a balance of at least `amount`.
637      */
638     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
639         _transfer(_msgSender(), recipient, amount);
640         return true;
641     }
642 
643     /**
644      * @dev See {IERC20-allowance}.
645      */
646     function allowance(address owner, address spender) public view virtual override returns (uint256) {
647         return _allowances[owner][spender];
648     }
649 
650     /**
651      * @dev See {IERC20-approve}.
652      *
653      * Requirements:
654      *
655      * - `spender` cannot be the zero address.
656      */
657     function approve(address spender, uint256 amount) public virtual override returns (bool) {
658         _approve(_msgSender(), spender, amount);
659         return true;
660     }
661 
662     /**
663      * @dev See {IERC20-transferFrom}.
664      *
665      * Emits an {Approval} event indicating the updated allowance. This is not
666      * required by the EIP. See the note at the beginning of {ERC20};
667      *
668      * Requirements:
669      * - `sender` and `recipient` cannot be the zero address.
670      * - `sender` must have a balance of at least `amount`.
671      * - the caller must have allowance for ``sender``'s tokens of at least
672      * `amount`.
673      */
674     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
675         _transfer(sender, recipient, amount);
676         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
677         return true;
678     }
679 
680     /**
681      * @dev Atomically increases the allowance granted to `spender` by the caller.
682      *
683      * This is an alternative to {approve} that can be used as a mitigation for
684      * problems described in {IERC20-approve}.
685      *
686      * Emits an {Approval} event indicating the updated allowance.
687      *
688      * Requirements:
689      *
690      * - `spender` cannot be the zero address.
691      */
692     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
693         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
694         return true;
695     }
696 
697     /**
698      * @dev Atomically decreases the allowance granted to `spender` by the caller.
699      *
700      * This is an alternative to {approve} that can be used as a mitigation for
701      * problems described in {IERC20-approve}.
702      *
703      * Emits an {Approval} event indicating the updated allowance.
704      *
705      * Requirements:
706      *
707      * - `spender` cannot be the zero address.
708      * - `spender` must have allowance for the caller of at least
709      * `subtractedValue`.
710      */
711     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
712         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
713         return true;
714     }
715 
716     // assign a new transactionfee
717     function setFee(uint8 _newTxFee) public onlyOwner {
718         txFee = _newTxFee;
719     }
720 
721     // assign a new fee distributor address
722     function setFeeDistributor(address _distributor) public onlyOwner {
723         feeDistributor = _distributor;
724     }
725 
726      // enable/disable sender who can send feeless transactions
727     function setFeelessSender(address _sender, bool _feeless) public onlyOwner {
728         require(!_feeless || _feeless && canWhitelist, "cannot add to whitelist");
729         feelessSender[_sender] = _feeless;
730     }
731 
732     // enable/disable recipient who can reccieve feeless transactions
733     function setFeelessReciever(address _recipient, bool _feeless) public onlyOwner {
734         require(!_feeless || _feeless && canWhitelist, "cannot add to whitelist");
735         feelessReciever[_recipient] = _feeless;
736     }
737 
738     // disable adding to whitelist forever
739     function renounceWhitelist() public onlyOwner {
740         // adding to whitelist has been disabled forever:
741         canWhitelist = false;
742     }
743 
744     // to caclulate the amounts for recipient and distributer after fees have been applied
745     function calculateAmountsAfterFee(
746         address sender,
747         address recipient,
748         uint256 amount
749     ) public view returns (uint256 transferToAmount, uint256 transferToFeeDistributorAmount) {
750 
751         // check if fees should apply to this transaction
752         if (feelessSender[sender] || feelessReciever[recipient]) {
753             return (amount, 0);
754         }
755 
756         // calculate fees and amounts
757         uint256 fee = amount.mul(txFee).div(1000);
758         return (amount.sub(fee), fee);
759     }
760 
761     /**
762      * @dev Moves tokens `amount` from `sender` to `recipient`.
763      *
764      * This is internal function is equivalent to {transfer}, and can be used to
765      * e.g. implement automatic token fees, slashing mechanisms, etc.
766      *
767      * Emits a {Transfer} event.
768      *
769      * Requirements:
770      *
771      * - `sender` cannot be the zero address.
772      * - `recipient` cannot be the zero address.
773      * - `sender` must have a balance of at least `amount`.
774      */
775     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
776         require(sender != address(0), "ERC20: transfer from the zero address");
777         require(recipient != address(0), "ERC20: transfer to the zero address");
778         require(amount > 1000, "amount to small, maths will break");
779         _beforeTokenTransfer(sender, recipient, amount);
780 
781         // subtract send balanced
782         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
783 
784         // calculate fee:
785         (uint256 transferToAmount, uint256 transferToFeeDistributorAmount) = calculateAmountsAfterFee(sender, recipient, amount);
786 
787         // update recipients balance:
788         _balances[recipient] = _balances[recipient].add(transferToAmount);
789         emit Transfer(sender, recipient, transferToAmount);
790 
791         // update distributers balance:
792         if(transferToFeeDistributorAmount > 0 && feeDistributor != address(0)){
793             _balances[feeDistributor] = _balances[feeDistributor].add(transferToFeeDistributorAmount);
794             emit Transfer(sender, feeDistributor, transferToFeeDistributorAmount);
795         }
796     }
797 
798     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
799      * the total supply.
800      *
801      * Emits a {Transfer} event with `from` set to the zero address.
802      *
803      * Requirements
804      *
805      * - `to` cannot be the zero address.
806      */
807     function _mint(address account, uint256 amount) internal virtual {
808         require(account != address(0), "ERC20: mint to the zero address");
809 
810         _beforeTokenTransfer(address(0), account, amount);
811 
812         _totalSupply = _totalSupply.add(amount);
813         _balances[account] = _balances[account].add(amount);
814         emit Transfer(address(0), account, amount);
815     }
816 
817     /**
818      * @dev Destroys `amount` tokens from `account`, reducing the
819      * total supply.
820      *
821      * Emits a {Transfer} event with `to` set to the zero address.
822      *
823      * Requirements
824      *
825      * - `account` cannot be the zero address.
826      * - `account` must have at least `amount` tokens.
827      */
828     function _burn(address account, uint256 amount) internal virtual {
829         require(account != address(0), "ERC20: burn from the zero address");
830 
831         _beforeTokenTransfer(account, address(0), amount);
832 
833         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
834         _totalSupply = _totalSupply.sub(amount);
835         emit Transfer(account, address(0), amount);
836     }
837 
838     /**
839      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
840      *
841      * This internal function is equivalent to `approve`, and can be used to
842      * e.g. set automatic allowances for certain subsystems, etc.
843      *
844      * Emits an {Approval} event.
845      *
846      * Requirements:
847      *
848      * - `owner` cannot be the zero address.
849      * - `spender` cannot be the zero address.
850      */
851     function _approve(address owner, address spender, uint256 amount) internal virtual {
852         require(owner != address(0), "ERC20: approve from the zero address");
853         require(spender != address(0), "ERC20: approve to the zero address");
854 
855         _allowances[owner][spender] = amount;
856         emit Approval(owner, spender, amount);
857     }
858 
859     /**
860      * @dev Sets {decimals} to a value other than the default one of 18.
861      *
862      * WARNING: This function should only be called from the constructor. Most
863      * applications that interact with token contracts will not expect
864      * {decimals} to ever change, and may work incorrectly if it does.
865      */
866     function _setupDecimals(uint8 decimals_) internal {
867         _decimals = decimals_;
868     }
869 
870     /**
871      * @dev Hook that is called before any transfer of tokens. This includes
872      * minting and burning.
873      *
874      * Calling conditions:
875      *
876      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
877      * will be to transferred to `to`.
878      * - when `from` is zero, `amount` tokens will be minted for `to`.
879      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
880      * - `from` and `to` are never both zero.
881      *
882      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
883      */
884     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
885 }
886 
887 
888 pragma solidity 0.6.6;
889 
890 
891 
892 
893 /**
894  * ETHY is an Ethereum Yield farming utility and governance coin.
895  * It will allow holders to access unique Ethereum farming opportunities,
896  * and collect a percentage of the farming platform fees.
897  *
898  * The ETHY Token itself is just a standard ERC20, with:
899  * No minting.
900  * Public burning.
901  * Transfer fee applied.
902  */
903 contract ETHY is DeflationaryERC20 {
904 
905     constructor() public DeflationaryERC20("Ethereum Yield", "ETHY") {
906         // symbol           = ETHY
907         // name             = ETHEREUM YEILD
908         // maximum supply   = 500000 ETHY
909         _mint(msg.sender, 500000e18);
910     }
911 
912     function burn(uint256 amount) public {
913         _burn(msg.sender, amount);
914     }
915 }