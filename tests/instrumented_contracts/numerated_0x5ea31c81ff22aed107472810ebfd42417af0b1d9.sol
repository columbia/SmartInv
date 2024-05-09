1 pragma solidity ^0.6.0;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP.
5  */
6 interface IERC20 {
7     /**
8      * @dev Returns the amount of tokens in existence.
9      */
10     function totalSupply() external view returns (uint256);
11 
12     /**
13      * @dev Returns the amount of tokens owned by `account`.
14      */
15     function balanceOf(address account) external view returns (uint256);
16 
17     /**
18      * @dev Moves `amount` tokens from the caller's account to `recipient`.
19      *
20      * Returns a boolean value indicating whether the operation succeeded.
21      *
22      * Emits a {Transfer} event.
23      */
24     function transfer(address recipient, uint256 amount)
25         external
26         returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender)
36         external
37         view
38         returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(
66         address sender,
67         address recipient,
68         uint256 amount
69     ) external returns (bool);
70 
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(
84         address indexed owner,
85         address indexed spender,
86         uint256 value
87     );
88 }
89 
90 /**
91  * @dev Wrappers over Solidity's arithmetic operations with added overflow
92  * checks.
93  *
94  * Arithmetic operations in Solidity wrap on overflow. This can easily result
95  * in bugs, because programmers usually assume that an overflow raises an
96  * error, which is the standard behavior in high level programming languages.
97  * `SafeMath` restores this intuition by reverting the transaction when an
98  * operation overflows.
99  *
100  * Using this library instead of the unchecked operations eliminates an entire
101  * class of bugs, so it's recommended to use it always.
102  */
103 library SafeMath {
104     /**
105      * @dev Returns the addition of two unsigned integers, reverting on
106      * overflow.
107      *
108      * Counterpart to Solidity's `+` operator.
109      *
110      * Requirements:
111      *
112      * - Addition cannot overflow.
113      */
114     function add(uint256 a, uint256 b) internal pure returns (uint256) {
115         uint256 c = a + b;
116         require(c >= a, "SafeMath: addition overflow");
117 
118         return c;
119     }
120 
121     /**
122      * @dev Returns the subtraction of two unsigned integers, reverting on
123      * overflow (when the result is negative).
124      *
125      * Counterpart to Solidity's `-` operator.
126      *
127      * Requirements:
128      *
129      * - Subtraction cannot overflow.
130      */
131     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
132         return sub(a, b, "SafeMath: subtraction overflow");
133     }
134 
135     /**
136      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
137      * overflow (when the result is negative).
138      *
139      * Counterpart to Solidity's `-` operator.
140      *
141      * Requirements:
142      *
143      * - Subtraction cannot overflow.
144      */
145     function sub(
146         uint256 a,
147         uint256 b,
148         string memory errorMessage
149     ) internal pure returns (uint256) {
150         require(b <= a, errorMessage);
151         uint256 c = a - b;
152 
153         return c;
154     }
155 
156     /**
157      * @dev Returns the multiplication of two unsigned integers, reverting on
158      * overflow.
159      *
160      * Counterpart to Solidity's `*` operator.
161      *
162      * Requirements:
163      *
164      * - Multiplication cannot overflow.
165      */
166     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
167         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
168         // benefit is lost if 'b' is also tested.
169         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
170         if (a == 0) {
171             return 0;
172         }
173 
174         uint256 c = a * b;
175         require(c / a == b, "SafeMath: multiplication overflow");
176 
177         return c;
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers. Reverts on
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
192     function div(uint256 a, uint256 b) internal pure returns (uint256) {
193         return div(a, b, "SafeMath: division by zero");
194     }
195 
196     /**
197      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
208     function div(
209         uint256 a,
210         uint256 b,
211         string memory errorMessage
212     ) internal pure returns (uint256) {
213         require(b > 0, errorMessage);
214         uint256 c = a / b;
215         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
216 
217         return c;
218     }
219 
220     /**
221      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
222      * Reverts when dividing by zero.
223      *
224      * Counterpart to Solidity's `%` operator. This function uses a `revert`
225      * opcode (which leaves remaining gas untouched) while Solidity uses an
226      * invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      *
230      * - The divisor cannot be zero.
231      */
232     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
233         return mod(a, b, "SafeMath: modulo by zero");
234     }
235 
236     /**
237      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
238      * Reverts with custom message when dividing by zero.
239      *
240      * Counterpart to Solidity's `%` operator. This function uses a `revert`
241      * opcode (which leaves remaining gas untouched) while Solidity uses an
242      * invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      *
246      * - The divisor cannot be zero.
247      */
248     function mod(
249         uint256 a,
250         uint256 b,
251         string memory errorMessage
252     ) internal pure returns (uint256) {
253         require(b != 0, errorMessage);
254         return a % b;
255     }
256 }
257 
258 // File: @openzeppelin/contracts/utils/Address.sol
259 
260 pragma solidity ^0.6.2;
261 
262 /**
263  * @dev Collection of functions related to the address type
264  */
265 library Address {
266     /**
267      * @dev Returns true if `account` is a contract.
268      *
269      * [IMPORTANT]
270      * ====
271      * It is unsafe to assume that an address for which this function returns
272      * false is an externally-owned account (EOA) and not a contract.
273      *
274      * Among others, `isContract` will return false for the following
275      * types of addresses:
276      *
277      *  - an externally-owned account
278      *  - a contract in construction
279      *  - an address where a contract will be created
280      *  - an address where a contract lived, but was destroyed
281      * ====
282      */
283     function isContract(address account) internal view returns (bool) {
284         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
285         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
286         // for accounts without code, i.e. `keccak256('')`
287         bytes32 codehash;
288 
289 
290             bytes32 accountHash
291          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
292         // solhint-disable-next-line no-inline-assembly
293         assembly {
294             codehash := extcodehash(account)
295         }
296         return (codehash != accountHash && codehash != 0x0);
297     }
298 
299     /**
300      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
301      * `recipient`, forwarding all available gas and reverting on errors.
302      *
303      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
304      * of certain opcodes, possibly making contracts go over the 2300 gas limit
305      * imposed by `transfer`, making them unable to receive funds via
306      * `transfer`. {sendValue} removes this limitation.
307      *
308      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
309      *
310      * IMPORTANT: because control is transferred to `recipient`, care must be
311      * taken to not create reentrancy vulnerabilities. Consider using
312      * {ReentrancyGuard} or the
313      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
314      */
315     function sendValue(address payable recipient, uint256 amount) internal {
316         require(
317             address(this).balance >= amount,
318             "Address: insufficient balance"
319         );
320 
321         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
322         (bool success, ) = recipient.call{value: amount}("");
323         require(
324             success,
325             "Address: unable to send value, recipient may have reverted"
326         );
327     }
328 
329     /**
330      * @dev Performs a Solidity function call using a low level `call`. A
331      * plain`call` is an unsafe replacement for a function call: use this
332      * function instead.
333      *
334      * If `target` reverts with a revert reason, it is bubbled up by this
335      * function (like regular Solidity function calls).
336      *
337      * Returns the raw returned data. To convert to the expected return value,
338      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
339      *
340      * Requirements:
341      *
342      * - `target` must be a contract.
343      * - calling `target` with `data` must not revert.
344      *
345      * _Available since v3.1._
346      */
347     function functionCall(address target, bytes memory data)
348         internal
349         returns (bytes memory)
350     {
351         return functionCall(target, data, "Address: low-level call failed");
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
356      * `errorMessage` as a fallback revert reason when `target` reverts.
357      *
358      * _Available since v3.1._
359      */
360     function functionCall(
361         address target,
362         bytes memory data,
363         string memory errorMessage
364     ) internal returns (bytes memory) {
365         return _functionCallWithValue(target, data, 0, errorMessage);
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
370      * but also transferring `value` wei to `target`.
371      *
372      * Requirements:
373      *
374      * - the calling contract must have an ETH balance of at least `value`.
375      * - the called Solidity function must be `payable`.
376      *
377      * _Available since v3.1._
378      */
379     function functionCallWithValue(
380         address target,
381         bytes memory data,
382         uint256 value
383     ) internal returns (bytes memory) {
384         return
385             functionCallWithValue(
386                 target,
387                 data,
388                 value,
389                 "Address: low-level call with value failed"
390             );
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
395      * with `errorMessage` as a fallback revert reason when `target` reverts.
396      *
397      * _Available since v3.1._
398      */
399     function functionCallWithValue(
400         address target,
401         bytes memory data,
402         uint256 value,
403         string memory errorMessage
404     ) internal returns (bytes memory) {
405         require(
406             address(this).balance >= value,
407             "Address: insufficient balance for call"
408         );
409         return _functionCallWithValue(target, data, value, errorMessage);
410     }
411 
412     function _functionCallWithValue(
413         address target,
414         bytes memory data,
415         uint256 weiValue,
416         string memory errorMessage
417     ) private returns (bytes memory) {
418         require(isContract(target), "Address: call to non-contract");
419 
420         // solhint-disable-next-line avoid-low-level-calls
421         (bool success, bytes memory returndata) = target.call{value: weiValue}(
422             data
423         );
424         if (success) {
425             return returndata;
426         } else {
427             // Look for revert reason and bubble it up if present
428             if (returndata.length > 0) {
429                 // The easiest way to bubble the revert reason is using memory via assembly
430 
431                 // solhint-disable-next-line no-inline-assembly
432                 assembly {
433                     let returndata_size := mload(returndata)
434                     revert(add(32, returndata), returndata_size)
435                 }
436             } else {
437                 revert(errorMessage);
438             }
439         }
440     }
441 }
442 
443 /**
444  * @title SafeERC20
445  * @dev Wrappers around ERC20 operations that throw on failure (when the token
446  * contract returns false). Tokens that return no value (and instead revert or
447  * throw on failure) are also supported, non-reverting calls are assumed to be
448  * successful.
449  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
450  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
451  */
452 library SafeERC20 {
453     using SafeMath for uint256;
454     using Address for address;
455 
456     function safeTransfer(
457         IERC20 token,
458         address to,
459         uint256 value
460     ) internal {
461         _callOptionalReturn(
462             token,
463             abi.encodeWithSelector(token.transfer.selector, to, value)
464         );
465     }
466 
467     function safeTransferFrom(
468         IERC20 token,
469         address from,
470         address to,
471         uint256 value
472     ) internal {
473         _callOptionalReturn(
474             token,
475             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
476         );
477     }
478 
479     /**
480      * @dev Deprecated. This function has issues similar to the ones found in
481      * {IERC20-approve}, and its usage is discouraged.
482      *
483      * Whenever possible, use {safeIncreaseAllowance} and
484      * {safeDecreaseAllowance} instead.
485      */
486     function safeApprove(
487         IERC20 token,
488         address spender,
489         uint256 value
490     ) internal {
491         // safeApprove should only be called when setting an initial allowance,
492         // or when resetting it to zero. To increase and decrease it, use
493         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
494         // solhint-disable-next-line max-line-length
495         require(
496             (value == 0) || (token.allowance(address(this), spender) == 0),
497             "SafeERC20: approve from non-zero to non-zero allowance"
498         );
499         _callOptionalReturn(
500             token,
501             abi.encodeWithSelector(token.approve.selector, spender, value)
502         );
503     }
504 
505     function safeIncreaseAllowance(
506         IERC20 token,
507         address spender,
508         uint256 value
509     ) internal {
510         uint256 newAllowance = token.allowance(address(this), spender).add(
511             value
512         );
513         _callOptionalReturn(
514             token,
515             abi.encodeWithSelector(
516                 token.approve.selector,
517                 spender,
518                 newAllowance
519             )
520         );
521     }
522 
523     function safeDecreaseAllowance(
524         IERC20 token,
525         address spender,
526         uint256 value
527     ) internal {
528         uint256 newAllowance = token.allowance(address(this), spender).sub(
529             value,
530             "SafeERC20: decreased allowance below zero"
531         );
532         _callOptionalReturn(
533             token,
534             abi.encodeWithSelector(
535                 token.approve.selector,
536                 spender,
537                 newAllowance
538             )
539         );
540     }
541 
542     /**
543      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
544      * on the return value: the return value is optional (but if data is returned, it must not be false).
545      * @param token The token targeted by the call.
546      * @param data The call data (encoded using abi.encode or one of its variants).
547      */
548     function _callOptionalReturn(IERC20 token, bytes memory data) private {
549         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
550         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
551         // the target address contains contract code and also asserts for success in the low-level call.
552 
553         bytes memory returndata = address(token).functionCall(
554             data,
555             "SafeERC20: low-level call failed"
556         );
557         if (returndata.length > 0) {
558             // Return data is optional
559             // solhint-disable-next-line max-line-length
560             require(
561                 abi.decode(returndata, (bool)),
562                 "SafeERC20: ERC20 operation did not succeed"
563             );
564         }
565     }
566 }
567 
568 // File: @openzeppelin/contracts/GSN/Context.sol
569 
570 pragma solidity ^0.6.0;
571 
572 /*
573  * @dev Provides information about the current execution context, including the
574  * sender of the transaction and its data. While these are generally available
575  * via msg.sender and msg.data, they should not be accessed in such a direct
576  * manner, since when dealing with GSN meta-transactions the account sending and
577  * paying for execution may not be the actual sender (as far as an application
578  * is concerned).
579  *
580  * This contract is only required for intermediate, library-like contracts.
581  */
582 abstract contract Context {
583     function _msgSender() internal virtual view returns (address payable) {
584         return msg.sender;
585     }
586 
587     function _msgData() internal virtual view returns (bytes memory) {
588         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
589         return msg.data;
590     }
591 }
592 
593 // File: @openzeppelin/contracts/access/Ownable.sol
594 
595 pragma solidity ^0.6.0;
596 
597 /**
598  * @dev Contract module which provides a basic access control mechanism, where
599  * there is an account (an owner) that can be granted exclusive access to
600  * specific functions.
601  *
602  * By default, the owner account will be the one that deploys the contract. This
603  * can later be changed with {transferOwnership}.
604  *
605  * This module is used through inheritance. It will make available the modifier
606  * `onlyOwner`, which can be applied to your functions to restrict their use to
607  * the owner.
608  */
609 contract Ownable is Context {
610     address private _owner;
611 
612     event OwnershipTransferred(
613         address indexed previousOwner,
614         address indexed newOwner
615     );
616 
617     /**
618      * @dev Initializes the contract setting the deployer as the initial owner.
619      */
620     constructor() internal {
621         address msgSender = _msgSender();
622         _owner = msgSender;
623         emit OwnershipTransferred(address(0), msgSender);
624     }
625 
626     /**
627      * @dev Returns the address of the current owner.
628      */
629     function owner() public view returns (address) {
630         return _owner;
631     }
632 
633     /**
634      * @dev Throws if called by any account other than the owner.
635      */
636     modifier onlyOwner() {
637         require(_owner == _msgSender(), "Ownable: caller is not the owner");
638         _;
639     }
640 
641     /**
642      * @dev Leaves the contract without owner. It will not be possible to call
643      * `onlyOwner` functions anymore. Can only be called by the current owner.
644      *
645      * NOTE: Renouncing ownership will leave the contract without an owner,
646      * thereby removing any functionality that is only available to the owner.
647      */
648     function renounceOwnership() public virtual onlyOwner {
649         emit OwnershipTransferred(_owner, address(0));
650         _owner = address(0);
651     }
652 
653     /**
654      * @dev Transfers ownership of the contract to a new account (`newOwner`).
655      * Can only be called by the current owner.
656      */
657     function transferOwnership(address newOwner) public virtual onlyOwner {
658         require(
659             newOwner != address(0),
660             "Ownable: new owner is the zero address"
661         );
662         emit OwnershipTransferred(_owner, newOwner);
663         _owner = newOwner;
664     }
665 }
666 
667 contract Defix_POOLX is Ownable {
668     using SafeMath for uint256;
669     using SafeERC20 for IERC20;
670     IERC20 public lpToken;
671     address public receiver;
672 
673     constructor(IERC20 _lptoken, address _receiver) public {
674         lpToken = _lptoken;
675         receiver = _receiver;
676     }
677 
678     function deposit(uint256 _amount) public {
679         lpToken.safeTransferFrom(address(msg.sender), receiver, _amount);
680     }
681 
682     function update_receiver(address _receiver) public onlyOwner {
683         receiver = _receiver;
684     }
685 }