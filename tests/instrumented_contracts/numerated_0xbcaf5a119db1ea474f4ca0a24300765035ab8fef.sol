1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Context.sol
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
27 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
28 
29 
30 
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @dev Interface of the ERC165 standard, as defined in the
35  * https://eips.ethereum.org/EIPS/eip-165[EIP].
36  *
37  * Implementers can declare support of contract interfaces, which can then be
38  * queried by others ({ERC165Checker}).
39  *
40  * For an implementation, see {ERC165}.
41  */
42 interface IERC165 {
43     /**
44      * @dev Returns true if this contract implements the interface defined by
45      * `interfaceId`. See the corresponding
46      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
47      * to learn more about how these ids are created.
48      *
49      * This function call must use less than 30 000 gas.
50      */
51     function supportsInterface(bytes4 interfaceId) external view returns (bool);
52 }
53 
54 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
55 
56 
57 
58 pragma solidity ^0.8.0;
59 
60 
61 /**
62  * @dev Required interface of an ERC721 compliant contract.
63  */
64 interface IERC721 is IERC165 {
65     /**
66      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
67      */
68     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
69 
70     /**
71      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
72      */
73     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
74 
75     /**
76      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
77      */
78     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
79 
80     /**
81      * @dev Returns the number of tokens in ``owner``'s account.
82      */
83     function balanceOf(address owner) external view returns (uint256 balance);
84 
85     /**
86      * @dev Returns the owner of the `tokenId` token.
87      *
88      * Requirements:
89      *
90      * - `tokenId` must exist.
91      */
92     function ownerOf(uint256 tokenId) external view returns (address owner);
93 
94     /**
95      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
96      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
97      *
98      * Requirements:
99      *
100      * - `from` cannot be the zero address.
101      * - `to` cannot be the zero address.
102      * - `tokenId` token must exist and be owned by `from`.
103      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
104      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
105      *
106      * Emits a {Transfer} event.
107      */
108     function safeTransferFrom(
109         address from,
110         address to,
111         uint256 tokenId
112     ) external;
113 
114     /**
115      * @dev Transfers `tokenId` token from `from` to `to`.
116      *
117      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
118      *
119      * Requirements:
120      *
121      * - `from` cannot be the zero address.
122      * - `to` cannot be the zero address.
123      * - `tokenId` token must be owned by `from`.
124      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
125      *
126      * Emits a {Transfer} event.
127      */
128     function transferFrom(
129         address from,
130         address to,
131         uint256 tokenId
132     ) external;
133 
134     /**
135      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
136      * The approval is cleared when the token is transferred.
137      *
138      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
139      *
140      * Requirements:
141      *
142      * - The caller must own the token or be an approved operator.
143      * - `tokenId` must exist.
144      *
145      * Emits an {Approval} event.
146      */
147     function approve(address to, uint256 tokenId) external;
148 
149     /**
150      * @dev Returns the account approved for `tokenId` token.
151      *
152      * Requirements:
153      *
154      * - `tokenId` must exist.
155      */
156     function getApproved(uint256 tokenId) external view returns (address operator);
157 
158     /**
159      * @dev Approve or remove `operator` as an operator for the caller.
160      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
161      *
162      * Requirements:
163      *
164      * - The `operator` cannot be the caller.
165      *
166      * Emits an {ApprovalForAll} event.
167      */
168     function setApprovalForAll(address operator, bool _approved) external;
169 
170     /**
171      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
172      *
173      * See {setApprovalForAll}
174      */
175     function isApprovedForAll(address owner, address operator) external view returns (bool);
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
198 
199 // File: @openzeppelin/contracts/access/Ownable.sol
200 
201 
202 
203 pragma solidity ^0.8.0;
204 
205 
206 /**
207  * @dev Contract module which provides a basic access control mechanism, where
208  * there is an account (an owner) that can be granted exclusive access to
209  * specific functions.
210  *
211  * By default, the owner account will be the one that deploys the contract. This
212  * can later be changed with {transferOwnership}.
213  *
214  * This module is used through inheritance. It will make available the modifier
215  * `onlyOwner`, which can be applied to your functions to restrict their use to
216  * the owner.
217  */
218 abstract contract Ownable is Context {
219     address private _owner;
220 
221     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
222 
223     /**
224      * @dev Initializes the contract setting the deployer as the initial owner.
225      */
226     constructor() {
227         _setOwner(_msgSender());
228     }
229 
230     /**
231      * @dev Returns the address of the current owner.
232      */
233     function owner() public view virtual returns (address) {
234         return _owner;
235     }
236 
237     /**
238      * @dev Throws if called by any account other than the owner.
239      */
240     modifier onlyOwner() {
241         require(owner() == _msgSender(), "Ownable: caller is not the owner");
242         _;
243     }
244 
245     /**
246      * @dev Leaves the contract without owner. It will not be possible to call
247      * `onlyOwner` functions anymore. Can only be called by the current owner.
248      *
249      * NOTE: Renouncing ownership will leave the contract without an owner,
250      * thereby removing any functionality that is only available to the owner.
251      */
252     function renounceOwnership() public virtual onlyOwner {
253         _setOwner(address(0));
254     }
255 
256     /**
257      * @dev Transfers ownership of the contract to a new account (`newOwner`).
258      * Can only be called by the current owner.
259      */
260     function transferOwnership(address newOwner) public virtual onlyOwner {
261         require(newOwner != address(0), "Ownable: new owner is the zero address");
262         _setOwner(newOwner);
263     }
264 
265     function _setOwner(address newOwner) private {
266         address oldOwner = _owner;
267         _owner = newOwner;
268         emit OwnershipTransferred(oldOwner, newOwner);
269     }
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
302 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
303 
304 
305 
306 pragma solidity ^0.8.0;
307 
308 
309 /**
310  * @dev Implementation of the {IERC165} interface.
311  *
312  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
313  * for the additional interface id that will be supported. For example:
314  *
315  * ```solidity
316  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
317  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
318  * }
319  * ```
320  *
321  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
322  */
323 abstract contract ERC165 is IERC165 {
324     /**
325      * @dev See {IERC165-supportsInterface}.
326      */
327     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
328         return interfaceId == type(IERC165).interfaceId;
329     }
330 }
331 
332 // File: @openzeppelin/contracts/utils/Strings.sol
333 
334 
335 
336 pragma solidity ^0.8.0;
337 
338 /**
339  * @dev String operations.
340  */
341 library Strings {
342     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
343 
344     /**
345      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
346      */
347     function toString(uint256 value) internal pure returns (string memory) {
348         // Inspired by OraclizeAPI's implementation - MIT licence
349         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
350 
351         if (value == 0) {
352             return "0";
353         }
354         uint256 temp = value;
355         uint256 digits;
356         while (temp != 0) {
357             digits++;
358             temp /= 10;
359         }
360         bytes memory buffer = new bytes(digits);
361         while (value != 0) {
362             digits -= 1;
363             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
364             value /= 10;
365         }
366         return string(buffer);
367     }
368 
369     /**
370      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
371      */
372     function toHexString(uint256 value) internal pure returns (string memory) {
373         if (value == 0) {
374             return "0x00";
375         }
376         uint256 temp = value;
377         uint256 length = 0;
378         while (temp != 0) {
379             length++;
380             temp >>= 8;
381         }
382         return toHexString(value, length);
383     }
384 
385     /**
386      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
387      */
388     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
389         bytes memory buffer = new bytes(2 * length + 2);
390         buffer[0] = "0";
391         buffer[1] = "x";
392         for (uint256 i = 2 * length + 1; i > 1; --i) {
393             buffer[i] = _HEX_SYMBOLS[value & 0xf];
394             value >>= 4;
395         }
396         require(value == 0, "Strings: hex length insufficient");
397         return string(buffer);
398     }
399 }
400 
401 
402 
403 // File: @openzeppelin/contracts/utils/Address.sol
404 
405 
406 
407 pragma solidity ^0.8.0;
408 
409 /**
410  * @dev Collection of functions related to the address type
411  */
412 library Address {
413     /**
414      * @dev Returns true if `account` is a contract.
415      *
416      * [IMPORTANT]
417      * ====
418      * It is unsafe to assume that an address for which this function returns
419      * false is an externally-owned account (EOA) and not a contract.
420      *
421      * Among others, `isContract` will return false for the following
422      * types of addresses:
423      *
424      *  - an externally-owned account
425      *  - a contract in construction
426      *  - an address where a contract will be created
427      *  - an address where a contract lived, but was destroyed
428      * ====
429      */
430     function isContract(address account) internal view returns (bool) {
431         // This method relies on extcodesize, which returns 0 for contracts in
432         // construction, since the code is only stored at the end of the
433         // constructor execution.
434 
435         uint256 size;
436         assembly {
437             size := extcodesize(account)
438         }
439         return size > 0;
440     }
441 
442     /**
443      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
444      * `recipient`, forwarding all available gas and reverting on errors.
445      *
446      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
447      * of certain opcodes, possibly making contracts go over the 2300 gas limit
448      * imposed by `transfer`, making them unable to receive funds via
449      * `transfer`. {sendValue} removes this limitation.
450      *
451      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
452      *
453      * IMPORTANT: because control is transferred to `recipient`, care must be
454      * taken to not create reentrancy vulnerabilities. Consider using
455      * {ReentrancyGuard} or the
456      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
457      */
458     function sendValue(address payable recipient, uint256 amount) internal {
459         require(address(this).balance >= amount, "Address: insufficient balance");
460 
461         (bool success, ) = recipient.call{value: amount}("");
462         require(success, "Address: unable to send value, recipient may have reverted");
463     }
464 
465     /**
466      * @dev Performs a Solidity function call using a low level `call`. A
467      * plain `call` is an unsafe replacement for a function call: use this
468      * function instead.
469      *
470      * If `target` reverts with a revert reason, it is bubbled up by this
471      * function (like regular Solidity function calls).
472      *
473      * Returns the raw returned data. To convert to the expected return value,
474      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
475      *
476      * Requirements:
477      *
478      * - `target` must be a contract.
479      * - calling `target` with `data` must not revert.
480      *
481      * _Available since v3.1._
482      */
483     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
484         return functionCall(target, data, "Address: low-level call failed");
485     }
486 
487     /**
488      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
489      * `errorMessage` as a fallback revert reason when `target` reverts.
490      *
491      * _Available since v3.1._
492      */
493     function functionCall(
494         address target,
495         bytes memory data,
496         string memory errorMessage
497     ) internal returns (bytes memory) {
498         return functionCallWithValue(target, data, 0, errorMessage);
499     }
500 
501     /**
502      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
503      * but also transferring `value` wei to `target`.
504      *
505      * Requirements:
506      *
507      * - the calling contract must have an ETH balance of at least `value`.
508      * - the called Solidity function must be `payable`.
509      *
510      * _Available since v3.1._
511      */
512     function functionCallWithValue(
513         address target,
514         bytes memory data,
515         uint256 value
516     ) internal returns (bytes memory) {
517         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
522      * with `errorMessage` as a fallback revert reason when `target` reverts.
523      *
524      * _Available since v3.1._
525      */
526     function functionCallWithValue(
527         address target,
528         bytes memory data,
529         uint256 value,
530         string memory errorMessage
531     ) internal returns (bytes memory) {
532         require(address(this).balance >= value, "Address: insufficient balance for call");
533         require(isContract(target), "Address: call to non-contract");
534 
535         (bool success, bytes memory returndata) = target.call{value: value}(data);
536         return verifyCallResult(success, returndata, errorMessage);
537     }
538 
539     /**
540      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
541      * but performing a static call.
542      *
543      * _Available since v3.3._
544      */
545     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
546         return functionStaticCall(target, data, "Address: low-level static call failed");
547     }
548 
549     /**
550      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
551      * but performing a static call.
552      *
553      * _Available since v3.3._
554      */
555     function functionStaticCall(
556         address target,
557         bytes memory data,
558         string memory errorMessage
559     ) internal view returns (bytes memory) {
560         require(isContract(target), "Address: static call to non-contract");
561 
562         (bool success, bytes memory returndata) = target.staticcall(data);
563         return verifyCallResult(success, returndata, errorMessage);
564     }
565 
566     /**
567      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
568      * but performing a delegate call.
569      *
570      * _Available since v3.4._
571      */
572     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
573         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
574     }
575 
576     /**
577      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
578      * but performing a delegate call.
579      *
580      * _Available since v3.4._
581      */
582     function functionDelegateCall(
583         address target,
584         bytes memory data,
585         string memory errorMessage
586     ) internal returns (bytes memory) {
587         require(isContract(target), "Address: delegate call to non-contract");
588 
589         (bool success, bytes memory returndata) = target.delegatecall(data);
590         return verifyCallResult(success, returndata, errorMessage);
591     }
592 
593     /**
594      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
595      * revert reason using the provided one.
596      *
597      * _Available since v4.3._
598      */
599     function verifyCallResult(
600         bool success,
601         bytes memory returndata,
602         string memory errorMessage
603     ) internal pure returns (bytes memory) {
604         if (success) {
605             return returndata;
606         } else {
607             // Look for revert reason and bubble it up if present
608             if (returndata.length > 0) {
609                 // The easiest way to bubble the revert reason is using memory via assembly
610 
611                 assembly {
612                     let returndata_size := mload(returndata)
613                     revert(add(32, returndata), returndata_size)
614                 }
615             } else {
616                 revert(errorMessage);
617             }
618         }
619     }
620 }
621 
622 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
623 
624 
625 
626 pragma solidity ^0.8.0;
627 
628 
629 /**
630  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
631  * @dev See https://eips.ethereum.org/EIPS/eip-721
632  */
633 interface IERC721Metadata is IERC721 {
634     /**
635      * @dev Returns the token collection name.
636      */
637     function name() external view returns (string memory);
638 
639     /**
640      * @dev Returns the token collection symbol.
641      */
642     function symbol() external view returns (string memory);
643 
644     /**
645      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
646      */
647     function tokenURI(uint256 tokenId) external view returns (string memory);
648 }
649 
650 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
651 
652 
653 
654 pragma solidity ^0.8.0;
655 
656 /**
657  * @title ERC721 token receiver interface
658  * @dev Interface for any contract that wants to support safeTransfers
659  * from ERC721 asset contracts.
660  */
661 interface IERC721Receiver {
662     /**
663      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
664      * by `operator` from `from`, this function is called.
665      *
666      * It must return its Solidity selector to confirm the token transfer.
667      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
668      *
669      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
670      */
671     function onERC721Received(
672         address operator,
673         address from,
674         uint256 tokenId,
675         bytes calldata data
676     ) external returns (bytes4);
677 }
678 
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
1258 
1259 
1260 pragma solidity ^0.8.0;
1261 
1262 
1263 
1264 contract SmartContract is ERC721Enumerable, Ownable {
1265   using Strings for uint256;
1266 
1267   string public baseURI;
1268   string public baseExtension = ".json";
1269   uint256 public cost = 0.019 ether;
1270   uint256 public maxSupply = 5002;
1271   uint256 public maxMintAmount = 20;
1272   bool public paused = false;
1273 
1274   constructor(
1275     string memory _name,
1276     string memory _symbol,
1277     string memory _initBaseURI
1278   ) ERC721(_name, _symbol) {
1279     setBaseURI(_initBaseURI);
1280 
1281     mint(msg.sender, 2);
1282   }
1283 
1284   // internal
1285   function _baseURI() internal view virtual override returns (string memory) {
1286     return baseURI;
1287   }
1288 
1289   // public
1290   function mint(address _to, uint256 _mintAmount) public payable {
1291     uint256 supply = totalSupply();
1292     require(!paused);
1293     require(_mintAmount > 0);
1294     require(_mintAmount <= maxMintAmount);
1295     require(supply + _mintAmount <= maxSupply);
1296 
1297     if (msg.sender != owner()) {
1298       require(msg.value >= cost * _mintAmount);
1299     }
1300 
1301     for (uint256 i = 1; i <= _mintAmount; i++) {
1302       _safeMint(_to, supply + i);
1303     }
1304   }
1305 
1306   function walletOfOwner(address _owner)
1307     public
1308     view
1309     returns (uint256[] memory)
1310   {
1311     uint256 ownerTokenCount = balanceOf(_owner);
1312     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1313     for (uint256 i; i < ownerTokenCount; i++) {
1314       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1315     }
1316     return tokenIds;
1317   }
1318 
1319   function tokenURI(uint256 tokenId)
1320     public
1321     view
1322     virtual
1323     override
1324     returns (string memory)
1325   {
1326     require(
1327       _exists(tokenId),
1328       "ERC721Metadata: URI query for nonexistent token"
1329     );
1330 
1331     string memory currentBaseURI = _baseURI();
1332     return
1333       bytes(currentBaseURI).length > 0
1334         ? string(
1335           abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)
1336         )
1337         : "";
1338   }
1339 
1340   //only owner
1341   function setCost(uint256 _newCost) public onlyOwner() {
1342     cost = _newCost;
1343   }
1344 
1345   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
1346     maxMintAmount = _newmaxMintAmount;
1347   }
1348 
1349   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1350     baseURI = _newBaseURI;
1351   }
1352 
1353   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1354     baseExtension = _newBaseExtension;
1355   }
1356 
1357   function pause(bool _state) public onlyOwner {
1358     paused = _state;
1359   }
1360 
1361   function withdraw() public payable onlyOwner {
1362     require(payable(msg.sender).send(address(this).balance));
1363   }
1364 }