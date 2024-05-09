1 pragma solidity ^0.5.0;
2 pragma experimental ABIEncoderV2;
3 
4 interface IGST2 {
5 
6     function freeUpTo(uint256 value) external returns (uint256 freed);
7 
8     function freeFromUpTo(address from, uint256 value) external returns (uint256 freed);
9 
10     function balanceOf(address who) external view returns (uint256);
11 }
12 
13 // solhint-disable max-line-length
14 contract LibConstants {
15 
16     // Asset data for ZRX token. Used for fee transfers.
17 
18     // The proxyId for ZRX_ASSET_DATA is bytes4(keccak256("ERC20Token(address)")) = 0xf47261b0
19 
20     // Kovan ZRX address is 0x6ff6c0ff1d68b964901f986d4c9fa3ac68346570.
21     // The ABI encoded proxyId and address is 0xf47261b00000000000000000000000006ff6c0ff1d68b964901f986d4c9fa3ac68346570
22     // bytes constant public ZRX_ASSET_DATA = "\xf4\x72\x61\xb0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x6f\xf6\xc0\xff\x1d\x68\xb9\x64\x90\x1f\x98\x6d\x4c\x9f\xa3\xac\x68\x34\x65\x70";
23 
24     // Mainnet ZRX address is 0xe41d2489571d322189246dafa5ebde1f4699f498.
25     // The ABI encoded proxyId and address is 0xf47261b0000000000000000000000000e41d2489571d322189246dafa5ebde1f4699f498
26     bytes constant public ZRX_ASSET_DATA = "\xf4\x72\x61\xb0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe4\x1d\x24\x89\x57\x1d\x32\x21\x89\x24\x6d\xaf\xa5\xeb\xde\x1f\x46\x99\xf4\x98";
27 }
28 // solhint-enable max-line-length
29 
30 contract LibFillResults
31 {
32     struct FillResults {
33         uint256 makerAssetFilledAmount;  // Total amount of makerAsset(s) filled.
34         uint256 takerAssetFilledAmount;  // Total amount of takerAsset(s) filled.
35         uint256 makerFeePaid;            // Total amount of ZRX paid by maker(s) to feeRecipient(s).
36         uint256 takerFeePaid;            // Total amount of ZRX paid by taker to feeRecipients(s).
37     }
38 
39     struct MatchedFillResults {
40         FillResults left;                    // Amounts filled and fees paid of left order.
41         FillResults right;                   // Amounts filled and fees paid of right order.
42         uint256 leftMakerAssetSpreadAmount;  // Spread between price of left and right order, denominated in the left order's makerAsset, paid to taker.
43     }
44 }
45 
46 contract LibOrder
47 {
48     // Hash for the EIP712 Order Schema
49     bytes32 constant internal EIP712_ORDER_SCHEMA_HASH = keccak256(abi.encodePacked(
50         "Order(",
51         "address makerAddress,",
52         "address takerAddress,",
53         "address feeRecipientAddress,",
54         "address senderAddress,",
55         "uint256 makerAssetAmount,",
56         "uint256 takerAssetAmount,",
57         "uint256 makerFee,",
58         "uint256 takerFee,",
59         "uint256 expirationTimeSeconds,",
60         "uint256 salt,",
61         "bytes makerAssetData,",
62         "bytes takerAssetData",
63         ")"
64     ));
65 
66     // A valid order remains fillable until it is expired, fully filled, or cancelled.
67     // An order's state is unaffected by external factors, like account balances.
68     enum OrderStatus {
69         INVALID,                     // Default value
70         INVALID_MAKER_ASSET_AMOUNT,  // Order does not have a valid maker asset amount
71         INVALID_TAKER_ASSET_AMOUNT,  // Order does not have a valid taker asset amount
72         FILLABLE,                    // Order is fillable
73         EXPIRED,                     // Order has already expired
74         FULLY_FILLED,                // Order is fully filled
75         CANCELLED                    // Order has been cancelled
76     }
77 
78     // solhint-disable max-line-length
79     struct Order {
80         address makerAddress;           // Address that created the order.
81         address takerAddress;           // Address that is allowed to fill the order. If set to 0, any address is allowed to fill the order.
82         address feeRecipientAddress;    // Address that will recieve fees when order is filled.
83         address senderAddress;          // Address that is allowed to call Exchange contract methods that affect this order. If set to 0, any address is allowed to call these methods.
84         uint256 makerAssetAmount;       // Amount of makerAsset being offered by maker. Must be greater than 0.
85         uint256 takerAssetAmount;       // Amount of takerAsset being bid on by maker. Must be greater than 0.
86         uint256 makerFee;               // Amount of ZRX paid to feeRecipient by maker when order is filled. If set to 0, no transfer of ZRX from maker to feeRecipient will be attempted.
87         uint256 takerFee;               // Amount of ZRX paid to feeRecipient by taker when order is filled. If set to 0, no transfer of ZRX from taker to feeRecipient will be attempted.
88         uint256 expirationTimeSeconds;  // Timestamp in seconds at which order expires.
89         uint256 salt;                   // Arbitrary number to facilitate uniqueness of the order's hash.
90         bytes makerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring makerAsset. The last byte references the id of this proxy.
91         bytes takerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring takerAsset. The last byte references the id of this proxy.
92     }
93     // solhint-enable max-line-length
94 
95     struct OrderInfo {
96         uint8 orderStatus;                    // Status that describes order's validity and fillability.
97         bytes32 orderHash;                    // EIP712 hash of the order (see LibOrder.getOrderHash).
98         uint256 orderTakerAssetFilledAmount;  // Amount of order that has already been filled.
99     }
100 }
101 
102 contract IExchangeCore {
103 
104     /// @dev Cancels all orders created by makerAddress with a salt less than or equal to the targetOrderEpoch
105     ///      and senderAddress equal to msg.sender (or null address if msg.sender == makerAddress).
106     /// @param targetOrderEpoch Orders created with a salt less or equal to this value will be cancelled.
107     function cancelOrdersUpTo(uint256 targetOrderEpoch)
108         external;
109 
110     /// @dev Fills the input order.
111     /// @param order Order struct containing order specifications.
112     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
113     /// @param signature Proof that order has been created by maker.
114     /// @return Amounts filled and fees paid by maker and taker.
115     function fillOrder(
116         LibOrder.Order memory order,
117         uint256 takerAssetFillAmount,
118         bytes memory signature
119     )
120         public
121         returns (LibFillResults.FillResults memory fillResults);
122 
123     /// @dev After calling, the order can not be filled anymore.
124     /// @param order Order struct containing order specifications.
125     function cancelOrder(LibOrder.Order memory order)
126         public;
127 
128     /// @dev Gets information about an order: status, hash, and amount filled.
129     /// @param order Order to gather information on.
130     /// @return OrderInfo Information about the order and its state.
131     ///                   See LibOrder.OrderInfo for a complete description.
132     function getOrderInfo(LibOrder.Order memory order)
133         public
134         view
135         returns (LibOrder.OrderInfo memory orderInfo);
136 }
137 
138 contract IAssetProxyDispatcher {
139 
140     /// @dev Registers an asset proxy to its asset proxy id.
141     ///      Once an asset proxy is registered, it cannot be unregistered.
142     /// @param assetProxy Address of new asset proxy to register.
143     function registerAssetProxy(address assetProxy)
144         external;
145 
146     /// @dev Gets an asset proxy.
147     /// @param assetProxyId Id of the asset proxy.
148     /// @return The asset proxy registered to assetProxyId. Returns 0x0 if no proxy is registered.
149     function getAssetProxy(bytes4 assetProxyId)
150         external
151         view
152         returns (address);
153 }
154 
155 contract IMatchOrders {
156 
157     /// @dev Match two complementary orders that have a profitable spread.
158     ///      Each order is filled at their respective price point. However, the calculations are
159     ///      carried out as though the orders are both being filled at the right order's price point.
160     ///      The profit made by the left order goes to the taker (who matched the two orders).
161     /// @param leftOrder First order to match.
162     /// @param rightOrder Second order to match.
163     /// @param leftSignature Proof that order was created by the left maker.
164     /// @param rightSignature Proof that order was created by the right maker.
165     /// @return matchedFillResults Amounts filled and fees paid by maker and taker of matched orders.
166     function matchOrders(
167         LibOrder.Order memory leftOrder,
168         LibOrder.Order memory rightOrder,
169         bytes memory leftSignature,
170         bytes memory rightSignature
171     )
172         public
173         returns (LibFillResults.MatchedFillResults memory matchedFillResults);
174 }
175 
176 contract IWrapperFunctions {
177 
178     /// @dev Fills the input order. Reverts if exact takerAssetFillAmount not filled.
179     /// @param order LibOrder.Order struct containing order specifications.
180     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
181     /// @param signature Proof that order has been created by maker.
182     function fillOrKillOrder(
183         LibOrder.Order memory order,
184         uint256 takerAssetFillAmount,
185         bytes memory signature
186     )
187         public
188         returns (LibFillResults.FillResults memory fillResults);
189 
190     /// @dev Fills an order with specified parameters and ECDSA signature.
191     ///      Returns false if the transaction would otherwise revert.
192     /// @param order LibOrder.Order struct containing order specifications.
193     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
194     /// @param signature Proof that order has been created by maker.
195     /// @return Amounts filled and fees paid by maker and taker.
196     function fillOrderNoThrow(
197         LibOrder.Order memory order,
198         uint256 takerAssetFillAmount,
199         bytes memory signature
200     )
201         public
202         returns (LibFillResults.FillResults memory fillResults);
203 
204     /// @dev Synchronously executes multiple calls of fillOrder.
205     /// @param orders Array of order specifications.
206     /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.
207     /// @param signatures Proofs that orders have been created by makers.
208     /// @return Amounts filled and fees paid by makers and taker.
209     function batchFillOrders(
210         LibOrder.Order[] memory orders,
211         uint256[] memory takerAssetFillAmounts,
212         bytes[] memory signatures
213     )
214         public
215         returns (LibFillResults.FillResults memory totalFillResults);
216 
217     /// @dev Synchronously executes multiple calls of fillOrKill.
218     /// @param orders Array of order specifications.
219     /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.
220     /// @param signatures Proofs that orders have been created by makers.
221     /// @return Amounts filled and fees paid by makers and taker.
222     function batchFillOrKillOrders(
223         LibOrder.Order[] memory orders,
224         uint256[] memory takerAssetFillAmounts,
225         bytes[] memory signatures
226     )
227         public
228         returns (LibFillResults.FillResults memory totalFillResults);
229 
230     /// @dev Fills an order with specified parameters and ECDSA signature.
231     ///      Returns false if the transaction would otherwise revert.
232     /// @param orders Array of order specifications.
233     /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.
234     /// @param signatures Proofs that orders have been created by makers.
235     /// @return Amounts filled and fees paid by makers and taker.
236     function batchFillOrdersNoThrow(
237         LibOrder.Order[] memory orders,
238         uint256[] memory takerAssetFillAmounts,
239         bytes[] memory signatures
240     )
241         public
242         returns (LibFillResults.FillResults memory totalFillResults);
243 
244     /// @dev Synchronously executes multiple calls of fillOrder until total amount of takerAsset is sold by taker.
245     /// @param orders Array of order specifications.
246     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
247     /// @param signatures Proofs that orders have been created by makers.
248     /// @return Amounts filled and fees paid by makers and taker.
249     function marketSellOrders(
250         LibOrder.Order[] memory orders,
251         uint256 takerAssetFillAmount,
252         bytes[] memory signatures
253     )
254         public
255         returns (LibFillResults.FillResults memory totalFillResults);
256 
257     /// @dev Synchronously executes multiple calls of fillOrder until total amount of takerAsset is sold by taker.
258     ///      Returns false if the transaction would otherwise revert.
259     /// @param orders Array of order specifications.
260     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
261     /// @param signatures Proofs that orders have been signed by makers.
262     /// @return Amounts filled and fees paid by makers and taker.
263     function marketSellOrdersNoThrow(
264         LibOrder.Order[] memory orders,
265         uint256 takerAssetFillAmount,
266         bytes[] memory signatures
267     )
268         public
269         returns (LibFillResults.FillResults memory totalFillResults);
270 
271     /// @dev Synchronously executes multiple calls of fillOrder until total amount of makerAsset is bought by taker.
272     /// @param orders Array of order specifications.
273     /// @param makerAssetFillAmount Desired amount of makerAsset to buy.
274     /// @param signatures Proofs that orders have been signed by makers.
275     /// @return Amounts filled and fees paid by makers and taker.
276     function marketBuyOrders(
277         LibOrder.Order[] memory orders,
278         uint256 makerAssetFillAmount,
279         bytes[] memory signatures
280     )
281         public
282         returns (LibFillResults.FillResults memory totalFillResults);
283 
284     /// @dev Synchronously executes multiple fill orders in a single transaction until total amount is bought by taker.
285     ///      Returns false if the transaction would otherwise revert.
286     /// @param orders Array of order specifications.
287     /// @param makerAssetFillAmount Desired amount of makerAsset to buy.
288     /// @param signatures Proofs that orders have been signed by makers.
289     /// @return Amounts filled and fees paid by makers and taker.
290     function marketBuyOrdersNoThrow(
291         LibOrder.Order[] memory orders,
292         uint256 makerAssetFillAmount,
293         bytes[] memory signatures
294     )
295         public
296         returns (LibFillResults.FillResults memory totalFillResults);
297 
298     /// @dev Synchronously cancels multiple orders in a single transaction.
299     /// @param orders Array of order specifications.
300     function batchCancelOrders(LibOrder.Order[] memory orders)
301         public;
302 
303     /// @dev Fetches information for all passed in orders
304     /// @param orders Array of order specifications.
305     /// @return Array of OrderInfo instances that correspond to each order.
306     function getOrdersInfo(LibOrder.Order[] memory orders)
307         public
308         view
309         returns (LibOrder.OrderInfo[] memory);
310 }
311 
312 // solhint-disable no-empty-blocks
313 contract IZrxExchange is
314     IExchangeCore,
315     IMatchOrders,
316     IAssetProxyDispatcher,
317     IWrapperFunctions
318 {}
319 
320 
321 
322 library ExternalCall {
323     // Source: https://github.com/gnosis/MultiSigWallet/blob/master/contracts/MultiSigWallet.sol
324     // call has been separated into its own function in order to take advantage
325     // of the Solidity's code generator to produce a loop that copies tx.data into memory.
326     function externalCall(address destination, uint value, bytes memory data, uint dataOffset, uint dataLength) internal returns(bool result) {
327         // solium-disable-next-line security/no-inline-assembly
328         assembly {
329             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
330             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
331             result := call(
332                 sub(gas, 34710),   // 34710 is the value that solidity is currently emitting
333                                    // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
334                                    // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
335                 destination,
336                 value,
337                 add(d, dataOffset),
338                 dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
339                 x,
340                 0                  // Output is ignored, therefore the output size is zero
341             )
342         }
343     }
344 }
345 
346 
347 
348 contract CompressedCaller {
349 
350     function compressedCall(
351         address target,
352         uint256 totalLength,
353         bytes memory zipped
354     )
355         public
356         payable
357         returns (bytes memory result)
358     {
359         (bytes memory data, uint decompressedLength) = decompress(totalLength, zipped);
360         require(decompressedLength == totalLength, "Uncompress error");
361 
362         bool success;
363         (success, result) = target.call.value(msg.value)(data);
364         require(success, "Decompressed call failed");
365     }
366 
367     function decompress(
368         uint256 totalLength,
369         bytes memory zipped
370     )
371         public
372         pure
373         returns (
374             bytes memory data,
375             uint256 index
376         )
377     {
378         data = new bytes(totalLength);
379 
380         for (uint i = 0; i < zipped.length; i++) {
381 
382             uint len = uint(uint8(zipped[i]) & 0x7F);
383 
384             if ((zipped[i] & 0x80) == 0) {
385                 memcpy(data, index, zipped, i + 1, len);
386                 i += len;
387             }
388 
389             index += len;
390         }
391     }
392 
393     //
394     // Modified version of:
395     // https://github.com/Arachnid/solidity-stringutils/blob/master/src/strings.sol#L45
396     //
397     function memcpy(
398         bytes memory destMem,
399         uint dest,
400         bytes memory srcMem,
401         uint src,
402         uint len
403     )
404         private
405         pure
406     {
407         uint mask = 256 ** (32 - len % 32) - 1;
408 
409         assembly {
410             dest := add(add(destMem, 32), dest)
411             src := add(add(srcMem, 32), src)
412 
413             // Copy word-length chunks while possible
414             for { } gt(len, 31) { len := sub(len, 32) } { // (!<) is the same as (>=)
415                 mstore(dest, mload(src))
416                 dest := add(dest, 32)
417                 src := add(src, 32)
418             }
419 
420             // Copy remaining bytes
421             let srcPart := and(mload(src), not(mask))
422             let destPart := and(mload(dest), mask)
423             mstore(dest, or(destPart, srcPart))
424         }
425     }
426 }
427 
428 
429 /**
430  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
431  * the optional functions; to access them see `ERC20Detailed`.
432  */
433 interface IERC20 {
434     /**
435      * @dev Returns the amount of tokens in existence.
436      */
437     function totalSupply() external view returns (uint256);
438 
439     /**
440      * @dev Returns the amount of tokens owned by `account`.
441      */
442     function balanceOf(address account) external view returns (uint256);
443 
444     /**
445      * @dev Moves `amount` tokens from the caller's account to `recipient`.
446      *
447      * Returns a boolean value indicating whether the operation succeeded.
448      *
449      * Emits a `Transfer` event.
450      */
451     function transfer(address recipient, uint256 amount) external returns (bool);
452 
453     /**
454      * @dev Returns the remaining number of tokens that `spender` will be
455      * allowed to spend on behalf of `owner` through `transferFrom`. This is
456      * zero by default.
457      *
458      * This value changes when `approve` or `transferFrom` are called.
459      */
460     function allowance(address owner, address spender) external view returns (uint256);
461 
462     /**
463      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
464      *
465      * Returns a boolean value indicating whether the operation succeeded.
466      *
467      * > Beware that changing an allowance with this method brings the risk
468      * that someone may use both the old and the new allowance by unfortunate
469      * transaction ordering. One possible solution to mitigate this race
470      * condition is to first reduce the spender's allowance to 0 and set the
471      * desired value afterwards:
472      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
473      *
474      * Emits an `Approval` event.
475      */
476     function approve(address spender, uint256 amount) external returns (bool);
477 
478     /**
479      * @dev Moves `amount` tokens from `sender` to `recipient` using the
480      * allowance mechanism. `amount` is then deducted from the caller's
481      * allowance.
482      *
483      * Returns a boolean value indicating whether the operation succeeded.
484      *
485      * Emits a `Transfer` event.
486      */
487     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
488 
489     /**
490      * @dev Emitted when `value` tokens are moved from one account (`from`) to
491      * another (`to`).
492      *
493      * Note that `value` may be zero.
494      */
495     event Transfer(address indexed from, address indexed to, uint256 value);
496 
497     /**
498      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
499      * a call to `approve`. `value` is the new allowance.
500      */
501     event Approval(address indexed owner, address indexed spender, uint256 value);
502 }
503 
504 
505 /**
506  * @dev Wrappers over Solidity's arithmetic operations with added overflow
507  * checks.
508  *
509  * Arithmetic operations in Solidity wrap on overflow. This can easily result
510  * in bugs, because programmers usually assume that an overflow raises an
511  * error, which is the standard behavior in high level programming languages.
512  * `SafeMath` restores this intuition by reverting the transaction when an
513  * operation overflows.
514  *
515  * Using this library instead of the unchecked operations eliminates an entire
516  * class of bugs, so it's recommended to use it always.
517  */
518 library SafeMath {
519     /**
520      * @dev Returns the addition of two unsigned integers, reverting on
521      * overflow.
522      *
523      * Counterpart to Solidity's `+` operator.
524      *
525      * Requirements:
526      * - Addition cannot overflow.
527      */
528     function add(uint256 a, uint256 b) internal pure returns (uint256) {
529         uint256 c = a + b;
530         require(c >= a, "SafeMath: addition overflow");
531 
532         return c;
533     }
534 
535     /**
536      * @dev Returns the subtraction of two unsigned integers, reverting on
537      * overflow (when the result is negative).
538      *
539      * Counterpart to Solidity's `-` operator.
540      *
541      * Requirements:
542      * - Subtraction cannot overflow.
543      */
544     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
545         require(b <= a, "SafeMath: subtraction overflow");
546         uint256 c = a - b;
547 
548         return c;
549     }
550 
551     /**
552      * @dev Returns the multiplication of two unsigned integers, reverting on
553      * overflow.
554      *
555      * Counterpart to Solidity's `*` operator.
556      *
557      * Requirements:
558      * - Multiplication cannot overflow.
559      */
560     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
561         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
562         // benefit is lost if 'b' is also tested.
563         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
564         if (a == 0) {
565             return 0;
566         }
567 
568         uint256 c = a * b;
569         require(c / a == b, "SafeMath: multiplication overflow");
570 
571         return c;
572     }
573 
574     /**
575      * @dev Returns the integer division of two unsigned integers. Reverts on
576      * division by zero. The result is rounded towards zero.
577      *
578      * Counterpart to Solidity's `/` operator. Note: this function uses a
579      * `revert` opcode (which leaves remaining gas untouched) while Solidity
580      * uses an invalid opcode to revert (consuming all remaining gas).
581      *
582      * Requirements:
583      * - The divisor cannot be zero.
584      */
585     function div(uint256 a, uint256 b) internal pure returns (uint256) {
586         // Solidity only automatically asserts when dividing by 0
587         require(b > 0, "SafeMath: division by zero");
588         uint256 c = a / b;
589         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
590 
591         return c;
592     }
593 
594     /**
595      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
596      * Reverts when dividing by zero.
597      *
598      * Counterpart to Solidity's `%` operator. This function uses a `revert`
599      * opcode (which leaves remaining gas untouched) while Solidity uses an
600      * invalid opcode to revert (consuming all remaining gas).
601      *
602      * Requirements:
603      * - The divisor cannot be zero.
604      */
605     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
606         require(b != 0, "SafeMath: modulo by zero");
607         return a % b;
608     }
609 }
610 
611 
612 /**
613  * @dev Collection of functions related to the address type,
614  */
615 library Address {
616     /**
617      * @dev Returns true if `account` is a contract.
618      *
619      * This test is non-exhaustive, and there may be false-negatives: during the
620      * execution of a contract's constructor, its address will be reported as
621      * not containing a contract.
622      *
623      * > It is unsafe to assume that an address for which this function returns
624      * false is an externally-owned account (EOA) and not a contract.
625      */
626     function isContract(address account) internal view returns (bool) {
627         // This method relies in extcodesize, which returns 0 for contracts in
628         // construction, since the code is only stored at the end of the
629         // constructor execution.
630 
631         uint256 size;
632         // solhint-disable-next-line no-inline-assembly
633         assembly { size := extcodesize(account) }
634         return size > 0;
635     }
636 }
637 
638 
639 /**
640  * @dev Contract module which provides a basic access control mechanism, where
641  * there is an account (an owner) that can be granted exclusive access to
642  * specific functions.
643  *
644  * This module is used through inheritance. It will make available the modifier
645  * `onlyOwner`, which can be aplied to your functions to restrict their use to
646  * the owner.
647  */
648 contract Ownable {
649     address private _owner;
650 
651     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
652 
653     /**
654      * @dev Initializes the contract setting the deployer as the initial owner.
655      */
656     constructor () internal {
657         _owner = msg.sender;
658         emit OwnershipTransferred(address(0), _owner);
659     }
660 
661     /**
662      * @dev Returns the address of the current owner.
663      */
664     function owner() public view returns (address) {
665         return _owner;
666     }
667 
668     /**
669      * @dev Throws if called by any account other than the owner.
670      */
671     modifier onlyOwner() {
672         require(isOwner(), "Ownable: caller is not the owner");
673         _;
674     }
675 
676     /**
677      * @dev Returns true if the caller is the current owner.
678      */
679     function isOwner() public view returns (bool) {
680         return msg.sender == _owner;
681     }
682 
683     /**
684      * @dev Leaves the contract without owner. It will not be possible to call
685      * `onlyOwner` functions anymore. Can only be called by the current owner.
686      *
687      * > Note: Renouncing ownership will leave the contract without an owner,
688      * thereby removing any functionality that is only available to the owner.
689      */
690     function renounceOwnership() public onlyOwner {
691         emit OwnershipTransferred(_owner, address(0));
692         _owner = address(0);
693     }
694 
695     /**
696      * @dev Transfers ownership of the contract to a new account (`newOwner`).
697      * Can only be called by the current owner.
698      */
699     function transferOwnership(address newOwner) public onlyOwner {
700         _transferOwnership(newOwner);
701     }
702 
703     /**
704      * @dev Transfers ownership of the contract to a new account (`newOwner`).
705      */
706     function _transferOwnership(address newOwner) internal {
707         require(newOwner != address(0), "Ownable: new owner is the zero address");
708         emit OwnershipTransferred(_owner, newOwner);
709         _owner = newOwner;
710     }
711 }
712 
713 
714 
715 
716 /**
717  * @title SafeERC20
718  * @dev Wrappers around ERC20 operations that throw on failure (when the token
719  * contract returns false). Tokens that return no value (and instead revert or
720  * throw on failure) are also supported, non-reverting calls are assumed to be
721  * successful.
722  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
723  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
724  */
725 library SafeERC20 {
726     using SafeMath for uint256;
727     using Address for address;
728 
729     function safeTransfer(IERC20 token, address to, uint256 value) internal {
730         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
731     }
732 
733     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
734         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
735     }
736 
737     function safeApprove(IERC20 token, address spender, uint256 value) internal {
738         // safeApprove should only be called when setting an initial allowance,
739         // or when resetting it to zero. To increase and decrease it, use
740         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
741         // solhint-disable-next-line max-line-length
742         require((value == 0) || (token.allowance(address(this), spender) == 0),
743             "SafeERC20: approve from non-zero to non-zero allowance"
744         );
745         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
746     }
747 
748     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
749         uint256 newAllowance = token.allowance(address(this), spender).add(value);
750         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
751     }
752 
753     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
754         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
755         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
756     }
757 
758     /**
759      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
760      * on the return value: the return value is optional (but if data is returned, it must not be false).
761      * @param token The token targeted by the call.
762      * @param data The call data (encoded using abi.encode or one of its variants).
763      */
764     function callOptionalReturn(IERC20 token, bytes memory data) private {
765         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
766         // we're implementing it ourselves.
767 
768         // A Solidity high level call has three parts:
769         //  1. The target address is checked to verify it contains contract code
770         //  2. The call itself is made, and success asserted
771         //  3. The return value is decoded, which in turn checks the size of the returned data.
772         // solhint-disable-next-line max-line-length
773         require(address(token).isContract(), "SafeERC20: call to non-contract");
774 
775         // solhint-disable-next-line avoid-low-level-calls
776         (bool success, bytes memory returndata) = address(token).call(data);
777         require(success, "SafeERC20: low-level call failed");
778 
779         if (returndata.length > 0) { // Return data is optional
780             // solhint-disable-next-line max-line-length
781             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
782         }
783     }
784 }
785 
786 
787 
788 contract IWETH is IERC20 {
789 
790     function deposit() external payable;
791 
792     function withdraw(uint256 amount) external;
793 }
794 
795 
796 
797 contract TokenSpender is Ownable {
798 
799     using SafeERC20 for IERC20;
800 
801     function claimTokens(IERC20 token, address who, address dest, uint256 amount) external onlyOwner {
802         token.safeTransferFrom(who, dest, amount);
803     }
804 
805 }
806 
807 
808 
809 
810 
811 
812 
813 
814 contract AggregatedTokenSwap is CompressedCaller {
815 
816     using SafeERC20 for IERC20;
817     using SafeMath for uint;
818     using ExternalCall for address;
819 
820     address constant ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
821 
822     TokenSpender public spender;
823     IGST2 gasToken;
824     address payable owner;
825     uint fee; // 10000 => 100%, 1 => 0.01%
826 
827     event OneInchFeePaid(
828         IERC20 indexed toToken,
829         address indexed referrer,
830         uint256 fee
831     );
832 
833     modifier onlyOwner {
834         require(
835             msg.sender == owner,
836             "Only owner can call this function."
837         );
838         _;
839     }
840 
841     constructor(
842         address payable _owner,
843         IGST2 _gasToken,
844         uint _fee
845     )
846     public
847     {
848         spender = new TokenSpender();
849         owner = _owner;
850         gasToken = _gasToken;
851         fee = _fee;
852     }
853 
854     function setFee(uint _fee) public onlyOwner {
855 
856         require(_fee <= 20, "Fee should not exceed 0.2%"); // <= 0.2%
857         fee = _fee;
858     }
859 
860     function aggregate(
861         address payable msgSender,
862         IERC20 fromToken,
863         IERC20 toToken,
864         uint tokensAmount,
865         address[] memory callAddresses,
866         bytes memory callDataConcat,
867         uint[] memory starts,
868         uint[] memory values,
869         uint mintGasPrice,
870         uint minTokensAmount,
871         address payable referrer
872     )
873     public
874     payable
875     returns (uint returnAmount)
876     {
877         returnAmount = gasleft();
878         uint gasTokenBalance = gasToken.balanceOf(address(this));
879 
880         require(callAddresses.length + 1 == starts.length);
881 
882         if (address(fromToken) != ETH_ADDRESS) {
883 
884             spender.claimTokens(fromToken, msgSender, address(this), tokensAmount);
885         }
886 
887         for (uint i = 0; i < starts.length - 1; i++) {
888 
889             if (starts[i + 1] - starts[i] > 0) {
890 
891                 require(
892                     callDataConcat[starts[i] + 0] != spender.claimTokens.selector[0] ||
893                     callDataConcat[starts[i] + 1] != spender.claimTokens.selector[1] ||
894                     callDataConcat[starts[i] + 2] != spender.claimTokens.selector[2] ||
895                     callDataConcat[starts[i] + 3] != spender.claimTokens.selector[3]
896                 );
897                 require(callAddresses[i].externalCall(values[i], callDataConcat, starts[i], starts[i + 1] - starts[i]));
898             }
899         }
900 
901         require(_balanceOf(toToken, address(this)) >= minTokensAmount);
902 
903         //
904 
905         require(gasTokenBalance == gasToken.balanceOf(address(this)));
906         if (mintGasPrice > 0) {
907             audoRefundGas(returnAmount, mintGasPrice);
908         }
909 
910         //
911 
912         returnAmount = _balanceOf(toToken, address(this)) * fee / 10000;
913         if (referrer != address(0)) {
914             returnAmount /= 2;
915             if (!_transfer(toToken, referrer, returnAmount, true)) {
916                 returnAmount *= 2;
917                 emit OneInchFeePaid(toToken, address(0), returnAmount);
918             } else {
919                 emit OneInchFeePaid(toToken, referrer, returnAmount / 2);
920             }
921         }
922 
923         _transfer(toToken, owner, returnAmount, false);
924 
925         returnAmount = _balanceOf(toToken, address(this));
926         _transfer(toToken, msgSender, returnAmount, false);
927     }
928 
929     function infiniteApproveIfNeeded(IERC20 token, address to) external {
930         if (
931             address(token) != ETH_ADDRESS &&
932             token.allowance(address(this), to) == 0
933         ) {
934             token.safeApprove(to, uint256(-1));
935         }
936     }
937 
938     function withdrawAllToken(IWETH token) external {
939         uint256 amount = token.balanceOf(address(this));
940         token.withdraw(amount);
941     }
942 
943     function marketSellOrders(
944         IERC20 token,
945         IZrxExchange zrxExchange,
946         LibOrder.Order[] calldata orders,
947         bytes[] calldata signatures,
948         uint256 mul,
949         uint256 div
950     )
951     external
952     {
953         uint256 amount = token.balanceOf(address(this)).mul(mul).div(div);
954         zrxExchange.marketSellOrders(orders, amount, signatures);
955     }
956 
957     function _balanceOf(IERC20 token, address who) internal view returns(uint256) {
958         if (address(token) == ETH_ADDRESS || token == IERC20(0)) {
959             return who.balance;
960         } else {
961             return token.balanceOf(who);
962         }
963     }
964 
965     function _transfer(IERC20 token, address payable to, uint256 amount, bool allowFail) internal returns(bool) {
966         if (address(token) == ETH_ADDRESS || token == IERC20(0)) {
967             if (allowFail) {
968                 return to.send(amount);
969             } else {
970                 to.transfer(amount);
971                 return true;
972             }
973         } else {
974             token.safeTransfer(to, amount);
975             return true;
976         }
977     }
978 
979     function audoRefundGas(
980         uint startGas,
981         uint mintGasPrice
982     )
983     private
984     returns (uint freed)
985     {
986         uint MINT_BASE = 32254;
987         uint MINT_TOKEN = 36543;
988         uint FREE_BASE = 14154;
989         uint FREE_TOKEN = 6870;
990         uint REIMBURSE = 24000;
991 
992         uint tokensAmount = ((startGas - gasleft()) + FREE_BASE) / (2 * REIMBURSE - FREE_TOKEN);
993         uint maxReimburse = tokensAmount * REIMBURSE;
994 
995         uint mintCost = MINT_BASE + (tokensAmount * MINT_TOKEN);
996         uint freeCost = FREE_BASE + (tokensAmount * FREE_TOKEN);
997 
998         uint efficiency = (maxReimburse * 100 * tx.gasprice) / (mintCost * mintGasPrice + freeCost * tx.gasprice);
999 
1000         if (efficiency > 100) {
1001 
1002             return refundGas(
1003                 tokensAmount
1004             );
1005         } else {
1006 
1007             return 0;
1008         }
1009     }
1010 
1011     function refundGas(
1012         uint tokensAmount
1013     )
1014     private
1015     returns (uint freed)
1016     {
1017 
1018         if (tokensAmount > 0) {
1019 
1020             uint safeNumTokens = 0;
1021             uint gas = gasleft();
1022 
1023             if (gas >= 27710) {
1024                 safeNumTokens = (gas - 27710) / (1148 + 5722 + 150);
1025             }
1026 
1027             if (tokensAmount > safeNumTokens) {
1028                 tokensAmount = safeNumTokens;
1029             }
1030 
1031             uint gasTokenBalance = IERC20(address(gasToken)).balanceOf(address(this));
1032 
1033             if (tokensAmount > 0 && gasTokenBalance >= tokensAmount) {
1034 
1035                 return gasToken.freeUpTo(tokensAmount);
1036             } else {
1037 
1038                 return 0;
1039             }
1040         } else {
1041 
1042             return 0;
1043         }
1044     }
1045 
1046     function() external payable {
1047 
1048         if (msg.value == 0 && msg.sender == owner) {
1049 
1050             IERC20 _gasToken = IERC20(address(gasToken));
1051 
1052             owner.transfer(address(this).balance);
1053             _gasToken.safeTransfer(owner, _gasToken.balanceOf(address(this)));
1054         }
1055     }
1056 }