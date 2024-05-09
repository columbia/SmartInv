1 // File: @openzeppelin/contracts@4.2.0/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /*
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
26 // File: @openzeppelin/contracts@4.2.0/access/Ownable.sol
27 
28 
29 
30 pragma solidity ^0.8.0;
31 
32 
33 /**
34  * @dev Contract module which provides a basic access control mechanism, where
35  * there is an account (an owner) that can be granted exclusive access to
36  * specific functions.
37  *
38  * By default, the owner account will be the one that deploys the contract. This
39  * can later be changed with {transferOwnership}.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 abstract contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor() {
54         _setOwner(_msgSender());
55     }
56 
57     /**
58      * @dev Returns the address of the current owner.
59      */
60     function owner() public view virtual returns (address) {
61         return _owner;
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(owner() == _msgSender(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     /**
73      * @dev Leaves the contract without owner. It will not be possible to call
74      * `onlyOwner` functions anymore. Can only be called by the current owner.
75      *
76      * NOTE: Renouncing ownership will leave the contract without an owner,
77      * thereby removing any functionality that is only available to the owner.
78      */
79     function renounceOwnership() public virtual onlyOwner {
80         _setOwner(address(0));
81     }
82 
83     /**
84      * @dev Transfers ownership of the contract to a new account (`newOwner`).
85      * Can only be called by the current owner.
86      */
87     function transferOwnership(address newOwner) public virtual onlyOwner {
88         require(newOwner != address(0), "Ownable: new owner is the zero address");
89         _setOwner(newOwner);
90     }
91 
92     function _setOwner(address newOwner) private {
93         address oldOwner = _owner;
94         _owner = newOwner;
95         emit OwnershipTransferred(oldOwner, newOwner);
96     }
97 }
98 
99 // File: @openzeppelin/contracts@4.2.0/utils/introspection/IERC165.sol
100 
101 pragma solidity ^0.8.0;
102 
103 /**
104  * @dev Interface of the ERC165 standard, as defined in the
105  * https://eips.ethereum.org/EIPS/eip-165[EIP].
106  *
107  * Implementers can declare support of contract interfaces, which can then be
108  * queried by others ({ERC165Checker}).
109  *
110  * For an implementation, see {ERC165}.
111  */
112 interface IERC165 {
113     /**
114      * @dev Returns true if this contract implements the interface defined by
115      * `interfaceId`. See the corresponding
116      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
117      * to learn more about how these ids are created.
118      *
119      * This function call must use less than 30 000 gas.
120      */
121     function supportsInterface(bytes4 interfaceId) external view returns (bool);
122 }
123 
124 
125 
126 // File: @openzeppelin/contracts@4.2.0/token/ERC721/IERC721.sol
127 
128 
129 pragma solidity ^0.8.0;
130 
131 
132 /**
133  * @dev Required interface of an ERC721 compliant contract.
134  */
135 interface IERC721 is IERC165 {
136     /**
137      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
138      */
139     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
140 
141     /**
142      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
143      */
144     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
145 
146     /**
147      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
148      */
149     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
150 
151     /**
152      * @dev Returns the number of tokens in ``owner``'s account.
153      */
154     function balanceOf(address owner) external view returns (uint256 balance);
155 
156     /**
157      * @dev Returns the owner of the `tokenId` token.
158      *
159      * Requirements:
160      *
161      * - `tokenId` must exist.
162      */
163     function ownerOf(uint256 tokenId) external view returns (address owner);
164 
165     /**
166      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
167      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
168      *
169      * Requirements:
170      *
171      * - `from` cannot be the zero address.
172      * - `to` cannot be the zero address.
173      * - `tokenId` token must exist and be owned by `from`.
174      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
175      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
176      *
177      * Emits a {Transfer} event.
178      */
179     function safeTransferFrom(
180         address from,
181         address to,
182         uint256 tokenId
183     ) external;
184 
185     /**
186      * @dev Transfers `tokenId` token from `from` to `to`.
187      *
188      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
189      *
190      * Requirements:
191      *
192      * - `from` cannot be the zero address.
193      * - `to` cannot be the zero address.
194      * - `tokenId` token must be owned by `from`.
195      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
196      *
197      * Emits a {Transfer} event.
198      */
199     function transferFrom(
200         address from,
201         address to,
202         uint256 tokenId
203     ) external;
204 
205     /**
206      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
207      * The approval is cleared when the token is transferred.
208      *
209      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
210      *
211      * Requirements:
212      *
213      * - The caller must own the token or be an approved operator.
214      * - `tokenId` must exist.
215      *
216      * Emits an {Approval} event.
217      */
218     function approve(address to, uint256 tokenId) external;
219 
220     /**
221      * @dev Returns the account approved for `tokenId` token.
222      *
223      * Requirements:
224      *
225      * - `tokenId` must exist.
226      */
227     function getApproved(uint256 tokenId) external view returns (address operator);
228 
229     /**
230      * @dev Approve or remove `operator` as an operator for the caller.
231      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
232      *
233      * Requirements:
234      *
235      * - The `operator` cannot be the caller.
236      *
237      * Emits an {ApprovalForAll} event.
238      */
239     function setApprovalForAll(address operator, bool _approved) external;
240 
241     /**
242      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
243      *
244      * See {setApprovalForAll}
245      */
246     function isApprovedForAll(address owner, address operator) external view returns (bool);
247 
248     /**
249      * @dev Safely transfers `tokenId` token from `from` to `to`.
250      *
251      * Requirements:
252      *
253      * - `from` cannot be the zero address.
254      * - `to` cannot be the zero address.
255      * - `tokenId` token must exist and be owned by `from`.
256      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
257      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
258      *
259      * Emits a {Transfer} event.
260      */
261     function safeTransferFrom(
262         address from,
263         address to,
264         uint256 tokenId,
265         bytes calldata data
266     ) external;
267 }
268 
269 // File: @openzeppelin/contracts@4.2.0/token/ERC721/extensions/IERC721Enumerable.sol
270 
271 
272 
273 pragma solidity ^0.8.0;
274 
275 
276 /**
277  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
278  * @dev See https://eips.ethereum.org/EIPS/eip-721
279  */
280 interface IERC721Enumerable is IERC721 {
281     /**
282      * @dev Returns the total amount of tokens stored by the contract.
283      */
284     function totalSupply() external view returns (uint256);
285 
286     /**
287      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
288      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
289      */
290     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
291 
292     /**
293      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
294      * Use along with {totalSupply} to enumerate all tokens.
295      */
296     function tokenByIndex(uint256 index) external view returns (uint256);
297 }
298 
299 // File: @openzeppelin/contracts@4.2.0/utils/introspection/ERC165.sol
300 
301 
302 
303 pragma solidity ^0.8.0;
304 
305 
306 /**
307  * @dev Implementation of the {IERC165} interface.
308  *
309  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
310  * for the additional interface id that will be supported. For example:
311  *
312  * ```solidity
313  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
314  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
315  * }
316  * ```
317  *
318  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
319  */
320 abstract contract ERC165 is IERC165 {
321     /**
322      * @dev See {IERC165-supportsInterface}.
323      */
324     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
325         return interfaceId == type(IERC165).interfaceId;
326     }
327 }
328 
329 // File: @openzeppelin/contracts@4.2.0/utils/Strings.sol
330 
331 
332 
333 pragma solidity ^0.8.0;
334 
335 /**
336  * @dev String operations.
337  */
338 library Strings {
339     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
340 
341     /**
342      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
343      */
344     function toString(uint256 value) internal pure returns (string memory) {
345         // Inspired by OraclizeAPI's implementation - MIT licence
346         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
347 
348         if (value == 0) {
349             return "0";
350         }
351         uint256 temp = value;
352         uint256 digits;
353         while (temp != 0) {
354             digits++;
355             temp /= 10;
356         }
357         bytes memory buffer = new bytes(digits);
358         while (value != 0) {
359             digits -= 1;
360             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
361             value /= 10;
362         }
363         return string(buffer);
364     }
365 
366     /**
367      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
368      */
369     function toHexString(uint256 value) internal pure returns (string memory) {
370         if (value == 0) {
371             return "0x00";
372         }
373         uint256 temp = value;
374         uint256 length = 0;
375         while (temp != 0) {
376             length++;
377             temp >>= 8;
378         }
379         return toHexString(value, length);
380     }
381 
382     /**
383      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
384      */
385     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
386         bytes memory buffer = new bytes(2 * length + 2);
387         buffer[0] = "0";
388         buffer[1] = "x";
389         for (uint256 i = 2 * length + 1; i > 1; --i) {
390             buffer[i] = _HEX_SYMBOLS[value & 0xf];
391             value >>= 4;
392         }
393         require(value == 0, "Strings: hex length insufficient");
394         return string(buffer);
395     }
396 }
397 
398 
399 
400 // File: @openzeppelin/contracts@4.2.0/utils/Address.sol
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
533         return _verifyCallResult(success, returndata, errorMessage);
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
560         return _verifyCallResult(success, returndata, errorMessage);
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
587         return _verifyCallResult(success, returndata, errorMessage);
588     }
589 
590     function _verifyCallResult(
591         bool success,
592         bytes memory returndata,
593         string memory errorMessage
594     ) private pure returns (bytes memory) {
595         if (success) {
596             return returndata;
597         } else {
598             // Look for revert reason and bubble it up if present
599             if (returndata.length > 0) {
600                 // The easiest way to bubble the revert reason is using memory via assembly
601 
602                 assembly {
603                     let returndata_size := mload(returndata)
604                     revert(add(32, returndata), returndata_size)
605                 }
606             } else {
607                 revert(errorMessage);
608             }
609         }
610     }
611 }
612 
613 // File: @openzeppelin/contracts@4.2.0/token/ERC721/extensions/IERC721Metadata.sol
614 
615 
616 
617 pragma solidity ^0.8.0;
618 
619 
620 /**
621  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
622  * @dev See https://eips.ethereum.org/EIPS/eip-721
623  */
624 interface IERC721Metadata is IERC721 {
625     /**
626      * @dev Returns the token collection name.
627      */
628     function name() external view returns (string memory);
629 
630     /**
631      * @dev Returns the token collection symbol.
632      */
633     function symbol() external view returns (string memory);
634 
635     /**
636      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
637      */
638     function tokenURI(uint256 tokenId) external view returns (string memory);
639 }
640 
641 // File: @openzeppelin/contracts@4.2.0/token/ERC721/IERC721Receiver.sol
642 
643 
644 
645 pragma solidity ^0.8.0;
646 
647 /**
648  * @title ERC721 token receiver interface
649  * @dev Interface for any contract that wants to support safeTransfers
650  * from ERC721 asset contracts.
651  */
652 interface IERC721Receiver {
653     /**
654      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
655      * by `operator` from `from`, this function is called.
656      *
657      * It must return its Solidity selector to confirm the token transfer.
658      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
659      *
660      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
661      */
662     function onERC721Received(
663         address operator,
664         address from,
665         uint256 tokenId,
666         bytes calldata data
667     ) external returns (bytes4);
668 }
669 
670 
671 
672 // File: @openzeppelin/contracts@4.2.0/token/ERC721/ERC721.sol
673 
674 
675 
676 pragma solidity ^0.8.0;
677 
678 
679 
680 
681 
682 
683 
684 
685 /**
686  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
687  * the Metadata extension, but not including the Enumerable extension, which is available separately as
688  * {ERC721Enumerable}.
689  */
690 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
691     using Address for address;
692     using Strings for uint256;
693 
694     // Token name
695     string private _name;
696 
697     // Token symbol
698     string private _symbol;
699 
700     // Mapping from token ID to owner address
701     mapping(uint256 => address) private _owners;
702 
703     // Mapping owner address to token count
704     mapping(address => uint256) private _balances;
705 
706     // Mapping from token ID to approved address
707     mapping(uint256 => address) private _tokenApprovals;
708 
709     // Mapping from owner to operator approvals
710     mapping(address => mapping(address => bool)) private _operatorApprovals;
711 
712     /**
713      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
714      */
715     constructor(string memory name_, string memory symbol_) {
716         _name = name_;
717         _symbol = symbol_;
718     }
719 
720     /**
721      * @dev See {IERC165-supportsInterface}.
722      */
723     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
724         return
725             interfaceId == type(IERC721).interfaceId ||
726             interfaceId == type(IERC721Metadata).interfaceId ||
727             super.supportsInterface(interfaceId);
728     }
729 
730     /**
731      * @dev See {IERC721-balanceOf}.
732      */
733     function balanceOf(address owner) public view virtual override returns (uint256) {
734         require(owner != address(0), "ERC721: balance query for the zero address");
735         return _balances[owner];
736     }
737 
738     /**
739      * @dev See {IERC721-ownerOf}.
740      */
741     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
742         address owner = _owners[tokenId];
743         require(owner != address(0), "ERC721: owner query for nonexistent token");
744         return owner;
745     }
746 
747     /**
748      * @dev See {IERC721Metadata-name}.
749      */
750     function name() public view virtual override returns (string memory) {
751         return _name;
752     }
753 
754     /**
755      * @dev See {IERC721Metadata-symbol}.
756      */
757     function symbol() public view virtual override returns (string memory) {
758         return _symbol;
759     }
760 
761     /**
762      * @dev See {IERC721Metadata-tokenURI}.
763      */
764     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
765         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
766 
767         string memory baseURI = _baseURI();
768         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
769     }
770 
771     /**
772      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
773      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
774      * by default, can be overriden in child contracts.
775      */
776     function _baseURI() internal view virtual returns (string memory) {
777         return "";
778     }
779 
780     /**
781      * @dev See {IERC721-approve}.
782      */
783     function approve(address to, uint256 tokenId) public virtual override {
784         address owner = ERC721.ownerOf(tokenId);
785         require(to != owner, "ERC721: approval to current owner");
786 
787         require(
788             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
789             "ERC721: approve caller is not owner nor approved for all"
790         );
791 
792         _approve(to, tokenId);
793     }
794 
795     /**
796      * @dev See {IERC721-getApproved}.
797      */
798     function getApproved(uint256 tokenId) public view virtual override returns (address) {
799         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
800 
801         return _tokenApprovals[tokenId];
802     }
803 
804     /**
805      * @dev See {IERC721-setApprovalForAll}.
806      */
807     function setApprovalForAll(address operator, bool approved) public virtual override {
808         require(operator != _msgSender(), "ERC721: approve to caller");
809 
810         _operatorApprovals[_msgSender()][operator] = approved;
811         emit ApprovalForAll(_msgSender(), operator, approved);
812     }
813 
814     /**
815      * @dev See {IERC721-isApprovedForAll}.
816      */
817     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
818         return _operatorApprovals[owner][operator];
819     }
820 
821     /**
822      * @dev See {IERC721-transferFrom}.
823      */
824     function transferFrom(
825         address from,
826         address to,
827         uint256 tokenId
828     ) public virtual override {
829         //solhint-disable-next-line max-line-length
830         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
831 
832         _transfer(from, to, tokenId);
833     }
834 
835     /**
836      * @dev See {IERC721-safeTransferFrom}.
837      */
838     function safeTransferFrom(
839         address from,
840         address to,
841         uint256 tokenId
842     ) public virtual override {
843         safeTransferFrom(from, to, tokenId, "");
844     }
845 
846     /**
847      * @dev See {IERC721-safeTransferFrom}.
848      */
849     function safeTransferFrom(
850         address from,
851         address to,
852         uint256 tokenId,
853         bytes memory _data
854     ) public virtual override {
855         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
856         _safeTransfer(from, to, tokenId, _data);
857     }
858 
859     /**
860      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
861      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
862      *
863      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
864      *
865      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
866      * implement alternative mechanisms to perform token transfer, such as signature-based.
867      *
868      * Requirements:
869      *
870      * - `from` cannot be the zero address.
871      * - `to` cannot be the zero address.
872      * - `tokenId` token must exist and be owned by `from`.
873      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
874      *
875      * Emits a {Transfer} event.
876      */
877     function _safeTransfer(
878         address from,
879         address to,
880         uint256 tokenId,
881         bytes memory _data
882     ) internal virtual {
883         _transfer(from, to, tokenId);
884         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
885     }
886 
887     /**
888      * @dev Returns whether `tokenId` exists.
889      *
890      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
891      *
892      * Tokens start existing when they are minted (`_mint`),
893      * and stop existing when they are burned (`_burn`).
894      */
895     function _exists(uint256 tokenId) internal view virtual returns (bool) {
896         return _owners[tokenId] != address(0);
897     }
898 
899     /**
900      * @dev Returns whether `spender` is allowed to manage `tokenId`.
901      *
902      * Requirements:
903      *
904      * - `tokenId` must exist.
905      */
906     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
907         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
908         address owner = ERC721.ownerOf(tokenId);
909         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
910     }
911 
912     /**
913      * @dev Safely mints `tokenId` and transfers it to `to`.
914      *
915      * Requirements:
916      *
917      * - `tokenId` must not exist.
918      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
919      *
920      * Emits a {Transfer} event.
921      */
922     function _safeMint(address to, uint256 tokenId) internal virtual {
923         _safeMint(to, tokenId, "");
924     }
925 
926     /**
927      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
928      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
929      */
930     function _safeMint(
931         address to,
932         uint256 tokenId,
933         bytes memory _data
934     ) internal virtual {
935         _mint(to, tokenId);
936         require(
937             _checkOnERC721Received(address(0), to, tokenId, _data),
938             "ERC721: transfer to non ERC721Receiver implementer"
939         );
940     }
941 
942     /**
943      * @dev Mints `tokenId` and transfers it to `to`.
944      *
945      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
946      *
947      * Requirements:
948      *
949      * - `tokenId` must not exist.
950      * - `to` cannot be the zero address.
951      *
952      * Emits a {Transfer} event.
953      */
954     function _mint(address to, uint256 tokenId) internal virtual {
955         require(to != address(0), "ERC721: mint to the zero address");
956         require(!_exists(tokenId), "ERC721: token already minted");
957 
958         _beforeTokenTransfer(address(0), to, tokenId);
959 
960         _balances[to] += 1;
961         _owners[tokenId] = to;
962 
963         emit Transfer(address(0), to, tokenId);
964     }
965 
966     /**
967      * @dev Destroys `tokenId`.
968      * The approval is cleared when the token is burned.
969      *
970      * Requirements:
971      *
972      * - `tokenId` must exist.
973      *
974      * Emits a {Transfer} event.
975      */
976     function _burn(uint256 tokenId) internal virtual {
977         address owner = ERC721.ownerOf(tokenId);
978 
979         _beforeTokenTransfer(owner, address(0), tokenId);
980 
981         // Clear approvals
982         _approve(address(0), tokenId);
983 
984         _balances[owner] -= 1;
985         delete _owners[tokenId];
986 
987         emit Transfer(owner, address(0), tokenId);
988     }
989 
990     /**
991      * @dev Transfers `tokenId` from `from` to `to`.
992      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
993      *
994      * Requirements:
995      *
996      * - `to` cannot be the zero address.
997      * - `tokenId` token must be owned by `from`.
998      *
999      * Emits a {Transfer} event.
1000      */
1001     function _transfer(
1002         address from,
1003         address to,
1004         uint256 tokenId
1005     ) internal virtual {
1006         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1007         require(to != address(0), "ERC721: transfer to the zero address");
1008 
1009         _beforeTokenTransfer(from, to, tokenId);
1010 
1011         // Clear approvals from the previous owner
1012         _approve(address(0), tokenId);
1013 
1014         _balances[from] -= 1;
1015         _balances[to] += 1;
1016         _owners[tokenId] = to;
1017 
1018         emit Transfer(from, to, tokenId);
1019     }
1020 
1021     /**
1022      * @dev Approve `to` to operate on `tokenId`
1023      *
1024      * Emits a {Approval} event.
1025      */
1026     function _approve(address to, uint256 tokenId) internal virtual {
1027         _tokenApprovals[tokenId] = to;
1028         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1029     }
1030 
1031     /**
1032      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1033      * The call is not executed if the target address is not a contract.
1034      *
1035      * @param from address representing the previous owner of the given token ID
1036      * @param to target address that will receive the tokens
1037      * @param tokenId uint256 ID of the token to be transferred
1038      * @param _data bytes optional data to send along with the call
1039      * @return bool whether the call correctly returned the expected magic value
1040      */
1041     function _checkOnERC721Received(
1042         address from,
1043         address to,
1044         uint256 tokenId,
1045         bytes memory _data
1046     ) private returns (bool) {
1047         if (to.isContract()) {
1048             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1049                 return retval == IERC721Receiver(to).onERC721Received.selector;
1050             } catch (bytes memory reason) {
1051                 if (reason.length == 0) {
1052                     revert("ERC721: transfer to non ERC721Receiver implementer");
1053                 } else {
1054                     assembly {
1055                         revert(add(32, reason), mload(reason))
1056                     }
1057                 }
1058             }
1059         } else {
1060             return true;
1061         }
1062     }
1063 
1064     /**
1065      * @dev Hook that is called before any token transfer. This includes minting
1066      * and burning.
1067      *
1068      * Calling conditions:
1069      *
1070      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1071      * transferred to `to`.
1072      * - When `from` is zero, `tokenId` will be minted for `to`.
1073      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1074      * - `from` and `to` are never both zero.
1075      *
1076      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1077      */
1078     function _beforeTokenTransfer(
1079         address from,
1080         address to,
1081         uint256 tokenId
1082     ) internal virtual {}
1083 }
1084 
1085 // File: @openzeppelin/contracts@4.2.0/token/ERC721/extensions/ERC721Enumerable.sol
1086 
1087 
1088 
1089 pragma solidity ^0.8.0;
1090 
1091 
1092 
1093 /**
1094  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1095  * enumerability of all the token ids in the contract as well as all token ids owned by each
1096  * account.
1097  */
1098 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1099     // Mapping from owner to list of owned token IDs
1100     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1101 
1102     // Mapping from token ID to index of the owner tokens list
1103     mapping(uint256 => uint256) private _ownedTokensIndex;
1104 
1105     // Array with all token ids, used for enumeration
1106     uint256[] private _allTokens;
1107 
1108     // Mapping from token id to position in the allTokens array
1109     mapping(uint256 => uint256) private _allTokensIndex;
1110 
1111     /**
1112      * @dev See {IERC165-supportsInterface}.
1113      */
1114     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1115         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1116     }
1117 
1118     /**
1119      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1120      */
1121     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1122         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1123         return _ownedTokens[owner][index];
1124     }
1125 
1126     /**
1127      * @dev See {IERC721Enumerable-totalSupply}.
1128      */
1129     function totalSupply() public view virtual override returns (uint256) {
1130         return _allTokens.length;
1131     }
1132 
1133     /**
1134      * @dev See {IERC721Enumerable-tokenByIndex}.
1135      */
1136     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1137         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1138         return _allTokens[index];
1139     }
1140 
1141     /**
1142      * @dev Hook that is called before any token transfer. This includes minting
1143      * and burning.
1144      *
1145      * Calling conditions:
1146      *
1147      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1148      * transferred to `to`.
1149      * - When `from` is zero, `tokenId` will be minted for `to`.
1150      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1151      * - `from` cannot be the zero address.
1152      * - `to` cannot be the zero address.
1153      *
1154      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1155      */
1156     function _beforeTokenTransfer(
1157         address from,
1158         address to,
1159         uint256 tokenId
1160     ) internal virtual override {
1161         super._beforeTokenTransfer(from, to, tokenId);
1162 
1163         if (from == address(0)) {
1164             _addTokenToAllTokensEnumeration(tokenId);
1165         } else if (from != to) {
1166             _removeTokenFromOwnerEnumeration(from, tokenId);
1167         }
1168         if (to == address(0)) {
1169             _removeTokenFromAllTokensEnumeration(tokenId);
1170         } else if (to != from) {
1171             _addTokenToOwnerEnumeration(to, tokenId);
1172         }
1173     }
1174 
1175     /**
1176      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1177      * @param to address representing the new owner of the given token ID
1178      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1179      */
1180     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1181         uint256 length = ERC721.balanceOf(to);
1182         _ownedTokens[to][length] = tokenId;
1183         _ownedTokensIndex[tokenId] = length;
1184     }
1185 
1186     /**
1187      * @dev Private function to add a token to this extension's token tracking data structures.
1188      * @param tokenId uint256 ID of the token to be added to the tokens list
1189      */
1190     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1191         _allTokensIndex[tokenId] = _allTokens.length;
1192         _allTokens.push(tokenId);
1193     }
1194 
1195     /**
1196      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1197      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1198      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1199      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1200      * @param from address representing the previous owner of the given token ID
1201      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1202      */
1203     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1204         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1205         // then delete the last slot (swap and pop).
1206 
1207         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1208         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1209 
1210         // When the token to delete is the last token, the swap operation is unnecessary
1211         if (tokenIndex != lastTokenIndex) {
1212             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1213 
1214             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1215             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1216         }
1217 
1218         // This also deletes the contents at the last position of the array
1219         delete _ownedTokensIndex[tokenId];
1220         delete _ownedTokens[from][lastTokenIndex];
1221     }
1222 
1223     /**
1224      * @dev Private function to remove a token from this extension's token tracking data structures.
1225      * This has O(1) time complexity, but alters the order of the _allTokens array.
1226      * @param tokenId uint256 ID of the token to be removed from the tokens list
1227      */
1228     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1229         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1230         // then delete the last slot (swap and pop).
1231 
1232         uint256 lastTokenIndex = _allTokens.length - 1;
1233         uint256 tokenIndex = _allTokensIndex[tokenId];
1234 
1235         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1236         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1237         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1238         uint256 lastTokenId = _allTokens[lastTokenIndex];
1239 
1240         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1241         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1242 
1243         // This also deletes the contents at the last position of the array
1244         delete _allTokensIndex[tokenId];
1245         _allTokens.pop();
1246     }
1247 }
1248 
1249 // File: hobobeardclub90.sol
1250 
1251 pragma solidity ^0.8.2;
1252 
1253 
1254 
1255 contract HBC90 is ERC721Enumerable, Ownable {
1256     IERC721 firstEdition = IERC721(0xD6777fD56eEd434D6159A0B0d0BDE8274ab8Bf78);
1257     mapping(address => uint256) public mintPasses;
1258     string private baseURI;
1259     string public BEARDO_PROVENANCE;
1260     uint256 public MAX_BEARDOS = 9090;
1261     uint256 private unredeemedFE = 367;
1262     uint256 public totalReservations = 90;
1263     uint256 public price = 30000000000000000;
1264     bool public saleIsActive;
1265     bool public reservationIsActive = true;
1266     bool public resMintIsActive;
1267     
1268     constructor() ERC721("HoboBeardClub 90", "HBC90") {
1269         // Reservations for giveaways, team members and anyone who helped us along the way
1270         mintPasses[0x21D7F026395C8F1C02f1C483B86F8f493876C35c] = 90;
1271     }
1272     
1273     function mintMyBeardo(uint _count) public payable {
1274         require(saleIsActive, "Sale is not active");
1275         uint ts = totalSupply()+unredeemedFE;
1276         require(ts+_count+totalReservations <= MAX_BEARDOS, "Supply exceeded");
1277         require(_count <= 20, "Maximum per tx reached");
1278         require(msg.value >= price*_count, "Value below price");
1279         for(uint i = 0; i < _count; i++){
1280             _safeMint(msg.sender, ts+i);
1281         }
1282     }
1283     
1284     function printMyBeardo(uint id) public {
1285         require(firstEdition.ownerOf(id) == msg.sender, "You have to own this 1st gen beardo with this id");
1286         _safeMint(msg.sender, id);
1287         unredeemedFE -= 1;
1288     }
1289     
1290     function printMyBeardos(uint[] memory ids) public {
1291         for(uint i = 0; i < ids.length; i++){
1292             printMyBeardo(ids[i]);
1293         }
1294     }
1295 
1296     function tokenRedeemed(uint id) public view returns (bool) {
1297         require(id<367,"Out of bound");
1298         return _exists(id);
1299     }
1300     
1301     function activateSale() public onlyOwner {
1302         require(reservationIsActive == false, "Reservation is still active");
1303         saleIsActive = true;
1304     }
1305     
1306     function deactivateSale() public onlyOwner {
1307         saleIsActive = false;
1308     }
1309     
1310     function burnBeardos() public onlyOwner {
1311         MAX_BEARDOS = actualTotalSupply();
1312     }
1313 
1314     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1315         BEARDO_PROVENANCE = provenanceHash;
1316     }
1317     
1318     // Alternative against gas wars
1319     function reserveMyBeardo(uint _count) public payable {
1320         require(reservationIsActive, "Reservation is not active");
1321         uint tres = totalReservations+_count;
1322         require(tres <= 8723, "Supply exceeded");
1323         require(msg.value >= price*_count, "Value below price");
1324         require(_count<=40, "Maximum reservations");
1325         mintPasses[msg.sender] = _count;
1326         totalReservations = tres;
1327     }
1328     
1329     function mintReservations(uint _count) public {
1330         require(resMintIsActive, "Minting is not active yet");
1331         uint reservations = mintPasses[msg.sender];
1332         require(_count <= reservations, "Not enough reservations");
1333         mintPasses[msg.sender] = reservations-_count;
1334         uint ts = totalSupply()+unredeemedFE;
1335         for(uint i = 0; i < _count; i++){
1336             _safeMint(msg.sender, ts+i);
1337         }
1338         totalReservations -= _count; 
1339     }
1340     
1341     function removeReservations(address[] memory addresses) public onlyOwner {
1342         for(uint i = 0; i < addresses.length; i++){
1343             totalReservations -= mintPasses[addresses[i]];
1344             delete mintPasses[addresses[i]];
1345         }
1346     }
1347     
1348     function deactivateReservation() public onlyOwner {
1349         reservationIsActive = false;
1350     }
1351     
1352     function activateResMint() public onlyOwner {
1353         require(reservationIsActive == false, "Reservation is still active");
1354         resMintIsActive = true;
1355     }
1356     
1357     function deactivateResMint() public onlyOwner {
1358         resMintIsActive = false;
1359     }
1360     
1361     // incase of price changes or collaborations that include airdrops, probably never used
1362     function initDrop(address _address, uint _count) public onlyOwner {
1363         uint newtr = totalReservations+_count;
1364         require(newtr+totalSupply()+unredeemedFE <= MAX_BEARDOS);
1365         mintPasses[_address] += _count;
1366         totalReservations = newtr;
1367     }
1368     
1369     function distributeDrop(address[] memory addresses) public {
1370         require(resMintIsActive, "Minting is not active yet");
1371         uint reservations = mintPasses[msg.sender];
1372         require(addresses.length <= reservations, "More addresses than reservations");
1373         uint ts = totalSupply()+unredeemedFE;
1374         for(uint i = 0; i < addresses.length; i++) {
1375             _safeMint(addresses[i], ts+i);
1376         }
1377         mintPasses[msg.sender] = reservations-addresses.length;
1378         totalReservations -= addresses.length;
1379     }
1380     
1381     function setPrice(uint _newPrice) public onlyOwner() {
1382         price = _newPrice;
1383     }
1384     
1385     function withdrawAll() public payable onlyOwner {
1386         require(payable(0x25c9DE88361b2E83f7C82446C7CCca2a369327dd).send(address(this).balance));
1387     }
1388     
1389     function _baseURI() internal view override returns (string memory) {
1390       return baseURI;
1391     }
1392     
1393     function setBaseURI(string memory uri) public onlyOwner {
1394       baseURI = uri;
1395     }
1396     
1397     // accounting for reservations and unminted first edition mints
1398     function actualTotalSupply() public view returns (uint){
1399         return totalSupply()+unredeemedFE+totalReservations;
1400     }
1401 }