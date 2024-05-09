1 // SPDX-License-Identifier: MIT
2 
3 /*
4    SSSSSSSSSSSSSSS              AAA               BBBBBBBBBBBBBBBBB           CCCCCCCCCCCCC
5  SS:::::::::::::::S            A:::A              B::::::::::::::::B       CCC::::::::::::C
6 S:::::SSSSSS::::::S           A:::::A             B::::::BBBBBB:::::B    CC:::::::::::::::C
7 S:::::S     SSSSSSS          A:::::::A            BB:::::B     B:::::B  C:::::CCCCCCCC::::C
8 S:::::S                     A:::::::::A             B::::B     B:::::B C:::::C       CCCCCC
9 S:::::S                    A:::::A:::::A            B::::B     B:::::BC:::::C              
10  S::::SSSS                A:::::A A:::::A           B::::BBBBBB:::::B C:::::C              
11   SS::::::SSSSS          A:::::A   A:::::A          B:::::::::::::BB  C:::::C              
12     SSS::::::::SS       A:::::A     A:::::A         B::::BBBBBB:::::B C:::::C              
13        SSSSSS::::S     A:::::AAAAAAAAA:::::A        B::::B     B:::::BC:::::C              
14             S:::::S   A:::::::::::::::::::::A       B::::B     B:::::BC:::::C              
15             S:::::S  A:::::AAAAAAAAAAAAA:::::A      B::::B     B:::::B C:::::C       CCCCCC
16 SSSSSSS     S:::::S A:::::A             A:::::A   BB:::::BBBBBB::::::B  C:::::CCCCCCCC::::C
17 S::::::SSSSSS:::::SA:::::A               A:::::A  B:::::::::::::::::B    CC:::::::::::::::C
18 S:::::::::::::::SSA:::::A                 A:::::A B::::::::::::::::B       CCC::::::::::::C
19  SSSSSSSSSSSSSSS AAAAAAA                   AAAAAAABBBBBBBBBBBBBBBBB           CCCCCCCCCCCCC
20 **/
21 
22 // Sketchy Ape Book Club (Sketchy Pages)
23 
24 /*
25 The sketchiest apes on the blockchain, the Sketchy Ape Book Club NFT Collection symbolizes 
26 the merging of the physical world and the digital. Each ape was hand drawn by the artist 
27 in separate layers and then ran through the HashLips Art Engine to generate 10 000 unique 
28 and very special apes.
29 **/
30 
31 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
32 pragma solidity ^0.8.0;
33 /**
34  * @dev Interface of the ERC165 standard, as defined in the
35  * https://eips.ethereum.org/EIPS/eip-165[EIP].
36  *
37  * Implementers can declare support of contract interfaces, which can then be
38  * queried by others ({ERC165Checker}).
39  *
40  * For an implementation, see {ERC165}.
41  */
42 interface IERC165 {
43     /**
44      * @dev Returns true if this contract implements the interface defined by
45      * `interfaceId`. See the corresponding
46      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
47      * to learn more about how these ids are created.
48      *
49      * This function call must use less than 30 000 gas.
50      */
51     function supportsInterface(bytes4 interfaceId) external view returns (bool);
52 }
53 
54 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
55 pragma solidity ^0.8.0;
56 /**
57  * @dev Required interface of an ERC721 compliant contract.
58  */
59 interface IERC721 is IERC165 {
60     /**
61      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
62      */
63     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
64 
65     /**
66      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
67      */
68     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
69 
70     /**
71      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
72      */
73     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
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
151     function getApproved(uint256 tokenId) external view returns (address operator);
152 
153     /**
154      * @dev Approve or remove `operator` as an operator for the caller.
155      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
156      *
157      * Requirements:
158      *
159      * - The `operator` cannot be the caller.
160      *
161      * Emits an {ApprovalForAll} event.
162      */
163     function setApprovalForAll(address operator, bool _approved) external;
164 
165     /**
166      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
167      *
168      * See {setApprovalForAll}
169      */
170     function isApprovedForAll(address owner, address operator) external view returns (bool);
171 
172     /**
173      * @dev Safely transfers `tokenId` token from `from` to `to`.
174      *
175      * Requirements:
176      *
177      * - `from` cannot be the zero address.
178      * - `to` cannot be the zero address.
179      * - `tokenId` token must exist and be owned by `from`.
180      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
181      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
182      *
183      * Emits a {Transfer} event.
184      */
185     function safeTransferFrom(
186         address from,
187         address to,
188         uint256 tokenId,
189         bytes calldata data
190     ) external;
191 }
192 
193 
194 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
195 pragma solidity ^0.8.0;
196 /**
197  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
198  * @dev See https://eips.ethereum.org/EIPS/eip-721
199  */
200 interface IERC721Enumerable is IERC721 {
201     /**
202      * @dev Returns the total amount of tokens stored by the contract.
203      */
204     function totalSupply() external view returns (uint256);
205 
206     /**
207      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
208      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
209      */
210     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
211 
212     /**
213      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
214      * Use along with {totalSupply} to enumerate all tokens.
215      */
216     function tokenByIndex(uint256 index) external view returns (uint256);
217 }
218 
219 
220 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
221 pragma solidity ^0.8.0;
222 /**
223  * @dev Implementation of the {IERC165} interface.
224  *
225  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
226  * for the additional interface id that will be supported. For example:
227  *
228  * ```solidity
229  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
230  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
231  * }
232  * ```
233  *
234  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
235  */
236 abstract contract ERC165 is IERC165 {
237     /**
238      * @dev See {IERC165-supportsInterface}.
239      */
240     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
241         return interfaceId == type(IERC165).interfaceId;
242     }
243 }
244 
245 // File: @openzeppelin/contracts/utils/Strings.sol
246 
247 
248 
249 pragma solidity ^0.8.0;
250 
251 /**
252  * @dev String operations.
253  */
254 library Strings {
255     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
256 
257     /**
258      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
259      */
260     function toString(uint256 value) internal pure returns (string memory) {
261         // Inspired by OraclizeAPI's implementation - MIT licence
262         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
263 
264         if (value == 0) {
265             return "0";
266         }
267         uint256 temp = value;
268         uint256 digits;
269         while (temp != 0) {
270             digits++;
271             temp /= 10;
272         }
273         bytes memory buffer = new bytes(digits);
274         while (value != 0) {
275             digits -= 1;
276             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
277             value /= 10;
278         }
279         return string(buffer);
280     }
281 
282     /**
283      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
284      */
285     function toHexString(uint256 value) internal pure returns (string memory) {
286         if (value == 0) {
287             return "0x00";
288         }
289         uint256 temp = value;
290         uint256 length = 0;
291         while (temp != 0) {
292             length++;
293             temp >>= 8;
294         }
295         return toHexString(value, length);
296     }
297 
298     /**
299      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
300      */
301     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
302         bytes memory buffer = new bytes(2 * length + 2);
303         buffer[0] = "0";
304         buffer[1] = "x";
305         for (uint256 i = 2 * length + 1; i > 1; --i) {
306             buffer[i] = _HEX_SYMBOLS[value & 0xf];
307             value >>= 4;
308         }
309         require(value == 0, "Strings: hex length insufficient");
310         return string(buffer);
311     }
312 }
313 
314 // File: @openzeppelin/contracts/utils/Address.sol
315 
316 
317 
318 pragma solidity ^0.8.0;
319 
320 /**
321  * @dev Collection of functions related to the address type
322  */
323 library Address {
324     /**
325      * @dev Returns true if `account` is a contract.
326      *
327      * [IMPORTANT]
328      * ====
329      * It is unsafe to assume that an address for which this function returns
330      * false is an externally-owned account (EOA) and not a contract.
331      *
332      * Among others, `isContract` will return false for the following
333      * types of addresses:
334      *
335      *  - an externally-owned account
336      *  - a contract in construction
337      *  - an address where a contract will be created
338      *  - an address where a contract lived, but was destroyed
339      * ====
340      */
341     function isContract(address account) internal view returns (bool) {
342         // This method relies on extcodesize, which returns 0 for contracts in
343         // construction, since the code is only stored at the end of the
344         // constructor execution.
345 
346         uint256 size;
347         assembly {
348             size := extcodesize(account)
349         }
350         return size > 0;
351     }
352 
353     /**
354      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
355      * `recipient`, forwarding all available gas and reverting on errors.
356      *
357      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
358      * of certain opcodes, possibly making contracts go over the 2300 gas limit
359      * imposed by `transfer`, making them unable to receive funds via
360      * `transfer`. {sendValue} removes this limitation.
361      *
362      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
363      *
364      * IMPORTANT: because control is transferred to `recipient`, care must be
365      * taken to not create reentrancy vulnerabilities. Consider using
366      * {ReentrancyGuard} or the
367      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
368      */
369     function sendValue(address payable recipient, uint256 amount) internal {
370         require(address(this).balance >= amount, "Address: insufficient balance");
371 
372         (bool success, ) = recipient.call{value: amount}("");
373         require(success, "Address: unable to send value, recipient may have reverted");
374     }
375 
376     /**
377      * @dev Performs a Solidity function call using a low level `call`. A
378      * plain `call` is an unsafe replacement for a function call: use this
379      * function instead.
380      *
381      * If `target` reverts with a revert reason, it is bubbled up by this
382      * function (like regular Solidity function calls).
383      *
384      * Returns the raw returned data. To convert to the expected return value,
385      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
386      *
387      * Requirements:
388      *
389      * - `target` must be a contract.
390      * - calling `target` with `data` must not revert.
391      *
392      * _Available since v3.1._
393      */
394     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
395         return functionCall(target, data, "Address: low-level call failed");
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
400      * `errorMessage` as a fallback revert reason when `target` reverts.
401      *
402      * _Available since v3.1._
403      */
404     function functionCall(
405         address target,
406         bytes memory data,
407         string memory errorMessage
408     ) internal returns (bytes memory) {
409         return functionCallWithValue(target, data, 0, errorMessage);
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
414      * but also transferring `value` wei to `target`.
415      *
416      * Requirements:
417      *
418      * - the calling contract must have an ETH balance of at least `value`.
419      * - the called Solidity function must be `payable`.
420      *
421      * _Available since v3.1._
422      */
423     function functionCallWithValue(
424         address target,
425         bytes memory data,
426         uint256 value
427     ) internal returns (bytes memory) {
428         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
433      * with `errorMessage` as a fallback revert reason when `target` reverts.
434      *
435      * _Available since v3.1._
436      */
437     function functionCallWithValue(
438         address target,
439         bytes memory data,
440         uint256 value,
441         string memory errorMessage
442     ) internal returns (bytes memory) {
443         require(address(this).balance >= value, "Address: insufficient balance for call");
444         require(isContract(target), "Address: call to non-contract");
445 
446         (bool success, bytes memory returndata) = target.call{value: value}(data);
447         return verifyCallResult(success, returndata, errorMessage);
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
452      * but performing a static call.
453      *
454      * _Available since v3.3._
455      */
456     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
457         return functionStaticCall(target, data, "Address: low-level static call failed");
458     }
459 
460     /**
461      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
462      * but performing a static call.
463      *
464      * _Available since v3.3._
465      */
466     function functionStaticCall(
467         address target,
468         bytes memory data,
469         string memory errorMessage
470     ) internal view returns (bytes memory) {
471         require(isContract(target), "Address: static call to non-contract");
472 
473         (bool success, bytes memory returndata) = target.staticcall(data);
474         return verifyCallResult(success, returndata, errorMessage);
475     }
476 
477     /**
478      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
479      * but performing a delegate call.
480      *
481      * _Available since v3.4._
482      */
483     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
484         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
485     }
486 
487     /**
488      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
489      * but performing a delegate call.
490      *
491      * _Available since v3.4._
492      */
493     function functionDelegateCall(
494         address target,
495         bytes memory data,
496         string memory errorMessage
497     ) internal returns (bytes memory) {
498         require(isContract(target), "Address: delegate call to non-contract");
499 
500         (bool success, bytes memory returndata) = target.delegatecall(data);
501         return verifyCallResult(success, returndata, errorMessage);
502     }
503 
504     /**
505      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
506      * revert reason using the provided one.
507      *
508      * _Available since v4.3._
509      */
510     function verifyCallResult(
511         bool success,
512         bytes memory returndata,
513         string memory errorMessage
514     ) internal pure returns (bytes memory) {
515         if (success) {
516             return returndata;
517         } else {
518             // Look for revert reason and bubble it up if present
519             if (returndata.length > 0) {
520                 // The easiest way to bubble the revert reason is using memory via assembly
521 
522                 assembly {
523                     let returndata_size := mload(returndata)
524                     revert(add(32, returndata), returndata_size)
525                 }
526             } else {
527                 revert(errorMessage);
528             }
529         }
530     }
531 }
532 
533 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
534 
535 
536 
537 pragma solidity ^0.8.0;
538 
539 
540 /**
541  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
542  * @dev See https://eips.ethereum.org/EIPS/eip-721
543  */
544 interface IERC721Metadata is IERC721 {
545     /**
546      * @dev Returns the token collection name.
547      */
548     function name() external view returns (string memory);
549 
550     /**
551      * @dev Returns the token collection symbol.
552      */
553     function symbol() external view returns (string memory);
554 
555     /**
556      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
557      */
558     function tokenURI(uint256 tokenId) external view returns (string memory);
559 }
560 
561 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
562 
563 
564 
565 pragma solidity ^0.8.0;
566 
567 /**
568  * @title ERC721 token receiver interface
569  * @dev Interface for any contract that wants to support safeTransfers
570  * from ERC721 asset contracts.
571  */
572 interface IERC721Receiver {
573     /**
574      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
575      * by `operator` from `from`, this function is called.
576      *
577      * It must return its Solidity selector to confirm the token transfer.
578      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
579      *
580      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
581      */
582     function onERC721Received(
583         address operator,
584         address from,
585         uint256 tokenId,
586         bytes calldata data
587     ) external returns (bytes4);
588 }
589 
590 // File: @openzeppelin/contracts/utils/Context.sol
591 pragma solidity ^0.8.0;
592 /**
593  * @dev Provides information about the current execution context, including the
594  * sender of the transaction and its data. While these are generally available
595  * via msg.sender and msg.data, they should not be accessed in such a direct
596  * manner, since when dealing with meta-transactions the account sending and
597  * paying for execution may not be the actual sender (as far as an application
598  * is concerned).
599  *
600  * This contract is only required for intermediate, library-like contracts.
601  */
602 abstract contract Context {
603     function _msgSender() internal view virtual returns (address) {
604         return msg.sender;
605     }
606 
607     function _msgData() internal view virtual returns (bytes calldata) {
608         return msg.data;
609     }
610 }
611 
612 
613 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
614 pragma solidity ^0.8.0;
615 /**
616  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
617  * the Metadata extension, but not including the Enumerable extension, which is available separately as
618  * {ERC721Enumerable}.
619  */
620 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
621     using Address for address;
622     using Strings for uint256;
623 
624     // Token name
625     string private _name;
626 
627     // Token symbol
628     string private _symbol;
629 
630     // Mapping from token ID to owner address
631     mapping(uint256 => address) private _owners;
632 
633     // Mapping owner address to token count
634     mapping(address => uint256) private _balances;
635 
636     // Mapping from token ID to approved address
637     mapping(uint256 => address) private _tokenApprovals;
638 
639     // Mapping from owner to operator approvals
640     mapping(address => mapping(address => bool)) private _operatorApprovals;
641 
642     /**
643      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
644      */
645     constructor(string memory name_, string memory symbol_) {
646         _name = name_;
647         _symbol = symbol_;
648     }
649 
650     /**
651      * @dev See {IERC165-supportsInterface}.
652      */
653     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
654         return
655             interfaceId == type(IERC721).interfaceId ||
656             interfaceId == type(IERC721Metadata).interfaceId ||
657             super.supportsInterface(interfaceId);
658     }
659 
660     /**
661      * @dev See {IERC721-balanceOf}.
662      */
663     function balanceOf(address owner) public view virtual override returns (uint256) {
664         require(owner != address(0), "ERC721: balance query for the zero address");
665         return _balances[owner];
666     }
667 
668     /**
669      * @dev See {IERC721-ownerOf}.
670      */
671     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
672         address owner = _owners[tokenId];
673         require(owner != address(0), "ERC721: owner query for nonexistent token");
674         return owner;
675     }
676 
677     /**
678      * @dev See {IERC721Metadata-name}.
679      */
680     function name() public view virtual override returns (string memory) {
681         return _name;
682     }
683 
684     /**
685      * @dev See {IERC721Metadata-symbol}.
686      */
687     function symbol() public view virtual override returns (string memory) {
688         return _symbol;
689     }
690 
691     /**
692      * @dev See {IERC721Metadata-tokenURI}.
693      */
694     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
695         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
696 
697         string memory baseURI = _baseURI();
698         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
699     }
700 
701     /**
702      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
703      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
704      * by default, can be overriden in child contracts.
705      */
706     function _baseURI() internal view virtual returns (string memory) {
707         return "";
708     }
709 
710     /**
711      * @dev See {IERC721-approve}.
712      */
713     function approve(address to, uint256 tokenId) public virtual override {
714         address owner = ERC721.ownerOf(tokenId);
715         require(to != owner, "ERC721: approval to current owner");
716 
717         require(
718             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
719             "ERC721: approve caller is not owner nor approved for all"
720         );
721 
722         _approve(to, tokenId);
723     }
724 
725     /**
726      * @dev See {IERC721-getApproved}.
727      */
728     function getApproved(uint256 tokenId) public view virtual override returns (address) {
729         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
730 
731         return _tokenApprovals[tokenId];
732     }
733 
734     /**
735      * @dev See {IERC721-setApprovalForAll}.
736      */
737     function setApprovalForAll(address operator, bool approved) public virtual override {
738         require(operator != _msgSender(), "ERC721: approve to caller");
739 
740         _operatorApprovals[_msgSender()][operator] = approved;
741         emit ApprovalForAll(_msgSender(), operator, approved);
742     }
743 
744     /**
745      * @dev See {IERC721-isApprovedForAll}.
746      */
747     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
748         return _operatorApprovals[owner][operator];
749     }
750 
751     /**
752      * @dev See {IERC721-transferFrom}.
753      */
754     function transferFrom(
755         address from,
756         address to,
757         uint256 tokenId
758     ) public virtual override {
759         //solhint-disable-next-line max-line-length
760         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
761 
762         _transfer(from, to, tokenId);
763     }
764 
765     /**
766      * @dev See {IERC721-safeTransferFrom}.
767      */
768     function safeTransferFrom(
769         address from,
770         address to,
771         uint256 tokenId
772     ) public virtual override {
773         safeTransferFrom(from, to, tokenId, "");
774     }
775 
776     /**
777      * @dev See {IERC721-safeTransferFrom}.
778      */
779     function safeTransferFrom(
780         address from,
781         address to,
782         uint256 tokenId,
783         bytes memory _data
784     ) public virtual override {
785         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
786         _safeTransfer(from, to, tokenId, _data);
787     }
788 
789     /**
790      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
791      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
792      *
793      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
794      *
795      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
796      * implement alternative mechanisms to perform token transfer, such as signature-based.
797      *
798      * Requirements:
799      *
800      * - `from` cannot be the zero address.
801      * - `to` cannot be the zero address.
802      * - `tokenId` token must exist and be owned by `from`.
803      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
804      *
805      * Emits a {Transfer} event.
806      */
807     function _safeTransfer(
808         address from,
809         address to,
810         uint256 tokenId,
811         bytes memory _data
812     ) internal virtual {
813         _transfer(from, to, tokenId);
814         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
815     }
816 
817     /**
818      * @dev Returns whether `tokenId` exists.
819      *
820      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
821      *
822      * Tokens start existing when they are minted (`_mint`),
823      * and stop existing when they are burned (`_burn`).
824      */
825     function _exists(uint256 tokenId) internal view virtual returns (bool) {
826         return _owners[tokenId] != address(0);
827     }
828 
829     /**
830      * @dev Returns whether `spender` is allowed to manage `tokenId`.
831      *
832      * Requirements:
833      *
834      * - `tokenId` must exist.
835      */
836     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
837         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
838         address owner = ERC721.ownerOf(tokenId);
839         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
840     }
841 
842     /**
843      * @dev Safely mints `tokenId` and transfers it to `to`.
844      *
845      * Requirements:
846      *
847      * - `tokenId` must not exist.
848      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
849      *
850      * Emits a {Transfer} event.
851      */
852     function _safeMint(address to, uint256 tokenId) internal virtual {
853         _safeMint(to, tokenId, "");
854     }
855 
856     /**
857      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
858      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
859      */
860     function _safeMint(
861         address to,
862         uint256 tokenId,
863         bytes memory _data
864     ) internal virtual {
865         _mint(to, tokenId);
866         require(
867             _checkOnERC721Received(address(0), to, tokenId, _data),
868             "ERC721: transfer to non ERC721Receiver implementer"
869         );
870     }
871 
872     /**
873      * @dev Mints `tokenId` and transfers it to `to`.
874      *
875      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
876      *
877      * Requirements:
878      *
879      * - `tokenId` must not exist.
880      * - `to` cannot be the zero address.
881      *
882      * Emits a {Transfer} event.
883      */
884     function _mint(address to, uint256 tokenId) internal virtual {
885         require(to != address(0), "ERC721: mint to the zero address");
886         require(!_exists(tokenId), "ERC721: token already minted");
887 
888         _beforeTokenTransfer(address(0), to, tokenId);
889 
890         _balances[to] += 1;
891         _owners[tokenId] = to;
892 
893         emit Transfer(address(0), to, tokenId);
894     }
895 
896     /**
897      * @dev Destroys `tokenId`.
898      * The approval is cleared when the token is burned.
899      *
900      * Requirements:
901      *
902      * - `tokenId` must exist.
903      *
904      * Emits a {Transfer} event.
905      */
906     function _burn(uint256 tokenId) internal virtual {
907         address owner = ERC721.ownerOf(tokenId);
908 
909         _beforeTokenTransfer(owner, address(0), tokenId);
910 
911         // Clear approvals
912         _approve(address(0), tokenId);
913 
914         _balances[owner] -= 1;
915         delete _owners[tokenId];
916 
917         emit Transfer(owner, address(0), tokenId);
918     }
919 
920     /**
921      * @dev Transfers `tokenId` from `from` to `to`.
922      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
923      *
924      * Requirements:
925      *
926      * - `to` cannot be the zero address.
927      * - `tokenId` token must be owned by `from`.
928      *
929      * Emits a {Transfer} event.
930      */
931     function _transfer(
932         address from,
933         address to,
934         uint256 tokenId
935     ) internal virtual {
936         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
937         require(to != address(0), "ERC721: transfer to the zero address");
938 
939         _beforeTokenTransfer(from, to, tokenId);
940 
941         // Clear approvals from the previous owner
942         _approve(address(0), tokenId);
943 
944         _balances[from] -= 1;
945         _balances[to] += 1;
946         _owners[tokenId] = to;
947 
948         emit Transfer(from, to, tokenId);
949     }
950 
951     /**
952      * @dev Approve `to` to operate on `tokenId`
953      *
954      * Emits a {Approval} event.
955      */
956     function _approve(address to, uint256 tokenId) internal virtual {
957         _tokenApprovals[tokenId] = to;
958         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
959     }
960 
961     /**
962      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
963      * The call is not executed if the target address is not a contract.
964      *
965      * @param from address representing the previous owner of the given token ID
966      * @param to target address that will receive the tokens
967      * @param tokenId uint256 ID of the token to be transferred
968      * @param _data bytes optional data to send along with the call
969      * @return bool whether the call correctly returned the expected magic value
970      */
971     function _checkOnERC721Received(
972         address from,
973         address to,
974         uint256 tokenId,
975         bytes memory _data
976     ) private returns (bool) {
977         if (to.isContract()) {
978             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
979                 return retval == IERC721Receiver.onERC721Received.selector;
980             } catch (bytes memory reason) {
981                 if (reason.length == 0) {
982                     revert("ERC721: transfer to non ERC721Receiver implementer");
983                 } else {
984                     assembly {
985                         revert(add(32, reason), mload(reason))
986                     }
987                 }
988             }
989         } else {
990             return true;
991         }
992     }
993 
994     /**
995      * @dev Hook that is called before any token transfer. This includes minting
996      * and burning.
997      *
998      * Calling conditions:
999      *
1000      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1001      * transferred to `to`.
1002      * - When `from` is zero, `tokenId` will be minted for `to`.
1003      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1004      * - `from` and `to` are never both zero.
1005      *
1006      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1007      */
1008     function _beforeTokenTransfer(
1009         address from,
1010         address to,
1011         uint256 tokenId
1012     ) internal virtual {}
1013 }
1014 
1015 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1016 
1017 
1018 
1019 pragma solidity ^0.8.0;
1020 
1021 
1022 
1023 /**
1024  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1025  * enumerability of all the token ids in the contract as well as all token ids owned by each
1026  * account.
1027  */
1028 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1029     // Mapping from owner to list of owned token IDs
1030     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1031 
1032     // Mapping from token ID to index of the owner tokens list
1033     mapping(uint256 => uint256) private _ownedTokensIndex;
1034 
1035     // Array with all token ids, used for enumeration
1036     uint256[] private _allTokens;
1037 
1038     // Mapping from token id to position in the allTokens array
1039     mapping(uint256 => uint256) private _allTokensIndex;
1040 
1041     /**
1042      * @dev See {IERC165-supportsInterface}.
1043      */
1044     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1045         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1046     }
1047 
1048     /**
1049      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1050      */
1051     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1052         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1053         return _ownedTokens[owner][index];
1054     }
1055 
1056     /**
1057      * @dev See {IERC721Enumerable-totalSupply}.
1058      */
1059     function totalSupply() public view virtual override returns (uint256) {
1060         return _allTokens.length;
1061     }
1062 
1063     /**
1064      * @dev See {IERC721Enumerable-tokenByIndex}.
1065      */
1066     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1067         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1068         return _allTokens[index];
1069     }
1070 
1071     /**
1072      * @dev Hook that is called before any token transfer. This includes minting
1073      * and burning.
1074      *
1075      * Calling conditions:
1076      *
1077      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1078      * transferred to `to`.
1079      * - When `from` is zero, `tokenId` will be minted for `to`.
1080      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1081      * - `from` cannot be the zero address.
1082      * - `to` cannot be the zero address.
1083      *
1084      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1085      */
1086     function _beforeTokenTransfer(
1087         address from,
1088         address to,
1089         uint256 tokenId
1090     ) internal virtual override {
1091         super._beforeTokenTransfer(from, to, tokenId);
1092 
1093         if (from == address(0)) {
1094             _addTokenToAllTokensEnumeration(tokenId);
1095         } else if (from != to) {
1096             _removeTokenFromOwnerEnumeration(from, tokenId);
1097         }
1098         if (to == address(0)) {
1099             _removeTokenFromAllTokensEnumeration(tokenId);
1100         } else if (to != from) {
1101             _addTokenToOwnerEnumeration(to, tokenId);
1102         }
1103     }
1104 
1105     /**
1106      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1107      * @param to address representing the new owner of the given token ID
1108      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1109      */
1110     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1111         uint256 length = ERC721.balanceOf(to);
1112         _ownedTokens[to][length] = tokenId;
1113         _ownedTokensIndex[tokenId] = length;
1114     }
1115 
1116     /**
1117      * @dev Private function to add a token to this extension's token tracking data structures.
1118      * @param tokenId uint256 ID of the token to be added to the tokens list
1119      */
1120     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1121         _allTokensIndex[tokenId] = _allTokens.length;
1122         _allTokens.push(tokenId);
1123     }
1124 
1125     /**
1126      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1127      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1128      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1129      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1130      * @param from address representing the previous owner of the given token ID
1131      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1132      */
1133     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1134         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1135         // then delete the last slot (swap and pop).
1136 
1137         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1138         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1139 
1140         // When the token to delete is the last token, the swap operation is unnecessary
1141         if (tokenIndex != lastTokenIndex) {
1142             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1143 
1144             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1145             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1146         }
1147 
1148         // This also deletes the contents at the last position of the array
1149         delete _ownedTokensIndex[tokenId];
1150         delete _ownedTokens[from][lastTokenIndex];
1151     }
1152 
1153     /**
1154      * @dev Private function to remove a token from this extension's token tracking data structures.
1155      * This has O(1) time complexity, but alters the order of the _allTokens array.
1156      * @param tokenId uint256 ID of the token to be removed from the tokens list
1157      */
1158     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1159         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1160         // then delete the last slot (swap and pop).
1161 
1162         uint256 lastTokenIndex = _allTokens.length - 1;
1163         uint256 tokenIndex = _allTokensIndex[tokenId];
1164 
1165         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1166         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1167         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1168         uint256 lastTokenId = _allTokens[lastTokenIndex];
1169 
1170         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1171         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1172 
1173         // This also deletes the contents at the last position of the array
1174         delete _allTokensIndex[tokenId];
1175         _allTokens.pop();
1176     }
1177 }
1178 
1179 
1180 // File: @openzeppelin/contracts/access/Ownable.sol
1181 pragma solidity ^0.8.0;
1182 /**
1183  * @dev Contract module which provides a basic access control mechanism, where
1184  * there is an account (an owner) that can be granted exclusive access to
1185  * specific functions.
1186  *
1187  * By default, the owner account will be the one that deploys the contract. This
1188  * can later be changed with {transferOwnership}.
1189  *
1190  * This module is used through inheritance. It will make available the modifier
1191  * `onlyOwner`, which can be applied to your functions to restrict their use to
1192  * the owner.
1193  */
1194 abstract contract Ownable is Context {
1195     address private _owner;
1196 
1197     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1198 
1199     /**
1200      * @dev Initializes the contract setting the deployer as the initial owner.
1201      */
1202     constructor() {
1203         _setOwner(_msgSender());
1204     }
1205 
1206     /**
1207      * @dev Returns the address of the current owner.
1208      */
1209     function owner() public view virtual returns (address) {
1210         return _owner;
1211     }
1212 
1213     /**
1214      * @dev Throws if called by any account other than the owner.
1215      */
1216     modifier onlyOwner() {
1217         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1218         _;
1219     }
1220 
1221     /**
1222      * @dev Leaves the contract without owner. It will not be possible to call
1223      * `onlyOwner` functions anymore. Can only be called by the current owner.
1224      *
1225      * NOTE: Renouncing ownership will leave the contract without an owner,
1226      * thereby removing any functionality that is only available to the owner.
1227      */
1228     function renounceOwnership() public virtual onlyOwner {
1229         _setOwner(address(0));
1230     }
1231 
1232     /**
1233      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1234      * Can only be called by the current owner.
1235      */
1236     function transferOwnership(address newOwner) public virtual onlyOwner {
1237         require(newOwner != address(0), "Ownable: new owner is the zero address");
1238         _setOwner(newOwner);
1239     }
1240 
1241     function _setOwner(address newOwner) private {
1242         address oldOwner = _owner;
1243         _owner = newOwner;
1244         emit OwnershipTransferred(oldOwner, newOwner);
1245     }
1246 }
1247 
1248 pragma solidity >=0.7.0 <0.9.0;
1249 
1250 contract SketchyPages is ERC721Enumerable, Ownable {
1251   using Strings for uint256;
1252 
1253   string baseURI;
1254   uint256 public requiredAmount = 3;
1255   uint256 public maxCharLimit = 200;
1256   bool public paused = false;
1257   string public notRevealedUri;
1258   address public sabcAddress;
1259 
1260   struct Page { 
1261       string message;
1262    }
1263 
1264   mapping (uint256 => Page) public pages;
1265 
1266   constructor(
1267     string memory _name,
1268     string memory _symbol,
1269     string memory _initBaseURI,
1270     string memory _initNotRevealedUri,
1271     address _initsabcAddress
1272   ) ERC721(_name, _symbol) {
1273     setBaseURI(_initBaseURI);
1274     setNotRevealedURI(_initNotRevealedUri);
1275     setsabcAddress(_initsabcAddress);
1276   }
1277 
1278   // internal
1279   function _baseURI() internal view virtual override returns (string memory) {
1280     return baseURI;
1281   }
1282 
1283   // public
1284   function claim() public {
1285     require(!paused, "Contract is paused");
1286     IERC721 token = IERC721(sabcAddress);
1287     uint256 ownedAmount = token.balanceOf(msg.sender);
1288     require(ownedAmount >= requiredAmount, "You don't own enough SABC NFTs");
1289     uint256 supply = totalSupply();
1290     require(supply + 1 <= 30000, "Max supply reached");
1291     Page memory newPage = Page("");
1292     pages[supply + 1] = newPage;
1293     _safeMint(msg.sender, supply + 1);
1294   }
1295 
1296   function walletOfOwner(address _owner)
1297     public
1298     view
1299     returns (uint256[] memory)
1300   {
1301     uint256 ownerTokenCount = balanceOf(_owner);
1302     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1303     for (uint256 i; i < ownerTokenCount; i++) {
1304       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1305     }
1306     return tokenIds;
1307   }
1308 
1309   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1310       require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1311         Page memory currentPage = pages[_tokenId];
1312         if(bytes(currentPage.message).length > 0) {
1313             return _baseURI(); 
1314         }
1315         else {
1316              return notRevealedUri;
1317         }
1318   }
1319 
1320   function setMessage(uint256 _tokenId, string memory _newMessage) public {
1321     require(msg.sender == ownerOf(_tokenId), "You are not the owner of this NFT.");
1322     bytes memory strBytes = bytes(_newMessage);
1323     require(strBytes.length <= maxCharLimit, "Message is too long.");
1324     Page storage currentPage = pages[_tokenId];
1325     currentPage.message = _newMessage;
1326   }
1327 
1328    function readMessage(uint256 _tokenId) public view returns (string memory message){
1329     Page memory currentPage = pages[_tokenId];
1330     return currentPage.message;
1331   }
1332 
1333   //only owner
1334   function setsabcAddress(address _newAddress) public onlyOwner {
1335     sabcAddress = _newAddress;
1336   }
1337   
1338   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1339     notRevealedUri = _notRevealedURI;
1340   }
1341 
1342   function setRequiredAmount(uint256 _newValue) public onlyOwner {
1343     requiredAmount = _newValue;
1344   }
1345 
1346   function setMaxCharLimit(uint256 _newValue) public onlyOwner {
1347     maxCharLimit = _newValue;
1348   }
1349 
1350   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1351     baseURI = _newBaseURI;
1352   }
1353 
1354   function pause(bool _state) public onlyOwner {
1355     paused = _state;
1356   }
1357  
1358   function withdraw() public payable onlyOwner {
1359     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1360     require(os);
1361   }
1362 }