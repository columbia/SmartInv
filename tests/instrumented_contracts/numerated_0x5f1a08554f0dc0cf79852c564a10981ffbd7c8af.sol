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
108  * An adapter for handling ether swaps.
109  *
110  * @author Ramp Network sp. z o.o.
111  */
112 contract EthAdapter is AssetAdapter {
113 
114     uint16 internal constant ETH_TYPE_ID = 1;
115 
116     // the hashes are generated using `genTypeHashes` from `eip712.swaps`
117     constructor() internal AssetAdapter(
118         ETH_TYPE_ID,
119         0x3f5e83ffc9f619035e6bbc5b772db010a6ea49213f31e8a5d137b6cebf8d19c7,
120         0x4edc3bd27f6cb13e1f0e97fa9dd936fa2dc988debb1378354f49e2bb59be435e
121     ) {}
122 
123     /**
124     * @dev byte offsets, byte length & contents for ether asset data:
125     * +00  32  uint256  data length (== 0x22 == 34 bytes)
126     * +32   2  uint16   asset type  (== 1)
127     * +34  32  uint256  ether amount in wei
128     */
129     function getAmount(bytes memory assetData) internal pure returns (uint256 amount) {
130         // solium-disable-next-line security/no-inline-assembly
131         assembly {
132             amount := mload(add(assetData, 34))
133         }
134     }
135 
136     function sendAssetTo(
137         bytes memory assetData, address payable _to
138     ) internal returns (bool success) {
139         _to.transfer(getAmount(assetData));  // always throws on failure
140         return true;
141     }
142 
143     function lockAssetFrom(
144         bytes memory assetData, address _from
145     ) internal returns (bool success) {
146         require(msg.sender == _from, "invalid ether sender");
147         require(msg.value == getAmount(assetData), "invalid ether amount sent");
148         return true;
149     }
150 
151     /**
152      * Returns the EIP712 hash of the eth asset data struct:
153      * EIP712EthAsset {
154      *    ethAmount: uint256;
155      * }
156      */
157     function getAssetTypedHash(bytes memory data) internal view returns (bytes32) {
158         return keccak256(
159             abi.encode(
160                 EIP712_ASSET_TYPEHASH,
161                 getAmount(data)
162             )
163         );
164     }
165 
166 }
167 
168 
169 contract Ownable {
170 
171     address public owner;
172 
173     constructor() internal {
174         owner = msg.sender;
175     }
176 
177     modifier onlyOwner() {
178         require(msg.sender == owner, "only the owner can call this");
179         _;
180     }
181 
182 }
183 
184 
185 /**
186  * An extended version of the standard `Pausable` contract, with more possible statuses:
187  *  * STOPPED: all swap actions cannot be executed until the status is changed,
188  *  * RETURN_ONLY: the existing swaps can only be returned, no new swaps can be created;
189  *  * FINALIZE_ONLY: the existing swaps can be released or returned, no new swaps can be created;
190  *  * ACTIVE: all swap actions can be executed.
191  *
192  * @dev the status enum is strictly monotonic, and the default 0 is mapped to STOPPED for safety.
193  */
194 contract WithStatus is Ownable {
195 
196     enum Status {
197         STOPPED,
198         RETURN_ONLY,
199         FINALIZE_ONLY,
200         ACTIVE
201     }
202 
203     event StatusChanged(Status oldStatus, Status newStatus);
204 
205     Status public status = Status.ACTIVE;
206 
207     constructor() internal {}
208 
209     function setStatus(Status _status) external onlyOwner {
210         emit StatusChanged(status, _status);
211         status = _status;
212     }
213 
214     modifier statusAtLeast(Status _status) {
215         require(status >= _status, "invalid contract status");
216         _;
217     }
218 
219 }
220 
221 
222 /**
223  * An owner-managed list of oracles, that are allowed to claim, release or return swaps.
224  */
225 contract WithOracles is Ownable {
226 
227     mapping (address => bool) oracles;
228 
229     /**
230      * The deployer is the default oracle.
231      */
232     constructor() internal {
233         oracles[msg.sender] = true;
234     }
235 
236     function approveOracle(address _oracle) external onlyOwner {
237         oracles[_oracle] = true;
238     }
239 
240     function revokeOracle(address _oracle) external onlyOwner {
241         oracles[_oracle] = false;
242     }
243 
244     modifier isOracle(address _oracle) {
245         require(oracles[_oracle], "invalid oracle address");
246         _;
247     }
248 
249     modifier onlyOracle(address _oracle) {
250         require(
251             msg.sender == _oracle && oracles[msg.sender],
252             "only the oracle can call this"
253         );
254         _;
255     }
256 
257     modifier onlyOracleOrSender(address _sender, address _oracle) {
258         require(
259             msg.sender == _sender || (msg.sender == _oracle && oracles[msg.sender]),
260             "only the oracle or the sender can call this"
261         );
262         _;
263     }
264 
265     modifier onlySender(address _sender) {
266         require(msg.sender == _sender, "only the sender can call this");
267         _;
268     }
269 
270 }
271 
272 
273 /**
274  * The main contract managing Ramp Swaps escrows lifecycle: create, claim, release and return.
275  * Uses an abstract AssetAdapter to carry out the transfers and handle the particular asset data.
276  * With a corresponding off-chain protocol allows for atomic-swap-like transfer between
277  * fiat currencies and crypto assets.
278  *
279  * @dev an active swap is represented by a hash of its details, mapped to its escrow expiration
280  * timestamp. When the swap is created, but not yet claimed, its end time is set to SWAP_UNCLAIMED.
281  * The hashed swap details are:
282  *  * address sender: the swap's creator, that sells the crypto asset;
283  *  * address receiver: the user that buys the crypto asset, `0x0` until the swap is claimed;
284  *  * address oracle: address of the oracle that handles this particular swap;
285  *  * bytes assetData: description of the crypto asset, handled by an AssetAdapter;
286  *  * bytes32 paymentDetailsHash: hash of the fiat payment details: account numbers, fiat value
287  *    and currency, and the transfer reference (title), that can be verified off-chain.
288  *
289  * @author Ramp Network sp. z o.o.
290  */
291 contract AbstractRampSwaps is Ownable, WithStatus, WithOracles, AssetAdapter {
292 
293     /// @dev contract version, defined in semver
294     string public constant VERSION = "0.3.1";
295 
296     /// @dev used as a special swap endTime value, to denote a yet unclaimed swap
297     uint32 internal constant SWAP_UNCLAIMED = 1;
298     uint32 internal constant MIN_ACTUAL_TIMESTAMP = 1000000000;
299 
300     /// @notice how long are sender's funds locked from a claim until he can cancel the swap
301     uint32 internal constant SWAP_LOCK_TIME_S = 3600 * 24 * 7;
302 
303     event Created(bytes32 indexed swapHash);
304     event BuyerSet(bytes32 indexed oldSwapHash, bytes32 indexed newSwapHash);
305     event Claimed(bytes32 indexed oldSwapHash, bytes32 indexed newSwapHash);
306     event Released(bytes32 indexed swapHash);
307     event SenderReleased(bytes32 indexed swapHash);
308     event Returned(bytes32 indexed swapHash);
309     event SenderReturned(bytes32 indexed swapHash);
310 
311     /**
312      * @notice Mapping from swap details hash to its end time (as a unix timestamp).
313      * After the end time the swap can be cancelled, and the funds will be returned to the sender.
314      * Value `(SWAP_UNCLAIMED)` is used to denote that a swap exists, but has not yet been claimed
315      * by any receiver, and can also be cancelled until that.
316      */
317     mapping (bytes32 => uint32) internal swaps;
318 
319     /**
320      * @dev EIP712 type hash for the struct:
321      * EIP712Domain {
322      *   name: string;
323      *   version: string;
324      *   chainId: uint256;
325      *   verifyingContract: address;
326      * }
327      */
328     bytes32 internal constant EIP712_DOMAIN_TYPEHASH = 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;
329     bytes32 internal EIP712_DOMAIN_HASH;
330 
331     constructor(uint256 _chainId) internal {
332         EIP712_DOMAIN_HASH = keccak256(
333             abi.encode(
334                 EIP712_DOMAIN_TYPEHASH,
335                 keccak256(bytes("RampSwaps")),
336                 keccak256(bytes(VERSION)),
337                 _chainId,
338                 address(this)
339             )
340         );
341     }
342 
343     /**
344      * Swap creation, called by the crypto sender. Checks swap parameters and ensures the crypto
345      * asset is locked on this contract.
346      * Additionally to the swap details, this function takes params v, r, s, which is checked to be
347      * an ECDSA signature of the swap hash made by the oracle -- to prevent users from creating
348      * swaps outside Ramp Network.
349      *
350      * Emits a `Created` event with the swap hash.
351      */
352     function create(
353         address _oracle,
354         bytes calldata _assetData,
355         bytes32 _paymentDetailsHash,
356         uint8 v,
357         bytes32 r,
358         bytes32 s
359     )
360         external
361         payable
362         statusAtLeast(Status.ACTIVE)
363         isOracle(_oracle)
364         checkAssetType(_assetData)
365         returns
366         (bool success)
367     {
368         bytes32 swapHash = getSwapHash(
369             msg.sender, address(0), _oracle, keccak256(_assetData), _paymentDetailsHash
370         );
371         requireSwapNotExists(swapHash);
372         require(ecrecover(swapHash, v, r, s) == _oracle, "invalid swap oracle signature");
373         // Set up swap status before transfer, to avoid reentrancy attacks.
374         // Even if a malicious token is somehow passed to this function (despite the oracle
375         // signature of its details), the state of this contract is already fully updated,
376         // so it will behave correctly (as it would be a separate call).
377         swaps[swapHash] = SWAP_UNCLAIMED;
378         require(
379             lockAssetFrom(_assetData, msg.sender),
380             "failed to lock asset on escrow"
381         );
382         emit Created(swapHash);
383         return true;
384     }
385 
386     /**
387      * Swap claim, called by the swap's oracle on behalf of the receiver, to confirm his interest
388      * in buying the crypto asset.
389      * Additional v, r, s parameters are checked to be the receiver's EIP712 typed data signature
390      * of the swap's details and a 'claim this swap' action -- which verifies the receiver's address
391      * and the authenthicity of his claim request. See `getClaimTypedHash` for description of the
392      * signed swap struct.
393      *
394      * Emits a `Claimed` event with the current swap hash and the new swap hash, updated with
395      * receiver's address. The current swap hash equal to the hash emitted in `create`, unless
396      * `setBuyer` was called in the meantime -- then the current swap hash is equal to the new
397      * swap hash, because the receiver's address was already set.
398      */
399     function claim(
400         address _sender,
401         address _receiver,
402         address _oracle,
403         bytes calldata _assetData,
404         bytes32 _paymentDetailsHash,
405         uint8 v,
406         bytes32 r,
407         bytes32 s
408     ) external statusAtLeast(Status.ACTIVE) onlyOracle(_oracle) {
409         // Verify claim signature
410         bytes32 claimTypedHash = getClaimTypedHash(
411             _sender,
412             _receiver,
413             _assetData,
414             _paymentDetailsHash
415         );
416         require(ecrecover(claimTypedHash, v, r, s) == _receiver, "invalid claim receiver signature");
417         // Verify swap hashes
418         bytes32 oldSwapHash = getSwapHash(
419             _sender, address(0), _oracle, keccak256(_assetData), _paymentDetailsHash
420         );
421         bytes32 newSwapHash = getSwapHash(
422             _sender, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash
423         );
424         bytes32 claimFromHash;
425         // We want this function to be universal, regardless of whether `setBuyer` was called before.
426         // If it was, the hash is already changed
427         if (swaps[oldSwapHash] == 0) {
428             claimFromHash = newSwapHash;
429             requireSwapUnclaimed(newSwapHash);
430         } else {
431             claimFromHash = oldSwapHash;
432             requireSwapUnclaimed(oldSwapHash);
433             requireSwapNotExists(newSwapHash);
434             swaps[oldSwapHash] = 0;
435         }
436         // any overflow security warnings can be safely ignored -- SWAP_LOCK_TIME_S is a small
437         // constant, so this won't overflow an uint32 until year 2106
438         // solium-disable-next-line security/no-block-members
439         swaps[newSwapHash] = uint32(block.timestamp) + SWAP_LOCK_TIME_S;
440         emit Claimed(claimFromHash, newSwapHash);
441     }
442 
443     /**
444      * Swap release, which transfers the crypto asset to the receiver and removes the swap from
445      * the active swap mapping. Normally called by the swap's oracle after it confirms a matching
446      * wire transfer on sender's bank account. Can be also called by the sender, for example in case
447      * of a dispute, when the parties reach an agreement off-chain.
448      *
449      * Emits a `Released` event with the swap's hash.
450      */
451     function release(
452         address _sender,
453         address payable _receiver,
454         address _oracle,
455         bytes calldata _assetData,
456         bytes32 _paymentDetailsHash
457     ) external statusAtLeast(Status.FINALIZE_ONLY) onlyOracleOrSender(_sender, _oracle) {
458         bytes32 swapHash = getSwapHash(
459             _sender, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash
460         );
461         requireSwapClaimed(swapHash);
462         // Delete the swap status before transfer, to avoid reentrancy attacks.
463         swaps[swapHash] = 0;
464         require(
465             sendAssetTo(_assetData, _receiver),
466             "failed to send asset to receiver"
467         );
468         if (msg.sender == _sender) {
469             emit SenderReleased(swapHash);
470         } else {
471             emit Released(swapHash);
472         }
473     }
474 
475     /**
476      * Swap return, which transfers the crypto asset back to the sender and removes the swap from
477      * the active swap mapping. Can be called by the sender or the swap's oracle, but only if the
478      * swap is not claimed, or was claimed but the escrow lock time expired.
479      *
480      * Emits a `Returned` event with the swap's hash.
481      */
482     function returnFunds(
483         address payable _sender,
484         address _receiver,
485         address _oracle,
486         bytes calldata _assetData,
487         bytes32 _paymentDetailsHash
488     ) external statusAtLeast(Status.RETURN_ONLY) onlyOracleOrSender(_sender, _oracle) {
489         bytes32 swapHash = getSwapHash(
490             _sender, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash
491         );
492         requireSwapUnclaimedOrExpired(swapHash);
493         // Delete the swap status before transfer, to avoid reentrancy attacks.
494         swaps[swapHash] = 0;
495         require(
496             sendAssetTo(_assetData, _sender),
497             "failed to send asset to sender"
498         );
499         if (msg.sender == _sender) {
500             emit SenderReturned(swapHash);
501         } else {
502             emit Returned(swapHash);
503         }
504     }
505 
506     /**
507      * After the sender creates a swap, he can optionally call this function to restrict the swap
508      * to a particular receiver address. The swap can't then be claimed by any other receiver.
509      *
510      * Emits a `BuyerSet` event with the created swap hash and new swap hash, updated with
511      * receiver's address.
512      */
513     function setBuyer(
514         address _sender,
515         address _receiver,
516         address _oracle,
517         bytes calldata _assetData,
518         bytes32 _paymentDetailsHash
519     ) external statusAtLeast(Status.ACTIVE) onlySender(_sender) {
520         bytes32 assetHash = keccak256(_assetData);
521         bytes32 oldSwapHash = getSwapHash(
522             _sender, address(0), _oracle, assetHash, _paymentDetailsHash
523         );
524         requireSwapUnclaimed(oldSwapHash);
525         bytes32 newSwapHash = getSwapHash(
526             _sender, _receiver, _oracle, assetHash, _paymentDetailsHash
527         );
528         requireSwapNotExists(newSwapHash);
529         swaps[oldSwapHash] = 0;
530         swaps[newSwapHash] = SWAP_UNCLAIMED;
531         emit BuyerSet(oldSwapHash, newSwapHash);
532     }
533 
534     /**
535      * Given all valid swap details, returns its status. To check a swap with unset buyer,
536      * use `0x0` as the `_receiver` address. The return can be:
537      * 0: the swap details are invalid, swap doesn't exist, or was already released/returned.
538      * 1: the swap was created, and is not claimed yet.
539      * >1: the swap was claimed, and the value is a timestamp indicating end of its lock time.
540      */
541     function getSwapStatus(
542         address _sender,
543         address _receiver,
544         address _oracle,
545         bytes calldata _assetData,
546         bytes32 _paymentDetailsHash
547     ) external view returns (uint32 status) {
548         bytes32 swapHash = getSwapHash(
549             _sender, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash
550         );
551         return swaps[swapHash];
552     }
553 
554     /**
555      * Calculates the swap hash used to reference the swap in this contract's storage.
556      */
557     function getSwapHash(
558         address _sender,
559         address _receiver,
560         address _oracle,
561         bytes32 assetHash,
562         bytes32 _paymentDetailsHash
563     ) internal pure returns (bytes32 hash) {
564         return keccak256(
565             abi.encodePacked(
566                 _sender, _receiver, _oracle, assetHash, _paymentDetailsHash
567             )
568         );
569     }
570 
571     /**
572      * Returns the EIP712 typed hash for the struct:
573      * EIP712<Type>Swap {
574      *   action: bytes32;
575      *   sender: address;
576      *   receiver: address;
577      *   asset: asset data struct, see `getAssetTypedHash` in specific AssetAdapter contracts
578      *   paymentDetailsHash: bytes32;
579      * }
580      */
581     function getClaimTypedHash(
582         address _sender,
583         address _receiver,
584         bytes memory _assetData,
585         bytes32 _paymentDetailsHash
586     ) internal view returns(bytes32 msgHash) {
587         bytes32 dataHash = keccak256(
588             abi.encode(
589                 EIP712_SWAP_TYPEHASH,
590                 bytes32("claim this swap"),
591                 _sender,
592                 _receiver,
593                 getAssetTypedHash(_assetData),
594                 _paymentDetailsHash
595             )
596         );
597         return keccak256(abi.encodePacked(bytes2(0x1901), EIP712_DOMAIN_HASH, dataHash));
598     }
599 
600     function requireSwapNotExists(bytes32 swapHash) internal view {
601         require(swaps[swapHash] == 0, "swap already exists");
602     }
603 
604     function requireSwapUnclaimed(bytes32 swapHash) internal view {
605         require(swaps[swapHash] == SWAP_UNCLAIMED, "swap already claimed or invalid");
606     }
607 
608     function requireSwapClaimed(bytes32 swapHash) internal view {
609         require(swaps[swapHash] > MIN_ACTUAL_TIMESTAMP, "swap unclaimed or invalid");
610     }
611 
612     function requireSwapUnclaimedOrExpired(bytes32 swapHash) internal view {
613         require(
614             // solium-disable-next-line security/no-block-members
615             (swaps[swapHash] > MIN_ACTUAL_TIMESTAMP && block.timestamp > swaps[swapHash]) ||
616                 swaps[swapHash] == SWAP_UNCLAIMED,
617             "swap not expired or invalid"
618         );
619     }
620 
621 }
622 
623 
624 /**
625  * Ramp Swaps contract with the ether asset adapter.
626  *
627  * @author Ramp Network sp. z o.o.
628  */
629 contract EthRampSwaps is AbstractRampSwaps, EthAdapter {
630     constructor(uint256 _chainId) public AbstractRampSwaps(_chainId) {}
631 }