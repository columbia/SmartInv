1 // Partial License: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 
27 // Partial License: MIT
28 
29 pragma solidity ^0.6.0;
30 
31 /**
32  * @dev Interface of the ERC20 standard as defined in the EIP.
33  */
34 interface IERC20 {
35     /**
36      * @dev Returns the amount of tokens in existence.
37      */
38     function totalSupply() external view returns (uint256);
39 
40     /**
41      * @dev Returns the amount of tokens owned by `account`.
42      */
43     function balanceOf(address account) external view returns (uint256);
44 
45     /**
46      * @dev Moves `amount` tokens from the caller's account to `recipient`.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * Emits a {Transfer} event.
51      */
52     function transfer(address recipient, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Returns the remaining number of tokens that `spender` will be
56      * allowed to spend on behalf of `owner` through {transferFrom}. This is
57      * zero by default.
58      *
59      * This value changes when {approve} or {transferFrom} are called.
60      */
61     function allowance(address owner, address spender) external view returns (uint256);
62 
63     /**
64      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * IMPORTANT: Beware that changing an allowance with this method brings the risk
69      * that someone may use both the old and the new allowance by unfortunate
70      * transaction ordering. One possible solution to mitigate this race
71      * condition is to first reduce the spender's allowance to 0 and set the
72      * desired value afterwards:
73      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
74      *
75      * Emits an {Approval} event.
76      */
77     function approve(address spender, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Moves `amount` tokens from `sender` to `recipient` using the
81      * allowance mechanism. `amount` is then deducted from the caller's
82      * allowance.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * Emits a {Transfer} event.
87      */
88     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
89 
90     /**
91      * @dev Emitted when `value` tokens are moved from one account (`from`) to
92      * another (`to`).
93      *
94      * Note that `value` may be zero.
95      */
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     /**
99      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
100      * a call to {approve}. `value` is the new allowance.
101      */
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 
106 // Partial License: MIT
107 
108 pragma solidity ^0.6.0;
109 
110 /**
111  * @dev Wrappers over Solidity's arithmetic operations with added overflow
112  * checks.
113  *
114  * Arithmetic operations in Solidity wrap on overflow. This can easily result
115  * in bugs, because programmers usually assume that an overflow raises an
116  * error, which is the standard behavior in high level programming languages.
117  * `SafeMath` restores this intuition by reverting the transaction when an
118  * operation overflows.
119  *
120  * Using this library instead of the unchecked operations eliminates an entire
121  * class of bugs, so it's recommended to use it always.
122  */
123 library SafeMath {
124     /**
125      * @dev Returns the addition of two unsigned integers, reverting on
126      * overflow.
127      *
128      * Counterpart to Solidity's `+` operator.
129      *
130      * Requirements:
131      *
132      * - Addition cannot overflow.
133      */
134     function add(uint256 a, uint256 b) internal pure returns (uint256) {
135         uint256 c = a + b;
136         require(c >= a, "SafeMath: addition overflow");
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the subtraction of two unsigned integers, reverting on
143      * overflow (when the result is negative).
144      *
145      * Counterpart to Solidity's `-` operator.
146      *
147      * Requirements:
148      *
149      * - Subtraction cannot overflow.
150      */
151     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
152         return sub(a, b, "SafeMath: subtraction overflow");
153     }
154 
155     /**
156      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
157      * overflow (when the result is negative).
158      *
159      * Counterpart to Solidity's `-` operator.
160      *
161      * Requirements:
162      *
163      * - Subtraction cannot overflow.
164      */
165     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
166         require(b <= a, errorMessage);
167         uint256 c = a - b;
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the multiplication of two unsigned integers, reverting on
174      * overflow.
175      *
176      * Counterpart to Solidity's `*` operator.
177      *
178      * Requirements:
179      *
180      * - Multiplication cannot overflow.
181      */
182     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
183         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
184         // benefit is lost if 'b' is also tested.
185         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
186         if (a == 0) {
187             return 0;
188         }
189 
190         uint256 c = a * b;
191         require(c / a == b, "SafeMath: multiplication overflow");
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the integer division of two unsigned integers. Reverts on
198      * division by zero. The result is rounded towards zero.
199      *
200      * Counterpart to Solidity's `/` operator. Note: this function uses a
201      * `revert` opcode (which leaves remaining gas untouched) while Solidity
202      * uses an invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      *
206      * - The divisor cannot be zero.
207      */
208     function div(uint256 a, uint256 b) internal pure returns (uint256) {
209         return div(a, b, "SafeMath: division by zero");
210     }
211 
212     /**
213      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
214      * division by zero. The result is rounded towards zero.
215      *
216      * Counterpart to Solidity's `/` operator. Note: this function uses a
217      * `revert` opcode (which leaves remaining gas untouched) while Solidity
218      * uses an invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b > 0, errorMessage);
226         uint256 c = a / b;
227         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
228 
229         return c;
230     }
231 
232     /**
233      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
234      * Reverts when dividing by zero.
235      *
236      * Counterpart to Solidity's `%` operator. This function uses a `revert`
237      * opcode (which leaves remaining gas untouched) while Solidity uses an
238      * invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
245         return mod(a, b, "SafeMath: modulo by zero");
246     }
247 
248     /**
249      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
250      * Reverts with custom message when dividing by zero.
251      *
252      * Counterpart to Solidity's `%` operator. This function uses a `revert`
253      * opcode (which leaves remaining gas untouched) while Solidity uses an
254      * invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      *
258      * - The divisor cannot be zero.
259      */
260     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
261         require(b != 0, errorMessage);
262         return a % b;
263     }
264 }
265 
266 
267 // Partial License: MIT
268 
269 pragma solidity ^0.6.2;
270 
271 /**
272  * @dev Collection of functions related to the address type
273  */
274 library Address {
275     /**
276      * @dev Returns true if `account` is a contract.
277      *
278      * [IMPORTANT]
279      * ====
280      * It is unsafe to assume that an address for which this function returns
281      * false is an externally-owned account (EOA) and not a contract.
282      *
283      * Among others, `isContract` will return false for the following
284      * types of addresses:
285      *
286      *  - an externally-owned account
287      *  - a contract in construction
288      *  - an address where a contract will be created
289      *  - an address where a contract lived, but was destroyed
290      * ====
291      */
292     function isContract(address account) internal view returns (bool) {
293         // This method relies in extcodesize, which returns 0 for contracts in
294         // construction, since the code is only stored at the end of the
295         // constructor execution.
296 
297         uint256 size;
298         // solhint-disable-next-line no-inline-assembly
299         assembly { size := extcodesize(account) }
300         return size > 0;
301     }
302 
303     /**
304      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
305      * `recipient`, forwarding all available gas and reverting on errors.
306      *
307      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
308      * of certain opcodes, possibly making contracts go over the 2300 gas limit
309      * imposed by `transfer`, making them unable to receive funds via
310      * `transfer`. {sendValue} removes this limitation.
311      *
312      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
313      *
314      * IMPORTANT: because control is transferred to `recipient`, care must be
315      * taken to not create reentrancy vulnerabilities. Consider using
316      * {ReentrancyGuard} or the
317      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
318      */
319     function sendValue(address payable recipient, uint256 amount) internal {
320         require(address(this).balance >= amount, "Address: insufficient balance");
321 
322         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
323         (bool success, ) = recipient.call{ value: amount }("");
324         require(success, "Address: unable to send value, recipient may have reverted");
325     }
326 
327     /**
328      * @dev Performs a Solidity function call using a low level `call`. A
329      * plain`call` is an unsafe replacement for a function call: use this
330      * function instead.
331      *
332      * If `target` reverts with a revert reason, it is bubbled up by this
333      * function (like regular Solidity function calls).
334      *
335      * Returns the raw returned data. To convert to the expected return value,
336      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
337      *
338      * Requirements:
339      *
340      * - `target` must be a contract.
341      * - calling `target` with `data` must not revert.
342      *
343      * _Available since v3.1._
344      */
345     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
346       return functionCall(target, data, "Address: low-level call failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
351      * `errorMessage` as a fallback revert reason when `target` reverts.
352      *
353      * _Available since v3.1._
354      */
355     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
356         return _functionCallWithValue(target, data, 0, errorMessage);
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
361      * but also transferring `value` wei to `target`.
362      *
363      * Requirements:
364      *
365      * - the calling contract must have an ETH balance of at least `value`.
366      * - the called Solidity function must be `payable`.
367      *
368      * _Available since v3.1._
369      */
370     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
371         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
376      * with `errorMessage` as a fallback revert reason when `target` reverts.
377      *
378      * _Available since v3.1._
379      */
380     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
381         require(address(this).balance >= value, "Address: insufficient balance for call");
382         return _functionCallWithValue(target, data, value, errorMessage);
383     }
384 
385     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
386         require(isContract(target), "Address: call to non-contract");
387 
388         // solhint-disable-next-line avoid-low-level-calls
389         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
390         if (success) {
391             return returndata;
392         } else {
393             // Look for revert reason and bubble it up if present
394             if (returndata.length > 0) {
395                 // The easiest way to bubble the revert reason is using memory via assembly
396 
397                 // solhint-disable-next-line no-inline-assembly
398                 assembly {
399                     let returndata_size := mload(returndata)
400                     revert(add(32, returndata), returndata_size)
401                 }
402             } else {
403                 revert(errorMessage);
404             }
405         }
406     }
407 }
408 
409 
410 // Partial License: MIT
411 
412 pragma solidity ^0.6.0;
413 
414 
415 /**
416  * @dev Contract module which provides a basic access control mechanism, where
417  * there is an account (an owner) that can be granted exclusive access to
418  * specific functions.
419  *
420  * By default, the owner account will be the one that deploys the contract. This
421  * can later be changed with {transferOwnership}.
422  *
423  * This module is used through inheritance. It will make available the modifier
424  * `onlyOwner`, which can be applied to your functions to restrict their use to
425  * the owner.
426  */
427 contract Ownable is Context {
428     address private _owner;
429 
430     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
431 
432     /**
433      * @dev Initializes the contract setting the deployer as the initial owner.
434      */
435     constructor () internal {
436         address msgSender = _msgSender();
437         _owner = msgSender;
438         emit OwnershipTransferred(address(0), msgSender);
439     }
440 
441     /**
442      * @dev Returns the address of the current owner.
443      */
444     function owner() public view returns (address) {
445         return _owner;
446     }
447 
448     /**
449      * @dev Throws if called by any account other than the owner.
450      */
451     modifier onlyOwner() {
452         require(_owner == _msgSender(), "Ownable: caller is not the owner");
453         _;
454     }
455 
456     /**
457      * @dev Leaves the contract without owner. It will not be possible to call
458      * `onlyOwner` functions anymore. Can only be called by the current owner.
459      *
460      * NOTE: Renouncing ownership will leave the contract without an owner,
461      * thereby removing any functionality that is only available to the owner.
462      */
463     function renounceOwnership() public virtual onlyOwner {
464         emit OwnershipTransferred(_owner, address(0));
465         _owner = address(0);
466     }
467 
468     /**
469      * @dev Transfers ownership of the contract to a new account (`newOwner`).
470      * Can only be called by the current owner.
471      */
472     function transferOwnership(address newOwner) public virtual onlyOwner {
473         require(newOwner != address(0), "Ownable: new owner is the zero address");
474         emit OwnershipTransferred(_owner, newOwner);
475         _owner = newOwner;
476     }
477 }
478 
479 
480 /**
481  * We have made some light modifications to the openzeppelin ER20
482  * located here "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol".
483  * Please read below for a quick overview of what has been changed:
484  *
485  * We have changed one function:
486  * - `_transfer` [line 293] to apply a transfer fee
487  *
488  * We have added 5 variables
489  * - `txFee` [line 78] the transaction fee to be applied.
490  * - `feeDistributor` [line 79] the contract address to recieve the fees.
491  * - `feelessSender` [line 82] map containing senders who will not have txFees applied.
492  * - `feelessReceiver` [line 83] map containing recipients who will not have txFee applied.
493  * - `canWhitelist` [line 85] map containing recipients who will not have txFee applied.
494  *
495  * We have added 6 simple functions
496  * - `setFee` [line 235] set new transaction fee.
497  * - `setFeeDistributor` [line 240] sets new address to recieve txFees
498  * - `setFeelessSender` [line 245] to enable/disable fees for a given sender.
499  * - `setfeelessReceiver` [line 251] to enable/disable fees for a given recipient.
500  * - `renounceWhitelist` [line 257] disables adding to whitelist forever.
501  * - `calculateAmountsAfterFee` [line 262] to caclulate the amounts after fees have been applied.
502  *
503  * We have updated this contract to implement the openzeppelin Ownable standard.
504  * We have updated the contract from 0.6.0 to 0.6.6;
505  */
506 
507 
508 // Partial License: MIT
509 
510 pragma solidity ^0.6.6;
511 
512 
513 
514 
515 
516 
517 
518 
519 /**
520  * @dev Implementation of the {IERC20} interface.
521  *
522  * This implementation is agnostic to the way tokens are created. This means
523  * that a supply mechanism has to be added in a derived contract using {_mint}.
524  * For a generic mechanism see {ERC20PresetMinterPauser}.
525  *
526  * TIP: For a detailed writeup see our guide
527  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
528  * to implement supply mechanisms].
529  *
530  * We have followed general OpenZeppelin guidelines: functions revert instead
531  * of returning `false` on failure. This behavior is nonetheless conventional
532  * and does not conflict with the expectations of ERC20 applications.
533  *
534  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
535  * This allows applications to reconstruct the allowance for all accounts just
536  * by listening to said events. Other implementations of the EIP may not emit
537  * these events, as it isn't required by the specification.
538  *
539  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
540  * functions have been added to mitigate the well-known issues around setting
541  * allowances. See {IERC20-approve}.
542  */
543 contract DeflationaryERC20 is Context, IERC20, Ownable {
544     using SafeMath for uint256;
545     using Address for address;
546 
547     mapping (address => uint256) private _balances;
548     mapping (address => mapping (address => uint256)) private _allowances;
549 
550     uint256 private _totalSupply;
551 
552     string private _name;
553     string private _symbol;
554     uint8 private _decimals;
555 
556     // Transaction Fees:
557     uint8 public txFee = 50; // capped to 10%.
558     address public feeDistributor; // fees are sent to fee distributer
559 
560     // Fee Whitelist
561     mapping(address => bool) public feelessSender;
562     mapping(address => bool) public feelessReceiver;
563     // if this equals false whitelist can nolonger be added to.
564     bool public canWhitelist = true;
565 
566     event UpdatedFeelessSender(address indexed _address, bool _isFeelessSender);
567     event UpdatedFeelessReceiver(address indexed _address, bool _isFeelessReceiver);
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
718         require(_newTxFee <= 100, "fee too big");
719         txFee = _newTxFee;
720     }
721 
722     // assign a new fee distributor address
723     function setFeeDistributor(address _distributor) public onlyOwner {
724         feeDistributor = _distributor;
725     }
726 
727      // enable/disable sender who can send feeless transactions
728     function setFeelessSender(address _sender, bool _feeless) public onlyOwner {
729         require(!_feeless || _feeless && canWhitelist, "cannot add to whitelist");
730         feelessSender[_sender] = _feeless;
731         emit UpdatedFeelessSender(_sender, _feeless);
732     }
733 
734     // enable/disable recipient who can reccieve feeless transactions
735     function setfeelessReceiver(address _recipient, bool _feeless) public onlyOwner {
736         require(!_feeless || _feeless && canWhitelist, "cannot add to whitelist");
737         feelessReceiver[_recipient] = _feeless;
738         emit UpdatedFeelessReceiver(_recipient, _feeless);
739     }
740 
741     // disable adding to whitelist forever
742     function renounceWhitelist() public onlyOwner {
743         // adding to whitelist has been disabled forever:
744         canWhitelist = false;
745     }
746 
747     // to caclulate the amounts for recipient and distributer after fees have been applied
748     function calculateAmountsAfterFee(
749         address sender,
750         address recipient,
751         uint256 amount
752     ) public view returns (uint256 transferToAmount, uint256 transferToFeeDistributorAmount) {
753 
754         // check if fees should apply to this transaction
755         if (feelessSender[sender] || feelessReceiver[recipient]) {
756             return (amount, 0);
757         }
758 
759         // calculate fees and amounts
760         uint256 fee = amount.mul(txFee).div(1000);
761         return (amount.sub(fee), fee);
762     }
763 
764     /**
765      * @dev Moves tokens `amount` from `sender` to `recipient`.
766      *
767      * This is internal function is equivalent to {transfer}, and can be used to
768      * e.g. implement automatic token fees, slashing mechanisms, etc.
769      *
770      * Emits a {Transfer} event.
771      *
772      * Requirements:
773      *
774      * - `sender` cannot be the zero address.
775      * - `recipient` cannot be the zero address.
776      * - `sender` must have a balance of at least `amount`.
777      */
778     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
779         require(sender != address(0), "ERC20: transfer from the zero address");
780         require(recipient != address(0), "ERC20: transfer to the zero address");
781         require(amount > 1000, "amount to small, maths will break");
782         _beforeTokenTransfer(sender, recipient, amount);
783 
784         // subtract send balanced
785         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
786 
787         // calculate fee:
788         (uint256 transferToAmount, uint256 transferToFeeDistributorAmount) = calculateAmountsAfterFee(sender, recipient, amount);
789 
790         // update recipients balance:
791         _balances[recipient] = _balances[recipient].add(transferToAmount);
792         emit Transfer(sender, recipient, transferToAmount);
793 
794         // update distributers balance:
795         if(transferToFeeDistributorAmount > 0 && feeDistributor != address(0)){
796             _balances[feeDistributor] = _balances[feeDistributor].add(transferToFeeDistributorAmount);
797             emit Transfer(sender, feeDistributor, transferToFeeDistributorAmount);
798         }
799     }
800 
801     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
802      * the total supply.
803      *
804      * Emits a {Transfer} event with `from` set to the zero address.
805      *
806      * Requirements
807      *
808      * - `to` cannot be the zero address.
809      */
810     function _mint(address account, uint256 amount) internal virtual {
811         require(account != address(0), "ERC20: mint to the zero address");
812 
813         _beforeTokenTransfer(address(0), account, amount);
814 
815         _totalSupply = _totalSupply.add(amount);
816         _balances[account] = _balances[account].add(amount);
817         emit Transfer(address(0), account, amount);
818     }
819 
820     /**
821      * @dev Destroys `amount` tokens from `account`, reducing the
822      * total supply.
823      *
824      * Emits a {Transfer} event with `to` set to the zero address.
825      *
826      * Requirements
827      *
828      * - `account` cannot be the zero address.
829      * - `account` must have at least `amount` tokens.
830      */
831     function _burn(address account, uint256 amount) internal virtual {
832         require(account != address(0), "ERC20: burn from the zero address");
833 
834         _beforeTokenTransfer(account, address(0), amount);
835 
836         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
837         _totalSupply = _totalSupply.sub(amount);
838         emit Transfer(account, address(0), amount);
839     }
840 
841     /**
842      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
843      *
844      * This internal function is equivalent to `approve`, and can be used to
845      * e.g. set automatic allowances for certain subsystems, etc.
846      *
847      * Emits an {Approval} event.
848      *
849      * Requirements:
850      *
851      * - `owner` cannot be the zero address.
852      * - `spender` cannot be the zero address.
853      */
854     function _approve(address owner, address spender, uint256 amount) internal virtual {
855         require(owner != address(0), "ERC20: approve from the zero address");
856         require(spender != address(0), "ERC20: approve to the zero address");
857 
858         _allowances[owner][spender] = amount;
859         emit Approval(owner, spender, amount);
860     }
861 
862     /**
863      * @dev Sets {decimals} to a value other than the default one of 18.
864      *
865      * WARNING: This function should only be called from the constructor. Most
866      * applications that interact with token contracts will not expect
867      * {decimals} to ever change, and may work incorrectly if it does.
868      */
869     function _setupDecimals(uint8 decimals_) internal {
870         _decimals = decimals_;
871     }
872 
873     /**
874      * @dev Hook that is called before any transfer of tokens. This includes
875      * minting and burning.
876      *
877      * Calling conditions:
878      *
879      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
880      * will be to transferred to `to`.
881      * - when `from` is zero, `amount` tokens will be minted for `to`.
882      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
883      * - `from` and `to` are never both zero.
884      *
885      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
886      */
887     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
888 }
889 
890 
891 pragma solidity 0.6.6;
892 
893 
894 
895 
896 /**
897  * ETHYS is the sister token to 'Ethereum Yield', 
898  * designed to implement and benefit from the same pumpemental concepts,
899  * and allow stakers extraordinary benefits.
900  *
901  * The ETHYS Token itself is just a standard ERC20, with:
902  * No minting.
903  * Public burning.
904  * Transfer fee applied. Capped to 10%.
905  */
906 contract ETHYS is DeflationaryERC20 {
907 
908     constructor() public DeflationaryERC20("Ethereum Stake", "ETHYS") {
909         // symbol           = ETHYS
910         // name             = ETHEREUM Stake
911         // maximum supply   = 500000 ETHYS
912         _mint(msg.sender, 500000e18);
913     }
914 
915     function burn(uint256 amount) public {
916         _burn(msg.sender, amount);
917     }
918 }