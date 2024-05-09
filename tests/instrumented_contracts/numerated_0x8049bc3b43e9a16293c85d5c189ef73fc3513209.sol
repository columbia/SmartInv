1 pragma solidity ^0.8.0;
2  
3 /**
4  * @dev Interface of the ERC165 standard, as defined in the
5  * https://eips.ethereum.org/EIPS/eip-165[EIP].
6  *
7  * Implementers can declare support of contract interfaces, which can then be
8  * queried by others ({ERC165Checker}).
9  *
10  * For an implementation, see {ERC165}.
11  */
12 interface IERC165 {
13     /**
14      * @dev Returns true if this contract implements the interface defined by
15      * `interfaceId`. See the corresponding
16      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
17      * to learn more about how these ids are created.
18      *
19      * This function call must use less than 30 000 gas.
20      */
21     function supportsInterface(bytes4 interfaceId) external view returns (bool);
22 }
23  
24  
25 
26  
27 // -License-Identifier: MIT
28 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
29  
30 pragma solidity ^0.8.0;
31  
32 /**
33  * @dev Required interface of an ERC721 compliant contract.
34  */
35 interface IERC721 is IERC165 {
36     /**
37      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
38      */
39     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
40  
41     /**
42      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
43      */
44     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
45  
46     /**
47      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
48      */
49     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
50  
51     /**
52      * @dev Returns the number of tokens in ``owner``'s account.
53      */
54     function balanceOf(address owner) external view returns (uint256 balance);
55  
56     /**
57      * @dev Returns the owner of the `tokenId` token.
58      *
59      * Requirements:
60      *
61      * - `tokenId` must exist.
62      */
63     function ownerOf(uint256 tokenId) external view returns (address owner);
64  
65     /**
66      * @dev Safely transfers `tokenId` token from `from` to `to`.
67      *
68      * Requirements:
69      *
70      * - `from` cannot be the zero address.
71      * - `to` cannot be the zero address.
72      * - `tokenId` token must exist and be owned by `from`.
73      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
74      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
75      *
76      * Emits a {Transfer} event.
77      */
78     function safeTransferFrom(
79         address from,
80         address to,
81         uint256 tokenId,
82         bytes calldata data
83     ) external;
84  
85     /**
86      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
87      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
88      *
89      * Requirements:
90      *
91      * - `from` cannot be the zero address.
92      * - `to` cannot be the zero address.
93      * - `tokenId` token must exist and be owned by `from`.
94      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
95      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
96      *
97      * Emits a {Transfer} event.
98      */
99     function safeTransferFrom(
100         address from,
101         address to,
102         uint256 tokenId
103     ) external;
104  
105     /**
106      * @dev Transfers `tokenId` token from `from` to `to`.
107      *
108      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
109      *
110      * Requirements:
111      *
112      * - `from` cannot be the zero address.
113      * - `to` cannot be the zero address.
114      * - `tokenId` token must be owned by `from`.
115      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
116      *
117      * Emits a {Transfer} event.
118      */
119     function transferFrom(
120         address from,
121         address to,
122         uint256 tokenId
123     ) external;
124  
125     /**
126      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
127      * The approval is cleared when the token is transferred.
128      *
129      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
130      *
131      * Requirements:
132      *
133      * - The caller must own the token or be an approved operator.
134      * - `tokenId` must exist.
135      *
136      * Emits an {Approval} event.
137      */
138     function approve(address to, uint256 tokenId) external;
139  
140     /**
141      * @dev Approve or remove `operator` as an operator for the caller.
142      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
143      *
144      * Requirements:
145      *
146      * - The `operator` cannot be the caller.
147      *
148      * Emits an {ApprovalForAll} event.
149      */
150     function setApprovalForAll(address operator, bool _approved) external;
151  
152     /**
153      * @dev Returns the account approved for `tokenId` token.
154      *
155      * Requirements:
156      *
157      * - `tokenId` must exist.
158      */
159     function getApproved(uint256 tokenId) external view returns (address operator);
160  
161     /**
162      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
163      *
164      * See {setApprovalForAll}
165      */
166     function isApprovedForAll(address owner, address operator) external view returns (bool);
167 }
168  
169  
170 
171  
172 // -License-Identifier: MIT
173 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
174  
175 pragma solidity ^0.8.0;
176  
177 /**
178  * @title ERC721 token receiver interface
179  * @dev Interface for any contract that wants to support safeTransfers
180  * from ERC721 asset contracts.
181  */
182 interface IERC721Receiver {
183     /**
184      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
185      * by `operator` from `from`, this function is called.
186      *
187      * It must return its Solidity selector to confirm the token transfer.
188      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
189      *
190      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
191      */
192     function onERC721Received(
193         address operator,
194         address from,
195         uint256 tokenId,
196         bytes calldata data
197     ) external returns (bytes4);
198 }
199  
200  
201 
202  
203 // -License-Identifier: MIT
204 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
205  
206 pragma solidity ^0.8.0;
207  
208 /**
209  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
210  * @dev See https://eips.ethereum.org/EIPS/eip-721
211  */
212 interface IERC721Metadata is IERC721 {
213     /**
214      * @dev Returns the token collection name.
215      */
216     function name() external view returns (string memory);
217  
218     /**
219      * @dev Returns the token collection symbol.
220      */
221     function symbol() external view returns (string memory);
222  
223     /**
224      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
225      */
226     function tokenURI(uint256 tokenId) external view returns (string memory);
227 }
228  
229  
230 
231  
232 // -License-Identifier: MIT
233 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
234  
235 pragma solidity ^0.8.1;
236  
237 /**
238  * @dev Collection of functions related to the address type
239  */
240 library Address {
241     /**
242      * @dev Returns true if `account` is a contract.
243      *
244      * [IMPORTANT]
245      * ====
246      * It is unsafe to assume that an address for which this function returns
247      * false is an externally-owned account (EOA) and not a contract.
248      *
249      * Among others, `isContract` will return false for the following
250      * types of addresses:
251      *
252      *  - an externally-owned account
253      *  - a contract in construction
254      *  - an address where a contract will be created
255      *  - an address where a contract lived, but was destroyed
256      * ====
257      *
258      * [IMPORTANT]
259      * ====
260      * You shouldn't rely on `isContract` to protect against flash loan attacks!
261      *
262      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
263      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
264      * constructor.
265      * ====
266      */
267     function isContract(address account) internal view returns (bool) {
268         // This method relies on extcodesize/address.code.length, which returns 0
269         // for contracts in construction, since the code is only stored at the end
270         // of the constructor execution.
271  
272         return account.code.length > 0;
273     }
274  
275     /**
276      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
277      * `recipient`, forwarding all available gas and reverting on errors.
278      *
279      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
280      * of certain opcodes, possibly making contracts go over the 2300 gas limit
281      * imposed by `transfer`, making them unable to receive funds via
282      * `transfer`. {sendValue} removes this limitation.
283      *
284      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
285      *
286      * IMPORTANT: because control is transferred to `recipient`, care must be
287      * taken to not create reentrancy vulnerabilities. Consider using
288      * {ReentrancyGuard} or the
289      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
290      */
291     function sendValue(address payable recipient, uint256 amount) internal {
292         require(address(this).balance >= amount, "Address: insufficient balance");
293  
294         (bool success,) = recipient.call{value : amount}("");
295         require(success, "Address: unable to send value, recipient may have reverted");
296     }
297  
298     /**
299      * @dev Performs a Solidity function call using a low level `call`. A
300      * plain `call` is an unsafe replacement for a function call: use this
301      * function instead.
302      *
303      * If `target` reverts with a revert reason, it is bubbled up by this
304      * function (like regular Solidity function calls).
305      *
306      * Returns the raw returned data. To convert to the expected return value,
307      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
308      *
309      * Requirements:
310      *
311      * - `target` must be a contract.
312      * - calling `target` with `data` must not revert.
313      *
314      * _Available since v3.1._
315      */
316     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
317         return functionCall(target, data, "Address: low-level call failed");
318     }
319  
320     /**
321      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
322      * `errorMessage` as a fallback revert reason when `target` reverts.
323      *
324      * _Available since v3.1._
325      */
326     function functionCall(
327         address target,
328         bytes memory data,
329         string memory errorMessage
330     ) internal returns (bytes memory) {
331         return functionCallWithValue(target, data, 0, errorMessage);
332     }
333  
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
336      * but also transferring `value` wei to `target`.
337      *
338      * Requirements:
339      *
340      * - the calling contract must have an ETH balance of at least `value`.
341      * - the called Solidity function must be `payable`.
342      *
343      * _Available since v3.1._
344      */
345     function functionCallWithValue(
346         address target,
347         bytes memory data,
348         uint256 value
349     ) internal returns (bytes memory) {
350         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
351     }
352  
353     /**
354      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
355      * with `errorMessage` as a fallback revert reason when `target` reverts.
356      *
357      * _Available since v3.1._
358      */
359     function functionCallWithValue(
360         address target,
361         bytes memory data,
362         uint256 value,
363         string memory errorMessage
364     ) internal returns (bytes memory) {
365         require(address(this).balance >= value, "Address: insufficient balance for call");
366         require(isContract(target), "Address: call to non-contract");
367  
368         (bool success, bytes memory returndata) = target.call{value : value}(data);
369         return verifyCallResult(success, returndata, errorMessage);
370     }
371  
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
374      * but performing a static call.
375      *
376      * _Available since v3.3._
377      */
378     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
379         return functionStaticCall(target, data, "Address: low-level static call failed");
380     }
381  
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
384      * but performing a static call.
385      *
386      * _Available since v3.3._
387      */
388     function functionStaticCall(
389         address target,
390         bytes memory data,
391         string memory errorMessage
392     ) internal view returns (bytes memory) {
393         require(isContract(target), "Address: static call to non-contract");
394  
395         (bool success, bytes memory returndata) = target.staticcall(data);
396         return verifyCallResult(success, returndata, errorMessage);
397     }
398  
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
401      * but performing a delegate call.
402      *
403      * _Available since v3.4._
404      */
405     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
406         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
407     }
408  
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
411      * but performing a delegate call.
412      *
413      * _Available since v3.4._
414      */
415     function functionDelegateCall(
416         address target,
417         bytes memory data,
418         string memory errorMessage
419     ) internal returns (bytes memory) {
420         require(isContract(target), "Address: delegate call to non-contract");
421  
422         (bool success, bytes memory returndata) = target.delegatecall(data);
423         return verifyCallResult(success, returndata, errorMessage);
424     }
425  
426     /**
427      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
428      * revert reason using the provided one.
429      *
430      * _Available since v4.3._
431      */
432     function verifyCallResult(
433         bool success,
434         bytes memory returndata,
435         string memory errorMessage
436     ) internal pure returns (bytes memory) {
437         if (success) {
438             return returndata;
439         } else {
440             // Look for revert reason and bubble it up if present
441             if (returndata.length > 0) {
442                 // The easiest way to bubble the revert reason is using memory via assembly
443                 /// @solidity memory-safe-assembly
444                 assembly {
445                     let returndata_size := mload(returndata)
446                     revert(add(32, returndata), returndata_size)
447                 }
448             } else {
449                 revert(errorMessage);
450             }
451         }
452     }
453 }
454  
455  
456 
457  
458 // -License-Identifier: MIT
459 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
460  
461 pragma solidity ^0.8.0;
462  
463 /**
464  * @dev Provides information about the current execution context, including the
465  * sender of the transaction and its data. While these are generally available
466  * via msg.sender and msg.data, they should not be accessed in such a direct
467  * manner, since when dealing with meta-transactions the account sending and
468  * paying for execution may not be the actual sender (as far as an application
469  * is concerned).
470  *
471  * This contract is only required for intermediate, library-like contracts.
472  */
473 abstract contract Context {
474     function _msgSender() internal view virtual returns (address) {
475         return msg.sender;
476     }
477  
478     function _msgData() internal view virtual returns (bytes calldata) {
479         return msg.data;
480     }
481 }
482  
483  
484 
485  
486 // -License-Identifier: MIT
487 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
488  
489 pragma solidity ^0.8.0;
490  
491 /**
492  * @dev String operations.
493  */
494 library Strings {
495     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
496     uint8 private constant _ADDRESS_LENGTH = 20;
497  
498     /**
499      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
500      */
501     function toString(uint256 value) internal pure returns (string memory) {
502         // Inspired by OraclizeAPI's implementation - MIT licence
503         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
504  
505         if (value == 0) {
506             return "0";
507         }
508         uint256 temp = value;
509         uint256 digits;
510         while (temp != 0) {
511             digits++;
512             temp /= 10;
513         }
514         bytes memory buffer = new bytes(digits);
515         while (value != 0) {
516             digits -= 1;
517             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
518             value /= 10;
519         }
520         return string(buffer);
521     }
522  
523     /**
524      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
525      */
526     function toHexString(uint256 value) internal pure returns (string memory) {
527         if (value == 0) {
528             return "0x00";
529         }
530         uint256 temp = value;
531         uint256 length = 0;
532         while (temp != 0) {
533             length++;
534             temp >>= 8;
535         }
536         return toHexString(value, length);
537     }
538  
539     /**
540      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
541      */
542     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
543         bytes memory buffer = new bytes(2 * length + 2);
544         buffer[0] = "0";
545         buffer[1] = "x";
546         for (uint256 i = 2 * length + 1; i > 1; --i) {
547             buffer[i] = _HEX_SYMBOLS[value & 0xf];
548             value >>= 4;
549         }
550         require(value == 0, "Strings: hex length insufficient");
551         return string(buffer);
552     }
553  
554     /**
555      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
556      */
557     function toHexString(address addr) internal pure returns (string memory) {
558         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
559     }
560 }
561  
562  
563 
564  
565 // -License-Identifier: MIT
566 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
567  
568 pragma solidity ^0.8.0;
569  
570 /**
571  * @dev Implementation of the {IERC165} interface.
572  *
573  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
574  * for the additional interface id that will be supported. For example:
575  *
576  * ```solidity
577  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
578  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
579  * }
580  * ```
581  *
582  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
583  */
584 abstract contract ERC165 is IERC165 {
585     /**
586      * @dev See {IERC165-supportsInterface}.
587      */
588     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
589         return interfaceId == type(IERC165).interfaceId;
590     }
591 }
592  
593  
594 
595  
596 // -License-Identifier: MIT
597 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
598  
599 pragma solidity ^0.8.0;
600  
601  
602  
603  
604  
605  
606  
607 /**
608  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
609  * the Metadata extension, but not including the Enumerable extension, which is available separately as
610  * {ERC721Enumerable}.
611  */
612 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
613     using Address for address;
614     using Strings for uint256;
615  
616     // Token name
617     string private _name;
618  
619     // Token symbol
620     string private _symbol;
621  
622     // Mapping from token ID to owner address
623     mapping(uint256 => address) private _owners;
624  
625     // Mapping owner address to token count
626     mapping(address => uint256) private _balances;
627  
628     // Mapping from token ID to approved address
629     mapping(uint256 => address) private _tokenApprovals;
630  
631     // Mapping from owner to operator approvals
632     mapping(address => mapping(address => bool)) private _operatorApprovals;
633  
634     /**
635      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
636      */
637     constructor(string memory name_, string memory symbol_) {
638         _name = name_;
639         _symbol = symbol_;
640     }
641  
642     /**
643      * @dev See {IERC165-supportsInterface}.
644      */
645     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
646         return
647         interfaceId == type(IERC721).interfaceId ||
648         interfaceId == type(IERC721Metadata).interfaceId ||
649         super.supportsInterface(interfaceId);
650     }
651  
652     /**
653      * @dev See {IERC721-balanceOf}.
654      */
655     function balanceOf(address owner) public view virtual override returns (uint256) {
656         require(owner != address(0), "ERC721: address zero is not a valid owner");
657         return _balances[owner];
658     }
659  
660     /**
661      * @dev See {IERC721-ownerOf}.
662      */
663     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
664         address owner = _owners[tokenId];
665         require(owner != address(0), "ERC721: invalid token ID");
666         return owner;
667     }
668  
669     /**
670      * @dev See {IERC721Metadata-name}.
671      */
672     function name() public view virtual override returns (string memory) {
673         return _name;
674     }
675  
676     /**
677      * @dev See {IERC721Metadata-symbol}.
678      */
679     function symbol() public view virtual override returns (string memory) {
680         return _symbol;
681     }
682  
683     /**
684      * @dev See {IERC721Metadata-tokenURI}.
685      */
686     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
687         _requireMinted(tokenId);
688  
689         string memory baseURI = _baseURI();
690         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
691     }
692  
693     /**
694      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
695      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
696      * by default, can be overridden in child contracts.
697      */
698     function _baseURI() internal view virtual returns (string memory) {
699         return "";
700     }
701  
702     /**
703      * @dev See {IERC721-approve}.
704      */
705     function approve(address to, uint256 tokenId) public virtual override {
706         address owner = ERC721.ownerOf(tokenId);
707         require(to != owner, "ERC721: approval to current owner");
708  
709         require(
710             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
711             "ERC721: approve caller is not token owner nor approved for all"
712         );
713  
714         _approve(to, tokenId);
715     }
716  
717     /**
718      * @dev See {IERC721-getApproved}.
719      */
720     function getApproved(uint256 tokenId) public view virtual override returns (address) {
721         _requireMinted(tokenId);
722  
723         return _tokenApprovals[tokenId];
724     }
725  
726     /**
727      * @dev See {IERC721-setApprovalForAll}.
728      */
729     function setApprovalForAll(address operator, bool approved) public virtual override {
730         _setApprovalForAll(_msgSender(), operator, approved);
731     }
732  
733     /**
734      * @dev See {IERC721-isApprovedForAll}.
735      */
736     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
737         return _operatorApprovals[owner][operator];
738     }
739  
740     /**
741      * @dev See {IERC721-transferFrom}.
742      */
743     function transferFrom(
744         address from,
745         address to,
746         uint256 tokenId
747     ) public virtual override {
748         //solhint-disable-next-line max-line-length
749         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
750  
751         _transfer(from, to, tokenId);
752     }
753  
754     /**
755      * @dev See {IERC721-safeTransferFrom}.
756      */
757     function safeTransferFrom(
758         address from,
759         address to,
760         uint256 tokenId
761     ) public virtual override {
762         safeTransferFrom(from, to, tokenId, "");
763     }
764  
765     /**
766      * @dev See {IERC721-safeTransferFrom}.
767      */
768     function safeTransferFrom(
769         address from,
770         address to,
771         uint256 tokenId,
772         bytes memory data
773     ) public virtual override {
774         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
775         _safeTransfer(from, to, tokenId, data);
776     }
777  
778     /**
779      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
780      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
781      *
782      * `data` is additional data, it has no specified format and it is sent in call to `to`.
783      *
784      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
785      * implement alternative mechanisms to perform token transfer, such as signature-based.
786      *
787      * Requirements:
788      *
789      * - `from` cannot be the zero address.
790      * - `to` cannot be the zero address.
791      * - `tokenId` token must exist and be owned by `from`.
792      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
793      *
794      * Emits a {Transfer} event.
795      */
796     function _safeTransfer(
797         address from,
798         address to,
799         uint256 tokenId,
800         bytes memory data
801     ) internal virtual {
802         _transfer(from, to, tokenId);
803         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
804     }
805  
806     /**
807      * @dev Returns whether `tokenId` exists.
808      *
809      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
810      *
811      * Tokens start existing when they are minted (`_mint`),
812      * and stop existing when they are burned (`_burn`).
813      */
814     function _exists(uint256 tokenId) internal view virtual returns (bool) {
815         return _owners[tokenId] != address(0);
816     }
817  
818     /**
819      * @dev Returns whether `spender` is allowed to manage `tokenId`.
820      *
821      * Requirements:
822      *
823      * - `tokenId` must exist.
824      */
825     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
826         address owner = ERC721.ownerOf(tokenId);
827         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
828     }
829  
830     /**
831      * @dev Safely mints `tokenId` and transfers it to `to`.
832      *
833      * Requirements:
834      *
835      * - `tokenId` must not exist.
836      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
837      *
838      * Emits a {Transfer} event.
839      */
840     function _safeMint(address to, uint256 tokenId) internal virtual {
841         _safeMint(to, tokenId, "");
842     }
843  
844     /**
845      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
846      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
847      */
848     function _safeMint(
849         address to,
850         uint256 tokenId,
851         bytes memory data
852     ) internal virtual {
853         _mint(to, tokenId);
854         require(
855             _checkOnERC721Received(address(0), to, tokenId, data),
856             "ERC721: transfer to non ERC721Receiver implementer"
857         );
858     }
859  
860     /**
861      * @dev Mints `tokenId` and transfers it to `to`.
862      *
863      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
864      *
865      * Requirements:
866      *
867      * - `tokenId` must not exist.
868      * - `to` cannot be the zero address.
869      *
870      * Emits a {Transfer} event.
871      */
872     function _mint(address to, uint256 tokenId) internal virtual {
873         require(to != address(0), "ERC721: mint to the zero address");
874         require(!_exists(tokenId), "ERC721: token already minted");
875  
876         _beforeTokenTransfer(address(0), to, tokenId);
877  
878         _balances[to] += 1;
879         _owners[tokenId] = to;
880  
881         emit Transfer(address(0), to, tokenId);
882  
883         _afterTokenTransfer(address(0), to, tokenId);
884     }
885  
886     /**
887      * @dev Destroys `tokenId`.
888      * The approval is cleared when the token is burned.
889      *
890      * Requirements:
891      *
892      * - `tokenId` must exist.
893      *
894      * Emits a {Transfer} event.
895      */
896     function _burn(uint256 tokenId) internal virtual {
897         address owner = ERC721.ownerOf(tokenId);
898  
899         _beforeTokenTransfer(owner, address(0), tokenId);
900  
901         // Clear approvals
902         _approve(address(0), tokenId);
903  
904         _balances[owner] -= 1;
905         delete _owners[tokenId];
906  
907         emit Transfer(owner, address(0), tokenId);
908  
909         _afterTokenTransfer(owner, address(0), tokenId);
910     }
911  
912     /**
913      * @dev Transfers `tokenId` from `from` to `to`.
914      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
915      *
916      * Requirements:
917      *
918      * - `to` cannot be the zero address.
919      * - `tokenId` token must be owned by `from`.
920      *
921      * Emits a {Transfer} event.
922      */
923     function _transfer(
924         address from,
925         address to,
926         uint256 tokenId
927     ) internal virtual {
928         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
929         require(to != address(0), "ERC721: transfer to the zero address");
930  
931         _beforeTokenTransfer(from, to, tokenId);
932  
933         // Clear approvals from the previous owner
934         _approve(address(0), tokenId);
935  
936         _balances[from] -= 1;
937         _balances[to] += 1;
938         _owners[tokenId] = to;
939  
940         emit Transfer(from, to, tokenId);
941  
942         _afterTokenTransfer(from, to, tokenId);
943     }
944  
945     /**
946      * @dev Approve `to` to operate on `tokenId`
947      *
948      * Emits an {Approval} event.
949      */
950     function _approve(address to, uint256 tokenId) internal virtual {
951         _tokenApprovals[tokenId] = to;
952         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
953     }
954  
955     /**
956      * @dev Approve `operator` to operate on all of `owner` tokens
957      *
958      * Emits an {ApprovalForAll} event.
959      */
960     function _setApprovalForAll(
961         address owner,
962         address operator,
963         bool approved
964     ) internal virtual {
965         require(owner != operator, "ERC721: approve to caller");
966         _operatorApprovals[owner][operator] = approved;
967         emit ApprovalForAll(owner, operator, approved);
968     }
969  
970     /**
971      * @dev Reverts if the `tokenId` has not been minted yet.
972      */
973     function _requireMinted(uint256 tokenId) internal view virtual {
974         require(_exists(tokenId), "ERC721: invalid token ID");
975     }
976  
977     /**
978      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
979      * The call is not executed if the target address is not a contract.
980      *
981      * @param from address representing the previous owner of the given token ID
982      * @param to target address that will receive the tokens
983      * @param tokenId uint256 ID of the token to be transferred
984      * @param data bytes optional data to send along with the call
985      * @return bool whether the call correctly returned the expected magic value
986      */
987     function _checkOnERC721Received(
988         address from,
989         address to,
990         uint256 tokenId,
991         bytes memory data
992     ) private returns (bool) {
993         if (to.isContract()) {
994             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
995                 return retval == IERC721Receiver.onERC721Received.selector;
996             } catch (bytes memory reason) {
997                 if (reason.length == 0) {
998                     revert("ERC721: transfer to non ERC721Receiver implementer");
999                 } else {
1000                     /// @solidity memory-safe-assembly
1001                     assembly {
1002                         revert(add(32, reason), mload(reason))
1003                     }
1004                 }
1005             }
1006         } else {
1007             return true;
1008         }
1009     }
1010  
1011     /**
1012      * @dev Hook that is called before any token transfer. This includes minting
1013      * and burning.
1014      *
1015      * Calling conditions:
1016      *
1017      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1018      * transferred to `to`.
1019      * - When `from` is zero, `tokenId` will be minted for `to`.
1020      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1021      * - `from` and `to` are never both zero.
1022      *
1023      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1024      */
1025     function _beforeTokenTransfer(
1026         address from,
1027         address to,
1028         uint256 tokenId
1029     ) internal virtual {}
1030  
1031     /**
1032      * @dev Hook that is called after any transfer of tokens. This includes
1033      * minting and burning.
1034      *
1035      * Calling conditions:
1036      *
1037      * - when `from` and `to` are both non-zero.
1038      * - `from` and `to` are never both zero.
1039      *
1040      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1041      */
1042     function _afterTokenTransfer(
1043         address from,
1044         address to,
1045         uint256 tokenId
1046     ) internal virtual {}
1047 }
1048  
1049  
1050 
1051  
1052 // -License-Identifier: MIT
1053 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1054  
1055 pragma solidity ^0.8.0;
1056  
1057 /**
1058  * @dev Contract module which provides a basic access control mechanism, where
1059  * there is an account (an owner) that can be granted exclusive access to
1060  * specific functions.
1061  *
1062  * By default, the owner account will be the one that deploys the contract. This
1063  * can later be changed with {transferOwnership}.
1064  *
1065  * This module is used through inheritance. It will make available the modifier
1066  * `onlyOwner`, which can be applied to your functions to restrict their use to
1067  * the owner.
1068  */
1069 abstract contract Ownable is Context {
1070     address private _owner;
1071  
1072     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1073  
1074     /**
1075      * @dev Initializes the contract setting the deployer as the initial owner.
1076      */
1077     constructor() {
1078         _transferOwnership(_msgSender());
1079     }
1080  
1081     /**
1082      * @dev Throws if called by any account other than the owner.
1083      */
1084     modifier onlyOwner() {
1085         _checkOwner();
1086         _;
1087     }
1088  
1089     /**
1090      * @dev Returns the address of the current owner.
1091      */
1092     function owner() public view virtual returns (address) {
1093         return _owner;
1094     }
1095  
1096     /**
1097      * @dev Throws if the sender is not the owner.
1098      */
1099     function _checkOwner() internal view virtual {
1100         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1101     }
1102  
1103     /**
1104      * @dev Leaves the contract without owner. It will not be possible to call
1105      * `onlyOwner` functions anymore. Can only be called by the current owner.
1106      *
1107      * NOTE: Renouncing ownership will leave the contract without an owner,
1108      * thereby removing any functionality that is only available to the owner.
1109      */
1110     function renounceOwnership() public virtual onlyOwner {
1111         _transferOwnership(address(0));
1112     }
1113  
1114     /**
1115      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1116      * Can only be called by the current owner.
1117      */
1118     function transferOwnership(address newOwner) public virtual onlyOwner {
1119         require(newOwner != address(0), "Ownable: new owner is the zero address");
1120         _transferOwnership(newOwner);
1121     }
1122  
1123     /**
1124      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1125      * Internal function without access restriction.
1126      */
1127     function _transferOwnership(address newOwner) internal virtual {
1128         address oldOwner = _owner;
1129         _owner = newOwner;
1130         emit OwnershipTransferred(oldOwner, newOwner);
1131     }
1132 }
1133  
1134  
1135 
1136  
1137 // -License-Identifier: MIT
1138 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1139  
1140 pragma solidity ^0.8.0;
1141  
1142 /**
1143  * @dev Interface of the ERC20 standard as defined in the EIP.
1144  */
1145 interface IERC20 {
1146     /**
1147      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1148      * another (`to`).
1149      *
1150      * Note that `value` may be zero.
1151      */
1152     event Transfer(address indexed from, address indexed to, uint256 value);
1153  
1154     /**
1155      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1156      * a call to {approve}. `value` is the new allowance.
1157      */
1158     event Approval(address indexed owner, address indexed spender, uint256 value);
1159  
1160     /**
1161      * @dev Returns the amount of tokens in existence.
1162      */
1163     function totalSupply() external view returns (uint256);
1164  
1165     /**
1166      * @dev Returns the amount of tokens owned by `account`.
1167      */
1168     function balanceOf(address account) external view returns (uint256);
1169  
1170     /**
1171      * @dev Moves `amount` tokens from the caller's account to `to`.
1172      *
1173      * Returns a boolean value indicating whether the operation succeeded.
1174      *
1175      * Emits a {Transfer} event.
1176      */
1177     function transfer(address to, uint256 amount) external returns (bool);
1178  
1179     /**
1180      * @dev Returns the remaining number of tokens that `spender` will be
1181      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1182      * zero by default.
1183      *
1184      * This value changes when {approve} or {transferFrom} are called.
1185      */
1186     function allowance(address owner, address spender) external view returns (uint256);
1187  
1188     /**
1189      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1190      *
1191      * Returns a boolean value indicating whether the operation succeeded.
1192      *
1193      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1194      * that someone may use both the old and the new allowance by unfortunate
1195      * transaction ordering. One possible solution to mitigate this race
1196      * condition is to first reduce the spender's allowance to 0 and set the
1197      * desired value afterwards:
1198      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1199      *
1200      * Emits an {Approval} event.
1201      */
1202     function approve(address spender, uint256 amount) external returns (bool);
1203  
1204     /**
1205      * @dev Moves `amount` tokens from `from` to `to` using the
1206      * allowance mechanism. `amount` is then deducted from the caller's
1207      * allowance.
1208      *
1209      * Returns a boolean value indicating whether the operation succeeded.
1210      *
1211      * Emits a {Transfer} event.
1212      */
1213     function transferFrom(
1214         address from,
1215         address to,
1216         uint256 amount
1217     ) external returns (bool);
1218 }
1219  
1220  
1221 
1222  
1223 // -License-Identifier: MIT
1224 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1225  
1226 pragma solidity ^0.8.0;
1227  
1228 /**
1229  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1230  * @dev See https://eips.ethereum.org/EIPS/eip-721
1231  */
1232 interface IERC721Enumerable is IERC721 {
1233     /**
1234      * @dev Returns the total amount of tokens stored by the contract.
1235      */
1236     function totalSupply() external view returns (uint256);
1237  
1238     /**
1239      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1240      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1241      */
1242     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1243  
1244     /**
1245      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1246      * Use along with {totalSupply} to enumerate all tokens.
1247      */
1248     function tokenByIndex(uint256 index) external view returns (uint256);
1249 }
1250  
1251  
1252 
1253  
1254 // -License-Identifier: MIT
1255 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1256  
1257 pragma solidity ^0.8.0;
1258  
1259  
1260 /**
1261  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1262  * enumerability of all the token ids in the contract as well as all token ids owned by each
1263  * account.
1264  */
1265 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1266     // Mapping from owner to list of owned token IDs
1267     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1268  
1269     // Mapping from token ID to index of the owner tokens list
1270     mapping(uint256 => uint256) private _ownedTokensIndex;
1271  
1272     // Array with all token ids, used for enumeration
1273     uint256[] private _allTokens;
1274  
1275     // Mapping from token id to position in the allTokens array
1276     mapping(uint256 => uint256) private _allTokensIndex;
1277  
1278     /**
1279      * @dev See {IERC165-supportsInterface}.
1280      */
1281     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1282         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1283     }
1284  
1285     /**
1286      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1287      */
1288     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1289         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1290         return _ownedTokens[owner][index];
1291     }
1292  
1293     /**
1294      * @dev See {IERC721Enumerable-totalSupply}.
1295      */
1296     function totalSupply() public view virtual override returns (uint256) {
1297         return _allTokens.length;
1298     }
1299  
1300     /**
1301      * @dev See {IERC721Enumerable-tokenByIndex}.
1302      */
1303     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1304         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1305         return _allTokens[index];
1306     }
1307  
1308     /**
1309      * @dev Hook that is called before any token transfer. This includes minting
1310      * and burning.
1311      *
1312      * Calling conditions:
1313      *
1314      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1315      * transferred to `to`.
1316      * - When `from` is zero, `tokenId` will be minted for `to`.
1317      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1318      * - `from` cannot be the zero address.
1319      * - `to` cannot be the zero address.
1320      *
1321      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1322      */
1323     function _beforeTokenTransfer(
1324         address from,
1325         address to,
1326         uint256 tokenId
1327     ) internal virtual override {
1328         super._beforeTokenTransfer(from, to, tokenId);
1329  
1330         if (from == address(0)) {
1331             _addTokenToAllTokensEnumeration(tokenId);
1332         } else if (from != to) {
1333             _removeTokenFromOwnerEnumeration(from, tokenId);
1334         }
1335         if (to == address(0)) {
1336             _removeTokenFromAllTokensEnumeration(tokenId);
1337         } else if (to != from) {
1338             _addTokenToOwnerEnumeration(to, tokenId);
1339         }
1340     }
1341  
1342     /**
1343      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1344      * @param to address representing the new owner of the given token ID
1345      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1346      */
1347     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1348         uint256 length = ERC721.balanceOf(to);
1349         _ownedTokens[to][length] = tokenId;
1350         _ownedTokensIndex[tokenId] = length;
1351     }
1352  
1353     /**
1354      * @dev Private function to add a token to this extension's token tracking data structures.
1355      * @param tokenId uint256 ID of the token to be added to the tokens list
1356      */
1357     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1358         _allTokensIndex[tokenId] = _allTokens.length;
1359         _allTokens.push(tokenId);
1360     }
1361  
1362     /**
1363      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1364      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1365      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1366      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1367      * @param from address representing the previous owner of the given token ID
1368      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1369      */
1370     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1371         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1372         // then delete the last slot (swap and pop).
1373  
1374         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1375         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1376  
1377         // When the token to delete is the last token, the swap operation is unnecessary
1378         if (tokenIndex != lastTokenIndex) {
1379             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1380  
1381             _ownedTokens[from][tokenIndex] = lastTokenId;
1382             // Move the last token to the slot of the to-delete token
1383             _ownedTokensIndex[lastTokenId] = tokenIndex;
1384             // Update the moved token's index
1385         }
1386  
1387         // This also deletes the contents at the last position of the array
1388         delete _ownedTokensIndex[tokenId];
1389         delete _ownedTokens[from][lastTokenIndex];
1390     }
1391  
1392     /**
1393      * @dev Private function to remove a token from this extension's token tracking data structures.
1394      * This has O(1) time complexity, but alters the order of the _allTokens array.
1395      * @param tokenId uint256 ID of the token to be removed from the tokens list
1396      */
1397     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1398         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1399         // then delete the last slot (swap and pop).
1400  
1401         uint256 lastTokenIndex = _allTokens.length - 1;
1402         uint256 tokenIndex = _allTokensIndex[tokenId];
1403  
1404         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1405         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1406         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1407         uint256 lastTokenId = _allTokens[lastTokenIndex];
1408  
1409         _allTokens[tokenIndex] = lastTokenId;
1410         // Move the last token to the slot of the to-delete token
1411         _allTokensIndex[lastTokenId] = tokenIndex;
1412         // Update the moved token's index
1413  
1414         // This also deletes the contents at the last position of the array
1415         delete _allTokensIndex[tokenId];
1416         _allTokens.pop();
1417     }
1418 }
1419  
1420  
1421 
1422  
1423 // -License-Identifier: MIT
1424 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721Burnable.sol)
1425  
1426 pragma solidity ^0.8.0;
1427  
1428  
1429 /**
1430  * @title ERC721 Burnable Token
1431  * @dev ERC721 Token that can be burned (destroyed).
1432  */
1433 abstract contract ERC721Burnable is Context, ERC721 {
1434     /**
1435      * @dev Burns `tokenId`. See {ERC721-_burn}.
1436      *
1437      * Requirements:
1438      *
1439      * - The caller must own `tokenId` or be an approved operator.
1440      */
1441     function burn(uint256 tokenId) public virtual {
1442         //solhint-disable-next-line max-line-length
1443         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1444         _burn(tokenId);
1445     }
1446 }
1447  
1448  
1449 
1450  
1451 // -License-Identifier: MIT
1452 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1453  
1454 pragma solidity ^0.8.0;
1455  
1456 /**
1457  * @dev Interface for the NFT Royalty Standard.
1458  *
1459  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1460  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1461  *
1462  * _Available since v4.5._
1463  */
1464 interface IERC2981 is IERC165 {
1465     /**
1466      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1467      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1468      */
1469     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1470     external
1471     view
1472     returns (address receiver, uint256 royaltyAmount);
1473 }
1474  
1475  
1476 
1477  
1478 // -License-Identifier: MIT
1479 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
1480  
1481 pragma solidity ^0.8.0;
1482  
1483  
1484 /**
1485  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1486  *
1487  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1488  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1489  *
1490  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1491  * fee is specified in basis points by default.
1492  *
1493  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1494  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1495  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1496  *
1497  * _Available since v4.5._
1498  */
1499 abstract contract ERC2981 is IERC2981, ERC165 {
1500     struct RoyaltyInfo {
1501         address receiver;
1502         uint96 royaltyFraction;
1503     }
1504  
1505     RoyaltyInfo private _defaultRoyaltyInfo;
1506     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1507  
1508     /**
1509      * @dev See {IERC165-supportsInterface}.
1510      */
1511     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1512         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1513     }
1514  
1515     /**
1516      * @inheritdoc IERC2981
1517      */
1518     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1519         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1520  
1521         if (royalty.receiver == address(0)) {
1522             royalty = _defaultRoyaltyInfo;
1523         }
1524  
1525         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1526  
1527         return (royalty.receiver, royaltyAmount);
1528     }
1529  
1530     /**
1531      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1532      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1533      * override.
1534      */
1535     function _feeDenominator() internal pure virtual returns (uint96) {
1536         return 10000;
1537     }
1538  
1539     /**
1540      * @dev Sets the royalty information that all ids in this contract will default to.
1541      *
1542      * Requirements:
1543      *
1544      * - `receiver` cannot be the zero address.
1545      * - `feeNumerator` cannot be greater than the fee denominator.
1546      */
1547     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1548         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1549         require(receiver != address(0), "ERC2981: invalid receiver");
1550  
1551         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1552     }
1553  
1554     /**
1555      * @dev Removes default royalty information.
1556      */
1557     function _deleteDefaultRoyalty() internal virtual {
1558         delete _defaultRoyaltyInfo;
1559     }
1560  
1561     /**
1562      * @dev Sets the royalty information for a specific token id, overriding the global default.
1563      *
1564      * Requirements:
1565      *
1566      * - `receiver` cannot be the zero address.
1567      * - `feeNumerator` cannot be greater than the fee denominator.
1568      */
1569     function _setTokenRoyalty(
1570         uint256 tokenId,
1571         address receiver,
1572         uint96 feeNumerator
1573     ) internal virtual {
1574         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1575         require(receiver != address(0), "ERC2981: Invalid parameters");
1576  
1577         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1578     }
1579  
1580     /**
1581      * @dev Resets royalty information for the token id back to the global default.
1582      */
1583     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1584         delete _tokenRoyaltyInfo[tokenId];
1585     }
1586 }
1587  
1588  
1589 
1590  
1591 // -License-Identifier: MIT
1592 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
1593  
1594 pragma solidity ^0.8.0;
1595  
1596 /**
1597  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1598  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1599  *
1600  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1601  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
1602  * need to send a transaction, and thus is not required to hold Ether at all.
1603  */
1604 interface IERC20Permit {
1605     /**
1606      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
1607      * given ``owner``'s signed approval.
1608      *
1609      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
1610      * ordering also apply here.
1611      *
1612      * Emits an {Approval} event.
1613      *
1614      * Requirements:
1615      *
1616      * - `spender` cannot be the zero address.
1617      * - `deadline` must be a timestamp in the future.
1618      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
1619      * over the EIP712-formatted function arguments.
1620      * - the signature must use ``owner``'s current nonce (see {nonces}).
1621      *
1622      * For more information on the signature format, see the
1623      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
1624      * section].
1625      */
1626     function permit(
1627         address owner,
1628         address spender,
1629         uint256 value,
1630         uint256 deadline,
1631         uint8 v,
1632         bytes32 r,
1633         bytes32 s
1634     ) external;
1635  
1636     /**
1637      * @dev Returns the current nonce for `owner`. This value must be
1638      * included whenever a signature is generated for {permit}.
1639      *
1640      * Every successful call to {permit} increases ``owner``'s nonce by one. This
1641      * prevents a signature from being used multiple times.
1642      */
1643     function nonces(address owner) external view returns (uint256);
1644  
1645     /**
1646      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
1647      */
1648     // solhint-disable-next-line func-name-mixedcase
1649     function DOMAIN_SEPARATOR() external view returns (bytes32);
1650 }
1651  
1652  
1653 
1654  
1655 // -License-Identifier: MIT
1656 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
1657  
1658 pragma solidity ^0.8.0;
1659  
1660  
1661  
1662 /**
1663  * @title SafeERC20
1664  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1665  * contract returns false). Tokens that return no value (and instead revert or
1666  * throw on failure) are also supported, non-reverting calls are assumed to be
1667  * successful.
1668  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1669  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1670  */
1671 library SafeERC20 {
1672     using Address for address;
1673  
1674     function safeTransfer(
1675         IERC20 token,
1676         address to,
1677         uint256 value
1678     ) internal {
1679         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1680     }
1681  
1682     function safeTransferFrom(
1683         IERC20 token,
1684         address from,
1685         address to,
1686         uint256 value
1687     ) internal {
1688         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1689     }
1690  
1691     /**
1692      * @dev Deprecated. This function has issues similar to the ones found in
1693      * {IERC20-approve}, and its usage is discouraged.
1694      *
1695      * Whenever possible, use {safeIncreaseAllowance} and
1696      * {safeDecreaseAllowance} instead.
1697      */
1698     function safeApprove(
1699         IERC20 token,
1700         address spender,
1701         uint256 value
1702     ) internal {
1703         // safeApprove should only be called when setting an initial allowance,
1704         // or when resetting it to zero. To increase and decrease it, use
1705         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1706         require(
1707             (value == 0) || (token.allowance(address(this), spender) == 0),
1708             "SafeERC20: approve from non-zero to non-zero allowance"
1709         );
1710         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1711     }
1712  
1713     function safeIncreaseAllowance(
1714         IERC20 token,
1715         address spender,
1716         uint256 value
1717     ) internal {
1718         uint256 newAllowance = token.allowance(address(this), spender) + value;
1719         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1720     }
1721  
1722     function safeDecreaseAllowance(
1723         IERC20 token,
1724         address spender,
1725         uint256 value
1726     ) internal {
1727     unchecked {
1728         uint256 oldAllowance = token.allowance(address(this), spender);
1729         require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1730         uint256 newAllowance = oldAllowance - value;
1731         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1732     }
1733     }
1734  
1735     function safePermit(
1736         IERC20Permit token,
1737         address owner,
1738         address spender,
1739         uint256 value,
1740         uint256 deadline,
1741         uint8 v,
1742         bytes32 r,
1743         bytes32 s
1744     ) internal {
1745         uint256 nonceBefore = token.nonces(owner);
1746         token.permit(owner, spender, value, deadline, v, r, s);
1747         uint256 nonceAfter = token.nonces(owner);
1748         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
1749     }
1750  
1751     /**
1752      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1753      * on the return value: the return value is optional (but if data is returned, it must not be false).
1754      * @param token The token targeted by the call.
1755      * @param data The call data (encoded using abi.encode or one of its variants).
1756      */
1757     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1758         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1759         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1760         // the target address contains contract code and also asserts for success in the low-level call.
1761  
1762         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1763         if (returndata.length > 0) {
1764             // Return data is optional
1765             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1766         }
1767     }
1768 }
1769  
1770  
1771 
1772  
1773 // -License-Identifier: MIT
1774 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
1775  
1776 pragma solidity ^0.8.0;
1777  
1778 /**
1779  * @dev Interface for the optional metadata functions from the ERC20 standard.
1780  *
1781  * _Available since v4.1._
1782  */
1783 interface IERC20Metadata is IERC20 {
1784     /**
1785      * @dev Returns the name of the token.
1786      */
1787     function name() external view returns (string memory);
1788  
1789     /**
1790      * @dev Returns the symbol of the token.
1791      */
1792     function symbol() external view returns (string memory);
1793  
1794     /**
1795      * @dev Returns the decimals places of the token.
1796      */
1797     function decimals() external view returns (uint8);
1798 }
1799  
1800  
1801 
1802  
1803 // -License-Identifier: MIT
1804 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
1805  
1806 pragma solidity ^0.8.0;
1807  
1808  
1809  
1810 /**
1811  * @dev Implementation of the {IERC20} interface.
1812  *
1813  * This implementation is agnostic to the way tokens are created. This means
1814  * that a supply mechanism has to be added in a derived contract using {_mint}.
1815  * For a generic mechanism see {ERC20PresetMinterPauser}.
1816  *
1817  * TIP: For a detailed writeup see our guide
1818  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1819  * to implement supply mechanisms].
1820  *
1821  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1822  * instead returning `false` on failure. This behavior is nonetheless
1823  * conventional and does not conflict with the expectations of ERC20
1824  * applications.
1825  *
1826  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1827  * This allows applications to reconstruct the allowance for all accounts just
1828  * by listening to said events. Other implementations of the EIP may not emit
1829  * these events, as it isn't required by the specification.
1830  *
1831  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1832  * functions have been added to mitigate the well-known issues around setting
1833  * allowances. See {IERC20-approve}.
1834  */
1835 contract ERC20 is Context, IERC20, IERC20Metadata {
1836     mapping(address => uint256) private _balances;
1837  
1838     mapping(address => mapping(address => uint256)) private _allowances;
1839  
1840     uint256 private _totalSupply;
1841  
1842     string private _name;
1843     string private _symbol;
1844  
1845     /**
1846      * @dev Sets the values for {name} and {symbol}.
1847      *
1848      * The default value of {decimals} is 18. To select a different value for
1849      * {decimals} you should overload it.
1850      *
1851      * All two of these values are immutable: they can only be set once during
1852      * construction.
1853      */
1854     constructor(string memory name_, string memory symbol_) {
1855         _name = name_;
1856         _symbol = symbol_;
1857     }
1858  
1859     /**
1860      * @dev Returns the name of the token.
1861      */
1862     function name() public view virtual override returns (string memory) {
1863         return _name;
1864     }
1865  
1866     /**
1867      * @dev Returns the symbol of the token, usually a shorter version of the
1868      * name.
1869      */
1870     function symbol() public view virtual override returns (string memory) {
1871         return _symbol;
1872     }
1873  
1874     /**
1875      * @dev Returns the number of decimals used to get its user representation.
1876      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1877      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1878      *
1879      * Tokens usually opt for a value of 18, imitating the relationship between
1880      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1881      * overridden;
1882      *
1883      * NOTE: This information is only used for _display_ purposes: it in
1884      * no way affects any of the arithmetic of the contract, including
1885      * {IERC20-balanceOf} and {IERC20-transfer}.
1886      */
1887     function decimals() public view virtual override returns (uint8) {
1888         return 18;
1889     }
1890  
1891     /**
1892      * @dev See {IERC20-totalSupply}.
1893      */
1894     function totalSupply() public view virtual override returns (uint256) {
1895         return _totalSupply;
1896     }
1897  
1898     /**
1899      * @dev See {IERC20-balanceOf}.
1900      */
1901     function balanceOf(address account) public view virtual override returns (uint256) {
1902         return _balances[account];
1903     }
1904  
1905     /**
1906      * @dev See {IERC20-transfer}.
1907      *
1908      * Requirements:
1909      *
1910      * - `to` cannot be the zero address.
1911      * - the caller must have a balance of at least `amount`.
1912      */
1913     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1914         address owner = _msgSender();
1915         _transfer(owner, to, amount);
1916         return true;
1917     }
1918  
1919     /**
1920      * @dev See {IERC20-allowance}.
1921      */
1922     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1923         return _allowances[owner][spender];
1924     }
1925  
1926     /**
1927      * @dev See {IERC20-approve}.
1928      *
1929      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1930      * `transferFrom`. This is semantically equivalent to an infinite approval.
1931      *
1932      * Requirements:
1933      *
1934      * - `spender` cannot be the zero address.
1935      */
1936     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1937         address owner = _msgSender();
1938         _approve(owner, spender, amount);
1939         return true;
1940     }
1941  
1942     /**
1943      * @dev See {IERC20-transferFrom}.
1944      *
1945      * Emits an {Approval} event indicating the updated allowance. This is not
1946      * required by the EIP. See the note at the beginning of {ERC20}.
1947      *
1948      * NOTE: Does not update the allowance if the current allowance
1949      * is the maximum `uint256`.
1950      *
1951      * Requirements:
1952      *
1953      * - `from` and `to` cannot be the zero address.
1954      * - `from` must have a balance of at least `amount`.
1955      * - the caller must have allowance for ``from``'s tokens of at least
1956      * `amount`.
1957      */
1958     function transferFrom(
1959         address from,
1960         address to,
1961         uint256 amount
1962     ) public virtual override returns (bool) {
1963         address spender = _msgSender();
1964         _spendAllowance(from, spender, amount);
1965         _transfer(from, to, amount);
1966         return true;
1967     }
1968  
1969     /**
1970      * @dev Atomically increases the allowance granted to `spender` by the caller.
1971      *
1972      * This is an alternative to {approve} that can be used as a mitigation for
1973      * problems described in {IERC20-approve}.
1974      *
1975      * Emits an {Approval} event indicating the updated allowance.
1976      *
1977      * Requirements:
1978      *
1979      * - `spender` cannot be the zero address.
1980      */
1981     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1982         address owner = _msgSender();
1983         _approve(owner, spender, allowance(owner, spender) + addedValue);
1984         return true;
1985     }
1986  
1987     /**
1988      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1989      *
1990      * This is an alternative to {approve} that can be used as a mitigation for
1991      * problems described in {IERC20-approve}.
1992      *
1993      * Emits an {Approval} event indicating the updated allowance.
1994      *
1995      * Requirements:
1996      *
1997      * - `spender` cannot be the zero address.
1998      * - `spender` must have allowance for the caller of at least
1999      * `subtractedValue`.
2000      */
2001     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
2002         address owner = _msgSender();
2003         uint256 currentAllowance = allowance(owner, spender);
2004         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
2005     unchecked {
2006         _approve(owner, spender, currentAllowance - subtractedValue);
2007     }
2008  
2009         return true;
2010     }
2011  
2012     /**
2013      * @dev Moves `amount` of tokens from `from` to `to`.
2014      *
2015      * This internal function is equivalent to {transfer}, and can be used to
2016      * e.g. implement automatic token fees, slashing mechanisms, etc.
2017      *
2018      * Emits a {Transfer} event.
2019      *
2020      * Requirements:
2021      *
2022      * - `from` cannot be the zero address.
2023      * - `to` cannot be the zero address.
2024      * - `from` must have a balance of at least `amount`.
2025      */
2026     function _transfer(
2027         address from,
2028         address to,
2029         uint256 amount
2030     ) internal virtual {
2031         require(from != address(0), "ERC20: transfer from the zero address");
2032         require(to != address(0), "ERC20: transfer to the zero address");
2033  
2034         _beforeTokenTransfer(from, to, amount);
2035  
2036         uint256 fromBalance = _balances[from];
2037         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
2038     unchecked {
2039         _balances[from] = fromBalance - amount;
2040     }
2041         _balances[to] += amount;
2042  
2043         emit Transfer(from, to, amount);
2044  
2045         _afterTokenTransfer(from, to, amount);
2046     }
2047  
2048     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
2049      * the total supply.
2050      *
2051      * Emits a {Transfer} event with `from` set to the zero address.
2052      *
2053      * Requirements:
2054      *
2055      * - `account` cannot be the zero address.
2056      */
2057     function _mint(address account, uint256 amount) internal virtual {
2058         require(account != address(0), "ERC20: mint to the zero address");
2059  
2060         _beforeTokenTransfer(address(0), account, amount);
2061  
2062         _totalSupply += amount;
2063         _balances[account] += amount;
2064         emit Transfer(address(0), account, amount);
2065  
2066         _afterTokenTransfer(address(0), account, amount);
2067     }
2068  
2069     /**
2070      * @dev Destroys `amount` tokens from `account`, reducing the
2071      * total supply.
2072      *
2073      * Emits a {Transfer} event with `to` set to the zero address.
2074      *
2075      * Requirements:
2076      *
2077      * - `account` cannot be the zero address.
2078      * - `account` must have at least `amount` tokens.
2079      */
2080     function _burn(address account, uint256 amount) internal virtual {
2081         require(account != address(0), "ERC20: burn from the zero address");
2082  
2083         _beforeTokenTransfer(account, address(0), amount);
2084  
2085         uint256 accountBalance = _balances[account];
2086         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
2087     unchecked {
2088         _balances[account] = accountBalance - amount;
2089     }
2090         _totalSupply -= amount;
2091  
2092         emit Transfer(account, address(0), amount);
2093  
2094         _afterTokenTransfer(account, address(0), amount);
2095     }
2096  
2097     /**
2098      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
2099      *
2100      * This internal function is equivalent to `approve`, and can be used to
2101      * e.g. set automatic allowances for certain subsystems, etc.
2102      *
2103      * Emits an {Approval} event.
2104      *
2105      * Requirements:
2106      *
2107      * - `owner` cannot be the zero address.
2108      * - `spender` cannot be the zero address.
2109      */
2110     function _approve(
2111         address owner,
2112         address spender,
2113         uint256 amount
2114     ) internal virtual {
2115         require(owner != address(0), "ERC20: approve from the zero address");
2116         require(spender != address(0), "ERC20: approve to the zero address");
2117  
2118         _allowances[owner][spender] = amount;
2119         emit Approval(owner, spender, amount);
2120     }
2121  
2122     /**
2123      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
2124      *
2125      * Does not update the allowance amount in case of infinite allowance.
2126      * Revert if not enough allowance is available.
2127      *
2128      * Might emit an {Approval} event.
2129      */
2130     function _spendAllowance(
2131         address owner,
2132         address spender,
2133         uint256 amount
2134     ) internal virtual {
2135         uint256 currentAllowance = allowance(owner, spender);
2136         if (currentAllowance != type(uint256).max) {
2137             require(currentAllowance >= amount, "ERC20: insufficient allowance");
2138         unchecked {
2139             _approve(owner, spender, currentAllowance - amount);
2140         }
2141         }
2142     }
2143  
2144     /**
2145      * @dev Hook that is called before any transfer of tokens. This includes
2146      * minting and burning.
2147      *
2148      * Calling conditions:
2149      *
2150      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2151      * will be transferred to `to`.
2152      * - when `from` is zero, `amount` tokens will be minted for `to`.
2153      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
2154      * - `from` and `to` are never both zero.
2155      *
2156      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2157      */
2158     function _beforeTokenTransfer(
2159         address from,
2160         address to,
2161         uint256 amount
2162     ) internal virtual {}
2163  
2164     /**
2165      * @dev Hook that is called after any transfer of tokens. This includes
2166      * minting and burning.
2167      *
2168      * Calling conditions:
2169      *
2170      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2171      * has been transferred to `to`.
2172      * - when `from` is zero, `amount` tokens have been minted for `to`.
2173      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
2174      * - `from` and `to` are never both zero.
2175      *
2176      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2177      */
2178     function _afterTokenTransfer(
2179         address from,
2180         address to,
2181         uint256 amount
2182     ) internal virtual {}
2183 }
2184  
2185  
2186 
2187  
2188 // -License-Identifier: MIT
2189 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
2190  
2191 pragma solidity ^0.8.0;
2192  
2193  
2194 /**
2195  * @dev Extension of {ERC20} that allows token holders to destroy both their own
2196  * tokens and those that they have an allowance for, in a way that can be
2197  * recognized off-chain (via event analysis).
2198  */
2199 abstract contract ERC20Burnable is Context, ERC20 {
2200     /**
2201      * @dev Destroys `amount` tokens from the caller.
2202      *
2203      * See {ERC20-_burn}.
2204      */
2205     function burn(uint256 amount) public virtual {
2206         _burn(_msgSender(), amount);
2207     }
2208  
2209     /**
2210      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
2211      * allowance.
2212      *
2213      * See {ERC20-_burn} and {ERC20-allowance}.
2214      *
2215      * Requirements:
2216      *
2217      * - the caller must have allowance for ``accounts``'s tokens of at least
2218      * `amount`.
2219      */
2220     function burnFrom(address account, uint256 amount) public virtual {
2221         _spendAllowance(account, _msgSender(), amount);
2222         _burn(account, amount);
2223     }
2224 }
2225  
2226  
2227 
2228  
2229 // -License-Identifier: MIT
2230 pragma solidity ^0.8.0;
2231  
2232 interface IOperatorFilterRegistry {
2233     /**
2234      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
2235      *         true if supplied registrant address is not registered.
2236      */
2237     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
2238  
2239     /**
2240      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
2241      */
2242     function register(address registrant) external;
2243  
2244     /**
2245      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
2246      */
2247     function registerAndSubscribe(address registrant, address subscription) external;
2248  
2249     /**
2250      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
2251      *         address without subscribing.
2252      */
2253     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
2254  
2255     /**
2256      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
2257      *         Note that this does not remove any filtered addresses or codeHashes.
2258      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
2259      */
2260     function unregister(address addr) external;
2261  
2262     /**
2263      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
2264      */
2265     function updateOperator(address registrant, address operator, bool filtered) external;
2266  
2267     /**
2268      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
2269      */
2270     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
2271  
2272     /**
2273      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
2274      */
2275     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
2276  
2277     /**
2278      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
2279      */
2280     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
2281  
2282     /**
2283      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
2284      *         subscription if present.
2285      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
2286      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
2287      *         used.
2288      */
2289     function subscribe(address registrant, address registrantToSubscribe) external;
2290  
2291     /**
2292      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
2293      */
2294     function unsubscribe(address registrant, bool copyExistingEntries) external;
2295  
2296     /**
2297      * @notice Get the subscription address of a given registrant, if any.
2298      */
2299     function subscriptionOf(address addr) external returns (address registrant);
2300  
2301     /**
2302      * @notice Get the set of addresses subscribed to a given registrant.
2303      *         Note that order is not guaranteed as updates are made.
2304      */
2305     function subscribers(address registrant) external returns (address[] memory);
2306  
2307     /**
2308      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
2309      *         Note that order is not guaranteed as updates are made.
2310      */
2311     function subscriberAt(address registrant, uint256 index) external returns (address);
2312  
2313     /**
2314      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
2315      */
2316     function copyEntriesOf(address registrant, address registrantToCopy) external;
2317  
2318     /**
2319      * @notice Returns true if operator is filtered by a given address or its subscription.
2320      */
2321     function isOperatorFiltered(address registrant, address operator) external returns (bool);
2322  
2323     /**
2324      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
2325      */
2326     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
2327  
2328     /**
2329      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
2330      */
2331     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
2332  
2333     /**
2334      * @notice Returns a list of filtered operators for a given address or its subscription.
2335      */
2336     function filteredOperators(address addr) external returns (address[] memory);
2337  
2338     /**
2339      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
2340      *         Note that order is not guaranteed as updates are made.
2341      */
2342     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
2343  
2344     /**
2345      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
2346      *         its subscription.
2347      *         Note that order is not guaranteed as updates are made.
2348      */
2349     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
2350  
2351     /**
2352      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
2353      *         its subscription.
2354      *         Note that order is not guaranteed as updates are made.
2355      */
2356     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
2357  
2358     /**
2359      * @notice Returns true if an address has registered
2360      */
2361     function isRegistered(address addr) external returns (bool);
2362  
2363     /**
2364      * @dev Convenience method to compute the code hash of an arbitrary contract
2365      */
2366     function codeHashOf(address addr) external returns (bytes32);
2367 }
2368  
2369  
2370 
2371  
2372 // -License-Identifier: MIT
2373 pragma solidity ^0.8.7;
2374  
2375 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
2376 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
2377  
2378  
2379 
2380  
2381 // -License-Identifier: MIT
2382 pragma solidity ^0.8.7;
2383  
2384  
2385 /**
2386  * @title  OperatorFilterer
2387  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
2388  *         registrant's entries in the OperatorFilterRegistry.
2389  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
2390  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
2391  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
2392  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
2393  *         administration methods on the contract itself to interact with the registry otherwise the subscription
2394  *         will be locked to the options set during construction.
2395  */
2396  
2397 abstract contract OperatorFilterer {
2398     /// @dev Emitted when an operator is not allowed.
2399     error OperatorNotAllowed(address operator);
2400  
2401     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
2402     IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
2403  
2404     /// @dev The constructor that is called when the contract is being deployed.
2405     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
2406         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
2407         // will not revert, but the contract will need to be registered with the registry once it is deployed in
2408         // order for the modifier to filter addresses.
2409         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2410             if (subscribe) {
2411                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
2412             } else {
2413                 if (subscriptionOrRegistrantToCopy != address(0)) {
2414                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
2415                 } else {
2416                     OPERATOR_FILTER_REGISTRY.register(address(this));
2417                 }
2418             }
2419         }
2420     }
2421  
2422     /**
2423      * @dev A helper function to check if an operator is allowed.
2424      */
2425     modifier onlyAllowedOperator(address from) virtual {
2426         // Allow spending tokens from addresses with balance
2427         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
2428         // from an EOA.
2429         if (from != msg.sender) {
2430             _checkFilterOperator(msg.sender);
2431         }
2432         _;
2433     }
2434  
2435     /**
2436      * @dev A helper function to check if an operator approval is allowed.
2437      */
2438     modifier onlyAllowedOperatorApproval(address operator) virtual {
2439         _checkFilterOperator(operator);
2440         _;
2441     }
2442  
2443     /**
2444      * @dev A helper function to check if an operator is allowed.
2445      */
2446     function _checkFilterOperator(address operator) internal view virtual {
2447         // Check registry code length to facilitate testing in environments without a deployed registry.
2448         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2449             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
2450             // may specify their own OperatorFilterRegistry implementations, which may behave differently
2451             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
2452                 revert OperatorNotAllowed(operator);
2453             }
2454         }
2455     }
2456 }
2457  
2458  
2459 
2460  
2461 // -License-Identifier: MIT
2462 pragma solidity ^0.8.7;
2463  
2464  
2465 /**
2466  * @title  DefaultOperatorFilterer
2467  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
2468  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
2469  *         administration methods on the contract itself to interact with the registry otherwise the subscription
2470  *         will be locked to the options set during construction.
2471  */
2472  
2473 abstract contract DefaultOperatorFilterer is OperatorFilterer {
2474     /// @dev The constructor that is called when the contract is being deployed.
2475     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
2476 }
2477  
2478  
2479 
2480  
2481 pragma solidity ^0.8.0;
2482  
2483  
2484 contract tehBagNFT is ERC721Enumerable, Ownable, ERC2981, DefaultOperatorFilterer {
2485     using SafeERC20 for IERC20;
2486  
2487     mapping(address => uint256) public prepaidWL;
2488     mapping(address => uint256) public guaranteedWL;
2489     mapping(address => uint256) public fcfsWL;
2490     mapping(address => uint256) public buyers;
2491  
2492     enum PresaleStage {PAUSED, ONLY_GUARANTEED_WL, ONLY_WL_FCFS, PUBLIC, ENDED}
2493     PresaleStage public presaleStage = PresaleStage.PAUSED;
2494     // Sale Configuration
2495     uint256 public mintPrice;
2496     uint256 public mintPriceInBag;
2497     uint256 public maxMintPerAddress = 6;
2498  
2499     uint256 public currentTokenId = 1;
2500     uint256 public prepaidNFTs = 0;
2501     string internal theBaseURI = "";
2502     uint256 public MAX_SUPPLY = 2000;
2503     uint256 public amountGuaranteedBuyWithToken = 0;
2504     uint256 public amountGuaranteedBuyWithETH = 0;
2505  
2506     address public token;
2507     address public royaltyReceiver;
2508     uint256 public royaltyPercentage;
2509     RoyaltyInfo public _defaultRoyaltyInfo;
2510  
2511     bool public os_filter_enabled = true;
2512     bool public disableContracts = true;
2513  
2514     modifier isEligibleToClaim(address sender, uint256 quantity){
2515         require(prepaidWL[sender] > 0, "The user is not eligible to claim");
2516         require(presaleStage != PresaleStage.PAUSED, "Presale is paused");
2517         require(prepaidNFTs >= quantity, "quantity exceed cap of prepaid NFTs");
2518         require(prepaidWL[sender] >= quantity, "The quantity requested is greater than the amount eligible for the sender.");
2519  
2520         prepaidWL[sender] -= quantity;
2521         prepaidNFTs -= quantity;
2522         _;
2523     }
2524  
2525     function checkContracts() internal {
2526         if (disableContracts) {
2527             require(tx.origin == msg.sender, "NFT: Contracts not allowed");
2528         }
2529     }
2530  
2531     modifier isEligibleToMint(address sender, uint256 quantity) {
2532         require(presaleStage != PresaleStage.PAUSED, "Presale is paused");
2533         require(presaleStage != PresaleStage.ENDED, "Presale has ended");
2534         require(buyers[sender] + quantity <= maxMintPerAddress, "Maximum purchase limit per address has been reached.");
2535         require(availableNFTS() >= quantity, "can't mint because total supply exceed cap");
2536  
2537         if (presaleStage == PresaleStage.ONLY_GUARANTEED_WL) {
2538             require(guaranteedWL[sender] > 0, "The user doesn't have guaranteed wl spot");
2539             require(guaranteedWL[sender] >= quantity, "The quantity requested is greater than the amount eligible for the sender.");
2540             guaranteedWL[sender] -= quantity;
2541         }
2542  
2543         else if (presaleStage == PresaleStage.ONLY_WL_FCFS) {
2544             require(fcfsWL[sender] > 0, "The user is not part of the fcfs WL");
2545             require(fcfsWL[sender] >= quantity, "The quantity requested is greater than the amount eligible for the sender.");
2546             fcfsWL[sender] -= quantity;
2547         } else if (presaleStage == PresaleStage.PUBLIC) {
2548             checkContracts();
2549         }
2550  
2551         buyers[sender] += quantity;
2552         _;
2553     }
2554  
2555     modifier isEligibleToMintAndPayWithToken(uint256 quantity) {
2556         require(presaleStage == PresaleStage.PUBLIC, "Mint with bag is not opened yet");
2557         require(amountGuaranteedBuyWithToken >= quantity, "quantity exceed cap of amount guaranteed for buying with token");
2558         amountGuaranteedBuyWithToken -= quantity;
2559         _;
2560     }
2561  
2562     modifier isEligibleToMintAndPayWithETH(uint256 quantity) {
2563         require(availableNFTsETH() >= quantity, "quantity exceed cap of amount guaranteed for buying with eth");
2564         amountGuaranteedBuyWithETH -= quantity;
2565         _;
2566     }
2567  
2568  
2569     modifier paidEnough(uint256 value, uint256 quantity) {
2570         require(quantity * mintPrice <= value, "not enough funds to buy NFTs.");
2571         _;
2572     }
2573  
2574     modifier paidEnoughBag(address sender, uint256 quantity) {
2575         uint256 value = ERC20Burnable(token).allowance(msg.sender, address(this));
2576         require(quantity * mintPriceInBag <= value, "not enough $bag to buy NFT");
2577         _;
2578     }
2579  
2580     // Events
2581     event EthTransfer(address to, uint256 amount);
2582     event TokenTransfer(address to, address token, uint256 amount);
2583  
2584     constructor(
2585         string memory name_,
2586         string memory symbol_,
2587         uint256 _maxSupply,
2588         uint256 _amountGuaranteedToBuyWithBag,
2589         uint256 _amountGuaranteedToBuyWithETH,
2590         uint256 _mintPrice,
2591         uint256 _mintPriceInBag,
2592         address _token,
2593         address _royaltyReceiver,
2594         uint96 _royaltyPercentage) ERC721(name_, symbol_) {
2595         MAX_SUPPLY = _maxSupply;
2596         amountGuaranteedBuyWithToken = _amountGuaranteedToBuyWithBag;
2597         amountGuaranteedBuyWithETH = _amountGuaranteedToBuyWithETH;
2598         require(amountGuaranteedBuyWithToken + amountGuaranteedBuyWithETH == MAX_SUPPLY, "Amount of tokens to buy with eth and to buy with bag should be equal to max supply");
2599         mintPriceInBag = _mintPriceInBag;
2600         mintPrice = _mintPrice;
2601         token = _token;
2602         royaltyReceiver = _royaltyReceiver;
2603         royaltyPercentage = _royaltyPercentage;
2604         _defaultRoyaltyInfo = RoyaltyInfo(_royaltyReceiver, _royaltyPercentage);
2605     }
2606  
2607     function _baseURI() internal view virtual override returns (string memory) {
2608         return theBaseURI;
2609     }
2610  
2611     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2612         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2613  
2614         string memory baseURI = _baseURI();
2615         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, Strings.toString(tokenId), ".json")) : "";
2616     }
2617  
2618     function setBaseURI(string memory _newBaseURI) external onlyOwner {
2619         // Update base uri
2620         theBaseURI = _newBaseURI;
2621     }
2622  
2623     function mint(uint256 quantity) external payable isEligibleToMintAndPayWithETH(quantity) isEligibleToMint(msg.sender, quantity) paidEnough(msg.value, quantity) {
2624         _bulkMint(msg.sender, quantity);
2625     }
2626  
2627     function mintUsingBag(uint256 quantity) external isEligibleToMintAndPayWithToken(quantity) isEligibleToMint(msg.sender, quantity) paidEnoughBag(msg.sender, quantity) {
2628         uint256 amountExpected = mintPriceInBag * quantity;
2629         ERC20Burnable(token).transferFrom(msg.sender, address(this), amountExpected);
2630         ERC20Burnable(token).burn(amountExpected);
2631         _bulkMint(msg.sender, quantity);
2632     }
2633  
2634     function _bulkMint(address to, uint256 quantity) internal {
2635         uint256 tokenId = currentTokenId;
2636         for (uint256 i = 0; i < quantity; i++) {
2637             _mint(to, tokenId);
2638             tokenId += 1;
2639         }
2640  
2641         currentTokenId = tokenId;
2642     }
2643  
2644     function claim(uint256 quantity) external isEligibleToClaim(msg.sender, quantity) {
2645         _bulkMint(msg.sender, quantity);
2646     }
2647  
2648     function mintOnlyOwner(address to, uint256 quantity, bool isBag) external onlyOwner {
2649         require(availableNFTS() >= quantity, "can't mint because total supply exceed cap");
2650  
2651         if (isBag) {
2652             require(amountGuaranteedBuyWithToken >= quantity, "quantity exceed cap of amount guaranteed for buying with token");
2653             amountGuaranteedBuyWithToken -= quantity;
2654         }
2655         else {
2656             require(amountGuaranteedBuyWithETH >= quantity, "quantity exceed cap of amount guaranteed for buying with eth");
2657             amountGuaranteedBuyWithETH -= quantity;
2658         }
2659  
2660         _bulkMint(to, quantity);
2661     }
2662  
2663     function setPrepaidWL(address [] memory addresses, uint256 [] memory amount) external onlyOwner {
2664         require(addresses.length == amount.length, "not same length");
2665  
2666         for (uint256 i = 0; i < addresses.length; i++) {
2667             _updateUserAllocation(addresses[i], amount[i]);
2668         }
2669  
2670     }
2671  
2672     // This function update the amount of NFTs guaranteed for the user, and the total amount of guaranteed NFTs
2673     function _updateUserAllocation(address user, uint256 quantity) internal {
2674         // The user is already in the allocation list. update the amount of NFTs allocated for the user and the total nfts guranteed.
2675         if (prepaidWL[user] != 0) {
2676             uint256 amountAllocatedBefore = prepaidWL[user];
2677             prepaidNFTs = prepaidNFTs - amountAllocatedBefore + quantity;
2678         }
2679         else {
2680             prepaidNFTs += quantity;
2681         }
2682  
2683         prepaidWL[user] = quantity;
2684  
2685         require(prepaidNFTs <= amountGuaranteedBuyWithETH, "The amount of prepaidNFTs should be less than the amount guaranteed to buy with eth");
2686     }
2687  
2688     function setGuaranteedWL(address [] memory addresses, uint256 [] memory amount) external onlyOwner {
2689         require(addresses.length == amount.length, "not same length");
2690  
2691         for (uint256 i = 0; i < addresses.length; i++) {
2692             guaranteedWL[addresses[i]] = amount[i];
2693         }
2694     }
2695  
2696     function setFcfsWL(address [] memory addresses, uint256 [] memory amount) external onlyOwner {
2697         require(addresses.length == amount.length, "not same length");
2698         for (uint256 i = 0; i < addresses.length; i++) {
2699             fcfsWL[addresses[i]] = amount[i];
2700         }
2701     }
2702  
2703     function setMintPrice(uint256 _mintPrice) external onlyOwner {
2704         mintPrice = _mintPrice;
2705     }
2706  
2707     function setMaxMintPerAddress(uint256 amount) external onlyOwner {
2708         maxMintPerAddress = amount;
2709     }
2710  
2711     function setStage(PresaleStage _stage) external onlyOwner {
2712         presaleStage = _stage;
2713     }
2714  
2715     function setprepaidNFTs(uint256 amount) external onlyOwner {
2716         require(MAX_SUPPLY - totalSupply() >= amount, "prepaid nfts cannot be greater than total available nfts");
2717         prepaidNFTs = amount;
2718     }
2719  
2720     function setPrepaidUserAllocation(address user, uint256 amount) external onlyOwner {
2721         _updateUserAllocation(user, amount);
2722     }
2723  
2724     function setGuaranteedWLUserAllocation(address user, uint256 amount) external onlyOwner {
2725         guaranteedWL[user] = amount;
2726     }
2727  
2728     function setFcfsUserAllocation(address user, uint256 amount) external onlyOwner {
2729         fcfsWL[user] = amount;
2730     }
2731  
2732     function setMintPriceUsingBag(uint256 amount) external onlyOwner {
2733         mintPriceInBag = amount;
2734     }
2735  
2736     function setToken(address token) external onlyOwner {
2737         token = token;
2738     }
2739  
2740     function addNFTsToBuyWithBag(uint256 _amount) external onlyOwner {
2741         require(availableNFTsETH() >= _amount, "Not enough NFTs to remove from eth allocation");
2742         amountGuaranteedBuyWithToken += _amount;
2743         amountGuaranteedBuyWithETH -= _amount;
2744     }
2745  
2746  
2747     function addNFTsToBuyWithETH(uint256 _amount) external onlyOwner {
2748         require(amountGuaranteedBuyWithToken >= _amount, "Not enough NFTs to remove from bag allocation");
2749         amountGuaranteedBuyWithETH += _amount;
2750         amountGuaranteedBuyWithToken -= _amount;
2751     }
2752  
2753     function setDefaultRoyaltyInfo(address receiver, uint96 amount) external onlyOwner {
2754         _defaultRoyaltyInfo = RoyaltyInfo(receiver, amount);
2755     }
2756  
2757     function setDisableContracts(bool status) external onlyOwner {
2758         disableContracts = status;
2759     }
2760  
2761     function withdrawETH() external onlyOwner {
2762         uint256 contractETHBalance = address(this).balance;
2763         payable(msg.sender).transfer(contractETHBalance);
2764  
2765         emit EthTransfer(msg.sender, contractETHBalance);
2766     }
2767  
2768     function withdrawTokens(address token) external onlyOwner {
2769         uint256 balance = IERC20(token).balanceOf(address(this));
2770         IERC20(token).safeTransfer(msg.sender, balance);
2771         emit TokenTransfer(msg.sender, token, balance);
2772     }
2773  
2774     /**
2775  * @inheritdoc ERC721
2776    */
2777     function supportsInterface(bytes4 interfaceId) public view override(ERC721Enumerable, ERC2981) returns (bool) {
2778         return (
2779         interfaceId == type(IERC2981).interfaceId ||
2780         super.supportsInterface(interfaceId)
2781         );
2782     }
2783  
2784     // amount of NFTs available to buy with ETH and BAG.
2785     function availableNFTS() public view returns (uint256){
2786         return MAX_SUPPLY - totalSupply() - prepaidNFTs;
2787     }
2788  
2789     // amount of NFTs available to buy with $bag
2790     function availableNFTsBag() public view returns (uint256){
2791         return amountGuaranteedBuyWithToken;
2792     }
2793  
2794     // amount of NFTs available to buy with ETH
2795     function availableNFTsETH() public view returns (uint256){
2796         return amountGuaranteedBuyWithETH - prepaidNFTs;
2797     }
2798  
2799     function getUserAllocation(address user, bool isClaim) public view returns (uint256){
2800         uint256 nftAllocated = 0;
2801  
2802         if (isClaim) {
2803             nftAllocated = prepaidWL[user];
2804         }
2805         else {
2806             if (presaleStage == PresaleStage.ONLY_GUARANTEED_WL) {
2807                 nftAllocated = guaranteedWL[user];
2808             }
2809  
2810             else if (presaleStage == PresaleStage.ONLY_WL_FCFS) {
2811                 nftAllocated = fcfsWL[user];
2812             }
2813             else if (presaleStage == PresaleStage.PUBLIC) {
2814                 if (buyers[user] >= maxMintPerAddress) {
2815                     nftAllocated = 0;
2816                 } else {
2817                     nftAllocated = maxMintPerAddress - buyers[user];
2818                 }
2819             }
2820         }
2821  
2822         return nftAllocated;
2823     }
2824  
2825     function getUserAllocationLeft(address user, bool isToken) public view returns (uint256){
2826         uint256 nftAllocated = getUserAllocation(user, false);
2827         if (isToken) {
2828             if (availableNFTsBag() < nftAllocated) {
2829                 return availableNFTsBag();
2830             }
2831  
2832             return nftAllocated;
2833         } else {
2834             if (availableNFTsETH() < nftAllocated) {
2835                 return availableNFTsETH();
2836             }
2837  
2838             return nftAllocated;
2839         }
2840     }
2841  
2842     function getUserTotalAllocationInAllRounds(address user) public view returns (uint256, uint256, uint256) {
2843         return (prepaidWL[user], guaranteedWL[user], fcfsWL[user]);
2844     }
2845  
2846     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view override returns (address, uint256) {
2847         RoyaltyInfo memory royalty = _defaultRoyaltyInfo;
2848         return (royalty.receiver, royalty.royaltyFraction);
2849     }
2850  
2851     function burn(uint256 tokenId) public virtual {
2852         //solhint-disable-next-line max-line-length
2853         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
2854         require(presaleStage == PresaleStage.ENDED, "NFT: Can't burn before presale ends");
2855         _burn(tokenId);
2856     }
2857  
2858     // OS Filter
2859     function setFilterStatus(bool status) external onlyOwner {
2860         os_filter_enabled = status;
2861     }
2862  
2863     function _checkFilterOperator(address operator) internal view virtual override {
2864         if (os_filter_enabled) {
2865             return super._checkFilterOperator(operator);
2866         }
2867     }
2868  
2869     /**
2870      * @dev See {IERC721-setApprovalForAll}.
2871      *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
2872      */
2873     function setApprovalForAll(address operator, bool approved) public override(ERC721, IERC721) onlyAllowedOperatorApproval(operator) {
2874         super.setApprovalForAll(operator, approved);
2875     }
2876  
2877     /**
2878      * @dev See {IERC721-approve}.
2879      *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
2880      */
2881     function approve(address operator, uint256 tokenId) public override(ERC721, IERC721) onlyAllowedOperatorApproval(operator) {
2882         super.approve(operator, tokenId);
2883     }
2884  
2885     /**
2886      * @dev See {IERC721-transferFrom}.
2887      *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
2888      */
2889     function transferFrom(address from, address to, uint256 tokenId) public override(ERC721, IERC721) onlyAllowedOperator(from) {
2890         super.transferFrom(from, to, tokenId);
2891     }
2892  
2893     /**
2894      * @dev See {IERC721-safeTransferFrom}.
2895      *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
2896      */
2897     function safeTransferFrom(address from, address to, uint256 tokenId) public override(ERC721, IERC721) onlyAllowedOperator(from) {
2898         super.safeTransferFrom(from, to, tokenId);
2899     }
2900  
2901     /**
2902      * @dev See {IERC721-safeTransferFrom}.
2903      *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
2904      */
2905     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2906     public
2907     override(ERC721, IERC721)
2908     onlyAllowedOperator(from)
2909     {
2910         super.safeTransferFrom(from, to, tokenId, data);
2911     }
2912 }