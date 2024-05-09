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
347 /**
348  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
349  * the optional functions; to access them see `ERC20Detailed`.
350  */
351 interface IERC20 {
352     /**
353      * @dev Returns the amount of tokens in existence.
354      */
355     function totalSupply() external view returns (uint256);
356 
357     /**
358      * @dev Returns the amount of tokens owned by `account`.
359      */
360     function balanceOf(address account) external view returns (uint256);
361 
362     /**
363      * @dev Moves `amount` tokens from the caller's account to `recipient`.
364      *
365      * Returns a boolean value indicating whether the operation succeeded.
366      *
367      * Emits a `Transfer` event.
368      */
369     function transfer(address recipient, uint256 amount) external returns (bool);
370 
371     /**
372      * @dev Returns the remaining number of tokens that `spender` will be
373      * allowed to spend on behalf of `owner` through `transferFrom`. This is
374      * zero by default.
375      *
376      * This value changes when `approve` or `transferFrom` are called.
377      */
378     function allowance(address owner, address spender) external view returns (uint256);
379 
380     /**
381      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
382      *
383      * Returns a boolean value indicating whether the operation succeeded.
384      *
385      * > Beware that changing an allowance with this method brings the risk
386      * that someone may use both the old and the new allowance by unfortunate
387      * transaction ordering. One possible solution to mitigate this race
388      * condition is to first reduce the spender's allowance to 0 and set the
389      * desired value afterwards:
390      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
391      *
392      * Emits an `Approval` event.
393      */
394     function approve(address spender, uint256 amount) external returns (bool);
395 
396     /**
397      * @dev Moves `amount` tokens from `sender` to `recipient` using the
398      * allowance mechanism. `amount` is then deducted from the caller's
399      * allowance.
400      *
401      * Returns a boolean value indicating whether the operation succeeded.
402      *
403      * Emits a `Transfer` event.
404      */
405     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
406 
407     /**
408      * @dev Emitted when `value` tokens are moved from one account (`from`) to
409      * another (`to`).
410      *
411      * Note that `value` may be zero.
412      */
413     event Transfer(address indexed from, address indexed to, uint256 value);
414 
415     /**
416      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
417      * a call to `approve`. `value` is the new allowance.
418      */
419     event Approval(address indexed owner, address indexed spender, uint256 value);
420 }
421 
422 
423 /**
424  * @dev Wrappers over Solidity's arithmetic operations with added overflow
425  * checks.
426  *
427  * Arithmetic operations in Solidity wrap on overflow. This can easily result
428  * in bugs, because programmers usually assume that an overflow raises an
429  * error, which is the standard behavior in high level programming languages.
430  * `SafeMath` restores this intuition by reverting the transaction when an
431  * operation overflows.
432  *
433  * Using this library instead of the unchecked operations eliminates an entire
434  * class of bugs, so it's recommended to use it always.
435  */
436 library SafeMath {
437     /**
438      * @dev Returns the addition of two unsigned integers, reverting on
439      * overflow.
440      *
441      * Counterpart to Solidity's `+` operator.
442      *
443      * Requirements:
444      * - Addition cannot overflow.
445      */
446     function add(uint256 a, uint256 b) internal pure returns (uint256) {
447         uint256 c = a + b;
448         require(c >= a, "SafeMath: addition overflow");
449 
450         return c;
451     }
452 
453     /**
454      * @dev Returns the subtraction of two unsigned integers, reverting on
455      * overflow (when the result is negative).
456      *
457      * Counterpart to Solidity's `-` operator.
458      *
459      * Requirements:
460      * - Subtraction cannot overflow.
461      */
462     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
463         require(b <= a, "SafeMath: subtraction overflow");
464         uint256 c = a - b;
465 
466         return c;
467     }
468 
469     /**
470      * @dev Returns the multiplication of two unsigned integers, reverting on
471      * overflow.
472      *
473      * Counterpart to Solidity's `*` operator.
474      *
475      * Requirements:
476      * - Multiplication cannot overflow.
477      */
478     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
479         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
480         // benefit is lost if 'b' is also tested.
481         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
482         if (a == 0) {
483             return 0;
484         }
485 
486         uint256 c = a * b;
487         require(c / a == b, "SafeMath: multiplication overflow");
488 
489         return c;
490     }
491 
492     /**
493      * @dev Returns the integer division of two unsigned integers. Reverts on
494      * division by zero. The result is rounded towards zero.
495      *
496      * Counterpart to Solidity's `/` operator. Note: this function uses a
497      * `revert` opcode (which leaves remaining gas untouched) while Solidity
498      * uses an invalid opcode to revert (consuming all remaining gas).
499      *
500      * Requirements:
501      * - The divisor cannot be zero.
502      */
503     function div(uint256 a, uint256 b) internal pure returns (uint256) {
504         // Solidity only automatically asserts when dividing by 0
505         require(b > 0, "SafeMath: division by zero");
506         uint256 c = a / b;
507         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
508 
509         return c;
510     }
511 
512     /**
513      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
514      * Reverts when dividing by zero.
515      *
516      * Counterpart to Solidity's `%` operator. This function uses a `revert`
517      * opcode (which leaves remaining gas untouched) while Solidity uses an
518      * invalid opcode to revert (consuming all remaining gas).
519      *
520      * Requirements:
521      * - The divisor cannot be zero.
522      */
523     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
524         require(b != 0, "SafeMath: modulo by zero");
525         return a % b;
526     }
527 }
528 
529 
530 /**
531  * @dev Collection of functions related to the address type,
532  */
533 library Address {
534     /**
535      * @dev Returns true if `account` is a contract.
536      *
537      * This test is non-exhaustive, and there may be false-negatives: during the
538      * execution of a contract's constructor, its address will be reported as
539      * not containing a contract.
540      *
541      * > It is unsafe to assume that an address for which this function returns
542      * false is an externally-owned account (EOA) and not a contract.
543      */
544     function isContract(address account) internal view returns (bool) {
545         // This method relies in extcodesize, which returns 0 for contracts in
546         // construction, since the code is only stored at the end of the
547         // constructor execution.
548 
549         uint256 size;
550         // solhint-disable-next-line no-inline-assembly
551         assembly { size := extcodesize(account) }
552         return size > 0;
553     }
554 }
555 
556 
557 /**
558  * @dev Contract module which provides a basic access control mechanism, where
559  * there is an account (an owner) that can be granted exclusive access to
560  * specific functions.
561  *
562  * This module is used through inheritance. It will make available the modifier
563  * `onlyOwner`, which can be aplied to your functions to restrict their use to
564  * the owner.
565  */
566 contract Ownable {
567     address private _owner;
568 
569     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
570 
571     /**
572      * @dev Initializes the contract setting the deployer as the initial owner.
573      */
574     constructor () internal {
575         _owner = msg.sender;
576         emit OwnershipTransferred(address(0), _owner);
577     }
578 
579     /**
580      * @dev Returns the address of the current owner.
581      */
582     function owner() public view returns (address) {
583         return _owner;
584     }
585 
586     /**
587      * @dev Throws if called by any account other than the owner.
588      */
589     modifier onlyOwner() {
590         require(isOwner(), "Ownable: caller is not the owner");
591         _;
592     }
593 
594     /**
595      * @dev Returns true if the caller is the current owner.
596      */
597     function isOwner() public view returns (bool) {
598         return msg.sender == _owner;
599     }
600 
601     /**
602      * @dev Leaves the contract without owner. It will not be possible to call
603      * `onlyOwner` functions anymore. Can only be called by the current owner.
604      *
605      * > Note: Renouncing ownership will leave the contract without an owner,
606      * thereby removing any functionality that is only available to the owner.
607      */
608     function renounceOwnership() public onlyOwner {
609         emit OwnershipTransferred(_owner, address(0));
610         _owner = address(0);
611     }
612 
613     /**
614      * @dev Transfers ownership of the contract to a new account (`newOwner`).
615      * Can only be called by the current owner.
616      */
617     function transferOwnership(address newOwner) public onlyOwner {
618         _transferOwnership(newOwner);
619     }
620 
621     /**
622      * @dev Transfers ownership of the contract to a new account (`newOwner`).
623      */
624     function _transferOwnership(address newOwner) internal {
625         require(newOwner != address(0), "Ownable: new owner is the zero address");
626         emit OwnershipTransferred(_owner, newOwner);
627         _owner = newOwner;
628     }
629 }
630 
631 
632 
633 
634 /**
635  * @title SafeERC20
636  * @dev Wrappers around ERC20 operations that throw on failure (when the token
637  * contract returns false). Tokens that return no value (and instead revert or
638  * throw on failure) are also supported, non-reverting calls are assumed to be
639  * successful.
640  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
641  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
642  */
643 library SafeERC20 {
644     using SafeMath for uint256;
645     using Address for address;
646 
647     function safeTransfer(IERC20 token, address to, uint256 value) internal {
648         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
649     }
650 
651     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
652         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
653     }
654 
655     function safeApprove(IERC20 token, address spender, uint256 value) internal {
656         // safeApprove should only be called when setting an initial allowance,
657         // or when resetting it to zero. To increase and decrease it, use
658         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
659         // solhint-disable-next-line max-line-length
660         require((value == 0) || (token.allowance(address(this), spender) == 0),
661             "SafeERC20: approve from non-zero to non-zero allowance"
662         );
663         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
664     }
665 
666     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
667         uint256 newAllowance = token.allowance(address(this), spender).add(value);
668         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
669     }
670 
671     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
672         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
673         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
674     }
675 
676     /**
677      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
678      * on the return value: the return value is optional (but if data is returned, it must not be false).
679      * @param token The token targeted by the call.
680      * @param data The call data (encoded using abi.encode or one of its variants).
681      */
682     function callOptionalReturn(IERC20 token, bytes memory data) private {
683         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
684         // we're implementing it ourselves.
685 
686         // A Solidity high level call has three parts:
687         //  1. The target address is checked to verify it contains contract code
688         //  2. The call itself is made, and success asserted
689         //  3. The return value is decoded, which in turn checks the size of the returned data.
690         // solhint-disable-next-line max-line-length
691         require(address(token).isContract(), "SafeERC20: call to non-contract");
692 
693         // solhint-disable-next-line avoid-low-level-calls
694         (bool success, bytes memory returndata) = address(token).call(data);
695         require(success, "SafeERC20: low-level call failed");
696 
697         if (returndata.length > 0) { // Return data is optional
698             // solhint-disable-next-line max-line-length
699             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
700         }
701     }
702 }
703 
704 
705 
706 contract IWETH is IERC20 {
707 
708     function deposit() external payable;
709 
710     function withdraw(uint256 amount) external;
711 }
712 
713 
714 
715 contract TokenSpender is Ownable {
716 
717     using SafeERC20 for IERC20;
718 
719     function claimTokens(IERC20 token, address who, address dest, uint256 amount) external onlyOwner {
720         token.safeTransferFrom(who, dest, amount);
721     }
722 
723 }
724 
725 
726 
727 
728 contract AggregatedTokenSwap {
729 
730     using SafeERC20 for IERC20;
731     using SafeMath for uint;
732     using ExternalCall for address;
733 
734     address constant ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
735 
736     TokenSpender public spender;
737     IGST2 gasToken;
738     address payable owner;
739     uint fee; // 10000 => 100%, 1 => 0.01%
740 
741     event OneInchFeePaid(
742         IERC20 indexed toToken,
743         address indexed referrer,
744         uint256 fee
745     );
746 
747     modifier onlyOwner {
748         require(
749             msg.sender == owner,
750             "Only owner can call this function."
751         );
752         _;
753     }
754 
755     constructor(
756         address payable _owner,
757         IGST2 _gasToken,
758         uint _fee
759     )
760     public
761     {
762         spender = new TokenSpender();
763         owner = _owner;
764         gasToken = _gasToken;
765         fee = _fee;
766     }
767 
768     function setFee(uint _fee) public onlyOwner {
769 
770         require(_fee <= 20, "Fee should not exceed 0.2%"); // <= 0.2%
771         fee = _fee;
772     }
773 
774     function aggregate(
775         IERC20 fromToken,
776         IERC20 toToken,
777         uint tokensAmount,
778         address[] memory callAddresses,
779         bytes memory callDataConcat,
780         uint[] memory starts,
781         uint[] memory values,
782         uint mintGasPrice,
783         uint minTokensAmount,
784         address payable referrer
785     )
786     public
787     payable
788     returns (uint returnAmount)
789     {
790         returnAmount = gasleft();
791         uint gasTokenBalance = gasToken.balanceOf(address(this));
792 
793         require(callAddresses.length + 1 == starts.length);
794 
795         if (address(fromToken) != ETH_ADDRESS) {
796 
797             spender.claimTokens(fromToken, msg.sender, address(this), tokensAmount);
798         }
799 
800         for (uint i = 0; i < starts.length - 1; i++) {
801 
802             if (starts[i + 1] - starts[i] > 0) {
803 
804                 require(
805                     callDataConcat[starts[i] + 0] != spender.claimTokens.selector[0] ||
806                     callDataConcat[starts[i] + 1] != spender.claimTokens.selector[1] ||
807                     callDataConcat[starts[i] + 2] != spender.claimTokens.selector[2] ||
808                     callDataConcat[starts[i] + 3] != spender.claimTokens.selector[3]
809                 );
810                 require(callAddresses[i].externalCall(values[i], callDataConcat, starts[i], starts[i + 1] - starts[i]));
811             }
812         }
813 
814         require(_balanceOf(toToken, address(this)) >= minTokensAmount);
815 
816         //
817 
818         require(gasTokenBalance == gasToken.balanceOf(address(this)));
819         if (mintGasPrice > 0) {
820             audoRefundGas(returnAmount, mintGasPrice);
821         }
822 
823         //
824 
825         returnAmount = _balanceOf(toToken, address(this)) * fee / 10000;
826         if (referrer != address(0)) {
827             returnAmount /= 2;
828             if (!_transfer(toToken, referrer, returnAmount, true)) {
829                 returnAmount *= 2;
830                 emit OneInchFeePaid(toToken, address(0), returnAmount);
831             } else {
832                 emit OneInchFeePaid(toToken, referrer, returnAmount / 2);
833             }
834         }
835 
836         _transfer(toToken, owner, returnAmount, false);
837 
838         returnAmount = _balanceOf(toToken, address(this));
839         _transfer(toToken, msg.sender, returnAmount, false);
840     }
841 
842     function infiniteApproveIfNeeded(IERC20 token, address to) external {
843         if (
844             address(token) != ETH_ADDRESS &&
845             token.allowance(address(this), to) == 0
846         ) {
847             token.safeApprove(to, uint256(-1));
848         }
849     }
850 
851     function withdrawAllToken(IWETH token) external {
852         uint256 amount = token.balanceOf(address(this));
853         token.withdraw(amount);
854     }
855 
856     function marketSellOrders(
857         IERC20 token,
858         IZrxExchange zrxExchange,
859         LibOrder.Order[] calldata orders,
860         bytes[] calldata signatures,
861         uint256 mul,
862         uint256 div
863     )
864     external
865     {
866         uint256 amount = token.balanceOf(address(this)).mul(mul).div(div);
867         zrxExchange.marketSellOrders(orders, amount, signatures);
868     }
869 
870     function _balanceOf(IERC20 token, address who) internal view returns(uint256) {
871         if (address(token) == ETH_ADDRESS || token == IERC20(0)) {
872             return who.balance;
873         } else {
874             return token.balanceOf(who);
875         }
876     }
877 
878     function _transfer(IERC20 token, address payable to, uint256 amount, bool allowFail) internal returns(bool) {
879         if (address(token) == ETH_ADDRESS || token == IERC20(0)) {
880             if (allowFail) {
881                 return to.send(amount);
882             } else {
883                 to.transfer(amount);
884                 return true;
885             }
886         } else {
887             token.safeTransfer(to, amount);
888             return true;
889         }
890     }
891 
892     function audoRefundGas(
893         uint startGas,
894         uint mintGasPrice
895     )
896     private
897     returns (uint freed)
898     {
899         uint MINT_BASE = 32254;
900         uint MINT_TOKEN = 36543;
901         uint FREE_BASE = 14154;
902         uint FREE_TOKEN = 6870;
903         uint REIMBURSE = 24000;
904 
905         uint tokensAmount = ((startGas - gasleft()) + FREE_BASE) / (2 * REIMBURSE - FREE_TOKEN);
906         uint maxReimburse = tokensAmount * REIMBURSE;
907 
908         uint mintCost = MINT_BASE + (tokensAmount * MINT_TOKEN);
909         uint freeCost = FREE_BASE + (tokensAmount * FREE_TOKEN);
910 
911         uint efficiency = (maxReimburse * 100 * tx.gasprice) / (mintCost * mintGasPrice + freeCost * tx.gasprice);
912 
913         if (efficiency > 100) {
914 
915             return refundGas(
916                 tokensAmount
917             );
918         } else {
919 
920             return 0;
921         }
922     }
923 
924     function refundGas(
925         uint tokensAmount
926     )
927     private
928     returns (uint freed)
929     {
930 
931         if (tokensAmount > 0) {
932 
933             uint safeNumTokens = 0;
934             uint gas = gasleft();
935 
936             if (gas >= 27710) {
937                 safeNumTokens = (gas - 27710) / (1148 + 5722 + 150);
938             }
939 
940             if (tokensAmount > safeNumTokens) {
941                 tokensAmount = safeNumTokens;
942             }
943 
944             uint gasTokenBalance = IERC20(address(gasToken)).balanceOf(address(this));
945 
946             if (tokensAmount > 0 && gasTokenBalance >= tokensAmount) {
947 
948                 return gasToken.freeUpTo(tokensAmount);
949             } else {
950 
951                 return 0;
952             }
953         } else {
954 
955             return 0;
956         }
957     }
958 
959     function() external payable {
960 
961         if (msg.value == 0 && msg.sender == owner) {
962 
963             IERC20 _gasToken = IERC20(address(gasToken));
964 
965             owner.transfer(address(this).balance);
966             _gasToken.safeTransfer(owner, _gasToken.balanceOf(address(this)));
967         }
968     }
969 }