1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Context.sol
4 
5 
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 // File: @openzeppelin/contracts/access/Ownable.sol
30 
31 pragma solidity ^0.8.0;
32 
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor() {
55         _setOwner(_msgSender());
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view virtual returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(owner() == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         _setOwner(address(0));
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Can only be called by the current owner.
87      */
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         _setOwner(newOwner);
91     }
92 
93     function _setOwner(address newOwner) private {
94         address oldOwner = _owner;
95         _owner = newOwner;
96         emit OwnershipTransferred(oldOwner, newOwner);
97     }
98 }
99 
100 
101 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
102 
103 
104 
105 pragma solidity ^0.8.0;
106 
107 /**
108  * @dev Interface of the ERC165 standard, as defined in the
109  * https://eips.ethereum.org/EIPS/eip-165[EIP].
110  *
111  * Implementers can declare support of contract interfaces, which can then be
112  * queried by others ({ERC165Checker}).
113  *
114  * For an implementation, see {ERC165}.
115  */
116 interface IERC165 {
117     /**
118      * @dev Returns true if this contract implements the interface defined by
119      * `interfaceId`. See the corresponding
120      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
121      * to learn more about how these ids are created.
122      *
123      * This function call must use less than 30 000 gas.
124      */
125     function supportsInterface(bytes4 interfaceId) external view returns (bool);
126 }
127 
128 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
129 
130 
131 
132 pragma solidity ^0.8.0;
133 
134 
135 /**
136  * @dev Required interface of an ERC721 compliant contract.
137  */
138 interface IERC721 is IERC165 {
139     /**
140      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
141      */
142     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
143 
144     /**
145      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
146      */
147     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
148 
149     /**
150      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
151      */
152     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
153 
154     /**
155      * @dev Returns the number of tokens in ``owner``'s account.
156      */
157     function balanceOf(address owner) external view returns (uint256 balance);
158 
159     /**
160      * @dev Returns the owner of the `tokenId` token.
161      *
162      * Requirements:
163      *
164      * - `tokenId` must exist.
165      */
166     function ownerOf(uint256 tokenId) external view returns (address owner);
167 
168     /**
169      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
170      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
171      *
172      * Requirements:
173      *
174      * - `from` cannot be the zero address.
175      * - `to` cannot be the zero address.
176      * - `tokenId` token must exist and be owned by `from`.
177      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
178      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
179      *
180      * Emits a {Transfer} event.
181      */
182     function safeTransferFrom(
183         address from,
184         address to,
185         uint256 tokenId
186     ) external;
187 
188     /**
189      * @dev Transfers `tokenId` token from `from` to `to`.
190      *
191      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
192      *
193      * Requirements:
194      *
195      * - `from` cannot be the zero address.
196      * - `to` cannot be the zero address.
197      * - `tokenId` token must be owned by `from`.
198      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
199      *
200      * Emits a {Transfer} event.
201      */
202     function transferFrom(
203         address from,
204         address to,
205         uint256 tokenId
206     ) external;
207 
208     /**
209      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
210      * The approval is cleared when the token is transferred.
211      *
212      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
213      *
214      * Requirements:
215      *
216      * - The caller must own the token or be an approved operator.
217      * - `tokenId` must exist.
218      *
219      * Emits an {Approval} event.
220      */
221     function approve(address to, uint256 tokenId) external;
222 
223     /**
224      * @dev Returns the account approved for `tokenId` token.
225      *
226      * Requirements:
227      *
228      * - `tokenId` must exist.
229      */
230     function getApproved(uint256 tokenId) external view returns (address operator);
231 
232     /**
233      * @dev Approve or remove `operator` as an operator for the caller.
234      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
235      *
236      * Requirements:
237      *
238      * - The `operator` cannot be the caller.
239      *
240      * Emits an {ApprovalForAll} event.
241      */
242     function setApprovalForAll(address operator, bool _approved) external;
243 
244     /**
245      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
246      *
247      * See {setApprovalForAll}
248      */
249     function isApprovedForAll(address owner, address operator) external view returns (bool);
250 
251     /**
252      * @dev Safely transfers `tokenId` token from `from` to `to`.
253      *
254      * Requirements:
255      *
256      * - `from` cannot be the zero address.
257      * - `to` cannot be the zero address.
258      * - `tokenId` token must exist and be owned by `from`.
259      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
260      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
261      *
262      * Emits a {Transfer} event.
263      */
264     function safeTransferFrom(
265         address from,
266         address to,
267         uint256 tokenId,
268         bytes calldata data
269     ) external;
270 }
271 
272 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
273 
274 
275 
276 pragma solidity ^0.8.0;
277 
278 
279 /**
280  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
281  * @dev See https://eips.ethereum.org/EIPS/eip-721
282  */
283 interface IERC721Enumerable is IERC721 {
284     /**
285      * @dev Returns the total amount of tokens stored by the contract.
286      */
287     function totalSupply() external view returns (uint256);
288 
289     /**
290      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
291      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
292      */
293     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
294 
295     /**
296      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
297      * Use along with {totalSupply} to enumerate all tokens.
298      */
299     function tokenByIndex(uint256 index) external view returns (uint256);
300 }
301 
302 
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
681 
682 
683 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
684 
685 
686 
687 pragma solidity ^0.8.0;
688 
689 
690 
691 
692 
693 
694 
695 
696 /**
697  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
698  * the Metadata extension, but not including the Enumerable extension, which is available separately as
699  * {ERC721Enumerable}.
700  */
701 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
702     using Address for address;
703     using Strings for uint256;
704 
705     // Token name
706     string private _name;
707 
708     // Token symbol
709     string private _symbol;
710 
711     // Mapping from token ID to owner address
712     mapping(uint256 => address) private _owners;
713 
714     // Mapping owner address to token count
715     mapping(address => uint256) private _balances;
716 
717     // Mapping from token ID to approved address
718     mapping(uint256 => address) private _tokenApprovals;
719 
720     // Mapping from owner to operator approvals
721     mapping(address => mapping(address => bool)) private _operatorApprovals;
722 
723     /**
724      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
725      */
726     constructor(string memory name_, string memory symbol_) {
727         _name = name_;
728         _symbol = symbol_;
729     }
730 
731     /**
732      * @dev See {IERC165-supportsInterface}.
733      */
734     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
735         return
736             interfaceId == type(IERC721).interfaceId ||
737             interfaceId == type(IERC721Metadata).interfaceId ||
738             super.supportsInterface(interfaceId);
739     }
740 
741     /**
742      * @dev See {IERC721-balanceOf}.
743      */
744     function balanceOf(address owner) public view virtual override returns (uint256) {
745         require(owner != address(0), "ERC721: balance query for the zero address");
746         return _balances[owner];
747     }
748 
749     /**
750      * @dev See {IERC721-ownerOf}.
751      */
752     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
753         address owner = _owners[tokenId];
754         require(owner != address(0), "ERC721: owner query for nonexistent token");
755         return owner;
756     }
757 
758     /**
759      * @dev See {IERC721Metadata-name}.
760      */
761     function name() public view virtual override returns (string memory) {
762         return _name;
763     }
764 
765     /**
766      * @dev See {IERC721Metadata-symbol}.
767      */
768     function symbol() public view virtual override returns (string memory) {
769         return _symbol;
770     }
771 
772     /**
773      * @dev See {IERC721Metadata-tokenURI}.
774      */
775     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
776         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
777 
778         string memory baseURI = _baseURI();
779         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
780     }
781 
782     /**
783      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
784      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
785      * by default, can be overriden in child contracts.
786      */
787     function _baseURI() internal view virtual returns (string memory) {
788         return "";
789     }
790 
791     /**
792      * @dev See {IERC721-approve}.
793      */
794     function approve(address to, uint256 tokenId) public virtual override {
795         address owner = ERC721.ownerOf(tokenId);
796         require(to != owner, "ERC721: approval to current owner");
797 
798         require(
799             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
800             "ERC721: approve caller is not owner nor approved for all"
801         );
802 
803         _approve(to, tokenId);
804     }
805 
806     /**
807      * @dev See {IERC721-getApproved}.
808      */
809     function getApproved(uint256 tokenId) public view virtual override returns (address) {
810         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
811 
812         return _tokenApprovals[tokenId];
813     }
814 
815     /**
816      * @dev See {IERC721-setApprovalForAll}.
817      */
818     function setApprovalForAll(address operator, bool approved) public virtual override {
819         require(operator != _msgSender(), "ERC721: approve to caller");
820 
821         _operatorApprovals[_msgSender()][operator] = approved;
822         emit ApprovalForAll(_msgSender(), operator, approved);
823     }
824 
825     /**
826      * @dev See {IERC721-isApprovedForAll}.
827      */
828     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
829         return _operatorApprovals[owner][operator];
830     }
831 
832     /**
833      * @dev See {IERC721-transferFrom}.
834      */
835     function transferFrom(
836         address from,
837         address to,
838         uint256 tokenId
839     ) public virtual override {
840         //solhint-disable-next-line max-line-length
841         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
842 
843         _transfer(from, to, tokenId);
844     }
845 
846     /**
847      * @dev See {IERC721-safeTransferFrom}.
848      */
849     function safeTransferFrom(
850         address from,
851         address to,
852         uint256 tokenId
853     ) public virtual override {
854         safeTransferFrom(from, to, tokenId, "");
855     }
856 
857     /**
858      * @dev See {IERC721-safeTransferFrom}.
859      */
860     function safeTransferFrom(
861         address from,
862         address to,
863         uint256 tokenId,
864         bytes memory _data
865     ) public virtual override {
866         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
867         _safeTransfer(from, to, tokenId, _data);
868     }
869 
870     /**
871      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
872      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
873      *
874      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
875      *
876      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
877      * implement alternative mechanisms to perform token transfer, such as signature-based.
878      *
879      * Requirements:
880      *
881      * - `from` cannot be the zero address.
882      * - `to` cannot be the zero address.
883      * - `tokenId` token must exist and be owned by `from`.
884      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
885      *
886      * Emits a {Transfer} event.
887      */
888     function _safeTransfer(
889         address from,
890         address to,
891         uint256 tokenId,
892         bytes memory _data
893     ) internal virtual {
894         _transfer(from, to, tokenId);
895         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
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
917     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
918         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
919         address owner = ERC721.ownerOf(tokenId);
920         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
921     }
922 
923     /**
924      * @dev Safely mints `tokenId` and transfers it to `to`.
925      *
926      * Requirements:
927      *
928      * - `tokenId` must not exist.
929      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
930      *
931      * Emits a {Transfer} event.
932      */
933     function _safeMint(address to, uint256 tokenId) internal virtual {
934         _safeMint(to, tokenId, "");
935     }
936 
937     /**
938      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
939      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
940      */
941     function _safeMint(
942         address to,
943         uint256 tokenId,
944         bytes memory _data
945     ) internal virtual {
946         _mint(to, tokenId);
947         require(
948             _checkOnERC721Received(address(0), to, tokenId, _data),
949             "ERC721: transfer to non ERC721Receiver implementer"
950         );
951     }
952 
953     /**
954      * @dev Mints `tokenId` and transfers it to `to`.
955      *
956      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
957      *
958      * Requirements:
959      *
960      * - `tokenId` must not exist.
961      * - `to` cannot be the zero address.
962      *
963      * Emits a {Transfer} event.
964      */
965     function _mint(address to, uint256 tokenId) internal virtual {
966         require(to != address(0), "ERC721: mint to the zero address");
967         require(!_exists(tokenId), "ERC721: token already minted");
968 
969         _beforeTokenTransfer(address(0), to, tokenId);
970 
971         _balances[to] += 1;
972         _owners[tokenId] = to;
973 
974         emit Transfer(address(0), to, tokenId);
975     }
976 
977     /**
978      * @dev Destroys `tokenId`.
979      * The approval is cleared when the token is burned.
980      *
981      * Requirements:
982      *
983      * - `tokenId` must exist.
984      *
985      * Emits a {Transfer} event.
986      */
987     function _burn(uint256 tokenId) internal virtual {
988         address owner = ERC721.ownerOf(tokenId);
989 
990         _beforeTokenTransfer(owner, address(0), tokenId);
991 
992         // Clear approvals
993         _approve(address(0), tokenId);
994 
995         _balances[owner] -= 1;
996         delete _owners[tokenId];
997 
998         emit Transfer(owner, address(0), tokenId);
999     }
1000 
1001     /**
1002      * @dev Transfers `tokenId` from `from` to `to`.
1003      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1004      *
1005      * Requirements:
1006      *
1007      * - `to` cannot be the zero address.
1008      * - `tokenId` token must be owned by `from`.
1009      *
1010      * Emits a {Transfer} event.
1011      */
1012     function _transfer(
1013         address from,
1014         address to,
1015         uint256 tokenId
1016     ) internal virtual {
1017         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1018         require(to != address(0), "ERC721: transfer to the zero address");
1019 
1020         _beforeTokenTransfer(from, to, tokenId);
1021 
1022         // Clear approvals from the previous owner
1023         _approve(address(0), tokenId);
1024 
1025         _balances[from] -= 1;
1026         _balances[to] += 1;
1027         _owners[tokenId] = to;
1028 
1029         emit Transfer(from, to, tokenId);
1030     }
1031 
1032     /**
1033      * @dev Approve `to` to operate on `tokenId`
1034      *
1035      * Emits a {Approval} event.
1036      */
1037     function _approve(address to, uint256 tokenId) internal virtual {
1038         _tokenApprovals[tokenId] = to;
1039         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1040     }
1041 
1042     /**
1043      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1044      * The call is not executed if the target address is not a contract.
1045      *
1046      * @param from address representing the previous owner of the given token ID
1047      * @param to target address that will receive the tokens
1048      * @param tokenId uint256 ID of the token to be transferred
1049      * @param _data bytes optional data to send along with the call
1050      * @return bool whether the call correctly returned the expected magic value
1051      */
1052     function _checkOnERC721Received(
1053         address from,
1054         address to,
1055         uint256 tokenId,
1056         bytes memory _data
1057     ) private returns (bool) {
1058         if (to.isContract()) {
1059             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1060                 return retval == IERC721Receiver.onERC721Received.selector;
1061             } catch (bytes memory reason) {
1062                 if (reason.length == 0) {
1063                     revert("ERC721: transfer to non ERC721Receiver implementer");
1064                 } else {
1065                     assembly {
1066                         revert(add(32, reason), mload(reason))
1067                     }
1068                 }
1069             }
1070         } else {
1071             return true;
1072         }
1073     }
1074 
1075     /**
1076      * @dev Hook that is called before any token transfer. This includes minting
1077      * and burning.
1078      *
1079      * Calling conditions:
1080      *
1081      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1082      * transferred to `to`.
1083      * - When `from` is zero, `tokenId` will be minted for `to`.
1084      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1085      * - `from` and `to` are never both zero.
1086      *
1087      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1088      */
1089     function _beforeTokenTransfer(
1090         address from,
1091         address to,
1092         uint256 tokenId
1093     ) internal virtual {}
1094 }
1095 
1096 // File: Animathereum.sol
1097 
1098 
1099 pragma solidity ^0.8.0;
1100 
1101 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1102 
1103 
1104 
1105 pragma solidity ^0.8.0;
1106 
1107 
1108 
1109 /**
1110  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1111  * enumerability of all the token ids in the contract as well as all token ids owned by each
1112  * account.
1113  */
1114 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1115     // Mapping from owner to list of owned token IDs
1116     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1117 
1118     // Mapping from token ID to index of the owner tokens list
1119     mapping(uint256 => uint256) private _ownedTokensIndex;
1120 
1121     // Array with all token ids, used for enumeration
1122     uint256[] private _allTokens;
1123 
1124     // Mapping from token id to position in the allTokens array
1125     mapping(uint256 => uint256) private _allTokensIndex;
1126 
1127     /**
1128      * @dev See {IERC165-supportsInterface}.
1129      */
1130     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1131         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1132     }
1133 
1134     /**
1135      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1136      */
1137     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1138         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1139         return _ownedTokens[owner][index];
1140     }
1141 
1142     /**
1143      * @dev See {IERC721Enumerable-totalSupply}.
1144      */
1145     function totalSupply() public view virtual override returns (uint256) {
1146         return _allTokens.length;
1147     }
1148 
1149     /**
1150      * @dev See {IERC721Enumerable-tokenByIndex}.
1151      */
1152     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1153         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1154         return _allTokens[index];
1155     }
1156 
1157     /**
1158      * @dev Hook that is called before any token transfer. This includes minting
1159      * and burning.
1160      *
1161      * Calling conditions:
1162      *
1163      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1164      * transferred to `to`.
1165      * - When `from` is zero, `tokenId` will be minted for `to`.
1166      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1167      * - `from` cannot be the zero address.
1168      * - `to` cannot be the zero address.
1169      *
1170      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1171      */
1172     function _beforeTokenTransfer(
1173         address from,
1174         address to,
1175         uint256 tokenId
1176     ) internal virtual override {
1177         super._beforeTokenTransfer(from, to, tokenId);
1178 
1179         if (from == address(0)) {
1180             _addTokenToAllTokensEnumeration(tokenId);
1181         } else if (from != to) {
1182             _removeTokenFromOwnerEnumeration(from, tokenId);
1183         }
1184         if (to == address(0)) {
1185             _removeTokenFromAllTokensEnumeration(tokenId);
1186         } else if (to != from) {
1187             _addTokenToOwnerEnumeration(to, tokenId);
1188         }
1189     }
1190 
1191     /**
1192      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1193      * @param to address representing the new owner of the given token ID
1194      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1195      */
1196     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1197         uint256 length = ERC721.balanceOf(to);
1198         _ownedTokens[to][length] = tokenId;
1199         _ownedTokensIndex[tokenId] = length;
1200     }
1201 
1202     /**
1203      * @dev Private function to add a token to this extension's token tracking data structures.
1204      * @param tokenId uint256 ID of the token to be added to the tokens list
1205      */
1206     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1207         _allTokensIndex[tokenId] = _allTokens.length;
1208         _allTokens.push(tokenId);
1209     }
1210 
1211     /**
1212      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1213      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1214      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1215      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1216      * @param from address representing the previous owner of the given token ID
1217      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1218      */
1219     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1220         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1221         // then delete the last slot (swap and pop).
1222 
1223         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1224         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1225 
1226         // When the token to delete is the last token, the swap operation is unnecessary
1227         if (tokenIndex != lastTokenIndex) {
1228             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1229 
1230             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1231             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1232         }
1233 
1234         // This also deletes the contents at the last position of the array
1235         delete _ownedTokensIndex[tokenId];
1236         delete _ownedTokens[from][lastTokenIndex];
1237     }
1238 
1239     /**
1240      * @dev Private function to remove a token from this extension's token tracking data structures.
1241      * This has O(1) time complexity, but alters the order of the _allTokens array.
1242      * @param tokenId uint256 ID of the token to be removed from the tokens list
1243      */
1244     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1245         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1246         // then delete the last slot (swap and pop).
1247 
1248         uint256 lastTokenIndex = _allTokens.length - 1;
1249         uint256 tokenIndex = _allTokensIndex[tokenId];
1250 
1251         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1252         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1253         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1254         uint256 lastTokenId = _allTokens[lastTokenIndex];
1255 
1256         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1257         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1258 
1259         // This also deletes the contents at the last position of the array
1260         delete _allTokensIndex[tokenId];
1261         _allTokens.pop();
1262     }
1263 }
1264 
1265 
1266 contract Animathereum is ERC721Enumerable, Ownable{
1267     uint public constant MAX_NFTS = 9999;
1268 	bool public paused = true;
1269 	string _baseTokenURI = "https://api.0xfactory.io/animathereum/";
1270 	mapping(uint256 => uint256) private _timestraps;
1271 	XFCT public constant XFCT_CONTRACT = XFCT(0xa50f74f04420443519Ad4908DDB82c02ACCab9D1);
1272 
1273     constructor(address _to, uint _count) ERC721("0xFactory's Animathereum", "Animations")  {
1274         uint _timestamp = block.timestamp;
1275         for(uint i = 0; i < _count; i++){
1276             _timestraps[totalSupply()] = _timestamp;
1277             _safeMint(_to, totalSupply());
1278         }
1279         
1280     }
1281 
1282     function mint(address _to, uint _count) public payable {
1283         require(!paused, "Pause");
1284         require(_count <= 20, "Exceeds 20");
1285         require(msg.value >= price(_count), "Value below price");
1286         require(totalSupply() + _count <= MAX_NFTS, "Max limit");
1287         require(totalSupply() < MAX_NFTS, "Sale end");
1288         
1289         uint _timestamp = block.timestamp;
1290         
1291         for(uint i = 0; i < _count; i++){
1292             _timestraps[totalSupply()] = _timestamp;
1293             _safeMint(_to, totalSupply());
1294         }
1295     }
1296     
1297     function mintForXFCT(address _to, uint _count) public {
1298         require(!paused, "Pause");
1299         require(_count <= 20, "Exceeds 20");
1300         require(totalSupply() + _count <= MAX_NFTS, "Max limit");
1301         require(totalSupply() < MAX_NFTS, "Sale end");
1302         require(XFCT_CONTRACT.balanceOf(msg.sender) >= priceInXFCT(_count), "Value below price");
1303         require(XFCT_CONTRACT.transferFrom(msg.sender, address(this), priceInXFCT(_count)), "xFCT Transfer error");
1304         
1305         uint _timestamp = block.timestamp;
1306         
1307         for(uint i = 0; i < _count; i++){
1308             _timestraps[totalSupply()] = _timestamp;
1309             _safeMint(_to, totalSupply());
1310         }
1311     }
1312     
1313     function price(uint _count) public pure returns (uint256) {
1314         return _count * 10000000000000000;
1315     }
1316     
1317     function priceInXFCT(uint _count) public pure returns (uint256) {
1318         return _count * 8600;
1319     }
1320         
1321     function _baseURI() internal view virtual override returns (string memory) {
1322         return _baseTokenURI;
1323     }
1324     
1325     function setBaseURI(string memory baseURI) public onlyOwner {
1326         _baseTokenURI = baseURI;
1327     }
1328 
1329     function walletOfOwner(address _owner) external view returns(uint256[] memory) {
1330         uint tokenCount = balanceOf(_owner);
1331         uint256[] memory tokensId = new uint256[](tokenCount);
1332         for(uint i = 0; i < tokenCount; i++){
1333             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1334         }
1335         return tokensId;
1336     }
1337     
1338     function pause(bool val) public onlyOwner {
1339         paused = val;
1340     }
1341 
1342     function withdrawAll() public payable onlyOwner {
1343         require(payable(msg.sender).send(address(this).balance));
1344     }
1345     
1346     function getXFCTBalance(address _owner) external view returns(uint256){
1347         require(_owner != address(0), "Query for the zero address");
1348         uint tokenCount = balanceOf(_owner);
1349         uint _timestamp = block.timestamp;
1350         uint256 _balance = 0;
1351         for(uint i = 0; i < tokenCount; i++){
1352             uint256 _tokenBalance = (_timestamp - _timestraps[tokenOfOwnerByIndex(msg.sender, i)]) / 3600;
1353             _balance = _balance + _tokenBalance;
1354         }
1355         return _balance;
1356     }
1357     
1358     function withdrawXFCT() public {
1359         uint tokenCount = balanceOf(msg.sender);
1360         uint _timestamp = block.timestamp;
1361         uint256 _balance = 0;
1362         for(uint i = 0; i < tokenCount; i++){
1363             uint256 _tokenBalance = (_timestamp - _timestraps[tokenOfOwnerByIndex(msg.sender, i)]) / 3600;
1364             if (_tokenBalance > 0) {
1365                 _timestraps[tokenOfOwnerByIndex(msg.sender, i)] = _timestamp;
1366             }
1367             _balance = _balance + _tokenBalance;
1368         }
1369         XFCT_CONTRACT.mint(msg.sender, _balance);
1370     }
1371     
1372     function burnAllXFCT() public onlyOwner {
1373         XFCT_CONTRACT.burn(XFCT_CONTRACT.balanceOf(address(this)));
1374     }
1375     
1376 }
1377 
1378 interface XFCT{
1379     function balanceOf(address account) external view returns (uint256);
1380     function transfer(address recipient, uint256 amount) external returns (bool);
1381     function allowance(address owner, address spender) external view returns (uint256);
1382     function approve(address spender, uint256 amount) external returns (bool);
1383     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1384     function mint(address _to, uint256 _count) external;
1385     function burn(uint256 _count) external;
1386     event Transfer(address indexed from, address indexed to, uint256 value);
1387     event Approval(address indexed owner, address indexed spender, uint256 value);
1388 }