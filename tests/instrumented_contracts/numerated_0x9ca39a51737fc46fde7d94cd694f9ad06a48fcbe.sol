1 // SPDX-License-Identifier: UNLICENSED 
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
27 
28 
29 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
30 
31 pragma solidity ^0.8.0;
32 
33 
34 /**
35  * @dev Implementation of the {IERC165} interface.
36  *
37  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
38  * for the additional interface id that will be supported. For example:
39  *
40  * ```solidity
41  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
42  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
43  * }
44  * ```
45  *
46  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
47  */
48 abstract contract ERC165 is IERC165 {
49     /**
50      * @dev See {IERC165-supportsInterface}.
51      */
52     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
53         return interfaceId == type(IERC165).interfaceId;
54     }
55 }
56 
57 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/interfaces/IERC2981.sol
58 
59 
60 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
61 
62 pragma solidity ^0.8.0;
63 
64 
65 /**
66  * @dev Interface for the NFT Royalty Standard.
67  *
68  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
69  * support for royalty payments across all NFT marketplaces and ecosystem participants.
70  *
71  * _Available since v4.5._
72  */
73 interface IERC2981 is IERC165 {
74     /**
75      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
76      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
77      */
78     function royaltyInfo(
79         uint256 tokenId,
80         uint256 salePrice
81     ) external view returns (address receiver, uint256 royaltyAmount);
82 }
83 
84 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/common/ERC2981.sol
85 
86 
87 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
88 
89 pragma solidity ^0.8.0;
90 
91 
92 
93 /**
94  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
95  *
96  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
97  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
98  *
99  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
100  * fee is specified in basis points by default.
101  *
102  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
103  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
104  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
105  *
106  * _Available since v4.5._
107  */
108 abstract contract ERC2981 is IERC2981, ERC165 {
109     struct RoyaltyInfo {
110         address receiver;
111         uint96 royaltyFraction;
112     }
113 
114     RoyaltyInfo private _defaultRoyaltyInfo;
115     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
116 
117     /**
118      * @dev See {IERC165-supportsInterface}.
119      */
120     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
121         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
122     }
123 
124     /**
125      * @inheritdoc IERC2981
126      */
127     function royaltyInfo(uint256 tokenId, uint256 salePrice) public view virtual override returns (address, uint256) {
128         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[tokenId];
129 
130         if (royalty.receiver == address(0)) {
131             royalty = _defaultRoyaltyInfo;
132         }
133 
134         uint256 royaltyAmount = (salePrice * royalty.royaltyFraction) / _feeDenominator();
135 
136         return (royalty.receiver, royaltyAmount);
137     }
138 
139     /**
140      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
141      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
142      * override.
143      */
144     function _feeDenominator() internal pure virtual returns (uint96) {
145         return 10000;
146     }
147 
148     /**
149      * @dev Sets the royalty information that all ids in this contract will default to.
150      *
151      * Requirements:
152      *
153      * - `receiver` cannot be the zero address.
154      * - `feeNumerator` cannot be greater than the fee denominator.
155      */
156     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
157         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
158         require(receiver != address(0), "ERC2981: invalid receiver");
159 
160         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
161     }
162 
163     /**
164      * @dev Removes default royalty information.
165      */
166     function _deleteDefaultRoyalty() internal virtual {
167         delete _defaultRoyaltyInfo;
168     }
169 
170     /**
171      * @dev Sets the royalty information for a specific token id, overriding the global default.
172      *
173      * Requirements:
174      *
175      * - `receiver` cannot be the zero address.
176      * - `feeNumerator` cannot be greater than the fee denominator.
177      */
178     function _setTokenRoyalty(uint256 tokenId, address receiver, uint96 feeNumerator) internal virtual {
179         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
180         require(receiver != address(0), "ERC2981: Invalid parameters");
181 
182         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
183     }
184 
185     /**
186      * @dev Resets royalty information for the token id back to the global default.
187      */
188     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
189         delete _tokenRoyaltyInfo[tokenId];
190     }
191 }
192 
193 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
194 
195 
196 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
197 
198 pragma solidity ^0.8.0;
199 
200 /**
201  * @dev Contract module that helps prevent reentrant calls to a function.
202  *
203  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
204  * available, which can be applied to functions to make sure there are no nested
205  * (reentrant) calls to them.
206  *
207  * Note that because there is a single `nonReentrant` guard, functions marked as
208  * `nonReentrant` may not call one another. This can be worked around by making
209  * those functions `private`, and then adding `external` `nonReentrant` entry
210  * points to them.
211  *
212  * TIP: If you would like to learn more about reentrancy and alternative ways
213  * to protect against it, check out our blog post
214  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
215  */
216 abstract contract ReentrancyGuard {
217     // Booleans are more expensive than uint256 or any type that takes up a full
218     // word because each write operation emits an extra SLOAD to first read the
219     // slot's contents, replace the bits taken up by the boolean, and then write
220     // back. This is the compiler's defense against contract upgrades and
221     // pointer aliasing, and it cannot be disabled.
222 
223     // The values being non-zero value makes deployment a bit more expensive,
224     // but in exchange the refund on every call to nonReentrant will be lower in
225     // amount. Since refunds are capped to a percentage of the total
226     // transaction's gas, it is best to keep them low in cases like this one, to
227     // increase the likelihood of the full refund coming into effect.
228     uint256 private constant _NOT_ENTERED = 1;
229     uint256 private constant _ENTERED = 2;
230 
231     uint256 private _status;
232 
233     constructor() {
234         _status = _NOT_ENTERED;
235     }
236 
237     /**
238      * @dev Prevents a contract from calling itself, directly or indirectly.
239      * Calling a `nonReentrant` function from another `nonReentrant`
240      * function is not supported. It is possible to prevent this from happening
241      * by making the `nonReentrant` function external, and making it call a
242      * `private` function that does the actual work.
243      */
244     modifier nonReentrant() {
245         _nonReentrantBefore();
246         _;
247         _nonReentrantAfter();
248     }
249 
250     function _nonReentrantBefore() private {
251         // On the first call to nonReentrant, _status will be _NOT_ENTERED
252         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
253 
254         // Any calls to nonReentrant after this point will fail
255         _status = _ENTERED;
256     }
257 
258     function _nonReentrantAfter() private {
259         // By storing the original value once again, a refund is triggered (see
260         // https://eips.ethereum.org/EIPS/eip-2200)
261         _status = _NOT_ENTERED;
262     }
263 }
264 
265 // File: NFTS/Lilverse/Contracts/Lilverse2.0.sol
266 
267 
268 pragma solidity ^0.8.0;
269 
270 
271 
272 
273 pragma solidity ^0.8.0;
274 
275 /**
276  * @dev String operations.
277  */
278 library Strings {
279     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
280 
281     /**
282      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
283      */
284     function toString(uint256 value) internal pure returns (string memory) {
285         // Inspired by OraclizeAPI's implementation - MIT licence
286         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
287 
288         if (value == 0) {
289             return "0";
290         }
291         uint256 temp = value;
292         uint256 digits;
293         while (temp != 0) {
294             digits++;
295             temp /= 10;
296         }
297         bytes memory buffer = new bytes(digits);
298         while (value != 0) {
299             digits -= 1;
300             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
301             value /= 10;
302         }
303         return string(buffer);
304     }
305 
306     /**
307      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
308      */
309     function toHexString(uint256 value) internal pure returns (string memory) {
310         if (value == 0) {
311             return "0x00";
312         }
313         uint256 temp = value;
314         uint256 length = 0;
315         while (temp != 0) {
316             length++;
317             temp >>= 8;
318         }
319         return toHexString(value, length);
320     }
321 
322     /**
323      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
324      */
325     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
326         bytes memory buffer = new bytes(2 * length + 2);
327         buffer[0] = "0";
328         buffer[1] = "x";
329         for (uint256 i = 2 * length + 1; i > 1; --i) {
330             buffer[i] = _HEX_SYMBOLS[value & 0xf];
331             value >>= 4;
332         }
333         require(value == 0, "Strings: hex length insufficient");
334         return string(buffer);
335     }
336 }
337 
338 // File: @openzeppelin/contracts/utils/Context.sol
339 
340 
341 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
342 
343 pragma solidity ^0.8.0;
344 
345 /**
346  * @dev Provides information about the current execution context, including the
347  * sender of the transaction and its data. While these are generally available
348  * via msg.sender and msg.data, they should not be accessed in such a direct
349  * manner, since when dealing with meta-transactions the account sending and
350  * paying for execution may not be the actual sender (as far as an application
351  * is concerned).
352  *
353  * This contract is only required for intermediate, library-like contracts.
354  */
355 abstract contract Context {
356     function _msgSender() internal view virtual returns (address) {
357         return msg.sender;
358     }
359 
360     function _msgData() internal view virtual returns (bytes calldata) {
361         return msg.data;
362     }
363 }
364 
365 // File: @openzeppelin/contracts/access/Ownable.sol
366 
367 
368 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
369 
370 pragma solidity ^0.8.0;
371 
372 
373 /**
374  * @dev Contract module which provides a basic access control mechanism, where
375  * there is an account (an owner) that can be granted exclusive access to
376  * specific functions.
377  *
378  * By default, the owner account will be the one that deploys the contract. This
379  * can later be changed with {transferOwnership}.
380  *
381  * This module is used through inheritance. It will make available the modifier
382  * `onlyOwner`, which can be applied to your functions to restrict their use to
383  * the owner.
384  */
385 abstract contract Ownable is Context {
386     address private _owner;
387 
388     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
389 
390     /**
391      * @dev Initializes the contract setting the deployer as the initial owner.
392      */
393     constructor() {
394         _transferOwnership(_msgSender());
395     }
396 
397     /**
398      * @dev Returns the address of the current owner.
399      */
400     function owner() public view virtual returns (address) {
401         return _owner;
402     }
403 
404     /**
405      * @dev Throws if called by any account other than the owner.
406      */
407     modifier onlyOwner() {
408         require(owner() == _msgSender(), "Ownable: caller is not the owner");
409         _;
410     }
411 
412     /**
413      * @dev Leaves the contract without owner. It will not be possible to call
414      * `onlyOwner` functions anymore. Can only be called by the current owner.
415      *
416      * NOTE: Renouncing ownership will leave the contract without an owner,
417      * thereby removing any functionality that is only available to the owner.
418      */
419     function renounceOwnership() public virtual onlyOwner {
420         _transferOwnership(address(0));
421     }
422 
423     /**
424      * @dev Transfers ownership of the contract to a new account (`newOwner`).
425      * Can only be called by the current owner.
426      */
427     function transferOwnership(address newOwner) public virtual onlyOwner {
428         require(newOwner != address(0), "Ownable: new owner is the zero address");
429         _transferOwnership(newOwner);
430     }
431 
432     /**
433      * @dev Transfers ownership of the contract to a new account (`newOwner`).
434      * Internal function without access restriction.
435      */
436     function _transferOwnership(address newOwner) internal virtual {
437         address oldOwner = _owner;
438         _owner = newOwner;
439         emit OwnershipTransferred(oldOwner, newOwner);
440     }
441 }
442 
443 // File: @openzeppelin/contracts/utils/Address.sol
444 
445 
446 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
447 
448 pragma solidity ^0.8.0;
449 
450 /**
451  * @dev Collection of functions related to the address type
452  */
453 library Address {
454     /**
455      * @dev Returns true if `account` is a contract.
456      *
457      * [IMPORTANT]
458      * ====
459      * It is unsafe to assume that an address for which this function returns
460      * false is an externally-owned account (EOA) and not a contract.
461      *
462      * Among others, `isContract` will return false for the following
463      * types of addresses:
464      *
465      *  - an externally-owned account
466      *  - a contract in construction
467      *  - an address where a contract will be created
468      *  - an address where a contract lived, but was destroyed
469      * ====
470      */
471     function isContract(address account) internal view returns (bool) {
472         // This method relies on extcodesize, which returns 0 for contracts in
473         // construction, since the code is only stored at the end of the
474         // constructor execution.
475 
476         uint256 size;
477         assembly {
478             size := extcodesize(account)
479         }
480         return size > 0;
481     }
482 
483     /**
484      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
485      * `recipient`, forwarding all available gas and reverting on errors.
486      *
487      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
488      * of certain opcodes, possibly making contracts go over the 2300 gas limit
489      * imposed by `transfer`, making them unable to receive funds via
490      * `transfer`. {sendValue} removes this limitation.
491      *
492      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
493      *
494      * IMPORTANT: because control is transferred to `recipient`, care must be
495      * taken to not create reentrancy vulnerabilities. Consider using
496      * {ReentrancyGuard} or the
497      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
498      */
499     function sendValue(address payable recipient, uint256 amount) internal {
500         require(address(this).balance >= amount, "Address: insufficient balance");
501 
502         (bool success, ) = recipient.call{value: amount}("");
503         require(success, "Address: unable to send value, recipient may have reverted");
504     }
505 
506     /**
507      * @dev Performs a Solidity function call using a low level `call`. A
508      * plain `call` is an unsafe replacement for a function call: use this
509      * function instead.
510      *
511      * If `target` reverts with a revert reason, it is bubbled up by this
512      * function (like regular Solidity function calls).
513      *
514      * Returns the raw returned data. To convert to the expected return value,
515      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
516      *
517      * Requirements:
518      *
519      * - `target` must be a contract.
520      * - calling `target` with `data` must not revert.
521      *
522      * _Available since v3.1._
523      */
524     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
525         return functionCall(target, data, "Address: low-level call failed");
526     }
527 
528     /**
529      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
530      * `errorMessage` as a fallback revert reason when `target` reverts.
531      *
532      * _Available since v3.1._
533      */
534     function functionCall(
535         address target,
536         bytes memory data,
537         string memory errorMessage
538     ) internal returns (bytes memory) {
539         return functionCallWithValue(target, data, 0, errorMessage);
540     }
541 
542     /**
543      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
544      * but also transferring `value` wei to `target`.
545      *
546      * Requirements:
547      *
548      * - the calling contract must have an ETH balance of at least `value`.
549      * - the called Solidity function must be `payable`.
550      *
551      * _Available since v3.1._
552      */
553     function functionCallWithValue(
554         address target,
555         bytes memory data,
556         uint256 value
557     ) internal returns (bytes memory) {
558         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
559     }
560 
561     /**
562      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
563      * with `errorMessage` as a fallback revert reason when `target` reverts.
564      *
565      * _Available since v3.1._
566      */
567     function functionCallWithValue(
568         address target,
569         bytes memory data,
570         uint256 value,
571         string memory errorMessage
572     ) internal returns (bytes memory) {
573         require(address(this).balance >= value, "Address: insufficient balance for call");
574         require(isContract(target), "Address: call to non-contract");
575 
576         (bool success, bytes memory returndata) = target.call{value: value}(data);
577         return verifyCallResult(success, returndata, errorMessage);
578     }
579 
580     /**
581      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
582      * but performing a static call.
583      *
584      * _Available since v3.3._
585      */
586     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
587         return functionStaticCall(target, data, "Address: low-level static call failed");
588     }
589 
590     /**
591      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
592      * but performing a static call.
593      *
594      * _Available since v3.3._
595      */
596     function functionStaticCall(
597         address target,
598         bytes memory data,
599         string memory errorMessage
600     ) internal view returns (bytes memory) {
601         require(isContract(target), "Address: static call to non-contract");
602 
603         (bool success, bytes memory returndata) = target.staticcall(data);
604         return verifyCallResult(success, returndata, errorMessage);
605     }
606 
607     /**
608      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
609      * but performing a delegate call.
610      *
611      * _Available since v3.4._
612      */
613     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
614         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
615     }
616 
617     /**
618      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
619      * but performing a delegate call.
620      *
621      * _Available since v3.4._
622      */
623     function functionDelegateCall(
624         address target,
625         bytes memory data,
626         string memory errorMessage
627     ) internal returns (bytes memory) {
628         require(isContract(target), "Address: delegate call to non-contract");
629 
630         (bool success, bytes memory returndata) = target.delegatecall(data);
631         return verifyCallResult(success, returndata, errorMessage);
632     }
633 
634     /**
635      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
636      * revert reason using the provided one.
637      *
638      * _Available since v4.3._
639      */
640     function verifyCallResult(
641         bool success,
642         bytes memory returndata,
643         string memory errorMessage
644     ) internal pure returns (bytes memory) {
645         if (success) {
646             return returndata;
647         } else {
648             // Look for revert reason and bubble it up if present
649             if (returndata.length > 0) {
650                 // The easiest way to bubble the revert reason is using memory via assembly
651 
652                 assembly {
653                     let returndata_size := mload(returndata)
654                     revert(add(32, returndata), returndata_size)
655                 }
656             } else {
657                 revert(errorMessage);
658             }
659         }
660     }
661 }
662 
663 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
664 
665 
666 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
667 
668 pragma solidity ^0.8.0;
669 
670 /**
671  * @title ERC721 token receiver interface
672  * @dev Interface for any contract that wants to support safeTransfers
673  * from ERC721 asset contracts.
674  */
675 interface IERC721Receiver {
676     /**
677      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
678      * by `operator` from `from`, this function is called.
679      *
680      * It must return its Solidity selector to confirm the token transfer.
681      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
682      *
683      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
684      */
685     function onERC721Received(
686         address operator,
687         address from,
688         uint256 tokenId,
689         bytes calldata data
690     ) external returns (bytes4);
691 }
692 
693 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
694 
695 
696 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
697 
698 pragma solidity ^0.8.0;
699 
700 /**
701  * @dev Interface of the ERC165 standard, as defined in the
702  * https://eips.ethereum.org/EIPS/eip-165[EIP].
703  *
704  * Implementers can declare support of contract interfaces, which can then be
705  * queried by others ({ERC165Checker}).
706  *
707  * For an implementation, see {ERC165}.
708  */
709 
710 
711 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
712 
713 
714 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
715 
716 pragma solidity ^0.8.0;
717 
718 
719 /**
720  * @dev Implementation of the {IERC165} interface.
721  *
722  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
723  * for the additional interface id that will be supported. For example:
724  *
725  * ```solidity
726  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
727  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
728  * }
729  * ```
730  *
731  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
732  */
733 
734 
735 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
736 
737 
738 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
739 
740 pragma solidity ^0.8.0;
741 
742 
743 /**
744  * @dev Required interface of an ERC721 compliant contract.
745  */
746 interface IERC721 is IERC165 {
747     /**
748      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
749      */
750     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
751 
752     /**
753      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
754      */
755     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
756 
757     /**
758      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
759      */
760     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
761 
762     /**
763      * @dev Returns the number of tokens in ``owner``'s account.
764      */
765     function balanceOf(address owner) external view returns (uint256 balance);
766 
767     /**
768      * @dev Returns the owner of the `tokenId` token.
769      *
770      * Requirements:
771      *
772      * - `tokenId` must exist.
773      */
774     function ownerOf(uint256 tokenId) external view returns (address owner);
775 
776     /**
777      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
778      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
779      *
780      * Requirements:
781      *
782      * - `from` cannot be the zero address.
783      * - `to` cannot be the zero address.
784      * - `tokenId` token must exist and be owned by `from`.
785      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
786      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
787      *
788      * Emits a {Transfer} event.
789      */
790     function safeTransferFrom(
791         address from,
792         address to,
793         uint256 tokenId
794     ) external;
795 
796     /**
797      * @dev Transfers `tokenId` token from `from` to `to`.
798      *
799      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
800      *
801      * Requirements:
802      *
803      * - `from` cannot be the zero address.
804      * - `to` cannot be the zero address.
805      * - `tokenId` token must be owned by `from`.
806      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
807      *
808      * Emits a {Transfer} event.
809      */
810     function transferFrom(
811         address from,
812         address to,
813         uint256 tokenId
814     ) external;
815 
816     /**
817      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
818      * The approval is cleared when the token is transferred.
819      *
820      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
821      *
822      * Requirements:
823      *
824      * - The caller must own the token or be an approved operator.
825      * - `tokenId` must exist.
826      *
827      * Emits an {Approval} event.
828      */
829     function approve(address to, uint256 tokenId) external;
830 
831     /**
832      * @dev Returns the account approved for `tokenId` token.
833      *
834      * Requirements:
835      *
836      * - `tokenId` must exist.
837      */
838     function getApproved(uint256 tokenId) external view returns (address operator);
839 
840     /**
841      * @dev Approve or remove `operator` as an operator for the caller.
842      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
843      *
844      * Requirements:
845      *
846      * - The `operator` cannot be the caller.
847      *
848      * Emits an {ApprovalForAll} event.
849      */
850     function setApprovalForAll(address operator, bool _approved) external;
851 
852     /**
853      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
854      *
855      * See {setApprovalForAll}
856      */
857     function isApprovedForAll(address owner, address operator) external view returns (bool);
858 
859     /**
860      * @dev Safely transfers `tokenId` token from `from` to `to`.
861      *
862      * Requirements:
863      *
864      * - `from` cannot be the zero address.
865      * - `to` cannot be the zero address.
866      * - `tokenId` token must exist and be owned by `from`.
867      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
868      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
869      *
870      * Emits a {Transfer} event.
871      */
872     function safeTransferFrom(
873         address from,
874         address to,
875         uint256 tokenId,
876         bytes calldata data
877     ) external;
878 }
879 
880 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
881 
882 
883 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
884 
885 pragma solidity ^0.8.0;
886 
887 
888 /**
889  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
890  * @dev See https://eips.ethereum.org/EIPS/eip-721
891  */
892 interface IERC721Enumerable is IERC721 {
893     /**
894      * @dev Returns the total amount of tokens stored by the contract.
895      */
896     function totalSupply() external view returns (uint256);
897 
898     /**
899      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
900      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
901      */
902     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
903 
904     /**
905      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
906      * Use along with {totalSupply} to enumerate all tokens.
907      */
908     function tokenByIndex(uint256 index) external view returns (uint256);
909 }
910 
911 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
912 
913 
914 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
915 
916 pragma solidity ^0.8.0;
917 
918 
919 /**
920  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
921  * @dev See https://eips.ethereum.org/EIPS/eip-721
922  */
923 interface IERC721Metadata is IERC721 {
924     /**
925      * @dev Returns the token collection name.
926      */
927     function name() external view returns (string memory);
928 
929     /**
930      * @dev Returns the token collection symbol.
931      */
932     function symbol() external view returns (string memory);
933 
934     /**
935      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
936      */
937     function tokenURI(uint256 tokenId) external view returns (string memory);
938 }
939 
940 // File: erc721a/contracts/ERC721A.sol
941 
942 
943 // Creator: Chiru Labs
944 
945 pragma solidity ^0.8.4;
946 
947 
948 
949 
950 
951 
952 
953 
954 
955 error ApprovalCallerNotOwnerNorApproved();
956 error ApprovalQueryForNonexistentToken();
957 error ApproveToCaller();
958 error ApprovalToCurrentOwner();
959 error BalanceQueryForZeroAddress();
960 error MintedQueryForZeroAddress();
961 error BurnedQueryForZeroAddress();
962 error AuxQueryForZeroAddress();
963 error MintToZeroAddress();
964 error MintZeroQuantity();
965 error OwnerIndexOutOfBounds();
966 error OwnerQueryForNonexistentToken();
967 error TokenIndexOutOfBounds();
968 error TransferCallerNotOwnerNorApproved();
969 error TransferFromIncorrectOwner();
970 error TransferToNonERC721ReceiverImplementer();
971 error TransferToZeroAddress();
972 error URIQueryForNonexistentToken();
973 
974 /**
975  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
976  * the Metadata extension. Built to optimize for lower gas during batch mints.
977  *
978  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
979  *
980  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
981  *
982  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
983  */
984 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
985     using Address for address;
986     using Strings for uint256;
987 
988     // Compiler will pack this into a single 256bit word.
989     struct TokenOwnership {
990         // The address of the owner.
991         address addr;
992         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
993         uint64 startTimestamp;
994         // Whether the token has been burned.
995         bool burned;
996     }
997 
998     // Compiler will pack this into a single 256bit word.
999     struct AddressData {
1000         // Realistically, 2**64-1 is more than enough.
1001         uint64 balance;
1002         // Keeps track of mint count with minimal overhead for tokenomics.
1003         uint64 numberMinted;
1004         // Keeps track of burn count with minimal overhead for tokenomics.
1005         uint64 numberBurned;
1006         // For miscellaneous variable(s) pertaining to the address
1007         // (e.g. number of whitelist mint slots used).
1008         // If there are multiple variables, please pack them into a uint64.
1009         uint64 aux;
1010     }
1011 
1012     // The tokenId of the next token to be minted.
1013     uint256 internal _currentIndex;
1014 
1015     // The number of tokens burned.
1016     uint256 internal _burnCounter;
1017 
1018     // Token name
1019     string private _name;
1020 
1021     // Token symbol
1022     string private _symbol;
1023 
1024     // Mapping from token ID to ownership details
1025     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1026     mapping(uint256 => TokenOwnership) internal _ownerships;
1027 
1028     // Mapping owner address to address data
1029     mapping(address => AddressData) private _addressData;
1030 
1031     // Mapping from token ID to approved address
1032     mapping(uint256 => address) private _tokenApprovals;
1033 
1034     // Mapping from owner to operator approvals
1035     mapping(address => mapping(address => bool)) private _operatorApprovals;
1036 
1037     constructor(string memory name_, string memory symbol_) {
1038         _name = name_;
1039         _symbol = symbol_;
1040         _currentIndex = _startTokenId();
1041     }
1042 
1043     /**
1044      * To change the starting tokenId, please override this function.
1045      */
1046     function _startTokenId() internal view virtual returns (uint256) {
1047         return 0;
1048     }
1049 
1050     /**
1051      * @dev See {IERC721Enumerable-totalSupply}.
1052      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1053      */
1054     function totalSupply() public view returns (uint256) {
1055         // Counter underflow is impossible as _burnCounter cannot be incremented
1056         // more than _currentIndex - _startTokenId() times
1057         unchecked {
1058             return _currentIndex - _burnCounter - _startTokenId();
1059         }
1060     }
1061 
1062     /**
1063      * Returns the total amount of tokens minted in the contract.
1064      */
1065     function _totalMinted() internal view returns (uint256) {
1066         // Counter underflow is impossible as _currentIndex does not decrement,
1067         // and it is initialized to _startTokenId()
1068         unchecked {
1069             return _currentIndex - _startTokenId();
1070         }
1071     }
1072 
1073     /**
1074      * @dev See {IERC165-supportsInterface}.
1075      */
1076     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1077         return
1078             interfaceId == type(IERC721).interfaceId ||
1079             interfaceId == type(IERC721Metadata).interfaceId ||
1080             super.supportsInterface(interfaceId);
1081     }
1082 
1083     /**
1084      * @dev See {IERC721-balanceOf}.
1085      */
1086     function balanceOf(address owner) public view override returns (uint256) {
1087         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1088         return uint256(_addressData[owner].balance);
1089     }
1090 
1091     /**
1092      * Returns the number of tokens minted by `owner`.
1093      */
1094     function _numberMinted(address owner) internal view returns (uint256) {
1095         if (owner == address(0)) revert MintedQueryForZeroAddress();
1096         return uint256(_addressData[owner].numberMinted);
1097     }
1098 
1099     /**
1100      * Returns the number of tokens burned by or on behalf of `owner`.
1101      */
1102     function _numberBurned(address owner) internal view returns (uint256) {
1103         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1104         return uint256(_addressData[owner].numberBurned);
1105     }
1106 
1107     /**
1108      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1109      */
1110     function _getAux(address owner) internal view returns (uint64) {
1111         if (owner == address(0)) revert AuxQueryForZeroAddress();
1112         return _addressData[owner].aux;
1113     }
1114 
1115     /**
1116      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1117      * If there are multiple variables, please pack them into a uint64.
1118      */
1119     function _setAux(address owner, uint64 aux) internal {
1120         if (owner == address(0)) revert AuxQueryForZeroAddress();
1121         _addressData[owner].aux = aux;
1122     }
1123 
1124     /**
1125      * Gas spent here starts off proportional to the maximum mint batch size.
1126      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1127      */
1128     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1129         uint256 curr = tokenId;
1130 
1131         unchecked {
1132             if (_startTokenId() <= curr && curr < _currentIndex) {
1133                 TokenOwnership memory ownership = _ownerships[curr];
1134                 if (!ownership.burned) {
1135                     if (ownership.addr != address(0)) {
1136                         return ownership;
1137                     }
1138                     // Invariant:
1139                     // There will always be an ownership that has an address and is not burned
1140                     // before an ownership that does not have an address and is not burned.
1141                     // Hence, curr will not underflow.
1142                     while (true) {
1143                         curr--;
1144                         ownership = _ownerships[curr];
1145                         if (ownership.addr != address(0)) {
1146                             return ownership;
1147                         }
1148                     }
1149                 }
1150             }
1151         }
1152         revert OwnerQueryForNonexistentToken();
1153     }
1154 
1155     /**
1156      * @dev See {IERC721-ownerOf}.
1157      */
1158     function ownerOf(uint256 tokenId) public view override returns (address) {
1159         return ownershipOf(tokenId).addr;
1160     }
1161 
1162     /**
1163      * @dev See {IERC721Metadata-name}.
1164      */
1165     function name() public view virtual override returns (string memory) {
1166         return _name;
1167     }
1168 
1169     /**
1170      * @dev See {IERC721Metadata-symbol}.
1171      */
1172     function symbol() public view virtual override returns (string memory) {
1173         return _symbol;
1174     }
1175 
1176     /**
1177      * @dev See {IERC721Metadata-tokenURI}.
1178      */
1179     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1180         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1181 
1182         string memory baseURI = _baseURI();
1183         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1184     }
1185 
1186     /**
1187      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1188      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1189      * by default, can be overriden in child contracts.
1190      */
1191     function _baseURI() internal view virtual returns (string memory) {
1192         return '';
1193     }
1194 
1195     /**
1196      * @dev See {IERC721-approve}.
1197      */
1198     function approve(address to, uint256 tokenId) public override {
1199         address owner = ERC721A.ownerOf(tokenId);
1200         if (to == owner) revert ApprovalToCurrentOwner();
1201 
1202         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1203             revert ApprovalCallerNotOwnerNorApproved();
1204         }
1205 
1206         _approve(to, tokenId, owner);
1207     }
1208 
1209     /**
1210      * @dev See {IERC721-getApproved}.
1211      */
1212     function getApproved(uint256 tokenId) public view override returns (address) {
1213         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1214 
1215         return _tokenApprovals[tokenId];
1216     }
1217 
1218     /**
1219      * @dev See {IERC721-setApprovalForAll}.
1220      */
1221     function setApprovalForAll(address operator, bool approved) public override {
1222         if (operator == _msgSender()) revert ApproveToCaller();
1223 
1224         _operatorApprovals[_msgSender()][operator] = approved;
1225         emit ApprovalForAll(_msgSender(), operator, approved);
1226     }
1227 
1228     /**
1229      * @dev See {IERC721-isApprovedForAll}.
1230      */
1231     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1232         return _operatorApprovals[owner][operator];
1233     }
1234 
1235     /**
1236      * @dev See {IERC721-transferFrom}.
1237      */
1238     function transferFrom(
1239         address from,
1240         address to,
1241         uint256 tokenId
1242     ) public virtual override {
1243         _transfer(from, to, tokenId);
1244     }
1245 
1246     /**
1247      * @dev See {IERC721-safeTransferFrom}.
1248      */
1249     function safeTransferFrom(
1250         address from,
1251         address to,
1252         uint256 tokenId
1253     ) public virtual override {
1254         safeTransferFrom(from, to, tokenId, '');
1255     }
1256 
1257     /**
1258      * @dev See {IERC721-safeTransferFrom}.
1259      */
1260     function safeTransferFrom(
1261         address from,
1262         address to,
1263         uint256 tokenId,
1264         bytes memory _data
1265     ) public virtual override {
1266         _transfer(from, to, tokenId);
1267         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1268             revert TransferToNonERC721ReceiverImplementer();
1269         }
1270     }
1271 
1272     /**
1273      * @dev Returns whether `tokenId` exists.
1274      *
1275      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1276      *
1277      * Tokens start existing when they are minted (`_mint`),
1278      */
1279     function _exists(uint256 tokenId) internal view returns (bool) {
1280         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1281             !_ownerships[tokenId].burned;
1282     }
1283 
1284     function _safeMint(address to, uint256 quantity) internal {
1285         _safeMint(to, quantity, '');
1286     }
1287 
1288     /**
1289      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1290      *
1291      * Requirements:
1292      *
1293      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1294      * - `quantity` must be greater than 0.
1295      *
1296      * Emits a {Transfer} event.
1297      */
1298     function _safeMint(
1299         address to,
1300         uint256 quantity,
1301         bytes memory _data
1302     ) internal {
1303         _mint(to, quantity, _data, true);
1304     }
1305 
1306     /**
1307      * @dev Mints `quantity` tokens and transfers them to `to`.
1308      *
1309      * Requirements:
1310      *
1311      * - `to` cannot be the zero address.
1312      * - `quantity` must be greater than 0.
1313      *
1314      * Emits a {Transfer} event.
1315      */
1316     function _mint(
1317         address to,
1318         uint256 quantity,
1319         bytes memory _data,
1320         bool safe
1321     ) internal {
1322         uint256 startTokenId = _currentIndex;
1323         if (to == address(0)) revert MintToZeroAddress();
1324         if (quantity == 0) revert MintZeroQuantity();
1325 
1326         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1327 
1328         // Overflows are incredibly unrealistic.
1329         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1330         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1331         unchecked {
1332             _addressData[to].balance += uint64(quantity);
1333             _addressData[to].numberMinted += uint64(quantity);
1334 
1335             _ownerships[startTokenId].addr = to;
1336             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1337 
1338             uint256 updatedIndex = startTokenId;
1339             uint256 end = updatedIndex + quantity;
1340 
1341             if (safe && to.isContract()) {
1342                 do {
1343                     emit Transfer(address(0), to, updatedIndex);
1344                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1345                         revert TransferToNonERC721ReceiverImplementer();
1346                     }
1347                 } while (updatedIndex != end);
1348                 // Reentrancy protection
1349                 if (_currentIndex != startTokenId) revert();
1350             } else {
1351                 do {
1352                     emit Transfer(address(0), to, updatedIndex++);
1353                 } while (updatedIndex != end);
1354             }
1355             _currentIndex = updatedIndex;
1356         }
1357         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1358     }
1359 
1360     /**
1361      * @dev Transfers `tokenId` from `from` to `to`.
1362      *
1363      * Requirements:
1364      *
1365      * - `to` cannot be the zero address.
1366      * - `tokenId` token must be owned by `from`.
1367      *
1368      * Emits a {Transfer} event.
1369      */
1370     function _transfer(
1371         address from,
1372         address to,
1373         uint256 tokenId
1374     ) private {
1375         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1376 
1377         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1378             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1379             getApproved(tokenId) == _msgSender());
1380 
1381         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1382         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1383         if (to == address(0)) revert TransferToZeroAddress();
1384 
1385         _beforeTokenTransfers(from, to, tokenId, 1);
1386 
1387         // Clear approvals from the previous owner
1388         _approve(address(0), tokenId, prevOwnership.addr);
1389 
1390         // Underflow of the sender's balance is impossible because we check for
1391         // ownership above and the recipient's balance can't realistically overflow.
1392         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1393         unchecked {
1394             _addressData[from].balance -= 1;
1395             _addressData[to].balance += 1;
1396 
1397             _ownerships[tokenId].addr = to;
1398             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1399 
1400             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1401             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1402             uint256 nextTokenId = tokenId + 1;
1403             if (_ownerships[nextTokenId].addr == address(0)) {
1404                 // This will suffice for checking _exists(nextTokenId),
1405                 // as a burned slot cannot contain the zero address.
1406                 if (nextTokenId < _currentIndex) {
1407                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1408                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1409                 }
1410             }
1411         }
1412 
1413         emit Transfer(from, to, tokenId);
1414         _afterTokenTransfers(from, to, tokenId, 1);
1415     }
1416 
1417     /**
1418      * @dev Destroys `tokenId`.
1419      * The approval is cleared when the token is burned.
1420      *
1421      * Requirements:
1422      *
1423      * - `tokenId` must exist.
1424      *
1425      * Emits a {Transfer} event.
1426      */
1427     function _burn(uint256 tokenId) internal virtual {
1428         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1429 
1430         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1431 
1432         // Clear approvals from the previous owner
1433         _approve(address(0), tokenId, prevOwnership.addr);
1434 
1435         // Underflow of the sender's balance is impossible because we check for
1436         // ownership above and the recipient's balance can't realistically overflow.
1437         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1438         unchecked {
1439             _addressData[prevOwnership.addr].balance -= 1;
1440             _addressData[prevOwnership.addr].numberBurned += 1;
1441 
1442             // Keep track of who burned the token, and the timestamp of burning.
1443             _ownerships[tokenId].addr = prevOwnership.addr;
1444             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1445             _ownerships[tokenId].burned = true;
1446 
1447             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1448             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1449             uint256 nextTokenId = tokenId + 1;
1450             if (_ownerships[nextTokenId].addr == address(0)) {
1451                 // This will suffice for checking _exists(nextTokenId),
1452                 // as a burned slot cannot contain the zero address.
1453                 if (nextTokenId < _currentIndex) {
1454                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1455                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1456                 }
1457             }
1458         }
1459 
1460         emit Transfer(prevOwnership.addr, address(0), tokenId);
1461         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1462 
1463         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1464         unchecked {
1465             _burnCounter++;
1466         }
1467     }
1468 
1469     /**
1470      * @dev Approve `to` to operate on `tokenId`
1471      *
1472      * Emits a {Approval} event.
1473      */
1474     function _approve(
1475         address to,
1476         uint256 tokenId,
1477         address owner
1478     ) private {
1479         _tokenApprovals[tokenId] = to;
1480         emit Approval(owner, to, tokenId);
1481     }
1482 
1483     /**
1484      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1485      *
1486      * @param from address representing the previous owner of the given token ID
1487      * @param to target address that will receive the tokens
1488      * @param tokenId uint256 ID of the token to be transferred
1489      * @param _data bytes optional data to send along with the call
1490      * @return bool whether the call correctly returned the expected magic value
1491      */
1492     function _checkContractOnERC721Received(
1493         address from,
1494         address to,
1495         uint256 tokenId,
1496         bytes memory _data
1497     ) private returns (bool) {
1498         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1499             return retval == IERC721Receiver(to).onERC721Received.selector;
1500         } catch (bytes memory reason) {
1501             if (reason.length == 0) {
1502                 revert TransferToNonERC721ReceiverImplementer();
1503             } else {
1504                 assembly {
1505                     revert(add(32, reason), mload(reason))
1506                 }
1507             }
1508         }
1509     }
1510 
1511     /**
1512      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1513      * And also called before burning one token.
1514      *
1515      * startTokenId - the first token id to be transferred
1516      * quantity - the amount to be transferred
1517      *
1518      * Calling conditions:
1519      *
1520      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1521      * transferred to `to`.
1522      * - When `from` is zero, `tokenId` will be minted for `to`.
1523      * - When `to` is zero, `tokenId` will be burned by `from`.
1524      * - `from` and `to` are never both zero.
1525      */
1526     function _beforeTokenTransfers(
1527         address from,
1528         address to,
1529         uint256 startTokenId,
1530         uint256 quantity
1531     ) internal virtual {}
1532 
1533     /**
1534      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1535      * minting.
1536      * And also called after one token has been burned.
1537      *
1538      * startTokenId - the first token id to be transferred
1539      * quantity - the amount to be transferred
1540      *
1541      * Calling conditions:
1542      *
1543      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1544      * transferred to `to`.
1545      * - When `from` is zero, `tokenId` has been minted for `to`.
1546      * - When `to` is zero, `tokenId` has been burned by `from`.
1547      * - `from` and `to` are never both zero.
1548      */
1549     function _afterTokenTransfers(
1550         address from,
1551         address to,
1552         uint256 startTokenId,
1553         uint256 quantity
1554     ) internal virtual {}
1555 }
1556 
1557 // File: contracts/DMMC.sol
1558 
1559 
1560 
1561 pragma solidity >=0.8.4 <0.9.0;
1562 
1563 
1564 contract Lilverse2 is ERC721A, Ownable, ReentrancyGuard {
1565   using Strings for uint256;
1566   string public baseURI;
1567   string public baseExtension = ".json";
1568 
1569   constructor() ERC721A("Lilverse NFT", "LILS") {
1570   }
1571 
1572   function airdrop(address[] memory users)public onlyOwner{
1573     for (uint256 i = 0; i < users.length; i++) {
1574         _mint(users[i], 1, "", false);
1575     }
1576   }
1577 
1578   function tokenURI(uint256 _tokenId)  public view virtual override returns (string memory){
1579     require( _exists(_tokenId),  "ERC721Metadata: URI query for nonexistent token");
1580 
1581     string memory currentBaseURI = _baseURI();
1582     return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), baseExtension) ) : "";
1583   }
1584 
1585   function _baseURI() internal view virtual override returns (string memory) {
1586     return baseURI;
1587   }
1588 
1589   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1590     baseURI = _newBaseURI;
1591   }
1592 
1593   function setBaseExtension(string memory _baseExtension) public onlyOwner {
1594     baseExtension = _baseExtension;
1595   }
1596 
1597 
1598   function withdraw() public onlyOwner nonReentrant {
1599     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1600     require(os);
1601   }
1602 
1603   function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A) returns (bool) {
1604     return super.supportsInterface(interfaceId);
1605 }
1606 
1607 }