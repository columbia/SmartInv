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
86 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
87 
88 
89 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 /**
94  * @dev Interface of the ERC165 standard, as defined in the
95  * https://eips.ethereum.org/EIPS/eip-165[EIP].
96  *
97  * Implementers can declare support of contract interfaces, which can then be
98  * queried by others ({ERC165Checker}).
99  *
100  * For an implementation, see {ERC165}.
101  */
102 interface IERC165 {
103     /**
104      * @dev Returns true if this contract implements the interface defined by
105      * `interfaceId`. See the corresponding
106      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
107      * to learn more about how these ids are created.
108      *
109      * This function call must use less than 30 000 gas.
110      */
111     function supportsInterface(bytes4 interfaceId) external view returns (bool);
112 }
113 
114 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
115 
116 
117 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 
122 /**
123  * @dev Required interface of an ERC721 compliant contract.
124  */
125 interface IERC721 is IERC165 {
126     /**
127      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
128      */
129     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
130 
131     /**
132      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
133      */
134     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
135 
136     /**
137      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
138      */
139     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
140 
141     /**
142      * @dev Returns the number of tokens in ``owner``'s account.
143      */
144     function balanceOf(address owner) external view returns (uint256 balance);
145 
146     /**
147      * @dev Returns the owner of the `tokenId` token.
148      *
149      * Requirements:
150      *
151      * - `tokenId` must exist.
152      */
153     function ownerOf(uint256 tokenId) external view returns (address owner);
154 
155     /**
156      * @dev Safely transfers `tokenId` token from `from` to `to`.
157      *
158      * Requirements:
159      *
160      * - `from` cannot be the zero address.
161      * - `to` cannot be the zero address.
162      * - `tokenId` token must exist and be owned by `from`.
163      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
164      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
165      *
166      * Emits a {Transfer} event.
167      */
168     function safeTransferFrom(
169         address from,
170         address to,
171         uint256 tokenId,
172         bytes calldata data
173     ) external;
174 
175     /**
176      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
177      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
178      *
179      * Requirements:
180      *
181      * - `from` cannot be the zero address.
182      * - `to` cannot be the zero address.
183      * - `tokenId` token must exist and be owned by `from`.
184      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
185      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
186      *
187      * Emits a {Transfer} event.
188      */
189     function safeTransferFrom(
190         address from,
191         address to,
192         uint256 tokenId
193     ) external;
194 
195     /**
196      * @dev Transfers `tokenId` token from `from` to `to`.
197      *
198      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
199      *
200      * Requirements:
201      *
202      * - `from` cannot be the zero address.
203      * - `to` cannot be the zero address.
204      * - `tokenId` token must be owned by `from`.
205      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
206      *
207      * Emits a {Transfer} event.
208      */
209     function transferFrom(
210         address from,
211         address to,
212         uint256 tokenId
213     ) external;
214 
215     /**
216      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
217      * The approval is cleared when the token is transferred.
218      *
219      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
220      *
221      * Requirements:
222      *
223      * - The caller must own the token or be an approved operator.
224      * - `tokenId` must exist.
225      *
226      * Emits an {Approval} event.
227      */
228     function approve(address to, uint256 tokenId) external;
229 
230     /**
231      * @dev Approve or remove `operator` as an operator for the caller.
232      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
233      *
234      * Requirements:
235      *
236      * - The `operator` cannot be the caller.
237      *
238      * Emits an {ApprovalForAll} event.
239      */
240     function setApprovalForAll(address operator, bool _approved) external;
241 
242     /**
243      * @dev Returns the account approved for `tokenId` token.
244      *
245      * Requirements:
246      *
247      * - `tokenId` must exist.
248      */
249     function getApproved(uint256 tokenId) external view returns (address operator);
250 
251     /**
252      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
253      *
254      * See {setApprovalForAll}
255      */
256     function isApprovedForAll(address owner, address operator) external view returns (bool);
257 }
258 
259 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
260 
261 
262 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
263 
264 pragma solidity ^0.8.0;
265 
266 
267 /**
268  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
269  * @dev See https://eips.ethereum.org/EIPS/eip-721
270  */
271 interface IERC721Metadata is IERC721 {
272     /**
273      * @dev Returns the token collection name.
274      */
275     function name() external view returns (string memory);
276 
277     /**
278      * @dev Returns the token collection symbol.
279      */
280     function symbol() external view returns (string memory);
281 
282     /**
283      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
284      */
285     function tokenURI(uint256 tokenId) external view returns (string memory);
286 }
287 
288 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
289 
290 
291 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
292 
293 pragma solidity ^0.8.0;
294 
295 
296 /**
297  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
298  * @dev See https://eips.ethereum.org/EIPS/eip-721
299  */
300 interface IERC721Enumerable is IERC721 {
301     /**
302      * @dev Returns the total amount of tokens stored by the contract.
303      */
304     function totalSupply() external view returns (uint256);
305 
306     /**
307      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
308      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
309      */
310     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
311 
312     /**
313      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
314      * Use along with {totalSupply} to enumerate all tokens.
315      */
316     function tokenByIndex(uint256 index) external view returns (uint256);
317 }
318 
319 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
320 
321 
322 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
323 
324 pragma solidity ^0.8.0;
325 
326 
327 /**
328  * @dev Implementation of the {IERC165} interface.
329  *
330  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
331  * for the additional interface id that will be supported. For example:
332  *
333  * ```solidity
334  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
335  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
336  * }
337  * ```
338  *
339  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
340  */
341 abstract contract ERC165 is IERC165 {
342     /**
343      * @dev See {IERC165-supportsInterface}.
344      */
345     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
346         return interfaceId == type(IERC165).interfaceId;
347     }
348 }
349 
350 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
351 
352 
353 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
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
370      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
371      */
372     function onERC721Received(
373         address operator,
374         address from,
375         uint256 tokenId,
376         bytes calldata data
377     ) external returns (bytes4);
378 }
379 
380 // File: @openzeppelin/contracts/utils/Context.sol
381 
382 
383 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
384 
385 pragma solidity ^0.8.0;
386 
387 /**
388  * @dev Provides information about the current execution context, including the
389  * sender of the transaction and its data. While these are generally available
390  * via msg.sender and msg.data, they should not be accessed in such a direct
391  * manner, since when dealing with meta-transactions the account sending and
392  * paying for execution may not be the actual sender (as far as an application
393  * is concerned).
394  *
395  * This contract is only required for intermediate, library-like contracts.
396  */
397 abstract contract Context {
398     function _msgSender() internal view virtual returns (address) {
399         return msg.sender;
400     }
401 
402     function _msgData() internal view virtual returns (bytes calldata) {
403         return msg.data;
404     }
405 }
406 
407 // File: @openzeppelin/contracts/access/Ownable.sol
408 
409 
410 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
411 
412 pragma solidity ^0.8.0;
413 
414 
415 /**
416  * @dev Contract module which provides a basic access control mechanism, where
417  * there is an account (an owner) that can be granted exclusive access to
418  * specific functions.
419  *
420  * By default, the owner account will be the one that deploys the contract. This
421  * can later be changed with {transferOwnership}.
422  *
423  * This module is used through inheritance. It will make available the modifier
424  * `onlyOwner`, which can be applied to your functions to restrict their use to
425  * the owner.
426  */
427 abstract contract Ownable is Context {
428     address private _owner;
429 
430     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
431 
432     /**
433      * @dev Initializes the contract setting the deployer as the initial owner.
434      */
435     constructor() {
436         _transferOwnership(_msgSender());
437     }
438 
439     /**
440      * @dev Throws if called by any account other than the owner.
441      */
442     modifier onlyOwner() {
443         _checkOwner();
444         _;
445     }
446 
447     /**
448      * @dev Returns the address of the current owner.
449      */
450     function owner() public view virtual returns (address) {
451         return _owner;
452     }
453 
454     /**
455      * @dev Throws if the sender is not the owner.
456      */
457     function _checkOwner() internal view virtual {
458         require(owner() == _msgSender(), "Ownable: caller is not the owner");
459     }
460 
461     /**
462      * @dev Leaves the contract without owner. It will not be possible to call
463      * `onlyOwner` functions anymore. Can only be called by the current owner.
464      *
465      * NOTE: Renouncing ownership will leave the contract without an owner,
466      * thereby removing any functionality that is only available to the owner.
467      */
468     function renounceOwnership() public virtual onlyOwner {
469         _transferOwnership(address(0));
470     }
471 
472     /**
473      * @dev Transfers ownership of the contract to a new account (`newOwner`).
474      * Can only be called by the current owner.
475      */
476     function transferOwnership(address newOwner) public virtual onlyOwner {
477         require(newOwner != address(0), "Ownable: new owner is the zero address");
478         _transferOwnership(newOwner);
479     }
480 
481     /**
482      * @dev Transfers ownership of the contract to a new account (`newOwner`).
483      * Internal function without access restriction.
484      */
485     function _transferOwnership(address newOwner) internal virtual {
486         address oldOwner = _owner;
487         _owner = newOwner;
488         emit OwnershipTransferred(oldOwner, newOwner);
489     }
490 }
491 
492 // File: @openzeppelin/contracts/utils/Address.sol
493 
494 
495 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
496 
497 pragma solidity ^0.8.1;
498 
499 /**
500  * @dev Collection of functions related to the address type
501  */
502 library Address {
503     /**
504      * @dev Returns true if `account` is a contract.
505      *
506      * [IMPORTANT]
507      * ====
508      * It is unsafe to assume that an address for which this function returns
509      * false is an externally-owned account (EOA) and not a contract.
510      *
511      * Among others, `isContract` will return false for the following
512      * types of addresses:
513      *
514      *  - an externally-owned account
515      *  - a contract in construction
516      *  - an address where a contract will be created
517      *  - an address where a contract lived, but was destroyed
518      * ====
519      *
520      * [IMPORTANT]
521      * ====
522      * You shouldn't rely on `isContract` to protect against flash loan attacks!
523      *
524      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
525      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
526      * constructor.
527      * ====
528      */
529     function isContract(address account) internal view returns (bool) {
530         // This method relies on extcodesize/address.code.length, which returns 0
531         // for contracts in construction, since the code is only stored at the end
532         // of the constructor execution.
533 
534         return account.code.length > 0;
535     }
536 
537     /**
538      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
539      * `recipient`, forwarding all available gas and reverting on errors.
540      *
541      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
542      * of certain opcodes, possibly making contracts go over the 2300 gas limit
543      * imposed by `transfer`, making them unable to receive funds via
544      * `transfer`. {sendValue} removes this limitation.
545      *
546      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
547      *
548      * IMPORTANT: because control is transferred to `recipient`, care must be
549      * taken to not create reentrancy vulnerabilities. Consider using
550      * {ReentrancyGuard} or the
551      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
552      */
553     function sendValue(address payable recipient, uint256 amount) internal {
554         require(address(this).balance >= amount, "Address: insufficient balance");
555 
556         (bool success, ) = recipient.call{value: amount}("");
557         require(success, "Address: unable to send value, recipient may have reverted");
558     }
559 
560     /**
561      * @dev Performs a Solidity function call using a low level `call`. A
562      * plain `call` is an unsafe replacement for a function call: use this
563      * function instead.
564      *
565      * If `target` reverts with a revert reason, it is bubbled up by this
566      * function (like regular Solidity function calls).
567      *
568      * Returns the raw returned data. To convert to the expected return value,
569      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
570      *
571      * Requirements:
572      *
573      * - `target` must be a contract.
574      * - calling `target` with `data` must not revert.
575      *
576      * _Available since v3.1._
577      */
578     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
579         return functionCall(target, data, "Address: low-level call failed");
580     }
581 
582     /**
583      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
584      * `errorMessage` as a fallback revert reason when `target` reverts.
585      *
586      * _Available since v3.1._
587      */
588     function functionCall(
589         address target,
590         bytes memory data,
591         string memory errorMessage
592     ) internal returns (bytes memory) {
593         return functionCallWithValue(target, data, 0, errorMessage);
594     }
595 
596     /**
597      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
598      * but also transferring `value` wei to `target`.
599      *
600      * Requirements:
601      *
602      * - the calling contract must have an ETH balance of at least `value`.
603      * - the called Solidity function must be `payable`.
604      *
605      * _Available since v3.1._
606      */
607     function functionCallWithValue(
608         address target,
609         bytes memory data,
610         uint256 value
611     ) internal returns (bytes memory) {
612         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
613     }
614 
615     /**
616      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
617      * with `errorMessage` as a fallback revert reason when `target` reverts.
618      *
619      * _Available since v3.1._
620      */
621     function functionCallWithValue(
622         address target,
623         bytes memory data,
624         uint256 value,
625         string memory errorMessage
626     ) internal returns (bytes memory) {
627         require(address(this).balance >= value, "Address: insufficient balance for call");
628         require(isContract(target), "Address: call to non-contract");
629 
630         (bool success, bytes memory returndata) = target.call{value: value}(data);
631         return verifyCallResult(success, returndata, errorMessage);
632     }
633 
634     /**
635      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
636      * but performing a static call.
637      *
638      * _Available since v3.3._
639      */
640     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
641         return functionStaticCall(target, data, "Address: low-level static call failed");
642     }
643 
644     /**
645      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
646      * but performing a static call.
647      *
648      * _Available since v3.3._
649      */
650     function functionStaticCall(
651         address target,
652         bytes memory data,
653         string memory errorMessage
654     ) internal view returns (bytes memory) {
655         require(isContract(target), "Address: static call to non-contract");
656 
657         (bool success, bytes memory returndata) = target.staticcall(data);
658         return verifyCallResult(success, returndata, errorMessage);
659     }
660 
661     /**
662      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
663      * but performing a delegate call.
664      *
665      * _Available since v3.4._
666      */
667     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
668         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
669     }
670 
671     /**
672      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
673      * but performing a delegate call.
674      *
675      * _Available since v3.4._
676      */
677     function functionDelegateCall(
678         address target,
679         bytes memory data,
680         string memory errorMessage
681     ) internal returns (bytes memory) {
682         require(isContract(target), "Address: delegate call to non-contract");
683 
684         (bool success, bytes memory returndata) = target.delegatecall(data);
685         return verifyCallResult(success, returndata, errorMessage);
686     }
687 
688     /**
689      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
690      * revert reason using the provided one.
691      *
692      * _Available since v4.3._
693      */
694     function verifyCallResult(
695         bool success,
696         bytes memory returndata,
697         string memory errorMessage
698     ) internal pure returns (bytes memory) {
699         if (success) {
700             return returndata;
701         } else {
702             // Look for revert reason and bubble it up if present
703             if (returndata.length > 0) {
704                 // The easiest way to bubble the revert reason is using memory via assembly
705                 /// @solidity memory-safe-assembly
706                 assembly {
707                     let returndata_size := mload(returndata)
708                     revert(add(32, returndata), returndata_size)
709                 }
710             } else {
711                 revert(errorMessage);
712             }
713         }
714     }
715 }
716 
717 // File: @openzeppelin/contracts/utils/Strings.sol
718 
719 
720 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
721 
722 pragma solidity ^0.8.0;
723 
724 /**
725  * @dev String operations.
726  */
727 library Strings {
728     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
729     uint8 private constant _ADDRESS_LENGTH = 20;
730 
731     /**
732      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
733      */
734     function toString(uint256 value) internal pure returns (string memory) {
735         // Inspired by OraclizeAPI's implementation - MIT licence
736         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
737 
738         if (value == 0) {
739             return "0";
740         }
741         uint256 temp = value;
742         uint256 digits;
743         while (temp != 0) {
744             digits++;
745             temp /= 10;
746         }
747         bytes memory buffer = new bytes(digits);
748         while (value != 0) {
749             digits -= 1;
750             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
751             value /= 10;
752         }
753         return string(buffer);
754     }
755 
756     /**
757      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
758      */
759     function toHexString(uint256 value) internal pure returns (string memory) {
760         if (value == 0) {
761             return "0x00";
762         }
763         uint256 temp = value;
764         uint256 length = 0;
765         while (temp != 0) {
766             length++;
767             temp >>= 8;
768         }
769         return toHexString(value, length);
770     }
771 
772     /**
773      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
774      */
775     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
776         bytes memory buffer = new bytes(2 * length + 2);
777         buffer[0] = "0";
778         buffer[1] = "x";
779         for (uint256 i = 2 * length + 1; i > 1; --i) {
780             buffer[i] = _HEX_SYMBOLS[value & 0xf];
781             value >>= 4;
782         }
783         require(value == 0, "Strings: hex length insufficient");
784         return string(buffer);
785     }
786 
787     /**
788      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
789      */
790     function toHexString(address addr) internal pure returns (string memory) {
791         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
792     }
793 }
794 
795 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
796 
797 
798 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
799 
800 pragma solidity ^0.8.0;
801 
802 /**
803  * @dev These functions deal with verification of Merkle Tree proofs.
804  *
805  * The proofs can be generated using the JavaScript library
806  * https://github.com/miguelmota/merkletreejs[merkletreejs].
807  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
808  *
809  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
810  *
811  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
812  * hashing, or use a hash function other than keccak256 for hashing leaves.
813  * This is because the concatenation of a sorted pair of internal nodes in
814  * the merkle tree could be reinterpreted as a leaf value.
815  */
816 library MerkleProof {
817     /**
818      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
819      * defined by `root`. For this, a `proof` must be provided, containing
820      * sibling hashes on the branch from the leaf to the root of the tree. Each
821      * pair of leaves and each pair of pre-images are assumed to be sorted.
822      */
823     function verify(
824         bytes32[] memory proof,
825         bytes32 root,
826         bytes32 leaf
827     ) internal pure returns (bool) {
828         return processProof(proof, leaf) == root;
829     }
830 
831     /**
832      * @dev Calldata version of {verify}
833      *
834      * _Available since v4.7._
835      */
836     function verifyCalldata(
837         bytes32[] calldata proof,
838         bytes32 root,
839         bytes32 leaf
840     ) internal pure returns (bool) {
841         return processProofCalldata(proof, leaf) == root;
842     }
843 
844     /**
845      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
846      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
847      * hash matches the root of the tree. When processing the proof, the pairs
848      * of leafs & pre-images are assumed to be sorted.
849      *
850      * _Available since v4.4._
851      */
852     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
853         bytes32 computedHash = leaf;
854         for (uint256 i = 0; i < proof.length; i++) {
855             computedHash = _hashPair(computedHash, proof[i]);
856         }
857         return computedHash;
858     }
859 
860     /**
861      * @dev Calldata version of {processProof}
862      *
863      * _Available since v4.7._
864      */
865     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
866         bytes32 computedHash = leaf;
867         for (uint256 i = 0; i < proof.length; i++) {
868             computedHash = _hashPair(computedHash, proof[i]);
869         }
870         return computedHash;
871     }
872 
873     /**
874      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
875      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
876      *
877      * _Available since v4.7._
878      */
879     function multiProofVerify(
880         bytes32[] memory proof,
881         bool[] memory proofFlags,
882         bytes32 root,
883         bytes32[] memory leaves
884     ) internal pure returns (bool) {
885         return processMultiProof(proof, proofFlags, leaves) == root;
886     }
887 
888     /**
889      * @dev Calldata version of {multiProofVerify}
890      *
891      * _Available since v4.7._
892      */
893     function multiProofVerifyCalldata(
894         bytes32[] calldata proof,
895         bool[] calldata proofFlags,
896         bytes32 root,
897         bytes32[] memory leaves
898     ) internal pure returns (bool) {
899         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
900     }
901 
902     /**
903      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
904      * consuming from one or the other at each step according to the instructions given by
905      * `proofFlags`.
906      *
907      * _Available since v4.7._
908      */
909     function processMultiProof(
910         bytes32[] memory proof,
911         bool[] memory proofFlags,
912         bytes32[] memory leaves
913     ) internal pure returns (bytes32 merkleRoot) {
914         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
915         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
916         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
917         // the merkle tree.
918         uint256 leavesLen = leaves.length;
919         uint256 totalHashes = proofFlags.length;
920 
921         // Check proof validity.
922         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
923 
924         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
925         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
926         bytes32[] memory hashes = new bytes32[](totalHashes);
927         uint256 leafPos = 0;
928         uint256 hashPos = 0;
929         uint256 proofPos = 0;
930         // At each step, we compute the next hash using two values:
931         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
932         //   get the next hash.
933         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
934         //   `proof` array.
935         for (uint256 i = 0; i < totalHashes; i++) {
936             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
937             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
938             hashes[i] = _hashPair(a, b);
939         }
940 
941         if (totalHashes > 0) {
942             return hashes[totalHashes - 1];
943         } else if (leavesLen > 0) {
944             return leaves[0];
945         } else {
946             return proof[0];
947         }
948     }
949 
950     /**
951      * @dev Calldata version of {processMultiProof}
952      *
953      * _Available since v4.7._
954      */
955     function processMultiProofCalldata(
956         bytes32[] calldata proof,
957         bool[] calldata proofFlags,
958         bytes32[] memory leaves
959     ) internal pure returns (bytes32 merkleRoot) {
960         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
961         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
962         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
963         // the merkle tree.
964         uint256 leavesLen = leaves.length;
965         uint256 totalHashes = proofFlags.length;
966 
967         // Check proof validity.
968         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
969 
970         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
971         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
972         bytes32[] memory hashes = new bytes32[](totalHashes);
973         uint256 leafPos = 0;
974         uint256 hashPos = 0;
975         uint256 proofPos = 0;
976         // At each step, we compute the next hash using two values:
977         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
978         //   get the next hash.
979         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
980         //   `proof` array.
981         for (uint256 i = 0; i < totalHashes; i++) {
982             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
983             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
984             hashes[i] = _hashPair(a, b);
985         }
986 
987         if (totalHashes > 0) {
988             return hashes[totalHashes - 1];
989         } else if (leavesLen > 0) {
990             return leaves[0];
991         } else {
992             return proof[0];
993         }
994     }
995 
996     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
997         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
998     }
999 
1000     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1001         /// @solidity memory-safe-assembly
1002         assembly {
1003             mstore(0x00, a)
1004             mstore(0x20, b)
1005             value := keccak256(0x00, 0x40)
1006         }
1007     }
1008 }
1009 
1010 // File: contracts/FSD_NFT.sol
1011 
1012 
1013 
1014 
1015 
1016 
1017 
1018 
1019 
1020 
1021 
1022 
1023 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
1024 
1025 
1026 // Creator: Chiru Labs
1027 
1028 pragma solidity ^0.8.4;
1029 
1030 
1031 
1032 
1033 
1034 
1035 
1036 
1037 
1038 error ApprovalCallerNotOwnerNorApproved();
1039 error ApprovalQueryForNonexistentToken();
1040 error ApproveToCaller();
1041 error ApprovalToCurrentOwner();
1042 error BalanceQueryForZeroAddress();
1043 error MintedQueryForZeroAddress();
1044 error BurnedQueryForZeroAddress();
1045 error AuxQueryForZeroAddress();
1046 error MintToZeroAddress();
1047 error MintZeroQuantity();
1048 error OwnerIndexOutOfBounds();
1049 error OwnerQueryForNonexistentToken();
1050 error TokenIndexOutOfBounds();
1051 error TransferCallerNotOwnerNorApproved();
1052 error TransferFromIncorrectOwner();
1053 error TransferToNonERC721ReceiverImplementer();
1054 error TransferToZeroAddress();
1055 error URIQueryForNonexistentToken();
1056 
1057 /**
1058  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1059  * the Metadata extension. Built to optimize for lower gas during batch mints.
1060  *
1061  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1062  *
1063  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1064  *
1065  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1066  */
1067 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1068     using Address for address;
1069     using Strings for uint256;
1070 
1071     // Compiler will pack this into a single 256bit word.
1072     struct TokenOwnership {
1073         // The address of the owner.
1074         address addr;
1075         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1076         uint64 startTimestamp;
1077         // Whether the token has been burned.
1078         bool burned;
1079     }
1080 
1081     // Compiler will pack this into a single 256bit word.
1082     struct AddressData {
1083         // Realistically, 2**64-1 is more than enough.
1084         uint64 balance;
1085         // Keeps track of mint count with minimal overhead for tokenomics.
1086         uint64 numberMinted;
1087         // Keeps track of burn count with minimal overhead for tokenomics.
1088         uint64 numberBurned;
1089         // For miscellaneous variable(s) pertaining to the address
1090         // (e.g. number of whitelist mint slots used). 
1091         // If there are multiple variables, please pack them into a uint64.
1092         uint64 aux;
1093     }
1094 
1095     // The tokenId of the next token to be minted.
1096     uint256 internal _currentIndex;
1097 
1098     // The number of tokens burned.
1099     uint256 internal _burnCounter;
1100 
1101     // Token name
1102     string private _name;
1103 
1104     // Token symbol
1105     string private _symbol;
1106 
1107     // Mapping from token ID to ownership details
1108     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1109     mapping(uint256 => TokenOwnership) internal _ownerships;
1110 
1111     // Mapping owner address to address data
1112     mapping(address => AddressData) private _addressData;
1113 
1114     // Mapping from token ID to approved address
1115     mapping(uint256 => address) private _tokenApprovals;
1116 
1117     // Mapping from owner to operator approvals
1118     mapping(address => mapping(address => bool)) private _operatorApprovals;
1119 
1120     constructor(string memory name_, string memory symbol_) {
1121         _name = name_;
1122         _symbol = symbol_;
1123     }
1124 
1125     /**
1126      * @dev See {IERC721Enumerable-totalSupply}.
1127      */
1128     function totalSupply() public view returns (uint256) {
1129         // Counter underflow is impossible as _burnCounter cannot be incremented
1130         // more than _currentIndex times
1131         unchecked {
1132             return _currentIndex - _burnCounter;    
1133         }
1134     }
1135 
1136     /**
1137      * @dev See {IERC165-supportsInterface}.
1138      */
1139     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1140         return
1141             interfaceId == type(IERC721).interfaceId ||
1142             interfaceId == type(IERC721Metadata).interfaceId ||
1143             super.supportsInterface(interfaceId);
1144     }
1145 
1146     /**
1147      * @dev See {IERC721-balanceOf}.
1148      */
1149     function balanceOf(address owner) public view override returns (uint256) {
1150         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1151         return uint256(_addressData[owner].balance);
1152     }
1153 
1154     /**
1155      * Returns the number of tokens minted by `owner`.
1156      */
1157     function _numberMinted(address owner) internal view returns (uint256) {
1158         if (owner == address(0)) revert MintedQueryForZeroAddress();
1159         return uint256(_addressData[owner].numberMinted);
1160     }
1161 
1162     /**
1163      * Returns the number of tokens burned by or on behalf of `owner`.
1164      */
1165     function _numberBurned(address owner) internal view returns (uint256) {
1166         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1167         return uint256(_addressData[owner].numberBurned);
1168     }
1169 
1170     /**
1171      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1172      */
1173     function _getAux(address owner) internal view returns (uint64) {
1174         if (owner == address(0)) revert AuxQueryForZeroAddress();
1175         return _addressData[owner].aux;
1176     }
1177 
1178     /**
1179      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1180      * If there are multiple variables, please pack them into a uint64.
1181      */
1182     function _setAux(address owner, uint64 aux) internal {
1183         if (owner == address(0)) revert AuxQueryForZeroAddress();
1184         _addressData[owner].aux = aux;
1185     }
1186 
1187     /**
1188      * Gas spent here starts off proportional to the maximum mint batch size.
1189      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1190      */
1191     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1192         uint256 curr = tokenId;
1193 
1194         unchecked {
1195             if (curr < _currentIndex) {
1196                 TokenOwnership memory ownership = _ownerships[curr];
1197                 if (!ownership.burned) {
1198                     if (ownership.addr != address(0)) {
1199                         return ownership;
1200                     }
1201                     // Invariant: 
1202                     // There will always be an ownership that has an address and is not burned 
1203                     // before an ownership that does not have an address and is not burned.
1204                     // Hence, curr will not underflow.
1205                     while (true) {
1206                         curr--;
1207                         ownership = _ownerships[curr];
1208                         if (ownership.addr != address(0)) {
1209                             return ownership;
1210                         }
1211                     }
1212                 }
1213             }
1214         }
1215         revert OwnerQueryForNonexistentToken();
1216     }
1217 
1218     /**
1219      * @dev See {IERC721-ownerOf}.
1220      */
1221     function ownerOf(uint256 tokenId) public view override returns (address) {
1222         return ownershipOf(tokenId).addr;
1223     }
1224 
1225     /**
1226      * @dev See {IERC721Metadata-name}.
1227      */
1228     function name() public view virtual override returns (string memory) {
1229         return _name;
1230     }
1231 
1232     /**
1233      * @dev See {IERC721Metadata-symbol}.
1234      */
1235     function symbol() public view virtual override returns (string memory) {
1236         return _symbol;
1237     }
1238 
1239     /**
1240      * @dev See {IERC721Metadata-tokenURI}.
1241      */
1242     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1243         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1244 
1245         string memory baseURI = _baseURI();
1246         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1247     }
1248 
1249     /**
1250      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1251      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1252      * by default, can be overriden in child contracts.
1253      */
1254     function _baseURI() internal view virtual returns (string memory) {
1255         return '';
1256     }
1257 
1258     /**
1259      * @dev See {IERC721-approve}.
1260      */
1261     function approve(address to, uint256 tokenId) public override {
1262         address owner = ERC721A.ownerOf(tokenId);
1263         if (to == owner) revert ApprovalToCurrentOwner();
1264 
1265         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1266             revert ApprovalCallerNotOwnerNorApproved();
1267         }
1268 
1269         _approve(to, tokenId, owner);
1270     }
1271 
1272     /**
1273      * @dev See {IERC721-getApproved}.
1274      */
1275     function getApproved(uint256 tokenId) public view override returns (address) {
1276         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1277 
1278         return _tokenApprovals[tokenId];
1279     }
1280 
1281     /**
1282      * @dev See {IERC721-setApprovalForAll}.
1283      */
1284     function setApprovalForAll(address operator, bool approved) public override {
1285         if (operator == _msgSender()) revert ApproveToCaller();
1286 
1287         _operatorApprovals[_msgSender()][operator] = approved;
1288         emit ApprovalForAll(_msgSender(), operator, approved);
1289     }
1290 
1291     /**
1292      * @dev See {IERC721-isApprovedForAll}.
1293      */
1294     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1295         return _operatorApprovals[owner][operator];
1296     }
1297 
1298     /**
1299      * @dev See {IERC721-transferFrom}.
1300      */
1301     function transferFrom(
1302         address from,
1303         address to,
1304         uint256 tokenId
1305     ) public virtual override {
1306         _transfer(from, to, tokenId);
1307     }
1308 
1309     /**
1310      * @dev See {IERC721-safeTransferFrom}.
1311      */
1312     function safeTransferFrom(
1313         address from,
1314         address to,
1315         uint256 tokenId
1316     ) public virtual override {
1317         safeTransferFrom(from, to, tokenId, '');
1318     }
1319 
1320     /**
1321      * @dev See {IERC721-safeTransferFrom}.
1322      */
1323     function safeTransferFrom(
1324         address from,
1325         address to,
1326         uint256 tokenId,
1327         bytes memory _data
1328     ) public virtual override {
1329         _transfer(from, to, tokenId);
1330         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1331             revert TransferToNonERC721ReceiverImplementer();
1332         }
1333     }
1334 
1335     /**
1336      * @dev Returns whether `tokenId` exists.
1337      *
1338      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1339      *
1340      * Tokens start existing when they are minted (`_mint`),
1341      */
1342     function _exists(uint256 tokenId) internal view returns (bool) {
1343         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1344     }
1345 
1346     function _safeMint(address to, uint256 quantity) internal {
1347         _safeMint(to, quantity, '');
1348     }
1349 
1350     /**
1351      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1352      *
1353      * Requirements:
1354      *
1355      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1356      * - `quantity` must be greater than 0.
1357      *
1358      * Emits a {Transfer} event.
1359      */
1360     function _safeMint(
1361         address to,
1362         uint256 quantity,
1363         bytes memory _data
1364     ) internal {
1365         _mint(to, quantity, _data, true);
1366     }
1367 
1368     /**
1369      * @dev Mints `quantity` tokens and transfers them to `to`.
1370      *
1371      * Requirements:
1372      *
1373      * - `to` cannot be the zero address.
1374      * - `quantity` must be greater than 0.
1375      *
1376      * Emits a {Transfer} event.
1377      */
1378     function _mint(
1379         address to,
1380         uint256 quantity,
1381         bytes memory _data,
1382         bool safe
1383     ) internal {
1384         uint256 startTokenId = _currentIndex;
1385         if (to == address(0)) revert MintToZeroAddress();
1386         if (quantity == 0) revert MintZeroQuantity();
1387 
1388         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1389 
1390         // Overflows are incredibly unrealistic.
1391         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1392         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1393         unchecked {
1394             _addressData[to].balance += uint64(quantity);
1395             _addressData[to].numberMinted += uint64(quantity);
1396 
1397             _ownerships[startTokenId].addr = to;
1398             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1399 
1400             uint256 updatedIndex = startTokenId;
1401 
1402             for (uint256 i; i < quantity; i++) {
1403                 emit Transfer(address(0), to, updatedIndex);
1404                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1405                     revert TransferToNonERC721ReceiverImplementer();
1406                 }
1407                 updatedIndex++;
1408             }
1409 
1410             _currentIndex = updatedIndex;
1411         }
1412         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1413     }
1414 
1415     /**
1416      * @dev Transfers `tokenId` from `from` to `to`.
1417      *
1418      * Requirements:
1419      *
1420      * - `to` cannot be the zero address.
1421      * - `tokenId` token must be owned by `from`.
1422      *
1423      * Emits a {Transfer} event.
1424      */
1425     function _transfer(
1426         address from,
1427         address to,
1428         uint256 tokenId
1429     ) private {
1430         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1431 
1432         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1433             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1434             getApproved(tokenId) == _msgSender());
1435 
1436         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1437         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1438         if (to == address(0)) revert TransferToZeroAddress();
1439 
1440         _beforeTokenTransfers(from, to, tokenId, 1);
1441 
1442         // Clear approvals from the previous owner
1443         _approve(address(0), tokenId, prevOwnership.addr);
1444 
1445         // Underflow of the sender's balance is impossible because we check for
1446         // ownership above and the recipient's balance can't realistically overflow.
1447         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1448         unchecked {
1449             _addressData[from].balance -= 1;
1450             _addressData[to].balance += 1;
1451 
1452             _ownerships[tokenId].addr = to;
1453             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1454 
1455             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1456             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1457             uint256 nextTokenId = tokenId + 1;
1458             if (_ownerships[nextTokenId].addr == address(0)) {
1459                 // This will suffice for checking _exists(nextTokenId),
1460                 // as a burned slot cannot contain the zero address.
1461                 if (nextTokenId < _currentIndex) {
1462                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1463                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1464                 }
1465             }
1466         }
1467 
1468         emit Transfer(from, to, tokenId);
1469         _afterTokenTransfers(from, to, tokenId, 1);
1470     }
1471 
1472     /**
1473      * @dev Destroys `tokenId`.
1474      * The approval is cleared when the token is burned.
1475      *
1476      * Requirements:
1477      *
1478      * - `tokenId` must exist.
1479      *
1480      * Emits a {Transfer} event.
1481      */
1482     function _burn(uint256 tokenId) internal virtual {
1483         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1484 
1485         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1486 
1487         // Clear approvals from the previous owner
1488         _approve(address(0), tokenId, prevOwnership.addr);
1489 
1490         // Underflow of the sender's balance is impossible because we check for
1491         // ownership above and the recipient's balance can't realistically overflow.
1492         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1493         unchecked {
1494             _addressData[prevOwnership.addr].balance -= 1;
1495             _addressData[prevOwnership.addr].numberBurned += 1;
1496 
1497             // Keep track of who burned the token, and the timestamp of burning.
1498             _ownerships[tokenId].addr = prevOwnership.addr;
1499             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1500             _ownerships[tokenId].burned = true;
1501 
1502             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1503             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1504             uint256 nextTokenId = tokenId + 1;
1505             if (_ownerships[nextTokenId].addr == address(0)) {
1506                 // This will suffice for checking _exists(nextTokenId),
1507                 // as a burned slot cannot contain the zero address.
1508                 if (nextTokenId < _currentIndex) {
1509                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1510                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1511                 }
1512             }
1513         }
1514 
1515         emit Transfer(prevOwnership.addr, address(0), tokenId);
1516         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1517 
1518         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1519         unchecked { 
1520             _burnCounter++;
1521         }
1522     }
1523 
1524     /**
1525      * @dev Approve `to` to operate on `tokenId`
1526      *
1527      * Emits a {Approval} event.
1528      */
1529     function _approve(
1530         address to,
1531         uint256 tokenId,
1532         address owner
1533     ) private {
1534         _tokenApprovals[tokenId] = to;
1535         emit Approval(owner, to, tokenId);
1536     }
1537 
1538     /**
1539      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1540      * The call is not executed if the target address is not a contract.
1541      *
1542      * @param from address representing the previous owner of the given token ID
1543      * @param to target address that will receive the tokens
1544      * @param tokenId uint256 ID of the token to be transferred
1545      * @param _data bytes optional data to send along with the call
1546      * @return bool whether the call correctly returned the expected magic value
1547      */
1548     function _checkOnERC721Received(
1549         address from,
1550         address to,
1551         uint256 tokenId,
1552         bytes memory _data
1553     ) private returns (bool) {
1554         if (to.isContract()) {
1555             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1556                 return retval == IERC721Receiver(to).onERC721Received.selector;
1557             } catch (bytes memory reason) {
1558                 if (reason.length == 0) {
1559                     revert TransferToNonERC721ReceiverImplementer();
1560                 } else {
1561                     assembly {
1562                         revert(add(32, reason), mload(reason))
1563                     }
1564                 }
1565             }
1566         } else {
1567             return true;
1568         }
1569     }
1570 
1571     /**
1572      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1573      * And also called before burning one token.
1574      *
1575      * startTokenId - the first token id to be transferred
1576      * quantity - the amount to be transferred
1577      *
1578      * Calling conditions:
1579      *
1580      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1581      * transferred to `to`.
1582      * - When `from` is zero, `tokenId` will be minted for `to`.
1583      * - When `to` is zero, `tokenId` will be burned by `from`.
1584      * - `from` and `to` are never both zero.
1585      */
1586     function _beforeTokenTransfers(
1587         address from,
1588         address to,
1589         uint256 startTokenId,
1590         uint256 quantity
1591     ) internal virtual {}
1592 
1593     /**
1594      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1595      * minting.
1596      * And also called after one token has been burned.
1597      *
1598      * startTokenId - the first token id to be transferred
1599      * quantity - the amount to be transferred
1600      *
1601      * Calling conditions:
1602      *
1603      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1604      * transferred to `to`.
1605      * - When `from` is zero, `tokenId` has been minted for `to`.
1606      * - When `to` is zero, `tokenId` has been burned by `from`.
1607      * - `from` and `to` are never both zero.
1608      */
1609     function _afterTokenTransfers(
1610         address from,
1611         address to,
1612         uint256 startTokenId,
1613         uint256 quantity
1614     ) internal virtual {}
1615 }
1616 
1617 
1618 pragma solidity ^0.8.7;
1619 
1620 contract FSD_NFT is ERC721A, Ownable {
1621     using Strings for uint256;
1622     
1623     uint256 public MAX_SUPPLY = 2420;
1624 
1625     string private BASE_URI;
1626     string private UNREVEAL_URI;
1627     bytes32 private FREELIST_ROOT;
1628     bytes32 private WHITELIST_ROOT;
1629 
1630     uint256 public COST = 0.0482 ether;
1631     uint256 public WHITELIST_COST = 0.042 ether;
1632     
1633     mapping(address => uint256) public MAP_FREE_MINTED;
1634     mapping(address => uint256) public MAP_WHITELIST_MINTED;
1635 
1636     uint256 public SALE_STATUS = 0; // 1 : Free 2: Whitelist 3: Public 0: None
1637 
1638 
1639     struct UserRewardInfo {
1640         uint256 rewards;
1641         uint256 lastUpdated;
1642         uint256 stakedBalance;
1643     }
1644     mapping(address => UserRewardInfo) public MAP_USER_REWARD_INFO;
1645     mapping(uint256 => bool) public MAP_STAKED_TOKEN;
1646     
1647     IERC20 public REWARD_TOKEN;
1648     uint256 public DAILY_REWARD_AMOUNT = 0.42 ether;
1649 
1650 
1651     constructor() ERC721A("Female Stoned Ducks", "FSD") {}
1652 
1653     function setRewardToken(address _tokenAddress) public onlyOwner {
1654         REWARD_TOKEN = IERC20(_tokenAddress);
1655     }
1656 
1657     function setDailyRewardAmount(uint256 _dailyReward) public onlyOwner {
1658         DAILY_REWARD_AMOUNT = _dailyReward;
1659     }
1660 
1661     function setWhitelistRoot(bytes32 _root) public onlyOwner {
1662         WHITELIST_ROOT = _root;
1663     }
1664 
1665     function setFreelistRoot(bytes32 _root) public onlyOwner {
1666         FREELIST_ROOT = _root;
1667     }
1668 
1669     // Verify that a given leaf is in the tree.
1670     function isFreeListed(bytes32 _leafNode, bytes32[] memory _proof) public view returns (bool) {
1671         return MerkleProof.verify(_proof, FREELIST_ROOT, _leafNode);
1672     }
1673 
1674     function isWhiteListed(bytes32 _leafNode, bytes32[] memory _proof) public view returns (bool) {
1675         return MerkleProof.verify(_proof, WHITELIST_ROOT, _leafNode);
1676     }
1677 
1678     // Generate the leaf node (just the hash of tokenID concatenated with the account address)
1679     function toLeaf(address account, uint256 index, uint256 amount) public pure returns (bytes32) {
1680         return keccak256(abi.encodePacked(index, account, amount));
1681     }
1682 
1683     function numberMinted(address _owner) public view returns (uint256) {
1684         return _numberMinted(_owner);
1685     }
1686 
1687     function mintFreelist(uint256 _mintAmount, uint256 _index, uint256 _amount, bytes32[] calldata _proof) external {
1688         require(SALE_STATUS == 1, "Free mint is not opened");
1689 
1690         require(isFreeListed(toLeaf(msg.sender, _index, _amount), _proof), "Invalid proof");
1691         
1692         require(totalSupply() + _mintAmount <= MAX_SUPPLY, "Exceeds Max Supply");
1693         
1694         require((MAP_FREE_MINTED[msg.sender] + _mintAmount) <= _amount, "Exceeds Max Mint Amount");
1695 
1696         //Mint
1697         _mintLoop(msg.sender, _mintAmount);
1698 
1699         MAP_FREE_MINTED[msg.sender] = MAP_FREE_MINTED[msg.sender] + _mintAmount;
1700     }
1701 
1702     function mintWhitelist(uint256 _mintAmount, uint256 _index, uint256 _amount, bytes32[] calldata _proof) external payable {
1703         require(SALE_STATUS == 2, "Whitelist sale is not opened");
1704 
1705         require(isWhiteListed(toLeaf(msg.sender, _index, _amount), _proof), "Invalid proof");
1706         
1707         require(totalSupply() + _mintAmount <= MAX_SUPPLY, "Exceeds Max Supply");
1708         
1709         require((MAP_WHITELIST_MINTED[msg.sender] + _mintAmount) <= _amount, "Exceeds Max Mint Amount");
1710 
1711         require(msg.value >= WHITELIST_COST * _mintAmount, "Insuffient funds");
1712 
1713         //Mint
1714         _mintLoop(msg.sender, _mintAmount);
1715 
1716         MAP_WHITELIST_MINTED[msg.sender] = MAP_WHITELIST_MINTED[msg.sender] + _mintAmount;
1717     }
1718 
1719     // public
1720     function mint(uint256 _mintAmount) external payable {
1721         require(SALE_STATUS == 3, "Public sale is not opened");
1722 
1723         require(totalSupply() + _mintAmount <= MAX_SUPPLY, "Exceeds Max Supply");
1724         
1725         require(msg.value >= COST * _mintAmount, "Insuffient funds");
1726 
1727         _mintLoop(msg.sender, _mintAmount);
1728     }
1729 
1730     function airdrop(address[] memory _airdropAddresses, uint256 _mintAmount) public onlyOwner {
1731         for (uint256 i = 0; i < _airdropAddresses.length; i++) {
1732             address to = _airdropAddresses[i];
1733             _mintLoop(to, _mintAmount);
1734         }
1735     }
1736 
1737     function _baseURI() internal view virtual override returns (string memory) {
1738         return BASE_URI;
1739     }
1740 
1741     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1742         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1743         string memory currentBaseURI = _baseURI();
1744         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString())) : UNREVEAL_URI;
1745     }
1746 
1747     function setCost(uint256 _newCost) public onlyOwner {
1748         COST = _newCost;
1749     }
1750 
1751     function setWhitelistCost(uint256 _newCost) public onlyOwner {
1752         WHITELIST_COST = _newCost;
1753     }
1754 
1755     function setMaxSupply(uint256 _supply) public onlyOwner {
1756         MAX_SUPPLY = _supply;
1757     }
1758 
1759     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1760         BASE_URI = _newBaseURI;
1761     }
1762 
1763     function setUnrevealURI(string memory _newUnrevealURI) public onlyOwner {
1764         UNREVEAL_URI = _newUnrevealURI;
1765     }
1766 
1767     function setSaleStatus(uint256 _status) public onlyOwner {
1768         SALE_STATUS = _status;
1769     }
1770 
1771     function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1772         _safeMint(_receiver, _mintAmount);
1773     }
1774 
1775     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1776         return ownershipOf(tokenId);
1777     }
1778 
1779     function tokensOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
1780         return tokensOfOwner(_owner)[_index];
1781     }
1782 
1783     function tokensOfOwner(address _owner) public view returns (uint256[] memory) {
1784         uint256 _tokenCount = balanceOf(_owner);
1785         uint256[] memory _tokenIds = new uint256[](_tokenCount);
1786         uint256 _tokenIndex = 0;
1787         for (uint256 i = 0; i < totalSupply(); i++) {
1788             if (ownerOf(i) == _owner) {
1789                 _tokenIds[_tokenIndex] = i;
1790                 _tokenIndex++;
1791             }
1792         }
1793         return _tokenIds;
1794     }
1795 
1796     function stakedTokensOfOwner(address _owner) public view returns (uint256[] memory) {
1797         uint256 _tokenCount = MAP_USER_REWARD_INFO[_owner].stakedBalance;
1798         uint256[] memory _tokenIds = new uint256[](_tokenCount);
1799         uint256 _tokenIndex = 0;
1800         for (uint256 i = 0; i < totalSupply(); i++) {
1801             if (ownerOf(i) == _owner && MAP_STAKED_TOKEN[i] == true) {
1802                 _tokenIds[_tokenIndex] = i;
1803                 _tokenIndex++;
1804             }
1805         }
1806         return _tokenIds;
1807     }
1808 
1809     function totalStakedCount() public view returns (uint256) {
1810         uint256 _totalCount = 0;
1811         for (uint256 i = 0; i < totalSupply(); i++) {
1812             if (MAP_STAKED_TOKEN[i] == true) {
1813                 _totalCount++;
1814             }
1815         }
1816         return _totalCount;
1817     }
1818 
1819     function earned(address account) public view returns (uint256) {
1820         uint256 blockTime = block.timestamp;
1821 
1822         UserRewardInfo memory user = MAP_USER_REWARD_INFO[account];
1823 
1824         uint256 amount = (blockTime - user.lastUpdated) * user.stakedBalance * DAILY_REWARD_AMOUNT / (1 days);
1825         
1826         return user.rewards + amount;
1827     }
1828 
1829 
1830     function stake( uint256[] calldata _tokenIDList) external {
1831         UserRewardInfo storage user = MAP_USER_REWARD_INFO[_msgSender()];
1832         user.rewards = earned(_msgSender());
1833         user.lastUpdated = block.timestamp;
1834 
1835         uint256 newStakedCount = 0;
1836         for (uint256 i = 0; i < _tokenIDList.length; i++) {
1837             if (ownerOf(_tokenIDList[i]) == _msgSender() && MAP_STAKED_TOKEN[_tokenIDList[i]] == false) {
1838                 newStakedCount++;
1839                 MAP_STAKED_TOKEN[_tokenIDList[i]] = true;
1840             }
1841         }
1842 
1843         user.stakedBalance = user.stakedBalance + newStakedCount;
1844     }
1845 
1846     function harvest() external {
1847         UserRewardInfo storage user = MAP_USER_REWARD_INFO[_msgSender()];
1848         user.rewards = earned(_msgSender());
1849         user.lastUpdated = block.timestamp;
1850 
1851         require(REWARD_TOKEN.balanceOf(address(this)) >= user.rewards,"Reward token amount is small");
1852 
1853         if (user.rewards > 0) {
1854             REWARD_TOKEN.transfer(_msgSender(), user.rewards);
1855         }
1856 
1857         user.rewards = 0;
1858     }
1859 
1860     function _beforeTokenTransfers(address from,address to,uint256 startTokenId,uint256 quantity) internal virtual override {
1861         super._beforeTokenTransfers(from, to, startTokenId, quantity);
1862         if (from != address(0) && MAP_STAKED_TOKEN[startTokenId] == true) {
1863             UserRewardInfo storage fromUser = MAP_USER_REWARD_INFO[from];
1864             UserRewardInfo storage toUser = MAP_USER_REWARD_INFO[to];
1865 
1866             fromUser.rewards = earned(from);
1867             fromUser.lastUpdated = block.timestamp;
1868             fromUser.stakedBalance = fromUser.stakedBalance - 1;
1869 
1870             toUser.rewards = earned(to);
1871             toUser.lastUpdated = block.timestamp;
1872             toUser.stakedBalance = toUser.stakedBalance + 1;
1873         }
1874     }
1875 
1876     function withdraw() public onlyOwner {
1877         uint256 balance = address(this).balance;
1878         payable(msg.sender).transfer(balance);
1879     }
1880 
1881     function withdrawToken() public onlyOwner {
1882         REWARD_TOKEN.transfer(msg.sender, REWARD_TOKEN.balanceOf(address(this)));
1883     }
1884 }