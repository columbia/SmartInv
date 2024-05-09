1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
3 /**
4  .--.--.                 .--.--.    .--.--.              
5  /  /    '    ,--.--.    /  /    '  /  /    '       .--,  
6 |  :  /`./   /       \  |  :  /`./ |  :  /`./     /_ ./|  
7 |  :  ;_    .--.  .-. | |  :  ;_   |  :  ;_    , ' , ' :  
8  \  \    `.  \__\/: . .  \  \    `. \  \    `./___/ \: |  
9   `----.   \ ," .--.; |   `----.   \ `----.   \.  \  ' |  
10  /  /`--'  //  /  ,.  |  /  /`--'  //  /`--'  / \  ;   :  
11 '--'.     /;  :   .'   \'--'.     /'--'.     /   \  \  ;  
12   `--'---' |  ,     .-./  `--'---'   `--'---'     :  \  \ 
13             `--`---'                               \  ' ; 
14                                                     `--`  
15                                                     
16 */
17 pragma solidity ^0.8.0;
18 
19 /**
20  * @dev Interface of the ERC165 standard, as defined in the
21  * https://eips.ethereum.org/EIPS/eip-165[EIP].
22  *
23  * Implementers can declare support of contract interfaces, which can then be
24  * queried by others ({ERC165Checker}).
25  *
26  * For an implementation, see {ERC165}.
27  */
28 interface IERC165 {
29     /**
30      * @dev Returns true if this contract implements the interface defined by
31      * `interfaceId`. See the corresponding
32      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
33      * to learn more about how these ids are created.
34      *
35      * This function call must use less than 30 000 gas.
36      */
37     function supportsInterface(bytes4 interfaceId) external view returns (bool);
38 }
39 
40 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
41 
42 pragma solidity ^0.8.0;
43 
44 /**
45  * @dev Required interface of an ERC721 compliant contract.
46  */
47 interface IERC721 is IERC165 {
48     /**
49      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
50      */
51     event Transfer(
52         address indexed from,
53         address indexed to,
54         uint256 indexed tokenId
55     );
56 
57     /**
58      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
59      */
60     event Approval(
61         address indexed owner,
62         address indexed approved,
63         uint256 indexed tokenId
64     );
65 
66     /**
67      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
68      */
69     event ApprovalForAll(
70         address indexed owner,
71         address indexed operator,
72         bool approved
73     );
74 
75     /**
76      * @dev Returns the number of tokens in ``owner``'s account.
77      */
78     function balanceOf(address owner) external view returns (uint256 balance);
79 
80     /**
81      * @dev Returns the owner of the `tokenId` token.
82      *
83      * Requirements:
84      *
85      * - `tokenId` must exist.
86      */
87     function ownerOf(uint256 tokenId) external view returns (address owner);
88 
89     /**
90      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
91      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
92      *
93      * Requirements:
94      *
95      * - `from` cannot be the zero address.
96      * - `to` cannot be the zero address.
97      * - `tokenId` token must exist and be owned by `from`.
98      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
99      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
100      *
101      * Emits a {Transfer} event.
102      */
103     function safeTransferFrom(
104         address from,
105         address to,
106         uint256 tokenId
107     ) external;
108 
109     /**
110      * @dev Transfers `tokenId` token from `from` to `to`.
111      *
112      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
113      *
114      * Requirements:
115      *
116      * - `from` cannot be the zero address.
117      * - `to` cannot be the zero address.
118      * - `tokenId` token must be owned by `from`.
119      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
120      *
121      * Emits a {Transfer} event.
122      */
123     function transferFrom(
124         address from,
125         address to,
126         uint256 tokenId
127     ) external;
128 
129     /**
130      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
131      * The approval is cleared when the token is transferred.
132      *
133      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
134      *
135      * Requirements:
136      *
137      * - The caller must own the token or be an approved operator.
138      * - `tokenId` must exist.
139      *
140      * Emits an {Approval} event.
141      */
142     function approve(address to, uint256 tokenId) external;
143 
144     /**
145      * @dev Returns the account approved for `tokenId` token.
146      *
147      * Requirements:
148      *
149      * - `tokenId` must exist.
150      */
151     function getApproved(uint256 tokenId)
152         external
153         view
154         returns (address operator);
155 
156     /**
157      * @dev Approve or remove `operator` as an operator for the caller.
158      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
159      *
160      * Requirements:
161      *
162      * - The `operator` cannot be the caller.
163      *
164      * Emits an {ApprovalForAll} event.
165      */
166     function setApprovalForAll(address operator, bool _approved) external;
167 
168     /**
169      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
170      *
171      * See {setApprovalForAll}
172      */
173     function isApprovedForAll(address owner, address operator)
174         external
175         view
176         returns (bool);
177 
178     /**
179      * @dev Safely transfers `tokenId` token from `from` to `to`.
180      *
181      * Requirements:
182      *
183      * - `from` cannot be the zero address.
184      * - `to` cannot be the zero address.
185      * - `tokenId` token must exist and be owned by `from`.
186      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
187      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
188      *
189      * Emits a {Transfer} event.
190      */
191     function safeTransferFrom(
192         address from,
193         address to,
194         uint256 tokenId,
195         bytes calldata data
196     ) external;
197 }
198 
199 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
200 
201 pragma solidity ^0.8.0;
202 
203 /**
204  * @title ERC721 token receiver interface
205  * @dev Interface for any contract that wants to support safeTransfers
206  * from ERC721 asset contracts.
207  */
208 interface IERC721Receiver {
209     /**
210      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
211      * by `operator` from `from`, this function is called.
212      *
213      * It must return its Solidity selector to confirm the token transfer.
214      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
215      *
216      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
217      */
218     function onERC721Received(
219         address operator,
220         address from,
221         uint256 tokenId,
222         bytes calldata data
223     ) external returns (bytes4);
224 }
225 
226 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
227 
228 pragma solidity ^0.8.0;
229 
230 /**
231  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
232  * @dev See https://eips.ethereum.org/EIPS/eip-721
233  */
234 interface IERC721Metadata is IERC721 {
235     /**
236      * @dev Returns the token collection name.
237      */
238     function name() external view returns (string memory);
239 
240     /**
241      * @dev Returns the token collection symbol.
242      */
243     function symbol() external view returns (string memory);
244 
245     /**
246      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
247      */
248     function tokenURI(uint256 tokenId) external view returns (string memory);
249 }
250 
251 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
252 
253 pragma solidity ^0.8.0;
254 
255 /**
256  * @dev Implementation of the {IERC165} interface.
257  *
258  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
259  * for the additional interface id that will be supported. For example:
260  *
261  * ```solidity
262  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
263  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
264  * }
265  * ```
266  *
267  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
268  */
269 abstract contract ERC165 is IERC165 {
270     /**
271      * @dev See {IERC165-supportsInterface}.
272      */
273     function supportsInterface(bytes4 interfaceId)
274         public
275         view
276         virtual
277         override
278         returns (bool)
279     {
280         return interfaceId == type(IERC165).interfaceId;
281     }
282 }
283 
284 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
285 
286 pragma solidity ^0.8.0;
287 
288 /**
289  * @dev Collection of functions related to the address type
290  */
291 library Address {
292     /**
293      * @dev Returns true if `account` is a contract.
294      *
295      * [IMPORTANT]
296      * ====
297      * It is unsafe to assume that an address for which this function returns
298      * false is an externally-owned account (EOA) and not a contract.
299      *
300      * Among others, `isContract` will return false for the following
301      * types of addresses:
302      *
303      *  - an externally-owned account
304      *  - a contract in construction
305      *  - an address where a contract will be created
306      *  - an address where a contract lived, but was destroyed
307      * ====
308      */
309     function isContract(address account) internal view returns (bool) {
310         // This method relies on extcodesize, which returns 0 for contracts in
311         // construction, since the code is only stored at the end of the
312         // constructor execution.
313 
314         uint256 size;
315         assembly {
316             size := extcodesize(account)
317         }
318         return size > 0;
319     }
320 
321     /**
322      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
323      * `recipient`, forwarding all available gas and reverting on errors.
324      *
325      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
326      * of certain opcodes, possibly making contracts go over the 2300 gas limit
327      * imposed by `transfer`, making them unable to receive funds via
328      * `transfer`. {sendValue} removes this limitation.
329      *
330      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
331      *
332      * IMPORTANT: because control is transferred to `recipient`, care must be
333      * taken to not create reentrancy vulnerabilities. Consider using
334      * {ReentrancyGuard} or the
335      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
336      */
337     function sendValue(address payable recipient, uint256 amount) internal {
338         require(
339             address(this).balance >= amount,
340             "Address: insufficient balance"
341         );
342 
343         (bool success, ) = recipient.call{value: amount}("");
344         require(
345             success,
346             "Address: unable to send value, recipient may have reverted"
347         );
348     }
349 
350     /**
351      * @dev Performs a Solidity function call using a low level `call`. A
352      * plain `call` is an unsafe replacement for a function call: use this
353      * function instead.
354      *
355      * If `target` reverts with a revert reason, it is bubbled up by this
356      * function (like regular Solidity function calls).
357      *
358      * Returns the raw returned data. To convert to the expected return value,
359      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
360      *
361      * Requirements:
362      *
363      * - `target` must be a contract.
364      * - calling `target` with `data` must not revert.
365      *
366      * _Available since v3.1._
367      */
368     function functionCall(address target, bytes memory data)
369         internal
370         returns (bytes memory)
371     {
372         return functionCall(target, data, "Address: low-level call failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
377      * `errorMessage` as a fallback revert reason when `target` reverts.
378      *
379      * _Available since v3.1._
380      */
381     function functionCall(
382         address target,
383         bytes memory data,
384         string memory errorMessage
385     ) internal returns (bytes memory) {
386         return functionCallWithValue(target, data, 0, errorMessage);
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
391      * but also transferring `value` wei to `target`.
392      *
393      * Requirements:
394      *
395      * - the calling contract must have an ETH balance of at least `value`.
396      * - the called Solidity function must be `payable`.
397      *
398      * _Available since v3.1._
399      */
400     function functionCallWithValue(
401         address target,
402         bytes memory data,
403         uint256 value
404     ) internal returns (bytes memory) {
405         return
406             functionCallWithValue(
407                 target,
408                 data,
409                 value,
410                 "Address: low-level call with value failed"
411             );
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
416      * with `errorMessage` as a fallback revert reason when `target` reverts.
417      *
418      * _Available since v3.1._
419      */
420     function functionCallWithValue(
421         address target,
422         bytes memory data,
423         uint256 value,
424         string memory errorMessage
425     ) internal returns (bytes memory) {
426         require(
427             address(this).balance >= value,
428             "Address: insufficient balance for call"
429         );
430         require(isContract(target), "Address: call to non-contract");
431 
432         (bool success, bytes memory returndata) = target.call{value: value}(
433             data
434         );
435         return verifyCallResult(success, returndata, errorMessage);
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
440      * but performing a static call.
441      *
442      * _Available since v3.3._
443      */
444     function functionStaticCall(address target, bytes memory data)
445         internal
446         view
447         returns (bytes memory)
448     {
449         return
450             functionStaticCall(
451                 target,
452                 data,
453                 "Address: low-level static call failed"
454             );
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
459      * but performing a static call.
460      *
461      * _Available since v3.3._
462      */
463     function functionStaticCall(
464         address target,
465         bytes memory data,
466         string memory errorMessage
467     ) internal view returns (bytes memory) {
468         require(isContract(target), "Address: static call to non-contract");
469 
470         (bool success, bytes memory returndata) = target.staticcall(data);
471         return verifyCallResult(success, returndata, errorMessage);
472     }
473 
474     /**
475      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
476      * but performing a delegate call.
477      *
478      * _Available since v3.4._
479      */
480     function functionDelegateCall(address target, bytes memory data)
481         internal
482         returns (bytes memory)
483     {
484         return
485             functionDelegateCall(
486                 target,
487                 data,
488                 "Address: low-level delegate call failed"
489             );
490     }
491 
492     /**
493      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
494      * but performing a delegate call.
495      *
496      * _Available since v3.4._
497      */
498     function functionDelegateCall(
499         address target,
500         bytes memory data,
501         string memory errorMessage
502     ) internal returns (bytes memory) {
503         require(isContract(target), "Address: delegate call to non-contract");
504 
505         (bool success, bytes memory returndata) = target.delegatecall(data);
506         return verifyCallResult(success, returndata, errorMessage);
507     }
508 
509     /**
510      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
511      * revert reason using the provided one.
512      *
513      * _Available since v4.3._
514      */
515     function verifyCallResult(
516         bool success,
517         bytes memory returndata,
518         string memory errorMessage
519     ) internal pure returns (bytes memory) {
520         if (success) {
521             return returndata;
522         } else {
523             // Look for revert reason and bubble it up if present
524             if (returndata.length > 0) {
525                 // The easiest way to bubble the revert reason is using memory via assembly
526 
527                 assembly {
528                     let returndata_size := mload(returndata)
529                     revert(add(32, returndata), returndata_size)
530                 }
531             } else {
532                 revert(errorMessage);
533             }
534         }
535     }
536 }
537 
538 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
539 
540 pragma solidity ^0.8.0;
541 
542 /**
543  * @dev Provides information about the current execution context, including the
544  * sender of the transaction and its data. While these are generally available
545  * via msg.sender and msg.data, they should not be accessed in such a direct
546  * manner, since when dealing with meta-transactions the account sending and
547  * paying for execution may not be the actual sender (as far as an application
548  * is concerned).
549  *
550  * This contract is only required for intermediate, library-like contracts.
551  */
552 abstract contract Context {
553     function _msgSender() internal view virtual returns (address) {
554         return msg.sender;
555     }
556 
557     function _msgData() internal view virtual returns (bytes calldata) {
558         return msg.data;
559     }
560 }
561 
562 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
563 
564 pragma solidity ^0.8.0;
565 
566 /**
567  * @dev String operations.
568  */
569 library Strings {
570     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
571 
572     /**
573      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
574      */
575     function toString(uint256 value) internal pure returns (string memory) {
576         // Inspired by OraclizeAPI's implementation - MIT licence
577         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
578 
579         if (value == 0) {
580             return "0";
581         }
582         uint256 temp = value;
583         uint256 digits;
584         while (temp != 0) {
585             digits++;
586             temp /= 10;
587         }
588         bytes memory buffer = new bytes(digits);
589         while (value != 0) {
590             digits -= 1;
591             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
592             value /= 10;
593         }
594         return string(buffer);
595     }
596 
597     /**
598      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
599      */
600     function toHexString(uint256 value) internal pure returns (string memory) {
601         if (value == 0) {
602             return "0x00";
603         }
604         uint256 temp = value;
605         uint256 length = 0;
606         while (temp != 0) {
607             length++;
608             temp >>= 8;
609         }
610         return toHexString(value, length);
611     }
612 
613     /**
614      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
615      */
616     function toHexString(uint256 value, uint256 length)
617         internal
618         pure
619         returns (string memory)
620     {
621         bytes memory buffer = new bytes(2 * length + 2);
622         buffer[0] = "0";
623         buffer[1] = "x";
624         for (uint256 i = 2 * length + 1; i > 1; --i) {
625             buffer[i] = _HEX_SYMBOLS[value & 0xf];
626             value >>= 4;
627         }
628         require(value == 0, "Strings: hex length insufficient");
629         return string(buffer);
630     }
631 }
632 
633 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
634 
635 pragma solidity ^0.8.0;
636 
637 /**
638  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
639  * @dev See https://eips.ethereum.org/EIPS/eip-721
640  */
641 interface IERC721Enumerable is IERC721 {
642     /**
643      * @dev Returns the total amount of tokens stored by the contract.
644      */
645     function totalSupply() external view returns (uint256);
646 
647     /**
648      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
649      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
650      */
651     function tokenOfOwnerByIndex(address owner, uint256 index)
652         external
653         view
654         returns (uint256 tokenId);
655 
656     /**
657      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
658      * Use along with {totalSupply} to enumerate all tokens.
659      */
660     function tokenByIndex(uint256 index) external view returns (uint256);
661 }
662 
663 pragma solidity ^0.8.0;
664 
665 /**
666  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
667  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
668  *
669  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
670  *
671  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
672  *
673  * Does not support burning tokens to address(0).
674  */
675 contract ERC721A is
676   Context,
677   ERC165,
678   IERC721,
679   IERC721Metadata,
680   IERC721Enumerable
681 {
682   using Address for address;
683   using Strings for uint256;
684 
685   struct TokenOwnership {
686     address addr;
687     uint64 startTimestamp;
688   }
689 
690   struct AddressData {
691     uint128 balance;
692     uint128 numberMinted;
693   }
694 
695   uint256 private currentIndex = 0;
696 
697   uint256 internal immutable collectionSize;
698   uint256 internal immutable maxBatchSize;
699 
700   // Token name
701   string private _name;
702 
703   // Token symbol
704   string private _symbol;
705 
706   // Mapping from token ID to ownership details
707   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
708   mapping(uint256 => TokenOwnership) private _ownerships;
709 
710   // Mapping owner address to address data
711   mapping(address => AddressData) private _addressData;
712 
713   // Mapping from token ID to approved address
714   mapping(uint256 => address) private _tokenApprovals;
715 
716   // Mapping from owner to operator approvals
717   mapping(address => mapping(address => bool)) private _operatorApprovals;
718 
719   /**
720    * @dev
721    * `maxBatchSize` refers to how much a minter can mint at a time.
722    * `collectionSize_` refers to how many tokens are in the collection.
723    */
724   constructor(
725     string memory name_,
726     string memory symbol_,
727     uint256 maxBatchSize_,
728     uint256 collectionSize_
729   ) {
730     require(
731       collectionSize_ > 0,
732       "ERC721A: collection must have a nonzero supply"
733     );
734     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
735     _name = name_;
736     _symbol = symbol_;
737     maxBatchSize = maxBatchSize_;
738     collectionSize = collectionSize_;
739   }
740 
741   /**
742    * @dev See {IERC721Enumerable-totalSupply}.
743    */
744   function totalSupply() public view override returns (uint256) {
745     return currentIndex;
746   }
747 
748   /**
749    * @dev See {IERC721Enumerable-tokenByIndex}.
750    */
751   function tokenByIndex(uint256 index) public view override returns (uint256) {
752     require(index < totalSupply(), "ERC721A: global index out of bounds");
753     return index;
754   }
755 
756   /**
757    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
758    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
759    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
760    */
761   function tokenOfOwnerByIndex(address owner, uint256 index)
762     public
763     view
764     override
765     returns (uint256)
766   {
767     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
768     uint256 numMintedSoFar = totalSupply();
769     uint256 tokenIdsIdx = 0;
770     address currOwnershipAddr = address(0);
771     for (uint256 i = 0; i < numMintedSoFar; i++) {
772       TokenOwnership memory ownership = _ownerships[i];
773       if (ownership.addr != address(0)) {
774         currOwnershipAddr = ownership.addr;
775       }
776       if (currOwnershipAddr == owner) {
777         if (tokenIdsIdx == index) {
778           return i;
779         }
780         tokenIdsIdx++;
781       }
782     }
783     revert("ERC721A: unable to get token of owner by index");
784   }
785 
786   /**
787    * @dev See {IERC165-supportsInterface}.
788    */
789   function supportsInterface(bytes4 interfaceId)
790     public
791     view
792     virtual
793     override(ERC165, IERC165)
794     returns (bool)
795   {
796     return
797       interfaceId == type(IERC721).interfaceId ||
798       interfaceId == type(IERC721Metadata).interfaceId ||
799       interfaceId == type(IERC721Enumerable).interfaceId ||
800       super.supportsInterface(interfaceId);
801   }
802 
803   /**
804    * @dev See {IERC721-balanceOf}.
805    */
806   function balanceOf(address owner) public view override returns (uint256) {
807     require(owner != address(0), "ERC721A: balance query for the zero address");
808     return uint256(_addressData[owner].balance);
809   }
810 
811   function _numberMinted(address owner) internal view returns (uint256) {
812     require(
813       owner != address(0),
814       "ERC721A: number minted query for the zero address"
815     );
816     return uint256(_addressData[owner].numberMinted);
817   }
818 
819   function ownershipOf(uint256 tokenId)
820     internal
821     view
822     returns (TokenOwnership memory)
823   {
824     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
825 
826     uint256 lowestTokenToCheck;
827     if (tokenId >= maxBatchSize) {
828       lowestTokenToCheck = tokenId - maxBatchSize + 1;
829     }
830 
831     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
832       TokenOwnership memory ownership = _ownerships[curr];
833       if (ownership.addr != address(0)) {
834         return ownership;
835       }
836     }
837 
838     revert("ERC721A: unable to determine the owner of token");
839   }
840 
841   /**
842    * @dev See {IERC721-ownerOf}.
843    */
844   function ownerOf(uint256 tokenId) public view override returns (address) {
845     return ownershipOf(tokenId).addr;
846   }
847 
848   /**
849    * @dev See {IERC721Metadata-name}.
850    */
851   function name() public view virtual override returns (string memory) {
852     return _name;
853   }
854 
855   /**
856    * @dev See {IERC721Metadata-symbol}.
857    */
858   function symbol() public view virtual override returns (string memory) {
859     return _symbol;
860   }
861 
862   /**
863    * @dev See {IERC721Metadata-tokenURI}.
864    */
865   function tokenURI(uint256 tokenId)
866     public
867     view
868     virtual
869     override
870     returns (string memory)
871   {
872     require(
873       _exists(tokenId),
874       "ERC721Metadata: URI query for nonexistent token"
875     );
876 
877     string memory baseURI = _baseURI();
878     return
879       bytes(baseURI).length > 0
880         ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
881         : "";
882   }
883 
884   /**
885    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
886    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
887    * by default, can be overriden in child contracts.
888    */
889   function _baseURI() internal view virtual returns (string memory) {
890     return "";
891   }
892 
893   /**
894    * @dev See {IERC721-approve}.
895    */
896   function approve(address to, uint256 tokenId) public override {
897     address owner = ERC721A.ownerOf(tokenId);
898     require(to != owner, "ERC721A: approval to current owner");
899 
900     require(
901       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
902       "ERC721A: approve caller is not owner nor approved for all"
903     );
904 
905     _approve(to, tokenId, owner);
906   }
907 
908   /**
909    * @dev See {IERC721-getApproved}.
910    */
911   function getApproved(uint256 tokenId) public view override returns (address) {
912     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
913 
914     return _tokenApprovals[tokenId];
915   }
916 
917   /**
918    * @dev See {IERC721-setApprovalForAll}.
919    */
920   function setApprovalForAll(address operator, bool approved) public override {
921     require(operator != _msgSender(), "ERC721A: approve to caller");
922 
923     _operatorApprovals[_msgSender()][operator] = approved;
924     emit ApprovalForAll(_msgSender(), operator, approved);
925   }
926 
927   /**
928    * @dev See {IERC721-isApprovedForAll}.
929    */
930   function isApprovedForAll(address owner, address operator)
931     public
932     view
933     virtual
934     override
935     returns (bool)
936   {
937     return _operatorApprovals[owner][operator];
938   }
939 
940   /**
941    * @dev See {IERC721-transferFrom}.
942    */
943   function transferFrom(
944     address from,
945     address to,
946     uint256 tokenId
947   ) public override {
948     _transfer(from, to, tokenId);
949   }
950 
951   /**
952    * @dev See {IERC721-safeTransferFrom}.
953    */
954   function safeTransferFrom(
955     address from,
956     address to,
957     uint256 tokenId
958   ) public override {
959     safeTransferFrom(from, to, tokenId, "");
960   }
961 
962   /**
963    * @dev See {IERC721-safeTransferFrom}.
964    */
965   function safeTransferFrom(
966     address from,
967     address to,
968     uint256 tokenId,
969     bytes memory _data
970   ) public override {
971     _transfer(from, to, tokenId);
972     require(
973       _checkOnERC721Received(from, to, tokenId, _data),
974       "ERC721A: transfer to non ERC721Receiver implementer"
975     );
976   }
977 
978   /**
979    * @dev Returns whether `tokenId` exists.
980    *
981    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
982    *
983    * Tokens start existing when they are minted (`_mint`),
984    */
985   function _exists(uint256 tokenId) internal view returns (bool) {
986     return tokenId < currentIndex;
987   }
988 
989   function _safeMint(address to, uint256 quantity) internal {
990     _safeMint(to, quantity, "");
991   }
992 
993   /**
994    * @dev Mints `quantity` tokens and transfers them to `to`.
995    *
996    * Requirements:
997    *
998    * - there must be `quantity` tokens remaining unminted in the total collection.
999    * - `to` cannot be the zero address.
1000    * - `quantity` cannot be larger than the max batch size.
1001    *
1002    * Emits a {Transfer} event.
1003    */
1004   function _safeMint(
1005     address to,
1006     uint256 quantity,
1007     bytes memory _data
1008   ) internal {
1009     uint256 startTokenId = currentIndex;
1010     require(to != address(0), "ERC721A: mint to the zero address");
1011     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1012     require(!_exists(startTokenId), "ERC721A: token already minted");
1013     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1014 
1015     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1016 
1017     AddressData memory addressData = _addressData[to];
1018     _addressData[to] = AddressData(
1019       addressData.balance + uint128(quantity),
1020       addressData.numberMinted + uint128(quantity)
1021     );
1022     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1023 
1024     uint256 updatedIndex = startTokenId;
1025 
1026     for (uint256 i = 0; i < quantity; i++) {
1027       emit Transfer(address(0), to, updatedIndex);
1028       require(
1029         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1030         "ERC721A: transfer to non ERC721Receiver implementer"
1031       );
1032       updatedIndex++;
1033     }
1034 
1035     currentIndex = updatedIndex;
1036     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1037   }
1038 
1039   /**
1040    * @dev Transfers `tokenId` from `from` to `to`.
1041    *
1042    * Requirements:
1043    *
1044    * - `to` cannot be the zero address.
1045    * - `tokenId` token must be owned by `from`.
1046    *
1047    * Emits a {Transfer} event.
1048    */
1049   function _transfer(
1050     address from,
1051     address to,
1052     uint256 tokenId
1053   ) private {
1054     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1055 
1056     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1057       getApproved(tokenId) == _msgSender() ||
1058       isApprovedForAll(prevOwnership.addr, _msgSender()));
1059 
1060     require(
1061       isApprovedOrOwner,
1062       "ERC721A: transfer caller is not owner nor approved"
1063     );
1064 
1065     require(
1066       prevOwnership.addr == from,
1067       "ERC721A: transfer from incorrect owner"
1068     );
1069     require(to != address(0), "ERC721A: transfer to the zero address");
1070 
1071     _beforeTokenTransfers(from, to, tokenId, 1);
1072 
1073     // Clear approvals from the previous owner
1074     _approve(address(0), tokenId, prevOwnership.addr);
1075 
1076     _addressData[from].balance -= 1;
1077     _addressData[to].balance += 1;
1078     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1079 
1080     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1081     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1082     uint256 nextTokenId = tokenId + 1;
1083     if (_ownerships[nextTokenId].addr == address(0)) {
1084       if (_exists(nextTokenId)) {
1085         _ownerships[nextTokenId] = TokenOwnership(
1086           prevOwnership.addr,
1087           prevOwnership.startTimestamp
1088         );
1089       }
1090     }
1091 
1092     emit Transfer(from, to, tokenId);
1093     _afterTokenTransfers(from, to, tokenId, 1);
1094   }
1095 
1096   /**
1097    * @dev Approve `to` to operate on `tokenId`
1098    *
1099    * Emits a {Approval} event.
1100    */
1101   function _approve(
1102     address to,
1103     uint256 tokenId,
1104     address owner
1105   ) private {
1106     _tokenApprovals[tokenId] = to;
1107     emit Approval(owner, to, tokenId);
1108   }
1109 
1110   uint256 public nextOwnerToExplicitlySet = 0;
1111 
1112   /**
1113    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1114    */
1115   function _setOwnersExplicit(uint256 quantity) internal {
1116     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1117     require(quantity > 0, "quantity must be nonzero");
1118     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1119     if (endIndex > collectionSize - 1) {
1120       endIndex = collectionSize - 1;
1121     }
1122     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1123     require(_exists(endIndex), "not enough minted yet for this cleanup");
1124     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1125       if (_ownerships[i].addr == address(0)) {
1126         TokenOwnership memory ownership = ownershipOf(i);
1127         _ownerships[i] = TokenOwnership(
1128           ownership.addr,
1129           ownership.startTimestamp
1130         );
1131       }
1132     }
1133     nextOwnerToExplicitlySet = endIndex + 1;
1134   }
1135 
1136   /**
1137    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1138    * The call is not executed if the target address is not a contract.
1139    *
1140    * @param from address representing the previous owner of the given token ID
1141    * @param to target address that will receive the tokens
1142    * @param tokenId uint256 ID of the token to be transferred
1143    * @param _data bytes optional data to send along with the call
1144    * @return bool whether the call correctly returned the expected magic value
1145    */
1146   function _checkOnERC721Received(
1147     address from,
1148     address to,
1149     uint256 tokenId,
1150     bytes memory _data
1151   ) private returns (bool) {
1152     if (to.isContract()) {
1153       try
1154         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1155       returns (bytes4 retval) {
1156         return retval == IERC721Receiver(to).onERC721Received.selector;
1157       } catch (bytes memory reason) {
1158         if (reason.length == 0) {
1159           revert("ERC721A: transfer to non ERC721Receiver implementer");
1160         } else {
1161           assembly {
1162             revert(add(32, reason), mload(reason))
1163           }
1164         }
1165       }
1166     } else {
1167       return true;
1168     }
1169   }
1170 
1171   /**
1172    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1173    *
1174    * startTokenId - the first token id to be transferred
1175    * quantity - the amount to be transferred
1176    *
1177    * Calling conditions:
1178    *
1179    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1180    * transferred to `to`.
1181    * - When `from` is zero, `tokenId` will be minted for `to`.
1182    */
1183   function _beforeTokenTransfers(
1184     address from,
1185     address to,
1186     uint256 startTokenId,
1187     uint256 quantity
1188   ) internal virtual {}
1189 
1190   /**
1191    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1192    * minting.
1193    *
1194    * startTokenId - the first token id to be transferred
1195    * quantity - the amount to be transferred
1196    *
1197    * Calling conditions:
1198    *
1199    * - when `from` and `to` are both non-zero.
1200    * - `from` and `to` are never both zero.
1201    */
1202   function _afterTokenTransfers(
1203     address from,
1204     address to,
1205     uint256 startTokenId,
1206     uint256 quantity
1207   ) internal virtual {}
1208 }
1209 
1210 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1211 
1212 pragma solidity ^0.8.0;
1213 
1214 /**
1215  * @dev Contract module which provides a basic access control mechanism, where
1216  * there is an account (an owner) that can be granted exclusive access to
1217  * specific functions.
1218  *
1219  * By default, the owner account will be the one that deploys the contract. This
1220  * can later be changed with {transferOwnership}.
1221  *
1222  * This module is used through inheritance. It will make available the modifier
1223  * `onlyOwner`, which can be applied to your functions to restrict their use to
1224  * the owner.
1225  */
1226 abstract contract Ownable is Context {
1227     address private _owner;
1228 
1229     event OwnershipTransferred(
1230         address indexed previousOwner,
1231         address indexed newOwner
1232     );
1233 
1234     /**
1235      * @dev Initializes the contract setting the deployer as the initial owner.
1236      */
1237     constructor() {
1238         _transferOwnership(_msgSender());
1239     }
1240 
1241     /**
1242      * @dev Returns the address of the current owner.
1243      */
1244     function owner() public view virtual returns (address) {
1245         return _owner;
1246     }
1247 
1248     /**
1249      * @dev Throws if called by any account other than the owner.
1250      */
1251     modifier onlyOwner() {
1252         require(owner() == _msgSender(), "You are not the owner");
1253         _;
1254     }
1255 
1256     /**
1257      * @dev Leaves the contract without owner. It will not be possible to call
1258      * `onlyOwner` functions anymore. Can only be called by the current owner.
1259      *
1260      * NOTE: Renouncing ownership will leave the contract without an owner,
1261      * thereby removing any functionality that is only available to the owner.
1262      */
1263     function renounceOwnership() public virtual onlyOwner {
1264         _transferOwnership(address(0));
1265     }
1266 
1267     /**
1268      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1269      * Can only be called by the current owner.
1270      */
1271     function transferOwnership(address newOwner) public virtual onlyOwner {
1272         require(
1273             newOwner != address(0),
1274             "Ownable: new owner is the zero address"
1275         );
1276         _transferOwnership(newOwner);
1277     }
1278 
1279     /**
1280      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1281      * Internal function without access restriction.
1282      */
1283     function _transferOwnership(address newOwner) internal virtual {
1284         address oldOwner = _owner;
1285         _owner = newOwner;
1286         emit OwnershipTransferred(oldOwner, newOwner);
1287     }
1288 }
1289 
1290 pragma solidity ^0.8.7;
1291 
1292 contract ChicknKimono is ERC721A, Ownable {
1293     uint256 public Chick_PRICE = 0.01 ether;
1294     uint256 public MAX_Chicks = 3000;
1295     uint256 public OwnerMint = 10;
1296     uint256 public MAX_MINTS = 8;
1297     string public baseURI = "";
1298     string public baseExtension = ".json";
1299      bool public paused = true;   
1300     
1301     constructor() ERC721A("Chick'n Kimono", "CNK", MAX_MINTS, MAX_Chicks) { 
1302         
1303     }
1304     
1305 
1306     function mint(uint256 numTokens) public payable {
1307         require(!paused, "Paused");
1308         require(numTokens > 0 && numTokens <= MAX_MINTS);
1309         require(totalSupply() + numTokens <= MAX_Chicks);
1310         require(msg.value >= numTokens * Chick_PRICE, "Invalid funds provided");
1311         _safeMint(msg.sender, numTokens);
1312     }
1313     function Ownermint(uint256 numTokens) public onlyOwner{
1314         require(totalSupply() + numTokens <= OwnerMint);
1315         _safeMint(msg.sender, numTokens);
1316     }
1317 
1318     function pause(bool _state) public onlyOwner {
1319         paused = _state;
1320     }
1321     function setBaseURI(string memory newBaseURI) public onlyOwner {
1322         baseURI = newBaseURI;
1323     }
1324     function tokenURI(uint256 _tokenId)
1325         public
1326         view
1327         override
1328         returns (string memory)
1329     {
1330         require(_exists(_tokenId), "That token doesn't exist");
1331         return
1332             bytes(baseURI).length > 0
1333                 ? string(
1334                     abi.encodePacked(
1335                         baseURI,
1336                         Strings.toString(_tokenId),
1337                         baseExtension
1338                     )
1339                 )
1340                 : "";
1341     }
1342 
1343 
1344     function setPrice(uint256 newPrice) public onlyOwner {
1345         Chick_PRICE = newPrice;
1346     }
1347 
1348     function _baseURI() internal view virtual override returns (string memory) {
1349         return baseURI;
1350     }
1351 
1352     function withdraw() public onlyOwner {
1353         require(payable(msg.sender).send(address(this).balance));
1354     }
1355 }