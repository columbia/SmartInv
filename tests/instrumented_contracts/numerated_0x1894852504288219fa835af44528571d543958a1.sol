1 // SPDX-License-Identifier: MIT
2 // Developed by: https://twitter.com/dev_mecha
3 // Primary Twitter: https://twitter.com/mecha_monkeys
4 // Website: https://mechamonkeys.io/
5 pragma solidity 0.8.15;
6 
7 // File: openzeppelin-contracts/contracts/utils/introspection/IERC165.sol
8 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
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
30 // File: openzeppelin-contracts/contracts/token/ERC721/IERC721.sol
31 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
32 /**
33  * @dev Required interface of an ERC721 compliant contract.
34  */
35 interface IERC721 is IERC165 {
36     /**
37      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
38      */
39     event Transfer(
40         address indexed from,
41         address indexed to,
42         uint256 indexed tokenId
43     );
44     /**
45      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
46      */
47     event Approval(
48         address indexed owner,
49         address indexed approved,
50         uint256 indexed tokenId
51     );
52     /**
53      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
54      */
55     event ApprovalForAll(
56         address indexed owner,
57         address indexed operator,
58         bool approved
59     );
60 
61     /**
62      * @dev Returns the number of tokens in ``owner``'s account.
63      */
64     function balanceOf(address owner) external view returns (uint256 balance);
65 
66     /**
67      * @dev Returns the owner of the `tokenId` token.
68      *
69      * Requirements:
70      *
71      * - `tokenId` must exist.
72      */
73     function ownerOf(uint256 tokenId) external view returns (address owner);
74 
75     /**
76      * @dev Safely transfers `tokenId` token from `from` to `to`.
77      *
78      * Requirements:
79      *
80      * - `from` cannot be the zero address.
81      * - `to` cannot be the zero address.
82      * - `tokenId` token must exist and be owned by `from`.
83      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
84      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
85      *
86      * Emits a {Transfer} event.
87      */
88     function safeTransferFrom(
89         address from,
90         address to,
91         uint256 tokenId,
92         bytes calldata data
93     ) external;
94 
95     /**
96      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
97      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
98      *
99      * Requirements:
100      *
101      * - `from` cannot be the zero address.
102      * - `to` cannot be the zero address.
103      * - `tokenId` token must exist and be owned by `from`.
104      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
105      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
106      *
107      * Emits a {Transfer} event.
108      */
109     function safeTransferFrom(
110         address from,
111         address to,
112         uint256 tokenId
113     ) external;
114 
115     /**
116      * @dev Transfers `tokenId` token from `from` to `to`.
117      *
118      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
119      *
120      * Requirements:
121      *
122      * - `from` cannot be the zero address.
123      * - `to` cannot be the zero address.
124      * - `tokenId` token must be owned by `from`.
125      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
126      *
127      * Emits a {Transfer} event.
128      */
129     function transferFrom(
130         address from,
131         address to,
132         uint256 tokenId
133     ) external;
134 
135     /**
136      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
137      * The approval is cleared when the token is transferred.
138      *
139      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
140      *
141      * Requirements:
142      *
143      * - The caller must own the token or be an approved operator.
144      * - `tokenId` must exist.
145      *
146      * Emits an {Approval} event.
147      */
148     function approve(address to, uint256 tokenId) external;
149 
150     /**
151      * @dev Approve or remove `operator` as an operator for the caller.
152      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
153      *
154      * Requirements:
155      *
156      * - The `operator` cannot be the caller.
157      *
158      * Emits an {ApprovalForAll} event.
159      */
160     function setApprovalForAll(address operator, bool _approved) external;
161 
162     /**
163      * @dev Returns the account approved for `tokenId` token.
164      *
165      * Requirements:
166      *
167      * - `tokenId` must exist.
168      */
169     function getApproved(uint256 tokenId)
170         external
171         view
172         returns (address operator);
173 
174     /**
175      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
176      *
177      * See {setApprovalForAll}
178      */
179     function isApprovedForAll(address owner, address operator)
180         external
181         view
182         returns (bool);
183 }
184 
185 // File: openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol
186 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
187 /**
188  * @title ERC721 token receiver interface
189  * @dev Interface for any contract that wants to support safeTransfers
190  * from ERC721 asset contracts.
191  */
192 interface IERC721Receiver {
193     /**
194      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
195      * by `operator` from `from`, this function is called.
196      *
197      * It must return its Solidity selector to confirm the token transfer.
198      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
199      *
200      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
201      */
202     function onERC721Received(
203         address operator,
204         address from,
205         uint256 tokenId,
206         bytes calldata data
207     ) external returns (bytes4);
208 }
209 
210 // File: openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Metadata.sol
211 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
212 /**
213  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
214  * @dev See https://eips.ethereum.org/EIPS/eip-721
215  */
216 interface IERC721Metadata is IERC721 {
217     /**
218      * @dev Returns the token collection name.
219      */
220     function name() external view returns (string memory);
221 
222     /**
223      * @dev Returns the token collection symbol.
224      */
225     function symbol() external view returns (string memory);
226 
227     /**
228      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
229      */
230     function tokenURI(uint256 tokenId) external view returns (string memory);
231 }
232 
233 // File: openzeppelin-contracts/contracts/utils/Address.sol
234 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
235 /**
236  * @dev Collection of functions related to the address type
237  */
238 library Address {
239     /**
240      * @dev Returns true if `account` is a contract.
241      *
242      * [IMPORTANT]
243      * ====
244      * It is unsafe to assume that an address for which this function returns
245      * false is an externally-owned account (EOA) and not a contract.
246      *
247      * Among others, `isContract` will return false for the following
248      * types of addresses:
249      *
250      *  - an externally-owned account
251      *  - a contract in construction
252      *  - an address where a contract will be created
253      *  - an address where a contract lived, but was destroyed
254      * ====
255      *
256      * [IMPORTANT]
257      * ====
258      * You shouldn't rely on `isContract` to protect against flash loan attacks!
259      *
260      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
261      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
262      * constructor.
263      * ====
264      */
265     function isContract(address account) internal view returns (bool) {
266         // This method relies on extcodesize/address.code.length, which returns 0
267         // for contracts in construction, since the code is only stored at the end
268         // of the constructor execution.
269         return account.code.length > 0;
270     }
271 
272     /**
273      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
274      * `recipient`, forwarding all available gas and reverting on errors.
275      *
276      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
277      * of certain opcodes, possibly making contracts go over the 2300 gas limit
278      * imposed by `transfer`, making them unable to receive funds via
279      * `transfer`. {sendValue} removes this limitation.
280      *
281      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
282      *
283      * IMPORTANT: because control is transferred to `recipient`, care must be
284      * taken to not create reentrancy vulnerabilities. Consider using
285      * {ReentrancyGuard} or the
286      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
287      */
288     function sendValue(address payable recipient, uint256 amount) internal {
289         require(
290             address(this).balance >= amount,
291             "Address: insufficient balance"
292         );
293         (bool success, ) = recipient.call{value: amount}("");
294         require(
295             success,
296             "Address: unable to send value, recipient may have reverted"
297         );
298     }
299 
300     /**
301      * @dev Performs a Solidity function call using a low level `call`. A
302      * plain `call` is an unsafe replacement for a function call: use this
303      * function instead.
304      *
305      * If `target` reverts with a revert reason, it is bubbled up by this
306      * function (like regular Solidity function calls).
307      *
308      * Returns the raw returned data. To convert to the expected return value,
309      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
310      *
311      * Requirements:
312      *
313      * - `target` must be a contract.
314      * - calling `target` with `data` must not revert.
315      *
316      * _Available since v3.1._
317      */
318     function functionCall(address target, bytes memory data)
319         internal
320         returns (bytes memory)
321     {
322         return
323             functionCallWithValue(
324                 target,
325                 data,
326                 0,
327                 "Address: low-level call failed"
328             );
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
333      * `errorMessage` as a fallback revert reason when `target` reverts.
334      *
335      * _Available since v3.1._
336      */
337     function functionCall(
338         address target,
339         bytes memory data,
340         string memory errorMessage
341     ) internal returns (bytes memory) {
342         return functionCallWithValue(target, data, 0, errorMessage);
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347      * but also transferring `value` wei to `target`.
348      *
349      * Requirements:
350      *
351      * - the calling contract must have an ETH balance of at least `value`.
352      * - the called Solidity function must be `payable`.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(
357         address target,
358         bytes memory data,
359         uint256 value
360     ) internal returns (bytes memory) {
361         return
362             functionCallWithValue(
363                 target,
364                 data,
365                 value,
366                 "Address: low-level call with value failed"
367             );
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
372      * with `errorMessage` as a fallback revert reason when `target` reverts.
373      *
374      * _Available since v3.1._
375      */
376     function functionCallWithValue(
377         address target,
378         bytes memory data,
379         uint256 value,
380         string memory errorMessage
381     ) internal returns (bytes memory) {
382         require(
383             address(this).balance >= value,
384             "Address: insufficient balance for call"
385         );
386         (bool success, bytes memory returndata) = target.call{value: value}(
387             data
388         );
389         return
390             verifyCallResultFromTarget(
391                 target,
392                 success,
393                 returndata,
394                 errorMessage
395             );
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
400      * but performing a static call.
401      *
402      * _Available since v3.3._
403      */
404     function functionStaticCall(address target, bytes memory data)
405         internal
406         view
407         returns (bytes memory)
408     {
409         return
410             functionStaticCall(
411                 target,
412                 data,
413                 "Address: low-level static call failed"
414             );
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
419      * but performing a static call.
420      *
421      * _Available since v3.3._
422      */
423     function functionStaticCall(
424         address target,
425         bytes memory data,
426         string memory errorMessage
427     ) internal view returns (bytes memory) {
428         (bool success, bytes memory returndata) = target.staticcall(data);
429         return
430             verifyCallResultFromTarget(
431                 target,
432                 success,
433                 returndata,
434                 errorMessage
435             );
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
440      * but performing a delegate call.
441      *
442      * _Available since v3.4._
443      */
444     function functionDelegateCall(address target, bytes memory data)
445         internal
446         returns (bytes memory)
447     {
448         return
449             functionDelegateCall(
450                 target,
451                 data,
452                 "Address: low-level delegate call failed"
453             );
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
458      * but performing a delegate call.
459      *
460      * _Available since v3.4._
461      */
462     function functionDelegateCall(
463         address target,
464         bytes memory data,
465         string memory errorMessage
466     ) internal returns (bytes memory) {
467         (bool success, bytes memory returndata) = target.delegatecall(data);
468         return
469             verifyCallResultFromTarget(
470                 target,
471                 success,
472                 returndata,
473                 errorMessage
474             );
475     }
476 
477     /**
478      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
479      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
480      *
481      * _Available since v4.8._
482      */
483     function verifyCallResultFromTarget(
484         address target,
485         bool success,
486         bytes memory returndata,
487         string memory errorMessage
488     ) internal view returns (bytes memory) {
489         if (success) {
490             if (returndata.length == 0) {
491                 // only check isContract if the call was successful and the return data is empty
492                 // otherwise we already know that it was a contract
493                 require(isContract(target), "Address: call to non-contract");
494             }
495             return returndata;
496         } else {
497             _revert(returndata, errorMessage);
498         }
499     }
500 
501     /**
502      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
503      * revert reason or using the provided one.
504      *
505      * _Available since v4.3._
506      */
507     function verifyCallResult(
508         bool success,
509         bytes memory returndata,
510         string memory errorMessage
511     ) internal pure returns (bytes memory) {
512         if (success) {
513             return returndata;
514         } else {
515             _revert(returndata, errorMessage);
516         }
517     }
518 
519     function _revert(bytes memory returndata, string memory errorMessage)
520         private
521         pure
522     {
523         // Look for revert reason and bubble it up if present
524         if (returndata.length > 0) {
525             // The easiest way to bubble the revert reason is using memory via assembly
526             /// @solidity memory-safe-assembly
527             assembly {
528                 let returndata_size := mload(returndata)
529                 revert(add(32, returndata), returndata_size)
530             }
531         } else {
532             revert(errorMessage);
533         }
534     }
535 }
536 
537 // File: openzeppelin-contracts/contracts/utils/Context.sol
538 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
539 /**
540  * @dev Provides information about the current execution context, including the
541  * sender of the transaction and its data. While these are generally available
542  * via msg.sender and msg.data, they should not be accessed in such a direct
543  * manner, since when dealing with meta-transactions the account sending and
544  * paying for execution may not be the actual sender (as far as an application
545  * is concerned).
546  *
547  * This contract is only required for intermediate, library-like contracts.
548  */
549 abstract contract Context {
550     function _msgSender() internal view virtual returns (address) {
551         return msg.sender;
552     }
553 
554     function _msgData() internal view virtual returns (bytes calldata) {
555         return msg.data;
556     }
557 }
558 
559 // File: openzeppelin-contracts/contracts/utils/Strings.sol
560 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
561 /**
562  * @dev String operations.
563  */
564 library Strings {
565     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
566     uint8 private constant _ADDRESS_LENGTH = 20;
567 
568     /**
569      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
570      */
571     function toString(uint256 value) internal pure returns (string memory) {
572         // Inspired by OraclizeAPI's implementation - MIT licence
573         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
574         if (value == 0) {
575             return "0";
576         }
577         uint256 temp = value;
578         uint256 digits;
579         while (temp != 0) {
580             digits++;
581             temp /= 10;
582         }
583         bytes memory buffer = new bytes(digits);
584         while (value != 0) {
585             digits -= 1;
586             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
587             value /= 10;
588         }
589         return string(buffer);
590     }
591 
592     /**
593      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
594      */
595     function toHexString(uint256 value) internal pure returns (string memory) {
596         if (value == 0) {
597             return "0x00";
598         }
599         uint256 temp = value;
600         uint256 length = 0;
601         while (temp != 0) {
602             length++;
603             temp >>= 8;
604         }
605         return toHexString(value, length);
606     }
607 
608     /**
609      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
610      */
611     function toHexString(uint256 value, uint256 length)
612         internal
613         pure
614         returns (string memory)
615     {
616         bytes memory buffer = new bytes(2 * length + 2);
617         buffer[0] = "0";
618         buffer[1] = "x";
619         for (uint256 i = 2 * length + 1; i > 1; --i) {
620             buffer[i] = _HEX_SYMBOLS[value & 0xf];
621             value >>= 4;
622         }
623         require(value == 0, "Strings: hex length insufficient");
624         return string(buffer);
625     }
626 
627     /**
628      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
629      */
630     function toHexString(address addr) internal pure returns (string memory) {
631         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
632     }
633 }
634 
635 // File: openzeppelin-contracts/contracts/utils/introspection/ERC165.sol
636 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
637 /**
638  * @dev Implementation of the {IERC165} interface.
639  *
640  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
641  * for the additional interface id that will be supported. For example:
642  *
643  * ```solidity
644  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
645  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
646  * }
647  * ```
648  *
649  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
650  */
651 abstract contract ERC165 is IERC165 {
652     /**
653      * @dev See {IERC165-supportsInterface}.
654      */
655     function supportsInterface(bytes4 interfaceId)
656         public
657         view
658         virtual
659         override
660         returns (bool)
661     {
662         return interfaceId == type(IERC165).interfaceId;
663     }
664 }
665 
666 // File: openzeppelin-contracts/contracts/token/ERC721/ERC721.sol
667 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
668 /**
669  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
670  * the Metadata extension, but not including the Enumerable extension, which is available separately as
671  * {ERC721Enumerable}.
672  */
673 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
674     using Address for address;
675     using Strings for uint256;
676     // Token name
677     string private _name;
678     // Token symbol
679     string private _symbol;
680     // Mapping from token ID to owner address
681     mapping(uint256 => address) private _owners;
682     // Mapping owner address to token count
683     mapping(address => uint256) private _balances;
684     // Mapping from token ID to approved address
685     mapping(uint256 => address) private _tokenApprovals;
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
725             "ERC721: address zero is not a valid owner"
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
741         require(owner != address(0), "ERC721: invalid token ID");
742         return owner;
743     }
744 
745     /**
746      * @dev See {IERC721Metadata-name}.
747      */
748     function name() public view virtual override returns (string memory) {
749         return _name;
750     }
751 
752     /**
753      * @dev See {IERC721Metadata-symbol}.
754      */
755     function symbol() public view virtual override returns (string memory) {
756         return _symbol;
757     }
758 
759     /**
760      * @dev See {IERC721Metadata-tokenURI}.
761      */
762     function tokenURI(uint256 tokenId)
763         public
764         view
765         virtual
766         override
767         returns (string memory)
768     {
769         _requireMinted(tokenId);
770         string memory baseURI = _baseURI();
771         return
772             bytes(baseURI).length > 0
773                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
774                 : "";
775     }
776 
777     /**
778      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
779      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
780      * by default, can be overridden in child contracts.
781      */
782     function _baseURI() internal view virtual returns (string memory) {
783         return "";
784     }
785 
786     /**
787      * @dev See {IERC721-approve}.
788      */
789     function approve(address to, uint256 tokenId) public virtual override {
790         address owner = ERC721.ownerOf(tokenId);
791         require(to != owner, "ERC721: approval to current owner");
792         require(
793             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
794             "ERC721: approve caller is not token owner nor approved for all"
795         );
796         _approve(to, tokenId);
797     }
798 
799     /**
800      * @dev See {IERC721-getApproved}.
801      */
802     function getApproved(uint256 tokenId)
803         public
804         view
805         virtual
806         override
807         returns (address)
808     {
809         _requireMinted(tokenId);
810         return _tokenApprovals[tokenId];
811     }
812 
813     /**
814      * @dev See {IERC721-setApprovalForAll}.
815      */
816     function setApprovalForAll(address operator, bool approved)
817         public
818         virtual
819         override
820     {
821         _setApprovalForAll(_msgSender(), operator, approved);
822     }
823 
824     /**
825      * @dev See {IERC721-isApprovedForAll}.
826      */
827     function isApprovedForAll(address owner, address operator)
828         public
829         view
830         virtual
831         override
832         returns (bool)
833     {
834         return _operatorApprovals[owner][operator];
835     }
836 
837     /**
838      * @dev See {IERC721-transferFrom}.
839      */
840     function transferFrom(
841         address from,
842         address to,
843         uint256 tokenId
844     ) public virtual override {
845         //solhint-disable-next-line max-line-length
846         require(
847             _isApprovedOrOwner(_msgSender(), tokenId),
848             "ERC721: caller is not token owner nor approved"
849         );
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
871         bytes memory data
872     ) public virtual override {
873         require(
874             _isApprovedOrOwner(_msgSender(), tokenId),
875             "ERC721: caller is not token owner nor approved"
876         );
877         _safeTransfer(from, to, tokenId, data);
878     }
879 
880     /**
881      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
882      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
883      *
884      * `data` is additional data, it has no specified format and it is sent in call to `to`.
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
902         bytes memory data
903     ) internal virtual {
904         _transfer(from, to, tokenId);
905         require(
906             _checkOnERC721Received(from, to, tokenId, data),
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
936         address owner = ERC721.ownerOf(tokenId);
937         return (spender == owner ||
938             isApprovedForAll(owner, spender) ||
939             getApproved(tokenId) == spender);
940     }
941 
942     /**
943      * @dev Safely mints `tokenId` and transfers it to `to`.
944      *
945      * Requirements:
946      *
947      * - `tokenId` must not exist.
948      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
949      *
950      * Emits a {Transfer} event.
951      */
952     function _safeMint(address to, uint256 tokenId) internal virtual {
953         _safeMint(to, tokenId, "");
954     }
955 
956     /**
957      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
958      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
959      */
960     function _safeMint(
961         address to,
962         uint256 tokenId,
963         bytes memory data
964     ) internal virtual {
965         _mint(to, tokenId);
966         require(
967             _checkOnERC721Received(address(0), to, tokenId, data),
968             "ERC721: transfer to non ERC721Receiver implementer"
969         );
970     }
971 
972     /**
973      * @dev Mints `tokenId` and transfers it to `to`.
974      *
975      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
976      *
977      * Requirements:
978      *
979      * - `tokenId` must not exist.
980      * - `to` cannot be the zero address.
981      *
982      * Emits a {Transfer} event.
983      */
984     function _mint(address to, uint256 tokenId) internal virtual {
985         require(to != address(0), "ERC721: mint to the zero address");
986         require(!_exists(tokenId), "ERC721: token already minted");
987         _beforeTokenTransfer(address(0), to, tokenId);
988         _balances[to] += 1;
989         _owners[tokenId] = to;
990         emit Transfer(address(0), to, tokenId);
991         _afterTokenTransfer(address(0), to, tokenId);
992     }
993 
994     /**
995      * @dev Destroys `tokenId`.
996      * The approval is cleared when the token is burned.
997      *
998      * Requirements:
999      *
1000      * - `tokenId` must exist.
1001      *
1002      * Emits a {Transfer} event.
1003      */
1004     function _burn(uint256 tokenId) internal virtual {
1005         address owner = ERC721.ownerOf(tokenId);
1006         _beforeTokenTransfer(owner, address(0), tokenId);
1007         // Clear approvals
1008         _approve(address(0), tokenId);
1009         _balances[owner] -= 1;
1010         delete _owners[tokenId];
1011         emit Transfer(owner, address(0), tokenId);
1012         _afterTokenTransfer(owner, address(0), tokenId);
1013     }
1014 
1015     /**
1016      * @dev Transfers `tokenId` from `from` to `to`.
1017      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1018      *
1019      * Requirements:
1020      *
1021      * - `to` cannot be the zero address.
1022      * - `tokenId` token must be owned by `from`.
1023      *
1024      * Emits a {Transfer} event.
1025      */
1026     function _transfer(
1027         address from,
1028         address to,
1029         uint256 tokenId
1030     ) internal virtual {
1031         require(
1032             ERC721.ownerOf(tokenId) == from,
1033             "ERC721: transfer from incorrect owner"
1034         );
1035         require(to != address(0), "ERC721: transfer to the zero address");
1036         _beforeTokenTransfer(from, to, tokenId);
1037         // Clear approvals from the previous owner
1038         _approve(address(0), tokenId);
1039         _balances[from] -= 1;
1040         _balances[to] += 1;
1041         _owners[tokenId] = to;
1042         emit Transfer(from, to, tokenId);
1043         _afterTokenTransfer(from, to, tokenId);
1044     }
1045 
1046     /**
1047      * @dev Approve `to` to operate on `tokenId`
1048      *
1049      * Emits an {Approval} event.
1050      */
1051     function _approve(address to, uint256 tokenId) internal virtual {
1052         _tokenApprovals[tokenId] = to;
1053         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1054     }
1055 
1056     /**
1057      * @dev Approve `operator` to operate on all of `owner` tokens
1058      *
1059      * Emits an {ApprovalForAll} event.
1060      */
1061     function _setApprovalForAll(
1062         address owner,
1063         address operator,
1064         bool approved
1065     ) internal virtual {
1066         require(owner != operator, "ERC721: approve to caller");
1067         _operatorApprovals[owner][operator] = approved;
1068         emit ApprovalForAll(owner, operator, approved);
1069     }
1070 
1071     /**
1072      * @dev Reverts if the `tokenId` has not been minted yet.
1073      */
1074     function _requireMinted(uint256 tokenId) internal view virtual {
1075         require(_exists(tokenId), "ERC721: invalid token ID");
1076     }
1077 
1078     /**
1079      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1080      * The call is not executed if the target address is not a contract.
1081      *
1082      * @param from address representing the previous owner of the given token ID
1083      * @param to target address that will receive the tokens
1084      * @param tokenId uint256 ID of the token to be transferred
1085      * @param data bytes optional data to send along with the call
1086      * @return bool whether the call correctly returned the expected magic value
1087      */
1088     function _checkOnERC721Received(
1089         address from,
1090         address to,
1091         uint256 tokenId,
1092         bytes memory data
1093     ) private returns (bool) {
1094         if (to.isContract()) {
1095             try
1096                 IERC721Receiver(to).onERC721Received(
1097                     _msgSender(),
1098                     from,
1099                     tokenId,
1100                     data
1101                 )
1102             returns (bytes4 retval) {
1103                 return retval == IERC721Receiver.onERC721Received.selector;
1104             } catch (bytes memory reason) {
1105                 if (reason.length == 0) {
1106                     revert(
1107                         "ERC721: transfer to non ERC721Receiver implementer"
1108                     );
1109                 } else {
1110                     /// @solidity memory-safe-assembly
1111                     assembly {
1112                         revert(add(32, reason), mload(reason))
1113                     }
1114                 }
1115             }
1116         } else {
1117             return true;
1118         }
1119     }
1120 
1121     /**
1122      * @dev Hook that is called before any token transfer. This includes minting
1123      * and burning.
1124      *
1125      * Calling conditions:
1126      *
1127      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1128      * transferred to `to`.
1129      * - When `from` is zero, `tokenId` will be minted for `to`.
1130      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1131      * - `from` and `to` are never both zero.
1132      *
1133      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1134      */
1135     function _beforeTokenTransfer(
1136         address from,
1137         address to,
1138         uint256 tokenId
1139     ) internal virtual {}
1140 
1141     /**
1142      * @dev Hook that is called after any transfer of tokens. This includes
1143      * minting and burning.
1144      *
1145      * Calling conditions:
1146      *
1147      * - when `from` and `to` are both non-zero.
1148      * - `from` and `to` are never both zero.
1149      *
1150      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1151      */
1152     function _afterTokenTransfer(
1153         address from,
1154         address to,
1155         uint256 tokenId
1156     ) internal virtual {}
1157 }
1158 
1159 // File: openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1160 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1161 /**
1162  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1163  * @dev See https://eips.ethereum.org/EIPS/eip-721
1164  */
1165 interface IERC721Enumerable is IERC721 {
1166     /**
1167      * @dev Returns the total amount of tokens stored by the contract.
1168      */
1169     function totalSupply() external view returns (uint256);
1170 
1171     /**
1172      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1173      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1174      */
1175     function tokenOfOwnerByIndex(address owner, uint256 index)
1176         external
1177         view
1178         returns (uint256);
1179 
1180     /**
1181      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1182      * Use along with {totalSupply} to enumerate all tokens.
1183      */
1184     function tokenByIndex(uint256 index) external view returns (uint256);
1185 }
1186 
1187 // File: openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1188 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1189 /**
1190  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1191  * enumerability of all the token ids in the contract as well as all token ids owned by each
1192  * account.
1193  */
1194 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1195     // Mapping from owner to list of owned token IDs
1196     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1197     // Mapping from token ID to index of the owner tokens list
1198     mapping(uint256 => uint256) private _ownedTokensIndex;
1199     // Array with all token ids, used for enumeration
1200     uint256[] private _allTokens;
1201     // Mapping from token id to position in the allTokens array
1202     mapping(uint256 => uint256) private _allTokensIndex;
1203 
1204     /**
1205      * @dev See {IERC165-supportsInterface}.
1206      */
1207     function supportsInterface(bytes4 interfaceId)
1208         public
1209         view
1210         virtual
1211         override(IERC165, ERC721)
1212         returns (bool)
1213     {
1214         return
1215             interfaceId == type(IERC721Enumerable).interfaceId ||
1216             super.supportsInterface(interfaceId);
1217     }
1218 
1219     /**
1220      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1221      */
1222     function tokenOfOwnerByIndex(address owner, uint256 index)
1223         public
1224         view
1225         virtual
1226         override
1227         returns (uint256)
1228     {
1229         require(
1230             index < ERC721.balanceOf(owner),
1231             "ERC721Enumerable: owner index out of bounds"
1232         );
1233         return _ownedTokens[owner][index];
1234     }
1235 
1236     /**
1237      * @dev See {IERC721Enumerable-totalSupply}.
1238      */
1239     function totalSupply() public view virtual override returns (uint256) {
1240         return _allTokens.length;
1241     }
1242 
1243     /**
1244      * @dev See {IERC721Enumerable-tokenByIndex}.
1245      */
1246     function tokenByIndex(uint256 index)
1247         public
1248         view
1249         virtual
1250         override
1251         returns (uint256)
1252     {
1253         require(
1254             index < ERC721Enumerable.totalSupply(),
1255             "ERC721Enumerable: global index out of bounds"
1256         );
1257         return _allTokens[index];
1258     }
1259 
1260     /**
1261      * @dev Hook that is called before any token transfer. This includes minting
1262      * and burning.
1263      *
1264      * Calling conditions:
1265      *
1266      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1267      * transferred to `to`.
1268      * - When `from` is zero, `tokenId` will be minted for `to`.
1269      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1270      * - `from` cannot be the zero address.
1271      * - `to` cannot be the zero address.
1272      *
1273      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1274      */
1275     function _beforeTokenTransfer(
1276         address from,
1277         address to,
1278         uint256 tokenId
1279     ) internal virtual override {
1280         super._beforeTokenTransfer(from, to, tokenId);
1281         if (from == address(0)) {
1282             _addTokenToAllTokensEnumeration(tokenId);
1283         } else if (from != to) {
1284             _removeTokenFromOwnerEnumeration(from, tokenId);
1285         }
1286         if (to == address(0)) {
1287             _removeTokenFromAllTokensEnumeration(tokenId);
1288         } else if (to != from) {
1289             _addTokenToOwnerEnumeration(to, tokenId);
1290         }
1291     }
1292 
1293     /**
1294      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1295      * @param to address representing the new owner of the given token ID
1296      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1297      */
1298     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1299         uint256 length = ERC721.balanceOf(to);
1300         _ownedTokens[to][length] = tokenId;
1301         _ownedTokensIndex[tokenId] = length;
1302     }
1303 
1304     /**
1305      * @dev Private function to add a token to this extension's token tracking data structures.
1306      * @param tokenId uint256 ID of the token to be added to the tokens list
1307      */
1308     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1309         _allTokensIndex[tokenId] = _allTokens.length;
1310         _allTokens.push(tokenId);
1311     }
1312 
1313     /**
1314      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1315      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1316      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1317      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1318      * @param from address representing the previous owner of the given token ID
1319      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1320      */
1321     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1322         private
1323     {
1324         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1325         // then delete the last slot (swap and pop).
1326         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1327         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1328         // When the token to delete is the last token, the swap operation is unnecessary
1329         if (tokenIndex != lastTokenIndex) {
1330             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1331             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1332             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1333         }
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
1347         uint256 lastTokenIndex = _allTokens.length - 1;
1348         uint256 tokenIndex = _allTokensIndex[tokenId];
1349         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1350         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1351         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1352         uint256 lastTokenId = _allTokens[lastTokenIndex];
1353         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1354         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1355         // This also deletes the contents at the last position of the array
1356         delete _allTokensIndex[tokenId];
1357         _allTokens.pop();
1358     }
1359 }
1360 
1361 // File: openzeppelin-contracts/contracts/interfaces/IERC2981.sol
1362 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1363 /**
1364  * @dev Interface for the NFT Royalty Standard.
1365  *
1366  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1367  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1368  *
1369  * _Available since v4.5._
1370  */
1371 interface IERC2981 is IERC165 {
1372     /**
1373      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1374      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1375      */
1376     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1377         external
1378         view
1379         returns (address receiver, uint256 royaltyAmount);
1380 }
1381 
1382 contract MechaMonkeysCollection is ERC721Enumerable, IERC2981 {
1383     // Owner of the contract with the ability to advance the `ReleasePhase`.
1384     // NOTE: When the owner advances the `ReleasePhase` to `ReleasePhase.COMPLETED`,
1385     //        the owner will not have any further ability to modify the release phase.
1386     address public contractOwner;
1387     // Address to send the trade commission payouts.
1388     // NOTE: A contract can be referenced to split transactions, or do further logic.
1389     address payable public transactionPayoutAddress;
1390     // Address of the artist. This address with automatically be assigned a special token
1391     //  specifically for the artist.
1392     address public artistAddress;
1393     // Iterate from 1 to 9999 (inclusive) tokens.
1394     uint256 public nextAvailableToken = 1;
1395     uint256 public constant TOKEN_FIRST = 1;
1396     uint256 public constant TOKEN_LAST = 9999;
1397     // Artist's special symbolic token (not part of official collection).
1398     uint256 public constant ARTIST_SPECIAL_TOKEN = 10000;
1399     // Fee denominator to determine the fraction of a transaction to use for payout.
1400     uint256 public constant TRANSACTION_FEE_DENOMINATOR = 18; // 1/18 ~= 0.0555 ~= 5.55%
1401     // The three phases during the release. Each phase changes what `_baseURI` returns, but each
1402     //  phase's URI is defined at construction of the contract. The `contractOwner` can trigger an advance
1403     //  to the next release phase but not the URI itself.
1404     //  NOTE: When `ReleasePhase.COMPLETED` is reached, `contractOwner` will no longer have any ability to
1405     //         modify the release phase.
1406     enum ReleasePhase {
1407         WAITING,
1408         MYSTERY,
1409         PARTIAL,
1410         COMPLETED
1411     }
1412     ReleasePhase public currentReleasePhase;
1413     string public releasePhaseURI_waiting;
1414     string public releasePhaseURI_mystery;
1415     string public releasePhaseURI_partial;
1416     string public releasePhaseURI_completed;
1417 
1418     constructor(
1419         address payable transactionPayoutAddress_,
1420         address artistAddress_,
1421         string memory releasePhaseURI_waiting_,
1422         string memory releasePhaseURI_mystery_,
1423         string memory releasePhaseURI_partial_,
1424         string memory releasePhaseURI_completed_
1425     ) ERC721("Mecha Monkeys", "MECHA") {
1426         contractOwner = _msgSender();
1427         transactionPayoutAddress = transactionPayoutAddress_;
1428         artistAddress = artistAddress_;
1429         // Start in release phase `ReleasePhase.WAITING`
1430         currentReleasePhase = ReleasePhase.WAITING;
1431         releasePhaseURI_waiting = releasePhaseURI_waiting_;
1432         releasePhaseURI_mystery = releasePhaseURI_mystery_;
1433         releasePhaseURI_partial = releasePhaseURI_partial_;
1434         releasePhaseURI_completed = releasePhaseURI_completed_;
1435         // Mint artist's special symbolic token (not part of official collection).
1436         _mint(artistAddress, ARTIST_SPECIAL_TOKEN);
1437     }
1438 
1439     /**
1440      * NOTE: Do NOT send Ether to this contract! It will be considered a donation.
1441      *       Do NOT send Tokens to this contract! They will be lost forever!
1442      *       This contract does not utilize received Ether by design.
1443      */
1444     receive() external payable {}
1445 
1446     /**
1447      * @dev Allow withdraw by the owner or artist.
1448      * NOTE: This contract should not hold any Ether except for donations.
1449      */
1450     function withdraw() public {
1451         // Only `contractOwner` and `artistAddress` can trigger a withdrawal.
1452         require(_msgSender() == contractOwner || _msgSender() == artistAddress);
1453         // Withdraw all Ether.
1454         transactionPayoutAddress.transfer(address(this).balance);
1455     }
1456 
1457     /**
1458      * @dev See {IERC165-supportsInterface}.
1459      * NOTE: ERC721 already accounted for in call to base.
1460      */
1461     function supportsInterface(bytes4 interfaceId_)
1462         public
1463         view
1464         virtual
1465         override(ERC721Enumerable, IERC165)
1466         returns (bool)
1467     {
1468         return
1469             interfaceId_ == type(IERC721Enumerable).interfaceId ||
1470             interfaceId_ == type(IERC2981).interfaceId ||
1471             super.supportsInterface(interfaceId_);
1472     }
1473 
1474     /**
1475      * @dev Public function for any address to mint only one new token.
1476      * NOTE: Token IDs do NOT represent rarity; each ID's token attributes will be randomized.
1477      */
1478     function mint() public {
1479         // Each address can only mint one token each.
1480         require(
1481             balanceOf(_msgSender()) == 0,
1482             "MM: Each address can only mint one token each."
1483         );
1484         // Total minting is limited from Ids of `TOKEN_FIRST` to a max of `TOKEN_LAST`.
1485         require(
1486             nextAvailableToken <= TOKEN_LAST,
1487             "MM: All tokens have been minted."
1488         );
1489         // Mint the next available token to the sender.
1490         _safeMint(_msgSender(), nextAvailableToken);
1491         // Advance token iterator
1492         nextAvailableToken += 1;
1493     }
1494 
1495     /**
1496      * @dev Returns the amount of tokens left to be minted.
1497      */
1498     function getAmountLeftToMint() public view returns (uint256) {
1499         if (nextAvailableToken > TOKEN_LAST) {
1500             return 0;
1501         } else {
1502             return (TOKEN_LAST + 1) - nextAvailableToken;
1503         }
1504     }
1505 
1506     /**
1507      * @dev Advance `currentReleasePhase` to the next pre-defined ReleasePhase.
1508      *       Only callable by the owner and when `ReleasePhase.COMPLETED` is reached,
1509      *       no further modifications to the release are allowed.
1510      */
1511     function nextReleasePhase() public {
1512         // Only callable by `_owner`
1513         require(_msgSender() == contractOwner);
1514         // Can only be called if not in `ReleasePhase.COMPLETED`
1515         require(currentReleasePhase != ReleasePhase.COMPLETED);
1516         // WAITING -> MYSTERY
1517         if (currentReleasePhase == ReleasePhase.WAITING) {
1518             currentReleasePhase = ReleasePhase.MYSTERY;
1519         }
1520         // MYSTERY -> PARTIAL
1521         else if (currentReleasePhase == ReleasePhase.MYSTERY) {
1522             currentReleasePhase = ReleasePhase.PARTIAL;
1523         }
1524         // PARTIAL -> COMPLETED
1525         else if (currentReleasePhase == ReleasePhase.PARTIAL) {
1526             currentReleasePhase = ReleasePhase.COMPLETED;
1527         } else {
1528             assert(false); // This line should never be reached.
1529         }
1530     }
1531 
1532     /**
1533      * @dev Base URI for computing {tokenURI}. Can change based on `currentReleasePhase`/`currentBaseURI`,
1534      *       but only until `currentReleasePhase` reaches `COMPLETED`, which then the baseURI is finalized.
1535      */
1536     function _baseURI()
1537         internal
1538         view
1539         virtual
1540         override(ERC721)
1541         returns (string memory)
1542     {
1543         if (currentReleasePhase == ReleasePhase.WAITING) {
1544             return releasePhaseURI_waiting;
1545         } else if (currentReleasePhase == ReleasePhase.MYSTERY) {
1546             return releasePhaseURI_mystery;
1547         } else if (currentReleasePhase == ReleasePhase.PARTIAL) {
1548             return releasePhaseURI_partial;
1549         }
1550         // else if (currentReleasePhase == ReleasePhase.COMPLETED)
1551         return releasePhaseURI_completed;
1552     }
1553 
1554     function tokenURI(uint256 tokenId)
1555         public
1556         view
1557         override(ERC721)
1558         returns (string memory)
1559     {
1560         return string.concat(super.tokenURI(tokenId), ".json");
1561     }
1562 
1563     /**
1564      * @dev Interject before transfer to disallow burning of tokens, only allow
1565      *       minting of tokens after `ReleasePhase.WAITING`, and allow special permission
1566      *       for artist to mint a special token meant just for the artist (not part of official collection).
1567      */
1568     function _beforeTokenTransfer(
1569         address from_,
1570         address to_,
1571         uint256 tokenId_
1572     ) internal virtual override(ERC721Enumerable) {
1573         super._beforeTokenTransfer(from_, to_, tokenId_);
1574         // Disallow burning
1575         require(to_ != address(0), "MM: Token cannot be burned.");
1576         // Only the artist can mint the artist's special token upon contract creation.
1577         if (
1578             _msgSender() == contractOwner &&
1579             tokenId_ == ARTIST_SPECIAL_TOKEN &&
1580             currentReleasePhase == ReleasePhase.WAITING
1581         ) {
1582             return; //OK
1583         }
1584         // Can only transfer tokens after minting has started.
1585         require(
1586             currentReleasePhase != ReleasePhase.WAITING,
1587             "MM: Transfers and minting cannot occur yet."
1588         );
1589     }
1590 
1591     /**
1592      * @dev Disallow token burning.
1593      * NOTE: This function is never called, but disable just in case, and to be verbose.
1594      */
1595     function _burn(uint256 tokenId_) internal virtual override {
1596         require(false, "MM: Token cannot be burned.");
1597     }
1598 
1599     /**
1600      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1601      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1602      * NOTE: All `tokenId`s have the same royalty ratio.
1603      */
1604     function royaltyInfo(uint256 tokenId_, uint256 salePrice_)
1605         external
1606         view
1607         override(IERC2981)
1608         returns (address, uint256)
1609     {
1610         address receiver = transactionPayoutAddress;
1611         uint256 royaltyAmount = salePrice_ / TRANSACTION_FEE_DENOMINATOR;
1612         return (receiver, royaltyAmount);
1613     }
1614 }