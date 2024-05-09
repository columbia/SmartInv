1 /**
2  *Submitted for verification at Etherscan.io on 2022-05-30
3 */
4 
5 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
6 
7 // SPDX-License-Identifier: MIT
8 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
9 
10 /*
11 
12  /$$$$$$$                            /$$ /$$                            /$$$$$$                               
13 | $$__  $$                          | $$| $$                           /$$__  $$                              
14 | $$  \ $$  /$$$$$$   /$$$$$$   /$$$$$$$| $$  /$$$$$$   /$$$$$$$      | $$  \ $$  /$$$$$$   /$$$$$$   /$$$$$$$
15 | $$  | $$ /$$__  $$ /$$__  $$ /$$__  $$| $$ /$$__  $$ /$$_____/      | $$$$$$$$ /$$__  $$ /$$__  $$ /$$_____/
16 | $$  | $$| $$  \ $$| $$  \ $$| $$  | $$| $$| $$$$$$$$|  $$$$$$       | $$__  $$| $$  \ $$| $$$$$$$$|  $$$$$$ 
17 | $$  | $$| $$  | $$| $$  | $$| $$  | $$| $$| $$_____/ \____  $$      | $$  | $$| $$  | $$| $$_____/ \____  $$
18 | $$$$$$$/|  $$$$$$/|  $$$$$$/|  $$$$$$$| $$|  $$$$$$$ /$$$$$$$/      | $$  | $$| $$$$$$$/|  $$$$$$$ /$$$$$$$/
19 |_______/  \______/  \______/  \_______/|__/ \_______/|_______/       |__/  |__/| $$____/  \_______/|_______/ 
20                                                                                 | $$                          
21                                                                                 | $$                          
22                                                                                 |__/                          
23 */
24 
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev Provides information about the current execution context, including the
29  * sender of the transaction and its data. While these are generally available
30  * via msg.sender and msg.data, they should not be accessed in such a direct
31  * manner, since when dealing with meta-transactions the account sending and
32  * paying for execution may not be the actual sender (as far as an application
33  * is concerned).
34  *
35  * This contract is only required for intermediate, library-like contracts.
36  */
37 abstract contract Context {
38     function _msgSender() internal view virtual returns (address) {
39         return msg.sender;
40     }
41 
42     function _msgData() internal view virtual returns (bytes calldata) {
43         return msg.data;
44     }
45 }
46 
47 
48 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
49 
50 
51 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
52 
53 
54 
55 /**
56  * @dev Contract module which provides a basic access control mechanism, where
57  * there is an account (an owner) that can be granted exclusive access to
58  * specific functions.
59  *
60  * By default, the owner account will be the one that deploys the contract. This
61  * can later be changed with {transferOwnership}.
62  *
63  * This module is used through inheritance. It will make available the modifier
64  * `onlyOwner`, which can be applied to your functions to restrict their use to
65  * the owner.
66  */
67 abstract contract Ownable is Context {
68     address private _owner;
69 
70     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71 
72     /**
73      * @dev Initializes the contract setting the deployer as the initial owner.
74      */
75     constructor() {
76         _transferOwnership(_msgSender());
77     }
78 
79     /**
80      * @dev Returns the address of the current owner.
81      */
82     function owner() public view virtual returns (address) {
83         return _owner;
84     }
85 
86     /**
87      * @dev Throws if called by any account other than the owner.
88      */
89     modifier onlyOwner() {
90         require(owner() == _msgSender(), "Ownable: caller is not the owner");
91         _;
92     }
93 
94     /**
95      * @dev Leaves the contract without owner. It will not be possible to call
96      * `onlyOwner` functions anymore. Can only be called by the current owner.
97      *
98      * NOTE: Renouncing ownership will leave the contract without an owner,
99      * thereby removing any functionality that is only available to the owner.
100      */
101     function renounceOwnership() public virtual onlyOwner {
102         _transferOwnership(address(0));
103     }
104 
105     /**
106      * @dev Transfers ownership of the contract to a new account (`newOwner`).
107      * Can only be called by the current owner.
108      */
109     function transferOwnership(address newOwner) public virtual onlyOwner {
110         require(newOwner != address(0), "Ownable: new owner is the zero address");
111         _transferOwnership(newOwner);
112     }
113 
114     /**
115      * @dev Transfers ownership of the contract to a new account (`newOwner`).
116      * Internal function without access restriction.
117      */
118     function _transferOwnership(address newOwner) internal virtual {
119         address oldOwner = _owner;
120         _owner = newOwner;
121         emit OwnershipTransferred(oldOwner, newOwner);
122     }
123 }
124 
125 
126 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
127 
128 
129 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
130 
131 
132 
133 /**
134  * @dev String operations.
135  */
136 library Strings {
137     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
138 
139     /**
140      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
141      */
142     function toString(uint256 value) internal pure returns (string memory) {
143         // Inspired by OraclizeAPI's implementation - MIT licence
144         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
145 
146         if (value == 0) {
147             return "0";
148         }
149         uint256 temp = value;
150         uint256 digits;
151         while (temp != 0) {
152             digits++;
153             temp /= 10;
154         }
155         bytes memory buffer = new bytes(digits);
156         while (value != 0) {
157             digits -= 1;
158             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
159             value /= 10;
160         }
161         return string(buffer);
162     }
163 
164     /**
165      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
166      */
167     function toHexString(uint256 value) internal pure returns (string memory) {
168         if (value == 0) {
169             return "0x00";
170         }
171         uint256 temp = value;
172         uint256 length = 0;
173         while (temp != 0) {
174             length++;
175             temp >>= 8;
176         }
177         return toHexString(value, length);
178     }
179 
180     /**
181      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
182      */
183     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
184         bytes memory buffer = new bytes(2 * length + 2);
185         buffer[0] = "0";
186         buffer[1] = "x";
187         for (uint256 i = 2 * length + 1; i > 1; --i) {
188             buffer[i] = _HEX_SYMBOLS[value & 0xf];
189             value >>= 4;
190         }
191         require(value == 0, "Strings: hex length insufficient");
192         return string(buffer);
193     }
194 }
195 
196 
197 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
198 
199 
200 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
201 
202 
203 
204 /**
205  * @dev Interface of the ERC165 standard, as defined in the
206  * https://eips.ethereum.org/EIPS/eip-165[EIP].
207  *
208  * Implementers can declare support of contract interfaces, which can then be
209  * queried by others ({ERC165Checker}).
210  *
211  * For an implementation, see {ERC165}.
212  */
213 interface IERC165 {
214     /**
215      * @dev Returns true if this contract implements the interface defined by
216      * `interfaceId`. See the corresponding
217      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
218      * to learn more about how these ids are created.
219      *
220      * This function call must use less than 30 000 gas.
221      */
222     function supportsInterface(bytes4 interfaceId) external view returns (bool);
223 }
224 
225 
226 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.2
227 
228 
229 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
230 
231 
232 
233 /**
234  * @dev Required interface of an ERC721 compliant contract.
235  */
236 interface IERC721 is IERC165 {
237     /**
238      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
239      */
240     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
241 
242     /**
243      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
244      */
245     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
246 
247     /**
248      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
249      */
250     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
251 
252     /**
253      * @dev Returns the number of tokens in ``owner``'s account.
254      */
255     function balanceOf(address owner) external view returns (uint256 balance);
256 
257     /**
258      * @dev Returns the owner of the `tokenId` token.
259      *
260      * Requirements:
261      *
262      * - `tokenId` must exist.
263      */
264     function ownerOf(uint256 tokenId) external view returns (address owner);
265 
266     /**
267      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
268      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
269      *
270      * Requirements:
271      *
272      * - `from` cannot be the zero address.
273      * - `to` cannot be the zero address.
274      * - `tokenId` token must exist and be owned by `from`.
275      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
276      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
277      *
278      * Emits a {Transfer} event.
279      */
280     function safeTransferFrom(
281         address from,
282         address to,
283         uint256 tokenId
284     ) external;
285 
286     /**
287      * @dev Transfers `tokenId` token from `from` to `to`.
288      *
289      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
290      *
291      * Requirements:
292      *
293      * - `from` cannot be the zero address.
294      * - `to` cannot be the zero address.
295      * - `tokenId` token must be owned by `from`.
296      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
297      *
298      * Emits a {Transfer} event.
299      */
300     function transferFrom(
301         address from,
302         address to,
303         uint256 tokenId
304     ) external;
305 
306     /**
307      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
308      * The approval is cleared when the token is transferred.
309      *
310      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
311      *
312      * Requirements:
313      *
314      * - The caller must own the token or be an approved operator.
315      * - `tokenId` must exist.
316      *
317      * Emits an {Approval} event.
318      */
319     function approve(address to, uint256 tokenId) external;
320 
321     /**
322      * @dev Returns the account approved for `tokenId` token.
323      *
324      * Requirements:
325      *
326      * - `tokenId` must exist.
327      */
328     function getApproved(uint256 tokenId) external view returns (address operator);
329 
330     /**
331      * @dev Approve or remove `operator` as an operator for the caller.
332      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
333      *
334      * Requirements:
335      *
336      * - The `operator` cannot be the caller.
337      *
338      * Emits an {ApprovalForAll} event.
339      */
340     function setApprovalForAll(address operator, bool _approved) external;
341 
342     /**
343      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
344      *
345      * See {setApprovalForAll}
346      */
347     function isApprovedForAll(address owner, address operator) external view returns (bool);
348 
349     /**
350      * @dev Safely transfers `tokenId` token from `from` to `to`.
351      *
352      * Requirements:
353      *
354      * - `from` cannot be the zero address.
355      * - `to` cannot be the zero address.
356      * - `tokenId` token must exist and be owned by `from`.
357      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
358      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
359      *
360      * Emits a {Transfer} event.
361      */
362     function safeTransferFrom(
363         address from,
364         address to,
365         uint256 tokenId,
366         bytes calldata data
367     ) external;
368 }
369 
370 
371 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.2
372 
373 
374 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
375 
376 
377 
378 /**
379  * @title ERC721 token receiver interface
380  * @dev Interface for any contract that wants to support safeTransfers
381  * from ERC721 asset contracts.
382  */
383 interface IERC721Receiver {
384     /**
385      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
386      * by `operator` from `from`, this function is called.
387      *
388      * It must return its Solidity selector to confirm the token transfer.
389      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
390      *
391      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
392      */
393     function onERC721Received(
394         address operator,
395         address from,
396         uint256 tokenId,
397         bytes calldata data
398     ) external returns (bytes4);
399 }
400 
401 
402 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.2
403 
404 
405 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
406 
407 
408 
409 /**
410  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
411  * @dev See https://eips.ethereum.org/EIPS/eip-721
412  */
413 interface IERC721Metadata is IERC721 {
414     /**
415      * @dev Returns the token collection name.
416      */
417     function name() external view returns (string memory);
418 
419     /**
420      * @dev Returns the token collection symbol.
421      */
422     function symbol() external view returns (string memory);
423 
424     /**
425      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
426      */
427     function tokenURI(uint256 tokenId) external view returns (string memory);
428 }
429 
430 
431 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.2
432 
433 
434 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
435 
436 
437 
438 /**
439  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
440  * @dev See https://eips.ethereum.org/EIPS/eip-721
441  */
442 interface IERC721Enumerable is IERC721 {
443     /**
444      * @dev Returns the total amount of tokens stored by the contract.
445      */
446     function totalSupply() external view returns (uint256);
447 
448     /**
449      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
450      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
451      */
452     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
453 
454     /**
455      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
456      * Use along with {totalSupply} to enumerate all tokens.
457      */
458     function tokenByIndex(uint256 index) external view returns (uint256);
459 }
460 
461 
462 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
463 
464 
465 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
466 
467 
468 
469 /**
470  * @dev Collection of functions related to the address type
471  */
472 library Address {
473     /**
474      * @dev Returns true if `account` is a contract.
475      *
476      * [IMPORTANT]
477      * ====
478      * It is unsafe to assume that an address for which this function returns
479      * false is an externally-owned account (EOA) and not a contract.
480      *
481      * Among others, `isContract` will return false for the following
482      * types of addresses:
483      *
484      *  - an externally-owned account
485      *  - a contract in construction
486      *  - an address where a contract will be created
487      *  - an address where a contract lived, but was destroyed
488      * ====
489      */
490     function isContract(address account) internal view returns (bool) {
491         // This method relies on extcodesize, which returns 0 for contracts in
492         // construction, since the code is only stored at the end of the
493         // constructor execution.
494 
495         uint256 size;
496         assembly {
497             size := extcodesize(account)
498         }
499         return size > 0;
500     }
501 
502     /**
503      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
504      * `recipient`, forwarding all available gas and reverting on errors.
505      *
506      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
507      * of certain opcodes, possibly making contracts go over the 2300 gas limit
508      * imposed by `transfer`, making them unable to receive funds via
509      * `transfer`. {sendValue} removes this limitation.
510      *
511      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
512      *
513      * IMPORTANT: because control is transferred to `recipient`, care must be
514      * taken to not create reentrancy vulnerabilities. Consider using
515      * {ReentrancyGuard} or the
516      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
517      */
518     function sendValue(address payable recipient, uint256 amount) internal {
519         require(address(this).balance >= amount, "Address: insufficient balance");
520 
521         (bool success, ) = recipient.call{value: amount}("");
522         require(success, "Address: unable to send value, recipient may have reverted");
523     }
524 
525     /**
526      * @dev Performs a Solidity function call using a low level `call`. A
527      * plain `call` is an unsafe replacement for a function call: use this
528      * function instead.
529      *
530      * If `target` reverts with a revert reason, it is bubbled up by this
531      * function (like regular Solidity function calls).
532      *
533      * Returns the raw returned data. To convert to the expected return value,
534      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
535      *
536      * Requirements:
537      *
538      * - `target` must be a contract.
539      * - calling `target` with `data` must not revert.
540      *
541      * _Available since v3.1._
542      */
543     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
544         return functionCall(target, data, "Address: low-level call failed");
545     }
546 
547     /**
548      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
549      * `errorMessage` as a fallback revert reason when `target` reverts.
550      *
551      * _Available since v3.1._
552      */
553     function functionCall(
554         address target,
555         bytes memory data,
556         string memory errorMessage
557     ) internal returns (bytes memory) {
558         return functionCallWithValue(target, data, 0, errorMessage);
559     }
560 
561     /**
562      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
563      * but also transferring `value` wei to `target`.
564      *
565      * Requirements:
566      *
567      * - the calling contract must have an ETH balance of at least `value`.
568      * - the called Solidity function must be `payable`.
569      *
570      * _Available since v3.1._
571      */
572     function functionCallWithValue(
573         address target,
574         bytes memory data,
575         uint256 value
576     ) internal returns (bytes memory) {
577         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
578     }
579 
580     /**
581      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
582      * with `errorMessage` as a fallback revert reason when `target` reverts.
583      *
584      * _Available since v3.1._
585      */
586     function functionCallWithValue(
587         address target,
588         bytes memory data,
589         uint256 value,
590         string memory errorMessage
591     ) internal returns (bytes memory) {
592         require(address(this).balance >= value, "Address: insufficient balance for call");
593         require(isContract(target), "Address: call to non-contract");
594 
595         (bool success, bytes memory returndata) = target.call{value: value}(data);
596         return verifyCallResult(success, returndata, errorMessage);
597     }
598 
599     /**
600      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
601      * but performing a static call.
602      *
603      * _Available since v3.3._
604      */
605     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
606         return functionStaticCall(target, data, "Address: low-level static call failed");
607     }
608 
609     /**
610      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
611      * but performing a static call.
612      *
613      * _Available since v3.3._
614      */
615     function functionStaticCall(
616         address target,
617         bytes memory data,
618         string memory errorMessage
619     ) internal view returns (bytes memory) {
620         require(isContract(target), "Address: static call to non-contract");
621 
622         (bool success, bytes memory returndata) = target.staticcall(data);
623         return verifyCallResult(success, returndata, errorMessage);
624     }
625 
626     /**
627      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
628      * but performing a delegate call.
629      *
630      * _Available since v3.4._
631      */
632     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
633         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
634     }
635 
636     /**
637      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
638      * but performing a delegate call.
639      *
640      * _Available since v3.4._
641      */
642     function functionDelegateCall(
643         address target,
644         bytes memory data,
645         string memory errorMessage
646     ) internal returns (bytes memory) {
647         require(isContract(target), "Address: delegate call to non-contract");
648 
649         (bool success, bytes memory returndata) = target.delegatecall(data);
650         return verifyCallResult(success, returndata, errorMessage);
651     }
652 
653     /**
654      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
655      * revert reason using the provided one.
656      *
657      * _Available since v4.3._
658      */
659     function verifyCallResult(
660         bool success,
661         bytes memory returndata,
662         string memory errorMessage
663     ) internal pure returns (bytes memory) {
664         if (success) {
665             return returndata;
666         } else {
667             // Look for revert reason and bubble it up if present
668             if (returndata.length > 0) {
669                 // The easiest way to bubble the revert reason is using memory via assembly
670 
671                 assembly {
672                     let returndata_size := mload(returndata)
673                     revert(add(32, returndata), returndata_size)
674                 }
675             } else {
676                 revert(errorMessage);
677             }
678         }
679     }
680 }
681 
682 
683 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.2
684 
685 
686 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
687 
688 
689 
690 /**
691  * @dev Implementation of the {IERC165} interface.
692  *
693  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
694  * for the additional interface id that will be supported. For example:
695  *
696  * ```solidity
697  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
698  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
699  * }
700  * ```
701  *
702  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
703  */
704 abstract contract ERC165 is IERC165 {
705     /**
706      * @dev See {IERC165-supportsInterface}.
707      */
708     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
709         return interfaceId == type(IERC165).interfaceId;
710     }
711 }
712 
713 
714 // File contracts/ERC721A.sol
715 
716 
717 // Creator: Chiru Labs
718 
719 
720 /**
721  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
722  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
723  *
724  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
725  *
726  * Does not support burning tokens to address(0).
727  *
728  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
729  */
730 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
731     using Address for address;
732     using Strings for uint256;
733 
734     struct TokenOwnership {
735         address addr;
736         uint64 startTimestamp;
737     }
738 
739     struct AddressData {
740         uint128 balance;
741         uint128 numberMinted;
742     }
743 
744     uint256 internal currentIndex = 1;
745 
746     // Token name
747     string private _name;
748 
749     // Token symbol
750     string private _symbol;
751 
752     // Mapping from token ID to ownership details
753     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
754     mapping(uint256 => TokenOwnership) internal _ownerships;
755 
756     // Mapping owner address to address data
757     mapping(address => AddressData) private _addressData;
758 
759     // Mapping from token ID to approved address
760     mapping(uint256 => address) private _tokenApprovals;
761 
762     // Mapping from owner to operator approvals
763     mapping(address => mapping(address => bool)) private _operatorApprovals;
764 
765     constructor(string memory name_, string memory symbol_) {
766         _name = name_;
767         _symbol = symbol_;
768     }
769 
770     /**
771      * @dev See {IERC721Enumerable-totalSupply}.
772      */
773     function totalSupply() public view override returns (uint256) {
774         return currentIndex;
775     }
776 
777     /**
778      * @dev See {IERC721Enumerable-tokenByIndex}.
779      */
780     function tokenByIndex(uint256 index) public view override returns (uint256) {
781         require(index < totalSupply(), 'ERC721A: global index out of bounds');
782         return index;
783     }
784 
785     /**
786      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
787      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
788      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
789      */
790     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
791         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
792         uint256 numMintedSoFar = totalSupply();
793         uint256 tokenIdsIdx = 0;
794         address currOwnershipAddr = address(0);
795         for (uint256 i = 0; i < numMintedSoFar; i++) {
796             TokenOwnership memory ownership = _ownerships[i];
797             if (ownership.addr != address(0)) {
798                 currOwnershipAddr = ownership.addr;
799             }
800             if (currOwnershipAddr == owner) {
801                 if (tokenIdsIdx == index) {
802                     return i;
803                 }
804                 tokenIdsIdx++;
805             }
806         }
807         revert('ERC721A: unable to get token of owner by index');
808     }
809 
810     /**
811      * @dev See {IERC165-supportsInterface}.
812      */
813     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
814         return
815             interfaceId == type(IERC721).interfaceId ||
816             interfaceId == type(IERC721Metadata).interfaceId ||
817             interfaceId == type(IERC721Enumerable).interfaceId ||
818             super.supportsInterface(interfaceId);
819     }
820 
821     /**
822      * @dev See {IERC721-balanceOf}.
823      */
824     function balanceOf(address owner) public view override returns (uint256) {
825         require(owner != address(0), 'ERC721A: balance query for the zero address');
826         return uint256(_addressData[owner].balance);
827     }
828 
829     function _numberMinted(address owner) internal view returns (uint256) {
830         require(owner != address(0), 'ERC721A: number minted query for the zero address');
831         return uint256(_addressData[owner].numberMinted);
832     }
833 
834     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
835         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
836 
837         for (uint256 curr = tokenId; ; curr--) {
838             TokenOwnership memory ownership = _ownerships[curr];
839             if (ownership.addr != address(0)) {
840                 return ownership;
841             }
842         }
843 
844         revert('ERC721A: unable to determine the owner of token');
845     }
846 
847     /**
848      * @dev See {IERC721-ownerOf}.
849      */
850     function ownerOf(uint256 tokenId) public view override returns (address) {
851         return ownershipOf(tokenId).addr;
852     }
853 
854     /**
855      * @dev See {IERC721Metadata-name}.
856      */
857     function name() public view virtual override returns (string memory) {
858         return _name;
859     }
860 
861     /**
862      * @dev See {IERC721Metadata-symbol}.
863      */
864     function symbol() public view virtual override returns (string memory) {
865         return _symbol;
866     }
867 
868     /**
869      * @dev See {IERC721Metadata-tokenURI}.
870      */
871     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
872         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
873 
874         string memory baseURI = _baseURI();
875         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
876     }
877 
878     /**
879      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
880      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
881      * by default, can be overriden in child contracts.
882      */
883     function _baseURI() internal view virtual returns (string memory) {
884         return '';
885     }
886 
887     /**
888      * @dev See {IERC721-approve}.
889      */
890     function approve(address to, uint256 tokenId) public override {
891         address owner = ERC721A.ownerOf(tokenId);
892         require(to != owner, 'ERC721A: approval to current owner');
893 
894         require(
895             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
896             'ERC721A: approve caller is not owner nor approved for all'
897         );
898 
899         _approve(to, tokenId, owner);
900     }
901 
902     /**
903      * @dev See {IERC721-getApproved}.
904      */
905     function getApproved(uint256 tokenId) public view override returns (address) {
906         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
907 
908         return _tokenApprovals[tokenId];
909     }
910 
911     /**
912      * @dev See {IERC721-setApprovalForAll}.
913      */
914     function setApprovalForAll(address operator, bool approved) public override {
915         require(operator != _msgSender(), 'ERC721A: approve to caller');
916 
917         _operatorApprovals[_msgSender()][operator] = approved;
918         emit ApprovalForAll(_msgSender(), operator, approved);
919     }
920 
921     /**
922      * @dev See {IERC721-isApprovedForAll}.
923      */
924     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
925         return _operatorApprovals[owner][operator];
926     }
927 
928     /**
929      * @dev See {IERC721-transferFrom}.
930      */
931     function transferFrom(
932         address from,
933         address to,
934         uint256 tokenId
935     ) public override {
936         _transfer(from, to, tokenId);
937     }
938 
939     /**
940      * @dev See {IERC721-safeTransferFrom}.
941      */
942     function safeTransferFrom(
943         address from,
944         address to,
945         uint256 tokenId
946     ) public override {
947         safeTransferFrom(from, to, tokenId, '');
948     }
949 
950     /**
951      * @dev See {IERC721-safeTransferFrom}.
952      */
953     function safeTransferFrom(
954         address from,
955         address to,
956         uint256 tokenId,
957         bytes memory _data
958     ) public override {
959         _transfer(from, to, tokenId);
960         require(
961             _checkOnERC721Received(from, to, tokenId, _data),
962             'ERC721A: transfer to non ERC721Receiver implementer'
963         );
964     }
965 
966     /**
967      * @dev Returns whether `tokenId` exists.
968      *
969      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
970      *
971      * Tokens start existing when they are minted (`_mint`),
972      */
973     function _exists(uint256 tokenId) internal view returns (bool) {
974         return tokenId < currentIndex;
975     }
976 
977     function _safeMint(address to, uint256 quantity) internal {
978         _safeMint(to, quantity, '');
979     }
980 
981     /**
982      * @dev Mints `quantity` tokens and transfers them to `to`.
983      *
984      * Requirements:
985      *
986      * - `to` cannot be the zero address.
987      * - `quantity` cannot be larger than the max batch size.
988      *
989      * Emits a {Transfer} event.
990      */
991     function _safeMint(
992         address to,
993         uint256 quantity,
994         bytes memory _data
995     ) internal {
996         uint256 startTokenId = currentIndex;
997         require(to != address(0), 'ERC721A: mint to the zero address');
998         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
999         require(!_exists(startTokenId), 'ERC721A: token already minted');
1000         require(quantity > 0, 'ERC721A: quantity must be greater 0');
1001 
1002         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1003 
1004         AddressData memory addressData = _addressData[to];
1005         _addressData[to] = AddressData(
1006             addressData.balance + uint128(quantity),
1007             addressData.numberMinted + uint128(quantity)
1008         );
1009         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1010 
1011         uint256 updatedIndex = startTokenId;
1012 
1013         for (uint256 i = 0; i < quantity; i++) {
1014             emit Transfer(address(0), to, updatedIndex);
1015             require(
1016                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1017                 'ERC721A: transfer to non ERC721Receiver implementer'
1018             );
1019             updatedIndex++;
1020         }
1021 
1022         currentIndex = updatedIndex;
1023         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1024     }
1025 
1026     /**
1027      * @dev Transfers `tokenId` from `from` to `to`.
1028      *
1029      * Requirements:
1030      *
1031      * - `to` cannot be the zero address.
1032      * - `tokenId` token must be owned by `from`.
1033      *
1034      * Emits a {Transfer} event.
1035      */
1036     function _transfer(
1037         address from,
1038         address to,
1039         uint256 tokenId
1040     ) private {
1041         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1042 
1043         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1044             getApproved(tokenId) == _msgSender() ||
1045             isApprovedForAll(prevOwnership.addr, _msgSender()));
1046 
1047         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1048 
1049         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1050         require(to != address(0), 'ERC721A: transfer to the zero address');
1051 
1052         _beforeTokenTransfers(from, to, tokenId, 1);
1053 
1054         // Clear approvals from the previous owner
1055         _approve(address(0), tokenId, prevOwnership.addr);
1056 
1057         // Underflow of the sender's balance is impossible because we check for
1058         // ownership above and the recipient's balance can't realistically overflow.
1059         unchecked {
1060             _addressData[from].balance -= 1;
1061             _addressData[to].balance += 1;
1062         }
1063 
1064         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1065 
1066         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1067         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1068         uint256 nextTokenId = tokenId + 1;
1069         if (_ownerships[nextTokenId].addr == address(0)) {
1070             if (_exists(nextTokenId)) {
1071                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1072             }
1073         }
1074 
1075         emit Transfer(from, to, tokenId);
1076         _afterTokenTransfers(from, to, tokenId, 1);
1077     }
1078 
1079     /**
1080      * @dev Approve `to` to operate on `tokenId`
1081      *
1082      * Emits a {Approval} event.
1083      */
1084     function _approve(
1085         address to,
1086         uint256 tokenId,
1087         address owner
1088     ) private {
1089         _tokenApprovals[tokenId] = to;
1090         emit Approval(owner, to, tokenId);
1091     }
1092 
1093     /**
1094      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1095      * The call is not executed if the target address is not a contract.
1096      *
1097      * @param from address representing the previous owner of the given token ID
1098      * @param to target address that will receive the tokens
1099      * @param tokenId uint256 ID of the token to be transferred
1100      * @param _data bytes optional data to send along with the call
1101      * @return bool whether the call correctly returned the expected magic value
1102      */
1103     function _checkOnERC721Received(
1104         address from,
1105         address to,
1106         uint256 tokenId,
1107         bytes memory _data
1108     ) private returns (bool) {
1109         if (to.isContract()) {
1110             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1111                 return retval == IERC721Receiver(to).onERC721Received.selector;
1112             } catch (bytes memory reason) {
1113                 if (reason.length == 0) {
1114                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1115                 } else {
1116                     assembly {
1117                         revert(add(32, reason), mload(reason))
1118                     }
1119                 }
1120             }
1121         } else {
1122             return true;
1123         }
1124     }
1125 
1126     /**
1127      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1128      *
1129      * startTokenId - the first token id to be transferred
1130      * quantity - the amount to be transferred
1131      *
1132      * Calling conditions:
1133      *
1134      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1135      * transferred to `to`.
1136      * - When `from` is zero, `tokenId` will be minted for `to`.
1137      */
1138     function _beforeTokenTransfers(
1139         address from,
1140         address to,
1141         uint256 startTokenId,
1142         uint256 quantity
1143     ) internal virtual {}
1144 
1145     /**
1146      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1147      * minting.
1148      *
1149      * startTokenId - the first token id to be transferred
1150      * quantity - the amount to be transferred
1151      *
1152      * Calling conditions:
1153      *
1154      * - when `from` and `to` are both non-zero.
1155      * - `from` and `to` are never both zero.
1156      */
1157     function _afterTokenTransfers(
1158         address from,
1159         address to,
1160         uint256 startTokenId,
1161         uint256 quantity
1162     ) internal virtual {}
1163 }
1164 
1165 
1166 // File contracts/TheDoodlesApes.sol
1167 
1168 
1169 contract TheDoodlesApes is ERC721A, Ownable {
1170 
1171     string public baseURI = "";
1172     string public contractURI = "";
1173     string public constant baseExtension = ".json";
1174     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1175 
1176     uint256 public constant MAX_PER_TX_FREE = 5;
1177     uint256 public constant MAX_PER_TX = 10;
1178     uint256 public constant FREE_MAX_SUPPLY = 1722;
1179     uint256 public constant MAX_SUPPLY = 2222;
1180     uint256 public price = 0.005 ether;
1181 
1182     bool public paused = true;
1183 
1184     constructor() ERC721A("TheDoodlesApes", "TDA") {}
1185 
1186     function mint(uint256 _amount) external payable {
1187         address _caller = _msgSender();
1188         require(!paused, "Paused");
1189         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1190         require(_amount > 0, "No 0 mints");
1191         require(tx.origin == _caller, "No contracts");
1192 
1193         if(FREE_MAX_SUPPLY >= totalSupply()){
1194             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
1195         }else{
1196             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1197             require(_amount * price == msg.value, "Invalid funds provided");
1198         }
1199 
1200         _safeMint(_caller, _amount);
1201     }
1202 
1203     function setCost(uint256 _newCost) public onlyOwner {
1204         price = _newCost;
1205     }
1206 
1207     function isApprovedForAll(address owner, address operator)
1208         override
1209         public
1210         view
1211         returns (bool)
1212     {
1213         // Whitelist OpenSea proxy contract for easy trading.
1214         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1215         if (address(proxyRegistry.proxies(owner)) == operator) {
1216             return true;
1217         }
1218 
1219         return super.isApprovedForAll(owner, operator);
1220     }
1221 
1222     function withdraw() external onlyOwner {
1223         uint256 balance = address(this).balance;
1224         (bool success, ) = _msgSender().call{value: balance}("");
1225         require(success, "Failed to send");
1226     }
1227 
1228     function setupOS() external onlyOwner {
1229         _safeMint(_msgSender(), 1);
1230     }
1231 
1232     function pause(bool _state) external onlyOwner {
1233         paused = _state;
1234     }
1235 
1236     function setBaseURI(string memory baseURI_) external onlyOwner {
1237         baseURI = baseURI_;
1238     }
1239 
1240     function setContractURI(string memory _contractURI) external onlyOwner {
1241         contractURI = _contractURI;
1242     }
1243 
1244     function Currentprice() public view returns (uint256){
1245         if (FREE_MAX_SUPPLY >= totalSupply()) {
1246             return 0;
1247         }else{
1248             return price;
1249         }
1250     }
1251 
1252     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1253         require(_exists(_tokenId), "Token does not exist.");
1254         return bytes(baseURI).length > 0 ? string(
1255             abi.encodePacked(
1256               baseURI,
1257               Strings.toString(_tokenId),
1258               baseExtension
1259             )
1260         ) : "";
1261     }
1262 }
1263 
1264 contract OwnableDelegateProxy { }
1265 contract ProxyRegistry {
1266     mapping(address => OwnableDelegateProxy) public proxies;
1267 }