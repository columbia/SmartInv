1 /**
2  *Submitted for verification at Etherscan.io on 2022-12-09
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
7 
8 
9 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Interface of the ERC165 standard, as defined in the
15  * https://eips.ethereum.org/EIPS/eip-165[EIP].
16  *
17  * Implementers can declare support of contract interfaces, which can then be
18  * queried by others ({ERC165Checker}).
19  *
20  * For an implementation, see {ERC165}.
21  */
22 interface IERC165 {
23     /**
24      * @dev Returns true if this contract implements the interface defined by
25      * `interfaceId`. See the corresponding
26      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
27      * to learn more about how these ids are created.
28      *
29      * This function call must use less than 30 000 gas.
30      */
31     function supportsInterface(bytes4 interfaceId) external view returns (bool);
32 }
33 
34 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
35 
36 
37 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
38 
39 pragma solidity ^0.8.0;
40 
41 
42 /**
43  * @dev Implementation of the {IERC165} interface.
44  *
45  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
46  * for the additional interface id that will be supported. For example:
47  *
48  * ```solidity
49  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
50  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
51  * }
52  * ```
53  *
54  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
55  */
56 abstract contract ERC165 is IERC165 {
57     /**
58      * @dev See {IERC165-supportsInterface}.
59      */
60     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
61         return interfaceId == type(IERC165).interfaceId;
62     }
63 }
64 
65 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
66 
67 
68 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
69 
70 pragma solidity ^0.8.0;
71 
72 
73 /**
74  * @dev Interface for the NFT Royalty Standard.
75  *
76  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
77  * support for royalty payments across all NFT marketplaces and ecosystem participants.
78  *
79  * _Available since v4.5._
80  */
81 interface IERC2981 is IERC165 {
82     /**
83      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
84      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
85      */
86     function royaltyInfo(uint256 tokenId, uint256 salePrice)
87         external
88         view
89         returns (address receiver, uint256 royaltyAmount);
90 }
91 
92 // File: @openzeppelin/contracts/token/common/ERC2981.sol
93 
94 
95 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
96 
97 pragma solidity ^0.8.0;
98 
99 
100 
101 /**
102  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
103  *
104  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
105  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
106  *
107  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
108  * fee is specified in basis points by default.
109  *
110  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
111  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
112  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
113  *
114  * _Available since v4.5._
115  */
116 abstract contract ERC2981 is IERC2981, ERC165 {
117     struct RoyaltyInfo {
118         address receiver;
119         uint96 royaltyFraction;
120     }
121 
122     RoyaltyInfo private _defaultRoyaltyInfo;
123     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
124 
125     /**
126      * @dev See {IERC165-supportsInterface}.
127      */
128     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
129         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
130     }
131 
132     /**
133      * @inheritdoc IERC2981
134      */
135     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
136         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
137 
138         if (royalty.receiver == address(0)) {
139             royalty = _defaultRoyaltyInfo;
140         }
141 
142         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
143 
144         return (royalty.receiver, royaltyAmount);
145     }
146 
147     /**
148      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
149      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
150      * override.
151      */
152     function _feeDenominator() internal pure virtual returns (uint96) {
153         return 10000;
154     }
155 
156     /**
157      * @dev Sets the royalty information that all ids in this contract will default to.
158      *
159      * Requirements:
160      *
161      * - `receiver` cannot be the zero address.
162      * - `feeNumerator` cannot be greater than the fee denominator.
163      */
164     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
165         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
166         require(receiver != address(0), "ERC2981: invalid receiver");
167 
168         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
169     }
170 
171     /**
172      * @dev Removes default royalty information.
173      */
174     function _deleteDefaultRoyalty() internal virtual {
175         delete _defaultRoyaltyInfo;
176     }
177 
178     /**
179      * @dev Sets the royalty information for a specific token id, overriding the global default.
180      *
181      * Requirements:
182      *
183      * - `receiver` cannot be the zero address.
184      * - `feeNumerator` cannot be greater than the fee denominator.
185      */
186     function _setTokenRoyalty(
187         uint256 tokenId,
188         address receiver,
189         uint96 feeNumerator
190     ) internal virtual {
191         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
192         require(receiver != address(0), "ERC2981: Invalid parameters");
193 
194         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
195     }
196 
197     /**
198      * @dev Resets royalty information for the token id back to the global default.
199      */
200     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
201         delete _tokenRoyaltyInfo[tokenId];
202     }
203 }
204 
205 // File: annunakis.sol
206 
207 /**
208  *Submitted for verification at Etherscan.io on 2022-09-13
209 */
210 
211 
212 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
213 
214 
215 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
216 
217 pragma solidity ^0.8.0;
218 
219 /**
220  * @dev These functions deal with verification of Merkle Tree proofs.
221  *
222  * The proofs can be generated using the JavaScript library
223  * https://github.com/miguelmota/merkletreejs[merkletreejs].
224  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
225  *
226  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
227  *
228  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
229  * hashing, or use a hash function other than keccak256 for hashing leaves.
230  * This is because the concatenation of a sorted pair of internal nodes in
231  * the merkle tree could be reinterpreted as a leaf value.
232  */
233 
234 // File: contracts/rose.sol
235 
236 /**
237  *Submitted for verification at Etherscan.io on 2022-07-22
238 */
239 
240 
241 
242 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
243 
244 pragma solidity ^0.8.0;
245 
246 /**
247  * @dev Contract module that helps prevent reentrant calls to a function.
248  *
249  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
250  * available, which can be applied to functions to make sure there are no nested
251  * (reentrant) calls to them.
252  *
253  * Note that because there is a single `nonReentrant` guard, functions marked as
254  * `nonReentrant` may not call one another. This can be worked around by making
255  * those functions `private`, and then adding `external` `nonReentrant` entry
256  * points to them.
257  *
258  * TIP: If you would like to learn more about reentrancy and alternative ways
259  * to protect against it, check out our blog post
260  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
261  */
262 
263 abstract contract ReentrancyGuard {
264     // Booleans are more expensive than uint256 or any type that takes up a full
265     // word because each write operation emits an extra SLOAD to first read the
266     // slot's contents, replace the bits taken up by the boolean, and then write
267     // back. This is the compiler's defense against contract upgrades and
268     // pointer aliasing, and it cannot be disabled.
269 
270     // The values being non-zero value makes deployment a bit more expensive,
271     // but in exchange the refund on every call to nonReentrant will be lower in
272     // amount. Since refunds are capped to a percentage of the total
273     // transaction's gas, it is best to keep them low in cases like this one, to
274     // increase the likelihood of the full refund coming into effect.
275     uint256 private constant _NOT_ENTERED = 1;
276     uint256 private constant _ENTERED = 2;
277 
278     uint256 private _status;
279 
280     constructor() {
281         _status = _NOT_ENTERED;
282     }
283 
284     /**
285      * @dev Prevents a contract from calling itself, directly or indirectly.
286      * Calling a `nonReentrant` function from another `nonReentrant`
287      * function is not supported. It is possible to prevent this from happening
288      * by making the `nonReentrant` function external, and making it call a
289      * `private` function that does the actual work.
290      */
291     modifier nonReentrant() {
292         // On the first call to nonReentrant, _notEntered will be true
293         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
294 
295         // Any calls to nonReentrant after this point will fail
296         _status = _ENTERED;
297 
298         _;
299 
300         // By storing the original value once again, a refund is triggered (see
301         // https://eips.ethereum.org/EIPS/eip-2200)
302         _status = _NOT_ENTERED;
303     }
304 }
305 
306 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
307 
308 
309 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
310 
311 // File: @openzeppelin/contracts/utils/Strings.sol
312 
313 
314 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
315 
316 pragma solidity ^0.8.0;
317 
318 /**
319  * @dev String operations.
320  */
321 library Strings {
322     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
323 
324     /**
325      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
326      */
327     function toString(uint256 value) internal pure returns (string memory) {
328         // Inspired by OraclizeAPI's implementation - MIT licence
329         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
330 
331         if (value == 0) {
332             return "0";
333         }
334         uint256 temp = value;
335         uint256 digits;
336         while (temp != 0) {
337             digits++;
338             temp /= 10;
339         }
340         bytes memory buffer = new bytes(digits);
341         while (value != 0) {
342             digits -= 1;
343             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
344             value /= 10;
345         }
346         return string(buffer);
347     }
348 
349     /**
350      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
351      */
352     function toHexString(uint256 value) internal pure returns (string memory) {
353         if (value == 0) {
354             return "0x00";
355         }
356         uint256 temp = value;
357         uint256 length = 0;
358         while (temp != 0) {
359             length++;
360             temp >>= 8;
361         }
362         return toHexString(value, length);
363     }
364 
365     /**
366      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
367      */
368     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
369         bytes memory buffer = new bytes(2 * length + 2);
370         buffer[0] = "0";
371         buffer[1] = "x";
372         for (uint256 i = 2 * length + 1; i > 1; --i) {
373             buffer[i] = _HEX_SYMBOLS[value & 0xf];
374             value >>= 4;
375         }
376         require(value == 0, "Strings: hex length insufficient");
377         return string(buffer);
378     }
379 }
380 
381 // File: @openzeppelin/contracts/utils/Context.sol
382 
383 
384 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
385 
386 pragma solidity ^0.8.0;
387 
388 /**
389  * @dev Provides information about the current execution context, including the
390  * sender of the transaction and its data. While these are generally available
391  * via msg.sender and msg.data, they should not be accessed in such a direct
392  * manner, since when dealing with meta-transactions the account sending and
393  * paying for execution may not be the actual sender (as far as an application
394  * is concerned).
395  *
396  * This contract is only required for intermediate, library-like contracts.
397  */
398 abstract contract Context {
399     function _msgSender() internal view virtual returns (address) {
400         return msg.sender;
401     }
402 
403     function _msgData() internal view virtual returns (bytes calldata) {
404         return msg.data;
405     }
406 }
407 
408 // File: @openzeppelin/contracts/access/Ownable.sol
409 
410 
411 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
412 
413 pragma solidity ^0.8.0;
414 
415 
416 /**
417  * @dev Contract module which provides a basic access control mechanism, where
418  * there is an account (an owner) that can be granted exclusive access to
419  * specific functions.
420  *
421  * By default, the owner account will be the one that deploys the contract. This
422  * can later be changed with {transferOwnership}.
423  *
424  * This module is used through inheritance. It will make available the modifier
425  * `onlyOwner`, which can be applied to your functions to restrict their use to
426  * the owner.
427  */
428 abstract contract Ownable is Context {
429     address private _owner;
430 
431     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
432 
433     /**
434      * @dev Initializes the contract setting the deployer as the initial owner.
435      */
436     constructor() {
437         _transferOwnership(_msgSender());
438     }
439 
440     /**
441      * @dev Returns the address of the current owner.
442      */
443     function owner() public view virtual returns (address) {
444         return _owner;
445     }
446 
447     /**
448      * @dev Throws if called by any account other than the owner.
449      */
450     modifier onlyOwner() {
451         require(owner() == _msgSender(), "Ownable: caller is not the owner");
452         _;
453     }
454 
455     /**
456      * @dev Leaves the contract without owner. It will not be possible to call
457      * `onlyOwner` functions anymore. Can only be called by the current owner.
458      *
459      * NOTE: Renouncing ownership will leave the contract without an owner,
460      * thereby removing any functionality that is only available to the owner.
461      */
462     function renounceOwnership() public virtual onlyOwner {
463         _transferOwnership(address(0));
464     }
465 
466     /**
467      * @dev Transfers ownership of the contract to a new account (`newOwner`).
468      * Can only be called by the current owner.
469      */
470     function transferOwnership(address newOwner) public virtual onlyOwner {
471         require(newOwner != address(0), "Ownable: new owner is the zero address");
472         _transferOwnership(newOwner);
473     }
474 
475     /**
476      * @dev Transfers ownership of the contract to a new account (`newOwner`).
477      * Internal function without access restriction.
478      */
479     function _transferOwnership(address newOwner) internal virtual {
480         address oldOwner = _owner;
481         _owner = newOwner;
482         emit OwnershipTransferred(oldOwner, newOwner);
483     }
484 }
485 
486 // File: @openzeppelin/contracts/utils/Address.sol
487 
488 
489 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
490 
491 pragma solidity ^0.8.1;
492 
493 /**
494  * @dev Collection of functions related to the address type
495  */
496 library Address {
497     /**
498      * @dev Returns true if `account` is a contract.
499      *
500      * [IMPORTANT]
501      * ====
502      * It is unsafe to assume that an address for which this function returns
503      * false is an externally-owned account (EOA) and not a contract.
504      *
505      * Among others, `isContract` will return false for the following
506      * types of addresses:
507      *
508      *  - an externally-owned account
509      *  - a contract in construction
510      *  - an address where a contract will be created
511      *  - an address where a contract lived, but was destroyed
512      * ====
513      *
514      * [IMPORTANT]
515      * ====
516      * You shouldn't rely on `isContract` to protect against flash loan attacks!
517      *
518      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
519      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
520      * constructor.
521      * ====
522      */
523     function isContract(address account) internal view returns (bool) {
524         // This method relies on extcodesize/address.code.length, which returns 0
525         // for contracts in construction, since the code is only stored at the end
526         // of the constructor execution.
527 
528         return account.code.length > 0;
529     }
530 
531     /**
532      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
533      * `recipient`, forwarding all available gas and reverting on errors.
534      *
535      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
536      * of certain opcodes, possibly making contracts go over the 2300 gas limit
537      * imposed by `transfer`, making them unable to receive funds via
538      * `transfer`. {sendValue} removes this limitation.
539      *
540      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
541      *
542      * IMPORTANT: because control is transferred to `recipient`, care must be
543      * taken to not create reentrancy vulnerabilities. Consider using
544      * {ReentrancyGuard} or the
545      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
546      */
547     function sendValue(address payable recipient, uint256 amount) internal {
548         require(address(this).balance >= amount, "Address: insufficient balance");
549 
550         (bool success, ) = recipient.call{value: amount}("");
551         require(success, "Address: unable to send value, recipient may have reverted");
552     }
553 
554     /**
555      * @dev Performs a Solidity function call using a low level `call`. A
556      * plain `call` is an unsafe replacement for a function call: use this
557      * function instead.
558      *
559      * If `target` reverts with a revert reason, it is bubbled up by this
560      * function (like regular Solidity function calls).
561      *
562      * Returns the raw returned data. To convert to the expected return value,
563      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
564      *
565      * Requirements:
566      *
567      * - `target` must be a contract.
568      * - calling `target` with `data` must not revert.
569      *
570      * _Available since v3.1._
571      */
572     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
573         return functionCall(target, data, "Address: low-level call failed");
574     }
575 
576     /**
577      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
578      * `errorMessage` as a fallback revert reason when `target` reverts.
579      *
580      * _Available since v3.1._
581      */
582     function functionCall(
583         address target,
584         bytes memory data,
585         string memory errorMessage
586     ) internal returns (bytes memory) {
587         return functionCallWithValue(target, data, 0, errorMessage);
588     }
589 
590     /**
591      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
592      * but also transferring `value` wei to `target`.
593      *
594      * Requirements:
595      *
596      * - the calling contract must have an ETH balance of at least `value`.
597      * - the called Solidity function must be `payable`.
598      *
599      * _Available since v3.1._
600      */
601     function functionCallWithValue(
602         address target,
603         bytes memory data,
604         uint256 value
605     ) internal returns (bytes memory) {
606         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
607     }
608 
609     /**
610      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
611      * with `errorMessage` as a fallback revert reason when `target` reverts.
612      *
613      * _Available since v3.1._
614      */
615     function functionCallWithValue(
616         address target,
617         bytes memory data,
618         uint256 value,
619         string memory errorMessage
620     ) internal returns (bytes memory) {
621         require(address(this).balance >= value, "Address: insufficient balance for call");
622         require(isContract(target), "Address: call to non-contract");
623 
624         (bool success, bytes memory returndata) = target.call{value: value}(data);
625         return verifyCallResult(success, returndata, errorMessage);
626     }
627 
628     /**
629      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
630      * but performing a static call.
631      *
632      * _Available since v3.3._
633      */
634     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
635         return functionStaticCall(target, data, "Address: low-level static call failed");
636     }
637 
638     /**
639      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
640      * but performing a static call.
641      *
642      * _Available since v3.3._
643      */
644     function functionStaticCall(
645         address target,
646         bytes memory data,
647         string memory errorMessage
648     ) internal view returns (bytes memory) {
649         require(isContract(target), "Address: static call to non-contract");
650 
651         (bool success, bytes memory returndata) = target.staticcall(data);
652         return verifyCallResult(success, returndata, errorMessage);
653     }
654 
655     /**
656      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
657      * but performing a delegate call.
658      *
659      * _Available since v3.4._
660      */
661     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
662         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
663     }
664 
665     /**
666      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
667      * but performing a delegate call.
668      *
669      * _Available since v3.4._
670      */
671     function functionDelegateCall(
672         address target,
673         bytes memory data,
674         string memory errorMessage
675     ) internal returns (bytes memory) {
676         require(isContract(target), "Address: delegate call to non-contract");
677 
678         (bool success, bytes memory returndata) = target.delegatecall(data);
679         return verifyCallResult(success, returndata, errorMessage);
680     }
681 
682     /**
683      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
684      * revert reason using the provided one.
685      *
686      * _Available since v4.3._
687      */
688     function verifyCallResult(
689         bool success,
690         bytes memory returndata,
691         string memory errorMessage
692     ) internal pure returns (bytes memory) {
693         if (success) {
694             return returndata;
695         } else {
696             // Look for revert reason and bubble it up if present
697             if (returndata.length > 0) {
698                 // The easiest way to bubble the revert reason is using memory via assembly
699 
700                 assembly {
701                     let returndata_size := mload(returndata)
702                     revert(add(32, returndata), returndata_size)
703                 }
704             } else {
705                 revert(errorMessage);
706             }
707         }
708     }
709 }
710 
711 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
712 
713 
714 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
715 
716 pragma solidity ^0.8.0;
717 
718 /**
719  * @title ERC721 token receiver interface
720  * @dev Interface for any contract that wants to support safeTransfers
721  * from ERC721 asset contracts.
722  */
723 interface IERC721Receiver {
724     /**
725      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
726      * by `operator` from `from`, this function is called.
727      *
728      * It must return its Solidity selector to confirm the token transfer.
729      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
730      *
731      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
732      */
733     function onERC721Received(
734         address operator,
735         address from,
736         uint256 tokenId,
737         bytes calldata data
738     ) external returns (bytes4);
739 }
740 
741 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
742 
743 
744 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
745 
746 pragma solidity ^0.8.0;
747 
748 /**
749  * @dev Interface of the ERC165 standard, as defined in the
750  * https://eips.ethereum.org/EIPS/eip-165[EIP].
751  *
752  * Implementers can declare support of contract interfaces, which can then be
753  * queried by others ({ERC165Checker}).
754  *
755  * For an implementation, see {ERC165}.
756  */
757 
758 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
759 
760 
761 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
762 
763 pragma solidity ^0.8.0;
764 
765 
766 /**
767  * @dev Implementation of the {IERC165} interface.
768  *
769  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
770  * for the additional interface id that will be supported. For example:
771  *
772  * ```solidity
773  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
774  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
775  * }
776  * ```
777  *
778  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
779  */
780 
781 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
782 
783 
784 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
785 
786 pragma solidity ^0.8.0;
787 
788 
789 /**
790  * @dev Required interface of an ERC721 compliant contract.
791  */
792 interface IERC721 is IERC165 {
793     /**
794      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
795      */
796     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
797 
798     /**
799      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
800      */
801     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
802 
803     /**
804      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
805      */
806     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
807 
808     /**
809      * @dev Returns the number of tokens in ``owner``'s account.
810      */
811     function balanceOf(address owner) external view returns (uint256 balance);
812 
813     /**
814      * @dev Returns the owner of the `tokenId` token.
815      *
816      * Requirements:
817      *
818      * - `tokenId` must exist.
819      */
820     function ownerOf(uint256 tokenId) external view returns (address owner);
821 
822     /**
823      * @dev Safely transfers `tokenId` token from `from` to `to`.
824      *
825      * Requirements:
826      *
827      * - `from` cannot be the zero address.
828      * - `to` cannot be the zero address.
829      * - `tokenId` token must exist and be owned by `from`.
830      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
831      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
832      *
833      * Emits a {Transfer} event.
834      */
835     function safeTransferFrom(
836         address from,
837         address to,
838         uint256 tokenId,
839         bytes calldata data
840     ) external;
841 
842     /**
843      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
844      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
845      *
846      * Requirements:
847      *
848      * - `from` cannot be the zero address.
849      * - `to` cannot be the zero address.
850      * - `tokenId` token must exist and be owned by `from`.
851      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
852      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
853      *
854      * Emits a {Transfer} event.
855      */
856     function safeTransferFrom(
857         address from,
858         address to,
859         uint256 tokenId
860     ) external;
861 
862     /**
863      * @dev Transfers `tokenId` token from `from` to `to`.
864      *
865      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
866      *
867      * Requirements:
868      *
869      * - `from` cannot be the zero address.
870      * - `to` cannot be the zero address.
871      * - `tokenId` token must be owned by `from`.
872      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
873      *
874      * Emits a {Transfer} event.
875      */
876     function transferFrom(
877         address from,
878         address to,
879         uint256 tokenId
880     ) external;
881 
882     /**
883      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
884      * The approval is cleared when the token is transferred.
885      *
886      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
887      *
888      * Requirements:
889      *
890      * - The caller must own the token or be an approved operator.
891      * - `tokenId` must exist.
892      *
893      * Emits an {Approval} event.
894      */
895     function approve(address to, uint256 tokenId) external;
896 
897     /**
898      * @dev Approve or remove `operator` as an operator for the caller.
899      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
900      *
901      * Requirements:
902      *
903      * - The `operator` cannot be the caller.
904      *
905      * Emits an {ApprovalForAll} event.
906      */
907     function setApprovalForAll(address operator, bool _approved) external;
908 
909     /**
910      * @dev Returns the account approved for `tokenId` token.
911      *
912      * Requirements:
913      *
914      * - `tokenId` must exist.
915      */
916     function getApproved(uint256 tokenId) external view returns (address operator);
917 
918     /**
919      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
920      *
921      * See {setApprovalForAll}
922      */
923     function isApprovedForAll(address owner, address operator) external view returns (bool);
924 }
925 
926 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
927 
928 
929 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
930 
931 pragma solidity ^0.8.0;
932 
933 
934 /**
935  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
936  * @dev See https://eips.ethereum.org/EIPS/eip-721
937  */
938 interface IERC721Metadata is IERC721 {
939     /**
940      * @dev Returns the token collection name.
941      */
942     function name() external view returns (string memory);
943 
944     /**
945      * @dev Returns the token collection symbol.
946      */
947     function symbol() external view returns (string memory);
948 
949     /**
950      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
951      */
952     function tokenURI(uint256 tokenId) external view returns (string memory);
953 }
954 
955 // File: ERC721A.sol
956 
957 
958 // Creator: Chiru Labs
959 
960 pragma solidity ^0.8.4;
961 
962 
963 
964 
965 
966 
967 
968 
969 error ApprovalCallerNotOwnerNorApproved();
970 error ApprovalQueryForNonexistentToken();
971 error ApproveToCaller();
972 error ApprovalToCurrentOwner();
973 error BalanceQueryForZeroAddress();
974 error MintToZeroAddress();
975 error MintZeroQuantity();
976 error OwnerQueryForNonexistentToken();
977 error TransferCallerNotOwnerNorApproved();
978 error TransferFromIncorrectOwner();
979 error TransferToNonERC721ReceiverImplementer();
980 error TransferToZeroAddress();
981 error URIQueryForNonexistentToken();
982 
983 /**
984  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
985  * the Metadata extension. Built to optimize for lower gas during batch mints.
986  *
987  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
988  *
989  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
990  *
991  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
992  */
993 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
994     using Address for address;
995     using Strings for uint256;
996 
997     // Compiler will pack this into a single 256bit word.
998     struct TokenOwnership {
999         // The address of the owner.
1000         address addr;
1001         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1002         uint64 startTimestamp;
1003         // Whether the token has been burned.
1004         bool burned;
1005     }
1006 
1007     // Compiler will pack this into a single 256bit word.
1008     struct AddressData {
1009         // Realistically, 2**64-1 is more than enough.
1010         uint64 balance;
1011         // Keeps track of mint count with minimal overhead for tokenomics.
1012         uint64 numberMinted;
1013         // Keeps track of burn count with minimal overhead for tokenomics.
1014         uint64 numberBurned;
1015         // For miscellaneous variable(s) pertaining to the address
1016         // (e.g. number of whitelist mint slots used).
1017         // If there are multiple variables, please pack them into a uint64.
1018         uint64 aux;
1019     }
1020 
1021     // The tokenId of the next token to be minted.
1022     uint256 internal _currentIndex;
1023 
1024     // The number of tokens burned.
1025     uint256 internal _burnCounter;
1026 
1027     // Token name
1028     string private _name;
1029 
1030     // Token symbol
1031     string private _symbol;
1032 
1033     // Mapping from token ID to ownership details
1034     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1035     mapping(uint256 => TokenOwnership) internal _ownerships;
1036 
1037     // Mapping owner address to address data
1038     mapping(address => AddressData) private _addressData;
1039 
1040     // Mapping from token ID to approved address
1041     mapping(uint256 => address) private _tokenApprovals;
1042 
1043     // Mapping from owner to operator approvals
1044     mapping(address => mapping(address => bool)) private _operatorApprovals;
1045 
1046     constructor(string memory name_, string memory symbol_) {
1047         _name = name_;
1048         _symbol = symbol_;
1049         _currentIndex = _startTokenId();
1050     }
1051 
1052     /**
1053      * To change the starting tokenId, please override this function.
1054      */
1055     function _startTokenId() internal view virtual returns (uint256) {
1056         return 1;
1057     }
1058 
1059     /**
1060      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1061      */
1062     function totalSupply() public view returns (uint256) {
1063         // Counter underflow is impossible as _burnCounter cannot be incremented
1064         // more than _currentIndex - _startTokenId() times
1065         unchecked {
1066             return _currentIndex - _burnCounter - _startTokenId();
1067         }
1068     }
1069 
1070     /**
1071      * Returns the total amount of tokens minted in the contract.
1072      */
1073     function _totalMinted() internal view returns (uint256) {
1074         // Counter underflow is impossible as _currentIndex does not decrement,
1075         // and it is initialized to _startTokenId()
1076         unchecked {
1077             return _currentIndex - _startTokenId();
1078         }
1079     }
1080 
1081     /**
1082      * @dev See {IERC165-supportsInterface}.
1083      */
1084     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1085         return
1086             interfaceId == type(IERC721).interfaceId ||
1087             interfaceId == type(IERC721Metadata).interfaceId ||
1088             super.supportsInterface(interfaceId);
1089     }
1090 
1091     /**
1092      * @dev See {IERC721-balanceOf}.
1093      */
1094     function balanceOf(address owner) public view override returns (uint256) {
1095         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1096         return uint256(_addressData[owner].balance);
1097     }
1098 
1099     /**
1100      * Returns the number of tokens minted by `owner`.
1101      */
1102     function _numberMinted(address owner) internal view returns (uint256) {
1103         return uint256(_addressData[owner].numberMinted);
1104     }
1105 
1106     /**
1107      * Returns the number of tokens burned by or on behalf of `owner`.
1108      */
1109     function _numberBurned(address owner) internal view returns (uint256) {
1110         return uint256(_addressData[owner].numberBurned);
1111     }
1112 
1113     /**
1114      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1115      */
1116     function _getAux(address owner) internal view returns (uint64) {
1117         return _addressData[owner].aux;
1118     }
1119 
1120     /**
1121      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1122      * If there are multiple variables, please pack them into a uint64.
1123      */
1124     function _setAux(address owner, uint64 aux) internal {
1125         _addressData[owner].aux = aux;
1126     }
1127 
1128     /**
1129      * Gas spent here starts off proportional to the maximum mint batch size.
1130      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1131      */
1132     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1133         uint256 curr = tokenId;
1134 
1135         unchecked {
1136             if (_startTokenId() <= curr && curr < _currentIndex) {
1137                 TokenOwnership memory ownership = _ownerships[curr];
1138                 if (!ownership.burned) {
1139                     if (ownership.addr != address(0)) {
1140                         return ownership;
1141                     }
1142                     // Invariant:
1143                     // There will always be an ownership that has an address and is not burned
1144                     // before an ownership that does not have an address and is not burned.
1145                     // Hence, curr will not underflow.
1146                     while (true) {
1147                         curr--;
1148                         ownership = _ownerships[curr];
1149                         if (ownership.addr != address(0)) {
1150                             return ownership;
1151                         }
1152                     }
1153                 }
1154             }
1155         }
1156         revert OwnerQueryForNonexistentToken();
1157     }
1158 
1159     /**
1160      * @dev See {IERC721-ownerOf}.
1161      */
1162     function ownerOf(uint256 tokenId) public view override returns (address) {
1163         return _ownershipOf(tokenId).addr;
1164     }
1165 
1166     /**
1167      * @dev See {IERC721Metadata-name}.
1168      */
1169     function name() public view virtual override returns (string memory) {
1170         return _name;
1171     }
1172 
1173     /**
1174      * @dev See {IERC721Metadata-symbol}.
1175      */
1176     function symbol() public view virtual override returns (string memory) {
1177         return _symbol;
1178     }
1179 
1180     /**
1181      * @dev See {IERC721Metadata-tokenURI}.
1182      */
1183     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1184         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1185 
1186         string memory baseURI = _baseURI();
1187         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1188     }
1189 
1190     /**
1191      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1192      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1193      * by default, can be overriden in child contracts.
1194      */
1195     function _baseURI() internal view virtual returns (string memory) {
1196         return '';
1197     }
1198 
1199     /**
1200      * @dev See {IERC721-approve}.
1201      */
1202     function approve(address to, uint256 tokenId) public override {
1203         address owner = ERC721A.ownerOf(tokenId);
1204         if (to == owner) revert ApprovalToCurrentOwner();
1205 
1206         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1207             revert ApprovalCallerNotOwnerNorApproved();
1208         }
1209 
1210         _approve(to, tokenId, owner);
1211     }
1212 
1213     /**
1214      * @dev See {IERC721-getApproved}.
1215      */
1216     function getApproved(uint256 tokenId) public view override returns (address) {
1217         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1218 
1219         return _tokenApprovals[tokenId];
1220     }
1221 
1222     /**
1223      * @dev See {IERC721-setApprovalForAll}.
1224      */
1225     function setApprovalForAll(address operator, bool approved) public virtual override {
1226         if (operator == _msgSender()) revert ApproveToCaller();
1227 
1228         _operatorApprovals[_msgSender()][operator] = approved;
1229         emit ApprovalForAll(_msgSender(), operator, approved);
1230     }
1231 
1232     /**
1233      * @dev See {IERC721-isApprovedForAll}.
1234      */
1235     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1236         return _operatorApprovals[owner][operator];
1237     }
1238 
1239     /**
1240      * @dev See {IERC721-transferFrom}.
1241      */
1242     function transferFrom(
1243         address from,
1244         address to,
1245         uint256 tokenId
1246     ) public virtual override {
1247         _transfer(from, to, tokenId);
1248     }
1249 
1250     /**
1251      * @dev See {IERC721-safeTransferFrom}.
1252      */
1253     function safeTransferFrom(
1254         address from,
1255         address to,
1256         uint256 tokenId
1257     ) public virtual override {
1258         safeTransferFrom(from, to, tokenId, '');
1259     }
1260 
1261     /**
1262      * @dev See {IERC721-safeTransferFrom}.
1263      */
1264     function safeTransferFrom(
1265         address from,
1266         address to,
1267         uint256 tokenId,
1268         bytes memory _data
1269     ) public virtual override {
1270         _transfer(from, to, tokenId);
1271         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1272             revert TransferToNonERC721ReceiverImplementer();
1273         }
1274     }
1275 
1276     /**
1277      * @dev Returns whether `tokenId` exists.
1278      *
1279      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1280      *
1281      * Tokens start existing when they are minted (`_mint`),
1282      */
1283     function _exists(uint256 tokenId) internal view returns (bool) {
1284         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1285     }
1286 
1287     function _safeMint(address to, uint256 quantity) internal {
1288         _safeMint(to, quantity, '');
1289     }
1290 
1291     /**
1292      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1293      *
1294      * Requirements:
1295      *
1296      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1297      * - `quantity` must be greater than 0.
1298      *
1299      * Emits a {Transfer} event.
1300      */
1301     function _safeMint(
1302         address to,
1303         uint256 quantity,
1304         bytes memory _data
1305     ) internal {
1306         _mint(to, quantity, _data, true);
1307     }
1308 
1309     /**
1310      * @dev Mints `quantity` tokens and transfers them to `to`.
1311      *
1312      * Requirements:
1313      *
1314      * - `to` cannot be the zero address.
1315      * - `quantity` must be greater than 0.
1316      *
1317      * Emits a {Transfer} event.
1318      */
1319     function _mint(
1320         address to,
1321         uint256 quantity,
1322         bytes memory _data,
1323         bool safe
1324     ) internal {
1325         uint256 startTokenId = _currentIndex;
1326         if (to == address(0)) revert MintToZeroAddress();
1327         if (quantity == 0) revert MintZeroQuantity();
1328 
1329         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1330 
1331         // Overflows are incredibly unrealistic.
1332         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1333         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1334         unchecked {
1335             _addressData[to].balance += uint64(quantity);
1336             _addressData[to].numberMinted += uint64(quantity);
1337 
1338             _ownerships[startTokenId].addr = to;
1339             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1340 
1341             uint256 updatedIndex = startTokenId;
1342             uint256 end = updatedIndex + quantity;
1343 
1344             if (safe && to.isContract()) {
1345                 do {
1346                     emit Transfer(address(0), to, updatedIndex);
1347                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1348                         revert TransferToNonERC721ReceiverImplementer();
1349                     }
1350                 } while (updatedIndex != end);
1351                 // Reentrancy protection
1352                 if (_currentIndex != startTokenId) revert();
1353             } else {
1354                 do {
1355                     emit Transfer(address(0), to, updatedIndex++);
1356                 } while (updatedIndex != end);
1357             }
1358             _currentIndex = updatedIndex;
1359         }
1360         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1361     }
1362 
1363     /**
1364      * @dev Transfers `tokenId` from `from` to `to`.
1365      *
1366      * Requirements:
1367      *
1368      * - `to` cannot be the zero address.
1369      * - `tokenId` token must be owned by `from`.
1370      *
1371      * Emits a {Transfer} event.
1372      */
1373     function _transfer(
1374         address from,
1375         address to,
1376         uint256 tokenId
1377     ) private {
1378         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1379 
1380         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1381 
1382         bool isApprovedOrOwner = (_msgSender() == from ||
1383             isApprovedForAll(from, _msgSender()) ||
1384             getApproved(tokenId) == _msgSender());
1385 
1386         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1387         if (to == address(0)) revert TransferToZeroAddress();
1388 
1389         _beforeTokenTransfers(from, to, tokenId, 1);
1390 
1391         // Clear approvals from the previous owner
1392         _approve(address(0), tokenId, from);
1393 
1394         // Underflow of the sender's balance is impossible because we check for
1395         // ownership above and the recipient's balance can't realistically overflow.
1396         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1397         unchecked {
1398             _addressData[from].balance -= 1;
1399             _addressData[to].balance += 1;
1400 
1401             TokenOwnership storage currSlot = _ownerships[tokenId];
1402             currSlot.addr = to;
1403             currSlot.startTimestamp = uint64(block.timestamp);
1404 
1405             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1406             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1407             uint256 nextTokenId = tokenId + 1;
1408             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1409             if (nextSlot.addr == address(0)) {
1410                 // This will suffice for checking _exists(nextTokenId),
1411                 // as a burned slot cannot contain the zero address.
1412                 if (nextTokenId != _currentIndex) {
1413                     nextSlot.addr = from;
1414                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1415                 }
1416             }
1417         }
1418 
1419         emit Transfer(from, to, tokenId);
1420         _afterTokenTransfers(from, to, tokenId, 1);
1421     }
1422 
1423     /**
1424      * @dev This is equivalent to _burn(tokenId, false)
1425      */
1426     function _burn(uint256 tokenId) internal virtual {
1427         _burn(tokenId, false);
1428     }
1429 
1430     /**
1431      * @dev Destroys `tokenId`.
1432      * The approval is cleared when the token is burned.
1433      *
1434      * Requirements:
1435      *
1436      * - `tokenId` must exist.
1437      *
1438      * Emits a {Transfer} event.
1439      */
1440     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1441         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1442 
1443         address from = prevOwnership.addr;
1444 
1445         if (approvalCheck) {
1446             bool isApprovedOrOwner = (_msgSender() == from ||
1447                 isApprovedForAll(from, _msgSender()) ||
1448                 getApproved(tokenId) == _msgSender());
1449 
1450             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1451         }
1452 
1453         _beforeTokenTransfers(from, address(0), tokenId, 1);
1454 
1455         // Clear approvals from the previous owner
1456         _approve(address(0), tokenId, from);
1457 
1458         // Underflow of the sender's balance is impossible because we check for
1459         // ownership above and the recipient's balance can't realistically overflow.
1460         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1461         unchecked {
1462             AddressData storage addressData = _addressData[from];
1463             addressData.balance -= 1;
1464             addressData.numberBurned += 1;
1465 
1466             // Keep track of who burned the token, and the timestamp of burning.
1467             TokenOwnership storage currSlot = _ownerships[tokenId];
1468             currSlot.addr = from;
1469             currSlot.startTimestamp = uint64(block.timestamp);
1470             currSlot.burned = true;
1471 
1472             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1473             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1474             uint256 nextTokenId = tokenId + 1;
1475             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1476             if (nextSlot.addr == address(0)) {
1477                 // This will suffice for checking _exists(nextTokenId),
1478                 // as a burned slot cannot contain the zero address.
1479                 if (nextTokenId != _currentIndex) {
1480                     nextSlot.addr = from;
1481                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1482                 }
1483             }
1484         }
1485 
1486         emit Transfer(from, address(0), tokenId);
1487         _afterTokenTransfers(from, address(0), tokenId, 1);
1488 
1489         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1490         unchecked {
1491             _burnCounter++;
1492         }
1493     }
1494 
1495     /**
1496      * @dev Approve `to` to operate on `tokenId`
1497      *
1498      * Emits a {Approval} event.
1499      */
1500     function _approve(
1501         address to,
1502         uint256 tokenId,
1503         address owner
1504     ) private {
1505         _tokenApprovals[tokenId] = to;
1506         emit Approval(owner, to, tokenId);
1507     }
1508 
1509     /**
1510      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1511      *
1512      * @param from address representing the previous owner of the given token ID
1513      * @param to target address that will receive the tokens
1514      * @param tokenId uint256 ID of the token to be transferred
1515      * @param _data bytes optional data to send along with the call
1516      * @return bool whether the call correctly returned the expected magic value
1517      */
1518     function _checkContractOnERC721Received(
1519         address from,
1520         address to,
1521         uint256 tokenId,
1522         bytes memory _data
1523     ) private returns (bool) {
1524         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1525             return retval == IERC721Receiver(to).onERC721Received.selector;
1526         } catch (bytes memory reason) {
1527             if (reason.length == 0) {
1528                 revert TransferToNonERC721ReceiverImplementer();
1529             } else {
1530                 assembly {
1531                     revert(add(32, reason), mload(reason))
1532                 }
1533             }
1534         }
1535     }
1536 
1537     /**
1538      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1539      * And also called before burning one token.
1540      *
1541      * startTokenId - the first token id to be transferred
1542      * quantity - the amount to be transferred
1543      *
1544      * Calling conditions:
1545      *
1546      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1547      * transferred to `to`.
1548      * - When `from` is zero, `tokenId` will be minted for `to`.
1549      * - When `to` is zero, `tokenId` will be burned by `from`.
1550      * - `from` and `to` are never both zero.
1551      */
1552     function _beforeTokenTransfers(
1553         address from,
1554         address to,
1555         uint256 startTokenId,
1556         uint256 quantity
1557     ) internal virtual {}
1558 
1559     /**
1560      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1561      * minting.
1562      * And also called after one token has been burned.
1563      *
1564      * startTokenId - the first token id to be transferred
1565      * quantity - the amount to be transferred
1566      *
1567      * Calling conditions:
1568      *
1569      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1570      * transferred to `to`.
1571      * - When `from` is zero, `tokenId` has been minted for `to`.
1572      * - When `to` is zero, `tokenId` has been burned by `from`.
1573      * - `from` and `to` are never both zero.
1574      */
1575     function _afterTokenTransfers(
1576         address from,
1577         address to,
1578         uint256 startTokenId,
1579         uint256 quantity
1580     ) internal virtual {}
1581 }
1582 // File: Contract.sol
1583 
1584 
1585 pragma solidity ^0.8.7;
1586 
1587 contract LostBaboons_Contract is ERC721A, ERC2981, Ownable, ReentrancyGuard {
1588     using Strings for uint256;
1589     mapping(address => uint256) public publicClaimed;
1590 
1591     string public baseURI;
1592     string public hiddenMetadataURILight = "ipfs://QmYQSepVG65MDvsVc1csB47jqyjYCqX2fK5XmxaR8Bc3fm/LostBaboonsLight.json";
1593     string public hiddenMetadataURIBlack = "ipfs://QmYQSepVG65MDvsVc1csB47jqyjYCqX2fK5XmxaR8Bc3fm/LostBaboonsDark.json";
1594     bool public revealed;
1595     bool public paused = true;
1596     address public ROYALITY__ADDRESS;
1597     uint96 public ROYALITY__VALUE;
1598     uint256 public publicPrice = 0.0088 ether;
1599     uint256 public publicMintPerTx = 20;
1600     uint256 public maxSupply = 7575;
1601 
1602     constructor() ERC721A("Lazy Baboons", "LB") {
1603         ROYALITY__ADDRESS = 0x14EaCd261B651d2cc8e4484a3A56C4aA37eE7DFf;
1604         ROYALITY__VALUE = 550;
1605         _setDefaultRoyalty(ROYALITY__ADDRESS, ROYALITY__VALUE);
1606         
1607     }
1608 
1609      
1610 
1611     // ============ PUBLIC FUNCTIONS FOR MINTING ============
1612     function mint(uint256 quantity) external payable nonReentrant {
1613         require(!paused, "The contract is paused!");
1614         require(quantity > 0 && totalSupply() + quantity <= maxSupply, "Invalid amount!");
1615         require(publicClaimed[msg.sender] + quantity <= publicMintPerTx, "You can't mint this amount");
1616         if (publicClaimed[msg.sender] == 0)
1617         require(msg.value >= publicPrice * (quantity-1), "Insufficient Funds!");
1618         else
1619              require(msg.value >= publicPrice * quantity, "Insufficient Funds!");
1620          publicClaimed[msg.sender] += quantity;
1621         _safeMint(msg.sender, quantity);
1622     }
1623 
1624     function _baseURI() internal view virtual override returns (string memory) {
1625         return baseURI;
1626     }
1627 
1628 
1629     // ============ PUBLIC READ-ONLY FUNCTIONS ============
1630 
1631     function tokenURI(uint256 tokenId)
1632         public
1633         view
1634         virtual
1635         override
1636         returns (string memory)
1637     {
1638         require(
1639             _exists(tokenId),
1640             "ERC721Metadata: URI query for nonexistent token"
1641         );
1642         string memory currentBaseURI = _baseURI();
1643          if (revealed == false) {
1644             if (tokenId % 2 == 0 )
1645                 return hiddenMetadataURILight;
1646         else
1647             return hiddenMetadataURIBlack;
1648         }
1649         return
1650             bytes(currentBaseURI).length > 0
1651                 ? string(
1652                     abi.encodePacked(
1653                         currentBaseURI,
1654                         tokenId.toString(),
1655                         ".json"
1656                     )
1657                 )
1658                 : "";
1659     }
1660     function supportsInterface(bytes4 interfaceId)
1661     public
1662     view
1663     override(ERC721A, ERC2981)
1664     returns (bool)
1665     {
1666         return
1667             ERC721A.supportsInterface(interfaceId)
1668             || ERC2981.supportsInterface(interfaceId);
1669     }
1670    
1671     function setRoyalties(address receiver, uint96 royaltyFraction) external onlyOwner {
1672         _setDefaultRoyalty(receiver, royaltyFraction);
1673     }
1674    
1675    
1676     function setCost(uint256 _newPublicCost) external onlyOwner {
1677         publicPrice = _newPublicCost;
1678     }
1679    
1680  
1681     function setMaxPublic(uint256 _newMaxPublic) external onlyOwner {
1682         publicMintPerTx = _newMaxPublic;
1683     }
1684 
1685     function setMaxSuppy(uint256 _amount) external onlyOwner {
1686         maxSupply = _amount;
1687     }
1688 
1689     function setPaused(bool _state) external onlyOwner {
1690         paused = _state;
1691     }
1692 
1693     function setBaseURI(string memory _newBaseURI) external onlyOwner {
1694         baseURI = _newBaseURI;
1695     }
1696    
1697     function airDrop(uint256 quantity, address _address) external onlyOwner {
1698         _safeMint(_address, quantity);
1699     }
1700     
1701 
1702     function airDropBatch(address[] memory _addresses) external onlyOwner {
1703         for(uint256 i = 0 ;i < _addresses.length; i ++) {
1704             _safeMint(_addresses[i], 1);
1705         }
1706     }
1707 
1708     function withdraw() public onlyOwner {
1709          // Do not remove this otherwise you will not be able to withdraw the funds.
1710         // =============================================================================
1711         (bool ts, ) = payable(owner()).call{value: address(this).balance}("");
1712         require(ts);
1713         // =============================================================================
1714     }
1715 }