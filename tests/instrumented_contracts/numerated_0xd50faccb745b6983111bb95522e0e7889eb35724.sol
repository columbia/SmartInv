1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-26
3 */
4 
5 // ........................................................................................................................
6 // ........................................................................................................................
7 // .....................................................%%%%%..............................................................
8 // ...................................................%%,,,%%..............................................................
9 // ................................................%%%,,%%%................................................................
10 // ..............................................%%***,,%%%................................................................
11 // ..............................................%%***,,%%%................................................................
12 // ..............................................%%***,,,,,%%..............................................................
13 // ..............................................%%***,,,,,,,%%,.........%%%%%.............................................
14 // ................................................%%%**,,,,,,,%%%%%%%%%%,,#%%.............................................
15 // ...................................................%%***,,,,,,,,,,,,,,%%*...............................................
16 // .....................................................%%%************%%..................................................
17 // .......................................................,%%%%%%%%%%%%....................................................
18 // ........................................................................................................................
19 // .......................................@@...............................................................................
20 // ....................................@@@((@@@............................................................................
21 // ..................................@@#####(((@@...............................@@@@@@@@@@.................................
22 // ..................................@@########((@@,.......................&@@@@(((((##@@@.................................
23 // ..................................@@##########((@@@...................@@#((((#######@@@.................................
24 // ..................................@@##########((###@@@@@@@@@@@@@@@@@@@(((((#######@@*...................................
25 // ..................................@@##########(((((###################(((((#######@@*...................................
26 // ..................................@@########(((((((((###############(((((((#######@@*...................................
27 // ....................................@@@((((((((((((((((((((((((((((((((((((((#####@@*...................................
28 // ....................................@@@(((((((((((((((((((((((((((((((((((((((((@@......................................
29 // ....................................@@@(((((#######%%%%%##((((((((((##%%%%%##(((@@......................................
30 // ..................................@@(((((#######%%%@@@@@%%##(((((###%%@@@@@%%###@@......................................
31 // ..................................@@(((((#####%%@@@**@@@  %%#####%%%@@@@.  @@%%%##@@*...................................
32 // ..................................@@(((#######%%@@@**@@@**%%#####%%%**@@(**@@%%%##@@*...................................
33 // ..................................@@(((#########%%%*******%%#####%%%*******%%#######@@@.................................
34 // ..................................@@(((############%%%%%%%##********%%%%%%%#########@@@.................................
35 // ..................................@@(((((#################************############((@@@.................................
36 // ..................................@@((((((((############****@@@@@@@@****(#######((@@*...................................
37 // ..................................@@(((((((((((((####*******/((@@@@@*******(((((((@@*...................................
38 // ..................................@@((((((((((     ************&&(((*******((     @@*...................................
39 // ..................................@@(((((     (((((*****&&*****&&*****&&/**  (((((  %@@.................................
40 // ..................................@@(((  (((((  /((*******&&&&&**&&&&&*******   ((((.  .................................
41 // ...............................,@@((((((((((  (((((((**********************(((((  (((((@@...............................
42 // ...............................,@@(((((((   (((((((((%%%%%************%%%%%((((((((((((@@...............................
43 // ...............................,@@(((((((((((((((((((#####%%%%%%%%%%%%#####((((((((((((((@@@............................
44 // .............................@@@((((((((((((((((((((((((###################((((((((((((((@@@............................
45 // .............................@@@((((((((((((((((((((((((################((((((((((((((((((((@@..........................
46 // .............................@@@((((((((((((((((((((((((################((((((((((((((((((((@@..........................
47 // ...........................@@(((((((((((((((((((((((((((###################(((((((((((((((((((@@*.......................
48 // ...........................@@((((((((((((((((((((((((########################(((((((((((((((((@@*.......................
49 // ...........................@@((((((((((((((((((((((((###########################((((((((((((((((&@@.....................
50 // ...........................@@((((((((((((((((((((((#############################((((((((((((((((&@@.....................
51 // ........................@@@((((((((((((((((((((((((###############################(((((((((((((((((@@,,,................
52 // ........................@@@(((((((((((((((((((((##################################(((((((((((((((((((@@@................
53 
54 // File: @openzeppelin/contracts/utils/Strings.sol
55 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
56 // SPDX-License-Identifier: Unlicense
57 
58 pragma solidity ^0.8.0;
59 
60 /**
61  * @dev String operations.
62  */
63 library Strings {
64     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
65 
66     /**
67      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
68      */
69     function toString(uint256 value) internal pure returns (string memory) {
70         // Inspired by OraclizeAPI's implementation - MIT licence
71         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
72 
73         if (value == 0) {
74             return "0";
75         }
76         uint256 temp = value;
77         uint256 digits;
78         while (temp != 0) {
79             digits++;
80             temp /= 10;
81         }
82         bytes memory buffer = new bytes(digits);
83         while (value != 0) {
84             digits -= 1;
85             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
86             value /= 10;
87         }
88         return string(buffer);
89     }
90 
91     /**
92      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
93      */
94     function toHexString(uint256 value) internal pure returns (string memory) {
95         if (value == 0) {
96             return "0x00";
97         }
98         uint256 temp = value;
99         uint256 length = 0;
100         while (temp != 0) {
101             length++;
102             temp >>= 8;
103         }
104         return toHexString(value, length);
105     }
106 
107     /**
108      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
109      */
110     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
111         bytes memory buffer = new bytes(2 * length + 2);
112         buffer[0] = "0";
113         buffer[1] = "x";
114         for (uint256 i = 2 * length + 1; i > 1; --i) {
115             buffer[i] = _HEX_SYMBOLS[value & 0xf];
116             value >>= 4;
117         }
118         require(value == 0, "Strings: hex length insufficient");
119         return string(buffer);
120     }
121 }
122 
123 // File: @openzeppelin/contracts/utils/Context.sol
124 
125 
126 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
127 
128 pragma solidity ^0.8.0;
129 
130 /**
131  * @dev Provides information about the current execution context, including the
132  * sender of the transaction and its data. While these are generally available
133  * via msg.sender and msg.data, they should not be accessed in such a direct
134  * manner, since when dealing with meta-transactions the account sending and
135  * paying for execution may not be the actual sender (as far as an application
136  * is concerned).
137  *
138  * This contract is only required for intermediate, library-like contracts.
139  */
140 abstract contract Context {
141     function _msgSender() internal view virtual returns (address) {
142         return msg.sender;
143     }
144 
145     function _msgData() internal view virtual returns (bytes calldata) {
146         return msg.data;
147     }
148 }
149 
150 // File: @openzeppelin/contracts/utils/Address.sol
151 
152 
153 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
154 
155 pragma solidity ^0.8.1;
156 
157 /**
158  * @dev Collection of functions related to the address type
159  */
160 library Address {
161     /**
162      * @dev Returns true if `account` is a contract.
163      *
164      * [IMPORTANT]
165      * ====
166      * It is unsafe to assume that an address for which this function returns
167      * false is an externally-owned account (EOA) and not a contract.
168      *
169      * Among others, `isContract` will return false for the following
170      * types of addresses:
171      *
172      *  - an externally-owned account
173      *  - a contract in construction
174      *  - an address where a contract will be created
175      *  - an address where a contract lived, but was destroyed
176      * ====
177      *
178      * [IMPORTANT]
179      * ====
180      * You shouldn't rely on `isContract` to protect against flash loan attacks!
181      *
182      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
183      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
184      * constructor.
185      * ====
186      */
187     function isContract(address account) internal view returns (bool) {
188         // This method relies on extcodesize/address.code.length, which returns 0
189         // for contracts in construction, since the code is only stored at the end
190         // of the constructor execution.
191 
192         return account.code.length > 0;
193     }
194 
195     /**
196      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
197      * `recipient`, forwarding all available gas and reverting on errors.
198      *
199      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
200      * of certain opcodes, possibly making contracts go over the 2300 gas limit
201      * imposed by `transfer`, making them unable to receive funds via
202      * `transfer`. {sendValue} removes this limitation.
203      *
204      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
205      *
206      * IMPORTANT: because control is transferred to `recipient`, care must be
207      * taken to not create reentrancy vulnerabilities. Consider using
208      * {ReentrancyGuard} or the
209      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
210      */
211     function sendValue(address payable recipient, uint256 amount) internal {
212         require(address(this).balance >= amount, "Address: insufficient balance");
213 
214         (bool success, ) = recipient.call{value: amount}("");
215         require(success, "Address: unable to send value, recipient may have reverted");
216     }
217 
218     /**
219      * @dev Performs a Solidity function call using a low level `call`. A
220      * plain `call` is an unsafe replacement for a function call: use this
221      * function instead.
222      *
223      * If `target` reverts with a revert reason, it is bubbled up by this
224      * function (like regular Solidity function calls).
225      *
226      * Returns the raw returned data. To convert to the expected return value,
227      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
228      *
229      * Requirements:
230      *
231      * - `target` must be a contract.
232      * - calling `target` with `data` must not revert.
233      *
234      * _Available since v3.1._
235      */
236     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
237         return functionCall(target, data, "Address: low-level call failed");
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
242      * `errorMessage` as a fallback revert reason when `target` reverts.
243      *
244      * _Available since v3.1._
245      */
246     function functionCall(
247         address target,
248         bytes memory data,
249         string memory errorMessage
250     ) internal returns (bytes memory) {
251         return functionCallWithValue(target, data, 0, errorMessage);
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
256      * but also transferring `value` wei to `target`.
257      *
258      * Requirements:
259      *
260      * - the calling contract must have an ETH balance of at least `value`.
261      * - the called Solidity function must be `payable`.
262      *
263      * _Available since v3.1._
264      */
265     function functionCallWithValue(
266         address target,
267         bytes memory data,
268         uint256 value
269     ) internal returns (bytes memory) {
270         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
271     }
272 
273     /**
274      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
275      * with `errorMessage` as a fallback revert reason when `target` reverts.
276      *
277      * _Available since v3.1._
278      */
279     function functionCallWithValue(
280         address target,
281         bytes memory data,
282         uint256 value,
283         string memory errorMessage
284     ) internal returns (bytes memory) {
285         require(address(this).balance >= value, "Address: insufficient balance for call");
286         require(isContract(target), "Address: call to non-contract");
287 
288         (bool success, bytes memory returndata) = target.call{value: value}(data);
289         return verifyCallResult(success, returndata, errorMessage);
290     }
291 
292     /**
293      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
294      * but performing a static call.
295      *
296      * _Available since v3.3._
297      */
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
375 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
376 
377 
378 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
379 
380 pragma solidity ^0.8.0;
381 
382 /**
383  * @title ERC721 token receiver interface
384  * @dev Interface for any contract that wants to support safeTransfers
385  * from ERC721 asset contracts.
386  */
387 interface IERC721Receiver {
388     /**
389      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
390      * by `operator` from `from`, this function is called.
391      *
392      * It must return its Solidity selector to confirm the token transfer.
393      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
394      *
395      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
396      */
397     function onERC721Received(
398         address operator,
399         address from,
400         uint256 tokenId,
401         bytes calldata data
402     ) external returns (bytes4);
403 }
404 
405 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
406 
407 
408 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
409 
410 pragma solidity ^0.8.0;
411 
412 /**
413  * @dev Interface of the ERC165 standard, as defined in the
414  * https://eips.ethereum.org/EIPS/eip-165[EIP].
415  *
416  * Implementers can declare support of contract interfaces, which can then be
417  * queried by others ({ERC165Checker}).
418  *
419  * For an implementation, see {ERC165}.
420  */
421 interface IERC165 {
422     /**
423      * @dev Returns true if this contract implements the interface defined by
424      * `interfaceId`. See the corresponding
425      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
426      * to learn more about how these ids are created.
427      *
428      * This function call must use less than 30 000 gas.
429      */
430     function supportsInterface(bytes4 interfaceId) external view returns (bool);
431 }
432 
433 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
434 
435 
436 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
437 
438 pragma solidity ^0.8.0;
439 
440 
441 /**
442  * @dev Implementation of the {IERC165} interface.
443  *
444  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
445  * for the additional interface id that will be supported. For example:
446  *
447  * ```solidity
448  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
449  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
450  * }
451  * ```
452  *
453  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
454  */
455 abstract contract ERC165 is IERC165 {
456     /**
457      * @dev See {IERC165-supportsInterface}.
458      */
459     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
460         return interfaceId == type(IERC165).interfaceId;
461     }
462 }
463 
464 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
465 
466 
467 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
468 
469 pragma solidity ^0.8.0;
470 
471 
472 /**
473  * @dev Required interface of an ERC721 compliant contract.
474  */
475 interface IERC721 is IERC165 {
476     /**
477      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
478      */
479     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
480 
481     /**
482      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
483      */
484     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
485 
486     /**
487      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
488      */
489     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
490 
491     /**
492      * @dev Returns the number of tokens in ``owner``'s account.
493      */
494     function balanceOf(address owner) external view returns (uint256 balance);
495 
496     /**
497      * @dev Returns the owner of the `tokenId` token.
498      *
499      * Requirements:
500      *
501      * - `tokenId` must exist.
502      */
503     function ownerOf(uint256 tokenId) external view returns (address owner);
504 
505     /**
506      * @dev Safely transfers `tokenId` token from `from` to `to`.
507      *
508      * Requirements:
509      *
510      * - `from` cannot be the zero address.
511      * - `to` cannot be the zero address.
512      * - `tokenId` token must exist and be owned by `from`.
513      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
514      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
515      *
516      * Emits a {Transfer} event.
517      */
518     function safeTransferFrom(
519         address from,
520         address to,
521         uint256 tokenId,
522         bytes calldata data
523     ) external;
524 
525     /**
526      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
527      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
528      *
529      * Requirements:
530      *
531      * - `from` cannot be the zero address.
532      * - `to` cannot be the zero address.
533      * - `tokenId` token must exist and be owned by `from`.
534      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
535      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
536      *
537      * Emits a {Transfer} event.
538      */
539     function safeTransferFrom(
540         address from,
541         address to,
542         uint256 tokenId
543     ) external;
544 
545     /**
546      * @dev Transfers `tokenId` token from `from` to `to`.
547      *
548      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
549      *
550      * Requirements:
551      *
552      * - `from` cannot be the zero address.
553      * - `to` cannot be the zero address.
554      * - `tokenId` token must be owned by `from`.
555      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
556      *
557      * Emits a {Transfer} event.
558      */
559     function transferFrom(
560         address from,
561         address to,
562         uint256 tokenId
563     ) external;
564 
565     /**
566      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
567      * The approval is cleared when the token is transferred.
568      *
569      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
570      *
571      * Requirements:
572      *
573      * - The caller must own the token or be an approved operator.
574      * - `tokenId` must exist.
575      *
576      * Emits an {Approval} event.
577      */
578     function approve(address to, uint256 tokenId) external;
579 
580     /**
581      * @dev Approve or remove `operator` as an operator for the caller.
582      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
583      *
584      * Requirements:
585      *
586      * - The `operator` cannot be the caller.
587      *
588      * Emits an {ApprovalForAll} event.
589      */
590     function setApprovalForAll(address operator, bool _approved) external;
591 
592     /**
593      * @dev Returns the account approved for `tokenId` token.
594      *
595      * Requirements:
596      *
597      * - `tokenId` must exist.
598      */
599     function getApproved(uint256 tokenId) external view returns (address operator);
600 
601     /**
602      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
603      *
604      * See {setApprovalForAll}
605      */
606     function isApprovedForAll(address owner, address operator) external view returns (bool);
607 }
608 
609 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
610 
611 
612 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
613 
614 pragma solidity ^0.8.0;
615 
616 
617 /**
618  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
619  * @dev See https://eips.ethereum.org/EIPS/eip-721
620  */
621 interface IERC721Enumerable is IERC721 {
622     /**
623      * @dev Returns the total amount of tokens stored by the contract.
624      */
625     function totalSupply() external view returns (uint256);
626 
627     /**
628      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
629      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
630      */
631     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
632 
633     /**
634      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
635      * Use along with {totalSupply} to enumerate all tokens.
636      */
637     function tokenByIndex(uint256 index) external view returns (uint256);
638 }
639 
640 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
641 
642 
643 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
644 
645 pragma solidity ^0.8.0;
646 
647 
648 /**
649  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
650  * @dev See https://eips.ethereum.org/EIPS/eip-721
651  */
652 interface IERC721Metadata is IERC721 {
653     /**
654      * @dev Returns the token collection name.
655      */
656     function name() external view returns (string memory);
657 
658     /**
659      * @dev Returns the token collection symbol.
660      */
661     function symbol() external view returns (string memory);
662 
663     /**
664      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
665      */
666     function tokenURI(uint256 tokenId) external view returns (string memory);
667 }
668 
669 // File: ERC721A.sol
670 
671 
672 // Creator: Chiru Labs
673 
674 pragma solidity ^0.8.0;
675 
676 
677 
678 
679 
680 
681 
682 
683 
684 /**
685  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
686  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
687  *
688  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
689  *
690  * Does not support burning tokens to address(0).
691  *
692  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
693  */
694 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
695     using Address for address;
696     using Strings for uint256;
697 
698     struct TokenOwnership {
699         address addr;
700         uint64 startTimestamp;
701     }
702 
703     struct AddressData {
704         uint128 balance;
705         uint128 numberMinted;
706     }
707 
708     uint256 internal currentIndex = 1;
709 
710     // Token name
711     string private _name;
712 
713     // Token symbol
714     string private _symbol;
715 
716     // Mapping from token ID to ownership details
717     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
718     mapping(uint256 => TokenOwnership) internal _ownerships;
719 
720     // Mapping owner address to address data
721     mapping(address => AddressData) private _addressData;
722 
723     // Mapping from token ID to approved address
724     mapping(uint256 => address) private _tokenApprovals;
725 
726     // Mapping from owner to operator approvals
727     mapping(address => mapping(address => bool)) private _operatorApprovals;
728 
729     constructor(string memory name_, string memory symbol_) {
730         _name = name_;
731         _symbol = symbol_;
732     }
733 
734     /**
735      * @dev See {IERC721Enumerable-totalSupply}.
736      */
737     function totalSupply() public view override returns (uint256) {
738         return currentIndex;
739     }
740 
741     /**
742      * @dev See {IERC721Enumerable-tokenByIndex}.
743      */
744     function tokenByIndex(uint256 index) public view override returns (uint256) {
745         require(index < totalSupply(), 'ERC721A: global index out of bounds');
746         return index;
747     }
748 
749     /**
750      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
751      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
752      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
753      */
754     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
755         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
756         uint256 numMintedSoFar = totalSupply();
757         uint256 tokenIdsIdx;
758         address currOwnershipAddr;
759 
760         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
761         unchecked {
762             for (uint256 i; i < numMintedSoFar; i++) {
763                 TokenOwnership memory ownership = _ownerships[i];
764                 if (ownership.addr != address(0)) {
765                     currOwnershipAddr = ownership.addr;
766                 }
767                 if (currOwnershipAddr == owner) {
768                     if (tokenIdsIdx == index) {
769                         return i;
770                     }
771                     tokenIdsIdx++;
772                 }
773             }
774         }
775 
776         revert('ERC721A: unable to get token of owner by index');
777     }
778 
779     /**
780      * @dev See {IERC165-supportsInterface}.
781      */
782     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
783         return
784             interfaceId == type(IERC721).interfaceId ||
785             interfaceId == type(IERC721Metadata).interfaceId ||
786             interfaceId == type(IERC721Enumerable).interfaceId ||
787             super.supportsInterface(interfaceId);
788     }
789 
790     /**
791      * @dev See {IERC721-balanceOf}.
792      */
793     function balanceOf(address owner) public view override returns (uint256) {
794         require(owner != address(0), 'ERC721A: balance query for the zero address');
795         return uint256(_addressData[owner].balance);
796     }
797 
798     function _numberMinted(address owner) internal view returns (uint256) {
799         require(owner != address(0), 'ERC721A: number minted query for the zero address');
800         return uint256(_addressData[owner].numberMinted);
801     }
802 
803     /**
804      * Gas spent here starts off proportional to the maximum mint batch size.
805      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
806      */
807     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
808         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
809 
810         unchecked {
811             for (uint256 curr = tokenId; curr >= 0; curr--) {
812                 TokenOwnership memory ownership = _ownerships[curr];
813                 if (ownership.addr != address(0)) {
814                     return ownership;
815                 }
816             }
817         }
818 
819         revert('ERC721A: unable to determine the owner of token');
820     }
821 
822     /**
823      * @dev See {IERC721-ownerOf}.
824      */
825     function ownerOf(uint256 tokenId) public view override returns (address) {
826         return ownershipOf(tokenId).addr;
827     }
828 
829     /**
830      * @dev See {IERC721Metadata-name}.
831      */
832     function name() public view virtual override returns (string memory) {
833         return _name;
834     }
835 
836     /**
837      * @dev See {IERC721Metadata-symbol}.
838      */
839     function symbol() public view virtual override returns (string memory) {
840         return _symbol;
841     }
842 
843     /**
844      * @dev See {IERC721Metadata-tokenURI}.
845      */
846     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
847         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
848 
849         string memory baseURI = _baseURI();
850         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
851     }
852 
853     /**
854      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
855      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
856      * by default, can be overriden in child contracts.
857      */
858     function _baseURI() internal view virtual returns (string memory) {
859         return '';
860     }
861 
862     /**
863      * @dev See {IERC721-approve}.
864      */
865     function approve(address to, uint256 tokenId) public override {
866         address owner = ERC721A.ownerOf(tokenId);
867         require(to != owner, 'ERC721A: approval to current owner');
868 
869         require(
870             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
871             'ERC721A: approve caller is not owner nor approved for all'
872         );
873 
874         _approve(to, tokenId, owner);
875     }
876 
877     /**
878      * @dev See {IERC721-getApproved}.
879      */
880     function getApproved(uint256 tokenId) public view override returns (address) {
881         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
882 
883         return _tokenApprovals[tokenId];
884     }
885 
886     /**
887      * @dev See {IERC721-setApprovalForAll}.
888      */
889     function setApprovalForAll(address operator, bool approved) public override {
890         require(operator != _msgSender(), 'ERC721A: approve to caller');
891 
892         _operatorApprovals[_msgSender()][operator] = approved;
893         emit ApprovalForAll(_msgSender(), operator, approved);
894     }
895 
896     /**
897      * @dev See {IERC721-isApprovedForAll}.
898      */
899     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
900         return _operatorApprovals[owner][operator];
901     }
902 
903     /**
904      * @dev See {IERC721-transferFrom}.
905      */
906     function transferFrom(
907         address from,
908         address to,
909         uint256 tokenId
910     ) public override {
911         _transfer(from, to, tokenId);
912     }
913 
914     /**
915      * @dev See {IERC721-safeTransferFrom}.
916      */
917     function safeTransferFrom(
918         address from,
919         address to,
920         uint256 tokenId
921     ) public override {
922         safeTransferFrom(from, to, tokenId, '');
923     }
924 
925     /**
926      * @dev See {IERC721-safeTransferFrom}.
927      */
928     function safeTransferFrom(
929         address from,
930         address to,
931         uint256 tokenId,
932         bytes memory _data
933     ) public override {
934         _transfer(from, to, tokenId);
935         require(
936             _checkOnERC721Received(from, to, tokenId, _data),
937             'ERC721A: transfer to non ERC721Receiver implementer'
938         );
939     }
940 
941     /**
942      * @dev Returns whether `tokenId` exists.
943      *
944      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
945      *
946      * Tokens start existing when they are minted (`_mint`),
947      */
948     function _exists(uint256 tokenId) internal view returns (bool) {
949         return tokenId < currentIndex;
950     }
951 
952     function _safeMint(address to, uint256 quantity) internal {
953         _safeMint(to, quantity, '');
954     }
955 
956     /**
957      * @dev Safely mints `quantity` tokens and transfers them to `to`.
958      *
959      * Requirements:
960      *
961      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
962      * - `quantity` must be greater than 0.
963      *
964      * Emits a {Transfer} event.
965      */
966     function _safeMint(
967         address to,
968         uint256 quantity,
969         bytes memory _data
970     ) internal {
971         _mint(to, quantity, _data, true);
972     }
973 
974     /**
975      * @dev Mints `quantity` tokens and transfers them to `to`.
976      *
977      * Requirements:
978      *
979      * - `to` cannot be the zero address.
980      * - `quantity` must be greater than 0.
981      *
982      * Emits a {Transfer} event.
983      */
984     function _mint(
985         address to,
986         uint256 quantity,
987         bytes memory _data,
988         bool safe
989     ) internal {
990         uint256 startTokenId = currentIndex;
991         require(to != address(0), 'ERC721A: mint to the zero address');
992         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
993 
994         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
995 
996         // Overflows are incredibly unrealistic.
997         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
998         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
999         unchecked {
1000             _addressData[to].balance += uint128(quantity);
1001             _addressData[to].numberMinted += uint128(quantity);
1002 
1003             _ownerships[startTokenId].addr = to;
1004             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1005 
1006             uint256 updatedIndex = startTokenId;
1007 
1008             for (uint256 i; i < quantity; i++) {
1009                 emit Transfer(address(0), to, updatedIndex);
1010                 if (safe) {
1011                     require(
1012                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1013                         'ERC721A: transfer to non ERC721Receiver implementer'
1014                     );
1015                 }
1016 
1017                 updatedIndex++;
1018             }
1019 
1020             currentIndex = updatedIndex;
1021         }
1022 
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
1059         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1060         unchecked {
1061             _addressData[from].balance -= 1;
1062             _addressData[to].balance += 1;
1063 
1064             _ownerships[tokenId].addr = to;
1065             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1066 
1067             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1068             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1069             uint256 nextTokenId = tokenId + 1;
1070             if (_ownerships[nextTokenId].addr == address(0)) {
1071                 if (_exists(nextTokenId)) {
1072                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1073                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1074                 }
1075             }
1076         }
1077 
1078         emit Transfer(from, to, tokenId);
1079         _afterTokenTransfers(from, to, tokenId, 1);
1080     }
1081 
1082     /**
1083      * @dev Approve `to` to operate on `tokenId`
1084      *
1085      * Emits a {Approval} event.
1086      */
1087     function _approve(
1088         address to,
1089         uint256 tokenId,
1090         address owner
1091     ) private {
1092         _tokenApprovals[tokenId] = to;
1093         emit Approval(owner, to, tokenId);
1094     }
1095 
1096     /**
1097      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1098      * The call is not executed if the target address is not a contract.
1099      *
1100      * @param from address representing the previous owner of the given token ID
1101      * @param to target address that will receive the tokens
1102      * @param tokenId uint256 ID of the token to be transferred
1103      * @param _data bytes optional data to send along with the call
1104      * @return bool whether the call correctly returned the expected magic value
1105      */
1106     function _checkOnERC721Received(
1107         address from,
1108         address to,
1109         uint256 tokenId,
1110         bytes memory _data
1111     ) private returns (bool) {
1112         if (to.isContract()) {
1113             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1114                 return retval == IERC721Receiver(to).onERC721Received.selector;
1115             } catch (bytes memory reason) {
1116                 if (reason.length == 0) {
1117                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1118                 } else {
1119                     assembly {
1120                         revert(add(32, reason), mload(reason))
1121                     }
1122                 }
1123             }
1124         } else {
1125             return true;
1126         }
1127     }
1128 
1129     /**
1130      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1131      *
1132      * startTokenId - the first token id to be transferred
1133      * quantity - the amount to be transferred
1134      *
1135      * Calling conditions:
1136      *
1137      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1138      * transferred to `to`.
1139      * - When `from` is zero, `tokenId` will be minted for `to`.
1140      */
1141     function _beforeTokenTransfers(
1142         address from,
1143         address to,
1144         uint256 startTokenId,
1145         uint256 quantity
1146     ) internal virtual {}
1147 
1148     /**
1149      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1150      * minting.
1151      *
1152      * startTokenId - the first token id to be transferred
1153      * quantity - the amount to be transferred
1154      *
1155      * Calling conditions:
1156      *
1157      * - when `from` and `to` are both non-zero.
1158      * - `from` and `to` are never both zero.
1159      */
1160     function _afterTokenTransfers(
1161         address from,
1162         address to,
1163         uint256 startTokenId,
1164         uint256 quantity
1165     ) internal virtual {}
1166 }
1167 // File: goblintownai-contract.sol
1168 
1169 
1170 
1171 pragma solidity ^0.8.0;
1172 
1173 /**
1174  * @dev Contract module which allows children to implement an emergency stop
1175  * mechanism that can be triggered by an authorized account.
1176  *
1177  * This module is used through inheritance. It will make available the
1178  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1179  * the functions of your contract. Note that they will not be pausable by
1180  * simply including this module, only once the modifiers are put in place.
1181  */
1182 abstract contract Pausable is Context {
1183     /**
1184      * @dev Emitted when the pause is triggered by `account`.
1185      */
1186     event Paused(address account);
1187 
1188     /**
1189      * @dev Emitted when the pause is lifted by `account`.
1190      */
1191     event Unpaused(address account);
1192 
1193     bool private _paused;
1194 
1195     /**
1196      * @dev Initializes the contract in unpaused state.
1197      */
1198     constructor() {
1199         _paused = false;
1200     }
1201 
1202     /**
1203      * @dev Returns true if the contract is paused, and false otherwise.
1204      */
1205     function paused() public view virtual returns (bool) {
1206         return _paused;
1207     }
1208 
1209     /**
1210      * @dev Modifier to make a function callable only when the contract is not paused.
1211      *
1212      * Requirements:
1213      *
1214      * - The contract must not be paused.
1215      */
1216     modifier whenNotPaused() {
1217         require(!paused(), "Pausable: paused");
1218         _;
1219     }
1220 
1221     /**
1222      * @dev Modifier to make a function callable only when the contract is paused.
1223      *
1224      * Requirements:
1225      *
1226      * - The contract must be paused.
1227      */
1228     modifier whenPaused() {
1229         require(paused(), "Pausable: not paused");
1230         _;
1231     }
1232 
1233     /**
1234      * @dev Triggers stopped state.
1235      *
1236      * Requirements:
1237      *
1238      * - The contract must not be paused.
1239      */
1240     function _pause() internal virtual whenNotPaused {
1241         _paused = true;
1242         emit Paused(_msgSender());
1243     }
1244 
1245     /**
1246      * @dev Returns to normal state.
1247      *
1248      * Requirements:
1249      *
1250      * - The contract must be paused.
1251      */
1252     function _unpause() internal virtual whenPaused {
1253         _paused = false;
1254         emit Unpaused(_msgSender());
1255     }
1256 }
1257 
1258 // Ownable.sol
1259 
1260 pragma solidity ^0.8.0;
1261 
1262 /**
1263  * @dev Contract module which provides a basic access control mechanism, where
1264  * there is an account (an owner) that can be granted exclusive access to
1265  * specific functions.
1266  *
1267  * By default, the owner account will be the one that deploys the contract. This
1268  * can later be changed with {transferOwnership}.
1269  *
1270  * This module is used through inheritance. It will make available the modifier
1271  * `onlyOwner`, which can be applied to your functions to restrict their use to
1272  * the owner.
1273  */
1274 abstract contract Ownable is Context {
1275     address private _owner;
1276 
1277     event OwnershipTransferred(
1278         address indexed previousOwner,
1279         address indexed newOwner
1280     );
1281 
1282     /**
1283      * @dev Initializes the contract setting the deployer as the initial owner.
1284      */
1285     constructor() {
1286         _setOwner(_msgSender());
1287     }
1288 
1289     /**
1290      * @dev Returns the address of the current owner.
1291      */
1292     function owner() public view virtual returns (address) {
1293         return _owner;
1294     }
1295 
1296     /**
1297      * @dev Throws if called by any account other than the owner.
1298      */
1299     modifier onlyOwner() {
1300         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1301         _;
1302     }
1303 
1304     /**
1305      * @dev Leaves the contract without owner. It will not be possible to call
1306      * `onlyOwner` functions anymore. Can only be called by the current owner.
1307      *
1308      * NOTE: Renouncing ownership will leave the contract without an owner,
1309      * thereby removing any functionality that is only available to the owner.
1310      */
1311     function renounceOwnership() public virtual onlyOwner {
1312         _setOwner(address(0));
1313     }
1314 
1315     /**
1316      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1317      * Can only be called by the current owner.
1318      */
1319     function transferOwnership(address newOwner) public virtual onlyOwner {
1320         require(
1321             newOwner != address(0),
1322             "Ownable: new owner is the zero address"
1323         );
1324         _setOwner(newOwner);
1325     }
1326 
1327     function _setOwner(address newOwner) private {
1328         address oldOwner = _owner;
1329         _owner = newOwner;
1330         emit OwnershipTransferred(oldOwner, newOwner);
1331     }
1332 }
1333 
1334 pragma solidity ^0.8.0;
1335 
1336 /**
1337  * @dev Contract module that helps prevent reentrant calls to a function.
1338  *
1339  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1340  * available, which can be applied to functions to make sure there are no nested
1341  * (reentrant) calls to them.
1342  *
1343  * Note that because there is a single `nonReentrant` guard, functions marked as
1344  * `nonReentrant` may not call one another. This can be worked around by making
1345  * those functions `private`, and then adding `external` `nonReentrant` entry
1346  * points to them.
1347  *
1348  * TIP: If you would like to learn more about reentrancy and alternative ways
1349  * to protect against it, check out our blog post
1350  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1351  */
1352 abstract contract ReentrancyGuard {
1353     // Booleans are more expensive than uint256 or any type that takes up a full
1354     // word because each write operation emits an extra SLOAD to first read the
1355     // slot's contents, replace the bits taken up by the boolean, and then write
1356     // back. This is the compiler's defense against contract upgrades and
1357     // pointer aliasing, and it cannot be disabled.
1358 
1359     // The values being non-zero value makes deployment a bit more expensive,
1360     // but in exchange the refund on every call to nonReentrant will be lower in
1361     // amount. Since refunds are capped to a percentage of the total
1362     // transaction's gas, it is best to keep them low in cases like this one, to
1363     // increase the likelihood of the full refund coming into effect.
1364     uint256 private constant _NOT_ENTERED = 1;
1365     uint256 private constant _ENTERED = 2;
1366 
1367     uint256 private _status;
1368 
1369     constructor() {
1370         _status = _NOT_ENTERED;
1371     }
1372 
1373     /**
1374      * @dev Prevents a contract from calling itself, directly or indirectly.
1375      * Calling a `nonReentrant` function from another `nonReentrant`
1376      * function is not supported. It is possible to prevent this from happening
1377      * by making the `nonReentrant` function external, and make it call a
1378      * `private` function that does the actual work.
1379      */
1380     modifier nonReentrant() {
1381         // On the first call to nonReentrant, _notEntered will be true
1382         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1383 
1384         // Any calls to nonReentrant after this point will fail
1385         _status = _ENTERED;
1386 
1387         _;
1388 
1389         // By storing the original value once again, a refund is triggered (see
1390         // https://eips.ethereum.org/EIPS/eip-2200)
1391         _status = _NOT_ENTERED;
1392     }
1393 }
1394 
1395 //newerc.sol
1396 pragma solidity ^0.8.0;
1397 
1398 
1399 contract Dawnscratchers is ERC721A, Ownable, Pausable, ReentrancyGuard {
1400     using Strings for uint256;
1401     string public baseURI;
1402     uint256 public cost = 0.002 ether;
1403     uint256 public maxSupply = 9999;
1404     uint256 public maxFree = 1999;
1405     uint256 public maxperAddressFreeLimit = 2;
1406     uint256 public maxperAddressPublicMint = 9;
1407 
1408     mapping(address => uint256) public addressFreeMintedBalance;
1409 
1410     constructor() ERC721A("Dawnscratchers", "DAWN") {
1411         setBaseURI("");
1412 
1413     }
1414 
1415     function _baseURI() internal view virtual override returns (string memory) {
1416         return baseURI;
1417     }
1418 
1419     function mintFree(uint256 _mintAmount) public payable nonReentrant{
1420 		uint256 s = totalSupply();
1421         uint256 addressFreeMintedCount = addressFreeMintedBalance[msg.sender];
1422         require(addressFreeMintedCount + _mintAmount <= maxperAddressFreeLimit, "Max Dawnscratchers per address exceeded");
1423 		require(_mintAmount > 0, "Cannot mint 0 Dawnscratchers" );
1424 		require(s + _mintAmount <= maxFree, "Cannot exceed Dawnscratchers supply" );
1425 		for (uint256 i = 0; i < _mintAmount; ++i) {
1426             addressFreeMintedBalance[msg.sender]++;
1427 
1428 		}
1429         _safeMint(msg.sender, _mintAmount);
1430 		delete s;
1431         delete addressFreeMintedCount;
1432 	}
1433 
1434 
1435     function mint(uint256 _mintAmount) public payable nonReentrant {
1436         uint256 s = totalSupply();
1437         require(_mintAmount > 0, "Cant mint 0 Dawnscratchers");
1438         require(_mintAmount <= maxperAddressPublicMint, "Cant mint more Dawnscratchers" );
1439         require(s + _mintAmount <= maxSupply, "Cant exceed Dawnscratchers supply");
1440         require(msg.value >= cost * _mintAmount);
1441         _safeMint(msg.sender, _mintAmount);
1442         delete s;
1443     }
1444 
1445     function gift(uint256[] calldata quantity, address[] calldata recipient)
1446         external
1447         onlyOwner
1448     {
1449         require(
1450             quantity.length == recipient.length,
1451             "Provide quantities and recipients"
1452         );
1453         uint256 totalQuantity = 0;
1454         uint256 s = totalSupply();
1455         for (uint256 i = 0; i < quantity.length; ++i) {
1456             totalQuantity += quantity[i];
1457         }
1458         require(s + totalQuantity <= maxSupply, "Too many Dawnscratchers");
1459         delete totalQuantity;
1460         for (uint256 i = 0; i < recipient.length; ++i) {
1461             _safeMint(recipient[i], quantity[i]);
1462         }
1463         delete s;
1464     }
1465 
1466     function tokenURI(uint256 tokenId)
1467         public
1468         view
1469         virtual
1470         override
1471         returns (string memory)
1472     {
1473         require(_exists(tokenId), "ERC721Metadata: Nonexistent token");
1474         string memory currentBaseURI = _baseURI();
1475         return
1476             bytes(currentBaseURI).length > 0
1477                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json"))
1478                 : "";
1479     }
1480 
1481 
1482 
1483     function setCost(uint256 _newCost) public onlyOwner {
1484         cost = _newCost;
1485     }
1486 
1487     function setmaxSupply(uint256 _newMaxSupply) public onlyOwner {
1488         require(_newMaxSupply <= maxSupply, "Cannot increase max supply");
1489         maxSupply = _newMaxSupply;
1490     }
1491      function setmaxFreeSupply(uint256 _newMaxFreeSupply) public onlyOwner {
1492                maxFree = _newMaxFreeSupply;
1493     }
1494 
1495     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1496         baseURI = _newBaseURI;
1497     }
1498 
1499     function setMaxperAddressPublicMint(uint256 _amount) public onlyOwner {
1500         maxperAddressPublicMint = _amount;
1501     }
1502 
1503     function setMaxperAddressFreeMint(uint256 _amount) public onlyOwner{
1504         maxperAddressFreeLimit = _amount;
1505     }
1506     function withdraw() public payable onlyOwner {
1507         (bool success, ) = payable(msg.sender).call{
1508             value: address(this).balance
1509         }("");
1510         require(success);
1511     }
1512 
1513     function withdrawAny(uint256 _amount) public payable onlyOwner {
1514         (bool success, ) = payable(msg.sender).call{value: _amount}("");
1515         require(success);
1516     }
1517 }