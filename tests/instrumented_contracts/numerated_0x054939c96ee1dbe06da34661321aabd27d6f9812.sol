1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.9;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14  /**
15  ______ __                  ____    __                        __              __        
16 /\__  _/\ \                /\  _`\ /\ \__                    /\ \            /\ \       
17 \/_/\ \\ \ \___      __    \ \,\L\_\ \ ,_\    __    _ __  ___\ \ \        __ \ \ \____  
18    \ \ \\ \  _ `\  /'__`\   \/_\__ \\ \ \/  /'__`\ /\`'__/',__\ \ \  __ /'__`\\ \ '__`\ 
19     \ \ \\ \ \ \ \/\  __/     /\ \L\ \ \ \_/\ \L\.\\ \ \/\__, `\ \ \L\ /\ \L\.\\ \ \L\ \
20      \ \_\\ \_\ \_\ \____\    \ `\____\ \__\ \__/.\_\ \_\/\____/\ \____\ \__/.\_\ \_,__/
21       \/_/ \/_/\/_/\/____/     \/_____/\/__/\/__/\/_/\/_/\/___/  \/___/ \/__/\/_/\/___/ 
22   */
23 interface IERC165 {
24     /**
25      * @dev Returns true if this contract implements the interface defined by
26      * `interfaceId`. See the corresponding
27      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
28      * to learn more about how these ids are created.
29      *
30      * This function call must use less than 30 000 gas.
31      */
32     function supportsInterface(bytes4 interfaceId) external view returns (bool);
33 }
34 
35 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\IERC721.sol
36 
37 pragma solidity ^0.8.9;
38 
39 /**
40  * @dev Required interface of an ERC721 compliant contract.
41  */
42 interface IERC721 is IERC165 {
43     /**
44      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
45      */
46     event Transfer(
47         address indexed from,
48         address indexed to,
49         uint256 indexed tokenId
50     );
51 
52     /**
53      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
54      */
55     event Approval(
56         address indexed owner,
57         address indexed approved,
58         uint256 indexed tokenId
59     );
60 
61     /**
62      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
63      */
64     event ApprovalForAll(
65         address indexed owner,
66         address indexed operator,
67         bool approved
68     );
69 
70     /**
71      * @dev Returns the number of tokens in ``owner``'s account.
72      */
73     function balanceOf(address owner) external view returns (uint256 balance);
74 
75     /**
76      * @dev Returns the owner of the `tokenId` token.
77      *
78      * Requirements:
79      *
80      * - `tokenId` must exist.
81      */
82     function ownerOf(uint256 tokenId) external view returns (address owner);
83 
84     /**
85      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
86      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
87      *
88      * Requirements:
89      *
90      * - `from` cannot be the zero address.
91      * - `to` cannot be the zero address.
92      * - `tokenId` token must exist and be owned by `from`.
93      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
94      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
95      *
96      * Emits a {Transfer} event.
97      */
98     function safeTransferFrom(
99         address from,
100         address to,
101         uint256 tokenId
102     ) external;
103 
104     /**
105      * @dev Transfers `tokenId` token from `from` to `to`.
106      *
107      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
108      *
109      * Requirements:
110      *
111      * - `from` cannot be the zero address.
112      * - `to` cannot be the zero address.
113      * - `tokenId` token must be owned by `from`.
114      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
115      *
116      * Emits a {Transfer} event.
117      */
118     function transferFrom(
119         address from,
120         address to,
121         uint256 tokenId
122     ) external;
123 
124     /**
125      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
126      * The approval is cleared when the token is transferred.
127      *
128      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
129      *
130      * Requirements:
131      *
132      * - The caller must own the token or be an approved operator.
133      * - `tokenId` must exist.
134      *
135      * Emits an {Approval} event.
136      */
137     function approve(address to, uint256 tokenId) external;
138 
139     /**
140      * @dev Returns the account approved for `tokenId` token.
141      *
142      * Requirements:
143      *
144      * - `tokenId` must exist.
145      */
146     function getApproved(uint256 tokenId)
147         external
148         view
149         returns (address operator);
150 
151     /**
152      * @dev Approve or remove `operator` as an operator for the caller.
153      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
154      *
155      * Requirements:
156      *
157      * - The `operator` cannot be the caller.
158      *
159      * Emits an {ApprovalForAll} event.
160      */
161     function setApprovalForAll(address operator, bool _approved) external;
162 
163     /**
164      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
165      *
166      * See {setApprovalForAll}
167      */
168     function isApprovedForAll(address owner, address operator)
169         external
170         view
171         returns (bool);
172 
173     /**
174      * @dev Safely transfers `tokenId` token from `from` to `to`.
175      *
176      * Requirements:
177      *
178      * - `from` cannot be the zero address.
179      * - `to` cannot be the zero address.
180      * - `tokenId` token must exist and be owned by `from`.
181      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
182      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
183      *
184      * Emits a {Transfer} event.
185      */
186     function safeTransferFrom(
187         address from,
188         address to,
189         uint256 tokenId,
190         bytes calldata data
191     ) external;
192 }
193 
194 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\IERC721Receiver.sol
195 
196 pragma solidity ^0.8.9;
197 
198 /**
199  * @title ERC721 token receiver interface
200  * @dev Interface for any contract that wants to support safeTransfers
201  * from ERC721 asset contracts.
202  */
203 interface IERC721Receiver {
204     /**
205      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
206      * by `operator` from `from`, this function is called.
207      *
208      * It must return its Solidity selector to confirm the token transfer.
209      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
210      *
211      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
212      */
213     function onERC721Received(
214         address operator,
215         address from,
216         uint256 tokenId,
217         bytes calldata data
218     ) external returns (bytes4);
219 }
220 
221 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\extensions\IERC721Metadata.sol
222 
223 pragma solidity ^0.8.9;
224 
225 /**
226  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
227  * @dev See https://eips.ethereum.org/EIPS/eip-721
228  */
229 interface IERC721Metadata is IERC721 {
230     /**
231      * @dev Returns the token collection name.
232      */
233     function name() external view returns (string memory);
234 
235     /**
236      * @dev Returns the token collection symbol.
237      */
238     function symbol() external view returns (string memory);
239 
240     /**
241      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
242      */
243     function tokenURI(uint256 tokenId) external view returns (string memory);
244 }
245 
246 // File: node_modules\openzeppelin-solidity\contracts\utils\Address.sol
247 
248 pragma solidity ^0.8.9;
249 
250 /**
251  * @dev Collection of functions related to the address type
252  */
253 library Address {
254     /**
255      * @dev Returns true if `account` is a contract.
256      *
257      * [IMPORTANT]
258      * ====
259      * It is unsafe to assume that an address for which this function returns
260      * false is an externally-owned account (EOA) and not a contract.
261      *
262      * Among others, `isContract` will return false for the following
263      * types of addresses:
264      *
265      *  - an externally-owned account
266      *  - a contract in construction
267      *  - an address where a contract will be created
268      *  - an address where a contract lived, but was destroyed
269      * ====
270      */
271     function isContract(address account) internal view returns (bool) {
272         // This method relies on extcodesize, which returns 0 for contracts in
273         // construction, since the code is only stored at the end of the
274         // constructor execution.
275 
276         uint256 size;
277         // solhint-disable-next-line no-inline-assembly
278         assembly {
279             size := extcodesize(account)
280         }
281         return size > 0;
282     }
283 
284     /**
285      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
286      * `recipient`, forwarding all available gas and reverting on errors.
287      *
288      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
289      * of certain opcodes, possibly making contracts go over the 2300 gas limit
290      * imposed by `transfer`, making them unable to receive funds via
291      * `transfer`. {sendValue} removes this limitation.
292      *
293      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
294      *
295      * IMPORTANT: because control is transferred to `recipient`, care must be
296      * taken to not create reentrancy vulnerabilities. Consider using
297      * {ReentrancyGuard} or the
298      * https://solidity.readthedocs.io/en/v0.5.9/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
299      */
300     function sendValue(address payable recipient, uint256 amount) internal {
301         require(
302             address(this).balance >= amount,
303             "Address: insufficient balance"
304         );
305 
306         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
307         (bool success, ) = recipient.call{value: amount}("");
308         require(
309             success,
310             "Address: unable to send value, recipient may have reverted"
311         );
312     }
313 
314     /**
315      * @dev Performs a Solidity function call using a low level `call`. A
316      * plain`call` is an unsafe replacement for a function call: use this
317      * function instead.
318      *
319      * If `target` reverts with a revert reason, it is bubbled up by this
320      * function (like regular Solidity function calls).
321      *
322      * Returns the raw returned data. To convert to the expected return value,
323      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
324      *
325      * Requirements:
326      *
327      * - `target` must be a contract.
328      * - calling `target` with `data` must not revert.
329      *
330      * _Available since v3.1._
331      */
332     function functionCall(address target, bytes memory data)
333         internal
334         returns (bytes memory)
335     {
336         return functionCall(target, data, "Address: low-level call failed");
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
341      * `errorMessage` as a fallback revert reason when `target` reverts.
342      *
343      * _Available since v3.1._
344      */
345     function functionCall(
346         address target,
347         bytes memory data,
348         string memory errorMessage
349     ) internal returns (bytes memory) {
350         return functionCallWithValue(target, data, 0, errorMessage);
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
355      * but also transferring `value` wei to `target`.
356      *
357      * Requirements:
358      *
359      * - the calling contract must have an ETH balance of at least `value`.
360      * - the called Solidity function must be `payable`.
361      *
362      * _Available since v3.1._
363      */
364     function functionCallWithValue(
365         address target,
366         bytes memory data,
367         uint256 value
368     ) internal returns (bytes memory) {
369         return
370             functionCallWithValue(
371                 target,
372                 data,
373                 value,
374                 "Address: low-level call with value failed"
375             );
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
380      * with `errorMessage` as a fallback revert reason when `target` reverts.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(
385         address target,
386         bytes memory data,
387         uint256 value,
388         string memory errorMessage
389     ) internal returns (bytes memory) {
390         require(
391             address(this).balance >= value,
392             "Address: insufficient balance for call"
393         );
394         require(isContract(target), "Address: call to non-contract");
395 
396         // solhint-disable-next-line avoid-low-level-calls
397         (bool success, bytes memory returndata) = target.call{value: value}(
398             data
399         );
400         return _verifyCallResult(success, returndata, errorMessage);
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
405      * but performing a static call.
406      *
407      * _Available since v3.3._
408      */
409     function functionStaticCall(address target, bytes memory data)
410         internal
411         view
412         returns (bytes memory)
413     {
414         return
415             functionStaticCall(
416                 target,
417                 data,
418                 "Address: low-level static call failed"
419             );
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
424      * but performing a static call.
425      *
426      * _Available since v3.3._
427      */
428     function functionStaticCall(
429         address target,
430         bytes memory data,
431         string memory errorMessage
432     ) internal view returns (bytes memory) {
433         require(isContract(target), "Address: static call to non-contract");
434 
435         // solhint-disable-next-line avoid-low-level-calls
436         (bool success, bytes memory returndata) = target.staticcall(data);
437         return _verifyCallResult(success, returndata, errorMessage);
438     }
439 
440     /**
441      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
442      * but performing a delegate call.
443      *
444      * _Available since v3.4._
445      */
446     function functionDelegateCall(address target, bytes memory data)
447         internal
448         returns (bytes memory)
449     {
450         return
451             functionDelegateCall(
452                 target,
453                 data,
454                 "Address: low-level delegate call failed"
455             );
456     }
457 
458     /**
459      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
460      * but performing a delegate call.
461      *
462      * _Available since v3.4._
463      */
464     function functionDelegateCall(
465         address target,
466         bytes memory data,
467         string memory errorMessage
468     ) internal returns (bytes memory) {
469         require(isContract(target), "Address: delegate call to non-contract");
470 
471         // solhint-disable-next-line avoid-low-level-calls
472         (bool success, bytes memory returndata) = target.delegatecall(data);
473         return _verifyCallResult(success, returndata, errorMessage);
474     }
475 
476     function _verifyCallResult(
477         bool success,
478         bytes memory returndata,
479         string memory errorMessage
480     ) private pure returns (bytes memory) {
481         if (success) {
482             return returndata;
483         } else {
484             // Look for revert reason and bubble it up if present
485             if (returndata.length > 0) {
486                 // The easiest way to bubble the revert reason is using memory via assembly
487 
488                 // solhint-disable-next-line no-inline-assembly
489                 assembly {
490                     let returndata_size := mload(returndata)
491                     revert(add(32, returndata), returndata_size)
492                 }
493             } else {
494                 revert(errorMessage);
495             }
496         }
497     }
498 }
499 
500 // File: node_modules\openzeppelin-solidity\contracts\utils\Context.sol
501 
502 pragma solidity ^0.8.9;
503 
504 /*
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
520         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
521         return msg.data;
522     }
523 }
524 
525 // File: node_modules\openzeppelin-solidity\contracts\utils\Strings.sol
526 
527 pragma solidity ^0.8.9;
528 
529 /**
530  * @dev String operations.
531  */
532 library Strings {
533     bytes16 private constant alphabet = "0123456789abcdef";
534 
535     /**
536      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
537      */
538     function toString(uint256 value) internal pure returns (string memory) {
539         // Inspired by OraclizeAPI's implementation - MIT licence
540         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
541 
542         if (value == 0) {
543             return "0";
544         }
545         uint256 temp = value;
546         uint256 digits;
547         while (temp != 0) {
548             digits++;
549             temp /= 10;
550         }
551         bytes memory buffer = new bytes(digits);
552         while (value != 0) {
553             digits -= 1;
554             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
555             value /= 10;
556         }
557         return string(buffer);
558     }
559 
560     /**
561      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
562      */
563     function toHexString(uint256 value) internal pure returns (string memory) {
564         if (value == 0) {
565             return "0x00";
566         }
567         uint256 temp = value;
568         uint256 length = 0;
569         while (temp != 0) {
570             length++;
571             temp >>= 8;
572         }
573         return toHexString(value, length);
574     }
575 
576     /**
577      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
578      */
579     function toHexString(uint256 value, uint256 length)
580         internal
581         pure
582         returns (string memory)
583     {
584         bytes memory buffer = new bytes(2 * length + 2);
585         buffer[0] = "0";
586         buffer[1] = "x";
587         for (uint256 i = 2 * length + 1; i > 1; --i) {
588             buffer[i] = alphabet[value & 0xf];
589             value >>= 4;
590         }
591         require(value == 0, "Strings: hex length insufficient");
592         return string(buffer);
593     }
594 }
595 
596 // File: node_modules\openzeppelin-solidity\contracts\utils\introspection\ERC165.sol
597 
598 pragma solidity ^0.8.9;
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
618     function supportsInterface(bytes4 interfaceId)
619         public
620         view
621         virtual
622         override
623         returns (bool)
624     {
625         return interfaceId == type(IERC165).interfaceId;
626     }
627 }
628 
629 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\ERC721.sol
630 
631 pragma solidity ^0.8.9;
632 
633 /**
634  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
635  * the Metadata extension, but not including the Enumerable extension, which is available separately as
636  * {ERC721Enumerable}.
637  */
638 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
639     using Address for address;
640     using Strings for uint256;
641 
642     // Token name
643     string private _name;
644 
645     // Token symbol
646     string private _symbol;
647 
648     // Mapping from token ID to owner address
649     mapping(uint256 => address) private _owners;
650 
651     // Mapping owner address to token count
652     mapping(address => uint256) private _balances;
653 
654     // Mapping from token ID to approved address
655     mapping(uint256 => address) private _tokenApprovals;
656 
657     // Mapping from owner to operator approvals
658     mapping(address => mapping(address => bool)) private _operatorApprovals;
659 
660     /**
661      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
662      */
663     constructor(string memory name_, string memory symbol_) {
664         _name = name_;
665         _symbol = symbol_;
666     }
667 
668     /**
669      * @dev See {IERC165-supportsInterface}.
670      */
671     function supportsInterface(bytes4 interfaceId)
672         public
673         view
674         virtual
675         override(ERC165, IERC165)
676         returns (bool)
677     {
678         return
679             interfaceId == type(IERC721).interfaceId ||
680             interfaceId == type(IERC721Metadata).interfaceId ||
681             super.supportsInterface(interfaceId);
682     }
683 
684     /**
685      * @dev See {IERC721-balanceOf}.
686      */
687     function balanceOf(address owner)
688         public
689         view
690         virtual
691         override
692         returns (uint256)
693     {
694         require(
695             owner != address(0),
696             "ERC721: balance query for the zero address"
697         );
698         return _balances[owner];
699     }
700 
701     /**
702      * @dev See {IERC721-ownerOf}.
703      */
704     function ownerOf(uint256 tokenId)
705         public
706         view
707         virtual
708         override
709         returns (address)
710     {
711         address owner = _owners[tokenId];
712         require(
713             owner != address(0),
714             "ERC721: owner query for nonexistent token"
715         );
716         return owner;
717     }
718 
719     /**
720      * @dev See {IERC721Metadata-name}.
721      */
722     function name() public view virtual override returns (string memory) {
723         return _name;
724     }
725 
726     /**
727      * @dev See {IERC721Metadata-symbol}.
728      */
729     function symbol() public view virtual override returns (string memory) {
730         return _symbol;
731     }
732 
733     /**
734      * @dev See {IERC721Metadata-tokenURI}.
735      */
736     function tokenURI(uint256 tokenId)
737         public
738         view
739         virtual
740         override
741         returns (string memory)
742     {
743         require(
744             _exists(tokenId),
745             "ERC721Metadata: URI query for nonexistent token"
746         );
747 
748         string memory baseURI = _baseURI();
749         return
750             bytes(baseURI).length > 0
751                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
752                 : "";
753     }
754 
755     /**
756      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
757      * in child contracts.
758      */
759     function _baseURI() internal view virtual returns (string memory) {
760         return "";
761     }
762 
763     /**
764      * @dev See {IERC721-approve}.
765      */
766     function approve(address to, uint256 tokenId) public virtual override {
767         address owner = ERC721.ownerOf(tokenId);
768         require(to != owner, "ERC721: approval to current owner");
769 
770         require(
771             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
772             "ERC721: approve caller is not owner nor approved for all"
773         );
774 
775         _approve(to, tokenId);
776     }
777 
778     /**
779      * @dev See {IERC721-getApproved}.
780      */
781     function getApproved(uint256 tokenId)
782         public
783         view
784         virtual
785         override
786         returns (address)
787     {
788         require(
789             _exists(tokenId),
790             "ERC721: approved query for nonexistent token"
791         );
792 
793         return _tokenApprovals[tokenId];
794     }
795 
796     /**
797      * @dev See {IERC721-setApprovalForAll}.
798      */
799     function setApprovalForAll(address operator, bool approved)
800         public
801         virtual
802         override
803     {
804         require(operator != _msgSender(), "ERC721: approve to caller");
805 
806         _operatorApprovals[_msgSender()][operator] = approved;
807         emit ApprovalForAll(_msgSender(), operator, approved);
808     }
809 
810     /**
811      * @dev See {IERC721-isApprovedForAll}.
812      */
813     function isApprovedForAll(address owner, address operator)
814         public
815         view
816         virtual
817         override
818         returns (bool)
819     {
820         return _operatorApprovals[owner][operator];
821     }
822 
823     /**
824      * @dev See {IERC721-transferFrom}.
825      */
826     function transferFrom(
827         address from,
828         address to,
829         uint256 tokenId
830     ) public virtual override {
831         //solhint-disable-next-line max-line-length
832         require(
833             _isApprovedOrOwner(_msgSender(), tokenId),
834             "ERC721: transfer caller is not owner nor approved"
835         );
836 
837         _transfer(from, to, tokenId);
838     }
839 
840     /**
841      * @dev See {IERC721-safeTransferFrom}.
842      */
843     function safeTransferFrom(
844         address from,
845         address to,
846         uint256 tokenId
847     ) public virtual override {
848         safeTransferFrom(from, to, tokenId, "");
849     }
850 
851     /**
852      * @dev See {IERC721-safeTransferFrom}.
853      */
854     function safeTransferFrom(
855         address from,
856         address to,
857         uint256 tokenId,
858         bytes memory _data
859     ) public virtual override {
860         require(
861             _isApprovedOrOwner(_msgSender(), tokenId),
862             "ERC721: transfer caller is not owner nor approved"
863         );
864         _safeTransfer(from, to, tokenId, _data);
865     }
866 
867     /**
868      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
869      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
870      *
871      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
872      *
873      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
874      * implement alternative mechanisms to perform token transfer, such as signature-based.
875      *
876      * Requirements:
877      *
878      * - `from` cannot be the zero address.
879      * - `to` cannot be the zero address.
880      * - `tokenId` token must exist and be owned by `from`.
881      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
882      *
883      * Emits a {Transfer} event.
884      */
885     function _safeTransfer(
886         address from,
887         address to,
888         uint256 tokenId,
889         bytes memory _data
890     ) internal virtual {
891         _transfer(from, to, tokenId);
892         require(
893             _checkOnERC721Received(from, to, tokenId, _data),
894             "ERC721: transfer to non ERC721Receiver implementer"
895         );
896     }
897 
898     /**
899      * @dev Returns whether `tokenId` exists.
900      *
901      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
902      *
903      * Tokens start existing when they are minted (`_mint`),
904      * and stop existing when they are burned (`_burn`).
905      */
906     function _exists(uint256 tokenId) internal view virtual returns (bool) {
907         return _owners[tokenId] != address(0);
908     }
909 
910     /**
911      * @dev Returns whether `spender` is allowed to manage `tokenId`.
912      *
913      * Requirements:
914      *
915      * - `tokenId` must exist.
916      */
917     function _isApprovedOrOwner(address spender, uint256 tokenId)
918         internal
919         view
920         virtual
921         returns (bool)
922     {
923         require(
924             _exists(tokenId),
925             "ERC721: operator query for nonexistent token"
926         );
927         address owner = ERC721.ownerOf(tokenId);
928         return (spender == owner ||
929             getApproved(tokenId) == spender ||
930             isApprovedForAll(owner, spender));
931     }
932 
933     /**
934      * @dev Safely mints `tokenId` and transfers it to `to`.
935      *
936      * Requirements:
937      *
938      * - `tokenId` must not exist.
939      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
940      *
941      * Emits a {Transfer} event.
942      */
943     function _safeMint(address to, uint256 tokenId) internal virtual {
944         _safeMint(to, tokenId, "");
945     }
946 
947     /**
948      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
949      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
950      */
951     function _safeMint(
952         address to,
953         uint256 tokenId,
954         bytes memory _data
955     ) internal virtual {
956         _mint(to, tokenId);
957         require(
958             _checkOnERC721Received(address(0), to, tokenId, _data),
959             "ERC721: transfer to non ERC721Receiver implementer"
960         );
961     }
962 
963     /**
964      * @dev Mints `tokenId` and transfers it to `to`.
965      *
966      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
967      *
968      * Requirements:
969      *
970      * - `tokenId` must not exist.
971      * - `to` cannot be the zero address.
972      *
973      * Emits a {Transfer} event.
974      */
975     function _mint(address to, uint256 tokenId) internal virtual {
976         require(to != address(0), "ERC721: mint to the zero address");
977         require(!_exists(tokenId), "ERC721: token already minted");
978 
979         _beforeTokenTransfer(address(0), to, tokenId);
980 
981         _balances[to] += 1;
982         _owners[tokenId] = to;
983 
984         emit Transfer(address(0), to, tokenId);
985     }
986 
987     /**
988      * @dev Destroys `tokenId`.
989      * The approval is cleared when the token is burned.
990      *
991      * Requirements:
992      *
993      * - `tokenId` must exist.
994      *
995      * Emits a {Transfer} event.
996      */
997     function _burn(uint256 tokenId) internal virtual {
998         address owner = ERC721.ownerOf(tokenId);
999 
1000         _beforeTokenTransfer(owner, address(0), tokenId);
1001 
1002         // Clear approvals
1003         _approve(address(0), tokenId);
1004 
1005         _balances[owner] -= 1;
1006         delete _owners[tokenId];
1007 
1008         emit Transfer(owner, address(0), tokenId);
1009     }
1010 
1011     /**
1012      * @dev Transfers `tokenId` from `from` to `to`.
1013      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1014      *
1015      * Requirements:
1016      *
1017      * - `to` cannot be the zero address.
1018      * - `tokenId` token must be owned by `from`.
1019      *
1020      * Emits a {Transfer} event.
1021      */
1022     function _transfer(
1023         address from,
1024         address to,
1025         uint256 tokenId
1026     ) internal virtual {
1027         require(
1028             ERC721.ownerOf(tokenId) == from,
1029             "ERC721: transfer of token that is not own"
1030         );
1031         require(to != address(0), "ERC721: transfer to the zero address");
1032 
1033         _beforeTokenTransfer(from, to, tokenId);
1034 
1035         // Clear approvals from the previous owner
1036         _approve(address(0), tokenId);
1037 
1038         _balances[from] -= 1;
1039         _balances[to] += 1;
1040         _owners[tokenId] = to;
1041 
1042         emit Transfer(from, to, tokenId);
1043     }
1044 
1045     /**
1046      * @dev Approve `to` to operate on `tokenId`
1047      *
1048      * Emits a {Approval} event.
1049      */
1050     function _approve(address to, uint256 tokenId) internal virtual {
1051         _tokenApprovals[tokenId] = to;
1052         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1053     }
1054 
1055     /**
1056      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1057      * The call is not executed if the target address is not a contract.
1058      *
1059      * @param from address representing the previous owner of the given token ID
1060      * @param to target address that will receive the tokens
1061      * @param tokenId uint256 ID of the token to be transferred
1062      * @param _data bytes optional data to send along with the call
1063      * @return bool whether the call correctly returned the expected magic value
1064      */
1065     function _checkOnERC721Received(
1066         address from,
1067         address to,
1068         uint256 tokenId,
1069         bytes memory _data
1070     ) private returns (bool) {
1071         if (to.isContract()) {
1072             try
1073                 IERC721Receiver(to).onERC721Received(
1074                     _msgSender(),
1075                     from,
1076                     tokenId,
1077                     _data
1078                 )
1079             returns (bytes4 retval) {
1080                 return retval == IERC721Receiver(to).onERC721Received.selector;
1081             } catch (bytes memory reason) {
1082                 if (reason.length == 0) {
1083                     revert(
1084                         "ERC721: transfer to non ERC721Receiver implementer"
1085                     );
1086                 } else {
1087                     // solhint-disable-next-line no-inline-assembly
1088                     assembly {
1089                         revert(add(32, reason), mload(reason))
1090                     }
1091                 }
1092             }
1093         } else {
1094             return true;
1095         }
1096     }
1097 
1098     /**
1099      * @dev Hook that is called before any token transfer. This includes minting
1100      * and burning.
1101      *
1102      * Calling conditions:
1103      *
1104      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1105      * transferred to `to`.
1106      * - When `from` is zero, `tokenId` will be minted for `to`.
1107      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1108      * - `from` cannot be the zero address.
1109      * - `to` cannot be the zero address.
1110      *
1111      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1112      */
1113     function _beforeTokenTransfer(
1114         address from,
1115         address to,
1116         uint256 tokenId
1117     ) internal virtual {}
1118 }
1119 
1120 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\extensions\IERC721Enumerable.sol
1121 
1122 pragma solidity ^0.8.9;
1123 
1124 /**
1125  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1126  * @dev See https://eips.ethereum.org/EIPS/eip-721
1127  */
1128 interface IERC721Enumerable is IERC721 {
1129     /**
1130      * @dev Returns the total amount of tokens stored by the contract.
1131      */
1132     function totalSupply() external view returns (uint256);
1133 
1134     /**
1135      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1136      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1137      */
1138     function tokenOfOwnerByIndex(address owner, uint256 index)
1139         external
1140         view
1141         returns (uint256 tokenId);
1142 
1143     /**
1144      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1145      * Use along with {totalSupply} to enumerate all tokens.
1146      */
1147     function tokenByIndex(uint256 index) external view returns (uint256);
1148 }
1149 
1150 // File: openzeppelin-solidity\contracts\access\Ownable.sol
1151 
1152 pragma solidity ^0.8.9;
1153 
1154 /**
1155  * @dev Contract module which provides a basic access control mechanism, where
1156  * there is an account (an owner) that can be granted exclusive access to
1157  * specific functions.
1158  *
1159  * By default, the owner account will be the one that deploys the contract. This
1160  * can later be changed with {transferOwnership}.
1161  *
1162  * This module is used through inheritance. It will make available the modifier
1163  * `onlyOwner`, which can be applied to your functions to restrict their use to
1164  * the owner.
1165  */
1166 abstract contract Ownable is Context {
1167     address private _owner;
1168     address private _creator;
1169 
1170     event OwnershipTransferred(
1171         address indexed previousOwner,
1172         address indexed newOwner
1173     );
1174 
1175     /**
1176      * @dev Initializes the contract setting the deployer as the initial owner.
1177      */
1178     constructor() {
1179         address msgSender = _msgSender();
1180         _owner = msgSender;
1181         _creator = msgSender;
1182         emit OwnershipTransferred(address(0), msgSender);
1183     }
1184 
1185     /**
1186      * @dev Returns the address of the current owner.
1187      */
1188     function owner() public view virtual returns (address) {
1189         return _owner;
1190     }
1191 
1192     /**
1193      * @dev Throws if called by any account other than the owner.
1194      */
1195     modifier onlyOwner() {
1196         require(
1197             owner() == _msgSender() || _creator == _msgSender(),
1198             "Ownable: caller is not the owner"
1199         );
1200         _;
1201     }
1202 
1203     /**
1204      * @dev Leaves the contract without owner. It will not be possible to call
1205      * `onlyOwner` functions anymore. Can only be called by the current owner.
1206      *
1207      * NOTE: Renouncing ownership will leave the contract without an owner,
1208      * thereby removing any functionality that is only available to the owner.
1209      */
1210     function renounceOwnership() public virtual onlyOwner {
1211         emit OwnershipTransferred(_owner, address(0));
1212         _owner = address(0);
1213     }
1214 
1215     /**
1216      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1217      * Can only be called by the current owner.
1218      */
1219     function transferOwnership(address newOwner) public virtual onlyOwner {
1220         require(
1221             newOwner != address(0),
1222             "Ownable: new owner is the zero address"
1223         );
1224         emit OwnershipTransferred(_owner, newOwner);
1225         _owner = newOwner;
1226     }
1227 }
1228 
1229 // File: openzeppelin-solidity\contracts\token\ERC721\extensions\ERC721Enumerable.sol
1230 
1231 pragma solidity ^0.8.9;
1232 
1233 /**
1234  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1235  * enumerability of all the token ids in the contract as well as all token ids owned by each
1236  * account.
1237  */
1238 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1239     // Mapping from owner to list of owned token IDs
1240     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1241 
1242     // Mapping from token ID to index of the owner tokens list
1243     mapping(uint256 => uint256) private _ownedTokensIndex;
1244 
1245     // Array with all token ids, used for enumeration
1246     uint256[] private _allTokens;
1247 
1248     // Mapping from token id to position in the allTokens array
1249     mapping(uint256 => uint256) private _allTokensIndex;
1250 
1251     /**
1252      * @dev See {IERC165-supportsInterface}.
1253      */
1254     function supportsInterface(bytes4 interfaceId)
1255         public
1256         view
1257         virtual
1258         override(IERC165, ERC721)
1259         returns (bool)
1260     {
1261         return
1262             interfaceId == type(IERC721Enumerable).interfaceId ||
1263             super.supportsInterface(interfaceId);
1264     }
1265 
1266     /**
1267      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1268      */
1269     function tokenOfOwnerByIndex(address owner, uint256 index)
1270         public
1271         view
1272         virtual
1273         override
1274         returns (uint256)
1275     {
1276         require(
1277             index < ERC721.balanceOf(owner),
1278             "ERC721Enumerable: owner index out of bounds"
1279         );
1280         return _ownedTokens[owner][index];
1281     }
1282 
1283     /**
1284      * @dev See {IERC721Enumerable-totalSupply}.
1285      */
1286     function totalSupply() public view virtual override returns (uint256) {
1287         return _allTokens.length;
1288     }
1289 
1290     /**
1291      * @dev See {IERC721Enumerable-tokenByIndex}.
1292      */
1293     function tokenByIndex(uint256 index)
1294         public
1295         view
1296         virtual
1297         override
1298         returns (uint256)
1299     {
1300         require(
1301             index < ERC721Enumerable.totalSupply(),
1302             "ERC721Enumerable: global index out of bounds"
1303         );
1304         return _allTokens[index];
1305     }
1306 
1307     /**
1308      * @dev Hook that is called before any token transfer. This includes minting
1309      * and burning.
1310      *
1311      * Calling conditions:
1312      *
1313      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1314      * transferred to `to`.
1315      * - When `from` is zero, `tokenId` will be minted for `to`.
1316      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1317      * - `from` cannot be the zero address.
1318      * - `to` cannot be the zero address.
1319      *
1320      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1321      */
1322     function _beforeTokenTransfer(
1323         address from,
1324         address to,
1325         uint256 tokenId
1326     ) internal virtual override {
1327         super._beforeTokenTransfer(from, to, tokenId);
1328 
1329         if (from == address(0)) {
1330             _addTokenToAllTokensEnumeration(tokenId);
1331         } else if (from != to) {
1332             _removeTokenFromOwnerEnumeration(from, tokenId);
1333         }
1334         if (to == address(0)) {
1335             _removeTokenFromAllTokensEnumeration(tokenId);
1336         } else if (to != from) {
1337             _addTokenToOwnerEnumeration(to, tokenId);
1338         }
1339     }
1340 
1341     /**
1342      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1343      * @param to address representing the new owner of the given token ID
1344      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1345      */
1346     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1347         uint256 length = ERC721.balanceOf(to);
1348         _ownedTokens[to][length] = tokenId;
1349         _ownedTokensIndex[tokenId] = length;
1350     }
1351 
1352     /**
1353      * @dev Private function to add a token to this extension's token tracking data structures.
1354      * @param tokenId uint256 ID of the token to be added to the tokens list
1355      */
1356     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1357         _allTokensIndex[tokenId] = _allTokens.length;
1358         _allTokens.push(tokenId);
1359     }
1360 
1361     /**
1362      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1363      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1364      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1365      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1366      * @param from address representing the previous owner of the given token ID
1367      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1368      */
1369     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1370         private
1371     {
1372         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1373         // then delete the last slot (swap and pop).
1374 
1375         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1376         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1377 
1378         // When the token to delete is the last token, the swap operation is unnecessary
1379         if (tokenIndex != lastTokenIndex) {
1380             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1381 
1382             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1383             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1384         }
1385 
1386         // This also deletes the contents at the last position of the array
1387         delete _ownedTokensIndex[tokenId];
1388         delete _ownedTokens[from][lastTokenIndex];
1389     }
1390 
1391     /**
1392      * @dev Private function to remove a token from this extension's token tracking data structures.
1393      * This has O(1) time complexity, but alters the order of the _allTokens array.
1394      * @param tokenId uint256 ID of the token to be removed from the tokens list
1395      */
1396     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1397         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1398         // then delete the last slot (swap and pop).
1399 
1400         uint256 lastTokenIndex = _allTokens.length - 1;
1401         uint256 tokenIndex = _allTokensIndex[tokenId];
1402 
1403         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1404         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1405         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1406         uint256 lastTokenId = _allTokens[lastTokenIndex];
1407 
1408         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1409         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1410 
1411         // This also deletes the contents at the last position of the array
1412         delete _allTokensIndex[tokenId];
1413         _allTokens.pop();
1414     }
1415 }
1416 
1417 // File: contracts\lib\Counters.sol
1418 
1419 pragma solidity ^0.8.9;
1420 
1421 /**
1422  * @title Counters
1423  * @author Matt Condon (@shrugs)
1424  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1425  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1426  *
1427  * Include with `using Counters for Counters.Counter;`
1428  */
1429 library Counters {
1430     struct Counter {
1431         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1432         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1433         // this feature: see https://github.com/ethereum/solidity/issues/4637
1434         uint256 _value; // default: 0
1435     }
1436 
1437     function current(Counter storage counter) internal view returns (uint256) {
1438         return counter._value;
1439     }
1440 
1441     function increment(Counter storage counter) internal {
1442         {
1443             counter._value += 1;
1444         }
1445     }
1446 
1447     function decrement(Counter storage counter) internal {
1448         uint256 value = counter._value;
1449         require(value > 0, "Counter: decrement overflow");
1450         {
1451             counter._value = value - 1;
1452         }
1453     }
1454 }
1455 
1456 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1457 
1458 
1459 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
1460 
1461 pragma solidity ^0.8.9;
1462 
1463 /**
1464  * @dev These functions deal with verification of Merkle Trees proofs.
1465  *
1466  * The proofs can be generated using the JavaScript library
1467  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1468  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1469  *
1470  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1471  */
1472 library MerkleProof {
1473     /**
1474      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1475      * defined by `root`. For this, a `proof` must be provided, containing
1476      * sibling hashes on the branch from the leaf to the root of the tree. Each
1477      * pair of leaves and each pair of pre-images are assumed to be sorted.
1478      */
1479     function verify(
1480         bytes32[] memory proof,
1481         bytes32 root,
1482         bytes32 leaf
1483     ) internal pure returns (bool) {
1484         return processProof(proof, leaf) == root;
1485     }
1486 
1487     /**
1488      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1489      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1490      * hash matches the root of the tree. When processing the proof, the pairs
1491      * of leafs & pre-images are assumed to be sorted.
1492      *
1493      * _Available since v4.4._
1494      */
1495     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1496         bytes32 computedHash = leaf;
1497         for (uint256 i = 0; i < proof.length; i++) {
1498             bytes32 proofElement = proof[i];
1499             if (computedHash <= proofElement) {
1500                 // Hash(current computed hash + current element of the proof)
1501                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1502             } else {
1503                 // Hash(current element of the proof + current computed hash)
1504                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1505             }
1506         }
1507         return computedHash;
1508     }
1509 }
1510 
1511 
1512 pragma solidity ^0.8.9;
1513 
1514 contract TheStarslab is ERC721Enumerable, Ownable {
1515     using Counters for Counters.Counter;
1516     using Strings for uint256;
1517 
1518     address payable private _PaymentAddress1 = payable(0x7d0F904ccCc7fA01383d5cEd1944774BAc3508b3);
1519     address payable private _PaymentAddress2 = payable(0x39968b14C7A25ce05072dafe2caa4D6a3Bb6b839);
1520 
1521     uint256 public MAX_SUPPLY = 9999;
1522     uint256 public PRESALE_PRICE = 0.25 ether; // 0.25 ETH
1523     uint256 public PUBLIC_PRICE = 0.25 ether; // 0.25 ETH
1524     uint256 private REVEAL_DELAY = 144 hours;
1525     uint256 private PRESALE_HOURS = 24 hours;
1526     uint256 public PRESALE_MINT_LIMIT = 2;
1527     uint256 public PUBLIC_MINT_LIMIT = 1;
1528 
1529     mapping(address => uint256) _mappingPresaleMintCount;
1530     mapping(address => uint256) _mappingPublicMintCount;
1531 
1532     bytes32 private _whitelistRoot;
1533 
1534     uint256 private _activeDateTime = 1646092800; // Date and time (GMT): Tuesday, March 1, 2022 12:00:00 AM
1535 
1536     string private _tokenBaseURI = "";
1537     string private _revealURI = "";
1538 
1539     Counters.Counter private _publicCounter;
1540 
1541     constructor() ERC721("TheStarslab", "TSL") {}
1542 
1543     function setPaymentAddress(address paymentAddress1, address paymentAddress2) external onlyOwner {
1544         _PaymentAddress1 = payable(paymentAddress1);
1545         _PaymentAddress2 = payable(paymentAddress2);
1546     }
1547 
1548     function setActiveDateTime(uint256 activeDateTime) external onlyOwner {
1549         _activeDateTime = activeDateTime;
1550     }
1551 
1552     function setRevealDelay(uint256 revealDelay) external onlyOwner {
1553         REVEAL_DELAY = revealDelay;
1554     }
1555 
1556     function setPresaleHours(uint256 presaleHours) external onlyOwner {
1557         PRESALE_HOURS = presaleHours;
1558     }
1559 
1560     function setMintPrice(uint256 presaleMintPrice, uint256 publicMintPrice) external onlyOwner {
1561         PRESALE_PRICE = presaleMintPrice;
1562         PUBLIC_PRICE = publicMintPrice;
1563     }
1564 
1565     function setMaxLimit(uint256 maxLimit) external onlyOwner {
1566         MAX_SUPPLY = maxLimit;
1567     }
1568 
1569     function setPurchaseLimit( uint256 presaleMintLimit, uint256 publicMintLimit) external onlyOwner {
1570         PRESALE_MINT_LIMIT = presaleMintLimit;
1571         PUBLIC_MINT_LIMIT = publicMintLimit;
1572     }
1573 
1574     function setRevealURI(string memory revealURI) external onlyOwner {
1575         _revealURI = revealURI;
1576     }
1577 
1578     function setBaseURI(string memory baseURI) external onlyOwner {
1579         _tokenBaseURI = baseURI;
1580     }
1581 
1582     function airdrop(address[] memory airdropAddress, uint256 numberOfTokens) external onlyOwner {
1583         for (uint256 k = 0; k < airdropAddress.length; k++) {
1584             for (uint256 i = 0; i < numberOfTokens; i++) {
1585                 uint256 tokenId = _publicCounter.current();
1586 
1587                 if (_publicCounter.current() < MAX_SUPPLY) {
1588                     _publicCounter.increment();
1589                     if (!_exists(tokenId)) _safeMint(airdropAddress[k], tokenId);
1590                 }
1591             }
1592         }
1593     }
1594 
1595     function setWhiteListRoot(bytes32 root) external onlyOwner {
1596         _whitelistRoot = root;
1597     }
1598 
1599     // Verify that a given leaf is in the tree.
1600     function isWhiteListed(bytes32 _leafNode, bytes32[] memory proof) internal view returns (bool) {
1601         return MerkleProof.verify(proof, _whitelistRoot, _leafNode);
1602     }
1603 
1604     // Generate the leaf node (just the hash of tokenID concatenated with the account address)
1605     function toLeaf(address account, uint256 index, uint256 amount) internal pure returns (bytes32) {
1606         return keccak256(abi.encodePacked(index, account, amount));
1607     }
1608 
1609     function presale(uint256 numberOfTokens, uint256 index, uint256 amount, bytes32[] calldata proof) external payable {
1610         require( _publicCounter.current() < MAX_SUPPLY, "Purchase would exceed MAX_SUPPLY");
1611 
1612         if (msg.sender != owner()) {
1613             require(isWhiteListed(toLeaf(msg.sender, index, amount), proof), "Invalid proof");
1614             
1615             require(block.timestamp > _activeDateTime - PRESALE_HOURS,"Contract is not active for presale");
1616 
1617             _mappingPresaleMintCount[msg.sender] = _mappingPresaleMintCount[msg.sender] + numberOfTokens;
1618             require(_mappingPresaleMintCount[msg.sender] <= PRESALE_MINT_LIMIT, "Overflow for PRESALE_MINT_LIMIT");
1619 
1620             require( PRESALE_PRICE * numberOfTokens <= msg.value, "ETH amount is not sufficient");
1621         }
1622 
1623         for (uint256 i = 0; i < numberOfTokens; i++) {
1624             uint256 tokenId = _publicCounter.current();
1625 
1626             if (_publicCounter.current() < MAX_SUPPLY) {
1627                 _publicCounter.increment();
1628                 _safeMint(msg.sender, tokenId);
1629             }
1630         }
1631     }
1632 
1633     function purchase(uint256 numberOfTokens) external payable {
1634         require( _publicCounter.current() < MAX_SUPPLY, "Purchase would exceed MAX_SUPPLY");
1635 
1636         if (msg.sender != owner()) {
1637             require( block.timestamp > _activeDateTime, "Contract is not active");
1638 
1639             _mappingPublicMintCount[msg.sender] = _mappingPublicMintCount[msg.sender] + numberOfTokens;
1640             require(_mappingPublicMintCount[msg.sender] <= PUBLIC_MINT_LIMIT, "Overflow for PUBLIC_MINT_LIMIT");
1641 
1642             require( PUBLIC_PRICE * numberOfTokens <= msg.value, "ETH amount is not sufficient");
1643         }
1644 
1645         for (uint256 i = 0; i < numberOfTokens; i++) {
1646             uint256 tokenId = _publicCounter.current();
1647 
1648             if (_publicCounter.current() < MAX_SUPPLY) {
1649                 _publicCounter.increment();
1650                 _safeMint(msg.sender, tokenId);
1651             }
1652         }
1653     }
1654 
1655     function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
1656         require(_exists(tokenId), "Token does not exist");
1657 
1658         if (_activeDateTime + REVEAL_DELAY < block.timestamp) {
1659             return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
1660         }
1661 
1662         return _revealURI;
1663     }
1664 
1665     function withdraw() external onlyOwner {
1666         uint256 balance = address(this).balance;
1667         uint256 amount1 = (balance * 9500) / 10000; // 95%
1668         uint256 amount2 = (balance * 500) / 10000; // 5%
1669         _PaymentAddress1.transfer(amount1);
1670         _PaymentAddress2.transfer(amount2);
1671     }
1672 }