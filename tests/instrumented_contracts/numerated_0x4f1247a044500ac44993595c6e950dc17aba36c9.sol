1 pragma solidity 0.7.0;
2 // SPDX-License-Identifier: MIT
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
25  * Abstract class for an asset adapter -- a class handling a binary asset description,
26  * encapsulating the asset-specific transfer logic, to maintain a single interface for the main
27  * escrows contract, regardless of asset type.
28  * The `assetData` bytes represent a tightly packed struct, consisting of a 2-byte (uint16) asset
29  * type, followed by asset-specific data. For now there are 2 asset types, ETH and ERC-20 tokens.
30  * The asset type bytes must be equal to the `ASSET_TYPE` constant in each subclass.
31  *
32  * @dev Subclasses of this class are used as mixins to their respective main escrows contract.
33  *
34  * @author Ramp Network sp. z o.o.
35  */
36 abstract contract AssetAdapter {
37 
38     uint16 public immutable ASSET_TYPE;  // solhint-disable-line var-name-mixedcase
39 
40     constructor(
41         uint16 assetType
42     ) {
43         ASSET_TYPE = assetType;
44     }
45 
46     /**
47      * Ensure the described asset is sent to the given address.
48      * Should revert if the transfer failed, but callers must also handle `false` being returned,
49      * much like ERC-20's `transfer`.
50      */
51     function rawSendAsset(
52         bytes memory assetData,
53         uint256 _amount,
54         address payable _to
55     ) internal virtual returns (bool success);
56 
57     /**
58      * Ensure the described asset is sent to this contract.
59      * Should revert if the transfer failed, but callers must also handle `false` being returned,
60      * much like ERC-20's `transfer`.
61      */
62     function rawLockAsset(
63         uint256 amount,
64         address payable _from
65     ) internal returns (bool success) {
66         return RampInstantPoolInterface(_from).sendFundsToSwap(amount);
67     }
68 
69     function getAmount(bytes memory assetData) internal virtual pure returns (uint256);
70 
71     /**
72      * Verify that the passed asset data can be handled by this adapter and given pool.
73      *
74      * @dev it's sufficient to use this only when creating a new swap -- all the other swap
75      * functions first check if the swap hash is valid, while a swap hash with invalid
76      * asset type wouldn't be created at all.
77      *
78      * @dev asset type is 2 bytes long, and it's at offset 32 in `assetData`'s memory (the first 32
79      * bytes are the data length). We load the word at offset 2 (it ends with the asset type bytes),
80      * and retrieve its last 2 bytes into a `uint16` variable.
81      */
82     modifier checkAssetTypeAndData(bytes memory assetData, address _pool) {
83         uint16 assetType;
84         // solhint-disable-next-line no-inline-assembly
85         assembly {
86             assetType := and(
87                 mload(add(assetData, 2)),
88                 0xffff
89             )
90         }
91         require(assetType == ASSET_TYPE, "iat");  // "invalid asset type"
92         checkAssetData(assetData, _pool);
93         _;
94     }
95 
96     function checkAssetData(bytes memory assetData, address _pool) internal virtual view;
97 
98 }
99 
100 /**
101  * A simple interface used by the escrows contract (precisely AssetAdapters) to interact
102  * with the liquidity pools.
103  */
104 abstract contract RampInstantPoolInterface {
105 
106     uint16 public ASSET_TYPE;  // solhint-disable-line var-name-mixedcase
107 
108     function sendFundsToSwap(uint256 _amount)
109         public virtual /*onlyActive onlySwapsContract isWithinLimits*/ returns(bool success);
110 
111 }
112 
113 /**
114  * A standard, simple transferrable contract ownership.
115  */
116 abstract contract Ownable {
117 
118     address public owner;
119 
120     event OwnerChanged(address oldOwner, address newOwner);
121 
122     constructor() {
123         owner = msg.sender;
124     }
125 
126     modifier onlyOwner() {
127         require(msg.sender == owner, "ooc");  // "only the owner can call this"
128         _;
129     }
130 
131     function changeOwner(address _newOwner) external onlyOwner {
132         owner = _newOwner;
133         emit OwnerChanged(msg.sender, _newOwner);
134     }
135 
136 }
137 
138 /**
139  * An extended version of the standard `Pausable` contract, with more possible statuses:
140  *  * STOPPED: all swap actions cannot be executed until the status is changed,
141  *  * RETURN_ONLY: the existing swaps can only be returned, no new swaps can be created;
142  *  * FINALIZE_ONLY: the existing swaps can be released or returned, no new swaps can be created;
143  *  * ACTIVE: all swap actions can be executed.
144  *
145  * @dev the status enum is strictly monotonic (i.e. all actions allowed on status X are allowed on
146  * status X+1) and the default 0 is mapped to STOPPED for safety.
147  */
148 abstract contract WithStatus is Ownable {
149 
150     enum Status {
151         STOPPED,
152         RETURN_ONLY,
153         FINALIZE_ONLY,
154         ACTIVE
155     }
156 
157     event StatusChanged(Status oldStatus, Status newStatus);
158 
159     Status public status = Status.ACTIVE;
160 
161     function setStatus(Status _status) external onlyOwner {
162         emit StatusChanged(status, _status);
163         status = _status;
164     }
165 
166     modifier statusAtLeast(Status _status) {
167         require(status >= _status, "ics");  // "invalid contract status"
168         _;
169     }
170 
171 }
172 
173 
174 /**
175  * An owner-managed list of oracles, that are allowed to release or return swaps.
176  * The deployer is the default only oracle.
177  */
178 abstract contract WithOracles is Ownable {
179 
180     mapping (address => bool) internal oracles;
181 
182     constructor() {
183         oracles[msg.sender] = true;
184     }
185 
186     function approveOracle(address _oracle) external onlyOwner {
187         oracles[_oracle] = true;
188     }
189 
190     function revokeOracle(address _oracle) external onlyOwner {
191         oracles[_oracle] = false;
192     }
193 
194     modifier isOracle(address _oracle) {
195         require(oracles[_oracle], "ioa");  // invalid oracle address"
196         _;
197     }
198 
199     modifier onlyOracleOrPool(address _pool, address _oracle) {
200         require(
201             msg.sender == _pool || (msg.sender == _oracle && oracles[msg.sender]),
202             "oop"  // "only the oracle or the pool can call this"
203         );
204         _;
205     }
206 
207 }
208 
209 
210 /**
211  * An owner-managed address that is allowed to create new swaps.
212  */
213 abstract contract WithSwapsCreators is Ownable {
214 
215     mapping (address => bool) internal creators;
216 
217     constructor() {
218         creators[msg.sender] = true;
219     }
220 
221     function approveSwapCreator(address _creator) external onlyOwner {
222         creators[_creator] = true;
223     }
224 
225     function revokeSwapCreator(address _creator) external onlyOwner {
226         creators[_creator] = false;
227     }
228 
229     modifier onlySwapCreator() {
230         require(creators[msg.sender], "osc");  // "only the swap creator can call this"
231         _;
232     }
233 
234 }
235 
236 /**
237  * An extension of `AssetAdapter` that encapsulates collecting Ramp fees while locking and resolving
238  * an escrow. The collected fees can be withdrawn by the contract owner.
239  *
240  * Fees are configured dynamically by the backend and encoded in `assetData`. The fee amount is
241  * also hashed into the swapHash, so a swap is guaranteed to be released/returned with the same fee
242  * it was created with.
243  *
244  * @author Ramp Network sp. z o.o.
245  */
246 abstract contract AssetAdapterWithFees is Ownable, AssetAdapter {
247 
248     function accumulateFee(bytes memory assetData) internal virtual;
249 
250     function withdrawFees(
251         bytes calldata assetData,
252         address payable _to
253     ) external virtual /*onlyOwner*/ returns (bool success);
254 
255     function getFee(bytes memory assetData) internal virtual pure returns (uint256);
256 
257     function getAmountWithFee(bytes memory assetData) internal pure returns (uint256) {
258         return getAmount(assetData) + getFee(assetData);
259     }
260 
261     function lockAssetWithFee(
262         bytes memory assetData,
263         address payable _from
264     ) internal returns (bool success) {
265         return rawLockAsset(getAmountWithFee(assetData), _from);
266     }
267 
268     function sendAssetWithFee(
269         bytes memory assetData,
270         address payable _to
271     ) internal returns (bool success) {
272         return rawSendAsset(assetData, getAmountWithFee(assetData), _to);
273     }
274 
275     function sendAssetKeepingFee(
276         bytes memory assetData,
277         address payable _to
278     ) internal returns (bool success) {
279         bool result = rawSendAsset(assetData, getAmount(assetData), _to);
280         if (result) accumulateFee(assetData);
281         return result;
282     }
283 
284     function getAccumulatedFees(address _assetAddress) public virtual view returns (uint256);
285 
286 }
287 
288 /**
289  * The main contract managing Ramp Swaps escrows lifecycle: create, release or return.
290  * Uses an abstract AssetAdapter to carry out the transfers and handle the particular asset data.
291  * With a corresponding off-chain oracle protocol allows for atomic-swap-like transfer between
292  * fiat currencies and crypto assets.
293  *
294  * @dev an active swap is represented by a hash of its details, mapped to its escrow expiration
295  * timestamp. When the swap is created, its end time is set a given amount of time in the future
296  * (but within {MIN,MAX}_SWAP_LOCK_TIME_S).
297  * The hashed swap details are:
298  *  * address pool: the `RampInstantPool` contract that sells the crypto asset;
299  *  * address receiver: the user that buys the crypto asset;
300  *  * address oracle: address of the oracle that handles this particular swap;
301  *  * bytes assetData: description of the crypto asset, handled by an AssetAdapter;
302  *  * bytes32 paymentDetailsHash: hash of the fiat payment details: account numbers, fiat value
303  *    and currency, and the transfer reference (title), that can be verified off-chain.
304  *
305  * @author Ramp Network sp. z o.o.
306  */
307 abstract contract RampInstantEscrows
308 is Ownable, WithStatus, WithOracles, WithSwapsCreators, AssetAdapterWithFees {
309 
310     /// @dev contract version, defined in semver
311     string public constant VERSION = "0.6.4";
312 
313     uint32 internal constant MIN_ACTUAL_TIMESTAMP = 1000000000;
314 
315     /// @dev lock time limits for pool's assets, after which unreleased escrows can be returned
316     uint32 internal constant MIN_SWAP_LOCK_TIME_S = 24 hours;
317     uint32 internal constant MAX_SWAP_LOCK_TIME_S = 30 days;
318 
319     event Created(bytes32 indexed swapHash);
320     event Released(bytes32 indexed swapHash);
321     event PoolReleased(bytes32 indexed swapHash);
322     event Returned(bytes32 indexed swapHash);
323     event PoolReturned(bytes32 indexed swapHash);
324 
325     /**
326      * @dev Mapping from swap details hash to its end time (as a unix timestamp).
327      * After the end time the swap can be cancelled, and the funds will be returned to the pool.
328      */
329     mapping (bytes32 => uint32) internal swaps;
330 
331     /**
332      * Swap creation, called by the Ramp Network. Checks swap parameters and ensures the crypto
333      * asset is locked on this contract.
334      *
335      * Emits a `Created` event with the swap hash.
336      */
337     function create(
338         address payable _pool,
339         address _receiver,
340         address _oracle,
341         bytes calldata _assetData,
342         bytes32 _paymentDetailsHash,
343         uint32 lockTimeS
344     )
345         external
346         statusAtLeast(Status.ACTIVE)
347         onlySwapCreator()
348         isOracle(_oracle)
349         checkAssetTypeAndData(_assetData, _pool)
350         returns
351         (bool success)
352     {
353         require(
354             lockTimeS >= MIN_SWAP_LOCK_TIME_S && lockTimeS <= MAX_SWAP_LOCK_TIME_S,
355             "ltl"  // "lock time outside limits"
356         );
357         bytes32 swapHash = getSwapHash(
358             _pool, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash
359         );
360         requireSwapNotExists(swapHash);
361         // Set up swap status before transfer, to avoid reentrancy attacks.
362         // Even if a malicious token is somehow passed to this function (despite the oracle
363         // signature of its details), the state of this contract is already fully updated,
364         // so it will behave correctly (as it would be a separate call).
365         // solhint-disable-next-line not-rely-on-time
366         swaps[swapHash] = uint32(block.timestamp) + lockTimeS;
367         require(
368             lockAssetWithFee(_assetData, _pool),
369             "elf"  // "escrow lock failed"
370         );
371         emit Created(swapHash);
372         return true;
373     }
374 
375     /**
376      * Swap release, which transfers the crypto asset to the receiver and removes the swap from
377      * the active swap mapping. Normally called by the swap's oracle after it confirms a matching
378      * wire transfer on pool's bank account. Can be also called by the pool, for example in case
379      * of a dispute, when the parties reach an agreement off-chain.
380      *
381      * Emits a `Released` or `PoolReleased` event with the swap's hash.
382      */
383     function release(
384         address _pool,
385         address payable _receiver,
386         address _oracle,
387         bytes calldata _assetData,
388         bytes32 _paymentDetailsHash
389     ) external statusAtLeast(Status.FINALIZE_ONLY) onlyOracleOrPool(_pool, _oracle) {
390         bytes32 swapHash = getSwapHash(
391             _pool, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash
392         );
393         requireSwapCreated(swapHash);
394         // Delete the swap status before transfer, to avoid reentrancy attacks.
395         swaps[swapHash] = 0;
396         require(
397             sendAssetKeepingFee(_assetData, _receiver),
398             "arf"  // "asset release failed"
399         );
400         if (msg.sender == _pool) {
401             emit PoolReleased(swapHash);
402         } else {
403             emit Released(swapHash);
404         }
405     }
406 
407     /**
408      * Swap return, which transfers the crypto asset back to the pool and removes the swap from
409      * the active swap mapping. Can be called by the pool or the swap's oracle, but only if the
410      * escrow lock time expired.
411      *
412      * Emits a `Returned` or `PoolReturned` event with the swap's hash.
413      */
414     function returnFunds(
415         address payable _pool,
416         address _receiver,
417         address _oracle,
418         bytes calldata _assetData,
419         bytes32 _paymentDetailsHash
420     ) external statusAtLeast(Status.RETURN_ONLY) onlyOracleOrPool(_pool, _oracle) {
421         bytes32 swapHash = getSwapHash(
422             _pool, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash
423         );
424         requireSwapExpired(swapHash);
425         // Delete the swap status before transfer, to avoid reentrancy attacks.
426         swaps[swapHash] = 0;
427         require(
428             sendAssetWithFee(_assetData, _pool),
429             "acf"  // "asset return failed"
430         );
431         if (msg.sender == _pool) {
432             emit PoolReturned(swapHash);
433         } else {
434             emit Returned(swapHash);
435         }
436     }
437 
438     /**
439      * Given all valid swap details, returns its status. The return can be:
440      * 0: the swap details are invalid, swap doesn't exist, or was already released/returned.
441      * >1: the swap was created, and the value is a timestamp indicating end of its lock time.
442      */
443     function getSwapStatus(
444         address _pool,
445         address _receiver,
446         address _oracle,
447         bytes calldata _assetData,
448         bytes32 _paymentDetailsHash
449     ) external view returns (uint32 status) {
450         bytes32 swapHash = getSwapHash(
451             _pool, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash
452         );
453         return swaps[swapHash];
454     }
455 
456     /**
457      * Calculates the swap hash used to reference the swap in this contract's storage.
458      */
459     function getSwapHash(
460         address _pool,
461         address _receiver,
462         address _oracle,
463         bytes32 assetHash,
464         bytes32 _paymentDetailsHash
465     ) internal pure returns (bytes32) {
466         return keccak256(
467             abi.encodePacked(
468                 _pool, _receiver, _oracle, assetHash, _paymentDetailsHash
469             )
470         );
471     }
472 
473     function requireSwapNotExists(bytes32 swapHash) internal view {
474         require(
475             swaps[swapHash] == 0,
476             "sae"  // "swap already exists"
477         );
478     }
479 
480     function requireSwapCreated(bytes32 swapHash) internal view {
481         require(
482             swaps[swapHash] > MIN_ACTUAL_TIMESTAMP,
483             "siv"  // "swap invalid"
484         );
485     }
486 
487     function requireSwapExpired(bytes32 swapHash) internal view {
488         require(
489             // solhint-disable-next-line not-rely-on-time
490             swaps[swapHash] > MIN_ACTUAL_TIMESTAMP && block.timestamp > swaps[swapHash],
491             "sei"  // "swap not expired or invalid"
492         );
493     }
494 
495 }
496 
497 /**
498  * An adapter for handling ether assets.
499  *
500  * @author Ramp Network sp. z o.o.
501  */
502 abstract contract EthAdapter is AssetAdapterWithFees {
503 
504     uint16 internal constant ETH_TYPE_ID = 1;
505     uint16 internal constant ETH_ASSET_DATA_LENGTH = 66;
506     uint256 internal accumulatedFees = 0;
507 
508     constructor() AssetAdapter(ETH_TYPE_ID) {}
509 
510     /**
511     * @dev extract the amount from the asset data bytes. ETH assetData bytes contents:
512     * offset length type     contents
513     * +00    32     uint256  data length (== 0x22 == 34 bytes)
514     * +32     2     uint16   asset type  (== ETH_TYPE_ID == 1)
515     * +34    32     uint256  ether amount in wei
516     * +66    32     uint256  ether fee in wei
517     */
518     function getAmount(bytes memory assetData) internal override pure returns (uint256 amount) {
519         // solhint-disable-next-line no-inline-assembly
520         assembly {
521             amount := mload(add(assetData, 34))
522         }
523     }
524 
525     /**
526      * @dev extract the fee from the asset data bytes. See getAmount for bytes contents.
527      */
528     function getFee(bytes memory assetData) internal override pure returns (uint256 fee) {
529         // solhint-disable-next-line no-inline-assembly
530         assembly {
531             fee := mload(add(assetData, 66))
532         }
533     }
534 
535     function rawSendAsset(
536         bytes memory /*assetData*/,
537         uint256 _amount,
538         address payable _to
539     ) internal override returns (bool success) {
540         // To enable more complex purchase receiver contracts, we're using `call.value(...)` instead
541         // of plain `transfer(...)`, which allows only 2300 gas to be used by the fallback function.
542         // This works for transfers to plain accounts too, no need to check if it's a contract.
543         // solhint-disable-next-line avoid-low-level-calls
544         (bool transferSuccessful,) = _to.call{ value:_amount }("");
545         require(transferSuccessful, "etf");  // "eth transfer failed"
546         return true;
547     }
548 
549     function accumulateFee(bytes memory assetData) internal override {
550         accumulatedFees += getFee(assetData);
551     }
552 
553     function withdrawFees(
554         bytes calldata /*assetData*/,
555         address payable _to
556     ) external override onlyOwner returns (bool success) {
557         uint256 fees = accumulatedFees;
558         accumulatedFees = 0;
559         _to.transfer(fees);
560         return true;
561     }
562 
563     /**
564      * This adapter can receive eth payments, but no other use of the fallback function is allowed.
565      * @dev this is the "receive ether" fallback function, split off from the regular fallback
566      * function in Solidity 0.6
567      */
568     receive () external payable {}
569 
570     function checkAssetData(bytes memory assetData, address /*_pool*/) internal override pure {
571         require(assetData.length == ETH_ASSET_DATA_LENGTH, "adl");  // "invalid asset data length"
572     }
573 
574     function getAccumulatedFees(address /*_assetAddress*/) public override view returns (uint256) {
575         return accumulatedFees;
576     }
577 
578 }
579 
580 
581 /**
582  * Ramp Swaps contract with the ether asset adapter.
583  *
584  * @author Ramp Network sp. z o.o.
585  */
586 contract RampInstantEthEscrows is RampInstantEscrows, EthAdapter {}