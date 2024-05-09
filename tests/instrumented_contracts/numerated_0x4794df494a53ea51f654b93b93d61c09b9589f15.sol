1 // SPDX-License-Identifier: MIT
2 
3 
4 /*
5      ______   _____ _____
6     |      |  |     \     \
7     |_____/   |     |     |
8      /_____   |     |     |
9      ______|  |     |    /
10      \____/             /__
11     
12     say it back! messages :)
13     
14     each NFT shows you gm/gn based on your time zone
15     
16     default set for GMT +0
17     gm: 00:00 - 12:00
18     gn: 12:00 - 24:00
19     
20     to set your GMT time zone, use set_gmt with a value between 0 and 23 to specify, use positive numbers only!
21     e.g. for, (GMT - 1) use 23, for (GMT - 2), use 22, etc.
22     
23     to change the gm/gn intervals:
24     set the gmOffset for gm to start
25     e.g. set_gmOffset 9 if you wake up at 9am
26     
27     same goes for set_gnOffset;
28     set the gnOffset for gn to start
29     e.g. if you'd like to say good night at 7 pm, simply set_gnOffset to 7!
30     
31     refresh metadata if not shown correctly!
32     
33     rarities:
34     
35     %60 lowercase helvetica / times new roman / comic sans
36     %30 uppercase helvetica / times new roman / comic sans
37     %10 uppercase helvetica / times new roman / comic sans *italic* :)
38     
39     free distro with 1 NFT/txn
40     %6,9 secondary royalties
41     
42     say gm in our discord 
43     https://discord.gg/N82Sg94R
44     
45      ______    _____
46     |      |  |     | 
47     |_____/   |     |
48      /_____   |     |
49      ______|       /_
50      \____/      
51     
52 */
53 
54 
55 pragma solidity ^0.8.0;
56 
57 /**
58  * @dev Interface of the ERC165 standard, as defined in the
59  * https://eips.ethereum.org/EIPS/eip-165[EIP].
60  *
61  * Implementers can declare support of contract interfaces, which can then be
62  * queried by others ({ERC165Checker}).
63  *
64  * For an implementation, see {ERC165}.
65  */
66 interface IERC165 {
67     /**
68      * @dev Returns true if this contract implements the interface defined by
69      * `interfaceId`. See the corresponding
70      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
71      * to learn more about how these ids are created.
72      *
73      * This function call must use less than 30 000 gas.
74      */
75     function supportsInterface(bytes4 interfaceId) external view returns (bool);
76 }
77 
78 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
79 
80 
81 
82 pragma solidity ^0.8.0;
83 
84 
85 /**
86  * @dev Required interface of an ERC721 compliant contract.
87  */
88 interface IERC721 is IERC165 {
89     /**
90      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
91      */
92     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
93 
94     /**
95      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
96      */
97     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
98 
99     /**
100      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
101      */
102     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
103 
104     /**
105      * @dev Returns the number of tokens in ``owner``'s account.
106      */
107     function balanceOf(address owner) external view returns (uint256 balance);
108 
109     /**
110      * @dev Returns the owner of the `tokenId` token.
111      *
112      * Requirements:
113      *
114      * - `tokenId` must exist.
115      */
116     function ownerOf(uint256 tokenId) external view returns (address owner);
117 
118     /**
119      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
120      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
121      *
122      * Requirements:
123      *
124      * - `from` cannot be the zero address.
125      * - `to` cannot be the zero address.
126      * - `tokenId` token must exist and be owned by `from`.
127      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
128      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
129      *
130      * Emits a {Transfer} event.
131      */
132     function safeTransferFrom(
133         address from,
134         address to,
135         uint256 tokenId
136     ) external;
137 
138     /**
139      * @dev Transfers `tokenId` token from `from` to `to`.
140      *
141      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
142      *
143      * Requirements:
144      *
145      * - `from` cannot be the zero address.
146      * - `to` cannot be the zero address.
147      * - `tokenId` token must be owned by `from`.
148      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
149      *
150      * Emits a {Transfer} event.
151      */
152     function transferFrom(
153         address from,
154         address to,
155         uint256 tokenId
156     ) external;
157 
158     /**
159      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
160      * The approval is cleared when the token is transferred.
161      *
162      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
163      *
164      * Requirements:
165      *
166      * - The caller must own the token or be an approved operator.
167      * - `tokenId` must exist.
168      *
169      * Emits an {Approval} event.
170      */
171     function approve(address to, uint256 tokenId) external;
172 
173     /**
174      * @dev Returns the account approved for `tokenId` token.
175      *
176      * Requirements:
177      *
178      * - `tokenId` must exist.
179      */
180     function getApproved(uint256 tokenId) external view returns (address operator);
181 
182     /**
183      * @dev Approve or remove `operator` as an operator for the caller.
184      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
185      *
186      * Requirements:
187      *
188      * - The `operator` cannot be the caller.
189      *
190      * Emits an {ApprovalForAll} event.
191      */
192     function setApprovalForAll(address operator, bool _approved) external;
193 
194     /**
195      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
196      *
197      * See {setApprovalForAll}
198      */
199     function isApprovedForAll(address owner, address operator) external view returns (bool);
200 
201     /**
202      * @dev Safely transfers `tokenId` token from `from` to `to`.
203      *
204      * Requirements:
205      *
206      * - `from` cannot be the zero address.
207      * - `to` cannot be the zero address.
208      * - `tokenId` token must exist and be owned by `from`.
209      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
210      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
211      *
212      * Emits a {Transfer} event.
213      */
214     function safeTransferFrom(
215         address from,
216         address to,
217         uint256 tokenId,
218         bytes calldata data
219     ) external;
220 }
221 
222 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
223 
224 
225 
226 pragma solidity ^0.8.0;
227 
228 /**
229  * @title ERC721 token receiver interface
230  * @dev Interface for any contract that wants to support safeTransfers
231  * from ERC721 asset contracts.
232  */
233 interface IERC721Receiver {
234     /**
235      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
236      * by `operator` from `from`, this function is called.
237      *
238      * It must return its Solidity selector to confirm the token transfer.
239      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
240      *
241      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
242      */
243     function onERC721Received(
244         address operator,
245         address from,
246         uint256 tokenId,
247         bytes calldata data
248     ) external returns (bytes4);
249 }
250 
251 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
252 
253 
254 
255 pragma solidity ^0.8.0;
256 
257 
258 /**
259  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
260  * @dev See https://eips.ethereum.org/EIPS/eip-721
261  */
262 interface IERC721Metadata is IERC721 {
263     /**
264      * @dev Returns the token collection name.
265      */
266     function name() external view returns (string memory);
267 
268     /**
269      * @dev Returns the token collection symbol.
270      */
271     function symbol() external view returns (string memory);
272 
273     /**
274      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
275      */
276     function tokenURI(uint256 tokenId) external view returns (string memory);
277 }
278 
279 // File: @openzeppelin/contracts/utils/Address.sol
280 
281 
282 
283 pragma solidity ^0.8.0;
284 
285 /**
286  * @dev Collection of functions related to the address type
287  */
288 library Address {
289     /**
290      * @dev Returns true if `account` is a contract.
291      *
292      * [IMPORTANT]
293      * ====
294      * It is unsafe to assume that an address for which this function returns
295      * false is an externally-owned account (EOA) and not a contract.
296      *
297      * Among others, `isContract` will return false for the following
298      * types of addresses:
299      *
300      *  - an externally-owned account
301      *  - a contract in construction
302      *  - an address where a contract will be created
303      *  - an address where a contract lived, but was destroyed
304      * ====
305      */
306     function isContract(address account) internal view returns (bool) {
307         // This method relies on extcodesize, which returns 0 for contracts in
308         // construction, since the code is only stored at the end of the
309         // constructor execution.
310 
311         uint256 size;
312         assembly {
313             size := extcodesize(account)
314         }
315         return size > 0;
316     }
317 
318     /**
319      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
320      * `recipient`, forwarding all available gas and reverting on errors.
321      *
322      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
323      * of certain opcodes, possibly making contracts go over the 2300 gas limit
324      * imposed by `transfer`, making them unable to receive funds via
325      * `transfer`. {sendValue} removes this limitation.
326      *
327      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
328      *
329      * IMPORTANT: because control is transferred to `recipient`, care must be
330      * taken to not create reentrancy vulnerabilities. Consider using
331      * {ReentrancyGuard} or the
332      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
333      */
334     function sendValue(address payable recipient, uint256 amount) internal {
335         require(address(this).balance >= amount, "Address: insufficient balance");
336 
337         (bool success, ) = recipient.call{value: amount}("");
338         require(success, "Address: unable to send value, recipient may have reverted");
339     }
340 
341     /**
342      * @dev Performs a Solidity function call using a low level `call`. A
343      * plain `call` is an unsafe replacement for a function call: use this
344      * function instead.
345      *
346      * If `target` reverts with a revert reason, it is bubbled up by this
347      * function (like regular Solidity function calls).
348      *
349      * Returns the raw returned data. To convert to the expected return value,
350      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
351      *
352      * Requirements:
353      *
354      * - `target` must be a contract.
355      * - calling `target` with `data` must not revert.
356      *
357      * _Available since v3.1._
358      */
359     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
360         return functionCall(target, data, "Address: low-level call failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
365      * `errorMessage` as a fallback revert reason when `target` reverts.
366      *
367      * _Available since v3.1._
368      */
369     function functionCall(
370         address target,
371         bytes memory data,
372         string memory errorMessage
373     ) internal returns (bytes memory) {
374         return functionCallWithValue(target, data, 0, errorMessage);
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
379      * but also transferring `value` wei to `target`.
380      *
381      * Requirements:
382      *
383      * - the calling contract must have an ETH balance of at least `value`.
384      * - the called Solidity function must be `payable`.
385      *
386      * _Available since v3.1._
387      */
388     function functionCallWithValue(
389         address target,
390         bytes memory data,
391         uint256 value
392     ) internal returns (bytes memory) {
393         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
398      * with `errorMessage` as a fallback revert reason when `target` reverts.
399      *
400      * _Available since v3.1._
401      */
402     function functionCallWithValue(
403         address target,
404         bytes memory data,
405         uint256 value,
406         string memory errorMessage
407     ) internal returns (bytes memory) {
408         require(address(this).balance >= value, "Address: insufficient balance for call");
409         require(isContract(target), "Address: call to non-contract");
410 
411         (bool success, bytes memory returndata) = target.call{value: value}(data);
412         return verifyCallResult(success, returndata, errorMessage);
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
417      * but performing a static call.
418      *
419      * _Available since v3.3._
420      */
421     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
422         return functionStaticCall(target, data, "Address: low-level static call failed");
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
427      * but performing a static call.
428      *
429      * _Available since v3.3._
430      */
431     function functionStaticCall(
432         address target,
433         bytes memory data,
434         string memory errorMessage
435     ) internal view returns (bytes memory) {
436         require(isContract(target), "Address: static call to non-contract");
437 
438         (bool success, bytes memory returndata) = target.staticcall(data);
439         return verifyCallResult(success, returndata, errorMessage);
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
444      * but performing a delegate call.
445      *
446      * _Available since v3.4._
447      */
448     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
449         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
454      * but performing a delegate call.
455      *
456      * _Available since v3.4._
457      */
458     function functionDelegateCall(
459         address target,
460         bytes memory data,
461         string memory errorMessage
462     ) internal returns (bytes memory) {
463         require(isContract(target), "Address: delegate call to non-contract");
464 
465         (bool success, bytes memory returndata) = target.delegatecall(data);
466         return verifyCallResult(success, returndata, errorMessage);
467     }
468 
469     /**
470      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
471      * revert reason using the provided one.
472      *
473      * _Available since v4.3._
474      */
475     function verifyCallResult(
476         bool success,
477         bytes memory returndata,
478         string memory errorMessage
479     ) internal pure returns (bytes memory) {
480         if (success) {
481             return returndata;
482         } else {
483             // Look for revert reason and bubble it up if present
484             if (returndata.length > 0) {
485                 // The easiest way to bubble the revert reason is using memory via assembly
486 
487                 assembly {
488                     let returndata_size := mload(returndata)
489                     revert(add(32, returndata), returndata_size)
490                 }
491             } else {
492                 revert(errorMessage);
493             }
494         }
495     }
496 }
497 
498 // File: @openzeppelin/contracts/utils/Context.sol
499 
500 
501 
502 pragma solidity ^0.8.0;
503 
504 /**
505  * @dev Provides information about the current execution context, including the
506  * sender of the transaction and its data. While these are generally available
507  * via msg.sender and msg.data, they should not be accessed in such a direct
508  * manner, since when dealing with meta-transactions the account sending and
509  * paying for execution may not be the actual sender (as far as an application
510  * is concerned).
511  *
512  * This contract is only required for intermediate, library-like contracts.
513  */
514 abstract contract Context {
515     function _msgSender() internal view virtual returns (address) {
516         return msg.sender;
517     }
518 
519     function _msgData() internal view virtual returns (bytes calldata) {
520         return msg.data;
521     }
522 }
523 
524 // File: @openzeppelin/contracts/utils/Strings.sol
525 
526 
527 
528 pragma solidity ^0.8.0;
529 
530 /**
531  * @dev String operations.
532  */
533 library Strings {
534     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
535 
536     /**
537      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
538      */
539     function toString(uint256 value) internal pure returns (string memory) {
540         // Inspired by OraclizeAPI's implementation - MIT licence
541         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
542 
543         if (value == 0) {
544             return "0";
545         }
546         uint256 temp = value;
547         uint256 digits;
548         while (temp != 0) {
549             digits++;
550             temp /= 10;
551         }
552         bytes memory buffer = new bytes(digits);
553         while (value != 0) {
554             digits -= 1;
555             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
556             value /= 10;
557         }
558         return string(buffer);
559     }
560 
561     /**
562      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
563      */
564     function toHexString(uint256 value) internal pure returns (string memory) {
565         if (value == 0) {
566             return "0x00";
567         }
568         uint256 temp = value;
569         uint256 length = 0;
570         while (temp != 0) {
571             length++;
572             temp >>= 8;
573         }
574         return toHexString(value, length);
575     }
576 
577     /**
578      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
579      */
580     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
581         bytes memory buffer = new bytes(2 * length + 2);
582         buffer[0] = "0";
583         buffer[1] = "x";
584         for (uint256 i = 2 * length + 1; i > 1; --i) {
585             buffer[i] = _HEX_SYMBOLS[value & 0xf];
586             value >>= 4;
587         }
588         require(value == 0, "Strings: hex length insufficient");
589         return string(buffer);
590     }
591 }
592 
593 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
594 
595 
596 
597 pragma solidity ^0.8.0;
598 
599 
600 /**
601  * @dev Implementation of the {IERC165} interface.
602  *
603  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
604  * for the additional interface id that will be supported. For example:
605  *
606  * ```solidity
607  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
608  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
609  * }
610  * ```
611  *
612  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
613  */
614 abstract contract ERC165 is IERC165 {
615     /**
616      * @dev See {IERC165-supportsInterface}.
617      */
618     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
619         return interfaceId == type(IERC165).interfaceId;
620     }
621 }
622 
623 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
624 
625 
626 
627 pragma solidity ^0.8.0;
628 
629 
630 
631 
632 
633 
634 
635 
636 /**
637  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
638  * the Metadata extension, but not including the Enumerable extension, which is available separately as
639  * {ERC721Enumerable}.
640  */
641 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
642     using Address for address;
643     using Strings for uint256;
644 
645     // Token name
646     string private _name;
647 
648     // Token symbol
649     string private _symbol;
650 
651     // Mapping from token ID to owner address
652     mapping(uint256 => address) private _owners;
653 
654     // Mapping owner address to token count
655     mapping(address => uint256) private _balances;
656 
657     // Mapping from token ID to approved address
658     mapping(uint256 => address) private _tokenApprovals;
659 
660     // Mapping from owner to operator approvals
661     mapping(address => mapping(address => bool)) private _operatorApprovals;
662 
663     /**
664      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
665      */
666     constructor(string memory name_, string memory symbol_) {
667         _name = name_;
668         _symbol = symbol_;
669     }
670 
671     /**
672      * @dev See {IERC165-supportsInterface}.
673      */
674     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
675         return
676             interfaceId == type(IERC721).interfaceId ||
677             interfaceId == type(IERC721Metadata).interfaceId ||
678             super.supportsInterface(interfaceId);
679     }
680 
681     /**
682      * @dev See {IERC721-balanceOf}.
683      */
684     function balanceOf(address owner) public view virtual override returns (uint256) {
685         require(owner != address(0), "ERC721: balance query for the zero address");
686         return _balances[owner];
687     }
688 
689     /**
690      * @dev See {IERC721-ownerOf}.
691      */
692     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
693         address owner = _owners[tokenId];
694         require(owner != address(0), "ERC721: owner query for nonexistent token");
695         return owner;
696     }
697 
698     /**
699      * @dev See {IERC721Metadata-name}.
700      */
701     function name() public view virtual override returns (string memory) {
702         return _name;
703     }
704 
705     /**
706      * @dev See {IERC721Metadata-symbol}.
707      */
708     function symbol() public view virtual override returns (string memory) {
709         return _symbol;
710     }
711 
712     /**
713      * @dev See {IERC721Metadata-tokenURI}.
714      */
715     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
716         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
717 
718         string memory baseURI = _baseURI();
719         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
720     }
721 
722     /**
723      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
724      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
725      * by default, can be overriden in child contracts.
726      */
727     function _baseURI() internal view virtual returns (string memory) {
728         return "";
729     }
730 
731     /**
732      * @dev See {IERC721-approve}.
733      */
734     function approve(address to, uint256 tokenId) public virtual override {
735         address owner = ERC721.ownerOf(tokenId);
736         require(to != owner, "ERC721: approval to current owner");
737 
738         require(
739             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
740             "ERC721: approve caller is not owner nor approved for all"
741         );
742 
743         _approve(to, tokenId);
744     }
745 
746     /**
747      * @dev See {IERC721-getApproved}.
748      */
749     function getApproved(uint256 tokenId) public view virtual override returns (address) {
750         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
751 
752         return _tokenApprovals[tokenId];
753     }
754 
755     /**
756      * @dev See {IERC721-setApprovalForAll}.
757      */
758     function setApprovalForAll(address operator, bool approved) public virtual override {
759         require(operator != _msgSender(), "ERC721: approve to caller");
760 
761         _operatorApprovals[_msgSender()][operator] = approved;
762         emit ApprovalForAll(_msgSender(), operator, approved);
763     }
764 
765     /**
766      * @dev See {IERC721-isApprovedForAll}.
767      */
768     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
769         return _operatorApprovals[owner][operator];
770     }
771 
772     /**
773      * @dev See {IERC721-transferFrom}.
774      */
775     function transferFrom(
776         address from,
777         address to,
778         uint256 tokenId
779     ) public virtual override {
780         //solhint-disable-next-line max-line-length
781         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
782 
783         _transfer(from, to, tokenId);
784     }
785 
786     /**
787      * @dev See {IERC721-safeTransferFrom}.
788      */
789     function safeTransferFrom(
790         address from,
791         address to,
792         uint256 tokenId
793     ) public virtual override {
794         safeTransferFrom(from, to, tokenId, "");
795     }
796 
797     /**
798      * @dev See {IERC721-safeTransferFrom}.
799      */
800     function safeTransferFrom(
801         address from,
802         address to,
803         uint256 tokenId,
804         bytes memory _data
805     ) public virtual override {
806         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
807         _safeTransfer(from, to, tokenId, _data);
808     }
809 
810     /**
811      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
812      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
813      *
814      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
815      *
816      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
817      * implement alternative mechanisms to perform token transfer, such as signature-based.
818      *
819      * Requirements:
820      *
821      * - `from` cannot be the zero address.
822      * - `to` cannot be the zero address.
823      * - `tokenId` token must exist and be owned by `from`.
824      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
825      *
826      * Emits a {Transfer} event.
827      */
828     function _safeTransfer(
829         address from,
830         address to,
831         uint256 tokenId,
832         bytes memory _data
833     ) internal virtual {
834         _transfer(from, to, tokenId);
835         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
836     }
837 
838     /**
839      * @dev Returns whether `tokenId` exists.
840      *
841      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
842      *
843      * Tokens start existing when they are minted (`_mint`),
844      * and stop existing when they are burned (`_burn`).
845      */
846     function _exists(uint256 tokenId) internal view virtual returns (bool) {
847         return _owners[tokenId] != address(0);
848     }
849 
850     /**
851      * @dev Returns whether `spender` is allowed to manage `tokenId`.
852      *
853      * Requirements:
854      *
855      * - `tokenId` must exist.
856      */
857     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
858         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
859         address owner = ERC721.ownerOf(tokenId);
860         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
861     }
862 
863     /**
864      * @dev Safely mints `tokenId` and transfers it to `to`.
865      *
866      * Requirements:
867      *
868      * - `tokenId` must not exist.
869      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
870      *
871      * Emits a {Transfer} event.
872      */
873     function _safeMint(address to, uint256 tokenId) internal virtual {
874         _safeMint(to, tokenId, "");
875     }
876 
877     /**
878      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
879      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
880      */
881     function _safeMint(
882         address to,
883         uint256 tokenId,
884         bytes memory _data
885     ) internal virtual {
886         _mint(to, tokenId);
887         require(
888             _checkOnERC721Received(address(0), to, tokenId, _data),
889             "ERC721: transfer to non ERC721Receiver implementer"
890         );
891     }
892 
893     /**
894      * @dev Mints `tokenId` and transfers it to `to`.
895      *
896      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
897      *
898      * Requirements:
899      *
900      * - `tokenId` must not exist.
901      * - `to` cannot be the zero address.
902      *
903      * Emits a {Transfer} event.
904      */
905     function _mint(address to, uint256 tokenId) internal virtual {
906         require(to != address(0), "ERC721: mint to the zero address");
907         require(!_exists(tokenId), "ERC721: token already minted");
908 
909         _beforeTokenTransfer(address(0), to, tokenId);
910 
911         _balances[to] += 1;
912         _owners[tokenId] = to;
913 
914         emit Transfer(address(0), to, tokenId);
915     }
916 
917     /**
918      * @dev Destroys `tokenId`.
919      * The approval is cleared when the token is burned.
920      *
921      * Requirements:
922      *
923      * - `tokenId` must exist.
924      *
925      * Emits a {Transfer} event.
926      */
927     function _burn(uint256 tokenId) internal virtual {
928         address owner = ERC721.ownerOf(tokenId);
929 
930         _beforeTokenTransfer(owner, address(0), tokenId);
931 
932         // Clear approvals
933         _approve(address(0), tokenId);
934 
935         _balances[owner] -= 1;
936         delete _owners[tokenId];
937 
938         emit Transfer(owner, address(0), tokenId);
939     }
940 
941     /**
942      * @dev Transfers `tokenId` from `from` to `to`.
943      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
944      *
945      * Requirements:
946      *
947      * - `to` cannot be the zero address.
948      * - `tokenId` token must be owned by `from`.
949      *
950      * Emits a {Transfer} event.
951      */
952     function _transfer(
953         address from,
954         address to,
955         uint256 tokenId
956     ) internal virtual {
957         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
958         require(to != address(0), "ERC721: transfer to the zero address");
959 
960         _beforeTokenTransfer(from, to, tokenId);
961 
962         // Clear approvals from the previous owner
963         _approve(address(0), tokenId);
964 
965         _balances[from] -= 1;
966         _balances[to] += 1;
967         _owners[tokenId] = to;
968 
969         emit Transfer(from, to, tokenId);
970     }
971 
972     /**
973      * @dev Approve `to` to operate on `tokenId`
974      *
975      * Emits a {Approval} event.
976      */
977     function _approve(address to, uint256 tokenId) internal virtual {
978         _tokenApprovals[tokenId] = to;
979         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
980     }
981 
982     /**
983      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
984      * The call is not executed if the target address is not a contract.
985      *
986      * @param from address representing the previous owner of the given token ID
987      * @param to target address that will receive the tokens
988      * @param tokenId uint256 ID of the token to be transferred
989      * @param _data bytes optional data to send along with the call
990      * @return bool whether the call correctly returned the expected magic value
991      */
992     function _checkOnERC721Received(
993         address from,
994         address to,
995         uint256 tokenId,
996         bytes memory _data
997     ) private returns (bool) {
998         if (to.isContract()) {
999             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1000                 return retval == IERC721Receiver.onERC721Received.selector;
1001             } catch (bytes memory reason) {
1002                 if (reason.length == 0) {
1003                     revert("ERC721: transfer to non ERC721Receiver implementer");
1004                 } else {
1005                     assembly {
1006                         revert(add(32, reason), mload(reason))
1007                     }
1008                 }
1009             }
1010         } else {
1011             return true;
1012         }
1013     }
1014 
1015     /**
1016      * @dev Hook that is called before any token transfer. This includes minting
1017      * and burning.
1018      *
1019      * Calling conditions:
1020      *
1021      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1022      * transferred to `to`.
1023      * - When `from` is zero, `tokenId` will be minted for `to`.
1024      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1025      * - `from` and `to` are never both zero.
1026      *
1027      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1028      */
1029     function _beforeTokenTransfer(
1030         address from,
1031         address to,
1032         uint256 tokenId
1033     ) internal virtual {}
1034 }
1035 
1036 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1037 
1038 
1039 
1040 pragma solidity ^0.8.0;
1041 
1042 /**
1043  * @dev Contract module that helps prevent reentrant calls to a function.
1044  *
1045  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1046  * available, which can be applied to functions to make sure there are no nested
1047  * (reentrant) calls to them.
1048  *
1049  * Note that because there is a single `nonReentrant` guard, functions marked as
1050  * `nonReentrant` may not call one another. This can be worked around by making
1051  * those functions `private`, and then adding `external` `nonReentrant` entry
1052  * points to them.
1053  *
1054  * TIP: If you would like to learn more about reentrancy and alternative ways
1055  * to protect against it, check out our blog post
1056  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1057  */
1058 abstract contract ReentrancyGuard {
1059     // Booleans are more expensive than uint256 or any type that takes up a full
1060     // word because each write operation emits an extra SLOAD to first read the
1061     // slot's contents, replace the bits taken up by the boolean, and then write
1062     // back. This is the compiler's defense against contract upgrades and
1063     // pointer aliasing, and it cannot be disabled.
1064 
1065     // The values being non-zero value makes deployment a bit more expensive,
1066     // but in exchange the refund on every call to nonReentrant will be lower in
1067     // amount. Since refunds are capped to a percentage of the total
1068     // transaction's gas, it is best to keep them low in cases like this one, to
1069     // increase the likelihood of the full refund coming into effect.
1070     uint256 private constant _NOT_ENTERED = 1;
1071     uint256 private constant _ENTERED = 2;
1072 
1073     uint256 private _status;
1074 
1075     constructor() {
1076         _status = _NOT_ENTERED;
1077     }
1078 
1079     /**
1080      * @dev Prevents a contract from calling itself, directly or indirectly.
1081      * Calling a `nonReentrant` function from another `nonReentrant`
1082      * function is not supported. It is possible to prevent this from happening
1083      * by making the `nonReentrant` function external, and make it call a
1084      * `private` function that does the actual work.
1085      */
1086     modifier nonReentrant() {
1087         // On the first call to nonReentrant, _notEntered will be true
1088         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1089 
1090         // Any calls to nonReentrant after this point will fail
1091         _status = _ENTERED;
1092 
1093         _;
1094 
1095         // By storing the original value once again, a refund is triggered (see
1096         // https://eips.ethereum.org/EIPS/eip-2200)
1097         _status = _NOT_ENTERED;
1098     }
1099 }
1100 
1101 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
1102 
1103 
1104 
1105 pragma solidity ^0.8.0;
1106 
1107 // CAUTION
1108 // This version of SafeMath should only be used with Solidity 0.8 or later,
1109 // because it relies on the compiler's built in overflow checks.
1110 
1111 /**
1112  * @dev Wrappers over Solidity's arithmetic operations.
1113  *
1114  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1115  * now has built in overflow checking.
1116  */
1117 library SafeMath {
1118     /**
1119      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1120      *
1121      * _Available since v3.4._
1122      */
1123     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1124             uint256 c = a + b;
1125             if (c < a) return (false, 0);
1126             return (true, c);
1127     }
1128 
1129     /**
1130      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1131      *
1132      * _Available since v3.4._
1133      */
1134     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1135             if (b > a) return (false, 0);
1136             return (true, a - b);
1137     }
1138 
1139     /**
1140      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1141      *
1142      * _Available since v3.4._
1143      */
1144     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1145             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1146             // benefit is lost if 'b' is also tested.
1147             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1148             if (a == 0) return (true, 0);
1149             uint256 c = a * b;
1150             if (c / a != b) return (false, 0);
1151             return (true, c);
1152     }
1153 
1154     /**
1155      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1156      *
1157      * _Available since v3.4._
1158      */
1159     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1160             if (b == 0) return (false, 0);
1161             return (true, a / b);
1162     }
1163 
1164     /**
1165      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1166      *
1167      * _Available since v3.4._
1168      */
1169     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1170             if (b == 0) return (false, 0);
1171             return (true, a % b);
1172     }
1173 
1174     /**
1175      * @dev Returns the addition of two unsigned integers, reverting on
1176      * overflow.
1177      *
1178      * Counterpart to Solidity's `+` operator.
1179      *
1180      * Requirements:
1181      *
1182      * - Addition cannot overflow.
1183      */
1184     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1185         return a + b;
1186     }
1187 
1188     /**
1189      * @dev Returns the subtraction of two unsigned integers, reverting on
1190      * overflow (when the result is negative).
1191      *
1192      * Counterpart to Solidity's `-` operator.
1193      *
1194      * Requirements:
1195      *
1196      * - Subtraction cannot overflow.
1197      */
1198     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1199         return a - b;
1200     }
1201 
1202     /**
1203      * @dev Returns the multiplication of two unsigned integers, reverting on
1204      * overflow.
1205      *
1206      * Counterpart to Solidity's `*` operator.
1207      *
1208      * Requirements:
1209      *
1210      * - Multiplication cannot overflow.
1211      */
1212     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1213         return a * b;
1214     }
1215 
1216     /**
1217      * @dev Returns the integer division of two unsigned integers, reverting on
1218      * division by zero. The result is rounded towards zero.
1219      *
1220      * Counterpart to Solidity's `/` operator.
1221      *
1222      * Requirements:
1223      *
1224      * - The divisor cannot be zero.
1225      */
1226     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1227         return a / b;
1228     }
1229 
1230     /**
1231      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1232      * reverting when dividing by zero.
1233      *
1234      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1235      * opcode (which leaves remaining gas untouched) while Solidity uses an
1236      * invalid opcode to revert (consuming all remaining gas).
1237      *
1238      * Requirements:
1239      *
1240      * - The divisor cannot be zero.
1241      */
1242     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1243         return a % b;
1244     }
1245 
1246     /**
1247      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1248      * overflow (when the result is negative).
1249      *
1250      * CAUTION: This function is deprecated because it requires allocating memory for the error
1251      * message unnecessarily. For custom revert reasons use {trySub}.
1252      *
1253      * Counterpart to Solidity's `-` operator.
1254      *
1255      * Requirements:
1256      *
1257      * - Subtraction cannot overflow.
1258      */
1259     function sub(
1260         uint256 a,
1261         uint256 b,
1262         string memory errorMessage
1263     ) internal pure returns (uint256) {
1264             require(b <= a, errorMessage);
1265             return a - b;
1266     }
1267 
1268     /**
1269      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1270      * division by zero. The result is rounded towards zero.
1271      *
1272      * Counterpart to Solidity's `/` operator. Note: this function uses a
1273      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1274      * uses an invalid opcode to revert (consuming all remaining gas).
1275      *
1276      * Requirements:
1277      *
1278      * - The divisor cannot be zero.
1279      */
1280     function div(
1281         uint256 a,
1282         uint256 b,
1283         string memory errorMessage
1284     ) internal pure returns (uint256) {
1285             require(b > 0, errorMessage);
1286             return a / b;
1287     }
1288 
1289     /**
1290      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1291      * reverting with custom message when dividing by zero.
1292      *
1293      * CAUTION: This function is deprecated because it requires allocating memory for the error
1294      * message unnecessarily. For custom revert reasons use {tryMod}.
1295      *
1296      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1297      * opcode (which leaves remaining gas untouched) while Solidity uses an
1298      * invalid opcode to revert (consuming all remaining gas).
1299      *
1300      * Requirements:
1301      *
1302      * - The divisor cannot be zero.
1303      */
1304     function mod(
1305         uint256 a,
1306         uint256 b,
1307         string memory errorMessage
1308     ) internal pure returns (uint256) {
1309             require(b > 0, errorMessage);
1310             return a % b;
1311     }
1312 }
1313 
1314 // File: @openzeppelin/contracts/access/Ownable.sol
1315 
1316 
1317 
1318 pragma solidity ^0.8.0;
1319 
1320 
1321 /**
1322  * @dev Contract module which provides a basic access control mechanism, where
1323  * there is an account (an owner) that can be granted exclusive access to
1324  * specific functions.
1325  *
1326  * By default, the owner account will be the one that deploys the contract. This
1327  * can later be changed with {transferOwnership}.
1328  *
1329  * This module is used through inheritance. It will make available the modifier
1330  * `onlyOwner`, which can be applied to your functions to restrict their use to
1331  * the owner.
1332  */
1333 abstract contract Ownable is Context {
1334     address private _owner;
1335 
1336     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1337 
1338     /**
1339      * @dev Initializes the contract setting the deployer as the initial owner.
1340      */
1341     constructor() {
1342         _setOwner(_msgSender());
1343     }
1344 
1345     /**
1346      * @dev Returns the address of the current owner.
1347      */
1348     function owner() public view virtual returns (address) {
1349         return _owner;
1350     }
1351 
1352     /**
1353      * @dev Throws if called by any account other than the owner.
1354      */
1355     modifier onlyOwner() {
1356         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1357         _;
1358     }
1359 
1360     /**
1361      * @dev Leaves the contract without owner. It will not be possible to call
1362      * `onlyOwner` functions anymore. Can only be called by the current owner.
1363      *
1364      * NOTE: Renouncing ownership will leave the contract without an owner,
1365      * thereby removing any functionality that is only available to the owner.
1366      */
1367     function renounceOwnership() public virtual onlyOwner {
1368         _setOwner(address(0));
1369     }
1370 
1371     /**
1372      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1373      * Can only be called by the current owner.
1374      */
1375     function transferOwnership(address newOwner) public virtual onlyOwner {
1376         require(newOwner != address(0), "Ownable: new owner is the zero address");
1377         _setOwner(newOwner);
1378     }
1379 
1380     function _setOwner(address newOwner) private {
1381         address oldOwner = _owner;
1382         _owner = newOwner;
1383         emit OwnershipTransferred(oldOwner, newOwner);
1384     }
1385 }
1386 
1387 // File: contracts/Utils/IUtils.sol
1388 
1389 
1390 pragma solidity ^0.8.0;
1391 
1392 
1393 interface IUtils {
1394     // Strings.sol
1395     function toString(uint256 value) external pure returns (string memory);
1396     function toHexString(uint256 value) external pure returns (string memory);
1397     function toHexString(uint256 value, uint256 length) external pure returns (string memory);    
1398     // Base64.sol
1399     function encode(bytes memory data) external pure returns (string memory);
1400     // KeyValueStorage.sol
1401     struct StorageItemArg { string key; string value; }
1402     function set(string memory _key, string memory _value, address[] memory _whitelist) external;
1403     function setBatch(StorageItemArg[] memory _storageItems, address _whitelist) external;
1404     function setValue(string memory _key, string memory _value) external;
1405     function setWhitelist(string memory _key, address[] memory _whitelist) external;
1406     function getValue(string memory _key) external view returns (string memory);
1407 
1408 }
1409 
1410 // File: contracts/GmRenderer.sol
1411 
1412 
1413 
1414 pragma solidity ^0.8.0;
1415 
1416 
1417 
1418 
1419 contract GmRenderer is Ownable {
1420     
1421     IUtils UTILS_CONTRACT = IUtils(0x0000000000000000000000000000000000000000);
1422 
1423 
1424     function setUtilsContractAddress(address _address) public onlyOwner {
1425         UTILS_CONTRACT = IUtils(_address);
1426     }
1427 
1428 
1429     mapping(uint16 => uint32) internal dna_bank;
1430     uint16 public gm_count;
1431     string[21] private kolor = [
1432         'EFFD5F',
1433         'FFFFFF',
1434         'B2BEB5',
1435         'FFFDD0',
1436         'E3B778',
1437         '000000',
1438         '30D5C8',
1439         '30D5C8',
1440         'BFFF00',
1441         'd73b3e',
1442         'FFFDD0',
1443         'ffc0cb',
1444         '000000',
1445         'B2BEB5',
1446         '36454f',
1447         'FFFFFF',
1448         '795c32',
1449         '4b382a',
1450         '36454f',
1451         '6F8FAF',
1452         'e0115f'
1453     ];
1454     
1455     function random() internal view returns (uint32) {
1456         return uint32(uint256(keccak256(abi.encodePacked(msg.sender, dna_bank[gm_count-1]))));
1457     }
1458     
1459     function get_h() internal view returns (string memory) {
1460         return UTILS_CONTRACT.getValue("gm_get_h");
1461     }
1462     function get_r(string memory _f) internal pure returns (string memory) {
1463         return string(abi.encodePacked('<rect height="600" width="600" y="0" x="0" fill="#', _f, '"/>'));
1464     }
1465     function get_e(string memory _s, string memory _f) internal pure returns (string memory) {
1466         return string(abi.encodePacked('<ellipse ry="297" rx="297" cy="300" cx="300" stroke="#', _s, '" stroke-width="5px" fill="#', _f, '"/></g>'));
1467     }
1468     
1469     function get_g(string memory _s, string memory _f) internal pure returns (string memory) {
1470         return string(abi.encodePacked('<g filter="url(#sh)" transform="scale(0.75)" stroke="#', _s, '" stroke-width="0.1px" fill="#', _f, '">'));
1471     }
1472     
1473     function get_p_string(uint8 _c) internal pure returns (string memory) {
1474         if (_c < 20){
1475             return "c"; 
1476         }
1477         if (_c < 30){
1478             return "c_u"; 
1479         }
1480         if (_c < 33){
1481             return "c_u_i"; 
1482         }
1483         if (_c < 53){
1484             return "h"; 
1485         }
1486         if (_c < 63){
1487             return "h_u"; 
1488         }
1489         if (_c < 66){
1490             return "h_u_i"; 
1491         }
1492         if (_c < 86){
1493             return "t"; 
1494         }
1495         if (_c < 96){
1496             return "t_u"; 
1497         }
1498         return "t_u_i"; 
1499     }
1500 
1501     function get_p(string memory _f, string memory _t) internal view returns (string memory) {
1502         return string(abi.encodePacked(
1503             UTILS_CONTRACT.getValue(string(abi.encodePacked("g_", _f))),
1504             UTILS_CONTRACT.getValue(string(abi.encodePacked(_t, "_", _f)))        
1505         )); 
1506     }
1507 
1508     function get_f(string memory _f) internal pure returns (string memory) {
1509         return string(abi.encodePacked('<filter id="sh" x="0" y="0" width="300%" height="300%"><feDropShadow dx="10" dy="10" stdDeviation="0" flood-color="#', _f, '" flood-opacity="1"></feDropShadow></filter></g></svg>'));
1510     }
1511     
1512     struct DNA_Decoded {
1513         // rect kolor
1514         string _r;
1515         // ellipse stroke
1516         string _es;
1517         // ellipse fill
1518         string _ef;
1519         // text stroke
1520         string _gs;
1521         // text fill
1522         string _gf;
1523         // font
1524         string _p;
1525         // text shadow
1526         string _f;
1527     }
1528     
1529     function decode_dna(uint _initial) internal view returns (DNA_Decoded memory) {
1530         // rect kolor
1531         string memory r = kolor[uint8(_initial % 21)];
1532         // ellipse stroke
1533         string memory es = kolor[uint8((_initial / 21) % 21)];
1534         // ellipse fill
1535         string memory ef = kolor[uint8((_initial / 21 ** 2) % 21)];
1536         // text stroke
1537         string memory gs = kolor[uint8((_initial / 21 ** 3) % 21)];
1538         // text fill
1539         string memory gf = kolor[uint8((_initial / 21 ** 4) % 21)];
1540         // font
1541         string memory p = get_p_string(uint8(_initial % 101));
1542         // text shadow 
1543         string memory f = kolor[uint8((_initial / 21 ** 5) % 21)];
1544         DNA_Decoded memory d = DNA_Decoded(r, es, ef, gs, gf, p, f);
1545         return d;
1546     }
1547 
1548     function show(uint16 _i, string memory _t) internal view returns (string memory){
1549         require(_i > 0, "gm");
1550         DNA_Decoded memory d  = decode_dna(dna_bank[_i]);
1551         string memory svg = string(abi.encodePacked(
1552             get_h(),
1553             get_r(d._r),
1554             get_e(d._es, d._ef),
1555             get_g(d._gs, d._gf),
1556             get_p(d._p, _t),
1557             get_f(d._f)));
1558         return svg;
1559     }
1560 
1561     
1562     constructor() onlyOwner {}
1563 
1564 
1565 }
1566 
1567 // File: contracts/GmErc721.sol
1568 
1569 
1570 pragma solidity ^0.8.2;
1571 
1572 
1573 
1574 
1575 
1576 contract GmErc721 is
1577     ERC721,
1578     ReentrancyGuard,
1579     GmRenderer
1580 {
1581     using SafeMath for uint256;
1582     using SafeMath for uint16;
1583 
1584 
1585     string private withdrawAddress = "";
1586 
1587     uint256 MAX_SUPPLY = 4444;
1588 
1589     mapping(uint256 => uint8) public _gmtMapping;
1590     mapping(uint256 => uint8) public _gmOffsetMapping;
1591     mapping(uint256 => uint8) public _gnOffsetMapping;
1592 
1593     function withdrawToPayees(uint256 _amount) internal {
1594         payable(0x3B99E794378bD057F3AD7aEA9206fB6C01f3Ee60).transfer(
1595             _amount.mul(33).div(100)
1596         ); // artist
1597 
1598         payable(0x575CBC1D88c266B18f1BB221C1a1a79A55A3d3BE).transfer(
1599             _amount.mul(33).div(100)
1600         ); // developer
1601 
1602         payable(0xBF7288346588897afdae38288fff58d2e27dd235).transfer(
1603             _amount.mul(33).div(100)
1604         ); // developer
1605     }
1606 
1607     function _mint(address _to) internal {
1608         gm_count++;
1609         dna_bank[gm_count] = random();
1610         _safeMint(_to, gm_count);
1611     }
1612 
1613     function generate() external nonReentrant {
1614         require(gm_count.add(1) <= MAX_SUPPLY, "sold out");
1615         _mint(msg.sender);
1616         if (gm_count % 100 == 99) {
1617             _mint(address(0x3B99E794378bD057F3AD7aEA9206fB6C01f3Ee60));
1618         }
1619     }
1620 
1621     function render(uint256) private view returns (string memory) {
1622         return UTILS_CONTRACT.getValue("gm_get_b");
1623     }
1624 
1625     function set_gmt(uint256 _tokenId, uint8 _gmt) public {
1626         require(msg.sender == ownerOf(_tokenId), "mind your own gm");
1627         require(_gmt <= 23, "only up to 12 hours of offset is allowed");
1628         _gmtMapping[_tokenId] = _gmt;
1629     }
1630 
1631     function set_gmOffset(uint256 _tokenId, uint8 _gmOffset) public {
1632         require(msg.sender == ownerOf(_tokenId), "mind your own gm");
1633         require(_gmOffset <= 12, "only up to 12 hours of offset is allowed");
1634         _gmOffsetMapping[_tokenId] = _gmOffset;
1635     }
1636 
1637     function set_gnOffset(uint256 _tokenId, uint8 _gnOffset) public {
1638         require(msg.sender == ownerOf(_tokenId), "mind your own gm");
1639         require(_gnOffset <= 12, "only up to 12 hours of offset is allowed");
1640         _gnOffsetMapping[_tokenId] = _gnOffset;
1641     }
1642 
1643     function gm_gn(uint256 _tokenId) public view returns (string memory) {
1644         string memory _t = "m";
1645         uint8 _local_time = what_time_is_it(_tokenId);
1646         if (
1647             _local_time > 12 + _gnOffsetMapping[_tokenId] ||
1648             _local_time < 0 + _gmOffsetMapping[_tokenId]
1649         ) {
1650             _t = "n";
1651         }
1652         return _t;
1653     }
1654     
1655     function what_time_is_it(uint256 _tokenId) public view returns (uint8){
1656         return uint8((block.timestamp / 60 / 60) + _gmtMapping[_tokenId]) % 24;
1657     }
1658 
1659     function getAttributes(uint256 tokenId)
1660         internal
1661         view
1662         returns (string memory)
1663     {
1664         DNA_Decoded memory d;
1665         uint256 dna;
1666         string memory traits1;
1667         string memory traits2;
1668         {
1669             dna = dna_bank[uint16(tokenId)];
1670         }
1671         {
1672             d = decode_dna(dna);
1673         }
1674         {
1675             traits1 = string(
1676                 abi.encodePacked(
1677                     '[{"trait_type": "Background Kolor", "value": "',
1678                     d._r,
1679                     '"}, {"trait_type": "Outline Kolor", "value": "',
1680                     d._es,
1681                     '"}, {"trait_type": "Circle Kolor", "value": "',
1682                     d._ef,
1683                     '"}, '
1684                 )
1685             );
1686         }
1687         {
1688             traits2 = string(
1689                 abi.encodePacked(
1690                     '{"trait_type": "Text Outline Kolor", "value": "',
1691                     d._gs,
1692                     '"}, {"trait_type": "Text Kolor", "value": "',
1693                     d._gf,
1694                     '"},  {"trait_type": "Text Shadow Kolor", "value": "',
1695                     d._f,
1696                     '"}, {"trait_type": "Font", "value": "',
1697                     d._p,
1698                     '"}]'
1699                 )
1700             );
1701         }
1702         return string(abi.encodePacked(traits1, traits2));
1703     }
1704 
1705     function tokenURI(uint256 tokenId)
1706         public
1707         view
1708         override(ERC721)
1709         returns (string memory)
1710     {
1711         super.tokenURI(tokenId);
1712         return
1713             string(
1714                 abi.encodePacked(
1715                     "data:application/json;base64,",
1716                     UTILS_CONTRACT.encode(
1717                         bytes(
1718                             abi.encodePacked(
1719                                 '{"attributes": ',
1720                                 getAttributes(tokenId),
1721                                 ',  "name": "say it back! #',
1722                                 UTILS_CONTRACT.toString(tokenId),
1723                                 '", "description": "4444 on-chain generated & stored daily messages - visit etherscan contract to set it to your time zone (do not compromise your opSec). say it back!", "image": "data:image/svg+xml;base64,',
1724                                 string(
1725                                     UTILS_CONTRACT.encode(
1726                                         bytes(
1727                                             abi.encodePacked(
1728                                                 show(
1729                                                     uint16(tokenId),
1730                                                     gm_gn(tokenId)
1731                                                 )
1732                                             )
1733                                         )
1734                                     )
1735                                 ),
1736                                 '"}'
1737                             )
1738                         )
1739                     ),
1740                     "#"
1741                 )
1742             );
1743     }
1744 
1745   
1746   
1747     function setWithdrawAddress(string memory _address) public onlyOwner {
1748         withdrawAddress = _address;
1749     }
1750   
1751     function contractURI() public view returns (string memory) {
1752         return
1753             string(
1754                 abi.encodePacked(
1755                     "data:application/json;base64,",
1756                     UTILS_CONTRACT.encode(
1757                         bytes(
1758                             abi.encodePacked(
1759                                 '{"name": "say it back!", "description": "4444 on-chain generated & stored daily messages - visit etherscan contract to set it to your time zone (do not compromise your opSec). say it back!", "seller_fee_basis_points": 690, "fee_recipient": "',
1760                                 withdrawAddress,
1761                                 '"}'
1762                             )
1763                         )
1764                     )
1765                 )
1766             );
1767     }
1768 
1769     receive() external payable {
1770         withdrawToPayees(msg.value);
1771     }
1772 
1773     function supportsInterface(bytes4 interfaceId)
1774         public
1775         view
1776         virtual
1777         override(ERC721)
1778         returns (bool)
1779     {
1780         return
1781             ERC721.supportsInterface(interfaceId);
1782     }
1783 
1784     constructor()
1785         //address _utilsAddress
1786         ERC721("GM", "GM")
1787         onlyOwner
1788     {
1789         //setUtilsContractAddress(_utilsAddress);
1790     }
1791 }