1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.6;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 /**
27  * @dev Required interface of an ERC721 compliant contract.
28  */
29 interface IERC721 is IERC165 {
30     /**
31      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
32      */
33     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
34 
35     /**
36      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
37      */
38     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
39 
40     /**
41      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
42      */
43     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
44 
45     /**
46      * @dev Returns the number of tokens in ``owner``'s account.
47      */
48     function balanceOf(address owner) external view returns (uint256 balance);
49 
50     /**
51      * @dev Returns the owner of the `tokenId` token.
52      *
53      * Requirements:
54      *
55      * - `tokenId` must exist.
56      */
57     function ownerOf(uint256 tokenId) external view returns (address owner);
58 
59     /**
60      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
61      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
62      *
63      * Requirements:
64      *
65      * - `from` cannot be the zero address.
66      * - `to` cannot be the zero address.
67      * - `tokenId` token must exist and be owned by `from`.
68      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
69      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
70      *
71      * Emits a {Transfer} event.
72      */
73     function safeTransferFrom(
74         address from,
75         address to,
76         uint256 tokenId
77     ) external;
78 
79     /**
80      * @dev Transfers `tokenId` token from `from` to `to`.
81      *
82      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
83      *
84      * Requirements:
85      *
86      * - `from` cannot be the zero address.
87      * - `to` cannot be the zero address.
88      * - `tokenId` token must be owned by `from`.
89      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(
94         address from,
95         address to,
96         uint256 tokenId
97     ) external;
98 
99     /**
100      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
101      * The approval is cleared when the token is transferred.
102      *
103      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
104      *
105      * Requirements:
106      *
107      * - The caller must own the token or be an approved operator.
108      * - `tokenId` must exist.
109      *
110      * Emits an {Approval} event.
111      */
112     function approve(address to, uint256 tokenId) external;
113 
114     /**
115      * @dev Returns the account approved for `tokenId` token.
116      *
117      * Requirements:
118      *
119      * - `tokenId` must exist.
120      */
121     function getApproved(uint256 tokenId) external view returns (address operator);
122 
123     /**
124      * @dev Approve or remove `operator` as an operator for the caller.
125      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
126      *
127      * Requirements:
128      *
129      * - The `operator` cannot be the caller.
130      *
131      * Emits an {ApprovalForAll} event.
132      */
133     function setApprovalForAll(address operator, bool _approved) external;
134 
135     /**
136      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
137      *
138      * See {setApprovalForAll}
139      */
140     function isApprovedForAll(address owner, address operator) external view returns (bool);
141 
142     /**
143      * @dev Safely transfers `tokenId` token from `from` to `to`.
144      *
145      * Requirements:
146      *
147      * - `from` cannot be the zero address.
148      * - `to` cannot be the zero address.
149      * - `tokenId` token must exist and be owned by `from`.
150      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
151      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
152      *
153      * Emits a {Transfer} event.
154      */
155     function safeTransferFrom(
156         address from,
157         address to,
158         uint256 tokenId,
159         bytes calldata data
160     ) external;
161 }
162 
163 /**
164  * @dev String operations.
165  */
166 library Strings {
167     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
168 
169     /**
170      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
171      */
172     function toString(uint256 value) internal pure returns (string memory) {
173         // Inspired by OraclizeAPI's implementation - MIT licence
174         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
175 
176         if (value == 0) {
177             return "0";
178         }
179         uint256 temp = value;
180         uint256 digits;
181         while (temp != 0) {
182             digits++;
183             temp /= 10;
184         }
185         bytes memory buffer = new bytes(digits);
186         while (value != 0) {
187             digits -= 1;
188             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
189             value /= 10;
190         }
191         return string(buffer);
192     }
193 
194     /**
195      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
196      */
197     function toHexString(uint256 value) internal pure returns (string memory) {
198         if (value == 0) {
199             return "0x00";
200         }
201         uint256 temp = value;
202         uint256 length = 0;
203         while (temp != 0) {
204             length++;
205             temp >>= 8;
206         }
207         return toHexString(value, length);
208     }
209 
210     /**
211      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
212      */
213     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
214         bytes memory buffer = new bytes(2 * length + 2);
215         buffer[0] = "0";
216         buffer[1] = "x";
217         for (uint256 i = 2 * length + 1; i > 1; --i) {
218             buffer[i] = _HEX_SYMBOLS[value & 0xf];
219             value >>= 4;
220         }
221         require(value == 0, "Strings: hex length insufficient");
222         return string(buffer);
223     }
224 }
225 
226 /*
227  * @dev Provides information about the current execution context, including the
228  * sender of the transaction and its data. While these are generally available
229  * via msg.sender and msg.data, they should not be accessed in such a direct
230  * manner, since when dealing with meta-transactions the account sending and
231  * paying for execution may not be the actual sender (as far as an application
232  * is concerned).
233  *
234  * This contract is only required for intermediate, library-like contracts.
235  */
236 abstract contract Context {
237     function _msgSender() internal view virtual returns (address) {
238         return msg.sender;
239     }
240 
241     function _msgData() internal view virtual returns (bytes calldata) {
242         return msg.data;
243     }
244 }
245 
246 /**
247  * @dev Contract module which provides a basic access control mechanism, where
248  * there is an account (an owner) that can be granted exclusive access to
249  * specific functions.
250  *
251  * By default, the owner account will be the one that deploys the contract. This
252  * can later be changed with {transferOwnership}.
253  *
254  * This module is used through inheritance. It will make available the modifier
255  * `onlyOwner`, which can be applied to your functions to restrict their use to
256  * the owner.
257  */
258 abstract contract Ownable is Context {
259     address private _owner;
260 
261     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
262 
263     /**
264      * @dev Initializes the contract setting the deployer as the initial owner.
265      */
266     constructor() {
267         _setOwner(_msgSender());
268     }
269 
270     /**
271      * @dev Returns the address of the current owner.
272      */
273     function owner() public view virtual returns (address) {
274         return _owner;
275     }
276 
277     /**
278      * @dev Throws if called by any account other than the owner.
279      */
280     modifier onlyOwner() {
281         require(owner() == _msgSender(), "Ownable: caller is not the owner");
282         _;
283     }
284 
285     /**
286      * @dev Leaves the contract without owner. It will not be possible to call
287      * `onlyOwner` functions anymore. Can only be called by the current owner.
288      *
289      * NOTE: Renouncing ownership will leave the contract without an owner,
290      * thereby removing any functionality that is only available to the owner.
291      */
292     function renounceOwnership() public virtual onlyOwner {
293         _setOwner(address(0));
294     }
295 
296     /**
297      * @dev Transfers ownership of the contract to a new account (`newOwner`).
298      * Can only be called by the current owner.
299      */
300     function transferOwnership(address newOwner) public virtual onlyOwner {
301         require(newOwner != address(0), "Ownable: new owner is the zero address");
302         _setOwner(newOwner);
303     }
304 
305     function _setOwner(address newOwner) private {
306         address oldOwner = _owner;
307         _owner = newOwner;
308         emit OwnershipTransferred(oldOwner, newOwner);
309     }
310 }
311 
312 /**
313  * @dev Contract module that helps prevent reentrant calls to a function.
314  *
315  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
316  * available, which can be applied to functions to make sure there are no nested
317  * (reentrant) calls to them.
318  *
319  * Note that because there is a single `nonReentrant` guard, functions marked as
320  * `nonReentrant` may not call one another. This can be worked around by making
321  * those functions `private`, and then adding `external` `nonReentrant` entry
322  * points to them.
323  *
324  * TIP: If you would like to learn more about reentrancy and alternative ways
325  * to protect against it, check out our blog post
326  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
327  */
328 abstract contract ReentrancyGuard {
329     // Booleans are more expensive than uint256 or any type that takes up a full
330     // word because each write operation emits an extra SLOAD to first read the
331     // slot's contents, replace the bits taken up by the boolean, and then write
332     // back. This is the compiler's defense against contract upgrades and
333     // pointer aliasing, and it cannot be disabled.
334 
335     // The values being non-zero value makes deployment a bit more expensive,
336     // but in exchange the refund on every call to nonReentrant will be lower in
337     // amount. Since refunds are capped to a percentage of the total
338     // transaction's gas, it is best to keep them low in cases like this one, to
339     // increase the likelihood of the full refund coming into effect.
340     uint256 private constant _NOT_ENTERED = 1;
341     uint256 private constant _ENTERED = 2;
342 
343     uint256 private _status;
344 
345     constructor() {
346         _status = _NOT_ENTERED;
347     }
348 
349     /**
350      * @dev Prevents a contract from calling itself, directly or indirectly.
351      * Calling a `nonReentrant` function from another `nonReentrant`
352      * function is not supported. It is possible to prevent this from happening
353      * by making the `nonReentrant` function external, and make it call a
354      * `private` function that does the actual work.
355      */
356     modifier nonReentrant() {
357         // On the first call to nonReentrant, _notEntered will be true
358         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
359 
360         // Any calls to nonReentrant after this point will fail
361         _status = _ENTERED;
362 
363         _;
364 
365         // By storing the original value once again, a refund is triggered (see
366         // https://eips.ethereum.org/EIPS/eip-2200)
367         _status = _NOT_ENTERED;
368     }
369 }
370 
371 /**
372  * @title ERC721 token receiver interface
373  * @dev Interface for any contract that wants to support safeTransfers
374  * from ERC721 asset contracts.
375  */
376 interface IERC721Receiver {
377     /**
378      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
379      * by `operator` from `from`, this function is called.
380      *
381      * It must return its Solidity selector to confirm the token transfer.
382      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
383      *
384      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
385      */
386     function onERC721Received(
387         address operator,
388         address from,
389         uint256 tokenId,
390         bytes calldata data
391     ) external returns (bytes4);
392 }
393 
394 /**
395  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
396  * @dev See https://eips.ethereum.org/EIPS/eip-721
397  */
398 interface IERC721Metadata is IERC721 {
399     /**
400      * @dev Returns the token collection name.
401      */
402     function name() external view returns (string memory);
403 
404     /**
405      * @dev Returns the token collection symbol.
406      */
407     function symbol() external view returns (string memory);
408 
409     /**
410      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
411      */
412     function tokenURI(uint256 tokenId) external view returns (string memory);
413 }
414 
415 /**
416  * @dev Collection of functions related to the address type
417  */
418 library Address {
419     /**
420      * @dev Returns true if `account` is a contract.
421      *
422      * [IMPORTANT]
423      * ====
424      * It is unsafe to assume that an address for which this function returns
425      * false is an externally-owned account (EOA) and not a contract.
426      *
427      * Among others, `isContract` will return false for the following
428      * types of addresses:
429      *
430      *  - an externally-owned account
431      *  - a contract in construction
432      *  - an address where a contract will be created
433      *  - an address where a contract lived, but was destroyed
434      * ====
435      */
436     function isContract(address account) internal view returns (bool) {
437         // This method relies on extcodesize, which returns 0 for contracts in
438         // construction, since the code is only stored at the end of the
439         // constructor execution.
440 
441         uint256 size;
442         assembly {
443             size := extcodesize(account)
444         }
445         return size > 0;
446     }
447 
448     /**
449      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
450      * `recipient`, forwarding all available gas and reverting on errors.
451      *
452      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
453      * of certain opcodes, possibly making contracts go over the 2300 gas limit
454      * imposed by `transfer`, making them unable to receive funds via
455      * `transfer`. {sendValue} removes this limitation.
456      *
457      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
458      *
459      * IMPORTANT: because control is transferred to `recipient`, care must be
460      * taken to not create reentrancy vulnerabilities. Consider using
461      * {ReentrancyGuard} or the
462      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
463      */
464     function sendValue(address payable recipient, uint256 amount) internal {
465         require(address(this).balance >= amount, "Address: insufficient balance");
466 
467         (bool success, ) = recipient.call{value: amount}("");
468         require(success, "Address: unable to send value, recipient may have reverted");
469     }
470 
471     /**
472      * @dev Performs a Solidity function call using a low level `call`. A
473      * plain `call` is an unsafe replacement for a function call: use this
474      * function instead.
475      *
476      * If `target` reverts with a revert reason, it is bubbled up by this
477      * function (like regular Solidity function calls).
478      *
479      * Returns the raw returned data. To convert to the expected return value,
480      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
481      *
482      * Requirements:
483      *
484      * - `target` must be a contract.
485      * - calling `target` with `data` must not revert.
486      *
487      * _Available since v3.1._
488      */
489     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
490         return functionCall(target, data, "Address: low-level call failed");
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
495      * `errorMessage` as a fallback revert reason when `target` reverts.
496      *
497      * _Available since v3.1._
498      */
499     function functionCall(
500         address target,
501         bytes memory data,
502         string memory errorMessage
503     ) internal returns (bytes memory) {
504         return functionCallWithValue(target, data, 0, errorMessage);
505     }
506 
507     /**
508      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
509      * but also transferring `value` wei to `target`.
510      *
511      * Requirements:
512      *
513      * - the calling contract must have an ETH balance of at least `value`.
514      * - the called Solidity function must be `payable`.
515      *
516      * _Available since v3.1._
517      */
518     function functionCallWithValue(
519         address target,
520         bytes memory data,
521         uint256 value
522     ) internal returns (bytes memory) {
523         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
524     }
525 
526     /**
527      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
528      * with `errorMessage` as a fallback revert reason when `target` reverts.
529      *
530      * _Available since v3.1._
531      */
532     function functionCallWithValue(
533         address target,
534         bytes memory data,
535         uint256 value,
536         string memory errorMessage
537     ) internal returns (bytes memory) {
538         require(address(this).balance >= value, "Address: insufficient balance for call");
539         require(isContract(target), "Address: call to non-contract");
540 
541         (bool success, bytes memory returndata) = target.call{value: value}(data);
542         return _verifyCallResult(success, returndata, errorMessage);
543     }
544 
545     /**
546      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
547      * but performing a static call.
548      *
549      * _Available since v3.3._
550      */
551     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
552         return functionStaticCall(target, data, "Address: low-level static call failed");
553     }
554 
555     /**
556      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
557      * but performing a static call.
558      *
559      * _Available since v3.3._
560      */
561     function functionStaticCall(
562         address target,
563         bytes memory data,
564         string memory errorMessage
565     ) internal view returns (bytes memory) {
566         require(isContract(target), "Address: static call to non-contract");
567 
568         (bool success, bytes memory returndata) = target.staticcall(data);
569         return _verifyCallResult(success, returndata, errorMessage);
570     }
571 
572     /**
573      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
574      * but performing a delegate call.
575      *
576      * _Available since v3.4._
577      */
578     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
579         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
580     }
581 
582     /**
583      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
584      * but performing a delegate call.
585      *
586      * _Available since v3.4._
587      */
588     function functionDelegateCall(
589         address target,
590         bytes memory data,
591         string memory errorMessage
592     ) internal returns (bytes memory) {
593         require(isContract(target), "Address: delegate call to non-contract");
594 
595         (bool success, bytes memory returndata) = target.delegatecall(data);
596         return _verifyCallResult(success, returndata, errorMessage);
597     }
598 
599     function _verifyCallResult(
600         bool success,
601         bytes memory returndata,
602         string memory errorMessage
603     ) private pure returns (bytes memory) {
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
622 /**
623  * @dev Implementation of the {IERC165} interface.
624  *
625  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
626  * for the additional interface id that will be supported. For example:
627  *
628  * ```solidity
629  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
630  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
631  * }
632  * ```
633  *
634  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
635  */
636 abstract contract ERC165 is IERC165 {
637     /**
638      * @dev See {IERC165-supportsInterface}.
639      */
640     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
641         return interfaceId == type(IERC165).interfaceId;
642     }
643 }
644 
645 /**
646  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
647  * the Metadata extension, but not including the Enumerable extension, which is available separately as
648  * {ERC721Enumerable}.
649  */
650 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
651     using Address for address;
652     using Strings for uint256;
653 
654     // Token name
655     string private _name;
656 
657     // Token symbol
658     string private _symbol;
659 
660     // Mapping from token ID to owner address
661     mapping(uint256 => address) private _owners;
662 
663     // Mapping owner address to token count
664     mapping(address => uint256) private _balances;
665 
666     // Mapping from token ID to approved address
667     mapping(uint256 => address) private _tokenApprovals;
668 
669     // Mapping from owner to operator approvals
670     mapping(address => mapping(address => bool)) private _operatorApprovals;
671 
672     /**
673      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
674      */
675     constructor(string memory name_, string memory symbol_) {
676         _name = name_;
677         _symbol = symbol_;
678     }
679 
680     /**
681      * @dev See {IERC165-supportsInterface}.
682      */
683     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
684         return
685             interfaceId == type(IERC721).interfaceId ||
686             interfaceId == type(IERC721Metadata).interfaceId ||
687             super.supportsInterface(interfaceId);
688     }
689 
690     /**
691      * @dev See {IERC721-balanceOf}.
692      */
693     function balanceOf(address owner) public view virtual override returns (uint256) {
694         require(owner != address(0), "ERC721: balance query for the zero address");
695         return _balances[owner];
696     }
697 
698     /**
699      * @dev See {IERC721-ownerOf}.
700      */
701     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
702         address owner = _owners[tokenId];
703         require(owner != address(0), "ERC721: owner query for nonexistent token");
704         return owner;
705     }
706 
707     /**
708      * @dev See {IERC721Metadata-name}.
709      */
710     function name() public view virtual override returns (string memory) {
711         return _name;
712     }
713 
714     /**
715      * @dev See {IERC721Metadata-symbol}.
716      */
717     function symbol() public view virtual override returns (string memory) {
718         return _symbol;
719     }
720 
721     /**
722      * @dev See {IERC721Metadata-tokenURI}.
723      */
724     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
725         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
726 
727         string memory baseURI = _baseURI();
728         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
729     }
730 
731     /**
732      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
733      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
734      * by default, can be overriden in child contracts.
735      */
736     function _baseURI() internal view virtual returns (string memory) {
737         return "";
738     }
739 
740     /**
741      * @dev See {IERC721-approve}.
742      */
743     function approve(address to, uint256 tokenId) public virtual override {
744         address owner = ERC721.ownerOf(tokenId);
745         require(to != owner, "ERC721: approval to current owner");
746 
747         require(
748             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
749             "ERC721: approve caller is not owner nor approved for all"
750         );
751 
752         _approve(to, tokenId);
753     }
754 
755     /**
756      * @dev See {IERC721-getApproved}.
757      */
758     function getApproved(uint256 tokenId) public view virtual override returns (address) {
759         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
760 
761         return _tokenApprovals[tokenId];
762     }
763 
764     /**
765      * @dev See {IERC721-setApprovalForAll}.
766      */
767     function setApprovalForAll(address operator, bool approved) public virtual override {
768         require(operator != _msgSender(), "ERC721: approve to caller");
769 
770         _operatorApprovals[_msgSender()][operator] = approved;
771         emit ApprovalForAll(_msgSender(), operator, approved);
772     }
773 
774     /**
775      * @dev See {IERC721-isApprovedForAll}.
776      */
777     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
778         return _operatorApprovals[owner][operator];
779     }
780 
781     /**
782      * @dev See {IERC721-transferFrom}.
783      */
784     function transferFrom(
785         address from,
786         address to,
787         uint256 tokenId
788     ) public virtual override {
789         //solhint-disable-next-line max-line-length
790         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
791 
792         _transfer(from, to, tokenId);
793     }
794 
795     /**
796      * @dev See {IERC721-safeTransferFrom}.
797      */
798     function safeTransferFrom(
799         address from,
800         address to,
801         uint256 tokenId
802     ) public virtual override {
803         safeTransferFrom(from, to, tokenId, "");
804     }
805 
806     /**
807      * @dev See {IERC721-safeTransferFrom}.
808      */
809     function safeTransferFrom(
810         address from,
811         address to,
812         uint256 tokenId,
813         bytes memory _data
814     ) public virtual override {
815         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
816         _safeTransfer(from, to, tokenId, _data);
817     }
818 
819     /**
820      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
821      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
822      *
823      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
824      *
825      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
826      * implement alternative mechanisms to perform token transfer, such as signature-based.
827      *
828      * Requirements:
829      *
830      * - `from` cannot be the zero address.
831      * - `to` cannot be the zero address.
832      * - `tokenId` token must exist and be owned by `from`.
833      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
834      *
835      * Emits a {Transfer} event.
836      */
837     function _safeTransfer(
838         address from,
839         address to,
840         uint256 tokenId,
841         bytes memory _data
842     ) internal virtual {
843         _transfer(from, to, tokenId);
844         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
845     }
846 
847     /**
848      * @dev Returns whether `tokenId` exists.
849      *
850      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
851      *
852      * Tokens start existing when they are minted (`_mint`),
853      * and stop existing when they are burned (`_burn`).
854      */
855     function _exists(uint256 tokenId) internal view virtual returns (bool) {
856         return _owners[tokenId] != address(0);
857     }
858 
859     /**
860      * @dev Returns whether `spender` is allowed to manage `tokenId`.
861      *
862      * Requirements:
863      *
864      * - `tokenId` must exist.
865      */
866     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
867         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
868         address owner = ERC721.ownerOf(tokenId);
869         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
870     }
871 
872     /**
873      * @dev Safely mints `tokenId` and transfers it to `to`.
874      *
875      * Requirements:
876      *
877      * - `tokenId` must not exist.
878      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
879      *
880      * Emits a {Transfer} event.
881      */
882     function _safeMint(address to, uint256 tokenId) internal virtual {
883         _safeMint(to, tokenId, "");
884     }
885 
886     /**
887      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
888      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
889      */
890     function _safeMint(
891         address to,
892         uint256 tokenId,
893         bytes memory _data
894     ) internal virtual {
895         _mint(to, tokenId);
896         require(
897             _checkOnERC721Received(address(0), to, tokenId, _data),
898             "ERC721: transfer to non ERC721Receiver implementer"
899         );
900     }
901 
902     /**
903      * @dev Mints `tokenId` and transfers it to `to`.
904      *
905      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
906      *
907      * Requirements:
908      *
909      * - `tokenId` must not exist.
910      * - `to` cannot be the zero address.
911      *
912      * Emits a {Transfer} event.
913      */
914     function _mint(address to, uint256 tokenId) internal virtual {
915         require(to != address(0), "ERC721: mint to the zero address");
916         require(!_exists(tokenId), "ERC721: token already minted");
917 
918         _beforeTokenTransfer(address(0), to, tokenId);
919 
920         _balances[to] += 1;
921         _owners[tokenId] = to;
922 
923         emit Transfer(address(0), to, tokenId);
924     }
925 
926     /**
927      * @dev Destroys `tokenId`.
928      * The approval is cleared when the token is burned.
929      *
930      * Requirements:
931      *
932      * - `tokenId` must exist.
933      *
934      * Emits a {Transfer} event.
935      */
936     function _burn(uint256 tokenId) internal virtual {
937         address owner = ERC721.ownerOf(tokenId);
938 
939         _beforeTokenTransfer(owner, address(0), tokenId);
940 
941         // Clear approvals
942         _approve(address(0), tokenId);
943 
944         _balances[owner] -= 1;
945         delete _owners[tokenId];
946 
947         emit Transfer(owner, address(0), tokenId);
948     }
949 
950     /**
951      * @dev Transfers `tokenId` from `from` to `to`.
952      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
953      *
954      * Requirements:
955      *
956      * - `to` cannot be the zero address.
957      * - `tokenId` token must be owned by `from`.
958      *
959      * Emits a {Transfer} event.
960      */
961     function _transfer(
962         address from,
963         address to,
964         uint256 tokenId
965     ) internal virtual {
966         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
967         require(to != address(0), "ERC721: transfer to the zero address");
968 
969         _beforeTokenTransfer(from, to, tokenId);
970 
971         // Clear approvals from the previous owner
972         _approve(address(0), tokenId);
973 
974         _balances[from] -= 1;
975         _balances[to] += 1;
976         _owners[tokenId] = to;
977 
978         emit Transfer(from, to, tokenId);
979     }
980 
981     /**
982      * @dev Approve `to` to operate on `tokenId`
983      *
984      * Emits a {Approval} event.
985      */
986     function _approve(address to, uint256 tokenId) internal virtual {
987         _tokenApprovals[tokenId] = to;
988         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
989     }
990 
991     /**
992      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
993      * The call is not executed if the target address is not a contract.
994      *
995      * @param from address representing the previous owner of the given token ID
996      * @param to target address that will receive the tokens
997      * @param tokenId uint256 ID of the token to be transferred
998      * @param _data bytes optional data to send along with the call
999      * @return bool whether the call correctly returned the expected magic value
1000      */
1001     function _checkOnERC721Received(
1002         address from,
1003         address to,
1004         uint256 tokenId,
1005         bytes memory _data
1006     ) private returns (bool) {
1007         if (to.isContract()) {
1008             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1009                 return retval == IERC721Receiver(to).onERC721Received.selector;
1010             } catch (bytes memory reason) {
1011                 if (reason.length == 0) {
1012                     revert("ERC721: transfer to non ERC721Receiver implementer");
1013                 } else {
1014                     assembly {
1015                         revert(add(32, reason), mload(reason))
1016                     }
1017                 }
1018             }
1019         } else {
1020             return true;
1021         }
1022     }
1023 
1024     /**
1025      * @dev Hook that is called before any token transfer. This includes minting
1026      * and burning.
1027      *
1028      * Calling conditions:
1029      *
1030      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1031      * transferred to `to`.
1032      * - When `from` is zero, `tokenId` will be minted for `to`.
1033      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1034      * - `from` and `to` are never both zero.
1035      *
1036      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1037      */
1038     function _beforeTokenTransfer(
1039         address from,
1040         address to,
1041         uint256 tokenId
1042     ) internal virtual {}
1043 }
1044 
1045 /**
1046  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1047  * @dev See https://eips.ethereum.org/EIPS/eip-721
1048  */
1049 interface IERC721Enumerable is IERC721 {
1050     /**
1051      * @dev Returns the total amount of tokens stored by the contract.
1052      */
1053     function totalSupply() external view returns (uint256);
1054 
1055     /**
1056      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1057      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1058      */
1059     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1060 
1061     /**
1062      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1063      * Use along with {totalSupply} to enumerate all tokens.
1064      */
1065     function tokenByIndex(uint256 index) external view returns (uint256);
1066 }
1067 
1068 /**
1069  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1070  * enumerability of all the token ids in the contract as well as all token ids owned by each
1071  * account.
1072  */
1073 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1074     // Mapping from owner to list of owned token IDs
1075     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1076 
1077     // Mapping from token ID to index of the owner tokens list
1078     mapping(uint256 => uint256) private _ownedTokensIndex;
1079 
1080     // Array with all token ids, used for enumeration
1081     uint256[] private _allTokens;
1082 
1083     // Mapping from token id to position in the allTokens array
1084     mapping(uint256 => uint256) private _allTokensIndex;
1085 
1086     /**
1087      * @dev See {IERC165-supportsInterface}.
1088      */
1089     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1090         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1091     }
1092 
1093     /**
1094      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1095      */
1096     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1097         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1098         return _ownedTokens[owner][index];
1099     }
1100 
1101     /**
1102      * @dev See {IERC721Enumerable-totalSupply}.
1103      */
1104     function totalSupply() public view virtual override returns (uint256) {
1105         return _allTokens.length;
1106     }
1107 
1108     /**
1109      * @dev See {IERC721Enumerable-tokenByIndex}.
1110      */
1111     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1112         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1113         return _allTokens[index];
1114     }
1115 
1116     /**
1117      * @dev Hook that is called before any token transfer. This includes minting
1118      * and burning.
1119      *
1120      * Calling conditions:
1121      *
1122      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1123      * transferred to `to`.
1124      * - When `from` is zero, `tokenId` will be minted for `to`.
1125      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1126      * - `from` cannot be the zero address.
1127      * - `to` cannot be the zero address.
1128      *
1129      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1130      */
1131     function _beforeTokenTransfer(
1132         address from,
1133         address to,
1134         uint256 tokenId
1135     ) internal virtual override {
1136         super._beforeTokenTransfer(from, to, tokenId);
1137 
1138         if (from == address(0)) {
1139             _addTokenToAllTokensEnumeration(tokenId);
1140         } else if (from != to) {
1141             _removeTokenFromOwnerEnumeration(from, tokenId);
1142         }
1143         if (to == address(0)) {
1144             _removeTokenFromAllTokensEnumeration(tokenId);
1145         } else if (to != from) {
1146             _addTokenToOwnerEnumeration(to, tokenId);
1147         }
1148     }
1149 
1150     /**
1151      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1152      * @param to address representing the new owner of the given token ID
1153      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1154      */
1155     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1156         uint256 length = ERC721.balanceOf(to);
1157         _ownedTokens[to][length] = tokenId;
1158         _ownedTokensIndex[tokenId] = length;
1159     }
1160 
1161     /**
1162      * @dev Private function to add a token to this extension's token tracking data structures.
1163      * @param tokenId uint256 ID of the token to be added to the tokens list
1164      */
1165     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1166         _allTokensIndex[tokenId] = _allTokens.length;
1167         _allTokens.push(tokenId);
1168     }
1169 
1170     /**
1171      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1172      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1173      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1174      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1175      * @param from address representing the previous owner of the given token ID
1176      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1177      */
1178     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1179         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1180         // then delete the last slot (swap and pop).
1181 
1182         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1183         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1184 
1185         // When the token to delete is the last token, the swap operation is unnecessary
1186         if (tokenIndex != lastTokenIndex) {
1187             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1188 
1189             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1190             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1191         }
1192 
1193         // This also deletes the contents at the last position of the array
1194         delete _ownedTokensIndex[tokenId];
1195         delete _ownedTokens[from][lastTokenIndex];
1196     }
1197 
1198     /**
1199      * @dev Private function to remove a token from this extension's token tracking data structures.
1200      * This has O(1) time complexity, but alters the order of the _allTokens array.
1201      * @param tokenId uint256 ID of the token to be removed from the tokens list
1202      */
1203     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1204         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1205         // then delete the last slot (swap and pop).
1206 
1207         uint256 lastTokenIndex = _allTokens.length - 1;
1208         uint256 tokenIndex = _allTokensIndex[tokenId];
1209 
1210         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1211         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1212         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1213         uint256 lastTokenId = _allTokens[lastTokenIndex];
1214 
1215         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1216         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1217 
1218         // This also deletes the contents at the last position of the array
1219         delete _allTokensIndex[tokenId];
1220         _allTokens.pop();
1221     }
1222 }
1223 
1224 contract Glitch is ERC721Enumerable, ReentrancyGuard, Ownable {
1225     address[] public requiredNfts;
1226 
1227     bool private constant onlyNftHolders = true;
1228     uint private ownerMintAmount = 188;
1229     uint private constant nftHolderTimeout = 45 minutes;
1230 
1231     uint public immutable deployedTime;
1232 
1233     string[] private morseCodes = [
1234     "|||||",
1235     "-||||",
1236     "--|||",
1237     "---||",
1238     "----|",
1239     "-----",
1240     "|----",
1241     "||---",
1242     "|||--",
1243     "||||-"
1244     ];
1245 
1246 
1247     uint8[] private units = [
1248         1,
1249         2,
1250         3,
1251         4,
1252         5,
1253         6,
1254         7,
1255         8,
1256         9,
1257         1,
1258         2,
1259         3,
1260         4,
1261         5,
1262         6,
1263         7,
1264         8,
1265         9,
1266         1,
1267         2,
1268         3,
1269         4,
1270         5,
1271         6,
1272         7,
1273         8,
1274         9,
1275         1,
1276         2,
1277         3,
1278         4,
1279         5,
1280         6,
1281         7,
1282         8,
1283         9,
1284         10
1285     ];
1286 
1287     uint8[] private multipliers = [
1288         1,
1289         1,
1290         1,
1291         1,
1292         1,
1293         1,
1294         1,
1295         1,
1296         1,
1297         1,
1298         1,
1299         1,
1300         1,
1301         1,
1302         1,
1303         1,
1304         1,
1305         1,
1306         1,
1307         1,
1308         1,
1309         1,
1310         1,
1311         1,
1312         1,
1313         1,
1314         1,
1315         1,
1316         1,
1317         1,
1318         1,
1319         1,
1320         1,
1321         1,
1322         1,
1323         1,
1324         1,
1325         1,
1326         1,
1327         1,
1328         1,
1329         1,
1330         1,
1331         1,
1332         1,
1333         1,
1334         1,
1335         1,
1336         1,
1337         1,
1338         1,
1339         1,
1340         1,
1341         1,
1342         1,
1343         1,
1344         1,
1345         1,
1346         1,
1347         1,
1348         1,
1349         1,
1350         1,
1351         1,
1352         1,
1353         1,
1354         1,
1355         1,
1356         1,
1357         1,
1358         1,
1359         1,
1360         1,
1361         1,
1362         1,
1363         1,
1364         1,
1365         1,
1366         1,
1367         1,
1368         1,
1369         1,
1370         1,
1371         1,
1372         1,
1373         1,
1374         1,
1375         0
1376     ];
1377 
1378     uint8[] private suffixes = [1, 2];
1379 
1380     function addRequiredNft(address _nft) external onlyOwner {
1381         requiredNfts.push(_nft);
1382     }
1383 
1384     function removeRequiredNft(uint256 _idx) external onlyOwner {
1385         requiredNfts[_idx] = requiredNfts[requiredNfts.length - 1];
1386         requiredNfts.pop();
1387     }
1388 
1389     function random(string memory input) internal pure returns (uint256) {
1390         return uint256(keccak256(abi.encodePacked(input)));
1391     }
1392 
1393     function getFirst(uint256 tokenId) public view returns (uint256) {
1394         return pluck(tokenId, "FIRST", units);
1395     }
1396 
1397     function getSecond(uint256 tokenId) public view returns (uint256) {
1398         return pluck(tokenId, "SECOND", units);
1399     }
1400 
1401     function getThird(uint256 tokenId) public view returns (uint256) {
1402         return pluck(tokenId, "THIRD", units);
1403     }
1404 
1405     function getFourth(uint256 tokenId) public view returns (uint256) {
1406         return pluck(tokenId, "FOURTH", units);
1407     }
1408 
1409     function getFifth(uint256 tokenId) public view returns (uint256) {
1410         return pluck(tokenId, "FIFTH", units);
1411     }
1412 
1413     function getSixth(uint256 tokenId) public view returns (uint256) {
1414         return pluck(tokenId, "SIXTH", units);
1415     }
1416 
1417     function getSeventh(uint256 tokenId) public view returns (uint256) {
1418         return pluck(tokenId, "SEVENTH", units);
1419     }
1420 
1421     function getEight(uint256 tokenId) public view returns (uint256) {
1422         return pluck(tokenId, "EIGHT", units);
1423     }
1424 
1425     function pluck(
1426         uint256 tokenId,
1427         string memory keyPrefix,
1428         uint8[] memory sourceArray
1429     ) internal view returns (uint256) {
1430         uint256 rand = random(string(abi.encodePacked(keyPrefix, toString(tokenId))));
1431         uint256 output = sourceArray[rand % sourceArray.length];
1432         uint256 luck = rand % 21;
1433         if (luck > 14) {
1434             output += suffixes[rand % suffixes.length];
1435         }
1436         if (luck >= 19) {
1437             if (luck == 19) {
1438                 output = (output * multipliers[rand % multipliers.length]) + suffixes[rand % suffixes.length];
1439             } else {
1440                 output = (output * multipliers[rand % multipliers.length]);
1441             }
1442         }
1443         return output;
1444     }
1445 
1446     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1447         string[17] memory parts;
1448         parts[
1449             0
1450           ] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"> <style>.glow { fill: #01ff01; font-family: serif; font-size:69px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="60" class="glow">';
1451         
1452         
1453 
1454         parts[1] = toMorse(getFirst(tokenId));
1455 
1456         parts[2] = '</text><text x="10" y="100" class="glow">';
1457 
1458         parts[3] = toMorse(getSecond(tokenId));
1459 
1460         parts[4] = '</text><text x="10" y="140" class="glow">';
1461 
1462         parts[5] = toMorse(getThird(tokenId));
1463 
1464         parts[6] = '</text><text x="10" y="180" class="glow">';
1465 
1466         parts[7] = toMorse(getFourth(tokenId));
1467 
1468         parts[8] = '</text><text x="10" y="220" class="glow">';
1469 
1470         parts[9] = toMorse(getFifth(tokenId));
1471 
1472         parts[10] = '</text><text x="10" y="260" class="glow">';
1473 
1474         parts[11] = toMorse(getSixth(tokenId));
1475 
1476         parts[12] = '</text><text x="10" y="300" class="glow">';
1477 
1478         parts[13] = toMorse(getSeventh(tokenId));
1479 
1480         parts[14] = '</text><text x="10" y="340" class="glow">';
1481 
1482         parts[15] = toMorse(getEight(tokenId));
1483 
1484         parts[16] = "</text></svg>";
1485 
1486         string memory output = string(
1487             abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8])
1488         );
1489         output = string(
1490             abi.encodePacked(
1491                 output,
1492                 parts[9],
1493                 parts[10],
1494                 parts[11],
1495                 parts[12],
1496                 parts[13],
1497                 parts[14],
1498                 parts[15],
1499                 parts[16]
1500             )
1501         );
1502 
1503         string memory json = Base64.encode(
1504             bytes(
1505                 string(
1506                     abi.encodePacked(
1507                         '{"name": "Glitch #',
1508                         toString(tokenId),
1509                         '", "description": "Is this reality in fact a simulation? A call... A routine... A bond... A dream... The subconscious instinct senses glitches in the matrix. Feel free to use the powers of your Glitch in any way you wish. What messages will you receive?", "image": "data:image/svg+xml;base64,',
1510                         Base64.encode(bytes(output)),
1511                         '"}'
1512                     )
1513                 )
1514             )
1515         );
1516         output = string(abi.encodePacked("data:application/json;base64,", json));
1517 
1518         return output;
1519     }
1520 
1521     function claim(uint256 tokenId) public nonReentrant {
1522         require(tokenId > 0 && tokenId < 8889, "Token ID invalid");
1523         require(totalSupply() + ownerMintAmount < 8889, "No available NFT");
1524         if (onlyNftHolders && block.timestamp <= deployedTime + nftHolderTimeout) {
1525             bool canClaim = false;
1526             for (uint256 i = 0; i < requiredNfts.length; i += 1) {
1527                 if (IERC721(requiredNfts[i]).balanceOf(msg.sender) > 0) {
1528                     canClaim = true;
1529                     break;
1530                 }
1531             }
1532             require(canClaim, "Cannot claim");
1533         }
1534         _safeMint(_msgSender(), tokenId);
1535     }
1536 
1537     function ownerClaim(uint256 tokenId) external onlyOwner {
1538         require(tokenId > 0 && tokenId < 8889, "Token ID invalid");
1539         require(ownerMintAmount > 0, "No available Owner NFT");
1540         _safeMint(_msgSender(), tokenId);
1541         ownerMintAmount --;
1542     }
1543 
1544     function toString(uint256 value) internal pure returns (string memory) {
1545         // Inspired by OraclizeAPI's implementation - MIT license
1546         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1547 
1548         if (value == 0) {
1549             return "0";
1550         }
1551         uint256 temp = value;
1552         uint256 digits;
1553         while (temp != 0) {
1554             digits++;
1555             temp /= 10;
1556         }
1557         bytes memory buffer = new bytes(digits);
1558         while (value != 0) {
1559             digits -= 1;
1560             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1561             value /= 10;
1562         }
1563         return string(buffer);
1564     }
1565 
1566     function toMorse(uint256 value) internal view returns (string memory) {
1567         if (value < 10) {
1568             return morseCodes[value];
1569         }
1570         uint256 temp = value;
1571         uint256 digits;
1572 
1573         while (temp != 0) {
1574             digits++;
1575             temp /= 10;
1576         }
1577         string memory res = "";
1578         while (value != 0) {
1579             digits -= 1;
1580             res = string(abi.encodePacked(morseCodes[value % 10], res));
1581             value /= 10;
1582         }
1583         return res;
1584     }
1585 
1586     constructor() ERC721("Glitch", "GLITCH") Ownable() {
1587         deployedTime = block.timestamp;
1588         requiredNfts.push(0x4F8730E0b32B04beaa5757e5aea3aeF970E5B613);
1589         requiredNfts.push(0xb2c02e550ad5845831D03aA38155FeE26931d33E);
1590         requiredNfts.push(0x3213e943a875C7B943608e990A91924692AB7494);
1591     }
1592 }
1593 
1594 /// [MIT License]
1595 /// @title Base64
1596 /// @notice Provides a function for encoding some bytes in base64
1597 /// @author Brecht Devos <brecht@loopring.org>
1598 library Base64 {
1599     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1600 
1601     /// @notice Encodes some bytes to the base64 representation
1602     function encode(bytes memory data) internal pure returns (string memory) {
1603         uint256 len = data.length;
1604         if (len == 0) return "";
1605 
1606         // multiply by 4/3 rounded up
1607         uint256 encodedLen = 4 * ((len + 2) / 3);
1608 
1609         // Add some extra buffer at the end
1610         bytes memory result = new bytes(encodedLen + 32);
1611 
1612         bytes memory table = TABLE;
1613 
1614         assembly {
1615             let tablePtr := add(table, 1)
1616             let resultPtr := add(result, 32)
1617 
1618             for {
1619                 let i := 0
1620             } lt(i, len) {
1621 
1622             } {
1623                 i := add(i, 3)
1624                 let input := and(mload(add(data, i)), 0xffffff)
1625 
1626                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
1627                 out := shl(8, out)
1628                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
1629                 out := shl(8, out)
1630                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
1631                 out := shl(8, out)
1632                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
1633                 out := shl(224, out)
1634 
1635                 mstore(resultPtr, out)
1636 
1637                 resultPtr := add(resultPtr, 4)
1638             }
1639 
1640             switch mod(len, 3)
1641             case 1 {
1642                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1643             }
1644             case 2 {
1645                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
1646             }
1647 
1648             mstore(result, encodedLen)
1649         }
1650 
1651         return string(result);
1652     }
1653 }