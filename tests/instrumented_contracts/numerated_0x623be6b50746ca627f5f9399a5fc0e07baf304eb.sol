1 /**
2  *Submitted for verification at Etherscan.io on 2021-10-03
3 */
4 
5 //SPDX-License-Identifier: MIT
6 
7 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Interface of the ERC165 standard, as defined in the
13  * https://eips.ethereum.org/EIPS/eip-165[EIP].
14  *
15  * Implementers can declare support of contract interfaces, which can then be
16  * queried by others ({ERC165Checker}).
17  *
18  * For an implementation, see {ERC165}.
19  */
20 interface IERC165 {
21     /**
22      * @dev Returns true if this contract implements the interface defined by
23      * `interfaceId`. See the corresponding
24      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
25      * to learn more about how these ids are created.
26      *
27      * This function call must use less than 30 000 gas.
28      */
29     function supportsInterface(bytes4 interfaceId) external view returns (bool);
30 }
31 // File: @openzeppelin/contracts/utils/Context.sol
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev Provides information about the current execution context, including the
37  * sender of the transaction and its data. While these are generally available
38  * via msg.sender and msg.data, they should not be accessed in such a direct
39  * manner, since when dealing with meta-transactions the account sending and
40  * paying for execution may not be the actual sender (as far as an application
41  * is concerned).
42  *
43  * This contract is only required for intermediate, library-like contracts.
44  */
45 abstract contract Context {
46     function _msgSender() internal view virtual returns (address) {
47         return msg.sender;
48     }
49 
50     function _msgData() internal view virtual returns (bytes calldata) {
51         return msg.data;
52     }
53 }
54 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
55 
56 pragma solidity ^0.8.0;
57 
58 /**
59  * @dev Required interface of an ERC721 compliant contract.
60  */
61 interface IERC721 is IERC165 {
62     /**
63      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
64      */
65     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
66 
67     /**
68      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
69      */
70     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
71 
72     /**
73      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
74      */
75     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
76 
77     /**
78      * @dev Returns the number of tokens in ``owner``'s account.
79      */
80     function balanceOf(address owner) external view returns (uint256 balance);
81 
82     /**
83      * @dev Returns the owner of the `tokenId` token.
84      *
85      * Requirements:
86      *
87      * - `tokenId` must exist.
88      */
89     function ownerOf(uint256 tokenId) external view returns (address owner);
90 
91     /**
92      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
93      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
94      *
95      * Requirements:
96      *
97      * - `from` cannot be the zero address.
98      * - `to` cannot be the zero address.
99      * - `tokenId` token must exist and be owned by `from`.
100      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
101      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
102      *
103      * Emits a {Transfer} event.
104      */
105     function safeTransferFrom(
106         address from,
107         address to,
108         uint256 tokenId
109     ) external;
110 
111     /**
112      * @dev Transfers `tokenId` token from `from` to `to`.
113      *
114      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
115      *
116      * Requirements:
117      *
118      * - `from` cannot be the zero address.
119      * - `to` cannot be the zero address.
120      * - `tokenId` token must be owned by `from`.
121      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
122      *
123      * Emits a {Transfer} event.
124      */
125     function transferFrom(
126         address from,
127         address to,
128         uint256 tokenId
129     ) external;
130 
131     /**
132      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
133      * The approval is cleared when the token is transferred.
134      *
135      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
136      *
137      * Requirements:
138      *
139      * - The caller must own the token or be an approved operator.
140      * - `tokenId` must exist.
141      *
142      * Emits an {Approval} event.
143      */
144     function approve(address to, uint256 tokenId) external;
145 
146     /**
147      * @dev Returns the account approved for `tokenId` token.
148      *
149      * Requirements:
150      *
151      * - `tokenId` must exist.
152      */
153     function getApproved(uint256 tokenId) external view returns (address operator);
154 
155     /**
156      * @dev Approve or remove `operator` as an operator for the caller.
157      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
158      *
159      * Requirements:
160      *
161      * - The `operator` cannot be the caller.
162      *
163      * Emits an {ApprovalForAll} event.
164      */
165     function setApprovalForAll(address operator, bool _approved) external;
166 
167     /**
168      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
169      *
170      * See {setApprovalForAll}
171      */
172     function isApprovedForAll(address owner, address operator) external view returns (bool);
173 
174     /**
175      * @dev Safely transfers `tokenId` token from `from` to `to`.
176      *
177      * Requirements:
178      *
179      * - `from` cannot be the zero address.
180      * - `to` cannot be the zero address.
181      * - `tokenId` token must exist and be owned by `from`.
182      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
183      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
184      *
185      * Emits a {Transfer} event.
186      */
187     function safeTransferFrom(
188         address from,
189         address to,
190         uint256 tokenId,
191         bytes calldata data
192     ) external;
193 }
194 
195 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
196 
197 pragma solidity ^0.8.0;
198 
199 /**
200  * @title ERC721 token receiver interface
201  * @dev Interface for any contract that wants to support safeTransfers
202  * from ERC721 asset contracts.
203  */
204 interface IERC721Receiver {
205     /**
206      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
207      * by `operator` from `from`, this function is called.
208      *
209      * It must return its Solidity selector to confirm the token transfer.
210      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
211      *
212      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
213      */
214     function onERC721Received(
215         address operator,
216         address from,
217         uint256 tokenId,
218         bytes calldata data
219     ) external returns (bytes4);
220 }
221 
222 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
223 
224 pragma solidity ^0.8.0;
225 
226 /**
227  * @dev Implementation of the {IERC165} interface.
228  *
229  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
230  * for the additional interface id that will be supported. For example:
231  *
232  * ```solidity
233  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
234  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
235  * }
236  * ```
237  *
238  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
239  */
240 abstract contract ERC165 is IERC165 {
241     /**
242      * @dev See {IERC165-supportsInterface}.
243      */
244     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
245         return interfaceId == type(IERC165).interfaceId;
246     }
247 }
248 
249 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
250 
251 pragma solidity ^0.8.0;
252 
253 /**
254  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
255  * @dev See https://eips.ethereum.org/EIPS/eip-721
256  */
257 interface IERC721Enumerable is IERC721 {
258     /**
259      * @dev Returns the total amount of tokens stored by the contract.
260      */
261     function totalSupply() external view returns (uint256);
262 
263     /**
264      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
265      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
266      */
267     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
268 
269     /**
270      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
271      * Use along with {totalSupply} to enumerate all tokens.
272      */
273     function tokenByIndex(uint256 index) external view returns (uint256);
274 }
275 
276 // File: @openzeppelin/contracts/access/Ownable.sol
277 
278 pragma solidity ^0.8.0;
279 
280 /**
281  * @dev Contract module which provides a basic access control mechanism, where
282  * there is an account (an owner) that can be granted exclusive access to
283  * specific functions.
284  *
285  * By default, the owner account will be the one that deploys the contract. This
286  * can later be changed with {transferOwnership}.
287  *
288  * This module is used through inheritance. It will make available the modifier
289  * `onlyOwner`, which can be applied to your functions to restrict their use to
290  * the owner.
291  */
292 abstract contract Ownable is Context {
293     address private _owner;
294 
295     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
296 
297     /**
298      * @dev Initializes the contract setting the deployer as the initial owner.
299      */
300     constructor() {
301         _setOwner(_msgSender());
302     }
303 
304     /**
305      * @dev Returns the address of the current owner.
306      */
307     function owner() public view virtual returns (address) {
308         return _owner;
309     }
310 
311     /**
312      * @dev Throws if called by any account other than the owner.
313      */
314     modifier onlyOwner() {
315         require(owner() == _msgSender(), "Ownable: caller is not the owner");
316         _;
317     }
318 
319     /**
320      * @dev Leaves the contract without owner. It will not be possible to call
321      * `onlyOwner` functions anymore. Can only be called by the current owner.
322      *
323      * NOTE: Renouncing ownership will leave the contract without an owner,
324      * thereby removing any functionality that is only available to the owner.
325      */
326     function renounceOwnership() public virtual onlyOwner {
327         _setOwner(address(0));
328     }
329 
330     /**
331      * @dev Transfers ownership of the contract to a new account (`newOwner`).
332      * Can only be called by the current owner.
333      */
334     function transferOwnership(address newOwner) public virtual onlyOwner {
335         require(newOwner != address(0), "Ownable: new owner is the zero address");
336         _setOwner(newOwner);
337     }
338 
339     function _setOwner(address newOwner) private {
340         address oldOwner = _owner;
341         _owner = newOwner;
342         emit OwnershipTransferred(oldOwner, newOwner);
343     }
344 }
345 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
346 
347 pragma solidity ^0.8.0;
348 
349 /**
350  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
351  * @dev See https://eips.ethereum.org/EIPS/eip-721
352  */
353 interface IERC721Metadata is IERC721 {
354     /**
355      * @dev Returns the token collection name.
356      */
357     function name() external view returns (string memory);
358 
359     /**
360      * @dev Returns the token collection symbol.
361      */
362     function symbol() external view returns (string memory);
363 
364     /**
365      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
366      */
367     function tokenURI(uint256 tokenId) external view returns (string memory);
368 }
369 
370 // File: @openzeppelin/contracts/utils/Address.sol
371 
372 pragma solidity ^0.8.0;
373 
374 /**
375  * @dev Collection of functions related to the address type
376  */
377 library Address {
378     /**
379      * @dev Returns true if `account` is a contract.
380      *
381      * [IMPORTANT]
382      * ====
383      * It is unsafe to assume that an address for which this function returns
384      * false is an externally-owned account (EOA) and not a contract.
385      *
386      * Among others, `isContract` will return false for the following
387      * types of addresses:
388      *
389      *  - an externally-owned account
390      *  - a contract in construction
391      *  - an address where a contract will be created
392      *  - an address where a contract lived, but was destroyed
393      * ====
394      */
395     function isContract(address account) internal view returns (bool) {
396         // This method relies on extcodesize, which returns 0 for contracts in
397         // construction, since the code is only stored at the end of the
398         // constructor execution.
399 
400         uint256 size;
401         assembly {
402             size := extcodesize(account)
403         }
404         return size > 0;
405     }
406 
407     /**
408      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
409      * `recipient`, forwarding all available gas and reverting on errors.
410      *
411      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
412      * of certain opcodes, possibly making contracts go over the 2300 gas limit
413      * imposed by `transfer`, making them unable to receive funds via
414      * `transfer`. {sendValue} removes this limitation.
415      *
416      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
417      *
418      * IMPORTANT: because control is transferred to `recipient`, care must be
419      * taken to not create reentrancy vulnerabilities. Consider using
420      * {ReentrancyGuard} or the
421      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
422      */
423     function sendValue(address payable recipient, uint256 amount) internal {
424         require(address(this).balance >= amount, "Address: insufficient balance");
425 
426         (bool success, ) = recipient.call{value: amount}("");
427         require(success, "Address: unable to send value, recipient may have reverted");
428     }
429 
430     /**
431      * @dev Performs a Solidity function call using a low level `call`. A
432      * plain `call` is an unsafe replacement for a function call: use this
433      * function instead.
434      *
435      * If `target` reverts with a revert reason, it is bubbled up by this
436      * function (like regular Solidity function calls).
437      *
438      * Returns the raw returned data. To convert to the expected return value,
439      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
440      *
441      * Requirements:
442      *
443      * - `target` must be a contract.
444      * - calling `target` with `data` must not revert.
445      *
446      * _Available since v3.1._
447      */
448     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
449         return functionCall(target, data, "Address: low-level call failed");
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
454      * `errorMessage` as a fallback revert reason when `target` reverts.
455      *
456      * _Available since v3.1._
457      */
458     function functionCall(
459         address target,
460         bytes memory data,
461         string memory errorMessage
462     ) internal returns (bytes memory) {
463         return functionCallWithValue(target, data, 0, errorMessage);
464     }
465 
466     /**
467      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
468      * but also transferring `value` wei to `target`.
469      *
470      * Requirements:
471      *
472      * - the calling contract must have an ETH balance of at least `value`.
473      * - the called Solidity function must be `payable`.
474      *
475      * _Available since v3.1._
476      */
477     function functionCallWithValue(
478         address target,
479         bytes memory data,
480         uint256 value
481     ) internal returns (bytes memory) {
482         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
487      * with `errorMessage` as a fallback revert reason when `target` reverts.
488      *
489      * _Available since v3.1._
490      */
491     function functionCallWithValue(
492         address target,
493         bytes memory data,
494         uint256 value,
495         string memory errorMessage
496     ) internal returns (bytes memory) {
497         require(address(this).balance >= value, "Address: insufficient balance for call");
498         require(isContract(target), "Address: call to non-contract");
499 
500         (bool success, bytes memory returndata) = target.call{value: value}(data);
501         return verifyCallResult(success, returndata, errorMessage);
502     }
503 
504     /**
505      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
506      * but performing a static call.
507      *
508      * _Available since v3.3._
509      */
510     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
511         return functionStaticCall(target, data, "Address: low-level static call failed");
512     }
513 
514     /**
515      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
516      * but performing a static call.
517      *
518      * _Available since v3.3._
519      */
520     function functionStaticCall(
521         address target,
522         bytes memory data,
523         string memory errorMessage
524     ) internal view returns (bytes memory) {
525         require(isContract(target), "Address: static call to non-contract");
526 
527         (bool success, bytes memory returndata) = target.staticcall(data);
528         return verifyCallResult(success, returndata, errorMessage);
529     }
530 
531     /**
532      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
533      * but performing a delegate call.
534      *
535      * _Available since v3.4._
536      */
537     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
538         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
539     }
540 
541     /**
542      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
543      * but performing a delegate call.
544      *
545      * _Available since v3.4._
546      */
547     function functionDelegateCall(
548         address target,
549         bytes memory data,
550         string memory errorMessage
551     ) internal returns (bytes memory) {
552         require(isContract(target), "Address: delegate call to non-contract");
553 
554         (bool success, bytes memory returndata) = target.delegatecall(data);
555         return verifyCallResult(success, returndata, errorMessage);
556     }
557 
558     /**
559      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
560      * revert reason using the provided one.
561      *
562      * _Available since v4.3._
563      */
564     function verifyCallResult(
565         bool success,
566         bytes memory returndata,
567         string memory errorMessage
568     ) internal pure returns (bytes memory) {
569         if (success) {
570             return returndata;
571         } else {
572             // Look for revert reason and bubble it up if present
573             if (returndata.length > 0) {
574                 // The easiest way to bubble the revert reason is using memory via assembly
575 
576                 assembly {
577                     let returndata_size := mload(returndata)
578                     revert(add(32, returndata), returndata_size)
579                 }
580             } else {
581                 revert(errorMessage);
582             }
583         }
584     }
585 }
586 
587 // File: @openzeppelin/contracts/utils/Strings.sol
588 
589 pragma solidity ^0.8.0;
590 
591 /**
592  * @dev String operations.
593  */
594 library Strings {
595     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
596 
597     /**
598      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
599      */
600     function toString(uint256 value) internal pure returns (string memory) {
601         // Inspired by OraclizeAPI's implementation - MIT licence
602         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
603 
604         if (value == 0) {
605             return "0";
606         }
607         uint256 temp = value;
608         uint256 digits;
609         while (temp != 0) {
610             digits++;
611             temp /= 10;
612         }
613         bytes memory buffer = new bytes(digits);
614         while (value != 0) {
615             digits -= 1;
616             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
617             value /= 10;
618         }
619         return string(buffer);
620     }
621 
622     /**
623      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
624      */
625     function toHexString(uint256 value) internal pure returns (string memory) {
626         if (value == 0) {
627             return "0x00";
628         }
629         uint256 temp = value;
630         uint256 length = 0;
631         while (temp != 0) {
632             length++;
633             temp >>= 8;
634         }
635         return toHexString(value, length);
636     }
637 
638     /**
639      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
640      */
641     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
642         bytes memory buffer = new bytes(2 * length + 2);
643         buffer[0] = "0";
644         buffer[1] = "x";
645         for (uint256 i = 2 * length + 1; i > 1; --i) {
646             buffer[i] = _HEX_SYMBOLS[value & 0xf];
647             value >>= 4;
648         }
649         require(value == 0, "Strings: hex length insufficient");
650         return string(buffer);
651     }
652 }
653 
654 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
655 
656 pragma solidity ^0.8.0;
657 
658 /**
659  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
660  * the Metadata extension, but not including the Enumerable extension, which is available separately as
661  * {ERC721Enumerable}.
662  */
663 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
664     using Address for address;
665     using Strings for uint256;
666 
667     // Token name
668     string private _name;
669 
670     // Token symbol
671     string private _symbol;
672 
673     // Mapping from token ID to owner address
674     mapping(uint256 => address) private _owners;
675 
676     // Mapping owner address to token count
677     mapping(address => uint256) private _balances;
678 
679     // Mapping from token ID to approved address
680     mapping(uint256 => address) private _tokenApprovals;
681 
682     // Mapping from owner to operator approvals
683     mapping(address => mapping(address => bool)) private _operatorApprovals;
684 
685     /**
686      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
687      */
688     constructor(string memory name_, string memory symbol_) {
689         _name = name_;
690         _symbol = symbol_;
691     }
692 
693     /**
694      * @dev See {IERC165-supportsInterface}.
695      */
696     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
697         return
698             interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC721Metadata).interfaceId || super.supportsInterface(interfaceId);
699     }
700 
701     /**
702      * @dev See {IERC721-balanceOf}.
703      */
704     function balanceOf(address owner) public view virtual override returns (uint256) {
705         require(owner != address(0), "ERC721: balance query for the zero address");
706         return _balances[owner];
707     }
708 
709     /**
710      * @dev See {IERC721-ownerOf}.
711      */
712     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
713         address owner = _owners[tokenId];
714         require(owner != address(0), "ERC721: owner query for nonexistent token");
715         return owner;
716     }
717 
718     /**
719      * @dev See {IERC721Metadata-name}.
720      */
721     function name() public view virtual override returns (string memory) {
722         return _name;
723     }
724 
725     /**
726      * @dev See {IERC721Metadata-symbol}.
727      */
728     function symbol() public view virtual override returns (string memory) {
729         return _symbol;
730     }
731 
732     /**
733      * @dev See {IERC721Metadata-tokenURI}.
734      */
735     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
736         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
737 
738         string memory baseURI = _baseURI();
739         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
740     }
741 
742     /**
743      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
744      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
745      * by default, can be overriden in child contracts.
746      */
747     function _baseURI() internal view virtual returns (string memory) {
748         return "";
749     }
750 
751     /**
752      * @dev See {IERC721-approve}.
753      */
754     function approve(address to, uint256 tokenId) public virtual override {
755         address owner = ERC721.ownerOf(tokenId);
756         require(to != owner, "ERC721: approval to current owner");
757 
758         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()), "ERC721: approve caller is not owner nor approved for all");
759 
760         _approve(to, tokenId);
761     }
762 
763     /**
764      * @dev See {IERC721-getApproved}.
765      */
766     function getApproved(uint256 tokenId) public view virtual override returns (address) {
767         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
768 
769         return _tokenApprovals[tokenId];
770     }
771 
772     /**
773      * @dev See {IERC721-setApprovalForAll}.
774      */
775     function setApprovalForAll(address operator, bool approved) public virtual override {
776         require(operator != _msgSender(), "ERC721: approve to caller");
777 
778         _operatorApprovals[_msgSender()][operator] = approved;
779         emit ApprovalForAll(_msgSender(), operator, approved);
780     }
781 
782     /**
783      * @dev See {IERC721-isApprovedForAll}.
784      */
785     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
786         return _operatorApprovals[owner][operator];
787     }
788 
789     /**
790      * @dev See {IERC721-transferFrom}.
791      */
792     function transferFrom(
793         address from,
794         address to,
795         uint256 tokenId
796     ) public virtual override {
797         //solhint-disable-next-line max-line-length
798         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
799 
800         _transfer(from, to, tokenId);
801     }
802 
803     /**
804      * @dev See {IERC721-safeTransferFrom}.
805      */
806     function safeTransferFrom(
807         address from,
808         address to,
809         uint256 tokenId
810     ) public virtual override {
811         safeTransferFrom(from, to, tokenId, "");
812     }
813 
814     /**
815      * @dev See {IERC721-safeTransferFrom}.
816      */
817     function safeTransferFrom(
818         address from,
819         address to,
820         uint256 tokenId,
821         bytes memory _data
822     ) public virtual override {
823         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
824         _safeTransfer(from, to, tokenId, _data);
825     }
826 
827     /**
828      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
829      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
830      *
831      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
832      *
833      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
834      * implement alternative mechanisms to perform token transfer, such as signature-based.
835      *
836      * Requirements:
837      *
838      * - `from` cannot be the zero address.
839      * - `to` cannot be the zero address.
840      * - `tokenId` token must exist and be owned by `from`.
841      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
842      *
843      * Emits a {Transfer} event.
844      */
845     function _safeTransfer(
846         address from,
847         address to,
848         uint256 tokenId,
849         bytes memory _data
850     ) internal virtual {
851         _transfer(from, to, tokenId);
852         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
853     }
854 
855     /**
856      * @dev Returns whether `tokenId` exists.
857      *
858      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
859      *
860      * Tokens start existing when they are minted (`_mint`),
861      * and stop existing when they are burned (`_burn`).
862      */
863     function _exists(uint256 tokenId) internal view virtual returns (bool) {
864         return _owners[tokenId] != address(0);
865     }
866 
867     /**
868      * @dev Returns whether `spender` is allowed to manage `tokenId`.
869      *
870      * Requirements:
871      *
872      * - `tokenId` must exist.
873      */
874     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
875         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
876         address owner = ERC721.ownerOf(tokenId);
877         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
878     }
879 
880     /**
881      * @dev Safely mints `tokenId` and transfers it to `to`.
882      *
883      * Requirements:
884      *
885      * - `tokenId` must not exist.
886      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
887      *
888      * Emits a {Transfer} event.
889      */
890     function _safeMint(address to, uint256 tokenId) internal virtual {
891         _safeMint(to, tokenId, "");
892     }
893 
894     /**
895      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
896      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
897      */
898     function _safeMint(
899         address to,
900         uint256 tokenId,
901         bytes memory _data
902     ) internal virtual {
903         _mint(to, tokenId);
904         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
905     }
906 
907     /**
908      * @dev Mints `tokenId` and transfers it to `to`.
909      *
910      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
911      *
912      * Requirements:
913      *
914      * - `tokenId` must not exist.
915      * - `to` cannot be the zero address.
916      *
917      * Emits a {Transfer} event.
918      */
919     function _mint(address to, uint256 tokenId) internal virtual {
920         require(to != address(0), "ERC721: mint to the zero address");
921         require(!_exists(tokenId), "ERC721: token already minted");
922 
923         _beforeTokenTransfer(address(0), to, tokenId);
924 
925         _balances[to] += 1;
926         _owners[tokenId] = to;
927 
928         emit Transfer(address(0), to, tokenId);
929     }
930 
931     /**
932      * @dev Destroys `tokenId`.
933      * The approval is cleared when the token is burned.
934      *
935      * Requirements:
936      *
937      * - `tokenId` must exist.
938      *
939      * Emits a {Transfer} event.
940      */
941     function _burn(uint256 tokenId) internal virtual {
942         address owner = ERC721.ownerOf(tokenId);
943 
944         _beforeTokenTransfer(owner, address(0), tokenId);
945 
946         // Clear approvals
947         _approve(address(0), tokenId);
948 
949         _balances[owner] -= 1;
950         delete _owners[tokenId];
951 
952         emit Transfer(owner, address(0), tokenId);
953     }
954 
955     /**
956      * @dev Transfers `tokenId` from `from` to `to`.
957      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
958      *
959      * Requirements:
960      *
961      * - `to` cannot be the zero address.
962      * - `tokenId` token must be owned by `from`.
963      *
964      * Emits a {Transfer} event.
965      */
966     function _transfer(
967         address from,
968         address to,
969         uint256 tokenId
970     ) internal virtual {
971         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
972         require(to != address(0), "ERC721: transfer to the zero address");
973 
974         _beforeTokenTransfer(from, to, tokenId);
975 
976         // Clear approvals from the previous owner
977         _approve(address(0), tokenId);
978 
979         _balances[from] -= 1;
980         _balances[to] += 1;
981         _owners[tokenId] = to;
982 
983         emit Transfer(from, to, tokenId);
984     }
985 
986     /**
987      * @dev Approve `to` to operate on `tokenId`
988      *
989      * Emits a {Approval} event.
990      */
991     function _approve(address to, uint256 tokenId) internal virtual {
992         _tokenApprovals[tokenId] = to;
993         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
994     }
995 
996     /**
997      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
998      * The call is not executed if the target address is not a contract.
999      *
1000      * @param from address representing the previous owner of the given token ID
1001      * @param to target address that will receive the tokens
1002      * @param tokenId uint256 ID of the token to be transferred
1003      * @param _data bytes optional data to send along with the call
1004      * @return bool whether the call correctly returned the expected magic value
1005      */
1006     function _checkOnERC721Received(
1007         address from,
1008         address to,
1009         uint256 tokenId,
1010         bytes memory _data
1011     ) private returns (bool) {
1012         if (to.isContract()) {
1013             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1014                 return retval == IERC721Receiver.onERC721Received.selector;
1015             } catch (bytes memory reason) {
1016                 if (reason.length == 0) {
1017                     revert("ERC721: transfer to non ERC721Receiver implementer");
1018                 } else {
1019                     assembly {
1020                         revert(add(32, reason), mload(reason))
1021                     }
1022                 }
1023             }
1024         } else {
1025             return true;
1026         }
1027     }
1028 
1029     /**
1030      * @dev Hook that is called before any token transfer. This includes minting
1031      * and burning.
1032      *
1033      * Calling conditions:
1034      *
1035      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1036      * transferred to `to`.
1037      * - When `from` is zero, `tokenId` will be minted for `to`.
1038      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1039      * - `from` and `to` are never both zero.
1040      *
1041      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1042      */
1043     function _beforeTokenTransfer(
1044         address from,
1045         address to,
1046         uint256 tokenId
1047     ) internal virtual {}
1048 }
1049 
1050 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1051 
1052 pragma solidity ^0.8.0;
1053 
1054 /**
1055  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1056  * enumerability of all the token ids in the contract as well as all token ids owned by each
1057  * account.
1058  */
1059 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1060     // Mapping from owner to list of owned token IDs
1061     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1062 
1063     // Mapping from token ID to index of the owner tokens list
1064     mapping(uint256 => uint256) private _ownedTokensIndex;
1065 
1066     // Array with all token ids, used for enumeration
1067     uint256[] private _allTokens;
1068 
1069     // Mapping from token id to position in the allTokens array
1070     mapping(uint256 => uint256) private _allTokensIndex;
1071 
1072     /**
1073      * @dev See {IERC165-supportsInterface}.
1074      */
1075     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1076         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1077     }
1078 
1079     /**
1080      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1081      */
1082     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1083         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1084         return _ownedTokens[owner][index];
1085     }
1086 
1087     /**
1088      * @dev See {IERC721Enumerable-totalSupply}.
1089      */
1090     function totalSupply() public view virtual override returns (uint256) {
1091         return _allTokens.length;
1092     }
1093 
1094     /**
1095      * @dev See {IERC721Enumerable-tokenByIndex}.
1096      */
1097     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1098         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1099         return _allTokens[index];
1100     }
1101 
1102     /**
1103      * @dev Hook that is called before any token transfer. This includes minting
1104      * and burning.
1105      *
1106      * Calling conditions:
1107      *
1108      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1109      * transferred to `to`.
1110      * - When `from` is zero, `tokenId` will be minted for `to`.
1111      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1112      * - `from` cannot be the zero address.
1113      * - `to` cannot be the zero address.
1114      *
1115      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1116      */
1117     function _beforeTokenTransfer(
1118         address from,
1119         address to,
1120         uint256 tokenId
1121     ) internal virtual override {
1122         super._beforeTokenTransfer(from, to, tokenId);
1123 
1124         if (from == address(0)) {
1125             _addTokenToAllTokensEnumeration(tokenId);
1126         } else if (from != to) {
1127             _removeTokenFromOwnerEnumeration(from, tokenId);
1128         }
1129         if (to == address(0)) {
1130             _removeTokenFromAllTokensEnumeration(tokenId);
1131         } else if (to != from) {
1132             _addTokenToOwnerEnumeration(to, tokenId);
1133         }
1134     }
1135 
1136     /**
1137      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1138      * @param to address representing the new owner of the given token ID
1139      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1140      */
1141     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1142         uint256 length = ERC721.balanceOf(to);
1143         _ownedTokens[to][length] = tokenId;
1144         _ownedTokensIndex[tokenId] = length;
1145     }
1146 
1147     /**
1148      * @dev Private function to add a token to this extension's token tracking data structures.
1149      * @param tokenId uint256 ID of the token to be added to the tokens list
1150      */
1151     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1152         _allTokensIndex[tokenId] = _allTokens.length;
1153         _allTokens.push(tokenId);
1154     }
1155 
1156     /**
1157      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1158      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1159      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1160      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1161      * @param from address representing the previous owner of the given token ID
1162      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1163      */
1164     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1165         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1166         // then delete the last slot (swap and pop).
1167 
1168         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1169         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1170 
1171         // When the token to delete is the last token, the swap operation is unnecessary
1172         if (tokenIndex != lastTokenIndex) {
1173             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1174 
1175             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1176             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1177         }
1178 
1179         // This also deletes the contents at the last position of the array
1180         delete _ownedTokensIndex[tokenId];
1181         delete _ownedTokens[from][lastTokenIndex];
1182     }
1183 
1184     /**
1185      * @dev Private function to remove a token from this extension's token tracking data structures.
1186      * This has O(1) time complexity, but alters the order of the _allTokens array.
1187      * @param tokenId uint256 ID of the token to be removed from the tokens list
1188      */
1189     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1190         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1191         // then delete the last slot (swap and pop).
1192 
1193         uint256 lastTokenIndex = _allTokens.length - 1;
1194         uint256 tokenIndex = _allTokensIndex[tokenId];
1195 
1196         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1197         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1198         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1199         uint256 lastTokenId = _allTokens[lastTokenIndex];
1200 
1201         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1202         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1203 
1204         // This also deletes the contents at the last position of the array
1205         delete _allTokensIndex[tokenId];
1206         _allTokens.pop();
1207     }
1208 }
1209 
1210 // File: contracts/JailTurtles.sol
1211 pragma solidity ^0.8.9;
1212 
1213 contract JailTurtles is ERC721, ERC721Enumerable, Ownable {
1214     uint256 public constant MAX_PER_TXN = 20;
1215 
1216     string private URI = "https://gateway.pinata.cloud/ipfs/QmUoFRDKdh7NxQ96hejoRhuiBeWLsnytFEy7BEkLH7HuGy/";
1217     
1218     // DAO Turtles contract
1219     IERC721Enumerable IBaseContract = IERC721Enumerable(0xc92d06C74A26AeAf4d1A1273FAC171f3B09FAC79);
1220     
1221     mapping (uint256 => bool) public claimedTurtles;
1222 
1223     constructor() ERC721("Jail Turtles", "#FreeTheTurtles") {}
1224 
1225     function _baseURI() internal view override returns (string memory) {
1226         return URI;
1227     }
1228 
1229     function setURI(string memory _URI) external onlyOwner {
1230         URI = _URI;
1231     }
1232     
1233     function freeMint(uint256 tokenId) public {
1234         require(!claimedTurtles[tokenId], "Jail Turtle already claimed");
1235         require(IBaseContract.ownerOf(tokenId) == msg.sender, "DAO Turtle not owned");
1236         _safeMint(msg.sender, tokenId);
1237         claimedTurtles[tokenId] = true;
1238     }
1239     
1240     function freeMintMultiple(uint256 amount, uint256[] calldata tokenIds) external {
1241         require(amount <= MAX_PER_TXN, "20 max. per. txn");
1242         for (uint256 i=0; i<amount; i++) {
1243             freeMint(tokenIds[i]);
1244         }
1245     }
1246 
1247 
1248     function _beforeTokenTransfer(
1249         address from,
1250         address to,
1251         uint256 tokenId
1252     ) internal override(ERC721, ERC721Enumerable) {
1253         super._beforeTokenTransfer(from, to, tokenId);
1254     }
1255 
1256     function supportsInterface(bytes4 interfaceId)
1257         public
1258         view
1259         override(ERC721, ERC721Enumerable)
1260         returns (bool)
1261     {
1262         return super.supportsInterface(interfaceId);
1263     }
1264 }