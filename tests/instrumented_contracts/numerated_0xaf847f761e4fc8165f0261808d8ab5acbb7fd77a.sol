1 /**
2  *Submitted for verification at Etherscan.io on 2021-10-28
3 */
4 
5 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.2
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Interface of the ERC165 standard, as defined in the
13  * https://eips.ethereum.org/EIPS/eip-165[EIP].
14  *
15  * Implementers can declare support of contract interfaces, which can then be
16  * queried by others ({ERC165Checker}).
17  *
18  * For an implementation, see {ERC165}.
19  */
20 interface IERC165 {
21     /**
22      * @dev Returns true if this contract implements the interface defined by
23      * `interfaceId`. See the corresponding
24      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
25      * to learn more about how these ids are created.
26      *
27      * This function call must use less than 30 000 gas.
28      */
29     function supportsInterface(bytes4 interfaceId) external view returns (bool);
30 }
31 
32 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.2
33 
34 /**
35  * @dev Required interface of an ERC721 compliant contract.
36  */
37 interface IERC721 is IERC165 {
38     /**
39      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
40      */
41     event Transfer(
42         address indexed from,
43         address indexed to,
44         uint256 indexed tokenId
45     );
46 
47     /**
48      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
49      */
50     event Approval(
51         address indexed owner,
52         address indexed approved,
53         uint256 indexed tokenId
54     );
55 
56     /**
57      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
58      */
59     event ApprovalForAll(
60         address indexed owner,
61         address indexed operator,
62         bool approved
63     );
64 
65     /**
66      * @dev Returns the number of tokens in ``owner``'s account.
67      */
68     function balanceOf(address owner) external view returns (uint256 balance);
69 
70     /**
71      * @dev Returns the owner of the `tokenId` token.
72      *
73      * Requirements:
74      *
75      * - `tokenId` must exist.
76      */
77     function ownerOf(uint256 tokenId) external view returns (address owner);
78 
79     /**
80      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
81      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
82      *
83      * Requirements:
84      *
85      * - `from` cannot be the zero address.
86      * - `to` cannot be the zero address.
87      * - `tokenId` token must exist and be owned by `from`.
88      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
89      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
90      *
91      * Emits a {Transfer} event.
92      */
93     function safeTransferFrom(
94         address from,
95         address to,
96         uint256 tokenId
97     ) external;
98 
99     /**
100      * @dev Transfers `tokenId` token from `from` to `to`.
101      *
102      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
103      *
104      * Requirements:
105      *
106      * - `from` cannot be the zero address.
107      * - `to` cannot be the zero address.
108      * - `tokenId` token must be owned by `from`.
109      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
110      *
111      * Emits a {Transfer} event.
112      */
113     function transferFrom(
114         address from,
115         address to,
116         uint256 tokenId
117     ) external;
118 
119     /**
120      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
121      * The approval is cleared when the token is transferred.
122      *
123      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
124      *
125      * Requirements:
126      *
127      * - The caller must own the token or be an approved operator.
128      * - `tokenId` must exist.
129      *
130      * Emits an {Approval} event.
131      */
132     function approve(address to, uint256 tokenId) external;
133 
134     /**
135      * @dev Returns the account approved for `tokenId` token.
136      *
137      * Requirements:
138      *
139      * - `tokenId` must exist.
140      */
141     function getApproved(uint256 tokenId)
142         external
143         view
144         returns (address operator);
145 
146     /**
147      * @dev Approve or remove `operator` as an operator for the caller.
148      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
149      *
150      * Requirements:
151      *
152      * - The `operator` cannot be the caller.
153      *
154      * Emits an {ApprovalForAll} event.
155      */
156     function setApprovalForAll(address operator, bool _approved) external;
157 
158     /**
159      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
160      *
161      * See {setApprovalForAll}
162      */
163     function isApprovedForAll(address owner, address operator)
164         external
165         view
166         returns (bool);
167 
168     /**
169      * @dev Safely transfers `tokenId` token from `from` to `to`.
170      *
171      * Requirements:
172      *
173      * - `from` cannot be the zero address.
174      * - `to` cannot be the zero address.
175      * - `tokenId` token must exist and be owned by `from`.
176      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
177      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
178      *
179      * Emits a {Transfer} event.
180      */
181     function safeTransferFrom(
182         address from,
183         address to,
184         uint256 tokenId,
185         bytes calldata data
186     ) external;
187 }
188 
189 
190 
191 
192 
193 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.2
194 
195 /**
196  * @title ERC721 token receiver interface
197  * @dev Interface for any contract that wants to support safeTransfers
198  * from ERC721 asset contracts.
199  */
200 interface IERC721Receiver {
201     /**
202      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
203      * by `operator` from `from`, this function is called.
204      *
205      * It must return its Solidity selector to confirm the token transfer.
206      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
207      *
208      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
209      */
210     function onERC721Received(
211         address operator,
212         address from,
213         uint256 tokenId,
214         bytes calldata data
215     ) external returns (bytes4);
216 }
217 
218 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.2
219 
220 /**
221  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
222  * @dev See https://eips.ethereum.org/EIPS/eip-721
223  */
224 interface IERC721Metadata is IERC721 {
225     /**
226      * @dev Returns the token collection name.
227      */
228     function name() external view returns (string memory);
229 
230     /**
231      * @dev Returns the token collection symbol.
232      */
233     function symbol() external view returns (string memory);
234 
235     /**
236      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
237      */
238     function tokenURI(uint256 tokenId) external view returns (string memory);
239 }
240 
241 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
242 
243 /**
244  * @dev Collection of functions related to the address type
245  */
246 library Address {
247     /**
248      * @dev Returns true if `account` is a contract.
249      *
250      * [IMPORTANT]
251      * ====
252      * It is unsafe to assume that an address for which this function returns
253      * false is an externally-owned account (EOA) and not a contract.
254      *
255      * Among others, `isContract` will return false for the following
256      * types of addresses:
257      *
258      *  - an externally-owned account
259      *  - a contract in construction
260      *  - an address where a contract will be created
261      *  - an address where a contract lived, but was destroyed
262      * ====
263      */
264     function isContract(address account) internal view returns (bool) {
265         // This method relies on extcodesize, which returns 0 for contracts in
266         // construction, since the code is only stored at the end of the
267         // constructor execution.
268 
269         uint256 size;
270         assembly {
271             size := extcodesize(account)
272         }
273         return size > 0;
274     }
275 
276     /**
277      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
278      * `recipient`, forwarding all available gas and reverting on errors.
279      *
280      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
281      * of certain opcodes, possibly making contracts go over the 2300 gas limit
282      * imposed by `transfer`, making them unable to receive funds via
283      * `transfer`. {sendValue} removes this limitation.
284      *
285      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
286      *
287      * IMPORTANT: because control is transferred to `recipient`, care must be
288      * taken to not create reentrancy vulnerabilities. Consider using
289      * {ReentrancyGuard} or the
290      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
291      */
292     function sendValue(address payable recipient, uint256 amount) internal {
293         require(
294             address(this).balance >= amount,
295             "Address: insufficient balance"
296         );
297 
298         (bool success, ) = recipient.call{value: amount}("");
299         require(
300             success,
301             "Address: unable to send value, recipient may have reverted"
302         );
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain `call` is an unsafe replacement for a function call: use this
308      * function instead.
309      *
310      * If `target` reverts with a revert reason, it is bubbled up by this
311      * function (like regular Solidity function calls).
312      *
313      * Returns the raw returned data. To convert to the expected return value,
314      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
315      *
316      * Requirements:
317      *
318      * - `target` must be a contract.
319      * - calling `target` with `data` must not revert.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data)
324         internal
325         returns (bytes memory)
326     {
327         return functionCall(target, data, "Address: low-level call failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
332      * `errorMessage` as a fallback revert reason when `target` reverts.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(
337         address target,
338         bytes memory data,
339         string memory errorMessage
340     ) internal returns (bytes memory) {
341         return functionCallWithValue(target, data, 0, errorMessage);
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
346      * but also transferring `value` wei to `target`.
347      *
348      * Requirements:
349      *
350      * - the calling contract must have an ETH balance of at least `value`.
351      * - the called Solidity function must be `payable`.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(
356         address target,
357         bytes memory data,
358         uint256 value
359     ) internal returns (bytes memory) {
360         return
361             functionCallWithValue(
362                 target,
363                 data,
364                 value,
365                 "Address: low-level call with value failed"
366             );
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
371      * with `errorMessage` as a fallback revert reason when `target` reverts.
372      *
373      * _Available since v3.1._
374      */
375     function functionCallWithValue(
376         address target,
377         bytes memory data,
378         uint256 value,
379         string memory errorMessage
380     ) internal returns (bytes memory) {
381         require(
382             address(this).balance >= value,
383             "Address: insufficient balance for call"
384         );
385         require(isContract(target), "Address: call to non-contract");
386 
387         (bool success, bytes memory returndata) = target.call{value: value}(
388             data
389         );
390         return verifyCallResult(success, returndata, errorMessage);
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
395      * but performing a static call.
396      *
397      * _Available since v3.3._
398      */
399     function functionStaticCall(address target, bytes memory data)
400         internal
401         view
402         returns (bytes memory)
403     {
404         return
405             functionStaticCall(
406                 target,
407                 data,
408                 "Address: low-level static call failed"
409             );
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
414      * but performing a static call.
415      *
416      * _Available since v3.3._
417      */
418     function functionStaticCall(
419         address target,
420         bytes memory data,
421         string memory errorMessage
422     ) internal view returns (bytes memory) {
423         require(isContract(target), "Address: static call to non-contract");
424 
425         (bool success, bytes memory returndata) = target.staticcall(data);
426         return verifyCallResult(success, returndata, errorMessage);
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
431      * but performing a delegate call.
432      *
433      * _Available since v3.4._
434      */
435     function functionDelegateCall(address target, bytes memory data)
436         internal
437         returns (bytes memory)
438     {
439         return
440             functionDelegateCall(
441                 target,
442                 data,
443                 "Address: low-level delegate call failed"
444             );
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
449      * but performing a delegate call.
450      *
451      * _Available since v3.4._
452      */
453     function functionDelegateCall(
454         address target,
455         bytes memory data,
456         string memory errorMessage
457     ) internal returns (bytes memory) {
458         require(isContract(target), "Address: delegate call to non-contract");
459 
460         (bool success, bytes memory returndata) = target.delegatecall(data);
461         return verifyCallResult(success, returndata, errorMessage);
462     }
463 
464     /**
465      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
466      * revert reason using the provided one.
467      *
468      * _Available since v4.3._
469      */
470     function verifyCallResult(
471         bool success,
472         bytes memory returndata,
473         string memory errorMessage
474     ) internal pure returns (bytes memory) {
475         if (success) {
476             return returndata;
477         } else {
478             // Look for revert reason and bubble it up if present
479             if (returndata.length > 0) {
480                 // The easiest way to bubble the revert reason is using memory via assembly
481 
482                 assembly {
483                     let returndata_size := mload(returndata)
484                     revert(add(32, returndata), returndata_size)
485                 }
486             } else {
487                 revert(errorMessage);
488             }
489         }
490     }
491 }
492 
493 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
494 
495 /**
496  * @dev Provides information about the current execution context, including the
497  * sender of the transaction and its data. While these are generally available
498  * via msg.sender and msg.data, they should not be accessed in such a direct
499  * manner, since when dealing with meta-transactions the account sending and
500  * paying for execution may not be the actual sender (as far as an application
501  * is concerned).
502  *
503  * This contract is only required for intermediate, library-like contracts.
504  */
505 abstract contract Context {
506     function _msgSender() internal view virtual returns (address) {
507         return msg.sender;
508     }
509 
510     function _msgData() internal view virtual returns (bytes calldata) {
511         return msg.data;
512     }
513 }
514 
515 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.2
516 
517 /**
518  * @dev String operations.
519  */
520 library Strings {
521     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
522 
523     /**
524      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
525      */
526     function toString(uint256 value) internal pure returns (string memory) {
527         // Inspired by OraclizeAPI's implementation - MIT licence
528         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
529 
530         if (value == 0) {
531             return "0";
532         }
533         uint256 temp = value;
534         uint256 digits;
535         while (temp != 0) {
536             digits++;
537             temp /= 10;
538         }
539         bytes memory buffer = new bytes(digits);
540         while (value != 0) {
541             digits -= 1;
542             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
543             value /= 10;
544         }
545         return string(buffer);
546     }
547 
548     /**
549      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
550      */
551     function toHexString(uint256 value) internal pure returns (string memory) {
552         if (value == 0) {
553             return "0x00";
554         }
555         uint256 temp = value;
556         uint256 length = 0;
557         while (temp != 0) {
558             length++;
559             temp >>= 8;
560         }
561         return toHexString(value, length);
562     }
563 
564     /**
565      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
566      */
567     function toHexString(uint256 value, uint256 length)
568         internal
569         pure
570         returns (string memory)
571     {
572         bytes memory buffer = new bytes(2 * length + 2);
573         buffer[0] = "0";
574         buffer[1] = "x";
575         for (uint256 i = 2 * length + 1; i > 1; --i) {
576             buffer[i] = _HEX_SYMBOLS[value & 0xf];
577             value >>= 4;
578         }
579         require(value == 0, "Strings: hex length insufficient");
580         return string(buffer);
581     }
582 }
583 
584 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
585 
586 /**
587  * @dev Implementation of the {IERC165} interface.
588  *
589  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
590  * for the additional interface id that will be supported. For example:
591  *
592  * ```solidity
593  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
594  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
595  * }
596  * ```
597  *
598  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
599  */
600 abstract contract ERC165 is IERC165 {
601     /**
602      * @dev See {IERC165-supportsInterface}.
603      */
604     function supportsInterface(bytes4 interfaceId)
605         public
606         view
607         virtual
608         override
609         returns (bool)
610     {
611         return interfaceId == type(IERC165).interfaceId;
612     }
613 }
614 
615 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.2
616 
617 /**
618  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
619  * the Metadata extension, but not including the Enumerable extension, which is available separately as
620  * {ERC721Enumerable}.
621  */
622 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
623     using Address for address;
624     using Strings for uint256;
625 
626     // Token name
627     string private _name;
628 
629     // Token symbol
630     string private _symbol;
631 
632     // Mapping from token ID to owner address
633     mapping(uint256 => address) private _owners;
634 
635     // Mapping owner address to token count
636     mapping(address => uint256) private _balances;
637 
638     // Mapping from token ID to approved address
639     mapping(uint256 => address) private _tokenApprovals;
640 
641     // Mapping from owner to operator approvals
642     mapping(address => mapping(address => bool)) private _operatorApprovals;
643 
644     /**
645      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
646      */
647     constructor(string memory name_, string memory symbol_) {
648         _name = name_;
649         _symbol = symbol_;
650     }
651 
652     /**
653      * @dev See {IERC165-supportsInterface}.
654      */
655     function supportsInterface(bytes4 interfaceId)
656         public
657         view
658         virtual
659         override(ERC165, IERC165)
660         returns (bool)
661     {
662         return
663             interfaceId == type(IERC721).interfaceId ||
664             interfaceId == type(IERC721Metadata).interfaceId ||
665             super.supportsInterface(interfaceId);
666     }
667 
668     /**
669      * @dev See {IERC721-balanceOf}.
670      */
671     function balanceOf(address owner)
672         public
673         view
674         virtual
675         override
676         returns (uint256)
677     {
678         require(
679             owner != address(0),
680             "ERC721: balance query for the zero address"
681         );
682         return _balances[owner];
683     }
684 
685     /**
686      * @dev See {IERC721-ownerOf}.
687      */
688     function ownerOf(uint256 tokenId)
689         public
690         view
691         virtual
692         override
693         returns (address)
694     {
695         address owner = _owners[tokenId];
696         require(
697             owner != address(0),
698             "ERC721: owner query for nonexistent token"
699         );
700         return owner;
701     }
702 
703     /**
704      * @dev See {IERC721Metadata-name}.
705      */
706     function name() public view virtual override returns (string memory) {
707         return _name;
708     }
709 
710     /**
711      * @dev See {IERC721Metadata-symbol}.
712      */
713     function symbol() public view virtual override returns (string memory) {
714         return _symbol;
715     }
716 
717     /**
718      * @dev See {IERC721Metadata-tokenURI}.
719      */
720     function tokenURI(uint256 tokenId)
721         public
722         view
723         virtual
724         override
725         returns (string memory)
726     {
727         require(
728             _exists(tokenId),
729             "ERC721Metadata: URI query for nonexistent token"
730         );
731 
732         string memory baseURI = _baseURI();
733         return
734             bytes(baseURI).length > 0
735                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
736                 : "";
737     }
738 
739     /**
740      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
741      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
742      * by default, can be overriden in child contracts.
743      */
744     function _baseURI() internal view virtual returns (string memory) {
745         return "";
746     }
747 
748     /**
749      * @dev See {IERC721-approve}.
750      */
751     function approve(address to, uint256 tokenId) public virtual override {
752         address owner = ERC721.ownerOf(tokenId);
753         require(to != owner, "ERC721: approval to current owner");
754 
755         require(
756             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
757             "ERC721: approve caller is not owner nor approved for all"
758         );
759 
760         _approve(to, tokenId);
761     }
762 
763     /**
764      * @dev See {IERC721-getApproved}.
765      */
766     function getApproved(uint256 tokenId)
767         public
768         view
769         virtual
770         override
771         returns (address)
772     {
773         require(
774             _exists(tokenId),
775             "ERC721: approved query for nonexistent token"
776         );
777 
778         return _tokenApprovals[tokenId];
779     }
780 
781     /**
782      * @dev See {IERC721-setApprovalForAll}.
783      */
784     function setApprovalForAll(address operator, bool approved)
785         public
786         virtual
787         override
788     {
789         require(operator != _msgSender(), "ERC721: approve to caller");
790 
791         _operatorApprovals[_msgSender()][operator] = approved;
792         emit ApprovalForAll(_msgSender(), operator, approved);
793     }
794 
795     /**
796      * @dev See {IERC721-isApprovedForAll}.
797      */
798     function isApprovedForAll(address owner, address operator)
799         public
800         view
801         virtual
802         override
803         returns (bool)
804     {
805         return _operatorApprovals[owner][operator];
806     }
807 
808     /**
809      * @dev See {IERC721-transferFrom}.
810      */
811     function transferFrom(
812         address from,
813         address to,
814         uint256 tokenId
815     ) public virtual override {
816         //solhint-disable-next-line max-line-length
817         require(
818             _isApprovedOrOwner(_msgSender(), tokenId),
819             "ERC721: transfer caller is not owner nor approved"
820         );
821 
822         _transfer(from, to, tokenId);
823     }
824 
825     /**
826      * @dev See {IERC721-safeTransferFrom}.
827      */
828     function safeTransferFrom(
829         address from,
830         address to,
831         uint256 tokenId
832     ) public virtual override {
833         safeTransferFrom(from, to, tokenId, "");
834     }
835 
836     /**
837      * @dev See {IERC721-safeTransferFrom}.
838      */
839     function safeTransferFrom(
840         address from,
841         address to,
842         uint256 tokenId,
843         bytes memory _data
844     ) public virtual override {
845         require(
846             _isApprovedOrOwner(_msgSender(), tokenId),
847             "ERC721: transfer caller is not owner nor approved"
848         );
849         _safeTransfer(from, to, tokenId, _data);
850     }
851 
852     /**
853      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
854      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
855      *
856      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
857      *
858      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
859      * implement alternative mechanisms to perform token transfer, such as signature-based.
860      *
861      * Requirements:
862      *
863      * - `from` cannot be the zero address.
864      * - `to` cannot be the zero address.
865      * - `tokenId` token must exist and be owned by `from`.
866      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
867      *
868      * Emits a {Transfer} event.
869      */
870     function _safeTransfer(
871         address from,
872         address to,
873         uint256 tokenId,
874         bytes memory _data
875     ) internal virtual {
876         _transfer(from, to, tokenId);
877         require(
878             _checkOnERC721Received(from, to, tokenId, _data),
879             "ERC721: transfer to non ERC721Receiver implementer"
880         );
881     }
882 
883     /**
884      * @dev Returns whether `tokenId` exists.
885      *
886      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
887      *
888      * Tokens start existing when they are minted (`_mint`),
889      * and stop existing when they are burned (`_burn`).
890      */
891     function _exists(uint256 tokenId) internal view virtual returns (bool) {
892         return _owners[tokenId] != address(0);
893     }
894 
895     /**
896      * @dev Returns whether `spender` is allowed to manage `tokenId`.
897      *
898      * Requirements:
899      *
900      * - `tokenId` must exist.
901      */
902     function _isApprovedOrOwner(address spender, uint256 tokenId)
903         internal
904         view
905         virtual
906         returns (bool)
907     {
908         require(
909             _exists(tokenId),
910             "ERC721: operator query for nonexistent token"
911         );
912         address owner = ERC721.ownerOf(tokenId);
913         return (spender == owner ||
914             getApproved(tokenId) == spender ||
915             isApprovedForAll(owner, spender));
916     }
917 
918     /**
919      * @dev Safely mints `tokenId` and transfers it to `to`.
920      *
921      * Requirements:
922      *
923      * - `tokenId` must not exist.
924      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
925      *
926      * Emits a {Transfer} event.
927      */
928     function _safeMint(address to, uint256 tokenId) internal virtual {
929         _safeMint(to, tokenId, "");
930     }
931 
932     /**
933      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
934      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
935      */
936     function _safeMint(
937         address to,
938         uint256 tokenId,
939         bytes memory _data
940     ) internal virtual {
941         _mint(to, tokenId);
942         require(
943             _checkOnERC721Received(address(0), to, tokenId, _data),
944             "ERC721: transfer to non ERC721Receiver implementer"
945         );
946     }
947 
948     /**
949      * @dev Mints `tokenId` and transfers it to `to`.
950      *
951      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
952      *
953      * Requirements:
954      *
955      * - `tokenId` must not exist.
956      * - `to` cannot be the zero address.
957      *
958      * Emits a {Transfer} event.
959      */
960     function _mint(address to, uint256 tokenId) internal virtual {
961         require(to != address(0), "ERC721: mint to the zero address");
962         require(!_exists(tokenId), "ERC721: token already minted");
963 
964         _beforeTokenTransfer(address(0), to, tokenId);
965 
966         _balances[to] += 1;
967         _owners[tokenId] = to;
968 
969         emit Transfer(address(0), to, tokenId);
970     }
971 
972     /**
973      * @dev Destroys `tokenId`.
974      * The approval is cleared when the token is burned.
975      *
976      * Requirements:
977      *
978      * - `tokenId` must exist.
979      *
980      * Emits a {Transfer} event.
981      */
982     function _burn(uint256 tokenId) internal virtual {
983         address owner = ERC721.ownerOf(tokenId);
984 
985         _beforeTokenTransfer(owner, address(0), tokenId);
986 
987         // Clear approvals
988         _approve(address(0), tokenId);
989 
990         _balances[owner] -= 1;
991         delete _owners[tokenId];
992 
993         emit Transfer(owner, address(0), tokenId);
994     }
995 
996     /**
997      * @dev Transfers `tokenId` from `from` to `to`.
998      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
999      *
1000      * Requirements:
1001      *
1002      * - `to` cannot be the zero address.
1003      * - `tokenId` token must be owned by `from`.
1004      *
1005      * Emits a {Transfer} event.
1006      */
1007     function _transfer(
1008         address from,
1009         address to,
1010         uint256 tokenId
1011     ) internal virtual {
1012         require(
1013             ERC721.ownerOf(tokenId) == from,
1014             "ERC721: transfer of token that is not own"
1015         );
1016         require(to != address(0), "ERC721: transfer to the zero address");
1017 
1018         _beforeTokenTransfer(from, to, tokenId);
1019 
1020         // Clear approvals from the previous owner
1021         _approve(address(0), tokenId);
1022 
1023         _balances[from] -= 1;
1024         _balances[to] += 1;
1025         _owners[tokenId] = to;
1026 
1027         emit Transfer(from, to, tokenId);
1028     }
1029 
1030     /**
1031      * @dev Approve `to` to operate on `tokenId`
1032      *
1033      * Emits a {Approval} event.
1034      */
1035     function _approve(address to, uint256 tokenId) internal virtual {
1036         _tokenApprovals[tokenId] = to;
1037         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1038     }
1039 
1040     /**
1041      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1042      * The call is not executed if the target address is not a contract.
1043      *
1044      * @param from address representing the previous owner of the given token ID
1045      * @param to target address that will receive the tokens
1046      * @param tokenId uint256 ID of the token to be transferred
1047      * @param _data bytes optional data to send along with the call
1048      * @return bool whether the call correctly returned the expected magic value
1049      */
1050     function _checkOnERC721Received(
1051         address from,
1052         address to,
1053         uint256 tokenId,
1054         bytes memory _data
1055     ) private returns (bool) {
1056         if (to.isContract()) {
1057             try
1058                 IERC721Receiver(to).onERC721Received(
1059                     _msgSender(),
1060                     from,
1061                     tokenId,
1062                     _data
1063                 )
1064             returns (bytes4 retval) {
1065                 return retval == IERC721Receiver.onERC721Received.selector;
1066             } catch (bytes memory reason) {
1067                 if (reason.length == 0) {
1068                     revert(
1069                         "ERC721: transfer to non ERC721Receiver implementer"
1070                     );
1071                 } else {
1072                     assembly {
1073                         revert(add(32, reason), mload(reason))
1074                     }
1075                 }
1076             }
1077         } else {
1078             return true;
1079         }
1080     }
1081 
1082     /**
1083      * @dev Hook that is called before any token transfer. This includes minting
1084      * and burning.
1085      *
1086      * Calling conditions:
1087      *
1088      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1089      * transferred to `to`.
1090      * - When `from` is zero, `tokenId` will be minted for `to`.
1091      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1092      * - `from` and `to` are never both zero.
1093      *
1094      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1095      */
1096     function _beforeTokenTransfer(
1097         address from,
1098         address to,
1099         uint256 tokenId
1100     ) internal virtual {}
1101 }
1102 
1103 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
1104 
1105 /**
1106  * @dev Contract module which provides a basic access control mechanism, where
1107  * there is an account (an owner) that can be granted exclusive access to
1108  * specific functions.
1109  *
1110  * By default, the owner account will be the one that deploys the contract. This
1111  * can later be changed with {transferOwnership}.
1112  *
1113  * This module is used through inheritance. It will make available the modifier
1114  * `onlyOwner`, which can be applied to your functions to restrict their use to
1115  * the owner.
1116  */
1117 abstract contract Ownable is Context {
1118     address private _owner;
1119 
1120     event OwnershipTransferred(
1121         address indexed previousOwner,
1122         address indexed newOwner
1123     );
1124 
1125     /**
1126      * @dev Initializes the contract setting the deployer as the initial owner.
1127      */
1128     constructor() {
1129         _setOwner(_msgSender());
1130     }
1131 
1132     /**
1133      * @dev Returns the address of the current owner.
1134      */
1135     function owner() public view virtual returns (address) {
1136         return _owner;
1137     }
1138 
1139     /**
1140      * @dev Throws if called by any account other than the owner.
1141      */
1142     modifier onlyOwner() {
1143         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1144         _;
1145     }
1146 
1147     /**
1148      * @dev Leaves the contract without owner. It will not be possible to call
1149      * `onlyOwner` functions anymore. Can only be called by the current owner.
1150      *
1151      * NOTE: Renouncing ownership will leave the contract without an owner,
1152      * thereby removing any functionality that is only available to the owner.
1153      */
1154     function renounceOwnership() public virtual onlyOwner {
1155         _setOwner(address(0));
1156     }
1157 
1158     /**
1159      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1160      * Can only be called by the current owner.
1161      */
1162     function transferOwnership(address newOwner) public virtual onlyOwner {
1163         require(
1164             newOwner != address(0),
1165             "Ownable: new owner is the zero address"
1166         );
1167         _setOwner(newOwner);
1168     }
1169 
1170     function _setOwner(address newOwner) private {
1171         address oldOwner = _owner;
1172         _owner = newOwner;
1173         emit OwnershipTransferred(oldOwner, newOwner);
1174     }
1175 }
1176 
1177 
1178 // File contracts/Billionaire.sol
1179 
1180 contract LilMutant is ERC721, Ownable {
1181     uint256 public constant PRICE = 0.025 * 1e18;
1182     uint256 public constant MAX_SUPPLY = 1333;
1183 
1184 
1185     bool public live;
1186     uint256 public minted;
1187     mapping(address => uint8) public earlyAccess;
1188     string public baseURI;
1189 
1190     constructor(
1191         string memory name_,
1192         string memory symbol_,
1193         string memory baseURI_
1194     ) ERC721(name_, symbol_) {
1195         baseURI = baseURI_;
1196     }
1197 
1198     function totalSupply() public view virtual returns (uint256) {
1199         return minted;
1200     }
1201 
1202     function mint(uint8 amount) public payable {
1203         require(amount > 0, "Amount must be more than 0");
1204         require(amount <= 10, "Amount must be 10 or less");
1205         require(msg.value == PRICE * amount, "Ether value sent is not correct");
1206         require(
1207             minted + amount <= MAX_SUPPLY,
1208             "Sold out!"
1209         );
1210 
1211         for (uint256 i = 0; i < amount; i++) {
1212             _safeMint(msg.sender, ++minted);
1213         }
1214     }
1215 
1216     function freemint(uint8 amount) public payable {
1217         require(amount > 0, "Amount must be more than 0");
1218         require(amount <= 5, "Amount must be 5 or less");
1219         require(
1220             minted + amount <= 200,
1221             "Sold out!"
1222         );
1223 
1224         for (uint256 i = 0; i < amount; i++) {
1225             _safeMint(msg.sender, ++minted);
1226         }
1227     }
1228 
1229     function withdraw(address payable recipient) public onlyOwner {
1230         require(address(this).balance > 0, "No contract balance");
1231         recipient.transfer(address(this).balance);
1232     }
1233 
1234     function setBaseURI(string memory baseURI_) public onlyOwner {
1235         baseURI = baseURI_;
1236     }
1237 
1238     function _baseURI() internal view virtual override returns (string memory) {
1239         return baseURI;
1240     }
1241 }