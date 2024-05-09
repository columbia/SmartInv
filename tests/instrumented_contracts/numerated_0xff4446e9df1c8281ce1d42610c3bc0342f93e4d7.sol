1 pragma solidity 0.6.12;
2 
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through {transferFrom}. This is
30      * zero by default.
31      *
32      * This value changes when {approve} or {transferFrom} are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to {approve}. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 /**
79  * @dev Wrappers over Solidity's arithmetic operations with added overflow
80  * checks.
81  *
82  * Arithmetic operations in Solidity wrap on overflow. This can easily result
83  * in bugs, because programmers usually assume that an overflow raises an
84  * error, which is the standard behavior in high level programming languages.
85  * `SafeMath` restores this intuition by reverting the transaction when an
86  * operation overflows.
87  *
88  * Using this library instead of the unchecked operations eliminates an entire
89  * class of bugs, so it's recommended to use it always.
90  */
91 library SafeMath {
92     /**
93      * @dev Returns the addition of two unsigned integers, reverting on
94      * overflow.
95      *
96      * Counterpart to Solidity's `+` operator.
97      *
98      * Requirements:
99      *
100      * - Addition cannot overflow.
101      */
102     function add(uint256 a, uint256 b) internal pure returns (uint256) {
103         uint256 c = a + b;
104         require(c >= a, "SafeMath: addition overflow");
105 
106         return c;
107     }
108 
109     /**
110      * @dev Returns the subtraction of two unsigned integers, reverting on
111      * overflow (when the result is negative).
112      *
113      * Counterpart to Solidity's `-` operator.
114      *
115      * Requirements:
116      *
117      * - Subtraction cannot overflow.
118      */
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         return sub(a, b, "SafeMath: subtraction overflow");
121     }
122 
123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      *
131      * - Subtraction cannot overflow.
132      */
133     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
134         require(b <= a, errorMessage);
135         uint256 c = a - b;
136 
137         return c;
138     }
139 
140     /**
141      * @dev Returns the multiplication of two unsigned integers, reverting on
142      * overflow.
143      *
144      * Counterpart to Solidity's `*` operator.
145      *
146      * Requirements:
147      *
148      * - Multiplication cannot overflow.
149      */
150     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
151         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
152         // benefit is lost if 'b' is also tested.
153         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
154         if (a == 0) {
155             return 0;
156         }
157 
158         uint256 c = a * b;
159         require(c / a == b, "SafeMath: multiplication overflow");
160 
161         return c;
162     }
163 
164     /**
165      * @dev Returns the integer division of two unsigned integers. Reverts on
166      * division by zero. The result is rounded towards zero.
167      *
168      * Counterpart to Solidity's `/` operator. Note: this function uses a
169      * `revert` opcode (which leaves remaining gas untouched) while Solidity
170      * uses an invalid opcode to revert (consuming all remaining gas).
171      *
172      * Requirements:
173      *
174      * - The divisor cannot be zero.
175      */
176     function div(uint256 a, uint256 b) internal pure returns (uint256) {
177         return div(a, b, "SafeMath: division by zero");
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         require(b > 0, errorMessage);
194         uint256 c = a / b;
195         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
202      * Reverts when dividing by zero.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
213         return mod(a, b, "SafeMath: modulo by zero");
214     }
215 
216     /**
217      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
218      * Reverts with custom message when dividing by zero.
219      *
220      * Counterpart to Solidity's `%` operator. This function uses a `revert`
221      * opcode (which leaves remaining gas untouched) while Solidity uses an
222      * invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b != 0, errorMessage);
230         return a % b;
231     }
232 }
233 
234 /**
235  * @dev Collection of functions related to the address type
236  */
237 library Address {
238     /**
239      * @dev Returns true if `account` is a contract.
240      *
241      * [IMPORTANT]
242      * ====
243      * It is unsafe to assume that an address for which this function returns
244      * false is an externally-owned account (EOA) and not a contract.
245      *
246      * Among others, `isContract` will return false for the following
247      * types of addresses:
248      *
249      *  - an externally-owned account
250      *  - a contract in construction
251      *  - an address where a contract will be created
252      *  - an address where a contract lived, but was destroyed
253      * ====
254      */
255     function isContract(address account) internal view returns (bool) {
256         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
257         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
258         // for accounts without code, i.e. `keccak256('')`
259         bytes32 codehash;
260         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
261         // solhint-disable-next-line no-inline-assembly
262         assembly { codehash := extcodehash(account) }
263         return (codehash != accountHash && codehash != 0x0);
264     }
265 
266     /**
267      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
268      * `recipient`, forwarding all available gas and reverting on errors.
269      *
270      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
271      * of certain opcodes, possibly making contracts go over the 2300 gas limit
272      * imposed by `transfer`, making them unable to receive funds via
273      * `transfer`. {sendValue} removes this limitation.
274      *
275      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
276      *
277      * IMPORTANT: because control is transferred to `recipient`, care must be
278      * taken to not create reentrancy vulnerabilities. Consider using
279      * {ReentrancyGuard} or the
280      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
281      */
282     function sendValue(address payable recipient, uint256 amount) internal {
283         require(address(this).balance >= amount, "Address: insufficient balance");
284 
285         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
286         (bool success, ) = recipient.call{ value: amount }("");
287         require(success, "Address: unable to send value, recipient may have reverted");
288     }
289 
290     /**
291      * @dev Performs a Solidity function call using a low level `call`. A
292      * plain`call` is an unsafe replacement for a function call: use this
293      * function instead.
294      *
295      * If `target` reverts with a revert reason, it is bubbled up by this
296      * function (like regular Solidity function calls).
297      *
298      * Returns the raw returned data. To convert to the expected return value,
299      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
300      *
301      * Requirements:
302      *
303      * - `target` must be a contract.
304      * - calling `target` with `data` must not revert.
305      *
306      * _Available since v3.1._
307      */
308     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
309       return functionCall(target, data, "Address: low-level call failed");
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
314      * `errorMessage` as a fallback revert reason when `target` reverts.
315      *
316      * _Available since v3.1._
317      */
318     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
319         return _functionCallWithValue(target, data, 0, errorMessage);
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
324      * but also transferring `value` wei to `target`.
325      *
326      * Requirements:
327      *
328      * - the calling contract must have an ETH balance of at least `value`.
329      * - the called Solidity function must be `payable`.
330      *
331      * _Available since v3.1._
332      */
333     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
334         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
339      * with `errorMessage` as a fallback revert reason when `target` reverts.
340      *
341      * _Available since v3.1._
342      */
343     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
344         require(address(this).balance >= value, "Address: insufficient balance for call");
345         return _functionCallWithValue(target, data, value, errorMessage);
346     }
347 
348     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
349         require(isContract(target), "Address: call to non-contract");
350 
351         // solhint-disable-next-line avoid-low-level-calls
352         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
353         if (success) {
354             return returndata;
355         } else {
356             // Look for revert reason and bubble it up if present
357             if (returndata.length > 0) {
358                 // The easiest way to bubble the revert reason is using memory via assembly
359 
360                 // solhint-disable-next-line no-inline-assembly
361                 assembly {
362                     let returndata_size := mload(returndata)
363                     revert(add(32, returndata), returndata_size)
364                 }
365             } else {
366                 revert(errorMessage);
367             }
368         }
369     }
370 }
371 
372 /**
373  * @title SafeERC20
374  * @dev Wrappers around ERC20 operations that throw on failure (when the token
375  * contract returns false). Tokens that return no value (and instead revert or
376  * throw on failure) are also supported, non-reverting calls are assumed to be
377  * successful.
378  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
379  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
380  */
381 library SafeERC20 {
382     using SafeMath for uint256;
383     using Address for address;
384 
385     function safeTransfer(IERC20 token, address to, uint256 value) internal {
386         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
387     }
388 
389     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
390         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
391     }
392 
393     /**
394      * @dev Deprecated. This function has issues similar to the ones found in
395      * {IERC20-approve}, and its usage is discouraged.
396      *
397      * Whenever possible, use {safeIncreaseAllowance} and
398      * {safeDecreaseAllowance} instead.
399      */
400     function safeApprove(IERC20 token, address spender, uint256 value) internal {
401         // safeApprove should only be called when setting an initial allowance,
402         // or when resetting it to zero. To increase and decrease it, use
403         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
404         // solhint-disable-next-line max-line-length
405         require((value == 0) || (token.allowance(address(this), spender) == 0),
406             "SafeERC20: approve from non-zero to non-zero allowance"
407         );
408         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
409     }
410 
411     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
412         uint256 newAllowance = token.allowance(address(this), spender).add(value);
413         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
414     }
415 
416     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
417         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
418         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
419     }
420 
421     /**
422      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
423      * on the return value: the return value is optional (but if data is returned, it must not be false).
424      * @param token The token targeted by the call.
425      * @param data The call data (encoded using abi.encode or one of its variants).
426      */
427     function _callOptionalReturn(IERC20 token, bytes memory data) private {
428         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
429         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
430         // the target address contains contract code and also asserts for success in the low-level call.
431 
432         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
433         if (returndata.length > 0) { // Return data is optional
434             // solhint-disable-next-line max-line-length
435             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
436         }
437     }
438 }
439 
440 /*
441  * @dev Provides information about the current execution context, including the
442  * sender of the transaction and its data. While these are generally available
443  * via msg.sender and msg.data, they should not be accessed in such a direct
444  * manner, since when dealing with GSN meta-transactions the account sending and
445  * paying for execution may not be the actual sender (as far as an application
446  * is concerned).
447  *
448  * This contract is only required for intermediate, library-like contracts.
449  */
450 abstract contract Context {
451     function _msgSender() internal view virtual returns (address payable) {
452         return msg.sender;
453     }
454 
455     function _msgData() internal view virtual returns (bytes memory) {
456         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
457         return msg.data;
458     }
459 }
460 
461 /**
462  * @dev Contract module which provides a basic access control mechanism, where
463  * there is an account (an owner) that can be granted exclusive access to
464  * specific functions.
465  *
466  * By default, the owner account will be the one that deploys the contract. This
467  * can later be changed with {transferOwnership}.
468  *
469  * This module is used through inheritance. It will make available the modifier
470  * `onlyOwner`, which can be applied to your functions to restrict their use to
471  * the owner.
472  */
473 contract Ownable is Context {
474     address private _owner;
475 
476     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
477 
478     /**
479      * @dev Initializes the contract setting the deployer as the initial owner.
480      */
481     constructor () internal {
482         address msgSender = _msgSender();
483         _owner = msgSender;
484         emit OwnershipTransferred(address(0), msgSender);
485     }
486 
487     /**
488      * @dev Returns the address of the current owner.
489      */
490     function owner() public view returns (address) {
491         return _owner;
492     }
493 
494     /**
495      * @dev Throws if called by any account other than the owner.
496      */
497     modifier onlyOwner() {
498         require(_owner == _msgSender(), "Ownable: caller is not the owner");
499         _;
500     }
501 
502     /**
503      * @dev Leaves the contract without owner. It will not be possible to call
504      * `onlyOwner` functions anymore. Can only be called by the current owner.
505      *
506      * NOTE: Renouncing ownership will leave the contract without an owner,
507      * thereby removing any functionality that is only available to the owner.
508      */
509     function renounceOwnership() public virtual onlyOwner {
510         emit OwnershipTransferred(_owner, address(0));
511         _owner = address(0);
512     }
513 
514     /**
515      * @dev Transfers ownership of the contract to a new account (`newOwner`).
516      * Can only be called by the current owner.
517      */
518     function transferOwnership(address newOwner) public virtual onlyOwner {
519         require(newOwner != address(0), "Ownable: new owner is the zero address");
520         emit OwnershipTransferred(_owner, newOwner);
521         _owner = newOwner;
522     }
523 }
524 
525 /**
526  * @dev Contract module that helps prevent reentrant calls to a function.
527  *
528  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
529  * available, which can be aplied to functions to make sure there are no nested
530  * (reentrant) calls to them.
531  *
532  * Note that because there is a single `nonReentrant` guard, functions marked as
533  * `nonReentrant` may not call one another. This can be worked around by making
534  * those functions `private`, and then adding `external` `nonReentrant` entry
535  * points to them.
536  */
537 contract ReentrancyGuard {
538     /// @dev counter to allow mutex lock with only one SSTORE operation
539     uint256 private _guardCounter;
540 
541     constructor () internal {
542         // The counter starts at one to prevent changing it from zero to a non-zero
543         // value, which is a more expensive operation.
544         _guardCounter = 1;
545     }
546 
547     /**
548      * @dev Prevents a contract from calling itself, directly or indirectly.
549      * Calling a `nonReentrant` function from another `nonReentrant`
550      * function is not supported. It is possible to prevent this from happening
551      * by making the `nonReentrant` function external, and make it call a
552      * `private` function that does the actual work.
553      */
554     modifier nonReentrant() {
555         _guardCounter += 1;
556         uint256 localCounter = _guardCounter;
557         _;
558         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
559     }
560 }
561 
562 /**
563  * @dev Implementation of the {IERC20} interface.
564  *
565  * This implementation is agnostic to the way tokens are created. This means
566  * that a supply mechanism has to be added in a derived contract using {_mint}.
567  * For a generic mechanism see {ERC20PresetMinterPauser}.
568  *
569  * TIP: For a detailed writeup see our guide
570  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
571  * to implement supply mechanisms].
572  *
573  * We have followed general OpenZeppelin guidelines: functions revert instead
574  * of returning `false` on failure. This behavior is nonetheless conventional
575  * and does not conflict with the expectations of ERC20 applications.
576  *
577  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
578  * This allows applications to reconstruct the allowance for all accounts just
579  * by listening to said events. Other implementations of the EIP may not emit
580  * these events, as it isn't required by the specification.
581  *
582  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
583  * functions have been added to mitigate the well-known issues around setting
584  * allowances. See {IERC20-approve}.
585  */
586 contract ERC20 is Context, IERC20 {
587     using SafeMath for uint256;
588     using Address for address;
589 
590     mapping (address => uint256) private _balances;
591 
592     mapping (address => mapping (address => uint256)) private _allowances;
593 
594     uint256 private _totalSupply;
595 
596     string private _name;
597     string private _symbol;
598     uint8 private _decimals;
599 
600     /**
601      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
602      * a default value of 18.
603      *
604      * To select a different value for {decimals}, use {_setupDecimals}.
605      *
606      * All three of these values are immutable: they can only be set once during
607      * construction.
608      */
609     constructor (string memory name, string memory symbol) public {
610         _name = name;
611         _symbol = symbol;
612         _decimals = 18;
613     }
614 
615     /**
616      * @dev Returns the name of the token.
617      */
618     function name() public view returns (string memory) {
619         return _name;
620     }
621 
622     /**
623      * @dev Returns the symbol of the token, usually a shorter version of the
624      * name.
625      */
626     function symbol() public view returns (string memory) {
627         return _symbol;
628     }
629 
630     /**
631      * @dev Returns the number of decimals used to get its user representation.
632      * For example, if `decimals` equals `2`, a balance of `505` tokens should
633      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
634      *
635      * Tokens usually opt for a value of 18, imitating the relationship between
636      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
637      * called.
638      *
639      * NOTE: This information is only used for _display_ purposes: it in
640      * no way affects any of the arithmetic of the contract, including
641      * {IERC20-balanceOf} and {IERC20-transfer}.
642      */
643     function decimals() public view returns (uint8) {
644         return _decimals;
645     }
646 
647     /**
648      * @dev See {IERC20-totalSupply}.
649      */
650     function totalSupply() public view override returns (uint256) {
651         return _totalSupply;
652     }
653 
654     /**
655      * @dev See {IERC20-balanceOf}.
656      */
657     function balanceOf(address account) public view override returns (uint256) {
658         return _balances[account];
659     }
660 
661     /**
662      * @dev See {IERC20-transfer}.
663      *
664      * Requirements:
665      *
666      * - `recipient` cannot be the zero address.
667      * - the caller must have a balance of at least `amount`.
668      */
669     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
670         _transfer(_msgSender(), recipient, amount);
671         return true;
672     }
673 
674     /**
675      * @dev See {IERC20-allowance}.
676      */
677     function allowance(address owner, address spender) public view virtual override returns (uint256) {
678         return _allowances[owner][spender];
679     }
680 
681     /**
682      * @dev See {IERC20-approve}.
683      *
684      * Requirements:
685      *
686      * - `spender` cannot be the zero address.
687      */
688     function approve(address spender, uint256 amount) public virtual override returns (bool) {
689         _approve(_msgSender(), spender, amount);
690         return true;
691     }
692 
693     /**
694      * @dev See {IERC20-transferFrom}.
695      *
696      * Emits an {Approval} event indicating the updated allowance. This is not
697      * required by the EIP. See the note at the beginning of {ERC20};
698      *
699      * Requirements:
700      * - `sender` and `recipient` cannot be the zero address.
701      * - `sender` must have a balance of at least `amount`.
702      * - the caller must have allowance for ``sender``'s tokens of at least
703      * `amount`.
704      */
705     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
706         _transfer(sender, recipient, amount);
707         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
708         return true;
709     }
710 
711     /**
712      * @dev Atomically increases the allowance granted to `spender` by the caller.
713      *
714      * This is an alternative to {approve} that can be used as a mitigation for
715      * problems described in {IERC20-approve}.
716      *
717      * Emits an {Approval} event indicating the updated allowance.
718      *
719      * Requirements:
720      *
721      * - `spender` cannot be the zero address.
722      */
723     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
724         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
725         return true;
726     }
727 
728     /**
729      * @dev Atomically decreases the allowance granted to `spender` by the caller.
730      *
731      * This is an alternative to {approve} that can be used as a mitigation for
732      * problems described in {IERC20-approve}.
733      *
734      * Emits an {Approval} event indicating the updated allowance.
735      *
736      * Requirements:
737      *
738      * - `spender` cannot be the zero address.
739      * - `spender` must have allowance for the caller of at least
740      * `subtractedValue`.
741      */
742     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
743         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
744         return true;
745     }
746 
747     /**
748      * @dev Moves tokens `amount` from `sender` to `recipient`.
749      *
750      * This is internal function is equivalent to {transfer}, and can be used to
751      * e.g. implement automatic token fees, slashing mechanisms, etc.
752      *
753      * Emits a {Transfer} event.
754      *
755      * Requirements:
756      *
757      * - `sender` cannot be the zero address.
758      * - `recipient` cannot be the zero address.
759      * - `sender` must have a balance of at least `amount`.
760      */
761     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
762         require(sender != address(0), "ERC20: transfer from the zero address");
763         require(recipient != address(0), "ERC20: transfer to the zero address");
764 
765         _beforeTokenTransfer(sender, recipient, amount);
766 
767         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
768         _balances[recipient] = _balances[recipient].add(amount);
769         emit Transfer(sender, recipient, amount);
770     }
771 
772     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
773      * the total supply.
774      *
775      * Emits a {Transfer} event with `from` set to the zero address.
776      *
777      * Requirements
778      *
779      * - `to` cannot be the zero address.
780      */
781     function _mint(address account, uint256 amount) internal virtual {
782         require(account != address(0), "ERC20: mint to the zero address");
783 
784         _beforeTokenTransfer(address(0), account, amount);
785 
786         _totalSupply = _totalSupply.add(amount);
787         _balances[account] = _balances[account].add(amount);
788         emit Transfer(address(0), account, amount);
789     }
790 
791     /**
792      * @dev Destroys `amount` tokens from `account`, reducing the
793      * total supply.
794      *
795      * Emits a {Transfer} event with `to` set to the zero address.
796      *
797      * Requirements
798      *
799      * - `account` cannot be the zero address.
800      * - `account` must have at least `amount` tokens.
801      */
802     function _burn(address account, uint256 amount) internal virtual {
803         require(account != address(0), "ERC20: burn from the zero address");
804 
805         _beforeTokenTransfer(account, address(0), amount);
806 
807         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
808         _totalSupply = _totalSupply.sub(amount);
809         emit Transfer(account, address(0), amount);
810     }
811 
812     /**
813      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
814      *
815      * This is internal function is equivalent to `approve`, and can be used to
816      * e.g. set automatic allowances for certain subsystems, etc.
817      *
818      * Emits an {Approval} event.
819      *
820      * Requirements:
821      *
822      * - `owner` cannot be the zero address.
823      * - `spender` cannot be the zero address.
824      */
825     function _approve(address owner, address spender, uint256 amount) internal virtual {
826         require(owner != address(0), "ERC20: approve from the zero address");
827         require(spender != address(0), "ERC20: approve to the zero address");
828 
829         _allowances[owner][spender] = amount;
830         emit Approval(owner, spender, amount);
831     }
832 
833     /**
834      * @dev Sets {decimals} to a value other than the default one of 18.
835      *
836      * WARNING: This function should only be called from the constructor. Most
837      * applications that interact with token contracts will not expect
838      * {decimals} to ever change, and may work incorrectly if it does.
839      */
840     function _setupDecimals(uint8 decimals_) internal {
841         _decimals = decimals_;
842     }
843 
844     /**
845      * @dev Hook that is called before any transfer of tokens. This includes
846      * minting and burning.
847      *
848      * Calling conditions:
849      *
850      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
851      * will be to transferred to `to`.
852      * - when `from` is zero, `amount` tokens will be minted for `to`.
853      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
854      * - `from` and `to` are never both zero.
855      *
856      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
857      */
858     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
859 }
860 
861 // Standard ERC20 token with mint and burn
862 contract ALDToken is ERC20("Aladdin Token", "ALD") {
863     address public governance;
864     mapping (address => bool) public isMinter;
865 
866     constructor () public {
867         governance = msg.sender;
868     }
869 
870     function setGovernance(address _governance) external {
871         require(msg.sender == governance, "!governance");
872         governance = _governance;
873     }
874 
875     function setMinter(address _minter, bool _status) external {
876         require(msg.sender == governance, "!governance");
877         isMinter[_minter] = _status;
878     }
879 
880     /// @notice Creates `_amount` token to `_to`. Must only be called by minter
881     function mint(address _to, uint256 _amount) external {
882         require(isMinter[msg.sender] == true, "!minter");
883         _mint(_to, _amount);
884     }
885 
886     /// @notice Burn `_amount` token from `_from`. Must only be called by governance
887     function burn(address _from, uint256 _amount) external {
888         require(msg.sender == governance, "!governance");
889         _burn(_from, _amount);
890     }
891 }
892 
893 contract TokenMaster is Ownable, ReentrancyGuard {
894     using SafeMath for uint256;
895     using SafeERC20 for IERC20;
896 
897     // Info of each user.
898     struct UserInfo {
899         uint256 amount; // How many LP tokens the user has provided.
900         uint256 rewardDebt; // Reward debt. See explanation below.
901         //
902         // We do some fancy math here. Basically, any point in time, the amount of ALDs
903         // entitled to a user but is pending to be distributed is:
904         //
905         //   pending reward = (user.amount * pool.accALDPerShare) - user.rewardDebt
906         //
907         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
908         //   1. The pool's `accALDPerShare` (and `lastRewardBlock`) gets updated.
909         //   2. User receives the pending reward sent to his/her address.
910         //   3. User's `amount` gets updated.
911         //   4. User's `rewardDebt` gets updated.
912     }
913 
914     // Info of each pool.
915     struct PoolInfo {
916         address token; // Address of LP token contract.
917         uint256 allocPoint; // How many allocation points assigned to this pool. ALDs to distribute per block.
918         uint256 lastRewardBlock; // Last block number that ALDs distribution occurs.
919         uint256 accALDPerShare; // Accumulated ALDs per share, times 1e18. See below.
920     }
921 
922     // The ALD TOKEN!
923     ALDToken public ald;
924     // Token distributor address
925     address public tokenDistributor;
926     // token distributor reward allocation = total reward emission * tokenDistributorAllocNume / tokenDistributorAllocDenom
927     uint256 public tokenDistributorAllocNume = 7070;
928     uint256 constant public tokenDistributorAllocDenom = 10000;
929     // ALD tokens created per block.
930     uint256 public aldPerBlock;
931     // mapping of token to pool id
932     mapping(address => uint) public tokenToPid;
933     // Info of each pool.
934     PoolInfo[] public poolInfo;
935     // Info of each user that stakes LP tokens.
936     mapping(uint => mapping(address => UserInfo)) public userInfo;
937     // Total allocation poitns. Must be the sum of all allocation points in all pools.
938     uint256 public totalAllocPoint = 0;
939     // The block number when ALD mining starts.
940     uint256 public startBlock;
941 
942     /* ========== CONSTRUCTOR ========== */
943 
944     constructor(
945         ALDToken _ald,
946         address _tokenDistributor,
947         uint256 _aldPerBlock,
948         uint256 _startBlock
949     ) public {
950         ald = _ald;
951         tokenDistributor = _tokenDistributor;
952         aldPerBlock = _aldPerBlock;
953         startBlock = _startBlock;
954     }
955 
956     /* ========== VIEW FUNCTIONS ========== */
957 
958     function userBalanceForPool(address _user, address _poolToken) external view returns (uint256) {
959         uint pid = tokenToPid[_poolToken];
960         if (pid == 0) {
961           // pool does not exist
962           return 0;
963         }
964         UserInfo storage user = userInfo[pid][_user];
965         return user.amount;
966     }
967 
968     function poolLength() external view returns (uint256) {
969         return poolInfo.length;
970     }
971 
972     // View function to see pending ALDs on frontend.
973     function pendingALD(address _token, address _user) onlyValidPool(_token) external view returns (uint256) {
974         uint pid = tokenToPid[_token];
975         PoolInfo storage pool = poolInfo[pid - 1];
976         UserInfo storage user = userInfo[pid][_user];
977         uint256 accALDPerShare = pool.accALDPerShare;
978         uint256 lpSupply = IERC20(pool.token).balanceOf(address(this));
979         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
980             uint256 aldReward = aldPerBlock.mul(block.number.sub(pool.lastRewardBlock))
981                                              .mul(pool.allocPoint)
982                                              .div(totalAllocPoint);
983             uint256 distributorReward = aldReward.mul(tokenDistributorAllocNume).div(tokenDistributorAllocDenom);
984             uint256 poolReward = aldReward.sub(distributorReward);
985             accALDPerShare = accALDPerShare.add(poolReward.mul(1e18).div(lpSupply));
986         }
987         return user.amount.mul(accALDPerShare).div(1e18).sub(user.rewardDebt);
988     }
989 
990     /* ========== MUTATIVE FUNCTIONS ========== */
991 
992     // Update reward vairables for all pools. Be careful of gas spending!
993     function massUpdatePools() public {
994         uint256 length = poolInfo.length;
995         for (uint256 pid = 1; pid <= length; ++pid) {
996             PoolInfo storage pool = poolInfo[pid - 1];
997             updatePool(pool.token);
998         }
999     }
1000 
1001     // Update reward variables of the given pool to be up-to-date.
1002     function updatePool(address _token) onlyValidPool(_token) public {
1003         uint pid = tokenToPid[_token];
1004         PoolInfo storage pool = poolInfo[pid - 1];
1005         if (block.number <= pool.lastRewardBlock) {
1006             return;
1007         }
1008         uint256 lpSupply = IERC20(pool.token).balanceOf(address(this));
1009         if (lpSupply == 0) {
1010             pool.lastRewardBlock = block.number;
1011             return;
1012         }
1013 
1014         // get total pool rewards in since last update
1015         uint256 aldReward = aldPerBlock.mul(block.number.sub(pool.lastRewardBlock))
1016                                          .mul(pool.allocPoint)
1017                                          .div(totalAllocPoint);
1018 
1019         // mint distributor portion
1020         uint256 distributorReward = aldReward.mul(tokenDistributorAllocNume).div(tokenDistributorAllocDenom);
1021         ald.mint(tokenDistributor, distributorReward);
1022 
1023         // update pool rewards
1024         uint256 poolReward = aldReward.sub(distributorReward);
1025         ald.mint(address(this), poolReward);
1026         pool.accALDPerShare = pool.accALDPerShare.add(
1027             poolReward.mul(1e18).div(lpSupply)
1028         );
1029         pool.lastRewardBlock = block.number;
1030     }
1031 
1032     // Deposit LP tokens for ALD allocation.
1033     function deposit(address _token, uint256 _amount) onlyValidPool(_token) external nonReentrant {
1034         uint pid = tokenToPid[_token];
1035         PoolInfo storage pool = poolInfo[pid - 1];
1036         UserInfo storage user = userInfo[pid][msg.sender];
1037         updatePool(pool.token);
1038         if (user.amount > 0) {
1039             uint256 pending = user.amount.mul(pool.accALDPerShare).div(1e18).sub(user.rewardDebt);
1040             if(pending > 0) {
1041                 safeALDTransferToStaker(msg.sender, pending);
1042             }
1043         }
1044         if(_amount > 0) {
1045             IERC20(pool.token).safeTransferFrom(address(msg.sender), address(this),_amount);
1046             user.amount = user.amount.add(_amount);
1047         }
1048         user.rewardDebt = user.amount.mul(pool.accALDPerShare).div(1e18);
1049         emit Deposit(msg.sender, _token, _amount);
1050     }
1051 
1052     // Withdraw LP tokens.
1053     function withdraw(address _token, uint256 _amount) onlyValidPool(_token) external {
1054         uint pid = tokenToPid[_token];
1055         PoolInfo storage pool = poolInfo[pid - 1];
1056         UserInfo storage user = userInfo[pid][msg.sender];
1057         require(user.amount >= _amount, "withdraw: not good");
1058         updatePool(pool.token);
1059         uint256 pending = user.amount.mul(pool.accALDPerShare).div(1e18).sub(user.rewardDebt);
1060         if(pending > 0) {
1061             safeALDTransferToStaker(msg.sender, pending);
1062         }
1063         if(_amount > 0) {
1064             user.amount = user.amount.sub(_amount);
1065             IERC20(pool.token).safeTransfer(address(msg.sender), _amount);
1066         }
1067         user.rewardDebt = user.amount.mul(pool.accALDPerShare).div(1e18);
1068         emit Withdraw(msg.sender, _token, _amount);
1069     }
1070 
1071     // Claim pending rewards for all pools
1072     function claimAll() external {
1073         massUpdatePools();
1074         uint256 pending;
1075         for (uint pid = 1; pid <= poolInfo.length; pid++) {
1076             PoolInfo storage pool = poolInfo[pid - 1];
1077             UserInfo storage user = userInfo[pid][msg.sender];
1078             if (user.amount > 0) {
1079                 pending = pending.add(user.amount.mul(pool.accALDPerShare).div(1e18).sub(user.rewardDebt));
1080                 user.rewardDebt = user.amount.mul(pool.accALDPerShare).div(1e18);
1081             }
1082         }
1083         if (pending > 0) {
1084             safeALDTransferToStaker(msg.sender, pending);
1085         }
1086     }
1087 
1088     // Withdraw without caring about rewards. EMERGENCY ONLY.
1089     function emergencyWithdraw(address _token) onlyValidPool(_token) external nonReentrant {
1090         uint pid = tokenToPid[_token];
1091         PoolInfo storage pool = poolInfo[pid - 1];
1092         UserInfo storage user = userInfo[pid][msg.sender];
1093         user.amount = 0;
1094         user.rewardDebt = 0;
1095         IERC20(pool.token).safeTransfer(address(msg.sender), user.amount);
1096         emit EmergencyWithdraw(msg.sender, _token, user.amount);
1097     }
1098 
1099     // Safe ald transfer function, just in case if rounding error causes pool to not have enough ALDs.
1100     function safeALDTransferToStaker(address _user, uint256 _amount) internal {
1101         uint256 aldBal = ald.balanceOf(address(this));
1102         if (_amount > aldBal) {
1103             ald.transfer(_user, aldBal);
1104         } else {
1105             ald.transfer(_user, _amount);
1106         }
1107     }
1108 
1109     /* ========== RESTRICTED FUNCTIONS ========== */
1110 
1111     // Add a new lp to the pool. Can only be called by the owner.
1112     function add(uint256 _allocPoint, address _token, bool _withUpdate) external onlyOwner checkDuplicatePool(_token) {
1113         if (_withUpdate) {
1114             massUpdatePools();
1115         }
1116         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1117         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1118         poolInfo.push(
1119             PoolInfo({
1120                 token: _token,
1121                 allocPoint: _allocPoint,
1122                 lastRewardBlock: lastRewardBlock,
1123                 accALDPerShare: 0
1124             })
1125         );
1126         tokenToPid[_token] = poolInfo.length; // pid 0 reserved for 'pool does not exist'
1127     }
1128 
1129     // Update the given pool's ALD allocation point. Can only be called by the owner.
1130     function set(address _token, uint256 _allocPoint) external onlyOwner onlyValidPool(_token){
1131         massUpdatePools();
1132         uint pid = tokenToPid[_token];
1133         totalAllocPoint = totalAllocPoint.sub(poolInfo[pid - 1].allocPoint).add(_allocPoint);
1134         poolInfo[pid - 1].allocPoint = _allocPoint;
1135     }
1136 
1137     function setALDPerBlock(uint256 _aldPerBlock) external onlyOwner {
1138         // mass update pools before updating reward rate to avoid changing pending rewards
1139         massUpdatePools();
1140         aldPerBlock = _aldPerBlock;
1141     }
1142 
1143     function setTokenDistributor(address _tokenDistributor) external onlyOwner {
1144         tokenDistributor = _tokenDistributor;
1145     }
1146 
1147     function setTokenDistributorAllocNume(uint256 _tokenDistributorAllocNume) external onlyOwner {
1148         require(_tokenDistributorAllocNume <= tokenDistributorAllocDenom, "Numerator cannot be larger than denominator");
1149         tokenDistributorAllocNume = _tokenDistributorAllocNume;
1150     }
1151 
1152     function setStartBlock(uint256 _startBlock) external onlyOwner {
1153         require(block.number < startBlock, "Cannot change startBlock after reward start");
1154         startBlock = _startBlock;
1155         // reinitialize lastRewardBlock of all existing pools (if any)
1156         uint256 length = poolInfo.length;
1157         for (uint256 pid = 1; pid <= length; ++pid) {
1158             PoolInfo storage pool = poolInfo[pid - 1];
1159             pool.lastRewardBlock = _startBlock;
1160         }
1161     }
1162 
1163     /* ========== MODIFIERS ========== */
1164 
1165     modifier onlyValidPool(address _token) {
1166         uint pid = tokenToPid[_token];
1167         require(pid != 0, "pool does not exist");
1168         _;
1169     }
1170 
1171     modifier checkDuplicatePool(address _token) {
1172         for (uint256 pid = 1; pid <= poolInfo.length; pid++) {
1173             require(poolInfo[pid - 1].token != _token,  "pool already exist");
1174         }
1175         _;
1176     }
1177 
1178     /* ========== EVENTS ========== */
1179 
1180     event Deposit(address indexed user, address indexed token, uint256 amount);
1181     event Withdraw(address indexed user, address indexed token, uint256 amount);
1182     event EmergencyWithdraw(address indexed user, address indexed token, uint256 amount);
1183 }