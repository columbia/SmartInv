1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev Contract module which provides a basic access control mechanism, where
29  * there is an account (an owner) that can be granted exclusive access to
30  * specific functions.
31  *
32  * By default, the owner account will be the one that deploys the contract. This
33  * can later be changed with {transferOwnership}.
34  *
35  * This module is used through inheritance. It will make available the modifier
36  * `onlyOwner`, which can be applied to your functions to restrict their use to
37  * the owner.
38  */
39 abstract contract Ownable is Context {
40     address private _owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     /**
45      * @dev Initializes the contract setting the deployer as the initial owner.
46      */
47     constructor() {
48         _setOwner(_msgSender());
49     }
50 
51     /**
52      * @dev Returns the address of the current owner.
53      */
54     function owner() public view virtual returns (address) {
55         return _owner;
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         require(owner() == _msgSender(), "Ownable: caller is not the owner");
63         _;
64     }
65 
66     /**
67      * @dev Leaves the contract without owner. It will not be possible to call
68      * `onlyOwner` functions anymore. Can only be called by the current owner.
69      *
70      * NOTE: Renouncing ownership will leave the contract without an owner,
71      * thereby removing any functionality that is only available to the owner.
72      */
73     function renounceOwnership() public virtual onlyOwner {
74         _setOwner(address(0));
75     }
76 
77     /**
78      * @dev Transfers ownership of the contract to a new account (`newOwner`).
79      * Can only be called by the current owner.
80      */
81     function transferOwnership(address newOwner) public virtual onlyOwner {
82         require(newOwner != address(0), "Ownable: new owner is the zero address");
83         _setOwner(newOwner);
84     }
85 
86     function _setOwner(address newOwner) private {
87         address oldOwner = _owner;
88         _owner = newOwner;
89         emit OwnershipTransferred(oldOwner, newOwner);
90     }
91 }
92 
93 pragma solidity ^0.8.0;
94 
95 /**
96  * @dev Interface of the ERC165 standard, as defined in the
97  * https://eips.ethereum.org/EIPS/eip-165[EIP].
98  *
99  * Implementers can declare support of contract interfaces, which can then be
100  * queried by others ({ERC165Checker}).
101  *
102  * For an implementation, see {ERC165}.
103  */
104 interface IERC165 {
105     /**
106      * @dev Returns true if this contract implements the interface defined by
107      * `interfaceId`. See the corresponding
108      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
109      * to learn more about how these ids are created.
110      *
111      * This function call must use less than 30 000 gas.
112      */
113     function supportsInterface(bytes4 interfaceId) external view returns (bool);
114 }
115 
116 pragma solidity ^0.8.0;
117 
118 /**
119  * @dev Required interface of an ERC721 compliant contract.
120  */
121 interface IERC721 is IERC165 {
122     /**
123      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
124      */
125     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
126 
127     /**
128      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
129      */
130     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
131 
132     /**
133      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
134      */
135     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
136 
137     /**
138      * @dev Returns the number of tokens in ``owner``'s account.
139      */
140     function balanceOf(address owner) external view returns (uint256 balance);
141 
142     /**
143      * @dev Returns the owner of the `tokenId` token.
144      *
145      * Requirements:
146      *
147      * - `tokenId` must exist.
148      */
149     function ownerOf(uint256 tokenId) external view returns (address owner);
150 
151     /**
152      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
153      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
154      *
155      * Requirements:
156      *
157      * - `from` cannot be the zero address.
158      * - `to` cannot be the zero address.
159      * - `tokenId` token must exist and be owned by `from`.
160      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
161      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
162      *
163      * Emits a {Transfer} event.
164      */
165     function safeTransferFrom(
166         address from,
167         address to,
168         uint256 tokenId
169     ) external;
170 
171     /**
172      * @dev Transfers `tokenId` token from `from` to `to`.
173      *
174      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
175      *
176      * Requirements:
177      *
178      * - `from` cannot be the zero address.
179      * - `to` cannot be the zero address.
180      * - `tokenId` token must be owned by `from`.
181      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
182      *
183      * Emits a {Transfer} event.
184      */
185     function transferFrom(
186         address from,
187         address to,
188         uint256 tokenId
189     ) external;
190 
191     /**
192      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
193      * The approval is cleared when the token is transferred.
194      *
195      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
196      *
197      * Requirements:
198      *
199      * - The caller must own the token or be an approved operator.
200      * - `tokenId` must exist.
201      *
202      * Emits an {Approval} event.
203      */
204     function approve(address to, uint256 tokenId) external;
205 
206     /**
207      * @dev Returns the account approved for `tokenId` token.
208      *
209      * Requirements:
210      *
211      * - `tokenId` must exist.
212      */
213     function getApproved(uint256 tokenId) external view returns (address operator);
214 
215     /**
216      * @dev Approve or remove `operator` as an operator for the caller.
217      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
218      *
219      * Requirements:
220      *
221      * - The `operator` cannot be the caller.
222      *
223      * Emits an {ApprovalForAll} event.
224      */
225     function setApprovalForAll(address operator, bool _approved) external;
226 
227     /**
228      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
229      *
230      * See {setApprovalForAll}
231      */
232     function isApprovedForAll(address owner, address operator) external view returns (bool);
233 
234     /**
235      * @dev Safely transfers `tokenId` token from `from` to `to`.
236      *
237      * Requirements:
238      *
239      * - `from` cannot be the zero address.
240      * - `to` cannot be the zero address.
241      * - `tokenId` token must exist and be owned by `from`.
242      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
243      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
244      *
245      * Emits a {Transfer} event.
246      */
247     function safeTransferFrom(
248         address from,
249         address to,
250         uint256 tokenId,
251         bytes calldata data
252     ) external;
253 }
254 
255 pragma solidity ^0.8.0;
256 
257 /**
258  * @title ERC721 token receiver interface
259  * @dev Interface for any contract that wants to support safeTransfers
260  * from ERC721 asset contracts.
261  */
262 interface IERC721Receiver {
263     /**
264      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
265      * by `operator` from `from`, this function is called.
266      *
267      * It must return its Solidity selector to confirm the token transfer.
268      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
269      *
270      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
271      */
272     function onERC721Received(
273         address operator,
274         address from,
275         uint256 tokenId,
276         bytes calldata data
277     ) external returns (bytes4);
278 }
279 
280 pragma solidity ^0.8.0;
281 
282 /**
283  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
284  * @dev See https://eips.ethereum.org/EIPS/eip-721
285  */
286 interface IERC721Metadata is IERC721 {
287     /**
288      * @dev Returns the token collection name.
289      */
290     function name() external view returns (string memory);
291 
292     /**
293      * @dev Returns the token collection symbol.
294      */
295     function symbol() external view returns (string memory);
296 
297     /**
298      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
299      */
300     function tokenURI(uint256 tokenId) external view returns (string memory);
301 }
302 
303 pragma solidity ^0.8.0;
304 
305 /**
306  * @dev Collection of functions related to the address type
307  */
308 library Address {
309     /**
310      * @dev Returns true if `account` is a contract.
311      *
312      * [IMPORTANT]
313      * ====
314      * It is unsafe to assume that an address for which this function returns
315      * false is an externally-owned account (EOA) and not a contract.
316      *
317      * Among others, `isContract` will return false for the following
318      * types of addresses:
319      *
320      *  - an externally-owned account
321      *  - a contract in construction
322      *  - an address where a contract will be created
323      *  - an address where a contract lived, but was destroyed
324      * ====
325      */
326     function isContract(address account) internal view returns (bool) {
327         // This method relies on extcodesize, which returns 0 for contracts in
328         // construction, since the code is only stored at the end of the
329         // constructor execution.
330 
331         uint256 size;
332         assembly {
333             size := extcodesize(account)
334         }
335         return size > 0;
336     }
337 
338     /**
339      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
340      * `recipient`, forwarding all available gas and reverting on errors.
341      *
342      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
343      * of certain opcodes, possibly making contracts go over the 2300 gas limit
344      * imposed by `transfer`, making them unable to receive funds via
345      * `transfer`. {sendValue} removes this limitation.
346      *
347      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
348      *
349      * IMPORTANT: because control is transferred to `recipient`, care must be
350      * taken to not create reentrancy vulnerabilities. Consider using
351      * {ReentrancyGuard} or the
352      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
353      */
354     function sendValue(address payable recipient, uint256 amount) internal {
355         require(address(this).balance >= amount, "Address: insufficient balance");
356 
357         (bool success, ) = recipient.call{value: amount}("");
358         require(success, "Address: unable to send value, recipient may have reverted");
359     }
360 
361     /**
362      * @dev Performs a Solidity function call using a low level `call`. A
363      * plain `call` is an unsafe replacement for a function call: use this
364      * function instead.
365      *
366      * If `target` reverts with a revert reason, it is bubbled up by this
367      * function (like regular Solidity function calls).
368      *
369      * Returns the raw returned data. To convert to the expected return value,
370      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
371      *
372      * Requirements:
373      *
374      * - `target` must be a contract.
375      * - calling `target` with `data` must not revert.
376      *
377      * _Available since v3.1._
378      */
379     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
380         return functionCall(target, data, "Address: low-level call failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
385      * `errorMessage` as a fallback revert reason when `target` reverts.
386      *
387      * _Available since v3.1._
388      */
389     function functionCall(
390         address target,
391         bytes memory data,
392         string memory errorMessage
393     ) internal returns (bytes memory) {
394         return functionCallWithValue(target, data, 0, errorMessage);
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
399      * but also transferring `value` wei to `target`.
400      *
401      * Requirements:
402      *
403      * - the calling contract must have an ETH balance of at least `value`.
404      * - the called Solidity function must be `payable`.
405      *
406      * _Available since v3.1._
407      */
408     function functionCallWithValue(
409         address target,
410         bytes memory data,
411         uint256 value
412     ) internal returns (bytes memory) {
413         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
418      * with `errorMessage` as a fallback revert reason when `target` reverts.
419      *
420      * _Available since v3.1._
421      */
422     function functionCallWithValue(
423         address target,
424         bytes memory data,
425         uint256 value,
426         string memory errorMessage
427     ) internal returns (bytes memory) {
428         require(address(this).balance >= value, "Address: insufficient balance for call");
429         require(isContract(target), "Address: call to non-contract");
430 
431         (bool success, bytes memory returndata) = target.call{value: value}(data);
432         return _verifyCallResult(success, returndata, errorMessage);
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
437      * but performing a static call.
438      *
439      * _Available since v3.3._
440      */
441     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
442         return functionStaticCall(target, data, "Address: low-level static call failed");
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
447      * but performing a static call.
448      *
449      * _Available since v3.3._
450      */
451     function functionStaticCall(
452         address target,
453         bytes memory data,
454         string memory errorMessage
455     ) internal view returns (bytes memory) {
456         require(isContract(target), "Address: static call to non-contract");
457 
458         (bool success, bytes memory returndata) = target.staticcall(data);
459         return _verifyCallResult(success, returndata, errorMessage);
460     }
461 
462     /**
463      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
464      * but performing a delegate call.
465      *
466      * _Available since v3.4._
467      */
468     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
469         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
474      * but performing a delegate call.
475      *
476      * _Available since v3.4._
477      */
478     function functionDelegateCall(
479         address target,
480         bytes memory data,
481         string memory errorMessage
482     ) internal returns (bytes memory) {
483         require(isContract(target), "Address: delegate call to non-contract");
484 
485         (bool success, bytes memory returndata) = target.delegatecall(data);
486         return _verifyCallResult(success, returndata, errorMessage);
487     }
488 
489     function _verifyCallResult(
490         bool success,
491         bytes memory returndata,
492         string memory errorMessage
493     ) private pure returns (bytes memory) {
494         if (success) {
495             return returndata;
496         } else {
497             // Look for revert reason and bubble it up if present
498             if (returndata.length > 0) {
499                 // The easiest way to bubble the revert reason is using memory via assembly
500 
501                 assembly {
502                     let returndata_size := mload(returndata)
503                     revert(add(32, returndata), returndata_size)
504                 }
505             } else {
506                 revert(errorMessage);
507             }
508         }
509     }
510 }
511 
512 pragma solidity ^0.8.0;
513 
514 /**
515  * @dev String operations.
516  */
517 library Strings {
518     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
519 
520     /**
521      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
522      */
523     function toString(uint256 value) internal pure returns (string memory) {
524         // Inspired by OraclizeAPI's implementation - MIT licence
525         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
526 
527         if (value == 0) {
528             return "0";
529         }
530         uint256 temp = value;
531         uint256 digits;
532         while (temp != 0) {
533             digits++;
534             temp /= 10;
535         }
536         bytes memory buffer = new bytes(digits);
537         while (value != 0) {
538             digits -= 1;
539             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
540             value /= 10;
541         }
542         return string(buffer);
543     }
544 
545     /**
546      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
547      */
548     function toHexString(uint256 value) internal pure returns (string memory) {
549         if (value == 0) {
550             return "0x00";
551         }
552         uint256 temp = value;
553         uint256 length = 0;
554         while (temp != 0) {
555             length++;
556             temp >>= 8;
557         }
558         return toHexString(value, length);
559     }
560 
561     /**
562      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
563      */
564     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
565         bytes memory buffer = new bytes(2 * length + 2);
566         buffer[0] = "0";
567         buffer[1] = "x";
568         for (uint256 i = 2 * length + 1; i > 1; --i) {
569             buffer[i] = _HEX_SYMBOLS[value & 0xf];
570             value >>= 4;
571         }
572         require(value == 0, "Strings: hex length insufficient");
573         return string(buffer);
574     }
575 }
576 
577 pragma solidity ^0.8.0;
578 
579 /**
580  * @dev Implementation of the {IERC165} interface.
581  *
582  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
583  * for the additional interface id that will be supported. For example:
584  *
585  * ```solidity
586  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
587  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
588  * }
589  * ```
590  *
591  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
592  */
593 abstract contract ERC165 is IERC165 {
594     /**
595      * @dev See {IERC165-supportsInterface}.
596      */
597     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
598         return interfaceId == type(IERC165).interfaceId;
599     }
600 }
601 
602 pragma solidity ^0.8.0;
603 
604 /**
605  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
606  * the Metadata extension, but not including the Enumerable extension, which is available separately as
607  * {ERC721Enumerable}.
608  */
609 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
610     using Address for address;
611     using Strings for uint256;
612 
613     // Token name
614     string private _name;
615 
616     // Token symbol
617     string private _symbol;
618 
619     // Mapping from token ID to owner address
620     mapping(uint256 => address) private _owners;
621 
622     // Mapping owner address to token count
623     mapping(address => uint256) private _balances;
624 
625     // Mapping from token ID to approved address
626     mapping(uint256 => address) private _tokenApprovals;
627 
628     // Mapping from owner to operator approvals
629     mapping(address => mapping(address => bool)) private _operatorApprovals;
630 
631     /**
632      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
633      */
634     constructor(string memory name_, string memory symbol_) {
635         _name = name_;
636         _symbol = symbol_;
637     }
638 
639     /**
640      * @dev See {IERC165-supportsInterface}.
641      */
642     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
643         return
644             interfaceId == type(IERC721).interfaceId ||
645             interfaceId == type(IERC721Metadata).interfaceId ||
646             super.supportsInterface(interfaceId);
647     }
648 
649     /**
650      * @dev See {IERC721-balanceOf}.
651      */
652     function balanceOf(address owner) public view virtual override returns (uint256) {
653         require(owner != address(0), "ERC721: balance query for the zero address");
654         return _balances[owner];
655     }
656 
657     /**
658      * @dev See {IERC721-ownerOf}.
659      */
660     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
661         address owner = _owners[tokenId];
662         require(owner != address(0), "ERC721: owner query for nonexistent token");
663         return owner;
664     }
665 
666     /**
667      * @dev See {IERC721Metadata-name}.
668      */
669     function name() public view virtual override returns (string memory) {
670         return _name;
671     }
672 
673     /**
674      * @dev See {IERC721Metadata-symbol}.
675      */
676     function symbol() public view virtual override returns (string memory) {
677         return _symbol;
678     }
679 
680     /**
681      * @dev See {IERC721Metadata-tokenURI}.
682      */
683     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
684         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
685 
686         string memory baseURI = _baseURI();
687         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
688     }
689 
690     /**
691      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
692      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
693      * by default, can be overriden in child contracts.
694      */
695     function _baseURI() internal view virtual returns (string memory) {
696         return "";
697     }
698 
699     /**
700      * @dev See {IERC721-approve}.
701      */
702     function approve(address to, uint256 tokenId) public virtual override {
703         address owner = ERC721.ownerOf(tokenId);
704         require(to != owner, "ERC721: approval to current owner");
705 
706         require(
707             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
708             "ERC721: approve caller is not owner nor approved for all"
709         );
710 
711         _approve(to, tokenId);
712     }
713 
714     /**
715      * @dev See {IERC721-getApproved}.
716      */
717     function getApproved(uint256 tokenId) public view virtual override returns (address) {
718         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
719 
720         return _tokenApprovals[tokenId];
721     }
722 
723     /**
724      * @dev See {IERC721-setApprovalForAll}.
725      */
726     function setApprovalForAll(address operator, bool approved) public virtual override {
727         require(operator != _msgSender(), "ERC721: approve to caller");
728 
729         _operatorApprovals[_msgSender()][operator] = approved;
730         emit ApprovalForAll(_msgSender(), operator, approved);
731     }
732 
733     /**
734      * @dev See {IERC721-isApprovedForAll}.
735      */
736     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
737         return _operatorApprovals[owner][operator];
738     }
739 
740     /**
741      * @dev See {IERC721-transferFrom}.
742      */
743     function transferFrom(
744         address from,
745         address to,
746         uint256 tokenId
747     ) public virtual override {
748         //solhint-disable-next-line max-line-length
749         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
750 
751         _transfer(from, to, tokenId);
752     }
753 
754     /**
755      * @dev See {IERC721-safeTransferFrom}.
756      */
757     function safeTransferFrom(
758         address from,
759         address to,
760         uint256 tokenId
761     ) public virtual override {
762         safeTransferFrom(from, to, tokenId, "");
763     }
764 
765     /**
766      * @dev See {IERC721-safeTransferFrom}.
767      */
768     function safeTransferFrom(
769         address from,
770         address to,
771         uint256 tokenId,
772         bytes memory _data
773     ) public virtual override {
774         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
775         _safeTransfer(from, to, tokenId, _data);
776     }
777 
778     /**
779      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
780      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
781      *
782      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
783      *
784      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
785      * implement alternative mechanisms to perform token transfer, such as signature-based.
786      *
787      * Requirements:
788      *
789      * - `from` cannot be the zero address.
790      * - `to` cannot be the zero address.
791      * - `tokenId` token must exist and be owned by `from`.
792      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
793      *
794      * Emits a {Transfer} event.
795      */
796     function _safeTransfer(
797         address from,
798         address to,
799         uint256 tokenId,
800         bytes memory _data
801     ) internal virtual {
802         _transfer(from, to, tokenId);
803         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
804     }
805 
806     /**
807      * @dev Returns whether `tokenId` exists.
808      *
809      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
810      *
811      * Tokens start existing when they are minted (`_mint`),
812      * and stop existing when they are burned (`_burn`).
813      */
814     function _exists(uint256 tokenId) internal view virtual returns (bool) {
815         return _owners[tokenId] != address(0);
816     }
817 
818     /**
819      * @dev Returns whether `spender` is allowed to manage `tokenId`.
820      *
821      * Requirements:
822      *
823      * - `tokenId` must exist.
824      */
825     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
826         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
827         address owner = ERC721.ownerOf(tokenId);
828         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
829     }
830 
831     /**
832      * @dev Safely mints `tokenId` and transfers it to `to`.
833      *
834      * Requirements:
835      *
836      * - `tokenId` must not exist.
837      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
838      *
839      * Emits a {Transfer} event.
840      */
841     function _safeMint(address to, uint256 tokenId) internal virtual {
842         _safeMint(to, tokenId, "");
843     }
844 
845     /**
846      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
847      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
848      */
849     function _safeMint(
850         address to,
851         uint256 tokenId,
852         bytes memory _data
853     ) internal virtual {
854         _mint(to, tokenId);
855         require(
856             _checkOnERC721Received(address(0), to, tokenId, _data),
857             "ERC721: transfer to non ERC721Receiver implementer"
858         );
859     }
860 
861     /**
862      * @dev Mints `tokenId` and transfers it to `to`.
863      *
864      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
865      *
866      * Requirements:
867      *
868      * - `tokenId` must not exist.
869      * - `to` cannot be the zero address.
870      *
871      * Emits a {Transfer} event.
872      */
873     function _mint(address to, uint256 tokenId) internal virtual {
874         require(to != address(0), "ERC721: mint to the zero address");
875         require(!_exists(tokenId), "ERC721: token already minted");
876 
877         _beforeTokenTransfer(address(0), to, tokenId);
878 
879         _balances[to] += 1;
880         _owners[tokenId] = to;
881 
882         emit Transfer(address(0), to, tokenId);
883     }
884 
885     /**
886      * @dev Destroys `tokenId`.
887      * The approval is cleared when the token is burned.
888      *
889      * Requirements:
890      *
891      * - `tokenId` must exist.
892      *
893      * Emits a {Transfer} event.
894      */
895     function _burn(uint256 tokenId) internal virtual {
896         address owner = ERC721.ownerOf(tokenId);
897 
898         _beforeTokenTransfer(owner, address(0), tokenId);
899 
900         // Clear approvals
901         _approve(address(0), tokenId);
902 
903         _balances[owner] -= 1;
904         delete _owners[tokenId];
905 
906         emit Transfer(owner, address(0), tokenId);
907     }
908 
909     /**
910      * @dev Transfers `tokenId` from `from` to `to`.
911      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
912      *
913      * Requirements:
914      *
915      * - `to` cannot be the zero address.
916      * - `tokenId` token must be owned by `from`.
917      *
918      * Emits a {Transfer} event.
919      */
920     function _transfer(
921         address from,
922         address to,
923         uint256 tokenId
924     ) internal virtual {
925         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
926         require(to != address(0), "ERC721: transfer to the zero address");
927 
928         _beforeTokenTransfer(from, to, tokenId);
929 
930         // Clear approvals from the previous owner
931         _approve(address(0), tokenId);
932 
933         _balances[from] -= 1;
934         _balances[to] += 1;
935         _owners[tokenId] = to;
936 
937         emit Transfer(from, to, tokenId);
938     }
939 
940     /**
941      * @dev Approve `to` to operate on `tokenId`
942      *
943      * Emits a {Approval} event.
944      */
945     function _approve(address to, uint256 tokenId) internal virtual {
946         _tokenApprovals[tokenId] = to;
947         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
948     }
949 
950     /**
951      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
952      * The call is not executed if the target address is not a contract.
953      *
954      * @param from address representing the previous owner of the given token ID
955      * @param to target address that will receive the tokens
956      * @param tokenId uint256 ID of the token to be transferred
957      * @param _data bytes optional data to send along with the call
958      * @return bool whether the call correctly returned the expected magic value
959      */
960     function _checkOnERC721Received(
961         address from,
962         address to,
963         uint256 tokenId,
964         bytes memory _data
965     ) private returns (bool) {
966         if (to.isContract()) {
967             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
968                 return retval == IERC721Receiver(to).onERC721Received.selector;
969             } catch (bytes memory reason) {
970                 if (reason.length == 0) {
971                     revert("ERC721: transfer to non ERC721Receiver implementer");
972                 } else {
973                     assembly {
974                         revert(add(32, reason), mload(reason))
975                     }
976                 }
977             }
978         } else {
979             return true;
980         }
981     }
982 
983     /**
984      * @dev Hook that is called before any token transfer. This includes minting
985      * and burning.
986      *
987      * Calling conditions:
988      *
989      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
990      * transferred to `to`.
991      * - When `from` is zero, `tokenId` will be minted for `to`.
992      * - When `to` is zero, ``from``'s `tokenId` will be burned.
993      * - `from` and `to` are never both zero.
994      *
995      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
996      */
997     function _beforeTokenTransfer(
998         address from,
999         address to,
1000         uint256 tokenId
1001     ) internal virtual {}
1002 }
1003 
1004 pragma solidity ^0.8.0;
1005 
1006 /**
1007  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1008  * @dev See https://eips.ethereum.org/EIPS/eip-721
1009  */
1010 interface IERC721Enumerable is IERC721 {
1011     /**
1012      * @dev Returns the total amount of tokens stored by the contract.
1013      */
1014     function totalSupply() external view returns (uint256);
1015 
1016     /**
1017      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1018      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1019      */
1020     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1021 
1022     /**
1023      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1024      * Use along with {totalSupply} to enumerate all tokens.
1025      */
1026     function tokenByIndex(uint256 index) external view returns (uint256);
1027 }
1028 
1029 pragma solidity ^0.8.0;
1030 
1031 
1032 /**
1033  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1034  * enumerability of all the token ids in the contract as well as all token ids owned by each
1035  * account.
1036  */
1037 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1038     // Mapping from owner to list of owned token IDs
1039     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1040 
1041     // Mapping from token ID to index of the owner tokens list
1042     mapping(uint256 => uint256) private _ownedTokensIndex;
1043 
1044     // Array with all token ids, used for enumeration
1045     uint256[] private _allTokens;
1046 
1047     // Mapping from token id to position in the allTokens array
1048     mapping(uint256 => uint256) private _allTokensIndex;
1049 
1050     /**
1051      * @dev See {IERC165-supportsInterface}.
1052      */
1053     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1054         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1055     }
1056 
1057     /**
1058      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1059      */
1060     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1061         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1062         return _ownedTokens[owner][index];
1063     }
1064 
1065     /**
1066      * @dev See {IERC721Enumerable-totalSupply}.
1067      */
1068     function totalSupply() public view virtual override returns (uint256) {
1069         return _allTokens.length;
1070     }
1071 
1072     /**
1073      * @dev See {IERC721Enumerable-tokenByIndex}.
1074      */
1075     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1076         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1077         return _allTokens[index];
1078     }
1079 
1080     /**
1081      * @dev Hook that is called before any token transfer. This includes minting
1082      * and burning.
1083      *
1084      * Calling conditions:
1085      *
1086      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1087      * transferred to `to`.
1088      * - When `from` is zero, `tokenId` will be minted for `to`.
1089      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1090      * - `from` cannot be the zero address.
1091      * - `to` cannot be the zero address.
1092      *
1093      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1094      */
1095     function _beforeTokenTransfer(
1096         address from,
1097         address to,
1098         uint256 tokenId
1099     ) internal virtual override {
1100         super._beforeTokenTransfer(from, to, tokenId);
1101 
1102         if (from == address(0)) {
1103             _addTokenToAllTokensEnumeration(tokenId);
1104         } else if (from != to) {
1105             _removeTokenFromOwnerEnumeration(from, tokenId);
1106         }
1107         if (to == address(0)) {
1108             _removeTokenFromAllTokensEnumeration(tokenId);
1109         } else if (to != from) {
1110             _addTokenToOwnerEnumeration(to, tokenId);
1111         }
1112     }
1113 
1114     /**
1115      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1116      * @param to address representing the new owner of the given token ID
1117      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1118      */
1119     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1120         uint256 length = ERC721.balanceOf(to);
1121         _ownedTokens[to][length] = tokenId;
1122         _ownedTokensIndex[tokenId] = length;
1123     }
1124 
1125     /**
1126      * @dev Private function to add a token to this extension's token tracking data structures.
1127      * @param tokenId uint256 ID of the token to be added to the tokens list
1128      */
1129     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1130         _allTokensIndex[tokenId] = _allTokens.length;
1131         _allTokens.push(tokenId);
1132     }
1133 
1134     /**
1135      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1136      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1137      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1138      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1139      * @param from address representing the previous owner of the given token ID
1140      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1141      */
1142     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1143         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1144         // then delete the last slot (swap and pop).
1145 
1146         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1147         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1148 
1149         // When the token to delete is the last token, the swap operation is unnecessary
1150         if (tokenIndex != lastTokenIndex) {
1151             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1152 
1153             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1154             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1155         }
1156 
1157         // This also deletes the contents at the last position of the array
1158         delete _ownedTokensIndex[tokenId];
1159         delete _ownedTokens[from][lastTokenIndex];
1160     }
1161 
1162     /**
1163      * @dev Private function to remove a token from this extension's token tracking data structures.
1164      * This has O(1) time complexity, but alters the order of the _allTokens array.
1165      * @param tokenId uint256 ID of the token to be removed from the tokens list
1166      */
1167     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1168         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1169         // then delete the last slot (swap and pop).
1170 
1171         uint256 lastTokenIndex = _allTokens.length - 1;
1172         uint256 tokenIndex = _allTokensIndex[tokenId];
1173 
1174         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1175         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1176         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1177         uint256 lastTokenId = _allTokens[lastTokenIndex];
1178 
1179         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1180         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1181 
1182         // This also deletes the contents at the last position of the array
1183         delete _allTokensIndex[tokenId];
1184         _allTokens.pop();
1185     }
1186 }
1187 
1188 pragma solidity ^0.8.0;
1189 
1190 /**
1191  * @dev Contract module that helps prevent reentrant calls to a function.
1192  *
1193  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1194  * available, which can be applied to functions to make sure there are no nested
1195  * (reentrant) calls to them.
1196  *
1197  * Note that because there is a single `nonReentrant` guard, functions marked as
1198  * `nonReentrant` may not call one another. This can be worked around by making
1199  * those functions `private`, and then adding `external` `nonReentrant` entry
1200  * points to them.
1201  *
1202  * TIP: If you would like to learn more about reentrancy and alternative ways
1203  * to protect against it, check out our blog post
1204  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1205  */
1206 abstract contract ReentrancyGuard {
1207     // Booleans are more expensive than uint256 or any type that takes up a full
1208     // word because each write operation emits an extra SLOAD to first read the
1209     // slot's contents, replace the bits taken up by the boolean, and then write
1210     // back. This is the compiler's defense against contract upgrades and
1211     // pointer aliasing, and it cannot be disabled.
1212 
1213     // The values being non-zero value makes deployment a bit more expensive,
1214     // but in exchange the refund on every call to nonReentrant will be lower in
1215     // amount. Since refunds are capped to a percentage of the total
1216     // transaction's gas, it is best to keep them low in cases like this one, to
1217     // increase the likelihood of the full refund coming into effect.
1218     uint256 private constant _NOT_ENTERED = 1;
1219     uint256 private constant _ENTERED = 2;
1220 
1221     uint256 private _status;
1222 
1223     constructor() {
1224         _status = _NOT_ENTERED;
1225     }
1226 
1227     /**
1228      * @dev Prevents a contract from calling itself, directly or indirectly.
1229      * Calling a `nonReentrant` function from another `nonReentrant`
1230      * function is not supported. It is possible to prevent this from happening
1231      * by making the `nonReentrant` function external, and make it call a
1232      * `private` function that does the actual work.
1233      */
1234     modifier nonReentrant() {
1235         // On the first call to nonReentrant, _notEntered will be true
1236         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1237 
1238         // Any calls to nonReentrant after this point will fail
1239         _status = _ENTERED;
1240 
1241         _;
1242 
1243         // By storing the original value once again, a refund is triggered (see
1244         // https://eips.ethereum.org/EIPS/eip-2200)
1245         _status = _NOT_ENTERED;
1246     }
1247 }
1248 
1249 pragma solidity ^0.8.0;
1250 
1251 /// @title Base64
1252 /// @notice Provides a function for encoding some bytes in base64
1253 /// @author Brecht Devos <brecht@loopring.org>
1254 library Base64 {
1255     bytes internal constant TABLE =
1256     'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
1257 
1258     /// @notice Encodes some bytes to the base64 representation
1259     function encode(bytes memory data) internal pure returns (string memory) {
1260         uint256 len = data.length;
1261         if (len == 0) return '';
1262 
1263         // multiply by 4/3 rounded up
1264         uint256 encodedLen = 4 * ((len + 2) / 3);
1265 
1266         // Add some extra buffer at the end
1267         bytes memory result = new bytes(encodedLen + 32);
1268 
1269         bytes memory table = TABLE;
1270 
1271         assembly {
1272             let tablePtr := add(table, 1)
1273             let resultPtr := add(result, 32)
1274 
1275             for {
1276                 let i := 0
1277             } lt(i, len) {
1278 
1279             } {
1280                 i := add(i, 3)
1281                 let input := and(mload(add(data, i)), 0xffffff)
1282 
1283                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
1284                 out := shl(8, out)
1285                 out := add(
1286                 out,
1287                 and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF)
1288                 )
1289                 out := shl(8, out)
1290                 out := add(
1291                 out,
1292                 and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF)
1293                 )
1294                 out := shl(8, out)
1295                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
1296                 out := shl(224, out)
1297 
1298                 mstore(resultPtr, out)
1299 
1300                 resultPtr := add(resultPtr, 4)
1301             }
1302 
1303             switch mod(len, 3)
1304             case 1 {
1305                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1306             }
1307             case 2 {
1308                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
1309             }
1310 
1311             mstore(result, encodedLen)
1312         }
1313 
1314         return string(result);
1315     }
1316 
1317     function get_an_url(string memory experience_url, string[17] memory parts) internal pure returns (string memory){
1318         string memory an_url = string(abi.encodePacked(',"animation_url":"', experience_url,
1319             'weapon=', parts[1],
1320             '&chest=', parts[3],
1321             '&head=', parts[5],
1322             '&waist=', parts[7]
1323             ));
1324         an_url = string(abi.encodePacked(an_url,
1325             '&foot=', parts[9],
1326             '&hand=', parts[11],
1327             '&neck=', parts[13],
1328             '&ring=', parts[15], '"'));
1329         return an_url;
1330     }
1331 }
1332 
1333 pragma solidity ^0.8.0;
1334 contract PLOOT is ERC721Enumerable, ReentrancyGuard, Ownable {
1335 
1336     string[] private weapons = [
1337     "Tweet",
1338     "PoopyPost",
1339     "SVG",
1340     "PNG",
1341     "Dump",
1342     "Dumper-Shield",
1343     "Fart",
1344     "Gas",
1345     "Plunger",
1346     "Plunger-Gun",
1347     "Mop",
1348     "Toilet Brush",
1349     "JPEG",
1350     "Toilet",
1351     "Micro-Toilet",
1352     "Macro-Flush",
1353     "Pooponator",
1354     "Grenades",
1355     "TNT",
1356     "Doom Sword",
1357     "Lance",
1358     "Umbrella",
1359     "Shield",
1360     "Flaming Staff",
1361     "Launcher",
1362     "Sticky-Poo",
1363     "Enemator",
1364     "Golf stick"
1365     ];
1366 
1367     string[] private chestArmor = [
1368     "Poopy Space Armor",
1369     "Poopy Suit",
1370     "Hazmat Poopy Suit",
1371     "Toilet-Paper Suit",
1372     "Poopy COPE armor",
1373     "WAGMI Poopy Robe",
1374     "Poopy Chain Mail",
1375     "Poopy FOMO Suit",
1376     "Poopy Poncho",
1377     "Incredible Poopy Bib",
1378     "Poopy Bra",
1379     "Iron Poopy Vest",
1380     "Blinding Poopy Tee",
1381     "French Maid Apron",
1382     "Spiky Poo Chest",
1383     "Poopy Wood Chest",
1384     "Haunted Poopy Dress",
1385     "Bewitched Poopy Gown",
1386     "Tactical Poopy Gear",
1387     "Poopy Birthday Suit",
1388     "Poopy Hoodie",
1389     "Poopy Chain Mail",
1390     "Poopy Harness",
1391     "Ninja suit",
1392     "Tuxedo",
1393     "Generic tee",
1394     "Banana costume",
1395     "Andy Warhol tee",
1396     "NGMI Poopy Robe"
1397     ];
1398 
1399     string[] private headArmor = [
1400     "Poopy Hat",
1401     "Poopy Helmet",
1402     "Toilet Seat",
1403     "Peanie Hat",
1404     "Gas Mask",
1405     "3D Poo Glasses",
1406     "Poopy Chef hat",
1407     "Butt Head",
1408     "Poopy Mask",
1409     "Poopy Tip",
1410     "Poopy Helmet",
1411     "Poopy Beard",
1412     "Poopy Lipstick",
1413     "Poopy Shades",
1414     "Goggles",
1415     "Traffic cone",
1416     "Rubber Duck",
1417     "Bandana",
1418     "Poopy Crown",
1419     "Olive Crown",
1420     "Horns"
1421     ];
1422 
1423     string[] private waistArmor = [
1424     "Diaper",
1425     "Poopy Boxers",
1426     "Poopy Underpants",
1427     "Brown Pants",
1428     "Soiled Trousers",
1429     "Toilet Bowl",
1430     "Diaper",
1431     "Poo Thong",
1432     "Poopy Bikini",
1433     "Poopy Belt",
1434     "Poopy Rope",
1435     "Gold Poopy Belt",
1436     "Poopy underwear",
1437     "Depends",
1438     "Poopy Leggings",
1439     "Poopy Strap On",
1440     "Titanium Strap On",
1441     "Poopy Skirt",
1442     "Poopy Kilt",
1443     "Scottish Skirt"
1444     ];
1445 
1446     string[] private footArmor = [
1447     "Toilet Shoes",
1448     "Poopy Clogs",
1449     "Poopy Waders",
1450     "Combat Poopy Boots",
1451     "Poopy Sneakers",
1452     "Plastic Bags",
1453     "Poopy crocs",
1454     "Poopy Pumps",
1455     "Poopy Slippers",
1456     "Golden Poopy Toes",
1457     "Poopy FlipFlops",
1458     "Poopy Wedges",
1459     "Platform Shoes",
1460     "High Heels",
1461     "Clown Shoes",
1462     "Bowling Shoes",
1463     "Rare Sneakerz",
1464     "Bigfoot Sandals",
1465     "Sexy High Heels",
1466     "Rain Boots",
1467     "Rollerblades"
1468     ];
1469 
1470     string[] private handArmor = [
1471     "Gloves",
1472     "Mitten",
1473     "Marigold",
1474     "Glove",
1475     "Brass Knuckles",
1476     "Lambo Door",
1477     "Ferrari Hood",
1478     "Cleaning Gloves",
1479     "Diamond Gloves",
1480     "Fomo Gloves",
1481     "Paper hands",
1482     "Diamond hands",
1483     "Poopy Claws",
1484     "Glamore Nails",
1485     "Poopy Hologlove",
1486     "Poopy Gloves",
1487     "Surgical Gloves",
1488     "Tennis Racket",
1489     "Toothbrush",
1490     "Spy Gloves",
1491     "Leather Gloves",
1492     "Butter fingers",
1493     "Salad Fingers",
1494     "Sparkle Nails",
1495     "Robot Claws",
1496     "Goalie Gloves"
1497     ];
1498 
1499     string[] private necklaces = [
1500     "Poo Chain",
1501     "Toilet Seat",
1502     "Poopy Links",
1503     "Hoola Poop",
1504     "Poopy Leash",
1505     "Poopy Scarf",
1506     "Poopy Beads",
1507     "Scarf",
1508     "Rapper chain",
1509     "Dog Leash",
1510     "Wizard Stone",
1511     "Choker",
1512     "Pendant"
1513     ];
1514 
1515     string[] private rings = [
1516     "Poopy Eth Ring",
1517     "Poopy Ring",
1518     "Poopy Diamond Ring",
1519     "High Poopy Gas Ring",
1520     "GMI Poo Ring",
1521     "Urinal Cake",
1522     "Poopy Bagel ring",
1523     "Poopy Ring Pop",
1524     "Poopy Candy Ring",
1525     "Poopy Wedding Band",
1526     "Poopy Laser Ring",
1527     "Poopy Spy Ring",
1528     "Poopourri Ring",
1529     "Poopy Finger",
1530     "Finger Glove",
1531     "Weeding Ring",
1532     "Paper Ring"
1533     ];
1534 
1535     string[] private suffixes = [
1536     "of Poop",
1537     "of Great Poop",
1538     "of OG Poopyness",
1539     "of Poopy Royalty",
1540     "of Holy Poopy",
1541     "of Laxative",
1542     "of Fart",
1543     "of Low Fiber",
1544     "of Tummyache",
1545     "of the Shitcoins",
1546     "of Rugs",
1547     "of Vitaliks IQ",
1548     "of FOMO",
1549     "of Cleaning",
1550     "of the Gas Wars",
1551     "of the HODLERS",
1552     "of the Vitalik",
1553     "of the Nakamoto",
1554     "of GMI",
1555     "of NGMI",
1556     "of Punishment",
1557     "of the Universe",
1558     "of the Toilette",
1559     "of Fire"
1560     ];
1561 
1562     string[] private namePrefixes = [
1563     "Poopy",
1564     "Royal",
1565     "Madd",
1566     "Kangaroo",
1567     "Crab",
1568     "Crypto",
1569     "Block",
1570     "0x",
1571     "Wagminerino",
1572     "Shitoshi",
1573     "Shitcoin",
1574     "Fomerino",
1575     "Fomostein",
1576     "Poopenstein",
1577     "Colon",
1578     "Rectal",
1579     "PooCoin",
1580     "Poopy Token",
1581     "Princess",
1582     "King",
1583     "Sir",
1584     "Queen",
1585     "Dutchess",
1586     "Bare",
1587     "Ms",
1588     "Mr",
1589     "Poo",
1590     "Beanie",
1591     "Ape",
1592     "Cat",
1593     "Kitty",
1594     "Robot",
1595     "Punks",
1596     "Knight",
1597     "Jester",
1598     "ERC-Poopy",
1599     "Legendary",
1600     "Fudder"
1601     ];
1602 
1603     string[] private nameSuffixes = [
1604     "Dump",
1605     "Plop",
1606     "Only-Up",
1607     "Paper-Hand",
1608     "Diamond-Hand",
1609     "Poopy-Hand",
1610     "Cat",
1611     "Dog",
1612     "Robot",
1613     "Yeti",
1614     "Panda",
1615     "Fox",
1616     "Undead",
1617     "Scientist",
1618     "Crab",
1619     "Kangeroo",
1620     "Comic",
1621     "Roadmap",
1622     "Whitepaper"
1623     ];
1624 
1625     function random(string memory input) internal pure returns (uint256) {
1626         return uint256(keccak256(abi.encodePacked(input)));
1627     }
1628 
1629     function getWeapon(uint256 tokenId) public view returns (string memory) {
1630         return pluck(tokenId, "WEAPON", weapons);
1631     }
1632 
1633     function getChest(uint256 tokenId) public view returns (string memory) {
1634         return pluck(tokenId, "CHEST", chestArmor);
1635     }
1636 
1637     function getHead(uint256 tokenId) public view returns (string memory) {
1638         return pluck(tokenId, "HEAD", headArmor);
1639     }
1640 
1641     function getWaist(uint256 tokenId) public view returns (string memory) {
1642         return pluck(tokenId, "WAIST", waistArmor);
1643     }
1644 
1645     function getFoot(uint256 tokenId) public view returns (string memory) {
1646         return pluck(tokenId, "FOOT", footArmor);
1647     }
1648 
1649     function getHand(uint256 tokenId) public view returns (string memory) {
1650         return pluck(tokenId, "HAND", handArmor);
1651     }
1652 
1653     function getNeck(uint256 tokenId) public view returns (string memory) {
1654         return pluck(tokenId, "NECK", necklaces);
1655     }
1656 
1657     function getRing(uint256 tokenId) public view returns (string memory) {
1658         return pluck(tokenId, "RING", rings);
1659     }
1660 
1661     function pluck(uint256 tokenId, string memory keyPrefix, string[] memory sourceArray) internal view returns (string memory) {
1662         uint256 rand = random(string(abi.encodePacked(keyPrefix, toString(tokenId))));
1663         string memory output = sourceArray[rand % sourceArray.length];
1664         uint256 greatness = rand % 21;
1665         if (greatness > 14) {
1666             output = string(abi.encodePacked(output, " ", suffixes[rand % suffixes.length]));
1667         }
1668         if (greatness >= 19) {
1669             string[2] memory name;
1670             name[0] = namePrefixes[rand % namePrefixes.length];
1671             name[1] = nameSuffixes[rand % nameSuffixes.length];
1672             if (greatness == 19) {
1673                 output = string(abi.encodePacked('*', name[0], ' ', name[1], '* ', output));
1674             } else {
1675                 output = string(abi.encodePacked('*', name[0], ' ', name[1], '* ', output, " +1"));
1676             }
1677         }
1678         return output;
1679     }
1680 
1681     function tokenURI(uint256 tokenId) override public view returns (string memory) {
1682         string[17] memory parts;
1683         parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: black; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="#01ff01" /><text x="10" y="20" class="base">';
1684 
1685         parts[1] = getWeapon(tokenId);
1686 
1687         parts[2] = '</text><text x="10" y="40" class="base">';
1688 
1689         parts[3] = getChest(tokenId);
1690 
1691         parts[4] = '</text><text x="10" y="60" class="base">';
1692 
1693         parts[5] = getHead(tokenId);
1694 
1695         parts[6] = '</text><text x="10" y="80" class="base">';
1696 
1697         parts[7] = getWaist(tokenId);
1698 
1699         parts[8] = '</text><text x="10" y="100" class="base">';
1700 
1701         parts[9] = getFoot(tokenId);
1702 
1703         parts[10] = '</text><text x="10" y="120" class="base">';
1704 
1705         parts[11] = getHand(tokenId);
1706 
1707         parts[12] = '</text><text x="10" y="140" class="base">';
1708 
1709         parts[13] = getNeck(tokenId);
1710 
1711         parts[14] = '</text><text x="10" y="160" class="base">';
1712 
1713         parts[15] = getRing(tokenId);
1714 
1715         parts[16] = '</text></svg>';
1716 
1717         string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8]));
1718         output = string(abi.encodePacked(output, parts[9], parts[10], parts[11], parts[12], parts[13], parts[14], parts[15], parts[16]));
1719 
1720         string memory an_url = '';
1721 
1722         if (bytes(experience_url).length > 0) {
1723             an_url = Base64.get_an_url(experience_url, parts);
1724         }
1725 
1726         string memory json = Base64.encode(bytes(string(abi.encodePacked(
1727                 '{"name": "pBloot #',
1728                 toString(tokenId),
1729                 '", "description": "pBloot is basically PoopyBLOOT.", "image": "data:image/svg+xml;base64,',
1730                 Base64.encode(bytes(output)), '"',
1731                 an_url,
1732                 '}'
1733             ))));
1734         output = string(abi.encodePacked('data:application/json;base64,', json));
1735 
1736         return output;
1737     }
1738 
1739     function claimForBloot(uint256 tokenId) public nonReentrant {
1740         require(tokenId > 0 && tokenId < 8009, 'Token ID invalid');
1741         require(bloot.ownerOf(tokenId) == msg.sender, 'Not Bloot owner');
1742         _safeMint(_msgSender(), tokenId);
1743     }
1744 
1745     function claim(uint256 tokenId) public nonReentrant {
1746         require(tokenId > 8008 && tokenId < 12908, 'Token ID invalid');
1747         _safeMint(_msgSender(), tokenId);
1748     }
1749 
1750     function giveaway(uint tokenId, address _to) public nonReentrant onlyOwner {
1751         require(tokenId > 12907 && tokenId < 13009, 'Token ID invalid');
1752         _safeMint(_to, tokenId);
1753     }
1754 
1755     function toString(uint256 value) internal pure returns (string memory) {
1756         // Inspired by OraclizeAPI's implementation - MIT license
1757         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1758 
1759         if (value == 0) {
1760             return "0";
1761         }
1762         uint256 temp = value;
1763         uint256 digits;
1764         while (temp != 0) {
1765             digits++;
1766             temp /= 10;
1767         }
1768         bytes memory buffer = new bytes(digits);
1769         while (value != 0) {
1770             digits -= 1;
1771             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1772             value /= 10;
1773         }
1774         return string(buffer);
1775     }
1776 
1777     ERC721 bloot = ERC721(0x4F8730E0b32B04beaa5757e5aea3aeF970E5B613);
1778 
1779     string private experience_url;
1780 
1781     function setExperienceUrl(string memory url) external onlyOwner {
1782         experience_url = url;
1783     }
1784 
1785     constructor() ERC721("Poopy BLOOT", "PBLOOT") Ownable() {}
1786 }