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
81 // File: @openzeppelin/contracts/math/SafeMath.sol
82 
83 
84 pragma solidity ^0.6.0;
85 
86 /**
87  * @dev Wrappers over Solidity's arithmetic operations with added overflow
88  * checks.
89  *
90  * Arithmetic operations in Solidity wrap on overflow. This can easily result
91  * in bugs, because programmers usually assume that an overflow raises an
92  * error, which is the standard behavior in high level programming languages.
93  * `SafeMath` restores this intuition by reverting the transaction when an
94  * operation overflows.
95  *
96  * Using this library instead of the unchecked operations eliminates an entire
97  * class of bugs, so it's recommended to use it always.
98  */
99 library SafeMath {
100     /**
101      * @dev Returns the addition of two unsigned integers, reverting on
102      * overflow.
103      *
104      * Counterpart to Solidity's `+` operator.
105      *
106      * Requirements:
107      *
108      * - Addition cannot overflow.
109      */
110     function add(uint256 a, uint256 b) internal pure returns (uint256) {
111         uint256 c = a + b;
112         require(c >= a, "SafeMath: addition overflow");
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the subtraction of two unsigned integers, reverting on
119      * overflow (when the result is negative).
120      *
121      * Counterpart to Solidity's `-` operator.
122      *
123      * Requirements:
124      *
125      * - Subtraction cannot overflow.
126      */
127     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128         return sub(a, b, "SafeMath: subtraction overflow");
129     }
130 
131     /**
132      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
133      * overflow (when the result is negative).
134      *
135      * Counterpart to Solidity's `-` operator.
136      *
137      * Requirements:
138      *
139      * - Subtraction cannot overflow.
140      */
141     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
142         require(b <= a, errorMessage);
143         uint256 c = a - b;
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the multiplication of two unsigned integers, reverting on
150      * overflow.
151      *
152      * Counterpart to Solidity's `*` operator.
153      *
154      * Requirements:
155      *
156      * - Multiplication cannot overflow.
157      */
158     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
159         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
160         // benefit is lost if 'b' is also tested.
161         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
162         if (a == 0) {
163             return 0;
164         }
165 
166         uint256 c = a * b;
167         require(c / a == b, "SafeMath: multiplication overflow");
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the integer division of two unsigned integers. Reverts on
174      * division by zero. The result is rounded towards zero.
175      *
176      * Counterpart to Solidity's `/` operator. Note: this function uses a
177      * `revert` opcode (which leaves remaining gas untouched) while Solidity
178      * uses an invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      *
182      * - The divisor cannot be zero.
183      */
184     function div(uint256 a, uint256 b) internal pure returns (uint256) {
185         return div(a, b, "SafeMath: division by zero");
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      *
198      * - The divisor cannot be zero.
199      */
200     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
201         require(b > 0, errorMessage);
202         uint256 c = a / b;
203         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
210      * Reverts when dividing by zero.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
221         return mod(a, b, "SafeMath: modulo by zero");
222     }
223 
224     /**
225      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
226      * Reverts with custom message when dividing by zero.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
237         require(b != 0, errorMessage);
238         return a % b;
239     }
240 }
241 
242 // File: @openzeppelin/contracts/utils/Address.sol
243 
244 
245 pragma solidity ^0.6.2;
246 
247 /**
248  * @dev Collection of functions related to the address type
249  */
250 library Address {
251     /**
252      * @dev Returns true if `account` is a contract.
253      *
254      * [IMPORTANT]
255      * ====
256      * It is unsafe to assume that an address for which this function returns
257      * false is an externally-owned account (EOA) and not a contract.
258      *
259      * Among others, `isContract` will return false for the following
260      * types of addresses:
261      *
262      *  - an externally-owned account
263      *  - a contract in construction
264      *  - an address where a contract will be created
265      *  - an address where a contract lived, but was destroyed
266      * ====
267      */
268     function isContract(address account) internal view returns (bool) {
269         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
270         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
271         // for accounts without code, i.e. `keccak256('')`
272         bytes32 codehash;
273         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
274         // solhint-disable-next-line no-inline-assembly
275         assembly { codehash := extcodehash(account) }
276         return (codehash != accountHash && codehash != 0x0);
277     }
278 
279     /**
280      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
281      * `recipient`, forwarding all available gas and reverting on errors.
282      *
283      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
284      * of certain opcodes, possibly making contracts go over the 2300 gas limit
285      * imposed by `transfer`, making them unable to receive funds via
286      * `transfer`. {sendValue} removes this limitation.
287      *
288      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
289      *
290      * IMPORTANT: because control is transferred to `recipient`, care must be
291      * taken to not create reentrancy vulnerabilities. Consider using
292      * {ReentrancyGuard} or the
293      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
294      */
295     function sendValue(address payable recipient, uint256 amount) internal {
296         require(address(this).balance >= amount, "Address: insufficient balance");
297 
298         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
299         (bool success, ) = recipient.call{ value: amount }("");
300         require(success, "Address: unable to send value, recipient may have reverted");
301     }
302 
303     /**
304      * @dev Performs a Solidity function call using a low level `call`. A
305      * plain`call` is an unsafe replacement for a function call: use this
306      * function instead.
307      *
308      * If `target` reverts with a revert reason, it is bubbled up by this
309      * function (like regular Solidity function calls).
310      *
311      * Returns the raw returned data. To convert to the expected return value,
312      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
313      *
314      * Requirements:
315      *
316      * - `target` must be a contract.
317      * - calling `target` with `data` must not revert.
318      *
319      * _Available since v3.1._
320      */
321     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
322       return functionCall(target, data, "Address: low-level call failed");
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
327      * `errorMessage` as a fallback revert reason when `target` reverts.
328      *
329      * _Available since v3.1._
330      */
331     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
332         return _functionCallWithValue(target, data, 0, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but also transferring `value` wei to `target`.
338      *
339      * Requirements:
340      *
341      * - the calling contract must have an ETH balance of at least `value`.
342      * - the called Solidity function must be `payable`.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
347         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
352      * with `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
357         require(address(this).balance >= value, "Address: insufficient balance for call");
358         return _functionCallWithValue(target, data, value, errorMessage);
359     }
360 
361     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
362         require(isContract(target), "Address: call to non-contract");
363 
364         // solhint-disable-next-line avoid-low-level-calls
365         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
366         if (success) {
367             return returndata;
368         } else {
369             // Look for revert reason and bubble it up if present
370             if (returndata.length > 0) {
371                 // The easiest way to bubble the revert reason is using memory via assembly
372 
373                 // solhint-disable-next-line no-inline-assembly
374                 assembly {
375                     let returndata_size := mload(returndata)
376                     revert(add(32, returndata), returndata_size)
377                 }
378             } else {
379                 revert(errorMessage);
380             }
381         }
382     }
383 }
384 
385 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
386 
387 
388 pragma solidity ^0.6.0;
389 
390 
391 
392 
393 /**
394  * @title SafeERC20
395  * @dev Wrappers around ERC20 operations that throw on failure (when the token
396  * contract returns false). Tokens that return no value (and instead revert or
397  * throw on failure) are also supported, non-reverting calls are assumed to be
398  * successful.
399  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
400  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
401  */
402 library SafeERC20 {
403     using SafeMath for uint256;
404     using Address for address;
405 
406     function safeTransfer(IERC20 token, address to, uint256 value) internal {
407         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
408     }
409 
410     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
411         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
412     }
413 
414     /**
415      * @dev Deprecated. This function has issues similar to the ones found in
416      * {IERC20-approve}, and its usage is discouraged.
417      *
418      * Whenever possible, use {safeIncreaseAllowance} and
419      * {safeDecreaseAllowance} instead.
420      */
421     function safeApprove(IERC20 token, address spender, uint256 value) internal {
422         // safeApprove should only be called when setting an initial allowance,
423         // or when resetting it to zero. To increase and decrease it, use
424         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
425         // solhint-disable-next-line max-line-length
426         require((value == 0) || (token.allowance(address(this), spender) == 0),
427             "SafeERC20: approve from non-zero to non-zero allowance"
428         );
429         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
430     }
431 
432     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
433         uint256 newAllowance = token.allowance(address(this), spender).add(value);
434         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
435     }
436 
437     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
438         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
439         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
440     }
441 
442     /**
443      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
444      * on the return value: the return value is optional (but if data is returned, it must not be false).
445      * @param token The token targeted by the call.
446      * @param data The call data (encoded using abi.encode or one of its variants).
447      */
448     function _callOptionalReturn(IERC20 token, bytes memory data) private {
449         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
450         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
451         // the target address contains contract code and also asserts for success in the low-level call.
452 
453         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
454         if (returndata.length > 0) { // Return data is optional
455             // solhint-disable-next-line max-line-length
456             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
457         }
458     }
459 }
460 
461 // File: @openzeppelin/contracts/GSN/Context.sol
462 
463 
464 pragma solidity ^0.6.0;
465 
466 /*
467  * @dev Provides information about the current execution context, including the
468  * sender of the transaction and its data. While these are generally available
469  * via msg.sender and msg.data, they should not be accessed in such a direct
470  * manner, since when dealing with GSN meta-transactions the account sending and
471  * paying for execution may not be the actual sender (as far as an application
472  * is concerned).
473  *
474  * This contract is only required for intermediate, library-like contracts.
475  */
476 abstract contract Context {
477     function _msgSender() internal view virtual returns (address payable) {
478         return msg.sender;
479     }
480 
481     function _msgData() internal view virtual returns (bytes memory) {
482         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
483         return msg.data;
484     }
485 }
486 
487 // File: @openzeppelin/contracts/access/Ownable.sol
488 
489 
490 pragma solidity ^0.6.0;
491 
492 /**
493  * @dev Contract module which provides a basic access control mechanism, where
494  * there is an account (an owner) that can be granted exclusive access to
495  * specific functions.
496  *
497  * By default, the owner account will be the one that deploys the contract. This
498  * can later be changed with {transferOwnership}.
499  *
500  * This module is used through inheritance. It will make available the modifier
501  * `onlyOwner`, which can be applied to your functions to restrict their use to
502  * the owner.
503  */
504 contract Ownable is Context {
505     address private _owner;
506 
507     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
508 
509     /**
510      * @dev Initializes the contract setting the deployer as the initial owner.
511      */
512     constructor () internal {
513         address msgSender = _msgSender();
514         _owner = msgSender;
515         emit OwnershipTransferred(address(0), msgSender);
516     }
517 
518     /**
519      * @dev Returns the address of the current owner.
520      */
521     function owner() public view returns (address) {
522         return _owner;
523     }
524 
525     /**
526      * @dev Throws if called by any account other than the owner.
527      */
528     modifier onlyOwner() {
529         require(_owner == _msgSender(), "Ownable: caller is not the owner");
530         _;
531     }
532 
533     /**
534      * @dev Leaves the contract without owner. It will not be possible to call
535      * `onlyOwner` functions anymore. Can only be called by the current owner.
536      *
537      * NOTE: Renouncing ownership will leave the contract without an owner,
538      * thereby removing any functionality that is only available to the owner.
539      */
540     function renounceOwnership() public virtual onlyOwner {
541         emit OwnershipTransferred(_owner, address(0));
542         _owner = address(0);
543     }
544 
545     /**
546      * @dev Transfers ownership of the contract to a new account (`newOwner`).
547      * Can only be called by the current owner.
548      */
549     function transferOwnership(address newOwner) public virtual onlyOwner {
550         require(newOwner != address(0), "Ownable: new owner is the zero address");
551         emit OwnershipTransferred(_owner, newOwner);
552         _owner = newOwner;
553     }
554 }
555 
556 // File: contracts/InitialOffering/TXJPInitialOffering.sol
557 
558 pragma solidity 0.6.12;
559 
560 /**
561  * TXJP
562  * Copyright (C) 2020 TXJP Protocol
563  *
564  * This program is free software: you can redistribute it and/or modify
565  * it under the terms of the GNU General Public License as published by
566  * the Free Software Foundation, either version 3 of the License, or
567  * (at your option) any later version.
568  *
569  * This program is distributed in the hope that it will be useful,
570  * but WITHOUT ANY WARRANTY; without even the implied warranty of
571  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
572  * GNU General Public License for more details.
573  *
574  * You should have received a copy of the GNU General Public License
575  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
576  */
577 
578 
579 
580 
581 /**
582  * @author 0xMotoko
583  * @title TXJP Initial Offering
584  * @notice some description
585  */
586 contract TXJPInitialOffering is Ownable {
587     using SafeERC20 for IERC20;
588     using SafeMath for uint;
589 
590     event Claimed(address indexed account, uint userShare, uint TXJPAmount);
591     event Received(address indexed account, uint amount);
592 
593     uint public constant START = 1625799600; //1day = 86400
594     uint public constant END = START + 5 days + 9 hours;
595     uint public constant TOTAL_DISTRIBUTE_AMOUNT = 36000e8;
596     uint public constant MINIMAL_PROVIDE_AMOUNT = 1 ether;
597     uint public totalProvided = 0;
598     mapping(address => uint) public provided;
599     IERC20 public TXJP;
600 
601     constructor(IERC20 _TXJP) public {
602         TXJP = _TXJP;
603     }
604 
605     receive() external payable {
606         require(START <= block.timestamp, "The offering has not started yet");
607         require(block.timestamp <= END, "The offering has already ended");
608         totalProvided += msg.value;
609         provided[msg.sender] += msg.value;
610         emit Received(msg.sender, msg.value);
611     }
612 
613     function claim() external {
614         require(block.timestamp > END);
615         require(provided[msg.sender] > 0);
616 
617         uint userShare = provided[msg.sender];
618         provided[msg.sender] = 0;
619 
620         if(totalProvided >= MINIMAL_PROVIDE_AMOUNT) {
621             uint TXJPAmount = TOTAL_DISTRIBUTE_AMOUNT
622                 .mul(userShare)
623                 .div(totalProvided);
624             TXJP.safeTransfer(msg.sender, TXJPAmount);
625             emit Claimed(msg.sender, userShare, TXJPAmount);
626         } else {
627             msg.sender.transfer(userShare);
628             emit Claimed(msg.sender, userShare, 0);
629         }
630     }
631 
632     function withdrawProvidedETH() external onlyOwner {
633         require(END < block.timestamp, "The offering must be completed");
634         require(
635             totalProvided >= MINIMAL_PROVIDE_AMOUNT,
636             "The required amount has not been provided!"
637         );
638         payable(owner()).transfer(address(this).balance);
639     }
640 
641     function withdrawTXJP() external onlyOwner {
642         require(END < block.timestamp, "The offering must be completed");
643         require(
644             totalProvided < MINIMAL_PROVIDE_AMOUNT,
645             "The required amount has been provided!"
646         );
647         TXJP.safeTransfer(owner(), TXJP.balanceOf(address(this)));
648     }
649 
650     function withdrawUnclaimedTXJP() external onlyOwner {
651         require(END + 30 days < block.timestamp, "Withdrawal unavailable yet");
652         TXJP.safeTransfer(owner(), TXJP.balanceOf(address(this)));
653     }
654 }