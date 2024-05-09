1 // SPDX-License-Identifier: MIT
2 
3 
4                                                                                 
5                                                                                 
6 //                           D I C K B U T T V E R S E                                                                                
7 //                                                                                
8 //                 ***//////////*                   ,#(((#########(               
9 //              **/////(((((((((////*,        ((######################            
10 //            **//((##(######(((((((/////############%%%%%%%%%%%%%%%####          
11 //           **/#    *//  #(((#(((((((///#######%%%%%%%%%%%%%&&&&    %%##.        
12 //          //(     */         #(((((((//###%#%%%%%%%%%*        &&      ##        
13 //        *****/  *****       ,**********//////////((((         ****    ,***      
14 //       ****//// *//((      ///*****************///((((       ////(   *****//    
15 //         ((((                ****************///(((,                 *///((     
16 //                             .#(((((,,,,,****(####                              
17 //                            (#/****/((****/(/**//(#*                            
18 //                             ((****/((#(((#(/*///##                             
19 //                             **,#(((/,,,***((##(#(                              
20 //                             ***,,,,,,*,,*/****///                              
21 //                             ***********((//*///(                               
22 //                   ,,*/,*(&&***/@@@@@@@@@@@@@@@@@% ,.                           
23 //                   /((((/  &&&***************///(&/*,,*                         
24 //                  ,,*/((@@@@@@@@.. ,*********///,@@@/,,*/                       
25 //                 **/(&@@@@@@@@@@@@.....(@@@@@,,,*@@@  (****                     
26 //                      &&&&@@@@@@@@@@%..,..@,,,**@@@      /(                     
27 //                      &&&&@@@@@@@@@@@@@...,,**@@#                               
28 //                      %&&@@@@@@@@@@@@@@@@@@@@@@                                 
29 //                       ,&&@@@@@@@@@@@@@@@@@@@@@                                 
30 //                          &&@@@@@@@@@@@@@@@@@@@                                 
31 //                           @@@@@&@&@@&@@@@@@@&                                  
32 //                           %@@@@/    &@@@@,                                     
33 //                            @@@@@     @@@@@                                     
34 //                            &&((#     .  .,                                     
35 //                            .  ..,   ..  .,,                                    
36 //                           ......*   ,.....*                                    
37 
38 
39 
40 pragma solidity ^0.8.0;
41 
42 /**
43  * @title ERC721 token receiver interface
44  * @dev Interface for any contract that wants to support safeTransfers
45  * from ERC721 asset contracts.
46  */
47 interface IERC721Receiver {
48     /**
49      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
50      * by `operator` from `from`, this function is called.
51      *
52      * It must return its Solidity selector to confirm the token transfer.
53      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
54      *
55      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
56      */
57     function onERC721Received(
58         address operator,
59         address from,
60         uint256 tokenId,
61         bytes calldata data
62     ) external returns (bytes4);
63 }
64 
65 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
66 
67 
68 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
69 
70 pragma solidity ^0.8.0;
71 
72 /**
73  * @dev Interface of the ERC165 standard, as defined in the
74  * https://eips.ethereum.org/EIPS/eip-165[EIP].
75  *
76  * Implementers can declare support of contract interfaces, which can then be
77  * queried by others ({ERC165Checker}).
78  *
79  * For an implementation, see {ERC165}.
80  */
81 interface IERC165 {
82     /**
83      * @dev Returns true if this contract implements the interface defined by
84      * `interfaceId`. See the corresponding
85      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
86      * to learn more about how these ids are created.
87      *
88      * This function call must use less than 30 000 gas.
89      */
90     function supportsInterface(bytes4 interfaceId) external view returns (bool);
91 }
92 
93 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
94 
95 
96 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
97 
98 pragma solidity ^0.8.0;
99 
100 
101 /**
102  * @dev Implementation of the {IERC165} interface.
103  *
104  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
105  * for the additional interface id that will be supported. For example:
106  *
107  * ```solidity
108  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
109  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
110  * }
111  * ```
112  *
113  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
114  */
115 abstract contract ERC165 is IERC165 {
116     /**
117      * @dev See {IERC165-supportsInterface}.
118      */
119     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
120         return interfaceId == type(IERC165).interfaceId;
121     }
122 }
123 
124 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
125 
126 
127 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
128 
129 pragma solidity ^0.8.0;
130 
131 
132 /**
133  * @dev Required interface of an ERC721 compliant contract.
134  */
135 interface IERC721 is IERC165 {
136     /**
137      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
138      */
139     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
140 
141     /**
142      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
143      */
144     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
145 
146     /**
147      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
148      */
149     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
150 
151     /**
152      * @dev Returns the number of tokens in ``owner``'s account.
153      */
154     function balanceOf(address owner) external view returns (uint256 balance);
155 
156     /**
157      * @dev Returns the owner of the `tokenId` token.
158      *
159      * Requirements:
160      *
161      * - `tokenId` must exist.
162      */
163     function ownerOf(uint256 tokenId) external view returns (address owner);
164 
165     /**
166      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
167      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
168      *
169      * Requirements:
170      *
171      * - `from` cannot be the zero address.
172      * - `to` cannot be the zero address.
173      * - `tokenId` token must exist and be owned by `from`.
174      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
175      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
176      *
177      * Emits a {Transfer} event.
178      */
179     function safeTransferFrom(
180         address from,
181         address to,
182         uint256 tokenId
183     ) external;
184 
185     /**
186      * @dev Transfers `tokenId` token from `from` to `to`.
187      *
188      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
189      *
190      * Requirements:
191      *
192      * - `from` cannot be the zero address.
193      * - `to` cannot be the zero address.
194      * - `tokenId` token must be owned by `from`.
195      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
196      *
197      * Emits a {Transfer} event.
198      */
199     function transferFrom(
200         address from,
201         address to,
202         uint256 tokenId
203     ) external;
204 
205     /**
206      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
207      * The approval is cleared when the token is transferred.
208      *
209      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
210      *
211      * Requirements:
212      *
213      * - The caller must own the token or be an approved operator.
214      * - `tokenId` must exist.
215      *
216      * Emits an {Approval} event.
217      */
218     function approve(address to, uint256 tokenId) external;
219 
220     /**
221      * @dev Returns the account approved for `tokenId` token.
222      *
223      * Requirements:
224      *
225      * - `tokenId` must exist.
226      */
227     function getApproved(uint256 tokenId) external view returns (address operator);
228 
229     /**
230      * @dev Approve or remove `operator` as an operator for the caller.
231      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
232      *
233      * Requirements:
234      *
235      * - The `operator` cannot be the caller.
236      *
237      * Emits an {ApprovalForAll} event.
238      */
239     function setApprovalForAll(address operator, bool _approved) external;
240 
241     /**
242      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
243      *
244      * See {setApprovalForAll}
245      */
246     function isApprovedForAll(address owner, address operator) external view returns (bool);
247 
248     /**
249      * @dev Safely transfers `tokenId` token from `from` to `to`.
250      *
251      * Requirements:
252      *
253      * - `from` cannot be the zero address.
254      * - `to` cannot be the zero address.
255      * - `tokenId` token must exist and be owned by `from`.
256      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
257      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
258      *
259      * Emits a {Transfer} event.
260      */
261     function safeTransferFrom(
262         address from,
263         address to,
264         uint256 tokenId,
265         bytes calldata data
266     ) external;
267 }
268 
269 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
270 
271 
272 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
273 
274 pragma solidity ^0.8.0;
275 
276 /**
277  * @dev String operations.
278  */
279 library Strings {
280     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
281 
282     /**
283      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
284      */
285     function toString(uint256 value) internal pure returns (string memory) {
286         // Inspired by OraclizeAPI's implementation - MIT licence
287         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
288 
289         if (value == 0) {
290             return "0";
291         }
292         uint256 temp = value;
293         uint256 digits;
294         while (temp != 0) {
295             digits++;
296             temp /= 10;
297         }
298         bytes memory buffer = new bytes(digits);
299         while (value != 0) {
300             digits -= 1;
301             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
302             value /= 10;
303         }
304         return string(buffer);
305     }
306 
307     /**
308      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
309      */
310     function toHexString(uint256 value) internal pure returns (string memory) {
311         if (value == 0) {
312             return "0x00";
313         }
314         uint256 temp = value;
315         uint256 length = 0;
316         while (temp != 0) {
317             length++;
318             temp >>= 8;
319         }
320         return toHexString(value, length);
321     }
322 
323     /**
324      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
325      */
326     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
327         bytes memory buffer = new bytes(2 * length + 2);
328         buffer[0] = "0";
329         buffer[1] = "x";
330         for (uint256 i = 2 * length + 1; i > 1; --i) {
331             buffer[i] = _HEX_SYMBOLS[value & 0xf];
332             value >>= 4;
333         }
334         require(value == 0, "Strings: hex length insufficient");
335         return string(buffer);
336     }
337 }
338 
339 // File: @openzeppelin/contracts/utils/Context.sol
340 
341 
342 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
343 
344 pragma solidity ^0.8.0;
345 
346 /**
347  * @dev Provides information about the current execution context, including the
348  * sender of the transaction and its data. While these are generally available
349  * via msg.sender and msg.data, they should not be accessed in such a direct
350  * manner, since when dealing with meta-transactions the account sending and
351  * paying for execution may not be the actual sender (as far as an application
352  * is concerned).
353  *
354  * This contract is only required for intermediate, library-like contracts.
355  */
356 abstract contract Context {
357     function _msgSender() internal view virtual returns (address) {
358         return msg.sender;
359     }
360 
361     function _msgData() internal view virtual returns (bytes calldata) {
362         return msg.data;
363     }
364 }
365 
366 // File: @openzeppelin/contracts/access/Ownable.sol
367 
368 
369 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
370 
371 pragma solidity ^0.8.0;
372 
373 
374 /**
375  * @dev Contract module which provides a basic access control mechanism, where
376  * there is an account (an owner) that can be granted exclusive access to
377  * specific functions.
378  *
379  * By default, the owner account will be the one that deploys the contract. This
380  * can later be changed with {transferOwnership}.
381  *
382  * This module is used through inheritance. It will make available the modifier
383  * `onlyOwner`, which can be applied to your functions to restrict their use to
384  * the owner.
385  */
386 abstract contract Ownable is Context {
387     address private _owner;
388 
389     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
390 
391     /**
392      * @dev Initializes the contract setting the deployer as the initial owner.
393      */
394     constructor() {
395         _transferOwnership(_msgSender());
396     }
397 
398     /**
399      * @dev Returns the address of the current owner.
400      */
401     function owner() public view virtual returns (address) {
402         return _owner;
403     }
404 
405     /**
406      * @dev Throws if called by any account other than the owner.
407      */
408     modifier onlyOwner() {
409         require(owner() == _msgSender(), "Ownable: caller is not the owner");
410         _;
411     }
412 
413     /**
414      * @dev Leaves the contract without owner. It will not be possible to call
415      * `onlyOwner` functions anymore. Can only be called by the current owner.
416      *
417      * NOTE: Renouncing ownership will leave the contract without an owner,
418      * thereby removing any functionality that is only available to the owner.
419      */
420     function renounceOwnership() public virtual onlyOwner {
421         _transferOwnership(address(0));
422     }
423 
424     /**
425      * @dev Transfers ownership of the contract to a new account (`newOwner`).
426      * Can only be called by the current owner.
427      */
428     function transferOwnership(address newOwner) public virtual onlyOwner {
429         require(newOwner != address(0), "Ownable: new owner is the zero address");
430         _transferOwnership(newOwner);
431     }
432 
433     /**
434      * @dev Transfers ownership of the contract to a new account (`newOwner`).
435      * Internal function without access restriction.
436      */
437     function _transferOwnership(address newOwner) internal virtual {
438         address oldOwner = _owner;
439         _owner = newOwner;
440         emit OwnershipTransferred(oldOwner, newOwner);
441     }
442 }
443 
444 // File: @openzeppelin/contracts/utils/Address.sol
445 
446 
447 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
448 
449 pragma solidity ^0.8.0;
450 
451 /**
452  * @dev Collection of functions related to the address type
453  */
454 library Address {
455     /**
456      * @dev Returns true if `account` is a contract.
457      *
458      * [IMPORTANT]
459      * ====
460      * It is unsafe to assume that an address for which this function returns
461      * false is an externally-owned account (EOA) and not a contract.
462      *
463      * Among others, `isContract` will return false for the following
464      * types of addresses:
465      *
466      *  - an externally-owned account
467      *  - a contract in construction
468      *  - an address where a contract will be created
469      *  - an address where a contract lived, but was destroyed
470      * ====
471      */
472     function isContract(address account) internal view returns (bool) {
473         // This method relies on extcodesize, which returns 0 for contracts in
474         // construction, since the code is only stored at the end of the
475         // constructor execution.
476 
477         uint256 size;
478         assembly {
479             size := extcodesize(account)
480         }
481         return size > 0;
482     }
483 
484     /**
485      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
486      * `recipient`, forwarding all available gas and reverting on errors.
487      *
488      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
489      * of certain opcodes, possibly making contracts go over the 2300 gas limit
490      * imposed by `transfer`, making them unable to receive funds via
491      * `transfer`. {sendValue} removes this limitation.
492      *
493      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
494      *
495      * IMPORTANT: because control is transferred to `recipient`, care must be
496      * taken to not create reentrancy vulnerabilities. Consider using
497      * {ReentrancyGuard} or the
498      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
499      */
500     function sendValue(address payable recipient, uint256 amount) internal {
501         require(address(this).balance >= amount, "Address: insufficient balance");
502 
503         (bool success, ) = recipient.call{value: amount}("");
504         require(success, "Address: unable to send value, recipient may have reverted");
505     }
506 
507     /**
508      * @dev Performs a Solidity function call using a low level `call`. A
509      * plain `call` is an unsafe replacement for a function call: use this
510      * function instead.
511      *
512      * If `target` reverts with a revert reason, it is bubbled up by this
513      * function (like regular Solidity function calls).
514      *
515      * Returns the raw returned data. To convert to the expected return value,
516      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
517      *
518      * Requirements:
519      *
520      * - `target` must be a contract.
521      * - calling `target` with `data` must not revert.
522      *
523      * _Available since v3.1._
524      */
525     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
526         return functionCall(target, data, "Address: low-level call failed");
527     }
528 
529     /**
530      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
531      * `errorMessage` as a fallback revert reason when `target` reverts.
532      *
533      * _Available since v3.1._
534      */
535     function functionCall(
536         address target,
537         bytes memory data,
538         string memory errorMessage
539     ) internal returns (bytes memory) {
540         return functionCallWithValue(target, data, 0, errorMessage);
541     }
542 
543     /**
544      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
545      * but also transferring `value` wei to `target`.
546      *
547      * Requirements:
548      *
549      * - the calling contract must have an ETH balance of at least `value`.
550      * - the called Solidity function must be `payable`.
551      *
552      * _Available since v3.1._
553      */
554     function functionCallWithValue(
555         address target,
556         bytes memory data,
557         uint256 value
558     ) internal returns (bytes memory) {
559         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
560     }
561 
562     /**
563      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
564      * with `errorMessage` as a fallback revert reason when `target` reverts.
565      *
566      * _Available since v3.1._
567      */
568     function functionCallWithValue(
569         address target,
570         bytes memory data,
571         uint256 value,
572         string memory errorMessage
573     ) internal returns (bytes memory) {
574         require(address(this).balance >= value, "Address: insufficient balance for call");
575         require(isContract(target), "Address: call to non-contract");
576 
577         (bool success, bytes memory returndata) = target.call{value: value}(data);
578         return verifyCallResult(success, returndata, errorMessage);
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
583      * but performing a static call.
584      *
585      * _Available since v3.3._
586      */
587     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
588         return functionStaticCall(target, data, "Address: low-level static call failed");
589     }
590 
591     /**
592      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
593      * but performing a static call.
594      *
595      * _Available since v3.3._
596      */
597     function functionStaticCall(
598         address target,
599         bytes memory data,
600         string memory errorMessage
601     ) internal view returns (bytes memory) {
602         require(isContract(target), "Address: static call to non-contract");
603 
604         (bool success, bytes memory returndata) = target.staticcall(data);
605         return verifyCallResult(success, returndata, errorMessage);
606     }
607 
608     /**
609      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
610      * but performing a delegate call.
611      *
612      * _Available since v3.4._
613      */
614     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
615         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
616     }
617 
618     /**
619      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
620      * but performing a delegate call.
621      *
622      * _Available since v3.4._
623      */
624     function functionDelegateCall(
625         address target,
626         bytes memory data,
627         string memory errorMessage
628     ) internal returns (bytes memory) {
629         require(isContract(target), "Address: delegate call to non-contract");
630 
631         (bool success, bytes memory returndata) = target.delegatecall(data);
632         return verifyCallResult(success, returndata, errorMessage);
633     }
634 
635     /**
636      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
637      * revert reason using the provided one.
638      *
639      * _Available since v4.3._
640      */
641     function verifyCallResult(
642         bool success,
643         bytes memory returndata,
644         string memory errorMessage
645     ) internal pure returns (bytes memory) {
646         if (success) {
647             return returndata;
648         } else {
649             // Look for revert reason and bubble it up if present
650             if (returndata.length > 0) {
651                 // The easiest way to bubble the revert reason is using memory via assembly
652 
653                 assembly {
654                     let returndata_size := mload(returndata)
655                     revert(add(32, returndata), returndata_size)
656                 }
657             } else {
658                 revert(errorMessage);
659             }
660         }
661     }
662 }
663 
664 
665 
666 pragma solidity ^0.8.0;
667 
668 
669 /**
670  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
671  * @dev See https://eips.ethereum.org/EIPS/eip-721
672  */
673 interface IERC721Enumerable is IERC721 {
674     /**
675      * @dev Returns the total amount of tokens stored by the contract.
676      */
677     function totalSupply() external view returns (uint256);
678 
679     /**
680      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
681      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
682      */
683     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
684 
685     /**
686      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
687      * Use along with {totalSupply} to enumerate all tokens.
688      */
689     function tokenByIndex(uint256 index) external view returns (uint256);
690 }
691 
692 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
693 
694 
695 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
696 
697 pragma solidity ^0.8.0;
698 
699 
700 /**
701  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
702  * @dev See https://eips.ethereum.org/EIPS/eip-721
703  */
704 interface IERC721Metadata is IERC721 {
705     /**
706      * @dev Returns the token collection name.
707      */
708     function name() external view returns (string memory);
709 
710     /**
711      * @dev Returns the token collection symbol.
712      */
713     function symbol() external view returns (string memory);
714 
715     /**
716      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
717      */
718     function tokenURI(uint256 tokenId) external view returns (string memory);
719 }
720 
721 
722 pragma solidity ^0.8.0;
723 
724 
725 /**
726  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
727  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
728  *
729  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
730  *
731  * Does not support burning tokens to address(0).
732  *
733  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
734  */
735 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
736     using Address for address;
737     using Strings for uint256;
738 
739     struct TokenOwnership {
740         address addr;
741         uint64 startTimestamp;
742     }
743 
744     struct AddressData {
745         uint128 balance;
746         uint128 numberMinted;
747     }
748 
749     uint256 internal currentIndex = 0;
750 
751     uint256 internal immutable maxBatchSize;
752 
753     // Token name
754     string private _name;
755 
756     // Token symbol
757     string private _symbol;
758 
759     // Mapping from token ID to ownership details
760     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
761     mapping(uint256 => TokenOwnership) internal _ownerships;
762 
763     // Mapping owner address to address data
764     mapping(address => AddressData) private _addressData;
765 
766     // Mapping from token ID to approved address
767     mapping(uint256 => address) private _tokenApprovals;
768 
769     // Mapping from owner to operator approvals
770     mapping(address => mapping(address => bool)) private _operatorApprovals;
771 
772     /**
773      * @dev
774      * `maxBatchSize` refers to how much a minter can mint at a time.
775      */
776     constructor(
777         string memory name_,
778         string memory symbol_,
779         uint256 maxBatchSize_
780     ) {
781         require(maxBatchSize_ > 0, 'ERC721A: max batch size must be nonzero');
782         _name = name_;
783         _symbol = symbol_;
784         maxBatchSize = maxBatchSize_;
785     }
786 
787     /**
788      * @dev See {IERC721Enumerable-totalSupply}.
789      */
790     function totalSupply() public view override returns (uint256) {
791         return currentIndex;
792     }
793 
794     /**
795      * @dev See {IERC721Enumerable-tokenByIndex}.
796      */
797     function tokenByIndex(uint256 index) public view override returns (uint256) {
798         require(index < totalSupply(), 'ERC721A: global index out of bounds');
799         return index;
800     }
801 
802     /**
803      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
804      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
805      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
806      */
807     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
808         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
809         uint256 numMintedSoFar = totalSupply();
810         uint256 tokenIdsIdx = 0;
811         address currOwnershipAddr = address(0);
812         for (uint256 i = 0; i < numMintedSoFar; i++) {
813             TokenOwnership memory ownership = _ownerships[i];
814             if (ownership.addr != address(0)) {
815                 currOwnershipAddr = ownership.addr;
816             }
817             if (currOwnershipAddr == owner) {
818                 if (tokenIdsIdx == index) {
819                     return i;
820                 }
821                 tokenIdsIdx++;
822             }
823         }
824         revert('ERC721A: unable to get token of owner by index');
825     }
826 
827     /**
828      * @dev See {IERC165-supportsInterface}.
829      */
830     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
831         return
832             interfaceId == type(IERC721).interfaceId ||
833             interfaceId == type(IERC721Metadata).interfaceId ||
834             interfaceId == type(IERC721Enumerable).interfaceId ||
835             super.supportsInterface(interfaceId);
836     }
837 
838     /**
839      * @dev See {IERC721-balanceOf}.
840      */
841     function balanceOf(address owner) public view override returns (uint256) {
842         require(owner != address(0), 'ERC721A: balance query for the zero address');
843         return uint256(_addressData[owner].balance);
844     }
845 
846     function _numberMinted(address owner) internal view returns (uint256) {
847         require(owner != address(0), 'ERC721A: number minted query for the zero address');
848         return uint256(_addressData[owner].numberMinted);
849     }
850 
851     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
852         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
853 
854         uint256 lowestTokenToCheck;
855         if (tokenId >= maxBatchSize) {
856             lowestTokenToCheck = tokenId - maxBatchSize + 1;
857         }
858 
859         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
860             TokenOwnership memory ownership = _ownerships[curr];
861             if (ownership.addr != address(0)) {
862                 return ownership;
863             }
864         }
865 
866         revert('ERC721A: unable to determine the owner of token');
867     }
868 
869     /**
870      * @dev See {IERC721-ownerOf}.
871      */
872     function ownerOf(uint256 tokenId) public view override returns (address) {
873         return ownershipOf(tokenId).addr;
874     }
875 
876     /**
877      * @dev See {IERC721Metadata-name}.
878      */
879     function name() public view virtual override returns (string memory) {
880         return _name;
881     }
882 
883     /**
884      * @dev See {IERC721Metadata-symbol}.
885      */
886     function symbol() public view virtual override returns (string memory) {
887         return _symbol;
888     }
889 
890     /**
891      * @dev See {IERC721Metadata-tokenURI}.
892      */
893     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
894         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
895 
896         string memory baseURI = _baseURI();
897         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
898     }
899 
900     /**
901      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
902      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
903      * by default, can be overriden in child contracts.
904      */
905     function _baseURI() internal view virtual returns (string memory) {
906         return '';
907     }
908 
909     /**
910      * @dev See {IERC721-approve}.
911      */
912     function approve(address to, uint256 tokenId) public override {
913         address owner = ERC721A.ownerOf(tokenId);
914         require(to != owner, 'ERC721A: approval to current owner');
915 
916         require(
917             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
918             'ERC721A: approve caller is not owner nor approved for all'
919         );
920 
921         _approve(to, tokenId, owner);
922     }
923 
924     /**
925      * @dev See {IERC721-getApproved}.
926      */
927     function getApproved(uint256 tokenId) public view override returns (address) {
928         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
929 
930         return _tokenApprovals[tokenId];
931     }
932 
933     /**
934      * @dev See {IERC721-setApprovalForAll}.
935      */
936     function setApprovalForAll(address operator, bool approved) public override {
937         require(operator != _msgSender(), 'ERC721A: approve to caller');
938 
939         _operatorApprovals[_msgSender()][operator] = approved;
940         emit ApprovalForAll(_msgSender(), operator, approved);
941     }
942 
943     /**
944      * @dev See {IERC721-isApprovedForAll}.
945      */
946     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
947         return _operatorApprovals[owner][operator];
948     }
949 
950     /**
951      * @dev See {IERC721-transferFrom}.
952      */
953     function transferFrom(
954         address from,
955         address to,
956         uint256 tokenId
957     ) public override {
958         _transfer(from, to, tokenId);
959     }
960 
961     /**
962      * @dev See {IERC721-safeTransferFrom}.
963      */
964     function safeTransferFrom(
965         address from,
966         address to,
967         uint256 tokenId
968     ) public override {
969         safeTransferFrom(from, to, tokenId, '');
970     }
971 
972     /**
973      * @dev See {IERC721-safeTransferFrom}.
974      */
975     function safeTransferFrom(
976         address from,
977         address to,
978         uint256 tokenId,
979         bytes memory _data
980     ) public override {
981         _transfer(from, to, tokenId);
982         require(
983             _checkOnERC721Received(from, to, tokenId, _data),
984             'ERC721A: transfer to non ERC721Receiver implementer'
985         );
986     }
987 
988     /**
989      * @dev Returns whether `tokenId` exists.
990      *
991      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
992      *
993      * Tokens start existing when they are minted (`_mint`),
994      */
995     function _exists(uint256 tokenId) internal view returns (bool) {
996         return tokenId < currentIndex;
997     }
998 
999     function _safeMint(address to, uint256 quantity) internal {
1000         _safeMint(to, quantity, '');
1001     }
1002 
1003     /**
1004      * @dev Mints `quantity` tokens and transfers them to `to`.
1005      *
1006      * Requirements:
1007      *
1008      * - `to` cannot be the zero address.
1009      * - `quantity` cannot be larger than the max batch size.
1010      *
1011      * Emits a {Transfer} event.
1012      */
1013     function _safeMint(
1014         address to,
1015         uint256 quantity,
1016         bytes memory _data
1017     ) internal {
1018         uint256 startTokenId = currentIndex;
1019         require(to != address(0), 'ERC721A: mint to the zero address');
1020         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1021         require(!_exists(startTokenId), 'ERC721A: token already minted');
1022         require(quantity <= maxBatchSize, 'ERC721A: quantity to mint too high');
1023         require(quantity > 0, 'ERC721A: quantity must be greater 0');
1024 
1025         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1026 
1027         AddressData memory addressData = _addressData[to];
1028         _addressData[to] = AddressData(
1029             addressData.balance + uint128(quantity),
1030             addressData.numberMinted + uint128(quantity)
1031         );
1032         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1033 
1034         uint256 updatedIndex = startTokenId;
1035 
1036         for (uint256 i = 0; i < quantity; i++) {
1037             emit Transfer(address(0), to, updatedIndex);
1038             require(
1039                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1040                 'ERC721A: transfer to non ERC721Receiver implementer'
1041             );
1042             updatedIndex++;
1043         }
1044 
1045         currentIndex = updatedIndex;
1046         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1047     }
1048 
1049     /**
1050      * @dev Transfers `tokenId` from `from` to `to`.
1051      *
1052      * Requirements:
1053      *
1054      * - `to` cannot be the zero address.
1055      * - `tokenId` token must be owned by `from`.
1056      *
1057      * Emits a {Transfer} event.
1058      */
1059     function _transfer(
1060         address from,
1061         address to,
1062         uint256 tokenId
1063     ) private {
1064         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1065 
1066         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1067             getApproved(tokenId) == _msgSender() ||
1068             isApprovedForAll(prevOwnership.addr, _msgSender()));
1069 
1070         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1071 
1072         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1073         require(to != address(0), 'ERC721A: transfer to the zero address');
1074 
1075         _beforeTokenTransfers(from, to, tokenId, 1);
1076 
1077         // Clear approvals from the previous owner
1078         _approve(address(0), tokenId, prevOwnership.addr);
1079 
1080         // Underflow of the sender's balance is impossible because we check for
1081         // ownership above and the recipient's balance can't realistically overflow.
1082         unchecked {
1083             _addressData[from].balance -= 1;
1084             _addressData[to].balance += 1;
1085         }
1086 
1087         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1088 
1089         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1090         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1091         uint256 nextTokenId = tokenId + 1;
1092         if (_ownerships[nextTokenId].addr == address(0)) {
1093             if (_exists(nextTokenId)) {
1094                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1095             }
1096         }
1097 
1098         emit Transfer(from, to, tokenId);
1099         _afterTokenTransfers(from, to, tokenId, 1);
1100     }
1101 
1102     /**
1103      * @dev Approve `to` to operate on `tokenId`
1104      *
1105      * Emits a {Approval} event.
1106      */
1107     function _approve(
1108         address to,
1109         uint256 tokenId,
1110         address owner
1111     ) private {
1112         _tokenApprovals[tokenId] = to;
1113         emit Approval(owner, to, tokenId);
1114     }
1115 
1116     /**
1117      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1118      * The call is not executed if the target address is not a contract.
1119      *
1120      * @param from address representing the previous owner of the given token ID
1121      * @param to target address that will receive the tokens
1122      * @param tokenId uint256 ID of the token to be transferred
1123      * @param _data bytes optional data to send along with the call
1124      * @return bool whether the call correctly returned the expected magic value
1125      */
1126     function _checkOnERC721Received(
1127         address from,
1128         address to,
1129         uint256 tokenId,
1130         bytes memory _data
1131     ) private returns (bool) {
1132         if (to.isContract()) {
1133             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1134                 return retval == IERC721Receiver(to).onERC721Received.selector;
1135             } catch (bytes memory reason) {
1136                 if (reason.length == 0) {
1137                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1138                 } else {
1139                     assembly {
1140                         revert(add(32, reason), mload(reason))
1141                     }
1142                 }
1143             }
1144         } else {
1145             return true;
1146         }
1147     }
1148 
1149     /**
1150      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1151      *
1152      * startTokenId - the first token id to be transferred
1153      * quantity - the amount to be transferred
1154      *
1155      * Calling conditions:
1156      *
1157      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1158      * transferred to `to`.
1159      * - When `from` is zero, `tokenId` will be minted for `to`.
1160      */
1161     function _beforeTokenTransfers(
1162         address from,
1163         address to,
1164         uint256 startTokenId,
1165         uint256 quantity
1166     ) internal virtual {}
1167 
1168     /**
1169      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1170      * minting.
1171      *
1172      * startTokenId - the first token id to be transferred
1173      * quantity - the amount to be transferred
1174      *
1175      * Calling conditions:
1176      *
1177      * - when `from` and `to` are both non-zero.
1178      * - `from` and `to` are never both zero.
1179      */
1180     function _afterTokenTransfers(
1181         address from,
1182         address to,
1183         uint256 startTokenId,
1184         uint256 quantity
1185     ) internal virtual {}
1186 }
1187 
1188 
1189 
1190 
1191 pragma solidity ^0.8.0;
1192 
1193 contract DickButtVerse is ERC721A, Ownable {
1194   using Strings for uint256;
1195 
1196   string private uriPrefix = "";
1197   string private uriSuffix = ".json";
1198   string public hiddenMetadataUri;
1199   
1200   uint256 public price = 0 ether; // Free Mint!
1201   uint256 public maxSupply = 5352; 
1202   uint256 public maxMintAmountPerTx = 100; // 100 are for deployer mints (600), then will limited to 2 per transaction
1203   uint256 public nftPerAddressLimit = 2; // Max 2 per wallet allowed!
1204   
1205   bool public paused = true;
1206   bool public revealed = true;
1207   mapping(address => uint256) public addressMintedBalance;
1208 
1209 
1210   constructor() ERC721A("DickButtVerse", "3D=3B", maxMintAmountPerTx) {
1211     setHiddenMetadataUri("");
1212   }
1213 
1214   modifier mintCompliance(uint256 _mintAmount) {
1215       uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1216     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1217     require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1218     require(currentIndex + _mintAmount <= maxSupply, "Max supply exceeded!");
1219     _;
1220   }
1221 
1222   function wen(uint256 _mintAmount) public payable mintCompliance(_mintAmount)
1223    {
1224     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1225     require(!paused, "The contract is paused!");
1226     require(msg.value >= price * _mintAmount, "Insufficient funds!");
1227      require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1228     
1229     
1230     _safeMint(msg.sender, _mintAmount);
1231   }
1232 
1233   
1234 
1235   
1236 
1237   function Airdrop(address _to, uint256 _mintAmount) public mintCompliance(_mintAmount) onlyOwner {
1238     _safeMint(_to, _mintAmount);
1239   }
1240 
1241  
1242   function walletOfOwner(address _owner)
1243     public
1244     view
1245     returns (uint256[] memory)
1246   {
1247     uint256 ownerTokenCount = balanceOf(_owner);
1248     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1249     uint256 currentTokenId = 0;
1250     uint256 ownedTokenIndex = 0;
1251 
1252     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1253       address currentTokenOwner = ownerOf(currentTokenId);
1254 
1255       if (currentTokenOwner == _owner) {
1256         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1257 
1258         ownedTokenIndex++;
1259       }
1260 
1261       currentTokenId++;
1262     }
1263 
1264     return ownedTokenIds;
1265   }
1266 
1267   function tokenURI(uint256 _tokenId)
1268     public
1269     view
1270     virtual
1271     override
1272     returns (string memory)
1273   {
1274     require(
1275       _exists(_tokenId),
1276       "ERC721Metadata: URI query for nonexistent token"
1277     );
1278 
1279     if (revealed == false) {
1280       return hiddenMetadataUri;
1281     }
1282 
1283     string memory currentBaseURI = _baseURI();
1284     return bytes(currentBaseURI).length > 0
1285         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1286         : "";
1287   }
1288 
1289   function setRevealed(bool _state) public onlyOwner {
1290     revealed = _state;
1291   
1292   }
1293 
1294   function setPrice(uint256 _price) public onlyOwner {
1295     price = _price;
1296 
1297   }
1298  
1299   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1300     hiddenMetadataUri = _hiddenMetadataUri;
1301   }
1302 
1303   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1304     uriPrefix = _uriPrefix;
1305   }
1306 
1307   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1308     uriSuffix = _uriSuffix;
1309   }
1310 
1311   function setPaused(bool _state) public onlyOwner {
1312     paused = _state;
1313   }
1314 
1315   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1316       _safeMint(_receiver, _mintAmount);
1317   }
1318 
1319   function _baseURI() internal view virtual override returns (string memory) {
1320     return uriPrefix;
1321     
1322   }
1323 
1324     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1325     maxMintAmountPerTx = _maxMintAmountPerTx;
1326 
1327   }
1328 
1329     function setNftPerAddressLimit(uint256 _nftPerAddressLimit) public onlyOwner {
1330     nftPerAddressLimit = _nftPerAddressLimit;
1331 
1332   }
1333 
1334     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1335     maxSupply = _maxSupply;
1336 
1337   }
1338 
1339   function withdraw() public onlyOwner {
1340     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1341     require(os);
1342     
1343   }
1344   
1345 }