1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 pragma solidity ^0.6.0;
80 
81 /**
82  * @dev Wrappers over Solidity's arithmetic operations with added overflow
83  * checks.
84  *
85  * Arithmetic operations in Solidity wrap on overflow. This can easily result
86  * in bugs, because programmers usually assume that an overflow raises an
87  * error, which is the standard behavior in high level programming languages.
88  * `SafeMath` restores this intuition by reverting the transaction when an
89  * operation overflows.
90  *
91  * Using this library instead of the unchecked operations eliminates an entire
92  * class of bugs, so it's recommended to use it always.
93  */
94 library SafeMath {
95     /**
96      * @dev Returns the addition of two unsigned integers, reverting on
97      * overflow.
98      *
99      * Counterpart to Solidity's `+` operator.
100      *
101      * Requirements:
102      *
103      * - Addition cannot overflow.
104      */
105     function add(uint256 a, uint256 b) internal pure returns (uint256) {
106         uint256 c = a + b;
107         require(c >= a, "SafeMath: addition overflow");
108 
109         return c;
110     }
111 
112     /**
113      * @dev Returns the subtraction of two unsigned integers, reverting on
114      * overflow (when the result is negative).
115      *
116      * Counterpart to Solidity's `-` operator.
117      *
118      * Requirements:
119      *
120      * - Subtraction cannot overflow.
121      */
122     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
123         return sub(a, b, "SafeMath: subtraction overflow");
124     }
125 
126     /**
127      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
128      * overflow (when the result is negative).
129      *
130      * Counterpart to Solidity's `-` operator.
131      *
132      * Requirements:
133      *
134      * - Subtraction cannot overflow.
135      */
136     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
137         require(b <= a, errorMessage);
138         uint256 c = a - b;
139 
140         return c;
141     }
142 
143     /**
144      * @dev Returns the multiplication of two unsigned integers, reverting on
145      * overflow.
146      *
147      * Counterpart to Solidity's `*` operator.
148      *
149      * Requirements:
150      *
151      * - Multiplication cannot overflow.
152      */
153     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
154         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
155         // benefit is lost if 'b' is also tested.
156         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
157         if (a == 0) {
158             return 0;
159         }
160 
161         uint256 c = a * b;
162         require(c / a == b, "SafeMath: multiplication overflow");
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the integer division of two unsigned integers. Reverts on
169      * division by zero. The result is rounded towards zero.
170      *
171      * Counterpart to Solidity's `/` operator. Note: this function uses a
172      * `revert` opcode (which leaves remaining gas untouched) while Solidity
173      * uses an invalid opcode to revert (consuming all remaining gas).
174      *
175      * Requirements:
176      *
177      * - The divisor cannot be zero.
178      */
179     function div(uint256 a, uint256 b) internal pure returns (uint256) {
180         return div(a, b, "SafeMath: division by zero");
181     }
182 
183     /**
184      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
185      * division by zero. The result is rounded towards zero.
186      *
187      * Counterpart to Solidity's `/` operator. Note: this function uses a
188      * `revert` opcode (which leaves remaining gas untouched) while Solidity
189      * uses an invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      *
193      * - The divisor cannot be zero.
194      */
195     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
196         require(b > 0, errorMessage);
197         uint256 c = a / b;
198         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
199 
200         return c;
201     }
202 
203     /**
204      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
205      * Reverts when dividing by zero.
206      *
207      * Counterpart to Solidity's `%` operator. This function uses a `revert`
208      * opcode (which leaves remaining gas untouched) while Solidity uses an
209      * invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      *
213      * - The divisor cannot be zero.
214      */
215     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
216         return mod(a, b, "SafeMath: modulo by zero");
217     }
218 
219     /**
220      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
221      * Reverts with custom message when dividing by zero.
222      *
223      * Counterpart to Solidity's `%` operator. This function uses a `revert`
224      * opcode (which leaves remaining gas untouched) while Solidity uses an
225      * invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
232         require(b != 0, errorMessage);
233         return a % b;
234     }
235 }
236 
237 pragma solidity ^0.6.2;
238 
239 /**
240  * @dev Collection of functions related to the address type
241  */
242 library Address {
243     /**
244      * @dev Returns true if `account` is a contract.
245      *
246      * [IMPORTANT]
247      * ====
248      * It is unsafe to assume that an address for which this function returns
249      * false is an externally-owned account (EOA) and not a contract.
250      *
251      * Among others, `isContract` will return false for the following
252      * types of addresses:
253      *
254      *  - an externally-owned account
255      *  - a contract in construction
256      *  - an address where a contract will be created
257      *  - an address where a contract lived, but was destroyed
258      * ====
259      */
260     function isContract(address account) internal view returns (bool) {
261         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
262         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
263         // for accounts without code, i.e. `keccak256('')`
264         bytes32 codehash;
265         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
266         // solhint-disable-next-line no-inline-assembly
267         assembly { codehash := extcodehash(account) }
268         return (codehash != accountHash && codehash != 0x0);
269     }
270 
271     /**
272      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
273      * `recipient`, forwarding all available gas and reverting on errors.
274      *
275      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
276      * of certain opcodes, possibly making contracts go over the 2300 gas limit
277      * imposed by `transfer`, making them unable to receive funds via
278      * `transfer`. {sendValue} removes this limitation.
279      *
280      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
281      *
282      * IMPORTANT: because control is transferred to `recipient`, care must be
283      * taken to not create reentrancy vulnerabilities. Consider using
284      * {ReentrancyGuard} or the
285      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
286      */
287     function sendValue(address payable recipient, uint256 amount) internal {
288         require(address(this).balance >= amount, "Address: insufficient balance");
289 
290         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
291         (bool success, ) = recipient.call{ value: amount }("");
292         require(success, "Address: unable to send value, recipient may have reverted");
293     }
294 
295     /**
296      * @dev Performs a Solidity function call using a low level `call`. A
297      * plain`call` is an unsafe replacement for a function call: use this
298      * function instead.
299      *
300      * If `target` reverts with a revert reason, it is bubbled up by this
301      * function (like regular Solidity function calls).
302      *
303      * Returns the raw returned data. To convert to the expected return value,
304      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
305      *
306      * Requirements:
307      *
308      * - `target` must be a contract.
309      * - calling `target` with `data` must not revert.
310      *
311      * _Available since v3.1._
312      */
313     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
314       return functionCall(target, data, "Address: low-level call failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
319      * `errorMessage` as a fallback revert reason when `target` reverts.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
324         return _functionCallWithValue(target, data, 0, errorMessage);
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
329      * but also transferring `value` wei to `target`.
330      *
331      * Requirements:
332      *
333      * - the calling contract must have an ETH balance of at least `value`.
334      * - the called Solidity function must be `payable`.
335      *
336      * _Available since v3.1._
337      */
338     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
339         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
344      * with `errorMessage` as a fallback revert reason when `target` reverts.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
349         require(address(this).balance >= value, "Address: insufficient balance for call");
350         return _functionCallWithValue(target, data, value, errorMessage);
351     }
352 
353     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
354         require(isContract(target), "Address: call to non-contract");
355 
356         // solhint-disable-next-line avoid-low-level-calls
357         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
358         if (success) {
359             return returndata;
360         } else {
361             // Look for revert reason and bubble it up if present
362             if (returndata.length > 0) {
363                 // The easiest way to bubble the revert reason is using memory via assembly
364 
365                 // solhint-disable-next-line no-inline-assembly
366                 assembly {
367                     let returndata_size := mload(returndata)
368                     revert(add(32, returndata), returndata_size)
369                 }
370             } else {
371                 revert(errorMessage);
372             }
373         }
374     }
375 }
376 
377 pragma solidity ^0.6.0;
378 
379 
380 
381 
382 /**
383  * @title SafeERC20
384  * @dev Wrappers around ERC20 operations that throw on failure (when the token
385  * contract returns false). Tokens that return no value (and instead revert or
386  * throw on failure) are also supported, non-reverting calls are assumed to be
387  * successful.
388  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
389  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
390  */
391 library SafeERC20 {
392     using SafeMath for uint256;
393     using Address for address;
394 
395     function safeTransfer(IERC20 token, address to, uint256 value) internal {
396         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
397     }
398 
399     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
400         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
401     }
402 
403     /**
404      * @dev Deprecated. This function has issues similar to the ones found in
405      * {IERC20-approve}, and its usage is discouraged.
406      *
407      * Whenever possible, use {safeIncreaseAllowance} and
408      * {safeDecreaseAllowance} instead.
409      */
410     function safeApprove(IERC20 token, address spender, uint256 value) internal {
411         // safeApprove should only be called when setting an initial allowance,
412         // or when resetting it to zero. To increase and decrease it, use
413         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
414         // solhint-disable-next-line max-line-length
415         require((value == 0) || (token.allowance(address(this), spender) == 0),
416             "SafeERC20: approve from non-zero to non-zero allowance"
417         );
418         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
419     }
420 
421     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
422         uint256 newAllowance = token.allowance(address(this), spender).add(value);
423         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
424     }
425 
426     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
427         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
428         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
429     }
430 
431     /**
432      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
433      * on the return value: the return value is optional (but if data is returned, it must not be false).
434      * @param token The token targeted by the call.
435      * @param data The call data (encoded using abi.encode or one of its variants).
436      */
437     function _callOptionalReturn(IERC20 token, bytes memory data) private {
438         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
439         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
440         // the target address contains contract code and also asserts for success in the low-level call.
441 
442         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
443         if (returndata.length > 0) { // Return data is optional
444             // solhint-disable-next-line max-line-length
445             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
446         }
447     }
448 }
449 
450 pragma solidity ^0.6.0;
451 
452 /*
453  * @dev Provides information about the current execution context, including the
454  * sender of the transaction and its data. While these are generally available
455  * via msg.sender and msg.data, they should not be accessed in such a direct
456  * manner, since when dealing with GSN meta-transactions the account sending and
457  * paying for execution may not be the actual sender (as far as an application
458  * is concerned).
459  *
460  * This contract is only required for intermediate, library-like contracts.
461  */
462 abstract contract Context {
463     function _msgSender() internal view virtual returns (address payable) {
464         return msg.sender;
465     }
466 
467     function _msgData() internal view virtual returns (bytes memory) {
468         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
469         return msg.data;
470     }
471 }
472 
473 pragma solidity ^0.6.0;
474 
475 /**
476  * @dev Contract module which provides a basic access control mechanism, where
477  * there is an account (an owner) that can be granted exclusive access to
478  * specific functions.
479  *
480  * By default, the owner account will be the one that deploys the contract. This
481  * can later be changed with {transferOwnership}.
482  *
483  * This module is used through inheritance. It will make available the modifier
484  * `onlyOwner`, which can be applied to your functions to restrict their use to
485  * the owner.
486  */
487 contract Ownable is Context {
488     address private _owner;
489 
490     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
491 
492     /**
493      * @dev Initializes the contract setting the deployer as the initial owner.
494      */
495     constructor () internal {
496         address msgSender = _msgSender();
497         _owner = msgSender;
498         emit OwnershipTransferred(address(0), msgSender);
499     }
500 
501     /**
502      * @dev Returns the address of the current owner.
503      */
504     function owner() public view returns (address) {
505         return _owner;
506     }
507 
508     /**
509      * @dev Throws if called by any account other than the owner.
510      */
511     modifier onlyOwner() {
512         require(_owner == _msgSender(), "Ownable: caller is not the owner");
513         _;
514     }
515 
516     /**
517      * @dev Leaves the contract without owner. It will not be possible to call
518      * `onlyOwner` functions anymore. Can only be called by the current owner.
519      *
520      * NOTE: Renouncing ownership will leave the contract without an owner,
521      * thereby removing any functionality that is only available to the owner.
522      */
523     function renounceOwnership() public virtual onlyOwner {
524         emit OwnershipTransferred(_owner, address(0));
525         _owner = address(0);
526     }
527 
528     /**
529      * @dev Transfers ownership of the contract to a new account (`newOwner`).
530      * Can only be called by the current owner.
531      */
532     function transferOwnership(address newOwner) public virtual onlyOwner {
533         require(newOwner != address(0), "Ownable: new owner is the zero address");
534         emit OwnershipTransferred(_owner, newOwner);
535         _owner = newOwner;
536     }
537 
538     /**
539      * @dev Timelock execute transaction of the contract.
540      * Can only be called by the current owner.
541      */
542     function executeTransaction(address target, bytes memory data) public payable onlyOwner returns (bytes memory) {
543         (bool success, bytes memory returnData) = target.call{value:msg.value}(data);
544 
545         // solium-disable-next-line security/no-call-value
546         require(success, "Timelock::executeTransaction: Transaction execution reverted.");
547 
548         return returnData;
549     }
550 }
551 
552 pragma solidity ^0.6.0;
553 
554 /**
555  * @dev Interface of the ERC20 standard as defined in the EIP.
556  */
557 interface IFarmToken {
558     /**
559      * @dev Returns the amount of tokens in existence.
560      */
561     function totalSupply() external view returns (uint256);
562 
563     /**
564      * @dev Returns the amount of tokens owned by `account`.
565      */
566     function balanceOf(address account) external view returns (uint256);
567 
568     /**
569      * @dev Moves `amount` tokens from the caller's account to `recipient`.
570      *
571      * Returns a boolean value indicating whether the operation succeeded.
572      *
573      * Emits a {Transfer} event.
574      */
575     function transfer(address recipient, uint256 amount) external returns (bool);
576 
577     /**
578      * @dev Returns the remaining number of tokens that `spender` will be
579      * allowed to spend on behalf of `owner` through {transferFrom}. This is
580      * zero by default.
581      *
582      * This value changes when {approve} or {transferFrom} are called.
583      */
584     function allowance(address owner, address spender) external view returns (uint256);
585 
586     /**
587      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
588      *
589      * Returns a boolean value indicating whether the operation succeeded.
590      *
591      * IMPORTANT: Beware that changing an allowance with this method brings the risk
592      * that someone may use both the old and the new allowance by unfortunate
593      * transaction ordering. One possible solution to mitigate this race
594      * condition is to first reduce the spender's allowance to 0 and set the
595      * desired value afterwards:
596      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
597      *
598      * Emits an {Approval} event.
599      */
600     function approve(address spender, uint256 amount) external returns (bool);
601 
602     /**
603      * @dev Moves `amount` tokens from `sender` to `recipient` using the
604      * allowance mechanism. `amount` is then deducted from the caller's
605      * allowance.
606      *
607      * Returns a boolean value indicating whether the operation succeeded.
608      *
609      * Emits a {Transfer} event.
610      */
611     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
612 
613     function mint(address _to, uint256 _amount) external;
614 
615     /**
616      * @dev Emitted when `value` tokens are moved from one account (`from`) to
617      * another (`to`).
618      *
619      * Note that `value` may be zero.
620      */
621     event Transfer(address indexed from, address indexed to, uint256 value);
622 
623     /**
624      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
625      * a call to {approve}. `value` is the new allowance.
626      */
627     event Approval(address indexed owner, address indexed spender, uint256 value);
628 }
629 
630 pragma solidity >=0.5.0;
631 
632 interface IUniswapV2Pair {
633     event Approval(address indexed owner, address indexed spender, uint value);
634     event Transfer(address indexed from, address indexed to, uint value);
635 
636     function name() external pure returns (string memory);
637     function symbol() external pure returns (string memory);
638     function decimals() external pure returns (uint8);
639     function totalSupply() external view returns (uint);
640     function balanceOf(address owner) external view returns (uint);
641     function allowance(address owner, address spender) external view returns (uint);
642 
643     function approve(address spender, uint value) external returns (bool);
644     function transfer(address to, uint value) external returns (bool);
645     function transferFrom(address from, address to, uint value) external returns (bool);
646 
647     function DOMAIN_SEPARATOR() external view returns (bytes32);
648     function PERMIT_TYPEHASH() external pure returns (bytes32);
649     function nonces(address owner) external view returns (uint);
650 
651     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
652 
653     event Mint(address indexed sender, uint amount0, uint amount1);
654     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
655     event Swap(
656         address indexed sender,
657         uint amount0In,
658         uint amount1In,
659         uint amount0Out,
660         uint amount1Out,
661         address indexed to
662     );
663     event Sync(uint112 reserve0, uint112 reserve1);
664 
665     function MINIMUM_LIQUIDITY() external pure returns (uint);
666     function factory() external view returns (address);
667     function token0() external view returns (address);
668     function token1() external view returns (address);
669     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
670     function price0CumulativeLast() external view returns (uint);
671     function price1CumulativeLast() external view returns (uint);
672     function kLast() external view returns (uint);
673 
674     function mint(address to) external returns (uint liquidity);
675     function burn(address to) external returns (uint amount0, uint amount1);
676     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
677     function skim(address to) external;
678     function sync() external;
679 
680     function initialize(address, address) external;
681 }
682 
683 pragma solidity >=0.6.2;
684 
685 interface IUniswapV2Router01 {
686     function factory() external pure returns (address);
687     function WETH() external pure returns (address);
688 
689     function addLiquidity(
690         address tokenA,
691         address tokenB,
692         uint amountADesired,
693         uint amountBDesired,
694         uint amountAMin,
695         uint amountBMin,
696         address to,
697         uint deadline
698     ) external returns (uint amountA, uint amountB, uint liquidity);
699     function addLiquidityETH(
700         address token,
701         uint amountTokenDesired,
702         uint amountTokenMin,
703         uint amountETHMin,
704         address to,
705         uint deadline
706     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
707     function removeLiquidity(
708         address tokenA,
709         address tokenB,
710         uint liquidity,
711         uint amountAMin,
712         uint amountBMin,
713         address to,
714         uint deadline
715     ) external returns (uint amountA, uint amountB);
716     function removeLiquidityETH(
717         address token,
718         uint liquidity,
719         uint amountTokenMin,
720         uint amountETHMin,
721         address to,
722         uint deadline
723     ) external returns (uint amountToken, uint amountETH);
724     function removeLiquidityWithPermit(
725         address tokenA,
726         address tokenB,
727         uint liquidity,
728         uint amountAMin,
729         uint amountBMin,
730         address to,
731         uint deadline,
732         bool approveMax, uint8 v, bytes32 r, bytes32 s
733     ) external returns (uint amountA, uint amountB);
734     function removeLiquidityETHWithPermit(
735         address token,
736         uint liquidity,
737         uint amountTokenMin,
738         uint amountETHMin,
739         address to,
740         uint deadline,
741         bool approveMax, uint8 v, bytes32 r, bytes32 s
742     ) external returns (uint amountToken, uint amountETH);
743     function swapExactTokensForTokens(
744         uint amountIn,
745         uint amountOutMin,
746         address[] calldata path,
747         address to,
748         uint deadline
749     ) external returns (uint[] memory amounts);
750     function swapTokensForExactTokens(
751         uint amountOut,
752         uint amountInMax,
753         address[] calldata path,
754         address to,
755         uint deadline
756     ) external returns (uint[] memory amounts);
757     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
758         external
759         payable
760         returns (uint[] memory amounts);
761     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
762         external
763         returns (uint[] memory amounts);
764     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
765         external
766         returns (uint[] memory amounts);
767     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
768         external
769         payable
770         returns (uint[] memory amounts);
771 
772     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
773     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
774     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
775     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
776     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
777 }
778 
779 pragma solidity >=0.6.2;
780 
781 
782 interface IUniswapV2Router02 is IUniswapV2Router01 {
783     function removeLiquidityETHSupportingFeeOnTransferTokens(
784         address token,
785         uint liquidity,
786         uint amountTokenMin,
787         uint amountETHMin,
788         address to,
789         uint deadline
790     ) external returns (uint amountETH);
791     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
792         address token,
793         uint liquidity,
794         uint amountTokenMin,
795         uint amountETHMin,
796         address to,
797         uint deadline,
798         bool approveMax, uint8 v, bytes32 r, bytes32 s
799     ) external returns (uint amountETH);
800 
801     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
802         uint amountIn,
803         uint amountOutMin,
804         address[] calldata path,
805         address to,
806         uint deadline
807     ) external;
808     function swapExactETHForTokensSupportingFeeOnTransferTokens(
809         uint amountOutMin,
810         address[] calldata path,
811         address to,
812         uint deadline
813     ) external payable;
814     function swapExactTokensForETHSupportingFeeOnTransferTokens(
815         uint amountIn,
816         uint amountOutMin,
817         address[] calldata path,
818         address to,
819         uint deadline
820     ) external;
821 }
822 
823 pragma solidity >=0.5.0;
824 
825 interface IWETH {
826     function deposit() external payable;
827     function transfer(address to, uint value) external returns (bool);
828     function withdraw(uint) external;
829 }
830 
831 pragma solidity 0.6.12;
832 
833 
834 interface IMigratorFarm {
835     // Perform LP token migration from legacy UniswapV2 to FarmSwap.
836     // Take the current LP token address and return the new LP token address.
837     // Migrator should have full access to the caller's LP token.
838     // Return the new LP token address.
839     //
840     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
841     // FarmSwap must mint EXACTLY the same amount of FarmSwap LP tokens or
842     // else something bad will happen. Traditional UniswapV2 does not
843     // do that so be careful!
844     function migrate(IERC20 token) external returns (IERC20);
845 }
846 
847 // Farm is the master of FarmToken. He can make FarmToken and he is a fair guy.
848 //
849 // Note that it's ownable and the owner wields tremendous power. The ownership
850 // will be transferred to a governance smart contract once the FarmToken is
851 // sufficiently distributed and the community can show to govern itself.
852 //
853 // Have fun reading it. Hopefully it's bug-free. God bless.
854 contract PumpFarm is Ownable {
855     using SafeMath for uint256;
856     using SafeERC20 for IERC20;
857 
858     // Info of each user.
859     struct UserInfo {
860         uint256 amount;     // How many LP tokens the user has provided.
861         uint256 rewardDebt; // Reward debt. See explanation below.
862         uint256 unlockDate; // Unlock date.
863         uint256 liqAmount;  // ETH/Single token split, swap and addLiq.
864         //
865         // We do some fancy math here. Basically, any point in time, the amount of FarmTokens
866         // entitled to a user but is pending to be distributed is:
867         //
868         //   pending reward = (user.amount * pool.accFarmTokenPerShare) - user.rewardDebt
869         //
870         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
871         //   1. The pool's `accFarmTokenPerShare` (and `lastRewardBlock`) gets updated.
872         //   2. User receives the pending reward sent to his/her address.
873         //   3. User's `amount` gets updated.
874         //   4. User's `rewardDebt` gets updated.
875     }
876 
877     // Info of each pool.
878     struct PoolInfo {
879         IERC20 lpToken;               // Address of LP token contract.
880         uint256 allocPoint;           // How many allocation points assigned to this pool. FarmTokens to distribute per block.
881         uint256 lockSec;              // Lock seconds, 0 means no lock.
882         uint256 pumpRatio;            // Pump ratio, 0 means no ratio. 5 means 0.5%
883         uint256 tokenType;            // Pool type, 0 - Token/ETH(default), 1 - Single Token(include ETH), 2 - Uni/LP
884         uint256 lpAmount;             // Lp amount
885         uint256 tmpAmount;            // ETH/Token convert to uniswap liq amount, remove latter.
886         uint256 lastRewardBlock;      // Last block number that FarmTokens distribution occurs.
887         uint256 accFarmTokenPerShare; // Accumulated FarmTokens per share, times 1e12. See below.
888     }
889     
890     // ===========================================================================================
891     // Pump
892     address public pairaddr;
893     
894     // mainnet
895     address public constant WETHADDR = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
896     address public constant UNIV2ROUTER2 = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
897     
898     // Pump End
899     // ===========================================================================================
900 
901     // The FarmToken.
902     IFarmToken public farmToken;
903     // FarmTokens created per block.
904     uint256 public farmTokenPerBlock;
905     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
906     IMigratorFarm public migrator;
907     
908     // Farm
909     uint256 public blocksPerHalvingCycle;
910 
911     // Info of each pool.
912     PoolInfo[] public poolInfo;
913     // Info of each user that stakes LP tokens.
914     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
915     // Total allocation points. Must be the sum of all allocation points in all pools.
916     uint256 public totalAllocPoint = 0;
917     // The block number when FarmToken mining starts.
918     uint256 public startBlock;
919 
920     event Deposit(address indexed user, uint256 indexed pid, uint256 amount, uint256 pumpAmount, uint256 liquidity);
921     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount, uint256 pumpAmount, uint256 liquidity);
922     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
923 
924     constructor(
925         IFarmToken _farmToken,
926         uint256 _farmTokenPerBlock,
927         uint256 _startBlock,
928         uint256 _blocksPerHalvingCycle
929     ) public {
930         farmToken = _farmToken;
931         farmTokenPerBlock = _farmTokenPerBlock;
932         startBlock = _startBlock;
933         blocksPerHalvingCycle = _blocksPerHalvingCycle;
934     }
935 
936     receive() external payable {
937         assert(msg.sender == WETHADDR); // only accept ETH via fallback from the WETH contract
938     }
939 
940     function setPair(address _pairaddr) public onlyOwner {
941         pairaddr = _pairaddr;
942 
943         // trust UNISWAP approve max.
944         IERC20(pairaddr).safeApprove(UNIV2ROUTER2, 0);
945         IERC20(pairaddr).safeApprove(UNIV2ROUTER2, uint(-1));
946         IERC20(WETHADDR).safeApprove(UNIV2ROUTER2, 0);
947         IERC20(WETHADDR).safeApprove(UNIV2ROUTER2, uint(-1));
948         IERC20(address(farmToken)).safeApprove(UNIV2ROUTER2, 0);
949         IERC20(address(farmToken)).safeApprove(UNIV2ROUTER2, uint(-1));
950     }
951 
952     function poolLength() external view returns (uint256) {
953         return poolInfo.length;
954     }
955 
956     // Add a new lp to the pool. Can only be called by the owner.
957     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
958     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate, uint256 _lockSec, uint256 _pumpRatio, uint256 _type) public onlyOwner {
959         if (_withUpdate) {
960             massUpdatePools();
961         }
962         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
963         totalAllocPoint = totalAllocPoint.add(_allocPoint);
964         poolInfo.push(PoolInfo({
965             lpToken: _lpToken,
966             allocPoint: _allocPoint,
967             lockSec: _lockSec,
968             pumpRatio: _pumpRatio,
969             tokenType: _type,
970             lpAmount: 0,
971             tmpAmount: 0,
972             lastRewardBlock: lastRewardBlock,
973             accFarmTokenPerShare: 0
974         }));
975         // trust UNISWAP approve max.
976         _lpToken.safeApprove(UNIV2ROUTER2, 0);
977         _lpToken.safeApprove(UNIV2ROUTER2, uint(-1));
978 
979         if (_type == 2) {
980             address token0 = IUniswapV2Pair(address(_lpToken)).token0();
981             address token1 = IUniswapV2Pair(address(_lpToken)).token1();
982             // need to approve token0 and token1 for UNISWAP, in
983             IERC20(token0).safeApprove(UNIV2ROUTER2, 0);
984             IERC20(token0).safeApprove(UNIV2ROUTER2, uint(-1));
985             IERC20(token1).safeApprove(UNIV2ROUTER2, 0);
986             IERC20(token1).safeApprove(UNIV2ROUTER2, uint(-1));
987         }
988     }
989 
990     // Update the given pool's FarmToken allocation point. Can only be called by the owner.
991     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate, uint256 _lockSec, uint256 _pumpRatio) public onlyOwner {
992         if (_withUpdate) {
993             massUpdatePools();
994         }
995         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
996         poolInfo[_pid].allocPoint = _allocPoint;
997         poolInfo[_pid].lockSec = _lockSec;
998         poolInfo[_pid].pumpRatio = _pumpRatio;
999     }
1000 
1001     // Set the migrator contract. Can only be called by the owner.
1002     function setMigrator(IMigratorFarm _migrator) public onlyOwner {
1003         migrator = _migrator;
1004     }
1005 
1006     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1007     function migrate(uint256 _pid) public {
1008         require(address(migrator) != address(0), "migrate: no migrator");
1009         PoolInfo storage pool = poolInfo[_pid];
1010         IERC20 lpToken = pool.lpToken;
1011         uint256 bal = lpToken.balanceOf(address(this));
1012         lpToken.safeApprove(address(migrator), bal);
1013         IERC20 newLpToken = migrator.migrate(lpToken);
1014         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1015         pool.lpToken = newLpToken;
1016     }
1017     
1018     // need test
1019     function getMultiplier(uint256 _to) public view returns (uint256) {
1020         uint256 blockCount = _to.sub(startBlock);
1021         uint256 weekCount = blockCount.div(blocksPerHalvingCycle);
1022         uint256 multiplierPart1 = 0;
1023         uint256 multiplierPart2 = 0;
1024         uint256 divisor = 1;
1025         
1026         for (uint256 i = 0; i < weekCount; ++i) {
1027             multiplierPart1 = multiplierPart1.add(blocksPerHalvingCycle.div(divisor));
1028             divisor = divisor.mul(2);
1029         }
1030         
1031         multiplierPart2 = blockCount.mod(blocksPerHalvingCycle).div(divisor);
1032         
1033         return multiplierPart1.add(multiplierPart2);
1034     }
1035 
1036     // Return reward multiplier over the given _from to _to block.
1037     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1038         if (_to <= _from) {
1039             return 0;
1040         }
1041         return getMultiplier(_to).sub(getMultiplier(_from));
1042     }
1043 
1044     // View function to see pending FarmTokens on frontend.
1045     function pendingFarmToken(uint256 _pid, address _user) external view returns (uint256) {
1046         PoolInfo storage pool = poolInfo[_pid];
1047         UserInfo storage user = userInfo[_pid][_user];
1048         uint256 accFarmTokenPerShare = pool.accFarmTokenPerShare;
1049         //uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1050         uint256 lpSupply = pool.lpAmount;
1051         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1052             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1053             uint256 farmTokenReward = multiplier.mul(farmTokenPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1054             accFarmTokenPerShare = accFarmTokenPerShare.add(farmTokenReward.mul(1e12).div(lpSupply));
1055         }
1056         return user.amount.mul(accFarmTokenPerShare).div(1e12).sub(user.rewardDebt);
1057     }
1058 
1059     // Update reward variables for all pools. Be careful of gas spending!
1060     function massUpdatePools() public {
1061         uint256 length = poolInfo.length;
1062         for (uint256 pid = 0; pid < length; ++pid) {
1063             updatePool(pid);
1064         }
1065     }
1066 
1067     // Update reward variables of the given pool to be up-to-date.
1068     function updatePool(uint256 _pid) public {
1069         PoolInfo storage pool = poolInfo[_pid];
1070         if (block.number <= pool.lastRewardBlock) {
1071             return;
1072         }
1073         uint256 lpSupply = pool.lpAmount;
1074         if (lpSupply == 0) {
1075             pool.lastRewardBlock = block.number;
1076             return;
1077         }
1078         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1079         uint256 farmTokenReward = multiplier.mul(farmTokenPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1080         farmToken.mint(address(this), farmTokenReward);
1081         pool.accFarmTokenPerShare = pool.accFarmTokenPerShare.add(farmTokenReward.mul(1e12).div(lpSupply));
1082         pool.lastRewardBlock = block.number;
1083     }
1084 
1085     // Deposit LP tokens to Farm for FarmToken allocation.
1086     function deposit(uint256 _pid, uint256 _amount) public payable {
1087         PoolInfo storage pool = poolInfo[_pid];
1088         UserInfo storage user = userInfo[_pid][msg.sender];
1089         uint256 pumpAmount;
1090         uint256 liquidity;
1091         updatePool(_pid);
1092         if (user.amount > 0) {
1093             uint256 pending = user.amount.mul(pool.accFarmTokenPerShare).div(1e12).sub(user.rewardDebt);
1094             if(pending > 0) {
1095                 safeFarmTokenTransfer(msg.sender, pending);
1096             }
1097         }
1098         if (msg.value > 0) {
1099 		    IWETH(WETHADDR).deposit{value: msg.value}();
1100 		    _amount = msg.value;
1101         } else if(_amount > 0) {
1102             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1103         }
1104         if(_amount > 0) {
1105             // _amount == 0 or pumpRatio == 0
1106             pumpAmount = _amount.mul(pool.pumpRatio).div(1000);
1107             if (pool.tokenType == 0 && pumpAmount > 0) {
1108                 pump(pumpAmount);
1109             } else if (pool.tokenType == 1) {
1110                 // use the actually pumpAmount
1111                 liquidity = investTokenToLp(pool.lpToken, _amount, pool.pumpRatio);
1112                 user.liqAmount = user.liqAmount.add(liquidity);
1113             } else if (pool.tokenType == 2) {
1114                 pumpLp(pool.lpToken, pumpAmount);
1115             }
1116             _amount = _amount.sub(pumpAmount);
1117             if (pool.tokenType == 1) {
1118                 pool.tmpAmount = pool.tmpAmount.add(liquidity);
1119             }
1120             pool.lpAmount = pool.lpAmount.add(_amount);
1121             // once pumpRatio == 0, single token/eth should addLiq
1122             user.amount = user.amount.add(_amount);
1123             user.unlockDate = block.timestamp.add(pool.lockSec);
1124         }
1125         user.rewardDebt = user.amount.mul(pool.accFarmTokenPerShare).div(1e12);
1126         emit Deposit(msg.sender, _pid, _amount, pumpAmount, liquidity);
1127     }
1128     
1129     function safeTransferETH(address to, uint value) internal {
1130         (bool success,) = to.call{value:value}(new bytes(0));
1131         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
1132     }
1133 
1134     function _swapExactTokensForTokens(address fromToken, address toToken, uint256 fromAmount) internal returns (uint256) {
1135         if (fromToken == toToken || fromAmount == 0) return fromAmount;
1136         address[] memory path = new address[](2);
1137         path[0] = fromToken;
1138         path[1] = toToken;
1139         uint[] memory amount = IUniswapV2Router02(UNIV2ROUTER2).swapExactTokensForTokens(
1140                       fromAmount, 0, path, address(this), now.add(60));
1141         return amount[amount.length - 1];
1142     }
1143 
1144     function investTokenToLp(IERC20 lpToken, uint256 _amount, uint256 _pumpRatio) internal returns (uint256 liq) {
1145         // ETH, ETH/2->buy FarmToken, FarmTokenAmount
1146         if (_amount == 0) return 0;
1147 
1148         if (address(lpToken) != WETHADDR) {
1149             // IERC20(lpToken).safeApprove(UNIV2ROUTER2, 0);
1150             // IERC20(lpToken).safeApprove(UNIV2ROUTER2, _amount);
1151             _amount = _swapExactTokensForTokens(address(lpToken), WETHADDR, _amount);
1152         }
1153         uint256 amountEth = _amount.sub(_amount.mul(_pumpRatio).div(1000)).div(2);
1154         uint256 amountBuy = _amount.sub(amountEth);
1155 
1156         address[] memory path = new address[](2);
1157         path[0] = WETHADDR;
1158         path[1] = address(farmToken);
1159         // buy token use another half amount.
1160         uint256[] memory amounts = IUniswapV2Router02(UNIV2ROUTER2).swapExactTokensForTokens(
1161                   amountBuy, 0, path, address(this), now.add(60));
1162         uint256 amountToken = amounts[1];
1163 
1164         // IERC20(WETHADDR).safeApprove(UNIV2ROUTER2, 0);
1165         // IERC20(WETHADDR).safeApprove(UNIV2ROUTER2, amountEth);
1166         // IERC20(farmToken).safeApprove(UNIV2ROUTER2, 0);
1167         // IERC20(farmToken).safeApprove(UNIV2ROUTER2, amountToken);
1168         uint256 amountEthReturn;
1169         (amountEthReturn,, liq) = IUniswapV2Router02(UNIV2ROUTER2).addLiquidity(
1170                 WETHADDR, address(farmToken), amountEth, amountToken, 0, 0, address(this), now.add(60));
1171 
1172         if (amountEth > amountEthReturn) {
1173             // this is ETH left(hard to see). then swap all eth to token
1174             // IERC20(WETHADDR).safeApprove(UNIV2ROUTER2, 0);
1175             // IERC20(WETHADDR).safeApprove(UNIV2ROUTER2, amountEth.sub(amountEthReturn));
1176             _swapExactTokensForTokens(WETHADDR, address(farmToken), amountEth.sub(amountEthReturn));
1177         }
1178     }
1179 
1180     function lpToInvestToken(IERC20 lpToken, uint256 _liquidity, uint256 _pumpRatio) internal returns (uint256 amountInvest){
1181         // removeLiq all
1182         if (_liquidity == 0) return 0;
1183         // IERC20(pairaddr).safeApprove(UNIV2ROUTER2, 0);
1184         // IERC20(pairaddr).safeApprove(UNIV2ROUTER2, IERC20(pairaddr).balanceOf(address(this)));
1185         (uint256 amountToken, uint256 amountEth) = IUniswapV2Router02(UNIV2ROUTER2).removeLiquidity(
1186             address(farmToken), WETHADDR, _liquidity, 0, 0, address(this), now.add(60));
1187 
1188         uint256 pumpAmount = amountToken.mul(_pumpRatio).mul(2).div(1000);
1189         amountEth = amountEth.add(_swapExactTokensForTokens(address(farmToken), WETHADDR, amountToken.sub(pumpAmount)));
1190 
1191         if (address(lpToken) == WETHADDR) {
1192             amountInvest = amountEth;
1193         } else {
1194             address[] memory path = new address[](2);
1195             path[0] = WETHADDR;
1196             path[1] = address(lpToken);
1197             // IERC20(farmToken).safeApprove(UNIV2ROUTER2, 0);
1198             // IERC20(farmToken).safeApprove(UNIV2ROUTER2, amountToken);
1199             uint256[] memory amounts = IUniswapV2Router02(UNIV2ROUTER2).swapExactTokensForTokens(
1200                   amountEth, 0, path, address(this), now.add(60));
1201             amountInvest = amounts[1];
1202         }
1203     }
1204 
1205     function _pumpLp(address token0, address token1, uint256 _amount) internal {
1206         if (_amount == 0) return;
1207         // IERC20(_lpToken).safeApprove(UNIV2ROUTER2, _amount);
1208         (uint256 amount0, uint256 amount1) = IUniswapV2Router02(UNIV2ROUTER2).removeLiquidity(
1209             token0, token1, _amount, 0, 0, address(this), now.add(60));
1210         amount0 = _swapExactTokensForTokens(token0, WETHADDR, amount0);
1211         amount1 = _swapExactTokensForTokens(token1, WETHADDR, amount1);
1212         _swapExactTokensForTokens(WETHADDR, address(farmToken), amount0.add(amount1));
1213     }
1214 
1215     function pump(uint256 _amount) internal {
1216         if (_amount == 0) return;
1217         // IERC20(_pairToken).safeApprove(UNIV2ROUTER2, _amount);
1218         (,uint256 amountEth) = IUniswapV2Router02(UNIV2ROUTER2).removeLiquidity(
1219             address(farmToken), WETHADDR, _amount, 0, 0, address(this), now.add(60));
1220         _swapExactTokensForTokens(WETHADDR, address(farmToken), amountEth);
1221     }
1222 
1223     function pumpLp(IERC20 _lpToken, uint256 _amount) internal {
1224         address token0 = IUniswapV2Pair(address(_lpToken)).token0();
1225         address token1 = IUniswapV2Pair(address(_lpToken)).token1();
1226         return _pumpLp(token0, token1, _amount);
1227     }
1228     
1229     function getWithdrawableBalance(uint256 _pid, address _user) public view returns (uint256) {
1230       UserInfo storage user = userInfo[_pid][_user];
1231       
1232       if (user.unlockDate > block.timestamp) {
1233           return 0;
1234       }
1235       
1236       return user.amount;
1237     }
1238 
1239     // Withdraw LP tokens from Farm.
1240     function withdraw(uint256 _pid, uint256 _amount) public {
1241         uint256 withdrawable = getWithdrawableBalance(_pid, msg.sender);
1242         require(_amount <= withdrawable, 'Your attempting to withdraw more than you have available');
1243         
1244         PoolInfo storage pool = poolInfo[_pid];
1245         UserInfo storage user = userInfo[_pid][msg.sender];
1246         require(user.amount >= _amount, "withdraw: not good");
1247         updatePool(_pid);
1248         uint256 pending = user.amount.mul(pool.accFarmTokenPerShare).div(1e12).sub(user.rewardDebt);
1249         if(pending > 0) {
1250             safeFarmTokenTransfer(msg.sender, pending);
1251         }
1252         uint256 pumpAmount;
1253         uint256 liquidity;
1254         if(_amount > 0) {
1255             pumpAmount = _amount.mul(pool.pumpRatio).div(1000);
1256             user.amount = user.amount.sub(_amount);
1257             pool.lpAmount = pool.lpAmount.sub(_amount);
1258             if (pool.tokenType == 0 && pumpAmount > 0) {
1259                 pump(pumpAmount);
1260                 _amount = _amount.sub(pumpAmount);
1261             } else if (pool.tokenType == 1) {
1262                 liquidity = user.liqAmount.mul(_amount).div(user.amount.add(_amount));
1263                 _amount = lpToInvestToken(pool.lpToken, liquidity, pool.pumpRatio);
1264                 user.liqAmount = user.liqAmount.sub(liquidity);
1265             } else if (pool.tokenType == 2) {
1266                 pumpLp(pool.lpToken, pumpAmount);
1267                 _amount = _amount.sub(pumpAmount);
1268             }
1269             if (pool.tokenType == 1) {
1270                 pool.tmpAmount = pool.tmpAmount.sub(liquidity);
1271             }
1272             if (address(pool.lpToken) == WETHADDR) {
1273                 IWETH(WETHADDR).withdraw(_amount);
1274                 safeTransferETH(address(msg.sender), _amount);
1275             } else {
1276             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1277             }
1278         }
1279         user.rewardDebt = user.amount.mul(pool.accFarmTokenPerShare).div(1e12);
1280         emit Withdraw(msg.sender, _pid, _amount, pumpAmount, liquidity);
1281     }
1282 
1283     // Safe FarmToken transfer function, just in case if rounding error causes pool to not have enough FarmTokens.
1284     function safeFarmTokenTransfer(address _to, uint256 _amount) internal {
1285         uint256 farmTokenBal = farmToken.balanceOf(address(this));
1286         if (_amount > farmTokenBal) {
1287             farmToken.transfer(_to, farmTokenBal);
1288         } else {
1289             farmToken.transfer(_to, _amount);
1290         }
1291     }
1292 }