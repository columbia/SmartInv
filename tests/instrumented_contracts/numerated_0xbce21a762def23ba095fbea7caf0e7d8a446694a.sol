1 // MOOVCLUB Sneakers
2 // https://moov.club
3 // https://twitter.com/moovclub
4 // https://www.instagram.com/moov.club
5 // A brand by dotmoovs
6 
7 // File @openzeppelin/contracts/utils/Context.sol@v4.6.0
8 
9 // SPDX-License-Identifier: MIT
10 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev Provides information about the current execution context, including the
16  * sender of the transaction and its data. While these are generally available
17  * via msg.sender and msg.data, they should not be accessed in such a direct
18  * manner, since when dealing with meta-transactions the account sending and
19  * paying for execution may not be the actual sender (as far as an application
20  * is concerned).
21  *
22  * This contract is only required for intermediate, library-like contracts.
23  */
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes calldata) {
30         return msg.data;
31     }
32 }
33 
34 // File @openzeppelin/contracts/access/Ownable.sol@v4.6.0
35 
36 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
37 
38 pragma solidity ^0.8.0;
39 
40 /**
41  * @dev Contract module which provides a basic access control mechanism, where
42  * there is an account (an owner) that can be granted exclusive access to
43  * specific functions.
44  *
45  * By default, the owner account will be the one that deploys the contract. This
46  * can later be changed with {transferOwnership}.
47  *
48  * This module is used through inheritance. It will make available the modifier
49  * `onlyOwner`, which can be applied to your functions to restrict their use to
50  * the owner.
51  */
52 abstract contract Ownable is Context {
53     address private _owner;
54 
55     event OwnershipTransferred(
56         address indexed previousOwner,
57         address indexed newOwner
58     );
59 
60     /**
61      * @dev Initializes the contract setting the deployer as the initial owner.
62      */
63     constructor() {
64         _transferOwnership(_msgSender());
65     }
66 
67     /**
68      * @dev Returns the address of the current owner.
69      */
70     function owner() public view virtual returns (address) {
71         return _owner;
72     }
73 
74     /**
75      * @dev Throws if called by any account other than the owner.
76      */
77     modifier onlyOwner() {
78         require(owner() == _msgSender(), "Ownable: caller is not the owner");
79         _;
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(
99             newOwner != address(0),
100             "Ownable: new owner is the zero address"
101         );
102         _transferOwnership(newOwner);
103     }
104 
105     /**
106      * @dev Transfers ownership of the contract to a new account (`newOwner`).
107      * Internal function without access restriction.
108      */
109     function _transferOwnership(address newOwner) internal virtual {
110         address oldOwner = _owner;
111         _owner = newOwner;
112         emit OwnershipTransferred(oldOwner, newOwner);
113     }
114 }
115 
116 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.6.0
117 
118 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
119 
120 pragma solidity ^0.8.0;
121 
122 /**
123  * @dev Contract module that helps prevent reentrant calls to a function.
124  *
125  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
126  * available, which can be applied to functions to make sure there are no nested
127  * (reentrant) calls to them.
128  *
129  * Note that because there is a single `nonReentrant` guard, functions marked as
130  * `nonReentrant` may not call one another. This can be worked around by making
131  * those functions `private`, and then adding `external` `nonReentrant` entry
132  * points to them.
133  *
134  * TIP: If you would like to learn more about reentrancy and alternative ways
135  * to protect against it, check out our blog post
136  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
137  */
138 abstract contract ReentrancyGuard {
139     // Booleans are more expensive than uint256 or any type that takes up a full
140     // word because each write operation emits an extra SLOAD to first read the
141     // slot's contents, replace the bits taken up by the boolean, and then write
142     // back. This is the compiler's defense against contract upgrades and
143     // pointer aliasing, and it cannot be disabled.
144 
145     // The values being non-zero value makes deployment a bit more expensive,
146     // but in exchange the refund on every call to nonReentrant will be lower in
147     // amount. Since refunds are capped to a percentage of the total
148     // transaction's gas, it is best to keep them low in cases like this one, to
149     // increase the likelihood of the full refund coming into effect.
150     uint256 private constant _NOT_ENTERED = 1;
151     uint256 private constant _ENTERED = 2;
152 
153     uint256 private _status;
154 
155     constructor() {
156         _status = _NOT_ENTERED;
157     }
158 
159     /**
160      * @dev Prevents a contract from calling itself, directly or indirectly.
161      * Calling a `nonReentrant` function from another `nonReentrant`
162      * function is not supported. It is possible to prevent this from happening
163      * by making the `nonReentrant` function external, and making it call a
164      * `private` function that does the actual work.
165      */
166     modifier nonReentrant() {
167         // On the first call to nonReentrant, _notEntered will be true
168         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
169 
170         // Any calls to nonReentrant after this point will fail
171         _status = _ENTERED;
172 
173         _;
174 
175         // By storing the original value once again, a refund is triggered (see
176         // https://eips.ethereum.org/EIPS/eip-2200)
177         _status = _NOT_ENTERED;
178     }
179 }
180 
181 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.6.0
182 
183 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
184 
185 pragma solidity ^0.8.0;
186 
187 /**
188  * @dev Interface of the ERC165 standard, as defined in the
189  * https://eips.ethereum.org/EIPS/eip-165[EIP].
190  *
191  * Implementers can declare support of contract interfaces, which can then be
192  * queried by others ({ERC165Checker}).
193  *
194  * For an implementation, see {ERC165}.
195  */
196 interface IERC165 {
197     /**
198      * @dev Returns true if this contract implements the interface defined by
199      * `interfaceId`. See the corresponding
200      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
201      * to learn more about how these ids are created.
202      *
203      * This function call must use less than 30 000 gas.
204      */
205     function supportsInterface(bytes4 interfaceId) external view returns (bool);
206 }
207 
208 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.6.0
209 
210 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
211 
212 pragma solidity ^0.8.0;
213 
214 /**
215  * @dev Required interface of an ERC721 compliant contract.
216  */
217 interface IERC721 is IERC165 {
218     /**
219      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
220      */
221     event Transfer(
222         address indexed from,
223         address indexed to,
224         uint256 indexed tokenId
225     );
226 
227     /**
228      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
229      */
230     event Approval(
231         address indexed owner,
232         address indexed approved,
233         uint256 indexed tokenId
234     );
235 
236     /**
237      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
238      */
239     event ApprovalForAll(
240         address indexed owner,
241         address indexed operator,
242         bool approved
243     );
244 
245     /**
246      * @dev Returns the number of tokens in ``owner``'s account.
247      */
248     function balanceOf(address owner) external view returns (uint256 balance);
249 
250     /**
251      * @dev Returns the owner of the `tokenId` token.
252      *
253      * Requirements:
254      *
255      * - `tokenId` must exist.
256      */
257     function ownerOf(uint256 tokenId) external view returns (address owner);
258 
259     /**
260      * @dev Safely transfers `tokenId` token from `from` to `to`.
261      *
262      * Requirements:
263      *
264      * - `from` cannot be the zero address.
265      * - `to` cannot be the zero address.
266      * - `tokenId` token must exist and be owned by `from`.
267      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
268      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
269      *
270      * Emits a {Transfer} event.
271      */
272     function safeTransferFrom(
273         address from,
274         address to,
275         uint256 tokenId,
276         bytes calldata data
277     ) external;
278 
279     /**
280      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
281      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
282      *
283      * Requirements:
284      *
285      * - `from` cannot be the zero address.
286      * - `to` cannot be the zero address.
287      * - `tokenId` token must exist and be owned by `from`.
288      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
289      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
290      *
291      * Emits a {Transfer} event.
292      */
293     function safeTransferFrom(
294         address from,
295         address to,
296         uint256 tokenId
297     ) external;
298 
299     /**
300      * @dev Transfers `tokenId` token from `from` to `to`.
301      *
302      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
303      *
304      * Requirements:
305      *
306      * - `from` cannot be the zero address.
307      * - `to` cannot be the zero address.
308      * - `tokenId` token must be owned by `from`.
309      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
310      *
311      * Emits a {Transfer} event.
312      */
313     function transferFrom(
314         address from,
315         address to,
316         uint256 tokenId
317     ) external;
318 
319     /**
320      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
321      * The approval is cleared when the token is transferred.
322      *
323      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
324      *
325      * Requirements:
326      *
327      * - The caller must own the token or be an approved operator.
328      * - `tokenId` must exist.
329      *
330      * Emits an {Approval} event.
331      */
332     function approve(address to, uint256 tokenId) external;
333 
334     /**
335      * @dev Approve or remove `operator` as an operator for the caller.
336      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
337      *
338      * Requirements:
339      *
340      * - The `operator` cannot be the caller.
341      *
342      * Emits an {ApprovalForAll} event.
343      */
344     function setApprovalForAll(address operator, bool _approved) external;
345 
346     /**
347      * @dev Returns the account approved for `tokenId` token.
348      *
349      * Requirements:
350      *
351      * - `tokenId` must exist.
352      */
353     function getApproved(uint256 tokenId)
354         external
355         view
356         returns (address operator);
357 
358     /**
359      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
360      *
361      * See {setApprovalForAll}
362      */
363     function isApprovedForAll(address owner, address operator)
364         external
365         view
366         returns (bool);
367 }
368 
369 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.6.0
370 
371 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
372 
373 pragma solidity ^0.8.0;
374 
375 /**
376  * @title ERC721 token receiver interface
377  * @dev Interface for any contract that wants to support safeTransfers
378  * from ERC721 asset contracts.
379  */
380 interface IERC721Receiver {
381     /**
382      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
383      * by `operator` from `from`, this function is called.
384      *
385      * It must return its Solidity selector to confirm the token transfer.
386      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
387      *
388      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
389      */
390     function onERC721Received(
391         address operator,
392         address from,
393         uint256 tokenId,
394         bytes calldata data
395     ) external returns (bytes4);
396 }
397 
398 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.6.0
399 
400 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
401 
402 pragma solidity ^0.8.0;
403 
404 /**
405  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
406  * @dev See https://eips.ethereum.org/EIPS/eip-721
407  */
408 interface IERC721Metadata is IERC721 {
409     /**
410      * @dev Returns the token collection name.
411      */
412     function name() external view returns (string memory);
413 
414     /**
415      * @dev Returns the token collection symbol.
416      */
417     function symbol() external view returns (string memory);
418 
419     /**
420      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
421      */
422     function tokenURI(uint256 tokenId) external view returns (string memory);
423 }
424 
425 // File @openzeppelin/contracts/utils/Address.sol@v4.6.0
426 
427 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
428 
429 pragma solidity ^0.8.1;
430 
431 /**
432  * @dev Collection of functions related to the address type
433  */
434 library Address {
435     /**
436      * @dev Returns true if `account` is a contract.
437      *
438      * [IMPORTANT]
439      * ====
440      * It is unsafe to assume that an address for which this function returns
441      * false is an externally-owned account (EOA) and not a contract.
442      *
443      * Among others, `isContract` will return false for the following
444      * types of addresses:
445      *
446      *  - an externally-owned account
447      *  - a contract in construction
448      *  - an address where a contract will be created
449      *  - an address where a contract lived, but was destroyed
450      * ====
451      *
452      * [IMPORTANT]
453      * ====
454      * You shouldn't rely on `isContract` to protect against flash loan attacks!
455      *
456      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
457      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
458      * constructor.
459      * ====
460      */
461     function isContract(address account) internal view returns (bool) {
462         // This method relies on extcodesize/address.code.length, which returns 0
463         // for contracts in construction, since the code is only stored at the end
464         // of the constructor execution.
465 
466         return account.code.length > 0;
467     }
468 
469     /**
470      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
471      * `recipient`, forwarding all available gas and reverting on errors.
472      *
473      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
474      * of certain opcodes, possibly making contracts go over the 2300 gas limit
475      * imposed by `transfer`, making them unable to receive funds via
476      * `transfer`. {sendValue} removes this limitation.
477      *
478      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
479      *
480      * IMPORTANT: because control is transferred to `recipient`, care must be
481      * taken to not create reentrancy vulnerabilities. Consider using
482      * {ReentrancyGuard} or the
483      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
484      */
485     function sendValue(address payable recipient, uint256 amount) internal {
486         require(
487             address(this).balance >= amount,
488             "Address: insufficient balance"
489         );
490 
491         (bool success, ) = recipient.call{value: amount}("");
492         require(
493             success,
494             "Address: unable to send value, recipient may have reverted"
495         );
496     }
497 
498     /**
499      * @dev Performs a Solidity function call using a low level `call`. A
500      * plain `call` is an unsafe replacement for a function call: use this
501      * function instead.
502      *
503      * If `target` reverts with a revert reason, it is bubbled up by this
504      * function (like regular Solidity function calls).
505      *
506      * Returns the raw returned data. To convert to the expected return value,
507      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
508      *
509      * Requirements:
510      *
511      * - `target` must be a contract.
512      * - calling `target` with `data` must not revert.
513      *
514      * _Available since v3.1._
515      */
516     function functionCall(address target, bytes memory data)
517         internal
518         returns (bytes memory)
519     {
520         return functionCall(target, data, "Address: low-level call failed");
521     }
522 
523     /**
524      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
525      * `errorMessage` as a fallback revert reason when `target` reverts.
526      *
527      * _Available since v3.1._
528      */
529     function functionCall(
530         address target,
531         bytes memory data,
532         string memory errorMessage
533     ) internal returns (bytes memory) {
534         return functionCallWithValue(target, data, 0, errorMessage);
535     }
536 
537     /**
538      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
539      * but also transferring `value` wei to `target`.
540      *
541      * Requirements:
542      *
543      * - the calling contract must have an ETH balance of at least `value`.
544      * - the called Solidity function must be `payable`.
545      *
546      * _Available since v3.1._
547      */
548     function functionCallWithValue(
549         address target,
550         bytes memory data,
551         uint256 value
552     ) internal returns (bytes memory) {
553         return
554             functionCallWithValue(
555                 target,
556                 data,
557                 value,
558                 "Address: low-level call with value failed"
559             );
560     }
561 
562     /**
563      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
564      * with `errorMessage` as a fallback revert reason when `target` reverts.
565      *
566      * _Available since v3.1._
567      */
568     function functionCallWithValue(
569         address target,
570         bytes memory data,
571         uint256 value,
572         string memory errorMessage
573     ) internal returns (bytes memory) {
574         require(
575             address(this).balance >= value,
576             "Address: insufficient balance for call"
577         );
578         require(isContract(target), "Address: call to non-contract");
579 
580         (bool success, bytes memory returndata) = target.call{value: value}(
581             data
582         );
583         return verifyCallResult(success, returndata, errorMessage);
584     }
585 
586     /**
587      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
588      * but performing a static call.
589      *
590      * _Available since v3.3._
591      */
592     function functionStaticCall(address target, bytes memory data)
593         internal
594         view
595         returns (bytes memory)
596     {
597         return
598             functionStaticCall(
599                 target,
600                 data,
601                 "Address: low-level static call failed"
602             );
603     }
604 
605     /**
606      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
607      * but performing a static call.
608      *
609      * _Available since v3.3._
610      */
611     function functionStaticCall(
612         address target,
613         bytes memory data,
614         string memory errorMessage
615     ) internal view returns (bytes memory) {
616         require(isContract(target), "Address: static call to non-contract");
617 
618         (bool success, bytes memory returndata) = target.staticcall(data);
619         return verifyCallResult(success, returndata, errorMessage);
620     }
621 
622     /**
623      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
624      * but performing a delegate call.
625      *
626      * _Available since v3.4._
627      */
628     function functionDelegateCall(address target, bytes memory data)
629         internal
630         returns (bytes memory)
631     {
632         return
633             functionDelegateCall(
634                 target,
635                 data,
636                 "Address: low-level delegate call failed"
637             );
638     }
639 
640     /**
641      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
642      * but performing a delegate call.
643      *
644      * _Available since v3.4._
645      */
646     function functionDelegateCall(
647         address target,
648         bytes memory data,
649         string memory errorMessage
650     ) internal returns (bytes memory) {
651         require(isContract(target), "Address: delegate call to non-contract");
652 
653         (bool success, bytes memory returndata) = target.delegatecall(data);
654         return verifyCallResult(success, returndata, errorMessage);
655     }
656 
657     /**
658      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
659      * revert reason using the provided one.
660      *
661      * _Available since v4.3._
662      */
663     function verifyCallResult(
664         bool success,
665         bytes memory returndata,
666         string memory errorMessage
667     ) internal pure returns (bytes memory) {
668         if (success) {
669             return returndata;
670         } else {
671             // Look for revert reason and bubble it up if present
672             if (returndata.length > 0) {
673                 // The easiest way to bubble the revert reason is using memory via assembly
674 
675                 assembly {
676                     let returndata_size := mload(returndata)
677                     revert(add(32, returndata), returndata_size)
678                 }
679             } else {
680                 revert(errorMessage);
681             }
682         }
683     }
684 }
685 
686 // File @openzeppelin/contracts/utils/Strings.sol@v4.6.0
687 
688 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
689 
690 pragma solidity ^0.8.0;
691 
692 /**
693  * @dev String operations.
694  */
695 library Strings {
696     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
697 
698     /**
699      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
700      */
701     function toString(uint256 value) internal pure returns (string memory) {
702         // Inspired by OraclizeAPI's implementation - MIT licence
703         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
704 
705         if (value == 0) {
706             return "0";
707         }
708         uint256 temp = value;
709         uint256 digits;
710         while (temp != 0) {
711             digits++;
712             temp /= 10;
713         }
714         bytes memory buffer = new bytes(digits);
715         while (value != 0) {
716             digits -= 1;
717             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
718             value /= 10;
719         }
720         return string(buffer);
721     }
722 
723     /**
724      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
725      */
726     function toHexString(uint256 value) internal pure returns (string memory) {
727         if (value == 0) {
728             return "0x00";
729         }
730         uint256 temp = value;
731         uint256 length = 0;
732         while (temp != 0) {
733             length++;
734             temp >>= 8;
735         }
736         return toHexString(value, length);
737     }
738 
739     /**
740      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
741      */
742     function toHexString(uint256 value, uint256 length)
743         internal
744         pure
745         returns (string memory)
746     {
747         bytes memory buffer = new bytes(2 * length + 2);
748         buffer[0] = "0";
749         buffer[1] = "x";
750         for (uint256 i = 2 * length + 1; i > 1; --i) {
751             buffer[i] = _HEX_SYMBOLS[value & 0xf];
752             value >>= 4;
753         }
754         require(value == 0, "Strings: hex length insufficient");
755         return string(buffer);
756     }
757 }
758 
759 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.6.0
760 
761 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
762 
763 pragma solidity ^0.8.0;
764 
765 /**
766  * @dev Implementation of the {IERC165} interface.
767  *
768  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
769  * for the additional interface id that will be supported. For example:
770  *
771  * ```solidity
772  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
773  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
774  * }
775  * ```
776  *
777  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
778  */
779 abstract contract ERC165 is IERC165 {
780     /**
781      * @dev See {IERC165-supportsInterface}.
782      */
783     function supportsInterface(bytes4 interfaceId)
784         public
785         view
786         virtual
787         override
788         returns (bool)
789     {
790         return interfaceId == type(IERC165).interfaceId;
791     }
792 }
793 
794 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.6.0
795 
796 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
797 
798 pragma solidity ^0.8.0;
799 
800 /**
801  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
802  * the Metadata extension, but not including the Enumerable extension, which is available separately as
803  * {ERC721Enumerable}.
804  */
805 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
806     using Address for address;
807     using Strings for uint256;
808 
809     // Token name
810     string private _name;
811 
812     // Token symbol
813     string private _symbol;
814 
815     // Mapping from token ID to owner address
816     mapping(uint256 => address) private _owners;
817 
818     // Mapping owner address to token count
819     mapping(address => uint256) private _balances;
820 
821     // Mapping from token ID to approved address
822     mapping(uint256 => address) private _tokenApprovals;
823 
824     // Mapping from owner to operator approvals
825     mapping(address => mapping(address => bool)) private _operatorApprovals;
826 
827     /**
828      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
829      */
830     constructor(string memory name_, string memory symbol_) {
831         _name = name_;
832         _symbol = symbol_;
833     }
834 
835     /**
836      * @dev See {IERC165-supportsInterface}.
837      */
838     function supportsInterface(bytes4 interfaceId)
839         public
840         view
841         virtual
842         override(ERC165, IERC165)
843         returns (bool)
844     {
845         return
846             interfaceId == type(IERC721).interfaceId ||
847             interfaceId == type(IERC721Metadata).interfaceId ||
848             super.supportsInterface(interfaceId);
849     }
850 
851     /**
852      * @dev See {IERC721-balanceOf}.
853      */
854     function balanceOf(address owner)
855         public
856         view
857         virtual
858         override
859         returns (uint256)
860     {
861         require(
862             owner != address(0),
863             "ERC721: balance query for the zero address"
864         );
865         return _balances[owner];
866     }
867 
868     /**
869      * @dev See {IERC721-ownerOf}.
870      */
871     function ownerOf(uint256 tokenId)
872         public
873         view
874         virtual
875         override
876         returns (address)
877     {
878         address owner = _owners[tokenId];
879         require(
880             owner != address(0),
881             "ERC721: owner query for nonexistent token"
882         );
883         return owner;
884     }
885 
886     /**
887      * @dev See {IERC721Metadata-name}.
888      */
889     function name() public view virtual override returns (string memory) {
890         return _name;
891     }
892 
893     /**
894      * @dev See {IERC721Metadata-symbol}.
895      */
896     function symbol() public view virtual override returns (string memory) {
897         return _symbol;
898     }
899 
900     /**
901      * @dev See {IERC721Metadata-tokenURI}.
902      */
903     function tokenURI(uint256 tokenId)
904         public
905         view
906         virtual
907         override
908         returns (string memory)
909     {
910         require(
911             _exists(tokenId),
912             "ERC721Metadata: URI query for nonexistent token"
913         );
914 
915         string memory baseURI = _baseURI();
916         return
917             bytes(baseURI).length > 0
918                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
919                 : "";
920     }
921 
922     /**
923      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
924      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
925      * by default, can be overridden in child contracts.
926      */
927     function _baseURI() internal view virtual returns (string memory) {
928         return "";
929     }
930 
931     /**
932      * @dev See {IERC721-approve}.
933      */
934     function approve(address to, uint256 tokenId) public virtual override {
935         address owner = ERC721.ownerOf(tokenId);
936         require(to != owner, "ERC721: approval to current owner");
937 
938         require(
939             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
940             "ERC721: approve caller is not owner nor approved for all"
941         );
942 
943         _approve(to, tokenId);
944     }
945 
946     /**
947      * @dev See {IERC721-getApproved}.
948      */
949     function getApproved(uint256 tokenId)
950         public
951         view
952         virtual
953         override
954         returns (address)
955     {
956         require(
957             _exists(tokenId),
958             "ERC721: approved query for nonexistent token"
959         );
960 
961         return _tokenApprovals[tokenId];
962     }
963 
964     /**
965      * @dev See {IERC721-setApprovalForAll}.
966      */
967     function setApprovalForAll(address operator, bool approved)
968         public
969         virtual
970         override
971     {
972         _setApprovalForAll(_msgSender(), operator, approved);
973     }
974 
975     /**
976      * @dev See {IERC721-isApprovedForAll}.
977      */
978     function isApprovedForAll(address owner, address operator)
979         public
980         view
981         virtual
982         override
983         returns (bool)
984     {
985         return _operatorApprovals[owner][operator];
986     }
987 
988     /**
989      * @dev See {IERC721-transferFrom}.
990      */
991     function transferFrom(
992         address from,
993         address to,
994         uint256 tokenId
995     ) public virtual override {
996         //solhint-disable-next-line max-line-length
997         require(
998             _isApprovedOrOwner(_msgSender(), tokenId),
999             "ERC721: transfer caller is not owner nor approved"
1000         );
1001 
1002         _transfer(from, to, tokenId);
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-safeTransferFrom}.
1007      */
1008     function safeTransferFrom(
1009         address from,
1010         address to,
1011         uint256 tokenId
1012     ) public virtual override {
1013         safeTransferFrom(from, to, tokenId, "");
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-safeTransferFrom}.
1018      */
1019     function safeTransferFrom(
1020         address from,
1021         address to,
1022         uint256 tokenId,
1023         bytes memory _data
1024     ) public virtual override {
1025         require(
1026             _isApprovedOrOwner(_msgSender(), tokenId),
1027             "ERC721: transfer caller is not owner nor approved"
1028         );
1029         _safeTransfer(from, to, tokenId, _data);
1030     }
1031 
1032     /**
1033      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1034      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1035      *
1036      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1037      *
1038      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1039      * implement alternative mechanisms to perform token transfer, such as signature-based.
1040      *
1041      * Requirements:
1042      *
1043      * - `from` cannot be the zero address.
1044      * - `to` cannot be the zero address.
1045      * - `tokenId` token must exist and be owned by `from`.
1046      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1047      *
1048      * Emits a {Transfer} event.
1049      */
1050     function _safeTransfer(
1051         address from,
1052         address to,
1053         uint256 tokenId,
1054         bytes memory _data
1055     ) internal virtual {
1056         _transfer(from, to, tokenId);
1057         require(
1058             _checkOnERC721Received(from, to, tokenId, _data),
1059             "ERC721: transfer to non ERC721Receiver implementer"
1060         );
1061     }
1062 
1063     /**
1064      * @dev Returns whether `tokenId` exists.
1065      *
1066      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1067      *
1068      * Tokens start existing when they are minted (`_mint`),
1069      * and stop existing when they are burned (`_burn`).
1070      */
1071     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1072         return _owners[tokenId] != address(0);
1073     }
1074 
1075     /**
1076      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1077      *
1078      * Requirements:
1079      *
1080      * - `tokenId` must exist.
1081      */
1082     function _isApprovedOrOwner(address spender, uint256 tokenId)
1083         internal
1084         view
1085         virtual
1086         returns (bool)
1087     {
1088         require(
1089             _exists(tokenId),
1090             "ERC721: operator query for nonexistent token"
1091         );
1092         address owner = ERC721.ownerOf(tokenId);
1093         return (spender == owner ||
1094             isApprovedForAll(owner, spender) ||
1095             getApproved(tokenId) == spender);
1096     }
1097 
1098     /**
1099      * @dev Safely mints `tokenId` and transfers it to `to`.
1100      *
1101      * Requirements:
1102      *
1103      * - `tokenId` must not exist.
1104      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1105      *
1106      * Emits a {Transfer} event.
1107      */
1108     function _safeMint(address to, uint256 tokenId) internal virtual {
1109         _safeMint(to, tokenId, "");
1110     }
1111 
1112     /**
1113      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1114      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1115      */
1116     function _safeMint(
1117         address to,
1118         uint256 tokenId,
1119         bytes memory _data
1120     ) internal virtual {
1121         _mint(to, tokenId);
1122         require(
1123             _checkOnERC721Received(address(0), to, tokenId, _data),
1124             "ERC721: transfer to non ERC721Receiver implementer"
1125         );
1126     }
1127 
1128     /**
1129      * @dev Mints `tokenId` and transfers it to `to`.
1130      *
1131      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1132      *
1133      * Requirements:
1134      *
1135      * - `tokenId` must not exist.
1136      * - `to` cannot be the zero address.
1137      *
1138      * Emits a {Transfer} event.
1139      */
1140     function _mint(address to, uint256 tokenId) internal virtual {
1141         require(to != address(0), "ERC721: mint to the zero address");
1142         require(!_exists(tokenId), "ERC721: token already minted");
1143 
1144         _beforeTokenTransfer(address(0), to, tokenId);
1145 
1146         _balances[to] += 1;
1147         _owners[tokenId] = to;
1148 
1149         emit Transfer(address(0), to, tokenId);
1150 
1151         _afterTokenTransfer(address(0), to, tokenId);
1152     }
1153 
1154     /**
1155      * @dev Destroys `tokenId`.
1156      * The approval is cleared when the token is burned.
1157      *
1158      * Requirements:
1159      *
1160      * - `tokenId` must exist.
1161      *
1162      * Emits a {Transfer} event.
1163      */
1164     function _burn(uint256 tokenId) internal virtual {
1165         address owner = ERC721.ownerOf(tokenId);
1166 
1167         _beforeTokenTransfer(owner, address(0), tokenId);
1168 
1169         // Clear approvals
1170         _approve(address(0), tokenId);
1171 
1172         _balances[owner] -= 1;
1173         delete _owners[tokenId];
1174 
1175         emit Transfer(owner, address(0), tokenId);
1176 
1177         _afterTokenTransfer(owner, address(0), tokenId);
1178     }
1179 
1180     /**
1181      * @dev Transfers `tokenId` from `from` to `to`.
1182      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1183      *
1184      * Requirements:
1185      *
1186      * - `to` cannot be the zero address.
1187      * - `tokenId` token must be owned by `from`.
1188      *
1189      * Emits a {Transfer} event.
1190      */
1191     function _transfer(
1192         address from,
1193         address to,
1194         uint256 tokenId
1195     ) internal virtual {
1196         require(
1197             ERC721.ownerOf(tokenId) == from,
1198             "ERC721: transfer from incorrect owner"
1199         );
1200         require(to != address(0), "ERC721: transfer to the zero address");
1201 
1202         _beforeTokenTransfer(from, to, tokenId);
1203 
1204         // Clear approvals from the previous owner
1205         _approve(address(0), tokenId);
1206 
1207         _balances[from] -= 1;
1208         _balances[to] += 1;
1209         _owners[tokenId] = to;
1210 
1211         emit Transfer(from, to, tokenId);
1212 
1213         _afterTokenTransfer(from, to, tokenId);
1214     }
1215 
1216     /**
1217      * @dev Approve `to` to operate on `tokenId`
1218      *
1219      * Emits a {Approval} event.
1220      */
1221     function _approve(address to, uint256 tokenId) internal virtual {
1222         _tokenApprovals[tokenId] = to;
1223         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1224     }
1225 
1226     /**
1227      * @dev Approve `operator` to operate on all of `owner` tokens
1228      *
1229      * Emits a {ApprovalForAll} event.
1230      */
1231     function _setApprovalForAll(
1232         address owner,
1233         address operator,
1234         bool approved
1235     ) internal virtual {
1236         require(owner != operator, "ERC721: approve to caller");
1237         _operatorApprovals[owner][operator] = approved;
1238         emit ApprovalForAll(owner, operator, approved);
1239     }
1240 
1241     /**
1242      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1243      * The call is not executed if the target address is not a contract.
1244      *
1245      * @param from address representing the previous owner of the given token ID
1246      * @param to target address that will receive the tokens
1247      * @param tokenId uint256 ID of the token to be transferred
1248      * @param _data bytes optional data to send along with the call
1249      * @return bool whether the call correctly returned the expected magic value
1250      */
1251     function _checkOnERC721Received(
1252         address from,
1253         address to,
1254         uint256 tokenId,
1255         bytes memory _data
1256     ) private returns (bool) {
1257         if (to.isContract()) {
1258             try
1259                 IERC721Receiver(to).onERC721Received(
1260                     _msgSender(),
1261                     from,
1262                     tokenId,
1263                     _data
1264                 )
1265             returns (bytes4 retval) {
1266                 return retval == IERC721Receiver.onERC721Received.selector;
1267             } catch (bytes memory reason) {
1268                 if (reason.length == 0) {
1269                     revert(
1270                         "ERC721: transfer to non ERC721Receiver implementer"
1271                     );
1272                 } else {
1273                     assembly {
1274                         revert(add(32, reason), mload(reason))
1275                     }
1276                 }
1277             }
1278         } else {
1279             return true;
1280         }
1281     }
1282 
1283     /**
1284      * @dev Hook that is called before any token transfer. This includes minting
1285      * and burning.
1286      *
1287      * Calling conditions:
1288      *
1289      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1290      * transferred to `to`.
1291      * - When `from` is zero, `tokenId` will be minted for `to`.
1292      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1293      * - `from` and `to` are never both zero.
1294      *
1295      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1296      */
1297     function _beforeTokenTransfer(
1298         address from,
1299         address to,
1300         uint256 tokenId
1301     ) internal virtual {}
1302 
1303     /**
1304      * @dev Hook that is called after any transfer of tokens. This includes
1305      * minting and burning.
1306      *
1307      * Calling conditions:
1308      *
1309      * - when `from` and `to` are both non-zero.
1310      * - `from` and `to` are never both zero.
1311      *
1312      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1313      */
1314     function _afterTokenTransfer(
1315         address from,
1316         address to,
1317         uint256 tokenId
1318     ) internal virtual {}
1319 }
1320 
1321 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol@v4.6.0
1322 
1323 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Burnable.sol)
1324 
1325 pragma solidity ^0.8.0;
1326 
1327 /**
1328  * @title ERC721 Burnable Token
1329  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1330  */
1331 abstract contract ERC721Burnable is Context, ERC721 {
1332     /**
1333      * @dev Burns `tokenId`. See {ERC721-_burn}.
1334      *
1335      * Requirements:
1336      *
1337      * - The caller must own `tokenId` or be an approved operator.
1338      */
1339     function burn(uint256 tokenId) public virtual {
1340         //solhint-disable-next-line max-line-length
1341         require(
1342             _isApprovedOrOwner(_msgSender(), tokenId),
1343             "ERC721Burnable: caller is not owner nor approved"
1344         );
1345         _burn(tokenId);
1346     }
1347 }
1348 
1349 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.6.0
1350 
1351 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
1352 
1353 pragma solidity ^0.8.0;
1354 
1355 /**
1356  * @dev These functions deal with verification of Merkle Trees proofs.
1357  *
1358  * The proofs can be generated using the JavaScript library
1359  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1360  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1361  *
1362  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1363  *
1364  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1365  * hashing, or use a hash function other than keccak256 for hashing leaves.
1366  * This is because the concatenation of a sorted pair of internal nodes in
1367  * the merkle tree could be reinterpreted as a leaf value.
1368  */
1369 library MerkleProof {
1370     /**
1371      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1372      * defined by `root`. For this, a `proof` must be provided, containing
1373      * sibling hashes on the branch from the leaf to the root of the tree. Each
1374      * pair of leaves and each pair of pre-images are assumed to be sorted.
1375      */
1376     function verify(
1377         bytes32[] memory proof,
1378         bytes32 root,
1379         bytes32 leaf
1380     ) internal pure returns (bool) {
1381         return processProof(proof, leaf) == root;
1382     }
1383 
1384     /**
1385      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1386      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1387      * hash matches the root of the tree. When processing the proof, the pairs
1388      * of leafs & pre-images are assumed to be sorted.
1389      *
1390      * _Available since v4.4._
1391      */
1392     function processProof(bytes32[] memory proof, bytes32 leaf)
1393         internal
1394         pure
1395         returns (bytes32)
1396     {
1397         bytes32 computedHash = leaf;
1398         for (uint256 i = 0; i < proof.length; i++) {
1399             bytes32 proofElement = proof[i];
1400             if (computedHash <= proofElement) {
1401                 // Hash(current computed hash + current element of the proof)
1402                 computedHash = _efficientHash(computedHash, proofElement);
1403             } else {
1404                 // Hash(current element of the proof + current computed hash)
1405                 computedHash = _efficientHash(proofElement, computedHash);
1406             }
1407         }
1408         return computedHash;
1409     }
1410 
1411     function _efficientHash(bytes32 a, bytes32 b)
1412         private
1413         pure
1414         returns (bytes32 value)
1415     {
1416         assembly {
1417             mstore(0x00, a)
1418             mstore(0x20, b)
1419             value := keccak256(0x00, 0x40)
1420         }
1421     }
1422 }
1423 
1424 // File contracts/helpers/ContextMixin.sol
1425 
1426 pragma solidity ^0.8.14;
1427 
1428 /**
1429  * https://github.com/maticnetwork/pos-portal/blob/master/contracts/common/ContextMixin.sol
1430  */
1431 abstract contract ContextMixin {
1432     function msgSender() internal view returns (address payable sender) {
1433         if (msg.sender == address(this)) {
1434             bytes memory array = msg.data;
1435             uint256 index = msg.data.length;
1436             assembly {
1437                 // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
1438                 sender := and(
1439                     mload(add(array, index)),
1440                     0xffffffffffffffffffffffffffffffffffffffff
1441                 )
1442             }
1443         } else {
1444             sender = payable(msg.sender);
1445         }
1446         return sender;
1447     }
1448 }
1449 
1450 // File contracts/helpers/Initializable.sol
1451 
1452 pragma solidity ^0.8.14;
1453 
1454 /**
1455  * https://github.com/maticnetwork/pos-portal/blob/master/contracts/common/Initializable.sol
1456  */
1457 contract Initializable {
1458     bool inited = false;
1459 
1460     modifier initializer() {
1461         require(!inited, "already inited");
1462         _;
1463         inited = true;
1464     }
1465 }
1466 
1467 // File contracts/helpers/EIP712Base.sol
1468 
1469 pragma solidity ^0.8.14;
1470 
1471 /**
1472  * https://github.com/maticnetwork/pos-portal/blob/master/contracts/common/EIP712Base.sol
1473  */
1474 contract EIP712Base is Initializable {
1475     struct EIP712Domain {
1476         string name;
1477         string version;
1478         address verifyingContract;
1479         bytes32 salt;
1480     }
1481 
1482     string public constant ERC712_VERSION = "1";
1483 
1484     bytes32 internal constant EIP712_DOMAIN_TYPEHASH =
1485         keccak256(
1486             bytes(
1487                 "EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)"
1488             )
1489         );
1490     bytes32 internal domainSeperator;
1491 
1492     // supposed to be called once while initializing.
1493     // one of the contractsa that inherits this contract follows proxy pattern
1494     // so it is not possible to do this in a constructor
1495     function _initializeEIP712(string memory name) internal initializer {
1496         _setDomainSeperator(name);
1497     }
1498 
1499     function _setDomainSeperator(string memory name) internal {
1500         domainSeperator = keccak256(
1501             abi.encode(
1502                 EIP712_DOMAIN_TYPEHASH,
1503                 keccak256(bytes(name)),
1504                 keccak256(bytes(ERC712_VERSION)),
1505                 address(this),
1506                 bytes32(getChainId())
1507             )
1508         );
1509     }
1510 
1511     function getDomainSeperator() public view returns (bytes32) {
1512         return domainSeperator;
1513     }
1514 
1515     function getChainId() public view returns (uint256) {
1516         uint256 id;
1517         assembly {
1518             id := chainid()
1519         }
1520         return id;
1521     }
1522 
1523     /**
1524      * Accept message hash and returns hash message in EIP712 compatible form
1525      * So that it can be used to recover signer from signature signed using EIP712 formatted data
1526      * https://eips.ethereum.org/EIPS/eip-712
1527      * "\\x19" makes the encoding deterministic
1528      * "\\x01" is the version byte to make it compatible to EIP-191
1529      */
1530     function toTypedMessageHash(bytes32 messageHash)
1531         internal
1532         view
1533         returns (bytes32)
1534     {
1535         return
1536             keccak256(
1537                 abi.encodePacked("\x19\x01", getDomainSeperator(), messageHash)
1538             );
1539     }
1540 }
1541 
1542 // File contracts/helpers/NativeMetaTransaction.sol
1543 
1544 pragma solidity ^0.8.14;
1545 
1546 /**
1547  * https://github.com/maticnetwork/pos-portal/blob/master/contracts/common/NativeMetaTransaction.sol
1548  */
1549 contract NativeMetaTransaction is EIP712Base {
1550     bytes32 private constant META_TRANSACTION_TYPEHASH =
1551         keccak256(
1552             bytes(
1553                 "MetaTransaction(uint256 nonce,address from,bytes functionSignature)"
1554             )
1555         );
1556     event MetaTransactionExecuted(
1557         address userAddress,
1558         address payable relayerAddress,
1559         bytes functionSignature
1560     );
1561     mapping(address => uint256) nonces;
1562 
1563     /*
1564      * Meta transaction structure.
1565      * No point of including value field here as if user is doing value transfer then he has the funds to pay for gas
1566      * He should call the desired function directly in that case.
1567      */
1568     struct MetaTransaction {
1569         uint256 nonce;
1570         address from;
1571         bytes functionSignature;
1572     }
1573 
1574     function executeMetaTransaction(
1575         address userAddress,
1576         bytes memory functionSignature,
1577         bytes32 sigR,
1578         bytes32 sigS,
1579         uint8 sigV
1580     ) public payable returns (bytes memory) {
1581         MetaTransaction memory metaTx = MetaTransaction({
1582             nonce: nonces[userAddress],
1583             from: userAddress,
1584             functionSignature: functionSignature
1585         });
1586 
1587         require(
1588             verify(userAddress, metaTx, sigR, sigS, sigV),
1589             "Signer and signature do not match"
1590         );
1591 
1592         // increase nonce for user (to avoid re-use)
1593         nonces[userAddress] = nonces[userAddress] + 1;
1594 
1595         emit MetaTransactionExecuted(
1596             userAddress,
1597             payable(msg.sender),
1598             functionSignature
1599         );
1600 
1601         // Append userAddress and relayer address at the end to extract it from calling context
1602         (bool success, bytes memory returnData) = address(this).call(
1603             abi.encodePacked(functionSignature, userAddress)
1604         );
1605         require(success, "Function call not successful");
1606 
1607         return returnData;
1608     }
1609 
1610     function hashMetaTransaction(MetaTransaction memory metaTx)
1611         internal
1612         pure
1613         returns (bytes32)
1614     {
1615         return
1616             keccak256(
1617                 abi.encode(
1618                     META_TRANSACTION_TYPEHASH,
1619                     metaTx.nonce,
1620                     metaTx.from,
1621                     keccak256(metaTx.functionSignature)
1622                 )
1623             );
1624     }
1625 
1626     function getNonce(address user) public view returns (uint256 nonce) {
1627         nonce = nonces[user];
1628     }
1629 
1630     function verify(
1631         address signer,
1632         MetaTransaction memory metaTx,
1633         bytes32 sigR,
1634         bytes32 sigS,
1635         uint8 sigV
1636     ) internal view returns (bool) {
1637         require(signer != address(0), "NativeMetaTransaction: INVALID_SIGNER");
1638         return
1639             signer ==
1640             ecrecover(
1641                 toTypedMessageHash(hashMetaTransaction(metaTx)),
1642                 sigV,
1643                 sigR,
1644                 sigS
1645             );
1646     }
1647 }
1648 
1649 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.6.0
1650 
1651 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1652 
1653 pragma solidity ^0.8.0;
1654 
1655 /**
1656  * @dev Interface of the ERC20 standard as defined in the EIP.
1657  */
1658 interface IERC20 {
1659     /**
1660      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1661      * another (`to`).
1662      *
1663      * Note that `value` may be zero.
1664      */
1665     event Transfer(address indexed from, address indexed to, uint256 value);
1666 
1667     /**
1668      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1669      * a call to {approve}. `value` is the new allowance.
1670      */
1671     event Approval(
1672         address indexed owner,
1673         address indexed spender,
1674         uint256 value
1675     );
1676 
1677     /**
1678      * @dev Returns the amount of tokens in existence.
1679      */
1680     function totalSupply() external view returns (uint256);
1681 
1682     /**
1683      * @dev Returns the amount of tokens owned by `account`.
1684      */
1685     function balanceOf(address account) external view returns (uint256);
1686 
1687     /**
1688      * @dev Moves `amount` tokens from the caller's account to `to`.
1689      *
1690      * Returns a boolean value indicating whether the operation succeeded.
1691      *
1692      * Emits a {Transfer} event.
1693      */
1694     function transfer(address to, uint256 amount) external returns (bool);
1695 
1696     /**
1697      * @dev Returns the remaining number of tokens that `spender` will be
1698      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1699      * zero by default.
1700      *
1701      * This value changes when {approve} or {transferFrom} are called.
1702      */
1703     function allowance(address owner, address spender)
1704         external
1705         view
1706         returns (uint256);
1707 
1708     /**
1709      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1710      *
1711      * Returns a boolean value indicating whether the operation succeeded.
1712      *
1713      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1714      * that someone may use both the old and the new allowance by unfortunate
1715      * transaction ordering. One possible solution to mitigate this race
1716      * condition is to first reduce the spender's allowance to 0 and set the
1717      * desired value afterwards:
1718      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1719      *
1720      * Emits an {Approval} event.
1721      */
1722     function approve(address spender, uint256 amount) external returns (bool);
1723 
1724     /**
1725      * @dev Moves `amount` tokens from `from` to `to` using the
1726      * allowance mechanism. `amount` is then deducted from the caller's
1727      * allowance.
1728      *
1729      * Returns a boolean value indicating whether the operation succeeded.
1730      *
1731      * Emits a {Transfer} event.
1732      */
1733     function transferFrom(
1734         address from,
1735         address to,
1736         uint256 amount
1737     ) external returns (bool);
1738 }
1739 
1740 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.6.0
1741 
1742 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
1743 
1744 pragma solidity ^0.8.0;
1745 
1746 /**
1747  * @title SafeERC20
1748  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1749  * contract returns false). Tokens that return no value (and instead revert or
1750  * throw on failure) are also supported, non-reverting calls are assumed to be
1751  * successful.
1752  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1753  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1754  */
1755 library SafeERC20 {
1756     using Address for address;
1757 
1758     function safeTransfer(
1759         IERC20 token,
1760         address to,
1761         uint256 value
1762     ) internal {
1763         _callOptionalReturn(
1764             token,
1765             abi.encodeWithSelector(token.transfer.selector, to, value)
1766         );
1767     }
1768 
1769     function safeTransferFrom(
1770         IERC20 token,
1771         address from,
1772         address to,
1773         uint256 value
1774     ) internal {
1775         _callOptionalReturn(
1776             token,
1777             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
1778         );
1779     }
1780 
1781     /**
1782      * @dev Deprecated. This function has issues similar to the ones found in
1783      * {IERC20-approve}, and its usage is discouraged.
1784      *
1785      * Whenever possible, use {safeIncreaseAllowance} and
1786      * {safeDecreaseAllowance} instead.
1787      */
1788     function safeApprove(
1789         IERC20 token,
1790         address spender,
1791         uint256 value
1792     ) internal {
1793         // safeApprove should only be called when setting an initial allowance,
1794         // or when resetting it to zero. To increase and decrease it, use
1795         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1796         require(
1797             (value == 0) || (token.allowance(address(this), spender) == 0),
1798             "SafeERC20: approve from non-zero to non-zero allowance"
1799         );
1800         _callOptionalReturn(
1801             token,
1802             abi.encodeWithSelector(token.approve.selector, spender, value)
1803         );
1804     }
1805 
1806     function safeIncreaseAllowance(
1807         IERC20 token,
1808         address spender,
1809         uint256 value
1810     ) internal {
1811         uint256 newAllowance = token.allowance(address(this), spender) + value;
1812         _callOptionalReturn(
1813             token,
1814             abi.encodeWithSelector(
1815                 token.approve.selector,
1816                 spender,
1817                 newAllowance
1818             )
1819         );
1820     }
1821 
1822     function safeDecreaseAllowance(
1823         IERC20 token,
1824         address spender,
1825         uint256 value
1826     ) internal {
1827         unchecked {
1828             uint256 oldAllowance = token.allowance(address(this), spender);
1829             require(
1830                 oldAllowance >= value,
1831                 "SafeERC20: decreased allowance below zero"
1832             );
1833             uint256 newAllowance = oldAllowance - value;
1834             _callOptionalReturn(
1835                 token,
1836                 abi.encodeWithSelector(
1837                     token.approve.selector,
1838                     spender,
1839                     newAllowance
1840                 )
1841             );
1842         }
1843     }
1844 
1845     /**
1846      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1847      * on the return value: the return value is optional (but if data is returned, it must not be false).
1848      * @param token The token targeted by the call.
1849      * @param data The call data (encoded using abi.encode or one of its variants).
1850      */
1851     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1852         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1853         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1854         // the target address contains contract code and also asserts for success in the low-level call.
1855 
1856         bytes memory returndata = address(token).functionCall(
1857             data,
1858             "SafeERC20: low-level call failed"
1859         );
1860         if (returndata.length > 0) {
1861             // Return data is optional
1862             require(
1863                 abi.decode(returndata, (bool)),
1864                 "SafeERC20: ERC20 operation did not succeed"
1865             );
1866         }
1867     }
1868 }
1869 
1870 // File contracts/WhitelistStaking.sol
1871 
1872 pragma solidity ^0.8.14;
1873 
1874 contract WhitelistStaking {
1875     using SafeERC20 for IERC20;
1876 
1877     uint256 public constant STAKE_AMOUNT = 60_000 ether;
1878     uint256 public constant STAKE_DURATION = 90 days;
1879     uint256 public constant STAKE_DISABLE = 45 days;
1880     uint256 public STAKE_START;
1881 
1882     IERC20 private immutable mainToken;
1883 
1884     mapping(address => uint256) public stakingStart; // userAddress => stakingStartTimestamp
1885 
1886     constructor(IERC20 _tokenContract) {
1887         mainToken = _tokenContract;
1888         STAKE_START = block.timestamp;
1889     }
1890 
1891     event Stake(address indexed userAddress);
1892 
1893     // Deposit staking funds
1894     function stake() external {
1895         require(stakingStart[msg.sender] == 0, "User is already staking");
1896         require(
1897             block.timestamp <= STAKE_START + STAKE_DISABLE,
1898             "Staking is now disabled"
1899         );
1900 
1901         stakingStart[msg.sender] = block.timestamp;
1902 
1903         mainToken.safeTransferFrom(msg.sender, address(this), STAKE_AMOUNT);
1904 
1905         emit Stake(msg.sender);
1906     }
1907 
1908     event Unstake(address indexed userAddress);
1909 
1910     // Withdraw staking funds
1911     function unstake() external {
1912         uint256 stakingStartTimestamp = stakingStart[msg.sender];
1913         require(stakingStartTimestamp != 0, "User is not staking");
1914 
1915         require(
1916             block.timestamp >= stakingStartTimestamp + STAKE_DURATION,
1917             "Stake is still locked"
1918         );
1919 
1920         delete stakingStart[msg.sender];
1921 
1922         mainToken.safeTransfer(msg.sender, STAKE_AMOUNT);
1923 
1924         emit Unstake(msg.sender);
1925     }
1926 }
1927 
1928 // File contracts/MOOVCLUBSneakers.sol
1929 
1930 pragma solidity ^0.8.14;
1931 
1932 contract MOOVCLUBSneakers is
1933     ERC721Burnable,
1934     ContextMixin,
1935     NativeMetaTransaction,
1936     ReentrancyGuard,
1937     Ownable
1938 {
1939     uint256 public constant MAXIMUM_SUPPLY = 4444;
1940     uint256 public constant MAXIMUM_MINT_AMOUNT = 10;
1941     uint256 public constant OWNER_MINT_LIMIT = 200;
1942 
1943     uint256 public constant WHITELIST_MINT_TIMESTAMP = 1654704000; // 2022-06-08 16:00 UTC
1944     uint256 public constant PUBLIC_MINT_TIMESTAMP = 1654790400; // 2022-06-09 16:00 UTC
1945     uint256 public constant METADATA_TIMESTAMP = 1654876800; // 2022-06-10 16:00 UTC
1946 
1947     uint256 public constant PRICE_PUBLIC = 0.069 ether;
1948     uint256 public constant PRICE_MERKLE = 0.055 ether;
1949     uint256 public constant PRICE_STAKING = 0.050 ether;
1950 
1951     WhitelistStaking public constant stakingContract =
1952         WhitelistStaking(0x98f26C02e89a886F1445B166051BE59bB5aC1733);
1953 
1954     uint256 public unmintedSupply = MAXIMUM_SUPPLY;
1955     uint256 public ownerUnmintedSupply = OWNER_MINT_LIMIT;
1956 
1957     bytes32 public merkleRoot;
1958     string public metadataFolder; // '' or 'ipfs://Q.../'
1959 
1960     mapping(address => uint8) public amountMinted; // userAddress => amountMinted
1961 
1962     constructor(string memory _name, string memory _symbol)
1963         ERC721(_name, _symbol)
1964     {
1965         _initializeEIP712(_name);
1966     }
1967 
1968     /**
1969      ** Users
1970      */
1971 
1972     function mintPublic(uint8 _amount) external payable {
1973         require(block.timestamp >= PUBLIC_MINT_TIMESTAMP, "Not available yet");
1974 
1975         mintUser(_amount, PRICE_PUBLIC);
1976     }
1977 
1978     function mintMerkle(uint8 _amount, bytes32[] calldata proof)
1979         external
1980         payable
1981     {
1982         require(
1983             block.timestamp >= WHITELIST_MINT_TIMESTAMP,
1984             "Not available yet"
1985         );
1986         require(block.timestamp < PUBLIC_MINT_TIMESTAMP, "No longer available");
1987 
1988         require(
1989             MerkleProof.verify(
1990                 proof,
1991                 merkleRoot,
1992                 keccak256(abi.encodePacked(msg.sender))
1993             ),
1994             "User is not whitelisted"
1995         );
1996 
1997         mintUser(_amount, PRICE_MERKLE);
1998     }
1999 
2000     function mintStaking(uint8 _amount) external payable {
2001         require(
2002             block.timestamp >= WHITELIST_MINT_TIMESTAMP,
2003             "Not available yet"
2004         );
2005         require(block.timestamp < PUBLIC_MINT_TIMESTAMP, "No longer available");
2006 
2007         require(
2008             stakingContract.stakingStart(msg.sender) != 0,
2009             "User is not staking"
2010         );
2011 
2012         mintUser(_amount, PRICE_STAKING);
2013     }
2014 
2015     function mintUser(uint8 _amount, uint256 _price) private {
2016         require(_amount > 0, "Nothing to mint");
2017         require(msg.value == _amount * _price, "Invalid amount");
2018 
2019         uint8 newUserMinted = amountMinted[msg.sender] + _amount;
2020         require(
2021             newUserMinted <= MAXIMUM_MINT_AMOUNT,
2022             "User mint capacity reached"
2023         );
2024         amountMinted[msg.sender] = newUserMinted;
2025 
2026         mint(_amount);
2027     }
2028 
2029     function mint(uint8 _amount) private nonReentrant {
2030         uint256 previousUnmintedSupply = unmintedSupply;
2031         unmintedSupply = previousUnmintedSupply - _amount;
2032 
2033         uint256 mintedSupply = MAXIMUM_SUPPLY - previousUnmintedSupply;
2034         for (uint256 i = 0; i < _amount; i++) {
2035             uint256 tokenId = mintedSupply + i;
2036             _safeMint(msg.sender, tokenId);
2037         }
2038     }
2039 
2040     /**
2041      ** Owner
2042      */
2043 
2044     function withdraw() external onlyOwner {
2045         uint256 balance = address(this).balance;
2046         require(balance > 0, "Nothing to withdraw");
2047 
2048         payable(owner()).transfer(balance);
2049     }
2050 
2051     function mintOwner(uint8 _amount) external onlyOwner {
2052         ownerUnmintedSupply = ownerUnmintedSupply - _amount;
2053 
2054         mint(_amount);
2055     }
2056 
2057     function setMerkleRootFolder(bytes32 _merkleRoot) external onlyOwner {
2058         merkleRoot = _merkleRoot;
2059     }
2060 
2061     function setMetadataFolder(string calldata _metadataFolder)
2062         external
2063         onlyOwner
2064     {
2065         require(block.timestamp > METADATA_TIMESTAMP, "Not available yet");
2066         metadataFolder = _metadataFolder;
2067     }
2068 
2069     /**
2070      ** Standards
2071      */
2072 
2073     function tokenURI(uint256 _tokenId)
2074         public
2075         view
2076         override
2077         returns (string memory)
2078     {
2079         if (bytes(metadataFolder).length == 0) {
2080             return "ipfs://QmXHTJk3wC877bmujJKBDmeQRZ4unJYMVakv5zthVaws7T";
2081         }
2082 
2083         return
2084             string(
2085                 abi.encodePacked(
2086                     metadataFolder,
2087                     Strings.toString(_tokenId),
2088                     ".json"
2089                 )
2090             );
2091     }
2092 
2093     function _msgSender() internal view override returns (address) {
2094         return ContextMixin.msgSender();
2095     }
2096 }