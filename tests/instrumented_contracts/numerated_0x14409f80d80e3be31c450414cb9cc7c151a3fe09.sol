1 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 /*
7      .-') _               .-') _            _ (`-.  _  .-')          _   .-')      ('-.     .-') _     ('-.    .-')    
8     ( OO ) )             (  OO) )          ( (OO  )( \( -O )        ( '.( OO )_   ( OO ).-.(  OO) )  _(  OO)  ( OO ).  
9 ,--./ ,--,'  .-'),-----. /     '._        _.`     \ ,------.  ,-.-') ,--.   ,--.) / . --. //     '._(,------.(_)---\_) 
10 |   \ |  |\ ( OO'  .-.  '|'--...__)      (__...--'' |   /`. ' |  |OO)|   `.'   |  | \-.  \ |'--...__)|  .---'/    _ |  
11 |    \|  | )/   |  | |  |'--.  .--'       |  /  | | |  /  | | |  |  \|         |.-'-'  |  |'--.  .--'|  |    \  :` `.  
12 |  .     |/ \_) |  |\|  |   |  |          |  |_.' | |  |_.' | |  |(_/|  |'.'|  | \| |_.'  |   |  |  (|  '--.  '..`''.) 
13 |  |\    |    \ |  | |  |   |  |          |  .___.' |  .  '.',|  |_.'|  |   |  |  |  .-.  |   |  |   |  .--' .-._)   \ 
14 |  | \   |     `'  '-'  '   |  |          |  |      |  |\  \(_|  |   |  |   |  |  |  | |  |   |  |   |  `---.\       / 
15 `--'  `--'       `-----'    `--'          `--'      `--' '--' `--'   `--'   `--'  `--' `--'   `--'   `------' `-----'   
16                                                                                    
17 */
18 
19 pragma solidity ^0.8.0;
20 
21 /**
22  * @dev Provides information about the current execution context, including the
23  * sender of the transaction and its data. While these are generally available
24  * via msg.sender and msg.data, they should not be accessed in such a direct
25  * manner, since when dealing with meta-transactions the account sending and
26  * paying for execution may not be the actual sender (as far as an application
27  * is concerned).
28  *
29  * This contract is only required for intermediate, library-like contracts.
30  */
31 abstract contract Context {
32     function _msgSender() internal view virtual returns (address) {
33         return msg.sender;
34     }
35 
36     function _msgData() internal view virtual returns (bytes calldata) {
37         return msg.data;
38     }
39 }
40 
41 
42 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
43 
44 
45 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
46 
47 
48 
49 /**
50  * @dev Contract module which provides a basic access control mechanism, where
51  * there is an account (an owner) that can be granted exclusive access to
52  * specific functions.
53  *
54  * By default, the owner account will be the one that deploys the contract. This
55  * can later be changed with {transferOwnership}.
56  *
57  * This module is used through inheritance. It will make available the modifier
58  * `onlyOwner`, which can be applied to your functions to restrict their use to
59  * the owner.
60  */
61 abstract contract Ownable is Context {
62     address private _owner;
63 
64     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
65 
66     /**
67      * @dev Initializes the contract setting the deployer as the initial owner.
68      */
69     constructor() {
70         _transferOwnership(_msgSender());
71     }
72 
73     /**
74      * @dev Returns the address of the current owner.
75      */
76     function owner() public view virtual returns (address) {
77         return _owner;
78     }
79 
80     /**
81      * @dev Throws if called by any account other than the owner.
82      */
83     modifier onlyOwner() {
84         require(owner() == _msgSender(), "Ownable: caller is not the owner");
85         _;
86     }
87 
88     /**
89      * @dev Leaves the contract without owner. It will not be possible to call
90      * `onlyOwner` functions anymore. Can only be called by the current owner.
91      *
92      * NOTE: Renouncing ownership will leave the contract without an owner,
93      * thereby removing any functionality that is only available to the owner.
94      */
95     function renounceOwnership() public virtual onlyOwner {
96         _transferOwnership(address(0));
97     }
98 
99     /**
100      * @dev Transfers ownership of the contract to a new account (`newOwner`).
101      * Can only be called by the current owner.
102      */
103     function transferOwnership(address newOwner) public virtual onlyOwner {
104         require(newOwner != address(0), "Ownable: new owner is the zero address");
105         _transferOwnership(newOwner);
106     }
107 
108     /**
109      * @dev Transfers ownership of the contract to a new account (`newOwner`).
110      * Internal function without access restriction.
111      */
112     function _transferOwnership(address newOwner) internal virtual {
113         address oldOwner = _owner;
114         _owner = newOwner;
115         emit OwnershipTransferred(oldOwner, newOwner);
116     }
117 }
118 
119 
120 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
121 
122 
123 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
124 
125 
126 
127 /**
128  * @dev String operations.
129  */
130 library Strings {
131     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
132 
133     /**
134      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
135      */
136     function toString(uint256 value) internal pure returns (string memory) {
137         // Inspired by OraclizeAPI's implementation - MIT licence
138         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
139 
140         if (value == 0) {
141             return "0";
142         }
143         uint256 temp = value;
144         uint256 digits;
145         while (temp != 0) {
146             digits++;
147             temp /= 10;
148         }
149         bytes memory buffer = new bytes(digits);
150         while (value != 0) {
151             digits -= 1;
152             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
153             value /= 10;
154         }
155         return string(buffer);
156     }
157 
158     /**
159      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
160      */
161     function toHexString(uint256 value) internal pure returns (string memory) {
162         if (value == 0) {
163             return "0x00";
164         }
165         uint256 temp = value;
166         uint256 length = 0;
167         while (temp != 0) {
168             length++;
169             temp >>= 8;
170         }
171         return toHexString(value, length);
172     }
173 
174     /**
175      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
176      */
177     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
178         bytes memory buffer = new bytes(2 * length + 2);
179         buffer[0] = "0";
180         buffer[1] = "x";
181         for (uint256 i = 2 * length + 1; i > 1; --i) {
182             buffer[i] = _HEX_SYMBOLS[value & 0xf];
183             value >>= 4;
184         }
185         require(value == 0, "Strings: hex length insufficient");
186         return string(buffer);
187     }
188 }
189 
190 
191 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
192 
193 
194 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
195 
196 
197 
198 /**
199  * @dev Interface of the ERC165 standard, as defined in the
200  * https://eips.ethereum.org/EIPS/eip-165[EIP].
201  *
202  * Implementers can declare support of contract interfaces, which can then be
203  * queried by others ({ERC165Checker}).
204  *
205  * For an implementation, see {ERC165}.
206  */
207 interface IERC165 {
208     /**
209      * @dev Returns true if this contract implements the interface defined by
210      * `interfaceId`. See the corresponding
211      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
212      * to learn more about how these ids are created.
213      *
214      * This function call must use less than 30 000 gas.
215      */
216     function supportsInterface(bytes4 interfaceId) external view returns (bool);
217 }
218 
219 
220 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.2
221 
222 
223 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
224 
225 
226 
227 /**
228  * @dev Required interface of an ERC721 compliant contract.
229  */
230 interface IERC721 is IERC165 {
231     /**
232      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
233      */
234     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
235 
236     /**
237      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
238      */
239     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
240 
241     /**
242      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
243      */
244     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
245 
246     /**
247      * @dev Returns the number of tokens in ``owner``'s account.
248      */
249     function balanceOf(address owner) external view returns (uint256 balance);
250 
251     /**
252      * @dev Returns the owner of the `tokenId` token.
253      *
254      * Requirements:
255      *
256      * - `tokenId` must exist.
257      */
258     function ownerOf(uint256 tokenId) external view returns (address owner);
259 
260     /**
261      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
262      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
263      *
264      * Requirements:
265      *
266      * - `from` cannot be the zero address.
267      * - `to` cannot be the zero address.
268      * - `tokenId` token must exist and be owned by `from`.
269      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
270      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
271      *
272      * Emits a {Transfer} event.
273      */
274     function safeTransferFrom(
275         address from,
276         address to,
277         uint256 tokenId
278     ) external;
279 
280     /**
281      * @dev Transfers `tokenId` token from `from` to `to`.
282      *
283      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
284      *
285      * Requirements:
286      *
287      * - `from` cannot be the zero address.
288      * - `to` cannot be the zero address.
289      * - `tokenId` token must be owned by `from`.
290      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
291      *
292      * Emits a {Transfer} event.
293      */
294     function transferFrom(
295         address from,
296         address to,
297         uint256 tokenId
298     ) external;
299 
300     /**
301      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
302      * The approval is cleared when the token is transferred.
303      *
304      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
305      *
306      * Requirements:
307      *
308      * - The caller must own the token or be an approved operator.
309      * - `tokenId` must exist.
310      *
311      * Emits an {Approval} event.
312      */
313     function approve(address to, uint256 tokenId) external;
314 
315     /**
316      * @dev Returns the account approved for `tokenId` token.
317      *
318      * Requirements:
319      *
320      * - `tokenId` must exist.
321      */
322     function getApproved(uint256 tokenId) external view returns (address operator);
323 
324     /**
325      * @dev Approve or remove `operator` as an operator for the caller.
326      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
327      *
328      * Requirements:
329      *
330      * - The `operator` cannot be the caller.
331      *
332      * Emits an {ApprovalForAll} event.
333      */
334     function setApprovalForAll(address operator, bool _approved) external;
335 
336     /**
337      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
338      *
339      * See {setApprovalForAll}
340      */
341     function isApprovedForAll(address owner, address operator) external view returns (bool);
342 
343     /**
344      * @dev Safely transfers `tokenId` token from `from` to `to`.
345      *
346      * Requirements:
347      *
348      * - `from` cannot be the zero address.
349      * - `to` cannot be the zero address.
350      * - `tokenId` token must exist and be owned by `from`.
351      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
352      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
353      *
354      * Emits a {Transfer} event.
355      */
356     function safeTransferFrom(
357         address from,
358         address to,
359         uint256 tokenId,
360         bytes calldata data
361     ) external;
362 }
363 
364 
365 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.2
366 
367 
368 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
369 
370 
371 
372 /**
373  * @title ERC721 token receiver interface
374  * @dev Interface for any contract that wants to support safeTransfers
375  * from ERC721 asset contracts.
376  */
377 interface IERC721Receiver {
378     /**
379      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
380      * by `operator` from `from`, this function is called.
381      *
382      * It must return its Solidity selector to confirm the token transfer.
383      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
384      *
385      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
386      */
387     function onERC721Received(
388         address operator,
389         address from,
390         uint256 tokenId,
391         bytes calldata data
392     ) external returns (bytes4);
393 }
394 
395 
396 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.2
397 
398 
399 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
400 
401 
402 
403 /**
404  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
405  * @dev See https://eips.ethereum.org/EIPS/eip-721
406  */
407 interface IERC721Metadata is IERC721 {
408     /**
409      * @dev Returns the token collection name.
410      */
411     function name() external view returns (string memory);
412 
413     /**
414      * @dev Returns the token collection symbol.
415      */
416     function symbol() external view returns (string memory);
417 
418     /**
419      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
420      */
421     function tokenURI(uint256 tokenId) external view returns (string memory);
422 }
423 
424 
425 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.2
426 
427 
428 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
429 
430 
431 
432 /**
433  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
434  * @dev See https://eips.ethereum.org/EIPS/eip-721
435  */
436 interface IERC721Enumerable is IERC721 {
437     /**
438      * @dev Returns the total amount of tokens stored by the contract.
439      */
440     function totalSupply() external view returns (uint256);
441 
442     /**
443      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
444      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
445      */
446     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
447 
448     /**
449      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
450      * Use along with {totalSupply} to enumerate all tokens.
451      */
452     function tokenByIndex(uint256 index) external view returns (uint256);
453 }
454 
455 
456 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
457 
458 
459 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
460 
461 
462 
463 /**
464  * @dev Collection of functions related to the address type
465  */
466 library Address {
467     /**
468      * @dev Returns true if `account` is a contract.
469      *
470      * [IMPORTANT]
471      * ====
472      * It is unsafe to assume that an address for which this function returns
473      * false is an externally-owned account (EOA) and not a contract.
474      *
475      * Among others, `isContract` will return false for the following
476      * types of addresses:
477      *
478      *  - an externally-owned account
479      *  - a contract in construction
480      *  - an address where a contract will be created
481      *  - an address where a contract lived, but was destroyed
482      * ====
483      */
484     function isContract(address account) internal view returns (bool) {
485         // This method relies on extcodesize, which returns 0 for contracts in
486         // construction, since the code is only stored at the end of the
487         // constructor execution.
488 
489         uint256 size;
490         assembly {
491             size := extcodesize(account)
492         }
493         return size > 0;
494     }
495 
496     /**
497      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
498      * `recipient`, forwarding all available gas and reverting on errors.
499      *
500      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
501      * of certain opcodes, possibly making contracts go over the 2300 gas limit
502      * imposed by `transfer`, making them unable to receive funds via
503      * `transfer`. {sendValue} removes this limitation.
504      *
505      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
506      *
507      * IMPORTANT: because control is transferred to `recipient`, care must be
508      * taken to not create reentrancy vulnerabilities. Consider using
509      * {ReentrancyGuard} or the
510      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
511      */
512     function sendValue(address payable recipient, uint256 amount) internal {
513         require(address(this).balance >= amount, "Address: insufficient balance");
514 
515         (bool success, ) = recipient.call{value: amount}("");
516         require(success, "Address: unable to send value, recipient may have reverted");
517     }
518 
519     /**
520      * @dev Performs a Solidity function call using a low level `call`. A
521      * plain `call` is an unsafe replacement for a function call: use this
522      * function instead.
523      *
524      * If `target` reverts with a revert reason, it is bubbled up by this
525      * function (like regular Solidity function calls).
526      *
527      * Returns the raw returned data. To convert to the expected return value,
528      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
529      *
530      * Requirements:
531      *
532      * - `target` must be a contract.
533      * - calling `target` with `data` must not revert.
534      *
535      * _Available since v3.1._
536      */
537     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
538         return functionCall(target, data, "Address: low-level call failed");
539     }
540 
541     /**
542      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
543      * `errorMessage` as a fallback revert reason when `target` reverts.
544      *
545      * _Available since v3.1._
546      */
547     function functionCall(
548         address target,
549         bytes memory data,
550         string memory errorMessage
551     ) internal returns (bytes memory) {
552         return functionCallWithValue(target, data, 0, errorMessage);
553     }
554 
555     /**
556      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
557      * but also transferring `value` wei to `target`.
558      *
559      * Requirements:
560      *
561      * - the calling contract must have an ETH balance of at least `value`.
562      * - the called Solidity function must be `payable`.
563      *
564      * _Available since v3.1._
565      */
566     function functionCallWithValue(
567         address target,
568         bytes memory data,
569         uint256 value
570     ) internal returns (bytes memory) {
571         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
572     }
573 
574     /**
575      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
576      * with `errorMessage` as a fallback revert reason when `target` reverts.
577      *
578      * _Available since v3.1._
579      */
580     function functionCallWithValue(
581         address target,
582         bytes memory data,
583         uint256 value,
584         string memory errorMessage
585     ) internal returns (bytes memory) {
586         require(address(this).balance >= value, "Address: insufficient balance for call");
587         require(isContract(target), "Address: call to non-contract");
588 
589         (bool success, bytes memory returndata) = target.call{value: value}(data);
590         return verifyCallResult(success, returndata, errorMessage);
591     }
592 
593     /**
594      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
595      * but performing a static call.
596      *
597      * _Available since v3.3._
598      */
599     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
600         return functionStaticCall(target, data, "Address: low-level static call failed");
601     }
602 
603     /**
604      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
605      * but performing a static call.
606      *
607      * _Available since v3.3._
608      */
609     function functionStaticCall(
610         address target,
611         bytes memory data,
612         string memory errorMessage
613     ) internal view returns (bytes memory) {
614         require(isContract(target), "Address: static call to non-contract");
615 
616         (bool success, bytes memory returndata) = target.staticcall(data);
617         return verifyCallResult(success, returndata, errorMessage);
618     }
619 
620     /**
621      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
622      * but performing a delegate call.
623      *
624      * _Available since v3.4._
625      */
626     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
627         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
628     }
629 
630     /**
631      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
632      * but performing a delegate call.
633      *
634      * _Available since v3.4._
635      */
636     function functionDelegateCall(
637         address target,
638         bytes memory data,
639         string memory errorMessage
640     ) internal returns (bytes memory) {
641         require(isContract(target), "Address: delegate call to non-contract");
642 
643         (bool success, bytes memory returndata) = target.delegatecall(data);
644         return verifyCallResult(success, returndata, errorMessage);
645     }
646 
647     /**
648      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
649      * revert reason using the provided one.
650      *
651      * _Available since v4.3._
652      */
653     function verifyCallResult(
654         bool success,
655         bytes memory returndata,
656         string memory errorMessage
657     ) internal pure returns (bytes memory) {
658         if (success) {
659             return returndata;
660         } else {
661             // Look for revert reason and bubble it up if present
662             if (returndata.length > 0) {
663                 // The easiest way to bubble the revert reason is using memory via assembly
664 
665                 assembly {
666                     let returndata_size := mload(returndata)
667                     revert(add(32, returndata), returndata_size)
668                 }
669             } else {
670                 revert(errorMessage);
671             }
672         }
673     }
674 }
675 
676 
677 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.2
678 
679 
680 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
681 
682 
683 
684 /**
685  * @dev Implementation of the {IERC165} interface.
686  *
687  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
688  * for the additional interface id that will be supported. For example:
689  *
690  * ```solidity
691  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
692  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
693  * }
694  * ```
695  *
696  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
697  */
698 abstract contract ERC165 is IERC165 {
699     /**
700      * @dev See {IERC165-supportsInterface}.
701      */
702     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
703         return interfaceId == type(IERC165).interfaceId;
704     }
705 }
706 
707 
708 // File contracts/ERC721A.sol
709 
710 
711 // Creator: Chiru Labs
712 
713 
714 /**
715  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
716  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
717  *
718  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
719  *
720  * Does not support burning tokens to address(0).
721  *
722  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
723  */
724 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
725     using Address for address;
726     using Strings for uint256;
727 
728     struct TokenOwnership {
729         address addr;
730         uint64 startTimestamp;
731     }
732 
733     struct AddressData {
734         uint128 balance;
735         uint128 numberMinted;
736     }
737 
738     uint256 internal currentIndex = 1;
739 
740     // Token name
741     string private _name;
742 
743     // Token symbol
744     string private _symbol;
745 
746     // Mapping from token ID to ownership details
747     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
748     mapping(uint256 => TokenOwnership) internal _ownerships;
749 
750     // Mapping owner address to address data
751     mapping(address => AddressData) private _addressData;
752 
753     // Mapping from token ID to approved address
754     mapping(uint256 => address) private _tokenApprovals;
755 
756     // Mapping from owner to operator approvals
757     mapping(address => mapping(address => bool)) private _operatorApprovals;
758 
759     constructor(string memory name_, string memory symbol_) {
760         _name = name_;
761         _symbol = symbol_;
762     }
763 
764     /**
765      * @dev See {IERC721Enumerable-totalSupply}.
766      */
767     function totalSupply() public view override returns (uint256) {
768         return currentIndex;
769     }
770 
771     /**
772      * @dev See {IERC721Enumerable-tokenByIndex}.
773      */
774     function tokenByIndex(uint256 index) public view override returns (uint256) {
775         require(index < totalSupply(), 'ERC721A: global index out of bounds');
776         return index;
777     }
778 
779     /**
780      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
781      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
782      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
783      */
784     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
785         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
786         uint256 numMintedSoFar = totalSupply();
787         uint256 tokenIdsIdx = 0;
788         address currOwnershipAddr = address(0);
789         for (uint256 i = 0; i < numMintedSoFar; i++) {
790             TokenOwnership memory ownership = _ownerships[i];
791             if (ownership.addr != address(0)) {
792                 currOwnershipAddr = ownership.addr;
793             }
794             if (currOwnershipAddr == owner) {
795                 if (tokenIdsIdx == index) {
796                     return i;
797                 }
798                 tokenIdsIdx++;
799             }
800         }
801         revert('ERC721A: unable to get token of owner by index');
802     }
803 
804     /**
805      * @dev See {IERC165-supportsInterface}.
806      */
807     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
808         return
809             interfaceId == type(IERC721).interfaceId ||
810             interfaceId == type(IERC721Metadata).interfaceId ||
811             interfaceId == type(IERC721Enumerable).interfaceId ||
812             super.supportsInterface(interfaceId);
813     }
814 
815     /**
816      * @dev See {IERC721-balanceOf}.
817      */
818     function balanceOf(address owner) public view override returns (uint256) {
819         require(owner != address(0), 'ERC721A: balance query for the zero address');
820         return uint256(_addressData[owner].balance);
821     }
822 
823     function _numberMinted(address owner) internal view returns (uint256) {
824         require(owner != address(0), 'ERC721A: number minted query for the zero address');
825         return uint256(_addressData[owner].numberMinted);
826     }
827 
828     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
829         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
830 
831         for (uint256 curr = tokenId; ; curr--) {
832             TokenOwnership memory ownership = _ownerships[curr];
833             if (ownership.addr != address(0)) {
834                 return ownership;
835             }
836         }
837 
838         revert('ERC721A: unable to determine the owner of token');
839     }
840 
841     /**
842      * @dev See {IERC721-ownerOf}.
843      */
844     function ownerOf(uint256 tokenId) public view override returns (address) {
845         return ownershipOf(tokenId).addr;
846     }
847 
848     /**
849      * @dev See {IERC721Metadata-name}.
850      */
851     function name() public view virtual override returns (string memory) {
852         return _name;
853     }
854 
855     /**
856      * @dev See {IERC721Metadata-symbol}.
857      */
858     function symbol() public view virtual override returns (string memory) {
859         return _symbol;
860     }
861 
862     /**
863      * @dev See {IERC721Metadata-tokenURI}.
864      */
865     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
866         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
867 
868         string memory baseURI = _baseURI();
869         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
870     }
871 
872     /**
873      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
874      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
875      * by default, can be overriden in child contracts.
876      */
877     function _baseURI() internal view virtual returns (string memory) {
878         return '';
879     }
880 
881     /**
882      * @dev See {IERC721-approve}.
883      */
884     function approve(address to, uint256 tokenId) public override {
885         address owner = ERC721A.ownerOf(tokenId);
886         require(to != owner, 'ERC721A: approval to current owner');
887 
888         require(
889             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
890             'ERC721A: approve caller is not owner nor approved for all'
891         );
892 
893         _approve(to, tokenId, owner);
894     }
895 
896     /**
897      * @dev See {IERC721-getApproved}.
898      */
899     function getApproved(uint256 tokenId) public view override returns (address) {
900         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
901 
902         return _tokenApprovals[tokenId];
903     }
904 
905     /**
906      * @dev See {IERC721-setApprovalForAll}.
907      */
908     function setApprovalForAll(address operator, bool approved) public override {
909         require(operator != _msgSender(), 'ERC721A: approve to caller');
910 
911         _operatorApprovals[_msgSender()][operator] = approved;
912         emit ApprovalForAll(_msgSender(), operator, approved);
913     }
914 
915     /**
916      * @dev See {IERC721-isApprovedForAll}.
917      */
918     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
919         return _operatorApprovals[owner][operator];
920     }
921 
922     /**
923      * @dev See {IERC721-transferFrom}.
924      */
925     function transferFrom(
926         address from,
927         address to,
928         uint256 tokenId
929     ) public override {
930         _transfer(from, to, tokenId);
931     }
932 
933     /**
934      * @dev See {IERC721-safeTransferFrom}.
935      */
936     function safeTransferFrom(
937         address from,
938         address to,
939         uint256 tokenId
940     ) public override {
941         safeTransferFrom(from, to, tokenId, '');
942     }
943 
944     /**
945      * @dev See {IERC721-safeTransferFrom}.
946      */
947     function safeTransferFrom(
948         address from,
949         address to,
950         uint256 tokenId,
951         bytes memory _data
952     ) public override {
953         _transfer(from, to, tokenId);
954         require(
955             _checkOnERC721Received(from, to, tokenId, _data),
956             'ERC721A: transfer to non ERC721Receiver implementer'
957         );
958     }
959 
960     /**
961      * @dev Returns whether `tokenId` exists.
962      *
963      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
964      *
965      * Tokens start existing when they are minted (`_mint`),
966      */
967     function _exists(uint256 tokenId) internal view returns (bool) {
968         return tokenId < currentIndex;
969     }
970 
971     function _safeMint(address to, uint256 quantity) internal {
972         _safeMint(to, quantity, '');
973     }
974 
975     /**
976      * @dev Mints `quantity` tokens and transfers them to `to`.
977      *
978      * Requirements:
979      *
980      * - `to` cannot be the zero address.
981      * - `quantity` cannot be larger than the max batch size.
982      *
983      * Emits a {Transfer} event.
984      */
985     function _safeMint(
986         address to,
987         uint256 quantity,
988         bytes memory _data
989     ) internal {
990         uint256 startTokenId = currentIndex;
991         require(to != address(0), 'ERC721A: mint to the zero address');
992         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
993         require(!_exists(startTokenId), 'ERC721A: token already minted');
994         require(quantity > 0, 'ERC721A: quantity must be greater 0');
995 
996         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
997 
998         AddressData memory addressData = _addressData[to];
999         _addressData[to] = AddressData(
1000             addressData.balance + uint128(quantity),
1001             addressData.numberMinted + uint128(quantity)
1002         );
1003         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1004 
1005         uint256 updatedIndex = startTokenId;
1006 
1007         for (uint256 i = 0; i < quantity; i++) {
1008             emit Transfer(address(0), to, updatedIndex);
1009             require(
1010                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1011                 'ERC721A: transfer to non ERC721Receiver implementer'
1012             );
1013             updatedIndex++;
1014         }
1015 
1016         currentIndex = updatedIndex;
1017         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1018     }
1019 
1020     /**
1021      * @dev Transfers `tokenId` from `from` to `to`.
1022      *
1023      * Requirements:
1024      *
1025      * - `to` cannot be the zero address.
1026      * - `tokenId` token must be owned by `from`.
1027      *
1028      * Emits a {Transfer} event.
1029      */
1030     function _transfer(
1031         address from,
1032         address to,
1033         uint256 tokenId
1034     ) private {
1035         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1036 
1037         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1038             getApproved(tokenId) == _msgSender() ||
1039             isApprovedForAll(prevOwnership.addr, _msgSender()));
1040 
1041         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1042 
1043         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1044         require(to != address(0), 'ERC721A: transfer to the zero address');
1045 
1046         _beforeTokenTransfers(from, to, tokenId, 1);
1047 
1048         // Clear approvals from the previous owner
1049         _approve(address(0), tokenId, prevOwnership.addr);
1050 
1051         // Underflow of the sender's balance is impossible because we check for
1052         // ownership above and the recipient's balance can't realistically overflow.
1053         unchecked {
1054             _addressData[from].balance -= 1;
1055             _addressData[to].balance += 1;
1056         }
1057 
1058         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1059 
1060         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1061         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1062         uint256 nextTokenId = tokenId + 1;
1063         if (_ownerships[nextTokenId].addr == address(0)) {
1064             if (_exists(nextTokenId)) {
1065                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1066             }
1067         }
1068 
1069         emit Transfer(from, to, tokenId);
1070         _afterTokenTransfers(from, to, tokenId, 1);
1071     }
1072 
1073     /**
1074      * @dev Approve `to` to operate on `tokenId`
1075      *
1076      * Emits a {Approval} event.
1077      */
1078     function _approve(
1079         address to,
1080         uint256 tokenId,
1081         address owner
1082     ) private {
1083         _tokenApprovals[tokenId] = to;
1084         emit Approval(owner, to, tokenId);
1085     }
1086 
1087     /**
1088      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1089      * The call is not executed if the target address is not a contract.
1090      *
1091      * @param from address representing the previous owner of the given token ID
1092      * @param to target address that will receive the tokens
1093      * @param tokenId uint256 ID of the token to be transferred
1094      * @param _data bytes optional data to send along with the call
1095      * @return bool whether the call correctly returned the expected magic value
1096      */
1097     function _checkOnERC721Received(
1098         address from,
1099         address to,
1100         uint256 tokenId,
1101         bytes memory _data
1102     ) private returns (bool) {
1103         if (to.isContract()) {
1104             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1105                 return retval == IERC721Receiver(to).onERC721Received.selector;
1106             } catch (bytes memory reason) {
1107                 if (reason.length == 0) {
1108                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1109                 } else {
1110                     assembly {
1111                         revert(add(32, reason), mload(reason))
1112                     }
1113                 }
1114             }
1115         } else {
1116             return true;
1117         }
1118     }
1119 
1120     /**
1121      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1122      *
1123      * startTokenId - the first token id to be transferred
1124      * quantity - the amount to be transferred
1125      *
1126      * Calling conditions:
1127      *
1128      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1129      * transferred to `to`.
1130      * - When `from` is zero, `tokenId` will be minted for `to`.
1131      */
1132     function _beforeTokenTransfers(
1133         address from,
1134         address to,
1135         uint256 startTokenId,
1136         uint256 quantity
1137     ) internal virtual {}
1138 
1139     /**
1140      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1141      * minting.
1142      *
1143      * startTokenId - the first token id to be transferred
1144      * quantity - the amount to be transferred
1145      *
1146      * Calling conditions:
1147      *
1148      * - when `from` and `to` are both non-zero.
1149      * - `from` and `to` are never both zero.
1150      */
1151     function _afterTokenTransfers(
1152         address from,
1153         address to,
1154         uint256 startTokenId,
1155         uint256 quantity
1156     ) internal virtual {}
1157 }
1158 
1159 
1160 // File contracts/NotPrimates.sol
1161 
1162 
1163 contract NotPrimates is ERC721A, Ownable {
1164 
1165     string public baseURI = "";
1166     string public contractURI = "";
1167     string public constant baseExtension = ".json";
1168     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1169 
1170     uint256 public constant MAX_PER_TX_FREE = 5;
1171     uint256 public constant MAX_PER_TX = 10;
1172     uint256 public constant FREE_MAX_SUPPLY = 4000;
1173     uint256 public constant MAX_SUPPLY = 5000;
1174     uint256 public price = 0.005 ether;
1175 
1176     bool public paused = true;
1177 
1178     constructor() ERC721A("NotPrimates", "NPM") {}
1179 
1180     function mint(uint256 _amount) external payable {
1181         address _caller = _msgSender();
1182         require(!paused, "Paused");
1183         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1184         require(_amount > 0, "No 0 mints");
1185         require(tx.origin == _caller, "No contracts");
1186 
1187         if(FREE_MAX_SUPPLY >= totalSupply()){
1188             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
1189         }else{
1190             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1191             require(_amount * price == msg.value, "Invalid funds provided");
1192         }
1193 
1194         _safeMint(_caller, _amount);
1195     }
1196 
1197     function setCost(uint256 _newCost) public onlyOwner {
1198         price = _newCost;
1199     }
1200 
1201     function isApprovedForAll(address owner, address operator)
1202         override
1203         public
1204         view
1205         returns (bool)
1206     {
1207         // Whitelist OpenSea proxy contract for easy trading.
1208         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1209         if (address(proxyRegistry.proxies(owner)) == operator) {
1210             return true;
1211         }
1212 
1213         return super.isApprovedForAll(owner, operator);
1214     }
1215 
1216     function withdraw() external onlyOwner {
1217         uint256 balance = address(this).balance;
1218         (bool success, ) = _msgSender().call{value: balance}("");
1219         require(success, "Failed to send");
1220     }
1221 
1222     function setupOS() external onlyOwner {
1223         _safeMint(_msgSender(), 1);
1224     }
1225 
1226     function pause(bool _state) external onlyOwner {
1227         paused = _state;
1228     }
1229 
1230     function setBaseURI(string memory baseURI_) external onlyOwner {
1231         baseURI = baseURI_;
1232     }
1233 
1234     function setContractURI(string memory _contractURI) external onlyOwner {
1235         contractURI = _contractURI;
1236     }
1237 
1238     function Currentprice() public view returns (uint256){
1239         if (FREE_MAX_SUPPLY >= totalSupply()) {
1240             return 0;
1241         }else{
1242             return price;
1243         }
1244     }
1245 
1246     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1247         require(_exists(_tokenId), "Token does not exist.");
1248         return bytes(baseURI).length > 0 ? string(
1249             abi.encodePacked(
1250               baseURI,
1251               Strings.toString(_tokenId),
1252               baseExtension
1253             )
1254         ) : "";
1255     }
1256 }
1257 
1258 contract OwnableDelegateProxy { }
1259 contract ProxyRegistry {
1260     mapping(address => OwnableDelegateProxy) public proxies;
1261 }