1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(
66         address sender,
67         address recipient,
68         uint256 amount
69     ) external returns (bool);
70 
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 // File: @openzeppelin/contracts/utils/Context.sol
87 
88 
89 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 /**
94  * @dev Provides information about the current execution context, including the
95  * sender of the transaction and its data. While these are generally available
96  * via msg.sender and msg.data, they should not be accessed in such a direct
97  * manner, since when dealing with meta-transactions the account sending and
98  * paying for execution may not be the actual sender (as far as an application
99  * is concerned).
100  *
101  * This contract is only required for intermediate, library-like contracts.
102  */
103 abstract contract Context {
104     function _msgSender() internal view virtual returns (address) {
105         return msg.sender;
106     }
107 
108     function _msgData() internal view virtual returns (bytes calldata) {
109         return msg.data;
110     }
111 }
112 
113 // File: @openzeppelin/contracts/access/Ownable.sol
114 
115 
116 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 
121 /**
122  * @dev Contract module which provides a basic access control mechanism, where
123  * there is an account (an owner) that can be granted exclusive access to
124  * specific functions.
125  *
126  * By default, the owner account will be the one that deploys the contract. This
127  * can later be changed with {transferOwnership}.
128  *
129  * This module is used through inheritance. It will make available the modifier
130  * `onlyOwner`, which can be applied to your functions to restrict their use to
131  * the owner.
132  */
133 abstract contract Ownable is Context {
134     address private _owner;
135 
136     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
137 
138     /**
139      * @dev Initializes the contract setting the deployer as the initial owner.
140      */
141     constructor() {
142         _transferOwnership(_msgSender());
143     }
144 
145     /**
146      * @dev Returns the address of the current owner.
147      */
148     function owner() public view virtual returns (address) {
149         return _owner;
150     }
151 
152     /**
153      * @dev Throws if called by any account other than the owner.
154      */
155     modifier onlyOwner() {
156         require(owner() == _msgSender(), "Ownable: caller is not the owner");
157         _;
158     }
159 
160     /**
161      * @dev Leaves the contract without owner. It will not be possible to call
162      * `onlyOwner` functions anymore. Can only be called by the current owner.
163      *
164      * NOTE: Renouncing ownership will leave the contract without an owner,
165      * thereby removing any functionality that is only available to the owner.
166      */
167     function renounceOwnership() public virtual onlyOwner {
168         _transferOwnership(address(0));
169     }
170 
171     /**
172      * @dev Transfers ownership of the contract to a new account (`newOwner`).
173      * Can only be called by the current owner.
174      */
175     function transferOwnership(address newOwner) public virtual onlyOwner {
176         require(newOwner != address(0), "Ownable: new owner is the zero address");
177         _transferOwnership(newOwner);
178     }
179 
180     /**
181      * @dev Transfers ownership of the contract to a new account (`newOwner`).
182      * Internal function without access restriction.
183      */
184     function _transferOwnership(address newOwner) internal virtual {
185         address oldOwner = _owner;
186         _owner = newOwner;
187         emit OwnershipTransferred(oldOwner, newOwner);
188     }
189 }
190 
191 // File: @openzeppelin/contracts/utils/Address.sol
192 
193 
194 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
195 
196 pragma solidity ^0.8.0;
197 
198 /**
199  * @dev Collection of functions related to the address type
200  */
201 library Address {
202     /**
203      * @dev Returns true if `account` is a contract.
204      *
205      * [IMPORTANT]
206      * ====
207      * It is unsafe to assume that an address for which this function returns
208      * false is an externally-owned account (EOA) and not a contract.
209      *
210      * Among others, `isContract` will return false for the following
211      * types of addresses:
212      *
213      *  - an externally-owned account
214      *  - a contract in construction
215      *  - an address where a contract will be created
216      *  - an address where a contract lived, but was destroyed
217      * ====
218      */
219     function isContract(address account) internal view returns (bool) {
220         // This method relies on extcodesize, which returns 0 for contracts in
221         // construction, since the code is only stored at the end of the
222         // constructor execution.
223 
224         uint256 size;
225         assembly {
226             size := extcodesize(account)
227         }
228         return size > 0;
229     }
230 
231     /**
232      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
233      * `recipient`, forwarding all available gas and reverting on errors.
234      *
235      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
236      * of certain opcodes, possibly making contracts go over the 2300 gas limit
237      * imposed by `transfer`, making them unable to receive funds via
238      * `transfer`. {sendValue} removes this limitation.
239      *
240      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
241      *
242      * IMPORTANT: because control is transferred to `recipient`, care must be
243      * taken to not create reentrancy vulnerabilities. Consider using
244      * {ReentrancyGuard} or the
245      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
246      */
247     function sendValue(address payable recipient, uint256 amount) internal {
248         require(address(this).balance >= amount, "Address: insufficient balance");
249 
250         (bool success, ) = recipient.call{value: amount}("");
251         require(success, "Address: unable to send value, recipient may have reverted");
252     }
253 
254     /**
255      * @dev Performs a Solidity function call using a low level `call`. A
256      * plain `call` is an unsafe replacement for a function call: use this
257      * function instead.
258      *
259      * If `target` reverts with a revert reason, it is bubbled up by this
260      * function (like regular Solidity function calls).
261      *
262      * Returns the raw returned data. To convert to the expected return value,
263      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
264      *
265      * Requirements:
266      *
267      * - `target` must be a contract.
268      * - calling `target` with `data` must not revert.
269      *
270      * _Available since v3.1._
271      */
272     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
273         return functionCall(target, data, "Address: low-level call failed");
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
278      * `errorMessage` as a fallback revert reason when `target` reverts.
279      *
280      * _Available since v3.1._
281      */
282     function functionCall(
283         address target,
284         bytes memory data,
285         string memory errorMessage
286     ) internal returns (bytes memory) {
287         return functionCallWithValue(target, data, 0, errorMessage);
288     }
289 
290     /**
291      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
292      * but also transferring `value` wei to `target`.
293      *
294      * Requirements:
295      *
296      * - the calling contract must have an ETH balance of at least `value`.
297      * - the called Solidity function must be `payable`.
298      *
299      * _Available since v3.1._
300      */
301     function functionCallWithValue(
302         address target,
303         bytes memory data,
304         uint256 value
305     ) internal returns (bytes memory) {
306         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
307     }
308 
309     /**
310      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
311      * with `errorMessage` as a fallback revert reason when `target` reverts.
312      *
313      * _Available since v3.1._
314      */
315     function functionCallWithValue(
316         address target,
317         bytes memory data,
318         uint256 value,
319         string memory errorMessage
320     ) internal returns (bytes memory) {
321         require(address(this).balance >= value, "Address: insufficient balance for call");
322         require(isContract(target), "Address: call to non-contract");
323 
324         (bool success, bytes memory returndata) = target.call{value: value}(data);
325         return verifyCallResult(success, returndata, errorMessage);
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
330      * but performing a static call.
331      *
332      * _Available since v3.3._
333      */
334     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
335         return functionStaticCall(target, data, "Address: low-level static call failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
340      * but performing a static call.
341      *
342      * _Available since v3.3._
343      */
344     function functionStaticCall(
345         address target,
346         bytes memory data,
347         string memory errorMessage
348     ) internal view returns (bytes memory) {
349         require(isContract(target), "Address: static call to non-contract");
350 
351         (bool success, bytes memory returndata) = target.staticcall(data);
352         return verifyCallResult(success, returndata, errorMessage);
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
357      * but performing a delegate call.
358      *
359      * _Available since v3.4._
360      */
361     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
362         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
367      * but performing a delegate call.
368      *
369      * _Available since v3.4._
370      */
371     function functionDelegateCall(
372         address target,
373         bytes memory data,
374         string memory errorMessage
375     ) internal returns (bytes memory) {
376         require(isContract(target), "Address: delegate call to non-contract");
377 
378         (bool success, bytes memory returndata) = target.delegatecall(data);
379         return verifyCallResult(success, returndata, errorMessage);
380     }
381 
382     /**
383      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
384      * revert reason using the provided one.
385      *
386      * _Available since v4.3._
387      */
388     function verifyCallResult(
389         bool success,
390         bytes memory returndata,
391         string memory errorMessage
392     ) internal pure returns (bytes memory) {
393         if (success) {
394             return returndata;
395         } else {
396             // Look for revert reason and bubble it up if present
397             if (returndata.length > 0) {
398                 // The easiest way to bubble the revert reason is using memory via assembly
399 
400                 assembly {
401                     let returndata_size := mload(returndata)
402                     revert(add(32, returndata), returndata_size)
403                 }
404             } else {
405                 revert(errorMessage);
406             }
407         }
408     }
409 }
410 
411 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
412 
413 
414 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
415 
416 pragma solidity ^0.8.0;
417 
418 /**
419  * @title ERC721 token receiver interface
420  * @dev Interface for any contract that wants to support safeTransfers
421  * from ERC721 asset contracts.
422  */
423 interface IERC721Receiver {
424     /**
425      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
426      * by `operator` from `from`, this function is called.
427      *
428      * It must return its Solidity selector to confirm the token transfer.
429      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
430      *
431      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
432      */
433     function onERC721Received(
434         address operator,
435         address from,
436         uint256 tokenId,
437         bytes calldata data
438     ) external returns (bytes4);
439 }
440 
441 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
442 
443 
444 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
445 
446 pragma solidity ^0.8.0;
447 
448 /**
449  * @dev Interface of the ERC165 standard, as defined in the
450  * https://eips.ethereum.org/EIPS/eip-165[EIP].
451  *
452  * Implementers can declare support of contract interfaces, which can then be
453  * queried by others ({ERC165Checker}).
454  *
455  * For an implementation, see {ERC165}.
456  */
457 interface IERC165 {
458     /**
459      * @dev Returns true if this contract implements the interface defined by
460      * `interfaceId`. See the corresponding
461      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
462      * to learn more about how these ids are created.
463      *
464      * This function call must use less than 30 000 gas.
465      */
466     function supportsInterface(bytes4 interfaceId) external view returns (bool);
467 }
468 
469 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
470 
471 
472 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
473 
474 pragma solidity ^0.8.0;
475 
476 
477 /**
478  * @dev Implementation of the {IERC165} interface.
479  *
480  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
481  * for the additional interface id that will be supported. For example:
482  *
483  * ```solidity
484  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
485  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
486  * }
487  * ```
488  *
489  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
490  */
491 abstract contract ERC165 is IERC165 {
492     /**
493      * @dev See {IERC165-supportsInterface}.
494      */
495     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
496         return interfaceId == type(IERC165).interfaceId;
497     }
498 }
499 
500 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
501 
502 
503 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
504 
505 pragma solidity ^0.8.0;
506 
507 
508 /**
509  * @dev Required interface of an ERC721 compliant contract.
510  */
511 interface IERC721 is IERC165 {
512     /**
513      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
514      */
515     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
516 
517     /**
518      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
519      */
520     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
521 
522     /**
523      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
524      */
525     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
526 
527     /**
528      * @dev Returns the number of tokens in ``owner``'s account.
529      */
530     function balanceOf(address owner) external view returns (uint256 balance);
531 
532     /**
533      * @dev Returns the owner of the `tokenId` token.
534      *
535      * Requirements:
536      *
537      * - `tokenId` must exist.
538      */
539     function ownerOf(uint256 tokenId) external view returns (address owner);
540 
541     /**
542      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
543      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
544      *
545      * Requirements:
546      *
547      * - `from` cannot be the zero address.
548      * - `to` cannot be the zero address.
549      * - `tokenId` token must exist and be owned by `from`.
550      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
551      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
552      *
553      * Emits a {Transfer} event.
554      */
555     function safeTransferFrom(
556         address from,
557         address to,
558         uint256 tokenId
559     ) external;
560 
561     /**
562      * @dev Transfers `tokenId` token from `from` to `to`.
563      *
564      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
565      *
566      * Requirements:
567      *
568      * - `from` cannot be the zero address.
569      * - `to` cannot be the zero address.
570      * - `tokenId` token must be owned by `from`.
571      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
572      *
573      * Emits a {Transfer} event.
574      */
575     function transferFrom(
576         address from,
577         address to,
578         uint256 tokenId
579     ) external;
580 
581     /**
582      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
583      * The approval is cleared when the token is transferred.
584      *
585      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
586      *
587      * Requirements:
588      *
589      * - The caller must own the token or be an approved operator.
590      * - `tokenId` must exist.
591      *
592      * Emits an {Approval} event.
593      */
594     function approve(address to, uint256 tokenId) external;
595 
596     /**
597      * @dev Returns the account approved for `tokenId` token.
598      *
599      * Requirements:
600      *
601      * - `tokenId` must exist.
602      */
603     function getApproved(uint256 tokenId) external view returns (address operator);
604 
605     /**
606      * @dev Approve or remove `operator` as an operator for the caller.
607      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
608      *
609      * Requirements:
610      *
611      * - The `operator` cannot be the caller.
612      *
613      * Emits an {ApprovalForAll} event.
614      */
615     function setApprovalForAll(address operator, bool _approved) external;
616 
617     /**
618      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
619      *
620      * See {setApprovalForAll}
621      */
622     function isApprovedForAll(address owner, address operator) external view returns (bool);
623 
624     /**
625      * @dev Safely transfers `tokenId` token from `from` to `to`.
626      *
627      * Requirements:
628      *
629      * - `from` cannot be the zero address.
630      * - `to` cannot be the zero address.
631      * - `tokenId` token must exist and be owned by `from`.
632      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
633      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
634      *
635      * Emits a {Transfer} event.
636      */
637     function safeTransferFrom(
638         address from,
639         address to,
640         uint256 tokenId,
641         bytes calldata data
642     ) external;
643 }
644 
645 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
646 
647 
648 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
649 
650 pragma solidity ^0.8.0;
651 
652 
653 /**
654  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
655  * @dev See https://eips.ethereum.org/EIPS/eip-721
656  */
657 interface IERC721Metadata is IERC721 {
658     /**
659      * @dev Returns the token collection name.
660      */
661     function name() external view returns (string memory);
662 
663     /**
664      * @dev Returns the token collection symbol.
665      */
666     function symbol() external view returns (string memory);
667 
668     /**
669      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
670      */
671     function tokenURI(uint256 tokenId) external view returns (string memory);
672 }
673 
674 // File: @openzeppelin/contracts/utils/Strings.sol
675 
676 
677 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
678 
679 pragma solidity ^0.8.0;
680 
681 /**
682  * @dev String operations.
683  */
684 library Strings {
685     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
686 
687     /**
688      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
689      */
690     function toString(uint256 value) internal pure returns (string memory) {
691         // Inspired by OraclizeAPI's implementation - MIT licence
692         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
693 
694         if (value == 0) {
695             return "0";
696         }
697         uint256 temp = value;
698         uint256 digits;
699         while (temp != 0) {
700             digits++;
701             temp /= 10;
702         }
703         bytes memory buffer = new bytes(digits);
704         while (value != 0) {
705             digits -= 1;
706             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
707             value /= 10;
708         }
709         return string(buffer);
710     }
711 
712     /**
713      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
714      */
715     function toHexString(uint256 value) internal pure returns (string memory) {
716         if (value == 0) {
717             return "0x00";
718         }
719         uint256 temp = value;
720         uint256 length = 0;
721         while (temp != 0) {
722             length++;
723             temp >>= 8;
724         }
725         return toHexString(value, length);
726     }
727 
728     /**
729      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
730      */
731     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
732         bytes memory buffer = new bytes(2 * length + 2);
733         buffer[0] = "0";
734         buffer[1] = "x";
735         for (uint256 i = 2 * length + 1; i > 1; --i) {
736             buffer[i] = _HEX_SYMBOLS[value & 0xf];
737             value >>= 4;
738         }
739         require(value == 0, "Strings: hex length insufficient");
740         return string(buffer);
741     }
742 }
743 
744 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
745 
746 
747 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
748 
749 pragma solidity ^0.8.0;
750 
751 
752 
753 
754 
755 
756 
757 
758 /**
759  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
760  * the Metadata extension, but not including the Enumerable extension, which is available separately as
761  * {ERC721Enumerable}.
762  */
763 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
764     using Address for address;
765     using Strings for uint256;
766 
767     // Token name
768     string private _name;
769 
770     // Token symbol
771     string private _symbol;
772 
773     // Mapping from token ID to owner address
774     mapping(uint256 => address) private _owners;
775 
776     // Mapping owner address to token count
777     mapping(address => uint256) private _balances;
778 
779     // Mapping from token ID to approved address
780     mapping(uint256 => address) private _tokenApprovals;
781 
782     // Mapping from owner to operator approvals
783     mapping(address => mapping(address => bool)) private _operatorApprovals;
784 
785     /**
786      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
787      */
788     constructor(string memory name_, string memory symbol_) {
789         _name = name_;
790         _symbol = symbol_;
791     }
792 
793     /**
794      * @dev See {IERC165-supportsInterface}.
795      */
796     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
797         return
798             interfaceId == type(IERC721).interfaceId ||
799             interfaceId == type(IERC721Metadata).interfaceId ||
800             super.supportsInterface(interfaceId);
801     }
802 
803     /**
804      * @dev See {IERC721-balanceOf}.
805      */
806     function balanceOf(address owner) public view virtual override returns (uint256) {
807         require(owner != address(0), "ERC721: balance query for the zero address");
808         return _balances[owner];
809     }
810 
811     /**
812      * @dev See {IERC721-ownerOf}.
813      */
814     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
815         address owner = _owners[tokenId];
816         require(owner != address(0), "ERC721: owner query for nonexistent token");
817         return owner;
818     }
819 
820     /**
821      * @dev See {IERC721Metadata-name}.
822      */
823     function name() public view virtual override returns (string memory) {
824         return _name;
825     }
826 
827     /**
828      * @dev See {IERC721Metadata-symbol}.
829      */
830     function symbol() public view virtual override returns (string memory) {
831         return _symbol;
832     }
833 
834     /**
835      * @dev See {IERC721Metadata-tokenURI}.
836      */
837     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
838         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
839 
840         string memory baseURI = _baseURI();
841         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
842     }
843 
844     /**
845      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
846      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
847      * by default, can be overriden in child contracts.
848      */
849     function _baseURI() internal view virtual returns (string memory) {
850         return "";
851     }
852 
853     /**
854      * @dev See {IERC721-approve}.
855      */
856     function approve(address to, uint256 tokenId) public virtual override {
857         address owner = ERC721.ownerOf(tokenId);
858         require(to != owner, "ERC721: approval to current owner");
859 
860         require(
861             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
862             "ERC721: approve caller is not owner nor approved for all"
863         );
864 
865         _approve(to, tokenId);
866     }
867 
868     /**
869      * @dev See {IERC721-getApproved}.
870      */
871     function getApproved(uint256 tokenId) public view virtual override returns (address) {
872         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
873 
874         return _tokenApprovals[tokenId];
875     }
876 
877     /**
878      * @dev See {IERC721-setApprovalForAll}.
879      */
880     function setApprovalForAll(address operator, bool approved) public virtual override {
881         _setApprovalForAll(_msgSender(), operator, approved);
882     }
883 
884     /**
885      * @dev See {IERC721-isApprovedForAll}.
886      */
887     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
888         return _operatorApprovals[owner][operator];
889     }
890 
891     /**
892      * @dev See {IERC721-transferFrom}.
893      */
894     function transferFrom(
895         address from,
896         address to,
897         uint256 tokenId
898     ) public virtual override {
899         //solhint-disable-next-line max-line-length
900         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
901 
902         _transfer(from, to, tokenId);
903     }
904 
905     /**
906      * @dev See {IERC721-safeTransferFrom}.
907      */
908     function safeTransferFrom(
909         address from,
910         address to,
911         uint256 tokenId
912     ) public virtual override {
913         safeTransferFrom(from, to, tokenId, "");
914     }
915 
916     /**
917      * @dev See {IERC721-safeTransferFrom}.
918      */
919     function safeTransferFrom(
920         address from,
921         address to,
922         uint256 tokenId,
923         bytes memory _data
924     ) public virtual override {
925         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
926         _safeTransfer(from, to, tokenId, _data);
927     }
928 
929     /**
930      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
931      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
932      *
933      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
934      *
935      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
936      * implement alternative mechanisms to perform token transfer, such as signature-based.
937      *
938      * Requirements:
939      *
940      * - `from` cannot be the zero address.
941      * - `to` cannot be the zero address.
942      * - `tokenId` token must exist and be owned by `from`.
943      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
944      *
945      * Emits a {Transfer} event.
946      */
947     function _safeTransfer(
948         address from,
949         address to,
950         uint256 tokenId,
951         bytes memory _data
952     ) internal virtual {
953         _transfer(from, to, tokenId);
954         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
955     }
956 
957     /**
958      * @dev Returns whether `tokenId` exists.
959      *
960      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
961      *
962      * Tokens start existing when they are minted (`_mint`),
963      * and stop existing when they are burned (`_burn`).
964      */
965     function _exists(uint256 tokenId) internal view virtual returns (bool) {
966         return _owners[tokenId] != address(0);
967     }
968 
969     /**
970      * @dev Returns whether `spender` is allowed to manage `tokenId`.
971      *
972      * Requirements:
973      *
974      * - `tokenId` must exist.
975      */
976     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
977         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
978         address owner = ERC721.ownerOf(tokenId);
979         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
980     }
981 
982     /**
983      * @dev Safely mints `tokenId` and transfers it to `to`.
984      *
985      * Requirements:
986      *
987      * - `tokenId` must not exist.
988      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
989      *
990      * Emits a {Transfer} event.
991      */
992     function _safeMint(address to, uint256 tokenId) internal virtual {
993         _safeMint(to, tokenId, "");
994     }
995 
996     /**
997      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
998      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
999      */
1000     function _safeMint(
1001         address to,
1002         uint256 tokenId,
1003         bytes memory _data
1004     ) internal virtual {
1005         _mint(to, tokenId);
1006         require(
1007             _checkOnERC721Received(address(0), to, tokenId, _data),
1008             "ERC721: transfer to non ERC721Receiver implementer"
1009         );
1010     }
1011 
1012     /**
1013      * @dev Mints `tokenId` and transfers it to `to`.
1014      *
1015      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1016      *
1017      * Requirements:
1018      *
1019      * - `tokenId` must not exist.
1020      * - `to` cannot be the zero address.
1021      *
1022      * Emits a {Transfer} event.
1023      */
1024     function _mint(address to, uint256 tokenId) internal virtual {
1025         require(to != address(0), "ERC721: mint to the zero address");
1026         require(!_exists(tokenId), "ERC721: token already minted");
1027 
1028         _beforeTokenTransfer(address(0), to, tokenId);
1029 
1030         _balances[to] += 1;
1031         _owners[tokenId] = to;
1032 
1033         emit Transfer(address(0), to, tokenId);
1034     }
1035 
1036     /**
1037      * @dev Destroys `tokenId`.
1038      * The approval is cleared when the token is burned.
1039      *
1040      * Requirements:
1041      *
1042      * - `tokenId` must exist.
1043      *
1044      * Emits a {Transfer} event.
1045      */
1046     function _burn(uint256 tokenId) internal virtual {
1047         address owner = ERC721.ownerOf(tokenId);
1048 
1049         _beforeTokenTransfer(owner, address(0), tokenId);
1050 
1051         // Clear approvals
1052         _approve(address(0), tokenId);
1053 
1054         _balances[owner] -= 1;
1055         delete _owners[tokenId];
1056 
1057         emit Transfer(owner, address(0), tokenId);
1058     }
1059 
1060     /**
1061      * @dev Transfers `tokenId` from `from` to `to`.
1062      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1063      *
1064      * Requirements:
1065      *
1066      * - `to` cannot be the zero address.
1067      * - `tokenId` token must be owned by `from`.
1068      *
1069      * Emits a {Transfer} event.
1070      */
1071     function _transfer(
1072         address from,
1073         address to,
1074         uint256 tokenId
1075     ) internal virtual {
1076         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1077         require(to != address(0), "ERC721: transfer to the zero address");
1078 
1079         _beforeTokenTransfer(from, to, tokenId);
1080 
1081         // Clear approvals from the previous owner
1082         _approve(address(0), tokenId);
1083 
1084         _balances[from] -= 1;
1085         _balances[to] += 1;
1086         _owners[tokenId] = to;
1087 
1088         emit Transfer(from, to, tokenId);
1089     }
1090 
1091     /**
1092      * @dev Approve `to` to operate on `tokenId`
1093      *
1094      * Emits a {Approval} event.
1095      */
1096     function _approve(address to, uint256 tokenId) internal virtual {
1097         _tokenApprovals[tokenId] = to;
1098         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1099     }
1100 
1101     /**
1102      * @dev Approve `operator` to operate on all of `owner` tokens
1103      *
1104      * Emits a {ApprovalForAll} event.
1105      */
1106     function _setApprovalForAll(
1107         address owner,
1108         address operator,
1109         bool approved
1110     ) internal virtual {
1111         require(owner != operator, "ERC721: approve to caller");
1112         _operatorApprovals[owner][operator] = approved;
1113         emit ApprovalForAll(owner, operator, approved);
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
1134                 return retval == IERC721Receiver.onERC721Received.selector;
1135             } catch (bytes memory reason) {
1136                 if (reason.length == 0) {
1137                     revert("ERC721: transfer to non ERC721Receiver implementer");
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
1150      * @dev Hook that is called before any token transfer. This includes minting
1151      * and burning.
1152      *
1153      * Calling conditions:
1154      *
1155      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1156      * transferred to `to`.
1157      * - When `from` is zero, `tokenId` will be minted for `to`.
1158      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1159      * - `from` and `to` are never both zero.
1160      *
1161      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1162      */
1163     function _beforeTokenTransfer(
1164         address from,
1165         address to,
1166         uint256 tokenId
1167     ) internal virtual {}
1168 }
1169 
1170 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
1171 
1172 
1173 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
1174 
1175 pragma solidity ^0.8.0;
1176 
1177 
1178 /**
1179  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1180  *
1181  * These functions can be used to verify that a message was signed by the holder
1182  * of the private keys of a given address.
1183  */
1184 library ECDSA {
1185     enum RecoverError {
1186         NoError,
1187         InvalidSignature,
1188         InvalidSignatureLength,
1189         InvalidSignatureS,
1190         InvalidSignatureV
1191     }
1192 
1193     function _throwError(RecoverError error) private pure {
1194         if (error == RecoverError.NoError) {
1195             return; // no error: do nothing
1196         } else if (error == RecoverError.InvalidSignature) {
1197             revert("ECDSA: invalid signature");
1198         } else if (error == RecoverError.InvalidSignatureLength) {
1199             revert("ECDSA: invalid signature length");
1200         } else if (error == RecoverError.InvalidSignatureS) {
1201             revert("ECDSA: invalid signature 's' value");
1202         } else if (error == RecoverError.InvalidSignatureV) {
1203             revert("ECDSA: invalid signature 'v' value");
1204         }
1205     }
1206 
1207     /**
1208      * @dev Returns the address that signed a hashed message (`hash`) with
1209      * `signature` or error string. This address can then be used for verification purposes.
1210      *
1211      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1212      * this function rejects them by requiring the `s` value to be in the lower
1213      * half order, and the `v` value to be either 27 or 28.
1214      *
1215      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1216      * verification to be secure: it is possible to craft signatures that
1217      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1218      * this is by receiving a hash of the original message (which may otherwise
1219      * be too long), and then calling {toEthSignedMessageHash} on it.
1220      *
1221      * Documentation for signature generation:
1222      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1223      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1224      *
1225      * _Available since v4.3._
1226      */
1227     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1228         // Check the signature length
1229         // - case 65: r,s,v signature (standard)
1230         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1231         if (signature.length == 65) {
1232             bytes32 r;
1233             bytes32 s;
1234             uint8 v;
1235             // ecrecover takes the signature parameters, and the only way to get them
1236             // currently is to use assembly.
1237             assembly {
1238                 r := mload(add(signature, 0x20))
1239                 s := mload(add(signature, 0x40))
1240                 v := byte(0, mload(add(signature, 0x60)))
1241             }
1242             return tryRecover(hash, v, r, s);
1243         } else if (signature.length == 64) {
1244             bytes32 r;
1245             bytes32 vs;
1246             // ecrecover takes the signature parameters, and the only way to get them
1247             // currently is to use assembly.
1248             assembly {
1249                 r := mload(add(signature, 0x20))
1250                 vs := mload(add(signature, 0x40))
1251             }
1252             return tryRecover(hash, r, vs);
1253         } else {
1254             return (address(0), RecoverError.InvalidSignatureLength);
1255         }
1256     }
1257 
1258     /**
1259      * @dev Returns the address that signed a hashed message (`hash`) with
1260      * `signature`. This address can then be used for verification purposes.
1261      *
1262      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1263      * this function rejects them by requiring the `s` value to be in the lower
1264      * half order, and the `v` value to be either 27 or 28.
1265      *
1266      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1267      * verification to be secure: it is possible to craft signatures that
1268      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1269      * this is by receiving a hash of the original message (which may otherwise
1270      * be too long), and then calling {toEthSignedMessageHash} on it.
1271      */
1272     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1273         (address recovered, RecoverError error) = tryRecover(hash, signature);
1274         _throwError(error);
1275         return recovered;
1276     }
1277 
1278     /**
1279      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1280      *
1281      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1282      *
1283      * _Available since v4.3._
1284      */
1285     function tryRecover(
1286         bytes32 hash,
1287         bytes32 r,
1288         bytes32 vs
1289     ) internal pure returns (address, RecoverError) {
1290         bytes32 s;
1291         uint8 v;
1292         assembly {
1293             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1294             v := add(shr(255, vs), 27)
1295         }
1296         return tryRecover(hash, v, r, s);
1297     }
1298 
1299     /**
1300      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1301      *
1302      * _Available since v4.2._
1303      */
1304     function recover(
1305         bytes32 hash,
1306         bytes32 r,
1307         bytes32 vs
1308     ) internal pure returns (address) {
1309         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1310         _throwError(error);
1311         return recovered;
1312     }
1313 
1314     /**
1315      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1316      * `r` and `s` signature fields separately.
1317      *
1318      * _Available since v4.3._
1319      */
1320     function tryRecover(
1321         bytes32 hash,
1322         uint8 v,
1323         bytes32 r,
1324         bytes32 s
1325     ) internal pure returns (address, RecoverError) {
1326         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1327         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1328         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1329         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1330         //
1331         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1332         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1333         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1334         // these malleable signatures as well.
1335         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1336             return (address(0), RecoverError.InvalidSignatureS);
1337         }
1338         if (v != 27 && v != 28) {
1339             return (address(0), RecoverError.InvalidSignatureV);
1340         }
1341 
1342         // If the signature is valid (and not malleable), return the signer address
1343         address signer = ecrecover(hash, v, r, s);
1344         if (signer == address(0)) {
1345             return (address(0), RecoverError.InvalidSignature);
1346         }
1347 
1348         return (signer, RecoverError.NoError);
1349     }
1350 
1351     /**
1352      * @dev Overload of {ECDSA-recover} that receives the `v`,
1353      * `r` and `s` signature fields separately.
1354      */
1355     function recover(
1356         bytes32 hash,
1357         uint8 v,
1358         bytes32 r,
1359         bytes32 s
1360     ) internal pure returns (address) {
1361         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1362         _throwError(error);
1363         return recovered;
1364     }
1365 
1366     /**
1367      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1368      * produces hash corresponding to the one signed with the
1369      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1370      * JSON-RPC method as part of EIP-191.
1371      *
1372      * See {recover}.
1373      */
1374     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1375         // 32 is the length in bytes of hash,
1376         // enforced by the type signature above
1377         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1378     }
1379 
1380     /**
1381      * @dev Returns an Ethereum Signed Message, created from `s`. This
1382      * produces hash corresponding to the one signed with the
1383      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1384      * JSON-RPC method as part of EIP-191.
1385      *
1386      * See {recover}.
1387      */
1388     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1389         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1390     }
1391 
1392     /**
1393      * @dev Returns an Ethereum Signed Typed Data, created from a
1394      * `domainSeparator` and a `structHash`. This produces hash corresponding
1395      * to the one signed with the
1396      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1397      * JSON-RPC method as part of EIP-712.
1398      *
1399      * See {recover}.
1400      */
1401     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1402         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1403     }
1404 }
1405 
1406 // File: Misc/Verification/TheSevensCompanions.sol
1407 
1408 
1409 pragma solidity ^0.8.7;
1410 
1411 
1412 
1413 
1414 
1415 contract TheSevensCompanions is ERC721, Ownable{
1416     using Strings for uint;
1417     using ECDSA for bytes32;
1418 
1419     constructor(IERC20 zeniContract_,string memory baseURI_) ERC721("The Sevens Companions","7COMP") {
1420         zeniContract = zeniContract_;
1421         baseURI = baseURI_;
1422         saleStartTime = 1640199600;
1423         _batchMint(address(0x1C9dEbB357b031e3220bEdF6a4F3710c773c145D), 49);
1424     }
1425 
1426 
1427     // Constants
1428 
1429     uint constant zeniToClaim = 350e18;
1430     uint constant etherToMint = 0.049e18;
1431 
1432     uint constant maxSupply = 7000;
1433 
1434     uint constant maxPerTransaction = 21;
1435 
1436     address constant dead = address(0x000000000000000000000000000000000000dEaD);
1437 
1438 
1439     // Storage Variables
1440 
1441     uint public saleStartTime;  
1442     uint public totalSupply = 0;
1443 
1444     string baseURI;
1445 
1446     IERC20 zeniContract;
1447 
1448     address stakingContract = address(0);
1449     address signer = 0x94382f4bcCD5c1Cb0B2B3A5CAA16B2909c0E494d;
1450 
1451     mapping(address => uint) public whitelistMintAmount;
1452 
1453     // Modifiers
1454 
1455     modifier mintChecks(uint amount, uint offset) {
1456         require(msg.sender == tx.origin, "No");
1457         
1458         require(amount <= maxPerTransaction,string(abi.encodePacked("You can only mint up to ", maxPerTransaction.toString() ," per transaction")));
1459         
1460         uint timeNow = block.timestamp;
1461         uint startTime = saleStartTime;
1462         require(startTime != 0, "Sale start time is not setup!");
1463         require(startTime + offset <= timeNow && timeNow <= startTime + 2 weeks,"Sale is not active!");
1464         _;
1465     }
1466 
1467     modifier etherMintChecks(uint amount) {
1468         require(msg.value == amount * etherToMint,"Invalid amount sent");
1469         _;
1470     }
1471 
1472     // Minting Functions
1473 
1474     function zeniMint(uint amount) external mintChecks(amount, 0) {
1475         zeniContract.transferFrom(msg.sender, dead, amount * zeniToClaim);
1476 
1477         _batchMint(msg.sender, amount);
1478     }
1479 
1480 
1481     function etherWhitelistMint(uint amount, uint maxMints, bytes calldata signature) external payable mintChecks(amount, 1 days) etherMintChecks(amount) {
1482         require(keccak256(abi.encode(msg.sender, maxMints)).toEthSignedMessageHash().recover(signature) == signer,"Invalid signature received");
1483         require(whitelistMintAmount[msg.sender] + amount <= maxMints, string(abi.encodePacked("You can only mint up to ", maxMints.toString(), " using your whitelist!")));
1484         whitelistMintAmount[msg.sender] += amount;
1485 
1486         _batchMint(msg.sender, amount);
1487     }
1488 
1489     function etherMint(uint amount) external payable mintChecks(amount, 2 days) etherMintChecks(amount) {
1490         _batchMint(msg.sender, amount);
1491     }
1492 
1493 
1494     function _batchMint(address to, uint amount) internal {
1495         uint nextId = totalSupply;
1496         require(nextId + amount <= maxSupply, "Mint would exceed supply");
1497         for(uint i = 1; i <= amount; i++) {
1498             _mint(to, nextId + i);
1499         }
1500         totalSupply += amount;
1501     }
1502 
1503     // View Only Functions
1504 
1505     function tokenURI(uint tokenId) public view override returns(string memory) {
1506         require(_exists(tokenId), string(abi.encodePacked("Token ", tokenId.toString(), " does not exist")));
1507         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
1508     }
1509 
1510     // Owner Only
1511 
1512     function adminSetSaleStartTime(uint startTime) external onlyOwner {
1513         saleStartTime = startTime;
1514     }
1515 
1516     bool public metadataLocked = false;
1517     function adminLockMetadata() external onlyOwner {
1518         metadataLocked = true;
1519     }
1520 
1521     function adminSetBaseURI(string memory baseURI_) external onlyOwner {
1522         require(!metadataLocked);
1523         baseURI = baseURI_;
1524     }
1525 
1526     function adminSetZeni(IERC20 zeniContract_) external onlyOwner {
1527         zeniContract = zeniContract_;
1528     }
1529 
1530     function adminSetStaking(address stakingContract_) external onlyOwner {
1531         stakingContract = stakingContract_;
1532     }
1533 
1534     function adminSetSigner(address signer_) external onlyOwner {
1535         signer = signer_;
1536     }
1537 
1538     function withdraw() external onlyOwner {
1539         payable(0xE776DF26ac31C46a302F495c61b1fab1198C582a).transfer(address(this).balance);
1540     }
1541 
1542     // Staking
1543 
1544     function takeToken(address from,uint tokenId) external {
1545         require(msg.sender == stakingContract);
1546         _transfer(from,msg.sender,tokenId);
1547     }
1548 }