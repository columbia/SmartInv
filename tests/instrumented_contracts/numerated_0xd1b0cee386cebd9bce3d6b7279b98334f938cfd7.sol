1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Trees proofs.
10  *
11  * The proofs can be generated using the JavaScript library
12  * https://github.com/miguelmota/merkletreejs[merkletreejs].
13  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
14  *
15  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
16  *
17  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
18  * hashing, or use a hash function other than keccak256 for hashing leaves.
19  * This is because the concatenation of a sorted pair of internal nodes in
20  * the merkle tree could be reinterpreted as a leaf value.
21  */
22 library MerkleProof {
23     /**
24      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
25      * defined by `root`. For this, a `proof` must be provided, containing
26      * sibling hashes on the branch from the leaf to the root of the tree. Each
27      * pair of leaves and each pair of pre-images are assumed to be sorted.
28      */
29     function verify(
30         bytes32[] memory proof,
31         bytes32 root,
32         bytes32 leaf
33     ) internal pure returns (bool) {
34         return processProof(proof, leaf) == root;
35     }
36 
37     /**
38      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
39      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
40      * hash matches the root of the tree. When processing the proof, the pairs
41      * of leafs & pre-images are assumed to be sorted.
42      *
43      * _Available since v4.4._
44      */
45     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
46         bytes32 computedHash = leaf;
47         for (uint256 i = 0; i < proof.length; i++) {
48             bytes32 proofElement = proof[i];
49             if (computedHash <= proofElement) {
50                 // Hash(current computed hash + current element of the proof)
51                 computedHash = _efficientHash(computedHash, proofElement);
52             } else {
53                 // Hash(current element of the proof + current computed hash)
54                 computedHash = _efficientHash(proofElement, computedHash);
55             }
56         }
57         return computedHash;
58     }
59 
60     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
61         assembly {
62             mstore(0x00, a)
63             mstore(0x20, b)
64             value := keccak256(0x00, 0x40)
65         }
66     }
67 }
68 
69 // File: @openzeppelin/contracts/utils/Strings.sol
70 
71 
72 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev String operations.
78  */
79 library Strings {
80     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
81 
82     /**
83      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
84      */
85     function toString(uint256 value) internal pure returns (string memory) {
86         // Inspired by OraclizeAPI's implementation - MIT licence
87         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
88 
89         if (value == 0) {
90             return "0";
91         }
92         uint256 temp = value;
93         uint256 digits;
94         while (temp != 0) {
95             digits++;
96             temp /= 10;
97         }
98         bytes memory buffer = new bytes(digits);
99         while (value != 0) {
100             digits -= 1;
101             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
102             value /= 10;
103         }
104         return string(buffer);
105     }
106 
107     /**
108      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
109      */
110     function toHexString(uint256 value) internal pure returns (string memory) {
111         if (value == 0) {
112             return "0x00";
113         }
114         uint256 temp = value;
115         uint256 length = 0;
116         while (temp != 0) {
117             length++;
118             temp >>= 8;
119         }
120         return toHexString(value, length);
121     }
122 
123     /**
124      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
125      */
126     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
127         bytes memory buffer = new bytes(2 * length + 2);
128         buffer[0] = "0";
129         buffer[1] = "x";
130         for (uint256 i = 2 * length + 1; i > 1; --i) {
131             buffer[i] = _HEX_SYMBOLS[value & 0xf];
132             value >>= 4;
133         }
134         require(value == 0, "Strings: hex length insufficient");
135         return string(buffer);
136     }
137 }
138 
139 // File: @openzeppelin/contracts/utils/Context.sol
140 
141 
142 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
143 
144 pragma solidity ^0.8.0;
145 
146 /**
147  * @dev Provides information about the current execution context, including the
148  * sender of the transaction and its data. While these are generally available
149  * via msg.sender and msg.data, they should not be accessed in such a direct
150  * manner, since when dealing with meta-transactions the account sending and
151  * paying for execution may not be the actual sender (as far as an application
152  * is concerned).
153  *
154  * This contract is only required for intermediate, library-like contracts.
155  */
156 abstract contract Context {
157     function _msgSender() internal view virtual returns (address) {
158         return msg.sender;
159     }
160 
161     function _msgData() internal view virtual returns (bytes calldata) {
162         return msg.data;
163     }
164 }
165 
166 // File: @openzeppelin/contracts/access/Ownable.sol
167 
168 
169 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
170 
171 pragma solidity ^0.8.0;
172 
173 
174 /**
175  * @dev Contract module which provides a basic access control mechanism, where
176  * there is an account (an owner) that can be granted exclusive access to
177  * specific functions.
178  *
179  * By default, the owner account will be the one that deploys the contract. This
180  * can later be changed with {transferOwnership}.
181  *
182  * This module is used through inheritance. It will make available the modifier
183  * `onlyOwner`, which can be applied to your functions to restrict their use to
184  * the owner.
185  */
186 abstract contract Ownable is Context {
187     address private _owner;
188 
189     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
190 
191     /**
192      * @dev Initializes the contract setting the deployer as the initial owner.
193      */
194     constructor() {
195         _transferOwnership(_msgSender());
196     }
197 
198     /**
199      * @dev Returns the address of the current owner.
200      */
201     function owner() public view virtual returns (address) {
202         return _owner;
203     }
204 
205     /**
206      * @dev Throws if called by any account other than the owner.
207      */
208     modifier onlyOwner() {
209         require(owner() == _msgSender(), "Ownable: caller is not the owner");
210         _;
211     }
212 
213     /**
214      * @dev Leaves the contract without owner. It will not be possible to call
215      * `onlyOwner` functions anymore. Can only be called by the current owner.
216      *
217      * NOTE: Renouncing ownership will leave the contract without an owner,
218      * thereby removing any functionality that is only available to the owner.
219      */
220     function renounceOwnership() public virtual onlyOwner {
221         _transferOwnership(address(0));
222     }
223 
224     /**
225      * @dev Transfers ownership of the contract to a new account (`newOwner`).
226      * Can only be called by the current owner.
227      */
228     function transferOwnership(address newOwner) public virtual onlyOwner {
229         require(newOwner != address(0), "Ownable: new owner is the zero address");
230         _transferOwnership(newOwner);
231     }
232 
233     /**
234      * @dev Transfers ownership of the contract to a new account (`newOwner`).
235      * Internal function without access restriction.
236      */
237     function _transferOwnership(address newOwner) internal virtual {
238         address oldOwner = _owner;
239         _owner = newOwner;
240         emit OwnershipTransferred(oldOwner, newOwner);
241     }
242 }
243 
244 // File: contracts/MDDA.sol
245 
246 //SPDX-License-Identifier: MIT
247 
248 pragma solidity ^0.8.4;
249 
250 
251 
252 
253 /*
254 
255 Open source Dutch Auction contract
256 
257 Dutch Auction that exposes a function to minters that allows them to pull difference between payment price and settle price.
258 
259 Initial version has no owner functions to not allow for owner foul play.
260 
261 Written by: mousedev.eth
262 
263 */
264 
265 
266 
267 contract MDDA is Ownable {
268 
269     uint256 public DA_STARTING_PRICE;
270 
271     uint256 public DA_ENDING_PRICE;
272 
273     uint256 public DA_DECREMENT;
274 
275     uint256 public DA_DECREMENT_FREQUENCY;
276 
277     uint256 public DA_STARTING_TIMESTAMP;
278 
279     uint256 public DA_MAX_QUANTITY;
280 
281 
282 
283     //The price the auction ended at.
284 
285     uint256 public DA_FINAL_PRICE;
286 
287 
288 
289     //The quantity for DA.
290 
291     uint256 public DA_QUANTITY;
292 
293 
294 
295     bool public DATA_SET;
296 
297     bool public INITIAL_FUNDS_WITHDRAWN;
298 
299     bool public REFUND_ENDED;
300 
301 
302 
303     //Struct for storing batch price data.
304 
305     struct TokenBatchPriceData {
306 
307         uint128 pricePaid;
308 
309         uint128 quantityMinted;
310 
311     }
312 
313 
314 
315     //Token to token price data
316 
317     mapping(address => TokenBatchPriceData[]) public userToTokenBatchPriceData;
318 
319 
320 
321     function initializeAuctionData(
322 
323         uint256 _DAStartingPrice,
324 
325         uint256 _DAEndingPrice,
326 
327         uint256 _DADecrement,
328 
329         uint256 _DADecrementFrequency,
330 
331         uint256 _DAStartingTimestamp,
332 
333         uint256 _DAMaxQuantity,
334 
335         uint256 _DAQuantity
336 
337     ) public onlyOwner {
338 
339         require(!DATA_SET, "DA data has already been set.");
340 
341         DA_STARTING_PRICE = _DAStartingPrice;
342 
343         DA_ENDING_PRICE = _DAEndingPrice;
344 
345         DA_DECREMENT = _DADecrement;
346 
347         DA_DECREMENT_FREQUENCY = _DADecrementFrequency;
348 
349         DA_STARTING_TIMESTAMP = _DAStartingTimestamp;
350 
351         DA_MAX_QUANTITY = _DAMaxQuantity;
352 
353         DA_QUANTITY = _DAQuantity;
354 
355 
356 
357         DATA_SET = true;
358 
359     }
360 
361 
362 
363     function userToTokenBatches(address user)
364 
365         public
366 
367         view
368 
369         returns (TokenBatchPriceData[] memory)
370 
371     {
372 
373         return userToTokenBatchPriceData[user];
374 
375     }
376 
377 
378 
379     function currentPrice() public view returns (uint256) {
380 
381         require(
382 
383             block.timestamp >= DA_STARTING_TIMESTAMP,
384 
385             "DA has not started!"
386 
387         );
388 
389 
390 
391         if (DA_FINAL_PRICE > 0) return DA_FINAL_PRICE;
392 
393 
394 
395         //Seconds since we started
396 
397         uint256 timeSinceStart = block.timestamp - DA_STARTING_TIMESTAMP;
398 
399 
400 
401         //How many decrements should've happened since that time
402 
403         uint256 decrementsSinceStart = timeSinceStart / DA_DECREMENT_FREQUENCY;
404 
405 
406 
407         //How much eth to remove
408 
409         uint256 totalDecrement = decrementsSinceStart * DA_DECREMENT;
410 
411 
412 
413         //If how much we want to reduce is greater or equal to the range, return the lowest value
414 
415         if (totalDecrement >= DA_STARTING_PRICE - DA_ENDING_PRICE) {
416 
417             return DA_ENDING_PRICE;
418 
419         }
420 
421 
422 
423         //If not, return the starting price minus the decrement.
424 
425         return DA_STARTING_PRICE - totalDecrement;
426 
427     }
428 
429 
430 
431     function DAHook(uint128 _quantity, uint256 _totalSupply) internal {
432 
433         require(DATA_SET, "DA data not set yet");
434 
435 
436 
437         uint256 _currentPrice = currentPrice();
438 
439 
440 
441         //Require enough ETH
442 
443         require(
444 
445             msg.value >= _quantity * _currentPrice,
446 
447             "Did not send enough eth."
448 
449         );
450 
451 
452 
453         require(
454 
455             _quantity > 0 && _quantity <= DA_MAX_QUANTITY,
456 
457             "Incorrect quantity!"
458 
459         );
460 
461 
462 
463         require(
464 
465             block.timestamp >= DA_STARTING_TIMESTAMP,
466 
467             "DA has not started!"
468 
469         );
470 
471 
472 
473         require(
474 
475             _totalSupply + _quantity <= DA_QUANTITY,
476 
477             "Max supply for DA reached!"
478 
479         );
480 
481 
482 
483         //Set the final price.
484 
485         if (_totalSupply + _quantity == DA_QUANTITY)
486 
487             DA_FINAL_PRICE = _currentPrice;
488 
489 
490 
491         //Add to user batch array.
492 
493         userToTokenBatchPriceData[msg.sender].push(
494 
495             TokenBatchPriceData(uint128(msg.value), _quantity)
496 
497         );
498 
499     }
500 
501 
502 
503     function refundExtraETH() public {
504 
505         require(DA_FINAL_PRICE > 0, "Dutch action must be over!");
506 
507         require(REFUND_ENDED == false, "Refund time has ended!");
508 
509 
510 
511         uint256 totalRefund;
512 
513 
514 
515         for (
516 
517             uint256 i = userToTokenBatchPriceData[msg.sender].length;
518 
519             i > 0;
520 
521             i--
522 
523         ) {
524 
525             //This is what they should have paid if they bought at lowest price tier.
526 
527             uint256 expectedPrice = userToTokenBatchPriceData[msg.sender][i - 1]
528 
529                 .quantityMinted * DA_FINAL_PRICE;
530 
531 
532 
533             //What they paid - what they should have paid = refund.
534 
535             uint256 refund = userToTokenBatchPriceData[msg.sender][i - 1]
536 
537                 .pricePaid - expectedPrice;
538 
539 
540 
541             //Remove this tokenBatch
542 
543             userToTokenBatchPriceData[msg.sender].pop();
544 
545 
546 
547             //Send them their extra monies.
548 
549             totalRefund += refund;
550 
551         }
552 
553         payable(msg.sender).transfer(totalRefund);
554 
555     }
556 
557 
558 
559     function setDAQuantity(uint256 _DAQuantity) public onlyOwner {
560 
561         DA_QUANTITY = _DAQuantity;
562 
563     }
564 
565 
566 
567     function setRefundEnded() public onlyOwner {
568 
569         require(REFUND_ENDED == false, "Refund time has ended!");
570 
571         REFUND_ENDED = true;
572 
573     }
574 
575 }
576 
577 
578 // File: @openzeppelin/contracts/utils/Address.sol
579 
580 
581 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
582 
583 pragma solidity ^0.8.1;
584 
585 /**
586  * @dev Collection of functions related to the address type
587  */
588 library Address {
589     /**
590      * @dev Returns true if `account` is a contract.
591      *
592      * [IMPORTANT]
593      * ====
594      * It is unsafe to assume that an address for which this function returns
595      * false is an externally-owned account (EOA) and not a contract.
596      *
597      * Among others, `isContract` will return false for the following
598      * types of addresses:
599      *
600      *  - an externally-owned account
601      *  - a contract in construction
602      *  - an address where a contract will be created
603      *  - an address where a contract lived, but was destroyed
604      * ====
605      *
606      * [IMPORTANT]
607      * ====
608      * You shouldn't rely on `isContract` to protect against flash loan attacks!
609      *
610      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
611      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
612      * constructor.
613      * ====
614      */
615     function isContract(address account) internal view returns (bool) {
616         // This method relies on extcodesize/address.code.length, which returns 0
617         // for contracts in construction, since the code is only stored at the end
618         // of the constructor execution.
619 
620         return account.code.length > 0;
621     }
622 
623     /**
624      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
625      * `recipient`, forwarding all available gas and reverting on errors.
626      *
627      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
628      * of certain opcodes, possibly making contracts go over the 2300 gas limit
629      * imposed by `transfer`, making them unable to receive funds via
630      * `transfer`. {sendValue} removes this limitation.
631      *
632      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
633      *
634      * IMPORTANT: because control is transferred to `recipient`, care must be
635      * taken to not create reentrancy vulnerabilities. Consider using
636      * {ReentrancyGuard} or the
637      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
638      */
639     function sendValue(address payable recipient, uint256 amount) internal {
640         require(address(this).balance >= amount, "Address: insufficient balance");
641 
642         (bool success, ) = recipient.call{value: amount}("");
643         require(success, "Address: unable to send value, recipient may have reverted");
644     }
645 
646     /**
647      * @dev Performs a Solidity function call using a low level `call`. A
648      * plain `call` is an unsafe replacement for a function call: use this
649      * function instead.
650      *
651      * If `target` reverts with a revert reason, it is bubbled up by this
652      * function (like regular Solidity function calls).
653      *
654      * Returns the raw returned data. To convert to the expected return value,
655      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
656      *
657      * Requirements:
658      *
659      * - `target` must be a contract.
660      * - calling `target` with `data` must not revert.
661      *
662      * _Available since v3.1._
663      */
664     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
665         return functionCall(target, data, "Address: low-level call failed");
666     }
667 
668     /**
669      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
670      * `errorMessage` as a fallback revert reason when `target` reverts.
671      *
672      * _Available since v3.1._
673      */
674     function functionCall(
675         address target,
676         bytes memory data,
677         string memory errorMessage
678     ) internal returns (bytes memory) {
679         return functionCallWithValue(target, data, 0, errorMessage);
680     }
681 
682     /**
683      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
684      * but also transferring `value` wei to `target`.
685      *
686      * Requirements:
687      *
688      * - the calling contract must have an ETH balance of at least `value`.
689      * - the called Solidity function must be `payable`.
690      *
691      * _Available since v3.1._
692      */
693     function functionCallWithValue(
694         address target,
695         bytes memory data,
696         uint256 value
697     ) internal returns (bytes memory) {
698         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
699     }
700 
701     /**
702      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
703      * with `errorMessage` as a fallback revert reason when `target` reverts.
704      *
705      * _Available since v3.1._
706      */
707     function functionCallWithValue(
708         address target,
709         bytes memory data,
710         uint256 value,
711         string memory errorMessage
712     ) internal returns (bytes memory) {
713         require(address(this).balance >= value, "Address: insufficient balance for call");
714         require(isContract(target), "Address: call to non-contract");
715 
716         (bool success, bytes memory returndata) = target.call{value: value}(data);
717         return verifyCallResult(success, returndata, errorMessage);
718     }
719 
720     /**
721      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
722      * but performing a static call.
723      *
724      * _Available since v3.3._
725      */
726     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
727         return functionStaticCall(target, data, "Address: low-level static call failed");
728     }
729 
730     /**
731      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
732      * but performing a static call.
733      *
734      * _Available since v3.3._
735      */
736     function functionStaticCall(
737         address target,
738         bytes memory data,
739         string memory errorMessage
740     ) internal view returns (bytes memory) {
741         require(isContract(target), "Address: static call to non-contract");
742 
743         (bool success, bytes memory returndata) = target.staticcall(data);
744         return verifyCallResult(success, returndata, errorMessage);
745     }
746 
747     /**
748      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
749      * but performing a delegate call.
750      *
751      * _Available since v3.4._
752      */
753     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
754         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
755     }
756 
757     /**
758      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
759      * but performing a delegate call.
760      *
761      * _Available since v3.4._
762      */
763     function functionDelegateCall(
764         address target,
765         bytes memory data,
766         string memory errorMessage
767     ) internal returns (bytes memory) {
768         require(isContract(target), "Address: delegate call to non-contract");
769 
770         (bool success, bytes memory returndata) = target.delegatecall(data);
771         return verifyCallResult(success, returndata, errorMessage);
772     }
773 
774     /**
775      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
776      * revert reason using the provided one.
777      *
778      * _Available since v4.3._
779      */
780     function verifyCallResult(
781         bool success,
782         bytes memory returndata,
783         string memory errorMessage
784     ) internal pure returns (bytes memory) {
785         if (success) {
786             return returndata;
787         } else {
788             // Look for revert reason and bubble it up if present
789             if (returndata.length > 0) {
790                 // The easiest way to bubble the revert reason is using memory via assembly
791 
792                 assembly {
793                     let returndata_size := mload(returndata)
794                     revert(add(32, returndata), returndata_size)
795                 }
796             } else {
797                 revert(errorMessage);
798             }
799         }
800     }
801 }
802 
803 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
804 
805 
806 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
807 
808 pragma solidity ^0.8.0;
809 
810 /**
811  * @title ERC721 token receiver interface
812  * @dev Interface for any contract that wants to support safeTransfers
813  * from ERC721 asset contracts.
814  */
815 interface IERC721Receiver {
816     /**
817      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
818      * by `operator` from `from`, this function is called.
819      *
820      * It must return its Solidity selector to confirm the token transfer.
821      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
822      *
823      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
824      */
825     function onERC721Received(
826         address operator,
827         address from,
828         uint256 tokenId,
829         bytes calldata data
830     ) external returns (bytes4);
831 }
832 
833 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
834 
835 
836 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
837 
838 pragma solidity ^0.8.0;
839 
840 /**
841  * @dev Interface of the ERC165 standard, as defined in the
842  * https://eips.ethereum.org/EIPS/eip-165[EIP].
843  *
844  * Implementers can declare support of contract interfaces, which can then be
845  * queried by others ({ERC165Checker}).
846  *
847  * For an implementation, see {ERC165}.
848  */
849 interface IERC165 {
850     /**
851      * @dev Returns true if this contract implements the interface defined by
852      * `interfaceId`. See the corresponding
853      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
854      * to learn more about how these ids are created.
855      *
856      * This function call must use less than 30 000 gas.
857      */
858     function supportsInterface(bytes4 interfaceId) external view returns (bool);
859 }
860 
861 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
862 
863 
864 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
865 
866 pragma solidity ^0.8.0;
867 
868 
869 /**
870  * @dev Implementation of the {IERC165} interface.
871  *
872  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
873  * for the additional interface id that will be supported. For example:
874  *
875  * ```solidity
876  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
877  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
878  * }
879  * ```
880  *
881  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
882  */
883 abstract contract ERC165 is IERC165 {
884     /**
885      * @dev See {IERC165-supportsInterface}.
886      */
887     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
888         return interfaceId == type(IERC165).interfaceId;
889     }
890 }
891 
892 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
893 
894 
895 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
896 
897 pragma solidity ^0.8.0;
898 
899 
900 /**
901  * @dev Required interface of an ERC721 compliant contract.
902  */
903 interface IERC721 is IERC165 {
904     /**
905      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
906      */
907     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
908 
909     /**
910      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
911      */
912     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
913 
914     /**
915      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
916      */
917     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
918 
919     /**
920      * @dev Returns the number of tokens in ``owner``'s account.
921      */
922     function balanceOf(address owner) external view returns (uint256 balance);
923 
924     /**
925      * @dev Returns the owner of the `tokenId` token.
926      *
927      * Requirements:
928      *
929      * - `tokenId` must exist.
930      */
931     function ownerOf(uint256 tokenId) external view returns (address owner);
932 
933     /**
934      * @dev Safely transfers `tokenId` token from `from` to `to`.
935      *
936      * Requirements:
937      *
938      * - `from` cannot be the zero address.
939      * - `to` cannot be the zero address.
940      * - `tokenId` token must exist and be owned by `from`.
941      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
942      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
943      *
944      * Emits a {Transfer} event.
945      */
946     function safeTransferFrom(
947         address from,
948         address to,
949         uint256 tokenId,
950         bytes calldata data
951     ) external;
952 
953     /**
954      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
955      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
956      *
957      * Requirements:
958      *
959      * - `from` cannot be the zero address.
960      * - `to` cannot be the zero address.
961      * - `tokenId` token must exist and be owned by `from`.
962      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
963      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
964      *
965      * Emits a {Transfer} event.
966      */
967     function safeTransferFrom(
968         address from,
969         address to,
970         uint256 tokenId
971     ) external;
972 
973     /**
974      * @dev Transfers `tokenId` token from `from` to `to`.
975      *
976      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
977      *
978      * Requirements:
979      *
980      * - `from` cannot be the zero address.
981      * - `to` cannot be the zero address.
982      * - `tokenId` token must be owned by `from`.
983      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
984      *
985      * Emits a {Transfer} event.
986      */
987     function transferFrom(
988         address from,
989         address to,
990         uint256 tokenId
991     ) external;
992 
993     /**
994      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
995      * The approval is cleared when the token is transferred.
996      *
997      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
998      *
999      * Requirements:
1000      *
1001      * - The caller must own the token or be an approved operator.
1002      * - `tokenId` must exist.
1003      *
1004      * Emits an {Approval} event.
1005      */
1006     function approve(address to, uint256 tokenId) external;
1007 
1008     /**
1009      * @dev Approve or remove `operator` as an operator for the caller.
1010      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1011      *
1012      * Requirements:
1013      *
1014      * - The `operator` cannot be the caller.
1015      *
1016      * Emits an {ApprovalForAll} event.
1017      */
1018     function setApprovalForAll(address operator, bool _approved) external;
1019 
1020     /**
1021      * @dev Returns the account approved for `tokenId` token.
1022      *
1023      * Requirements:
1024      *
1025      * - `tokenId` must exist.
1026      */
1027     function getApproved(uint256 tokenId) external view returns (address operator);
1028 
1029     /**
1030      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1031      *
1032      * See {setApprovalForAll}
1033      */
1034     function isApprovedForAll(address owner, address operator) external view returns (bool);
1035 }
1036 
1037 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1038 
1039 
1040 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1041 
1042 pragma solidity ^0.8.0;
1043 
1044 
1045 /**
1046  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1047  * @dev See https://eips.ethereum.org/EIPS/eip-721
1048  */
1049 interface IERC721Metadata is IERC721 {
1050     /**
1051      * @dev Returns the token collection name.
1052      */
1053     function name() external view returns (string memory);
1054 
1055     /**
1056      * @dev Returns the token collection symbol.
1057      */
1058     function symbol() external view returns (string memory);
1059 
1060     /**
1061      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1062      */
1063     function tokenURI(uint256 tokenId) external view returns (string memory);
1064 }
1065 
1066 // File: erc721a/contracts/IERC721A.sol
1067 
1068 
1069 // ERC721A Contracts v3.3.0
1070 // Creator: Chiru Labs
1071 
1072 pragma solidity ^0.8.4;
1073 
1074 
1075 
1076 /**
1077  * @dev Interface of an ERC721A compliant contract.
1078  */
1079 interface IERC721A is IERC721, IERC721Metadata {
1080     /**
1081      * The caller must own the token or be an approved operator.
1082      */
1083     error ApprovalCallerNotOwnerNorApproved();
1084 
1085     /**
1086      * The token does not exist.
1087      */
1088     error ApprovalQueryForNonexistentToken();
1089 
1090     /**
1091      * The caller cannot approve to their own address.
1092      */
1093     error ApproveToCaller();
1094 
1095     /**
1096      * The caller cannot approve to the current owner.
1097      */
1098     error ApprovalToCurrentOwner();
1099 
1100     /**
1101      * Cannot query the balance for the zero address.
1102      */
1103     error BalanceQueryForZeroAddress();
1104 
1105     /**
1106      * Cannot mint to the zero address.
1107      */
1108     error MintToZeroAddress();
1109 
1110     /**
1111      * The quantity of tokens minted must be more than zero.
1112      */
1113     error MintZeroQuantity();
1114 
1115     /**
1116      * The token does not exist.
1117      */
1118     error OwnerQueryForNonexistentToken();
1119 
1120     /**
1121      * The caller must own the token or be an approved operator.
1122      */
1123     error TransferCallerNotOwnerNorApproved();
1124 
1125     /**
1126      * The token must be owned by `from`.
1127      */
1128     error TransferFromIncorrectOwner();
1129 
1130     /**
1131      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
1132      */
1133     error TransferToNonERC721ReceiverImplementer();
1134 
1135     /**
1136      * Cannot transfer to the zero address.
1137      */
1138     error TransferToZeroAddress();
1139 
1140     /**
1141      * The token does not exist.
1142      */
1143     error URIQueryForNonexistentToken();
1144 
1145     // Compiler will pack this into a single 256bit word.
1146     struct TokenOwnership {
1147         // The address of the owner.
1148         address addr;
1149         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1150         uint64 startTimestamp;
1151         // Whether the token has been burned.
1152         bool burned;
1153     }
1154 
1155     // Compiler will pack this into a single 256bit word.
1156     struct AddressData {
1157         // Realistically, 2**64-1 is more than enough.
1158         uint64 balance;
1159         // Keeps track of mint count with minimal overhead for tokenomics.
1160         uint64 numberMinted;
1161         // Keeps track of burn count with minimal overhead for tokenomics.
1162         uint64 numberBurned;
1163         // For miscellaneous variable(s) pertaining to the address
1164         // (e.g. number of whitelist mint slots used).
1165         // If there are multiple variables, please pack them into a uint64.
1166         uint64 aux;
1167     }
1168 
1169     /**
1170      * @dev Returns the total amount of tokens stored by the contract.
1171      * 
1172      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
1173      */
1174     function totalSupply() external view returns (uint256);
1175 }
1176 
1177 // File: erc721a/contracts/ERC721A.sol
1178 
1179 
1180 // ERC721A Contracts v3.3.0
1181 // Creator: Chiru Labs
1182 
1183 pragma solidity ^0.8.4;
1184 
1185 
1186 
1187 
1188 
1189 
1190 
1191 /**
1192  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1193  * the Metadata extension. Built to optimize for lower gas during batch mints.
1194  *
1195  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1196  *
1197  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1198  *
1199  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1200  */
1201 contract ERC721A is Context, ERC165, IERC721A {
1202     using Address for address;
1203     using Strings for uint256;
1204 
1205     // The tokenId of the next token to be minted.
1206     uint256 internal _currentIndex;
1207 
1208     // The number of tokens burned.
1209     uint256 internal _burnCounter;
1210 
1211     // Token name
1212     string private _name;
1213 
1214     // Token symbol
1215     string private _symbol;
1216 
1217     // Mapping from token ID to ownership details
1218     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1219     mapping(uint256 => TokenOwnership) internal _ownerships;
1220 
1221     // Mapping owner address to address data
1222     mapping(address => AddressData) private _addressData;
1223 
1224     // Mapping from token ID to approved address
1225     mapping(uint256 => address) private _tokenApprovals;
1226 
1227     // Mapping from owner to operator approvals
1228     mapping(address => mapping(address => bool)) private _operatorApprovals;
1229 
1230     constructor(string memory name_, string memory symbol_) {
1231         _name = name_;
1232         _symbol = symbol_;
1233         _currentIndex = _startTokenId();
1234     }
1235 
1236     /**
1237      * To change the starting tokenId, please override this function.
1238      */
1239     function _startTokenId() internal view virtual returns (uint256) {
1240         return 0;
1241     }
1242 
1243     /**
1244      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1245      */
1246     function totalSupply() public view override returns (uint256) {
1247         // Counter underflow is impossible as _burnCounter cannot be incremented
1248         // more than _currentIndex - _startTokenId() times
1249         unchecked {
1250             return _currentIndex - _burnCounter - _startTokenId();
1251         }
1252     }
1253 
1254     /**
1255      * Returns the total amount of tokens minted in the contract.
1256      */
1257     function _totalMinted() internal view returns (uint256) {
1258         // Counter underflow is impossible as _currentIndex does not decrement,
1259         // and it is initialized to _startTokenId()
1260         unchecked {
1261             return _currentIndex - _startTokenId();
1262         }
1263     }
1264 
1265     /**
1266      * @dev See {IERC165-supportsInterface}.
1267      */
1268     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1269         return
1270             interfaceId == type(IERC721).interfaceId ||
1271             interfaceId == type(IERC721Metadata).interfaceId ||
1272             super.supportsInterface(interfaceId);
1273     }
1274 
1275     /**
1276      * @dev See {IERC721-balanceOf}.
1277      */
1278     function balanceOf(address owner) public view override returns (uint256) {
1279         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1280         return uint256(_addressData[owner].balance);
1281     }
1282 
1283     /**
1284      * Returns the number of tokens minted by `owner`.
1285      */
1286     function _numberMinted(address owner) internal view returns (uint256) {
1287         return uint256(_addressData[owner].numberMinted);
1288     }
1289 
1290     /**
1291      * Returns the number of tokens burned by or on behalf of `owner`.
1292      */
1293     function _numberBurned(address owner) internal view returns (uint256) {
1294         return uint256(_addressData[owner].numberBurned);
1295     }
1296 
1297     /**
1298      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1299      */
1300     function _getAux(address owner) internal view returns (uint64) {
1301         return _addressData[owner].aux;
1302     }
1303 
1304     /**
1305      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1306      * If there are multiple variables, please pack them into a uint64.
1307      */
1308     function _setAux(address owner, uint64 aux) internal {
1309         _addressData[owner].aux = aux;
1310     }
1311 
1312     /**
1313      * Gas spent here starts off proportional to the maximum mint batch size.
1314      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1315      */
1316     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1317         uint256 curr = tokenId;
1318 
1319         unchecked {
1320             if (_startTokenId() <= curr) if (curr < _currentIndex) {
1321                 TokenOwnership memory ownership = _ownerships[curr];
1322                 if (!ownership.burned) {
1323                     if (ownership.addr != address(0)) {
1324                         return ownership;
1325                     }
1326                     // Invariant:
1327                     // There will always be an ownership that has an address and is not burned
1328                     // before an ownership that does not have an address and is not burned.
1329                     // Hence, curr will not underflow.
1330                     while (true) {
1331                         curr--;
1332                         ownership = _ownerships[curr];
1333                         if (ownership.addr != address(0)) {
1334                             return ownership;
1335                         }
1336                     }
1337                 }
1338             }
1339         }
1340         revert OwnerQueryForNonexistentToken();
1341     }
1342 
1343     /**
1344      * @dev See {IERC721-ownerOf}.
1345      */
1346     function ownerOf(uint256 tokenId) public view override returns (address) {
1347         return _ownershipOf(tokenId).addr;
1348     }
1349 
1350     /**
1351      * @dev See {IERC721Metadata-name}.
1352      */
1353     function name() public view virtual override returns (string memory) {
1354         return _name;
1355     }
1356 
1357     /**
1358      * @dev See {IERC721Metadata-symbol}.
1359      */
1360     function symbol() public view virtual override returns (string memory) {
1361         return _symbol;
1362     }
1363 
1364     /**
1365      * @dev See {IERC721Metadata-tokenURI}.
1366      */
1367     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1368         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1369 
1370         string memory baseURI = _baseURI();
1371         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1372     }
1373 
1374     /**
1375      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1376      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1377      * by default, can be overriden in child contracts.
1378      */
1379     function _baseURI() internal view virtual returns (string memory) {
1380         return '';
1381     }
1382 
1383     /**
1384      * @dev See {IERC721-approve}.
1385      */
1386     function approve(address to, uint256 tokenId) public override {
1387         address owner = ERC721A.ownerOf(tokenId);
1388         if (to == owner) revert ApprovalToCurrentOwner();
1389 
1390         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
1391             revert ApprovalCallerNotOwnerNorApproved();
1392         }
1393 
1394         _approve(to, tokenId, owner);
1395     }
1396 
1397     /**
1398      * @dev See {IERC721-getApproved}.
1399      */
1400     function getApproved(uint256 tokenId) public view override returns (address) {
1401         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1402 
1403         return _tokenApprovals[tokenId];
1404     }
1405 
1406     /**
1407      * @dev See {IERC721-setApprovalForAll}.
1408      */
1409     function setApprovalForAll(address operator, bool approved) public virtual override {
1410         if (operator == _msgSender()) revert ApproveToCaller();
1411 
1412         _operatorApprovals[_msgSender()][operator] = approved;
1413         emit ApprovalForAll(_msgSender(), operator, approved);
1414     }
1415 
1416     /**
1417      * @dev See {IERC721-isApprovedForAll}.
1418      */
1419     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1420         return _operatorApprovals[owner][operator];
1421     }
1422 
1423     /**
1424      * @dev See {IERC721-transferFrom}.
1425      */
1426     function transferFrom(
1427         address from,
1428         address to,
1429         uint256 tokenId
1430     ) public virtual override {
1431         _transfer(from, to, tokenId);
1432     }
1433 
1434     /**
1435      * @dev See {IERC721-safeTransferFrom}.
1436      */
1437     function safeTransferFrom(
1438         address from,
1439         address to,
1440         uint256 tokenId
1441     ) public virtual override {
1442         safeTransferFrom(from, to, tokenId, '');
1443     }
1444 
1445     /**
1446      * @dev See {IERC721-safeTransferFrom}.
1447      */
1448     function safeTransferFrom(
1449         address from,
1450         address to,
1451         uint256 tokenId,
1452         bytes memory _data
1453     ) public virtual override {
1454         _transfer(from, to, tokenId);
1455         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1456             revert TransferToNonERC721ReceiverImplementer();
1457         }
1458     }
1459 
1460     /**
1461      * @dev Returns whether `tokenId` exists.
1462      *
1463      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1464      *
1465      * Tokens start existing when they are minted (`_mint`),
1466      */
1467     function _exists(uint256 tokenId) internal view returns (bool) {
1468         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1469     }
1470 
1471     /**
1472      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1473      */
1474     function _safeMint(address to, uint256 quantity) internal {
1475         _safeMint(to, quantity, '');
1476     }
1477 
1478     /**
1479      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1480      *
1481      * Requirements:
1482      *
1483      * - If `to` refers to a smart contract, it must implement
1484      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1485      * - `quantity` must be greater than 0.
1486      *
1487      * Emits a {Transfer} event.
1488      */
1489     function _safeMint(
1490         address to,
1491         uint256 quantity,
1492         bytes memory _data
1493     ) internal {
1494         uint256 startTokenId = _currentIndex;
1495         if (to == address(0)) revert MintToZeroAddress();
1496         if (quantity == 0) revert MintZeroQuantity();
1497 
1498         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1499 
1500         // Overflows are incredibly unrealistic.
1501         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1502         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1503         unchecked {
1504             _addressData[to].balance += uint64(quantity);
1505             _addressData[to].numberMinted += uint64(quantity);
1506 
1507             _ownerships[startTokenId].addr = to;
1508             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1509 
1510             uint256 updatedIndex = startTokenId;
1511             uint256 end = updatedIndex + quantity;
1512 
1513             if (to.isContract()) {
1514                 do {
1515                     emit Transfer(address(0), to, updatedIndex);
1516                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1517                         revert TransferToNonERC721ReceiverImplementer();
1518                     }
1519                 } while (updatedIndex < end);
1520                 // Reentrancy protection
1521                 if (_currentIndex != startTokenId) revert();
1522             } else {
1523                 do {
1524                     emit Transfer(address(0), to, updatedIndex++);
1525                 } while (updatedIndex < end);
1526             }
1527             _currentIndex = updatedIndex;
1528         }
1529         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1530     }
1531 
1532     /**
1533      * @dev Mints `quantity` tokens and transfers them to `to`.
1534      *
1535      * Requirements:
1536      *
1537      * - `to` cannot be the zero address.
1538      * - `quantity` must be greater than 0.
1539      *
1540      * Emits a {Transfer} event.
1541      */
1542     function _mint(address to, uint256 quantity) internal {
1543         uint256 startTokenId = _currentIndex;
1544         if (to == address(0)) revert MintToZeroAddress();
1545         if (quantity == 0) revert MintZeroQuantity();
1546 
1547         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1548 
1549         // Overflows are incredibly unrealistic.
1550         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1551         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1552         unchecked {
1553             _addressData[to].balance += uint64(quantity);
1554             _addressData[to].numberMinted += uint64(quantity);
1555 
1556             _ownerships[startTokenId].addr = to;
1557             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1558 
1559             uint256 updatedIndex = startTokenId;
1560             uint256 end = updatedIndex + quantity;
1561 
1562             do {
1563                 emit Transfer(address(0), to, updatedIndex++);
1564             } while (updatedIndex < end);
1565 
1566             _currentIndex = updatedIndex;
1567         }
1568         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1569     }
1570 
1571     /**
1572      * @dev Transfers `tokenId` from `from` to `to`.
1573      *
1574      * Requirements:
1575      *
1576      * - `to` cannot be the zero address.
1577      * - `tokenId` token must be owned by `from`.
1578      *
1579      * Emits a {Transfer} event.
1580      */
1581     function _transfer(
1582         address from,
1583         address to,
1584         uint256 tokenId
1585     ) private {
1586         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1587 
1588         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1589 
1590         bool isApprovedOrOwner = (_msgSender() == from ||
1591             isApprovedForAll(from, _msgSender()) ||
1592             getApproved(tokenId) == _msgSender());
1593 
1594         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1595         if (to == address(0)) revert TransferToZeroAddress();
1596 
1597         _beforeTokenTransfers(from, to, tokenId, 1);
1598 
1599         // Clear approvals from the previous owner
1600         _approve(address(0), tokenId, from);
1601 
1602         // Underflow of the sender's balance is impossible because we check for
1603         // ownership above and the recipient's balance can't realistically overflow.
1604         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1605         unchecked {
1606             _addressData[from].balance -= 1;
1607             _addressData[to].balance += 1;
1608 
1609             TokenOwnership storage currSlot = _ownerships[tokenId];
1610             currSlot.addr = to;
1611             currSlot.startTimestamp = uint64(block.timestamp);
1612 
1613             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1614             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1615             uint256 nextTokenId = tokenId + 1;
1616             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1617             if (nextSlot.addr == address(0)) {
1618                 // This will suffice for checking _exists(nextTokenId),
1619                 // as a burned slot cannot contain the zero address.
1620                 if (nextTokenId != _currentIndex) {
1621                     nextSlot.addr = from;
1622                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1623                 }
1624             }
1625         }
1626 
1627         emit Transfer(from, to, tokenId);
1628         _afterTokenTransfers(from, to, tokenId, 1);
1629     }
1630 
1631     /**
1632      * @dev Equivalent to `_burn(tokenId, false)`.
1633      */
1634     function _burn(uint256 tokenId) internal virtual {
1635         _burn(tokenId, false);
1636     }
1637 
1638     /**
1639      * @dev Destroys `tokenId`.
1640      * The approval is cleared when the token is burned.
1641      *
1642      * Requirements:
1643      *
1644      * - `tokenId` must exist.
1645      *
1646      * Emits a {Transfer} event.
1647      */
1648     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1649         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1650 
1651         address from = prevOwnership.addr;
1652 
1653         if (approvalCheck) {
1654             bool isApprovedOrOwner = (_msgSender() == from ||
1655                 isApprovedForAll(from, _msgSender()) ||
1656                 getApproved(tokenId) == _msgSender());
1657 
1658             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1659         }
1660 
1661         _beforeTokenTransfers(from, address(0), tokenId, 1);
1662 
1663         // Clear approvals from the previous owner
1664         _approve(address(0), tokenId, from);
1665 
1666         // Underflow of the sender's balance is impossible because we check for
1667         // ownership above and the recipient's balance can't realistically overflow.
1668         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1669         unchecked {
1670             AddressData storage addressData = _addressData[from];
1671             addressData.balance -= 1;
1672             addressData.numberBurned += 1;
1673 
1674             // Keep track of who burned the token, and the timestamp of burning.
1675             TokenOwnership storage currSlot = _ownerships[tokenId];
1676             currSlot.addr = from;
1677             currSlot.startTimestamp = uint64(block.timestamp);
1678             currSlot.burned = true;
1679 
1680             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1681             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1682             uint256 nextTokenId = tokenId + 1;
1683             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1684             if (nextSlot.addr == address(0)) {
1685                 // This will suffice for checking _exists(nextTokenId),
1686                 // as a burned slot cannot contain the zero address.
1687                 if (nextTokenId != _currentIndex) {
1688                     nextSlot.addr = from;
1689                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1690                 }
1691             }
1692         }
1693 
1694         emit Transfer(from, address(0), tokenId);
1695         _afterTokenTransfers(from, address(0), tokenId, 1);
1696 
1697         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1698         unchecked {
1699             _burnCounter++;
1700         }
1701     }
1702 
1703     /**
1704      * @dev Approve `to` to operate on `tokenId`
1705      *
1706      * Emits a {Approval} event.
1707      */
1708     function _approve(
1709         address to,
1710         uint256 tokenId,
1711         address owner
1712     ) private {
1713         _tokenApprovals[tokenId] = to;
1714         emit Approval(owner, to, tokenId);
1715     }
1716 
1717     /**
1718      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1719      *
1720      * @param from address representing the previous owner of the given token ID
1721      * @param to target address that will receive the tokens
1722      * @param tokenId uint256 ID of the token to be transferred
1723      * @param _data bytes optional data to send along with the call
1724      * @return bool whether the call correctly returned the expected magic value
1725      */
1726     function _checkContractOnERC721Received(
1727         address from,
1728         address to,
1729         uint256 tokenId,
1730         bytes memory _data
1731     ) private returns (bool) {
1732         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1733             return retval == IERC721Receiver(to).onERC721Received.selector;
1734         } catch (bytes memory reason) {
1735             if (reason.length == 0) {
1736                 revert TransferToNonERC721ReceiverImplementer();
1737             } else {
1738                 assembly {
1739                     revert(add(32, reason), mload(reason))
1740                 }
1741             }
1742         }
1743     }
1744 
1745     /**
1746      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1747      * And also called before burning one token.
1748      *
1749      * startTokenId - the first token id to be transferred
1750      * quantity - the amount to be transferred
1751      *
1752      * Calling conditions:
1753      *
1754      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1755      * transferred to `to`.
1756      * - When `from` is zero, `tokenId` will be minted for `to`.
1757      * - When `to` is zero, `tokenId` will be burned by `from`.
1758      * - `from` and `to` are never both zero.
1759      */
1760     function _beforeTokenTransfers(
1761         address from,
1762         address to,
1763         uint256 startTokenId,
1764         uint256 quantity
1765     ) internal virtual {}
1766 
1767     /**
1768      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1769      * minting.
1770      * And also called after one token has been burned.
1771      *
1772      * startTokenId - the first token id to be transferred
1773      * quantity - the amount to be transferred
1774      *
1775      * Calling conditions:
1776      *
1777      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1778      * transferred to `to`.
1779      * - When `from` is zero, `tokenId` has been minted for `to`.
1780      * - When `to` is zero, `tokenId` has been burned by `from`.
1781      * - `from` and `to` are never both zero.
1782      */
1783     function _afterTokenTransfers(
1784         address from,
1785         address to,
1786         uint256 startTokenId,
1787         uint256 quantity
1788     ) internal virtual {}
1789 }
1790 
1791 // File: contracts/Kuroki.sol
1792 
1793 
1794 
1795 pragma solidity ^0.8.12;
1796 
1797 
1798 
1799 
1800 
1801 
1802 
1803 contract Kuroki is Ownable, ERC721A, MDDA {
1804 
1805     uint256 public immutable maxSupply = 5555;
1806 
1807     uint256 public maxMintAmount = 2;
1808 
1809     uint256 public whitelistPrice = 0.08 ether;
1810 
1811     uint256 public publicPrice = 0.1 ether;
1812 
1813     uint256 public whitelistSaleStartTime;
1814 
1815     uint256 public publicSaleStartTime;
1816 
1817     string private _baseTokenURI;
1818 
1819 
1820 
1821     // ======== MERKLE ROOT ========
1822 
1823     bytes32 public rootWL;
1824 
1825     bytes32 public rootOG;
1826 
1827 
1828 
1829     // Flag user after mint wl / og
1830 
1831     mapping(address => bool) private mintedUsers;
1832 
1833 
1834 
1835     constructor() ERC721A("Kuroki Genesis", "KUROKI") {}
1836 
1837 
1838 
1839     function publicMint(uint256 _mintAmount) external payable {
1840 
1841         uint256 supply = totalSupply();
1842 
1843         uint256 _saleStartTime = uint256(publicSaleStartTime);
1844 
1845         require(
1846 
1847             _saleStartTime != 0 && block.timestamp >= _saleStartTime,
1848 
1849             "Sale has not started yet"
1850 
1851         );
1852 
1853         require(_mintAmount <= maxMintAmount, "Can not mint this many");
1854 
1855         require(supply + _mintAmount <= maxSupply, "Reached max supply");
1856 
1857         require(msg.value >= publicPrice * _mintAmount);
1858 
1859         _safeMint(msg.sender, _mintAmount);
1860 
1861     }
1862 
1863 
1864 
1865     function mintDutchAuction(uint8 _quantity) external payable {
1866 
1867         DAHook(_quantity, totalSupply());
1868 
1869         _safeMint(msg.sender, _quantity);
1870 
1871     }
1872 
1873 
1874 
1875     function whitelistMint(bytes32[] memory proof) external payable {
1876 
1877         uint256 supply = totalSupply();
1878 
1879         uint256 _saleStartTime = uint256(whitelistSaleStartTime);
1880 
1881         require(
1882 
1883             _saleStartTime != 0 && block.timestamp >= _saleStartTime,
1884 
1885             "Sale has not started yet"
1886 
1887         );
1888 
1889         require(mintedUsers[msg.sender] == false, "Already minted");
1890 
1891         require(
1892 
1893             isValidWL(proof, keccak256(abi.encodePacked(msg.sender))),
1894 
1895             "Not a part of WL"
1896 
1897         );
1898 
1899         require(supply + 1 <= maxSupply, "Reached max supply");
1900 
1901         require(msg.value >= whitelistPrice);
1902 
1903         mintedUsers[msg.sender] = true;
1904 
1905         _safeMint(msg.sender, 1);
1906 
1907     }
1908 
1909 
1910 
1911     function ogMint(bytes32[] memory proof) external payable {
1912 
1913         uint256 supply = totalSupply();
1914 
1915         uint256 _saleStartTime = uint256(whitelistSaleStartTime);
1916 
1917         require(
1918 
1919             _saleStartTime != 0 && block.timestamp >= _saleStartTime,
1920 
1921             "Sale has not started yet"
1922 
1923         );
1924 
1925         require(mintedUsers[msg.sender] == false, "Already minted");
1926 
1927         require(
1928 
1929             isValidOG(proof, keccak256(abi.encodePacked(msg.sender))),
1930 
1931             "Not a part of OG"
1932 
1933         );
1934 
1935         require(supply + 2 <= maxSupply, "Reached max supply");
1936 
1937         require(msg.value >= whitelistPrice * 2);
1938 
1939         mintedUsers[msg.sender] = true;
1940 
1941         _safeMint(msg.sender, 2);
1942 
1943     }
1944 
1945 
1946 
1947     function isValidWL(bytes32[] memory proof, bytes32 leaf)
1948 
1949         public
1950 
1951         view
1952 
1953         returns (bool)
1954 
1955     {
1956 
1957         return MerkleProof.verify(proof, rootWL, leaf);
1958 
1959     }
1960 
1961 
1962 
1963     function isValidOG(bytes32[] memory proof, bytes32 leaf)
1964 
1965         public
1966 
1967         view
1968 
1969         returns (bool)
1970 
1971     {
1972 
1973         return MerkleProof.verify(proof, rootOG, leaf);
1974 
1975     }
1976 
1977 
1978 
1979     function getUserMinted() public view returns (bool) {
1980 
1981         return mintedUsers[msg.sender];
1982 
1983     }
1984 
1985 
1986 
1987     // For marketing etc.
1988 
1989     function devMint(uint256 quantity) external onlyOwner {
1990 
1991         require(totalSupply() + quantity <= maxSupply, "Reached max supply");
1992 
1993         _safeMint(msg.sender, quantity);
1994 
1995     }
1996 
1997 
1998 
1999     // only owner
2000 
2001     function setMaxMintAmount(uint256 _maxMintAmount) external onlyOwner {
2002 
2003         maxMintAmount = _maxMintAmount;
2004 
2005     }
2006 
2007 
2008 
2009     function setWhitelistPrice(uint256 _newPrice) external onlyOwner {
2010 
2011         whitelistPrice = _newPrice;
2012 
2013     }
2014 
2015 
2016 
2017     function setPublicPrice(uint256 _newPrice) external onlyOwner {
2018 
2019         publicPrice = _newPrice;
2020 
2021     }
2022 
2023 
2024 
2025     function _baseURI() internal view virtual override returns (string memory) {
2026 
2027         return _baseTokenURI;
2028 
2029     }
2030 
2031 
2032 
2033     function setBaseURI(string calldata baseURI) external onlyOwner {
2034 
2035         _baseTokenURI = baseURI;
2036 
2037     }
2038 
2039 
2040 
2041     function chWhitelistSaleStartTime(uint256 timestamp) external onlyOwner {
2042 
2043         whitelistSaleStartTime = timestamp;
2044 
2045     }
2046 
2047 
2048 
2049     function chPublicSaleStartTime(uint256 timestamp) external onlyOwner {
2050 
2051         publicSaleStartTime = timestamp;
2052 
2053     }
2054 
2055 
2056 
2057     function setRootWL(bytes32 _rootWL) external onlyOwner {
2058 
2059         rootWL = _rootWL;
2060 
2061     }
2062 
2063 
2064 
2065     function setRootOG(bytes32 _rootOG) external onlyOwner {
2066 
2067         rootOG = _rootOG;
2068 
2069     }
2070 
2071 
2072 
2073     function withdrawFunds() external onlyOwner {
2074 
2075         uint256 finalFunds = address(this).balance;
2076 
2077         (bool succ, ) = payable(msg.sender).call{value: finalFunds}("");
2078 
2079         require(succ, "transfer failed");
2080 
2081     }
2082 
2083 }