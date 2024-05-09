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
29 
30 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
31 
32 
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Interface of the ERC165 standard, as defined in the
38  * https://eips.ethereum.org/EIPS/eip-165[EIP].
39  *
40  * Implementers can declare support of contract interfaces, which can then be
41  * queried by others ({ERC165Checker}).
42  *
43  * For an implementation, see {ERC165}.
44  */
45 interface IERC165 {
46     /**
47      * @dev Returns true if this contract implements the interface defined by
48      * `interfaceId`. See the corresponding
49      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
50      * to learn more about how these ids are created.
51      *
52      * This function call must use less than 30 000 gas.
53      */
54     function supportsInterface(bytes4 interfaceId) external view returns (bool);
55 }
56 
57 
58 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
59 
60 
61 
62 pragma solidity ^0.8.0;
63 
64 
65 /**
66  * @dev Required interface of an ERC721 compliant contract.
67  */
68 interface IERC721 is IERC165 {
69     /**
70      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
73 
74     /**
75      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
76      */
77     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
78 
79     /**
80      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
81      */
82     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
83 
84     /**
85      * @dev Returns the number of tokens in ``owner``'s account.
86      */
87     function balanceOf(address owner) external view returns (uint256 balance);
88 
89     /**
90      * @dev Returns the owner of the `tokenId` token.
91      *
92      * Requirements:
93      *
94      * - `tokenId` must exist.
95      */
96     function ownerOf(uint256 tokenId) external view returns (address owner);
97 
98     /**
99      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
100      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
101      *
102      * Requirements:
103      *
104      * - `from` cannot be the zero address.
105      * - `to` cannot be the zero address.
106      * - `tokenId` token must exist and be owned by `from`.
107      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
108      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
109      *
110      * Emits a {Transfer} event.
111      */
112     function safeTransferFrom(
113         address from,
114         address to,
115         uint256 tokenId
116     ) external;
117 
118     /**
119      * @dev Transfers `tokenId` token from `from` to `to`.
120      *
121      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
122      *
123      * Requirements:
124      *
125      * - `from` cannot be the zero address.
126      * - `to` cannot be the zero address.
127      * - `tokenId` token must be owned by `from`.
128      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
129      *
130      * Emits a {Transfer} event.
131      */
132     function transferFrom(
133         address from,
134         address to,
135         uint256 tokenId
136     ) external;
137 
138     /**
139      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
140      * The approval is cleared when the token is transferred.
141      *
142      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
143      *
144      * Requirements:
145      *
146      * - The caller must own the token or be an approved operator.
147      * - `tokenId` must exist.
148      *
149      * Emits an {Approval} event.
150      */
151     function approve(address to, uint256 tokenId) external;
152 
153     /**
154      * @dev Returns the account approved for `tokenId` token.
155      *
156      * Requirements:
157      *
158      * - `tokenId` must exist.
159      */
160     function getApproved(uint256 tokenId) external view returns (address operator);
161 
162     /**
163      * @dev Approve or remove `operator` as an operator for the caller.
164      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
165      *
166      * Requirements:
167      *
168      * - The `operator` cannot be the caller.
169      *
170      * Emits an {ApprovalForAll} event.
171      */
172     function setApprovalForAll(address operator, bool _approved) external;
173 
174     /**
175      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
176      *
177      * See {setApprovalForAll}
178      */
179     function isApprovedForAll(address owner, address operator) external view returns (bool);
180 
181     /**
182      * @dev Safely transfers `tokenId` token from `from` to `to`.
183      *
184      * Requirements:
185      *
186      * - `from` cannot be the zero address.
187      * - `to` cannot be the zero address.
188      * - `tokenId` token must exist and be owned by `from`.
189      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
190      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
191      *
192      * Emits a {Transfer} event.
193      */
194     function safeTransferFrom(
195         address from,
196         address to,
197         uint256 tokenId,
198         bytes calldata data
199     ) external;
200 }
201 
202 
203 // File: @openzeppelin/contracts/access/Ownable.sol
204 
205 
206 
207 pragma solidity ^0.8.0;
208 
209 
210 /**
211  * @dev Contract module which provides a basic access control mechanism, where
212  * there is an account (an owner) that can be granted exclusive access to
213  * specific functions.
214  *
215  * By default, the owner account will be the one that deploys the contract. This
216  * can later be changed with {transferOwnership}.
217  *
218  * This module is used through inheritance. It will make available the modifier
219  * `onlyOwner`, which can be applied to your functions to restrict their use to
220  * the owner.
221  */
222 abstract contract Ownable is Context {
223     address private _owner;
224 
225     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
226 
227     /**
228      * @dev Initializes the contract setting the deployer as the initial owner.
229      */
230     constructor() {
231         _setOwner(_msgSender());
232     }
233 
234     /**
235      * @dev Returns the address of the current owner.
236      */
237     function owner() public view virtual returns (address) {
238         return _owner;
239     }
240 
241     /**
242      * @dev Throws if called by any account other than the owner.
243      */
244     modifier onlyOwner() {
245         require(owner() == _msgSender(), "Ownable: caller is not the owner");
246         _;
247     }
248 
249     /**
250      * @dev Leaves the contract without owner. It will not be possible to call
251      * `onlyOwner` functions anymore. Can only be called by the current owner.
252      *
253      * NOTE: Renouncing ownership will leave the contract without an owner,
254      * thereby removing any functionality that is only available to the owner.
255      */
256     function renounceOwnership() public virtual onlyOwner {
257         _setOwner(address(0));
258     }
259 
260     /**
261      * @dev Transfers ownership of the contract to a new account (`newOwner`).
262      * Can only be called by the current owner.
263      */
264     function transferOwnership(address newOwner) public virtual onlyOwner {
265         require(newOwner != address(0), "Ownable: new owner is the zero address");
266         _setOwner(newOwner);
267     }
268 
269     function _setOwner(address newOwner) private {
270         address oldOwner = _owner;
271         _owner = newOwner;
272         emit OwnershipTransferred(oldOwner, newOwner);
273     }
274 }
275 
276 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
277 
278 
279 
280 pragma solidity ^0.8.0;
281 
282 
283 /**
284  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
285  * @dev See https://eips.ethereum.org/EIPS/eip-721
286  */
287 interface IERC721Enumerable is IERC721 {
288     /**
289      * @dev Returns the total amount of tokens stored by the contract.
290      */
291     function totalSupply() external view returns (uint256);
292 
293     /**
294      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
295      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
296      */
297     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
298 
299     /**
300      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
301      * Use along with {totalSupply} to enumerate all tokens.
302      */
303     function tokenByIndex(uint256 index) external view returns (uint256);
304 }
305 
306 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
307 
308 
309 
310 pragma solidity ^0.8.0;
311 
312 
313 /**
314  * @dev Implementation of the {IERC165} interface.
315  *
316  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
317  * for the additional interface id that will be supported. For example:
318  *
319  * ```solidity
320  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
321  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
322  * }
323  * ```
324  *
325  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
326  */
327 abstract contract ERC165 is IERC165 {
328     /**
329      * @dev See {IERC165-supportsInterface}.
330      */
331     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
332         return interfaceId == type(IERC165).interfaceId;
333     }
334 }
335 
336 // File: @openzeppelin/contracts/utils/Strings.sol
337 
338 
339 
340 pragma solidity ^0.8.0;
341 
342 /**
343  * @dev String operations.
344  */
345 library Strings {
346     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
347 
348     /**
349      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
350      */
351     function toString(uint256 value) internal pure returns (string memory) {
352         // Inspired by OraclizeAPI's implementation - MIT licence
353         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
354 
355         if (value == 0) {
356             return "0";
357         }
358         uint256 temp = value;
359         uint256 digits;
360         while (temp != 0) {
361             digits++;
362             temp /= 10;
363         }
364         bytes memory buffer = new bytes(digits);
365         while (value != 0) {
366             digits -= 1;
367             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
368             value /= 10;
369         }
370         return string(buffer);
371     }
372 
373     /**
374      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
375      */
376     function toHexString(uint256 value) internal pure returns (string memory) {
377         if (value == 0) {
378             return "0x00";
379         }
380         uint256 temp = value;
381         uint256 length = 0;
382         while (temp != 0) {
383             length++;
384             temp >>= 8;
385         }
386         return toHexString(value, length);
387     }
388 
389     /**
390      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
391      */
392     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
393         bytes memory buffer = new bytes(2 * length + 2);
394         buffer[0] = "0";
395         buffer[1] = "x";
396         for (uint256 i = 2 * length + 1; i > 1; --i) {
397             buffer[i] = _HEX_SYMBOLS[value & 0xf];
398             value >>= 4;
399         }
400         require(value == 0, "Strings: hex length insufficient");
401         return string(buffer);
402     }
403 }
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
1257 // File: contracts/Create256Art.sol
1258 
1259 
1260 
1261 pragma solidity ^0.8.0;
1262 
1263 
1264 
1265 contract CREATE256ART is ERC721Enumerable, Ownable {
1266     using Strings for uint256;
1267 
1268     string public baseURI;
1269     string public baseExtension = ".json";
1270     uint256 public cost = 0.0256 ether;
1271     uint256 public maxSupply = 4096;
1272     uint256 public maxMintAmount = 16;
1273     bool public paused = false;
1274 
1275     constructor(
1276         string memory _name,
1277         string memory _symbol,
1278         string memory _initBaseURI
1279     ) ERC721(_name, _symbol) {
1280         setBaseURI(_initBaseURI);
1281 
1282         mint(msg.sender, 16);
1283         mint(msg.sender, 16);
1284     }
1285 
1286     // internal
1287     function _baseURI() internal view virtual override returns (string memory) {
1288         return baseURI;
1289     }
1290 
1291     // public
1292     function mint(address _to, uint256 _mintAmount) public payable {
1293         uint256 supply = totalSupply();
1294         require(!paused);
1295         require(_mintAmount > 0);
1296         require(_mintAmount <= maxMintAmount);
1297         require(supply + _mintAmount <= maxSupply);
1298 
1299         if (msg.sender != owner()) {
1300             require(msg.value >= cost * _mintAmount);
1301         }
1302 
1303         for (uint256 i = 1; i <= _mintAmount; i++) {
1304             _safeMint(_to, supply + i);
1305         }
1306     }
1307 
1308     function walletOfOwner(address _owner)
1309         public
1310         view
1311         returns (uint256[] memory)
1312     {
1313         uint256 ownerTokenCount = balanceOf(_owner);
1314         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1315         for (uint256 i; i < ownerTokenCount; i++) {
1316             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1317         }
1318         return tokenIds;
1319     }
1320 
1321     function tokenURI(uint256 tokenId)
1322         public
1323         view
1324         virtual
1325         override
1326         returns (string memory)
1327     {
1328         require(
1329             _exists(tokenId),
1330             "ERC721Metadata: URI query for nonexistent token"
1331         );
1332 
1333         string memory currentBaseURI = _baseURI();
1334         return
1335             bytes(currentBaseURI).length > 0
1336                 ? string(
1337                     abi.encodePacked(
1338                         currentBaseURI,
1339                         tokenId.toString(),
1340                         baseExtension
1341                     )
1342                 )
1343                 : "";
1344     }
1345 
1346     //only owner
1347     function setCost(uint256 _newCost) public onlyOwner {
1348         cost = _newCost;
1349     }
1350 
1351     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1352         maxMintAmount = _newmaxMintAmount;
1353     }
1354 
1355     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1356         baseURI = _newBaseURI;
1357     }
1358 
1359     function setBaseExtension(string memory _newBaseExtension)
1360         public
1361         onlyOwner
1362     {
1363         baseExtension = _newBaseExtension;
1364     }
1365 
1366     function pause(bool _state) public onlyOwner {
1367         paused = _state;
1368     }
1369 
1370     function withdraw() public payable onlyOwner {
1371         require(payable(msg.sender).send(address(this).balance));
1372     }
1373 }