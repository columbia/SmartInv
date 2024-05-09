1 // File: contracts/lib/math/SafeMath.sol
2 
3 pragma solidity 0.5.12;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b <= a, "SafeMath: subtraction overflow");
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     /**
52      * @dev Returns the multiplication of two unsigned integers, reverting on
53      * overflow.
54      *
55      * Counterpart to Solidity's `*` operator.
56      *
57      * Requirements:
58      * - Multiplication cannot overflow.
59      */
60     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
62         // benefit is lost if 'b' is also tested.
63         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
64         if (a == 0) {
65             return 0;
66         }
67 
68         uint256 c = a * b;
69         require(c / a == b, "SafeMath: multiplication overflow");
70 
71         return c;
72     }
73 
74     /**
75      * @dev Returns the integer division of two unsigned integers. Reverts on
76      * division by zero. The result is rounded towards zero.
77      *
78      * Counterpart to Solidity's `/` operator. Note: this function uses a
79      * `revert` opcode (which leaves remaining gas untouched) while Solidity
80      * uses an invalid opcode to revert (consuming all remaining gas).
81      *
82      * Requirements:
83      * - The divisor cannot be zero.
84      */
85     function div(uint256 a, uint256 b) internal pure returns (uint256) {
86         // Solidity only automatically asserts when dividing by 0
87         require(b > 0, "SafeMath: division by zero");
88         uint256 c = a / b;
89         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90 
91         return c;
92     }
93 
94     /**
95      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
96      * Reverts when dividing by zero.
97      *
98      * Counterpart to Solidity's `%` operator. This function uses a `revert`
99      * opcode (which leaves remaining gas untouched) while Solidity uses an
100      * invalid opcode to revert (consuming all remaining gas).
101      *
102      * Requirements:
103      * - The divisor cannot be zero.
104      */
105     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
106         require(b != 0, "SafeMath: modulo by zero");
107         return a % b;
108     }
109 }
110 
111 // File: contracts/lib/ownership/Ownable.sol
112 
113 pragma solidity 0.5.12;
114 
115 /**
116  * @dev Contract module which provides a basic access control mechanism, where
117  * there is an account (an owner) that can be granted exclusive access to
118  * specific functions.
119  *
120  * This module is used through inheritance. It will make available the modifier
121  * `onlyOwner`, which can be aplied to your functions to restrict their use to
122  * the owner.
123  */
124 contract Ownable {
125     address public owner;
126     address public pendingOwner;
127 
128     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
129 
130     /**
131      * @dev Initializes the contract setting the deployer as the initial owner.
132      */
133     constructor () internal {
134         owner = msg.sender;
135         emit OwnershipTransferred(address(0), owner);
136     }
137 
138     /**
139     * @dev Modifier throws if called by any account other than the pendingOwner.
140     */
141     modifier onlyPendingOwner() {
142         require(msg.sender == pendingOwner);
143         _;
144     }
145 
146     /**
147      * @dev Throws if called by any account other than the owner.
148      */
149     modifier onlyOwner() {
150         require(isOwner(), "Ownable: caller is not the owner");
151         _;
152     }
153 
154     /**
155      * @dev Returns true if the caller is the current owner.
156      */
157     function isOwner() public view returns (bool) {
158         return msg.sender == owner;
159     }
160 
161     /**
162     * @dev Allows the current owner to set the pendingOwner address.
163     * @param newOwner The address to transfer ownership to.
164     */
165     function transferOwnership(address newOwner) public onlyOwner {
166         pendingOwner = newOwner;
167     }
168 
169     /**
170     * @dev Allows the pendingOwner address to finalize the transfer.
171     */
172     function claimOwnership() public onlyPendingOwner {
173         emit OwnershipTransferred(owner, pendingOwner);
174         owner = pendingOwner;
175         pendingOwner = address(0);
176     }
177 }
178 
179 // File: contracts/lib/utils/ReentrancyGuard.sol
180 
181 pragma solidity ^0.5.0;
182 
183 /**
184  * @dev Contract module that helps prevent reentrant calls to a function.
185  *
186  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
187  * available, which can be aplied to functions to make sure there are no nested
188  * (reentrant) calls to them.
189  *
190  * Note that because there is a single `nonReentrant` guard, functions marked as
191  * `nonReentrant` may not call one another. This can be worked around by making
192  * those functions `private`, and then adding `external` `nonReentrant` entry
193  * points to them.
194  */
195 contract ReentrancyGuard {
196     /// @dev counter to allow mutex lock with only one SSTORE operation
197     uint256 private _guardCounter;
198 
199     constructor () internal {
200         // The counter starts at one to prevent changing it from zero to a non-zero
201         // value, which is a more expensive operation.
202         _guardCounter = 1;
203     }
204 
205     /**
206      * @dev Prevents a contract from calling itself, directly or indirectly.
207      * Calling a `nonReentrant` function from another `nonReentrant`
208      * function is not supported. It is possible to prevent this from happening
209      * by making the `nonReentrant` function external, and make it call a
210      * `private` function that does the actual work.
211      */
212     modifier nonReentrant() {
213         _guardCounter += 1;
214         uint256 localCounter = _guardCounter;
215         _;
216         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
217     }
218 }
219 
220 // File: contracts/Utils.sol
221 
222 pragma solidity 0.5.12;
223 
224 
225 interface ERC20 {
226     function balanceOf(address account) external view returns (uint256);
227 }
228 
229 interface MarketDapp {
230     // Returns the address to approve tokens for
231     function tokenReceiver(address[] calldata assetIds, uint256[] calldata dataValues, address[] calldata addresses) external view returns(address);
232     function trade(address[] calldata assetIds, uint256[] calldata dataValues, address[] calldata addresses, address payable recipient) external payable;
233 }
234 
235 /// @title Util functions for the BrokerV2 contract for Switcheo Exchange
236 /// @author Switcheo Network
237 /// @notice Functions were moved from the BrokerV2 contract into this contract
238 /// so that the BrokerV2 contract would not exceed the maximum contract size of
239 /// 24 KB.
240 library Utils {
241     using SafeMath for uint256;
242 
243     // The constants for EIP-712 are precompiled to reduce contract size,
244     // the original values are left here for reference and verification.
245     //
246     // bytes32 public constant EIP712_DOMAIN_TYPEHASH = keccak256(abi.encodePacked(
247     //     "EIP712Domain(",
248     //         "string name,",
249     //         "string version,",
250     //         "uint256 chainId,",
251     //         "address verifyingContract,",
252     //         "bytes32 salt",
253     //     ")"
254     // ));
255     // bytes32 public constant EIP712_DOMAIN_TYPEHASH = 0xd87cd6ef79d4e2b95e15ce8abf732db51ec771f1ca2edccf22a46c729ac56472;
256     //
257     // bytes32 public constant CONTRACT_NAME = keccak256("Switcheo Exchange");
258     // bytes32 public constant CONTRACT_VERSION = keccak256("2");
259     // uint256 public constant CHAIN_ID = 1;
260     // address public constant VERIFYING_CONTRACT = 0x7ee7Ca6E75dE79e618e88bDf80d0B1DB136b22D0;
261     // bytes32 public constant SALT = keccak256("switcheo-eth-salt");
262 
263     // bytes32 public constant DOMAIN_SEPARATOR = keccak256(abi.encode(
264     //     EIP712_DOMAIN_TYPEHASH,
265     //     CONTRACT_NAME,
266     //     CONTRACT_VERSION,
267     //     CHAIN_ID,
268     //     VERIFYING_CONTRACT,
269     //     SALT
270     // ));
271     bytes32 public constant DOMAIN_SEPARATOR = 0x256c0713d13c6a01bd319a2f7edabde771b6c167d37c01778290d60b362ccc7d;
272 
273     // bytes32 public constant OFFER_TYPEHASH = keccak256(abi.encodePacked(
274     //     "Offer(",
275     //         "address maker,",
276     //         "address offerAssetId,",
277     //         "uint256 offerAmount,",
278     //         "address wantAssetId,",
279     //         "uint256 wantAmount,",
280     //         "address feeAssetId,",
281     //         "uint256 feeAmount,",
282     //         "uint256 nonce",
283     //     ")"
284     // ));
285     bytes32 public constant OFFER_TYPEHASH = 0xf845c83a8f7964bc8dd1a092d28b83573b35be97630a5b8a3b8ae2ae79cd9260;
286 
287     // bytes32 public constant CANCEL_TYPEHASH = keccak256(abi.encodePacked(
288     //     "Cancel(",
289     //         "bytes32 offerHash,",
290     //         "address feeAssetId,",
291     //         "uint256 feeAmount,",
292     //     ")"
293     // ));
294     bytes32 public constant CANCEL_TYPEHASH = 0x46f6d088b1f0ff5a05c3f232c4567f2df96958e05457e6c0e1221dcee7d69c18;
295 
296     // bytes32 public constant FILL_TYPEHASH = keccak256(abi.encodePacked(
297     //     "Fill(",
298     //         "address filler,",
299     //         "address offerAssetId,",
300     //         "uint256 offerAmount,",
301     //         "address wantAssetId,",
302     //         "uint256 wantAmount,",
303     //         "address feeAssetId,",
304     //         "uint256 feeAmount,",
305     //         "uint256 nonce",
306     //     ")"
307     // ));
308     bytes32 public constant FILL_TYPEHASH = 0x5f59dbc3412a4575afed909d028055a91a4250ce92235f6790c155a4b2669e99;
309 
310     // The Ether token address is set as the constant 0x00 for backwards
311     // compatibility
312     address private constant ETHER_ADDR = address(0);
313 
314     uint256 private constant mask8 = ~(~uint256(0) << 8);
315     uint256 private constant mask16 = ~(~uint256(0) << 16);
316     uint256 private constant mask24 = ~(~uint256(0) << 24);
317     uint256 private constant mask32 = ~(~uint256(0) << 32);
318     uint256 private constant mask40 = ~(~uint256(0) << 40);
319     uint256 private constant mask48 = ~(~uint256(0) << 48);
320     uint256 private constant mask56 = ~(~uint256(0) << 56);
321     uint256 private constant mask120 = ~(~uint256(0) << 120);
322     uint256 private constant mask128 = ~(~uint256(0) << 128);
323     uint256 private constant mask136 = ~(~uint256(0) << 136);
324     uint256 private constant mask144 = ~(~uint256(0) << 144);
325 
326     event Trade(
327         address maker,
328         address taker,
329         address makerGiveAsset,
330         uint256 makerGiveAmount,
331         address fillerGiveAsset,
332         uint256 fillerGiveAmount
333     );
334 
335     /// @dev Calculates the balance increments for a set of trades
336     /// @param _values The _values param from the trade method
337     /// @param _incrementsLength Should match the value of _addresses.length / 2
338     /// from the trade method
339     /// @return An array of increments
340     function calculateTradeIncrements(
341         uint256[] memory _values,
342         uint256 _incrementsLength
343     )
344         public
345         pure
346         returns (uint256[] memory)
347     {
348         uint256[] memory increments = new uint256[](_incrementsLength);
349         _creditFillBalances(increments, _values);
350         _creditMakerBalances(increments, _values);
351         _creditMakerFeeBalances(increments, _values);
352         return increments;
353     }
354 
355     /// @dev Calculates the balance decrements for a set of trades
356     /// @param _values The _values param from the trade method
357     /// @param _decrementsLength Should match the value of _addresses.length / 2
358     /// from the trade method
359     /// @return An array of decrements
360     function calculateTradeDecrements(
361         uint256[] memory _values,
362         uint256 _decrementsLength
363     )
364         public
365         pure
366         returns (uint256[] memory)
367     {
368         uint256[] memory decrements = new uint256[](_decrementsLength);
369         _deductFillBalances(decrements, _values);
370         _deductMakerBalances(decrements, _values);
371         return decrements;
372     }
373 
374     /// @dev Calculates the balance increments for a set of network trades
375     /// @param _values The _values param from the networkTrade method
376     /// @param _incrementsLength Should match the value of _addresses.length / 2
377     /// from the networkTrade method
378     /// @return An array of increments
379     function calculateNetworkTradeIncrements(
380         uint256[] memory _values,
381         uint256 _incrementsLength
382     )
383         public
384         pure
385         returns (uint256[] memory)
386     {
387         uint256[] memory increments = new uint256[](_incrementsLength);
388         _creditMakerBalances(increments, _values);
389         _creditMakerFeeBalances(increments, _values);
390         return increments;
391     }
392 
393     /// @dev Calculates the balance decrements for a set of network trades
394     /// @param _values The _values param from the trade method
395     /// @param _decrementsLength Should match the value of _addresses.length / 2
396     /// from the networkTrade method
397     /// @return An array of decrements
398     function calculateNetworkTradeDecrements(
399         uint256[] memory _values,
400         uint256 _decrementsLength
401     )
402         public
403         pure
404         returns (uint256[] memory)
405     {
406         uint256[] memory decrements = new uint256[](_decrementsLength);
407         _deductMakerBalances(decrements, _values);
408         return decrements;
409     }
410 
411     /// @dev Validates `BrokerV2.trade` parameters to ensure trade fairness,
412     /// see `BrokerV2.trade` for param details.
413     /// @param _values Values from `trade`
414     /// @param _hashes Hashes from `trade`
415     /// @param _addresses Addresses from `trade`
416     function validateTrades(
417         uint256[] memory _values,
418         bytes32[] memory _hashes,
419         address[] memory _addresses,
420         address _operator
421     )
422         public
423         returns (bytes32[] memory)
424     {
425         _validateTradeInputLengths(_values, _hashes);
426         _validateUniqueOffers(_values);
427         _validateMatches(_values, _addresses);
428         _validateFillAmounts(_values);
429         _validateTradeData(_values, _addresses, _operator);
430 
431         // validate signatures of all offers
432         _validateTradeSignatures(
433             _values,
434             _hashes,
435             _addresses,
436             OFFER_TYPEHASH,
437             0,
438             _values[0] & mask8 // numOffers
439         );
440 
441         // validate signatures of all fills
442         _validateTradeSignatures(
443             _values,
444             _hashes,
445             _addresses,
446             FILL_TYPEHASH,
447             _values[0] & mask8, // numOffers
448             (_values[0] & mask8) + ((_values[0] & mask16) >> 8) // numOffers + numFills
449         );
450 
451         _emitTradeEvents(_values, _addresses, new address[](0), false);
452 
453         return _hashes;
454     }
455 
456     /// @dev Validates `BrokerV2.networkTrade` parameters to ensure trade fairness,
457     /// see `BrokerV2.networkTrade` for param details.
458     /// @param _values Values from `networkTrade`
459     /// @param _hashes Hashes from `networkTrade`
460     /// @param _addresses Addresses from `networkTrade`
461     /// @param _operator Address of the `BrokerV2.operator`
462     function validateNetworkTrades(
463         uint256[] memory _values,
464         bytes32[] memory _hashes,
465         address[] memory _addresses,
466         address _operator
467     )
468         public
469         pure
470         returns (bytes32[] memory)
471     {
472         _validateNetworkTradeInputLengths(_values, _hashes);
473         _validateUniqueOffers(_values);
474         _validateNetworkMatches(_values, _addresses, _operator);
475         _validateTradeData(_values, _addresses, _operator);
476 
477         // validate signatures of all offers
478         _validateTradeSignatures(
479             _values,
480             _hashes,
481             _addresses,
482             OFFER_TYPEHASH,
483             0,
484             _values[0] & mask8 // numOffers
485         );
486 
487         return _hashes;
488     }
489 
490     /// @dev Executes trades against external markets,
491     /// see `BrokerV2.networkTrade` for param details.
492     /// @param _values Values from `networkTrade`
493     /// @param _addresses Addresses from `networkTrade`
494     /// @param _marketDapps See `BrokerV2.marketDapps`
495     function performNetworkTrades(
496         uint256[] memory _values,
497         address[] memory _addresses,
498         address[] memory _marketDapps
499     )
500         public
501         returns (uint256[] memory)
502     {
503         uint256[] memory increments = new uint256[](_addresses.length / 2);
504         // i = 1 + numOffers * 2
505         uint256 i = 1 + (_values[0] & mask8) * 2;
506         uint256 end = _values.length;
507 
508         // loop matches
509         for(i; i < end; i++) {
510             uint256[] memory data = new uint256[](9);
511             data[0] = _values[i]; // match data
512             data[1] = data[0] & mask8; // offerIndex
513             data[2] = (data[0] & mask24) >> 16; // operator.surplusAssetIndex
514             data[3] = _values[data[1] * 2 + 1]; // offer.dataA
515             data[4] = _values[data[1] * 2 + 2]; // offer.dataB
516             data[5] = ((data[3] & mask16) >> 8); // maker.offerAssetIndex
517             data[6] = ((data[3] & mask24) >> 16); // maker.wantAssetIndex
518             // amount of offerAssetId to take from the offer is equal to the match.takeAmount
519             data[7] = data[0] >> 128;
520             // expected amount to receive is: matchData.takeAmount * offer.wantAmount / offer.offerAmount
521             data[8] = data[7].mul(data[4] >> 128).div(data[4] & mask128);
522 
523             address[] memory assetIds = new address[](3);
524             assetIds[0] = _addresses[data[5] * 2 + 1]; // offer.offerAssetId
525             assetIds[1] = _addresses[data[6] * 2 + 1]; // offer.wantAssetId
526             assetIds[2] = _addresses[data[2] * 2 + 1]; // surplusAssetId
527 
528             uint256[] memory dataValues = new uint256[](3);
529             dataValues[0] = data[7]; // the proportion of offerAmount to offer
530             dataValues[1] = data[8]; // the proportion of wantAmount to receive for the offer
531             dataValues[2] = data[0]; // match data
532 
533             increments[data[2]] = _performNetworkTrade(
534                 assetIds,
535                 dataValues,
536                 _marketDapps,
537                 _addresses
538             );
539         }
540 
541         _emitTradeEvents(_values, _addresses, _marketDapps, true);
542 
543         return increments;
544     }
545 
546     /// @dev Validates the signature of a cancel invocation
547     /// @param _values The _values param from the cancel method
548     /// @param _hashes The _hashes param from the cancel method
549     /// @param _addresses The _addresses param from the cancel method
550     function validateCancel(
551         uint256[] memory _values,
552         bytes32[] memory _hashes,
553         address[] memory _addresses
554     )
555         public
556         pure
557     {
558         bytes32 offerHash = hashOffer(_values, _addresses);
559 
560         bytes32 cancelHash = keccak256(abi.encode(
561             CANCEL_TYPEHASH,
562             offerHash,
563             _addresses[4],
564             _values[1] >> 128
565         ));
566 
567         validateSignature(
568             cancelHash,
569             _addresses[0], // maker
570             uint8((_values[2] & mask144) >> 136), // v
571             _hashes[0], // r
572             _hashes[1], // s
573             ((_values[2] & mask136) >> 128) != 0 // prefixedSignature
574         );
575     }
576 
577     /// @dev Hashes an offer for the cancel method
578     /// @param _values The _values param from the cancel method
579     /// @param _addresses THe _addresses param from the cancel method
580     /// @return The hash of the offer
581     function hashOffer(
582         uint256[] memory _values,
583         address[] memory _addresses
584     )
585         public
586         pure
587         returns (bytes32)
588     {
589         return keccak256(abi.encode(
590             OFFER_TYPEHASH,
591             _addresses[0], // maker
592             _addresses[1], // offerAssetId
593             _values[0] & mask128, // offerAmount
594             _addresses[2], // wantAssetId
595             _values[0] >> 128, // wantAmount
596             _addresses[3], // feeAssetId
597             _values[1] & mask128, // feeAmount
598             _values[2] >> 144 // offerNonce
599         ));
600     }
601 
602     /// @notice Approves a token transfer
603     /// @param _assetId The address of the token to approve
604     /// @param _spender The address of the spender to approve
605     /// @param _amount The number of tokens to approve
606     function approveTokenTransfer(
607         address _assetId,
608         address _spender,
609         uint256 _amount
610     )
611         public
612     {
613         _validateContractAddress(_assetId);
614 
615         // Some tokens have an `approve` which returns a boolean and some do not.
616         // The ERC20 interface cannot be used here because it requires specifying
617         // an explicit return value, and an EVM exception would be raised when calling
618         // a token with the mismatched return value.
619         bytes memory payload = abi.encodeWithSignature(
620             "approve(address,uint256)",
621             _spender,
622             _amount
623         );
624         bytes memory returnData = _callContract(_assetId, payload);
625         // Ensure that the asset transfer succeeded
626         _validateContractCallResult(returnData);
627     }
628 
629     /// @notice Transfers tokens into the contract
630     /// @param _user The address to transfer the tokens from
631     /// @param _assetId The address of the token to transfer
632     /// @param _amount The number of tokens to transfer
633     /// @param _expectedAmount The number of tokens expected to be received,
634     /// this may not match `_amount`, for example, tokens which have a
635     /// proportion burnt on transfer will have a different amount received.
636     function transferTokensIn(
637         address _user,
638         address _assetId,
639         uint256 _amount,
640         uint256 _expectedAmount
641     )
642         public
643     {
644         _validateContractAddress(_assetId);
645 
646         uint256 initialBalance = tokenBalance(_assetId);
647 
648         // Some tokens have a `transferFrom` which returns a boolean and some do not.
649         // The ERC20 interface cannot be used here because it requires specifying
650         // an explicit return value, and an EVM exception would be raised when calling
651         // a token with the mismatched return value.
652         bytes memory payload = abi.encodeWithSignature(
653             "transferFrom(address,address,uint256)",
654             _user,
655             address(this),
656             _amount
657         );
658         bytes memory returnData = _callContract(_assetId, payload);
659         // Ensure that the asset transfer succeeded
660         _validateContractCallResult(returnData);
661 
662         uint256 finalBalance = tokenBalance(_assetId);
663         uint256 transferredAmount = finalBalance.sub(initialBalance);
664 
665         require(transferredAmount == _expectedAmount, "Invalid transfer");
666     }
667 
668     /// @notice Transfers tokens from the contract to a user
669     /// @param _receivingAddress The address to transfer the tokens to
670     /// @param _assetId The address of the token to transfer
671     /// @param _amount The number of tokens to transfer
672     function transferTokensOut(
673         address _receivingAddress,
674         address _assetId,
675         uint256 _amount
676     )
677         public
678     {
679         _validateContractAddress(_assetId);
680 
681         // Some tokens have a `transfer` which returns a boolean and some do not.
682         // The ERC20 interface cannot be used here because it requires specifying
683         // an explicit return value, and an EVM exception would be raised when calling
684         // a token with the mismatched return value.
685         bytes memory payload = abi.encodeWithSignature(
686                                    "transfer(address,uint256)",
687                                    _receivingAddress,
688                                    _amount
689                                );
690         bytes memory returnData = _callContract(_assetId, payload);
691 
692         // Ensure that the asset transfer succeeded
693         _validateContractCallResult(returnData);
694     }
695 
696     /// @notice Returns the number of tokens owned by this contract
697     /// @param _assetId The address of the token to query
698     function externalBalance(address _assetId) public view returns (uint256) {
699         if (_assetId == ETHER_ADDR) {
700             return address(this).balance;
701         }
702         return tokenBalance(_assetId);
703     }
704 
705     /// @notice Returns the number of tokens owned by this contract.
706     /// @dev This will not work for Ether tokens, use `externalBalance` for
707     /// Ether tokens.
708     /// @param _assetId The address of the token to query
709     function tokenBalance(address _assetId) public view returns (uint256) {
710         return ERC20(_assetId).balanceOf(address(this));
711     }
712 
713     /// @dev Validates that the specified `_hash` was signed by the specified `_user`.
714     /// This method supports the EIP712 specification, the older Ethereum
715     /// signed message specification is also supported for backwards compatibility.
716     /// @param _hash The original hash that was signed by the user
717     /// @param _user The user who signed the hash
718     /// @param _v The `v` component of the `_user`'s signature
719     /// @param _r The `r` component of the `_user`'s signature
720     /// @param _s The `s` component of the `_user`'s signature
721     /// @param _prefixed If true, the signature will be verified
722     /// against the Ethereum signed message specification instead of the
723     /// EIP712 specification
724     function validateSignature(
725         bytes32 _hash,
726         address _user,
727         uint8 _v,
728         bytes32 _r,
729         bytes32 _s,
730         bool _prefixed
731     )
732         public
733         pure
734     {
735         bytes32 eip712Hash = keccak256(abi.encodePacked(
736             "\x19\x01",
737             DOMAIN_SEPARATOR,
738             _hash
739         ));
740 
741         if (_prefixed) {
742             bytes32 prefixedHash = keccak256(abi.encodePacked(
743                 "\x19Ethereum Signed Message:\n32",
744                 eip712Hash
745             ));
746             require(_user == ecrecover(prefixedHash, _v, _r, _s), "Invalid signature");
747         } else {
748             require(_user == ecrecover(eip712Hash, _v, _r, _s), "Invalid signature");
749         }
750     }
751 
752     /// @dev Ensures that `_address` is not the zero address
753     /// @param _address The address to check
754     function validateAddress(address _address) public pure {
755         require(_address != address(0), "Invalid address");
756     }
757 
758     /// @dev Credit fillers for each fill.wantAmount,and credit the operator
759     /// for each fill.feeAmount. See the `trade` method for param details.
760     /// @param _values Values from `trade`
761     function _creditFillBalances(
762         uint256[] memory _increments,
763         uint256[] memory _values
764     )
765         private
766         pure
767     {
768         // 1 + numOffers * 2
769         uint256 i = 1 + (_values[0] & mask8) * 2;
770         // i + numFills * 2
771         uint256 end = i + ((_values[0] & mask16) >> 8) * 2;
772 
773         // loop fills
774         for(i; i < end; i += 2) {
775             uint256 fillerWantAssetIndex = (_values[i] & mask24) >> 16;
776             uint256 wantAmount = _values[i + 1] >> 128;
777 
778             // credit fill.wantAmount to filler
779             _increments[fillerWantAssetIndex] = _increments[fillerWantAssetIndex].add(wantAmount);
780 
781             uint256 feeAmount = _values[i] >> 128;
782             if (feeAmount == 0) { continue; }
783 
784             uint256 operatorFeeAssetIndex = ((_values[i] & mask40) >> 32);
785             // credit fill.feeAmount to operator
786             _increments[operatorFeeAssetIndex] = _increments[operatorFeeAssetIndex].add(feeAmount);
787         }
788     }
789 
790     /// @dev Credit makers for each amount received through a matched fill.
791     /// See the `trade` method for param details.
792     /// @param _values Values from `trade`
793     function _creditMakerBalances(
794         uint256[] memory _increments,
795         uint256[] memory _values
796     )
797         private
798         pure
799     {
800         uint256 i = 1;
801         // i += numOffers * 2
802         i += (_values[0] & mask8) * 2;
803         // i += numFills * 2
804         i += ((_values[0] & mask16) >> 8) * 2;
805 
806         uint256 end = _values.length;
807 
808         // loop matches
809         for(i; i < end; i++) {
810             // match.offerIndex
811             uint256 offerIndex = _values[i] & mask8;
812             // maker.wantAssetIndex
813             uint256 makerWantAssetIndex = (_values[1 + offerIndex * 2] & mask24) >> 16;
814 
815             // match.takeAmount
816             uint256 amount = _values[i] >> 128;
817             // receiveAmount = match.takeAmount * offer.wantAmount / offer.offerAmount
818             amount = amount.mul(_values[2 + offerIndex * 2] >> 128)
819                            .div(_values[2 + offerIndex * 2] & mask128);
820 
821             // credit maker for the amount received from the match
822             _increments[makerWantAssetIndex] = _increments[makerWantAssetIndex].add(amount);
823         }
824     }
825 
826     /// @dev Credit the operator for each offer.feeAmount if the offer has not
827     /// been recorded through a previous `trade` call.
828     /// See the `trade` method for param details.
829     /// @param _values Values from `trade`
830     function _creditMakerFeeBalances(
831         uint256[] memory _increments,
832         uint256[] memory _values
833     )
834         private
835         pure
836     {
837         uint256 i = 1;
838         // i + numOffers * 2
839         uint256 end = i + (_values[0] & mask8) * 2;
840 
841         // loop offers
842         for(i; i < end; i += 2) {
843             bool nonceTaken = ((_values[i] & mask128) >> 120) == 1;
844             if (nonceTaken) { continue; }
845 
846             uint256 feeAmount = _values[i] >> 128;
847             if (feeAmount == 0) { continue; }
848 
849             uint256 operatorFeeAssetIndex = (_values[i] & mask40) >> 32;
850 
851             // credit make.feeAmount to operator
852             _increments[operatorFeeAssetIndex] = _increments[operatorFeeAssetIndex].add(feeAmount);
853         }
854     }
855 
856     /// @dev Deduct tokens from fillers for each fill.offerAmount
857     /// and each fill.feeAmount.
858     /// See the `trade` method for param details.
859     /// @param _values Values from `trade`
860     function _deductFillBalances(
861         uint256[] memory _decrements,
862         uint256[] memory _values
863     )
864         private
865         pure
866     {
867         // 1 + numOffers * 2
868         uint256 i = 1 + (_values[0] & mask8) * 2;
869         // i + numFills * 2
870         uint256 end = i + ((_values[0] & mask16) >> 8) * 2;
871 
872         // loop fills
873         for(i; i < end; i += 2) {
874             uint256 fillerOfferAssetIndex = (_values[i] & mask16) >> 8;
875             uint256 offerAmount = _values[i + 1] & mask128;
876 
877             // deduct fill.offerAmount from filler
878             _decrements[fillerOfferAssetIndex] = _decrements[fillerOfferAssetIndex].add(offerAmount);
879 
880             uint256 feeAmount = _values[i] >> 128;
881             if (feeAmount == 0) { continue; }
882 
883             // deduct fill.feeAmount from filler
884             uint256 fillerFeeAssetIndex = (_values[i] & mask32) >> 24;
885             _decrements[fillerFeeAssetIndex] = _decrements[fillerFeeAssetIndex].add(feeAmount);
886         }
887     }
888 
889     /// @dev Deduct tokens from makers for each offer.offerAmount
890     /// and each offer.feeAmount if the offer has not been recorded
891     /// through a previous `trade` call.
892     /// See the `trade` method for param details.
893     /// @param _values Values from `trade`
894     function _deductMakerBalances(
895         uint256[] memory _decrements,
896         uint256[] memory _values
897     )
898         private
899         pure
900     {
901         uint256 i = 1;
902         // i + numOffers * 2
903         uint256 end = i + (_values[0] & mask8) * 2;
904 
905         // loop offers
906         for(i; i < end; i += 2) {
907             bool nonceTaken = ((_values[i] & mask128) >> 120) == 1;
908             if (nonceTaken) { continue; }
909 
910             uint256 makerOfferAssetIndex = (_values[i] & mask16) >> 8;
911             uint256 offerAmount = _values[i + 1] & mask128;
912 
913             // deduct make.offerAmount from maker
914             _decrements[makerOfferAssetIndex] = _decrements[makerOfferAssetIndex].add(offerAmount);
915 
916             uint256 feeAmount = _values[i] >> 128;
917             if (feeAmount == 0) { continue; }
918 
919             // deduct make.feeAmount from maker
920             uint256 makerFeeAssetIndex = (_values[i] & mask32) >> 24;
921             _decrements[makerFeeAssetIndex] = _decrements[makerFeeAssetIndex].add(feeAmount);
922         }
923     }
924 
925     /// @dev Emits trade events for easier tracking
926     /// @param _values The _values param from the trade / networkTrade method
927     /// @param _addresses The _addresses param from the trade / networkTrade method
928     /// @param _marketDapps The _marketDapps from BrokerV2
929     /// @param _forNetworkTrade Whether this is called from the networkTrade method
930     function _emitTradeEvents(
931         uint256[] memory _values,
932         address[] memory _addresses,
933         address[] memory _marketDapps,
934         bool _forNetworkTrade
935     )
936         private
937     {
938         uint256 i = 1;
939         // i += numOffers * 2
940         i += (_values[0] & mask8) * 2;
941         // i += numFills * 2
942         i += ((_values[0] & mask16) >> 8) * 2;
943 
944         uint256 end = _values.length;
945 
946         // loop matches
947         for(i; i < end; i++) {
948             uint256[] memory data = new uint256[](7);
949             data[0] = _values[i] & mask8; // match.offerIndex
950             data[1] = _values[1 + data[0] * 2] & mask8; // makerIndex
951             data[2] = (_values[1 + data[0] * 2] & mask16) >> 8; // makerOfferAssetIndex
952             data[3] = (_values[1 + data[0] * 2] & mask24) >> 16; // makerWantAssetIndex
953             data[4] = _values[i] >> 128; // match.takeAmount
954             // receiveAmount = match.takeAmount * offer.wantAmount / offer.offerAmount
955             data[5] = data[4].mul(_values[2 + data[0] * 2] >> 128)
956                              .div(_values[2 + data[0] * 2] & mask128);
957             // match.fillIndex for `trade`, marketDappIndex for `networkTrade`
958             data[6] = (_values[i] & mask16) >> 8;
959 
960             address filler;
961             if (_forNetworkTrade) {
962                 filler = _marketDapps[data[6]];
963             } else {
964                 uint256 fillerIndex = (_values[1 + data[6] * 2] & mask8);
965                 filler = _addresses[fillerIndex * 2];
966             }
967 
968             emit Trade(
969                 _addresses[data[1] * 2], // maker
970                 filler,
971                 _addresses[data[2] * 2 + 1], // makerGiveAsset
972                 data[4], // makerGiveAmount
973                 _addresses[data[3] * 2 + 1], // fillerGiveAsset
974                 data[5] // fillerGiveAmount
975             );
976         }
977     }
978 
979 
980     /// @notice Executes a trade against an external market.
981     /// @dev The initial Ether or token balance is compared with the
982     /// balance after the trade to ensure that the appropriate amounts of
983     /// tokens were taken and an appropriate amount received.
984     /// The trade will fail if the number of tokens received is less than
985     /// expected. If the number of tokens received is more than expected than
986     /// the excess tokens are transferred to the `BrokerV2.operator`.
987     /// @param _assetIds[0] The offerAssetId of the offer
988     /// @param _assetIds[1] The wantAssetId of the offer
989     /// @param _assetIds[2] The surplusAssetId
990     /// @param _dataValues[0] The number of tokens offerred
991     /// @param _dataValues[1] The number of tokens expected to be received
992     /// @param _dataValues[2] Match data
993     /// @param _marketDapps See `BrokerV2.marketDapps`
994     /// @param _addresses Addresses from `networkTrade`
995     function _performNetworkTrade(
996         address[] memory _assetIds,
997         uint256[] memory _dataValues,
998         address[] memory _marketDapps,
999         address[] memory _addresses
1000     )
1001         private
1002         returns (uint256)
1003     {
1004         uint256 dappIndex = (_dataValues[2] & mask16) >> 8;
1005         validateAddress(_marketDapps[dappIndex]);
1006         MarketDapp marketDapp = MarketDapp(_marketDapps[dappIndex]);
1007 
1008         uint256[] memory funds = new uint256[](6);
1009         funds[0] = externalBalance(_assetIds[0]); // initialOfferTokenBalance
1010         funds[1] = externalBalance(_assetIds[1]); // initialWantTokenBalance
1011         if (_assetIds[2] != _assetIds[0] && _assetIds[2] != _assetIds[1]) {
1012             funds[2] = externalBalance(_assetIds[2]); // initialSurplusTokenBalance
1013         }
1014 
1015         uint256 ethValue = 0;
1016         address tokenReceiver;
1017 
1018         if (_assetIds[0] == ETHER_ADDR) {
1019             ethValue = _dataValues[0]; // offerAmount
1020         } else {
1021             tokenReceiver = marketDapp.tokenReceiver(_assetIds, _dataValues, _addresses);
1022             approveTokenTransfer(
1023                 _assetIds[0], // offerAssetId
1024                 tokenReceiver,
1025                 _dataValues[0] // offerAmount
1026             );
1027         }
1028 
1029         marketDapp.trade.value(ethValue)(
1030             _assetIds,
1031             _dataValues,
1032             _addresses,
1033             // use uint160 to cast `address` to `address payable`
1034             address(uint160(address(this))) // destAddress
1035         );
1036 
1037         funds[3] = externalBalance(_assetIds[0]); // finalOfferTokenBalance
1038         funds[4] = externalBalance(_assetIds[1]); // finalWantTokenBalance
1039         if (_assetIds[2] != _assetIds[0] && _assetIds[2] != _assetIds[1]) {
1040             funds[5] = externalBalance(_assetIds[2]); // finalSurplusTokenBalance
1041         }
1042 
1043         uint256 surplusAmount = 0;
1044 
1045         // validate that the appropriate offerAmount was deducted
1046         // surplusAssetId == offerAssetId
1047         if (_assetIds[2] == _assetIds[0]) {
1048             // surplusAmount = finalOfferTokenBalance - (initialOfferTokenBalance - offerAmount)
1049             surplusAmount = funds[3].sub(funds[0].sub(_dataValues[0]));
1050         } else {
1051             // finalOfferTokenBalance == initialOfferTokenBalance - offerAmount
1052             require(funds[3] == funds[0].sub(_dataValues[0]), "Invalid offer asset balance");
1053         }
1054 
1055         // validate that the appropriate wantAmount was credited
1056         // surplusAssetId == wantAssetId
1057         if (_assetIds[2] == _assetIds[1]) {
1058             // surplusAmount = finalWantTokenBalance - (initialWantTokenBalance + wantAmount)
1059             surplusAmount = funds[4].sub(funds[1].add(_dataValues[1]));
1060         } else {
1061             // finalWantTokenBalance == initialWantTokenBalance + wantAmount
1062             require(funds[4] == funds[1].add(_dataValues[1]), "Invalid want asset balance");
1063         }
1064 
1065         // surplusAssetId != offerAssetId && surplusAssetId != wantAssetId
1066         if (_assetIds[2] != _assetIds[0] && _assetIds[2] != _assetIds[1]) {
1067             // surplusAmount = finalSurplusTokenBalance - initialSurplusTokenBalance
1068             surplusAmount = funds[5].sub(funds[2]);
1069         }
1070 
1071         // set the approved token amount back to zero
1072         if (_assetIds[0] != ETHER_ADDR) {
1073             approveTokenTransfer(
1074                 _assetIds[0],
1075                 tokenReceiver,
1076                 0
1077             );
1078         }
1079 
1080         return surplusAmount;
1081     }
1082 
1083     /// @dev Validates input lengths based on the expected format
1084     /// detailed in the `trade` method.
1085     /// @param _values Values from `trade`
1086     /// @param _hashes Hashes from `trade`
1087     function _validateTradeInputLengths(
1088         uint256[] memory _values,
1089         bytes32[] memory _hashes
1090     )
1091         private
1092         pure
1093     {
1094         uint256 numOffers = _values[0] & mask8;
1095         uint256 numFills = (_values[0] & mask16) >> 8;
1096         uint256 numMatches = (_values[0] & mask24) >> 16;
1097 
1098         // Validate that bits(24..256) are zero
1099         require(_values[0] >> 24 == 0, "Invalid trade input");
1100 
1101         // It is enforced by other checks that if a fill is present
1102         // then it must be completely filled so there must be at least one offer
1103         // and at least one match in this case.
1104         // It is possible to have one offer with no matches and no fills
1105         // but that is blocked by this check as there is no foreseeable use
1106         // case for it.
1107         require(
1108             numOffers > 0 && numFills > 0 && numMatches > 0,
1109             "Invalid trade input"
1110         );
1111 
1112         require(
1113             _values.length == 1 + numOffers * 2 + numFills * 2 + numMatches,
1114             "Invalid _values.length"
1115         );
1116 
1117         require(
1118             _hashes.length == (numOffers + numFills) * 2,
1119             "Invalid _hashes.length"
1120         );
1121     }
1122 
1123     /// @dev Validates input lengths based on the expected format
1124     /// detailed in the `networkTrade` method.
1125     /// @param _values Values from `networkTrade`
1126     /// @param _hashes Hashes from `networkTrade`
1127     function _validateNetworkTradeInputLengths(
1128         uint256[] memory _values,
1129         bytes32[] memory _hashes
1130     )
1131         private
1132         pure
1133     {
1134         uint256 numOffers = _values[0] & mask8;
1135         uint256 numFills = (_values[0] & mask16) >> 8;
1136         uint256 numMatches = (_values[0] & mask24) >> 16;
1137 
1138         // Validate that bits(24..256) are zero
1139         require(_values[0] >> 24 == 0, "Invalid networkTrade input");
1140 
1141         // Validate that numFills is zero because the offers
1142         // should be filled against external orders
1143         require(
1144             numOffers > 0 && numMatches > 0 && numFills == 0,
1145             "Invalid networkTrade input"
1146         );
1147 
1148         require(
1149             _values.length == 1 + numOffers * 2 + numMatches,
1150             "Invalid _values.length"
1151         );
1152 
1153         require(
1154             _hashes.length == numOffers * 2,
1155             "Invalid _hashes.length"
1156         );
1157     }
1158 
1159     /// @dev See the `BrokerV2.trade` method for an explanation of why offer
1160     /// uniquness is required.
1161     /// The set of offers in `_values` must be sorted such that offer nonces'
1162     /// are arranged in a strictly ascending order.
1163     /// This allows the validation of offer uniqueness to be done in O(N) time,
1164     /// with N being the number of offers.
1165     /// @param _values Values from `trade`
1166     function _validateUniqueOffers(uint256[] memory _values) private pure {
1167         uint256 numOffers = _values[0] & mask8;
1168 
1169         uint256 prevNonce;
1170 
1171         for(uint256 i = 0; i < numOffers; i++) {
1172             uint256 nonce = (_values[i * 2 + 1] & mask120) >> 56;
1173 
1174             if (i == 0) {
1175                 // Set the value of the first nonce
1176                 prevNonce = nonce;
1177                 continue;
1178             }
1179 
1180             require(nonce > prevNonce, "Invalid offer nonces");
1181             prevNonce = nonce;
1182         }
1183     }
1184 
1185     /// @dev Validate that for every match:
1186     /// 1. offerIndexes fall within the range of offers
1187     /// 2. fillIndexes falls within the range of fills
1188     /// 3. offer.offerAssetId == fill.wantAssetId
1189     /// 4. offer.wantAssetId == fill.offerAssetId
1190     /// 5. takeAmount > 0
1191     /// 6. (offer.wantAmount * takeAmount) % offer.offerAmount == 0
1192     /// @param _values Values from `trade`
1193     /// @param _addresses Addresses from `trade`
1194     function _validateMatches(
1195         uint256[] memory _values,
1196         address[] memory _addresses
1197     )
1198         private
1199         pure
1200     {
1201         uint256 numOffers = _values[0] & mask8;
1202         uint256 numFills = (_values[0] & mask16) >> 8;
1203 
1204         uint256 i = 1 + numOffers * 2 + numFills * 2;
1205         uint256 end = _values.length;
1206 
1207         // loop matches
1208         for (i; i < end; i++) {
1209             uint256 offerIndex = _values[i] & mask8;
1210             uint256 fillIndex = (_values[i] & mask16) >> 8;
1211 
1212             require(offerIndex < numOffers, "Invalid match.offerIndex");
1213 
1214             require(fillIndex >= numOffers && fillIndex < numOffers + numFills, "Invalid match.fillIndex");
1215 
1216             require(
1217                 _addresses[_values[1 + offerIndex * 2] & mask8] !=
1218                 _addresses[_values[1 + fillIndex * 2] & mask8],
1219                 "offer.maker cannot be the same as fill.filler"
1220             );
1221 
1222             uint256 makerOfferAssetIndex = (_values[1 + offerIndex * 2] & mask16) >> 8;
1223             uint256 makerWantAssetIndex = (_values[1 + offerIndex * 2] & mask24) >> 16;
1224             uint256 fillerOfferAssetIndex = (_values[1 + fillIndex * 2] & mask16) >> 8;
1225             uint256 fillerWantAssetIndex = (_values[1 + fillIndex * 2] & mask24) >> 16;
1226 
1227             require(
1228                 _addresses[makerOfferAssetIndex * 2 + 1] ==
1229                 _addresses[fillerWantAssetIndex * 2 + 1],
1230                 "offer.offerAssetId does not match fill.wantAssetId"
1231             );
1232 
1233             require(
1234                 _addresses[makerWantAssetIndex * 2 + 1] ==
1235                 _addresses[fillerOfferAssetIndex * 2 + 1],
1236                 "offer.wantAssetId does not match fill.offerAssetId"
1237             );
1238 
1239             // require that bits(16..128) are all zero for every match
1240             require((_values[i] & mask128) >> 16 == uint256(0), "Invalid match data");
1241 
1242             uint256 takeAmount = _values[i] >> 128;
1243             require(takeAmount > 0, "Invalid match.takeAmount");
1244 
1245             uint256 offerDataB = _values[2 + offerIndex * 2];
1246             // (offer.wantAmount * takeAmount) % offer.offerAmount == 0
1247             require(
1248                 (offerDataB >> 128).mul(takeAmount).mod(offerDataB & mask128) == 0,
1249                 "Invalid amounts"
1250             );
1251         }
1252     }
1253 
1254     /// @dev Validate that for every match:
1255     /// 1. offerIndexes fall within the range of offers
1256     /// 2. _addresses[surplusAssetIndexes * 2] matches the operator address
1257     /// 3. takeAmount > 0
1258     /// 4. (offer.wantAmount * takeAmount) % offer.offerAmount == 0
1259     /// @param _values Values from `trade`
1260     /// @param _addresses Addresses from `trade`
1261     /// @param _operator Address of the `BrokerV2.operator`
1262     function _validateNetworkMatches(
1263         uint256[] memory _values,
1264         address[] memory _addresses,
1265         address _operator
1266     )
1267         private
1268         pure
1269     {
1270         uint256 numOffers = _values[0] & mask8;
1271 
1272         // 1 + numOffers * 2
1273         uint256 i = 1 + (_values[0] & mask8) * 2;
1274         uint256 end = _values.length;
1275 
1276         // loop matches
1277         for (i; i < end; i++) {
1278             uint256 offerIndex = _values[i] & mask8;
1279             uint256 surplusAssetIndex = (_values[i] & mask24) >> 16;
1280 
1281             require(offerIndex < numOffers, "Invalid match.offerIndex");
1282             require(_addresses[surplusAssetIndex * 2] == _operator, "Invalid operator address");
1283 
1284             uint256 takeAmount = _values[i] >> 128;
1285             require(takeAmount > 0, "Invalid match.takeAmount");
1286 
1287             uint256 offerDataB = _values[2 + offerIndex * 2];
1288             // (offer.wantAmount * takeAmount) % offer.offerAmount == 0
1289             require(
1290                 (offerDataB >> 128).mul(takeAmount).mod(offerDataB & mask128) == 0,
1291                 "Invalid amounts"
1292             );
1293         }
1294     }
1295 
1296     /// @dev Validate that all fills will be completely filled by the specified
1297     /// matches. See the `BrokerV2.trade` method for an explanation of why
1298     /// fills must be completely filled.
1299     /// @param _values Values from `trade`
1300     function _validateFillAmounts(uint256[] memory _values) private pure {
1301         // "filled" is used to store the sum of `takeAmount`s and `giveAmount`s.
1302         // While a fill's `offerAmount` and `wantAmount` are combined to share
1303         // a single uint256 value, each sum of `takeAmount`s and `giveAmount`s
1304         // for a fill is tracked with an individual uint256 value.
1305         // This is to prevent the verification from being vulnerable to overflow
1306         // issues.
1307         uint256[] memory filled = new uint256[](_values.length);
1308 
1309         uint256 i = 1;
1310         // i += numOffers * 2
1311         i += (_values[0] & mask8) * 2;
1312         // i += numFills * 2
1313         i += ((_values[0] & mask16) >> 8) * 2;
1314 
1315         uint256 end = _values.length;
1316 
1317         // loop matches
1318         for (i; i < end; i++) {
1319             uint256 offerIndex = _values[i] & mask8;
1320             uint256 fillIndex = (_values[i] & mask16) >> 8;
1321             uint256 takeAmount = _values[i] >> 128;
1322             uint256 wantAmount = _values[2 + offerIndex * 2] >> 128;
1323             uint256 offerAmount = _values[2 + offerIndex * 2] & mask128;
1324             // giveAmount = takeAmount * wantAmount / offerAmount
1325             uint256 giveAmount = takeAmount.mul(wantAmount).div(offerAmount);
1326 
1327             // (1 + fillIndex * 2) would give the index of the first part
1328             // of the data for the fill at fillIndex within `_values`,
1329             // and (2 + fillIndex * 2) would give the index of the second part
1330             filled[1 + fillIndex * 2] = filled[1 + fillIndex * 2].add(giveAmount);
1331             filled[2 + fillIndex * 2] = filled[2 + fillIndex * 2].add(takeAmount);
1332         }
1333 
1334         // numOffers
1335         i = _values[0] & mask8;
1336         // i + numFills
1337         end = i + ((_values[0] & mask16) >> 8);
1338 
1339         // loop fills
1340         for(i; i < end; i++) {
1341             require(
1342                 // fill.offerAmount == (sum of given amounts for fill)
1343                 _values[i * 2 + 2] & mask128 == filled[i * 2 + 1] &&
1344                 // fill.wantAmount == (sum of taken amounts for fill)
1345                 _values[i * 2 + 2] >> 128 == filled[i * 2 + 2],
1346                 "Invalid fills"
1347             );
1348         }
1349     }
1350 
1351     /// @dev Validates that for every offer / fill
1352     /// 1. user address matches address referenced by user.offerAssetIndex
1353     /// 2. user address matches address referenced by user.wantAssetIndex
1354     /// 3. user address matches address referenced by user.feeAssetIndex
1355     /// 4. offerAssetId != wantAssetId
1356     /// 5. offerAmount > 0 && wantAmount > 0
1357     /// 6. Specified `operator` address matches the expected `operator` address,
1358     /// 7. Specified `operator.feeAssetId` matches the offer's feeAssetId
1359     /// @param _values Values from `trade`
1360     /// @param _addresses Addresses from `trade`
1361     function _validateTradeData(
1362         uint256[] memory _values,
1363         address[] memory _addresses,
1364         address _operator
1365     )
1366         private
1367         pure
1368     {
1369         // numOffers + numFills
1370         uint256 end = (_values[0] & mask8) +
1371                       ((_values[0] & mask16) >> 8);
1372 
1373         for (uint256 i = 0; i < end; i++) {
1374             uint256 dataA = _values[i * 2 + 1];
1375             uint256 dataB = _values[i * 2 + 2];
1376             uint256 feeAssetIndex = ((dataA & mask40) >> 32) * 2;
1377 
1378             require(
1379                 // user address == user in user.offerAssetIndex pair
1380                 _addresses[(dataA & mask8) * 2] ==
1381                 _addresses[((dataA & mask16) >> 8) * 2],
1382                 "Invalid user in user.offerAssetIndex"
1383             );
1384 
1385             require(
1386                 // user address == user in user.wantAssetIndex pair
1387                 _addresses[(dataA & mask8) * 2] ==
1388                 _addresses[((dataA & mask24) >> 16) * 2],
1389                 "Invalid user in user.wantAssetIndex"
1390             );
1391 
1392             require(
1393                 // user address == user in user.feeAssetIndex pair
1394                 _addresses[(dataA & mask8) * 2] ==
1395                 _addresses[((dataA & mask32) >> 24) * 2],
1396                 "Invalid user in user.feeAssetIndex"
1397             );
1398 
1399             require(
1400                 // offerAssetId != wantAssetId
1401                 _addresses[((dataA & mask16) >> 8) * 2 + 1] !=
1402                 _addresses[((dataA & mask24) >> 16) * 2 + 1],
1403                 "Invalid trade assets"
1404             );
1405 
1406             require(
1407                 // offerAmount > 0 && wantAmount > 0
1408                 (dataB & mask128) > 0 && (dataB >> 128) > 0,
1409                 "Invalid trade amounts"
1410             );
1411 
1412              require(
1413                 _addresses[feeAssetIndex] == _operator,
1414                 "Invalid operator address"
1415             );
1416 
1417              require(
1418                 _addresses[feeAssetIndex + 1] ==
1419                 _addresses[((dataA & mask32) >> 24) * 2 + 1],
1420                 "Invalid operator fee asset ID"
1421             );
1422         }
1423     }
1424 
1425     /// @dev Validates signatures for a set of offers or fills
1426     /// Note that the r value of the offer / fill in _hashes will be
1427     /// overwritten by the hash of that offer / fill
1428     /// @param _values Values from `trade`
1429     /// @param _hashes Hashes from `trade`
1430     /// @param _addresses Addresses from `trade`
1431     /// @param _typehash The typehash used to construct the signed hash
1432     /// @param _i The starting index to verify
1433     /// @param _end The ending index to verify
1434     /// @return An array of hash keys if _i started as 0, because only
1435     /// the hash keys of offers are needed
1436     function _validateTradeSignatures(
1437         uint256[] memory _values,
1438         bytes32[] memory _hashes,
1439         address[] memory _addresses,
1440         bytes32 _typehash,
1441         uint256 _i,
1442         uint256 _end
1443     )
1444         private
1445         pure
1446     {
1447         for (_i; _i < _end; _i++) {
1448             uint256 dataA = _values[_i * 2 + 1];
1449             uint256 dataB = _values[_i * 2 + 2];
1450 
1451             bytes32 hashKey = keccak256(abi.encode(
1452                 _typehash,
1453                 _addresses[(dataA & mask8) * 2], // user
1454                 _addresses[((dataA & mask16) >> 8) * 2 + 1], // offerAssetId
1455                 dataB & mask128, // offerAmount
1456                 _addresses[((dataA & mask24) >> 16) * 2 + 1], // wantAssetId
1457                 dataB >> 128, // wantAmount
1458                 _addresses[((dataA & mask32) >> 24) * 2 + 1], // feeAssetId
1459                 dataA >> 128, // feeAmount
1460                 (dataA & mask120) >> 56 // nonce
1461             ));
1462 
1463             bool prefixedSignature = ((dataA & mask56) >> 48) != 0;
1464 
1465             validateSignature(
1466                 hashKey,
1467                 _addresses[(dataA & mask8) * 2], // user
1468                 uint8((dataA & mask48) >> 40), // The `v` component of the user's signature
1469                 _hashes[_i * 2], // The `r` component of the user's signature
1470                 _hashes[_i * 2 + 1], // The `s` component of the user's signature
1471                 prefixedSignature
1472             );
1473 
1474             _hashes[_i * 2] = hashKey;
1475         }
1476     }
1477 
1478     /// @dev Ensure that the address is a deployed contract
1479     /// @param _contract The address to check
1480     function _validateContractAddress(address _contract) private view {
1481         assembly {
1482             if iszero(extcodesize(_contract)) { revert(0, 0) }
1483         }
1484     }
1485 
1486     /// @dev A thin wrapper around the native `call` function, to
1487     /// validate that the contract `call` must be successful.
1488     /// See https://solidity.readthedocs.io/en/v0.5.1/050-breaking-changes.html
1489     /// for details on constructing the `_payload`
1490     /// @param _contract Address of the contract to call
1491     /// @param _payload The data to call the contract with
1492     /// @return The data returned from the contract call
1493     function _callContract(
1494         address _contract,
1495         bytes memory _payload
1496     )
1497         private
1498         returns (bytes memory)
1499     {
1500         bool success;
1501         bytes memory returnData;
1502 
1503         (success, returnData) = _contract.call(_payload);
1504         require(success, "Contract call failed");
1505 
1506         return returnData;
1507     }
1508 
1509     /// @dev Fix for ERC-20 tokens that do not have proper return type
1510     /// See: https://github.com/ethereum/solidity/issues/4116
1511     /// https://medium.com/loopring-protocol/an-incompatibility-in-smart-contract-threatening-dapp-ecosystem-72b8ca5db4da
1512     /// https://github.com/sec-bit/badERC20Fix/blob/master/badERC20Fix.sol
1513     /// @param _data The data returned from a transfer call
1514     function _validateContractCallResult(bytes memory _data) private pure {
1515         require(
1516             _data.length == 0 ||
1517             (_data.length == 32 && _getUint256FromBytes(_data) != 0),
1518             "Invalid contract call result"
1519         );
1520     }
1521 
1522     /// @dev Converts data of type `bytes` into its corresponding `uint256` value
1523     /// @param _data The data in bytes
1524     /// @return The corresponding `uint256` value
1525     function _getUint256FromBytes(
1526         bytes memory _data
1527     )
1528         private
1529         pure
1530         returns (uint256)
1531     {
1532         uint256 parsed;
1533         assembly { parsed := mload(add(_data, 32)) }
1534         return parsed;
1535     }
1536 }
1537 
1538 // File: contracts/BrokerV2.sol
1539 
1540 pragma solidity 0.5.12;
1541 
1542 
1543 
1544 
1545 
1546 interface IERC1820Registry {
1547     function setInterfaceImplementer(address account, bytes32 interfaceHash, address implementer) external;
1548 }
1549 
1550 interface TokenList {
1551     function validateToken(address assetId) external view;
1552 }
1553 
1554 interface SpenderList {
1555     function validateSpender(address spender) external view;
1556     function validateSpenderAuthorization(address user, address spender) external view;
1557 }
1558 
1559 /// @title The BrokerV2 contract for Switcheo Exchange
1560 /// @author Switcheo Network
1561 /// @notice This contract faciliates Ethereum and Ethereum token trades
1562 /// between users.
1563 /// Users can trade with each other by making and taking offers without
1564 /// giving up custody of their tokens.
1565 /// Users should first deposit tokens, then communicate off-chain
1566 /// with the exchange coordinator, in order to place orders.
1567 /// This allows trades to be confirmed immediately by the coordinator,
1568 /// and settled on-chain through this contract at a later time.
1569 ///
1570 /// @dev Bit compacting is used in the contract to reduce gas costs, when
1571 /// it is used, params are documented as bits(n..m).
1572 /// This means that the documented value is represented by bits starting
1573 /// from and including `n`, up to and excluding `m`.
1574 /// For example, bits(8..16), indicates that the value is represented by bits:
1575 /// [8, 9, 10, 11, 12, 13, 14, 15].
1576 ///
1577 /// Bit manipulation of the form (data & ~(~uint(0) << m)) >> n is frequently
1578 /// used to recover the value at the specified bits.
1579 /// For example, to recover bits(2..7) from a uint8 value, we can use
1580 /// (data & ~(~uint8(0) << 7)) >> 2.
1581 /// Given a `data` value of `1101,0111`, bits(2..7) should give "10101".
1582 /// ~uint8(0): "1111,1111" (8 ones)
1583 /// (~uint8(0) << 7): "1000,0000" (1 followed by 7 zeros)
1584 /// ~(~uint8(0) << 7): "0111,1111" (0 followed by 7 ones)
1585 /// (data & ~(~uint8(0) << 7)): "0101,0111" (bits after the 7th bit is zeroed)
1586 /// (data & ~(~uint8(0) << 7)) >> 2: "0001,0101" (matching the expected "10101")
1587 ///
1588 /// Additionally, bit manipulation of the form data >> n is used to recover
1589 /// bits(n..e), where e is equal to the number of bits in the data.
1590 /// For example, to recover bits(4..8) from a uint8 value, we can use data >> 4.
1591 /// Given a data value of "1111,1111", bits(4..8) should give "1111".
1592 /// data >> 4: "0000,1111" (matching the expected "1111")
1593 ///
1594 /// There is frequent reference and usage of asset IDs, this is a unique
1595 /// identifier used within the contract to represent individual assets.
1596 /// For all tokens, the asset ID is identical to the contract address
1597 /// of the token, this is so that additional mappings are not needed to
1598 /// identify tokens during deposits and withdrawals.
1599 /// The only exception is the Ethereum token, which does not have a contract
1600 /// address, for this reason, the zero address is used to represent the
1601 /// Ethereum token's ID.
1602 contract BrokerV2 is Ownable, ReentrancyGuard {
1603     using SafeMath for uint256;
1604 
1605     struct WithdrawalAnnouncement {
1606         uint256 amount;
1607         uint256 withdrawableAt;
1608     }
1609 
1610     // Exchange states
1611     enum State { Active, Inactive }
1612     // Exchange admin states
1613     enum AdminState { Normal, Escalated }
1614 
1615     // The constants for EIP-712 are precompiled to reduce contract size,
1616     // the original values are left here for reference and verification.
1617     //
1618     // bytes32 public constant WITHDRAW_TYPEHASH = keccak256(abi.encodePacked(
1619     //     "Withdraw(",
1620     //         "address withdrawer,",
1621     //         "address receivingAddress,",
1622     //         "address assetId,",
1623     //         "uint256 amount,",
1624     //         "address feeAssetId,",
1625     //         "uint256 feeAmount,",
1626     //         "uint256 nonce",
1627     //     ")"
1628     // ));
1629     bytes32 public constant WITHDRAW_TYPEHASH = 0xbe2f4292252fbb88b129dc7717b2f3f74a9afb5b13a2283cac5c056117b002eb;
1630 
1631     // bytes32 public constant OFFER_TYPEHASH = keccak256(abi.encodePacked(
1632     //     "Offer(",
1633     //         "address maker,",
1634     //         "address offerAssetId,",
1635     //         "uint256 offerAmount,",
1636     //         "address wantAssetId,",
1637     //         "uint256 wantAmount,",
1638     //         "address feeAssetId,",
1639     //         "uint256 feeAmount,",
1640     //         "uint256 nonce",
1641     //     ")"
1642     // ));
1643     bytes32 public constant OFFER_TYPEHASH = 0xf845c83a8f7964bc8dd1a092d28b83573b35be97630a5b8a3b8ae2ae79cd9260;
1644 
1645     // bytes32 public constant SWAP_TYPEHASH = keccak256(abi.encodePacked(
1646     //     "Swap(",
1647     //         "address maker,",
1648     //         "address taker,",
1649     //         "address assetId,",
1650     //         "uint256 amount,",
1651     //         "bytes32 hashedSecret,",
1652     //         "uint256 expiryTime,",
1653     //         "address feeAssetId,",
1654     //         "uint256 feeAmount,",
1655     //         "uint256 nonce",
1656     //     ")"
1657     // ));
1658     bytes32 public constant SWAP_TYPEHASH = 0x6ba9001457a287c210b728198a424a4222098d7fac48f8c5fb5ab10ef907d3ef;
1659 
1660     // The Ether token address is set as the constant 0x00 for backwards
1661     // compatibility
1662     address private constant ETHER_ADDR = address(0);
1663 
1664     // The maximum length of swap secret values
1665     uint256 private constant MAX_SWAP_SECRET_LENGTH = 64;
1666 
1667     // Reason codes are used by the off-chain coordinator to track balance changes
1668     uint256 private constant REASON_DEPOSIT = 0x01;
1669 
1670     uint256 private constant REASON_WITHDRAW = 0x09;
1671     uint256 private constant REASON_WITHDRAW_FEE_GIVE = 0x14;
1672     uint256 private constant REASON_WITHDRAW_FEE_RECEIVE = 0x15;
1673 
1674     uint256 private constant REASON_CANCEL = 0x08;
1675     uint256 private constant REASON_CANCEL_FEE_GIVE = 0x12;
1676     uint256 private constant REASON_CANCEL_FEE_RECEIVE = 0x13;
1677 
1678     uint256 private constant REASON_SWAP_GIVE = 0x30;
1679     uint256 private constant REASON_SWAP_FEE_GIVE = 0x32;
1680     uint256 private constant REASON_SWAP_RECEIVE = 0x35;
1681     uint256 private constant REASON_SWAP_FEE_RECEIVE = 0x37;
1682 
1683     uint256 private constant REASON_SWAP_CANCEL_RECEIVE = 0x38;
1684     uint256 private constant REASON_SWAP_CANCEL_FEE_RECEIVE = 0x3B;
1685     uint256 private constant REASON_SWAP_CANCEL_FEE_REFUND = 0x3D;
1686 
1687     // 7 days * 24 hours * 60 mins * 60 seconds: 604800
1688     uint256 private constant MAX_SLOW_WITHDRAW_DELAY = 604800;
1689     uint256 private constant MAX_SLOW_CANCEL_DELAY = 604800;
1690 
1691     uint256 private constant mask8 = ~(~uint256(0) << 8);
1692     uint256 private constant mask16 = ~(~uint256(0) << 16);
1693     uint256 private constant mask24 = ~(~uint256(0) << 24);
1694     uint256 private constant mask32 = ~(~uint256(0) << 32);
1695     uint256 private constant mask40 = ~(~uint256(0) << 40);
1696     uint256 private constant mask120 = ~(~uint256(0) << 120);
1697     uint256 private constant mask128 = ~(~uint256(0) << 128);
1698     uint256 private constant mask136 = ~(~uint256(0) << 136);
1699     uint256 private constant mask144 = ~(~uint256(0) << 144);
1700 
1701     State public state;
1702     AdminState public adminState;
1703     // All fees will be transferred to the operator address
1704     address public operator;
1705     TokenList public tokenList;
1706     SpenderList public spenderList;
1707 
1708     // The delay in seconds to complete the respective escape hatch (`slowCancel` / `slowWithdraw`).
1709     // This gives the off-chain service time to update the off-chain state
1710     // before the state is separately updated by the user.
1711     uint256 public slowCancelDelay;
1712     uint256 public slowWithdrawDelay;
1713 
1714     // A mapping of remaining offer amounts: offerHash => availableAmount
1715     mapping(bytes32 => uint256) public offers;
1716     // A mapping of used nonces: nonceIndex => nonceData
1717     // The storing of nonces is used to ensure that transactions signed by
1718     // the user can only be used once.
1719     // For space and gas cost efficiency, one nonceData is used to store the
1720     // state of 256 nonces.
1721     // This reduces the average cost of storing a new nonce from 20,000 gas
1722     // to 5000 + 20,000 / 256 = 5078.125 gas
1723     // See _markNonce and _nonceTaken for more details.
1724     mapping(uint256 => uint256) public usedNonces;
1725     // A mapping of user balances: userAddress => assetId => balance
1726     mapping(address => mapping(address => uint256)) public balances;
1727     // A mapping of atomic swap states: swapHash => isSwapActive
1728     mapping(bytes32 => bool) public atomicSwaps;
1729 
1730     // A record of admin addresses: userAddress => isAdmin
1731     mapping(address => bool) public adminAddresses;
1732     // A record of market DApp addresses
1733     address[] public marketDapps;
1734     // A mapping of cancellation announcements for the cancel escape hatch: offerHash => cancellableAt
1735     mapping(bytes32 => uint256) public cancellationAnnouncements;
1736     // A mapping of withdrawal announcements: userAddress => assetId => { amount, withdrawableAt }
1737     mapping(address => mapping(address => WithdrawalAnnouncement)) public withdrawalAnnouncements;
1738 
1739     // Emitted on positive balance state transitions
1740     event BalanceIncrease(
1741         address indexed user,
1742         address indexed assetId,
1743         uint256 amount,
1744         uint256 reason,
1745         uint256 nonce
1746     );
1747 
1748     // Emitted on negative balance state transitions
1749     event BalanceDecrease(
1750         address indexed user,
1751         address indexed assetId,
1752         uint256 amount,
1753         uint256 reason,
1754         uint256 nonce
1755     );
1756 
1757     // Compacted versions of the `BalanceIncrease` and `BalanceDecrease` events.
1758     // These are used in the `trade` method, they are compacted to save gas costs.
1759     event Increment(uint256 data);
1760     event Decrement(uint256 data);
1761 
1762     event TokenFallback(
1763         address indexed user,
1764         address indexed assetId,
1765         uint256 amount
1766     );
1767 
1768     event TokensReceived(
1769         address indexed user,
1770         address indexed assetId,
1771         uint256 amount
1772     );
1773 
1774     event AnnounceCancel(
1775         bytes32 indexed offerHash,
1776         uint256 cancellableAt
1777     );
1778 
1779     event SlowCancel(
1780         bytes32 indexed offerHash,
1781         uint256 amount
1782     );
1783 
1784     event AnnounceWithdraw(
1785         address indexed withdrawer,
1786         address indexed assetId,
1787         uint256 amount,
1788         uint256 withdrawableAt
1789     );
1790 
1791     event SlowWithdraw(
1792         address indexed withdrawer,
1793         address indexed assetId,
1794         uint256 amount
1795     );
1796 
1797     /// @notice Initializes the Broker contract
1798     /// @dev The coordinator, operator and owner (through Ownable) is initialized
1799     /// to be the address of the sender.
1800     /// The Broker is put into an active state, with maximum exit delays set.
1801     /// The Broker is also registered as an implementer of ERC777TokensRecipient
1802     /// through the ERC1820 registry.
1803     constructor(address _tokenListAddress, address _spenderListAddress) public {
1804         adminAddresses[msg.sender] = true;
1805         operator = msg.sender;
1806         tokenList = TokenList(_tokenListAddress);
1807         spenderList = SpenderList(_spenderListAddress);
1808 
1809         slowWithdrawDelay = MAX_SLOW_WITHDRAW_DELAY;
1810         slowCancelDelay = MAX_SLOW_CANCEL_DELAY;
1811         state = State.Active;
1812 
1813         IERC1820Registry erc1820 = IERC1820Registry(
1814             0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24
1815         );
1816 
1817         erc1820.setInterfaceImplementer(
1818             address(this),
1819             keccak256("ERC777TokensRecipient"),
1820             address(this)
1821         );
1822     }
1823 
1824     modifier onlyAdmin() {
1825         // Error code 1: onlyAdmin, address is not an admin address
1826         require(adminAddresses[msg.sender], "1");
1827         _;
1828     }
1829 
1830     modifier onlyActiveState() {
1831         // Error code 2: onlyActiveState, state is not 'Active'
1832         require(state == State.Active, "2");
1833         _;
1834     }
1835 
1836     modifier onlyEscalatedAdminState() {
1837         // Error code 3: onlyEscalatedAdminState, adminState is not 'Escalated'
1838         require(adminState == AdminState.Escalated, "3");
1839         _;
1840     }
1841 
1842     /// @notice Checks whether an address is appointed as an admin user
1843     /// @param _user The address to check
1844     /// @return Whether the address is appointed as an admin user
1845     function isAdmin(address _user) external view returns(bool) {
1846         return adminAddresses[_user];
1847     }
1848 
1849     /// @notice Sets tbe Broker's state.
1850     /// @dev The two available states are `Active` and `Inactive`.
1851     /// The `Active` state allows for regular exchange activity,
1852     /// while the `Inactive` state prevents the invocation of deposit
1853     /// and trading functions.
1854     /// The `Inactive` state is intended as a means to cease contract operation
1855     /// in the case of an upgrade or in an emergency.
1856     /// @param _state The state to transition the contract into
1857     function setState(State _state) external onlyOwner nonReentrant { state = _state; }
1858 
1859     /// @notice Sets the Broker's admin state.
1860     /// @dev The two available states are `Normal` and `Escalated`.
1861     /// In the `Normal` admin state, the admin methods `adminCancel` and `adminWithdraw`
1862     /// are not invocable.
1863     /// The admin state must be set to `Escalated` by the contract owner for these
1864     /// methods to become usable.
1865     /// In an `Escalated` admin state, admin addresses would be able to cancel offers
1866     /// and withdraw balances to the respective user's wallet on behalf of users.
1867     /// The escalated state is intended to be used in the case of a contract upgrade or
1868     /// in an emergency.
1869     /// It is set separately from the `Inactive` state so that it is possible
1870     /// to use admin functions without affecting regular operations.
1871     /// @param _state The admin state to transition the contract into
1872     function setAdminState(AdminState _state) external onlyOwner nonReentrant { adminState = _state; }
1873 
1874     /// @notice Sets the operator address.
1875     /// @dev All fees will be transferred to the operator address.
1876     /// @param _operator The address to set as the operator
1877     function setOperator(address _operator) external onlyOwner nonReentrant {
1878         _validateAddress(operator);
1879         operator = _operator;
1880     }
1881 
1882     /// @notice Sets the minimum delay between an `announceCancel` call and
1883     /// when the cancellation can actually be executed through `slowCancel`.
1884     /// @dev This gives the off-chain service time to update the off-chain state
1885     /// before the state is separately updated by the user.
1886     /// This differs from the regular `cancel` operation, which does not involve a delay.
1887     /// @param _delay The delay in seconds
1888     function setSlowCancelDelay(uint256 _delay) external onlyOwner nonReentrant {
1889         // Error code 4: setSlowCancelDelay, slow cancel delay exceeds max allowable delay
1890         require(_delay <= MAX_SLOW_CANCEL_DELAY, "4");
1891         slowCancelDelay = _delay;
1892     }
1893 
1894     /// @notice Sets the delay between an `announceWithdraw` call and
1895     /// when the withdrawal can actually be executed through `slowWithdraw`.
1896     /// @dev This gives the off-chain service time to update the off-chain state
1897     /// before the state is separately updated by the user.
1898     /// This differs from the regular `withdraw` operation, which does not involve a delay.
1899     /// @param _delay The delay in seconds
1900     function setSlowWithdrawDelay(uint256 _delay) external onlyOwner nonReentrant {
1901         // Error code 5: setSlowWithdrawDelay, slow withdraw delay exceeds max allowable delay
1902         require(_delay <= MAX_SLOW_WITHDRAW_DELAY, "5");
1903         slowWithdrawDelay = _delay;
1904     }
1905 
1906     /// @notice Gives admin permissons to the specified address.
1907     /// @dev Admin addresses are intended to coordinate the regular operation
1908     /// of the Broker contract, and to perform special functions such as
1909     /// `adminCancel` and `adminWithdraw`.
1910     /// @param _admin The address to give admin permissions to
1911     function addAdmin(address _admin) external onlyOwner nonReentrant {
1912         _validateAddress(_admin);
1913         // Error code 6: addAdmin, address is already an admin address
1914         require(!adminAddresses[_admin], "6");
1915         adminAddresses[_admin] = true;
1916     }
1917 
1918     /// @notice Removes admin permissons for the specified address.
1919     /// @param _admin The admin address to remove admin permissions from
1920     function removeAdmin(address _admin) external onlyOwner nonReentrant {
1921         _validateAddress(_admin);
1922         // Error code 7: removeAdmin, address is not an admin address
1923         require(adminAddresses[_admin], "7");
1924         delete adminAddresses[_admin];
1925     }
1926 
1927     /// @notice Adds a market DApp to be used in `networkTrade`
1928     /// @param _dapp Address of the market DApp
1929     function addMarketDapp(address _dapp) external onlyOwner nonReentrant {
1930         _validateAddress(_dapp);
1931         marketDapps.push(_dapp);
1932     }
1933 
1934     /// @notice Updates a market DApp to be used in `networkTrade`
1935     /// @param _index Index of the market DApp to update
1936     /// @param _dapp The new address of the market DApp
1937     function updateMarketDapp(uint256 _index, address _dapp) external onlyOwner nonReentrant {
1938         _validateAddress(_dapp);
1939         // Error code 8: updateMarketDapp, _index does not refer to an existing non-zero address
1940         require(marketDapps[_index] != address(0), "8");
1941         marketDapps[_index] = _dapp;
1942     }
1943 
1944     /// @notice Removes a market DApp
1945     /// @param _index Index of the market DApp to remove
1946     function removeMarketDapp(uint256 _index) external onlyOwner nonReentrant {
1947         // Error code 9: removeMarketDapp, _index does not refer to a DApp address
1948         require(marketDapps[_index] != address(0), "9");
1949         delete marketDapps[_index];
1950     }
1951 
1952     /// @notice Performs a balance transfer from one address to another
1953     /// @dev This method is intended to be invoked by spender contracts.
1954     /// To invoke this method, a spender contract must have been
1955     /// previously whitelisted and also authorized by the address from which
1956     /// funds will be deducted.
1957     /// Balance events are not emitted by this method, they should be separately
1958     /// emitted by the spender contract.
1959     /// @param _from The address to deduct from
1960     /// @param _to The address to credit
1961     /// @param _assetId The asset to transfer
1962     /// @param _amount The amount to transfer
1963     function spendFrom(
1964         address _from,
1965         address _to,
1966         address _assetId,
1967         uint256 _amount
1968     )
1969         external
1970         nonReentrant
1971     {
1972         spenderList.validateSpenderAuthorization(_from, msg.sender);
1973 
1974         _validateAddress(_to);
1975 
1976         balances[_from][_assetId] = balances[_from][_assetId].sub(_amount);
1977         balances[_to][_assetId] = balances[_to][_assetId].add(_amount);
1978     }
1979 
1980     /// @notice Allows a whitelisted contract to mark nonces
1981     /// @dev If the whitelisted contract is malicious or vulnerable then there is
1982     /// a possibility of a DoS attack. However, since this attack requires cooperation
1983     /// of the contract owner, the risk is similar to the contract owner withholding
1984     /// transactions, so there is no violation of the contract's trust model.
1985     /// In the case that nonces are misused, users will still be able to cancel their offers
1986     /// and withdraw all their funds using the escape hatch methods.
1987     /// @param _nonce The nonce to mark
1988     function markNonce(uint256 _nonce) external nonReentrant {
1989         spenderList.validateSpender(msg.sender);
1990         _markNonce(_nonce);
1991     }
1992 
1993     /// @notice Returns whether a nonce has been taken
1994     /// @param _nonce The nonce to check
1995     /// @return Whether the nonce has been taken
1996     function nonceTaken(uint256 _nonce) external view returns (bool) {
1997         return _nonceTaken(_nonce);
1998     }
1999 
2000     /// @notice Deposits ETH into the sender's contract balance
2001     /// @dev This operation is only usable in an `Active` state
2002     /// to prevent this contract from receiving ETH in the case that its
2003     /// operation has been terminated.
2004     function deposit() external payable onlyActiveState nonReentrant {
2005         // Error code 10: deposit, msg.value is 0
2006         require(msg.value > 0, "10");
2007         _increaseBalance(msg.sender, ETHER_ADDR, msg.value, REASON_DEPOSIT, 0);
2008     }
2009 
2010     /// @dev This function is needed as market DApps generally send ETH
2011     /// using the `<address>.transfer` method.
2012     /// It is left empty to avoid issues with the function call running out
2013     /// of gas, as some callers set a small limit on how much gas can be
2014     /// used by the ETH receiver.
2015     function() payable external {}
2016 
2017     /// @notice Deposits ERC20 tokens under the `_user`'s balance
2018     /// @dev Transfers token into the Broker contract using the
2019     /// token's `transferFrom` method.
2020     /// The user must have previously authorized the token transfer
2021     /// through the token's `approve` method.
2022     /// This method has separate `_amount` and `_expectedAmount` values
2023     /// to support unconventional token transfers, e.g. tokens which have a
2024     /// proportion burnt on transfer.
2025     /// @param _user The address of the user depositing the tokens
2026     /// @param _assetId The address of the token contract
2027     /// @param _amount The value to invoke the token's `transferFrom` with
2028     /// @param _expectedAmount The final amount expected to be received by this contract
2029     /// @param _nonce A nonce for balance tracking, emitted in the BalanceIncrease event
2030     function depositToken(
2031         address _user,
2032         address _assetId,
2033         uint256 _amount,
2034         uint256 _expectedAmount,
2035         uint256 _nonce
2036     )
2037         external
2038         onlyAdmin
2039         onlyActiveState
2040         nonReentrant
2041     {
2042         _increaseBalance(
2043             _user,
2044             _assetId,
2045             _expectedAmount,
2046             REASON_DEPOSIT,
2047             _nonce
2048         );
2049 
2050         Utils.transferTokensIn(
2051             _user,
2052             _assetId,
2053             _amount,
2054             _expectedAmount
2055         );
2056     }
2057 
2058     /// @notice Deposits ERC223 tokens under the `_user`'s balance
2059     /// @dev ERC223 tokens should invoke this method when tokens are
2060     /// sent to the Broker contract.
2061     /// The invocation will fail unless the token has been previously
2062     /// whitelisted through the `whitelistToken` method.
2063     /// @param _user The address of the user sending the tokens
2064     /// @param _amount The amount of tokens transferred to the Broker
2065     function tokenFallback(
2066         address _user,
2067         uint _amount,
2068         bytes calldata /* _data */
2069     )
2070         external
2071         onlyActiveState
2072         nonReentrant
2073     {
2074         address assetId = msg.sender;
2075         tokenList.validateToken(assetId);
2076         _increaseBalance(_user, assetId, _amount, REASON_DEPOSIT, 0);
2077         emit TokenFallback(_user, assetId, _amount);
2078     }
2079 
2080     /// @notice Deposits ERC777 tokens under the `_user`'s balance
2081     /// @dev ERC777 tokens should invoke this method when tokens are
2082     /// sent to the Broker contract.
2083     /// The invocation will fail unless the token has been previously
2084     /// whitelisted through the `whitelistToken` method.
2085     /// @param _user The address of the user sending the tokens
2086     /// @param _to The address receiving the tokens
2087     /// @param _amount The amount of tokens transferred to the Broker
2088     function tokensReceived(
2089         address /* _operator */,
2090         address _user,
2091         address _to,
2092         uint _amount,
2093         bytes calldata /* _userData */,
2094         bytes calldata /* _operatorData */
2095     )
2096         external
2097         onlyActiveState
2098         nonReentrant
2099     {
2100         if (_to != address(this)) { return; }
2101         address assetId = msg.sender;
2102         tokenList.validateToken(assetId);
2103         _increaseBalance(_user, assetId, _amount, REASON_DEPOSIT, 0);
2104         emit TokensReceived(_user, assetId, _amount);
2105     }
2106 
2107     /// @notice Executes an array of offers and fills
2108     /// @dev This method accepts an array of "offers" and "fills" together with
2109     /// an array of "matches" to specify the matching between the "offers" and "fills".
2110     /// The data is bit compacted for ease of index referencing and to reduce gas costs,
2111     /// i.e. data representing different types of information is stored within one 256 bit value.
2112     ///
2113     /// For efficient balance updates, the `_addresses` array is meant to contain a
2114     /// unique set of user asset pairs in the form of:
2115     /// [
2116     ///     user_1_address,
2117     ///     asset_1_address,
2118     ///     user_1_address,
2119     ///     asset_2_address,
2120     ///     user_2_address,
2121     ///     asset_1_address,
2122     ///     ...
2123     /// ]
2124     /// This allows combining multiple balance updates for a user asset pair
2125     /// into a single update by first calculating the total balance update for
2126     /// a pair at a specified index, then looping through the sums to perform
2127     /// the balance update.
2128     ///
2129     /// The added benefit is further gas cost reduction because repeated
2130     /// user asset pairs do not need to be duplicated for the calldata.
2131     ///
2132     /// The operator address is enforced to be the contract's current operator
2133     /// address, and the operator fee asset ID is enforced to be identical to
2134     /// the maker's / filler's feeAssetId.
2135     ///
2136     /// A tradeoff of compacting the bits is that there is a lower maximum value
2137     /// for offer and fill data, however the limits remain generally practical.
2138     ///
2139     /// For `offerAmount`, `wantAmount`, `feeAmount` values, the maximum value
2140     /// is 2^128. For a token with 18 decimals, this allows support for tokens
2141     /// with a maximum supply of 1000 million billion billion (33 zeros).
2142     /// In the case where the maximum value needs to be exceeded, a single
2143     /// offer / fill can be split into multiple offers / fills by the off-chain
2144     /// service.
2145     ///
2146     /// For nonces the maximum value is 2^64, or more than a billion billion (19 zeros).
2147     ///
2148     /// Offers and fills both encompass information about how much (offerAmount)
2149     /// of a specified token (offerAssetId) the user wants to offer and
2150     /// how much (wantAmount) of another token (wantAssetId) they want
2151     /// in return.
2152     ///
2153     /// Each match specifies how much of the match's `offer.offerAmount` should
2154     /// be transferred to the filler, in return, the offer's maker receives:
2155     /// `offer.wantAmount * match.takeAmount / offer.offerAmount` of the
2156     /// `offer.wantAssetId` from the filler.
2157     ///
2158     /// A few restirctions are enforced to ensure fairness and security of trades:
2159     /// 1. To prevent unfairness due to rounding issues, it is required that:
2160     /// `offer.wantAmount * match.takeAmount % offer.offerAmount == 0`.
2161     ///
2162     /// 2. Fills can be filled by offers which do not individually match
2163     /// the `fill.offerAmount` and `fill.wantAmount` ratio. As such, it is
2164     /// required that:
2165     /// fill.offerAmount == total amount deducted from filler for the fill's
2166     /// associated matches (excluding fees)
2167     /// fill.wantAmount == total amount credited to filler for the fill's
2168     /// associated matches (excluding fees)
2169     ///
2170     /// 3. The offer array must not consist of repeated offers. For efficient
2171     /// balance updates, a loop through each offer in the offer array is used
2172     /// to deduct the offer.offerAmount from the respective maker
2173     /// if the offer has not been recorded by a previos `trade` call.
2174     /// If an offer is repeated in the offers array, then there would be
2175     /// duplicate deductions from the maker.
2176     /// To enforce uniqueness, it is required that offers for a trade transaction
2177     /// are sorted such that their nonces are in a strictly ascending order.
2178     ///
2179     /// 4. The fill array must not consist of repeated fills, for the same
2180     /// reason why there cannot be repeated offers. Additionally, to prevent
2181     /// replay attacks, all fill nonces are required to be unused.
2182     ///
2183     /// @param _values[0] Number of offers, fills, matches
2184     /// bits(0..8): number of offers (numOffers)
2185     /// bits(8..16): number of fills (numFills)
2186     /// bits(16..24): number of matches (numMatches)
2187     /// bits(24..256): must be zero
2188     ///
2189     /// @param _values[1 + i * 2] First part of offer data for the i'th offer
2190     /// bits(0..8): Index of the maker's address in _addresses
2191     /// bits(8..16): Index of the maker offerAssetId pair in _addresses
2192     /// bits(16..24): Index of the maker wantAssetId pair in _addresses
2193     /// bits(24..32): Index of the maker feeAssetId pair in _addresses
2194     /// bits(32..40): Index of the operator feeAssetId pair in _addresses
2195     /// bits(40..48): The `v` component of the maker's signature for this offer
2196     /// bits(48..56): Indicates whether the Ethereum signed message
2197     /// prefix should be prepended during signature verification
2198     /// bits(56..120): The offer nonce to prevent replay attacks
2199     /// bits(120..128): Space to indicate whether the offer nonce has been marked before
2200     /// bits(128..256): The number of tokens to be paid to the operator as fees for this offer
2201     ///
2202     /// @param _values[2 + i * 2] Second part of offer data for the i'th offer
2203     /// bits(0..128): offer.offerAmount, i.e. the number of tokens to offer
2204     /// bits(128..256): offer.wantAmount, i.e. the number of tokens to ask for in return
2205     ///
2206     /// @param _values[1 + numOffers * 2 + i * 2] First part of fill data for the i'th fill
2207     /// bits(0..8): Index of the filler's address in _addresses
2208     /// bits(8..16): Index of the filler offerAssetId pair in _addresses
2209     /// bits(16..24): Index of the filler wantAssetId pair in _addresses
2210     /// bits(24..32): Index of the filler feeAssetId pair in _addresses
2211     /// bits(32..40): Index of the operator feeAssetId pair in _addresses
2212     /// bits(40..48): The `v` component of the filler's signature for this fill
2213     /// bits(48..56): Indicates whether the Ethereum signed message
2214     /// prefix should be prepended during signature verification
2215     /// bits(56..120): The fill nonce to prevent replay attacks
2216     /// bits(120..128): Left empty to match the offer values format
2217     /// bits(128..256): The number of tokens to be paid to the operator as fees for this fill
2218     ///
2219     /// @param _values[2 + numOffers * 2 + i * 2] Second part of fill data for the i'th fill
2220     /// bits(0..128): fill.offerAmount, i.e. the number of tokens to offer
2221     /// bits(128..256): fill.wantAmount, i.e. the number of tokens to ask for in return
2222     ///
2223     /// @param _values[1 + numOffers * 2 + numFills * 2 + i] Data for the i'th match
2224     /// bits(0..8): Index of the offerIndex for this match
2225     /// bits(8..16): Index of the fillIndex for this match
2226     /// bits(128..256): The number of tokens to take from the matched offer's offerAmount
2227     ///
2228     /// @param _hashes[i * 2] The `r` component of the maker's / filler's signature
2229     /// for the i'th offer / fill
2230     ///
2231     /// @param _hashes[i * 2 + 1] The `s` component of the maker's / filler's signature
2232     /// for the i'th offer / fill
2233     ///
2234     /// @param _addresses An array of user asset pairs in the form of:
2235     /// [
2236     ///     user_1_address,
2237     ///     asset_1_address,
2238     ///     user_1_address,
2239     ///     asset_2_address,
2240     ///     user_2_address,
2241     ///     asset_1_address,
2242     ///     ...
2243     /// ]
2244     function trade(
2245         uint256[] memory _values,
2246         bytes32[] memory _hashes,
2247         address[] memory _addresses
2248     )
2249         public
2250         onlyAdmin
2251         onlyActiveState
2252         nonReentrant
2253     {
2254         // Cache the operator address to reduce gas costs from storage reads
2255         address operatorAddress = operator;
2256         // An array variable to store balance increments / decrements
2257         uint256[] memory statements;
2258 
2259         // Cache whether offer nonces are taken in the offer's nonce space
2260         _cacheOfferNonceStates(_values);
2261 
2262         // `validateTrades` needs to calculate the hash keys of offers and fills
2263         // to verify the signature of the offer / fill.
2264         // The calculated hash keys are returned to reduce repeated computation.
2265         _hashes = Utils.validateTrades(
2266             _values,
2267             _hashes,
2268             _addresses,
2269             operatorAddress
2270         );
2271 
2272         statements = Utils.calculateTradeIncrements(_values, _addresses.length / 2);
2273         _incrementBalances(statements, _addresses, 1);
2274 
2275         statements = Utils.calculateTradeDecrements(_values, _addresses.length / 2);
2276         _decrementBalances(statements, _addresses);
2277 
2278         // Reduce available offer amounts of offers and store the remaining
2279         // offer amount in the `offers` mapping.
2280         // Offer nonces will also be marked as taken.
2281         _storeOfferData(_values, _hashes);
2282 
2283         // Mark all fill nonces as taken in the `usedNonces` mapping.
2284         _storeFillNonces(_values);
2285     }
2286 
2287     /// @notice Executes an array of offers against external orders.
2288     /// @dev This method accepts an array of "offers" together with
2289     /// an array of "matches" to specify the matching between the "offers" and
2290     /// external orders.
2291     /// The data is bit compacted and formatted in the same way as the `trade` function.
2292     ///
2293     /// @param _values[0] Number of offers, fills, matches
2294     /// bits(0..8): number of offers (numOffers)
2295     /// bits(8..16): number of fills, must be zero
2296     /// bits(16..24): number of matches (numMatches)
2297     /// bits(24..256): must be zero
2298     ///
2299     /// @param _values[1 + i * 2] First part of offer data for the i'th offer
2300     /// bits(0..8): Index of the maker's address in _addresses
2301     /// bits(8..16): Index of the maker offerAssetId pair in _addresses
2302     /// bits(16..24): Index of the maker wantAssetId pair in _addresses
2303     /// bits(24..32): Index of the maker feeAssetId pair in _addresses
2304     /// bits(32..40): Index of the operator feeAssetId pair in _addresses
2305     /// bits(40..48): The `v` component of the maker's signature for this offer
2306     /// bits(48..56): Indicates whether the Ethereum signed message
2307     /// prefix should be prepended during signature verification
2308     /// bits(56..120): The offer nonce to prevent replay attacks
2309     /// bits(120..128): Space to indicate whether the offer nonce has been marked before
2310     /// bits(128..256): The number of tokens to be paid to the operator as fees for this offer
2311     ///
2312     /// @param _values[2 + i * 2] Second part of offer data for the i'th offer
2313     /// bits(0..128): offer.offerAmount, i.e. the number of tokens to offer
2314     /// bits(128..256): offer.wantAmount, i.e. the number of tokens to ask for in return
2315     ///
2316     /// @param _values[1 + numOffers * 2 + i] Data for the i'th match
2317     /// bits(0..8): Index of the offerIndex for this match
2318     /// bits(8..16): Index of the marketDapp for this match
2319     /// bits(16..24): Index of the surplus receiver and surplus asset ID for this
2320     /// match, for any excess tokens resulting from the trade
2321     /// bits(24..128): Additional DApp specific data
2322     /// bits(128..256): The number of tokens to take from the matched offer's offerAmount
2323     ///
2324     /// @param _hashes[i * 2] The `r` component of the maker's / filler's signature
2325     /// for the i'th offer / fill
2326     ///
2327     /// @param _hashes[i * 2 + 1] The `s` component of the maker's / filler's signature
2328     /// for the i'th offer / fill
2329     ///
2330     /// @param _addresses An array of user asset pairs in the form of:
2331     /// [
2332     ///     user_1_address,
2333     ///     asset_1_address,
2334     ///     user_1_address,
2335     ///     asset_2_address,
2336     ///     user_2_address,
2337     ///     asset_1_address,
2338     ///     ...
2339     /// ]
2340     function networkTrade(
2341         uint256[] memory _values,
2342         bytes32[] memory _hashes,
2343         address[] memory _addresses
2344     )
2345         public
2346         onlyAdmin
2347         onlyActiveState
2348         nonReentrant
2349     {
2350         // Cache the operator address to reduce gas costs from storage reads
2351         address operatorAddress = operator;
2352         // An array variable to store balance increments / decrements
2353         uint256[] memory statements;
2354 
2355         // Cache whether offer nonces are taken in the offer's nonce space
2356         _cacheOfferNonceStates(_values);
2357 
2358         // `validateNetworkTrades` needs to calculate the hash keys of offers
2359         // to verify the signature of the offer.
2360         // The calculated hash keys for each offer is return to reduce repeated
2361         // computation.
2362         _hashes = Utils.validateNetworkTrades(
2363             _values,
2364             _hashes,
2365             _addresses,
2366             operatorAddress
2367         );
2368 
2369         statements = Utils.calculateNetworkTradeIncrements(_values, _addresses.length / 2);
2370         _incrementBalances(statements, _addresses, 1);
2371 
2372         statements = Utils.calculateNetworkTradeDecrements(_values, _addresses.length / 2);
2373         _decrementBalances(statements, _addresses);
2374 
2375         // Reduce available offer amounts of offers and store the remaining
2376         // offer amount in the `offers` mapping.
2377         // Offer nonces will also be marked as taken.
2378         _storeOfferData(_values, _hashes);
2379 
2380         // There may be excess tokens resulting from a trade
2381         // Any excess tokens are returned and recorded in `increments`
2382         statements = Utils.performNetworkTrades(
2383             _values,
2384             _addresses,
2385             marketDapps
2386         );
2387         _incrementBalances(statements, _addresses, 0);
2388     }
2389 
2390     /// @notice Cancels a perviously made offer and refunds the remaining offer
2391     /// amount to the offer maker.
2392     /// To reduce gas costs, the original parameters of the offer are not stored
2393     /// in the contract's storage, only the hash of the parameters is stored for
2394     /// verification, so the original parameters need to be re-specified here.
2395     ///
2396     /// The `_expectedavailableamount` is required to help prevent accidental
2397     /// cancellation of an offer ahead of time, for example, if there is
2398     /// a pending fill in the off-chain state.
2399     ///
2400     /// @param _values[0] The offerAmount and wantAmount of the offer
2401     /// bits(0..128): offer.offerAmount
2402     /// bits(128..256): offer.wantAmount
2403     ///
2404     /// @param _values[1] The fee amounts
2405     /// bits(0..128): offer.feeAmount
2406     /// bits(128..256): cancelFeeAmount
2407     ///
2408     /// @param _values[2] Additional offer and cancellation data
2409     /// bits(0..128): expectedAvailableAmount
2410     /// bits(128..136): prefixedSignature
2411     /// bits(136..144): The `v` component of the maker's signature for the cancellation
2412     /// bits(144..256): offer.nonce
2413     ///
2414     /// @param _hashes[0] The `r` component of the maker's signature for the cancellation
2415     /// @param _hashes[1] The `s` component of the maker's signature for the cancellation
2416     ///
2417     /// @param _addresses[0] offer.maker
2418     /// @param _addresses[1] offer.offerAssetId
2419     /// @param _addresses[2] offer.wantAssetId
2420     /// @param _addresses[3] offer.feeAssetId
2421     /// @param _addresses[4] offer.cancelFeeAssetId
2422     function cancel(
2423         uint256[] calldata _values,
2424         bytes32[] calldata _hashes,
2425         address[] calldata _addresses
2426     )
2427         external
2428         onlyAdmin
2429         nonReentrant
2430     {
2431         Utils.validateCancel(_values, _hashes, _addresses);
2432         bytes32 offerHash = Utils.hashOffer(_values, _addresses);
2433         _cancel(
2434             _addresses[0], // maker
2435             offerHash,
2436             _values[2] & mask128, // expectedAvailableAmount
2437             _addresses[1], // offerAssetId
2438             _values[2] >> 144, // offerNonce
2439             _addresses[4], // cancelFeeAssetId
2440             _values[1] >> 128 // cancelFeeAmount
2441         );
2442     }
2443 
2444     /// @notice Cancels an offer without requiring the maker's signature
2445     /// @dev This method is intended to be used in the case of a contract
2446     /// upgrade or in an emergency. It can only be invoked by an admin and only
2447     /// after the admin state has been set to `Escalated` by the contract owner.
2448     ///
2449     /// To reduce gas costs, the original parameters of the offer are not stored
2450     /// in the contract's storage, only the hash of the parameters is stored for
2451     /// verification, so the original parameters need to be re-specified here.
2452     ///
2453     /// The `_expectedavailableamount` is required to help prevent accidental
2454     /// cancellation of an offer ahead of time, for example, if there is
2455     /// a pending fill in the off-chain state.
2456     /// @param _maker The address of the offer's maker
2457     /// @param _offerAssetId The contract address of the offerred asset
2458     /// @param _offerAmount The number of tokens offerred
2459     /// @param _wantAssetId The contract address of the asset asked in return
2460     /// @param _wantAmount The number of tokens asked for in return
2461     /// @param _feeAssetId The contract address of the fee asset
2462     /// @param _feeAmount The number of tokens to pay as fees to the operator
2463     /// @param _offerNonce The nonce of the original offer
2464     /// @param _expectedAvailableAmount The offer amount remaining
2465     function adminCancel(
2466         address _maker,
2467         address _offerAssetId,
2468         uint256 _offerAmount,
2469         address _wantAssetId,
2470         uint256 _wantAmount,
2471         address _feeAssetId,
2472         uint256 _feeAmount,
2473         uint256 _offerNonce,
2474         uint256 _expectedAvailableAmount
2475     )
2476         external
2477         onlyAdmin
2478         onlyEscalatedAdminState
2479         nonReentrant
2480     {
2481         bytes32 offerHash = keccak256(abi.encode(
2482             OFFER_TYPEHASH,
2483             _maker,
2484             _offerAssetId,
2485             _offerAmount,
2486             _wantAssetId,
2487             _wantAmount,
2488             _feeAssetId,
2489             _feeAmount,
2490             _offerNonce
2491         ));
2492 
2493         _cancel(
2494             _maker,
2495             offerHash,
2496             _expectedAvailableAmount,
2497             _offerAssetId,
2498             _offerNonce,
2499             address(0),
2500             0
2501         );
2502     }
2503 
2504     /// @notice Announces a user's intention to cancel their offer
2505     /// @dev This method allows a user to cancel their offer without requiring
2506     /// admin permissions.
2507     /// An announcement followed by a delay is needed so that the off-chain
2508     /// service has time to update the off-chain state.
2509     ///
2510     /// To reduce gas costs, the original parameters of the offer are not stored
2511     /// in the contract's storage, only the hash of the parameters is stored for
2512     /// verification, so the original parameters need to be re-specified here.
2513     ///
2514     /// @param _maker The address of the offer's maker
2515     /// @param _offerAssetId The contract address of the offerred asset
2516     /// @param _offerAmount The number of tokens offerred
2517     /// @param _wantAssetId The contract address of the asset asked in return
2518     /// @param _wantAmount The number of tokens asked for in return
2519     /// @param _feeAssetId The contract address of the fee asset
2520     /// @param _feeAmount The number of tokens to pay as fees to the operator
2521     /// @param _offerNonce The nonce of the original offer
2522     function announceCancel(
2523         address _maker,
2524         address _offerAssetId,
2525         uint256 _offerAmount,
2526         address _wantAssetId,
2527         uint256 _wantAmount,
2528         address _feeAssetId,
2529         uint256 _feeAmount,
2530         uint256 _offerNonce
2531     )
2532         external
2533         nonReentrant
2534     {
2535         // Error code 11: announceCancel, invalid msg.sender
2536         require(_maker == msg.sender, "11");
2537 
2538         bytes32 offerHash = keccak256(abi.encode(
2539             OFFER_TYPEHASH,
2540             _maker,
2541             _offerAssetId,
2542             _offerAmount,
2543             _wantAssetId,
2544             _wantAmount,
2545             _feeAssetId,
2546             _feeAmount,
2547             _offerNonce
2548         ));
2549 
2550         // Error code 12: announceCancel, nothing left to cancel
2551         require(offers[offerHash] > 0, "12");
2552 
2553         uint256 cancellableAt = now.add(slowCancelDelay);
2554         cancellationAnnouncements[offerHash] = cancellableAt;
2555 
2556         emit AnnounceCancel(offerHash, cancellableAt);
2557     }
2558 
2559     /// @notice Executes an offer cancellation previously announced in `announceCancel`
2560     /// @dev This method allows a user to cancel their offer without requiring
2561     /// admin permissions.
2562     /// An announcement followed by a delay is needed so that the off-chain
2563     /// service has time to update the off-chain state.
2564     ///
2565     /// To reduce gas costs, the original parameters of the offer are not stored
2566     /// in the contract's storage, only the hash of the parameters is stored for
2567     /// verification, so the original parameters need to be re-specified here.
2568     ///
2569     /// @param _maker The address of the offer's maker
2570     /// @param _offerAssetId The contract address of the offerred asset
2571     /// @param _offerAmount The number of tokens offerred
2572     /// @param _wantAssetId The contract address of the asset asked in return
2573     /// @param _wantAmount The number of tokens asked for in return
2574     /// @param _feeAssetId The contract address of the fee asset
2575     /// @param _feeAmount The number of tokens to pay as fees to the operator
2576     /// @param _offerNonce The nonce of the original offer
2577     function slowCancel(
2578         address _maker,
2579         address _offerAssetId,
2580         uint256 _offerAmount,
2581         address _wantAssetId,
2582         uint256 _wantAmount,
2583         address _feeAssetId,
2584         uint256 _feeAmount,
2585         uint256 _offerNonce
2586     )
2587         external
2588         nonReentrant
2589     {
2590         bytes32 offerHash = keccak256(abi.encode(
2591             OFFER_TYPEHASH,
2592             _maker,
2593             _offerAssetId,
2594             _offerAmount,
2595             _wantAssetId,
2596             _wantAmount,
2597             _feeAssetId,
2598             _feeAmount,
2599             _offerNonce
2600         ));
2601 
2602         uint256 cancellableAt = cancellationAnnouncements[offerHash];
2603         // Error code 13: slowCancel, cancellation was not announced
2604         require(cancellableAt != 0, "13");
2605         // Error code 14: slowCancel, cancellation delay not yet reached
2606         require(now >= cancellableAt, "14");
2607 
2608         uint256 availableAmount = offers[offerHash];
2609         // Error code 15: slowCancel, nothing left to cancel
2610         require(availableAmount > 0, "15");
2611 
2612         delete cancellationAnnouncements[offerHash];
2613         _cancel(
2614             _maker,
2615             offerHash,
2616             availableAmount,
2617             _offerAssetId,
2618             _offerNonce,
2619             address(0),
2620             0
2621         );
2622 
2623         emit SlowCancel(offerHash, availableAmount);
2624     }
2625 
2626     /// @notice Withdraws tokens from the Broker contract to a user's wallet balance
2627     /// @dev The user's internal balance is decreased, and the tokens are transferred
2628     /// to the `_receivingAddress` signed by the user.
2629     /// @param _withdrawer The user address whose balance will be reduced
2630     /// @param _receivingAddress The address to tranfer the tokens to
2631     /// @param _assetId The contract address of the token to withdraw
2632     /// @param _amount The number of tokens to withdraw
2633     /// @param _feeAssetId The contract address of the fee asset
2634     /// @param _feeAmount The number of tokens to pay as fees to the operator
2635     /// @param _nonce An unused nonce to prevent replay attacks
2636     /// @param _v The `v` component of the `_user`'s signature
2637     /// @param _r The `r` component of the `_user`'s signature
2638     /// @param _s The `s` component of the `_user`'s signature
2639     /// @param _prefixedSignature Indicates whether the Ethereum signed message
2640     /// prefix should be prepended during signature verification
2641     function withdraw(
2642         address _withdrawer,
2643         address payable _receivingAddress,
2644         address _assetId,
2645         uint256 _amount,
2646         address _feeAssetId,
2647         uint256 _feeAmount,
2648         uint256 _nonce,
2649         uint8 _v,
2650         bytes32 _r,
2651         bytes32 _s,
2652         bool _prefixedSignature
2653     )
2654         external
2655         onlyAdmin
2656         nonReentrant
2657     {
2658         _markNonce(_nonce);
2659 
2660         _validateSignature(
2661             keccak256(abi.encode(
2662                 WITHDRAW_TYPEHASH,
2663                 _withdrawer,
2664                 _receivingAddress,
2665                 _assetId,
2666                 _amount,
2667                 _feeAssetId,
2668                 _feeAmount,
2669                 _nonce
2670             )),
2671             _withdrawer,
2672             _v,
2673             _r,
2674             _s,
2675             _prefixedSignature
2676         );
2677 
2678         _withdraw(
2679             _withdrawer,
2680             _receivingAddress,
2681             _assetId,
2682             _amount,
2683             _feeAssetId,
2684             _feeAmount,
2685             _nonce
2686         );
2687     }
2688 
2689     /// @notice Withdraws tokens without requiring the withdrawer's signature
2690     /// @dev This method is intended to be used in the case of a contract
2691     /// upgrade or in an emergency. It can only be invoked by an admin and only
2692     /// after the admin state has been set to `Escalated` by the contract owner.
2693     /// Unlike `withdraw`, tokens can only be withdrawn to the `_withdrawer`'s
2694     /// address.
2695     /// @param _withdrawer The user address whose balance will be reduced
2696     /// @param _assetId The contract address of the token to withdraw
2697     /// @param _amount The number of tokens to withdraw
2698     /// @param _nonce An unused nonce for balance tracking
2699     function adminWithdraw(
2700         address payable _withdrawer,
2701         address _assetId,
2702         uint256 _amount,
2703         uint256 _nonce
2704     )
2705         external
2706         onlyAdmin
2707         onlyEscalatedAdminState
2708         nonReentrant
2709     {
2710         _markNonce(_nonce);
2711 
2712         _withdraw(
2713             _withdrawer,
2714             _withdrawer,
2715             _assetId,
2716             _amount,
2717             address(0),
2718             0,
2719             _nonce
2720         );
2721     }
2722 
2723     /// @notice Announces a user's intention to withdraw their funds
2724     /// @dev This method allows a user to withdraw their funds without requiring
2725     /// admin permissions.
2726     /// An announcement followed by a delay before execution is needed so that
2727     /// the off-chain service has time to update the off-chain state.
2728     /// @param _assetId The contract address of the token to withdraw
2729     /// @param _amount The number of tokens to withdraw
2730     function announceWithdraw(
2731         address _assetId,
2732         uint256 _amount
2733     )
2734         external
2735         nonReentrant
2736     {
2737 
2738         // Error code 16: announceWithdraw, invalid withdrawal amount
2739         require(_amount > 0 && _amount <= balances[msg.sender][_assetId], "16");
2740 
2741         WithdrawalAnnouncement storage announcement = withdrawalAnnouncements[msg.sender][_assetId];
2742 
2743         announcement.withdrawableAt = now.add(slowWithdrawDelay);
2744         announcement.amount = _amount;
2745 
2746         emit AnnounceWithdraw(msg.sender, _assetId, _amount, announcement.withdrawableAt);
2747     }
2748 
2749     /// @notice Executes a withdrawal previously announced in `announceWithdraw`
2750     /// @dev This method allows a user to withdraw their funds without requiring
2751     /// admin permissions.
2752     /// An announcement followed by a delay before execution is needed so that
2753     /// the off-chain service has time to update the off-chain state.
2754     /// @param _withdrawer The user address whose balance will be reduced
2755     /// @param _assetId The contract address of the token to withdraw
2756     function slowWithdraw(
2757         address payable _withdrawer,
2758         address _assetId,
2759         uint256 _amount
2760     )
2761         external
2762         nonReentrant
2763     {
2764         WithdrawalAnnouncement memory announcement = withdrawalAnnouncements[_withdrawer][_assetId];
2765 
2766         // Error code 17: slowWithdraw, withdrawal was not announced
2767         require(announcement.withdrawableAt != 0, "17");
2768         // Error code 18: slowWithdraw, withdrawal delay not yet reached
2769         require(now >= announcement.withdrawableAt, "18");
2770         // Error code 19: slowWithdraw, withdrawal amount does not match announced amount
2771         require(announcement.amount == _amount, "19");
2772 
2773         delete withdrawalAnnouncements[_withdrawer][_assetId];
2774         _withdraw(
2775             _withdrawer,
2776             _withdrawer,
2777             _assetId,
2778             _amount,
2779             address(0),
2780             0,
2781             0
2782         );
2783         emit SlowWithdraw(_withdrawer, _assetId, _amount);
2784     }
2785 
2786     /// @notice Locks a user's balances for the first part of an atomic swap
2787     /// @param _addresses[0] maker: the address of the user to deduct the swap tokens from
2788     /// @param _addresses[1] taker: the address of the swap taker who will receive the swap tokens
2789     /// if the swap is completed through `executeSwap`
2790     /// @param _addresses[2] assetId: the contract address of the token to swap
2791     /// @param _addresses[3] feeAssetId: the contract address of the token to use as fees
2792     /// @param _values[0] amount: the number of tokens to lock and to transfer if the swap
2793     ///  is completed through `executeSwap`
2794     /// @param _values[1] expiryTime: the time in epoch seconds after which the swap will become cancellable
2795     /// @param _values[2] feeAmount: the number of tokens to be paid to the operator as fees
2796     /// @param _values[3] nonce: an unused nonce to prevent replay attacks
2797     /// @param _hashes[0] hashedSecret: the hash of the secret decided by the maker
2798     /// @param _hashes[1] The `r` component of the user's signature
2799     /// @param _hashes[2] The `s` component of the user's signature
2800     /// @param _v The `v` component of the user's signature
2801     /// @param _prefixedSignature Indicates whether the Ethereum signed message
2802     /// prefix should be prepended during signature verification
2803     function createSwap(
2804         address[4] calldata _addresses,
2805         uint256[4] calldata _values,
2806         bytes32[3] calldata _hashes,
2807         uint8 _v,
2808         bool _prefixedSignature
2809     )
2810         external
2811         onlyAdmin
2812         onlyActiveState
2813         nonReentrant
2814     {
2815         // Error code 20: createSwap, invalid swap amount
2816         require(_values[0] > 0, "20");
2817         // Error code 21: createSwap, expiry time has already passed
2818         require(_values[1] > now, "21");
2819         _validateAddress(_addresses[1]);
2820 
2821         // Error code 39: createSwap, swap maker cannot be the swap taker
2822         require(_addresses[0] != _addresses[1], "39");
2823 
2824         bytes32 swapHash = _hashSwap(_addresses, _values, _hashes[0]);
2825         // Error code 22: createSwap, the swap is already active
2826         require(!atomicSwaps[swapHash], "22");
2827 
2828         _markNonce(_values[3]);
2829 
2830         _validateSignature(
2831             swapHash,
2832             _addresses[0], // swap.maker
2833             _v,
2834             _hashes[1], // r
2835             _hashes[2], // s
2836             _prefixedSignature
2837         );
2838 
2839         if (_addresses[3] == _addresses[2]) { // feeAssetId == assetId
2840             // Error code 23: createSwap, swap.feeAmount exceeds swap.amount
2841             require(_values[2] < _values[0], "23"); // feeAmount < amount
2842         } else {
2843             _decreaseBalance(
2844                 _addresses[0], // maker
2845                 _addresses[3], // feeAssetId
2846                 _values[2], // feeAmount
2847                 REASON_SWAP_FEE_GIVE,
2848                 _values[3] // nonce
2849             );
2850         }
2851 
2852         _decreaseBalance(
2853             _addresses[0], // maker
2854             _addresses[2], // assetId
2855             _values[0], // amount
2856             REASON_SWAP_GIVE,
2857             _values[3] // nonce
2858         );
2859 
2860         atomicSwaps[swapHash] = true;
2861     }
2862 
2863     /// @notice Executes a swap by transferring the tokens previously locked through
2864     /// a `createSwap` call to the swap taker.
2865     ///
2866     /// @dev To reduce gas costs, the original parameters of the swap are not stored
2867     /// in the contract's storage, only the hash of the parameters is stored for
2868     /// verification, so the original parameters need to be re-specified here.
2869     ///
2870     /// @param _addresses[0] maker: the address of the user to deduct the swap tokens from
2871     /// @param _addresses[1] taker: the address of the swap taker who will receive the swap tokens
2872     /// @param _addresses[2] assetId: the contract address of the token to swap
2873     /// @param _addresses[3] feeAssetId: the contract address of the token to use as fees
2874     /// @param _values[0] amount: the number of tokens previously locked
2875     /// @param _values[1] expiryTime: the time in epoch seconds after which the swap will become cancellable
2876     /// @param _values[2] feeAmount: the number of tokens to be paid to the operator as fees
2877     /// @param _values[3] nonce: an unused nonce to prevent replay attacks
2878     /// @param _hashedSecret The hash of the secret decided by the maker
2879     /// @param _preimage The preimage of the `_hashedSecret`
2880     function executeSwap(
2881         address[4] calldata _addresses,
2882         uint256[4] calldata _values,
2883         bytes32 _hashedSecret,
2884         bytes calldata _preimage
2885     )
2886         external
2887         nonReentrant
2888     {
2889         // Error code 37: swap secret length exceeded
2890         require(_preimage.length <= MAX_SWAP_SECRET_LENGTH, "37");
2891 
2892         bytes32 swapHash = _hashSwap(_addresses, _values, _hashedSecret);
2893         // Error code 24: executeSwap, swap is not active
2894         require(atomicSwaps[swapHash], "24");
2895         // Error code 25: executeSwap, hash of preimage does not match hashedSecret
2896         require(sha256(abi.encodePacked(sha256(_preimage))) == _hashedSecret, "25");
2897 
2898         uint256 takeAmount = _values[0];
2899         if (_addresses[3] == _addresses[2]) { // feeAssetId == assetId
2900             takeAmount = takeAmount.sub(_values[2]);
2901         }
2902 
2903         delete atomicSwaps[swapHash];
2904 
2905         _increaseBalance(
2906             _addresses[1], // taker
2907             _addresses[2], // assetId
2908             takeAmount,
2909             REASON_SWAP_RECEIVE,
2910             _values[3] // nonce
2911         );
2912 
2913         _increaseBalance(
2914             operator,
2915             _addresses[3], // feeAssetId
2916             _values[2], // feeAmount
2917             REASON_SWAP_FEE_RECEIVE,
2918             _values[3] // nonce
2919         );
2920     }
2921 
2922     /// @notice Cancels a swap and refunds the previously locked tokens to
2923     /// the swap maker.
2924     ///
2925     /// @dev To reduce gas costs, the original parameters of the swap are not stored
2926     /// in the contract's storage, only the hash of the parameters is stored for
2927     /// verification, so the original parameters need to be re-specified here.
2928     ///
2929     /// @param _addresses[0] maker: the address of the user to deduct the swap tokens from
2930     /// @param _addresses[1] taker: the address of the swap taker who will receive the swap tokens
2931     /// @param _addresses[2] assetId: the contract address of the token to swap
2932     /// @param _addresses[3] feeAssetId: the contract address of the token to use as fees
2933     /// @param _values[0] amount: the number of tokens previously locked
2934     /// @param _values[1] expiryTime: the time in epoch seconds after which the swap will become cancellable
2935     /// @param _values[2] feeAmount: the number of tokens to be paid to the operator as fees
2936     /// @param _values[3] nonce: an unused nonce to prevent replay attacks
2937     /// @param _hashedSecret The hash of the secret decided by the maker
2938     /// @param _cancelFeeAmount The number of tokens to be paid to the operator as the cancellation fee
2939     function cancelSwap(
2940         address[4] calldata _addresses,
2941         uint256[4] calldata _values,
2942         bytes32 _hashedSecret,
2943         uint256 _cancelFeeAmount
2944     )
2945         external
2946         nonReentrant
2947     {
2948         // Error code 26: cancelSwap, expiry time has not been reached
2949         require(_values[1] <= now, "26");
2950         bytes32 swapHash = _hashSwap(_addresses, _values, _hashedSecret);
2951         // Error code 27: cancelSwap, swap is not active
2952         require(atomicSwaps[swapHash], "27");
2953 
2954         uint256 cancelFeeAmount = _cancelFeeAmount;
2955         if (!adminAddresses[msg.sender]) { cancelFeeAmount = _values[2]; }
2956 
2957         // cancelFeeAmount <= feeAmount
2958         // Error code 28: cancelSwap, cancelFeeAmount exceeds swap.feeAmount
2959         require(cancelFeeAmount <= _values[2], "28");
2960 
2961         uint256 refundAmount = _values[0];
2962         if (_addresses[3] == _addresses[2]) { // feeAssetId == assetId
2963             refundAmount = refundAmount.sub(cancelFeeAmount);
2964         }
2965 
2966         delete atomicSwaps[swapHash];
2967 
2968         _increaseBalance(
2969             _addresses[0], // maker
2970             _addresses[2], // assetId
2971             refundAmount,
2972             REASON_SWAP_CANCEL_RECEIVE,
2973             _values[3] // nonce
2974         );
2975 
2976         _increaseBalance(
2977             operator,
2978             _addresses[3], // feeAssetId
2979             cancelFeeAmount,
2980             REASON_SWAP_CANCEL_FEE_RECEIVE,
2981             _values[3] // nonce
2982         );
2983 
2984         if (_addresses[3] != _addresses[2]) { // feeAssetId != assetId
2985             uint256 refundFeeAmount = _values[2].sub(cancelFeeAmount);
2986             _increaseBalance(
2987                 _addresses[0], // maker
2988                 _addresses[3], // feeAssetId
2989                 refundFeeAmount,
2990                 REASON_SWAP_CANCEL_FEE_REFUND,
2991                 _values[3] // nonce
2992             );
2993         }
2994     }
2995 
2996     /// @dev Cache whether offer nonces are taken in the offer's nonce space
2997     /// @param _values The _values param from the trade / networkTrade method
2998     function _cacheOfferNonceStates(uint256[] memory _values) private view {
2999         uint256 i = 1;
3000         // i + numOffers * 2
3001         uint256 end = i + (_values[0] & mask8) * 2;
3002 
3003         // loop offers
3004         for(i; i < end; i += 2) {
3005             // Error code 38: Invalid nonce space
3006             require(((_values[i] & mask128) >> 120) == 0, "38");
3007 
3008             uint256 nonce = (_values[i] & mask120) >> 56;
3009             if (_nonceTaken(nonce)) {
3010                 _values[i] = _values[i] | (uint256(1) << 120);
3011             }
3012         }
3013     }
3014 
3015     /// @dev Reduce available offer amounts of offers and store the remaining
3016     /// offer amount in the `offers` mapping.
3017     /// Offer nonces will also be marked as taken.
3018     /// See the `trade` method for param details.
3019     /// @param _values Values from `trade`
3020     /// @param _hashes An array of offer hash keys
3021     function _storeOfferData(
3022         uint256[] memory _values,
3023         bytes32[] memory _hashes
3024     )
3025         private
3026     {
3027         // takenAmounts with same size as numOffers
3028         uint256[] memory takenAmounts = new uint256[](_values[0] & mask8);
3029 
3030         uint256 i = 1;
3031         // i += numOffers * 2
3032         i += (_values[0] & mask8) * 2;
3033         // i += numFills * 2
3034         i += ((_values[0] & mask16) >> 8) * 2;
3035 
3036         uint256 end = _values.length;
3037 
3038         // loop matches
3039         for (i; i < end; i++) {
3040             uint256 offerIndex = _values[i] & mask8;
3041             uint256 takeAmount = _values[i] >> 128;
3042             takenAmounts[offerIndex] = takenAmounts[offerIndex].add(takeAmount);
3043         }
3044 
3045         i = 0;
3046         end = _values[0] & mask8; // numOffers
3047 
3048         // loop offers
3049         for (i; i < end; i++) {
3050             // we can use the cached nonce taken value here because offers have been
3051             // validated to be unique
3052             bool existingOffer = ((_values[i * 2 + 1] & mask128) >> 120) == 1;
3053             bytes32 hashKey = _hashes[i * 2];
3054 
3055             uint256 availableAmount = existingOffer ? offers[hashKey] : (_values[i * 2 + 2] & mask128);
3056             // Error code 31: _storeOfferData, offer's available amount is zero
3057             require(availableAmount > 0, "31");
3058 
3059             uint256 remainingAmount = availableAmount.sub(takenAmounts[i]);
3060             if (remainingAmount > 0) { offers[hashKey] = remainingAmount; }
3061             if (existingOffer && remainingAmount == 0) { delete offers[hashKey]; }
3062 
3063             if (!existingOffer) {
3064                 uint256 nonce = (_values[i * 2 + 1] & mask120) >> 56;
3065                 _markNonce(nonce);
3066             }
3067         }
3068     }
3069 
3070     /// @dev Mark all fill nonces as taken in the `usedNonces` mapping.
3071     /// This also validates fill uniquness within the set of fills in `_values`,
3072     /// since fill nonces are marked one at a time with validation that the
3073     /// nonce to be marked has not been marked before.
3074     /// See the `trade` method for param details.
3075     /// @param _values Values from `trade`
3076     function _storeFillNonces(uint256[] memory _values) private {
3077         // 1 + numOffers * 2
3078         uint256 i = 1 + (_values[0] & mask8) * 2;
3079         // i + numFills * 2
3080         uint256 end = i + ((_values[0] & mask16) >> 8) * 2;
3081 
3082         // loop fills
3083         for(i; i < end; i += 2) {
3084             uint256 nonce = (_values[i] & mask120) >> 56;
3085             _markNonce(nonce);
3086         }
3087     }
3088 
3089     /// @dev The actual cancellation logic shared by `cancel`, `adminCancel`,
3090     /// `slowCancel`.
3091     /// The remaining offer amount is refunded back to the offer's maker, and
3092     /// the specified cancellation fee will be deducted from the maker's balances.
3093     function _cancel(
3094         address _maker,
3095         bytes32 _offerHash,
3096         uint256 _expectedAvailableAmount,
3097         address _offerAssetId,
3098         uint256 _offerNonce,
3099         address _cancelFeeAssetId,
3100         uint256 _cancelFeeAmount
3101     )
3102         private
3103     {
3104         uint256 refundAmount = offers[_offerHash];
3105         // Error code 32: _cancel, there is no offer amount left to cancel
3106         require(refundAmount > 0, "32");
3107         // Error code 33: _cancel, the remaining offer amount does not match
3108         // the expectedAvailableAmount
3109         require(refundAmount == _expectedAvailableAmount, "33");
3110 
3111         delete offers[_offerHash];
3112 
3113         if (_cancelFeeAssetId == _offerAssetId) {
3114             refundAmount = refundAmount.sub(_cancelFeeAmount);
3115         } else {
3116             _decreaseBalance(
3117                 _maker,
3118                 _cancelFeeAssetId,
3119                 _cancelFeeAmount,
3120                 REASON_CANCEL_FEE_GIVE,
3121                 _offerNonce
3122             );
3123         }
3124 
3125         _increaseBalance(
3126             _maker,
3127             _offerAssetId,
3128             refundAmount,
3129             REASON_CANCEL,
3130             _offerNonce
3131         );
3132 
3133         _increaseBalance(
3134             operator,
3135             _cancelFeeAssetId,
3136             _cancelFeeAmount,
3137             REASON_CANCEL_FEE_RECEIVE,
3138             _offerNonce // offer nonce
3139         );
3140     }
3141 
3142     /// @dev The actual withdrawal logic shared by `withdraw`, `adminWithdraw`,
3143     /// `slowWithdraw`. The specified amount is deducted from the `_withdrawer`'s
3144     /// contract balance and transferred to the external `_receivingAddress`,
3145     /// and the specified withdrawal fee will be deducted from the `_withdrawer`'s
3146     /// balance.
3147     function _withdraw(
3148         address _withdrawer,
3149         address payable _receivingAddress,
3150         address _assetId,
3151         uint256 _amount,
3152         address _feeAssetId,
3153         uint256 _feeAmount,
3154         uint256 _nonce
3155     )
3156         private
3157     {
3158         // Error code 34: _withdraw, invalid withdrawal amount
3159         require(_amount > 0, "34");
3160 
3161         _validateAddress(_receivingAddress);
3162 
3163         _decreaseBalance(
3164             _withdrawer,
3165             _assetId,
3166             _amount,
3167             REASON_WITHDRAW,
3168             _nonce
3169         );
3170 
3171         _increaseBalance(
3172             operator,
3173             _feeAssetId,
3174             _feeAmount,
3175             REASON_WITHDRAW_FEE_RECEIVE,
3176             _nonce
3177         );
3178 
3179         uint256 withdrawAmount;
3180 
3181         if (_feeAssetId == _assetId) {
3182             withdrawAmount = _amount.sub(_feeAmount);
3183         } else {
3184             _decreaseBalance(
3185                 _withdrawer,
3186                 _feeAssetId,
3187                 _feeAmount,
3188                 REASON_WITHDRAW_FEE_GIVE,
3189                 _nonce
3190             );
3191             withdrawAmount = _amount;
3192         }
3193 
3194         if (_assetId == ETHER_ADDR) {
3195             _receivingAddress.transfer(withdrawAmount);
3196             return;
3197         }
3198 
3199         Utils.transferTokensOut(
3200             _receivingAddress,
3201             _assetId,
3202             withdrawAmount
3203         );
3204     }
3205 
3206     /// @dev Creates a hash key for a swap using the swap's parameters
3207     /// @param _addresses[0] Address of the user making the swap
3208     /// @param _addresses[1] Address of the user taking the swap
3209     /// @param _addresses[2] Contract address of the asset to swap
3210     /// @param _addresses[3] Contract address of the fee asset
3211     /// @param _values[0] The number of tokens to be transferred
3212     /// @param _values[1] The time in epoch seconds after which the swap will become cancellable
3213     /// @param _values[2] The number of tokens to pay as fees to the operator
3214     /// @param _values[3] The swap nonce to prevent replay attacks
3215     /// @param _hashedSecret The hash of the secret decided by the maker
3216     /// @return The hash key of the swap
3217     function _hashSwap(
3218         address[4] memory _addresses,
3219         uint256[4] memory _values,
3220         bytes32 _hashedSecret
3221     )
3222         private
3223         pure
3224         returns (bytes32)
3225     {
3226         return keccak256(abi.encode(
3227             SWAP_TYPEHASH,
3228             _addresses[0], // maker
3229             _addresses[1], // taker
3230             _addresses[2], // assetId
3231             _values[0], // amount
3232             _hashedSecret, // hashedSecret
3233             _values[1], // expiryTime
3234             _addresses[3], // feeAssetId
3235             _values[2], // feeAmount
3236             _values[3] // nonce
3237         ));
3238     }
3239 
3240     /// @dev Checks if the `_nonce` had been previously taken.
3241     /// To reduce gas costs, a single `usedNonces` value is used to
3242     /// store the state of 256 nonces, using the formula:
3243     /// nonceTaken = "usedNonces[_nonce / 256] bit (_nonce % 256)" != 0
3244     /// For example:
3245     /// nonce 0 taken: "usedNonces[0] bit 0" != 0 (0 / 256 = 0, 0 % 256 = 0)
3246     /// nonce 1 taken: "usedNonces[0] bit 1" != 0 (1 / 256 = 0, 1 % 256 = 1)
3247     /// nonce 2 taken: "usedNonces[0] bit 2" != 0 (2 / 256 = 0, 2 % 256 = 2)
3248     /// nonce 255 taken: "usedNonces[0] bit 255" != 0 (255 / 256 = 0, 255 % 256 = 255)
3249     /// nonce 256 taken: "usedNonces[1] bit 0" != 0 (256 / 256 = 1, 256 % 256 = 0)
3250     /// nonce 257 taken: "usedNonces[1] bit 1" != 0 (257 / 256 = 1, 257 % 256 = 1)
3251     /// @param _nonce The nonce to check
3252     /// @return Whether the nonce has been taken
3253     function _nonceTaken(uint256 _nonce) private view returns (bool) {
3254         uint256 slotData = _nonce.div(256);
3255         uint256 shiftedBit = uint256(1) << _nonce.mod(256);
3256         uint256 bits = usedNonces[slotData];
3257 
3258         // The check is for "!= 0" instead of "== 1" because the shiftedBit is
3259         // not at the zero'th position, so it would require an additional
3260         // shift to compare it with "== 1"
3261         return bits & shiftedBit != 0;
3262     }
3263 
3264     /// @dev Sets the corresponding `_nonce` bit to 1.
3265     /// An error will be raised if the corresponding `_nonce` bit was
3266     /// previously set to 1.
3267     /// See `_nonceTaken` for details on calculating the corresponding `_nonce` bit.
3268     /// @param _nonce The nonce to mark
3269     function _markNonce(uint256 _nonce) private {
3270         // Error code 35: _markNonce, nonce cannot be zero
3271         require(_nonce != 0, "35");
3272 
3273         uint256 slotData = _nonce.div(256);
3274         uint256 shiftedBit = 1 << _nonce.mod(256);
3275         uint256 bits = usedNonces[slotData];
3276 
3277         // Error code 36: _markNonce, nonce has already been marked
3278         require(bits & shiftedBit == 0, "36");
3279 
3280         usedNonces[slotData] = bits | shiftedBit;
3281     }
3282 
3283     /// @dev Validates that the specified `_hash` was signed by the specified `_user`.
3284     /// This method supports the EIP712 specification, the older Ethereum
3285     /// signed message specification is also supported for backwards compatibility.
3286     /// @param _hash The original hash that was signed by the user
3287     /// @param _user The user who signed the hash
3288     /// @param _v The `v` component of the `_user`'s signature
3289     /// @param _r The `r` component of the `_user`'s signature
3290     /// @param _s The `s` component of the `_user`'s signature
3291     /// @param _prefixed If true, the signature will be verified
3292     /// against the Ethereum signed message specification instead of the
3293     /// EIP712 specification
3294     function _validateSignature(
3295         bytes32 _hash,
3296         address _user,
3297         uint8 _v,
3298         bytes32 _r,
3299         bytes32 _s,
3300         bool _prefixed
3301     )
3302         private
3303         pure
3304     {
3305         Utils.validateSignature(
3306             _hash,
3307             _user,
3308             _v,
3309             _r,
3310             _s,
3311             _prefixed
3312         );
3313     }
3314 
3315     /// @dev A utility method to increase the balance of a user.
3316     /// A corressponding `BalanceIncrease` event will also be emitted.
3317     /// @param _user The address to increase balance for
3318     /// @param _assetId The asset's contract address
3319     /// @param _amount The number of tokens to increase the balance by
3320     /// @param _reasonCode The reason code for the `BalanceIncrease` event
3321     /// @param _nonce The nonce for the `BalanceIncrease` event
3322     function _increaseBalance(
3323         address _user,
3324         address _assetId,
3325         uint256 _amount,
3326         uint256 _reasonCode,
3327         uint256 _nonce
3328     )
3329         private
3330     {
3331         if (_amount == 0) { return; }
3332         balances[_user][_assetId] = balances[_user][_assetId].add(_amount);
3333 
3334         emit BalanceIncrease(
3335             _user,
3336             _assetId,
3337             _amount,
3338             _reasonCode,
3339             _nonce
3340         );
3341     }
3342 
3343     /// @dev A utility method to decrease the balance of a user.
3344     /// A corressponding `BalanceDecrease` event will also be emitted.
3345     /// @param _user The address to decrease balance for
3346     /// @param _assetId The asset's contract address
3347     /// @param _amount The number of tokens to decrease the balance by
3348     /// @param _reasonCode The reason code for the `BalanceDecrease` event
3349     /// @param _nonce The nonce for the `BalanceDecrease` event
3350     function _decreaseBalance(
3351         address _user,
3352         address _assetId,
3353         uint256 _amount,
3354         uint256 _reasonCode,
3355         uint256 _nonce
3356     )
3357         private
3358     {
3359         if (_amount == 0) { return; }
3360         balances[_user][_assetId] = balances[_user][_assetId].sub(_amount);
3361 
3362         emit BalanceDecrease(
3363             _user,
3364             _assetId,
3365             _amount,
3366             _reasonCode,
3367             _nonce
3368         );
3369     }
3370 
3371     /// @dev Ensures that `_address` is not the zero address
3372     /// @param _address The address to check
3373     function _validateAddress(address _address) private pure {
3374         Utils.validateAddress(_address);
3375     }
3376 
3377     /// @dev A utility method to increase balances of multiple addresses.
3378     /// A corressponding `Increment` event will also be emitted.
3379     /// @param _increments An array of amounts to increase a user's balance by,
3380     /// the corresponding user and assetId is referenced by
3381     /// _addresses[index * 2] and _addresses[index * 2 + 1] respectively
3382     /// @param _addresses An array of user asset pairs in the form of:
3383     /// [
3384     ///     user_1_address,
3385     ///     asset_1_address,
3386     ///     user_1_address,
3387     ///     asset_2_address,
3388     ///     user_2_address,
3389     ///     asset_1_address,
3390     ///     ...
3391     /// ]
3392     /// @param _static Indicates if the amount was pre-calculated or only known
3393     /// at the time the transaction was executed
3394     function _incrementBalances(
3395         uint256[] memory _increments,
3396         address[] memory _addresses,
3397         uint256 _static
3398     )
3399         private
3400     {
3401         uint256 end = _increments.length;
3402 
3403         for(uint256 i = 0; i < end; i++) {
3404             uint256 increment = _increments[i];
3405             if (increment == 0) { continue; }
3406 
3407             balances[_addresses[i * 2]][_addresses[i * 2 + 1]] =
3408             balances[_addresses[i * 2]][_addresses[i * 2 + 1]].add(increment);
3409 
3410             emit Increment((i << 248) | (_static << 240) | increment);
3411         }
3412     }
3413 
3414     /// @dev A utility method to decrease balances of multiple addresses.
3415     /// A corressponding `Decrement` event will also be emitted.
3416     /// @param _decrements An array of amounts to decrease a user's balance by,
3417     /// the corresponding user and assetId is referenced by
3418     /// _addresses[index * 2] and _addresses[index * 2 + 1] respectively
3419     /// @param _addresses An array of user asset pairs in the form of:
3420     /// [
3421     ///     user_1_address,
3422     ///     asset_1_address,
3423     ///     user_1_address,
3424     ///     asset_2_address,
3425     ///     user_2_address,
3426     ///     asset_1_address,
3427     ///     ...
3428     /// ]
3429     function _decrementBalances(
3430         uint256[] memory _decrements,
3431         address[] memory _addresses
3432     )
3433         private
3434     {
3435         uint256 end = _decrements.length;
3436         for(uint256 i = 0; i < end; i++) {
3437             uint256 decrement = _decrements[i];
3438             if (decrement == 0) { continue; }
3439 
3440             balances[_addresses[i * 2]][_addresses[i * 2 + 1]] =
3441             balances[_addresses[i * 2]][_addresses[i * 2 + 1]].sub(decrement);
3442 
3443             emit Decrement(i << 248 | decrement);
3444         }
3445     }
3446 }