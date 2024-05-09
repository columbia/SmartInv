1 // SPDX-License-Identifier: GPL-3.0
2 
3 /**
4 
5 My name is Kendrick, a messenger of King Eero.
6 
7 Allow me to take you back in time. Long before the trove was hidden.
8 
9 King Eero left me an urgent message to pass along.
10 Pray thee take the time to read as we need your help saving the Realm.
11 
12 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
13 
14 Scavenger,
15 
16 Our climb to the throne will be arduous. We will not claim by blood, but by duty to the Realm.
17 
18 I'm looking for 9 Knights to bear our swords. The swords are made from the 9 precious gems.
19 The Topaz Sword, Ruby Sword, Sapphire Sword, Emerald Sword, 
20 Opal Sword, Zircon Sword, Onyx Sword, Jadeite Sword, and the Amber Sword.
21 
22 All assembled with an Onyx hilt.
23 
24 We mustn't forget our 1 Queen. She is a key to the throne.
25 
26 Each checkpoint along the way will be more daring than the last, 
27 but have faith we can claim the throne before the Whales.
28 
29 Tread carefully scavenger, you will soon realize things may not always appear as they seem.
30 
31 Unwaveringly,
32 Eero
33 
34 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
35 
36 //                                  ////                                   //
37 ///                                //////                                 ///
38 ////                              ////////                               ////
39 /////                            //////////                             /////
40 //////                          ////////////                           //////
41 ///////                        //////////////                         ///////
42 ////////                      ////////////////                       ////////
43 /////////                    //////////////////                     /////////
44 //////////                  ////////////////////                   //////////                                                                   
45 ///////////                //////////////////////                 ///////////                                                                    
46 ////////////              ////////////////////////               ////////////                                                                   
47 /////////////            //////////////////////////             /////////////                                                                     
48 //////////////          ////////////////////////////           //////////////                                                          
49 /////////////////////////////////////////////////////////////////////////////
50 /////////////////////////////////////////////////////////////////////////////
51 /////////////////////////////////////////////////////////////////////////////
52 /////////////////////////////////////////////////////////////////////////////
53 /////////////////////////////////////////////////////////////////////////////
54 /////////////////////////////////////////////////////////////////////////////
55 /////////////////////////////////////////////////////////////////////////////
56 
57  */
58 
59 // File: @openzeppelin/contracts/utils/Strings.sol
60 
61 
62 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
63 
64 pragma solidity ^0.8.0;
65 
66 /**
67  * @dev String operations.
68  */
69 library Strings {
70     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
71 
72     /**
73      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
74      */
75     function toString(uint256 value) internal pure returns (string memory) {
76         // Inspired by OraclizeAPI's implementation - MIT licence
77         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
78 
79         if (value == 0) {
80             return "0";
81         }
82         uint256 temp = value;
83         uint256 digits;
84         while (temp != 0) {
85             digits++;
86             temp /= 10;
87         }
88         bytes memory buffer = new bytes(digits);
89         while (value != 0) {
90             digits -= 1;
91             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
92             value /= 10;
93         }
94         return string(buffer);
95     }
96 
97     /**
98      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
99      */
100     function toHexString(uint256 value) internal pure returns (string memory) {
101         if (value == 0) {
102             return "0x00";
103         }
104         uint256 temp = value;
105         uint256 length = 0;
106         while (temp != 0) {
107             length++;
108             temp >>= 8;
109         }
110         return toHexString(value, length);
111     }
112 
113     /**
114      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
115      */
116     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
117         bytes memory buffer = new bytes(2 * length + 2);
118         buffer[0] = "0";
119         buffer[1] = "x";
120         for (uint256 i = 2 * length + 1; i > 1; --i) {
121             buffer[i] = _HEX_SYMBOLS[value & 0xf];
122             value >>= 4;
123         }
124         require(value == 0, "Strings: hex length insufficient");
125         return string(buffer);
126     }
127 }
128 
129 // File: @openzeppelin/contracts/utils/Context.sol
130 
131 
132 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
133 
134 pragma solidity ^0.8.0;
135 
136 /**
137  * @dev Provides information about the current execution context, including the
138  * sender of the transaction and its data. While these are generally available
139  * via msg.sender and msg.data, they should not be accessed in such a direct
140  * manner, since when dealing with meta-transactions the account sending and
141  * paying for execution may not be the actual sender (as far as an application
142  * is concerned).
143  *
144  * This contract is only required for intermediate, library-like contracts.
145  */
146 abstract contract Context {
147     function _msgSender() internal view virtual returns (address) {
148         return msg.sender;
149     }
150 
151     function _msgData() internal view virtual returns (bytes calldata) {
152         return msg.data;
153     }
154 }
155 
156 // File: @openzeppelin/contracts/access/Ownable.sol
157 
158 
159 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
160 
161 pragma solidity ^0.8.0;
162 
163 
164 /**
165  * @dev Contract module which provides a basic access control mechanism, where
166  * there is an account (an owner) that can be granted exclusive access to
167  * specific functions.
168  *
169  * By default, the owner account will be the one that deploys the contract. This
170  * can later be changed with {transferOwnership}.
171  *
172  * This module is used through inheritance. It will make available the modifier
173  * `onlyOwner`, which can be applied to your functions to restrict their use to
174  * the owner.
175  */
176 abstract contract Ownable is Context {
177     address private _owner;
178 
179     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
180 
181     /**
182      * @dev Initializes the contract setting the deployer as the initial owner.
183      */
184     constructor() {
185         _transferOwnership(_msgSender());
186     }
187 
188     /**
189      * @dev Returns the address of the current owner.
190      */
191     function owner() public view virtual returns (address) {
192         return _owner;
193     }
194 
195     /**
196      * @dev Throws if called by any account other than the owner.
197      */
198     modifier onlyOwner() {
199         require(owner() == _msgSender(), "Ownable: caller is not the owner");
200         _;
201     }
202 
203     /**
204      * @dev Leaves the contract without owner. It will not be possible to call
205      * `onlyOwner` functions anymore. Can only be called by the current owner.
206      *
207      * NOTE: Renouncing ownership will leave the contract without an owner,
208      * thereby removing any functionality that is only available to the owner.
209      */
210     function renounceOwnership() public virtual onlyOwner {
211         _transferOwnership(address(0));
212     }
213 
214     /**
215      * @dev Transfers ownership of the contract to a new account (`newOwner`).
216      * Can only be called by the current owner.
217      */
218     function transferOwnership(address newOwner) public virtual onlyOwner {
219         require(newOwner != address(0), "Ownable: new owner is the zero address");
220         _transferOwnership(newOwner);
221     }
222 
223     /**
224      * @dev Transfers ownership of the contract to a new account (`newOwner`).
225      * Internal function without access restriction.
226      */
227     function _transferOwnership(address newOwner) internal virtual {
228         address oldOwner = _owner;
229         _owner = newOwner;
230         emit OwnershipTransferred(oldOwner, newOwner);
231     }
232 }
233 
234 // File: @openzeppelin/contracts/utils/Address.sol
235 
236 
237 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
238 
239 pragma solidity ^0.8.1;
240 
241 /**
242  * @dev Collection of functions related to the address type
243  */
244 library Address {
245     /**
246      * @dev Returns true if `account` is a contract.
247      *
248      * [IMPORTANT]
249      * ====
250      * It is unsafe to assume that an address for which this function returns
251      * false is an externally-owned account (EOA) and not a contract.
252      *
253      * Among others, `isContract` will return false for the following
254      * types of addresses:
255      *
256      *  - an externally-owned account
257      *  - a contract in construction
258      *  - an address where a contract will be created
259      *  - an address where a contract lived, but was destroyed
260      * ====
261      *
262      * [IMPORTANT]
263      * ====
264      * You shouldn't rely on `isContract` to protect against flash loan attacks!
265      *
266      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
267      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
268      * constructor.
269      * ====
270      */
271     function isContract(address account) internal view returns (bool) {
272         // This method relies on extcodesize/address.code.length, which returns 0
273         // for contracts in construction, since the code is only stored at the end
274         // of the constructor execution.
275 
276         return account.code.length > 0;
277     }
278 
279     /**
280      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
281      * `recipient`, forwarding all available gas and reverting on errors.
282      *
283      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
284      * of certain opcodes, possibly making contracts go over the 2300 gas limit
285      * imposed by `transfer`, making them unable to receive funds via
286      * `transfer`. {sendValue} removes this limitation.
287      *
288      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
289      *
290      * IMPORTANT: because control is transferred to `recipient`, care must be
291      * taken to not create reentrancy vulnerabilities. Consider using
292      * {ReentrancyGuard} or the
293      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
294      */
295     function sendValue(address payable recipient, uint256 amount) internal {
296         require(address(this).balance >= amount, "Address: insufficient balance");
297 
298         (bool success, ) = recipient.call{value: amount}("");
299         require(success, "Address: unable to send value, recipient may have reverted");
300     }
301 
302     /**
303      * @dev Performs a Solidity function call using a low level `call`. A
304      * plain `call` is an unsafe replacement for a function call: use this
305      * function instead.
306      *
307      * If `target` reverts with a revert reason, it is bubbled up by this
308      * function (like regular Solidity function calls).
309      *
310      * Returns the raw returned data. To convert to the expected return value,
311      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
312      *
313      * Requirements:
314      *
315      * - `target` must be a contract.
316      * - calling `target` with `data` must not revert.
317      *
318      * _Available since v3.1._
319      */
320     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
321         return functionCall(target, data, "Address: low-level call failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
326      * `errorMessage` as a fallback revert reason when `target` reverts.
327      *
328      * _Available since v3.1._
329      */
330     function functionCall(
331         address target,
332         bytes memory data,
333         string memory errorMessage
334     ) internal returns (bytes memory) {
335         return functionCallWithValue(target, data, 0, errorMessage);
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
340      * but also transferring `value` wei to `target`.
341      *
342      * Requirements:
343      *
344      * - the calling contract must have an ETH balance of at least `value`.
345      * - the called Solidity function must be `payable`.
346      *
347      * _Available since v3.1._
348      */
349     function functionCallWithValue(
350         address target,
351         bytes memory data,
352         uint256 value
353     ) internal returns (bytes memory) {
354         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
359      * with `errorMessage` as a fallback revert reason when `target` reverts.
360      *
361      * _Available since v3.1._
362      */
363     function functionCallWithValue(
364         address target,
365         bytes memory data,
366         uint256 value,
367         string memory errorMessage
368     ) internal returns (bytes memory) {
369         require(address(this).balance >= value, "Address: insufficient balance for call");
370         require(isContract(target), "Address: call to non-contract");
371 
372         (bool success, bytes memory returndata) = target.call{value: value}(data);
373         return verifyCallResult(success, returndata, errorMessage);
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
378      * but performing a static call.
379      *
380      * _Available since v3.3._
381      */
382     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
383         return functionStaticCall(target, data, "Address: low-level static call failed");
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
388      * but performing a static call.
389      *
390      * _Available since v3.3._
391      */
392     function functionStaticCall(
393         address target,
394         bytes memory data,
395         string memory errorMessage
396     ) internal view returns (bytes memory) {
397         require(isContract(target), "Address: static call to non-contract");
398 
399         (bool success, bytes memory returndata) = target.staticcall(data);
400         return verifyCallResult(success, returndata, errorMessage);
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
405      * but performing a delegate call.
406      *
407      * _Available since v3.4._
408      */
409     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
410         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
415      * but performing a delegate call.
416      *
417      * _Available since v3.4._
418      */
419     function functionDelegateCall(
420         address target,
421         bytes memory data,
422         string memory errorMessage
423     ) internal returns (bytes memory) {
424         require(isContract(target), "Address: delegate call to non-contract");
425 
426         (bool success, bytes memory returndata) = target.delegatecall(data);
427         return verifyCallResult(success, returndata, errorMessage);
428     }
429 
430     /**
431      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
432      * revert reason using the provided one.
433      *
434      * _Available since v4.3._
435      */
436     function verifyCallResult(
437         bool success,
438         bytes memory returndata,
439         string memory errorMessage
440     ) internal pure returns (bytes memory) {
441         if (success) {
442             return returndata;
443         } else {
444             // Look for revert reason and bubble it up if present
445             if (returndata.length > 0) {
446                 // The easiest way to bubble the revert reason is using memory via assembly
447 
448                 assembly {
449                     let returndata_size := mload(returndata)
450                     revert(add(32, returndata), returndata_size)
451                 }
452             } else {
453                 revert(errorMessage);
454             }
455         }
456     }
457 }
458 
459 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
460 
461 
462 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
463 
464 pragma solidity ^0.8.0;
465 
466 /**
467  * @title ERC721 token receiver interface
468  * @dev Interface for any contract that wants to support safeTransfers
469  * from ERC721 asset contracts.
470  */
471 interface IERC721Receiver {
472     /**
473      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
474      * by `operator` from `from`, this function is called.
475      *
476      * It must return its Solidity selector to confirm the token transfer.
477      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
478      *
479      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
480      */
481     function onERC721Received(
482         address operator,
483         address from,
484         uint256 tokenId,
485         bytes calldata data
486     ) external returns (bytes4);
487 }
488 
489 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
490 
491 
492 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
493 
494 pragma solidity ^0.8.0;
495 
496 /**
497  * @dev Interface of the ERC165 standard, as defined in the
498  * https://eips.ethereum.org/EIPS/eip-165[EIP].
499  *
500  * Implementers can declare support of contract interfaces, which can then be
501  * queried by others ({ERC165Checker}).
502  *
503  * For an implementation, see {ERC165}.
504  */
505 interface IERC165 {
506     /**
507      * @dev Returns true if this contract implements the interface defined by
508      * `interfaceId`. See the corresponding
509      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
510      * to learn more about how these ids are created.
511      *
512      * This function call must use less than 30 000 gas.
513      */
514     function supportsInterface(bytes4 interfaceId) external view returns (bool);
515 }
516 
517 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
518 
519 
520 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
521 
522 pragma solidity ^0.8.0;
523 
524 
525 /**
526  * @dev Implementation of the {IERC165} interface.
527  *
528  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
529  * for the additional interface id that will be supported. For example:
530  *
531  * ```solidity
532  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
533  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
534  * }
535  * ```
536  *
537  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
538  */
539 abstract contract ERC165 is IERC165 {
540     /**
541      * @dev See {IERC165-supportsInterface}.
542      */
543     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
544         return interfaceId == type(IERC165).interfaceId;
545     }
546 }
547 
548 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
549 
550 
551 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
552 
553 pragma solidity ^0.8.0;
554 
555 
556 /**
557  * @dev Required interface of an ERC721 compliant contract.
558  */
559 interface IERC721 is IERC165 {
560     /**
561      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
562      */
563     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
564 
565     /**
566      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
567      */
568     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
569 
570     /**
571      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
572      */
573     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
574 
575     /**
576      * @dev Returns the number of tokens in ``owner``'s account.
577      */
578     function balanceOf(address owner) external view returns (uint256 balance);
579 
580     /**
581      * @dev Returns the owner of the `tokenId` token.
582      *
583      * Requirements:
584      *
585      * - `tokenId` must exist.
586      */
587     function ownerOf(uint256 tokenId) external view returns (address owner);
588 
589     /**
590      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
591      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
592      *
593      * Requirements:
594      *
595      * - `from` cannot be the zero address.
596      * - `to` cannot be the zero address.
597      * - `tokenId` token must exist and be owned by `from`.
598      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
599      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
600      *
601      * Emits a {Transfer} event.
602      */
603     function safeTransferFrom(
604         address from,
605         address to,
606         uint256 tokenId
607     ) external;
608 
609     /**
610      * @dev Transfers `tokenId` token from `from` to `to`.
611      *
612      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
613      *
614      * Requirements:
615      *
616      * - `from` cannot be the zero address.
617      * - `to` cannot be the zero address.
618      * - `tokenId` token must be owned by `from`.
619      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
620      *
621      * Emits a {Transfer} event.
622      */
623     function transferFrom(
624         address from,
625         address to,
626         uint256 tokenId
627     ) external;
628 
629     /**
630      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
631      * The approval is cleared when the token is transferred.
632      *
633      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
634      *
635      * Requirements:
636      *
637      * - The caller must own the token or be an approved operator.
638      * - `tokenId` must exist.
639      *
640      * Emits an {Approval} event.
641      */
642     function approve(address to, uint256 tokenId) external;
643 
644     /**
645      * @dev Returns the account approved for `tokenId` token.
646      *
647      * Requirements:
648      *
649      * - `tokenId` must exist.
650      */
651     function getApproved(uint256 tokenId) external view returns (address operator);
652 
653     /**
654      * @dev Approve or remove `operator` as an operator for the caller.
655      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
656      *
657      * Requirements:
658      *
659      * - The `operator` cannot be the caller.
660      *
661      * Emits an {ApprovalForAll} event.
662      */
663     function setApprovalForAll(address operator, bool _approved) external;
664 
665     /**
666      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
667      *
668      * See {setApprovalForAll}
669      */
670     function isApprovedForAll(address owner, address operator) external view returns (bool);
671 
672     /**
673      * @dev Safely transfers `tokenId` token from `from` to `to`.
674      *
675      * Requirements:
676      *
677      * - `from` cannot be the zero address.
678      * - `to` cannot be the zero address.
679      * - `tokenId` token must exist and be owned by `from`.
680      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
681      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
682      *
683      * Emits a {Transfer} event.
684      */
685     function safeTransferFrom(
686         address from,
687         address to,
688         uint256 tokenId,
689         bytes calldata data
690     ) external;
691 }
692 
693 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
694 
695 
696 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
697 
698 pragma solidity ^0.8.0;
699 
700 
701 /**
702  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
703  * @dev See https://eips.ethereum.org/EIPS/eip-721
704  */
705 interface IERC721Enumerable is IERC721 {
706     /**
707      * @dev Returns the total amount of tokens stored by the contract.
708      */
709     function totalSupply() external view returns (uint256);
710 
711     /**
712      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
713      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
714      */
715     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
716 
717     /**
718      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
719      * Use along with {totalSupply} to enumerate all tokens.
720      */
721     function tokenByIndex(uint256 index) external view returns (uint256);
722 }
723 
724 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
725 
726 
727 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
728 
729 pragma solidity ^0.8.0;
730 
731 
732 /**
733  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
734  * @dev See https://eips.ethereum.org/EIPS/eip-721
735  */
736 interface IERC721Metadata is IERC721 {
737     /**
738      * @dev Returns the token collection name.
739      */
740     function name() external view returns (string memory);
741 
742     /**
743      * @dev Returns the token collection symbol.
744      */
745     function symbol() external view returns (string memory);
746 
747     /**
748      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
749      */
750     function tokenURI(uint256 tokenId) external view returns (string memory);
751 }
752 
753 // File: contracts/KingEerosKnights.sol
754 
755 
756 pragma solidity ^0.8.4;
757 
758 
759 
760 
761 
762 
763 
764 
765 
766 
767 error ApprovalCallerNotOwnerNorApproved();
768 error ApprovalQueryForNonexistentToken();
769 error ApproveToCaller();
770 error ApprovalToCurrentOwner();
771 error BalanceQueryForZeroAddress();
772 error MintedQueryForZeroAddress();
773 error BurnedQueryForZeroAddress();
774 error AuxQueryForZeroAddress();
775 error MintToZeroAddress();
776 error MintZeroQuantity();
777 error OwnerIndexOutOfBounds();
778 error OwnerQueryForNonexistentToken();
779 error TokenIndexOutOfBounds();
780 error TransferCallerNotOwnerNorApproved();
781 error TransferFromIncorrectOwner();
782 error TransferToNonERC721ReceiverImplementer();
783 error TransferToZeroAddress();
784 error URIQueryForNonexistentToken();
785 
786 /**
787  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
788  * the Metadata extension. Built to optimize for lower gas during batch mints.
789  *
790  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
791  *
792  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
793  *
794  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
795  */
796 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
797     using Address for address;
798     using Strings for uint256;
799 
800     // Compiler will pack this into a single 256bit word.
801     struct TokenOwnership {
802         // The address of the owner.
803         address addr;
804         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
805         uint64 startTimestamp;
806         // Whether the token has been burned.
807         bool burned;
808     }
809 
810     // Compiler will pack this into a single 256bit word.
811     struct AddressData {
812         // Realistically, 2**64-1 is more than enough.
813         uint64 balance;
814         // Keeps track of mint count with minimal overhead for tokenomics.
815         uint64 numberMinted;
816         // Keeps track of burn count with minimal overhead for tokenomics.
817         uint64 numberBurned;
818         // For miscellaneous variable(s) pertaining to the address
819         // (e.g. number of whitelist mint slots used). 
820         // If there are multiple variables, please pack them into a uint64.
821         uint64 aux;
822     }
823 
824     // The tokenId of the next token to be minted.
825     uint256 internal _currentIndex;
826 
827     // The number of tokens burned.
828     uint256 internal _burnCounter;
829 
830     // Token name
831     string private _name;
832 
833     // Token symbol
834     string private _symbol;
835 
836     // Mapping from token ID to ownership details
837     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
838     mapping(uint256 => TokenOwnership) internal _ownerships;
839 
840     // Mapping owner address to address data
841     mapping(address => AddressData) private _addressData;
842 
843     // Mapping from token ID to approved address
844     mapping(uint256 => address) private _tokenApprovals;
845 
846     // Mapping from owner to operator approvals
847     mapping(address => mapping(address => bool)) private _operatorApprovals;
848 
849     constructor(string memory name_, string memory symbol_) {
850         _name = name_;
851         _symbol = symbol_;
852     }
853 
854     /**
855      * @dev See {IERC721Enumerable-totalSupply}.
856      */
857     function totalSupply() public view returns (uint256) {
858         // Counter underflow is impossible as _burnCounter cannot be incremented
859         // more than _currentIndex times
860         unchecked {
861             return _currentIndex - _burnCounter;    
862         }
863     }
864 
865     /**
866      * @dev See {IERC165-supportsInterface}.
867      */
868     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
869         return
870             interfaceId == type(IERC721).interfaceId ||
871             interfaceId == type(IERC721Metadata).interfaceId ||
872             super.supportsInterface(interfaceId);
873     }
874 
875     /**
876      * @dev See {IERC721-balanceOf}.
877      */
878     function balanceOf(address owner) public view override returns (uint256) {
879         if (owner == address(0)) revert BalanceQueryForZeroAddress();
880         return uint256(_addressData[owner].balance);
881     }
882 
883     /**
884      * Returns the number of tokens minted by `owner`.
885      */
886     function _numberMinted(address owner) internal view returns (uint256) {
887         if (owner == address(0)) revert MintedQueryForZeroAddress();
888         return uint256(_addressData[owner].numberMinted);
889     }
890 
891     /**
892      * Returns the number of tokens burned by or on behalf of `owner`.
893      */
894     function _numberBurned(address owner) internal view returns (uint256) {
895         if (owner == address(0)) revert BurnedQueryForZeroAddress();
896         return uint256(_addressData[owner].numberBurned);
897     }
898 
899     /**
900      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
901      */
902     function _getAux(address owner) internal view returns (uint64) {
903         if (owner == address(0)) revert AuxQueryForZeroAddress();
904         return _addressData[owner].aux;
905     }
906 
907     /**
908      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
909      * If there are multiple variables, please pack them into a uint64.
910      */
911     function _setAux(address owner, uint64 aux) internal {
912         if (owner == address(0)) revert AuxQueryForZeroAddress();
913         _addressData[owner].aux = aux;
914     }
915 
916     /**
917      * Gas spent here starts off proportional to the maximum mint batch size.
918      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
919      */
920     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
921         uint256 curr = tokenId;
922 
923         unchecked {
924             if (curr < _currentIndex) {
925                 TokenOwnership memory ownership = _ownerships[curr];
926                 if (!ownership.burned) {
927                     if (ownership.addr != address(0)) {
928                         return ownership;
929                     }
930                     // Invariant: 
931                     // There will always be an ownership that has an address and is not burned 
932                     // before an ownership that does not have an address and is not burned.
933                     // Hence, curr will not underflow.
934                     while (true) {
935                         curr--;
936                         ownership = _ownerships[curr];
937                         if (ownership.addr != address(0)) {
938                             return ownership;
939                         }
940                     }
941                 }
942             }
943         }
944         revert OwnerQueryForNonexistentToken();
945     }
946 
947     /**
948      * @dev See {IERC721-ownerOf}.
949      */
950     function ownerOf(uint256 tokenId) public view override returns (address) {
951         return ownershipOf(tokenId).addr;
952     }
953 
954     /**
955      * @dev See {IERC721Metadata-name}.
956      */
957     function name() public view virtual override returns (string memory) {
958         return _name;
959     }
960 
961     /**
962      * @dev See {IERC721Metadata-symbol}.
963      */
964     function symbol() public view virtual override returns (string memory) {
965         return _symbol;
966     }
967 
968     /**
969      * @dev See {IERC721Metadata-tokenURI}.
970      */
971     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
972         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
973 
974         string memory baseURI = _baseURI();
975         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
976     }
977 
978     /**
979      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
980      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
981      * by default, can be overriden in child contracts.
982      */
983     function _baseURI() internal view virtual returns (string memory) {
984         return '';
985     }
986 
987     /**
988      * @dev See {IERC721-approve}.
989      */
990     function approve(address to, uint256 tokenId) public override {
991         address owner = ERC721A.ownerOf(tokenId);
992         if (to == owner) revert ApprovalToCurrentOwner();
993 
994         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
995             revert ApprovalCallerNotOwnerNorApproved();
996         }
997 
998         _approve(to, tokenId, owner);
999     }
1000 
1001     /**
1002      * @dev See {IERC721-getApproved}.
1003      */
1004     function getApproved(uint256 tokenId) public view override returns (address) {
1005         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1006 
1007         return _tokenApprovals[tokenId];
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-setApprovalForAll}.
1012      */
1013     function setApprovalForAll(address operator, bool approved) public override {
1014         require(totalSupply() >= 9999, "not permitted until all gems are minted");
1015         if (operator == _msgSender()) revert ApproveToCaller();
1016 
1017         _operatorApprovals[_msgSender()][operator] = approved;
1018         emit ApprovalForAll(_msgSender(), operator, approved);
1019     }
1020 
1021     /**
1022      * @dev See {IERC721-isApprovedForAll}.
1023      */
1024     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1025         return _operatorApprovals[owner][operator];
1026     }
1027 
1028     /**
1029      * @dev See {IERC721-transferFrom}.
1030      */
1031     function transferFrom(
1032         address from,
1033         address to,
1034         uint256 tokenId
1035     ) public virtual override {
1036         _transfer(from, to, tokenId);
1037     }
1038 
1039     /**
1040      * @dev See {IERC721-safeTransferFrom}.
1041      */
1042     function safeTransferFrom(
1043         address from,
1044         address to,
1045         uint256 tokenId
1046     ) public virtual override {
1047         safeTransferFrom(from, to, tokenId, '');
1048     }
1049 
1050     /**
1051      * @dev See {IERC721-safeTransferFrom}.
1052      */
1053     function safeTransferFrom(
1054         address from,
1055         address to,
1056         uint256 tokenId,
1057         bytes memory _data
1058     ) public virtual override {
1059         _transfer(from, to, tokenId);
1060         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1061             revert TransferToNonERC721ReceiverImplementer();
1062         }
1063     }
1064 
1065     /**
1066      * @dev Returns whether `tokenId` exists.
1067      *
1068      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1069      *
1070      * Tokens start existing when they are minted (`_mint`),
1071      */
1072     function _exists(uint256 tokenId) internal view returns (bool) {
1073         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1074     }
1075 
1076     function _safeMint(address to, uint256 quantity) internal {
1077         _safeMint(to, quantity, '');
1078     }
1079 
1080     /**
1081      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1082      *
1083      * Requirements:
1084      *
1085      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1086      * - `quantity` must be greater than 0.
1087      *
1088      * Emits a {Transfer} event.
1089      */
1090     function _safeMint(
1091         address to,
1092         uint256 quantity,
1093         bytes memory _data
1094     ) internal {
1095         _mint(to, quantity, _data, true);
1096     }
1097 
1098     /**
1099      * @dev Mints `quantity` tokens and transfers them to `to`.
1100      *
1101      * Requirements:
1102      *
1103      * - `to` cannot be the zero address.
1104      * - `quantity` must be greater than 0.
1105      *
1106      * Emits a {Transfer} event.
1107      */
1108     function _mint(
1109         address to,
1110         uint256 quantity,
1111         bytes memory _data,
1112         bool safe
1113     ) internal {
1114         uint256 startTokenId = _currentIndex;
1115         if (to == address(0)) revert MintToZeroAddress();
1116         if (quantity == 0) revert MintZeroQuantity();
1117 
1118         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1119 
1120         // Overflows are incredibly unrealistic.
1121         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1122         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1123         unchecked {
1124             _addressData[to].balance += uint64(quantity);
1125             _addressData[to].numberMinted += uint64(quantity);
1126 
1127             _ownerships[startTokenId].addr = to;
1128             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1129 
1130             uint256 updatedIndex = startTokenId;
1131 
1132             for (uint256 i; i < quantity; i++) {
1133                 emit Transfer(address(0), to, updatedIndex);
1134                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1135                     revert TransferToNonERC721ReceiverImplementer();
1136                 }
1137                 updatedIndex++;
1138             }
1139 
1140             _currentIndex = updatedIndex;
1141         }
1142         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1143     }
1144 
1145     /**
1146      * @dev Transfers `tokenId` from `from` to `to`.
1147      *
1148      * Requirements:
1149      *
1150      * - `to` cannot be the zero address.
1151      * - `tokenId` token must be owned by `from`.
1152      *
1153      * Emits a {Transfer} event.
1154      */
1155     function _transfer(
1156         address from,
1157         address to,
1158         uint256 tokenId
1159     ) private {
1160         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1161 
1162         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1163             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1164             getApproved(tokenId) == _msgSender());
1165 
1166         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1167         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1168         if (to == address(0)) revert TransferToZeroAddress();
1169 
1170         _beforeTokenTransfers(from, to, tokenId, 1);
1171 
1172         // Clear approvals from the previous owner
1173         _approve(address(0), tokenId, prevOwnership.addr);
1174 
1175         // Underflow of the sender's balance is impossible because we check for
1176         // ownership above and the recipient's balance can't realistically overflow.
1177         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1178         unchecked {
1179             _addressData[from].balance -= 1;
1180             _addressData[to].balance += 1;
1181 
1182             _ownerships[tokenId].addr = to;
1183             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1184 
1185             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1186             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1187             uint256 nextTokenId = tokenId + 1;
1188             if (_ownerships[nextTokenId].addr == address(0)) {
1189                 // This will suffice for checking _exists(nextTokenId),
1190                 // as a burned slot cannot contain the zero address.
1191                 if (nextTokenId < _currentIndex) {
1192                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1193                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1194                 }
1195             }
1196         }
1197 
1198         emit Transfer(from, to, tokenId);
1199         _afterTokenTransfers(from, to, tokenId, 1);
1200     }
1201 
1202     /**
1203      * @dev Destroys `tokenId`.
1204      * The approval is cleared when the token is burned.
1205      *
1206      * Requirements:
1207      *
1208      * - `tokenId` must exist.
1209      *
1210      * Emits a {Transfer} event.
1211      */
1212     function _burn(uint256 tokenId) internal virtual {
1213         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1214 
1215         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1216 
1217         // Clear approvals from the previous owner
1218         _approve(address(0), tokenId, prevOwnership.addr);
1219 
1220         // Underflow of the sender's balance is impossible because we check for
1221         // ownership above and the recipient's balance can't realistically overflow.
1222         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1223         unchecked {
1224             _addressData[prevOwnership.addr].balance -= 1;
1225             _addressData[prevOwnership.addr].numberBurned += 1;
1226 
1227             // Keep track of who burned the token, and the timestamp of burning.
1228             _ownerships[tokenId].addr = prevOwnership.addr;
1229             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1230             _ownerships[tokenId].burned = true;
1231 
1232             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1233             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1234             uint256 nextTokenId = tokenId + 1;
1235             if (_ownerships[nextTokenId].addr == address(0)) {
1236                 // This will suffice for checking _exists(nextTokenId),
1237                 // as a burned slot cannot contain the zero address.
1238                 if (nextTokenId < _currentIndex) {
1239                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1240                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1241                 }
1242             }
1243         }
1244 
1245         emit Transfer(prevOwnership.addr, address(0), tokenId);
1246         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1247 
1248         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1249         unchecked { 
1250             _burnCounter++;
1251         }
1252     }
1253 
1254     /**
1255      * @dev Approve `to` to operate on `tokenId`
1256      *
1257      * Emits a {Approval} event.
1258      */
1259     function _approve(
1260         address to,
1261         uint256 tokenId,
1262         address owner
1263     ) private {
1264         _tokenApprovals[tokenId] = to;
1265         emit Approval(owner, to, tokenId);
1266     }
1267 
1268     /**
1269      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1270      * The call is not executed if the target address is not a contract.
1271      *
1272      * @param from address representing the previous owner of the given token ID
1273      * @param to target address that will receive the tokens
1274      * @param tokenId uint256 ID of the token to be transferred
1275      * @param _data bytes optional data to send along with the call
1276      * @return bool whether the call correctly returned the expected magic value
1277      */
1278     function _checkOnERC721Received(
1279         address from,
1280         address to,
1281         uint256 tokenId,
1282         bytes memory _data
1283     ) private returns (bool) {
1284         if (to.isContract()) {
1285             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1286                 return retval == IERC721Receiver(to).onERC721Received.selector;
1287             } catch (bytes memory reason) {
1288                 if (reason.length == 0) {
1289                     revert TransferToNonERC721ReceiverImplementer();
1290                 } else {
1291                     assembly {
1292                         revert(add(32, reason), mload(reason))
1293                     }
1294                 }
1295             }
1296         } else {
1297             return true;
1298         }
1299     }
1300 
1301     /**
1302      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1303      * And also called before burning one token.
1304      *
1305      * startTokenId - the first token id to be transferred
1306      * quantity - the amount to be transferred
1307      *
1308      * Calling conditions:
1309      *
1310      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1311      * transferred to `to`.
1312      * - When `from` is zero, `tokenId` will be minted for `to`.
1313      * - When `to` is zero, `tokenId` will be burned by `from`.
1314      * - `from` and `to` are never both zero.
1315      */
1316     function _beforeTokenTransfers(
1317         address from,
1318         address to,
1319         uint256 startTokenId,
1320         uint256 quantity
1321     ) internal virtual {}
1322 
1323     /**
1324      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1325      * minting.
1326      * And also called after one token has been burned.
1327      *
1328      * startTokenId - the first token id to be transferred
1329      * quantity - the amount to be transferred
1330      *
1331      * Calling conditions:
1332      *
1333      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1334      * transferred to `to`.
1335      * - When `from` is zero, `tokenId` has been minted for `to`.
1336      * - When `to` is zero, `tokenId` has been burned by `from`.
1337      * - `from` and `to` are never both zero.
1338      */
1339     function _afterTokenTransfers(
1340         address from,
1341         address to,
1342         uint256 startTokenId,
1343         uint256 quantity
1344     ) internal virtual {}
1345 }
1346 
1347 contract KingEerosKnights is ERC721A, Ownable {
1348     using Strings for uint256;
1349 
1350     uint256 public constant MAX_GEMS = 9999;
1351     uint256 public constant MAX_GEMS_MINTED = 10;
1352     uint256 private knightsCount = 0;
1353     bool public isKing = false;
1354     bool public isQueen = false;
1355     string public constant BASE_TOKEN_URI = "ipfs://QmeG5bEemxUxzNJkQAANabDAfGJ5xrCQdnMJSfhJVPaxbx/";
1356     string public constant GEM_CLARITY = "GEM CLARITY";
1357     string public constant GEM_CUT = "GEM CUT";
1358 
1359     constructor() ERC721A("King Eeros Knights", "CROWN") {} 
1360 
1361      /**
1362      * @dev See {ERC721-_beforeTokenTranfser}.
1363      */
1364      function _beforeTokenTransfers(
1365         address from,
1366         address to,
1367         uint256 startTokenId,
1368         uint256 quantity
1369     ) internal virtual override {
1370         require(from == address(0) || totalSupply() >= MAX_GEMS, "not permitted until all gems are minted");
1371         super._beforeTokenTransfers(from, to, startTokenId, quantity);
1372     }
1373 
1374     /**
1375      * @dev Mint your gems for free (eth gas fees only).
1376      * @param _numberOfGems The number of gems you want to mint. Max 10 per wallet.
1377      */
1378     function mintGems(uint256 _numberOfGems) public {
1379         uint256 currentTotal = totalSupply();
1380         require(_numberOfGems > 0, "wtf");
1381         require(currentTotal + _numberOfGems <= MAX_GEMS, "fren, gems are minted");
1382         require(balanceOf(_msgSender()) + _numberOfGems <= MAX_GEMS_MINTED, "greedy");
1383 
1384         _safeMint(msg.sender, _numberOfGems);
1385     }
1386 
1387     function getGemId(uint256 _tokenId) internal pure returns (uint256) {
1388         uint256 rarity = uint256(keccak256(abi.encodePacked("GEM", Strings.toString(_tokenId)))) % 101;
1389         uint256 gemId = 0;
1390         if (rarity >= 15) { gemId = 1; }
1391         if (rarity >= 25) { gemId = 2; }
1392         if (rarity >= 50) { gemId = 3; }
1393         if (rarity >= 75) { gemId = 4; }
1394         if (rarity >= 90) { gemId = 5; }
1395         if (rarity >= 96) { gemId = 6; }
1396         if (rarity >= 99) { gemId = 8; }
1397         if (rarity == 69) { gemId = 7; }
1398         return gemId;
1399     }
1400 
1401     function getGrade(uint256 _tokenId, string memory _gradeType) internal pure returns (uint256) {
1402         uint256 rarity = uint256(keccak256(abi.encodePacked(_gradeType, Strings.toString(_tokenId)))) % 101;
1403         uint256 grade = 0;
1404         if (rarity >= 5) { grade = 1; }
1405         if (rarity >= 25) { grade = 2; }
1406         if (rarity >= 90) { grade = 3; }
1407         if (rarity == 100) { grade = 4; }
1408         return grade;
1409     }
1410 
1411     function getKnighted(uint256[] memory knightKeys) public {
1412         require(totalSupply() >= MAX_GEMS, "not permitted until all gems are minted");
1413         require(knightsCount < 9, "Knights are knighted");
1414         require(knightKeys[10] == uint256(keccak256(abi.encodePacked(msg.sender))) % 69, "oooooh, try again ser");
1415         for (uint256 i = 0; i < 9; i++) {
1416             uint256 _tokenId = knightKeys[i];
1417             require(ownerOf(_tokenId) == msg.sender);
1418             require(getGemId(_tokenId) == knightsCount);
1419             transferFrom(msg.sender, 0x000000000000000000000000000000000000dEaD, _tokenId);
1420         } 
1421         uint256 _gripTokenId = knightKeys[9];
1422         require(ownerOf(_gripTokenId) == msg.sender);
1423         require(getGemId(_gripTokenId) == 6);
1424 
1425         // mint sword
1426         _safeMint(msg.sender, 1);
1427         knightsCount = knightsCount + 1;
1428     }
1429     
1430     function claimThrone(uint256[] memory crownKeys) public {
1431         require(!isKing || !isQueen);
1432         require(knightsCount >= 9, "Knights are not knighted");
1433         require(crownKeys[20] == uint256(keccak256(abi.encodePacked(msg.sender))) % 69, "oooooh, try again ser");
1434         uint256 minGems = isQueen ? 100 : 50;
1435         require(balanceOf(_msgSender()) >= minGems, "needs more gems to claim the crown"); 
1436 
1437         for (uint256 i = 0; i < 5; i++) {
1438             uint256 _tokenId = crownKeys[i];
1439             require(ownerOf(_tokenId) == msg.sender);
1440             require(getGrade(_tokenId, GEM_CLARITY) == i);
1441         }
1442 
1443         for (uint256 i = 0; i < 5; i++) {
1444             uint256 _tokenId = crownKeys[i + 5];
1445             require(ownerOf(_tokenId) == msg.sender);
1446             require(getGrade(_tokenId, GEM_CUT) == i);
1447         }
1448 
1449         for (uint256 i = 0; i < 9; i++) {
1450             uint256 _tokenId = crownKeys[i + 10];
1451             require(ownerOf(_tokenId) == msg.sender);
1452             require(getGemId(_tokenId) == i);
1453             transferFrom(msg.sender, 0x000000000000000000000000000000000000dEaD, _tokenId);
1454         } 
1455 
1456         // mint crown
1457         _safeMint(msg.sender, 1);
1458 
1459         if (isQueen) {
1460             isKing = true;
1461         }
1462         isQueen = true;
1463     }
1464 
1465     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1466         uint256 gemId = getGemId(tokenId);
1467         uint256 gemClarity = getGrade(tokenId, GEM_CLARITY);
1468         uint256 gemCut = getGrade(tokenId, GEM_CUT);
1469         uint256 path = gemId * 100 + gemClarity * 10 + gemCut;
1470         
1471         if (tokenId >= MAX_GEMS) {
1472             uint256 uniqueCount = tokenId - MAX_GEMS;
1473             path = uniqueCount + 1000;
1474             if (uniqueCount == 9) {
1475                 path = 1420;
1476             }
1477             if (uniqueCount == 10) {
1478                 path = 1069;
1479             }
1480         }
1481         if (totalSupply() < MAX_GEMS) {
1482             path = 999;
1483         }
1484         return string(abi.encodePacked(BASE_TOKEN_URI, Strings.toString(path)));
1485     }
1486 }