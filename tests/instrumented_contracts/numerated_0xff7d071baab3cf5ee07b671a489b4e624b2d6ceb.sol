1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-21
3  */
4 
5 // SPDX-License-Identifier: MIT LICENSE
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev String operations.
12  */
13 library Strings {
14     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
15 
16     /**
17      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
18      */
19     function toString(uint256 value) internal pure returns (string memory) {
20         // Inspired by OraclizeAPI's implementation - MIT licence
21         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
22 
23         if (value == 0) {
24             return "0";
25         }
26         uint256 temp = value;
27         uint256 digits;
28         while (temp != 0) {
29             digits++;
30             temp /= 10;
31         }
32         bytes memory buffer = new bytes(digits);
33         while (value != 0) {
34             digits -= 1;
35             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
36             value /= 10;
37         }
38         return string(buffer);
39     }
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
43      */
44     function toHexString(uint256 value) internal pure returns (string memory) {
45         if (value == 0) {
46             return "0x00";
47         }
48         uint256 temp = value;
49         uint256 length = 0;
50         while (temp != 0) {
51             length++;
52             temp >>= 8;
53         }
54         return toHexString(value, length);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
59      */
60     function toHexString(uint256 value, uint256 length)
61         internal
62         pure
63         returns (string memory)
64     {
65         bytes memory buffer = new bytes(2 * length + 2);
66         buffer[0] = "0";
67         buffer[1] = "x";
68         for (uint256 i = 2 * length + 1; i > 1; --i) {
69             buffer[i] = _HEX_SYMBOLS[value & 0xf];
70             value >>= 4;
71         }
72         require(value == 0, "Strings: hex length insufficient");
73         return string(buffer);
74     }
75 }
76 
77 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
78 pragma solidity ^0.8.1;
79 
80 /**
81  * @dev Collection of functions related to the address type
82  */
83 library Address {
84     /**
85      * @dev Returns true if `account` is a contract.
86      *
87      * [IMPORTANT]
88      * ====
89      * It is unsafe to assume that an address for which this function returns
90      * false is an externally-owned account (EOA) and not a contract.
91      *
92      * Among others, `isContract` will return false for the following
93      * types of addresses:
94      *
95      *  - an externally-owned account
96      *  - a contract in construction
97      *  - an address where a contract will be created
98      *  - an address where a contract lived, but was destroyed
99      * ====
100      *
101      * [IMPORTANT]
102      * ====
103      * You shouldn't rely on `isContract` to protect against flash loan attacks!
104      *
105      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
106      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
107      * constructor.
108      * ====
109      */
110     function isContract(address account) internal view returns (bool) {
111         // This method relies on extcodesize/address.code.length, which returns 0
112         // for contracts in construction, since the code is only stored at the end
113         // of the constructor execution.
114 
115         return account.code.length > 0;
116     }
117 
118     /**
119      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
120      * `recipient`, forwarding all available gas and reverting on errors.
121      *
122      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
123      * of certain opcodes, possibly making contracts go over the 2300 gas limit
124      * imposed by `transfer`, making them unable to receive funds via
125      * `transfer`. {sendValue} removes this limitation.
126      *
127      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
128      *
129      * IMPORTANT: because control is transferred to `recipient`, care must be
130      * taken to not create reentrancy vulnerabilities. Consider using
131      * {ReentrancyGuard} or the
132      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
133      */
134     function sendValue(address payable recipient, uint256 amount) internal {
135         require(
136             address(this).balance >= amount,
137             "Address: insufficient balance"
138         );
139 
140         (bool success, ) = recipient.call{value: amount}("");
141         require(
142             success,
143             "Address: unable to send value, recipient may have reverted"
144         );
145     }
146 
147     /**
148      * @dev Performs a Solidity function call using a low level `call`. A
149      * plain `call` is an unsafe replacement for a function call: use this
150      * function instead.
151      *
152      * If `target` reverts with a revert reason, it is bubbled up by this
153      * function (like regular Solidity function calls).
154      *
155      * Returns the raw returned data. To convert to the expected return value,
156      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
157      *
158      * Requirements:
159      *
160      * - `target` must be a contract.
161      * - calling `target` with `data` must not revert.
162      *
163      * _Available since v3.1._
164      */
165     function functionCall(address target, bytes memory data)
166         internal
167         returns (bytes memory)
168     {
169         return functionCall(target, data, "Address: low-level call failed");
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
174      * `errorMessage` as a fallback revert reason when `target` reverts.
175      *
176      * _Available since v3.1._
177      */
178     function functionCall(
179         address target,
180         bytes memory data,
181         string memory errorMessage
182     ) internal returns (bytes memory) {
183         return functionCallWithValue(target, data, 0, errorMessage);
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
188      * but also transferring `value` wei to `target`.
189      *
190      * Requirements:
191      *
192      * - the calling contract must have an ETH balance of at least `value`.
193      * - the called Solidity function must be `payable`.
194      *
195      * _Available since v3.1._
196      */
197     function functionCallWithValue(
198         address target,
199         bytes memory data,
200         uint256 value
201     ) internal returns (bytes memory) {
202         return
203             functionCallWithValue(
204                 target,
205                 data,
206                 value,
207                 "Address: low-level call with value failed"
208             );
209     }
210 
211     /**
212      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
213      * with `errorMessage` as a fallback revert reason when `target` reverts.
214      *
215      * _Available since v3.1._
216      */
217     function functionCallWithValue(
218         address target,
219         bytes memory data,
220         uint256 value,
221         string memory errorMessage
222     ) internal returns (bytes memory) {
223         require(
224             address(this).balance >= value,
225             "Address: insufficient balance for call"
226         );
227         require(isContract(target), "Address: call to non-contract");
228 
229         (bool success, bytes memory returndata) = target.call{value: value}(
230             data
231         );
232         return verifyCallResult(success, returndata, errorMessage);
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
237      * but performing a static call.
238      *
239      * _Available since v3.3._
240      */
241     function functionStaticCall(address target, bytes memory data)
242         internal
243         view
244         returns (bytes memory)
245     {
246         return
247             functionStaticCall(
248                 target,
249                 data,
250                 "Address: low-level static call failed"
251             );
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
256      * but performing a static call.
257      *
258      * _Available since v3.3._
259      */
260     function functionStaticCall(
261         address target,
262         bytes memory data,
263         string memory errorMessage
264     ) internal view returns (bytes memory) {
265         require(isContract(target), "Address: static call to non-contract");
266 
267         (bool success, bytes memory returndata) = target.staticcall(data);
268         return verifyCallResult(success, returndata, errorMessage);
269     }
270 
271     /**
272      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
273      * but performing a delegate call.
274      *
275      * _Available since v3.4._
276      */
277     function functionDelegateCall(address target, bytes memory data)
278         internal
279         returns (bytes memory)
280     {
281         return
282             functionDelegateCall(
283                 target,
284                 data,
285                 "Address: low-level delegate call failed"
286             );
287     }
288 
289     /**
290      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
291      * but performing a delegate call.
292      *
293      * _Available since v3.4._
294      */
295     function functionDelegateCall(
296         address target,
297         bytes memory data,
298         string memory errorMessage
299     ) internal returns (bytes memory) {
300         require(isContract(target), "Address: delegate call to non-contract");
301 
302         (bool success, bytes memory returndata) = target.delegatecall(data);
303         return verifyCallResult(success, returndata, errorMessage);
304     }
305 
306     /**
307      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
308      * revert reason using the provided one.
309      *
310      * _Available since v4.3._
311      */
312     function verifyCallResult(
313         bool success,
314         bytes memory returndata,
315         string memory errorMessage
316     ) internal pure returns (bytes memory) {
317         if (success) {
318             return returndata;
319         } else {
320             // Look for revert reason and bubble it up if present
321             if (returndata.length > 0) {
322                 // The easiest way to bubble the revert reason is using memory via assembly
323 
324                 assembly {
325                     let returndata_size := mload(returndata)
326                     revert(add(32, returndata), returndata_size)
327                 }
328             } else {
329                 revert(errorMessage);
330             }
331         }
332     }
333 }
334 
335 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
336 pragma solidity ^0.8.0;
337 
338 /**
339  * @title ERC721 token receiver interface
340  * @dev Interface for any contract that wants to support safeTransfers
341  * from ERC721 asset contracts.
342  */
343 interface IERC721Receiver {
344     /**
345      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
346      * by `operator` from `from`, this function is called.
347      *
348      * It must return its Solidity selector to confirm the token transfer.
349      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
350      *
351      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
352      */
353     function onERC721Received(
354         address operator,
355         address from,
356         uint256 tokenId,
357         bytes calldata data
358     ) external returns (bytes4);
359 }
360 
361 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
362 pragma solidity ^0.8.0;
363 
364 /**
365  * @dev Interface of the ERC165 standard, as defined in the
366  * https://eips.ethereum.org/EIPS/eip-165[EIP].
367  *
368  * Implementers can declare support of contract interfaces, which can then be
369  * queried by others ({ERC165Checker}).
370  *
371  * For an implementation, see {ERC165}.
372  */
373 interface IERC165 {
374     /**
375      * @dev Returns true if this contract implements the interface defined by
376      * `interfaceId`. See the corresponding
377      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
378      * to learn more about how these ids are created.
379      *
380      * This function call must use less than 30 000 gas.
381      */
382     function supportsInterface(bytes4 interfaceId) external view returns (bool);
383 }
384 
385 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
386 pragma solidity ^0.8.0;
387 
388 /**
389  * @dev Implementation of the {IERC165} interface.
390  *
391  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
392  * for the additional interface id that will be supported. For example:
393  *
394  * ```solidity
395  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
396  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
397  * }
398  * ```
399  *
400  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
401  */
402 abstract contract ERC165 is IERC165 {
403     /**
404      * @dev See {IERC165-supportsInterface}.
405      */
406     function supportsInterface(bytes4 interfaceId)
407         public
408         view
409         virtual
410         override
411         returns (bool)
412     {
413         return interfaceId == type(IERC165).interfaceId;
414     }
415 }
416 
417 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
418 pragma solidity ^0.8.0;
419 
420 /**
421  * @dev Required interface of an ERC721 compliant contract.
422  */
423 interface IERC721 is IERC165 {
424     /**
425      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
426      */
427     event Transfer(
428         address indexed from,
429         address indexed to,
430         uint256 indexed tokenId
431     );
432 
433     /**
434      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
435      */
436     event Approval(
437         address indexed owner,
438         address indexed approved,
439         uint256 indexed tokenId
440     );
441 
442     /**
443      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
444      */
445     event ApprovalForAll(
446         address indexed owner,
447         address indexed operator,
448         bool approved
449     );
450 
451     /**
452      * @dev Returns the number of tokens in ``owner``'s account.
453      */
454     function balanceOf(address owner) external view returns (uint256 balance);
455 
456     /**
457      * @dev Returns the owner of the `tokenId` token.
458      *
459      * Requirements:
460      *
461      * - `tokenId` must exist.
462      */
463     function ownerOf(uint256 tokenId) external view returns (address owner);
464 
465     /**
466      * @dev Safely transfers `tokenId` token from `from` to `to`.
467      *
468      * Requirements:
469      *
470      * - `from` cannot be the zero address.
471      * - `to` cannot be the zero address.
472      * - `tokenId` token must exist and be owned by `from`.
473      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
474      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
475      *
476      * Emits a {Transfer} event.
477      */
478     function safeTransferFrom(
479         address from,
480         address to,
481         uint256 tokenId,
482         bytes calldata data
483     ) external;
484 
485     /**
486      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
487      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
488      *
489      * Requirements:
490      *
491      * - `from` cannot be the zero address.
492      * - `to` cannot be the zero address.
493      * - `tokenId` token must exist and be owned by `from`.
494      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
495      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
496      *
497      * Emits a {Transfer} event.
498      */
499     function safeTransferFrom(
500         address from,
501         address to,
502         uint256 tokenId
503     ) external;
504 
505     /**
506      * @dev Transfers `tokenId` token from `from` to `to`.
507      *
508      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
509      *
510      * Requirements:
511      *
512      * - `from` cannot be the zero address.
513      * - `to` cannot be the zero address.
514      * - `tokenId` token must be owned by `from`.
515      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
516      *
517      * Emits a {Transfer} event.
518      */
519     function transferFrom(
520         address from,
521         address to,
522         uint256 tokenId
523     ) external;
524 
525     /**
526      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
527      * The approval is cleared when the token is transferred.
528      *
529      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
530      *
531      * Requirements:
532      *
533      * - The caller must own the token or be an approved operator.
534      * - `tokenId` must exist.
535      *
536      * Emits an {Approval} event.
537      */
538     function approve(address to, uint256 tokenId) external;
539 
540     /**
541      * @dev Approve or remove `operator` as an operator for the caller.
542      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
543      *
544      * Requirements:
545      *
546      * - The `operator` cannot be the caller.
547      *
548      * Emits an {ApprovalForAll} event.
549      */
550     function setApprovalForAll(address operator, bool _approved) external;
551 
552     /**
553      * @dev Returns the account approved for `tokenId` token.
554      *
555      * Requirements:
556      *
557      * - `tokenId` must exist.
558      */
559     function getApproved(uint256 tokenId)
560         external
561         view
562         returns (address operator);
563 
564     /**
565      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
566      *
567      * See {setApprovalForAll}
568      */
569     function isApprovedForAll(address owner, address operator)
570         external
571         view
572         returns (bool);
573 }
574 
575 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
576 pragma solidity ^0.8.0;
577 
578 /**
579  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
580  * @dev See https://eips.ethereum.org/EIPS/eip-721
581  */
582 interface IERC721Enumerable is IERC721 {
583     /**
584      * @dev Returns the total amount of tokens stored by the contract.
585      */
586     function totalSupply() external view returns (uint256);
587 
588     /**
589      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
590      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
591      */
592     function tokenOfOwnerByIndex(address owner, uint256 index)
593         external
594         view
595         returns (uint256);
596 
597     /**
598      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
599      * Use along with {totalSupply} to enumerate all tokens.
600      */
601     function tokenByIndex(uint256 index) external view returns (uint256);
602 }
603 
604 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
605 pragma solidity ^0.8.0;
606 
607 /**
608  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
609  * @dev See https://eips.ethereum.org/EIPS/eip-721
610  */
611 interface IERC721Metadata is IERC721 {
612     /**
613      * @dev Returns the token collection name.
614      */
615     function name() external view returns (string memory);
616 
617     /**
618      * @dev Returns the token collection symbol.
619      */
620     function symbol() external view returns (string memory);
621 
622     /**
623      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
624      */
625     function tokenURI(uint256 tokenId) external view returns (string memory);
626 }
627 
628 // File: @openzeppelin/contracts/utils/Context.sol
629 
630 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
631 
632 pragma solidity ^0.8.0;
633 
634 /**
635  * @dev Provides information about the current execution context, including the
636  * sender of the transaction and its data. While these are generally available
637  * via msg.sender and msg.data, they should not be accessed in such a direct
638  * manner, since when dealing with meta-transactions the account sending and
639  * paying for execution may not be the actual sender (as far as an application
640  * is concerned).
641  *
642  * This contract is only required for intermediate, library-like contracts.
643  */
644 abstract contract Context {
645     function _msgSender() internal view virtual returns (address) {
646         return msg.sender;
647     }
648 
649     function _msgData() internal view virtual returns (bytes calldata) {
650         return msg.data;
651     }
652 }
653 
654 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
655 pragma solidity ^0.8.0;
656 
657 /**
658  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
659  * the Metadata extension, but not including the Enumerable extension, which is available separately as
660  * {ERC721Enumerable}.
661  */
662 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
663     using Address for address;
664     using Strings for uint256;
665 
666     // Token name
667     string private _name;
668 
669     // Token symbol
670     string private _symbol;
671 
672     // Mapping from token ID to owner address
673     mapping(uint256 => address) private _owners;
674 
675     // Mapping owner address to token count
676     mapping(address => uint256) private _balances;
677 
678     // Mapping from token ID to approved address
679     mapping(uint256 => address) private _tokenApprovals;
680 
681     // Mapping from owner to operator approvals
682     mapping(address => mapping(address => bool)) private _operatorApprovals;
683 
684     /**
685      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
686      */
687     constructor(string memory name_, string memory symbol_) {
688         _name = name_;
689         _symbol = symbol_;
690     }
691 
692     /**
693      * @dev See {IERC165-supportsInterface}.
694      */
695     function supportsInterface(bytes4 interfaceId)
696         public
697         view
698         virtual
699         override(ERC165, IERC165)
700         returns (bool)
701     {
702         return
703             interfaceId == type(IERC721).interfaceId ||
704             interfaceId == type(IERC721Metadata).interfaceId ||
705             super.supportsInterface(interfaceId);
706     }
707 
708     /**
709      * @dev See {IERC721-balanceOf}.
710      */
711     function balanceOf(address owner)
712         public
713         view
714         virtual
715         override
716         returns (uint256)
717     {
718         require(
719             owner != address(0),
720             "ERC721: balance query for the zero address"
721         );
722         return _balances[owner];
723     }
724 
725     /**
726      * @dev See {IERC721-ownerOf}.
727      */
728     function ownerOf(uint256 tokenId)
729         public
730         view
731         virtual
732         override
733         returns (address)
734     {
735         address owner = _owners[tokenId];
736         require(
737             owner != address(0),
738             "ERC721: owner query for nonexistent token"
739         );
740         return owner;
741     }
742 
743     /**
744      * @dev See {IERC721Metadata-name}.
745      */
746     function name() public view virtual override returns (string memory) {
747         return _name;
748     }
749 
750     /**
751      * @dev See {IERC721Metadata-symbol}.
752      */
753     function symbol() public view virtual override returns (string memory) {
754         return _symbol;
755     }
756 
757     /**
758      * @dev See {IERC721Metadata-tokenURI}.
759      */
760     function tokenURI(uint256 tokenId)
761         public
762         view
763         virtual
764         override
765         returns (string memory)
766     {
767         require(
768             _exists(tokenId),
769             "ERC721Metadata: URI query for nonexistent token"
770         );
771 
772         string memory baseURI = _baseURI();
773         return
774             bytes(baseURI).length > 0
775                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
776                 : "";
777     }
778 
779     /**
780      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
781      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
782      * by default, can be overridden in child contracts.
783      */
784     function _baseURI() internal view virtual returns (string memory) {
785         return "";
786     }
787 
788     /**
789      * @dev See {IERC721-approve}.
790      */
791     function approve(address to, uint256 tokenId) public virtual override {
792         address owner = ERC721.ownerOf(tokenId);
793         require(to != owner, "ERC721: approval to current owner");
794 
795         require(
796             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
797             "ERC721: approve caller is not owner nor approved for all"
798         );
799 
800         _approve(to, tokenId);
801     }
802 
803     /**
804      * @dev See {IERC721-getApproved}.
805      */
806     function getApproved(uint256 tokenId)
807         public
808         view
809         virtual
810         override
811         returns (address)
812     {
813         require(
814             _exists(tokenId),
815             "ERC721: approved query for nonexistent token"
816         );
817 
818         return _tokenApprovals[tokenId];
819     }
820 
821     /**
822      * @dev See {IERC721-setApprovalForAll}.
823      */
824     function setApprovalForAll(address operator, bool approved)
825         public
826         virtual
827         override
828     {
829         _setApprovalForAll(_msgSender(), operator, approved);
830     }
831 
832     /**
833      * @dev See {IERC721-isApprovedForAll}.
834      */
835     function isApprovedForAll(address owner, address operator)
836         public
837         view
838         virtual
839         override
840         returns (bool)
841     {
842         return _operatorApprovals[owner][operator];
843     }
844 
845     /**
846      * @dev See {IERC721-transferFrom}.
847      */
848     function transferFrom(
849         address from,
850         address to,
851         uint256 tokenId
852     ) public virtual override {
853         //solhint-disable-next-line max-line-length
854         require(
855             _isApprovedOrOwner(_msgSender(), tokenId),
856             "ERC721: transfer caller is not owner nor approved"
857         );
858 
859         _transfer(from, to, tokenId);
860     }
861 
862     /**
863      * @dev See {IERC721-safeTransferFrom}.
864      */
865     function safeTransferFrom(
866         address from,
867         address to,
868         uint256 tokenId
869     ) public virtual override {
870         safeTransferFrom(from, to, tokenId, "");
871     }
872 
873     /**
874      * @dev See {IERC721-safeTransferFrom}.
875      */
876     function safeTransferFrom(
877         address from,
878         address to,
879         uint256 tokenId,
880         bytes memory _data
881     ) public virtual override {
882         require(
883             _isApprovedOrOwner(_msgSender(), tokenId),
884             "ERC721: transfer caller is not owner nor approved"
885         );
886         _safeTransfer(from, to, tokenId, _data);
887     }
888 
889     /**
890      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
891      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
892      *
893      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
894      *
895      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
896      * implement alternative mechanisms to perform token transfer, such as signature-based.
897      *
898      * Requirements:
899      *
900      * - `from` cannot be the zero address.
901      * - `to` cannot be the zero address.
902      * - `tokenId` token must exist and be owned by `from`.
903      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
904      *
905      * Emits a {Transfer} event.
906      */
907     function _safeTransfer(
908         address from,
909         address to,
910         uint256 tokenId,
911         bytes memory _data
912     ) internal virtual {
913         _transfer(from, to, tokenId);
914         require(
915             _checkOnERC721Received(from, to, tokenId, _data),
916             "ERC721: transfer to non ERC721Receiver implementer"
917         );
918     }
919 
920     /**
921      * @dev Returns whether `tokenId` exists.
922      *
923      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
924      *
925      * Tokens start existing when they are minted (`_mint`),
926      * and stop existing when they are burned (`_burn`).
927      */
928     function _exists(uint256 tokenId) internal view virtual returns (bool) {
929         return _owners[tokenId] != address(0);
930     }
931 
932     /**
933      * @dev Returns whether `spender` is allowed to manage `tokenId`.
934      *
935      * Requirements:
936      *
937      * - `tokenId` must exist.
938      */
939     function _isApprovedOrOwner(address spender, uint256 tokenId)
940         internal
941         view
942         virtual
943         returns (bool)
944     {
945         require(
946             _exists(tokenId),
947             "ERC721: operator query for nonexistent token"
948         );
949         address owner = ERC721.ownerOf(tokenId);
950         return (spender == owner ||
951             isApprovedForAll(owner, spender) ||
952             getApproved(tokenId) == spender);
953     }
954 
955     /**
956      * @dev Safely mints `tokenId` and transfers it to `to`.
957      *
958      * Requirements:
959      *
960      * - `tokenId` must not exist.
961      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
962      *
963      * Emits a {Transfer} event.
964      */
965     function _safeMint(address to, uint256 tokenId) internal virtual {
966         _safeMint(to, tokenId, "");
967     }
968 
969     /**
970      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
971      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
972      */
973     function _safeMint(
974         address to,
975         uint256 tokenId,
976         bytes memory _data
977     ) internal virtual {
978         _mint(to, tokenId);
979         require(
980             _checkOnERC721Received(address(0), to, tokenId, _data),
981             "ERC721: transfer to non ERC721Receiver implementer"
982         );
983     }
984 
985     /**
986      * @dev Mints `tokenId` and transfers it to `to`.
987      *
988      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
989      *
990      * Requirements:
991      *
992      * - `tokenId` must not exist.
993      * - `to` cannot be the zero address.
994      *
995      * Emits a {Transfer} event.
996      */
997     function _mint(address to, uint256 tokenId) internal virtual {
998         require(to != address(0), "ERC721: mint to the zero address");
999         require(!_exists(tokenId), "ERC721: token already minted");
1000 
1001         _beforeTokenTransfer(address(0), to, tokenId);
1002 
1003         _balances[to] += 1;
1004         _owners[tokenId] = to;
1005 
1006         emit Transfer(address(0), to, tokenId);
1007 
1008         _afterTokenTransfer(address(0), to, tokenId);
1009     }
1010 
1011     /**
1012      * @dev Destroys `tokenId`.
1013      * The approval is cleared when the token is burned.
1014      *
1015      * Requirements:
1016      *
1017      * - `tokenId` must exist.
1018      *
1019      * Emits a {Transfer} event.
1020      */
1021     function _burn(uint256 tokenId) internal virtual {
1022         address owner = ERC721.ownerOf(tokenId);
1023 
1024         _beforeTokenTransfer(owner, address(0), tokenId);
1025 
1026         // Clear approvals
1027         _approve(address(0), tokenId);
1028 
1029         _balances[owner] -= 1;
1030         delete _owners[tokenId];
1031 
1032         emit Transfer(owner, address(0), tokenId);
1033 
1034         _afterTokenTransfer(owner, address(0), tokenId);
1035     }
1036 
1037     /**
1038      * @dev Transfers `tokenId` from `from` to `to`.
1039      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1040      *
1041      * Requirements:
1042      *
1043      * - `to` cannot be the zero address.
1044      * - `tokenId` token must be owned by `from`.
1045      *
1046      * Emits a {Transfer} event.
1047      */
1048     function _transfer(
1049         address from,
1050         address to,
1051         uint256 tokenId
1052     ) internal virtual {
1053         require(
1054             ERC721.ownerOf(tokenId) == from,
1055             "ERC721: transfer from incorrect owner"
1056         );
1057         require(to != address(0), "ERC721: transfer to the zero address");
1058 
1059         _beforeTokenTransfer(from, to, tokenId);
1060 
1061         // Clear approvals from the previous owner
1062         _approve(address(0), tokenId);
1063 
1064         _balances[from] -= 1;
1065         _balances[to] += 1;
1066         _owners[tokenId] = to;
1067 
1068         emit Transfer(from, to, tokenId);
1069 
1070         _afterTokenTransfer(from, to, tokenId);
1071     }
1072 
1073     /**
1074      * @dev Approve `to` to operate on `tokenId`
1075      *
1076      * Emits a {Approval} event.
1077      */
1078     function _approve(address to, uint256 tokenId) internal virtual {
1079         _tokenApprovals[tokenId] = to;
1080         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1081     }
1082 
1083     /**
1084      * @dev Approve `operator` to operate on all of `owner` tokens
1085      *
1086      * Emits a {ApprovalForAll} event.
1087      */
1088     function _setApprovalForAll(
1089         address owner,
1090         address operator,
1091         bool approved
1092     ) internal virtual {
1093         require(owner != operator, "ERC721: approve to caller");
1094         _operatorApprovals[owner][operator] = approved;
1095         emit ApprovalForAll(owner, operator, approved);
1096     }
1097 
1098     /**
1099      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1100      * The call is not executed if the target address is not a contract.
1101      *
1102      * @param from address representing the previous owner of the given token ID
1103      * @param to target address that will receive the tokens
1104      * @param tokenId uint256 ID of the token to be transferred
1105      * @param _data bytes optional data to send along with the call
1106      * @return bool whether the call correctly returned the expected magic value
1107      */
1108     function _checkOnERC721Received(
1109         address from,
1110         address to,
1111         uint256 tokenId,
1112         bytes memory _data
1113     ) private returns (bool) {
1114         if (to.isContract()) {
1115             try
1116                 IERC721Receiver(to).onERC721Received(
1117                     _msgSender(),
1118                     from,
1119                     tokenId,
1120                     _data
1121                 )
1122             returns (bytes4 retval) {
1123                 return retval == IERC721Receiver.onERC721Received.selector;
1124             } catch (bytes memory reason) {
1125                 if (reason.length == 0) {
1126                     revert(
1127                         "ERC721: transfer to non ERC721Receiver implementer"
1128                     );
1129                 } else {
1130                     assembly {
1131                         revert(add(32, reason), mload(reason))
1132                     }
1133                 }
1134             }
1135         } else {
1136             return true;
1137         }
1138     }
1139 
1140     /**
1141      * @dev Hook that is called before any token transfer. This includes minting
1142      * and burning.
1143      *
1144      * Calling conditions:
1145      *
1146      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1147      * transferred to `to`.
1148      * - When `from` is zero, `tokenId` will be minted for `to`.
1149      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1150      * - `from` and `to` are never both zero.
1151      *
1152      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1153      */
1154     function _beforeTokenTransfer(
1155         address from,
1156         address to,
1157         uint256 tokenId
1158     ) internal virtual {}
1159 
1160     /**
1161      * @dev Hook that is called after any transfer of tokens. This includes
1162      * minting and burning.
1163      *
1164      * Calling conditions:
1165      *
1166      * - when `from` and `to` are both non-zero.
1167      * - `from` and `to` are never both zero.
1168      *
1169      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1170      */
1171     function _afterTokenTransfer(
1172         address from,
1173         address to,
1174         uint256 tokenId
1175     ) internal virtual {}
1176 }
1177 
1178 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1179 pragma solidity ^0.8.0;
1180 
1181 /**
1182  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1183  * enumerability of all the token ids in the contract as well as all token ids owned by each
1184  * account.
1185  */
1186 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1187     // Mapping from owner to list of owned token IDs
1188     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1189 
1190     // Mapping from token ID to index of the owner tokens list
1191     mapping(uint256 => uint256) private _ownedTokensIndex;
1192 
1193     // Array with all token ids, used for enumeration
1194     uint256[] private _allTokens;
1195 
1196     // Mapping from token id to position in the allTokens array
1197     mapping(uint256 => uint256) private _allTokensIndex;
1198 
1199     /**
1200      * @dev See {IERC165-supportsInterface}.
1201      */
1202     function supportsInterface(bytes4 interfaceId)
1203         public
1204         view
1205         virtual
1206         override(IERC165, ERC721)
1207         returns (bool)
1208     {
1209         return
1210             interfaceId == type(IERC721Enumerable).interfaceId ||
1211             super.supportsInterface(interfaceId);
1212     }
1213 
1214     /**
1215      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1216      */
1217     function tokenOfOwnerByIndex(address owner, uint256 index)
1218         public
1219         view
1220         virtual
1221         override
1222         returns (uint256)
1223     {
1224         require(
1225             index < ERC721.balanceOf(owner),
1226             "ERC721Enumerable: owner index out of bounds"
1227         );
1228         return _ownedTokens[owner][index];
1229     }
1230 
1231     /**
1232      * @dev See {IERC721Enumerable-totalSupply}.
1233      */
1234     function totalSupply() public view virtual override returns (uint256) {
1235         return _allTokens.length;
1236     }
1237 
1238     /**
1239      * @dev See {IERC721Enumerable-tokenByIndex}.
1240      */
1241     function tokenByIndex(uint256 index)
1242         public
1243         view
1244         virtual
1245         override
1246         returns (uint256)
1247     {
1248         require(
1249             index < ERC721Enumerable.totalSupply(),
1250             "ERC721Enumerable: global index out of bounds"
1251         );
1252         return _allTokens[index];
1253     }
1254 
1255     /**
1256      * @dev Hook that is called before any token transfer. This includes minting
1257      * and burning.
1258      *
1259      * Calling conditions:
1260      *
1261      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1262      * transferred to `to`.
1263      * - When `from` is zero, `tokenId` will be minted for `to`.
1264      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1265      * - `from` cannot be the zero address.
1266      * - `to` cannot be the zero address.
1267      *
1268      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1269      */
1270     function _beforeTokenTransfer(
1271         address from,
1272         address to,
1273         uint256 tokenId
1274     ) internal virtual override {
1275         super._beforeTokenTransfer(from, to, tokenId);
1276 
1277         if (from == address(0)) {
1278             _addTokenToAllTokensEnumeration(tokenId);
1279         } else if (from != to) {
1280             _removeTokenFromOwnerEnumeration(from, tokenId);
1281         }
1282         if (to == address(0)) {
1283             _removeTokenFromAllTokensEnumeration(tokenId);
1284         } else if (to != from) {
1285             _addTokenToOwnerEnumeration(to, tokenId);
1286         }
1287     }
1288 
1289     /**
1290      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1291      * @param to address representing the new owner of the given token ID
1292      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1293      */
1294     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1295         uint256 length = ERC721.balanceOf(to);
1296         _ownedTokens[to][length] = tokenId;
1297         _ownedTokensIndex[tokenId] = length;
1298     }
1299 
1300     /**
1301      * @dev Private function to add a token to this extension's token tracking data structures.
1302      * @param tokenId uint256 ID of the token to be added to the tokens list
1303      */
1304     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1305         _allTokensIndex[tokenId] = _allTokens.length;
1306         _allTokens.push(tokenId);
1307     }
1308 
1309     /**
1310      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1311      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1312      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1313      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1314      * @param from address representing the previous owner of the given token ID
1315      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1316      */
1317     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1318         private
1319     {
1320         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1321         // then delete the last slot (swap and pop).
1322 
1323         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1324         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1325 
1326         // When the token to delete is the last token, the swap operation is unnecessary
1327         if (tokenIndex != lastTokenIndex) {
1328             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1329 
1330             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1331             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1332         }
1333 
1334         // This also deletes the contents at the last position of the array
1335         delete _ownedTokensIndex[tokenId];
1336         delete _ownedTokens[from][lastTokenIndex];
1337     }
1338 
1339     /**
1340      * @dev Private function to remove a token from this extension's token tracking data structures.
1341      * This has O(1) time complexity, but alters the order of the _allTokens array.
1342      * @param tokenId uint256 ID of the token to be removed from the tokens list
1343      */
1344     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1345         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1346         // then delete the last slot (swap and pop).
1347 
1348         uint256 lastTokenIndex = _allTokens.length - 1;
1349         uint256 tokenIndex = _allTokensIndex[tokenId];
1350 
1351         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1352         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1353         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1354         uint256 lastTokenId = _allTokens[lastTokenIndex];
1355 
1356         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1357         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1358 
1359         // This also deletes the contents at the last position of the array
1360         delete _allTokensIndex[tokenId];
1361         _allTokens.pop();
1362     }
1363 }
1364 
1365 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1366 pragma solidity ^0.8.0;
1367 
1368 /**
1369  * @dev Contract module which provides a basic access control mechanism, where
1370  * there is an account (an owner) that can be granted exclusive access to
1371  * specific functions.
1372  *
1373  * By default, the owner account will be the one that deploys the contract. This
1374  * can later be changed with {transferOwnership}.
1375  *
1376  * This module is used through inheritance. It will make available the modifier
1377  * `onlyOwner`, which can be applied to your functions to restrict their use to
1378  * the owner.
1379  */
1380 abstract contract Ownable is Context {
1381     address private _owner;
1382 
1383     event OwnershipTransferred(
1384         address indexed previousOwner,
1385         address indexed newOwner
1386     );
1387 
1388     /**
1389      * @dev Initializes the contract setting the deployer as the initial owner.
1390      */
1391     constructor() {
1392         _transferOwnership(_msgSender());
1393     }
1394 
1395     /**
1396      * @dev Returns the address of the current owner.
1397      */
1398     function owner() public view virtual returns (address) {
1399         return _owner;
1400     }
1401 
1402     /**
1403      * @dev Throws if called by any account other than the owner.
1404      */
1405     modifier onlyOwner() {
1406         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1407         _;
1408     }
1409 
1410     /**
1411      * @dev Leaves the contract without owner. It will not be possible to call
1412      * `onlyOwner` functions anymore. Can only be called by the current owner.
1413      *
1414      * NOTE: Renouncing ownership will leave the contract without an owner,
1415      * thereby removing any functionality that is only available to the owner.
1416      */
1417     function renounceOwnership() public virtual onlyOwner {
1418         _transferOwnership(address(0));
1419     }
1420 
1421     /**
1422      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1423      * Can only be called by the current owner.
1424      */
1425     function transferOwnership(address newOwner) public virtual onlyOwner {
1426         require(
1427             newOwner != address(0),
1428             "Ownable: new owner is the zero address"
1429         );
1430         _transferOwnership(newOwner);
1431     }
1432 
1433     /**
1434      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1435      * Internal function without access restriction.
1436      */
1437     function _transferOwnership(address newOwner) internal virtual {
1438         address oldOwner = _owner;
1439         _owner = newOwner;
1440         emit OwnershipTransferred(oldOwner, newOwner);
1441     }
1442 }
1443 
1444 pragma solidity 0.8.4;
1445 
1446 contract HELLISHVAULT is Ownable, IERC721Receiver {
1447     struct vaultInfo {
1448         IERC721 nft;
1449         string name;
1450     }
1451 
1452     struct Stake {
1453         uint24 tokenId;
1454         uint256 timestamp;
1455         address owner;
1456         uint256 tower;
1457         uint256 familiar;
1458     }
1459 
1460     struct LegendaryLocked {
1461         uint24 tokenId;
1462         address owner;
1463     }
1464 
1465     struct Tower {
1466         uint24 tokenId;
1467         uint256 timestamp;
1468         address owner;
1469     }
1470 
1471     vaultInfo[] public VaultInfo;
1472     LegendaryLocked[] public LegendsLocked;
1473 
1474     uint256 public totalStaked = 0;
1475     uint256 public activatedTowers;
1476     uint256 public bgfVault = 0;
1477     uint256 public towerVault = 1;
1478     uint256 public legendaryVault = 2;
1479     address public familiars;
1480     address public towers;
1481     uint256 public rewardInterval = 1 days;
1482     uint256 public rewardRegular = 10;
1483     uint256 public rewardElite = 15;
1484     uint256 public rewardLegendary = 25;
1485     bool public claimingEnabled = true;
1486     bool public stakingEnabled = false;
1487     bool public spendingEnabled = true;
1488     mapping(uint256 => Stake) public vault;
1489     mapping(uint256 => LegendaryLocked) public lockedLegendaries;
1490     mapping(uint256 => Tower) public activeTowers;
1491     mapping(address => uint256) public bank;
1492     mapping(address => uint256) public addrTotalStake;
1493     mapping(address => uint256) public addrTotalTowers;
1494     mapping(address => uint256) public addrTotalFamiliars;
1495 
1496     event NFTStaked(address owner, uint256 tokenId, uint256 value);
1497     event NFTUnstaked(address owner, uint256 tokenId, uint256 value);
1498     event Claimed(address owner, uint256 amount);
1499 
1500     function addVault(IERC721 _nft, string calldata _name) public {
1501         VaultInfo.push(vaultInfo({nft: _nft, name: _name}));
1502     }
1503 
1504     function stakeBGF(uint256[] calldata tokenIds) external {
1505         require(stakingEnabled, "Staking functions are disabled.");
1506         _stakeBGF(tokenIds);
1507     }
1508 
1509     function _stakeBGF(uint256[] calldata tokenIds) internal {
1510         uint256 tokenId;
1511 
1512         uint256 userTowers = addrTotalTowers[msg.sender];
1513         uint256 userStaked = addrTotalStake[msg.sender];
1514         uint256 totalStakeInput = userStaked + tokenIds.length;
1515 
1516         require(totalStakeInput < 12, "Max allowance is 12.");
1517 
1518         if (totalStakeInput > 1) {
1519             require(userTowers > 0, "Boost not found.");
1520 
1521             if (totalStakeInput > 6) {
1522                 require(userTowers > 1, "Boost maxed out.");
1523             }
1524         }
1525 
1526         totalStaked += tokenIds.length;
1527         vaultInfo storage vaultid = VaultInfo[bgfVault];
1528         addrTotalFamiliars[msg.sender] = IERC721(familiars).balanceOf(
1529             msg.sender
1530         );
1531 
1532         for (uint256 i = 0; i < tokenIds.length; i++) {
1533             tokenId = tokenIds[i];
1534             require(
1535                 vaultid.nft.ownerOf(tokenId) == msg.sender,
1536                 "Caller is not token owner."
1537             );
1538 
1539             require(vault[tokenId].tokenId == 0, "NFT already staked.");
1540             vaultid.nft.transferFrom(msg.sender, address(this), tokenId);
1541             emit NFTStaked(msg.sender, tokenId, block.timestamp);
1542 
1543             vault[tokenId] = Stake({
1544                 owner: msg.sender,
1545                 tokenId: uint24(tokenId),
1546                 timestamp: uint256(block.timestamp),
1547                 tower: userTowers,
1548                 familiar: addrTotalFamiliars[msg.sender]
1549             });
1550 
1551             addrTotalStake[msg.sender] += 1;
1552         }
1553     }
1554 
1555     function unstakeBGF(uint256[] calldata tokenIds) external {
1556         require(stakingEnabled, "Staking functions are disabled.");
1557         _unstakeBGF(tokenIds);
1558     }
1559 
1560     function _unstakeBGF(uint256[] calldata tokenIds) internal {
1561         uint256 tokenId;
1562         vaultInfo storage vaultid = VaultInfo[bgfVault];
1563 
1564         for (uint256 i = 0; i < tokenIds.length; i++) {
1565             tokenId = tokenIds[i];
1566             Stake memory staked = vault[tokenId];
1567 
1568             require(staked.owner == msg.sender, "Caller is not token owner.");
1569 
1570             delete vault[tokenId];
1571             totalStaked -= tokenIds.length;
1572             addrTotalStake[msg.sender] -= 1;
1573 
1574             emit NFTUnstaked(msg.sender, tokenId, block.timestamp);
1575             vaultid.nft.transferFrom(address(this), msg.sender, tokenId);
1576         }
1577     }
1578 
1579     function activateTower(uint256 tokenId) external {
1580         require(stakingEnabled, "Staking functions are disabled.");
1581         _activateTower(tokenId);
1582     }
1583 
1584     function _activateTower(uint256 tokenId) internal {
1585         vaultInfo storage vaultid = VaultInfo[towerVault];
1586         uint256 totalTowers = addrTotalTowers[msg.sender]; // balanceOf(msg.sender, towerVault);
1587         require(totalTowers < 2, "Max Towers activated.");
1588 
1589         require(
1590             vaultid.nft.ownerOf(tokenId) == msg.sender,
1591             "Caller is not token owner."
1592         );
1593 
1594         require(activeTowers[tokenId].tokenId == 0, "NFT already staked.");
1595         vaultid.nft.transferFrom(msg.sender, address(this), tokenId);
1596         emit NFTStaked(msg.sender, tokenId, block.timestamp);
1597 
1598         activeTowers[tokenId] = Tower({
1599             tokenId: uint24(tokenId),
1600             timestamp: uint256(block.timestamp),
1601             owner: msg.sender
1602         });
1603 
1604         activatedTowers++;
1605         addrTotalTowers[msg.sender] += 1;
1606     }
1607 
1608     function deactivateTower(uint256 tokenId) external {
1609         require(stakingEnabled, "Staking functions are disabled.");
1610         _deactivateTower(tokenId);
1611     }
1612 
1613     function _deactivateTower(uint256 tokenId) internal {
1614         require(
1615             activeTowers[tokenId].owner == msg.sender,
1616             "Caller is not token owner."
1617         );
1618 
1619         uint256 userStaked = addrTotalStake[msg.sender];
1620         uint256 userTowers = addrTotalTowers[msg.sender];
1621 
1622         require(userStaked < 6, "Not allowed, too much at stake!");
1623 
1624         if (userStaked <= 1) {
1625             require(userTowers > 0, "Not allowed!");
1626         }
1627 
1628         if (userStaked > 1) {
1629             require(userTowers == 2, "Not allowed while boost activated!");
1630         }
1631 
1632         activatedTowers--;
1633         vaultInfo storage vaultid = VaultInfo[towerVault];
1634         vaultid.nft.transferFrom(address(this), msg.sender, tokenId);
1635         emit NFTUnstaked(msg.sender, tokenId, block.timestamp);
1636         delete activeTowers[tokenId];
1637         addrTotalTowers[msg.sender] -= 1;
1638     }
1639 
1640     function claim(uint256[] calldata tokenIds, bool _unstake) external {
1641         require(stakingEnabled, "Staking functions are disabled.");
1642         _claim(tokenIds, _unstake);
1643     }
1644 
1645     function _claim(uint256[] calldata tokenIds, bool _unstake) internal {
1646         uint256 tokenId;
1647         uint256 stakedTime;
1648         uint256 earned = 0;
1649         uint256 towerBoost = 0;
1650         uint256 familiarBoost = 0;
1651         uint256 userTokens = addrTotalStake[msg.sender];
1652         uint256 userFamiliars = addrTotalFamiliars[msg.sender];
1653 
1654         for (uint256 i = 0; i < tokenIds.length; i++) {
1655             tokenId = tokenIds[i];
1656             Stake memory staked = vault[tokenId];
1657             require(staked.owner == msg.sender, "Not token owner.");
1658             stakedTime += block.timestamp - staked.timestamp;
1659 
1660             //Legendary Tier Rewards
1661             if (tokenId >= 1 && tokenId <= 10) {
1662                 earned += (stakedTime / rewardInterval) * rewardLegendary;
1663             }
1664             //Elite Tier Rewards
1665             else if (tokenId >= 5510 && tokenId <= 6000) {
1666                 earned += (stakedTime / rewardInterval) * rewardElite;
1667             }
1668             //Regular Tier Rewards
1669             else {
1670                 earned += (stakedTime / rewardInterval) * rewardRegular;
1671             }
1672 
1673             vault[tokenId] = Stake({
1674                 owner: staked.owner,
1675                 tokenId: uint24(tokenId),
1676                 timestamp: uint256(block.timestamp),
1677                 tower: staked.tower,
1678                 familiar: staked.familiar
1679             });
1680         }
1681 
1682         if (userTokens == 6) {
1683             towerBoost = (3 * earned) / 100;
1684         }
1685 
1686         if (userTokens == 12) {
1687             towerBoost = (6 * earned) / 100;
1688         }
1689 
1690         if (userFamiliars == 1) {
1691             familiarBoost = ((20 * earned) / 100);
1692         }
1693 
1694         if (userFamiliars > 1) {
1695             familiarBoost = ((35 * earned) / 100);
1696         }
1697 
1698         earned = earned + towerBoost + familiarBoost;
1699         bank[msg.sender] += earned;
1700 
1701         if (_unstake) {
1702             _unstakeBGF(tokenIds);
1703         }
1704 
1705         emit Claimed(msg.sender, earned);
1706     }
1707 
1708     function earningInfo(uint256[] calldata tokenIds)
1709         public
1710         view
1711         returns (uint256)
1712     {
1713         uint256 tokenId;
1714         uint256 stakedTime;
1715         uint256 earned = 0;
1716         uint256 towerBoost = 0;
1717         uint256 familiarBoost = 0;
1718         uint256 userTokens = addrTotalStake[msg.sender];
1719         uint256 userFamiliars = addrTotalFamiliars[msg.sender];
1720 
1721         for (uint256 i = 0; i < tokenIds.length; i++) {
1722             tokenId = tokenIds[i];
1723             Stake memory staked = vault[tokenId];
1724             require(staked.owner == msg.sender, "Not token owner.");
1725             stakedTime += block.timestamp - staked.timestamp;
1726 
1727             //Legendary Tier Rewards
1728 
1729             if (tokenId >= 1 && tokenId <= 10) {
1730                 earned += (stakedTime / rewardInterval) * rewardLegendary;
1731             }
1732             //Elite Tier Rewards
1733             else if (tokenId >= 5510 && tokenId <= 6000) {
1734                 earned += (stakedTime / rewardInterval) * rewardElite;
1735             }
1736             //Regular Tier Rewards
1737             else {
1738                 earned += (stakedTime / rewardInterval) * rewardRegular;
1739             }
1740         }
1741 
1742         if (userTokens == 6) {
1743             towerBoost = (3 * earned) / 100;
1744         }
1745 
1746         if (userTokens == 12) {
1747             towerBoost = (6 * earned) / 100;
1748         }
1749 
1750         if (userFamiliars == 1) {
1751             familiarBoost = ((20 * earned) / 100);
1752         }
1753 
1754         if (userFamiliars > 1) {
1755             familiarBoost = ((35 * earned) / 100);
1756         }
1757 
1758         earned = earned + towerBoost + familiarBoost;
1759         return earned;
1760     }
1761 
1762     function getBankBalance(address _address) public view returns (uint256) {
1763         return bank[_address];
1764     }
1765 
1766     function spendBalanceFamiliars(address _address, uint256 _amount) public {
1767         require(spendingEnabled, "Balance spending functions are disabled.");
1768         require(msg.sender == familiars, "Not Allowed.");
1769         bank[_address] -= _amount;
1770     }
1771 
1772     function spendBalanceTowers(address _address, uint256 _amount) public {
1773         require(spendingEnabled, "Balance spending functions are disabled.");
1774         require(msg.sender == towers, "Not Allowed.");
1775         bank[_address] -= _amount;
1776     }
1777 
1778     function addStyxBalance(address _address, uint256 _amount)
1779         public
1780         onlyOwner
1781     {
1782         bank[_address] += _amount;
1783     }
1784 
1785     function tokensOfOwner(address account)
1786         public
1787         view
1788         returns (uint256[] memory)
1789     {
1790         uint256[] memory tmp = new uint256[](totalStaked);
1791         uint256 index = 0;
1792 
1793         for (uint256 tokenId = 1; tokenId <= totalStaked; tokenId++) {
1794             if (vault[tokenId].owner == account) {
1795                 tmp[index] = vault[tokenId].tokenId;
1796                 index += 1;
1797             }
1798         }
1799 
1800         uint256[] memory tokens = new uint256[](index);
1801 
1802         for (uint256 i = 0; i < index; i++) {
1803             tokens[i] = tmp[i];
1804         }
1805 
1806         return tokens;
1807     }
1808 
1809     function lockLegendary(uint256[] calldata tokenIds) public onlyOwner {
1810         uint256 tokenId;
1811         vaultInfo storage vaultid = VaultInfo[legendaryVault];
1812 
1813         for (uint256 i = 0; i < tokenIds.length; i++) {
1814             tokenId = tokenIds[i];
1815             require(
1816                 lockedLegendaries[tokenId].tokenId == 0,
1817                 "NFT already locked."
1818             );
1819 
1820             vaultid.nft.transferFrom(msg.sender, address(this), tokenId);
1821             emit NFTStaked(msg.sender, tokenId, block.timestamp);
1822             lockedLegendaries[tokenId] = LegendaryLocked({
1823                 owner: msg.sender,
1824                 tokenId: uint24(tokenId)
1825             });
1826         }
1827     }
1828 
1829     function unlockLegendary(uint256 _tokenId) public {
1830         require(spendingEnabled, "Staking functions are disabled.");
1831         uint256 price = 0;
1832 
1833         vaultInfo storage vaultid = VaultInfo[legendaryVault];
1834         require(
1835             lockedLegendaries[_tokenId].tokenId == _tokenId,
1836             "Invalid token id."
1837         );
1838 
1839         if (_tokenId >= 1 && _tokenId <= 3) {
1840             price = 600;
1841         }
1842 
1843         if (_tokenId >= 4 && _tokenId <= 7) {
1844             price = 640;
1845         }
1846 
1847         if (_tokenId >= 4 && _tokenId <= 7) {
1848             price = 700;
1849         }
1850 
1851         if (msg.sender != owner()) {
1852             require(bank[msg.sender] >= price, "Insufficient balance.");
1853         }
1854 
1855         bank[msg.sender] -= price;
1856         delete lockedLegendaries[_tokenId];
1857         emit NFTUnstaked(msg.sender, _tokenId, block.timestamp);
1858         vaultid.nft.transferFrom(address(this), msg.sender, _tokenId);
1859     }
1860 
1861     //Only Owner
1862     function unstakeBGFSafe(uint256[] calldata tokenIds) public onlyOwner {
1863         uint256 tokenId;
1864         vaultInfo storage vaultid = VaultInfo[bgfVault];
1865 
1866         for (uint256 i = 0; i < tokenIds.length; i++) {
1867             tokenId = tokenIds[i];
1868             delete vault[tokenId];
1869             totalStaked -= tokenIds.length;
1870             addrTotalStake[msg.sender] -= 1;
1871             emit NFTUnstaked(msg.sender, tokenId, block.timestamp);
1872             vaultid.nft.transferFrom(address(this), msg.sender, tokenId);
1873         }
1874     }
1875 
1876     function unlockLegendarySafe(uint256 _tokenId) public onlyOwner {
1877         vaultInfo storage vaultid = VaultInfo[legendaryVault];
1878 
1879         require(
1880             lockedLegendaries[_tokenId].tokenId == _tokenId,
1881             "Invalid token id."
1882         );
1883 
1884         delete lockedLegendaries[_tokenId];
1885         emit NFTUnstaked(msg.sender, _tokenId, block.timestamp);
1886         vaultid.nft.transferFrom(address(this), msg.sender, _tokenId);
1887     }
1888 
1889     function deactivateTowerSafe(uint256 tokenId) public onlyOwner {
1890         require(activeTowers[tokenId].tokenId == tokenId, "Invalid token id.");
1891 
1892         activatedTowers--;
1893         vaultInfo storage vaultid = VaultInfo[towerVault];
1894         vaultid.nft.transferFrom(address(this), msg.sender, tokenId);
1895         emit NFTUnstaked(msg.sender, tokenId, block.timestamp);
1896         delete activeTowers[tokenId];
1897         addrTotalTowers[activeTowers[tokenId].owner] -= 1;
1898     }
1899 
1900     function setBgfVault(uint256 _vault) public onlyOwner {
1901         bgfVault = _vault;
1902     }
1903 
1904     function setTowerVault(uint256 _vault) public onlyOwner {
1905         towerVault = _vault;
1906     }
1907 
1908     function setFamiliarsAddress(address _address) public onlyOwner {
1909         familiars = _address;
1910     }
1911 
1912     function setTowersAddress(address _address) public onlyOwner {
1913         towers = _address;
1914     }
1915 
1916     function toggleStaking(bool _state) public onlyOwner {
1917         stakingEnabled = _state;
1918     }
1919 
1920     function toggleSpending(bool _state) public onlyOwner {
1921         spendingEnabled = _state;
1922     }
1923 
1924     function onERC721Received(
1925         address,
1926         address from,
1927         uint256,
1928         bytes calldata
1929     ) external pure override returns (bytes4) {
1930         require(from == address(0x0), "Cannot send Tokens to Vault directly");
1931 
1932         return IERC721Receiver.onERC721Received.selector;
1933     }
1934 }