1 // SPDX-License-Identifier: MIT
2 
3 /*
4 __/\\\______________/\\\\\\\\\\\\\_______/\\\\\\\\\___________/\\\\\\\\\_        
5  _\/\\\_____________\/\\\/////////\\\___/\\\\\\\\\\\\\______/\\\////////__       
6   _\/\\\_____________\/\\\_______\/\\\__/\\\/////////\\\___/\\\/___________      
7    _\/\\\_____________\/\\\\\\\\\\\\\\__\/\\\_______\/\\\__/\\\_____________     
8     _\/\\\_____________\/\\\/////////\\\_\/\\\\\\\\\\\\\\\_\/\\\_____________    
9      _\/\\\_____________\/\\\_______\/\\\_\/\\\/////////\\\_\//\\\____________   
10       _\/\\\_____________\/\\\_______\/\\\_\/\\\_______\/\\\__\///\\\__________  
11        _\/\\\\\\\\\\\\\\\_\/\\\\\\\\\\\\\/__\/\\\_______\/\\\____\////\\\\\\\\\_ 
12         _\///////////////__\/////////////____\///________\///________\/////////__
13 */                             
14 
15 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
16 pragma solidity ^0.8.0;
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
38 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
39 pragma solidity ^0.8.0;
40 /**
41  * @dev Required interface of an ERC721 compliant contract.
42  */
43 interface IERC721 is IERC165 {
44     /**
45      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
46      */
47     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
48 
49     /**
50      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
51      */
52     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
53 
54     /**
55      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
56      */
57     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
58 
59     /**
60      * @dev Returns the number of tokens in ``owner``'s account.
61      */
62     function balanceOf(address owner) external view returns (uint256 balance);
63 
64     /**
65      * @dev Returns the owner of the `tokenId` token.
66      *
67      * Requirements:
68      *
69      * - `tokenId` must exist.
70      */
71     function ownerOf(uint256 tokenId) external view returns (address owner);
72 
73     /**
74      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
75      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
76      *
77      * Requirements:
78      *
79      * - `from` cannot be the zero address.
80      * - `to` cannot be the zero address.
81      * - `tokenId` token must exist and be owned by `from`.
82      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
83      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
84      *
85      * Emits a {Transfer} event.
86      */
87     function safeTransferFrom(
88         address from,
89         address to,
90         uint256 tokenId
91     ) external;
92 
93     /**
94      * @dev Transfers `tokenId` token from `from` to `to`.
95      *
96      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
97      *
98      * Requirements:
99      *
100      * - `from` cannot be the zero address.
101      * - `to` cannot be the zero address.
102      * - `tokenId` token must be owned by `from`.
103      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
104      *
105      * Emits a {Transfer} event.
106      */
107     function transferFrom(
108         address from,
109         address to,
110         uint256 tokenId
111     ) external;
112 
113     /**
114      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
115      * The approval is cleared when the token is transferred.
116      *
117      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
118      *
119      * Requirements:
120      *
121      * - The caller must own the token or be an approved operator.
122      * - `tokenId` must exist.
123      *
124      * Emits an {Approval} event.
125      */
126     function approve(address to, uint256 tokenId) external;
127 
128     /**
129      * @dev Returns the account approved for `tokenId` token.
130      *
131      * Requirements:
132      *
133      * - `tokenId` must exist.
134      */
135     function getApproved(uint256 tokenId) external view returns (address operator);
136 
137     /**
138      * @dev Approve or remove `operator` as an operator for the caller.
139      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
140      *
141      * Requirements:
142      *
143      * - The `operator` cannot be the caller.
144      *
145      * Emits an {ApprovalForAll} event.
146      */
147     function setApprovalForAll(address operator, bool _approved) external;
148 
149     /**
150      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
151      *
152      * See {setApprovalForAll}
153      */
154     function isApprovedForAll(address owner, address operator) external view returns (bool);
155 
156     /**
157      * @dev Safely transfers `tokenId` token from `from` to `to`.
158      *
159      * Requirements:
160      *
161      * - `from` cannot be the zero address.
162      * - `to` cannot be the zero address.
163      * - `tokenId` token must exist and be owned by `from`.
164      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
165      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
166      *
167      * Emits a {Transfer} event.
168      */
169     function safeTransferFrom(
170         address from,
171         address to,
172         uint256 tokenId,
173         bytes calldata data
174     ) external;
175 }
176 
177 
178 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
179 pragma solidity ^0.8.0;
180 /**
181  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
182  * @dev See https://eips.ethereum.org/EIPS/eip-721
183  */
184 interface IERC721Enumerable is IERC721 {
185     /**
186      * @dev Returns the total amount of tokens stored by the contract.
187      */
188     function totalSupply() external view returns (uint256);
189 
190     /**
191      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
192      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
193      */
194     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
195 
196     /**
197      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
198      * Use along with {totalSupply} to enumerate all tokens.
199      */
200     function tokenByIndex(uint256 index) external view returns (uint256);
201 }
202 
203 
204 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
205 pragma solidity ^0.8.0;
206 /**
207  * @dev Implementation of the {IERC165} interface.
208  *
209  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
210  * for the additional interface id that will be supported. For example:
211  *
212  * ```solidity
213  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
214  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
215  * }
216  * ```
217  *
218  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
219  */
220 abstract contract ERC165 is IERC165 {
221     /**
222      * @dev See {IERC165-supportsInterface}.
223      */
224     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
225         return interfaceId == type(IERC165).interfaceId;
226     }
227 }
228 
229 // File: @openzeppelin/contracts/utils/Strings.sol
230 
231 
232 
233 pragma solidity ^0.8.0;
234 
235 /**
236  * @dev String operations.
237  */
238 library Strings {
239     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
240 
241     /**
242      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
243      */
244     function toString(uint256 value) internal pure returns (string memory) {
245         // Inspired by OraclizeAPI's implementation - MIT licence
246         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
247 
248         if (value == 0) {
249             return "0";
250         }
251         uint256 temp = value;
252         uint256 digits;
253         while (temp != 0) {
254             digits++;
255             temp /= 10;
256         }
257         bytes memory buffer = new bytes(digits);
258         while (value != 0) {
259             digits -= 1;
260             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
261             value /= 10;
262         }
263         return string(buffer);
264     }
265 
266     /**
267      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
268      */
269     function toHexString(uint256 value) internal pure returns (string memory) {
270         if (value == 0) {
271             return "0x00";
272         }
273         uint256 temp = value;
274         uint256 length = 0;
275         while (temp != 0) {
276             length++;
277             temp >>= 8;
278         }
279         return toHexString(value, length);
280     }
281 
282     /**
283      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
284      */
285     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
286         bytes memory buffer = new bytes(2 * length + 2);
287         buffer[0] = "0";
288         buffer[1] = "x";
289         for (uint256 i = 2 * length + 1; i > 1; --i) {
290             buffer[i] = _HEX_SYMBOLS[value & 0xf];
291             value >>= 4;
292         }
293         require(value == 0, "Strings: hex length insufficient");
294         return string(buffer);
295     }
296 }
297 
298 // File: @openzeppelin/contracts/utils/Address.sol
299 
300 
301 
302 pragma solidity ^0.8.0;
303 
304 /**
305  * @dev Collection of functions related to the address type
306  */
307 library Address {
308     /**
309      * @dev Returns true if `account` is a contract.
310      *
311      * [IMPORTANT]
312      * ====
313      * It is unsafe to assume that an address for which this function returns
314      * false is an externally-owned account (EOA) and not a contract.
315      *
316      * Among others, `isContract` will return false for the following
317      * types of addresses:
318      *
319      *  - an externally-owned account
320      *  - a contract in construction
321      *  - an address where a contract will be created
322      *  - an address where a contract lived, but was destroyed
323      * ====
324      */
325     function isContract(address account) internal view returns (bool) {
326         // This method relies on extcodesize, which returns 0 for contracts in
327         // construction, since the code is only stored at the end of the
328         // constructor execution.
329 
330         uint256 size;
331         assembly {
332             size := extcodesize(account)
333         }
334         return size > 0;
335     }
336 
337     /**
338      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
339      * `recipient`, forwarding all available gas and reverting on errors.
340      *
341      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
342      * of certain opcodes, possibly making contracts go over the 2300 gas limit
343      * imposed by `transfer`, making them unable to receive funds via
344      * `transfer`. {sendValue} removes this limitation.
345      *
346      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
347      *
348      * IMPORTANT: because control is transferred to `recipient`, care must be
349      * taken to not create reentrancy vulnerabilities. Consider using
350      * {ReentrancyGuard} or the
351      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
352      */
353     function sendValue(address payable recipient, uint256 amount) internal {
354         require(address(this).balance >= amount, "Address: insufficient balance");
355 
356         (bool success, ) = recipient.call{value: amount}("");
357         require(success, "Address: unable to send value, recipient may have reverted");
358     }
359 
360     /**
361      * @dev Performs a Solidity function call using a low level `call`. A
362      * plain `call` is an unsafe replacement for a function call: use this
363      * function instead.
364      *
365      * If `target` reverts with a revert reason, it is bubbled up by this
366      * function (like regular Solidity function calls).
367      *
368      * Returns the raw returned data. To convert to the expected return value,
369      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
370      *
371      * Requirements:
372      *
373      * - `target` must be a contract.
374      * - calling `target` with `data` must not revert.
375      *
376      * _Available since v3.1._
377      */
378     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
379         return functionCall(target, data, "Address: low-level call failed");
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
384      * `errorMessage` as a fallback revert reason when `target` reverts.
385      *
386      * _Available since v3.1._
387      */
388     function functionCall(
389         address target,
390         bytes memory data,
391         string memory errorMessage
392     ) internal returns (bytes memory) {
393         return functionCallWithValue(target, data, 0, errorMessage);
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
398      * but also transferring `value` wei to `target`.
399      *
400      * Requirements:
401      *
402      * - the calling contract must have an ETH balance of at least `value`.
403      * - the called Solidity function must be `payable`.
404      *
405      * _Available since v3.1._
406      */
407     function functionCallWithValue(
408         address target,
409         bytes memory data,
410         uint256 value
411     ) internal returns (bytes memory) {
412         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
417      * with `errorMessage` as a fallback revert reason when `target` reverts.
418      *
419      * _Available since v3.1._
420      */
421     function functionCallWithValue(
422         address target,
423         bytes memory data,
424         uint256 value,
425         string memory errorMessage
426     ) internal returns (bytes memory) {
427         require(address(this).balance >= value, "Address: insufficient balance for call");
428         require(isContract(target), "Address: call to non-contract");
429 
430         (bool success, bytes memory returndata) = target.call{value: value}(data);
431         return verifyCallResult(success, returndata, errorMessage);
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
436      * but performing a static call.
437      *
438      * _Available since v3.3._
439      */
440     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
441         return functionStaticCall(target, data, "Address: low-level static call failed");
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
446      * but performing a static call.
447      *
448      * _Available since v3.3._
449      */
450     function functionStaticCall(
451         address target,
452         bytes memory data,
453         string memory errorMessage
454     ) internal view returns (bytes memory) {
455         require(isContract(target), "Address: static call to non-contract");
456 
457         (bool success, bytes memory returndata) = target.staticcall(data);
458         return verifyCallResult(success, returndata, errorMessage);
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
463      * but performing a delegate call.
464      *
465      * _Available since v3.4._
466      */
467     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
468         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
473      * but performing a delegate call.
474      *
475      * _Available since v3.4._
476      */
477     function functionDelegateCall(
478         address target,
479         bytes memory data,
480         string memory errorMessage
481     ) internal returns (bytes memory) {
482         require(isContract(target), "Address: delegate call to non-contract");
483 
484         (bool success, bytes memory returndata) = target.delegatecall(data);
485         return verifyCallResult(success, returndata, errorMessage);
486     }
487 
488     /**
489      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
490      * revert reason using the provided one.
491      *
492      * _Available since v4.3._
493      */
494     function verifyCallResult(
495         bool success,
496         bytes memory returndata,
497         string memory errorMessage
498     ) internal pure returns (bytes memory) {
499         if (success) {
500             return returndata;
501         } else {
502             // Look for revert reason and bubble it up if present
503             if (returndata.length > 0) {
504                 // The easiest way to bubble the revert reason is using memory via assembly
505 
506                 assembly {
507                     let returndata_size := mload(returndata)
508                     revert(add(32, returndata), returndata_size)
509                 }
510             } else {
511                 revert(errorMessage);
512             }
513         }
514     }
515 }
516 
517 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
518 
519 
520 
521 pragma solidity ^0.8.0;
522 
523 
524 /**
525  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
526  * @dev See https://eips.ethereum.org/EIPS/eip-721
527  */
528 interface IERC721Metadata is IERC721 {
529     /**
530      * @dev Returns the token collection name.
531      */
532     function name() external view returns (string memory);
533 
534     /**
535      * @dev Returns the token collection symbol.
536      */
537     function symbol() external view returns (string memory);
538 
539     /**
540      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
541      */
542     function tokenURI(uint256 tokenId) external view returns (string memory);
543 }
544 
545 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
546 
547 
548 
549 pragma solidity ^0.8.0;
550 
551 /**
552  * @title ERC721 token receiver interface
553  * @dev Interface for any contract that wants to support safeTransfers
554  * from ERC721 asset contracts.
555  */
556 interface IERC721Receiver {
557     /**
558      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
559      * by `operator` from `from`, this function is called.
560      *
561      * It must return its Solidity selector to confirm the token transfer.
562      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
563      *
564      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
565      */
566     function onERC721Received(
567         address operator,
568         address from,
569         uint256 tokenId,
570         bytes calldata data
571     ) external returns (bytes4);
572 }
573 
574 // File: @openzeppelin/contracts/utils/Context.sol
575 pragma solidity ^0.8.0;
576 /**
577  * @dev Provides information about the current execution context, including the
578  * sender of the transaction and its data. While these are generally available
579  * via msg.sender and msg.data, they should not be accessed in such a direct
580  * manner, since when dealing with meta-transactions the account sending and
581  * paying for execution may not be the actual sender (as far as an application
582  * is concerned).
583  *
584  * This contract is only required for intermediate, library-like contracts.
585  */
586 abstract contract Context {
587     function _msgSender() internal view virtual returns (address) {
588         return msg.sender;
589     }
590 
591     function _msgData() internal view virtual returns (bytes calldata) {
592         return msg.data;
593     }
594 }
595 
596 
597 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
598 pragma solidity ^0.8.0;
599 /**
600  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
601  * the Metadata extension, but not including the Enumerable extension, which is available separately as
602  * {ERC721Enumerable}.
603  */
604 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
605     using Address for address;
606     using Strings for uint256;
607 
608     // Token name
609     string private _name;
610 
611     // Token symbol
612     string private _symbol;
613 
614     // Mapping from token ID to owner address
615     mapping(uint256 => address) private _owners;
616 
617     // Mapping owner address to token count
618     mapping(address => uint256) private _balances;
619 
620     // Mapping from token ID to approved address
621     mapping(uint256 => address) private _tokenApprovals;
622 
623     // Mapping from owner to operator approvals
624     mapping(address => mapping(address => bool)) private _operatorApprovals;
625 
626     /**
627      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
628      */
629     constructor(string memory name_, string memory symbol_) {
630         _name = name_;
631         _symbol = symbol_;
632     }
633 
634     /**
635      * @dev See {IERC165-supportsInterface}.
636      */
637     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
638         return
639             interfaceId == type(IERC721).interfaceId ||
640             interfaceId == type(IERC721Metadata).interfaceId ||
641             super.supportsInterface(interfaceId);
642     }
643 
644     /**
645      * @dev See {IERC721-balanceOf}.
646      */
647     function balanceOf(address owner) public view virtual override returns (uint256) {
648         require(owner != address(0), "ERC721: balance query for the zero address");
649         return _balances[owner];
650     }
651 
652     /**
653      * @dev See {IERC721-ownerOf}.
654      */
655     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
656         address owner = _owners[tokenId];
657         require(owner != address(0), "ERC721: owner query for nonexistent token");
658         return owner;
659     }
660 
661     /**
662      * @dev See {IERC721Metadata-name}.
663      */
664     function name() public view virtual override returns (string memory) {
665         return _name;
666     }
667 
668     /**
669      * @dev See {IERC721Metadata-symbol}.
670      */
671     function symbol() public view virtual override returns (string memory) {
672         return _symbol;
673     }
674 
675     /**
676      * @dev See {IERC721Metadata-tokenURI}.
677      */
678     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
679         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
680 
681         string memory baseURI = _baseURI();
682         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
683     }
684 
685     /**
686      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
687      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
688      * by default, can be overriden in child contracts.
689      */
690     function _baseURI() internal view virtual returns (string memory) {
691         return "";
692     }
693 
694     /**
695      * @dev See {IERC721-approve}.
696      */
697     function approve(address to, uint256 tokenId) public virtual override {
698         address owner = ERC721.ownerOf(tokenId);
699         require(to != owner, "ERC721: approval to current owner");
700 
701         require(
702             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
703             "ERC721: approve caller is not owner nor approved for all"
704         );
705 
706         _approve(to, tokenId);
707     }
708 
709     /**
710      * @dev See {IERC721-getApproved}.
711      */
712     function getApproved(uint256 tokenId) public view virtual override returns (address) {
713         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
714 
715         return _tokenApprovals[tokenId];
716     }
717 
718     /**
719      * @dev See {IERC721-setApprovalForAll}.
720      */
721     function setApprovalForAll(address operator, bool approved) public virtual override {
722         require(operator != _msgSender(), "ERC721: approve to caller");
723 
724         _operatorApprovals[_msgSender()][operator] = approved;
725         emit ApprovalForAll(_msgSender(), operator, approved);
726     }
727 
728     /**
729      * @dev See {IERC721-isApprovedForAll}.
730      */
731     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
732         return _operatorApprovals[owner][operator];
733     }
734 
735     /**
736      * @dev See {IERC721-transferFrom}.
737      */
738     function transferFrom(
739         address from,
740         address to,
741         uint256 tokenId
742     ) public virtual override {
743         //solhint-disable-next-line max-line-length
744         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
745 
746         _transfer(from, to, tokenId);
747     }
748 
749     /**
750      * @dev See {IERC721-safeTransferFrom}.
751      */
752     function safeTransferFrom(
753         address from,
754         address to,
755         uint256 tokenId
756     ) public virtual override {
757         safeTransferFrom(from, to, tokenId, "");
758     }
759 
760     /**
761      * @dev See {IERC721-safeTransferFrom}.
762      */
763     function safeTransferFrom(
764         address from,
765         address to,
766         uint256 tokenId,
767         bytes memory _data
768     ) public virtual override {
769         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
770         _safeTransfer(from, to, tokenId, _data);
771     }
772 
773     /**
774      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
775      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
776      *
777      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
778      *
779      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
780      * implement alternative mechanisms to perform token transfer, such as signature-based.
781      *
782      * Requirements:
783      *
784      * - `from` cannot be the zero address.
785      * - `to` cannot be the zero address.
786      * - `tokenId` token must exist and be owned by `from`.
787      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
788      *
789      * Emits a {Transfer} event.
790      */
791     function _safeTransfer(
792         address from,
793         address to,
794         uint256 tokenId,
795         bytes memory _data
796     ) internal virtual {
797         _transfer(from, to, tokenId);
798         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
799     }
800 
801     /**
802      * @dev Returns whether `tokenId` exists.
803      *
804      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
805      *
806      * Tokens start existing when they are minted (`_mint`),
807      * and stop existing when they are burned (`_burn`).
808      */
809     function _exists(uint256 tokenId) internal view virtual returns (bool) {
810         return _owners[tokenId] != address(0);
811     }
812 
813     /**
814      * @dev Returns whether `spender` is allowed to manage `tokenId`.
815      *
816      * Requirements:
817      *
818      * - `tokenId` must exist.
819      */
820     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
821         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
822         address owner = ERC721.ownerOf(tokenId);
823         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
824     }
825 
826     /**
827      * @dev Safely mints `tokenId` and transfers it to `to`.
828      *
829      * Requirements:
830      *
831      * - `tokenId` must not exist.
832      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
833      *
834      * Emits a {Transfer} event.
835      */
836     function _safeMint(address to, uint256 tokenId) internal virtual {
837         _safeMint(to, tokenId, "");
838     }
839 
840     /**
841      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
842      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
843      */
844     function _safeMint(
845         address to,
846         uint256 tokenId,
847         bytes memory _data
848     ) internal virtual {
849         _mint(to, tokenId);
850         require(
851             _checkOnERC721Received(address(0), to, tokenId, _data),
852             "ERC721: transfer to non ERC721Receiver implementer"
853         );
854     }
855 
856     /**
857      * @dev Mints `tokenId` and transfers it to `to`.
858      *
859      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
860      *
861      * Requirements:
862      *
863      * - `tokenId` must not exist.
864      * - `to` cannot be the zero address.
865      *
866      * Emits a {Transfer} event.
867      */
868     function _mint(address to, uint256 tokenId) internal virtual {
869         require(to != address(0), "ERC721: mint to the zero address");
870         require(!_exists(tokenId), "ERC721: token already minted");
871 
872         _beforeTokenTransfer(address(0), to, tokenId);
873 
874         _balances[to] += 1;
875         _owners[tokenId] = to;
876 
877         emit Transfer(address(0), to, tokenId);
878     }
879 
880     /**
881      * @dev Destroys `tokenId`.
882      * The approval is cleared when the token is burned.
883      *
884      * Requirements:
885      *
886      * - `tokenId` must exist.
887      *
888      * Emits a {Transfer} event.
889      */
890     function _burn(uint256 tokenId) internal virtual {
891         address owner = ERC721.ownerOf(tokenId);
892 
893         _beforeTokenTransfer(owner, address(0), tokenId);
894 
895         // Clear approvals
896         _approve(address(0), tokenId);
897 
898         _balances[owner] -= 1;
899         delete _owners[tokenId];
900 
901         emit Transfer(owner, address(0), tokenId);
902     }
903 
904     /**
905      * @dev Transfers `tokenId` from `from` to `to`.
906      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
907      *
908      * Requirements:
909      *
910      * - `to` cannot be the zero address.
911      * - `tokenId` token must be owned by `from`.
912      *
913      * Emits a {Transfer} event.
914      */
915     function _transfer(
916         address from,
917         address to,
918         uint256 tokenId
919     ) internal virtual {
920         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
921         require(to != address(0), "ERC721: transfer to the zero address");
922 
923         _beforeTokenTransfer(from, to, tokenId);
924 
925         // Clear approvals from the previous owner
926         _approve(address(0), tokenId);
927 
928         _balances[from] -= 1;
929         _balances[to] += 1;
930         _owners[tokenId] = to;
931 
932         emit Transfer(from, to, tokenId);
933     }
934 
935     /**
936      * @dev Approve `to` to operate on `tokenId`
937      *
938      * Emits a {Approval} event.
939      */
940     function _approve(address to, uint256 tokenId) internal virtual {
941         _tokenApprovals[tokenId] = to;
942         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
943     }
944 
945     /**
946      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
947      * The call is not executed if the target address is not a contract.
948      *
949      * @param from address representing the previous owner of the given token ID
950      * @param to target address that will receive the tokens
951      * @param tokenId uint256 ID of the token to be transferred
952      * @param _data bytes optional data to send along with the call
953      * @return bool whether the call correctly returned the expected magic value
954      */
955     function _checkOnERC721Received(
956         address from,
957         address to,
958         uint256 tokenId,
959         bytes memory _data
960     ) private returns (bool) {
961         if (to.isContract()) {
962             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
963                 return retval == IERC721Receiver.onERC721Received.selector;
964             } catch (bytes memory reason) {
965                 if (reason.length == 0) {
966                     revert("ERC721: transfer to non ERC721Receiver implementer");
967                 } else {
968                     assembly {
969                         revert(add(32, reason), mload(reason))
970                     }
971                 }
972             }
973         } else {
974             return true;
975         }
976     }
977 
978     /**
979      * @dev Hook that is called before any token transfer. This includes minting
980      * and burning.
981      *
982      * Calling conditions:
983      *
984      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
985      * transferred to `to`.
986      * - When `from` is zero, `tokenId` will be minted for `to`.
987      * - When `to` is zero, ``from``'s `tokenId` will be burned.
988      * - `from` and `to` are never both zero.
989      *
990      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
991      */
992     function _beforeTokenTransfer(
993         address from,
994         address to,
995         uint256 tokenId
996     ) internal virtual {}
997 }
998 
999 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1000 
1001 
1002 
1003 pragma solidity ^0.8.0;
1004 
1005 
1006 
1007 /**
1008  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1009  * enumerability of all the token ids in the contract as well as all token ids owned by each
1010  * account.
1011  */
1012 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1013     // Mapping from owner to list of owned token IDs
1014     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1015 
1016     // Mapping from token ID to index of the owner tokens list
1017     mapping(uint256 => uint256) private _ownedTokensIndex;
1018 
1019     // Array with all token ids, used for enumeration
1020     uint256[] private _allTokens;
1021 
1022     // Mapping from token id to position in the allTokens array
1023     mapping(uint256 => uint256) private _allTokensIndex;
1024 
1025     /**
1026      * @dev See {IERC165-supportsInterface}.
1027      */
1028     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1029         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1030     }
1031 
1032     /**
1033      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1034      */
1035     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1036         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1037         return _ownedTokens[owner][index];
1038     }
1039 
1040     /**
1041      * @dev See {IERC721Enumerable-totalSupply}.
1042      */
1043     function totalSupply() public view virtual override returns (uint256) {
1044         return _allTokens.length;
1045     }
1046 
1047     /**
1048      * @dev See {IERC721Enumerable-tokenByIndex}.
1049      */
1050     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1051         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1052         return _allTokens[index];
1053     }
1054 
1055     /**
1056      * @dev Hook that is called before any token transfer. This includes minting
1057      * and burning.
1058      *
1059      * Calling conditions:
1060      *
1061      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1062      * transferred to `to`.
1063      * - When `from` is zero, `tokenId` will be minted for `to`.
1064      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1065      * - `from` cannot be the zero address.
1066      * - `to` cannot be the zero address.
1067      *
1068      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1069      */
1070     function _beforeTokenTransfer(
1071         address from,
1072         address to,
1073         uint256 tokenId
1074     ) internal virtual override {
1075         super._beforeTokenTransfer(from, to, tokenId);
1076 
1077         if (from == address(0)) {
1078             _addTokenToAllTokensEnumeration(tokenId);
1079         } else if (from != to) {
1080             _removeTokenFromOwnerEnumeration(from, tokenId);
1081         }
1082         if (to == address(0)) {
1083             _removeTokenFromAllTokensEnumeration(tokenId);
1084         } else if (to != from) {
1085             _addTokenToOwnerEnumeration(to, tokenId);
1086         }
1087     }
1088 
1089     /**
1090      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1091      * @param to address representing the new owner of the given token ID
1092      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1093      */
1094     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1095         uint256 length = ERC721.balanceOf(to);
1096         _ownedTokens[to][length] = tokenId;
1097         _ownedTokensIndex[tokenId] = length;
1098     }
1099 
1100     /**
1101      * @dev Private function to add a token to this extension's token tracking data structures.
1102      * @param tokenId uint256 ID of the token to be added to the tokens list
1103      */
1104     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1105         _allTokensIndex[tokenId] = _allTokens.length;
1106         _allTokens.push(tokenId);
1107     }
1108 
1109     /**
1110      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1111      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1112      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1113      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1114      * @param from address representing the previous owner of the given token ID
1115      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1116      */
1117     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1118         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1119         // then delete the last slot (swap and pop).
1120 
1121         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1122         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1123 
1124         // When the token to delete is the last token, the swap operation is unnecessary
1125         if (tokenIndex != lastTokenIndex) {
1126             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1127 
1128             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1129             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1130         }
1131 
1132         // This also deletes the contents at the last position of the array
1133         delete _ownedTokensIndex[tokenId];
1134         delete _ownedTokens[from][lastTokenIndex];
1135     }
1136 
1137     /**
1138      * @dev Private function to remove a token from this extension's token tracking data structures.
1139      * This has O(1) time complexity, but alters the order of the _allTokens array.
1140      * @param tokenId uint256 ID of the token to be removed from the tokens list
1141      */
1142     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1143         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1144         // then delete the last slot (swap and pop).
1145 
1146         uint256 lastTokenIndex = _allTokens.length - 1;
1147         uint256 tokenIndex = _allTokensIndex[tokenId];
1148 
1149         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1150         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1151         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1152         uint256 lastTokenId = _allTokens[lastTokenIndex];
1153 
1154         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1155         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1156 
1157         // This also deletes the contents at the last position of the array
1158         delete _allTokensIndex[tokenId];
1159         _allTokens.pop();
1160     }
1161 }
1162 
1163 
1164 // File: @openzeppelin/contracts/access/Ownable.sol
1165 pragma solidity ^0.8.0;
1166 /**
1167  * @dev Contract module which provides a basic access control mechanism, where
1168  * there is an account (an owner) that can be granted exclusive access to
1169  * specific functions.
1170  *
1171  * By default, the owner account will be the one that deploys the contract. This
1172  * can later be changed with {transferOwnership}.
1173  *
1174  * This module is used through inheritance. It will make available the modifier
1175  * `onlyOwner`, which can be applied to your functions to restrict their use to
1176  * the owner.
1177  */
1178 abstract contract Ownable is Context {
1179     address private _owner;
1180 
1181     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1182 
1183     /**
1184      * @dev Initializes the contract setting the deployer as the initial owner.
1185      */
1186     constructor() {
1187         _setOwner(_msgSender());
1188     }
1189 
1190     /**
1191      * @dev Returns the address of the current owner.
1192      */
1193     function owner() public view virtual returns (address) {
1194         return _owner;
1195     }
1196 
1197     /**
1198      * @dev Throws if called by any account other than the owner.
1199      */
1200     modifier onlyOwner() {
1201         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1202         _;
1203     }
1204 
1205     /**
1206      * @dev Leaves the contract without owner. It will not be possible to call
1207      * `onlyOwner` functions anymore. Can only be called by the current owner.
1208      *
1209      * NOTE: Renouncing ownership will leave the contract without an owner,
1210      * thereby removing any functionality that is only available to the owner.
1211      */
1212     function renounceOwnership() public virtual onlyOwner {
1213         _setOwner(address(0));
1214     }
1215 
1216     /**
1217      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1218      * Can only be called by the current owner.
1219      */
1220     function transferOwnership(address newOwner) public virtual onlyOwner {
1221         require(newOwner != address(0), "Ownable: new owner is the zero address");
1222         _setOwner(newOwner);
1223     }
1224 
1225     function _setOwner(address newOwner) private {
1226         address oldOwner = _owner;
1227         _owner = newOwner;
1228         emit OwnershipTransferred(oldOwner, newOwner);
1229     }
1230 }
1231 
1232 pragma solidity ^0.8.0;
1233 
1234 contract KoolKittensNFT is ERC721Enumerable, Ownable {
1235   using Strings for uint256;
1236 
1237   string public baseURI;
1238   uint256 public cost = 20000000000000000; // 0.02 eth
1239   uint256 public maxSupply = 3333;
1240   uint256 public maxMintAmount = 20;
1241   bool public paused = false;
1242   mapping(address => bool) public whitelisted;
1243 
1244   constructor() ERC721("Kool Kittens", "KoolKittens") { }
1245 
1246   // internal
1247   function _baseURI() internal view virtual override returns (string memory) {
1248     return baseURI;
1249   }
1250 
1251   // public
1252   function mint(address _to, uint256 _mintAmount) public payable {
1253     uint256 supply = totalSupply();
1254     require(!paused);
1255     require(msg.value >= cost);
1256     require(_mintAmount > 0);
1257     require(_mintAmount <= maxMintAmount);
1258     require(supply + _mintAmount <= maxSupply);
1259 
1260     if (msg.sender != owner()) {
1261         if(whitelisted[msg.sender] != true) {
1262           require(msg.value >= cost * _mintAmount);
1263         }
1264     }
1265 
1266     for (uint256 i = 1; i <= _mintAmount; i++) {
1267       _safeMint(_to, supply + i);
1268     }
1269   }
1270 
1271   // free
1272   function mintFREE(address _to, uint256 _claimAmount) public payable {
1273     uint256 supply = totalSupply();
1274     require(!paused);
1275     require(_claimAmount > 0);
1276     require(_claimAmount <= 1);
1277     require(supply + _claimAmount <= 300);
1278 
1279     for (uint256 i = 1; i <= _claimAmount; i++) {
1280       _safeMint(_to, supply + i);
1281     }
1282   }
1283   
1284   function walletOfOwner(address _owner)
1285     public
1286     view
1287     returns (uint256[] memory)
1288   {
1289     uint256 ownerTokenCount = balanceOf(_owner);
1290     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1291     for (uint256 i; i < ownerTokenCount; i++) {
1292       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1293     }
1294     return tokenIds;
1295   }
1296 
1297   function tokenURI(uint256 tokenId)
1298     public
1299     view
1300     virtual
1301     override
1302     returns (string memory)
1303   {
1304     require(
1305       _exists(tokenId),
1306       "ERC721Metadata: URI query for nonexistent token"
1307     );
1308 
1309     string memory currentBaseURI = _baseURI();
1310     return bytes(currentBaseURI).length > 0
1311         ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
1312         : "";
1313   }
1314 
1315   //only owner
1316   function setCost(uint256 _newCost) public onlyOwner {
1317     cost = _newCost;
1318   }
1319 
1320   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1321     maxMintAmount = _newmaxMintAmount;
1322   }
1323 
1324   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1325     baseURI = _newBaseURI;
1326   }
1327 
1328   function pause(bool _state) public onlyOwner {
1329     paused = _state;
1330   }
1331  
1332  function whitelistUser(address _user) public onlyOwner {
1333     whitelisted[_user] = true;
1334   }
1335  
1336   function removeWhitelistUser(address _user) public onlyOwner {
1337     whitelisted[_user] = false;
1338   }
1339 
1340   function withdraw() onlyOwner public {
1341     uint256 balance = address(this).balance;
1342     payable(msg.sender).transfer(balance);
1343   }   
1344 }