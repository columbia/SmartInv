1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.14;
3 
4 /*
5 
6 ██████████████████████████████████████████████████████████████████████████████████████████
7 ██████████████████████████████████████████████████████████████████████████████████████████
8 ██████████████████████████████████████████████████████████████████████████████████████████
9 ██████████████████████████████████████████████████████████████████████████████████████████
10 ██████████████████████████████████████████████████████████████████████████████████████████
11 ██████████████████████████████████████████████████████████████████████████████████████████
12 ██████████████████████████████████████████████████████████████▓▒▒░░▒██████████████████████
13 ██████████████████████████████████████████████████████████▓▒░░░░▒░░░░█████████████████████
14 ██████████████████████████████████████████████████████▓▒░░░░░░░░▓██▓░░████████████████████
15 ██████████████████████████████████████████████████▓▒░░░░░░░░░░▒█▓▓██▓░▒███████████████████
16 █████████████████████████████████████████████████░░░░░░░░░░░▒██▒░▒▓▓░▒████████████████████
17 █████████████████████████████████████████████████▓░░░░░░░░░▓█████▒░▒██████████████████████
18 ████████████████████████████████████████████░░░░░░░░░░░░░░░███████████████████████████████
19 ██████████████████████████████████████████▓░░░░░░░░░░░░░░░░░██████████████████████████████
20 █████████████████████████▓▒▒▓█▓▓█████████░░▒▒▒░░░░░░░░░░░░▒▒▓█████████████████████████████
21 ████████████████████████▓░░░░░▓▒░░░░▒▒▓▓▓░░░░░▒▒▒▒░░▒▒▒▒░░░░░█████████████████████████████
22 ██████████████████████████▓░░░░▒▓░░░░░░░░▒▓▒░░░░░░▒▓▓▒▒▓█▓▒▒▒█████████████████████████████
23 ███████████████████████████████▓▓█▓░░░░░░░░░▒▓▒░░░░▓░░░░▓▒░░░░████████████████████████████
24 ███████████████████████████████▒░░▒▓░░░░░░░░░░▒▓▓▒░▓▒▒░▒▓░░░░░▒███████████████████████████
25 ██████████████████████████████░░▒▓███▓░░░░░░░░░░░░▒▒▓▓▓▓▒▒▒▒▒▒▒███████████████████████████
26 █████████████████████████████▒░▒█▒███▒▒▓░░░░░░░░░░░░░░░░░░░░░░░░▒█████████████████████████
27 █████████████████████████████░▒█▒████░░█▓▓▓▒░░░░░░░░░░░░░░░░░░░░░░▒███████████████████████
28 ████████████████████████████▒▒█▒████▓░░█░██████▓▓▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░▓█████████████████████
29 ███████████████████████████▓░░▓▓██▓▒░░░█▒██████▒░░░█░░░░░░░▓▓▒▒▒░░░░░▓████████████████████
30 ██████████████████████████▒░░░░░░░░░░░░░▓▓██▓▓░░░░░█░░░░░░░░░▒▓░░░░░░░░███████████████████
31 █████████████████████████▒░░▓▓███▓▒░░░░░░░░░░░░░░░░▓░░░░░░░░░░░▓█▒░░░▒████████████████████
32 █████████████████████████▓░▒█▓█████░░░░░░░░░░░░░░░░░▒▓▒▒▒░░░░░▒███████████████████████████
33 ██████████████████████████░█▓▓████▒░░░░░░░░░░░░░░▒▓▓▓▒▒░░▒▓▓▒▓████████████████████████████
34 ████████████████████████▓░░█▒███▓░░░░░░░░░░░░░░░█▒░░░▓▓▒▓█████████████████████████████████
35 ██████████████████████▓░░░░░▒▒░░░░░░░░░░░░░░░░▓▓░░░░▓▒░░██████████████████████████████████
36 ██████████████████████▒▒▒▒░░░░░░░░░░░░░░░░░░░█░░░░░▓▒░░▓██████████████████████████████████
37 █████████████████████▒▓░▓░▓▓▒▓▒▒▒▒░░░░░░▒▒▒▒░█░░░░░█░░░▓██████████████████████████████████
38 ████████████████████▓▓█▓▓▓▓▒▒▓▒▓░░█▒▒▓▒█▒█▒▓░█▒▒▒▒▒░░░░▓██████████████████████████████████
39 █████████████████████▓▓░▓░░▓▓░░▓░▒█▓█▓▓█▒█▒█▒░░░░░░░░░░▓██████████████████████████████████
40 █████████████████████▒▒▒▓▒▓▒░░░█▓▓░░█░▒▓▒▒▒░░░░░░░░░░░▒███████████████████████████████████
41 ██████████████████████▒░░░░▒▒▒▒▒░▒▒▒░▒▒░░░░░░░░░░░░░░▒████████████████████████████████████
42 ███████████████████████▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓█████████████████████████████████████
43 █████████████████████████▓▒▒░░░░░░░░░░░░░▒▓▓▓▓████████████████████████████████████████████
44 ██████████████████████████████████████████████████████████████████████████████████████████
45 ██████████████████████████████████████████████████████████████████████████████████████████
46 ██████████████████████████████████████████████████████████████████████████████████████████
47 ██████████████████████████████████████████████████████████████████████████████████████████
48 ██████████████████████████████████████████████████████████████████████████████████████████
49 ██████████████████████████████████████████████████████████████████████████████████████████
50 ██████████████████████████████████████████████████████████████████████████████████████████
51 
52 
53 */
54 
55 /**
56  * @dev String operations.
57  */
58 library Strings {
59     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
60 
61     /**
62      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
63      */
64     function toString(uint256 value) internal pure returns (string memory) {
65         // Inspired by OraclizeAPI's implementation - MIT licence
66         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
67 
68         if (value == 0) {
69             return "0";
70         }
71         uint256 temp = value;
72         uint256 digits;
73         while (temp != 0) {
74             digits++;
75             temp /= 10;
76         }
77         bytes memory buffer = new bytes(digits);
78         while (value != 0) {
79             digits -= 1;
80             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
81             value /= 10;
82         }
83         return string(buffer);
84     }
85 
86     /**
87      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
88      */
89     function toHexString(uint256 value) internal pure returns (string memory) {
90         if (value == 0) {
91             return "0x00";
92         }
93         uint256 temp = value;
94         uint256 length = 0;
95         while (temp != 0) {
96             length++;
97             temp >>= 8;
98         }
99         return toHexString(value, length);
100     }
101 
102     /**
103      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
104      */
105     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
106         bytes memory buffer = new bytes(2 * length + 2);
107         buffer[0] = "0";
108         buffer[1] = "x";
109         for (uint256 i = 2 * length + 1; i > 1; --i) {
110             buffer[i] = _HEX_SYMBOLS[value & 0xf];
111             value >>= 4;
112         }
113         require(value == 0, "Strings: hex length insufficient");
114         return string(buffer);
115     }
116 }
117 
118 // Context.sol
119 /**
120  * @dev Provides information about the current execution context, including the
121  * sender of the transaction and its data. While these are generally available
122  * via msg.sender and msg.data, they should not be accessed in such a direct
123  * manner, since when dealing with meta-transactions the account sending and
124  * paying for execution may not be the actual sender (as far as an application
125  * is concerned).
126  *
127  * This contract is only required for intermediate, library-like contracts.
128  */
129 abstract contract Context {
130     function _msgSender() internal view virtual returns (address) {
131         return msg.sender;
132     }
133 
134     function _msgData() internal view virtual returns (bytes calldata) {
135         return msg.data;
136     }
137 }
138 
139 
140 // Ownable.sol
141 /**
142  * @dev Contract module which provides a basic access control mechanism, where
143  * there is an account (an owner) that can be granted exclusive access to
144  * specific functions.
145  *
146  * By default, the owner account will be the one that deploys the contract. This
147  * can later be changed with {transferOwnership}.
148  *
149  * This module is used through inheritance. It will make available the modifier
150  * `onlyOwner`, which can be applied to your functions to restrict their use to
151  * the owner.
152  */
153 abstract contract Ownable is Context {
154     address private _owner;
155 
156     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
157 
158     /**
159      * @dev Initializes the contract setting the deployer as the initial owner.
160      */
161     constructor() {
162         _setOwner(_msgSender());
163     }
164 
165     /**
166      * @dev Returns the address of the current owner.
167      */
168     function owner() public view virtual returns (address) {
169         return _owner;
170     }
171 
172     /**
173      * @dev Throws if called by any account other than the owner.
174      */
175     modifier onlyOwner() {
176         require(owner() == _msgSender(), "Ownable: caller is not the owner");
177         _;
178     }
179 
180     /**
181      * @dev Leaves the contract without owner. It will not be possible to call
182      * `onlyOwner` functions anymore. Can only be called by the current owner.
183      *
184      * NOTE: Renouncing ownership will leave the contract without an owner,
185      * thereby removing any functionality that is only available to the owner.
186      */
187     function renounceOwnership() public virtual onlyOwner {
188         _setOwner(address(0));
189     }
190 
191     /**
192      * @dev Transfers ownership of the contract to a new account (`newOwner`).
193      * Can only be called by the current owner.
194      */
195     function transferOwnership(address newOwner) public virtual onlyOwner {
196         require(newOwner != address(0), "Ownable: new owner is the zero address");
197         _setOwner(newOwner);
198     }
199 
200     function _setOwner(address newOwner) private {
201         address oldOwner = _owner;
202         _owner = newOwner;
203         emit OwnershipTransferred(oldOwner, newOwner);
204     }
205 }
206 
207 // Address.sol
208 /**
209  * @dev Collection of functions related to the address type
210  */
211 library Address {
212     /**
213      * @dev Returns true if `account` is a contract.
214      *
215      * [IMPORTANT]
216      * ====
217      * It is unsafe to assume that an address for which this function returns
218      * false is an externally-owned account (EOA) and not a contract.
219      *
220      * Among others, `isContract` will return false for the following
221      * types of addresses:
222      *
223      *  - an externally-owned account
224      *  - a contract in construction
225      *  - an address where a contract will be created
226      *  - an address where a contract lived, but was destroyed
227      * ====
228      */
229     function isContract(address account) internal view returns (bool) {
230         // This method relies on extcodesize, which returns 0 for contracts in
231         // construction, since the code is only stored at the end of the
232         // constructor execution.
233 
234         uint256 size;
235         assembly {
236             size := extcodesize(account)
237         }
238         return size > 0;
239     }
240 
241     /**
242      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
243      * `recipient`, forwarding all available gas and reverting on errors.
244      *
245      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
246      * of certain opcodes, possibly making contracts go over the 2300 gas limit
247      * imposed by `transfer`, making them unable to receive funds via
248      * `transfer`. {sendValue} removes this limitation.
249      *
250      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
251      *
252      * IMPORTANT: because control is transferred to `recipient`, care must be
253      * taken to not create reentrancy vulnerabilities. Consider using
254      * {ReentrancyGuard} or the
255      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
256      */
257     function sendValue(address payable recipient, uint256 amount) internal {
258         require(address(this).balance >= amount, "Address: insufficient balance");
259 
260         (bool success, ) = recipient.call{value: amount}("");
261         require(success, "Address: unable to send value, recipient may have reverted");
262     }
263 
264     /**
265      * @dev Performs a Solidity function call using a low level `call`. A
266      * plain `call` is an unsafe replacement for a function call: use this
267      * function instead.
268      *
269      * If `target` reverts with a revert reason, it is bubbled up by this
270      * function (like regular Solidity function calls).
271      *
272      * Returns the raw returned data. To convert to the expected return value,
273      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
274      *
275      * Requirements:
276      *
277      * - `target` must be a contract.
278      * - calling `target` with `data` must not revert.
279      *
280      * _Available since v3.1._
281      */
282     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
283         return functionCall(target, data, "Address: low-level call failed");
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
288      * `errorMessage` as a fallback revert reason when `target` reverts.
289      *
290      * _Available since v3.1._
291      */
292     function functionCall(
293         address target,
294         bytes memory data,
295         string memory errorMessage
296     ) internal returns (bytes memory) {
297         return functionCallWithValue(target, data, 0, errorMessage);
298     }
299 
300     /**
301      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
302      * but also transferring `value` wei to `target`.
303      *
304      * Requirements:
305      *
306      * - the calling contract must have an ETH balance of at least `value`.
307      * - the called Solidity function must be `payable`.
308      *
309      * _Available since v3.1._
310      */
311     function functionCallWithValue(
312         address target,
313         bytes memory data,
314         uint256 value
315     ) internal returns (bytes memory) {
316         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
321      * with `errorMessage` as a fallback revert reason when `target` reverts.
322      *
323      * _Available since v3.1._
324      */
325     function functionCallWithValue(
326         address target,
327         bytes memory data,
328         uint256 value,
329         string memory errorMessage
330     ) internal returns (bytes memory) {
331         require(address(this).balance >= value, "Address: insufficient balance for call");
332         require(isContract(target), "Address: call to non-contract");
333 
334         (bool success, bytes memory returndata) = target.call{value: value}(data);
335         return _verifyCallResult(success, returndata, errorMessage);
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
340      * but performing a static call.
341      *
342      * _Available since v3.3._
343      */
344     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
345         return functionStaticCall(target, data, "Address: low-level static call failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
350      * but performing a static call.
351      *
352      * _Available since v3.3._
353      */
354     function functionStaticCall(
355         address target,
356         bytes memory data,
357         string memory errorMessage
358     ) internal view returns (bytes memory) {
359         require(isContract(target), "Address: static call to non-contract");
360 
361         (bool success, bytes memory returndata) = target.staticcall(data);
362         return _verifyCallResult(success, returndata, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but performing a delegate call.
368      *
369      * _Available since v3.4._
370      */
371     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
372         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
377      * but performing a delegate call.
378      *
379      * _Available since v3.4._
380      */
381     function functionDelegateCall(
382         address target,
383         bytes memory data,
384         string memory errorMessage
385     ) internal returns (bytes memory) {
386         require(isContract(target), "Address: delegate call to non-contract");
387 
388         (bool success, bytes memory returndata) = target.delegatecall(data);
389         return _verifyCallResult(success, returndata, errorMessage);
390     }
391 
392     function _verifyCallResult(
393         bool success,
394         bytes memory returndata,
395         string memory errorMessage
396     ) private pure returns (bytes memory) {
397         if (success) {
398             return returndata;
399         } else {
400             // Look for revert reason and bubble it up if present
401             if (returndata.length > 0) {
402                 // The easiest way to bubble the revert reason is using memory via assembly
403 
404                 assembly {
405                     let returndata_size := mload(returndata)
406                     revert(add(32, returndata), returndata_size)
407                 }
408             } else {
409                 revert(errorMessage);
410             }
411         }
412     }
413 }
414 
415 // IERC721Receiver.sol
416 /**
417  * @title ERC721 token receiver interface
418  * @dev Interface for any contract that wants to support safeTransfers
419  * from ERC721 asset contracts.
420  */
421 interface IERC721Receiver {
422     /**
423      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
424      * by `operator` from `from`, this function is called.
425      *
426      * It must return its Solidity selector to confirm the token transfer.
427      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
428      *
429      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
430      */
431     function onERC721Received(
432         address operator,
433         address from,
434         uint256 tokenId,
435         bytes calldata data
436     ) external returns (bytes4);
437 }
438 
439 // IERC165.sol
440 /**
441  * @dev Interface of the ERC165 standard, as defined in the
442  * https://eips.ethereum.org/EIPS/eip-165[EIP].
443  *
444  * Implementers can declare support of contract interfaces, which can then be
445  * queried by others ({ERC165Checker}).
446  *
447  * For an implementation, see {ERC165}.
448  */
449 interface IERC165 {
450     /**
451      * @dev Returns true if this contract implements the interface defined by
452      * `interfaceId`. See the corresponding
453      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
454      * to learn more about how these ids are created.
455      *
456      * This function call must use less than 30 000 gas.
457      */
458     function supportsInterface(bytes4 interfaceId) external view returns (bool);
459 }
460 
461 // ERC165.sol
462 /**
463  * @dev Implementation of the {IERC165} interface.
464  *
465  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
466  * for the additional interface id that will be supported. For example:
467  *
468  * ```solidity
469  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
470  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
471  * }
472  * ```
473  *
474  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
475  */
476 abstract contract ERC165 is IERC165 {
477     /**
478      * @dev See {IERC165-supportsInterface}.
479      */
480     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
481         return interfaceId == type(IERC165).interfaceId;
482     }
483 }
484 
485 // IERC721.sol
486 /**
487  * @dev Required interface of an ERC721 compliant contract.
488  */
489 interface IERC721 is IERC165 {
490     /**
491      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
492      */
493     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
494 
495     /**
496      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
497      */
498     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
499 
500     /**
501      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
502      */
503     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
504 
505     /**
506      * @dev Returns the number of tokens in ``owner``'s account.
507      */
508     function balanceOf(address owner) external view returns (uint256 balance);
509 
510     /**
511      * @dev Returns the owner of the `tokenId` token.
512      *
513      * Requirements:
514      *
515      * - `tokenId` must exist.
516      */
517     function ownerOf(uint256 tokenId) external view returns (address owner);
518 
519     /**
520      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
521      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
522      *
523      * Requirements:
524      *
525      * - `from` cannot be the zero address.
526      * - `to` cannot be the zero address.
527      * - `tokenId` token must exist and be owned by `from`.
528      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
529      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
530      *
531      * Emits a {Transfer} event.
532      */
533     function safeTransferFrom(
534         address from,
535         address to,
536         uint256 tokenId
537     ) external;
538 
539     /**
540      * @dev Transfers `tokenId` token from `from` to `to`.
541      *
542      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
543      *
544      * Requirements:
545      *
546      * - `from` cannot be the zero address.
547      * - `to` cannot be the zero address.
548      * - `tokenId` token must be owned by `from`.
549      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
550      *
551      * Emits a {Transfer} event.
552      */
553     function transferFrom(
554         address from,
555         address to,
556         uint256 tokenId
557     ) external;
558 
559     /**
560      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
561      * The approval is cleared when the token is transferred.
562      *
563      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
564      *
565      * Requirements:
566      *
567      * - The caller must own the token or be an approved operator.
568      * - `tokenId` must exist.
569      *
570      * Emits an {Approval} event.
571      */
572     function approve(address to, uint256 tokenId) external;
573 
574     /**
575      * @dev Returns the account approved for `tokenId` token.
576      *
577      * Requirements:
578      *
579      * - `tokenId` must exist.
580      */
581     function getApproved(uint256 tokenId) external view returns (address operator);
582 
583     /**
584      * @dev Approve or remove `operator` as an operator for the caller.
585      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
586      *
587      * Requirements:
588      *
589      * - The `operator` cannot be the caller.
590      *
591      * Emits an {ApprovalForAll} event.
592      */
593     function setApprovalForAll(address operator, bool _approved) external;
594 
595     /**
596      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
597      *
598      * See {setApprovalForAll}
599      */
600     function isApprovedForAll(address owner, address operator) external view returns (bool);
601 
602     /**
603      * @dev Safely transfers `tokenId` token from `from` to `to`.
604      *
605      * Requirements:
606      *
607      * - `from` cannot be the zero address.
608      * - `to` cannot be the zero address.
609      * - `tokenId` token must exist and be owned by `from`.
610      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
611      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
612      *
613      * Emits a {Transfer} event.
614      */
615     function safeTransferFrom(
616         address from,
617         address to,
618         uint256 tokenId,
619         bytes calldata data
620     ) external;
621 }
622 
623 // IERC721Enumerable.sol
624 /**
625  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
626  * @dev See https://eips.ethereum.org/EIPS/eip-721
627  */
628 interface IERC721Enumerable is IERC721 {
629     /**
630      * @dev Returns the total amount of tokens stored by the contract.
631      */
632     function totalSupply() external view returns (uint256);
633 
634     /**
635      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
636      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
637      */
638     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
639 
640     /**
641      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
642      * Use along with {totalSupply} to enumerate all tokens.
643      */
644     function tokenByIndex(uint256 index) external view returns (uint256);
645 }
646 
647 // IERC721Metadata.sol
648 /**
649  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
650  * @dev See https://eips.ethereum.org/EIPS/eip-721
651  */
652 interface IERC721Metadata is IERC721 {
653     /**
654      * @dev Returns the token collection name.
655      */
656     function name() external view returns (string memory);
657 
658     /**
659      * @dev Returns the token collection symbol.
660      */
661     function symbol() external view returns (string memory);
662 
663     /**
664      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
665      */
666     function tokenURI(uint256 tokenId) external view returns (string memory);
667 }
668 
669 // ERC721A.sol
670 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
671     using Address for address;
672     using Strings for uint256;
673 
674     struct TokenOwnership {
675         address addr;
676         uint64 startTimestamp;
677     }
678 
679     struct AddressData {
680         uint128 balance;
681         uint128 numberMinted;
682     }
683 
684     uint256 internal currentIndex = 1;
685 
686     // Token name
687     string private _name;
688 
689     // Token symbol
690     string private _symbol;
691 
692     // Mapping from token ID to ownership details
693     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
694     mapping(uint256 => TokenOwnership) internal _ownerships;
695 
696     // Mapping owner address to address data
697     mapping(address => AddressData) private _addressData;
698 
699     // Mapping from token ID to approved address
700     mapping(uint256 => address) private _tokenApprovals;
701 
702     // Mapping from owner to operator approvals
703     mapping(address => mapping(address => bool)) private _operatorApprovals;
704 
705     constructor(string memory name_, string memory symbol_) {
706         _name = name_;
707         _symbol = symbol_;
708     }
709 
710     /**
711      * @dev See {IERC721Enumerable-totalSupply}.
712      */
713     function totalSupply() public view override returns (uint256) {
714         return currentIndex-1;
715     }
716 
717     /**
718      * @dev See {IERC721Enumerable-tokenByIndex}.
719      */
720     function tokenByIndex(uint256 index) public view override returns (uint256) {
721         require(index < totalSupply(), 'ERC721A: global index out of bounds');
722         return index;
723     }
724 
725     /**
726      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
727      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
728      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
729      */
730     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
731         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
732         uint256 numMintedSoFar = totalSupply();
733         uint256 tokenIdsIdx;
734         address currOwnershipAddr;
735 
736         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
737         unchecked {
738             for (uint256 i; i < numMintedSoFar; i++) {
739                 TokenOwnership memory ownership = _ownerships[i];
740                 if (ownership.addr != address(0)) {
741                     currOwnershipAddr = ownership.addr;
742                 }
743                 if (currOwnershipAddr == owner) {
744                     if (tokenIdsIdx == index) {
745                         return i;
746                     }
747                     tokenIdsIdx++;
748                 }
749             }
750         }
751 
752         revert('ERC721A: unable to get token of owner by index');
753     }
754 
755     /**
756      * @dev See {IERC165-supportsInterface}.
757      */
758     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
759         return
760             interfaceId == type(IERC721).interfaceId ||
761             interfaceId == type(IERC721Metadata).interfaceId ||
762             interfaceId == type(IERC721Enumerable).interfaceId ||
763             super.supportsInterface(interfaceId);
764     }
765 
766     /**
767      * @dev See {IERC721-balanceOf}.
768      */
769     function balanceOf(address owner) public view override returns (uint256) {
770         require(owner != address(0), 'ERC721A: balance query for the zero address');
771         return uint256(_addressData[owner].balance);
772     }
773 
774     function _numberMinted(address owner) internal view returns (uint256) {
775         require(owner != address(0), 'ERC721A: number minted query for the zero address');
776         return uint256(_addressData[owner].numberMinted);
777     }
778 
779     /**
780      * Gas spent here starts off proportional to the maximum mint batch size.
781      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
782      */
783     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
784         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
785 
786         unchecked {
787             for (uint256 curr = tokenId; curr >= 0; curr--) {
788                 TokenOwnership memory ownership = _ownerships[curr];
789                 if (ownership.addr != address(0)) {
790                     return ownership;
791                 }
792             }
793         }
794 
795         revert('ERC721A: unable to determine the owner of token');
796     }
797 
798     /**
799      * @dev See {IERC721-ownerOf}.
800      */
801     function ownerOf(uint256 tokenId) public view override returns (address) {
802         return ownershipOf(tokenId).addr;
803     }
804 
805     /**
806      * @dev See {IERC721Metadata-name}.
807      */
808     function name() public view virtual override returns (string memory) {
809         return _name;
810     }
811 
812     /**
813      * @dev See {IERC721Metadata-symbol}.
814      */
815     function symbol() public view virtual override returns (string memory) {
816         return _symbol;
817     }
818 
819     /**
820      * @dev See {IERC721Metadata-tokenURI}.
821      */
822     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
823         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
824 
825         string memory baseURI = _baseURI();
826         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
827     }
828 
829     /**
830      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
831      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
832      * by default, can be overriden in child contracts.
833      */
834     function _baseURI() internal view virtual returns (string memory) {
835         return '';
836     }
837 
838     /**
839      * @dev See {IERC721-approve}.
840      */
841     function approve(address to, uint256 tokenId) public override {
842         address owner = ERC721A.ownerOf(tokenId);
843         require(to != owner, 'ERC721A: approval to current owner');
844 
845         require(
846             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
847             'ERC721A: approve caller is not owner nor approved for all'
848         );
849 
850         _approve(to, tokenId, owner);
851     }
852 
853     /**
854      * @dev See {IERC721-getApproved}.
855      */
856     function getApproved(uint256 tokenId) public view override returns (address) {
857         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
858 
859         return _tokenApprovals[tokenId];
860     }
861 
862     /**
863      * @dev See {IERC721-setApprovalForAll}.
864      */
865     function setApprovalForAll(address operator, bool approved) public override {
866         require(operator != _msgSender(), 'ERC721A: approve to caller');
867 
868         _operatorApprovals[_msgSender()][operator] = approved;
869         emit ApprovalForAll(_msgSender(), operator, approved);
870     }
871 
872     /**
873      * @dev See {IERC721-isApprovedForAll}.
874      */
875     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
876         return _operatorApprovals[owner][operator];
877     }
878 
879     /**
880      * @dev See {IERC721-transferFrom}.
881      */
882     function transferFrom(
883         address from,
884         address to,
885         uint256 tokenId
886     ) public override {
887         _transfer(from, to, tokenId);
888     }
889 
890     /**
891      * @dev See {IERC721-safeTransferFrom}.
892      */
893     function safeTransferFrom(
894         address from,
895         address to,
896         uint256 tokenId
897     ) public override {
898         safeTransferFrom(from, to, tokenId, '');
899     }
900 
901     /**
902      * @dev See {IERC721-safeTransferFrom}.
903      */
904     function safeTransferFrom(
905         address from,
906         address to,
907         uint256 tokenId,
908         bytes memory _data
909     ) public override {
910         _transfer(from, to, tokenId);
911         require(
912             _checkOnERC721Received(from, to, tokenId, _data),
913             'ERC721A: transfer to non ERC721Receiver implementer'
914         );
915     }
916 
917     /**
918      * @dev Returns whether `tokenId` exists.
919      *
920      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
921      *
922      * Tokens start existing when they are minted (`_mint`),
923      */
924     function _exists(uint256 tokenId) internal view returns (bool) {
925         return tokenId < currentIndex;
926     }
927 
928     function _safeMint(address to, uint256 quantity) internal {
929         _safeMint(to, quantity, '');
930     }
931 
932     /**
933      * @dev Safely mints `quantity` tokens and transfers them to `to`.
934      *
935      * Requirements:
936      *
937      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
938      * - `quantity` must be greater than 0.
939      *
940      * Emits a {Transfer} event.
941      */
942     function _safeMint(
943         address to,
944         uint256 quantity,
945         bytes memory _data
946     ) internal {
947         _mint(to, quantity, _data, true);
948     }
949 
950 
951     function _mint(
952         address to,
953         uint256 quantity,
954         bytes memory _data,
955         bool safe
956     ) internal {
957         uint256 startTokenId = currentIndex;
958         require(to != address(0), 'ERC721A: mint to the zero address');
959         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
960 
961         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
962 
963         // Overflows are incredibly unrealistic.
964         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
965         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
966         unchecked {
967             _addressData[to].balance += uint128(quantity);
968             _addressData[to].numberMinted += uint128(quantity);
969 
970             _ownerships[startTokenId].addr = to;
971             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
972 
973             uint256 updatedIndex = startTokenId;
974 
975             for (uint256 i; i < quantity; i++) {
976                 emit Transfer(address(0), to, updatedIndex);
977                 if (safe) {
978                     require(
979                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
980                         'ERC721A: transfer to non ERC721Receiver implementer'
981                     );
982                 }
983 
984                 updatedIndex++;
985             }
986 
987             currentIndex = updatedIndex;
988         }
989 
990         _afterTokenTransfers(address(0), to, startTokenId, quantity);
991     }
992 
993     /**
994      * @dev Transfers `tokenId` from `from` to `to`.
995      *
996      * Requirements:
997      *
998      * - `to` cannot be the zero address.
999      * - `tokenId` token must be owned by `from`.
1000      *
1001      * Emits a {Transfer} event.
1002      */
1003     function _transfer(
1004         address from,
1005         address to,
1006         uint256 tokenId
1007     ) private {
1008         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1009 
1010         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1011             getApproved(tokenId) == _msgSender() ||
1012             isApprovedForAll(prevOwnership.addr, _msgSender()));
1013 
1014         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1015 
1016         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1017         require(to != address(0), 'ERC721A: transfer to the zero address');
1018 
1019         _beforeTokenTransfers(from, to, tokenId, 1);
1020 
1021         // Clear approvals from the previous owner
1022         _approve(address(0), tokenId, prevOwnership.addr);
1023 
1024         // Underflow of the sender's balance is impossible because we check for
1025         // ownership above and the recipient's balance can't realistically overflow.
1026         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1027         unchecked {
1028             _addressData[from].balance -= 1;
1029             _addressData[to].balance += 1;
1030 
1031             _ownerships[tokenId].addr = to;
1032             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1033 
1034             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1035             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1036             uint256 nextTokenId = tokenId + 1;
1037             if (_ownerships[nextTokenId].addr == address(0)) {
1038                 if (_exists(nextTokenId)) {
1039                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1040                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1041                 }
1042             }
1043         }
1044 
1045         emit Transfer(from, to, tokenId);
1046         _afterTokenTransfers(from, to, tokenId, 1);
1047     }
1048 
1049     /**
1050      * @dev Approve `to` to operate on `tokenId`
1051      *
1052      * Emits a {Approval} event.
1053      */
1054     function _approve(
1055         address to,
1056         uint256 tokenId,
1057         address owner
1058     ) private {
1059         _tokenApprovals[tokenId] = to;
1060         emit Approval(owner, to, tokenId);
1061     }
1062 
1063     /**
1064      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1065      * The call is not executed if the target address is not a contract.
1066      *
1067      * @param from address representing the previous owner of the given token ID
1068      * @param to target address that will receive the tokens
1069      * @param tokenId uint256 ID of the token to be transferred
1070      * @param _data bytes optional data to send along with the call
1071      * @return bool whether the call correctly returned the expected magic value
1072      */
1073     function _checkOnERC721Received(
1074         address from,
1075         address to,
1076         uint256 tokenId,
1077         bytes memory _data
1078     ) private returns (bool) {
1079         if (to.isContract()) {
1080             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1081                 return retval == IERC721Receiver(to).onERC721Received.selector;
1082             } catch (bytes memory reason) {
1083                 if (reason.length == 0) {
1084                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1085                 } else {
1086                     assembly {
1087                         revert(add(32, reason), mload(reason))
1088                     }
1089                 }
1090             }
1091         } else {
1092             return true;
1093         }
1094     }
1095 
1096     /**
1097      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1098      *
1099      * startTokenId - the first token id to be transferred
1100      * quantity - the amount to be transferred
1101      *
1102      * Calling conditions:
1103      *
1104      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1105      * transferred to `to`.
1106      * - When `from` is zero, `tokenId` will be minted for `to`.
1107      */
1108     function _beforeTokenTransfers(
1109         address from,
1110         address to,
1111         uint256 startTokenId,
1112         uint256 quantity
1113     ) internal virtual {}
1114 
1115     /**
1116      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1117      * minting.
1118      *
1119      * startTokenId - the first token id to be transferred
1120      * quantity - the amount to be transferred
1121      *
1122      * Calling conditions:
1123      *
1124      * - when `from` and `to` are both non-zero.
1125      * - `from` and `to` are never both zero.
1126      */
1127     function _afterTokenTransfers(
1128         address from,
1129         address to,
1130         uint256 startTokenId,
1131         uint256 quantity
1132     ) internal virtual {}
1133 }
1134 
1135 contract SpookyApeHauntedClub is ERC721A, Ownable {
1136     
1137     uint256 MAX_SUPPLY = 10000;
1138     uint256 Allremain = 10000;
1139     uint256 public mintRate = 0.0035 ether; 
1140     uint256 MintForWallet = 10000;
1141     string public base_URI = "";
1142     string public baseExtension = ".json";
1143     string public prerevealURL = "ipfs://__CID__/" ;
1144     bool public start = true;
1145  
1146     mapping (address => uint256) private MintedBalance;
1147 
1148     constructor() ERC721A("Spooky Ape Haunted Club", "SAHC") {}
1149 
1150 
1151 
1152     function reveal(string memory url) external onlyOwner {
1153 		base_URI = url;
1154 	}
1155 
1156     function withdraw() external payable onlyOwner {
1157         payable(owner()).transfer(address(this).balance);
1158     }
1159 
1160     function _baseURI() internal view override returns (string memory) {
1161         return base_URI;
1162     }
1163 
1164 
1165     function pauseStartSwitch() public onlyOwner {
1166         start = !start;
1167     }
1168 
1169     function RemainingItem() public view returns (uint256) {
1170         return Allremain;
1171     }   
1172     
1173     function mint(uint256 quantity) public payable {
1174         require(start, "Sorry, Minting is paused.");
1175         require(quantity<=10 , "Sorry, there are only 10 items allowed for each minting.");
1176         require((totalSupply() + quantity) <= MAX_SUPPLY, "Sorry, There is no more items.");
1177         
1178         uint payforNum = quantity;
1179 
1180         if(MintedBalance[msg.sender] == 0){
1181             payforNum = payforNum - 1;
1182         }
1183 
1184         require(msg.value >= payforNum * mintRate, "Ether is not enough.");
1185 
1186 
1187         _safeMint(msg.sender, quantity);
1188         MintedBalance[msg.sender] = MintedBalance[msg.sender] + quantity;
1189         Allremain -= quantity;
1190     }
1191 
1192     function setRate(uint256 newRate) external onlyOwner {
1193         mintRate = newRate;
1194     }
1195     
1196     function walletOfOwner(address _owner)
1197         public
1198         view
1199         returns (uint256[] memory)
1200     {
1201         uint256 ownerTokenCount = balanceOf(_owner);
1202         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1203         for (uint256 i; i < ownerTokenCount; i++) {
1204         tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1205         }
1206         return tokenIds;
1207     }
1208 
1209     function tokenURI(uint256 tokenId)
1210     public
1211     view
1212     virtual
1213     override
1214     returns (string memory)
1215     {
1216         require(
1217         _exists(tokenId),
1218         "ERC721AMetadata: URI query for nonexistent token"
1219         );
1220         
1221 
1222         string memory currentBaseURI = _baseURI();
1223         return bytes(currentBaseURI).length > 0
1224             ? string(abi.encodePacked(currentBaseURI, Strings.toString(tokenId), baseExtension))
1225             : prerevealURL;
1226     }
1227 
1228 }