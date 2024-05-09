1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
3 
4 pragma solidity ^0.8.4;
5 
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
15 interface IERC165 {
16     /**
17      * @dev Returns true if this contract implements the interface defined by
18      * `interfaceId`. See the corresponding
19      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
20      * to learn more about how these ids are created.
21      *
22      * This function call must use less than 30 000 gas.
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool);
25 }
26 
27 
28 
29 pragma solidity ^0.8.4;
30 
31 
32 /**
33  * @dev Interface for the NFT Royalty Standard.
34  *
35  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
36  * support for royalty payments across all NFT marketplaces and ecosystem participants.
37  *
38  * _Available since v4.5._
39  */
40 interface IERC2981 is IERC165 {
41     /**
42      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
43      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
44      */
45     function royaltyInfo(uint256 tokenId, uint256 salePrice)
46         external
47         view
48         returns (address receiver, uint256 royaltyAmount);
49 }
50 
51 
52 
53 
54 pragma solidity ^0.8.0;
55 
56 
57 /**
58  * @dev Implementation of the {IERC165} interface.
59  *
60  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
61  * for the additional interface id that will be supported. For example:
62  *
63  * ```solidity
64  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
65  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
66  * }
67  * ```
68  *
69  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
70  */
71 abstract contract ERC165 is IERC165 {
72     /**
73      * @dev See {IERC165-supportsInterface}.
74      */
75     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
76         return interfaceId == type(IERC165).interfaceId;
77     }
78 }
79 
80 
81    
82 
83 pragma solidity ^0.8.0;
84 
85 
86 /**
87  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
88  *
89  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
90  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
91  *
92  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
93  * fee is specified in basis points by default.
94  *
95  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
96  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
97  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
98  *
99  * _Available since v4.5._
100  */
101 abstract contract ERC2981 is IERC2981, ERC165 {
102     struct RoyaltyInfo {
103         address receiver;
104         uint96 royaltyFraction;
105     }
106 
107     RoyaltyInfo private _defaultRoyaltyInfo;
108     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
109 
110     /**
111      * @dev See {IERC165-supportsInterface}.
112      */
113     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
114         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
115     }
116 
117     /**
118      * @inheritdoc IERC2981
119      */
120     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
121         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
122 
123         if (royalty.receiver == address(0)) {
124             royalty = _defaultRoyaltyInfo;
125         }
126 
127         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
128 
129         return (royalty.receiver, royaltyAmount);
130     }
131 
132     /**
133      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
134      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
135      * override.
136      */
137     function _feeDenominator() internal pure virtual returns (uint96) {
138         return 10000;
139     }
140 
141     /**
142      * @dev Sets the royalty information that all ids in this contract will default to.
143      *
144      * Requirements:
145      *
146      * - `receiver` cannot be the zero address.
147      * - `feeNumerator` cannot be greater than the fee denominator.
148      */
149     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
150         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
151         require(receiver != address(0), "ERC2981: invalid receiver");
152 
153         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
154     }
155 
156     /**
157      * @dev Removes default royalty information.
158      */
159     function _deleteDefaultRoyalty() internal virtual {
160         delete _defaultRoyaltyInfo;
161     }
162 
163     /**
164      * @dev Sets the royalty information for a specific token id, overriding the global default.
165      *
166      * Requirements:
167      *
168      * - `receiver` cannot be the zero address.
169      * - `feeNumerator` cannot be greater than the fee denominator.
170      */
171     function _setTokenRoyalty(
172         uint256 tokenId,
173         address receiver,
174         uint96 feeNumerator
175     ) internal virtual {
176         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
177         require(receiver != address(0), "ERC2981: Invalid parameters");
178 
179         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
180     }
181 
182     /**
183      * @dev Resets royalty information for the token id back to the global default.
184      */
185     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
186         delete _tokenRoyaltyInfo[tokenId];
187     }
188 }
189 
190 
191 
192 
193 
194 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
195 
196 pragma solidity ^0.8.0;
197 
198 /**
199  * @dev Contract module that helps prevent reentrant calls to a function.
200  *
201  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
202  * available, which can be applied to functions to make sure there are no nested
203  * (reentrant) calls to them.
204  *
205  * Note that because there is a single `nonReentrant` guard, functions marked as
206  * `nonReentrant` may not call one another. This can be worked around by making
207  * those functions `private`, and then adding `external` `nonReentrant` entry
208  * points to them.
209  *
210  * TIP: If you would like to learn more about reentrancy and alternative ways
211  * to protect against it, check out our blog post
212  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
213  */
214 abstract contract ReentrancyGuard {
215     // Booleans are more expensive than uint256 or any type that takes up a full
216     // word because each write operation emits an extra SLOAD to first read the
217     // slot's contents, replace the bits taken up by the boolean, and then write
218     // back. This is the compiler's defense against contract upgrades and
219     // pointer aliasing, and it cannot be disabled.
220 
221     // The values being non-zero value makes deployment a bit more expensive,
222     // but in exchange the refund on every call to nonReentrant will be lower in
223     // amount. Since refunds are capped to a percentage of the total
224     // transaction's gas, it is best to keep them low in cases like this one, to
225     // increase the likelihood of the full refund coming into effect.
226     uint256 private constant _NOT_ENTERED = 1;
227     uint256 private constant _ENTERED = 2;
228 
229     uint256 private _status;
230 
231     constructor() {
232         _status = _NOT_ENTERED;
233     }
234 
235     /**
236      * @dev Prevents a contract from calling itself, directly or indirectly.
237      * Calling a `nonReentrant` function from another `nonReentrant`
238      * function is not supported. It is possible to prevent this from happening
239      * by making the `nonReentrant` function external, and making it call a
240      * `private` function that does the actual work.
241      */
242     modifier nonReentrant() {
243         // On the first call to nonReentrant, _notEntered will be true
244         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
245 
246         // Any calls to nonReentrant after this point will fail
247         _status = _ENTERED;
248 
249         _;
250 
251         // By storing the original value once again, a refund is triggered (see
252         // https://eips.ethereum.org/EIPS/eip-2200)
253         _status = _NOT_ENTERED;
254     }
255 }
256 
257 // File: @openzeppelin/contracts/utils/Strings.sol
258 
259 
260 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
261 
262 pragma solidity ^0.8.0;
263 
264 /**
265  * @dev String operations.
266  */
267 library Strings {
268     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
269 
270     /**
271      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
272      */
273     function toString(uint256 value) internal pure returns (string memory) {
274         // Inspired by OraclizeAPI's implementation - MIT licence
275         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
276 
277         if (value == 0) {
278             return "0";
279         }
280         uint256 temp = value;
281         uint256 digits;
282         while (temp != 0) {
283             digits++;
284             temp /= 10;
285         }
286         bytes memory buffer = new bytes(digits);
287         while (value != 0) {
288             digits -= 1;
289             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
290             value /= 10;
291         }
292         return string(buffer);
293     }
294 
295     /**
296      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
297      */
298     function toHexString(uint256 value) internal pure returns (string memory) {
299         if (value == 0) {
300             return "0x00";
301         }
302         uint256 temp = value;
303         uint256 length = 0;
304         while (temp != 0) {
305             length++;
306             temp >>= 8;
307         }
308         return toHexString(value, length);
309     }
310 
311     /**
312      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
313      */
314     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
315         bytes memory buffer = new bytes(2 * length + 2);
316         buffer[0] = "0";
317         buffer[1] = "x";
318         for (uint256 i = 2 * length + 1; i > 1; --i) {
319             buffer[i] = _HEX_SYMBOLS[value & 0xf];
320             value >>= 4;
321         }
322         require(value == 0, "Strings: hex length insufficient");
323         return string(buffer);
324     }
325 }
326 
327 // File: @openzeppelin/contracts/utils/Context.sol
328 
329 
330 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
331 
332 pragma solidity ^0.8.0;
333 
334 /**
335  * @dev Provides information about the current execution context, including the
336  * sender of the transaction and its data. While these are generally available
337  * via msg.sender and msg.data, they should not be accessed in such a direct
338  * manner, since when dealing with meta-transactions the account sending and
339  * paying for execution may not be the actual sender (as far as an application
340  * is concerned).
341  *
342  * This contract is only required for intermediate, library-like contracts.
343  */
344 abstract contract Context {
345     function _msgSender() internal view virtual returns (address) {
346         return msg.sender;
347     }
348 
349     function _msgData() internal view virtual returns (bytes calldata) {
350         return msg.data;
351     }
352 }
353 
354 // File: @openzeppelin/contracts/access/Ownable.sol
355 
356 
357 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
358 
359 pragma solidity ^0.8.0;
360 
361 
362 /**
363  * @dev Contract module which provides a basic access control mechanism, where
364  * there is an account (an owner) that can be granted exclusive access to
365  * specific functions.
366  *
367  * By default, the owner account will be the one that deploys the contract. This
368  * can later be changed with {transferOwnership}.
369  *
370  * This module is used through inheritance. It will make available the modifier
371  * `onlyOwner`, which can be applied to your functions to restrict their use to
372  * the owner.
373  */
374 abstract contract Ownable is Context {
375     address private _owner;
376 
377     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
378 
379     /**
380      * @dev Initializes the contract setting the deployer as the initial owner.
381      */
382     constructor() {
383         _transferOwnership(_msgSender());
384     }
385 
386     /**
387      * @dev Returns the address of the current owner.
388      */
389     function owner() public view virtual returns (address) {
390         return _owner;
391     }
392 
393     /**
394      * @dev Throws if called by any account other than the owner.
395      */
396     modifier onlyOwner() {
397         require(owner() == _msgSender(), "Ownable: caller is not the owner");
398         _;
399     }
400 
401     /**
402      * @dev Leaves the contract without owner. It will not be possible to call
403      * `onlyOwner` functions anymore. Can only be called by the current owner.
404      *
405      * NOTE: Renouncing ownership will leave the contract without an owner,
406      * thereby removing any functionality that is only available to the owner.
407      */
408     function renounceOwnership() public virtual onlyOwner {
409         _transferOwnership(address(0));
410     }
411 
412     /**
413      * @dev Transfers ownership of the contract to a new account (`newOwner`).
414      * Can only be called by the current owner.
415      */
416     function transferOwnership(address newOwner) public virtual onlyOwner {
417         require(newOwner != address(0), "Ownable: new owner is the zero address");
418         _transferOwnership(newOwner);
419     }
420 
421     /**
422      * @dev Transfers ownership of the contract to a new account (`newOwner`).
423      * Internal function without access restriction.
424      */
425     function _transferOwnership(address newOwner) internal virtual {
426         address oldOwner = _owner;
427         _owner = newOwner;
428         emit OwnershipTransferred(oldOwner, newOwner);
429     }
430 }
431 
432 // File: @openzeppelin/contracts/utils/Address.sol
433 
434 
435 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
436 
437 pragma solidity ^0.8.0;
438 
439 /**
440  * @dev Collection of functions related to the address type
441  */
442 library Address {
443     /**
444      * @dev Returns true if `account` is a contract.
445      *
446      * [IMPORTANT]
447      * ====
448      * It is unsafe to assume that an address for which this function returns
449      * false is an externally-owned account (EOA) and not a contract.
450      *
451      * Among others, `isContract` will return false for the following
452      * types of addresses:
453      *
454      *  - an externally-owned account
455      *  - a contract in construction
456      *  - an address where a contract will be created
457      *  - an address where a contract lived, but was destroyed
458      * ====
459      */
460     function isContract(address account) internal view returns (bool) {
461         // This method relies on extcodesize, which returns 0 for contracts in
462         // construction, since the code is only stored at the end of the
463         // constructor execution.
464 
465         uint256 size;
466         assembly {
467             size := extcodesize(account)
468         }
469         return size > 0;
470     }
471 
472     /**
473      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
474      * `recipient`, forwarding all available gas and reverting on errors.
475      *
476      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
477      * of certain opcodes, possibly making contracts go over the 2300 gas limit
478      * imposed by `transfer`, making them unable to receive funds via
479      * `transfer`. {sendValue} removes this limitation.
480      *
481      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
482      *
483      * IMPORTANT: because control is transferred to `recipient`, care must be
484      * taken to not create reentrancy vulnerabilities. Consider using
485      * {ReentrancyGuard} or the
486      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
487      */
488     function sendValue(address payable recipient, uint256 amount) internal {
489         require(address(this).balance >= amount, "Address: insufficient balance");
490 
491         (bool success, ) = recipient.call{value: amount}("");
492         require(success, "Address: unable to send value, recipient may have reverted");
493     }
494 
495     /**
496      * @dev Performs a Solidity function call using a low level `call`. A
497      * plain `call` is an unsafe replacement for a function call: use this
498      * function instead.
499      *
500      * If `target` reverts with a revert reason, it is bubbled up by this
501      * function (like regular Solidity function calls).
502      *
503      * Returns the raw returned data. To convert to the expected return value,
504      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
505      *
506      * Requirements:
507      *
508      * - `target` must be a contract.
509      * - calling `target` with `data` must not revert.
510      *
511      * _Available since v3.1._
512      */
513     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
514         return functionCall(target, data, "Address: low-level call failed");
515     }
516 
517     /**
518      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
519      * `errorMessage` as a fallback revert reason when `target` reverts.
520      *
521      * _Available since v3.1._
522      */
523     function functionCall(
524         address target,
525         bytes memory data,
526         string memory errorMessage
527     ) internal returns (bytes memory) {
528         return functionCallWithValue(target, data, 0, errorMessage);
529     }
530 
531     /**
532      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
533      * but also transferring `value` wei to `target`.
534      *
535      * Requirements:
536      *
537      * - the calling contract must have an ETH balance of at least `value`.
538      * - the called Solidity function must be `payable`.
539      *
540      * _Available since v3.1._
541      */
542     function functionCallWithValue(
543         address target,
544         bytes memory data,
545         uint256 value
546     ) internal returns (bytes memory) {
547         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
548     }
549 
550     /**
551      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
552      * with `errorMessage` as a fallback revert reason when `target` reverts.
553      *
554      * _Available since v3.1._
555      */
556     function functionCallWithValue(
557         address target,
558         bytes memory data,
559         uint256 value,
560         string memory errorMessage
561     ) internal returns (bytes memory) {
562         require(address(this).balance >= value, "Address: insufficient balance for call");
563         require(isContract(target), "Address: call to non-contract");
564 
565         (bool success, bytes memory returndata) = target.call{value: value}(data);
566         return verifyCallResult(success, returndata, errorMessage);
567     }
568 
569     /**
570      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
571      * but performing a static call.
572      *
573      * _Available since v3.3._
574      */
575     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
576         return functionStaticCall(target, data, "Address: low-level static call failed");
577     }
578 
579     /**
580      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
581      * but performing a static call.
582      *
583      * _Available since v3.3._
584      */
585     function functionStaticCall(
586         address target,
587         bytes memory data,
588         string memory errorMessage
589     ) internal view returns (bytes memory) {
590         require(isContract(target), "Address: static call to non-contract");
591 
592         (bool success, bytes memory returndata) = target.staticcall(data);
593         return verifyCallResult(success, returndata, errorMessage);
594     }
595 
596     /**
597      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
598      * but performing a delegate call.
599      *
600      * _Available since v3.4._
601      */
602     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
603         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
604     }
605 
606     /**
607      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
608      * but performing a delegate call.
609      *
610      * _Available since v3.4._
611      */
612     function functionDelegateCall(
613         address target,
614         bytes memory data,
615         string memory errorMessage
616     ) internal returns (bytes memory) {
617         require(isContract(target), "Address: delegate call to non-contract");
618 
619         (bool success, bytes memory returndata) = target.delegatecall(data);
620         return verifyCallResult(success, returndata, errorMessage);
621     }
622 
623     /**
624      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
625      * revert reason using the provided one.
626      *
627      * _Available since v4.3._
628      */
629     function verifyCallResult(
630         bool success,
631         bytes memory returndata,
632         string memory errorMessage
633     ) internal pure returns (bytes memory) {
634         if (success) {
635             return returndata;
636         } else {
637             // Look for revert reason and bubble it up if present
638             if (returndata.length > 0) {
639                 // The easiest way to bubble the revert reason is using memory via assembly
640 
641                 assembly {
642                     let returndata_size := mload(returndata)
643                     revert(add(32, returndata), returndata_size)
644                 }
645             } else {
646                 revert(errorMessage);
647             }
648         }
649     }
650 }
651 
652 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
653 
654 
655 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
656 
657 pragma solidity ^0.8.0;
658 
659 /**
660  * @title ERC721 token receiver interface
661  * @dev Interface for any contract that wants to support safeTransfers
662  * from ERC721 asset contracts.
663  */
664 interface IERC721Receiver {
665     /**
666      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
667      * by `operator` from `from`, this function is called.
668      *
669      * It must return its Solidity selector to confirm the token transfer.
670      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
671      *
672      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
673      */
674     function onERC721Received(
675         address operator,
676         address from,
677         uint256 tokenId,
678         bytes calldata data
679     ) external returns (bytes4);
680 }
681 
682 
683 
684 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
685 
686 
687 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
688 
689 pragma solidity ^0.8.0;
690 
691 
692 /**
693  * @dev Required interface of an ERC721 compliant contract.
694  */
695 interface IERC721 is IERC165 {
696     /**
697      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
698      */
699     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
700 
701     /**
702      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
703      */
704     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
705 
706     /**
707      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
708      */
709     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
710 
711     /**
712      * @dev Returns the number of tokens in ``owner``'s account.
713      */
714     function balanceOf(address owner) external view returns (uint256 balance);
715 
716     /**
717      * @dev Returns the owner of the `tokenId` token.
718      *
719      * Requirements:
720      *
721      * - `tokenId` must exist.
722      */
723     function ownerOf(uint256 tokenId) external view returns (address owner);
724 
725     /**
726      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
727      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
728      *
729      * Requirements:
730      *
731      * - `from` cannot be the zero address.
732      * - `to` cannot be the zero address.
733      * - `tokenId` token must exist and be owned by `from`.
734      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
735      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
736      *
737      * Emits a {Transfer} event.
738      */
739     function safeTransferFrom(
740         address from,
741         address to,
742         uint256 tokenId
743     ) external;
744 
745     /**
746      * @dev Transfers `tokenId` token from `from` to `to`.
747      *
748      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
749      *
750      * Requirements:
751      *
752      * - `from` cannot be the zero address.
753      * - `to` cannot be the zero address.
754      * - `tokenId` token must be owned by `from`.
755      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
756      *
757      * Emits a {Transfer} event.
758      */
759     function transferFrom(
760         address from,
761         address to,
762         uint256 tokenId
763     ) external;
764 
765     /**
766      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
767      * The approval is cleared when the token is transferred.
768      *
769      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
770      *
771      * Requirements:
772      *
773      * - The caller must own the token or be an approved operator.
774      * - `tokenId` must exist.
775      *
776      * Emits an {Approval} event.
777      */
778     function approve(address to, uint256 tokenId) external;
779 
780     /**
781      * @dev Returns the account approved for `tokenId` token.
782      *
783      * Requirements:
784      *
785      * - `tokenId` must exist.
786      */
787     function getApproved(uint256 tokenId) external view returns (address operator);
788 
789     /**
790      * @dev Approve or remove `operator` as an operator for the caller.
791      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
792      *
793      * Requirements:
794      *
795      * - The `operator` cannot be the caller.
796      *
797      * Emits an {ApprovalForAll} event.
798      */
799     function setApprovalForAll(address operator, bool _approved) external;
800 
801     /**
802      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
803      *
804      * See {setApprovalForAll}
805      */
806     function isApprovedForAll(address owner, address operator) external view returns (bool);
807 
808     /**
809      * @dev Safely transfers `tokenId` token from `from` to `to`.
810      *
811      * Requirements:
812      *
813      * - `from` cannot be the zero address.
814      * - `to` cannot be the zero address.
815      * - `tokenId` token must exist and be owned by `from`.
816      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
817      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
818      *
819      * Emits a {Transfer} event.
820      */
821     function safeTransferFrom(
822         address from,
823         address to,
824         uint256 tokenId,
825         bytes calldata data
826     ) external;
827 }
828 
829 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
830 
831 
832 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
833 
834 pragma solidity ^0.8.0;
835 
836 
837 /**
838  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
839  * @dev See https://eips.ethereum.org/EIPS/eip-721
840  */
841 interface IERC721Enumerable is IERC721 {
842     /**
843      * @dev Returns the total amount of tokens stored by the contract.
844      */
845     function totalSupply() external view returns (uint256);
846 
847     /**
848      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
849      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
850      */
851     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
852 
853     /**
854      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
855      * Use along with {totalSupply} to enumerate all tokens.
856      */
857     function tokenByIndex(uint256 index) external view returns (uint256);
858 }
859 
860 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
861 
862 
863 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
864 
865 pragma solidity ^0.8.0;
866 
867 
868 /**
869  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
870  * @dev See https://eips.ethereum.org/EIPS/eip-721
871  */
872 interface IERC721Metadata is IERC721 {
873     /**
874      * @dev Returns the token collection name.
875      */
876     function name() external view returns (string memory);
877 
878     /**
879      * @dev Returns the token collection symbol.
880      */
881     function symbol() external view returns (string memory);
882 
883     /**
884      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
885      */
886     function tokenURI(uint256 tokenId) external view returns (string memory);
887 }
888 
889 // File: contracts/ERC721A.sol
890 
891 
892 // Creator: Chiru Labs
893 
894 pragma solidity ^0.8.4;
895 
896 
897 
898 
899 
900 
901 
902 
903 
904 error ApprovalCallerNotOwnerNorApproved();
905 error ApprovalQueryForNonexistentToken();
906 error ApproveToCaller();
907 error ApprovalToCurrentOwner();
908 error BalanceQueryForZeroAddress();
909 error MintedQueryForZeroAddress();
910 error BurnedQueryForZeroAddress();
911 error AuxQueryForZeroAddress();
912 error MintToZeroAddress();
913 error MintZeroQuantity();
914 error OwnerIndexOutOfBounds();
915 error OwnerQueryForNonexistentToken();
916 error TokenIndexOutOfBounds();
917 error TransferCallerNotOwnerNorApproved();
918 error TransferFromIncorrectOwner();
919 error TransferToNonERC721ReceiverImplementer();
920 error TransferToZeroAddress();
921 error URIQueryForNonexistentToken();
922 
923 /**
924  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
925  * the Metadata extension. Built to optimize for lower gas during batch mints.
926  *
927  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
928  *
929  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
930  *
931  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
932  */
933 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
934     using Address for address;
935     using Strings for uint256;
936 
937     // Compiler will pack this into a single 256bit word.
938     struct TokenOwnership {
939         // The address of the owner.
940         address addr;
941         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
942         uint64 startTimestamp;
943         // Whether the token has been burned.
944         bool burned;
945     }
946 
947     // Compiler will pack this into a single 256bit word.
948     struct AddressData {
949         // Realistically, 2**64-1 is more than enough.
950         uint64 balance;
951         // Keeps track of mint count with minimal overhead for tokenomics.
952         uint64 numberMinted;
953         // Keeps track of burn count with minimal overhead for tokenomics.
954         uint64 numberBurned;
955         // For miscellaneous variable(s) pertaining to the address
956         // (e.g. number of whitelist mint slots used).
957         // If there are multiple variables, please pack them into a uint64.
958         uint64 aux;
959     }
960 
961     // The tokenId of the next token to be minted.
962     uint256 internal _currentIndex;
963 
964     // The number of tokens burned.
965     uint256 internal _burnCounter;
966 
967     // Token name
968     string private _name;
969 
970     // Token symbol
971     string private _symbol;
972 
973     // Mapping from token ID to ownership details
974     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
975     mapping(uint256 => TokenOwnership) internal _ownerships;
976 
977     // Mapping owner address to address data
978     mapping(address => AddressData) private _addressData;
979 
980     // Mapping from token ID to approved address
981     mapping(uint256 => address) private _tokenApprovals;
982 
983     // Mapping from owner to operator approvals
984     mapping(address => mapping(address => bool)) private _operatorApprovals;
985 
986     constructor(string memory name_, string memory symbol_) {
987         _name = name_;
988         _symbol = symbol_;
989         _currentIndex = _startTokenId();
990     }
991 
992     /**
993      * To change the starting tokenId, please override this function.
994      */
995     function _startTokenId() internal view virtual returns (uint256) {
996         return 0;
997     }
998 
999     /**
1000      * @dev See {IERC721Enumerable-totalSupply}.
1001      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1002      */
1003     function totalSupply() public view returns (uint256) {
1004         // Counter underflow is impossible as _burnCounter cannot be incremented
1005         // more than _currentIndex - _startTokenId() times
1006         unchecked {
1007             return _currentIndex - _burnCounter - _startTokenId();
1008         }
1009     }
1010 
1011     /**
1012      * Returns the total amount of tokens minted in the contract.
1013      */
1014     function _totalMinted() internal view returns (uint256) {
1015         // Counter underflow is impossible as _currentIndex does not decrement,
1016         // and it is initialized to _startTokenId()
1017         unchecked {
1018             return _currentIndex - _startTokenId();
1019         }
1020     }
1021 
1022     /**
1023      * @dev See {IERC165-supportsInterface}.
1024      */
1025     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1026         return
1027             interfaceId == type(IERC721).interfaceId ||
1028             interfaceId == type(IERC721Metadata).interfaceId ||
1029             super.supportsInterface(interfaceId);
1030     }
1031 
1032     /**
1033      * @dev See {IERC721-balanceOf}.
1034      */
1035     function balanceOf(address owner) public view override returns (uint256) {
1036         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1037         return uint256(_addressData[owner].balance);
1038     }
1039 
1040     /**
1041      * Returns the number of tokens minted by `owner`.
1042      */
1043     function _numberMinted(address owner) internal view returns (uint256) {
1044         if (owner == address(0)) revert MintedQueryForZeroAddress();
1045         return uint256(_addressData[owner].numberMinted);
1046     }
1047 
1048     /**
1049      * Returns the number of tokens burned by or on behalf of `owner`.
1050      */
1051     function _numberBurned(address owner) internal view returns (uint256) {
1052         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1053         return uint256(_addressData[owner].numberBurned);
1054     }
1055 
1056     /**
1057      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1058      */
1059     function _getAux(address owner) internal view returns (uint64) {
1060         if (owner == address(0)) revert AuxQueryForZeroAddress();
1061         return _addressData[owner].aux;
1062     }
1063 
1064     /**
1065      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1066      * If there are multiple variables, please pack them into a uint64.
1067      */
1068     function _setAux(address owner, uint64 aux) internal {
1069         if (owner == address(0)) revert AuxQueryForZeroAddress();
1070         _addressData[owner].aux = aux;
1071     }
1072 
1073     /**
1074      * Gas spent here starts off proportional to the maximum mint batch size.
1075      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1076      */
1077     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1078         uint256 curr = tokenId;
1079 
1080         unchecked {
1081             if (_startTokenId() <= curr && curr < _currentIndex) {
1082                 TokenOwnership memory ownership = _ownerships[curr];
1083                 if (!ownership.burned) {
1084                     if (ownership.addr != address(0)) {
1085                         return ownership;
1086                     }
1087                     // Invariant:
1088                     // There will always be an ownership that has an address and is not burned
1089                     // before an ownership that does not have an address and is not burned.
1090                     // Hence, curr will not underflow.
1091                     while (true) {
1092                         curr--;
1093                         ownership = _ownerships[curr];
1094                         if (ownership.addr != address(0)) {
1095                             return ownership;
1096                         }
1097                     }
1098                 }
1099             }
1100         }
1101         revert OwnerQueryForNonexistentToken();
1102     }
1103 
1104     /**
1105      * @dev See {IERC721-ownerOf}.
1106      */
1107     function ownerOf(uint256 tokenId) public view override returns (address) {
1108         return ownershipOf(tokenId).addr;
1109     }
1110 
1111     /**
1112      * @dev See {IERC721Metadata-name}.
1113      */
1114     function name() public view virtual override returns (string memory) {
1115         return _name;
1116     }
1117 
1118     /**
1119      * @dev See {IERC721Metadata-symbol}.
1120      */
1121     function symbol() public view virtual override returns (string memory) {
1122         return _symbol;
1123     }
1124 
1125     /**
1126      * @dev See {IERC721Metadata-tokenURI}.
1127      */
1128     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1129         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1130 
1131         string memory baseURI = _baseURI();
1132         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1133     }
1134 
1135     /**
1136      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1137      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1138      * by default, can be overriden in child contracts.
1139      */
1140     function _baseURI() internal view virtual returns (string memory) {
1141         return '';
1142     }
1143 
1144     /**
1145      * @dev See {IERC721-approve}.
1146      */
1147     function approve(address to, uint256 tokenId) public override {
1148         address owner = ERC721A.ownerOf(tokenId);
1149         if (to == owner) revert ApprovalToCurrentOwner();
1150 
1151         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1152             revert ApprovalCallerNotOwnerNorApproved();
1153         }
1154 
1155         _approve(to, tokenId, owner);
1156     }
1157 
1158     /**
1159      * @dev See {IERC721-getApproved}.
1160      */
1161     function getApproved(uint256 tokenId) public view override returns (address) {
1162         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1163 
1164         return _tokenApprovals[tokenId];
1165     }
1166 
1167     /**
1168      * @dev See {IERC721-setApprovalForAll}.
1169      */
1170     function setApprovalForAll(address operator, bool approved) public override {
1171         if (operator == _msgSender()) revert ApproveToCaller();
1172 
1173         _operatorApprovals[_msgSender()][operator] = approved;
1174         emit ApprovalForAll(_msgSender(), operator, approved);
1175     }
1176 
1177     /**
1178      * @dev See {IERC721-isApprovedForAll}.
1179      */
1180     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1181         return _operatorApprovals[owner][operator];
1182     }
1183 
1184     /**
1185      * @dev See {IERC721-transferFrom}.
1186      */
1187     function transferFrom(
1188         address from,
1189         address to,
1190         uint256 tokenId
1191     ) public virtual override {
1192         _transfer(from, to, tokenId);
1193     }
1194 
1195     /**
1196      * @dev See {IERC721-safeTransferFrom}.
1197      */
1198     function safeTransferFrom(
1199         address from,
1200         address to,
1201         uint256 tokenId
1202     ) public virtual override {
1203         safeTransferFrom(from, to, tokenId, '');
1204     }
1205 
1206     /**
1207      * @dev See {IERC721-safeTransferFrom}.
1208      */
1209     function safeTransferFrom(
1210         address from,
1211         address to,
1212         uint256 tokenId,
1213         bytes memory _data
1214     ) public virtual override {
1215         _transfer(from, to, tokenId);
1216         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1217             revert TransferToNonERC721ReceiverImplementer();
1218         }
1219     }
1220 
1221     /**
1222      * @dev Returns whether `tokenId` exists.
1223      *
1224      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1225      *
1226      * Tokens start existing when they are minted (`_mint`),
1227      */
1228     function _exists(uint256 tokenId) internal view returns (bool) {
1229         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1230             !_ownerships[tokenId].burned;
1231     }
1232 
1233     function _safeMint(address to, uint256 quantity) internal {
1234         _safeMint(to, quantity, '');
1235     }
1236 
1237     /**
1238      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1239      *
1240      * Requirements:
1241      *
1242      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1243      * - `quantity` must be greater than 0.
1244      *
1245      * Emits a {Transfer} event.
1246      */
1247     function _safeMint(
1248         address to,
1249         uint256 quantity,
1250         bytes memory _data
1251     ) internal {
1252         _mint(to, quantity, _data, true);
1253     }
1254 
1255     /**
1256      * @dev Mints `quantity` tokens and transfers them to `to`.
1257      *
1258      * Requirements:
1259      *
1260      * - `to` cannot be the zero address.
1261      * - `quantity` must be greater than 0.
1262      *
1263      * Emits a {Transfer} event.
1264      */
1265     function _mint(
1266         address to,
1267         uint256 quantity,
1268         bytes memory _data,
1269         bool safe
1270     ) internal {
1271         uint256 startTokenId = _currentIndex;
1272         if (to == address(0)) revert MintToZeroAddress();
1273         if (quantity == 0) revert MintZeroQuantity();
1274 
1275         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1276 
1277         // Overflows are incredibly unrealistic.
1278         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1279         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1280         unchecked {
1281             _addressData[to].balance += uint64(quantity);
1282             _addressData[to].numberMinted += uint64(quantity);
1283 
1284             _ownerships[startTokenId].addr = to;
1285             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1286 
1287             uint256 updatedIndex = startTokenId;
1288             uint256 end = updatedIndex + quantity;
1289 
1290             if (safe && to.isContract()) {
1291                 do {
1292                     emit Transfer(address(0), to, updatedIndex);
1293                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1294                         revert TransferToNonERC721ReceiverImplementer();
1295                     }
1296                 } while (updatedIndex != end);
1297                 // Reentrancy protection
1298                 if (_currentIndex != startTokenId) revert();
1299             } else {
1300                 do {
1301                     emit Transfer(address(0), to, updatedIndex++);
1302                 } while (updatedIndex != end);
1303             }
1304             _currentIndex = updatedIndex;
1305         }
1306         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1307     }
1308 
1309     /**
1310      * @dev Transfers `tokenId` from `from` to `to`.
1311      *
1312      * Requirements:
1313      *
1314      * - `to` cannot be the zero address.
1315      * - `tokenId` token must be owned by `from`.
1316      *
1317      * Emits a {Transfer} event.
1318      */
1319     function _transfer(
1320         address from,
1321         address to,
1322         uint256 tokenId
1323     ) private {
1324         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1325 
1326         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1327             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1328             getApproved(tokenId) == _msgSender());
1329 
1330         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1331         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1332         if (to == address(0)) revert TransferToZeroAddress();
1333 
1334         _beforeTokenTransfers(from, to, tokenId, 1);
1335 
1336         // Clear approvals from the previous owner
1337         _approve(address(0), tokenId, prevOwnership.addr);
1338 
1339         // Underflow of the sender's balance is impossible because we check for
1340         // ownership above and the recipient's balance can't realistically overflow.
1341         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1342         unchecked {
1343             _addressData[from].balance -= 1;
1344             _addressData[to].balance += 1;
1345 
1346             _ownerships[tokenId].addr = to;
1347             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1348 
1349             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1350             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1351             uint256 nextTokenId = tokenId + 1;
1352             if (_ownerships[nextTokenId].addr == address(0)) {
1353                 // This will suffice for checking _exists(nextTokenId),
1354                 // as a burned slot cannot contain the zero address.
1355                 if (nextTokenId < _currentIndex) {
1356                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1357                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1358                 }
1359             }
1360         }
1361 
1362         emit Transfer(from, to, tokenId);
1363         _afterTokenTransfers(from, to, tokenId, 1);
1364     }
1365 
1366     /**
1367      * @dev Destroys `tokenId`.
1368      * The approval is cleared when the token is burned.
1369      *
1370      * Requirements:
1371      *
1372      * - `tokenId` must exist.
1373      *
1374      * Emits a {Transfer} event.
1375      */
1376     function _burn(uint256 tokenId) internal virtual {
1377         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1378 
1379         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1380 
1381         // Clear approvals from the previous owner
1382         _approve(address(0), tokenId, prevOwnership.addr);
1383 
1384         // Underflow of the sender's balance is impossible because we check for
1385         // ownership above and the recipient's balance can't realistically overflow.
1386         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1387         unchecked {
1388             _addressData[prevOwnership.addr].balance -= 1;
1389             _addressData[prevOwnership.addr].numberBurned += 1;
1390 
1391             // Keep track of who burned the token, and the timestamp of burning.
1392             _ownerships[tokenId].addr = prevOwnership.addr;
1393             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1394             _ownerships[tokenId].burned = true;
1395 
1396             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1397             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1398             uint256 nextTokenId = tokenId + 1;
1399             if (_ownerships[nextTokenId].addr == address(0)) {
1400                 // This will suffice for checking _exists(nextTokenId),
1401                 // as a burned slot cannot contain the zero address.
1402                 if (nextTokenId < _currentIndex) {
1403                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1404                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1405                 }
1406             }
1407         }
1408 
1409         emit Transfer(prevOwnership.addr, address(0), tokenId);
1410         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1411 
1412         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1413         unchecked {
1414             _burnCounter++;
1415         }
1416     }
1417 
1418     /**
1419      * @dev Approve `to` to operate on `tokenId`
1420      *
1421      * Emits a {Approval} event.
1422      */
1423     function _approve(
1424         address to,
1425         uint256 tokenId,
1426         address owner
1427     ) private {
1428         _tokenApprovals[tokenId] = to;
1429         emit Approval(owner, to, tokenId);
1430     }
1431 
1432     /**
1433      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1434      *
1435      * @param from address representing the previous owner of the given token ID
1436      * @param to target address that will receive the tokens
1437      * @param tokenId uint256 ID of the token to be transferred
1438      * @param _data bytes optional data to send along with the call
1439      * @return bool whether the call correctly returned the expected magic value
1440      */
1441     function _checkContractOnERC721Received(
1442         address from,
1443         address to,
1444         uint256 tokenId,
1445         bytes memory _data
1446     ) private returns (bool) {
1447         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1448             return retval == IERC721Receiver(to).onERC721Received.selector;
1449         } catch (bytes memory reason) {
1450             if (reason.length == 0) {
1451                 revert TransferToNonERC721ReceiverImplementer();
1452             } else {
1453                 assembly {
1454                     revert(add(32, reason), mload(reason))
1455                 }
1456             }
1457         }
1458     }
1459 
1460     /**
1461      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1462      * And also called before burning one token.
1463      *
1464      * startTokenId - the first token id to be transferred
1465      * quantity - the amount to be transferred
1466      *
1467      * Calling conditions:
1468      *
1469      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1470      * transferred to `to`.
1471      * - When `from` is zero, `tokenId` will be minted for `to`.
1472      * - When `to` is zero, `tokenId` will be burned by `from`.
1473      * - `from` and `to` are never both zero.
1474      */
1475     function _beforeTokenTransfers(
1476         address from,
1477         address to,
1478         uint256 startTokenId,
1479         uint256 quantity
1480     ) internal virtual {}
1481 
1482     /**
1483      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1484      * minting.
1485      * And also called after one token has been burned.
1486      *
1487      * startTokenId - the first token id to be transferred
1488      * quantity - the amount to be transferred
1489      *
1490      * Calling conditions:
1491      *
1492      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1493      * transferred to `to`.
1494      * - When `from` is zero, `tokenId` has been minted for `to`.
1495      * - When `to` is zero, `tokenId` has been burned by `from`.
1496      * - `from` and `to` are never both zero.
1497      */
1498     function _afterTokenTransfers(
1499         address from,
1500         address to,
1501         uint256 startTokenId,
1502         uint256 quantity
1503     ) internal virtual {}
1504 }
1505 // File: contracts/AzukiNext.sol
1506 
1507 
1508 
1509 pragma solidity >=0.8.4 <0.9.0;
1510 
1511 
1512 
1513 
1514 contract ToxicTurtles is ERC721A, Ownable, ReentrancyGuard, ERC2981 {
1515 
1516   using Strings for uint256;
1517 
1518   string public uriPrefix = '';
1519   string public uriSuffix = '.json';
1520   
1521   uint256 public presalePrice;
1522   uint256 public publicPrice;
1523   uint256 public maxSupply;
1524   uint256 public maxPresale;
1525   uint256 public maxPublic; 
1526   uint256 public maxMintAmountPerTx;
1527 
1528   address public signerAddress;
1529   address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1530 
1531   mapping(address => uint256) public preSaleListCounter;
1532   mapping(address => uint256) public publicCounter;
1533 
1534   uint256 public saleStatus;
1535 
1536   constructor() ERC721A("Toxic Turtles", "TT") {
1537     _setDefaultRoyalty(0xD31e11a3620Ec6e4409A4A811d862034e54b8C77, 500);
1538     presalePrice = 0 ether;
1539     publicPrice = 0.03 ether;
1540     maxSupply = 5000;
1541     maxPresale = 1;
1542     maxPublic = 5;
1543     maxMintAmountPerTx = 5;    
1544     signerAddress = 0x7C6B970eF4E98E973830735a3eE89c2BAA8A1b1C;
1545     setUriPrefix("https://gateway.pinata.cloud/ipfs/Qmbhv5d1sajQuuj91wB8GBCX3E5D5ZkmtGmw87zW6nQZVG/");
1546   }
1547 
1548   modifier mintCompliance(uint256 _mintAmount) {
1549     require(tx.origin == msg.sender, "The caller is another contract");
1550     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
1551     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1552     _;
1553   }
1554 
1555 
1556   function whitelistMint(bytes memory sig) public payable mintCompliance(1) {
1557     require(saleStatus == 1, "The whitelist sale is not enabled!");
1558     require(verify(sig, _msgSender()), "Sorry, but you are not in WL");
1559     require(msg.value >= presalePrice, 'Insufficient funds!');
1560     require(preSaleListCounter[_msgSender()] + 1 <= maxPresale,"Exceeded max available to purchase");
1561     preSaleListCounter[_msgSender()] += 1;
1562     _safeMint(_msgSender(), 1);
1563   }
1564 
1565   function publicMint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1566     require(saleStatus==2, 'Public mint disabled');
1567     require(msg.value >= publicPrice * _mintAmount, 'Insufficient funds!');
1568     require(publicCounter[_msgSender()] + _mintAmount <= maxPublic,"exceeds max per address");
1569     publicCounter[_msgSender()] += _mintAmount;
1570     _safeMint(_msgSender(), _mintAmount);
1571   }
1572   
1573   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1574     _safeMint(_receiver, _mintAmount);
1575   }
1576 
1577   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1578     uint256 ownerTokenCount = balanceOf(_owner);
1579     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1580     uint256 currentTokenId = _startTokenId();
1581     uint256 ownedTokenIndex = 0;
1582 
1583     while (ownedTokenIndex < ownerTokenCount && currentTokenId < maxSupply) {
1584       address currentTokenOwner = ownerOf(currentTokenId);
1585 
1586       if (currentTokenOwner == _owner) {
1587         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1588 
1589         ownedTokenIndex++;
1590       }
1591 
1592       currentTokenId++;
1593     }
1594 
1595     return ownedTokenIds;
1596   }
1597 
1598   function _startTokenId() internal view virtual override returns (uint256) {
1599         return 1;
1600     }
1601 
1602   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1603     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1604 
1605     string memory currentBaseURI = _baseURI();
1606     return bytes(currentBaseURI).length > 0
1607         ? string(abi.encodePacked(currentBaseURI,_tokenId.toString(), uriSuffix))
1608         : '';
1609   }
1610 
1611 
1612 //*******************ADMIN AREA********************
1613 
1614   function setSignerAddress(address newSigner) public onlyOwner {
1615       signerAddress = newSigner;
1616   }
1617 
1618   function setPresalePrice(uint256 _cost) public onlyOwner {
1619     presalePrice = _cost;
1620   }
1621 
1622     function setPublicPrice(uint256 _cost) public onlyOwner {
1623     publicPrice = _cost;
1624   }
1625 
1626   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1627     maxMintAmountPerTx = _maxMintAmountPerTx;
1628   }
1629 
1630     function setMaxPresale(uint256 _maxMintAmountPresale) public onlyOwner {
1631     maxPresale = _maxMintAmountPresale;
1632   }
1633 
1634     function setMaxPublic(uint256 _maxMintAmountPublic) public onlyOwner {
1635     maxPublic = _maxMintAmountPublic;
1636   }
1637 
1638   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1639     uriPrefix = _uriPrefix;
1640   }
1641 
1642   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1643     uriSuffix = _uriSuffix;
1644   }
1645 
1646 
1647   function supportsInterface(bytes4 interfaceId) public view virtual override(ERC2981, ERC721A) returns (bool) {
1648         return
1649             interfaceId == type(IERC2981).interfaceId ||
1650             interfaceId == type(IERC721).interfaceId ||
1651             super.supportsInterface(interfaceId);
1652     }
1653 
1654   function setDefaultRoyalty(address _receiver, uint96 _feeNumerator) public {
1655       _setDefaultRoyalty(_receiver, _feeNumerator);
1656   }
1657 
1658   function setSaleStatus(uint256 _status) public onlyOwner {
1659     saleStatus = _status;
1660   }
1661 
1662   function withdraw() public onlyOwner nonReentrant {
1663 
1664    (bool hs, ) = payable(0x2399e46f0103E3c1266A3e4e672CE806FB9E6d60).call{value: address(this).balance * 6 / 100}('');
1665     require(hs);
1666 
1667     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1668     require(os);
1669   }
1670 
1671   function _baseURI() internal view virtual override returns (string memory) {
1672     return uriPrefix;
1673   }
1674 
1675 //*****************************OPENSEA PROXY*********************************
1676 
1677   function isApprovedForAll(address owner, address operator)
1678         override
1679         public
1680         view
1681         returns (bool)
1682     {
1683         // Whitelist OpenSea proxy contract for easy trading.
1684         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1685         if (address(proxyRegistry.proxies(owner)) == operator) {
1686             return true;
1687         }
1688 
1689         return super.isApprovedForAll(owner, operator);
1690     }
1691 
1692 
1693 //*****************************SIGNATURE*********************************
1694 
1695 function getMessageHash(address _message) public pure returns(bytes32) 
1696 { 
1697     return keccak256(abi.encodePacked(_message)); 
1698 } 
1699  
1700 function getMessageHashEth(bytes32 _sender) public pure returns(bytes32) 
1701 { 
1702     bytes memory prefix = "\x19Ethereum Signed Message:\n32"; 
1703     return keccak256(abi.encodePacked(prefix,_sender)); 
1704 } 
1705  
1706 function verify(bytes memory _signature, address sender) public view returns(bool) 
1707 { 
1708     bytes32 messageHas = getMessageHash(sender); 
1709     bytes32 messageHashEth = getMessageHashEth(messageHas);     
1710     return recoverSigner(messageHashEth, _signature) == signerAddress; 
1711  
1712 } 
1713  
1714 function recoverSigner(bytes32 _messageHash, bytes memory _signature) public pure returns (address) 
1715 { 
1716     (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature); 
1717     return ecrecover(_messageHash, v ,r, s); 
1718 } 
1719  
1720 function splitSignature(bytes memory _sig) public pure returns (bytes32 r, bytes32 s, uint8 v) 
1721 { 
1722     require(_sig.length == 65, "invalid signature length"); 
1723      
1724     assembly { 
1725         r := mload(add(_sig, 32)) 
1726         s := mload(add(_sig, 64)) 
1727         v := byte(0, mload(add(_sig, 96))) 
1728     } 
1729 } 
1730 
1731 
1732 }
1733 
1734 contract OwnableDelegateProxy { }
1735 contract ProxyRegistry {
1736     mapping(address => OwnableDelegateProxy) public proxies;
1737 }