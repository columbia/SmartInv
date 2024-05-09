1 // 	    __ __                     __  __     _
2 // 	   / //_/_  ______  ____ _   / / / /__  (_)
3 // 	  / ,< / / / / __ \/ __ `/  / /_/ / _ \/ /
4 // 	 / /| / /_/ / / / / /_/ /  / __  /  __/ /
5 // 	/_/ |_\__,_/_/ /_/\__, /  /_/ /_/\___/_/
6 // 	                 /____/
7 // 	    ______      __     ________
8 // 	   / ____/___ _/ /_   / ____/ /_  ____  __  __
9 // 	  / /_  / __ `/ __/  / /   / __ \/ __ \/ / / /
10 // 	 / __/ / /_/ / /_   / /___/ / / / /_/ / /_/ /
11 // 	/_/    \__,_/\__/   \____/_/ /_/\____/\__, /
12 //         	                             /____/
13 //
14 //                        ___......----:'"":--....(\
15 //                 .-':'"":   :  :  :   :  :  :.(1\.`-.
16 //               .'`.  `.  :  :  :   :   : : : : : :  .';
17 //              :-`. :   .  : :  `.  :   : :.   : :`.`. a;
18 //              : ;-. `-.-._.  :  :   :  ::. .' `. `., =  ;
19 //              :-:.` .-. _-.,  :  :  : ::,.'.-' ;-. ,'''"
20 //            .'.' ;`. .-' `-.:  :  : : :;.-'.-.'   `-'
21 //     :.   .'.'.-' .'`-.' -._;..:---'''"~;._.-;
22 //     :`--'.'  : :'     ;`-.;            :.`.-'`.
23 //      `'"`    : :      ;`.;             :=; `.-'`.
24 //              : '.    :  ;              :-:   `._-`.
25 //               `'"'    `. `.            `--'     `._;
26 //                         `'"'
27 //            |
28 //      _____ | _____        \     /   /______    |  |     / /_  /    | |
29 //     ()____)+()____)     -----  /       |       | -+-.  /_.|_|/_.   | |
30 //     ()____)+()____)      \ /  /___   __|__   | |  | |   / | | /    | |
31 //     ()____)+()____)     ----- | |    | |     |_| _|_|_ /_\`-'/_\   | |
32 //     ()____)+()____)     __|__ | |  __|_|____   |  |     ___|___    | |
33 //     ()____)+()____)      /|\  | |      |       | / \     _/|\_     * *
34 //          / | \
35 // __  __                         ____   __  __            __  _
36 // \ \/ /__  ____ ______   ____  / __/  / /_/ /_  ___     / /_(_)___ ____  _____
37 //  \  / _ \/ __ `/ ___/  / __ \/ /_   / __/ __ \/ _ \   / __/ / __ `/ _ \/ ___/
38 //  / /  __/ /_/ / /     / /_/ / __/  / /_/ / / /  __/  / /_/ / /_/ /  __/ /
39 // /_/\___/\__,_/_/      \____/_/     \__/_/ /_/\___/   \__/_/\__, /\___/_/
40 //                                                           /____/
41 //
42 // Author: bayu (github.com/pyk)
43 
44 // Verified using https://dapp.tools
45 
46 // hevm: flattened sources of src/LauHuPao.sol
47 // SPDX-License-Identifier: MIT AND GPL-3.0-or-later
48 pragma solidity =0.8.10 >=0.8.0 <0.9.0;
49 pragma experimental ABIEncoderV2;
50 
51 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
52 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
53 
54 /* pragma solidity ^0.8.0; */
55 
56 /**
57  * @dev Provides information about the current execution context, including the
58  * sender of the transaction and its data. While these are generally available
59  * via msg.sender and msg.data, they should not be accessed in such a direct
60  * manner, since when dealing with meta-transactions the account sending and
61  * paying for execution may not be the actual sender (as far as an application
62  * is concerned).
63  *
64  * This contract is only required for intermediate, library-like contracts.
65  */
66 abstract contract Context {
67     function _msgSender() internal view virtual returns (address) {
68         return msg.sender;
69     }
70 
71     function _msgData() internal view virtual returns (bytes calldata) {
72         return msg.data;
73     }
74 }
75 
76 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
77 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
78 
79 /* pragma solidity ^0.8.0; */
80 
81 /* import "../utils/Context.sol"; */
82 
83 /**
84  * @dev Contract module which provides a basic access control mechanism, where
85  * there is an account (an owner) that can be granted exclusive access to
86  * specific functions.
87  *
88  * By default, the owner account will be the one that deploys the contract. This
89  * can later be changed with {transferOwnership}.
90  *
91  * This module is used through inheritance. It will make available the modifier
92  * `onlyOwner`, which can be applied to your functions to restrict their use to
93  * the owner.
94  */
95 abstract contract Ownable is Context {
96     address private _owner;
97 
98     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
99 
100     /**
101      * @dev Initializes the contract setting the deployer as the initial owner.
102      */
103     constructor() {
104         _transferOwnership(_msgSender());
105     }
106 
107     /**
108      * @dev Returns the address of the current owner.
109      */
110     function owner() public view virtual returns (address) {
111         return _owner;
112     }
113 
114     /**
115      * @dev Throws if called by any account other than the owner.
116      */
117     modifier onlyOwner() {
118         require(owner() == _msgSender(), "Ownable: caller is not the owner");
119         _;
120     }
121 
122     /**
123      * @dev Leaves the contract without owner. It will not be possible to call
124      * `onlyOwner` functions anymore. Can only be called by the current owner.
125      *
126      * NOTE: Renouncing ownership will leave the contract without an owner,
127      * thereby removing any functionality that is only available to the owner.
128      */
129     function renounceOwnership() public virtual onlyOwner {
130         _transferOwnership(address(0));
131     }
132 
133     /**
134      * @dev Transfers ownership of the contract to a new account (`newOwner`).
135      * Can only be called by the current owner.
136      */
137     function transferOwnership(address newOwner) public virtual onlyOwner {
138         require(newOwner != address(0), "Ownable: new owner is the zero address");
139         _transferOwnership(newOwner);
140     }
141 
142     /**
143      * @dev Transfers ownership of the contract to a new account (`newOwner`).
144      * Internal function without access restriction.
145      */
146     function _transferOwnership(address newOwner) internal virtual {
147         address oldOwner = _owner;
148         _owner = newOwner;
149         emit OwnershipTransferred(oldOwner, newOwner);
150     }
151 }
152 
153 ////// lib/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol
154 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
155 
156 /* pragma solidity ^0.8.0; */
157 
158 /**
159  * @dev Interface of the ERC165 standard, as defined in the
160  * https://eips.ethereum.org/EIPS/eip-165[EIP].
161  *
162  * Implementers can declare support of contract interfaces, which can then be
163  * queried by others ({ERC165Checker}).
164  *
165  * For an implementation, see {ERC165}.
166  */
167 interface IERC165 {
168     /**
169      * @dev Returns true if this contract implements the interface defined by
170      * `interfaceId`. See the corresponding
171      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
172      * to learn more about how these ids are created.
173      *
174      * This function call must use less than 30 000 gas.
175      */
176     function supportsInterface(bytes4 interfaceId) external view returns (bool);
177 }
178 
179 ////// lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol
180 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
181 
182 /* pragma solidity ^0.8.0; */
183 
184 /* import "../../utils/introspection/IERC165.sol"; */
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
323 ////// lib/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol
324 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
325 
326 /* pragma solidity ^0.8.0; */
327 
328 /**
329  * @title ERC721 token receiver interface
330  * @dev Interface for any contract that wants to support safeTransfers
331  * from ERC721 asset contracts.
332  */
333 interface IERC721Receiver {
334     /**
335      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
336      * by `operator` from `from`, this function is called.
337      *
338      * It must return its Solidity selector to confirm the token transfer.
339      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
340      *
341      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
342      */
343     function onERC721Received(
344         address operator,
345         address from,
346         uint256 tokenId,
347         bytes calldata data
348     ) external returns (bytes4);
349 }
350 
351 ////// lib/openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Metadata.sol
352 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
353 
354 /* pragma solidity ^0.8.0; */
355 
356 /* import "../IERC721.sol"; */
357 
358 /**
359  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
360  * @dev See https://eips.ethereum.org/EIPS/eip-721
361  */
362 interface IERC721Metadata is IERC721 {
363     /**
364      * @dev Returns the token collection name.
365      */
366     function name() external view returns (string memory);
367 
368     /**
369      * @dev Returns the token collection symbol.
370      */
371     function symbol() external view returns (string memory);
372 
373     /**
374      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
375      */
376     function tokenURI(uint256 tokenId) external view returns (string memory);
377 }
378 
379 ////// lib/openzeppelin-contracts/contracts/utils/Address.sol
380 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
381 
382 /* pragma solidity ^0.8.0; */
383 
384 /**
385  * @dev Collection of functions related to the address type
386  */
387 library Address {
388     /**
389      * @dev Returns true if `account` is a contract.
390      *
391      * [IMPORTANT]
392      * ====
393      * It is unsafe to assume that an address for which this function returns
394      * false is an externally-owned account (EOA) and not a contract.
395      *
396      * Among others, `isContract` will return false for the following
397      * types of addresses:
398      *
399      *  - an externally-owned account
400      *  - a contract in construction
401      *  - an address where a contract will be created
402      *  - an address where a contract lived, but was destroyed
403      * ====
404      */
405     function isContract(address account) internal view returns (bool) {
406         // This method relies on extcodesize, which returns 0 for contracts in
407         // construction, since the code is only stored at the end of the
408         // constructor execution.
409 
410         uint256 size;
411         assembly {
412             size := extcodesize(account)
413         }
414         return size > 0;
415     }
416 
417     /**
418      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
419      * `recipient`, forwarding all available gas and reverting on errors.
420      *
421      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
422      * of certain opcodes, possibly making contracts go over the 2300 gas limit
423      * imposed by `transfer`, making them unable to receive funds via
424      * `transfer`. {sendValue} removes this limitation.
425      *
426      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
427      *
428      * IMPORTANT: because control is transferred to `recipient`, care must be
429      * taken to not create reentrancy vulnerabilities. Consider using
430      * {ReentrancyGuard} or the
431      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
432      */
433     function sendValue(address payable recipient, uint256 amount) internal {
434         require(address(this).balance >= amount, "Address: insufficient balance");
435 
436         (bool success, ) = recipient.call{value: amount}("");
437         require(success, "Address: unable to send value, recipient may have reverted");
438     }
439 
440     /**
441      * @dev Performs a Solidity function call using a low level `call`. A
442      * plain `call` is an unsafe replacement for a function call: use this
443      * function instead.
444      *
445      * If `target` reverts with a revert reason, it is bubbled up by this
446      * function (like regular Solidity function calls).
447      *
448      * Returns the raw returned data. To convert to the expected return value,
449      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
450      *
451      * Requirements:
452      *
453      * - `target` must be a contract.
454      * - calling `target` with `data` must not revert.
455      *
456      * _Available since v3.1._
457      */
458     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
459         return functionCall(target, data, "Address: low-level call failed");
460     }
461 
462     /**
463      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
464      * `errorMessage` as a fallback revert reason when `target` reverts.
465      *
466      * _Available since v3.1._
467      */
468     function functionCall(
469         address target,
470         bytes memory data,
471         string memory errorMessage
472     ) internal returns (bytes memory) {
473         return functionCallWithValue(target, data, 0, errorMessage);
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
478      * but also transferring `value` wei to `target`.
479      *
480      * Requirements:
481      *
482      * - the calling contract must have an ETH balance of at least `value`.
483      * - the called Solidity function must be `payable`.
484      *
485      * _Available since v3.1._
486      */
487     function functionCallWithValue(
488         address target,
489         bytes memory data,
490         uint256 value
491     ) internal returns (bytes memory) {
492         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
493     }
494 
495     /**
496      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
497      * with `errorMessage` as a fallback revert reason when `target` reverts.
498      *
499      * _Available since v3.1._
500      */
501     function functionCallWithValue(
502         address target,
503         bytes memory data,
504         uint256 value,
505         string memory errorMessage
506     ) internal returns (bytes memory) {
507         require(address(this).balance >= value, "Address: insufficient balance for call");
508         require(isContract(target), "Address: call to non-contract");
509 
510         (bool success, bytes memory returndata) = target.call{value: value}(data);
511         return verifyCallResult(success, returndata, errorMessage);
512     }
513 
514     /**
515      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
516      * but performing a static call.
517      *
518      * _Available since v3.3._
519      */
520     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
521         return functionStaticCall(target, data, "Address: low-level static call failed");
522     }
523 
524     /**
525      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
526      * but performing a static call.
527      *
528      * _Available since v3.3._
529      */
530     function functionStaticCall(
531         address target,
532         bytes memory data,
533         string memory errorMessage
534     ) internal view returns (bytes memory) {
535         require(isContract(target), "Address: static call to non-contract");
536 
537         (bool success, bytes memory returndata) = target.staticcall(data);
538         return verifyCallResult(success, returndata, errorMessage);
539     }
540 
541     /**
542      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
543      * but performing a delegate call.
544      *
545      * _Available since v3.4._
546      */
547     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
548         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
549     }
550 
551     /**
552      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
553      * but performing a delegate call.
554      *
555      * _Available since v3.4._
556      */
557     function functionDelegateCall(
558         address target,
559         bytes memory data,
560         string memory errorMessage
561     ) internal returns (bytes memory) {
562         require(isContract(target), "Address: delegate call to non-contract");
563 
564         (bool success, bytes memory returndata) = target.delegatecall(data);
565         return verifyCallResult(success, returndata, errorMessage);
566     }
567 
568     /**
569      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
570      * revert reason using the provided one.
571      *
572      * _Available since v4.3._
573      */
574     function verifyCallResult(
575         bool success,
576         bytes memory returndata,
577         string memory errorMessage
578     ) internal pure returns (bytes memory) {
579         if (success) {
580             return returndata;
581         } else {
582             // Look for revert reason and bubble it up if present
583             if (returndata.length > 0) {
584                 // The easiest way to bubble the revert reason is using memory via assembly
585 
586                 assembly {
587                     let returndata_size := mload(returndata)
588                     revert(add(32, returndata), returndata_size)
589                 }
590             } else {
591                 revert(errorMessage);
592             }
593         }
594     }
595 }
596 
597 ////// lib/openzeppelin-contracts/contracts/utils/Strings.sol
598 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
599 
600 /* pragma solidity ^0.8.0; */
601 
602 /**
603  * @dev String operations.
604  */
605 library Strings {
606     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
607 
608     /**
609      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
610      */
611     function toString(uint256 value) internal pure returns (string memory) {
612         // Inspired by OraclizeAPI's implementation - MIT licence
613         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
614 
615         if (value == 0) {
616             return "0";
617         }
618         uint256 temp = value;
619         uint256 digits;
620         while (temp != 0) {
621             digits++;
622             temp /= 10;
623         }
624         bytes memory buffer = new bytes(digits);
625         while (value != 0) {
626             digits -= 1;
627             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
628             value /= 10;
629         }
630         return string(buffer);
631     }
632 
633     /**
634      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
635      */
636     function toHexString(uint256 value) internal pure returns (string memory) {
637         if (value == 0) {
638             return "0x00";
639         }
640         uint256 temp = value;
641         uint256 length = 0;
642         while (temp != 0) {
643             length++;
644             temp >>= 8;
645         }
646         return toHexString(value, length);
647     }
648 
649     /**
650      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
651      */
652     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
653         bytes memory buffer = new bytes(2 * length + 2);
654         buffer[0] = "0";
655         buffer[1] = "x";
656         for (uint256 i = 2 * length + 1; i > 1; --i) {
657             buffer[i] = _HEX_SYMBOLS[value & 0xf];
658             value >>= 4;
659         }
660         require(value == 0, "Strings: hex length insufficient");
661         return string(buffer);
662     }
663 }
664 
665 ////// lib/openzeppelin-contracts/contracts/utils/introspection/ERC165.sol
666 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
667 
668 /* pragma solidity ^0.8.0; */
669 
670 /* import "./IERC165.sol"; */
671 
672 /**
673  * @dev Implementation of the {IERC165} interface.
674  *
675  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
676  * for the additional interface id that will be supported. For example:
677  *
678  * ```solidity
679  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
680  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
681  * }
682  * ```
683  *
684  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
685  */
686 abstract contract ERC165 is IERC165 {
687     /**
688      * @dev See {IERC165-supportsInterface}.
689      */
690     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
691         return interfaceId == type(IERC165).interfaceId;
692     }
693 }
694 
695 ////// lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol
696 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
697 
698 /* pragma solidity ^0.8.0; */
699 
700 /* import "./IERC721.sol"; */
701 /* import "./IERC721Receiver.sol"; */
702 /* import "./extensions/IERC721Metadata.sol"; */
703 /* import "../../utils/Address.sol"; */
704 /* import "../../utils/Context.sol"; */
705 /* import "../../utils/Strings.sol"; */
706 /* import "../../utils/introspection/ERC165.sol"; */
707 
708 /**
709  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
710  * the Metadata extension, but not including the Enumerable extension, which is available separately as
711  * {ERC721Enumerable}.
712  */
713 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
714     using Address for address;
715     using Strings for uint256;
716 
717     // Token name
718     string private _name;
719 
720     // Token symbol
721     string private _symbol;
722 
723     // Mapping from token ID to owner address
724     mapping(uint256 => address) private _owners;
725 
726     // Mapping owner address to token count
727     mapping(address => uint256) private _balances;
728 
729     // Mapping from token ID to approved address
730     mapping(uint256 => address) private _tokenApprovals;
731 
732     // Mapping from owner to operator approvals
733     mapping(address => mapping(address => bool)) private _operatorApprovals;
734 
735     /**
736      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
737      */
738     constructor(string memory name_, string memory symbol_) {
739         _name = name_;
740         _symbol = symbol_;
741     }
742 
743     /**
744      * @dev See {IERC165-supportsInterface}.
745      */
746     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
747         return
748             interfaceId == type(IERC721).interfaceId ||
749             interfaceId == type(IERC721Metadata).interfaceId ||
750             super.supportsInterface(interfaceId);
751     }
752 
753     /**
754      * @dev See {IERC721-balanceOf}.
755      */
756     function balanceOf(address owner) public view virtual override returns (uint256) {
757         require(owner != address(0), "ERC721: balance query for the zero address");
758         return _balances[owner];
759     }
760 
761     /**
762      * @dev See {IERC721-ownerOf}.
763      */
764     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
765         address owner = _owners[tokenId];
766         require(owner != address(0), "ERC721: owner query for nonexistent token");
767         return owner;
768     }
769 
770     /**
771      * @dev See {IERC721Metadata-name}.
772      */
773     function name() public view virtual override returns (string memory) {
774         return _name;
775     }
776 
777     /**
778      * @dev See {IERC721Metadata-symbol}.
779      */
780     function symbol() public view virtual override returns (string memory) {
781         return _symbol;
782     }
783 
784     /**
785      * @dev See {IERC721Metadata-tokenURI}.
786      */
787     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
788         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
789 
790         string memory baseURI = _baseURI();
791         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
792     }
793 
794     /**
795      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
796      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
797      * by default, can be overriden in child contracts.
798      */
799     function _baseURI() internal view virtual returns (string memory) {
800         return "";
801     }
802 
803     /**
804      * @dev See {IERC721-approve}.
805      */
806     function approve(address to, uint256 tokenId) public virtual override {
807         address owner = ERC721.ownerOf(tokenId);
808         require(to != owner, "ERC721: approval to current owner");
809 
810         require(
811             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
812             "ERC721: approve caller is not owner nor approved for all"
813         );
814 
815         _approve(to, tokenId);
816     }
817 
818     /**
819      * @dev See {IERC721-getApproved}.
820      */
821     function getApproved(uint256 tokenId) public view virtual override returns (address) {
822         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
823 
824         return _tokenApprovals[tokenId];
825     }
826 
827     /**
828      * @dev See {IERC721-setApprovalForAll}.
829      */
830     function setApprovalForAll(address operator, bool approved) public virtual override {
831         _setApprovalForAll(_msgSender(), operator, approved);
832     }
833 
834     /**
835      * @dev See {IERC721-isApprovedForAll}.
836      */
837     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
838         return _operatorApprovals[owner][operator];
839     }
840 
841     /**
842      * @dev See {IERC721-transferFrom}.
843      */
844     function transferFrom(
845         address from,
846         address to,
847         uint256 tokenId
848     ) public virtual override {
849         //solhint-disable-next-line max-line-length
850         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
851 
852         _transfer(from, to, tokenId);
853     }
854 
855     /**
856      * @dev See {IERC721-safeTransferFrom}.
857      */
858     function safeTransferFrom(
859         address from,
860         address to,
861         uint256 tokenId
862     ) public virtual override {
863         safeTransferFrom(from, to, tokenId, "");
864     }
865 
866     /**
867      * @dev See {IERC721-safeTransferFrom}.
868      */
869     function safeTransferFrom(
870         address from,
871         address to,
872         uint256 tokenId,
873         bytes memory _data
874     ) public virtual override {
875         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
876         _safeTransfer(from, to, tokenId, _data);
877     }
878 
879     /**
880      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
881      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
882      *
883      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
884      *
885      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
886      * implement alternative mechanisms to perform token transfer, such as signature-based.
887      *
888      * Requirements:
889      *
890      * - `from` cannot be the zero address.
891      * - `to` cannot be the zero address.
892      * - `tokenId` token must exist and be owned by `from`.
893      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
894      *
895      * Emits a {Transfer} event.
896      */
897     function _safeTransfer(
898         address from,
899         address to,
900         uint256 tokenId,
901         bytes memory _data
902     ) internal virtual {
903         _transfer(from, to, tokenId);
904         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
905     }
906 
907     /**
908      * @dev Returns whether `tokenId` exists.
909      *
910      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
911      *
912      * Tokens start existing when they are minted (`_mint`),
913      * and stop existing when they are burned (`_burn`).
914      */
915     function _exists(uint256 tokenId) internal view virtual returns (bool) {
916         return _owners[tokenId] != address(0);
917     }
918 
919     /**
920      * @dev Returns whether `spender` is allowed to manage `tokenId`.
921      *
922      * Requirements:
923      *
924      * - `tokenId` must exist.
925      */
926     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
927         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
928         address owner = ERC721.ownerOf(tokenId);
929         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
930     }
931 
932     /**
933      * @dev Safely mints `tokenId` and transfers it to `to`.
934      *
935      * Requirements:
936      *
937      * - `tokenId` must not exist.
938      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
939      *
940      * Emits a {Transfer} event.
941      */
942     function _safeMint(address to, uint256 tokenId) internal virtual {
943         _safeMint(to, tokenId, "");
944     }
945 
946     /**
947      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
948      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
949      */
950     function _safeMint(
951         address to,
952         uint256 tokenId,
953         bytes memory _data
954     ) internal virtual {
955         _mint(to, tokenId);
956         require(
957             _checkOnERC721Received(address(0), to, tokenId, _data),
958             "ERC721: transfer to non ERC721Receiver implementer"
959         );
960     }
961 
962     /**
963      * @dev Mints `tokenId` and transfers it to `to`.
964      *
965      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
966      *
967      * Requirements:
968      *
969      * - `tokenId` must not exist.
970      * - `to` cannot be the zero address.
971      *
972      * Emits a {Transfer} event.
973      */
974     function _mint(address to, uint256 tokenId) internal virtual {
975         require(to != address(0), "ERC721: mint to the zero address");
976         require(!_exists(tokenId), "ERC721: token already minted");
977 
978         _beforeTokenTransfer(address(0), to, tokenId);
979 
980         _balances[to] += 1;
981         _owners[tokenId] = to;
982 
983         emit Transfer(address(0), to, tokenId);
984     }
985 
986     /**
987      * @dev Destroys `tokenId`.
988      * The approval is cleared when the token is burned.
989      *
990      * Requirements:
991      *
992      * - `tokenId` must exist.
993      *
994      * Emits a {Transfer} event.
995      */
996     function _burn(uint256 tokenId) internal virtual {
997         address owner = ERC721.ownerOf(tokenId);
998 
999         _beforeTokenTransfer(owner, address(0), tokenId);
1000 
1001         // Clear approvals
1002         _approve(address(0), tokenId);
1003 
1004         _balances[owner] -= 1;
1005         delete _owners[tokenId];
1006 
1007         emit Transfer(owner, address(0), tokenId);
1008     }
1009 
1010     /**
1011      * @dev Transfers `tokenId` from `from` to `to`.
1012      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1013      *
1014      * Requirements:
1015      *
1016      * - `to` cannot be the zero address.
1017      * - `tokenId` token must be owned by `from`.
1018      *
1019      * Emits a {Transfer} event.
1020      */
1021     function _transfer(
1022         address from,
1023         address to,
1024         uint256 tokenId
1025     ) internal virtual {
1026         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1027         require(to != address(0), "ERC721: transfer to the zero address");
1028 
1029         _beforeTokenTransfer(from, to, tokenId);
1030 
1031         // Clear approvals from the previous owner
1032         _approve(address(0), tokenId);
1033 
1034         _balances[from] -= 1;
1035         _balances[to] += 1;
1036         _owners[tokenId] = to;
1037 
1038         emit Transfer(from, to, tokenId);
1039     }
1040 
1041     /**
1042      * @dev Approve `to` to operate on `tokenId`
1043      *
1044      * Emits a {Approval} event.
1045      */
1046     function _approve(address to, uint256 tokenId) internal virtual {
1047         _tokenApprovals[tokenId] = to;
1048         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1049     }
1050 
1051     /**
1052      * @dev Approve `operator` to operate on all of `owner` tokens
1053      *
1054      * Emits a {ApprovalForAll} event.
1055      */
1056     function _setApprovalForAll(
1057         address owner,
1058         address operator,
1059         bool approved
1060     ) internal virtual {
1061         require(owner != operator, "ERC721: approve to caller");
1062         _operatorApprovals[owner][operator] = approved;
1063         emit ApprovalForAll(owner, operator, approved);
1064     }
1065 
1066     /**
1067      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1068      * The call is not executed if the target address is not a contract.
1069      *
1070      * @param from address representing the previous owner of the given token ID
1071      * @param to target address that will receive the tokens
1072      * @param tokenId uint256 ID of the token to be transferred
1073      * @param _data bytes optional data to send along with the call
1074      * @return bool whether the call correctly returned the expected magic value
1075      */
1076     function _checkOnERC721Received(
1077         address from,
1078         address to,
1079         uint256 tokenId,
1080         bytes memory _data
1081     ) private returns (bool) {
1082         if (to.isContract()) {
1083             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1084                 return retval == IERC721Receiver.onERC721Received.selector;
1085             } catch (bytes memory reason) {
1086                 if (reason.length == 0) {
1087                     revert("ERC721: transfer to non ERC721Receiver implementer");
1088                 } else {
1089                     assembly {
1090                         revert(add(32, reason), mload(reason))
1091                     }
1092                 }
1093             }
1094         } else {
1095             return true;
1096         }
1097     }
1098 
1099     /**
1100      * @dev Hook that is called before any token transfer. This includes minting
1101      * and burning.
1102      *
1103      * Calling conditions:
1104      *
1105      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1106      * transferred to `to`.
1107      * - When `from` is zero, `tokenId` will be minted for `to`.
1108      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1109      * - `from` and `to` are never both zero.
1110      *
1111      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1112      */
1113     function _beforeTokenTransfer(
1114         address from,
1115         address to,
1116         uint256 tokenId
1117     ) internal virtual {}
1118 }
1119 
1120 ////// src/LauHuPao.sol
1121 /* pragma solidity 0.8.10; */
1122 /* pragma experimental ABIEncoderV2; */
1123 
1124 /* import { ERC721 } from "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol"; */
1125 /* import { Ownable } from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1126 /* import { Strings } from "lib/openzeppelin-contracts/contracts/utils/Strings.sol"; */
1127 
1128 /// @title Lau Hu Pao
1129 /// @author bayu (github.com/pyk)
1130 /// @dev Token ID start from 1 to 3333
1131 contract LauHuPao is ERC721, Ownable {
1132     /// @notice Mint price in ether units (e.g. 0.05 ETH is 40000000000000000 wei)
1133     uint256 public MINT_PRICE = 0.05 ether;
1134 
1135     /// @notice Max supply of the Lau Hu Pao
1136     uint256 public MAX_SUPPLY = 3333;
1137     uint256 public totalSupply = 0;
1138 
1139     /// @notice The base URI; Please remove slash suffix
1140     string public BASE_URI = "https://gateway.pinata.cloud/ipfs/QmPND6T88JrzjyYbmtih3KbJkg39fFq5HcQKbjnpRrgaN5";
1141 
1142     /// @notice Fee recipient; Multisig address
1143     address payable public FEE_RECIPIENT_90 = payable(0xfD63134C6CC6f4F0B84Da802f8c586C5Fe4A6Be0);
1144     address payable public FEE_RECIPIENT_10 = payable(0xB70E93561322e2189799F87D18a0216C5A706cC6);
1145 
1146     constructor() ERC721("Lau Hu Pao", "LAUHUPAO") {}
1147 
1148     /// @notice Set the base URI. This allows us to do endpoint upgrade
1149     /// @dev Only owner can call this function
1150     function setBaseURI(string memory uri) external onlyOwner {
1151         BASE_URI = uri;
1152     }
1153 
1154     /// @notice Get the base URI
1155     function getBaseURI() external view returns (string memory) {
1156         return BASE_URI;
1157     }
1158 
1159     /// @notice Mint new NFT
1160     /// @dev Anyone can call this function
1161     function mint(uint256 amount) external payable {
1162         require(totalSupply + amount <= MAX_SUPPLY, "!OOS"); // Out of stock
1163 
1164         if (totalSupply + amount <= 800) {
1165             require(amount == 1, "!IA"); // Invalid amount
1166         } else {
1167             require(amount > 0 && amount <= 20, "!IA");
1168             require(msg.value >= MINT_PRICE * amount, "!NEETH"); // Not enough ETH
1169         }
1170 
1171         for (uint256 i = 0; i < amount; i++) {
1172             // Mint user the NFT token
1173             uint256 tokenID = totalSupply + 1;
1174             _mint(msg.sender, tokenID);
1175             // Update total supply
1176             totalSupply = tokenID;
1177         }
1178     }
1179 
1180     /// @notice Mint new NFT to given address
1181     /// @notice This is free mint
1182     /// @dev only owner can call this function
1183     function mintTo(address recipient, uint256 amount) external onlyOwner {
1184         require(totalSupply >= 801, "!SNV"); // Supply not valid
1185         require(totalSupply + amount <= MAX_SUPPLY, "!OOS"); // Out of stock
1186 
1187         for (uint256 i = 0; i < amount; i++) {
1188             // Mint user the NFT token
1189             uint256 tokenID = totalSupply + 1;
1190             _mint(recipient, tokenID);
1191             totalSupply = tokenID;
1192         }
1193     }
1194 
1195     /// @notice Fee splitter
1196     function splitFee(uint256 amount) internal pure returns (uint256 ten, uint256 ninety) {
1197         ten = (amount * 0.1 ether) / 1 ether;
1198         ninety = amount - ten;
1199     }
1200 
1201     /// @notice Send ETH inside the contract to multisig address
1202     function withdraw() external {
1203         // Split amount
1204         (uint256 ten, uint256 ninety) = splitFee(address(this).balance);
1205         (bool success, ) = address(FEE_RECIPIENT_90).call{ value: ninety }("");
1206         require(success, "!FWF");
1207         (success, ) = address(FEE_RECIPIENT_10).call{ value: ten }("");
1208         require(success, "!SWF");
1209     }
1210 
1211     /// @notice Send ETH inside the contract to multisig address
1212     function withdraw(uint256 amount) external {
1213         // Split amount
1214         (uint256 ten, uint256 ninety) = splitFee(amount);
1215         (bool success, ) = address(FEE_RECIPIENT_90).call{ value: ninety }("");
1216         require(success, "!FWF");
1217         (success, ) = address(FEE_RECIPIENT_10).call{ value: ten }("");
1218         require(success, "!SWF");
1219     }
1220 
1221     /// @notice Implement interface for ERC721URIStorage
1222     function tokenURI(uint256 tokenID) public view virtual override returns (string memory) {
1223         return string(abi.encodePacked(BASE_URI, "/", Strings.toString(tokenID), ".json"));
1224     }
1225 }
