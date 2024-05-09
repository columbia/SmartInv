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
23 interface Erc20Token {
24 
25     /**
26      * Send `_value` of tokens from `msg.sender` to `_to`
27      *
28      * @param _to The recipient address
29      * @param _value The amount of tokens to be transferred
30      * @return Indication if the transfer was successful
31      */
32     function transfer(address _to, uint256 _value) external returns (bool success);
33 
34     /**
35      * Approve `_spender` to withdraw from sender's account multiple times, up to `_value`
36      * amount. If this function is called again it overwrites the current allowance with _value.
37      *
38      * @param _spender The address allowed to operate on sender's tokens
39      * @param _value The amount of tokens allowed to be transferred
40      * @return Indication if the approval was successful
41      */
42     function approve(address _spender, uint256 _value) external returns (bool success);
43 
44     /**
45      * Transfer tokens on behalf of `_from`, provided it was previously approved.
46      *
47      * @param _from The transfer source address (tokens owner)
48      * @param _to The transfer destination address
49      * @param _value The amount of tokens to be transferred
50      * @return Indication if the approval was successful
51      */
52     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
53 
54     /**
55      * Returns the account balance of another account with address `_owner`.
56      */
57     function balanceOf(address _owner) external view returns (uint256);
58 
59 }
60 
61 contract AssetAdapter {
62 
63     uint16 public ASSET_TYPE;
64 
65     constructor(
66         uint16 assetType
67     ) internal {
68         ASSET_TYPE = assetType;
69     }
70 
71     /**
72      * Ensure the described asset is sent to the given address.
73      * Should revert if the transfer failed, but callers must also handle `false` being returned,
74      * much like ERC-20's `transfer`.
75      */
76     function rawSendAsset(
77         bytes memory assetData,
78         uint256 _amount,
79         address payable _to
80     ) internal returns (bool success);  // solium-disable-line indentation
81     // indentation rule bug ^ https://github.com/duaraghav8/Ethlint/issues/268
82 
83     /**
84      * Ensure the described asset is sent to this contract.
85      * Should revert if the transfer failed, but callers must also handle `false` being returned,
86      * much like ERC-20's `transfer`.
87      */
88     function rawLockAsset(
89         uint256 amount,
90         address payable _from
91     ) internal returns (bool success) {
92         return RampInstantPoolInterface(_from).sendFundsToSwap(amount);
93     }
94 
95     function getAmount(bytes memory assetData) internal pure returns (uint256);
96 
97     /**
98      * Verify that the passed asset data can be handled by this adapter and given pool.
99      *
100      * @dev it's sufficient to use this only when creating a new swap -- all the other swap
101      * functions first check if the swap hash is valid, while a swap hash with invalid
102      * asset type wouldn't be created at all.
103      *
104      * @dev asset type is 2 bytes long, and it's at offset 32 in `assetData`'s memory (the first 32
105      * bytes are the data length). We load the word at offset 2 (it ends with the asset type bytes),
106      * and retrieve its last 2 bytes into a `uint16` variable.
107      */
108     modifier checkAssetTypeAndData(bytes memory assetData, address _pool) {
109         uint16 assetType;
110         // solium-disable-next-line security/no-inline-assembly
111         assembly {
112             assetType := and(
113                 mload(add(assetData, 2)),
114                 0xffff
115             )
116         }
117         require(assetType == ASSET_TYPE, "invalid asset type");
118         checkAssetData(assetData, _pool);
119         _;
120     }
121 
122     function checkAssetData(bytes memory assetData, address _pool) internal view;
123 
124     function () external payable {
125         revert("this contract cannot receive ether");
126     }
127 
128 }
129 
130 contract RampInstantPoolInterface {
131 
132     uint16 public ASSET_TYPE;
133 
134     function sendFundsToSwap(uint256 _amount)
135         public /*onlyActive onlySwapsContract isWithinLimits*/ returns(bool success);
136 
137 }
138 
139 contract RampInstantTokenPoolInterface is RampInstantPoolInterface {
140 
141     address public token;
142 
143 }
144 
145 contract Ownable {
146 
147     address public owner;
148 
149     event OwnerChanged(address oldOwner, address newOwner);
150 
151     constructor() internal {
152         owner = msg.sender;
153     }
154 
155     modifier onlyOwner() {
156         require(msg.sender == owner, "only the owner can call this");
157         _;
158     }
159 
160     function changeOwner(address _newOwner) external onlyOwner {
161         owner = _newOwner;
162         emit OwnerChanged(msg.sender, _newOwner);
163     }
164 
165 }
166 
167 contract WithStatus is Ownable {
168 
169     enum Status {
170         STOPPED,
171         RETURN_ONLY,
172         FINALIZE_ONLY,
173         ACTIVE
174     }
175 
176     event StatusChanged(Status oldStatus, Status newStatus);
177 
178     Status public status = Status.ACTIVE;
179 
180     function setStatus(Status _status) external onlyOwner {
181         emit StatusChanged(status, _status);
182         status = _status;
183     }
184 
185     modifier statusAtLeast(Status _status) {
186         require(status >= _status, "invalid contract status");
187         _;
188     }
189 
190 }
191 
192 contract WithOracles is Ownable {
193 
194     mapping (address => bool) oracles;
195 
196     constructor() internal {
197         oracles[msg.sender] = true;
198     }
199 
200     function approveOracle(address _oracle) external onlyOwner {
201         oracles[_oracle] = true;
202     }
203 
204     function revokeOracle(address _oracle) external onlyOwner {
205         oracles[_oracle] = false;
206     }
207 
208     modifier isOracle(address _oracle) {
209         require(oracles[_oracle], "invalid oracle address");
210         _;
211     }
212 
213     modifier onlyOracleOrPool(address _pool, address _oracle) {
214         require(
215             msg.sender == _pool || (msg.sender == _oracle && oracles[msg.sender]),
216             "only the oracle or the pool can call this"
217         );
218         _;
219     }
220 
221 }
222 
223 contract WithSwapsCreator is Ownable {
224 
225     address internal swapCreator;
226 
227     event SwapCreatorChanged(address _oldCreator, address _newCreator);
228 
229     constructor() internal {
230         swapCreator = msg.sender;
231     }
232 
233     function changeSwapCreator(address _newCreator) public onlyOwner {
234         swapCreator = _newCreator;
235         emit SwapCreatorChanged(msg.sender, _newCreator);
236     }
237 
238     modifier onlySwapCreator() {
239         require(msg.sender == swapCreator, "only the swap creator can call this");
240         _;
241     }
242 
243 }
244 
245 contract AssetAdapterWithFees is Ownable, AssetAdapter {
246 
247     uint16 public feeThousandthsPercent;
248     uint256 public minFeeAmount;
249 
250     constructor(uint16 _feeThousandthsPercent, uint256 _minFeeAmount) public {
251         require(_feeThousandthsPercent < (1 << 16), "fee % too high");
252         require(_minFeeAmount <= (1 << 255), "minFeeAmount too high");
253         feeThousandthsPercent = _feeThousandthsPercent;
254         minFeeAmount = _minFeeAmount;
255     }
256 
257     function rawAccumulateFee(bytes memory assetData, uint256 _amount) internal;
258 
259     function accumulateFee(bytes memory assetData) internal {
260         rawAccumulateFee(assetData, getFee(getAmount(assetData)));
261     }
262 
263     function withdrawFees(
264         bytes calldata assetData,
265         address payable _to
266     ) external /*onlyOwner*/ returns (bool success);  // solium-disable-line indentation
267 
268     function getFee(uint256 _amount) internal view returns (uint256) {
269         uint256 fee = _amount * feeThousandthsPercent / 100000;
270         return fee < minFeeAmount
271             ? minFeeAmount
272             : fee;
273     }
274 
275     function getAmountWithFee(bytes memory assetData) internal view returns (uint256) {
276         uint256 baseAmount = getAmount(assetData);
277         return baseAmount + getFee(baseAmount);
278     }
279 
280     function lockAssetWithFee(
281         bytes memory assetData,
282         address payable _from
283     ) internal returns (bool success) {
284         return rawLockAsset(getAmountWithFee(assetData), _from);
285     }
286 
287     function sendAssetWithFee(
288         bytes memory assetData,
289         address payable _to
290     ) internal returns (bool success) {
291         return rawSendAsset(assetData, getAmountWithFee(assetData), _to);
292     }
293 
294     function sendAssetKeepingFee(
295         bytes memory assetData,
296         address payable _to
297     ) internal returns (bool success) {
298         bool result = rawSendAsset(assetData, getAmount(assetData), _to);
299         if (result) accumulateFee(assetData);
300         return result;
301     }
302 
303 }
304 
305 /**
306  * The main contract managing Ramp Swaps escrows lifecycle: create, release or return.
307  * Uses an abstract AssetAdapter to carry out the transfers and handle the particular asset data.
308  * With a corresponding off-chain oracle protocol allows for atomic-swap-like transfer between
309  * fiat currencies and crypto assets.
310  *
311  * @dev an active swap is represented by a hash of its details, mapped to its escrow expiration
312  * timestamp. When the swap is created, its end time is set a given amount of time in the future
313  * (but within {MIN,MAX}_SWAP_LOCK_TIME_S).
314  * The hashed swap details are:
315  *  * address pool: the `RampInstantPool` contract that sells the crypto asset;
316  *  * address receiver: the user that buys the crypto asset;
317  *  * address oracle: address of the oracle that handles this particular swap;
318  *  * bytes assetData: description of the crypto asset, handled by an AssetAdapter;
319  *  * bytes32 paymentDetailsHash: hash of the fiat payment details: account numbers, fiat value
320  *    and currency, and the transfer reference (title), that can be verified off-chain.
321  *
322  * @author Ramp Network sp. z o.o.
323  */
324 contract RampInstantEscrows
325 is Ownable, WithStatus, WithOracles, WithSwapsCreator, AssetAdapterWithFees {
326 
327     /// @dev contract version, defined in semver
328     string public constant VERSION = "0.5.1";
329 
330     uint32 internal constant MIN_ACTUAL_TIMESTAMP = 1000000000;
331 
332     /// @notice lock time limits for pool's assets, after which unreleased escrows can be returned
333     uint32 internal constant MIN_SWAP_LOCK_TIME_S = 24 hours;
334     uint32 internal constant MAX_SWAP_LOCK_TIME_S = 30 days;
335 
336     event Created(bytes32 indexed swapHash);
337     event Released(bytes32 indexed swapHash);
338     event PoolReleased(bytes32 indexed swapHash);
339     event Returned(bytes32 indexed swapHash);
340     event PoolReturned(bytes32 indexed swapHash);
341 
342     /**
343      * @notice Mapping from swap details hash to its end time (as a unix timestamp).
344      * After the end time the swap can be cancelled, and the funds will be returned to the pool.
345      */
346     mapping (bytes32 => uint32) internal swaps;
347 
348     /**
349      * Swap creation, called by the Ramp Network. Checks swap parameters and ensures the crypto
350      * asset is locked on this contract.
351      *
352      * Emits a `Created` event with the swap hash.
353      */
354     function create(
355         address payable _pool,
356         address _receiver,
357         address _oracle,
358         bytes calldata _assetData,
359         bytes32 _paymentDetailsHash,
360         uint32 lockTimeS
361     )
362         external
363         statusAtLeast(Status.ACTIVE)
364         onlySwapCreator()
365         isOracle(_oracle)
366         checkAssetTypeAndData(_assetData, _pool)
367         returns
368         (bool success)
369     {
370         require(
371             lockTimeS >= MIN_SWAP_LOCK_TIME_S && lockTimeS <= MAX_SWAP_LOCK_TIME_S,
372             "lock time outside limits"
373         );
374         bytes32 swapHash = getSwapHash(
375             _pool, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash
376         );
377         requireSwapNotExists(swapHash);
378         // Set up swap status before transfer, to avoid reentrancy attacks.
379         // Even if a malicious token is somehow passed to this function (despite the oracle
380         // signature of its details), the state of this contract is already fully updated,
381         // so it will behave correctly (as it would be a separate call).
382         // solium-disable-next-line security/no-block-members
383         swaps[swapHash] = uint32(block.timestamp) + lockTimeS;
384         require(
385             lockAssetWithFee(_assetData, _pool),
386             "escrow lock failed"
387         );
388         emit Created(swapHash);
389         return true;
390     }
391 
392     /**
393      * Swap release, which transfers the crypto asset to the receiver and removes the swap from
394      * the active swap mapping. Normally called by the swap's oracle after it confirms a matching
395      * wire transfer on pool's bank account. Can be also called by the pool, for example in case
396      * of a dispute, when the parties reach an agreement off-chain.
397      *
398      * Emits a `Released` or `PoolReleased` event with the swap's hash.
399      */
400     function release(
401         address _pool,
402         address payable _receiver,
403         address _oracle,
404         bytes calldata _assetData,
405         bytes32 _paymentDetailsHash
406     ) external statusAtLeast(Status.FINALIZE_ONLY) onlyOracleOrPool(_pool, _oracle) {
407         bytes32 swapHash = getSwapHash(
408             _pool, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash
409         );
410         requireSwapCreated(swapHash);
411         // Delete the swap status before transfer, to avoid reentrancy attacks.
412         swaps[swapHash] = 0;
413         require(
414             sendAssetKeepingFee(_assetData, _receiver),
415             "asset release failed"
416         );
417         if (msg.sender == _pool) {
418             emit PoolReleased(swapHash);
419         } else {
420             emit Released(swapHash);
421         }
422     }
423 
424     /**
425      * Swap return, which transfers the crypto asset back to the pool and removes the swap from
426      * the active swap mapping. Can be called by the pool or the swap's oracle, but only if the
427      * escrow lock time expired.
428      *
429      * Emits a `Returned` or `PoolReturned` event with the swap's hash.
430      */
431     function returnFunds(
432         address payable _pool,
433         address _receiver,
434         address _oracle,
435         bytes calldata _assetData,
436         bytes32 _paymentDetailsHash
437     ) external statusAtLeast(Status.RETURN_ONLY) onlyOracleOrPool(_pool, _oracle) {
438         bytes32 swapHash = getSwapHash(
439             _pool, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash
440         );
441         requireSwapExpired(swapHash);
442         // Delete the swap status before transfer, to avoid reentrancy attacks.
443         swaps[swapHash] = 0;
444         require(
445             sendAssetWithFee(_assetData, _pool),
446             "asset return failed"
447         );
448         if (msg.sender == _pool) {
449             emit PoolReturned(swapHash);
450         } else {
451             emit Returned(swapHash);
452         }
453     }
454 
455     /**
456      * Given all valid swap details, returns its status. The return can be:
457      * 0: the swap details are invalid, swap doesn't exist, or was already released/returned.
458      * >1: the swap was created, and the value is a timestamp indicating end of its lock time.
459      */
460     function getSwapStatus(
461         address _pool,
462         address _receiver,
463         address _oracle,
464         bytes calldata _assetData,
465         bytes32 _paymentDetailsHash
466     ) external view returns (uint32 status) {
467         bytes32 swapHash = getSwapHash(
468             _pool, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash
469         );
470         return swaps[swapHash];
471     }
472 
473     /**
474      * Calculates the swap hash used to reference the swap in this contract's storage.
475      */
476     function getSwapHash(
477         address _pool,
478         address _receiver,
479         address _oracle,
480         bytes32 assetHash,
481         bytes32 _paymentDetailsHash
482     ) internal pure returns (bytes32) {
483         return keccak256(
484             abi.encodePacked(
485                 _pool, _receiver, _oracle, assetHash, _paymentDetailsHash
486             )
487         );
488     }
489 
490     function requireSwapNotExists(bytes32 swapHash) internal view {
491         require(
492             swaps[swapHash] == 0,
493             "swap already exists"
494         );
495     }
496 
497     function requireSwapCreated(bytes32 swapHash) internal view {
498         require(
499             swaps[swapHash] > MIN_ACTUAL_TIMESTAMP,
500             "swap invalid"
501         );
502     }
503 
504     function requireSwapExpired(bytes32 swapHash) internal view {
505         require(
506             // solium-disable-next-line security/no-block-members
507             swaps[swapHash] > MIN_ACTUAL_TIMESTAMP && block.timestamp > swaps[swapHash],
508             "swap not expired or invalid"
509         );
510     }
511 
512 }
513 
514 contract TokenAdapter is AssetAdapterWithFees {
515 
516     uint16 internal constant TOKEN_TYPE_ID = 2;
517     uint16 internal constant TOKEN_ASSET_DATA_LENGTH = 54;
518     mapping (address => uint256) internal accumulatedFees;
519 
520     constructor() internal AssetAdapter(TOKEN_TYPE_ID) {}
521 
522     /**
523     * @dev token assetData bytes contents:
524     * offset length type     contents
525     * +00    32     uint256  data length (== 0x36 == 54 bytes)
526     * +32     2     uint16   asset type  (== TOKEN_TYPE_ID == 2)
527     * +34    32     uint256  token amount in units
528     * +66    20     address  token contract address
529     */
530     function getAmount(bytes memory assetData) internal pure returns (uint256 amount) {
531         // solium-disable-next-line security/no-inline-assembly
532         assembly {
533             amount := mload(add(assetData, 34))
534         }
535     }
536 
537     /**
538      * @dev To retrieve the address at offset 66, get the word at offset 54 and return its last
539      * 20 bytes. See `getAmount` for byte offsets table.
540      */
541     function getTokenAddress(bytes memory assetData) internal pure returns (address tokenAddress) {
542         // solium-disable-next-line security/no-inline-assembly
543         assembly {
544             tokenAddress := and(
545                 mload(add(assetData, 54)),
546                 0xffffffffffffffffffffffffffffffffffffffff
547             )
548         }
549     }
550 
551     function rawSendAsset(
552         bytes memory assetData,
553         uint256 _amount,
554         address payable _to
555     ) internal returns (bool success) {
556         Erc20Token token = Erc20Token(getTokenAddress(assetData));
557         return token.transfer(_to, _amount);
558     }
559 
560     function rawAccumulateFee(bytes memory assetData, uint256 _amount) internal {
561         accumulatedFees[getTokenAddress(assetData)] += _amount;
562     }
563 
564     function withdrawFees(
565         bytes calldata assetData,
566         address payable _to
567     ) external onlyOwner returns (bool success) {
568         address token = getTokenAddress(assetData);
569         uint256 fees = accumulatedFees[token];
570         accumulatedFees[token] = 0;
571         require(Erc20Token(token).transfer(_to, fees), "fees transfer failed");
572         return true;
573     }
574 
575     function checkAssetData(bytes memory assetData, address _pool) internal view {
576         require(assetData.length == TOKEN_ASSET_DATA_LENGTH, "invalid asset data length");
577         require(
578             RampInstantTokenPoolInterface(_pool).token() == getTokenAddress(assetData),
579             "invalid pool token address"
580         );
581     }
582 
583 }
584 
585 contract RampInstantTokenEscrows is RampInstantEscrows, TokenAdapter {
586 
587     constructor(
588         uint16 _feeThousandthsPercent,
589         uint256 _minFeeAmount
590     ) public AssetAdapterWithFees(_feeThousandthsPercent, _minFeeAmount) {}
591 
592 }