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
117 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
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
184      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
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
410 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
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
440      * @dev Returns the address of the current owner.
441      */
442     function owner() public view virtual returns (address) {
443         return _owner;
444     }
445 
446     /**
447      * @dev Throws if called by any account other than the owner.
448      */
449     modifier onlyOwner() {
450         require(owner() == _msgSender(), "Ownable: caller is not the owner");
451         _;
452     }
453 
454     /**
455      * @dev Leaves the contract without owner. It will not be possible to call
456      * `onlyOwner` functions anymore. Can only be called by the current owner.
457      *
458      * NOTE: Renouncing ownership will leave the contract without an owner,
459      * thereby removing any functionality that is only available to the owner.
460      */
461     function renounceOwnership() public virtual onlyOwner {
462         _transferOwnership(address(0));
463     }
464 
465     /**
466      * @dev Transfers ownership of the contract to a new account (`newOwner`).
467      * Can only be called by the current owner.
468      */
469     function transferOwnership(address newOwner) public virtual onlyOwner {
470         require(newOwner != address(0), "Ownable: new owner is the zero address");
471         _transferOwnership(newOwner);
472     }
473 
474     /**
475      * @dev Transfers ownership of the contract to a new account (`newOwner`).
476      * Internal function without access restriction.
477      */
478     function _transferOwnership(address newOwner) internal virtual {
479         address oldOwner = _owner;
480         _owner = newOwner;
481         emit OwnershipTransferred(oldOwner, newOwner);
482     }
483 }
484 
485 // File: @openzeppelin/contracts/utils/Address.sol
486 
487 
488 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
489 
490 pragma solidity ^0.8.1;
491 
492 /**
493  * @dev Collection of functions related to the address type
494  */
495 library Address {
496     /**
497      * @dev Returns true if `account` is a contract.
498      *
499      * [IMPORTANT]
500      * ====
501      * It is unsafe to assume that an address for which this function returns
502      * false is an externally-owned account (EOA) and not a contract.
503      *
504      * Among others, `isContract` will return false for the following
505      * types of addresses:
506      *
507      *  - an externally-owned account
508      *  - a contract in construction
509      *  - an address where a contract will be created
510      *  - an address where a contract lived, but was destroyed
511      * ====
512      *
513      * [IMPORTANT]
514      * ====
515      * You shouldn't rely on `isContract` to protect against flash loan attacks!
516      *
517      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
518      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
519      * constructor.
520      * ====
521      */
522     function isContract(address account) internal view returns (bool) {
523         // This method relies on extcodesize/address.code.length, which returns 0
524         // for contracts in construction, since the code is only stored at the end
525         // of the constructor execution.
526 
527         return account.code.length > 0;
528     }
529 
530     /**
531      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
532      * `recipient`, forwarding all available gas and reverting on errors.
533      *
534      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
535      * of certain opcodes, possibly making contracts go over the 2300 gas limit
536      * imposed by `transfer`, making them unable to receive funds via
537      * `transfer`. {sendValue} removes this limitation.
538      *
539      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
540      *
541      * IMPORTANT: because control is transferred to `recipient`, care must be
542      * taken to not create reentrancy vulnerabilities. Consider using
543      * {ReentrancyGuard} or the
544      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
545      */
546     function sendValue(address payable recipient, uint256 amount) internal {
547         require(address(this).balance >= amount, "Address: insufficient balance");
548 
549         (bool success, ) = recipient.call{value: amount}("");
550         require(success, "Address: unable to send value, recipient may have reverted");
551     }
552 
553     /**
554      * @dev Performs a Solidity function call using a low level `call`. A
555      * plain `call` is an unsafe replacement for a function call: use this
556      * function instead.
557      *
558      * If `target` reverts with a revert reason, it is bubbled up by this
559      * function (like regular Solidity function calls).
560      *
561      * Returns the raw returned data. To convert to the expected return value,
562      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
563      *
564      * Requirements:
565      *
566      * - `target` must be a contract.
567      * - calling `target` with `data` must not revert.
568      *
569      * _Available since v3.1._
570      */
571     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
572         return functionCall(target, data, "Address: low-level call failed");
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
577      * `errorMessage` as a fallback revert reason when `target` reverts.
578      *
579      * _Available since v3.1._
580      */
581     function functionCall(
582         address target,
583         bytes memory data,
584         string memory errorMessage
585     ) internal returns (bytes memory) {
586         return functionCallWithValue(target, data, 0, errorMessage);
587     }
588 
589     /**
590      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
591      * but also transferring `value` wei to `target`.
592      *
593      * Requirements:
594      *
595      * - the calling contract must have an ETH balance of at least `value`.
596      * - the called Solidity function must be `payable`.
597      *
598      * _Available since v3.1._
599      */
600     function functionCallWithValue(
601         address target,
602         bytes memory data,
603         uint256 value
604     ) internal returns (bytes memory) {
605         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
606     }
607 
608     /**
609      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
610      * with `errorMessage` as a fallback revert reason when `target` reverts.
611      *
612      * _Available since v3.1._
613      */
614     function functionCallWithValue(
615         address target,
616         bytes memory data,
617         uint256 value,
618         string memory errorMessage
619     ) internal returns (bytes memory) {
620         require(address(this).balance >= value, "Address: insufficient balance for call");
621         require(isContract(target), "Address: call to non-contract");
622 
623         (bool success, bytes memory returndata) = target.call{value: value}(data);
624         return verifyCallResult(success, returndata, errorMessage);
625     }
626 
627     /**
628      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
629      * but performing a static call.
630      *
631      * _Available since v3.3._
632      */
633     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
634         return functionStaticCall(target, data, "Address: low-level static call failed");
635     }
636 
637     /**
638      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
639      * but performing a static call.
640      *
641      * _Available since v3.3._
642      */
643     function functionStaticCall(
644         address target,
645         bytes memory data,
646         string memory errorMessage
647     ) internal view returns (bytes memory) {
648         require(isContract(target), "Address: static call to non-contract");
649 
650         (bool success, bytes memory returndata) = target.staticcall(data);
651         return verifyCallResult(success, returndata, errorMessage);
652     }
653 
654     /**
655      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
656      * but performing a delegate call.
657      *
658      * _Available since v3.4._
659      */
660     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
661         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
662     }
663 
664     /**
665      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
666      * but performing a delegate call.
667      *
668      * _Available since v3.4._
669      */
670     function functionDelegateCall(
671         address target,
672         bytes memory data,
673         string memory errorMessage
674     ) internal returns (bytes memory) {
675         require(isContract(target), "Address: delegate call to non-contract");
676 
677         (bool success, bytes memory returndata) = target.delegatecall(data);
678         return verifyCallResult(success, returndata, errorMessage);
679     }
680 
681     /**
682      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
683      * revert reason using the provided one.
684      *
685      * _Available since v4.3._
686      */
687     function verifyCallResult(
688         bool success,
689         bytes memory returndata,
690         string memory errorMessage
691     ) internal pure returns (bytes memory) {
692         if (success) {
693             return returndata;
694         } else {
695             // Look for revert reason and bubble it up if present
696             if (returndata.length > 0) {
697                 // The easiest way to bubble the revert reason is using memory via assembly
698 
699                 assembly {
700                     let returndata_size := mload(returndata)
701                     revert(add(32, returndata), returndata_size)
702                 }
703             } else {
704                 revert(errorMessage);
705             }
706         }
707     }
708 }
709 
710 // File: @openzeppelin/contracts/utils/Strings.sol
711 
712 
713 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
714 
715 pragma solidity ^0.8.0;
716 
717 /**
718  * @dev String operations.
719  */
720 library Strings {
721     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
722 
723     /**
724      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
725      */
726     function toString(uint256 value) internal pure returns (string memory) {
727         // Inspired by OraclizeAPI's implementation - MIT licence
728         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
729 
730         if (value == 0) {
731             return "0";
732         }
733         uint256 temp = value;
734         uint256 digits;
735         while (temp != 0) {
736             digits++;
737             temp /= 10;
738         }
739         bytes memory buffer = new bytes(digits);
740         while (value != 0) {
741             digits -= 1;
742             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
743             value /= 10;
744         }
745         return string(buffer);
746     }
747 
748     /**
749      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
750      */
751     function toHexString(uint256 value) internal pure returns (string memory) {
752         if (value == 0) {
753             return "0x00";
754         }
755         uint256 temp = value;
756         uint256 length = 0;
757         while (temp != 0) {
758             length++;
759             temp >>= 8;
760         }
761         return toHexString(value, length);
762     }
763 
764     /**
765      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
766      */
767     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
768         bytes memory buffer = new bytes(2 * length + 2);
769         buffer[0] = "0";
770         buffer[1] = "x";
771         for (uint256 i = 2 * length + 1; i > 1; --i) {
772             buffer[i] = _HEX_SYMBOLS[value & 0xf];
773             value >>= 4;
774         }
775         require(value == 0, "Strings: hex length insufficient");
776         return string(buffer);
777     }
778 }
779 
780 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
781 
782 
783 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
784 
785 pragma solidity ^0.8.0;
786 
787 /**
788  * @dev These functions deal with verification of Merkle Trees proofs.
789  *
790  * The proofs can be generated using the JavaScript library
791  * https://github.com/miguelmota/merkletreejs[merkletreejs].
792  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
793  *
794  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
795  *
796  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
797  * hashing, or use a hash function other than keccak256 for hashing leaves.
798  * This is because the concatenation of a sorted pair of internal nodes in
799  * the merkle tree could be reinterpreted as a leaf value.
800  */
801 library MerkleProof {
802     /**
803      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
804      * defined by `root`. For this, a `proof` must be provided, containing
805      * sibling hashes on the branch from the leaf to the root of the tree. Each
806      * pair of leaves and each pair of pre-images are assumed to be sorted.
807      */
808     function verify(
809         bytes32[] memory proof,
810         bytes32 root,
811         bytes32 leaf
812     ) internal pure returns (bool) {
813         return processProof(proof, leaf) == root;
814     }
815 
816     /**
817      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
818      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
819      * hash matches the root of the tree. When processing the proof, the pairs
820      * of leafs & pre-images are assumed to be sorted.
821      *
822      * _Available since v4.4._
823      */
824     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
825         bytes32 computedHash = leaf;
826         for (uint256 i = 0; i < proof.length; i++) {
827             bytes32 proofElement = proof[i];
828             if (computedHash <= proofElement) {
829                 // Hash(current computed hash + current element of the proof)
830                 computedHash = _efficientHash(computedHash, proofElement);
831             } else {
832                 // Hash(current element of the proof + current computed hash)
833                 computedHash = _efficientHash(proofElement, computedHash);
834             }
835         }
836         return computedHash;
837     }
838 
839     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
840         assembly {
841             mstore(0x00, a)
842             mstore(0x20, b)
843             value := keccak256(0x00, 0x40)
844         }
845     }
846 }
847 
848 // File: contracts/SDLC_NFT.sol
849 
850 
851 
852 
853 
854 
855 
856 
857 
858 
859 
860 
861 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
862 
863 
864 // Creator: Chiru Labs
865 
866 pragma solidity ^0.8.4;
867 
868 
869 
870 
871 
872 
873 
874 
875 
876 error ApprovalCallerNotOwnerNorApproved();
877 error ApprovalQueryForNonexistentToken();
878 error ApproveToCaller();
879 error ApprovalToCurrentOwner();
880 error BalanceQueryForZeroAddress();
881 error MintedQueryForZeroAddress();
882 error BurnedQueryForZeroAddress();
883 error AuxQueryForZeroAddress();
884 error MintToZeroAddress();
885 error MintZeroQuantity();
886 error OwnerIndexOutOfBounds();
887 error OwnerQueryForNonexistentToken();
888 error TokenIndexOutOfBounds();
889 error TransferCallerNotOwnerNorApproved();
890 error TransferFromIncorrectOwner();
891 error TransferToNonERC721ReceiverImplementer();
892 error TransferToZeroAddress();
893 error URIQueryForNonexistentToken();
894 
895 /**
896  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
897  * the Metadata extension. Built to optimize for lower gas during batch mints.
898  *
899  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
900  *
901  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
902  *
903  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
904  */
905 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
906     using Address for address;
907     using Strings for uint256;
908 
909     // Compiler will pack this into a single 256bit word.
910     struct TokenOwnership {
911         // The address of the owner.
912         address addr;
913         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
914         uint64 startTimestamp;
915         // Whether the token has been burned.
916         bool burned;
917     }
918 
919     // Compiler will pack this into a single 256bit word.
920     struct AddressData {
921         // Realistically, 2**64-1 is more than enough.
922         uint64 balance;
923         // Keeps track of mint count with minimal overhead for tokenomics.
924         uint64 numberMinted;
925         // Keeps track of burn count with minimal overhead for tokenomics.
926         uint64 numberBurned;
927         // For miscellaneous variable(s) pertaining to the address
928         // (e.g. number of whitelist mint slots used). 
929         // If there are multiple variables, please pack them into a uint64.
930         uint64 aux;
931     }
932 
933     // The tokenId of the next token to be minted.
934     uint256 internal _currentIndex;
935 
936     // The number of tokens burned.
937     uint256 internal _burnCounter;
938 
939     // Token name
940     string private _name;
941 
942     // Token symbol
943     string private _symbol;
944 
945     // Mapping from token ID to ownership details
946     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
947     mapping(uint256 => TokenOwnership) internal _ownerships;
948 
949     // Mapping owner address to address data
950     mapping(address => AddressData) private _addressData;
951 
952     // Mapping from token ID to approved address
953     mapping(uint256 => address) private _tokenApprovals;
954 
955     // Mapping from owner to operator approvals
956     mapping(address => mapping(address => bool)) private _operatorApprovals;
957 
958     constructor(string memory name_, string memory symbol_) {
959         _name = name_;
960         _symbol = symbol_;
961     }
962 
963     /**
964      * @dev See {IERC721Enumerable-totalSupply}.
965      */
966     function totalSupply() public view returns (uint256) {
967         // Counter underflow is impossible as _burnCounter cannot be incremented
968         // more than _currentIndex times
969         unchecked {
970             return _currentIndex - _burnCounter;    
971         }
972     }
973 
974     /**
975      * @dev See {IERC165-supportsInterface}.
976      */
977     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
978         return
979             interfaceId == type(IERC721).interfaceId ||
980             interfaceId == type(IERC721Metadata).interfaceId ||
981             super.supportsInterface(interfaceId);
982     }
983 
984     /**
985      * @dev See {IERC721-balanceOf}.
986      */
987     function balanceOf(address owner) public view override returns (uint256) {
988         if (owner == address(0)) revert BalanceQueryForZeroAddress();
989         return uint256(_addressData[owner].balance);
990     }
991 
992     /**
993      * Returns the number of tokens minted by `owner`.
994      */
995     function _numberMinted(address owner) internal view returns (uint256) {
996         if (owner == address(0)) revert MintedQueryForZeroAddress();
997         return uint256(_addressData[owner].numberMinted);
998     }
999 
1000     /**
1001      * Returns the number of tokens burned by or on behalf of `owner`.
1002      */
1003     function _numberBurned(address owner) internal view returns (uint256) {
1004         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1005         return uint256(_addressData[owner].numberBurned);
1006     }
1007 
1008     /**
1009      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1010      */
1011     function _getAux(address owner) internal view returns (uint64) {
1012         if (owner == address(0)) revert AuxQueryForZeroAddress();
1013         return _addressData[owner].aux;
1014     }
1015 
1016     /**
1017      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1018      * If there are multiple variables, please pack them into a uint64.
1019      */
1020     function _setAux(address owner, uint64 aux) internal {
1021         if (owner == address(0)) revert AuxQueryForZeroAddress();
1022         _addressData[owner].aux = aux;
1023     }
1024 
1025     /**
1026      * Gas spent here starts off proportional to the maximum mint batch size.
1027      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1028      */
1029     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1030         uint256 curr = tokenId;
1031 
1032         unchecked {
1033             if (curr < _currentIndex) {
1034                 TokenOwnership memory ownership = _ownerships[curr];
1035                 if (!ownership.burned) {
1036                     if (ownership.addr != address(0)) {
1037                         return ownership;
1038                     }
1039                     // Invariant: 
1040                     // There will always be an ownership that has an address and is not burned 
1041                     // before an ownership that does not have an address and is not burned.
1042                     // Hence, curr will not underflow.
1043                     while (true) {
1044                         curr--;
1045                         ownership = _ownerships[curr];
1046                         if (ownership.addr != address(0)) {
1047                             return ownership;
1048                         }
1049                     }
1050                 }
1051             }
1052         }
1053         revert OwnerQueryForNonexistentToken();
1054     }
1055 
1056     /**
1057      * @dev See {IERC721-ownerOf}.
1058      */
1059     function ownerOf(uint256 tokenId) public view override returns (address) {
1060         return ownershipOf(tokenId).addr;
1061     }
1062 
1063     /**
1064      * @dev See {IERC721Metadata-name}.
1065      */
1066     function name() public view virtual override returns (string memory) {
1067         return _name;
1068     }
1069 
1070     /**
1071      * @dev See {IERC721Metadata-symbol}.
1072      */
1073     function symbol() public view virtual override returns (string memory) {
1074         return _symbol;
1075     }
1076 
1077     /**
1078      * @dev See {IERC721Metadata-tokenURI}.
1079      */
1080     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1081         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1082 
1083         string memory baseURI = _baseURI();
1084         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1085     }
1086 
1087     /**
1088      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1089      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1090      * by default, can be overriden in child contracts.
1091      */
1092     function _baseURI() internal view virtual returns (string memory) {
1093         return '';
1094     }
1095 
1096     /**
1097      * @dev See {IERC721-approve}.
1098      */
1099     function approve(address to, uint256 tokenId) public override {
1100         address owner = ERC721A.ownerOf(tokenId);
1101         if (to == owner) revert ApprovalToCurrentOwner();
1102 
1103         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1104             revert ApprovalCallerNotOwnerNorApproved();
1105         }
1106 
1107         _approve(to, tokenId, owner);
1108     }
1109 
1110     /**
1111      * @dev See {IERC721-getApproved}.
1112      */
1113     function getApproved(uint256 tokenId) public view override returns (address) {
1114         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1115 
1116         return _tokenApprovals[tokenId];
1117     }
1118 
1119     /**
1120      * @dev See {IERC721-setApprovalForAll}.
1121      */
1122     function setApprovalForAll(address operator, bool approved) public override {
1123         if (operator == _msgSender()) revert ApproveToCaller();
1124 
1125         _operatorApprovals[_msgSender()][operator] = approved;
1126         emit ApprovalForAll(_msgSender(), operator, approved);
1127     }
1128 
1129     /**
1130      * @dev See {IERC721-isApprovedForAll}.
1131      */
1132     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1133         return _operatorApprovals[owner][operator];
1134     }
1135 
1136     /**
1137      * @dev See {IERC721-transferFrom}.
1138      */
1139     function transferFrom(
1140         address from,
1141         address to,
1142         uint256 tokenId
1143     ) public virtual override {
1144         _transfer(from, to, tokenId);
1145     }
1146 
1147     /**
1148      * @dev See {IERC721-safeTransferFrom}.
1149      */
1150     function safeTransferFrom(
1151         address from,
1152         address to,
1153         uint256 tokenId
1154     ) public virtual override {
1155         safeTransferFrom(from, to, tokenId, '');
1156     }
1157 
1158     /**
1159      * @dev See {IERC721-safeTransferFrom}.
1160      */
1161     function safeTransferFrom(
1162         address from,
1163         address to,
1164         uint256 tokenId,
1165         bytes memory _data
1166     ) public virtual override {
1167         _transfer(from, to, tokenId);
1168         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1169             revert TransferToNonERC721ReceiverImplementer();
1170         }
1171     }
1172 
1173     /**
1174      * @dev Returns whether `tokenId` exists.
1175      *
1176      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1177      *
1178      * Tokens start existing when they are minted (`_mint`),
1179      */
1180     function _exists(uint256 tokenId) internal view returns (bool) {
1181         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1182     }
1183 
1184     function _safeMint(address to, uint256 quantity) internal {
1185         _safeMint(to, quantity, '');
1186     }
1187 
1188     /**
1189      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1190      *
1191      * Requirements:
1192      *
1193      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1194      * - `quantity` must be greater than 0.
1195      *
1196      * Emits a {Transfer} event.
1197      */
1198     function _safeMint(
1199         address to,
1200         uint256 quantity,
1201         bytes memory _data
1202     ) internal {
1203         _mint(to, quantity, _data, true);
1204     }
1205 
1206     /**
1207      * @dev Mints `quantity` tokens and transfers them to `to`.
1208      *
1209      * Requirements:
1210      *
1211      * - `to` cannot be the zero address.
1212      * - `quantity` must be greater than 0.
1213      *
1214      * Emits a {Transfer} event.
1215      */
1216     function _mint(
1217         address to,
1218         uint256 quantity,
1219         bytes memory _data,
1220         bool safe
1221     ) internal {
1222         uint256 startTokenId = _currentIndex;
1223         if (to == address(0)) revert MintToZeroAddress();
1224         if (quantity == 0) revert MintZeroQuantity();
1225 
1226         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1227 
1228         // Overflows are incredibly unrealistic.
1229         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1230         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1231         unchecked {
1232             _addressData[to].balance += uint64(quantity);
1233             _addressData[to].numberMinted += uint64(quantity);
1234 
1235             _ownerships[startTokenId].addr = to;
1236             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1237 
1238             uint256 updatedIndex = startTokenId;
1239 
1240             for (uint256 i; i < quantity; i++) {
1241                 emit Transfer(address(0), to, updatedIndex);
1242                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1243                     revert TransferToNonERC721ReceiverImplementer();
1244                 }
1245                 updatedIndex++;
1246             }
1247 
1248             _currentIndex = updatedIndex;
1249         }
1250         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1251     }
1252 
1253     /**
1254      * @dev Transfers `tokenId` from `from` to `to`.
1255      *
1256      * Requirements:
1257      *
1258      * - `to` cannot be the zero address.
1259      * - `tokenId` token must be owned by `from`.
1260      *
1261      * Emits a {Transfer} event.
1262      */
1263     function _transfer(
1264         address from,
1265         address to,
1266         uint256 tokenId
1267     ) private {
1268         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1269 
1270         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1271             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1272             getApproved(tokenId) == _msgSender());
1273 
1274         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1275         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1276         if (to == address(0)) revert TransferToZeroAddress();
1277 
1278         _beforeTokenTransfers(from, to, tokenId, 1);
1279 
1280         // Clear approvals from the previous owner
1281         _approve(address(0), tokenId, prevOwnership.addr);
1282 
1283         // Underflow of the sender's balance is impossible because we check for
1284         // ownership above and the recipient's balance can't realistically overflow.
1285         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1286         unchecked {
1287             _addressData[from].balance -= 1;
1288             _addressData[to].balance += 1;
1289 
1290             _ownerships[tokenId].addr = to;
1291             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1292 
1293             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1294             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1295             uint256 nextTokenId = tokenId + 1;
1296             if (_ownerships[nextTokenId].addr == address(0)) {
1297                 // This will suffice for checking _exists(nextTokenId),
1298                 // as a burned slot cannot contain the zero address.
1299                 if (nextTokenId < _currentIndex) {
1300                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1301                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1302                 }
1303             }
1304         }
1305 
1306         emit Transfer(from, to, tokenId);
1307         _afterTokenTransfers(from, to, tokenId, 1);
1308     }
1309 
1310     /**
1311      * @dev Destroys `tokenId`.
1312      * The approval is cleared when the token is burned.
1313      *
1314      * Requirements:
1315      *
1316      * - `tokenId` must exist.
1317      *
1318      * Emits a {Transfer} event.
1319      */
1320     function _burn(uint256 tokenId) internal virtual {
1321         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1322 
1323         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1324 
1325         // Clear approvals from the previous owner
1326         _approve(address(0), tokenId, prevOwnership.addr);
1327 
1328         // Underflow of the sender's balance is impossible because we check for
1329         // ownership above and the recipient's balance can't realistically overflow.
1330         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1331         unchecked {
1332             _addressData[prevOwnership.addr].balance -= 1;
1333             _addressData[prevOwnership.addr].numberBurned += 1;
1334 
1335             // Keep track of who burned the token, and the timestamp of burning.
1336             _ownerships[tokenId].addr = prevOwnership.addr;
1337             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1338             _ownerships[tokenId].burned = true;
1339 
1340             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1341             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1342             uint256 nextTokenId = tokenId + 1;
1343             if (_ownerships[nextTokenId].addr == address(0)) {
1344                 // This will suffice for checking _exists(nextTokenId),
1345                 // as a burned slot cannot contain the zero address.
1346                 if (nextTokenId < _currentIndex) {
1347                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1348                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1349                 }
1350             }
1351         }
1352 
1353         emit Transfer(prevOwnership.addr, address(0), tokenId);
1354         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1355 
1356         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1357         unchecked { 
1358             _burnCounter++;
1359         }
1360     }
1361 
1362     /**
1363      * @dev Approve `to` to operate on `tokenId`
1364      *
1365      * Emits a {Approval} event.
1366      */
1367     function _approve(
1368         address to,
1369         uint256 tokenId,
1370         address owner
1371     ) private {
1372         _tokenApprovals[tokenId] = to;
1373         emit Approval(owner, to, tokenId);
1374     }
1375 
1376     /**
1377      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1378      * The call is not executed if the target address is not a contract.
1379      *
1380      * @param from address representing the previous owner of the given token ID
1381      * @param to target address that will receive the tokens
1382      * @param tokenId uint256 ID of the token to be transferred
1383      * @param _data bytes optional data to send along with the call
1384      * @return bool whether the call correctly returned the expected magic value
1385      */
1386     function _checkOnERC721Received(
1387         address from,
1388         address to,
1389         uint256 tokenId,
1390         bytes memory _data
1391     ) private returns (bool) {
1392         if (to.isContract()) {
1393             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1394                 return retval == IERC721Receiver(to).onERC721Received.selector;
1395             } catch (bytes memory reason) {
1396                 if (reason.length == 0) {
1397                     revert TransferToNonERC721ReceiverImplementer();
1398                 } else {
1399                     assembly {
1400                         revert(add(32, reason), mload(reason))
1401                     }
1402                 }
1403             }
1404         } else {
1405             return true;
1406         }
1407     }
1408 
1409     /**
1410      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1411      * And also called before burning one token.
1412      *
1413      * startTokenId - the first token id to be transferred
1414      * quantity - the amount to be transferred
1415      *
1416      * Calling conditions:
1417      *
1418      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1419      * transferred to `to`.
1420      * - When `from` is zero, `tokenId` will be minted for `to`.
1421      * - When `to` is zero, `tokenId` will be burned by `from`.
1422      * - `from` and `to` are never both zero.
1423      */
1424     function _beforeTokenTransfers(
1425         address from,
1426         address to,
1427         uint256 startTokenId,
1428         uint256 quantity
1429     ) internal virtual {}
1430 
1431     /**
1432      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1433      * minting.
1434      * And also called after one token has been burned.
1435      *
1436      * startTokenId - the first token id to be transferred
1437      * quantity - the amount to be transferred
1438      *
1439      * Calling conditions:
1440      *
1441      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1442      * transferred to `to`.
1443      * - When `from` is zero, `tokenId` has been minted for `to`.
1444      * - When `to` is zero, `tokenId` has been burned by `from`.
1445      * - `from` and `to` are never both zero.
1446      */
1447     function _afterTokenTransfers(
1448         address from,
1449         address to,
1450         uint256 startTokenId,
1451         uint256 quantity
1452     ) internal virtual {}
1453 }
1454 
1455 
1456 pragma solidity ^0.8.7;
1457 
1458 contract SDLC_NFT is ERC721A, Ownable {
1459     using Strings for uint256;
1460     
1461     uint256 public MAX_SUPPLY = 5500;
1462 
1463     string private BASE_URI;
1464     string private UNREVEAL_URI;
1465     bytes32 private FREELIST_ROOT;
1466     bytes32 private WHITELIST_ROOT;
1467 
1468     uint256 public COST = 0.04 ether;
1469     uint256 public WHITELIST_COST = 0.03 ether;
1470     
1471     mapping(address => uint256) public MAP_FREE_MINTED;
1472     mapping(address => uint256) public MAP_WHITELIST_MINTED;
1473 
1474     uint256 public SALE_STATUS = 0; // 1 : Free 2: Whitelist 3: Public 0: None
1475 
1476 
1477     struct UserRewardInfo {
1478         uint256 rewards;
1479         uint256 lastUpdated;
1480         uint256 stakedBalance;
1481     }
1482     mapping(address => UserRewardInfo) public MAP_USER_REWARD_INFO;
1483     mapping(uint256 => bool) public MAP_STAKED_TOKEN;
1484     
1485     IERC20 public REWARD_TOKEN;
1486     uint256 public DAILY_REWARD_AMOUNT = 0.42 ether;
1487     uint256 public BONUS_STAKE_LIMIT = 10;
1488     uint256 public BONUS_PERCENT = 42;
1489 
1490 
1491     constructor() ERC721A("Stoned Duck Lifestyle Club", "SDLC") {}
1492 
1493     function setRewardToken(address _tokenAddress) public onlyOwner {
1494         REWARD_TOKEN = IERC20(_tokenAddress);
1495     }
1496 
1497     function setDailyRewardAmount(uint256 _dailyReward) public onlyOwner {
1498         DAILY_REWARD_AMOUNT = _dailyReward;
1499     }
1500 
1501     function setBonusReward(uint256 _stakeLimit, uint256 _bonusPercent) public onlyOwner {
1502         BONUS_STAKE_LIMIT = _stakeLimit;
1503         BONUS_PERCENT = _bonusPercent;
1504     }
1505 
1506     function setWhitelistRoot(bytes32 _root) public onlyOwner {
1507         WHITELIST_ROOT = _root;
1508     }
1509 
1510     function setFreelistRoot(bytes32 _root) public onlyOwner {
1511         FREELIST_ROOT = _root;
1512     }
1513 
1514     // Verify that a given leaf is in the tree.
1515     function isFreeListed(bytes32 _leafNode, bytes32[] memory _proof) public view returns (bool) {
1516         return MerkleProof.verify(_proof, FREELIST_ROOT, _leafNode);
1517     }
1518 
1519     function isWhiteListed(bytes32 _leafNode, bytes32[] memory _proof) public view returns (bool) {
1520         return MerkleProof.verify(_proof, WHITELIST_ROOT, _leafNode);
1521     }
1522 
1523     // Generate the leaf node (just the hash of tokenID concatenated with the account address)
1524     function toLeaf(address account, uint256 index, uint256 amount) public pure returns (bytes32) {
1525         return keccak256(abi.encodePacked(index, account, amount));
1526     }
1527 
1528     function numberMinted(address _owner) public view returns (uint256) {
1529         return _numberMinted(_owner);
1530     }
1531 
1532     function mintFreelist(uint256 _mintAmount, uint256 _index, uint256 _amount, bytes32[] calldata _proof) external {
1533         require(SALE_STATUS == 1, "Free mint is not opened");
1534 
1535         require(isFreeListed(toLeaf(msg.sender, _index, _amount), _proof), "Invalid proof");
1536         
1537         require(totalSupply() + _mintAmount <= MAX_SUPPLY, "Exceeds Max Supply");
1538         
1539         require((MAP_FREE_MINTED[msg.sender] + _mintAmount) <= _amount, "Exceeds Max Mint Amount");
1540 
1541         //Mint
1542         _mintLoop(msg.sender, _mintAmount);
1543 
1544         MAP_FREE_MINTED[msg.sender] = MAP_FREE_MINTED[msg.sender] + _mintAmount;
1545     }
1546 
1547     function mintWhitelist(uint256 _mintAmount, uint256 _index, uint256 _amount, bytes32[] calldata _proof) external payable {
1548         require(SALE_STATUS == 2, "Whitelist sale is not opened");
1549 
1550         require(isWhiteListed(toLeaf(msg.sender, _index, _amount), _proof), "Invalid proof");
1551         
1552         require(totalSupply() + _mintAmount <= MAX_SUPPLY, "Exceeds Max Supply");
1553         
1554         require((MAP_WHITELIST_MINTED[msg.sender] + _mintAmount) <= _amount, "Exceeds Max Mint Amount");
1555 
1556         require(msg.value >= WHITELIST_COST * _mintAmount, "Insuffient funds");
1557 
1558         //Mint
1559         _mintLoop(msg.sender, _mintAmount);
1560 
1561         MAP_WHITELIST_MINTED[msg.sender] = MAP_WHITELIST_MINTED[msg.sender] + _mintAmount;
1562     }
1563 
1564     // public
1565     function mint(uint256 _mintAmount) external payable {
1566         require(SALE_STATUS == 3, "Public sale is not opened");
1567 
1568         require(totalSupply() + _mintAmount <= MAX_SUPPLY, "Exceeds Max Supply");
1569         
1570         require(msg.value >= COST * _mintAmount, "Insuffient funds");
1571 
1572         _mintLoop(msg.sender, _mintAmount);
1573     }
1574 
1575     function airdrop(address[] memory _airdropAddresses, uint256 _mintAmount) public onlyOwner {
1576         for (uint256 i = 0; i < _airdropAddresses.length; i++) {
1577             address to = _airdropAddresses[i];
1578             _mintLoop(to, _mintAmount);
1579         }
1580     }
1581 
1582     function _baseURI() internal view virtual override returns (string memory) {
1583         return BASE_URI;
1584     }
1585 
1586     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1587         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1588         string memory currentBaseURI = _baseURI();
1589         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString())) : UNREVEAL_URI;
1590     }
1591 
1592     function setCost(uint256 _newCost) public onlyOwner {
1593         COST = _newCost;
1594     }
1595 
1596     function setWhitelistCost(uint256 _newCost) public onlyOwner {
1597         WHITELIST_COST = _newCost;
1598     }
1599 
1600     function setMaxSupply(uint256 _supply) public onlyOwner {
1601         MAX_SUPPLY = _supply;
1602     }
1603 
1604     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1605         BASE_URI = _newBaseURI;
1606     }
1607 
1608     function setUnrevealURI(string memory _newUnrevealURI) public onlyOwner {
1609         UNREVEAL_URI = _newUnrevealURI;
1610     }
1611 
1612     function setSaleStatus(uint256 _status) public onlyOwner {
1613         SALE_STATUS = _status;
1614     }
1615 
1616     function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1617         _safeMint(_receiver, _mintAmount);
1618     }
1619 
1620     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1621         return ownershipOf(tokenId);
1622     }
1623 
1624     function tokensOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
1625         return tokensOfOwner(_owner)[_index];
1626     }
1627 
1628     function tokensOfOwner(address _owner) public view returns (uint256[] memory) {
1629         uint256 _tokenCount = balanceOf(_owner);
1630         uint256[] memory _tokenIds = new uint256[](_tokenCount);
1631         uint256 _tokenIndex = 0;
1632         for (uint256 i = 0; i < totalSupply(); i++) {
1633             if (ownerOf(i) == _owner) {
1634                 _tokenIds[_tokenIndex] = i;
1635                 _tokenIndex++;
1636             }
1637         }
1638         return _tokenIds;
1639     }
1640 
1641     function stakedTokensOfOwner(address _owner) public view returns (uint256[] memory) {
1642         uint256 _tokenCount = MAP_USER_REWARD_INFO[_owner].stakedBalance;
1643         uint256[] memory _tokenIds = new uint256[](_tokenCount);
1644         uint256 _tokenIndex = 0;
1645         for (uint256 i = 0; i < totalSupply(); i++) {
1646             if (ownerOf(i) == _owner && MAP_STAKED_TOKEN[i] == true) {
1647                 _tokenIds[_tokenIndex] = i;
1648                 _tokenIndex++;
1649             }
1650         }
1651         return _tokenIds;
1652     }
1653 
1654     function totalStakedCount() public view returns (uint256) {
1655         uint256 _totalCount = 0;
1656         for (uint256 i = 0; i < totalSupply(); i++) {
1657             if (MAP_STAKED_TOKEN[i] == true) {
1658                 _totalCount++;
1659             }
1660         }
1661         return _totalCount;
1662     }
1663 
1664     function earned(address account) public view returns (uint256) {
1665         uint256 blockTime = block.timestamp;
1666 
1667         UserRewardInfo memory user = MAP_USER_REWARD_INFO[account];
1668 
1669         uint256 amount = (blockTime - user.lastUpdated) * user.stakedBalance * DAILY_REWARD_AMOUNT / (1 days);
1670 
1671         if (user.stakedBalance >= BONUS_STAKE_LIMIT)  amount = amount * (100 + BONUS_PERCENT) / 100;
1672         
1673         return user.rewards + amount;
1674     }
1675 
1676 
1677     function stake( uint256[] calldata _tokenIDList) external {
1678         UserRewardInfo storage user = MAP_USER_REWARD_INFO[_msgSender()];
1679         user.rewards = earned(_msgSender());
1680         user.lastUpdated = block.timestamp;
1681 
1682         uint256 newStakedCount = 0;
1683         for (uint256 i = 0; i < _tokenIDList.length; i++) {
1684             if (ownerOf(_tokenIDList[i]) == _msgSender() && MAP_STAKED_TOKEN[_tokenIDList[i]] == false) {
1685                 newStakedCount++;
1686                 MAP_STAKED_TOKEN[_tokenIDList[i]] = true;
1687             }
1688         }
1689 
1690         user.stakedBalance = user.stakedBalance + newStakedCount;
1691     }
1692 
1693     function harvest() external {
1694         UserRewardInfo storage user = MAP_USER_REWARD_INFO[_msgSender()];
1695         user.rewards = earned(_msgSender());
1696         user.lastUpdated = block.timestamp;
1697 
1698         require(REWARD_TOKEN.balanceOf(address(this)) >= user.rewards,"Reward token amount is small");
1699 
1700         if (user.rewards > 0) {
1701             REWARD_TOKEN.transfer(_msgSender(), user.rewards);
1702         }
1703 
1704         user.rewards = 0;
1705     }
1706 
1707     function _beforeTokenTransfers(address from,address to,uint256 startTokenId,uint256 quantity) internal virtual override {
1708         super._beforeTokenTransfers(from, to, startTokenId, quantity);
1709         if (from != address(0) && MAP_STAKED_TOKEN[startTokenId] == true) {
1710             UserRewardInfo storage fromUser = MAP_USER_REWARD_INFO[from];
1711             UserRewardInfo storage toUser = MAP_USER_REWARD_INFO[to];
1712 
1713             fromUser.rewards = earned(from);
1714             fromUser.lastUpdated = block.timestamp;
1715             fromUser.stakedBalance = fromUser.stakedBalance - 1;
1716 
1717             toUser.rewards = earned(to);
1718             toUser.lastUpdated = block.timestamp;
1719             toUser.stakedBalance = toUser.stakedBalance + 1;
1720         }
1721     }
1722 
1723     function withdraw() public onlyOwner {
1724         uint256 balance = address(this).balance;
1725         payable(msg.sender).transfer(balance);
1726     }
1727 
1728     function withdrawToken() public onlyOwner {
1729         REWARD_TOKEN.transfer(msg.sender, REWARD_TOKEN.balanceOf(address(this)));
1730     }
1731 }