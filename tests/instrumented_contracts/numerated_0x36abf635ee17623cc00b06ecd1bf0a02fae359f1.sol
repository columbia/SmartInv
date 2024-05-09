1 //SPDX-License-Identifier: MIT
2 // File: gist-270e50cc401a88221663666c2f449393/Strings.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length)
60         internal
61         pure
62         returns (string memory)
63     {
64         bytes memory buffer = new bytes(2 * length + 2);
65         buffer[0] = "0";
66         buffer[1] = "x";
67         for (uint256 i = 2 * length + 1; i > 1; --i) {
68             buffer[i] = _HEX_SYMBOLS[value & 0xf];
69             value >>= 4;
70         }
71         require(value == 0, "Strings: hex length insufficient");
72         return string(buffer);
73     }
74 }
75 
76 // File: gist-270e50cc401a88221663666c2f449393/Context.sol
77 
78 
79 pragma solidity ^0.8.0;
80 
81 /**
82  * @dev Provides information about the current execution context, including the
83  * sender of the transaction and its data. While these are generally available
84  * via msg.sender and msg.data, they should not be accessed in such a direct
85  * manner, since when dealing with meta-transactions the account sending and
86  * paying for execution may not be the actual sender (as far as an application
87  * is concerned).
88  *
89  * This contract is only required for intermediate, library-like contracts.
90  */
91 abstract contract Context {
92     function _msgSender() internal view virtual returns (address) {
93         return msg.sender;
94     }
95 
96     function _msgData() internal view virtual returns (bytes calldata) {
97         return msg.data;
98     }
99 }
100 
101 // File: gist-270e50cc401a88221663666c2f449393/Ownable.sol
102 
103 
104 pragma solidity ^0.8.0;
105 
106 
107 /**
108  * @dev Contract module which provides a basic access control mechanism, where
109  * there is an account (an owner) that can be granted exclusive access to
110  * specific functions.
111  *
112  * By default, the owner account will be the one that deploys the contract. This
113  * can later be changed with {transferOwnership}.
114  *
115  * This module is used through inheritance. It will make available the modifier
116  * `onlyOwner`, which can be applied to your functions to restrict their use to
117  * the owner.
118  */
119 abstract contract Ownable is Context {
120     address private _owner;
121 
122     event OwnershipTransferred(
123         address indexed previousOwner,
124         address indexed newOwner
125     );
126 
127     /**
128      * @dev Initializes the contract setting the deployer as the initial owner.
129      */
130     constructor() {
131         _transferOwnership(_msgSender());
132     }
133 
134     /**
135      * @dev Returns the address of the current owner.
136      */
137     function owner() public view virtual returns (address) {
138         return _owner;
139     }
140 
141     /**
142      * @dev Throws if called by any account other than the owner.
143      */
144     modifier onlyOwner() {
145         require(owner() == _msgSender(), "Ownable: caller is not the owner");
146         _;
147     }
148 
149     /**
150      * @dev Leaves the contract without owner. It will not be possible to call
151      * `onlyOwner` functions anymore. Can only be called by the current owner.
152      *
153      * NOTE: Renouncing ownership will leave the contract without an owner,
154      * thereby removing any functionality that is only available to the owner.
155      */
156     function renounceOwnership() public virtual onlyOwner {
157         _transferOwnership(address(0));
158     }
159 
160     /**
161      * @dev Transfers ownership of the contract to a new account (`newOwner`).
162      * Can only be called by the current owner.
163      */
164     function transferOwnership(address newOwner) public virtual onlyOwner {
165         require(
166             newOwner != address(0),
167             "Ownable: new owner is the zero address"
168         );
169         _transferOwnership(newOwner);
170     }
171 
172     /**
173      * @dev Transfers ownership of the contract to a new account (`newOwner`).
174      * Internal function without access restriction.
175      */
176     function _transferOwnership(address newOwner) internal virtual {
177         address oldOwner = _owner;
178         _owner = newOwner;
179         emit OwnershipTransferred(oldOwner, newOwner);
180     }
181 }
182 
183 // File: gist-270e50cc401a88221663666c2f449393/Address.sol
184 
185 
186 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
187 
188 pragma solidity ^0.8.1;
189 
190 /**
191  * @dev Collection of functions related to the address type
192  */
193 library Address {
194     /**
195      * @dev Returns true if `account` is a contract.
196      *
197      * [IMPORTANT]
198      * ====
199      * It is unsafe to assume that an address for which this function returns
200      * false is an externally-owned account (EOA) and not a contract.
201      *
202      * Among others, `isContract` will return false for the following
203      * types of addresses:
204      *
205      *  - an externally-owned account
206      *  - a contract in construction
207      *  - an address where a contract will be created
208      *  - an address where a contract lived, but was destroyed
209      * ====
210      *
211      * [IMPORTANT]
212      * ====
213      * You shouldn't rely on `isContract` to protect against flash loan attacks!
214      *
215      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
216      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
217      * constructor.
218      * ====
219      */
220     function isContract(address account) internal view returns (bool) {
221         // This method relies on extcodesize/address.code.length, which returns 0
222         // for contracts in construction, since the code is only stored at the end
223         // of the constructor execution.
224 
225         return account.code.length > 0;
226     }
227 
228     /**
229      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
230      * `recipient`, forwarding all available gas and reverting on errors.
231      *
232      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
233      * of certain opcodes, possibly making contracts go over the 2300 gas limit
234      * imposed by `transfer`, making them unable to receive funds via
235      * `transfer`. {sendValue} removes this limitation.
236      *
237      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
238      *
239      * IMPORTANT: because control is transferred to `recipient`, care must be
240      * taken to not create reentrancy vulnerabilities. Consider using
241      * {ReentrancyGuard} or the
242      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
243      */
244     function sendValue(address payable recipient, uint256 amount) internal {
245         require(
246             address(this).balance >= amount,
247             "Address: insufficient balance"
248         );
249 
250         (bool success, ) = recipient.call{value: amount}("");
251         require(
252             success,
253             "Address: unable to send value, recipient may have reverted"
254         );
255     }
256 
257     /**
258      * @dev Performs a Solidity function call using a low level `call`. A
259      * plain `call` is an unsafe replacement for a function call: use this
260      * function instead.
261      *
262      * If `target` reverts with a revert reason, it is bubbled up by this
263      * function (like regular Solidity function calls).
264      *
265      * Returns the raw returned data. To convert to the expected return value,
266      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
267      *
268      * Requirements:
269      *
270      * - `target` must be a contract.
271      * - calling `target` with `data` must not revert.
272      *
273      * _Available since v3.1._
274      */
275     function functionCall(address target, bytes memory data)
276         internal
277         returns (bytes memory)
278     {
279         return functionCall(target, data, "Address: low-level call failed");
280     }
281 
282     /**
283      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
284      * `errorMessage` as a fallback revert reason when `target` reverts.
285      *
286      * _Available since v3.1._
287      */
288     function functionCall(
289         address target,
290         bytes memory data,
291         string memory errorMessage
292     ) internal returns (bytes memory) {
293         return functionCallWithValue(target, data, 0, errorMessage);
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
298      * but also transferring `value` wei to `target`.
299      *
300      * Requirements:
301      *
302      * - the calling contract must have an ETH balance of at least `value`.
303      * - the called Solidity function must be `payable`.
304      *
305      * _Available since v3.1._
306      */
307     function functionCallWithValue(
308         address target,
309         bytes memory data,
310         uint256 value
311     ) internal returns (bytes memory) {
312         return
313             functionCallWithValue(
314                 target,
315                 data,
316                 value,
317                 "Address: low-level call with value failed"
318             );
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
323      * with `errorMessage` as a fallback revert reason when `target` reverts.
324      *
325      * _Available since v3.1._
326      */
327     function functionCallWithValue(
328         address target,
329         bytes memory data,
330         uint256 value,
331         string memory errorMessage
332     ) internal returns (bytes memory) {
333         require(
334             address(this).balance >= value,
335             "Address: insufficient balance for call"
336         );
337         require(isContract(target), "Address: call to non-contract");
338 
339         (bool success, bytes memory returndata) = target.call{value: value}(
340             data
341         );
342         return verifyCallResult(success, returndata, errorMessage);
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347      * but performing a static call.
348      *
349      * _Available since v3.3._
350      */
351     function functionStaticCall(address target, bytes memory data)
352         internal
353         view
354         returns (bytes memory)
355     {
356         return
357             functionStaticCall(
358                 target,
359                 data,
360                 "Address: low-level static call failed"
361             );
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
366      * but performing a static call.
367      *
368      * _Available since v3.3._
369      */
370     function functionStaticCall(
371         address target,
372         bytes memory data,
373         string memory errorMessage
374     ) internal view returns (bytes memory) {
375         require(isContract(target), "Address: static call to non-contract");
376 
377         (bool success, bytes memory returndata) = target.staticcall(data);
378         return verifyCallResult(success, returndata, errorMessage);
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
383      * but performing a delegate call.
384      *
385      * _Available since v3.4._
386      */
387     function functionDelegateCall(address target, bytes memory data)
388         internal
389         returns (bytes memory)
390     {
391         return
392             functionDelegateCall(
393                 target,
394                 data,
395                 "Address: low-level delegate call failed"
396             );
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
401      * but performing a delegate call.
402      *
403      * _Available since v3.4._
404      */
405     function functionDelegateCall(
406         address target,
407         bytes memory data,
408         string memory errorMessage
409     ) internal returns (bytes memory) {
410         require(isContract(target), "Address: delegate call to non-contract");
411 
412         (bool success, bytes memory returndata) = target.delegatecall(data);
413         return verifyCallResult(success, returndata, errorMessage);
414     }
415 
416     /**
417      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
418      * revert reason using the provided one.
419      *
420      * _Available since v4.3._
421      */
422     function verifyCallResult(
423         bool success,
424         bytes memory returndata,
425         string memory errorMessage
426     ) internal pure returns (bytes memory) {
427         if (success) {
428             return returndata;
429         } else {
430             // Look for revert reason and bubble it up if present
431             if (returndata.length > 0) {
432                 // The easiest way to bubble the revert reason is using memory via assembly
433 
434                 assembly {
435                     let returndata_size := mload(returndata)
436                     revert(add(32, returndata), returndata_size)
437                 }
438             } else {
439                 revert(errorMessage);
440             }
441         }
442     }
443 }
444 
445 // File: gist-270e50cc401a88221663666c2f449393/IERC721Receiver.sol
446 
447 
448 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
449 
450 pragma solidity ^0.8.0;
451 
452 /**
453  * @title ERC721 token receiver interface
454  * @dev Interface for any contract that wants to support safeTransfers
455  * from ERC721 asset contracts.
456  */
457 interface IERC721Receiver {
458     /**
459      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
460      * by `operator` from `from`, this function is called.
461      *
462      * It must return its Solidity selector to confirm the token transfer.
463      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
464      *
465      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
466      */
467     function onERC721Received(
468         address operator,
469         address from,
470         uint256 tokenId,
471         bytes calldata data
472     ) external returns (bytes4);
473 }
474 
475 // File: gist-270e50cc401a88221663666c2f449393/IERC165.sol
476 
477 
478 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
479 
480 pragma solidity ^0.8.0;
481 
482 /**
483  * @dev Interface of the ERC165 standard, as defined in the
484  * https://eips.ethereum.org/EIPS/eip-165[EIP].
485  *
486  * Implementers can declare support of contract interfaces, which can then be
487  * queried by others ({ERC165Checker}).
488  *
489  * For an implementation, see {ERC165}.
490  */
491 interface IERC165 {
492     /**
493      * @dev Returns true if this contract implements the interface defined by
494      * `interfaceId`. See the corresponding
495      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
496      * to learn more about how these ids are created.
497      *
498      * This function call must use less than 30 000 gas.
499      */
500     function supportsInterface(bytes4 interfaceId) external view returns (bool);
501 }
502 
503 // File: gist-270e50cc401a88221663666c2f449393/ERC165.sol
504 
505 
506 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
507 
508 pragma solidity ^0.8.0;
509 
510 
511 /**
512  * @dev Implementation of the {IERC165} interface.
513  *
514  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
515  * for the additional interface id that will be supported. For example:
516  *
517  * ```solidity
518  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
519  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
520  * }
521  * ```
522  *
523  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
524  */
525 abstract contract ERC165 is IERC165 {
526     /**
527      * @dev See {IERC165-supportsInterface}.
528      */
529     function supportsInterface(bytes4 interfaceId)
530         public
531         view
532         virtual
533         override
534         returns (bool)
535     {
536         return interfaceId == type(IERC165).interfaceId;
537     }
538 }
539 
540 // File: gist-270e50cc401a88221663666c2f449393/IERC721.sol
541 
542 
543 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
544 
545 pragma solidity ^0.8.0;
546 
547 
548 /**
549  * @dev Required interface of an ERC721 compliant contract.
550  */
551 interface IERC721 is IERC165 {
552     /**
553      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
554      */
555     event Transfer(
556         address indexed from,
557         address indexed to,
558         uint256 indexed tokenId
559     );
560 
561     /**
562      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
563      */
564     event Approval(
565         address indexed owner,
566         address indexed approved,
567         uint256 indexed tokenId
568     );
569 
570     /**
571      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
572      */
573     event ApprovalForAll(
574         address indexed owner,
575         address indexed operator,
576         bool approved
577     );
578 
579     /**
580      * @dev Returns the number of tokens in ``owner``'s account.
581      */
582     function balanceOf(address owner) external view returns (uint256 balance);
583 
584     /**
585      * @dev Returns the owner of the `tokenId` token.
586      *
587      * Requirements:
588      *
589      * - `tokenId` must exist.
590      */
591     function ownerOf(uint256 tokenId) external view returns (address owner);
592 
593     /**
594      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
595      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
596      *
597      * Requirements:
598      *
599      * - `from` cannot be the zero address.
600      * - `to` cannot be the zero address.
601      * - `tokenId` token must exist and be owned by `from`.
602      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
603      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
604      *
605      * Emits a {Transfer} event.
606      */
607     function safeTransferFrom(
608         address from,
609         address to,
610         uint256 tokenId
611     ) external;
612 
613     /**
614      * @dev Transfers `tokenId` token from `from` to `to`.
615      *
616      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
617      *
618      * Requirements:
619      *
620      * - `from` cannot be the zero address.
621      * - `to` cannot be the zero address.
622      * - `tokenId` token must be owned by `from`.
623      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
624      *
625      * Emits a {Transfer} event.
626      */
627     function transferFrom(
628         address from,
629         address to,
630         uint256 tokenId
631     ) external;
632 
633     /**
634      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
635      * The approval is cleared when the token is transferred.
636      *
637      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
638      *
639      * Requirements:
640      *
641      * - The caller must own the token or be an approved operator.
642      * - `tokenId` must exist.
643      *
644      * Emits an {Approval} event.
645      */
646     function approve(address to, uint256 tokenId) external;
647 
648     /**
649      * @dev Returns the account approved for `tokenId` token.
650      *
651      * Requirements:
652      *
653      * - `tokenId` must exist.
654      */
655     function getApproved(uint256 tokenId)
656         external
657         view
658         returns (address operator);
659 
660     /**
661      * @dev Approve or remove `operator` as an operator for the caller.
662      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
663      *
664      * Requirements:
665      *
666      * - The `operator` cannot be the caller.
667      *
668      * Emits an {ApprovalForAll} event.
669      */
670     function setApprovalForAll(address operator, bool _approved) external;
671 
672     /**
673      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
674      *
675      * See {setApprovalForAll}
676      */
677     function isApprovedForAll(address owner, address operator)
678         external
679         view
680         returns (bool);
681 
682     /**
683      * @dev Safely transfers `tokenId` token from `from` to `to`.
684      *
685      * Requirements:
686      *
687      * - `from` cannot be the zero address.
688      * - `to` cannot be the zero address.
689      * - `tokenId` token must exist and be owned by `from`.
690      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
691      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
692      *
693      * Emits a {Transfer} event.
694      */
695     function safeTransferFrom(
696         address from,
697         address to,
698         uint256 tokenId,
699         bytes calldata data
700     ) external;
701 }
702 
703 // File: gist-270e50cc401a88221663666c2f449393/IERC721Enumerable.sol
704 
705 
706 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
707 
708 pragma solidity ^0.8.0;
709 
710 
711 /**
712  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
713  * @dev See https://eips.ethereum.org/EIPS/eip-721
714  */
715 interface IERC721Enumerable is IERC721 {
716     /**
717      * @dev Returns the total amount of tokens stored by the contract.
718      */
719     function totalSupply() external view returns (uint256);
720 
721     /**
722      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
723      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
724      */
725     function tokenOfOwnerByIndex(address owner, uint256 index)
726         external
727         view
728         returns (uint256);
729 
730     /**
731      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
732      * Use along with {totalSupply} to enumerate all tokens.
733      */
734     function tokenByIndex(uint256 index) external view returns (uint256);
735 }
736 
737 // File: gist-270e50cc401a88221663666c2f449393/IERC721Metadata.sol
738 
739 
740 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
741 
742 pragma solidity ^0.8.0;
743 
744 
745 /**
746  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
747  * @dev See https://eips.ethereum.org/EIPS/eip-721
748  */
749 interface IERC721Metadata is IERC721 {
750     /**
751      * @dev Returns the token collection name.
752      */
753     function name() external view returns (string memory);
754 
755     /**
756      * @dev Returns the token collection symbol.
757      */
758     function symbol() external view returns (string memory);
759 
760     /**
761      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
762      */
763     function tokenURI(uint256 tokenId) external view returns (string memory);
764 }
765 
766 // File: gist-270e50cc401a88221663666c2f449393/ERC721A.sol
767 
768 
769 // Creator: Chiru Labs
770 
771 pragma solidity ^0.8.0;
772 
773 
774 
775 
776 
777 
778 
779 
780 
781 /**
782  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
783  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
784  *
785  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
786  *
787  * Does not support burning tokens to address(0).
788  *
789  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
790  */
791 contract ERC721A is
792     Context,
793     ERC165,
794     IERC721,
795     IERC721Metadata,
796     IERC721Enumerable
797 {
798     using Address for address;
799     using Strings for uint256;
800 
801     struct TokenOwnership {
802         address addr;
803         uint64 startTimestamp;
804     }
805 
806     struct AddressData {
807         uint128 balance;
808         uint128 numberMinted;
809     }
810 
811     uint256 internal currentIndex;
812 
813     // Token name
814     string private _name;
815 
816     // Token symbol
817     string private _symbol;
818 
819     // Mapping from token ID to ownership details
820     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
821     mapping(uint256 => TokenOwnership) internal _ownerships;
822 
823     // Mapping owner address to address data
824     mapping(address => AddressData) private _addressData;
825 
826     // Mapping from token ID to approved address
827     mapping(uint256 => address) private _tokenApprovals;
828 
829     // Mapping from owner to operator approvals
830     mapping(address => mapping(address => bool)) private _operatorApprovals;
831 
832     constructor(string memory name_, string memory symbol_) {
833         _name = name_;
834         _symbol = symbol_;
835     }
836 
837     /**
838      * @dev See {IERC721Enumerable-totalSupply}.
839      */
840     function totalSupply() public view override returns (uint256) {
841         return currentIndex;
842     }
843 
844     /**
845      * @dev See {IERC721Enumerable-tokenByIndex}.
846      */
847     function tokenByIndex(uint256 index)
848         public
849         view
850         override
851         returns (uint256)
852     {
853         require(index < totalSupply(), "ERC721A: global index out of bounds");
854         return index;
855     }
856 
857     /**
858      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
859      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
860      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
861      */
862     function tokenOfOwnerByIndex(address owner, uint256 index)
863         public
864         view
865         override
866         returns (uint256)
867     {
868         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
869         uint256 numMintedSoFar = totalSupply();
870         uint256 tokenIdsIdx;
871         address currOwnershipAddr;
872 
873         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
874         unchecked {
875             for (uint256 i; i < numMintedSoFar; i++) {
876                 TokenOwnership memory ownership = _ownerships[i];
877                 if (ownership.addr != address(0)) {
878                     currOwnershipAddr = ownership.addr;
879                 }
880                 if (currOwnershipAddr == owner) {
881                     if (tokenIdsIdx == index) {
882                         return i;
883                     }
884                     tokenIdsIdx++;
885                 }
886             }
887         }
888 
889         revert("ERC721A: unable to get token of owner by index");
890     }
891 
892     /**
893      * @dev See {IERC165-supportsInterface}.
894      */
895     function supportsInterface(bytes4 interfaceId)
896         public
897         view
898         virtual
899         override(ERC165, IERC165)
900         returns (bool)
901     {
902         return
903             interfaceId == type(IERC721).interfaceId ||
904             interfaceId == type(IERC721Metadata).interfaceId ||
905             interfaceId == type(IERC721Enumerable).interfaceId ||
906             super.supportsInterface(interfaceId);
907     }
908 
909     /**
910      * @dev See {IERC721-balanceOf}.
911      */
912     function balanceOf(address owner) public view override returns (uint256) {
913         require(
914             owner != address(0),
915             "ERC721A: balance query for the zero address"
916         );
917         return uint256(_addressData[owner].balance);
918     }
919 
920     function _numberMinted(address owner) internal view returns (uint256) {
921         require(
922             owner != address(0),
923             "ERC721A: number minted query for the zero address"
924         );
925         return uint256(_addressData[owner].numberMinted);
926     }
927 
928     /**
929      * Gas spent here starts off proportional to the maximum mint batch size.
930      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
931      */
932     function ownershipOf(uint256 tokenId)
933         internal
934         view
935         returns (TokenOwnership memory)
936     {
937         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
938 
939         unchecked {
940             for (uint256 curr = tokenId; curr >= 0; curr--) {
941                 TokenOwnership memory ownership = _ownerships[curr];
942                 if (ownership.addr != address(0)) {
943                     return ownership;
944                 }
945             }
946         }
947 
948         revert("ERC721A: unable to determine the owner of token");
949     }
950 
951     /**
952      * @dev See {IERC721-ownerOf}.
953      */
954     function ownerOf(uint256 tokenId) public view override returns (address) {
955         return ownershipOf(tokenId).addr;
956     }
957 
958     /**
959      * @dev See {IERC721Metadata-name}.
960      */
961     function name() public view virtual override returns (string memory) {
962         return _name;
963     }
964 
965     /**
966      * @dev See {IERC721Metadata-symbol}.
967      */
968     function symbol() public view virtual override returns (string memory) {
969         return _symbol;
970     }
971 
972     /**
973      * @dev See {IERC721Metadata-tokenURI}.
974      */
975     function tokenURI(uint256 tokenId)
976         public
977         view
978         virtual
979         override
980         returns (string memory)
981     {
982         require(
983             _exists(tokenId),
984             "ERC721Metadata: URI query for nonexistent token"
985         );
986 
987         string memory baseURI = _baseURI();
988         return
989             bytes(baseURI).length != 0
990                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
991                 : "";
992     }
993 
994     /**
995      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
996      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
997      * by default, can be overriden in child contracts.
998      */
999     function _baseURI() internal view virtual returns (string memory) {
1000         return "";
1001     }
1002 
1003     /**
1004      * @dev See {IERC721-approve}.
1005      */
1006     function approve(address to, uint256 tokenId) public override {
1007         address owner = ERC721A.ownerOf(tokenId);
1008         require(to != owner, "ERC721A: approval to current owner");
1009 
1010         require(
1011             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1012             "ERC721A: approve caller is not owner nor approved for all"
1013         );
1014 
1015         _approve(to, tokenId, owner);
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-getApproved}.
1020      */
1021     function getApproved(uint256 tokenId)
1022         public
1023         view
1024         override
1025         returns (address)
1026     {
1027         require(
1028             _exists(tokenId),
1029             "ERC721A: approved query for nonexistent token"
1030         );
1031 
1032         return _tokenApprovals[tokenId];
1033     }
1034 
1035     /**
1036      * @dev See {IERC721-setApprovalForAll}.
1037      */
1038     function setApprovalForAll(address operator, bool approved)
1039         public
1040         override
1041     {
1042         require(operator != _msgSender(), "ERC721A: approve to caller");
1043 
1044         _operatorApprovals[_msgSender()][operator] = approved;
1045         emit ApprovalForAll(_msgSender(), operator, approved);
1046     }
1047 
1048     /**
1049      * @dev See {IERC721-isApprovedForAll}.
1050      */
1051     function isApprovedForAll(address owner, address operator)
1052         public
1053         view
1054         virtual
1055         override
1056         returns (bool)
1057     {
1058         return _operatorApprovals[owner][operator];
1059     }
1060 
1061     /**
1062      * @dev See {IERC721-transferFrom}.
1063      */
1064     function transferFrom(
1065         address from,
1066         address to,
1067         uint256 tokenId
1068     ) public override {
1069         _transfer(from, to, tokenId);
1070     }
1071 
1072     /**
1073      * @dev See {IERC721-safeTransferFrom}.
1074      */
1075     function safeTransferFrom(
1076         address from,
1077         address to,
1078         uint256 tokenId
1079     ) public override {
1080         safeTransferFrom(from, to, tokenId, "");
1081     }
1082 
1083     /**
1084      * @dev See {IERC721-safeTransferFrom}.
1085      */
1086     function safeTransferFrom(
1087         address from,
1088         address to,
1089         uint256 tokenId,
1090         bytes memory _data
1091     ) public override {
1092         _transfer(from, to, tokenId);
1093         require(
1094             _checkOnERC721Received(from, to, tokenId, _data),
1095             "ERC721A: transfer to non ERC721Receiver implementer"
1096         );
1097     }
1098 
1099     /**
1100      * @dev Returns whether `tokenId` exists.
1101      *
1102      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1103      *
1104      * Tokens start existing when they are minted (`_mint`),
1105      */
1106     function _exists(uint256 tokenId) internal view returns (bool) {
1107         return tokenId < currentIndex;
1108     }
1109 
1110     function _safeMint(address to, uint256 quantity) internal {
1111         _safeMint(to, quantity, "");
1112     }
1113 
1114     /**
1115      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1116      *
1117      * Requirements:
1118      *
1119      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1120      * - `quantity` must be greater than 0.
1121      *
1122      * Emits a {Transfer} event.
1123      */
1124     function _safeMint(
1125         address to,
1126         uint256 quantity,
1127         bytes memory _data
1128     ) internal {
1129         _mint(to, quantity, _data, true);
1130     }
1131 
1132     /**
1133      * @dev Mints `quantity` tokens and transfers them to `to`.
1134      *
1135      * Requirements:
1136      *
1137      * - `to` cannot be the zero address.
1138      * - `quantity` must be greater than 0.
1139      *
1140      * Emits a {Transfer} event.
1141      */
1142     function _mint(
1143         address to,
1144         uint256 quantity,
1145         bytes memory _data,
1146         bool safe
1147     ) internal {
1148         uint256 startTokenId = currentIndex;
1149         require(to != address(0), "ERC721A: mint to the zero address");
1150         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1151 
1152         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1153 
1154         // Overflows are incredibly unrealistic.
1155         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1156         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1157         unchecked {
1158             _addressData[to].balance += uint128(quantity);
1159             _addressData[to].numberMinted += uint128(quantity);
1160 
1161             _ownerships[startTokenId].addr = to;
1162             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1163 
1164             uint256 updatedIndex = startTokenId;
1165 
1166             for (uint256 i; i < quantity; i++) {
1167                 emit Transfer(address(0), to, updatedIndex);
1168                 if (safe) {
1169                     require(
1170                         _checkOnERC721Received(
1171                             address(0),
1172                             to,
1173                             updatedIndex,
1174                             _data
1175                         ),
1176                         "ERC721A: transfer to non ERC721Receiver implementer"
1177                     );
1178                 }
1179 
1180                 updatedIndex++;
1181             }
1182 
1183             currentIndex = updatedIndex;
1184         }
1185 
1186         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1187     }
1188 
1189     /**
1190      * @dev Transfers `tokenId` from `from` to `to`.
1191      *
1192      * Requirements:
1193      *
1194      * - `to` cannot be the zero address.
1195      * - `tokenId` token must be owned by `from`.
1196      *
1197      * Emits a {Transfer} event.
1198      */
1199     function _transfer(
1200         address from,
1201         address to,
1202         uint256 tokenId
1203     ) private {
1204         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1205 
1206         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1207             getApproved(tokenId) == _msgSender() ||
1208             isApprovedForAll(prevOwnership.addr, _msgSender()));
1209 
1210         require(
1211             isApprovedOrOwner,
1212             "ERC721A: transfer caller is not owner nor approved"
1213         );
1214 
1215         require(
1216             prevOwnership.addr == from,
1217             "ERC721A: transfer from incorrect owner"
1218         );
1219         require(to != address(0), "ERC721A: transfer to the zero address");
1220 
1221         _beforeTokenTransfers(from, to, tokenId, 1);
1222 
1223         // Clear approvals from the previous owner
1224         _approve(address(0), tokenId, prevOwnership.addr);
1225 
1226         // Underflow of the sender's balance is impossible because we check for
1227         // ownership above and the recipient's balance can't realistically overflow.
1228         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1229         unchecked {
1230             _addressData[from].balance -= 1;
1231             _addressData[to].balance += 1;
1232 
1233             _ownerships[tokenId].addr = to;
1234             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1235 
1236             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1237             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1238             uint256 nextTokenId = tokenId + 1;
1239             if (_ownerships[nextTokenId].addr == address(0)) {
1240                 if (_exists(nextTokenId)) {
1241                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1242                     _ownerships[nextTokenId].startTimestamp = prevOwnership
1243                         .startTimestamp;
1244                 }
1245             }
1246         }
1247 
1248         emit Transfer(from, to, tokenId);
1249         _afterTokenTransfers(from, to, tokenId, 1);
1250     }
1251 
1252     /**
1253      * @dev Approve `to` to operate on `tokenId`
1254      *
1255      * Emits a {Approval} event.
1256      */
1257     function _approve(
1258         address to,
1259         uint256 tokenId,
1260         address owner
1261     ) private {
1262         _tokenApprovals[tokenId] = to;
1263         emit Approval(owner, to, tokenId);
1264     }
1265 
1266     /**
1267      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1268      * The call is not executed if the target address is not a contract.
1269      *
1270      * @param from address representing the previous owner of the given token ID
1271      * @param to target address that will receive the tokens
1272      * @param tokenId uint256 ID of the token to be transferred
1273      * @param _data bytes optional data to send along with the call
1274      * @return bool whether the call correctly returned the expected magic value
1275      */
1276     function _checkOnERC721Received(
1277         address from,
1278         address to,
1279         uint256 tokenId,
1280         bytes memory _data
1281     ) private returns (bool) {
1282         if (to.isContract()) {
1283             try
1284                 IERC721Receiver(to).onERC721Received(
1285                     _msgSender(),
1286                     from,
1287                     tokenId,
1288                     _data
1289                 )
1290             returns (bytes4 retval) {
1291                 return retval == IERC721Receiver(to).onERC721Received.selector;
1292             } catch (bytes memory reason) {
1293                 if (reason.length == 0) {
1294                     revert(
1295                         "ERC721A: transfer to non ERC721Receiver implementer"
1296                     );
1297                 } else {
1298                     assembly {
1299                         revert(add(32, reason), mload(reason))
1300                     }
1301                 }
1302             }
1303         } else {
1304             return true;
1305         }
1306     }
1307 
1308     /**
1309      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1310      *
1311      * startTokenId - the first token id to be transferred
1312      * quantity - the amount to be transferred
1313      *
1314      * Calling conditions:
1315      *
1316      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1317      * transferred to `to`.
1318      * - When `from` is zero, `tokenId` will be minted for `to`.
1319      */
1320     function _beforeTokenTransfers(
1321         address from,
1322         address to,
1323         uint256 startTokenId,
1324         uint256 quantity
1325     ) internal virtual {}
1326 
1327     /**
1328      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1329      * minting.
1330      *
1331      * startTokenId - the first token id to be transferred
1332      * quantity - the amount to be transferred
1333      *
1334      * Calling conditions:
1335      *
1336      * - when `from` and `to` are both non-zero.
1337      * - `from` and `to` are never both zero.
1338      */
1339     function _afterTokenTransfers(
1340         address from,
1341         address to,
1342         uint256 startTokenId,
1343         uint256 quantity
1344     ) internal virtual {}
1345 }
1346 // File: gist-270e50cc401a88221663666c2f449393/XrootDotDev.sol
1347 
1348 pragma solidity 0.8.13;
1349 
1350 
1351 
1352 
1353 
1354 
1355 contract AsianIdentity is ERC721A, Ownable {
1356   using Strings for uint256;
1357 
1358   string public baseURI;
1359   string public baseExtension = ".json";
1360   string public notRevealedUri;
1361 
1362   uint256 public cost = 0.055 ether;
1363   uint256 public maxSupply = 8000;
1364   uint256 public maxMintAmount = 5;
1365   uint256 public nftPerAddressLimit = 5;
1366   uint256 public ReservedNFT = 200;
1367   
1368   bool public paused = true;
1369   bool public revealed = false;
1370   bool public onlyWhitelisted = true;
1371   address[] public whitelistedAddresses;
1372 
1373 
1374 
1375   constructor(
1376     string memory _name,
1377     string memory _symbol,
1378     string memory _initBaseURI,
1379     string memory _initNotRevealedUri
1380   ) ERC721A(_name, _symbol) {
1381     setBaseURI(_initBaseURI);
1382     setNotRevealedURI(_initNotRevealedUri);
1383   }
1384 
1385   // internal
1386   function _baseURI() internal view virtual override returns (string memory) {
1387     return baseURI;
1388   }
1389 
1390   // public
1391   function mint(uint256 _mintAmount) public payable {
1392     require(!paused);
1393     uint256 supply = totalSupply();
1394     require(_mintAmount > 0);
1395     require(_mintAmount <= maxMintAmount);
1396     require(supply + _mintAmount <= maxSupply - ReservedNFT);
1397 
1398     if (msg.sender != owner()) {
1399         if (onlyWhitelisted == true) {
1400             require(isWhitelisted(msg.sender), "User is not whitelisted.");
1401             uint256 ownerTokenCount = balanceOf(msg.sender);
1402             require (ownerTokenCount < nftPerAddressLimit);
1403 
1404         }
1405           require(msg.value >= cost * _mintAmount); 
1406     }
1407 
1408    
1409       _safeMint(msg.sender, _mintAmount);
1410     
1411   }
1412     function isWhitelisted(address _user) public view returns (bool) {
1413         for (uint256 i = 0; i < whitelistedAddresses.length; i++) {
1414             if(whitelistedAddresses[i] == _user) {
1415                 return true;
1416 
1417             }
1418         }
1419             return false;
1420     }
1421 
1422 
1423   function walletOfOwner(address _owner)
1424     public
1425     view
1426     returns (uint256[] memory)
1427   {
1428     uint256 ownerTokenCount = balanceOf(_owner);
1429     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1430     for (uint256 i; i < ownerTokenCount; i++) {
1431       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1432     }
1433     return tokenIds;
1434   }
1435 
1436   function tokenURI(uint256 tokenId)
1437     public
1438     view
1439     virtual
1440     override
1441     returns (string memory)
1442   {
1443     require(
1444       _exists(tokenId),
1445       "ERC721Metadata: URI query for nonexistent token"
1446     );
1447     
1448     if(revealed == false) {
1449         return notRevealedUri;
1450     }
1451 
1452     string memory currentBaseURI = _baseURI();
1453     return bytes(currentBaseURI).length > 0
1454         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1455         : "";
1456   }
1457 
1458   //only owner
1459   function reveal() public onlyOwner {
1460       revealed = true;
1461   }
1462   
1463   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1464     nftPerAddressLimit = _limit;
1465   }
1466 
1467   function setCost(uint256 _newCost) public onlyOwner {
1468     cost = _newCost;
1469   }
1470 
1471   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1472     maxMintAmount = _newmaxMintAmount;
1473   }
1474   
1475   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1476     notRevealedUri = _notRevealedURI;
1477   }
1478 
1479   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1480     baseURI = _newBaseURI;
1481   }
1482 
1483   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1484     baseExtension = _newBaseExtension;
1485   }
1486 
1487   function pause(bool _state) public onlyOwner {
1488     paused = _state;
1489   }
1490 
1491   function setOnlyWhitelisted(bool _state) public onlyOwner {
1492     onlyWhitelisted = _state;
1493   }
1494  
1495  function whitelistUsers(address[] calldata _users) public onlyOwner {
1496      delete whitelistedAddresses;
1497      whitelistedAddresses = _users;
1498   }
1499 
1500 
1501     function seReservedNFT(uint256 _newreserve) public onlyOwner {
1502         ReservedNFT = _newreserve;
1503 
1504     }
1505  
1506 
1507   function withdraw() public payable onlyOwner {
1508     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1509     require(os);
1510   }
1511   
1512   function AirDrop(address _to, uint256 _mintAmount) public onlyOwner {
1513     uint256 supply = totalSupply();
1514     require(!paused);
1515     require(_mintAmount > 0);
1516     require(_mintAmount <= maxMintAmount);
1517     require(supply + _mintAmount <= maxSupply);
1518    
1519       _safeMint(_to, _mintAmount);
1520     
1521   }
1522   
1523 }