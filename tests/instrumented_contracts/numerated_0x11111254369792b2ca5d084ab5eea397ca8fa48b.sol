1 pragma solidity ^0.5.0;
2 pragma experimental ABIEncoderV2;
3 
4 
5 library ExternalCall {
6     // Source: https://github.com/gnosis/MultiSigWallet/blob/master/contracts/MultiSigWallet.sol
7     // call has been separated into its own function in order to take advantage
8     // of the Solidity's code generator to produce a loop that copies tx.data into memory.
9     function externalCall(address destination, uint value, bytes memory data, uint dataOffset, uint dataLength, uint gasLimit) internal returns(bool result) {
10         // solium-disable-next-line security/no-inline-assembly
11         if (gasLimit == 0) {
12             gasLimit = gasleft() - 40000;
13         }
14         assembly {
15             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
16             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
17             result := call(
18                 gasLimit,
19                 destination,
20                 value,
21                 add(d, dataOffset),
22                 dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
23                 x,
24                 0                  // Output is ignored, therefore the output size is zero
25             )
26         }
27     }
28 }
29 
30 
31 /**
32  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
33  * the optional functions; to access them see `ERC20Detailed`.
34  */
35 interface IERC20 {
36     /**
37      * @dev Returns the amount of tokens in existence.
38      */
39     function totalSupply() external view returns (uint256);
40 
41     /**
42      * @dev Returns the amount of tokens owned by `account`.
43      */
44     function balanceOf(address account) external view returns (uint256);
45 
46     /**
47      * @dev Moves `amount` tokens from the caller's account to `recipient`.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * Emits a `Transfer` event.
52      */
53     function transfer(address recipient, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Returns the remaining number of tokens that `spender` will be
57      * allowed to spend on behalf of `owner` through `transferFrom`. This is
58      * zero by default.
59      *
60      * This value changes when `approve` or `transferFrom` are called.
61      */
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     /**
65      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * > Beware that changing an allowance with this method brings the risk
70      * that someone may use both the old and the new allowance by unfortunate
71      * transaction ordering. One possible solution to mitigate this race
72      * condition is to first reduce the spender's allowance to 0 and set the
73      * desired value afterwards:
74      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75      *
76      * Emits an `Approval` event.
77      */
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Moves `amount` tokens from `sender` to `recipient` using the
82      * allowance mechanism. `amount` is then deducted from the caller's
83      * allowance.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a `Transfer` event.
88      */
89     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to `approve`. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 
107 /**
108  * @dev Wrappers over Solidity's arithmetic operations with added overflow
109  * checks.
110  *
111  * Arithmetic operations in Solidity wrap on overflow. This can easily result
112  * in bugs, because programmers usually assume that an overflow raises an
113  * error, which is the standard behavior in high level programming languages.
114  * `SafeMath` restores this intuition by reverting the transaction when an
115  * operation overflows.
116  *
117  * Using this library instead of the unchecked operations eliminates an entire
118  * class of bugs, so it's recommended to use it always.
119  */
120 library SafeMath {
121     /**
122      * @dev Returns the addition of two unsigned integers, reverting on
123      * overflow.
124      *
125      * Counterpart to Solidity's `+` operator.
126      *
127      * Requirements:
128      * - Addition cannot overflow.
129      */
130     function add(uint256 a, uint256 b) internal pure returns (uint256) {
131         uint256 c = a + b;
132         require(c >= a, "SafeMath: addition overflow");
133 
134         return c;
135     }
136 
137     /**
138      * @dev Returns the subtraction of two unsigned integers, reverting on
139      * overflow (when the result is negative).
140      *
141      * Counterpart to Solidity's `-` operator.
142      *
143      * Requirements:
144      * - Subtraction cannot overflow.
145      */
146     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
147         require(b <= a, "SafeMath: subtraction overflow");
148         uint256 c = a - b;
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the multiplication of two unsigned integers, reverting on
155      * overflow.
156      *
157      * Counterpart to Solidity's `*` operator.
158      *
159      * Requirements:
160      * - Multiplication cannot overflow.
161      */
162     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
163         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
164         // benefit is lost if 'b' is also tested.
165         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
166         if (a == 0) {
167             return 0;
168         }
169 
170         uint256 c = a * b;
171         require(c / a == b, "SafeMath: multiplication overflow");
172 
173         return c;
174     }
175 
176     /**
177      * @dev Returns the integer division of two unsigned integers. Reverts on
178      * division by zero. The result is rounded towards zero.
179      *
180      * Counterpart to Solidity's `/` operator. Note: this function uses a
181      * `revert` opcode (which leaves remaining gas untouched) while Solidity
182      * uses an invalid opcode to revert (consuming all remaining gas).
183      *
184      * Requirements:
185      * - The divisor cannot be zero.
186      */
187     function div(uint256 a, uint256 b) internal pure returns (uint256) {
188         // Solidity only automatically asserts when dividing by 0
189         require(b > 0, "SafeMath: division by zero");
190         uint256 c = a / b;
191         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
198      * Reverts when dividing by zero.
199      *
200      * Counterpart to Solidity's `%` operator. This function uses a `revert`
201      * opcode (which leaves remaining gas untouched) while Solidity uses an
202      * invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      * - The divisor cannot be zero.
206      */
207     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
208         require(b != 0, "SafeMath: modulo by zero");
209         return a % b;
210     }
211 }
212 
213 
214 /**
215  * @dev Contract module which provides a basic access control mechanism, where
216  * there is an account (an owner) that can be granted exclusive access to
217  * specific functions.
218  *
219  * This module is used through inheritance. It will make available the modifier
220  * `onlyOwner`, which can be aplied to your functions to restrict their use to
221  * the owner.
222  */
223 contract Ownable {
224     address private _owner;
225 
226     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
227 
228     /**
229      * @dev Initializes the contract setting the deployer as the initial owner.
230      */
231     constructor () internal {
232         _owner = msg.sender;
233         emit OwnershipTransferred(address(0), _owner);
234     }
235 
236     /**
237      * @dev Returns the address of the current owner.
238      */
239     function owner() public view returns (address) {
240         return _owner;
241     }
242 
243     /**
244      * @dev Throws if called by any account other than the owner.
245      */
246     modifier onlyOwner() {
247         require(isOwner(), "Ownable: caller is not the owner");
248         _;
249     }
250 
251     /**
252      * @dev Returns true if the caller is the current owner.
253      */
254     function isOwner() public view returns (bool) {
255         return msg.sender == _owner;
256     }
257 
258     /**
259      * @dev Leaves the contract without owner. It will not be possible to call
260      * `onlyOwner` functions anymore. Can only be called by the current owner.
261      *
262      * > Note: Renouncing ownership will leave the contract without an owner,
263      * thereby removing any functionality that is only available to the owner.
264      */
265     function renounceOwnership() public onlyOwner {
266         emit OwnershipTransferred(_owner, address(0));
267         _owner = address(0);
268     }
269 
270     /**
271      * @dev Transfers ownership of the contract to a new account (`newOwner`).
272      * Can only be called by the current owner.
273      */
274     function transferOwnership(address newOwner) public onlyOwner {
275         _transferOwnership(newOwner);
276     }
277 
278     /**
279      * @dev Transfers ownership of the contract to a new account (`newOwner`).
280      */
281     function _transferOwnership(address newOwner) internal {
282         require(newOwner != address(0), "Ownable: new owner is the zero address");
283         emit OwnershipTransferred(_owner, newOwner);
284         _owner = newOwner;
285     }
286 }
287 
288 contract IZrxExchange {
289 
290     struct Order {
291         address makerAddress;           // Address that created the order.
292         address takerAddress;           // Address that is allowed to fill the order. If set to 0, any address is allowed to fill the order.
293         address feeRecipientAddress;    // Address that will recieve fees when order is filled.
294         address senderAddress;          // Address that is allowed to call Exchange contract methods that affect this order. If set to 0, any address is allowed to call these methods.
295         uint256 makerAssetAmount;       // Amount of makerAsset being offered by maker. Must be greater than 0.
296         uint256 takerAssetAmount;       // Amount of takerAsset being bid on by maker. Must be greater than 0.
297         uint256 makerFee;               // Amount of ZRX paid to feeRecipient by maker when order is filled. If set to 0, no transfer of ZRX from maker to feeRecipient will be attempted.
298         uint256 takerFee;               // Amount of ZRX paid to feeRecipient by taker when order is filled. If set to 0, no transfer of ZRX from taker to feeRecipient will be attempted.
299         uint256 expirationTimeSeconds;  // Timestamp in seconds at which order expires.
300         uint256 salt;                   // Arbitrary number to facilitate uniqueness of the order's hash.
301         bytes makerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring makerAsset. The last byte references the id of this proxy.
302         bytes takerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring takerAsset. The last byte references the id of this proxy.
303     }
304 
305     struct OrderInfo {
306         uint8 orderStatus;                    // Status that describes order's validity and fillability.
307         bytes32 orderHash;                    // EIP712 hash of the order (see IZrxExchange.getOrderHash).
308         uint256 orderTakerAssetFilledAmount;  // Amount of order that has already been filled.
309     }
310 
311     struct FillResults {
312         uint256 makerAssetFilledAmount;  // Total amount of makerAsset(s) filled.
313         uint256 takerAssetFilledAmount;  // Total amount of takerAsset(s) filled.
314         uint256 makerFeePaid;            // Total amount of ZRX paid by maker(s) to feeRecipient(s).
315         uint256 takerFeePaid;            // Total amount of ZRX paid by taker to feeRecipients(s).
316     }
317 
318     function getOrderInfo(Order memory order)
319         public
320         view
321         returns (OrderInfo memory orderInfo);
322 
323     function getOrdersInfo(Order[] memory orders)
324         public
325         view
326         returns (OrderInfo[] memory ordersInfo);
327 
328     function fillOrder(
329         Order memory order,
330         uint256 takerAssetFillAmount,
331         bytes memory signature
332     )
333         public
334         returns (FillResults memory fillResults);
335 
336     function fillOrderNoThrow(
337         Order memory order,
338         uint256 takerAssetFillAmount,
339         bytes memory signature
340     )
341         public
342         returns (FillResults memory fillResults);
343 }
344 
345 
346 contract IGST2 is IERC20 {
347 
348     function freeUpTo(uint256 value) external returns (uint256 freed);
349 
350     function freeFromUpTo(address from, uint256 value) external returns (uint256 freed);
351 
352     function balanceOf(address who) external view returns (uint256);
353 }
354 
355 
356 /**
357  * @dev Collection of functions related to the address type,
358  */
359 library Address {
360     /**
361      * @dev Returns true if `account` is a contract.
362      *
363      * This test is non-exhaustive, and there may be false-negatives: during the
364      * execution of a contract's constructor, its address will be reported as
365      * not containing a contract.
366      *
367      * > It is unsafe to assume that an address for which this function returns
368      * false is an externally-owned account (EOA) and not a contract.
369      */
370     function isContract(address account) internal view returns (bool) {
371         // This method relies in extcodesize, which returns 0 for contracts in
372         // construction, since the code is only stored at the end of the
373         // constructor execution.
374 
375         uint256 size;
376         // solhint-disable-next-line no-inline-assembly
377         assembly { size := extcodesize(account) }
378         return size > 0;
379     }
380 }
381 
382 
383 
384 contract IWETH is IERC20 {
385 
386     function deposit() external payable;
387 
388     function withdraw(uint256 amount) external;
389 }
390 
391 
392 
393 contract Shutdownable is Ownable {
394 
395     bool public isShutdown;
396 
397     event Shutdown();
398 
399     modifier notShutdown {
400         require(!isShutdown, "Smart contract is shut down.");
401         _;
402     }
403 
404     function shutdown() public onlyOwner {
405         isShutdown = true;
406         emit Shutdown();
407     }
408 }
409 
410 contract IERC20NonView {
411     // Methods are not view to avoid throw on proxy tokens with delegatecall inside
412     function balanceOf(address user) public returns(uint256);
413     function allowance(address from, address to) public returns(uint256);
414 }
415 
416 contract ZrxMarketOrder {
417 
418     using SafeMath for uint256;
419 
420     function marketSellOrdersProportion(
421         IERC20 tokenSell,
422         address tokenBuy,
423         address zrxExchange,
424         address zrxTokenProxy,
425         IZrxExchange.Order[] calldata orders,
426         bytes[] calldata signatures,
427         uint256 mul,
428         uint256 div
429     )
430         external
431     {
432         uint256 amount = tokenSell.balanceOf(msg.sender).mul(mul).div(div);
433         this.marketSellOrders(tokenBuy, zrxExchange, zrxTokenProxy, amount, orders, signatures);
434     }
435 
436     function marketSellOrders(
437         address makerAsset,
438         address zrxExchange,
439         address zrxTokenProxy,
440         uint256 takerAssetFillAmount,
441         IZrxExchange.Order[] calldata orders,
442         bytes[] calldata signatures
443     )
444         external
445         returns (IZrxExchange.FillResults memory totalFillResults)
446     {
447         for (uint i = 0; i < orders.length; i++) {
448 
449             // Stop execution if the entire amount of takerAsset has been sold
450             if (totalFillResults.takerAssetFilledAmount >= takerAssetFillAmount) {
451                 break;
452             }
453 
454             // Calculate the remaining amount of takerAsset to sell
455             uint256 remainingTakerAmount = takerAssetFillAmount.sub(totalFillResults.takerAssetFilledAmount);
456 
457             IZrxExchange.OrderInfo memory orderInfo = IZrxExchange(zrxExchange).getOrderInfo(orders[i]);
458             uint256 orderRemainingTakerAmount = orders[i].takerAssetAmount.sub(orderInfo.orderTakerAssetFilledAmount);
459 
460             // Check available balance and allowance and update orderRemainingTakerAmount
461             {
462                 uint256 balance = IERC20NonView(makerAsset).balanceOf(orders[i].makerAddress);
463                 uint256 allowance = IERC20NonView(makerAsset).allowance(orders[i].makerAddress, zrxTokenProxy);
464                 uint256 availableMakerAmount = (allowance < balance) ? allowance : balance;
465                 uint256 availableTakerAmount = availableMakerAmount.mul(orders[i].takerAssetAmount).div(orders[i].makerAssetAmount);
466 
467                 if (availableTakerAmount < orderRemainingTakerAmount) {
468                     orderRemainingTakerAmount = availableTakerAmount;
469                 }
470             }
471 
472             uint256 takerAmount = (orderRemainingTakerAmount < remainingTakerAmount) ? orderRemainingTakerAmount : remainingTakerAmount;
473 
474             IZrxExchange.FillResults memory fillResults = IZrxExchange(zrxExchange).fillOrderNoThrow(
475                 orders[i],
476                 takerAmount,
477                 signatures[i]
478             );
479 
480             _addFillResults(totalFillResults, fillResults);
481         }
482 
483         return totalFillResults;
484     }
485 
486     function _addFillResults(
487         IZrxExchange.FillResults memory totalFillResults,
488         IZrxExchange.FillResults memory singleFillResults
489     )
490         internal
491         pure
492     {
493         totalFillResults.makerAssetFilledAmount = totalFillResults.makerAssetFilledAmount.add(singleFillResults.makerAssetFilledAmount);
494         totalFillResults.takerAssetFilledAmount = totalFillResults.takerAssetFilledAmount.add(singleFillResults.takerAssetFilledAmount);
495         totalFillResults.makerFeePaid = totalFillResults.makerFeePaid.add(singleFillResults.makerFeePaid);
496         totalFillResults.takerFeePaid = totalFillResults.takerFeePaid.add(singleFillResults.takerFeePaid);
497     }
498 
499     function getOrdersInfoRespectingBalancesAndAllowances(
500         IERC20 token,
501         IZrxExchange zrx,
502         address zrxTokenProxy,
503         IZrxExchange.Order[] memory orders
504     )
505         public
506         view
507         returns (IZrxExchange.OrderInfo[] memory ordersInfo)
508     {
509         ordersInfo = zrx.getOrdersInfo(orders);
510 
511         for (uint i = 0; i < ordersInfo.length; i++) {
512 
513             uint256 balance = token.balanceOf(orders[i].makerAddress);
514             uint256 allowance = token.allowance(orders[i].makerAddress, zrxTokenProxy);
515             uint256 availableMakerAmount = (allowance < balance) ? allowance : balance;
516             uint256 availableTakerAmount = availableMakerAmount.mul(orders[i].takerAssetAmount).div(orders[i].makerAssetAmount);
517 
518             for (uint j = 0; j < i; j++) {
519 
520                 if (orders[j].makerAddress == orders[i].makerAddress) {
521 
522                     uint256 orderTakerAssetRemainigAmount = orders[j].takerAssetAmount.sub(
523                         ordersInfo[j].orderTakerAssetFilledAmount
524                     );
525 
526                     if (availableTakerAmount > orderTakerAssetRemainigAmount) {
527 
528                         availableTakerAmount = availableTakerAmount.sub(orderTakerAssetRemainigAmount);
529                     } else {
530 
531                         availableTakerAmount = 0;
532                         break;
533                     }
534                 }
535             }
536 
537             uint256 remainingTakerAmount = orders[i].takerAssetAmount.sub(
538                 ordersInfo[i].orderTakerAssetFilledAmount
539             );
540 
541             if (availableTakerAmount < remainingTakerAmount) {
542 
543                 ordersInfo[i].orderTakerAssetFilledAmount = orders[i].takerAssetAmount.sub(availableTakerAmount);
544             }
545         }
546     }
547 }
548 
549 
550 
551 
552 /**
553  * @title SafeERC20
554  * @dev Wrappers around ERC20 operations that throw on failure (when the token
555  * contract returns false). Tokens that return no value (and instead revert or
556  * throw on failure) are also supported, non-reverting calls are assumed to be
557  * successful.
558  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
559  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
560  */
561 library SafeERC20 {
562     using SafeMath for uint256;
563     using Address for address;
564 
565     function safeTransfer(IERC20 token, address to, uint256 value) internal {
566         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
567     }
568 
569     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
570         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
571     }
572 
573     function safeApprove(IERC20 token, address spender, uint256 value) internal {
574         // safeApprove should only be called when setting an initial allowance,
575         // or when resetting it to zero. To increase and decrease it, use
576         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
577         // solhint-disable-next-line max-line-length
578         require((value == 0) || (token.allowance(address(this), spender) == 0),
579             "SafeERC20: approve from non-zero to non-zero allowance"
580         );
581         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
582     }
583 
584     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
585         uint256 newAllowance = token.allowance(address(this), spender).add(value);
586         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
587     }
588 
589     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
590         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
591         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
592     }
593 
594     /**
595      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
596      * on the return value: the return value is optional (but if data is returned, it must not be false).
597      * @param token The token targeted by the call.
598      * @param data The call data (encoded using abi.encode or one of its variants).
599      */
600     function callOptionalReturn(IERC20 token, bytes memory data) private {
601         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
602         // we're implementing it ourselves.
603 
604         // A Solidity high level call has three parts:
605         //  1. The target address is checked to verify it contains contract code
606         //  2. The call itself is made, and success asserted
607         //  3. The return value is decoded, which in turn checks the size of the returned data.
608         // solhint-disable-next-line max-line-length
609         require(address(token).isContract(), "SafeERC20: call to non-contract");
610 
611         // solhint-disable-next-line avoid-low-level-calls
612         (bool success, bytes memory returndata) = address(token).call(data);
613         require(success, "SafeERC20: low-level call failed");
614 
615         if (returndata.length > 0) { // Return data is optional
616             // solhint-disable-next-line max-line-length
617             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
618         }
619     }
620 }
621 
622 
623 
624 
625 
626 library UniversalERC20 {
627 
628     using SafeMath for uint256;
629     using SafeERC20 for IERC20;
630 
631     IERC20 private constant ZERO_ADDRESS = IERC20(0x0000000000000000000000000000000000000000);
632     IERC20 private constant ETH_ADDRESS = IERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
633 
634     function universalTransfer(IERC20 token, address to, uint256 amount) internal {
635         universalTransfer(token, to, amount, false);
636     }
637 
638     function universalTransfer(IERC20 token, address to, uint256 amount, bool mayFail) internal returns(bool) {
639         if (amount == 0) {
640             return true;
641         }
642 
643         if (token == ZERO_ADDRESS || token == ETH_ADDRESS) {
644             if (mayFail) {
645                 return address(uint160(to)).send(amount);
646             } else {
647                 address(uint160(to)).transfer(amount);
648                 return true;
649             }
650         } else {
651             token.safeTransfer(to, amount);
652             return true;
653         }
654     }
655 
656     function universalApprove(IERC20 token, address to, uint256 amount) internal {
657         if (token != ZERO_ADDRESS && token != ETH_ADDRESS) {
658             token.safeApprove(to, amount);
659         }
660     }
661 
662     function universalTransferFrom(IERC20 token, address from, address to, uint256 amount) internal {
663         if (amount == 0) {
664             return;
665         }
666 
667         if (token == ZERO_ADDRESS || token == ETH_ADDRESS) {
668             require(from == msg.sender && msg.value >= amount, "msg.value is zero");
669             if (to != address(this)) {
670                 address(uint160(to)).transfer(amount);
671             }
672             if (msg.value > amount) {
673                 msg.sender.transfer(msg.value.sub(amount));
674             }
675         } else {
676             token.safeTransferFrom(from, to, amount);
677         }
678     }
679 
680     function universalBalanceOf(IERC20 token, address who) internal view returns (uint256) {
681         if (token == ZERO_ADDRESS || token == ETH_ADDRESS) {
682             return who.balance;
683         } else {
684             return token.balanceOf(who);
685         }
686     }
687 }
688 
689 
690 
691 contract TokenSpender {
692 
693     using SafeERC20 for IERC20;
694 
695     address public owner;
696     IGST2 public gasToken;
697     address public gasTokenOwner;
698 
699     constructor(IGST2 _gasToken, address _gasTokenOwner) public {
700         owner = msg.sender;
701         gasToken = _gasToken;
702         gasTokenOwner = _gasTokenOwner;
703     }
704 
705     function claimTokens(IERC20 token, address who, address dest, uint256 amount) external {
706         require(msg.sender == owner, "Access restricted");
707         token.safeTransferFrom(who, dest, amount);
708     }
709 
710     function burnGasToken(uint gasSpent) external {
711         require(msg.sender == owner, "Access restricted");
712         uint256 tokens = (gasSpent + 14154) / 41130;
713         gasToken.freeUpTo(tokens);
714     }
715 
716     function() external {
717         if (msg.sender == gasTokenOwner) {
718             gasToken.transfer(msg.sender, gasToken.balanceOf(address(this)));
719         }
720     }
721 }
722 
723 contract OneInchExchange is Shutdownable, ZrxMarketOrder {
724 
725     using SafeMath for uint256;
726     using UniversalERC20 for IERC20;
727     using ExternalCall for address;
728 
729     IERC20 constant ETH_ADDRESS = IERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
730 
731     TokenSpender public spender;
732     uint fee; // 10000 => 100%, 1 => 0.01%
733 
734     event History(
735         address indexed sender,
736         IERC20 fromToken,
737         IERC20 toToken,
738         uint256 fromAmount,
739         uint256 toAmount
740     );
741 
742     event Swapped(
743         IERC20 indexed fromToken,
744         IERC20 indexed toToken,
745         address indexed referrer,
746         uint256 fromAmount,
747         uint256 toAmount,
748         uint256 referrerFee,
749         uint256 fee
750     );
751 
752     constructor(address _owner, IGST2 _gasToken, uint _fee) public {
753         spender = new TokenSpender(
754             _gasToken,
755             _owner
756         );
757 
758         _transferOwnership(_owner);
759         fee = _fee;
760     }
761 
762     function() external payable notShutdown {
763         require(msg.sender != tx.origin);
764     }
765 
766     function swap(
767         IERC20 fromToken,
768         IERC20 toToken,
769         uint256 fromTokenAmount,
770         uint256 minReturnAmount,
771         uint256 guaranteedAmount,
772         address payable referrer,
773         address[] memory callAddresses,
774         bytes memory callDataConcat,
775         uint256[] memory starts,
776         uint256[] memory gasLimitsAndValues
777     )
778     public
779     payable
780     notShutdown
781     returns (uint256 returnAmount)
782     {
783         uint256 gasProvided = gasleft();
784 
785         require(minReturnAmount > 0, "Min return should be bigger then 0.");
786         require(callAddresses.length > 0, "Call data should exists.");
787 
788         if (fromToken != ETH_ADDRESS) {
789             spender.claimTokens(fromToken, msg.sender, address(this), fromTokenAmount);
790         }
791 
792         for (uint i = 0; i < callAddresses.length; i++) {
793             require(callAddresses[i] != address(spender), "Access denied");
794             require(callAddresses[i].externalCall(
795                 gasLimitsAndValues[i] & ((1 << 128) - 1),
796                 callDataConcat,
797                 starts[i],
798                 starts[i + 1] - starts[i],
799                 gasLimitsAndValues[i] >> 128
800             ));
801         }
802 
803         // Return back all unswapped
804         fromToken.universalTransfer(msg.sender, fromToken.universalBalanceOf(address(this)));
805 
806         returnAmount = toToken.universalBalanceOf(address(this));
807         (uint256 toTokenAmount, uint256 referrerFee) = _handleFees(toToken, referrer, returnAmount, guaranteedAmount);
808 
809         require(toTokenAmount >= minReturnAmount, "Return amount is not enough");
810         toToken.universalTransfer(msg.sender, toTokenAmount);
811 
812         emit History(
813             msg.sender,
814             fromToken,
815             toToken,
816             fromTokenAmount,
817             toTokenAmount
818         );
819 
820         emit Swapped(
821             fromToken,
822             toToken,
823             referrer,
824             fromTokenAmount,
825             toTokenAmount,
826             referrerFee,
827             returnAmount.sub(toTokenAmount)
828         );
829 
830         spender.burnGasToken(gasProvided.sub(gasleft()));
831     }
832 
833     function _handleFees(
834         IERC20 toToken,
835         address referrer,
836         uint256 returnAmount,
837         uint256 guaranteedAmount
838     )
839     internal
840     returns (
841         uint256 toTokenAmount,
842         uint256 referrerFee
843     )
844     {
845         if (returnAmount <= guaranteedAmount) {
846             return (returnAmount, 0);
847         }
848 
849         uint256 feeAmount = returnAmount.sub(guaranteedAmount).mul(fee).div(10000);
850 
851         if (referrer != address(0) && referrer != msg.sender && referrer != tx.origin) {
852             referrerFee = feeAmount.div(10);
853             if (toToken.universalTransfer(referrer, referrerFee, true)) {
854                 returnAmount = returnAmount.sub(referrerFee);
855                 feeAmount = feeAmount.sub(referrerFee);
856             } else {
857                 referrerFee = 0;
858             }
859         }
860 
861         if (toToken.universalTransfer(owner(), feeAmount, true)) {
862             returnAmount = returnAmount.sub(feeAmount);
863         }
864 
865         return (returnAmount, referrerFee);
866     }
867 
868     function infiniteApproveIfNeeded(IERC20 token, address to) external notShutdown {
869         if (token != ETH_ADDRESS) {
870             if ((token.allowance(address(this), to) >> 255) == 0) {
871                 token.universalApprove(to, uint256(- 1));
872             }
873         }
874     }
875 
876     function withdrawAllToken(IWETH token) external notShutdown {
877         uint256 amount = token.balanceOf(address(this));
878         token.withdraw(amount);
879     }
880 }