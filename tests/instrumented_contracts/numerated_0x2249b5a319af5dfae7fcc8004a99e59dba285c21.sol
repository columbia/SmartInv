1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Emitted when `value` tokens are moved from one account (`from`) to
14      * another (`to`).
15      *
16      * Note that `value` may be zero.
17      */
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     /**
21      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
22      * a call to {approve}. `value` is the new allowance.
23      */
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 
26     /**
27      * @dev Returns the amount of tokens in existence.
28      */
29     function totalSupply() external view returns (uint256);
30 
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `to`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address to, uint256 amount) external returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender) external view returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `from` to `to` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(
80         address from,
81         address to,
82         uint256 amount
83     ) external returns (bool);
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
183 // File: @openzeppelin/contracts/security/Pausable.sol
184 
185 
186 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
187 
188 pragma solidity ^0.8.0;
189 
190 
191 /**
192  * @dev Contract module which allows children to implement an emergency stop
193  * mechanism that can be triggered by an authorized account.
194  *
195  * This module is used through inheritance. It will make available the
196  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
197  * the functions of your contract. Note that they will not be pausable by
198  * simply including this module, only once the modifiers are put in place.
199  */
200 abstract contract Pausable is Context {
201     /**
202      * @dev Emitted when the pause is triggered by `account`.
203      */
204     event Paused(address account);
205 
206     /**
207      * @dev Emitted when the pause is lifted by `account`.
208      */
209     event Unpaused(address account);
210 
211     bool private _paused;
212 
213     /**
214      * @dev Initializes the contract in unpaused state.
215      */
216     constructor() {
217         _paused = false;
218     }
219 
220     /**
221      * @dev Returns true if the contract is paused, and false otherwise.
222      */
223     function paused() public view virtual returns (bool) {
224         return _paused;
225     }
226 
227     /**
228      * @dev Modifier to make a function callable only when the contract is not paused.
229      *
230      * Requirements:
231      *
232      * - The contract must not be paused.
233      */
234     modifier whenNotPaused() {
235         require(!paused(), "Pausable: paused");
236         _;
237     }
238 
239     /**
240      * @dev Modifier to make a function callable only when the contract is paused.
241      *
242      * Requirements:
243      *
244      * - The contract must be paused.
245      */
246     modifier whenPaused() {
247         require(paused(), "Pausable: not paused");
248         _;
249     }
250 
251     /**
252      * @dev Triggers stopped state.
253      *
254      * Requirements:
255      *
256      * - The contract must not be paused.
257      */
258     function _pause() internal virtual whenNotPaused {
259         _paused = true;
260         emit Paused(_msgSender());
261     }
262 
263     /**
264      * @dev Returns to normal state.
265      *
266      * Requirements:
267      *
268      * - The contract must be paused.
269      */
270     function _unpause() internal virtual whenPaused {
271         _paused = false;
272         emit Unpaused(_msgSender());
273     }
274 }
275 
276 // File: @openzeppelin/contracts/access/Ownable.sol
277 
278 
279 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
280 
281 pragma solidity ^0.8.0;
282 
283 
284 /**
285  * @dev Contract module which provides a basic access control mechanism, where
286  * there is an account (an owner) that can be granted exclusive access to
287  * specific functions.
288  *
289  * By default, the owner account will be the one that deploys the contract. This
290  * can later be changed with {transferOwnership}.
291  *
292  * This module is used through inheritance. It will make available the modifier
293  * `onlyOwner`, which can be applied to your functions to restrict their use to
294  * the owner.
295  */
296 abstract contract Ownable is Context {
297     address private _owner;
298 
299     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
300 
301     /**
302      * @dev Initializes the contract setting the deployer as the initial owner.
303      */
304     constructor() {
305         _transferOwnership(_msgSender());
306     }
307 
308     /**
309      * @dev Returns the address of the current owner.
310      */
311     function owner() public view virtual returns (address) {
312         return _owner;
313     }
314 
315     /**
316      * @dev Throws if called by any account other than the owner.
317      */
318     modifier onlyOwner() {
319         require(owner() == _msgSender(), "Ownable: caller is not the owner");
320         _;
321     }
322 
323     /**
324      * @dev Leaves the contract without owner. It will not be possible to call
325      * `onlyOwner` functions anymore. Can only be called by the current owner.
326      *
327      * NOTE: Renouncing ownership will leave the contract without an owner,
328      * thereby removing any functionality that is only available to the owner.
329      */
330     function renounceOwnership() public virtual onlyOwner {
331         _transferOwnership(address(0));
332     }
333 
334     /**
335      * @dev Transfers ownership of the contract to a new account (`newOwner`).
336      * Can only be called by the current owner.
337      */
338     function transferOwnership(address newOwner) public virtual onlyOwner {
339         require(newOwner != address(0), "Ownable: new owner is the zero address");
340         _transferOwnership(newOwner);
341     }
342 
343     /**
344      * @dev Transfers ownership of the contract to a new account (`newOwner`).
345      * Internal function without access restriction.
346      */
347     function _transferOwnership(address newOwner) internal virtual {
348         address oldOwner = _owner;
349         _owner = newOwner;
350         emit OwnershipTransferred(oldOwner, newOwner);
351     }
352 }
353 
354 // File: @openzeppelin/contracts/utils/Address.sol
355 
356 
357 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
358 
359 pragma solidity ^0.8.1;
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
381      *
382      * [IMPORTANT]
383      * ====
384      * You shouldn't rely on `isContract` to protect against flash loan attacks!
385      *
386      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
387      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
388      * constructor.
389      * ====
390      */
391     function isContract(address account) internal view returns (bool) {
392         // This method relies on extcodesize/address.code.length, which returns 0
393         // for contracts in construction, since the code is only stored at the end
394         // of the constructor execution.
395 
396         return account.code.length > 0;
397     }
398 
399     /**
400      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
401      * `recipient`, forwarding all available gas and reverting on errors.
402      *
403      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
404      * of certain opcodes, possibly making contracts go over the 2300 gas limit
405      * imposed by `transfer`, making them unable to receive funds via
406      * `transfer`. {sendValue} removes this limitation.
407      *
408      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
409      *
410      * IMPORTANT: because control is transferred to `recipient`, care must be
411      * taken to not create reentrancy vulnerabilities. Consider using
412      * {ReentrancyGuard} or the
413      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
414      */
415     function sendValue(address payable recipient, uint256 amount) internal {
416         require(address(this).balance >= amount, "Address: insufficient balance");
417 
418         (bool success, ) = recipient.call{value: amount}("");
419         require(success, "Address: unable to send value, recipient may have reverted");
420     }
421 
422     /**
423      * @dev Performs a Solidity function call using a low level `call`. A
424      * plain `call` is an unsafe replacement for a function call: use this
425      * function instead.
426      *
427      * If `target` reverts with a revert reason, it is bubbled up by this
428      * function (like regular Solidity function calls).
429      *
430      * Returns the raw returned data. To convert to the expected return value,
431      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
432      *
433      * Requirements:
434      *
435      * - `target` must be a contract.
436      * - calling `target` with `data` must not revert.
437      *
438      * _Available since v3.1._
439      */
440     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
441         return functionCall(target, data, "Address: low-level call failed");
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
446      * `errorMessage` as a fallback revert reason when `target` reverts.
447      *
448      * _Available since v3.1._
449      */
450     function functionCall(
451         address target,
452         bytes memory data,
453         string memory errorMessage
454     ) internal returns (bytes memory) {
455         return functionCallWithValue(target, data, 0, errorMessage);
456     }
457 
458     /**
459      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
460      * but also transferring `value` wei to `target`.
461      *
462      * Requirements:
463      *
464      * - the calling contract must have an ETH balance of at least `value`.
465      * - the called Solidity function must be `payable`.
466      *
467      * _Available since v3.1._
468      */
469     function functionCallWithValue(
470         address target,
471         bytes memory data,
472         uint256 value
473     ) internal returns (bytes memory) {
474         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
475     }
476 
477     /**
478      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
479      * with `errorMessage` as a fallback revert reason when `target` reverts.
480      *
481      * _Available since v3.1._
482      */
483     function functionCallWithValue(
484         address target,
485         bytes memory data,
486         uint256 value,
487         string memory errorMessage
488     ) internal returns (bytes memory) {
489         require(address(this).balance >= value, "Address: insufficient balance for call");
490         require(isContract(target), "Address: call to non-contract");
491 
492         (bool success, bytes memory returndata) = target.call{value: value}(data);
493         return verifyCallResult(success, returndata, errorMessage);
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
498      * but performing a static call.
499      *
500      * _Available since v3.3._
501      */
502     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
503         return functionStaticCall(target, data, "Address: low-level static call failed");
504     }
505 
506     /**
507      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
508      * but performing a static call.
509      *
510      * _Available since v3.3._
511      */
512     function functionStaticCall(
513         address target,
514         bytes memory data,
515         string memory errorMessage
516     ) internal view returns (bytes memory) {
517         require(isContract(target), "Address: static call to non-contract");
518 
519         (bool success, bytes memory returndata) = target.staticcall(data);
520         return verifyCallResult(success, returndata, errorMessage);
521     }
522 
523     /**
524      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
525      * but performing a delegate call.
526      *
527      * _Available since v3.4._
528      */
529     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
530         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
531     }
532 
533     /**
534      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
535      * but performing a delegate call.
536      *
537      * _Available since v3.4._
538      */
539     function functionDelegateCall(
540         address target,
541         bytes memory data,
542         string memory errorMessage
543     ) internal returns (bytes memory) {
544         require(isContract(target), "Address: delegate call to non-contract");
545 
546         (bool success, bytes memory returndata) = target.delegatecall(data);
547         return verifyCallResult(success, returndata, errorMessage);
548     }
549 
550     /**
551      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
552      * revert reason using the provided one.
553      *
554      * _Available since v4.3._
555      */
556     function verifyCallResult(
557         bool success,
558         bytes memory returndata,
559         string memory errorMessage
560     ) internal pure returns (bytes memory) {
561         if (success) {
562             return returndata;
563         } else {
564             // Look for revert reason and bubble it up if present
565             if (returndata.length > 0) {
566                 // The easiest way to bubble the revert reason is using memory via assembly
567 
568                 assembly {
569                     let returndata_size := mload(returndata)
570                     revert(add(32, returndata), returndata_size)
571                 }
572             } else {
573                 revert(errorMessage);
574             }
575         }
576     }
577 }
578 
579 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
580 
581 
582 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
583 
584 pragma solidity ^0.8.0;
585 
586 /**
587  * @title ERC721 token receiver interface
588  * @dev Interface for any contract that wants to support safeTransfers
589  * from ERC721 asset contracts.
590  */
591 interface IERC721Receiver {
592     /**
593      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
594      * by `operator` from `from`, this function is called.
595      *
596      * It must return its Solidity selector to confirm the token transfer.
597      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
598      *
599      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
600      */
601     function onERC721Received(
602         address operator,
603         address from,
604         uint256 tokenId,
605         bytes calldata data
606     ) external returns (bytes4);
607 }
608 
609 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
610 
611 
612 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
613 
614 pragma solidity ^0.8.0;
615 
616 /**
617  * @dev Interface of the ERC165 standard, as defined in the
618  * https://eips.ethereum.org/EIPS/eip-165[EIP].
619  *
620  * Implementers can declare support of contract interfaces, which can then be
621  * queried by others ({ERC165Checker}).
622  *
623  * For an implementation, see {ERC165}.
624  */
625 interface IERC165 {
626     /**
627      * @dev Returns true if this contract implements the interface defined by
628      * `interfaceId`. See the corresponding
629      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
630      * to learn more about how these ids are created.
631      *
632      * This function call must use less than 30 000 gas.
633      */
634     function supportsInterface(bytes4 interfaceId) external view returns (bool);
635 }
636 
637 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
638 
639 
640 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
641 
642 pragma solidity ^0.8.0;
643 
644 
645 /**
646  * @dev Interface for the NFT Royalty Standard.
647  *
648  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
649  * support for royalty payments across all NFT marketplaces and ecosystem participants.
650  *
651  * _Available since v4.5._
652  */
653 interface IERC2981 is IERC165 {
654     /**
655      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
656      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
657      */
658     function royaltyInfo(uint256 tokenId, uint256 salePrice)
659         external
660         view
661         returns (address receiver, uint256 royaltyAmount);
662 }
663 
664 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
665 
666 
667 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
668 
669 pragma solidity ^0.8.0;
670 
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
695 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
696 
697 
698 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
699 
700 pragma solidity ^0.8.0;
701 
702 
703 /**
704  * @dev Required interface of an ERC721 compliant contract.
705  */
706 interface IERC721 is IERC165 {
707     /**
708      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
709      */
710     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
711 
712     /**
713      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
714      */
715     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
716 
717     /**
718      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
719      */
720     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
721 
722     /**
723      * @dev Returns the number of tokens in ``owner``'s account.
724      */
725     function balanceOf(address owner) external view returns (uint256 balance);
726 
727     /**
728      * @dev Returns the owner of the `tokenId` token.
729      *
730      * Requirements:
731      *
732      * - `tokenId` must exist.
733      */
734     function ownerOf(uint256 tokenId) external view returns (address owner);
735 
736     /**
737      * @dev Safely transfers `tokenId` token from `from` to `to`.
738      *
739      * Requirements:
740      *
741      * - `from` cannot be the zero address.
742      * - `to` cannot be the zero address.
743      * - `tokenId` token must exist and be owned by `from`.
744      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
745      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
746      *
747      * Emits a {Transfer} event.
748      */
749     function safeTransferFrom(
750         address from,
751         address to,
752         uint256 tokenId,
753         bytes calldata data
754     ) external;
755 
756     /**
757      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
758      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
759      *
760      * Requirements:
761      *
762      * - `from` cannot be the zero address.
763      * - `to` cannot be the zero address.
764      * - `tokenId` token must exist and be owned by `from`.
765      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
766      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
767      *
768      * Emits a {Transfer} event.
769      */
770     function safeTransferFrom(
771         address from,
772         address to,
773         uint256 tokenId
774     ) external;
775 
776     /**
777      * @dev Transfers `tokenId` token from `from` to `to`.
778      *
779      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
780      *
781      * Requirements:
782      *
783      * - `from` cannot be the zero address.
784      * - `to` cannot be the zero address.
785      * - `tokenId` token must be owned by `from`.
786      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
787      *
788      * Emits a {Transfer} event.
789      */
790     function transferFrom(
791         address from,
792         address to,
793         uint256 tokenId
794     ) external;
795 
796     /**
797      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
798      * The approval is cleared when the token is transferred.
799      *
800      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
801      *
802      * Requirements:
803      *
804      * - The caller must own the token or be an approved operator.
805      * - `tokenId` must exist.
806      *
807      * Emits an {Approval} event.
808      */
809     function approve(address to, uint256 tokenId) external;
810 
811     /**
812      * @dev Approve or remove `operator` as an operator for the caller.
813      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
814      *
815      * Requirements:
816      *
817      * - The `operator` cannot be the caller.
818      *
819      * Emits an {ApprovalForAll} event.
820      */
821     function setApprovalForAll(address operator, bool _approved) external;
822 
823     /**
824      * @dev Returns the account approved for `tokenId` token.
825      *
826      * Requirements:
827      *
828      * - `tokenId` must exist.
829      */
830     function getApproved(uint256 tokenId) external view returns (address operator);
831 
832     /**
833      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
834      *
835      * See {setApprovalForAll}
836      */
837     function isApprovedForAll(address owner, address operator) external view returns (bool);
838 }
839 
840 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
841 
842 
843 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
844 
845 pragma solidity ^0.8.0;
846 
847 
848 /**
849  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
850  * @dev See https://eips.ethereum.org/EIPS/eip-721
851  */
852 interface IERC721Metadata is IERC721 {
853     /**
854      * @dev Returns the token collection name.
855      */
856     function name() external view returns (string memory);
857 
858     /**
859      * @dev Returns the token collection symbol.
860      */
861     function symbol() external view returns (string memory);
862 
863     /**
864      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
865      */
866     function tokenURI(uint256 tokenId) external view returns (string memory);
867 }
868 
869 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
870 
871 
872 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
873 
874 pragma solidity ^0.8.0;
875 
876 
877 
878 
879 
880 
881 
882 
883 /**
884  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
885  * the Metadata extension, but not including the Enumerable extension, which is available separately as
886  * {ERC721Enumerable}.
887  */
888 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
889     using Address for address;
890     using Strings for uint256;
891 
892     // Token name
893     string private _name;
894 
895     // Token symbol
896     string private _symbol;
897 
898     // Mapping from token ID to owner address
899     mapping(uint256 => address) private _owners;
900 
901     // Mapping owner address to token count
902     mapping(address => uint256) private _balances;
903 
904     // Mapping from token ID to approved address
905     mapping(uint256 => address) private _tokenApprovals;
906 
907     // Mapping from owner to operator approvals
908     mapping(address => mapping(address => bool)) private _operatorApprovals;
909 
910     /**
911      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
912      */
913     constructor(string memory name_, string memory symbol_) {
914         _name = name_;
915         _symbol = symbol_;
916     }
917 
918     /**
919      * @dev See {IERC165-supportsInterface}.
920      */
921     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
922         return
923             interfaceId == type(IERC721).interfaceId ||
924             interfaceId == type(IERC721Metadata).interfaceId ||
925             super.supportsInterface(interfaceId);
926     }
927 
928     /**
929      * @dev See {IERC721-balanceOf}.
930      */
931     function balanceOf(address owner) public view virtual override returns (uint256) {
932         require(owner != address(0), "ERC721: balance query for the zero address");
933         return _balances[owner];
934     }
935 
936     /**
937      * @dev See {IERC721-ownerOf}.
938      */
939     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
940         address owner = _owners[tokenId];
941         require(owner != address(0), "ERC721: owner query for nonexistent token");
942         return owner;
943     }
944 
945     /**
946      * @dev See {IERC721Metadata-name}.
947      */
948     function name() public view virtual override returns (string memory) {
949         return _name;
950     }
951 
952     /**
953      * @dev See {IERC721Metadata-symbol}.
954      */
955     function symbol() public view virtual override returns (string memory) {
956         return _symbol;
957     }
958 
959     /**
960      * @dev See {IERC721Metadata-tokenURI}.
961      */
962     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
963         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
964 
965         string memory baseURI = _baseURI();
966         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
967     }
968 
969     /**
970      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
971      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
972      * by default, can be overridden in child contracts.
973      */
974     function _baseURI() internal view virtual returns (string memory) {
975         return "";
976     }
977 
978     /**
979      * @dev See {IERC721-approve}.
980      */
981     function approve(address to, uint256 tokenId) public virtual override {
982         address owner = ERC721.ownerOf(tokenId);
983         require(to != owner, "ERC721: approval to current owner");
984 
985         require(
986             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
987             "ERC721: approve caller is not owner nor approved for all"
988         );
989 
990         _approve(to, tokenId);
991     }
992 
993     /**
994      * @dev See {IERC721-getApproved}.
995      */
996     function getApproved(uint256 tokenId) public view virtual override returns (address) {
997         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
998 
999         return _tokenApprovals[tokenId];
1000     }
1001 
1002     /**
1003      * @dev See {IERC721-setApprovalForAll}.
1004      */
1005     function setApprovalForAll(address operator, bool approved) public virtual override {
1006         _setApprovalForAll(_msgSender(), operator, approved);
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-isApprovedForAll}.
1011      */
1012     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1013         return _operatorApprovals[owner][operator];
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-transferFrom}.
1018      */
1019     function transferFrom(
1020         address from,
1021         address to,
1022         uint256 tokenId
1023     ) public virtual override {
1024         //solhint-disable-next-line max-line-length
1025         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1026 
1027         _transfer(from, to, tokenId);
1028     }
1029 
1030     /**
1031      * @dev See {IERC721-safeTransferFrom}.
1032      */
1033     function safeTransferFrom(
1034         address from,
1035         address to,
1036         uint256 tokenId
1037     ) public virtual override {
1038         safeTransferFrom(from, to, tokenId, "");
1039     }
1040 
1041     /**
1042      * @dev See {IERC721-safeTransferFrom}.
1043      */
1044     function safeTransferFrom(
1045         address from,
1046         address to,
1047         uint256 tokenId,
1048         bytes memory _data
1049     ) public virtual override {
1050         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1051         _safeTransfer(from, to, tokenId, _data);
1052     }
1053 
1054     /**
1055      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1056      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1057      *
1058      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1059      *
1060      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1061      * implement alternative mechanisms to perform token transfer, such as signature-based.
1062      *
1063      * Requirements:
1064      *
1065      * - `from` cannot be the zero address.
1066      * - `to` cannot be the zero address.
1067      * - `tokenId` token must exist and be owned by `from`.
1068      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1069      *
1070      * Emits a {Transfer} event.
1071      */
1072     function _safeTransfer(
1073         address from,
1074         address to,
1075         uint256 tokenId,
1076         bytes memory _data
1077     ) internal virtual {
1078         _transfer(from, to, tokenId);
1079         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1080     }
1081 
1082     /**
1083      * @dev Returns whether `tokenId` exists.
1084      *
1085      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1086      *
1087      * Tokens start existing when they are minted (`_mint`),
1088      * and stop existing when they are burned (`_burn`).
1089      */
1090     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1091         return _owners[tokenId] != address(0);
1092     }
1093 
1094     /**
1095      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1096      *
1097      * Requirements:
1098      *
1099      * - `tokenId` must exist.
1100      */
1101     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1102         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1103         address owner = ERC721.ownerOf(tokenId);
1104         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1105     }
1106 
1107     /**
1108      * @dev Safely mints `tokenId` and transfers it to `to`.
1109      *
1110      * Requirements:
1111      *
1112      * - `tokenId` must not exist.
1113      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1114      *
1115      * Emits a {Transfer} event.
1116      */
1117     function _safeMint(address to, uint256 tokenId) internal virtual {
1118         _safeMint(to, tokenId, "");
1119     }
1120 
1121     /**
1122      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1123      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1124      */
1125     function _safeMint(
1126         address to,
1127         uint256 tokenId,
1128         bytes memory _data
1129     ) internal virtual {
1130         _mint(to, tokenId);
1131         require(
1132             _checkOnERC721Received(address(0), to, tokenId, _data),
1133             "ERC721: transfer to non ERC721Receiver implementer"
1134         );
1135     }
1136 
1137     /**
1138      * @dev Mints `tokenId` and transfers it to `to`.
1139      *
1140      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1141      *
1142      * Requirements:
1143      *
1144      * - `tokenId` must not exist.
1145      * - `to` cannot be the zero address.
1146      *
1147      * Emits a {Transfer} event.
1148      */
1149     function _mint(address to, uint256 tokenId) internal virtual {
1150         require(to != address(0), "ERC721: mint to the zero address");
1151         require(!_exists(tokenId), "ERC721: token already minted");
1152 
1153         _beforeTokenTransfer(address(0), to, tokenId);
1154 
1155         _balances[to] += 1;
1156         _owners[tokenId] = to;
1157 
1158         emit Transfer(address(0), to, tokenId);
1159 
1160         _afterTokenTransfer(address(0), to, tokenId);
1161     }
1162 
1163     /**
1164      * @dev Destroys `tokenId`.
1165      * The approval is cleared when the token is burned.
1166      *
1167      * Requirements:
1168      *
1169      * - `tokenId` must exist.
1170      *
1171      * Emits a {Transfer} event.
1172      */
1173     function _burn(uint256 tokenId) internal virtual {
1174         address owner = ERC721.ownerOf(tokenId);
1175 
1176         _beforeTokenTransfer(owner, address(0), tokenId);
1177 
1178         // Clear approvals
1179         _approve(address(0), tokenId);
1180 
1181         _balances[owner] -= 1;
1182         delete _owners[tokenId];
1183 
1184         emit Transfer(owner, address(0), tokenId);
1185 
1186         _afterTokenTransfer(owner, address(0), tokenId);
1187     }
1188 
1189     /**
1190      * @dev Transfers `tokenId` from `from` to `to`.
1191      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1192      *
1193      * Requirements:
1194      *
1195      * - `to` cannot be the zero address.
1196      * - `tokenId` token must be owned by `from`.
1197      *
1198      * Emits a {Transfer} event.
1199      */
1200     function _transfer(
1201         address from,
1202         address to,
1203         uint256 tokenId
1204     ) internal virtual {
1205         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1206         require(to != address(0), "ERC721: transfer to the zero address");
1207 
1208         _beforeTokenTransfer(from, to, tokenId);
1209 
1210         // Clear approvals from the previous owner
1211         _approve(address(0), tokenId);
1212 
1213         _balances[from] -= 1;
1214         _balances[to] += 1;
1215         _owners[tokenId] = to;
1216 
1217         emit Transfer(from, to, tokenId);
1218 
1219         _afterTokenTransfer(from, to, tokenId);
1220     }
1221 
1222     /**
1223      * @dev Approve `to` to operate on `tokenId`
1224      *
1225      * Emits a {Approval} event.
1226      */
1227     function _approve(address to, uint256 tokenId) internal virtual {
1228         _tokenApprovals[tokenId] = to;
1229         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1230     }
1231 
1232     /**
1233      * @dev Approve `operator` to operate on all of `owner` tokens
1234      *
1235      * Emits a {ApprovalForAll} event.
1236      */
1237     function _setApprovalForAll(
1238         address owner,
1239         address operator,
1240         bool approved
1241     ) internal virtual {
1242         require(owner != operator, "ERC721: approve to caller");
1243         _operatorApprovals[owner][operator] = approved;
1244         emit ApprovalForAll(owner, operator, approved);
1245     }
1246 
1247     /**
1248      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1249      * The call is not executed if the target address is not a contract.
1250      *
1251      * @param from address representing the previous owner of the given token ID
1252      * @param to target address that will receive the tokens
1253      * @param tokenId uint256 ID of the token to be transferred
1254      * @param _data bytes optional data to send along with the call
1255      * @return bool whether the call correctly returned the expected magic value
1256      */
1257     function _checkOnERC721Received(
1258         address from,
1259         address to,
1260         uint256 tokenId,
1261         bytes memory _data
1262     ) private returns (bool) {
1263         if (to.isContract()) {
1264             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1265                 return retval == IERC721Receiver.onERC721Received.selector;
1266             } catch (bytes memory reason) {
1267                 if (reason.length == 0) {
1268                     revert("ERC721: transfer to non ERC721Receiver implementer");
1269                 } else {
1270                     assembly {
1271                         revert(add(32, reason), mload(reason))
1272                     }
1273                 }
1274             }
1275         } else {
1276             return true;
1277         }
1278     }
1279 
1280     /**
1281      * @dev Hook that is called before any token transfer. This includes minting
1282      * and burning.
1283      *
1284      * Calling conditions:
1285      *
1286      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1287      * transferred to `to`.
1288      * - When `from` is zero, `tokenId` will be minted for `to`.
1289      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1290      * - `from` and `to` are never both zero.
1291      *
1292      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1293      */
1294     function _beforeTokenTransfer(
1295         address from,
1296         address to,
1297         uint256 tokenId
1298     ) internal virtual {}
1299 
1300     /**
1301      * @dev Hook that is called after any transfer of tokens. This includes
1302      * minting and burning.
1303      *
1304      * Calling conditions:
1305      *
1306      * - when `from` and `to` are both non-zero.
1307      * - `from` and `to` are never both zero.
1308      *
1309      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1310      */
1311     function _afterTokenTransfer(
1312         address from,
1313         address to,
1314         uint256 tokenId
1315     ) internal virtual {}
1316 }
1317 
1318 // File: contracts/MonaverseV2.sol
1319 
1320 
1321 pragma solidity ^0.8.0;
1322 
1323 
1324 
1325 
1326 
1327 
1328 contract MonaverseV2 is ERC721, Ownable, Pausable {
1329     // Original Monaverse contract, to be used for migration.
1330     ERC721 monaV1;
1331 
1332     // Mona Wallet for royalty payments and emergency withdrawals.
1333     address monaWallet;
1334 
1335     // Next token ID to be minted.
1336     uint256 private nextTokenId;
1337 
1338     // Can creators update the URIs of their tokens?
1339     bool creatorURIUpdatesPaused;
1340 
1341     // For EIP 2981, royalty rate out of 10,000.
1342     // For example, 10% royalties: royaltyRate = 1000.
1343     uint256 royaltyRate;
1344     uint256 constant royaltyRateDivisor = 10_000;
1345 
1346     // token id => uri
1347     mapping(uint256 => string) private _tokenURIs;
1348 
1349     // uri => used (has this URI been used before?)
1350     mapping(string => bool) private _tokenURIUsed;
1351 
1352     // token id => creator (who has permission to update this token's URI and get paid royalties?)
1353     mapping(uint256 => address) private _creators;
1354 
1355     // Prefix that all token URIs must begin with. Enforced when token URI is set to prevent typosquatting.
1356     string public uriPrefix;
1357 
1358     // @param: _name: The name of the ERC721 token.
1359     // @param: _symbol: The symbol of the ERC721 token.
1360     // @param: _royaltyRate: The rate (out of 10,000) EIP 2981 royalties should be paid at.
1361     // @param: _monaV1Address: The address of the original Mona contract to be used for migration.
1362     // @param: _monaWallet: The address where Mona royalties should be paid out (also used for emergency withdrawals).
1363     constructor(
1364         string memory _name,
1365         string memory _symbol,
1366         uint256 _royaltyRate,
1367         address _monaV1Address,
1368         address _monaWallet,
1369         string memory _uriPrefix
1370     ) ERC721(_name, _symbol) {
1371         royaltyRate = _royaltyRate;
1372         monaV1 = ERC721(_monaV1Address);
1373         monaWallet = _monaWallet;
1374         uriPrefix = _uriPrefix;
1375     }
1376 
1377     // MODIFIERS //
1378 
1379     // Is this URI allowed to be used? Only yes if it's unused
1380     modifier tokenURIAllowed(string memory _tokenURI) {
1381         require(!_tokenURIUsed[_tokenURI], "token uri already used");
1382         _tokenURIPrefixed(_tokenURI);
1383         _;
1384     }
1385 
1386     // Is this user allowed to update the URI of a given token?
1387     // Only yes if it's the creator and creator updates are unpaused, or admin.
1388     modifier allowedToUpdateURI(uint256 _tokenId) {
1389         _allowedToUpdateURI(_tokenId);
1390         _;
1391     }
1392 
1393     // Bulk allowedToUpdateURI check
1394     modifier allowedToUpdateURIs(uint256[] calldata _tokenIds) {
1395         for (uint256 i = 0; i < _tokenIds.length; i++) {
1396             _allowedToUpdateURI(_tokenIds[i]);
1397         }
1398         _;
1399     }
1400 
1401     function _allowedToUpdateURI(uint256 _tokenId) internal view {
1402         require(
1403             msg.sender == owner() ||
1404                 (msg.sender == _creators[_tokenId] && !creatorURIUpdatesPaused),
1405             "not allowed to update token uri"
1406         );
1407     }
1408 
1409     // Does the provided tokenURI have the correct prefix?
1410     function _tokenURIPrefixed(string memory _tokenURI) internal view {
1411         bytes memory newURIBytes = bytes(_tokenURI);
1412         uint256 prefixLength = bytes(uriPrefix).length;
1413         // New token URI must be longer than prefix, else bail early to prevent overflow.
1414         require(newURIBytes.length > prefixLength, "Incorrect URI prefix length");
1415         bytes memory resultPrefix = new bytes(prefixLength);
1416         // Slice prefixLength bytes from _tokenURI to compare.
1417         for (uint256 i; i < prefixLength; ) {
1418             resultPrefix[i] = newURIBytes[i];
1419             unchecked {
1420                 ++i;
1421             }
1422         }
1423         require(
1424             keccak256(resultPrefix) == keccak256(bytes(uriPrefix)),
1425             "Incorrect URI prefix"
1426         );
1427     }
1428 
1429     // MINTING & BURNING //
1430 
1431     // @notice: Mints a new token and assigns URI specific variables.
1432     // @notice: Once a creator claims are URI it cannot be used again to mint tokens.
1433     // @notice: If a creator wants to mint multiple copies of a space, they must use bulkMint.
1434     // @param: _tokenURI: URI of the new token.
1435     function mintToken(string memory _tokenURI)
1436         public
1437         whenNotPaused
1438         tokenURIAllowed(_tokenURI)
1439     {
1440         _tokenURIs[nextTokenId] = _tokenURI;
1441         _tokenURIUsed[_tokenURI] = true;
1442         _creators[nextTokenId] = msg.sender;
1443         _mint(msg.sender, nextTokenId++);
1444     }
1445 
1446     // @notice: Mints a number of new tokens with the same URI.
1447     // @notice: Subsequent mints with the same tokenURI will fail, ensure total supply is generated in 1 bulkMint call.
1448     // @param: _tokenURI: URI of the new tokens.
1449     // @param: _quantity: The number of tokens to mint.
1450     function bulkMintTokens(string memory _tokenURI, uint256 _quantity)
1451         external
1452         whenNotPaused
1453         tokenURIAllowed(_tokenURI)
1454     {
1455         _tokenURIUsed[_tokenURI] = true;
1456         for (uint256 i = 0; i < _quantity; i++) {
1457             _tokenURIs[nextTokenId] = _tokenURI;
1458             _creators[nextTokenId] = msg.sender;
1459             _mint(msg.sender, nextTokenId++);
1460         }
1461     }
1462 
1463     // @notice: Burns a given token, removing it from circulation.
1464     // @param: _tokenId: ID of the token to burn.
1465     function burn(uint256 _tokenId) public onlyOwner {
1466         _burn(_tokenId);
1467     }
1468 
1469     // TOKEN URI FUNCTIONS //
1470 
1471     // @notice: Updates the URI of a given token to a new URI.
1472     // @notice: Requires that the new URI is unused, and that sender is this token's creator or admin.
1473     // @param: _tokenId: ID of the token to update.
1474     // @param: _tokenURI: New URI to assign to the token.
1475     function updateTokenURI(uint256 _tokenId, string calldata _tokenURI)
1476         public
1477         tokenURIAllowed(_tokenURI)
1478         allowedToUpdateURI(_tokenId)
1479     {
1480         _tokenURIs[_tokenId] = _tokenURI;
1481         _tokenURIUsed[_tokenURI] = true;
1482     }
1483 
1484     // @notice: Updates a number of tokens to the same new URI.
1485     // @notice: Requires that the new URI is unused, and that sender is this token's creator or admin.
1486     // @param: _tokenIds: An array of the IDs of the tokens to update.
1487     // @param: _tokenURI: New URI to assign to the tokens.
1488     function bulkUpdateTokenURIs(
1489         uint256[] calldata _tokenIds,
1490         string calldata _tokenURI
1491     ) public tokenURIAllowed(_tokenURI) allowedToUpdateURIs(_tokenIds) {
1492         _tokenURIUsed[_tokenURI] = true;
1493         for (uint256 i = 0; i < _tokenIds.length; i++) {
1494             _tokenURIs[_tokenIds[i]] = _tokenURI;
1495         }
1496     }
1497 
1498     // @notice: Returns the URI of a given token.
1499     // @param: _tokenId: ID of the token to get the URI of.
1500     function tokenURI(uint256 _tokenId)
1501         public
1502         view
1503         virtual
1504         override
1505         returns (string memory)
1506     {
1507         require(_exists(_tokenId), "nonexistant token");
1508         return _tokenURIs[_tokenId];
1509     }
1510 
1511     // CREATOR & URI OWNER //
1512 
1513     // @notice: Update the creator of a given token.
1514     // @notice: Only the creator of the token or the admin can update the creator.
1515     // @param: _tokenId: ID of the token to update.
1516     // @param: _newCreator: The address of the new creator to assign to the token.
1517     function updateCreator(uint256 _tokenId, address _newCreator) public {
1518         require(
1519             msg.sender == _creators[_tokenId] || msg.sender == owner(),
1520             "only creator"
1521         );
1522         _creators[_tokenId] = _newCreator;
1523     }
1524 
1525     // @notice: Returns the creator of a given token.
1526     // @param: _tokenId: ID of the token to get the creator of.
1527     function creatorOf(uint256 _tokenId) public view returns (address) {
1528         require(_exists(_tokenId), "nonexistant token");
1529         return _creators[_tokenId];
1530     }
1531 
1532     // @notice: Allows admin to update the enforce URI prefix.
1533     // @param: _uriPrefix: Prefix expected in URI updates
1534     function updateURIPrefix(string calldata _uriPrefix) public onlyOwner {
1535         uriPrefix = _uriPrefix;
1536     }
1537 
1538     // PAUSE AND UNPAUSE //
1539 
1540     // @notice: Pauses minting of tokens.
1541     // @notice: Only the admin can pause minting.
1542     // @notice: Uses the _pause() function from the Pausable OZ import.
1543     function pauseMinting() public onlyOwner {
1544         _pause();
1545     }
1546 
1547     // @notice: Unpauses minting of tokens.
1548     // @notice: Only the admin can unpause minting.
1549     // @notice: Uses the _unpause() function from the Pausable OZ import.
1550     function unpauseMinting() public onlyOwner {
1551         _unpause();
1552     }
1553 
1554     // @notice: Turns OFF permission for creators to update URIs of their tokens.
1555     // @notice: Only the admin can pause creator URI updates.
1556     function pauseCreatorURIUpdates() public onlyOwner {
1557         creatorURIUpdatesPaused = true;
1558     }
1559 
1560     // @notice: Turns ON permission for creators to update URIs of their tokens.
1561     // @notice: Only the admin can unpause creator URI updates.
1562     function unpauseCreatorURIUpdates() public onlyOwner {
1563         creatorURIUpdatesPaused = false;
1564     }
1565 
1566     // ROYALTY INFO //
1567 
1568     // @notice: EIP 165 compliance to let marketplaces know we implement EIP 2981 for royalty info.
1569     function supportsInterface(bytes4 interfaceId)
1570         public
1571         view
1572         virtual
1573         override(ERC721)
1574         returns (bool)
1575     {
1576         return
1577             interfaceId == type(IERC2981).interfaceId ||
1578             super.supportsInterface(interfaceId);
1579     }
1580 
1581     // @notice: Royalty info function, as specified in EIP 2981.
1582     // @notice: Returns the address to pay royalties to, and the amount to pay out.
1583     // @notice: monaWallet is set to receive royalties, but admin can set address to 0 and royalties will flow straight to creators.
1584     // @param: _tokenId: ID of the token to get royalty info for.
1585     // @param: _salePrice: How much the token sold for, to use in royalty calculations.
1586     function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
1587         external
1588         view
1589         returns (address receiver, uint256 royaltyAmount)
1590     {
1591         require(_exists(_tokenId), "nonexistant token");
1592         uint256 amountToPay = (_salePrice * royaltyRate) / royaltyRateDivisor;
1593         return (
1594             monaWallet == address(0) ? _creators[_tokenId] : monaWallet,
1595             amountToPay
1596         );
1597     }
1598 
1599     // @notice: Update the address of the Mona Wallet, to collect EIP 2981 royalties or do emergency withdrawals.
1600     // @notice: Only the admin can update the Mona Wallet.
1601     // @param: _newMonaWallet: The address of the new Mona Wallet.
1602     function updateMonaWallet(address _newMonaWallet) public onlyOwner {
1603         monaWallet = _newMonaWallet;
1604     }
1605 
1606     // @notice: Update the royalty rate for EIP 2981 compliant marketplaces.
1607     // @notice: Only the admin can update the royalty rate.
1608     // @param: _rate: The new royalty rate, calculated as x / 10,000. For example, 10% royalties = 1000.
1609     function updateRoyaltyRate(uint256 _rate) public onlyOwner {
1610         royaltyRate = _rate;
1611     }
1612 
1613     // EMERGENCY WITHDRAWALS //
1614 
1615     // @notice: Emergency withdraw any Eth in this contract to the Mona Wallet.
1616     function withdrawEth() public onlyOwner {
1617         payable(monaWallet).transfer(address(this).balance);
1618     }
1619 
1620     // @notice: Emergency withdraw any ERC20 tokens in this contract to the Mona Wallet.
1621     // @param: amount: The amount of tokens to withdraw.
1622     // @param: token: The ERC20 token to withdraw.
1623     function withdrawERC20(uint256 amount, address token) public onlyOwner {
1624         IERC20(token).transfer(monaWallet, amount);
1625     }
1626 
1627     // MIGRATION FROM V1 //
1628 
1629     // @notice: Migration function to move all tokens over from V1.
1630     // @param: tokensToMigrate: An array of tokenIds to migration from V1.
1631     // @param: oldTokenCreators: An array containing the creators of each of the tokens to migrate.
1632     function migrateTokens(
1633         uint256[] calldata tokensToMigrate,
1634         address[] calldata oldTokenCreators
1635     ) public onlyOwner {
1636         require(
1637             tokensToMigrate.length == oldTokenCreators.length,
1638             "tokenIds and creators must be the same length"
1639         );
1640         for (uint256 i = 0; i < tokensToMigrate.length; i++) {
1641             string memory oldTokenURI = monaV1.tokenURI(tokensToMigrate[i]);
1642 
1643             _tokenURIs[nextTokenId] = oldTokenURI;
1644             _tokenURIUsed[oldTokenURI] = true;
1645             _creators[nextTokenId] = oldTokenCreators[i];
1646 
1647             address oldTokenOwner = monaV1.ownerOf(tokensToMigrate[i]);
1648             _mint(oldTokenOwner, nextTokenId++);
1649         }
1650     }
1651 }