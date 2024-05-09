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
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 
32 pragma solidity ^0.8.0;
33 
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * By default, the owner account will be the one that deploys the contract. This
41  * can later be changed with {transferOwnership}.
42  *
43  * This module is used through inheritance. It will make available the modifier
44  * `onlyOwner`, which can be applied to your functions to restrict their use to
45  * the owner.
46  */
47 abstract contract Ownable is Context {
48     address private _owner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     /**
53      * @dev Initializes the contract setting the deployer as the initial owner.
54      */
55     constructor() {
56         _setOwner(_msgSender());
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view virtual returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(owner() == _msgSender(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         _setOwner(address(0));
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         _setOwner(newOwner);
92     }
93 
94     function _setOwner(address newOwner) private {
95         address oldOwner = _owner;
96         _owner = newOwner;
97         emit OwnershipTransferred(oldOwner, newOwner);
98     }
99 }
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
402 // File: @openzeppelin/contracts/utils/Address.sol
403 
404 
405 
406 pragma solidity ^0.8.0;
407 
408 /**
409  * @dev Collection of functions related to the address type
410  */
411 library Address {
412     /**
413      * @dev Returns true if `account` is a contract.
414      *
415      * [IMPORTANT]
416      * ====
417      * It is unsafe to assume that an address for which this function returns
418      * false is an externally-owned account (EOA) and not a contract.
419      *
420      * Among others, `isContract` will return false for the following
421      * types of addresses:
422      *
423      *  - an externally-owned account
424      *  - a contract in construction
425      *  - an address where a contract will be created
426      *  - an address where a contract lived, but was destroyed
427      * ====
428      */
429     function isContract(address account) internal view returns (bool) {
430         // This method relies on extcodesize, which returns 0 for contracts in
431         // construction, since the code is only stored at the end of the
432         // constructor execution.
433 
434         uint256 size;
435         assembly {
436             size := extcodesize(account)
437         }
438         return size > 0;
439     }
440 
441     /**
442      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
443      * `recipient`, forwarding all available gas and reverting on errors.
444      *
445      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
446      * of certain opcodes, possibly making contracts go over the 2300 gas limit
447      * imposed by `transfer`, making them unable to receive funds via
448      * `transfer`. {sendValue} removes this limitation.
449      *
450      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
451      *
452      * IMPORTANT: because control is transferred to `recipient`, care must be
453      * taken to not create reentrancy vulnerabilities. Consider using
454      * {ReentrancyGuard} or the
455      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
456      */
457     function sendValue(address payable recipient, uint256 amount) internal {
458         require(address(this).balance >= amount, "Address: insufficient balance");
459 
460         (bool success, ) = recipient.call{value: amount}("");
461         require(success, "Address: unable to send value, recipient may have reverted");
462     }
463 
464     /**
465      * @dev Performs a Solidity function call using a low level `call`. A
466      * plain `call` is an unsafe replacement for a function call: use this
467      * function instead.
468      *
469      * If `target` reverts with a revert reason, it is bubbled up by this
470      * function (like regular Solidity function calls).
471      *
472      * Returns the raw returned data. To convert to the expected return value,
473      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
474      *
475      * Requirements:
476      *
477      * - `target` must be a contract.
478      * - calling `target` with `data` must not revert.
479      *
480      * _Available since v3.1._
481      */
482     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
483         return functionCall(target, data, "Address: low-level call failed");
484     }
485 
486     /**
487      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
488      * `errorMessage` as a fallback revert reason when `target` reverts.
489      *
490      * _Available since v3.1._
491      */
492     function functionCall(
493         address target,
494         bytes memory data,
495         string memory errorMessage
496     ) internal returns (bytes memory) {
497         return functionCallWithValue(target, data, 0, errorMessage);
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
502      * but also transferring `value` wei to `target`.
503      *
504      * Requirements:
505      *
506      * - the calling contract must have an ETH balance of at least `value`.
507      * - the called Solidity function must be `payable`.
508      *
509      * _Available since v3.1._
510      */
511     function functionCallWithValue(
512         address target,
513         bytes memory data,
514         uint256 value
515     ) internal returns (bytes memory) {
516         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
517     }
518 
519     /**
520      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
521      * with `errorMessage` as a fallback revert reason when `target` reverts.
522      *
523      * _Available since v3.1._
524      */
525     function functionCallWithValue(
526         address target,
527         bytes memory data,
528         uint256 value,
529         string memory errorMessage
530     ) internal returns (bytes memory) {
531         require(address(this).balance >= value, "Address: insufficient balance for call");
532         require(isContract(target), "Address: call to non-contract");
533 
534         (bool success, bytes memory returndata) = target.call{value: value}(data);
535         return verifyCallResult(success, returndata, errorMessage);
536     }
537 
538     /**
539      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
540      * but performing a static call.
541      *
542      * _Available since v3.3._
543      */
544     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
545         return functionStaticCall(target, data, "Address: low-level static call failed");
546     }
547 
548     /**
549      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
550      * but performing a static call.
551      *
552      * _Available since v3.3._
553      */
554     function functionStaticCall(
555         address target,
556         bytes memory data,
557         string memory errorMessage
558     ) internal view returns (bytes memory) {
559         require(isContract(target), "Address: static call to non-contract");
560 
561         (bool success, bytes memory returndata) = target.staticcall(data);
562         return verifyCallResult(success, returndata, errorMessage);
563     }
564 
565     /**
566      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
567      * but performing a delegate call.
568      *
569      * _Available since v3.4._
570      */
571     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
572         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
577      * but performing a delegate call.
578      *
579      * _Available since v3.4._
580      */
581     function functionDelegateCall(
582         address target,
583         bytes memory data,
584         string memory errorMessage
585     ) internal returns (bytes memory) {
586         require(isContract(target), "Address: delegate call to non-contract");
587 
588         (bool success, bytes memory returndata) = target.delegatecall(data);
589         return verifyCallResult(success, returndata, errorMessage);
590     }
591 
592     /**
593      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
594      * revert reason using the provided one.
595      *
596      * _Available since v4.3._
597      */
598     function verifyCallResult(
599         bool success,
600         bytes memory returndata,
601         string memory errorMessage
602     ) internal pure returns (bytes memory) {
603         if (success) {
604             return returndata;
605         } else {
606             // Look for revert reason and bubble it up if present
607             if (returndata.length > 0) {
608                 // The easiest way to bubble the revert reason is using memory via assembly
609 
610                 assembly {
611                     let returndata_size := mload(returndata)
612                     revert(add(32, returndata), returndata_size)
613                 }
614             } else {
615                 revert(errorMessage);
616             }
617         }
618     }
619 }
620 
621 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
622 
623 
624 
625 pragma solidity ^0.8.0;
626 
627 
628 /**
629  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
630  * @dev See https://eips.ethereum.org/EIPS/eip-721
631  */
632 interface IERC721Metadata is IERC721 {
633     /**
634      * @dev Returns the token collection name.
635      */
636     function name() external view returns (string memory);
637 
638     /**
639      * @dev Returns the token collection symbol.
640      */
641     function symbol() external view returns (string memory);
642 
643     /**
644      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
645      */
646     function tokenURI(uint256 tokenId) external view returns (string memory);
647 }
648 
649 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
650 
651 
652 
653 pragma solidity ^0.8.0;
654 
655 /**
656  * @title ERC721 token receiver interface
657  * @dev Interface for any contract that wants to support safeTransfers
658  * from ERC721 asset contracts.
659  */
660 interface IERC721Receiver {
661     /**
662      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
663      * by `operator` from `from`, this function is called.
664      *
665      * It must return its Solidity selector to confirm the token transfer.
666      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
667      *
668      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
669      */
670     function onERC721Received(
671         address operator,
672         address from,
673         uint256 tokenId,
674         bytes calldata data
675     ) external returns (bytes4);
676 }
677 
678 
679 
680 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
681 
682 
683 
684 pragma solidity ^0.8.0;
685 
686 
687 
688 
689 
690 
691 
692 
693 /**
694  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
695  * the Metadata extension, but not including the Enumerable extension, which is available separately as
696  * {ERC721Enumerable}.
697  */
698 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
699     using Address for address;
700     using Strings for uint256;
701 
702     // Token name
703     string private _name;
704 
705     // Token symbol
706     string private _symbol;
707 
708     // Mapping from token ID to owner address
709     mapping(uint256 => address) private _owners;
710 
711     // Mapping owner address to token count
712     mapping(address => uint256) private _balances;
713 
714     // Mapping from token ID to approved address
715     mapping(uint256 => address) private _tokenApprovals;
716 
717     // Mapping from owner to operator approvals
718     mapping(address => mapping(address => bool)) private _operatorApprovals;
719 
720     /**
721      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
722      */
723     constructor(string memory name_, string memory symbol_) {
724         _name = name_;
725         _symbol = symbol_;
726     }
727 
728     /**
729      * @dev See {IERC165-supportsInterface}.
730      */
731     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
732         return
733             interfaceId == type(IERC721).interfaceId ||
734             interfaceId == type(IERC721Metadata).interfaceId ||
735             super.supportsInterface(interfaceId);
736     }
737 
738     /**
739      * @dev See {IERC721-balanceOf}.
740      */
741     function balanceOf(address owner) public view virtual override returns (uint256) {
742         require(owner != address(0), "ERC721: balance query for the zero address");
743         return _balances[owner];
744     }
745 
746     /**
747      * @dev See {IERC721-ownerOf}.
748      */
749     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
750         address owner = _owners[tokenId];
751         require(owner != address(0), "ERC721: owner query for nonexistent token");
752         return owner;
753     }
754 
755     /**
756      * @dev See {IERC721Metadata-name}.
757      */
758     function name() public view virtual override returns (string memory) {
759         return _name;
760     }
761 
762     /**
763      * @dev See {IERC721Metadata-symbol}.
764      */
765     function symbol() public view virtual override returns (string memory) {
766         return _symbol;
767     }
768 
769     /**
770      * @dev See {IERC721Metadata-tokenURI}.
771      */
772     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
773         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
774 
775         string memory baseURI = _baseURI();
776         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
777     }
778 
779     /**
780      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
781      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
782      * by default, can be overriden in child contracts.
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
806     function getApproved(uint256 tokenId) public view virtual override returns (address) {
807         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
808 
809         return _tokenApprovals[tokenId];
810     }
811 
812     /**
813      * @dev See {IERC721-setApprovalForAll}.
814      */
815     function setApprovalForAll(address operator, bool approved) public virtual override {
816         require(operator != _msgSender(), "ERC721: approve to caller");
817 
818         _operatorApprovals[_msgSender()][operator] = approved;
819         emit ApprovalForAll(_msgSender(), operator, approved);
820     }
821 
822     /**
823      * @dev See {IERC721-isApprovedForAll}.
824      */
825     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
826         return _operatorApprovals[owner][operator];
827     }
828 
829     /**
830      * @dev See {IERC721-transferFrom}.
831      */
832     function transferFrom(
833         address from,
834         address to,
835         uint256 tokenId
836     ) public virtual override {
837         //solhint-disable-next-line max-line-length
838         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
839 
840         _transfer(from, to, tokenId);
841     }
842 
843     /**
844      * @dev See {IERC721-safeTransferFrom}.
845      */
846     function safeTransferFrom(
847         address from,
848         address to,
849         uint256 tokenId
850     ) public virtual override {
851         safeTransferFrom(from, to, tokenId, "");
852     }
853 
854     /**
855      * @dev See {IERC721-safeTransferFrom}.
856      */
857     function safeTransferFrom(
858         address from,
859         address to,
860         uint256 tokenId,
861         bytes memory _data
862     ) public virtual override {
863         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
864         _safeTransfer(from, to, tokenId, _data);
865     }
866 
867     /**
868      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
869      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
870      *
871      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
872      *
873      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
874      * implement alternative mechanisms to perform token transfer, such as signature-based.
875      *
876      * Requirements:
877      *
878      * - `from` cannot be the zero address.
879      * - `to` cannot be the zero address.
880      * - `tokenId` token must exist and be owned by `from`.
881      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
882      *
883      * Emits a {Transfer} event.
884      */
885     function _safeTransfer(
886         address from,
887         address to,
888         uint256 tokenId,
889         bytes memory _data
890     ) internal virtual {
891         _transfer(from, to, tokenId);
892         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
893     }
894 
895     /**
896      * @dev Returns whether `tokenId` exists.
897      *
898      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
899      *
900      * Tokens start existing when they are minted (`_mint`),
901      * and stop existing when they are burned (`_burn`).
902      */
903     function _exists(uint256 tokenId) internal view virtual returns (bool) {
904         return _owners[tokenId] != address(0);
905     }
906 
907     /**
908      * @dev Returns whether `spender` is allowed to manage `tokenId`.
909      *
910      * Requirements:
911      *
912      * - `tokenId` must exist.
913      */
914     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
915         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
916         address owner = ERC721.ownerOf(tokenId);
917         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
918     }
919 
920     /**
921      * @dev Safely mints `tokenId` and transfers it to `to`.
922      *
923      * Requirements:
924      *
925      * - `tokenId` must not exist.
926      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
927      *
928      * Emits a {Transfer} event.
929      */
930     function _safeMint(address to, uint256 tokenId) internal virtual {
931         _safeMint(to, tokenId, "");
932     }
933 
934     /**
935      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
936      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
937      */
938     function _safeMint(
939         address to,
940         uint256 tokenId,
941         bytes memory _data
942     ) internal virtual {
943         _mint(to, tokenId);
944         require(
945             _checkOnERC721Received(address(0), to, tokenId, _data),
946             "ERC721: transfer to non ERC721Receiver implementer"
947         );
948     }
949 
950     /**
951      * @dev Mints `tokenId` and transfers it to `to`.
952      *
953      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
954      *
955      * Requirements:
956      *
957      * - `tokenId` must not exist.
958      * - `to` cannot be the zero address.
959      *
960      * Emits a {Transfer} event.
961      */
962     function _mint(address to, uint256 tokenId) internal virtual {
963         require(to != address(0), "ERC721: mint to the zero address");
964         require(!_exists(tokenId), "ERC721: token already minted");
965 
966         _beforeTokenTransfer(address(0), to, tokenId);
967 
968         _balances[to] += 1;
969         _owners[tokenId] = to;
970 
971         emit Transfer(address(0), to, tokenId);
972     }
973 
974     /**
975      * @dev Destroys `tokenId`.
976      * The approval is cleared when the token is burned.
977      *
978      * Requirements:
979      *
980      * - `tokenId` must exist.
981      *
982      * Emits a {Transfer} event.
983      */
984     function _burn(uint256 tokenId) internal virtual {
985         address owner = ERC721.ownerOf(tokenId);
986 
987         _beforeTokenTransfer(owner, address(0), tokenId);
988 
989         // Clear approvals
990         _approve(address(0), tokenId);
991 
992         _balances[owner] -= 1;
993         delete _owners[tokenId];
994 
995         emit Transfer(owner, address(0), tokenId);
996     }
997 
998     /**
999      * @dev Transfers `tokenId` from `from` to `to`.
1000      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1001      *
1002      * Requirements:
1003      *
1004      * - `to` cannot be the zero address.
1005      * - `tokenId` token must be owned by `from`.
1006      *
1007      * Emits a {Transfer} event.
1008      */
1009     function _transfer(
1010         address from,
1011         address to,
1012         uint256 tokenId
1013     ) internal virtual {
1014         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1015         require(to != address(0), "ERC721: transfer to the zero address");
1016 
1017         _beforeTokenTransfer(from, to, tokenId);
1018 
1019         // Clear approvals from the previous owner
1020         _approve(address(0), tokenId);
1021 
1022         _balances[from] -= 1;
1023         _balances[to] += 1;
1024         _owners[tokenId] = to;
1025 
1026         emit Transfer(from, to, tokenId);
1027     }
1028 
1029     /**
1030      * @dev Approve `to` to operate on `tokenId`
1031      *
1032      * Emits a {Approval} event.
1033      */
1034     function _approve(address to, uint256 tokenId) internal virtual {
1035         _tokenApprovals[tokenId] = to;
1036         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1037     }
1038 
1039     /**
1040      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1041      * The call is not executed if the target address is not a contract.
1042      *
1043      * @param from address representing the previous owner of the given token ID
1044      * @param to target address that will receive the tokens
1045      * @param tokenId uint256 ID of the token to be transferred
1046      * @param _data bytes optional data to send along with the call
1047      * @return bool whether the call correctly returned the expected magic value
1048      */
1049     function _checkOnERC721Received(
1050         address from,
1051         address to,
1052         uint256 tokenId,
1053         bytes memory _data
1054     ) private returns (bool) {
1055         if (to.isContract()) {
1056             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1057                 return retval == IERC721Receiver.onERC721Received.selector;
1058             } catch (bytes memory reason) {
1059                 if (reason.length == 0) {
1060                     revert("ERC721: transfer to non ERC721Receiver implementer");
1061                 } else {
1062                     assembly {
1063                         revert(add(32, reason), mload(reason))
1064                     }
1065                 }
1066             }
1067         } else {
1068             return true;
1069         }
1070     }
1071 
1072     /**
1073      * @dev Hook that is called before any token transfer. This includes minting
1074      * and burning.
1075      *
1076      * Calling conditions:
1077      *
1078      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1079      * transferred to `to`.
1080      * - When `from` is zero, `tokenId` will be minted for `to`.
1081      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1082      * - `from` and `to` are never both zero.
1083      *
1084      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1085      */
1086     function _beforeTokenTransfer(
1087         address from,
1088         address to,
1089         uint256 tokenId
1090     ) internal virtual {}
1091 }
1092 
1093 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1094 
1095 
1096 
1097 pragma solidity ^0.8.0;
1098 
1099 
1100 
1101 /**
1102  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1103  * enumerability of all the token ids in the contract as well as all token ids owned by each
1104  * account.
1105  */
1106 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1107     // Mapping from owner to list of owned token IDs
1108     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1109 
1110     // Mapping from token ID to index of the owner tokens list
1111     mapping(uint256 => uint256) private _ownedTokensIndex;
1112 
1113     // Array with all token ids, used for enumeration
1114     uint256[] private _allTokens;
1115 
1116     // Mapping from token id to position in the allTokens array
1117     mapping(uint256 => uint256) private _allTokensIndex;
1118 
1119     /**
1120      * @dev See {IERC165-supportsInterface}.
1121      */
1122     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1123         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1124     }
1125 
1126     /**
1127      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1128      */
1129     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1130         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1131         return _ownedTokens[owner][index];
1132     }
1133 
1134     /**
1135      * @dev See {IERC721Enumerable-totalSupply}.
1136      */
1137     function totalSupply() public view virtual override returns (uint256) {
1138         return _allTokens.length;
1139     }
1140 
1141     /**
1142      * @dev See {IERC721Enumerable-tokenByIndex}.
1143      */
1144     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1145         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1146         return _allTokens[index];
1147     }
1148 
1149     /**
1150      * @dev Hook that is called before any token transfer. This includes minting
1151      * and burning.
1152      *
1153      * Calling conditions:
1154      *
1155      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1156      * transferred to `to`.
1157      * - When `from` is zero, `tokenId` will be minted for `to`.
1158      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1159      * - `from` cannot be the zero address.
1160      * - `to` cannot be the zero address.
1161      *
1162      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1163      */
1164     function _beforeTokenTransfer(
1165         address from,
1166         address to,
1167         uint256 tokenId
1168     ) internal virtual override {
1169         super._beforeTokenTransfer(from, to, tokenId);
1170 
1171         if (from == address(0)) {
1172             _addTokenToAllTokensEnumeration(tokenId);
1173         } else if (from != to) {
1174             _removeTokenFromOwnerEnumeration(from, tokenId);
1175         }
1176         if (to == address(0)) {
1177             _removeTokenFromAllTokensEnumeration(tokenId);
1178         } else if (to != from) {
1179             _addTokenToOwnerEnumeration(to, tokenId);
1180         }
1181     }
1182 
1183     /**
1184      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1185      * @param to address representing the new owner of the given token ID
1186      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1187      */
1188     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1189         uint256 length = ERC721.balanceOf(to);
1190         _ownedTokens[to][length] = tokenId;
1191         _ownedTokensIndex[tokenId] = length;
1192     }
1193 
1194     /**
1195      * @dev Private function to add a token to this extension's token tracking data structures.
1196      * @param tokenId uint256 ID of the token to be added to the tokens list
1197      */
1198     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1199         _allTokensIndex[tokenId] = _allTokens.length;
1200         _allTokens.push(tokenId);
1201     }
1202 
1203     /**
1204      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1205      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1206      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1207      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1208      * @param from address representing the previous owner of the given token ID
1209      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1210      */
1211     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1212         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1213         // then delete the last slot (swap and pop).
1214 
1215         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1216         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1217 
1218         // When the token to delete is the last token, the swap operation is unnecessary
1219         if (tokenIndex != lastTokenIndex) {
1220             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1221 
1222             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1223             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1224         }
1225 
1226         // This also deletes the contents at the last position of the array
1227         delete _ownedTokensIndex[tokenId];
1228         delete _ownedTokens[from][lastTokenIndex];
1229     }
1230 
1231     /**
1232      * @dev Private function to remove a token from this extension's token tracking data structures.
1233      * This has O(1) time complexity, but alters the order of the _allTokens array.
1234      * @param tokenId uint256 ID of the token to be removed from the tokens list
1235      */
1236     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1237         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1238         // then delete the last slot (swap and pop).
1239 
1240         uint256 lastTokenIndex = _allTokens.length - 1;
1241         uint256 tokenIndex = _allTokensIndex[tokenId];
1242 
1243         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1244         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1245         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1246         uint256 lastTokenId = _allTokens[lastTokenIndex];
1247 
1248         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1249         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1250 
1251         // This also deletes the contents at the last position of the array
1252         delete _allTokensIndex[tokenId];
1253         _allTokens.pop();
1254     }
1255 }
1256 
1257 // File: contracts/UnusualWhales.sol
1258 
1259 
1260 
1261 /**
1262  
1263  *Unusual Whales (WHALE)
1264  *
1265  * 6,969 Unusual Whales in the Sea
1266 */
1267 
1268 pragma solidity ^0.8.0;
1269 
1270 
1271 
1272 
1273 contract UnusualWhales is ERC721Enumerable, Ownable {
1274   using Strings for uint256;
1275 
1276   string public baseURI;
1277   uint256 public cost = 0.069 ether;
1278   uint256 public maxSupply = 6969;
1279   uint256 public maxMintAmount = 20;
1280   bool public paused = false;
1281   mapping(address => bool) public whitelisted;
1282 
1283   constructor(
1284     string memory _name,
1285     string memory _symbol,
1286     string memory _initBaseURI
1287   ) ERC721(_name, _symbol) {
1288      
1289     setBaseURI(_initBaseURI);
1290    
1291     mint(msg.sender, 20);
1292   }
1293 
1294   // internal
1295   function _baseURI() internal view virtual override returns (string memory) {
1296     return baseURI;
1297   }
1298 
1299   // public
1300   function mint(address _to, uint256 _mintAmount) public payable {
1301     uint256 supply = totalSupply();
1302     require(!paused);
1303     require(_mintAmount > 0);
1304     require(_mintAmount <= maxMintAmount);
1305     require(supply + _mintAmount <= maxSupply);
1306 
1307     if (msg.sender != owner()) {
1308         if(whitelisted[msg.sender] != true) {
1309           require(msg.value >= cost * _mintAmount);
1310         }
1311     }
1312 
1313     for (uint256 i = 1; i <= _mintAmount; i++) {
1314       _safeMint(_to, supply + i);
1315     }
1316   }
1317 
1318   function walletOfOwner(address _owner)
1319     public
1320     view
1321     returns (uint256[] memory)
1322   {
1323     uint256 ownerTokenCount = balanceOf(_owner);
1324     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1325     for (uint256 i; i < ownerTokenCount; i++) {
1326       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1327     }
1328     return tokenIds;
1329   }
1330 
1331   function tokenURI(uint256 tokenId)
1332     public
1333     view
1334     virtual
1335     override
1336     returns (string memory)
1337   {
1338     require(
1339       _exists(tokenId),
1340       "ERC721Metadata: URI query for nonexistent token"
1341     );
1342 
1343     string memory currentBaseURI = _baseURI();
1344     return bytes(currentBaseURI).length > 0
1345         ? string(abi.encodePacked(currentBaseURI, (tokenId-1).toString()))
1346         : "";
1347   }
1348 
1349   //only owner
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
1362 
1363   function pause(bool _state) public onlyOwner {
1364     paused = _state;
1365   }
1366  
1367  function whitelistUser(address _user) public onlyOwner {
1368     whitelisted[_user] = true;
1369   }
1370  
1371   function removeWhitelistUser(address _user) public onlyOwner {
1372     whitelisted[_user] = false;
1373   }
1374 
1375   function withdraw() public payable onlyOwner {
1376     require(payable(msg.sender).send(address(this).balance));
1377   }
1378 }