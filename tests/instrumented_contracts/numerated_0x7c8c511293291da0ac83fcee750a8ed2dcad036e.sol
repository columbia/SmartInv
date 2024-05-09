1 /**
2 888 messages floating in the ocean awaiting their beholder. 
3 Rumor has it inside are quests, heroes, villains, maps, and maybe even treasure.
4 */
5 
6 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
7 
8 // SPDX-License-Identifier: MIT
9 
10 // Illuminati: True
11 
12 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
13 
14 pragma solidity ^0.8.0;
15 
16 /**
17  * @dev Contract module that helps prevent reentrant calls to a function.
18  *
19  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
20  * available, which can be applied to functions to make sure there are no nested
21  * (reentrant) calls to them.
22  *
23  * Note that because there is a single `nonReentrant` guard, functions marked as
24  * `nonReentrant` may not call one another. This can be worked around by making
25  * those functions `private`, and then adding `external` `nonReentrant` entry
26  * points to them.
27  *
28  * TIP: If you would like to learn more about reentrancy and alternative ways
29  * to protect against it, check out our blog post
30  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
31  */
32 abstract contract ReentrancyGuard {
33     // Booleans are more expensive than uint256 or any type that takes up a full
34     // word because each write operation emits an extra SLOAD to first read the
35     // slot's contents, replace the bits taken up by the boolean, and then write
36     // back. This is the compiler's defense against contract upgrades and
37     // pointer aliasing, and it cannot be disabled.
38 
39     // The values being non-zero value makes deployment a bit more expensive,
40     // but in exchange the refund on every call to nonReentrant will be lower in
41     // amount. Since refunds are capped to a percentage of the total
42     // transaction's gas, it is best to keep them low in cases like this one, to
43     // increase the likelihood of the full refund coming into effect.
44     uint256 private constant _NOT_ENTERED = 1;
45     uint256 private constant _ENTERED = 2;
46 
47     uint256 private _status;
48 
49     constructor() {
50         _status = _NOT_ENTERED;
51     }
52 
53     /**
54      * @dev Prevents a contract from calling itself, directly or indirectly.
55      * Calling a `nonReentrant` function from another `nonReentrant`
56      * function is not supported. It is possible to prevent this from happening
57      * by making the `nonReentrant` function external, and making it call a
58      * `private` function that does the actual work.
59      */
60     modifier nonReentrant() {
61         // On the first call to nonReentrant, _notEntered will be true
62         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
63 
64         // Any calls to nonReentrant after this point will fail
65         _status = _ENTERED;
66 
67         _;
68 
69         // By storing the original value once again, a refund is triggered (see
70         // https://eips.ethereum.org/EIPS/eip-2200)
71         _status = _NOT_ENTERED;
72     }
73 }
74 
75 // File: @openzeppelin/contracts/utils/Strings.sol
76 
77 
78 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
79 
80 pragma solidity ^0.8.0;
81 
82 /**
83  * @dev String operations.
84  */
85 library Strings {
86     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
87 
88     /**
89      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
90      */
91     function toString(uint256 value) internal pure returns (string memory) {
92         // Inspired by OraclizeAPI's implementation - MIT licence
93         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
94 
95         if (value == 0) {
96             return "0";
97         }
98         uint256 temp = value;
99         uint256 digits;
100         while (temp != 0) {
101             digits++;
102             temp /= 10;
103         }
104         bytes memory buffer = new bytes(digits);
105         while (value != 0) {
106             digits -= 1;
107             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
108             value /= 10;
109         }
110         return string(buffer);
111     }
112 
113     /**
114      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
115      */
116     function toHexString(uint256 value) internal pure returns (string memory) {
117         if (value == 0) {
118             return "0x00";
119         }
120         uint256 temp = value;
121         uint256 length = 0;
122         while (temp != 0) {
123             length++;
124             temp >>= 8;
125         }
126         return toHexString(value, length);
127     }
128 
129     /**
130      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
131      */
132     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
133         bytes memory buffer = new bytes(2 * length + 2);
134         buffer[0] = "0";
135         buffer[1] = "x";
136         for (uint256 i = 2 * length + 1; i > 1; --i) {
137             buffer[i] = _HEX_SYMBOLS[value & 0xf];
138             value >>= 4;
139         }
140         require(value == 0, "Strings: hex length insufficient");
141         return string(buffer);
142     }
143 }
144 
145 // File: @openzeppelin/contracts/utils/Context.sol
146 
147 
148 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
149 
150 pragma solidity ^0.8.0;
151 
152 /**
153  * @dev Provides information about the current execution context, including the
154  * sender of the transaction and its data. While these are generally available
155  * via msg.sender and msg.data, they should not be accessed in such a direct
156  * manner, since when dealing with meta-transactions the account sending and
157  * paying for execution may not be the actual sender (as far as an application
158  * is concerned).
159  *
160  * This contract is only required for intermediate, library-like contracts.
161  */
162 abstract contract Context {
163     function _msgSender() internal view virtual returns (address) {
164         return msg.sender;
165     }
166 
167     function _msgData() internal view virtual returns (bytes calldata) {
168         return msg.data;
169     }
170 }
171 
172 // File: @openzeppelin/contracts/access/Ownable.sol
173 
174 
175 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
176 
177 pragma solidity ^0.8.0;
178 
179 
180 /**
181  * @dev Contract module which provides a basic access control mechanism, where
182  * there is an account (an owner) that can be granted exclusive access to
183  * specific functions.
184  *
185  * By default, the owner account will be the one that deploys the contract. This
186  * can later be changed with {transferOwnership}.
187  *
188  * This module is used through inheritance. It will make available the modifier
189  * `onlyOwner`, which can be applied to your functions to restrict their use to
190  * the owner.
191  */
192 abstract contract Ownable is Context {
193     address private _owner;
194 
195     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
196 
197     /**
198      * @dev Initializes the contract setting the deployer as the initial owner.
199      */
200     constructor() {
201         _transferOwnership(_msgSender());
202     }
203 
204     /**
205      * @dev Returns the address of the current owner.
206      */
207     function owner() public view virtual returns (address) {
208         return _owner;
209     }
210 
211     /**
212      * @dev Throws if called by any account other than the owner.
213      */
214     modifier onlyOwner() {
215         require(owner() == _msgSender(), "Ownable: caller is not the owner");
216         _;
217     }
218 
219     /**
220      * @dev Leaves the contract without owner. It will not be possible to call
221      * `onlyOwner` functions anymore. Can only be called by the current owner.
222      *
223      * NOTE: Renouncing ownership will leave the contract without an owner,
224      * thereby removing any functionality that is only available to the owner.
225      */
226     function renounceOwnership() public virtual onlyOwner {
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
738 // File: contracts/ERC721A.sol
739 
740 
741 // Creator: Chiru Labs
742 
743 pragma solidity ^0.8.4;
744 
745 
746 
747 
748 
749 
750 
751 
752 error ApprovalCallerNotOwnerNorApproved();
753 error ApprovalQueryForNonexistentToken();
754 error ApproveToCaller();
755 error ApprovalToCurrentOwner();
756 error BalanceQueryForZeroAddress();
757 error MintToZeroAddress();
758 error MintZeroQuantity();
759 error OwnerQueryForNonexistentToken();
760 error TransferCallerNotOwnerNorApproved();
761 error TransferFromIncorrectOwner();
762 error TransferToNonERC721ReceiverImplementer();
763 error TransferToZeroAddress();
764 error URIQueryForNonexistentToken();
765 
766 /**
767  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
768  * the Metadata extension. Built to optimize for lower gas during batch mints.
769  *
770  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
771  *
772  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
773  *
774  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
775  */
776 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
777     using Address for address;
778     using Strings for uint256;
779 
780     // Compiler will pack this into a single 256bit word.
781     struct TokenOwnership {
782         // The address of the owner.
783         address addr;
784         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
785         uint64 startTimestamp;
786         // Whether the token has been burned.
787         bool burned;
788     }
789 
790     // Compiler will pack this into a single 256bit word.
791     struct AddressData {
792         // Realistically, 2**64-1 is more than enough.
793         uint64 balance;
794         // Keeps track of mint count with minimal overhead for tokenomics.
795         uint64 numberMinted;
796         // Keeps track of burn count with minimal overhead for tokenomics.
797         uint64 numberBurned;
798         // For miscellaneous variable(s) pertaining to the address
799         // (e.g. number of whitelist mint slots used).
800         // If there are multiple variables, please pack them into a uint64.
801         uint64 aux;
802     }
803 
804     // The tokenId of the next token to be minted.
805     uint256 internal _currentIndex;
806 
807     // The number of tokens burned.
808     uint256 internal _burnCounter;
809 
810     // Token name
811     string private _name;
812 
813     // Token symbol
814     string private _symbol;
815 
816     // Mapping from token ID to ownership details
817     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
818     mapping(uint256 => TokenOwnership) internal _ownerships;
819 
820     // Mapping owner address to address data
821     mapping(address => AddressData) private _addressData;
822 
823     // Mapping from token ID to approved address
824     mapping(uint256 => address) private _tokenApprovals;
825 
826     // Mapping from owner to operator approvals
827     mapping(address => mapping(address => bool)) private _operatorApprovals;
828 
829     constructor(string memory name_, string memory symbol_) {
830         _name = name_;
831         _symbol = symbol_;
832         _currentIndex = _startTokenId();
833     }
834 
835     /**
836      * To change the starting tokenId, please override this function.
837      */
838     function _startTokenId() internal view virtual returns (uint256) {
839         return 1;
840     }
841 
842     /**
843      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
844      */
845     function totalSupply() public view returns (uint256) {
846         // Counter underflow is impossible as _burnCounter cannot be incremented
847         // more than _currentIndex - _startTokenId() times
848         unchecked {
849             return _currentIndex - _burnCounter - _startTokenId();
850         }
851     }
852 
853     /**
854      * Returns the total amount of tokens minted in the contract.
855      */
856     function _totalMinted() internal view returns (uint256) {
857         // Counter underflow is impossible as _currentIndex does not decrement,
858         // and it is initialized to _startTokenId()
859         unchecked {
860             return _currentIndex - _startTokenId();
861         }
862     }
863 
864     /**
865      * @dev See {IERC165-supportsInterface}.
866      */
867     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
868         return
869             interfaceId == type(IERC721).interfaceId ||
870             interfaceId == type(IERC721Metadata).interfaceId ||
871             super.supportsInterface(interfaceId);
872     }
873 
874     /**
875      * @dev See {IERC721-balanceOf}.
876      */
877     function balanceOf(address owner) public view override returns (uint256) {
878         if (owner == address(0)) revert BalanceQueryForZeroAddress();
879         return uint256(_addressData[owner].balance);
880     }
881 
882     /**
883      * Returns the number of tokens minted by `owner`.
884      */
885     function _numberMinted(address owner) internal view returns (uint256) {
886         return uint256(_addressData[owner].numberMinted);
887     }
888 
889     /**
890      * Returns the number of tokens burned by or on behalf of `owner`.
891      */
892     function _numberBurned(address owner) internal view returns (uint256) {
893         return uint256(_addressData[owner].numberBurned);
894     }
895 
896     /**
897      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
898      */
899     function _getAux(address owner) internal view returns (uint64) {
900         return _addressData[owner].aux;
901     }
902 
903     /**
904      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
905      * If there are multiple variables, please pack them into a uint64.
906      */
907     function _setAux(address owner, uint64 aux) internal {
908         _addressData[owner].aux = aux;
909     }
910 
911     /**
912      * Gas spent here starts off proportional to the maximum mint batch size.
913      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
914      */
915     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
916         uint256 curr = tokenId;
917 
918         unchecked {
919             if (_startTokenId() <= curr && curr < _currentIndex) {
920                 TokenOwnership memory ownership = _ownerships[curr];
921                 if (!ownership.burned) {
922                     if (ownership.addr != address(0)) {
923                         return ownership;
924                     }
925                     // Invariant:
926                     // There will always be an ownership that has an address and is not burned
927                     // before an ownership that does not have an address and is not burned.
928                     // Hence, curr will not underflow.
929                     while (true) {
930                         curr--;
931                         ownership = _ownerships[curr];
932                         if (ownership.addr != address(0)) {
933                             return ownership;
934                         }
935                     }
936                 }
937             }
938         }
939         revert OwnerQueryForNonexistentToken();
940     }
941 
942     /**
943      * @dev See {IERC721-ownerOf}.
944      */
945     function ownerOf(uint256 tokenId) public view override returns (address) {
946         return _ownershipOf(tokenId).addr;
947     }
948 
949     /**
950      * @dev See {IERC721Metadata-name}.
951      */
952     function name() public view virtual override returns (string memory) {
953         return _name;
954     }
955 
956     /**
957      * @dev See {IERC721Metadata-symbol}.
958      */
959     function symbol() public view virtual override returns (string memory) {
960         return _symbol;
961     }
962 
963     /**
964      * @dev See {IERC721Metadata-tokenURI}.
965      */
966     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
967         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
968 
969         string memory baseURI = _baseURI();
970         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
971     }
972 
973     /**
974      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
975      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
976      * by default, can be overriden in child contracts.
977      */
978     function _baseURI() internal view virtual returns (string memory) {
979         return '';
980     }
981 
982     /**
983      * @dev See {IERC721-approve}.
984      */
985     function approve(address to, uint256 tokenId) public override {
986         address owner = ERC721A.ownerOf(tokenId);
987         if (to == owner) revert ApprovalToCurrentOwner();
988 
989         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
990             revert ApprovalCallerNotOwnerNorApproved();
991         }
992 
993         _approve(to, tokenId, owner);
994     }
995 
996     /**
997      * @dev See {IERC721-getApproved}.
998      */
999     function getApproved(uint256 tokenId) public view override returns (address) {
1000         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1001 
1002         return _tokenApprovals[tokenId];
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-setApprovalForAll}.
1007      */
1008     function setApprovalForAll(address operator, bool approved) public virtual override {
1009         if (operator == _msgSender()) revert ApproveToCaller();
1010 
1011         _operatorApprovals[_msgSender()][operator] = approved;
1012         emit ApprovalForAll(_msgSender(), operator, approved);
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-isApprovedForAll}.
1017      */
1018     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1019         return _operatorApprovals[owner][operator];
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-transferFrom}.
1024      */
1025     function transferFrom(
1026         address from,
1027         address to,
1028         uint256 tokenId
1029     ) public virtual override {
1030         _transfer(from, to, tokenId);
1031     }
1032 
1033     /**
1034      * @dev See {IERC721-safeTransferFrom}.
1035      */
1036     function safeTransferFrom(
1037         address from,
1038         address to,
1039         uint256 tokenId
1040     ) public virtual override {
1041         safeTransferFrom(from, to, tokenId, '');
1042     }
1043 
1044     /**
1045      * @dev See {IERC721-safeTransferFrom}.
1046      */
1047     function safeTransferFrom(
1048         address from,
1049         address to,
1050         uint256 tokenId,
1051         bytes memory _data
1052     ) public virtual override {
1053         _transfer(from, to, tokenId);
1054         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1055             revert TransferToNonERC721ReceiverImplementer();
1056         }
1057     }
1058 
1059     /**
1060      * @dev Returns whether `tokenId` exists.
1061      *
1062      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1063      *
1064      * Tokens start existing when they are minted (`_mint`),
1065      */
1066     function _exists(uint256 tokenId) internal view returns (bool) {
1067         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1068     }
1069 
1070     /**
1071      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1072      */
1073     function _safeMint(address to, uint256 quantity) internal {
1074         _safeMint(to, quantity, '');
1075     }
1076 
1077     /**
1078      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1079      *
1080      * Requirements:
1081      *
1082      * - If `to` refers to a smart contract, it must implement 
1083      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1084      * - `quantity` must be greater than 0.
1085      *
1086      * Emits a {Transfer} event.
1087      */
1088     function _safeMint(
1089         address to,
1090         uint256 quantity,
1091         bytes memory _data
1092     ) internal {
1093         uint256 startTokenId = _currentIndex;
1094         if (to == address(0)) revert MintToZeroAddress();
1095         if (quantity == 0) revert MintZeroQuantity();
1096 
1097         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1098 
1099         // Overflows are incredibly unrealistic.
1100         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1101         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1102         unchecked {
1103             _addressData[to].balance += uint64(quantity);
1104             _addressData[to].numberMinted += uint64(quantity);
1105 
1106             _ownerships[startTokenId].addr = to;
1107             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1108 
1109             uint256 updatedIndex = startTokenId;
1110             uint256 end = updatedIndex + quantity;
1111 
1112             if (to.isContract()) {
1113                 do {
1114                     emit Transfer(address(0), to, updatedIndex);
1115                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1116                         revert TransferToNonERC721ReceiverImplementer();
1117                     }
1118                 } while (updatedIndex != end);
1119                 // Reentrancy protection
1120                 if (_currentIndex != startTokenId) revert();
1121             } else {
1122                 do {
1123                     emit Transfer(address(0), to, updatedIndex++);
1124                 } while (updatedIndex != end);
1125             }
1126             _currentIndex = updatedIndex;
1127         }
1128         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1129     }
1130 
1131     /**
1132      * @dev Mints `quantity` tokens and transfers them to `to`.
1133      *
1134      * Requirements:
1135      *
1136      * - `to` cannot be the zero address.
1137      * - `quantity` must be greater than 0.
1138      *
1139      * Emits a {Transfer} event.
1140      */
1141     function _mint(address to, uint256 quantity) internal {
1142         uint256 startTokenId = _currentIndex;
1143         if (to == address(0)) revert MintToZeroAddress();
1144         if (quantity == 0) revert MintZeroQuantity();
1145 
1146         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1147 
1148         // Overflows are incredibly unrealistic.
1149         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1150         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1151         unchecked {
1152             _addressData[to].balance += uint64(quantity);
1153             _addressData[to].numberMinted += uint64(quantity);
1154 
1155             _ownerships[startTokenId].addr = to;
1156             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1157 
1158             uint256 updatedIndex = startTokenId;
1159             uint256 end = updatedIndex + quantity;
1160 
1161             do {
1162                 emit Transfer(address(0), to, updatedIndex++);
1163             } while (updatedIndex != end);
1164 
1165             _currentIndex = updatedIndex;
1166         }
1167         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1168     }
1169 
1170     /**
1171      * @dev Transfers `tokenId` from `from` to `to`.
1172      *
1173      * Requirements:
1174      *
1175      * - `to` cannot be the zero address.
1176      * - `tokenId` token must be owned by `from`.
1177      *
1178      * Emits a {Transfer} event.
1179      */
1180     function _transfer(
1181         address from,
1182         address to,
1183         uint256 tokenId
1184     ) private {
1185         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1186 
1187         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1188 
1189         bool isApprovedOrOwner = (_msgSender() == from ||
1190             isApprovedForAll(from, _msgSender()) ||
1191             getApproved(tokenId) == _msgSender());
1192 
1193         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1194         if (to == address(0)) revert TransferToZeroAddress();
1195 
1196         _beforeTokenTransfers(from, to, tokenId, 1);
1197 
1198         // Clear approvals from the previous owner
1199         _approve(address(0), tokenId, from);
1200 
1201         // Underflow of the sender's balance is impossible because we check for
1202         // ownership above and the recipient's balance can't realistically overflow.
1203         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1204         unchecked {
1205             _addressData[from].balance -= 1;
1206             _addressData[to].balance += 1;
1207 
1208             TokenOwnership storage currSlot = _ownerships[tokenId];
1209             currSlot.addr = to;
1210             currSlot.startTimestamp = uint64(block.timestamp);
1211 
1212             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1213             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1214             uint256 nextTokenId = tokenId + 1;
1215             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1216             if (nextSlot.addr == address(0)) {
1217                 // This will suffice for checking _exists(nextTokenId),
1218                 // as a burned slot cannot contain the zero address.
1219                 if (nextTokenId != _currentIndex) {
1220                     nextSlot.addr = from;
1221                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1222                 }
1223             }
1224         }
1225 
1226         emit Transfer(from, to, tokenId);
1227         _afterTokenTransfers(from, to, tokenId, 1);
1228     }
1229 
1230     /**
1231      * @dev Equivalent to `_burn(tokenId, false)`.
1232      */
1233     function _burn(uint256 tokenId) internal virtual {
1234         _burn(tokenId, false);
1235     }
1236 
1237     /**
1238      * @dev Destroys `tokenId`.
1239      * The approval is cleared when the token is burned.
1240      *
1241      * Requirements:
1242      *
1243      * - `tokenId` must exist.
1244      *
1245      * Emits a {Transfer} event.
1246      */
1247     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1248         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1249 
1250         address from = prevOwnership.addr;
1251 
1252         if (approvalCheck) {
1253             bool isApprovedOrOwner = (_msgSender() == from ||
1254                 isApprovedForAll(from, _msgSender()) ||
1255                 getApproved(tokenId) == _msgSender());
1256 
1257             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1258         }
1259 
1260         _beforeTokenTransfers(from, address(0), tokenId, 1);
1261 
1262         // Clear approvals from the previous owner
1263         _approve(address(0), tokenId, from);
1264 
1265         // Underflow of the sender's balance is impossible because we check for
1266         // ownership above and the recipient's balance can't realistically overflow.
1267         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1268         unchecked {
1269             AddressData storage addressData = _addressData[from];
1270             addressData.balance -= 1;
1271             addressData.numberBurned += 1;
1272 
1273             // Keep track of who burned the token, and the timestamp of burning.
1274             TokenOwnership storage currSlot = _ownerships[tokenId];
1275             currSlot.addr = from;
1276             currSlot.startTimestamp = uint64(block.timestamp);
1277             currSlot.burned = true;
1278 
1279             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1280             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1281             uint256 nextTokenId = tokenId + 1;
1282             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1283             if (nextSlot.addr == address(0)) {
1284                 // This will suffice for checking _exists(nextTokenId),
1285                 // as a burned slot cannot contain the zero address.
1286                 if (nextTokenId != _currentIndex) {
1287                     nextSlot.addr = from;
1288                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1289                 }
1290             }
1291         }
1292 
1293         emit Transfer(from, address(0), tokenId);
1294         _afterTokenTransfers(from, address(0), tokenId, 1);
1295 
1296         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1297         unchecked {
1298             _burnCounter++;
1299         }
1300     }
1301 
1302     /**
1303      * @dev Approve `to` to operate on `tokenId`
1304      *
1305      * Emits a {Approval} event.
1306      */
1307     function _approve(
1308         address to,
1309         uint256 tokenId,
1310         address owner
1311     ) private {
1312         _tokenApprovals[tokenId] = to;
1313         emit Approval(owner, to, tokenId);
1314     }
1315 
1316     /**
1317      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1318      *
1319      * @param from address representing the previous owner of the given token ID
1320      * @param to target address that will receive the tokens
1321      * @param tokenId uint256 ID of the token to be transferred
1322      * @param _data bytes optional data to send along with the call
1323      * @return bool whether the call correctly returned the expected magic value
1324      */
1325     function _checkContractOnERC721Received(
1326         address from,
1327         address to,
1328         uint256 tokenId,
1329         bytes memory _data
1330     ) private returns (bool) {
1331         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1332             return retval == IERC721Receiver(to).onERC721Received.selector;
1333         } catch (bytes memory reason) {
1334             if (reason.length == 0) {
1335                 revert TransferToNonERC721ReceiverImplementer();
1336             } else {
1337                 assembly {
1338                     revert(add(32, reason), mload(reason))
1339                 }
1340             }
1341         }
1342     }
1343 
1344     /**
1345      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1346      * And also called before burning one token.
1347      *
1348      * startTokenId - the first token id to be transferred
1349      * quantity - the amount to be transferred
1350      *
1351      * Calling conditions:
1352      *
1353      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1354      * transferred to `to`.
1355      * - When `from` is zero, `tokenId` will be minted for `to`.
1356      * - When `to` is zero, `tokenId` will be burned by `from`.
1357      * - `from` and `to` are never both zero.
1358      */
1359     function _beforeTokenTransfers(
1360         address from,
1361         address to,
1362         uint256 startTokenId,
1363         uint256 quantity
1364     ) internal virtual {}
1365 
1366     /**
1367      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1368      * minting.
1369      * And also called after one token has been burned.
1370      *
1371      * startTokenId - the first token id to be transferred
1372      * quantity - the amount to be transferred
1373      *
1374      * Calling conditions:
1375      *
1376      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1377      * transferred to `to`.
1378      * - When `from` is zero, `tokenId` has been minted for `to`.
1379      * - When `to` is zero, `tokenId` has been burned by `from`.
1380      * - `from` and `to` are never both zero.
1381      */
1382     function _afterTokenTransfers(
1383         address from,
1384         address to,
1385         uint256 startTokenId,
1386         uint256 quantity
1387     ) internal virtual {}
1388 }
1389 // File: contracts/MessageInABottle.sol
1390 
1391 
1392 
1393 pragma solidity ^0.8.0;
1394 
1395 
1396 
1397 
1398 
1399 contract MessageInABottle is ERC721A, Ownable, ReentrancyGuard {
1400   using Address for address;
1401   using Strings for uint;
1402 
1403 
1404   string  public  baseTokenURI = "ipfs://QmVGL4rRy2Vk5NhZajTVRec3H8Y5D2GGBREMYxWETJyN27/";
1405   uint256  public  maxSupply = 888;
1406   uint256 public  MAX_MINTS_PER_TX = 1;
1407   uint256 public  PUBLIC_SALE_PRICE = 0.00 ether;
1408   uint256 public  NUM_FREE_MINTS = 888;
1409   uint256 public  MAX_FREE_PER_WALLET = 1;
1410   uint256 public freeNFTAlreadyMinted = 0;
1411   bool public isPublicSaleActive = false;
1412 
1413   constructor(
1414 
1415   ) ERC721A("MessageInABottle", "OpenMe") {
1416 
1417   }
1418 
1419 
1420   function mint(uint256 numberOfTokens)
1421       external
1422       payable
1423   {
1424     require(isPublicSaleActive, "Public sale is not open");
1425     require(totalSupply() + numberOfTokens < maxSupply + 1, "No more");
1426 
1427     if(freeNFTAlreadyMinted + numberOfTokens > NUM_FREE_MINTS){
1428         require(
1429             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1430             "Incorrect ETH value sent"
1431         );
1432     } else {
1433         if (balanceOf(msg.sender) + numberOfTokens > MAX_FREE_PER_WALLET) {
1434         require(
1435             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1436             "Incorrect ETH value sent"
1437         );
1438         require(
1439             numberOfTokens <= MAX_MINTS_PER_TX,
1440             "Max mints per transaction exceeded"
1441         );
1442         } else {
1443             require(
1444                 numberOfTokens <= MAX_FREE_PER_WALLET,
1445                 "Max mints per transaction exceeded"
1446             );
1447             freeNFTAlreadyMinted += numberOfTokens;
1448         }
1449     }
1450     _safeMint(msg.sender, numberOfTokens);
1451   }
1452 
1453   function setBaseURI(string memory baseURI)
1454     public
1455     onlyOwner
1456   {
1457     baseTokenURI = baseURI;
1458   }
1459 
1460   function treasuryMint(uint quantity)
1461     public
1462     onlyOwner
1463   {
1464     require(
1465       quantity > 0,
1466       "Invalid mint amount"
1467     );
1468     require(
1469       totalSupply() + quantity <= maxSupply,
1470       "Maximum supply exceeded"
1471     );
1472     _safeMint(msg.sender, quantity);
1473   }
1474 
1475   function withdraw()
1476     public
1477     onlyOwner
1478     nonReentrant
1479   {
1480     Address.sendValue(payable(msg.sender), address(this).balance);
1481   }
1482 
1483   function tokenURI(uint _tokenId)
1484     public
1485     view
1486     virtual
1487     override
1488     returns (string memory)
1489   {
1490     require(
1491       _exists(_tokenId),
1492       "ERC721Metadata: URI query for nonexistent token"
1493     );
1494     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1495   }
1496 
1497   function _baseURI()
1498     internal
1499     view
1500     virtual
1501     override
1502     returns (string memory)
1503   {
1504     return baseTokenURI;
1505   }
1506 
1507   function setIsPublicSaleActive(bool _isPublicSaleActive)
1508       external
1509       onlyOwner
1510   {
1511       isPublicSaleActive = _isPublicSaleActive;
1512   }
1513 
1514   function setNumFreeMints(uint256 _numfreemints)
1515       external
1516       onlyOwner
1517   {
1518       NUM_FREE_MINTS = _numfreemints;
1519   }
1520 
1521   function setSalePrice(uint256 _price)
1522       external
1523       onlyOwner
1524   {
1525       PUBLIC_SALE_PRICE = _price;
1526   }
1527 
1528   function setMaxLimitPerTransaction(uint256 _limit)
1529       external
1530       onlyOwner
1531   {
1532       MAX_MINTS_PER_TX = _limit;
1533   }
1534 
1535   function setFreeLimitPerWallet(uint256 _limit)
1536       external
1537       onlyOwner
1538   {
1539       MAX_FREE_PER_WALLET = _limit;
1540   }
1541 }