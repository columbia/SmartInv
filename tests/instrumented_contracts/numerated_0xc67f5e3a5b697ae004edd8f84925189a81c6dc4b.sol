1 // File contracts/openzeppelin/contracts/utils/Context.sol
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
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 // File contracts/openzeppelin/contracts/access/Ownable.sol
27 
28 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor() {
53         _transferOwnership(_msgSender());
54     }
55 
56     /**
57      * @dev Returns the address of the current owner.
58      */
59     function owner() public view virtual returns (address) {
60         return _owner;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(owner() == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     /**
72      * @dev Leaves the contract without owner. It will not be possible to call
73      * `onlyOwner` functions anymore. Can only be called by the current owner.
74      *
75      * NOTE: Renouncing ownership will leave the contract without an owner,
76      * thereby removing any functionality that is only available to the owner.
77      */
78     function renounceOwnership() public virtual onlyOwner {
79         _transferOwnership(address(0));
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Can only be called by the current owner.
85      */
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(newOwner != address(0), "Ownable: new owner is the zero address");
88         _transferOwnership(newOwner);
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Internal function without access restriction.
94      */
95     function _transferOwnership(address newOwner) internal virtual {
96         address oldOwner = _owner;
97         _owner = newOwner;
98         emit OwnershipTransferred(oldOwner, newOwner);
99     }
100 }
101 
102 // File contracts/openzeppelin/contracts/utils/introspection/IERC165.sol
103 
104 pragma solidity ^0.8.0;
105 
106 /**
107  * @dev Interface of the ERC165 standard, as defined in the
108  * https://eips.ethereum.org/EIPS/eip-165[EIP].
109  *
110  * Implementers can declare support of contract interfaces, which can then be
111  * queried by others ({ERC165Checker}).
112  *
113  * For an implementation, see {ERC165}.
114  */
115 interface IERC165 {
116     /**
117      * @dev Returns true if this contract implements the interface defined by
118      * `interfaceId`. See the corresponding
119      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
120      * to learn more about how these ids are created.
121      *
122      * This function call must use less than 30 000 gas.
123      */
124     function supportsInterface(bytes4 interfaceId) external view returns (bool);
125 }
126 
127 // File contracts/openzeppelin/contracts/token/ERC721/IERC721.sol
128 
129 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
130 
131 pragma solidity ^0.8.0;
132 
133 /**
134  * @dev Required interface of an ERC721 compliant contract.
135  */
136 interface IERC721 is IERC165 {
137     /**
138      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
139      */
140     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
141 
142     /**
143      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
144      */
145     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
146 
147     /**
148      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
149      */
150     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
151 
152     /**
153      * @dev Returns the number of tokens in ``owner``'s account.
154      */
155     function balanceOf(address owner) external view returns (uint256 balance);
156 
157     /**
158      * @dev Returns the owner of the `tokenId` token.
159      *
160      * Requirements:
161      *
162      * - `tokenId` must exist.
163      */
164     function ownerOf(uint256 tokenId) external view returns (address owner);
165 
166     /**
167      * @dev Safely transfers `tokenId` token from `from` to `to`.
168      *
169      * Requirements:
170      *
171      * - `from` cannot be the zero address.
172      * - `to` cannot be the zero address.
173      * - `tokenId` token must exist and be owned by `from`.
174      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
175      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
176      *
177      * Emits a {Transfer} event.
178      */
179     function safeTransferFrom(
180         address from,
181         address to,
182         uint256 tokenId,
183         bytes calldata data
184     ) external;
185 
186     /**
187      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
188      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
189      *
190      * Requirements:
191      *
192      * - `from` cannot be the zero address.
193      * - `to` cannot be the zero address.
194      * - `tokenId` token must exist and be owned by `from`.
195      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
196      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
197      *
198      * Emits a {Transfer} event.
199      */
200     function safeTransferFrom(
201         address from,
202         address to,
203         uint256 tokenId
204     ) external;
205 
206     /**
207      * @dev Transfers `tokenId` token from `from` to `to`.
208      *
209      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
210      *
211      * Requirements:
212      *
213      * - `from` cannot be the zero address.
214      * - `to` cannot be the zero address.
215      * - `tokenId` token must be owned by `from`.
216      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
217      *
218      * Emits a {Transfer} event.
219      */
220     function transferFrom(
221         address from,
222         address to,
223         uint256 tokenId
224     ) external;
225 
226     /**
227      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
228      * The approval is cleared when the token is transferred.
229      *
230      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
231      *
232      * Requirements:
233      *
234      * - The caller must own the token or be an approved operator.
235      * - `tokenId` must exist.
236      *
237      * Emits an {Approval} event.
238      */
239     function approve(address to, uint256 tokenId) external;
240 
241     /**
242      * @dev Approve or remove `operator` as an operator for the caller.
243      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
244      *
245      * Requirements:
246      *
247      * - The `operator` cannot be the caller.
248      *
249      * Emits an {ApprovalForAll} event.
250      */
251     function setApprovalForAll(address operator, bool _approved) external;
252 
253     /**
254      * @dev Returns the account approved for `tokenId` token.
255      *
256      * Requirements:
257      *
258      * - `tokenId` must exist.
259      */
260     function getApproved(uint256 tokenId) external view returns (address operator);
261 
262     /**
263      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
264      *
265      * See {setApprovalForAll}
266      */
267     function isApprovedForAll(address owner, address operator) external view returns (bool);
268 }
269 
270 // File contracts/openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
271 
272 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
273 
274 pragma solidity ^0.8.0;
275 
276 /**
277  * @title ERC721 token receiver interface
278  * @dev Interface for any contract that wants to support safeTransfers
279  * from ERC721 asset contracts.
280  */
281 interface IERC721Receiver {
282     /**
283      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
284      * by `operator` from `from`, this function is called.
285      *
286      * It must return its Solidity selector to confirm the token transfer.
287      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
288      *
289      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
290      */
291     function onERC721Received(
292         address operator,
293         address from,
294         uint256 tokenId,
295         bytes calldata data
296     ) external returns (bytes4);
297 }
298 
299 // File contracts/openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
300 
301 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
302 
303 pragma solidity ^0.8.0;
304 
305 /**
306  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
307  * @dev See https://eips.ethereum.org/EIPS/eip-721
308  */
309 interface IERC721Metadata is IERC721 {
310     /**
311      * @dev Returns the token collection name.
312      */
313     function name() external view returns (string memory);
314 
315     /**
316      * @dev Returns the token collection symbol.
317      */
318     function symbol() external view returns (string memory);
319 
320     /**
321      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
322      */
323     function tokenURI(uint256 tokenId) external view returns (string memory);
324 }
325 
326 // File contracts/openzeppelin/contracts/utils/Address.sol
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
357         // solhint-disable-next-line no-inline-assembly
358         assembly {
359             size := extcodesize(account)
360         }
361         return size > 0;
362     }
363 
364     /**
365      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
366      * `recipient`, forwarding all available gas and reverting on errors.
367      *
368      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
369      * of certain opcodes, possibly making contracts go over the 2300 gas limit
370      * imposed by `transfer`, making them unable to receive funds via
371      * `transfer`. {sendValue} removes this limitation.
372      *
373      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
374      *
375      * IMPORTANT: because control is transferred to `recipient`, care must be
376      * taken to not create reentrancy vulnerabilities. Consider using
377      * {ReentrancyGuard} or the
378      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
379      */
380     function sendValue(address payable recipient, uint256 amount) internal {
381         require(address(this).balance >= amount, "Address: insufficient balance");
382 
383         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
384         (bool success, ) = recipient.call{value: amount}("");
385         require(success, "Address: unable to send value, recipient may have reverted");
386     }
387 
388     /**
389      * @dev Performs a Solidity function call using a low level `call`. A
390      * plain`call` is an unsafe replacement for a function call: use this
391      * function instead.
392      *
393      * If `target` reverts with a revert reason, it is bubbled up by this
394      * function (like regular Solidity function calls).
395      *
396      * Returns the raw returned data. To convert to the expected return value,
397      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
398      *
399      * Requirements:
400      *
401      * - `target` must be a contract.
402      * - calling `target` with `data` must not revert.
403      *
404      * _Available since v3.1._
405      */
406     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
407         return functionCall(target, data, "Address: low-level call failed");
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
412      * `errorMessage` as a fallback revert reason when `target` reverts.
413      *
414      * _Available since v3.1._
415      */
416     function functionCall(
417         address target,
418         bytes memory data,
419         string memory errorMessage
420     ) internal returns (bytes memory) {
421         return functionCallWithValue(target, data, 0, errorMessage);
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
426      * but also transferring `value` wei to `target`.
427      *
428      * Requirements:
429      *
430      * - the calling contract must have an ETH balance of at least `value`.
431      * - the called Solidity function must be `payable`.
432      *
433      * _Available since v3.1._
434      */
435     function functionCallWithValue(
436         address target,
437         bytes memory data,
438         uint256 value
439     ) internal returns (bytes memory) {
440         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
445      * with `errorMessage` as a fallback revert reason when `target` reverts.
446      *
447      * _Available since v3.1._
448      */
449     function functionCallWithValue(
450         address target,
451         bytes memory data,
452         uint256 value,
453         string memory errorMessage
454     ) internal returns (bytes memory) {
455         require(address(this).balance >= value, "Address: insufficient balance for call");
456         require(isContract(target), "Address: call to non-contract");
457 
458         // solhint-disable-next-line avoid-low-level-calls
459         (bool success, bytes memory returndata) = target.call{value: value}(data);
460         return _verifyCallResult(success, returndata, errorMessage);
461     }
462 
463     /**
464      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
465      * but performing a static call.
466      *
467      * _Available since v3.3._
468      */
469     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
470         return functionStaticCall(target, data, "Address: low-level static call failed");
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
475      * but performing a static call.
476      *
477      * _Available since v3.3._
478      */
479     function functionStaticCall(
480         address target,
481         bytes memory data,
482         string memory errorMessage
483     ) internal view returns (bytes memory) {
484         require(isContract(target), "Address: static call to non-contract");
485 
486         // solhint-disable-next-line avoid-low-level-calls
487         (bool success, bytes memory returndata) = target.staticcall(data);
488         return _verifyCallResult(success, returndata, errorMessage);
489     }
490 
491     /**
492      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
493      * but performing a delegate call.
494      *
495      * _Available since v3.4._
496      */
497     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
498         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
499     }
500 
501     /**
502      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
503      * but performing a delegate call.
504      *
505      * _Available since v3.4._
506      */
507     function functionDelegateCall(
508         address target,
509         bytes memory data,
510         string memory errorMessage
511     ) internal returns (bytes memory) {
512         require(isContract(target), "Address: delegate call to non-contract");
513 
514         // solhint-disable-next-line avoid-low-level-calls
515         (bool success, bytes memory returndata) = target.delegatecall(data);
516         return _verifyCallResult(success, returndata, errorMessage);
517     }
518 
519     function _verifyCallResult(
520         bool success,
521         bytes memory returndata,
522         string memory errorMessage
523     ) private pure returns (bytes memory) {
524         if (success) {
525             return returndata;
526         } else {
527             // Look for revert reason and bubble it up if present
528             if (returndata.length > 0) {
529                 // The easiest way to bubble the revert reason is using memory via assembly
530 
531                 // solhint-disable-next-line no-inline-assembly
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
543 // File contracts/openzeppelin/contracts/utils/Strings.sol
544 
545 pragma solidity ^0.8.0;
546 
547 /**
548  * @dev String operations.
549  */
550 library Strings {
551     bytes16 private constant alphabet = "0123456789abcdef";
552 
553     /**
554      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
555      */
556     function toString(uint256 value) internal pure returns (string memory) {
557         // Inspired by OraclizeAPI's implementation - MIT licence
558         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
559 
560         if (value == 0) {
561             return "0";
562         }
563         uint256 temp = value;
564         uint256 digits;
565         while (temp != 0) {
566             digits++;
567             temp /= 10;
568         }
569         bytes memory buffer = new bytes(digits);
570         while (value != 0) {
571             digits -= 1;
572             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
573             value /= 10;
574         }
575         return string(buffer);
576     }
577 
578     /**
579      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
580      */
581     function toHexString(uint256 value) internal pure returns (string memory) {
582         if (value == 0) {
583             return "0x00";
584         }
585         uint256 temp = value;
586         uint256 length = 0;
587         while (temp != 0) {
588             length++;
589             temp >>= 8;
590         }
591         return toHexString(value, length);
592     }
593 
594     /**
595      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
596      */
597     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
598         bytes memory buffer = new bytes(2 * length + 2);
599         buffer[0] = "0";
600         buffer[1] = "x";
601         for (uint256 i = 2 * length + 1; i > 1; --i) {
602             buffer[i] = alphabet[value & 0xf];
603             value >>= 4;
604         }
605         require(value == 0, "Strings: hex length insufficient");
606         return string(buffer);
607     }
608 }
609 
610 // File contracts/openzeppelin/contracts/utils/introspection/ERC165.sol
611 
612 pragma solidity ^0.8.0;
613 
614 /**
615  * @dev Implementation of the {IERC165} interface.
616  *
617  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
618  * for the additional interface id that will be supported. For example:
619  *
620  * ```solidity
621  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
622  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
623  * }
624  * ```
625  *
626  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
627  */
628 abstract contract ERC165 is IERC165 {
629     /**
630      * @dev See {IERC165-supportsInterface}.
631      */
632     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
633         return interfaceId == type(IERC165).interfaceId;
634     }
635 }
636 
637 // File contracts/openzeppelin/contracts/token/ERC721/ERC721.sol
638 
639 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
640 
641 pragma solidity ^0.8.0;
642 
643 /**
644  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
645  * the Metadata extension, but not including the Enumerable extension, which is available separately as
646  * {ERC721Enumerable}.
647  */
648 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
649     using Address for address;
650     using Strings for uint256;
651 
652     // Token name
653     string private _name;
654 
655     // Token symbol
656     string private _symbol;
657 
658     // Mapping from token ID to owner address
659     mapping(uint256 => address) private _owners;
660 
661     // Mapping owner address to token count
662     mapping(address => uint256) private _balances;
663 
664     // Mapping from token ID to approved address
665     mapping(uint256 => address) private _tokenApprovals;
666 
667     // Mapping from owner to operator approvals
668     mapping(address => mapping(address => bool)) private _operatorApprovals;
669 
670     /**
671      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
672      */
673     constructor(string memory name_, string memory symbol_) {
674         _name = name_;
675         _symbol = symbol_;
676     }
677 
678     /**
679      * @dev See {IERC165-supportsInterface}.
680      */
681     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
682         return
683             interfaceId == type(IERC721).interfaceId ||
684             interfaceId == type(IERC721Metadata).interfaceId ||
685             super.supportsInterface(interfaceId);
686     }
687 
688     /**
689      * @dev See {IERC721-balanceOf}.
690      */
691     function balanceOf(address owner) public view virtual override returns (uint256) {
692         require(owner != address(0), "ERC721: balance query for the zero address");
693         return _balances[owner];
694     }
695 
696     /**
697      * @dev See {IERC721-ownerOf}.
698      */
699     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
700         address owner = _owners[tokenId];
701         require(owner != address(0), "ERC721: owner query for nonexistent token");
702         return owner;
703     }
704 
705     /**
706      * @dev See {IERC721Metadata-name}.
707      */
708     function name() public view virtual override returns (string memory) {
709         return _name;
710     }
711 
712     /**
713      * @dev See {IERC721Metadata-symbol}.
714      */
715     function symbol() public view virtual override returns (string memory) {
716         return _symbol;
717     }
718 
719     /**
720      * @dev See {IERC721Metadata-tokenURI}.
721      */
722     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
723         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
724 
725         string memory baseURI = _baseURI();
726         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
727     }
728 
729     /**
730      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
731      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
732      * by default, can be overridden in child contracts.
733      */
734     function _baseURI() internal view virtual returns (string memory) {
735         return "";
736     }
737 
738     /**
739      * @dev See {IERC721-approve}.
740      */
741     function approve(address to, uint256 tokenId) public virtual override {
742         address owner = ERC721.ownerOf(tokenId);
743         require(to != owner, "ERC721: approval to current owner");
744 
745         require(
746             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
747             "ERC721: approve caller is not owner nor approved for all"
748         );
749 
750         _approve(to, tokenId);
751     }
752 
753     /**
754      * @dev See {IERC721-getApproved}.
755      */
756     function getApproved(uint256 tokenId) public view virtual override returns (address) {
757         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
758 
759         return _tokenApprovals[tokenId];
760     }
761 
762     /**
763      * @dev See {IERC721-setApprovalForAll}.
764      */
765     function setApprovalForAll(address operator, bool approved) public virtual override {
766         _setApprovalForAll(_msgSender(), operator, approved);
767     }
768 
769     /**
770      * @dev See {IERC721-isApprovedForAll}.
771      */
772     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
773         return _operatorApprovals[owner][operator];
774     }
775 
776     /**
777      * @dev See {IERC721-transferFrom}.
778      */
779     function transferFrom(
780         address from,
781         address to,
782         uint256 tokenId
783     ) public virtual override {
784         //solhint-disable-next-line max-line-length
785         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
786 
787         _transfer(from, to, tokenId);
788     }
789 
790     /**
791      * @dev See {IERC721-safeTransferFrom}.
792      */
793     function safeTransferFrom(
794         address from,
795         address to,
796         uint256 tokenId
797     ) public virtual override {
798         safeTransferFrom(from, to, tokenId, "");
799     }
800 
801     /**
802      * @dev See {IERC721-safeTransferFrom}.
803      */
804     function safeTransferFrom(
805         address from,
806         address to,
807         uint256 tokenId,
808         bytes memory _data
809     ) public virtual override {
810         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
811         _safeTransfer(from, to, tokenId, _data);
812     }
813 
814     /**
815      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
816      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
817      *
818      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
819      *
820      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
821      * implement alternative mechanisms to perform token transfer, such as signature-based.
822      *
823      * Requirements:
824      *
825      * - `from` cannot be the zero address.
826      * - `to` cannot be the zero address.
827      * - `tokenId` token must exist and be owned by `from`.
828      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
829      *
830      * Emits a {Transfer} event.
831      */
832     function _safeTransfer(
833         address from,
834         address to,
835         uint256 tokenId,
836         bytes memory _data
837     ) internal virtual {
838         _transfer(from, to, tokenId);
839         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
840     }
841 
842     /**
843      * @dev Returns whether `tokenId` exists.
844      *
845      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
846      *
847      * Tokens start existing when they are minted (`_mint`),
848      * and stop existing when they are burned (`_burn`).
849      */
850     function _exists(uint256 tokenId) internal view virtual returns (bool) {
851         return _owners[tokenId] != address(0);
852     }
853 
854     /**
855      * @dev Returns whether `spender` is allowed to manage `tokenId`.
856      *
857      * Requirements:
858      *
859      * - `tokenId` must exist.
860      */
861     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
862         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
863         address owner = ERC721.ownerOf(tokenId);
864         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
865     }
866 
867     /**
868      * @dev Safely mints `tokenId` and transfers it to `to`.
869      *
870      * Requirements:
871      *
872      * - `tokenId` must not exist.
873      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
874      *
875      * Emits a {Transfer} event.
876      */
877     function _safeMint(address to, uint256 tokenId) internal virtual {
878         _safeMint(to, tokenId, "");
879     }
880 
881     /**
882      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
883      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
884      */
885     function _safeMint(
886         address to,
887         uint256 tokenId,
888         bytes memory _data
889     ) internal virtual {
890         _mint(to, tokenId);
891         require(
892             _checkOnERC721Received(address(0), to, tokenId, _data),
893             "ERC721: transfer to non ERC721Receiver implementer"
894         );
895     }
896 
897     /**
898      * @dev Mints `tokenId` and transfers it to `to`.
899      *
900      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
901      *
902      * Requirements:
903      *
904      * - `tokenId` must not exist.
905      * - `to` cannot be the zero address.
906      *
907      * Emits a {Transfer} event.
908      */
909     function _mint(address to, uint256 tokenId) internal virtual {
910         require(to != address(0), "ERC721: mint to the zero address");
911         require(!_exists(tokenId), "ERC721: token already minted");
912 
913         _beforeTokenTransfer(address(0), to, tokenId);
914 
915         _balances[to] += 1;
916         _owners[tokenId] = to;
917 
918         emit Transfer(address(0), to, tokenId);
919 
920         _afterTokenTransfer(address(0), to, tokenId);
921     }
922 
923     /**
924      * @dev Destroys `tokenId`.
925      * The approval is cleared when the token is burned.
926      *
927      * Requirements:
928      *
929      * - `tokenId` must exist.
930      *
931      * Emits a {Transfer} event.
932      */
933     function _burn(uint256 tokenId) internal virtual {
934         address owner = ERC721.ownerOf(tokenId);
935 
936         _beforeTokenTransfer(owner, address(0), tokenId);
937 
938         // Clear approvals
939         _approve(address(0), tokenId);
940 
941         _balances[owner] -= 1;
942         delete _owners[tokenId];
943 
944         emit Transfer(owner, address(0), tokenId);
945 
946         _afterTokenTransfer(owner, address(0), tokenId);
947     }
948 
949     /**
950      * @dev Transfers `tokenId` from `from` to `to`.
951      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
952      *
953      * Requirements:
954      *
955      * - `to` cannot be the zero address.
956      * - `tokenId` token must be owned by `from`.
957      *
958      * Emits a {Transfer} event.
959      */
960     function _transfer(
961         address from,
962         address to,
963         uint256 tokenId
964     ) internal virtual {
965         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
966         require(to != address(0), "ERC721: transfer to the zero address");
967 
968         _beforeTokenTransfer(from, to, tokenId);
969 
970         // Clear approvals from the previous owner
971         _approve(address(0), tokenId);
972 
973         _balances[from] -= 1;
974         _balances[to] += 1;
975         _owners[tokenId] = to;
976 
977         emit Transfer(from, to, tokenId);
978 
979         _afterTokenTransfer(from, to, tokenId);
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
993      * @dev Approve `operator` to operate on all of `owner` tokens
994      *
995      * Emits a {ApprovalForAll} event.
996      */
997     function _setApprovalForAll(
998         address owner,
999         address operator,
1000         bool approved
1001     ) internal virtual {
1002         require(owner != operator, "ERC721: approve to caller");
1003         _operatorApprovals[owner][operator] = approved;
1004         emit ApprovalForAll(owner, operator, approved);
1005     }
1006 
1007     /**
1008      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1009      * The call is not executed if the target address is not a contract.
1010      *
1011      * @param from address representing the previous owner of the given token ID
1012      * @param to target address that will receive the tokens
1013      * @param tokenId uint256 ID of the token to be transferred
1014      * @param _data bytes optional data to send along with the call
1015      * @return bool whether the call correctly returned the expected magic value
1016      */
1017     function _checkOnERC721Received(
1018         address from,
1019         address to,
1020         uint256 tokenId,
1021         bytes memory _data
1022     ) private returns (bool) {
1023         if (to.isContract()) {
1024             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1025                 return retval == IERC721Receiver.onERC721Received.selector;
1026             } catch (bytes memory reason) {
1027                 if (reason.length == 0) {
1028                     revert("ERC721: transfer to non ERC721Receiver implementer");
1029                 } else {
1030                     assembly {
1031                         revert(add(32, reason), mload(reason))
1032                     }
1033                 }
1034             }
1035         } else {
1036             return true;
1037         }
1038     }
1039 
1040     /**
1041      * @dev Hook that is called before any token transfer. This includes minting
1042      * and burning.
1043      *
1044      * Calling conditions:
1045      *
1046      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1047      * transferred to `to`.
1048      * - When `from` is zero, `tokenId` will be minted for `to`.
1049      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1050      * - `from` and `to` are never both zero.
1051      *
1052      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1053      */
1054     function _beforeTokenTransfer(
1055         address from,
1056         address to,
1057         uint256 tokenId
1058     ) internal virtual {}
1059 
1060     /**
1061      * @dev Hook that is called after any transfer of tokens. This includes
1062      * minting and burning.
1063      *
1064      * Calling conditions:
1065      *
1066      * - when `from` and `to` are both non-zero.
1067      * - `from` and `to` are never both zero.
1068      *
1069      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1070      */
1071     function _afterTokenTransfer(
1072         address from,
1073         address to,
1074         uint256 tokenId
1075     ) internal virtual {}
1076 }
1077 
1078 // File contracts/openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1079 
1080 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1081 
1082 pragma solidity ^0.8.0;
1083 
1084 /**
1085  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1086  * @dev See https://eips.ethereum.org/EIPS/eip-721
1087  */
1088 interface IERC721Enumerable is IERC721 {
1089     /**
1090      * @dev Returns the total amount of tokens stored by the contract.
1091      */
1092     function totalSupply() external view returns (uint256);
1093 
1094     /**
1095      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1096      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1097      */
1098     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1099 
1100     /**
1101      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1102      * Use along with {totalSupply} to enumerate all tokens.
1103      */
1104     function tokenByIndex(uint256 index) external view returns (uint256);
1105 }
1106 
1107 // File contracts/openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1108 
1109 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1110 
1111 pragma solidity ^0.8.0;
1112 
1113 /**
1114  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1115  * enumerability of all the token ids in the contract as well as all token ids owned by each
1116  * account.
1117  */
1118 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1119     // Mapping from owner to list of owned token IDs
1120     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1121 
1122     // Mapping from token ID to index of the owner tokens list
1123     mapping(uint256 => uint256) private _ownedTokensIndex;
1124 
1125     // Array with all token ids, used for enumeration
1126     uint256[] private _allTokens;
1127 
1128     // Mapping from token id to position in the allTokens array
1129     mapping(uint256 => uint256) private _allTokensIndex;
1130 
1131     /**
1132      * @dev See {IERC165-supportsInterface}.
1133      */
1134     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1135         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1136     }
1137 
1138     /**
1139      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1140      */
1141     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1142         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1143         return _ownedTokens[owner][index];
1144     }
1145 
1146     /**
1147      * @dev See {IERC721Enumerable-totalSupply}.
1148      */
1149     function totalSupply() public view virtual override returns (uint256) {
1150         return _allTokens.length;
1151     }
1152 
1153     /**
1154      * @dev See {IERC721Enumerable-tokenByIndex}.
1155      */
1156     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1157         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1158         return _allTokens[index];
1159     }
1160 
1161     /**
1162      * @dev Hook that is called before any token transfer. This includes minting
1163      * and burning.
1164      *
1165      * Calling conditions:
1166      *
1167      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1168      * transferred to `to`.
1169      * - When `from` is zero, `tokenId` will be minted for `to`.
1170      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1171      * - `from` cannot be the zero address.
1172      * - `to` cannot be the zero address.
1173      *
1174      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1175      */
1176     function _beforeTokenTransfer(
1177         address from,
1178         address to,
1179         uint256 tokenId
1180     ) internal virtual override {
1181         super._beforeTokenTransfer(from, to, tokenId);
1182 
1183         if (from == address(0)) {
1184             _addTokenToAllTokensEnumeration(tokenId);
1185         } else if (from != to) {
1186             _removeTokenFromOwnerEnumeration(from, tokenId);
1187         }
1188         if (to == address(0)) {
1189             _removeTokenFromAllTokensEnumeration(tokenId);
1190         } else if (to != from) {
1191             _addTokenToOwnerEnumeration(to, tokenId);
1192         }
1193     }
1194 
1195     /**
1196      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1197      * @param to address representing the new owner of the given token ID
1198      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1199      */
1200     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1201         uint256 length = ERC721.balanceOf(to);
1202         _ownedTokens[to][length] = tokenId;
1203         _ownedTokensIndex[tokenId] = length;
1204     }
1205 
1206     /**
1207      * @dev Private function to add a token to this extension's token tracking data structures.
1208      * @param tokenId uint256 ID of the token to be added to the tokens list
1209      */
1210     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1211         _allTokensIndex[tokenId] = _allTokens.length;
1212         _allTokens.push(tokenId);
1213     }
1214 
1215     /**
1216      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1217      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1218      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1219      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1220      * @param from address representing the previous owner of the given token ID
1221      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1222      */
1223     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1224         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1225         // then delete the last slot (swap and pop).
1226 
1227         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1228         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1229 
1230         // When the token to delete is the last token, the swap operation is unnecessary
1231         if (tokenIndex != lastTokenIndex) {
1232             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1233 
1234             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1235             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1236         }
1237 
1238         // This also deletes the contents at the last position of the array
1239         delete _ownedTokensIndex[tokenId];
1240         delete _ownedTokens[from][lastTokenIndex];
1241     }
1242 
1243     /**
1244      * @dev Private function to remove a token from this extension's token tracking data structures.
1245      * This has O(1) time complexity, but alters the order of the _allTokens array.
1246      * @param tokenId uint256 ID of the token to be removed from the tokens list
1247      */
1248     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1249         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1250         // then delete the last slot (swap and pop).
1251 
1252         uint256 lastTokenIndex = _allTokens.length - 1;
1253         uint256 tokenIndex = _allTokensIndex[tokenId];
1254 
1255         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1256         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1257         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1258         uint256 lastTokenId = _allTokens[lastTokenIndex];
1259 
1260         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1261         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1262 
1263         // This also deletes the contents at the last position of the array
1264         delete _allTokensIndex[tokenId];
1265         _allTokens.pop();
1266     }
1267 }
1268 
1269 // File contracts/openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1270 
1271 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721URIStorage.sol)
1272 
1273 pragma solidity ^0.8.0;
1274 
1275 /**
1276  * @dev ERC721 token with storage based token URI management.
1277  */
1278 abstract contract ERC721URIStorage is ERC721 {
1279     using Strings for uint256;
1280 
1281     // Optional mapping for token URIs
1282     mapping(uint256 => string) private _tokenURIs;
1283 
1284     /**
1285      * @dev See {IERC721Metadata-tokenURI}.
1286      */
1287     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1288         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1289 
1290         string memory _tokenURI = _tokenURIs[tokenId];
1291         string memory base = _baseURI();
1292 
1293         // If there is no base URI, return the token URI.
1294         if (bytes(base).length == 0) {
1295             return _tokenURI;
1296         }
1297         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1298         if (bytes(_tokenURI).length > 0) {
1299             return string(abi.encodePacked(base, _tokenURI));
1300         }
1301 
1302         return super.tokenURI(tokenId);
1303     }
1304 
1305     /**
1306      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1307      *
1308      * Requirements:
1309      *
1310      * - `tokenId` must exist.
1311      */
1312     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1313         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1314         _tokenURIs[tokenId] = _tokenURI;
1315     }
1316 
1317     /**
1318      * @dev Destroys `tokenId`.
1319      * The approval is cleared when the token is burned.
1320      *
1321      * Requirements:
1322      *
1323      * - `tokenId` must exist.
1324      *
1325      * Emits a {Transfer} event.
1326      */
1327     function _burn(uint256 tokenId) internal virtual override {
1328         super._burn(tokenId);
1329 
1330         if (bytes(_tokenURIs[tokenId]).length != 0) {
1331             delete _tokenURIs[tokenId];
1332         }
1333     }
1334 }
1335 
1336 // File contracts/interfaces/IGovernable.sol
1337 
1338 pragma solidity 0.8.9;
1339 
1340 /**
1341  * @notice Governable interface
1342  */
1343 interface IGovernable {
1344     function governor() external view returns (address _governor);
1345 
1346     function transferGovernorship(address _proposedGovernor) external;
1347 }
1348 
1349 // File contracts/interfaces/ICapsuleFactory.sol
1350 
1351 pragma solidity 0.8.9;
1352 
1353 interface ICapsuleFactory is IGovernable {
1354     function capsuleMinter() external view returns (address);
1355 
1356     function createCapsuleCollection(
1357         string memory _name,
1358         string memory _symbol,
1359         address _tokenURIOwner,
1360         bool _isCollectionPrivate
1361     ) external payable returns (address);
1362 
1363     function getAllCapsuleCollections() external view returns (address[] memory);
1364 
1365     function getCapsuleCollectionsOf(address _owner) external view returns (address[] memory);
1366 
1367     function getBlacklist() external view returns (address[] memory);
1368 
1369     function getWhitelist() external view returns (address[] memory);
1370 
1371     function isCapsule(address _capsule) external view returns (bool);
1372 
1373     function isBlacklisted(address _user) external view returns (bool);
1374 
1375     function isWhitelisted(address _user) external view returns (bool);
1376 
1377     function taxCollector() external view returns (address);
1378 
1379     //solhint-disable-next-line func-name-mixedcase
1380     function VERSION() external view returns (string memory);
1381 
1382     // Special permission functions
1383     function addToWhitelist(address _user) external;
1384 
1385     function removeFromWhitelist(address _user) external;
1386 
1387     function addToBlacklist(address _user) external;
1388 
1389     function removeFromBlacklist(address _user) external;
1390 
1391     function flushTaxAmount() external;
1392 
1393     function setCapsuleMinter(address _newCapsuleMinter) external;
1394 
1395     function updateCapsuleCollectionOwner(address _previousOwner, address _newOwner) external;
1396 
1397     function updateCapsuleCollectionTax(uint256 _newTax) external;
1398 
1399     function updateTaxCollector(address _newTaxCollector) external;
1400 }
1401 
1402 // File contracts/openzeppelin/contracts/interfaces/IERC2981.sol
1403 
1404 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1405 
1406 pragma solidity ^0.8.0;
1407 
1408 /**
1409  * @dev Interface for the NFT Royalty Standard.
1410  *
1411  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1412  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1413  *
1414  * _Available since v4.5._
1415  */
1416 interface IERC2981 is IERC165 {
1417     /**
1418      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1419      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1420      */
1421     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1422         external
1423         view
1424         returns (address receiver, uint256 royaltyAmount);
1425 }
1426 
1427 // File contracts/interfaces/ICapsule.sol
1428 
1429 pragma solidity 0.8.9;
1430 
1431 interface ICapsule is IERC721, IERC2981 {
1432     function mint(address account, string memory _uri) external;
1433 
1434     function burn(address owner, uint256 tokenId) external;
1435 
1436     // Read functions
1437     function baseURI() external view returns (string memory);
1438 
1439     function counter() external view returns (uint256);
1440 
1441     function exists(uint256 tokenId) external view returns (bool);
1442 
1443     function isCollectionMinter(address _account) external view returns (bool);
1444 
1445     function maxId() external view returns (uint256);
1446 
1447     function royaltyRate() external view returns (uint256);
1448 
1449     function royaltyReceiver() external view returns (address);
1450 
1451     function tokenURIOwner() external view returns (address);
1452 }
1453 
1454 // File contracts/Capsule.sol
1455 
1456 // SPDX-License-Identifier: BUSL-1.1
1457 
1458 pragma solidity 0.8.9;
1459 
1460 contract Capsule is ERC721URIStorage, ERC721Enumerable, Ownable, ICapsule {
1461     // solhint-disable-next-line var-name-mixedcase
1462     string public VERSION;
1463     string public constant LICENSE = "www.capsulenft.com/license";
1464     ICapsuleFactory public immutable factory;
1465     /// @notice Token URI owner can change token URI of any NFT.
1466     address public tokenURIOwner;
1467     string public baseURI;
1468     uint256 public counter;
1469     /// @notice Max possible NFT id of this collection
1470     uint256 public maxId = type(uint256).max;
1471     /// @notice Flag indicating whether this collection is private.
1472     bool public immutable isCollectionPrivate;
1473     /// @notice Address which can receive NFT royalties using the EIP-2981 standard
1474     address public royaltyReceiver;
1475     /// @notice Percentage amount of royalties (using 2 decimals: 10000 = 100) using the EIP-2981 standard
1476     uint256 public royaltyRate = 0;
1477 
1478     uint256 internal constant MAX_BPS = 10_000; // 100%
1479 
1480     event RoyaltyConfigUpdated(
1481         address indexed oldReceiver,
1482         address indexed newReceiver,
1483         uint256 oldRate,
1484         uint256 newRate
1485     );
1486     event TokenURIOwnerUpdated(address indexed oldOwner, address indexed newOwner);
1487     event TokenURIUpdated(uint256 indexed tokenId, string oldTokenURI, string newTokenURI);
1488     event BaseURIUpdated(string oldBaseURI, string newBaseURI);
1489     event CollectionLocked(uint256 nftCount);
1490 
1491     constructor(
1492         string memory _name,
1493         string memory _symbol,
1494         address _tokenURIOwner,
1495         bool _isCollectionPrivate
1496     ) ERC721(_name, _symbol) {
1497         isCollectionPrivate = _isCollectionPrivate;
1498         factory = ICapsuleFactory(_msgSender());
1499         // Address zero as tokenURIOwner is valid
1500         tokenURIOwner = _tokenURIOwner;
1501         VERSION = ICapsuleFactory(_msgSender()).VERSION();
1502     }
1503 
1504     modifier onlyMinter() {
1505         require(factory.capsuleMinter() == _msgSender(), "!minter");
1506         _;
1507     }
1508 
1509     modifier onlyTokenURIOwner() {
1510         require(tokenURIOwner == _msgSender(), "caller is not tokenURI owner");
1511         _;
1512     }
1513 
1514     /******************************************************************************
1515      *                              Read functions                                *
1516      *****************************************************************************/
1517 
1518     /// @notice Check whether given tokenId exists.
1519     function exists(uint256 tokenId) external view returns (bool) {
1520         return _exists(tokenId);
1521     }
1522 
1523     /// @notice Check if the Capsule collection is locked.
1524     /// @dev This is checked by ensuring the counter is greater than the maxId.
1525     function isCollectionLocked() public view returns (bool) {
1526         return counter > maxId;
1527     }
1528 
1529     /// @notice Check whether given address is owner of this collection.
1530     function isCollectionMinter(address _account) external view returns (bool) {
1531         if (isCollectionPrivate) {
1532             return owner() == _account;
1533         }
1534         return true;
1535     }
1536 
1537     /// @notice Returns tokenURI of given tokenId.
1538     function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
1539         return ERC721URIStorage.tokenURI(tokenId);
1540     }
1541 
1542     /// @inheritdoc IERC2981
1543     function royaltyInfo(uint256, uint256 _salePrice)
1544         external
1545         view
1546         override
1547         returns (address receiver, uint256 royaltyAmount)
1548     {
1549         return (royaltyReceiver, (_salePrice * royaltyRate) / MAX_BPS);
1550     }
1551 
1552     function supportsInterface(bytes4 interfaceId)
1553         public
1554         view
1555         override(IERC165, ERC721, ERC721Enumerable)
1556         returns (bool)
1557     {
1558         return (interfaceId == type(IERC2981).interfaceId || ERC721Enumerable.supportsInterface(interfaceId));
1559     }
1560 
1561     /******************************************************************************
1562      *                             Minter functions                               *
1563      *****************************************************************************/
1564 
1565     /// @notice onlyMinter:: Burn Capsule with given tokenId from given account
1566     function burn(address _account, uint256 _tokenId) external onlyMinter {
1567         require(ERC721.ownerOf(_tokenId) == _account, "not NFT owner");
1568         _burn(_tokenId);
1569     }
1570 
1571     /// @notice onlyMinter:: Mint new Capsule to given account
1572     function mint(address _account, string calldata _uri) external onlyMinter {
1573         require(!isCollectionLocked(), "collection is locked");
1574         _mint(_account, counter);
1575         // If baseURI exists then do not use incoming url.
1576         if (bytes(baseURI).length == 0) {
1577             _setTokenURI(counter, _uri);
1578         }
1579         counter++;
1580     }
1581 
1582     /******************************************************************************
1583      *                             Owner functions                                *
1584      *****************************************************************************/
1585 
1586     /**
1587      * @notice onlyOwner:: Lock collection at provided NFT count (the collection total NFT count),
1588      * preventing any further minting past the given NFT count.
1589      * @dev Max id of this collection will be provided NFT count minus one.
1590      */
1591     function lockCollectionCount(uint256 _nftCount) external virtual onlyOwner {
1592         require(maxId == type(uint256).max, "collection is already locked");
1593         require(_nftCount > 0, "_nftCount is zero");
1594         require(_nftCount >= counter, "_nftCount is less than counter");
1595 
1596         maxId = _nftCount - 1;
1597         emit CollectionLocked(_nftCount);
1598     }
1599 
1600     /// @notice onlyTokenURIOwner:: Set new token URI for given tokenId.
1601     function setTokenURI(uint256 _tokenId, string calldata _newTokenURI) external onlyTokenURIOwner {
1602         emit TokenURIUpdated(_tokenId, tokenURI(_tokenId), _newTokenURI);
1603         _setTokenURI(_tokenId, _newTokenURI);
1604     }
1605 
1606     /// @notice onlyTokenURIOwner:: Set new base URI for the collection.
1607     function setBaseURI(string calldata baseURI_) external onlyTokenURIOwner {
1608         emit BaseURIUpdated(baseURI, baseURI_);
1609         baseURI = baseURI_;
1610     }
1611 
1612     /**
1613      * @notice onlyOwner:: Update royalty receiver and rate.
1614      * @param _royaltyReceiver Address of royalty receiver
1615      * @param _royaltyRate Royalty rate in Basis Points. ie. 100 = 1%, 10_000 = 100%
1616      */
1617     function updateRoyaltyConfig(address _royaltyReceiver, uint256 _royaltyRate) external onlyOwner {
1618         require(_royaltyReceiver != address(0), "Royalty receiver is null");
1619         require(_royaltyRate <= MAX_BPS, "Royalty rate too high");
1620         emit RoyaltyConfigUpdated(royaltyReceiver, _royaltyReceiver, royaltyRate, _royaltyRate);
1621         royaltyReceiver = _royaltyReceiver;
1622         royaltyRate = _royaltyRate;
1623     }
1624 
1625     /// @notice onlyTokenURIOwner:: Update token URI owner.
1626     function updateTokenURIOwner(address _newTokenURIOwner) external onlyTokenURIOwner {
1627         emit TokenURIOwnerUpdated(tokenURIOwner, _newTokenURIOwner);
1628         tokenURIOwner = _newTokenURIOwner;
1629     }
1630 
1631     /// @inheritdoc Ownable
1632     function renounceOwnership() public override onlyOwner {
1633         super.renounceOwnership();
1634         factory.updateCapsuleCollectionOwner(_msgSender(), address(0));
1635     }
1636 
1637     /// @inheritdoc Ownable
1638     function transferOwnership(address _newOwner) public override onlyOwner {
1639         super.transferOwnership(_newOwner);
1640         if (_msgSender() != address(factory)) {
1641             factory.updateCapsuleCollectionOwner(_msgSender(), _newOwner);
1642         }
1643     }
1644 
1645     /******************************************************************************
1646      *                            Internal functions                              *
1647      *****************************************************************************/
1648     function _beforeTokenTransfer(
1649         address from,
1650         address to,
1651         uint256 tokenId
1652     ) internal override(ERC721, ERC721Enumerable) {
1653         ERC721Enumerable._beforeTokenTransfer(from, to, tokenId);
1654     }
1655 
1656     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
1657         ERC721URIStorage._burn(tokenId);
1658     }
1659 
1660     function _baseURI() internal view virtual override returns (string memory) {
1661         return baseURI;
1662     }
1663 }