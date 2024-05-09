1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /*
5 ################################################################################
6 ################################################################################
7 ################################################################################
8 ########################&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&#######################
9 ########################&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&#######################
10 ########################&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&#######################
11 ########################&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&#######################
12 ########################(((((((((((((((((((((((((((((((((#######################
13 ########################(((((((((((((((((((((((((((((((((#######################
14 #######################%%%%%%%%...................%%%%%%%%######################
15 #####################%%%%%%%........................./%%%%%%####################
16 ###################%%%%%%...............................%%%%%%##################
17 ##################%%%%%*....        ......................%%%%%#################
18 ############%%%%%%%%%%.....   #####   ....... *####   .....%%%%%%%%%%###########
19 #########%%%%%%%%%%%%,.....  ##@@%##  ...... (##@@##   .....%%%%%%%%%%%%########
20 ########%%%%%%..%%%%%.......  ####   ........  ####   ......%%%%%../%%%%%#######
21 ########%%%%%...%%%%%...........................   .........%%%%%...#%%%%#######
22 ########%%%%%%..%%%%%.......................................%%%%%..%%%%%%#######
23 ##########%%%%%%%%%%%#................     ................,%%%%%%%%%%%%########
24 #############%%%%%%%%%.......        @     @        .......%%%%%%%%%############
25 ##################%%%%%%...                           ...%%%%%%#################
26 ###################%%%%%%/..                         ...%%%%%%##################
27 #####################%%%%%%%.....               @....%%%%%%%####################
28 #######################%%%%%%%%%.................%@%%%%%%%######################
29 ###########################%%%%%%%%%%%%%%%%%%%%%%%%%%%%#########################
30 ###############################%%%%%%%%%%%%%%%%%%%##############################
31 ################/(((((((////((((/((((((///(/(/(//(((((((///(((((/###############
32 ################(((/((/(/((//((///(/(/((///((//(((/((/((((//((///###############
33 ################//((/((///(((/(/(((///////(/(//////////(/(/(/(((/###############
34 ################/(//((/(/(((/(///(/((((((/(((/////////(//(//((//(###############
35 ################/(((////////(//(//((//(///(/(//////////(//((/(((/###############
36 ################(/(/((/(((((((/(////((/(/(/(///////////((((((/(//###############
37 */
38 // @title: ApesOnChain
39 // @author: MasterApe
40 //
41 // On chain PFP collection of 3.5K unique profile images with the following properties:
42 //   - a single Ethereum transaction created everything
43 //   - all metadata on chain
44 //   - all images on chain in svg format
45 //   - all created in the constraints of a single txn without need of any other txns to load additional data
46 //   - no use of other deployed contracts
47 //   - all 3.500 ApesOnChain are unique
48 //   - there are 7 traits with 171 values (including 3 traits of no hat, no clothes, and no earring)
49 //   - the traits have distribution and rarities interesting for collecting
50 //   - everything on chain can be used in other apps and collections in the future
51 // Do u wanna be an Ape On Chain? 
52 
53 
54 
55 /// [MIT License]
56 /// @title Base64
57 /// @notice Provides a function for encoding some bytes in base64
58 /// @author Brecht Devos <brecht@loopring.org>
59 library Base64 {
60     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
61 
62     /// @notice Encodes some bytes to the base64 representation
63     function encode(bytes memory data) internal pure returns (string memory) {
64         uint256 len = data.length;
65         if (len == 0) return "";
66 
67         // multiply by 4/3 rounded up
68         uint256 encodedLen = 4 * ((len + 2) / 3);
69 
70         // Add some extra buffer at the end
71         bytes memory result = new bytes(encodedLen + 32);
72         bytes memory table = TABLE;
73 
74         assembly {
75             let tablePtr := add(table, 1)
76             let resultPtr := add(result, 32)
77             for {
78                 let i := 0
79             } lt(i, len) {
80             } {
81                 i := add(i, 3)
82                 let input := and(mload(add(data, i)), 0xffffff)
83                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
84                 out := shl(8, out)
85                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
86                 out := shl(8, out)
87                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
88                 out := shl(8, out)
89                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
90                 out := shl(224, out)
91                 mstore(resultPtr, out)
92                 resultPtr := add(resultPtr, 4)
93             }
94             switch mod(len, 3)
95             case 1 {
96                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
97             }
98             case 2 {
99                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
100             }
101             mstore(result, encodedLen)
102         }
103         return string(result);
104     }
105 }
106 
107 /**
108  * @dev Interface of the ERC165 standard, as defined in the
109  * https://eips.ethereum.org/EIPS/eip-165[EIP].
110  *
111  * Implementers can declare support of contract interfaces, which can then be
112  * queried by others ({ERC165Checker}).
113  *
114  * For an implementation, see {ERC165}.
115  */
116 interface IERC165 {
117     /**
118      * @dev Returns true if this contract implements the interface defined by
119      * `interfaceId`. See the corresponding
120      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
121      * to learn more about how these ids are created.
122      *
123      * This function call must use less than 30 000 gas.
124      */
125     function supportsInterface(bytes4 interfaceId) external view returns (bool);
126 }
127 
128 /**
129  * @dev Required interface of an ERC721 compliant contract.
130  */
131 interface IERC721 is IERC165 {
132     /**
133      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
134      */
135     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
136 
137     /**
138      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
139      */
140     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
141 
142     /**
143      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
144      */
145     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
146 
147     /**
148      * @dev Returns the number of tokens in ``owner``'s account.
149      */
150     function balanceOf(address owner) external view returns (uint256 balance);
151 
152     /**
153      * @dev Returns the owner of the `tokenId` token.
154      *
155      * Requirements:
156      *
157      * - `tokenId` must exist.
158      */
159     function ownerOf(uint256 tokenId) external view returns (address owner);
160 
161     /**
162      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
163      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
164      *
165      * Requirements:
166      *
167      * - `from` cannot be the zero address.
168      * - `to` cannot be the zero address.
169      * - `tokenId` token must exist and be owned by `from`.
170      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
171      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
172      *
173      * Emits a {Transfer} event.
174      */
175     function safeTransferFrom(
176         address from,
177         address to,
178         uint256 tokenId
179     ) external;
180 
181     /**
182      * @dev Transfers `tokenId` token from `from` to `to`.
183      *
184      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
185      *
186      * Requirements:
187      *
188      * - `from` cannot be the zero address.
189      * - `to` cannot be the zero address.
190      * - `tokenId` token must be owned by `from`.
191      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
192      *
193      * Emits a {Transfer} event.
194      */
195     function transferFrom(
196         address from,
197         address to,
198         uint256 tokenId
199     ) external;
200 
201     /**
202      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
203      * The approval is cleared when the token is transferred.
204      *
205      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
206      *
207      * Requirements:
208      *
209      * - The caller must own the token or be an approved operator.
210      * - `tokenId` must exist.
211      *
212      * Emits an {Approval} event.
213      */
214     function approve(address to, uint256 tokenId) external;
215 
216     /**
217      * @dev Returns the account approved for `tokenId` token.
218      *
219      * Requirements:
220      *
221      * - `tokenId` must exist.
222      */
223     function getApproved(uint256 tokenId) external view returns (address operator);
224 
225     /**
226      * @dev Approve or remove `operator` as an operator for the caller.
227      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
228      *
229      * Requirements:
230      *
231      * - The `operator` cannot be the caller.
232      *
233      * Emits an {ApprovalForAll} event.
234      */
235     function setApprovalForAll(address operator, bool _approved) external;
236 
237     /**
238      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
239      *
240      * See {setApprovalForAll}
241      */
242     function isApprovedForAll(address owner, address operator) external view returns (bool);
243 
244     /**
245      * @dev Safely transfers `tokenId` token from `from` to `to`.
246      *
247      * Requirements:
248      *
249      * - `from` cannot be the zero address.
250      * - `to` cannot be the zero address.
251      * - `tokenId` token must exist and be owned by `from`.
252      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
253      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
254      *
255      * Emits a {Transfer} event.
256      */
257     function safeTransferFrom(
258         address from,
259         address to,
260         uint256 tokenId,
261         bytes calldata data
262     ) external;
263 }
264 
265 /**
266  * @dev String operations.
267  */
268 library Strings {
269     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
270 
271     /**
272      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
273      */
274     function toString(uint256 value) internal pure returns (string memory) {
275         // Inspired by OraclizeAPI's implementation - MIT licence
276         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
277 
278         if (value == 0) {
279             return "0";
280         }
281         uint256 temp = value;
282         uint256 digits;
283         while (temp != 0) {
284             digits++;
285             temp /= 10;
286         }
287         bytes memory buffer = new bytes(digits);
288         while (value != 0) {
289             digits -= 1;
290             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
291             value /= 10;
292         }
293         return string(buffer);
294     }
295 
296     /**
297      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
298      */
299     function toHexString(uint256 value) internal pure returns (string memory) {
300         if (value == 0) {
301             return "0x00";
302         }
303         uint256 temp = value;
304         uint256 length = 0;
305         while (temp != 0) {
306             length++;
307             temp >>= 8;
308         }
309         return toHexString(value, length);
310     }
311 
312     /**
313      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
314      */
315     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
316         bytes memory buffer = new bytes(2 * length + 2);
317         buffer[0] = "0";
318         buffer[1] = "x";
319         for (uint256 i = 2 * length + 1; i > 1; --i) {
320             buffer[i] = _HEX_SYMBOLS[value & 0xf];
321             value >>= 4;
322         }
323         require(value == 0, "Strings: hex length insufficient");
324         return string(buffer);
325     }
326 }
327 
328 /*
329  * @dev Provides information about the current execution context, including the
330  * sender of the transaction and its data. While these are generally available
331  * via msg.sender and msg.data, they should not be accessed in such a direct
332  * manner, since when dealing with meta-transactions the account sending and
333  * paying for execution may not be the actual sender (as far as an application
334  * is concerned).
335  *
336  * This contract is only required for intermediate, library-like contracts.
337  */
338 abstract contract Context {
339     function _msgSender() internal view virtual returns (address) {
340         return msg.sender;
341     }
342 
343     function _msgData() internal view virtual returns (bytes calldata) {
344         return msg.data;
345     }
346 }
347 
348 /**
349  * @dev Contract module which provides a basic access control mechanism, where
350  * there is an account (an owner) that can be granted exclusive access to
351  * specific functions.
352  *
353  * By default, the owner account will be the one that deploys the contract. This
354  * can later be changed with {transferOwnership}.
355  *
356  * This module is used through inheritance. It will make available the modifier
357  * `onlyOwner`, which can be applied to your functions to restrict their use to
358  * the owner.
359  */
360 abstract contract Ownable is Context {
361     address private _owner;
362 
363     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
364 
365     /**
366      * @dev Initializes the contract setting the deployer as the initial owner.
367      */
368     constructor() {
369         _setOwner(_msgSender());
370     }
371 
372     /**
373      * @dev Returns the address of the current owner.
374      */
375     function owner() public view virtual returns (address) {
376         return _owner;
377     }
378 
379     /**
380      * @dev Throws if called by any account other than the owner.
381      */
382     modifier onlyOwner() {
383         require(owner() == _msgSender(), "Ownable: caller is not the owner");
384         _;
385     }
386 
387     /**
388      * @dev Leaves the contract without owner. It will not be possible to call
389      * `onlyOwner` functions anymore. Can only be called by the current owner.
390      *
391      * NOTE: Renouncing ownership will leave the contract without an owner,
392      * thereby removing any functionality that is only available to the owner.
393      */
394     function renounceOwnership() public virtual onlyOwner {
395         _setOwner(address(0));
396     }
397 
398     /**
399      * @dev Transfers ownership of the contract to a new account (`newOwner`).
400      * Can only be called by the current owner.
401      */
402     function transferOwnership(address newOwner) public virtual onlyOwner {
403         require(newOwner != address(0), "Ownable: new owner is the zero address");
404         _setOwner(newOwner);
405     }
406 
407     function _setOwner(address newOwner) private {
408         address oldOwner = _owner;
409         _owner = newOwner;
410         emit OwnershipTransferred(oldOwner, newOwner);
411     }
412 }
413 
414 /**
415  * @dev Contract module that helps prevent reentrant calls to a function.
416  *
417  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
418  * available, which can be applied to functions to make sure there are no nested
419  * (reentrant) calls to them.
420  *
421  * Note that because there is a single `nonReentrant` guard, functions marked as
422  * `nonReentrant` may not call one another. This can be worked around by making
423  * those functions `private`, and then adding `external` `nonReentrant` entry
424  * points to them.
425  *
426  * TIP: If you would like to learn more about reentrancy and alternative ways
427  * to protect against it, check out our blog post
428  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
429  */
430 abstract contract ReentrancyGuard {
431     // Booleans are more expensive than uint256 or any type that takes up a full
432     // word because each write operation emits an extra SLOAD to first read the
433     // slot's contents, replace the bits taken up by the boolean, and then write
434     // back. This is the compiler's defense against contract upgrades and
435     // pointer aliasing, and it cannot be disabled.
436 
437     // The values being non-zero value makes deployment a bit more expensive,
438     // but in exchange the refund on every call to nonReentrant will be lower in
439     // amount. Since refunds are capped to a percentage of the total
440     // transaction's gas, it is best to keep them low in cases like this one, to
441     // increase the likelihood of the full refund coming into effect.
442     uint256 private constant _NOT_ENTERED = 1;
443     uint256 private constant _ENTERED = 2;
444 
445     uint256 private _status;
446 
447     constructor() {
448         _status = _NOT_ENTERED;
449     }
450 
451     /**
452      * @dev Prevents a contract from calling itself, directly or indirectly.
453      * Calling a `nonReentrant` function from another `nonReentrant`
454      * function is not supported. It is possible to prevent this from happening
455      * by making the `nonReentrant` function external, and make it call a
456      * `private` function that does the actual work.
457      */
458     modifier nonReentrant() {
459         // On the first call to nonReentrant, _notEntered will be true
460         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
461 
462         // Any calls to nonReentrant after this point will fail
463         _status = _ENTERED;
464 
465         _;
466 
467         // By storing the original value once again, a refund is triggered (see
468         // https://eips.ethereum.org/EIPS/eip-2200)
469         _status = _NOT_ENTERED;
470     }
471 }
472 
473 /**
474  * @title ERC721 token receiver interface
475  * @dev Interface for any contract that wants to support safeTransfers
476  * from ERC721 asset contracts.
477  */
478 interface IERC721Receiver {
479     /**
480      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
481      * by `operator` from `from`, this function is called.
482      *
483      * It must return its Solidity selector to confirm the token transfer.
484      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
485      *
486      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
487      */
488     function onERC721Received(
489         address operator,
490         address from,
491         uint256 tokenId,
492         bytes calldata data
493     ) external returns (bytes4);
494 }
495 
496 /**
497  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
498  * @dev See https://eips.ethereum.org/EIPS/eip-721
499  */
500 interface IERC721Metadata is IERC721 {
501     /**
502      * @dev Returns the token collection name.
503      */
504     function name() external view returns (string memory);
505 
506     /**
507      * @dev Returns the token collection symbol.
508      */
509     function symbol() external view returns (string memory);
510 
511     /**
512      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
513      */
514     function tokenURI(uint256 tokenId) external view returns (string memory);
515 }
516 
517 /**
518  * @dev Collection of functions related to the address type
519  */
520 library Address {
521     /**
522      * @dev Returns true if `account` is a contract.
523      *
524      * [IMPORTANT]
525      * ====
526      * It is unsafe to assume that an address for which this function returns
527      * false is an externally-owned account (EOA) and not a contract.
528      *
529      * Among others, `isContract` will return false for the following
530      * types of addresses:
531      *
532      *  - an externally-owned account
533      *  - a contract in construction
534      *  - an address where a contract will be created
535      *  - an address where a contract lived, but was destroyed
536      * ====
537      */
538     function isContract(address account) internal view returns (bool) {
539         // This method relies on extcodesize, which returns 0 for contracts in
540         // construction, since the code is only stored at the end of the
541         // constructor execution.
542 
543         uint256 size;
544         assembly {
545             size := extcodesize(account)
546         }
547         return size > 0;
548     }
549 
550     /**
551      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
552      * `recipient`, forwarding all available gas and reverting on errors.
553      *
554      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
555      * of certain opcodes, possibly making contracts go over the 2300 gas limit
556      * imposed by `transfer`, making them unable to receive funds via
557      * `transfer`. {sendValue} removes this limitation.
558      *
559      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
560      *
561      * IMPORTANT: because control is transferred to `recipient`, care must be
562      * taken to not create reentrancy vulnerabilities. Consider using
563      * {ReentrancyGuard} or the
564      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
565      */
566     function sendValue(address payable recipient, uint256 amount) internal {
567         require(address(this).balance >= amount, "Address: insufficient balance");
568 
569         (bool success, ) = recipient.call{value: amount}("");
570         require(success, "Address: unable to send value, recipient may have reverted");
571     }
572 
573     /**
574      * @dev Performs a Solidity function call using a low level `call`. A
575      * plain `call` is an unsafe replacement for a function call: use this
576      * function instead.
577      *
578      * If `target` reverts with a revert reason, it is bubbled up by this
579      * function (like regular Solidity function calls).
580      *
581      * Returns the raw returned data. To convert to the expected return value,
582      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
583      *
584      * Requirements:
585      *
586      * - `target` must be a contract.
587      * - calling `target` with `data` must not revert.
588      *
589      * _Available since v3.1._
590      */
591     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
592         return functionCall(target, data, "Address: low-level call failed");
593     }
594 
595     /**
596      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
597      * `errorMessage` as a fallback revert reason when `target` reverts.
598      *
599      * _Available since v3.1._
600      */
601     function functionCall(
602         address target,
603         bytes memory data,
604         string memory errorMessage
605     ) internal returns (bytes memory) {
606         return functionCallWithValue(target, data, 0, errorMessage);
607     }
608 
609     /**
610      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
611      * but also transferring `value` wei to `target`.
612      *
613      * Requirements:
614      *
615      * - the calling contract must have an ETH balance of at least `value`.
616      * - the called Solidity function must be `payable`.
617      *
618      * _Available since v3.1._
619      */
620     function functionCallWithValue(
621         address target,
622         bytes memory data,
623         uint256 value
624     ) internal returns (bytes memory) {
625         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
626     }
627 
628     /**
629      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
630      * with `errorMessage` as a fallback revert reason when `target` reverts.
631      *
632      * _Available since v3.1._
633      */
634     function functionCallWithValue(
635         address target,
636         bytes memory data,
637         uint256 value,
638         string memory errorMessage
639     ) internal returns (bytes memory) {
640         require(address(this).balance >= value, "Address: insufficient balance for call");
641         require(isContract(target), "Address: call to non-contract");
642 
643         (bool success, bytes memory returndata) = target.call{value: value}(data);
644         return _verifyCallResult(success, returndata, errorMessage);
645     }
646 
647     /**
648      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
649      * but performing a static call.
650      *
651      * _Available since v3.3._
652      */
653     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
654         return functionStaticCall(target, data, "Address: low-level static call failed");
655     }
656 
657     /**
658      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
659      * but performing a static call.
660      *
661      * _Available since v3.3._
662      */
663     function functionStaticCall(
664         address target,
665         bytes memory data,
666         string memory errorMessage
667     ) internal view returns (bytes memory) {
668         require(isContract(target), "Address: static call to non-contract");
669 
670         (bool success, bytes memory returndata) = target.staticcall(data);
671         return _verifyCallResult(success, returndata, errorMessage);
672     }
673 
674     /**
675      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
676      * but performing a delegate call.
677      *
678      * _Available since v3.4._
679      */
680     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
681         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
682     }
683 
684     /**
685      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
686      * but performing a delegate call.
687      *
688      * _Available since v3.4._
689      */
690     function functionDelegateCall(
691         address target,
692         bytes memory data,
693         string memory errorMessage
694     ) internal returns (bytes memory) {
695         require(isContract(target), "Address: delegate call to non-contract");
696 
697         (bool success, bytes memory returndata) = target.delegatecall(data);
698         return _verifyCallResult(success, returndata, errorMessage);
699     }
700 
701     function _verifyCallResult(
702         bool success,
703         bytes memory returndata,
704         string memory errorMessage
705     ) private pure returns (bytes memory) {
706         if (success) {
707             return returndata;
708         } else {
709             // Look for revert reason and bubble it up if present
710             if (returndata.length > 0) {
711                 // The easiest way to bubble the revert reason is using memory via assembly
712 
713                 assembly {
714                     let returndata_size := mload(returndata)
715                     revert(add(32, returndata), returndata_size)
716                 }
717             } else {
718                 revert(errorMessage);
719             }
720         }
721     }
722 }
723 
724 /**
725  * @dev Implementation of the {IERC165} interface.
726  *
727  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
728  * for the additional interface id that will be supported. For example:
729  *
730  * ```solidity
731  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
732  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
733  * }
734  * ```
735  *
736  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
737  */
738 abstract contract ERC165 is IERC165 {
739     /**
740      * @dev See {IERC165-supportsInterface}.
741      */
742     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
743         return interfaceId == type(IERC165).interfaceId;
744     }
745 }
746 
747 /**
748  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
749  * the Metadata extension, but not including the Enumerable extension, which is available separately as
750  * {ERC721Enumerable}.
751  */
752 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
753     using Address for address;
754     using Strings for uint256;
755 
756     // Token name
757     string private _name;
758 
759     // Token symbol
760     string private _symbol;
761 
762     // Mapping from token ID to owner address
763     mapping(uint256 => address) private _owners;
764 
765     // Mapping owner address to token count
766     mapping(address => uint256) private _balances;
767 
768     // Mapping from token ID to approved address
769     mapping(uint256 => address) private _tokenApprovals;
770 
771     // Mapping from owner to operator approvals
772     mapping(address => mapping(address => bool)) private _operatorApprovals;
773 
774     /**
775      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
776      */
777     constructor(string memory name_, string memory symbol_) {
778         _name = name_;
779         _symbol = symbol_;
780     }
781 
782     /**
783      * @dev See {IERC165-supportsInterface}.
784      */
785     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
786         return
787             interfaceId == type(IERC721).interfaceId ||
788             interfaceId == type(IERC721Metadata).interfaceId ||
789             super.supportsInterface(interfaceId);
790     }
791 
792     /**
793      * @dev See {IERC721-balanceOf}.
794      */
795     function balanceOf(address owner) public view virtual override returns (uint256) {
796         require(owner != address(0), "ERC721: balance query for the zero address");
797         return _balances[owner];
798     }
799 
800     /**
801      * @dev See {IERC721-ownerOf}.
802      */
803     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
804         address owner = _owners[tokenId];
805         require(owner != address(0), "ERC721: owner query for nonexistent token");
806         return owner;
807     }
808 
809     /**
810      * @dev See {IERC721Metadata-name}.
811      */
812     function name() public view virtual override returns (string memory) {
813         return _name;
814     }
815 
816     /**
817      * @dev See {IERC721Metadata-symbol}.
818      */
819     function symbol() public view virtual override returns (string memory) {
820         return _symbol;
821     }
822 
823     /**
824      * @dev See {IERC721Metadata-tokenURI}.
825      */
826     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
827         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
828 
829         string memory baseURI = _baseURI();
830         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
831     }
832 
833     /**
834      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
835      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
836      * by default, can be overriden in child contracts.
837      */
838     function _baseURI() internal view virtual returns (string memory) {
839         return "";
840     }
841 
842     /**
843      * @dev See {IERC721-approve}.
844      */
845     function approve(address to, uint256 tokenId) public virtual override {
846         address owner = ERC721.ownerOf(tokenId);
847         require(to != owner, "ERC721: approval to current owner");
848 
849         require(
850             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
851             "ERC721: approve caller is not owner nor approved for all"
852         );
853 
854         _approve(to, tokenId);
855     }
856 
857     /**
858      * @dev See {IERC721-getApproved}.
859      */
860     function getApproved(uint256 tokenId) public view virtual override returns (address) {
861         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
862 
863         return _tokenApprovals[tokenId];
864     }
865 
866     /**
867      * @dev See {IERC721-setApprovalForAll}.
868      */
869     function setApprovalForAll(address operator, bool approved) public virtual override {
870         require(operator != _msgSender(), "ERC721: approve to caller");
871 
872         _operatorApprovals[_msgSender()][operator] = approved;
873         emit ApprovalForAll(_msgSender(), operator, approved);
874     }
875 
876     /**
877      * @dev See {IERC721-isApprovedForAll}.
878      */
879     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
880         return _operatorApprovals[owner][operator];
881     }
882 
883     /**
884      * @dev See {IERC721-transferFrom}.
885      */
886     function transferFrom(
887         address from,
888         address to,
889         uint256 tokenId
890     ) public virtual override {
891         //solhint-disable-next-line max-line-length
892         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
893 
894         _transfer(from, to, tokenId);
895     }
896 
897     /**
898      * @dev See {IERC721-safeTransferFrom}.
899      */
900     function safeTransferFrom(
901         address from,
902         address to,
903         uint256 tokenId
904     ) public virtual override {
905         safeTransferFrom(from, to, tokenId, "");
906     }
907 
908     /**
909      * @dev See {IERC721-safeTransferFrom}.
910      */
911     function safeTransferFrom(
912         address from,
913         address to,
914         uint256 tokenId,
915         bytes memory _data
916     ) public virtual override {
917         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
918         _safeTransfer(from, to, tokenId, _data);
919     }
920 
921     /**
922      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
923      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
924      *
925      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
926      *
927      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
928      * implement alternative mechanisms to perform token transfer, such as signature-based.
929      *
930      * Requirements:
931      *
932      * - `from` cannot be the zero address.
933      * - `to` cannot be the zero address.
934      * - `tokenId` token must exist and be owned by `from`.
935      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
936      *
937      * Emits a {Transfer} event.
938      */
939     function _safeTransfer(
940         address from,
941         address to,
942         uint256 tokenId,
943         bytes memory _data
944     ) internal virtual {
945         _transfer(from, to, tokenId);
946         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
947     }
948 
949     /**
950      * @dev Returns whether `tokenId` exists.
951      *
952      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
953      *
954      * Tokens start existing when they are minted (`_mint`),
955      * and stop existing when they are burned (`_burn`).
956      */
957     function _exists(uint256 tokenId) internal view virtual returns (bool) {
958         return _owners[tokenId] != address(0);
959     }
960 
961     /**
962      * @dev Returns whether `spender` is allowed to manage `tokenId`.
963      *
964      * Requirements:
965      *
966      * - `tokenId` must exist.
967      */
968     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
969         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
970         address owner = ERC721.ownerOf(tokenId);
971         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
972     }
973 
974     /**
975      * @dev Safely mints `tokenId` and transfers it to `to`.
976      *
977      * Requirements:
978      *
979      * - `tokenId` must not exist.
980      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
981      *
982      * Emits a {Transfer} event.
983      */
984     function _safeMint(address to, uint256 tokenId) internal virtual {
985         _safeMint(to, tokenId, "");
986     }
987 
988     /**
989      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
990      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
991      */
992     function _safeMint(
993         address to,
994         uint256 tokenId,
995         bytes memory _data
996     ) internal virtual {
997         _mint(to, tokenId);
998         require(
999             _checkOnERC721Received(address(0), to, tokenId, _data),
1000             "ERC721: transfer to non ERC721Receiver implementer"
1001         );
1002     }
1003 
1004     /**
1005      * @dev Mints `tokenId` and transfers it to `to`.
1006      *
1007      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1008      *
1009      * Requirements:
1010      *
1011      * - `tokenId` must not exist.
1012      * - `to` cannot be the zero address.
1013      *
1014      * Emits a {Transfer} event.
1015      */
1016     function _mint(address to, uint256 tokenId) internal virtual {
1017         require(to != address(0), "ERC721: mint to the zero address");
1018         require(!_exists(tokenId), "ERC721: token already minted");
1019 
1020         _beforeTokenTransfer(address(0), to, tokenId);
1021 
1022         _balances[to] += 1;
1023         _owners[tokenId] = to;
1024 
1025         emit Transfer(address(0), to, tokenId);
1026     }
1027 
1028     /**
1029      * @dev Destroys `tokenId`.
1030      * The approval is cleared when the token is burned.
1031      *
1032      * Requirements:
1033      *
1034      * - `tokenId` must exist.
1035      *
1036      * Emits a {Transfer} event.
1037      */
1038     function _burn(uint256 tokenId) internal virtual {
1039         address owner = ERC721.ownerOf(tokenId);
1040 
1041         _beforeTokenTransfer(owner, address(0), tokenId);
1042 
1043         // Clear approvals
1044         _approve(address(0), tokenId);
1045 
1046         _balances[owner] -= 1;
1047         delete _owners[tokenId];
1048 
1049         emit Transfer(owner, address(0), tokenId);
1050     }
1051 
1052     /**
1053      * @dev Transfers `tokenId` from `from` to `to`.
1054      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1055      *
1056      * Requirements:
1057      *
1058      * - `to` cannot be the zero address.
1059      * - `tokenId` token must be owned by `from`.
1060      *
1061      * Emits a {Transfer} event.
1062      */
1063     function _transfer(
1064         address from,
1065         address to,
1066         uint256 tokenId
1067     ) internal virtual {
1068         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1069         require(to != address(0), "ERC721: transfer to the zero address");
1070 
1071         _beforeTokenTransfer(from, to, tokenId);
1072 
1073         // Clear approvals from the previous owner
1074         _approve(address(0), tokenId);
1075 
1076         _balances[from] -= 1;
1077         _balances[to] += 1;
1078         _owners[tokenId] = to;
1079 
1080         emit Transfer(from, to, tokenId);
1081     }
1082 
1083     /**
1084      * @dev Approve `to` to operate on `tokenId`
1085      *
1086      * Emits a {Approval} event.
1087      */
1088     function _approve(address to, uint256 tokenId) internal virtual {
1089         _tokenApprovals[tokenId] = to;
1090         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
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
1114                     revert("ERC721: transfer to non ERC721Receiver implementer");
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
1127      * @dev Hook that is called before any token transfer. This includes minting
1128      * and burning.
1129      *
1130      * Calling conditions:
1131      *
1132      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1133      * transferred to `to`.
1134      * - When `from` is zero, `tokenId` will be minted for `to`.
1135      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1136      * - `from` and `to` are never both zero.
1137      *
1138      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1139      */
1140     function _beforeTokenTransfer(
1141         address from,
1142         address to,
1143         uint256 tokenId
1144     ) internal virtual {}
1145 }
1146 
1147 /**
1148  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1149  * @dev See https://eips.ethereum.org/EIPS/eip-721
1150  */
1151 interface IERC721Enumerable is IERC721 {
1152     /**
1153      * @dev Returns the total amount of tokens stored by the contract.
1154      */
1155     function totalSupply() external view returns (uint256);
1156 
1157     /**
1158      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1159      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1160      */
1161     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1162 
1163     /**
1164      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1165      * Use along with {totalSupply} to enumerate all tokens.
1166      */
1167     function tokenByIndex(uint256 index) external view returns (uint256);
1168 }
1169 
1170 /**
1171  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1172  * enumerability of all the token ids in the contract as well as all token ids owned by each
1173  * account.
1174  */
1175 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1176     // Mapping from owner to list of owned token IDs
1177     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1178 
1179     // Mapping from token ID to index of the owner tokens list
1180     mapping(uint256 => uint256) private _ownedTokensIndex;
1181 
1182     // Array with all token ids, used for enumeration
1183     uint256[] private _allTokens;
1184 
1185     // Mapping from token id to position in the allTokens array
1186     mapping(uint256 => uint256) private _allTokensIndex;
1187 
1188     /**
1189      * @dev See {IERC165-supportsInterface}.
1190      */
1191     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1192         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1193     }
1194 
1195     /**
1196      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1197      */
1198     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1199         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1200         return _ownedTokens[owner][index];
1201     }
1202 
1203     /**
1204      * @dev See {IERC721Enumerable-totalSupply}.
1205      */
1206     function totalSupply() public view virtual override returns (uint256) {
1207         return _allTokens.length;
1208     }
1209 
1210     /**
1211      * @dev See {IERC721Enumerable-tokenByIndex}.
1212      */
1213     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1214         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1215         return _allTokens[index];
1216     }
1217 
1218     /**
1219      * @dev Hook that is called before any token transfer. This includes minting
1220      * and burning.
1221      *
1222      * Calling conditions:
1223      *
1224      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1225      * transferred to `to`.
1226      * - When `from` is zero, `tokenId` will be minted for `to`.
1227      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1228      * - `from` cannot be the zero address.
1229      * - `to` cannot be the zero address.
1230      *
1231      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1232      */
1233     function _beforeTokenTransfer(
1234         address from,
1235         address to,
1236         uint256 tokenId
1237     ) internal virtual override {
1238         super._beforeTokenTransfer(from, to, tokenId);
1239 
1240         if (from == address(0)) {
1241             _addTokenToAllTokensEnumeration(tokenId);
1242         } else if (from != to) {
1243             _removeTokenFromOwnerEnumeration(from, tokenId);
1244         }
1245         if (to == address(0)) {
1246             _removeTokenFromAllTokensEnumeration(tokenId);
1247         } else if (to != from) {
1248             _addTokenToOwnerEnumeration(to, tokenId);
1249         }
1250     }
1251 
1252     /**
1253      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1254      * @param to address representing the new owner of the given token ID
1255      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1256      */
1257     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1258         uint256 length = ERC721.balanceOf(to);
1259         _ownedTokens[to][length] = tokenId;
1260         _ownedTokensIndex[tokenId] = length;
1261     }
1262 
1263     /**
1264      * @dev Private function to add a token to this extension's token tracking data structures.
1265      * @param tokenId uint256 ID of the token to be added to the tokens list
1266      */
1267     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1268         _allTokensIndex[tokenId] = _allTokens.length;
1269         _allTokens.push(tokenId);
1270     }
1271 
1272     /**
1273      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1274      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1275      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1276      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1277      * @param from address representing the previous owner of the given token ID
1278      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1279      */
1280     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1281         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1282         // then delete the last slot (swap and pop).
1283 
1284         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1285         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1286 
1287         // When the token to delete is the last token, the swap operation is unnecessary
1288         if (tokenIndex != lastTokenIndex) {
1289             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1290 
1291             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1292             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1293         }
1294 
1295         // This also deletes the contents at the last position of the array
1296         delete _ownedTokensIndex[tokenId];
1297         delete _ownedTokens[from][lastTokenIndex];
1298     }
1299 
1300     /**
1301      * @dev Private function to remove a token from this extension's token tracking data structures.
1302      * This has O(1) time complexity, but alters the order of the _allTokens array.
1303      * @param tokenId uint256 ID of the token to be removed from the tokens list
1304      */
1305     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1306         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1307         // then delete the last slot (swap and pop).
1308 
1309         uint256 lastTokenIndex = _allTokens.length - 1;
1310         uint256 tokenIndex = _allTokensIndex[tokenId];
1311 
1312         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1313         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1314         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1315         uint256 lastTokenId = _allTokens[lastTokenIndex];
1316 
1317         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1318         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1319 
1320         // This also deletes the contents at the last position of the array
1321         delete _allTokensIndex[tokenId];
1322         _allTokens.pop();
1323     }
1324 }
1325 
1326 // Bring on the ApesOnChain!
1327 contract ApesOnChain is ERC721Enumerable, ReentrancyGuard, Ownable {
1328   using Strings for uint256;
1329 
1330   uint256 public constant maxSupply = 3500;
1331   uint256 public numClaimed = 0;
1332   string[] private background = ["1eb","dda","e92","656","663","9de","367","ccc"]; // only trait that is uniform, no need for rarity weights
1333   string[] private fur1 = ["444","532","653","a71","ffc","ca9","f89","777","049","901","fc5","ffe","574","bcc","d04","222","889","7f9","fd1"];
1334   string[] private fur2 = ["344","653","653","653","110","653","653","653","653","653","344","653","711","110","799","555","8a8","32f","110"];
1335   uint8[] private fur_w =[249, 246, 223, 141, 116, 114, 93, 90, 89, 86, 74, 28, 55, 48, 39, 32, 72, 14, 8];
1336   string[] private eyes = ["888","0a0","653","653","be7","abe","0a0","653","888","be7","cef","abe","0a0","653","888","be7","cef","abe","0a0","abe","888","be7","cef"];
1337   uint8[] private eyes_w = [68, 121, 107, 101, 33, 78, 70, 245, 62, 58, 56, 51, 50, 48, 44, 38, 35, 79, 31, 22, 15, 10, 7];
1338   string[] private mouth = ["bcc","049","f89","777","ffc","901","653","d04","fd1","ffc","bcc","f89","777","049","049","901","901","bcc","653","d04","ffc","f89","bcc","049","fd1","f89","777","bcc","d04","049","ffc","901","fd1"];
1339   uint8[] private mouth_w = [252, 172, 80, 10, 27, 49, 37, 33, 31, 30, 28, 56, 26, 23, 22, 18, 15, 14, 13, 12, 11, 79, 10, 10, 9, 8, 7, 7, 6, 5, 5, 4, 3];
1340   string[] private earring = ["999","fe7","999","999","fe7","bdd"];
1341   uint8[] private earring_w = [251, 32, 29, 17, 16, 8, 5];
1342   string[] private clothes1 = ["222","f00","222","f00","f00","f00","90f","f00","90f","00f","00f","00f","00f","00f","00f","00f","222","00f","f0f","222","f0f","f0f","f0f","f0f","f0f","f0f","f0f","f80","f80","f80","f80","f80","f00","f80","f80","f80","90f","90f","00f","90f","00f","90f","222"];
1343   string[] private clothes2 = ["ddd","00f","f00","f0f","f80","ddd","f48","0f0","ff0","f0f","00d","f0f","f80","90f","f48","0f0","ddd","ff0","f00","653","00f","d0d","f80","90f","f48","0f0","ff0","f00","f0f","00f","d60","f48","ddd","90f","0f0","ff0","f00","00f","fd1","f0f","f80","70d","fd1"];
1344   uint8[] private clothes_w = [251, 55, 31, 43, 38, 37, 34, 33, 32, 31, 31, 31, 45, 45, 30, 30, 29, 29, 28, 27, 27, 27, 26, 25, 24, 22, 21, 20, 19, 19, 19, 19, 19, 19, 18, 17, 16, 15, 14, 13, 11, 9, 8, 6];
1345   string[] private hat1 = ["ff0","f80","f00","f00","90f","f80","f00","00f","00f","00f","00f","00f","00f","00f","f00","f00","f0f","f0f","f0f","f00","f00","f0f","f80","f80","f80","f80","22d","f80","f00","f80","90f","f48","22d","90f","90f","ff0",""];
1346   string[] private hat2 = ["0f0","00f","f80","ff0","f80","f0f","f48","f00","0f0","00f","f80","ff0","90f","f80","000","f00","0f0","00f","f80","000","90f","f0f","90f","f80","00f","f80","ff0","90f","f00","f0f","f00","000","000","0f0","00f","f48",""];  
1347   uint8[] private hat_w = [36, 64, 47, 42, 39, 38, 251, 35, 34, 34, 33, 29, 28, 26, 26, 25, 25, 25, 22, 21, 20, 20, 18, 17, 17, 15, 14, 14, 13, 13, 12, 12, 12, 10, 9, 8, 7];
1348   string[] private z = ['<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 500 500"><rect x="0" y="0" width="500" height="500" style="fill:#',
1349     '"/><rect width="300" height="120" x="99" y="400" style="fill:#', '"/><circle cx="190" cy="470" r="5" style="fill:#', '"/><circle cx="310" cy="470" r="5" style="fill:#',
1350     '"/><circle cx="100" cy="250" r="50" style="fill:#', '"/><circle cx="100" cy="250" r="20" style="fill:#', '"/><circle cx="400" cy="250" r="50" style="fill:#',
1351     '"/><circle cx="400" cy="250" r="20" style="fill:#', '"/><circle cx="250" cy="250" r="150" style="fill:#', '"/><circle cx="250" cy="250" r="120" style="fill:#',
1352     '"/><circle cx="200" cy="215" r="35" style="fill:#fff"/><circle cx="305" cy="222" r="31" style="fill:#fff"/><circle cx="200" cy="220" r="20" style="fill:#',
1353     '"/><circle cx="300" cy="220" r="20" style="fill:#', '"/><circle cx="200" cy="220" r="7" style="fill:#000"/><circle cx="300" cy="220" r="7" style="fill:#000"/>',
1354     '<ellipse cx="250" cy="315" rx="84" ry="34" style="fill:#',
1355      '"/><rect x="195" y="330" width="110" height="3" style="fill:#000"/><circle cx="268" cy="295" r="5" style="fill:#000"/><circle cx="232" cy="295" r="5" style="fill:#000"/>',
1356     '</svg>'];
1357   string private cross='<rect x="95" y="275" width="10" height="40" style="fill:#872"/><rect x="85" y="285" width="30" height="10" style="fill:#872"/>';
1358   string private clo1='<rect width="300" height="120" x="99" y="400" style="fill:#';
1359   string private clo2='"/><rect width="50" height="55" x="280" y="430" style="fill:#';
1360   string private hh1='<rect width="200" height="99" x="150" y="40" style="fill:#';
1361   string private hh2='"/><rect width="200" height="33" x="150" y="106" style="fill:#';
1362   string private sl1='<rect x="150" y="190" width="200" height="30" style="fill:#';
1363   string private sl2='"/><rect x="160" y="170" width="180" height="50" style="fill:#';
1364   string private mou='<line x1="287" y1="331" x2="320" y2="366" style="stroke:#000;stroke-width:5"/>';
1365   string private ey1='<rect x="160" y="190" width="75" height="15" style="fill:#';
1366   string private ey2='"/><rect x="275" y="190" width="65" height="15" style="fill:#';
1367   string private ey3='<rect x="160" y="235" width="180" height="50" style="fill:#';
1368   string private zz='"/>';
1369   string private ea1='<circle cx="100" cy="290" r="14" style="fill:#';
1370   string private ea2='fe7';
1371   string private ea3='999';
1372   string private ea4='"/><circle cx="100" cy="290" r="4" style="fill:#000"/>';
1373   string private ea5='<circle cx="100" cy="290" r="12" style="fill:#';
1374   string private ea6='bdd';
1375   string private mo1='<line x1="';
1376   string private mo2='" y1="307" x2="';
1377   string private mo3='" y2="312" style="stroke:#000;stroke-width:2"/>';
1378   string private mo4='" y1="317" x2="';
1379   string private mo5='" y2="322" style="stroke:#000;stroke-width:2"/>';
1380   string private tr1='", "attributes": [{"trait_type": "Background","value": "';
1381   string private tr2='"},{"trait_type": "Fur","value": "';
1382   string private tr3='"},{"trait_type": "Earring","value": "';
1383   string private tr4='"},{"trait_type": "Hat","value": "';
1384   string private tr5='"},{"trait_type": "Eyes","value": "';
1385   string private tr6='"},{"trait_type": "Clothes","value": "';
1386   string private tr7='"},{"trait_type": "Mouth","value": "';
1387   string private tr8='"}],"image": "data:image/svg+xml;base64,';
1388   string private ra1='A';
1389   string private ra2='C';
1390   string private ra3='D';
1391   string private ra4='E';
1392   string private ra5='F';
1393   string private ra6='G';
1394   string private co1=', ';
1395   string private rl1='{"name": "Ape On Chain #';
1396   string private rl3='"}';
1397   string private rl4='data:application/json;base64,';
1398 
1399   struct Ape { 
1400     uint8 bg;
1401     uint8 fur;
1402     uint8 eyes;
1403     uint8 mouth;
1404     uint8 earring;
1405     uint8 clothes;
1406     uint8 hat;
1407   }
1408 
1409   // this was used to create the distributon of 3,500 and tested for uniqueness for the given parameters of this collection
1410   function random(string memory input) internal pure returns (uint256) {
1411     return uint256(keccak256(abi.encodePacked(input)));
1412   }
1413 
1414   function usew(uint8[] memory w,uint256 i) internal pure returns (uint8) {
1415     uint8 ind=0;
1416     uint256 j=uint256(w[0]);
1417     while (j<=i) {
1418       ind++;
1419       j+=uint256(w[ind]);
1420     }
1421     return ind;
1422   }
1423 
1424   function randomOne(uint256 tokenId) internal view returns (Ape memory) {
1425     tokenId=12839-tokenId; // avoid dupes
1426     Ape memory ape;
1427     ape.bg = uint8(random(string(abi.encodePacked(ra1,tokenId.toString()))) % 8);
1428     ape.fur = usew(fur_w,random(string(abi.encodePacked(clo1,tokenId.toString())))%1817);
1429     ape.eyes = usew(eyes_w,random(string(abi.encodePacked(ra2,tokenId.toString())))%1429);
1430     ape.mouth = usew(mouth_w,random(string(abi.encodePacked(ra3,tokenId.toString())))%1112);
1431     ape.earring = usew(earring_w,random(string(abi.encodePacked(ra4,tokenId.toString())))%358);
1432     ape.clothes = usew(clothes_w,random(string(abi.encodePacked(ra5,tokenId.toString())))%1329);
1433     ape.hat = usew(hat_w,random(string(abi.encodePacked(ra6,tokenId.toString())))%1111);
1434     if (tokenId==7403) {
1435       ape.hat++; 
1436     }
1437     return ape;
1438   }
1439 
1440   // get string attributes of properties, used in tokenURI call
1441   function getTraits(Ape memory ape) internal view returns (string memory) {
1442     string memory o=string(abi.encodePacked(tr1,uint256(ape.bg).toString(),tr2,uint256(ape.fur).toString(),tr3,uint256(ape.earring).toString()));
1443     return string(abi.encodePacked(o,tr4,uint256(ape.hat).toString(),tr5,uint256(ape.eyes).toString(),tr6,uint256(ape.clothes).toString(),tr7,uint256(ape.mouth).toString(),tr8));
1444   }
1445 
1446   // return comma separated traits in order: hat, fur, clothes, eyes, earring, mouth, background
1447   function getAttributes(uint256 tokenId) public view returns (string memory) {
1448     Ape memory ape = randomOne(tokenId);
1449     string memory o=string(abi.encodePacked(uint256(ape.hat).toString(),co1,uint256(ape.fur).toString(),co1,uint256(ape.clothes).toString(),co1));
1450     return string(abi.encodePacked(o,uint256(ape.eyes).toString(),co1,uint256(ape.earring).toString(),co1,uint256(ape.mouth).toString(),co1,uint256(ape.bg).toString()));
1451   }
1452 
1453   function genEye(string memory a,string memory b,uint8 h) internal view returns (string memory) {
1454     string memory out = '';
1455     if (h>4) { out = string(abi.encodePacked(sl1,a,sl2,a,zz)); }
1456     if (h>10) { out = string(abi.encodePacked(out,ey1,b,ey2,b,zz)); }
1457     if (h>16) { out = string(abi.encodePacked(out,ey3,a,zz)); }
1458     return out;
1459   }
1460 
1461   function genMouth(uint8 h) internal view returns (string memory) {
1462     string memory out = '';
1463     uint i;
1464     if ((h>24) || ((h>8) && (h<16))) {
1465       for (i=0;i<7;i++) {
1466         out = string(abi.encodePacked(out,mo1,(175+i*25).toString(),mo2,(175+i*25).toString(),mo3));
1467       }
1468       for (i=0;i<6;i++) {
1469         out = string(abi.encodePacked(out,mo1,(187+i*25).toString(),mo4,(187+i*25).toString(),mo5));
1470       }
1471     }
1472     if (h>15) {
1473       out = string(abi.encodePacked(out,mou));
1474     }
1475     return out;
1476   }
1477 
1478   function genEarring(uint8 h) internal view returns (string memory) {
1479     if (h==0) {
1480       return '';
1481     }
1482     if (h<3) {
1483       if (h>1) {
1484         return string(abi.encodePacked(ea1,ea2,ea4));
1485       } 
1486       return string(abi.encodePacked(ea1,ea3,ea4));
1487     }
1488     if (h>3) {
1489       if (h>5) {
1490         return string(abi.encodePacked(ea5,ea6,zz));
1491       } 
1492       if (h>4) {
1493         return string(abi.encodePacked(ea5,ea2,zz));
1494       } 
1495       return string(abi.encodePacked(ea5,ea3,zz));
1496     }
1497     return cross;
1498   }
1499 
1500   function genSVG(Ape memory ape) internal view returns (string memory) {
1501     string memory a=fur1[ape.fur];
1502     string memory b=fur2[ape.fur];
1503     string memory hatst='';
1504     string memory clost='';
1505     if (ape.clothes>0) {
1506       clost=string(abi.encodePacked(clo1,clothes1[ape.clothes-1],clo2,clothes2[ape.clothes-1],zz));
1507     }
1508     if (ape.hat>0) {
1509       hatst=string(abi.encodePacked(hh1,hat1[ape.hat-1],hh2,hat2[ape.hat-1],zz));
1510     }
1511     string memory output = string(abi.encodePacked(z[0],background[ape.bg],z[1],b,z[2]));
1512     output = string(abi.encodePacked(output,a,z[3],a,z[4],b,z[5],a,z[6]));
1513     output = string(abi.encodePacked(output,b,z[7],a,z[8],b,z[9],a,z[10]));
1514     output = string(abi.encodePacked(output,eyes[ape.eyes],z[11],eyes[ape.eyes],z[12],genEye(a,b,ape.eyes),z[13],mouth[ape.mouth],z[14]));
1515     return string(abi.encodePacked(output,genMouth(ape.mouth),genEarring(ape.earring),hatst,clost,z[15]));
1516   }
1517 
1518   function tokenURI(uint256 tokenId) override public view returns (string memory) {
1519     Ape memory ape = randomOne(tokenId);
1520     return string(abi.encodePacked(rl4,Base64.encode(bytes(string(abi.encodePacked(rl1,tokenId.toString(),getTraits(ape),Base64.encode(bytes(genSVG(ape))),rl3))))));
1521   }
1522 
1523   function mint() public nonReentrant {
1524     require(numClaimed >= 0 && numClaimed < 3450, "invalid mint");
1525     _safeMint(_msgSender(), numClaimed + 1);
1526     numClaimed += 1;
1527   }
1528     
1529   function ownerClaim(uint256 tokenId) public nonReentrant onlyOwner {
1530     require(tokenId > 3450 && tokenId < 3501, "invalid mint");
1531     _safeMint(owner(), tokenId);
1532   }
1533     
1534   constructor() ERC721("ApesOnChain", "APOC") Ownable() {}
1535 }