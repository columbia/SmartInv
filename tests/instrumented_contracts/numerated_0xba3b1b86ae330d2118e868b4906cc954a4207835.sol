1 // SPDX-License-Identifier: MIT
2 /*
3    .____    .__             .__    .___   ___________
4    |    |   |__| ________ __|__| __| _/   \_   _____/__________  ____   ____
5    |    |   |  |/ ____/  |  \  |/ __ |     |    __)/  _ \_  __ \/ ___\_/ __ \
6    |    |___|  < <_|  |  |  /  / /_/ |     |     \(  <_> )  | \/ /_/  >  ___/
7    |_______ \__|\__   |____/|__\____ |     \___  / \____/|__|  \___  / \___  >
8            \/      |__|             \/         \/             /_____/      \/
9 
10     * Liquid Forge Contract for ApeLiquid.io | November 2022
11     *
12     * ApeLiquid Membership Forge: 10 METL/month for 8 Months
13     * Plus Azuki Royalties (paid in METL) across all Memberships
14 */
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @dev Interface of the ERC165 standard, as defined in the
20  * https://eips.ethereum.org/EIPS/eip-165[EIP].
21  *
22  * Implementers can declare support of contract interfaces, which can then be
23  * queried by others ({ERC165Checker}).
24  *
25  * For an implementation, see {ERC165}.
26  */
27 interface IERC165 {
28     /**
29      * @dev Returns true if this contract implements the interface defined by
30      * `interfaceId`. See the corresponding
31      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
32      * to learn more about how these ids are created.
33      *
34      * This function call must use less than 30 000 gas.
35      */
36     function supportsInterface(bytes4 interfaceId) external view returns (bool);
37 }
38 
39 pragma solidity ^0.8.0;
40 
41 /**
42  * @dev Implementation of the {IERC165} interface.
43  *
44  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
45  * for the additional interface id that will be supported. For example:
46  *
47  * ```solidity
48  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
49  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
50  * }
51  * ```
52  *
53  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
54  */
55 abstract contract ERC165 is IERC165 {
56     /**
57      * @dev See {IERC165-supportsInterface}.
58      */
59     function supportsInterface(bytes4 interfaceId)
60         public
61         view
62         virtual
63         override
64         returns (bool)
65     {
66         return interfaceId == type(IERC165).interfaceId;
67     }
68 }
69 
70 pragma solidity ^0.8.0;
71 
72 /**
73  * @dev String operations.
74  */
75 library Strings {
76     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
77 
78     /**
79      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
80      */
81     function toString(uint256 value) internal pure returns (string memory) {
82         // Inspired by OraclizeAPI's implementation - MIT licence
83         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
84 
85         if (value == 0) {
86             return "0";
87         }
88         uint256 temp = value;
89         uint256 digits;
90         while (temp != 0) {
91             digits++;
92             temp /= 10;
93         }
94         bytes memory buffer = new bytes(digits);
95         while (value != 0) {
96             digits -= 1;
97             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
98             value /= 10;
99         }
100         return string(buffer);
101     }
102 
103     /**
104      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
105      */
106     function toHexString(uint256 value) internal pure returns (string memory) {
107         if (value == 0) {
108             return "0x00";
109         }
110         uint256 temp = value;
111         uint256 length = 0;
112         while (temp != 0) {
113             length++;
114             temp >>= 8;
115         }
116         return toHexString(value, length);
117     }
118 
119     /**
120      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
121      */
122     function toHexString(uint256 value, uint256 length)
123         internal
124         pure
125         returns (string memory)
126     {
127         bytes memory buffer = new bytes(2 * length + 2);
128         buffer[0] = "0";
129         buffer[1] = "x";
130         for (uint256 i = 2 * length + 1; i > 1; --i) {
131             buffer[i] = _HEX_SYMBOLS[value & 0xf];
132             value >>= 4;
133         }
134         require(value == 0, "Strings: hex length insufficient");
135         return string(buffer);
136     }
137 }
138 
139 pragma solidity ^0.8.0;
140 
141 /**
142  * @dev Provides information about the current execution context, including the
143  * sender of the transaction and its data. While these are generally available
144  * via msg.sender and msg.data, they should not be accessed in such a direct
145  * manner, since when dealing with meta-transactions the account sending and
146  * paying for execution may not be the actual sender (as far as an application
147  * is concerned).
148  *
149  * This contract is only required for intermediate, library-like contracts.
150  */
151 abstract contract Context {
152     function _msgSender() internal view virtual returns (address) {
153         return msg.sender;
154     }
155 
156     function _msgData() internal view virtual returns (bytes calldata) {
157         return msg.data;
158     }
159 }
160 
161 pragma solidity ^0.8.0;
162 
163 /**
164  * @dev Collection of functions related to the address type
165  */
166 library Address {
167     /**
168      * @dev Returns true if `account` is a contract.
169      *
170      * [IMPORTANT]
171      * ====
172      * It is unsafe to assume that an address for which this function returns
173      * false is an externally-owned account (EOA) and not a contract.
174      *
175      * Among others, `isContract` will return false for the following
176      * types of addresses:
177      *
178      *  - an externally-owned account
179      *  - a contract in construction
180      *  - an address where a contract will be created
181      *  - an address where a contract lived, but was destroyed
182      * ====
183      */
184     function isContract(address account) internal view returns (bool) {
185         // This method relies on extcodesize, which returns 0 for contracts in
186         // construction, since the code is only stored at the end of the
187         // constructor execution.
188 
189         uint256 size;
190         assembly {
191             size := extcodesize(account)
192         }
193         return size > 0;
194     }
195 
196     /**
197      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
198      * `recipient`, forwarding all available gas and reverting on errors.
199      *
200      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
201      * of certain opcodes, possibly making contracts go over the 2300 gas limit
202      * imposed by `transfer`, making them unable to receive funds via
203      * `transfer`. {sendValue} removes this limitation.
204      *
205      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
206      *
207      * IMPORTANT: because control is transferred to `recipient`, care must be
208      * taken to not create reentrancy vulnerabilities. Consider using
209      * {ReentrancyGuard} or the
210      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
211      */
212     function sendValue(address payable recipient, uint256 amount) internal {
213         require(
214             address(this).balance >= amount,
215             "Address: insufficient balance"
216         );
217 
218         (bool success, ) = recipient.call{value: amount}("");
219         require(
220             success,
221             "Address: unable to send value, recipient may have reverted"
222         );
223     }
224 
225     /**
226      * @dev Performs a Solidity function call using a low level `call`. A
227      * plain `call` is an unsafe replacement for a function call: use this
228      * function instead.
229      *
230      * If `target` reverts with a revert reason, it is bubbled up by this
231      * function (like regular Solidity function calls).
232      *
233      * Returns the raw returned data. To convert to the expected return value,
234      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
235      *
236      * Requirements:
237      *
238      * - `target` must be a contract.
239      * - calling `target` with `data` must not revert.
240      *
241      * _Available since v3.1._
242      */
243     function functionCall(address target, bytes memory data)
244         internal
245         returns (bytes memory)
246     {
247         return functionCall(target, data, "Address: low-level call failed");
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
252      * `errorMessage` as a fallback revert reason when `target` reverts.
253      *
254      * _Available since v3.1._
255      */
256     function functionCall(
257         address target,
258         bytes memory data,
259         string memory errorMessage
260     ) internal returns (bytes memory) {
261         return functionCallWithValue(target, data, 0, errorMessage);
262     }
263 
264     /**
265      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
266      * but also transferring `value` wei to `target`.
267      *
268      * Requirements:
269      *
270      * - the calling contract must have an ETH balance of at least `value`.
271      * - the called Solidity function must be `payable`.
272      *
273      * _Available since v3.1._
274      */
275     function functionCallWithValue(
276         address target,
277         bytes memory data,
278         uint256 value
279     ) internal returns (bytes memory) {
280         return
281             functionCallWithValue(
282                 target,
283                 data,
284                 value,
285                 "Address: low-level call with value failed"
286             );
287     }
288 
289     /**
290      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
291      * with `errorMessage` as a fallback revert reason when `target` reverts.
292      *
293      * _Available since v3.1._
294      */
295     function functionCallWithValue(
296         address target,
297         bytes memory data,
298         uint256 value,
299         string memory errorMessage
300     ) internal returns (bytes memory) {
301         require(
302             address(this).balance >= value,
303             "Address: insufficient balance for call"
304         );
305         require(isContract(target), "Address: call to non-contract");
306 
307         (bool success, bytes memory returndata) = target.call{value: value}(
308             data
309         );
310         return verifyCallResult(success, returndata, errorMessage);
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
315      * but performing a static call.
316      *
317      * _Available since v3.3._
318      */
319     function functionStaticCall(address target, bytes memory data)
320         internal
321         view
322         returns (bytes memory)
323     {
324         return
325             functionStaticCall(
326                 target,
327                 data,
328                 "Address: low-level static call failed"
329             );
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
334      * but performing a static call.
335      *
336      * _Available since v3.3._
337      */
338     function functionStaticCall(
339         address target,
340         bytes memory data,
341         string memory errorMessage
342     ) internal view returns (bytes memory) {
343         require(isContract(target), "Address: static call to non-contract");
344 
345         (bool success, bytes memory returndata) = target.staticcall(data);
346         return verifyCallResult(success, returndata, errorMessage);
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
351      * but performing a delegate call.
352      *
353      * _Available since v3.4._
354      */
355     function functionDelegateCall(address target, bytes memory data)
356         internal
357         returns (bytes memory)
358     {
359         return
360             functionDelegateCall(
361                 target,
362                 data,
363                 "Address: low-level delegate call failed"
364             );
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
369      * but performing a delegate call.
370      *
371      * _Available since v3.4._
372      */
373     function functionDelegateCall(
374         address target,
375         bytes memory data,
376         string memory errorMessage
377     ) internal returns (bytes memory) {
378         require(isContract(target), "Address: delegate call to non-contract");
379 
380         (bool success, bytes memory returndata) = target.delegatecall(data);
381         return verifyCallResult(success, returndata, errorMessage);
382     }
383 
384     /**
385      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
386      * revert reason using the provided one.
387      *
388      * _Available since v4.3._
389      */
390     function verifyCallResult(
391         bool success,
392         bytes memory returndata,
393         string memory errorMessage
394     ) internal pure returns (bytes memory) {
395         if (success) {
396             return returndata;
397         } else {
398             // Look for revert reason and bubble it up if present
399             if (returndata.length > 0) {
400                 // The easiest way to bubble the revert reason is using memory via assembly
401 
402                 assembly {
403                     let returndata_size := mload(returndata)
404                     revert(add(32, returndata), returndata_size)
405                 }
406             } else {
407                 revert(errorMessage);
408             }
409         }
410     }
411 }
412 
413 pragma solidity ^0.8.0;
414 
415 /**
416  * @title ERC721 token receiver interface
417  * @dev Interface for any contract that wants to support safeTransfers
418  * from ERC721 asset contracts.
419  */
420 interface IERC721Receiver {
421     /**
422      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
423      * by `operator` from `from`, this function is called.
424      *
425      * It must return its Solidity selector to confirm the token transfer.
426      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
427      *
428      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
429      */
430     function onERC721Received(
431         address operator,
432         address from,
433         uint256 tokenId,
434         bytes calldata data
435     ) external returns (bytes4);
436 }
437 
438 pragma solidity ^0.8.0;
439 
440 pragma solidity ^0.8.0;
441 
442 /**
443  * @dev Required interface of an ERC721 compliant contract.
444  */
445 interface IERC721 is IERC165 {
446     /**
447      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
448      */
449     event Transfer(
450         address indexed from,
451         address indexed to,
452         uint256 indexed tokenId
453     );
454 
455     /**
456      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
457      */
458     event Approval(
459         address indexed owner,
460         address indexed approved,
461         uint256 indexed tokenId
462     );
463 
464     /**
465      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
466      */
467     event ApprovalForAll(
468         address indexed owner,
469         address indexed operator,
470         bool approved
471     );
472 
473     /**
474      * @dev Returns the number of tokens in ``owner``'s account.
475      */
476     function balanceOf(address owner) external view returns (uint256 balance);
477 
478     /**
479      * @dev Returns the owner of the `tokenId` token.
480      *
481      * Requirements:
482      *
483      * - `tokenId` must exist.
484      */
485     function ownerOf(uint256 tokenId) external view returns (address owner);
486 
487     /**
488      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
489      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
490      *
491      * Requirements:
492      *
493      * - `from` cannot be the zero address.
494      * - `to` cannot be the zero address.
495      * - `tokenId` token must exist and be owned by `from`.
496      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
497      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
498      *
499      * Emits a {Transfer} event.
500      */
501     function safeTransferFrom(
502         address from,
503         address to,
504         uint256 tokenId
505     ) external;
506 
507     /**
508      * @dev Transfers `tokenId` token from `from` to `to`.
509      *
510      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
511      *
512      * Requirements:
513      *
514      * - `from` cannot be the zero address.
515      * - `to` cannot be the zero address.
516      * - `tokenId` token must be owned by `from`.
517      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
518      *
519      * Emits a {Transfer} event.
520      */
521     function transferFrom(
522         address from,
523         address to,
524         uint256 tokenId
525     ) external;
526 
527     /**
528      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
529      * The approval is cleared when the token is transferred.
530      *
531      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
532      *
533      * Requirements:
534      *
535      * - The caller must own the token or be an approved operator.
536      * - `tokenId` must exist.
537      *
538      * Emits an {Approval} event.
539      */
540     function approve(address to, uint256 tokenId) external;
541 
542     /**
543      * @dev Returns the account approved for `tokenId` token.
544      *
545      * Requirements:
546      *
547      * - `tokenId` must exist.
548      */
549     function getApproved(uint256 tokenId)
550         external
551         view
552         returns (address operator);
553 
554     /**
555      * @dev Approve or remove `operator` as an operator for the caller.
556      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
557      *
558      * Requirements:
559      *
560      * - The `operator` cannot be the caller.
561      *
562      * Emits an {ApprovalForAll} event.
563      */
564     function setApprovalForAll(address operator, bool _approved) external;
565 
566     /**
567      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
568      *
569      * See {setApprovalForAll}
570      */
571     function isApprovedForAll(address owner, address operator)
572         external
573         view
574         returns (bool);
575 
576     /**
577      * @dev Safely transfers `tokenId` token from `from` to `to`.
578      *
579      * Requirements:
580      *
581      * - `from` cannot be the zero address.
582      * - `to` cannot be the zero address.
583      * - `tokenId` token must exist and be owned by `from`.
584      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
585      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
586      *
587      * Emits a {Transfer} event.
588      */
589     function safeTransferFrom(
590         address from,
591         address to,
592         uint256 tokenId,
593         bytes calldata data
594     ) external;
595 }
596 
597 /**
598  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
599  * @dev See https://eips.ethereum.org/EIPS/eip-721
600  */
601 interface IERC721Enumerable is IERC721 {
602     /**
603      * @dev Returns the total amount of tokens stored by the contract.
604      */
605     function totalSupply() external view returns (uint256);
606 
607     /**
608      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
609      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
610      */
611     function tokenOfOwnerByIndex(address owner, uint256 index)
612         external
613         view
614         returns (uint256 tokenId);
615 
616     /**
617      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
618      * Use along with {totalSupply} to enumerate all tokens.
619      */
620     function tokenByIndex(uint256 index) external view returns (uint256);
621 }
622 
623 pragma solidity ^0.8.0;
624 
625 /**
626  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
627  * @dev See https://eips.ethereum.org/EIPS/eip-721
628  */
629 interface IERC721Metadata is IERC721 {
630     /**
631      * @dev Returns the token collection name.
632      */
633     function name() external view returns (string memory);
634 
635     /**
636      * @dev Returns the token collection symbol.
637      */
638     function symbol() external view returns (string memory);
639 
640     /**
641      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
642      */
643     function tokenURI(uint256 tokenId) external view returns (string memory);
644 }
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
773      * by default, can be overriden in child contracts.
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
942             getApproved(tokenId) == spender ||
943             isApprovedForAll(owner, spender));
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
998     }
999 
1000     /**
1001      * @dev Destroys `tokenId`.
1002      * The approval is cleared when the token is burned.
1003      *
1004      * Requirements:
1005      *
1006      * - `tokenId` must exist.
1007      *
1008      * Emits a {Transfer} event.
1009      */
1010     function _burn(uint256 tokenId) internal virtual {
1011         address owner = ERC721.ownerOf(tokenId);
1012 
1013         _beforeTokenTransfer(owner, address(0), tokenId);
1014 
1015         // Clear approvals
1016         _approve(address(0), tokenId);
1017 
1018         _balances[owner] -= 1;
1019         delete _owners[tokenId];
1020 
1021         emit Transfer(owner, address(0), tokenId);
1022     }
1023 
1024     /**
1025      * @dev Transfers `tokenId` from `from` to `to`.
1026      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1027      *
1028      * Requirements:
1029      *
1030      * - `to` cannot be the zero address.
1031      * - `tokenId` token must be owned by `from`.
1032      *
1033      * Emits a {Transfer} event.
1034      */
1035     function _transfer(
1036         address from,
1037         address to,
1038         uint256 tokenId
1039     ) internal virtual {
1040         require(
1041             ERC721.ownerOf(tokenId) == from,
1042             "ERC721: transfer of token that is not own"
1043         );
1044         require(to != address(0), "ERC721: transfer to the zero address");
1045 
1046         _beforeTokenTransfer(from, to, tokenId);
1047 
1048         // Clear approvals from the previous owner
1049         _approve(address(0), tokenId);
1050 
1051         _balances[from] -= 1;
1052         _balances[to] += 1;
1053         _owners[tokenId] = to;
1054 
1055         emit Transfer(from, to, tokenId);
1056     }
1057 
1058     /**
1059      * @dev Approve `to` to operate on `tokenId`
1060      *
1061      * Emits a {Approval} event.
1062      */
1063     function _approve(address to, uint256 tokenId) internal virtual {
1064         _tokenApprovals[tokenId] = to;
1065         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1066     }
1067 
1068     /**
1069      * @dev Approve `operator` to operate on all of `owner` tokens
1070      *
1071      * Emits a {ApprovalForAll} event.
1072      */
1073     function _setApprovalForAll(
1074         address owner,
1075         address operator,
1076         bool approved
1077     ) internal virtual {
1078         require(owner != operator, "ERC721: approve to caller");
1079         _operatorApprovals[owner][operator] = approved;
1080         emit ApprovalForAll(owner, operator, approved);
1081     }
1082 
1083     /**
1084      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1085      * The call is not executed if the target address is not a contract.
1086      *
1087      * @param from address representing the previous owner of the given token ID
1088      * @param to target address that will receive the tokens
1089      * @param tokenId uint256 ID of the token to be transferred
1090      * @param _data bytes optional data to send along with the call
1091      * @return bool whether the call correctly returned the expected magic value
1092      */
1093     function _checkOnERC721Received(
1094         address from,
1095         address to,
1096         uint256 tokenId,
1097         bytes memory _data
1098     ) private returns (bool) {
1099         if (to.isContract()) {
1100             try
1101                 IERC721Receiver(to).onERC721Received(
1102                     _msgSender(),
1103                     from,
1104                     tokenId,
1105                     _data
1106                 )
1107             returns (bytes4 retval) {
1108                 return retval == IERC721Receiver.onERC721Received.selector;
1109             } catch (bytes memory reason) {
1110                 if (reason.length == 0) {
1111                     revert(
1112                         "ERC721: transfer to non ERC721Receiver implementer"
1113                     );
1114                 } else {
1115                     assembly {
1116                         revert(add(32, reason), mload(reason))
1117                     }
1118                 }
1119             }
1120         } else {
1121             return true;
1122         }
1123     }
1124 
1125     /**
1126      * @dev Hook that is called before any token transfer. This includes minting
1127      * and burning.
1128      *
1129      * Calling conditions:
1130      *
1131      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1132      * transferred to `to`.
1133      * - When `from` is zero, `tokenId` will be minted for `to`.
1134      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1135      * - `from` and `to` are never both zero.
1136      *
1137      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1138      */
1139     function _beforeTokenTransfer(
1140         address from,
1141         address to,
1142         uint256 tokenId
1143     ) internal virtual {}
1144 }
1145 
1146 pragma solidity ^0.8.0;
1147 
1148 /**
1149  * @title SafeERC20
1150  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1151  * contract returns false). Tokens that return no value (and instead revert or
1152  * throw on failure) are also supported, non-reverting calls are assumed to be
1153  * successful.
1154  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1155  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1156  */
1157 library SafeERC20 {
1158     using Address for address;
1159 
1160     function safeTransfer(
1161         IERC20 token,
1162         address to,
1163         uint256 value
1164     ) internal {
1165         _callOptionalReturn(
1166             token,
1167             abi.encodeWithSelector(token.transfer.selector, to, value)
1168         );
1169     }
1170 
1171     function safeTransferFrom(
1172         IERC20 token,
1173         address from,
1174         address to,
1175         uint256 value
1176     ) internal {
1177         _callOptionalReturn(
1178             token,
1179             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
1180         );
1181     }
1182 
1183     /**
1184      * @dev Deprecated. This function has issues similar to the ones found in
1185      * {IERC20-approve}, and its usage is discouraged.
1186      *
1187      * Whenever possible, use {safeIncreaseAllowance} and
1188      * {safeDecreaseAllowance} instead.
1189      */
1190     function safeApprove(
1191         IERC20 token,
1192         address spender,
1193         uint256 value
1194     ) internal {
1195         // safeApprove should only be called when setting an initial allowance,
1196         // or when resetting it to zero. To increase and decrease it, use
1197         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1198         require(
1199             (value == 0) || (token.allowance(address(this), spender) == 0),
1200             "SafeERC20: approve from non-zero to non-zero allowance"
1201         );
1202         _callOptionalReturn(
1203             token,
1204             abi.encodeWithSelector(token.approve.selector, spender, value)
1205         );
1206     }
1207 
1208     function safeIncreaseAllowance(
1209         IERC20 token,
1210         address spender,
1211         uint256 value
1212     ) internal {
1213         uint256 newAllowance = token.allowance(address(this), spender) + value;
1214         _callOptionalReturn(
1215             token,
1216             abi.encodeWithSelector(
1217                 token.approve.selector,
1218                 spender,
1219                 newAllowance
1220             )
1221         );
1222     }
1223 
1224     function safeDecreaseAllowance(
1225         IERC20 token,
1226         address spender,
1227         uint256 value
1228     ) internal {
1229         unchecked {
1230             uint256 oldAllowance = token.allowance(address(this), spender);
1231             require(
1232                 oldAllowance >= value,
1233                 "SafeERC20: decreased allowance below zero"
1234             );
1235             uint256 newAllowance = oldAllowance - value;
1236             _callOptionalReturn(
1237                 token,
1238                 abi.encodeWithSelector(
1239                     token.approve.selector,
1240                     spender,
1241                     newAllowance
1242                 )
1243             );
1244         }
1245     }
1246 
1247     /**
1248      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract),
1249      * relaxing the requirement
1250      * on the return value: the return value is optional (but if data is returned, it must not be false).
1251      * @param token The token targeted by the call.
1252      * @param data The call data (encoded using abi.encode or one of its variants).
1253      */
1254     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1255         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1256         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1257         // the target address contains contract code and also asserts for success in the low-level call.
1258 
1259         bytes memory returndata = address(token).functionCall(
1260             data,
1261             "SafeERC20: low-level call failed"
1262         );
1263         if (returndata.length > 0) {
1264             // Return data is optional
1265             require(
1266                 abi.decode(returndata, (bool)),
1267                 "SafeERC20: ERC20 operation did not succeed"
1268             );
1269         }
1270     }
1271 }
1272 
1273 pragma solidity ^0.8.0;
1274 
1275 /**
1276  * @dev Interface of the ERC20 standard as defined in the EIP.
1277  */
1278 interface IERC20 {
1279     /**
1280      * @dev Returns the amount of tokens in existence.
1281      */
1282     function totalSupply() external view returns (uint256);
1283 
1284     /**
1285      * @dev Returns the amount of tokens owned by `account`.
1286      */
1287     function balanceOf(address account) external view returns (uint256);
1288 
1289     /**
1290      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1291      *
1292      * Returns a boolean value indicating whether the operation succeeded.
1293      *
1294      * Emits a {Transfer} event.
1295      */
1296     function transfer(address recipient, uint256 amount)
1297         external
1298         returns (bool);
1299 
1300     /**
1301      * @dev Returns the remaining number of tokens that `spender` will be
1302      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1303      * zero by default.
1304      *
1305      * This value changes when {approve} or {transferFrom} are called.
1306      */
1307     function allowance(address owner, address spender)
1308         external
1309         view
1310         returns (uint256);
1311 
1312     /**
1313      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1314      *
1315      * Returns a boolean value indicating whether the operation succeeded.
1316      *
1317      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1318      * that someone may use both the old and the new allowance by unfortunate
1319      * transaction ordering. One possible solution to mitigate this race
1320      * condition is to first reduce the spender's allowance to 0 and set the
1321      * desired value afterwards:
1322      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1323      *
1324      * Emits an {Approval} event.
1325      */
1326     function approve(address spender, uint256 amount) external returns (bool);
1327 
1328     /**
1329      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1330      * allowance mechanism. `amount` is then deducted from the caller's
1331      * allowance.
1332      *
1333      * Returns a boolean value indicating whether the operation succeeded.
1334      *
1335      * Emits a {Transfer} event.
1336      */
1337     function transferFrom(
1338         address sender,
1339         address recipient,
1340         uint256 amount
1341     ) external returns (bool);
1342 
1343     /**
1344      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1345      * another (`to`).
1346      *
1347      * Note that `value` may be zero.
1348      */
1349     event Transfer(address indexed from, address indexed to, uint256 value);
1350 
1351     /**
1352      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1353      * a call to {approve}. `value` is the new allowance.
1354      */
1355     event Approval(
1356         address indexed owner,
1357         address indexed spender,
1358         uint256 value
1359     );
1360 }
1361 
1362 pragma solidity ^0.8.0;
1363 
1364 /**
1365  * @dev Contract module which allows children to implement an emergency stop
1366  * mechanism that can be triggered by an authorized account.
1367  *
1368  * This module is used through inheritance. It will make available the
1369  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1370  * the functions of your contract. Note that they will not be pausable by
1371  * simply including this module, only once the modifiers are put in place.
1372  */
1373 abstract contract Pausable is Context {
1374     /**
1375      * @dev Emitted when the pause is triggered by `account`.
1376      */
1377     event Paused(address account);
1378 
1379     /**
1380      * @dev Emitted when the pause is lifted by `account`.
1381      */
1382     event Unpaused(address account);
1383 
1384     bool private _paused;
1385 
1386     /**
1387      * @dev Initializes the contract in unpaused state.
1388      */
1389     constructor() {
1390         _paused = false;
1391     }
1392 
1393     /**
1394      * @dev Returns true if the contract is paused, and false otherwise.
1395      */
1396     function paused() public view virtual returns (bool) {
1397         return _paused;
1398     }
1399 
1400     /**
1401      * @dev Modifier to make a function callable only when the contract is not paused.
1402      *
1403      * Requirements:
1404      *
1405      * - The contract must not be paused.
1406      */
1407     modifier whenNotPaused() {
1408         require(!paused(), "Pausable: paused");
1409         _;
1410     }
1411 
1412     /**
1413      * @dev Modifier to make a function callable only when the contract is paused.
1414      *
1415      * Requirements:
1416      *
1417      * - The contract must be paused.
1418      */
1419     modifier whenPaused() {
1420         require(paused(), "Pausable: not paused");
1421         _;
1422     }
1423 
1424     /**
1425      * @dev Triggers stopped state.
1426      *
1427      * Requirements:
1428      *
1429      * - The contract must not be paused.
1430      */
1431     function _pause() internal virtual whenNotPaused {
1432         _paused = true;
1433         emit Paused(_msgSender());
1434     }
1435 
1436     /**
1437      * @dev Returns to normal state.
1438      *
1439      * Requirements:
1440      *
1441      * - The contract must be paused.
1442      */
1443     function _unpause() internal virtual whenPaused {
1444         _paused = false;
1445         emit Unpaused(_msgSender());
1446     }
1447 }
1448 
1449 pragma solidity ^0.8.0;
1450 
1451 /**
1452  * @dev Contract module which provides a basic access control mechanism, where
1453  * there is an account (an owner) that can be granted exclusive access to
1454  * specific functions.
1455  *
1456  * By default, the owner account will be the one that deploys the contract. This
1457  * can later be changed with {transferOwnership}.
1458  *
1459  * This module is used through inheritance. It will make available the modifier
1460  * `onlyOwner`, which can be applied to your functions to restrict their use to
1461  * the owner.
1462  */
1463 abstract contract Ownable is Context {
1464     address private _owner;
1465 
1466     event OwnershipTransferred(
1467         address indexed previousOwner,
1468         address indexed newOwner
1469     );
1470 
1471     /**
1472      * @dev Initializes the contract setting the deployer as the initial owner.
1473      */
1474     constructor() {
1475         _transferOwnership(_msgSender());
1476     }
1477 
1478     /**
1479      * @dev Returns the address of the current owner.
1480      */
1481     function owner() public view virtual returns (address) {
1482         return _owner;
1483     }
1484 
1485     /**
1486      * @dev Throws if called by any account other than the owner.
1487      */
1488     modifier onlyOwner() {
1489         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1490         _;
1491     }
1492 
1493     /**
1494      * @dev Leaves the contract without owner. It will not be possible to call
1495      * `onlyOwner` functions anymore. Can only be called by the current owner.
1496      *
1497      * NOTE: Renouncing ownership will leave the contract without an owner,
1498      * thereby removing any functionality that is only available to the owner.
1499      */
1500     function renounceOwnership() public virtual onlyOwner {
1501         _transferOwnership(address(0));
1502     }
1503 
1504     /**
1505      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1506      * Can only be called by the current owner.
1507      */
1508     function transferOwnership(address newOwner) public virtual onlyOwner {
1509         require(
1510             newOwner != address(0),
1511             "Ownable: new owner is the zero address"
1512         );
1513         _transferOwnership(newOwner);
1514     }
1515 
1516     /**
1517      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1518      * Internal function without access restriction.
1519      */
1520     function _transferOwnership(address newOwner) internal virtual {
1521         address oldOwner = _owner;
1522         _owner = newOwner;
1523         emit OwnershipTransferred(oldOwner, newOwner);
1524     }
1525 }
1526 
1527 pragma solidity ^0.8.0;
1528 
1529 /**
1530  * @dev Standard math utilities missing in the Solidity language.
1531  */
1532 library Math {
1533     /**
1534      * @dev Returns the largest of two numbers.
1535      */
1536     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1537         return a >= b ? a : b;
1538     }
1539 
1540     /**
1541      * @dev Returns the smallest of two numbers.
1542      */
1543     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1544         return a < b ? a : b;
1545     }
1546 
1547     /**
1548      * @dev Returns the average of two numbers. The result is rounded towards
1549      * zero.
1550      */
1551     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1552         // (a + b) / 2 can overflow.
1553         return (a & b) + (a ^ b) / 2;
1554     }
1555 
1556     /**
1557      * @dev Returns the ceiling of the division of two numbers.
1558      *
1559      * This differs from standard division with `/` in that it rounds up instead
1560      * of rounding down.
1561      */
1562     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1563         // (a + b - 1) / b can overflow on addition, so we distribute.
1564         return a / b + (a % b == 0 ? 0 : 1);
1565     }
1566 }
1567 
1568 pragma solidity ^0.8.0;
1569 
1570 /**
1571  * @dev Contract module that helps prevent reentrant calls to a function.
1572  *
1573  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1574  * available, which can be applied to functions to make sure there are no nested
1575  * (reentrant) calls to them.
1576  *
1577  * Note that because there is a single `nonReentrant` guard, functions marked as
1578  * `nonReentrant` may not call one another. This can be worked around by making
1579  * those functions `private`, and then adding `external` `nonReentrant` entry
1580  * points to them.
1581  *
1582  * TIP: If you would like to learn more about reentrancy and alternative ways
1583  * to protect against it, check out our blog post
1584  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1585  */
1586 abstract contract ReentrancyGuard {
1587     // Booleans are more expensive than uint256 or any type that takes up a full
1588     // word because each write operation emits an extra SLOAD to first read the
1589     // slot's contents, replace the bits taken up by the boolean, and then write
1590     // back. This is the compiler's defense against contract upgrades and
1591     // pointer aliasing, and it cannot be disabled.
1592 
1593     // The values being non-zero value makes deployment a bit more expensive,
1594     // but in exchange the refund on every call to nonReentrant will be lower in
1595     // amount. Since refunds are capped to a percentage of the total
1596     // transaction's gas, it is best to keep them low in cases like this one, to
1597     // increase the likelihood of the full refund coming into effect.
1598     uint256 private constant _NOT_ENTERED = 1;
1599     uint256 private constant _ENTERED = 2;
1600 
1601     uint256 private _status;
1602 
1603     constructor() {
1604         _status = _NOT_ENTERED;
1605     }
1606 
1607     /**
1608      * @dev Prevents a contract from calling itself, directly or indirectly.
1609      * Calling a `nonReentrant` function from another `nonReentrant`
1610      * function is not supported. It is possible to prevent this from happening
1611      * by making the `nonReentrant` function external, and make it call a
1612      * `private` function that does the actual work.
1613      */
1614     modifier nonReentrant() {
1615         // On the first call to nonReentrant, _notEntered will be true
1616         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1617 
1618         // Any calls to nonReentrant after this point will fail
1619         _status = _ENTERED;
1620 
1621         _;
1622 
1623         // By storing the original value once again, a refund is triggered (see
1624         // https://eips.ethereum.org/EIPS/eip-2200)
1625         _status = _NOT_ENTERED;
1626     }
1627 }
1628 
1629 pragma solidity ^0.8.0;
1630 
1631 /**
1632  * @dev Library for managing
1633  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1634  * types.
1635  *
1636  * Sets have the following properties:
1637  *
1638  * - Elements are added, removed, and checked for existence in constant time
1639  * (O(1)).
1640  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1641  *
1642  * ```
1643  * contract Example {
1644  *     // Add the library methods
1645  *     using EnumerableSet for EnumerableSet.AddressSet;
1646  *
1647  *     // Declare a set state variable
1648  *     EnumerableSet.AddressSet private mySet;
1649  * }
1650  * ```
1651  *
1652  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1653  * and `uint256` (`UintSet`) are supported.
1654  */
1655 library EnumerableSet {
1656     // To implement this library for multiple types with as little code
1657     // repetition as possible, we write it in terms of a generic Set type with
1658     // bytes32 values.
1659     // The Set implementation uses private functions, and user-facing
1660     // implementations (such as AddressSet) are just wrappers around the
1661     // underlying Set.
1662     // This means that we can only create new EnumerableSets for types that fit
1663     // in bytes32.
1664 
1665     struct Set {
1666         // Storage of set values
1667         bytes32[] _values;
1668         // Position of the value in the `values` array, plus 1 because index 0
1669         // means a value is not in the set.
1670         mapping(bytes32 => uint256) _indexes;
1671     }
1672 
1673     /**
1674      * @dev Add a value to a set. O(1).
1675      *
1676      * Returns true if the value was added to the set, that is if it was not
1677      * already present.
1678      */
1679     function _add(Set storage set, bytes32 value) private returns (bool) {
1680         if (!_contains(set, value)) {
1681             set._values.push(value);
1682             // The value is stored at length-1, but we add 1 to all indexes
1683             // and use 0 as a sentinel value
1684             set._indexes[value] = set._values.length;
1685             return true;
1686         } else {
1687             return false;
1688         }
1689     }
1690 
1691     /**
1692      * @dev Removes a value from a set. O(1).
1693      *
1694      * Returns true if the value was removed from the set, that is if it was
1695      * present.
1696      */
1697     function _remove(Set storage set, bytes32 value) private returns (bool) {
1698         // We read and store the value's index to prevent multiple reads from the same storage slot
1699         uint256 valueIndex = set._indexes[value];
1700 
1701         if (valueIndex != 0) {
1702             // Equivalent to contains(set, value)
1703             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1704             // the array, and then remove the last element (sometimes called as 'swap and pop').
1705             // This modifies the order of the array, as noted in {at}.
1706 
1707             uint256 toDeleteIndex = valueIndex - 1;
1708             uint256 lastIndex = set._values.length - 1;
1709 
1710             if (lastIndex != toDeleteIndex) {
1711                 bytes32 lastvalue = set._values[lastIndex];
1712 
1713                 // Move the last value to the index where the value to delete is
1714                 set._values[toDeleteIndex] = lastvalue;
1715                 // Update the index for the moved value
1716                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
1717             }
1718 
1719             // Delete the slot where the moved value was stored
1720             set._values.pop();
1721 
1722             // Delete the index for the deleted slot
1723             delete set._indexes[value];
1724 
1725             return true;
1726         } else {
1727             return false;
1728         }
1729     }
1730 
1731     /**
1732      * @dev Returns true if the value is in the set. O(1).
1733      */
1734     function _contains(Set storage set, bytes32 value)
1735         private
1736         view
1737         returns (bool)
1738     {
1739         return set._indexes[value] != 0;
1740     }
1741 
1742     /**
1743      * @dev Returns the number of values on the set. O(1).
1744      */
1745     function _length(Set storage set) private view returns (uint256) {
1746         return set._values.length;
1747     }
1748 
1749     /**
1750      * @dev Returns the value stored at position `index` in the set. O(1).
1751      *
1752      * Note that there are no guarantees on the ordering of values inside the
1753      * array, and it may change when more values are added or removed.
1754      *
1755      * Requirements:
1756      *
1757      * - `index` must be strictly less than {length}.
1758      */
1759     function _at(Set storage set, uint256 index)
1760         private
1761         view
1762         returns (bytes32)
1763     {
1764         return set._values[index];
1765     }
1766 
1767     /**
1768      * @dev Return the entire set in an array
1769      *
1770      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1771      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1772      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1773      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1774      */
1775     function _values(Set storage set) private view returns (bytes32[] memory) {
1776         return set._values;
1777     }
1778 
1779     // Bytes32Set
1780 
1781     struct Bytes32Set {
1782         Set _inner;
1783     }
1784 
1785     /**
1786      * @dev Add a value to a set. O(1).
1787      *
1788      * Returns true if the value was added to the set, that is if it was not
1789      * already present.
1790      */
1791     function add(Bytes32Set storage set, bytes32 value)
1792         internal
1793         returns (bool)
1794     {
1795         return _add(set._inner, value);
1796     }
1797 
1798     /**
1799      * @dev Removes a value from a set. O(1).
1800      *
1801      * Returns true if the value was removed from the set, that is if it was
1802      * present.
1803      */
1804     function remove(Bytes32Set storage set, bytes32 value)
1805         internal
1806         returns (bool)
1807     {
1808         return _remove(set._inner, value);
1809     }
1810 
1811     /**
1812      * @dev Returns true if the value is in the set. O(1).
1813      */
1814     function contains(Bytes32Set storage set, bytes32 value)
1815         internal
1816         view
1817         returns (bool)
1818     {
1819         return _contains(set._inner, value);
1820     }
1821 
1822     /**
1823      * @dev Returns the number of values in the set. O(1).
1824      */
1825     function length(Bytes32Set storage set) internal view returns (uint256) {
1826         return _length(set._inner);
1827     }
1828 
1829     /**
1830      * @dev Returns the value stored at position `index` in the set. O(1).
1831      *
1832      * Note that there are no guarantees on the ordering of values inside the
1833      * array, and it may change when more values are added or removed.
1834      *
1835      * Requirements:
1836      *
1837      * - `index` must be strictly less than {length}.
1838      */
1839     function at(Bytes32Set storage set, uint256 index)
1840         internal
1841         view
1842         returns (bytes32)
1843     {
1844         return _at(set._inner, index);
1845     }
1846 
1847     /**
1848      * @dev Return the entire set in an array
1849      *
1850      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1851      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1852      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1853      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1854      */
1855     function values(Bytes32Set storage set)
1856         internal
1857         view
1858         returns (bytes32[] memory)
1859     {
1860         return _values(set._inner);
1861     }
1862 
1863     // AddressSet
1864 
1865     struct AddressSet {
1866         Set _inner;
1867     }
1868 
1869     /**
1870      * @dev Add a value to a set. O(1).
1871      *
1872      * Returns true if the value was added to the set, that is if it was not
1873      * already present.
1874      */
1875     function add(AddressSet storage set, address value)
1876         internal
1877         returns (bool)
1878     {
1879         return _add(set._inner, bytes32(uint256(uint160(value))));
1880     }
1881 
1882     /**
1883      * @dev Removes a value from a set. O(1).
1884      *
1885      * Returns true if the value was removed from the set, that is if it was
1886      * present.
1887      */
1888     function remove(AddressSet storage set, address value)
1889         internal
1890         returns (bool)
1891     {
1892         return _remove(set._inner, bytes32(uint256(uint160(value))));
1893     }
1894 
1895     /**
1896      * @dev Returns true if the value is in the set. O(1).
1897      */
1898     function contains(AddressSet storage set, address value)
1899         internal
1900         view
1901         returns (bool)
1902     {
1903         return _contains(set._inner, bytes32(uint256(uint160(value))));
1904     }
1905 
1906     /**
1907      * @dev Returns the number of values in the set. O(1).
1908      */
1909     function length(AddressSet storage set) internal view returns (uint256) {
1910         return _length(set._inner);
1911     }
1912 
1913     /**
1914      * @dev Returns the value stored at position `index` in the set. O(1).
1915      *
1916      * Note that there are no guarantees on the ordering of values inside the
1917      * array, and it may change when more values are added or removed.
1918      *
1919      * Requirements:
1920      *
1921      * - `index` must be strictly less than {length}.
1922      */
1923     function at(AddressSet storage set, uint256 index)
1924         internal
1925         view
1926         returns (address)
1927     {
1928         return address(uint160(uint256(_at(set._inner, index))));
1929     }
1930 
1931     /**
1932      * @dev Return the entire set in an array
1933      *
1934      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1935      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1936      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1937      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1938      */
1939     function values(AddressSet storage set)
1940         internal
1941         view
1942         returns (address[] memory)
1943     {
1944         bytes32[] memory store = _values(set._inner);
1945         address[] memory result;
1946 
1947         assembly {
1948             result := store
1949         }
1950 
1951         return result;
1952     }
1953 
1954     // UintSet
1955 
1956     struct UintSet {
1957         Set _inner;
1958     }
1959 
1960     /**
1961      * @dev Add a value to a set. O(1).
1962      *
1963      * Returns true if the value was added to the set, that is if it was not
1964      * already present.
1965      */
1966     function add(UintSet storage set, uint256 value) internal returns (bool) {
1967         return _add(set._inner, bytes32(value));
1968     }
1969 
1970     /**
1971      * @dev Removes a value from a set. O(1).
1972      *
1973      * Returns true if the value was removed from the set, that is if it was
1974      * present.
1975      */
1976     function remove(UintSet storage set, uint256 value)
1977         internal
1978         returns (bool)
1979     {
1980         return _remove(set._inner, bytes32(value));
1981     }
1982 
1983     /**
1984      * @dev Returns true if the value is in the set. O(1).
1985      */
1986     function contains(UintSet storage set, uint256 value)
1987         internal
1988         view
1989         returns (bool)
1990     {
1991         return _contains(set._inner, bytes32(value));
1992     }
1993 
1994     /**
1995      * @dev Returns the number of values on the set. O(1).
1996      */
1997     function length(UintSet storage set) internal view returns (uint256) {
1998         return _length(set._inner);
1999     }
2000 
2001     /**
2002      * @dev Returns the value stored at position `index` in the set. O(1).
2003      *
2004      * Note that there are no guarantees on the ordering of values inside the
2005      * array, and it may change when more values are added or removed.
2006      *
2007      * Requirements:
2008      *
2009      * - `index` must be strictly less than {length}.
2010      */
2011     function at(UintSet storage set, uint256 index)
2012         internal
2013         view
2014         returns (uint256)
2015     {
2016         return uint256(_at(set._inner, index));
2017     }
2018 
2019     /**
2020      * @dev Return the entire set in an array
2021      *
2022      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2023      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2024      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2025      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2026      */
2027     function values(UintSet storage set)
2028         internal
2029         view
2030         returns (uint256[] memory)
2031     {
2032         bytes32[] memory store = _values(set._inner);
2033         uint256[] memory result;
2034 
2035         assembly {
2036             result := store
2037         }
2038 
2039         return result;
2040     }
2041 }
2042 
2043 pragma solidity ^0.8.0;
2044 
2045 interface liquidForgeStaking {
2046     // get the forgeblocks for the forged liquid key
2047     function _liquidKeyForgeBlocks(address) external view returns (uint256);
2048 
2049     // Retrieve the Token IDs of the Forged Liquid Key address
2050     function forgedKeyOwnerAddress(address account)
2051         external
2052         view
2053         returns (uint256[] memory);
2054 }
2055 
2056 contract ApeLiquidMembershipForge is Ownable, ReentrancyGuard, Pausable {
2057     using EnumerableSet for EnumerableSet.UintSet;
2058 
2059     mapping(uint256 => uint256) public nftForgeBlocks;
2060     mapping(address => EnumerableSet.UintSet) private nftForges; // private
2061     mapping(uint256 => address) public _nftTokenForges;
2062 
2063     // NFT Collection, Forge, and METL token addresses
2064     address public nftAddress = 0x61028F622CB6618cAC3DeB9ef0f0D5B9c6369C72; // ApeLiquid Membership
2065     address public forgeAddress = 0x346e31ddE260c6BEEA84186ad99878C1D8C7D90F; // Liquid Key Forge
2066     address public metlTokenAddress = 0xFcbE615dEf610E806BB64427574A2c5c1fB55510; // METL Token
2067 
2068     // how many blocks before a claim (30 days) and when do we expire?
2069     uint256 public expiration = 1000000000;
2070     uint256 public minBlockToClaim = 180204;
2071 
2072     // rate governs how often you receive your token
2073     uint256 public nftRate = 64676699740294; // nft earning rate
2074 
2075     function pause() public onlyOwner {
2076         _pause();
2077     }
2078 
2079     function unpause() public onlyOwner {
2080         _unpause();
2081     }
2082 
2083     // Set this to a expiration block to disable the ability to continue accruing tokens past that block number.
2084     // which is calculated as current block plus the parameters
2085     //
2086     // Set a multiplier for how many tokens to earn each time a block passes
2087     // and the min number of blocks needed to pass to claim rewards
2088     function setRates(
2089         uint256 _nftRate,
2090         uint256 _minBlockToClaim,
2091         uint256 _expiration
2092     ) public onlyOwner {
2093         nftRate = _nftRate;
2094         minBlockToClaim = _minBlockToClaim;
2095         expiration = block.number + _expiration;
2096     }
2097 
2098     // Set addresses
2099     function setAddresses(
2100         address _nftAddress, 
2101         address _forgeAddress, 
2102         address _metlTokenAddress
2103     ) public onlyOwner {
2104         nftAddress = _nftAddress;
2105         forgeAddress = _forgeAddress;
2106         metlTokenAddress = _metlTokenAddress;
2107     }
2108 
2109     // Reward Claimable information
2110     function rewardClaimable(uint256 tokenId) public view returns (bool) {
2111         uint256 blockCur = Math.min(block.number, expiration);
2112         if (nftForgeBlocks[tokenId] > 0) {
2113             return (blockCur - nftForgeBlocks[tokenId] > minBlockToClaim);
2114         }
2115         return false;
2116     }
2117 
2118     // reward amount by address/tokenIds[]
2119     function CalculateEarnedMETL(address account, uint256 tokenId)
2120         public
2121         view
2122         returns (uint256)
2123     {
2124         require(
2125             Math.min(block.number, expiration) > nftForgeBlocks[tokenId],
2126             "Invalid blocks"
2127         );
2128         return
2129             nftRate *
2130             (nftForges[msg.sender].contains(tokenId) ? 1 : 0) *
2131             (Math.min(block.number, expiration) -
2132                 Math.max(
2133                     liquidForgeStaking(forgeAddress)._liquidKeyForgeBlocks(
2134                         account
2135                     ),
2136                     nftForgeBlocks[tokenId]
2137                 ));
2138     }
2139 
2140     // claim rewards (earned METL)
2141     function ClaimEarnedMETL(uint256[] calldata tokenIds) public whenNotPaused {
2142         uint256 reward;
2143         uint256 blockCur = Math.min(block.number, expiration);
2144 
2145         require(
2146             liquidForgeStaking(forgeAddress)
2147                 .forgedKeyOwnerAddress(msg.sender)
2148                 .length > 0,
2149             "No Liquid Key Forged"
2150         );
2151 
2152         for (uint256 i; i < tokenIds.length; i++) {
2153             require(
2154                 nftForges[msg.sender].contains(tokenIds[i]),
2155                 "Staking: token not forged"
2156             );
2157             require(blockCur - nftForgeBlocks[tokenIds[i]] > minBlockToClaim);
2158         }
2159 
2160         for (uint256 i; i < tokenIds.length; i++) {
2161             reward += CalculateEarnedMETL(msg.sender, tokenIds[i]);
2162             nftForgeBlocks[tokenIds[i]] = blockCur;
2163         }
2164 
2165         if (reward > 0) {
2166             IERC20(metlTokenAddress).transfer(msg.sender, reward);
2167         }
2168     }
2169 
2170     // Forge NFT
2171     function ForgeNFT(uint256[] calldata tokenIds)
2172         external
2173         whenNotPaused
2174     {
2175         uint256 blockCur = block.number;
2176         require(msg.sender != nftAddress, "Invalid NFT contract address");
2177 
2178         for (uint256 i; i < tokenIds.length; i++) {
2179             IERC721(nftAddress).safeTransferFrom(
2180                 msg.sender,
2181                 address(this),
2182                 tokenIds[i],
2183                 "Transfer from Member to Forge"
2184             );
2185             nftForges[msg.sender].add(tokenIds[i]);
2186             nftForgeBlocks[tokenIds[i]] = blockCur;
2187             // write the entry for the ETH address
2188             _nftTokenForges[tokenIds[i]] = msg.sender;
2189         }
2190     }
2191 
2192     // withdrawal function
2193     function WithdrawNFT(uint256[] calldata tokenIds)
2194         external
2195         whenNotPaused
2196         nonReentrant
2197     {
2198         for (uint256 i; i < tokenIds.length; i++) {
2199             require(
2200                 nftForges[msg.sender].contains(tokenIds[i]),
2201                 "Staking: token not forged"
2202             );
2203 
2204             nftForges[msg.sender].remove(tokenIds[i]);
2205             _nftTokenForges[tokenIds[i]] = 0x0000000000000000000000000000000000000000;
2206 
2207             IERC721(nftAddress).safeTransferFrom(
2208                 address(this),
2209                 msg.sender,
2210                 tokenIds[i],
2211                 "Not withdrawn: Transfer failed"
2212             );
2213         }
2214     }
2215 
2216     // withdraw earned METL
2217     function WithdrawEarnedMETL() external onlyOwner {
2218         uint256 tokenSupply = IERC20(metlTokenAddress).balanceOf(address(this));
2219         IERC20(metlTokenAddress).transfer(msg.sender, tokenSupply);
2220     }
2221     
2222     // ERC721 token receiver for transferred NFT to Forge
2223     function onERC721Received(
2224         address,
2225         address,
2226         uint256,
2227         bytes calldata
2228     ) external pure  returns (bytes4) {
2229         return IERC721Receiver.onERC721Received.selector;
2230     }
2231 }