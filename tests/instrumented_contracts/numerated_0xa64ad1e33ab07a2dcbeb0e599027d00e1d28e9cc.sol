1 pragma solidity ^0.5.3;
2 
3 
4 /**
5  * Copyright © 2017-2019 Ramp Network sp. z o.o. All rights reserved (MIT License).
6  * 
7  * Permission is hereby granted, free of charge, to any person obtaining a copy of this software
8  * and associated documentation files (the "Software"), to deal in the Software without restriction,
9  * including without limitation the rights to use, copy, modify, merge, publish, distribute,
10  * sublicense, and/or sell copies of the Software, and to permit persons to whom the Software
11  * is furnished to do so, subject to the following conditions:
12  * 
13  * The above copyright notice and this permission notice shall be included in all copies
14  * or substantial portions of the Software.
15  * 
16  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
17  * BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
18  * AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
19  * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
20  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
21  */
22 
23 
24 /**
25  * Abstract class for an asset adapter -- a class handling the binary asset description,
26  * encapsulating the asset-specific transfer logic.
27  * The `assetData` bytes consist of a 2-byte (uint16) asset type, followed by asset-specific data.
28  * The asset type bytes must be equal to the `ASSET_TYPE` constant in each subclass.
29  *
30  * @dev Subclasses of this class are used as mixins to their respective main swap contract.
31  *
32  * @author Ramp Network sp. z o.o.
33  */
34 contract AssetAdapter {
35 
36     uint16 public ASSET_TYPE;
37     bytes32 internal EIP712_SWAP_TYPEHASH;
38     bytes32 internal EIP712_ASSET_TYPEHASH;
39 
40     constructor(
41         uint16 assetType,
42         bytes32 swapTypehash,
43         bytes32 assetTypehash
44     ) internal {
45         ASSET_TYPE = assetType;
46         EIP712_SWAP_TYPEHASH = swapTypehash;
47         EIP712_ASSET_TYPEHASH = assetTypehash;
48     }
49 
50     /**
51      * Ensure the described asset is sent to the given address.
52      * Should revert if the transfer failed, but callers must also handle `false` being returned,
53      * much like ERC20's `transfer`.
54      */
55     function sendAssetTo(bytes memory assetData, address payable _to) internal returns (bool success);
56 
57     /**
58      * Ensure the described asset is sent to the contract (check `msg.value` for ether,
59      * do a `transferFrom` for tokens, etc).
60      * Should revert if the transfer failed, but callers must also handle `false` being returned,
61      * much like ERC20's `transfer`.
62      *
63      * @dev subclasses that don't use ether should mark this with the `noEther` modifier, to make
64      * sure no ether is sent -- because, to have one consistent interface, the `create` function
65      * in `AbstractRampSwaps` is marked `payable`.
66      */
67     function lockAssetFrom(bytes memory assetData, address _from) internal returns (bool success);
68 
69     /**
70      * Returns the EIP712 hash of the handled asset data struct.
71      * See `getAssetTypedHash` in the subclasses for asset struct type description.
72      */
73     function getAssetTypedHash(bytes memory data) internal view returns (bytes32);
74 
75     /**
76      * Verify that the passed asset data should be handled by this adapter.
77      *
78      * @dev it's sufficient to use this only when creating a new swap -- all the other swap
79      * functions first check if the swap hash is valid, while a swap hash with invalid
80      * asset type wouldn't be created at all.
81      *
82      * @dev asset type is 2 bytes long, and it's at offset 32 in `assetData`'s memory (the first 32
83      * bytes are the data length). We load the word at offset 2 (it ends with the asset type bytes),
84      * and retrieve its last 2 bytes into a `uint16` variable.
85      */
86     modifier checkAssetType(bytes memory assetData) {
87         uint16 assetType;
88         // solium-disable-next-line security/no-inline-assembly
89         assembly {
90             assetType := and(
91                 mload(add(assetData, 2)),
92                 0xffff
93             )
94         }
95         require(assetType == ASSET_TYPE, "invalid asset type");
96         _;
97     }
98 
99     modifier noEther() {
100         require(msg.value == 0, "this asset doesn't accept ether");
101         _;
102     }
103 
104 }
105 
106 
107 /**
108  * @title partial ERC 20 Token interface according to official documentation:
109  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
110  */
111 interface Erc20Token {
112 
113     /**
114      * Send `_value` of tokens from `msg.sender` to `_to`
115      *
116      * @param _to The recipient address
117      * @param _value The amount of tokens to be transferred
118      * @return Indication if the transfer was successful
119      */
120     function transfer(address _to, uint256 _value) external returns (bool success);
121 
122     /**
123      * Approve `_spender` to withdraw from sender's account multiple times, up to `_value`
124      * amount. If this function is called again it overwrites the current allowance with _value.
125      *
126      * @param _spender The address allowed to operate on sender's tokens
127      * @param _value The amount of tokens allowed to be transferred
128      * @return Indication if the approval was successful
129      */
130     function approve(address _spender, uint256 _value) external returns (bool success);
131 
132     /**
133      * Transfer tokens on behalf of `_from`, provided it was previously approved.
134      *
135      * @param _from The transfer source address (tokens owner)
136      * @param _to The transfer destination address
137      * @param _value The amount of tokens to be transferred
138      * @return Indication if the approval was successful
139      */
140     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
141 }
142 
143 
144 /**
145  * An adapter for handling ERC20-based token swaps.
146  *
147  * @author Ramp Network sp. z o.o.
148  */
149 contract TokenAdapter is AssetAdapter {
150 
151     uint16 internal constant TOKEN_TYPE_ID = 2;
152     
153     // the hashes are generated using `genTypeHashes` from `eip712.swaps`
154     constructor() internal AssetAdapter(
155         TOKEN_TYPE_ID,
156         0xacdf4bfc42db1ef8f283505784fc4d04c30ee19cc3ff6ae81e0a8e522ddcc950,
157         0x36cb415f6a5e783824a0cf6e4d040975f6b49a9b971f3362c7a48e4ebe338f28
158     ) {}
159 
160     /**
161     * @dev byte offsets, byte length & contents for token asset data:
162     * +00  32  uint256  data length (== 0x36 == 54 bytes)
163     * +32   2  uint16   asset type  (== 2)
164     * +34  32  uint256  token amount in units
165     * +66  20  address  token contract address
166     */
167     function getAmount(bytes memory assetData) internal pure returns (uint256 amount) {
168         // solium-disable-next-line security/no-inline-assembly
169         assembly {
170             amount := mload(add(assetData, 34))
171         }
172     }
173 
174     /**
175      * @dev To retrieve the address at offset 66, get the word at offset 54 and return its last
176      * 20 bytes. See `getAmount` for byte offsets table.
177      */
178     function getTokenAddress(bytes memory assetData) internal pure returns (address tokenAddress) {
179         // solium-disable-next-line security/no-inline-assembly
180         assembly {
181             tokenAddress := and(
182                 mload(add(assetData, 54)),
183                 0xffffffffffffffffffffffffffffffffffffffff
184             )
185         }
186     }
187 
188     function sendAssetTo(
189         bytes memory assetData, address payable _to
190     ) internal returns (bool success) {
191         Erc20Token token = Erc20Token(getTokenAddress(assetData));
192         return token.transfer(_to, getAmount(assetData));
193     }
194 
195     function lockAssetFrom(
196         bytes memory assetData, address _from
197     ) internal noEther returns (bool success) {
198         Erc20Token token = Erc20Token(getTokenAddress(assetData));
199         return token.transferFrom(_from, address(this), getAmount(assetData));
200     }
201 
202     /**
203      * Returns the EIP712 hash of the token asset data struct:
204      * EIP712TokenAsset {
205      *    amount: uint256;
206      *    tokenAddress: address;
207      * }
208      */
209     function getAssetTypedHash(bytes memory data) internal view returns (bytes32) {
210         return keccak256(
211             abi.encode(
212                 EIP712_ASSET_TYPEHASH,
213                 getAmount(data),
214                 getTokenAddress(data)
215             )
216         );
217     }
218 }
219 
220 
221 contract Ownable {
222 
223     address public owner;
224 
225     constructor() internal {
226         owner = msg.sender;
227     }
228 
229     modifier onlyOwner() {
230         require(msg.sender == owner, "only the owner can call this");
231         _;
232     }
233 
234 }
235 
236 
237 /**
238  * An extended version of the standard `Pausable` contract, with more possible statuses:
239  *  * STOPPED: all swap actions cannot be executed until the status is changed,
240  *  * RETURN_ONLY: the existing swaps can only be returned, no new swaps can be created;
241  *  * FINALIZE_ONLY: the existing swaps can be released or returned, no new swaps can be created;
242  *  * ACTIVE: all swap actions can be executed.
243  *
244  * @dev the status enum is strictly monotonic, and the default 0 is mapped to STOPPED for safety.
245  */
246 contract WithStatus is Ownable {
247 
248     enum Status {
249         STOPPED,
250         RETURN_ONLY,
251         FINALIZE_ONLY,
252         ACTIVE
253     }
254 
255     event StatusChanged(Status oldStatus, Status newStatus);
256 
257     Status public status = Status.ACTIVE;
258 
259     constructor() internal {}
260 
261     function setStatus(Status _status) external onlyOwner {
262         emit StatusChanged(status, _status);
263         status = _status;
264     }
265 
266     modifier statusAtLeast(Status _status) {
267         require(status >= _status, "invalid contract status");
268         _;
269     }
270 
271 }
272 
273 
274 /**
275  * An owner-managed list of oracles, that are allowed to claim, release or return swaps.
276  */
277 contract WithOracles is Ownable {
278 
279     mapping (address => bool) oracles;
280 
281     /**
282      * The deployer is the default oracle.
283      */
284     constructor() internal {
285         oracles[msg.sender] = true;
286     }
287 
288     function approveOracle(address _oracle) external onlyOwner {
289         oracles[_oracle] = true;
290     }
291 
292     function revokeOracle(address _oracle) external onlyOwner {
293         oracles[_oracle] = false;
294     }
295 
296     modifier isOracle(address _oracle) {
297         require(oracles[_oracle], "invalid oracle address");
298         _;
299     }
300 
301     modifier onlyOracle(address _oracle) {
302         require(
303             msg.sender == _oracle && oracles[msg.sender],
304             "only the oracle can call this"
305         );
306         _;
307     }
308 
309     modifier onlyOracleOrSender(address _sender, address _oracle) {
310         require(
311             msg.sender == _sender || (msg.sender == _oracle && oracles[msg.sender]),
312             "only the oracle or the sender can call this"
313         );
314         _;
315     }
316 
317     modifier onlySender(address _sender) {
318         require(msg.sender == _sender, "only the sender can call this");
319         _;
320     }
321 
322 }
323 
324 
325 /**
326  * The main contract managing Ramp Swaps escrows lifecycle: create, claim, release and return.
327  * Uses an abstract AssetAdapter to carry out the transfers and handle the particular asset data.
328  * With a corresponding off-chain protocol allows for atomic-swap-like transfer between
329  * fiat currencies and crypto assets.
330  *
331  * @dev an active swap is represented by a hash of its details, mapped to its escrow expiration
332  * timestamp. When the swap is created, but not yet claimed, its end time is set to SWAP_UNCLAIMED.
333  * The hashed swap details are:
334  *  * address sender: the swap's creator, that sells the crypto asset;
335  *  * address receiver: the user that buys the crypto asset, `0x0` until the swap is claimed;
336  *  * address oracle: address of the oracle that handles this particular swap;
337  *  * bytes assetData: description of the crypto asset, handled by an AssetAdapter;
338  *  * bytes32 paymentDetailsHash: hash of the fiat payment details: account numbers, fiat value
339  *    and currency, and the transfer reference (title), that can be verified off-chain.
340  *
341  * @author Ramp Network sp. z o.o.
342  */
343 contract AbstractRampSwaps is Ownable, WithStatus, WithOracles, AssetAdapter {
344 
345     /// @dev contract version, defined in semver
346     string public constant VERSION = "0.3.1";
347 
348     /// @dev used as a special swap endTime value, to denote a yet unclaimed swap
349     uint32 internal constant SWAP_UNCLAIMED = 1;
350     uint32 internal constant MIN_ACTUAL_TIMESTAMP = 1000000000;
351 
352     /// @notice how long are sender's funds locked from a claim until he can cancel the swap
353     uint32 internal constant SWAP_LOCK_TIME_S = 3600 * 24 * 7;
354 
355     event Created(bytes32 indexed swapHash);
356     event BuyerSet(bytes32 indexed oldSwapHash, bytes32 indexed newSwapHash);
357     event Claimed(bytes32 indexed oldSwapHash, bytes32 indexed newSwapHash);
358     event Released(bytes32 indexed swapHash);
359     event SenderReleased(bytes32 indexed swapHash);
360     event Returned(bytes32 indexed swapHash);
361     event SenderReturned(bytes32 indexed swapHash);
362 
363     /**
364      * @notice Mapping from swap details hash to its end time (as a unix timestamp).
365      * After the end time the swap can be cancelled, and the funds will be returned to the sender.
366      * Value `(SWAP_UNCLAIMED)` is used to denote that a swap exists, but has not yet been claimed
367      * by any receiver, and can also be cancelled until that.
368      */
369     mapping (bytes32 => uint32) internal swaps;
370 
371     /**
372      * @dev EIP712 type hash for the struct:
373      * EIP712Domain {
374      *   name: string;
375      *   version: string;
376      *   chainId: uint256;
377      *   verifyingContract: address;
378      * }
379      */
380     bytes32 internal constant EIP712_DOMAIN_TYPEHASH = 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;
381     bytes32 internal EIP712_DOMAIN_HASH;
382 
383     constructor(uint256 _chainId) internal {
384         EIP712_DOMAIN_HASH = keccak256(
385             abi.encode(
386                 EIP712_DOMAIN_TYPEHASH,
387                 keccak256(bytes("RampSwaps")),
388                 keccak256(bytes(VERSION)),
389                 _chainId,
390                 address(this)
391             )
392         );
393     }
394 
395     /**
396      * Swap creation, called by the crypto sender. Checks swap parameters and ensures the crypto
397      * asset is locked on this contract.
398      * Additionally to the swap details, this function takes params v, r, s, which is checked to be
399      * an ECDSA signature of the swap hash made by the oracle -- to prevent users from creating
400      * swaps outside Ramp Network.
401      *
402      * Emits a `Created` event with the swap hash.
403      */
404     function create(
405         address _oracle,
406         bytes calldata _assetData,
407         bytes32 _paymentDetailsHash,
408         uint8 v,
409         bytes32 r,
410         bytes32 s
411     )
412         external
413         payable
414         statusAtLeast(Status.ACTIVE)
415         isOracle(_oracle)
416         checkAssetType(_assetData)
417         returns
418         (bool success)
419     {
420         bytes32 swapHash = getSwapHash(
421             msg.sender, address(0), _oracle, keccak256(_assetData), _paymentDetailsHash
422         );
423         requireSwapNotExists(swapHash);
424         require(ecrecover(swapHash, v, r, s) == _oracle, "invalid swap oracle signature");
425         // Set up swap status before transfer, to avoid reentrancy attacks.
426         // Even if a malicious token is somehow passed to this function (despite the oracle
427         // signature of its details), the state of this contract is already fully updated,
428         // so it will behave correctly (as it would be a separate call).
429         swaps[swapHash] = SWAP_UNCLAIMED;
430         require(
431             lockAssetFrom(_assetData, msg.sender),
432             "failed to lock asset on escrow"
433         );
434         emit Created(swapHash);
435         return true;
436     }
437 
438     /**
439      * Swap claim, called by the swap's oracle on behalf of the receiver, to confirm his interest
440      * in buying the crypto asset.
441      * Additional v, r, s parameters are checked to be the receiver's EIP712 typed data signature
442      * of the swap's details and a 'claim this swap' action -- which verifies the receiver's address
443      * and the authenthicity of his claim request. See `getClaimTypedHash` for description of the
444      * signed swap struct.
445      *
446      * Emits a `Claimed` event with the current swap hash and the new swap hash, updated with
447      * receiver's address. The current swap hash equal to the hash emitted in `create`, unless
448      * `setBuyer` was called in the meantime -- then the current swap hash is equal to the new
449      * swap hash, because the receiver's address was already set.
450      */
451     function claim(
452         address _sender,
453         address _receiver,
454         address _oracle,
455         bytes calldata _assetData,
456         bytes32 _paymentDetailsHash,
457         uint8 v,
458         bytes32 r,
459         bytes32 s
460     ) external statusAtLeast(Status.ACTIVE) onlyOracle(_oracle) {
461         // Verify claim signature
462         bytes32 claimTypedHash = getClaimTypedHash(
463             _sender,
464             _receiver,
465             _assetData,
466             _paymentDetailsHash
467         );
468         require(ecrecover(claimTypedHash, v, r, s) == _receiver, "invalid claim receiver signature");
469         // Verify swap hashes
470         bytes32 oldSwapHash = getSwapHash(
471             _sender, address(0), _oracle, keccak256(_assetData), _paymentDetailsHash
472         );
473         bytes32 newSwapHash = getSwapHash(
474             _sender, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash
475         );
476         bytes32 claimFromHash;
477         // We want this function to be universal, regardless of whether `setBuyer` was called before.
478         // If it was, the hash is already changed
479         if (swaps[oldSwapHash] == 0) {
480             claimFromHash = newSwapHash;
481             requireSwapUnclaimed(newSwapHash);
482         } else {
483             claimFromHash = oldSwapHash;
484             requireSwapUnclaimed(oldSwapHash);
485             requireSwapNotExists(newSwapHash);
486             swaps[oldSwapHash] = 0;
487         }
488         // any overflow security warnings can be safely ignored -- SWAP_LOCK_TIME_S is a small
489         // constant, so this won't overflow an uint32 until year 2106
490         // solium-disable-next-line security/no-block-members
491         swaps[newSwapHash] = uint32(block.timestamp) + SWAP_LOCK_TIME_S;
492         emit Claimed(claimFromHash, newSwapHash);
493     }
494 
495     /**
496      * Swap release, which transfers the crypto asset to the receiver and removes the swap from
497      * the active swap mapping. Normally called by the swap's oracle after it confirms a matching
498      * wire transfer on sender's bank account. Can be also called by the sender, for example in case
499      * of a dispute, when the parties reach an agreement off-chain.
500      *
501      * Emits a `Released` event with the swap's hash.
502      */
503     function release(
504         address _sender,
505         address payable _receiver,
506         address _oracle,
507         bytes calldata _assetData,
508         bytes32 _paymentDetailsHash
509     ) external statusAtLeast(Status.FINALIZE_ONLY) onlyOracleOrSender(_sender, _oracle) {
510         bytes32 swapHash = getSwapHash(
511             _sender, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash
512         );
513         requireSwapClaimed(swapHash);
514         // Delete the swap status before transfer, to avoid reentrancy attacks.
515         swaps[swapHash] = 0;
516         require(
517             sendAssetTo(_assetData, _receiver),
518             "failed to send asset to receiver"
519         );
520         if (msg.sender == _sender) {
521             emit SenderReleased(swapHash);
522         } else {
523             emit Released(swapHash);
524         }
525     }
526 
527     /**
528      * Swap return, which transfers the crypto asset back to the sender and removes the swap from
529      * the active swap mapping. Can be called by the sender or the swap's oracle, but only if the
530      * swap is not claimed, or was claimed but the escrow lock time expired.
531      *
532      * Emits a `Returned` event with the swap's hash.
533      */
534     function returnFunds(
535         address payable _sender,
536         address _receiver,
537         address _oracle,
538         bytes calldata _assetData,
539         bytes32 _paymentDetailsHash
540     ) external statusAtLeast(Status.RETURN_ONLY) onlyOracleOrSender(_sender, _oracle) {
541         bytes32 swapHash = getSwapHash(
542             _sender, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash
543         );
544         requireSwapUnclaimedOrExpired(swapHash);
545         // Delete the swap status before transfer, to avoid reentrancy attacks.
546         swaps[swapHash] = 0;
547         require(
548             sendAssetTo(_assetData, _sender),
549             "failed to send asset to sender"
550         );
551         if (msg.sender == _sender) {
552             emit SenderReturned(swapHash);
553         } else {
554             emit Returned(swapHash);
555         }
556     }
557 
558     /**
559      * After the sender creates a swap, he can optionally call this function to restrict the swap
560      * to a particular receiver address. The swap can't then be claimed by any other receiver.
561      *
562      * Emits a `BuyerSet` event with the created swap hash and new swap hash, updated with
563      * receiver's address.
564      */
565     function setBuyer(
566         address _sender,
567         address _receiver,
568         address _oracle,
569         bytes calldata _assetData,
570         bytes32 _paymentDetailsHash
571     ) external statusAtLeast(Status.ACTIVE) onlySender(_sender) {
572         bytes32 assetHash = keccak256(_assetData);
573         bytes32 oldSwapHash = getSwapHash(
574             _sender, address(0), _oracle, assetHash, _paymentDetailsHash
575         );
576         requireSwapUnclaimed(oldSwapHash);
577         bytes32 newSwapHash = getSwapHash(
578             _sender, _receiver, _oracle, assetHash, _paymentDetailsHash
579         );
580         requireSwapNotExists(newSwapHash);
581         swaps[oldSwapHash] = 0;
582         swaps[newSwapHash] = SWAP_UNCLAIMED;
583         emit BuyerSet(oldSwapHash, newSwapHash);
584     }
585 
586     /**
587      * Given all valid swap details, returns its status. To check a swap with unset buyer,
588      * use `0x0` as the `_receiver` address. The return can be:
589      * 0: the swap details are invalid, swap doesn't exist, or was already released/returned.
590      * 1: the swap was created, and is not claimed yet.
591      * >1: the swap was claimed, and the value is a timestamp indicating end of its lock time.
592      */
593     function getSwapStatus(
594         address _sender,
595         address _receiver,
596         address _oracle,
597         bytes calldata _assetData,
598         bytes32 _paymentDetailsHash
599     ) external view returns (uint32 status) {
600         bytes32 swapHash = getSwapHash(
601             _sender, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash
602         );
603         return swaps[swapHash];
604     }
605 
606     /**
607      * Calculates the swap hash used to reference the swap in this contract's storage.
608      */
609     function getSwapHash(
610         address _sender,
611         address _receiver,
612         address _oracle,
613         bytes32 assetHash,
614         bytes32 _paymentDetailsHash
615     ) internal pure returns (bytes32 hash) {
616         return keccak256(
617             abi.encodePacked(
618                 _sender, _receiver, _oracle, assetHash, _paymentDetailsHash
619             )
620         );
621     }
622 
623     /**
624      * Returns the EIP712 typed hash for the struct:
625      * EIP712<Type>Swap {
626      *   action: bytes32;
627      *   sender: address;
628      *   receiver: address;
629      *   asset: asset data struct, see `getAssetTypedHash` in specific AssetAdapter contracts
630      *   paymentDetailsHash: bytes32;
631      * }
632      */
633     function getClaimTypedHash(
634         address _sender,
635         address _receiver,
636         bytes memory _assetData,
637         bytes32 _paymentDetailsHash
638     ) internal view returns(bytes32 msgHash) {
639         bytes32 dataHash = keccak256(
640             abi.encode(
641                 EIP712_SWAP_TYPEHASH,
642                 bytes32("claim this swap"),
643                 _sender,
644                 _receiver,
645                 getAssetTypedHash(_assetData),
646                 _paymentDetailsHash
647             )
648         );
649         return keccak256(abi.encodePacked(bytes2(0x1901), EIP712_DOMAIN_HASH, dataHash));
650     }
651 
652     function requireSwapNotExists(bytes32 swapHash) internal view {
653         require(swaps[swapHash] == 0, "swap already exists");
654     }
655 
656     function requireSwapUnclaimed(bytes32 swapHash) internal view {
657         require(swaps[swapHash] == SWAP_UNCLAIMED, "swap already claimed or invalid");
658     }
659 
660     function requireSwapClaimed(bytes32 swapHash) internal view {
661         require(swaps[swapHash] > MIN_ACTUAL_TIMESTAMP, "swap unclaimed or invalid");
662     }
663 
664     function requireSwapUnclaimedOrExpired(bytes32 swapHash) internal view {
665         require(
666             // solium-disable-next-line security/no-block-members
667             (swaps[swapHash] > MIN_ACTUAL_TIMESTAMP && block.timestamp > swaps[swapHash]) ||
668                 swaps[swapHash] == SWAP_UNCLAIMED,
669             "swap not expired or invalid"
670         );
671     }
672 
673 }
674 
675 
676 /**
677  * Ramp Swaps contract with the ERC20 token asset adapter.
678  *
679  * @author Ramp Network sp. z o.o.
680  */
681 contract TokenRampSwaps is AbstractRampSwaps, TokenAdapter {
682     constructor(uint256 _chainId) public AbstractRampSwaps(_chainId) {}
683 }