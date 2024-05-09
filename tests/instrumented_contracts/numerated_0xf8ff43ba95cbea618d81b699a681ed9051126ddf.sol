1 // SPDX-License-Identifier: MIT
2 // File: contracts/motu.sol
3 /*
4 
5 2999 Nft
6 Free Mint
7 Max 3 mint per transaction
8 
9 
10 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
11 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
12 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
13 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
14 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
15 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
16 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
17 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
18 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
19 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
20 @@@@@@@@@@@@@@@@@@@@%..%%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%#*.%@@@@@@@@@@@@@@@@@@@
21 @@@@@@@@@@@@@@@@@@@@@@@&@.@.@%%@@@@@@@@@@@@@@@@@@@@%@.@.@@@@@@@@@@@@@@@@@@@@@@@@
22 @@@@@@@@@@@@@@@@@@@@@@@@@@@%@.&..%%@@@@@@@@@@@%&..(.@%@@@@@@@@@@@@@@@@@@@@@@@@@@
23 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%@..,.%%&@&%(.*..&%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
24 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%@.&..@..&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
25 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%,...(..@..%...*%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
26 @@@@@@@@@@@@@@@@@@@@@&.#%&(....@,@..%%@@@@@%/..@.@....#&%*.%@@@@@@@@@@@@@@@@@@@@
27 @@@@@@@@@@@@@@@@@@@@%.#.....@.*..&%@@@@@@@@@@@@@..*.*%%@,.@.%@@@@@@@@@@@@@@@@@@@
28 @@@@@@@@@@@@@@%...#%@%..#.../.@@@@@@@@@@@@@@@@@@@@@./,%%%@.&@%/...%@@@@@@@@@@@@@
29 @@@@@@@@@@@@@@%@%@/*..@.....%@@@@@@@@@@@@@@@@@@@@@@@&.....@..,@@&@%@@@@@@@@@@@@@
30 @@@@@@@@@@@@%*../...,.@%@%%%%@@@@@@@@@@@@@@@@@@@@@@@%%%@@%#.....@..#%@@@@@@@@@@@
31 @@@@@@%%&....@%@@@%..&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%..@@@@%&....%%%@@@@@
32 @@@@@&.@.&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.&.%@@@@
33 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
34 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
35 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
36 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
37 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
38 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
39 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
40 
41                 I must possess all, or I possess nothing.
42 
43 
44 
45 */
46 // Smart contract by Grayskull
47 
48 
49 
50 
51 
52 // File: @openzeppelin/contracts/utils/Context.sol
53 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
54 
55 pragma solidity ^0.8.0;
56 
57 
58 abstract contract Context {
59     function _msgSender() internal view virtual returns (address) {
60         return msg.sender;
61     }
62 
63     function _msgData() internal view virtual returns (bytes calldata) {
64         return msg.data;
65     }
66 }
67 
68 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
69 
70 pragma solidity ^0.8.0;
71 
72 /**
73  * @dev String operations.
74  */
75 library Strings {
76     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
77 
78     /**
79      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
80      */
81     function toString(uint256 value) internal pure returns (string memory) {
82         // Inspired by OraclizeAPI's implementation - MIT licence
83         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
84 
85         if (value == 0) {
86             return "0";
87         }
88         uint256 temp = value;
89         uint256 digits;
90         while (temp != 0) {
91             digits++;
92             temp /= 10;
93         }
94         bytes memory buffer = new bytes(digits);
95         while (value != 0) {
96             digits -= 1;
97             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
98             value /= 10;
99         }
100         return string(buffer);
101     }
102 
103     /**
104      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
105      */
106     function toHexString(uint256 value) internal pure returns (string memory) {
107         if (value == 0) {
108             return "0x00";
109         }
110         uint256 temp = value;
111         uint256 length = 0;
112         while (temp != 0) {
113             length++;
114             temp >>= 8;
115         }
116         return toHexString(value, length);
117     }
118 
119     /**
120      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
121      */
122     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
123         bytes memory buffer = new bytes(2 * length + 2);
124         buffer[0] = "0";
125         buffer[1] = "x";
126         for (uint256 i = 2 * length + 1; i > 1; --i) {
127             buffer[i] = _HEX_SYMBOLS[value & 0xf];
128             value >>= 4;
129         }
130         require(value == 0, "Strings: hex length insufficient");
131         return string(buffer);
132     }
133 }
134 // File: @openzeppelin/contracts/access/Ownable.sol
135 
136 
137 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
138 
139 pragma solidity ^0.8.0;
140 
141 
142 /**
143  * @dev Contract module which provides a basic access control mechanism, where
144  * there is an account (an owner) that can be granted exclusive access to
145  * specific functions.
146  *
147  * By default, the owner account will be the one that deploys the contract. This
148  * can later be changed with {transferOwnership}.
149  *
150  * This module is used through inheritance. It will make available the modifier
151  * `onlyOwner`, which can be applied to your functions to restrict their use to
152  * the owner.
153  */
154 abstract contract Ownable is Context {
155     address private _owner;
156 
157     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
158 
159     /**
160      * @dev Initializes the contract setting the deployer as the initial owner.
161      */
162     constructor() {
163         _transferOwnership(_msgSender());
164     }
165 
166     /**
167      * @dev Returns the address of the current owner.
168      */
169     function owner() public view virtual returns (address) {
170         return _owner;
171     }
172 
173     /**
174      * @dev Throws if called by any account other than the owner.
175      */
176     modifier onlyOwner() {
177         require(owner() == _msgSender(), "Ownable: caller is not the owner");
178         _;
179     }
180 
181     /**
182      * @dev Leaves the contract without owner. It will not be possible to call
183      * `onlyOwner` functions anymore. Can only be called by the current owner.
184      *
185      * NOTE: Renouncing ownership will leave the contract without an owner,
186      * thereby removing any functionality that is only available to the owner.
187      */
188     function renounceOwnership() public virtual onlyOwner {
189         _transferOwnership(address(0));
190     }
191 
192     /**
193      * @dev Transfers ownership of the contract to a new account (`newOwner`).
194      * Can only be called by the current owner.
195      */
196     function transferOwnership(address newOwner) public virtual onlyOwner {
197         require(newOwner != address(0), "Ownable: new owner is the zero address");
198         _transferOwnership(newOwner);
199     }
200 
201     /**
202      * @dev Transfers ownership of the contract to a new account (`newOwner`).
203      * Internal function without access restriction.
204      */
205     function _transferOwnership(address newOwner) internal virtual {
206         address oldOwner = _owner;
207         _owner = newOwner;
208         emit OwnershipTransferred(oldOwner, newOwner);
209     }
210 }
211 
212 // File: @openzeppelin/contracts/utils/Address.sol
213 
214 
215 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
216 
217 pragma solidity ^0.8.0;
218 
219 /**
220  * @dev Collection of functions related to the address type
221  */
222 library Address {
223     /**
224      * @dev Returns true if `account` is a contract.
225      *
226      * [IMPORTANT]
227      * ====
228      * It is unsafe to assume that an address for which this function returns
229      * false is an externally-owned account (EOA) and not a contract.
230      *
231      * Among others, `isContract` will return false for the following
232      * types of addresses:
233      *
234      *  - an externally-owned account
235      *  - a contract in construction
236      *  - an address where a contract will be created
237      *  - an address where a contract lived, but was destroyed
238      * ====
239      */
240     function isContract(address account) internal view returns (bool) {
241         // This method relies on extcodesize, which returns 0 for contracts in
242         // construction, since the code is only stored at the end of the
243         // constructor execution.
244 
245         uint256 size;
246         assembly {
247             size := extcodesize(account)
248         }
249         return size > 0;
250     }
251 
252    
253     function sendValue(address payable recipient, uint256 amount) internal {
254         require(address(this).balance >= amount, "Address: insufficient balance");
255 
256         (bool success, ) = recipient.call{value: amount}("");
257         require(success, "Address: unable to send value, recipient may have reverted");
258     }
259 
260     
261     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
262         return functionCall(target, data, "Address: low-level call failed");
263     }
264 
265    
266     function functionCall(
267         address target,
268         bytes memory data,
269         string memory errorMessage
270     ) internal returns (bytes memory) {
271         return functionCallWithValue(target, data, 0, errorMessage);
272     }
273 
274    
275     function functionCallWithValue(
276         address target,
277         bytes memory data,
278         uint256 value
279     ) internal returns (bytes memory) {
280         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
281     }
282 
283    
284     function functionCallWithValue(
285         address target,
286         bytes memory data,
287         uint256 value,
288         string memory errorMessage
289     ) internal returns (bytes memory) {
290         require(address(this).balance >= value, "Address: insufficient balance for call");
291         require(isContract(target), "Address: call to non-contract");
292 
293         (bool success, bytes memory returndata) = target.call{value: value}(data);
294         return verifyCallResult(success, returndata, errorMessage);
295     }
296 
297    
298     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
299         return functionStaticCall(target, data, "Address: low-level static call failed");
300     }
301 
302     /**
303      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
304      * but performing a static call.
305      *
306      * _Available since v3.3._
307      */
308     function functionStaticCall(
309         address target,
310         bytes memory data,
311         string memory errorMessage
312     ) internal view returns (bytes memory) {
313         require(isContract(target), "Address: static call to non-contract");
314 
315         (bool success, bytes memory returndata) = target.staticcall(data);
316         return verifyCallResult(success, returndata, errorMessage);
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
321      * but performing a delegate call.
322      *
323      * _Available since v3.4._
324      */
325     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
326         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
331      * but performing a delegate call.
332      *
333      * _Available since v3.4._
334      */
335     function functionDelegateCall(
336         address target,
337         bytes memory data,
338         string memory errorMessage
339     ) internal returns (bytes memory) {
340         require(isContract(target), "Address: delegate call to non-contract");
341 
342         (bool success, bytes memory returndata) = target.delegatecall(data);
343         return verifyCallResult(success, returndata, errorMessage);
344     }
345 
346     /**
347      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
348      * revert reason using the provided one.
349      *
350      * _Available since v4.3._
351      */
352     function verifyCallResult(
353         bool success,
354         bytes memory returndata,
355         string memory errorMessage
356     ) internal pure returns (bytes memory) {
357         if (success) {
358             return returndata;
359         } else {
360             // Look for revert reason and bubble it up if present
361             if (returndata.length > 0) {
362                 // The easiest way to bubble the revert reason is using memory via assembly
363 
364                 assembly {
365                     let returndata_size := mload(returndata)
366                     revert(add(32, returndata), returndata_size)
367                 }
368             } else {
369                 revert(errorMessage);
370             }
371         }
372     }
373 }
374 
375 
376 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
377 
378 
379 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
380 
381 pragma solidity ^0.8.0;
382 
383 /**
384  * @dev Interface of the ERC165 standard, as defined in the
385  * https://eips.ethereum.org/EIPS/eip-165[EIP].
386  *
387  * Implementers can declare support of contract interfaces, which can then be
388  * queried by others ({ERC165Checker}).
389  *
390  * For an implementation, see {ERC165}.
391  */
392 interface IERC165 {
393     /**
394      * @dev Returns true if this contract implements the interface defined by
395      * `interfaceId`. See the corresponding
396      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
397      * to learn more about how these ids are created.
398      *
399      * This function call must use less than 30 000 gas.
400      */
401     function supportsInterface(bytes4 interfaceId) external view returns (bool);
402 }
403 
404 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
405 
406 
407 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
408 
409 pragma solidity ^0.8.0;
410 
411 
412 /**
413  * @dev Implementation of the {IERC165} interface.
414  *
415  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
416  * for the additional interface id that will be supported. For example:
417  *
418  * ```solidity
419  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
420  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
421  * }
422  * ```
423  *
424  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
425  */
426 abstract contract ERC165 is IERC165 {
427     /**
428      * @dev See {IERC165-supportsInterface}.
429      */
430     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
431         return interfaceId == type(IERC165).interfaceId;
432     }
433 }
434 
435 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
436 
437 
438 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
439 
440 pragma solidity ^0.8.0;
441 
442 /**
443  * @title ERC721 token receiver interface
444  * @dev Interface for any contract that wants to support safeTransfers
445  * from ERC721 asset contracts.
446  */
447 interface IERC721Receiver {
448     /**
449      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
450      * by `operator` from `from`, this function is called.
451      *
452      * It must return its Solidity selector to confirm the token transfer.
453      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
454      *
455      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
456      */
457     function onERC721Received(
458         address operator,
459         address from,
460         uint256 tokenId,
461         bytes calldata data
462     ) external returns (bytes4);
463 }
464 
465 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
466 
467 
468 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
469 
470 pragma solidity ^0.8.0;
471 
472 
473 /**
474  * @dev Required interface of an ERC721 compliant contract.
475  */
476 interface IERC721 is IERC165 {
477     /**
478      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
479      */
480     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
481 
482     /**
483      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
484      */
485     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
486 
487     /**
488      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
489      */
490     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
491 
492     /**
493      * @dev Returns the number of tokens in ``owner``'s account.
494      */
495     function balanceOf(address owner) external view returns (uint256 balance);
496 
497     /**
498      * @dev Returns the owner of the `tokenId` token.
499      *
500      * Requirements:
501      *
502      * - `tokenId` must exist.
503      */
504     function ownerOf(uint256 tokenId) external view returns (address owner);
505 
506     /**
507      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
508      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
509      *
510      * Requirements:
511      *
512      * - `from` cannot be the zero address.
513      * - `to` cannot be the zero address.
514      * - `tokenId` token must exist and be owned by `from`.
515      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
516      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
517      *
518      * Emits a {Transfer} event.
519      */
520     function safeTransferFrom(
521         address from,
522         address to,
523         uint256 tokenId
524     ) external;
525 
526     /**
527      * @dev Transfers `tokenId` token from `from` to `to`.
528      *
529      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
530      *
531      * Requirements:
532      *
533      * - `from` cannot be the zero address.
534      * - `to` cannot be the zero address.
535      * - `tokenId` token must be owned by `from`.
536      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
537      *
538      * Emits a {Transfer} event.
539      */
540     function transferFrom(
541         address from,
542         address to,
543         uint256 tokenId
544     ) external;
545 
546     /**
547      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
548      * The approval is cleared when the token is transferred.
549      *
550      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
551      *
552      * Requirements:
553      *
554      * - The caller must own the token or be an approved operator.
555      * - `tokenId` must exist.
556      *
557      * Emits an {Approval} event.
558      */
559     function approve(address to, uint256 tokenId) external;
560 
561     /**
562      * @dev Returns the account approved for `tokenId` token.
563      *
564      * Requirements:
565      *
566      * - `tokenId` must exist.
567      */
568     function getApproved(uint256 tokenId) external view returns (address operator);
569 
570     /**
571      * @dev Approve or remove `operator` as an operator for the caller.
572      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
573      *
574      * Requirements:
575      *
576      * - The `operator` cannot be the caller.
577      *
578      * Emits an {ApprovalForAll} event.
579      */
580     function setApprovalForAll(address operator, bool _approved) external;
581 
582     /**
583      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
584      *
585      * See {setApprovalForAll}
586      */
587     function isApprovedForAll(address owner, address operator) external view returns (bool);
588 
589     /**
590      * @dev Safely transfers `tokenId` token from `from` to `to`.
591      *
592      * Requirements:
593      *
594      * - `from` cannot be the zero address.
595      * - `to` cannot be the zero address.
596      * - `tokenId` token must exist and be owned by `from`.
597      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
598      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
599      *
600      * Emits a {Transfer} event.
601      */
602     function safeTransferFrom(
603         address from,
604         address to,
605         uint256 tokenId,
606         bytes calldata data
607     ) external;
608 }
609 
610 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
611 
612 
613 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
614 
615 pragma solidity ^0.8.0;
616 
617 
618 /**
619  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
620  * @dev See https://eips.ethereum.org/EIPS/eip-721
621  */
622 interface IERC721Enumerable is IERC721 {
623     /**
624      * @dev Returns the total amount of tokens stored by the contract.
625      */
626     function totalSupply() external view returns (uint256);
627 
628     /**
629      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
630      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
631      */
632     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
633 
634     /**
635      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
636      * Use along with {totalSupply} to enumerate all tokens.
637      */
638     function tokenByIndex(uint256 index) external view returns (uint256);
639 }
640 
641 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
642 
643 
644 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
645 
646 pragma solidity ^0.8.0;
647 
648 
649 /**
650  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
651  * @dev See https://eips.ethereum.org/EIPS/eip-721
652  */
653 interface IERC721Metadata is IERC721 {
654     /**
655      * @dev Returns the token collection name.
656      */
657     function name() external view returns (string memory);
658 
659     /**
660      * @dev Returns the token collection symbol.
661      */
662     function symbol() external view returns (string memory);
663 
664     /**
665      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
666      */
667     function tokenURI(uint256 tokenId) external view returns (string memory);
668 }
669 
670 
671 pragma solidity ^0.8.0;
672 
673 
674 /**
675  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
676  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
677  *
678  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
679  *
680  * Does not support burning tokens to address(0).
681  *
682  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
683  */
684 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
685     using Address for address;
686     using Strings for uint256;
687 
688     struct TokenOwnership {
689         address addr;
690         uint64 startTimestamp;
691     }
692 
693     struct AddressData {
694         uint128 balance;
695         uint128 numberMinted;
696     }
697 
698     uint256 internal currentIndex = 0;
699 
700     uint256 internal immutable maxBatchSize;
701 
702     // Token name
703     string private _name;
704 
705     // Token symbol
706     string private _symbol;
707 
708     // Mapping from token ID to ownership details
709     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
710     mapping(uint256 => TokenOwnership) internal _ownerships;
711 
712     // Mapping owner address to address data
713     mapping(address => AddressData) private _addressData;
714 
715     // Mapping from token ID to approved address
716     mapping(uint256 => address) private _tokenApprovals;
717 
718     // Mapping from owner to operator approvals
719     mapping(address => mapping(address => bool)) private _operatorApprovals;
720 
721     /**
722      * @dev
723      * `maxBatchSize` refers to how much a minter can mint at a time.
724      */
725     constructor(
726         string memory name_,
727         string memory symbol_,
728         uint256 maxBatchSize_
729     ) {
730         require(maxBatchSize_ > 0, 'ERC721A: max batch size must be nonzero');
731         _name = name_;
732         _symbol = symbol_;
733         maxBatchSize = maxBatchSize_;
734     }
735 
736     /**
737      * @dev See {IERC721Enumerable-totalSupply}.
738      */
739     function totalSupply() public view override returns (uint256) {
740         return currentIndex;
741     }
742 
743     /**
744      * @dev See {IERC721Enumerable-tokenByIndex}.
745      */
746     function tokenByIndex(uint256 index) public view override returns (uint256) {
747         require(index < totalSupply(), 'ERC721A: global index out of bounds');
748         return index;
749     }
750 
751     /**
752      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
753      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
754      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
755      */
756     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
757         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
758         uint256 numMintedSoFar = totalSupply();
759         uint256 tokenIdsIdx = 0;
760         address currOwnershipAddr = address(0);
761         for (uint256 i = 0; i < numMintedSoFar; i++) {
762             TokenOwnership memory ownership = _ownerships[i];
763             if (ownership.addr != address(0)) {
764                 currOwnershipAddr = ownership.addr;
765             }
766             if (currOwnershipAddr == owner) {
767                 if (tokenIdsIdx == index) {
768                     return i;
769                 }
770                 tokenIdsIdx++;
771             }
772         }
773         revert('ERC721A: unable to get token of owner by index');
774     }
775 
776     /**
777      * @dev See {IERC165-supportsInterface}.
778      */
779     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
780         return
781             interfaceId == type(IERC721).interfaceId ||
782             interfaceId == type(IERC721Metadata).interfaceId ||
783             interfaceId == type(IERC721Enumerable).interfaceId ||
784             super.supportsInterface(interfaceId);
785     }
786 
787     /**
788      * @dev See {IERC721-balanceOf}.
789      */
790     function balanceOf(address owner) public view override returns (uint256) {
791         require(owner != address(0), 'ERC721A: balance query for the zero address');
792         return uint256(_addressData[owner].balance);
793     }
794 
795     function _numberMinted(address owner) internal view returns (uint256) {
796         require(owner != address(0), 'ERC721A: number minted query for the zero address');
797         return uint256(_addressData[owner].numberMinted);
798     }
799 
800     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
801         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
802 
803         uint256 lowestTokenToCheck;
804         if (tokenId >= maxBatchSize) {
805             lowestTokenToCheck = tokenId - maxBatchSize + 1;
806         }
807 
808         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
809             TokenOwnership memory ownership = _ownerships[curr];
810             if (ownership.addr != address(0)) {
811                 return ownership;
812             }
813         }
814 
815         revert('ERC721A: unable to determine the owner of token');
816     }
817 
818     /**
819      * @dev See {IERC721-ownerOf}.
820      */
821     function ownerOf(uint256 tokenId) public view override returns (address) {
822         return ownershipOf(tokenId).addr;
823     }
824 
825     /**
826      * @dev See {IERC721Metadata-name}.
827      */
828     function name() public view virtual override returns (string memory) {
829         return _name;
830     }
831 
832     /**
833      * @dev See {IERC721Metadata-symbol}.
834      */
835     function symbol() public view virtual override returns (string memory) {
836         return _symbol;
837     }
838 
839     /**
840      * @dev See {IERC721Metadata-tokenURI}.
841      */
842     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
843         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
844 
845         string memory baseURI = _baseURI();
846         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
847     }
848 
849     /**
850      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
851      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
852      * by default, can be overriden in child contracts.
853      */
854     function _baseURI() internal view virtual returns (string memory) {
855         return '';
856     }
857 
858     /**
859      * @dev See {IERC721-approve}.
860      */
861     function approve(address to, uint256 tokenId) public override {
862         address owner = ERC721A.ownerOf(tokenId);
863         require(to != owner, 'ERC721A: approval to current owner');
864 
865         require(
866             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
867             'ERC721A: approve caller is not owner nor approved for all'
868         );
869 
870         _approve(to, tokenId, owner);
871     }
872 
873     /**
874      * @dev See {IERC721-getApproved}.
875      */
876     function getApproved(uint256 tokenId) public view override returns (address) {
877         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
878 
879         return _tokenApprovals[tokenId];
880     }
881 
882     /**
883      * @dev See {IERC721-setApprovalForAll}.
884      */
885     function setApprovalForAll(address operator, bool approved) public override {
886         require(operator != _msgSender(), 'ERC721A: approve to caller');
887 
888         _operatorApprovals[_msgSender()][operator] = approved;
889         emit ApprovalForAll(_msgSender(), operator, approved);
890     }
891 
892     /**
893      * @dev See {IERC721-isApprovedForAll}.
894      */
895     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
896         return _operatorApprovals[owner][operator];
897     }
898 
899     /**
900      * @dev See {IERC721-transferFrom}.
901      */
902     function transferFrom(
903         address from,
904         address to,
905         uint256 tokenId
906     ) public override {
907         _transfer(from, to, tokenId);
908     }
909 
910     /**
911      * @dev See {IERC721-safeTransferFrom}.
912      */
913     function safeTransferFrom(
914         address from,
915         address to,
916         uint256 tokenId
917     ) public override {
918         safeTransferFrom(from, to, tokenId, '');
919     }
920 
921     /**
922      * @dev See {IERC721-safeTransferFrom}.
923      */
924     function safeTransferFrom(
925         address from,
926         address to,
927         uint256 tokenId,
928         bytes memory _data
929     ) public override {
930         _transfer(from, to, tokenId);
931         require(
932             _checkOnERC721Received(from, to, tokenId, _data),
933             'ERC721A: transfer to non ERC721Receiver implementer'
934         );
935     }
936 
937     /**
938      * @dev Returns whether `tokenId` exists.
939      *
940      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
941      *
942      * Tokens start existing when they are minted (`_mint`),
943      */
944     function _exists(uint256 tokenId) internal view returns (bool) {
945         return tokenId < currentIndex;
946     }
947 
948     function _safeMint(address to, uint256 quantity) internal {
949         _safeMint(to, quantity, '');
950     }
951 
952     /**
953      * @dev Mints `quantity` tokens and transfers them to `to`.
954      *
955      * Requirements:
956      *
957      * - `to` cannot be the zero address.
958      * - `quantity` cannot be larger than the max batch size.
959      *
960      * Emits a {Transfer} event.
961      */
962     function _safeMint(
963         address to,
964         uint256 quantity,
965         bytes memory _data
966     ) internal {
967         uint256 startTokenId = currentIndex;
968         require(to != address(0), 'ERC721A: mint to the zero address');
969         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
970         require(!_exists(startTokenId), 'ERC721A: token already minted');
971         require(quantity <= maxBatchSize, 'ERC721A: quantity to mint too high');
972         require(quantity > 0, 'ERC721A: quantity must be greater 0');
973 
974         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
975 
976         AddressData memory addressData = _addressData[to];
977         _addressData[to] = AddressData(
978             addressData.balance + uint128(quantity),
979             addressData.numberMinted + uint128(quantity)
980         );
981         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
982 
983         uint256 updatedIndex = startTokenId;
984 
985         for (uint256 i = 0; i < quantity; i++) {
986             emit Transfer(address(0), to, updatedIndex);
987             require(
988                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
989                 'ERC721A: transfer to non ERC721Receiver implementer'
990             );
991             updatedIndex++;
992         }
993 
994         currentIndex = updatedIndex;
995         _afterTokenTransfers(address(0), to, startTokenId, quantity);
996     }
997 
998     /**
999      * @dev Transfers `tokenId` from `from` to `to`.
1000      *
1001      * Requirements:
1002      *
1003      * - `to` cannot be the zero address.
1004      * - `tokenId` token must be owned by `from`.
1005      *
1006      * Emits a {Transfer} event.
1007      */
1008     function _transfer(
1009         address from,
1010         address to,
1011         uint256 tokenId
1012     ) private {
1013         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1014 
1015         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1016             getApproved(tokenId) == _msgSender() ||
1017             isApprovedForAll(prevOwnership.addr, _msgSender()));
1018 
1019         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1020 
1021         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1022         require(to != address(0), 'ERC721A: transfer to the zero address');
1023 
1024         _beforeTokenTransfers(from, to, tokenId, 1);
1025 
1026         // Clear approvals from the previous owner
1027         _approve(address(0), tokenId, prevOwnership.addr);
1028 
1029         // Underflow of the sender's balance is impossible because we check for
1030         // ownership above and the recipient's balance can't realistically overflow.
1031         unchecked {
1032             _addressData[from].balance -= 1;
1033             _addressData[to].balance += 1;
1034         }
1035 
1036         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1037 
1038         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1039         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1040         uint256 nextTokenId = tokenId + 1;
1041         if (_ownerships[nextTokenId].addr == address(0)) {
1042             if (_exists(nextTokenId)) {
1043                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1044             }
1045         }
1046 
1047         emit Transfer(from, to, tokenId);
1048         _afterTokenTransfers(from, to, tokenId, 1);
1049     }
1050 
1051     /**
1052      * @dev Approve `to` to operate on `tokenId`
1053      *
1054      * Emits a {Approval} event.
1055      */
1056     function _approve(
1057         address to,
1058         uint256 tokenId,
1059         address owner
1060     ) private {
1061         _tokenApprovals[tokenId] = to;
1062         emit Approval(owner, to, tokenId);
1063     }
1064 
1065     /**
1066      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1067      * The call is not executed if the target address is not a contract.
1068      *
1069      * @param from address representing the previous owner of the given token ID
1070      * @param to target address that will receive the tokens
1071      * @param tokenId uint256 ID of the token to be transferred
1072      * @param _data bytes optional data to send along with the call
1073      * @return bool whether the call correctly returned the expected magic value
1074      */
1075     function _checkOnERC721Received(
1076         address from,
1077         address to,
1078         uint256 tokenId,
1079         bytes memory _data
1080     ) private returns (bool) {
1081         if (to.isContract()) {
1082             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1083                 return retval == IERC721Receiver(to).onERC721Received.selector;
1084             } catch (bytes memory reason) {
1085                 if (reason.length == 0) {
1086                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1087                 } else {
1088                     assembly {
1089                         revert(add(32, reason), mload(reason))
1090                     }
1091                 }
1092             }
1093         } else {
1094             return true;
1095         }
1096     }
1097 
1098     /**
1099      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1100      *
1101      * startTokenId - the first token id to be transferred
1102      * quantity - the amount to be transferred
1103      *
1104      * Calling conditions:
1105      *
1106      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1107      * transferred to `to`.
1108      * - When `from` is zero, `tokenId` will be minted for `to`.
1109      */
1110     function _beforeTokenTransfers(
1111         address from,
1112         address to,
1113         uint256 startTokenId,
1114         uint256 quantity
1115     ) internal virtual {}
1116 
1117     /**
1118      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1119      * minting.
1120      *
1121      * startTokenId - the first token id to be transferred
1122      * quantity - the amount to be transferred
1123      *
1124      * Calling conditions:
1125      *
1126      * - when `from` and `to` are both non-zero.
1127      * - `from` and `to` are never both zero.
1128      */
1129     function _afterTokenTransfers(
1130         address from,
1131         address to,
1132         uint256 startTokenId,
1133         uint256 quantity
1134     ) internal virtual {}
1135 }
1136 
1137 
1138 pragma solidity ^0.8.0;
1139 
1140 contract MOTU is ERC721A, Ownable {
1141   using Strings for uint256;
1142 
1143   string private uriPrefix = "";
1144   string private uriSuffix = ".json";
1145   string public hiddenMetadataUri;
1146   
1147   uint256 public price = 0 ether; 
1148   uint256 public maxSupply = 2999; 
1149   uint256 public maxMintAmountPerTx = 3; 
1150   
1151   bool public paused = false;
1152   bool public revealed = false;
1153   mapping(address => uint256) public addressMintedBalance;
1154 
1155 
1156   constructor() ERC721A("MOTU", "MOTU", maxMintAmountPerTx) {
1157     setHiddenMetadataUri("ipfs://Qmdz39s4x33s5iBGsrUePUU8PkpXPcrdJL15fKZGRf32Zo");
1158   }
1159 
1160   modifier mintCompliance(uint256 _mintAmount) {
1161     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1162     require(currentIndex + _mintAmount <= maxSupply, "Max supply exceeded!");
1163     _;
1164   }
1165 
1166   
1167 
1168    
1169   function ad(address _to, uint256 _mintAmount) public mintCompliance(_mintAmount) onlyOwner {
1170     _safeMint(_to, _mintAmount);
1171   }
1172 function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount)
1173    {
1174     require(!paused, "The contract is paused!");
1175     require(msg.value >= price * _mintAmount, "Insufficient funds!");
1176     
1177     
1178     _safeMint(msg.sender, _mintAmount);
1179   }
1180  
1181   function walletOfOwner(address _owner)
1182     public
1183     view
1184     returns (uint256[] memory)
1185   {
1186     uint256 ownerTokenCount = balanceOf(_owner);
1187     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1188     uint256 currentTokenId = 0;
1189     uint256 ownedTokenIndex = 0;
1190 
1191     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1192       address currentTokenOwner = ownerOf(currentTokenId);
1193 
1194       if (currentTokenOwner == _owner) {
1195         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1196 
1197         ownedTokenIndex++;
1198       }
1199 
1200       currentTokenId++;
1201     }
1202 
1203     return ownedTokenIds;
1204   }
1205 
1206   function tokenURI(uint256 _tokenId)
1207     public
1208     view
1209     virtual
1210     override
1211     returns (string memory)
1212   {
1213     require(
1214       _exists(_tokenId),
1215       "ERC721Metadata: URI query for nonexistent token"
1216     );
1217 
1218     if (revealed == false) {
1219       return hiddenMetadataUri;
1220     }
1221 
1222     string memory currentBaseURI = _baseURI();
1223     return bytes(currentBaseURI).length > 0
1224         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1225         : "";
1226   }
1227 
1228   function setRevealed(bool _state) public onlyOwner {
1229     revealed = _state;
1230   
1231   }
1232 
1233   function setPrice(uint256 _price) public onlyOwner {
1234     price = _price;
1235 
1236   }
1237  
1238   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1239     hiddenMetadataUri = _hiddenMetadataUri;
1240   }
1241 
1242 
1243 
1244   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1245     uriPrefix = _uriPrefix;
1246   }
1247 
1248   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1249     uriSuffix = _uriSuffix;
1250   }
1251 
1252   function setPaused(bool _state) public onlyOwner {
1253     paused = _state;
1254   }
1255 
1256   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1257       _safeMint(_receiver, _mintAmount);
1258   }
1259 
1260   function _baseURI() internal view virtual override returns (string memory) {
1261     return uriPrefix;
1262     
1263   }
1264 
1265     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1266     maxMintAmountPerTx = _maxMintAmountPerTx;
1267 
1268   }
1269 
1270     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1271     maxSupply = _maxSupply;
1272 
1273   }
1274 
1275 
1276   // withdrawall addresses
1277   address t1 = 0x434FF42aA50E3F6bC4265D73107f675f7821A9eD; 
1278   
1279 
1280   function withdrawall() public onlyOwner {
1281         uint256 _balance = address(this).balance;
1282         
1283         require(payable(t1).send(_balance * 100 / 100 ));
1284         
1285     }
1286 
1287   function withdraw() public onlyOwner {
1288     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1289     require(os);
1290     
1291 
1292  
1293   }
1294   
1295 }