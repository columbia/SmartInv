1 // SPDX-License-Identifier: MIT
2 /*
3    .____    .__             .__    .___   ___________
4    |    |   |__| ________ __|__| __| _/   \_   _____/__________  ____   ____
5    |    |   |  |/ ____/  |  \  |/ __ |     |    __)/  _ \_  __ \/ ___\_/ __ \
6    |    |___|  < <_|  |  |  /  / /_/ |     |     \(  <_> )  | \/ /_/  >  ___/
7    |_______ \__|\__   |____/|__\____ |     \___  / \____/|__|  \___  / \___  >
8            \/      |__|             \/         \/             /_____/      \/
9 
10     * Liquid Forge Contract for ApeLiquid.io | August 2022
11     *
12     * For the Forge of Typical Tigers with METL rewards earned over time
13 */
14 
15 pragma solidity ^0.8.0;
16 
17 /**
18  * @dev Interface of the ERC165 standard, as defined in the
19  * https://eips.ethereum.org/EIPS/eip-165[EIP].
20  *
21  * Implementers can declare support of contract interfaces, which can then be
22  * queried by others ({ERC165Checker}).
23  *
24  * For an implementation, see {ERC165}.
25  */
26 interface IERC165 {
27     /**
28      * @dev Returns true if this contract implements the interface defined by
29      * `interfaceId`. See the corresponding
30      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
31      * to learn more about how these ids are created.
32      *
33      * This function call must use less than 30 000 gas.
34      */
35     function supportsInterface(bytes4 interfaceId) external view returns (bool);
36 }
37 
38 pragma solidity ^0.8.0;
39 
40 /**
41  * @dev Implementation of the {IERC165} interface.
42  *
43  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
44  * for the additional interface id that will be supported. For example:
45  *
46  * ```solidity
47  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
48  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
49  * }
50  * ```
51  *
52  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
53  */
54 abstract contract ERC165 is IERC165 {
55     /**
56      * @dev See {IERC165-supportsInterface}.
57      */
58     function supportsInterface(bytes4 interfaceId)
59         public
60         view
61         virtual
62         override
63         returns (bool)
64     {
65         return interfaceId == type(IERC165).interfaceId;
66     }
67 }
68 
69 pragma solidity ^0.8.0;
70 
71 /**
72  * @dev String operations.
73  */
74 library Strings {
75     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
76 
77     /**
78      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
79      */
80     function toString(uint256 value) internal pure returns (string memory) {
81         // Inspired by OraclizeAPI's implementation - MIT licence
82         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
83 
84         if (value == 0) {
85             return "0";
86         }
87         uint256 temp = value;
88         uint256 digits;
89         while (temp != 0) {
90             digits++;
91             temp /= 10;
92         }
93         bytes memory buffer = new bytes(digits);
94         while (value != 0) {
95             digits -= 1;
96             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
97             value /= 10;
98         }
99         return string(buffer);
100     }
101 
102     /**
103      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
104      */
105     function toHexString(uint256 value) internal pure returns (string memory) {
106         if (value == 0) {
107             return "0x00";
108         }
109         uint256 temp = value;
110         uint256 length = 0;
111         while (temp != 0) {
112             length++;
113             temp >>= 8;
114         }
115         return toHexString(value, length);
116     }
117 
118     /**
119      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
120      */
121     function toHexString(uint256 value, uint256 length)
122         internal
123         pure
124         returns (string memory)
125     {
126         bytes memory buffer = new bytes(2 * length + 2);
127         buffer[0] = "0";
128         buffer[1] = "x";
129         for (uint256 i = 2 * length + 1; i > 1; --i) {
130             buffer[i] = _HEX_SYMBOLS[value & 0xf];
131             value >>= 4;
132         }
133         require(value == 0, "Strings: hex length insufficient");
134         return string(buffer);
135     }
136 }
137 
138 pragma solidity ^0.8.0;
139 
140 /**
141  * @dev Provides information about the current execution context, including the
142  * sender of the transaction and its data. While these are generally available
143  * via msg.sender and msg.data, they should not be accessed in such a direct
144  * manner, since when dealing with meta-transactions the account sending and
145  * paying for execution may not be the actual sender (as far as an application
146  * is concerned).
147  *
148  * This contract is only required for intermediate, library-like contracts.
149  */
150 abstract contract Context {
151     function _msgSender() internal view virtual returns (address) {
152         return msg.sender;
153     }
154 
155     function _msgData() internal view virtual returns (bytes calldata) {
156         return msg.data;
157     }
158 }
159 
160 pragma solidity ^0.8.0;
161 
162 /**
163  * @dev Collection of functions related to the address type
164  */
165 library Address {
166     /**
167      * @dev Returns true if `account` is a contract.
168      *
169      * [IMPORTANT]
170      * ====
171      * It is unsafe to assume that an address for which this function returns
172      * false is an externally-owned account (EOA) and not a contract.
173      *
174      * Among others, `isContract` will return false for the following
175      * types of addresses:
176      *
177      *  - an externally-owned account
178      *  - a contract in construction
179      *  - an address where a contract will be created
180      *  - an address where a contract lived, but was destroyed
181      * ====
182      */
183     function isContract(address account) internal view returns (bool) {
184         // This method relies on extcodesize, which returns 0 for contracts in
185         // construction, since the code is only stored at the end of the
186         // constructor execution.
187 
188         uint256 size;
189         assembly {
190             size := extcodesize(account)
191         }
192         return size > 0;
193     }
194 
195     /**
196      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
197      * `recipient`, forwarding all available gas and reverting on errors.
198      *
199      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
200      * of certain opcodes, possibly making contracts go over the 2300 gas limit
201      * imposed by `transfer`, making them unable to receive funds via
202      * `transfer`. {sendValue} removes this limitation.
203      *
204      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
205      *
206      * IMPORTANT: because control is transferred to `recipient`, care must be
207      * taken to not create reentrancy vulnerabilities. Consider using
208      * {ReentrancyGuard} or the
209      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
210      */
211     function sendValue(address payable recipient, uint256 amount) internal {
212         require(
213             address(this).balance >= amount,
214             "Address: insufficient balance"
215         );
216 
217         (bool success, ) = recipient.call{value: amount}("");
218         require(
219             success,
220             "Address: unable to send value, recipient may have reverted"
221         );
222     }
223 
224     /**
225      * @dev Performs a Solidity function call using a low level `call`. A
226      * plain `call` is an unsafe replacement for a function call: use this
227      * function instead.
228      *
229      * If `target` reverts with a revert reason, it is bubbled up by this
230      * function (like regular Solidity function calls).
231      *
232      * Returns the raw returned data. To convert to the expected return value,
233      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
234      *
235      * Requirements:
236      *
237      * - `target` must be a contract.
238      * - calling `target` with `data` must not revert.
239      *
240      * _Available since v3.1._
241      */
242     function functionCall(address target, bytes memory data)
243         internal
244         returns (bytes memory)
245     {
246         return functionCall(target, data, "Address: low-level call failed");
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
251      * `errorMessage` as a fallback revert reason when `target` reverts.
252      *
253      * _Available since v3.1._
254      */
255     function functionCall(
256         address target,
257         bytes memory data,
258         string memory errorMessage
259     ) internal returns (bytes memory) {
260         return functionCallWithValue(target, data, 0, errorMessage);
261     }
262 
263     /**
264      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
265      * but also transferring `value` wei to `target`.
266      *
267      * Requirements:
268      *
269      * - the calling contract must have an ETH balance of at least `value`.
270      * - the called Solidity function must be `payable`.
271      *
272      * _Available since v3.1._
273      */
274     function functionCallWithValue(
275         address target,
276         bytes memory data,
277         uint256 value
278     ) internal returns (bytes memory) {
279         return
280             functionCallWithValue(
281                 target,
282                 data,
283                 value,
284                 "Address: low-level call with value failed"
285             );
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
290      * with `errorMessage` as a fallback revert reason when `target` reverts.
291      *
292      * _Available since v3.1._
293      */
294     function functionCallWithValue(
295         address target,
296         bytes memory data,
297         uint256 value,
298         string memory errorMessage
299     ) internal returns (bytes memory) {
300         require(
301             address(this).balance >= value,
302             "Address: insufficient balance for call"
303         );
304         require(isContract(target), "Address: call to non-contract");
305 
306         (bool success, bytes memory returndata) = target.call{value: value}(
307             data
308         );
309         return verifyCallResult(success, returndata, errorMessage);
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
314      * but performing a static call.
315      *
316      * _Available since v3.3._
317      */
318     function functionStaticCall(address target, bytes memory data)
319         internal
320         view
321         returns (bytes memory)
322     {
323         return
324             functionStaticCall(
325                 target,
326                 data,
327                 "Address: low-level static call failed"
328             );
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
333      * but performing a static call.
334      *
335      * _Available since v3.3._
336      */
337     function functionStaticCall(
338         address target,
339         bytes memory data,
340         string memory errorMessage
341     ) internal view returns (bytes memory) {
342         require(isContract(target), "Address: static call to non-contract");
343 
344         (bool success, bytes memory returndata) = target.staticcall(data);
345         return verifyCallResult(success, returndata, errorMessage);
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
350      * but performing a delegate call.
351      *
352      * _Available since v3.4._
353      */
354     function functionDelegateCall(address target, bytes memory data)
355         internal
356         returns (bytes memory)
357     {
358         return
359             functionDelegateCall(
360                 target,
361                 data,
362                 "Address: low-level delegate call failed"
363             );
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
368      * but performing a delegate call.
369      *
370      * _Available since v3.4._
371      */
372     function functionDelegateCall(
373         address target,
374         bytes memory data,
375         string memory errorMessage
376     ) internal returns (bytes memory) {
377         require(isContract(target), "Address: delegate call to non-contract");
378 
379         (bool success, bytes memory returndata) = target.delegatecall(data);
380         return verifyCallResult(success, returndata, errorMessage);
381     }
382 
383     /**
384      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
385      * revert reason using the provided one.
386      *
387      * _Available since v4.3._
388      */
389     function verifyCallResult(
390         bool success,
391         bytes memory returndata,
392         string memory errorMessage
393     ) internal pure returns (bytes memory) {
394         if (success) {
395             return returndata;
396         } else {
397             // Look for revert reason and bubble it up if present
398             if (returndata.length > 0) {
399                 // The easiest way to bubble the revert reason is using memory via assembly
400 
401                 assembly {
402                     let returndata_size := mload(returndata)
403                     revert(add(32, returndata), returndata_size)
404                 }
405             } else {
406                 revert(errorMessage);
407             }
408         }
409     }
410 }
411 
412 pragma solidity ^0.8.0;
413 
414 /**
415  * @title ERC721 token receiver interface
416  * @dev Interface for any contract that wants to support safeTransfers
417  * from ERC721 asset contracts.
418  */
419 interface IERC721Receiver {
420     /**
421      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
422      * by `operator` from `from`, this function is called.
423      *
424      * It must return its Solidity selector to confirm the token transfer.
425      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
426      *
427      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
428      */
429     function onERC721Received(
430         address operator,
431         address from,
432         uint256 tokenId,
433         bytes calldata data
434     ) external returns (bytes4);
435 }
436 
437 pragma solidity ^0.8.0;
438 
439 pragma solidity ^0.8.0;
440 
441 /**
442  * @dev Required interface of an ERC721 compliant contract.
443  */
444 interface IERC721 is IERC165 {
445     /**
446      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
447      */
448     event Transfer(
449         address indexed from,
450         address indexed to,
451         uint256 indexed tokenId
452     );
453 
454     /**
455      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
456      */
457     event Approval(
458         address indexed owner,
459         address indexed approved,
460         uint256 indexed tokenId
461     );
462 
463     /**
464      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
465      */
466     event ApprovalForAll(
467         address indexed owner,
468         address indexed operator,
469         bool approved
470     );
471 
472     /**
473      * @dev Returns the number of tokens in ``owner``'s account.
474      */
475     function balanceOf(address owner) external view returns (uint256 balance);
476 
477     /**
478      * @dev Returns the owner of the `tokenId` token.
479      *
480      * Requirements:
481      *
482      * - `tokenId` must exist.
483      */
484     function ownerOf(uint256 tokenId) external view returns (address owner);
485 
486     /**
487      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
488      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
489      *
490      * Requirements:
491      *
492      * - `from` cannot be the zero address.
493      * - `to` cannot be the zero address.
494      * - `tokenId` token must exist and be owned by `from`.
495      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
496      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
497      *
498      * Emits a {Transfer} event.
499      */
500     function safeTransferFrom(
501         address from,
502         address to,
503         uint256 tokenId
504     ) external;
505 
506     /**
507      * @dev Transfers `tokenId` token from `from` to `to`.
508      *
509      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
510      *
511      * Requirements:
512      *
513      * - `from` cannot be the zero address.
514      * - `to` cannot be the zero address.
515      * - `tokenId` token must be owned by `from`.
516      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
517      *
518      * Emits a {Transfer} event.
519      */
520     function transferFrom(
521         address from,
522         address to,
523         uint256 tokenId
524     ) external;
525 
526     /**
527      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
528      * The approval is cleared when the token is transferred.
529      *
530      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
531      *
532      * Requirements:
533      *
534      * - The caller must own the token or be an approved operator.
535      * - `tokenId` must exist.
536      *
537      * Emits an {Approval} event.
538      */
539     function approve(address to, uint256 tokenId) external;
540 
541     /**
542      * @dev Returns the account approved for `tokenId` token.
543      *
544      * Requirements:
545      *
546      * - `tokenId` must exist.
547      */
548     function getApproved(uint256 tokenId)
549         external
550         view
551         returns (address operator);
552 
553     /**
554      * @dev Approve or remove `operator` as an operator for the caller.
555      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
556      *
557      * Requirements:
558      *
559      * - The `operator` cannot be the caller.
560      *
561      * Emits an {ApprovalForAll} event.
562      */
563     function setApprovalForAll(address operator, bool _approved) external;
564 
565     /**
566      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
567      *
568      * See {setApprovalForAll}
569      */
570     function isApprovedForAll(address owner, address operator)
571         external
572         view
573         returns (bool);
574 
575     /**
576      * @dev Safely transfers `tokenId` token from `from` to `to`.
577      *
578      * Requirements:
579      *
580      * - `from` cannot be the zero address.
581      * - `to` cannot be the zero address.
582      * - `tokenId` token must exist and be owned by `from`.
583      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
584      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
585      *
586      * Emits a {Transfer} event.
587      */
588     function safeTransferFrom(
589         address from,
590         address to,
591         uint256 tokenId,
592         bytes calldata data
593     ) external;
594 }
595 
596 /**
597  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
598  * @dev See https://eips.ethereum.org/EIPS/eip-721
599  */
600 interface IERC721Enumerable is IERC721 {
601     /**
602      * @dev Returns the total amount of tokens stored by the contract.
603      */
604     function totalSupply() external view returns (uint256);
605 
606     /**
607      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
608      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
609      */
610     function tokenOfOwnerByIndex(address owner, uint256 index)
611         external
612         view
613         returns (uint256 tokenId);
614 
615     /**
616      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
617      * Use along with {totalSupply} to enumerate all tokens.
618      */
619     function tokenByIndex(uint256 index) external view returns (uint256);
620 }
621 
622 pragma solidity ^0.8.0;
623 
624 /**
625  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
626  * @dev See https://eips.ethereum.org/EIPS/eip-721
627  */
628 interface IERC721Metadata is IERC721 {
629     /**
630      * @dev Returns the token collection name.
631      */
632     function name() external view returns (string memory);
633 
634     /**
635      * @dev Returns the token collection symbol.
636      */
637     function symbol() external view returns (string memory);
638 
639     /**
640      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
641      */
642     function tokenURI(uint256 tokenId) external view returns (string memory);
643 }
644 
645 pragma solidity ^0.8.0;
646 
647 /**
648  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
649  * the Metadata extension, but not including the Enumerable extension, which is available separately as
650  * {ERC721Enumerable}.
651  */
652 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
653     using Address for address;
654     using Strings for uint256;
655 
656     // Token name
657     string private _name;
658 
659     // Token symbol
660     string private _symbol;
661 
662     // Mapping from token ID to owner address
663     mapping(uint256 => address) private _owners;
664 
665     // Mapping owner address to token count
666     mapping(address => uint256) private _balances;
667 
668     // Mapping from token ID to approved address
669     mapping(uint256 => address) private _tokenApprovals;
670 
671     // Mapping from owner to operator approvals
672     mapping(address => mapping(address => bool)) private _operatorApprovals;
673 
674     /**
675      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
676      */
677     constructor(string memory name_, string memory symbol_) {
678         _name = name_;
679         _symbol = symbol_;
680     }
681 
682     /**
683      * @dev See {IERC165-supportsInterface}.
684      */
685     function supportsInterface(bytes4 interfaceId)
686         public
687         view
688         virtual
689         override(ERC165, IERC165)
690         returns (bool)
691     {
692         return
693             interfaceId == type(IERC721).interfaceId ||
694             interfaceId == type(IERC721Metadata).interfaceId ||
695             super.supportsInterface(interfaceId);
696     }
697 
698     /**
699      * @dev See {IERC721-balanceOf}.
700      */
701     function balanceOf(address owner)
702         public
703         view
704         virtual
705         override
706         returns (uint256)
707     {
708         require(
709             owner != address(0),
710             "ERC721: balance query for the zero address"
711         );
712         return _balances[owner];
713     }
714 
715     /**
716      * @dev See {IERC721-ownerOf}.
717      */
718     function ownerOf(uint256 tokenId)
719         public
720         view
721         virtual
722         override
723         returns (address)
724     {
725         address owner = _owners[tokenId];
726         require(
727             owner != address(0),
728             "ERC721: owner query for nonexistent token"
729         );
730         return owner;
731     }
732 
733     /**
734      * @dev See {IERC721Metadata-name}.
735      */
736     function name() public view virtual override returns (string memory) {
737         return _name;
738     }
739 
740     /**
741      * @dev See {IERC721Metadata-symbol}.
742      */
743     function symbol() public view virtual override returns (string memory) {
744         return _symbol;
745     }
746 
747     /**
748      * @dev See {IERC721Metadata-tokenURI}.
749      */
750     function tokenURI(uint256 tokenId)
751         public
752         view
753         virtual
754         override
755         returns (string memory)
756     {
757         require(
758             _exists(tokenId),
759             "ERC721Metadata: URI query for nonexistent token"
760         );
761 
762         string memory baseURI = _baseURI();
763         return
764             bytes(baseURI).length > 0
765                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
766                 : "";
767     }
768 
769     /**
770      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
771      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
772      * by default, can be overriden in child contracts.
773      */
774     function _baseURI() internal view virtual returns (string memory) {
775         return "";
776     }
777 
778     /**
779      * @dev See {IERC721-approve}.
780      */
781     function approve(address to, uint256 tokenId) public virtual override {
782         address owner = ERC721.ownerOf(tokenId);
783         require(to != owner, "ERC721: approval to current owner");
784 
785         require(
786             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
787             "ERC721: approve caller is not owner nor approved for all"
788         );
789 
790         _approve(to, tokenId);
791     }
792 
793     /**
794      * @dev See {IERC721-getApproved}.
795      */
796     function getApproved(uint256 tokenId)
797         public
798         view
799         virtual
800         override
801         returns (address)
802     {
803         require(
804             _exists(tokenId),
805             "ERC721: approved query for nonexistent token"
806         );
807 
808         return _tokenApprovals[tokenId];
809     }
810 
811     /**
812      * @dev See {IERC721-setApprovalForAll}.
813      */
814     function setApprovalForAll(address operator, bool approved)
815         public
816         virtual
817         override
818     {
819         _setApprovalForAll(_msgSender(), operator, approved);
820     }
821 
822     /**
823      * @dev See {IERC721-isApprovedForAll}.
824      */
825     function isApprovedForAll(address owner, address operator)
826         public
827         view
828         virtual
829         override
830         returns (bool)
831     {
832         return _operatorApprovals[owner][operator];
833     }
834 
835     /**
836      * @dev See {IERC721-transferFrom}.
837      */
838     function transferFrom(
839         address from,
840         address to,
841         uint256 tokenId
842     ) public virtual override {
843         //solhint-disable-next-line max-line-length
844         require(
845             _isApprovedOrOwner(_msgSender(), tokenId),
846             "ERC721: transfer caller is not owner nor approved"
847         );
848 
849         _transfer(from, to, tokenId);
850     }
851 
852     /**
853      * @dev See {IERC721-safeTransferFrom}.
854      */
855     function safeTransferFrom(
856         address from,
857         address to,
858         uint256 tokenId
859     ) public virtual override {
860         safeTransferFrom(from, to, tokenId, "");
861     }
862 
863     /**
864      * @dev See {IERC721-safeTransferFrom}.
865      */
866     function safeTransferFrom(
867         address from,
868         address to,
869         uint256 tokenId,
870         bytes memory _data
871     ) public virtual override {
872         require(
873             _isApprovedOrOwner(_msgSender(), tokenId),
874             "ERC721: transfer caller is not owner nor approved"
875         );
876         _safeTransfer(from, to, tokenId, _data);
877     }
878 
879     /**
880      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
881      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
882      *
883      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
884      *
885      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
886      * implement alternative mechanisms to perform token transfer, such as signature-based.
887      *
888      * Requirements:
889      *
890      * - `from` cannot be the zero address.
891      * - `to` cannot be the zero address.
892      * - `tokenId` token must exist and be owned by `from`.
893      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
894      *
895      * Emits a {Transfer} event.
896      */
897     function _safeTransfer(
898         address from,
899         address to,
900         uint256 tokenId,
901         bytes memory _data
902     ) internal virtual {
903         _transfer(from, to, tokenId);
904         require(
905             _checkOnERC721Received(from, to, tokenId, _data),
906             "ERC721: transfer to non ERC721Receiver implementer"
907         );
908     }
909 
910     /**
911      * @dev Returns whether `tokenId` exists.
912      *
913      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
914      *
915      * Tokens start existing when they are minted (`_mint`),
916      * and stop existing when they are burned (`_burn`).
917      */
918     function _exists(uint256 tokenId) internal view virtual returns (bool) {
919         return _owners[tokenId] != address(0);
920     }
921 
922     /**
923      * @dev Returns whether `spender` is allowed to manage `tokenId`.
924      *
925      * Requirements:
926      *
927      * - `tokenId` must exist.
928      */
929     function _isApprovedOrOwner(address spender, uint256 tokenId)
930         internal
931         view
932         virtual
933         returns (bool)
934     {
935         require(
936             _exists(tokenId),
937             "ERC721: operator query for nonexistent token"
938         );
939         address owner = ERC721.ownerOf(tokenId);
940         return (spender == owner ||
941             getApproved(tokenId) == spender ||
942             isApprovedForAll(owner, spender));
943     }
944 
945     /**
946      * @dev Safely mints `tokenId` and transfers it to `to`.
947      *
948      * Requirements:
949      *
950      * - `tokenId` must not exist.
951      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
952      *
953      * Emits a {Transfer} event.
954      */
955     function _safeMint(address to, uint256 tokenId) internal virtual {
956         _safeMint(to, tokenId, "");
957     }
958 
959     /**
960      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
961      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
962      */
963     function _safeMint(
964         address to,
965         uint256 tokenId,
966         bytes memory _data
967     ) internal virtual {
968         _mint(to, tokenId);
969         require(
970             _checkOnERC721Received(address(0), to, tokenId, _data),
971             "ERC721: transfer to non ERC721Receiver implementer"
972         );
973     }
974 
975     /**
976      * @dev Mints `tokenId` and transfers it to `to`.
977      *
978      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
979      *
980      * Requirements:
981      *
982      * - `tokenId` must not exist.
983      * - `to` cannot be the zero address.
984      *
985      * Emits a {Transfer} event.
986      */
987     function _mint(address to, uint256 tokenId) internal virtual {
988         require(to != address(0), "ERC721: mint to the zero address");
989         require(!_exists(tokenId), "ERC721: token already minted");
990 
991         _beforeTokenTransfer(address(0), to, tokenId);
992 
993         _balances[to] += 1;
994         _owners[tokenId] = to;
995 
996         emit Transfer(address(0), to, tokenId);
997     }
998 
999     /**
1000      * @dev Destroys `tokenId`.
1001      * The approval is cleared when the token is burned.
1002      *
1003      * Requirements:
1004      *
1005      * - `tokenId` must exist.
1006      *
1007      * Emits a {Transfer} event.
1008      */
1009     function _burn(uint256 tokenId) internal virtual {
1010         address owner = ERC721.ownerOf(tokenId);
1011 
1012         _beforeTokenTransfer(owner, address(0), tokenId);
1013 
1014         // Clear approvals
1015         _approve(address(0), tokenId);
1016 
1017         _balances[owner] -= 1;
1018         delete _owners[tokenId];
1019 
1020         emit Transfer(owner, address(0), tokenId);
1021     }
1022 
1023     /**
1024      * @dev Transfers `tokenId` from `from` to `to`.
1025      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1026      *
1027      * Requirements:
1028      *
1029      * - `to` cannot be the zero address.
1030      * - `tokenId` token must be owned by `from`.
1031      *
1032      * Emits a {Transfer} event.
1033      */
1034     function _transfer(
1035         address from,
1036         address to,
1037         uint256 tokenId
1038     ) internal virtual {
1039         require(
1040             ERC721.ownerOf(tokenId) == from,
1041             "ERC721: transfer of token that is not own"
1042         );
1043         require(to != address(0), "ERC721: transfer to the zero address");
1044 
1045         _beforeTokenTransfer(from, to, tokenId);
1046 
1047         // Clear approvals from the previous owner
1048         _approve(address(0), tokenId);
1049 
1050         _balances[from] -= 1;
1051         _balances[to] += 1;
1052         _owners[tokenId] = to;
1053 
1054         emit Transfer(from, to, tokenId);
1055     }
1056 
1057     /**
1058      * @dev Approve `to` to operate on `tokenId`
1059      *
1060      * Emits a {Approval} event.
1061      */
1062     function _approve(address to, uint256 tokenId) internal virtual {
1063         _tokenApprovals[tokenId] = to;
1064         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1065     }
1066 
1067     /**
1068      * @dev Approve `operator` to operate on all of `owner` tokens
1069      *
1070      * Emits a {ApprovalForAll} event.
1071      */
1072     function _setApprovalForAll(
1073         address owner,
1074         address operator,
1075         bool approved
1076     ) internal virtual {
1077         require(owner != operator, "ERC721: approve to caller");
1078         _operatorApprovals[owner][operator] = approved;
1079         emit ApprovalForAll(owner, operator, approved);
1080     }
1081 
1082     /**
1083      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1084      * The call is not executed if the target address is not a contract.
1085      *
1086      * @param from address representing the previous owner of the given token ID
1087      * @param to target address that will receive the tokens
1088      * @param tokenId uint256 ID of the token to be transferred
1089      * @param _data bytes optional data to send along with the call
1090      * @return bool whether the call correctly returned the expected magic value
1091      */
1092     function _checkOnERC721Received(
1093         address from,
1094         address to,
1095         uint256 tokenId,
1096         bytes memory _data
1097     ) private returns (bool) {
1098         if (to.isContract()) {
1099             try
1100                 IERC721Receiver(to).onERC721Received(
1101                     _msgSender(),
1102                     from,
1103                     tokenId,
1104                     _data
1105                 )
1106             returns (bytes4 retval) {
1107                 return retval == IERC721Receiver.onERC721Received.selector;
1108             } catch (bytes memory reason) {
1109                 if (reason.length == 0) {
1110                     revert(
1111                         "ERC721: transfer to non ERC721Receiver implementer"
1112                     );
1113                 } else {
1114                     assembly {
1115                         revert(add(32, reason), mload(reason))
1116                     }
1117                 }
1118             }
1119         } else {
1120             return true;
1121         }
1122     }
1123 
1124     /**
1125      * @dev Hook that is called before any token transfer. This includes minting
1126      * and burning.
1127      *
1128      * Calling conditions:
1129      *
1130      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1131      * transferred to `to`.
1132      * - When `from` is zero, `tokenId` will be minted for `to`.
1133      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1134      * - `from` and `to` are never both zero.
1135      *
1136      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1137      */
1138     function _beforeTokenTransfer(
1139         address from,
1140         address to,
1141         uint256 tokenId
1142     ) internal virtual {}
1143 }
1144 
1145 pragma solidity ^0.8.0;
1146 
1147 /**
1148  * @title SafeERC20
1149  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1150  * contract returns false). Tokens that return no value (and instead revert or
1151  * throw on failure) are also supported, non-reverting calls are assumed to be
1152  * successful.
1153  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1154  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1155  */
1156 library SafeERC20 {
1157     using Address for address;
1158 
1159     function safeTransfer(
1160         IERC20 token,
1161         address to,
1162         uint256 value
1163     ) internal {
1164         _callOptionalReturn(
1165             token,
1166             abi.encodeWithSelector(token.transfer.selector, to, value)
1167         );
1168     }
1169 
1170     function safeTransferFrom(
1171         IERC20 token,
1172         address from,
1173         address to,
1174         uint256 value
1175     ) internal {
1176         _callOptionalReturn(
1177             token,
1178             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
1179         );
1180     }
1181 
1182     /**
1183      * @dev Deprecated. This function has issues similar to the ones found in
1184      * {IERC20-approve}, and its usage is discouraged.
1185      *
1186      * Whenever possible, use {safeIncreaseAllowance} and
1187      * {safeDecreaseAllowance} instead.
1188      */
1189     function safeApprove(
1190         IERC20 token,
1191         address spender,
1192         uint256 value
1193     ) internal {
1194         // safeApprove should only be called when setting an initial allowance,
1195         // or when resetting it to zero. To increase and decrease it, use
1196         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1197         require(
1198             (value == 0) || (token.allowance(address(this), spender) == 0),
1199             "SafeERC20: approve from non-zero to non-zero allowance"
1200         );
1201         _callOptionalReturn(
1202             token,
1203             abi.encodeWithSelector(token.approve.selector, spender, value)
1204         );
1205     }
1206 
1207     function safeIncreaseAllowance(
1208         IERC20 token,
1209         address spender,
1210         uint256 value
1211     ) internal {
1212         uint256 newAllowance = token.allowance(address(this), spender) + value;
1213         _callOptionalReturn(
1214             token,
1215             abi.encodeWithSelector(
1216                 token.approve.selector,
1217                 spender,
1218                 newAllowance
1219             )
1220         );
1221     }
1222 
1223     function safeDecreaseAllowance(
1224         IERC20 token,
1225         address spender,
1226         uint256 value
1227     ) internal {
1228         unchecked {
1229             uint256 oldAllowance = token.allowance(address(this), spender);
1230             require(
1231                 oldAllowance >= value,
1232                 "SafeERC20: decreased allowance below zero"
1233             );
1234             uint256 newAllowance = oldAllowance - value;
1235             _callOptionalReturn(
1236                 token,
1237                 abi.encodeWithSelector(
1238                     token.approve.selector,
1239                     spender,
1240                     newAllowance
1241                 )
1242             );
1243         }
1244     }
1245 
1246     /**
1247      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract),
1248      * relaxing the requirement
1249      * on the return value: the return value is optional (but if data is returned, it must not be false).
1250      * @param token The token targeted by the call.
1251      * @param data The call data (encoded using abi.encode or one of its variants).
1252      */
1253     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1254         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1255         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1256         // the target address contains contract code and also asserts for success in the low-level call.
1257 
1258         bytes memory returndata = address(token).functionCall(
1259             data,
1260             "SafeERC20: low-level call failed"
1261         );
1262         if (returndata.length > 0) {
1263             // Return data is optional
1264             require(
1265                 abi.decode(returndata, (bool)),
1266                 "SafeERC20: ERC20 operation did not succeed"
1267             );
1268         }
1269     }
1270 }
1271 
1272 pragma solidity ^0.8.0;
1273 
1274 /**
1275  * @dev Interface of the ERC20 standard as defined in the EIP.
1276  */
1277 interface IERC20 {
1278     /**
1279      * @dev Returns the amount of tokens in existence.
1280      */
1281     function totalSupply() external view returns (uint256);
1282 
1283     /**
1284      * @dev Returns the amount of tokens owned by `account`.
1285      */
1286     function balanceOf(address account) external view returns (uint256);
1287 
1288     /**
1289      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1290      *
1291      * Returns a boolean value indicating whether the operation succeeded.
1292      *
1293      * Emits a {Transfer} event.
1294      */
1295     function transfer(address recipient, uint256 amount)
1296         external
1297         returns (bool);
1298 
1299     /**
1300      * @dev Returns the remaining number of tokens that `spender` will be
1301      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1302      * zero by default.
1303      *
1304      * This value changes when {approve} or {transferFrom} are called.
1305      */
1306     function allowance(address owner, address spender)
1307         external
1308         view
1309         returns (uint256);
1310 
1311     /**
1312      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1313      *
1314      * Returns a boolean value indicating whether the operation succeeded.
1315      *
1316      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1317      * that someone may use both the old and the new allowance by unfortunate
1318      * transaction ordering. One possible solution to mitigate this race
1319      * condition is to first reduce the spender's allowance to 0 and set the
1320      * desired value afterwards:
1321      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1322      *
1323      * Emits an {Approval} event.
1324      */
1325     function approve(address spender, uint256 amount) external returns (bool);
1326 
1327     /**
1328      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1329      * allowance mechanism. `amount` is then deducted from the caller's
1330      * allowance.
1331      *
1332      * Returns a boolean value indicating whether the operation succeeded.
1333      *
1334      * Emits a {Transfer} event.
1335      */
1336     function transferFrom(
1337         address sender,
1338         address recipient,
1339         uint256 amount
1340     ) external returns (bool);
1341 
1342     /**
1343      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1344      * another (`to`).
1345      *
1346      * Note that `value` may be zero.
1347      */
1348     event Transfer(address indexed from, address indexed to, uint256 value);
1349 
1350     /**
1351      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1352      * a call to {approve}. `value` is the new allowance.
1353      */
1354     event Approval(
1355         address indexed owner,
1356         address indexed spender,
1357         uint256 value
1358     );
1359 }
1360 
1361 pragma solidity ^0.8.0;
1362 
1363 /**
1364  * @dev Contract module which allows children to implement an emergency stop
1365  * mechanism that can be triggered by an authorized account.
1366  *
1367  * This module is used through inheritance. It will make available the
1368  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1369  * the functions of your contract. Note that they will not be pausable by
1370  * simply including this module, only once the modifiers are put in place.
1371  */
1372 abstract contract Pausable is Context {
1373     /**
1374      * @dev Emitted when the pause is triggered by `account`.
1375      */
1376     event Paused(address account);
1377 
1378     /**
1379      * @dev Emitted when the pause is lifted by `account`.
1380      */
1381     event Unpaused(address account);
1382 
1383     bool private _paused;
1384 
1385     /**
1386      * @dev Initializes the contract in unpaused state.
1387      */
1388     constructor() {
1389         _paused = false;
1390     }
1391 
1392     /**
1393      * @dev Returns true if the contract is paused, and false otherwise.
1394      */
1395     function paused() public view virtual returns (bool) {
1396         return _paused;
1397     }
1398 
1399     /**
1400      * @dev Modifier to make a function callable only when the contract is not paused.
1401      *
1402      * Requirements:
1403      *
1404      * - The contract must not be paused.
1405      */
1406     modifier whenNotPaused() {
1407         require(!paused(), "Pausable: paused");
1408         _;
1409     }
1410 
1411     /**
1412      * @dev Modifier to make a function callable only when the contract is paused.
1413      *
1414      * Requirements:
1415      *
1416      * - The contract must be paused.
1417      */
1418     modifier whenPaused() {
1419         require(paused(), "Pausable: not paused");
1420         _;
1421     }
1422 
1423     /**
1424      * @dev Triggers stopped state.
1425      *
1426      * Requirements:
1427      *
1428      * - The contract must not be paused.
1429      */
1430     function _pause() internal virtual whenNotPaused {
1431         _paused = true;
1432         emit Paused(_msgSender());
1433     }
1434 
1435     /**
1436      * @dev Returns to normal state.
1437      *
1438      * Requirements:
1439      *
1440      * - The contract must be paused.
1441      */
1442     function _unpause() internal virtual whenPaused {
1443         _paused = false;
1444         emit Unpaused(_msgSender());
1445     }
1446 }
1447 
1448 pragma solidity ^0.8.0;
1449 
1450 /**
1451  * @dev Contract module which provides a basic access control mechanism, where
1452  * there is an account (an owner) that can be granted exclusive access to
1453  * specific functions.
1454  *
1455  * By default, the owner account will be the one that deploys the contract. This
1456  * can later be changed with {transferOwnership}.
1457  *
1458  * This module is used through inheritance. It will make available the modifier
1459  * `onlyOwner`, which can be applied to your functions to restrict their use to
1460  * the owner.
1461  */
1462 abstract contract Ownable is Context {
1463     address private _owner;
1464 
1465     event OwnershipTransferred(
1466         address indexed previousOwner,
1467         address indexed newOwner
1468     );
1469 
1470     /**
1471      * @dev Initializes the contract setting the deployer as the initial owner.
1472      */
1473     constructor() {
1474         _transferOwnership(_msgSender());
1475     }
1476 
1477     /**
1478      * @dev Returns the address of the current owner.
1479      */
1480     function owner() public view virtual returns (address) {
1481         return _owner;
1482     }
1483 
1484     /**
1485      * @dev Throws if called by any account other than the owner.
1486      */
1487     modifier onlyOwner() {
1488         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1489         _;
1490     }
1491 
1492     /**
1493      * @dev Leaves the contract without owner. It will not be possible to call
1494      * `onlyOwner` functions anymore. Can only be called by the current owner.
1495      *
1496      * NOTE: Renouncing ownership will leave the contract without an owner,
1497      * thereby removing any functionality that is only available to the owner.
1498      */
1499     function renounceOwnership() public virtual onlyOwner {
1500         _transferOwnership(address(0));
1501     }
1502 
1503     /**
1504      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1505      * Can only be called by the current owner.
1506      */
1507     function transferOwnership(address newOwner) public virtual onlyOwner {
1508         require(
1509             newOwner != address(0),
1510             "Ownable: new owner is the zero address"
1511         );
1512         _transferOwnership(newOwner);
1513     }
1514 
1515     /**
1516      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1517      * Internal function without access restriction.
1518      */
1519     function _transferOwnership(address newOwner) internal virtual {
1520         address oldOwner = _owner;
1521         _owner = newOwner;
1522         emit OwnershipTransferred(oldOwner, newOwner);
1523     }
1524 }
1525 
1526 pragma solidity ^0.8.0;
1527 
1528 /**
1529  * @dev Standard math utilities missing in the Solidity language.
1530  */
1531 library Math {
1532     /**
1533      * @dev Returns the largest of two numbers.
1534      */
1535     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1536         return a >= b ? a : b;
1537     }
1538 
1539     /**
1540      * @dev Returns the smallest of two numbers.
1541      */
1542     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1543         return a < b ? a : b;
1544     }
1545 
1546     /**
1547      * @dev Returns the average of two numbers. The result is rounded towards
1548      * zero.
1549      */
1550     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1551         // (a + b) / 2 can overflow.
1552         return (a & b) + (a ^ b) / 2;
1553     }
1554 
1555     /**
1556      * @dev Returns the ceiling of the division of two numbers.
1557      *
1558      * This differs from standard division with `/` in that it rounds up instead
1559      * of rounding down.
1560      */
1561     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1562         // (a + b - 1) / b can overflow on addition, so we distribute.
1563         return a / b + (a % b == 0 ? 0 : 1);
1564     }
1565 }
1566 
1567 pragma solidity ^0.8.0;
1568 
1569 /**
1570  * @dev Contract module that helps prevent reentrant calls to a function.
1571  *
1572  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1573  * available, which can be applied to functions to make sure there are no nested
1574  * (reentrant) calls to them.
1575  *
1576  * Note that because there is a single `nonReentrant` guard, functions marked as
1577  * `nonReentrant` may not call one another. This can be worked around by making
1578  * those functions `private`, and then adding `external` `nonReentrant` entry
1579  * points to them.
1580  *
1581  * TIP: If you would like to learn more about reentrancy and alternative ways
1582  * to protect against it, check out our blog post
1583  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1584  */
1585 abstract contract ReentrancyGuard {
1586     // Booleans are more expensive than uint256 or any type that takes up a full
1587     // word because each write operation emits an extra SLOAD to first read the
1588     // slot's contents, replace the bits taken up by the boolean, and then write
1589     // back. This is the compiler's defense against contract upgrades and
1590     // pointer aliasing, and it cannot be disabled.
1591 
1592     // The values being non-zero value makes deployment a bit more expensive,
1593     // but in exchange the refund on every call to nonReentrant will be lower in
1594     // amount. Since refunds are capped to a percentage of the total
1595     // transaction's gas, it is best to keep them low in cases like this one, to
1596     // increase the likelihood of the full refund coming into effect.
1597     uint256 private constant _NOT_ENTERED = 1;
1598     uint256 private constant _ENTERED = 2;
1599 
1600     uint256 private _status;
1601 
1602     constructor() {
1603         _status = _NOT_ENTERED;
1604     }
1605 
1606     /**
1607      * @dev Prevents a contract from calling itself, directly or indirectly.
1608      * Calling a `nonReentrant` function from another `nonReentrant`
1609      * function is not supported. It is possible to prevent this from happening
1610      * by making the `nonReentrant` function external, and make it call a
1611      * `private` function that does the actual work.
1612      */
1613     modifier nonReentrant() {
1614         // On the first call to nonReentrant, _notEntered will be true
1615         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1616 
1617         // Any calls to nonReentrant after this point will fail
1618         _status = _ENTERED;
1619 
1620         _;
1621 
1622         // By storing the original value once again, a refund is triggered (see
1623         // https://eips.ethereum.org/EIPS/eip-2200)
1624         _status = _NOT_ENTERED;
1625     }
1626 }
1627 
1628 pragma solidity ^0.8.0;
1629 
1630 /**
1631  * @dev Library for managing
1632  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1633  * types.
1634  *
1635  * Sets have the following properties:
1636  *
1637  * - Elements are added, removed, and checked for existence in constant time
1638  * (O(1)).
1639  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1640  *
1641  * ```
1642  * contract Example {
1643  *     // Add the library methods
1644  *     using EnumerableSet for EnumerableSet.AddressSet;
1645  *
1646  *     // Declare a set state variable
1647  *     EnumerableSet.AddressSet private mySet;
1648  * }
1649  * ```
1650  *
1651  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1652  * and `uint256` (`UintSet`) are supported.
1653  */
1654 library EnumerableSet {
1655     // To implement this library for multiple types with as little code
1656     // repetition as possible, we write it in terms of a generic Set type with
1657     // bytes32 values.
1658     // The Set implementation uses private functions, and user-facing
1659     // implementations (such as AddressSet) are just wrappers around the
1660     // underlying Set.
1661     // This means that we can only create new EnumerableSets for types that fit
1662     // in bytes32.
1663 
1664     struct Set {
1665         // Storage of set values
1666         bytes32[] _values;
1667         // Position of the value in the `values` array, plus 1 because index 0
1668         // means a value is not in the set.
1669         mapping(bytes32 => uint256) _indexes;
1670     }
1671 
1672     /**
1673      * @dev Add a value to a set. O(1).
1674      *
1675      * Returns true if the value was added to the set, that is if it was not
1676      * already present.
1677      */
1678     function _add(Set storage set, bytes32 value) private returns (bool) {
1679         if (!_contains(set, value)) {
1680             set._values.push(value);
1681             // The value is stored at length-1, but we add 1 to all indexes
1682             // and use 0 as a sentinel value
1683             set._indexes[value] = set._values.length;
1684             return true;
1685         } else {
1686             return false;
1687         }
1688     }
1689 
1690     /**
1691      * @dev Removes a value from a set. O(1).
1692      *
1693      * Returns true if the value was removed from the set, that is if it was
1694      * present.
1695      */
1696     function _remove(Set storage set, bytes32 value) private returns (bool) {
1697         // We read and store the value's index to prevent multiple reads from the same storage slot
1698         uint256 valueIndex = set._indexes[value];
1699 
1700         if (valueIndex != 0) {
1701             // Equivalent to contains(set, value)
1702             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1703             // the array, and then remove the last element (sometimes called as 'swap and pop').
1704             // This modifies the order of the array, as noted in {at}.
1705 
1706             uint256 toDeleteIndex = valueIndex - 1;
1707             uint256 lastIndex = set._values.length - 1;
1708 
1709             if (lastIndex != toDeleteIndex) {
1710                 bytes32 lastvalue = set._values[lastIndex];
1711 
1712                 // Move the last value to the index where the value to delete is
1713                 set._values[toDeleteIndex] = lastvalue;
1714                 // Update the index for the moved value
1715                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
1716             }
1717 
1718             // Delete the slot where the moved value was stored
1719             set._values.pop();
1720 
1721             // Delete the index for the deleted slot
1722             delete set._indexes[value];
1723 
1724             return true;
1725         } else {
1726             return false;
1727         }
1728     }
1729 
1730     /**
1731      * @dev Returns true if the value is in the set. O(1).
1732      */
1733     function _contains(Set storage set, bytes32 value)
1734         private
1735         view
1736         returns (bool)
1737     {
1738         return set._indexes[value] != 0;
1739     }
1740 
1741     /**
1742      * @dev Returns the number of values on the set. O(1).
1743      */
1744     function _length(Set storage set) private view returns (uint256) {
1745         return set._values.length;
1746     }
1747 
1748     /**
1749      * @dev Returns the value stored at position `index` in the set. O(1).
1750      *
1751      * Note that there are no guarantees on the ordering of values inside the
1752      * array, and it may change when more values are added or removed.
1753      *
1754      * Requirements:
1755      *
1756      * - `index` must be strictly less than {length}.
1757      */
1758     function _at(Set storage set, uint256 index)
1759         private
1760         view
1761         returns (bytes32)
1762     {
1763         return set._values[index];
1764     }
1765 
1766     /**
1767      * @dev Return the entire set in an array
1768      *
1769      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1770      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1771      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1772      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1773      */
1774     function _values(Set storage set) private view returns (bytes32[] memory) {
1775         return set._values;
1776     }
1777 
1778     // Bytes32Set
1779 
1780     struct Bytes32Set {
1781         Set _inner;
1782     }
1783 
1784     /**
1785      * @dev Add a value to a set. O(1).
1786      *
1787      * Returns true if the value was added to the set, that is if it was not
1788      * already present.
1789      */
1790     function add(Bytes32Set storage set, bytes32 value)
1791         internal
1792         returns (bool)
1793     {
1794         return _add(set._inner, value);
1795     }
1796 
1797     /**
1798      * @dev Removes a value from a set. O(1).
1799      *
1800      * Returns true if the value was removed from the set, that is if it was
1801      * present.
1802      */
1803     function remove(Bytes32Set storage set, bytes32 value)
1804         internal
1805         returns (bool)
1806     {
1807         return _remove(set._inner, value);
1808     }
1809 
1810     /**
1811      * @dev Returns true if the value is in the set. O(1).
1812      */
1813     function contains(Bytes32Set storage set, bytes32 value)
1814         internal
1815         view
1816         returns (bool)
1817     {
1818         return _contains(set._inner, value);
1819     }
1820 
1821     /**
1822      * @dev Returns the number of values in the set. O(1).
1823      */
1824     function length(Bytes32Set storage set) internal view returns (uint256) {
1825         return _length(set._inner);
1826     }
1827 
1828     /**
1829      * @dev Returns the value stored at position `index` in the set. O(1).
1830      *
1831      * Note that there are no guarantees on the ordering of values inside the
1832      * array, and it may change when more values are added or removed.
1833      *
1834      * Requirements:
1835      *
1836      * - `index` must be strictly less than {length}.
1837      */
1838     function at(Bytes32Set storage set, uint256 index)
1839         internal
1840         view
1841         returns (bytes32)
1842     {
1843         return _at(set._inner, index);
1844     }
1845 
1846     /**
1847      * @dev Return the entire set in an array
1848      *
1849      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1850      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1851      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1852      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1853      */
1854     function values(Bytes32Set storage set)
1855         internal
1856         view
1857         returns (bytes32[] memory)
1858     {
1859         return _values(set._inner);
1860     }
1861 
1862     // AddressSet
1863 
1864     struct AddressSet {
1865         Set _inner;
1866     }
1867 
1868     /**
1869      * @dev Add a value to a set. O(1).
1870      *
1871      * Returns true if the value was added to the set, that is if it was not
1872      * already present.
1873      */
1874     function add(AddressSet storage set, address value)
1875         internal
1876         returns (bool)
1877     {
1878         return _add(set._inner, bytes32(uint256(uint160(value))));
1879     }
1880 
1881     /**
1882      * @dev Removes a value from a set. O(1).
1883      *
1884      * Returns true if the value was removed from the set, that is if it was
1885      * present.
1886      */
1887     function remove(AddressSet storage set, address value)
1888         internal
1889         returns (bool)
1890     {
1891         return _remove(set._inner, bytes32(uint256(uint160(value))));
1892     }
1893 
1894     /**
1895      * @dev Returns true if the value is in the set. O(1).
1896      */
1897     function contains(AddressSet storage set, address value)
1898         internal
1899         view
1900         returns (bool)
1901     {
1902         return _contains(set._inner, bytes32(uint256(uint160(value))));
1903     }
1904 
1905     /**
1906      * @dev Returns the number of values in the set. O(1).
1907      */
1908     function length(AddressSet storage set) internal view returns (uint256) {
1909         return _length(set._inner);
1910     }
1911 
1912     /**
1913      * @dev Returns the value stored at position `index` in the set. O(1).
1914      *
1915      * Note that there are no guarantees on the ordering of values inside the
1916      * array, and it may change when more values are added or removed.
1917      *
1918      * Requirements:
1919      *
1920      * - `index` must be strictly less than {length}.
1921      */
1922     function at(AddressSet storage set, uint256 index)
1923         internal
1924         view
1925         returns (address)
1926     {
1927         return address(uint160(uint256(_at(set._inner, index))));
1928     }
1929 
1930     /**
1931      * @dev Return the entire set in an array
1932      *
1933      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1934      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1935      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1936      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1937      */
1938     function values(AddressSet storage set)
1939         internal
1940         view
1941         returns (address[] memory)
1942     {
1943         bytes32[] memory store = _values(set._inner);
1944         address[] memory result;
1945 
1946         assembly {
1947             result := store
1948         }
1949 
1950         return result;
1951     }
1952 
1953     // UintSet
1954 
1955     struct UintSet {
1956         Set _inner;
1957     }
1958 
1959     /**
1960      * @dev Add a value to a set. O(1).
1961      *
1962      * Returns true if the value was added to the set, that is if it was not
1963      * already present.
1964      */
1965     function add(UintSet storage set, uint256 value) internal returns (bool) {
1966         return _add(set._inner, bytes32(value));
1967     }
1968 
1969     /**
1970      * @dev Removes a value from a set. O(1).
1971      *
1972      * Returns true if the value was removed from the set, that is if it was
1973      * present.
1974      */
1975     function remove(UintSet storage set, uint256 value)
1976         internal
1977         returns (bool)
1978     {
1979         return _remove(set._inner, bytes32(value));
1980     }
1981 
1982     /**
1983      * @dev Returns true if the value is in the set. O(1).
1984      */
1985     function contains(UintSet storage set, uint256 value)
1986         internal
1987         view
1988         returns (bool)
1989     {
1990         return _contains(set._inner, bytes32(value));
1991     }
1992 
1993     /**
1994      * @dev Returns the number of values on the set. O(1).
1995      */
1996     function length(UintSet storage set) internal view returns (uint256) {
1997         return _length(set._inner);
1998     }
1999 
2000     /**
2001      * @dev Returns the value stored at position `index` in the set. O(1).
2002      *
2003      * Note that there are no guarantees on the ordering of values inside the
2004      * array, and it may change when more values are added or removed.
2005      *
2006      * Requirements:
2007      *
2008      * - `index` must be strictly less than {length}.
2009      */
2010     function at(UintSet storage set, uint256 index)
2011         internal
2012         view
2013         returns (uint256)
2014     {
2015         return uint256(_at(set._inner, index));
2016     }
2017 
2018     /**
2019      * @dev Return the entire set in an array
2020      *
2021      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2022      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2023      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2024      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2025      */
2026     function values(UintSet storage set)
2027         internal
2028         view
2029         returns (uint256[] memory)
2030     {
2031         bytes32[] memory store = _values(set._inner);
2032         uint256[] memory result;
2033 
2034         assembly {
2035             result := store
2036         }
2037 
2038         return result;
2039     }
2040 }
2041 
2042 pragma solidity ^0.8.0;
2043 
2044 interface liquidForgeStaking {
2045     // get the forgeblocks for the forged liquid key
2046     function _liquidKeyForgeBlocks(address) external view returns (uint256);
2047 
2048     // Retrieve the Token IDs of the Forged Liquid Key address
2049     function forgedKeyOwnerAddress(address account)
2050         external
2051         view
2052         returns (uint256[] memory);
2053 }
2054 
2055 contract TypicalTigersForge is Ownable, ReentrancyGuard, Pausable {
2056     using EnumerableSet for EnumerableSet.UintSet;
2057 
2058     mapping(uint256 => uint256) public nftForgeBlocks;
2059     mapping(address => EnumerableSet.UintSet) private nftForges; // private
2060     mapping(uint256 => address) public _nftTokenForges;
2061 
2062     // NFT Collection, Forge, and METL token addresses
2063     address public nftAddress = 0x813b5c4aE6b188F4581aa1dfdB7f4Aba44AA578B; // AASC
2064     address public forgeAddress = 0x346e31ddE260c6BEEA84186ad99878C1D8C7D90F; // Liquid Key Forge
2065     address public metlTokenAddress = 0xFcbE615dEf610E806BB64427574A2c5c1fB55510; // METL Token
2066 
2067     // how many blocks before a claim (30 days) and when do we expire?
2068     uint256 public expiration = 1000000000;
2069     uint256 public minBlockToClaim = 180204;
2070 
2071     // rate governs how often you receive your token
2072     uint256 public nftRate = 1730416400242;
2073 
2074     function pause() public onlyOwner {
2075         _pause();
2076     }
2077 
2078     function unpause() public onlyOwner {
2079         _unpause();
2080     }
2081 
2082     // Set this to a expiration block to disable the ability to continue accruing tokens past that block number.
2083     // which is calculated as current block plus the parameters
2084     //
2085     // Set a multiplier for how many tokens to earn each time a block passes
2086     // and the min number of blocks needed to pass to claim rewards
2087     function setRates(
2088         uint256 _nftRate,
2089         uint256 _minBlockToClaim,
2090         uint256 _expiration
2091     ) public onlyOwner {
2092         nftRate = _nftRate;
2093         minBlockToClaim = _minBlockToClaim;
2094         expiration = block.number + _expiration;
2095     }
2096 
2097     // Set addresses
2098     function setAddresses(
2099         address _nftAddress, 
2100         address _forgeAddress, 
2101         address _metlTokenAddress
2102     ) public onlyOwner {
2103         nftAddress = _nftAddress;
2104         forgeAddress = _forgeAddress;
2105         metlTokenAddress = _metlTokenAddress;
2106     }
2107 
2108     // Reward Claimable information
2109     function rewardClaimable(uint256 tokenId) public view returns (bool) {
2110         uint256 blockCur = Math.min(block.number, expiration);
2111         if (nftForgeBlocks[tokenId] > 0) {
2112             return (blockCur - nftForgeBlocks[tokenId] > minBlockToClaim);
2113         }
2114         return false;
2115     }
2116 
2117     // reward amount by address/tokenIds[]
2118     function CalculateEarnedMETL(address account, uint256 tokenId)
2119         public
2120         view
2121         returns (uint256)
2122     {
2123         require(
2124             Math.min(block.number, expiration) > nftForgeBlocks[tokenId],
2125             "Invalid blocks"
2126         );
2127         return
2128             nftRate *
2129             (nftForges[msg.sender].contains(tokenId) ? 1 : 0) *
2130             (Math.min(block.number, expiration) -
2131                 Math.max(
2132                     liquidForgeStaking(forgeAddress)._liquidKeyForgeBlocks(
2133                         account
2134                     ),
2135                     nftForgeBlocks[tokenId]
2136                 ));
2137     }
2138 
2139     // claim rewards (earned METL)
2140     function ClaimEarnedMETL(uint256[] calldata tokenIds) public whenNotPaused {
2141         uint256 reward;
2142         uint256 blockCur = Math.min(block.number, expiration);
2143 
2144         require(
2145             liquidForgeStaking(forgeAddress)
2146                 .forgedKeyOwnerAddress(msg.sender)
2147                 .length > 0,
2148             "No Liquid Key Forged"
2149         );
2150 
2151         for (uint256 i; i < tokenIds.length; i++) {
2152             require(
2153                 nftForges[msg.sender].contains(tokenIds[i]),
2154                 "Staking: token not forged"
2155             );
2156             require(blockCur - nftForgeBlocks[tokenIds[i]] > minBlockToClaim);
2157         }
2158 
2159         for (uint256 i; i < tokenIds.length; i++) {
2160             reward += CalculateEarnedMETL(msg.sender, tokenIds[i]);
2161             nftForgeBlocks[tokenIds[i]] = blockCur;
2162         }
2163 
2164         if (reward > 0) {
2165             IERC20(metlTokenAddress).transfer(msg.sender, reward);
2166         }
2167     }
2168 
2169     // Forge NFT
2170     function ForgeNFT(uint256[] calldata tokenIds)
2171         external
2172         whenNotPaused
2173     {
2174         uint256 blockCur = block.number;
2175         require(msg.sender != nftAddress, "Invalid NFT contract address");
2176 
2177         for (uint256 i; i < tokenIds.length; i++) {
2178             IERC721(nftAddress).safeTransferFrom(
2179                 msg.sender,
2180                 address(this),
2181                 tokenIds[i],
2182                 "Transfer from Member to Forge"
2183             );
2184             nftForges[msg.sender].add(tokenIds[i]);
2185             nftForgeBlocks[tokenIds[i]] = blockCur;
2186             // write the entry for the ETH address
2187             _nftTokenForges[tokenIds[i]] = msg.sender;
2188         }
2189     }
2190 
2191     // withdrawal function
2192     function WithdrawNFT(uint256[] calldata tokenIds)
2193         external
2194         whenNotPaused
2195         nonReentrant
2196     {
2197         for (uint256 i; i < tokenIds.length; i++) {
2198             require(
2199                 nftForges[msg.sender].contains(tokenIds[i]),
2200                 "Staking: token not forged"
2201             );
2202 
2203             nftForges[msg.sender].remove(tokenIds[i]);
2204             _nftTokenForges[tokenIds[i]] = 0x0000000000000000000000000000000000000000;
2205 
2206             IERC721(nftAddress).safeTransferFrom(
2207                 address(this),
2208                 msg.sender,
2209                 tokenIds[i],
2210                 "Not withdrawn: Transfer failed"
2211             );
2212         }
2213     }
2214 
2215     // withdraw earned METL
2216     function WithdrawEarnedMETL() external onlyOwner {
2217         uint256 tokenSupply = IERC20(metlTokenAddress).balanceOf(address(this));
2218         IERC20(metlTokenAddress).transfer(msg.sender, tokenSupply);
2219     }
2220     
2221     // ERC721 token receiver for transferred NFT to Forge
2222     function onERC721Received(
2223         address,
2224         address,
2225         uint256,
2226         bytes calldata
2227     ) external pure  returns (bytes4) {
2228         return IERC721Receiver.onERC721Received.selector;
2229     }
2230 }