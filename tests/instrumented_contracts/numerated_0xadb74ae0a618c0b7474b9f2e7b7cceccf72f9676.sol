1 // SPDX-License-Identifier: https://github.com/lendroidproject/protocol.2.0/blob/master/LICENSE.md
2 
3 
4 // File: @openzeppelin/contracts/GSN/Context.sol
5 
6 pragma solidity ^0.7.0;
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
29 // File: @openzeppelin/contracts/access/Ownable.sol
30 
31 pragma solidity ^0.7.0;
32 
33 /**
34  * @dev Contract module which provides a basic access control mechanism, where
35  * there is an account (an owner) that can be granted exclusive access to
36  * specific functions.
37  *
38  * By default, the owner account will be the one that deploys the contract. This
39  * can later be changed with {transferOwnership}.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor () {
54         address msgSender = _msgSender();
55         _owner = msgSender;
56         emit OwnershipTransferred(address(0), msgSender);
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(_owner == _msgSender(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         emit OwnershipTransferred(_owner, address(0));
83         _owner = address(0);
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         emit OwnershipTransferred(_owner, newOwner);
93         _owner = newOwner;
94     }
95 }
96 
97 // File: @openzeppelin/contracts/math/SafeMath.sol
98 
99 pragma solidity ^0.7.0;
100 
101 /**
102  * @dev Wrappers over Solidity's arithmetic operations with added overflow
103  * checks.
104  *
105  * Arithmetic operations in Solidity wrap on overflow. This can easily result
106  * in bugs, because programmers usually assume that an overflow raises an
107  * error, which is the standard behavior in high level programming languages.
108  * `SafeMath` restores this intuition by reverting the transaction when an
109  * operation overflows.
110  *
111  * Using this library instead of the unchecked operations eliminates an entire
112  * class of bugs, so it's recommended to use it always.
113  */
114 library SafeMath {
115     /**
116      * @dev Returns the addition of two unsigned integers, reverting on
117      * overflow.
118      *
119      * Counterpart to Solidity's `+` operator.
120      *
121      * Requirements:
122      *
123      * - Addition cannot overflow.
124      */
125     function add(uint256 a, uint256 b) internal pure returns (uint256) {
126         uint256 c = a + b;
127         require(c >= a, "SafeMath: addition overflow");
128 
129         return c;
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      *
140      * - Subtraction cannot overflow.
141      */
142     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
143         return sub(a, b, "SafeMath: subtraction overflow");
144     }
145 
146     /**
147      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
148      * overflow (when the result is negative).
149      *
150      * Counterpart to Solidity's `-` operator.
151      *
152      * Requirements:
153      *
154      * - Subtraction cannot overflow.
155      */
156     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
157         require(b <= a, errorMessage);
158         uint256 c = a - b;
159 
160         return c;
161     }
162 
163     /**
164      * @dev Returns the multiplication of two unsigned integers, reverting on
165      * overflow.
166      *
167      * Counterpart to Solidity's `*` operator.
168      *
169      * Requirements:
170      *
171      * - Multiplication cannot overflow.
172      */
173     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
174         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
175         // benefit is lost if 'b' is also tested.
176         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
177         if (a == 0) {
178             return 0;
179         }
180 
181         uint256 c = a * b;
182         require(c / a == b, "SafeMath: multiplication overflow");
183 
184         return c;
185     }
186 
187     /**
188      * @dev Returns the integer division of two unsigned integers. Reverts on
189      * division by zero. The result is rounded towards zero.
190      *
191      * Counterpart to Solidity's `/` operator. Note: this function uses a
192      * `revert` opcode (which leaves remaining gas untouched) while Solidity
193      * uses an invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      *
197      * - The divisor cannot be zero.
198      */
199     function div(uint256 a, uint256 b) internal pure returns (uint256) {
200         return div(a, b, "SafeMath: division by zero");
201     }
202 
203     /**
204      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
205      * division by zero. The result is rounded towards zero.
206      *
207      * Counterpart to Solidity's `/` operator. Note: this function uses a
208      * `revert` opcode (which leaves remaining gas untouched) while Solidity
209      * uses an invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      *
213      * - The divisor cannot be zero.
214      */
215     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
216         require(b > 0, errorMessage);
217         uint256 c = a / b;
218         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
219 
220         return c;
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * Reverts when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
236         return mod(a, b, "SafeMath: modulo by zero");
237     }
238 
239     /**
240      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
241      * Reverts with custom message when dividing by zero.
242      *
243      * Counterpart to Solidity's `%` operator. This function uses a `revert`
244      * opcode (which leaves remaining gas untouched) while Solidity uses an
245      * invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      *
249      * - The divisor cannot be zero.
250      */
251     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
252         require(b != 0, errorMessage);
253         return a % b;
254     }
255 }
256 
257 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
258 
259 pragma solidity ^0.7.0;
260 
261 /**
262  * @dev Interface of the ERC20 standard as defined in the EIP.
263  */
264 interface IERC20 {
265     /**
266      * @dev Returns the amount of tokens in existence.
267      */
268     function totalSupply() external view returns (uint256);
269 
270     /**
271      * @dev Returns the amount of tokens owned by `account`.
272      */
273     function balanceOf(address account) external view returns (uint256);
274 
275     /**
276      * @dev Moves `amount` tokens from the caller's account to `recipient`.
277      *
278      * Returns a boolean value indicating whether the operation succeeded.
279      *
280      * Emits a {Transfer} event.
281      */
282     function transfer(address recipient, uint256 amount) external returns (bool);
283 
284     /**
285      * @dev Returns the remaining number of tokens that `spender` will be
286      * allowed to spend on behalf of `owner` through {transferFrom}. This is
287      * zero by default.
288      *
289      * This value changes when {approve} or {transferFrom} are called.
290      */
291     function allowance(address owner, address spender) external view returns (uint256);
292 
293     /**
294      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
295      *
296      * Returns a boolean value indicating whether the operation succeeded.
297      *
298      * IMPORTANT: Beware that changing an allowance with this method brings the risk
299      * that someone may use both the old and the new allowance by unfortunate
300      * transaction ordering. One possible solution to mitigate this race
301      * condition is to first reduce the spender's allowance to 0 and set the
302      * desired value afterwards:
303      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
304      *
305      * Emits an {Approval} event.
306      */
307     function approve(address spender, uint256 amount) external returns (bool);
308 
309     /**
310      * @dev Moves `amount` tokens from `sender` to `recipient` using the
311      * allowance mechanism. `amount` is then deducted from the caller's
312      * allowance.
313      *
314      * Returns a boolean value indicating whether the operation succeeded.
315      *
316      * Emits a {Transfer} event.
317      */
318     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
319 
320     /**
321      * @dev Emitted when `value` tokens are moved from one account (`from`) to
322      * another (`to`).
323      *
324      * Note that `value` may be zero.
325      */
326     event Transfer(address indexed from, address indexed to, uint256 value);
327 
328     /**
329      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
330      * a call to {approve}. `value` is the new allowance.
331      */
332     event Approval(address indexed owner, address indexed spender, uint256 value);
333 }
334 
335 // File: @openzeppelin/contracts/utils/Address.sol
336 
337 pragma solidity ^0.7.0;
338 
339 /**
340  * @dev Collection of functions related to the address type
341  */
342 library Address {
343     /**
344      * @dev Returns true if `account` is a contract.
345      *
346      * [IMPORTANT]
347      * ====
348      * It is unsafe to assume that an address for which this function returns
349      * false is an externally-owned account (EOA) and not a contract.
350      *
351      * Among others, `isContract` will return false for the following
352      * types of addresses:
353      *
354      *  - an externally-owned account
355      *  - a contract in construction
356      *  - an address where a contract will be created
357      *  - an address where a contract lived, but was destroyed
358      * ====
359      */
360     function isContract(address account) internal view returns (bool) {
361         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
362         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
363         // for accounts without code, i.e. `keccak256('')`
364         bytes32 codehash;
365         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
366         // solhint-disable-next-line no-inline-assembly
367         assembly { codehash := extcodehash(account) }
368         return (codehash != accountHash && codehash != 0x0);
369     }
370 
371     /**
372      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
373      * `recipient`, forwarding all available gas and reverting on errors.
374      *
375      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
376      * of certain opcodes, possibly making contracts go over the 2300 gas limit
377      * imposed by `transfer`, making them unable to receive funds via
378      * `transfer`. {sendValue} removes this limitation.
379      *
380      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
381      *
382      * IMPORTANT: because control is transferred to `recipient`, care must be
383      * taken to not create reentrancy vulnerabilities. Consider using
384      * {ReentrancyGuard} or the
385      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
386      */
387     function sendValue(address payable recipient, uint256 amount) internal {
388         require(address(this).balance >= amount, "Address: insufficient balance");
389 
390         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
391         (bool success, ) = recipient.call{ value: amount }("");
392         require(success, "Address: unable to send value, recipient may have reverted");
393     }
394 
395     /**
396      * @dev Performs a Solidity function call using a low level `call`. A
397      * plain`call` is an unsafe replacement for a function call: use this
398      * function instead.
399      *
400      * If `target` reverts with a revert reason, it is bubbled up by this
401      * function (like regular Solidity function calls).
402      *
403      * Returns the raw returned data. To convert to the expected return value,
404      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
405      *
406      * Requirements:
407      *
408      * - `target` must be a contract.
409      * - calling `target` with `data` must not revert.
410      *
411      * _Available since v3.1._
412      */
413     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
414       return functionCall(target, data, "Address: low-level call failed");
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
419      * `errorMessage` as a fallback revert reason when `target` reverts.
420      *
421      * _Available since v3.1._
422      */
423     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
424         return _functionCallWithValue(target, data, 0, errorMessage);
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
429      * but also transferring `value` wei to `target`.
430      *
431      * Requirements:
432      *
433      * - the calling contract must have an ETH balance of at least `value`.
434      * - the called Solidity function must be `payable`.
435      *
436      * _Available since v3.1._
437      */
438     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
439         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
444      * with `errorMessage` as a fallback revert reason when `target` reverts.
445      *
446      * _Available since v3.1._
447      */
448     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
449         require(address(this).balance >= value, "Address: insufficient balance for call");
450         return _functionCallWithValue(target, data, value, errorMessage);
451     }
452 
453     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
454         require(isContract(target), "Address: call to non-contract");
455 
456         // solhint-disable-next-line avoid-low-level-calls
457         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
458         if (success) {
459             return returndata;
460         } else {
461             // Look for revert reason and bubble it up if present
462             if (returndata.length > 0) {
463                 // The easiest way to bubble the revert reason is using memory via assembly
464 
465                 // solhint-disable-next-line no-inline-assembly
466                 assembly {
467                     let returndata_size := mload(returndata)
468                     revert(add(32, returndata), returndata_size)
469                 }
470             } else {
471                 revert(errorMessage);
472             }
473         }
474     }
475 }
476 
477 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
478 
479 pragma solidity ^0.7.0;
480 
481 
482 
483 
484 /**
485  * @title SafeERC20
486  * @dev Wrappers around ERC20 operations that throw on failure (when the token
487  * contract returns false). Tokens that return no value (and instead revert or
488  * throw on failure) are also supported, non-reverting calls are assumed to be
489  * successful.
490  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
491  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
492  */
493 library SafeERC20 {
494     using SafeMath for uint256;
495     using Address for address;
496 
497     function safeTransfer(IERC20 token, address to, uint256 value) internal {
498         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
499     }
500 
501     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
502         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
503     }
504 
505     /**
506      * @dev Deprecated. This function has issues similar to the ones found in
507      * {IERC20-approve}, and its usage is discouraged.
508      *
509      * Whenever possible, use {safeIncreaseAllowance} and
510      * {safeDecreaseAllowance} instead.
511      */
512     function safeApprove(IERC20 token, address spender, uint256 value) internal {
513         // safeApprove should only be called when setting an initial allowance,
514         // or when resetting it to zero. To increase and decrease it, use
515         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
516         // solhint-disable-next-line max-line-length
517         require((value == 0) || (token.allowance(address(this), spender) == 0),
518             "SafeERC20: approve from non-zero to non-zero allowance"
519         );
520         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
521     }
522 
523     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
524         uint256 newAllowance = token.allowance(address(this), spender).add(value);
525         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
526     }
527 
528     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
529         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
530         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
531     }
532 
533     /**
534      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
535      * on the return value: the return value is optional (but if data is returned, it must not be false).
536      * @param token The token targeted by the call.
537      * @param data The call data (encoded using abi.encode or one of its variants).
538      */
539     function _callOptionalReturn(IERC20 token, bytes memory data) private {
540         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
541         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
542         // the target address contains contract code and also asserts for success in the low-level call.
543 
544         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
545         if (returndata.length > 0) { // Return data is optional
546             // solhint-disable-next-line max-line-length
547             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
548         }
549     }
550 }
551 
552 // File: contracts/IToken0.sol
553 
554 pragma solidity 0.7.5;
555 
556 
557 
558 /**
559  * @dev Required interface of a Token0 compliant contract.
560  */
561 interface IToken0 is IERC20 {
562     function mint(address account, uint256 amount) external;
563 
564     function burn(uint256 amount) external;
565 
566     function burnFrom(address account, uint256 amount) external;
567 }
568 
569 // File: contracts/SimpleMarket.sol
570 
571 pragma solidity 0.7.5;
572 pragma abicoder v2;
573 
574 
575 
576 
577 
578 
579 
580 /** @title SimpleMarket
581     @author Lendroid Foundation
582     @notice Smart contract representing token0 market
583     @dev Audit certificate : Pending
584 */
585 contract SimpleMarket is Ownable {
586     using SafeMath for uint256;
587     using SafeERC20 for IERC20;
588     using SafeERC20 for IToken0;
589     using Address for address;
590 
591     enum MarketStatus { CREATED, OPEN, CLOSED }
592 
593     MarketStatus public marketStatus;
594     IToken0 public token0;
595     // admin
596     IERC20 public token1;
597     uint256 public marketStart;
598     address public fundsWallet;// address where funds are collected
599     uint256 public totalCap;// total payment cap
600     uint256 public individualCap;// individual payment cap
601     uint256 public totaltoken1Paid;
602     uint256 public token1PerToken0;// token0 distributed per token1 paid
603     //// end user
604     address[] public buyers;
605     mapping (address => uint256) public payments;
606 
607     event PaymentReceived(address buyer, uint256 amount);
608 
609     function createMarket(address token0Address, address token1Address,
610         address fundsWalletAddress,
611         uint256[4] memory uint256Values) external onlyOwner {
612         require(marketStatus == MarketStatus.CREATED, "{createMarket} : market has already been created");
613         // input validations
614         require(token0Address.isContract(), "{createMarket} : token0Address is not contract");
615         require(token1Address.isContract(), "{createMarket} : token1Address is not contract");
616         require(fundsWalletAddress != address(0), "{createMarket} : invalid fundsWalletAddress");
617         // solhint-disable-next-line not-rely-on-time
618         require(uint256Values[0] >= block.timestamp, "{createMarket} : marketStart should be in the future");
619         require(uint256Values[1] > 0, "{createMarket} : totalCap cannot be zero");
620         require(uint256Values[2] > 0, "{createMarket} : token1PerToken0 cannot be zero");
621         require(uint256Values[3] > 0, "{createMarket} : individualCap cannot be zero");
622         marketStatus = MarketStatus.OPEN;
623         // set values
624         token0 = IToken0(token0Address);
625         token1 = IERC20(token1Address);
626         fundsWallet = fundsWalletAddress;
627         marketStart = uint256Values[0];
628         totalCap = uint256Values[1];
629         token1PerToken0 = uint256Values[2];
630         individualCap = uint256Values[3];
631     }
632 
633     /**
634     * @dev Allows owner to close the market and activate token0 issuance.
635     */
636     function closeMarket() external onlyOwner {
637         require(marketStatus == MarketStatus.OPEN, "{closeMarket} : marketStatus is not OPEN");
638         // close market
639         marketStatus = MarketStatus.CLOSED;
640     }
641 
642     /**
643     * @notice Records payment per account.
644     */
645     function pay(uint256 token1Amount) external {
646         require(marketStatus == MarketStatus.OPEN, "{pay} : marketStatus is not OPEN");
647         // solhint-disable-next-line not-rely-on-time
648         require(block.timestamp >= marketStart, "{pay} : market has not yet started");
649         // validations
650         require(token1Amount > 0, "{pay} : token1Amount cannot be zero");
651         require(totaltoken1Paid.add(token1Amount) <= totalCap, "{pay} : token1Amount cannot exceed totalCap");
652         require(payments[msg.sender].add(token1Amount) <= individualCap,
653             "{pay} : token1Amount cannot exceed individualCap");
654         // if we have not received any WEI from this address until now, then we add this address to buyers list.
655         if (payments[msg.sender] == 0) {
656             buyers.push(msg.sender);
657         }
658         payments[msg.sender] = payments[msg.sender].add(token1Amount);
659         totaltoken1Paid = totaltoken1Paid.add(token1Amount);
660         // send token1 from sender to fundsWallet
661         token1.safeTransferFrom(msg.sender, address(fundsWallet), token1Amount);
662         // send token0 to sender
663         uint256 token0Amount = token1Amount.mul(1e18).div(token1PerToken0);
664         token0.safeTransfer(msg.sender, token0Amount);
665         // emit notification
666         emit PaymentReceived(msg.sender, token1Amount);
667     }
668 
669     function marketClosed() external view returns (bool) {
670         return marketStatus == MarketStatus.CLOSED;
671     }
672 
673     function marketOpen() external view returns (bool) {
674         return marketStatus == MarketStatus.OPEN;
675     }
676 
677     function totalBuyers() external view returns (uint256) {
678         return buyers.length;
679     }
680 
681 }