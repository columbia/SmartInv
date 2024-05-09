1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 
25 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
26 
27 pragma solidity ^0.8.0;
28 
29 /**
30  * @dev Contract module which provides a basic access control mechanism, where
31  * there is an account (an owner) that can be granted exclusive access to
32  * specific functions.
33  *
34  * By default, the owner account will be the one that deploys the contract. This
35  * can later be changed with {transferOwnership}.
36  *
37  * This module is used through inheritance. It will make available the modifier
38  * `onlyOwner`, which can be applied to your functions to restrict their use to
39  * the owner.
40  */
41 abstract contract Ownable is Context {
42     address private _owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev Initializes the contract setting the deployer as the initial owner.
48      */
49     constructor() {
50         _setOwner(_msgSender());
51     }
52 
53     /**
54      * @dev Returns the address of the current owner.
55      */
56     function owner() public view virtual returns (address) {
57         return _owner;
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         require(owner() == _msgSender(), "Ownable: caller is not the owner");
65         _;
66     }
67 
68     /**
69      * @dev Leaves the contract without owner. It will not be possible to call
70      * `onlyOwner` functions anymore. Can only be called by the current owner.
71      *
72      * NOTE: Renouncing ownership will leave the contract without an owner,
73      * thereby removing any functionality that is only available to the owner.
74      */
75     function renounceOwnership() public virtual onlyOwner {
76         _setOwner(address(0));
77     }
78 
79     /**
80      * @dev Transfers ownership of the contract to a new account (`newOwner`).
81      * Can only be called by the current owner.
82      */
83     function transferOwnership(address newOwner) public virtual onlyOwner {
84         require(newOwner != address(0), "Ownable: new owner is the zero address");
85         _setOwner(newOwner);
86     }
87 
88     function _setOwner(address newOwner) private {
89         address oldOwner = _owner;
90         _owner = newOwner;
91         emit OwnershipTransferred(oldOwner, newOwner);
92     }
93 }
94 
95 
96 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.2
97 
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
122 
123 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.2
124 
125 
126 
127 pragma solidity ^0.8.0;
128 
129 /**
130  * @dev Required interface of an ERC721 compliant contract.
131  */
132 interface IERC721 is IERC165 {
133     /**
134      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
135      */
136     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
137 
138     /**
139      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
140      */
141     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
142 
143     /**
144      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
145      */
146     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
147 
148     /**
149      * @dev Returns the number of tokens in ``owner``'s account.
150      */
151     function balanceOf(address owner) external view returns (uint256 balance);
152 
153     /**
154      * @dev Returns the owner of the `tokenId` token.
155      *
156      * Requirements:
157      *
158      * - `tokenId` must exist.
159      */
160     function ownerOf(uint256 tokenId) external view returns (address owner);
161 
162     /**
163      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
164      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
165      *
166      * Requirements:
167      *
168      * - `from` cannot be the zero address.
169      * - `to` cannot be the zero address.
170      * - `tokenId` token must exist and be owned by `from`.
171      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
172      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
173      *
174      * Emits a {Transfer} event.
175      */
176     function safeTransferFrom(
177         address from,
178         address to,
179         uint256 tokenId
180     ) external;
181 
182     /**
183      * @dev Transfers `tokenId` token from `from` to `to`.
184      *
185      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
186      *
187      * Requirements:
188      *
189      * - `from` cannot be the zero address.
190      * - `to` cannot be the zero address.
191      * - `tokenId` token must be owned by `from`.
192      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
193      *
194      * Emits a {Transfer} event.
195      */
196     function transferFrom(
197         address from,
198         address to,
199         uint256 tokenId
200     ) external;
201 
202     /**
203      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
204      * The approval is cleared when the token is transferred.
205      *
206      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
207      *
208      * Requirements:
209      *
210      * - The caller must own the token or be an approved operator.
211      * - `tokenId` must exist.
212      *
213      * Emits an {Approval} event.
214      */
215     function approve(address to, uint256 tokenId) external;
216 
217     /**
218      * @dev Returns the account approved for `tokenId` token.
219      *
220      * Requirements:
221      *
222      * - `tokenId` must exist.
223      */
224     function getApproved(uint256 tokenId) external view returns (address operator);
225 
226     /**
227      * @dev Approve or remove `operator` as an operator for the caller.
228      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
229      *
230      * Requirements:
231      *
232      * - The `operator` cannot be the caller.
233      *
234      * Emits an {ApprovalForAll} event.
235      */
236     function setApprovalForAll(address operator, bool _approved) external;
237 
238     /**
239      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
240      *
241      * See {setApprovalForAll}
242      */
243     function isApprovedForAll(address owner, address operator) external view returns (bool);
244 
245     /**
246      * @dev Safely transfers `tokenId` token from `from` to `to`.
247      *
248      * Requirements:
249      *
250      * - `from` cannot be the zero address.
251      * - `to` cannot be the zero address.
252      * - `tokenId` token must exist and be owned by `from`.
253      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
254      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
255      *
256      * Emits a {Transfer} event.
257      */
258     function safeTransferFrom(
259         address from,
260         address to,
261         uint256 tokenId,
262         bytes calldata data
263     ) external;
264 }
265 
266 
267 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.2
268 
269 
270 pragma solidity ^0.8.0;
271 
272 /**
273  * @title ERC721 token receiver interface
274  * @dev Interface for any contract that wants to support safeTransfers
275  * from ERC721 asset contracts.
276  */
277 interface IERC721Receiver {
278     /**
279      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
280      * by `operator` from `from`, this function is called.
281      *
282      * It must return its Solidity selector to confirm the token transfer.
283      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
284      *
285      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
286      */
287     function onERC721Received(
288         address operator,
289         address from,
290         uint256 tokenId,
291         bytes calldata data
292     ) external returns (bytes4);
293 }
294 
295 
296 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.2
297 
298 
299 
300 pragma solidity ^0.8.0;
301 
302 /**
303  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
304  * @dev See https://eips.ethereum.org/EIPS/eip-721
305  */
306 interface IERC721Metadata is IERC721 {
307     /**
308      * @dev Returns the token collection name.
309      */
310     function name() external view returns (string memory);
311 
312     /**
313      * @dev Returns the token collection symbol.
314      */
315     function symbol() external view returns (string memory);
316 
317     /**
318      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
319      */
320     function tokenURI(uint256 tokenId) external view returns (string memory);
321 }
322 
323 
324 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
325 
326 
327 
328 pragma solidity ^0.8.0;
329 
330 /**
331  * @dev Collection of functions related to the address type
332  */
333 library Address {
334     /**
335      * @dev Returns true if `account` is a contract.
336      *
337      * [IMPORTANT]
338      * ====
339      * It is unsafe to assume that an address for which this function returns
340      * false is an externally-owned account (EOA) and not a contract.
341      *
342      * Among others, `isContract` will return false for the following
343      * types of addresses:
344      *
345      *  - an externally-owned account
346      *  - a contract in construction
347      *  - an address where a contract will be created
348      *  - an address where a contract lived, but was destroyed
349      * ====
350      */
351     function isContract(address account) internal view returns (bool) {
352         // This method relies on extcodesize, which returns 0 for contracts in
353         // construction, since the code is only stored at the end of the
354         // constructor execution.
355 
356         uint256 size;
357         assembly {
358             size := extcodesize(account)
359         }
360         return size > 0;
361     }
362 
363     /**
364      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
365      * `recipient`, forwarding all available gas and reverting on errors.
366      *
367      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
368      * of certain opcodes, possibly making contracts go over the 2300 gas limit
369      * imposed by `transfer`, making them unable to receive funds via
370      * `transfer`. {sendValue} removes this limitation.
371      *
372      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
373      *
374      * IMPORTANT: because control is transferred to `recipient`, care must be
375      * taken to not create reentrancy vulnerabilities. Consider using
376      * {ReentrancyGuard} or the
377      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
378      */
379     function sendValue(address payable recipient, uint256 amount) internal {
380         require(address(this).balance >= amount, "Address: insufficient balance");
381 
382         (bool success, ) = recipient.call{value: amount}("");
383         require(success, "Address: unable to send value, recipient may have reverted");
384     }
385 
386     /**
387      * @dev Performs a Solidity function call using a low level `call`. A
388      * plain `call` is an unsafe replacement for a function call: use this
389      * function instead.
390      *
391      * If `target` reverts with a revert reason, it is bubbled up by this
392      * function (like regular Solidity function calls).
393      *
394      * Returns the raw returned data. To convert to the expected return value,
395      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
396      *
397      * Requirements:
398      *
399      * - `target` must be a contract.
400      * - calling `target` with `data` must not revert.
401      *
402      * _Available since v3.1._
403      */
404     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
405         return functionCall(target, data, "Address: low-level call failed");
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
410      * `errorMessage` as a fallback revert reason when `target` reverts.
411      *
412      * _Available since v3.1._
413      */
414     function functionCall(
415         address target,
416         bytes memory data,
417         string memory errorMessage
418     ) internal returns (bytes memory) {
419         return functionCallWithValue(target, data, 0, errorMessage);
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
424      * but also transferring `value` wei to `target`.
425      *
426      * Requirements:
427      *
428      * - the calling contract must have an ETH balance of at least `value`.
429      * - the called Solidity function must be `payable`.
430      *
431      * _Available since v3.1._
432      */
433     function functionCallWithValue(
434         address target,
435         bytes memory data,
436         uint256 value
437     ) internal returns (bytes memory) {
438         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
443      * with `errorMessage` as a fallback revert reason when `target` reverts.
444      *
445      * _Available since v3.1._
446      */
447     function functionCallWithValue(
448         address target,
449         bytes memory data,
450         uint256 value,
451         string memory errorMessage
452     ) internal returns (bytes memory) {
453         require(address(this).balance >= value, "Address: insufficient balance for call");
454         require(isContract(target), "Address: call to non-contract");
455 
456         (bool success, bytes memory returndata) = target.call{value: value}(data);
457         return verifyCallResult(success, returndata, errorMessage);
458     }
459 
460     /**
461      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
462      * but performing a static call.
463      *
464      * _Available since v3.3._
465      */
466     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
467         return functionStaticCall(target, data, "Address: low-level static call failed");
468     }
469 
470     /**
471      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
472      * but performing a static call.
473      *
474      * _Available since v3.3._
475      */
476     function functionStaticCall(
477         address target,
478         bytes memory data,
479         string memory errorMessage
480     ) internal view returns (bytes memory) {
481         require(isContract(target), "Address: static call to non-contract");
482 
483         (bool success, bytes memory returndata) = target.staticcall(data);
484         return verifyCallResult(success, returndata, errorMessage);
485     }
486 
487     /**
488      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
489      * but performing a delegate call.
490      *
491      * _Available since v3.4._
492      */
493     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
494         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
495     }
496 
497     /**
498      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
499      * but performing a delegate call.
500      *
501      * _Available since v3.4._
502      */
503     function functionDelegateCall(
504         address target,
505         bytes memory data,
506         string memory errorMessage
507     ) internal returns (bytes memory) {
508         require(isContract(target), "Address: delegate call to non-contract");
509 
510         (bool success, bytes memory returndata) = target.delegatecall(data);
511         return verifyCallResult(success, returndata, errorMessage);
512     }
513 
514     /**
515      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
516      * revert reason using the provided one.
517      *
518      * _Available since v4.3._
519      */
520     function verifyCallResult(
521         bool success,
522         bytes memory returndata,
523         string memory errorMessage
524     ) internal pure returns (bytes memory) {
525         if (success) {
526             return returndata;
527         } else {
528             // Look for revert reason and bubble it up if present
529             if (returndata.length > 0) {
530                 // The easiest way to bubble the revert reason is using memory via assembly
531 
532                 assembly {
533                     let returndata_size := mload(returndata)
534                     revert(add(32, returndata), returndata_size)
535                 }
536             } else {
537                 revert(errorMessage);
538             }
539         }
540     }
541 }
542 
543 
544 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.2
545 
546 
547 
548 pragma solidity ^0.8.0;
549 
550 /**
551  * @dev String operations.
552  */
553 library Strings {
554     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
555 
556     /**
557      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
558      */
559     function toString(uint256 value) internal pure returns (string memory) {
560         // Inspired by OraclizeAPI's implementation - MIT licence
561         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
562 
563         if (value == 0) {
564             return "0";
565         }
566         uint256 temp = value;
567         uint256 digits;
568         while (temp != 0) {
569             digits++;
570             temp /= 10;
571         }
572         bytes memory buffer = new bytes(digits);
573         while (value != 0) {
574             digits -= 1;
575             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
576             value /= 10;
577         }
578         return string(buffer);
579     }
580 
581     /**
582      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
583      */
584     function toHexString(uint256 value) internal pure returns (string memory) {
585         if (value == 0) {
586             return "0x00";
587         }
588         uint256 temp = value;
589         uint256 length = 0;
590         while (temp != 0) {
591             length++;
592             temp >>= 8;
593         }
594         return toHexString(value, length);
595     }
596 
597     /**
598      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
599      */
600     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
601         bytes memory buffer = new bytes(2 * length + 2);
602         buffer[0] = "0";
603         buffer[1] = "x";
604         for (uint256 i = 2 * length + 1; i > 1; --i) {
605             buffer[i] = _HEX_SYMBOLS[value & 0xf];
606             value >>= 4;
607         }
608         require(value == 0, "Strings: hex length insufficient");
609         return string(buffer);
610     }
611 }
612 
613 
614 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
615 
616 
617 
618 pragma solidity ^0.8.0;
619 
620 /**
621  * @dev Implementation of the {IERC165} interface.
622  *
623  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
624  * for the additional interface id that will be supported. For example:
625  *
626  * ```solidity
627  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
628  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
629  * }
630  * ```
631  *
632  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
633  */
634 abstract contract ERC165 is IERC165 {
635     /**
636      * @dev See {IERC165-supportsInterface}.
637      */
638     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
639         return interfaceId == type(IERC165).interfaceId;
640     }
641 }
642 
643 
644 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.2
645 
646 
647 
648 pragma solidity ^0.8.0;
649 
650 
651 
652 
653 
654 
655 
656 /**
657  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
658  * the Metadata extension, but not including the Enumerable extension, which is available separately as
659  * {ERC721Enumerable}.
660  */
661 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
662     using Address for address;
663     using Strings for uint256;
664 
665     // Token name
666     string private _name;
667 
668     // Token symbol
669     string private _symbol;
670 
671     // Mapping from token ID to owner address
672     mapping(uint256 => address) private _owners;
673 
674     // Mapping owner address to token count
675     mapping(address => uint256) private _balances;
676 
677     // Mapping from token ID to approved address
678     mapping(uint256 => address) private _tokenApprovals;
679 
680     // Mapping from owner to operator approvals
681     mapping(address => mapping(address => bool)) private _operatorApprovals;
682 
683     /**
684      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
685      */
686     constructor(string memory name_, string memory symbol_) {
687         _name = name_;
688         _symbol = symbol_;
689     }
690 
691     /**
692      * @dev See {IERC165-supportsInterface}.
693      */
694     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
695         return
696             interfaceId == type(IERC721).interfaceId ||
697             interfaceId == type(IERC721Metadata).interfaceId ||
698             super.supportsInterface(interfaceId);
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
758         require(
759             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
760             "ERC721: approve caller is not owner nor approved for all"
761         );
762 
763         _approve(to, tokenId);
764     }
765 
766     /**
767      * @dev See {IERC721-getApproved}.
768      */
769     function getApproved(uint256 tokenId) public view virtual override returns (address) {
770         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
771 
772         return _tokenApprovals[tokenId];
773     }
774 
775     /**
776      * @dev See {IERC721-setApprovalForAll}.
777      */
778     function setApprovalForAll(address operator, bool approved) public virtual override {
779         require(operator != _msgSender(), "ERC721: approve to caller");
780 
781         _operatorApprovals[_msgSender()][operator] = approved;
782         emit ApprovalForAll(_msgSender(), operator, approved);
783     }
784 
785     /**
786      * @dev See {IERC721-isApprovedForAll}.
787      */
788     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
789         return _operatorApprovals[owner][operator];
790     }
791 
792     /**
793      * @dev See {IERC721-transferFrom}.
794      */
795     function transferFrom(
796         address from,
797         address to,
798         uint256 tokenId
799     ) public virtual override {
800         //solhint-disable-next-line max-line-length
801         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
802 
803         _transfer(from, to, tokenId);
804     }
805 
806     /**
807      * @dev See {IERC721-safeTransferFrom}.
808      */
809     function safeTransferFrom(
810         address from,
811         address to,
812         uint256 tokenId
813     ) public virtual override {
814         safeTransferFrom(from, to, tokenId, "");
815     }
816 
817     /**
818      * @dev See {IERC721-safeTransferFrom}.
819      */
820     function safeTransferFrom(
821         address from,
822         address to,
823         uint256 tokenId,
824         bytes memory _data
825     ) public virtual override {
826         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
827         _safeTransfer(from, to, tokenId, _data);
828     }
829 
830     /**
831      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
832      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
833      *
834      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
835      *
836      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
837      * implement alternative mechanisms to perform token transfer, such as signature-based.
838      *
839      * Requirements:
840      *
841      * - `from` cannot be the zero address.
842      * - `to` cannot be the zero address.
843      * - `tokenId` token must exist and be owned by `from`.
844      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
845      *
846      * Emits a {Transfer} event.
847      */
848     function _safeTransfer(
849         address from,
850         address to,
851         uint256 tokenId,
852         bytes memory _data
853     ) internal virtual {
854         _transfer(from, to, tokenId);
855         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
856     }
857 
858     /**
859      * @dev Returns whether `tokenId` exists.
860      *
861      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
862      *
863      * Tokens start existing when they are minted (`_mint`),
864      * and stop existing when they are burned (`_burn`).
865      */
866     function _exists(uint256 tokenId) internal view virtual returns (bool) {
867         return _owners[tokenId] != address(0);
868     }
869 
870     /**
871      * @dev Returns whether `spender` is allowed to manage `tokenId`.
872      *
873      * Requirements:
874      *
875      * - `tokenId` must exist.
876      */
877     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
878         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
879         address owner = ERC721.ownerOf(tokenId);
880         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
881     }
882 
883     /**
884      * @dev Safely mints `tokenId` and transfers it to `to`.
885      *
886      * Requirements:
887      *
888      * - `tokenId` must not exist.
889      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
890      *
891      * Emits a {Transfer} event.
892      */
893     function _safeMint(address to, uint256 tokenId) internal virtual {
894         _safeMint(to, tokenId, "");
895     }
896 
897     /**
898      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
899      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
900      */
901     function _safeMint(
902         address to,
903         uint256 tokenId,
904         bytes memory _data
905     ) internal virtual {
906         _mint(to, tokenId);
907         require(
908             _checkOnERC721Received(address(0), to, tokenId, _data),
909             "ERC721: transfer to non ERC721Receiver implementer"
910         );
911     }
912 
913     /**
914      * @dev Mints `tokenId` and transfers it to `to`.
915      *
916      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
917      *
918      * Requirements:
919      *
920      * - `tokenId` must not exist.
921      * - `to` cannot be the zero address.
922      *
923      * Emits a {Transfer} event.
924      */
925     function _mint(address to, uint256 tokenId) internal virtual {
926         require(to != address(0), "ERC721: mint to the zero address");
927         require(!_exists(tokenId), "ERC721: token already minted");
928 
929         _beforeTokenTransfer(address(0), to, tokenId);
930 
931         _balances[to] += 1;
932         _owners[tokenId] = to;
933 
934         emit Transfer(address(0), to, tokenId);
935     }
936 
937     /**
938      * @dev Destroys `tokenId`.
939      * The approval is cleared when the token is burned.
940      *
941      * Requirements:
942      *
943      * - `tokenId` must exist.
944      *
945      * Emits a {Transfer} event.
946      */
947     function _burn(uint256 tokenId) internal virtual {
948         address owner = ERC721.ownerOf(tokenId);
949 
950         _beforeTokenTransfer(owner, address(0), tokenId);
951 
952         // Clear approvals
953         _approve(address(0), tokenId);
954 
955         _balances[owner] -= 1;
956         delete _owners[tokenId];
957 
958         emit Transfer(owner, address(0), tokenId);
959     }
960 
961     /**
962      * @dev Transfers `tokenId` from `from` to `to`.
963      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
964      *
965      * Requirements:
966      *
967      * - `to` cannot be the zero address.
968      * - `tokenId` token must be owned by `from`.
969      *
970      * Emits a {Transfer} event.
971      */
972     function _transfer(
973         address from,
974         address to,
975         uint256 tokenId
976     ) internal virtual {
977         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
978         require(to != address(0), "ERC721: transfer to the zero address");
979 
980         _beforeTokenTransfer(from, to, tokenId);
981 
982         // Clear approvals from the previous owner
983         _approve(address(0), tokenId);
984 
985         _balances[from] -= 1;
986         _balances[to] += 1;
987         _owners[tokenId] = to;
988 
989         emit Transfer(from, to, tokenId);
990     }
991 
992     /**
993      * @dev Approve `to` to operate on `tokenId`
994      *
995      * Emits a {Approval} event.
996      */
997     function _approve(address to, uint256 tokenId) internal virtual {
998         _tokenApprovals[tokenId] = to;
999         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1000     }
1001 
1002     /**
1003      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1004      * The call is not executed if the target address is not a contract.
1005      *
1006      * @param from address representing the previous owner of the given token ID
1007      * @param to target address that will receive the tokens
1008      * @param tokenId uint256 ID of the token to be transferred
1009      * @param _data bytes optional data to send along with the call
1010      * @return bool whether the call correctly returned the expected magic value
1011      */
1012     function _checkOnERC721Received(
1013         address from,
1014         address to,
1015         uint256 tokenId,
1016         bytes memory _data
1017     ) private returns (bool) {
1018         if (to.isContract()) {
1019             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1020                 return retval == IERC721Receiver.onERC721Received.selector;
1021             } catch (bytes memory reason) {
1022                 if (reason.length == 0) {
1023                     revert("ERC721: transfer to non ERC721Receiver implementer");
1024                 } else {
1025                     assembly {
1026                         revert(add(32, reason), mload(reason))
1027                     }
1028                 }
1029             }
1030         } else {
1031             return true;
1032         }
1033     }
1034 
1035     /**
1036      * @dev Hook that is called before any token transfer. This includes minting
1037      * and burning.
1038      *
1039      * Calling conditions:
1040      *
1041      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1042      * transferred to `to`.
1043      * - When `from` is zero, `tokenId` will be minted for `to`.
1044      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1045      * - `from` and `to` are never both zero.
1046      *
1047      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1048      */
1049     function _beforeTokenTransfer(
1050         address from,
1051         address to,
1052         uint256 tokenId
1053     ) internal virtual {}
1054 }
1055 
1056 
1057 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.2
1058 
1059 
1060 
1061 pragma solidity ^0.8.0;
1062 
1063 /**
1064  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1065  * @dev See https://eips.ethereum.org/EIPS/eip-721
1066  */
1067 interface IERC721Enumerable is IERC721 {
1068     /**
1069      * @dev Returns the total amount of tokens stored by the contract.
1070      */
1071     function totalSupply() external view returns (uint256);
1072 
1073     /**
1074      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1075      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1076      */
1077     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1078 
1079     /**
1080      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1081      * Use along with {totalSupply} to enumerate all tokens.
1082      */
1083     function tokenByIndex(uint256 index) external view returns (uint256);
1084 }
1085 
1086 
1087 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.2
1088 
1089 
1090 
1091 pragma solidity ^0.8.0;
1092 
1093 
1094 /**
1095  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1096  * enumerability of all the token ids in the contract as well as all token ids owned by each
1097  * account.
1098  */
1099 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1100     // Mapping from owner to list of owned token IDs
1101     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1102 
1103     // Mapping from token ID to index of the owner tokens list
1104     mapping(uint256 => uint256) private _ownedTokensIndex;
1105 
1106     // Array with all token ids, used for enumeration
1107     uint256[] private _allTokens;
1108 
1109     // Mapping from token id to position in the allTokens array
1110     mapping(uint256 => uint256) private _allTokensIndex;
1111 
1112     /**
1113      * @dev See {IERC165-supportsInterface}.
1114      */
1115     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1116         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1117     }
1118 
1119     /**
1120      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1121      */
1122     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1123         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1124         return _ownedTokens[owner][index];
1125     }
1126 
1127     /**
1128      * @dev See {IERC721Enumerable-totalSupply}.
1129      */
1130     function totalSupply() public view virtual override returns (uint256) {
1131         return _allTokens.length;
1132     }
1133 
1134     /**
1135      * @dev See {IERC721Enumerable-tokenByIndex}.
1136      */
1137     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1138         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1139         return _allTokens[index];
1140     }
1141 
1142     /**
1143      * @dev Hook that is called before any token transfer. This includes minting
1144      * and burning.
1145      *
1146      * Calling conditions:
1147      *
1148      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1149      * transferred to `to`.
1150      * - When `from` is zero, `tokenId` will be minted for `to`.
1151      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1152      * - `from` cannot be the zero address.
1153      * - `to` cannot be the zero address.
1154      *
1155      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1156      */
1157     function _beforeTokenTransfer(
1158         address from,
1159         address to,
1160         uint256 tokenId
1161     ) internal virtual override {
1162         super._beforeTokenTransfer(from, to, tokenId);
1163 
1164         if (from == address(0)) {
1165             _addTokenToAllTokensEnumeration(tokenId);
1166         } else if (from != to) {
1167             _removeTokenFromOwnerEnumeration(from, tokenId);
1168         }
1169         if (to == address(0)) {
1170             _removeTokenFromAllTokensEnumeration(tokenId);
1171         } else if (to != from) {
1172             _addTokenToOwnerEnumeration(to, tokenId);
1173         }
1174     }
1175 
1176     /**
1177      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1178      * @param to address representing the new owner of the given token ID
1179      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1180      */
1181     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1182         uint256 length = ERC721.balanceOf(to);
1183         _ownedTokens[to][length] = tokenId;
1184         _ownedTokensIndex[tokenId] = length;
1185     }
1186 
1187     /**
1188      * @dev Private function to add a token to this extension's token tracking data structures.
1189      * @param tokenId uint256 ID of the token to be added to the tokens list
1190      */
1191     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1192         _allTokensIndex[tokenId] = _allTokens.length;
1193         _allTokens.push(tokenId);
1194     }
1195 
1196     /**
1197      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1198      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1199      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1200      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1201      * @param from address representing the previous owner of the given token ID
1202      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1203      */
1204     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1205         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1206         // then delete the last slot (swap and pop).
1207 
1208         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1209         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1210 
1211         // When the token to delete is the last token, the swap operation is unnecessary
1212         if (tokenIndex != lastTokenIndex) {
1213             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1214 
1215             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1216             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1217         }
1218 
1219         // This also deletes the contents at the last position of the array
1220         delete _ownedTokensIndex[tokenId];
1221         delete _ownedTokens[from][lastTokenIndex];
1222     }
1223 
1224     /**
1225      * @dev Private function to remove a token from this extension's token tracking data structures.
1226      * This has O(1) time complexity, but alters the order of the _allTokens array.
1227      * @param tokenId uint256 ID of the token to be removed from the tokens list
1228      */
1229     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1230         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1231         // then delete the last slot (swap and pop).
1232 
1233         uint256 lastTokenIndex = _allTokens.length - 1;
1234         uint256 tokenIndex = _allTokensIndex[tokenId];
1235 
1236         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1237         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1238         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1239         uint256 lastTokenId = _allTokens[lastTokenIndex];
1240 
1241         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1242         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1243 
1244         // This also deletes the contents at the last position of the array
1245         delete _allTokensIndex[tokenId];
1246         _allTokens.pop();
1247     }
1248 }
1249 
1250 
1251 
1252 
1253 
1254 pragma solidity ^0.8.0;
1255 
1256 contract PixelVerse is ERC721Enumerable, Ownable {
1257     using Strings for uint256;
1258     event Mint(address indexed sender, uint256 startWith, uint256 times);
1259 
1260     //supply counters
1261     uint256 public totalMints;
1262     uint256 public totalCount = 8888;
1263    
1264     //token Index tracker
1265 
1266 
1267     uint256 public maxBatch = 10;
1268     uint256 public price = 0.03 * 10 ** 18;
1269 
1270     //string
1271     string public baseURI;
1272 
1273     //bool
1274     bool private started;
1275     bool private mekas;
1276     //constructor args
1277     constructor(string memory name_, string memory symbol_, string memory baseURI_) ERC721(name_, symbol_) {
1278         baseURI = baseURI_;
1279     }
1280 
1281     //basic functions.
1282     function _baseURI() internal view virtual override returns (string memory){
1283         return baseURI;
1284     }
1285     function setBaseURI(string memory _newURI) public onlyOwner {
1286         baseURI = _newURI;
1287     }
1288 
1289     //erc721
1290     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1291         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token.");
1292 
1293         string memory baseURI2 = _baseURI();
1294         return bytes(baseURI2).length > 0
1295             ? string(abi.encodePacked(baseURI2, tokenId.toString(), ".json")) : '.json';
1296     }
1297     function setStart(bool _start) public onlyOwner {
1298         started = _start;
1299     }
1300 
1301     function tokensOfOwner(address owner)
1302         public
1303         view
1304         returns (uint256[] memory)
1305     {
1306         uint256 count = balanceOf(owner);
1307         uint256[] memory ids = new uint256[](count);
1308         for (uint256 i = 0; i < count; i++) {
1309             ids[i] = tokenOfOwnerByIndex(owner, i);
1310         }
1311         return ids;
1312     }
1313 
1314     function mint(uint256 _times) payable public {
1315         require(started, "not started");
1316         require(_times >0 && _times <= maxBatch, "must mint fewer in each batch");
1317         require(totalMints + _times <= totalCount, "max supply reached!");
1318         require(msg.value == _times * price, "value error, please check price.");
1319         payable(owner()).transfer(msg.value);
1320         emit Mint(_msgSender(), totalMints+1, _times);
1321         for(uint256 i=0; i< _times; i++){
1322             _mint(_msgSender(), 1 + totalMints++);
1323         }
1324     }
1325 }