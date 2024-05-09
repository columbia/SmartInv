1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
3 
4 
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
30 
31 
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Required interface of an ERC721 compliant contract.
38  */
39 interface IERC721 is IERC165 {
40     /**
41      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
42      */
43     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
44 
45     /**
46      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
47      */
48     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
49 
50     /**
51      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
52      */
53     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
54 
55     /**
56      * @dev Returns the number of tokens in ``owner``'s account.
57      */
58     function balanceOf(address owner) external view returns (uint256 balance);
59 
60     /**
61      * @dev Returns the owner of the `tokenId` token.
62      *
63      * Requirements:
64      *
65      * - `tokenId` must exist.
66      */
67     function ownerOf(uint256 tokenId) external view returns (address owner);
68 
69     /**
70      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
71      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
72      *
73      * Requirements:
74      *
75      * - `from` cannot be the zero address.
76      * - `to` cannot be the zero address.
77      * - `tokenId` token must exist and be owned by `from`.
78      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
79      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
80      *
81      * Emits a {Transfer} event.
82      */
83     function safeTransferFrom(
84         address from,
85         address to,
86         uint256 tokenId
87     ) external;
88 
89     /**
90      * @dev Transfers `tokenId` token from `from` to `to`.
91      *
92      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
93      *
94      * Requirements:
95      *
96      * - `from` cannot be the zero address.
97      * - `to` cannot be the zero address.
98      * - `tokenId` token must be owned by `from`.
99      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
100      *
101      * Emits a {Transfer} event.
102      */
103     function transferFrom(
104         address from,
105         address to,
106         uint256 tokenId
107     ) external;
108 
109     /**
110      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
111      * The approval is cleared when the token is transferred.
112      *
113      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
114      *
115      * Requirements:
116      *
117      * - The caller must own the token or be an approved operator.
118      * - `tokenId` must exist.
119      *
120      * Emits an {Approval} event.
121      */
122     function approve(address to, uint256 tokenId) external;
123 
124     /**
125      * @dev Returns the account approved for `tokenId` token.
126      *
127      * Requirements:
128      *
129      * - `tokenId` must exist.
130      */
131     function getApproved(uint256 tokenId) external view returns (address operator);
132 
133     /**
134      * @dev Approve or remove `operator` as an operator for the caller.
135      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
136      *
137      * Requirements:
138      *
139      * - The `operator` cannot be the caller.
140      *
141      * Emits an {ApprovalForAll} event.
142      */
143     function setApprovalForAll(address operator, bool _approved) external;
144 
145     /**
146      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
147      *
148      * See {setApprovalForAll}
149      */
150     function isApprovedForAll(address owner, address operator) external view returns (bool);
151 
152     /**
153      * @dev Safely transfers `tokenId` token from `from` to `to`.
154      *
155      * Requirements:
156      *
157      * - `from` cannot be the zero address.
158      * - `to` cannot be the zero address.
159      * - `tokenId` token must exist and be owned by `from`.
160      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
161      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
162      *
163      * Emits a {Transfer} event.
164      */
165     function safeTransferFrom(
166         address from,
167         address to,
168         uint256 tokenId,
169         bytes calldata data
170     ) external;
171 }
172 
173 
174 // File: @openzeppelin/contracts/utils/Context.sol
175 
176 
177 
178 pragma solidity ^0.8.0;
179 
180 /**
181  * @dev Provides information about the current execution context, including the
182  * sender of the transaction and its data. While these are generally available
183  * via msg.sender and msg.data, they should not be accessed in such a direct
184  * manner, since when dealing with meta-transactions the account sending and
185  * paying for execution may not be the actual sender (as far as an application
186  * is concerned).
187  *
188  * This contract is only required for intermediate, library-like contracts.
189  */
190 abstract contract Context {
191     function _msgSender() internal view virtual returns (address) {
192         return msg.sender;
193     }
194 
195     function _msgData() internal view virtual returns (bytes calldata) {
196         return msg.data;
197     }
198 }
199 
200 // File: @openzeppelin/contracts/access/Ownable.sol
201 
202 
203 
204 pragma solidity ^0.8.0;
205 
206 
207 /**
208  * @dev Contract module which provides a basic access control mechanism, where
209  * there is an account (an owner) that can be granted exclusive access to
210  * specific functions.
211  *
212  * By default, the owner account will be the one that deploys the contract. This
213  * can later be changed with {transferOwnership}.
214  *
215  * This module is used through inheritance. It will make available the modifier
216  * `onlyOwner`, which can be applied to your functions to restrict their use to
217  * the owner.
218  */
219 abstract contract Ownable is Context {
220     address private _owner;
221 
222     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
223 
224     /**
225      * @dev Initializes the contract setting the deployer as the initial owner.
226      */
227     constructor() {
228         _setOwner(_msgSender());
229     }
230 
231     /**
232      * @dev Returns the address of the current owner.
233      */
234     function owner() public view virtual returns (address) {
235         return _owner;
236     }
237 
238     /**
239      * @dev Throws if called by any account other than the owner.
240      */
241     modifier onlyOwner() {
242         require(owner() == _msgSender(), "Ownable: caller is not the owner");
243         _;
244     }
245 
246     /**
247      * @dev Leaves the contract without owner. It will not be possible to call
248      * `onlyOwner` functions anymore. Can only be called by the current owner.
249      *
250      * NOTE: Renouncing ownership will leave the contract without an owner,
251      * thereby removing any functionality that is only available to the owner.
252      */
253     function renounceOwnership() public virtual onlyOwner {
254         _setOwner(address(0));
255     }
256 
257     /**
258      * @dev Transfers ownership of the contract to a new account (`newOwner`).
259      * Can only be called by the current owner.
260      */
261     function transferOwnership(address newOwner) public virtual onlyOwner {
262         require(newOwner != address(0), "Ownable: new owner is the zero address");
263         _setOwner(newOwner);
264     }
265 
266     function _setOwner(address newOwner) private {
267         address oldOwner = _owner;
268         _owner = newOwner;
269         emit OwnershipTransferred(oldOwner, newOwner);
270     }
271 }
272 
273 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
274 
275 
276 
277 pragma solidity ^0.8.0;
278 
279 
280 /**
281  * @dev Implementation of the {IERC165} interface.
282  *
283  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
284  * for the additional interface id that will be supported. For example:
285  *
286  * ```solidity
287  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
288  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
289  * }
290  * ```
291  *
292  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
293  */
294 abstract contract ERC165 is IERC165 {
295     /**
296      * @dev See {IERC165-supportsInterface}.
297      */
298     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
299         return interfaceId == type(IERC165).interfaceId;
300     }
301 }
302 
303 // File: @openzeppelin/contracts/utils/Strings.sol
304 
305 
306 
307 pragma solidity ^0.8.0;
308 
309 /**
310  * @dev String operations.
311  */
312 library Strings {
313     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
314 
315     /**
316      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
317      */
318     function toString(uint256 value) internal pure returns (string memory) {
319         // Inspired by OraclizeAPI's implementation - MIT licence
320         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
321 
322         if (value == 0) {
323             return "0";
324         }
325         uint256 temp = value;
326         uint256 digits;
327         while (temp != 0) {
328             digits++;
329             temp /= 10;
330         }
331         bytes memory buffer = new bytes(digits);
332         while (value != 0) {
333             digits -= 1;
334             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
335             value /= 10;
336         }
337         return string(buffer);
338     }
339 
340     /**
341      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
342      */
343     function toHexString(uint256 value) internal pure returns (string memory) {
344         if (value == 0) {
345             return "0x00";
346         }
347         uint256 temp = value;
348         uint256 length = 0;
349         while (temp != 0) {
350             length++;
351             temp >>= 8;
352         }
353         return toHexString(value, length);
354     }
355 
356     /**
357      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
358      */
359     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
360         bytes memory buffer = new bytes(2 * length + 2);
361         buffer[0] = "0";
362         buffer[1] = "x";
363         for (uint256 i = 2 * length + 1; i > 1; --i) {
364             buffer[i] = _HEX_SYMBOLS[value & 0xf];
365             value >>= 4;
366         }
367         require(value == 0, "Strings: hex length insufficient");
368         return string(buffer);
369     }
370 }
371 
372 
373 
374 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
375 
376 
377 
378 pragma solidity ^0.8.0;
379 
380 
381 /**
382  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
383  * @dev See https://eips.ethereum.org/EIPS/eip-721
384  */
385 interface IERC721Enumerable is IERC721 {
386     /**
387      * @dev Returns the total amount of tokens stored by the contract.
388      */
389     function totalSupply() external view returns (uint256);
390 
391     /**
392      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
393      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
394      */
395     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
396 
397     /**
398      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
399      * Use along with {totalSupply} to enumerate all tokens.
400      */
401     function tokenByIndex(uint256 index) external view returns (uint256);
402 }
403 
404 
405 // File: @openzeppelin/contracts/utils/Address.sol
406 
407 
408 
409 pragma solidity ^0.8.0;
410 
411 /**
412  * @dev Collection of functions related to the address type
413  */
414 library Address {
415     /**
416      * @dev Returns true if `account` is a contract.
417      *
418      * [IMPORTANT]
419      * ====
420      * It is unsafe to assume that an address for which this function returns
421      * false is an externally-owned account (EOA) and not a contract.
422      *
423      * Among others, `isContract` will return false for the following
424      * types of addresses:
425      *
426      *  - an externally-owned account
427      *  - a contract in construction
428      *  - an address where a contract will be created
429      *  - an address where a contract lived, but was destroyed
430      * ====
431      */
432     function isContract(address account) internal view returns (bool) {
433         // This method relies on extcodesize, which returns 0 for contracts in
434         // construction, since the code is only stored at the end of the
435         // constructor execution.
436 
437         uint256 size;
438         assembly {
439             size := extcodesize(account)
440         }
441         return size > 0;
442     }
443 
444     /**
445      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
446      * `recipient`, forwarding all available gas and reverting on errors.
447      *
448      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
449      * of certain opcodes, possibly making contracts go over the 2300 gas limit
450      * imposed by `transfer`, making them unable to receive funds via
451      * `transfer`. {sendValue} removes this limitation.
452      *
453      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
454      *
455      * IMPORTANT: because control is transferred to `recipient`, care must be
456      * taken to not create reentrancy vulnerabilities. Consider using
457      * {ReentrancyGuard} or the
458      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
459      */
460     function sendValue(address payable recipient, uint256 amount) internal {
461         require(address(this).balance >= amount, "Address: insufficient balance");
462 
463         (bool success, ) = recipient.call{value: amount}("");
464         require(success, "Address: unable to send value, recipient may have reverted");
465     }
466 
467     /**
468      * @dev Performs a Solidity function call using a low level `call`. A
469      * plain `call` is an unsafe replacement for a function call: use this
470      * function instead.
471      *
472      * If `target` reverts with a revert reason, it is bubbled up by this
473      * function (like regular Solidity function calls).
474      *
475      * Returns the raw returned data. To convert to the expected return value,
476      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
477      *
478      * Requirements:
479      *
480      * - `target` must be a contract.
481      * - calling `target` with `data` must not revert.
482      *
483      * _Available since v3.1._
484      */
485     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
486         return functionCall(target, data, "Address: low-level call failed");
487     }
488 
489     /**
490      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
491      * `errorMessage` as a fallback revert reason when `target` reverts.
492      *
493      * _Available since v3.1._
494      */
495     function functionCall(
496         address target,
497         bytes memory data,
498         string memory errorMessage
499     ) internal returns (bytes memory) {
500         return functionCallWithValue(target, data, 0, errorMessage);
501     }
502 
503     /**
504      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
505      * but also transferring `value` wei to `target`.
506      *
507      * Requirements:
508      *
509      * - the calling contract must have an ETH balance of at least `value`.
510      * - the called Solidity function must be `payable`.
511      *
512      * _Available since v3.1._
513      */
514     function functionCallWithValue(
515         address target,
516         bytes memory data,
517         uint256 value
518     ) internal returns (bytes memory) {
519         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
520     }
521 
522     /**
523      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
524      * with `errorMessage` as a fallback revert reason when `target` reverts.
525      *
526      * _Available since v3.1._
527      */
528     function functionCallWithValue(
529         address target,
530         bytes memory data,
531         uint256 value,
532         string memory errorMessage
533     ) internal returns (bytes memory) {
534         require(address(this).balance >= value, "Address: insufficient balance for call");
535         require(isContract(target), "Address: call to non-contract");
536 
537         (bool success, bytes memory returndata) = target.call{value: value}(data);
538         return verifyCallResult(success, returndata, errorMessage);
539     }
540 
541     /**
542      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
543      * but performing a static call.
544      *
545      * _Available since v3.3._
546      */
547     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
548         return functionStaticCall(target, data, "Address: low-level static call failed");
549     }
550 
551     /**
552      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
553      * but performing a static call.
554      *
555      * _Available since v3.3._
556      */
557     function functionStaticCall(
558         address target,
559         bytes memory data,
560         string memory errorMessage
561     ) internal view returns (bytes memory) {
562         require(isContract(target), "Address: static call to non-contract");
563 
564         (bool success, bytes memory returndata) = target.staticcall(data);
565         return verifyCallResult(success, returndata, errorMessage);
566     }
567 
568     /**
569      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
570      * but performing a delegate call.
571      *
572      * _Available since v3.4._
573      */
574     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
575         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
576     }
577 
578     /**
579      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
580      * but performing a delegate call.
581      *
582      * _Available since v3.4._
583      */
584     function functionDelegateCall(
585         address target,
586         bytes memory data,
587         string memory errorMessage
588     ) internal returns (bytes memory) {
589         require(isContract(target), "Address: delegate call to non-contract");
590 
591         (bool success, bytes memory returndata) = target.delegatecall(data);
592         return verifyCallResult(success, returndata, errorMessage);
593     }
594 
595     /**
596      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
597      * revert reason using the provided one.
598      *
599      * _Available since v4.3._
600      */
601     function verifyCallResult(
602         bool success,
603         bytes memory returndata,
604         string memory errorMessage
605     ) internal pure returns (bytes memory) {
606         if (success) {
607             return returndata;
608         } else {
609             // Look for revert reason and bubble it up if present
610             if (returndata.length > 0) {
611                 // The easiest way to bubble the revert reason is using memory via assembly
612 
613                 assembly {
614                     let returndata_size := mload(returndata)
615                     revert(add(32, returndata), returndata_size)
616                 }
617             } else {
618                 revert(errorMessage);
619             }
620         }
621     }
622 }
623 
624 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
625 
626 
627 
628 pragma solidity ^0.8.0;
629 
630 
631 /**
632  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
633  * @dev See https://eips.ethereum.org/EIPS/eip-721
634  */
635 interface IERC721Metadata is IERC721 {
636     /**
637      * @dev Returns the token collection name.
638      */
639     function name() external view returns (string memory);
640 
641     /**
642      * @dev Returns the token collection symbol.
643      */
644     function symbol() external view returns (string memory);
645 
646     /**
647      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
648      */
649     function tokenURI(uint256 tokenId) external view returns (string memory);
650 }
651 
652 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
653 
654 
655 
656 pragma solidity ^0.8.0;
657 
658 /**
659  * @title ERC721 token receiver interface
660  * @dev Interface for any contract that wants to support safeTransfers
661  * from ERC721 asset contracts.
662  */
663 interface IERC721Receiver {
664     /**
665      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
666      * by `operator` from `from`, this function is called.
667      *
668      * It must return its Solidity selector to confirm the token transfer.
669      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
670      *
671      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
672      */
673     function onERC721Received(
674         address operator,
675         address from,
676         uint256 tokenId,
677         bytes calldata data
678     ) external returns (bytes4);
679 }
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
734         interfaceId == type(IERC721).interfaceId ||
735         interfaceId == type(IERC721Metadata).interfaceId ||
736         super.supportsInterface(interfaceId);
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
1258 // File: contracts/arcapol.sol
1259 
1260 
1261 pragma solidity ^0.8.0;
1262 
1263 
1264 
1265 contract StonedApeSaturnClub is ERC721Enumerable, Ownable {
1266     using Strings for uint256;
1267 
1268     address public _t1 = 0xd230f390AbB50470fa265a022d673c6147BDc396;
1269     address public _t2 = 0xbc15b4665633eC65925040fAb61D0fC1C4eeFAaB;
1270     address public _t3 = 0x5F55Cd7A509fdA9F0beB9309A49a689EB8C122EE;
1271     address public _t4 = 0x5F55Cd7A509fdA9F0beB9309A49a689EB8C122EE;
1272     address public _t5 = 0x9CED6C82326c7Dbc222dd17B6573E69cfE3983f2;
1273     address public _t6 = 0x630A035Be662260Db9Fe33cD58aFD71f7e8F4fa3;
1274     address public _t7 = 0x335B108025D6F6cAf4f98357baaa6Dfde715406C;
1275     address public _t8 = 0x872b7b86BA6F64E724CfB8788410cB3042F564FA;
1276 
1277     bool public _active = false;
1278     string public _baseTokenURI;
1279     uint256 public _gifts = 145;
1280     uint256 public _price = 0.024 ether;
1281     uint256 public _supply = 6969;
1282 
1283     constructor(string memory baseURI) ERC721("Stoned Ape Saturn Club", "SASC") {
1284         setBaseURI(baseURI);
1285         _safeMint( _t3, 0 );
1286         _safeMint( _t2, 1 );
1287         _safeMint( _t5, 2 );
1288         _safeMint( _t7, 3 );
1289         _safeMint( _t1, 4 );
1290 
1291     }
1292 
1293     function setActive(bool active) public onlyOwner {
1294         _active = active;
1295     }
1296 
1297     function setBaseURI(string memory baseURI) public onlyOwner {
1298         _baseTokenURI = baseURI;
1299     }
1300 
1301     function setPrice(uint256 price) public onlyOwner {
1302         _price = price;
1303     }
1304 
1305     function _baseURI() internal view virtual override returns (string memory) {
1306         return _baseTokenURI;
1307     }
1308 
1309     function gift(address _to, uint256 _amount) external onlyOwner {
1310         require(_amount <= _gifts, "Gift reserve exceeded with provided amount.");
1311 
1312         uint256 supply = totalSupply();
1313 
1314         for(uint256 i; i < _amount; i++){
1315             _safeMint( _to, supply + i );
1316         }
1317 
1318         _gifts -= _amount;
1319     }
1320 
1321     function mint(uint256 _amount) public payable {
1322         uint256 supply = totalSupply();
1323 
1324         require( _active, "Sale is not active.");
1325         require( _amount < 10, "Provided amount exceeds mint limit.");
1326         require( msg.value >= _price * _amount, "Insufficient ether provided.");
1327         require( supply + _amount <= _supply - _gifts, "Supply exceeded with provided amount.");
1328 
1329         for(uint256 i; i < _amount; i++){
1330             _safeMint( msg.sender, supply + i );
1331         }
1332     }
1333 
1334     function withdraw() public payable onlyOwner {
1335         uint256 _p1 = address(this).balance / 10;
1336         uint256 _p2 = address(this).balance * 2 / 25;
1337         uint256 _p3 = address(this).balance * 2 / 25;
1338         uint256 _p4 = address(this).balance * 11 / 100;
1339         uint256 _p5 = address(this).balance * 11 / 100;
1340         uint256 _p6 = address(this).balance * 11 / 100;
1341         uint256 _p7 = address(this).balance * 11 / 100;
1342         uint256 _p8 = address(this).balance * 3 / 10;
1343 
1344         require(payable(_t1).send(_p1));
1345         require(payable(_t2).send(_p2));
1346         require(payable(_t3).send(_p3));
1347         require(payable(_t4).send(_p4));
1348         require(payable(_t5).send(_p5));
1349         require(payable(_t6).send(_p6));
1350         require(payable(_t7).send(_p7));
1351         require(payable(_t8).send(_p8));
1352     }
1353 }