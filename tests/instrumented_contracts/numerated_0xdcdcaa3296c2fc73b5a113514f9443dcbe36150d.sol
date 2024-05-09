1 /**
2  *Submitted for verification at Etherscan.io on 2022-04-10
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // thereisnoBanksy
7 // made for NFT community with love
8 // There's no Banksy NFTs, there's NFT community only
9 // 1974 Nfts
10 // Free mint
11 // Max 2 x Transaction
12 // There's no Banksy NFTs, there's NFT community only There's no Banksy NFTs, there's NFT community only There's no Banksy NFTs, there's NFT community only
13 // There's no Banksy NFTs, there's NFT community only There's no Banksy NFTs, there's NFT community only There's no Banksy NFTs, there's NFT community only
14 // There's no Banksy NFTs, there's NFT community only There's no Banksy NFTs, there's NFT community only There's no Banksy NFTs, there's NFT community only
15 // There's no Banksy NFTs, there's NFT community only There's no Banksy NFTs, there's NFT community only There's no Banksy NFTs, there's NFT community only
16 // There's no Banksy NFTs, there's NFT community only There's no Banksy NFTs, there's NFT community only There's no Banksy NFTs, there's NFT community only
17 // There's no Banksy NFTs, there's NFT community only There's no Banksy NFTs, there's NFT community only There's no Banksy NFTs, there's NFT community only
18 // There's no Banksy NFTs, there's NFT community only There's no Banksy NFTs, there's NFT community only There's no Banksy NFTs, there's NFT community only
19 // There's no Banksy NFTs, there's NFT community only There's no Banksy NFTs, there's NFT community only There's no Banksy NFTs, there's NFT community only
20 // There's no Banksy NFTs, there's NFT community only There's no Banksy NFTs, there's NFT community only There's no Banksy NFTs, there's NFT community only
21 // There's no Banksy NFTs, there's NFT community only There's no Banksy NFTs, there's NFT community only There's no Banksy NFTs, there's NFT community only
22 // There's no Banksy NFTs, there's NFT community only There's no Banksy NFTs, there's NFT community only There's no Banksy NFTs, there's NFT community only
23 // There's no Banksy NFTs, there's NFT community only There's no Banksy NFTs, there's NFT community only There's no Banksy NFTs, there's NFT community only
24 // There's no Banksy NFTs, there's NFT community only There's no Banksy NFTs, there's NFT community only There's no Banksy NFTs, there's NFT community only
25 // There's no Banksy NFTs, there's NFT community only There's no Banksy NFTs, there's NFT community only There's no Banksy NFTs, there's NFT community only
26 
27 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
28 
29 pragma solidity ^0.8.0;
30 
31 /**
32  * @dev String operations.
33  */
34 library Strings {
35     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
36 
37     /**
38      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
39      */
40     function toString(uint256 value) internal pure returns (string memory) {
41         // Inspired by OraclizeAPI's implementation - MIT licence
42         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
43 
44         if (value == 0) {
45             return "0";
46         }
47         uint256 temp = value;
48         uint256 digits;
49         while (temp != 0) {
50             digits++;
51             temp /= 10;
52         }
53         bytes memory buffer = new bytes(digits);
54         while (value != 0) {
55             digits -= 1;
56             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
57             value /= 10;
58         }
59         return string(buffer);
60     }
61 
62     /**
63      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
64      */
65     function toHexString(uint256 value) internal pure returns (string memory) {
66         if (value == 0) {
67             return "0x00";
68         }
69         uint256 temp = value;
70         uint256 length = 0;
71         while (temp != 0) {
72             length++;
73             temp >>= 8;
74         }
75         return toHexString(value, length);
76     }
77 
78     /**
79      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
80      */
81     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
82         bytes memory buffer = new bytes(2 * length + 2);
83         buffer[0] = "0";
84         buffer[1] = "x";
85         for (uint256 i = 2 * length + 1; i > 1; --i) {
86             buffer[i] = _HEX_SYMBOLS[value & 0xf];
87             value >>= 4;
88         }
89         require(value == 0, "Strings: hex length insufficient");
90         return string(buffer);
91     }
92 }
93 
94 // File: @openzeppelin/contracts/utils/Context.sol
95 
96 
97 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
98 
99 pragma solidity ^0.8.0;
100 
101 /**
102  * @dev Provides information about the current execution context, including the
103  * sender of the transaction and its data. While these are generally available
104  * via msg.sender and msg.data, they should not be accessed in such a direct
105  * manner, since when dealing with meta-transactions the account sending and
106  * paying for execution may not be the actual sender (as far as an application
107  * is concerned).
108  *
109  * This contract is only required for intermediate, library-like contracts.
110  */
111 abstract contract Context {
112     function _msgSender() internal view virtual returns (address) {
113         return msg.sender;
114     }
115 
116     function _msgData() internal view virtual returns (bytes calldata) {
117         return msg.data;
118     }
119 }
120 
121 // File: @openzeppelin/contracts/access/Ownable.sol
122 
123 
124 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
125 
126 pragma solidity ^0.8.0;
127 
128 
129 /**
130  * @dev Contract module which provides a basic access control mechanism, where
131  * there is an account (an owner) that can be granted exclusive access to
132  * specific functions.
133  *
134  * By default, the owner account will be the one that deploys the contract. This
135  * can later be changed with {transferOwnership}.
136  *
137  * This module is used through inheritance. It will make available the modifier
138  * `onlyOwner`, which can be applied to your functions to restrict their use to
139  * the owner.
140  */
141 abstract contract Ownable is Context {
142     address private _owner;
143 
144     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
145 
146     /**
147      * @dev Initializes the contract setting the deployer as the initial owner.
148      */
149     constructor() {
150         _transferOwnership(_msgSender());
151     }
152 
153     /**
154      * @dev Returns the address of the current owner.
155      */
156     function owner() public view virtual returns (address) {
157         return _owner;
158     }
159 
160     /**
161      * @dev Throws if called by any account other than the owner.
162      */
163     modifier onlyOwner() {
164         require(owner() == _msgSender(), "Ownable: caller is not the owner");
165         _;
166     }
167 
168     /**
169      * @dev Leaves the contract without owner. It will not be possible to call
170      * `onlyOwner` functions anymore. Can only be called by the current owner.
171      *
172      * NOTE: Renouncing ownership will leave the contract without an owner,
173      * thereby removing any functionality that is only available to the owner.
174      */
175     function renounceOwnership() public virtual onlyOwner {
176         _transferOwnership(address(0));
177     }
178 
179     /**
180      * @dev Transfers ownership of the contract to a new account (`newOwner`).
181      * Can only be called by the current owner.
182      */
183     function transferOwnership(address newOwner) public virtual onlyOwner {
184         require(newOwner != address(0), "Ownable: new owner is the zero address");
185         _transferOwnership(newOwner);
186     }
187 
188     /**
189      * @dev Transfers ownership of the contract to a new account (`newOwner`).
190      * Internal function without access restriction.
191      */
192     function _transferOwnership(address newOwner) internal virtual {
193         address oldOwner = _owner;
194         _owner = newOwner;
195         emit OwnershipTransferred(oldOwner, newOwner);
196     }
197 }
198 
199 // File: @openzeppelin/contracts/utils/Address.sol
200 
201 
202 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
203 
204 pragma solidity ^0.8.0;
205 
206 /**
207  * @dev Collection of functions related to the address type
208  */
209 library Address {
210     /**
211      * @dev Returns true if `account` is a contract.
212      *
213      * [IMPORTANT]
214      * ====
215      * It is unsafe to assume that an address for which this function returns
216      * false is an externally-owned account (EOA) and not a contract.
217      *
218      * Among others, `isContract` will return false for the following
219      * types of addresses:
220      *
221      *  - an externally-owned account
222      *  - a contract in construction
223      *  - an address where a contract will be created
224      *  - an address where a contract lived, but was destroyed
225      * ====
226      */
227     function isContract(address account) internal view returns (bool) {
228         // This method relies on extcodesize, which returns 0 for contracts in
229         // construction, since the code is only stored at the end of the
230         // constructor execution.
231 
232         uint256 size;
233         assembly {
234             size := extcodesize(account)
235         }
236         return size > 0;
237     }
238 
239     /**
240      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
241      * `recipient`, forwarding all available gas and reverting on errors.
242      *
243      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
244      * of certain opcodes, possibly making contracts go over the 2300 gas limit
245      * imposed by `transfer`, making them unable to receive funds via
246      * `transfer`. {sendValue} removes this limitation.
247      *
248      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
249      *
250      * IMPORTANT: because control is transferred to `recipient`, care must be
251      * taken to not create reentrancy vulnerabilities. Consider using
252      * {ReentrancyGuard} or the
253      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
254      */
255     function sendValue(address payable recipient, uint256 amount) internal {
256         require(address(this).balance >= amount, "Address: insufficient balance");
257 
258         (bool success, ) = recipient.call{value: amount}("");
259         require(success, "Address: unable to send value, recipient may have reverted");
260     }
261 
262     /**
263      * @dev Performs a Solidity function call using a low level `call`. A
264      * plain `call` is an unsafe replacement for a function call: use this
265      * function instead.
266      *
267      * If `target` reverts with a revert reason, it is bubbled up by this
268      * function (like regular Solidity function calls).
269      *
270      * Returns the raw returned data. To convert to the expected return value,
271      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
272      *
273      * Requirements:
274      *
275      * - `target` must be a contract.
276      * - calling `target` with `data` must not revert.
277      *
278      * _Available since v3.1._
279      */
280     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
281         return functionCall(target, data, "Address: low-level call failed");
282     }
283 
284     /**
285      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
286      * `errorMessage` as a fallback revert reason when `target` reverts.
287      *
288      * _Available since v3.1._
289      */
290     function functionCall(
291         address target,
292         bytes memory data,
293         string memory errorMessage
294     ) internal returns (bytes memory) {
295         return functionCallWithValue(target, data, 0, errorMessage);
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
300      * but also transferring `value` wei to `target`.
301      *
302      * Requirements:
303      *
304      * - the calling contract must have an ETH balance of at least `value`.
305      * - the called Solidity function must be `payable`.
306      *
307      * _Available since v3.1._
308      */
309     function functionCallWithValue(
310         address target,
311         bytes memory data,
312         uint256 value
313     ) internal returns (bytes memory) {
314         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
319      * with `errorMessage` as a fallback revert reason when `target` reverts.
320      *
321      * _Available since v3.1._
322      */
323     function functionCallWithValue(
324         address target,
325         bytes memory data,
326         uint256 value,
327         string memory errorMessage
328     ) internal returns (bytes memory) {
329         require(address(this).balance >= value, "Address: insufficient balance for call");
330         require(isContract(target), "Address: call to non-contract");
331 
332         (bool success, bytes memory returndata) = target.call{value: value}(data);
333         return verifyCallResult(success, returndata, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but performing a static call.
339      *
340      * _Available since v3.3._
341      */
342     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
343         return functionStaticCall(target, data, "Address: low-level static call failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
348      * but performing a static call.
349      *
350      * _Available since v3.3._
351      */
352     function functionStaticCall(
353         address target,
354         bytes memory data,
355         string memory errorMessage
356     ) internal view returns (bytes memory) {
357         require(isContract(target), "Address: static call to non-contract");
358 
359         (bool success, bytes memory returndata) = target.staticcall(data);
360         return verifyCallResult(success, returndata, errorMessage);
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
365      * but performing a delegate call.
366      *
367      * _Available since v3.4._
368      */
369     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
370         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
375      * but performing a delegate call.
376      *
377      * _Available since v3.4._
378      */
379     function functionDelegateCall(
380         address target,
381         bytes memory data,
382         string memory errorMessage
383     ) internal returns (bytes memory) {
384         require(isContract(target), "Address: delegate call to non-contract");
385 
386         (bool success, bytes memory returndata) = target.delegatecall(data);
387         return verifyCallResult(success, returndata, errorMessage);
388     }
389 
390     /**
391      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
392      * revert reason using the provided one.
393      *
394      * _Available since v4.3._
395      */
396     function verifyCallResult(
397         bool success,
398         bytes memory returndata,
399         string memory errorMessage
400     ) internal pure returns (bytes memory) {
401         if (success) {
402             return returndata;
403         } else {
404             // Look for revert reason and bubble it up if present
405             if (returndata.length > 0) {
406                 // The easiest way to bubble the revert reason is using memory via assembly
407 
408                 assembly {
409                     let returndata_size := mload(returndata)
410                     revert(add(32, returndata), returndata_size)
411                 }
412             } else {
413                 revert(errorMessage);
414             }
415         }
416     }
417 }
418 
419 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
420 
421 
422 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
423 
424 pragma solidity ^0.8.0;
425 
426 /**
427  * @title ERC721 token receiver interface
428  * @dev Interface for any contract that wants to support safeTransfers
429  * from ERC721 asset contracts.
430  */
431 interface IERC721Receiver {
432     /**
433      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
434      * by `operator` from `from`, this function is called.
435      *
436      * It must return its Solidity selector to confirm the token transfer.
437      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
438      *
439      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
440      */
441     function onERC721Received(
442         address operator,
443         address from,
444         uint256 tokenId,
445         bytes calldata data
446     ) external returns (bytes4);
447 }
448 
449 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
450 
451 
452 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
453 
454 pragma solidity ^0.8.0;
455 
456 /**
457  * @dev Interface of the ERC165 standard, as defined in the
458  * https://eips.ethereum.org/EIPS/eip-165[EIP].
459  *
460  * Implementers can declare support of contract interfaces, which can then be
461  * queried by others ({ERC165Checker}).
462  *
463  * For an implementation, see {ERC165}.
464  */
465 interface IERC165 {
466     /**
467      * @dev Returns true if this contract implements the interface defined by
468      * `interfaceId`. See the corresponding
469      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
470      * to learn more about how these ids are created.
471      *
472      * This function call must use less than 30 000 gas.
473      */
474     function supportsInterface(bytes4 interfaceId) external view returns (bool);
475 }
476 
477 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
478 
479 
480 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
481 
482 pragma solidity ^0.8.0;
483 
484 
485 /**
486  * @dev Implementation of the {IERC165} interface.
487  *
488  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
489  * for the additional interface id that will be supported. For example:
490  *
491  * ```solidity
492  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
493  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
494  * }
495  * ```
496  *
497  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
498  */
499 abstract contract ERC165 is IERC165 {
500     /**
501      * @dev See {IERC165-supportsInterface}.
502      */
503     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
504         return interfaceId == type(IERC165).interfaceId;
505     }
506 }
507 
508 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
509 
510 
511 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
512 
513 pragma solidity ^0.8.0;
514 
515 
516 /**
517  * @dev Required interface of an ERC721 compliant contract.
518  */
519 interface IERC721 is IERC165 {
520     /**
521      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
522      */
523     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
524 
525     /**
526      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
527      */
528     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
529 
530     /**
531      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
532      */
533     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
534 
535     /**
536      * @dev Returns the number of tokens in ``owner``'s account.
537      */
538     function balanceOf(address owner) external view returns (uint256 balance);
539 
540     /**
541      * @dev Returns the owner of the `tokenId` token.
542      *
543      * Requirements:
544      *
545      * - `tokenId` must exist.
546      */
547     function ownerOf(uint256 tokenId) external view returns (address owner);
548 
549     /**
550      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
551      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
552      *
553      * Requirements:
554      *
555      * - `from` cannot be the zero address.
556      * - `to` cannot be the zero address.
557      * - `tokenId` token must exist and be owned by `from`.
558      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
559      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
560      *
561      * Emits a {Transfer} event.
562      */
563     function safeTransferFrom(
564         address from,
565         address to,
566         uint256 tokenId
567     ) external;
568 
569     /**
570      * @dev Transfers `tokenId` token from `from` to `to`.
571      *
572      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
573      *
574      * Requirements:
575      *
576      * - `from` cannot be the zero address.
577      * - `to` cannot be the zero address.
578      * - `tokenId` token must be owned by `from`.
579      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
580      *
581      * Emits a {Transfer} event.
582      */
583     function transferFrom(
584         address from,
585         address to,
586         uint256 tokenId
587     ) external;
588 
589     /**
590      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
591      * The approval is cleared when the token is transferred.
592      *
593      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
594      *
595      * Requirements:
596      *
597      * - The caller must own the token or be an approved operator.
598      * - `tokenId` must exist.
599      *
600      * Emits an {Approval} event.
601      */
602     function approve(address to, uint256 tokenId) external;
603 
604     /**
605      * @dev Returns the account approved for `tokenId` token.
606      *
607      * Requirements:
608      *
609      * - `tokenId` must exist.
610      */
611     function getApproved(uint256 tokenId) external view returns (address operator);
612 
613     /**
614      * @dev Approve or remove `operator` as an operator for the caller.
615      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
616      *
617      * Requirements:
618      *
619      * - The `operator` cannot be the caller.
620      *
621      * Emits an {ApprovalForAll} event.
622      */
623     function setApprovalForAll(address operator, bool _approved) external;
624 
625     /**
626      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
627      *
628      * See {setApprovalForAll}
629      */
630     function isApprovedForAll(address owner, address operator) external view returns (bool);
631 
632     /**
633      * @dev Safely transfers `tokenId` token from `from` to `to`.
634      *
635      * Requirements:
636      *
637      * - `from` cannot be the zero address.
638      * - `to` cannot be the zero address.
639      * - `tokenId` token must exist and be owned by `from`.
640      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
641      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
642      *
643      * Emits a {Transfer} event.
644      */
645     function safeTransferFrom(
646         address from,
647         address to,
648         uint256 tokenId,
649         bytes calldata data
650     ) external;
651 }
652 
653 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
654 
655 
656 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
657 
658 pragma solidity ^0.8.0;
659 
660 
661 /**
662  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
663  * @dev See https://eips.ethereum.org/EIPS/eip-721
664  */
665 interface IERC721Enumerable is IERC721 {
666     /**
667      * @dev Returns the total amount of tokens stored by the contract.
668      */
669     function totalSupply() external view returns (uint256);
670 
671     /**
672      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
673      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
674      */
675     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
676 
677     /**
678      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
679      * Use along with {totalSupply} to enumerate all tokens.
680      */
681     function tokenByIndex(uint256 index) external view returns (uint256);
682 }
683 
684 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
685 
686 
687 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
688 
689 pragma solidity ^0.8.0;
690 
691 
692 /**
693  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
694  * @dev See https://eips.ethereum.org/EIPS/eip-721
695  */
696 interface IERC721Metadata is IERC721 {
697     /**
698      * @dev Returns the token collection name.
699      */
700     function name() external view returns (string memory);
701 
702     /**
703      * @dev Returns the token collection symbol.
704      */
705     function symbol() external view returns (string memory);
706 
707     /**
708      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
709      */
710     function tokenURI(uint256 tokenId) external view returns (string memory);
711 }
712 
713 
714 pragma solidity ^0.8.0;
715 
716 
717 /**
718  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
719  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
720  *
721  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
722  *
723  * Does not support burning tokens to address(0).
724  *
725  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
726  */
727 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
728     using Address for address;
729     using Strings for uint256;
730 
731     struct TokenOwnership {
732         address addr;
733         uint64 startTimestamp;
734     }
735 
736     struct AddressData {
737         uint128 balance;
738         uint128 numberMinted;
739     }
740 
741     uint256 internal currentIndex = 0;
742 
743     uint256 internal immutable maxBatchSize;
744 
745     // Token name
746     string private _name;
747 
748     // Token symbol
749     string private _symbol;
750 
751     // Mapping from token ID to ownership details
752     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
753     mapping(uint256 => TokenOwnership) internal _ownerships;
754 
755     // Mapping owner address to address data
756     mapping(address => AddressData) private _addressData;
757 
758     // Mapping from token ID to approved address
759     mapping(uint256 => address) private _tokenApprovals;
760 
761     // Mapping from owner to operator approvals
762     mapping(address => mapping(address => bool)) private _operatorApprovals;
763 
764     /**
765      * @dev
766      * `maxBatchSize` refers to how much a minter can mint at a time.
767      */
768     constructor(
769         string memory name_,
770         string memory symbol_,
771         uint256 maxBatchSize_
772     ) {
773         require(maxBatchSize_ > 0, 'ERC721A: max batch size must be nonzero');
774         _name = name_;
775         _symbol = symbol_;
776         maxBatchSize = maxBatchSize_;
777     }
778 
779     /**
780      * @dev See {IERC721Enumerable-totalSupply}.
781      */
782     function totalSupply() public view override returns (uint256) {
783         return currentIndex;
784     }
785 
786     /**
787      * @dev See {IERC721Enumerable-tokenByIndex}.
788      */
789     function tokenByIndex(uint256 index) public view override returns (uint256) {
790         require(index < totalSupply(), 'ERC721A: global index out of bounds');
791         return index;
792     }
793 
794     /**
795      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
796      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
797      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
798      */
799     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
800         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
801         uint256 numMintedSoFar = totalSupply();
802         uint256 tokenIdsIdx = 0;
803         address currOwnershipAddr = address(0);
804         for (uint256 i = 0; i < numMintedSoFar; i++) {
805             TokenOwnership memory ownership = _ownerships[i];
806             if (ownership.addr != address(0)) {
807                 currOwnershipAddr = ownership.addr;
808             }
809             if (currOwnershipAddr == owner) {
810                 if (tokenIdsIdx == index) {
811                     return i;
812                 }
813                 tokenIdsIdx++;
814             }
815         }
816         revert('ERC721A: unable to get token of owner by index');
817     }
818 
819     /**
820      * @dev See {IERC165-supportsInterface}.
821      */
822     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
823         return
824             interfaceId == type(IERC721).interfaceId ||
825             interfaceId == type(IERC721Metadata).interfaceId ||
826             interfaceId == type(IERC721Enumerable).interfaceId ||
827             super.supportsInterface(interfaceId);
828     }
829 
830     /**
831      * @dev See {IERC721-balanceOf}.
832      */
833     function balanceOf(address owner) public view override returns (uint256) {
834         require(owner != address(0), 'ERC721A: balance query for the zero address');
835         return uint256(_addressData[owner].balance);
836     }
837 
838     function _numberMinted(address owner) internal view returns (uint256) {
839         require(owner != address(0), 'ERC721A: number minted query for the zero address');
840         return uint256(_addressData[owner].numberMinted);
841     }
842 
843     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
844         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
845 
846         uint256 lowestTokenToCheck;
847         if (tokenId >= maxBatchSize) {
848             lowestTokenToCheck = tokenId - maxBatchSize + 1;
849         }
850 
851         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
852             TokenOwnership memory ownership = _ownerships[curr];
853             if (ownership.addr != address(0)) {
854                 return ownership;
855             }
856         }
857 
858         revert('ERC721A: unable to determine the owner of token');
859     }
860 
861     /**
862      * @dev See {IERC721-ownerOf}.
863      */
864     function ownerOf(uint256 tokenId) public view override returns (address) {
865         return ownershipOf(tokenId).addr;
866     }
867 
868     /**
869      * @dev See {IERC721Metadata-name}.
870      */
871     function name() public view virtual override returns (string memory) {
872         return _name;
873     }
874 
875     /**
876      * @dev See {IERC721Metadata-symbol}.
877      */
878     function symbol() public view virtual override returns (string memory) {
879         return _symbol;
880     }
881 
882     /**
883      * @dev See {IERC721Metadata-tokenURI}.
884      */
885     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
886         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
887 
888         string memory baseURI = _baseURI();
889         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
890     }
891 
892     /**
893      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
894      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
895      * by default, can be overriden in child contracts.
896      */
897     function _baseURI() internal view virtual returns (string memory) {
898         return '';
899     }
900 
901     /**
902      * @dev See {IERC721-approve}.
903      */
904     function approve(address to, uint256 tokenId) public override {
905         address owner = ERC721A.ownerOf(tokenId);
906         require(to != owner, 'ERC721A: approval to current owner');
907 
908         require(
909             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
910             'ERC721A: approve caller is not owner nor approved for all'
911         );
912 
913         _approve(to, tokenId, owner);
914     }
915 
916     /**
917      * @dev See {IERC721-getApproved}.
918      */
919     function getApproved(uint256 tokenId) public view override returns (address) {
920         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
921 
922         return _tokenApprovals[tokenId];
923     }
924 
925     /**
926      * @dev See {IERC721-setApprovalForAll}.
927      */
928     function setApprovalForAll(address operator, bool approved) public override {
929         require(operator != _msgSender(), 'ERC721A: approve to caller');
930 
931         _operatorApprovals[_msgSender()][operator] = approved;
932         emit ApprovalForAll(_msgSender(), operator, approved);
933     }
934 
935     /**
936      * @dev See {IERC721-isApprovedForAll}.
937      */
938     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
939         return _operatorApprovals[owner][operator];
940     }
941 
942     /**
943      * @dev See {IERC721-transferFrom}.
944      */
945     function transferFrom(
946         address from,
947         address to,
948         uint256 tokenId
949     ) public override {
950         _transfer(from, to, tokenId);
951     }
952 
953     /**
954      * @dev See {IERC721-safeTransferFrom}.
955      */
956     function safeTransferFrom(
957         address from,
958         address to,
959         uint256 tokenId
960     ) public override {
961         safeTransferFrom(from, to, tokenId, '');
962     }
963 
964     /**
965      * @dev See {IERC721-safeTransferFrom}.
966      */
967     function safeTransferFrom(
968         address from,
969         address to,
970         uint256 tokenId,
971         bytes memory _data
972     ) public override {
973         _transfer(from, to, tokenId);
974         require(
975             _checkOnERC721Received(from, to, tokenId, _data),
976             'ERC721A: transfer to non ERC721Receiver implementer'
977         );
978     }
979 
980     /**
981      * @dev Returns whether `tokenId` exists.
982      *
983      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
984      *
985      * Tokens start existing when they are minted (`_mint`),
986      */
987     function _exists(uint256 tokenId) internal view returns (bool) {
988         return tokenId < currentIndex;
989     }
990 
991     function _safeMint(address to, uint256 quantity) internal {
992         _safeMint(to, quantity, '');
993     }
994 
995     /**
996      * @dev Mints `quantity` tokens and transfers them to `to`.
997      *
998      * Requirements:
999      *
1000      * - `to` cannot be the zero address.
1001      * - `quantity` cannot be larger than the max batch size.
1002      *
1003      * Emits a {Transfer} event.
1004      */
1005     function _safeMint(
1006         address to,
1007         uint256 quantity,
1008         bytes memory _data
1009     ) internal {
1010         uint256 startTokenId = currentIndex;
1011         require(to != address(0), 'ERC721A: mint to the zero address');
1012         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1013         require(!_exists(startTokenId), 'ERC721A: token already minted');
1014         require(quantity <= maxBatchSize, 'ERC721A: quantity to mint too high');
1015         require(quantity > 0, 'ERC721A: quantity must be greater 0');
1016 
1017         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1018 
1019         AddressData memory addressData = _addressData[to];
1020         _addressData[to] = AddressData(
1021             addressData.balance + uint128(quantity),
1022             addressData.numberMinted + uint128(quantity)
1023         );
1024         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1025 
1026         uint256 updatedIndex = startTokenId;
1027 
1028         for (uint256 i = 0; i < quantity; i++) {
1029             emit Transfer(address(0), to, updatedIndex);
1030             require(
1031                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1032                 'ERC721A: transfer to non ERC721Receiver implementer'
1033             );
1034             updatedIndex++;
1035         }
1036 
1037         currentIndex = updatedIndex;
1038         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1039     }
1040 
1041     /**
1042      * @dev Transfers `tokenId` from `from` to `to`.
1043      *
1044      * Requirements:
1045      *
1046      * - `to` cannot be the zero address.
1047      * - `tokenId` token must be owned by `from`.
1048      *
1049      * Emits a {Transfer} event.
1050      */
1051     function _transfer(
1052         address from,
1053         address to,
1054         uint256 tokenId
1055     ) private {
1056         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1057 
1058         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1059             getApproved(tokenId) == _msgSender() ||
1060             isApprovedForAll(prevOwnership.addr, _msgSender()));
1061 
1062         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1063 
1064         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1065         require(to != address(0), 'ERC721A: transfer to the zero address');
1066 
1067         _beforeTokenTransfers(from, to, tokenId, 1);
1068 
1069         // Clear approvals from the previous owner
1070         _approve(address(0), tokenId, prevOwnership.addr);
1071 
1072         // Underflow of the sender's balance is impossible because we check for
1073         // ownership above and the recipient's balance can't realistically overflow.
1074         unchecked {
1075             _addressData[from].balance -= 1;
1076             _addressData[to].balance += 1;
1077         }
1078 
1079         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1080 
1081         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1082         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1083         uint256 nextTokenId = tokenId + 1;
1084         if (_ownerships[nextTokenId].addr == address(0)) {
1085             if (_exists(nextTokenId)) {
1086                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1087             }
1088         }
1089 
1090         emit Transfer(from, to, tokenId);
1091         _afterTokenTransfers(from, to, tokenId, 1);
1092     }
1093 
1094     /**
1095      * @dev Approve `to` to operate on `tokenId`
1096      *
1097      * Emits a {Approval} event.
1098      */
1099     function _approve(
1100         address to,
1101         uint256 tokenId,
1102         address owner
1103     ) private {
1104         _tokenApprovals[tokenId] = to;
1105         emit Approval(owner, to, tokenId);
1106     }
1107 
1108     /**
1109      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1110      * The call is not executed if the target address is not a contract.
1111      *
1112      * @param from address representing the previous owner of the given token ID
1113      * @param to target address that will receive the tokens
1114      * @param tokenId uint256 ID of the token to be transferred
1115      * @param _data bytes optional data to send along with the call
1116      * @return bool whether the call correctly returned the expected magic value
1117      */
1118     function _checkOnERC721Received(
1119         address from,
1120         address to,
1121         uint256 tokenId,
1122         bytes memory _data
1123     ) private returns (bool) {
1124         if (to.isContract()) {
1125             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1126                 return retval == IERC721Receiver(to).onERC721Received.selector;
1127             } catch (bytes memory reason) {
1128                 if (reason.length == 0) {
1129                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1130                 } else {
1131                     assembly {
1132                         revert(add(32, reason), mload(reason))
1133                     }
1134                 }
1135             }
1136         } else {
1137             return true;
1138         }
1139     }
1140 
1141     /**
1142      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1143      *
1144      * startTokenId - the first token id to be transferred
1145      * quantity - the amount to be transferred
1146      *
1147      * Calling conditions:
1148      *
1149      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1150      * transferred to `to`.
1151      * - When `from` is zero, `tokenId` will be minted for `to`.
1152      */
1153     function _beforeTokenTransfers(
1154         address from,
1155         address to,
1156         uint256 startTokenId,
1157         uint256 quantity
1158     ) internal virtual {}
1159 
1160     /**
1161      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1162      * minting.
1163      *
1164      * startTokenId - the first token id to be transferred
1165      * quantity - the amount to be transferred
1166      *
1167      * Calling conditions:
1168      *
1169      * - when `from` and `to` are both non-zero.
1170      * - `from` and `to` are never both zero.
1171      */
1172     function _afterTokenTransfers(
1173         address from,
1174         address to,
1175         uint256 startTokenId,
1176         uint256 quantity
1177     ) internal virtual {}
1178 }
1179 
1180 
1181 pragma solidity ^0.8.0;
1182 
1183 contract thereisnoBanksy is ERC721A, Ownable {
1184   using Strings for uint256;
1185 
1186   string private uriPrefix = "ipfs://_______THEREISNOBANKSY____/";
1187   string private uriSuffix = ".json";
1188   string public hiddenMetadataUri;
1189   
1190   uint256 public price = 0 ether; 
1191   uint256 public maxSupply = 1974; 
1192   uint256 public maxMintAmountPerTx = 2; 
1193   
1194   bool public paused = true;
1195   bool public revealed = false;
1196   mapping(address => uint256) public addressMintedBalance;
1197 
1198 
1199   constructor() ERC721A("thereisnoBanksy", "NoBa", maxMintAmountPerTx) {
1200     setHiddenMetadataUri("ipfs://QmbvBcrfYbB5bHxCMSUCbb3vuZnM9PgJ8Uiu76kyk8Nekh");
1201   }
1202 
1203   modifier mintCompliance(uint256 _mintAmount) {
1204     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1205     require(currentIndex + _mintAmount <= maxSupply, "Max supply exceeded!");
1206     _;
1207   }
1208 
1209   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount)
1210    {
1211     require(!paused, "The contract is paused!");
1212     require(msg.value >= price * _mintAmount, "Insufficient funds!");
1213     
1214     
1215     _safeMint(msg.sender, _mintAmount);
1216   }
1217 
1218    
1219   function notBanksytoAddress(address _to, uint256 _mintAmount) public mintCompliance(_mintAmount) onlyOwner {
1220     _safeMint(_to, _mintAmount);
1221   }
1222 
1223  
1224   function walletOfOwner(address _owner)
1225     public
1226     view
1227     returns (uint256[] memory)
1228   {
1229     uint256 ownerTokenCount = balanceOf(_owner);
1230     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1231     uint256 currentTokenId = 0;
1232     uint256 ownedTokenIndex = 0;
1233 
1234     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1235       address currentTokenOwner = ownerOf(currentTokenId);
1236 
1237       if (currentTokenOwner == _owner) {
1238         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1239 
1240         ownedTokenIndex++;
1241       }
1242 
1243       currentTokenId++;
1244     }
1245 
1246     return ownedTokenIds;
1247   }
1248 
1249   function tokenURI(uint256 _tokenId)
1250     public
1251     view
1252     virtual
1253     override
1254     returns (string memory)
1255   {
1256     require(
1257       _exists(_tokenId),
1258       "ERC721Metadata: URI query for nonexistent token"
1259     );
1260 
1261     if (revealed == false) {
1262       return hiddenMetadataUri;
1263     }
1264 
1265     string memory currentBaseURI = _baseURI();
1266     return bytes(currentBaseURI).length > 0
1267         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1268         : "";
1269   }
1270 
1271   function setRevealed(bool _state) public onlyOwner {
1272     revealed = _state;
1273   
1274   }
1275 
1276   function setPrice(uint256 _price) public onlyOwner {
1277     price = _price;
1278 
1279   }
1280  
1281   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1282     hiddenMetadataUri = _hiddenMetadataUri;
1283   }
1284 
1285 
1286 
1287   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1288     uriPrefix = _uriPrefix;
1289   }
1290 
1291   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1292     uriSuffix = _uriSuffix;
1293   }
1294 
1295   function setPaused(bool _state) public onlyOwner {
1296     paused = _state;
1297   }
1298 
1299   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1300       _safeMint(_receiver, _mintAmount);
1301   }
1302 
1303   function _baseURI() internal view virtual override returns (string memory) {
1304     return uriPrefix;
1305     
1306   }
1307 
1308     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1309     maxMintAmountPerTx = _maxMintAmountPerTx;
1310 
1311   }
1312 
1313     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1314     maxSupply = _maxSupply;
1315 
1316   }
1317 
1318 
1319   // withdrawall addresses
1320   address t1 = 0x8e308ee8394BC2095d2d64aF56dBFB92Dc605999; 
1321   
1322 
1323   function withdrawall() public onlyOwner {
1324         uint256 _balance = address(this).balance;
1325         
1326         require(payable(t1).send(_balance * 100 / 100 ));
1327         
1328     }
1329 
1330   function withdraw() public onlyOwner {
1331     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1332     require(os);
1333     
1334 
1335  
1336   }
1337   
1338 }