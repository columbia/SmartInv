1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
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
371 
372 /**
373  * @title ERC721 token receiver interface
374  * @dev Interface for any contract that wants to support safeTransfers
375  * from ERC721 asset contracts.
376  */
377 interface IERC721Receiver {
378     /**
379      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
380      * by `operator` from `from`, this function is called.
381      *
382      * It must return its Solidity selector to confirm the token transfer.
383      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
384      *
385      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
386      */
387     function onERC721Received(
388         address operator,
389         address from,
390         uint256 tokenId,
391         bytes calldata data
392     ) external returns (bytes4);
393 }
394 
395 /**
396  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
397  * @dev See https://eips.ethereum.org/EIPS/eip-721
398  */
399 interface IERC721Metadata is IERC721 {
400     /**
401      * @dev Returns the token collection name.
402      */
403     function name() external view returns (string memory);
404 
405     /**
406      * @dev Returns the token collection symbol.
407      */
408     function symbol() external view returns (string memory);
409 
410     /**
411      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
412      */
413     function tokenURI(uint256 tokenId) external view returns (string memory);
414 }
415 
416 /**
417  * @dev Collection of functions related to the address type
418  */
419 library Address {
420     /**
421      * @dev Returns true if `account` is a contract.
422      *
423      * [IMPORTANT]
424      * ====
425      * It is unsafe to assume that an address for which this function returns
426      * false is an externally-owned account (EOA) and not a contract.
427      *
428      * Among others, `isContract` will return false for the following
429      * types of addresses:
430      *
431      *  - an externally-owned account
432      *  - a contract in construction
433      *  - an address where a contract will be created
434      *  - an address where a contract lived, but was destroyed
435      * ====
436      */
437     function isContract(address account) internal view returns (bool) {
438         // This method relies on extcodesize, which returns 0 for contracts in
439         // construction, since the code is only stored at the end of the
440         // constructor execution.
441 
442         uint256 size;
443         assembly {
444             size := extcodesize(account)
445         }
446         return size > 0;
447     }
448 
449     /**
450      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
451      * `recipient`, forwarding all available gas and reverting on errors.
452      *
453      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
454      * of certain opcodes, possibly making contracts go over the 2300 gas limit
455      * imposed by `transfer`, making them unable to receive funds via
456      * `transfer`. {sendValue} removes this limitation.
457      *
458      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
459      *
460      * IMPORTANT: because control is transferred to `recipient`, care must be
461      * taken to not create reentrancy vulnerabilities. Consider using
462      * {ReentrancyGuard} or the
463      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
464      */
465     function sendValue(address payable recipient, uint256 amount) internal {
466         require(address(this).balance >= amount, "Address: insufficient balance");
467 
468         (bool success, ) = recipient.call{value: amount}("");
469         require(success, "Address: unable to send value, recipient may have reverted");
470     }
471 
472     /**
473      * @dev Performs a Solidity function call using a low level `call`. A
474      * plain `call` is an unsafe replacement for a function call: use this
475      * function instead.
476      *
477      * If `target` reverts with a revert reason, it is bubbled up by this
478      * function (like regular Solidity function calls).
479      *
480      * Returns the raw returned data. To convert to the expected return value,
481      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
482      *
483      * Requirements:
484      *
485      * - `target` must be a contract.
486      * - calling `target` with `data` must not revert.
487      *
488      * _Available since v3.1._
489      */
490     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
491         return functionCall(target, data, "Address: low-level call failed");
492     }
493 
494     /**
495      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
496      * `errorMessage` as a fallback revert reason when `target` reverts.
497      *
498      * _Available since v3.1._
499      */
500     function functionCall(
501         address target,
502         bytes memory data,
503         string memory errorMessage
504     ) internal returns (bytes memory) {
505         return functionCallWithValue(target, data, 0, errorMessage);
506     }
507 
508     /**
509      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
510      * but also transferring `value` wei to `target`.
511      *
512      * Requirements:
513      *
514      * - the calling contract must have an ETH balance of at least `value`.
515      * - the called Solidity function must be `payable`.
516      *
517      * _Available since v3.1._
518      */
519     function functionCallWithValue(
520         address target,
521         bytes memory data,
522         uint256 value
523     ) internal returns (bytes memory) {
524         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
525     }
526 
527     /**
528      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
529      * with `errorMessage` as a fallback revert reason when `target` reverts.
530      *
531      * _Available since v3.1._
532      */
533     function functionCallWithValue(
534         address target,
535         bytes memory data,
536         uint256 value,
537         string memory errorMessage
538     ) internal returns (bytes memory) {
539         require(address(this).balance >= value, "Address: insufficient balance for call");
540         require(isContract(target), "Address: call to non-contract");
541 
542         (bool success, bytes memory returndata) = target.call{value: value}(data);
543         return _verifyCallResult(success, returndata, errorMessage);
544     }
545 
546     /**
547      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
548      * but performing a static call.
549      *
550      * _Available since v3.3._
551      */
552     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
553         return functionStaticCall(target, data, "Address: low-level static call failed");
554     }
555 
556     /**
557      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
558      * but performing a static call.
559      *
560      * _Available since v3.3._
561      */
562     function functionStaticCall(
563         address target,
564         bytes memory data,
565         string memory errorMessage
566     ) internal view returns (bytes memory) {
567         require(isContract(target), "Address: static call to non-contract");
568 
569         (bool success, bytes memory returndata) = target.staticcall(data);
570         return _verifyCallResult(success, returndata, errorMessage);
571     }
572 
573     /**
574      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
575      * but performing a delegate call.
576      *
577      * _Available since v3.4._
578      */
579     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
580         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
581     }
582 
583     /**
584      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
585      * but performing a delegate call.
586      *
587      * _Available since v3.4._
588      */
589     function functionDelegateCall(
590         address target,
591         bytes memory data,
592         string memory errorMessage
593     ) internal returns (bytes memory) {
594         require(isContract(target), "Address: delegate call to non-contract");
595 
596         (bool success, bytes memory returndata) = target.delegatecall(data);
597         return _verifyCallResult(success, returndata, errorMessage);
598     }
599 
600     function _verifyCallResult(
601         bool success,
602         bytes memory returndata,
603         string memory errorMessage
604     ) private pure returns (bytes memory) {
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
623 /**
624  * @dev Implementation of the {IERC165} interface.
625  *
626  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
627  * for the additional interface id that will be supported. For example:
628  *
629  * ```solidity
630  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
631  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
632  * }
633  * ```
634  *
635  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
636  */
637 abstract contract ERC165 is IERC165 {
638     /**
639      * @dev See {IERC165-supportsInterface}.
640      */
641     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
642         return interfaceId == type(IERC165).interfaceId;
643     }
644 }
645 
646 /**
647  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
648  * the Metadata extension, but not including the Enumerable extension, which is available separately as
649  * {ERC721Enumerable}.
650  */
651 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
652     using Address for address;
653     using Strings for uint256;
654 
655     // Token name
656     string private _name;
657 
658     // Token symbol
659     string private _symbol;
660 
661     // Mapping from token ID to owner address
662     mapping(uint256 => address) private _owners;
663 
664     // Mapping owner address to token count
665     mapping(address => uint256) private _balances;
666 
667     // Mapping from token ID to approved address
668     mapping(uint256 => address) private _tokenApprovals;
669 
670     // Mapping from owner to operator approvals
671     mapping(address => mapping(address => bool)) private _operatorApprovals;
672 
673     /**
674      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
675      */
676     constructor(string memory name_, string memory symbol_) {
677         _name = name_;
678         _symbol = symbol_;
679     }
680 
681     /**
682      * @dev See {IERC165-supportsInterface}.
683      */
684     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
685         return
686             interfaceId == type(IERC721).interfaceId ||
687             interfaceId == type(IERC721Metadata).interfaceId ||
688             super.supportsInterface(interfaceId);
689     }
690 
691     /**
692      * @dev See {IERC721-balanceOf}.
693      */
694     function balanceOf(address owner) public view virtual override returns (uint256) {
695         require(owner != address(0), "ERC721: balance query for the zero address");
696         return _balances[owner];
697     }
698 
699     /**
700      * @dev See {IERC721-ownerOf}.
701      */
702     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
703         address owner = _owners[tokenId];
704         require(owner != address(0), "ERC721: owner query for nonexistent token");
705         return owner;
706     }
707 
708     /**
709      * @dev See {IERC721Metadata-name}.
710      */
711     function name() public view virtual override returns (string memory) {
712         return _name;
713     }
714 
715     /**
716      * @dev See {IERC721Metadata-symbol}.
717      */
718     function symbol() public view virtual override returns (string memory) {
719         return _symbol;
720     }
721 
722     /**
723      * @dev See {IERC721Metadata-tokenURI}.
724      */
725     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
726         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
727 
728         string memory baseURI = _baseURI();
729         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
730     }
731 
732     /**
733      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
734      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
735      * by default, can be overriden in child contracts.
736      */
737     function _baseURI() internal view virtual returns (string memory) {
738         return "";
739     }
740 
741     /**
742      * @dev See {IERC721-approve}.
743      */
744     function approve(address to, uint256 tokenId) public virtual override {
745         address owner = ERC721.ownerOf(tokenId);
746         require(to != owner, "ERC721: approval to current owner");
747 
748         require(
749             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
750             "ERC721: approve caller is not owner nor approved for all"
751         );
752 
753         _approve(to, tokenId);
754     }
755 
756     /**
757      * @dev See {IERC721-getApproved}.
758      */
759     function getApproved(uint256 tokenId) public view virtual override returns (address) {
760         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
761 
762         return _tokenApprovals[tokenId];
763     }
764 
765     /**
766      * @dev See {IERC721-setApprovalForAll}.
767      */
768     function setApprovalForAll(address operator, bool approved) public virtual override {
769         require(operator != _msgSender(), "ERC721: approve to caller");
770 
771         _operatorApprovals[_msgSender()][operator] = approved;
772         emit ApprovalForAll(_msgSender(), operator, approved);
773     }
774 
775     /**
776      * @dev See {IERC721-isApprovedForAll}.
777      */
778     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
779         return _operatorApprovals[owner][operator];
780     }
781 
782     /**
783      * @dev See {IERC721-transferFrom}.
784      */
785     function transferFrom(
786         address from,
787         address to,
788         uint256 tokenId
789     ) public virtual override {
790         //solhint-disable-next-line max-line-length
791         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
792 
793         _transfer(from, to, tokenId);
794     }
795 
796     /**
797      * @dev See {IERC721-safeTransferFrom}.
798      */
799     function safeTransferFrom(
800         address from,
801         address to,
802         uint256 tokenId
803     ) public virtual override {
804         safeTransferFrom(from, to, tokenId, "");
805     }
806 
807     /**
808      * @dev See {IERC721-safeTransferFrom}.
809      */
810     function safeTransferFrom(
811         address from,
812         address to,
813         uint256 tokenId,
814         bytes memory _data
815     ) public virtual override {
816         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
817         _safeTransfer(from, to, tokenId, _data);
818     }
819 
820     /**
821      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
822      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
823      *
824      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
825      *
826      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
827      * implement alternative mechanisms to perform token transfer, such as signature-based.
828      *
829      * Requirements:
830      *
831      * - `from` cannot be the zero address.
832      * - `to` cannot be the zero address.
833      * - `tokenId` token must exist and be owned by `from`.
834      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
835      *
836      * Emits a {Transfer} event.
837      */
838     function _safeTransfer(
839         address from,
840         address to,
841         uint256 tokenId,
842         bytes memory _data
843     ) internal virtual {
844         _transfer(from, to, tokenId);
845         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
846     }
847 
848     /**
849      * @dev Returns whether `tokenId` exists.
850      *
851      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
852      *
853      * Tokens start existing when they are minted (`_mint`),
854      * and stop existing when they are burned (`_burn`).
855      */
856     function _exists(uint256 tokenId) internal view virtual returns (bool) {
857         return _owners[tokenId] != address(0);
858     }
859 
860     /**
861      * @dev Returns whether `spender` is allowed to manage `tokenId`.
862      *
863      * Requirements:
864      *
865      * - `tokenId` must exist.
866      */
867     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
868         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
869         address owner = ERC721.ownerOf(tokenId);
870         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
871     }
872 
873     /**
874      * @dev Safely mints `tokenId` and transfers it to `to`.
875      *
876      * Requirements:
877      *
878      * - `tokenId` must not exist.
879      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
880      *
881      * Emits a {Transfer} event.
882      */
883     function _safeMint(address to, uint256 tokenId) internal virtual {
884         _safeMint(to, tokenId, "");
885     }
886 
887     /**
888      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
889      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
890      */
891     function _safeMint(
892         address to,
893         uint256 tokenId,
894         bytes memory _data
895     ) internal virtual {
896         _mint(to, tokenId);
897         require(
898             _checkOnERC721Received(address(0), to, tokenId, _data),
899             "ERC721: transfer to non ERC721Receiver implementer"
900         );
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
1010                 return retval == IERC721Receiver(to).onERC721Received.selector;
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
1046 /**
1047  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1048  * @dev See https://eips.ethereum.org/EIPS/eip-721
1049  */
1050 interface IERC721Enumerable is IERC721 {
1051     /**
1052      * @dev Returns the total amount of tokens stored by the contract.
1053      */
1054     function totalSupply() external view returns (uint256);
1055 
1056     /**
1057      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1058      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1059      */
1060     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1061 
1062     /**
1063      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1064      * Use along with {totalSupply} to enumerate all tokens.
1065      */
1066     function tokenByIndex(uint256 index) external view returns (uint256);
1067 }
1068 
1069 
1070 /**
1071  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1072  * enumerability of all the token ids in the contract as well as all token ids owned by each
1073  * account.
1074  */
1075 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1076     // Mapping from owner to list of owned token IDs
1077     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1078 
1079     // Mapping from token ID to index of the owner tokens list
1080     mapping(uint256 => uint256) private _ownedTokensIndex;
1081 
1082     // Array with all token ids, used for enumeration
1083     uint256[] private _allTokens;
1084 
1085     // Mapping from token id to position in the allTokens array
1086     mapping(uint256 => uint256) private _allTokensIndex;
1087 
1088     /**
1089      * @dev See {IERC165-supportsInterface}.
1090      */
1091     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1092         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1093     }
1094 
1095     /**
1096      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1097      */
1098     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1099         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1100         return _ownedTokens[owner][index];
1101     }
1102 
1103     /**
1104      * @dev See {IERC721Enumerable-totalSupply}.
1105      */
1106     function totalSupply() public view virtual override returns (uint256) {
1107         return _allTokens.length;
1108     }
1109 
1110     /**
1111      * @dev See {IERC721Enumerable-tokenByIndex}.
1112      */
1113     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1114         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1115         return _allTokens[index];
1116     }
1117 
1118     /**
1119      * @dev Hook that is called before any token transfer. This includes minting
1120      * and burning.
1121      *
1122      * Calling conditions:
1123      *
1124      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1125      * transferred to `to`.
1126      * - When `from` is zero, `tokenId` will be minted for `to`.
1127      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1128      * - `from` cannot be the zero address.
1129      * - `to` cannot be the zero address.
1130      *
1131      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1132      */
1133     function _beforeTokenTransfer(
1134         address from,
1135         address to,
1136         uint256 tokenId
1137     ) internal virtual override {
1138         super._beforeTokenTransfer(from, to, tokenId);
1139 
1140         if (from == address(0)) {
1141             _addTokenToAllTokensEnumeration(tokenId);
1142         } else if (from != to) {
1143             _removeTokenFromOwnerEnumeration(from, tokenId);
1144         }
1145         if (to == address(0)) {
1146             _removeTokenFromAllTokensEnumeration(tokenId);
1147         } else if (to != from) {
1148             _addTokenToOwnerEnumeration(to, tokenId);
1149         }
1150     }
1151 
1152     /**
1153      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1154      * @param to address representing the new owner of the given token ID
1155      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1156      */
1157     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1158         uint256 length = ERC721.balanceOf(to);
1159         _ownedTokens[to][length] = tokenId;
1160         _ownedTokensIndex[tokenId] = length;
1161     }
1162 
1163     /**
1164      * @dev Private function to add a token to this extension's token tracking data structures.
1165      * @param tokenId uint256 ID of the token to be added to the tokens list
1166      */
1167     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1168         _allTokensIndex[tokenId] = _allTokens.length;
1169         _allTokens.push(tokenId);
1170     }
1171 
1172     /**
1173      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1174      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1175      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1176      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1177      * @param from address representing the previous owner of the given token ID
1178      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1179      */
1180     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1181         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1182         // then delete the last slot (swap and pop).
1183 
1184         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1185         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1186 
1187         // When the token to delete is the last token, the swap operation is unnecessary
1188         if (tokenIndex != lastTokenIndex) {
1189             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1190 
1191             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1192             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1193         }
1194 
1195         // This also deletes the contents at the last position of the array
1196         delete _ownedTokensIndex[tokenId];
1197         delete _ownedTokens[from][lastTokenIndex];
1198     }
1199 
1200     /**
1201      * @dev Private function to remove a token from this extension's token tracking data structures.
1202      * This has O(1) time complexity, but alters the order of the _allTokens array.
1203      * @param tokenId uint256 ID of the token to be removed from the tokens list
1204      */
1205     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1206         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1207         // then delete the last slot (swap and pop).
1208 
1209         uint256 lastTokenIndex = _allTokens.length - 1;
1210         uint256 tokenIndex = _allTokensIndex[tokenId];
1211 
1212         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1213         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1214         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1215         uint256 lastTokenId = _allTokens[lastTokenIndex];
1216 
1217         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1218         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1219 
1220         // This also deletes the contents at the last position of the array
1221         delete _allTokensIndex[tokenId];
1222         _allTokens.pop();
1223     }
1224 }
1225 
1226 //File: contracts/Realms.sol
1227 
1228 interface LootInterface {
1229     function ownerOf(uint256 tokenId) external view returns (address owner);
1230     function balanceOf(address owner) external view returns (uint256 balance);
1231     function tokenOfOwnerByIndex(address owner, uint256 index)
1232         external
1233         view
1234         returns (uint256 tokenId);
1235 }
1236 
1237 
1238 contract SJWBloot is ERC721Enumerable, ReentrancyGuard, Ownable {
1239     uint256 public constant PUBLIC_MINT_PRICE = 15000000000000000; //0.015 ETH
1240 
1241     string[] private weapons = [
1242         "No weapon",
1243         "Knife",
1244         "Gun",
1245         "Molotov",
1246         "Protest Sign",
1247         "Scream",
1248         "Pepper Spray",
1249         "Police Gun",
1250         "Hands",
1251         "Long Nails",
1252         "Mouth",
1253         "Baseball bat",
1254         "Tear Gas",
1255         "Tazer",
1256         "Megaphone",
1257         "Whistle",
1258         "Stick",
1259         "Protest Banner",
1260         "Spray paint",
1261         "Rainbow Dildo"
1262         
1263     ];
1264     
1265     string[] private chestArmor = [
1266         "Make America Great Again t-shirt",
1267         "Fuck Trump t-shirt",
1268         "Trigger Warning shirt",
1269         "Rainbow jacket",
1270         "Black hoodie",
1271         "WOKE BIDEN t-shirt",
1272         "Stolen police vest",
1273         "Plain black shirt",
1274         "Plain white shirt",
1275         "Plain hoodie",
1276         "Start-up hoodie",
1277         "We Love Biden t-shirt",
1278         "NO WALL t-shirt",
1279         "Free speach t-shirt",
1280         "Can't silence us t-shirt",
1281         "Rainbow jumper",
1282         "Trump 2024 t-shirt",
1283         "Biden 2024 t-shirt"
1284     ];
1285     
1286     string[] private headArmor = [
1287         "No hair",
1288         "Fuzzy hat",
1289         "Black beanie",
1290         "Special hat",
1291         "Stolen police helmet",
1292         "Rainbow hair",
1293         "Make America Great Again hat",
1294         "Balding",
1295         "Long hair",
1296         "Gag ball",
1297         "Blue hair",
1298         "Red hair",
1299         "Gas Mask",
1300         "Half shaved head",
1301         "Rainbow hat",
1302         "Trump face mask",
1303         "Biden face mask",
1304         "N95 mask",
1305         "Piercings",
1306         "Tinfoil hat"
1307         
1308     ];
1309     
1310     string[] private pantsArmor = [
1311         "No pants",
1312         "Black leggings",
1313         "Khakis",
1314         "Leather pants",
1315         "Sweatpants",
1316         "Ripped jeans",
1317         "Rainbow leggings",
1318         "Casual jeans",
1319         "Tight jeans",
1320         "Short shorts",
1321         "Rainbow pants",
1322         "Slacks",
1323         "Skirt",
1324         "G-string",
1325         "Rainbow shorts",
1326         "Fish net leggings"
1327     ];
1328     
1329     string[] private footArmor = [
1330         "No shoes",
1331         "Old ass trainers",
1332         "Nike Dunks",
1333         "Boomer trainers",
1334         "Leather boots",
1335         "Ugly running shoes",
1336         "Converse",
1337         "Thicc black boots",
1338         "Knee high boots",
1339         "Sketchers",
1340         "Heels",
1341         "Toe exposing shoes",
1342         "Crocs",
1343         "Slippers",
1344         "Socks with sandals",
1345         "Airforces",
1346         "Beat up jordans",
1347         "Skater shoes",
1348         "Strapped up boots",
1349         "Rainbow boots"
1350     ];
1351     
1352     string[] private handArmor = [
1353         "No hands",
1354         "Leather gloves",
1355         "Fingerless gloves",
1356         "Winter gloves",
1357         "Hand tattoos",
1358         "Fat hands",
1359         "Skinny hands",
1360         "Long ass nails",
1361         "Unwashed hands",
1362         "Washed hands",
1363         "Sanitised hands",
1364         "Calloused hands",
1365         "Diamond hands",
1366         "Black gloves",
1367         "Fucked up hands",
1368         "Diamond detector",
1369         "Dollar store gloves"
1370     ];
1371     
1372     string[] private necklaces = [
1373 	    "No necklace",
1374         "Dollar store chain",
1375         "Iced out biden chain",
1376         "Iced out trump chain",
1377         "Fuck trump pendant",
1378         "Peace and love pendant",
1379         "Choker",
1380         "Neckbeard",
1381         "Neck fuzz",
1382         "Rainbow choker",
1383         "Dog collar",
1384         "Covid tracking chip",
1385         "Free speach chain"
1386         
1387     ];
1388     
1389     string[] private rings = [
1390         "No ring",
1391         "Purity ring",
1392         "Fake ass gold ring",
1393         "Wedding ring",
1394         "Biden purity ring",
1395         "Real diamond ring"
1396         "Glass ring"
1397         
1398     ];
1399     
1400     string[] private suffixes = [
1401         "of Free Speach",
1402         "of Trump Tower",
1403         "of White House",
1404         "of School",
1405         "of Senate",
1406         "of Faithulness",
1407         "of Consciousness",
1408         "of Strictness",
1409         "of Power",
1410         "of Ass",
1411         "of Rage",
1412         "of Death",
1413         "of Cope",
1414         "of Humanity",
1415         "of Church",
1416         "of The Streets",
1417         "of Politics",
1418         "of Police",
1419         "of America",
1420         "of The World"
1421     ];
1422     
1423     string[] private namePrefixes = [
1424         "Horrible", "Mean", "Silly", "Beast", "Strong", "Impenetrable", "Nerdy", "Clean", "Proud", "Long-bearded", "Manly", "Wimpy", "Scrawny", "Crackling", 
1425         "Corruption", "Faithless", "Sturdy", "Painful", "Painted", "Gnarly", "MUD", "Sad", "Angry", "Touchy", "Cold", "Robot", "Ghastly", 
1426         "Haunted", "Glyph", "Gory", "Hateful", "Rage", "Honorable", "Grody", "Depressed", "Clicky", "Bullshit", "False", "Lying", "Fake", "Agile", "Extreme", "Free", 
1427         "Expensive", "Horny", "Lonely", "Creepy", "Awkward", "Unfriendly", "Physco", "Mental", "Faithful", "Shimmering", "Shaky", "Scared"
1428     ];
1429     
1430     string[] private nameSuffixes = [
1431         "Sjw",
1432         "Patient",
1433         "Politician",
1434         "Supporter",
1435         "Patriot",
1436         "Woman",
1437         "Man",
1438         "Gender",
1439         "Bender",
1440         "Stealer",
1441         "Looter",
1442         "Scream",
1443         "Fire",
1444         "Officier"
1445         "Juul",
1446         "Blunt",
1447         "Rat"
1448     ];
1449     
1450     //Loot Contract
1451     address public svblootAddress = 0x471E9CfcfB031B71813F0F7530696f41c09c4a9c;
1452     address public blootAddress = 0x4F8730E0b32B04beaa5757e5aea3aeF970E5B613;
1453     LootInterface svblootContract = LootInterface(svblootAddress);
1454     LootInterface blootContract = LootInterface(blootAddress);
1455     
1456     uint private svblootOwnersSupply = 0;
1457     uint private blootOwnersSupply = 0;
1458     uint private publicOwnersSupply = 0;
1459     uint private maxSupply = 8000;
1460     
1461     function random(string memory input) internal pure returns (uint256) {
1462         return uint256(keccak256(abi.encodePacked(input)));
1463     }
1464     
1465     function getWeapon(uint256 tokenId) public view returns (string memory) {
1466         return pluck(tokenId, "WEAPON", weapons);
1467     }
1468     
1469     function getChest(uint256 tokenId) public view returns (string memory) {
1470         return pluck(tokenId, "CHEST", chestArmor);
1471     }
1472     
1473     function getHead(uint256 tokenId) public view returns (string memory) {
1474         return pluck(tokenId, "HEAD", headArmor);
1475     }
1476     
1477     function getPants(uint256 tokenId) public view returns (string memory) {
1478         return pluck(tokenId, "PANTS", pantsArmor);
1479     }
1480 
1481     function getFoot(uint256 tokenId) public view returns (string memory) {
1482         return pluck(tokenId, "FOOT", footArmor);
1483     }
1484     
1485     function getHand(uint256 tokenId) public view returns (string memory) {
1486         return pluck(tokenId, "HAND", handArmor);
1487     }
1488     
1489     function getNeck(uint256 tokenId) public view returns (string memory) {
1490         return pluck(tokenId, "NECK", necklaces);
1491     }
1492     
1493     function getRing(uint256 tokenId) public view returns (string memory) {
1494         return pluck(tokenId, "RING", rings);
1495     }
1496     
1497     function pluck(uint256 tokenId, string memory keyPrefix, string[] memory sourceArray) internal view returns (string memory) {
1498         uint256 rand = random(string(abi.encodePacked(keyPrefix, toString(tokenId))));
1499         uint256 index = rand % sourceArray.length;
1500         string memory output = sourceArray[index];
1501         if (index == 0) {
1502             return output;
1503         }
1504         
1505         uint256 nerdiness = rand % 21;
1506         if (nerdiness > 14) {
1507             output = string(abi.encodePacked(output, " ", suffixes[rand % suffixes.length]));
1508         }
1509         if (nerdiness >= 19) {
1510             string[2] memory name;
1511             name[0] = namePrefixes[rand % namePrefixes.length];
1512             name[1] = nameSuffixes[rand % nameSuffixes.length];
1513             if (nerdiness == 19) {
1514                 output = string(abi.encodePacked('"', name[0], ' ', name[1], '" ', output));
1515             } else {
1516                 output = string(abi.encodePacked('"', name[0], ' ', name[1], '" ', output, " +1"));
1517             }
1518         }
1519         return output;
1520     }
1521 
1522     function tokenURI(uint256 tokenId) override public view returns (string memory) {
1523         string memory output = 
1524             string(abi.encodePacked(
1525                 '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: black; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="#01ff01" /><text x="10" y="20" class="base">',
1526                 getWeapon(tokenId),
1527                 '</text><text x="10" y="40" class="base">',
1528                 getChest(tokenId),
1529                 '</text><text x="10" y="60" class="base">',
1530                 getHead(tokenId),
1531                 '</text><text x="10" y="80" class="base">',
1532                 getPants(tokenId),
1533                 '</text><text x="10" y="100" class="base">',
1534                 getFoot(tokenId)
1535             ));
1536 
1537         output = 
1538             string(abi.encodePacked(
1539                 output,
1540                 '</text><text x="10" y="120" class="base">',
1541                 getHand(tokenId),
1542                 '</text><text x="10" y="140" class="base">',
1543                 getNeck(tokenId),
1544                 '</text><text x="10" y="160" class="base">',
1545                 getRing(tokenId),
1546                 '</text></svg>'
1547             ));
1548         
1549         string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "SJW Gear #', toString(tokenId), '", "description": "sjwBloot is basically worthless randomized sjw gear generated and stored on chain. Stats, images, and other functionality are intentionally omitted for others to interpret. Feel free to use sjwBloot in any way you want.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
1550         output = string(abi.encodePacked('data:application/json;base64,', json));
1551 
1552         return output;
1553     }
1554     
1555     function svblootOwnerFreeClaim() public nonReentrant {
1556         require(svblootOwnersSupply < 2000, "No more svbloot owner claims");
1557         require(totalSupply() < maxSupply, "No more tokens to mint");
1558         require(svblootContract.balanceOf(msg.sender) > 0, "Must own a svbloot to claim from this method");
1559         uint index = totalSupply();
1560         svblootOwnersSupply = svblootOwnersSupply + 1;
1561         _safeMint(_msgSender(), index);
1562     }
1563     
1564     function blootOwnerFreeClaim() public nonReentrant {
1565         require(blootOwnersSupply < 3000, "No more bloot owner claims");
1566         require(totalSupply() < maxSupply, "No more tokens to mint");
1567         require(blootContract.balanceOf(msg.sender) > 0, "Must own a bloot to claim from this method");
1568         uint index = totalSupply();
1569         blootOwnersSupply = blootOwnersSupply + 1;
1570         _safeMint(_msgSender(), index);
1571     }
1572     
1573     function publicClaim() public nonReentrant payable {
1574         require(publicOwnersSupply < 3000, "No more tokens to mint");
1575         require(totalSupply() < maxSupply, "No more tokens to mint");
1576         require(msg.value >= PUBLIC_MINT_PRICE, "Payment too low, try .015");
1577         uint index = totalSupply();
1578         publicOwnersSupply = publicOwnersSupply + 1;
1579         _safeMint(_msgSender(), index);
1580     }
1581     
1582     function withdrawFunds() public onlyOwner {
1583         uint balance = address(this).balance;
1584         payable(msg.sender).transfer(balance);
1585     }
1586     
1587     function toString(uint256 value) internal pure returns (string memory) {
1588     // Inspired by OraclizeAPI's implementation - MIT license
1589     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1590 
1591         if (value == 0) {
1592             return "0";
1593         }
1594         uint256 temp = value;
1595         uint256 digits;
1596         while (temp != 0) {
1597             digits++;
1598             temp /= 10;
1599         }
1600         bytes memory buffer = new bytes(digits);
1601         while (value != 0) {
1602             digits -= 1;
1603             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1604             value /= 10;
1605         }
1606         return string(buffer);
1607     }
1608     
1609     constructor() ERC721("sjwBloot", "SJWBLOOT") Ownable() {}
1610 }
1611 
1612 /// [MIT License]
1613 /// @title Base64
1614 /// @notice Provides a function for encoding some bytes in base64
1615 /// @author Brecht Devos <brecht@loopring.org>
1616 library Base64 {
1617     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1618 
1619     /// @notice Encodes some bytes to the base64 representation
1620     function encode(bytes memory data) internal pure returns (string memory) {
1621         uint256 len = data.length;
1622         if (len == 0) return "";
1623 
1624         // multiply by 4/3 rounded up
1625         uint256 encodedLen = 4 * ((len + 2) / 3);
1626 
1627         // Add some extra buffer at the end
1628         bytes memory result = new bytes(encodedLen + 32);
1629 
1630         bytes memory table = TABLE;
1631 
1632         assembly {
1633             let tablePtr := add(table, 1)
1634             let resultPtr := add(result, 32)
1635 
1636             for {
1637                 let i := 0
1638             } lt(i, len) {
1639 
1640             } {
1641                 i := add(i, 3)
1642                 let input := and(mload(add(data, i)), 0xffffff)
1643 
1644                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
1645                 out := shl(8, out)
1646                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
1647                 out := shl(8, out)
1648                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
1649                 out := shl(8, out)
1650                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
1651                 out := shl(224, out)
1652 
1653                 mstore(resultPtr, out)
1654 
1655                 resultPtr := add(resultPtr, 4)
1656             }
1657 
1658             switch mod(len, 3)
1659             case 1 {
1660                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1661             }
1662             case 2 {
1663                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
1664             }
1665 
1666             mstore(result, encodedLen)
1667         }
1668 
1669         return string(result);
1670     }
1671 }