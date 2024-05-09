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
86 // File: @openzeppelin/contracts/utils/Strings.sol
87 
88 
89 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 /**
94  * @dev String operations.
95  */
96 library Strings {
97     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
98 
99     /**
100      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
101      */
102     function toString(uint256 value) internal pure returns (string memory) {
103         // Inspired by OraclizeAPI's implementation - MIT licence
104         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
105 
106         if (value == 0) {
107             return "0";
108         }
109         uint256 temp = value;
110         uint256 digits;
111         while (temp != 0) {
112             digits++;
113             temp /= 10;
114         }
115         bytes memory buffer = new bytes(digits);
116         while (value != 0) {
117             digits -= 1;
118             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
119             value /= 10;
120         }
121         return string(buffer);
122     }
123 
124     /**
125      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
126      */
127     function toHexString(uint256 value) internal pure returns (string memory) {
128         if (value == 0) {
129             return "0x00";
130         }
131         uint256 temp = value;
132         uint256 length = 0;
133         while (temp != 0) {
134             length++;
135             temp >>= 8;
136         }
137         return toHexString(value, length);
138     }
139 
140     /**
141      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
142      */
143     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
144         bytes memory buffer = new bytes(2 * length + 2);
145         buffer[0] = "0";
146         buffer[1] = "x";
147         for (uint256 i = 2 * length + 1; i > 1; --i) {
148             buffer[i] = _HEX_SYMBOLS[value & 0xf];
149             value >>= 4;
150         }
151         require(value == 0, "Strings: hex length insufficient");
152         return string(buffer);
153     }
154 }
155 
156 // File: @openzeppelin/contracts/utils/Context.sol
157 
158 
159 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
160 
161 pragma solidity ^0.8.0;
162 
163 /**
164  * @dev Provides information about the current execution context, including the
165  * sender of the transaction and its data. While these are generally available
166  * via msg.sender and msg.data, they should not be accessed in such a direct
167  * manner, since when dealing with meta-transactions the account sending and
168  * paying for execution may not be the actual sender (as far as an application
169  * is concerned).
170  *
171  * This contract is only required for intermediate, library-like contracts.
172  */
173 abstract contract Context {
174     function _msgSender() internal view virtual returns (address) {
175         return msg.sender;
176     }
177 
178     function _msgData() internal view virtual returns (bytes calldata) {
179         return msg.data;
180     }
181 }
182 
183 // File: @openzeppelin/contracts/access/Ownable.sol
184 
185 
186 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
187 
188 pragma solidity ^0.8.0;
189 
190 
191 /**
192  * @dev Contract module which provides a basic access control mechanism, where
193  * there is an account (an owner) that can be granted exclusive access to
194  * specific functions.
195  *
196  * By default, the owner account will be the one that deploys the contract. This
197  * can later be changed with {transferOwnership}.
198  *
199  * This module is used through inheritance. It will make available the modifier
200  * `onlyOwner`, which can be applied to your functions to restrict their use to
201  * the owner.
202  */
203 abstract contract Ownable is Context {
204     address private _owner;
205 
206     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
207 
208     /**
209      * @dev Initializes the contract setting the deployer as the initial owner.
210      */
211     constructor() {
212         _transferOwnership(_msgSender());
213     }
214 
215     /**
216      * @dev Returns the address of the current owner.
217      */
218     function owner() public view virtual returns (address) {
219         return _owner;
220     }
221 
222     /**
223      * @dev Throws if called by any account other than the owner.
224      */
225     modifier onlyOwner() {
226         require(owner() == _msgSender(), "Ownable: caller is not the owner");
227         _;
228     }
229 
230     /**
231      * @dev Leaves the contract without owner. It will not be possible to call
232      * `onlyOwner` functions anymore. Can only be called by the current owner.
233      *
234      * NOTE: Renouncing ownership will leave the contract without an owner,
235      * thereby removing any functionality that is only available to the owner.
236      */
237     function renounceOwnership() public virtual onlyOwner {
238         _transferOwnership(address(0));
239     }
240 
241     /**
242      * @dev Transfers ownership of the contract to a new account (`newOwner`).
243      * Can only be called by the current owner.
244      */
245     function transferOwnership(address newOwner) public virtual onlyOwner {
246         require(newOwner != address(0), "Ownable: new owner is the zero address");
247         _transferOwnership(newOwner);
248     }
249 
250     /**
251      * @dev Transfers ownership of the contract to a new account (`newOwner`).
252      * Internal function without access restriction.
253      */
254     function _transferOwnership(address newOwner) internal virtual {
255         address oldOwner = _owner;
256         _owner = newOwner;
257         emit OwnershipTransferred(oldOwner, newOwner);
258     }
259 }
260 
261 // File: @openzeppelin/contracts/security/Pausable.sol
262 
263 
264 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
265 
266 pragma solidity ^0.8.0;
267 
268 
269 /**
270  * @dev Contract module which allows children to implement an emergency stop
271  * mechanism that can be triggered by an authorized account.
272  *
273  * This module is used through inheritance. It will make available the
274  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
275  * the functions of your contract. Note that they will not be pausable by
276  * simply including this module, only once the modifiers are put in place.
277  */
278 abstract contract Pausable is Context {
279     /**
280      * @dev Emitted when the pause is triggered by `account`.
281      */
282     event Paused(address account);
283 
284     /**
285      * @dev Emitted when the pause is lifted by `account`.
286      */
287     event Unpaused(address account);
288 
289     bool private _paused;
290 
291     /**
292      * @dev Initializes the contract in unpaused state.
293      */
294     constructor() {
295         _paused = false;
296     }
297 
298     /**
299      * @dev Returns true if the contract is paused, and false otherwise.
300      */
301     function paused() public view virtual returns (bool) {
302         return _paused;
303     }
304 
305     /**
306      * @dev Modifier to make a function callable only when the contract is not paused.
307      *
308      * Requirements:
309      *
310      * - The contract must not be paused.
311      */
312     modifier whenNotPaused() {
313         require(!paused(), "Pausable: paused");
314         _;
315     }
316 
317     /**
318      * @dev Modifier to make a function callable only when the contract is paused.
319      *
320      * Requirements:
321      *
322      * - The contract must be paused.
323      */
324     modifier whenPaused() {
325         require(paused(), "Pausable: not paused");
326         _;
327     }
328 
329     /**
330      * @dev Triggers stopped state.
331      *
332      * Requirements:
333      *
334      * - The contract must not be paused.
335      */
336     function _pause() internal virtual whenNotPaused {
337         _paused = true;
338         emit Paused(_msgSender());
339     }
340 
341     /**
342      * @dev Returns to normal state.
343      *
344      * Requirements:
345      *
346      * - The contract must be paused.
347      */
348     function _unpause() internal virtual whenPaused {
349         _paused = false;
350         emit Unpaused(_msgSender());
351     }
352 }
353 
354 // File: @openzeppelin/contracts/utils/Address.sol
355 
356 
357 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
358 
359 pragma solidity ^0.8.0;
360 
361 /**
362  * @dev Collection of functions related to the address type
363  */
364 library Address {
365     /**
366      * @dev Returns true if `account` is a contract.
367      *
368      * [IMPORTANT]
369      * ====
370      * It is unsafe to assume that an address for which this function returns
371      * false is an externally-owned account (EOA) and not a contract.
372      *
373      * Among others, `isContract` will return false for the following
374      * types of addresses:
375      *
376      *  - an externally-owned account
377      *  - a contract in construction
378      *  - an address where a contract will be created
379      *  - an address where a contract lived, but was destroyed
380      * ====
381      */
382     function isContract(address account) internal view returns (bool) {
383         // This method relies on extcodesize, which returns 0 for contracts in
384         // construction, since the code is only stored at the end of the
385         // constructor execution.
386 
387         uint256 size;
388         assembly {
389             size := extcodesize(account)
390         }
391         return size > 0;
392     }
393 
394     /**
395      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
396      * `recipient`, forwarding all available gas and reverting on errors.
397      *
398      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
399      * of certain opcodes, possibly making contracts go over the 2300 gas limit
400      * imposed by `transfer`, making them unable to receive funds via
401      * `transfer`. {sendValue} removes this limitation.
402      *
403      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
404      *
405      * IMPORTANT: because control is transferred to `recipient`, care must be
406      * taken to not create reentrancy vulnerabilities. Consider using
407      * {ReentrancyGuard} or the
408      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
409      */
410     function sendValue(address payable recipient, uint256 amount) internal {
411         require(address(this).balance >= amount, "Address: insufficient balance");
412 
413         (bool success, ) = recipient.call{value: amount}("");
414         require(success, "Address: unable to send value, recipient may have reverted");
415     }
416 
417     /**
418      * @dev Performs a Solidity function call using a low level `call`. A
419      * plain `call` is an unsafe replacement for a function call: use this
420      * function instead.
421      *
422      * If `target` reverts with a revert reason, it is bubbled up by this
423      * function (like regular Solidity function calls).
424      *
425      * Returns the raw returned data. To convert to the expected return value,
426      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
427      *
428      * Requirements:
429      *
430      * - `target` must be a contract.
431      * - calling `target` with `data` must not revert.
432      *
433      * _Available since v3.1._
434      */
435     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
436         return functionCall(target, data, "Address: low-level call failed");
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
441      * `errorMessage` as a fallback revert reason when `target` reverts.
442      *
443      * _Available since v3.1._
444      */
445     function functionCall(
446         address target,
447         bytes memory data,
448         string memory errorMessage
449     ) internal returns (bytes memory) {
450         return functionCallWithValue(target, data, 0, errorMessage);
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
455      * but also transferring `value` wei to `target`.
456      *
457      * Requirements:
458      *
459      * - the calling contract must have an ETH balance of at least `value`.
460      * - the called Solidity function must be `payable`.
461      *
462      * _Available since v3.1._
463      */
464     function functionCallWithValue(
465         address target,
466         bytes memory data,
467         uint256 value
468     ) internal returns (bytes memory) {
469         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
474      * with `errorMessage` as a fallback revert reason when `target` reverts.
475      *
476      * _Available since v3.1._
477      */
478     function functionCallWithValue(
479         address target,
480         bytes memory data,
481         uint256 value,
482         string memory errorMessage
483     ) internal returns (bytes memory) {
484         require(address(this).balance >= value, "Address: insufficient balance for call");
485         require(isContract(target), "Address: call to non-contract");
486 
487         (bool success, bytes memory returndata) = target.call{value: value}(data);
488         return verifyCallResult(success, returndata, errorMessage);
489     }
490 
491     /**
492      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
493      * but performing a static call.
494      *
495      * _Available since v3.3._
496      */
497     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
498         return functionStaticCall(target, data, "Address: low-level static call failed");
499     }
500 
501     /**
502      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
503      * but performing a static call.
504      *
505      * _Available since v3.3._
506      */
507     function functionStaticCall(
508         address target,
509         bytes memory data,
510         string memory errorMessage
511     ) internal view returns (bytes memory) {
512         require(isContract(target), "Address: static call to non-contract");
513 
514         (bool success, bytes memory returndata) = target.staticcall(data);
515         return verifyCallResult(success, returndata, errorMessage);
516     }
517 
518     /**
519      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
520      * but performing a delegate call.
521      *
522      * _Available since v3.4._
523      */
524     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
525         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
526     }
527 
528     /**
529      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
530      * but performing a delegate call.
531      *
532      * _Available since v3.4._
533      */
534     function functionDelegateCall(
535         address target,
536         bytes memory data,
537         string memory errorMessage
538     ) internal returns (bytes memory) {
539         require(isContract(target), "Address: delegate call to non-contract");
540 
541         (bool success, bytes memory returndata) = target.delegatecall(data);
542         return verifyCallResult(success, returndata, errorMessage);
543     }
544 
545     /**
546      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
547      * revert reason using the provided one.
548      *
549      * _Available since v4.3._
550      */
551     function verifyCallResult(
552         bool success,
553         bytes memory returndata,
554         string memory errorMessage
555     ) internal pure returns (bytes memory) {
556         if (success) {
557             return returndata;
558         } else {
559             // Look for revert reason and bubble it up if present
560             if (returndata.length > 0) {
561                 // The easiest way to bubble the revert reason is using memory via assembly
562 
563                 assembly {
564                     let returndata_size := mload(returndata)
565                     revert(add(32, returndata), returndata_size)
566                 }
567             } else {
568                 revert(errorMessage);
569             }
570         }
571     }
572 }
573 
574 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
575 
576 
577 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
578 
579 pragma solidity ^0.8.0;
580 
581 /**
582  * @title ERC721 token receiver interface
583  * @dev Interface for any contract that wants to support safeTransfers
584  * from ERC721 asset contracts.
585  */
586 interface IERC721Receiver {
587     /**
588      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
589      * by `operator` from `from`, this function is called.
590      *
591      * It must return its Solidity selector to confirm the token transfer.
592      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
593      *
594      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
595      */
596     function onERC721Received(
597         address operator,
598         address from,
599         uint256 tokenId,
600         bytes calldata data
601     ) external returns (bytes4);
602 }
603 
604 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
605 
606 
607 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
608 
609 pragma solidity ^0.8.0;
610 
611 /**
612  * @dev Interface of the ERC165 standard, as defined in the
613  * https://eips.ethereum.org/EIPS/eip-165[EIP].
614  *
615  * Implementers can declare support of contract interfaces, which can then be
616  * queried by others ({ERC165Checker}).
617  *
618  * For an implementation, see {ERC165}.
619  */
620 interface IERC165 {
621     /**
622      * @dev Returns true if this contract implements the interface defined by
623      * `interfaceId`. See the corresponding
624      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
625      * to learn more about how these ids are created.
626      *
627      * This function call must use less than 30 000 gas.
628      */
629     function supportsInterface(bytes4 interfaceId) external view returns (bool);
630 }
631 
632 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
633 
634 
635 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
636 
637 pragma solidity ^0.8.0;
638 
639 
640 /**
641  * @dev Implementation of the {IERC165} interface.
642  *
643  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
644  * for the additional interface id that will be supported. For example:
645  *
646  * ```solidity
647  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
648  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
649  * }
650  * ```
651  *
652  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
653  */
654 abstract contract ERC165 is IERC165 {
655     /**
656      * @dev See {IERC165-supportsInterface}.
657      */
658     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
659         return interfaceId == type(IERC165).interfaceId;
660     }
661 }
662 
663 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
664 
665 
666 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
667 
668 pragma solidity ^0.8.0;
669 
670 
671 /**
672  * @dev Required interface of an ERC721 compliant contract.
673  */
674 interface IERC721 is IERC165 {
675     /**
676      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
677      */
678     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
679 
680     /**
681      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
682      */
683     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
684 
685     /**
686      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
687      */
688     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
689 
690     /**
691      * @dev Returns the number of tokens in ``owner``'s account.
692      */
693     function balanceOf(address owner) external view returns (uint256 balance);
694 
695     /**
696      * @dev Returns the owner of the `tokenId` token.
697      *
698      * Requirements:
699      *
700      * - `tokenId` must exist.
701      */
702     function ownerOf(uint256 tokenId) external view returns (address owner);
703 
704     /**
705      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
706      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
707      *
708      * Requirements:
709      *
710      * - `from` cannot be the zero address.
711      * - `to` cannot be the zero address.
712      * - `tokenId` token must exist and be owned by `from`.
713      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
714      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
715      *
716      * Emits a {Transfer} event.
717      */
718     function safeTransferFrom(
719         address from,
720         address to,
721         uint256 tokenId
722     ) external;
723 
724     /**
725      * @dev Transfers `tokenId` token from `from` to `to`.
726      *
727      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
728      *
729      * Requirements:
730      *
731      * - `from` cannot be the zero address.
732      * - `to` cannot be the zero address.
733      * - `tokenId` token must be owned by `from`.
734      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
735      *
736      * Emits a {Transfer} event.
737      */
738     function transferFrom(
739         address from,
740         address to,
741         uint256 tokenId
742     ) external;
743 
744     /**
745      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
746      * The approval is cleared when the token is transferred.
747      *
748      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
749      *
750      * Requirements:
751      *
752      * - The caller must own the token or be an approved operator.
753      * - `tokenId` must exist.
754      *
755      * Emits an {Approval} event.
756      */
757     function approve(address to, uint256 tokenId) external;
758 
759     /**
760      * @dev Returns the account approved for `tokenId` token.
761      *
762      * Requirements:
763      *
764      * - `tokenId` must exist.
765      */
766     function getApproved(uint256 tokenId) external view returns (address operator);
767 
768     /**
769      * @dev Approve or remove `operator` as an operator for the caller.
770      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
771      *
772      * Requirements:
773      *
774      * - The `operator` cannot be the caller.
775      *
776      * Emits an {ApprovalForAll} event.
777      */
778     function setApprovalForAll(address operator, bool _approved) external;
779 
780     /**
781      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
782      *
783      * See {setApprovalForAll}
784      */
785     function isApprovedForAll(address owner, address operator) external view returns (bool);
786 
787     /**
788      * @dev Safely transfers `tokenId` token from `from` to `to`.
789      *
790      * Requirements:
791      *
792      * - `from` cannot be the zero address.
793      * - `to` cannot be the zero address.
794      * - `tokenId` token must exist and be owned by `from`.
795      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
796      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
797      *
798      * Emits a {Transfer} event.
799      */
800     function safeTransferFrom(
801         address from,
802         address to,
803         uint256 tokenId,
804         bytes calldata data
805     ) external;
806 }
807 
808 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
809 
810 
811 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
812 
813 pragma solidity ^0.8.0;
814 
815 
816 /**
817  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
818  * @dev See https://eips.ethereum.org/EIPS/eip-721
819  */
820 interface IERC721Metadata is IERC721 {
821     /**
822      * @dev Returns the token collection name.
823      */
824     function name() external view returns (string memory);
825 
826     /**
827      * @dev Returns the token collection symbol.
828      */
829     function symbol() external view returns (string memory);
830 
831     /**
832      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
833      */
834     function tokenURI(uint256 tokenId) external view returns (string memory);
835 }
836 
837 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
838 
839 
840 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
841 
842 pragma solidity ^0.8.0;
843 
844 
845 
846 
847 
848 
849 
850 
851 /**
852  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
853  * the Metadata extension, but not including the Enumerable extension, which is available separately as
854  * {ERC721Enumerable}.
855  */
856 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
857     using Address for address;
858     using Strings for uint256;
859 
860     // Token name
861     string private _name;
862 
863     // Token symbol
864     string private _symbol;
865 
866     // Mapping from token ID to owner address
867     mapping(uint256 => address) private _owners;
868 
869     // Mapping owner address to token count
870     mapping(address => uint256) private _balances;
871 
872     // Mapping from token ID to approved address
873     mapping(uint256 => address) private _tokenApprovals;
874 
875     // Mapping from owner to operator approvals
876     mapping(address => mapping(address => bool)) private _operatorApprovals;
877 
878     /**
879      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
880      */
881     constructor(string memory name_, string memory symbol_) {
882         _name = name_;
883         _symbol = symbol_;
884     }
885 
886     /**
887      * @dev See {IERC165-supportsInterface}.
888      */
889     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
890         return
891             interfaceId == type(IERC721).interfaceId ||
892             interfaceId == type(IERC721Metadata).interfaceId ||
893             super.supportsInterface(interfaceId);
894     }
895 
896     /**
897      * @dev See {IERC721-balanceOf}.
898      */
899     function balanceOf(address owner) public view virtual override returns (uint256) {
900         require(owner != address(0), "ERC721: balance query for the zero address");
901         return _balances[owner];
902     }
903 
904     /**
905      * @dev See {IERC721-ownerOf}.
906      */
907     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
908         address owner = _owners[tokenId];
909         require(owner != address(0), "ERC721: owner query for nonexistent token");
910         return owner;
911     }
912 
913     /**
914      * @dev See {IERC721Metadata-name}.
915      */
916     function name() public view virtual override returns (string memory) {
917         return _name;
918     }
919 
920     /**
921      * @dev See {IERC721Metadata-symbol}.
922      */
923     function symbol() public view virtual override returns (string memory) {
924         return _symbol;
925     }
926 
927     /**
928      * @dev See {IERC721Metadata-tokenURI}.
929      */
930     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
931         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
932 
933         string memory baseURI = _baseURI();
934         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
935     }
936 
937     /**
938      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
939      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
940      * by default, can be overriden in child contracts.
941      */
942     function _baseURI() internal view virtual returns (string memory) {
943         return "";
944     }
945 
946     /**
947      * @dev See {IERC721-approve}.
948      */
949     function approve(address to, uint256 tokenId) public virtual override {
950         address owner = ERC721.ownerOf(tokenId);
951         require(to != owner, "ERC721: approval to current owner");
952 
953         require(
954             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
955             "ERC721: approve caller is not owner nor approved for all"
956         );
957 
958         _approve(to, tokenId);
959     }
960 
961     /**
962      * @dev See {IERC721-getApproved}.
963      */
964     function getApproved(uint256 tokenId) public view virtual override returns (address) {
965         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
966 
967         return _tokenApprovals[tokenId];
968     }
969 
970     /**
971      * @dev See {IERC721-setApprovalForAll}.
972      */
973     function setApprovalForAll(address operator, bool approved) public virtual override {
974         _setApprovalForAll(_msgSender(), operator, approved);
975     }
976 
977     /**
978      * @dev See {IERC721-isApprovedForAll}.
979      */
980     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
981         return _operatorApprovals[owner][operator];
982     }
983 
984     /**
985      * @dev See {IERC721-transferFrom}.
986      */
987     function transferFrom(
988         address from,
989         address to,
990         uint256 tokenId
991     ) public virtual override {
992         //solhint-disable-next-line max-line-length
993         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
994 
995         _transfer(from, to, tokenId);
996     }
997 
998     /**
999      * @dev See {IERC721-safeTransferFrom}.
1000      */
1001     function safeTransferFrom(
1002         address from,
1003         address to,
1004         uint256 tokenId
1005     ) public virtual override {
1006         safeTransferFrom(from, to, tokenId, "");
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-safeTransferFrom}.
1011      */
1012     function safeTransferFrom(
1013         address from,
1014         address to,
1015         uint256 tokenId,
1016         bytes memory _data
1017     ) public virtual override {
1018         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1019         _safeTransfer(from, to, tokenId, _data);
1020     }
1021 
1022     /**
1023      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1024      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1025      *
1026      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1027      *
1028      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1029      * implement alternative mechanisms to perform token transfer, such as signature-based.
1030      *
1031      * Requirements:
1032      *
1033      * - `from` cannot be the zero address.
1034      * - `to` cannot be the zero address.
1035      * - `tokenId` token must exist and be owned by `from`.
1036      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1037      *
1038      * Emits a {Transfer} event.
1039      */
1040     function _safeTransfer(
1041         address from,
1042         address to,
1043         uint256 tokenId,
1044         bytes memory _data
1045     ) internal virtual {
1046         _transfer(from, to, tokenId);
1047         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1048     }
1049 
1050     /**
1051      * @dev Returns whether `tokenId` exists.
1052      *
1053      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1054      *
1055      * Tokens start existing when they are minted (`_mint`),
1056      * and stop existing when they are burned (`_burn`).
1057      */
1058     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1059         return _owners[tokenId] != address(0);
1060     }
1061 
1062     /**
1063      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1064      *
1065      * Requirements:
1066      *
1067      * - `tokenId` must exist.
1068      */
1069     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1070         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1071         address owner = ERC721.ownerOf(tokenId);
1072         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1073     }
1074 
1075     /**
1076      * @dev Safely mints `tokenId` and transfers it to `to`.
1077      *
1078      * Requirements:
1079      *
1080      * - `tokenId` must not exist.
1081      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1082      *
1083      * Emits a {Transfer} event.
1084      */
1085     function _safeMint(address to, uint256 tokenId) internal virtual {
1086         _safeMint(to, tokenId, "");
1087     }
1088 
1089     /**
1090      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1091      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1092      */
1093     function _safeMint(
1094         address to,
1095         uint256 tokenId,
1096         bytes memory _data
1097     ) internal virtual {
1098         _mint(to, tokenId);
1099         require(
1100             _checkOnERC721Received(address(0), to, tokenId, _data),
1101             "ERC721: transfer to non ERC721Receiver implementer"
1102         );
1103     }
1104 
1105     /**
1106      * @dev Mints `tokenId` and transfers it to `to`.
1107      *
1108      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1109      *
1110      * Requirements:
1111      *
1112      * - `tokenId` must not exist.
1113      * - `to` cannot be the zero address.
1114      *
1115      * Emits a {Transfer} event.
1116      */
1117     function _mint(address to, uint256 tokenId) internal virtual {
1118         require(to != address(0), "ERC721: mint to the zero address");
1119         require(!_exists(tokenId), "ERC721: token already minted");
1120 
1121         _beforeTokenTransfer(address(0), to, tokenId);
1122 
1123         _balances[to] += 1;
1124         _owners[tokenId] = to;
1125 
1126         emit Transfer(address(0), to, tokenId);
1127     }
1128 
1129     /**
1130      * @dev Destroys `tokenId`.
1131      * The approval is cleared when the token is burned.
1132      *
1133      * Requirements:
1134      *
1135      * - `tokenId` must exist.
1136      *
1137      * Emits a {Transfer} event.
1138      */
1139     function _burn(uint256 tokenId) internal virtual {
1140         address owner = ERC721.ownerOf(tokenId);
1141 
1142         _beforeTokenTransfer(owner, address(0), tokenId);
1143 
1144         // Clear approvals
1145         _approve(address(0), tokenId);
1146 
1147         _balances[owner] -= 1;
1148         delete _owners[tokenId];
1149 
1150         emit Transfer(owner, address(0), tokenId);
1151     }
1152 
1153     /**
1154      * @dev Transfers `tokenId` from `from` to `to`.
1155      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1156      *
1157      * Requirements:
1158      *
1159      * - `to` cannot be the zero address.
1160      * - `tokenId` token must be owned by `from`.
1161      *
1162      * Emits a {Transfer} event.
1163      */
1164     function _transfer(
1165         address from,
1166         address to,
1167         uint256 tokenId
1168     ) internal virtual {
1169         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1170         require(to != address(0), "ERC721: transfer to the zero address");
1171 
1172         _beforeTokenTransfer(from, to, tokenId);
1173 
1174         // Clear approvals from the previous owner
1175         _approve(address(0), tokenId);
1176 
1177         _balances[from] -= 1;
1178         _balances[to] += 1;
1179         _owners[tokenId] = to;
1180 
1181         emit Transfer(from, to, tokenId);
1182     }
1183 
1184     /**
1185      * @dev Approve `to` to operate on `tokenId`
1186      *
1187      * Emits a {Approval} event.
1188      */
1189     function _approve(address to, uint256 tokenId) internal virtual {
1190         _tokenApprovals[tokenId] = to;
1191         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1192     }
1193 
1194     /**
1195      * @dev Approve `operator` to operate on all of `owner` tokens
1196      *
1197      * Emits a {ApprovalForAll} event.
1198      */
1199     function _setApprovalForAll(
1200         address owner,
1201         address operator,
1202         bool approved
1203     ) internal virtual {
1204         require(owner != operator, "ERC721: approve to caller");
1205         _operatorApprovals[owner][operator] = approved;
1206         emit ApprovalForAll(owner, operator, approved);
1207     }
1208 
1209     /**
1210      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1211      * The call is not executed if the target address is not a contract.
1212      *
1213      * @param from address representing the previous owner of the given token ID
1214      * @param to target address that will receive the tokens
1215      * @param tokenId uint256 ID of the token to be transferred
1216      * @param _data bytes optional data to send along with the call
1217      * @return bool whether the call correctly returned the expected magic value
1218      */
1219     function _checkOnERC721Received(
1220         address from,
1221         address to,
1222         uint256 tokenId,
1223         bytes memory _data
1224     ) private returns (bool) {
1225         if (to.isContract()) {
1226             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1227                 return retval == IERC721Receiver.onERC721Received.selector;
1228             } catch (bytes memory reason) {
1229                 if (reason.length == 0) {
1230                     revert("ERC721: transfer to non ERC721Receiver implementer");
1231                 } else {
1232                     assembly {
1233                         revert(add(32, reason), mload(reason))
1234                     }
1235                 }
1236             }
1237         } else {
1238             return true;
1239         }
1240     }
1241 
1242     /**
1243      * @dev Hook that is called before any token transfer. This includes minting
1244      * and burning.
1245      *
1246      * Calling conditions:
1247      *
1248      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1249      * transferred to `to`.
1250      * - When `from` is zero, `tokenId` will be minted for `to`.
1251      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1252      * - `from` and `to` are never both zero.
1253      *
1254      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1255      */
1256     function _beforeTokenTransfer(
1257         address from,
1258         address to,
1259         uint256 tokenId
1260     ) internal virtual {}
1261 }
1262 
1263 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1264 
1265 
1266 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Burnable.sol)
1267 
1268 pragma solidity ^0.8.0;
1269 
1270 
1271 
1272 /**
1273  * @title ERC721 Burnable Token
1274  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1275  */
1276 abstract contract ERC721Burnable is Context, ERC721 {
1277     /**
1278      * @dev Burns `tokenId`. See {ERC721-_burn}.
1279      *
1280      * Requirements:
1281      *
1282      * - The caller must own `tokenId` or be an approved operator.
1283      */
1284     function burn(uint256 tokenId) public virtual {
1285         //solhint-disable-next-line max-line-length
1286         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1287         _burn(tokenId);
1288     }
1289 }
1290 
1291 // File: verified-sources/0x1fF7307ED4dF5b3694Fddb6B3bABb3A0CC65650e/sources/github/WarAgainstRugs/WrappedFrosties/contracts/WrappedFrostiesNFT.sol
1292 
1293 
1294 pragma solidity ^0.8.9;
1295 
1296 
1297 
1298 
1299 
1300 
1301 
1302 
1303 contract WrappedFrostiesNFT is
1304   ERC721,
1305   IERC721Receiver,
1306   Pausable,
1307   Ownable,
1308   ERC721Burnable
1309 {
1310   event Wrapped(uint256 indexed tokenId);
1311   event Unwrapped(uint256 indexed tokenId);
1312 
1313   IERC721 immutable frostiesNFT;
1314 
1315   constructor(address frostiesNFTContractAddress_)
1316     ERC721("Official Wrapped Frosties", "WFROST")
1317   {
1318     frostiesNFT = IERC721(frostiesNFTContractAddress_);
1319   }
1320 
1321   function _baseURI() internal pure override returns (string memory) {
1322     return "ipfs://QmYSKvwngQxaSAKniUvQ8koQAaCaa5Pimsar38bPYP5aSv/";
1323   }
1324 
1325   function tokenURI(uint256 tokenId)
1326     public
1327     view
1328     override
1329     returns (string memory)
1330   {
1331     return string(abi.encodePacked(super.tokenURI(tokenId), ".json"));
1332   }
1333 
1334   function pause() public onlyOwner {
1335     _pause();
1336   }
1337 
1338   function unpause() public onlyOwner {
1339     _unpause();
1340   }
1341 
1342   /// Wrap Frosties NFT(s) to get Wrapped Frosty(s)
1343   function wrap(uint256[] calldata tokenIds_) external {
1344     for (uint256 i = 0; i < tokenIds_.length; i++) {
1345       frostiesNFT.safeTransferFrom(msg.sender, address(this), tokenIds_[i]);
1346     }
1347   }
1348 
1349   /// Unwrap to get Frosties NFT(s) back
1350   function unwrap(uint256[] calldata tokenIds_) external {
1351     for (uint256 i = 0; i < tokenIds_.length; i++) {
1352       _safeTransfer(msg.sender, address(this), tokenIds_[i], "");
1353     }
1354   }
1355 
1356   function _flip(
1357     address who_,
1358     bool isWrapping_,
1359     uint256 tokenId_
1360   ) private {
1361     if (isWrapping_) {
1362       // Mint Wrapped Frosty of same tokenID if not yet minted, otherwise swap for existing Wrapped Frostie
1363       if (_exists(tokenId_) && ownerOf(tokenId_) == address(this)) {
1364         _safeTransfer(address(this), who_, tokenId_, "");
1365       } else {
1366         _safeMint(who_, tokenId_);
1367       }
1368       emit Wrapped(tokenId_);
1369     } else {
1370       frostiesNFT.safeTransferFrom(address(this), who_, tokenId_);
1371       emit Unwrapped(tokenId_);
1372     }
1373   }
1374 
1375   // Notice: You must use safeTransferFrom in order to properly wrap/unwrap your frosty.
1376   function onERC721Received(
1377     address operator_,
1378     address from_,
1379     uint256 tokenId_,
1380     bytes memory data_
1381   ) external override returns (bytes4) {
1382     // Only supports callback from the original FrostyNFTs contract and this contract
1383     require(
1384       msg.sender == address(frostiesNFT) || msg.sender == address(this),
1385       "must be FrostyNFT or WrappedFrosty"
1386     );
1387 
1388     bool isWrapping = msg.sender == address(frostiesNFT);
1389     _flip(from_, isWrapping, tokenId_);
1390 
1391     return this.onERC721Received.selector;
1392   }
1393 
1394   function _beforeTokenTransfer(
1395     address from,
1396     address to,
1397     uint256 tokenId
1398   ) internal override whenNotPaused {
1399     super._beforeTokenTransfer(from, to, tokenId);
1400   }
1401 
1402   fallback() external payable {}
1403 
1404   receive() external payable {}
1405 
1406   function withdrawETH() external onlyOwner {
1407     (bool success, ) = owner().call{value: address(this).balance}("");
1408     require(success, "Transfer failed.");
1409   }
1410 
1411   function withdrawERC20(address token) external onlyOwner {
1412     bool success = IERC20(token).transfer(
1413       owner(),
1414       IERC20(token).balanceOf(address(this))
1415     );
1416     require(success, "Transfer failed");
1417   }
1418 
1419   // @notice Mints or transfers wrapped frosty nft to owner for users who incorrectly transfer a Frostie Frosty or Wrapped Frosty directly to the contract without using safeTransferFrom.
1420   // @dev This condition will occur if onERC721Received isn't called when transferring.
1421   function emergencyMintWrapped(uint256 tokenId_) external onlyOwner {
1422     if (frostiesNFT.ownerOf(tokenId_) == address(this)) {
1423       // Contract owns the Frostie Frosty.
1424       if (_exists(tokenId_) && ownerOf(tokenId_) == address(this)) {
1425         // Wrapped Frosty is also trapped in contract.
1426         _safeTransfer(address(this), owner(), tokenId_, "");
1427         emit Wrapped(tokenId_);
1428       } else if (!_exists(tokenId_)) {
1429         // Wrapped Frosty hasn't ever been minted.
1430         _safeMint(owner(), tokenId_);
1431         emit Wrapped(tokenId_);
1432       } else {
1433         revert("Wrapped Frosty minted and distributed already");
1434       }
1435     } else {
1436       revert("Frostie Frosty is not locked in contract");
1437     }
1438   }
1439 }