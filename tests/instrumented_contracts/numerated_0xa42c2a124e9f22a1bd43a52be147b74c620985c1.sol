1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 
5 /*
6   _    _                     _ _             _ _____                            
7  | |  | |                   | (_)           | |  __ \                           
8  | |  | |_ __   ___  _ __ __| |_ _ __   __ _| | |  | | ___  __ _  ___ _ __  ___ 
9  | |  | | '_ \ / _ \| '__/ _` | | '_ \ / _` | | |  | |/ _ \/ _` |/ _ \ '_ \/ __|
10  | |__| | | | | (_) | | | (_| | | | | | (_| | | |__| |  __/ (_| |  __/ | | \__ \
11   \____/|_| |_|\___/|_|  \__,_|_|_| |_|\__,_|_|_____/ \___|\__, |\___|_| |_|___/
12                                                             __/ |               
13                                                            |___/                
14 
15 ⣿⣿⣿⠛⠉⢀⣤⣀⠄⠄⠄⠄⠄⠄⠄⠄⠄⠻⠷⠄⠄⠄⢘⣲⣄⠉⢻⣿⣿⣿
16 ⣿⠛⠁⠄⢸⣿⣿⡿⣋⣤⠤⠄⠄⣀⣀⣀⡀⠄⠄⠄⣀⣤⣤⣤⣤⣅⡀⠹⣿⣿
17 ⠇⠄⠌⢀⣿⣿⣿⣿⠟⣁⣴⣾⣿⣿⠟⡛⠛⢿⣆⢸⣿⣿⣿⠫⠄⠈⢻⠄⢹⣿
18 ⠄⠘⠄⣸⣿⣿⣿⣿⡐⣿⣿⣿⣿⣿⣄⠅⢀⣼⡿⠘⢿⣿⣿⣷⣥⣴⡿⠄⢸⣿
19 ⠄⠃⠄⣿⣿⣿⣿⣿⣷⣬⡙⠻⠿⠿⠿⠿⠟⠋⠁⣠⡀⠠⠭⠭⠭⢥⣤⠄⢸⣿
20 ⢸⠄⢸⣿⣿⣿⣿⣿⣿⣿⣉⣛⠒⠒⠒⢂⣁⣠⣴⣿⣿⣿⣶⣶⣶⣿⣿⡇⠄⣿
21 ⣿⠄⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠋⠉⠉⠛⢿⣿⣿⣿⡇⠄⣿
22 ⡏⠄⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠋⠄⠄⠄⠄⠄⠄⠈⢻⣿⣿⠃⢀⣿
23 ⡇⠄⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⠇⠄⠄⠄⠄⠄⠄⠄⠄⠈⣿⣿⠄⢸⣿
24 ⡇⠄⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣏⠄⠹⣶⣄⠄⠄⠄⠄⠄⠄⠄⠘⠛⢿⠄⢸⣿
25 ⠃⠠⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⢰⣿⣿⣧⠄⡀⠄⢀⣠⣶⣿⠗⠄⢀⣾⣿
26 ⠄⠄⠄⠄⠉⠻⣿⣿⣿⣿⣿⣿⣿⣿⠈⣿⣿⠃⠄⣩⣴⣿⣿⣿⣃⣤⣶⠄⢹⣿
27 ⠄⠄⠄⠄⠄⠄⠄⠉⠻⢿⣿⣿⣿⡟⢠⣿⣧⣴⣿⣿⣿⣿⣿⣿⣿⣿⣋⡀⠘⣿
28 ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠉⠛⠁⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠄⠻
29 ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣾⡖
30 
31 
32 Anon, did u fade degens? :kekw:
33 
34 The first ordinal yield farming nft
35 with $OD staking.
36 royalties are kept in our Dao treasury.
37 
38 phase 1 : stealth mint for 24/7 degens only, having post mint day party
39 phase 2 : $OD dao discord open, released white paper, take OD holder snapshot
40 phase 3: $OD token airdrop with product execution
41 
42  */
43 
44 
45 /**
46  * @dev Interface of the ERC165 standard, as defined in the
47  * https://eips.ethereum.org/EIPS/eip-165[EIP].
48  *
49  * Implementers can declare support of contract interfaces, which can then be
50  * queried by others ({ERC165Checker}).
51  *
52  * For an implementation, see {ERC165}.
53  */
54 interface IERC165 {
55     /**
56      * @dev Returns true if this contract implements the interface defined by
57      * `interfaceId`. See the corresponding
58      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
59      * to learn more about how these ids are created.
60      *
61      * This function call must use less than 30 000 gas.
62      */
63     function supportsInterface(bytes4 interfaceId) external view returns (bool);
64 }
65 
66 /**
67  * @dev Required interface of an ERC721 compliant contract.
68  */
69 interface IERC721 is IERC165 {
70     /**
71      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
72      */
73     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
74 
75     /**
76      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
77      */
78     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
79 
80     /**
81      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
82      */
83     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
84 
85     /**
86      * @dev Returns the number of tokens in ``owner``'s account.
87      */
88     function balanceOf(address owner) external view returns (uint256 balance);
89 
90     /**
91      * @dev Returns the owner of the `tokenId` token.
92      *
93      * Requirements:
94      *
95      * - `tokenId` must exist.
96      */
97     function ownerOf(uint256 tokenId) external view returns (address owner);
98 
99     /**
100      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
101      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
102      *
103      * Requirements:
104      *
105      * - `from` cannot be the zero address.
106      * - `to` cannot be the zero address.
107      * - `tokenId` token must exist and be owned by `from`.
108      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
109      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
110      *
111      * Emits a {Transfer} event.
112      */
113     function safeTransferFrom(
114         address from,
115         address to,
116         uint256 tokenId
117     ) external;
118 
119     /**
120      * @dev Transfers `tokenId` token from `from` to `to`.
121      *
122      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
123      *
124      * Requirements:
125      *
126      * - `from` cannot be the zero address.
127      * - `to` cannot be the zero address.
128      * - `tokenId` token must be owned by `from`.
129      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
130      *
131      * Emits a {Transfer} event.
132      */
133     function transferFrom(
134         address from,
135         address to,
136         uint256 tokenId
137     ) external;
138 
139     /**
140      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
141      * The approval is cleared when the token is transferred.
142      *
143      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
144      *
145      * Requirements:
146      *
147      * - The caller must own the token or be an approved operator.
148      * - `tokenId` must exist.
149      *
150      * Emits an {Approval} event.
151      */
152     function approve(address to, uint256 tokenId) external;
153 
154     /**
155      * @dev Returns the account approved for `tokenId` token.
156      *
157      * Requirements:
158      *
159      * - `tokenId` must exist.
160      */
161     function getApproved(uint256 tokenId) external view returns (address operator);
162 
163     /**
164      * @dev Approve or remove `operator` as an operator for the caller.
165      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
166      *
167      * Requirements:
168      *
169      * - The `operator` cannot be the caller.
170      *
171      * Emits an {ApprovalForAll} event.
172      */
173     function setApprovalForAll(address operator, bool _approved) external;
174 
175     /**
176      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
177      *
178      * See {setApprovalForAll}
179      */
180     function isApprovedForAll(address owner, address operator) external view returns (bool);
181 
182     /**
183      * @dev Safely transfers `tokenId` token from `from` to `to`.
184      *
185      * Requirements:
186      *
187      * - `from` cannot be the zero address.
188      * - `to` cannot be the zero address.
189      * - `tokenId` token must exist and be owned by `from`.
190      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
191      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
192      *
193      * Emits a {Transfer} event.
194      */
195     function safeTransferFrom(
196         address from,
197         address to,
198         uint256 tokenId,
199         bytes calldata data
200     ) external;
201 }
202 
203 
204 
205 /**
206  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
207  * @dev See https://eips.ethereum.org/EIPS/eip-721
208  */
209 interface IERC721Enumerable is IERC721 {
210     /**
211      * @dev Returns the total amount of tokens stored by the contract.
212      */
213     function totalSupply() external view returns (uint256);
214 
215     /**
216      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
217      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
218      */
219     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
220 
221     /**
222      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
223      * Use along with {totalSupply} to enumerate all tokens.
224      */
225     function tokenByIndex(uint256 index) external view returns (uint256);
226 }
227 
228 
229 /**
230  * @dev Implementation of the {IERC165} interface.
231  *
232  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
233  * for the additional interface id that will be supported. For example:
234  *
235  * ```solidity
236  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
237  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
238  * }
239  * ```
240  *
241  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
242  */
243 abstract contract ERC165 is IERC165 {
244     /**
245      * @dev See {IERC165-supportsInterface}.
246      */
247     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
248         return interfaceId == type(IERC165).interfaceId;
249     }
250 }
251 
252 
253 /**
254  * @dev String operations.
255  */
256 library Strings {
257     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
258 
259     /**
260      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
261      */
262     function toString(uint256 value) internal pure returns (string memory) {
263         // Inspired by OraclizeAPI's implementation - MIT licence
264         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
265 
266         if (value == 0) {
267             return "0";
268         }
269         uint256 temp = value;
270         uint256 digits;
271         while (temp != 0) {
272             digits++;
273             temp /= 10;
274         }
275         bytes memory buffer = new bytes(digits);
276         while (value != 0) {
277             digits -= 1;
278             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
279             value /= 10;
280         }
281         return string(buffer);
282     }
283 
284     /**
285      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
286      */
287     function toHexString(uint256 value) internal pure returns (string memory) {
288         if (value == 0) {
289             return "0x00";
290         }
291         uint256 temp = value;
292         uint256 length = 0;
293         while (temp != 0) {
294             length++;
295             temp >>= 8;
296         }
297         return toHexString(value, length);
298     }
299 
300     /**
301      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
302      */
303     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
304         bytes memory buffer = new bytes(2 * length + 2);
305         buffer[0] = "0";
306         buffer[1] = "x";
307         for (uint256 i = 2 * length + 1; i > 1; --i) {
308             buffer[i] = _HEX_SYMBOLS[value & 0xf];
309             value >>= 4;
310         }
311         require(value == 0, "Strings: hex length insufficient");
312         return string(buffer);
313     }
314 }
315 
316 
317 /**
318  * @dev Collection of functions related to the address type
319  */
320 library Address {
321     /**
322      * @dev Returns true if `account` is a contract.
323      *
324      * [IMPORTANT]
325      * ====
326      * It is unsafe to assume that an address for which this function returns
327      * false is an externally-owned account (EOA) and not a contract.
328      *
329      * Among others, `isContract` will return false for the following
330      * types of addresses:
331      *
332      *  - an externally-owned account
333      *  - a contract in construction
334      *  - an address where a contract will be created
335      *  - an address where a contract lived, but was destroyed
336      * ====
337      */
338     function isContract(address account) internal view returns (bool) {
339         // This method relies on extcodesize, which returns 0 for contracts in
340         // construction, since the code is only stored at the end of the
341         // constructor execution.
342 
343         uint256 size;
344         assembly {
345             size := extcodesize(account)
346         }
347         return size > 0;
348     }
349 
350     /**
351      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
352      * `recipient`, forwarding all available gas and reverting on errors.
353      *
354      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
355      * of certain opcodes, possibly making contracts go over the 2300 gas limit
356      * imposed by `transfer`, making them unable to receive funds via
357      * `transfer`. {sendValue} removes this limitation.
358      *
359      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
360      *
361      * IMPORTANT: because control is transferred to `recipient`, care must be
362      * taken to not create reentrancy vulnerabilities. Consider using
363      * {ReentrancyGuard} or the
364      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
365      */
366     function sendValue(address payable recipient, uint256 amount) internal {
367         require(address(this).balance >= amount, "Address: insufficient balance");
368 
369         (bool success, ) = recipient.call{value: amount}("");
370         require(success, "Address: unable to send value, recipient may have reverted");
371     }
372 
373     /**
374      * @dev Performs a Solidity function call using a low level `call`. A
375      * plain `call` is an unsafe replacement for a function call: use this
376      * function instead.
377      *
378      * If `target` reverts with a revert reason, it is bubbled up by this
379      * function (like regular Solidity function calls).
380      *
381      * Returns the raw returned data. To convert to the expected return value,
382      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
383      *
384      * Requirements:
385      *
386      * - `target` must be a contract.
387      * - calling `target` with `data` must not revert.
388      *
389      * _Available since v3.1._
390      */
391     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
392         return functionCall(target, data, "Address: low-level call failed");
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
397      * `errorMessage` as a fallback revert reason when `target` reverts.
398      *
399      * _Available since v3.1._
400      */
401     function functionCall(
402         address target,
403         bytes memory data,
404         string memory errorMessage
405     ) internal returns (bytes memory) {
406         return functionCallWithValue(target, data, 0, errorMessage);
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
411      * but also transferring `value` wei to `target`.
412      *
413      * Requirements:
414      *
415      * - the calling contract must have an ETH balance of at least `value`.
416      * - the called Solidity function must be `payable`.
417      *
418      * _Available since v3.1._
419      */
420     function functionCallWithValue(
421         address target,
422         bytes memory data,
423         uint256 value
424     ) internal returns (bytes memory) {
425         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
430      * with `errorMessage` as a fallback revert reason when `target` reverts.
431      *
432      * _Available since v3.1._
433      */
434     function functionCallWithValue(
435         address target,
436         bytes memory data,
437         uint256 value,
438         string memory errorMessage
439     ) internal returns (bytes memory) {
440         require(address(this).balance >= value, "Address: insufficient balance for call");
441         require(isContract(target), "Address: call to non-contract");
442 
443         (bool success, bytes memory returndata) = target.call{value: value}(data);
444         return verifyCallResult(success, returndata, errorMessage);
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
449      * but performing a static call.
450      *
451      * _Available since v3.3._
452      */
453     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
454         return functionStaticCall(target, data, "Address: low-level static call failed");
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
459      * but performing a static call.
460      *
461      * _Available since v3.3._
462      */
463     function functionStaticCall(
464         address target,
465         bytes memory data,
466         string memory errorMessage
467     ) internal view returns (bytes memory) {
468         require(isContract(target), "Address: static call to non-contract");
469 
470         (bool success, bytes memory returndata) = target.staticcall(data);
471         return verifyCallResult(success, returndata, errorMessage);
472     }
473 
474     /**
475      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
476      * but performing a delegate call.
477      *
478      * _Available since v3.4._
479      */
480     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
481         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
482     }
483 
484     /**
485      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
486      * but performing a delegate call.
487      *
488      * _Available since v3.4._
489      */
490     function functionDelegateCall(
491         address target,
492         bytes memory data,
493         string memory errorMessage
494     ) internal returns (bytes memory) {
495         require(isContract(target), "Address: delegate call to non-contract");
496 
497         (bool success, bytes memory returndata) = target.delegatecall(data);
498         return verifyCallResult(success, returndata, errorMessage);
499     }
500 
501     /**
502      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
503      * revert reason using the provided one.
504      *
505      * _Available since v4.3._
506      */
507     function verifyCallResult(
508         bool success,
509         bytes memory returndata,
510         string memory errorMessage
511     ) internal pure returns (bytes memory) {
512         if (success) {
513             return returndata;
514         } else {
515             // Look for revert reason and bubble it up if present
516             if (returndata.length > 0) {
517                 // The easiest way to bubble the revert reason is using memory via assembly
518 
519                 assembly {
520                     let returndata_size := mload(returndata)
521                     revert(add(32, returndata), returndata_size)
522                 }
523             } else {
524                 revert(errorMessage);
525             }
526         }
527     }
528 }
529 
530 
531 
532 /**
533  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
534  * @dev See https://eips.ethereum.org/EIPS/eip-721
535  */
536 interface IERC721Metadata is IERC721 {
537     /**
538      * @dev Returns the token collection name.
539      */
540     function name() external view returns (string memory);
541 
542     /**
543      * @dev Returns the token collection symbol.
544      */
545     function symbol() external view returns (string memory);
546 
547     /**
548      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
549      */
550     function tokenURI(uint256 tokenId) external view returns (string memory);
551 }
552 
553 
554 /**
555  * @title ERC721 token receiver interface
556  * @dev Interface for any contract that wants to support safeTransfers
557  * from ERC721 asset contracts.
558  */
559 interface IERC721Receiver {
560     /**
561      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
562      * by `operator` from `from`, this function is called.
563      *
564      * It must return its Solidity selector to confirm the token transfer.
565      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
566      *
567      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
568      */
569     function onERC721Received(
570         address operator,
571         address from,
572         uint256 tokenId,
573         bytes calldata data
574     ) external returns (bytes4);
575 }
576 
577 // File: @openzeppelin/contracts/utils/Context.sol
578 
579 /**
580  * @dev Provides information about the current execution context, including the
581  * sender of the transaction and its data. While these are generally available
582  * via msg.sender and msg.data, they should not be accessed in such a direct
583  * manner, since when dealing with meta-transactions the account sending and
584  * paying for execution may not be the actual sender (as far as an application
585  * is concerned).
586  *
587  * This contract is only required for intermediate, library-like contracts.
588  */
589 abstract contract Context {
590     function _msgSender() internal view virtual returns (address) {
591         return msg.sender;
592     }
593 
594     function _msgData() internal view virtual returns (bytes calldata) {
595         return msg.data;
596     }
597 }
598 
599 
600 /**
601  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
602  * the Metadata extension, but not including the Enumerable extension, which is available separately as
603  * {ERC721Enumerable}.
604  */
605 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
606     using Address for address;
607     using Strings for uint256;
608 
609     // Token name
610     string private _name;
611 
612     // Token symbol
613     string private _symbol;
614 
615     // Mapping from token ID to owner address
616     mapping(uint256 => address) private _owners;
617 
618     // Mapping owner address to token count
619     mapping(address => uint256) private _balances;
620 
621     // Mapping from token ID to approved address
622     mapping(uint256 => address) private _tokenApprovals;
623 
624     // Mapping from owner to operator approvals
625     mapping(address => mapping(address => bool)) private _operatorApprovals;
626 
627     /**
628      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
629      */
630     constructor(string memory name_, string memory symbol_) {
631         _name = name_;
632         _symbol = symbol_;
633     }
634 
635     /**
636      * @dev See {IERC165-supportsInterface}.
637      */
638     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
639         return
640             interfaceId == type(IERC721).interfaceId ||
641             interfaceId == type(IERC721Metadata).interfaceId ||
642             super.supportsInterface(interfaceId);
643     }
644 
645     /**
646      * @dev See {IERC721-balanceOf}.
647      */
648     function balanceOf(address owner) public view virtual override returns (uint256) {
649         require(owner != address(0), "ERC721: balance query for the zero address");
650         return _balances[owner];
651     }
652 
653     /**
654      * @dev See {IERC721-ownerOf}.
655      */
656     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
657         address owner = _owners[tokenId];
658         require(owner != address(0), "ERC721: owner query for nonexistent token");
659         return owner;
660     }
661 
662     /**
663      * @dev See {IERC721Metadata-name}.
664      */
665     function name() public view virtual override returns (string memory) {
666         return _name;
667     }
668 
669     /**
670      * @dev See {IERC721Metadata-symbol}.
671      */
672     function symbol() public view virtual override returns (string memory) {
673         return _symbol;
674     }
675 
676     /**
677      * @dev See {IERC721Metadata-tokenURI}.
678      */
679     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
680         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
681 
682         string memory baseURI = _baseURI();
683         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
684     }
685 
686     /**
687      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
688      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
689      * by default, can be overriden in child contracts.
690      */
691     function _baseURI() internal view virtual returns (string memory) {
692         return "";
693     }
694 
695     /**
696      * @dev See {IERC721-approve}.
697      */
698     function approve(address to, uint256 tokenId) public virtual override {
699         address owner = ERC721.ownerOf(tokenId);
700         require(to != owner, "ERC721: approval to current owner");
701 
702         require(
703             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
704             "ERC721: approve caller is not owner nor approved for all"
705         );
706 
707         _approve(to, tokenId);
708     }
709 
710     /**
711      * @dev See {IERC721-getApproved}.
712      */
713     function getApproved(uint256 tokenId) public view virtual override returns (address) {
714         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
715 
716         return _tokenApprovals[tokenId];
717     }
718 
719     /**
720      * @dev See {IERC721-setApprovalForAll}.
721      */
722     function setApprovalForAll(address operator, bool approved) public virtual override {
723         require(operator != _msgSender(), "ERC721: approve to caller");
724 
725         _operatorApprovals[_msgSender()][operator] = approved;
726         emit ApprovalForAll(_msgSender(), operator, approved);
727     }
728 
729     /**
730      * @dev See {IERC721-isApprovedForAll}.
731      */
732     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
733         return _operatorApprovals[owner][operator];
734     }
735 
736     /**
737      * @dev See {IERC721-transferFrom}.
738      */
739     function transferFrom(
740         address from,
741         address to,
742         uint256 tokenId
743     ) public virtual override {
744         //solhint-disable-next-line max-line-length
745         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
746 
747         _transfer(from, to, tokenId);
748     }
749 
750     /**
751      * @dev See {IERC721-safeTransferFrom}.
752      */
753     function safeTransferFrom(
754         address from,
755         address to,
756         uint256 tokenId
757     ) public virtual override {
758         safeTransferFrom(from, to, tokenId, "");
759     }
760 
761     /**
762      * @dev See {IERC721-safeTransferFrom}.
763      */
764     function safeTransferFrom(
765         address from,
766         address to,
767         uint256 tokenId,
768         bytes memory _data
769     ) public virtual override {
770         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
771         _safeTransfer(from, to, tokenId, _data);
772     }
773 
774     /**
775      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
776      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
777      *
778      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
779      *
780      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
781      * implement alternative mechanisms to perform token transfer, such as signature-based.
782      *
783      * Requirements:
784      *
785      * - `from` cannot be the zero address.
786      * - `to` cannot be the zero address.
787      * - `tokenId` token must exist and be owned by `from`.
788      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
789      *
790      * Emits a {Transfer} event.
791      */
792     function _safeTransfer(
793         address from,
794         address to,
795         uint256 tokenId,
796         bytes memory _data
797     ) internal virtual {
798         _transfer(from, to, tokenId);
799         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
800     }
801 
802     /**
803      * @dev Returns whether `tokenId` exists.
804      *
805      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
806      *
807      * Tokens start existing when they are minted (`_mint`),
808      * and stop existing when they are burned (`_burn`).
809      */
810     function _exists(uint256 tokenId) internal view virtual returns (bool) {
811         return _owners[tokenId] != address(0);
812     }
813 
814     /**
815      * @dev Returns whether `spender` is allowed to manage `tokenId`.
816      *
817      * Requirements:
818      *
819      * - `tokenId` must exist.
820      */
821     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
822         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
823         address owner = ERC721.ownerOf(tokenId);
824         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
825     }
826 
827     /**
828      * @dev Safely mints `tokenId` and transfers it to `to`.
829      *
830      * Requirements:
831      *
832      * - `tokenId` must not exist.
833      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
834      *
835      * Emits a {Transfer} event.
836      */
837     function _safeMint(address to, uint256 tokenId) internal virtual {
838         _safeMint(to, tokenId, "");
839     }
840 
841     /**
842      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
843      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
844      */
845     function _safeMint(
846         address to,
847         uint256 tokenId,
848         bytes memory _data
849     ) internal virtual {
850         _mint(to, tokenId);
851         require(
852             _checkOnERC721Received(address(0), to, tokenId, _data),
853             "ERC721: transfer to non ERC721Receiver implementer"
854         );
855     }
856 
857     /**
858      * @dev Mints `tokenId` and transfers it to `to`.
859      *
860      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
861      *
862      * Requirements:
863      *
864      * - `tokenId` must not exist.
865      * - `to` cannot be the zero address.
866      *
867      * Emits a {Transfer} event.
868      */
869     function _mint(address to, uint256 tokenId) internal virtual {
870         require(to != address(0), "ERC721: mint to the zero address");
871         require(!_exists(tokenId), "ERC721: token already minted");
872 
873         _beforeTokenTransfer(address(0), to, tokenId);
874 
875         _balances[to] += 1;
876         _owners[tokenId] = to;
877 
878         emit Transfer(address(0), to, tokenId);
879     }
880 
881     /**
882      * @dev Destroys `tokenId`.
883      * The approval is cleared when the token is burned.
884      *
885      * Requirements:
886      *
887      * - `tokenId` must exist.
888      *
889      * Emits a {Transfer} event.
890      */
891     function _burn(uint256 tokenId) internal virtual {
892         address owner = ERC721.ownerOf(tokenId);
893 
894         _beforeTokenTransfer(owner, address(0), tokenId);
895 
896         // Clear approvals
897         _approve(address(0), tokenId);
898 
899         _balances[owner] -= 1;
900         delete _owners[tokenId];
901 
902         emit Transfer(owner, address(0), tokenId);
903     }
904 
905     /**
906      * @dev Transfers `tokenId` from `from` to `to`.
907      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
908      *
909      * Requirements:
910      *
911      * - `to` cannot be the zero address.
912      * - `tokenId` token must be owned by `from`.
913      *
914      * Emits a {Transfer} event.
915      */
916     function _transfer(
917         address from,
918         address to,
919         uint256 tokenId
920     ) internal virtual {
921         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
922         require(to != address(0), "ERC721: transfer to the zero address");
923 
924         _beforeTokenTransfer(from, to, tokenId);
925 
926         // Clear approvals from the previous owner
927         _approve(address(0), tokenId);
928 
929         _balances[from] -= 1;
930         _balances[to] += 1;
931         _owners[tokenId] = to;
932 
933         emit Transfer(from, to, tokenId);
934     }
935 
936     /**
937      * @dev Approve `to` to operate on `tokenId`
938      *
939      * Emits a {Approval} event.
940      */
941     function _approve(address to, uint256 tokenId) internal virtual {
942         _tokenApprovals[tokenId] = to;
943         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
944     }
945 
946     /**
947      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
948      * The call is not executed if the target address is not a contract.
949      *
950      * @param from address representing the previous owner of the given token ID
951      * @param to target address that will receive the tokens
952      * @param tokenId uint256 ID of the token to be transferred
953      * @param _data bytes optional data to send along with the call
954      * @return bool whether the call correctly returned the expected magic value
955      */
956     function _checkOnERC721Received(
957         address from,
958         address to,
959         uint256 tokenId,
960         bytes memory _data
961     ) private returns (bool) {
962         if (to.isContract()) {
963             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
964                 return retval == IERC721Receiver.onERC721Received.selector;
965             } catch (bytes memory reason) {
966                 if (reason.length == 0) {
967                     revert("ERC721: transfer to non ERC721Receiver implementer");
968                 } else {
969                     assembly {
970                         revert(add(32, reason), mload(reason))
971                     }
972                 }
973             }
974         } else {
975             return true;
976         }
977     }
978 
979     /**
980      * @dev Hook that is called before any token transfer. This includes minting
981      * and burning.
982      *
983      * Calling conditions:
984      *
985      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
986      * transferred to `to`.
987      * - When `from` is zero, `tokenId` will be minted for `to`.
988      * - When `to` is zero, ``from``'s `tokenId` will be burned.
989      * - `from` and `to` are never both zero.
990      *
991      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
992      */
993     function _beforeTokenTransfer(
994         address from,
995         address to,
996         uint256 tokenId
997     ) internal virtual {}
998 }
999 
1000 
1001 
1002 /**
1003  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1004  * enumerability of all the token ids in the contract as well as all token ids owned by each
1005  * account.
1006  */
1007 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1008     // Mapping from owner to list of owned token IDs
1009     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1010 
1011     // Mapping from token ID to index of the owner tokens list
1012     mapping(uint256 => uint256) private _ownedTokensIndex;
1013 
1014     // Array with all token ids, used for enumeration
1015     uint256[] private _allTokens;
1016 
1017     // Mapping from token id to position in the allTokens array
1018     mapping(uint256 => uint256) private _allTokensIndex;
1019 
1020     /**
1021      * @dev See {IERC165-supportsInterface}.
1022      */
1023     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1024         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1025     }
1026 
1027     /**
1028      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1029      */
1030     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1031         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1032         return _ownedTokens[owner][index];
1033     }
1034 
1035     /**
1036      * @dev See {IERC721Enumerable-totalSupply}.
1037      */
1038     function totalSupply() public view virtual override returns (uint256) {
1039         return _allTokens.length;
1040     }
1041 
1042     /**
1043      * @dev See {IERC721Enumerable-tokenByIndex}.
1044      */
1045     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1046         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1047         return _allTokens[index];
1048     }
1049 
1050     /**
1051      * @dev Hook that is called before any token transfer. This includes minting
1052      * and burning.
1053      *
1054      * Calling conditions:
1055      *
1056      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1057      * transferred to `to`.
1058      * - When `from` is zero, `tokenId` will be minted for `to`.
1059      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1060      * - `from` cannot be the zero address.
1061      * - `to` cannot be the zero address.
1062      *
1063      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1064      */
1065     function _beforeTokenTransfer(
1066         address from,
1067         address to,
1068         uint256 tokenId
1069     ) internal virtual override {
1070         super._beforeTokenTransfer(from, to, tokenId);
1071 
1072         if (from == address(0)) {
1073             _addTokenToAllTokensEnumeration(tokenId);
1074         } else if (from != to) {
1075             _removeTokenFromOwnerEnumeration(from, tokenId);
1076         }
1077         if (to == address(0)) {
1078             _removeTokenFromAllTokensEnumeration(tokenId);
1079         } else if (to != from) {
1080             _addTokenToOwnerEnumeration(to, tokenId);
1081         }
1082     }
1083 
1084     /**
1085      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1086      * @param to address representing the new owner of the given token ID
1087      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1088      */
1089     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1090         uint256 length = ERC721.balanceOf(to);
1091         _ownedTokens[to][length] = tokenId;
1092         _ownedTokensIndex[tokenId] = length;
1093     }
1094 
1095     /**
1096      * @dev Private function to add a token to this extension's token tracking data structures.
1097      * @param tokenId uint256 ID of the token to be added to the tokens list
1098      */
1099     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1100         _allTokensIndex[tokenId] = _allTokens.length;
1101         _allTokens.push(tokenId);
1102     }
1103 
1104     /**
1105      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1106      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1107      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1108      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1109      * @param from address representing the previous owner of the given token ID
1110      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1111      */
1112     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1113         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1114         // then delete the last slot (swap and pop).
1115 
1116         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1117         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1118 
1119         // When the token to delete is the last token, the swap operation is unnecessary
1120         if (tokenIndex != lastTokenIndex) {
1121             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1122 
1123             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1124             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1125         }
1126 
1127         // This also deletes the contents at the last position of the array
1128         delete _ownedTokensIndex[tokenId];
1129         delete _ownedTokens[from][lastTokenIndex];
1130     }
1131 
1132     /**
1133      * @dev Private function to remove a token from this extension's token tracking data structures.
1134      * This has O(1) time complexity, but alters the order of the _allTokens array.
1135      * @param tokenId uint256 ID of the token to be removed from the tokens list
1136      */
1137     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1138         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1139         // then delete the last slot (swap and pop).
1140 
1141         uint256 lastTokenIndex = _allTokens.length - 1;
1142         uint256 tokenIndex = _allTokensIndex[tokenId];
1143 
1144         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1145         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1146         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1147         uint256 lastTokenId = _allTokens[lastTokenIndex];
1148 
1149         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1150         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1151 
1152         // This also deletes the contents at the last position of the array
1153         delete _allTokensIndex[tokenId];
1154         _allTokens.pop();
1155     }
1156 }
1157 
1158 
1159 /**
1160  * @dev Contract module which provides a basic access control mechanism, where
1161  * there is an account (an owner) that can be granted exclusive access to
1162  * specific functions.
1163  *
1164  * By default, the owner account will be the one that deploys the contract. This
1165  * can later be changed with {transferOwnership}.
1166  *
1167  * This module is used through inheritance. It will make available the modifier
1168  * `onlyOwner`, which can be applied to your functions to restrict their use to
1169  * the owner.
1170  */
1171 abstract contract Ownable is Context {
1172     address private _owner;
1173 
1174     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1175 
1176     /**
1177      * @dev Initializes the contract setting the deployer as the initial owner.
1178      */
1179     constructor() {
1180         _setOwner(_msgSender());
1181     }
1182 
1183     /**
1184      * @dev Returns the address of the current owner.
1185      */
1186     function owner() public view virtual returns (address) {
1187         return _owner;
1188     }
1189 
1190     /**
1191      * @dev Throws if called by any account other than the owner.
1192      */
1193     modifier onlyOwner() {
1194         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1195         _;
1196     }
1197 
1198     /**
1199      * @dev Leaves the contract without owner. It will not be possible to call
1200      * `onlyOwner` functions anymore. Can only be called by the current owner.
1201      *
1202      * NOTE: Renouncing ownership will leave the contract without an owner,
1203      * thereby removing any functionality that is only available to the owner.
1204      */
1205     function renounceOwnership() public virtual onlyOwner {
1206         _setOwner(address(0));
1207     }
1208 
1209     /**
1210      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1211      * Can only be called by the current owner.
1212      */
1213     function transferOwnership(address newOwner) public virtual onlyOwner {
1214         require(newOwner != address(0), "Ownable: new owner is the zero address");
1215         _setOwner(newOwner);
1216     }
1217 
1218     function _setOwner(address newOwner) private {
1219         address oldOwner = _owner;
1220         _owner = newOwner;
1221         emit OwnershipTransferred(oldOwner, newOwner);
1222     }
1223 }
1224 
1225 interface IStaker {
1226     function staked(uint16 tokenId) external;
1227 }
1228 
1229 
1230 contract Official_UnordinalDegens is ERC721Enumerable, Ownable {
1231   using Strings for uint256;
1232 
1233   string public baseURI = "https://ipfs.io/ipfs/bafybeieoee7xyvlkmnzrdmbl4e7kv3vdvqqa4t5jad2m66j3twoqakno3u/";
1234   string public baseExtension = ".json";
1235   uint256 public cost = 0.004 ether;
1236   uint256 public maxSupply = 3333;
1237   uint256 private Freeminted = 0;
1238   uint256 public FreeSupplyCap = 1111;
1239   uint256 public maxMintAmount = 11;
1240   uint256 public maxFree = 1;
1241   mapping(address => uint256) private _mintedFreeAmount;
1242   bool public paused = true;
1243 
1244 
1245   constructor(
1246     string memory _name,
1247     string memory _symbol
1248   ) ERC721(_name, _symbol) {
1249 
1250   }
1251  
1252 
1253   // internal
1254   function _baseURI() internal view virtual override returns (string memory) {
1255     return baseURI;
1256   }
1257 
1258   // public
1259   function mint(uint256 _mintAmount) public payable {
1260     uint256 supply = totalSupply();
1261     require(!paused);
1262     require(_mintAmount > 0);
1263     require(_mintAmount <= maxMintAmount);
1264     require(supply + _mintAmount <= maxSupply);
1265     uint256 _cost = (msg.value == 0 &&
1266             (_mintedFreeAmount[msg.sender] + _mintAmount <= maxFree))
1267             ? 0
1268             : cost;
1269     require(msg.value >= _cost * _mintAmount, "not enough ETH");
1270 
1271 
1272     if (_cost == 0) {
1273         require(Freeminted+_mintAmount <= FreeSupplyCap, "FreeSupplyCap reached.");
1274             _mintedFreeAmount[msg.sender] += _mintAmount;
1275             Freeminted += _mintAmount;
1276         }
1277 
1278 
1279     for (uint256 i = 1; i <= _mintAmount; i++) {
1280       _safeMint(msg.sender, supply + i);
1281     }
1282   }
1283   
1284 
1285   function setMaxFreeMint(uint256 _maxFree) external onlyOwner {
1286         maxFree = _maxFree;
1287     }
1288 
1289   function mintForOwner(uint256 _mintAmount) external onlyOwner {
1290     uint256 supply = totalSupply();
1291     require(_mintAmount > 0);
1292     require(_mintAmount <= maxMintAmount);
1293     require(supply + _mintAmount <= maxSupply);
1294 
1295     for (uint256 i = 1; i <= _mintAmount; i++) {
1296       _safeMint(msg.sender, supply + i);
1297     }
1298   }
1299 
1300   function NFTsOfOwner(address _owner)
1301     public
1302     view
1303     returns (uint256[] memory)
1304   {
1305     uint256 ownerTokenCount = balanceOf(_owner);
1306     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1307     for (uint256 i; i < ownerTokenCount; i++) {
1308       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1309     }
1310     return tokenIds;
1311   }
1312 
1313   function tokenURI(uint256 tokenId)
1314     public
1315     view
1316     virtual
1317     override
1318     returns (string memory)
1319   {
1320     require(
1321       _exists(tokenId),
1322       "ERC721Metadata: URI query for nonexistent token"
1323     );
1324 
1325     string memory currentBaseURI = _baseURI();
1326     return bytes(currentBaseURI).length > 0
1327         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1328         : "";
1329   }
1330 
1331   //only owner
1332   
1333   function setCost(uint256 _newCost) external onlyOwner {
1334     cost = _newCost;
1335   }
1336 
1337   function setmaxMintAmount(uint256 _newmaxMintAmount) external onlyOwner {
1338     maxMintAmount = _newmaxMintAmount;
1339   }
1340   
1341 
1342   function setBaseURI(string memory _newBaseURI) external onlyOwner {
1343     baseURI = _newBaseURI;
1344   }
1345 
1346   function setBaseExtension(string memory _newBaseExtension) external onlyOwner {
1347     baseExtension = _newBaseExtension;
1348   }
1349 
1350   function SalePaused(bool _state) external onlyOwner {
1351     paused = _state;
1352   }
1353 
1354 
1355     function withdraw() external onlyOwner {
1356         (bool success, ) = payable(msg.sender).call{
1357             value: address(this).balance
1358         }("");
1359         require(success, "Transfer failed.");
1360     }
1361 
1362 }