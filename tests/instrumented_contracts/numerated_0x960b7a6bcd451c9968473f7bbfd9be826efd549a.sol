1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 // @title: OnChainMonkey
5 // @author: huuep
6 //
7 // On chain PFP collection of 10k unique profile images with the following properties:
8 //   - a single Ethereum transaction created everything
9 //   - all metadata on chain
10 //   - all images on chain in svg format
11 //   - all created in the constraints of a single txn without need of any other txns to load additional data
12 //   - no use of other deployed contracts
13 //   - all 10,000 OnChain Monkeys are unique
14 //   - there are 7 traits with 171 values (including 3 traits of no hat, no clothes, and no earring)
15 //   - the traits have distribution and rarities interesting for collecting
16 //   - everything on chain can be used in other apps and collections in the future
17 // And did I say, Monkeys?
18 
19 /// [MIT License]
20 /// @title Base64
21 /// @notice Provides a function for encoding some bytes in base64
22 /// @author Brecht Devos <brecht@loopring.org>
23 library Base64 {
24     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
25 
26     /// @notice Encodes some bytes to the base64 representation
27     function encode(bytes memory data) internal pure returns (string memory) {
28         uint256 len = data.length;
29         if (len == 0) return "";
30 
31         // multiply by 4/3 rounded up
32         uint256 encodedLen = 4 * ((len + 2) / 3);
33 
34         // Add some extra buffer at the end
35         bytes memory result = new bytes(encodedLen + 32);
36         bytes memory table = TABLE;
37 
38         assembly {
39             let tablePtr := add(table, 1)
40             let resultPtr := add(result, 32)
41             for {
42                 let i := 0
43             } lt(i, len) {
44             } {
45                 i := add(i, 3)
46                 let input := and(mload(add(data, i)), 0xffffff)
47                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
48                 out := shl(8, out)
49                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
50                 out := shl(8, out)
51                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
52                 out := shl(8, out)
53                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
54                 out := shl(224, out)
55                 mstore(resultPtr, out)
56                 resultPtr := add(resultPtr, 4)
57             }
58             switch mod(len, 3)
59             case 1 {
60                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
61             }
62             case 2 {
63                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
64             }
65             mstore(result, encodedLen)
66         }
67         return string(result);
68     }
69 }
70 
71 /**
72  * @dev Interface of the ERC165 standard, as defined in the
73  * https://eips.ethereum.org/EIPS/eip-165[EIP].
74  *
75  * Implementers can declare support of contract interfaces, which can then be
76  * queried by others ({ERC165Checker}).
77  *
78  * For an implementation, see {ERC165}.
79  */
80 interface IERC165 {
81     /**
82      * @dev Returns true if this contract implements the interface defined by
83      * `interfaceId`. See the corresponding
84      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
85      * to learn more about how these ids are created.
86      *
87      * This function call must use less than 30 000 gas.
88      */
89     function supportsInterface(bytes4 interfaceId) external view returns (bool);
90 }
91 
92 /**
93  * @dev Required interface of an ERC721 compliant contract.
94  */
95 interface IERC721 is IERC165 {
96     /**
97      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
100 
101     /**
102      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
103      */
104     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
105 
106     /**
107      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
108      */
109     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
110 
111     /**
112      * @dev Returns the number of tokens in ``owner``'s account.
113      */
114     function balanceOf(address owner) external view returns (uint256 balance);
115 
116     /**
117      * @dev Returns the owner of the `tokenId` token.
118      *
119      * Requirements:
120      *
121      * - `tokenId` must exist.
122      */
123     function ownerOf(uint256 tokenId) external view returns (address owner);
124 
125     /**
126      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
127      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
128      *
129      * Requirements:
130      *
131      * - `from` cannot be the zero address.
132      * - `to` cannot be the zero address.
133      * - `tokenId` token must exist and be owned by `from`.
134      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
135      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
136      *
137      * Emits a {Transfer} event.
138      */
139     function safeTransferFrom(
140         address from,
141         address to,
142         uint256 tokenId
143     ) external;
144 
145     /**
146      * @dev Transfers `tokenId` token from `from` to `to`.
147      *
148      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
149      *
150      * Requirements:
151      *
152      * - `from` cannot be the zero address.
153      * - `to` cannot be the zero address.
154      * - `tokenId` token must be owned by `from`.
155      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
156      *
157      * Emits a {Transfer} event.
158      */
159     function transferFrom(
160         address from,
161         address to,
162         uint256 tokenId
163     ) external;
164 
165     /**
166      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
167      * The approval is cleared when the token is transferred.
168      *
169      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
170      *
171      * Requirements:
172      *
173      * - The caller must own the token or be an approved operator.
174      * - `tokenId` must exist.
175      *
176      * Emits an {Approval} event.
177      */
178     function approve(address to, uint256 tokenId) external;
179 
180     /**
181      * @dev Returns the account approved for `tokenId` token.
182      *
183      * Requirements:
184      *
185      * - `tokenId` must exist.
186      */
187     function getApproved(uint256 tokenId) external view returns (address operator);
188 
189     /**
190      * @dev Approve or remove `operator` as an operator for the caller.
191      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
192      *
193      * Requirements:
194      *
195      * - The `operator` cannot be the caller.
196      *
197      * Emits an {ApprovalForAll} event.
198      */
199     function setApprovalForAll(address operator, bool _approved) external;
200 
201     /**
202      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
203      *
204      * See {setApprovalForAll}
205      */
206     function isApprovedForAll(address owner, address operator) external view returns (bool);
207 
208     /**
209      * @dev Safely transfers `tokenId` token from `from` to `to`.
210      *
211      * Requirements:
212      *
213      * - `from` cannot be the zero address.
214      * - `to` cannot be the zero address.
215      * - `tokenId` token must exist and be owned by `from`.
216      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
217      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
218      *
219      * Emits a {Transfer} event.
220      */
221     function safeTransferFrom(
222         address from,
223         address to,
224         uint256 tokenId,
225         bytes calldata data
226     ) external;
227 }
228 
229 /**
230  * @dev String operations.
231  */
232 library Strings {
233     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
234 
235     /**
236      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
237      */
238     function toString(uint256 value) internal pure returns (string memory) {
239         // Inspired by OraclizeAPI's implementation - MIT licence
240         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
241 
242         if (value == 0) {
243             return "0";
244         }
245         uint256 temp = value;
246         uint256 digits;
247         while (temp != 0) {
248             digits++;
249             temp /= 10;
250         }
251         bytes memory buffer = new bytes(digits);
252         while (value != 0) {
253             digits -= 1;
254             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
255             value /= 10;
256         }
257         return string(buffer);
258     }
259 
260     /**
261      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
262      */
263     function toHexString(uint256 value) internal pure returns (string memory) {
264         if (value == 0) {
265             return "0x00";
266         }
267         uint256 temp = value;
268         uint256 length = 0;
269         while (temp != 0) {
270             length++;
271             temp >>= 8;
272         }
273         return toHexString(value, length);
274     }
275 
276     /**
277      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
278      */
279     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
280         bytes memory buffer = new bytes(2 * length + 2);
281         buffer[0] = "0";
282         buffer[1] = "x";
283         for (uint256 i = 2 * length + 1; i > 1; --i) {
284             buffer[i] = _HEX_SYMBOLS[value & 0xf];
285             value >>= 4;
286         }
287         require(value == 0, "Strings: hex length insufficient");
288         return string(buffer);
289     }
290 }
291 
292 /*
293  * @dev Provides information about the current execution context, including the
294  * sender of the transaction and its data. While these are generally available
295  * via msg.sender and msg.data, they should not be accessed in such a direct
296  * manner, since when dealing with meta-transactions the account sending and
297  * paying for execution may not be the actual sender (as far as an application
298  * is concerned).
299  *
300  * This contract is only required for intermediate, library-like contracts.
301  */
302 abstract contract Context {
303     function _msgSender() internal view virtual returns (address) {
304         return msg.sender;
305     }
306 
307     function _msgData() internal view virtual returns (bytes calldata) {
308         return msg.data;
309     }
310 }
311 
312 /**
313  * @dev Contract module which provides a basic access control mechanism, where
314  * there is an account (an owner) that can be granted exclusive access to
315  * specific functions.
316  *
317  * By default, the owner account will be the one that deploys the contract. This
318  * can later be changed with {transferOwnership}.
319  *
320  * This module is used through inheritance. It will make available the modifier
321  * `onlyOwner`, which can be applied to your functions to restrict their use to
322  * the owner.
323  */
324 abstract contract Ownable is Context {
325     address private _owner;
326 
327     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
328 
329     /**
330      * @dev Initializes the contract setting the deployer as the initial owner.
331      */
332     constructor() {
333         _setOwner(_msgSender());
334     }
335 
336     /**
337      * @dev Returns the address of the current owner.
338      */
339     function owner() public view virtual returns (address) {
340         return _owner;
341     }
342 
343     /**
344      * @dev Throws if called by any account other than the owner.
345      */
346     modifier onlyOwner() {
347         require(owner() == _msgSender(), "Ownable: caller is not the owner");
348         _;
349     }
350 
351     /**
352      * @dev Leaves the contract without owner. It will not be possible to call
353      * `onlyOwner` functions anymore. Can only be called by the current owner.
354      *
355      * NOTE: Renouncing ownership will leave the contract without an owner,
356      * thereby removing any functionality that is only available to the owner.
357      */
358     function renounceOwnership() public virtual onlyOwner {
359         _setOwner(address(0));
360     }
361 
362     /**
363      * @dev Transfers ownership of the contract to a new account (`newOwner`).
364      * Can only be called by the current owner.
365      */
366     function transferOwnership(address newOwner) public virtual onlyOwner {
367         require(newOwner != address(0), "Ownable: new owner is the zero address");
368         _setOwner(newOwner);
369     }
370 
371     function _setOwner(address newOwner) private {
372         address oldOwner = _owner;
373         _owner = newOwner;
374         emit OwnershipTransferred(oldOwner, newOwner);
375     }
376 }
377 
378 /**
379  * @dev Contract module that helps prevent reentrant calls to a function.
380  *
381  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
382  * available, which can be applied to functions to make sure there are no nested
383  * (reentrant) calls to them.
384  *
385  * Note that because there is a single `nonReentrant` guard, functions marked as
386  * `nonReentrant` may not call one another. This can be worked around by making
387  * those functions `private`, and then adding `external` `nonReentrant` entry
388  * points to them.
389  *
390  * TIP: If you would like to learn more about reentrancy and alternative ways
391  * to protect against it, check out our blog post
392  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
393  */
394 abstract contract ReentrancyGuard {
395     // Booleans are more expensive than uint256 or any type that takes up a full
396     // word because each write operation emits an extra SLOAD to first read the
397     // slot's contents, replace the bits taken up by the boolean, and then write
398     // back. This is the compiler's defense against contract upgrades and
399     // pointer aliasing, and it cannot be disabled.
400 
401     // The values being non-zero value makes deployment a bit more expensive,
402     // but in exchange the refund on every call to nonReentrant will be lower in
403     // amount. Since refunds are capped to a percentage of the total
404     // transaction's gas, it is best to keep them low in cases like this one, to
405     // increase the likelihood of the full refund coming into effect.
406     uint256 private constant _NOT_ENTERED = 1;
407     uint256 private constant _ENTERED = 2;
408 
409     uint256 private _status;
410 
411     constructor() {
412         _status = _NOT_ENTERED;
413     }
414 
415     /**
416      * @dev Prevents a contract from calling itself, directly or indirectly.
417      * Calling a `nonReentrant` function from another `nonReentrant`
418      * function is not supported. It is possible to prevent this from happening
419      * by making the `nonReentrant` function external, and make it call a
420      * `private` function that does the actual work.
421      */
422     modifier nonReentrant() {
423         // On the first call to nonReentrant, _notEntered will be true
424         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
425 
426         // Any calls to nonReentrant after this point will fail
427         _status = _ENTERED;
428 
429         _;
430 
431         // By storing the original value once again, a refund is triggered (see
432         // https://eips.ethereum.org/EIPS/eip-2200)
433         _status = _NOT_ENTERED;
434     }
435 }
436 
437 /**
438  * @title ERC721 token receiver interface
439  * @dev Interface for any contract that wants to support safeTransfers
440  * from ERC721 asset contracts.
441  */
442 interface IERC721Receiver {
443     /**
444      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
445      * by `operator` from `from`, this function is called.
446      *
447      * It must return its Solidity selector to confirm the token transfer.
448      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
449      *
450      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
451      */
452     function onERC721Received(
453         address operator,
454         address from,
455         uint256 tokenId,
456         bytes calldata data
457     ) external returns (bytes4);
458 }
459 
460 /**
461  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
462  * @dev See https://eips.ethereum.org/EIPS/eip-721
463  */
464 interface IERC721Metadata is IERC721 {
465     /**
466      * @dev Returns the token collection name.
467      */
468     function name() external view returns (string memory);
469 
470     /**
471      * @dev Returns the token collection symbol.
472      */
473     function symbol() external view returns (string memory);
474 
475     /**
476      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
477      */
478     function tokenURI(uint256 tokenId) external view returns (string memory);
479 }
480 
481 /**
482  * @dev Collection of functions related to the address type
483  */
484 library Address {
485     /**
486      * @dev Returns true if `account` is a contract.
487      *
488      * [IMPORTANT]
489      * ====
490      * It is unsafe to assume that an address for which this function returns
491      * false is an externally-owned account (EOA) and not a contract.
492      *
493      * Among others, `isContract` will return false for the following
494      * types of addresses:
495      *
496      *  - an externally-owned account
497      *  - a contract in construction
498      *  - an address where a contract will be created
499      *  - an address where a contract lived, but was destroyed
500      * ====
501      */
502     function isContract(address account) internal view returns (bool) {
503         // This method relies on extcodesize, which returns 0 for contracts in
504         // construction, since the code is only stored at the end of the
505         // constructor execution.
506 
507         uint256 size;
508         assembly {
509             size := extcodesize(account)
510         }
511         return size > 0;
512     }
513 
514     /**
515      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
516      * `recipient`, forwarding all available gas and reverting on errors.
517      *
518      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
519      * of certain opcodes, possibly making contracts go over the 2300 gas limit
520      * imposed by `transfer`, making them unable to receive funds via
521      * `transfer`. {sendValue} removes this limitation.
522      *
523      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
524      *
525      * IMPORTANT: because control is transferred to `recipient`, care must be
526      * taken to not create reentrancy vulnerabilities. Consider using
527      * {ReentrancyGuard} or the
528      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
529      */
530     function sendValue(address payable recipient, uint256 amount) internal {
531         require(address(this).balance >= amount, "Address: insufficient balance");
532 
533         (bool success, ) = recipient.call{value: amount}("");
534         require(success, "Address: unable to send value, recipient may have reverted");
535     }
536 
537     /**
538      * @dev Performs a Solidity function call using a low level `call`. A
539      * plain `call` is an unsafe replacement for a function call: use this
540      * function instead.
541      *
542      * If `target` reverts with a revert reason, it is bubbled up by this
543      * function (like regular Solidity function calls).
544      *
545      * Returns the raw returned data. To convert to the expected return value,
546      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
547      *
548      * Requirements:
549      *
550      * - `target` must be a contract.
551      * - calling `target` with `data` must not revert.
552      *
553      * _Available since v3.1._
554      */
555     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
556         return functionCall(target, data, "Address: low-level call failed");
557     }
558 
559     /**
560      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
561      * `errorMessage` as a fallback revert reason when `target` reverts.
562      *
563      * _Available since v3.1._
564      */
565     function functionCall(
566         address target,
567         bytes memory data,
568         string memory errorMessage
569     ) internal returns (bytes memory) {
570         return functionCallWithValue(target, data, 0, errorMessage);
571     }
572 
573     /**
574      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
575      * but also transferring `value` wei to `target`.
576      *
577      * Requirements:
578      *
579      * - the calling contract must have an ETH balance of at least `value`.
580      * - the called Solidity function must be `payable`.
581      *
582      * _Available since v3.1._
583      */
584     function functionCallWithValue(
585         address target,
586         bytes memory data,
587         uint256 value
588     ) internal returns (bytes memory) {
589         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
590     }
591 
592     /**
593      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
594      * with `errorMessage` as a fallback revert reason when `target` reverts.
595      *
596      * _Available since v3.1._
597      */
598     function functionCallWithValue(
599         address target,
600         bytes memory data,
601         uint256 value,
602         string memory errorMessage
603     ) internal returns (bytes memory) {
604         require(address(this).balance >= value, "Address: insufficient balance for call");
605         require(isContract(target), "Address: call to non-contract");
606 
607         (bool success, bytes memory returndata) = target.call{value: value}(data);
608         return _verifyCallResult(success, returndata, errorMessage);
609     }
610 
611     /**
612      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
613      * but performing a static call.
614      *
615      * _Available since v3.3._
616      */
617     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
618         return functionStaticCall(target, data, "Address: low-level static call failed");
619     }
620 
621     /**
622      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
623      * but performing a static call.
624      *
625      * _Available since v3.3._
626      */
627     function functionStaticCall(
628         address target,
629         bytes memory data,
630         string memory errorMessage
631     ) internal view returns (bytes memory) {
632         require(isContract(target), "Address: static call to non-contract");
633 
634         (bool success, bytes memory returndata) = target.staticcall(data);
635         return _verifyCallResult(success, returndata, errorMessage);
636     }
637 
638     /**
639      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
640      * but performing a delegate call.
641      *
642      * _Available since v3.4._
643      */
644     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
645         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
646     }
647 
648     /**
649      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
650      * but performing a delegate call.
651      *
652      * _Available since v3.4._
653      */
654     function functionDelegateCall(
655         address target,
656         bytes memory data,
657         string memory errorMessage
658     ) internal returns (bytes memory) {
659         require(isContract(target), "Address: delegate call to non-contract");
660 
661         (bool success, bytes memory returndata) = target.delegatecall(data);
662         return _verifyCallResult(success, returndata, errorMessage);
663     }
664 
665     function _verifyCallResult(
666         bool success,
667         bytes memory returndata,
668         string memory errorMessage
669     ) private pure returns (bytes memory) {
670         if (success) {
671             return returndata;
672         } else {
673             // Look for revert reason and bubble it up if present
674             if (returndata.length > 0) {
675                 // The easiest way to bubble the revert reason is using memory via assembly
676 
677                 assembly {
678                     let returndata_size := mload(returndata)
679                     revert(add(32, returndata), returndata_size)
680                 }
681             } else {
682                 revert(errorMessage);
683             }
684         }
685     }
686 }
687 
688 /**
689  * @dev Implementation of the {IERC165} interface.
690  *
691  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
692  * for the additional interface id that will be supported. For example:
693  *
694  * ```solidity
695  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
696  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
697  * }
698  * ```
699  *
700  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
701  */
702 abstract contract ERC165 is IERC165 {
703     /**
704      * @dev See {IERC165-supportsInterface}.
705      */
706     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
707         return interfaceId == type(IERC165).interfaceId;
708     }
709 }
710 
711 /**
712  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
713  * the Metadata extension, but not including the Enumerable extension, which is available separately as
714  * {ERC721Enumerable}.
715  */
716 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
717     using Address for address;
718     using Strings for uint256;
719 
720     // Token name
721     string private _name;
722 
723     // Token symbol
724     string private _symbol;
725 
726     // Mapping from token ID to owner address
727     mapping(uint256 => address) private _owners;
728 
729     // Mapping owner address to token count
730     mapping(address => uint256) private _balances;
731 
732     // Mapping from token ID to approved address
733     mapping(uint256 => address) private _tokenApprovals;
734 
735     // Mapping from owner to operator approvals
736     mapping(address => mapping(address => bool)) private _operatorApprovals;
737 
738     /**
739      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
740      */
741     constructor(string memory name_, string memory symbol_) {
742         _name = name_;
743         _symbol = symbol_;
744     }
745 
746     /**
747      * @dev See {IERC165-supportsInterface}.
748      */
749     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
750         return
751             interfaceId == type(IERC721).interfaceId ||
752             interfaceId == type(IERC721Metadata).interfaceId ||
753             super.supportsInterface(interfaceId);
754     }
755 
756     /**
757      * @dev See {IERC721-balanceOf}.
758      */
759     function balanceOf(address owner) public view virtual override returns (uint256) {
760         require(owner != address(0), "ERC721: balance query for the zero address");
761         return _balances[owner];
762     }
763 
764     /**
765      * @dev See {IERC721-ownerOf}.
766      */
767     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
768         address owner = _owners[tokenId];
769         require(owner != address(0), "ERC721: owner query for nonexistent token");
770         return owner;
771     }
772 
773     /**
774      * @dev See {IERC721Metadata-name}.
775      */
776     function name() public view virtual override returns (string memory) {
777         return _name;
778     }
779 
780     /**
781      * @dev See {IERC721Metadata-symbol}.
782      */
783     function symbol() public view virtual override returns (string memory) {
784         return _symbol;
785     }
786 
787     /**
788      * @dev See {IERC721Metadata-tokenURI}.
789      */
790     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
791         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
792 
793         string memory baseURI = _baseURI();
794         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
795     }
796 
797     /**
798      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
799      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
800      * by default, can be overriden in child contracts.
801      */
802     function _baseURI() internal view virtual returns (string memory) {
803         return "";
804     }
805 
806     /**
807      * @dev See {IERC721-approve}.
808      */
809     function approve(address to, uint256 tokenId) public virtual override {
810         address owner = ERC721.ownerOf(tokenId);
811         require(to != owner, "ERC721: approval to current owner");
812 
813         require(
814             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
815             "ERC721: approve caller is not owner nor approved for all"
816         );
817 
818         _approve(to, tokenId);
819     }
820 
821     /**
822      * @dev See {IERC721-getApproved}.
823      */
824     function getApproved(uint256 tokenId) public view virtual override returns (address) {
825         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
826 
827         return _tokenApprovals[tokenId];
828     }
829 
830     /**
831      * @dev See {IERC721-setApprovalForAll}.
832      */
833     function setApprovalForAll(address operator, bool approved) public virtual override {
834         require(operator != _msgSender(), "ERC721: approve to caller");
835 
836         _operatorApprovals[_msgSender()][operator] = approved;
837         emit ApprovalForAll(_msgSender(), operator, approved);
838     }
839 
840     /**
841      * @dev See {IERC721-isApprovedForAll}.
842      */
843     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
844         return _operatorApprovals[owner][operator];
845     }
846 
847     /**
848      * @dev See {IERC721-transferFrom}.
849      */
850     function transferFrom(
851         address from,
852         address to,
853         uint256 tokenId
854     ) public virtual override {
855         //solhint-disable-next-line max-line-length
856         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
857 
858         _transfer(from, to, tokenId);
859     }
860 
861     /**
862      * @dev See {IERC721-safeTransferFrom}.
863      */
864     function safeTransferFrom(
865         address from,
866         address to,
867         uint256 tokenId
868     ) public virtual override {
869         safeTransferFrom(from, to, tokenId, "");
870     }
871 
872     /**
873      * @dev See {IERC721-safeTransferFrom}.
874      */
875     function safeTransferFrom(
876         address from,
877         address to,
878         uint256 tokenId,
879         bytes memory _data
880     ) public virtual override {
881         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
882         _safeTransfer(from, to, tokenId, _data);
883     }
884 
885     /**
886      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
887      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
888      *
889      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
890      *
891      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
892      * implement alternative mechanisms to perform token transfer, such as signature-based.
893      *
894      * Requirements:
895      *
896      * - `from` cannot be the zero address.
897      * - `to` cannot be the zero address.
898      * - `tokenId` token must exist and be owned by `from`.
899      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
900      *
901      * Emits a {Transfer} event.
902      */
903     function _safeTransfer(
904         address from,
905         address to,
906         uint256 tokenId,
907         bytes memory _data
908     ) internal virtual {
909         _transfer(from, to, tokenId);
910         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
911     }
912 
913     /**
914      * @dev Returns whether `tokenId` exists.
915      *
916      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
917      *
918      * Tokens start existing when they are minted (`_mint`),
919      * and stop existing when they are burned (`_burn`).
920      */
921     function _exists(uint256 tokenId) internal view virtual returns (bool) {
922         return _owners[tokenId] != address(0);
923     }
924 
925     /**
926      * @dev Returns whether `spender` is allowed to manage `tokenId`.
927      *
928      * Requirements:
929      *
930      * - `tokenId` must exist.
931      */
932     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
933         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
934         address owner = ERC721.ownerOf(tokenId);
935         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
936     }
937 
938     /**
939      * @dev Safely mints `tokenId` and transfers it to `to`.
940      *
941      * Requirements:
942      *
943      * - `tokenId` must not exist.
944      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
945      *
946      * Emits a {Transfer} event.
947      */
948     function _safeMint(address to, uint256 tokenId) internal virtual {
949         _safeMint(to, tokenId, "");
950     }
951 
952     /**
953      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
954      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
955      */
956     function _safeMint(
957         address to,
958         uint256 tokenId,
959         bytes memory _data
960     ) internal virtual {
961         _mint(to, tokenId);
962         require(
963             _checkOnERC721Received(address(0), to, tokenId, _data),
964             "ERC721: transfer to non ERC721Receiver implementer"
965         );
966     }
967 
968     /**
969      * @dev Mints `tokenId` and transfers it to `to`.
970      *
971      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
972      *
973      * Requirements:
974      *
975      * - `tokenId` must not exist.
976      * - `to` cannot be the zero address.
977      *
978      * Emits a {Transfer} event.
979      */
980     function _mint(address to, uint256 tokenId) internal virtual {
981         require(to != address(0), "ERC721: mint to the zero address");
982         require(!_exists(tokenId), "ERC721: token already minted");
983 
984         _beforeTokenTransfer(address(0), to, tokenId);
985 
986         _balances[to] += 1;
987         _owners[tokenId] = to;
988 
989         emit Transfer(address(0), to, tokenId);
990     }
991 
992     /**
993      * @dev Destroys `tokenId`.
994      * The approval is cleared when the token is burned.
995      *
996      * Requirements:
997      *
998      * - `tokenId` must exist.
999      *
1000      * Emits a {Transfer} event.
1001      */
1002     function _burn(uint256 tokenId) internal virtual {
1003         address owner = ERC721.ownerOf(tokenId);
1004 
1005         _beforeTokenTransfer(owner, address(0), tokenId);
1006 
1007         // Clear approvals
1008         _approve(address(0), tokenId);
1009 
1010         _balances[owner] -= 1;
1011         delete _owners[tokenId];
1012 
1013         emit Transfer(owner, address(0), tokenId);
1014     }
1015 
1016     /**
1017      * @dev Transfers `tokenId` from `from` to `to`.
1018      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1019      *
1020      * Requirements:
1021      *
1022      * - `to` cannot be the zero address.
1023      * - `tokenId` token must be owned by `from`.
1024      *
1025      * Emits a {Transfer} event.
1026      */
1027     function _transfer(
1028         address from,
1029         address to,
1030         uint256 tokenId
1031     ) internal virtual {
1032         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1033         require(to != address(0), "ERC721: transfer to the zero address");
1034 
1035         _beforeTokenTransfer(from, to, tokenId);
1036 
1037         // Clear approvals from the previous owner
1038         _approve(address(0), tokenId);
1039 
1040         _balances[from] -= 1;
1041         _balances[to] += 1;
1042         _owners[tokenId] = to;
1043 
1044         emit Transfer(from, to, tokenId);
1045     }
1046 
1047     /**
1048      * @dev Approve `to` to operate on `tokenId`
1049      *
1050      * Emits a {Approval} event.
1051      */
1052     function _approve(address to, uint256 tokenId) internal virtual {
1053         _tokenApprovals[tokenId] = to;
1054         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1055     }
1056 
1057     /**
1058      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1059      * The call is not executed if the target address is not a contract.
1060      *
1061      * @param from address representing the previous owner of the given token ID
1062      * @param to target address that will receive the tokens
1063      * @param tokenId uint256 ID of the token to be transferred
1064      * @param _data bytes optional data to send along with the call
1065      * @return bool whether the call correctly returned the expected magic value
1066      */
1067     function _checkOnERC721Received(
1068         address from,
1069         address to,
1070         uint256 tokenId,
1071         bytes memory _data
1072     ) private returns (bool) {
1073         if (to.isContract()) {
1074             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1075                 return retval == IERC721Receiver(to).onERC721Received.selector;
1076             } catch (bytes memory reason) {
1077                 if (reason.length == 0) {
1078                     revert("ERC721: transfer to non ERC721Receiver implementer");
1079                 } else {
1080                     assembly {
1081                         revert(add(32, reason), mload(reason))
1082                     }
1083                 }
1084             }
1085         } else {
1086             return true;
1087         }
1088     }
1089 
1090     /**
1091      * @dev Hook that is called before any token transfer. This includes minting
1092      * and burning.
1093      *
1094      * Calling conditions:
1095      *
1096      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1097      * transferred to `to`.
1098      * - When `from` is zero, `tokenId` will be minted for `to`.
1099      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1100      * - `from` and `to` are never both zero.
1101      *
1102      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1103      */
1104     function _beforeTokenTransfer(
1105         address from,
1106         address to,
1107         uint256 tokenId
1108     ) internal virtual {}
1109 }
1110 
1111 /**
1112  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1113  * @dev See https://eips.ethereum.org/EIPS/eip-721
1114  */
1115 interface IERC721Enumerable is IERC721 {
1116     /**
1117      * @dev Returns the total amount of tokens stored by the contract.
1118      */
1119     function totalSupply() external view returns (uint256);
1120 
1121     /**
1122      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1123      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1124      */
1125     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1126 
1127     /**
1128      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1129      * Use along with {totalSupply} to enumerate all tokens.
1130      */
1131     function tokenByIndex(uint256 index) external view returns (uint256);
1132 }
1133 
1134 /**
1135  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1136  * enumerability of all the token ids in the contract as well as all token ids owned by each
1137  * account.
1138  */
1139 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1140     // Mapping from owner to list of owned token IDs
1141     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1142 
1143     // Mapping from token ID to index of the owner tokens list
1144     mapping(uint256 => uint256) private _ownedTokensIndex;
1145 
1146     // Array with all token ids, used for enumeration
1147     uint256[] private _allTokens;
1148 
1149     // Mapping from token id to position in the allTokens array
1150     mapping(uint256 => uint256) private _allTokensIndex;
1151 
1152     /**
1153      * @dev See {IERC165-supportsInterface}.
1154      */
1155     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1156         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1157     }
1158 
1159     /**
1160      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1161      */
1162     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1163         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1164         return _ownedTokens[owner][index];
1165     }
1166 
1167     /**
1168      * @dev See {IERC721Enumerable-totalSupply}.
1169      */
1170     function totalSupply() public view virtual override returns (uint256) {
1171         return _allTokens.length;
1172     }
1173 
1174     /**
1175      * @dev See {IERC721Enumerable-tokenByIndex}.
1176      */
1177     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1178         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1179         return _allTokens[index];
1180     }
1181 
1182     /**
1183      * @dev Hook that is called before any token transfer. This includes minting
1184      * and burning.
1185      *
1186      * Calling conditions:
1187      *
1188      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1189      * transferred to `to`.
1190      * - When `from` is zero, `tokenId` will be minted for `to`.
1191      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1192      * - `from` cannot be the zero address.
1193      * - `to` cannot be the zero address.
1194      *
1195      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1196      */
1197     function _beforeTokenTransfer(
1198         address from,
1199         address to,
1200         uint256 tokenId
1201     ) internal virtual override {
1202         super._beforeTokenTransfer(from, to, tokenId);
1203 
1204         if (from == address(0)) {
1205             _addTokenToAllTokensEnumeration(tokenId);
1206         } else if (from != to) {
1207             _removeTokenFromOwnerEnumeration(from, tokenId);
1208         }
1209         if (to == address(0)) {
1210             _removeTokenFromAllTokensEnumeration(tokenId);
1211         } else if (to != from) {
1212             _addTokenToOwnerEnumeration(to, tokenId);
1213         }
1214     }
1215 
1216     /**
1217      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1218      * @param to address representing the new owner of the given token ID
1219      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1220      */
1221     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1222         uint256 length = ERC721.balanceOf(to);
1223         _ownedTokens[to][length] = tokenId;
1224         _ownedTokensIndex[tokenId] = length;
1225     }
1226 
1227     /**
1228      * @dev Private function to add a token to this extension's token tracking data structures.
1229      * @param tokenId uint256 ID of the token to be added to the tokens list
1230      */
1231     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1232         _allTokensIndex[tokenId] = _allTokens.length;
1233         _allTokens.push(tokenId);
1234     }
1235 
1236     /**
1237      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1238      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1239      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1240      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1241      * @param from address representing the previous owner of the given token ID
1242      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1243      */
1244     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1245         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1246         // then delete the last slot (swap and pop).
1247 
1248         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1249         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1250 
1251         // When the token to delete is the last token, the swap operation is unnecessary
1252         if (tokenIndex != lastTokenIndex) {
1253             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1254 
1255             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1256             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1257         }
1258 
1259         // This also deletes the contents at the last position of the array
1260         delete _ownedTokensIndex[tokenId];
1261         delete _ownedTokens[from][lastTokenIndex];
1262     }
1263 
1264     /**
1265      * @dev Private function to remove a token from this extension's token tracking data structures.
1266      * This has O(1) time complexity, but alters the order of the _allTokens array.
1267      * @param tokenId uint256 ID of the token to be removed from the tokens list
1268      */
1269     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1270         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1271         // then delete the last slot (swap and pop).
1272 
1273         uint256 lastTokenIndex = _allTokens.length - 1;
1274         uint256 tokenIndex = _allTokensIndex[tokenId];
1275 
1276         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1277         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1278         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1279         uint256 lastTokenId = _allTokens[lastTokenIndex];
1280 
1281         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1282         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1283 
1284         // This also deletes the contents at the last position of the array
1285         delete _allTokensIndex[tokenId];
1286         _allTokens.pop();
1287     }
1288 }
1289 
1290 // Bring on the OnChain Monkeys!
1291 contract OnChainMonkey is ERC721Enumerable, ReentrancyGuard, Ownable {
1292   using Strings for uint256;
1293 
1294   uint256 public constant maxSupply = 10000;
1295   uint256 public numClaimed = 0;
1296   string[] private background = ["656","dda","e92","1eb","663","9de","367","ccc"]; // only trait that is uniform, no need for rarity weights
1297   string[] private fur1 = ["653","532","444","a71","ffc","ca9","f89","777","049","901","fc5","ffe","574","bcc","d04","222","889","7f9","fd1"];
1298   string[] private fur2 = ["532","653","653","653","653","653","653","653","653","653","110","653","711","344","799","555","8a8","32f","653"];
1299   uint8[] private fur_w =[249, 246, 223, 141, 116, 114, 93, 90, 89, 86, 74, 72, 55, 48, 39, 32, 28, 14, 8];
1300   string[] private eyes = ["abe","0a0","653","888","be7","abe","0a0","653","888","be7","cef","abe","0a0","653","888","be7","cef","abe","0a0","653","888","be7","cef"];
1301   uint8[] private eyes_w = [245, 121, 107, 101, 79, 78, 70, 68, 62, 58, 56, 51, 50, 48, 44, 38, 35, 33, 31, 22, 15, 10, 7];
1302   string[] private mouth = ["653","ffc","f89","777","049","901","bcc","d04","fd1","ffc","653","f89","777","049","bcc","901","901","bcc","653","d04","ffc","f89","777","049","fd1","f89","777","bcc","d04","049","ffc","901","fd1"];
1303   uint8[] private mouth_w = [252, 172, 80, 79, 56, 49, 37, 33, 31, 30, 28, 27, 26, 23, 22, 18, 15, 14, 13, 12, 11, 10, 10, 10, 9, 8, 7, 7, 6, 5, 5, 4, 3];
1304   string[] private earring = ["999","fe7","999","999","fe7","bdd"];
1305   uint8[] private earring_w = [251, 32, 29, 17, 16, 8, 5];
1306   string[] private clothes1 = ["f00","f00","222","f00","f00","f00","f00","f00","f00","00f","00f","00f","00f","00f","00f","00f","222","00f","f0f","222","f0f","f0f","f0f","f0f","f0f","f0f","f0f","f80","f80","f80","f80","f80","f00","f80","f80","f80","90f","90f","00f","90f","90f","90f","222"];
1307   string[] private clothes2 = ["d00","00f","f00","f0f","f80","90f","f48","0f0","ff0","f00","00d","f0f","f80","90f","f48","0f0","ddd","ff0","f00","653","00f","d0d","f80","90f","f48","0f0","ff0","f00","f0f","00f","d60","f48","ddd","90f","0f0","ff0","f00","00f","fd1","f0f","f80","70d","fd1"];
1308   uint8[] private clothes_w = [251, 55, 45, 43, 38, 37, 34, 33, 32, 31, 31, 31, 31, 31, 30, 30, 29, 29, 28, 27, 27, 27, 26, 25, 24, 22, 21, 20, 19, 19, 19, 19, 19, 19, 18, 17, 16, 15, 14, 13, 11, 9, 8, 6];
1309   string[] private hat1 = ["f00","f00","f00","f00","f00","f00","f00","00f","00f","00f","00f","00f","00f","00f","f00","f0f","f0f","f0f","f0f","f0f","f0f","f0f","f80","f80","f80","f80","f80","f80","f00","f80","90f","f48","22d","90f","90f","ff0",""];
1310   string[] private hat2 = ["0f0","00f","f80","ff0","90f","f0f","f48","f00","0f0","00f","f80","ff0","90f","f0f","000","f00","0f0","00f","f80","ff0","90f","f0f","f00","0f0","00f","f80","ff0","90f","f00","f0f","f00","000","000","0f0","00f","f48",""];  
1311   uint8[] private hat_w = [251, 64, 47, 42, 39, 38, 36, 35, 34, 34, 33, 29, 28, 26, 26, 25, 25, 25, 22, 21, 20, 20, 18, 17, 17, 15, 14, 14, 13, 13, 12, 12, 12, 10, 9, 8, 7];
1312   string[] private z = ['<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 500 500"><rect x="0" y="0" width="500" height="500" style="fill:#',
1313     '"/><rect width="300" height="120" x="99" y="400" style="fill:#', '"/><circle cx="190" cy="470" r="5" style="fill:#', '"/><circle cx="310" cy="470" r="5" style="fill:#',
1314     '"/><circle cx="100" cy="250" r="50" style="fill:#', '"/><circle cx="100" cy="250" r="20" style="fill:#', '"/><circle cx="400" cy="250" r="50" style="fill:#',
1315     '"/><circle cx="400" cy="250" r="20" style="fill:#', '"/><circle cx="250" cy="250" r="150" style="fill:#', '"/><circle cx="250" cy="250" r="120" style="fill:#',
1316     '"/><circle cx="200" cy="215" r="35" style="fill:#fff"/><circle cx="305" cy="222" r="31" style="fill:#fff"/><circle cx="200" cy="220" r="20" style="fill:#',
1317     '"/><circle cx="300" cy="220" r="20" style="fill:#', '"/><circle cx="200" cy="220" r="7" style="fill:#000"/><circle cx="300" cy="220" r="7" style="fill:#000"/>',
1318     '<ellipse cx="250" cy="315" rx="84" ry="34" style="fill:#',
1319      '"/><rect x="195" y="330" width="110" height="3" style="fill:#000"/><circle cx="268" cy="295" r="5" style="fill:#000"/><circle cx="232" cy="295" r="5" style="fill:#000"/>',
1320     '</svg>'];
1321   string private cross='<rect x="95" y="275" width="10" height="40" style="fill:#872"/><rect x="85" y="285" width="30" height="10" style="fill:#872"/>';
1322   string private clo1='<rect width="300" height="120" x="99" y="400" style="fill:#';
1323   string private clo2='"/><rect width="50" height="55" x="280" y="430" style="fill:#';
1324   string private hh1='<rect width="200" height="99" x="150" y="40" style="fill:#';
1325   string private hh2='"/><rect width="200" height="33" x="150" y="106" style="fill:#';
1326   string private sl1='<rect x="150" y="190" width="200" height="30" style="fill:#';
1327   string private sl2='"/><rect x="160" y="170" width="180" height="50" style="fill:#';
1328   string private mou='<line x1="287" y1="331" x2="320" y2="366" style="stroke:#000;stroke-width:5"/>';
1329   string private ey1='<rect x="160" y="190" width="75" height="15" style="fill:#';
1330   string private ey2='"/><rect x="275" y="190" width="65" height="15" style="fill:#';
1331   string private ey3='<rect x="160" y="235" width="180" height="50" style="fill:#';
1332   string private zz='"/>';
1333   string private ea1='<circle cx="100" cy="290" r="14" style="fill:#';
1334   string private ea2='fe7';
1335   string private ea3='999';
1336   string private ea4='"/><circle cx="100" cy="290" r="4" style="fill:#000"/>';
1337   string private ea5='<circle cx="100" cy="290" r="12" style="fill:#';
1338   string private ea6='bdd';
1339   string private mo1='<line x1="';
1340   string private mo2='" y1="307" x2="';
1341   string private mo3='" y2="312" style="stroke:#000;stroke-width:2"/>';
1342   string private mo4='" y1="317" x2="';
1343   string private mo5='" y2="322" style="stroke:#000;stroke-width:2"/>';
1344   string private tr1='", "attributes": [{"trait_type": "Background","value": "';
1345   string private tr2='"},{"trait_type": "Fur","value": "';
1346   string private tr3='"},{"trait_type": "Earring","value": "';
1347   string private tr4='"},{"trait_type": "Hat","value": "';
1348   string private tr5='"},{"trait_type": "Eyes","value": "';
1349   string private tr6='"},{"trait_type": "Clothes","value": "';
1350   string private tr7='"},{"trait_type": "Mouth","value": "';
1351   string private tr8='"}],"image": "data:image/svg+xml;base64,';
1352   string private ra1='A';
1353   string private ra2='C';
1354   string private ra3='D';
1355   string private ra4='E';
1356   string private ra5='F';
1357   string private ra6='G';
1358   string private co1=', ';
1359   string private rl1='{"name": "OnChain Monkey #';
1360   string private rl3='"}';
1361   string private rl4='data:application/json;base64,';
1362 
1363   struct Ape { // a nod to BAYC, "ape" was shorter to type than monkey
1364     uint8 bg;
1365     uint8 fur;
1366     uint8 eyes;
1367     uint8 mouth;
1368     uint8 earring;
1369     uint8 clothes;
1370     uint8 hat;
1371   }
1372 
1373   // this was used to create the distributon of 10,000 and tested for uniqueness for the given parameters of this collection
1374   function random(string memory input) internal pure returns (uint256) {
1375     return uint256(keccak256(abi.encodePacked(input)));
1376   }
1377 
1378   function usew(uint8[] memory w,uint256 i) internal pure returns (uint8) {
1379     uint8 ind=0;
1380     uint256 j=uint256(w[0]);
1381     while (j<=i) {
1382       ind++;
1383       j+=uint256(w[ind]);
1384     }
1385     return ind;
1386   }
1387 
1388   function randomOne(uint256 tokenId) internal view returns (Ape memory) {
1389     tokenId=12839-tokenId; // avoid dupes
1390     Ape memory ape;
1391     ape.bg = uint8(random(string(abi.encodePacked(ra1,tokenId.toString()))) % 8);
1392     ape.fur = usew(fur_w,random(string(abi.encodePacked(clo1,tokenId.toString())))%1817);
1393     ape.eyes = usew(eyes_w,random(string(abi.encodePacked(ra2,tokenId.toString())))%1429);
1394     ape.mouth = usew(mouth_w,random(string(abi.encodePacked(ra3,tokenId.toString())))%1112);
1395     ape.earring = usew(earring_w,random(string(abi.encodePacked(ra4,tokenId.toString())))%358);
1396     ape.clothes = usew(clothes_w,random(string(abi.encodePacked(ra5,tokenId.toString())))%1329);
1397     ape.hat = usew(hat_w,random(string(abi.encodePacked(ra6,tokenId.toString())))%1111);
1398     if (tokenId==7403) {
1399       ape.hat++; // perturb dupe
1400     }
1401     return ape;
1402   }
1403 
1404   // get string attributes of properties, used in tokenURI call
1405   function getTraits(Ape memory ape) internal view returns (string memory) {
1406     string memory o=string(abi.encodePacked(tr1,uint256(ape.bg).toString(),tr2,uint256(ape.fur).toString(),tr3,uint256(ape.earring).toString()));
1407     return string(abi.encodePacked(o,tr4,uint256(ape.hat).toString(),tr5,uint256(ape.eyes).toString(),tr6,uint256(ape.clothes).toString(),tr7,uint256(ape.mouth).toString(),tr8));
1408   }
1409 
1410   // return comma separated traits in order: hat, fur, clothes, eyes, earring, mouth, background
1411   function getAttributes(uint256 tokenId) public view returns (string memory) {
1412     Ape memory ape = randomOne(tokenId);
1413     string memory o=string(abi.encodePacked(uint256(ape.hat).toString(),co1,uint256(ape.fur).toString(),co1,uint256(ape.clothes).toString(),co1));
1414     return string(abi.encodePacked(o,uint256(ape.eyes).toString(),co1,uint256(ape.earring).toString(),co1,uint256(ape.mouth).toString(),co1,uint256(ape.bg).toString()));
1415   }
1416 
1417   function genEye(string memory a,string memory b,uint8 h) internal view returns (string memory) {
1418     string memory out = '';
1419     if (h>4) { out = string(abi.encodePacked(sl1,a,sl2,a,zz)); }
1420     if (h>10) { out = string(abi.encodePacked(out,ey1,b,ey2,b,zz)); }
1421     if (h>16) { out = string(abi.encodePacked(out,ey3,a,zz)); }
1422     return out;
1423   }
1424 
1425   function genMouth(uint8 h) internal view returns (string memory) {
1426     string memory out = '';
1427     uint i;
1428     if ((h>24) || ((h>8) && (h<16))) {
1429       for (i=0;i<7;i++) {
1430         out = string(abi.encodePacked(out,mo1,(175+i*25).toString(),mo2,(175+i*25).toString(),mo3));
1431       }
1432       for (i=0;i<6;i++) {
1433         out = string(abi.encodePacked(out,mo1,(187+i*25).toString(),mo4,(187+i*25).toString(),mo5));
1434       }
1435     }
1436     if (h>15) {
1437       out = string(abi.encodePacked(out,mou));
1438     }
1439     return out;
1440   }
1441 
1442   function genEarring(uint8 h) internal view returns (string memory) {
1443     if (h==0) {
1444       return '';
1445     }
1446     if (h<3) {
1447       if (h>1) {
1448         return string(abi.encodePacked(ea1,ea2,ea4));
1449       } 
1450       return string(abi.encodePacked(ea1,ea3,ea4));
1451     }
1452     if (h>3) {
1453       if (h>5) {
1454         return string(abi.encodePacked(ea5,ea6,zz));
1455       } 
1456       if (h>4) {
1457         return string(abi.encodePacked(ea5,ea2,zz));
1458       } 
1459       return string(abi.encodePacked(ea5,ea3,zz));
1460     }
1461     return cross;
1462   }
1463 
1464   function genSVG(Ape memory ape) internal view returns (string memory) {
1465     string memory a=fur1[ape.fur];
1466     string memory b=fur2[ape.fur];
1467     string memory hatst='';
1468     string memory clost='';
1469     if (ape.clothes>0) {
1470       clost=string(abi.encodePacked(clo1,clothes1[ape.clothes-1],clo2,clothes2[ape.clothes-1],zz));
1471     }
1472     if (ape.hat>0) {
1473       hatst=string(abi.encodePacked(hh1,hat1[ape.hat-1],hh2,hat2[ape.hat-1],zz));
1474     }
1475     string memory output = string(abi.encodePacked(z[0],background[ape.bg],z[1],b,z[2]));
1476     output = string(abi.encodePacked(output,a,z[3],a,z[4],b,z[5],a,z[6]));
1477     output = string(abi.encodePacked(output,b,z[7],a,z[8],b,z[9],a,z[10]));
1478     output = string(abi.encodePacked(output,eyes[ape.eyes],z[11],eyes[ape.eyes],z[12],genEye(a,b,ape.eyes),z[13],mouth[ape.mouth],z[14]));
1479     return string(abi.encodePacked(output,genMouth(ape.mouth),genEarring(ape.earring),hatst,clost,z[15]));
1480   }
1481 
1482   function tokenURI(uint256 tokenId) override public view returns (string memory) {
1483     Ape memory ape = randomOne(tokenId);
1484     return string(abi.encodePacked(rl4,Base64.encode(bytes(string(abi.encodePacked(rl1,tokenId.toString(),getTraits(ape),Base64.encode(bytes(genSVG(ape))),rl3))))));
1485   }
1486 
1487   function claim() public nonReentrant {
1488     require(numClaimed >= 0 && numClaimed < 9500, "invalid claim");
1489     _safeMint(_msgSender(), numClaimed + 1);
1490     numClaimed += 1;
1491   }
1492     
1493   function ownerClaim(uint256 tokenId) public nonReentrant onlyOwner {
1494     require(tokenId > 9500 && tokenId < 10001, "invalid claim");
1495     _safeMint(owner(), tokenId);
1496   }
1497     
1498   constructor() ERC721("OnChainMonkey", "OCMONK") Ownable() {}
1499 }