1 // SPDX-License-Identifier: MIT
2 
3                                                                                                                                          
4                                                                                 
5 //             &&&&&&&&&&&&&&&&&&&&&&&&&&&@&&&&&&&&&&&&&&&&&&&&&&&&&&&            
6 //             &@@&@@@&@@@&@@&&@@@&@@@&@@@@@@@@@@@@&@@@&@@@&@@@&@@@&@&            
7 //              @@&@@@&@@&&@@@&@@@&@@@&@@@@@@@@@@@@&@@@&@@@&@@@&@@@@@             
8 //             &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&@@@@@@@@@@@&&&&            
9 //             &&&    &    &&&@&@//////*////////////@&@&&&&&&     .&&&            
10 //             &&(     @ @@@/ @&@                   @&@ .&&&&@@    &&&            
11 //             &%    .  @@@   @&@     V / H / S     @&@   @@@@@     &&            
12 //             &&@        &&& @&@ @@@@@@@@@@@@@@@@@ @&@.@@@@&&     @&&            
13 //             &&&@          &@&&@///////////////*/@&&@@@@&&@     @&%&            
14 //             &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&            
15 //             @@@&@@@&@@&&@@@&@@@&@@@&@@@@@&@@@@@@@@@@&@@@&@@@&@@@&@@            
16 //             @@@&@@@&&@@&@@@&@@@&@@@&@@@@@@@@@@@@@@@@&@@@&@@@&@@@&@@   
17 //                                   
18 //                                   DO NOT LOOK
19 /*
20                                                                                
21 V/H/S - Do not look
22 1983 Unique Nfts
23 Price 0.005
24 WARNING
25 This NFT has not been rated because of its brutal and explicit depiction of actual death.
26 The content and subject matter may not be suitable for those under 18, those with weak hearts, and those of delicate nature.
27 
28 */
29                                                                                 
30                                                                             
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @title ERC721 token receiver interface
35  * @dev Interface for any contract that wants to support safeTransfers
36  * from ERC721 asset contracts.
37  */
38 interface IERC721Receiver {
39     /**
40      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
41      * by `operator` from `from`, this function is called.
42      *
43      * It must return its Solidity selector to confirm the token transfer.
44      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
45      *
46      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
47      */
48     function onERC721Received(
49         address operator,
50         address from,
51         uint256 tokenId,
52         bytes calldata data
53     ) external returns (bytes4);
54 }
55 
56 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
57 
58 
59 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
60 
61 pragma solidity ^0.8.0;
62 
63 /**
64  * @dev Interface of the ERC165 standard, as defined in the
65  * https://eips.ethereum.org/EIPS/eip-165[EIP].
66  *
67  * Implementers can declare support of contract interfaces, which can then be
68  * queried by others ({ERC165Checker}).
69  *
70  * For an implementation, see {ERC165}.
71  */
72 interface IERC165 {
73     /**
74      * @dev Returns true if this contract implements the interface defined by
75      * `interfaceId`. See the corresponding
76      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
77      * to learn more about how these ids are created.
78      *
79      * This function call must use less than 30 000 gas.
80      */
81     function supportsInterface(bytes4 interfaceId) external view returns (bool);
82 }
83 
84 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
85 
86 
87 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
88 
89 pragma solidity ^0.8.0;
90 
91 
92 /**
93  * @dev Implementation of the {IERC165} interface.
94  *
95  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
96  * for the additional interface id that will be supported. For example:
97  *
98  * ```solidity
99  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
100  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
101  * }
102  * ```
103  *
104  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
105  */
106 abstract contract ERC165 is IERC165 {
107     /**
108      * @dev See {IERC165-supportsInterface}.
109      */
110     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
111         return interfaceId == type(IERC165).interfaceId;
112     }
113 }
114 
115 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
116 
117 
118 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
119 
120 pragma solidity ^0.8.0;
121 
122 
123 /**
124  * @dev Required interface of an ERC721 compliant contract.
125  */
126 interface IERC721 is IERC165 {
127     /**
128      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
129      */
130     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
131 
132     /**
133      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
134      */
135     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
136 
137     /**
138      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
139      */
140     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
141 
142     /**
143      * @dev Returns the number of tokens in ``owner``'s account.
144      */
145     function balanceOf(address owner) external view returns (uint256 balance);
146 
147     /**
148      * @dev Returns the owner of the `tokenId` token.
149      *
150      * Requirements:
151      *
152      * - `tokenId` must exist.
153      */
154     function ownerOf(uint256 tokenId) external view returns (address owner);
155 
156     /**
157      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
158      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
159      *
160      * Requirements:
161      *
162      * - `from` cannot be the zero address.
163      * - `to` cannot be the zero address.
164      * - `tokenId` token must exist and be owned by `from`.
165      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
166      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
167      *
168      * Emits a {Transfer} event.
169      */
170     function safeTransferFrom(
171         address from,
172         address to,
173         uint256 tokenId
174     ) external;
175 
176     /**
177      * @dev Transfers `tokenId` token from `from` to `to`.
178      *
179      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
180      *
181      * Requirements:
182      *
183      * - `from` cannot be the zero address.
184      * - `to` cannot be the zero address.
185      * - `tokenId` token must be owned by `from`.
186      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
187      *
188      * Emits a {Transfer} event.
189      */
190     function transferFrom(
191         address from,
192         address to,
193         uint256 tokenId
194     ) external;
195 
196     /**
197      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
198      * The approval is cleared when the token is transferred.
199      *
200      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
201      *
202      * Requirements:
203      *
204      * - The caller must own the token or be an approved operator.
205      * - `tokenId` must exist.
206      *
207      * Emits an {Approval} event.
208      */
209     function approve(address to, uint256 tokenId) external;
210 
211     /**
212      * @dev Returns the account approved for `tokenId` token.
213      *
214      * Requirements:
215      *
216      * - `tokenId` must exist.
217      */
218     function getApproved(uint256 tokenId) external view returns (address operator);
219 
220     /**
221      * @dev Approve or remove `operator` as an operator for the caller.
222      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
223      *
224      * Requirements:
225      *
226      * - The `operator` cannot be the caller.
227      *
228      * Emits an {ApprovalForAll} event.
229      */
230     function setApprovalForAll(address operator, bool _approved) external;
231 
232     /**
233      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
234      *
235      * See {setApprovalForAll}
236      */
237     function isApprovedForAll(address owner, address operator) external view returns (bool);
238 
239     /**
240      * @dev Safely transfers `tokenId` token from `from` to `to`.
241      *
242      * Requirements:
243      *
244      * - `from` cannot be the zero address.
245      * - `to` cannot be the zero address.
246      * - `tokenId` token must exist and be owned by `from`.
247      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
248      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
249      *
250      * Emits a {Transfer} event.
251      */
252     function safeTransferFrom(
253         address from,
254         address to,
255         uint256 tokenId,
256         bytes calldata data
257     ) external;
258 }
259 
260 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
261 
262 
263 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
264 
265 pragma solidity ^0.8.0;
266 
267 /**
268  * @dev String operations.
269  */
270 library Strings {
271     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
272 
273     /**
274      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
275      */
276     function toString(uint256 value) internal pure returns (string memory) {
277         // Inspired by OraclizeAPI's implementation - MIT licence
278         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
279 
280         if (value == 0) {
281             return "0";
282         }
283         uint256 temp = value;
284         uint256 digits;
285         while (temp != 0) {
286             digits++;
287             temp /= 10;
288         }
289         bytes memory buffer = new bytes(digits);
290         while (value != 0) {
291             digits -= 1;
292             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
293             value /= 10;
294         }
295         return string(buffer);
296     }
297 
298     /**
299      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
300      */
301     function toHexString(uint256 value) internal pure returns (string memory) {
302         if (value == 0) {
303             return "0x00";
304         }
305         uint256 temp = value;
306         uint256 length = 0;
307         while (temp != 0) {
308             length++;
309             temp >>= 8;
310         }
311         return toHexString(value, length);
312     }
313 
314     /**
315      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
316      */
317     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
318         bytes memory buffer = new bytes(2 * length + 2);
319         buffer[0] = "0";
320         buffer[1] = "x";
321         for (uint256 i = 2 * length + 1; i > 1; --i) {
322             buffer[i] = _HEX_SYMBOLS[value & 0xf];
323             value >>= 4;
324         }
325         require(value == 0, "Strings: hex length insufficient");
326         return string(buffer);
327     }
328 }
329 
330 // File: @openzeppelin/contracts/utils/Context.sol
331 
332 
333 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
334 
335 pragma solidity ^0.8.0;
336 
337 /**
338  * @dev Provides information about the current execution context, including the
339  * sender of the transaction and its data. While these are generally available
340  * via msg.sender and msg.data, they should not be accessed in such a direct
341  * manner, since when dealing with meta-transactions the account sending and
342  * paying for execution may not be the actual sender (as far as an application
343  * is concerned).
344  *
345  * This contract is only required for intermediate, library-like contracts.
346  */
347 abstract contract Context {
348     function _msgSender() internal view virtual returns (address) {
349         return msg.sender;
350     }
351 
352     function _msgData() internal view virtual returns (bytes calldata) {
353         return msg.data;
354     }
355 }
356 
357 // File: @openzeppelin/contracts/access/Ownable.sol
358 
359 
360 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
361 
362 pragma solidity ^0.8.0;
363 
364 
365 /**
366  * @dev Contract module which provides a basic access control mechanism, where
367  * there is an account (an owner) that can be granted exclusive access to
368  * specific functions.
369  *
370  * By default, the owner account will be the one that deploys the contract. This
371  * can later be changed with {transferOwnership}.
372  *
373  * This module is used through inheritance. It will make available the modifier
374  * `onlyOwner`, which can be applied to your functions to restrict their use to
375  * the owner.
376  */
377 abstract contract Ownable is Context {
378     address private _owner;
379 
380     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
381 
382     /**
383      * @dev Initializes the contract setting the deployer as the initial owner.
384      */
385     constructor() {
386         _transferOwnership(_msgSender());
387     }
388 
389     /**
390      * @dev Returns the address of the current owner.
391      */
392     function owner() public view virtual returns (address) {
393         return _owner;
394     }
395 
396     /**
397      * @dev Throws if called by any account other than the owner.
398      */
399     modifier onlyOwner() {
400         require(owner() == _msgSender(), "Ownable: caller is not the owner");
401         _;
402     }
403 
404     /**
405      * @dev Leaves the contract without owner. It will not be possible to call
406      * `onlyOwner` functions anymore. Can only be called by the current owner.
407      *
408      * NOTE: Renouncing ownership will leave the contract without an owner,
409      * thereby removing any functionality that is only available to the owner.
410      */
411     function renounceOwnership() public virtual onlyOwner {
412         _transferOwnership(address(0));
413     }
414 
415     /**
416      * @dev Transfers ownership of the contract to a new account (`newOwner`).
417      * Can only be called by the current owner.
418      */
419     function transferOwnership(address newOwner) public virtual onlyOwner {
420         require(newOwner != address(0), "Ownable: new owner is the zero address");
421         _transferOwnership(newOwner);
422     }
423 
424     /**
425      * @dev Transfers ownership of the contract to a new account (`newOwner`).
426      * Internal function without access restriction.
427      */
428     function _transferOwnership(address newOwner) internal virtual {
429         address oldOwner = _owner;
430         _owner = newOwner;
431         emit OwnershipTransferred(oldOwner, newOwner);
432     }
433 }
434 
435 // File: @openzeppelin/contracts/utils/Address.sol
436 
437 
438 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
439 
440 pragma solidity ^0.8.0;
441 
442 /**
443  * @dev Collection of functions related to the address type
444  */
445 library Address {
446     /**
447      * @dev Returns true if `account` is a contract.
448      *
449      * [IMPORTANT]
450      * ====
451      * It is unsafe to assume that an address for which this function returns
452      * false is an externally-owned account (EOA) and not a contract.
453      *
454      * Among others, `isContract` will return false for the following
455      * types of addresses:
456      *
457      *  - an externally-owned account
458      *  - a contract in construction
459      *  - an address where a contract will be created
460      *  - an address where a contract lived, but was destroyed
461      * ====
462      */
463     function isContract(address account) internal view returns (bool) {
464         // This method relies on extcodesize, which returns 0 for contracts in
465         // construction, since the code is only stored at the end of the
466         // constructor execution.
467 
468         uint256 size;
469         assembly {
470             size := extcodesize(account)
471         }
472         return size > 0;
473     }
474 
475     /**
476      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
477      * `recipient`, forwarding all available gas and reverting on errors.
478      *
479      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
480      * of certain opcodes, possibly making contracts go over the 2300 gas limit
481      * imposed by `transfer`, making them unable to receive funds via
482      * `transfer`. {sendValue} removes this limitation.
483      *
484      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
485      *
486      * IMPORTANT: because control is transferred to `recipient`, care must be
487      * taken to not create reentrancy vulnerabilities. Consider using
488      * {ReentrancyGuard} or the
489      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
490      */
491     function sendValue(address payable recipient, uint256 amount) internal {
492         require(address(this).balance >= amount, "Address: insufficient balance");
493 
494         (bool success, ) = recipient.call{value: amount}("");
495         require(success, "Address: unable to send value, recipient may have reverted");
496     }
497 
498     /**
499      * @dev Performs a Solidity function call using a low level `call`. A
500      * plain `call` is an unsafe replacement for a function call: use this
501      * function instead.
502      *
503      * If `target` reverts with a revert reason, it is bubbled up by this
504      * function (like regular Solidity function calls).
505      *
506      * Returns the raw returned data. To convert to the expected return value,
507      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
508      *
509      * Requirements:
510      *
511      * - `target` must be a contract.
512      * - calling `target` with `data` must not revert.
513      *
514      * _Available since v3.1._
515      */
516     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
517         return functionCall(target, data, "Address: low-level call failed");
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
522      * `errorMessage` as a fallback revert reason when `target` reverts.
523      *
524      * _Available since v3.1._
525      */
526     function functionCall(
527         address target,
528         bytes memory data,
529         string memory errorMessage
530     ) internal returns (bytes memory) {
531         return functionCallWithValue(target, data, 0, errorMessage);
532     }
533 
534     /**
535      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
536      * but also transferring `value` wei to `target`.
537      *
538      * Requirements:
539      *
540      * - the calling contract must have an ETH balance of at least `value`.
541      * - the called Solidity function must be `payable`.
542      *
543      * _Available since v3.1._
544      */
545     function functionCallWithValue(
546         address target,
547         bytes memory data,
548         uint256 value
549     ) internal returns (bytes memory) {
550         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
551     }
552 
553     /**
554      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
555      * with `errorMessage` as a fallback revert reason when `target` reverts.
556      *
557      * _Available since v3.1._
558      */
559     function functionCallWithValue(
560         address target,
561         bytes memory data,
562         uint256 value,
563         string memory errorMessage
564     ) internal returns (bytes memory) {
565         require(address(this).balance >= value, "Address: insufficient balance for call");
566         require(isContract(target), "Address: call to non-contract");
567 
568         (bool success, bytes memory returndata) = target.call{value: value}(data);
569         return verifyCallResult(success, returndata, errorMessage);
570     }
571 
572     /**
573      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
574      * but performing a static call.
575      *
576      * _Available since v3.3._
577      */
578     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
579         return functionStaticCall(target, data, "Address: low-level static call failed");
580     }
581 
582     /**
583      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
584      * but performing a static call.
585      *
586      * _Available since v3.3._
587      */
588     function functionStaticCall(
589         address target,
590         bytes memory data,
591         string memory errorMessage
592     ) internal view returns (bytes memory) {
593         require(isContract(target), "Address: static call to non-contract");
594 
595         (bool success, bytes memory returndata) = target.staticcall(data);
596         return verifyCallResult(success, returndata, errorMessage);
597     }
598 
599     /**
600      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
601      * but performing a delegate call.
602      *
603      * _Available since v3.4._
604      */
605     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
606         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
607     }
608 
609     /**
610      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
611      * but performing a delegate call.
612      *
613      * _Available since v3.4._
614      */
615     function functionDelegateCall(
616         address target,
617         bytes memory data,
618         string memory errorMessage
619     ) internal returns (bytes memory) {
620         require(isContract(target), "Address: delegate call to non-contract");
621 
622         (bool success, bytes memory returndata) = target.delegatecall(data);
623         return verifyCallResult(success, returndata, errorMessage);
624     }
625 
626     /**
627      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
628      * revert reason using the provided one.
629      *
630      * _Available since v4.3._
631      */
632     function verifyCallResult(
633         bool success,
634         bytes memory returndata,
635         string memory errorMessage
636     ) internal pure returns (bytes memory) {
637         if (success) {
638             return returndata;
639         } else {
640             // Look for revert reason and bubble it up if present
641             if (returndata.length > 0) {
642                 // The easiest way to bubble the revert reason is using memory via assembly
643 
644                 assembly {
645                     let returndata_size := mload(returndata)
646                     revert(add(32, returndata), returndata_size)
647                 }
648             } else {
649                 revert(errorMessage);
650             }
651         }
652     }
653 }
654 
655 
656 
657 pragma solidity ^0.8.0;
658 
659 
660 /**
661  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
662  * @dev See https://eips.ethereum.org/EIPS/eip-721
663  */
664 interface IERC721Enumerable is IERC721 {
665     /**
666      * @dev Returns the total amount of tokens stored by the contract.
667      */
668     function totalSupply() external view returns (uint256);
669 
670     /**
671      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
672      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
673      */
674     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
675 
676     /**
677      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
678      * Use along with {totalSupply} to enumerate all tokens.
679      */
680     function tokenByIndex(uint256 index) external view returns (uint256);
681 }
682 
683 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
684 
685 
686 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
687 
688 pragma solidity ^0.8.0;
689 
690 
691 /**
692  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
693  * @dev See https://eips.ethereum.org/EIPS/eip-721
694  */
695 interface IERC721Metadata is IERC721 {
696     /**
697      * @dev Returns the token collection name.
698      */
699     function name() external view returns (string memory);
700 
701     /**
702      * @dev Returns the token collection symbol.
703      */
704     function symbol() external view returns (string memory);
705 
706     /**
707      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
708      */
709     function tokenURI(uint256 tokenId) external view returns (string memory);
710 }
711 
712 
713 pragma solidity ^0.8.0;
714 
715 
716 /**
717  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
718  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
719  *
720  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
721  *
722  * Does not support burning tokens to address(0).
723  *
724  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
725  */
726 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
727     using Address for address;
728     using Strings for uint256;
729 
730     struct TokenOwnership {
731         address addr;
732         uint64 startTimestamp;
733     }
734 
735     struct AddressData {
736         uint128 balance;
737         uint128 numberMinted;
738     }
739 
740     uint256 internal currentIndex = 0;
741 
742     uint256 internal immutable maxBatchSize;
743 
744     // Token name
745     string private _name;
746 
747     // Token symbol
748     string private _symbol;
749 
750     // Mapping from token ID to ownership details
751     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
752     mapping(uint256 => TokenOwnership) internal _ownerships;
753 
754     // Mapping owner address to address data
755     mapping(address => AddressData) private _addressData;
756 
757     // Mapping from token ID to approved address
758     mapping(uint256 => address) private _tokenApprovals;
759 
760     // Mapping from owner to operator approvals
761     mapping(address => mapping(address => bool)) private _operatorApprovals;
762 
763     /**
764      * @dev
765      * `maxBatchSize` refers to how much a minter can mint at a time.
766      */
767     constructor(
768         string memory name_,
769         string memory symbol_,
770         uint256 maxBatchSize_
771     ) {
772         require(maxBatchSize_ > 0, 'ERC721A: max batch size must be nonzero');
773         _name = name_;
774         _symbol = symbol_;
775         maxBatchSize = maxBatchSize_;
776     }
777 
778     /**
779      * @dev See {IERC721Enumerable-totalSupply}.
780      */
781     function totalSupply() public view override returns (uint256) {
782         return currentIndex;
783     }
784 
785     /**
786      * @dev See {IERC721Enumerable-tokenByIndex}.
787      */
788     function tokenByIndex(uint256 index) public view override returns (uint256) {
789         require(index < totalSupply(), 'ERC721A: global index out of bounds');
790         return index;
791     }
792 
793     /**
794      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
795      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
796      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
797      */
798     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
799         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
800         uint256 numMintedSoFar = totalSupply();
801         uint256 tokenIdsIdx = 0;
802         address currOwnershipAddr = address(0);
803         for (uint256 i = 0; i < numMintedSoFar; i++) {
804             TokenOwnership memory ownership = _ownerships[i];
805             if (ownership.addr != address(0)) {
806                 currOwnershipAddr = ownership.addr;
807             }
808             if (currOwnershipAddr == owner) {
809                 if (tokenIdsIdx == index) {
810                     return i;
811                 }
812                 tokenIdsIdx++;
813             }
814         }
815         revert('ERC721A: unable to get token of owner by index');
816     }
817 
818     /**
819      * @dev See {IERC165-supportsInterface}.
820      */
821     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
822         return
823             interfaceId == type(IERC721).interfaceId ||
824             interfaceId == type(IERC721Metadata).interfaceId ||
825             interfaceId == type(IERC721Enumerable).interfaceId ||
826             super.supportsInterface(interfaceId);
827     }
828 
829     /**
830      * @dev See {IERC721-balanceOf}.
831      */
832     function balanceOf(address owner) public view override returns (uint256) {
833         require(owner != address(0), 'ERC721A: balance query for the zero address');
834         return uint256(_addressData[owner].balance);
835     }
836 
837     function _numberMinted(address owner) internal view returns (uint256) {
838         require(owner != address(0), 'ERC721A: number minted query for the zero address');
839         return uint256(_addressData[owner].numberMinted);
840     }
841 
842     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
843         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
844 
845         uint256 lowestTokenToCheck;
846         if (tokenId >= maxBatchSize) {
847             lowestTokenToCheck = tokenId - maxBatchSize + 1;
848         }
849 
850         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
851             TokenOwnership memory ownership = _ownerships[curr];
852             if (ownership.addr != address(0)) {
853                 return ownership;
854             }
855         }
856 
857         revert('ERC721A: unable to determine the owner of token');
858     }
859 
860     /**
861      * @dev See {IERC721-ownerOf}.
862      */
863     function ownerOf(uint256 tokenId) public view override returns (address) {
864         return ownershipOf(tokenId).addr;
865     }
866 
867     /**
868      * @dev See {IERC721Metadata-name}.
869      */
870     function name() public view virtual override returns (string memory) {
871         return _name;
872     }
873 
874     /**
875      * @dev See {IERC721Metadata-symbol}.
876      */
877     function symbol() public view virtual override returns (string memory) {
878         return _symbol;
879     }
880 
881     /**
882      * @dev See {IERC721Metadata-tokenURI}.
883      */
884     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
885         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
886 
887         string memory baseURI = _baseURI();
888         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
889     }
890 
891     /**
892      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
893      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
894      * by default, can be overriden in child contracts.
895      */
896     function _baseURI() internal view virtual returns (string memory) {
897         return '';
898     }
899 
900     /**
901      * @dev See {IERC721-approve}.
902      */
903     function approve(address to, uint256 tokenId) public override {
904         address owner = ERC721A.ownerOf(tokenId);
905         require(to != owner, 'ERC721A: approval to current owner');
906 
907         require(
908             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
909             'ERC721A: approve caller is not owner nor approved for all'
910         );
911 
912         _approve(to, tokenId, owner);
913     }
914 
915     /**
916      * @dev See {IERC721-getApproved}.
917      */
918     function getApproved(uint256 tokenId) public view override returns (address) {
919         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
920 
921         return _tokenApprovals[tokenId];
922     }
923 
924     /**
925      * @dev See {IERC721-setApprovalForAll}.
926      */
927     function setApprovalForAll(address operator, bool approved) public override {
928         require(operator != _msgSender(), 'ERC721A: approve to caller');
929 
930         _operatorApprovals[_msgSender()][operator] = approved;
931         emit ApprovalForAll(_msgSender(), operator, approved);
932     }
933 
934     /**
935      * @dev See {IERC721-isApprovedForAll}.
936      */
937     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
938         return _operatorApprovals[owner][operator];
939     }
940 
941     /**
942      * @dev See {IERC721-transferFrom}.
943      */
944     function transferFrom(
945         address from,
946         address to,
947         uint256 tokenId
948     ) public override {
949         _transfer(from, to, tokenId);
950     }
951 
952     /**
953      * @dev See {IERC721-safeTransferFrom}.
954      */
955     function safeTransferFrom(
956         address from,
957         address to,
958         uint256 tokenId
959     ) public override {
960         safeTransferFrom(from, to, tokenId, '');
961     }
962 
963     /**
964      * @dev See {IERC721-safeTransferFrom}.
965      */
966     function safeTransferFrom(
967         address from,
968         address to,
969         uint256 tokenId,
970         bytes memory _data
971     ) public override {
972         _transfer(from, to, tokenId);
973         require(
974             _checkOnERC721Received(from, to, tokenId, _data),
975             'ERC721A: transfer to non ERC721Receiver implementer'
976         );
977     }
978 
979     /**
980      * @dev Returns whether `tokenId` exists.
981      *
982      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
983      *
984      * Tokens start existing when they are minted (`_mint`),
985      */
986     function _exists(uint256 tokenId) internal view returns (bool) {
987         return tokenId < currentIndex;
988     }
989 
990     function _safeMint(address to, uint256 quantity) internal {
991         _safeMint(to, quantity, '');
992     }
993 
994     /**
995      * @dev Mints `quantity` tokens and transfers them to `to`.
996      *
997      * Requirements:
998      *
999      * - `to` cannot be the zero address.
1000      * - `quantity` cannot be larger than the max batch size.
1001      *
1002      * Emits a {Transfer} event.
1003      */
1004     function _safeMint(
1005         address to,
1006         uint256 quantity,
1007         bytes memory _data
1008     ) internal {
1009         uint256 startTokenId = currentIndex;
1010         require(to != address(0), 'ERC721A: mint to the zero address');
1011         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1012         require(!_exists(startTokenId), 'ERC721A: token already minted');
1013         require(quantity <= maxBatchSize, 'ERC721A: quantity to mint too high');
1014         require(quantity > 0, 'ERC721A: quantity must be greater 0');
1015 
1016         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1017 
1018         AddressData memory addressData = _addressData[to];
1019         _addressData[to] = AddressData(
1020             addressData.balance + uint128(quantity),
1021             addressData.numberMinted + uint128(quantity)
1022         );
1023         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1024 
1025         uint256 updatedIndex = startTokenId;
1026 
1027         for (uint256 i = 0; i < quantity; i++) {
1028             emit Transfer(address(0), to, updatedIndex);
1029             require(
1030                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1031                 'ERC721A: transfer to non ERC721Receiver implementer'
1032             );
1033             updatedIndex++;
1034         }
1035 
1036         currentIndex = updatedIndex;
1037         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1038     }
1039 
1040     /**
1041      * @dev Transfers `tokenId` from `from` to `to`.
1042      *
1043      * Requirements:
1044      *
1045      * - `to` cannot be the zero address.
1046      * - `tokenId` token must be owned by `from`.
1047      *
1048      * Emits a {Transfer} event.
1049      */
1050     function _transfer(
1051         address from,
1052         address to,
1053         uint256 tokenId
1054     ) private {
1055         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1056 
1057         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1058             getApproved(tokenId) == _msgSender() ||
1059             isApprovedForAll(prevOwnership.addr, _msgSender()));
1060 
1061         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1062 
1063         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1064         require(to != address(0), 'ERC721A: transfer to the zero address');
1065 
1066         _beforeTokenTransfers(from, to, tokenId, 1);
1067 
1068         // Clear approvals from the previous owner
1069         _approve(address(0), tokenId, prevOwnership.addr);
1070 
1071         // Underflow of the sender's balance is impossible because we check for
1072         // ownership above and the recipient's balance can't realistically overflow.
1073         unchecked {
1074             _addressData[from].balance -= 1;
1075             _addressData[to].balance += 1;
1076         }
1077 
1078         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1079 
1080         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1081         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1082         uint256 nextTokenId = tokenId + 1;
1083         if (_ownerships[nextTokenId].addr == address(0)) {
1084             if (_exists(nextTokenId)) {
1085                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1086             }
1087         }
1088 
1089         emit Transfer(from, to, tokenId);
1090         _afterTokenTransfers(from, to, tokenId, 1);
1091     }
1092 
1093     /**
1094      * @dev Approve `to` to operate on `tokenId`
1095      *
1096      * Emits a {Approval} event.
1097      */
1098     function _approve(
1099         address to,
1100         uint256 tokenId,
1101         address owner
1102     ) private {
1103         _tokenApprovals[tokenId] = to;
1104         emit Approval(owner, to, tokenId);
1105     }
1106 
1107     /**
1108      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1109      * The call is not executed if the target address is not a contract.
1110      *
1111      * @param from address representing the previous owner of the given token ID
1112      * @param to target address that will receive the tokens
1113      * @param tokenId uint256 ID of the token to be transferred
1114      * @param _data bytes optional data to send along with the call
1115      * @return bool whether the call correctly returned the expected magic value
1116      */
1117     function _checkOnERC721Received(
1118         address from,
1119         address to,
1120         uint256 tokenId,
1121         bytes memory _data
1122     ) private returns (bool) {
1123         if (to.isContract()) {
1124             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1125                 return retval == IERC721Receiver(to).onERC721Received.selector;
1126             } catch (bytes memory reason) {
1127                 if (reason.length == 0) {
1128                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1129                 } else {
1130                     assembly {
1131                         revert(add(32, reason), mload(reason))
1132                     }
1133                 }
1134             }
1135         } else {
1136             return true;
1137         }
1138     }
1139 
1140     /**
1141      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1142      *
1143      * startTokenId - the first token id to be transferred
1144      * quantity - the amount to be transferred
1145      *
1146      * Calling conditions:
1147      *
1148      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1149      * transferred to `to`.
1150      * - When `from` is zero, `tokenId` will be minted for `to`.
1151      */
1152     function _beforeTokenTransfers(
1153         address from,
1154         address to,
1155         uint256 startTokenId,
1156         uint256 quantity
1157     ) internal virtual {}
1158 
1159     /**
1160      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1161      * minting.
1162      *
1163      * startTokenId - the first token id to be transferred
1164      * quantity - the amount to be transferred
1165      *
1166      * Calling conditions:
1167      *
1168      * - when `from` and `to` are both non-zero.
1169      * - `from` and `to` are never both zero.
1170      */
1171     function _afterTokenTransfers(
1172         address from,
1173         address to,
1174         uint256 startTokenId,
1175         uint256 quantity
1176     ) internal virtual {}
1177 }
1178 //             &&&&&&&&&&&&&&&&&&&&&&&&&&&@&&&&&&&&&&&&&&&&&&&&&&&&&&&            
1179 //             &@@&@@@&@@@&@@&&@@@&@@@&@@@@@@@@@@@@&@@@&@@@&@@@&@@@&@&            
1180 //              @@&@@@&@@&&@@@&@@@&@@@&@@@@@@@@@@@@&@@@&@@@&@@@&@@@@@             
1181 //             &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&@@@@@@@@@@@&&&&            
1182 //             &&&    &    &&&@&@//////*////////////@&@&&&&&&     .&&&            
1183 //             &&(     @ @@@/ @&@                   @&@ .&&&&@@    &&&            
1184 //             &%    .  @@@   @&@     V / H / S     @&@   @@@@@     &&            
1185 //             &&@        &&& @&@ @@@@@@@@@@@@@@@@@ @&@.@@@@&&     @&&            
1186 //             &&&@          &@&&@///////////////*/@&&@@@@&&@     @&%&            
1187 //             &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&            
1188 //             @@@&@@@&@@&&@@@&@@@&@@@&@@@@@&@@@@@@@@@@&@@@&@@@&@@@&@@            
1189 //             @@@&@@@&&@@&@@@&@@@&@@@&@@@@@@@@@@@@@@@@&@@@&@@@&@@@&@@   
1190 //                                    V / H / S
1191 //                                   DO NOT LOOK
1192 
1193 
1194 
1195 pragma solidity ^0.8.0;
1196 
1197 contract VHS is ERC721A, Ownable {
1198   using Strings for uint256;
1199 
1200   string private uriPrefix = "";
1201   string private uriSuffix = ".json";
1202   string public hiddenMetadataUri;
1203   
1204   uint256 public price = 0.005 ether; 
1205   uint256 public maxSupply = 1983; 
1206   uint256 public maxMintAmountPerTx = 50; 
1207   bool public paused = false;
1208   bool public revealed = true;
1209 
1210 
1211   constructor() ERC721A("V/H/S Do not look", "V/H/S", maxMintAmountPerTx) {
1212     setHiddenMetadataUri("ipfs://QmSU7MEqYN4tZoWuKSkHGBH6f84ofFhv3PQ1bVkyD8zuo8");
1213   }
1214 
1215   
1216 
1217   function PLAYvhs(uint256 _mintAmount) public payable mintCompliance(_mintAmount)
1218    {
1219     require(!paused, "The contract is paused!");
1220     require(msg.value >= price * _mintAmount, "Insufficient funds!");
1221     
1222     
1223     _safeMint(msg.sender, _mintAmount);
1224   }
1225 
1226   modifier mintCompliance(uint256 _mintAmount) {
1227     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1228     require(currentIndex + _mintAmount <= maxSupply, "Max supply exceeded!");
1229     _;
1230   }
1231 
1232   
1233 
1234   function Airdrop(address _to, uint256 _mintAmount) public mintCompliance(_mintAmount) onlyOwner {
1235     _safeMint(_to, _mintAmount);
1236   }
1237 
1238  
1239   function walletOfOwner(address _owner)
1240     public
1241     view
1242     returns (uint256[] memory)
1243   {
1244     uint256 ownerTokenCount = balanceOf(_owner);
1245     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1246     uint256 currentTokenId = 0;
1247     uint256 ownedTokenIndex = 0;
1248 
1249     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1250       address currentTokenOwner = ownerOf(currentTokenId);
1251 
1252       if (currentTokenOwner == _owner) {
1253         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1254 
1255         ownedTokenIndex++;
1256       }
1257 
1258       currentTokenId++;
1259     }
1260 
1261     return ownedTokenIds;
1262   }
1263 
1264   function tokenURI(uint256 _tokenId)
1265     public
1266     view
1267     virtual
1268     override
1269     returns (string memory)
1270   {
1271     require(
1272       _exists(_tokenId),
1273       "ERC721Metadata: URI query for nonexistent token"
1274     );
1275 
1276     if (revealed == false) {
1277       return hiddenMetadataUri;
1278     }
1279 
1280     string memory currentBaseURI = _baseURI();
1281     return bytes(currentBaseURI).length > 0
1282         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1283         : "";
1284   }
1285 
1286   function setRevealed(bool _state) public onlyOwner {
1287     revealed = _state;
1288   
1289   }
1290 
1291   function setPrice(uint256 _price) public onlyOwner {
1292     price = _price;
1293 
1294   }
1295  
1296   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1297     hiddenMetadataUri = _hiddenMetadataUri;
1298   }
1299 
1300   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1301     uriPrefix = _uriPrefix;
1302   }
1303 
1304   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1305     uriSuffix = _uriSuffix;
1306   }
1307 
1308   function setPaused(bool _state) public onlyOwner {
1309     paused = _state;
1310   }
1311 
1312   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1313       _safeMint(_receiver, _mintAmount);
1314   }
1315 
1316   function _baseURI() internal view virtual override returns (string memory) {
1317     return uriPrefix;
1318     
1319   }
1320 
1321     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1322     maxMintAmountPerTx = _maxMintAmountPerTx;
1323 
1324   }
1325 
1326 
1327     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1328     maxSupply = _maxSupply;
1329 
1330   }
1331 
1332   function RECvhs() public onlyOwner {
1333     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1334     require(os);
1335     
1336   }
1337   
1338 }