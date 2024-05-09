1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
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
29 pragma solidity ^0.8.0;
30 
31 /**
32  * @dev Contract module which provides a basic access control mechanism, where
33  * there is an account (an owner) that can be granted exclusive access to
34  * specific functions.
35  *
36  * By default, the owner account will be the one that deploys the contract. This
37  * can later be changed with {transferOwnership}.
38  *
39  * This module is used through inheritance. It will make available the modifier
40  * `onlyOwner`, which can be applied to your functions to restrict their use to
41  * the owner.
42  */
43 abstract contract Ownable is Context {
44     address private _owner;
45 
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48     /**
49      * @dev Initializes the contract setting the deployer as the initial owner.
50      */
51     constructor() {
52         _setOwner(_msgSender());
53     }
54 
55     /**
56      * @dev Returns the address of the current owner.
57      */
58     function owner() public view virtual returns (address) {
59         return _owner;
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         require(owner() == _msgSender(), "Ownable: caller is not the owner");
67         _;
68     }
69 
70     /**
71      * @dev Leaves the contract without owner. It will not be possible to call
72      * `onlyOwner` functions anymore. Can only be called by the current owner.
73      *
74      * NOTE: Renouncing ownership will leave the contract without an owner,
75      * thereby removing any functionality that is only available to the owner.
76      */
77     function renounceOwnership() public virtual onlyOwner {
78         _setOwner(address(0));
79     }
80 
81     /**
82      * @dev Transfers ownership of the contract to a new account (`newOwner`).
83      * Can only be called by the current owner.
84      */
85     function transferOwnership(address newOwner) public virtual onlyOwner {
86         require(newOwner != address(0), "Ownable: new owner is the zero address");
87         _setOwner(newOwner);
88     }
89 
90     function _setOwner(address newOwner) private {
91         address oldOwner = _owner;
92         _owner = newOwner;
93         emit OwnershipTransferred(oldOwner, newOwner);
94     }
95 }
96 
97 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
98 
99 pragma solidity ^0.8.0;
100 
101 /**
102  * @dev Interface of the ERC165 standard, as defined in the
103  * https://eips.ethereum.org/EIPS/eip-165[EIP].
104  *
105  * Implementers can declare support of contract interfaces, which can then be
106  * queried by others ({ERC165Checker}).
107  *
108  * For an implementation, see {ERC165}.
109  */
110 interface IERC165 {
111     /**
112      * @dev Returns true if this contract implements the interface defined by
113      * `interfaceId`. See the corresponding
114      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
115      * to learn more about how these ids are created.
116      *
117      * This function call must use less than 30 000 gas.
118      */
119     function supportsInterface(bytes4 interfaceId) external view returns (bool);
120 }
121 
122 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
123 
124 pragma solidity ^0.8.0;
125 
126 /**
127  * @dev Required interface of an ERC721 compliant contract.
128  */
129 interface IERC721 is IERC165 {
130     /**
131      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
132      */
133     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
134 
135     /**
136      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
137      */
138     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
139 
140     /**
141      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
142      */
143     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
144 
145     /**
146      * @dev Returns the number of tokens in ``owner``'s account.
147      */
148     function balanceOf(address owner) external view returns (uint256 balance);
149 
150     /**
151      * @dev Returns the owner of the `tokenId` token.
152      *
153      * Requirements:
154      *
155      * - `tokenId` must exist.
156      */
157     function ownerOf(uint256 tokenId) external view returns (address owner);
158 
159     /**
160      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
161      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
162      *
163      * Requirements:
164      *
165      * - `from` cannot be the zero address.
166      * - `to` cannot be the zero address.
167      * - `tokenId` token must exist and be owned by `from`.
168      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
169      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
170      *
171      * Emits a {Transfer} event.
172      */
173     function safeTransferFrom(
174         address from,
175         address to,
176         uint256 tokenId
177     ) external;
178 
179     /**
180      * @dev Transfers `tokenId` token from `from` to `to`.
181      *
182      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
183      *
184      * Requirements:
185      *
186      * - `from` cannot be the zero address.
187      * - `to` cannot be the zero address.
188      * - `tokenId` token must be owned by `from`.
189      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
190      *
191      * Emits a {Transfer} event.
192      */
193     function transferFrom(
194         address from,
195         address to,
196         uint256 tokenId
197     ) external;
198 
199     /**
200      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
201      * The approval is cleared when the token is transferred.
202      *
203      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
204      *
205      * Requirements:
206      *
207      * - The caller must own the token or be an approved operator.
208      * - `tokenId` must exist.
209      *
210      * Emits an {Approval} event.
211      */
212     function approve(address to, uint256 tokenId) external;
213 
214     /**
215      * @dev Returns the account approved for `tokenId` token.
216      *
217      * Requirements:
218      *
219      * - `tokenId` must exist.
220      */
221     function getApproved(uint256 tokenId) external view returns (address operator);
222 
223     /**
224      * @dev Approve or remove `operator` as an operator for the caller.
225      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
226      *
227      * Requirements:
228      *
229      * - The `operator` cannot be the caller.
230      *
231      * Emits an {ApprovalForAll} event.
232      */
233     function setApprovalForAll(address operator, bool _approved) external;
234 
235     /**
236      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
237      *
238      * See {setApprovalForAll}
239      */
240     function isApprovedForAll(address owner, address operator) external view returns (bool);
241 
242     /**
243      * @dev Safely transfers `tokenId` token from `from` to `to`.
244      *
245      * Requirements:
246      *
247      * - `from` cannot be the zero address.
248      * - `to` cannot be the zero address.
249      * - `tokenId` token must exist and be owned by `from`.
250      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
251      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
252      *
253      * Emits a {Transfer} event.
254      */
255     function safeTransferFrom(
256         address from,
257         address to,
258         uint256 tokenId,
259         bytes calldata data
260     ) external;
261 }
262 
263 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
264 
265 pragma solidity ^0.8.0;
266 
267 /**
268  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
269  * @dev See https://eips.ethereum.org/EIPS/eip-721
270  */
271 interface IERC721Enumerable is IERC721 {
272     /**
273      * @dev Returns the total amount of tokens stored by the contract.
274      */
275     function totalSupply() external view returns (uint256);
276 
277     /**
278      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
279      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
280      */
281     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
282 
283     /**
284      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
285      * Use along with {totalSupply} to enumerate all tokens.
286      */
287     function tokenByIndex(uint256 index) external view returns (uint256);
288 }
289 
290 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
291 
292 pragma solidity ^0.8.0;
293 
294 /**
295  * @dev Implementation of the {IERC165} interface.
296  *
297  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
298  * for the additional interface id that will be supported. For example:
299  *
300  * ```solidity
301  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
302  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
303  * }
304  * ```
305  *
306  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
307  */
308 abstract contract ERC165 is IERC165 {
309     /**
310      * @dev See {IERC165-supportsInterface}.
311      */
312     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
313         return interfaceId == type(IERC165).interfaceId;
314     }
315 }
316 
317 // File: @openzeppelin/contracts/utils/Strings.sol
318 
319 pragma solidity ^0.8.0;
320 
321 /**
322  * @dev String operations.
323  */
324 library Strings {
325     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
326 
327     /**
328      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
329      */
330     function toString(uint256 value) internal pure returns (string memory) {
331         // Inspired by OraclizeAPI's implementation - MIT licence
332         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
333 
334         if (value == 0) {
335             return "0";
336         }
337         uint256 temp = value;
338         uint256 digits;
339         while (temp != 0) {
340             digits++;
341             temp /= 10;
342         }
343         bytes memory buffer = new bytes(digits);
344         while (value != 0) {
345             digits -= 1;
346             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
347             value /= 10;
348         }
349         return string(buffer);
350     }
351 
352     /**
353      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
354      */
355     function toHexString(uint256 value) internal pure returns (string memory) {
356         if (value == 0) {
357             return "0x00";
358         }
359         uint256 temp = value;
360         uint256 length = 0;
361         while (temp != 0) {
362             length++;
363             temp >>= 8;
364         }
365         return toHexString(value, length);
366     }
367 
368     /**
369      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
370      */
371     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
372         bytes memory buffer = new bytes(2 * length + 2);
373         buffer[0] = "0";
374         buffer[1] = "x";
375         for (uint256 i = 2 * length + 1; i > 1; --i) {
376             buffer[i] = _HEX_SYMBOLS[value & 0xf];
377             value >>= 4;
378         }
379         require(value == 0, "Strings: hex length insufficient");
380         return string(buffer);
381     }
382 }
383 
384 // File: @openzeppelin/contracts/utils/Address.sol
385 
386 pragma solidity ^0.8.0;
387 
388 /**
389  * @dev Collection of functions related to the address type
390  */
391 library Address {
392     /**
393      * @dev Returns true if `account` is a contract.
394      *
395      * [IMPORTANT]
396      * ====
397      * It is unsafe to assume that an address for which this function returns
398      * false is an externally-owned account (EOA) and not a contract.
399      *
400      * Among others, `isContract` will return false for the following
401      * types of addresses:
402      *
403      *  - an externally-owned account
404      *  - a contract in construction
405      *  - an address where a contract will be created
406      *  - an address where a contract lived, but was destroyed
407      * ====
408      */
409     function isContract(address account) internal view returns (bool) {
410         // This method relies on extcodesize, which returns 0 for contracts in
411         // construction, since the code is only stored at the end of the
412         // constructor execution.
413 
414         uint256 size;
415         assembly {
416             size := extcodesize(account)
417         }
418         return size > 0;
419     }
420 
421     /**
422      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
423      * `recipient`, forwarding all available gas and reverting on errors.
424      *
425      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
426      * of certain opcodes, possibly making contracts go over the 2300 gas limit
427      * imposed by `transfer`, making them unable to receive funds via
428      * `transfer`. {sendValue} removes this limitation.
429      *
430      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
431      *
432      * IMPORTANT: because control is transferred to `recipient`, care must be
433      * taken to not create reentrancy vulnerabilities. Consider using
434      * {ReentrancyGuard} or the
435      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
436      */
437     function sendValue(address payable recipient, uint256 amount) internal {
438         require(address(this).balance >= amount, "Address: insufficient balance");
439 
440         (bool success, ) = recipient.call{value: amount}("");
441         require(success, "Address: unable to send value, recipient may have reverted");
442     }
443 
444     /**
445      * @dev Performs a Solidity function call using a low level `call`. A
446      * plain `call` is an unsafe replacement for a function call: use this
447      * function instead.
448      *
449      * If `target` reverts with a revert reason, it is bubbled up by this
450      * function (like regular Solidity function calls).
451      *
452      * Returns the raw returned data. To convert to the expected return value,
453      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
454      *
455      * Requirements:
456      *
457      * - `target` must be a contract.
458      * - calling `target` with `data` must not revert.
459      *
460      * _Available since v3.1._
461      */
462     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
463         return functionCall(target, data, "Address: low-level call failed");
464     }
465 
466     /**
467      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
468      * `errorMessage` as a fallback revert reason when `target` reverts.
469      *
470      * _Available since v3.1._
471      */
472     function functionCall(
473         address target,
474         bytes memory data,
475         string memory errorMessage
476     ) internal returns (bytes memory) {
477         return functionCallWithValue(target, data, 0, errorMessage);
478     }
479 
480     /**
481      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
482      * but also transferring `value` wei to `target`.
483      *
484      * Requirements:
485      *
486      * - the calling contract must have an ETH balance of at least `value`.
487      * - the called Solidity function must be `payable`.
488      *
489      * _Available since v3.1._
490      */
491     function functionCallWithValue(
492         address target,
493         bytes memory data,
494         uint256 value
495     ) internal returns (bytes memory) {
496         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
497     }
498 
499     /**
500      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
501      * with `errorMessage` as a fallback revert reason when `target` reverts.
502      *
503      * _Available since v3.1._
504      */
505     function functionCallWithValue(
506         address target,
507         bytes memory data,
508         uint256 value,
509         string memory errorMessage
510     ) internal returns (bytes memory) {
511         require(address(this).balance >= value, "Address: insufficient balance for call");
512         require(isContract(target), "Address: call to non-contract");
513 
514         (bool success, bytes memory returndata) = target.call{value: value}(data);
515         return verifyCallResult(success, returndata, errorMessage);
516     }
517 
518     /**
519      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
520      * but performing a static call.
521      *
522      * _Available since v3.3._
523      */
524     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
525         return functionStaticCall(target, data, "Address: low-level static call failed");
526     }
527 
528     /**
529      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
530      * but performing a static call.
531      *
532      * _Available since v3.3._
533      */
534     function functionStaticCall(
535         address target,
536         bytes memory data,
537         string memory errorMessage
538     ) internal view returns (bytes memory) {
539         require(isContract(target), "Address: static call to non-contract");
540 
541         (bool success, bytes memory returndata) = target.staticcall(data);
542         return verifyCallResult(success, returndata, errorMessage);
543     }
544 
545     /**
546      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
547      * but performing a delegate call.
548      *
549      * _Available since v3.4._
550      */
551     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
552         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
553     }
554 
555     /**
556      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
557      * but performing a delegate call.
558      *
559      * _Available since v3.4._
560      */
561     function functionDelegateCall(
562         address target,
563         bytes memory data,
564         string memory errorMessage
565     ) internal returns (bytes memory) {
566         require(isContract(target), "Address: delegate call to non-contract");
567 
568         (bool success, bytes memory returndata) = target.delegatecall(data);
569         return verifyCallResult(success, returndata, errorMessage);
570     }
571 
572     /**
573      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
574      * revert reason using the provided one.
575      *
576      * _Available since v4.3._
577      */
578     function verifyCallResult(
579         bool success,
580         bytes memory returndata,
581         string memory errorMessage
582     ) internal pure returns (bytes memory) {
583         if (success) {
584             return returndata;
585         } else {
586             // Look for revert reason and bubble it up if present
587             if (returndata.length > 0) {
588                 // The easiest way to bubble the revert reason is using memory via assembly
589 
590                 assembly {
591                     let returndata_size := mload(returndata)
592                     revert(add(32, returndata), returndata_size)
593                 }
594             } else {
595                 revert(errorMessage);
596             }
597         }
598     }
599 }
600 
601 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
602 
603 pragma solidity ^0.8.0;
604 
605 /**
606  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
607  * @dev See https://eips.ethereum.org/EIPS/eip-721
608  */
609 interface IERC721Metadata is IERC721 {
610     /**
611      * @dev Returns the token collection name.
612      */
613     function name() external view returns (string memory);
614 
615     /**
616      * @dev Returns the token collection symbol.
617      */
618     function symbol() external view returns (string memory);
619 
620     /**
621      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
622      */
623     function tokenURI(uint256 tokenId) external view returns (string memory);
624 }
625 
626 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
627 
628 pragma solidity ^0.8.0;
629 
630 /**
631  * @title ERC721 token receiver interface
632  * @dev Interface for any contract that wants to support safeTransfers
633  * from ERC721 asset contracts.
634  */
635 interface IERC721Receiver {
636     /**
637      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
638      * by `operator` from `from`, this function is called.
639      *
640      * It must return its Solidity selector to confirm the token transfer.
641      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
642      *
643      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
644      */
645     function onERC721Received(
646         address operator,
647         address from,
648         uint256 tokenId,
649         bytes calldata data
650     ) external returns (bytes4);
651 }
652 
653 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
654 
655 pragma solidity ^0.8.0;
656 
657 /**
658  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
659  * the Metadata extension, but not including the Enumerable extension, which is available separately as
660  * {ERC721Enumerable}.
661  */
662 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
663     using Address for address;
664     using Strings for uint256;
665 
666     // Token name
667     string private _name;
668 
669     // Token symbol
670     string private _symbol;
671 
672     // Mapping from token ID to owner address
673     mapping(uint256 => address) private _owners;
674 
675     // Mapping owner address to token count
676     mapping(address => uint256) private _balances;
677 
678     // Mapping from token ID to approved address
679     mapping(uint256 => address) private _tokenApprovals;
680 
681     // Mapping from owner to operator approvals
682     mapping(address => mapping(address => bool)) private _operatorApprovals;
683 
684     /**
685      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
686      */
687     constructor(string memory name_, string memory symbol_) {
688         _name = name_;
689         _symbol = symbol_;
690     }
691 
692     /**
693      * @dev See {IERC165-supportsInterface}.
694      */
695     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
696         return
697             interfaceId == type(IERC721).interfaceId ||
698             interfaceId == type(IERC721Metadata).interfaceId ||
699             super.supportsInterface(interfaceId);
700     }
701 
702     /**
703      * @dev See {IERC721-balanceOf}.
704      */
705     function balanceOf(address owner) public view virtual override returns (uint256) {
706         require(owner != address(0), "ERC721: balance query for the zero address");
707         return _balances[owner];
708     }
709 
710     /**
711      * @dev See {IERC721-ownerOf}.
712      */
713     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
714         address owner = _owners[tokenId];
715         require(owner != address(0), "ERC721: owner query for nonexistent token");
716         return owner;
717     }
718 
719     /**
720      * @dev See {IERC721Metadata-name}.
721      */
722     function name() public view virtual override returns (string memory) {
723         return _name;
724     }
725 
726     /**
727      * @dev See {IERC721Metadata-symbol}.
728      */
729     function symbol() public view virtual override returns (string memory) {
730         return _symbol;
731     }
732 
733     /**
734      * @dev See {IERC721Metadata-tokenURI}.
735      */
736     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
737         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
738 
739         string memory baseURI = _baseURI();
740         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
741     }
742 
743     /**
744      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
745      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
746      * by default, can be overriden in child contracts.
747      */
748     function _baseURI() internal view virtual returns (string memory) {
749         return "";
750     }
751 
752     /**
753      * @dev See {IERC721-approve}.
754      */
755     function approve(address to, uint256 tokenId) public virtual override {
756         address owner = ERC721.ownerOf(tokenId);
757         require(to != owner, "ERC721: approval to current owner");
758 
759         require(
760             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
761             "ERC721: approve caller is not owner nor approved for all"
762         );
763 
764         _approve(to, tokenId);
765     }
766 
767     /**
768      * @dev See {IERC721-getApproved}.
769      */
770     function getApproved(uint256 tokenId) public view virtual override returns (address) {
771         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
772 
773         return _tokenApprovals[tokenId];
774     }
775 
776     /**
777      * @dev See {IERC721-setApprovalForAll}.
778      */
779     function setApprovalForAll(address operator, bool approved) public virtual override {
780         require(operator != _msgSender(), "ERC721: approve to caller");
781 
782         _operatorApprovals[_msgSender()][operator] = approved;
783         emit ApprovalForAll(_msgSender(), operator, approved);
784     }
785 
786     /**
787      * @dev See {IERC721-isApprovedForAll}.
788      */
789     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
790         return _operatorApprovals[owner][operator];
791     }
792 
793     /**
794      * @dev See {IERC721-transferFrom}.
795      */
796     function transferFrom(
797         address from,
798         address to,
799         uint256 tokenId
800     ) public virtual override {
801         //solhint-disable-next-line max-line-length
802         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
803 
804         _transfer(from, to, tokenId);
805     }
806 
807     /**
808      * @dev See {IERC721-safeTransferFrom}.
809      */
810     function safeTransferFrom(
811         address from,
812         address to,
813         uint256 tokenId
814     ) public virtual override {
815         safeTransferFrom(from, to, tokenId, "");
816     }
817 
818     /**
819      * @dev See {IERC721-safeTransferFrom}.
820      */
821     function safeTransferFrom(
822         address from,
823         address to,
824         uint256 tokenId,
825         bytes memory _data
826     ) public virtual override {
827         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
828         _safeTransfer(from, to, tokenId, _data);
829     }
830 
831     /**
832      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
833      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
834      *
835      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
836      *
837      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
838      * implement alternative mechanisms to perform token transfer, such as signature-based.
839      *
840      * Requirements:
841      *
842      * - `from` cannot be the zero address.
843      * - `to` cannot be the zero address.
844      * - `tokenId` token must exist and be owned by `from`.
845      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
846      *
847      * Emits a {Transfer} event.
848      */
849     function _safeTransfer(
850         address from,
851         address to,
852         uint256 tokenId,
853         bytes memory _data
854     ) internal virtual {
855         _transfer(from, to, tokenId);
856         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
857     }
858 
859     /**
860      * @dev Returns whether `tokenId` exists.
861      *
862      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
863      *
864      * Tokens start existing when they are minted (`_mint`),
865      * and stop existing when they are burned (`_burn`).
866      */
867     function _exists(uint256 tokenId) internal view virtual returns (bool) {
868         return _owners[tokenId] != address(0);
869     }
870 
871     /**
872      * @dev Returns whether `spender` is allowed to manage `tokenId`.
873      *
874      * Requirements:
875      *
876      * - `tokenId` must exist.
877      */
878     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
879         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
880         address owner = ERC721.ownerOf(tokenId);
881         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
882     }
883 
884     /**
885      * @dev Safely mints `tokenId` and transfers it to `to`.
886      *
887      * Requirements:
888      *
889      * - `tokenId` must not exist.
890      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
891      *
892      * Emits a {Transfer} event.
893      */
894     function _safeMint(address to, uint256 tokenId) internal virtual {
895         _safeMint(to, tokenId, "");
896     }
897 
898     /**
899      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
900      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
901      */
902     function _safeMint(
903         address to,
904         uint256 tokenId,
905         bytes memory _data
906     ) internal virtual {
907         _mint(to, tokenId);
908         require(
909             _checkOnERC721Received(address(0), to, tokenId, _data),
910             "ERC721: transfer to non ERC721Receiver implementer"
911         );
912     }
913 
914     /**
915      * @dev Mints `tokenId` and transfers it to `to`.
916      *
917      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
918      *
919      * Requirements:
920      *
921      * - `tokenId` must not exist.
922      * - `to` cannot be the zero address.
923      *
924      * Emits a {Transfer} event.
925      */
926     function _mint(address to, uint256 tokenId) internal virtual {
927         require(to != address(0), "ERC721: mint to the zero address");
928         require(!_exists(tokenId), "ERC721: token already minted");
929 
930         _beforeTokenTransfer(address(0), to, tokenId);
931 
932         _balances[to] += 1;
933         _owners[tokenId] = to;
934 
935         emit Transfer(address(0), to, tokenId);
936     }
937 
938     /**
939      * @dev Destroys `tokenId`.
940      * The approval is cleared when the token is burned.
941      *
942      * Requirements:
943      *
944      * - `tokenId` must exist.
945      *
946      * Emits a {Transfer} event.
947      */
948     function _burn(uint256 tokenId) internal virtual {
949         address owner = ERC721.ownerOf(tokenId);
950 
951         _beforeTokenTransfer(owner, address(0), tokenId);
952 
953         // Clear approvals
954         _approve(address(0), tokenId);
955 
956         _balances[owner] -= 1;
957         delete _owners[tokenId];
958 
959         emit Transfer(owner, address(0), tokenId);
960     }
961 
962     /**
963      * @dev Transfers `tokenId` from `from` to `to`.
964      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
965      *
966      * Requirements:
967      *
968      * - `to` cannot be the zero address.
969      * - `tokenId` token must be owned by `from`.
970      *
971      * Emits a {Transfer} event.
972      */
973     function _transfer(
974         address from,
975         address to,
976         uint256 tokenId
977     ) internal virtual {
978         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
979         require(to != address(0), "ERC721: transfer to the zero address");
980 
981         _beforeTokenTransfer(from, to, tokenId);
982 
983         // Clear approvals from the previous owner
984         _approve(address(0), tokenId);
985 
986         _balances[from] -= 1;
987         _balances[to] += 1;
988         _owners[tokenId] = to;
989 
990         emit Transfer(from, to, tokenId);
991     }
992 
993     /**
994      * @dev Approve `to` to operate on `tokenId`
995      *
996      * Emits a {Approval} event.
997      */
998     function _approve(address to, uint256 tokenId) internal virtual {
999         _tokenApprovals[tokenId] = to;
1000         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1001     }
1002 
1003     /**
1004      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1005      * The call is not executed if the target address is not a contract.
1006      *
1007      * @param from address representing the previous owner of the given token ID
1008      * @param to target address that will receive the tokens
1009      * @param tokenId uint256 ID of the token to be transferred
1010      * @param _data bytes optional data to send along with the call
1011      * @return bool whether the call correctly returned the expected magic value
1012      */
1013     function _checkOnERC721Received(
1014         address from,
1015         address to,
1016         uint256 tokenId,
1017         bytes memory _data
1018     ) private returns (bool) {
1019         if (to.isContract()) {
1020             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1021                 return retval == IERC721Receiver.onERC721Received.selector;
1022             } catch (bytes memory reason) {
1023                 if (reason.length == 0) {
1024                     revert("ERC721: transfer to non ERC721Receiver implementer");
1025                 } else {
1026                     assembly {
1027                         revert(add(32, reason), mload(reason))
1028                     }
1029                 }
1030             }
1031         } else {
1032             return true;
1033         }
1034     }
1035 
1036     /**
1037      * @dev Hook that is called before any token transfer. This includes minting
1038      * and burning.
1039      *
1040      * Calling conditions:
1041      *
1042      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1043      * transferred to `to`.
1044      * - When `from` is zero, `tokenId` will be minted for `to`.
1045      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1046      * - `from` and `to` are never both zero.
1047      *
1048      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1049      */
1050     function _beforeTokenTransfer(
1051         address from,
1052         address to,
1053         uint256 tokenId
1054     ) internal virtual {}
1055 }
1056 
1057 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1058 
1059 pragma solidity ^0.8.0;
1060 
1061 /**
1062  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1063  * enumerability of all the token ids in the contract as well as all token ids owned by each
1064  * account.
1065  */
1066 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1067     // Mapping from owner to list of owned token IDs
1068     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1069 
1070     // Mapping from token ID to index of the owner tokens list
1071     mapping(uint256 => uint256) private _ownedTokensIndex;
1072 
1073     // Array with all token ids, used for enumeration
1074     uint256[] private _allTokens;
1075 
1076     // Mapping from token id to position in the allTokens array
1077     mapping(uint256 => uint256) private _allTokensIndex;
1078 
1079     /**
1080      * @dev See {IERC165-supportsInterface}.
1081      */
1082     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1083         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1084     }
1085 
1086     /**
1087      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1088      */
1089     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1090         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1091         return _ownedTokens[owner][index];
1092     }
1093 
1094     /**
1095      * @dev See {IERC721Enumerable-totalSupply}.
1096      */
1097     function totalSupply() public view virtual override returns (uint256) {
1098         return _allTokens.length;
1099     }
1100 
1101     /**
1102      * @dev See {IERC721Enumerable-tokenByIndex}.
1103      */
1104     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1105         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1106         return _allTokens[index];
1107     }
1108 
1109     /**
1110      * @dev Hook that is called before any token transfer. This includes minting
1111      * and burning.
1112      *
1113      * Calling conditions:
1114      *
1115      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1116      * transferred to `to`.
1117      * - When `from` is zero, `tokenId` will be minted for `to`.
1118      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1119      * - `from` cannot be the zero address.
1120      * - `to` cannot be the zero address.
1121      *
1122      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1123      */
1124     function _beforeTokenTransfer(
1125         address from,
1126         address to,
1127         uint256 tokenId
1128     ) internal virtual override {
1129         super._beforeTokenTransfer(from, to, tokenId);
1130 
1131         if (from == address(0)) {
1132             _addTokenToAllTokensEnumeration(tokenId);
1133         } else if (from != to) {
1134             _removeTokenFromOwnerEnumeration(from, tokenId);
1135         }
1136         if (to == address(0)) {
1137             _removeTokenFromAllTokensEnumeration(tokenId);
1138         } else if (to != from) {
1139             _addTokenToOwnerEnumeration(to, tokenId);
1140         }
1141     }
1142 
1143     /**
1144      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1145      * @param to address representing the new owner of the given token ID
1146      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1147      */
1148     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1149         uint256 length = ERC721.balanceOf(to);
1150         _ownedTokens[to][length] = tokenId;
1151         _ownedTokensIndex[tokenId] = length;
1152     }
1153 
1154     /**
1155      * @dev Private function to add a token to this extension's token tracking data structures.
1156      * @param tokenId uint256 ID of the token to be added to the tokens list
1157      */
1158     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1159         _allTokensIndex[tokenId] = _allTokens.length;
1160         _allTokens.push(tokenId);
1161     }
1162 
1163     /**
1164      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1165      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1166      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1167      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1168      * @param from address representing the previous owner of the given token ID
1169      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1170      */
1171     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1172         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1173         // then delete the last slot (swap and pop).
1174 
1175         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1176         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1177 
1178         // When the token to delete is the last token, the swap operation is unnecessary
1179         if (tokenIndex != lastTokenIndex) {
1180             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1181 
1182             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1183             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1184         }
1185 
1186         // This also deletes the contents at the last position of the array
1187         delete _ownedTokensIndex[tokenId];
1188         delete _ownedTokens[from][lastTokenIndex];
1189     }
1190 
1191     /**
1192      * @dev Private function to remove a token from this extension's token tracking data structures.
1193      * This has O(1) time complexity, but alters the order of the _allTokens array.
1194      * @param tokenId uint256 ID of the token to be removed from the tokens list
1195      */
1196     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1197         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1198         // then delete the last slot (swap and pop).
1199 
1200         uint256 lastTokenIndex = _allTokens.length - 1;
1201         uint256 tokenIndex = _allTokensIndex[tokenId];
1202 
1203         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1204         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1205         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1206         uint256 lastTokenId = _allTokens[lastTokenIndex];
1207 
1208         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1209         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1210 
1211         // This also deletes the contents at the last position of the array
1212         delete _allTokensIndex[tokenId];
1213         _allTokens.pop();
1214     }
1215 }
1216 
1217 // File: contracts/DogTagNFT.sol
1218 
1219 pragma solidity ^0.8.0;
1220 
1221 contract DogTagNFT is ERC721Enumerable, Ownable {
1222   using Strings for uint256;
1223 
1224   string public baseURI;
1225   string public baseExtension = ".json";
1226   uint256 public price = 0.08 ether;
1227   uint256 public maxSupply = 25000;
1228   uint256 public maxMintAmount = 25;
1229   bool public paused = false;
1230 
1231   constructor(string memory _initBaseURI) ERC721("DogTagNFT", "DGTG") {
1232     setBaseURI(_initBaseURI);
1233     //For promos, giveaways, and the team.
1234     mint(msg.sender, 25);
1235   }
1236 
1237   function mint(address _to, uint256 _mintAmount) public payable {
1238     uint256 supply = totalSupply();
1239     require(!paused);
1240     require(_mintAmount > 0);
1241     require(_mintAmount <= maxMintAmount);
1242     require(supply + _mintAmount <= maxSupply);
1243 
1244     if (msg.sender != owner()) {
1245           require(msg.value >= price * _mintAmount);
1246     }
1247 
1248     for (uint256 i = 0; i < _mintAmount; i++) {
1249       _safeMint(_to, supply + i);
1250     }
1251   }
1252 
1253   function walletOfOwner(address _owner) public view returns (uint256[] memory)
1254   {
1255     uint256 ownerTokenCount = balanceOf(_owner);
1256     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1257     for (uint256 i; i < ownerTokenCount; i++) {
1258       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1259     }
1260     return tokenIds;
1261   }
1262 
1263   function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
1264   {
1265     require(
1266       _exists(tokenId),
1267       "ERC721Metadata: URI query for nonexistent token"
1268     );
1269 
1270     string memory currentBaseURI = _baseURI();
1271     return bytes(currentBaseURI).length > 0
1272         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1273         : "";
1274   }
1275 
1276   function getPrice() public view returns (uint256) {
1277       return price;
1278   }
1279   
1280   function setPrice(uint256 _newPrice) public onlyOwner() {
1281     price = _newPrice;
1282   }
1283 
1284   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
1285     maxMintAmount = _newmaxMintAmount;
1286   }
1287 
1288   function _baseURI() internal view virtual override returns (string memory) {
1289     return baseURI;
1290   }
1291 
1292   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1293     baseURI = _newBaseURI;
1294   }
1295 
1296   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1297     baseExtension = _newBaseExtension;
1298   }
1299 
1300   function pause(bool _state) public onlyOwner {
1301     paused = _state;
1302   }
1303  
1304   function withdraw() public payable onlyOwner {
1305     require(payable(msg.sender).send(address(this).balance));
1306   }
1307 }