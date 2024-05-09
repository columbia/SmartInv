1 // SPDX-License-Identifier: MIT
2 
3 
4                                                                                 
5 /*
6 Nobody has to know
7                     1289 Nft
8                                 free mint
9                                             wen reveal?
10     https://www.tickcounter.com/countdown/3317447/wen-reveal-nobody-has-to-know
11 
12 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,.....,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
13 @@@@@@@@@@@@@@@@@@@@@@@@@@%...........................@@@@@@@@@@@@@@@@@@@@@@@@@@
14 @@@@@@@@@@@@@@@@@@@@@,.....................................#@@@@@@@@@@@@@@@@@@@@
15 @@@@@@@@@@@@@@@@@@.............................................@@@@@@@@@@@@@@@@@
16 @@@@@@@@@@@@@@@........,%%%%%%%%%...............%%%%%%%%%.........@@@@@@@@@@@@@@
17 @@@@@@@@@@@@.......%%%%%%%%%%%%%,...............*%%%%%%%%%%%%%.......@@@@@@@@@@@
18 @@@@@@@@@@......%%%%%%%%................................,%%%%%%%%......@@@@@@@@@
19 @@@@@@@@,....%%%%%%%.........................................%%%%%%(....%@@@@@@@
20 @@@@@@@.....%%%%%,.............................................(%%%%%.....@@@@@@
21 @@@@@@.......%%...................................................%%.......@@@@@
22 @@@@@....................%%%%%/...................#%%%%%....................@@@@
23 @@@@....................%%%%%%%%.................%%%%%%%%....................@@@
24 @@@....................,%%%%%%%%.................%%%%%%%%....................%@@
25 @@@.....................#%%%%%%..................*%%%%%%/.....................@@
26 @@@...........................................................................@@
27 @@@...........................................................................@@
28 @@@...................................********................................@@
29 @@@...................................********................................@@
30 @@@..................................********,................................@@
31 @@@@................................%********................................@@@
32 @@@@@..........................#%%%%********(%%%#...........................@@@@
33 @@@@@@.........................%%%%%********%%%%#..........................@@@@@
34 @@@@@@@............................********#(.............................@@@@@@
35 @@@@@@@@...........................*************....,***,................@@@@@@@
36 @@@@@@@@@@........................*************************............@@@@@@@@@
37 @@@@@@@@@@@@.....................,********%%%%%(**********,..........@@@@@@@@@@@
38 @@@@@@@@@@@@@@...................****************%#******..........@@@@@@@@@@@@@
39 @@@@@@@@@@@@@@@@@................****************(%****,........@@@@@@@@@@@@@@@@
40 @@@@@@@@@@@@@@@@@@@@@...........*************#%%******......@@@@@@@@@@@@@@@@@@@@
41 @@@@@@@@@@@@@@@@@@@@@@@@@,.....,***************#%***,..@@@@@@@@@@@@@@@@@@@@@@@@@
42 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*******(%*******%****@@@@@@@@@@@@@@@@@@@@@@@@@@@@
43 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@********%%%%%%%#***@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
44 
45 */
46 
47 
48 
49 
50 pragma solidity ^0.8.0;
51 
52 /**
53  * @dev Interface of the ERC165 standard, as defined in the
54  * https://eips.ethereum.org/EIPS/eip-165[EIP].
55  *
56  * Implementers can declare support of contract interfaces, which can then be
57  * queried by others ({ERC165Checker}).
58  *
59  * For an implementation, see {ERC165}.
60  */
61 interface IERC165 {
62     /**
63      * @dev Returns true if this contract implements the interface defined by
64      * `interfaceId`. See the corresponding
65      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
66      * to learn more about how these ids are created.
67      *
68      * This function call must use less than 30 000 gas.
69      */
70     function supportsInterface(bytes4 interfaceId) external view returns (bool);
71 }
72 
73 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
74 
75 
76 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
77 
78 pragma solidity ^0.8.0;
79 
80 /**
81  * @title ERC721 token receiver interface
82  * @dev Interface for any contract that wants to support safeTransfers
83  * from ERC721 asset contracts.
84  */
85 interface IERC721Receiver {
86     /**
87      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
88      * by `operator` from `from`, this function is called.
89      *
90      * It must return its Solidity selector to confirm the token transfer.
91      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
92      *
93      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
94      */
95     function onERC721Received(
96         address operator,
97         address from,
98         uint256 tokenId,
99         bytes calldata data
100     ) external returns (bytes4);
101 }
102 
103 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
104 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
105 
106 pragma solidity ^0.8.0;
107 
108 /**
109  * @dev String operations.
110  */
111 library Strings {
112     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
113 
114     /**
115      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
116      */
117     function toString(uint256 value) internal pure returns (string memory) {
118         // Inspired by OraclizeAPI's implementation - MIT licence
119         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
120 
121         if (value == 0) {
122             return "0";
123         }
124         uint256 temp = value;
125         uint256 digits;
126         while (temp != 0) {
127             digits++;
128             temp /= 10;
129         }
130         bytes memory buffer = new bytes(digits);
131         while (value != 0) {
132             digits -= 1;
133             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
134             value /= 10;
135         }
136         return string(buffer);
137     }
138 
139     /**
140      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
141      */
142     function toHexString(uint256 value) internal pure returns (string memory) {
143         if (value == 0) {
144             return "0x00";
145         }
146         uint256 temp = value;
147         uint256 length = 0;
148         while (temp != 0) {
149             length++;
150             temp >>= 8;
151         }
152         return toHexString(value, length);
153     }
154 
155     /**
156      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
157      */
158     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
159         bytes memory buffer = new bytes(2 * length + 2);
160         buffer[0] = "0";
161         buffer[1] = "x";
162         for (uint256 i = 2 * length + 1; i > 1; --i) {
163             buffer[i] = _HEX_SYMBOLS[value & 0xf];
164             value >>= 4;
165         }
166         require(value == 0, "Strings: hex length insufficient");
167         return string(buffer);
168     }
169 }
170 
171 // File: @openzeppelin/contracts/utils/Context.sol
172 
173 
174 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
175 pragma solidity ^0.8.0;
176 
177 
178 /**
179  * @dev Implementation of the {IERC165} interface.
180  *
181  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
182  * for the additional interface id that will be supported. For example:
183  *
184  * ```solidity
185  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
186  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
187  * }
188  * ```
189  *
190  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
191  */
192 abstract contract ERC165 is IERC165 {
193     /**
194      * @dev See {IERC165-supportsInterface}.
195      */
196     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
197         return interfaceId == type(IERC165).interfaceId;
198     }
199 }
200 
201 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
202 
203 
204 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
205 
206 pragma solidity ^0.8.0;
207 
208 
209 /**
210  * @dev Required interface of an ERC721 compliant contract.
211  */
212 interface IERC721 is IERC165 {
213     /**
214      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
215      */
216     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
217 
218     /**
219      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
220      */
221     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
222 
223     /**
224      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
225      */
226     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
227 
228     /**
229      * @dev Returns the number of tokens in ``owner``'s account.
230      */
231     function balanceOf(address owner) external view returns (uint256 balance);
232 
233     /**
234      * @dev Returns the owner of the `tokenId` token.
235      *
236      * Requirements:
237      *
238      * - `tokenId` must exist.
239      */
240     function ownerOf(uint256 tokenId) external view returns (address owner);
241 
242     /**
243      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
244      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
245      *
246      * Requirements:
247      *
248      * - `from` cannot be the zero address.
249      * - `to` cannot be the zero address.
250      * - `tokenId` token must exist and be owned by `from`.
251      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
252      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
253      *
254      * Emits a {Transfer} event.
255      */
256     function safeTransferFrom(
257         address from,
258         address to,
259         uint256 tokenId
260     ) external;
261 
262     /**
263      * @dev Transfers `tokenId` token from `from` to `to`.
264      *
265      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
266      *
267      * Requirements:
268      *
269      * - `from` cannot be the zero address.
270      * - `to` cannot be the zero address.
271      * - `tokenId` token must be owned by `from`.
272      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
273      *
274      * Emits a {Transfer} event.
275      */
276     function transferFrom(
277         address from,
278         address to,
279         uint256 tokenId
280     ) external;
281 
282     /**
283      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
284      * The approval is cleared when the token is transferred.
285      *
286      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
287      *
288      * Requirements:
289      *
290      * - The caller must own the token or be an approved operator.
291      * - `tokenId` must exist.
292      *
293      * Emits an {Approval} event.
294      */
295     function approve(address to, uint256 tokenId) external;
296 
297     /**
298      * @dev Returns the account approved for `tokenId` token.
299      *
300      * Requirements:
301      *
302      * - `tokenId` must exist.
303      */
304     function getApproved(uint256 tokenId) external view returns (address operator);
305 
306     /**
307      * @dev Approve or remove `operator` as an operator for the caller.
308      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
309      *
310      * Requirements:
311      *
312      * - The `operator` cannot be the caller.
313      *
314      * Emits an {ApprovalForAll} event.
315      */
316     function setApprovalForAll(address operator, bool _approved) external;
317 
318     /**
319      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
320      *
321      * See {setApprovalForAll}
322      */
323     function isApprovedForAll(address owner, address operator) external view returns (bool);
324 
325     /**
326      * @dev Safely transfers `tokenId` token from `from` to `to`.
327      *
328      * Requirements:
329      *
330      * - `from` cannot be the zero address.
331      * - `to` cannot be the zero address.
332      * - `tokenId` token must exist and be owned by `from`.
333      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
334      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
335      *
336      * Emits a {Transfer} event.
337      */
338     function safeTransferFrom(
339         address from,
340         address to,
341         uint256 tokenId,
342         bytes calldata data
343     ) external;
344 }
345 
346 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
347 
348 
349 
350 
351 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
352 
353 pragma solidity ^0.8.0;
354 
355 /**
356  * @dev Provides information about the current execution context, including the
357  * sender of the transaction and its data. While these are generally available
358  * via msg.sender and msg.data, they should not be accessed in such a direct
359  * manner, since when dealing with meta-transactions the account sending and
360  * paying for execution may not be the actual sender (as far as an application
361  * is concerned).
362  *
363  * This contract is only required for intermediate, library-like contracts.
364  */
365 abstract contract Context {
366     function _msgSender() internal view virtual returns (address) {
367         return msg.sender;
368     }
369 
370     function _msgData() internal view virtual returns (bytes calldata) {
371         return msg.data;
372     }
373 }
374 
375 // File: @openzeppelin/contracts/access/Ownable.sol
376 
377 
378 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
379 
380 pragma solidity ^0.8.0;
381 
382 
383 /**
384  * @dev Contract module which provides a basic access control mechanism, where
385  * there is an account (an owner) that can be granted exclusive access to
386  * specific functions.
387  *
388  * By default, the owner account will be the one that deploys the contract. This
389  * can later be changed with {transferOwnership}.
390  *
391  * This module is used through inheritance. It will make available the modifier
392  * `onlyOwner`, which can be applied to your functions to restrict their use to
393  * the owner.
394  */
395 abstract contract Ownable is Context {
396     address private _owner;
397 
398     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
399 
400     /**
401      * @dev Initializes the contract setting the deployer as the initial owner.
402      */
403     constructor() {
404         _transferOwnership(_msgSender());
405     }
406 
407     /**
408      * @dev Returns the address of the current owner.
409      */
410     function owner() public view virtual returns (address) {
411         return _owner;
412     }
413 
414     /**
415      * @dev Throws if called by any account other than the owner.
416      */
417     modifier onlyOwner() {
418         require(owner() == _msgSender(), "Ownable: caller is not the owner");
419         _;
420     }
421 
422     /**
423      * @dev Leaves the contract without owner. It will not be possible to call
424      * `onlyOwner` functions anymore. Can only be called by the current owner.
425      *
426      * NOTE: Renouncing ownership will leave the contract without an owner,
427      * thereby removing any functionality that is only available to the owner.
428      */
429     function renounceOwnership() public virtual onlyOwner {
430         _transferOwnership(address(0));
431     }
432 
433     /**
434      * @dev Transfers ownership of the contract to a new account (`newOwner`).
435      * Can only be called by the current owner.
436      */
437     function transferOwnership(address newOwner) public virtual onlyOwner {
438         require(newOwner != address(0), "Ownable: new owner is the zero address");
439         _transferOwnership(newOwner);
440     }
441 
442     /**
443      * @dev Transfers ownership of the contract to a new account (`newOwner`).
444      * Internal function without access restriction.
445      */
446     function _transferOwnership(address newOwner) internal virtual {
447         address oldOwner = _owner;
448         _owner = newOwner;
449         emit OwnershipTransferred(oldOwner, newOwner);
450     }
451 }
452 
453 // File: @openzeppelin/contracts/utils/Address.sol
454 
455 
456 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
457 
458 pragma solidity ^0.8.0;
459 
460 /**
461  * @dev Collection of functions related to the address type
462  */
463 library Address {
464     /**
465      * @dev Returns true if `account` is a contract.
466      *
467      * [IMPORTANT]
468      * ====
469      * It is unsafe to assume that an address for which this function returns
470      * false is an externally-owned account (EOA) and not a contract.
471      *
472      * Among others, `isContract` will return false for the following
473      * types of addresses:
474      *
475      *  - an externally-owned account
476      *  - a contract in construction
477      *  - an address where a contract will be created
478      *  - an address where a contract lived, but was destroyed
479      * ====
480      */
481     function isContract(address account) internal view returns (bool) {
482         // This method relies on extcodesize, which returns 0 for contracts in
483         // construction, since the code is only stored at the end of the
484         // constructor execution.
485 
486         uint256 size;
487         assembly {
488             size := extcodesize(account)
489         }
490         return size > 0;
491     }
492 
493     /**
494      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
495      * `recipient`, forwarding all available gas and reverting on errors.
496      *
497      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
498      * of certain opcodes, possibly making contracts go over the 2300 gas limit
499      * imposed by `transfer`, making them unable to receive funds via
500      * `transfer`. {sendValue} removes this limitation.
501      *
502      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
503      *
504      * IMPORTANT: because control is transferred to `recipient`, care must be
505      * taken to not create reentrancy vulnerabilities. Consider using
506      * {ReentrancyGuard} or the
507      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
508      */
509     function sendValue(address payable recipient, uint256 amount) internal {
510         require(address(this).balance >= amount, "Address: insufficient balance");
511 
512         (bool success, ) = recipient.call{value: amount}("");
513         require(success, "Address: unable to send value, recipient may have reverted");
514     }
515 
516     /**
517      * @dev Performs a Solidity function call using a low level `call`. A
518      * plain `call` is an unsafe replacement for a function call: use this
519      * function instead.
520      *
521      * If `target` reverts with a revert reason, it is bubbled up by this
522      * function (like regular Solidity function calls).
523      *
524      * Returns the raw returned data. To convert to the expected return value,
525      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
526      *
527      * Requirements:
528      *
529      * - `target` must be a contract.
530      * - calling `target` with `data` must not revert.
531      *
532      * _Available since v3.1._
533      */
534     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
535         return functionCall(target, data, "Address: low-level call failed");
536     }
537 
538     /**
539      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
540      * `errorMessage` as a fallback revert reason when `target` reverts.
541      *
542      * _Available since v3.1._
543      */
544     function functionCall(
545         address target,
546         bytes memory data,
547         string memory errorMessage
548     ) internal returns (bytes memory) {
549         return functionCallWithValue(target, data, 0, errorMessage);
550     }
551 
552     /**
553      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
554      * but also transferring `value` wei to `target`.
555      *
556      * Requirements:
557      *
558      * - the calling contract must have an ETH balance of at least `value`.
559      * - the called Solidity function must be `payable`.
560      *
561      * _Available since v3.1._
562      */
563     function functionCallWithValue(
564         address target,
565         bytes memory data,
566         uint256 value
567     ) internal returns (bytes memory) {
568         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
569     }
570 
571     /**
572      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
573      * with `errorMessage` as a fallback revert reason when `target` reverts.
574      *
575      * _Available since v3.1._
576      */
577     function functionCallWithValue(
578         address target,
579         bytes memory data,
580         uint256 value,
581         string memory errorMessage
582     ) internal returns (bytes memory) {
583         require(address(this).balance >= value, "Address: insufficient balance for call");
584         require(isContract(target), "Address: call to non-contract");
585 
586         (bool success, bytes memory returndata) = target.call{value: value}(data);
587         return verifyCallResult(success, returndata, errorMessage);
588     }
589 
590     /**
591      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
592      * but performing a static call.
593      *
594      * _Available since v3.3._
595      */
596     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
597         return functionStaticCall(target, data, "Address: low-level static call failed");
598     }
599 
600     /**
601      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
602      * but performing a static call.
603      *
604      * _Available since v3.3._
605      */
606     function functionStaticCall(
607         address target,
608         bytes memory data,
609         string memory errorMessage
610     ) internal view returns (bytes memory) {
611         require(isContract(target), "Address: static call to non-contract");
612 
613         (bool success, bytes memory returndata) = target.staticcall(data);
614         return verifyCallResult(success, returndata, errorMessage);
615     }
616 
617     /**
618      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
619      * but performing a delegate call.
620      *
621      * _Available since v3.4._
622      */
623     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
624         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
625     }
626 
627     /**
628      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
629      * but performing a delegate call.
630      *
631      * _Available since v3.4._
632      */
633     function functionDelegateCall(
634         address target,
635         bytes memory data,
636         string memory errorMessage
637     ) internal returns (bytes memory) {
638         require(isContract(target), "Address: delegate call to non-contract");
639 
640         (bool success, bytes memory returndata) = target.delegatecall(data);
641         return verifyCallResult(success, returndata, errorMessage);
642     }
643 
644     /**
645      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
646      * revert reason using the provided one.
647      *
648      * _Available since v4.3._
649      */
650     function verifyCallResult(
651         bool success,
652         bytes memory returndata,
653         string memory errorMessage
654     ) internal pure returns (bytes memory) {
655         if (success) {
656             return returndata;
657         } else {
658             // Look for revert reason and bubble it up if present
659             if (returndata.length > 0) {
660                 // The easiest way to bubble the revert reason is using memory via assembly
661 
662                 assembly {
663                     let returndata_size := mload(returndata)
664                     revert(add(32, returndata), returndata_size)
665                 }
666             } else {
667                 revert(errorMessage);
668             }
669         }
670     }
671 }
672 
673 
674 
675 pragma solidity ^0.8.0;
676 
677 
678 /**
679  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
680  * @dev See https://eips.ethereum.org/EIPS/eip-721
681  */
682 interface IERC721Enumerable is IERC721 {
683     /**
684      * @dev Returns the total amount of tokens stored by the contract.
685      */
686     function totalSupply() external view returns (uint256);
687 
688     /**
689      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
690      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
691      */
692     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
693 
694     /**
695      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
696      * Use along with {totalSupply} to enumerate all tokens.
697      */
698     function tokenByIndex(uint256 index) external view returns (uint256);
699 }
700 
701 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
702 
703 
704 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
705 
706 pragma solidity ^0.8.0;
707 
708 
709 /**
710  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
711  * @dev See https://eips.ethereum.org/EIPS/eip-721
712  */
713 interface IERC721Metadata is IERC721 {
714     /**
715      * @dev Returns the token collection name.
716      */
717     function name() external view returns (string memory);
718 
719     /**
720      * @dev Returns the token collection symbol.
721      */
722     function symbol() external view returns (string memory);
723 
724     /**
725      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
726      */
727     function tokenURI(uint256 tokenId) external view returns (string memory);
728 }
729 
730 
731 pragma solidity ^0.8.0;
732 
733 
734 /**
735  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
736  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
737  *
738  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
739  *
740  * Does not support burning tokens to address(0).
741  *
742  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
743  */
744 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
745     using Address for address;
746     using Strings for uint256;
747 
748     struct TokenOwnership {
749         address addr;
750         uint64 startTimestamp;
751     }
752 
753     struct AddressData {
754         uint128 balance;
755         uint128 numberMinted;
756     }
757 
758     uint256 internal currentIndex = 0;
759 
760     uint256 internal immutable maxBatchSize;
761 
762     // Token name
763     string private _name;
764 
765     // Token symbol
766     string private _symbol;
767 
768     // Mapping from token ID to ownership details
769     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
770     mapping(uint256 => TokenOwnership) internal _ownerships;
771 
772     // Mapping owner address to address data
773     mapping(address => AddressData) private _addressData;
774 
775     // Mapping from token ID to approved address
776     mapping(uint256 => address) private _tokenApprovals;
777 
778     // Mapping from owner to operator approvals
779     mapping(address => mapping(address => bool)) private _operatorApprovals;
780 
781     /**
782      * @dev
783      * `maxBatchSize` refers to how much a minter can mint at a time.
784      */
785     constructor(
786         string memory name_,
787         string memory symbol_,
788         uint256 maxBatchSize_
789     ) {
790         require(maxBatchSize_ > 0, 'ERC721A: max batch size must be nonzero');
791         _name = name_;
792         _symbol = symbol_;
793         maxBatchSize = maxBatchSize_;
794     }
795 
796     /**
797      * @dev See {IERC721Enumerable-totalSupply}.
798      */
799     function totalSupply() public view override returns (uint256) {
800         return currentIndex;
801     }
802 
803     /**
804      * @dev See {IERC721Enumerable-tokenByIndex}.
805      */
806     function tokenByIndex(uint256 index) public view override returns (uint256) {
807         require(index < totalSupply(), 'ERC721A: global index out of bounds');
808         return index;
809     }
810 
811     /**
812      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
813      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
814      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
815      */
816     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
817         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
818         uint256 numMintedSoFar = totalSupply();
819         uint256 tokenIdsIdx = 0;
820         address currOwnershipAddr = address(0);
821         for (uint256 i = 0; i < numMintedSoFar; i++) {
822             TokenOwnership memory ownership = _ownerships[i];
823             if (ownership.addr != address(0)) {
824                 currOwnershipAddr = ownership.addr;
825             }
826             if (currOwnershipAddr == owner) {
827                 if (tokenIdsIdx == index) {
828                     return i;
829                 }
830                 tokenIdsIdx++;
831             }
832         }
833         revert('ERC721A: unable to get token of owner by index');
834     }
835 
836     /**
837      * @dev See {IERC165-supportsInterface}.
838      */
839     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
840         return
841             interfaceId == type(IERC721).interfaceId ||
842             interfaceId == type(IERC721Metadata).interfaceId ||
843             interfaceId == type(IERC721Enumerable).interfaceId ||
844             super.supportsInterface(interfaceId);
845     }
846 
847     /**
848      * @dev See {IERC721-balanceOf}.
849      */
850     function balanceOf(address owner) public view override returns (uint256) {
851         require(owner != address(0), 'ERC721A: balance query for the zero address');
852         return uint256(_addressData[owner].balance);
853     }
854 
855     function _numberMinted(address owner) internal view returns (uint256) {
856         require(owner != address(0), 'ERC721A: number minted query for the zero address');
857         return uint256(_addressData[owner].numberMinted);
858     }
859 
860     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
861         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
862 
863         uint256 lowestTokenToCheck;
864         if (tokenId >= maxBatchSize) {
865             lowestTokenToCheck = tokenId - maxBatchSize + 1;
866         }
867 
868         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
869             TokenOwnership memory ownership = _ownerships[curr];
870             if (ownership.addr != address(0)) {
871                 return ownership;
872             }
873         }
874 
875         revert('ERC721A: unable to determine the owner of token');
876     }
877 
878     /**
879      * @dev See {IERC721-ownerOf}.
880      */
881     function ownerOf(uint256 tokenId) public view override returns (address) {
882         return ownershipOf(tokenId).addr;
883     }
884 
885     /**
886      * @dev See {IERC721Metadata-name}.
887      */
888     function name() public view virtual override returns (string memory) {
889         return _name;
890     }
891 
892     /**
893      * @dev See {IERC721Metadata-symbol}.
894      */
895     function symbol() public view virtual override returns (string memory) {
896         return _symbol;
897     }
898 
899     /**
900      * @dev See {IERC721Metadata-tokenURI}.
901      */
902     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
903         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
904 
905         string memory baseURI = _baseURI();
906         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
907     }
908 
909     /**
910      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
911      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
912      * by default, can be overriden in child contracts.
913      */
914     function _baseURI() internal view virtual returns (string memory) {
915         return '';
916     }
917 
918     /**
919      * @dev See {IERC721-approve}.
920      */
921     function approve(address to, uint256 tokenId) public override {
922         address owner = ERC721A.ownerOf(tokenId);
923         require(to != owner, 'ERC721A: approval to current owner');
924 
925         require(
926             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
927             'ERC721A: approve caller is not owner nor approved for all'
928         );
929 
930         _approve(to, tokenId, owner);
931     }
932 
933     /**
934      * @dev See {IERC721-getApproved}.
935      */
936     function getApproved(uint256 tokenId) public view override returns (address) {
937         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
938 
939         return _tokenApprovals[tokenId];
940     }
941 
942     /**
943      * @dev See {IERC721-setApprovalForAll}.
944      */
945     function setApprovalForAll(address operator, bool approved) public override {
946         require(operator != _msgSender(), 'ERC721A: approve to caller');
947 
948         _operatorApprovals[_msgSender()][operator] = approved;
949         emit ApprovalForAll(_msgSender(), operator, approved);
950     }
951 
952     /**
953      * @dev See {IERC721-isApprovedForAll}.
954      */
955     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
956         return _operatorApprovals[owner][operator];
957     }
958 
959     /**
960      * @dev See {IERC721-transferFrom}.
961      */
962     function transferFrom(
963         address from,
964         address to,
965         uint256 tokenId
966     ) public override {
967         _transfer(from, to, tokenId);
968     }
969 
970     /**
971      * @dev See {IERC721-safeTransferFrom}.
972      */
973     function safeTransferFrom(
974         address from,
975         address to,
976         uint256 tokenId
977     ) public override {
978         safeTransferFrom(from, to, tokenId, '');
979     }
980 
981     /**
982      * @dev See {IERC721-safeTransferFrom}.
983      */
984     function safeTransferFrom(
985         address from,
986         address to,
987         uint256 tokenId,
988         bytes memory _data
989     ) public override {
990         _transfer(from, to, tokenId);
991         require(
992             _checkOnERC721Received(from, to, tokenId, _data),
993             'ERC721A: transfer to non ERC721Receiver implementer'
994         );
995     }
996 
997     /**
998      * @dev Returns whether `tokenId` exists.
999      *
1000      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1001      *
1002      * Tokens start existing when they are minted (`_mint`),
1003      */
1004     function _exists(uint256 tokenId) internal view returns (bool) {
1005         return tokenId < currentIndex;
1006     }
1007 
1008     function _safeMint(address to, uint256 quantity) internal {
1009         _safeMint(to, quantity, '');
1010     }
1011 
1012     /**
1013      * @dev Mints `quantity` tokens and transfers them to `to`.
1014      *
1015      * Requirements:
1016      *
1017      * - `to` cannot be the zero address.
1018      * - `quantity` cannot be larger than the max batch size.
1019      *
1020      * Emits a {Transfer} event.
1021      */
1022     function _safeMint(
1023         address to,
1024         uint256 quantity,
1025         bytes memory _data
1026     ) internal {
1027         uint256 startTokenId = currentIndex;
1028         require(to != address(0), 'ERC721A: mint to the zero address');
1029         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1030         require(!_exists(startTokenId), 'ERC721A: token already minted');
1031         require(quantity <= maxBatchSize, 'ERC721A: quantity to mint too high');
1032         require(quantity > 0, 'ERC721A: quantity must be greater 0');
1033 
1034         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1035 
1036         AddressData memory addressData = _addressData[to];
1037         _addressData[to] = AddressData(
1038             addressData.balance + uint128(quantity),
1039             addressData.numberMinted + uint128(quantity)
1040         );
1041         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1042 
1043         uint256 updatedIndex = startTokenId;
1044 
1045         for (uint256 i = 0; i < quantity; i++) {
1046             emit Transfer(address(0), to, updatedIndex);
1047             require(
1048                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1049                 'ERC721A: transfer to non ERC721Receiver implementer'
1050             );
1051             updatedIndex++;
1052         }
1053 
1054         currentIndex = updatedIndex;
1055         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1056     }
1057 
1058     /**
1059      * @dev Transfers `tokenId` from `from` to `to`.
1060      *
1061      * Requirements:
1062      *
1063      * - `to` cannot be the zero address.
1064      * - `tokenId` token must be owned by `from`.
1065      *
1066      * Emits a {Transfer} event.
1067      */
1068     function _transfer(
1069         address from,
1070         address to,
1071         uint256 tokenId
1072     ) private {
1073         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1074 
1075         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1076             getApproved(tokenId) == _msgSender() ||
1077             isApprovedForAll(prevOwnership.addr, _msgSender()));
1078 
1079         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1080 
1081         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1082         require(to != address(0), 'ERC721A: transfer to the zero address');
1083 
1084         _beforeTokenTransfers(from, to, tokenId, 1);
1085 
1086         // Clear approvals from the previous owner
1087         _approve(address(0), tokenId, prevOwnership.addr);
1088 
1089         // Underflow of the sender's balance is impossible because we check for
1090         // ownership above and the recipient's balance can't realistically overflow.
1091         unchecked {
1092             _addressData[from].balance -= 1;
1093             _addressData[to].balance += 1;
1094         }
1095 
1096         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1097 
1098         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1099         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1100         uint256 nextTokenId = tokenId + 1;
1101         if (_ownerships[nextTokenId].addr == address(0)) {
1102             if (_exists(nextTokenId)) {
1103                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1104             }
1105         }
1106 
1107         emit Transfer(from, to, tokenId);
1108         _afterTokenTransfers(from, to, tokenId, 1);
1109     }
1110 
1111     /**
1112      * @dev Approve `to` to operate on `tokenId`
1113      *
1114      * Emits a {Approval} event.
1115      */
1116     function _approve(
1117         address to,
1118         uint256 tokenId,
1119         address owner
1120     ) private {
1121         _tokenApprovals[tokenId] = to;
1122         emit Approval(owner, to, tokenId);
1123     }
1124 
1125     /**
1126      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1127      * The call is not executed if the target address is not a contract.
1128      *
1129      * @param from address representing the previous owner of the given token ID
1130      * @param to target address that will receive the tokens
1131      * @param tokenId uint256 ID of the token to be transferred
1132      * @param _data bytes optional data to send along with the call
1133      * @return bool whether the call correctly returned the expected magic value
1134      */
1135     function _checkOnERC721Received(
1136         address from,
1137         address to,
1138         uint256 tokenId,
1139         bytes memory _data
1140     ) private returns (bool) {
1141         if (to.isContract()) {
1142             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1143                 return retval == IERC721Receiver(to).onERC721Received.selector;
1144             } catch (bytes memory reason) {
1145                 if (reason.length == 0) {
1146                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1147                 } else {
1148                     assembly {
1149                         revert(add(32, reason), mload(reason))
1150                     }
1151                 }
1152             }
1153         } else {
1154             return true;
1155         }
1156     }
1157 
1158     /**
1159      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1160      *
1161      * startTokenId - the first token id to be transferred
1162      * quantity - the amount to be transferred
1163      *
1164      * Calling conditions:
1165      *
1166      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1167      * transferred to `to`.
1168      * - When `from` is zero, `tokenId` will be minted for `to`.
1169      */
1170     function _beforeTokenTransfers(
1171         address from,
1172         address to,
1173         uint256 startTokenId,
1174         uint256 quantity
1175     ) internal virtual {}
1176 
1177     /**
1178      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1179      * minting.
1180      *
1181      * startTokenId - the first token id to be transferred
1182      * quantity - the amount to be transferred
1183      *
1184      * Calling conditions:
1185      *
1186      * - when `from` and `to` are both non-zero.
1187      * - `from` and `to` are never both zero.
1188      */
1189     function _afterTokenTransfers(
1190         address from,
1191         address to,
1192         uint256 startTokenId,
1193         uint256 quantity
1194     ) internal virtual {}
1195 }
1196 
1197 /*
1198 Nobody has to know
1199                     1289 Nft
1200                                 free mint
1201                                             wen reveal?
1202     https://www.tickcounter.com/countdown/3317447/wen-reveal-nobody-has-to-know
1203 
1204 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,.....,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1205 @@@@@@@@@@@@@@@@@@@@@@@@@@%...........................@@@@@@@@@@@@@@@@@@@@@@@@@@
1206 @@@@@@@@@@@@@@@@@@@@@,.....................................#@@@@@@@@@@@@@@@@@@@@
1207 @@@@@@@@@@@@@@@@@@.............................................@@@@@@@@@@@@@@@@@
1208 @@@@@@@@@@@@@@@........,%%%%%%%%%...............%%%%%%%%%.........@@@@@@@@@@@@@@
1209 @@@@@@@@@@@@.......%%%%%%%%%%%%%,...............*%%%%%%%%%%%%%.......@@@@@@@@@@@
1210 @@@@@@@@@@......%%%%%%%%................................,%%%%%%%%......@@@@@@@@@
1211 @@@@@@@@,....%%%%%%%.........................................%%%%%%(....%@@@@@@@
1212 @@@@@@@.....%%%%%,.............................................(%%%%%.....@@@@@@
1213 @@@@@@.......%%...................................................%%.......@@@@@
1214 @@@@@....................%%%%%/...................#%%%%%....................@@@@
1215 @@@@....................%%%%%%%%.................%%%%%%%%....................@@@
1216 @@@....................,%%%%%%%%.................%%%%%%%%....................%@@
1217 @@@.....................#%%%%%%..................*%%%%%%/.....................@@
1218 @@@...........................................................................@@
1219 @@@...........................................................................@@
1220 @@@...................................********................................@@
1221 @@@...................................********................................@@
1222 @@@..................................********,................................@@
1223 @@@@................................%********................................@@@
1224 @@@@@..........................#%%%%********(%%%#...........................@@@@
1225 @@@@@@.........................%%%%%********%%%%#..........................@@@@@
1226 @@@@@@@............................********#(.............................@@@@@@
1227 @@@@@@@@...........................*************....,***,................@@@@@@@
1228 @@@@@@@@@@........................*************************............@@@@@@@@@
1229 @@@@@@@@@@@@.....................,********%%%%%(**********,..........@@@@@@@@@@@
1230 @@@@@@@@@@@@@@...................****************%#******..........@@@@@@@@@@@@@
1231 @@@@@@@@@@@@@@@@@................****************(%****,........@@@@@@@@@@@@@@@@
1232 @@@@@@@@@@@@@@@@@@@@@...........*************#%%******......@@@@@@@@@@@@@@@@@@@@
1233 @@@@@@@@@@@@@@@@@@@@@@@@@,.....,***************#%***,..@@@@@@@@@@@@@@@@@@@@@@@@@
1234 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*******(%*******%****@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1235 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@********%%%%%%%#***@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1236 
1237 */
1238 
1239 
1240 pragma solidity ^0.8.0;
1241 
1242 contract NobodyHasToKnow is ERC721A, Ownable {
1243   using Strings for uint256;
1244 
1245   string private uriPrefix = "";
1246   string private uriSuffix = ".json";
1247   string public hiddenMetadataUri;
1248   
1249   uint256 public price = 0 ether; 
1250   uint256 public maxSupply = 1289; 
1251   uint256 public maxMintAmountPerTx = 3; 
1252   uint256 public nftPerAddressLimit = 3; 
1253   
1254   bool public paused = false;
1255   bool public revealed = false;
1256   mapping(address => uint256) public addressMintedBalance;
1257 
1258 
1259   constructor() ERC721A("nobodyhastoknow", "$$$$H", maxMintAmountPerTx) {
1260     setHiddenMetadataUri("ipfs://QmQGyVacehfdeyTieLaJdgaceX4TwDr8ZMuuriFKE5Mzt1");
1261   }
1262 
1263   modifier mintCompliance(uint256 _mintAmount) {
1264       uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1265     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1266     require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1267     require(currentIndex + _mintAmount <= maxSupply, "Max supply exceeded!");
1268     _;
1269   }
1270 
1271   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount)
1272    {
1273     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1274     require(!paused, "The contract is paused!");
1275     require(msg.value >= price * _mintAmount, "Insufficient funds!");
1276      require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1277     
1278     
1279     _safeMint(msg.sender, _mintAmount);
1280   }
1281 
1282   
1283 
1284   
1285 
1286   function Airdrop(address _to, uint256 _mintAmount) public mintCompliance(_mintAmount) onlyOwner {
1287     _safeMint(_to, _mintAmount);
1288   }
1289 
1290  
1291   function walletOfOwner(address _owner)
1292     public
1293     view
1294     returns (uint256[] memory)
1295   {
1296     uint256 ownerTokenCount = balanceOf(_owner);
1297     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1298     uint256 currentTokenId = 0;
1299     uint256 ownedTokenIndex = 0;
1300 
1301     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1302       address currentTokenOwner = ownerOf(currentTokenId);
1303 
1304       if (currentTokenOwner == _owner) {
1305         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1306 
1307         ownedTokenIndex++;
1308       }
1309 
1310       currentTokenId++;
1311     }
1312 
1313     return ownedTokenIds;
1314   }
1315 
1316   function tokenURI(uint256 _tokenId)
1317     public
1318     view
1319     virtual
1320     override
1321     returns (string memory)
1322   {
1323     require(
1324       _exists(_tokenId),
1325       "ERC721Metadata: URI query for nonexistent token"
1326     );
1327 
1328     if (revealed == false) {
1329       return hiddenMetadataUri;
1330     }
1331 
1332     string memory currentBaseURI = _baseURI();
1333     return bytes(currentBaseURI).length > 0
1334         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1335         : "";
1336   }
1337 
1338   function setRevealed(bool _state) public onlyOwner {
1339     revealed = _state;
1340   
1341   }
1342 
1343   function setPrice(uint256 _price) public onlyOwner {
1344     price = _price;
1345 
1346   }
1347  
1348   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1349     hiddenMetadataUri = _hiddenMetadataUri;
1350   }
1351 
1352   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1353     uriPrefix = _uriPrefix;
1354   }
1355 
1356   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1357     uriSuffix = _uriSuffix;
1358   }
1359 
1360   function setPaused(bool _state) public onlyOwner {
1361     paused = _state;
1362   }
1363 
1364   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1365       _safeMint(_receiver, _mintAmount);
1366   }
1367 
1368   function _baseURI() internal view virtual override returns (string memory) {
1369     return uriPrefix;
1370     
1371   }
1372 
1373     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1374     maxMintAmountPerTx = _maxMintAmountPerTx;
1375 
1376   }
1377 
1378     function setNftPerAddressLimit(uint256 _nftPerAddressLimit) public onlyOwner {
1379     nftPerAddressLimit = _nftPerAddressLimit;
1380 
1381   }
1382 
1383     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1384     maxSupply = _maxSupply;
1385 
1386   }
1387 
1388   function withdraw() public onlyOwner {
1389     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1390     require(os);
1391     
1392   }
1393   
1394 }