1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 interface IERC165 {
17     /**
18      * @dev Returns true if this contract implements the interface defined by
19      * `interfaceId`. See the corresponding
20      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
21      * to learn more about how these ids are created.
22      *
23      * This function call must use less than 30 000 gas.
24      */
25     function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
29 
30 
31 pragma solidity ^0.8.0;
32 
33 
34 /**
35  * @dev Required interface of an ERC721 compliant contract.
36  */
37 interface IERC721 is IERC165 {
38     /**
39      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
40      */
41     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
42 
43     /**
44      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
45      */
46     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
47 
48     /**
49      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
50      */
51     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
52 
53     /**
54      * @dev Returns the number of tokens in ``owner``'s account.
55      */
56     function balanceOf(address owner) external view returns (uint256 balance);
57 
58     /**
59      * @dev Returns the owner of the `tokenId` token.
60      *
61      * Requirements:
62      *
63      * - `tokenId` must exist.
64      */
65     function ownerOf(uint256 tokenId) external view returns (address owner);
66 
67     /**
68      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
69      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
70      *
71      * Requirements:
72      *
73      * - `from` cannot be the zero address.
74      * - `to` cannot be the zero address.
75      * - `tokenId` token must exist and be owned by `from`.
76      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
77      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
78      *
79      * Emits a {Transfer} event.
80      */
81     function safeTransferFrom(
82         address from,
83         address to,
84         uint256 tokenId
85     ) external;
86 
87     /**
88      * @dev Transfers `tokenId` token from `from` to `to`.
89      *
90      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
91      *
92      * Requirements:
93      *
94      * - `from` cannot be the zero address.
95      * - `to` cannot be the zero address.
96      * - `tokenId` token must be owned by `from`.
97      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
98      *
99      * Emits a {Transfer} event.
100      */
101     function transferFrom(
102         address from,
103         address to,
104         uint256 tokenId
105     ) external;
106 
107     /**
108      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
109      * The approval is cleared when the token is transferred.
110      *
111      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
112      *
113      * Requirements:
114      *
115      * - The caller must own the token or be an approved operator.
116      * - `tokenId` must exist.
117      *
118      * Emits an {Approval} event.
119      */
120     function approve(address to, uint256 tokenId) external;
121 
122     /**
123      * @dev Returns the account approved for `tokenId` token.
124      *
125      * Requirements:
126      *
127      * - `tokenId` must exist.
128      */
129     function getApproved(uint256 tokenId) external view returns (address operator);
130 
131     /**
132      * @dev Approve or remove `operator` as an operator for the caller.
133      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
134      *
135      * Requirements:
136      *
137      * - The `operator` cannot be the caller.
138      *
139      * Emits an {ApprovalForAll} event.
140      */
141     function setApprovalForAll(address operator, bool _approved) external;
142 
143     /**
144      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
145      *
146      * See {setApprovalForAll}
147      */
148     function isApprovedForAll(address owner, address operator) external view returns (bool);
149 
150     /**
151      * @dev Safely transfers `tokenId` token from `from` to `to`.
152      *
153      * Requirements:
154      *
155      * - `from` cannot be the zero address.
156      * - `to` cannot be the zero address.
157      * - `tokenId` token must exist and be owned by `from`.
158      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
159      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
160      *
161      * Emits a {Transfer} event.
162      */
163     function safeTransferFrom(
164         address from,
165         address to,
166         uint256 tokenId,
167         bytes calldata data
168     ) external;
169 }
170 
171 // File: contracts/interfaces/IHuxleyComics.sol
172 
173 pragma solidity 0.8.6;
174 
175  
176 interface IHuxleyComics is IERC721 {
177     struct Issue {
178         uint256 price;
179         uint256 goldSupplyLeft;
180         uint256 firstEditionSupplyLeft;
181         uint256 holographicSupplyLeft;
182         uint256 serialNumberToMintGold;
183         uint256 serialNumberToMintFirstEdition;
184         uint256 serialNumberToMintHolographic;
185         uint256 maxPayableMintBatch;
186         string uri;
187         bool exist;
188     }
189 
190     struct Token {
191         uint256 serialNumber;
192         uint256 issueNumber;
193         TokenType tokenType;
194     }
195 
196     enum TokenType {FirstEdition, Gold, Holographic}
197 
198     function safeMint(address _to) external returns (uint256);
199 
200     function getCurrentIssue() external returns (uint256 _currentIssue);
201     function getCurrentPrice() external returns (uint256 _currentPrice);
202     function getCurrentMaxPayableMintBatch() external returns (uint256 _currentMaxPayableMintBatch);
203 
204     function createNewIssue(
205         uint256 _price,
206         uint256 _goldSupply,
207         uint256 _firstEditionSupply,
208         uint256 _holographicSupply,
209         uint256 _startSerialNumberGold,
210         uint256 _startSerialNumberFirstEdition,
211         uint256 _startSerialNumberHolographic,
212         uint256 _maxPaybleMintBatch,
213         string memory _uri
214     ) external;
215 
216     function getIssue(uint256 _issueNumber) external returns (Issue memory _issue);
217 
218     function getToken(uint256 _tokenId) external returns (Token memory _token);
219 
220     function setTokenDetails(uint256 _tokenId, TokenType _tokenType) external;
221 
222     function setBaseURI(uint256 _issueNumber, string memory _uri) external;
223 
224     function setCanBurn(bool _canBurn) external;
225 }
226 
227 // File: @openzeppelin/contracts/utils/Context.sol
228 
229 
230 pragma solidity ^0.8.0;
231 
232 /*
233  * @dev Provides information about the current execution context, including the
234  * sender of the transaction and its data. While these are generally available
235  * via msg.sender and msg.data, they should not be accessed in such a direct
236  * manner, since when dealing with meta-transactions the account sending and
237  * paying for execution may not be the actual sender (as far as an application
238  * is concerned).
239  *
240  * This contract is only required for intermediate, library-like contracts.
241  */
242 abstract contract Context {
243     function _msgSender() internal view virtual returns (address) {
244         return msg.sender;
245     }
246 
247     function _msgData() internal view virtual returns (bytes calldata) {
248         return msg.data;
249     }
250 }
251 
252 // File: @openzeppelin/contracts/access/Ownable.sol
253 
254 
255 pragma solidity ^0.8.0;
256 
257 
258 /**
259  * @dev Contract module which provides a basic access control mechanism, where
260  * there is an account (an owner) that can be granted exclusive access to
261  * specific functions.
262  *
263  * By default, the owner account will be the one that deploys the contract. This
264  * can later be changed with {transferOwnership}.
265  *
266  * This module is used through inheritance. It will make available the modifier
267  * `onlyOwner`, which can be applied to your functions to restrict their use to
268  * the owner.
269  */
270 abstract contract Ownable is Context {
271     address private _owner;
272 
273     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
274 
275     /**
276      * @dev Initializes the contract setting the deployer as the initial owner.
277      */
278     constructor() {
279         _setOwner(_msgSender());
280     }
281 
282     /**
283      * @dev Returns the address of the current owner.
284      */
285     function owner() public view virtual returns (address) {
286         return _owner;
287     }
288 
289     /**
290      * @dev Throws if called by any account other than the owner.
291      */
292     modifier onlyOwner() {
293         require(owner() == _msgSender(), "Ownable: caller is not the owner");
294         _;
295     }
296 
297     /**
298      * @dev Leaves the contract without owner. It will not be possible to call
299      * `onlyOwner` functions anymore. Can only be called by the current owner.
300      *
301      * NOTE: Renouncing ownership will leave the contract without an owner,
302      * thereby removing any functionality that is only available to the owner.
303      */
304     function renounceOwnership() public virtual onlyOwner {
305         _setOwner(address(0));
306     }
307 
308     /**
309      * @dev Transfers ownership of the contract to a new account (`newOwner`).
310      * Can only be called by the current owner.
311      */
312     function transferOwnership(address newOwner) public virtual onlyOwner {
313         require(newOwner != address(0), "Ownable: new owner is the zero address");
314         _setOwner(newOwner);
315     }
316 
317     function _setOwner(address newOwner) private {
318         address oldOwner = _owner;
319         _owner = newOwner;
320         emit OwnershipTransferred(oldOwner, newOwner);
321     }
322 }
323 
324 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
325 
326 
327 pragma solidity ^0.8.0;
328 
329 /**
330  * @title ERC721 token receiver interface
331  * @dev Interface for any contract that wants to support safeTransfers
332  * from ERC721 asset contracts.
333  */
334 interface IERC721Receiver {
335     /**
336      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
337      * by `operator` from `from`, this function is called.
338      *
339      * It must return its Solidity selector to confirm the token transfer.
340      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
341      *
342      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
343      */
344     function onERC721Received(
345         address operator,
346         address from,
347         uint256 tokenId,
348         bytes calldata data
349     ) external returns (bytes4);
350 }
351 
352 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
353 
354 
355 pragma solidity ^0.8.0;
356 
357 
358 /**
359  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
360  * @dev See https://eips.ethereum.org/EIPS/eip-721
361  */
362 interface IERC721Metadata is IERC721 {
363     /**
364      * @dev Returns the token collection name.
365      */
366     function name() external view returns (string memory);
367 
368     /**
369      * @dev Returns the token collection symbol.
370      */
371     function symbol() external view returns (string memory);
372 
373     /**
374      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
375      */
376     function tokenURI(uint256 tokenId) external view returns (string memory);
377 }
378 
379 // File: @openzeppelin/contracts/utils/Address.sol
380 
381 
382 pragma solidity ^0.8.0;
383 
384 /**
385  * @dev Collection of functions related to the address type
386  */
387 library Address {
388     /**
389      * @dev Returns true if `account` is a contract.
390      *
391      * [IMPORTANT]
392      * ====
393      * It is unsafe to assume that an address for which this function returns
394      * false is an externally-owned account (EOA) and not a contract.
395      *
396      * Among others, `isContract` will return false for the following
397      * types of addresses:
398      *
399      *  - an externally-owned account
400      *  - a contract in construction
401      *  - an address where a contract will be created
402      *  - an address where a contract lived, but was destroyed
403      * ====
404      */
405     function isContract(address account) internal view returns (bool) {
406         // This method relies on extcodesize, which returns 0 for contracts in
407         // construction, since the code is only stored at the end of the
408         // constructor execution.
409 
410         uint256 size;
411         assembly {
412             size := extcodesize(account)
413         }
414         return size > 0;
415     }
416 
417     /**
418      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
419      * `recipient`, forwarding all available gas and reverting on errors.
420      *
421      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
422      * of certain opcodes, possibly making contracts go over the 2300 gas limit
423      * imposed by `transfer`, making them unable to receive funds via
424      * `transfer`. {sendValue} removes this limitation.
425      *
426      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
427      *
428      * IMPORTANT: because control is transferred to `recipient`, care must be
429      * taken to not create reentrancy vulnerabilities. Consider using
430      * {ReentrancyGuard} or the
431      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
432      */
433     function sendValue(address payable recipient, uint256 amount) internal {
434         require(address(this).balance >= amount, "Address: insufficient balance");
435 
436         (bool success, ) = recipient.call{value: amount}("");
437         require(success, "Address: unable to send value, recipient may have reverted");
438     }
439 
440     /**
441      * @dev Performs a Solidity function call using a low level `call`. A
442      * plain `call` is an unsafe replacement for a function call: use this
443      * function instead.
444      *
445      * If `target` reverts with a revert reason, it is bubbled up by this
446      * function (like regular Solidity function calls).
447      *
448      * Returns the raw returned data. To convert to the expected return value,
449      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
450      *
451      * Requirements:
452      *
453      * - `target` must be a contract.
454      * - calling `target` with `data` must not revert.
455      *
456      * _Available since v3.1._
457      */
458     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
459         return functionCall(target, data, "Address: low-level call failed");
460     }
461 
462     /**
463      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
464      * `errorMessage` as a fallback revert reason when `target` reverts.
465      *
466      * _Available since v3.1._
467      */
468     function functionCall(
469         address target,
470         bytes memory data,
471         string memory errorMessage
472     ) internal returns (bytes memory) {
473         return functionCallWithValue(target, data, 0, errorMessage);
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
478      * but also transferring `value` wei to `target`.
479      *
480      * Requirements:
481      *
482      * - the calling contract must have an ETH balance of at least `value`.
483      * - the called Solidity function must be `payable`.
484      *
485      * _Available since v3.1._
486      */
487     function functionCallWithValue(
488         address target,
489         bytes memory data,
490         uint256 value
491     ) internal returns (bytes memory) {
492         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
493     }
494 
495     /**
496      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
497      * with `errorMessage` as a fallback revert reason when `target` reverts.
498      *
499      * _Available since v3.1._
500      */
501     function functionCallWithValue(
502         address target,
503         bytes memory data,
504         uint256 value,
505         string memory errorMessage
506     ) internal returns (bytes memory) {
507         require(address(this).balance >= value, "Address: insufficient balance for call");
508         require(isContract(target), "Address: call to non-contract");
509 
510         (bool success, bytes memory returndata) = target.call{value: value}(data);
511         return _verifyCallResult(success, returndata, errorMessage);
512     }
513 
514     /**
515      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
516      * but performing a static call.
517      *
518      * _Available since v3.3._
519      */
520     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
521         return functionStaticCall(target, data, "Address: low-level static call failed");
522     }
523 
524     /**
525      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
526      * but performing a static call.
527      *
528      * _Available since v3.3._
529      */
530     function functionStaticCall(
531         address target,
532         bytes memory data,
533         string memory errorMessage
534     ) internal view returns (bytes memory) {
535         require(isContract(target), "Address: static call to non-contract");
536 
537         (bool success, bytes memory returndata) = target.staticcall(data);
538         return _verifyCallResult(success, returndata, errorMessage);
539     }
540 
541     /**
542      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
543      * but performing a delegate call.
544      *
545      * _Available since v3.4._
546      */
547     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
548         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
549     }
550 
551     /**
552      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
553      * but performing a delegate call.
554      *
555      * _Available since v3.4._
556      */
557     function functionDelegateCall(
558         address target,
559         bytes memory data,
560         string memory errorMessage
561     ) internal returns (bytes memory) {
562         require(isContract(target), "Address: delegate call to non-contract");
563 
564         (bool success, bytes memory returndata) = target.delegatecall(data);
565         return _verifyCallResult(success, returndata, errorMessage);
566     }
567 
568     function _verifyCallResult(
569         bool success,
570         bytes memory returndata,
571         string memory errorMessage
572     ) private pure returns (bytes memory) {
573         if (success) {
574             return returndata;
575         } else {
576             // Look for revert reason and bubble it up if present
577             if (returndata.length > 0) {
578                 // The easiest way to bubble the revert reason is using memory via assembly
579 
580                 assembly {
581                     let returndata_size := mload(returndata)
582                     revert(add(32, returndata), returndata_size)
583                 }
584             } else {
585                 revert(errorMessage);
586             }
587         }
588     }
589 }
590 
591 // File: @openzeppelin/contracts/utils/Strings.sol
592 
593 
594 pragma solidity ^0.8.0;
595 
596 /**
597  * @dev String operations.
598  */
599 library Strings {
600     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
601 
602     /**
603      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
604      */
605     function toString(uint256 value) internal pure returns (string memory) {
606         // Inspired by OraclizeAPI's implementation - MIT licence
607         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
608 
609         if (value == 0) {
610             return "0";
611         }
612         uint256 temp = value;
613         uint256 digits;
614         while (temp != 0) {
615             digits++;
616             temp /= 10;
617         }
618         bytes memory buffer = new bytes(digits);
619         while (value != 0) {
620             digits -= 1;
621             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
622             value /= 10;
623         }
624         return string(buffer);
625     }
626 
627     /**
628      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
629      */
630     function toHexString(uint256 value) internal pure returns (string memory) {
631         if (value == 0) {
632             return "0x00";
633         }
634         uint256 temp = value;
635         uint256 length = 0;
636         while (temp != 0) {
637             length++;
638             temp >>= 8;
639         }
640         return toHexString(value, length);
641     }
642 
643     /**
644      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
645      */
646     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
647         bytes memory buffer = new bytes(2 * length + 2);
648         buffer[0] = "0";
649         buffer[1] = "x";
650         for (uint256 i = 2 * length + 1; i > 1; --i) {
651             buffer[i] = _HEX_SYMBOLS[value & 0xf];
652             value >>= 4;
653         }
654         require(value == 0, "Strings: hex length insufficient");
655         return string(buffer);
656     }
657 }
658 
659 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
660 
661 
662 pragma solidity ^0.8.0;
663 
664 
665 /**
666  * @dev Implementation of the {IERC165} interface.
667  *
668  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
669  * for the additional interface id that will be supported. For example:
670  *
671  * ```solidity
672  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
673  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
674  * }
675  * ```
676  *
677  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
678  */
679 abstract contract ERC165 is IERC165 {
680     /**
681      * @dev See {IERC165-supportsInterface}.
682      */
683     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
684         return interfaceId == type(IERC165).interfaceId;
685     }
686 }
687 
688 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
689 
690 
691 pragma solidity ^0.8.0;
692 
693 
694 
695 
696 
697 
698 
699 
700 /**
701  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
702  * the Metadata extension, but not including the Enumerable extension, which is available separately as
703  * {ERC721Enumerable}.
704  */
705 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
706     using Address for address;
707     using Strings for uint256;
708 
709     // Token name
710     string private _name;
711 
712     // Token symbol
713     string private _symbol;
714 
715     // Mapping from token ID to owner address
716     mapping(uint256 => address) private _owners;
717 
718     // Mapping owner address to token count
719     mapping(address => uint256) private _balances;
720 
721     // Mapping from token ID to approved address
722     mapping(uint256 => address) private _tokenApprovals;
723 
724     // Mapping from owner to operator approvals
725     mapping(address => mapping(address => bool)) private _operatorApprovals;
726 
727     /**
728      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
729      */
730     constructor(string memory name_, string memory symbol_) {
731         _name = name_;
732         _symbol = symbol_;
733     }
734 
735     /**
736      * @dev See {IERC165-supportsInterface}.
737      */
738     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
739         return
740             interfaceId == type(IERC721).interfaceId ||
741             interfaceId == type(IERC721Metadata).interfaceId ||
742             super.supportsInterface(interfaceId);
743     }
744 
745     /**
746      * @dev See {IERC721-balanceOf}.
747      */
748     function balanceOf(address owner) public view virtual override returns (uint256) {
749         require(owner != address(0), "ERC721: balance query for the zero address");
750         return _balances[owner];
751     }
752 
753     /**
754      * @dev See {IERC721-ownerOf}.
755      */
756     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
757         address owner = _owners[tokenId];
758         require(owner != address(0), "ERC721: owner query for nonexistent token");
759         return owner;
760     }
761 
762     /**
763      * @dev See {IERC721Metadata-name}.
764      */
765     function name() public view virtual override returns (string memory) {
766         return _name;
767     }
768 
769     /**
770      * @dev See {IERC721Metadata-symbol}.
771      */
772     function symbol() public view virtual override returns (string memory) {
773         return _symbol;
774     }
775 
776     /**
777      * @dev See {IERC721Metadata-tokenURI}.
778      */
779     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
780         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
781 
782         string memory baseURI = _baseURI();
783         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
784     }
785 
786     /**
787      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
788      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
789      * by default, can be overriden in child contracts.
790      */
791     function _baseURI() internal view virtual returns (string memory) {
792         return "";
793     }
794 
795     /**
796      * @dev See {IERC721-approve}.
797      */
798     function approve(address to, uint256 tokenId) public virtual override {
799         address owner = ERC721.ownerOf(tokenId);
800         require(to != owner, "ERC721: approval to current owner");
801 
802         require(
803             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
804             "ERC721: approve caller is not owner nor approved for all"
805         );
806 
807         _approve(to, tokenId);
808     }
809 
810     /**
811      * @dev See {IERC721-getApproved}.
812      */
813     function getApproved(uint256 tokenId) public view virtual override returns (address) {
814         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
815 
816         return _tokenApprovals[tokenId];
817     }
818 
819     /**
820      * @dev See {IERC721-setApprovalForAll}.
821      */
822     function setApprovalForAll(address operator, bool approved) public virtual override {
823         require(operator != _msgSender(), "ERC721: approve to caller");
824 
825         _operatorApprovals[_msgSender()][operator] = approved;
826         emit ApprovalForAll(_msgSender(), operator, approved);
827     }
828 
829     /**
830      * @dev See {IERC721-isApprovedForAll}.
831      */
832     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
833         return _operatorApprovals[owner][operator];
834     }
835 
836     /**
837      * @dev See {IERC721-transferFrom}.
838      */
839     function transferFrom(
840         address from,
841         address to,
842         uint256 tokenId
843     ) public virtual override {
844         //solhint-disable-next-line max-line-length
845         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
846 
847         _transfer(from, to, tokenId);
848     }
849 
850     /**
851      * @dev See {IERC721-safeTransferFrom}.
852      */
853     function safeTransferFrom(
854         address from,
855         address to,
856         uint256 tokenId
857     ) public virtual override {
858         safeTransferFrom(from, to, tokenId, "");
859     }
860 
861     /**
862      * @dev See {IERC721-safeTransferFrom}.
863      */
864     function safeTransferFrom(
865         address from,
866         address to,
867         uint256 tokenId,
868         bytes memory _data
869     ) public virtual override {
870         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
871         _safeTransfer(from, to, tokenId, _data);
872     }
873 
874     /**
875      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
876      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
877      *
878      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
879      *
880      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
881      * implement alternative mechanisms to perform token transfer, such as signature-based.
882      *
883      * Requirements:
884      *
885      * - `from` cannot be the zero address.
886      * - `to` cannot be the zero address.
887      * - `tokenId` token must exist and be owned by `from`.
888      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
889      *
890      * Emits a {Transfer} event.
891      */
892     function _safeTransfer(
893         address from,
894         address to,
895         uint256 tokenId,
896         bytes memory _data
897     ) internal virtual {
898         _transfer(from, to, tokenId);
899         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
900     }
901 
902     /**
903      * @dev Returns whether `tokenId` exists.
904      *
905      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
906      *
907      * Tokens start existing when they are minted (`_mint`),
908      * and stop existing when they are burned (`_burn`).
909      */
910     function _exists(uint256 tokenId) internal view virtual returns (bool) {
911         return _owners[tokenId] != address(0);
912     }
913 
914     /**
915      * @dev Returns whether `spender` is allowed to manage `tokenId`.
916      *
917      * Requirements:
918      *
919      * - `tokenId` must exist.
920      */
921     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
922         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
923         address owner = ERC721.ownerOf(tokenId);
924         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
925     }
926 
927     /**
928      * @dev Safely mints `tokenId` and transfers it to `to`.
929      *
930      * Requirements:
931      *
932      * - `tokenId` must not exist.
933      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
934      *
935      * Emits a {Transfer} event.
936      */
937     function _safeMint(address to, uint256 tokenId) internal virtual {
938         _safeMint(to, tokenId, "");
939     }
940 
941     /**
942      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
943      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
944      */
945     function _safeMint(
946         address to,
947         uint256 tokenId,
948         bytes memory _data
949     ) internal virtual {
950         _mint(to, tokenId);
951         require(
952             _checkOnERC721Received(address(0), to, tokenId, _data),
953             "ERC721: transfer to non ERC721Receiver implementer"
954         );
955     }
956 
957     /**
958      * @dev Mints `tokenId` and transfers it to `to`.
959      *
960      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
961      *
962      * Requirements:
963      *
964      * - `tokenId` must not exist.
965      * - `to` cannot be the zero address.
966      *
967      * Emits a {Transfer} event.
968      */
969     function _mint(address to, uint256 tokenId) internal virtual {
970         require(to != address(0), "ERC721: mint to the zero address");
971         require(!_exists(tokenId), "ERC721: token already minted");
972 
973         _beforeTokenTransfer(address(0), to, tokenId);
974 
975         _balances[to] += 1;
976         _owners[tokenId] = to;
977 
978         emit Transfer(address(0), to, tokenId);
979     }
980 
981     /**
982      * @dev Destroys `tokenId`.
983      * The approval is cleared when the token is burned.
984      *
985      * Requirements:
986      *
987      * - `tokenId` must exist.
988      *
989      * Emits a {Transfer} event.
990      */
991     function _burn(uint256 tokenId) internal virtual {
992         address owner = ERC721.ownerOf(tokenId);
993 
994         _beforeTokenTransfer(owner, address(0), tokenId);
995 
996         // Clear approvals
997         _approve(address(0), tokenId);
998 
999         _balances[owner] -= 1;
1000         delete _owners[tokenId];
1001 
1002         emit Transfer(owner, address(0), tokenId);
1003     }
1004 
1005     /**
1006      * @dev Transfers `tokenId` from `from` to `to`.
1007      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1008      *
1009      * Requirements:
1010      *
1011      * - `to` cannot be the zero address.
1012      * - `tokenId` token must be owned by `from`.
1013      *
1014      * Emits a {Transfer} event.
1015      */
1016     function _transfer(
1017         address from,
1018         address to,
1019         uint256 tokenId
1020     ) internal virtual {
1021         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1022         require(to != address(0), "ERC721: transfer to the zero address");
1023 
1024         _beforeTokenTransfer(from, to, tokenId);
1025 
1026         // Clear approvals from the previous owner
1027         _approve(address(0), tokenId);
1028 
1029         _balances[from] -= 1;
1030         _balances[to] += 1;
1031         _owners[tokenId] = to;
1032 
1033         emit Transfer(from, to, tokenId);
1034     }
1035 
1036     /**
1037      * @dev Approve `to` to operate on `tokenId`
1038      *
1039      * Emits a {Approval} event.
1040      */
1041     function _approve(address to, uint256 tokenId) internal virtual {
1042         _tokenApprovals[tokenId] = to;
1043         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1044     }
1045 
1046     /**
1047      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1048      * The call is not executed if the target address is not a contract.
1049      *
1050      * @param from address representing the previous owner of the given token ID
1051      * @param to target address that will receive the tokens
1052      * @param tokenId uint256 ID of the token to be transferred
1053      * @param _data bytes optional data to send along with the call
1054      * @return bool whether the call correctly returned the expected magic value
1055      */
1056     function _checkOnERC721Received(
1057         address from,
1058         address to,
1059         uint256 tokenId,
1060         bytes memory _data
1061     ) private returns (bool) {
1062         if (to.isContract()) {
1063             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1064                 return retval == IERC721Receiver(to).onERC721Received.selector;
1065             } catch (bytes memory reason) {
1066                 if (reason.length == 0) {
1067                     revert("ERC721: transfer to non ERC721Receiver implementer");
1068                 } else {
1069                     assembly {
1070                         revert(add(32, reason), mload(reason))
1071                     }
1072                 }
1073             }
1074         } else {
1075             return true;
1076         }
1077     }
1078 
1079     /**
1080      * @dev Hook that is called before any token transfer. This includes minting
1081      * and burning.
1082      *
1083      * Calling conditions:
1084      *
1085      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1086      * transferred to `to`.
1087      * - When `from` is zero, `tokenId` will be minted for `to`.
1088      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1089      * - `from` and `to` are never both zero.
1090      *
1091      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1092      */
1093     function _beforeTokenTransfer(
1094         address from,
1095         address to,
1096         uint256 tokenId
1097     ) internal virtual {}
1098 }
1099 
1100 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1101 
1102 
1103 pragma solidity ^0.8.0;
1104 
1105 
1106 /**
1107  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1108  * @dev See https://eips.ethereum.org/EIPS/eip-721
1109  */
1110 interface IERC721Enumerable is IERC721 {
1111     /**
1112      * @dev Returns the total amount of tokens stored by the contract.
1113      */
1114     function totalSupply() external view returns (uint256);
1115 
1116     /**
1117      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1118      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1119      */
1120     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1121 
1122     /**
1123      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1124      * Use along with {totalSupply} to enumerate all tokens.
1125      */
1126     function tokenByIndex(uint256 index) external view returns (uint256);
1127 }
1128 
1129 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1130 
1131 
1132 pragma solidity ^0.8.0;
1133 
1134 
1135 
1136 /**
1137  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1138  * enumerability of all the token ids in the contract as well as all token ids owned by each
1139  * account.
1140  */
1141 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1142     // Mapping from owner to list of owned token IDs
1143     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1144 
1145     // Mapping from token ID to index of the owner tokens list
1146     mapping(uint256 => uint256) private _ownedTokensIndex;
1147 
1148     // Array with all token ids, used for enumeration
1149     uint256[] private _allTokens;
1150 
1151     // Mapping from token id to position in the allTokens array
1152     mapping(uint256 => uint256) private _allTokensIndex;
1153 
1154     /**
1155      * @dev See {IERC165-supportsInterface}.
1156      */
1157     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1158         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1159     }
1160 
1161     /**
1162      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1163      */
1164     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1165         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1166         return _ownedTokens[owner][index];
1167     }
1168 
1169     /**
1170      * @dev See {IERC721Enumerable-totalSupply}.
1171      */
1172     function totalSupply() public view virtual override returns (uint256) {
1173         return _allTokens.length;
1174     }
1175 
1176     /**
1177      * @dev See {IERC721Enumerable-tokenByIndex}.
1178      */
1179     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1180         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1181         return _allTokens[index];
1182     }
1183 
1184     /**
1185      * @dev Hook that is called before any token transfer. This includes minting
1186      * and burning.
1187      *
1188      * Calling conditions:
1189      *
1190      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1191      * transferred to `to`.
1192      * - When `from` is zero, `tokenId` will be minted for `to`.
1193      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1194      * - `from` cannot be the zero address.
1195      * - `to` cannot be the zero address.
1196      *
1197      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1198      */
1199     function _beforeTokenTransfer(
1200         address from,
1201         address to,
1202         uint256 tokenId
1203     ) internal virtual override {
1204         super._beforeTokenTransfer(from, to, tokenId);
1205 
1206         if (from == address(0)) {
1207             _addTokenToAllTokensEnumeration(tokenId);
1208         } else if (from != to) {
1209             _removeTokenFromOwnerEnumeration(from, tokenId);
1210         }
1211         if (to == address(0)) {
1212             _removeTokenFromAllTokensEnumeration(tokenId);
1213         } else if (to != from) {
1214             _addTokenToOwnerEnumeration(to, tokenId);
1215         }
1216     }
1217 
1218     /**
1219      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1220      * @param to address representing the new owner of the given token ID
1221      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1222      */
1223     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1224         uint256 length = ERC721.balanceOf(to);
1225         _ownedTokens[to][length] = tokenId;
1226         _ownedTokensIndex[tokenId] = length;
1227     }
1228 
1229     /**
1230      * @dev Private function to add a token to this extension's token tracking data structures.
1231      * @param tokenId uint256 ID of the token to be added to the tokens list
1232      */
1233     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1234         _allTokensIndex[tokenId] = _allTokens.length;
1235         _allTokens.push(tokenId);
1236     }
1237 
1238     /**
1239      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1240      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1241      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1242      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1243      * @param from address representing the previous owner of the given token ID
1244      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1245      */
1246     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1247         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1248         // then delete the last slot (swap and pop).
1249 
1250         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1251         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1252 
1253         // When the token to delete is the last token, the swap operation is unnecessary
1254         if (tokenIndex != lastTokenIndex) {
1255             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1256 
1257             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1258             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1259         }
1260 
1261         // This also deletes the contents at the last position of the array
1262         delete _ownedTokensIndex[tokenId];
1263         delete _ownedTokens[from][lastTokenIndex];
1264     }
1265 
1266     /**
1267      * @dev Private function to remove a token from this extension's token tracking data structures.
1268      * This has O(1) time complexity, but alters the order of the _allTokens array.
1269      * @param tokenId uint256 ID of the token to be removed from the tokens list
1270      */
1271     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1272         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1273         // then delete the last slot (swap and pop).
1274 
1275         uint256 lastTokenIndex = _allTokens.length - 1;
1276         uint256 tokenIndex = _allTokensIndex[tokenId];
1277 
1278         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1279         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1280         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1281         uint256 lastTokenId = _allTokens[lastTokenIndex];
1282 
1283         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1284         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1285 
1286         // This also deletes the contents at the last position of the array
1287         delete _allTokensIndex[tokenId];
1288         _allTokens.pop();
1289     }
1290 }
1291 
1292 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1293 
1294 
1295 pragma solidity ^0.8.0;
1296 
1297 /**
1298  * @dev Contract module that helps prevent reentrant calls to a function.
1299  *
1300  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1301  * available, which can be applied to functions to make sure there are no nested
1302  * (reentrant) calls to them.
1303  *
1304  * Note that because there is a single `nonReentrant` guard, functions marked as
1305  * `nonReentrant` may not call one another. This can be worked around by making
1306  * those functions `private`, and then adding `external` `nonReentrant` entry
1307  * points to them.
1308  *
1309  * TIP: If you would like to learn more about reentrancy and alternative ways
1310  * to protect against it, check out our blog post
1311  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1312  */
1313 abstract contract ReentrancyGuard {
1314     // Booleans are more expensive than uint256 or any type that takes up a full
1315     // word because each write operation emits an extra SLOAD to first read the
1316     // slot's contents, replace the bits taken up by the boolean, and then write
1317     // back. This is the compiler's defense against contract upgrades and
1318     // pointer aliasing, and it cannot be disabled.
1319 
1320     // The values being non-zero value makes deployment a bit more expensive,
1321     // but in exchange the refund on every call to nonReentrant will be lower in
1322     // amount. Since refunds are capped to a percentage of the total
1323     // transaction's gas, it is best to keep them low in cases like this one, to
1324     // increase the likelihood of the full refund coming into effect.
1325     uint256 private constant _NOT_ENTERED = 1;
1326     uint256 private constant _ENTERED = 2;
1327 
1328     uint256 private _status;
1329 
1330     constructor() {
1331         _status = _NOT_ENTERED;
1332     }
1333 
1334     /**
1335      * @dev Prevents a contract from calling itself, directly or indirectly.
1336      * Calling a `nonReentrant` function from another `nonReentrant`
1337      * function is not supported. It is possible to prevent this from happening
1338      * by making the `nonReentrant` function external, and make it call a
1339      * `private` function that does the actual work.
1340      */
1341     modifier nonReentrant() {
1342         // On the first call to nonReentrant, _notEntered will be true
1343         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1344 
1345         // Any calls to nonReentrant after this point will fail
1346         _status = _ENTERED;
1347 
1348         _;
1349 
1350         // By storing the original value once again, a refund is triggered (see
1351         // https://eips.ethereum.org/EIPS/eip-2200)
1352         _status = _NOT_ENTERED;
1353     }
1354 }
1355 
1356 // File: contracts/HuxleyComics.sol
1357 
1358 pragma solidity 0.8.6;
1359 
1360 
1361 
1362 
1363 
1364 
1365 contract HuxleyComics is ERC721Enumerable, IHuxleyComics, ReentrancyGuard, Ownable {
1366     using Strings for uint256;
1367 
1368     // address of the HuxleyComicsOps contract that can mint tokens
1369     address public minter;
1370 
1371     // control if tokens can be burned or not. Default is false
1372     bool public canBurn;
1373 
1374     // Last token id minted
1375     uint256 public tokenId;
1376 
1377     //Issue being minted
1378     uint256 private currentIssue;
1379 
1380     //Price of token to be minted
1381     uint256 private currentPrice;
1382 
1383     //Max amount of tokens that can be mined from current issue
1384     uint256 private currentMaxPayableMintBatch;
1385 
1386     // mapping of Issues - issue number -> Isssue
1387     mapping(uint256 => Issue) private issues;
1388 
1389     // mapping of redemptions - tokenId -> true/false
1390     mapping(uint256 => bool) public redemptions;
1391 
1392     // mapping of Tokens - tokenId -> Token
1393     mapping(uint256 => Token) private tokens;
1394 
1395     /**
1396      * @dev Modifier that checks that address is minter. Reverts
1397      * if sender is not the minter
1398      */
1399     modifier onlyMinter() {
1400         require(msg.sender == minter, "HT: Only minter");
1401         _;
1402     }
1403 
1404     /**
1405      * @dev Initializes the contract by setting a `name` and a `symbol` to the token.
1406      */
1407     constructor() ERC721("HUXLEY Comics", "HUXLEY") {}
1408 
1409     /**
1410      * @dev Safely mints a token. Increments 'tokenId' by 1 and calls super._safeMint()
1411      *
1412      * @param to Address that will be the owner of the token
1413      */
1414     function safeMint(address to) external override onlyMinter() nonReentrant returns (uint256 _tokenId) {
1415         tokenId++;
1416         super._safeMint(to, tokenId);
1417         return tokenId;
1418     }
1419 
1420     /**
1421      * @dev Burns a token. Can only be called by token Owner
1422      *
1423      * @param _tokenId Token that will be burned
1424      */
1425     function burn(uint256 _tokenId) external {
1426         require(canBurn, "HT: is not burnable");
1427         require(ownerOf(_tokenId) == msg.sender, "HT: Not owner");
1428         super._burn(_tokenId);
1429     }
1430 
1431     /**
1432      * @dev It creates a new Issue. Only 'minter' can call this function.
1433      *
1434      * @param _price Price for each token to be minted in wei
1435      * @param _goldSupply Total supply of Gold token
1436      * @param _firstEditionSupply Total supply of First Edition token
1437      * @param _holographicSupply Total supply of Holographic token
1438      * @param _startSerialNumberGold Initial serial number for Gold token
1439      * @param _startSerialNumberFirstEdition Initial serial number for First Edition token
1440      * @param _startSerialNumberHolographic Initial serial number for Holographic token
1441      * @param _maxPayableMintBatch Max amount of tokens that can be minted when calling batch functions (should not be greater than 100 so it won't run out of gas)
1442      * @param _uri Uri for the tokens of the issue
1443      */
1444     function createNewIssue(
1445         uint256 _price,
1446         uint256 _goldSupply,
1447         uint256 _firstEditionSupply,
1448         uint256 _holographicSupply,
1449         uint256 _startSerialNumberGold,
1450         uint256 _startSerialNumberFirstEdition,
1451         uint256 _startSerialNumberHolographic,
1452         uint256 _maxPayableMintBatch,
1453         string memory _uri
1454     ) external override onlyMinter {
1455         currentIssue = currentIssue + 1;
1456         currentPrice = _price;
1457         currentMaxPayableMintBatch = _maxPayableMintBatch;
1458 
1459         Issue storage issue = issues[currentIssue];
1460 
1461         issue.price = _price;
1462         issue.goldSupplyLeft = _goldSupply;
1463         issue.firstEditionSupplyLeft = _firstEditionSupply;
1464         issue.holographicSupplyLeft = _holographicSupply;
1465         issue.serialNumberToMintGold = _startSerialNumberGold;
1466         issue.serialNumberToMintFirstEdition = _startSerialNumberFirstEdition;
1467         issue.serialNumberToMintHolographic = _startSerialNumberHolographic;
1468         issue.maxPayableMintBatch = _maxPayableMintBatch;
1469         issue.uri = _uri;
1470         issue.exist = true;
1471     }
1472 
1473     /**
1474      * @dev Returns whether `issueNumber` exists.
1475      *
1476      * Issue can be created via {createNewIssue}.
1477      *
1478      */
1479     function _issueExists(uint256 _issueNumber) internal view virtual returns (bool) {
1480         return issues[_issueNumber].exist ? true : false;
1481     }
1482 
1483     /**
1484      * @dev It sets details for the token. It sets the issue number, serial number and token type.
1485      *     It also updates supply left of the token.
1486      *
1487      * Emits a {IssueCreated} event.
1488      *
1489      * @param _tokenId tokenID
1490      * @param _tokenType tokenType
1491      */
1492     function setTokenDetails(uint256 _tokenId, TokenType _tokenType) external override onlyMinter {
1493         Token storage token = tokens[_tokenId];
1494         token.issueNumber = currentIssue;
1495 
1496         Issue storage issue = issues[currentIssue];
1497         // can mint Gold, FirstEdition and Holographic
1498         if (_tokenType == TokenType.Gold) {
1499             uint256 goldSupplyLeft = issue.goldSupplyLeft;
1500             require(goldSupplyLeft > 0, "HT: no gold");
1501 
1502             issue.goldSupplyLeft = goldSupplyLeft - 1;
1503             uint256 serialNumberGold = issue.serialNumberToMintGold;
1504             issue.serialNumberToMintGold = serialNumberGold + 1; //next mint
1505 
1506             token.tokenType = TokenType.Gold;
1507             token.serialNumber = serialNumberGold;
1508         } else if (_tokenType == TokenType.FirstEdition) {
1509             uint256 firstEditionSupplyLeft = issue.firstEditionSupplyLeft;
1510             require(firstEditionSupplyLeft > 0, "HT: no firstEdition");
1511 
1512             issue.firstEditionSupplyLeft = firstEditionSupplyLeft - 1;
1513             uint256 serialNumberFirstEdition = issue.serialNumberToMintFirstEdition;
1514             issue.serialNumberToMintFirstEdition = serialNumberFirstEdition + 1; //next mint
1515 
1516             token.tokenType = TokenType.FirstEdition;
1517             token.serialNumber = serialNumberFirstEdition;
1518         } else if (_tokenType == TokenType.Holographic) {
1519             uint256 holographicSupplyLeft = issue.holographicSupplyLeft;
1520             require(holographicSupplyLeft > 0, "HT: no holographic");
1521 
1522             issue.holographicSupplyLeft = holographicSupplyLeft - 1;
1523             uint256 serialNumberHolographic = issue.serialNumberToMintHolographic;
1524             issue.serialNumberToMintHolographic = serialNumberHolographic + 1; //next mint
1525 
1526             token.tokenType = TokenType.Holographic;
1527             token.serialNumber = serialNumberHolographic;
1528         } else {
1529             revert();
1530         }
1531     }
1532 
1533     /// @dev Returns URI for the token. Each Issue number has a base uri.
1534     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1535         require(_exists(_tokenId), "UT: invalid token");
1536 
1537         Token memory token = tokens[_tokenId];
1538         uint256 issueNumber = token.issueNumber;
1539         require(issueNumber > 0, "HT: invalid issue");
1540 
1541         Issue memory issue = issues[issueNumber];
1542         string memory baseURI = issue.uri;
1543 
1544         return
1545             bytes(baseURI).length > 0
1546                 ? string(abi.encodePacked(baseURI, _tokenId.toString()))
1547                 : "";
1548     }
1549 
1550     /**
1551      * @dev Sets URI for an Issue.
1552      *
1553      * Issue can be created via {createNewIssue} by the Minter.
1554      *
1555      */
1556     function setBaseURI(uint256 _issueNumber, string memory _uri) external override onlyMinter {
1557         require(_issueExists(_issueNumber), "UT: invalid issue");
1558 
1559         Issue storage issue = issues[_issueNumber];
1560         issue.uri = _uri;
1561     }
1562 
1563     /// @dev Returns Issue that can be minted.
1564     function getCurrentIssue() external view override returns (uint256 _currentIssue) {
1565         return currentIssue;
1566     }
1567 
1568     /// @dev Returns Price of token that can be minted.
1569     function getCurrentPrice() external view override returns (uint256 _currentPrice) {
1570         return currentPrice;
1571     }
1572 
1573     /// @dev Returns Max Amount of First Edition tokens an address can pay to mint.
1574     function getCurrentMaxPayableMintBatch() external view override returns (uint256 _currentMaxaPaybleMintBatch) {
1575         return currentMaxPayableMintBatch;
1576     }
1577 
1578     /**
1579      * @dev Returns details of an Issue: 'price', 'goldSupplyLeft', 'firstEditionSupplyLeft,
1580      *   'holographicSupplyLeft', 'serialNumberToMintGold', 'serialNumberToMintFirstEdition',
1581      *   'serialNumberToMintHolographic', 'MaxPayableMintBatch', 'uri' and 'exist'.
1582      *
1583      */
1584     function getIssue(uint256 _issueNumber) external view override returns (Issue memory _issue) {
1585         return issues[_issueNumber];
1586     }
1587 
1588     /// @dev Returns token details: 'serialNumber', 'issueNumber' and 'TokenType'
1589     function getToken(uint256 _tokenId) external view override returns (Token memory _token) {
1590         return tokens[_tokenId];
1591     }
1592 
1593     /// @dev User can redeem a copy
1594     function redeemCopy(uint256 _tokenId) external {
1595         require(ownerOf(_tokenId) == msg.sender, "HT: Not owner");
1596         require(redemptions[_tokenId] == false, "HT: already redeemed");
1597 
1598         redemptions[_tokenId] = true;
1599     }
1600 
1601     // Setup functions
1602     /// @dev Sets new minter address. Only Owner can call this function.
1603     function updateMinter(address _minter) external onlyOwner {
1604         minter = _minter;
1605     }
1606 
1607     /// @dev Sets if it is allowed to burn tokens. Default is 'false'. Only Minter can call this function.
1608     function setCanBurn(bool _canBurn) external override onlyMinter {
1609         canBurn = _canBurn;
1610     }
1611     // End setup functions
1612 }