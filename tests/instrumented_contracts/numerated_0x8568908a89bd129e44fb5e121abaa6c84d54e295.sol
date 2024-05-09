1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
68 
69 
70 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev These functions deal with verification of Merkle Trees proofs.
76  *
77  * The proofs can be generated using the JavaScript library
78  * https://github.com/miguelmota/merkletreejs[merkletreejs].
79  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
80  *
81  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
82  *
83  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
84  * hashing, or use a hash function other than keccak256 for hashing leaves.
85  * This is because the concatenation of a sorted pair of internal nodes in
86  * the merkle tree could be reinterpreted as a leaf value.
87  */
88 library MerkleProof {
89     /**
90      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
91      * defined by `root`. For this, a `proof` must be provided, containing
92      * sibling hashes on the branch from the leaf to the root of the tree. Each
93      * pair of leaves and each pair of pre-images are assumed to be sorted.
94      */
95     function verify(
96         bytes32[] memory proof,
97         bytes32 root,
98         bytes32 leaf
99     ) internal pure returns (bool) {
100         return processProof(proof, leaf) == root;
101     }
102 
103     /**
104      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
105      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
106      * hash matches the root of the tree. When processing the proof, the pairs
107      * of leafs & pre-images are assumed to be sorted.
108      *
109      * _Available since v4.4._
110      */
111     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
112         bytes32 computedHash = leaf;
113         for (uint256 i = 0; i < proof.length; i++) {
114             bytes32 proofElement = proof[i];
115             if (computedHash <= proofElement) {
116                 // Hash(current computed hash + current element of the proof)
117                 computedHash = _efficientHash(computedHash, proofElement);
118             } else {
119                 // Hash(current element of the proof + current computed hash)
120                 computedHash = _efficientHash(proofElement, computedHash);
121             }
122         }
123         return computedHash;
124     }
125 
126     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
127         assembly {
128             mstore(0x00, a)
129             mstore(0x20, b)
130             value := keccak256(0x00, 0x40)
131         }
132     }
133 }
134 
135 // File: @openzeppelin/contracts/utils/Strings.sol
136 
137 
138 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
139 
140 pragma solidity ^0.8.0;
141 
142 /**
143  * @dev String operations.
144  */
145 library Strings {
146     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
147 
148     /**
149      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
150      */
151     function toString(uint256 value) internal pure returns (string memory) {
152         // Inspired by OraclizeAPI's implementation - MIT licence
153         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
154 
155         if (value == 0) {
156             return "0";
157         }
158         uint256 temp = value;
159         uint256 digits;
160         while (temp != 0) {
161             digits++;
162             temp /= 10;
163         }
164         bytes memory buffer = new bytes(digits);
165         while (value != 0) {
166             digits -= 1;
167             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
168             value /= 10;
169         }
170         return string(buffer);
171     }
172 
173     /**
174      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
175      */
176     function toHexString(uint256 value) internal pure returns (string memory) {
177         if (value == 0) {
178             return "0x00";
179         }
180         uint256 temp = value;
181         uint256 length = 0;
182         while (temp != 0) {
183             length++;
184             temp >>= 8;
185         }
186         return toHexString(value, length);
187     }
188 
189     /**
190      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
191      */
192     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
193         bytes memory buffer = new bytes(2 * length + 2);
194         buffer[0] = "0";
195         buffer[1] = "x";
196         for (uint256 i = 2 * length + 1; i > 1; --i) {
197             buffer[i] = _HEX_SYMBOLS[value & 0xf];
198             value >>= 4;
199         }
200         require(value == 0, "Strings: hex length insufficient");
201         return string(buffer);
202     }
203 }
204 
205 // File: @openzeppelin/contracts/utils/Context.sol
206 
207 
208 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
209 
210 pragma solidity ^0.8.0;
211 
212 /**
213  * @dev Provides information about the current execution context, including the
214  * sender of the transaction and its data. While these are generally available
215  * via msg.sender and msg.data, they should not be accessed in such a direct
216  * manner, since when dealing with meta-transactions the account sending and
217  * paying for execution may not be the actual sender (as far as an application
218  * is concerned).
219  *
220  * This contract is only required for intermediate, library-like contracts.
221  */
222 abstract contract Context {
223     function _msgSender() internal view virtual returns (address) {
224         return msg.sender;
225     }
226 
227     function _msgData() internal view virtual returns (bytes calldata) {
228         return msg.data;
229     }
230 }
231 
232 // File: @openzeppelin/contracts/access/Ownable.sol
233 
234 
235 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
236 
237 pragma solidity ^0.8.0;
238 
239 
240 /**
241  * @dev Contract module which provides a basic access control mechanism, where
242  * there is an account (an owner) that can be granted exclusive access to
243  * specific functions.
244  *
245  * By default, the owner account will be the one that deploys the contract. This
246  * can later be changed with {transferOwnership}.
247  *
248  * This module is used through inheritance. It will make available the modifier
249  * `onlyOwner`, which can be applied to your functions to restrict their use to
250  * the owner.
251  */
252 abstract contract Ownable is Context {
253     address private _owner;
254 
255     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
256 
257     /**
258      * @dev Initializes the contract setting the deployer as the initial owner.
259      */
260     constructor() {
261         _transferOwnership(_msgSender());
262     }
263 
264     /**
265      * @dev Returns the address of the current owner.
266      */
267     function owner() public view virtual returns (address) {
268         return _owner;
269     }
270 
271     /**
272      * @dev Throws if called by any account other than the owner.
273      */
274     modifier onlyOwner() {
275         require(owner() == _msgSender(), "Ownable: caller is not the owner");
276         _;
277     }
278 
279     /**
280      * @dev Leaves the contract without owner. It will not be possible to call
281      * `onlyOwner` functions anymore. Can only be called by the current owner.
282      *
283      * NOTE: Renouncing ownership will leave the contract without an owner,
284      * thereby removing any functionality that is only available to the owner.
285      */
286     function renounceOwnership() public virtual onlyOwner {
287         _transferOwnership(address(0));
288     }
289 
290     /**
291      * @dev Transfers ownership of the contract to a new account (`newOwner`).
292      * Can only be called by the current owner.
293      */
294     function transferOwnership(address newOwner) public virtual onlyOwner {
295         require(newOwner != address(0), "Ownable: new owner is the zero address");
296         _transferOwnership(newOwner);
297     }
298 
299     /**
300      * @dev Transfers ownership of the contract to a new account (`newOwner`).
301      * Internal function without access restriction.
302      */
303     function _transferOwnership(address newOwner) internal virtual {
304         address oldOwner = _owner;
305         _owner = newOwner;
306         emit OwnershipTransferred(oldOwner, newOwner);
307     }
308 }
309 
310 // File: @openzeppelin/contracts/utils/Address.sol
311 
312 
313 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
314 
315 pragma solidity ^0.8.1;
316 
317 /**
318  * @dev Collection of functions related to the address type
319  */
320 library Address {
321     /**
322      * @dev Returns true if `account` is a contract.
323      *
324      * [IMPORTANT]
325      * ====
326      * It is unsafe to assume that an address for which this function returns
327      * false is an externally-owned account (EOA) and not a contract.
328      *
329      * Among others, `isContract` will return false for the following
330      * types of addresses:
331      *
332      *  - an externally-owned account
333      *  - a contract in construction
334      *  - an address where a contract will be created
335      *  - an address where a contract lived, but was destroyed
336      * ====
337      *
338      * [IMPORTANT]
339      * ====
340      * You shouldn't rely on `isContract` to protect against flash loan attacks!
341      *
342      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
343      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
344      * constructor.
345      * ====
346      */
347     function isContract(address account) internal view returns (bool) {
348         // This method relies on extcodesize/address.code.length, which returns 0
349         // for contracts in construction, since the code is only stored at the end
350         // of the constructor execution.
351 
352         return account.code.length > 0;
353     }
354 
355     /**
356      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
357      * `recipient`, forwarding all available gas and reverting on errors.
358      *
359      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
360      * of certain opcodes, possibly making contracts go over the 2300 gas limit
361      * imposed by `transfer`, making them unable to receive funds via
362      * `transfer`. {sendValue} removes this limitation.
363      *
364      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
365      *
366      * IMPORTANT: because control is transferred to `recipient`, care must be
367      * taken to not create reentrancy vulnerabilities. Consider using
368      * {ReentrancyGuard} or the
369      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
370      */
371     function sendValue(address payable recipient, uint256 amount) internal {
372         require(address(this).balance >= amount, "Address: insufficient balance");
373 
374         (bool success, ) = recipient.call{value: amount}("");
375         require(success, "Address: unable to send value, recipient may have reverted");
376     }
377 
378     /**
379      * @dev Performs a Solidity function call using a low level `call`. A
380      * plain `call` is an unsafe replacement for a function call: use this
381      * function instead.
382      *
383      * If `target` reverts with a revert reason, it is bubbled up by this
384      * function (like regular Solidity function calls).
385      *
386      * Returns the raw returned data. To convert to the expected return value,
387      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
388      *
389      * Requirements:
390      *
391      * - `target` must be a contract.
392      * - calling `target` with `data` must not revert.
393      *
394      * _Available since v3.1._
395      */
396     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
397         return functionCall(target, data, "Address: low-level call failed");
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
402      * `errorMessage` as a fallback revert reason when `target` reverts.
403      *
404      * _Available since v3.1._
405      */
406     function functionCall(
407         address target,
408         bytes memory data,
409         string memory errorMessage
410     ) internal returns (bytes memory) {
411         return functionCallWithValue(target, data, 0, errorMessage);
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
416      * but also transferring `value` wei to `target`.
417      *
418      * Requirements:
419      *
420      * - the calling contract must have an ETH balance of at least `value`.
421      * - the called Solidity function must be `payable`.
422      *
423      * _Available since v3.1._
424      */
425     function functionCallWithValue(
426         address target,
427         bytes memory data,
428         uint256 value
429     ) internal returns (bytes memory) {
430         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
435      * with `errorMessage` as a fallback revert reason when `target` reverts.
436      *
437      * _Available since v3.1._
438      */
439     function functionCallWithValue(
440         address target,
441         bytes memory data,
442         uint256 value,
443         string memory errorMessage
444     ) internal returns (bytes memory) {
445         require(address(this).balance >= value, "Address: insufficient balance for call");
446         require(isContract(target), "Address: call to non-contract");
447 
448         (bool success, bytes memory returndata) = target.call{value: value}(data);
449         return verifyCallResult(success, returndata, errorMessage);
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
454      * but performing a static call.
455      *
456      * _Available since v3.3._
457      */
458     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
459         return functionStaticCall(target, data, "Address: low-level static call failed");
460     }
461 
462     /**
463      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
464      * but performing a static call.
465      *
466      * _Available since v3.3._
467      */
468     function functionStaticCall(
469         address target,
470         bytes memory data,
471         string memory errorMessage
472     ) internal view returns (bytes memory) {
473         require(isContract(target), "Address: static call to non-contract");
474 
475         (bool success, bytes memory returndata) = target.staticcall(data);
476         return verifyCallResult(success, returndata, errorMessage);
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
481      * but performing a delegate call.
482      *
483      * _Available since v3.4._
484      */
485     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
486         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
487     }
488 
489     /**
490      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
491      * but performing a delegate call.
492      *
493      * _Available since v3.4._
494      */
495     function functionDelegateCall(
496         address target,
497         bytes memory data,
498         string memory errorMessage
499     ) internal returns (bytes memory) {
500         require(isContract(target), "Address: delegate call to non-contract");
501 
502         (bool success, bytes memory returndata) = target.delegatecall(data);
503         return verifyCallResult(success, returndata, errorMessage);
504     }
505 
506     /**
507      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
508      * revert reason using the provided one.
509      *
510      * _Available since v4.3._
511      */
512     function verifyCallResult(
513         bool success,
514         bytes memory returndata,
515         string memory errorMessage
516     ) internal pure returns (bytes memory) {
517         if (success) {
518             return returndata;
519         } else {
520             // Look for revert reason and bubble it up if present
521             if (returndata.length > 0) {
522                 // The easiest way to bubble the revert reason is using memory via assembly
523 
524                 assembly {
525                     let returndata_size := mload(returndata)
526                     revert(add(32, returndata), returndata_size)
527                 }
528             } else {
529                 revert(errorMessage);
530             }
531         }
532     }
533 }
534 
535 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
536 
537 
538 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
539 
540 pragma solidity ^0.8.0;
541 
542 /**
543  * @title ERC721 token receiver interface
544  * @dev Interface for any contract that wants to support safeTransfers
545  * from ERC721 asset contracts.
546  */
547 interface IERC721Receiver {
548     /**
549      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
550      * by `operator` from `from`, this function is called.
551      *
552      * It must return its Solidity selector to confirm the token transfer.
553      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
554      *
555      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
556      */
557     function onERC721Received(
558         address operator,
559         address from,
560         uint256 tokenId,
561         bytes calldata data
562     ) external returns (bytes4);
563 }
564 
565 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
566 
567 
568 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
569 
570 pragma solidity ^0.8.0;
571 
572 /**
573  * @dev Interface of the ERC165 standard, as defined in the
574  * https://eips.ethereum.org/EIPS/eip-165[EIP].
575  *
576  * Implementers can declare support of contract interfaces, which can then be
577  * queried by others ({ERC165Checker}).
578  *
579  * For an implementation, see {ERC165}.
580  */
581 interface IERC165 {
582     /**
583      * @dev Returns true if this contract implements the interface defined by
584      * `interfaceId`. See the corresponding
585      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
586      * to learn more about how these ids are created.
587      *
588      * This function call must use less than 30 000 gas.
589      */
590     function supportsInterface(bytes4 interfaceId) external view returns (bool);
591 }
592 
593 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
594 
595 
596 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
597 
598 pragma solidity ^0.8.0;
599 
600 
601 /**
602  * @dev Interface for the NFT Royalty Standard.
603  *
604  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
605  * support for royalty payments across all NFT marketplaces and ecosystem participants.
606  *
607  * _Available since v4.5._
608  */
609 interface IERC2981 is IERC165 {
610     /**
611      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
612      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
613      */
614     function royaltyInfo(uint256 tokenId, uint256 salePrice)
615         external
616         view
617         returns (address receiver, uint256 royaltyAmount);
618 }
619 
620 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
621 
622 
623 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
624 
625 pragma solidity ^0.8.0;
626 
627 
628 /**
629  * @dev Implementation of the {IERC165} interface.
630  *
631  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
632  * for the additional interface id that will be supported. For example:
633  *
634  * ```solidity
635  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
636  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
637  * }
638  * ```
639  *
640  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
641  */
642 abstract contract ERC165 is IERC165 {
643     /**
644      * @dev See {IERC165-supportsInterface}.
645      */
646     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
647         return interfaceId == type(IERC165).interfaceId;
648     }
649 }
650 
651 // File: @openzeppelin/contracts/token/common/ERC2981.sol
652 
653 
654 // OpenZeppelin Contracts (last updated v4.6.0) (token/common/ERC2981.sol)
655 
656 pragma solidity ^0.8.0;
657 
658 
659 
660 /**
661  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
662  *
663  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
664  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
665  *
666  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
667  * fee is specified in basis points by default.
668  *
669  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
670  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
671  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
672  *
673  * _Available since v4.5._
674  */
675 abstract contract ERC2981 is IERC2981, ERC165 {
676     struct RoyaltyInfo {
677         address receiver;
678         uint96 royaltyFraction;
679     }
680 
681     RoyaltyInfo private _defaultRoyaltyInfo;
682     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
683 
684     /**
685      * @dev See {IERC165-supportsInterface}.
686      */
687     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
688         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
689     }
690 
691     /**
692      * @inheritdoc IERC2981
693      */
694     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
695         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
696 
697         if (royalty.receiver == address(0)) {
698             royalty = _defaultRoyaltyInfo;
699         }
700 
701         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
702 
703         return (royalty.receiver, royaltyAmount);
704     }
705 
706     /**
707      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
708      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
709      * override.
710      */
711     function _feeDenominator() internal pure virtual returns (uint96) {
712         return 10000;
713     }
714 
715     /**
716      * @dev Sets the royalty information that all ids in this contract will default to.
717      *
718      * Requirements:
719      *
720      * - `receiver` cannot be the zero address.
721      * - `feeNumerator` cannot be greater than the fee denominator.
722      */
723     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
724         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
725         require(receiver != address(0), "ERC2981: invalid receiver");
726 
727         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
728     }
729 
730     /**
731      * @dev Removes default royalty information.
732      */
733     function _deleteDefaultRoyalty() internal virtual {
734         delete _defaultRoyaltyInfo;
735     }
736 
737     /**
738      * @dev Sets the royalty information for a specific token id, overriding the global default.
739      *
740      * Requirements:
741      *
742      * - `tokenId` must be already minted.
743      * - `receiver` cannot be the zero address.
744      * - `feeNumerator` cannot be greater than the fee denominator.
745      */
746     function _setTokenRoyalty(
747         uint256 tokenId,
748         address receiver,
749         uint96 feeNumerator
750     ) internal virtual {
751         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
752         require(receiver != address(0), "ERC2981: Invalid parameters");
753 
754         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
755     }
756 
757     /**
758      * @dev Resets royalty information for the token id back to the global default.
759      */
760     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
761         delete _tokenRoyaltyInfo[tokenId];
762     }
763 }
764 
765 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
766 
767 
768 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
769 
770 pragma solidity ^0.8.0;
771 
772 
773 /**
774  * @dev Required interface of an ERC721 compliant contract.
775  */
776 interface IERC721 is IERC165 {
777     /**
778      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
779      */
780     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
781 
782     /**
783      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
784      */
785     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
786 
787     /**
788      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
789      */
790     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
791 
792     /**
793      * @dev Returns the number of tokens in ``owner``'s account.
794      */
795     function balanceOf(address owner) external view returns (uint256 balance);
796 
797     /**
798      * @dev Returns the owner of the `tokenId` token.
799      *
800      * Requirements:
801      *
802      * - `tokenId` must exist.
803      */
804     function ownerOf(uint256 tokenId) external view returns (address owner);
805 
806     /**
807      * @dev Safely transfers `tokenId` token from `from` to `to`.
808      *
809      * Requirements:
810      *
811      * - `from` cannot be the zero address.
812      * - `to` cannot be the zero address.
813      * - `tokenId` token must exist and be owned by `from`.
814      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
815      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
816      *
817      * Emits a {Transfer} event.
818      */
819     function safeTransferFrom(
820         address from,
821         address to,
822         uint256 tokenId,
823         bytes calldata data
824     ) external;
825 
826     /**
827      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
828      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
829      *
830      * Requirements:
831      *
832      * - `from` cannot be the zero address.
833      * - `to` cannot be the zero address.
834      * - `tokenId` token must exist and be owned by `from`.
835      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
836      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
837      *
838      * Emits a {Transfer} event.
839      */
840     function safeTransferFrom(
841         address from,
842         address to,
843         uint256 tokenId
844     ) external;
845 
846     /**
847      * @dev Transfers `tokenId` token from `from` to `to`.
848      *
849      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
850      *
851      * Requirements:
852      *
853      * - `from` cannot be the zero address.
854      * - `to` cannot be the zero address.
855      * - `tokenId` token must be owned by `from`.
856      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
857      *
858      * Emits a {Transfer} event.
859      */
860     function transferFrom(
861         address from,
862         address to,
863         uint256 tokenId
864     ) external;
865 
866     /**
867      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
868      * The approval is cleared when the token is transferred.
869      *
870      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
871      *
872      * Requirements:
873      *
874      * - The caller must own the token or be an approved operator.
875      * - `tokenId` must exist.
876      *
877      * Emits an {Approval} event.
878      */
879     function approve(address to, uint256 tokenId) external;
880 
881     /**
882      * @dev Approve or remove `operator` as an operator for the caller.
883      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
884      *
885      * Requirements:
886      *
887      * - The `operator` cannot be the caller.
888      *
889      * Emits an {ApprovalForAll} event.
890      */
891     function setApprovalForAll(address operator, bool _approved) external;
892 
893     /**
894      * @dev Returns the account approved for `tokenId` token.
895      *
896      * Requirements:
897      *
898      * - `tokenId` must exist.
899      */
900     function getApproved(uint256 tokenId) external view returns (address operator);
901 
902     /**
903      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
904      *
905      * See {setApprovalForAll}
906      */
907     function isApprovedForAll(address owner, address operator) external view returns (bool);
908 }
909 
910 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
911 
912 
913 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
914 
915 pragma solidity ^0.8.0;
916 
917 
918 /**
919  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
920  * @dev See https://eips.ethereum.org/EIPS/eip-721
921  */
922 interface IERC721Metadata is IERC721 {
923     /**
924      * @dev Returns the token collection name.
925      */
926     function name() external view returns (string memory);
927 
928     /**
929      * @dev Returns the token collection symbol.
930      */
931     function symbol() external view returns (string memory);
932 
933     /**
934      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
935      */
936     function tokenURI(uint256 tokenId) external view returns (string memory);
937 }
938 
939 // File: contracts/ERC721A.sol
940 
941 
942 // Creator: Chiru Labs
943 
944 pragma solidity ^0.8.4;
945 
946 
947 
948 
949 
950 
951 
952 
953 error ApprovalCallerNotOwnerNorApproved();
954 error ApprovalQueryForNonexistentToken();
955 error ApproveToCaller();
956 error ApprovalToCurrentOwner();
957 error BalanceQueryForZeroAddress();
958 error MintToZeroAddress();
959 error MintZeroQuantity();
960 error OwnerQueryForNonexistentToken();
961 error TransferCallerNotOwnerNorApproved();
962 error TransferFromIncorrectOwner();
963 error TransferToNonERC721ReceiverImplementer();
964 error TransferToZeroAddress();
965 error URIQueryForNonexistentToken();
966 
967 /**
968  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
969  * the Metadata extension. Built to optimize for lower gas during batch mints.
970  *
971  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
972  *
973  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
974  *
975  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
976  */
977 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
978     using Address for address;
979     using Strings for uint256;
980 
981     // Compiler will pack this into a single 256bit word.
982     struct TokenOwnership {
983         // The address of the owner.
984         address addr;
985         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
986         uint64 startTimestamp;
987         // Whether the token has been burned.
988         bool burned;
989     }
990 
991     // Compiler will pack this into a single 256bit word.
992     struct AddressData {
993         // Realistically, 2**64-1 is more than enough.
994         uint64 balance;
995         // Keeps track of mint count with minimal overhead for tokenomics.
996         uint64 numberMinted;
997         // Keeps track of burn count with minimal overhead for tokenomics.
998         uint64 numberBurned;
999         // For miscellaneous variable(s) pertaining to the address
1000         // (e.g. number of whitelist mint slots used).
1001         // If there are multiple variables, please pack them into a uint64.
1002         uint64 aux;
1003     }
1004 
1005     // The tokenId of the next token to be minted.
1006     uint256 internal _currentIndex;
1007 
1008     // The number of tokens burned.
1009     uint256 internal _burnCounter;
1010 
1011     // Token name
1012     string private _name;
1013 
1014     // Token symbol
1015     string private _symbol;
1016 
1017     // Mapping from token ID to ownership details
1018     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1019     mapping(uint256 => TokenOwnership) internal _ownerships;
1020 
1021     // Mapping owner address to address data
1022     mapping(address => AddressData) private _addressData;
1023 
1024     // Mapping from token ID to approved address
1025     mapping(uint256 => address) private _tokenApprovals;
1026 
1027     // Mapping from owner to operator approvals
1028     mapping(address => mapping(address => bool)) private _operatorApprovals;
1029 
1030     constructor(string memory name_, string memory symbol_) {
1031         _name = name_;
1032         _symbol = symbol_;
1033         _currentIndex = _startTokenId();
1034     }
1035 
1036     /**
1037      * To change the starting tokenId, please override this function.
1038      */
1039     function _startTokenId() internal view virtual returns (uint256) {
1040         return 0;
1041     }
1042 
1043     /**
1044      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1045      */
1046     function totalSupply() public view returns (uint256) {
1047         // Counter underflow is impossible as _burnCounter cannot be incremented
1048         // more than _currentIndex - _startTokenId() times
1049         unchecked {
1050             return _currentIndex - _burnCounter - _startTokenId();
1051         }
1052     }
1053 
1054     /**
1055      * Returns the total amount of tokens minted in the contract.
1056      */
1057     function _totalMinted() internal view returns (uint256) {
1058         // Counter underflow is impossible as _currentIndex does not decrement,
1059         // and it is initialized to _startTokenId()
1060         unchecked {
1061             return _currentIndex - _startTokenId();
1062         }
1063     }
1064 
1065     /**
1066      * @dev See {IERC165-supportsInterface}.
1067      */
1068     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1069         return
1070             interfaceId == type(IERC721).interfaceId ||
1071             interfaceId == type(IERC721Metadata).interfaceId ||
1072             super.supportsInterface(interfaceId);
1073     }
1074 
1075     /**
1076      * @dev See {IERC721-balanceOf}.
1077      */
1078     function balanceOf(address owner) public view override returns (uint256) {
1079         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1080         return uint256(_addressData[owner].balance);
1081     }
1082 
1083     /**
1084      * Returns the number of tokens minted by `owner`.
1085      */
1086     function _numberMinted(address owner) internal view returns (uint256) {
1087         return uint256(_addressData[owner].numberMinted);
1088     }
1089 
1090     /**
1091      * Returns the number of tokens burned by or on behalf of `owner`.
1092      */
1093     function _numberBurned(address owner) internal view returns (uint256) {
1094         return uint256(_addressData[owner].numberBurned);
1095     }
1096 
1097     /**
1098      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1099      */
1100     function _getAux(address owner) internal view returns (uint64) {
1101         return _addressData[owner].aux;
1102     }
1103 
1104     /**
1105      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1106      * If there are multiple variables, please pack them into a uint64.
1107      */
1108     function _setAux(address owner, uint64 aux) internal {
1109         _addressData[owner].aux = aux;
1110     }
1111 
1112     /**
1113      * Gas spent here starts off proportional to the maximum mint batch size.
1114      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1115      */
1116     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1117         uint256 curr = tokenId;
1118 
1119         unchecked {
1120             if (_startTokenId() <= curr && curr < _currentIndex) {
1121                 TokenOwnership memory ownership = _ownerships[curr];
1122                 if (!ownership.burned) {
1123                     if (ownership.addr != address(0)) {
1124                         return ownership;
1125                     }
1126                     // Invariant:
1127                     // There will always be an ownership that has an address and is not burned
1128                     // before an ownership that does not have an address and is not burned.
1129                     // Hence, curr will not underflow.
1130                     while (true) {
1131                         curr--;
1132                         ownership = _ownerships[curr];
1133                         if (ownership.addr != address(0)) {
1134                             return ownership;
1135                         }
1136                     }
1137                 }
1138             }
1139         }
1140         revert OwnerQueryForNonexistentToken();
1141     }
1142 
1143     /**
1144      * @dev See {IERC721-ownerOf}.
1145      */
1146     function ownerOf(uint256 tokenId) public view override returns (address) {
1147         return _ownershipOf(tokenId).addr;
1148     }
1149 
1150     /**
1151      * @dev See {IERC721Metadata-name}.
1152      */
1153     function name() public view virtual override returns (string memory) {
1154         return _name;
1155     }
1156 
1157     /**
1158      * @dev See {IERC721Metadata-symbol}.
1159      */
1160     function symbol() public view virtual override returns (string memory) {
1161         return _symbol;
1162     }
1163 
1164     /**
1165      * @dev See {IERC721Metadata-tokenURI}.
1166      */
1167     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1168         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1169 
1170         string memory baseURI = _baseURI();
1171         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1172     }
1173 
1174     /**
1175      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1176      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1177      * by default, can be overriden in child contracts.
1178      */
1179     function _baseURI() internal view virtual returns (string memory) {
1180         return '';
1181     }
1182 
1183     /**
1184      * @dev See {IERC721-approve}.
1185      */
1186     function approve(address to, uint256 tokenId) public override {
1187         address owner = ERC721A.ownerOf(tokenId);
1188         if (to == owner) revert ApprovalToCurrentOwner();
1189 
1190         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1191             revert ApprovalCallerNotOwnerNorApproved();
1192         }
1193 
1194         _approve(to, tokenId, owner);
1195     }
1196 
1197     /**
1198      * @dev See {IERC721-getApproved}.
1199      */
1200     function getApproved(uint256 tokenId) public view override returns (address) {
1201         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1202 
1203         return _tokenApprovals[tokenId];
1204     }
1205 
1206     /**
1207      * @dev See {IERC721-setApprovalForAll}.
1208      */
1209     function setApprovalForAll(address operator, bool approved) public virtual override {
1210         if (operator == _msgSender()) revert ApproveToCaller();
1211 
1212         _operatorApprovals[_msgSender()][operator] = approved;
1213         emit ApprovalForAll(_msgSender(), operator, approved);
1214     }
1215 
1216     /**
1217      * @dev See {IERC721-isApprovedForAll}.
1218      */
1219     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1220         return _operatorApprovals[owner][operator];
1221     }
1222 
1223     /**
1224      * @dev See {IERC721-transferFrom}.
1225      */
1226     function transferFrom(
1227         address from,
1228         address to,
1229         uint256 tokenId
1230     ) public virtual override {
1231         _transfer(from, to, tokenId);
1232     }
1233 
1234     /**
1235      * @dev See {IERC721-safeTransferFrom}.
1236      */
1237     function safeTransferFrom(
1238         address from,
1239         address to,
1240         uint256 tokenId
1241     ) public virtual override {
1242         safeTransferFrom(from, to, tokenId, '');
1243     }
1244 
1245     /**
1246      * @dev See {IERC721-safeTransferFrom}.
1247      */
1248     function safeTransferFrom(
1249         address from,
1250         address to,
1251         uint256 tokenId,
1252         bytes memory _data
1253     ) public virtual override {
1254         _transfer(from, to, tokenId);
1255         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1256             revert TransferToNonERC721ReceiverImplementer();
1257         }
1258     }
1259 
1260     /**
1261      * @dev Returns whether `tokenId` exists.
1262      *
1263      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1264      *
1265      * Tokens start existing when they are minted (`_mint`),
1266      */
1267     function _exists(uint256 tokenId) internal view returns (bool) {
1268         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1269             !_ownerships[tokenId].burned;
1270     }
1271 
1272     function _safeMint(address to, uint256 quantity) internal {
1273         _safeMint(to, quantity, '');
1274     }
1275 
1276     /**
1277      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1278      *
1279      * Requirements:
1280      *
1281      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1282      * - `quantity` must be greater than 0.
1283      *
1284      * Emits a {Transfer} event.
1285      */
1286     function _safeMint(
1287         address to,
1288         uint256 quantity,
1289         bytes memory _data
1290     ) internal {
1291         _mint(to, quantity, _data, true);
1292     }
1293 
1294     /**
1295      * @dev Mints `quantity` tokens and transfers them to `to`.
1296      *
1297      * Requirements:
1298      *
1299      * - `to` cannot be the zero address.
1300      * - `quantity` must be greater than 0.
1301      *
1302      * Emits a {Transfer} event.
1303      */
1304     function _mint(
1305         address to,
1306         uint256 quantity,
1307         bytes memory _data,
1308         bool safe
1309     ) internal {
1310         uint256 startTokenId = _currentIndex;
1311         if (to == address(0)) revert MintToZeroAddress();
1312         if (quantity == 0) revert MintZeroQuantity();
1313 
1314         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1315 
1316         // Overflows are incredibly unrealistic.
1317         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1318         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1319         unchecked {
1320             _addressData[to].balance += uint64(quantity);
1321             _addressData[to].numberMinted += uint64(quantity);
1322 
1323             _ownerships[startTokenId].addr = to;
1324             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1325 
1326             uint256 updatedIndex = startTokenId;
1327             uint256 end = updatedIndex + quantity;
1328 
1329             if (safe && to.isContract()) {
1330                 do {
1331                     emit Transfer(address(0), to, updatedIndex);
1332                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1333                         revert TransferToNonERC721ReceiverImplementer();
1334                     }
1335                 } while (updatedIndex != end);
1336                 // Reentrancy protection
1337                 if (_currentIndex != startTokenId) revert();
1338             } else {
1339                 do {
1340                     emit Transfer(address(0), to, updatedIndex++);
1341                 } while (updatedIndex != end);
1342             }
1343             _currentIndex = updatedIndex;
1344         }
1345         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1346     }
1347 
1348     /**
1349      * @dev Transfers `tokenId` from `from` to `to`.
1350      *
1351      * Requirements:
1352      *
1353      * - `to` cannot be the zero address.
1354      * - `tokenId` token must be owned by `from`.
1355      *
1356      * Emits a {Transfer} event.
1357      */
1358     function _transfer(
1359         address from,
1360         address to,
1361         uint256 tokenId
1362     ) private {
1363         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1364 
1365         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1366 
1367         bool isApprovedOrOwner = (_msgSender() == from ||
1368             isApprovedForAll(from, _msgSender()) ||
1369             getApproved(tokenId) == _msgSender());
1370 
1371         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1372         if (to == address(0)) revert TransferToZeroAddress();
1373 
1374         _beforeTokenTransfers(from, to, tokenId, 1);
1375 
1376         // Clear approvals from the previous owner
1377         _approve(address(0), tokenId, from);
1378 
1379         // Underflow of the sender's balance is impossible because we check for
1380         // ownership above and the recipient's balance can't realistically overflow.
1381         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1382         unchecked {
1383             _addressData[from].balance -= 1;
1384             _addressData[to].balance += 1;
1385 
1386             TokenOwnership storage currSlot = _ownerships[tokenId];
1387             currSlot.addr = to;
1388             currSlot.startTimestamp = uint64(block.timestamp);
1389 
1390             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1391             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1392             uint256 nextTokenId = tokenId + 1;
1393             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1394             if (nextSlot.addr == address(0)) {
1395                 // This will suffice for checking _exists(nextTokenId),
1396                 // as a burned slot cannot contain the zero address.
1397                 if (nextTokenId != _currentIndex) {
1398                     nextSlot.addr = from;
1399                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1400                 }
1401             }
1402         }
1403 
1404         emit Transfer(from, to, tokenId);
1405         _afterTokenTransfers(from, to, tokenId, 1);
1406     }
1407 
1408     /**
1409      * @dev This is equivalent to _burn(tokenId, false)
1410      */
1411     function _burn(uint256 tokenId) internal virtual {
1412         _burn(tokenId, false);
1413     }
1414 
1415     /**
1416      * @dev Destroys `tokenId`.
1417      * The approval is cleared when the token is burned.
1418      *
1419      * Requirements:
1420      *
1421      * - `tokenId` must exist.
1422      *
1423      * Emits a {Transfer} event.
1424      */
1425     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1426         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1427 
1428         address from = prevOwnership.addr;
1429 
1430         if (approvalCheck) {
1431             bool isApprovedOrOwner = (_msgSender() == from ||
1432                 isApprovedForAll(from, _msgSender()) ||
1433                 getApproved(tokenId) == _msgSender());
1434 
1435             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1436         }
1437 
1438         _beforeTokenTransfers(from, address(0), tokenId, 1);
1439 
1440         // Clear approvals from the previous owner
1441         _approve(address(0), tokenId, from);
1442 
1443         // Underflow of the sender's balance is impossible because we check for
1444         // ownership above and the recipient's balance can't realistically overflow.
1445         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1446         unchecked {
1447             AddressData storage addressData = _addressData[from];
1448             addressData.balance -= 1;
1449             addressData.numberBurned += 1;
1450 
1451             // Keep track of who burned the token, and the timestamp of burning.
1452             TokenOwnership storage currSlot = _ownerships[tokenId];
1453             currSlot.addr = from;
1454             currSlot.startTimestamp = uint64(block.timestamp);
1455             currSlot.burned = true;
1456 
1457             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1458             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1459             uint256 nextTokenId = tokenId + 1;
1460             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1461             if (nextSlot.addr == address(0)) {
1462                 // This will suffice for checking _exists(nextTokenId),
1463                 // as a burned slot cannot contain the zero address.
1464                 if (nextTokenId != _currentIndex) {
1465                     nextSlot.addr = from;
1466                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1467                 }
1468             }
1469         }
1470 
1471         emit Transfer(from, address(0), tokenId);
1472         _afterTokenTransfers(from, address(0), tokenId, 1);
1473 
1474         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1475         unchecked {
1476             _burnCounter++;
1477         }
1478     }
1479 
1480     /**
1481      * @dev Approve `to` to operate on `tokenId`
1482      *
1483      * Emits a {Approval} event.
1484      */
1485     function _approve(
1486         address to,
1487         uint256 tokenId,
1488         address owner
1489     ) private {
1490         _tokenApprovals[tokenId] = to;
1491         emit Approval(owner, to, tokenId);
1492     }
1493 
1494     /**
1495      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1496      *
1497      * @param from address representing the previous owner of the given token ID
1498      * @param to target address that will receive the tokens
1499      * @param tokenId uint256 ID of the token to be transferred
1500      * @param _data bytes optional data to send along with the call
1501      * @return bool whether the call correctly returned the expected magic value
1502      */
1503     function _checkContractOnERC721Received(
1504         address from,
1505         address to,
1506         uint256 tokenId,
1507         bytes memory _data
1508     ) private returns (bool) {
1509         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1510             return retval == IERC721Receiver(to).onERC721Received.selector;
1511         } catch (bytes memory reason) {
1512             if (reason.length == 0) {
1513                 revert TransferToNonERC721ReceiverImplementer();
1514             } else {
1515                 assembly {
1516                     revert(add(32, reason), mload(reason))
1517                 }
1518             }
1519         }
1520     }
1521 
1522     /**
1523      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1524      * And also called before burning one token.
1525      *
1526      * startTokenId - the first token id to be transferred
1527      * quantity - the amount to be transferred
1528      *
1529      * Calling conditions:
1530      *
1531      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1532      * transferred to `to`.
1533      * - When `from` is zero, `tokenId` will be minted for `to`.
1534      * - When `to` is zero, `tokenId` will be burned by `from`.
1535      * - `from` and `to` are never both zero.
1536      */
1537     function _beforeTokenTransfers(
1538         address from,
1539         address to,
1540         uint256 startTokenId,
1541         uint256 quantity
1542     ) internal virtual {}
1543 
1544     /**
1545      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1546      * minting.
1547      * And also called after one token has been burned.
1548      *
1549      * startTokenId - the first token id to be transferred
1550      * quantity - the amount to be transferred
1551      *
1552      * Calling conditions:
1553      *
1554      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1555      * transferred to `to`.
1556      * - When `from` is zero, `tokenId` has been minted for `to`.
1557      * - When `to` is zero, `tokenId` has been burned by `from`.
1558      * - `from` and `to` are never both zero.
1559      */
1560     function _afterTokenTransfers(
1561         address from,
1562         address to,
1563         uint256 startTokenId,
1564         uint256 quantity
1565     ) internal virtual {}
1566 }
1567 
1568 // File: contracts/dragonia.sol
1569 
1570 pragma solidity >=0.8.9 <0.9.0;
1571 
1572 
1573 
1574 
1575 
1576 
1577 contract Dragonia is ERC721A, Ownable, ReentrancyGuard {
1578 
1579  using Strings for uint256;
1580 
1581   bytes32 public merkleRoot;
1582   mapping(address => bool) public whitelistClaimed1;
1583 
1584   bytes32 public merkleRoot2;
1585   mapping(address => bool) public whitelistClaimed2;
1586 
1587   bytes32 public merkleRoot3;
1588   mapping(address => bool) public whitelistClaimed3;
1589 
1590   string public uriPrefix = '';
1591   string public uriSuffix = '.json';
1592   string public hiddenMetadataUri;
1593   
1594   uint256 public publicCost;
1595   uint256 public whitelistCost1;
1596   uint256 public whitelistCost2;
1597   uint256 public whitelistCost3;
1598   uint256 public maxSupply;
1599   uint256 public maxMintAmountPerTx1;
1600   uint256 public maxMintAmountPerTx2;
1601   uint256 public maxMintAmountPerTx3;
1602   uint256 public maxMintAmountPerTx4;
1603 
1604   bool public paused = true;
1605   bool public whitelistMint1Enabled = false;
1606   bool public whitelistMint2Enabled = false;
1607   bool public whitelistMint3Enabled = false;
1608   bool public revealed = true;
1609 
1610   constructor(
1611     string memory _tokenName,
1612     string memory _tokenSymbol,
1613     // uint256 _whitelistCost1,
1614     // uint256 _whitelistCost2,
1615     // uint256 _whitelistCost3,
1616     // uint256 _publicCost,
1617     uint256 _maxSupply,
1618     // uint256 _maxMintAmountPerTx1,
1619     // uint256 _maxMintAmountPerTx2,
1620     // uint256 _maxMintAmountPerTx3,
1621     // uint256 _maxMintAmountPerTx4,
1622     string memory _uriPrefix,
1623     string memory _hiddenMetadataUri,
1624     bytes32 _merkleRoot,
1625     bytes32 _merkleRoot1,
1626     bytes32 _merkleRoot2
1627   ) ERC721A(_tokenName, _tokenSymbol) {
1628     // setCost1(_whitelistCost1);
1629     // setCost2(_whitelistCost2);
1630     // setCost3(_whitelistCost3);
1631     maxSupply = _maxSupply;
1632     // setMaxMintAmountPerTx1(_maxMintAmountPerTx1);
1633     // setMaxMintAmountPerTx2(_maxMintAmountPerTx2);
1634     // setMaxMintAmountPerTx3(_maxMintAmountPerTx3);
1635     // setMaxMintAmountPerTx4(_maxMintAmountPerTx4);
1636     setHiddenMetadataUri(_hiddenMetadataUri);
1637     setUriPrefix(_uriPrefix);
1638     setMerkleRoot1(_merkleRoot);
1639     setMerkleRoot2(_merkleRoot1);
1640     setMerkleRoot3(_merkleRoot2);
1641   }
1642 
1643   modifier mintCompliancePublic(uint256 _mintAmount) {
1644     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx4, 'Invalid mint amount!');
1645     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1646     _;
1647   }
1648 
1649   modifier mintPriceCompliancePublic(uint256 _mintAmount) {
1650     require(msg.value >= publicCost * _mintAmount, 'Insufficient funds!');
1651     _;
1652   }
1653 
1654   modifier mintComplianceWhitelist1(uint256 _mintAmount) {
1655     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx1, 'Invalid mint amount!');
1656     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1657     _;
1658   }
1659 
1660   modifier mintPriceComplianceWhitelist1(uint256 _mintAmount) {
1661     require(msg.value >= whitelistCost1 * _mintAmount, 'Insufficient funds!');
1662     _;
1663   }
1664 
1665   modifier mintComplianceWhitelist2(uint256 _mintAmount) {
1666     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx2, 'Invalid mint amount!');
1667     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1668     _;
1669   }
1670 
1671   modifier mintPriceComplianceWhitelist2(uint256 _mintAmount) {
1672     require(msg.value >= whitelistCost2 * _mintAmount, 'Insufficient funds!');
1673     _;
1674   }
1675 
1676    modifier mintComplianceWhitelist3(uint256 _mintAmount) {
1677     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx3, 'Invalid mint amount!');
1678     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1679     _;
1680   }
1681 
1682   modifier mintPriceComplianceWhitelist3(uint256 _mintAmount) {
1683     require(msg.value >= whitelistCost3 * _mintAmount, 'Insufficient funds!');
1684     _;
1685   }
1686   
1687   function setRevealed(bool _state) public onlyOwner {
1688     revealed = _state;
1689   }
1690 
1691    function setCost1(uint256 _cost) public onlyOwner {
1692     whitelistCost1 = _cost;
1693   }
1694 
1695    function setCost2(uint256 _cost) public onlyOwner {
1696     whitelistCost2 = _cost;
1697   }
1698 
1699   function setCost3(uint256 _cost) public onlyOwner {
1700     whitelistCost3 = _cost;
1701   }
1702 
1703   function setMaxMintAmountPerTx1(uint256 _maxMintAmountPerTx) public onlyOwner {
1704     maxMintAmountPerTx1 = _maxMintAmountPerTx;
1705   }
1706   function setMaxMintAmountPerTx2(uint256 _maxMintAmountPerTx) public onlyOwner {
1707     maxMintAmountPerTx2 = _maxMintAmountPerTx;
1708   }
1709 
1710   function setMaxMintAmountPerTx3(uint256 _maxMintAmountPerTx) public onlyOwner {
1711     maxMintAmountPerTx3 = _maxMintAmountPerTx;
1712   }
1713 
1714   function setMaxMintAmountPerTx4(uint256 _maxMintAmountPerTx) public onlyOwner {
1715     maxMintAmountPerTx4 = _maxMintAmountPerTx;
1716   }
1717   
1718   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1719     hiddenMetadataUri = _hiddenMetadataUri;
1720   }
1721 
1722   function setMerkleRoot1(bytes32 _merkleRoot) public onlyOwner {
1723     merkleRoot = _merkleRoot;
1724   }
1725 
1726   function setMerkleRoot2(bytes32 _merkleRoot) public onlyOwner {
1727     merkleRoot2 = _merkleRoot;
1728   }
1729 
1730   function setMerkleRoot3(bytes32 _merkleRoot) public onlyOwner {
1731     merkleRoot3 = _merkleRoot;
1732   }
1733 
1734   function setWhitelist1MintEnabled(bool _state,uint _cost, uint _maxMintAmountPerTx1) public onlyOwner {
1735     setCost1(_cost);
1736     setMaxMintAmountPerTx1(_maxMintAmountPerTx1);
1737     whitelistMint1Enabled = _state;
1738   }
1739 
1740   function setWhitelist2MintEnabled(bool _state,uint _cost, uint _maxMintAmountPerTx2) public onlyOwner {
1741     setCost2(_cost);
1742     setMaxMintAmountPerTx2(_maxMintAmountPerTx2);
1743     whitelistMint1Enabled = false;
1744     whitelistMint2Enabled = _state;
1745   }
1746 
1747   function setWhitelist3MintEnabled(bool _state,uint _cost, uint _maxMintAmountPerTx3) public onlyOwner {
1748     setCost3(_cost);
1749     setMaxMintAmountPerTx3(_maxMintAmountPerTx3);
1750     whitelistMint2Enabled = false;
1751     whitelistMint3Enabled = _state;
1752   }
1753 
1754   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1755     uriPrefix = _uriPrefix;
1756   }
1757 
1758   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1759     uriSuffix = _uriSuffix;
1760   }
1761 
1762   function setPaused(bool _state,uint _cost, uint _maxMintAmountPerTx4) public onlyOwner {
1763     publicCost = _cost;
1764     setMaxMintAmountPerTx4(_maxMintAmountPerTx4);
1765     whitelistMint1Enabled = false;
1766     whitelistMint2Enabled = false;
1767     whitelistMint3Enabled = false;
1768     paused = _state;
1769   }
1770 
1771   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1772     uint256 ownerTokenCount = balanceOf(_owner);
1773     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1774     uint256 currentTokenId = _startTokenId();
1775     uint256 ownedTokenIndex = 0;
1776     address latestOwnerAddress;
1777 
1778     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1779       TokenOwnership memory ownership = _ownerships[currentTokenId];
1780 
1781       if (!ownership.burned && ownership.addr != address(0)) {
1782         latestOwnerAddress = ownership.addr;
1783       }
1784 
1785       if (latestOwnerAddress == _owner) {
1786         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1787 
1788         ownedTokenIndex++;
1789       }
1790 
1791       currentTokenId++;
1792     }
1793 
1794     return ownedTokenIds;
1795   }
1796 
1797   function _startTokenId() internal view virtual override returns (uint256) {
1798     return 1;
1799   }
1800 
1801   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1802     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1803 
1804     if (revealed == false) {
1805       return hiddenMetadataUri;
1806     }
1807 
1808     string memory currentBaseURI = _baseURI();
1809     return bytes(currentBaseURI).length > 0
1810         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1811         : '';
1812   }
1813 
1814   function mint(uint256 _mintAmount) public payable mintCompliancePublic(_mintAmount) mintPriceCompliancePublic(_mintAmount) {
1815     require(!paused, 'The contract is paused!');
1816 
1817     _safeMint(_msgSender(), _mintAmount);
1818   }
1819 
1820     function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
1821     _safeMint(_receiver, _mintAmount);
1822   }
1823 
1824     function whitelist1Mint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable mintComplianceWhitelist1(_mintAmount) mintPriceComplianceWhitelist1(_mintAmount) {
1825     // Verify whitelist requirements
1826     require(whitelistMint1Enabled, 'The whitelist sale is not enabled!');
1827     require(!whitelistClaimed1[_msgSender()], 'Address already claimed!');
1828     bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
1829     require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), 'Invalid proof!');
1830 
1831     whitelistClaimed1[_msgSender()] = true;
1832     _safeMint(_msgSender(), _mintAmount);
1833   }
1834 
1835   function whitelist2Mint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable mintComplianceWhitelist2(_mintAmount) mintPriceComplianceWhitelist2(_mintAmount) {
1836     // Verify whitelist requirements
1837     require(whitelistMint2Enabled, 'The whitelist sale is not enabled!');
1838     require(!whitelistClaimed2[_msgSender()], 'Address already claimed!');
1839     bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
1840     require(MerkleProof.verify(_merkleProof, merkleRoot2, leaf), 'Invalid proof!');
1841 
1842     whitelistClaimed2[_msgSender()] = true;
1843     _safeMint(_msgSender(), _mintAmount);
1844   }
1845 
1846   function whitelist3Mint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable mintComplianceWhitelist3(_mintAmount) mintPriceComplianceWhitelist3(_mintAmount) {
1847     // Verify whitelist requirements
1848     require(whitelistMint3Enabled, 'The whitelist sale is not enabled!');
1849     require(!whitelistClaimed3[_msgSender()], 'Address already claimed!');
1850     bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
1851     require(MerkleProof.verify(_merkleProof, merkleRoot3, leaf), 'Invalid proof!');
1852 
1853     whitelistClaimed3[_msgSender()] = true;
1854     _safeMint(_msgSender(), _mintAmount);
1855   }
1856 
1857    function withdraw() public onlyOwner nonReentrant {
1858 
1859     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1860     require(os);
1861    
1862   }
1863 
1864   function _baseURI() internal view virtual override returns (string memory) {
1865     return uriPrefix;
1866   }
1867 
1868 }