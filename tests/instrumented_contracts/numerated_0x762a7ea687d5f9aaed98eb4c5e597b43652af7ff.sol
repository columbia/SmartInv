1 pragma solidity 0.5.10;
2 
3 /**
4  * Copyright © 2017-2019 Ramp Network sp. z o.o. All rights reserved (MIT License).
5  *
6  * Permission is hereby granted, free of charge, to any person obtaining a copy of this software
7  * and associated documentation files (the "Software"), to deal in the Software without restriction,
8  * including without limitation the rights to use, copy, modify, merge, publish, distribute,
9  * sublicense, and/or sell copies of the Software, and to permit persons to whom the Software
10  * is furnished to do so, subject to the following conditions:
11  *
12  * The above copyright notice and this permission notice shall be included in all copies
13  * or substantial portions of the Software.
14  *
15  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
16  * BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
17  * AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
18  * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
19  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
20  */
21 
22 
23 contract AssetAdapter {
24 
25     uint16 public ASSET_TYPE;
26 
27     constructor(
28         uint16 assetType
29     ) internal {
30         ASSET_TYPE = assetType;
31     }
32 
33     /**
34      * Ensure the described asset is sent to the given address.
35      * Should revert if the transfer failed, but callers must also handle `false` being returned,
36      * much like ERC-20's `transfer`.
37      */
38     function rawSendAsset(
39         bytes memory assetData,
40         uint256 _amount,
41         address payable _to
42     ) internal returns (bool success);  // solium-disable-line indentation
43     // indentation rule bug ^ https://github.com/duaraghav8/Ethlint/issues/268
44 
45     /**
46      * Ensure the described asset is sent to this contract.
47      * Should revert if the transfer failed, but callers must also handle `false` being returned,
48      * much like ERC-20's `transfer`.
49      */
50     function rawLockAsset(
51         uint256 amount,
52         address payable _from
53     ) internal returns (bool success) {
54         return RampInstantPoolInterface(_from).sendFundsToSwap(amount);
55     }
56 
57     function getAmount(bytes memory assetData) internal pure returns (uint256);
58 
59     /**
60      * Verify that the passed asset data can be handled by this adapter and given pool.
61      *
62      * @dev it's sufficient to use this only when creating a new swap -- all the other swap
63      * functions first check if the swap hash is valid, while a swap hash with invalid
64      * asset type wouldn't be created at all.
65      *
66      * @dev asset type is 2 bytes long, and it's at offset 32 in `assetData`'s memory (the first 32
67      * bytes are the data length). We load the word at offset 2 (it ends with the asset type bytes),
68      * and retrieve its last 2 bytes into a `uint16` variable.
69      */
70     modifier checkAssetTypeAndData(bytes memory assetData, address _pool) {
71         uint16 assetType;
72         // solium-disable-next-line security/no-inline-assembly
73         assembly {
74             assetType := and(
75                 mload(add(assetData, 2)),
76                 0xffff
77             )
78         }
79         require(assetType == ASSET_TYPE, "invalid asset type");
80         checkAssetData(assetData, _pool);
81         _;
82     }
83 
84     function checkAssetData(bytes memory assetData, address _pool) internal view;
85 
86     function () external payable {
87         revert("this contract cannot receive ether");
88     }
89 
90 }
91 
92 contract RampInstantPoolInterface {
93 
94     uint16 public ASSET_TYPE;
95 
96     function sendFundsToSwap(uint256 _amount)
97         public /*onlyActive onlySwapsContract isWithinLimits*/ returns(bool success);
98 
99 }
100 
101 contract Ownable {
102 
103     address public owner;
104 
105     event OwnerChanged(address oldOwner, address newOwner);
106 
107     constructor() internal {
108         owner = msg.sender;
109     }
110 
111     modifier onlyOwner() {
112         require(msg.sender == owner, "only the owner can call this");
113         _;
114     }
115 
116     function changeOwner(address _newOwner) external onlyOwner {
117         owner = _newOwner;
118         emit OwnerChanged(msg.sender, _newOwner);
119     }
120 
121 }
122 
123 contract WithStatus is Ownable {
124 
125     enum Status {
126         STOPPED,
127         RETURN_ONLY,
128         FINALIZE_ONLY,
129         ACTIVE
130     }
131 
132     event StatusChanged(Status oldStatus, Status newStatus);
133 
134     Status public status = Status.ACTIVE;
135 
136     function setStatus(Status _status) external onlyOwner {
137         emit StatusChanged(status, _status);
138         status = _status;
139     }
140 
141     modifier statusAtLeast(Status _status) {
142         require(status >= _status, "invalid contract status");
143         _;
144     }
145 
146 }
147 
148 contract WithOracles is Ownable {
149 
150     mapping (address => bool) oracles;
151 
152     constructor() internal {
153         oracles[msg.sender] = true;
154     }
155 
156     function approveOracle(address _oracle) external onlyOwner {
157         oracles[_oracle] = true;
158     }
159 
160     function revokeOracle(address _oracle) external onlyOwner {
161         oracles[_oracle] = false;
162     }
163 
164     modifier isOracle(address _oracle) {
165         require(oracles[_oracle], "invalid oracle address");
166         _;
167     }
168 
169     modifier onlyOracleOrPool(address _pool, address _oracle) {
170         require(
171             msg.sender == _pool || (msg.sender == _oracle && oracles[msg.sender]),
172             "only the oracle or the pool can call this"
173         );
174         _;
175     }
176 
177 }
178 
179 contract WithSwapsCreator is Ownable {
180 
181     address internal swapCreator;
182 
183     event SwapCreatorChanged(address _oldCreator, address _newCreator);
184 
185     constructor() internal {
186         swapCreator = msg.sender;
187     }
188 
189     function changeSwapCreator(address _newCreator) public onlyOwner {
190         swapCreator = _newCreator;
191         emit SwapCreatorChanged(msg.sender, _newCreator);
192     }
193 
194     modifier onlySwapCreator() {
195         require(msg.sender == swapCreator, "only the swap creator can call this");
196         _;
197     }
198 
199 }
200 
201 contract AssetAdapterWithFees is Ownable, AssetAdapter {
202 
203     uint16 public feeThousandthsPercent;
204     uint256 public minFeeAmount;
205 
206     constructor(uint16 _feeThousandthsPercent, uint256 _minFeeAmount) public {
207         require(_feeThousandthsPercent < (1 << 16), "fee % too high");
208         require(_minFeeAmount <= (1 << 255), "minFeeAmount too high");
209         feeThousandthsPercent = _feeThousandthsPercent;
210         minFeeAmount = _minFeeAmount;
211     }
212 
213     function rawAccumulateFee(bytes memory assetData, uint256 _amount) internal;
214 
215     function accumulateFee(bytes memory assetData) internal {
216         rawAccumulateFee(assetData, getFee(getAmount(assetData)));
217     }
218 
219     function withdrawFees(
220         bytes calldata assetData,
221         address payable _to
222     ) external /*onlyOwner*/ returns (bool success);  // solium-disable-line indentation
223 
224     function getFee(uint256 _amount) internal view returns (uint256) {
225         uint256 fee = _amount * feeThousandthsPercent / 100000;
226         return fee < minFeeAmount
227             ? minFeeAmount
228             : fee;
229     }
230 
231     function getAmountWithFee(bytes memory assetData) internal view returns (uint256) {
232         uint256 baseAmount = getAmount(assetData);
233         return baseAmount + getFee(baseAmount);
234     }
235 
236     function lockAssetWithFee(
237         bytes memory assetData,
238         address payable _from
239     ) internal returns (bool success) {
240         return rawLockAsset(getAmountWithFee(assetData), _from);
241     }
242 
243     function sendAssetWithFee(
244         bytes memory assetData,
245         address payable _to
246     ) internal returns (bool success) {
247         return rawSendAsset(assetData, getAmountWithFee(assetData), _to);
248     }
249 
250     function sendAssetKeepingFee(
251         bytes memory assetData,
252         address payable _to
253     ) internal returns (bool success) {
254         bool result = rawSendAsset(assetData, getAmount(assetData), _to);
255         if (result) accumulateFee(assetData);
256         return result;
257     }
258 
259 }
260 
261 /**
262  * The main contract managing Ramp Swaps escrows lifecycle: create, release or return.
263  * Uses an abstract AssetAdapter to carry out the transfers and handle the particular asset data.
264  * With a corresponding off-chain oracle protocol allows for atomic-swap-like transfer between
265  * fiat currencies and crypto assets.
266  *
267  * @dev an active swap is represented by a hash of its details, mapped to its escrow expiration
268  * timestamp. When the swap is created, its end time is set a given amount of time in the future
269  * (but within {MIN,MAX}_SWAP_LOCK_TIME_S).
270  * The hashed swap details are:
271  *  * address pool: the `RampInstantPool` contract that sells the crypto asset;
272  *  * address receiver: the user that buys the crypto asset;
273  *  * address oracle: address of the oracle that handles this particular swap;
274  *  * bytes assetData: description of the crypto asset, handled by an AssetAdapter;
275  *  * bytes32 paymentDetailsHash: hash of the fiat payment details: account numbers, fiat value
276  *    and currency, and the transfer reference (title), that can be verified off-chain.
277  *
278  * @author Ramp Network sp. z o.o.
279  */
280 contract RampInstantEscrows
281 is Ownable, WithStatus, WithOracles, WithSwapsCreator, AssetAdapterWithFees {
282 
283     /// @dev contract version, defined in semver
284     string public constant VERSION = "0.5.1";
285 
286     uint32 internal constant MIN_ACTUAL_TIMESTAMP = 1000000000;
287 
288     /// @notice lock time limits for pool's assets, after which unreleased escrows can be returned
289     uint32 internal constant MIN_SWAP_LOCK_TIME_S = 24 hours;
290     uint32 internal constant MAX_SWAP_LOCK_TIME_S = 30 days;
291 
292     event Created(bytes32 indexed swapHash);
293     event Released(bytes32 indexed swapHash);
294     event PoolReleased(bytes32 indexed swapHash);
295     event Returned(bytes32 indexed swapHash);
296     event PoolReturned(bytes32 indexed swapHash);
297 
298     /**
299      * @notice Mapping from swap details hash to its end time (as a unix timestamp).
300      * After the end time the swap can be cancelled, and the funds will be returned to the pool.
301      */
302     mapping (bytes32 => uint32) internal swaps;
303 
304     /**
305      * Swap creation, called by the Ramp Network. Checks swap parameters and ensures the crypto
306      * asset is locked on this contract.
307      *
308      * Emits a `Created` event with the swap hash.
309      */
310     function create(
311         address payable _pool,
312         address _receiver,
313         address _oracle,
314         bytes calldata _assetData,
315         bytes32 _paymentDetailsHash,
316         uint32 lockTimeS
317     )
318         external
319         statusAtLeast(Status.ACTIVE)
320         onlySwapCreator()
321         isOracle(_oracle)
322         checkAssetTypeAndData(_assetData, _pool)
323         returns
324         (bool success)
325     {
326         require(
327             lockTimeS >= MIN_SWAP_LOCK_TIME_S && lockTimeS <= MAX_SWAP_LOCK_TIME_S,
328             "lock time outside limits"
329         );
330         bytes32 swapHash = getSwapHash(
331             _pool, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash
332         );
333         requireSwapNotExists(swapHash);
334         // Set up swap status before transfer, to avoid reentrancy attacks.
335         // Even if a malicious token is somehow passed to this function (despite the oracle
336         // signature of its details), the state of this contract is already fully updated,
337         // so it will behave correctly (as it would be a separate call).
338         // solium-disable-next-line security/no-block-members
339         swaps[swapHash] = uint32(block.timestamp) + lockTimeS;
340         require(
341             lockAssetWithFee(_assetData, _pool),
342             "escrow lock failed"
343         );
344         emit Created(swapHash);
345         return true;
346     }
347 
348     /**
349      * Swap release, which transfers the crypto asset to the receiver and removes the swap from
350      * the active swap mapping. Normally called by the swap's oracle after it confirms a matching
351      * wire transfer on pool's bank account. Can be also called by the pool, for example in case
352      * of a dispute, when the parties reach an agreement off-chain.
353      *
354      * Emits a `Released` or `PoolReleased` event with the swap's hash.
355      */
356     function release(
357         address _pool,
358         address payable _receiver,
359         address _oracle,
360         bytes calldata _assetData,
361         bytes32 _paymentDetailsHash
362     ) external statusAtLeast(Status.FINALIZE_ONLY) onlyOracleOrPool(_pool, _oracle) {
363         bytes32 swapHash = getSwapHash(
364             _pool, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash
365         );
366         requireSwapCreated(swapHash);
367         // Delete the swap status before transfer, to avoid reentrancy attacks.
368         swaps[swapHash] = 0;
369         require(
370             sendAssetKeepingFee(_assetData, _receiver),
371             "asset release failed"
372         );
373         if (msg.sender == _pool) {
374             emit PoolReleased(swapHash);
375         } else {
376             emit Released(swapHash);
377         }
378     }
379 
380     /**
381      * Swap return, which transfers the crypto asset back to the pool and removes the swap from
382      * the active swap mapping. Can be called by the pool or the swap's oracle, but only if the
383      * escrow lock time expired.
384      *
385      * Emits a `Returned` or `PoolReturned` event with the swap's hash.
386      */
387     function returnFunds(
388         address payable _pool,
389         address _receiver,
390         address _oracle,
391         bytes calldata _assetData,
392         bytes32 _paymentDetailsHash
393     ) external statusAtLeast(Status.RETURN_ONLY) onlyOracleOrPool(_pool, _oracle) {
394         bytes32 swapHash = getSwapHash(
395             _pool, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash
396         );
397         requireSwapExpired(swapHash);
398         // Delete the swap status before transfer, to avoid reentrancy attacks.
399         swaps[swapHash] = 0;
400         require(
401             sendAssetWithFee(_assetData, _pool),
402             "asset return failed"
403         );
404         if (msg.sender == _pool) {
405             emit PoolReturned(swapHash);
406         } else {
407             emit Returned(swapHash);
408         }
409     }
410 
411     /**
412      * Given all valid swap details, returns its status. The return can be:
413      * 0: the swap details are invalid, swap doesn't exist, or was already released/returned.
414      * >1: the swap was created, and the value is a timestamp indicating end of its lock time.
415      */
416     function getSwapStatus(
417         address _pool,
418         address _receiver,
419         address _oracle,
420         bytes calldata _assetData,
421         bytes32 _paymentDetailsHash
422     ) external view returns (uint32 status) {
423         bytes32 swapHash = getSwapHash(
424             _pool, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash
425         );
426         return swaps[swapHash];
427     }
428 
429     /**
430      * Calculates the swap hash used to reference the swap in this contract's storage.
431      */
432     function getSwapHash(
433         address _pool,
434         address _receiver,
435         address _oracle,
436         bytes32 assetHash,
437         bytes32 _paymentDetailsHash
438     ) internal pure returns (bytes32) {
439         return keccak256(
440             abi.encodePacked(
441                 _pool, _receiver, _oracle, assetHash, _paymentDetailsHash
442             )
443         );
444     }
445 
446     function requireSwapNotExists(bytes32 swapHash) internal view {
447         require(
448             swaps[swapHash] == 0,
449             "swap already exists"
450         );
451     }
452 
453     function requireSwapCreated(bytes32 swapHash) internal view {
454         require(
455             swaps[swapHash] > MIN_ACTUAL_TIMESTAMP,
456             "swap invalid"
457         );
458     }
459 
460     function requireSwapExpired(bytes32 swapHash) internal view {
461         require(
462             // solium-disable-next-line security/no-block-members
463             swaps[swapHash] > MIN_ACTUAL_TIMESTAMP && block.timestamp > swaps[swapHash],
464             "swap not expired or invalid"
465         );
466     }
467 
468 }
469 
470 contract EthAdapter is AssetAdapterWithFees {
471 
472     uint16 internal constant ETH_TYPE_ID = 1;
473     uint16 internal constant ETH_ASSET_DATA_LENGTH = 34;
474     uint256 internal accumulatedFees = 0;
475 
476     constructor() internal AssetAdapter(ETH_TYPE_ID) {}
477 
478     /**
479     * @dev eth assetData bytes contents:
480     * offset length type     contents
481     * +00    32     uint256  data length (== 0x22 == 34 bytes)
482     * +32     2     uint16   asset type  (== ETH_TYPE_ID == 1)
483     * +34    32     uint256  ether amount in wei
484     */
485     function getAmount(bytes memory assetData) internal pure returns (uint256 amount) {
486         // solium-disable-next-line security/no-inline-assembly
487         assembly {
488             amount := mload(add(assetData, 34))
489         }
490     }
491 
492     function rawSendAsset(
493         bytes memory /*assetData*/,
494         uint256 _amount,
495         address payable _to
496     ) internal returns (bool success) {
497         // To enable more complex purchase receiver contracts, we're using `call.value(...)` instead
498         // of plain `transfer(...)`, which allows only 2300 gas to be used by the fallback function.
499         // This works for transfers to plain accounts too, no need to check if it's a contract.
500         // solium-disable-next-line security/no-call-value
501         (bool transferSuccessful,) = _to.call.value(_amount)("");
502         require(transferSuccessful, "eth transfer failed");
503         return true;
504     }
505 
506     function rawAccumulateFee(bytes memory /*assetData*/, uint256 _amount) internal {
507         accumulatedFees += _amount;
508     }
509 
510     function withdrawFees(
511         bytes calldata /*assetData*/,
512         address payable _to
513     ) external onlyOwner returns (bool success) {
514         uint256 fees = accumulatedFees;
515         accumulatedFees = 0;
516         _to.transfer(fees);
517         return true;
518     }
519 
520     /**
521      * This adapter can receive eth payments, but no other use of the fallback function is allowed.
522      */
523     function () external payable {
524         require(msg.data.length == 0, "invalid method called");
525     }
526 
527     function checkAssetData(bytes memory assetData, address /*_pool*/) internal view {
528         require(assetData.length == ETH_ASSET_DATA_LENGTH, "invalid asset data length");
529     }
530 
531 }
532 
533 contract RampInstantEthEscrows is RampInstantEscrows, EthAdapter {
534 
535     constructor(
536         uint16 _feeThousandthsPercent,
537         uint256 _minFeeAmount
538     ) public AssetAdapterWithFees(_feeThousandthsPercent, _minFeeAmount) {}
539 
540 }