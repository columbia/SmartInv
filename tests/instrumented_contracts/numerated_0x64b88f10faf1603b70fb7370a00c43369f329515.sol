1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
26 
27 pragma solidity ^0.8.0;
28 
29 /**
30  * @dev Contract module which provides a basic access control mechanism, where
31  * there is an account (an owner) that can be granted exclusive access to
32  * specific functions.
33  *
34  * By default, the owner account will be the one that deploys the contract. This
35  * can later be changed with {transferOwnership}.
36  *
37  * This module is used through inheritance. It will make available the modifier
38  * `onlyOwner`, which can be applied to your functions to restrict their use to
39  * the owner.
40  */
41 abstract contract Ownable is Context {
42     address private _owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev Initializes the contract setting the deployer as the initial owner.
48      */
49     constructor() {
50         _transferOwnership(_msgSender());
51     }
52 
53     /**
54      * @dev Returns the address of the current owner.
55      */
56     function owner() public view virtual returns (address) {
57         return _owner;
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         require(owner() == _msgSender(), "Ownable: caller is not the owner");
65         _;
66     }
67 
68     /**
69      * @dev Leaves the contract without owner. It will not be possible to call
70      * `onlyOwner` functions anymore. Can only be called by the current owner.
71      *
72      * NOTE: Renouncing ownership will leave the contract without an owner,
73      * thereby removing any functionality that is only available to the owner.
74      */
75     function renounceOwnership() public virtual onlyOwner {
76         _transferOwnership(address(0));
77     }
78 
79     /**
80      * @dev Transfers ownership of the contract to a new account (`newOwner`).
81      * Can only be called by the current owner.
82      */
83     function transferOwnership(address newOwner) public virtual onlyOwner {
84         require(newOwner != address(0), "Ownable: new owner is the zero address");
85         _transferOwnership(newOwner);
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Internal function without access restriction.
91      */
92     function _transferOwnership(address newOwner) internal virtual {
93         address oldOwner = _owner;
94         _owner = newOwner;
95         emit OwnershipTransferred(oldOwner, newOwner);
96     }
97 }
98 
99 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
100 
101 pragma solidity ^0.8.0;
102 
103 /**
104  * @dev Contract module that helps prevent reentrant calls to a function.
105  *
106  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
107  * available, which can be applied to functions to make sure there are no nested
108  * (reentrant) calls to them.
109  *
110  * Note that because there is a single `nonReentrant` guard, functions marked as
111  * `nonReentrant` may not call one another. This can be worked around by making
112  * those functions `private`, and then adding `external` `nonReentrant` entry
113  * points to them.
114  *
115  * TIP: If you would like to learn more about reentrancy and alternative ways
116  * to protect against it, check out our blog post
117  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
118  */
119 abstract contract ReentrancyGuard {
120     // Booleans are more expensive than uint256 or any type that takes up a full
121     // word because each write operation emits an extra SLOAD to first read the
122     // slot's contents, replace the bits taken up by the boolean, and then write
123     // back. This is the compiler's defense against contract upgrades and
124     // pointer aliasing, and it cannot be disabled.
125 
126     // The values being non-zero value makes deployment a bit more expensive,
127     // but in exchange the refund on every call to nonReentrant will be lower in
128     // amount. Since refunds are capped to a percentage of the total
129     // transaction's gas, it is best to keep them low in cases like this one, to
130     // increase the likelihood of the full refund coming into effect.
131     uint256 private constant _NOT_ENTERED = 1;
132     uint256 private constant _ENTERED = 2;
133 
134     uint256 private _status;
135 
136     constructor() {
137         _status = _NOT_ENTERED;
138     }
139 
140     /**
141      * @dev Prevents a contract from calling itself, directly or indirectly.
142      * Calling a `nonReentrant` function from another `nonReentrant`
143      * function is not supported. It is possible to prevent this from happening
144      * by making the `nonReentrant` function external, and making it call a
145      * `private` function that does the actual work.
146      */
147     modifier nonReentrant() {
148         // On the first call to nonReentrant, _notEntered will be true
149         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
150 
151         // Any calls to nonReentrant after this point will fail
152         _status = _ENTERED;
153 
154         _;
155 
156         // By storing the original value once again, a refund is triggered (see
157         // https://eips.ethereum.org/EIPS/eip-2200)
158         _status = _NOT_ENTERED;
159     }
160 }
161 
162 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
163 
164 pragma solidity ^0.8.0;
165 
166 /**
167  * @dev Interface of the ERC165 standard, as defined in the
168  * https://eips.ethereum.org/EIPS/eip-165[EIP].
169  *
170  * Implementers can declare support of contract interfaces, which can then be
171  * queried by others ({ERC165Checker}).
172  *
173  * For an implementation, see {ERC165}.
174  */
175 interface IERC165 {
176     /**
177      * @dev Returns true if this contract implements the interface defined by
178      * `interfaceId`. See the corresponding
179      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
180      * to learn more about how these ids are created.
181      *
182      * This function call must use less than 30 000 gas.
183      */
184     function supportsInterface(bytes4 interfaceId) external view returns (bool);
185 }
186 
187 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
188 
189 pragma solidity ^0.8.0;
190 
191 /**
192  * @dev Implementation of the {IERC165} interface.
193  *
194  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
195  * for the additional interface id that will be supported. For example:
196  *
197  * ```solidity
198  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
199  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
200  * }
201  * ```
202  *
203  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
204  */
205 abstract contract ERC165 is IERC165 {
206     /**
207      * @dev See {IERC165-supportsInterface}.
208      */
209     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
210         return interfaceId == type(IERC165).interfaceId;
211     }
212 }
213 
214 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
215 
216 pragma solidity ^0.8.0;
217 
218 
219 /**
220  * @dev Required interface of an ERC721 compliant contract.
221  */
222 interface IERC721 is IERC165 {
223     /**
224      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
225      */
226     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
227 
228     /**
229      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
230      */
231     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
232 
233     /**
234      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
235      */
236     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
237 
238     /**
239      * @dev Returns the number of tokens in ``owner``'s account.
240      */
241     function balanceOf(address owner) external view returns (uint256 balance);
242 
243     /**
244      * @dev Returns the owner of the `tokenId` token.
245      *
246      * Requirements:
247      *
248      * - `tokenId` must exist.
249      */
250     function ownerOf(uint256 tokenId) external view returns (address owner);
251 
252     /**
253      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
254      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
255      *
256      * Requirements:
257      *
258      * - `from` cannot be the zero address.
259      * - `to` cannot be the zero address.
260      * - `tokenId` token must exist and be owned by `from`.
261      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
262      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
263      *
264      * Emits a {Transfer} event.
265      */
266     function safeTransferFrom(
267         address from,
268         address to,
269         uint256 tokenId
270     ) external;
271 
272     /**
273      * @dev Transfers `tokenId` token from `from` to `to`.
274      *
275      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
276      *
277      * Requirements:
278      *
279      * - `from` cannot be the zero address.
280      * - `to` cannot be the zero address.
281      * - `tokenId` token must be owned by `from`.
282      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
283      *
284      * Emits a {Transfer} event.
285      */
286     function transferFrom(
287         address from,
288         address to,
289         uint256 tokenId
290     ) external;
291 
292     /**
293      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
294      * The approval is cleared when the token is transferred.
295      *
296      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
297      *
298      * Requirements:
299      *
300      * - The caller must own the token or be an approved operator.
301      * - `tokenId` must exist.
302      *
303      * Emits an {Approval} event.
304      */
305     function approve(address to, uint256 tokenId) external;
306 
307     /**
308      * @dev Returns the account approved for `tokenId` token.
309      *
310      * Requirements:
311      *
312      * - `tokenId` must exist.
313      */
314     function getApproved(uint256 tokenId) external view returns (address operator);
315 
316     /**
317      * @dev Approve or remove `operator` as an operator for the caller.
318      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
319      *
320      * Requirements:
321      *
322      * - The `operator` cannot be the caller.
323      *
324      * Emits an {ApprovalForAll} event.
325      */
326     function setApprovalForAll(address operator, bool _approved) external;
327 
328     /**
329      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
330      *
331      * See {setApprovalForAll}
332      */
333     function isApprovedForAll(address owner, address operator) external view returns (bool);
334 
335     /**
336      * @dev Safely transfers `tokenId` token from `from` to `to`.
337      *
338      * Requirements:
339      *
340      * - `from` cannot be the zero address.
341      * - `to` cannot be the zero address.
342      * - `tokenId` token must exist and be owned by `from`.
343      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
344      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
345      *
346      * Emits a {Transfer} event.
347      */
348     function safeTransferFrom(
349         address from,
350         address to,
351         uint256 tokenId,
352         bytes calldata data
353     ) external;
354 }
355 
356 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
357 
358 pragma solidity ^0.8.0;
359 
360 /**
361  * @title ERC721 token receiver interface
362  * @dev Interface for any contract that wants to support safeTransfers
363  * from ERC721 asset contracts.
364  */
365 interface IERC721Receiver {
366     /**
367      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
368      * by `operator` from `from`, this function is called.
369      *
370      * It must return its Solidity selector to confirm the token transfer.
371      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
372      *
373      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
374      */
375     function onERC721Received(
376         address operator,
377         address from,
378         uint256 tokenId,
379         bytes calldata data
380     ) external returns (bytes4);
381 }
382 
383 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
384 
385 pragma solidity ^0.8.0;
386 
387 
388 /**
389  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
390  * @dev See https://eips.ethereum.org/EIPS/eip-721
391  */
392 interface IERC721Enumerable is IERC721 {
393     /**
394      * @dev Returns the total amount of tokens stored by the contract.
395      */
396     function totalSupply() external view returns (uint256);
397 
398     /**
399      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
400      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
401      */
402     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
403 
404     /**
405      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
406      * Use along with {totalSupply} to enumerate all tokens.
407      */
408     function tokenByIndex(uint256 index) external view returns (uint256);
409 }
410 
411 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
412 
413 pragma solidity ^0.8.0;
414 
415 /**
416  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
417  * @dev See https://eips.ethereum.org/EIPS/eip-721
418  */
419 interface IERC721Metadata is IERC721 {
420     /**
421      * @dev Returns the token collection name.
422      */
423     function name() external view returns (string memory);
424 
425     /**
426      * @dev Returns the token collection symbol.
427      */
428     function symbol() external view returns (string memory);
429 
430     /**
431      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
432      */
433     function tokenURI(uint256 tokenId) external view returns (string memory);
434 }
435 
436 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
437 
438 pragma solidity ^0.8.0;
439 
440 /**
441  * @dev Collection of functions related to the address type
442  */
443 library Address {
444     /**
445      * @dev Returns true if `account` is a contract.
446      *
447      * [IMPORTANT]
448      * ====
449      * It is unsafe to assume that an address for which this function returns
450      * false is an externally-owned account (EOA) and not a contract.
451      *
452      * Among others, `isContract` will return false for the following
453      * types of addresses:
454      *
455      *  - an externally-owned account
456      *  - a contract in construction
457      *  - an address where a contract will be created
458      *  - an address where a contract lived, but was destroyed
459      * ====
460      */
461     function isContract(address account) internal view returns (bool) {
462         // This method relies on extcodesize, which returns 0 for contracts in
463         // construction, since the code is only stored at the end of the
464         // constructor execution.
465 
466         uint256 size;
467         assembly {
468             size := extcodesize(account)
469         }
470         return size > 0;
471     }
472 
473     /**
474      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
475      * `recipient`, forwarding all available gas and reverting on errors.
476      *
477      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
478      * of certain opcodes, possibly making contracts go over the 2300 gas limit
479      * imposed by `transfer`, making them unable to receive funds via
480      * `transfer`. {sendValue} removes this limitation.
481      *
482      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
483      *
484      * IMPORTANT: because control is transferred to `recipient`, care must be
485      * taken to not create reentrancy vulnerabilities. Consider using
486      * {ReentrancyGuard} or the
487      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
488      */
489     function sendValue(address payable recipient, uint256 amount) internal {
490         require(address(this).balance >= amount, "Address: insufficient balance");
491 
492         (bool success, ) = recipient.call{value: amount}("");
493         require(success, "Address: unable to send value, recipient may have reverted");
494     }
495 
496     /**
497      * @dev Performs a Solidity function call using a low level `call`. A
498      * plain `call` is an unsafe replacement for a function call: use this
499      * function instead.
500      *
501      * If `target` reverts with a revert reason, it is bubbled up by this
502      * function (like regular Solidity function calls).
503      *
504      * Returns the raw returned data. To convert to the expected return value,
505      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
506      *
507      * Requirements:
508      *
509      * - `target` must be a contract.
510      * - calling `target` with `data` must not revert.
511      *
512      * _Available since v3.1._
513      */
514     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
515         return functionCall(target, data, "Address: low-level call failed");
516     }
517 
518     /**
519      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
520      * `errorMessage` as a fallback revert reason when `target` reverts.
521      *
522      * _Available since v3.1._
523      */
524     function functionCall(
525         address target,
526         bytes memory data,
527         string memory errorMessage
528     ) internal returns (bytes memory) {
529         return functionCallWithValue(target, data, 0, errorMessage);
530     }
531 
532     /**
533      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
534      * but also transferring `value` wei to `target`.
535      *
536      * Requirements:
537      *
538      * - the calling contract must have an ETH balance of at least `value`.
539      * - the called Solidity function must be `payable`.
540      *
541      * _Available since v3.1._
542      */
543     function functionCallWithValue(
544         address target,
545         bytes memory data,
546         uint256 value
547     ) internal returns (bytes memory) {
548         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
549     }
550 
551     /**
552      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
553      * with `errorMessage` as a fallback revert reason when `target` reverts.
554      *
555      * _Available since v3.1._
556      */
557     function functionCallWithValue(
558         address target,
559         bytes memory data,
560         uint256 value,
561         string memory errorMessage
562     ) internal returns (bytes memory) {
563         require(address(this).balance >= value, "Address: insufficient balance for call");
564         require(isContract(target), "Address: call to non-contract");
565 
566         (bool success, bytes memory returndata) = target.call{value: value}(data);
567         return verifyCallResult(success, returndata, errorMessage);
568     }
569 
570     /**
571      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
572      * but performing a static call.
573      *
574      * _Available since v3.3._
575      */
576     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
577         return functionStaticCall(target, data, "Address: low-level static call failed");
578     }
579 
580     /**
581      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
582      * but performing a static call.
583      *
584      * _Available since v3.3._
585      */
586     function functionStaticCall(
587         address target,
588         bytes memory data,
589         string memory errorMessage
590     ) internal view returns (bytes memory) {
591         require(isContract(target), "Address: static call to non-contract");
592 
593         (bool success, bytes memory returndata) = target.staticcall(data);
594         return verifyCallResult(success, returndata, errorMessage);
595     }
596 
597     /**
598      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
599      * but performing a delegate call.
600      *
601      * _Available since v3.4._
602      */
603     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
604         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
605     }
606 
607     /**
608      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
609      * but performing a delegate call.
610      *
611      * _Available since v3.4._
612      */
613     function functionDelegateCall(
614         address target,
615         bytes memory data,
616         string memory errorMessage
617     ) internal returns (bytes memory) {
618         require(isContract(target), "Address: delegate call to non-contract");
619 
620         (bool success, bytes memory returndata) = target.delegatecall(data);
621         return verifyCallResult(success, returndata, errorMessage);
622     }
623 
624     /**
625      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
626      * revert reason using the provided one.
627      *
628      * _Available since v4.3._
629      */
630     function verifyCallResult(
631         bool success,
632         bytes memory returndata,
633         string memory errorMessage
634     ) internal pure returns (bytes memory) {
635         if (success) {
636             return returndata;
637         } else {
638             // Look for revert reason and bubble it up if present
639             if (returndata.length > 0) {
640                 // The easiest way to bubble the revert reason is using memory via assembly
641 
642                 assembly {
643                     let returndata_size := mload(returndata)
644                     revert(add(32, returndata), returndata_size)
645                 }
646             } else {
647                 revert(errorMessage);
648             }
649         }
650     }
651 }
652 
653 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
654 
655 pragma solidity ^0.8.0;
656 
657 /**
658  * @dev String operations.
659  */
660 library Strings {
661     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
662 
663     /**
664      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
665      */
666     function toString(uint256 value) internal pure returns (string memory) {
667         // Inspired by OraclizeAPI's implementation - MIT licence
668         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
669 
670         if (value == 0) {
671             return "0";
672         }
673         uint256 temp = value;
674         uint256 digits;
675         while (temp != 0) {
676             digits++;
677             temp /= 10;
678         }
679         bytes memory buffer = new bytes(digits);
680         while (value != 0) {
681             digits -= 1;
682             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
683             value /= 10;
684         }
685         return string(buffer);
686     }
687 
688     /**
689      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
690      */
691     function toHexString(uint256 value) internal pure returns (string memory) {
692         if (value == 0) {
693             return "0x00";
694         }
695         uint256 temp = value;
696         uint256 length = 0;
697         while (temp != 0) {
698             length++;
699             temp >>= 8;
700         }
701         return toHexString(value, length);
702     }
703 
704     /**
705      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
706      */
707     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
708         bytes memory buffer = new bytes(2 * length + 2);
709         buffer[0] = "0";
710         buffer[1] = "x";
711         for (uint256 i = 2 * length + 1; i > 1; --i) {
712             buffer[i] = _HEX_SYMBOLS[value & 0xf];
713             value >>= 4;
714         }
715         require(value == 0, "Strings: hex length insufficient");
716         return string(buffer);
717     }
718 }
719 
720 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
721 
722 pragma solidity ^0.8.0;
723 
724 
725 /**
726  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
727  *
728  * These functions can be used to verify that a message was signed by the holder
729  * of the private keys of a given address.
730  */
731 library ECDSA {
732     enum RecoverError {
733         NoError,
734         InvalidSignature,
735         InvalidSignatureLength,
736         InvalidSignatureS,
737         InvalidSignatureV
738     }
739 
740     function _throwError(RecoverError error) private pure {
741         if (error == RecoverError.NoError) {
742             return; // no error: do nothing
743         } else if (error == RecoverError.InvalidSignature) {
744             revert("ECDSA: invalid signature");
745         } else if (error == RecoverError.InvalidSignatureLength) {
746             revert("ECDSA: invalid signature length");
747         } else if (error == RecoverError.InvalidSignatureS) {
748             revert("ECDSA: invalid signature 's' value");
749         } else if (error == RecoverError.InvalidSignatureV) {
750             revert("ECDSA: invalid signature 'v' value");
751         }
752     }
753 
754     /**
755      * @dev Returns the address that signed a hashed message (`hash`) with
756      * `signature` or error string. This address can then be used for verification purposes.
757      *
758      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
759      * this function rejects them by requiring the `s` value to be in the lower
760      * half order, and the `v` value to be either 27 or 28.
761      *
762      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
763      * verification to be secure: it is possible to craft signatures that
764      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
765      * this is by receiving a hash of the original message (which may otherwise
766      * be too long), and then calling {toEthSignedMessageHash} on it.
767      *
768      * Documentation for signature generation:
769      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
770      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
771      *
772      * _Available since v4.3._
773      */
774     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
775         // Check the signature length
776         // - case 65: r,s,v signature (standard)
777         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
778         if (signature.length == 65) {
779             bytes32 r;
780             bytes32 s;
781             uint8 v;
782             // ecrecover takes the signature parameters, and the only way to get them
783             // currently is to use assembly.
784             assembly {
785                 r := mload(add(signature, 0x20))
786                 s := mload(add(signature, 0x40))
787                 v := byte(0, mload(add(signature, 0x60)))
788             }
789             return tryRecover(hash, v, r, s);
790         } else if (signature.length == 64) {
791             bytes32 r;
792             bytes32 vs;
793             // ecrecover takes the signature parameters, and the only way to get them
794             // currently is to use assembly.
795             assembly {
796                 r := mload(add(signature, 0x20))
797                 vs := mload(add(signature, 0x40))
798             }
799             return tryRecover(hash, r, vs);
800         } else {
801             return (address(0), RecoverError.InvalidSignatureLength);
802         }
803     }
804 
805     /**
806      * @dev Returns the address that signed a hashed message (`hash`) with
807      * `signature`. This address can then be used for verification purposes.
808      *
809      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
810      * this function rejects them by requiring the `s` value to be in the lower
811      * half order, and the `v` value to be either 27 or 28.
812      *
813      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
814      * verification to be secure: it is possible to craft signatures that
815      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
816      * this is by receiving a hash of the original message (which may otherwise
817      * be too long), and then calling {toEthSignedMessageHash} on it.
818      */
819     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
820         (address recovered, RecoverError error) = tryRecover(hash, signature);
821         _throwError(error);
822         return recovered;
823     }
824 
825     /**
826      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
827      *
828      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
829      *
830      * _Available since v4.3._
831      */
832     function tryRecover(
833         bytes32 hash,
834         bytes32 r,
835         bytes32 vs
836     ) internal pure returns (address, RecoverError) {
837         bytes32 s;
838         uint8 v;
839         assembly {
840             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
841             v := add(shr(255, vs), 27)
842         }
843         return tryRecover(hash, v, r, s);
844     }
845 
846     /**
847      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
848      *
849      * _Available since v4.2._
850      */
851     function recover(
852         bytes32 hash,
853         bytes32 r,
854         bytes32 vs
855     ) internal pure returns (address) {
856         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
857         _throwError(error);
858         return recovered;
859     }
860 
861     /**
862      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
863      * `r` and `s` signature fields separately.
864      *
865      * _Available since v4.3._
866      */
867     function tryRecover(
868         bytes32 hash,
869         uint8 v,
870         bytes32 r,
871         bytes32 s
872     ) internal pure returns (address, RecoverError) {
873         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
874         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
875         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
876         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
877         //
878         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
879         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
880         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
881         // these malleable signatures as well.
882         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
883             return (address(0), RecoverError.InvalidSignatureS);
884         }
885         if (v != 27 && v != 28) {
886             return (address(0), RecoverError.InvalidSignatureV);
887         }
888 
889         // If the signature is valid (and not malleable), return the signer address
890         address signer = ecrecover(hash, v, r, s);
891         if (signer == address(0)) {
892             return (address(0), RecoverError.InvalidSignature);
893         }
894 
895         return (signer, RecoverError.NoError);
896     }
897 
898     /**
899      * @dev Overload of {ECDSA-recover} that receives the `v`,
900      * `r` and `s` signature fields separately.
901      */
902     function recover(
903         bytes32 hash,
904         uint8 v,
905         bytes32 r,
906         bytes32 s
907     ) internal pure returns (address) {
908         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
909         _throwError(error);
910         return recovered;
911     }
912 
913     /**
914      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
915      * produces hash corresponding to the one signed with the
916      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
917      * JSON-RPC method as part of EIP-191.
918      *
919      * See {recover}.
920      */
921     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
922         // 32 is the length in bytes of hash,
923         // enforced by the type signature above
924         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
925     }
926 
927     /**
928      * @dev Returns an Ethereum Signed Message, created from `s`. This
929      * produces hash corresponding to the one signed with the
930      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
931      * JSON-RPC method as part of EIP-191.
932      *
933      * See {recover}.
934      */
935     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
936         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
937     }
938 
939     /**
940      * @dev Returns an Ethereum Signed Typed Data, created from a
941      * `domainSeparator` and a `structHash`. This produces hash corresponding
942      * to the one signed with the
943      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
944      * JSON-RPC method as part of EIP-712.
945      *
946      * See {recover}.
947      */
948     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
949         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
950     }
951 }
952 
953 
954 pragma solidity ^0.8.0;
955 
956 /**
957  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
958  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
959  *
960  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
961  *
962  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
963  *
964  * Does not support burning tokens to address(0).
965  */
966 contract ERC721A is
967     Context,
968     ERC165,
969     IERC721,
970     IERC721Metadata,
971     IERC721Enumerable
972 {
973     using Address for address;
974     using Strings for uint256;
975 
976     struct TokenOwnership {
977         address addr;
978         uint64 startTimestamp;
979     }
980 
981     struct AddressData {
982         uint128 balance;
983         uint128 numberMinted;
984     }
985 
986     uint256 private currentIndex = 0;
987 
988     uint256 internal immutable collectionSize;
989     uint256 internal immutable maxBatchSize;
990 
991     // Token name
992     string private _name;
993 
994     // Token symbol
995     string private _symbol;
996 
997     // Mapping from token ID to ownership details
998     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
999     mapping(uint256 => TokenOwnership) private _ownerships;
1000 
1001     // Mapping owner address to address data
1002     mapping(address => AddressData) private _addressData;
1003 
1004     // Mapping from token ID to approved address
1005     mapping(uint256 => address) private _tokenApprovals;
1006 
1007     // Mapping from owner to operator approvals
1008     mapping(address => mapping(address => bool)) private _operatorApprovals;
1009 
1010     /**
1011      * @dev
1012      * `maxBatchSize` refers to how much a minter can mint at a time.
1013      * `collectionSize_` refers to how many tokens are in the collection.
1014      */
1015     constructor(
1016         string memory name_,
1017         string memory symbol_,
1018         uint256 maxBatchSize_,
1019         uint256 collectionSize_
1020     ) {
1021         require(
1022             collectionSize_ > 0,
1023             "ERC721A: collection must have a nonzero supply"
1024         );
1025         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1026         _name = name_;
1027         _symbol = symbol_;
1028         maxBatchSize = maxBatchSize_;
1029         collectionSize = collectionSize_;
1030     }
1031 
1032     /**
1033      * @dev See {IERC721Enumerable-totalSupply}.
1034      */
1035     function totalSupply() public view override returns (uint256) {
1036         return currentIndex;
1037     }
1038 
1039     /**
1040      * @dev See {IERC721Enumerable-tokenByIndex}.
1041      */
1042     function tokenByIndex(uint256 index)
1043         public
1044         view
1045         override
1046         returns (uint256)
1047     {
1048         require(index < totalSupply(), "ERC721A: global index out of bounds");
1049         return index;
1050     }
1051 
1052     /**
1053      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1054      * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1055      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1056      */
1057     function tokenOfOwnerByIndex(address owner, uint256 index)
1058         public
1059         view
1060         override
1061         returns (uint256)
1062     {
1063         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1064         uint256 numMintedSoFar = totalSupply();
1065         uint256 tokenIdsIdx = 0;
1066         address currOwnershipAddr = address(0);
1067         for (uint256 i = 0; i < numMintedSoFar; i++) {
1068             TokenOwnership memory ownership = _ownerships[i];
1069             if (ownership.addr != address(0)) {
1070                 currOwnershipAddr = ownership.addr;
1071             }
1072             if (currOwnershipAddr == owner) {
1073                 if (tokenIdsIdx == index) {
1074                     return i;
1075                 }
1076                 tokenIdsIdx++;
1077             }
1078         }
1079         revert("ERC721A: unable to get token of owner by index");
1080     }
1081 
1082     /**
1083      * @dev See {IERC165-supportsInterface}.
1084      */
1085     function supportsInterface(bytes4 interfaceId)
1086         public
1087         view
1088         virtual
1089         override(ERC165, IERC165)
1090         returns (bool)
1091     {
1092         return
1093             interfaceId == type(IERC721).interfaceId ||
1094             interfaceId == type(IERC721Metadata).interfaceId ||
1095             interfaceId == type(IERC721Enumerable).interfaceId ||
1096             super.supportsInterface(interfaceId);
1097     }
1098 
1099     /**
1100      * @dev See {IERC721-balanceOf}.
1101      */
1102     function balanceOf(address owner) public view override returns (uint256) {
1103         require(
1104             owner != address(0),
1105             "ERC721A: balance query for the zero address"
1106         );
1107         return uint256(_addressData[owner].balance);
1108     }
1109 
1110     function _numberMinted(address owner) internal view returns (uint256) {
1111         require(
1112             owner != address(0),
1113             "ERC721A: number minted query for the zero address"
1114         );
1115         return uint256(_addressData[owner].numberMinted);
1116     }
1117 
1118     function ownershipOf(uint256 tokenId)
1119         internal
1120         view
1121         returns (TokenOwnership memory)
1122     {
1123         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1124 
1125         uint256 lowestTokenToCheck;
1126         if (tokenId >= maxBatchSize) {
1127             lowestTokenToCheck = tokenId - maxBatchSize + 1;
1128         }
1129 
1130         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1131             TokenOwnership memory ownership = _ownerships[curr];
1132             if (ownership.addr != address(0)) {
1133                 return ownership;
1134             }
1135         }
1136 
1137         revert("ERC721A: unable to determine the owner of token");
1138     }
1139 
1140     /**
1141      * @dev See {IERC721-ownerOf}.
1142      */
1143     function ownerOf(uint256 tokenId) public view override returns (address) {
1144         return ownershipOf(tokenId).addr;
1145     }
1146 
1147     /**
1148      * @dev See {IERC721Metadata-name}.
1149      */
1150     function name() public view virtual override returns (string memory) {
1151         return _name;
1152     }
1153 
1154     /**
1155      * @dev See {IERC721Metadata-symbol}.
1156      */
1157     function symbol() public view virtual override returns (string memory) {
1158         return _symbol;
1159     }
1160 
1161     /**
1162      * @dev See {IERC721Metadata-tokenURI}.
1163      */
1164     function tokenURI(uint256 tokenId)
1165         public
1166         view
1167         virtual
1168         override
1169         returns (string memory)
1170     {
1171         require(
1172             _exists(tokenId),
1173             "ERC721Metadata: URI query for nonexistent token"
1174         );
1175 
1176         string memory baseURI = _baseURI();
1177         return
1178             bytes(baseURI).length > 0
1179                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1180                 : "";
1181     }
1182 
1183     /**
1184      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1185      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1186      * by default, can be overriden in child contracts.
1187      */
1188     function _baseURI() internal view virtual returns (string memory) {
1189         return "";
1190     }
1191 
1192     /**
1193      * @dev See {IERC721-approve}.
1194      */
1195     function approve(address to, uint256 tokenId) public override {
1196         address owner = ERC721A.ownerOf(tokenId);
1197         require(to != owner, "ERC721A: approval to current owner");
1198 
1199         require(
1200             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1201             "ERC721A: approve caller is not owner nor approved for all"
1202         );
1203 
1204         _approve(to, tokenId, owner);
1205     }
1206 
1207     /**
1208      * @dev See {IERC721-getApproved}.
1209      */
1210     function getApproved(uint256 tokenId)
1211         public
1212         view
1213         override
1214         returns (address)
1215     {
1216         require(
1217             _exists(tokenId),
1218             "ERC721A: approved query for nonexistent token"
1219         );
1220 
1221         return _tokenApprovals[tokenId];
1222     }
1223 
1224     /**
1225      * @dev See {IERC721-setApprovalForAll}.
1226      */
1227     function setApprovalForAll(address operator, bool approved)
1228         public
1229         override
1230     {
1231         require(operator != _msgSender(), "ERC721A: approve to caller");
1232 
1233         _operatorApprovals[_msgSender()][operator] = approved;
1234         emit ApprovalForAll(_msgSender(), operator, approved);
1235     }
1236 
1237     /**
1238      * @dev See {IERC721-isApprovedForAll}.
1239      */
1240     function isApprovedForAll(address owner, address operator)
1241         public
1242         view
1243         virtual
1244         override
1245         returns (bool)
1246     {
1247         return _operatorApprovals[owner][operator];
1248     }
1249 
1250     /**
1251      * @dev See {IERC721-transferFrom}.
1252      */
1253     function transferFrom(
1254         address from,
1255         address to,
1256         uint256 tokenId
1257     ) public override {
1258         _transfer(from, to, tokenId);
1259     }
1260 
1261     /**
1262      * @dev See {IERC721-safeTransferFrom}.
1263      */
1264     function safeTransferFrom(
1265         address from,
1266         address to,
1267         uint256 tokenId
1268     ) public override {
1269         safeTransferFrom(from, to, tokenId, "");
1270     }
1271 
1272     /**
1273      * @dev See {IERC721-safeTransferFrom}.
1274      */
1275     function safeTransferFrom(
1276         address from,
1277         address to,
1278         uint256 tokenId,
1279         bytes memory _data
1280     ) public override {
1281         _transfer(from, to, tokenId);
1282         require(
1283             _checkOnERC721Received(from, to, tokenId, _data),
1284             "ERC721A: transfer to non ERC721Receiver implementer"
1285         );
1286     }
1287 
1288     /**
1289      * @dev Returns whether `tokenId` exists.
1290      *
1291      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1292      *
1293      * Tokens start existing when they are minted (`_mint`),
1294      */
1295     function _exists(uint256 tokenId) internal view returns (bool) {
1296         return tokenId < currentIndex;
1297     }
1298 
1299     function _safeMint(address to, uint256 quantity) internal {
1300         _safeMint(to, quantity, "");
1301     }
1302 
1303     /**
1304      * @dev Mints `quantity` tokens and transfers them to `to`.
1305      *
1306      * Requirements:
1307      *
1308      * - there must be `quantity` tokens remaining unminted in the total collection.
1309      * - `to` cannot be the zero address.
1310      * - `quantity` cannot be larger than the max batch size.
1311      *
1312      * Emits a {Transfer} event.
1313      */
1314     function _safeMint(
1315         address to,
1316         uint256 quantity,
1317         bytes memory _data
1318     ) internal {
1319         uint256 startTokenId = currentIndex;
1320         require(to != address(0), "ERC721A: mint to the zero address");
1321         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1322         require(!_exists(startTokenId), "ERC721A: token already minted");
1323         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1324 
1325         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1326 
1327         AddressData memory addressData = _addressData[to];
1328         _addressData[to] = AddressData(
1329             addressData.balance + uint128(quantity),
1330             addressData.numberMinted + uint128(quantity)
1331         );
1332         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1333 
1334         uint256 updatedIndex = startTokenId;
1335 
1336         for (uint256 i = 0; i < quantity; i++) {
1337             emit Transfer(address(0), to, updatedIndex);
1338             require(
1339                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1340                 "ERC721A: transfer to non ERC721Receiver implementer"
1341             );
1342             updatedIndex++;
1343         }
1344 
1345         currentIndex = updatedIndex;
1346         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1347     }
1348 
1349     /**
1350      * @dev Transfers `tokenId` from `from` to `to`.
1351      *
1352      * Requirements:
1353      *
1354      * - `to` cannot be the zero address.
1355      * - `tokenId` token must be owned by `from`.
1356      *
1357      * Emits a {Transfer} event.
1358      */
1359     function _transfer(
1360         address from,
1361         address to,
1362         uint256 tokenId
1363     ) private {
1364         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1365 
1366         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1367             getApproved(tokenId) == _msgSender() ||
1368             isApprovedForAll(prevOwnership.addr, _msgSender()));
1369 
1370         require(
1371             isApprovedOrOwner,
1372             "ERC721A: transfer caller is not owner nor approved"
1373         );
1374 
1375         require(
1376             prevOwnership.addr == from,
1377             "ERC721A: transfer from incorrect owner"
1378         );
1379         require(to != address(0), "ERC721A: transfer to the zero address");
1380 
1381         _beforeTokenTransfers(from, to, tokenId, 1);
1382 
1383         // Clear approvals from the previous owner
1384         _approve(address(0), tokenId, prevOwnership.addr);
1385 
1386         _addressData[from].balance -= 1;
1387         _addressData[to].balance += 1;
1388         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1389 
1390         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1391         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1392         uint256 nextTokenId = tokenId + 1;
1393         if (_ownerships[nextTokenId].addr == address(0)) {
1394             if (_exists(nextTokenId)) {
1395                 _ownerships[nextTokenId] = TokenOwnership(
1396                     prevOwnership.addr,
1397                     prevOwnership.startTimestamp
1398                 );
1399             }
1400         }
1401 
1402         emit Transfer(from, to, tokenId);
1403         _afterTokenTransfers(from, to, tokenId, 1);
1404     }
1405 
1406     /**
1407      * @dev Approve `to` to operate on `tokenId`
1408      *
1409      * Emits a {Approval} event.
1410      */
1411     function _approve(
1412         address to,
1413         uint256 tokenId,
1414         address owner
1415     ) private {
1416         _tokenApprovals[tokenId] = to;
1417         emit Approval(owner, to, tokenId);
1418     }
1419 
1420     uint256 public nextOwnerToExplicitlySet = 0;
1421 
1422     /**
1423      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1424      */
1425     function _setOwnersExplicit(uint256 quantity) internal {
1426         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1427         require(quantity > 0, "quantity must be nonzero");
1428         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1429         if (endIndex > collectionSize - 1) {
1430             endIndex = collectionSize - 1;
1431         }
1432         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1433         require(_exists(endIndex), "not enough minted yet for this cleanup");
1434         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1435             if (_ownerships[i].addr == address(0)) {
1436                 TokenOwnership memory ownership = ownershipOf(i);
1437                 _ownerships[i] = TokenOwnership(
1438                     ownership.addr,
1439                     ownership.startTimestamp
1440                 );
1441             }
1442         }
1443         nextOwnerToExplicitlySet = endIndex + 1;
1444     }
1445 
1446     /**
1447      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1448      * The call is not executed if the target address is not a contract.
1449      *
1450      * @param from address representing the previous owner of the given token ID
1451      * @param to target address that will receive the tokens
1452      * @param tokenId uint256 ID of the token to be transferred
1453      * @param _data bytes optional data to send along with the call
1454      * @return bool whether the call correctly returned the expected magic value
1455      */
1456     function _checkOnERC721Received(
1457         address from,
1458         address to,
1459         uint256 tokenId,
1460         bytes memory _data
1461     ) private returns (bool) {
1462         if (to.isContract()) {
1463             try
1464                 IERC721Receiver(to).onERC721Received(
1465                     _msgSender(),
1466                     from,
1467                     tokenId,
1468                     _data
1469                 )
1470             returns (bytes4 retval) {
1471                 return retval == IERC721Receiver(to).onERC721Received.selector;
1472             } catch (bytes memory reason) {
1473                 if (reason.length == 0) {
1474                     revert(
1475                         "ERC721A: transfer to non ERC721Receiver implementer"
1476                     );
1477                 } else {
1478                     assembly {
1479                         revert(add(32, reason), mload(reason))
1480                     }
1481                 }
1482             }
1483         } else {
1484             return true;
1485         }
1486     }
1487 
1488     /**
1489      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1490      *
1491      * startTokenId - the first token id to be transferred
1492      * quantity - the amount to be transferred
1493      *
1494      * Calling conditions:
1495      *
1496      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1497      * transferred to `to`.
1498      * - When `from` is zero, `tokenId` will be minted for `to`.
1499      */
1500     function _beforeTokenTransfers(
1501         address from,
1502         address to,
1503         uint256 startTokenId,
1504         uint256 quantity
1505     ) internal virtual {}
1506 
1507     /**
1508      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1509      * minting.
1510      *
1511      * startTokenId - the first token id to be transferred
1512      * quantity - the amount to be transferred
1513      *
1514      * Calling conditions:
1515      *
1516      * - when `from` and `to` are both non-zero.
1517      * - `from` and `to` are never both zero.
1518      */
1519     function _afterTokenTransfers(
1520         address from,
1521         address to,
1522         uint256 startTokenId,
1523         uint256 quantity
1524     ) internal virtual {}
1525 }
1526 
1527 
1528 pragma solidity ^0.8.7;
1529 
1530 contract Puggy is ERC721A, Ownable, ReentrancyGuard {
1531     using ECDSA for bytes32;
1532 
1533     string public baseURI;
1534     address private _signer;
1535     
1536     uint256 public immutable maxMintPerWallet;
1537     uint256 public immutable maxSupply;
1538     uint256 public PRICE = 0.03 * 1000000000000000000;
1539     bool public mintPaused = true;
1540     bool public publicMintPaused = true;
1541     mapping(address => uint256) private mintLists; 
1542     event Minted(address minter, uint256 amount);
1543 
1544     constructor(
1545         string memory initBaseURI,
1546         address signer,
1547         uint256 _maxBatchSize,
1548         uint256 _collectionSize
1549     ) ERC721A("Puggy Squad", "Puggy", _maxBatchSize, _collectionSize) {
1550         baseURI = initBaseURI;
1551         _signer = signer;
1552         maxMintPerWallet = _maxBatchSize;
1553         maxSupply = _collectionSize;
1554     }
1555 
1556     function _hash(string calldata salt, address _address)
1557         internal
1558         view
1559         returns (bytes32)
1560     {
1561         return keccak256(abi.encode(salt, address(this), _address));
1562     }
1563 
1564     function _verify(bytes32 hash, bytes memory token)
1565         internal
1566         view
1567         returns (bool)
1568     {
1569         return (_recover(hash, token) == _signer);
1570     }
1571 
1572     function _recover(bytes32 hash, bytes memory token)
1573         internal
1574         pure
1575         returns (address)
1576     {
1577         return hash.toEthSignedMessageHash().recover(token);
1578     }
1579 
1580     function _baseURI() internal view override returns (string memory) {
1581         return baseURI;
1582     }
1583 
1584     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1585         return string(abi.encodePacked(_baseURI(), Strings.toString(_tokenId), ".json"));
1586     }
1587 
1588 
1589     function preMint(
1590         uint256 amount,
1591         string calldata salt,
1592         bytes calldata token
1593     ) external payable {
1594         require(!mintPaused, "Puggy: preMint Paused");
1595         require(tx.origin == msg.sender, "Puggy: contract is not allowed to mint.");
1596         require(_verify(_hash(salt, msg.sender), token), "Puggy: Invalid token.");
1597         require(mintLists[msg.sender] + amount <= maxMintPerWallet, "Puggy: The wallet has already minted during preslae sale."); 
1598         require(totalSupply() + amount <= maxSupply, "Puggy: Max supply exceeded.");
1599         _safeMint(msg.sender, amount);
1600         mintLists[msg.sender] += amount;
1601         emit Minted(msg.sender, amount);
1602     }
1603 
1604     function publicMint(
1605         uint256 amount
1606     ) external payable {
1607         require(!publicMintPaused, "Puggy: publicMint Paused");
1608         require(tx.origin == msg.sender, "Puggy: contract is not allowed to mint.");
1609         require(mintLists[msg.sender] + amount <= maxMintPerWallet, "Puggy: The wallet has already minted."); 
1610         require(totalSupply() + amount <= maxSupply, "Puggy: Max supply exceeded.");
1611         _safeMint(msg.sender, amount);
1612         refundIfOver(PRICE * amount);
1613         mintLists[msg.sender] += amount;
1614         emit Minted(msg.sender, amount);
1615     }
1616     
1617     function refundIfOver(uint256 price) private {
1618         require(msg.value >= price, "Puggy: Need to send more ETH.");
1619         if (msg.value > price) {
1620             payable(msg.sender).transfer(msg.value - price);
1621         }
1622     }
1623 
1624     
1625 
1626     function setOwnersExplicit(uint256 quantity)
1627         external
1628         onlyOwner
1629         nonReentrant
1630     {
1631         _setOwnersExplicit(quantity);
1632     }
1633 
1634     function getOwnershipData(uint256 tokenId)
1635         external
1636         view
1637         returns (TokenOwnership memory)
1638     {
1639         return ownershipOf(tokenId);
1640     }
1641 
1642 
1643     // ADMIN FUNCTIONALITY
1644     function setMintPaused(bool _mintPaused) external onlyOwner {
1645         mintPaused = _mintPaused;
1646     }
1647 
1648     function setPublicMintPaused(bool _pMintPaused) external onlyOwner {
1649         publicMintPaused = _pMintPaused;
1650     }
1651 
1652     function setPrice(uint256 _price) external onlyOwner {
1653         PRICE = _price;
1654     }
1655 
1656 
1657     function setSignerAddr(address __address) external onlyOwner {
1658         _signer = __address;
1659     }
1660 
1661     function setBaseURI(string calldata newBaseURI) external onlyOwner {
1662         baseURI = newBaseURI;
1663     }
1664 
1665     /**
1666      * @dev Withdraw the contract balance to the dev address or splitter address
1667      */
1668 
1669     function withdrawAll() external onlyOwner {
1670         _widthdraw(msg.sender, address(this).balance);
1671     }
1672 
1673     function _widthdraw(address _address, uint256 _amount) private {
1674         (bool success, ) = _address.call{value: _amount}("");
1675         require(success, "Transfer failed.");
1676     }
1677 }