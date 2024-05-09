1 // SPDX-License-Identifier: MIT
2 
3 // Amended by HashLips
4 /**
5     !Disclaimer!
6     These contracts have been used to create tutorials,
7     and was created for the purpose to teach people
8     how to create smart contracts on the blockchain.
9     please review this code on your own before using any of
10     the following code for production.
11     HashLips will not be liable in any way if for the use 
12     of the code. That being said, the code has been tested 
13     to the best of the developers' knowledge to work as intended.
14 */
15 
16 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
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
40 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
41 pragma solidity ^0.8.0;
42 
43 /**
44  * @dev Required interface of an ERC721 compliant contract.
45  */
46 interface IERC721 is IERC165 {
47     /**
48      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
49      */
50     event Transfer(
51         address indexed from,
52         address indexed to,
53         uint256 indexed tokenId
54     );
55 
56     /**
57      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
58      */
59     event Approval(
60         address indexed owner,
61         address indexed approved,
62         uint256 indexed tokenId
63     );
64 
65     /**
66      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
67      */
68     event ApprovalForAll(
69         address indexed owner,
70         address indexed operator,
71         bool approved
72     );
73 
74     /**
75      * @dev Returns the number of tokens in ``owner``'s account.
76      */
77     function balanceOf(address owner) external view returns (uint256 balance);
78 
79     /**
80      * @dev Returns the owner of the `tokenId` token.
81      *
82      * Requirements:
83      *
84      * - `tokenId` must exist.
85      */
86     function ownerOf(uint256 tokenId) external view returns (address owner);
87 
88     /**
89      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
90      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
91      *
92      * Requirements:
93      *
94      * - `from` cannot be the zero address.
95      * - `to` cannot be the zero address.
96      * - `tokenId` token must exist and be owned by `from`.
97      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
98      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
99      *
100      * Emits a {Transfer} event.
101      */
102     function safeTransferFrom(
103         address from,
104         address to,
105         uint256 tokenId
106     ) external;
107 
108     /**
109      * @dev Transfers `tokenId` token from `from` to `to`.
110      *
111      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
112      *
113      * Requirements:
114      *
115      * - `from` cannot be the zero address.
116      * - `to` cannot be the zero address.
117      * - `tokenId` token must be owned by `from`.
118      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
119      *
120      * Emits a {Transfer} event.
121      */
122     function transferFrom(
123         address from,
124         address to,
125         uint256 tokenId
126     ) external;
127 
128     /**
129      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
130      * The approval is cleared when the token is transferred.
131      *
132      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
133      *
134      * Requirements:
135      *
136      * - The caller must own the token or be an approved operator.
137      * - `tokenId` must exist.
138      *
139      * Emits an {Approval} event.
140      */
141     function approve(address to, uint256 tokenId) external;
142 
143     /**
144      * @dev Returns the account approved for `tokenId` token.
145      *
146      * Requirements:
147      *
148      * - `tokenId` must exist.
149      */
150     function getApproved(uint256 tokenId)
151         external
152         view
153         returns (address operator);
154 
155     /**
156      * @dev Approve or remove `operator` as an operator for the caller.
157      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
158      *
159      * Requirements:
160      *
161      * - The `operator` cannot be the caller.
162      *
163      * Emits an {ApprovalForAll} event.
164      */
165     function setApprovalForAll(address operator, bool _approved) external;
166 
167     /**
168      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
169      *
170      * See {setApprovalForAll}
171      */
172     function isApprovedForAll(address owner, address operator)
173         external
174         view
175         returns (bool);
176 
177     /**
178      * @dev Safely transfers `tokenId` token from `from` to `to`.
179      *
180      * Requirements:
181      *
182      * - `from` cannot be the zero address.
183      * - `to` cannot be the zero address.
184      * - `tokenId` token must exist and be owned by `from`.
185      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
186      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
187      *
188      * Emits a {Transfer} event.
189      */
190     function safeTransferFrom(
191         address from,
192         address to,
193         uint256 tokenId,
194         bytes calldata data
195     ) external;
196 }
197 
198 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
199 pragma solidity ^0.8.0;
200 
201 /**
202  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
203  * @dev See https://eips.ethereum.org/EIPS/eip-721
204  */
205 interface IERC721Enumerable is IERC721 {
206     /**
207      * @dev Returns the total amount of tokens stored by the contract.
208      */
209     function totalSupply() external view returns (uint256);
210 
211     /**
212      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
213      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
214      */
215     function tokenOfOwnerByIndex(address owner, uint256 index)
216         external
217         view
218         returns (uint256 tokenId);
219 
220     /**
221      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
222      * Use along with {totalSupply} to enumerate all tokens.
223      */
224     function tokenByIndex(uint256 index) external view returns (uint256);
225 }
226 
227 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
228 pragma solidity ^0.8.0;
229 
230 /**
231  * @dev Implementation of the {IERC165} interface.
232  *
233  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
234  * for the additional interface id that will be supported. For example:
235  *
236  * ```solidity
237  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
238  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
239  * }
240  * ```
241  *
242  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
243  */
244 abstract contract ERC165 is IERC165 {
245     /**
246      * @dev See {IERC165-supportsInterface}.
247      */
248     function supportsInterface(bytes4 interfaceId)
249         public
250         view
251         virtual
252         override
253         returns (bool)
254     {
255         return interfaceId == type(IERC165).interfaceId;
256     }
257 }
258 
259 // File: @openzeppelin/contracts/utils/Strings.sol
260 
261 pragma solidity ^0.8.0;
262 
263 /**
264  * @dev String operations.
265  */
266 library Strings {
267     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
268 
269     /**
270      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
271      */
272     function toString(uint256 value) internal pure returns (string memory) {
273         // Inspired by OraclizeAPI's implementation - MIT licence
274         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
275 
276         if (value == 0) {
277             return "0";
278         }
279         uint256 temp = value;
280         uint256 digits;
281         while (temp != 0) {
282             digits++;
283             temp /= 10;
284         }
285         bytes memory buffer = new bytes(digits);
286         while (value != 0) {
287             digits -= 1;
288             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
289             value /= 10;
290         }
291         return string(buffer);
292     }
293 
294     /**
295      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
296      */
297     function toHexString(uint256 value) internal pure returns (string memory) {
298         if (value == 0) {
299             return "0x00";
300         }
301         uint256 temp = value;
302         uint256 length = 0;
303         while (temp != 0) {
304             length++;
305             temp >>= 8;
306         }
307         return toHexString(value, length);
308     }
309 
310     /**
311      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
312      */
313     function toHexString(uint256 value, uint256 length)
314         internal
315         pure
316         returns (string memory)
317     {
318         bytes memory buffer = new bytes(2 * length + 2);
319         buffer[0] = "0";
320         buffer[1] = "x";
321         for (uint256 i = 2 * length + 1; i > 1; --i) {
322             buffer[i] = _HEX_SYMBOLS[value & 0xf];
323             value >>= 4;
324         }
325         require(value == 0, "Strings: hex length insufficient");
326         return string(buffer);
327     }
328 }
329 
330 // File: @openzeppelin/contracts/utils/Address.sol
331 
332 pragma solidity ^0.8.0;
333 
334 /**
335  * @dev Collection of functions related to the address type
336  */
337 library Address {
338     /**
339      * @dev Returns true if `account` is a contract.
340      *
341      * [IMPORTANT]
342      * ====
343      * It is unsafe to assume that an address for which this function returns
344      * false is an externally-owned account (EOA) and not a contract.
345      *
346      * Among others, `isContract` will return false for the following
347      * types of addresses:
348      *
349      *  - an externally-owned account
350      *  - a contract in construction
351      *  - an address where a contract will be created
352      *  - an address where a contract lived, but was destroyed
353      * ====
354      */
355     function isContract(address account) internal view returns (bool) {
356         // This method relies on extcodesize, which returns 0 for contracts in
357         // construction, since the code is only stored at the end of the
358         // constructor execution.
359 
360         uint256 size;
361         assembly {
362             size := extcodesize(account)
363         }
364         return size > 0;
365     }
366 
367     /**
368      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
369      * `recipient`, forwarding all available gas and reverting on errors.
370      *
371      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
372      * of certain opcodes, possibly making contracts go over the 2300 gas limit
373      * imposed by `transfer`, making them unable to receive funds via
374      * `transfer`. {sendValue} removes this limitation.
375      *
376      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
377      *
378      * IMPORTANT: because control is transferred to `recipient`, care must be
379      * taken to not create reentrancy vulnerabilities. Consider using
380      * {ReentrancyGuard} or the
381      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
382      */
383     function sendValue(address payable recipient, uint256 amount) internal {
384         require(
385             address(this).balance >= amount,
386             "Address: insufficient balance"
387         );
388 
389         (bool success, ) = recipient.call{value: amount}("");
390         require(
391             success,
392             "Address: unable to send value, recipient may have reverted"
393         );
394     }
395 
396     /**
397      * @dev Performs a Solidity function call using a low level `call`. A
398      * plain `call` is an unsafe replacement for a function call: use this
399      * function instead.
400      *
401      * If `target` reverts with a revert reason, it is bubbled up by this
402      * function (like regular Solidity function calls).
403      *
404      * Returns the raw returned data. To convert to the expected return value,
405      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
406      *
407      * Requirements:
408      *
409      * - `target` must be a contract.
410      * - calling `target` with `data` must not revert.
411      *
412      * _Available since v3.1._
413      */
414     function functionCall(address target, bytes memory data)
415         internal
416         returns (bytes memory)
417     {
418         return functionCall(target, data, "Address: low-level call failed");
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
423      * `errorMessage` as a fallback revert reason when `target` reverts.
424      *
425      * _Available since v3.1._
426      */
427     function functionCall(
428         address target,
429         bytes memory data,
430         string memory errorMessage
431     ) internal returns (bytes memory) {
432         return functionCallWithValue(target, data, 0, errorMessage);
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
437      * but also transferring `value` wei to `target`.
438      *
439      * Requirements:
440      *
441      * - the calling contract must have an ETH balance of at least `value`.
442      * - the called Solidity function must be `payable`.
443      *
444      * _Available since v3.1._
445      */
446     function functionCallWithValue(
447         address target,
448         bytes memory data,
449         uint256 value
450     ) internal returns (bytes memory) {
451         return
452             functionCallWithValue(
453                 target,
454                 data,
455                 value,
456                 "Address: low-level call with value failed"
457             );
458     }
459 
460     /**
461      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
462      * with `errorMessage` as a fallback revert reason when `target` reverts.
463      *
464      * _Available since v3.1._
465      */
466     function functionCallWithValue(
467         address target,
468         bytes memory data,
469         uint256 value,
470         string memory errorMessage
471     ) internal returns (bytes memory) {
472         require(
473             address(this).balance >= value,
474             "Address: insufficient balance for call"
475         );
476         require(isContract(target), "Address: call to non-contract");
477 
478         (bool success, bytes memory returndata) = target.call{value: value}(
479             data
480         );
481         return verifyCallResult(success, returndata, errorMessage);
482     }
483 
484     /**
485      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
486      * but performing a static call.
487      *
488      * _Available since v3.3._
489      */
490     function functionStaticCall(address target, bytes memory data)
491         internal
492         view
493         returns (bytes memory)
494     {
495         return
496             functionStaticCall(
497                 target,
498                 data,
499                 "Address: low-level static call failed"
500             );
501     }
502 
503     /**
504      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
505      * but performing a static call.
506      *
507      * _Available since v3.3._
508      */
509     function functionStaticCall(
510         address target,
511         bytes memory data,
512         string memory errorMessage
513     ) internal view returns (bytes memory) {
514         require(isContract(target), "Address: static call to non-contract");
515 
516         (bool success, bytes memory returndata) = target.staticcall(data);
517         return verifyCallResult(success, returndata, errorMessage);
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
522      * but performing a delegate call.
523      *
524      * _Available since v3.4._
525      */
526     function functionDelegateCall(address target, bytes memory data)
527         internal
528         returns (bytes memory)
529     {
530         return
531             functionDelegateCall(
532                 target,
533                 data,
534                 "Address: low-level delegate call failed"
535             );
536     }
537 
538     /**
539      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
540      * but performing a delegate call.
541      *
542      * _Available since v3.4._
543      */
544     function functionDelegateCall(
545         address target,
546         bytes memory data,
547         string memory errorMessage
548     ) internal returns (bytes memory) {
549         require(isContract(target), "Address: delegate call to non-contract");
550 
551         (bool success, bytes memory returndata) = target.delegatecall(data);
552         return verifyCallResult(success, returndata, errorMessage);
553     }
554 
555     /**
556      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
557      * revert reason using the provided one.
558      *
559      * _Available since v4.3._
560      */
561     function verifyCallResult(
562         bool success,
563         bytes memory returndata,
564         string memory errorMessage
565     ) internal pure returns (bytes memory) {
566         if (success) {
567             return returndata;
568         } else {
569             // Look for revert reason and bubble it up if present
570             if (returndata.length > 0) {
571                 // The easiest way to bubble the revert reason is using memory via assembly
572 
573                 assembly {
574                     let returndata_size := mload(returndata)
575                     revert(add(32, returndata), returndata_size)
576                 }
577             } else {
578                 revert(errorMessage);
579             }
580         }
581     }
582 }
583 
584 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
585 
586 pragma solidity ^0.8.0;
587 
588 /**
589  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
590  * @dev See https://eips.ethereum.org/EIPS/eip-721
591  */
592 interface IERC721Metadata is IERC721 {
593     /**
594      * @dev Returns the token collection name.
595      */
596     function name() external view returns (string memory);
597 
598     /**
599      * @dev Returns the token collection symbol.
600      */
601     function symbol() external view returns (string memory);
602 
603     /**
604      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
605      */
606     function tokenURI(uint256 tokenId) external view returns (string memory);
607 }
608 
609 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
610 
611 pragma solidity ^0.8.0;
612 
613 /**
614  * @title ERC721 token receiver interface
615  * @dev Interface for any contract that wants to support safeTransfers
616  * from ERC721 asset contracts.
617  */
618 interface IERC721Receiver {
619     /**
620      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
621      * by `operator` from `from`, this function is called.
622      *
623      * It must return its Solidity selector to confirm the token transfer.
624      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
625      *
626      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
627      */
628     function onERC721Received(
629         address operator,
630         address from,
631         uint256 tokenId,
632         bytes calldata data
633     ) external returns (bytes4);
634 }
635 
636 // File: @openzeppelin/contracts/utils/Context.sol
637 pragma solidity ^0.8.0;
638 
639 /**
640  * @dev Provides information about the current execution context, including the
641  * sender of the transaction and its data. While these are generally available
642  * via msg.sender and msg.data, they should not be accessed in such a direct
643  * manner, since when dealing with meta-transactions the account sending and
644  * paying for execution may not be the actual sender (as far as an application
645  * is concerned).
646  *
647  * This contract is only required for intermediate, library-like contracts.
648  */
649 abstract contract Context {
650     function _msgSender() internal view virtual returns (address) {
651         return msg.sender;
652     }
653 
654     function _msgData() internal view virtual returns (bytes calldata) {
655         return msg.data;
656     }
657 }
658 
659 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
660 pragma solidity ^0.8.0;
661 
662 /**
663  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
664  * the Metadata extension, but not including the Enumerable extension, which is available separately as
665  * {ERC721Enumerable}.
666  */
667 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
668     using Address for address;
669     using Strings for uint256;
670 
671     // Token name
672     string private _name;
673 
674     // Token symbol
675     string private _symbol;
676 
677     // Mapping from token ID to owner address
678     mapping(uint256 => address) private _owners;
679 
680     // Mapping owner address to token count
681     mapping(address => uint256) private _balances;
682 
683     // Mapping from token ID to approved address
684     mapping(uint256 => address) private _tokenApprovals;
685 
686     // Mapping from owner to operator approvals
687     mapping(address => mapping(address => bool)) private _operatorApprovals;
688 
689     /**
690      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
691      */
692     constructor(string memory name_, string memory symbol_) {
693         _name = name_;
694         _symbol = symbol_;
695     }
696 
697     /**
698      * @dev See {IERC165-supportsInterface}.
699      */
700     function supportsInterface(bytes4 interfaceId)
701         public
702         view
703         virtual
704         override(ERC165, IERC165)
705         returns (bool)
706     {
707         return
708             interfaceId == type(IERC721).interfaceId ||
709             interfaceId == type(IERC721Metadata).interfaceId ||
710             super.supportsInterface(interfaceId);
711     }
712 
713     /**
714      * @dev See {IERC721-balanceOf}.
715      */
716     function balanceOf(address owner)
717         public
718         view
719         virtual
720         override
721         returns (uint256)
722     {
723         require(
724             owner != address(0),
725             "ERC721: balance query for the zero address"
726         );
727         return _balances[owner];
728     }
729 
730     /**
731      * @dev See {IERC721-ownerOf}.
732      */
733     function ownerOf(uint256 tokenId)
734         public
735         view
736         virtual
737         override
738         returns (address)
739     {
740         address owner = _owners[tokenId];
741         require(
742             owner != address(0),
743             "ERC721: owner query for nonexistent token"
744         );
745         return owner;
746     }
747 
748     /**
749      * @dev See {IERC721Metadata-name}.
750      */
751     function name() public view virtual override returns (string memory) {
752         return _name;
753     }
754 
755     /**
756      * @dev See {IERC721Metadata-symbol}.
757      */
758     function symbol() public view virtual override returns (string memory) {
759         return _symbol;
760     }
761 
762     /**
763      * @dev See {IERC721Metadata-tokenURI}.
764      */
765     function tokenURI(uint256 tokenId)
766         public
767         view
768         virtual
769         override
770         returns (string memory)
771     {
772         require(
773             _exists(tokenId),
774             "ERC721Metadata: URI query for nonexistent token"
775         );
776 
777         string memory baseURI = _baseURI();
778         return
779             bytes(baseURI).length > 0
780                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
781                 : "";
782     }
783 
784     /**
785      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
786      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
787      * by default, can be overriden in child contracts.
788      */
789     function _baseURI() internal view virtual returns (string memory) {
790         return "";
791     }
792 
793     /**
794      * @dev See {IERC721-approve}.
795      */
796     function approve(address to, uint256 tokenId) public virtual override {
797         address owner = ERC721.ownerOf(tokenId);
798         require(to != owner, "ERC721: approval to current owner");
799 
800         require(
801             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
802             "ERC721: approve caller is not owner nor approved for all"
803         );
804 
805         _approve(to, tokenId);
806     }
807 
808     /**
809      * @dev See {IERC721-getApproved}.
810      */
811     function getApproved(uint256 tokenId)
812         public
813         view
814         virtual
815         override
816         returns (address)
817     {
818         require(
819             _exists(tokenId),
820             "ERC721: approved query for nonexistent token"
821         );
822 
823         return _tokenApprovals[tokenId];
824     }
825 
826     /**
827      * @dev See {IERC721-setApprovalForAll}.
828      */
829     function setApprovalForAll(address operator, bool approved)
830         public
831         virtual
832         override
833     {
834         require(operator != _msgSender(), "ERC721: approve to caller");
835 
836         _operatorApprovals[_msgSender()][operator] = approved;
837         emit ApprovalForAll(_msgSender(), operator, approved);
838     }
839 
840     /**
841      * @dev See {IERC721-isApprovedForAll}.
842      */
843     function isApprovedForAll(address owner, address operator)
844         public
845         view
846         virtual
847         override
848         returns (bool)
849     {
850         return _operatorApprovals[owner][operator];
851     }
852 
853     /**
854      * @dev See {IERC721-transferFrom}.
855      */
856     function transferFrom(
857         address from,
858         address to,
859         uint256 tokenId
860     ) public virtual override {
861         //solhint-disable-next-line max-line-length
862         require(
863             _isApprovedOrOwner(_msgSender(), tokenId),
864             "ERC721: transfer caller is not owner nor approved"
865         );
866 
867         _transfer(from, to, tokenId);
868     }
869 
870     /**
871      * @dev See {IERC721-safeTransferFrom}.
872      */
873     function safeTransferFrom(
874         address from,
875         address to,
876         uint256 tokenId
877     ) public virtual override {
878         safeTransferFrom(from, to, tokenId, "");
879     }
880 
881     /**
882      * @dev See {IERC721-safeTransferFrom}.
883      */
884     function safeTransferFrom(
885         address from,
886         address to,
887         uint256 tokenId,
888         bytes memory _data
889     ) public virtual override {
890         require(
891             _isApprovedOrOwner(_msgSender(), tokenId),
892             "ERC721: transfer caller is not owner nor approved"
893         );
894         _safeTransfer(from, to, tokenId, _data);
895     }
896 
897     /**
898      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
899      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
900      *
901      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
902      *
903      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
904      * implement alternative mechanisms to perform token transfer, such as signature-based.
905      *
906      * Requirements:
907      *
908      * - `from` cannot be the zero address.
909      * - `to` cannot be the zero address.
910      * - `tokenId` token must exist and be owned by `from`.
911      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
912      *
913      * Emits a {Transfer} event.
914      */
915     function _safeTransfer(
916         address from,
917         address to,
918         uint256 tokenId,
919         bytes memory _data
920     ) internal virtual {
921         _transfer(from, to, tokenId);
922         require(
923             _checkOnERC721Received(from, to, tokenId, _data),
924             "ERC721: transfer to non ERC721Receiver implementer"
925         );
926     }
927 
928     /**
929      * @dev Returns whether `tokenId` exists.
930      *
931      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
932      *
933      * Tokens start existing when they are minted (`_mint`),
934      * and stop existing when they are burned (`_burn`).
935      */
936     function _exists(uint256 tokenId) internal view virtual returns (bool) {
937         return _owners[tokenId] != address(0);
938     }
939 
940     /**
941      * @dev Returns whether `spender` is allowed to manage `tokenId`.
942      *
943      * Requirements:
944      *
945      * - `tokenId` must exist.
946      */
947     function _isApprovedOrOwner(address spender, uint256 tokenId)
948         internal
949         view
950         virtual
951         returns (bool)
952     {
953         require(
954             _exists(tokenId),
955             "ERC721: operator query for nonexistent token"
956         );
957         address owner = ERC721.ownerOf(tokenId);
958         return (spender == owner ||
959             getApproved(tokenId) == spender ||
960             isApprovedForAll(owner, spender));
961     }
962 
963     /**
964      * @dev Safely mints `tokenId` and transfers it to `to`.
965      *
966      * Requirements:
967      *
968      * - `tokenId` must not exist.
969      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
970      *
971      * Emits a {Transfer} event.
972      */
973     function _safeMint(address to, uint256 tokenId) internal virtual {
974         _safeMint(to, tokenId, "");
975     }
976 
977     /**
978      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
979      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
980      */
981     function _safeMint(
982         address to,
983         uint256 tokenId,
984         bytes memory _data
985     ) internal virtual {
986         _mint(to, tokenId);
987         require(
988             _checkOnERC721Received(address(0), to, tokenId, _data),
989             "ERC721: transfer to non ERC721Receiver implementer"
990         );
991     }
992 
993     /**
994      * @dev Mints `tokenId` and transfers it to `to`.
995      *
996      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
997      *
998      * Requirements:
999      *
1000      * - `tokenId` must not exist.
1001      * - `to` cannot be the zero address.
1002      *
1003      * Emits a {Transfer} event.
1004      */
1005     function _mint(address to, uint256 tokenId) internal virtual {
1006         require(to != address(0), "ERC721: mint to the zero address");
1007         require(!_exists(tokenId), "ERC721: token already minted");
1008 
1009         _beforeTokenTransfer(address(0), to, tokenId);
1010 
1011         _balances[to] += 1;
1012         _owners[tokenId] = to;
1013 
1014         emit Transfer(address(0), to, tokenId);
1015     }
1016 
1017     /**
1018      * @dev Destroys `tokenId`.
1019      * The approval is cleared when the token is burned.
1020      *
1021      * Requirements:
1022      *
1023      * - `tokenId` must exist.
1024      *
1025      * Emits a {Transfer} event.
1026      */
1027     function _burn(uint256 tokenId) internal virtual {
1028         address owner = ERC721.ownerOf(tokenId);
1029 
1030         _beforeTokenTransfer(owner, address(0), tokenId);
1031 
1032         // Clear approvals
1033         _approve(address(0), tokenId);
1034 
1035         _balances[owner] -= 1;
1036         delete _owners[tokenId];
1037 
1038         emit Transfer(owner, address(0), tokenId);
1039     }
1040 
1041     /**
1042      * @dev Transfers `tokenId` from `from` to `to`.
1043      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1044      *
1045      * Requirements:
1046      *
1047      * - `to` cannot be the zero address.
1048      * - `tokenId` token must be owned by `from`.
1049      *
1050      * Emits a {Transfer} event.
1051      */
1052     function _transfer(
1053         address from,
1054         address to,
1055         uint256 tokenId
1056     ) internal virtual {
1057         require(
1058             ERC721.ownerOf(tokenId) == from,
1059             "ERC721: transfer of token that is not own"
1060         );
1061         require(to != address(0), "ERC721: transfer to the zero address");
1062 
1063         _beforeTokenTransfer(from, to, tokenId);
1064 
1065         // Clear approvals from the previous owner
1066         _approve(address(0), tokenId);
1067 
1068         _balances[from] -= 1;
1069         _balances[to] += 1;
1070         _owners[tokenId] = to;
1071 
1072         emit Transfer(from, to, tokenId);
1073     }
1074 
1075     /**
1076      * @dev Approve `to` to operate on `tokenId`
1077      *
1078      * Emits a {Approval} event.
1079      */
1080     function _approve(address to, uint256 tokenId) internal virtual {
1081         _tokenApprovals[tokenId] = to;
1082         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1083     }
1084 
1085     /**
1086      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1087      * The call is not executed if the target address is not a contract.
1088      *
1089      * @param from address representing the previous owner of the given token ID
1090      * @param to target address that will receive the tokens
1091      * @param tokenId uint256 ID of the token to be transferred
1092      * @param _data bytes optional data to send along with the call
1093      * @return bool whether the call correctly returned the expected magic value
1094      */
1095     function _checkOnERC721Received(
1096         address from,
1097         address to,
1098         uint256 tokenId,
1099         bytes memory _data
1100     ) private returns (bool) {
1101         if (to.isContract()) {
1102             try
1103                 IERC721Receiver(to).onERC721Received(
1104                     _msgSender(),
1105                     from,
1106                     tokenId,
1107                     _data
1108                 )
1109             returns (bytes4 retval) {
1110                 return retval == IERC721Receiver.onERC721Received.selector;
1111             } catch (bytes memory reason) {
1112                 if (reason.length == 0) {
1113                     revert(
1114                         "ERC721: transfer to non ERC721Receiver implementer"
1115                     );
1116                 } else {
1117                     assembly {
1118                         revert(add(32, reason), mload(reason))
1119                     }
1120                 }
1121             }
1122         } else {
1123             return true;
1124         }
1125     }
1126 
1127     /**
1128      * @dev Hook that is called before any token transfer. This includes minting
1129      * and burning.
1130      *
1131      * Calling conditions:
1132      *
1133      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1134      * transferred to `to`.
1135      * - When `from` is zero, `tokenId` will be minted for `to`.
1136      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1137      * - `from` and `to` are never both zero.
1138      *
1139      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1140      */
1141     function _beforeTokenTransfer(
1142         address from,
1143         address to,
1144         uint256 tokenId
1145     ) internal virtual {}
1146 }
1147 
1148 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1149 
1150 pragma solidity ^0.8.0;
1151 
1152 /**
1153  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1154  * enumerability of all the token ids in the contract as well as all token ids owned by each
1155  * account.
1156  */
1157 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1158     // Mapping from owner to list of owned token IDs
1159     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1160 
1161     // Mapping from token ID to index of the owner tokens list
1162     mapping(uint256 => uint256) private _ownedTokensIndex;
1163 
1164     // Array with all token ids, used for enumeration
1165     uint256[] private _allTokens;
1166 
1167     // Mapping from token id to position in the allTokens array
1168     mapping(uint256 => uint256) private _allTokensIndex;
1169 
1170     /**
1171      * @dev See {IERC165-supportsInterface}.
1172      */
1173     function supportsInterface(bytes4 interfaceId)
1174         public
1175         view
1176         virtual
1177         override(IERC165, ERC721)
1178         returns (bool)
1179     {
1180         return
1181             interfaceId == type(IERC721Enumerable).interfaceId ||
1182             super.supportsInterface(interfaceId);
1183     }
1184 
1185     /**
1186      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1187      */
1188     function tokenOfOwnerByIndex(address owner, uint256 index)
1189         public
1190         view
1191         virtual
1192         override
1193         returns (uint256)
1194     {
1195         require(
1196             index < ERC721.balanceOf(owner),
1197             "ERC721Enumerable: owner index out of bounds"
1198         );
1199         return _ownedTokens[owner][index];
1200     }
1201 
1202     /**
1203      * @dev See {IERC721Enumerable-totalSupply}.
1204      */
1205     function totalSupply() public view virtual override returns (uint256) {
1206         return _allTokens.length;
1207     }
1208 
1209     /**
1210      * @dev See {IERC721Enumerable-tokenByIndex}.
1211      */
1212     function tokenByIndex(uint256 index)
1213         public
1214         view
1215         virtual
1216         override
1217         returns (uint256)
1218     {
1219         require(
1220             index < ERC721Enumerable.totalSupply(),
1221             "ERC721Enumerable: global index out of bounds"
1222         );
1223         return _allTokens[index];
1224     }
1225 
1226     /**
1227      * @dev Hook that is called before any token transfer. This includes minting
1228      * and burning.
1229      *
1230      * Calling conditions:
1231      *
1232      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1233      * transferred to `to`.
1234      * - When `from` is zero, `tokenId` will be minted for `to`.
1235      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1236      * - `from` cannot be the zero address.
1237      * - `to` cannot be the zero address.
1238      *
1239      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1240      */
1241     function _beforeTokenTransfer(
1242         address from,
1243         address to,
1244         uint256 tokenId
1245     ) internal virtual override {
1246         super._beforeTokenTransfer(from, to, tokenId);
1247 
1248         if (from == address(0)) {
1249             _addTokenToAllTokensEnumeration(tokenId);
1250         } else if (from != to) {
1251             _removeTokenFromOwnerEnumeration(from, tokenId);
1252         }
1253         if (to == address(0)) {
1254             _removeTokenFromAllTokensEnumeration(tokenId);
1255         } else if (to != from) {
1256             _addTokenToOwnerEnumeration(to, tokenId);
1257         }
1258     }
1259 
1260     /**
1261      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1262      * @param to address representing the new owner of the given token ID
1263      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1264      */
1265     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1266         uint256 length = ERC721.balanceOf(to);
1267         _ownedTokens[to][length] = tokenId;
1268         _ownedTokensIndex[tokenId] = length;
1269     }
1270 
1271     /**
1272      * @dev Private function to add a token to this extension's token tracking data structures.
1273      * @param tokenId uint256 ID of the token to be added to the tokens list
1274      */
1275     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1276         _allTokensIndex[tokenId] = _allTokens.length;
1277         _allTokens.push(tokenId);
1278     }
1279 
1280     /**
1281      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1282      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1283      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1284      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1285      * @param from address representing the previous owner of the given token ID
1286      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1287      */
1288     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1289         private
1290     {
1291         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1292         // then delete the last slot (swap and pop).
1293 
1294         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1295         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1296 
1297         // When the token to delete is the last token, the swap operation is unnecessary
1298         if (tokenIndex != lastTokenIndex) {
1299             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1300 
1301             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1302             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1303         }
1304 
1305         // This also deletes the contents at the last position of the array
1306         delete _ownedTokensIndex[tokenId];
1307         delete _ownedTokens[from][lastTokenIndex];
1308     }
1309 
1310     /**
1311      * @dev Private function to remove a token from this extension's token tracking data structures.
1312      * This has O(1) time complexity, but alters the order of the _allTokens array.
1313      * @param tokenId uint256 ID of the token to be removed from the tokens list
1314      */
1315     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1316         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1317         // then delete the last slot (swap and pop).
1318 
1319         uint256 lastTokenIndex = _allTokens.length - 1;
1320         uint256 tokenIndex = _allTokensIndex[tokenId];
1321 
1322         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1323         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1324         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1325         uint256 lastTokenId = _allTokens[lastTokenIndex];
1326 
1327         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1328         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1329 
1330         // This also deletes the contents at the last position of the array
1331         delete _allTokensIndex[tokenId];
1332         _allTokens.pop();
1333     }
1334 }
1335 
1336 // File: @openzeppelin/contracts/access/Ownable.sol
1337 pragma solidity ^0.8.0;
1338 
1339 /**
1340  * @dev Contract module which provides a basic access control mechanism, where
1341  * there is an account (an owner) that can be granted exclusive access to
1342  * specific functions.
1343  *
1344  * By default, the owner account will be the one that deploys the contract. This
1345  * can later be changed with {transferOwnership}.
1346  *
1347  * This module is used through inheritance. It will make available the modifier
1348  * `onlyOwner`, which can be applied to your functions to restrict their use to
1349  * the owner.
1350  */
1351 abstract contract Ownable is Context {
1352     address private _owner;
1353 
1354     event OwnershipTransferred(
1355         address indexed previousOwner,
1356         address indexed newOwner
1357     );
1358 
1359     /**
1360      * @dev Initializes the contract setting the deployer as the initial owner.
1361      */
1362     constructor() {
1363         _setOwner(_msgSender());
1364     }
1365 
1366     /**
1367      * @dev Returns the address of the current owner.
1368      */
1369     function owner() public view virtual returns (address) {
1370         return _owner;
1371     }
1372 
1373     /**
1374      * @dev Throws if called by any account other than the owner.
1375      */
1376     modifier onlyOwner() {
1377         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1378         _;
1379     }
1380 
1381     /**
1382      * @dev Leaves the contract without owner. It will not be possible to call
1383      * `onlyOwner` functions anymore. Can only be called by the current owner.
1384      *
1385      * NOTE: Renouncing ownership will leave the contract without an owner,
1386      * thereby removing any functionality that is only available to the owner.
1387      */
1388     function renounceOwnership() public virtual onlyOwner {
1389         _setOwner(address(0));
1390     }
1391 
1392     /**
1393      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1394      * Can only be called by the current owner.
1395      */
1396     function transferOwnership(address newOwner) public virtual onlyOwner {
1397         require(
1398             newOwner != address(0),
1399             "Ownable: new owner is the zero address"
1400         );
1401         _setOwner(newOwner);
1402     }
1403 
1404     function _setOwner(address newOwner) private {
1405         address oldOwner = _owner;
1406         _owner = newOwner;
1407         emit OwnershipTransferred(oldOwner, newOwner);
1408     }
1409 }
1410 
1411 pragma solidity >=0.7.0 <0.9.0;
1412 
1413 contract RipEthereum is ERC721Enumerable, Ownable {
1414     using Strings for uint256;
1415 
1416     string baseURI;
1417     string public baseExtension = ".json";
1418     uint256 public phaseOneCost = 0 ether;
1419     uint256 public phaseTwoCost = 0.01 ether;
1420     uint256 public maxSupply = 3333;
1421     uint256 public phaseOneSupply = 1500;
1422     uint256 public maxMintAmountPerTransaction = 5;
1423     uint256 public maxMintAmountPerWalletNonGotRektPhaseOne = 1;
1424     uint256 public maxMintAmountPerWalletPhaseTwo = 2;
1425     bool public paused = false;
1426     bool public isWhitelistOnly = true;
1427     mapping(address => bool) public whitelisted;
1428     address public gotRektAddress = 0x2aE61706433A65C5776E7BcbC94C3eF7422F84db;
1429 
1430     constructor(
1431         string memory _name,
1432         string memory _symbol,
1433         string memory _initBaseURI
1434     ) ERC721(_name, _symbol) {
1435         setBaseURI(_initBaseURI);
1436         mint(10);
1437     }
1438 
1439     // internal
1440     function _baseURI() internal view virtual override returns (string memory) {
1441         return baseURI;
1442     }
1443 
1444     // public
1445     function mint(uint256 _mintAmount) public payable {
1446         uint256 supply = totalSupply();
1447         require(!paused);
1448         require(_mintAmount > 0);
1449         require(supply + _mintAmount <= maxSupply);
1450 
1451         if (msg.sender != owner()) {
1452             require(_mintAmount <= maxMintAmountPerTransaction);
1453             require(balanceOf(msg.sender) + _mintAmount <= getMaxMintAmountPerWallet());
1454             require(msg.value >= getCost() * _mintAmount);
1455             if (isWhitelistOnly) {
1456                 require(whitelisted[msg.sender] == true);
1457             }
1458         }
1459 
1460         for (uint256 i = 1; i <= _mintAmount; i++) {
1461             _safeMint(msg.sender, supply + i);
1462         }
1463     }
1464 
1465     function walletOfOwner(address _owner)
1466         public
1467         view
1468         returns (uint256[] memory)
1469     {
1470         uint256 ownerTokenCount = balanceOf(_owner);
1471         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1472         for (uint256 i; i < ownerTokenCount; i++) {
1473             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1474         }
1475         return tokenIds;
1476     }
1477 
1478     function tokenURI(uint256 tokenId)
1479         public
1480         view
1481         virtual
1482         override
1483         returns (string memory)
1484     {
1485         require(
1486             _exists(tokenId),
1487             "ERC721Metadata: URI query for nonexistent token"
1488         );
1489         string memory currentBaseURI = _baseURI();
1490         return
1491             bytes(currentBaseURI).length > 0
1492                 ? string(
1493                     abi.encodePacked(
1494                         currentBaseURI,
1495                         tokenId.toString(),
1496                         baseExtension
1497                     )
1498                 )
1499                 : "";
1500     }
1501 
1502     function getCost() public view returns (uint256 cost) {
1503         return getIsPhaseOne() ? phaseOneCost : phaseTwoCost;
1504     }
1505 
1506     function getIsPhaseOne() public view returns (bool isPhaseOne) {
1507         return totalSupply() < phaseOneSupply;
1508     }
1509 
1510     function getMaxMintAmountPerWallet()
1511         public
1512         view
1513         returns (uint256 maxMintAmountPerWallet)
1514     {
1515         if (getIsPhaseOne()) {
1516             if (whitelisted[msg.sender]) {
1517                 uint256 gotRektBalance = getGotRektBalance();
1518                 if (gotRektBalance > 0) return gotRektBalance;
1519             }
1520             return maxMintAmountPerWalletNonGotRektPhaseOne;
1521         }
1522         else {
1523             return maxMintAmountPerWalletPhaseTwo;
1524         }
1525     }
1526 
1527     //only owner
1528     function setPhaseOneCost(uint256 _newCost) public onlyOwner {
1529         phaseOneCost = _newCost;
1530     }
1531 
1532     function setPhaseTwoCost(uint256 _newCost) public onlyOwner {
1533         phaseTwoCost = _newCost;
1534     }
1535 
1536     function setPhaseOneSupply(uint256 _newSupply) public onlyOwner {
1537         phaseOneSupply = _newSupply;
1538     }
1539 
1540     function setmaxMintAmountPerTransaction(
1541         uint256 _newmaxMintAmountPerTransaction
1542     ) public onlyOwner {
1543         maxMintAmountPerTransaction = _newmaxMintAmountPerTransaction;
1544     }
1545 
1546     function setmaxMintAmountPerWalletNonGotRektPhaseOne(
1547         uint256 _newmaxMintAmountPerWallet
1548     ) public onlyOwner {
1549         maxMintAmountPerWalletNonGotRektPhaseOne = _newmaxMintAmountPerWallet;
1550     }
1551 
1552     function setmaxMintAmountPerWalletPhaseTwo(
1553         uint256 _newmaxMintAmountPerWallet
1554     ) public onlyOwner {
1555         maxMintAmountPerWalletPhaseTwo = _newmaxMintAmountPerWallet;
1556     }
1557 
1558     function setIsWhitelistOnly(bool _state) public onlyOwner {
1559         isWhitelistOnly = _state;
1560     }
1561 
1562     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1563         baseURI = _newBaseURI;
1564     }
1565 
1566     function setBaseExtension(string memory _newBaseExtension)
1567         public
1568         onlyOwner
1569     {
1570         baseExtension = _newBaseExtension;
1571     }
1572 
1573     function pause(bool _state) public onlyOwner {
1574         paused = _state;
1575     }
1576 
1577     function whitelistUser(address _user) public onlyOwner {
1578         whitelisted[_user] = true;
1579     }
1580 
1581     function removeWhitelistUser(address _user) public onlyOwner {
1582         whitelisted[_user] = false;
1583     }
1584 
1585     function whitelistUsers(address[] calldata addresses) public onlyOwner {
1586         for (uint256 i = 0; i < addresses.length; i++) {
1587             whitelistUser(addresses[i]);
1588         }
1589     }
1590 
1591     function setGotRektAddress(address contractAddress) public onlyOwner {
1592         gotRektAddress = contractAddress;
1593     }
1594 
1595     function getGotRektBalance() public view returns (uint256 _balance) {
1596         return IERC721(gotRektAddress).balanceOf(msg.sender);
1597     }
1598 
1599     function withdraw() public payable onlyOwner {
1600         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1601         require(os);
1602     }
1603 }