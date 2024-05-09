1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/access/Ownable.sol
28 
29 
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
99 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
100 
101 
102 
103 pragma solidity ^0.8.0;
104 
105 /**
106  * @dev Interface of the ERC165 standard, as defined in the
107  * https://eips.ethereum.org/EIPS/eip-165[EIP].
108  *
109  * Implementers can declare support of contract interfaces, which can then be
110  * queried by others ({ERC165Checker}).
111  *
112  * For an implementation, see {ERC165}.
113  */
114 interface IERC165 {
115     /**
116      * @dev Returns true if this contract implements the interface defined by
117      * `interfaceId`. See the corresponding
118      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
119      * to learn more about how these ids are created.
120      *
121      * This function call must use less than 30 000 gas.
122      */
123     function supportsInterface(bytes4 interfaceId) external view returns (bool);
124 }
125 
126 
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
271 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
272 
273 
274 
275 pragma solidity ^0.8.0;
276 
277 
278 /**
279  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
280  * @dev See https://eips.ethereum.org/EIPS/eip-721
281  */
282 interface IERC721Enumerable is IERC721 {
283     /**
284      * @dev Returns the total amount of tokens stored by the contract.
285      */
286     function totalSupply() external view returns (uint256);
287 
288     /**
289      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
290      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
291      */
292     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
293 
294     /**
295      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
296      * Use along with {totalSupply} to enumerate all tokens.
297      */
298     function tokenByIndex(uint256 index) external view returns (uint256);
299 }
300 
301 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
302 
303 
304 
305 pragma solidity ^0.8.0;
306 
307 
308 /**
309  * @dev Implementation of the {IERC165} interface.
310  *
311  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
312  * for the additional interface id that will be supported. For example:
313  *
314  * ```solidity
315  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
316  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
317  * }
318  * ```
319  *
320  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
321  */
322 abstract contract ERC165 is IERC165 {
323     /**
324      * @dev See {IERC165-supportsInterface}.
325      */
326     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
327         return interfaceId == type(IERC165).interfaceId;
328     }
329 }
330 
331 // File: @openzeppelin/contracts/utils/Strings.sol
332 
333 
334 
335 pragma solidity ^0.8.0;
336 
337 /**
338  * @dev String operations.
339  */
340 library Strings {
341     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
342 
343     /**
344      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
345      */
346     function toString(uint256 value) internal pure returns (string memory) {
347         // Inspired by OraclizeAPI's implementation - MIT licence
348         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
349 
350         if (value == 0) {
351             return "0";
352         }
353         uint256 temp = value;
354         uint256 digits;
355         while (temp != 0) {
356             digits++;
357             temp /= 10;
358         }
359         bytes memory buffer = new bytes(digits);
360         while (value != 0) {
361             digits -= 1;
362             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
363             value /= 10;
364         }
365         return string(buffer);
366     }
367 
368     /**
369      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
370      */
371     function toHexString(uint256 value) internal pure returns (string memory) {
372         if (value == 0) {
373             return "0x00";
374         }
375         uint256 temp = value;
376         uint256 length = 0;
377         while (temp != 0) {
378             length++;
379             temp >>= 8;
380         }
381         return toHexString(value, length);
382     }
383 
384     /**
385      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
386      */
387     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
388         bytes memory buffer = new bytes(2 * length + 2);
389         buffer[0] = "0";
390         buffer[1] = "x";
391         for (uint256 i = 2 * length + 1; i > 1; --i) {
392             buffer[i] = _HEX_SYMBOLS[value & 0xf];
393             value >>= 4;
394         }
395         require(value == 0, "Strings: hex length insufficient");
396         return string(buffer);
397     }
398 }
399 
400 // File: @openzeppelin/contracts/utils/Address.sol
401 
402 
403 
404 pragma solidity ^0.8.0;
405 
406 /**
407  * @dev Collection of functions related to the address type
408  */
409 library Address {
410     /**
411      * @dev Returns true if `account` is a contract.
412      *
413      * [IMPORTANT]
414      * ====
415      * It is unsafe to assume that an address for which this function returns
416      * false is an externally-owned account (EOA) and not a contract.
417      *
418      * Among others, `isContract` will return false for the following
419      * types of addresses:
420      *
421      *  - an externally-owned account
422      *  - a contract in construction
423      *  - an address where a contract will be created
424      *  - an address where a contract lived, but was destroyed
425      * ====
426      */
427     function isContract(address account) internal view returns (bool) {
428         // This method relies on extcodesize, which returns 0 for contracts in
429         // construction, since the code is only stored at the end of the
430         // constructor execution.
431 
432         uint256 size;
433         assembly {
434             size := extcodesize(account)
435         }
436         return size > 0;
437     }
438 
439     /**
440      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
441      * `recipient`, forwarding all available gas and reverting on errors.
442      *
443      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
444      * of certain opcodes, possibly making contracts go over the 2300 gas limit
445      * imposed by `transfer`, making them unable to receive funds via
446      * `transfer`. {sendValue} removes this limitation.
447      *
448      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
449      *
450      * IMPORTANT: because control is transferred to `recipient`, care must be
451      * taken to not create reentrancy vulnerabilities. Consider using
452      * {ReentrancyGuard} or the
453      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
454      */
455     function sendValue(address payable recipient, uint256 amount) internal {
456         require(address(this).balance >= amount, "Address: insufficient balance");
457 
458         (bool success, ) = recipient.call{value: amount}("");
459         require(success, "Address: unable to send value, recipient may have reverted");
460     }
461 
462     /**
463      * @dev Performs a Solidity function call using a low level `call`. A
464      * plain `call` is an unsafe replacement for a function call: use this
465      * function instead.
466      *
467      * If `target` reverts with a revert reason, it is bubbled up by this
468      * function (like regular Solidity function calls).
469      *
470      * Returns the raw returned data. To convert to the expected return value,
471      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
472      *
473      * Requirements:
474      *
475      * - `target` must be a contract.
476      * - calling `target` with `data` must not revert.
477      *
478      * _Available since v3.1._
479      */
480     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
481         return functionCall(target, data, "Address: low-level call failed");
482     }
483 
484     /**
485      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
486      * `errorMessage` as a fallback revert reason when `target` reverts.
487      *
488      * _Available since v3.1._
489      */
490     function functionCall(
491         address target,
492         bytes memory data,
493         string memory errorMessage
494     ) internal returns (bytes memory) {
495         return functionCallWithValue(target, data, 0, errorMessage);
496     }
497 
498     /**
499      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
500      * but also transferring `value` wei to `target`.
501      *
502      * Requirements:
503      *
504      * - the calling contract must have an ETH balance of at least `value`.
505      * - the called Solidity function must be `payable`.
506      *
507      * _Available since v3.1._
508      */
509     function functionCallWithValue(
510         address target,
511         bytes memory data,
512         uint256 value
513     ) internal returns (bytes memory) {
514         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
515     }
516 
517     /**
518      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
519      * with `errorMessage` as a fallback revert reason when `target` reverts.
520      *
521      * _Available since v3.1._
522      */
523     function functionCallWithValue(
524         address target,
525         bytes memory data,
526         uint256 value,
527         string memory errorMessage
528     ) internal returns (bytes memory) {
529         require(address(this).balance >= value, "Address: insufficient balance for call");
530         require(isContract(target), "Address: call to non-contract");
531 
532         (bool success, bytes memory returndata) = target.call{value: value}(data);
533         return verifyCallResult(success, returndata, errorMessage);
534     }
535 
536     /**
537      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
538      * but performing a static call.
539      *
540      * _Available since v3.3._
541      */
542     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
543         return functionStaticCall(target, data, "Address: low-level static call failed");
544     }
545 
546     /**
547      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
548      * but performing a static call.
549      *
550      * _Available since v3.3._
551      */
552     function functionStaticCall(
553         address target,
554         bytes memory data,
555         string memory errorMessage
556     ) internal view returns (bytes memory) {
557         require(isContract(target), "Address: static call to non-contract");
558 
559         (bool success, bytes memory returndata) = target.staticcall(data);
560         return verifyCallResult(success, returndata, errorMessage);
561     }
562 
563     /**
564      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
565      * but performing a delegate call.
566      *
567      * _Available since v3.4._
568      */
569     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
570         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
571     }
572 
573     /**
574      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
575      * but performing a delegate call.
576      *
577      * _Available since v3.4._
578      */
579     function functionDelegateCall(
580         address target,
581         bytes memory data,
582         string memory errorMessage
583     ) internal returns (bytes memory) {
584         require(isContract(target), "Address: delegate call to non-contract");
585 
586         (bool success, bytes memory returndata) = target.delegatecall(data);
587         return verifyCallResult(success, returndata, errorMessage);
588     }
589 
590     /**
591      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
592      * revert reason using the provided one.
593      *
594      * _Available since v4.3._
595      */
596     function verifyCallResult(
597         bool success,
598         bytes memory returndata,
599         string memory errorMessage
600     ) internal pure returns (bytes memory) {
601         if (success) {
602             return returndata;
603         } else {
604             // Look for revert reason and bubble it up if present
605             if (returndata.length > 0) {
606                 // The easiest way to bubble the revert reason is using memory via assembly
607 
608                 assembly {
609                     let returndata_size := mload(returndata)
610                     revert(add(32, returndata), returndata_size)
611                 }
612             } else {
613                 revert(errorMessage);
614             }
615         }
616     }
617 }
618 
619 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
620 
621 
622 
623 pragma solidity ^0.8.0;
624 
625 
626 /**
627  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
628  * @dev See https://eips.ethereum.org/EIPS/eip-721
629  */
630 interface IERC721Metadata is IERC721 {
631     /**
632      * @dev Returns the token collection name.
633      */
634     function name() external view returns (string memory);
635 
636     /**
637      * @dev Returns the token collection symbol.
638      */
639     function symbol() external view returns (string memory);
640 
641     /**
642      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
643      */
644     function tokenURI(uint256 tokenId) external view returns (string memory);
645 }
646 
647 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
648 
649 
650 
651 pragma solidity ^0.8.0;
652 
653 /**
654  * @title ERC721 token receiver interface
655  * @dev Interface for any contract that wants to support safeTransfers
656  * from ERC721 asset contracts.
657  */
658 interface IERC721Receiver {
659     /**
660      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
661      * by `operator` from `from`, this function is called.
662      *
663      * It must return its Solidity selector to confirm the token transfer.
664      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
665      *
666      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
667      */
668     function onERC721Received(
669         address operator,
670         address from,
671         uint256 tokenId,
672         bytes calldata data
673     ) external returns (bytes4);
674 }
675 
676 
677 
678 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
679 
680 
681 
682 pragma solidity ^0.8.0;
683 
684 
685 
686 
687 
688 
689 
690 
691 /**
692  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
693  * the Metadata extension, but not including the Enumerable extension, which is available separately as
694  * {ERC721Enumerable}.
695  */
696 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
697     using Address for address;
698     using Strings for uint256;
699 
700     // Token name
701     string private _name;
702 
703     // Token symbol
704     string private _symbol;
705 
706     // Mapping from token ID to owner address
707     mapping(uint256 => address) private _owners;
708 
709     // Mapping owner address to token count
710     mapping(address => uint256) private _balances;
711 
712     // Mapping from token ID to approved address
713     mapping(uint256 => address) private _tokenApprovals;
714 
715     // Mapping from owner to operator approvals
716     mapping(address => mapping(address => bool)) private _operatorApprovals;
717 
718     /**
719      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
720      */
721     constructor(string memory name_, string memory symbol_) {
722         _name = name_;
723         _symbol = symbol_;
724     }
725 
726     /**
727      * @dev See {IERC165-supportsInterface}.
728      */
729     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
730         return
731             interfaceId == type(IERC721).interfaceId ||
732             interfaceId == type(IERC721Metadata).interfaceId ||
733             super.supportsInterface(interfaceId);
734     }
735 
736     /**
737      * @dev See {IERC721-balanceOf}.
738      */
739     function balanceOf(address owner) public view virtual override returns (uint256) {
740         require(owner != address(0), "ERC721: balance query for the zero address");
741         return _balances[owner];
742     }
743 
744     /**
745      * @dev See {IERC721-ownerOf}.
746      */
747     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
748         address owner = _owners[tokenId];
749         require(owner != address(0), "ERC721: owner query for nonexistent token");
750         return owner;
751     }
752 
753     /**
754      * @dev See {IERC721Metadata-name}.
755      */
756     function name() public view virtual override returns (string memory) {
757         return _name;
758     }
759 
760     /**
761      * @dev See {IERC721Metadata-symbol}.
762      */
763     function symbol() public view virtual override returns (string memory) {
764         return _symbol;
765     }
766 
767     /**
768      * @dev See {IERC721Metadata-tokenURI}.
769      */
770     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
771         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
772 
773         string memory baseURI = _baseURI();
774         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
775     }
776 
777     /**
778      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
779      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
780      * by default, can be overriden in child contracts.
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
792 
793         require(
794             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
795             "ERC721: approve caller is not owner nor approved for all"
796         );
797 
798         _approve(to, tokenId);
799     }
800 
801     /**
802      * @dev See {IERC721-getApproved}.
803      */
804     function getApproved(uint256 tokenId) public view virtual override returns (address) {
805         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
806 
807         return _tokenApprovals[tokenId];
808     }
809 
810     /**
811      * @dev See {IERC721-setApprovalForAll}.
812      */
813     function setApprovalForAll(address operator, bool approved) public virtual override {
814         require(operator != _msgSender(), "ERC721: approve to caller");
815 
816         _operatorApprovals[_msgSender()][operator] = approved;
817         emit ApprovalForAll(_msgSender(), operator, approved);
818     }
819 
820     /**
821      * @dev See {IERC721-isApprovedForAll}.
822      */
823     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
824         return _operatorApprovals[owner][operator];
825     }
826 
827     /**
828      * @dev See {IERC721-transferFrom}.
829      */
830     function transferFrom(
831         address from,
832         address to,
833         uint256 tokenId
834     ) public virtual override {
835         //solhint-disable-next-line max-line-length
836         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
837 
838         _transfer(from, to, tokenId);
839     }
840 
841     /**
842      * @dev See {IERC721-safeTransferFrom}.
843      */
844     function safeTransferFrom(
845         address from,
846         address to,
847         uint256 tokenId
848     ) public virtual override {
849         safeTransferFrom(from, to, tokenId, "");
850     }
851 
852     /**
853      * @dev See {IERC721-safeTransferFrom}.
854      */
855     function safeTransferFrom(
856         address from,
857         address to,
858         uint256 tokenId,
859         bytes memory _data
860     ) public virtual override {
861         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
862         _safeTransfer(from, to, tokenId, _data);
863     }
864 
865     /**
866      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
867      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
868      *
869      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
870      *
871      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
872      * implement alternative mechanisms to perform token transfer, such as signature-based.
873      *
874      * Requirements:
875      *
876      * - `from` cannot be the zero address.
877      * - `to` cannot be the zero address.
878      * - `tokenId` token must exist and be owned by `from`.
879      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
880      *
881      * Emits a {Transfer} event.
882      */
883     function _safeTransfer(
884         address from,
885         address to,
886         uint256 tokenId,
887         bytes memory _data
888     ) internal virtual {
889         _transfer(from, to, tokenId);
890         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
891     }
892 
893     /**
894      * @dev Returns whether `tokenId` exists.
895      *
896      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
897      *
898      * Tokens start existing when they are minted (`_mint`),
899      * and stop existing when they are burned (`_burn`).
900      */
901     function _exists(uint256 tokenId) internal view virtual returns (bool) {
902         return _owners[tokenId] != address(0);
903     }
904 
905     /**
906      * @dev Returns whether `spender` is allowed to manage `tokenId`.
907      *
908      * Requirements:
909      *
910      * - `tokenId` must exist.
911      */
912     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
913         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
914         address owner = ERC721.ownerOf(tokenId);
915         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
916     }
917 
918     /**
919      * @dev Safely mints `tokenId` and transfers it to `to`.
920      *
921      * Requirements:
922      *
923      * - `tokenId` must not exist.
924      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
925      *
926      * Emits a {Transfer} event.
927      */
928     function _safeMint(address to, uint256 tokenId) internal virtual {
929         _safeMint(to, tokenId, "");
930     }
931 
932     /**
933      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
934      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
935      */
936     function _safeMint(
937         address to,
938         uint256 tokenId,
939         bytes memory _data
940     ) internal virtual {
941         _mint(to, tokenId);
942         require(
943             _checkOnERC721Received(address(0), to, tokenId, _data),
944             "ERC721: transfer to non ERC721Receiver implementer"
945         );
946     }
947 
948     /**
949      * @dev Mints `tokenId` and transfers it to `to`.
950      *
951      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
952      *
953      * Requirements:
954      *
955      * - `tokenId` must not exist.
956      * - `to` cannot be the zero address.
957      *
958      * Emits a {Transfer} event.
959      */
960     function _mint(address to, uint256 tokenId) internal virtual {
961         require(to != address(0), "ERC721: mint to the zero address");
962         require(!_exists(tokenId), "ERC721: token already minted");
963 
964         _beforeTokenTransfer(address(0), to, tokenId);
965 
966         _balances[to] += 1;
967         _owners[tokenId] = to;
968 
969         emit Transfer(address(0), to, tokenId);
970     }
971 
972     /**
973      * @dev Destroys `tokenId`.
974      * The approval is cleared when the token is burned.
975      *
976      * Requirements:
977      *
978      * - `tokenId` must exist.
979      *
980      * Emits a {Transfer} event.
981      */
982     function _burn(uint256 tokenId) internal virtual {
983         address owner = ERC721.ownerOf(tokenId);
984 
985         _beforeTokenTransfer(owner, address(0), tokenId);
986 
987         // Clear approvals
988         _approve(address(0), tokenId);
989 
990         _balances[owner] -= 1;
991         delete _owners[tokenId];
992 
993         emit Transfer(owner, address(0), tokenId);
994     }
995 
996     /**
997      * @dev Transfers `tokenId` from `from` to `to`.
998      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
999      *
1000      * Requirements:
1001      *
1002      * - `to` cannot be the zero address.
1003      * - `tokenId` token must be owned by `from`.
1004      *
1005      * Emits a {Transfer} event.
1006      */
1007     function _transfer(
1008         address from,
1009         address to,
1010         uint256 tokenId
1011     ) internal virtual {
1012         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1013         require(to != address(0), "ERC721: transfer to the zero address");
1014 
1015         _beforeTokenTransfer(from, to, tokenId);
1016 
1017         // Clear approvals from the previous owner
1018         _approve(address(0), tokenId);
1019 
1020         _balances[from] -= 1;
1021         _balances[to] += 1;
1022         _owners[tokenId] = to;
1023 
1024         emit Transfer(from, to, tokenId);
1025     }
1026 
1027     /**
1028      * @dev Approve `to` to operate on `tokenId`
1029      *
1030      * Emits a {Approval} event.
1031      */
1032     function _approve(address to, uint256 tokenId) internal virtual {
1033         _tokenApprovals[tokenId] = to;
1034         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1035     }
1036 
1037     /**
1038      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1039      * The call is not executed if the target address is not a contract.
1040      *
1041      * @param from address representing the previous owner of the given token ID
1042      * @param to target address that will receive the tokens
1043      * @param tokenId uint256 ID of the token to be transferred
1044      * @param _data bytes optional data to send along with the call
1045      * @return bool whether the call correctly returned the expected magic value
1046      */
1047     function _checkOnERC721Received(
1048         address from,
1049         address to,
1050         uint256 tokenId,
1051         bytes memory _data
1052     ) private returns (bool) {
1053         if (to.isContract()) {
1054             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1055                 return retval == IERC721Receiver.onERC721Received.selector;
1056             } catch (bytes memory reason) {
1057                 if (reason.length == 0) {
1058                     revert("ERC721: transfer to non ERC721Receiver implementer");
1059                 } else {
1060                     assembly {
1061                         revert(add(32, reason), mload(reason))
1062                     }
1063                 }
1064             }
1065         } else {
1066             return true;
1067         }
1068     }
1069 
1070     /**
1071      * @dev Hook that is called before any token transfer. This includes minting
1072      * and burning.
1073      *
1074      * Calling conditions:
1075      *
1076      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1077      * transferred to `to`.
1078      * - When `from` is zero, `tokenId` will be minted for `to`.
1079      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1080      * - `from` and `to` are never both zero.
1081      *
1082      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1083      */
1084     function _beforeTokenTransfer(
1085         address from,
1086         address to,
1087         uint256 tokenId
1088     ) internal virtual {}
1089 }
1090 
1091 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1092 
1093 
1094 
1095 pragma solidity ^0.8.0;
1096 
1097 
1098 
1099 /**
1100  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1101  * enumerability of all the token ids in the contract as well as all token ids owned by each
1102  * account.
1103  */
1104 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1105     // Mapping from owner to list of owned token IDs
1106     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1107 
1108     // Mapping from token ID to index of the owner tokens list
1109     mapping(uint256 => uint256) private _ownedTokensIndex;
1110 
1111     // Array with all token ids, used for enumeration
1112     uint256[] private _allTokens;
1113 
1114     // Mapping from token id to position in the allTokens array
1115     mapping(uint256 => uint256) private _allTokensIndex;
1116 
1117     /**
1118      * @dev See {IERC165-supportsInterface}.
1119      */
1120     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1121         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1122     }
1123 
1124     /**
1125      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1126      */
1127     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1128         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1129         return _ownedTokens[owner][index];
1130     }
1131 
1132     /**
1133      * @dev See {IERC721Enumerable-totalSupply}.
1134      */
1135     function totalSupply() public view virtual override returns (uint256) {
1136         return _allTokens.length;
1137     }
1138 
1139     /**
1140      * @dev See {IERC721Enumerable-tokenByIndex}.
1141      */
1142     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1143         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1144         return _allTokens[index];
1145     }
1146 
1147     /**
1148      * @dev Hook that is called before any token transfer. This includes minting
1149      * and burning.
1150      *
1151      * Calling conditions:
1152      *
1153      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1154      * transferred to `to`.
1155      * - When `from` is zero, `tokenId` will be minted for `to`.
1156      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1157      * - `from` cannot be the zero address.
1158      * - `to` cannot be the zero address.
1159      *
1160      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1161      */
1162     function _beforeTokenTransfer(
1163         address from,
1164         address to,
1165         uint256 tokenId
1166     ) internal virtual override {
1167         super._beforeTokenTransfer(from, to, tokenId);
1168 
1169         if (from == address(0)) {
1170             _addTokenToAllTokensEnumeration(tokenId);
1171         } else if (from != to) {
1172             _removeTokenFromOwnerEnumeration(from, tokenId);
1173         }
1174         if (to == address(0)) {
1175             _removeTokenFromAllTokensEnumeration(tokenId);
1176         } else if (to != from) {
1177             _addTokenToOwnerEnumeration(to, tokenId);
1178         }
1179     }
1180 
1181     /**
1182      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1183      * @param to address representing the new owner of the given token ID
1184      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1185      */
1186     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1187         uint256 length = ERC721.balanceOf(to);
1188         _ownedTokens[to][length] = tokenId;
1189         _ownedTokensIndex[tokenId] = length;
1190     }
1191 
1192     /**
1193      * @dev Private function to add a token to this extension's token tracking data structures.
1194      * @param tokenId uint256 ID of the token to be added to the tokens list
1195      */
1196     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1197         _allTokensIndex[tokenId] = _allTokens.length;
1198         _allTokens.push(tokenId);
1199     }
1200 
1201     /**
1202      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1203      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1204      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1205      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1206      * @param from address representing the previous owner of the given token ID
1207      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1208      */
1209     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1210         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1211         // then delete the last slot (swap and pop).
1212 
1213         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1214         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1215 
1216         // When the token to delete is the last token, the swap operation is unnecessary
1217         if (tokenIndex != lastTokenIndex) {
1218             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1219 
1220             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1221             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1222         }
1223 
1224         // This also deletes the contents at the last position of the array
1225         delete _ownedTokensIndex[tokenId];
1226         delete _ownedTokens[from][lastTokenIndex];
1227     }
1228 
1229     /**
1230      * @dev Private function to remove a token from this extension's token tracking data structures.
1231      * This has O(1) time complexity, but alters the order of the _allTokens array.
1232      * @param tokenId uint256 ID of the token to be removed from the tokens list
1233      */
1234     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1235         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1236         // then delete the last slot (swap and pop).
1237 
1238         uint256 lastTokenIndex = _allTokens.length - 1;
1239         uint256 tokenIndex = _allTokensIndex[tokenId];
1240 
1241         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1242         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1243         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1244         uint256 lastTokenId = _allTokens[lastTokenIndex];
1245 
1246         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1247         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1248 
1249         // This also deletes the contents at the last position of the array
1250         delete _allTokensIndex[tokenId];
1251         _allTokens.pop();
1252     }
1253 }
1254 
1255 // File: contracts/PixelDoors.sol
1256 
1257 // SPDX-License-Identifier: MIT
1258 
1259 pragma solidity >=0.7.0 <0.9.0;
1260 
1261 contract PixelDoors is ERC721Enumerable, Ownable {
1262   using Strings for uint256;
1263 
1264   string public baseURI;
1265   string public baseExtension = ".json";
1266   uint256 public cost = 0 ether;
1267   uint256 public maxSupply = 10000;
1268   uint256 public maxMintAmount = 1;
1269   uint256 public nftPerAddressLimit = 2;
1270   bool public paused = false;
1271   mapping(address => uint256) public addressMintedBalance;
1272 
1273   constructor(
1274     string memory _name,
1275     string memory _symbol,
1276     string memory _initBaseURI
1277   ) ERC721(_name, _symbol) {
1278     setBaseURI(_initBaseURI);
1279     mint(1);
1280   }
1281 
1282   // internal
1283   function _baseURI() internal view virtual override returns (string memory) {
1284     return baseURI;
1285   }
1286 
1287   // public
1288   function mint(uint256 _mintAmount) public payable {
1289     require(!paused, "the contract is paused");
1290     uint256 supply = totalSupply();
1291     if (supply >= 1000) { //When 1000 have been minted alter price and nft per address limit and nft max amount mint
1292     cost = 0.01 ether;
1293     maxMintAmount = 20;
1294     nftPerAddressLimit = 100;
1295     }
1296     if (supply >= 5000) cost = 0.02 ether;
1297     if (supply >= 8000) cost = 0.03 ether;
1298     require(_mintAmount > 0, "Need to mint at least 1 NFT");
1299     require(_mintAmount <= maxMintAmount, "Max mint amount per session exceeded");
1300     require(supply + _mintAmount <= maxSupply, "Max NFT limit exceeded");
1301 
1302     if (msg.sender != owner()) {
1303         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1304         require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "Max NFT per address exceeded");
1305         require(msg.value >= cost * _mintAmount, "Insufficient funds");
1306     }
1307 
1308     for (uint256 i = 1; i <= _mintAmount; i++) {
1309       addressMintedBalance[msg.sender]++;
1310       _safeMint(msg.sender, supply + i);
1311     }
1312   }
1313 
1314   function walletOfOwner(address _owner)
1315     public
1316     view
1317     returns (uint256[] memory)
1318   {
1319     uint256 ownerTokenCount = balanceOf(_owner);
1320     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1321     for (uint256 i; i < ownerTokenCount; i++) {
1322       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1323     }
1324     return tokenIds;
1325   }
1326 
1327   function tokenURI(uint256 tokenId)
1328     public
1329     view
1330     virtual
1331     override
1332     returns (string memory)
1333   {
1334     require(
1335       _exists(tokenId),
1336       "ERC721Metadata: URI query for nonexistent token"
1337     );
1338     
1339     string memory currentBaseURI = _baseURI();
1340     return bytes(currentBaseURI).length > 0
1341         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1342         : "";
1343   }
1344 
1345   //only owner
1346   function setNftPerAddressLimit(uint256 _limit) public onlyOwner() {
1347     nftPerAddressLimit = _limit;
1348   }
1349   
1350   function setCost(uint256 _newCost) public onlyOwner() {
1351     cost = _newCost;
1352   }
1353 
1354   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
1355     maxMintAmount = _newmaxMintAmount;
1356   }
1357 
1358   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1359     baseURI = _newBaseURI;
1360   }
1361 
1362   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1363     baseExtension = _newBaseExtension;
1364   }
1365   function pause(bool _state) public onlyOwner {
1366     paused = _state;
1367   }
1368  
1369   function withdraw() public payable onlyOwner {
1370     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1371     require(success);
1372   }
1373 }