1 // SPDX-License-Identifier: MIT
2 
3 
4 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
5 
6 
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC165 standard, as defined in the
12  * https://eips.ethereum.org/EIPS/eip-165[EIP].
13  *
14  * Implementers can declare support of contract interfaces, which can then be
15  * queried by others ({ERC165Checker}).
16  *
17  * For an implementation, see {ERC165}.
18  */
19 interface IERC165 {
20     /**
21      * @dev Returns true if this contract implements the interface defined by
22      * `interfaceId`. See the corresponding
23      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
24      * to learn more about how these ids are created.
25      *
26      * This function call must use less than 30 000 gas.
27      */
28     function supportsInterface(bytes4 interfaceId) external view returns (bool);
29 }
30 
31 
32 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
33 
34 
35 
36 pragma solidity ^0.8.0;
37 
38 
39 /**
40  * @dev Required interface of an ERC721 compliant contract.
41  */
42 interface IERC721 is IERC165 {
43     /**
44      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
45      */
46     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
47 
48     /**
49      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
50      */
51     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
52 
53     /**
54      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
55      */
56     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
57 
58     /**
59      * @dev Returns the number of tokens in ``owner``'s account.
60      */
61     function balanceOf(address owner) external view returns (uint256 balance);
62 
63     /**
64      * @dev Returns the owner of the `tokenId` token.
65      *
66      * Requirements:
67      *
68      * - `tokenId` must exist.
69      */
70     function ownerOf(uint256 tokenId) external view returns (address owner);
71 
72     /**
73      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
74      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
75      *
76      * Requirements:
77      *
78      * - `from` cannot be the zero address.
79      * - `to` cannot be the zero address.
80      * - `tokenId` token must exist and be owned by `from`.
81      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
82      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
83      *
84      * Emits a {Transfer} event.
85      */
86     function safeTransferFrom(
87         address from,
88         address to,
89         uint256 tokenId
90     ) external;
91 
92     /**
93      * @dev Transfers `tokenId` token from `from` to `to`.
94      *
95      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
96      *
97      * Requirements:
98      *
99      * - `from` cannot be the zero address.
100      * - `to` cannot be the zero address.
101      * - `tokenId` token must be owned by `from`.
102      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transferFrom(
107         address from,
108         address to,
109         uint256 tokenId
110     ) external;
111 
112     /**
113      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
114      * The approval is cleared when the token is transferred.
115      *
116      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
117      *
118      * Requirements:
119      *
120      * - The caller must own the token or be an approved operator.
121      * - `tokenId` must exist.
122      *
123      * Emits an {Approval} event.
124      */
125     function approve(address to, uint256 tokenId) external;
126 
127     /**
128      * @dev Returns the account approved for `tokenId` token.
129      *
130      * Requirements:
131      *
132      * - `tokenId` must exist.
133      */
134     function getApproved(uint256 tokenId) external view returns (address operator);
135 
136     /**
137      * @dev Approve or remove `operator` as an operator for the caller.
138      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
139      *
140      * Requirements:
141      *
142      * - The `operator` cannot be the caller.
143      *
144      * Emits an {ApprovalForAll} event.
145      */
146     function setApprovalForAll(address operator, bool _approved) external;
147 
148     /**
149      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
150      *
151      * See {setApprovalForAll}
152      */
153     function isApprovedForAll(address owner, address operator) external view returns (bool);
154 
155     /**
156      * @dev Safely transfers `tokenId` token from `from` to `to`.
157      *
158      * Requirements:
159      *
160      * - `from` cannot be the zero address.
161      * - `to` cannot be the zero address.
162      * - `tokenId` token must exist and be owned by `from`.
163      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
164      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
165      *
166      * Emits a {Transfer} event.
167      */
168     function safeTransferFrom(
169         address from,
170         address to,
171         uint256 tokenId,
172         bytes calldata data
173     ) external;
174 }
175 
176 // File: @openzeppelin/contracts/utils/Context.sol
177 
178 
179 
180 pragma solidity ^0.8.0;
181 
182 /**
183  * @dev Provides information about the current execution context, including the
184  * sender of the transaction and its data. While these are generally available
185  * via msg.sender and msg.data, they should not be accessed in such a direct
186  * manner, since when dealing with meta-transactions the account sending and
187  * paying for execution may not be the actual sender (as far as an application
188  * is concerned).
189  *
190  * This contract is only required for intermediate, library-like contracts.
191  */
192 abstract contract Context {
193     function _msgSender() internal view virtual returns (address) {
194         return msg.sender;
195     }
196 
197     function _msgData() internal view virtual returns (bytes calldata) {
198         return msg.data;
199     }
200 }
201 
202 // File: @openzeppelin/contracts/access/Ownable.sol
203 
204 
205 pragma solidity ^0.8.0;
206 
207 
208 /**
209  * @dev Contract module which provides a basic access control mechanism, where
210  * there is an account (an owner) that can be granted exclusive access to
211  * specific functions.
212  *
213  * By default, the owner account will be the one that deploys the contract. This
214  * can later be changed with {transferOwnership}.
215  *
216  * This module is used through inheritance. It will make available the modifier
217  * `onlyOwner`, which can be applied to your functions to restrict their use to
218  * the owner.
219  */
220 abstract contract Ownable is Context {
221     address private _owner;
222 
223     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
224 
225     /**
226      * @dev Initializes the contract setting the deployer as the initial owner.
227      */
228     constructor() {
229         _setOwner(_msgSender());
230     }
231 
232     /**
233      * @dev Returns the address of the current owner.
234      */
235     function owner() public view virtual returns (address) {
236         return _owner;
237     }
238 
239     /**
240      * @dev Throws if called by any account other than the owner.
241      */
242     modifier onlyOwner() {
243         require(owner() == _msgSender(), "Ownable: caller is not the owner");
244         _;
245     }
246 
247     /**
248      * @dev Leaves the contract without owner. It will not be possible to call
249      * `onlyOwner` functions anymore. Can only be called by the current owner.
250      *
251      * NOTE: Renouncing ownership will leave the contract without an owner,
252      * thereby removing any functionality that is only available to the owner.
253      */
254     function renounceOwnership() public virtual onlyOwner {
255         _setOwner(address(0));
256     }
257 
258     /**
259      * @dev Transfers ownership of the contract to a new account (`newOwner`).
260      * Can only be called by the current owner.
261      */
262     function transferOwnership(address newOwner) public virtual onlyOwner {
263         require(newOwner != address(0), "Ownable: new owner is the zero address");
264         _setOwner(newOwner);
265     }
266 
267     function _setOwner(address newOwner) private {
268         address oldOwner = _owner;
269         _owner = newOwner;
270         emit OwnershipTransferred(oldOwner, newOwner);
271     }
272 }
273 
274 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
275 
276 
277 
278 pragma solidity ^0.8.0;
279 
280 
281 /**
282  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
283  * @dev See https://eips.ethereum.org/EIPS/eip-721
284  */
285 interface IERC721Enumerable is IERC721 {
286     /**
287      * @dev Returns the total amount of tokens stored by the contract.
288      */
289     function totalSupply() external view returns (uint256);
290 
291     /**
292      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
293      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
294      */
295     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
296 
297     /**
298      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
299      * Use along with {totalSupply} to enumerate all tokens.
300      */
301     function tokenByIndex(uint256 index) external view returns (uint256);
302 }
303 
304 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
305 
306 
307 
308 pragma solidity ^0.8.0;
309 
310 
311 /**
312  * @dev Implementation of the {IERC165} interface.
313  *
314  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
315  * for the additional interface id that will be supported. For example:
316  *
317  * ```solidity
318  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
319  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
320  * }
321  * ```
322  *
323  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
324  */
325 abstract contract ERC165 is IERC165 {
326     /**
327      * @dev See {IERC165-supportsInterface}.
328      */
329     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
330         return interfaceId == type(IERC165).interfaceId;
331     }
332 }
333 
334 // File: @openzeppelin/contracts/utils/Strings.sol
335 
336 
337 
338 pragma solidity ^0.8.0;
339 
340 /**
341  * @dev String operations.
342  */
343 library Strings {
344     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
345 
346     /**
347      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
348      */
349     function toString(uint256 value) internal pure returns (string memory) {
350         // Inspired by OraclizeAPI's implementation - MIT licence
351         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
352 
353         if (value == 0) {
354             return "0";
355         }
356         uint256 temp = value;
357         uint256 digits;
358         while (temp != 0) {
359             digits++;
360             temp /= 10;
361         }
362         bytes memory buffer = new bytes(digits);
363         while (value != 0) {
364             digits -= 1;
365             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
366             value /= 10;
367         }
368         return string(buffer);
369     }
370 
371     /**
372      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
373      */
374     function toHexString(uint256 value) internal pure returns (string memory) {
375         if (value == 0) {
376             return "0x00";
377         }
378         uint256 temp = value;
379         uint256 length = 0;
380         while (temp != 0) {
381             length++;
382             temp >>= 8;
383         }
384         return toHexString(value, length);
385     }
386 
387     /**
388      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
389      */
390     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
391         bytes memory buffer = new bytes(2 * length + 2);
392         buffer[0] = "0";
393         buffer[1] = "x";
394         for (uint256 i = 2 * length + 1; i > 1; --i) {
395             buffer[i] = _HEX_SYMBOLS[value & 0xf];
396             value >>= 4;
397         }
398         require(value == 0, "Strings: hex length insufficient");
399         return string(buffer);
400     }
401 }
402 
403 
404 // File: @openzeppelin/contracts/utils/Address.sol
405 
406 
407 
408 pragma solidity ^0.8.0;
409 
410 /**
411  * @dev Collection of functions related to the address type
412  */
413 library Address {
414     /**
415      * @dev Returns true if `account` is a contract.
416      *
417      * [IMPORTANT]
418      * ====
419      * It is unsafe to assume that an address for which this function returns
420      * false is an externally-owned account (EOA) and not a contract.
421      *
422      * Among others, `isContract` will return false for the following
423      * types of addresses:
424      *
425      *  - an externally-owned account
426      *  - a contract in construction
427      *  - an address where a contract will be created
428      *  - an address where a contract lived, but was destroyed
429      * ====
430      */
431     function isContract(address account) internal view returns (bool) {
432         // This method relies on extcodesize, which returns 0 for contracts in
433         // construction, since the code is only stored at the end of the
434         // constructor execution.
435 
436         uint256 size;
437         assembly {
438             size := extcodesize(account)
439         }
440         return size > 0;
441     }
442 
443     /**
444      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
445      * `recipient`, forwarding all available gas and reverting on errors.
446      *
447      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
448      * of certain opcodes, possibly making contracts go over the 2300 gas limit
449      * imposed by `transfer`, making them unable to receive funds via
450      * `transfer`. {sendValue} removes this limitation.
451      *
452      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
453      *
454      * IMPORTANT: because control is transferred to `recipient`, care must be
455      * taken to not create reentrancy vulnerabilities. Consider using
456      * {ReentrancyGuard} or the
457      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
458      */
459     function sendValue(address payable recipient, uint256 amount) internal {
460         require(address(this).balance >= amount, "Address: insufficient balance");
461 
462         (bool success, ) = recipient.call{value: amount}("");
463         require(success, "Address: unable to send value, recipient may have reverted");
464     }
465 
466     /**
467      * @dev Performs a Solidity function call using a low level `call`. A
468      * plain `call` is an unsafe replacement for a function call: use this
469      * function instead.
470      *
471      * If `target` reverts with a revert reason, it is bubbled up by this
472      * function (like regular Solidity function calls).
473      *
474      * Returns the raw returned data. To convert to the expected return value,
475      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
476      *
477      * Requirements:
478      *
479      * - `target` must be a contract.
480      * - calling `target` with `data` must not revert.
481      *
482      * _Available since v3.1._
483      */
484     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
485         return functionCall(target, data, "Address: low-level call failed");
486     }
487 
488     /**
489      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
490      * `errorMessage` as a fallback revert reason when `target` reverts.
491      *
492      * _Available since v3.1._
493      */
494     function functionCall(
495         address target,
496         bytes memory data,
497         string memory errorMessage
498     ) internal returns (bytes memory) {
499         return functionCallWithValue(target, data, 0, errorMessage);
500     }
501 
502     /**
503      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
504      * but also transferring `value` wei to `target`.
505      *
506      * Requirements:
507      *
508      * - the calling contract must have an ETH balance of at least `value`.
509      * - the called Solidity function must be `payable`.
510      *
511      * _Available since v3.1._
512      */
513     function functionCallWithValue(
514         address target,
515         bytes memory data,
516         uint256 value
517     ) internal returns (bytes memory) {
518         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
519     }
520 
521     /**
522      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
523      * with `errorMessage` as a fallback revert reason when `target` reverts.
524      *
525      * _Available since v3.1._
526      */
527     function functionCallWithValue(
528         address target,
529         bytes memory data,
530         uint256 value,
531         string memory errorMessage
532     ) internal returns (bytes memory) {
533         require(address(this).balance >= value, "Address: insufficient balance for call");
534         require(isContract(target), "Address: call to non-contract");
535 
536         (bool success, bytes memory returndata) = target.call{value: value}(data);
537         return verifyCallResult(success, returndata, errorMessage);
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
542      * but performing a static call.
543      *
544      * _Available since v3.3._
545      */
546     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
547         return functionStaticCall(target, data, "Address: low-level static call failed");
548     }
549 
550     /**
551      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
552      * but performing a static call.
553      *
554      * _Available since v3.3._
555      */
556     function functionStaticCall(
557         address target,
558         bytes memory data,
559         string memory errorMessage
560     ) internal view returns (bytes memory) {
561         require(isContract(target), "Address: static call to non-contract");
562 
563         (bool success, bytes memory returndata) = target.staticcall(data);
564         return verifyCallResult(success, returndata, errorMessage);
565     }
566 
567     /**
568      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
569      * but performing a delegate call.
570      *
571      * _Available since v3.4._
572      */
573     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
574         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
575     }
576 
577     /**
578      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
579      * but performing a delegate call.
580      *
581      * _Available since v3.4._
582      */
583     function functionDelegateCall(
584         address target,
585         bytes memory data,
586         string memory errorMessage
587     ) internal returns (bytes memory) {
588         require(isContract(target), "Address: delegate call to non-contract");
589 
590         (bool success, bytes memory returndata) = target.delegatecall(data);
591         return verifyCallResult(success, returndata, errorMessage);
592     }
593 
594     /**
595      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
596      * revert reason using the provided one.
597      *
598      * _Available since v4.3._
599      */
600     function verifyCallResult(
601         bool success,
602         bytes memory returndata,
603         string memory errorMessage
604     ) internal pure returns (bytes memory) {
605         if (success) {
606             return returndata;
607         } else {
608             // Look for revert reason and bubble it up if present
609             if (returndata.length > 0) {
610                 // The easiest way to bubble the revert reason is using memory via assembly
611 
612                 assembly {
613                     let returndata_size := mload(returndata)
614                     revert(add(32, returndata), returndata_size)
615                 }
616             } else {
617                 revert(errorMessage);
618             }
619         }
620     }
621 }
622 
623 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
624 
625 
626 
627 pragma solidity ^0.8.0;
628 
629 
630 /**
631  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
632  * @dev See https://eips.ethereum.org/EIPS/eip-721
633  */
634 interface IERC721Metadata is IERC721 {
635     /**
636      * @dev Returns the token collection name.
637      */
638     function name() external view returns (string memory);
639 
640     /**
641      * @dev Returns the token collection symbol.
642      */
643     function symbol() external view returns (string memory);
644 
645     /**
646      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
647      */
648     function tokenURI(uint256 tokenId) external view returns (string memory);
649 }
650 
651 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
652 
653 
654 
655 pragma solidity ^0.8.0;
656 
657 /**
658  * @title ERC721 token receiver interface
659  * @dev Interface for any contract that wants to support safeTransfers
660  * from ERC721 asset contracts.
661  */
662 interface IERC721Receiver {
663     /**
664      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
665      * by `operator` from `from`, this function is called.
666      *
667      * It must return its Solidity selector to confirm the token transfer.
668      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
669      *
670      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
671      */
672     function onERC721Received(
673         address operator,
674         address from,
675         uint256 tokenId,
676         bytes calldata data
677     ) external returns (bytes4);
678 }
679 
680 
681 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
682 
683 
684 
685 pragma solidity ^0.8.0;
686 
687 
688 
689 
690 
691 
692 
693 
694 /**
695  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
696  * the Metadata extension, but not including the Enumerable extension, which is available separately as
697  * {ERC721Enumerable}.
698  */
699 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
700     using Address for address;
701     using Strings for uint256;
702 
703     // Token name
704     string private _name;
705 
706     // Token symbol
707     string private _symbol;
708 
709     // Mapping from token ID to owner address
710     mapping(uint256 => address) private _owners;
711 
712     // Mapping owner address to token count
713     mapping(address => uint256) private _balances;
714 
715     // Mapping from token ID to approved address
716     mapping(uint256 => address) private _tokenApprovals;
717 
718     // Mapping from owner to operator approvals
719     mapping(address => mapping(address => bool)) private _operatorApprovals;
720 
721     /**
722      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
723      */
724     constructor(string memory name_, string memory symbol_) {
725         _name = name_;
726         _symbol = symbol_;
727     }
728 
729     /**
730      * @dev See {IERC165-supportsInterface}.
731      */
732     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
733         return
734             interfaceId == type(IERC721).interfaceId ||
735             interfaceId == type(IERC721Metadata).interfaceId ||
736             super.supportsInterface(interfaceId);
737     }
738 
739     /**
740      * @dev See {IERC721-balanceOf}.
741      */
742     function balanceOf(address owner) public view virtual override returns (uint256) {
743         require(owner != address(0), "ERC721: balance query for the zero address");
744         return _balances[owner];
745     }
746 
747     /**
748      * @dev See {IERC721-ownerOf}.
749      */
750     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
751         address owner = _owners[tokenId];
752         require(owner != address(0), "ERC721: owner query for nonexistent token");
753         return owner;
754     }
755 
756     /**
757      * @dev See {IERC721Metadata-name}.
758      */
759     function name() public view virtual override returns (string memory) {
760         return _name;
761     }
762 
763     /**
764      * @dev See {IERC721Metadata-symbol}.
765      */
766     function symbol() public view virtual override returns (string memory) {
767         return _symbol;
768     }
769 
770     /**
771      * @dev See {IERC721Metadata-tokenURI}.
772      */
773     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
774         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
775 
776         string memory baseURI = _baseURI();
777         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
778     }
779 
780     /**
781      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
782      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
783      * by default, can be overriden in child contracts.
784      */
785     function _baseURI() internal view virtual returns (string memory) {
786         return "";
787     }
788 
789     /**
790      * @dev See {IERC721-approve}.
791      */
792     function approve(address to, uint256 tokenId) public virtual override {
793         address owner = ERC721.ownerOf(tokenId);
794         require(to != owner, "ERC721: approval to current owner");
795 
796         require(
797             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
798             "ERC721: approve caller is not owner nor approved for all"
799         );
800 
801         _approve(to, tokenId);
802     }
803 
804     /**
805      * @dev See {IERC721-getApproved}.
806      */
807     function getApproved(uint256 tokenId) public view virtual override returns (address) {
808         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
809 
810         return _tokenApprovals[tokenId];
811     }
812 
813     /**
814      * @dev See {IERC721-setApprovalForAll}.
815      */
816     function setApprovalForAll(address operator, bool approved) public virtual override {
817         require(operator != _msgSender(), "ERC721: approve to caller");
818 
819         _operatorApprovals[_msgSender()][operator] = approved;
820         emit ApprovalForAll(_msgSender(), operator, approved);
821     }
822 
823     /**
824      * @dev See {IERC721-isApprovedForAll}.
825      */
826     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
827         return _operatorApprovals[owner][operator];
828     }
829 
830     /**
831      * @dev See {IERC721-transferFrom}.
832      */
833     function transferFrom(
834         address from,
835         address to,
836         uint256 tokenId
837     ) public virtual override {
838         //solhint-disable-next-line max-line-length
839         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
840 
841         _transfer(from, to, tokenId);
842     }
843 
844     /**
845      * @dev See {IERC721-safeTransferFrom}.
846      */
847     function safeTransferFrom(
848         address from,
849         address to,
850         uint256 tokenId
851     ) public virtual override {
852         safeTransferFrom(from, to, tokenId, "");
853     }
854 
855     /**
856      * @dev See {IERC721-safeTransferFrom}.
857      */
858     function safeTransferFrom(
859         address from,
860         address to,
861         uint256 tokenId,
862         bytes memory _data
863     ) public virtual override {
864         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
865         _safeTransfer(from, to, tokenId, _data);
866     }
867 
868     /**
869      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
870      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
871      *
872      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
873      *
874      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
875      * implement alternative mechanisms to perform token transfer, such as signature-based.
876      *
877      * Requirements:
878      *
879      * - `from` cannot be the zero address.
880      * - `to` cannot be the zero address.
881      * - `tokenId` token must exist and be owned by `from`.
882      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
883      *
884      * Emits a {Transfer} event.
885      */
886     function _safeTransfer(
887         address from,
888         address to,
889         uint256 tokenId,
890         bytes memory _data
891     ) internal virtual {
892         _transfer(from, to, tokenId);
893         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
894     }
895 
896     /**
897      * @dev Returns whether `tokenId` exists.
898      *
899      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
900      *
901      * Tokens start existing when they are minted (`_mint`),
902      * and stop existing when they are burned (`_burn`).
903      */
904     function _exists(uint256 tokenId) internal view virtual returns (bool) {
905         return _owners[tokenId] != address(0);
906     }
907 
908     /**
909      * @dev Returns whether `spender` is allowed to manage `tokenId`.
910      *
911      * Requirements:
912      *
913      * - `tokenId` must exist.
914      */
915     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
916         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
917         address owner = ERC721.ownerOf(tokenId);
918         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
919     }
920 
921     /**
922      * @dev Safely mints `tokenId` and transfers it to `to`.
923      *
924      * Requirements:
925      *
926      * - `tokenId` must not exist.
927      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
928      *
929      * Emits a {Transfer} event.
930      */
931     function _safeMint(address to, uint256 tokenId) internal virtual {
932         _safeMint(to, tokenId, "");
933     }
934 
935     /**
936      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
937      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
938      */
939     function _safeMint(
940         address to,
941         uint256 tokenId,
942         bytes memory _data
943     ) internal virtual {
944         _mint(to, tokenId);
945         require(
946             _checkOnERC721Received(address(0), to, tokenId, _data),
947             "ERC721: transfer to non ERC721Receiver implementer"
948         );
949     }
950 
951     /**
952      * @dev Mints `tokenId` and transfers it to `to`.
953      *
954      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
955      *
956      * Requirements:
957      *
958      * - `tokenId` must not exist.
959      * - `to` cannot be the zero address.
960      *
961      * Emits a {Transfer} event.
962      */
963     function _mint(address to, uint256 tokenId) internal virtual {
964         require(to != address(0), "ERC721: mint to the zero address");
965         require(!_exists(tokenId), "ERC721: token already minted");
966 
967         _beforeTokenTransfer(address(0), to, tokenId);
968 
969         _balances[to] += 1;
970         _owners[tokenId] = to;
971 
972         emit Transfer(address(0), to, tokenId);
973     }
974 
975     /**
976      * @dev Destroys `tokenId`.
977      * The approval is cleared when the token is burned.
978      *
979      * Requirements:
980      *
981      * - `tokenId` must exist.
982      *
983      * Emits a {Transfer} event.
984      */
985     function _burn(uint256 tokenId) internal virtual {
986         address owner = ERC721.ownerOf(tokenId);
987 
988         _beforeTokenTransfer(owner, address(0), tokenId);
989 
990         // Clear approvals
991         _approve(address(0), tokenId);
992 
993         _balances[owner] -= 1;
994         delete _owners[tokenId];
995 
996         emit Transfer(owner, address(0), tokenId);
997     }
998 
999     /**
1000      * @dev Transfers `tokenId` from `from` to `to`.
1001      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1002      *
1003      * Requirements:
1004      *
1005      * - `to` cannot be the zero address.
1006      * - `tokenId` token must be owned by `from`.
1007      *
1008      * Emits a {Transfer} event.
1009      */
1010     function _transfer(
1011         address from,
1012         address to,
1013         uint256 tokenId
1014     ) internal virtual {
1015         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
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
1057             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1058                 return retval == IERC721Receiver.onERC721Received.selector;
1059             } catch (bytes memory reason) {
1060                 if (reason.length == 0) {
1061                     revert("ERC721: transfer to non ERC721Receiver implementer");
1062                 } else {
1063                     assembly {
1064                         revert(add(32, reason), mload(reason))
1065                     }
1066                 }
1067             }
1068         } else {
1069             return true;
1070         }
1071     }
1072 
1073     /**
1074      * @dev Hook that is called before any token transfer. This includes minting
1075      * and burning.
1076      *
1077      * Calling conditions:
1078      *
1079      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1080      * transferred to `to`.
1081      * - When `from` is zero, `tokenId` will be minted for `to`.
1082      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1083      * - `from` and `to` are never both zero.
1084      *
1085      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1086      */
1087     function _beforeTokenTransfer(
1088         address from,
1089         address to,
1090         uint256 tokenId
1091     ) internal virtual {}
1092 }
1093 
1094 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1095 
1096 
1097 
1098 pragma solidity ^0.8.0;
1099 
1100 
1101 
1102 /**
1103  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1104  * enumerability of all the token ids in the contract as well as all token ids owned by each
1105  * account.
1106  */
1107 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1108     // Mapping from owner to list of owned token IDs
1109     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1110 
1111     // Mapping from token ID to index of the owner tokens list
1112     mapping(uint256 => uint256) private _ownedTokensIndex;
1113 
1114     // Array with all token ids, used for enumeration
1115     uint256[] private _allTokens;
1116 
1117     // Mapping from token id to position in the allTokens array
1118     mapping(uint256 => uint256) private _allTokensIndex;
1119 
1120     /**
1121      * @dev See {IERC165-supportsInterface}.
1122      */
1123     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1124         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1125     }
1126 
1127     /**
1128      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1129      */
1130     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1131         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1132         return _ownedTokens[owner][index];
1133     }
1134 
1135     /**
1136      * @dev See {IERC721Enumerable-totalSupply}.
1137      */
1138     function totalSupply() public view virtual override returns (uint256) {
1139         return _allTokens.length;
1140     }
1141 
1142     /**
1143      * @dev See {IERC721Enumerable-tokenByIndex}.
1144      */
1145     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1146         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1147         return _allTokens[index];
1148     }
1149 
1150     /**
1151      * @dev Hook that is called before any token transfer. This includes minting
1152      * and burning.
1153      *
1154      * Calling conditions:
1155      *
1156      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1157      * transferred to `to`.
1158      * - When `from` is zero, `tokenId` will be minted for `to`.
1159      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1160      * - `from` cannot be the zero address.
1161      * - `to` cannot be the zero address.
1162      *
1163      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1164      */
1165     function _beforeTokenTransfer(
1166         address from,
1167         address to,
1168         uint256 tokenId
1169     ) internal virtual override {
1170         super._beforeTokenTransfer(from, to, tokenId);
1171 
1172         if (from == address(0)) {
1173             _addTokenToAllTokensEnumeration(tokenId);
1174         } else if (from != to) {
1175             _removeTokenFromOwnerEnumeration(from, tokenId);
1176         }
1177         if (to == address(0)) {
1178             _removeTokenFromAllTokensEnumeration(tokenId);
1179         } else if (to != from) {
1180             _addTokenToOwnerEnumeration(to, tokenId);
1181         }
1182     }
1183 
1184     /**
1185      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1186      * @param to address representing the new owner of the given token ID
1187      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1188      */
1189     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1190         uint256 length = ERC721.balanceOf(to);
1191         _ownedTokens[to][length] = tokenId;
1192         _ownedTokensIndex[tokenId] = length;
1193     }
1194 
1195     /**
1196      * @dev Private function to add a token to this extension's token tracking data structures.
1197      * @param tokenId uint256 ID of the token to be added to the tokens list
1198      */
1199     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1200         _allTokensIndex[tokenId] = _allTokens.length;
1201         _allTokens.push(tokenId);
1202     }
1203 
1204     /**
1205      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1206      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1207      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1208      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1209      * @param from address representing the previous owner of the given token ID
1210      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1211      */
1212     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1213         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1214         // then delete the last slot (swap and pop).
1215 
1216         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1217         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1218 
1219         // When the token to delete is the last token, the swap operation is unnecessary
1220         if (tokenIndex != lastTokenIndex) {
1221             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1222 
1223             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1224             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1225         }
1226 
1227         // This also deletes the contents at the last position of the array
1228         delete _ownedTokensIndex[tokenId];
1229         delete _ownedTokens[from][lastTokenIndex];
1230     }
1231 
1232     /**
1233      * @dev Private function to remove a token from this extension's token tracking data structures.
1234      * This has O(1) time complexity, but alters the order of the _allTokens array.
1235      * @param tokenId uint256 ID of the token to be removed from the tokens list
1236      */
1237     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1238         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1239         // then delete the last slot (swap and pop).
1240 
1241         uint256 lastTokenIndex = _allTokens.length - 1;
1242         uint256 tokenIndex = _allTokensIndex[tokenId];
1243 
1244         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1245         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1246         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1247         uint256 lastTokenId = _allTokens[lastTokenIndex];
1248 
1249         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1250         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1251 
1252         // This also deletes the contents at the last position of the array
1253         delete _allTokensIndex[tokenId];
1254         _allTokens.pop();
1255     }
1256 }
1257 
1258 // File: contracts/zombiemice.sol
1259 
1260 
1261 pragma solidity ^0.8.0;
1262 
1263 // contract inheritance
1264 
1265 
1266 
1267 
1268 interface ICheeth {
1269     function getStaker(uint256 tokenId) external returns (address);
1270 }
1271 
1272 contract ZombieMice is ERC721Enumerable, Ownable {
1273     address public anonymiceAddress = 0xbad6186E92002E312078b5a1dAfd5ddf63d3f731;
1274     address public cheethAddress = 0x5f7BA84c7984Aa5ef329B66E313498F0aEd6d23A;
1275     uint public maxTokens = 6450;
1276     uint public mintingCost = 0.02 ether;
1277     string private baseTokenURI;
1278 
1279     uint public miceClaimed = 0;
1280     uint public maxMiceClaimed = 3550;
1281 
1282     uint public normalMinted = 0;
1283     uint public maxNormalMinted = 2900;
1284     uint public maxMintPerTx = 10;
1285 
1286     mapping(uint => uint) miceUsedToClaim;
1287     
1288     event Mint(address to, uint tokenId);
1289     event MintWithMice(address to, uint tokenId);
1290 
1291     constructor() ERC721("Zombiemice", "ZMICE") {}
1292 
1293     // modifiers
1294     bool claimIsEnabled;
1295 
1296     modifier claimEnabled {
1297         require(claimIsEnabled);
1298         _;
1299     }
1300     
1301     modifier onlySender() {
1302         require(msg.sender == tx.origin);
1303         _;
1304     }
1305 
1306     // owner functions
1307     function setClaimStatus(bool bool_) external onlyOwner {
1308         claimIsEnabled = bool_;
1309     }
1310     
1311     function setClaimedMiceToMintable() external onlyOwner {
1312         maxNormalMinted = maxNormalMinted + (maxMiceClaimed - miceClaimed);
1313     }
1314     
1315     function withdrawEther() external onlyOwner {
1316         payable(msg.sender).transfer(address(this).balance);
1317     }
1318     
1319     function setBaseTokenURI(string memory uri_) external onlyOwner {
1320         baseTokenURI = uri_;
1321     }
1322 
1323     // functions
1324     function mintWithStakedMice(uint tokenId_) external onlySender claimEnabled {
1325         require(msg.sender == ICheeth(cheethAddress).getStaker(tokenId_), "You are not the staker!");
1326         require(miceUsedToClaim[tokenId_] == 0, "Mice already used to claim!");
1327         require(miceClaimed + 1 <= maxMiceClaimed, "No more claimable mice!");
1328 
1329         uint _mintId = totalSupply();
1330         miceUsedToClaim[tokenId_]++;
1331         miceClaimed++;
1332 
1333         _mint(msg.sender, _mintId);
1334         emit MintWithMice(msg.sender, _mintId);
1335     }
1336     
1337     function mintWithMice(uint tokenId_) external onlySender claimEnabled {
1338         require(msg.sender == IERC721(anonymiceAddress).ownerOf(tokenId_), "You are not the owner!");
1339         require(miceUsedToClaim[tokenId_] == 0, "Mice already used to claim!");
1340         require(miceClaimed + 1 <= maxMiceClaimed, "No more claimable mice!");
1341 
1342         uint _mintId = totalSupply();
1343         miceUsedToClaim[tokenId_]++;
1344         miceClaimed++;
1345 
1346         _mint(msg.sender, _mintId);
1347         emit MintWithMice(msg.sender, _mintId);
1348     }
1349     
1350     function mint(uint amount_) payable external onlySender {
1351         require(amount_ <= maxMintPerTx, "Over Maximum Mints per TX!");
1352         require(msg.value == (mintingCost * amount_), "Invalid value!");
1353         require(normalMinted + amount_ <= maxNormalMinted, "No more mintable mice!");
1354 
1355         uint _startMintId = totalSupply();
1356         normalMinted = normalMinted + amount_;
1357 
1358         // this mints the amount of tokens
1359         for (uint i = 0; i < amount_; i++) {
1360             uint _mintId = _startMintId + i;
1361             _mint(msg.sender, _mintId);
1362             emit Mint(msg.sender, _mintId);
1363         }
1364     }
1365 
1366     // view functions
1367     function tokenURI(uint tokenId_) public view override returns (string memory) {
1368         return string(abi.encodePacked(baseTokenURI, Strings.toString(tokenId_)));
1369     }
1370 }