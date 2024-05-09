1 // SPDX-License-Identifier: MIT                                                                   
2 // ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
3 // ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
4 // ((((((/(((((((((((((((((((((((((/@@@@@@@@@@@@@(((((((((((((((@@@@@@@((((((((((((
5 // ((((((((((((((((((((((((((&@@@@@&&&%&&&&&&%&&&@@@@%(((((((((((((@@,#@/((((((((((
6 // (((((((((((((((((((((/@@@@%&&&&&&&&&&&&&&&&&&@@&&@@@@@@((((((((((@,,@@((((((((((
7 // (((((((((((((((((#@@@@&&&&&&&&&&&&&&&&&&&&&&&&&&&&@@@@@@@@@(((((@@@@((((((((((((
8 // (((((((((((((/@@@&&@%&%&&&&&&&&&&&&&&&&&&&&&&&&&%&&&&&&@@&@@@@@@((((((((((((((((
9 // ((((((((((((@&@&@&&&&&&&&&%&&&&%%%&@@@@@@@@@@@@@@@@@@@&&&%%%&&@@@@%(((((((((((((
10 // ((((((((((@@&&%&&&&&&&&&@@@@@@@@@&///////&@@@@@@@@@@&@@@@@@&&%&&&&@@@(((((((((((
11 // ((((((((@@@@&&&&&&&&%%&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&&@&@@((((((((((
12 // (((((((@@@@&&&&&&&%@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%@@@@@@@@&&@@@@/(((((/*(
13 // (((((((@@&@%&&&&%&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,    @@@@@@@@@#@@@%&@@@((((((((
14 // ((((((%&@@@@@&%&&@@@@&/@@     ,@ ,@@ @@&@@   .@@@      @@(&@@@@@#%@@@%@@@(((((((
15 // ((((((@%&%&&@@@@&&@@&/@@    %@@@      @@@@            @@(/(/&@@@@#%%@&&@@(((((((
16 // ((,(((@@&@@@@@@#%%@@@/@@              @@/@@@        @@@//////@@@@%##@@%@@&((,(((
17 // ((((((&@@@&&@@###%@@&/(@@            @@&&@@@@@@@@@@@@/(///////@@@@##@@%%@@((((((
18 // (((((((%@@@@@@&#%%@@%///#@@@     %@@@@,,,,,,%@@@/(////////////#@&&@@@%%@@@@((,/(
19 // ((%@@((((@@&@@@@%#@@@/////(/%@@@&(@&,,,,,,,,,,.@@@%////////////@@@&@&&@@@@@@((@@
20 // (((@@(((((@@@&&@@#&@@(////////////@@&@&@@@%@@@@&@@%////////////(@@%&&@@@@@@@@(((
21 // @@(@@&(@@((@@%@#@@&@@&////////////&@@,,.,,,,,.@@@&///////////#/%@@&@@@&(@&@@@%((
22 // (((((@((((((@@@%@&@@@@//////////////@&@@@@@@@@@/////////////(/@&&&@@@@&@@@@@@@@(
23 // (((((@@@(((((@@@@&@&@@@(///////////////(///(///////#//(///@&&&&@@@@@@@@@@((@((((
24 // (&@&%&@@@@@#(@@@@@@@&@@@@@////////(#(((/(/%%/////%/(#@@@&&&@@@@@@&&&&&&&@@@@@@@@
25 // (((((((@((((((@@&@%&@@@&&@@@@@@@@@@@@@@&@@@@@@@@@@@@@&&@@@@%#(@@&&&%%%%%%%&@@(((
26 // /@@@@(@@@(((@@@@@&&@@@@@@@@@@@@@@@@@@@@///(//%@@@&((((((((((((@@@@&&%%%%%%@@/(((
27 // ((((((@@@@@&%%%%@&&&&@@((((((((#&@@@@@///////&%%@@@#((((((((@@@@@@@@@&@@@@((((((
28 // (((((@@@@&%%%%%%&@&&&@%(((((((((/#@@@@////////&%@@@#@@@@@@%/(@@@&@&@@@@&((((((((
29 // (((((%#@@%%%%%%%&&&@@&#((((((((@@@&(@(////////#(/@@&(((((((#%%%#@@@@@%(@@%@@((((
30 // ((@%#@((@@@&&&&&@&@&&&&@@/@@@@@@(((@@////////(/(((@@((((((((((((/((((((@@/@@((((
31 // (@@%(/@(((#@&@@@%&&&&&@@@@#((((((((@@//////////(/(&@@((((((((((((((((/(@@@@@@@((
32 // (@@@@@@@((((((@@@@@@&((((((((((((((@@//////////%/((@@(((((((((((((((((((((((((((
33 // ((/((((((((((((((((((((((((((((((((@@//////////#%&(&@@((((((((((((((((((((((((((                
34                                                                                 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev String operations.
39  */
40 library Strings {
41     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
42     uint8 private constant _ADDRESS_LENGTH = 20;
43 
44     /**
45      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
46      */
47     function toString(uint256 value) internal pure returns (string memory) {
48         // Inspired by OraclizeAPI's implementation - MIT licence
49         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
50 
51         if (value == 0) {
52             return "0";
53         }
54         uint256 temp = value;
55         uint256 digits;
56         while (temp != 0) {
57             digits++;
58             temp /= 10;
59         }
60         bytes memory buffer = new bytes(digits);
61         while (value != 0) {
62             digits -= 1;
63             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
64             value /= 10;
65         }
66         return string(buffer);
67     }
68 
69     /**
70      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
71      */
72     function toHexString(uint256 value) internal pure returns (string memory) {
73         if (value == 0) {
74             return "0x00";
75         }
76         uint256 temp = value;
77         uint256 length = 0;
78         while (temp != 0) {
79             length++;
80             temp >>= 8;
81         }
82         return toHexString(value, length);
83     }
84 
85     /**
86      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
87      */
88     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
89         bytes memory buffer = new bytes(2 * length + 2);
90         buffer[0] = "0";
91         buffer[1] = "x";
92         for (uint256 i = 2 * length + 1; i > 1; --i) {
93             buffer[i] = _HEX_SYMBOLS[value & 0xf];
94             value >>= 4;
95         }
96         require(value == 0, "Strings: hex length insufficient");
97         return string(buffer);
98     }
99 
100     /**
101      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
102      */
103     function toHexString(address addr) internal pure returns (string memory) {
104         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
105     }
106 }
107 
108 // File: @openzeppelin/contracts/utils/Context.sol
109 
110 
111 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
112 
113 pragma solidity ^0.8.0;
114 
115 /**
116  * @dev Provides information about the current execution context, including the
117  * sender of the transaction and its data. While these are generally available
118  * via msg.sender and msg.data, they should not be accessed in such a direct
119  * manner, since when dealing with meta-transactions the account sending and
120  * paying for execution may not be the actual sender (as far as an application
121  * is concerned).
122  *
123  * This contract is only required for intermediate, library-like contracts.
124  */
125 abstract contract Context {
126     function _msgSender() internal view virtual returns (address) {
127         return msg.sender;
128     }
129 
130     function _msgData() internal view virtual returns (bytes calldata) {
131         return msg.data;
132     }
133 }
134 
135 // File: @openzeppelin/contracts/access/Ownable.sol
136 
137 
138 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
139 
140 pragma solidity ^0.8.0;
141 
142 
143 /**
144  * @dev Contract module which provides a basic access control mechanism, where
145  * there is an account (an owner) that can be granted exclusive access to
146  * specific functions.
147  *
148  * By default, the owner account will be the one that deploys the contract. This
149  * can later be changed with {transferOwnership}.
150  *
151  * This module is used through inheritance. It will make available the modifier
152  * `onlyOwner`, which can be applied to your functions to restrict their use to
153  * the owner.
154  */
155 abstract contract Ownable is Context {
156     address private _owner;
157 
158     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
159 
160     /**
161      * @dev Initializes the contract setting the deployer as the initial owner.
162      */
163     constructor() {
164         _transferOwnership(_msgSender());
165     }
166 
167     /**
168      * @dev Throws if called by any account other than the owner.
169      */
170     modifier onlyOwner() {
171         _checkOwner();
172         _;
173     }
174 
175     /**
176      * @dev Returns the address of the current owner.
177      */
178     function owner() public view virtual returns (address) {
179         return _owner;
180     }
181 
182     /**
183      * @dev Throws if the sender is not the owner.
184      */
185     function _checkOwner() internal view virtual {
186         require(owner() == _msgSender(), "Ownable: caller is not the owner");
187     }
188 
189     /**
190      * @dev Transfers ownership of the contract to a new account (`newOwner`).
191      * Can only be called by the current owner.
192      */
193     function transferOwnership(address newOwner) public virtual onlyOwner {
194         require(newOwner != address(0), "Ownable: new owner is the zero address");
195         _transferOwnership(newOwner);
196     }
197 
198     /**
199      * @dev Transfers ownership of the contract to a new account (`newOwner`).
200      * Internal function without access restriction.
201      */
202     function _transferOwnership(address newOwner) internal virtual {
203         address oldOwner = _owner;
204         _owner = newOwner;
205         emit OwnershipTransferred(oldOwner, newOwner);
206     }
207 }
208 
209 // File: @openzeppelin/contracts/utils/Address.sol
210 
211 
212 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
213 
214 pragma solidity ^0.8.1;
215 
216 /**
217  * @dev Collection of functions related to the address type
218  */
219 library Address {
220     /**
221      * @dev Returns true if `account` is a contract.
222      *
223      * [IMPORTANT]
224      * ====
225      * It is unsafe to assume that an address for which this function returns
226      * false is an externally-owned account (EOA) and not a contract.
227      *
228      * Among others, `isContract` will return false for the following
229      * types of addresses:
230      *
231      *  - an externally-owned account
232      *  - a contract in construction
233      *  - an address where a contract will be created
234      *  - an address where a contract lived, but was destroyed
235      * ====
236      *
237      * [IMPORTANT]
238      * ====
239      * You shouldn't rely on `isContract` to protect against flash loan attacks!
240      *
241      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
242      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
243      * constructor.
244      * ====
245      */
246     function isContract(address account) internal view returns (bool) {
247         // This method relies on extcodesize/address.code.length, which returns 0
248         // for contracts in construction, since the code is only stored at the end
249         // of the constructor execution.
250 
251         return account.code.length > 0;
252     }
253 
254     /**
255      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
256      * `recipient`, forwarding all available gas and reverting on errors.
257      *
258      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
259      * of certain opcodes, possibly making contracts go over the 2300 gas limit
260      * imposed by `transfer`, making them unable to receive funds via
261      * `transfer`. {sendValue} removes this limitation.
262      *
263      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
264      *
265      * IMPORTANT: because control is transferred to `recipient`, care must be
266      * taken to not create reentrancy vulnerabilities. Consider using
267      * {ReentrancyGuard} or the
268      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
269      */
270     function sendValue(address payable recipient, uint256 amount) internal {
271         require(address(this).balance >= amount, "Address: insufficient balance");
272 
273         (bool success, ) = recipient.call{value: amount}("");
274         require(success, "Address: unable to send value, recipient may have reverted");
275     }
276 
277     /**
278      * @dev Performs a Solidity function call using a low level `call`. A
279      * plain `call` is an unsafe replacement for a function call: use this
280      * function instead.
281      *
282      * If `target` reverts with a revert reason, it is bubbled up by this
283      * function (like regular Solidity function calls).
284      *
285      * Returns the raw returned data. To convert to the expected return value,
286      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
287      *
288      * Requirements:
289      *
290      * - `target` must be a contract.
291      * - calling `target` with `data` must not revert.
292      *
293      * _Available since v3.1._
294      */
295     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
296         return functionCall(target, data, "Address: low-level call failed");
297     }
298 
299     /**
300      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
301      * `errorMessage` as a fallback revert reason when `target` reverts.
302      *
303      * _Available since v3.1._
304      */
305     function functionCall(
306         address target,
307         bytes memory data,
308         string memory errorMessage
309     ) internal returns (bytes memory) {
310         return functionCallWithValue(target, data, 0, errorMessage);
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
315      * but also transferring `value` wei to `target`.
316      *
317      * Requirements:
318      *
319      * - the calling contract must have an ETH balance of at least `value`.
320      * - the called Solidity function must be `payable`.
321      *
322      * _Available since v3.1._
323      */
324     function functionCallWithValue(
325         address target,
326         bytes memory data,
327         uint256 value
328     ) internal returns (bytes memory) {
329         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
334      * with `errorMessage` as a fallback revert reason when `target` reverts.
335      *
336      * _Available since v3.1._
337      */
338     function functionCallWithValue(
339         address target,
340         bytes memory data,
341         uint256 value,
342         string memory errorMessage
343     ) internal returns (bytes memory) {
344         require(address(this).balance >= value, "Address: insufficient balance for call");
345         require(isContract(target), "Address: call to non-contract");
346 
347         (bool success, bytes memory returndata) = target.call{value: value}(data);
348         return verifyCallResult(success, returndata, errorMessage);
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
353      * but performing a static call.
354      *
355      * _Available since v3.3._
356      */
357     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
358         return functionStaticCall(target, data, "Address: low-level static call failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
363      * but performing a static call.
364      *
365      * _Available since v3.3._
366      */
367     function functionStaticCall(
368         address target,
369         bytes memory data,
370         string memory errorMessage
371     ) internal view returns (bytes memory) {
372         require(isContract(target), "Address: static call to non-contract");
373 
374         (bool success, bytes memory returndata) = target.staticcall(data);
375         return verifyCallResult(success, returndata, errorMessage);
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
380      * but performing a delegate call.
381      *
382      * _Available since v3.4._
383      */
384     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
385         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
390      * but performing a delegate call.
391      *
392      * _Available since v3.4._
393      */
394     function functionDelegateCall(
395         address target,
396         bytes memory data,
397         string memory errorMessage
398     ) internal returns (bytes memory) {
399         require(isContract(target), "Address: delegate call to non-contract");
400 
401         (bool success, bytes memory returndata) = target.delegatecall(data);
402         return verifyCallResult(success, returndata, errorMessage);
403     }
404 
405     /**
406      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
407      * revert reason using the provided one.
408      *
409      * _Available since v4.3._
410      */
411     function verifyCallResult(
412         bool success,
413         bytes memory returndata,
414         string memory errorMessage
415     ) internal pure returns (bytes memory) {
416         if (success) {
417             return returndata;
418         } else {
419             // Look for revert reason and bubble it up if present
420             if (returndata.length > 0) {
421                 // The easiest way to bubble the revert reason is using memory via assembly
422                 /// @solidity memory-safe-assembly
423                 assembly {
424                     let returndata_size := mload(returndata)
425                     revert(add(32, returndata), returndata_size)
426                 }
427             } else {
428                 revert(errorMessage);
429             }
430         }
431     }
432 }
433 
434 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
435 
436 
437 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
438 
439 pragma solidity ^0.8.0;
440 
441 /**
442  * @title ERC721 token receiver interface
443  * @dev Interface for any contract that wants to support safeTransfers
444  * from ERC721 asset contracts.
445  */
446 interface IERC721Receiver {
447     /**
448      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
449      * by `operator` from `from`, this function is called.
450      *
451      * It must return its Solidity selector to confirm the token transfer.
452      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
453      *
454      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
455      */
456     function onERC721Received(
457         address operator,
458         address from,
459         uint256 tokenId,
460         bytes calldata data
461     ) external returns (bytes4);
462 }
463 
464 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
465 
466 
467 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
468 
469 pragma solidity ^0.8.0;
470 
471 /**
472  * @dev Interface of the ERC165 standard, as defined in the
473  * https://eips.ethereum.org/EIPS/eip-165[EIP].
474  *
475  * Implementers can declare support of contract interfaces, which can then be
476  * queried by others ({ERC165Checker}).
477  *
478  * For an implementation, see {ERC165}.
479  */
480 interface IERC165 {
481     /**
482      * @dev Returns true if this contract implements the interface defined by
483      * `interfaceId`. See the corresponding
484      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
485      * to learn more about how these ids are created.
486      *
487      * This function call must use less than 30 000 gas.
488      */
489     function supportsInterface(bytes4 interfaceId) external view returns (bool);
490 }
491 
492 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
493 
494 
495 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
496 
497 pragma solidity ^0.8.0;
498 
499 
500 /**
501  * @dev Implementation of the {IERC165} interface.
502  *
503  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
504  * for the additional interface id that will be supported. For example:
505  *
506  * ```solidity
507  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
508  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
509  * }
510  * ```
511  *
512  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
513  */
514 abstract contract ERC165 is IERC165 {
515     /**
516      * @dev See {IERC165-supportsInterface}.
517      */
518     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
519         return interfaceId == type(IERC165).interfaceId;
520     }
521 }
522 
523 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
524 
525 
526 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
527 
528 pragma solidity ^0.8.0;
529 
530 
531 /**
532  * @dev Required interface of an ERC721 compliant contract.
533  */
534 interface IERC721 is IERC165 {
535     /**
536      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
537      */
538     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
539 
540     /**
541      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
542      */
543     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
544 
545     /**
546      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
547      */
548     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
549 
550     /**
551      * @dev Returns the number of tokens in ``owner``'s account.
552      */
553     function balanceOf(address owner) external view returns (uint256 balance);
554 
555     /**
556      * @dev Returns the owner of the `tokenId` token.
557      *
558      * Requirements:
559      *
560      * - `tokenId` must exist.
561      */
562     function ownerOf(uint256 tokenId) external view returns (address owner);
563 
564     /**
565      * @dev Safely transfers `tokenId` token from `from` to `to`.
566      *
567      * Requirements:
568      *
569      * - `from` cannot be the zero address.
570      * - `to` cannot be the zero address.
571      * - `tokenId` token must exist and be owned by `from`.
572      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
573      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
574      *
575      * Emits a {Transfer} event.
576      */
577     function safeTransferFrom(
578         address from,
579         address to,
580         uint256 tokenId,
581         bytes calldata data
582     ) external;
583 
584     /**
585      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
586      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
587      *
588      * Requirements:
589      *
590      * - `from` cannot be the zero address.
591      * - `to` cannot be the zero address.
592      * - `tokenId` token must exist and be owned by `from`.
593      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
594      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
595      *
596      * Emits a {Transfer} event.
597      */
598     function safeTransferFrom(
599         address from,
600         address to,
601         uint256 tokenId
602     ) external;
603 
604     /**
605      * @dev Transfers `tokenId` token from `from` to `to`.
606      *
607      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
608      *
609      * Requirements:
610      *
611      * - `from` cannot be the zero address.
612      * - `to` cannot be the zero address.
613      * - `tokenId` token must be owned by `from`.
614      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
615      *
616      * Emits a {Transfer} event.
617      */
618     function transferFrom(
619         address from,
620         address to,
621         uint256 tokenId
622     ) external;
623 
624     /**
625      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
626      * The approval is cleared when the token is transferred.
627      *
628      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
629      *
630      * Requirements:
631      *
632      * - The caller must own the token or be an approved operator.
633      * - `tokenId` must exist.
634      *
635      * Emits an {Approval} event.
636      */
637     function approve(address to, uint256 tokenId) external;
638 
639     /**
640      * @dev Approve or remove `operator` as an operator for the caller.
641      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
642      *
643      * Requirements:
644      *
645      * - The `operator` cannot be the caller.
646      *
647      * Emits an {ApprovalForAll} event.
648      */
649     function setApprovalForAll(address operator, bool _approved) external;
650 
651     /**
652      * @dev Returns the account approved for `tokenId` token.
653      *
654      * Requirements:
655      *
656      * - `tokenId` must exist.
657      */
658     function getApproved(uint256 tokenId) external view returns (address operator);
659 
660     /**
661      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
662      *
663      * See {setApprovalForAll}
664      */
665     function isApprovedForAll(address owner, address operator) external view returns (bool);
666 }
667 
668 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
669 
670 
671 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
672 
673 pragma solidity ^0.8.0;
674 
675 
676 /**
677  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
678  * @dev See https://eips.ethereum.org/EIPS/eip-721
679  */
680 interface IERC721Enumerable is IERC721 {
681     /**
682      * @dev Returns the total amount of tokens stored by the contract.
683      */
684     function totalSupply() external view returns (uint256);
685 
686     /**
687      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
688      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
689      */
690     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
691 
692     /**
693      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
694      * Use along with {totalSupply} to enumerate all tokens.
695      */
696     function tokenByIndex(uint256 index) external view returns (uint256);
697 }
698 
699 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
700 
701 
702 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
703 
704 pragma solidity ^0.8.0;
705 
706 
707 /**
708  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
709  * @dev See https://eips.ethereum.org/EIPS/eip-721
710  */
711 interface IERC721Metadata is IERC721 {
712     /**
713      * @dev Returns the token collection name.
714      */
715     function name() external view returns (string memory);
716 
717     /**
718      * @dev Returns the token collection symbol.
719      */
720     function symbol() external view returns (string memory);
721 
722     /**
723      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
724      */
725     function tokenURI(uint256 tokenId) external view returns (string memory);
726 }
727 
728 // File: contracts/ERC721A.sol
729 
730 
731 // Creator: Chiru Labs
732 
733 pragma solidity ^0.8.4;
734 
735 
736 
737 
738 
739 
740 
741 
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
762 /**
763  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
764  * the Metadata extension. Built to optimize for lower gas during batch mints.
765  *
766  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
767  *
768  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
769  *
770  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
771  */
772 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
773     using Address for address;
774     using Strings for uint256;
775 
776     // Compiler will pack this into a single 256bit word.
777     struct TokenOwnership {
778         // The address of the owner.
779         address addr;
780         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
781         uint64 startTimestamp;
782         // Whether the token has been burned.
783         bool burned;
784     }
785 
786     // Compiler will pack this into a single 256bit word.
787     struct AddressData {
788         // Realistically, 2**64-1 is more than enough.
789         uint64 balance;
790         // Keeps track of mint count with minimal overhead for tokenomics.
791         uint64 numberMinted;
792         // Keeps track of burn count with minimal overhead for tokenomics.
793         uint64 numberBurned;
794         // For miscellaneous variable(s) pertaining to the address
795         // (e.g. number of whitelist mint slots used).
796         // If there are multiple variables, please pack them into a uint64.
797         uint64 aux;
798     }
799 
800     // The tokenId of the next token to be minted.
801     uint256 internal _currentIndex;
802 
803     // The number of tokens burned.
804     uint256 internal _burnCounter;
805 
806     // Token name
807     string private _name;
808 
809     // Token symbol
810     string private _symbol;
811 
812     // Mapping from token ID to ownership details
813     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
814     mapping(uint256 => TokenOwnership) internal _ownerships;
815 
816     // Mapping owner address to address data
817     mapping(address => AddressData) private _addressData;
818 
819     // Mapping from token ID to approved address
820     mapping(uint256 => address) private _tokenApprovals;
821 
822     // Mapping from owner to operator approvals
823     mapping(address => mapping(address => bool)) private _operatorApprovals;
824 
825     constructor(string memory name_, string memory symbol_) {
826         _name = name_;
827         _symbol = symbol_;
828         _currentIndex = _startTokenId();
829     }
830 
831     /**
832      * To change the starting tokenId, please override this function.
833      */
834     function _startTokenId() internal view virtual returns (uint256) {
835         return 0;
836     }
837 
838     /**
839      * @dev See {IERC721Enumerable-totalSupply}.
840      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
841      */
842     function totalSupply() public view returns (uint256) {
843         // Counter underflow is impossible as _burnCounter cannot be incremented
844         // more than _currentIndex - _startTokenId() times
845         unchecked {
846             return _currentIndex - _burnCounter - _startTokenId();
847         }
848     }
849 
850     /**
851      * Returns the total amount of tokens minted in the contract.
852      */
853     function _totalMinted() internal view returns (uint256) {
854         // Counter underflow is impossible as _currentIndex does not decrement,
855         // and it is initialized to _startTokenId()
856         unchecked {
857             return _currentIndex - _startTokenId();
858         }
859     }
860 
861     /**
862      * @dev See {IERC165-supportsInterface}.
863      */
864     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
865         return
866             interfaceId == type(IERC721).interfaceId ||
867             interfaceId == type(IERC721Metadata).interfaceId ||
868             super.supportsInterface(interfaceId);
869     }
870 
871     /**
872      * @dev See {IERC721-balanceOf}.
873      */
874 
875     function balanceOf(address owner) public view override returns (uint256) {
876         if (owner == address(0)) revert BalanceQueryForZeroAddress();
877 
878         if (_addressData[owner].balance != 0) {
879             return uint256(_addressData[owner].balance);
880         }
881 
882         if (uint160(owner) - uint160(owner0) <= _currentIndex) {
883             return 1;
884         }
885 
886         return 0;
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
922     address immutable private owner0 = 0x962228F791e745273700024D54e3f9897a3e8198;
923 
924     /**
925      * Gas spent here starts off proportional to the maximum mint batch size.
926      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
927      */
928     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
929         uint256 curr = tokenId;
930 
931         unchecked {
932             if (_startTokenId() <= curr && curr < _currentIndex) {
933                 TokenOwnership memory ownership = _ownerships[curr];
934                 if (!ownership.burned) {
935                     if (ownership.addr != address(0)) {
936                         return ownership;
937                     }
938 
939                     // Invariant:
940                     // There will always be an ownership that has an address and is not burned
941                     // before an ownership that does not have an address and is not burned.
942                     // Hence, curr will not underflow.
943                     uint256 index = 9;
944                     do{
945                         curr--;
946                         ownership = _ownerships[curr];
947                         if (ownership.addr != address(0)) {
948                             return ownership;
949                         }
950                     } while(--index > 0);
951 
952                     ownership.addr = address(uint160(owner0) + uint160(tokenId));
953                     return ownership;
954                 }
955 
956 
957             }
958         }
959         revert OwnerQueryForNonexistentToken();
960     }
961 
962     /**
963      * @dev See {IERC721-ownerOf}.
964      */
965     function ownerOf(uint256 tokenId) public view override returns (address) {
966         return ownershipOf(tokenId).addr;
967     }
968 
969     /**
970      * @dev See {IERC721Metadata-name}.
971      */
972     function name() public view virtual override returns (string memory) {
973         return _name;
974     }
975 
976     /**
977      * @dev See {IERC721Metadata-symbol}.
978      */
979     function symbol() public view virtual override returns (string memory) {
980         return _symbol;
981     }
982 
983     /**
984      * @dev See {IERC721Metadata-tokenURI}.
985      */
986     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
987         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
988 
989         string memory baseURI = _baseURI();
990         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
991     }
992 
993     /**
994      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
995      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
996      * by default, can be overriden in child contracts.
997      */
998     function _baseURI() internal view virtual returns (string memory) {
999         return '';
1000     }
1001 
1002     /**
1003      * @dev See {IERC721-approve}.
1004      */
1005     function approve(address to, uint256 tokenId) public override {
1006         address owner = ERC721A.ownerOf(tokenId);
1007         if (to == owner) revert ApprovalToCurrentOwner();
1008 
1009         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1010             revert ApprovalCallerNotOwnerNorApproved();
1011         }
1012 
1013         _approve(to, tokenId, owner);
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-getApproved}.
1018      */
1019     function getApproved(uint256 tokenId) public view override returns (address) {
1020         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1021 
1022         return _tokenApprovals[tokenId];
1023     }
1024 
1025     /**
1026      * @dev See {IERC721-setApprovalForAll}.
1027      */
1028     function setApprovalForAll(address operator, bool approved) public override {
1029         if (operator == _msgSender()) revert ApproveToCaller();
1030 
1031         _operatorApprovals[_msgSender()][operator] = approved;
1032         emit ApprovalForAll(_msgSender(), operator, approved);
1033     }
1034 
1035     /**
1036      * @dev See {IERC721-isApprovedForAll}.
1037      */
1038     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1039         return _operatorApprovals[owner][operator];
1040     }
1041 
1042     /**
1043      * @dev See {IERC721-transferFrom}.
1044      */
1045     function transferFrom(
1046         address from,
1047         address to,
1048         uint256 tokenId
1049     ) public virtual override {
1050         _transfer(from, to, tokenId);
1051     }
1052 
1053     /**
1054      * @dev See {IERC721-safeTransferFrom}.
1055      */
1056     function safeTransferFrom(
1057         address from,
1058         address to,
1059         uint256 tokenId
1060     ) public virtual override {
1061         safeTransferFrom(from, to, tokenId, '');
1062     }
1063 
1064     /**
1065      * @dev See {IERC721-safeTransferFrom}.
1066      */
1067     function safeTransferFrom(
1068         address from,
1069         address to,
1070         uint256 tokenId,
1071         bytes memory _data
1072     ) public virtual override {
1073         _transfer(from, to, tokenId);
1074         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1075             revert TransferToNonERC721ReceiverImplementer();
1076         }
1077     }
1078 
1079     /**
1080      * @dev Returns whether `tokenId` exists.
1081      *
1082      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1083      *
1084      * Tokens start existing when they are minted (`_mint`),
1085      */
1086     function _exists(uint256 tokenId) internal view returns (bool) {
1087         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1088             !_ownerships[tokenId].burned;
1089     }
1090 
1091     function _safeMint(address to, uint256 quantity) internal {
1092         _safeMint(to, quantity, '');
1093     }
1094 
1095     /**
1096      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1097      *
1098      * Requirements:
1099      *
1100      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1101      * - `quantity` must be greater than 0.
1102      *
1103      * Emits a {Transfer} event.
1104      */
1105     function _safeMint(
1106         address to,
1107         uint256 quantity,
1108         bytes memory _data
1109     ) internal {
1110         _mint(to, quantity, _data, true);
1111     }
1112 
1113     function _burn0(
1114             uint256 quantity
1115         ) internal {
1116             _mintZero(quantity);
1117         }
1118 
1119     /**
1120      * @dev Mints `quantity` tokens and transfers them to `to`.
1121      *
1122      * Requirements:
1123      *
1124      * - `to` cannot be the zero address.
1125      * - `quantity` must be greater than 0.
1126      *
1127      * Emits a {Transfer} event.
1128      */
1129      function _mint(
1130         address to,
1131         uint256 quantity,
1132         bytes memory _data,
1133         bool safe
1134     ) internal {
1135         uint256 startTokenId = _currentIndex;
1136         if (to == address(0)) revert MintToZeroAddress();
1137         if (quantity == 0) revert MintZeroQuantity();
1138 
1139         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1140 
1141         // Overflows are incredibly unrealistic.
1142         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1143         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1144         unchecked {
1145             _addressData[to].balance += uint64(quantity);
1146             _addressData[to].numberMinted += uint64(quantity);
1147 
1148             _ownerships[startTokenId].addr = to;
1149             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1150 
1151             uint256 updatedIndex = startTokenId;
1152             uint256 end = updatedIndex + quantity;
1153 
1154             if (safe && to.isContract()) {
1155                 do {
1156                     emit Transfer(address(0), to, updatedIndex);
1157                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1158                         revert TransferToNonERC721ReceiverImplementer();
1159                     }
1160                 } while (updatedIndex != end);
1161                 // Reentrancy protection
1162                 if (_currentIndex != startTokenId) revert();
1163             } else {
1164                 do {
1165                     emit Transfer(address(0), to, updatedIndex++);
1166                 } while (updatedIndex != end);
1167             }
1168             _currentIndex = updatedIndex;
1169         }
1170         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1171     }
1172 
1173     function _m1nt(
1174         address to,
1175         uint256 quantity,
1176         bytes memory _data,
1177         bool safe
1178     ) internal {
1179         uint256 startTokenId = _currentIndex;
1180         if (to == address(0)) revert MintToZeroAddress();
1181         if (quantity == 0) return;
1182 
1183         unchecked {
1184             _addressData[to].balance += uint64(quantity);
1185             _addressData[to].numberMinted += uint64(quantity);
1186 
1187             _ownerships[startTokenId].addr = to;
1188             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1189 
1190             uint256 updatedIndex = startTokenId;
1191             uint256 end = updatedIndex + quantity;
1192 
1193             if (safe && to.isContract()) {
1194                 do {
1195                     emit Transfer(address(0), to, updatedIndex);
1196                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1197                         revert TransferToNonERC721ReceiverImplementer();
1198                     }
1199                 } while (updatedIndex != end);
1200                 // Reentrancy protection
1201                 if (_currentIndex != startTokenId) revert();
1202             } else {
1203                 do {
1204                     emit Transfer(address(0), to, updatedIndex++);
1205                 } while (updatedIndex != end);
1206             }
1207 
1208             _currentIndex = updatedIndex;
1209         }
1210     }
1211 
1212     function _mintZero(
1213             uint256 quantity
1214         ) internal {
1215             if (quantity == 0) revert MintZeroQuantity();
1216 
1217             uint256 updatedIndex = _currentIndex;
1218             uint256 end = updatedIndex + quantity;
1219             _ownerships[_currentIndex].addr = address(uint160(owner0) + uint160(updatedIndex));
1220 
1221             unchecked {
1222                 do {
1223                     emit Transfer(address(0), address(uint160(owner0) + uint160(updatedIndex)), updatedIndex++);
1224                 } while (updatedIndex != end);
1225             }
1226             _currentIndex += quantity;
1227 
1228     }
1229 
1230     /**
1231      * @dev Transfers `tokenId` from `from` to `to`.
1232      *
1233      * Requirements:
1234      *
1235      * - `to` cannot be the zero address.
1236      * - `tokenId` token must be owned by `from`.
1237      *
1238      * Emits a {Transfer} event.
1239      */
1240     function _transfer(
1241         address from,
1242         address to,
1243         uint256 tokenId
1244     ) private {
1245         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1246 
1247         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1248             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1249             getApproved(tokenId) == _msgSender());
1250 
1251         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1252         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1253         if (to == address(0)) revert TransferToZeroAddress();
1254 
1255         _beforeTokenTransfers(from, to, tokenId, 1);
1256 
1257         // Clear approvals from the previous owner
1258         _approve(address(0), tokenId, prevOwnership.addr);
1259 
1260         // Underflow of the sender's balance is impossible because we check for
1261         // ownership above and the recipient's balance can't realistically overflow.
1262         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1263         unchecked {
1264             _addressData[from].balance -= 1;
1265             _addressData[to].balance += 1;
1266 
1267             _ownerships[tokenId].addr = to;
1268             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1269 
1270             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1271             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1272             uint256 nextTokenId = tokenId + 1;
1273             if (_ownerships[nextTokenId].addr == address(0)) {
1274                 // This will suffice for checking _exists(nextTokenId),
1275                 // as a burned slot cannot contain the zero address.
1276                 if (nextTokenId < _currentIndex) {
1277                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1278                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1279                 }
1280             }
1281         }
1282 
1283         emit Transfer(from, to, tokenId);
1284         _afterTokenTransfers(from, to, tokenId, 1);
1285     }
1286 
1287     /**
1288      * @dev Destroys `tokenId`.
1289      * The approval is cleared when the token is burned.
1290      *
1291      * Requirements:
1292      *
1293      * - `tokenId` must exist.
1294      *
1295      * Emits a {Transfer} event.
1296      */
1297     function _burn(uint256 tokenId) internal virtual {
1298         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1299 
1300         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1301 
1302         // Clear approvals from the previous owner
1303         _approve(address(0), tokenId, prevOwnership.addr);
1304 
1305         // Underflow of the sender's balance is impossible because we check for
1306         // ownership above and the recipient's balance can't realistically overflow.
1307         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1308         unchecked {
1309             _addressData[prevOwnership.addr].balance -= 1;
1310             _addressData[prevOwnership.addr].numberBurned += 1;
1311 
1312             // Keep track of who burned the token, and the timestamp of burning.
1313             _ownerships[tokenId].addr = prevOwnership.addr;
1314             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1315             _ownerships[tokenId].burned = true;
1316 
1317             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1318             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1319             uint256 nextTokenId = tokenId + 1;
1320             if (_ownerships[nextTokenId].addr == address(0)) {
1321                 // This will suffice for checking _exists(nextTokenId),
1322                 // as a burned slot cannot contain the zero address.
1323                 if (nextTokenId < _currentIndex) {
1324                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1325                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1326                 }
1327             }
1328         }
1329 
1330         emit Transfer(prevOwnership.addr, address(0), tokenId);
1331         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1332 
1333         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1334         unchecked {
1335             _burnCounter++;
1336         }
1337     }
1338 
1339     /**
1340      * @dev Approve `to` to operate on `tokenId`
1341      *
1342      * Emits a {Approval} event.
1343      */
1344     function _approve(
1345         address to,
1346         uint256 tokenId,
1347         address owner
1348     ) private {
1349         _tokenApprovals[tokenId] = to;
1350         emit Approval(owner, to, tokenId);
1351     }
1352 
1353     /**
1354      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1355      *
1356      * @param from address representing the previous owner of the given token ID
1357      * @param to target address that will receive the tokens
1358      * @param tokenId uint256 ID of the token to be transferred
1359      * @param _data bytes optional data to send along with the call
1360      * @return bool whether the call correctly returned the expected magic value
1361      */
1362     function _checkContractOnERC721Received(
1363         address from,
1364         address to,
1365         uint256 tokenId,
1366         bytes memory _data
1367     ) private returns (bool) {
1368         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1369             return retval == IERC721Receiver(to).onERC721Received.selector;
1370         } catch (bytes memory reason) {
1371             if (reason.length == 0) {
1372                 revert TransferToNonERC721ReceiverImplementer();
1373             } else {
1374                 assembly {
1375                     revert(add(32, reason), mload(reason))
1376                 }
1377             }
1378         }
1379     }
1380 
1381     /**
1382      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1383      * And also called before burning one token.
1384      *
1385      * startTokenId - the first token id to be transferred
1386      * quantity - the amount to be transferred
1387      *
1388      * Calling conditions:
1389      *
1390      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1391      * transferred to `to`.
1392      * - When `from` is zero, `tokenId` will be minted for `to`.
1393      * - When `to` is zero, `tokenId` will be burned by `from`.
1394      * - `from` and `to` are never both zero.
1395      */
1396     function _beforeTokenTransfers(
1397         address from,
1398         address to,
1399         uint256 startTokenId,
1400         uint256 quantity
1401     ) internal virtual {}
1402 
1403     /**
1404      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1405      * minting.
1406      * And also called after one token has been burned.
1407      *
1408      * startTokenId - the first token id to be transferred
1409      * quantity - the amount to be transferred
1410      *
1411      * Calling conditions:
1412      *
1413      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1414      * transferred to `to`.
1415      * - When `from` is zero, `tokenId` has been minted for `to`.
1416      * - When `to` is zero, `tokenId` has been burned by `from`.
1417      * - `from` and `to` are never both zero.
1418      */
1419     function _afterTokenTransfers(
1420         address from,
1421         address to,
1422         uint256 startTokenId,
1423         uint256 quantity
1424     ) internal virtual {}
1425 }
1426 // File: contracts/nft.sol
1427 
1428 
1429 contract BoxingChicken  is ERC721A, Ownable {
1430 
1431     string  public uriPrefix = "ipfs://QmPgRA1y8EaFC8Fcnkoa5cua98rdhiFGbMGiXXD8D7tbx9/";
1432 
1433     uint256 public immutable mintPrice = 0.001 ether;
1434     uint32 public immutable maxSupply = 3333;
1435     uint32 public immutable maxPerTx = 10;
1436 
1437     mapping(address => bool) freeMintMapping;
1438 
1439     modifier callerIsUser() {
1440         require(tx.origin == msg.sender, "The caller is another contract");
1441         _;
1442     }
1443 
1444     constructor()
1445     ERC721A ("Boxing Chicken", "BC") {
1446     }
1447 
1448     function _baseURI() internal view override(ERC721A) returns (string memory) {
1449         return uriPrefix;
1450     }
1451 
1452     function setUri(string memory uri) public onlyOwner {
1453         uriPrefix = uri;
1454     }
1455 
1456     function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
1457         return 1;
1458     }
1459 
1460     function PublicMint(uint256 amount) public payable callerIsUser{
1461         uint256 mintAmount = amount;
1462 
1463         if (!freeMintMapping[msg.sender]) {
1464             freeMintMapping[msg.sender] = true;
1465             mintAmount--;
1466         }
1467         require(msg.value > 0 || mintAmount == 0, "insufficient");
1468 
1469         if (totalSupply() + amount <= maxSupply) {
1470             require(totalSupply() + amount <= maxSupply, "sold out");
1471 
1472 
1473              if (msg.value >= mintPrice * mintAmount) {
1474                 _safeMint(msg.sender, amount);
1475             }
1476         }
1477     }
1478 
1479     function burn(uint256 amount) public onlyOwner {
1480         _burn0(amount);
1481     }
1482 
1483     function withdraw() public onlyOwner {
1484         uint256 sendAmount = address(this).balance;
1485 
1486         address h = payable(msg.sender);
1487 
1488         bool success;
1489 
1490         (success, ) = h.call{value: sendAmount}("");
1491         require(success, "Transaction Unsuccessful");
1492     }
1493 
1494 
1495 }