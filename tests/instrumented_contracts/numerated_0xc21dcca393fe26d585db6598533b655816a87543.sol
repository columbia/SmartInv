1 // SPDX-License-Identifier: MIT
2 
3 // File: node_modules\openzeppelin-solidity\contracts\utils\introspection\IERC165.sol
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\IERC721.sol
31 
32 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Required interface of an ERC721 compliant contract.
38  */
39 interface IERC721 is IERC165 {
40     /**
41      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
42      */
43     event Transfer(
44         address indexed from,
45         address indexed to,
46         uint256 indexed tokenId
47     );
48 
49     /**
50      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
51      */
52     event Approval(
53         address indexed owner,
54         address indexed approved,
55         uint256 indexed tokenId
56     );
57 
58     /**
59      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
60      */
61     event ApprovalForAll(
62         address indexed owner,
63         address indexed operator,
64         bool approved
65     );
66 
67     /**
68      * @dev Returns the number of tokens in ``owner``'s account.
69      */
70     function balanceOf(address owner) external view returns (uint256 balance);
71 
72     /**
73      * @dev Returns the owner of the `tokenId` token.
74      *
75      * Requirements:
76      *
77      * - `tokenId` must exist.
78      */
79     function ownerOf(uint256 tokenId) external view returns (address owner);
80 
81     /**
82      * @dev Safely transfers `tokenId` token from `from` to `to`.
83      *
84      * Requirements:
85      *
86      * - `from` cannot be the zero address.
87      * - `to` cannot be the zero address.
88      * - `tokenId` token must exist and be owned by `from`.
89      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
90      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
91      *
92      * Emits a {Transfer} event.
93      */
94     function safeTransferFrom(
95         address from,
96         address to,
97         uint256 tokenId,
98         bytes calldata data
99     ) external;
100 
101     /**
102      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
103      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
104      *
105      * Requirements:
106      *
107      * - `from` cannot be the zero address.
108      * - `to` cannot be the zero address.
109      * - `tokenId` token must exist and be owned by `from`.
110      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
111      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
112      *
113      * Emits a {Transfer} event.
114      */
115     function safeTransferFrom(
116         address from,
117         address to,
118         uint256 tokenId
119     ) external;
120 
121     /**
122      * @dev Transfers `tokenId` token from `from` to `to`.
123      *
124      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
125      *
126      * Requirements:
127      *
128      * - `from` cannot be the zero address.
129      * - `to` cannot be the zero address.
130      * - `tokenId` token must be owned by `from`.
131      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
132      *
133      * Emits a {Transfer} event.
134      */
135     function transferFrom(
136         address from,
137         address to,
138         uint256 tokenId
139     ) external;
140 
141     /**
142      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
143      * The approval is cleared when the token is transferred.
144      *
145      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
146      *
147      * Requirements:
148      *
149      * - The caller must own the token or be an approved operator.
150      * - `tokenId` must exist.
151      *
152      * Emits an {Approval} event.
153      */
154     function approve(address to, uint256 tokenId) external;
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
169      * @dev Returns the account approved for `tokenId` token.
170      *
171      * Requirements:
172      *
173      * - `tokenId` must exist.
174      */
175     function getApproved(uint256 tokenId)
176         external
177         view
178         returns (address operator);
179 
180     /**
181      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
182      *
183      * See {setApprovalForAll}
184      */
185     function isApprovedForAll(address owner, address operator)
186         external
187         view
188         returns (bool);
189 }
190 
191 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\IERC721Receiver.sol
192 
193 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
194 
195 pragma solidity ^0.8.0;
196 
197 /**
198  * @title ERC721 token receiver interface
199  * @dev Interface for any contract that wants to support safeTransfers
200  * from ERC721 asset contracts.
201  */
202 interface IERC721Receiver {
203     /**
204      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
205      * by `operator` from `from`, this function is called.
206      *
207      * It must return its Solidity selector to confirm the token transfer.
208      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
209      *
210      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
211      */
212     function onERC721Received(
213         address operator,
214         address from,
215         uint256 tokenId,
216         bytes calldata data
217     ) external returns (bytes4);
218 }
219 
220 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\extensions\IERC721Metadata.sol
221 
222 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
223 
224 pragma solidity ^0.8.0;
225 
226 /**
227  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
228  * @dev See https://eips.ethereum.org/EIPS/eip-721
229  */
230 interface IERC721Metadata is IERC721 {
231     /**
232      * @dev Returns the token collection name.
233      */
234     function name() external view returns (string memory);
235 
236     /**
237      * @dev Returns the token collection symbol.
238      */
239     function symbol() external view returns (string memory);
240 
241     /**
242      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
243      */
244     function tokenURI(uint256 tokenId) external view returns (string memory);
245 }
246 
247 // File: node_modules\openzeppelin-solidity\contracts\utils\Address.sol
248 
249 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
250 
251 pragma solidity ^0.8.1;
252 
253 /**
254  * @dev Collection of functions related to the address type
255  */
256 library Address {
257     /**
258      * @dev Returns true if `account` is a contract.
259      *
260      * [IMPORTANT]
261      * ====
262      * It is unsafe to assume that an address for which this function returns
263      * false is an externally-owned account (EOA) and not a contract.
264      *
265      * Among others, `isContract` will return false for the following
266      * types of addresses:
267      *
268      *  - an externally-owned account
269      *  - a contract in construction
270      *  - an address where a contract will be created
271      *  - an address where a contract lived, but was destroyed
272      * ====
273      *
274      * [IMPORTANT]
275      * ====
276      * You shouldn't rely on `isContract` to protect against flash loan attacks!
277      *
278      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
279      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
280      * constructor.
281      * ====
282      */
283     function isContract(address account) internal view returns (bool) {
284         // This method relies on extcodesize/address.code.length, which returns 0
285         // for contracts in construction, since the code is only stored at the end
286         // of the constructor execution.
287 
288         return account.code.length > 0;
289     }
290 
291     /**
292      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
293      * `recipient`, forwarding all available gas and reverting on errors.
294      *
295      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
296      * of certain opcodes, possibly making contracts go over the 2300 gas limit
297      * imposed by `transfer`, making them unable to receive funds via
298      * `transfer`. {sendValue} removes this limitation.
299      *
300      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
301      *
302      * IMPORTANT: because control is transferred to `recipient`, care must be
303      * taken to not create reentrancy vulnerabilities. Consider using
304      * {ReentrancyGuard} or the
305      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
306      */
307     function sendValue(address payable recipient, uint256 amount) internal {
308         require(
309             address(this).balance >= amount,
310             "Address: insufficient balance"
311         );
312 
313         (bool success, ) = recipient.call{value: amount}("");
314         require(
315             success,
316             "Address: unable to send value, recipient may have reverted"
317         );
318     }
319 
320     /**
321      * @dev Performs a Solidity function call using a low level `call`. A
322      * plain `call` is an unsafe replacement for a function call: use this
323      * function instead.
324      *
325      * If `target` reverts with a revert reason, it is bubbled up by this
326      * function (like regular Solidity function calls).
327      *
328      * Returns the raw returned data. To convert to the expected return value,
329      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
330      *
331      * Requirements:
332      *
333      * - `target` must be a contract.
334      * - calling `target` with `data` must not revert.
335      *
336      * _Available since v3.1._
337      */
338     function functionCall(address target, bytes memory data)
339         internal
340         returns (bytes memory)
341     {
342         return functionCall(target, data, "Address: low-level call failed");
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
347      * `errorMessage` as a fallback revert reason when `target` reverts.
348      *
349      * _Available since v3.1._
350      */
351     function functionCall(
352         address target,
353         bytes memory data,
354         string memory errorMessage
355     ) internal returns (bytes memory) {
356         return functionCallWithValue(target, data, 0, errorMessage);
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
361      * but also transferring `value` wei to `target`.
362      *
363      * Requirements:
364      *
365      * - the calling contract must have an ETH balance of at least `value`.
366      * - the called Solidity function must be `payable`.
367      *
368      * _Available since v3.1._
369      */
370     function functionCallWithValue(
371         address target,
372         bytes memory data,
373         uint256 value
374     ) internal returns (bytes memory) {
375         return
376             functionCallWithValue(
377                 target,
378                 data,
379                 value,
380                 "Address: low-level call with value failed"
381             );
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
386      * with `errorMessage` as a fallback revert reason when `target` reverts.
387      *
388      * _Available since v3.1._
389      */
390     function functionCallWithValue(
391         address target,
392         bytes memory data,
393         uint256 value,
394         string memory errorMessage
395     ) internal returns (bytes memory) {
396         require(
397             address(this).balance >= value,
398             "Address: insufficient balance for call"
399         );
400         require(isContract(target), "Address: call to non-contract");
401 
402         (bool success, bytes memory returndata) = target.call{value: value}(
403             data
404         );
405         return verifyCallResult(success, returndata, errorMessage);
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
410      * but performing a static call.
411      *
412      * _Available since v3.3._
413      */
414     function functionStaticCall(address target, bytes memory data)
415         internal
416         view
417         returns (bytes memory)
418     {
419         return
420             functionStaticCall(
421                 target,
422                 data,
423                 "Address: low-level static call failed"
424             );
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
429      * but performing a static call.
430      *
431      * _Available since v3.3._
432      */
433     function functionStaticCall(
434         address target,
435         bytes memory data,
436         string memory errorMessage
437     ) internal view returns (bytes memory) {
438         require(isContract(target), "Address: static call to non-contract");
439 
440         (bool success, bytes memory returndata) = target.staticcall(data);
441         return verifyCallResult(success, returndata, errorMessage);
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
446      * but performing a delegate call.
447      *
448      * _Available since v3.4._
449      */
450     function functionDelegateCall(address target, bytes memory data)
451         internal
452         returns (bytes memory)
453     {
454         return
455             functionDelegateCall(
456                 target,
457                 data,
458                 "Address: low-level delegate call failed"
459             );
460     }
461 
462     /**
463      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
464      * but performing a delegate call.
465      *
466      * _Available since v3.4._
467      */
468     function functionDelegateCall(
469         address target,
470         bytes memory data,
471         string memory errorMessage
472     ) internal returns (bytes memory) {
473         require(isContract(target), "Address: delegate call to non-contract");
474 
475         (bool success, bytes memory returndata) = target.delegatecall(data);
476         return verifyCallResult(success, returndata, errorMessage);
477     }
478 
479     /**
480      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
481      * revert reason using the provided one.
482      *
483      * _Available since v4.3._
484      */
485     function verifyCallResult(
486         bool success,
487         bytes memory returndata,
488         string memory errorMessage
489     ) internal pure returns (bytes memory) {
490         if (success) {
491             return returndata;
492         } else {
493             // Look for revert reason and bubble it up if present
494             if (returndata.length > 0) {
495                 // The easiest way to bubble the revert reason is using memory via assembly
496 
497                 assembly {
498                     let returndata_size := mload(returndata)
499                     revert(add(32, returndata), returndata_size)
500                 }
501             } else {
502                 revert(errorMessage);
503             }
504         }
505     }
506 }
507 
508 // File: node_modules\openzeppelin-solidity\contracts\utils\Context.sol
509 
510 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
511 
512 pragma solidity ^0.8.0;
513 
514 /**
515  * @dev Provides information about the current execution context, including the
516  * sender of the transaction and its data. While these are generally available
517  * via msg.sender and msg.data, they should not be accessed in such a direct
518  * manner, since when dealing with meta-transactions the account sending and
519  * paying for execution may not be the actual sender (as far as an application
520  * is concerned).
521  *
522  * This contract is only required for intermediate, library-like contracts.
523  */
524 abstract contract Context {
525     function _msgSender() internal view virtual returns (address) {
526         return msg.sender;
527     }
528 
529     function _msgData() internal view virtual returns (bytes calldata) {
530         return msg.data;
531     }
532 }
533 
534 // File: node_modules\openzeppelin-solidity\contracts\utils\Strings.sol
535 
536 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
537 
538 pragma solidity ^0.8.0;
539 
540 /**
541  * @dev String operations.
542  */
543 library Strings {
544     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
545 
546     /**
547      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
548      */
549     function toString(uint256 value) internal pure returns (string memory) {
550         // Inspired by OraclizeAPI's implementation - MIT licence
551         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
552 
553         if (value == 0) {
554             return "0";
555         }
556         uint256 temp = value;
557         uint256 digits;
558         while (temp != 0) {
559             digits++;
560             temp /= 10;
561         }
562         bytes memory buffer = new bytes(digits);
563         while (value != 0) {
564             digits -= 1;
565             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
566             value /= 10;
567         }
568         return string(buffer);
569     }
570 
571     /**
572      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
573      */
574     function toHexString(uint256 value) internal pure returns (string memory) {
575         if (value == 0) {
576             return "0x00";
577         }
578         uint256 temp = value;
579         uint256 length = 0;
580         while (temp != 0) {
581             length++;
582             temp >>= 8;
583         }
584         return toHexString(value, length);
585     }
586 
587     /**
588      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
589      */
590     function toHexString(uint256 value, uint256 length)
591         internal
592         pure
593         returns (string memory)
594     {
595         bytes memory buffer = new bytes(2 * length + 2);
596         buffer[0] = "0";
597         buffer[1] = "x";
598         for (uint256 i = 2 * length + 1; i > 1; --i) {
599             buffer[i] = _HEX_SYMBOLS[value & 0xf];
600             value >>= 4;
601         }
602         require(value == 0, "Strings: hex length insufficient");
603         return string(buffer);
604     }
605 }
606 
607 // File: node_modules\openzeppelin-solidity\contracts\utils\introspection\ERC165.sol
608 
609 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
610 
611 pragma solidity ^0.8.0;
612 
613 /**
614  * @dev Implementation of the {IERC165} interface.
615  *
616  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
617  * for the additional interface id that will be supported. For example:
618  *
619  * ```solidity
620  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
621  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
622  * }
623  * ```
624  *
625  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
626  */
627 abstract contract ERC165 is IERC165 {
628     /**
629      * @dev See {IERC165-supportsInterface}.
630      */
631     function supportsInterface(bytes4 interfaceId)
632         public
633         view
634         virtual
635         override
636         returns (bool)
637     {
638         return interfaceId == type(IERC165).interfaceId;
639     }
640 }
641 
642 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\ERC721.sol
643 
644 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
645 
646 pragma solidity ^0.8.0;
647 
648 /**
649  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
650  * the Metadata extension, but not including the Enumerable extension, which is available separately as
651  * {ERC721Enumerable}.
652  */
653 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
654     using Address for address;
655     using Strings for uint256;
656 
657     // Token name
658     string private _name;
659 
660     // Token symbol
661     string private _symbol;
662 
663     // Mapping from token ID to owner address
664     mapping(uint256 => address) private _owners;
665 
666     // Mapping owner address to token count
667     mapping(address => uint256) private _balances;
668 
669     // Mapping from token ID to approved address
670     mapping(uint256 => address) private _tokenApprovals;
671 
672     // Mapping from owner to operator approvals
673     mapping(address => mapping(address => bool)) private _operatorApprovals;
674 
675     /**
676      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
677      */
678     constructor(string memory name_, string memory symbol_) {
679         _name = name_;
680         _symbol = symbol_;
681     }
682 
683     /**
684      * @dev See {IERC165-supportsInterface}.
685      */
686     function supportsInterface(bytes4 interfaceId)
687         public
688         view
689         virtual
690         override(ERC165, IERC165)
691         returns (bool)
692     {
693         return
694             interfaceId == type(IERC721).interfaceId ||
695             interfaceId == type(IERC721Metadata).interfaceId ||
696             super.supportsInterface(interfaceId);
697     }
698 
699     /**
700      * @dev See {IERC721-balanceOf}.
701      */
702     function balanceOf(address owner)
703         public
704         view
705         virtual
706         override
707         returns (uint256)
708     {
709         require(
710             owner != address(0),
711             "ERC721: balance query for the zero address"
712         );
713         return _balances[owner];
714     }
715 
716     /**
717      * @dev See {IERC721-ownerOf}.
718      */
719     function ownerOf(uint256 tokenId)
720         public
721         view
722         virtual
723         override
724         returns (address)
725     {
726         address owner = _owners[tokenId];
727         require(
728             owner != address(0),
729             "ERC721: owner query for nonexistent token"
730         );
731         return owner;
732     }
733 
734     /**
735      * @dev See {IERC721Metadata-name}.
736      */
737     function name() public view virtual override returns (string memory) {
738         return _name;
739     }
740 
741     /**
742      * @dev See {IERC721Metadata-symbol}.
743      */
744     function symbol() public view virtual override returns (string memory) {
745         return _symbol;
746     }
747 
748     /**
749      * @dev See {IERC721Metadata-tokenURI}.
750      */
751     function tokenURI(uint256 tokenId)
752         public
753         view
754         virtual
755         override
756         returns (string memory)
757     {
758         require(
759             _exists(tokenId),
760             "ERC721Metadata: URI query for nonexistent token"
761         );
762 
763         string memory baseURI = _baseURI();
764         return
765             bytes(baseURI).length > 0
766                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
767                 : "";
768     }
769 
770     /**
771      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
772      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
773      * by default, can be overridden in child contracts.
774      */
775     function _baseURI() internal view virtual returns (string memory) {
776         return "";
777     }
778 
779     /**
780      * @dev See {IERC721-approve}.
781      */
782     function approve(address to, uint256 tokenId) public virtual override {
783         address owner = ERC721.ownerOf(tokenId);
784         require(to != owner, "ERC721: approval to current owner");
785 
786         require(
787             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
788             "ERC721: approve caller is not owner nor approved for all"
789         );
790 
791         _approve(to, tokenId);
792     }
793 
794     /**
795      * @dev See {IERC721-getApproved}.
796      */
797     function getApproved(uint256 tokenId)
798         public
799         view
800         virtual
801         override
802         returns (address)
803     {
804         require(
805             _exists(tokenId),
806             "ERC721: approved query for nonexistent token"
807         );
808 
809         return _tokenApprovals[tokenId];
810     }
811 
812     /**
813      * @dev See {IERC721-setApprovalForAll}.
814      */
815     function setApprovalForAll(address operator, bool approved)
816         public
817         virtual
818         override
819     {
820         _setApprovalForAll(_msgSender(), operator, approved);
821     }
822 
823     /**
824      * @dev See {IERC721-isApprovedForAll}.
825      */
826     function isApprovedForAll(address owner, address operator)
827         public
828         view
829         virtual
830         override
831         returns (bool)
832     {
833         return _operatorApprovals[owner][operator];
834     }
835 
836     /**
837      * @dev See {IERC721-transferFrom}.
838      */
839     function transferFrom(
840         address from,
841         address to,
842         uint256 tokenId
843     ) public virtual override {
844         //solhint-disable-next-line max-line-length
845         require(
846             _isApprovedOrOwner(_msgSender(), tokenId),
847             "ERC721: transfer caller is not owner nor approved"
848         );
849 
850         _transfer(from, to, tokenId);
851     }
852 
853     /**
854      * @dev See {IERC721-safeTransferFrom}.
855      */
856     function safeTransferFrom(
857         address from,
858         address to,
859         uint256 tokenId
860     ) public virtual override {
861         safeTransferFrom(from, to, tokenId, "");
862     }
863 
864     /**
865      * @dev See {IERC721-safeTransferFrom}.
866      */
867     function safeTransferFrom(
868         address from,
869         address to,
870         uint256 tokenId,
871         bytes memory _data
872     ) public virtual override {
873         require(
874             _isApprovedOrOwner(_msgSender(), tokenId),
875             "ERC721: transfer caller is not owner nor approved"
876         );
877         _safeTransfer(from, to, tokenId, _data);
878     }
879 
880     /**
881      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
882      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
883      *
884      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
885      *
886      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
887      * implement alternative mechanisms to perform token transfer, such as signature-based.
888      *
889      * Requirements:
890      *
891      * - `from` cannot be the zero address.
892      * - `to` cannot be the zero address.
893      * - `tokenId` token must exist and be owned by `from`.
894      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
895      *
896      * Emits a {Transfer} event.
897      */
898     function _safeTransfer(
899         address from,
900         address to,
901         uint256 tokenId,
902         bytes memory _data
903     ) internal virtual {
904         _transfer(from, to, tokenId);
905         require(
906             _checkOnERC721Received(from, to, tokenId, _data),
907             "ERC721: transfer to non ERC721Receiver implementer"
908         );
909     }
910 
911     /**
912      * @dev Returns whether `tokenId` exists.
913      *
914      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
915      *
916      * Tokens start existing when they are minted (`_mint`),
917      * and stop existing when they are burned (`_burn`).
918      */
919     function _exists(uint256 tokenId) internal view virtual returns (bool) {
920         return _owners[tokenId] != address(0);
921     }
922 
923     /**
924      * @dev Returns whether `spender` is allowed to manage `tokenId`.
925      *
926      * Requirements:
927      *
928      * - `tokenId` must exist.
929      */
930     function _isApprovedOrOwner(address spender, uint256 tokenId)
931         internal
932         view
933         virtual
934         returns (bool)
935     {
936         require(
937             _exists(tokenId),
938             "ERC721: operator query for nonexistent token"
939         );
940         address owner = ERC721.ownerOf(tokenId);
941         return (spender == owner ||
942             isApprovedForAll(owner, spender) ||
943             getApproved(tokenId) == spender);
944     }
945 
946     /**
947      * @dev Safely mints `tokenId` and transfers it to `to`.
948      *
949      * Requirements:
950      *
951      * - `tokenId` must not exist.
952      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
953      *
954      * Emits a {Transfer} event.
955      */
956     function _safeMint(address to, uint256 tokenId) internal virtual {
957         _safeMint(to, tokenId, "");
958     }
959 
960     /**
961      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
962      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
963      */
964     function _safeMint(
965         address to,
966         uint256 tokenId,
967         bytes memory _data
968     ) internal virtual {
969         _mint(to, tokenId);
970         require(
971             _checkOnERC721Received(address(0), to, tokenId, _data),
972             "ERC721: transfer to non ERC721Receiver implementer"
973         );
974     }
975 
976     /**
977      * @dev Mints `tokenId` and transfers it to `to`.
978      *
979      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
980      *
981      * Requirements:
982      *
983      * - `tokenId` must not exist.
984      * - `to` cannot be the zero address.
985      *
986      * Emits a {Transfer} event.
987      */
988     function _mint(address to, uint256 tokenId) internal virtual {
989         require(to != address(0), "ERC721: mint to the zero address");
990         require(!_exists(tokenId), "ERC721: token already minted");
991 
992         _beforeTokenTransfer(address(0), to, tokenId);
993 
994         _balances[to] += 1;
995         _owners[tokenId] = to;
996 
997         emit Transfer(address(0), to, tokenId);
998 
999         _afterTokenTransfer(address(0), to, tokenId);
1000     }
1001 
1002     /**
1003      * @dev Destroys `tokenId`.
1004      * The approval is cleared when the token is burned.
1005      *
1006      * Requirements:
1007      *
1008      * - `tokenId` must exist.
1009      *
1010      * Emits a {Transfer} event.
1011      */
1012     function _burn(uint256 tokenId) internal virtual {
1013         address owner = ERC721.ownerOf(tokenId);
1014 
1015         _beforeTokenTransfer(owner, address(0), tokenId);
1016 
1017         // Clear approvals
1018         _approve(address(0), tokenId);
1019 
1020         _balances[owner] -= 1;
1021         delete _owners[tokenId];
1022 
1023         emit Transfer(owner, address(0), tokenId);
1024 
1025         _afterTokenTransfer(owner, address(0), tokenId);
1026     }
1027 
1028     /**
1029      * @dev Transfers `tokenId` from `from` to `to`.
1030      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1031      *
1032      * Requirements:
1033      *
1034      * - `to` cannot be the zero address.
1035      * - `tokenId` token must be owned by `from`.
1036      *
1037      * Emits a {Transfer} event.
1038      */
1039     function _transfer(
1040         address from,
1041         address to,
1042         uint256 tokenId
1043     ) internal virtual {
1044         require(
1045             ERC721.ownerOf(tokenId) == from,
1046             "ERC721: transfer from incorrect owner"
1047         );
1048         require(to != address(0), "ERC721: transfer to the zero address");
1049 
1050         _beforeTokenTransfer(from, to, tokenId);
1051 
1052         // Clear approvals from the previous owner
1053         _approve(address(0), tokenId);
1054 
1055         _balances[from] -= 1;
1056         _balances[to] += 1;
1057         _owners[tokenId] = to;
1058 
1059         emit Transfer(from, to, tokenId);
1060 
1061         _afterTokenTransfer(from, to, tokenId);
1062     }
1063 
1064     /**
1065      * @dev Approve `to` to operate on `tokenId`
1066      *
1067      * Emits a {Approval} event.
1068      */
1069     function _approve(address to, uint256 tokenId) internal virtual {
1070         _tokenApprovals[tokenId] = to;
1071         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1072     }
1073 
1074     /**
1075      * @dev Approve `operator` to operate on all of `owner` tokens
1076      *
1077      * Emits a {ApprovalForAll} event.
1078      */
1079     function _setApprovalForAll(
1080         address owner,
1081         address operator,
1082         bool approved
1083     ) internal virtual {
1084         require(owner != operator, "ERC721: approve to caller");
1085         _operatorApprovals[owner][operator] = approved;
1086         emit ApprovalForAll(owner, operator, approved);
1087     }
1088 
1089     /**
1090      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1091      * The call is not executed if the target address is not a contract.
1092      *
1093      * @param from address representing the previous owner of the given token ID
1094      * @param to target address that will receive the tokens
1095      * @param tokenId uint256 ID of the token to be transferred
1096      * @param _data bytes optional data to send along with the call
1097      * @return bool whether the call correctly returned the expected magic value
1098      */
1099     function _checkOnERC721Received(
1100         address from,
1101         address to,
1102         uint256 tokenId,
1103         bytes memory _data
1104     ) private returns (bool) {
1105         if (to.isContract()) {
1106             try
1107                 IERC721Receiver(to).onERC721Received(
1108                     _msgSender(),
1109                     from,
1110                     tokenId,
1111                     _data
1112                 )
1113             returns (bytes4 retval) {
1114                 return retval == IERC721Receiver.onERC721Received.selector;
1115             } catch (bytes memory reason) {
1116                 if (reason.length == 0) {
1117                     revert(
1118                         "ERC721: transfer to non ERC721Receiver implementer"
1119                     );
1120                 } else {
1121                     assembly {
1122                         revert(add(32, reason), mload(reason))
1123                     }
1124                 }
1125             }
1126         } else {
1127             return true;
1128         }
1129     }
1130 
1131     /**
1132      * @dev Hook that is called before any token transfer. This includes minting
1133      * and burning.
1134      *
1135      * Calling conditions:
1136      *
1137      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1138      * transferred to `to`.
1139      * - When `from` is zero, `tokenId` will be minted for `to`.
1140      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1141      * - `from` and `to` are never both zero.
1142      *
1143      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1144      */
1145     function _beforeTokenTransfer(
1146         address from,
1147         address to,
1148         uint256 tokenId
1149     ) internal virtual {}
1150 
1151     /**
1152      * @dev Hook that is called after any transfer of tokens. This includes
1153      * minting and burning.
1154      *
1155      * Calling conditions:
1156      *
1157      * - when `from` and `to` are both non-zero.
1158      * - `from` and `to` are never both zero.
1159      *
1160      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1161      */
1162     function _afterTokenTransfer(
1163         address from,
1164         address to,
1165         uint256 tokenId
1166     ) internal virtual {}
1167 }
1168 
1169 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\extensions\IERC721Enumerable.sol
1170 
1171 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1172 
1173 pragma solidity ^0.8.0;
1174 
1175 /**
1176  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1177  * @dev See https://eips.ethereum.org/EIPS/eip-721
1178  */
1179 interface IERC721Enumerable is IERC721 {
1180     /**
1181      * @dev Returns the total amount of tokens stored by the contract.
1182      */
1183     function totalSupply() external view returns (uint256);
1184 
1185     /**
1186      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1187      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1188      */
1189     function tokenOfOwnerByIndex(address owner, uint256 index)
1190         external
1191         view
1192         returns (uint256);
1193 
1194     /**
1195      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1196      * Use along with {totalSupply} to enumerate all tokens.
1197      */
1198     function tokenByIndex(uint256 index) external view returns (uint256);
1199 }
1200 
1201 // File: openzeppelin-solidity\contracts\token\ERC721\extensions\ERC721Enumerable.sol
1202 
1203 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1204 
1205 pragma solidity ^0.8.0;
1206 
1207 /**
1208  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1209  * enumerability of all the token ids in the contract as well as all token ids owned by each
1210  * account.
1211  */
1212 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1213     // Mapping from owner to list of owned token IDs
1214     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1215 
1216     // Mapping from token ID to index of the owner tokens list
1217     mapping(uint256 => uint256) private _ownedTokensIndex;
1218 
1219     // Array with all token ids, used for enumeration
1220     uint256[] private _allTokens;
1221 
1222     // Mapping from token id to position in the allTokens array
1223     mapping(uint256 => uint256) private _allTokensIndex;
1224 
1225     /**
1226      * @dev See {IERC165-supportsInterface}.
1227      */
1228     function supportsInterface(bytes4 interfaceId)
1229         public
1230         view
1231         virtual
1232         override(IERC165, ERC721)
1233         returns (bool)
1234     {
1235         return
1236             interfaceId == type(IERC721Enumerable).interfaceId ||
1237             super.supportsInterface(interfaceId);
1238     }
1239 
1240     /**
1241      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1242      */
1243     function tokenOfOwnerByIndex(address owner, uint256 index)
1244         public
1245         view
1246         virtual
1247         override
1248         returns (uint256)
1249     {
1250         require(
1251             index < ERC721.balanceOf(owner),
1252             "ERC721Enumerable: owner index out of bounds"
1253         );
1254         return _ownedTokens[owner][index];
1255     }
1256 
1257     /**
1258      * @dev See {IERC721Enumerable-totalSupply}.
1259      */
1260     function totalSupply() public view virtual override returns (uint256) {
1261         return _allTokens.length;
1262     }
1263 
1264     /**
1265      * @dev See {IERC721Enumerable-tokenByIndex}.
1266      */
1267     function tokenByIndex(uint256 index)
1268         public
1269         view
1270         virtual
1271         override
1272         returns (uint256)
1273     {
1274         require(
1275             index < ERC721Enumerable.totalSupply(),
1276             "ERC721Enumerable: global index out of bounds"
1277         );
1278         return _allTokens[index];
1279     }
1280 
1281     /**
1282      * @dev Hook that is called before any token transfer. This includes minting
1283      * and burning.
1284      *
1285      * Calling conditions:
1286      *
1287      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1288      * transferred to `to`.
1289      * - When `from` is zero, `tokenId` will be minted for `to`.
1290      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1291      * - `from` cannot be the zero address.
1292      * - `to` cannot be the zero address.
1293      *
1294      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1295      */
1296     function _beforeTokenTransfer(
1297         address from,
1298         address to,
1299         uint256 tokenId
1300     ) internal virtual override {
1301         super._beforeTokenTransfer(from, to, tokenId);
1302 
1303         if (from == address(0)) {
1304             _addTokenToAllTokensEnumeration(tokenId);
1305         } else if (from != to) {
1306             _removeTokenFromOwnerEnumeration(from, tokenId);
1307         }
1308         if (to == address(0)) {
1309             _removeTokenFromAllTokensEnumeration(tokenId);
1310         } else if (to != from) {
1311             _addTokenToOwnerEnumeration(to, tokenId);
1312         }
1313     }
1314 
1315     /**
1316      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1317      * @param to address representing the new owner of the given token ID
1318      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1319      */
1320     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1321         uint256 length = ERC721.balanceOf(to);
1322         _ownedTokens[to][length] = tokenId;
1323         _ownedTokensIndex[tokenId] = length;
1324     }
1325 
1326     /**
1327      * @dev Private function to add a token to this extension's token tracking data structures.
1328      * @param tokenId uint256 ID of the token to be added to the tokens list
1329      */
1330     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1331         _allTokensIndex[tokenId] = _allTokens.length;
1332         _allTokens.push(tokenId);
1333     }
1334 
1335     /**
1336      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1337      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1338      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1339      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1340      * @param from address representing the previous owner of the given token ID
1341      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1342      */
1343     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1344         private
1345     {
1346         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1347         // then delete the last slot (swap and pop).
1348 
1349         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1350         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1351 
1352         // When the token to delete is the last token, the swap operation is unnecessary
1353         if (tokenIndex != lastTokenIndex) {
1354             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1355 
1356             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1357             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1358         }
1359 
1360         // This also deletes the contents at the last position of the array
1361         delete _ownedTokensIndex[tokenId];
1362         delete _ownedTokens[from][lastTokenIndex];
1363     }
1364 
1365     /**
1366      * @dev Private function to remove a token from this extension's token tracking data structures.
1367      * This has O(1) time complexity, but alters the order of the _allTokens array.
1368      * @param tokenId uint256 ID of the token to be removed from the tokens list
1369      */
1370     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1371         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1372         // then delete the last slot (swap and pop).
1373 
1374         uint256 lastTokenIndex = _allTokens.length - 1;
1375         uint256 tokenIndex = _allTokensIndex[tokenId];
1376 
1377         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1378         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1379         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1380         uint256 lastTokenId = _allTokens[lastTokenIndex];
1381 
1382         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1383         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1384 
1385         // This also deletes the contents at the last position of the array
1386         delete _allTokensIndex[tokenId];
1387         _allTokens.pop();
1388     }
1389 }
1390 
1391 // File: openzeppelin-solidity\contracts\access\Ownable.sol
1392 
1393 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1394 
1395 pragma solidity ^0.8.0;
1396 
1397 /**
1398  * @dev Contract module which provides a basic access control mechanism, where
1399  * there is an account (an owner) that can be granted exclusive access to
1400  * specific functions.
1401  *
1402  * By default, the owner account will be the one that deploys the contract. This
1403  * can later be changed with {transferOwnership}.
1404  *
1405  * This module is used through inheritance. It will make available the modifier
1406  * `onlyOwner`, which can be applied to your functions to restrict their use to
1407  * the owner.
1408  */
1409 abstract contract Ownable is Context {
1410     address private _owner;
1411 
1412     event OwnershipTransferred(
1413         address indexed previousOwner,
1414         address indexed newOwner
1415     );
1416 
1417     /**
1418      * @dev Initializes the contract setting the deployer as the initial owner.
1419      */
1420     constructor() {
1421         _transferOwnership(_msgSender());
1422     }
1423 
1424     /**
1425      * @dev Returns the address of the current owner.
1426      */
1427     function owner() public view virtual returns (address) {
1428         return _owner;
1429     }
1430 
1431     /**
1432      * @dev Throws if called by any account other than the owner.
1433      */
1434     modifier onlyOwner() {
1435         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1436         _;
1437     }
1438 
1439     /**
1440      * @dev Leaves the contract without owner. It will not be possible to call
1441      * `onlyOwner` functions anymore. Can only be called by the current owner.
1442      *
1443      * NOTE: Renouncing ownership will leave the contract without an owner,
1444      * thereby removing any functionality that is only available to the owner.
1445      */
1446     function renounceOwnership() public virtual onlyOwner {
1447         _transferOwnership(address(0));
1448     }
1449 
1450     /**
1451      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1452      * Can only be called by the current owner.
1453      */
1454     function transferOwnership(address newOwner) public virtual onlyOwner {
1455         require(
1456             newOwner != address(0),
1457             "Ownable: new owner is the zero address"
1458         );
1459         _transferOwnership(newOwner);
1460     }
1461 
1462     /**
1463      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1464      * Internal function without access restriction.
1465      */
1466     function _transferOwnership(address newOwner) internal virtual {
1467         address oldOwner = _owner;
1468         _owner = newOwner;
1469         emit OwnershipTransferred(oldOwner, newOwner);
1470     }
1471 }
1472 
1473 // File: contracts\RPG404.sol
1474 
1475 pragma solidity >=0.7.0 <0.9.0;
1476 
1477 contract RPG404 is ERC721Enumerable, Ownable {
1478     using Strings for uint256;
1479 
1480     string baseURI;
1481     string public baseExtension = ".json";
1482 
1483     uint256 public maxSupply = 19998;
1484     uint256 public maxFreeSupply = 999;
1485 
1486     uint256 public maxPerTxDuringMint = 6;
1487     uint256 public maxPerAddressDuringMint = 18;
1488     uint256 public maxPerAddressDuringFreeMint = 3;
1489 
1490     uint256 public cost = 0.015 ether;
1491     bool public saleIsActive = false;
1492 
1493     mapping(address => uint256) public freeMintedAmount;
1494     mapping(address => uint256) public mintedAmount;
1495 
1496     constructor() ERC721("RPG 404", "RPG404") {}
1497 
1498     modifier mintCompliance() {
1499         require(saleIsActive, "Sale is not active yet.");
1500         require(tx.origin == msg.sender, "Caller cannot be a contract.");
1501         _;
1502     }
1503 
1504     // internal
1505     function _baseURI() internal view virtual override returns (string memory) {
1506         return baseURI;
1507     }
1508 
1509     // public
1510     function mint(uint256 _quantity) external payable mintCompliance {
1511         uint256 _totalSupply = totalSupply();
1512         require(msg.value >= cost * _quantity, "Insufficient Fund.");
1513         require(maxSupply >= _totalSupply + _quantity, "Exceeds max supply.");
1514         uint256 _mintedAmount = mintedAmount[msg.sender];
1515         require(
1516             _mintedAmount + _quantity <= maxPerAddressDuringMint,
1517             "Exceeds max mints per address!"
1518         );
1519         require(
1520             _quantity > 0 && _quantity <= maxPerTxDuringMint,
1521             "Invalid mint amount."
1522         );
1523         mintedAmount[msg.sender] = _mintedAmount + _quantity;
1524         for (uint256 i = 1; i <= _quantity; i++) {
1525             _safeMint(msg.sender, _totalSupply + i);
1526         }
1527     }
1528 
1529     function freeMint(uint256 _quantity) external mintCompliance {
1530         uint256 _totalSupply = totalSupply();
1531         require(
1532             maxFreeSupply >= _totalSupply + _quantity,
1533             "Exceeds max free supply."
1534         );
1535         uint256 _freeMintedAmount = freeMintedAmount[msg.sender];
1536         require(
1537             _quantity > 0 && _quantity <= maxPerAddressDuringFreeMint,
1538             "Invalid mint amount."
1539         );
1540         require(
1541             _freeMintedAmount + _quantity <= maxPerAddressDuringFreeMint,
1542             "Exceeds max free mints per address!"
1543         );
1544         freeMintedAmount[msg.sender] = _freeMintedAmount + _quantity;
1545 
1546         for (uint256 i = 1; i <= _quantity; i++) {
1547             _safeMint(msg.sender, _totalSupply + i);
1548         }
1549     }
1550 
1551     function walletOfOwner(address _owner)
1552         public
1553         view
1554         returns (uint256[] memory)
1555     {
1556         uint256 _ownerTokenCount = balanceOf(_owner);
1557         uint256[] memory tokenIds = new uint256[](_ownerTokenCount);
1558         for (uint256 i; i < _ownerTokenCount; i++) {
1559             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1560         }
1561         return tokenIds;
1562     }
1563 
1564     function tokenURI(uint256 _tokenId)
1565         public
1566         view
1567         virtual
1568         override
1569         returns (string memory)
1570     {
1571         require(
1572             _exists(_tokenId),
1573             "ERC721Metadata: URI query for nonexistent token"
1574         );
1575 
1576         string memory _currentBaseURI = _baseURI();
1577         return
1578             bytes(_currentBaseURI).length > 0
1579                 ? string(
1580                     abi.encodePacked(
1581                         _currentBaseURI,
1582                         _tokenId.toString(),
1583                         baseExtension
1584                     )
1585                 )
1586                 : "";
1587     }
1588 
1589     function setCost(uint256 _newCost) public onlyOwner {
1590         cost = _newCost;
1591     }
1592 
1593     function setmaxMintAmount(uint256 _newMaxPerTxDuringMint) public onlyOwner {
1594         maxPerTxDuringMint = _newMaxPerTxDuringMint;
1595     }
1596 
1597     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1598         baseURI = _newBaseURI;
1599     }
1600 
1601     function setBaseExtension(string memory _newBaseExtension)
1602         public
1603         onlyOwner
1604     {
1605         baseExtension = _newBaseExtension;
1606     }
1607 
1608     function flipSale() public onlyOwner {
1609         saleIsActive = !saleIsActive;
1610     }
1611 
1612     function withdraw() public payable onlyOwner {
1613         (bool _success, ) = payable(owner()).call{value: address(this).balance}(
1614             ""
1615         );
1616         require(_success);
1617     }
1618 }