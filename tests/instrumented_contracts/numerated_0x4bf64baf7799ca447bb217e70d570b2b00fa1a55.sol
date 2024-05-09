1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Contract module that helps prevent reentrant calls to a function.
12  *
13  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
14  * available, which can be applied to functions to make sure there are no nested
15  * (reentrant) calls to them.
16  *
17  * Note that because there is a single `nonReentrant` guard, functions marked as
18  * `nonReentrant` may not call one another. This can be worked around by making
19  * those functions `private`, and then adding `external` `nonReentrant` entry
20  * points to them.
21  *
22  * TIP: If you would like to learn more about reentrancy and alternative ways
23  * to protect against it, check out our blog post
24  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
25  */
26 abstract contract ReentrancyGuard {
27     // Booleans are more expensive than uint256 or any type that takes up a full
28     // word because each write operation emits an extra SLOAD to first read the
29     // slot's contents, replace the bits taken up by the boolean, and then write
30     // back. This is the compiler's defense against contract upgrades and
31     // pointer aliasing, and it cannot be disabled.
32 
33     // The values being non-zero value makes deployment a bit more expensive,
34     // but in exchange the refund on every call to nonReentrant will be lower in
35     // amount. Since refunds are capped to a percentage of the total
36     // transaction's gas, it is best to keep them low in cases like this one, to
37     // increase the likelihood of the full refund coming into effect.
38     uint256 private constant _NOT_ENTERED = 1;
39     uint256 private constant _ENTERED = 2;
40 
41     uint256 private _status;
42 
43     constructor() {
44         _status = _NOT_ENTERED;
45     }
46 
47     /**
48      * @dev Prevents a contract from calling itself, directly or indirectly.
49      * Calling a `nonReentrant` function from another `nonReentrant`
50      * function is not supported. It is possible to prevent this from happening
51      * by making the `nonReentrant` function external, and making it call a
52      * `private` function that does the actual work.
53      */
54     modifier nonReentrant() {
55         // On the first call to nonReentrant, _notEntered will be true
56         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
57 
58         // Any calls to nonReentrant after this point will fail
59         _status = _ENTERED;
60 
61         _;
62 
63         // By storing the original value once again, a refund is triggered (see
64         // https://eips.ethereum.org/EIPS/eip-2200)
65         _status = _NOT_ENTERED;
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
188     bool private wantToRenounceOwnership = false;
189 
190     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
191 
192     /**
193      * @dev Initializes the contract setting the deployer as the initial owner.
194      */
195     constructor() {
196         _transferOwnership(_msgSender());
197     }
198 
199     /**
200      * @dev Returns the address of the current owner.
201      */
202     function owner() public view virtual returns (address) {
203         return _owner;
204     }
205 
206     function setRenounceOwnership(bool _state) external onlyOwner {
207         wantToRenounceOwnership = _state;
208     }
209 
210     /**
211      * @dev Throws if called by any account other than the owner.
212      */
213     modifier onlyOwner() {
214         require(owner() == _msgSender(), "Ownable: caller is not the owner");
215         _;
216     }
217 
218     /**
219      * @dev Leaves the contract without owner. It will not be possible to call
220      * `onlyOwner` functions anymore. Can only be called by the current owner.
221      *
222      * NOTE: Renouncing ownership will leave the contract without an owner,
223      * thereby removing any functionality that is only available to the owner.
224      */
225     function renounceOwnership() public virtual onlyOwner {
226         require(wantToRenounceOwnership, "Not allowed to renouce. Set variable!");
227         _transferOwnership(address(0));
228     }
229 
230     /**
231      * @dev Transfers ownership of the contract to a new account (`newOwner`).
232      * Can only be called by the current owner.
233      */
234     function transferOwnership(address newOwner) public virtual onlyOwner {
235         require(newOwner != address(0), "Ownable: new owner is the zero address");
236         _transferOwnership(newOwner);
237     }
238 
239     /**
240      * @dev Transfers ownership of the contract to a new account (`newOwner`).
241      * Internal function without access restriction.
242      */
243     function _transferOwnership(address newOwner) internal virtual {
244         address oldOwner = _owner;
245         _owner = newOwner;
246         emit OwnershipTransferred(oldOwner, newOwner);
247     }
248 }
249 
250 // File: @openzeppelin/contracts/utils/Address.sol
251 
252 
253 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
254 
255 pragma solidity ^0.8.1;
256 
257 /**
258  * @dev Collection of functions related to the address type
259  */
260 library Address {
261     /**
262      * @dev Returns true if `account` is a contract.
263      *
264      * [IMPORTANT]
265      * ====
266      * It is unsafe to assume that an address for which this function returns
267      * false is an externally-owned account (EOA) and not a contract.
268      *
269      * Among others, `isContract` will return false for the following
270      * types of addresses:
271      *
272      *  - an externally-owned account
273      *  - a contract in construction
274      *  - an address where a contract will be created
275      *  - an address where a contract lived, but was destroyed
276      * ====
277      *
278      * [IMPORTANT]
279      * ====
280      * You shouldn't rely on `isContract` to protect against flash loan attacks!
281      *
282      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
283      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
284      * constructor.
285      * ====
286      */
287     function isContract(address account) internal view returns (bool) {
288         // This method relies on extcodesize/address.code.length, which returns 0
289         // for contracts in construction, since the code is only stored at the end
290         // of the constructor execution.
291 
292         return account.code.length > 0;
293     }
294 
295     /**
296      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
297      * `recipient`, forwarding all available gas and reverting on errors.
298      *
299      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
300      * of certain opcodes, possibly making contracts go over the 2300 gas limit
301      * imposed by `transfer`, making them unable to receive funds via
302      * `transfer`. {sendValue} removes this limitation.
303      *
304      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
305      *
306      * IMPORTANT: because control is transferred to `recipient`, care must be
307      * taken to not create reentrancy vulnerabilities. Consider using
308      * {ReentrancyGuard} or the
309      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
310      */
311     function sendValue(address payable recipient, uint256 amount) internal {
312         require(address(this).balance >= amount, "Address: insufficient balance");
313 
314         (bool success, ) = recipient.call{value: amount}("");
315         require(success, "Address: unable to send value, recipient may have reverted");
316     }
317 
318     /**
319      * @dev Performs a Solidity function call using a low level `call`. A
320      * plain `call` is an unsafe replacement for a function call: use this
321      * function instead.
322      *
323      * If `target` reverts with a revert reason, it is bubbled up by this
324      * function (like regular Solidity function calls).
325      *
326      * Returns the raw returned data. To convert to the expected return value,
327      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
328      *
329      * Requirements:
330      *
331      * - `target` must be a contract.
332      * - calling `target` with `data` must not revert.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
337         return functionCall(target, data, "Address: low-level call failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
342      * `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCall(
347         address target,
348         bytes memory data,
349         string memory errorMessage
350     ) internal returns (bytes memory) {
351         return functionCallWithValue(target, data, 0, errorMessage);
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
356      * but also transferring `value` wei to `target`.
357      *
358      * Requirements:
359      *
360      * - the calling contract must have an ETH balance of at least `value`.
361      * - the called Solidity function must be `payable`.
362      *
363      * _Available since v3.1._
364      */
365     function functionCallWithValue(
366         address target,
367         bytes memory data,
368         uint256 value
369     ) internal returns (bytes memory) {
370         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
375      * with `errorMessage` as a fallback revert reason when `target` reverts.
376      *
377      * _Available since v3.1._
378      */
379     function functionCallWithValue(
380         address target,
381         bytes memory data,
382         uint256 value,
383         string memory errorMessage
384     ) internal returns (bytes memory) {
385         require(address(this).balance >= value, "Address: insufficient balance for call");
386         require(isContract(target), "Address: call to non-contract");
387 
388         (bool success, bytes memory returndata) = target.call{value: value}(data);
389         return verifyCallResult(success, returndata, errorMessage);
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
394      * but performing a static call.
395      *
396      * _Available since v3.3._
397      */
398     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
399         return functionStaticCall(target, data, "Address: low-level static call failed");
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
404      * but performing a static call.
405      *
406      * _Available since v3.3._
407      */
408     function functionStaticCall(
409         address target,
410         bytes memory data,
411         string memory errorMessage
412     ) internal view returns (bytes memory) {
413         require(isContract(target), "Address: static call to non-contract");
414 
415         (bool success, bytes memory returndata) = target.staticcall(data);
416         return verifyCallResult(success, returndata, errorMessage);
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
421      * but performing a delegate call.
422      *
423      * _Available since v3.4._
424      */
425     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
426         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
431      * but performing a delegate call.
432      *
433      * _Available since v3.4._
434      */
435     function functionDelegateCall(
436         address target,
437         bytes memory data,
438         string memory errorMessage
439     ) internal returns (bytes memory) {
440         require(isContract(target), "Address: delegate call to non-contract");
441 
442         (bool success, bytes memory returndata) = target.delegatecall(data);
443         return verifyCallResult(success, returndata, errorMessage);
444     }
445 
446     /**
447      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
448      * revert reason using the provided one.
449      *
450      * _Available since v4.3._
451      */
452     function verifyCallResult(
453         bool success,
454         bytes memory returndata,
455         string memory errorMessage
456     ) internal pure returns (bytes memory) {
457         if (success) {
458             return returndata;
459         } else {
460             // Look for revert reason and bubble it up if present
461             if (returndata.length > 0) {
462                 // The easiest way to bubble the revert reason is using memory via assembly
463 
464                 assembly {
465                     let returndata_size := mload(returndata)
466                     revert(add(32, returndata), returndata_size)
467                 }
468             } else {
469                 revert(errorMessage);
470             }
471         }
472     }
473 }
474 
475 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
476 
477 
478 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
479 
480 pragma solidity ^0.8.0;
481 
482 /**
483  * @title ERC721 token receiver interface
484  * @dev Interface for any contract that wants to support safeTransfers
485  * from ERC721 asset contracts.
486  */
487 interface IERC721Receiver {
488     /**
489      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
490      * by `operator` from `from`, this function is called.
491      *
492      * It must return its Solidity selector to confirm the token transfer.
493      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
494      *
495      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
496      */
497     function onERC721Received(
498         address operator,
499         address from,
500         uint256 tokenId,
501         bytes calldata data
502     ) external returns (bytes4);
503 }
504 
505 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
506 
507 
508 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
509 
510 pragma solidity ^0.8.0;
511 
512 /**
513  * @dev Interface of the ERC165 standard, as defined in the
514  * https://eips.ethereum.org/EIPS/eip-165[EIP].
515  *
516  * Implementers can declare support of contract interfaces, which can then be
517  * queried by others ({ERC165Checker}).
518  *
519  * For an implementation, see {ERC165}.
520  */
521 interface IERC165 {
522     /**
523      * @dev Returns true if this contract implements the interface defined by
524      * `interfaceId`. See the corresponding
525      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
526      * to learn more about how these ids are created.
527      *
528      * This function call must use less than 30 000 gas.
529      */
530     function supportsInterface(bytes4 interfaceId) external view returns (bool);
531 }
532 
533 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
534 
535 
536 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
537 
538 pragma solidity ^0.8.0;
539 
540 
541 /**
542  * @dev Implementation of the {IERC165} interface.
543  *
544  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
545  * for the additional interface id that will be supported. For example:
546  *
547  * ```solidity
548  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
549  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
550  * }
551  * ```
552  *
553  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
554  */
555 abstract contract ERC165 is IERC165 {
556     /**
557      * @dev See {IERC165-supportsInterface}.
558      */
559     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
560         return interfaceId == type(IERC165).interfaceId;
561     }
562 }
563 
564 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
565 
566 
567 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
568 
569 pragma solidity ^0.8.0;
570 
571 
572 /**
573  * @dev Required interface of an ERC721 compliant contract.
574  */
575 interface IERC721 is IERC165 {
576     /**
577      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
578      */
579     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
580 
581     /**
582      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
583      */
584     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
585 
586     /**
587      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
588      */
589     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
590 
591     /**
592      * @dev Returns the number of tokens in ``owner``'s account.
593      */
594     function balanceOf(address owner) external view returns (uint256 balance);
595 
596     /**
597      * @dev Returns the owner of the `tokenId` token.
598      *
599      * Requirements:
600      *
601      * - `tokenId` must exist.
602      */
603     function ownerOf(uint256 tokenId) external view returns (address owner);
604 
605     /**
606      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
607      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
608      *
609      * Requirements:
610      *
611      * - `from` cannot be the zero address.
612      * - `to` cannot be the zero address.
613      * - `tokenId` token must exist and be owned by `from`.
614      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
615      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
616      *
617      * Emits a {Transfer} event.
618      */
619     function safeTransferFrom(
620         address from,
621         address to,
622         uint256 tokenId
623     ) external;
624 
625     /**
626      * @dev Transfers `tokenId` token from `from` to `to`.
627      *
628      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
629      *
630      * Requirements:
631      *
632      * - `from` cannot be the zero address.
633      * - `to` cannot be the zero address.
634      * - `tokenId` token must be owned by `from`.
635      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
636      *
637      * Emits a {Transfer} event.
638      */
639     function transferFrom(
640         address from,
641         address to,
642         uint256 tokenId
643     ) external;
644 
645     /**
646      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
647      * The approval is cleared when the token is transferred.
648      *
649      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
650      *
651      * Requirements:
652      *
653      * - The caller must own the token or be an approved operator.
654      * - `tokenId` must exist.
655      *
656      * Emits an {Approval} event.
657      */
658     function approve(address to, uint256 tokenId) external;
659 
660     /**
661      * @dev Returns the account approved for `tokenId` token.
662      *
663      * Requirements:
664      *
665      * - `tokenId` must exist.
666      */
667     function getApproved(uint256 tokenId) external view returns (address operator);
668 
669     /**
670      * @dev Approve or remove `operator` as an operator for the caller.
671      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
672      *
673      * Requirements:
674      *
675      * - The `operator` cannot be the caller.
676      *
677      * Emits an {ApprovalForAll} event.
678      */
679     function setApprovalForAll(address operator, bool _approved) external;
680 
681     /**
682      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
683      *
684      * See {setApprovalForAll}
685      */
686     function isApprovedForAll(address owner, address operator) external view returns (bool);
687 
688     /**
689      * @dev Safely transfers `tokenId` token from `from` to `to`.
690      *
691      * Requirements:
692      *
693      * - `from` cannot be the zero address.
694      * - `to` cannot be the zero address.
695      * - `tokenId` token must exist and be owned by `from`.
696      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
697      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
698      *
699      * Emits a {Transfer} event.
700      */
701     function safeTransferFrom(
702         address from,
703         address to,
704         uint256 tokenId,
705         bytes calldata data
706     ) external;
707 }
708 
709 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
710 
711 
712 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
713 
714 pragma solidity ^0.8.0;
715 
716 
717 /**
718  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
719  * @dev See https://eips.ethereum.org/EIPS/eip-721
720  */
721 interface IERC721Metadata is IERC721 {
722     /**
723      * @dev Returns the token collection name.
724      */
725     function name() external view returns (string memory);
726 
727     /**
728      * @dev Returns the token collection symbol.
729      */
730     function symbol() external view returns (string memory);
731 
732     /**
733      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
734      */
735     function tokenURI(uint256 tokenId) external view returns (string memory);
736 }
737 
738 // File: contracts/0xCryptoPunks.sol
739 
740 
741 
742 pragma solidity ^0.8.0;
743 
744 
745 
746 
747 
748 
749 
750 
751 /**
752  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
753  * the Metadata extension. Built to optimize for lower gas during batch mints.
754  *
755  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
756  *
757  * Does not support burning tokens to address(0).
758  *
759  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
760  */
761 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
762     using Address for address;
763     using Strings for uint256;
764 
765     struct TokenOwnership {
766         address addr;
767         uint64 startTimestamp;
768     }
769 
770     struct AddressData {
771         uint128 balance;
772         uint128 numberMinted;
773     }
774 
775     uint256 internal currentIndex;
776 
777     // Token name
778     string private _name;
779 
780     // Token symbol
781     string private _symbol;
782 
783     // Mapping from token ID to ownership details
784     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
785     mapping(uint256 => TokenOwnership) internal _ownerships;
786 
787     // Mapping owner address to address data
788     mapping(address => AddressData) private _addressData;
789 
790     // Mapping from token ID to approved address
791     mapping(uint256 => address) private _tokenApprovals;
792 
793     // Mapping from owner to operator approvals
794     mapping(address => mapping(address => bool)) private _operatorApprovals;
795 
796     constructor(string memory name_, string memory symbol_) {
797         _name = name_;
798         _symbol = symbol_;
799     }
800 
801     function totalSupply() public view returns (uint256) {
802         return currentIndex;
803     }
804 
805     /**
806      * @dev See {IERC165-supportsInterface}.
807      */
808     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
809         return
810         interfaceId == type(IERC721).interfaceId ||
811         interfaceId == type(IERC721Metadata).interfaceId ||
812         super.supportsInterface(interfaceId);
813     }
814 
815     /**
816      * @dev See {IERC721-balanceOf}.
817      */
818     function balanceOf(address owner) public view override returns (uint256) {
819         require(owner != address(0), 'ERC721A: balance query for the zero address');
820         return uint256(_addressData[owner].balance);
821     }
822 
823     function _numberMinted(address owner) internal view returns (uint256) {
824         require(owner != address(0), 'ERC721A: number minted query for the zero address');
825         return uint256(_addressData[owner].numberMinted);
826     }
827 
828     /**
829      * Gas spent here starts off proportional to the maximum mint batch size.
830      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
831      */
832     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
833         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
834 
835     unchecked {
836         for (uint256 curr = tokenId; curr >= 0; curr--) {
837             TokenOwnership memory ownership = _ownerships[curr];
838             if (ownership.addr != address(0)) {
839                 return ownership;
840             }
841         }
842     }
843 
844         revert('ERC721A: unable to determine the owner of token');
845     }
846 
847     /**
848      * @dev See {IERC721-ownerOf}.
849      */
850     function ownerOf(uint256 tokenId) public view override returns (address) {
851         return ownershipOf(tokenId).addr;
852     }
853 
854     /**
855      * @dev See {IERC721Metadata-name}.
856      */
857     function name() public view virtual override returns (string memory) {
858         return _name;
859     }
860 
861     /**
862      * @dev See {IERC721Metadata-symbol}.
863      */
864     function symbol() public view virtual override returns (string memory) {
865         return _symbol;
866     }
867 
868     /**
869      * @dev See {IERC721Metadata-tokenURI}.
870      */
871     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
872         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
873 
874         string memory baseURI = _baseURI();
875         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
876     }
877 
878     /**
879      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
880      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
881      * by default, can be overriden in child contracts.
882      */
883     function _baseURI() internal view virtual returns (string memory) {
884         return '';
885     }
886 
887     /**
888      * @dev See {IERC721-approve}.
889      */
890     function approve(address to, uint256 tokenId) public override {
891         address owner = ERC721A.ownerOf(tokenId);
892         require(to != owner, 'ERC721A: approval to current owner');
893 
894         require(
895             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
896             'ERC721A: approve caller is not owner nor approved for all'
897         );
898 
899         _approve(to, tokenId, owner);
900     }
901 
902     /**
903      * @dev See {IERC721-getApproved}.
904      */
905     function getApproved(uint256 tokenId) public view override returns (address) {
906         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
907 
908         return _tokenApprovals[tokenId];
909     }
910 
911     /**
912      * @dev See {IERC721-setApprovalForAll}.
913      */
914     function setApprovalForAll(address operator, bool approved) public override {
915         require(operator != _msgSender(), 'ERC721A: approve to caller');
916 
917         _operatorApprovals[_msgSender()][operator] = approved;
918         emit ApprovalForAll(_msgSender(), operator, approved);
919     }
920 
921     /**
922      * @dev See {IERC721-isApprovedForAll}.
923      */
924     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
925         return _operatorApprovals[owner][operator];
926     }
927 
928     /**
929      * @dev See {IERC721-transferFrom}.
930      */
931     function transferFrom(
932         address from,
933         address to,
934         uint256 tokenId
935     ) public override {
936         _transfer(from, to, tokenId);
937     }
938 
939     /**
940      * @dev See {IERC721-safeTransferFrom}.
941      */
942     function safeTransferFrom(
943         address from,
944         address to,
945         uint256 tokenId
946     ) public override {
947         safeTransferFrom(from, to, tokenId, '');
948     }
949 
950     /**
951      * @dev See {IERC721-safeTransferFrom}.
952      */
953     function safeTransferFrom(
954         address from,
955         address to,
956         uint256 tokenId,
957         bytes memory _data
958     ) public override {
959         _transfer(from, to, tokenId);
960         require(
961             _checkOnERC721Received(from, to, tokenId, _data),
962             'ERC721A: transfer to non ERC721Receiver implementer'
963         );
964     }
965 
966     /**
967      * @dev Returns whether `tokenId` exists.
968      *
969      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
970      *
971      * Tokens start existing when they are minted (`_mint`),
972      */
973     function _exists(uint256 tokenId) internal view returns (bool) {
974         return (tokenId < currentIndex);
975     }
976 
977     function _safeMint(address to, uint256 quantity) internal {
978         _safeMint(to, quantity, '');
979     }
980 
981     /**
982      * @dev Safely mints `quantity` tokens and transfers them to `to`.
983      *
984      * Requirements:
985      *
986      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
987      * - `quantity` must be greater than 0.
988      *
989      * Emits a {Transfer} event.
990      */
991     function _safeMint(
992         address to,
993         uint256 quantity,
994         bytes memory _data
995     ) internal {
996         _mint(to, quantity, _data, true);
997     }
998 
999     /**
1000      * @dev Mints `quantity` tokens and transfers them to `to`.
1001      *
1002      * Requirements:
1003      *
1004      * - `to` cannot be the zero address.
1005      * - `quantity` must be greater than 0.
1006      *
1007      * Emits a {Transfer} event.
1008      */
1009     function _mint(
1010         address to,
1011         uint256 quantity,
1012         bytes memory _data,
1013         bool safe
1014     ) internal {
1015         uint256 startTokenId = currentIndex;
1016         require(to != address(0), 'ERC721A: mint to the zero address');
1017         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1018 
1019         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1020 
1021         // Overflows are incredibly unrealistic.
1022         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1023         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1024     unchecked {
1025         _addressData[to].balance += uint128(quantity);
1026         _addressData[to].numberMinted += uint128(quantity);
1027 
1028         _ownerships[startTokenId].addr = to;
1029         _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1030 
1031         uint256 updatedIndex = startTokenId;
1032 
1033         for (uint256 i; i < quantity; i++) {
1034             emit Transfer(address(0), to, updatedIndex);
1035             if (safe) {
1036                 require(
1037                     _checkOnERC721Received(address(0), to, updatedIndex, _data),
1038                     'ERC721A: transfer to non ERC721Receiver implementer'
1039                 );
1040             }
1041 
1042             updatedIndex++;
1043         }
1044 
1045         currentIndex = updatedIndex;
1046     }
1047 
1048         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1049     }
1050 
1051     /**
1052      * @dev Transfers `tokenId` from `from` to `to`.
1053      *
1054      * Requirements:
1055      *
1056      * - `to` cannot be the zero address.
1057      * - `tokenId` token must be owned by `from`.
1058      *
1059      * Emits a {Transfer} event.
1060      */
1061     function _transfer(
1062         address from,
1063         address to,
1064         uint256 tokenId
1065     ) private {
1066         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1067 
1068         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1069         getApproved(tokenId) == _msgSender() ||
1070         isApprovedForAll(prevOwnership.addr, _msgSender()));
1071 
1072         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1073 
1074         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1075         require(to != address(0), 'ERC721A: transfer to the zero address');
1076 
1077         _beforeTokenTransfers(from, to, tokenId, 1);
1078 
1079         // Clear approvals from the previous owner
1080         _approve(address(0), tokenId, prevOwnership.addr);
1081 
1082         // Underflow of the sender's balance is impossible because we check for
1083         // ownership above and the recipient's balance can't realistically overflow.
1084         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1085     unchecked {
1086         _addressData[from].balance -= 1;
1087         _addressData[to].balance += 1;
1088 
1089         _ownerships[tokenId].addr = to;
1090         _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1091 
1092         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1093         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1094         uint256 nextTokenId = tokenId + 1;
1095         if (_ownerships[nextTokenId].addr == address(0)) {
1096             if (_exists(nextTokenId)) {
1097                 _ownerships[nextTokenId].addr = prevOwnership.addr;
1098                 _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1099             }
1100         }
1101     }
1102 
1103         emit Transfer(from, to, tokenId);
1104         _afterTokenTransfers(from, to, tokenId, 1);
1105     }
1106 
1107     /**
1108      * @dev Approve `to` to operate on `tokenId`
1109      *
1110      * Emits a {Approval} event.
1111      */
1112     function _approve(
1113         address to,
1114         uint256 tokenId,
1115         address owner
1116     ) private {
1117         _tokenApprovals[tokenId] = to;
1118         emit Approval(owner, to, tokenId);
1119     }
1120 
1121     /**
1122      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1123      * The call is not executed if the target address is not a contract.
1124      *
1125      * @param from address representing the previous owner of the given token ID
1126      * @param to target address that will receive the tokens
1127      * @param tokenId uint256 ID of the token to be transferred
1128      * @param _data bytes optional data to send along with the call
1129      * @return bool whether the call correctly returned the expected magic value
1130      */
1131     function _checkOnERC721Received(
1132         address from,
1133         address to,
1134         uint256 tokenId,
1135         bytes memory _data
1136     ) private returns (bool) {
1137         if (to.isContract()) {
1138             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1139                 return retval == IERC721Receiver(to).onERC721Received.selector;
1140             } catch (bytes memory reason) {
1141                 if (reason.length == 0) {
1142                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1143                 } else {
1144                     assembly {
1145                         revert(add(32, reason), mload(reason))
1146                     }
1147                 }
1148             }
1149         } else {
1150             return true;
1151         }
1152     }
1153 
1154     /**
1155      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1156      *
1157      * startTokenId - the first token id to be transferred
1158      * quantity - the amount to be transferred
1159      *
1160      * Calling conditions:
1161      *
1162      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1163      * transferred to `to`.
1164      * - When `from` is zero, `tokenId` will be minted for `to`.
1165      */
1166     function _beforeTokenTransfers(
1167         address from,
1168         address to,
1169         uint256 startTokenId,
1170         uint256 quantity
1171     ) internal virtual {}
1172 
1173     /**
1174      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1175      * minting.
1176      *
1177      * startTokenId - the first token id to be transferred
1178      * quantity - the amount to be transferred
1179      *
1180      * Calling conditions:
1181      *
1182      * - when `from` and `to` are both non-zero.
1183      * - `from` and `to` are never both zero.
1184      */
1185     function _afterTokenTransfers(
1186         address from,
1187         address to,
1188         uint256 startTokenId,
1189         uint256 quantity
1190     ) internal virtual {}
1191 }
1192 
1193 pragma solidity ^0.8.4;
1194 
1195 
1196 
1197 contract OxCryptoPunks is ERC721A, Ownable, ReentrancyGuard {
1198     using Strings for uint256;
1199 
1200     uint256 public PRICE = 20000000000000000; //0.02 eth
1201     uint128 public FREE_MINT_PRICE = 0; 
1202     uint256 public MAX_SUPPLY = 9999;
1203     uint256 public MAX_MINT_AMOUNT_PER_TX = 10;
1204     uint256 public FREE_MINT_IS_ALLOWED_UNTIL = 999; // Free mint is allowed until x mint
1205 
1206     bool public IS_SALE_ACTIVE = false;
1207     bool public REVEALED = false;
1208 
1209     string public URIPREFIX = "";
1210     string public URISUFFIX = ".json";
1211     string public HIDDENMETADATAURI = "";
1212 
1213     constructor() 
1214     ERC721A("0xCryptoPunks", "0xCP") {
1215         setHiddenMetadataUri("ipfs://QmSZHtu4SaWKTgBTYh9nBBtLDgMm9pJZTrP439wTEvUot1/");
1216     }
1217 
1218     /** GETTERS **/
1219     function _baseURI() internal view virtual override returns (string memory) {
1220         return URIPREFIX;
1221     }
1222 
1223     function tokenURI(uint256 _tokenId)
1224     public
1225     view
1226     virtual
1227     override
1228     returns (string memory)
1229   {
1230     require(
1231       _exists(_tokenId),
1232       "ERC721Metadata: URI query for nonexistent token"
1233     );
1234 
1235 
1236     if (REVEALED == false) {
1237       return bytes(HIDDENMETADATAURI).length > 0
1238         ? string(abi.encodePacked(HIDDENMETADATAURI, _tokenId.toString(), ".json"))
1239         : "";
1240     }
1241 
1242     string memory currentBaseURI = _baseURI();
1243     return bytes(currentBaseURI).length > 0
1244         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), URISUFFIX))
1245         : "";
1246   }
1247     
1248     /** SETTERS **/
1249     function setPrice(uint256 customPrice) external onlyOwner {
1250         PRICE = customPrice;
1251     }
1252 
1253     function setLowerMaxSupply(uint256 newMaxSupply) external onlyOwner {
1254         require(newMaxSupply < MAX_SUPPLY, "Invalid new max supply");
1255         require(newMaxSupply >= currentIndex, "Invalid new max supply");
1256         MAX_SUPPLY = newMaxSupply;
1257     }
1258 
1259     function setMaxMintPerTx(uint256 maxMintPerTx) external onlyOwner {
1260         MAX_MINT_AMOUNT_PER_TX = maxMintPerTx;
1261     }
1262 
1263     function setSaleActive(bool saleIsActive) external onlyOwner {
1264         IS_SALE_ACTIVE = saleIsActive;
1265     }
1266 
1267     function setFreeMintAllowedUntil(uint256 freeMintIsAllowedUntil) external onlyOwner {
1268         FREE_MINT_IS_ALLOWED_UNTIL = freeMintIsAllowedUntil;
1269     }
1270 
1271     function setHiddenMetadataUri(string memory _hiddenMetadataUri) internal onlyOwner {
1272         HIDDENMETADATAURI = _hiddenMetadataUri;
1273      }
1274 
1275      function setExHiddenMetadataUri(string memory _hiddenMetadataUri) external onlyOwner {
1276         HIDDENMETADATAURI = _hiddenMetadataUri;
1277      }
1278 
1279      function setRevealed(bool _state) external onlyOwner {
1280         string memory currentBaseURI = _baseURI();
1281         require(bytes(currentBaseURI).length != 0, "Set the URIprefix before revealing the NFTs!");
1282         REVEALED = _state;
1283     }
1284 
1285     function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1286         URIPREFIX = _uriPrefix;
1287     }
1288 
1289     function setUriSuffix(string memory _uriSuffix) external onlyOwner {
1290         URISUFFIX = _uriSuffix;
1291     }
1292 
1293     /** MINT **/
1294     modifier mintCompliance(uint256 _mintAmount) {
1295         require(_mintAmount > 0 && _mintAmount <= MAX_MINT_AMOUNT_PER_TX, "Invalid mint amount or transaction maximum exceeded!");
1296         require(currentIndex + _mintAmount <= MAX_SUPPLY, "Max supply exceeded!");
1297         _;
1298     }
1299 
1300     function mint(uint256 _mintAmount) external payable mintCompliance(_mintAmount) nonReentrant {
1301         require(IS_SALE_ACTIVE, "Sale is not active!");
1302 
1303         uint256 price;
1304 
1305         if (currentIndex < FREE_MINT_IS_ALLOWED_UNTIL) {
1306             price = FREE_MINT_PRICE;        
1307         }
1308         else {
1309             price = _mintAmount * PRICE;
1310         }
1311 
1312         require(msg.value >= price, "Insufficient funds!");
1313 
1314         _safeMint(msg.sender, _mintAmount);
1315     }
1316 
1317     function mintOwner(address _to, uint256 _mintAmount) external mintCompliance(_mintAmount) onlyOwner {
1318         _safeMint(_to, _mintAmount);
1319     }
1320 
1321     function withdraw() external onlyOwner nonReentrant {
1322     // Transfer balance to the owner.
1323         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1324         require(os, "Transfer failed.");
1325     }
1326 }