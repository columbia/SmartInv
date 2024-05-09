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
25  * @title partial ERC-20 Token interface according to official documentation:
26  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
27  */
28 interface Erc20Token {
29 
30     /**
31      * Send `_value` of tokens from `msg.sender` to `_to`
32      *
33      * @param _to The recipient address
34      * @param _value The amount of tokens to be transferred
35      * @return success Indication if the transfer was successful
36      */
37     function transfer(address _to, uint256 _value) external returns (bool success);
38 
39     /**
40      * Approve `_spender` to withdraw from sender's account multiple times, up to `_value`
41      * amount. If this function is called again it overwrites the current allowance with _value.
42      *
43      * @param _spender The address allowed to operate on sender's tokens
44      * @param _value The amount of tokens allowed to be transferred
45      * @return success Indication if the approval was successful
46      */
47     function approve(address _spender, uint256 _value) external returns (bool success);
48 
49     /**
50      * Transfer tokens on behalf of `_from`, provided it was previously approved.
51      *
52      * @param _from The transfer source address (tokens owner)
53      * @param _to The transfer destination address
54      * @param _value The amount of tokens to be transferred
55      * @return success Indication if the approval was successful
56      */
57     function transferFrom(
58         address _from,
59         address _to,
60         uint256 _value
61     ) external returns (bool success);
62 
63     /**
64      * Returns the account balance of another account with address `_owner`.
65      */
66     function balanceOf(address _owner) external view returns (uint256);
67 
68     /// OPTIONAL in the standard
69     function decimals() external pure returns (uint8);
70 
71     function allowance(address _owner, address _spender) external view returns (uint256);
72 
73 }
74 
75 /**
76  * Abstract class for an asset adapter -- a class handling a binary asset description,
77  * encapsulating the asset-specific transfer logic, to maintain a single interface for the main
78  * escrows contract, regardless of asset type.
79  * The `assetData` bytes represent a tightly packed struct, consisting of a 2-byte (uint16) asset
80  * type, followed by asset-specific data. For now there are 2 asset types, ETH and ERC-20 tokens.
81  * The asset type bytes must be equal to the `ASSET_TYPE` constant in each subclass.
82  *
83  * @dev Subclasses of this class are used as mixins to their respective main escrows contract.
84  *
85  * @author Ramp Network sp. z o.o.
86  */
87 abstract contract AssetAdapter {
88 
89     uint16 public immutable ASSET_TYPE;  // solhint-disable-line var-name-mixedcase
90 
91     constructor(
92         uint16 assetType
93     ) {
94         ASSET_TYPE = assetType;
95     }
96 
97     /**
98      * Ensure the described asset is sent to the given address.
99      * Should revert if the transfer failed, but callers must also handle `false` being returned,
100      * much like ERC-20's `transfer`.
101      */
102     function rawSendAsset(
103         bytes memory assetData,
104         uint256 _amount,
105         address payable _to
106     ) internal virtual returns (bool success);
107 
108     /**
109      * Ensure the described asset is sent to this contract.
110      * Should revert if the transfer failed, but callers must also handle `false` being returned,
111      * much like ERC-20's `transfer`.
112      */
113     function rawLockAsset(
114         uint256 amount,
115         address payable _from
116     ) internal returns (bool success) {
117         return RampInstantPoolInterface(_from).sendFundsToSwap(amount);
118     }
119 
120     function getAmount(bytes memory assetData) internal virtual pure returns (uint256);
121 
122     /**
123      * Verify that the passed asset data can be handled by this adapter and given pool.
124      *
125      * @dev it's sufficient to use this only when creating a new swap -- all the other swap
126      * functions first check if the swap hash is valid, while a swap hash with invalid
127      * asset type wouldn't be created at all.
128      *
129      * @dev asset type is 2 bytes long, and it's at offset 32 in `assetData`'s memory (the first 32
130      * bytes are the data length). We load the word at offset 2 (it ends with the asset type bytes),
131      * and retrieve its last 2 bytes into a `uint16` variable.
132      */
133     modifier checkAssetTypeAndData(bytes memory assetData, address _pool) {
134         uint16 assetType;
135         // solhint-disable-next-line no-inline-assembly
136         assembly {
137             assetType := and(
138                 mload(add(assetData, 2)),
139                 0xffff
140             )
141         }
142         require(assetType == ASSET_TYPE, "iat");  // "invalid asset type"
143         checkAssetData(assetData, _pool);
144         _;
145     }
146 
147     function checkAssetData(bytes memory assetData, address _pool) internal virtual view;
148 
149 }
150 
151 /**
152  * A simple interface used by the escrows contract (precisely AssetAdapters) to interact
153  * with the liquidity pools.
154  */
155 abstract contract RampInstantPoolInterface {
156 
157     uint16 public ASSET_TYPE;  // solhint-disable-line var-name-mixedcase
158 
159     function sendFundsToSwap(uint256 _amount)
160         public virtual /*onlyActive onlySwapsContract isWithinLimits*/ returns(bool success);
161 
162 }
163 
164 abstract contract RampInstantTokenPoolInterface is RampInstantPoolInterface {
165 
166     address public token;
167 
168 }
169 
170 /**
171  * A standard, simple transferrable contract ownership.
172  */
173 abstract contract Ownable {
174 
175     address public owner;
176 
177     event OwnerChanged(address oldOwner, address newOwner);
178 
179     constructor() {
180         owner = msg.sender;
181     }
182 
183     modifier onlyOwner() {
184         require(msg.sender == owner, "ooc");  // "only the owner can call this"
185         _;
186     }
187 
188     function changeOwner(address _newOwner) external onlyOwner {
189         owner = _newOwner;
190         emit OwnerChanged(msg.sender, _newOwner);
191     }
192 
193 }
194 
195 /**
196  * An extended version of the standard `Pausable` contract, with more possible statuses:
197  *  * STOPPED: all swap actions cannot be executed until the status is changed,
198  *  * RETURN_ONLY: the existing swaps can only be returned, no new swaps can be created;
199  *  * FINALIZE_ONLY: the existing swaps can be released or returned, no new swaps can be created;
200  *  * ACTIVE: all swap actions can be executed.
201  *
202  * @dev the status enum is strictly monotonic (i.e. all actions allowed on status X are allowed on
203  * status X+1) and the default 0 is mapped to STOPPED for safety.
204  */
205 abstract contract WithStatus is Ownable {
206 
207     enum Status {
208         STOPPED,
209         RETURN_ONLY,
210         FINALIZE_ONLY,
211         ACTIVE
212     }
213 
214     event StatusChanged(Status oldStatus, Status newStatus);
215 
216     Status public status = Status.ACTIVE;
217 
218     function setStatus(Status _status) external onlyOwner {
219         emit StatusChanged(status, _status);
220         status = _status;
221     }
222 
223     modifier statusAtLeast(Status _status) {
224         require(status >= _status, "ics");  // "invalid contract status"
225         _;
226     }
227 
228 }
229 
230 
231 /**
232  * An owner-managed list of oracles, that are allowed to release or return swaps.
233  * The deployer is the default only oracle.
234  */
235 abstract contract WithOracles is Ownable {
236 
237     mapping (address => bool) internal oracles;
238 
239     constructor() {
240         oracles[msg.sender] = true;
241     }
242 
243     function approveOracle(address _oracle) external onlyOwner {
244         oracles[_oracle] = true;
245     }
246 
247     function revokeOracle(address _oracle) external onlyOwner {
248         oracles[_oracle] = false;
249     }
250 
251     modifier isOracle(address _oracle) {
252         require(oracles[_oracle], "ioa");  // invalid oracle address"
253         _;
254     }
255 
256     modifier onlyOracleOrPool(address _pool, address _oracle) {
257         require(
258             msg.sender == _pool || (msg.sender == _oracle && oracles[msg.sender]),
259             "oop"  // "only the oracle or the pool can call this"
260         );
261         _;
262     }
263 
264 }
265 
266 
267 /**
268  * An owner-managed address that is allowed to create new swaps.
269  */
270 abstract contract WithSwapsCreators is Ownable {
271 
272     mapping (address => bool) internal creators;
273 
274     constructor() {
275         creators[msg.sender] = true;
276     }
277 
278     function approveSwapCreator(address _creator) external onlyOwner {
279         creators[_creator] = true;
280     }
281 
282     function revokeSwapCreator(address _creator) external onlyOwner {
283         creators[_creator] = false;
284     }
285 
286     modifier onlySwapCreator() {
287         require(creators[msg.sender], "osc");  // "only the swap creator can call this"
288         _;
289     }
290 
291 }
292 
293 /**
294  * An extension of `AssetAdapter` that encapsulates collecting Ramp fees while locking and resolving
295  * an escrow. The collected fees can be withdrawn by the contract owner.
296  *
297  * Fees are configured dynamically by the backend and encoded in `assetData`. The fee amount is
298  * also hashed into the swapHash, so a swap is guaranteed to be released/returned with the same fee
299  * it was created with.
300  *
301  * @author Ramp Network sp. z o.o.
302  */
303 abstract contract AssetAdapterWithFees is Ownable, AssetAdapter {
304 
305     function accumulateFee(bytes memory assetData) internal virtual;
306 
307     function withdrawFees(
308         bytes calldata assetData,
309         address payable _to
310     ) external virtual /*onlyOwner*/ returns (bool success);
311 
312     function getFee(bytes memory assetData) internal virtual pure returns (uint256);
313 
314     function getAmountWithFee(bytes memory assetData) internal pure returns (uint256) {
315         return getAmount(assetData) + getFee(assetData);
316     }
317 
318     function lockAssetWithFee(
319         bytes memory assetData,
320         address payable _from
321     ) internal returns (bool success) {
322         return rawLockAsset(getAmountWithFee(assetData), _from);
323     }
324 
325     function sendAssetWithFee(
326         bytes memory assetData,
327         address payable _to
328     ) internal returns (bool success) {
329         return rawSendAsset(assetData, getAmountWithFee(assetData), _to);
330     }
331 
332     function sendAssetKeepingFee(
333         bytes memory assetData,
334         address payable _to
335     ) internal returns (bool success) {
336         bool result = rawSendAsset(assetData, getAmount(assetData), _to);
337         if (result) accumulateFee(assetData);
338         return result;
339     }
340 
341     function getAccumulatedFees(address _assetAddress) public virtual view returns (uint256);
342 
343 }
344 
345 /**
346  * The main contract managing Ramp Swaps escrows lifecycle: create, release or return.
347  * Uses an abstract AssetAdapter to carry out the transfers and handle the particular asset data.
348  * With a corresponding off-chain oracle protocol allows for atomic-swap-like transfer between
349  * fiat currencies and crypto assets.
350  *
351  * @dev an active swap is represented by a hash of its details, mapped to its escrow expiration
352  * timestamp. When the swap is created, its end time is set a given amount of time in the future
353  * (but within {MIN,MAX}_SWAP_LOCK_TIME_S).
354  * The hashed swap details are:
355  *  * address pool: the `RampInstantPool` contract that sells the crypto asset;
356  *  * address receiver: the user that buys the crypto asset;
357  *  * address oracle: address of the oracle that handles this particular swap;
358  *  * bytes assetData: description of the crypto asset, handled by an AssetAdapter;
359  *  * bytes32 paymentDetailsHash: hash of the fiat payment details: account numbers, fiat value
360  *    and currency, and the transfer reference (title), that can be verified off-chain.
361  *
362  * @author Ramp Network sp. z o.o.
363  */
364 abstract contract RampInstantEscrows
365 is Ownable, WithStatus, WithOracles, WithSwapsCreators, AssetAdapterWithFees {
366 
367     /// @dev contract version, defined in semver
368     string public constant VERSION = "0.6.4";
369 
370     uint32 internal constant MIN_ACTUAL_TIMESTAMP = 1000000000;
371 
372     /// @dev lock time limits for pool's assets, after which unreleased escrows can be returned
373     uint32 internal constant MIN_SWAP_LOCK_TIME_S = 24 hours;
374     uint32 internal constant MAX_SWAP_LOCK_TIME_S = 30 days;
375 
376     event Created(bytes32 indexed swapHash);
377     event Released(bytes32 indexed swapHash);
378     event PoolReleased(bytes32 indexed swapHash);
379     event Returned(bytes32 indexed swapHash);
380     event PoolReturned(bytes32 indexed swapHash);
381 
382     /**
383      * @dev Mapping from swap details hash to its end time (as a unix timestamp).
384      * After the end time the swap can be cancelled, and the funds will be returned to the pool.
385      */
386     mapping (bytes32 => uint32) internal swaps;
387 
388     /**
389      * Swap creation, called by the Ramp Network. Checks swap parameters and ensures the crypto
390      * asset is locked on this contract.
391      *
392      * Emits a `Created` event with the swap hash.
393      */
394     function create(
395         address payable _pool,
396         address _receiver,
397         address _oracle,
398         bytes calldata _assetData,
399         bytes32 _paymentDetailsHash,
400         uint32 lockTimeS
401     )
402         external
403         statusAtLeast(Status.ACTIVE)
404         onlySwapCreator()
405         isOracle(_oracle)
406         checkAssetTypeAndData(_assetData, _pool)
407         returns
408         (bool success)
409     {
410         require(
411             lockTimeS >= MIN_SWAP_LOCK_TIME_S && lockTimeS <= MAX_SWAP_LOCK_TIME_S,
412             "ltl"  // "lock time outside limits"
413         );
414         bytes32 swapHash = getSwapHash(
415             _pool, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash
416         );
417         requireSwapNotExists(swapHash);
418         // Set up swap status before transfer, to avoid reentrancy attacks.
419         // Even if a malicious token is somehow passed to this function (despite the oracle
420         // signature of its details), the state of this contract is already fully updated,
421         // so it will behave correctly (as it would be a separate call).
422         // solhint-disable-next-line not-rely-on-time
423         swaps[swapHash] = uint32(block.timestamp) + lockTimeS;
424         require(
425             lockAssetWithFee(_assetData, _pool),
426             "elf"  // "escrow lock failed"
427         );
428         emit Created(swapHash);
429         return true;
430     }
431 
432     /**
433      * Swap release, which transfers the crypto asset to the receiver and removes the swap from
434      * the active swap mapping. Normally called by the swap's oracle after it confirms a matching
435      * wire transfer on pool's bank account. Can be also called by the pool, for example in case
436      * of a dispute, when the parties reach an agreement off-chain.
437      *
438      * Emits a `Released` or `PoolReleased` event with the swap's hash.
439      */
440     function release(
441         address _pool,
442         address payable _receiver,
443         address _oracle,
444         bytes calldata _assetData,
445         bytes32 _paymentDetailsHash
446     ) external statusAtLeast(Status.FINALIZE_ONLY) onlyOracleOrPool(_pool, _oracle) {
447         bytes32 swapHash = getSwapHash(
448             _pool, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash
449         );
450         requireSwapCreated(swapHash);
451         // Delete the swap status before transfer, to avoid reentrancy attacks.
452         swaps[swapHash] = 0;
453         require(
454             sendAssetKeepingFee(_assetData, _receiver),
455             "arf"  // "asset release failed"
456         );
457         if (msg.sender == _pool) {
458             emit PoolReleased(swapHash);
459         } else {
460             emit Released(swapHash);
461         }
462     }
463 
464     /**
465      * Swap return, which transfers the crypto asset back to the pool and removes the swap from
466      * the active swap mapping. Can be called by the pool or the swap's oracle, but only if the
467      * escrow lock time expired.
468      *
469      * Emits a `Returned` or `PoolReturned` event with the swap's hash.
470      */
471     function returnFunds(
472         address payable _pool,
473         address _receiver,
474         address _oracle,
475         bytes calldata _assetData,
476         bytes32 _paymentDetailsHash
477     ) external statusAtLeast(Status.RETURN_ONLY) onlyOracleOrPool(_pool, _oracle) {
478         bytes32 swapHash = getSwapHash(
479             _pool, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash
480         );
481         requireSwapExpired(swapHash);
482         // Delete the swap status before transfer, to avoid reentrancy attacks.
483         swaps[swapHash] = 0;
484         require(
485             sendAssetWithFee(_assetData, _pool),
486             "acf"  // "asset return failed"
487         );
488         if (msg.sender == _pool) {
489             emit PoolReturned(swapHash);
490         } else {
491             emit Returned(swapHash);
492         }
493     }
494 
495     /**
496      * Given all valid swap details, returns its status. The return can be:
497      * 0: the swap details are invalid, swap doesn't exist, or was already released/returned.
498      * >1: the swap was created, and the value is a timestamp indicating end of its lock time.
499      */
500     function getSwapStatus(
501         address _pool,
502         address _receiver,
503         address _oracle,
504         bytes calldata _assetData,
505         bytes32 _paymentDetailsHash
506     ) external view returns (uint32 status) {
507         bytes32 swapHash = getSwapHash(
508             _pool, _receiver, _oracle, keccak256(_assetData), _paymentDetailsHash
509         );
510         return swaps[swapHash];
511     }
512 
513     /**
514      * Calculates the swap hash used to reference the swap in this contract's storage.
515      */
516     function getSwapHash(
517         address _pool,
518         address _receiver,
519         address _oracle,
520         bytes32 assetHash,
521         bytes32 _paymentDetailsHash
522     ) internal pure returns (bytes32) {
523         return keccak256(
524             abi.encodePacked(
525                 _pool, _receiver, _oracle, assetHash, _paymentDetailsHash
526             )
527         );
528     }
529 
530     function requireSwapNotExists(bytes32 swapHash) internal view {
531         require(
532             swaps[swapHash] == 0,
533             "sae"  // "swap already exists"
534         );
535     }
536 
537     function requireSwapCreated(bytes32 swapHash) internal view {
538         require(
539             swaps[swapHash] > MIN_ACTUAL_TIMESTAMP,
540             "siv"  // "swap invalid"
541         );
542     }
543 
544     function requireSwapExpired(bytes32 swapHash) internal view {
545         require(
546             // solhint-disable-next-line not-rely-on-time
547             swaps[swapHash] > MIN_ACTUAL_TIMESTAMP && block.timestamp > swaps[swapHash],
548             "sei"  // "swap not expired or invalid"
549         );
550     }
551 
552 }
553 
554 /**
555  * @dev a wrapper to call token.transfer, that allows us to be compatible with older tokens
556  * that don't comply with the ERC-20 interface and don't return anything
557  */
558 abstract contract TokenTransferrer {
559 
560     function doTokenTransfer(
561         address _token,
562         address _to,
563         uint256 _amount
564     ) internal returns (bool success) {
565         // selector is bytes4(keccak256("transfer(address,uint256)"))
566         bytes memory callData = abi.encodeWithSelector(bytes4(0xa9059cbb), _to, _amount);
567         // overwrite callData with call results (either the revert reason or return value)
568         // solhint-disable-next-line avoid-low-level-calls
569         (success, callData) = _token.call(callData);
570         // if call failed, revert with the same error (also works with plain revert())
571         require(success, string(callData));
572         // if the call succeeded, check its result data:
573         // * when no data is returned, assume the token reverts on failure, so the
574         //   transfer was successful
575         // * otherwise check the call returned a single nonzero word
576         //   (the value at callData is the offset to the first data byte, hence the add+mload)
577         // solhint-disable-next-line no-inline-assembly
578         assembly {
579             success := or(
580                 iszero(returndatasize()),
581                 and(eq(returndatasize(), 32), gt(mload(add(callData, mload(callData))), 0))
582             )
583         }
584         require(success, "ttf");  // "token transfer failed"
585         return true;
586     }
587 
588 }
589 
590 /**
591  * An adapter for handling ERC-20-based token assets.
592  *
593  * @author Ramp Network sp. z o.o.
594  */
595 abstract contract TokenAdapter is AssetAdapterWithFees, TokenTransferrer {
596 
597     uint16 internal constant TOKEN_TYPE_ID = 2;
598     uint16 internal constant TOKEN_ASSET_DATA_LENGTH = 86;
599     mapping (address => uint256) internal accumulatedFees;
600 
601     constructor() AssetAdapter(TOKEN_TYPE_ID) {}
602 
603     /**
604     * @dev extract the amount from the asset data bytes. Token assetData bytes contents:
605     * offset length type     contents
606     * +00    32     uint256  data length (== 0x36 == 54 bytes)
607     * +32     2     uint16   asset type  (== TOKEN_TYPE_ID == 2)
608     * +34    32     uint256  token amount in units
609     * +66    32     uint256  fee amount in units
610     * +98    20     address  token contract address
611     */
612     function getAmount(bytes memory assetData) internal override pure returns (uint256 amount) {
613         // solhint-disable-next-line no-inline-assembly
614         assembly {
615             amount := mload(add(assetData, 34))
616         }
617     }
618 
619     /**
620      * @dev extract the fee from the asset data bytes. See getAmount for bytes contents.
621      */
622     function getFee(bytes memory assetData) internal override pure returns (uint256 fee) {
623         // solhint-disable-next-line no-inline-assembly
624         assembly {
625             fee := mload(add(assetData, 66))
626         }
627     }
628 
629     /**
630      * @dev To retrieve the address at offset 98, get the word at offset 86 and return its last
631      * 20 bytes. See `getAmount` for byte offsets table.
632      */
633     function getTokenAddress(bytes memory assetData) internal pure returns (address tokenAddress) {
634         // solhint-disable-next-line no-inline-assembly
635         assembly {
636             tokenAddress := and(
637                 mload(add(assetData, 86)),
638                 0xffffffffffffffffffffffffffffffffffffffff
639             )
640         }
641     }
642 
643     function rawSendAsset(
644         bytes memory assetData,
645         uint256 _amount,
646         address payable _to
647     ) internal override returns (bool success) {
648         return doTokenTransfer(getTokenAddress(assetData), _to, _amount);
649     }
650 
651     function accumulateFee(bytes memory assetData) internal override {
652         accumulatedFees[getTokenAddress(assetData)] += getFee(assetData);
653     }
654 
655     function withdrawFees(
656         bytes calldata assetData,
657         address payable _to
658     ) external override onlyOwner returns (bool success) {
659         address token = getTokenAddress(assetData);
660         uint256 fees = accumulatedFees[token];
661         accumulatedFees[token] = 0;
662         return doTokenTransfer(getTokenAddress(assetData), _to, fees);
663     }
664 
665     function checkAssetData(bytes memory assetData, address _pool) internal override view {
666         require(assetData.length == TOKEN_ASSET_DATA_LENGTH, "adl");  // "invalid asset data length"
667         require(
668             RampInstantTokenPoolInterface(_pool).token() == getTokenAddress(assetData),
669             "pta"  // "invalid pool token address"
670         );
671     }
672 
673     function getAccumulatedFees(address _assetAddress) public override view returns (uint256) {
674         return accumulatedFees[_assetAddress];
675     }
676 
677 }
678 
679 /**
680  * Ramp Swaps contract with the ERC-20 token asset adapter.
681  *
682  * @author Ramp Network sp. z o.o.
683  */
684 contract RampInstantTokenEscrows is RampInstantEscrows, TokenAdapter {}