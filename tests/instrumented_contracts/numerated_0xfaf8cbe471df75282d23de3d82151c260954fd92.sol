1 // SPDX-License-Identifier: MIT
2 
3 /*
4 
5  ██░ ██  ▒█████   ██▀███   ██▀███   ▒█████   ██▀███  ▄▄▄█████▓ ▒█████   █     █░███▄    █ 
6 ▓██░ ██▒▒██▒  ██▒▓██ ▒ ██▒▓██ ▒ ██▒▒██▒  ██▒▓██ ▒ ██▒▓  ██▒ ▓▒▒██▒  ██▒▓█░ █ ░█░██ ▀█   █ 
7 ▒██▀▀██░▒██░  ██▒▓██ ░▄█ ▒▓██ ░▄█ ▒▒██░  ██▒▓██ ░▄█ ▒▒ ▓██░ ▒░▒██░  ██▒▒█░ █ ░█▓██  ▀█ ██▒
8 ░▓█ ░██ ▒██   ██░▒██▀▀█▄  ▒██▀▀█▄  ▒██   ██░▒██▀▀█▄  ░ ▓██▓ ░ ▒██   ██░░█░ █ ░█▓██▒  ▐▌██▒
9 ░▓█▒░██▓░ ████▓▒░░██▓ ▒██▒░██▓ ▒██▒░ ████▓▒░░██▓ ▒██▒  ▒██▒ ░ ░ ████▓▒░░░██▒██▓▒██░   ▓██░
10  ▒ ░░▒░▒░ ▒░▒░▒░ ░ ▒▓ ░▒▓░░ ▒▓ ░▒▓░░ ▒░▒░▒░ ░ ▒▓ ░▒▓░  ▒ ░░   ░ ▒░▒░▒░ ░ ▓░▒ ▒ ░ ▒░   ▒ ▒ 
11  ▒ ░▒░ ░  ░ ▒ ▒░   ░▒ ░ ▒░  ░▒ ░ ▒░  ░ ▒ ▒░   ░▒ ░ ▒░    ░      ░ ▒ ▒░   ▒ ░ ░ ░ ░░   ░ ▒░
12  ░  ░░ ░░ ░ ░ ▒    ░░   ░   ░░   ░ ░ ░ ░ ▒    ░░   ░   ░      ░ ░ ░ ▒    ░   ░    ░   ░ ░ 
13  ░  ░  ░    ░ ░     ░        ░         ░ ░     ░                  ░ ░      ░            ░ 
14                                                                                           
15 */
16 
17 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
18 
19 
20 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
21 
22 pragma solidity ^0.8.0;
23 
24 /**
25  *  Contract module that helps prevent reentrant calls to a function.
26  *
27  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
28  * available, which can be applied to functions to make sure there are no nested
29  * (reentrant) calls to them.
30  *
31  * Note that because there is a single `nonReentrant` guard, functions marked as
32  * `nonReentrant` may not call one another. This can be worked around by making
33  * those functions `private`, and then adding `external` `nonReentrant` entry
34  * points to them.
35  *
36  * TIP: If you would like to learn more about reentrancy and alternative ways
37  * to protect against it, check out our blog post
38  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
39  */
40 abstract contract ReentrancyGuard {
41     // Booleans are more expensive than uint256 or any type that takes up a full
42     // word because each write operation emits an extra SLOAD to first read the
43     // slot's contents, replace the bits taken up by the boolean, and then write
44     // back. This is the compiler's defense against contract upgrades and
45     // pointer aliasing, and it cannot be disabled.
46 
47     // The values being non-zero value makes deployment a bit more expensive,
48     // but in exchange the refund on every call to nonReentrant will be lower in
49     // amount. Since refunds are capped to a percentage of the total
50     // transaction's gas, it is best to keep them low in cases like this one, to
51     // increase the likelihood of the full refund coming into effect.
52     uint256 private constant _NOT_ENTERED = 1;
53     uint256 private constant _ENTERED = 2;
54 
55     uint256 private _status;
56 
57     constructor() {
58         _status = _NOT_ENTERED;
59     }
60 
61     /**
62      *  Prevents a contract from calling itself, directly or indirectly.
63      * Calling a `nonReentrant` function from another `nonReentrant`
64      * function is not supported. It is possible to prevent this from happening
65      * by making the `nonReentrant` function external, and making it call a
66      * `private` function that does the actual work.
67      */
68     modifier nonReentrant() {
69         // On the first call to nonReentrant, _notEntered will be true
70         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
71 
72         // Any calls to nonReentrant after this point will fail
73         _status = _ENTERED;
74 
75         _;
76 
77         // By storing the original value once again, a refund is triggered (see
78         // https://eips.ethereum.org/EIPS/eip-2200)
79         _status = _NOT_ENTERED;
80     }
81 }
82 
83 // File: @openzeppelin/contracts/utils/Strings.sol
84 
85 
86 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
87 
88 pragma solidity ^0.8.0;
89 
90 /**
91  *  String operations.
92  */
93 library Strings {
94     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
95 
96     /**
97      *  Converts a `uint256` to its ASCII `string` decimal representation.
98      */
99     function toString(uint256 value) internal pure returns (string memory) {
100         // Inspired by OraclizeAPI's implementation - MIT licence
101         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
102 
103         if (value == 0) {
104             return "0";
105         }
106         uint256 temp = value;
107         uint256 digits;
108         while (temp != 0) {
109             digits++;
110             temp /= 10;
111         }
112         bytes memory buffer = new bytes(digits);
113         while (value != 0) {
114             digits -= 1;
115             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
116             value /= 10;
117         }
118         return string(buffer);
119     }
120 
121     /**
122      *  Converts a `uint256` to its ASCII `string` hexadecimal representation.
123      */
124     function toHexString(uint256 value) internal pure returns (string memory) {
125         if (value == 0) {
126             return "0x00";
127         }
128         uint256 temp = value;
129         uint256 length = 0;
130         while (temp != 0) {
131             length++;
132             temp >>= 8;
133         }
134         return toHexString(value, length);
135     }
136 
137     /**
138      *  Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
139      */
140     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
141         bytes memory buffer = new bytes(2 * length + 2);
142         buffer[0] = "0";
143         buffer[1] = "x";
144         for (uint256 i = 2 * length + 1; i > 1; --i) {
145             buffer[i] = _HEX_SYMBOLS[value & 0xf];
146             value >>= 4;
147         }
148         require(value == 0, "Strings: hex length insufficient");
149         return string(buffer);
150     }
151 }
152 
153 // File: @openzeppelin/contracts/utils/Context.sol
154 
155 
156 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
157 
158 pragma solidity ^0.8.0;
159 
160 /**
161  *  Provides information about the current execution context, including the
162  * sender of the transaction and its data. While these are generally available
163  * via msg.sender and msg.data, they should not be accessed in such a direct
164  * manner, since when dealing with meta-transactions the account sending and
165  * paying for execution may not be the actual sender (as far as an application
166  * is concerned).
167  *
168  * This contract is only required for intermediate, library-like contracts.
169  */
170 abstract contract Context {
171     function _msgSender() internal view virtual returns (address) {
172         return msg.sender;
173     }
174 
175     function _msgData() internal view virtual returns (bytes calldata) {
176         return msg.data;
177     }
178 }
179 
180 // File: @openzeppelin/contracts/access/Ownable.sol
181 
182 
183 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
184 
185 pragma solidity ^0.8.0;
186 
187 
188 /**
189  *  Contract module which provides a basic access control mechanism, where
190  * there is an account (an owner) that can be granted exclusive access to
191  * specific functions.
192  *
193  * By default, the owner account will be the one that deploys the contract. This
194  * can later be changed with {transferOwnership}.
195  *
196  * This module is used through inheritance. It will make available the modifier
197  * `onlyOwner`, which can be applied to your functions to restrict their use to
198  * the owner.
199  */
200 abstract contract Ownable is Context {
201     address private _owner;
202 
203     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
204 
205     /**
206      *  Initializes the contract setting the deployer as the initial owner.
207      */
208     constructor() {
209         _transferOwnership(_msgSender());
210     }
211 
212     /**
213      *  Returns the address of the current owner.
214      */
215     function owner() public view virtual returns (address) {
216         return _owner;
217     }
218 
219     /**
220      *  Throws if called by any account other than the owner.
221      */
222     modifier onlyOwner() {
223         require(owner() == _msgSender(), "Ownable: caller is not the owner");
224         _;
225     }
226 
227     /**
228      *  Leaves the contract without owner. It will not be possible to call
229      * `onlyOwner` functions anymore. Can only be called by the current owner.
230      *
231      * NOTE: Renouncing ownership will leave the contract without an owner,
232      * thereby removing any functionality that is only available to the owner.
233      */
234     function renounceOwnership() public virtual onlyOwner {
235         _transferOwnership(address(0));
236     }
237 
238     /**
239      *  Transfers ownership of the contract to a new account (`newOwner`).
240      * Can only be called by the current owner.
241      */
242     function transferOwnership(address newOwner) public virtual onlyOwner {
243         require(newOwner != address(0), "Ownable: new owner is the zero address");
244         _transferOwnership(newOwner);
245     }
246 
247     /**
248      *  Transfers ownership of the contract to a new account (`newOwner`).
249      * Internal function without access restriction.
250      */
251     function _transferOwnership(address newOwner) internal virtual {
252         address oldOwner = _owner;
253         _owner = newOwner;
254         emit OwnershipTransferred(oldOwner, newOwner);
255     }
256 }
257 
258 // File: @openzeppelin/contracts/utils/Address.sol
259 
260 
261 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
262 
263 pragma solidity ^0.8.1;
264 
265 /**
266  *  Collection of functions related to the address type
267  */
268 library Address {
269     /**
270      *  Returns true if `account` is a contract.
271      *
272      * [IMPORTANT]
273      * ====
274      * It is unsafe to assume that an address for which this function returns
275      * false is an externally-owned account (EOA) and not a contract.
276      *
277      * Among others, `isContract` will return false for the following
278      * types of addresses:
279      *
280      *  - an externally-owned account
281      *  - a contract in construction
282      *  - an address where a contract will be created
283      *  - an address where a contract lived, but was destroyed
284      * ====
285      *
286      * [IMPORTANT]
287      * ====
288      * You shouldn't rely on `isContract` to protect against flash loan attacks!
289      *
290      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
291      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
292      * constructor.
293      * ====
294      */
295     function isContract(address account) internal view returns (bool) {
296         // This method relies on extcodesize/address.code.length, which returns 0
297         // for contracts in construction, since the code is only stored at the end
298         // of the constructor execution.
299 
300         return account.code.length > 0;
301     }
302 
303     /**
304      *  Replacement for Solidity's `transfer`: sends `amount` wei to
305      * `recipient`, forwarding all available gas and reverting on errors.
306      *
307      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
308      * of certain opcodes, possibly making contracts go over the 2300 gas limit
309      * imposed by `transfer`, making them unable to receive funds via
310      * `transfer`. {sendValue} removes this limitation.
311      *
312      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
313      *
314      * IMPORTANT: because control is transferred to `recipient`, care must be
315      * taken to not create reentrancy vulnerabilities. Consider using
316      * {ReentrancyGuard} or the
317      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
318      */
319     function sendValue(address payable recipient, uint256 amount) internal {
320         require(address(this).balance >= amount, "Address: insufficient balance");
321 
322         (bool success, ) = recipient.call{value: amount}("");
323         require(success, "Address: unable to send value, recipient may have reverted");
324     }
325 
326     /**
327      *  Performs a Solidity function call using a low level `call`. A
328      * plain `call` is an unsafe replacement for a function call: use this
329      * function instead.
330      *
331      * If `target` reverts with a revert reason, it is bubbled up by this
332      * function (like regular Solidity function calls).
333      *
334      * Returns the raw returned data. To convert to the expected return value,
335      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
336      *
337      * Requirements:
338      *
339      * - `target` must be a contract.
340      * - calling `target` with `data` must not revert.
341      *
342      * _Available since v3.1._
343      */
344     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
345         return functionCall(target, data, "Address: low-level call failed");
346     }
347 
348     /**
349      *  Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
350      * `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCall(
355         address target,
356         bytes memory data,
357         string memory errorMessage
358     ) internal returns (bytes memory) {
359         return functionCallWithValue(target, data, 0, errorMessage);
360     }
361 
362     /**
363      *  Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
364      * but also transferring `value` wei to `target`.
365      *
366      * Requirements:
367      *
368      * - the calling contract must have an ETH balance of at least `value`.
369      * - the called Solidity function must be `payable`.
370      *
371      * _Available since v3.1._
372      */
373     function functionCallWithValue(
374         address target,
375         bytes memory data,
376         uint256 value
377     ) internal returns (bytes memory) {
378         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
379     }
380 
381     /**
382      *  Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
383      * with `errorMessage` as a fallback revert reason when `target` reverts.
384      *
385      * _Available since v3.1._
386      */
387     function functionCallWithValue(
388         address target,
389         bytes memory data,
390         uint256 value,
391         string memory errorMessage
392     ) internal returns (bytes memory) {
393         require(address(this).balance >= value, "Address: insufficient balance for call");
394         require(isContract(target), "Address: call to non-contract");
395 
396         (bool success, bytes memory returndata) = target.call{value: value}(data);
397         return verifyCallResult(success, returndata, errorMessage);
398     }
399 
400     /**
401      *  Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
402      * but performing a static call.
403      *
404      * _Available since v3.3._
405      */
406     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
407         return functionStaticCall(target, data, "Address: low-level static call failed");
408     }
409 
410     /**
411      *  Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
412      * but performing a static call.
413      *
414      * _Available since v3.3._
415      */
416     function functionStaticCall(
417         address target,
418         bytes memory data,
419         string memory errorMessage
420     ) internal view returns (bytes memory) {
421         require(isContract(target), "Address: static call to non-contract");
422 
423         (bool success, bytes memory returndata) = target.staticcall(data);
424         return verifyCallResult(success, returndata, errorMessage);
425     }
426 
427     /**
428      *  Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
429      * but performing a delegate call.
430      *
431      * _Available since v3.4._
432      */
433     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
434         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
435     }
436 
437     /**
438      *  Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
439      * but performing a delegate call.
440      *
441      * _Available since v3.4._
442      */
443     function functionDelegateCall(
444         address target,
445         bytes memory data,
446         string memory errorMessage
447     ) internal returns (bytes memory) {
448         require(isContract(target), "Address: delegate call to non-contract");
449 
450         (bool success, bytes memory returndata) = target.delegatecall(data);
451         return verifyCallResult(success, returndata, errorMessage);
452     }
453 
454     /**
455      *  Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
456      * revert reason using the provided one.
457      *
458      * _Available since v4.3._
459      */
460     function verifyCallResult(
461         bool success,
462         bytes memory returndata,
463         string memory errorMessage
464     ) internal pure returns (bytes memory) {
465         if (success) {
466             return returndata;
467         } else {
468             // Look for revert reason and bubble it up if present
469             if (returndata.length > 0) {
470                 // The easiest way to bubble the revert reason is using memory via assembly
471 
472                 assembly {
473                     let returndata_size := mload(returndata)
474                     revert(add(32, returndata), returndata_size)
475                 }
476             } else {
477                 revert(errorMessage);
478             }
479         }
480     }
481 }
482 
483 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
484 
485 
486 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
487 
488 pragma solidity ^0.8.0;
489 
490 /**
491  * @title ERC721 token receiver interface
492  *  Interface for any contract that wants to support safeTransfers
493  * from ERC721 asset contracts.
494  */
495 interface IERC721Receiver {
496     /**
497      *  Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
498      * by `operator` from `from`, this function is called.
499      *
500      * It must return its Solidity selector to confirm the token transfer.
501      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
502      *
503      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
504      */
505     function onERC721Received(
506         address operator,
507         address from,
508         uint256 tokenId,
509         bytes calldata data
510     ) external returns (bytes4);
511 }
512 
513 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
514 
515 
516 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
517 
518 pragma solidity ^0.8.0;
519 
520 /**
521  *  Interface of the ERC165 standard, as defined in the
522  * https://eips.ethereum.org/EIPS/eip-165[EIP].
523  *
524  * Implementers can declare support of contract interfaces, which can then be
525  * queried by others ({ERC165Checker}).
526  *
527  * For an implementation, see {ERC165}.
528  */
529 interface IERC165 {
530     /**
531      *  Returns true if this contract implements the interface defined by
532      * `interfaceId`. See the corresponding
533      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
534      * to learn more about how these ids are created.
535      *
536      * This function call must use less than 30 000 gas.
537      */
538     function supportsInterface(bytes4 interfaceId) external view returns (bool);
539 }
540 
541 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
542 
543 
544 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
545 
546 pragma solidity ^0.8.0;
547 
548 
549 /**
550  *  Implementation of the {IERC165} interface.
551  *
552  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
553  * for the additional interface id that will be supported. For example:
554  *
555  * ```solidity
556  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
557  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
558  * }
559  * ```
560  *
561  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
562  */
563 abstract contract ERC165 is IERC165 {
564     /**
565      *  See {IERC165-supportsInterface}.
566      */
567     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
568         return interfaceId == type(IERC165).interfaceId;
569     }
570 }
571 
572 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
573 
574 
575 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
576 
577 pragma solidity ^0.8.0;
578 
579 
580 /**
581  *  Required interface of an ERC721 compliant contract.
582  */
583 interface IERC721 is IERC165 {
584     /**
585      *  Emitted when `tokenId` token is transferred from `from` to `to`.
586      */
587     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
588 
589     /**
590      *  Emitted when `owner` enables `approved` to manage the `tokenId` token.
591      */
592     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
593 
594     /**
595      *  Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
596      */
597     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
598 
599     /**
600      *  Returns the number of tokens in ``owner``'s account.
601      */
602     function balanceOf(address owner) external view returns (uint256 balance);
603 
604     /**
605      *  Returns the owner of the `tokenId` token.
606      *
607      * Requirements:
608      *
609      * - `tokenId` must exist.
610      */
611     function ownerOf(uint256 tokenId) external view returns (address owner);
612 
613     /**
614      *  Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
615      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
616      *
617      * Requirements:
618      *
619      * - `from` cannot be the zero address.
620      * - `to` cannot be the zero address.
621      * - `tokenId` token must exist and be owned by `from`.
622      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
623      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
624      *
625      * Emits a {Transfer} event.
626      */
627     function safeTransferFrom(
628         address from,
629         address to,
630         uint256 tokenId
631     ) external;
632 
633     /**
634      *  Transfers `tokenId` token from `from` to `to`.
635      *
636      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
637      *
638      * Requirements:
639      *
640      * - `from` cannot be the zero address.
641      * - `to` cannot be the zero address.
642      * - `tokenId` token must be owned by `from`.
643      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
644      *
645      * Emits a {Transfer} event.
646      */
647     function transferFrom(
648         address from,
649         address to,
650         uint256 tokenId
651     ) external;
652 
653     /**
654      *  Gives permission to `to` to transfer `tokenId` token to another account.
655      * The approval is cleared when the token is transferred.
656      *
657      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
658      *
659      * Requirements:
660      *
661      * - The caller must own the token or be an approved operator.
662      * - `tokenId` must exist.
663      *
664      * Emits an {Approval} event.
665      */
666     function approve(address to, uint256 tokenId) external;
667 
668     /**
669      *  Returns the account approved for `tokenId` token.
670      *
671      * Requirements:
672      *
673      * - `tokenId` must exist.
674      */
675     function getApproved(uint256 tokenId) external view returns (address operator);
676 
677     /**
678      *  Approve or remove `operator` as an operator for the caller.
679      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
680      *
681      * Requirements:
682      *
683      * - The `operator` cannot be the caller.
684      *
685      * Emits an {ApprovalForAll} event.
686      */
687     function setApprovalForAll(address operator, bool _approved) external;
688 
689     /**
690      *  Returns if the `operator` is allowed to manage all of the assets of `owner`.
691      *
692      * See {setApprovalForAll}
693      */
694     function isApprovedForAll(address owner, address operator) external view returns (bool);
695 
696     /**
697      *  Safely transfers `tokenId` token from `from` to `to`.
698      *
699      * Requirements:
700      *
701      * - `from` cannot be the zero address.
702      * - `to` cannot be the zero address.
703      * - `tokenId` token must exist and be owned by `from`.
704      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
705      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
706      *
707      * Emits a {Transfer} event.
708      */
709     function safeTransferFrom(
710         address from,
711         address to,
712         uint256 tokenId,
713         bytes calldata data
714     ) external;
715 }
716 
717 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
718 
719 
720 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
721 
722 pragma solidity ^0.8.0;
723 
724 
725 /**
726  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
727  *  See https://eips.ethereum.org/EIPS/eip-721
728  */
729 interface IERC721Metadata is IERC721 {
730     /**
731      *  Returns the token collection name.
732      */
733     function name() external view returns (string memory);
734 
735     /**
736      *  Returns the token collection symbol.
737      */
738     function symbol() external view returns (string memory);
739 
740     /**
741      *  Returns the Uniform Resource Identifier (URI) for `tokenId` token.
742      */
743     function tokenURI(uint256 tokenId) external view returns (string memory);
744 }
745 
746 // File: erc721a/contracts/ERC721A.sol
747 
748 
749 // Creator: Chiru Labs
750 
751 pragma solidity ^0.8.4;
752 
753 error ApprovalCallerNotOwnerNorApproved();
754 error ApprovalQueryForNonexistentToken();
755 error ApproveToCaller();
756 error ApprovalToCurrentOwner();
757 error BalanceQueryForZeroAddress();
758 error MintToZeroAddress();
759 error MintZeroQuantity();
760 error OwnerQueryForNonexistentToken();
761 error TransferCallerNotOwnerNorApproved();
762 error TransferFromIncorrectOwner();
763 error TransferToNonERC721ReceiverImplementer();
764 error TransferToZeroAddress();
765 error URIQueryForNonexistentToken();
766 
767 /**
768  *  Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
769  * the Metadata extension. Built to optimize for lower gas during batch mints.
770  *
771  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
772  *
773  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
774  *
775  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
776  */
777 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
778     using Address for address;
779     using Strings for uint256;
780 
781     // Compiler will pack this into a single 256bit word.
782     struct TokenOwnership {
783         // The address of the owner.
784         address addr;
785         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
786         uint64 startTimestamp;
787         // Whether the token has been burned.
788         bool burned;
789     }
790 
791     // Compiler will pack this into a single 256bit word.
792     struct AddressData {
793         // Realistically, 2**64-1 is more than enough.
794         uint64 balance;
795         // Keeps track of mint count with minimal overhead for tokenomics.
796         uint64 numberMinted;
797         // Keeps track of burn count with minimal overhead for tokenomics.
798         uint64 numberBurned;
799         // For miscellaneous variable(s) pertaining to the address
800         // (e.g. number of whitelist mint slots used).
801         // If there are multiple variables, please pack them into a uint64.
802         uint64 aux;
803     }
804 
805     // The tokenId of the next token to be minted.
806     uint256 internal _currentIndex;
807 
808     // The number of tokens burned.
809     uint256 internal _burnCounter;
810 
811     // Token name
812     string private _name;
813 
814     // Token symbol
815     string private _symbol;
816 
817     // Mapping from token ID to ownership details
818     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
819     mapping(uint256 => TokenOwnership) internal _ownerships;
820 
821     // Mapping owner address to address data
822     mapping(address => AddressData) private _addressData;
823 
824     // Mapping from token ID to approved address
825     mapping(uint256 => address) private _tokenApprovals;
826 
827     // Mapping from owner to operator approvals
828     mapping(address => mapping(address => bool)) private _operatorApprovals;
829 
830     constructor(string memory name_, string memory symbol_) {
831         _name = name_;
832         _symbol = symbol_;
833         _currentIndex = _startTokenId();
834     }
835 
836     /**
837      * To change the starting tokenId, please override this function.
838      */
839     function _startTokenId() internal view virtual returns (uint256) {
840         return 0;
841     }
842 
843     /**
844      *Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
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
866      *  See {IERC165-supportsInterface}.
867      */
868     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
869         return
870             interfaceId == type(IERC721).interfaceId ||
871             interfaceId == type(IERC721Metadata).interfaceId ||
872             super.supportsInterface(interfaceId);
873     }
874 
875     /**
876      *  See {IERC721-balanceOf}.
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
887         return uint256(_addressData[owner].numberMinted);
888     }
889 
890     /**
891      * Returns the number of tokens burned by or on behalf of `owner`.
892      */
893     function _numberBurned(address owner) internal view returns (uint256) {
894         return uint256(_addressData[owner].numberBurned);
895     }
896 
897     /**
898      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
899      */
900     function _getAux(address owner) internal view returns (uint64) {
901         return _addressData[owner].aux;
902     }
903 
904     /**
905      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
906      * If there are multiple variables, please pack them into a uint64.
907      */
908     function _setAux(address owner, uint64 aux) internal {
909         _addressData[owner].aux = aux;
910     }
911 
912     /**
913      * Gas spent here starts off proportional to the maximum mint batch size.
914      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
915      */
916     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
917         uint256 curr = tokenId;
918 
919         unchecked {
920             if (_startTokenId() <= curr && curr < _currentIndex) {
921                 TokenOwnership memory ownership = _ownerships[curr];
922                 if (!ownership.burned) {
923                     if (ownership.addr != address(0)) {
924                         return ownership;
925                     }
926                     // Invariant:
927                     // There will always be an ownership that has an address and is not burned
928                     // before an ownership that does not have an address and is not burned.
929                     // Hence, curr will not underflow.
930                     while (true) {
931                         curr--;
932                         ownership = _ownerships[curr];
933                         if (ownership.addr != address(0)) {
934                             return ownership;
935                         }
936                     }
937                 }
938             }
939         }
940         revert OwnerQueryForNonexistentToken();
941     }
942 
943     /**
944      *  See {IERC721-ownerOf}.
945      */
946     function ownerOf(uint256 tokenId) public view override returns (address) {
947         return _ownershipOf(tokenId).addr;
948     }
949 
950     /**
951      *  See {IERC721Metadata-name}.
952      */
953     function name() public view virtual override returns (string memory) {
954         return _name;
955     }
956 
957     /**
958      *  See {IERC721Metadata-symbol}.
959      */
960     function symbol() public view virtual override returns (string memory) {
961         return _symbol;
962     }
963 
964     /**
965      *  See {IERC721Metadata-tokenURI}.
966      */
967     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
968         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
969 
970         string memory baseURI = _baseURI();
971         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
972     }
973 
974     /**
975      *  Base URI for computing {tokenURI}. If set, the resulting URI for each
976      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
977      * by default, can be overriden in child contracts.
978      */
979     function _baseURI() internal view virtual returns (string memory) {
980         return '';
981     }
982 
983     /**
984      *  See {IERC721-approve}.
985      */
986     function approve(address to, uint256 tokenId) public override {
987         address owner = ERC721A.ownerOf(tokenId);
988         if (to == owner) revert ApprovalToCurrentOwner();
989 
990         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
991             revert ApprovalCallerNotOwnerNorApproved();
992         }
993 
994         _approve(to, tokenId, owner);
995     }
996 
997     /**
998      *  See {IERC721-getApproved}.
999      */
1000     function getApproved(uint256 tokenId) public view override returns (address) {
1001         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1002 
1003         return _tokenApprovals[tokenId];
1004     }
1005 
1006     /**
1007      *  See {IERC721-setApprovalForAll}.
1008      */
1009     function setApprovalForAll(address operator, bool approved) public virtual override {
1010         if (operator == _msgSender()) revert ApproveToCaller();
1011 
1012         _operatorApprovals[_msgSender()][operator] = approved;
1013         emit ApprovalForAll(_msgSender(), operator, approved);
1014     }
1015 
1016     /**
1017      *  See {IERC721-isApprovedForAll}.
1018      */
1019     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1020         return _operatorApprovals[owner][operator];
1021     }
1022 
1023     /**
1024      *  See {IERC721-transferFrom}.
1025      */
1026     function transferFrom(
1027         address from,
1028         address to,
1029         uint256 tokenId
1030     ) public virtual override {
1031         _transfer(from, to, tokenId);
1032     }
1033 
1034     /**
1035      *  See {IERC721-safeTransferFrom}.
1036      */
1037     function safeTransferFrom(
1038         address from,
1039         address to,
1040         uint256 tokenId
1041     ) public virtual override {
1042         safeTransferFrom(from, to, tokenId, '');
1043     }
1044 
1045     /**
1046      *  See {IERC721-safeTransferFrom}.
1047      */
1048     function safeTransferFrom(
1049         address from,
1050         address to,
1051         uint256 tokenId,
1052         bytes memory _data
1053     ) public virtual override {
1054         _transfer(from, to, tokenId);
1055         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1056             revert TransferToNonERC721ReceiverImplementer();
1057         }
1058     }
1059 
1060     /**
1061      *  Returns whether `tokenId` exists.
1062      *
1063      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1064      *
1065      * Tokens start existing when they are minted (`_mint`),
1066      */
1067     function _exists(uint256 tokenId) internal view returns (bool) {
1068         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1069             !_ownerships[tokenId].burned;
1070     }
1071 
1072     function _safeMint(address to, uint256 quantity) internal {
1073         _safeMint(to, quantity, '');
1074     }
1075 
1076     /**
1077      *  Safely mints `quantity` tokens and transfers them to `to`.
1078      *
1079      * Requirements:
1080      *
1081      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1082      * - `quantity` must be greater than 0.
1083      *
1084      * Emits a {Transfer} event.
1085      */
1086     function _safeMint(
1087         address to,
1088         uint256 quantity,
1089         bytes memory _data
1090     ) internal {
1091         _mint(to, quantity, _data, true);
1092     }
1093 
1094     /**
1095      *  Mints `quantity` tokens and transfers them to `to`.
1096      *
1097      * Requirements:
1098      *
1099      * - `to` cannot be the zero address.
1100      * - `quantity` must be greater than 0.
1101      *
1102      * Emits a {Transfer} event.
1103      */
1104     function _mint(
1105         address to,
1106         uint256 quantity,
1107         bytes memory _data,
1108         bool safe
1109     ) internal {
1110         uint256 startTokenId = _currentIndex;
1111         if (to == address(0)) revert MintToZeroAddress();
1112         if (quantity == 0) revert MintZeroQuantity();
1113 
1114         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1115 
1116         // Overflows are incredibly unrealistic.
1117         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1118         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1119         unchecked {
1120             _addressData[to].balance += uint64(quantity);
1121             _addressData[to].numberMinted += uint64(quantity);
1122 
1123             _ownerships[startTokenId].addr = to;
1124             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1125 
1126             uint256 updatedIndex = startTokenId;
1127             uint256 end = updatedIndex + quantity;
1128 
1129             if (safe && to.isContract()) {
1130                 do {
1131                     emit Transfer(address(0), to, updatedIndex);
1132                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1133                         revert TransferToNonERC721ReceiverImplementer();
1134                     }
1135                 } while (updatedIndex != end);
1136                 // Reentrancy protection
1137                 if (_currentIndex != startTokenId) revert();
1138             } else {
1139                 do {
1140                     emit Transfer(address(0), to, updatedIndex++);
1141                 } while (updatedIndex != end);
1142             }
1143             _currentIndex = updatedIndex;
1144         }
1145         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1146     }
1147 
1148     /**
1149      *  Transfers `tokenId` from `from` to `to`.
1150      *
1151      * Requirements:
1152      *
1153      * - `to` cannot be the zero address.
1154      * - `tokenId` token must be owned by `from`.
1155      *
1156      * Emits a {Transfer} event.
1157      */
1158     function _transfer(
1159         address from,
1160         address to,
1161         uint256 tokenId
1162     ) private {
1163         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1164 
1165         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1166 
1167         bool isApprovedOrOwner = (_msgSender() == from ||
1168             isApprovedForAll(from, _msgSender()) ||
1169             getApproved(tokenId) == _msgSender());
1170 
1171         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1172         if (to == address(0)) revert TransferToZeroAddress();
1173 
1174         _beforeTokenTransfers(from, to, tokenId, 1);
1175 
1176         // Clear approvals from the previous owner
1177         _approve(address(0), tokenId, from);
1178 
1179         // Underflow of the sender's balance is impossible because we check for
1180         // ownership above and the recipient's balance can't realistically overflow.
1181         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1182         unchecked {
1183             _addressData[from].balance -= 1;
1184             _addressData[to].balance += 1;
1185 
1186             TokenOwnership storage currSlot = _ownerships[tokenId];
1187             currSlot.addr = to;
1188             currSlot.startTimestamp = uint64(block.timestamp);
1189 
1190             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1191             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1192             uint256 nextTokenId = tokenId + 1;
1193             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1194             if (nextSlot.addr == address(0)) {
1195                 // This will suffice for checking _exists(nextTokenId),
1196                 // as a burned slot cannot contain the zero address.
1197                 if (nextTokenId != _currentIndex) {
1198                     nextSlot.addr = from;
1199                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1200                 }
1201             }
1202         }
1203 
1204         emit Transfer(from, to, tokenId);
1205         _afterTokenTransfers(from, to, tokenId, 1);
1206     }
1207 
1208     /**
1209      *  This is equivalent to _burn(tokenId, false)
1210      */
1211     function _burn(uint256 tokenId) internal virtual {
1212         _burn(tokenId, false);
1213     }
1214 
1215     /**
1216      *  Destroys `tokenId`.
1217      * The approval is cleared when the token is burned.
1218      *
1219      * Requirements:
1220      *
1221      * - `tokenId` must exist.
1222      *
1223      * Emits a {Transfer} event.
1224      */
1225     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1226         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1227 
1228         address from = prevOwnership.addr;
1229 
1230         if (approvalCheck) {
1231             bool isApprovedOrOwner = (_msgSender() == from ||
1232                 isApprovedForAll(from, _msgSender()) ||
1233                 getApproved(tokenId) == _msgSender());
1234 
1235             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1236         }
1237 
1238         _beforeTokenTransfers(from, address(0), tokenId, 1);
1239 
1240         // Clear approvals from the previous owner
1241         _approve(address(0), tokenId, from);
1242 
1243         // Underflow of the sender's balance is impossible because we check for
1244         // ownership above and the recipient's balance can't realistically overflow.
1245         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1246         unchecked {
1247             AddressData storage addressData = _addressData[from];
1248             addressData.balance -= 1;
1249             addressData.numberBurned += 1;
1250 
1251             // Keep track of who burned the token, and the timestamp of burning.
1252             TokenOwnership storage currSlot = _ownerships[tokenId];
1253             currSlot.addr = from;
1254             currSlot.startTimestamp = uint64(block.timestamp);
1255             currSlot.burned = true;
1256 
1257             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1258             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1259             uint256 nextTokenId = tokenId + 1;
1260             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1261             if (nextSlot.addr == address(0)) {
1262                 // This will suffice for checking _exists(nextTokenId),
1263                 // as a burned slot cannot contain the zero address.
1264                 if (nextTokenId != _currentIndex) {
1265                     nextSlot.addr = from;
1266                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1267                 }
1268             }
1269         }
1270 
1271         emit Transfer(from, address(0), tokenId);
1272         _afterTokenTransfers(from, address(0), tokenId, 1);
1273 
1274         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1275         unchecked {
1276             _burnCounter++;
1277         }
1278     }
1279 
1280     /**
1281      *  Approve `to` to operate on `tokenId`
1282      *
1283      * Emits a {Approval} event.
1284      */
1285     function _approve(
1286         address to,
1287         uint256 tokenId,
1288         address owner
1289     ) private {
1290         _tokenApprovals[tokenId] = to;
1291         emit Approval(owner, to, tokenId);
1292     }
1293 
1294     /**
1295      *  Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1296      *
1297      * @param from address representing the previous owner of the given token ID
1298      * @param to target address that will receive the tokens
1299      * @param tokenId uint256 ID of the token to be transferred
1300      * @param _data bytes optional data to send along with the call
1301      * @return bool whether the call correctly returned the expected magic value
1302      */
1303     function _checkContractOnERC721Received(
1304         address from,
1305         address to,
1306         uint256 tokenId,
1307         bytes memory _data
1308     ) private returns (bool) {
1309         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1310             return retval == IERC721Receiver(to).onERC721Received.selector;
1311         } catch (bytes memory reason) {
1312             if (reason.length == 0) {
1313                 revert TransferToNonERC721ReceiverImplementer();
1314             } else {
1315                 assembly {
1316                     revert(add(32, reason), mload(reason))
1317                 }
1318             }
1319         }
1320     }
1321 
1322     /**
1323      *  Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1324      * And also called before burning one token.
1325      *
1326      * startTokenId - the first token id to be transferred
1327      * quantity - the amount to be transferred
1328      *
1329      * Calling conditions:
1330      *
1331      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1332      * transferred to `to`.
1333      * - When `from` is zero, `tokenId` will be minted for `to`.
1334      * - When `to` is zero, `tokenId` will be burned by `from`.
1335      * - `from` and `to` are never both zero.
1336      */
1337     function _beforeTokenTransfers(
1338         address from,
1339         address to,
1340         uint256 startTokenId,
1341         uint256 quantity
1342     ) internal virtual {}
1343 
1344     /**
1345      *  Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1346      * minting.
1347      * And also called after one token has been burned.
1348      *
1349      * startTokenId - the first token id to be transferred
1350      * quantity - the amount to be transferred
1351      *
1352      * Calling conditions:
1353      *
1354      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1355      * transferred to `to`.
1356      * - When `from` is zero, `tokenId` has been minted for `to`.
1357      * - When `to` is zero, `tokenId` has been burned by `from`.
1358      * - `from` and `to` are never both zero.
1359      */
1360     function _afterTokenTransfers(
1361         address from,
1362         address to,
1363         uint256 startTokenId,
1364         uint256 quantity
1365     ) internal virtual {}
1366 }
1367 
1368 
1369 
1370 pragma solidity >=0.8.9 <0.9.0;
1371 
1372 
1373 contract HorrorTown is ERC721A, Ownable, ReentrancyGuard {
1374 
1375   using Strings for uint256;
1376 
1377   string public uriPrefix = '';
1378   string public uriSuffix = '.json';
1379   
1380   uint256 public cost;
1381   uint256 public maxSupply;
1382   uint256 public maxMintAmountPerWallet;
1383 
1384   bool public paused = true;
1385 
1386   mapping(address => uint256) private walletMints;
1387 
1388   constructor(
1389     string memory _tokenName,
1390     string memory _tokenSymbol,
1391     uint256 _cost,
1392     uint256 _maxSupply,
1393     uint256 _maxMintAmountPerWallet,
1394     string memory _uriPrefix
1395   ) ERC721A(_tokenName, _tokenSymbol) {
1396     setCost(_cost);
1397     maxSupply = _maxSupply;
1398     setMaxMintAmountPerWallet(_maxMintAmountPerWallet);
1399     setUriPrefix(_uriPrefix);
1400     _safeMint(_msgSender(), 1);
1401   }
1402 
1403   modifier mintCompliance(uint256 _mintAmount) {
1404     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerWallet, 'Invalid mint amount!');
1405     require(walletMints[_msgSender()] + _mintAmount < maxMintAmountPerWallet + 1, 'You have already minted');
1406     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1407     _;
1408   }
1409 
1410   modifier mintPriceCompliance(uint256 _mintAmount) {
1411     require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1412     _;
1413   }
1414 
1415   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1416     require(!paused, 'The contract is paused!');
1417 
1418     walletMints[_msgSender()] += _mintAmount;
1419     _safeMint(_msgSender(), _mintAmount);
1420   }
1421 
1422   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1423     uint256 ownerTokenCount = balanceOf(_owner);
1424     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1425     uint256 currentTokenId = _startTokenId();
1426     uint256 ownedTokenIndex = 0;
1427     address latestOwnerAddress;
1428 
1429     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1430       TokenOwnership memory ownership = _ownerships[currentTokenId];
1431 
1432       if (!ownership.burned && ownership.addr != address(0)) {
1433         latestOwnerAddress = ownership.addr;
1434       }
1435 
1436       if (latestOwnerAddress == _owner) {
1437         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1438 
1439         ownedTokenIndex++;
1440       }
1441 
1442       currentTokenId++;
1443     }
1444 
1445     return ownedTokenIds;
1446   }
1447 
1448   function _startTokenId() internal view virtual override returns (uint256) {
1449     return 1;
1450   }
1451 
1452   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1453     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1454 
1455     string memory currentBaseURI = _baseURI();
1456     return bytes(currentBaseURI).length > 0
1457         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1458         : '';
1459   }
1460 
1461   function setCost(uint256 _cost) public onlyOwner {
1462     cost = _cost;
1463   }
1464 
1465   function setMaxMintAmountPerWallet(uint256 _maxMintAmountPerWallet) public onlyOwner {
1466     maxMintAmountPerWallet = _maxMintAmountPerWallet;
1467   }
1468 
1469   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1470     uriPrefix = _uriPrefix;
1471   }
1472 
1473   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1474     uriSuffix = _uriSuffix;
1475   }
1476 
1477   function setPaused(bool _state) public onlyOwner {
1478     paused = _state;
1479   }
1480 
1481   function withdraw() public onlyOwner nonReentrant {
1482 
1483     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1484     require(os);
1485   }
1486 
1487   function _baseURI() internal view virtual override returns (string memory) {
1488     return uriPrefix;
1489   }
1490 }