1 // Sources flattened with hardhat v2.9.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
32 
33 
34 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Returns the address of the current owner.
64      */
65     function owner() public view virtual returns (address) {
66         return _owner;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(owner() == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public virtual onlyOwner {
85         _transferOwnership(address(0));
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         _transferOwnership(newOwner);
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Internal function without access restriction.
100      */
101     function _transferOwnership(address newOwner) internal virtual {
102         address oldOwner = _owner;
103         _owner = newOwner;
104         emit OwnershipTransferred(oldOwner, newOwner);
105     }
106 }
107 
108 
109 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.5.0
110 
111 
112 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
113 
114 pragma solidity ^0.8.0;
115 
116 /**
117  * @dev Contract module that helps prevent reentrant calls to a function.
118  *
119  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
120  * available, which can be applied to functions to make sure there are no nested
121  * (reentrant) calls to them.
122  *
123  * Note that because there is a single `nonReentrant` guard, functions marked as
124  * `nonReentrant` may not call one another. This can be worked around by making
125  * those functions `private`, and then adding `external` `nonReentrant` entry
126  * points to them.
127  *
128  * TIP: If you would like to learn more about reentrancy and alternative ways
129  * to protect against it, check out our blog post
130  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
131  */
132 abstract contract ReentrancyGuard {
133     // Booleans are more expensive than uint256 or any type that takes up a full
134     // word because each write operation emits an extra SLOAD to first read the
135     // slot's contents, replace the bits taken up by the boolean, and then write
136     // back. This is the compiler's defense against contract upgrades and
137     // pointer aliasing, and it cannot be disabled.
138 
139     // The values being non-zero value makes deployment a bit more expensive,
140     // but in exchange the refund on every call to nonReentrant will be lower in
141     // amount. Since refunds are capped to a percentage of the total
142     // transaction's gas, it is best to keep them low in cases like this one, to
143     // increase the likelihood of the full refund coming into effect.
144     uint256 private constant _NOT_ENTERED = 1;
145     uint256 private constant _ENTERED = 2;
146 
147     uint256 private _status;
148 
149     constructor() {
150         _status = _NOT_ENTERED;
151     }
152 
153     /**
154      * @dev Prevents a contract from calling itself, directly or indirectly.
155      * Calling a `nonReentrant` function from another `nonReentrant`
156      * function is not supported. It is possible to prevent this from happening
157      * by making the `nonReentrant` function external, and making it call a
158      * `private` function that does the actual work.
159      */
160     modifier nonReentrant() {
161         // On the first call to nonReentrant, _notEntered will be true
162         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
163 
164         // Any calls to nonReentrant after this point will fail
165         _status = _ENTERED;
166 
167         _;
168 
169         // By storing the original value once again, a refund is triggered (see
170         // https://eips.ethereum.org/EIPS/eip-2200)
171         _status = _NOT_ENTERED;
172     }
173 }
174 
175 
176 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
177 
178 
179 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
180 
181 pragma solidity ^0.8.0;
182 
183 /**
184  * @dev Interface of the ERC165 standard, as defined in the
185  * https://eips.ethereum.org/EIPS/eip-165[EIP].
186  *
187  * Implementers can declare support of contract interfaces, which can then be
188  * queried by others ({ERC165Checker}).
189  *
190  * For an implementation, see {ERC165}.
191  */
192 interface IERC165 {
193     /**
194      * @dev Returns true if this contract implements the interface defined by
195      * `interfaceId`. See the corresponding
196      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
197      * to learn more about how these ids are created.
198      *
199      * This function call must use less than 30 000 gas.
200      */
201     function supportsInterface(bytes4 interfaceId) external view returns (bool);
202 }
203 
204 
205 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
206 
207 
208 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
209 
210 pragma solidity ^0.8.0;
211 
212 /**
213  * @dev Required interface of an ERC721 compliant contract.
214  */
215 interface IERC721 is IERC165 {
216     /**
217      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
218      */
219     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
220 
221     /**
222      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
223      */
224     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
225 
226     /**
227      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
228      */
229     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
230 
231     /**
232      * @dev Returns the number of tokens in ``owner``'s account.
233      */
234     function balanceOf(address owner) external view returns (uint256 balance);
235 
236     /**
237      * @dev Returns the owner of the `tokenId` token.
238      *
239      * Requirements:
240      *
241      * - `tokenId` must exist.
242      */
243     function ownerOf(uint256 tokenId) external view returns (address owner);
244 
245     /**
246      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
247      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
248      *
249      * Requirements:
250      *
251      * - `from` cannot be the zero address.
252      * - `to` cannot be the zero address.
253      * - `tokenId` token must exist and be owned by `from`.
254      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
255      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
256      *
257      * Emits a {Transfer} event.
258      */
259     function safeTransferFrom(
260         address from,
261         address to,
262         uint256 tokenId
263     ) external;
264 
265     /**
266      * @dev Transfers `tokenId` token from `from` to `to`.
267      *
268      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
269      *
270      * Requirements:
271      *
272      * - `from` cannot be the zero address.
273      * - `to` cannot be the zero address.
274      * - `tokenId` token must be owned by `from`.
275      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
276      *
277      * Emits a {Transfer} event.
278      */
279     function transferFrom(
280         address from,
281         address to,
282         uint256 tokenId
283     ) external;
284 
285     /**
286      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
287      * The approval is cleared when the token is transferred.
288      *
289      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
290      *
291      * Requirements:
292      *
293      * - The caller must own the token or be an approved operator.
294      * - `tokenId` must exist.
295      *
296      * Emits an {Approval} event.
297      */
298     function approve(address to, uint256 tokenId) external;
299 
300     /**
301      * @dev Returns the account approved for `tokenId` token.
302      *
303      * Requirements:
304      *
305      * - `tokenId` must exist.
306      */
307     function getApproved(uint256 tokenId) external view returns (address operator);
308 
309     /**
310      * @dev Approve or remove `operator` as an operator for the caller.
311      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
312      *
313      * Requirements:
314      *
315      * - The `operator` cannot be the caller.
316      *
317      * Emits an {ApprovalForAll} event.
318      */
319     function setApprovalForAll(address operator, bool _approved) external;
320 
321     /**
322      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
323      *
324      * See {setApprovalForAll}
325      */
326     function isApprovedForAll(address owner, address operator) external view returns (bool);
327 
328     /**
329      * @dev Safely transfers `tokenId` token from `from` to `to`.
330      *
331      * Requirements:
332      *
333      * - `from` cannot be the zero address.
334      * - `to` cannot be the zero address.
335      * - `tokenId` token must exist and be owned by `from`.
336      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
337      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
338      *
339      * Emits a {Transfer} event.
340      */
341     function safeTransferFrom(
342         address from,
343         address to,
344         uint256 tokenId,
345         bytes calldata data
346     ) external;
347 }
348 
349 
350 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
351 
352 
353 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
354 
355 pragma solidity ^0.8.0;
356 
357 /**
358  * @title ERC721 token receiver interface
359  * @dev Interface for any contract that wants to support safeTransfers
360  * from ERC721 asset contracts.
361  */
362 interface IERC721Receiver {
363     /**
364      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
365      * by `operator` from `from`, this function is called.
366      *
367      * It must return its Solidity selector to confirm the token transfer.
368      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
369      *
370      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
371      */
372     function onERC721Received(
373         address operator,
374         address from,
375         uint256 tokenId,
376         bytes calldata data
377     ) external returns (bytes4);
378 }
379 
380 
381 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
382 
383 
384 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
385 
386 pragma solidity ^0.8.0;
387 
388 /**
389  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
390  * @dev See https://eips.ethereum.org/EIPS/eip-721
391  */
392 interface IERC721Metadata is IERC721 {
393     /**
394      * @dev Returns the token collection name.
395      */
396     function name() external view returns (string memory);
397 
398     /**
399      * @dev Returns the token collection symbol.
400      */
401     function symbol() external view returns (string memory);
402 
403     /**
404      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
405      */
406     function tokenURI(uint256 tokenId) external view returns (string memory);
407 }
408 
409 
410 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
411 
412 
413 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
414 
415 pragma solidity ^0.8.0;
416 
417 /**
418  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
419  * @dev See https://eips.ethereum.org/EIPS/eip-721
420  */
421 interface IERC721Enumerable is IERC721 {
422     /**
423      * @dev Returns the total amount of tokens stored by the contract.
424      */
425     function totalSupply() external view returns (uint256);
426 
427     /**
428      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
429      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
430      */
431     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
432 
433     /**
434      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
435      * Use along with {totalSupply} to enumerate all tokens.
436      */
437     function tokenByIndex(uint256 index) external view returns (uint256);
438 }
439 
440 
441 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
442 
443 
444 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
445 
446 pragma solidity ^0.8.1;
447 
448 /**
449  * @dev Collection of functions related to the address type
450  */
451 library Address {
452     /**
453      * @dev Returns true if `account` is a contract.
454      *
455      * [IMPORTANT]
456      * ====
457      * It is unsafe to assume that an address for which this function returns
458      * false is an externally-owned account (EOA) and not a contract.
459      *
460      * Among others, `isContract` will return false for the following
461      * types of addresses:
462      *
463      *  - an externally-owned account
464      *  - a contract in construction
465      *  - an address where a contract will be created
466      *  - an address where a contract lived, but was destroyed
467      * ====
468      *
469      * [IMPORTANT]
470      * ====
471      * You shouldn't rely on `isContract` to protect against flash loan attacks!
472      *
473      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
474      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
475      * constructor.
476      * ====
477      */
478     function isContract(address account) internal view returns (bool) {
479         // This method relies on extcodesize/address.code.length, which returns 0
480         // for contracts in construction, since the code is only stored at the end
481         // of the constructor execution.
482 
483         return account.code.length > 0;
484     }
485 
486     /**
487      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
488      * `recipient`, forwarding all available gas and reverting on errors.
489      *
490      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
491      * of certain opcodes, possibly making contracts go over the 2300 gas limit
492      * imposed by `transfer`, making them unable to receive funds via
493      * `transfer`. {sendValue} removes this limitation.
494      *
495      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
496      *
497      * IMPORTANT: because control is transferred to `recipient`, care must be
498      * taken to not create reentrancy vulnerabilities. Consider using
499      * {ReentrancyGuard} or the
500      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
501      */
502     function sendValue(address payable recipient, uint256 amount) internal {
503         require(address(this).balance >= amount, "Address: insufficient balance");
504 
505         (bool success, ) = recipient.call{value: amount}("");
506         require(success, "Address: unable to send value, recipient may have reverted");
507     }
508 
509     /**
510      * @dev Performs a Solidity function call using a low level `call`. A
511      * plain `call` is an unsafe replacement for a function call: use this
512      * function instead.
513      *
514      * If `target` reverts with a revert reason, it is bubbled up by this
515      * function (like regular Solidity function calls).
516      *
517      * Returns the raw returned data. To convert to the expected return value,
518      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
519      *
520      * Requirements:
521      *
522      * - `target` must be a contract.
523      * - calling `target` with `data` must not revert.
524      *
525      * _Available since v3.1._
526      */
527     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
528         return functionCall(target, data, "Address: low-level call failed");
529     }
530 
531     /**
532      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
533      * `errorMessage` as a fallback revert reason when `target` reverts.
534      *
535      * _Available since v3.1._
536      */
537     function functionCall(
538         address target,
539         bytes memory data,
540         string memory errorMessage
541     ) internal returns (bytes memory) {
542         return functionCallWithValue(target, data, 0, errorMessage);
543     }
544 
545     /**
546      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
547      * but also transferring `value` wei to `target`.
548      *
549      * Requirements:
550      *
551      * - the calling contract must have an ETH balance of at least `value`.
552      * - the called Solidity function must be `payable`.
553      *
554      * _Available since v3.1._
555      */
556     function functionCallWithValue(
557         address target,
558         bytes memory data,
559         uint256 value
560     ) internal returns (bytes memory) {
561         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
562     }
563 
564     /**
565      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
566      * with `errorMessage` as a fallback revert reason when `target` reverts.
567      *
568      * _Available since v3.1._
569      */
570     function functionCallWithValue(
571         address target,
572         bytes memory data,
573         uint256 value,
574         string memory errorMessage
575     ) internal returns (bytes memory) {
576         require(address(this).balance >= value, "Address: insufficient balance for call");
577         require(isContract(target), "Address: call to non-contract");
578 
579         (bool success, bytes memory returndata) = target.call{value: value}(data);
580         return verifyCallResult(success, returndata, errorMessage);
581     }
582 
583     /**
584      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
585      * but performing a static call.
586      *
587      * _Available since v3.3._
588      */
589     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
590         return functionStaticCall(target, data, "Address: low-level static call failed");
591     }
592 
593     /**
594      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
595      * but performing a static call.
596      *
597      * _Available since v3.3._
598      */
599     function functionStaticCall(
600         address target,
601         bytes memory data,
602         string memory errorMessage
603     ) internal view returns (bytes memory) {
604         require(isContract(target), "Address: static call to non-contract");
605 
606         (bool success, bytes memory returndata) = target.staticcall(data);
607         return verifyCallResult(success, returndata, errorMessage);
608     }
609 
610     /**
611      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
612      * but performing a delegate call.
613      *
614      * _Available since v3.4._
615      */
616     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
617         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
618     }
619 
620     /**
621      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
622      * but performing a delegate call.
623      *
624      * _Available since v3.4._
625      */
626     function functionDelegateCall(
627         address target,
628         bytes memory data,
629         string memory errorMessage
630     ) internal returns (bytes memory) {
631         require(isContract(target), "Address: delegate call to non-contract");
632 
633         (bool success, bytes memory returndata) = target.delegatecall(data);
634         return verifyCallResult(success, returndata, errorMessage);
635     }
636 
637     /**
638      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
639      * revert reason using the provided one.
640      *
641      * _Available since v4.3._
642      */
643     function verifyCallResult(
644         bool success,
645         bytes memory returndata,
646         string memory errorMessage
647     ) internal pure returns (bytes memory) {
648         if (success) {
649             return returndata;
650         } else {
651             // Look for revert reason and bubble it up if present
652             if (returndata.length > 0) {
653                 // The easiest way to bubble the revert reason is using memory via assembly
654 
655                 assembly {
656                     let returndata_size := mload(returndata)
657                     revert(add(32, returndata), returndata_size)
658                 }
659             } else {
660                 revert(errorMessage);
661             }
662         }
663     }
664 }
665 
666 
667 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
668 
669 
670 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
671 
672 pragma solidity ^0.8.0;
673 
674 /**
675  * @dev String operations.
676  */
677 library Strings {
678     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
679 
680     /**
681      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
682      */
683     function toString(uint256 value) internal pure returns (string memory) {
684         // Inspired by OraclizeAPI's implementation - MIT licence
685         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
686 
687         if (value == 0) {
688             return "0";
689         }
690         uint256 temp = value;
691         uint256 digits;
692         while (temp != 0) {
693             digits++;
694             temp /= 10;
695         }
696         bytes memory buffer = new bytes(digits);
697         while (value != 0) {
698             digits -= 1;
699             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
700             value /= 10;
701         }
702         return string(buffer);
703     }
704 
705     /**
706      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
707      */
708     function toHexString(uint256 value) internal pure returns (string memory) {
709         if (value == 0) {
710             return "0x00";
711         }
712         uint256 temp = value;
713         uint256 length = 0;
714         while (temp != 0) {
715             length++;
716             temp >>= 8;
717         }
718         return toHexString(value, length);
719     }
720 
721     /**
722      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
723      */
724     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
725         bytes memory buffer = new bytes(2 * length + 2);
726         buffer[0] = "0";
727         buffer[1] = "x";
728         for (uint256 i = 2 * length + 1; i > 1; --i) {
729             buffer[i] = _HEX_SYMBOLS[value & 0xf];
730             value >>= 4;
731         }
732         require(value == 0, "Strings: hex length insufficient");
733         return string(buffer);
734     }
735 }
736 
737 
738 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
739 
740 
741 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
742 
743 pragma solidity ^0.8.0;
744 
745 /**
746  * @dev Implementation of the {IERC165} interface.
747  *
748  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
749  * for the additional interface id that will be supported. For example:
750  *
751  * ```solidity
752  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
753  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
754  * }
755  * ```
756  *
757  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
758  */
759 abstract contract ERC165 is IERC165 {
760     /**
761      * @dev See {IERC165-supportsInterface}.
762      */
763     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
764         return interfaceId == type(IERC165).interfaceId;
765     }
766 }
767 
768 
769 // File contracts/ERC721A.sol
770 
771 
772 
773 pragma solidity ^0.8.0;
774 
775 
776 
777 
778 
779 
780 
781 
782 /**
783  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
784  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
785  *
786  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
787  *
788  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
789  *
790  * Does not support burning tokens to address(0).
791  */
792 contract ERC721A is
793   Context,
794   ERC165,
795   IERC721,
796   IERC721Metadata,
797   IERC721Enumerable
798 {
799   using Address for address;
800   using Strings for uint256;
801 
802   struct TokenOwnership {
803     address addr;
804     uint64 startTimestamp;
805   }
806 
807   struct AddressData {
808     uint128 balance;
809     uint128 numberMinted;
810   }
811 
812   uint256 private currentIndex = 0;
813 
814   uint256 internal immutable collectionSize;
815   uint256 internal immutable maxBatchSize;
816 
817   // Token name
818   string private _name;
819 
820   // Token symbol
821   string private _symbol;
822 
823   // Mapping from token ID to ownership details
824   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
825   mapping(uint256 => TokenOwnership) private _ownerships;
826 
827   // Mapping owner address to address data
828   mapping(address => AddressData) private _addressData;
829 
830   // Mapping from token ID to approved address
831   mapping(uint256 => address) private _tokenApprovals;
832 
833   // Mapping from owner to operator approvals
834   mapping(address => mapping(address => bool)) private _operatorApprovals;
835 
836   /**
837    * @dev
838    * `maxBatchSize` refers to how much a minter can mint at a time.
839    * `collectionSize_` refers to how many tokens are in the collection.
840    */
841   constructor(
842     string memory name_,
843     string memory symbol_,
844     uint256 maxBatchSize_,
845     uint256 collectionSize_
846   ) {
847     require(
848       collectionSize_ > 0,
849       "ERC721A: collection must have a nonzero supply"
850     );
851     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
852     _name = name_;
853     _symbol = symbol_;
854     maxBatchSize = maxBatchSize_;
855     collectionSize = collectionSize_;
856   }
857 
858   /**
859    * @dev See {IERC721Enumerable-totalSupply}.
860    */
861   function totalSupply() public view override returns (uint256) {
862     return currentIndex;
863   }
864 
865   /**
866    * @dev See {IERC721Enumerable-tokenByIndex}.
867    */
868   function tokenByIndex(uint256 index) public view override returns (uint256) {
869     require(index < totalSupply(), "ERC721A: global index out of bounds");
870     return index;
871   }
872 
873   /**
874    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
875    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
876    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
877    */
878   function tokenOfOwnerByIndex(address owner, uint256 index)
879     public
880     view
881     override
882     returns (uint256)
883   {
884     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
885     uint256 numMintedSoFar = totalSupply();
886     uint256 tokenIdsIdx = 0;
887     address currOwnershipAddr = address(0);
888     for (uint256 i = 0; i < numMintedSoFar; i++) {
889       TokenOwnership memory ownership = _ownerships[i];
890       if (ownership.addr != address(0)) {
891         currOwnershipAddr = ownership.addr;
892       }
893       if (currOwnershipAddr == owner) {
894         if (tokenIdsIdx == index) {
895           return i;
896         }
897         tokenIdsIdx++;
898       }
899     }
900     revert("ERC721A: unable to get token of owner by index");
901   }
902 
903   /**
904    * @dev See {IERC165-supportsInterface}.
905    */
906   function supportsInterface(bytes4 interfaceId)
907     public
908     view
909     virtual
910     override(ERC165, IERC165)
911     returns (bool)
912   {
913     return
914       interfaceId == type(IERC721).interfaceId ||
915       interfaceId == type(IERC721Metadata).interfaceId ||
916       interfaceId == type(IERC721Enumerable).interfaceId ||
917       super.supportsInterface(interfaceId);
918   }
919 
920   /**
921    * @dev See {IERC721-balanceOf}.
922    */
923   function balanceOf(address owner) public view override returns (uint256) {
924     require(owner != address(0), "ERC721A: balance query for the zero address");
925     return uint256(_addressData[owner].balance);
926   }
927 
928   function _numberMinted(address owner) internal view returns (uint256) {
929     require(
930       owner != address(0),
931       "ERC721A: number minted query for the zero address"
932     );
933     return uint256(_addressData[owner].numberMinted);
934   }
935 
936   function ownershipOf(uint256 tokenId)
937     internal
938     view
939     returns (TokenOwnership memory)
940   {
941     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
942 
943     uint256 lowestTokenToCheck;
944     if (tokenId >= maxBatchSize) {
945       lowestTokenToCheck = tokenId - maxBatchSize + 1;
946     }
947 
948     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
949       TokenOwnership memory ownership = _ownerships[curr];
950       if (ownership.addr != address(0)) {
951         return ownership;
952       }
953     }
954 
955     revert("ERC721A: unable to determine the owner of token");
956   }
957 
958   /**
959    * @dev See {IERC721-ownerOf}.
960    */
961   function ownerOf(uint256 tokenId) public view override returns (address) {
962     return ownershipOf(tokenId).addr;
963   }
964 
965   /**
966    * @dev See {IERC721Metadata-name}.
967    */
968   function name() public view virtual override returns (string memory) {
969     return _name;
970   }
971 
972   /**
973    * @dev See {IERC721Metadata-symbol}.
974    */
975   function symbol() public view virtual override returns (string memory) {
976     return _symbol;
977   }
978 
979   /**
980    * @dev See {IERC721Metadata-tokenURI}.
981    */
982   function tokenURI(uint256 tokenId)
983     public
984     view
985     virtual
986     override
987     returns (string memory)
988   {
989     require(
990       _exists(tokenId),
991       "ERC721Metadata: URI query for nonexistent token"
992     );
993 
994     string memory baseURI = _baseURI();
995     return
996       bytes(baseURI).length > 0
997         ? string(abi.encodePacked(baseURI, tokenId.toString()))
998         : "";
999   }
1000 
1001   /**
1002    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1003    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1004    * by default, can be overriden in child contracts.
1005    */
1006   function _baseURI() internal view virtual returns (string memory) {
1007     return "";
1008   }
1009 
1010   /**
1011    * @dev See {IERC721-approve}.
1012    */
1013   function approve(address to, uint256 tokenId) public override {
1014     address owner = ERC721A.ownerOf(tokenId);
1015     require(to != owner, "ERC721A: approval to current owner");
1016 
1017     require(
1018       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1019       "ERC721A: approve caller is not owner nor approved for all"
1020     );
1021 
1022     _approve(to, tokenId, owner);
1023   }
1024 
1025   /**
1026    * @dev See {IERC721-getApproved}.
1027    */
1028   function getApproved(uint256 tokenId) public view override returns (address) {
1029     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1030 
1031     return _tokenApprovals[tokenId];
1032   }
1033 
1034   /**
1035    * @dev See {IERC721-setApprovalForAll}.
1036    */
1037   function setApprovalForAll(address operator, bool approved) public override {
1038     require(operator != _msgSender(), "ERC721A: approve to caller");
1039 
1040     _operatorApprovals[_msgSender()][operator] = approved;
1041     emit ApprovalForAll(_msgSender(), operator, approved);
1042   }
1043 
1044   /**
1045    * @dev See {IERC721-isApprovedForAll}.
1046    */
1047   function isApprovedForAll(address owner, address operator)
1048     public
1049     view
1050     virtual
1051     override
1052     returns (bool)
1053   {
1054     return _operatorApprovals[owner][operator];
1055   }
1056 
1057   /**
1058    * @dev See {IERC721-transferFrom}.
1059    */
1060   function transferFrom(
1061     address from,
1062     address to,
1063     uint256 tokenId
1064   ) public override {
1065     _transfer(from, to, tokenId);
1066   }
1067 
1068   /**
1069    * @dev See {IERC721-safeTransferFrom}.
1070    */
1071   function safeTransferFrom(
1072     address from,
1073     address to,
1074     uint256 tokenId
1075   ) public override {
1076     safeTransferFrom(from, to, tokenId, "");
1077   }
1078 
1079   /**
1080    * @dev See {IERC721-safeTransferFrom}.
1081    */
1082   function safeTransferFrom(
1083     address from,
1084     address to,
1085     uint256 tokenId,
1086     bytes memory _data
1087   ) public override {
1088     _transfer(from, to, tokenId);
1089     require(
1090       _checkOnERC721Received(from, to, tokenId, _data),
1091       "ERC721A: transfer to non ERC721Receiver implementer"
1092     );
1093   }
1094 
1095   /**
1096    * @dev Returns whether `tokenId` exists.
1097    *
1098    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1099    *
1100    * Tokens start existing when they are minted (`_mint`),
1101    */
1102   function _exists(uint256 tokenId) internal view returns (bool) {
1103     return tokenId < currentIndex;
1104   }
1105 
1106   function _safeMint(address to, uint256 quantity) internal {
1107     _safeMint(to, quantity, "");
1108   }
1109 
1110   /**
1111    * @dev Mints `quantity` tokens and transfers them to `to`.
1112    *
1113    * Requirements:
1114    *
1115    * - there must be `quantity` tokens remaining unminted in the total collection.
1116    * - `to` cannot be the zero address.
1117    * - `quantity` cannot be larger than the max batch size.
1118    *
1119    * Emits a {Transfer} event.
1120    */
1121   function _safeMint(
1122     address to,
1123     uint256 quantity,
1124     bytes memory _data
1125   ) internal {
1126     uint256 startTokenId = currentIndex;
1127     require(to != address(0), "ERC721A: mint to the zero address");
1128     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1129     require(!_exists(startTokenId), "ERC721A: token already minted");
1130     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1131 
1132     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1133 
1134     AddressData memory addressData = _addressData[to];
1135     _addressData[to] = AddressData(
1136       addressData.balance + uint128(quantity),
1137       addressData.numberMinted + uint128(quantity)
1138     );
1139     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1140 
1141     uint256 updatedIndex = startTokenId;
1142 
1143     for (uint256 i = 0; i < quantity; i++) {
1144       emit Transfer(address(0), to, updatedIndex);
1145       require(
1146         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1147         "ERC721A: transfer to non ERC721Receiver implementer"
1148       );
1149       updatedIndex++;
1150     }
1151 
1152     currentIndex = updatedIndex;
1153     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1154   }
1155 
1156   /**
1157    * @dev Transfers `tokenId` from `from` to `to`.
1158    *
1159    * Requirements:
1160    *
1161    * - `to` cannot be the zero address.
1162    * - `tokenId` token must be owned by `from`.
1163    *
1164    * Emits a {Transfer} event.
1165    */
1166   function _transfer(
1167     address from,
1168     address to,
1169     uint256 tokenId
1170   ) private {
1171     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1172 
1173     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1174       getApproved(tokenId) == _msgSender() ||
1175       isApprovedForAll(prevOwnership.addr, _msgSender()));
1176 
1177     require(
1178       isApprovedOrOwner,
1179       "ERC721A: transfer caller is not owner nor approved"
1180     );
1181 
1182     require(
1183       prevOwnership.addr == from,
1184       "ERC721A: transfer from incorrect owner"
1185     );
1186     require(to != address(0), "ERC721A: transfer to the zero address");
1187 
1188     _beforeTokenTransfers(from, to, tokenId, 1);
1189 
1190     // Clear approvals from the previous owner
1191     _approve(address(0), tokenId, prevOwnership.addr);
1192 
1193     _addressData[from].balance -= 1;
1194     _addressData[to].balance += 1;
1195     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1196 
1197     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1198     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1199     uint256 nextTokenId = tokenId + 1;
1200     if (_ownerships[nextTokenId].addr == address(0)) {
1201       if (_exists(nextTokenId)) {
1202         _ownerships[nextTokenId] = TokenOwnership(
1203           prevOwnership.addr,
1204           prevOwnership.startTimestamp
1205         );
1206       }
1207     }
1208 
1209     emit Transfer(from, to, tokenId);
1210     _afterTokenTransfers(from, to, tokenId, 1);
1211   }
1212 
1213   /**
1214    * @dev Approve `to` to operate on `tokenId`
1215    *
1216    * Emits a {Approval} event.
1217    */
1218   function _approve(
1219     address to,
1220     uint256 tokenId,
1221     address owner
1222   ) private {
1223     _tokenApprovals[tokenId] = to;
1224     emit Approval(owner, to, tokenId);
1225   }
1226 
1227   uint256 public nextOwnerToExplicitlySet = 0;
1228 
1229   /**
1230    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1231    */
1232   function _setOwnersExplicit(uint256 quantity) internal {
1233     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1234     require(quantity > 0, "quantity must be nonzero");
1235     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1236     if (endIndex > collectionSize - 1) {
1237       endIndex = collectionSize - 1;
1238     }
1239     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1240     require(_exists(endIndex), "not enough minted yet for this cleanup");
1241     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1242       if (_ownerships[i].addr == address(0)) {
1243         TokenOwnership memory ownership = ownershipOf(i);
1244         _ownerships[i] = TokenOwnership(
1245           ownership.addr,
1246           ownership.startTimestamp
1247         );
1248       }
1249     }
1250     nextOwnerToExplicitlySet = endIndex + 1;
1251   }
1252 
1253   /**
1254    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1255    * The call is not executed if the target address is not a contract.
1256    *
1257    * @param from address representing the previous owner of the given token ID
1258    * @param to target address that will receive the tokens
1259    * @param tokenId uint256 ID of the token to be transferred
1260    * @param _data bytes optional data to send along with the call
1261    * @return bool whether the call correctly returned the expected magic value
1262    */
1263   function _checkOnERC721Received(
1264     address from,
1265     address to,
1266     uint256 tokenId,
1267     bytes memory _data
1268   ) private returns (bool) {
1269     if (to.isContract()) {
1270       try
1271         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1272       returns (bytes4 retval) {
1273         return retval == IERC721Receiver(to).onERC721Received.selector;
1274       } catch (bytes memory reason) {
1275         if (reason.length == 0) {
1276           revert("ERC721A: transfer to non ERC721Receiver implementer");
1277         } else {
1278           assembly {
1279             revert(add(32, reason), mload(reason))
1280           }
1281         }
1282       }
1283     } else {
1284       return true;
1285     }
1286   }
1287 
1288   /**
1289    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1290    *
1291    * startTokenId - the first token id to be transferred
1292    * quantity - the amount to be transferred
1293    *
1294    * Calling conditions:
1295    *
1296    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1297    * transferred to `to`.
1298    * - When `from` is zero, `tokenId` will be minted for `to`.
1299    */
1300   function _beforeTokenTransfers(
1301     address from,
1302     address to,
1303     uint256 startTokenId,
1304     uint256 quantity
1305   ) internal virtual {}
1306 
1307   /**
1308    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1309    * minting.
1310    *
1311    * startTokenId - the first token id to be transferred
1312    * quantity - the amount to be transferred
1313    *
1314    * Calling conditions:
1315    *
1316    * - when `from` and `to` are both non-zero.
1317    * - `from` and `to` are never both zero.
1318    */
1319   function _afterTokenTransfers(
1320     address from,
1321     address to,
1322     uint256 startTokenId,
1323     uint256 quantity
1324   ) internal virtual {}
1325 }
1326 
1327 
1328 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.5.0
1329 
1330 
1331 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
1332 
1333 pragma solidity ^0.8.0;
1334 
1335 /**
1336  * @dev These functions deal with verification of Merkle Trees proofs.
1337  *
1338  * The proofs can be generated using the JavaScript library
1339  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1340  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1341  *
1342  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1343  */
1344 library MerkleProof {
1345     /**
1346      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1347      * defined by `root`. For this, a `proof` must be provided, containing
1348      * sibling hashes on the branch from the leaf to the root of the tree. Each
1349      * pair of leaves and each pair of pre-images are assumed to be sorted.
1350      */
1351     function verify(
1352         bytes32[] memory proof,
1353         bytes32 root,
1354         bytes32 leaf
1355     ) internal pure returns (bool) {
1356         return processProof(proof, leaf) == root;
1357     }
1358 
1359     /**
1360      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1361      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1362      * hash matches the root of the tree. When processing the proof, the pairs
1363      * of leafs & pre-images are assumed to be sorted.
1364      *
1365      * _Available since v4.4._
1366      */
1367     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1368         bytes32 computedHash = leaf;
1369         for (uint256 i = 0; i < proof.length; i++) {
1370             bytes32 proofElement = proof[i];
1371             if (computedHash <= proofElement) {
1372                 // Hash(current computed hash + current element of the proof)
1373                 computedHash = _efficientHash(computedHash, proofElement);
1374             } else {
1375                 // Hash(current element of the proof + current computed hash)
1376                 computedHash = _efficientHash(proofElement, computedHash);
1377             }
1378         }
1379         return computedHash;
1380     }
1381 
1382     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1383         assembly {
1384             mstore(0x00, a)
1385             mstore(0x20, b)
1386             value := keccak256(0x00, 0x40)
1387         }
1388     }
1389 }
1390 
1391 
1392 // File contracts/RichGang.sol
1393 
1394 
1395 
1396 pragma solidity ^0.8.0;
1397 
1398 
1399 
1400 
1401 
1402 contract RichGang is Ownable, ERC721A, ReentrancyGuard {
1403   uint256 public immutable maxPerAddressDuringMint;
1404   uint256 public immutable amountForDevs;
1405   bytes32 public merkle_root;
1406   mapping(address => bool) allowlistMinted;
1407 
1408   struct SaleConfig {
1409     uint32 publicSaleStartTime;
1410     uint64 mintlistPrice;
1411     uint64 publicPrice;
1412     uint32 publicSaleKey;
1413   }
1414 
1415   SaleConfig public saleConfig;
1416 
1417 
1418   constructor(
1419     uint256 maxBatchSize_,
1420     uint256 collectionSize_,
1421     uint256 amountForDevs_
1422   ) ERC721A("RichGang", "RichGang", maxBatchSize_, collectionSize_) {
1423     maxPerAddressDuringMint = maxBatchSize_;
1424     amountForDevs = amountForDevs_;
1425     saleConfig.publicSaleStartTime = uint32(block.timestamp);
1426     saleConfig.mintlistPrice = 0 ether;
1427     saleConfig.publicPrice = 0 ether;
1428     saleConfig.publicSaleKey = 0;
1429     require(
1430       amountForDevs_ <= collectionSize_,
1431       "larger collection size needed"
1432     );
1433   }
1434    function endAuctionAndSetupNonAuctionSaleInfo(
1435     uint64 mintlistPriceWei,
1436     uint64 publicPriceWei,
1437     uint32 publicSaleStartTime,
1438     uint32 publicSaleKey
1439   ) external onlyOwner {
1440     saleConfig = SaleConfig(
1441       publicSaleStartTime,
1442       mintlistPriceWei,
1443       publicPriceWei,
1444       publicSaleKey
1445     );
1446   }
1447   modifier callerIsUser() {
1448     require(tx.origin == msg.sender, "The caller is another contract");
1449     _;
1450   }
1451 
1452   function setMerkleRoot(bytes32 _merkle_root) external onlyOwner {
1453     merkle_root = _merkle_root;
1454   }
1455 
1456   function allowlistMint(bytes32[] memory proof) external payable callerIsUser {
1457     uint256 price = uint256(saleConfig.mintlistPrice);
1458     require(price != 0, "allowlist sale has not begun yet");
1459     require(allowlistMinted[msg.sender] == false, "You has minted");
1460     require(isQualified(proof, merkle_root, msg.sender), "not eligible for allowlist mint");
1461     require(totalSupply() + 1 <= collectionSize, "reached max supply");
1462     allowlistMinted[msg.sender] = true;
1463     _safeMint(msg.sender, 1);
1464     refundIfOver(price);
1465   }
1466 
1467   function publicSaleMint(uint256 quantity, uint256 callerPublicSaleKey)
1468     external
1469     payable
1470     callerIsUser
1471   {
1472     SaleConfig memory config = saleConfig;
1473     uint256 publicSaleKey = uint256(config.publicSaleKey);
1474     uint256 publicPrice = uint256(config.publicPrice);
1475     uint256 publicSaleStartTime = uint256(config.publicSaleStartTime);
1476     require(
1477       publicSaleKey == callerPublicSaleKey,
1478       "called with incorrect public sale key"
1479     );
1480 
1481     require(
1482       isPublicSaleOn(publicPrice, publicSaleKey, publicSaleStartTime),
1483       "public sale has not begun yet"
1484     );
1485     require(totalSupply() + quantity <= collectionSize, "reached max supply");
1486     require(
1487       numberMinted(msg.sender) + quantity <= maxPerAddressDuringMint,
1488       "can not mint this many"
1489     );
1490     _safeMint(msg.sender, quantity);
1491     refundIfOver(publicPrice * quantity);
1492   }
1493 
1494   function refundIfOver(uint256 price) private {
1495     require(msg.value >= price, "Need to send more ETH.");
1496     if (msg.value > price) {
1497       payable(msg.sender).transfer(msg.value - price);
1498     }
1499   }
1500   function isQualified(bytes32[] memory proof, bytes32 root, address account)
1501         virtual
1502         public
1503         view
1504         returns (bool)
1505     {
1506         // solhint-disable-next-line
1507         // validate whitelist user
1508         bytes32 leaf = keccak256(abi.encodePacked(account));
1509         if (MerkleProof.verify(proof, root, leaf)) {
1510             return (true);
1511         }
1512         return (false);
1513   }
1514 
1515   function isPublicSaleOn(
1516     uint256 publicPriceWei,
1517     uint256 publicSaleKey,
1518     uint256 publicSaleStartTime
1519   ) public view returns (bool) {
1520     return
1521       publicPriceWei != 0 &&
1522       publicSaleKey != 0 &&
1523       block.timestamp >= publicSaleStartTime;
1524   }
1525 
1526   
1527   // For marketing etc.
1528   function devMint(uint256 quantity) external onlyOwner {
1529     require(
1530       totalSupply() + quantity <= amountForDevs,
1531       "too many already minted before dev mint"
1532     );
1533     require(
1534       quantity % maxBatchSize == 0,
1535       "can only mint a multiple of the maxBatchSize"
1536     );
1537     uint256 numChunks = quantity / maxBatchSize;
1538     for (uint256 i = 0; i < numChunks; i++) {
1539       _safeMint(msg.sender, maxBatchSize);
1540     }
1541   }
1542 
1543   // // metadata URI
1544   string private _baseTokenURI;
1545 
1546   function _baseURI() internal view virtual override returns (string memory) {
1547     return _baseTokenURI;
1548   }
1549 
1550   function setBaseURI(string calldata baseURI) external onlyOwner {
1551     _baseTokenURI = baseURI;
1552   }
1553 
1554   function withdrawMoney() external onlyOwner nonReentrant {
1555     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1556     require(success, "Transfer failed.");
1557   }
1558 
1559   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1560     _setOwnersExplicit(quantity);
1561   }
1562 
1563   function numberMinted(address owner) public view returns (uint256) {
1564     return _numberMinted(owner);
1565   }
1566 
1567   function getOwnershipData(uint256 tokenId)
1568     external
1569     view
1570     returns (TokenOwnership memory)
1571   {
1572     return ownershipOf(tokenId);
1573   }
1574 }