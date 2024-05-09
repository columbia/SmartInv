1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.12;
4 
5 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
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
81 // File: @openzeppelin/contracts/math/SafeMath.sol
82 
83 /**
84  * @dev Wrappers over Solidity's arithmetic operations with added overflow
85  * checks.
86  *
87  * Arithmetic operations in Solidity wrap on overflow. This can easily result
88  * in bugs, because programmers usually assume that an overflow raises an
89  * error, which is the standard behavior in high level programming languages.
90  * `SafeMath` restores this intuition by reverting the transaction when an
91  * operation overflows.
92  *
93  * Using this library instead of the unchecked operations eliminates an entire
94  * class of bugs, so it's recommended to use it always.
95  */
96 library SafeMath {
97     /**
98      * @dev Returns the addition of two unsigned integers, reverting on
99      * overflow.
100      *
101      * Counterpart to Solidity's `+` operator.
102      *
103      * Requirements:
104      *
105      * - Addition cannot overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a, "SafeMath: addition overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the subtraction of two unsigned integers, reverting on
116      * overflow (when the result is negative).
117      *
118      * Counterpart to Solidity's `-` operator.
119      *
120      * Requirements:
121      *
122      * - Subtraction cannot overflow.
123      */
124     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125         return sub(a, b, "SafeMath: subtraction overflow");
126     }
127 
128     /**
129      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
130      * overflow (when the result is negative).
131      *
132      * Counterpart to Solidity's `-` operator.
133      *
134      * Requirements:
135      *
136      * - Subtraction cannot overflow.
137      */
138     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
139         require(b <= a, errorMessage);
140         uint256 c = a - b;
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the multiplication of two unsigned integers, reverting on
147      * overflow.
148      *
149      * Counterpart to Solidity's `*` operator.
150      *
151      * Requirements:
152      *
153      * - Multiplication cannot overflow.
154      */
155     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
156         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
157         // benefit is lost if 'b' is also tested.
158         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
159         if (a == 0) {
160             return 0;
161         }
162 
163         uint256 c = a * b;
164         require(c / a == b, "SafeMath: multiplication overflow");
165 
166         return c;
167     }
168 
169     /**
170      * @dev Returns the integer division of two unsigned integers. Reverts on
171      * division by zero. The result is rounded towards zero.
172      *
173      * Counterpart to Solidity's `/` operator. Note: this function uses a
174      * `revert` opcode (which leaves remaining gas untouched) while Solidity
175      * uses an invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      *
179      * - The divisor cannot be zero.
180      */
181     function div(uint256 a, uint256 b) internal pure returns (uint256) {
182         return div(a, b, "SafeMath: division by zero");
183     }
184 
185     /**
186      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
187      * division by zero. The result is rounded towards zero.
188      *
189      * Counterpart to Solidity's `/` operator. Note: this function uses a
190      * `revert` opcode (which leaves remaining gas untouched) while Solidity
191      * uses an invalid opcode to revert (consuming all remaining gas).
192      *
193      * Requirements:
194      *
195      * - The divisor cannot be zero.
196      */
197     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
198         require(b > 0, errorMessage);
199         uint256 c = a / b;
200         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
201 
202         return c;
203     }
204 
205     /**
206      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207      * Reverts when dividing by zero.
208      *
209      * Counterpart to Solidity's `%` operator. This function uses a `revert`
210      * opcode (which leaves remaining gas untouched) while Solidity uses an
211      * invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
218         return mod(a, b, "SafeMath: modulo by zero");
219     }
220 
221     /**
222      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223      * Reverts with custom message when dividing by zero.
224      *
225      * Counterpart to Solidity's `%` operator. This function uses a `revert`
226      * opcode (which leaves remaining gas untouched) while Solidity uses an
227      * invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
234         require(b != 0, errorMessage);
235         return a % b;
236     }
237 }
238 
239 // File: @openzeppelin/contracts/utils/Address.sol
240 
241 /**
242  * @dev Collection of functions related to the address type
243  */
244 library Address {
245     /**
246      * @dev Returns true if `account` is a contract.
247      *
248      * [IMPORTANT]
249      * ====
250      * It is unsafe to assume that an address for which this function returns
251      * false is an externally-owned account (EOA) and not a contract.
252      *
253      * Among others, `isContract` will return false for the following
254      * types of addresses:
255      *
256      *  - an externally-owned account
257      *  - a contract in construction
258      *  - an address where a contract will be created
259      *  - an address where a contract lived, but was destroyed
260      * ====
261      */
262     function isContract(address account) internal view returns (bool) {
263         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
264         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
265         // for accounts without code, i.e. `keccak256('')`
266         bytes32 codehash;
267         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
268         // solhint-disable-next-line no-inline-assembly
269         assembly { codehash := extcodehash(account) }
270         return (codehash != accountHash && codehash != 0x0);
271     }
272 
273     /**
274      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
275      * `recipient`, forwarding all available gas and reverting on errors.
276      *
277      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
278      * of certain opcodes, possibly making contracts go over the 2300 gas limit
279      * imposed by `transfer`, making them unable to receive funds via
280      * `transfer`. {sendValue} removes this limitation.
281      *
282      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
283      *
284      * IMPORTANT: because control is transferred to `recipient`, care must be
285      * taken to not create reentrancy vulnerabilities. Consider using
286      * {ReentrancyGuard} or the
287      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
288      */
289     function sendValue(address payable recipient, uint256 amount) internal {
290         require(address(this).balance >= amount, "Address: insufficient balance");
291 
292         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
293         (bool success, ) = recipient.call{ value: amount }("");
294         require(success, "Address: unable to send value, recipient may have reverted");
295     }
296 
297     /**
298      * @dev Performs a Solidity function call using a low level `call`. A
299      * plain`call` is an unsafe replacement for a function call: use this
300      * function instead.
301      *
302      * If `target` reverts with a revert reason, it is bubbled up by this
303      * function (like regular Solidity function calls).
304      *
305      * Returns the raw returned data. To convert to the expected return value,
306      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
307      *
308      * Requirements:
309      *
310      * - `target` must be a contract.
311      * - calling `target` with `data` must not revert.
312      *
313      * _Available since v3.1._
314      */
315     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
316       return functionCall(target, data, "Address: low-level call failed");
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
321      * `errorMessage` as a fallback revert reason when `target` reverts.
322      *
323      * _Available since v3.1._
324      */
325     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
326         return _functionCallWithValue(target, data, 0, errorMessage);
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
331      * but also transferring `value` wei to `target`.
332      *
333      * Requirements:
334      *
335      * - the calling contract must have an ETH balance of at least `value`.
336      * - the called Solidity function must be `payable`.
337      *
338      * _Available since v3.1._
339      */
340     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
341         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
346      * with `errorMessage` as a fallback revert reason when `target` reverts.
347      *
348      * _Available since v3.1._
349      */
350     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
351         require(address(this).balance >= value, "Address: insufficient balance for call");
352         return _functionCallWithValue(target, data, value, errorMessage);
353     }
354 
355     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
356         require(isContract(target), "Address: call to non-contract");
357 
358         // solhint-disable-next-line avoid-low-level-calls
359         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
360         if (success) {
361             return returndata;
362         } else {
363             // Look for revert reason and bubble it up if present
364             if (returndata.length > 0) {
365                 // The easiest way to bubble the revert reason is using memory via assembly
366 
367                 // solhint-disable-next-line no-inline-assembly
368                 assembly {
369                     let returndata_size := mload(returndata)
370                     revert(add(32, returndata), returndata_size)
371                 }
372             } else {
373                 revert(errorMessage);
374             }
375         }
376     }
377 }
378 
379 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
380 
381 /**
382  * @title SafeERC20
383  * @dev Wrappers around ERC20 operations that throw on failure (when the token
384  * contract returns false). Tokens that return no value (and instead revert or
385  * throw on failure) are also supported, non-reverting calls are assumed to be
386  * successful.
387  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
388  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
389  */
390 library SafeERC20 {
391     using SafeMath for uint256;
392     using Address for address;
393 
394     function safeTransfer(IERC20 token, address to, uint256 value) internal {
395         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
396     }
397 
398     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
399         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
400     }
401 
402     /**
403      * @dev Deprecated. This function has issues similar to the ones found in
404      * {IERC20-approve}, and its usage is discouraged.
405      *
406      * Whenever possible, use {safeIncreaseAllowance} and
407      * {safeDecreaseAllowance} instead.
408      */
409     function safeApprove(IERC20 token, address spender, uint256 value) internal {
410         // safeApprove should only be called when setting an initial allowance,
411         // or when resetting it to zero. To increase and decrease it, use
412         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
413         // solhint-disable-next-line max-line-length
414         require((value == 0) || (token.allowance(address(this), spender) == 0),
415             "SafeERC20: approve from non-zero to non-zero allowance"
416         );
417         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
418     }
419 
420     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
421         uint256 newAllowance = token.allowance(address(this), spender).add(value);
422         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
423     }
424 
425     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
426         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
427         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
428     }
429 
430     /**
431      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
432      * on the return value: the return value is optional (but if data is returned, it must not be false).
433      * @param token The token targeted by the call.
434      * @param data The call data (encoded using abi.encode or one of its variants).
435      */
436     function _callOptionalReturn(IERC20 token, bytes memory data) private {
437         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
438         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
439         // the target address contains contract code and also asserts for success in the low-level call.
440 
441         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
442         if (returndata.length > 0) { // Return data is optional
443             // solhint-disable-next-line max-line-length
444             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
445         }
446     }
447 }
448 
449 // File: @openzeppelin/contracts/GSN/Context.sol
450 
451 /*
452  * @dev Provides information about the current execution context, including the
453  * sender of the transaction and its data. While these are generally available
454  * via msg.sender and msg.data, they should not be accessed in such a direct
455  * manner, since when dealing with GSN meta-transactions the account sending and
456  * paying for execution may not be the actual sender (as far as an application
457  * is concerned).
458  *
459  * This contract is only required for intermediate, library-like contracts.
460  */
461 abstract contract Context {
462     function _msgSender() internal view virtual returns (address payable) {
463         return msg.sender;
464     }
465 
466     function _msgData() internal view virtual returns (bytes memory) {
467         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
468         return msg.data;
469     }
470 }
471 
472 // File: @openzeppelin/contracts/access/Ownable.sol
473 
474 /**
475  * @dev Contract module which provides a basic access control mechanism, where
476  * there is an account (an owner) that can be granted exclusive access to
477  * specific functions.
478  *
479  * By default, the owner account will be the one that deploys the contract. This
480  * can later be changed with {transferOwnership}.
481  *
482  * This module is used through inheritance. It will make available the modifier
483  * `onlyOwner`, which can be applied to your functions to restrict their use to
484  * the owner.
485  */
486 contract Ownable is Context {
487     address private _owner;
488 
489     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
490 
491     /**
492      * @dev Initializes the contract setting the deployer as the initial owner.
493      */
494     constructor () internal {
495         address msgSender = _msgSender();
496         _owner = msgSender;
497         emit OwnershipTransferred(address(0), msgSender);
498     }
499 
500     /**
501      * @dev Returns the address of the current owner.
502      */
503     function owner() public view returns (address) {
504         return _owner;
505     }
506 
507     /**
508      * @dev Throws if called by any account other than the owner.
509      */
510     modifier onlyOwner() {
511         require(_owner == _msgSender(), "Ownable: caller is not the owner");
512         _;
513     }
514 
515     /**
516      * @dev Leaves the contract without owner. It will not be possible to call
517      * `onlyOwner` functions anymore. Can only be called by the current owner.
518      *
519      * NOTE: Renouncing ownership will leave the contract without an owner,
520      * thereby removing any functionality that is only available to the owner.
521      */
522     function renounceOwnership() public virtual onlyOwner {
523         emit OwnershipTransferred(_owner, address(0));
524         _owner = address(0);
525     }
526 
527     /**
528      * @dev Transfers ownership of the contract to a new account (`newOwner`).
529      * Can only be called by the current owner.
530      */
531     function transferOwnership(address newOwner) public virtual onlyOwner {
532         require(newOwner != address(0), "Ownable: new owner is the zero address");
533         emit OwnershipTransferred(_owner, newOwner);
534         _owner = newOwner;
535     }
536 }
537 
538 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
539 
540 /**
541  * @dev Implementation of the {IERC20} interface.
542  *
543  * This implementation is agnostic to the way tokens are created. This means
544  * that a supply mechanism has to be added in a derived contract using {_mint}.
545  * For a generic mechanism see {ERC20PresetMinterPauser}.
546  *
547  * TIP: For a detailed writeup see our guide
548  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
549  * to implement supply mechanisms].
550  *
551  * We have followed general OpenZeppelin guidelines: functions revert instead
552  * of returning `false` on failure. This behavior is nonetheless conventional
553  * and does not conflict with the expectations of ERC20 applications.
554  *
555  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
556  * This allows applications to reconstruct the allowance for all accounts just
557  * by listening to said events. Other implementations of the EIP may not emit
558  * these events, as it isn't required by the specification.
559  *
560  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
561  * functions have been added to mitigate the well-known issues around setting
562  * allowances. See {IERC20-approve}.
563  */
564 contract ERC20 is Context, IERC20 {
565     using SafeMath for uint256;
566     using Address for address;
567 
568     mapping (address => uint256) private _balances;
569 
570     mapping (address => mapping (address => uint256)) private _allowances;
571 
572     uint256 private _totalSupply;
573 
574     string private _name;
575     string private _symbol;
576     uint8 private _decimals;
577 
578     /**
579      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
580      * a default value of 18.
581      *
582      * To select a different value for {decimals}, use {_setupDecimals}.
583      *
584      * All three of these values are immutable: they can only be set once during
585      * construction.
586      */
587     constructor (string memory name, string memory symbol) public {
588         _name = name;
589         _symbol = symbol;
590         _decimals = 18;
591     }
592 
593     /**
594      * @dev Returns the name of the token.
595      */
596     function name() public view returns (string memory) {
597         return _name;
598     }
599 
600     /**
601      * @dev Returns the symbol of the token, usually a shorter version of the
602      * name.
603      */
604     function symbol() public view returns (string memory) {
605         return _symbol;
606     }
607 
608     /**
609      * @dev Returns the number of decimals used to get its user representation.
610      * For example, if `decimals` equals `2`, a balance of `505` tokens should
611      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
612      *
613      * Tokens usually opt for a value of 18, imitating the relationship between
614      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
615      * called.
616      *
617      * NOTE: This information is only used for _display_ purposes: it in
618      * no way affects any of the arithmetic of the contract, including
619      * {IERC20-balanceOf} and {IERC20-transfer}.
620      */
621     function decimals() public view returns (uint8) {
622         return _decimals;
623     }
624 
625     /**
626      * @dev See {IERC20-totalSupply}.
627      */
628     function totalSupply() public view override returns (uint256) {
629         return _totalSupply;
630     }
631 
632     /**
633      * @dev See {IERC20-balanceOf}.
634      */
635     function balanceOf(address account) public view override returns (uint256) {
636         return _balances[account];
637     }
638 
639     /**
640      * @dev See {IERC20-transfer}.
641      *
642      * Requirements:
643      *
644      * - `recipient` cannot be the zero address.
645      * - the caller must have a balance of at least `amount`.
646      */
647     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
648         _transfer(_msgSender(), recipient, amount);
649         return true;
650     }
651 
652     /**
653      * @dev See {IERC20-allowance}.
654      */
655     function allowance(address owner, address spender) public view virtual override returns (uint256) {
656         return _allowances[owner][spender];
657     }
658 
659     /**
660      * @dev See {IERC20-approve}.
661      *
662      * Requirements:
663      *
664      * - `spender` cannot be the zero address.
665      */
666     function approve(address spender, uint256 amount) public virtual override returns (bool) {
667         _approve(_msgSender(), spender, amount);
668         return true;
669     }
670 
671     /**
672      * @dev See {IERC20-transferFrom}.
673      *
674      * Emits an {Approval} event indicating the updated allowance. This is not
675      * required by the EIP. See the note at the beginning of {ERC20};
676      *
677      * Requirements:
678      * - `sender` and `recipient` cannot be the zero address.
679      * - `sender` must have a balance of at least `amount`.
680      * - the caller must have allowance for ``sender``'s tokens of at least
681      * `amount`.
682      */
683     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
684         _transfer(sender, recipient, amount);
685         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
686         return true;
687     }
688 
689     /**
690      * @dev Atomically increases the allowance granted to `spender` by the caller.
691      *
692      * This is an alternative to {approve} that can be used as a mitigation for
693      * problems described in {IERC20-approve}.
694      *
695      * Emits an {Approval} event indicating the updated allowance.
696      *
697      * Requirements:
698      *
699      * - `spender` cannot be the zero address.
700      */
701     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
702         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
703         return true;
704     }
705 
706     /**
707      * @dev Atomically decreases the allowance granted to `spender` by the caller.
708      *
709      * This is an alternative to {approve} that can be used as a mitigation for
710      * problems described in {IERC20-approve}.
711      *
712      * Emits an {Approval} event indicating the updated allowance.
713      *
714      * Requirements:
715      *
716      * - `spender` cannot be the zero address.
717      * - `spender` must have allowance for the caller of at least
718      * `subtractedValue`.
719      */
720     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
721         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
722         return true;
723     }
724 
725     /**
726      * @dev Moves tokens `amount` from `sender` to `recipient`.
727      *
728      * This is internal function is equivalent to {transfer}, and can be used to
729      * e.g. implement automatic token fees, slashing mechanisms, etc.
730      *
731      * Emits a {Transfer} event.
732      *
733      * Requirements:
734      *
735      * - `sender` cannot be the zero address.
736      * - `recipient` cannot be the zero address.
737      * - `sender` must have a balance of at least `amount`.
738      */
739     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
740         require(sender != address(0), "ERC20: transfer from the zero address");
741         require(recipient != address(0), "ERC20: transfer to the zero address");
742 
743         _beforeTokenTransfer(sender, recipient, amount);
744 
745         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
746         _balances[recipient] = _balances[recipient].add(amount);
747         emit Transfer(sender, recipient, amount);
748     }
749 
750     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
751      * the total supply.
752      *
753      * Emits a {Transfer} event with `from` set to the zero address.
754      *
755      * Requirements
756      *
757      * - `to` cannot be the zero address.
758      */
759     function _mint(address account, uint256 amount) internal virtual {
760         require(account != address(0), "ERC20: mint to the zero address");
761 
762         _beforeTokenTransfer(address(0), account, amount);
763 
764         _totalSupply = _totalSupply.add(amount);
765         _balances[account] = _balances[account].add(amount);
766         emit Transfer(address(0), account, amount);
767     }
768 
769     /**
770      * @dev Destroys `amount` tokens from `account`, reducing the
771      * total supply.
772      *
773      * Emits a {Transfer} event with `to` set to the zero address.
774      *
775      * Requirements
776      *
777      * - `account` cannot be the zero address.
778      * - `account` must have at least `amount` tokens.
779      */
780     function _burn(address account, uint256 amount) internal virtual {
781         require(account != address(0), "ERC20: burn from the zero address");
782 
783         _beforeTokenTransfer(account, address(0), amount);
784 
785         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
786         _totalSupply = _totalSupply.sub(amount);
787         emit Transfer(account, address(0), amount);
788     }
789 
790     /**
791      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
792      *
793      * This is internal function is equivalent to `approve`, and can be used to
794      * e.g. set automatic allowances for certain subsystems, etc.
795      *
796      * Emits an {Approval} event.
797      *
798      * Requirements:
799      *
800      * - `owner` cannot be the zero address.
801      * - `spender` cannot be the zero address.
802      */
803     function _approve(address owner, address spender, uint256 amount) internal virtual {
804         require(owner != address(0), "ERC20: approve from the zero address");
805         require(spender != address(0), "ERC20: approve to the zero address");
806 
807         _allowances[owner][spender] = amount;
808         emit Approval(owner, spender, amount);
809     }
810 
811     /**
812      * @dev Sets {decimals} to a value other than the default one of 18.
813      *
814      * WARNING: This function should only be called from the constructor. Most
815      * applications that interact with token contracts will not expect
816      * {decimals} to ever change, and may work incorrectly if it does.
817      */
818     function _setupDecimals(uint8 decimals_) internal {
819         _decimals = decimals_;
820     }
821 
822     /**
823      * @dev Hook that is called before any transfer of tokens. This includes
824      * minting and burning.
825      *
826      * Calling conditions:
827      *
828      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
829      * will be to transferred to `to`.
830      * - when `from` is zero, `amount` tokens will be minted for `to`.
831      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
832      * - `from` and `to` are never both zero.
833      *
834      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
835      */
836     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
837 }
838 
839 // File: contracts/strategies/IStrategy.sol
840 
841 // Assume the strategy generates `TOKEN`.
842 interface IStrategy {
843 
844     function approve(IERC20 _token) external;
845 
846     function getValuePerShare(address _vault) external view returns(uint256);
847     function pendingValuePerShare(address _vault) external view returns (uint256);
848 
849     // Deposit tokens to a farm to yield more tokens.
850     function deposit(address _vault, uint256 _amount) external;
851 
852     // Claim the profit from a farm.
853     function claim(address _vault) external;
854 
855     // Withdraw the principal from a farm.
856     function withdraw(address _vault, uint256 _amount) external;
857 
858     // Target farming token of this strategy.
859     function getTargetToken() external view returns(address);
860 }
861 
862 // File: contracts/SodaMaster.sol
863 
864 /*
865 
866 Here we have a list of constants. In order to get access to an address
867 managed by SodaMaster, the calling contract should copy and define
868 some of these constants and use them as keys.
869 
870 Keys themselves are immutable. Addresses can be immutable or mutable.
871 
872 a) Vault addresses are immutable once set, and the list may grow:
873 
874 K_VAULT_WETH = 0;
875 K_VAULT_USDT_ETH_SUSHI_LP = 1;
876 K_VAULT_SOETH_ETH_UNI_V2_LP = 2;
877 K_VAULT_SODA_ETH_UNI_V2_LP = 3;
878 K_VAULT_GT = 4;
879 K_VAULT_GT_ETH_UNI_V2_LP = 5;
880 
881 
882 b) SodaMade token addresses are immutable once set, and the list may grow:
883 
884 K_MADE_SOETH = 0;
885 
886 
887 c) Strategy addresses are mutable:
888 
889 K_STRATEGY_CREATE_SODA = 0;
890 K_STRATEGY_EAT_SUSHI = 1;
891 K_STRATEGY_SHARE_REVENUE = 2;
892 
893 
894 d) Calculator addresses are mutable:
895 
896 K_CALCULATOR_WETH = 0;
897 
898 Solidity doesn't allow me to define global constants, so please
899 always make sure the key name and key value are copied as the same
900 in different contracts.
901 
902 */
903 
904 
905 // SodaMaster manages the addresses all the other contracts of the system.
906 // This contract is owned by Timelock.
907 contract SodaMaster is Ownable {
908 
909     address public pool;
910     address public bank;
911     address public revenue;
912     address public dev;
913 
914     address public soda;
915     address public wETH;
916     address public usdt;
917 
918     address public uniswapV2Factory;
919 
920     mapping(address => bool) public isVault;
921     mapping(uint256 => address) public vaultByKey;
922 
923     mapping(address => bool) public isSodaMade;
924     mapping(uint256 => address) public sodaMadeByKey;
925 
926     mapping(address => bool) public isStrategy;
927     mapping(uint256 => address) public strategyByKey;
928 
929     mapping(address => bool) public isCalculator;
930     mapping(uint256 => address) public calculatorByKey;
931 
932     // Immutable once set.
933     function setPool(address _pool) external onlyOwner {
934         require(pool == address(0));
935         pool = _pool;
936     }
937 
938     // Immutable once set.
939     // Bank owns all the SodaMade tokens.
940     function setBank(address _bank) external onlyOwner {
941         require(bank == address(0));
942         bank = _bank;
943     }
944 
945     // Mutable in case we want to upgrade this module.
946     function setRevenue(address _revenue) external onlyOwner {
947         revenue = _revenue;
948     }
949 
950     // Mutable in case we want to upgrade this module.
951     function setDev(address _dev) external onlyOwner {
952         dev = _dev;
953     }
954 
955     // Mutable, in case Uniswap has changed or we want to switch to sushi.
956     // The core systems, Pool and Bank, don't rely on Uniswap, so there is no risk.
957     function setUniswapV2Factory(address _uniswapV2Factory) external onlyOwner {
958         uniswapV2Factory = _uniswapV2Factory;
959     }
960 
961     // Immutable once set.
962     function setWETH(address _wETH) external onlyOwner {
963        require(wETH == address(0));
964        wETH = _wETH;
965     }
966 
967     // Immutable once set. Hopefully Tether is reliable.
968     // Even if it fails, not a big deal, we only used USDT to estimate APY.
969     function setUSDT(address _usdt) external onlyOwner {
970         require(usdt == address(0));
971         usdt = _usdt;
972     }
973  
974     // Immutable once set.
975     function setSoda(address _soda) external onlyOwner {
976         require(soda == address(0));
977         soda = _soda;
978     }
979 
980     // Immutable once added, and you can always add more.
981     function addVault(uint256 _key, address _vault) external onlyOwner {
982         require(vaultByKey[_key] == address(0), "vault: key is taken");
983 
984         isVault[_vault] = true;
985         vaultByKey[_key] = _vault;
986     }
987 
988     // Immutable once added, and you can always add more.
989     function addSodaMade(uint256 _key, address _sodaMade) external onlyOwner {
990         require(sodaMadeByKey[_key] == address(0), "sodaMade: key is taken");
991 
992         isSodaMade[_sodaMade] = true;
993         sodaMadeByKey[_key] = _sodaMade;
994     }
995 
996     // Mutable and removable.
997     function addStrategy(uint256 _key, address _strategy) external onlyOwner {
998         isStrategy[_strategy] = true;
999         strategyByKey[_key] = _strategy;
1000     }
1001 
1002     function removeStrategy(uint256 _key) external onlyOwner {
1003         isStrategy[strategyByKey[_key]] = false;
1004         delete strategyByKey[_key];
1005     }
1006 
1007     // Mutable and removable.
1008     function addCalculator(uint256 _key, address _calculator) external onlyOwner {
1009         isCalculator[_calculator] = true;
1010         calculatorByKey[_key] = _calculator;
1011     }
1012 
1013     function removeCalculator(uint256 _key) external onlyOwner {
1014         isCalculator[calculatorByKey[_key]] = false;
1015         delete calculatorByKey[_key];
1016     }
1017 }
1018 
1019 // File: contracts/tokens/SodaVault.sol
1020 
1021 // SodaVault is owned by Timelock
1022 contract SodaVault is ERC20, Ownable {
1023     using SafeMath for uint256;
1024 
1025     uint256 constant PER_SHARE_SIZE = 1e12;
1026 
1027     mapping (address => uint256) public lockedAmount;
1028     mapping (address => mapping(uint256 => uint256)) public rewards;
1029     mapping (address => mapping(uint256 => uint256)) public debts;
1030 
1031     IStrategy[] public strategies;
1032 
1033     SodaMaster public sodaMaster;
1034 
1035     constructor (SodaMaster _sodaMaster, string memory _name, string memory _symbol) ERC20(_name, _symbol) public  {
1036         sodaMaster = _sodaMaster;
1037     }
1038 
1039     function setStrategies(IStrategy[] memory _strategies) public onlyOwner {
1040         delete strategies;
1041         for (uint256 i = 0; i < _strategies.length; ++i) {
1042             strategies.push(_strategies[i]);
1043         }
1044     }
1045 
1046     function getStrategyCount() view public returns(uint count) {
1047         return strategies.length;
1048     }
1049 
1050     /// @notice Creates `_amount` token to `_to`. Must only be called by SodaPool.
1051     function mintByPool(address _to, uint256 _amount) public {
1052         require(_msgSender() == sodaMaster.pool(), "not pool");
1053 
1054         _deposit(_amount);
1055         _updateReward(_to);
1056         if (_amount > 0) {
1057             _mint(_to, _amount);
1058         }
1059         _updateDebt(_to);
1060     }
1061 
1062     // Must only be called by SodaPool.
1063     function burnByPool(address _account, uint256 _amount) public {
1064         require(_msgSender() == sodaMaster.pool(), "not pool");
1065 
1066         uint256 balance = balanceOf(_account);
1067         require(lockedAmount[_account] + _amount <= balance, "Vault: burn too much");
1068 
1069         _withdraw(_amount);
1070         _updateReward(_account);
1071         _burn(_account, _amount);
1072         _updateDebt(_account);
1073     }
1074 
1075     // Must only be called by SodaBank.
1076     function transferByBank(address _from, address _to, uint256 _amount) public {
1077         require(_msgSender() == sodaMaster.bank(), "not bank");
1078 
1079         uint256 balance = balanceOf(_from);
1080         require(lockedAmount[_from] + _amount <= balance);
1081 
1082         _claim();
1083         _updateReward(_from);
1084         _updateReward(_to);
1085         _transfer(_from, _to, _amount);
1086         _updateDebt(_to);
1087         _updateDebt(_from);
1088     }
1089 
1090     // Any user can transfer to another user.
1091     function transfer(address _to, uint256 _amount) public override returns (bool) {
1092         uint256 balance = balanceOf(_msgSender());
1093         require(lockedAmount[_msgSender()] + _amount <= balance, "transfer: <= balance");
1094 
1095         _updateReward(_msgSender());
1096         _updateReward(_to);
1097         _transfer(_msgSender(), _to, _amount);
1098         _updateDebt(_to);
1099         _updateDebt(_msgSender());
1100 
1101         return true;
1102     }
1103 
1104     // Must only be called by SodaBank.
1105     function lockByBank(address _account, uint256 _amount) public {
1106         require(_msgSender() == sodaMaster.bank(), "not bank");
1107 
1108         uint256 balance = balanceOf(_account);
1109         require(lockedAmount[_account] + _amount <= balance, "Vault: lock too much");
1110         lockedAmount[_account] += _amount;
1111     }
1112 
1113     // Must only be called by SodaBank.
1114     function unlockByBank(address _account, uint256 _amount) public {
1115         require(_msgSender() == sodaMaster.bank(), "not bank");
1116 
1117         require(_amount <= lockedAmount[_account], "Vault: unlock too much");
1118         lockedAmount[_account] -= _amount;
1119     }
1120 
1121     // Must only be called by SodaPool.
1122     function clearRewardByPool(address _who) public {
1123         require(_msgSender() == sodaMaster.pool(), "not pool");
1124 
1125         for (uint256 i = 0; i < strategies.length; ++i) {
1126             rewards[_who][i] = 0;
1127         }
1128     }
1129 
1130     function getPendingReward(address _who, uint256 _index) public view returns (uint256) {
1131         uint256 total = totalSupply();
1132         if (total == 0 || _index >= strategies.length) {
1133             return 0;
1134         }
1135 
1136         uint256 value = strategies[_index].getValuePerShare(address(this));
1137         uint256 pending = strategies[_index].pendingValuePerShare(address(this));
1138         uint256 balance = balanceOf(_who);
1139 
1140         return balance.mul(value.add(pending)).div(PER_SHARE_SIZE).sub(debts[_who][_index]);
1141     }
1142 
1143     function _deposit(uint256 _amount) internal {
1144         for (uint256 i = 0; i < strategies.length; ++i) {
1145             strategies[i].deposit(address(this), _amount);
1146         }
1147     }
1148 
1149     function _withdraw(uint256 _amount) internal {
1150         for (uint256 i = 0; i < strategies.length; ++i) {
1151             strategies[i].withdraw(address(this), _amount);
1152         }
1153     }
1154 
1155     function _claim() internal {
1156         for (uint256 i = 0; i < strategies.length; ++i) {
1157             strategies[i].claim(address(this));
1158         }
1159     }
1160 
1161     function _updateReward(address _who) internal {
1162         uint256 balance = balanceOf(_who);
1163         if (balance > 0) {
1164             for (uint256 i = 0; i < strategies.length; ++i) {
1165                 uint256 value = strategies[i].getValuePerShare(address(this));
1166                 rewards[_who][i] = rewards[_who][i].add(balance.mul(
1167                     value).div(PER_SHARE_SIZE).sub(debts[_who][i]));
1168             }
1169         }
1170     }
1171 
1172     function _updateDebt(address _who) internal {
1173         uint256 balance = balanceOf(_who);
1174         for (uint256 i = 0; i < strategies.length; ++i) {
1175             uint256 value = strategies[i].getValuePerShare(address(this));
1176             debts[_who][i] = balance.mul(value).div(PER_SHARE_SIZE);
1177         }
1178     }
1179 }
1180 
1181 // File: contracts/components/SodaPool.sol
1182 
1183 // This contract is owned by Timelock.
1184 contract SodaPool is Ownable {
1185     using SafeMath for uint256;
1186     using SafeERC20 for IERC20;
1187 
1188     // Info of each pool.
1189     struct PoolInfo {
1190         IERC20 token;           // Address of token contract.
1191         SodaVault vault;           // Address of vault contract.
1192         uint256 startTime;
1193     }
1194 
1195     // Info of each pool.
1196     mapping (uint256 => PoolInfo) public poolMap;  // By poolId
1197 
1198     event Deposit(address indexed user, uint256 indexed poolId, uint256 amount);
1199     event Withdraw(address indexed user, uint256 indexed poolId, uint256 amount);
1200     event Claim(address indexed user, uint256 indexed poolId);
1201 
1202     constructor() public {
1203     }
1204 
1205     function setPoolInfo(uint256 _poolId, IERC20 _token, SodaVault _vault, uint256 _startTime) public onlyOwner {
1206         poolMap[_poolId].token = _token;
1207         poolMap[_poolId].vault = _vault;
1208         poolMap[_poolId].startTime = _startTime;
1209     }
1210 
1211     function _handleDeposit(SodaVault _vault, IERC20 _token, uint256 _amount) internal {
1212         uint256 count = _vault.getStrategyCount();
1213         require(count == 1 || count == 2, "_handleDeposit: count");
1214 
1215         // NOTE: strategy0 is always the main strategy.
1216         address strategy0 = address(_vault.strategies(0));
1217         _token.safeTransferFrom(address(msg.sender), strategy0, _amount);
1218     }
1219 
1220     function _handleWithdraw(SodaVault _vault, IERC20 _token, uint256 _amount) internal {
1221         uint256 count = _vault.getStrategyCount();
1222         require(count == 1 || count == 2, "_handleWithdraw: count");
1223 
1224         address strategy0 = address(_vault.strategies(0));
1225         _token.safeTransferFrom(strategy0, address(msg.sender), _amount);
1226     }
1227 
1228     function _handleRewards(SodaVault _vault) internal {
1229         uint256 count = _vault.getStrategyCount();
1230 
1231         for (uint256 i = 0; i < count; ++i) {
1232             uint256 rewardPending = _vault.rewards(msg.sender, i);
1233             if (rewardPending > 0) {
1234                 IERC20(_vault.strategies(i).getTargetToken()).safeTransferFrom(
1235                     address(_vault.strategies(i)), msg.sender, rewardPending);
1236             }
1237         }
1238 
1239         _vault.clearRewardByPool(msg.sender);
1240     }
1241 
1242     // Deposit tokens to SodaPool for SODA allocation.
1243     // If we have a strategy, then tokens will be moved there.
1244     function deposit(uint256 _poolId, uint256 _amount) public {
1245         PoolInfo storage pool = poolMap[_poolId];
1246         require(now >= pool.startTime, "deposit: after startTime");
1247 
1248         _handleDeposit(pool.vault, pool.token, _amount);
1249         pool.vault.mintByPool(msg.sender, _amount);
1250 
1251         emit Deposit(msg.sender, _poolId, _amount);
1252     }
1253 
1254     // Claim SODA (and potentially other tokens depends on strategy).
1255     function claim(uint256 _poolId) public {
1256         PoolInfo storage pool = poolMap[_poolId];
1257         require(now >= pool.startTime, "claim: after startTime");
1258 
1259         pool.vault.mintByPool(msg.sender, 0);
1260         _handleRewards(pool.vault);
1261 
1262         emit Claim(msg.sender, _poolId);
1263     }
1264 
1265     // Withdraw tokens from SodaPool (from a strategy first if there is one).
1266     function withdraw(uint256 _poolId, uint256 _amount) public {
1267         PoolInfo storage pool = poolMap[_poolId];
1268         require(now >= pool.startTime, "withdraw: after startTime");
1269 
1270         pool.vault.burnByPool(msg.sender, _amount);
1271 
1272         _handleWithdraw(pool.vault, pool.token, _amount);
1273         _handleRewards(pool.vault);
1274 
1275         emit Withdraw(msg.sender, _poolId, _amount);
1276     }
1277 }