1 //SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
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
27 // File: @openzeppelin/contracts/utils/Context.sol
28 
29 pragma solidity ^0.8.0;
30 
31 /**
32  * @dev Provides information about the current execution context, including the
33  * sender of the transaction and its data. While these are generally available
34  * via msg.sender and msg.data, they should not be accessed in such a direct
35  * manner, since when dealing with meta-transactions the account sending and
36  * paying for execution may not be the actual sender (as far as an application
37  * is concerned).
38  *
39  * This contract is only required for intermediate, library-like contracts.
40  */
41 abstract contract Context {
42     function _msgSender() internal view virtual returns (address) {
43         return msg.sender;
44     }
45 
46     function _msgData() internal view virtual returns (bytes calldata) {
47         return msg.data;
48     }
49 }
50 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev Required interface of an ERC721 compliant contract.
56  */
57 interface IERC721 is IERC165 {
58     /**
59      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
60      */
61     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
62 
63     /**
64      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
65      */
66     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
67 
68     /**
69      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
70      */
71     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
72 
73     /**
74      * @dev Returns the number of tokens in ``owner``'s account.
75      */
76     function balanceOf(address owner) external view returns (uint256 balance);
77 
78     /**
79      * @dev Returns the owner of the `tokenId` token.
80      *
81      * Requirements:
82      *
83      * - `tokenId` must exist.
84      */
85     function ownerOf(uint256 tokenId) external view returns (address owner);
86 
87     /**
88      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
89      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
90      *
91      * Requirements:
92      *
93      * - `from` cannot be the zero address.
94      * - `to` cannot be the zero address.
95      * - `tokenId` token must exist and be owned by `from`.
96      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
97      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
98      *
99      * Emits a {Transfer} event.
100      */
101     function safeTransferFrom(
102         address from,
103         address to,
104         uint256 tokenId
105     ) external;
106 
107     /**
108      * @dev Transfers `tokenId` token from `from` to `to`.
109      *
110      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
111      *
112      * Requirements:
113      *
114      * - `from` cannot be the zero address.
115      * - `to` cannot be the zero address.
116      * - `tokenId` token must be owned by `from`.
117      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
118      *
119      * Emits a {Transfer} event.
120      */
121     function transferFrom(
122         address from,
123         address to,
124         uint256 tokenId
125     ) external;
126 
127     /**
128      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
129      * The approval is cleared when the token is transferred.
130      *
131      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
132      *
133      * Requirements:
134      *
135      * - The caller must own the token or be an approved operator.
136      * - `tokenId` must exist.
137      *
138      * Emits an {Approval} event.
139      */
140     function approve(address to, uint256 tokenId) external;
141 
142     /**
143      * @dev Returns the account approved for `tokenId` token.
144      *
145      * Requirements:
146      *
147      * - `tokenId` must exist.
148      */
149     function getApproved(uint256 tokenId) external view returns (address operator);
150 
151     /**
152      * @dev Approve or remove `operator` as an operator for the caller.
153      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
154      *
155      * Requirements:
156      *
157      * - The `operator` cannot be the caller.
158      *
159      * Emits an {ApprovalForAll} event.
160      */
161     function setApprovalForAll(address operator, bool _approved) external;
162 
163     /**
164      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
165      *
166      * See {setApprovalForAll}
167      */
168     function isApprovedForAll(address owner, address operator) external view returns (bool);
169 
170     /**
171      * @dev Safely transfers `tokenId` token from `from` to `to`.
172      *
173      * Requirements:
174      *
175      * - `from` cannot be the zero address.
176      * - `to` cannot be the zero address.
177      * - `tokenId` token must exist and be owned by `from`.
178      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
179      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
180      *
181      * Emits a {Transfer} event.
182      */
183     function safeTransferFrom(
184         address from,
185         address to,
186         uint256 tokenId,
187         bytes calldata data
188     ) external;
189 }
190 
191 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
192 
193 pragma solidity ^0.8.0;
194 
195 /**
196  * @title ERC721 token receiver interface
197  * @dev Interface for any contract that wants to support safeTransfers
198  * from ERC721 asset contracts.
199  */
200 interface IERC721Receiver {
201     /**
202      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
203      * by `operator` from `from`, this function is called.
204      *
205      * It must return its Solidity selector to confirm the token transfer.
206      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
207      *
208      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
209      */
210     function onERC721Received(
211         address operator,
212         address from,
213         uint256 tokenId,
214         bytes calldata data
215     ) external returns (bytes4);
216 }
217 
218 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
219 
220 pragma solidity ^0.8.0;
221 
222 /**
223  * @dev Implementation of the {IERC165} interface.
224  *
225  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
226  * for the additional interface id that will be supported. For example:
227  *
228  * ```solidity
229  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
230  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
231  * }
232  * ```
233  *
234  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
235  */
236 abstract contract ERC165 is IERC165 {
237     /**
238      * @dev See {IERC165-supportsInterface}.
239      */
240     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
241         return interfaceId == type(IERC165).interfaceId;
242     }
243 }
244 
245 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
246 
247 pragma solidity ^0.8.0;
248 
249 /**
250  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
251  * @dev See https://eips.ethereum.org/EIPS/eip-721
252  */
253 interface IERC721Enumerable is IERC721 {
254     /**
255      * @dev Returns the total amount of tokens stored by the contract.
256      */
257     function totalSupply() external view returns (uint256);
258 
259     /**
260      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
261      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
262      */
263     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
264 
265     /**
266      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
267      * Use along with {totalSupply} to enumerate all tokens.
268      */
269     function tokenByIndex(uint256 index) external view returns (uint256);
270 }
271 
272 // File: @openzeppelin/contracts/access/Ownable.sol
273 
274 pragma solidity ^0.8.0;
275 
276 /**
277  * @dev Contract module which provides a basic access control mechanism, where
278  * there is an account (an owner) that can be granted exclusive access to
279  * specific functions.
280  *
281  * By default, the owner account will be the one that deploys the contract. This
282  * can later be changed with {transferOwnership}.
283  *
284  * This module is used through inheritance. It will make available the modifier
285  * `onlyOwner`, which can be applied to your functions to restrict their use to
286  * the owner.
287  */
288 abstract contract Ownable is Context {
289     address private _owner;
290 
291     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
292 
293     /**
294      * @dev Initializes the contract setting the deployer as the initial owner.
295      */
296     constructor() {
297         _setOwner(_msgSender());
298     }
299 
300     /**
301      * @dev Returns the address of the current owner.
302      */
303     function owner() public view virtual returns (address) {
304         return _owner;
305     }
306 
307     /**
308      * @dev Throws if called by any account other than the owner.
309      */
310     modifier onlyOwner() {
311         require(owner() == _msgSender(), "Ownable: caller is not the owner");
312         _;
313     }
314 
315     /**
316      * @dev Leaves the contract without owner. It will not be possible to call
317      * `onlyOwner` functions anymore. Can only be called by the current owner.
318      *
319      * NOTE: Renouncing ownership will leave the contract without an owner,
320      * thereby removing any functionality that is only available to the owner.
321      */
322     function renounceOwnership() public virtual onlyOwner {
323         _setOwner(address(0));
324     }
325 
326     /**
327      * @dev Transfers ownership of the contract to a new account (`newOwner`).
328      * Can only be called by the current owner.
329      */
330     function transferOwnership(address newOwner) public virtual onlyOwner {
331         require(newOwner != address(0), "Ownable: new owner is the zero address");
332         _setOwner(newOwner);
333     }
334 
335     function _setOwner(address newOwner) private {
336         address oldOwner = _owner;
337         _owner = newOwner;
338         emit OwnershipTransferred(oldOwner, newOwner);
339     }
340 }
341 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
342 
343 pragma solidity ^0.8.0;
344 
345 /**
346  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
347  * @dev See https://eips.ethereum.org/EIPS/eip-721
348  */
349 interface IERC721Metadata is IERC721 {
350     /**
351      * @dev Returns the token collection name.
352      */
353     function name() external view returns (string memory);
354 
355     /**
356      * @dev Returns the token collection symbol.
357      */
358     function symbol() external view returns (string memory);
359 
360     /**
361      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
362      */
363     function tokenURI(uint256 tokenId) external view returns (string memory);
364 }
365 
366 // File: @openzeppelin/contracts/utils/Address.sol
367 
368 pragma solidity ^0.8.0;
369 
370 /**
371  * @dev Collection of functions related to the address type
372  */
373 library Address {
374     /**
375      * @dev Returns true if `account` is a contract.
376      *
377      * [IMPORTANT]
378      * ====
379      * It is unsafe to assume that an address for which this function returns
380      * false is an externally-owned account (EOA) and not a contract.
381      *
382      * Among others, `isContract` will return false for the following
383      * types of addresses:
384      *
385      *  - an externally-owned account
386      *  - a contract in construction
387      *  - an address where a contract will be created
388      *  - an address where a contract lived, but was destroyed
389      * ====
390      */
391     function isContract(address account) internal view returns (bool) {
392         // This method relies on extcodesize, which returns 0 for contracts in
393         // construction, since the code is only stored at the end of the
394         // constructor execution.
395 
396         uint256 size;
397         assembly {
398             size := extcodesize(account)
399         }
400         return size > 0;
401     }
402 
403     /**
404      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
405      * `recipient`, forwarding all available gas and reverting on errors.
406      *
407      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
408      * of certain opcodes, possibly making contracts go over the 2300 gas limit
409      * imposed by `transfer`, making them unable to receive funds via
410      * `transfer`. {sendValue} removes this limitation.
411      *
412      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
413      *
414      * IMPORTANT: because control is transferred to `recipient`, care must be
415      * taken to not create reentrancy vulnerabilities. Consider using
416      * {ReentrancyGuard} or the
417      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
418      */
419     function sendValue(address payable recipient, uint256 amount) internal {
420         require(address(this).balance >= amount, "Address: insufficient balance");
421 
422         (bool success, ) = recipient.call{value: amount}("");
423         require(success, "Address: unable to send value, recipient may have reverted");
424     }
425 
426     /**
427      * @dev Performs a Solidity function call using a low level `call`. A
428      * plain `call` is an unsafe replacement for a function call: use this
429      * function instead.
430      *
431      * If `target` reverts with a revert reason, it is bubbled up by this
432      * function (like regular Solidity function calls).
433      *
434      * Returns the raw returned data. To convert to the expected return value,
435      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
436      *
437      * Requirements:
438      *
439      * - `target` must be a contract.
440      * - calling `target` with `data` must not revert.
441      *
442      * _Available since v3.1._
443      */
444     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
445         return functionCall(target, data, "Address: low-level call failed");
446     }
447 
448     /**
449      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
450      * `errorMessage` as a fallback revert reason when `target` reverts.
451      *
452      * _Available since v3.1._
453      */
454     function functionCall(
455         address target,
456         bytes memory data,
457         string memory errorMessage
458     ) internal returns (bytes memory) {
459         return functionCallWithValue(target, data, 0, errorMessage);
460     }
461 
462     /**
463      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
464      * but also transferring `value` wei to `target`.
465      *
466      * Requirements:
467      *
468      * - the calling contract must have an ETH balance of at least `value`.
469      * - the called Solidity function must be `payable`.
470      *
471      * _Available since v3.1._
472      */
473     function functionCallWithValue(
474         address target,
475         bytes memory data,
476         uint256 value
477     ) internal returns (bytes memory) {
478         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
479     }
480 
481     /**
482      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
483      * with `errorMessage` as a fallback revert reason when `target` reverts.
484      *
485      * _Available since v3.1._
486      */
487     function functionCallWithValue(
488         address target,
489         bytes memory data,
490         uint256 value,
491         string memory errorMessage
492     ) internal returns (bytes memory) {
493         require(address(this).balance >= value, "Address: insufficient balance for call");
494         require(isContract(target), "Address: call to non-contract");
495 
496         (bool success, bytes memory returndata) = target.call{value: value}(data);
497         return verifyCallResult(success, returndata, errorMessage);
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
502      * but performing a static call.
503      *
504      * _Available since v3.3._
505      */
506     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
507         return functionStaticCall(target, data, "Address: low-level static call failed");
508     }
509 
510     /**
511      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
512      * but performing a static call.
513      *
514      * _Available since v3.3._
515      */
516     function functionStaticCall(
517         address target,
518         bytes memory data,
519         string memory errorMessage
520     ) internal view returns (bytes memory) {
521         require(isContract(target), "Address: static call to non-contract");
522 
523         (bool success, bytes memory returndata) = target.staticcall(data);
524         return verifyCallResult(success, returndata, errorMessage);
525     }
526 
527     /**
528      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
529      * but performing a delegate call.
530      *
531      * _Available since v3.4._
532      */
533     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
534         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
535     }
536 
537     /**
538      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
539      * but performing a delegate call.
540      *
541      * _Available since v3.4._
542      */
543     function functionDelegateCall(
544         address target,
545         bytes memory data,
546         string memory errorMessage
547     ) internal returns (bytes memory) {
548         require(isContract(target), "Address: delegate call to non-contract");
549 
550         (bool success, bytes memory returndata) = target.delegatecall(data);
551         return verifyCallResult(success, returndata, errorMessage);
552     }
553 
554     /**
555      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
556      * revert reason using the provided one.
557      *
558      * _Available since v4.3._
559      */
560     function verifyCallResult(
561         bool success,
562         bytes memory returndata,
563         string memory errorMessage
564     ) internal pure returns (bytes memory) {
565         if (success) {
566             return returndata;
567         } else {
568             // Look for revert reason and bubble it up if present
569             if (returndata.length > 0) {
570                 // The easiest way to bubble the revert reason is using memory via assembly
571 
572                 assembly {
573                     let returndata_size := mload(returndata)
574                     revert(add(32, returndata), returndata_size)
575                 }
576             } else {
577                 revert(errorMessage);
578             }
579         }
580     }
581 }
582 
583 // File: @openzeppelin/contracts/utils/Strings.sol
584 
585 pragma solidity ^0.8.0;
586 
587 /**
588  * @dev String operations.
589  */
590 library Strings {
591     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
592 
593     /**
594      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
595      */
596     function toString(uint256 value) internal pure returns (string memory) {
597         // Inspired by OraclizeAPI's implementation - MIT licence
598         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
599 
600         if (value == 0) {
601             return "0";
602         }
603         uint256 temp = value;
604         uint256 digits;
605         while (temp != 0) {
606             digits++;
607             temp /= 10;
608         }
609         bytes memory buffer = new bytes(digits);
610         while (value != 0) {
611             digits -= 1;
612             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
613             value /= 10;
614         }
615         return string(buffer);
616     }
617 
618     /**
619      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
620      */
621     function toHexString(uint256 value) internal pure returns (string memory) {
622         if (value == 0) {
623             return "0x00";
624         }
625         uint256 temp = value;
626         uint256 length = 0;
627         while (temp != 0) {
628             length++;
629             temp >>= 8;
630         }
631         return toHexString(value, length);
632     }
633 
634     /**
635      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
636      */
637     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
638         bytes memory buffer = new bytes(2 * length + 2);
639         buffer[0] = "0";
640         buffer[1] = "x";
641         for (uint256 i = 2 * length + 1; i > 1; --i) {
642             buffer[i] = _HEX_SYMBOLS[value & 0xf];
643             value >>= 4;
644         }
645         require(value == 0, "Strings: hex length insufficient");
646         return string(buffer);
647     }
648 }
649 
650 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
651 
652 pragma solidity ^0.8.0;
653 
654 /**
655  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
656  * the Metadata extension, but not including the Enumerable extension, which is available separately as
657  * {ERC721Enumerable}.
658  */
659 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
660     using Address for address;
661     using Strings for uint256;
662 
663     // Token name
664     string private _name;
665 
666     // Token symbol
667     string private _symbol;
668 
669     // Mapping from token ID to owner address
670     mapping(uint256 => address) private _owners;
671 
672     // Mapping owner address to token count
673     mapping(address => uint256) private _balances;
674 
675     // Mapping from token ID to approved address
676     mapping(uint256 => address) private _tokenApprovals;
677 
678     // Mapping from owner to operator approvals
679     mapping(address => mapping(address => bool)) private _operatorApprovals;
680 
681     /**
682      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
683      */
684     constructor(string memory name_, string memory symbol_) {
685         _name = name_;
686         _symbol = symbol_;
687     }
688 
689     /**
690      * @dev See {IERC165-supportsInterface}.
691      */
692     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
693         return
694             interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC721Metadata).interfaceId || super.supportsInterface(interfaceId);
695     }
696 
697     /**
698      * @dev See {IERC721-balanceOf}.
699      */
700     function balanceOf(address owner) public view virtual override returns (uint256) {
701         require(owner != address(0), "ERC721: balance query for the zero address");
702         return _balances[owner];
703     }
704 
705     /**
706      * @dev See {IERC721-ownerOf}.
707      */
708     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
709         address owner = _owners[tokenId];
710         require(owner != address(0), "ERC721: owner query for nonexistent token");
711         return owner;
712     }
713 
714     /**
715      * @dev See {IERC721Metadata-name}.
716      */
717     function name() public view virtual override returns (string memory) {
718         return _name;
719     }
720 
721     /**
722      * @dev See {IERC721Metadata-symbol}.
723      */
724     function symbol() public view virtual override returns (string memory) {
725         return _symbol;
726     }
727 
728     /**
729      * @dev See {IERC721Metadata-tokenURI}.
730      */
731     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
732         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
733 
734         string memory baseURI = _baseURI();
735         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
736     }
737 
738     /**
739      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
740      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
741      * by default, can be overriden in child contracts.
742      */
743     function _baseURI() internal view virtual returns (string memory) {
744         return "";
745     }
746 
747     /**
748      * @dev See {IERC721-approve}.
749      */
750     function approve(address to, uint256 tokenId) public virtual override {
751         address owner = ERC721.ownerOf(tokenId);
752         require(to != owner, "ERC721: approval to current owner");
753 
754         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()), "ERC721: approve caller is not owner nor approved for all");
755 
756         _approve(to, tokenId);
757     }
758 
759     /**
760      * @dev See {IERC721-getApproved}.
761      */
762     function getApproved(uint256 tokenId) public view virtual override returns (address) {
763         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
764 
765         return _tokenApprovals[tokenId];
766     }
767 
768     /**
769      * @dev See {IERC721-setApprovalForAll}.
770      */
771     function setApprovalForAll(address operator, bool approved) public virtual override {
772         require(operator != _msgSender(), "ERC721: approve to caller");
773 
774         _operatorApprovals[_msgSender()][operator] = approved;
775         emit ApprovalForAll(_msgSender(), operator, approved);
776     }
777 
778     /**
779      * @dev See {IERC721-isApprovedForAll}.
780      */
781     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
782         return _operatorApprovals[owner][operator];
783     }
784 
785     /**
786      * @dev See {IERC721-transferFrom}.
787      */
788     function transferFrom(
789         address from,
790         address to,
791         uint256 tokenId
792     ) public virtual override {
793         //solhint-disable-next-line max-line-length
794         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
795 
796         _transfer(from, to, tokenId);
797     }
798 
799     /**
800      * @dev See {IERC721-safeTransferFrom}.
801      */
802     function safeTransferFrom(
803         address from,
804         address to,
805         uint256 tokenId
806     ) public virtual override {
807         safeTransferFrom(from, to, tokenId, "");
808     }
809 
810     /**
811      * @dev See {IERC721-safeTransferFrom}.
812      */
813     function safeTransferFrom(
814         address from,
815         address to,
816         uint256 tokenId,
817         bytes memory _data
818     ) public virtual override {
819         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
820         _safeTransfer(from, to, tokenId, _data);
821     }
822 
823     /**
824      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
825      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
826      *
827      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
828      *
829      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
830      * implement alternative mechanisms to perform token transfer, such as signature-based.
831      *
832      * Requirements:
833      *
834      * - `from` cannot be the zero address.
835      * - `to` cannot be the zero address.
836      * - `tokenId` token must exist and be owned by `from`.
837      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
838      *
839      * Emits a {Transfer} event.
840      */
841     function _safeTransfer(
842         address from,
843         address to,
844         uint256 tokenId,
845         bytes memory _data
846     ) internal virtual {
847         _transfer(from, to, tokenId);
848         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
849     }
850 
851     /**
852      * @dev Returns whether `tokenId` exists.
853      *
854      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
855      *
856      * Tokens start existing when they are minted (`_mint`),
857      * and stop existing when they are burned (`_burn`).
858      */
859     function _exists(uint256 tokenId) internal view virtual returns (bool) {
860         return _owners[tokenId] != address(0);
861     }
862 
863     /**
864      * @dev Returns whether `spender` is allowed to manage `tokenId`.
865      *
866      * Requirements:
867      *
868      * - `tokenId` must exist.
869      */
870     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
871         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
872         address owner = ERC721.ownerOf(tokenId);
873         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
874     }
875 
876     /**
877      * @dev Safely mints `tokenId` and transfers it to `to`.
878      *
879      * Requirements:
880      *
881      * - `tokenId` must not exist.
882      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
883      *
884      * Emits a {Transfer} event.
885      */
886     function _safeMint(address to, uint256 tokenId) internal virtual {
887         _safeMint(to, tokenId, "");
888     }
889 
890     /**
891      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
892      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
893      */
894     function _safeMint(
895         address to,
896         uint256 tokenId,
897         bytes memory _data
898     ) internal virtual {
899         _mint(to, tokenId);
900         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
901     }
902 
903     /**
904      * @dev Mints `tokenId` and transfers it to `to`.
905      *
906      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
907      *
908      * Requirements:
909      *
910      * - `tokenId` must not exist.
911      * - `to` cannot be the zero address.
912      *
913      * Emits a {Transfer} event.
914      */
915     function _mint(address to, uint256 tokenId) internal virtual {
916         require(to != address(0), "ERC721: mint to the zero address");
917         require(!_exists(tokenId), "ERC721: token already minted");
918 
919         _beforeTokenTransfer(address(0), to, tokenId);
920 
921         _balances[to] += 1;
922         _owners[tokenId] = to;
923 
924         emit Transfer(address(0), to, tokenId);
925     }
926 
927     /**
928      * @dev Destroys `tokenId`.
929      * The approval is cleared when the token is burned.
930      *
931      * Requirements:
932      *
933      * - `tokenId` must exist.
934      *
935      * Emits a {Transfer} event.
936      */
937     function _burn(uint256 tokenId) internal virtual {
938         address owner = ERC721.ownerOf(tokenId);
939 
940         _beforeTokenTransfer(owner, address(0), tokenId);
941 
942         // Clear approvals
943         _approve(address(0), tokenId);
944 
945         _balances[owner] -= 1;
946         delete _owners[tokenId];
947 
948         emit Transfer(owner, address(0), tokenId);
949     }
950 
951     /**
952      * @dev Transfers `tokenId` from `from` to `to`.
953      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
954      *
955      * Requirements:
956      *
957      * - `to` cannot be the zero address.
958      * - `tokenId` token must be owned by `from`.
959      *
960      * Emits a {Transfer} event.
961      */
962     function _transfer(
963         address from,
964         address to,
965         uint256 tokenId
966     ) internal virtual {
967         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
968         require(to != address(0), "ERC721: transfer to the zero address");
969 
970         _beforeTokenTransfer(from, to, tokenId);
971 
972         // Clear approvals from the previous owner
973         _approve(address(0), tokenId);
974 
975         _balances[from] -= 1;
976         _balances[to] += 1;
977         _owners[tokenId] = to;
978 
979         emit Transfer(from, to, tokenId);
980     }
981 
982     /**
983      * @dev Approve `to` to operate on `tokenId`
984      *
985      * Emits a {Approval} event.
986      */
987     function _approve(address to, uint256 tokenId) internal virtual {
988         _tokenApprovals[tokenId] = to;
989         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
990     }
991 
992     /**
993      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
994      * The call is not executed if the target address is not a contract.
995      *
996      * @param from address representing the previous owner of the given token ID
997      * @param to target address that will receive the tokens
998      * @param tokenId uint256 ID of the token to be transferred
999      * @param _data bytes optional data to send along with the call
1000      * @return bool whether the call correctly returned the expected magic value
1001      */
1002     function _checkOnERC721Received(
1003         address from,
1004         address to,
1005         uint256 tokenId,
1006         bytes memory _data
1007     ) private returns (bool) {
1008         if (to.isContract()) {
1009             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1010                 return retval == IERC721Receiver.onERC721Received.selector;
1011             } catch (bytes memory reason) {
1012                 if (reason.length == 0) {
1013                     revert("ERC721: transfer to non ERC721Receiver implementer");
1014                 } else {
1015                     assembly {
1016                         revert(add(32, reason), mload(reason))
1017                     }
1018                 }
1019             }
1020         } else {
1021             return true;
1022         }
1023     }
1024 
1025     /**
1026      * @dev Hook that is called before any token transfer. This includes minting
1027      * and burning.
1028      *
1029      * Calling conditions:
1030      *
1031      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1032      * transferred to `to`.
1033      * - When `from` is zero, `tokenId` will be minted for `to`.
1034      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1035      * - `from` and `to` are never both zero.
1036      *
1037      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1038      */
1039     function _beforeTokenTransfer(
1040         address from,
1041         address to,
1042         uint256 tokenId
1043     ) internal virtual {}
1044 }
1045 
1046 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1047 
1048 pragma solidity ^0.8.0;
1049 
1050 /**
1051  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1052  * enumerability of all the token ids in the contract as well as all token ids owned by each
1053  * account.
1054  */
1055 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1056     // Mapping from owner to list of owned token IDs
1057     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1058 
1059     // Mapping from token ID to index of the owner tokens list
1060     mapping(uint256 => uint256) private _ownedTokensIndex;
1061 
1062     // Array with all token ids, used for enumeration
1063     uint256[] private _allTokens;
1064 
1065     // Mapping from token id to position in the allTokens array
1066     mapping(uint256 => uint256) private _allTokensIndex;
1067 
1068     /**
1069      * @dev See {IERC165-supportsInterface}.
1070      */
1071     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1072         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1073     }
1074 
1075     /**
1076      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1077      */
1078     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1079         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1080         return _ownedTokens[owner][index];
1081     }
1082 
1083     /**
1084      * @dev See {IERC721Enumerable-totalSupply}.
1085      */
1086     function totalSupply() public view virtual override returns (uint256) {
1087         return _allTokens.length;
1088     }
1089 
1090     /**
1091      * @dev See {IERC721Enumerable-tokenByIndex}.
1092      */
1093     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1094         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1095         return _allTokens[index];
1096     }
1097 
1098     /**
1099      * @dev Hook that is called before any token transfer. This includes minting
1100      * and burning.
1101      *
1102      * Calling conditions:
1103      *
1104      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1105      * transferred to `to`.
1106      * - When `from` is zero, `tokenId` will be minted for `to`.
1107      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1108      * - `from` cannot be the zero address.
1109      * - `to` cannot be the zero address.
1110      *
1111      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1112      */
1113     function _beforeTokenTransfer(
1114         address from,
1115         address to,
1116         uint256 tokenId
1117     ) internal virtual override {
1118         super._beforeTokenTransfer(from, to, tokenId);
1119 
1120         if (from == address(0)) {
1121             _addTokenToAllTokensEnumeration(tokenId);
1122         } else if (from != to) {
1123             _removeTokenFromOwnerEnumeration(from, tokenId);
1124         }
1125         if (to == address(0)) {
1126             _removeTokenFromAllTokensEnumeration(tokenId);
1127         } else if (to != from) {
1128             _addTokenToOwnerEnumeration(to, tokenId);
1129         }
1130     }
1131 
1132     /**
1133      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1134      * @param to address representing the new owner of the given token ID
1135      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1136      */
1137     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1138         uint256 length = ERC721.balanceOf(to);
1139         _ownedTokens[to][length] = tokenId;
1140         _ownedTokensIndex[tokenId] = length;
1141     }
1142 
1143     /**
1144      * @dev Private function to add a token to this extension's token tracking data structures.
1145      * @param tokenId uint256 ID of the token to be added to the tokens list
1146      */
1147     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1148         _allTokensIndex[tokenId] = _allTokens.length;
1149         _allTokens.push(tokenId);
1150     }
1151 
1152     /**
1153      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1154      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1155      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1156      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1157      * @param from address representing the previous owner of the given token ID
1158      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1159      */
1160     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1161         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1162         // then delete the last slot (swap and pop).
1163 
1164         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1165         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1166 
1167         // When the token to delete is the last token, the swap operation is unnecessary
1168         if (tokenIndex != lastTokenIndex) {
1169             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1170 
1171             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1172             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1173         }
1174 
1175         // This also deletes the contents at the last position of the array
1176         delete _ownedTokensIndex[tokenId];
1177         delete _ownedTokens[from][lastTokenIndex];
1178     }
1179 
1180     /**
1181      * @dev Private function to remove a token from this extension's token tracking data structures.
1182      * This has O(1) time complexity, but alters the order of the _allTokens array.
1183      * @param tokenId uint256 ID of the token to be removed from the tokens list
1184      */
1185     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1186         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1187         // then delete the last slot (swap and pop).
1188 
1189         uint256 lastTokenIndex = _allTokens.length - 1;
1190         uint256 tokenIndex = _allTokensIndex[tokenId];
1191 
1192         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1193         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1194         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1195         uint256 lastTokenId = _allTokens[lastTokenIndex];
1196 
1197         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1198         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1199 
1200         // This also deletes the contents at the last position of the array
1201         delete _allTokensIndex[tokenId];
1202         _allTokens.pop();
1203     }
1204 }
1205 
1206 // File: contracts/SaconiHolmovimiento.sol
1207 
1208 /*
1209 ╔═╗┌─┐┌─┐┌─┐┌┐┌┬  ╔═╗┌─┐┌┐┌┌─┐┬─┐┌─┐┌┬┐┬┬  ┬┌─┐
1210 ╚═╗├─┤│  │ │││││  ║ ╦├┤ │││├┤ ├┬┘├─┤ │ │└┐┌┘├┤ 
1211 ╚═╝┴ ┴└─┘└─┘┘└┘┴  ╚═╝└─┘┘└┘└─┘┴└─┴ ┴ ┴ ┴ └┘ └─┘
1212 */
1213 
1214 pragma solidity ^0.8.2;
1215 
1216 contract SaconiHolmovimiento is ERC721, ERC721Enumerable, Ownable {
1217     uint256 public constant MAX_SUPPLY = 2000;
1218     uint256 public constant PRICE = 0.04 ether;
1219     uint256 private tokenCounter;
1220     bool public saleActive;
1221 
1222     string private URI = "https://gateway.pinata.cloud/ipfs/QmQ32LbxeNhQCsHgp521M5NRddUYMhh2WGdoWGGXyPq3oF/";
1223 
1224     constructor() ERC721("Saconi Holmovimiento", "SGHM") {}
1225 
1226     function _baseURI() internal view override returns (string memory) {
1227         return URI;
1228     }
1229 
1230     function setURI(string memory _URI) external onlyOwner {
1231         URI = _URI;
1232     }
1233 
1234     function flipSale() external onlyOwner {
1235         saleActive = !saleActive;
1236     }
1237 
1238     function mint(address to, uint256 amount) external payable {
1239         require(saleActive, "Sale inactive");
1240         require(amount <= 10, "Exceeds 10");
1241         require(amount + tokenCounter < MAX_SUPPLY, "Supply limit");
1242         require(msg.value >= amount * PRICE, "Incorrect ETH");
1243 
1244         // Solidity optimization
1245         uint256 _tokenCounter = tokenCounter;
1246         for (uint256 i = 0; i < amount; i++) {
1247             _safeMint(to, _tokenCounter);
1248             _tokenCounter++;
1249         }
1250         tokenCounter = _tokenCounter;
1251     }
1252 
1253     // cash money
1254     function withdrawAll() external payable onlyOwner {
1255         payable(owner()).transfer(address(this).balance);
1256     }
1257 
1258     function forge(address to, uint256 amount) external onlyOwner {
1259         require(amount <= 10, "Exceeds 10");
1260         require(amount + tokenCounter < MAX_SUPPLY, "Supply limit!");
1261 
1262         // Solidity optimization
1263         uint256 _tokenCounter = tokenCounter;
1264         for (uint256 i = 0; i < amount; i++) {
1265             _safeMint(to, _tokenCounter);
1266             _tokenCounter++;
1267         }
1268         tokenCounter = _tokenCounter;
1269     }
1270 
1271     function _beforeTokenTransfer(
1272         address from,
1273         address to,
1274         uint256 tokenId
1275     ) internal override(ERC721, ERC721Enumerable) {
1276         super._beforeTokenTransfer(from, to, tokenId);
1277     }
1278 
1279     function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
1280         return super.supportsInterface(interfaceId);
1281     }
1282 }