1 pragma solidity ^0.5.0;
2 pragma experimental ABIEncoderV2;
3 
4 library ExternalCall {
5     // Source: https://github.com/gnosis/MultiSigWallet/blob/master/contracts/MultiSigWallet.sol
6     // call has been separated into its own function in order to take advantage
7     // of the Solidity's code generator to produce a loop that copies tx.data into memory.
8     function externalCall(address destination, uint value, bytes memory data, uint dataOffset, uint dataLength) internal returns(bool result) {
9         // solium-disable-next-line security/no-inline-assembly
10         assembly {
11             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
12             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
13             result := call(
14                 sub(gas, 34710),   // 34710 is the value that solidity is currently emitting
15                                    // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
16                                    // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
17                 destination,
18                 value,
19                 add(d, dataOffset),
20                 dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
21                 x,
22                 0                  // Output is ignored, therefore the output size is zero
23             )
24         }
25     }
26 }
27 
28 
29 /**
30  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
31  * the optional functions; to access them see `ERC20Detailed`.
32  */
33 interface IERC20 {
34     /**
35      * @dev Returns the amount of tokens in existence.
36      */
37     function totalSupply() external view returns (uint256);
38 
39     /**
40      * @dev Returns the amount of tokens owned by `account`.
41      */
42     function balanceOf(address account) external view returns (uint256);
43 
44     /**
45      * @dev Moves `amount` tokens from the caller's account to `recipient`.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * Emits a `Transfer` event.
50      */
51     function transfer(address recipient, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Returns the remaining number of tokens that `spender` will be
55      * allowed to spend on behalf of `owner` through `transferFrom`. This is
56      * zero by default.
57      *
58      * This value changes when `approve` or `transferFrom` are called.
59      */
60     function allowance(address owner, address spender) external view returns (uint256);
61 
62     /**
63      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * > Beware that changing an allowance with this method brings the risk
68      * that someone may use both the old and the new allowance by unfortunate
69      * transaction ordering. One possible solution to mitigate this race
70      * condition is to first reduce the spender's allowance to 0 and set the
71      * desired value afterwards:
72      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73      *
74      * Emits an `Approval` event.
75      */
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Moves `amount` tokens from `sender` to `recipient` using the
80      * allowance mechanism. `amount` is then deducted from the caller's
81      * allowance.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a `Transfer` event.
86      */
87     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Emitted when `value` tokens are moved from one account (`from`) to
91      * another (`to`).
92      *
93      * Note that `value` may be zero.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99      * a call to `approve`. `value` is the new allowance.
100      */
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 
105 /**
106  * @dev Wrappers over Solidity's arithmetic operations with added overflow
107  * checks.
108  *
109  * Arithmetic operations in Solidity wrap on overflow. This can easily result
110  * in bugs, because programmers usually assume that an overflow raises an
111  * error, which is the standard behavior in high level programming languages.
112  * `SafeMath` restores this intuition by reverting the transaction when an
113  * operation overflows.
114  *
115  * Using this library instead of the unchecked operations eliminates an entire
116  * class of bugs, so it's recommended to use it always.
117  */
118 library SafeMath {
119     /**
120      * @dev Returns the addition of two unsigned integers, reverting on
121      * overflow.
122      *
123      * Counterpart to Solidity's `+` operator.
124      *
125      * Requirements:
126      * - Addition cannot overflow.
127      */
128     function add(uint256 a, uint256 b) internal pure returns (uint256) {
129         uint256 c = a + b;
130         require(c >= a, "SafeMath: addition overflow");
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the subtraction of two unsigned integers, reverting on
137      * overflow (when the result is negative).
138      *
139      * Counterpart to Solidity's `-` operator.
140      *
141      * Requirements:
142      * - Subtraction cannot overflow.
143      */
144     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
145         require(b <= a, "SafeMath: subtraction overflow");
146         uint256 c = a - b;
147 
148         return c;
149     }
150 
151     /**
152      * @dev Returns the multiplication of two unsigned integers, reverting on
153      * overflow.
154      *
155      * Counterpart to Solidity's `*` operator.
156      *
157      * Requirements:
158      * - Multiplication cannot overflow.
159      */
160     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
161         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
162         // benefit is lost if 'b' is also tested.
163         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
164         if (a == 0) {
165             return 0;
166         }
167 
168         uint256 c = a * b;
169         require(c / a == b, "SafeMath: multiplication overflow");
170 
171         return c;
172     }
173 
174     /**
175      * @dev Returns the integer division of two unsigned integers. Reverts on
176      * division by zero. The result is rounded towards zero.
177      *
178      * Counterpart to Solidity's `/` operator. Note: this function uses a
179      * `revert` opcode (which leaves remaining gas untouched) while Solidity
180      * uses an invalid opcode to revert (consuming all remaining gas).
181      *
182      * Requirements:
183      * - The divisor cannot be zero.
184      */
185     function div(uint256 a, uint256 b) internal pure returns (uint256) {
186         // Solidity only automatically asserts when dividing by 0
187         require(b > 0, "SafeMath: division by zero");
188         uint256 c = a / b;
189         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
190 
191         return c;
192     }
193 
194     /**
195      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
196      * Reverts when dividing by zero.
197      *
198      * Counterpart to Solidity's `%` operator. This function uses a `revert`
199      * opcode (which leaves remaining gas untouched) while Solidity uses an
200      * invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      * - The divisor cannot be zero.
204      */
205     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
206         require(b != 0, "SafeMath: modulo by zero");
207         return a % b;
208     }
209 }
210 
211 
212 /**
213  * @dev Contract module which provides a basic access control mechanism, where
214  * there is an account (an owner) that can be granted exclusive access to
215  * specific functions.
216  *
217  * This module is used through inheritance. It will make available the modifier
218  * `onlyOwner`, which can be aplied to your functions to restrict their use to
219  * the owner.
220  */
221 contract Ownable {
222     address private _owner;
223 
224     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
225 
226     /**
227      * @dev Initializes the contract setting the deployer as the initial owner.
228      */
229     constructor () internal {
230         _owner = msg.sender;
231         emit OwnershipTransferred(address(0), _owner);
232     }
233 
234     /**
235      * @dev Returns the address of the current owner.
236      */
237     function owner() public view returns (address) {
238         return _owner;
239     }
240 
241     /**
242      * @dev Throws if called by any account other than the owner.
243      */
244     modifier onlyOwner() {
245         require(isOwner(), "Ownable: caller is not the owner");
246         _;
247     }
248 
249     /**
250      * @dev Returns true if the caller is the current owner.
251      */
252     function isOwner() public view returns (bool) {
253         return msg.sender == _owner;
254     }
255 
256     /**
257      * @dev Leaves the contract without owner. It will not be possible to call
258      * `onlyOwner` functions anymore. Can only be called by the current owner.
259      *
260      * > Note: Renouncing ownership will leave the contract without an owner,
261      * thereby removing any functionality that is only available to the owner.
262      */
263     function renounceOwnership() public onlyOwner {
264         emit OwnershipTransferred(_owner, address(0));
265         _owner = address(0);
266     }
267 
268     /**
269      * @dev Transfers ownership of the contract to a new account (`newOwner`).
270      * Can only be called by the current owner.
271      */
272     function transferOwnership(address newOwner) public onlyOwner {
273         _transferOwnership(newOwner);
274     }
275 
276     /**
277      * @dev Transfers ownership of the contract to a new account (`newOwner`).
278      */
279     function _transferOwnership(address newOwner) internal {
280         require(newOwner != address(0), "Ownable: new owner is the zero address");
281         emit OwnershipTransferred(_owner, newOwner);
282         _owner = newOwner;
283     }
284 }
285 
286 contract IZrxExchange {
287 
288     struct Order {
289         address makerAddress;           // Address that created the order.
290         address takerAddress;           // Address that is allowed to fill the order. If set to 0, any address is allowed to fill the order.
291         address feeRecipientAddress;    // Address that will recieve fees when order is filled.
292         address senderAddress;          // Address that is allowed to call Exchange contract methods that affect this order. If set to 0, any address is allowed to call these methods.
293         uint256 makerAssetAmount;       // Amount of makerAsset being offered by maker. Must be greater than 0.
294         uint256 takerAssetAmount;       // Amount of takerAsset being bid on by maker. Must be greater than 0.
295         uint256 makerFee;               // Amount of ZRX paid to feeRecipient by maker when order is filled. If set to 0, no transfer of ZRX from maker to feeRecipient will be attempted.
296         uint256 takerFee;               // Amount of ZRX paid to feeRecipient by taker when order is filled. If set to 0, no transfer of ZRX from taker to feeRecipient will be attempted.
297         uint256 expirationTimeSeconds;  // Timestamp in seconds at which order expires.
298         uint256 salt;                   // Arbitrary number to facilitate uniqueness of the order's hash.
299         bytes makerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring makerAsset. The last byte references the id of this proxy.
300         bytes takerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring takerAsset. The last byte references the id of this proxy.
301     }
302 
303     struct OrderInfo {
304         uint8 orderStatus;                    // Status that describes order's validity and fillability.
305         bytes32 orderHash;                    // EIP712 hash of the order (see IZrxExchange.getOrderHash).
306         uint256 orderTakerAssetFilledAmount;  // Amount of order that has already been filled.
307     }
308 
309     struct FillResults {
310         uint256 makerAssetFilledAmount;  // Total amount of makerAsset(s) filled.
311         uint256 takerAssetFilledAmount;  // Total amount of takerAsset(s) filled.
312         uint256 makerFeePaid;            // Total amount of ZRX paid by maker(s) to feeRecipient(s).
313         uint256 takerFeePaid;            // Total amount of ZRX paid by taker to feeRecipients(s).
314     }
315 
316     function getOrderInfo(Order memory order)
317         public
318         view
319         returns (OrderInfo memory orderInfo);
320 
321     function getOrdersInfo(Order[] memory orders)
322         public
323         view
324         returns (OrderInfo[] memory ordersInfo);
325 
326     function fillOrder(
327         Order memory order,
328         uint256 takerAssetFillAmount,
329         bytes memory signature
330     )
331         public
332         returns (FillResults memory fillResults);
333 
334     function fillOrderNoThrow(
335         Order memory order,
336         uint256 takerAssetFillAmount,
337         bytes memory signature
338     )
339         public
340         returns (FillResults memory fillResults);
341 }
342 
343 
344 contract IGST2 is IERC20 {
345 
346     function freeUpTo(uint256 value) external returns (uint256 freed);
347 
348     function freeFromUpTo(address from, uint256 value) external returns (uint256 freed);
349 
350     function balanceOf(address who) external view returns (uint256);
351 }
352 
353 
354 /**
355  * @dev Collection of functions related to the address type,
356  */
357 library Address {
358     /**
359      * @dev Returns true if `account` is a contract.
360      *
361      * This test is non-exhaustive, and there may be false-negatives: during the
362      * execution of a contract's constructor, its address will be reported as
363      * not containing a contract.
364      *
365      * > It is unsafe to assume that an address for which this function returns
366      * false is an externally-owned account (EOA) and not a contract.
367      */
368     function isContract(address account) internal view returns (bool) {
369         // This method relies in extcodesize, which returns 0 for contracts in
370         // construction, since the code is only stored at the end of the
371         // constructor execution.
372 
373         uint256 size;
374         // solhint-disable-next-line no-inline-assembly
375         assembly { size := extcodesize(account) }
376         return size > 0;
377     }
378 }
379 
380 
381 
382 contract IWETH is IERC20 {
383 
384     function deposit() external payable;
385 
386     function withdraw(uint256 amount) external;
387 }
388 
389 
390 
391 contract Shutdownable is Ownable {
392 
393     bool public isShutdown;
394 
395     event Shutdown();
396 
397     modifier notShutdown {
398         require(!isShutdown, "Smart contract is shut down.");
399         _;
400     }
401 
402     function shutdown() public onlyOwner {
403         isShutdown = true;
404         emit Shutdown();
405     }
406 }
407 
408 
409 
410 
411 
412 contract IERC20NonView {
413     // Methods are not view to avoid throw on proxy tokens with delegatecall inside
414     function balanceOf(address user) public returns(uint256);
415     function allowance(address from, address to) public returns(uint256);
416 }
417 
418 contract ZrxMarketOrder {
419 
420     using SafeMath for uint256;
421 
422     function marketSellOrdersProportion(
423         IERC20 tokenSell,
424         address tokenBuy,
425         address zrxExchange,
426         address zrxTokenProxy,
427         IZrxExchange.Order[] calldata orders,
428         bytes[] calldata signatures,
429         uint256 mul,
430         uint256 div
431     )
432         external
433     {
434         uint256 amount = tokenSell.balanceOf(msg.sender).mul(mul).div(div);
435         this.marketSellOrders(tokenBuy, zrxExchange, zrxTokenProxy, amount, orders, signatures);
436     }
437 
438     function marketSellOrders(
439         address makerAsset,
440         address zrxExchange,
441         address zrxTokenProxy,
442         uint256 takerAssetFillAmount,
443         IZrxExchange.Order[] calldata orders,
444         bytes[] calldata signatures
445     )
446         external
447         returns (IZrxExchange.FillResults memory totalFillResults)
448     {
449         for (uint i = 0; i < orders.length; i++) {
450 
451             // Stop execution if the entire amount of takerAsset has been sold
452             if (totalFillResults.takerAssetFilledAmount >= takerAssetFillAmount) {
453                 break;
454             }
455 
456             // Calculate the remaining amount of takerAsset to sell
457             uint256 remainingTakerAmount = takerAssetFillAmount.sub(totalFillResults.takerAssetFilledAmount);
458 
459             IZrxExchange.OrderInfo memory orderInfo = IZrxExchange(zrxExchange).getOrderInfo(orders[i]);
460             uint256 orderRemainingTakerAmount = orders[i].takerAssetAmount.sub(orderInfo.orderTakerAssetFilledAmount);
461 
462             // Check available balance and allowance and update orderRemainingTakerAmount
463             {
464                 uint256 balance = IERC20NonView(makerAsset).balanceOf(orders[i].makerAddress);
465                 uint256 allowance = IERC20NonView(makerAsset).allowance(orders[i].makerAddress, zrxTokenProxy);
466                 uint256 availableMakerAmount = (allowance < balance) ? allowance : balance;
467                 uint256 availableTakerAmount = availableMakerAmount.mul(orders[i].takerAssetAmount).div(orders[i].makerAssetAmount);
468 
469                 if (availableTakerAmount < orderRemainingTakerAmount) {
470                     orderRemainingTakerAmount = availableTakerAmount;
471                 }
472             }
473 
474             uint256 takerAmount = (orderRemainingTakerAmount < remainingTakerAmount) ? orderRemainingTakerAmount : remainingTakerAmount;
475 
476             IZrxExchange.FillResults memory fillResults = IZrxExchange(zrxExchange).fillOrderNoThrow(
477                 orders[i],
478                 takerAmount,
479                 signatures[i]
480             );
481 
482             _addFillResults(totalFillResults, fillResults);
483         }
484 
485         return totalFillResults;
486     }
487 
488     function _addFillResults(
489         IZrxExchange.FillResults memory totalFillResults,
490         IZrxExchange.FillResults memory singleFillResults
491     )
492         internal
493         pure
494     {
495         totalFillResults.makerAssetFilledAmount = totalFillResults.makerAssetFilledAmount.add(singleFillResults.makerAssetFilledAmount);
496         totalFillResults.takerAssetFilledAmount = totalFillResults.takerAssetFilledAmount.add(singleFillResults.takerAssetFilledAmount);
497         totalFillResults.makerFeePaid = totalFillResults.makerFeePaid.add(singleFillResults.makerFeePaid);
498         totalFillResults.takerFeePaid = totalFillResults.takerFeePaid.add(singleFillResults.takerFeePaid);
499     }
500 
501     function getOrdersInfoRespectingBalancesAndAllowances(
502         IERC20 token,
503         IZrxExchange zrx,
504         address zrxTokenProxy,
505         IZrxExchange.Order[] memory orders
506     )
507         public
508         view
509         returns (IZrxExchange.OrderInfo[] memory ordersInfo)
510     {
511         ordersInfo = zrx.getOrdersInfo(orders);
512 
513         for (uint i = 0; i < ordersInfo.length; i++) {
514 
515             uint256 balance = token.balanceOf(orders[i].makerAddress);
516             uint256 allowance = token.allowance(orders[i].makerAddress, zrxTokenProxy);
517             uint256 availableMakerAmount = (allowance < balance) ? allowance : balance;
518             uint256 availableTakerAmount = availableMakerAmount.mul(orders[i].takerAssetAmount).div(orders[i].makerAssetAmount);
519 
520             for (uint j = 0; j < i; j++) {
521 
522                 if (orders[j].makerAddress == orders[i].makerAddress) {
523 
524                     uint256 orderTakerAssetRemainigAmount = orders[j].takerAssetAmount.sub(
525                         ordersInfo[j].orderTakerAssetFilledAmount
526                     );
527 
528                     if (availableTakerAmount > orderTakerAssetRemainigAmount) {
529 
530                         availableTakerAmount = availableTakerAmount.sub(orderTakerAssetRemainigAmount);
531                     } else {
532 
533                         availableTakerAmount = 0;
534                         break;
535                     }
536                 }
537             }
538 
539             uint256 remainingTakerAmount = orders[i].takerAssetAmount.sub(
540                 ordersInfo[i].orderTakerAssetFilledAmount
541             );
542 
543             if (availableTakerAmount < remainingTakerAmount) {
544 
545                 ordersInfo[i].orderTakerAssetFilledAmount = orders[i].takerAssetAmount.sub(availableTakerAmount);
546             }
547         }
548     }
549 }
550 
551 
552 
553 
554 /**
555  * @title SafeERC20
556  * @dev Wrappers around ERC20 operations that throw on failure (when the token
557  * contract returns false). Tokens that return no value (and instead revert or
558  * throw on failure) are also supported, non-reverting calls are assumed to be
559  * successful.
560  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
561  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
562  */
563 library SafeERC20 {
564     using SafeMath for uint256;
565     using Address for address;
566 
567     function safeTransfer(IERC20 token, address to, uint256 value) internal {
568         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
569     }
570 
571     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
572         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
573     }
574 
575     function safeApprove(IERC20 token, address spender, uint256 value) internal {
576         // safeApprove should only be called when setting an initial allowance,
577         // or when resetting it to zero. To increase and decrease it, use
578         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
579         // solhint-disable-next-line max-line-length
580         require((value == 0) || (token.allowance(address(this), spender) == 0),
581             "SafeERC20: approve from non-zero to non-zero allowance"
582         );
583         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
584     }
585 
586     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
587         uint256 newAllowance = token.allowance(address(this), spender).add(value);
588         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
589     }
590 
591     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
592         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
593         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
594     }
595 
596     /**
597      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
598      * on the return value: the return value is optional (but if data is returned, it must not be false).
599      * @param token The token targeted by the call.
600      * @param data The call data (encoded using abi.encode or one of its variants).
601      */
602     function callOptionalReturn(IERC20 token, bytes memory data) private {
603         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
604         // we're implementing it ourselves.
605 
606         // A Solidity high level call has three parts:
607         //  1. The target address is checked to verify it contains contract code
608         //  2. The call itself is made, and success asserted
609         //  3. The return value is decoded, which in turn checks the size of the returned data.
610         // solhint-disable-next-line max-line-length
611         require(address(token).isContract(), "SafeERC20: call to non-contract");
612 
613         // solhint-disable-next-line avoid-low-level-calls
614         (bool success, bytes memory returndata) = address(token).call(data);
615         require(success, "SafeERC20: low-level call failed");
616 
617         if (returndata.length > 0) { // Return data is optional
618             // solhint-disable-next-line max-line-length
619             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
620         }
621     }
622 }
623 
624 
625 
626 
627 
628 library UniversalERC20 {
629 
630     using SafeMath for uint256;
631     using SafeERC20 for IERC20;
632 
633     IERC20 private constant ZERO_ADDRESS = IERC20(0x0000000000000000000000000000000000000000);
634     IERC20 private constant ETH_ADDRESS = IERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
635 
636     function universalTransfer(IERC20 token, address to, uint256 amount) internal {
637         universalTransfer(token, to, amount, false);
638     }
639 
640     function universalTransfer(IERC20 token, address to, uint256 amount, bool mayFail) internal returns(bool) {
641         if (amount == 0) {
642             return true;
643         }
644 
645         if (token == ZERO_ADDRESS || token == ETH_ADDRESS) {
646             if (mayFail) {
647                 return address(uint160(to)).send(amount);
648             } else {
649                 address(uint160(to)).transfer(amount);
650                 return true;
651             }
652         } else {
653             token.safeTransfer(to, amount);
654             return true;
655         }
656     }
657 
658     function universalApprove(IERC20 token, address to, uint256 amount) internal {
659         if (token != ZERO_ADDRESS && token != ETH_ADDRESS) {
660             token.safeApprove(to, amount);
661         }
662     }
663 
664     function universalTransferFrom(IERC20 token, address from, address to, uint256 amount) internal {
665         if (amount == 0) {
666             return;
667         }
668 
669         if (token == ZERO_ADDRESS || token == ETH_ADDRESS) {
670             require(from == msg.sender && msg.value >= amount, "msg.value is zero");
671             if (to != address(this)) {
672                 address(uint160(to)).transfer(amount);
673             }
674             if (msg.value > amount) {
675                 msg.sender.transfer(msg.value.sub(amount));
676             }
677         } else {
678             token.safeTransferFrom(from, to, amount);
679         }
680     }
681 
682     function universalBalanceOf(IERC20 token, address who) internal view returns (uint256) {
683         if (token == ZERO_ADDRESS || token == ETH_ADDRESS) {
684             return who.balance;
685         } else {
686             return token.balanceOf(who);
687         }
688     }
689 }
690 
691 
692 
693 contract TokenSpender {
694 
695     using SafeERC20 for IERC20;
696 
697     address public owner;
698     IGST2 public gasToken;
699     address public gasTokenOwner;
700 
701     constructor(IGST2 _gasToken, address _gasTokenOwner) public {
702         owner = msg.sender;
703         gasToken = _gasToken;
704         gasTokenOwner = _gasTokenOwner;
705     }
706 
707     function claimTokens(IERC20 token, address who, address dest, uint256 amount) external {
708         require(msg.sender == owner, "Access restricted");
709         token.safeTransferFrom(who, dest, amount);
710     }
711 
712     function burnGasToken(uint gasSpent) external {
713         require(msg.sender == owner, "Access restricted");
714         uint256 tokens = (gasSpent + 14154) / 41130;
715         gasToken.freeUpTo(tokens);
716     }
717 
718     function() external {
719         if (msg.sender == gasTokenOwner) {
720             gasToken.transfer(msg.sender, gasToken.balanceOf(address(this)));
721         }
722     }
723 }
724 
725 
726 contract OneInchExchange is Shutdownable, ZrxMarketOrder {
727 
728     using SafeMath for uint256;
729     using UniversalERC20 for IERC20;
730     using ExternalCall for address;
731 
732     IERC20 constant ETH_ADDRESS = IERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
733 
734     TokenSpender public spender;
735     uint fee; // 10000 => 100%, 1 => 0.01%
736 
737     event Swapped(
738         IERC20 indexed fromToken,
739         IERC20 indexed toToken,
740         uint256 fromAmount,
741         uint256 toAmount,
742         address indexed referrer,
743         uint256 referrerFee,
744         uint256 fee
745     );
746 
747     constructor(address _owner, IGST2 _gasToken, uint _fee) public {
748         spender = new TokenSpender(
749             _gasToken,
750             _owner
751         );
752 
753         _transferOwnership(_owner);
754         fee = _fee;
755     }
756 
757     function () external payable notShutdown {
758         require(msg.sender != tx.origin);
759     }
760 
761     function swap(
762         IERC20 fromToken,
763         IERC20 toToken,
764         uint256 fromTokenAmount,
765         uint256 minReturnAmount,
766         uint256 guaranteedAmount,
767         address payable referrer,
768         address[] memory callAddresses,
769         bytes memory callDataConcat,
770         uint256[] memory starts,
771         uint256[] memory values
772     )
773         public
774         payable
775         notShutdown
776         returns (uint256 returnAmount)
777     {
778         uint256 gasProvided = gasleft();
779 
780         if (fromToken != ETH_ADDRESS) {
781             spender.claimTokens(fromToken, msg.sender, address(this), fromTokenAmount);
782         }
783 
784         for (uint i = 0; i < callAddresses.length; i++) {
785             require(callAddresses[i] != address(spender), "Access denied");
786             require(callAddresses[i].externalCall(values[i], callDataConcat, starts[i], starts[i + 1] - starts[i]));
787         }
788 
789         returnAmount = toToken.universalBalanceOf(address(this));
790         (uint256 toTokenAmount, uint256 referrerFee) = _handleFees(toToken, referrer, returnAmount, guaranteedAmount);
791 
792         require(toTokenAmount >= minReturnAmount, "Return amount is not enough");
793         toToken.universalTransfer(msg.sender, toTokenAmount);
794 
795         emit Swapped(
796             fromToken,
797             toToken,
798             fromTokenAmount,
799             toTokenAmount,
800             referrer,
801             referrerFee,
802             returnAmount.sub(toTokenAmount)
803         );
804 
805         spender.burnGasToken(gasProvided.sub(gasleft()));
806     }
807 
808     function _handleFees(
809         IERC20 toToken,
810         address referrer,
811         uint256 returnAmount,
812         uint256 guaranteedAmount
813     )
814         internal
815         returns(
816             uint256 toTokenAmount,
817             uint256 referrerFee
818         )
819     {
820         if (returnAmount <= guaranteedAmount) {
821             return (returnAmount, 0);
822         }
823 
824         uint256 feeAmount = returnAmount.sub(guaranteedAmount).mul(fee).div(10000);
825 
826         if (referrer != address(0) && referrer != msg.sender && referrer != tx.origin) {
827             referrerFee = feeAmount.div(10);
828             if (toToken.universalTransfer(referrer, referrerFee, true)) {
829                 returnAmount = returnAmount.sub(referrerFee);
830                 feeAmount = feeAmount.sub(referrerFee);
831             } else {
832                 referrerFee = 0;
833             }
834         }
835 
836         if (toToken.universalTransfer(owner(), feeAmount, true)) {
837             returnAmount = returnAmount.sub(feeAmount);
838         }
839 
840         return (returnAmount, referrerFee);
841     }
842 
843     function infiniteApproveIfNeeded(IERC20 token, address to) external notShutdown {
844         if (token != ETH_ADDRESS) {
845             if ((token.allowance(address(this), to) >> 255) == 0) {
846                 token.universalApprove(to, uint256(- 1));
847             }
848         }
849     }
850 
851     function withdrawAllToken(IWETH token) external notShutdown {
852         uint256 amount = token.balanceOf(address(this));
853         token.withdraw(amount);
854     }
855 }