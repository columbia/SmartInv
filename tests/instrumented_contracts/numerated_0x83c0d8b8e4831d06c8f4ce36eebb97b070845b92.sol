1 /**
2  *Submitted for verification at Etherscan.io on 2022-02-26
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
8 
9 //
10 //                                        .      .%@@(       .                    
11 //                               .    (@@@@@@@@@@@@@@@@@@@@/   .               
12 //                           .   ,@@@@@@.                 @@@@@                 
13 //                            @@@@@                          @@@@  .            
14 //                         @@@@#                               @@@.             
15 //                     @@@@/                                   @@@@            
16 //                   @@@@                            @@         %@@@           
17 //                 @@@@                    @@@@    @@@@@         @@@           
18 //            .  #@@@                     @@@@@   (@@@@           @@@          
19 //           .  @@@*                      @@@@     @@@            @@@  .       
20 //           .  @@@                                                 @@@         
21 //             #@@#                                                 @@@         
22 //            @@@                         @@.   %@@                @@@         
23 //             @@@                          @@@@@@                  @@@         
24 //            .@@@                                                 @@@         
25 //        .  *@@@                                                  @@@         
26 //       .  @@@#                                                   @@@         
27 //          @@@                                                     @@@         
28 //     .  @@@                                                      @@@         
29 //    .  @@@        (@@                                            @@@         
30 //     .  @@@     @@@@@@@@@       .@@@@@@@          @@@@           /@@(         
31 //       @@@@@@@@@&     @@@   @@@@@    @@@       @@@* @@@#        @@@  .       
32 //      .          .     @@@@@@%     .  @@@   (@@@@    *@@@     @@@@           
33 //                    .        .     .  &@@@@@@         @@@@@@@@@   .         
34 //                                     .       .                 .            
35                                                                                                                                                                
36 
37 pragma solidity ^0.8.0;
38 
39 library Address {
40 
41     function isContract(address account) internal view returns (bool) {
42 
43         uint256 size;
44         assembly {
45             size := extcodesize(account)
46         }
47         return size > 0;
48     }
49 
50     function sendValue(address payable recipient, uint256 amount) internal {
51         require(address(this).balance >= amount, "Address: insufficient balance");
52 
53         (bool success, ) = recipient.call{value: amount}("");
54         require(success, "Address: unable to send value, recipient may have reverted");
55     }
56 
57     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
58         return functionCall(target, data, "Address: low-level call failed");
59     }
60 
61     /**
62      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
63      * `errorMessage` as a fallback revert reason when `target` reverts.
64      *
65      * _Available since v3.1._
66      */
67     function functionCall(
68         address target,
69         bytes memory data,
70         string memory errorMessage
71     ) internal returns (bytes memory) {
72         return functionCallWithValue(target, data, 0, errorMessage);
73     }
74 
75     /**
76      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
77      * but also transferring `value` wei to `target`.
78      *
79      * Requirements:
80      *
81      * - the calling contract must have an ETH balance of at least `value`.
82      * - the called Solidity function must be `payable`.
83      *
84      * _Available since v3.1._
85      */
86     function functionCallWithValue(
87         address target,
88         bytes memory data,
89         uint256 value
90     ) internal returns (bytes memory) {
91         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
92     }
93 
94     /**
95      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
96      * with `errorMessage` as a fallback revert reason when `target` reverts.
97      *
98      * _Available since v3.1._
99      */
100     function functionCallWithValue(
101         address target,
102         bytes memory data,
103         uint256 value,
104         string memory errorMessage
105     ) internal returns (bytes memory) {
106         require(address(this).balance >= value, "Address: insufficient balance for call");
107         require(isContract(target), "Address: call to non-contract");
108 
109         (bool success, bytes memory returndata) = target.call{value: value}(data);
110         return verifyCallResult(success, returndata, errorMessage);
111     }
112 
113     /**
114      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
115      * but performing a static call.
116      *
117      * _Available since v3.3._
118      */
119     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
120         return functionStaticCall(target, data, "Address: low-level static call failed");
121     }
122 
123     /**
124      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
125      * but performing a static call.
126      *
127      * _Available since v3.3._
128      */
129     function functionStaticCall(
130         address target,
131         bytes memory data,
132         string memory errorMessage
133     ) internal view returns (bytes memory) {
134         require(isContract(target), "Address: static call to non-contract");
135 
136         (bool success, bytes memory returndata) = target.staticcall(data);
137         return verifyCallResult(success, returndata, errorMessage);
138     }
139 
140     /**
141      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
142      * but performing a delegate call.
143      *
144      * _Available since v3.4._
145      */
146     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
147         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
148     }
149 
150     /**
151      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
152      * but performing a delegate call.
153      *
154      * _Available since v3.4._
155      */
156     function functionDelegateCall(
157         address target,
158         bytes memory data,
159         string memory errorMessage
160     ) internal returns (bytes memory) {
161         require(isContract(target), "Address: delegate call to non-contract");
162 
163         (bool success, bytes memory returndata) = target.delegatecall(data);
164         return verifyCallResult(success, returndata, errorMessage);
165     }
166 
167     /**
168      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
169      * revert reason using the provided one.
170      *
171      * _Available since v4.3._
172      */
173     function verifyCallResult(
174         bool success,
175         bytes memory returndata,
176         string memory errorMessage
177     ) internal pure returns (bytes memory) {
178         if (success) {
179             return returndata;
180         } else {
181             // Look for revert reason and bubble it up if present
182             if (returndata.length > 0) {
183                 // The easiest way to bubble the revert reason is using memory via assembly
184 
185                 assembly {
186                     let returndata_size := mload(returndata)
187                     revert(add(32, returndata), returndata_size)
188                 }
189             } else {
190                 revert(errorMessage);
191             }
192         }
193     }
194 }
195 
196 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.2
197 pragma solidity ^0.8.0;
198 
199 /**
200  * @dev String operations.
201  */
202 library Strings {
203     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
204 
205     /**
206      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
207      */
208     function toString(uint256 value) internal pure returns (string memory) {
209         // Inspired by OraclizeAPI's implementation - MIT licence
210         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
211 
212         if (value == 0) {
213             return "0";
214         }
215         uint256 temp = value;
216         uint256 digits;
217         while (temp != 0) {
218             digits++;
219             temp /= 10;
220         }
221         bytes memory buffer = new bytes(digits);
222         while (value != 0) {
223             digits -= 1;
224             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
225             value /= 10;
226         }
227         return string(buffer);
228     }
229 
230     /**
231      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
232      */
233     function toHexString(uint256 value) internal pure returns (string memory) {
234         if (value == 0) {
235             return "0x00";
236         }
237         uint256 temp = value;
238         uint256 length = 0;
239         while (temp != 0) {
240             length++;
241             temp >>= 8;
242         }
243         return toHexString(value, length);
244     }
245 
246     /**
247      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
248      */
249     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
250         bytes memory buffer = new bytes(2 * length + 2);
251         buffer[0] = "0";
252         buffer[1] = "x";
253         for (uint256 i = 2 * length + 1; i > 1; --i) {
254             buffer[i] = _HEX_SYMBOLS[value & 0xf];
255             value >>= 4;
256         }
257         require(value == 0, "Strings: hex length insufficient");
258         return string(buffer);
259     }
260 }
261 
262 
263 // File @openzeppelin/contracts/utils/Counters.sol@v4.3.2
264 pragma solidity ^0.8.0;
265 
266 /**
267  * @title Counters
268  * @author Matt Condon (@shrugs)
269  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
270  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
271  *
272  * Include with `using Counters for Counters.Counter;`
273  */
274 library Counters {
275     struct Counter {
276         // This variable should never be directly accessed by users of the library: interactions must be restricted to
277         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
278         // this feature: see https://github.com/ethereum/solidity/issues/4637
279         uint256 _value; // default: 0
280     }
281 
282     function current(Counter storage counter) internal view returns (uint256) {
283         return counter._value;
284     }
285 
286     function increment(Counter storage counter) internal {
287         unchecked {
288             counter._value += 1;
289         }
290     }
291 
292     function decrement(Counter storage counter) internal {
293         uint256 value = counter._value;
294         require(value > 0, "Counter: decrement overflow");
295         unchecked {
296             counter._value = value - 1;
297         }
298     }
299 
300     function reset(Counter storage counter) internal {
301         counter._value = 0;
302     }
303 }
304 
305 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.2
306 pragma solidity ^0.8.0;
307 
308 /**
309  * @dev Interface of the ERC165 standard, as defined in the
310  * https://eips.ethereum.org/EIPS/eip-165[EIP].
311  *
312  * Implementers can declare support of contract interfaces, which can then be
313  * queried by others ({ERC165Checker}).
314  *
315  * For an implementation, see {ERC165}.
316  */
317 interface IERC165 {
318     /**
319      * @dev Returns true if this contract implements the interface defined by
320      * `interfaceId`. See the corresponding
321      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
322      * to learn more about how these ids are created.
323      *
324      * This function call must use less than 30 000 gas.
325      */
326     function supportsInterface(bytes4 interfaceId) external view returns (bool);
327 }
328 
329 
330 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.2
331 pragma solidity ^0.8.0;
332 
333 /**
334  * @dev Required interface of an ERC721 compliant contract.
335  */
336 interface IERC721 is IERC165 {
337     /**
338      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
339      */
340     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
341 
342     /**
343      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
344      */
345     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
346 
347     /**
348      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
349      */
350     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
351 
352     /**
353      * @dev Returns the number of tokens in ``owner``'s account.
354      */
355     function balanceOf(address owner) external view returns (uint256 balance);
356 
357     /**
358      * @dev Returns the owner of the `tokenId` token.
359      *
360      * Requirements:
361      *
362      * - `tokenId` must exist.
363      */
364     function ownerOf(uint256 tokenId) external view returns (address owner);
365 
366     /**
367      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
368      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
369      *
370      * Requirements:
371      *
372      * - `from` cannot be the zero address.
373      * - `to` cannot be the zero address.
374      * - `tokenId` token must exist and be owned by `from`.
375      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
376      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
377      *
378      * Emits a {Transfer} event.
379      */
380     function safeTransferFrom(
381         address from,
382         address to,
383         uint256 tokenId
384     ) external;
385 
386     /**
387      * @dev Transfers `tokenId` token from `from` to `to`.
388      *
389      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
390      *
391      * Requirements:
392      *
393      * - `from` cannot be the zero address.
394      * - `to` cannot be the zero address.
395      * - `tokenId` token must be owned by `from`.
396      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
397      *
398      * Emits a {Transfer} event.
399      */
400     function transferFrom(
401         address from,
402         address to,
403         uint256 tokenId
404     ) external;
405 
406     /**
407      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
408      * The approval is cleared when the token is transferred.
409      *
410      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
411      *
412      * Requirements:
413      *
414      * - The caller must own the token or be an approved operator.
415      * - `tokenId` must exist.
416      *
417      * Emits an {Approval} event.
418      */
419     function approve(address to, uint256 tokenId) external;
420 
421     /**
422      * @dev Returns the account approved for `tokenId` token.
423      *
424      * Requirements:
425      *
426      * - `tokenId` must exist.
427      */
428     function getApproved(uint256 tokenId) external view returns (address operator);
429 
430     /**
431      * @dev Approve or remove `operator` as an operator for the caller.
432      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
433      *
434      * Requirements:
435      *
436      * - The `operator` cannot be the caller.
437      *
438      * Emits an {ApprovalForAll} event.
439      */
440     function setApprovalForAll(address operator, bool _approved) external;
441 
442     /**
443      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
444      *
445      * See {setApprovalForAll}
446      */
447     function isApprovedForAll(address owner, address operator) external view returns (bool);
448 
449     /**
450      * @dev Safely transfers `tokenId` token from `from` to `to`.
451      *
452      * Requirements:
453      *
454      * - `from` cannot be the zero address.
455      * - `to` cannot be the zero address.
456      * - `tokenId` token must exist and be owned by `from`.
457      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
458      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
459      *
460      * Emits a {Transfer} event.
461      */
462     function safeTransferFrom(
463         address from,
464         address to,
465         uint256 tokenId,
466         bytes calldata data
467     ) external;
468 }
469 
470 
471 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.2
472 pragma solidity ^0.8.0;
473 
474 /**
475  * @title ERC721 token receiver interface
476  * @dev Interface for any contract that wants to support safeTransfers
477  * from ERC721 asset contracts.
478  */
479 interface IERC721Receiver {
480     /**
481      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
482      * by `operator` from `from`, this function is called.
483      *
484      * It must return its Solidity selector to confirm the token transfer.
485      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
486      *
487      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
488      */
489     function onERC721Received(
490         address operator,
491         address from,
492         uint256 tokenId,
493         bytes calldata data
494     ) external returns (bytes4);
495 }
496 
497 
498 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.2
499 pragma solidity ^0.8.0;
500 
501 /**
502  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
503  * @dev See https://eips.ethereum.org/EIPS/eip-721
504  */
505 interface IERC721Metadata is IERC721 {
506     /**
507      * @dev Returns the token collection name.
508      */
509     function name() external view returns (string memory);
510 
511     /**
512      * @dev Returns the token collection symbol.
513      */
514     function symbol() external view returns (string memory);
515 
516     /**
517      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
518      */
519     function tokenURI(uint256 tokenId) external view returns (string memory);
520 }
521 
522 
523 
524 
525 
526 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
527 pragma solidity ^0.8.0;
528 
529 /**
530  * @dev Provides information about the current execution context, including the
531  * sender of the transaction and its data. While these are generally available
532  * via msg.sender and msg.data, they should not be accessed in such a direct
533  * manner, since when dealing with meta-transactions the account sending and
534  * paying for execution may not be the actual sender (as far as an application
535  * is concerned).
536  *
537  * This contract is only required for intermediate, library-like contracts.
538  */
539 abstract contract Context {
540     function _msgSender() internal view virtual returns (address) {
541         return msg.sender;
542     }
543 
544     function _msgData() internal view virtual returns (bytes calldata) {
545         return msg.data;
546     }
547 }
548 
549 
550 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
551 pragma solidity ^0.8.0;
552 
553 /**
554  * @dev Implementation of the {IERC165} interface.
555  *
556  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
557  * for the additional interface id that will be supported. For example:
558  *
559  * ```solidity
560  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
561  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
562  * }
563  * ```
564  *
565  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
566  */
567 abstract contract ERC165 is IERC165 {
568     /**
569      * @dev See {IERC165-supportsInterface}.
570      */
571     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
572         return interfaceId == type(IERC165).interfaceId;
573     }
574 }
575 
576 
577 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.2
578 pragma solidity ^0.8.0;
579 
580 /**
581  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
582  * the Metadata extension, but not including the Enumerable extension, which is available separately as
583  * {ERC721Enumerable}.
584  */
585 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
586     using Address for address;
587     using Strings for uint256;
588 
589     // Token name
590     string private _name;
591 
592     // Token symbol
593     string private _symbol;
594 
595     // Mapping from token ID to owner address
596     mapping(uint256 => address) private _owners;
597 
598     // Mapping owner address to token count
599     mapping(address => uint256) private _balances;
600 
601     // Mapping from token ID to approved address
602     mapping(uint256 => address) private _tokenApprovals;
603 
604     // Mapping from owner to operator approvals
605     mapping(address => mapping(address => bool)) private _operatorApprovals;
606 
607     /**
608      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
609      */
610     constructor(string memory name_, string memory symbol_) {
611         _name = name_;
612         _symbol = symbol_;
613     }
614 
615     /**
616      * @dev See {IERC165-supportsInterface}.
617      */
618     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
619         return
620             interfaceId == type(IERC721).interfaceId ||
621             interfaceId == type(IERC721Metadata).interfaceId ||
622             super.supportsInterface(interfaceId);
623     }
624 
625     /**
626      * @dev See {IERC721-balanceOf}.
627      */
628     function balanceOf(address owner) public view virtual override returns (uint256) {
629         require(owner != address(0), "ERC721: balance query for the zero address");
630         return _balances[owner];
631     }
632 
633     /**
634      * @dev See {IERC721-ownerOf}.
635      */
636     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
637         address owner = _owners[tokenId];
638         require(owner != address(0), "ERC721: owner query for nonexistent token");
639         return owner;
640     }
641 
642     /**
643      * @dev See {IERC721Metadata-name}.
644      */
645     function name() public view virtual override returns (string memory) {
646         return _name;
647     }
648 
649     /**
650      * @dev See {IERC721Metadata-symbol}.
651      */
652     function symbol() public view virtual override returns (string memory) {
653         return _symbol;
654     }
655 
656     /**
657      * @dev See {IERC721Metadata-tokenURI}.
658      */
659     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
660         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
661 
662         string memory baseURI = _baseURI();
663         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
664     }
665 
666     /**
667      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
668      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
669      * by default, can be overriden in child contracts.
670      */
671     function _baseURI() internal view virtual returns (string memory) {
672         return "";
673     }
674 
675     /**
676      * @dev See {IERC721-approve}.
677      */
678     function approve(address to, uint256 tokenId) public virtual override {
679         address owner = ERC721.ownerOf(tokenId);
680         require(to != owner, "ERC721: approval to current owner");
681 
682         require(
683             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
684             "ERC721: approve caller is not owner nor approved for all"
685         );
686 
687         _approve(to, tokenId);
688     }
689 
690     /**
691      * @dev See {IERC721-getApproved}.
692      */
693     function getApproved(uint256 tokenId) public view virtual override returns (address) {
694         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
695 
696         return _tokenApprovals[tokenId];
697     }
698 
699     /**
700      * @dev See {IERC721-setApprovalForAll}.
701      */
702     function setApprovalForAll(address operator, bool approved) public virtual override {
703         require(operator != _msgSender(), "ERC721: approve to caller");
704 
705         _operatorApprovals[_msgSender()][operator] = approved;
706         emit ApprovalForAll(_msgSender(), operator, approved);
707     }
708 
709     /**
710      * @dev See {IERC721-isApprovedForAll}.
711      */
712     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
713         return _operatorApprovals[owner][operator];
714     }
715 
716     /**
717      * @dev See {IERC721-transferFrom}.
718      */
719     function transferFrom(
720         address from,
721         address to,
722         uint256 tokenId
723     ) public virtual override {
724         //solhint-disable-next-line max-line-length
725         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
726 
727         _transfer(from, to, tokenId);
728     }
729 
730     /**
731      * @dev See {IERC721-safeTransferFrom}.
732      */
733     function safeTransferFrom(
734         address from,
735         address to,
736         uint256 tokenId
737     ) public virtual override {
738         safeTransferFrom(from, to, tokenId, "");
739     }
740 
741     /**
742      * @dev See {IERC721-safeTransferFrom}.
743      */
744     function safeTransferFrom(
745         address from,
746         address to,
747         uint256 tokenId,
748         bytes memory _data
749     ) public virtual override {
750         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
751         _safeTransfer(from, to, tokenId, _data);
752     }
753 
754     /**
755      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
756      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
757      *
758      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
759      *
760      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
761      * implement alternative mechanisms to perform token transfer, such as signature-based.
762      *
763      * Requirements:
764      *
765      * - `from` cannot be the zero address.
766      * - `to` cannot be the zero address.
767      * - `tokenId` token must exist and be owned by `from`.
768      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
769      *
770      * Emits a {Transfer} event.
771      */
772     function _safeTransfer(
773         address from,
774         address to,
775         uint256 tokenId,
776         bytes memory _data
777     ) internal virtual {
778         _transfer(from, to, tokenId);
779         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
780     }
781 
782     /**
783      * @dev Returns whether `tokenId` exists.
784      *
785      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
786      *
787      * Tokens start existing when they are minted (`_mint`),
788      * and stop existing when they are burned (`_burn`).
789      */
790     function _exists(uint256 tokenId) internal view virtual returns (bool) {
791         return _owners[tokenId] != address(0);
792     }
793 
794     /**
795      * @dev Returns whether `spender` is allowed to manage `tokenId`.
796      *
797      * Requirements:
798      *
799      * - `tokenId` must exist.
800      */
801     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
802         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
803         address owner = ERC721.ownerOf(tokenId);
804         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
805     }
806 
807     /**
808      * @dev Safely mints `tokenId` and transfers it to `to`.
809      *
810      * Requirements:
811      *
812      * - `tokenId` must not exist.
813      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
814      *
815      * Emits a {Transfer} event.
816      */
817     function _safeMint(address to, uint256 tokenId) internal virtual {
818         _safeMint(to, tokenId, "");
819     }
820 
821     /**
822      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
823      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
824      */
825     function _safeMint(
826         address to,
827         uint256 tokenId,
828         bytes memory _data
829     ) internal virtual {
830         _mint(to, tokenId);
831         require(
832             _checkOnERC721Received(address(0), to, tokenId, _data),
833             "ERC721: transfer to non ERC721Receiver implementer"
834         );
835     }
836 
837     /**
838      * @dev Mints `tokenId` and transfers it to `to`.
839      *
840      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
841      *
842      * Requirements:
843      *
844      * - `tokenId` must not exist.
845      * - `to` cannot be the zero address.
846      *
847      * Emits a {Transfer} event.
848      */
849     function _mint(address to, uint256 tokenId) internal virtual {
850         require(to != address(0), "ERC721: mint to the zero address");
851         require(!_exists(tokenId), "ERC721: token already minted");
852 
853         _beforeTokenTransfer(address(0), to, tokenId);
854 
855         _balances[to] += 1;
856         _owners[tokenId] = to;
857 
858         emit Transfer(address(0), to, tokenId);
859     }
860 
861     /**
862      * @dev Destroys `tokenId`.
863      * The approval is cleared when the token is burned.
864      *
865      * Requirements:
866      *
867      * - `tokenId` must exist.
868      *
869      * Emits a {Transfer} event.
870      */
871     function _burn(uint256 tokenId) internal virtual {
872         address owner = ERC721.ownerOf(tokenId);
873 
874         _beforeTokenTransfer(owner, address(0), tokenId);
875 
876         // Clear approvals
877         _approve(address(0), tokenId);
878 
879         _balances[owner] -= 1;
880         delete _owners[tokenId];
881 
882         emit Transfer(owner, address(0), tokenId);
883     }
884 
885     /**
886      * @dev Transfers `tokenId` from `from` to `to`.
887      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
888      *
889      * Requirements:
890      *
891      * - `to` cannot be the zero address.
892      * - `tokenId` token must be owned by `from`.
893      *
894      * Emits a {Transfer} event.
895      */
896     function _transfer(
897         address from,
898         address to,
899         uint256 tokenId
900     ) internal virtual {
901         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
902         require(to != address(0), "ERC721: transfer to the zero address");
903 
904         _beforeTokenTransfer(from, to, tokenId);
905 
906         // Clear approvals from the previous owner
907         _approve(address(0), tokenId);
908 
909         _balances[from] -= 1;
910         _balances[to] += 1;
911         _owners[tokenId] = to;
912 
913         emit Transfer(from, to, tokenId);
914     }
915 
916     /**
917      * @dev Approve `to` to operate on `tokenId`
918      *
919      * Emits a {Approval} event.
920      */
921     function _approve(address to, uint256 tokenId) internal virtual {
922         _tokenApprovals[tokenId] = to;
923         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
924     }
925 
926     /**
927      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
928      * The call is not executed if the target address is not a contract.
929      *
930      * @param from address representing the previous owner of the given token ID
931      * @param to target address that will receive the tokens
932      * @param tokenId uint256 ID of the token to be transferred
933      * @param _data bytes optional data to send along with the call
934      * @return bool whether the call correctly returned the expected magic value
935      */
936     function _checkOnERC721Received(
937         address from,
938         address to,
939         uint256 tokenId,
940         bytes memory _data
941     ) private returns (bool) {
942         if (to.isContract()) {
943             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
944                 return retval == IERC721Receiver.onERC721Received.selector;
945             } catch (bytes memory reason) {
946                 if (reason.length == 0) {
947                     revert("ERC721: transfer to non ERC721Receiver implementer");
948                 } else {
949                     assembly {
950                         revert(add(32, reason), mload(reason))
951                     }
952                 }
953             }
954         } else {
955             return true;
956         }
957     }
958 
959     /**
960      * @dev Hook that is called before any token transfer. This includes minting
961      * and burning.
962      *
963      * Calling conditions:
964      *
965      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
966      * transferred to `to`.
967      * - When `from` is zero, `tokenId` will be minted for `to`.
968      * - When `to` is zero, ``from``'s `tokenId` will be burned.
969      * - `from` and `to` are never both zero.
970      *
971      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
972      */
973     function _beforeTokenTransfer(
974         address from,
975         address to,
976         uint256 tokenId
977     ) internal virtual {}
978 }
979 
980 
981 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.2
982 
983 
984 pragma solidity ^0.8.0;
985 
986 /**
987  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
988  * @dev See https://eips.ethereum.org/EIPS/eip-721
989  */
990 interface IERC721Enumerable is IERC721 {
991     /**
992      * @dev Returns the total amount of tokens stored by the contract.
993      */
994     function totalSupply() external view returns (uint256);
995 
996     /**
997      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
998      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
999      */
1000     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1001 
1002     /**
1003      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1004      * Use along with {totalSupply} to enumerate all tokens.
1005      */
1006     function tokenByIndex(uint256 index) external view returns (uint256);
1007 }
1008 
1009 
1010 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.2
1011 
1012 
1013 pragma solidity ^0.8.0;
1014 
1015 
1016 /**
1017  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1018  * enumerability of all the token ids in the contract as well as all token ids owned by each
1019  * account.
1020  */
1021 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1022     // Mapping from owner to list of owned token IDs
1023     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1024 
1025     // Mapping from token ID to index of the owner tokens list
1026     mapping(uint256 => uint256) private _ownedTokensIndex;
1027 
1028     // Array with all token ids, used for enumeration
1029     uint256[] private _allTokens;
1030 
1031     // Mapping from token id to position in the allTokens array
1032     mapping(uint256 => uint256) private _allTokensIndex;
1033 
1034     /**
1035      * @dev See {IERC165-supportsInterface}.
1036      */
1037     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1038         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1039     }
1040 
1041     /**
1042      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1043      */
1044     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1045         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1046         return _ownedTokens[owner][index];
1047     }
1048 
1049     /**
1050      * @dev See {IERC721Enumerable-totalSupply}.
1051      */
1052     function totalSupply() public view virtual override returns (uint256) {
1053         return _allTokens.length;
1054     }
1055 
1056     /**
1057      * @dev See {IERC721Enumerable-tokenByIndex}.
1058      */
1059     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1060         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1061         return _allTokens[index];
1062     }
1063 
1064     /**
1065      * @dev Hook that is called before any token transfer. This includes minting
1066      * and burning.
1067      *
1068      * Calling conditions:
1069      *
1070      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1071      * transferred to `to`.
1072      * - When `from` is zero, `tokenId` will be minted for `to`.
1073      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1074      * - `from` cannot be the zero address.
1075      * - `to` cannot be the zero address.
1076      *
1077      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1078      */
1079     function _beforeTokenTransfer(
1080         address from,
1081         address to,
1082         uint256 tokenId
1083     ) internal virtual override {
1084         super._beforeTokenTransfer(from, to, tokenId);
1085 
1086         if (from == address(0)) {
1087             _addTokenToAllTokensEnumeration(tokenId);
1088         } else if (from != to) {
1089             _removeTokenFromOwnerEnumeration(from, tokenId);
1090         }
1091         if (to == address(0)) {
1092             _removeTokenFromAllTokensEnumeration(tokenId);
1093         } else if (to != from) {
1094             _addTokenToOwnerEnumeration(to, tokenId);
1095         }
1096     }
1097 
1098     /**
1099      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1100      * @param to address representing the new owner of the given token ID
1101      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1102      */
1103     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1104         uint256 length = ERC721.balanceOf(to);
1105         _ownedTokens[to][length] = tokenId;
1106         _ownedTokensIndex[tokenId] = length;
1107     }
1108 
1109     /**
1110      * @dev Private function to add a token to this extension's token tracking data structures.
1111      * @param tokenId uint256 ID of the token to be added to the tokens list
1112      */
1113     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1114         _allTokensIndex[tokenId] = _allTokens.length;
1115         _allTokens.push(tokenId);
1116     }
1117 
1118     /**
1119      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1120      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1121      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1122      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1123      * @param from address representing the previous owner of the given token ID
1124      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1125      */
1126     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1127         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1128         // then delete the last slot (swap and pop).
1129 
1130         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1131         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1132 
1133         // When the token to delete is the last token, the swap operation is unnecessary
1134         if (tokenIndex != lastTokenIndex) {
1135             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1136 
1137             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1138             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1139         }
1140 
1141         // This also deletes the contents at the last position of the array
1142         delete _ownedTokensIndex[tokenId];
1143         delete _ownedTokens[from][lastTokenIndex];
1144     }
1145 
1146     /**
1147      * @dev Private function to remove a token from this extension's token tracking data structures.
1148      * This has O(1) time complexity, but alters the order of the _allTokens array.
1149      * @param tokenId uint256 ID of the token to be removed from the tokens list
1150      */
1151     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1152         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1153         // then delete the last slot (swap and pop).
1154 
1155         uint256 lastTokenIndex = _allTokens.length - 1;
1156         uint256 tokenIndex = _allTokensIndex[tokenId];
1157 
1158         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1159         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1160         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1161         uint256 lastTokenId = _allTokens[lastTokenIndex];
1162 
1163         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1164         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1165 
1166         // This also deletes the contents at the last position of the array
1167         delete _allTokensIndex[tokenId];
1168         _allTokens.pop();
1169     }
1170 }
1171 
1172 /**
1173  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1174  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1175  *
1176  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1177  *
1178  * Does not support burning tokens to address(0).
1179  */
1180 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1181     using Address for address;
1182     using Strings for uint256;
1183 
1184     struct TokenOwnership {
1185         address addr;
1186         uint64 startTimestamp;
1187     }
1188 
1189     struct AddressData {
1190         uint128 balance;
1191         uint128 numberMinted;
1192     }
1193 
1194     uint256 private currentIndex = 1;
1195 
1196      uint256 internal immutable maxBatchSize;
1197 
1198     // Token name
1199     string private _name;
1200 
1201     // Token symbol
1202     string private _symbol;
1203 
1204     // Mapping from token ID to ownership details
1205     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1206     mapping(uint256 => TokenOwnership) private _ownerships;
1207 
1208     // Mapping owner address to address data
1209     mapping(address => AddressData) private _addressData;
1210 
1211     // Mapping from token ID to approved address
1212     mapping(uint256 => address) private _tokenApprovals;
1213 
1214     // Mapping from owner to operator approvals
1215     mapping(address => mapping(address => bool)) private _operatorApprovals;
1216 
1217     /**
1218      * @dev
1219      * `maxBatchSize` refers to how much a minter can mint at a time.
1220      */
1221     constructor(
1222         string memory name_,
1223         string memory symbol_,
1224         uint256 maxBatchSize_
1225     ) {
1226         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1227         _name = name_;
1228         _symbol = symbol_;
1229         maxBatchSize = maxBatchSize_;
1230     }
1231 
1232     /**
1233      * @dev See {IERC721Enumerable-totalSupply}.
1234      */
1235     function totalSupply() public view override returns (uint256) {
1236         return currentIndex;
1237     }
1238 
1239     /**
1240      * @dev See {IERC721Enumerable-tokenByIndex}.
1241      */
1242     function tokenByIndex(uint256 index) public view override returns (uint256) {
1243         require(index < totalSupply(), "ERC721A: global index out of bounds");
1244         return index;
1245     }
1246 
1247     /**
1248      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1249      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1250      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1251      */
1252     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1253         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1254         uint256 numMintedSoFar = totalSupply();
1255         uint256 tokenIdsIdx = 0;
1256         address currOwnershipAddr = address(0);
1257         for (uint256 i = 0; i < numMintedSoFar; i++) {
1258             TokenOwnership memory ownership = _ownerships[i];
1259             if (ownership.addr != address(0)) {
1260                 currOwnershipAddr = ownership.addr;
1261             }
1262             if (currOwnershipAddr == owner) {
1263                 if (tokenIdsIdx == index) {
1264                     return i;
1265                 }
1266                 tokenIdsIdx++;
1267             }
1268         }
1269         revert("ERC721A: unable to get token of owner by index");
1270     }
1271 
1272     /**
1273      * @dev See {IERC165-supportsInterface}.
1274      */
1275     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1276         return
1277             interfaceId == type(IERC721).interfaceId ||
1278             interfaceId == type(IERC721Metadata).interfaceId ||
1279             interfaceId == type(IERC721Enumerable).interfaceId ||
1280             super.supportsInterface(interfaceId);
1281     }
1282 
1283     /**
1284      * @dev See {IERC721-balanceOf}.
1285      */
1286     function balanceOf(address owner) public view override returns (uint256) {
1287         require(owner != address(0), "ERC721A: balance query for the zero address");
1288         return uint256(_addressData[owner].balance);
1289     }
1290 
1291     function _numberMinted(address owner) internal view returns (uint256) {
1292         require(owner != address(0), "ERC721A: number minted query for the zero address");
1293         return uint256(_addressData[owner].numberMinted);
1294     }
1295 
1296     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1297         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1298 
1299         uint256 lowestTokenToCheck;
1300         if (tokenId >= maxBatchSize) {
1301             lowestTokenToCheck = tokenId - maxBatchSize + 1;
1302         }
1303 
1304         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1305             TokenOwnership memory ownership = _ownerships[curr];
1306             if (ownership.addr != address(0)) {
1307                 return ownership;
1308             }
1309         }
1310 
1311         revert("ERC721A: unable to determine the owner of token");
1312     }
1313 
1314     /**
1315      * @dev See {IERC721-ownerOf}.
1316      */
1317     function ownerOf(uint256 tokenId) public view override returns (address) {
1318         return ownershipOf(tokenId).addr;
1319     }
1320 
1321     /**
1322      * @dev See {IERC721Metadata-name}.
1323      */
1324     function name() public view virtual override returns (string memory) {
1325         return _name;
1326     }
1327 
1328     /**
1329      * @dev See {IERC721Metadata-symbol}.
1330      */
1331     function symbol() public view virtual override returns (string memory) {
1332         return _symbol;
1333     }
1334 
1335     /**
1336      * @dev See {IERC721Metadata-tokenURI}.
1337      */
1338     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1339         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1340 
1341         string memory baseURI = _baseURI();
1342         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1343     }
1344 
1345     /**
1346      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1347      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1348      * by default, can be overriden in child contracts.
1349      */
1350     function _baseURI() internal view virtual returns (string memory) {
1351         return "";
1352     }
1353 
1354     /**
1355      * @dev See {IERC721-approve}.
1356      */
1357     function approve(address to, uint256 tokenId) public override {
1358         address owner = ERC721A.ownerOf(tokenId);
1359         require(to != owner, "ERC721A: approval to current owner");
1360 
1361         require(
1362             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1363             "ERC721A: approve caller is not owner nor approved for all"
1364         );
1365 
1366         _approve(to, tokenId, owner);
1367     }
1368 
1369     /**
1370      * @dev See {IERC721-getApproved}.
1371      */
1372     function getApproved(uint256 tokenId) public view override returns (address) {
1373         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1374 
1375         return _tokenApprovals[tokenId];
1376     }
1377 
1378     /**
1379      * @dev See {IERC721-setApprovalForAll}.
1380      */
1381     function setApprovalForAll(address operator, bool approved) public override {
1382         require(operator != _msgSender(), "ERC721A: approve to caller");
1383 
1384         _operatorApprovals[_msgSender()][operator] = approved;
1385         emit ApprovalForAll(_msgSender(), operator, approved);
1386     }
1387 
1388     /**
1389      * @dev See {IERC721-isApprovedForAll}.
1390      */
1391     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1392         return _operatorApprovals[owner][operator];
1393     }
1394 
1395     /**
1396      * @dev See {IERC721-transferFrom}.
1397      */
1398     function transferFrom(
1399         address from,
1400         address to,
1401         uint256 tokenId
1402     ) public override {
1403         _transfer(from, to, tokenId);
1404     }
1405 
1406     /**
1407      * @dev See {IERC721-safeTransferFrom}.
1408      */
1409     function safeTransferFrom(
1410         address from,
1411         address to,
1412         uint256 tokenId
1413     ) public override {
1414         safeTransferFrom(from, to, tokenId, "");
1415     }
1416 
1417     /**
1418      * @dev See {IERC721-safeTransferFrom}.
1419      */
1420     function safeTransferFrom(
1421         address from,
1422         address to,
1423         uint256 tokenId,
1424         bytes memory _data
1425     ) public override {
1426         _transfer(from, to, tokenId);
1427         require(
1428             _checkOnERC721Received(from, to, tokenId, _data),
1429             "ERC721A: transfer to non ERC721Receiver implementer"
1430         );
1431     }
1432 
1433     /**
1434      * @dev Returns whether `tokenId` exists.
1435      *
1436      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1437      *
1438      * Tokens start existing when they are minted (`_mint`),
1439      */
1440     function _exists(uint256 tokenId) internal view returns (bool) {
1441         return tokenId < currentIndex;
1442     }
1443 
1444     function _safeMint(address to, uint256 quantity) internal {
1445         _safeMint(to, quantity, "");
1446     }
1447 
1448     /**
1449      * @dev Mints `quantity` tokens and transfers them to `to`.
1450      *
1451      * Requirements:
1452      *
1453      * - `to` cannot be the zero address.
1454      * - `quantity` cannot be larger than the max batch size.
1455      *
1456      * Emits a {Transfer} event.
1457      */
1458     function _safeMint(
1459         address to,
1460         uint256 quantity,
1461         bytes memory _data
1462     ) internal {
1463         uint256 startTokenId = currentIndex;
1464         require(to != address(0), "ERC721A: mint to the zero address");
1465         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1466         require(!_exists(startTokenId), "ERC721A: token already minted");
1467         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1468 
1469         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1470 
1471         AddressData memory addressData = _addressData[to];
1472         _addressData[to] = AddressData(
1473             addressData.balance + uint128(quantity),
1474             addressData.numberMinted + uint128(quantity)
1475         );
1476         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1477 
1478         uint256 updatedIndex = startTokenId;
1479 
1480         for (uint256 i = 0; i < quantity; i++) {
1481             emit Transfer(address(0), to, updatedIndex);
1482             require(
1483                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1484                 "ERC721A: transfer to non ERC721Receiver implementer"
1485             );
1486             updatedIndex++;
1487         }
1488 
1489         currentIndex = updatedIndex;
1490         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1491     }
1492 
1493     /**
1494      * @dev Transfers `tokenId` from `from` to `to`.
1495      *
1496      * Requirements:
1497      *
1498      * - `to` cannot be the zero address.
1499      * - `tokenId` token must be owned by `from`.
1500      *
1501      * Emits a {Transfer} event.
1502      */
1503     function _transfer(
1504         address from,
1505         address to,
1506         uint256 tokenId
1507     ) private {
1508         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1509 
1510         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1511             getApproved(tokenId) == _msgSender() ||
1512             isApprovedForAll(prevOwnership.addr, _msgSender()));
1513 
1514         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1515 
1516         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1517         require(to != address(0), "ERC721A: transfer to the zero address");
1518 
1519         _beforeTokenTransfers(from, to, tokenId, 1);
1520 
1521         // Clear approvals from the previous owner
1522         _approve(address(0), tokenId, prevOwnership.addr);
1523 
1524         _addressData[from].balance -= 1;
1525         _addressData[to].balance += 1;
1526         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1527 
1528         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1529         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1530         uint256 nextTokenId = tokenId + 1;
1531         if (_ownerships[nextTokenId].addr == address(0)) {
1532             if (_exists(nextTokenId)) {
1533                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1534             }
1535         }
1536 
1537         emit Transfer(from, to, tokenId);
1538         _afterTokenTransfers(from, to, tokenId, 1);
1539     }
1540 
1541     /**
1542      * @dev Approve `to` to operate on `tokenId`
1543      *
1544      * Emits a {Approval} event.
1545      */
1546     function _approve(
1547         address to,
1548         uint256 tokenId,
1549         address owner
1550     ) private {
1551         _tokenApprovals[tokenId] = to;
1552         emit Approval(owner, to, tokenId);
1553     }
1554 
1555     uint256 public nextOwnerToExplicitlySet = 0;
1556 
1557     /**
1558      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1559      */
1560     function _setOwnersExplicit(uint256 quantity) internal {
1561         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1562         require(quantity > 0, "quantity must be nonzero");
1563         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1564         if (endIndex > currentIndex - 1) {
1565             endIndex = currentIndex - 1;
1566         }
1567         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1568         require(_exists(endIndex), "not enough minted yet for this cleanup");
1569         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1570             if (_ownerships[i].addr == address(0)) {
1571                 TokenOwnership memory ownership = ownershipOf(i);
1572                 _ownerships[i] = TokenOwnership(ownership.addr, ownership.startTimestamp);
1573             }
1574         }
1575         nextOwnerToExplicitlySet = endIndex + 1;
1576     }
1577 
1578     /**
1579      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1580      * The call is not executed if the target address is not a contract.
1581      *
1582      * @param from address representing the previous owner of the given token ID
1583      * @param to target address that will receive the tokens
1584      * @param tokenId uint256 ID of the token to be transferred
1585      * @param _data bytes optional data to send along with the call
1586      * @return bool whether the call correctly returned the expected magic value
1587      */
1588     function _checkOnERC721Received(
1589         address from,
1590         address to,
1591         uint256 tokenId,
1592         bytes memory _data
1593     ) private returns (bool) {
1594         if (to.isContract()) {
1595             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1596                 return retval == IERC721Receiver(to).onERC721Received.selector;
1597             } catch (bytes memory reason) {
1598                 if (reason.length == 0) {
1599                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1600                 } else {
1601                     assembly {
1602                         revert(add(32, reason), mload(reason))
1603                     }
1604                 }
1605             }
1606         } else {
1607             return true;
1608         }
1609     }
1610 
1611     /**
1612      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1613      *
1614      * startTokenId - the first token id to be transferred
1615      * quantity - the amount to be transferred
1616      *
1617      * Calling conditions:
1618      *
1619      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1620      * transferred to `to`.
1621      * - When `from` is zero, `tokenId` will be minted for `to`.
1622      */
1623     function _beforeTokenTransfers(
1624         address from,
1625         address to,
1626         uint256 startTokenId,
1627         uint256 quantity
1628     ) internal virtual {}
1629 
1630     /**
1631      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1632      * minting.
1633      *
1634      * startTokenId - the first token id to be transferred
1635      * quantity - the amount to be transferred
1636      *
1637      * Calling conditions:
1638      *
1639      * - when `from` and `to` are both non-zero.
1640      * - `from` and `to` are never both zero.
1641      */
1642     function _afterTokenTransfers(
1643         address from,
1644         address to,
1645         uint256 startTokenId,
1646         uint256 quantity
1647     ) internal virtual {}
1648 }
1649 
1650 pragma solidity ^0.8.0;
1651 
1652 contract ghostown is ERC721A
1653 {
1654     using Strings for uint256;
1655 
1656     string public baseURI;
1657     uint256 public cost;
1658     uint256 public maxSupply;
1659     uint256 public maxMintAmount = 42;
1660     uint256 public maxMintPerTransaction = 42;
1661     address public owner;
1662     bool public preSaleLive;
1663     bool public mintLive;
1664 
1665     mapping(address => bool) private whiteList;
1666     mapping(address => uint256) private mintCount;
1667 
1668     modifier onlyOwner() {
1669         require(owner == msg.sender, "not owner");
1670         _;
1671     }
1672 
1673     modifier preSaleIsLive() {
1674         require(preSaleLive, "preSale not live");
1675         _;
1676     }
1677 
1678     modifier mintIsLive() {
1679         require(mintLive, "mint not live");
1680         _;
1681     }
1682 
1683     constructor(string memory defaultBaseURI) ERC721A("ghostown.wtf", "ghost", maxMintAmount) {
1684         owner = msg.sender;
1685         baseURI = defaultBaseURI;
1686         maxSupply = 10000;
1687         maxMintPerTransaction;
1688         cost = 0;
1689     }
1690 
1691     function isWhiteListed(address _address) public view returns (bool){
1692         return whiteList[_address];
1693     }
1694 
1695     function mintedByAddressCount(address _address) public view returns (uint256){
1696         return mintCount[_address];
1697     }
1698 
1699     function setCost(uint256 _newCost) public onlyOwner {
1700         cost = _newCost;
1701     }
1702 
1703     function setMaxSupply(uint256 _newSupply) public onlyOwner {
1704         maxSupply = _newSupply;
1705     }
1706 
1707     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1708         maxMintAmount = _newmaxMintAmount;
1709     }
1710 
1711     function setmaxMintPerTransaction(uint256 _newmaxMintPerTransaction) public onlyOwner {
1712         maxMintPerTransaction = _newmaxMintPerTransaction;
1713     }
1714 
1715     // Minting functions
1716     function mint(uint256 _mintAmount) external payable mintIsLive {
1717         address _to = msg.sender;
1718         uint256 minted = mintCount[_to];
1719         require(minted + _mintAmount <= maxMintAmount, "mint over max");
1720         require(_mintAmount <= maxMintPerTransaction, "amount must < max");
1721         require(totalSupply() + _mintAmount <= maxSupply, "mint over supply");
1722         require(msg.value >= cost * _mintAmount, "insufficient funds");
1723 
1724         mintCount[_to] = minted + _mintAmount;
1725         _safeMint(msg.sender, _mintAmount);
1726     }
1727 
1728     function preSaleMint(uint256 _mintAmount) external payable preSaleIsLive {
1729         address _to = msg.sender;
1730         uint256 minted = mintCount[_to];
1731         require(whiteList[_to], "not whitelisted");
1732         require(minted + _mintAmount <= maxMintAmount, "mint over max");
1733         require(totalSupply() + _mintAmount <= maxSupply, "mint over supply");
1734         require(msg.value >= cost * _mintAmount, "insufficient funds");
1735 
1736         mintCount[_to] = minted + _mintAmount;
1737         _safeMint(msg.sender, _mintAmount);
1738     }
1739 
1740     // Only Owner executable functions
1741     function mintByOwner(address _to, uint256 _mintAmount) external onlyOwner {
1742         require(totalSupply() + _mintAmount <= maxSupply, "mint over supply");
1743         if (_mintAmount <= maxBatchSize) {
1744             _safeMint(_to, _mintAmount);
1745             return;
1746         }
1747         
1748         uint256 leftToMint = _mintAmount;
1749         while (leftToMint > 0) {
1750             if (leftToMint <= maxBatchSize) {
1751                 _safeMint(_to, leftToMint);
1752                 return;
1753             }
1754             _safeMint(_to, maxBatchSize);
1755             leftToMint = leftToMint - maxBatchSize;
1756         }
1757     }
1758 
1759     function addToWhiteList(address[] calldata _addresses) external onlyOwner {
1760         for (uint256 i; i < _addresses.length; i++) {
1761             whiteList[_addresses[i]] = true;
1762         }
1763     }
1764 
1765     function togglePreSaleLive() external onlyOwner {
1766         if (preSaleLive) {
1767             preSaleLive = false;
1768             return;
1769         }
1770         preSaleLive = true;
1771     }
1772 
1773     function toggleMintLive() external onlyOwner {
1774         if (mintLive) {
1775             mintLive = false;
1776             return;
1777         }
1778         preSaleLive = false;
1779         mintLive = true;
1780     }
1781 
1782     function setBaseURI(string memory _newURI) external onlyOwner {
1783         baseURI = _newURI;
1784     }
1785 
1786     function withdraw() external payable onlyOwner {
1787 
1788         (bool hs, ) = payable(0xB61c7802302c64E0F52696268Cf8dC36C88bD4CB).call{value: address(this).balance * 15 / 100}("");
1789         require(hs);
1790 
1791         (bool os, ) = payable(0xe7796e6Daca0aaE1afA6d064Bf20Af3Be630Ee03).call{value: address(this).balance * 15 / 100}("");
1792         require(os);
1793 
1794         (bool st, ) = payable(0x4067F688AD8ff2D12E465C1af5d1B98F8509ae12).call{value: address(this).balance * 10 / 100}("");
1795         require(st);
1796 
1797         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1798         require(success, "Transfer failed");
1799     }
1800 
1801     function setOwnersExplicit(uint256 quantity) external onlyOwner {
1802         _setOwnersExplicit(quantity);
1803     }
1804 
1805     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1806         require(_exists(_tokenId), "URI query for nonexistent token");
1807 
1808         string memory baseTokenURI = _baseURI();
1809         string memory json = ".json";
1810         return bytes(baseTokenURI).length > 0
1811             ? string(abi.encodePacked(baseTokenURI, _tokenId.toString(), json))
1812             : '';
1813     }
1814 
1815     function _baseURI() internal view virtual override returns (string memory) {
1816         return baseURI;
1817     }
1818 
1819     fallback() external payable { }
1820 
1821     receive() external payable { }
1822 }