1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/GSN/Context.sol
2 
3 
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/access/Ownable.sol
29 
30 
31 
32 pragma solidity >=0.6.0 <0.8.0;
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor () {
55         address msgSender = _msgSender();
56         _owner = msgSender;
57         emit OwnershipTransferred(address(0), msgSender);
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(_owner == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         emit OwnershipTransferred(_owner, newOwner);
94         _owner = newOwner;
95     }
96 }
97 
98 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/utils/Address.sol
99 
100 
101 
102 pragma solidity >=0.6.2 <0.8.0;
103 
104 /**
105  * @dev Collection of functions related to the address type
106  */
107 library Address {
108     /**
109      * @dev Returns true if `account` is a contract.
110      *
111      * [IMPORTANT]
112      * ====
113      * It is unsafe to assume that an address for which this function returns
114      * false is an externally-owned account (EOA) and not a contract.
115      *
116      * Among others, `isContract` will return false for the following
117      * types of addresses:
118      *
119      *  - an externally-owned account
120      *  - a contract in construction
121      *  - an address where a contract will be created
122      *  - an address where a contract lived, but was destroyed
123      * ====
124      */
125     function isContract(address account) internal view returns (bool) {
126         // This method relies on extcodesize, which returns 0 for contracts in
127         // construction, since the code is only stored at the end of the
128         // constructor execution.
129 
130         uint256 size;
131         // solhint-disable-next-line no-inline-assembly
132         assembly { size := extcodesize(account) }
133         return size > 0;
134     }
135 
136     /**
137      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
138      * `recipient`, forwarding all available gas and reverting on errors.
139      *
140      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
141      * of certain opcodes, possibly making contracts go over the 2300 gas limit
142      * imposed by `transfer`, making them unable to receive funds via
143      * `transfer`. {sendValue} removes this limitation.
144      *
145      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
146      *
147      * IMPORTANT: because control is transferred to `recipient`, care must be
148      * taken to not create reentrancy vulnerabilities. Consider using
149      * {ReentrancyGuard} or the
150      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
151      */
152     function sendValue(address payable recipient, uint256 amount) internal {
153         require(address(this).balance >= amount, "Address: insufficient balance");
154 
155         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
156         (bool success, ) = recipient.call{ value: amount }("");
157         require(success, "Address: unable to send value, recipient may have reverted");
158     }
159 
160     /**
161      * @dev Performs a Solidity function call using a low level `call`. A
162      * plain`call` is an unsafe replacement for a function call: use this
163      * function instead.
164      *
165      * If `target` reverts with a revert reason, it is bubbled up by this
166      * function (like regular Solidity function calls).
167      *
168      * Returns the raw returned data. To convert to the expected return value,
169      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
170      *
171      * Requirements:
172      *
173      * - `target` must be a contract.
174      * - calling `target` with `data` must not revert.
175      *
176      * _Available since v3.1._
177      */
178     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
179       return functionCall(target, data, "Address: low-level call failed");
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
184      * `errorMessage` as a fallback revert reason when `target` reverts.
185      *
186      * _Available since v3.1._
187      */
188     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
189         return functionCallWithValue(target, data, 0, errorMessage);
190     }
191 
192     /**
193      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
194      * but also transferring `value` wei to `target`.
195      *
196      * Requirements:
197      *
198      * - the calling contract must have an ETH balance of at least `value`.
199      * - the called Solidity function must be `payable`.
200      *
201      * _Available since v3.1._
202      */
203     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
204         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
205     }
206 
207     /**
208      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
209      * with `errorMessage` as a fallback revert reason when `target` reverts.
210      *
211      * _Available since v3.1._
212      */
213     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
214         require(address(this).balance >= value, "Address: insufficient balance for call");
215         require(isContract(target), "Address: call to non-contract");
216 
217         // solhint-disable-next-line avoid-low-level-calls
218         (bool success, bytes memory returndata) = target.call{ value: value }(data);
219         return _verifyCallResult(success, returndata, errorMessage);
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
224      * but performing a static call.
225      *
226      * _Available since v3.3._
227      */
228     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
229         return functionStaticCall(target, data, "Address: low-level static call failed");
230     }
231 
232     /**
233      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
234      * but performing a static call.
235      *
236      * _Available since v3.3._
237      */
238     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
239         require(isContract(target), "Address: static call to non-contract");
240 
241         // solhint-disable-next-line avoid-low-level-calls
242         (bool success, bytes memory returndata) = target.staticcall(data);
243         return _verifyCallResult(success, returndata, errorMessage);
244     }
245 
246     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
247         if (success) {
248             return returndata;
249         } else {
250             // Look for revert reason and bubble it up if present
251             if (returndata.length > 0) {
252                 // The easiest way to bubble the revert reason is using memory via assembly
253 
254                 // solhint-disable-next-line no-inline-assembly
255                 assembly {
256                     let returndata_size := mload(returndata)
257                     revert(add(32, returndata), returndata_size)
258                 }
259             } else {
260                 revert(errorMessage);
261             }
262         }
263     }
264 }
265 
266 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/math/SafeMath.sol
267 
268 
269 
270 pragma solidity >=0.6.0 <0.8.0;
271 
272 /**
273  * @dev Wrappers over Solidity's arithmetic operations with added overflow
274  * checks.
275  *
276  * Arithmetic operations in Solidity wrap on overflow. This can easily result
277  * in bugs, because programmers usually assume that an overflow raises an
278  * error, which is the standard behavior in high level programming languages.
279  * `SafeMath` restores this intuition by reverting the transaction when an
280  * operation overflows.
281  *
282  * Using this library instead of the unchecked operations eliminates an entire
283  * class of bugs, so it's recommended to use it always.
284  */
285 library SafeMath {
286     /**
287      * @dev Returns the addition of two unsigned integers, reverting on
288      * overflow.
289      *
290      * Counterpart to Solidity's `+` operator.
291      *
292      * Requirements:
293      *
294      * - Addition cannot overflow.
295      */
296     function add(uint256 a, uint256 b) internal pure returns (uint256) {
297         uint256 c = a + b;
298         require(c >= a, "SafeMath: addition overflow");
299 
300         return c;
301     }
302 
303     /**
304      * @dev Returns the subtraction of two unsigned integers, reverting on
305      * overflow (when the result is negative).
306      *
307      * Counterpart to Solidity's `-` operator.
308      *
309      * Requirements:
310      *
311      * - Subtraction cannot overflow.
312      */
313     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
314         return sub(a, b, "SafeMath: subtraction overflow");
315     }
316 
317     /**
318      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
319      * overflow (when the result is negative).
320      *
321      * Counterpart to Solidity's `-` operator.
322      *
323      * Requirements:
324      *
325      * - Subtraction cannot overflow.
326      */
327     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
328         require(b <= a, errorMessage);
329         uint256 c = a - b;
330 
331         return c;
332     }
333 
334     /**
335      * @dev Returns the multiplication of two unsigned integers, reverting on
336      * overflow.
337      *
338      * Counterpart to Solidity's `*` operator.
339      *
340      * Requirements:
341      *
342      * - Multiplication cannot overflow.
343      */
344     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
345         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
346         // benefit is lost if 'b' is also tested.
347         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
348         if (a == 0) {
349             return 0;
350         }
351 
352         uint256 c = a * b;
353         require(c / a == b, "SafeMath: multiplication overflow");
354 
355         return c;
356     }
357 
358     /**
359      * @dev Returns the integer division of two unsigned integers. Reverts on
360      * division by zero. The result is rounded towards zero.
361      *
362      * Counterpart to Solidity's `/` operator. Note: this function uses a
363      * `revert` opcode (which leaves remaining gas untouched) while Solidity
364      * uses an invalid opcode to revert (consuming all remaining gas).
365      *
366      * Requirements:
367      *
368      * - The divisor cannot be zero.
369      */
370     function div(uint256 a, uint256 b) internal pure returns (uint256) {
371         return div(a, b, "SafeMath: division by zero");
372     }
373 
374     /**
375      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
376      * division by zero. The result is rounded towards zero.
377      *
378      * Counterpart to Solidity's `/` operator. Note: this function uses a
379      * `revert` opcode (which leaves remaining gas untouched) while Solidity
380      * uses an invalid opcode to revert (consuming all remaining gas).
381      *
382      * Requirements:
383      *
384      * - The divisor cannot be zero.
385      */
386     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
387         require(b > 0, errorMessage);
388         uint256 c = a / b;
389         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
390 
391         return c;
392     }
393 
394     /**
395      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
396      * Reverts when dividing by zero.
397      *
398      * Counterpart to Solidity's `%` operator. This function uses a `revert`
399      * opcode (which leaves remaining gas untouched) while Solidity uses an
400      * invalid opcode to revert (consuming all remaining gas).
401      *
402      * Requirements:
403      *
404      * - The divisor cannot be zero.
405      */
406     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
407         return mod(a, b, "SafeMath: modulo by zero");
408     }
409 
410     /**
411      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
412      * Reverts with custom message when dividing by zero.
413      *
414      * Counterpart to Solidity's `%` operator. This function uses a `revert`
415      * opcode (which leaves remaining gas untouched) while Solidity uses an
416      * invalid opcode to revert (consuming all remaining gas).
417      *
418      * Requirements:
419      *
420      * - The divisor cannot be zero.
421      */
422     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
423         require(b != 0, errorMessage);
424         return a % b;
425     }
426 }
427 
428 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/token/ERC20/IERC20.sol
429 
430 
431 
432 pragma solidity >=0.6.0 <0.8.0;
433 
434 /**
435  * @dev Interface of the ERC20 standard as defined in the EIP.
436  */
437 interface IERC20 {
438     /**
439      * @dev Returns the amount of tokens in existence.
440      */
441     function totalSupply() external view returns (uint256);
442 
443     /**
444      * @dev Returns the amount of tokens owned by `account`.
445      */
446     function balanceOf(address account) external view returns (uint256);
447 
448     /**
449      * @dev Moves `amount` tokens from the caller's account to `recipient`.
450      *
451      * Returns a boolean value indicating whether the operation succeeded.
452      *
453      * Emits a {Transfer} event.
454      */
455     function transfer(address recipient, uint256 amount) external returns (bool);
456 
457     /**
458      * @dev Returns the remaining number of tokens that `spender` will be
459      * allowed to spend on behalf of `owner` through {transferFrom}. This is
460      * zero by default.
461      *
462      * This value changes when {approve} or {transferFrom} are called.
463      */
464     function allowance(address owner, address spender) external view returns (uint256);
465 
466     /**
467      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
468      *
469      * Returns a boolean value indicating whether the operation succeeded.
470      *
471      * IMPORTANT: Beware that changing an allowance with this method brings the risk
472      * that someone may use both the old and the new allowance by unfortunate
473      * transaction ordering. One possible solution to mitigate this race
474      * condition is to first reduce the spender's allowance to 0 and set the
475      * desired value afterwards:
476      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
477      *
478      * Emits an {Approval} event.
479      */
480     function approve(address spender, uint256 amount) external returns (bool);
481 
482     /**
483      * @dev Moves `amount` tokens from `sender` to `recipient` using the
484      * allowance mechanism. `amount` is then deducted from the caller's
485      * allowance.
486      *
487      * Returns a boolean value indicating whether the operation succeeded.
488      *
489      * Emits a {Transfer} event.
490      */
491     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
492 
493     /**
494      * @dev Emitted when `value` tokens are moved from one account (`from`) to
495      * another (`to`).
496      *
497      * Note that `value` may be zero.
498      */
499     event Transfer(address indexed from, address indexed to, uint256 value);
500 
501     /**
502      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
503      * a call to {approve}. `value` is the new allowance.
504      */
505     event Approval(address indexed owner, address indexed spender, uint256 value);
506 }
507 
508 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.3.0/contracts/token/ERC20/SafeERC20.sol
509 
510 
511 
512 pragma solidity >=0.6.0 <0.8.0;
513 
514 
515 
516 
517 /**
518  * @title SafeERC20
519  * @dev Wrappers around ERC20 operations that throw on failure (when the token
520  * contract returns false). Tokens that return no value (and instead revert or
521  * throw on failure) are also supported, non-reverting calls are assumed to be
522  * successful.
523  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
524  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
525  */
526 library SafeERC20 {
527     using SafeMath for uint256;
528     using Address for address;
529 
530     function safeTransfer(IERC20 token, address to, uint256 value) internal {
531         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
532     }
533 
534     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
535         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
536     }
537 
538     /**
539      * @dev Deprecated. This function has issues similar to the ones found in
540      * {IERC20-approve}, and its usage is discouraged.
541      *
542      * Whenever possible, use {safeIncreaseAllowance} and
543      * {safeDecreaseAllowance} instead.
544      */
545     function safeApprove(IERC20 token, address spender, uint256 value) internal {
546         // safeApprove should only be called when setting an initial allowance,
547         // or when resetting it to zero. To increase and decrease it, use
548         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
549         // solhint-disable-next-line max-line-length
550         require((value == 0) || (token.allowance(address(this), spender) == 0),
551             "SafeERC20: approve from non-zero to non-zero allowance"
552         );
553         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
554     }
555 
556     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
557         uint256 newAllowance = token.allowance(address(this), spender).add(value);
558         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
559     }
560 
561     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
562         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
563         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
564     }
565 
566     /**
567      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
568      * on the return value: the return value is optional (but if data is returned, it must not be false).
569      * @param token The token targeted by the call.
570      * @param data The call data (encoded using abi.encode or one of its variants).
571      */
572     function _callOptionalReturn(IERC20 token, bytes memory data) private {
573         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
574         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
575         // the target address contains contract code and also asserts for success in the low-level call.
576 
577         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
578         if (returndata.length > 0) { // Return data is optional
579             // solhint-disable-next-line max-line-length
580             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
581         }
582     }
583 }
584 
585 // File: browser/wh.sol
586 
587 pragma solidity 0.7.6;
588 // SPDX-License-Identifier: GPL-3.0-or-later
589 
590 
591 
592 
593 contract WhiteheartInitialOffering is Ownable {
594     using SafeERC20 for IERC20;
595     using SafeMath for uint;
596 
597     event Claimed(address indexed account, uint userShare, uint whiteAmount);
598     event Received(address indexed account, uint amount);
599 
600     uint public constant START = 1608811932;
601     uint public constant END = START + 3 days;
602     uint public constant TOTAL_DISTRIBUTE_AMOUNT = 8_000e18;
603     uint public constant MINIMAL_PROVIDE_AMOUNT = 8 ether;
604     uint public totalProvided = 0;
605     
606     mapping(address => uint) public provided;
607     IERC20 public immutable WHITE;
608 
609     constructor(IERC20 white) {
610         WHITE = white;
611     }
612 
613     receive() external payable {
614         require(START <= block.timestamp, "The offering has not started yet");
615         require(block.timestamp <= END, "The offering has already ended");
616         totalProvided += msg.value;
617         provided[msg.sender] += msg.value;
618         emit Received(msg.sender, msg.value);
619     }
620 
621     function claim() external {
622         require(block.timestamp > END);
623         require(provided[msg.sender] > 0);
624 
625         uint userShare = provided[msg.sender];
626         provided[msg.sender] = 0;
627 
628         if(totalProvided >= MINIMAL_PROVIDE_AMOUNT) {
629             uint whiteAmount = TOTAL_DISTRIBUTE_AMOUNT
630                 .mul(userShare)
631                 .div(totalProvided);
632             WHITE.safeTransfer(msg.sender, whiteAmount);
633             emit Claimed(msg.sender, userShare, whiteAmount);
634         } else {
635             msg.sender.transfer(userShare);
636             emit Claimed(msg.sender, userShare, 0);
637         }
638     }
639 
640     function withdrawProvidedETH() external onlyOwner {
641         require(END < block.timestamp, "The offering must be completed");
642         require(
643             totalProvided >= MINIMAL_PROVIDE_AMOUNT,
644             "The required amount has not been provided!"
645         );
646         payable(owner()).transfer(address(this).balance);
647     }
648 
649     function withdrawWHITE() external onlyOwner {
650         require(END < block.timestamp, "The offering must be completed");
651         require(
652             totalProvided < MINIMAL_PROVIDE_AMOUNT,
653             "The required amount has been provided!"
654         );
655         WHITE.safeTransfer(owner(), WHITE.balanceOf(address(this)));
656     }
657 
658     function withdrawUnclaimedWHITE() external onlyOwner {
659         require(END + 5 days < block.timestamp, "Withdrawal unavailable yet");
660         WHITE.safeTransfer(owner(), WHITE.balanceOf(address(this)));
661     }
662 }