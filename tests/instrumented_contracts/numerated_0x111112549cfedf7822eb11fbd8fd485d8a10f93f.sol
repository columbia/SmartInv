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
13 contract IZrxExchange {
14 
15     struct Order {
16         address makerAddress;           // Address that created the order.
17         address takerAddress;           // Address that is allowed to fill the order. If set to 0, any address is allowed to fill the order.
18         address feeRecipientAddress;    // Address that will recieve fees when order is filled.
19         address senderAddress;          // Address that is allowed to call Exchange contract methods that affect this order. If set to 0, any address is allowed to call these methods.
20         uint256 makerAssetAmount;       // Amount of makerAsset being offered by maker. Must be greater than 0.
21         uint256 takerAssetAmount;       // Amount of takerAsset being bid on by maker. Must be greater than 0.
22         uint256 makerFee;               // Amount of ZRX paid to feeRecipient by maker when order is filled. If set to 0, no transfer of ZRX from maker to feeRecipient will be attempted.
23         uint256 takerFee;               // Amount of ZRX paid to feeRecipient by taker when order is filled. If set to 0, no transfer of ZRX from taker to feeRecipient will be attempted.
24         uint256 expirationTimeSeconds;  // Timestamp in seconds at which order expires.
25         uint256 salt;                   // Arbitrary number to facilitate uniqueness of the order's hash.
26         bytes makerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring makerAsset. The last byte references the id of this proxy.
27         bytes takerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring takerAsset. The last byte references the id of this proxy.
28     }
29 
30     struct OrderInfo {
31         uint8 orderStatus;                    // Status that describes order's validity and fillability.
32         bytes32 orderHash;                    // EIP712 hash of the order (see IZrxExchange.getOrderHash).
33         uint256 orderTakerAssetFilledAmount;  // Amount of order that has already been filled.
34     }
35 
36     struct FillResults {
37         uint256 makerAssetFilledAmount;  // Total amount of makerAsset(s) filled.
38         uint256 takerAssetFilledAmount;  // Total amount of takerAsset(s) filled.
39         uint256 makerFeePaid;            // Total amount of ZRX paid by maker(s) to feeRecipient(s).
40         uint256 takerFeePaid;            // Total amount of ZRX paid by taker to feeRecipients(s).
41     }
42 
43     function getOrderInfo(Order memory order)
44         public
45         view
46         returns (OrderInfo memory orderInfo);
47 
48     function getOrdersInfo(Order[] memory orders)
49         public
50         view
51         returns (OrderInfo[] memory ordersInfo);
52 
53     function fillOrder(
54         Order memory order,
55         uint256 takerAssetFillAmount,
56         bytes memory signature
57     )
58         public
59         returns (FillResults memory fillResults);
60 
61     function fillOrderNoThrow(
62         Order memory order,
63         uint256 takerAssetFillAmount,
64         bytes memory signature
65     )
66         public
67         returns (FillResults memory fillResults);
68 }
69 
70 
71 
72 library ExternalCall {
73     // Source: https://github.com/gnosis/MultiSigWallet/blob/master/contracts/MultiSigWallet.sol
74     // call has been separated into its own function in order to take advantage
75     // of the Solidity's code generator to produce a loop that copies tx.data into memory.
76     function externalCall(address destination, uint value, bytes memory data, uint dataOffset, uint dataLength) internal returns(bool result) {
77         // solium-disable-next-line security/no-inline-assembly
78         assembly {
79             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
80             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
81             result := call(
82                 sub(gas, 34710),   // 34710 is the value that solidity is currently emitting
83                                    // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
84                                    // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
85                 destination,
86                 value,
87                 add(d, dataOffset),
88                 dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
89                 x,
90                 0                  // Output is ignored, therefore the output size is zero
91             )
92         }
93     }
94 }
95 
96 
97 
98 contract CompressedCaller {
99 
100     function compressedCall(
101         address target,
102         uint256 totalLength,
103         bytes memory zipped
104     )
105         public
106         payable
107         returns (bytes memory result)
108     {
109         (bytes memory data, uint decompressedLength) = decompress(totalLength, zipped);
110         require(decompressedLength == totalLength, "Uncompress error");
111 
112         bool success;
113         (success, result) = target.call.value(msg.value)(data);
114         require(success, "Decompressed call failed");
115     }
116 
117     function decompress(
118         uint256 totalLength,
119         bytes memory zipped
120     )
121         public
122         pure
123         returns (
124             bytes memory data,
125             uint256 index
126         )
127     {
128         data = new bytes(totalLength);
129 
130         for (uint i = 0; i < zipped.length; i++) {
131 
132             uint len = uint(uint8(zipped[i]) & 0x7F);
133 
134             if ((zipped[i] & 0x80) == 0) {
135                 memcpy(data, index, zipped, i + 1, len);
136                 i += len;
137             }
138 
139             index += len;
140         }
141     }
142 
143     //
144     // Modified version of:
145     // https://github.com/Arachnid/solidity-stringutils/blob/master/src/strings.sol#L45
146     //
147     function memcpy(
148         bytes memory destMem,
149         uint dest,
150         bytes memory srcMem,
151         uint src,
152         uint len
153     )
154         private
155         pure
156     {
157         uint mask = 256 ** (32 - len % 32) - 1;
158 
159         assembly {
160             dest := add(add(destMem, 32), dest)
161             src := add(add(srcMem, 32), src)
162 
163             // Copy word-length chunks while possible
164             for { } gt(len, 31) { len := sub(len, 32) } { // (!<) is the same as (>=)
165                 mstore(dest, mload(src))
166                 dest := add(dest, 32)
167                 src := add(src, 32)
168             }
169 
170             // Copy remaining bytes
171             let srcPart := and(mload(src), not(mask))
172             let destPart := and(mload(dest), mask)
173             mstore(dest, or(destPart, srcPart))
174         }
175     }
176 }
177 
178 
179 /**
180  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
181  * the optional functions; to access them see `ERC20Detailed`.
182  */
183 interface IERC20 {
184     /**
185      * @dev Returns the amount of tokens in existence.
186      */
187     function totalSupply() external view returns (uint256);
188 
189     /**
190      * @dev Returns the amount of tokens owned by `account`.
191      */
192     function balanceOf(address account) external view returns (uint256);
193 
194     /**
195      * @dev Moves `amount` tokens from the caller's account to `recipient`.
196      *
197      * Returns a boolean value indicating whether the operation succeeded.
198      *
199      * Emits a `Transfer` event.
200      */
201     function transfer(address recipient, uint256 amount) external returns (bool);
202 
203     /**
204      * @dev Returns the remaining number of tokens that `spender` will be
205      * allowed to spend on behalf of `owner` through `transferFrom`. This is
206      * zero by default.
207      *
208      * This value changes when `approve` or `transferFrom` are called.
209      */
210     function allowance(address owner, address spender) external view returns (uint256);
211 
212     /**
213      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
214      *
215      * Returns a boolean value indicating whether the operation succeeded.
216      *
217      * > Beware that changing an allowance with this method brings the risk
218      * that someone may use both the old and the new allowance by unfortunate
219      * transaction ordering. One possible solution to mitigate this race
220      * condition is to first reduce the spender's allowance to 0 and set the
221      * desired value afterwards:
222      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
223      *
224      * Emits an `Approval` event.
225      */
226     function approve(address spender, uint256 amount) external returns (bool);
227 
228     /**
229      * @dev Moves `amount` tokens from `sender` to `recipient` using the
230      * allowance mechanism. `amount` is then deducted from the caller's
231      * allowance.
232      *
233      * Returns a boolean value indicating whether the operation succeeded.
234      *
235      * Emits a `Transfer` event.
236      */
237     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
238 
239     /**
240      * @dev Emitted when `value` tokens are moved from one account (`from`) to
241      * another (`to`).
242      *
243      * Note that `value` may be zero.
244      */
245     event Transfer(address indexed from, address indexed to, uint256 value);
246 
247     /**
248      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
249      * a call to `approve`. `value` is the new allowance.
250      */
251     event Approval(address indexed owner, address indexed spender, uint256 value);
252 }
253 
254 
255 /**
256  * @dev Wrappers over Solidity's arithmetic operations with added overflow
257  * checks.
258  *
259  * Arithmetic operations in Solidity wrap on overflow. This can easily result
260  * in bugs, because programmers usually assume that an overflow raises an
261  * error, which is the standard behavior in high level programming languages.
262  * `SafeMath` restores this intuition by reverting the transaction when an
263  * operation overflows.
264  *
265  * Using this library instead of the unchecked operations eliminates an entire
266  * class of bugs, so it's recommended to use it always.
267  */
268 library SafeMath {
269     /**
270      * @dev Returns the addition of two unsigned integers, reverting on
271      * overflow.
272      *
273      * Counterpart to Solidity's `+` operator.
274      *
275      * Requirements:
276      * - Addition cannot overflow.
277      */
278     function add(uint256 a, uint256 b) internal pure returns (uint256) {
279         uint256 c = a + b;
280         require(c >= a, "SafeMath: addition overflow");
281 
282         return c;
283     }
284 
285     /**
286      * @dev Returns the subtraction of two unsigned integers, reverting on
287      * overflow (when the result is negative).
288      *
289      * Counterpart to Solidity's `-` operator.
290      *
291      * Requirements:
292      * - Subtraction cannot overflow.
293      */
294     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
295         require(b <= a, "SafeMath: subtraction overflow");
296         uint256 c = a - b;
297 
298         return c;
299     }
300 
301     /**
302      * @dev Returns the multiplication of two unsigned integers, reverting on
303      * overflow.
304      *
305      * Counterpart to Solidity's `*` operator.
306      *
307      * Requirements:
308      * - Multiplication cannot overflow.
309      */
310     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
311         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
312         // benefit is lost if 'b' is also tested.
313         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
314         if (a == 0) {
315             return 0;
316         }
317 
318         uint256 c = a * b;
319         require(c / a == b, "SafeMath: multiplication overflow");
320 
321         return c;
322     }
323 
324     /**
325      * @dev Returns the integer division of two unsigned integers. Reverts on
326      * division by zero. The result is rounded towards zero.
327      *
328      * Counterpart to Solidity's `/` operator. Note: this function uses a
329      * `revert` opcode (which leaves remaining gas untouched) while Solidity
330      * uses an invalid opcode to revert (consuming all remaining gas).
331      *
332      * Requirements:
333      * - The divisor cannot be zero.
334      */
335     function div(uint256 a, uint256 b) internal pure returns (uint256) {
336         // Solidity only automatically asserts when dividing by 0
337         require(b > 0, "SafeMath: division by zero");
338         uint256 c = a / b;
339         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
340 
341         return c;
342     }
343 
344     /**
345      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
346      * Reverts when dividing by zero.
347      *
348      * Counterpart to Solidity's `%` operator. This function uses a `revert`
349      * opcode (which leaves remaining gas untouched) while Solidity uses an
350      * invalid opcode to revert (consuming all remaining gas).
351      *
352      * Requirements:
353      * - The divisor cannot be zero.
354      */
355     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
356         require(b != 0, "SafeMath: modulo by zero");
357         return a % b;
358     }
359 }
360 
361 
362 /**
363  * @dev Collection of functions related to the address type,
364  */
365 library Address {
366     /**
367      * @dev Returns true if `account` is a contract.
368      *
369      * This test is non-exhaustive, and there may be false-negatives: during the
370      * execution of a contract's constructor, its address will be reported as
371      * not containing a contract.
372      *
373      * > It is unsafe to assume that an address for which this function returns
374      * false is an externally-owned account (EOA) and not a contract.
375      */
376     function isContract(address account) internal view returns (bool) {
377         // This method relies in extcodesize, which returns 0 for contracts in
378         // construction, since the code is only stored at the end of the
379         // constructor execution.
380 
381         uint256 size;
382         // solhint-disable-next-line no-inline-assembly
383         assembly { size := extcodesize(account) }
384         return size > 0;
385     }
386 }
387 
388 
389 /**
390  * @dev Contract module which provides a basic access control mechanism, where
391  * there is an account (an owner) that can be granted exclusive access to
392  * specific functions.
393  *
394  * This module is used through inheritance. It will make available the modifier
395  * `onlyOwner`, which can be aplied to your functions to restrict their use to
396  * the owner.
397  */
398 contract Ownable {
399     address private _owner;
400 
401     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
402 
403     /**
404      * @dev Initializes the contract setting the deployer as the initial owner.
405      */
406     constructor () internal {
407         _owner = msg.sender;
408         emit OwnershipTransferred(address(0), _owner);
409     }
410 
411     /**
412      * @dev Returns the address of the current owner.
413      */
414     function owner() public view returns (address) {
415         return _owner;
416     }
417 
418     /**
419      * @dev Throws if called by any account other than the owner.
420      */
421     modifier onlyOwner() {
422         require(isOwner(), "Ownable: caller is not the owner");
423         _;
424     }
425 
426     /**
427      * @dev Returns true if the caller is the current owner.
428      */
429     function isOwner() public view returns (bool) {
430         return msg.sender == _owner;
431     }
432 
433     /**
434      * @dev Leaves the contract without owner. It will not be possible to call
435      * `onlyOwner` functions anymore. Can only be called by the current owner.
436      *
437      * > Note: Renouncing ownership will leave the contract without an owner,
438      * thereby removing any functionality that is only available to the owner.
439      */
440     function renounceOwnership() public onlyOwner {
441         emit OwnershipTransferred(_owner, address(0));
442         _owner = address(0);
443     }
444 
445     /**
446      * @dev Transfers ownership of the contract to a new account (`newOwner`).
447      * Can only be called by the current owner.
448      */
449     function transferOwnership(address newOwner) public onlyOwner {
450         _transferOwnership(newOwner);
451     }
452 
453     /**
454      * @dev Transfers ownership of the contract to a new account (`newOwner`).
455      */
456     function _transferOwnership(address newOwner) internal {
457         require(newOwner != address(0), "Ownable: new owner is the zero address");
458         emit OwnershipTransferred(_owner, newOwner);
459         _owner = newOwner;
460     }
461 }
462 
463 
464 
465 
466 /**
467  * @title SafeERC20
468  * @dev Wrappers around ERC20 operations that throw on failure (when the token
469  * contract returns false). Tokens that return no value (and instead revert or
470  * throw on failure) are also supported, non-reverting calls are assumed to be
471  * successful.
472  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
473  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
474  */
475 library SafeERC20 {
476     using SafeMath for uint256;
477     using Address for address;
478 
479     function safeTransfer(IERC20 token, address to, uint256 value) internal {
480         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
481     }
482 
483     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
484         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
485     }
486 
487     function safeApprove(IERC20 token, address spender, uint256 value) internal {
488         // safeApprove should only be called when setting an initial allowance,
489         // or when resetting it to zero. To increase and decrease it, use
490         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
491         // solhint-disable-next-line max-line-length
492         require((value == 0) || (token.allowance(address(this), spender) == 0),
493             "SafeERC20: approve from non-zero to non-zero allowance"
494         );
495         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
496     }
497 
498     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
499         uint256 newAllowance = token.allowance(address(this), spender).add(value);
500         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
501     }
502 
503     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
504         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
505         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
506     }
507 
508     /**
509      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
510      * on the return value: the return value is optional (but if data is returned, it must not be false).
511      * @param token The token targeted by the call.
512      * @param data The call data (encoded using abi.encode or one of its variants).
513      */
514     function callOptionalReturn(IERC20 token, bytes memory data) private {
515         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
516         // we're implementing it ourselves.
517 
518         // A Solidity high level call has three parts:
519         //  1. The target address is checked to verify it contains contract code
520         //  2. The call itself is made, and success asserted
521         //  3. The return value is decoded, which in turn checks the size of the returned data.
522         // solhint-disable-next-line max-line-length
523         require(address(token).isContract(), "SafeERC20: call to non-contract");
524 
525         // solhint-disable-next-line avoid-low-level-calls
526         (bool success, bytes memory returndata) = address(token).call(data);
527         require(success, "SafeERC20: low-level call failed");
528 
529         if (returndata.length > 0) { // Return data is optional
530             // solhint-disable-next-line max-line-length
531             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
532         }
533     }
534 }
535 
536 
537 
538 contract IWETH is IERC20 {
539 
540     function deposit() external payable;
541 
542     function withdraw(uint256 amount) external;
543 }
544 
545 
546 
547 contract TokenSpender is Ownable {
548 
549     using SafeERC20 for IERC20;
550 
551     function claimTokens(IERC20 token, address who, address dest, uint256 amount) external onlyOwner {
552         token.safeTransferFrom(who, dest, amount);
553     }
554 
555 }
556 
557 contract IERC20NonView {
558     // Methods are not view to avoid throw on proxy tokens with delegatecall inside
559     function balanceOf(address user) public returns(uint256);
560     function allowance(address from, address to) public returns(uint256);
561 }
562 
563 contract ZrxMarketOrder {
564 
565     using SafeMath for uint256;
566 
567     function marketSellOrders(
568         address makerAsset,
569         address zrxExchange,
570         address zrxTokenProxy,
571         uint256 takerAssetFillAmount,
572         IZrxExchange.Order[] calldata orders,
573         bytes[] calldata signatures
574     )
575         external
576         returns (IZrxExchange.FillResults memory totalFillResults)
577     {
578         for (uint i = 0; i < orders.length; i++) {
579 
580             // Stop execution if the entire amount of takerAsset has been sold
581             if (totalFillResults.takerAssetFilledAmount >= takerAssetFillAmount) {
582                 break;
583             }
584 
585             // Calculate the remaining amount of takerAsset to sell
586             uint256 remainingTakerAmount = takerAssetFillAmount.sub(totalFillResults.takerAssetFilledAmount);
587 
588             IZrxExchange.OrderInfo memory orderInfo = IZrxExchange(zrxExchange).getOrderInfo(orders[i]);
589             uint256 orderRemainingTakerAmount = orders[i].takerAssetAmount.sub(orderInfo.orderTakerAssetFilledAmount);
590 
591             // Check available balance and allowance and update orderRemainingTakerAmount
592             {
593                 uint256 balance = IERC20NonView(makerAsset).balanceOf(orders[i].makerAddress);
594                 uint256 allowance = IERC20NonView(makerAsset).allowance(orders[i].makerAddress, zrxTokenProxy);
595                 uint256 availableMakerAmount = (allowance < balance) ? allowance : balance;
596                 uint256 availableTakerAmount = availableMakerAmount.mul(orders[i].takerAssetAmount).div(orders[i].makerAssetAmount);
597 
598                 if (availableTakerAmount < orderRemainingTakerAmount) {
599                     orderRemainingTakerAmount = availableTakerAmount;
600                 }
601             }
602 
603             uint256 takerAmount = (orderRemainingTakerAmount < remainingTakerAmount) ? orderRemainingTakerAmount : remainingTakerAmount;
604 
605             IZrxExchange.FillResults memory fillResults = IZrxExchange(zrxExchange).fillOrderNoThrow(
606                 orders[i],
607                 takerAmount,
608                 signatures[i]
609             );
610 
611             addFillResults(totalFillResults, fillResults);
612         }
613 
614         return totalFillResults;
615     }
616 
617     function addFillResults(
618         IZrxExchange.FillResults memory totalFillResults,
619         IZrxExchange.FillResults memory singleFillResults
620     )
621         internal
622         pure
623     {
624         totalFillResults.makerAssetFilledAmount = totalFillResults.makerAssetFilledAmount.add(singleFillResults.makerAssetFilledAmount);
625         totalFillResults.takerAssetFilledAmount = totalFillResults.takerAssetFilledAmount.add(singleFillResults.takerAssetFilledAmount);
626         totalFillResults.makerFeePaid = totalFillResults.makerFeePaid.add(singleFillResults.makerFeePaid);
627         totalFillResults.takerFeePaid = totalFillResults.takerFeePaid.add(singleFillResults.takerFeePaid);
628     }
629 }
630 
631 
632 
633 contract AggregatedTokenSwap is CompressedCaller, ZrxMarketOrder {
634 
635     using SafeERC20 for IERC20;
636     using SafeMath for uint;
637     using ExternalCall for address;
638 
639     address constant ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
640 
641     TokenSpender public spender;
642     IGST2 gasToken;
643     address payable owner;
644     uint fee; // 10000 => 100%, 1 => 0.01%
645 
646     event OneInchFeePaid(
647         IERC20 indexed toToken,
648         address indexed referrer,
649         uint256 fee
650     );
651 
652     modifier onlyOwner {
653         require(
654             msg.sender == owner,
655             "Only owner can call this function."
656         );
657         _;
658     }
659 
660     constructor(
661         address payable _owner,
662         IGST2 _gasToken,
663         uint _fee
664     )
665     public
666     {
667         spender = new TokenSpender();
668         owner = _owner;
669         gasToken = _gasToken;
670         fee = _fee;
671     }
672 
673     function aggregate(
674         IERC20 fromToken,
675         IERC20 toToken,
676         uint tokensAmount,
677         address[] memory callAddresses,
678         bytes memory callDataConcat,
679         uint[] memory starts,
680         uint[] memory values,
681         uint mintGasPrice,
682         uint minTokensAmount,
683         uint guaranteedAmount,
684         address payable referrer
685     )
686     public
687     payable
688     returns (uint returnAmount)
689     {
690         returnAmount = gasleft();
691         uint gasTokenBalance = gasToken.balanceOf(address(this));
692 
693         require(callAddresses.length + 1 == starts.length);
694 
695         if (address(fromToken) != ETH_ADDRESS) {
696 
697             spender.claimTokens(fromToken, tx.origin, address(this), tokensAmount);
698         }
699 
700         for (uint i = 0; i < starts.length - 1; i++) {
701 
702             if (starts[i + 1] - starts[i] > 0) {
703 
704                 require(
705                     callDataConcat[starts[i] + 0] != spender.claimTokens.selector[0] ||
706                     callDataConcat[starts[i] + 1] != spender.claimTokens.selector[1] ||
707                     callDataConcat[starts[i] + 2] != spender.claimTokens.selector[2] ||
708                     callDataConcat[starts[i] + 3] != spender.claimTokens.selector[3]
709                 );
710                 require(callAddresses[i].externalCall(values[i], callDataConcat, starts[i], starts[i + 1] - starts[i]));
711             }
712         }
713 
714         //
715 
716         require(gasTokenBalance == gasToken.balanceOf(address(this)));
717         if (mintGasPrice > 0) {
718             audoRefundGas(returnAmount, mintGasPrice);
719         }
720 
721         //
722 
723         returnAmount = _balanceOf(toToken, address(this));
724         require(returnAmount >= minTokensAmount, "Return amount is not enough");
725 
726         if (returnAmount > guaranteedAmount) {
727 
728             uint feeAmount = returnAmount.sub(guaranteedAmount).mul(fee).div(10000);
729 
730             if (feeAmount.mul(10000).div(returnAmount) > 100) { // 1%
731 
732                 feeAmount = returnAmount.div(100); // 1%
733             }
734 
735             if (referrer != address(0) && referrer != tx.origin && referrer != tx.origin) {
736                 if (_transfer(toToken, referrer, feeAmount.div(10), true)) {
737                     returnAmount = returnAmount.sub(feeAmount.div(10));
738                     emit OneInchFeePaid(toToken, referrer, feeAmount.div(10));
739                     feeAmount = feeAmount.mul(9).div(10);
740                 } else {
741                     emit OneInchFeePaid(toToken, address(0), feeAmount);
742                 }
743             } else {
744                 emit OneInchFeePaid(toToken, address(0), feeAmount);
745             }
746 
747             if (_transfer(toToken, owner, feeAmount, true)) {
748                 returnAmount = returnAmount.sub(feeAmount);
749             }
750         }
751 
752         _transfer(toToken, tx.origin, returnAmount, false);
753     }
754 
755     function infiniteApproveIfNeeded(IERC20 token, address to) external {
756         if (
757             address(token) != ETH_ADDRESS &&
758             token.allowance(address(this), to) == 0
759         ) {
760             token.safeApprove(to, uint256(-1));
761         }
762     }
763 
764     function withdrawAllToken(IWETH token) external {
765         uint256 amount = token.balanceOf(address(this));
766         token.withdraw(amount);
767     }
768 
769     function marketSellOrdersProportion(
770         IERC20 tokenSell,
771         address tokenBuy,
772         address zrxExchange,
773         address zrxTokenProxy,
774         IZrxExchange.Order[] calldata orders,
775         bytes[] calldata signatures,
776         uint256 mul,
777         uint256 div
778     )
779     external
780     {
781         uint256 amount = tokenSell.balanceOf(address(this)).mul(mul).div(div);
782         this.marketSellOrders(tokenBuy, zrxExchange, zrxTokenProxy, amount, orders, signatures);
783     }
784 
785     function _balanceOf(IERC20 token, address who) internal view returns(uint256) {
786         if (address(token) == ETH_ADDRESS || token == IERC20(0)) {
787             return who.balance;
788         } else {
789             return token.balanceOf(who);
790         }
791     }
792 
793     function _transfer(IERC20 token, address payable to, uint256 amount, bool allowFail) internal returns(bool) {
794         if (address(token) == ETH_ADDRESS || token == IERC20(0)) {
795             if (allowFail) {
796                 return to.send(amount);
797             } else {
798                 to.transfer(amount);
799                 return true;
800             }
801         } else {
802             token.safeTransfer(to, amount);
803             return true;
804         }
805     }
806 
807     function audoRefundGas(
808         uint startGas,
809         uint mintGasPrice
810     )
811     private
812     returns (uint freed)
813     {
814         uint MINT_BASE = 32254;
815         uint MINT_TOKEN = 36543;
816         uint FREE_BASE = 14154;
817         uint FREE_TOKEN = 6870;
818         uint REIMBURSE = 24000;
819 
820         uint tokensAmount = ((startGas - gasleft()) + FREE_BASE) / (2 * REIMBURSE - FREE_TOKEN);
821         uint maxReimburse = tokensAmount * REIMBURSE;
822 
823         uint mintCost = MINT_BASE + (tokensAmount * MINT_TOKEN);
824         uint freeCost = FREE_BASE + (tokensAmount * FREE_TOKEN);
825 
826         uint efficiency = (maxReimburse * 100 * tx.gasprice) / (mintCost * mintGasPrice + freeCost * tx.gasprice);
827 
828         if (efficiency > 100) {
829 
830             return refundGas(
831                 tokensAmount
832             );
833         } else {
834 
835             return 0;
836         }
837     }
838 
839     function refundGas(
840         uint tokensAmount
841     )
842     private
843     returns (uint freed)
844     {
845 
846         if (tokensAmount > 0) {
847 
848             uint safeNumTokens = 0;
849             uint gas = gasleft();
850 
851             if (gas >= 27710) {
852                 safeNumTokens = (gas - 27710) / (1148 + 5722 + 150);
853             }
854 
855             if (tokensAmount > safeNumTokens) {
856                 tokensAmount = safeNumTokens;
857             }
858 
859             uint gasTokenBalance = IERC20(address(gasToken)).balanceOf(address(this));
860 
861             if (tokensAmount > 0 && gasTokenBalance >= tokensAmount) {
862 
863                 return gasToken.freeUpTo(tokensAmount);
864             } else {
865 
866                 return 0;
867             }
868         } else {
869 
870             return 0;
871         }
872     }
873 
874     function() external payable {
875 
876         if (msg.value == 0 && msg.sender == owner) {
877 
878             IERC20 _gasToken = IERC20(address(gasToken));
879 
880             owner.transfer(address(this).balance);
881             _gasToken.safeTransfer(owner, _gasToken.balanceOf(address(this)));
882         }
883     }
884 
885     function getOrdersInfoRespectingBalancesAndAllowances(
886         IERC20 token,
887         IZrxExchange zrx,
888         address zrxTokenProxy,
889         IZrxExchange.Order[] memory orders
890     )
891         public
892         view
893         returns (IZrxExchange.OrderInfo[] memory ordersInfo)
894     {
895         ordersInfo = zrx.getOrdersInfo(orders);
896 
897         for (uint i = 0; i < ordersInfo.length; i++) {
898 
899             uint256 balance = token.balanceOf(orders[i].makerAddress);
900             uint256 allowance = token.allowance(orders[i].makerAddress, zrxTokenProxy);
901             uint256 availableMakerAmount = (allowance < balance) ? allowance : balance;
902             uint256 availableTakerAmount = availableMakerAmount.mul(orders[i].takerAssetAmount).div(orders[i].makerAssetAmount);
903 
904             for (uint j = 0; j < i; j++) {
905 
906                 if (orders[j].makerAddress == orders[i].makerAddress) {
907 
908                     uint256 orderTakerAssetRemainigAmount = orders[j].takerAssetAmount.sub(
909                         ordersInfo[j].orderTakerAssetFilledAmount
910                     );
911 
912                     if (availableTakerAmount > orderTakerAssetRemainigAmount) {
913                         availableTakerAmount = availableTakerAmount.sub(orderTakerAssetRemainigAmount);
914                     } else {
915                         availableTakerAmount = 0;
916                         break;
917                     }
918                 }
919             }
920 
921             uint256 remainingTakerAmount = orders[i].takerAssetAmount.sub(
922                 ordersInfo[i].orderTakerAssetFilledAmount
923             );
924 
925             if (availableTakerAmount < remainingTakerAmount) {
926 
927                 ordersInfo[i].orderTakerAssetFilledAmount = orders[i].takerAssetAmount.sub(availableTakerAmount);
928             }
929         }
930     }
931 }