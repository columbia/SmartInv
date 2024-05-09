1 /**                                                                            
2 ⠀⠀⠀⠀⣀⣀⣤⣤⣤⣄⣀⡀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀
3 ⠀⣠⠶⠚⠉⠉⠀⠀⠀⣈⡉⠙⠳⢦⡴⠖⠚⠉⠉⠉⠉⠉⠙⠲⣤⡀⠀⠀⠀⠀
4 ⠊⠁⠀⠀⠀⠀⠀⣀⠭⠛⠛⣛⠳⣶⣤⡀⠀⠀⠀⠀⠀⣠⣴⠶⡛⢛⠻⢦⣀⠀
5 ⠀⠀⠀⠠⠤⠤⡜⣡⣴⣿⣿⣿⠟⠁⢹⡿⢦⠀⠀⢠⠊⣻⣷⣿⣿⠟⠉⢰⡌⢳
6 ⠉⠐⠒⠦⢤⣸⠀⣿⣿⣿⠟⠁⢀⣴⣿⣿⢸⠒⠒⡇⢸⣿⣿⡿⠃⠀⣠⣿⣿⠀
7 ⠀⠀⠀⠀⠀⠘⢄⠻⣿⠁⢀⡠⣪⣿⣿⠏⡼⠁⠀⢣⠈⢿⠟⠁⢠⢮⣾⣿⠟⢠
8 ⠀⠀⠀⣠⠤⠤⣌⠑⠤⣁⣋⣋⣉⣁⠴⠊⠀⣀⣀⣀⡑⠤⣁⠒⠳⠛⢋⣁⢴⠋
9 ⠀⠀⠀⢻⣴⠰⣌⠓⠦⢤⣀⣀⣶⣤⣤⣶⣿⣿⡿⣿⣿⣶⣤⣬⣽⠉⠁⠀⢸⡗
10 ⠀⠀⠀⠀⠙⠶⣄⣁⠒⠀⠤⠀⠈⣙⡛⠛⠛⠛⠛⠛⠛⠛⠟⠛⠛⠉⠉⣉⣹⡇
11 ⣿⣷⣶⣦⣤⣤⣄⣈⣉⠉⠙⠒⠒⠒⠦⠤⠤⠤⠤⠤⠤⠤⠤⡤⣤⠤⣖⡶⠟⠁
12 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣤⣤⣤⣤⣤⣤⡤⠚⠉⡠⠴⡯⠤⣄⠀
13 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠋⠀⠀⠈⠑⠀⢋⠔⠛⣦
14 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣄⠀⠀⠀⠤⠤⠢⠀⠀⠊⣽
15 ⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣀⣠⠋⠑⠉⡍⢱⣉⠞⠁
16 */
17 
18 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
19 
20 // SPDX-License-Identifier: MIT
21 
22 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
23 
24 pragma solidity ^0.8.0;
25 
26 /**
27  * @dev Contract module that helps prevent reentrant calls to a function.
28  *
29  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
30  * available, which can be applied to functions to make sure there are no nested
31  * (reentrant) calls to them.
32  *
33  * Note that because there is a single `nonReentrant` guard, functions marked as
34  * `nonReentrant` may not call one another. This can be worked around by making
35  * those functions `private`, and then adding `external` `nonReentrant` entry
36  * points to them.
37  *
38  * TIP: If you would like to learn more about reentrancy and alternative ways
39  * to protect against it, check out our blog post
40  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
41  */
42 abstract contract ReentrancyGuard {
43     // Booleans are more expensive than uint256 or any type that takes up a full
44     // word because each write operation emits an extra SLOAD to first read the
45     // slot's contents, replace the bits taken up by the boolean, and then write
46     // back. This is the compiler's defense against contract upgrades and
47     // pointer aliasing, and it cannot be disabled.
48 
49     // The values being non-zero value makes deployment a bit more expensive,
50     // but in exchange the refund on every call to nonReentrant will be lower in
51     // amount. Since refunds are capped to a percentage of the total
52     // transaction's gas, it is best to keep them low in cases like this one, to
53     // increase the likelihood of the full refund coming into effect.
54     uint256 private constant _NOT_ENTERED = 1;
55     uint256 private constant _ENTERED = 2;
56 
57     uint256 private _status;
58 
59     constructor() {
60         _status = _NOT_ENTERED;
61     }
62 
63     /**
64      * @dev Prevents a contract from calling itself, directly or indirectly.
65      * Calling a `nonReentrant` function from another `nonReentrant`
66      * function is not supported. It is possible to prevent this from happening
67      * by making the `nonReentrant` function external, and making it call a
68      * `private` function that does the actual work.
69      */
70     modifier nonReentrant() {
71         // On the first call to nonReentrant, _notEntered will be true
72         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
73 
74         // Any calls to nonReentrant after this point will fail
75         _status = _ENTERED;
76 
77         _;
78 
79         // By storing the original value once again, a refund is triggered (see
80         // https://eips.ethereum.org/EIPS/eip-2200)
81         _status = _NOT_ENTERED;
82     }
83 }
84 
85 // File: @openzeppelin/contracts/utils/Strings.sol
86 
87 
88 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
89 
90 pragma solidity ^0.8.0;
91 
92 /**
93  * @dev String operations.
94  */
95 library Strings {
96     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
97 
98     /**
99      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
100      */
101     function toString(uint256 value) internal pure returns (string memory) {
102         // Inspired by OraclizeAPI's implementation - MIT licence
103         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
104 
105         if (value == 0) {
106             return "0";
107         }
108         uint256 temp = value;
109         uint256 digits;
110         while (temp != 0) {
111             digits++;
112             temp /= 10;
113         }
114         bytes memory buffer = new bytes(digits);
115         while (value != 0) {
116             digits -= 1;
117             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
118             value /= 10;
119         }
120         return string(buffer);
121     }
122 
123     /**
124      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
125      */
126     function toHexString(uint256 value) internal pure returns (string memory) {
127         if (value == 0) {
128             return "0x00";
129         }
130         uint256 temp = value;
131         uint256 length = 0;
132         while (temp != 0) {
133             length++;
134             temp >>= 8;
135         }
136         return toHexString(value, length);
137     }
138 
139     /**
140      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
141      */
142     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
143         bytes memory buffer = new bytes(2 * length + 2);
144         buffer[0] = "0";
145         buffer[1] = "x";
146         for (uint256 i = 2 * length + 1; i > 1; --i) {
147             buffer[i] = _HEX_SYMBOLS[value & 0xf];
148             value >>= 4;
149         }
150         require(value == 0, "Strings: hex length insufficient");
151         return string(buffer);
152     }
153 }
154 
155 // File: @openzeppelin/contracts/utils/Context.sol
156 
157 
158 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
159 
160 pragma solidity ^0.8.0;
161 
162 /**
163  * @dev Provides information about the current execution context, including the
164  * sender of the transaction and its data. While these are generally available
165  * via msg.sender and msg.data, they should not be accessed in such a direct
166  * manner, since when dealing with meta-transactions the account sending and
167  * paying for execution may not be the actual sender (as far as an application
168  * is concerned).
169  *
170  * This contract is only required for intermediate, library-like contracts.
171  */
172 abstract contract Context {
173     function _msgSender() internal view virtual returns (address) {
174         return msg.sender;
175     }
176 
177     function _msgData() internal view virtual returns (bytes calldata) {
178         return msg.data;
179     }
180 }
181 
182 // File: @openzeppelin/contracts/access/Ownable.sol
183 
184 
185 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
186 
187 pragma solidity ^0.8.0;
188 
189 
190 /**
191  * @dev Contract module which provides a basic access control mechanism, where
192  * there is an account (an owner) that can be granted exclusive access to
193  * specific functions.
194  *
195  * By default, the owner account will be the one that deploys the contract. This
196  * can later be changed with {transferOwnership}.
197  *
198  * This module is used through inheritance. It will make available the modifier
199  * `onlyOwner`, which can be applied to your functions to restrict their use to
200  * the owner.
201  */
202 abstract contract Ownable is Context {
203     address private _owner;
204 
205     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
206 
207     /**
208      * @dev Initializes the contract setting the deployer as the initial owner.
209      */
210     constructor() {
211         _transferOwnership(_msgSender());
212     }
213 
214     /**
215      * @dev Returns the address of the current owner.
216      */
217     function owner() public view virtual returns (address) {
218         return _owner;
219     }
220 
221     /**
222      * @dev Throws if called by any account other than the owner.
223      */
224     modifier onlyOwner() {
225         require(owner() == _msgSender(), "Ownable: caller is not the owner");
226         _;
227     }
228 
229     /**
230      * @dev Leaves the contract without owner. It will not be possible to call
231      * `onlyOwner` functions anymore. Can only be called by the current owner.
232      *
233      * NOTE: Renouncing ownership will leave the contract without an owner,
234      * thereby removing any functionality that is only available to the owner.
235      */
236     function renounceOwnership() public virtual onlyOwner {
237         _transferOwnership(address(0));
238     }
239 
240     /**
241      * @dev Transfers ownership of the contract to a new account (`newOwner`).
242      * Can only be called by the current owner.
243      */
244     function transferOwnership(address newOwner) public virtual onlyOwner {
245         require(newOwner != address(0), "Ownable: new owner is the zero address");
246         _transferOwnership(newOwner);
247     }
248 
249     /**
250      * @dev Transfers ownership of the contract to a new account (`newOwner`).
251      * Internal function without access restriction.
252      */
253     function _transferOwnership(address newOwner) internal virtual {
254         address oldOwner = _owner;
255         _owner = newOwner;
256         emit OwnershipTransferred(oldOwner, newOwner);
257     }
258 }
259 
260 // File: @openzeppelin/contracts/utils/Address.sol
261 
262 
263 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
264 
265 pragma solidity ^0.8.1;
266 
267 /**
268  * @dev Collection of functions related to the address type
269  */
270 library Address {
271     /**
272      * @dev Returns true if `account` is a contract.
273      *
274      * [IMPORTANT]
275      * ====
276      * It is unsafe to assume that an address for which this function returns
277      * false is an externally-owned account (EOA) and not a contract.
278      *
279      * Among others, `isContract` will return false for the following
280      * types of addresses:
281      *
282      *  - an externally-owned account
283      *  - a contract in construction
284      *  - an address where a contract will be created
285      *  - an address where a contract lived, but was destroyed
286      * ====
287      *
288      * [IMPORTANT]
289      * ====
290      * You shouldn't rely on `isContract` to protect against flash loan attacks!
291      *
292      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
293      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
294      * constructor.
295      * ====
296      */
297     function isContract(address account) internal view returns (bool) {
298         // This method relies on extcodesize/address.code.length, which returns 0
299         // for contracts in construction, since the code is only stored at the end
300         // of the constructor execution.
301 
302         return account.code.length > 0;
303     }
304 
305     /**
306      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
307      * `recipient`, forwarding all available gas and reverting on errors.
308      *
309      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
310      * of certain opcodes, possibly making contracts go over the 2300 gas limit
311      * imposed by `transfer`, making them unable to receive funds via
312      * `transfer`. {sendValue} removes this limitation.
313      *
314      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
315      *
316      * IMPORTANT: because control is transferred to `recipient`, care must be
317      * taken to not create reentrancy vulnerabilities. Consider using
318      * {ReentrancyGuard} or the
319      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
320      */
321     function sendValue(address payable recipient, uint256 amount) internal {
322         require(address(this).balance >= amount, "Address: insufficient balance");
323 
324         (bool success, ) = recipient.call{value: amount}("");
325         require(success, "Address: unable to send value, recipient may have reverted");
326     }
327 
328     /**
329      * @dev Performs a Solidity function call using a low level `call`. A
330      * plain `call` is an unsafe replacement for a function call: use this
331      * function instead.
332      *
333      * If `target` reverts with a revert reason, it is bubbled up by this
334      * function (like regular Solidity function calls).
335      *
336      * Returns the raw returned data. To convert to the expected return value,
337      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
338      *
339      * Requirements:
340      *
341      * - `target` must be a contract.
342      * - calling `target` with `data` must not revert.
343      *
344      * _Available since v3.1._
345      */
346     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
347         return functionCall(target, data, "Address: low-level call failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
352      * `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCall(
357         address target,
358         bytes memory data,
359         string memory errorMessage
360     ) internal returns (bytes memory) {
361         return functionCallWithValue(target, data, 0, errorMessage);
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
366      * but also transferring `value` wei to `target`.
367      *
368      * Requirements:
369      *
370      * - the calling contract must have an ETH balance of at least `value`.
371      * - the called Solidity function must be `payable`.
372      *
373      * _Available since v3.1._
374      */
375     function functionCallWithValue(
376         address target,
377         bytes memory data,
378         uint256 value
379     ) internal returns (bytes memory) {
380         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
385      * with `errorMessage` as a fallback revert reason when `target` reverts.
386      *
387      * _Available since v3.1._
388      */
389     function functionCallWithValue(
390         address target,
391         bytes memory data,
392         uint256 value,
393         string memory errorMessage
394     ) internal returns (bytes memory) {
395         require(address(this).balance >= value, "Address: insufficient balance for call");
396         require(isContract(target), "Address: call to non-contract");
397 
398         (bool success, bytes memory returndata) = target.call{value: value}(data);
399         return verifyCallResult(success, returndata, errorMessage);
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
404      * but performing a static call.
405      *
406      * _Available since v3.3._
407      */
408     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
409         return functionStaticCall(target, data, "Address: low-level static call failed");
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
414      * but performing a static call.
415      *
416      * _Available since v3.3._
417      */
418     function functionStaticCall(
419         address target,
420         bytes memory data,
421         string memory errorMessage
422     ) internal view returns (bytes memory) {
423         require(isContract(target), "Address: static call to non-contract");
424 
425         (bool success, bytes memory returndata) = target.staticcall(data);
426         return verifyCallResult(success, returndata, errorMessage);
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
431      * but performing a delegate call.
432      *
433      * _Available since v3.4._
434      */
435     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
436         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
441      * but performing a delegate call.
442      *
443      * _Available since v3.4._
444      */
445     function functionDelegateCall(
446         address target,
447         bytes memory data,
448         string memory errorMessage
449     ) internal returns (bytes memory) {
450         require(isContract(target), "Address: delegate call to non-contract");
451 
452         (bool success, bytes memory returndata) = target.delegatecall(data);
453         return verifyCallResult(success, returndata, errorMessage);
454     }
455 
456     /**
457      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
458      * revert reason using the provided one.
459      *
460      * _Available since v4.3._
461      */
462     function verifyCallResult(
463         bool success,
464         bytes memory returndata,
465         string memory errorMessage
466     ) internal pure returns (bytes memory) {
467         if (success) {
468             return returndata;
469         } else {
470             // Look for revert reason and bubble it up if present
471             if (returndata.length > 0) {
472                 // The easiest way to bubble the revert reason is using memory via assembly
473 
474                 assembly {
475                     let returndata_size := mload(returndata)
476                     revert(add(32, returndata), returndata_size)
477                 }
478             } else {
479                 revert(errorMessage);
480             }
481         }
482     }
483 }
484 
485 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
486 
487 
488 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
489 
490 pragma solidity ^0.8.0;
491 
492 /**
493  * @title ERC721 token receiver interface
494  * @dev Interface for any contract that wants to support safeTransfers
495  * from ERC721 asset contracts.
496  */
497 interface IERC721Receiver {
498     /**
499      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
500      * by `operator` from `from`, this function is called.
501      *
502      * It must return its Solidity selector to confirm the token transfer.
503      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
504      *
505      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
506      */
507     function onERC721Received(
508         address operator,
509         address from,
510         uint256 tokenId,
511         bytes calldata data
512     ) external returns (bytes4);
513 }
514 
515 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
516 
517 
518 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
519 
520 pragma solidity ^0.8.0;
521 
522 /**
523  * @dev Interface of the ERC165 standard, as defined in the
524  * https://eips.ethereum.org/EIPS/eip-165[EIP].
525  *
526  * Implementers can declare support of contract interfaces, which can then be
527  * queried by others ({ERC165Checker}).
528  *
529  * For an implementation, see {ERC165}.
530  */
531 interface IERC165 {
532     /**
533      * @dev Returns true if this contract implements the interface defined by
534      * `interfaceId`. See the corresponding
535      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
536      * to learn more about how these ids are created.
537      *
538      * This function call must use less than 30 000 gas.
539      */
540     function supportsInterface(bytes4 interfaceId) external view returns (bool);
541 }
542 
543 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
544 
545 
546 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
547 
548 pragma solidity ^0.8.0;
549 
550 
551 /**
552  * @dev Implementation of the {IERC165} interface.
553  *
554  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
555  * for the additional interface id that will be supported. For example:
556  *
557  * ```solidity
558  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
559  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
560  * }
561  * ```
562  *
563  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
564  */
565 abstract contract ERC165 is IERC165 {
566     /**
567      * @dev See {IERC165-supportsInterface}.
568      */
569     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
570         return interfaceId == type(IERC165).interfaceId;
571     }
572 }
573 
574 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
575 
576 
577 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
578 
579 pragma solidity ^0.8.0;
580 
581 
582 /**
583  * @dev Required interface of an ERC721 compliant contract.
584  */
585 interface IERC721 is IERC165 {
586     /**
587      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
588      */
589     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
590 
591     /**
592      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
593      */
594     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
595 
596     /**
597      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
598      */
599     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
600 
601     /**
602      * @dev Returns the number of tokens in ``owner``'s account.
603      */
604     function balanceOf(address owner) external view returns (uint256 balance);
605 
606     /**
607      * @dev Returns the owner of the `tokenId` token.
608      *
609      * Requirements:
610      *
611      * - `tokenId` must exist.
612      */
613     function ownerOf(uint256 tokenId) external view returns (address owner);
614 
615     /**
616      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
617      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
618      *
619      * Requirements:
620      *
621      * - `from` cannot be the zero address.
622      * - `to` cannot be the zero address.
623      * - `tokenId` token must exist and be owned by `from`.
624      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
625      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
626      *
627      * Emits a {Transfer} event.
628      */
629     function safeTransferFrom(
630         address from,
631         address to,
632         uint256 tokenId
633     ) external;
634 
635     /**
636      * @dev Transfers `tokenId` token from `from` to `to`.
637      *
638      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
639      *
640      * Requirements:
641      *
642      * - `from` cannot be the zero address.
643      * - `to` cannot be the zero address.
644      * - `tokenId` token must be owned by `from`.
645      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
646      *
647      * Emits a {Transfer} event.
648      */
649     function transferFrom(
650         address from,
651         address to,
652         uint256 tokenId
653     ) external;
654 
655     /**
656      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
657      * The approval is cleared when the token is transferred.
658      *
659      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
660      *
661      * Requirements:
662      *
663      * - The caller must own the token or be an approved operator.
664      * - `tokenId` must exist.
665      *
666      * Emits an {Approval} event.
667      */
668     function approve(address to, uint256 tokenId) external;
669 
670     /**
671      * @dev Returns the account approved for `tokenId` token.
672      *
673      * Requirements:
674      *
675      * - `tokenId` must exist.
676      */
677     function getApproved(uint256 tokenId) external view returns (address operator);
678 
679     /**
680      * @dev Approve or remove `operator` as an operator for the caller.
681      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
682      *
683      * Requirements:
684      *
685      * - The `operator` cannot be the caller.
686      *
687      * Emits an {ApprovalForAll} event.
688      */
689     function setApprovalForAll(address operator, bool _approved) external;
690 
691     /**
692      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
693      *
694      * See {setApprovalForAll}
695      */
696     function isApprovedForAll(address owner, address operator) external view returns (bool);
697 
698     /**
699      * @dev Safely transfers `tokenId` token from `from` to `to`.
700      *
701      * Requirements:
702      *
703      * - `from` cannot be the zero address.
704      * - `to` cannot be the zero address.
705      * - `tokenId` token must exist and be owned by `from`.
706      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
707      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
708      *
709      * Emits a {Transfer} event.
710      */
711     function safeTransferFrom(
712         address from,
713         address to,
714         uint256 tokenId,
715         bytes calldata data
716     ) external;
717 }
718 
719 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
720 
721 
722 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
723 
724 pragma solidity ^0.8.0;
725 
726 
727 /**
728  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
729  * @dev See https://eips.ethereum.org/EIPS/eip-721
730  */
731 interface IERC721Metadata is IERC721 {
732     /**
733      * @dev Returns the token collection name.
734      */
735     function name() external view returns (string memory);
736 
737     /**
738      * @dev Returns the token collection symbol.
739      */
740     function symbol() external view returns (string memory);
741 
742     /**
743      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
744      */
745     function tokenURI(uint256 tokenId) external view returns (string memory);
746 }
747 
748 // File: contracts/ERC721A.sol
749 
750 
751 // Creator: Chiru Labs
752 
753 pragma solidity ^0.8.4;
754 
755 
756 
757 
758 
759 
760 
761 
762 error ApprovalCallerNotOwnerNorApproved();
763 error ApprovalQueryForNonexistentToken();
764 error ApproveToCaller();
765 error ApprovalToCurrentOwner();
766 error BalanceQueryForZeroAddress();
767 error MintToZeroAddress();
768 error MintZeroQuantity();
769 error OwnerQueryForNonexistentToken();
770 error TransferCallerNotOwnerNorApproved();
771 error TransferFromIncorrectOwner();
772 error TransferToNonERC721ReceiverImplementer();
773 error TransferToZeroAddress();
774 error URIQueryForNonexistentToken();
775 
776 /**
777  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
778  * the Metadata extension. Built to optimize for lower gas during batch mints.
779  *
780  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
781  *
782  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
783  *
784  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
785  */
786 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
787     using Address for address;
788     using Strings for uint256;
789 
790     // Compiler will pack this into a single 256bit word.
791     struct TokenOwnership {
792         // The address of the owner.
793         address addr;
794         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
795         uint64 startTimestamp;
796         // Whether the token has been burned.
797         bool burned;
798     }
799 
800     // Compiler will pack this into a single 256bit word.
801     struct AddressData {
802         // Realistically, 2**64-1 is more than enough.
803         uint64 balance;
804         // Keeps track of mint count with minimal overhead for tokenomics.
805         uint64 numberMinted;
806         // Keeps track of burn count with minimal overhead for tokenomics.
807         uint64 numberBurned;
808         // For miscellaneous variable(s) pertaining to the address
809         // (e.g. number of whitelist mint slots used).
810         // If there are multiple variables, please pack them into a uint64.
811         uint64 aux;
812     }
813 
814     // The tokenId of the next token to be minted.
815     uint256 internal _currentIndex;
816 
817     // The number of tokens burned.
818     uint256 internal _burnCounter;
819 
820     // Token name
821     string private _name;
822 
823     // Token symbol
824     string private _symbol;
825 
826     // Mapping from token ID to ownership details
827     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
828     mapping(uint256 => TokenOwnership) internal _ownerships;
829 
830     // Mapping owner address to address data
831     mapping(address => AddressData) private _addressData;
832 
833     // Mapping from token ID to approved address
834     mapping(uint256 => address) private _tokenApprovals;
835 
836     // Mapping from owner to operator approvals
837     mapping(address => mapping(address => bool)) private _operatorApprovals;
838 
839     constructor(string memory name_, string memory symbol_) {
840         _name = name_;
841         _symbol = symbol_;
842         _currentIndex = _startTokenId();
843     }
844 
845     /**
846      * To change the starting tokenId, please override this function.
847      */
848     function _startTokenId() internal view virtual returns (uint256) {
849         return 1;
850     }
851 
852     /**
853      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
854      */
855     function totalSupply() public view returns (uint256) {
856         // Counter underflow is impossible as _burnCounter cannot be incremented
857         // more than _currentIndex - _startTokenId() times
858         unchecked {
859             return _currentIndex - _burnCounter - _startTokenId();
860         }
861     }
862 
863     /**
864      * Returns the total amount of tokens minted in the contract.
865      */
866     function _totalMinted() internal view returns (uint256) {
867         // Counter underflow is impossible as _currentIndex does not decrement,
868         // and it is initialized to _startTokenId()
869         unchecked {
870             return _currentIndex - _startTokenId();
871         }
872     }
873 
874     /**
875      * @dev See {IERC165-supportsInterface}.
876      */
877     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
878         return
879             interfaceId == type(IERC721).interfaceId ||
880             interfaceId == type(IERC721Metadata).interfaceId ||
881             super.supportsInterface(interfaceId);
882     }
883 
884     /**
885      * @dev See {IERC721-balanceOf}.
886      */
887     function balanceOf(address owner) public view override returns (uint256) {
888         if (owner == address(0)) revert BalanceQueryForZeroAddress();
889         return uint256(_addressData[owner].balance);
890     }
891 
892     /**
893      * Returns the number of tokens minted by `owner`.
894      */
895     function _numberMinted(address owner) internal view returns (uint256) {
896         return uint256(_addressData[owner].numberMinted);
897     }
898 
899     /**
900      * Returns the number of tokens burned by or on behalf of `owner`.
901      */
902     function _numberBurned(address owner) internal view returns (uint256) {
903         return uint256(_addressData[owner].numberBurned);
904     }
905 
906     /**
907      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
908      */
909     function _getAux(address owner) internal view returns (uint64) {
910         return _addressData[owner].aux;
911     }
912 
913     /**
914      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
915      * If there are multiple variables, please pack them into a uint64.
916      */
917     function _setAux(address owner, uint64 aux) internal {
918         _addressData[owner].aux = aux;
919     }
920 
921     /**
922      * Gas spent here starts off proportional to the maximum mint batch size.
923      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
924      */
925     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
926         uint256 curr = tokenId;
927 
928         unchecked {
929             if (_startTokenId() <= curr && curr < _currentIndex) {
930                 TokenOwnership memory ownership = _ownerships[curr];
931                 if (!ownership.burned) {
932                     if (ownership.addr != address(0)) {
933                         return ownership;
934                     }
935                     // Invariant:
936                     // There will always be an ownership that has an address and is not burned
937                     // before an ownership that does not have an address and is not burned.
938                     // Hence, curr will not underflow.
939                     while (true) {
940                         curr--;
941                         ownership = _ownerships[curr];
942                         if (ownership.addr != address(0)) {
943                             return ownership;
944                         }
945                     }
946                 }
947             }
948         }
949         revert OwnerQueryForNonexistentToken();
950     }
951 
952     /**
953      * @dev See {IERC721-ownerOf}.
954      */
955     function ownerOf(uint256 tokenId) public view override returns (address) {
956         return _ownershipOf(tokenId).addr;
957     }
958 
959     /**
960      * @dev See {IERC721Metadata-name}.
961      */
962     function name() public view virtual override returns (string memory) {
963         return _name;
964     }
965 
966     /**
967      * @dev See {IERC721Metadata-symbol}.
968      */
969     function symbol() public view virtual override returns (string memory) {
970         return _symbol;
971     }
972 
973     /**
974      * @dev See {IERC721Metadata-tokenURI}.
975      */
976     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
977         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
978 
979         string memory baseURI = _baseURI();
980         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
981     }
982 
983     /**
984      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
985      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
986      * by default, can be overriden in child contracts.
987      */
988     function _baseURI() internal view virtual returns (string memory) {
989         return '';
990     }
991 
992     /**
993      * @dev See {IERC721-approve}.
994      */
995     function approve(address to, uint256 tokenId) public override {
996         address owner = ERC721A.ownerOf(tokenId);
997         if (to == owner) revert ApprovalToCurrentOwner();
998 
999         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1000             revert ApprovalCallerNotOwnerNorApproved();
1001         }
1002 
1003         _approve(to, tokenId, owner);
1004     }
1005 
1006     /**
1007      * @dev See {IERC721-getApproved}.
1008      */
1009     function getApproved(uint256 tokenId) public view override returns (address) {
1010         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1011 
1012         return _tokenApprovals[tokenId];
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-setApprovalForAll}.
1017      */
1018     function setApprovalForAll(address operator, bool approved) public virtual override {
1019         if (operator == _msgSender()) revert ApproveToCaller();
1020 
1021         _operatorApprovals[_msgSender()][operator] = approved;
1022         emit ApprovalForAll(_msgSender(), operator, approved);
1023     }
1024 
1025     /**
1026      * @dev See {IERC721-isApprovedForAll}.
1027      */
1028     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1029         return _operatorApprovals[owner][operator];
1030     }
1031 
1032     /**
1033      * @dev See {IERC721-transferFrom}.
1034      */
1035     function transferFrom(
1036         address from,
1037         address to,
1038         uint256 tokenId
1039     ) public virtual override {
1040         _transfer(from, to, tokenId);
1041     }
1042 
1043     /**
1044      * @dev See {IERC721-safeTransferFrom}.
1045      */
1046     function safeTransferFrom(
1047         address from,
1048         address to,
1049         uint256 tokenId
1050     ) public virtual override {
1051         safeTransferFrom(from, to, tokenId, '');
1052     }
1053 
1054     /**
1055      * @dev See {IERC721-safeTransferFrom}.
1056      */
1057     function safeTransferFrom(
1058         address from,
1059         address to,
1060         uint256 tokenId,
1061         bytes memory _data
1062     ) public virtual override {
1063         _transfer(from, to, tokenId);
1064         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1065             revert TransferToNonERC721ReceiverImplementer();
1066         }
1067     }
1068 
1069     /**
1070      * @dev Returns whether `tokenId` exists.
1071      *
1072      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1073      *
1074      * Tokens start existing when they are minted (`_mint`),
1075      */
1076     function _exists(uint256 tokenId) internal view returns (bool) {
1077         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1078     }
1079 
1080     /**
1081      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1082      */
1083     function _safeMint(address to, uint256 quantity) internal {
1084         _safeMint(to, quantity, '');
1085     }
1086 
1087     /**
1088      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1089      *
1090      * Requirements:
1091      *
1092      * - If `to` refers to a smart contract, it must implement 
1093      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1094      * - `quantity` must be greater than 0.
1095      *
1096      * Emits a {Transfer} event.
1097      */
1098     function _safeMint(
1099         address to,
1100         uint256 quantity,
1101         bytes memory _data
1102     ) internal {
1103         uint256 startTokenId = _currentIndex;
1104         if (to == address(0)) revert MintToZeroAddress();
1105         if (quantity == 0) revert MintZeroQuantity();
1106 
1107         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1108 
1109         // Overflows are incredibly unrealistic.
1110         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1111         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1112         unchecked {
1113             _addressData[to].balance += uint64(quantity);
1114             _addressData[to].numberMinted += uint64(quantity);
1115 
1116             _ownerships[startTokenId].addr = to;
1117             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1118 
1119             uint256 updatedIndex = startTokenId;
1120             uint256 end = updatedIndex + quantity;
1121 
1122             if (to.isContract()) {
1123                 do {
1124                     emit Transfer(address(0), to, updatedIndex);
1125                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1126                         revert TransferToNonERC721ReceiverImplementer();
1127                     }
1128                 } while (updatedIndex != end);
1129                 // Reentrancy protection
1130                 if (_currentIndex != startTokenId) revert();
1131             } else {
1132                 do {
1133                     emit Transfer(address(0), to, updatedIndex++);
1134                 } while (updatedIndex != end);
1135             }
1136             _currentIndex = updatedIndex;
1137         }
1138         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1139     }
1140 
1141     /**
1142      * @dev Mints `quantity` tokens and transfers them to `to`.
1143      *
1144      * Requirements:
1145      *
1146      * - `to` cannot be the zero address.
1147      * - `quantity` must be greater than 0.
1148      *
1149      * Emits a {Transfer} event.
1150      */
1151     function _mint(address to, uint256 quantity) internal {
1152         uint256 startTokenId = _currentIndex;
1153         if (to == address(0)) revert MintToZeroAddress();
1154         if (quantity == 0) revert MintZeroQuantity();
1155 
1156         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1157 
1158         // Overflows are incredibly unrealistic.
1159         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1160         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1161         unchecked {
1162             _addressData[to].balance += uint64(quantity);
1163             _addressData[to].numberMinted += uint64(quantity);
1164 
1165             _ownerships[startTokenId].addr = to;
1166             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1167 
1168             uint256 updatedIndex = startTokenId;
1169             uint256 end = updatedIndex + quantity;
1170 
1171             do {
1172                 emit Transfer(address(0), to, updatedIndex++);
1173             } while (updatedIndex != end);
1174 
1175             _currentIndex = updatedIndex;
1176         }
1177         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1178     }
1179 
1180     /**
1181      * @dev Transfers `tokenId` from `from` to `to`.
1182      *
1183      * Requirements:
1184      *
1185      * - `to` cannot be the zero address.
1186      * - `tokenId` token must be owned by `from`.
1187      *
1188      * Emits a {Transfer} event.
1189      */
1190     function _transfer(
1191         address from,
1192         address to,
1193         uint256 tokenId
1194     ) private {
1195         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1196 
1197         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1198 
1199         bool isApprovedOrOwner = (_msgSender() == from ||
1200             isApprovedForAll(from, _msgSender()) ||
1201             getApproved(tokenId) == _msgSender());
1202 
1203         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1204         if (to == address(0)) revert TransferToZeroAddress();
1205 
1206         _beforeTokenTransfers(from, to, tokenId, 1);
1207 
1208         // Clear approvals from the previous owner
1209         _approve(address(0), tokenId, from);
1210 
1211         // Underflow of the sender's balance is impossible because we check for
1212         // ownership above and the recipient's balance can't realistically overflow.
1213         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1214         unchecked {
1215             _addressData[from].balance -= 1;
1216             _addressData[to].balance += 1;
1217 
1218             TokenOwnership storage currSlot = _ownerships[tokenId];
1219             currSlot.addr = to;
1220             currSlot.startTimestamp = uint64(block.timestamp);
1221 
1222             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1223             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1224             uint256 nextTokenId = tokenId + 1;
1225             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1226             if (nextSlot.addr == address(0)) {
1227                 // This will suffice for checking _exists(nextTokenId),
1228                 // as a burned slot cannot contain the zero address.
1229                 if (nextTokenId != _currentIndex) {
1230                     nextSlot.addr = from;
1231                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1232                 }
1233             }
1234         }
1235 
1236         emit Transfer(from, to, tokenId);
1237         _afterTokenTransfers(from, to, tokenId, 1);
1238     }
1239 
1240     /**
1241      * @dev Equivalent to `_burn(tokenId, false)`.
1242      */
1243     function _burn(uint256 tokenId) internal virtual {
1244         _burn(tokenId, false);
1245     }
1246 
1247     /**
1248      * @dev Destroys `tokenId`.
1249      * The approval is cleared when the token is burned.
1250      *
1251      * Requirements:
1252      *
1253      * - `tokenId` must exist.
1254      *
1255      * Emits a {Transfer} event.
1256      */
1257     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1258         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1259 
1260         address from = prevOwnership.addr;
1261 
1262         if (approvalCheck) {
1263             bool isApprovedOrOwner = (_msgSender() == from ||
1264                 isApprovedForAll(from, _msgSender()) ||
1265                 getApproved(tokenId) == _msgSender());
1266 
1267             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1268         }
1269 
1270         _beforeTokenTransfers(from, address(0), tokenId, 1);
1271 
1272         // Clear approvals from the previous owner
1273         _approve(address(0), tokenId, from);
1274 
1275         // Underflow of the sender's balance is impossible because we check for
1276         // ownership above and the recipient's balance can't realistically overflow.
1277         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1278         unchecked {
1279             AddressData storage addressData = _addressData[from];
1280             addressData.balance -= 1;
1281             addressData.numberBurned += 1;
1282 
1283             // Keep track of who burned the token, and the timestamp of burning.
1284             TokenOwnership storage currSlot = _ownerships[tokenId];
1285             currSlot.addr = from;
1286             currSlot.startTimestamp = uint64(block.timestamp);
1287             currSlot.burned = true;
1288 
1289             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1290             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1291             uint256 nextTokenId = tokenId + 1;
1292             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1293             if (nextSlot.addr == address(0)) {
1294                 // This will suffice for checking _exists(nextTokenId),
1295                 // as a burned slot cannot contain the zero address.
1296                 if (nextTokenId != _currentIndex) {
1297                     nextSlot.addr = from;
1298                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1299                 }
1300             }
1301         }
1302 
1303         emit Transfer(from, address(0), tokenId);
1304         _afterTokenTransfers(from, address(0), tokenId, 1);
1305 
1306         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1307         unchecked {
1308             _burnCounter++;
1309         }
1310     }
1311 
1312     /**
1313      * @dev Approve `to` to operate on `tokenId`
1314      *
1315      * Emits a {Approval} event.
1316      */
1317     function _approve(
1318         address to,
1319         uint256 tokenId,
1320         address owner
1321     ) private {
1322         _tokenApprovals[tokenId] = to;
1323         emit Approval(owner, to, tokenId);
1324     }
1325 
1326     /**
1327      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1328      *
1329      * @param from address representing the previous owner of the given token ID
1330      * @param to target address that will receive the tokens
1331      * @param tokenId uint256 ID of the token to be transferred
1332      * @param _data bytes optional data to send along with the call
1333      * @return bool whether the call correctly returned the expected magic value
1334      */
1335     function _checkContractOnERC721Received(
1336         address from,
1337         address to,
1338         uint256 tokenId,
1339         bytes memory _data
1340     ) private returns (bool) {
1341         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1342             return retval == IERC721Receiver(to).onERC721Received.selector;
1343         } catch (bytes memory reason) {
1344             if (reason.length == 0) {
1345                 revert TransferToNonERC721ReceiverImplementer();
1346             } else {
1347                 assembly {
1348                     revert(add(32, reason), mload(reason))
1349                 }
1350             }
1351         }
1352     }
1353 
1354     /**
1355      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1356      * And also called before burning one token.
1357      *
1358      * startTokenId - the first token id to be transferred
1359      * quantity - the amount to be transferred
1360      *
1361      * Calling conditions:
1362      *
1363      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1364      * transferred to `to`.
1365      * - When `from` is zero, `tokenId` will be minted for `to`.
1366      * - When `to` is zero, `tokenId` will be burned by `from`.
1367      * - `from` and `to` are never both zero.
1368      */
1369     function _beforeTokenTransfers(
1370         address from,
1371         address to,
1372         uint256 startTokenId,
1373         uint256 quantity
1374     ) internal virtual {}
1375 
1376     /**
1377      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1378      * minting.
1379      * And also called after one token has been burned.
1380      *
1381      * startTokenId - the first token id to be transferred
1382      * quantity - the amount to be transferred
1383      *
1384      * Calling conditions:
1385      *
1386      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1387      * transferred to `to`.
1388      * - When `from` is zero, `tokenId` has been minted for `to`.
1389      * - When `to` is zero, `tokenId` has been burned by `from`.
1390      * - `from` and `to` are never both zero.
1391      */
1392     function _afterTokenTransfers(
1393         address from,
1394         address to,
1395         uint256 startTokenId,
1396         uint256 quantity
1397     ) internal virtual {}
1398 }
1399 // File: contracts/PepesNotAJoke.sol
1400 
1401 
1402 
1403 pragma solidity ^0.8.0;
1404 
1405 
1406 
1407 
1408 
1409 contract PepesNotAJoke is ERC721A, Ownable, ReentrancyGuard {
1410   using Address for address;
1411   using Strings for uint;
1412 
1413 
1414   string  public  baseTokenURI = "ipfs://QmWgNMaJ7w95oh4XfjxCPkwB1MkCNVHDMdZiEuvqkS7kmF/";
1415   uint256  public  maxSupply = 5555;
1416   uint256 public  MAX_MINTS_PER_TX = 20;
1417   uint256 public  PUBLIC_SALE_PRICE = 0.003 ether;
1418   uint256 public  NUM_FREE_MINTS = 5555;
1419   uint256 public  MAX_FREE_PER_WALLET = 1;
1420   uint256 public freeNFTAlreadyMinted = 0;
1421   bool public isPublicSaleActive = false;
1422 
1423   constructor(
1424 
1425   ) ERC721A("PepesNotAJoke", "PepesNotAJoke") {
1426 
1427   }
1428 
1429 
1430   function mint(uint256 numberOfTokens)
1431       external
1432       payable
1433   {
1434     require(isPublicSaleActive, "Public sale is not open");
1435     require(totalSupply() + numberOfTokens < maxSupply + 1, "No more");
1436 
1437     if(freeNFTAlreadyMinted + numberOfTokens > NUM_FREE_MINTS){
1438         require(
1439             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1440             "Incorrect ETH value sent"
1441         );
1442     } else {
1443         if (balanceOf(msg.sender) + numberOfTokens > MAX_FREE_PER_WALLET) {
1444         require(
1445             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1446             "Incorrect ETH value sent"
1447         );
1448         require(
1449             numberOfTokens <= MAX_MINTS_PER_TX,
1450             "Max mints per transaction exceeded"
1451         );
1452         } else {
1453             require(
1454                 numberOfTokens <= MAX_FREE_PER_WALLET,
1455                 "Max mints per transaction exceeded"
1456             );
1457             freeNFTAlreadyMinted += numberOfTokens;
1458         }
1459     }
1460     _safeMint(msg.sender, numberOfTokens);
1461   }
1462 
1463   function setBaseURI(string memory baseURI)
1464     public
1465     onlyOwner
1466   {
1467     baseTokenURI = baseURI;
1468   }
1469 
1470   function treasuryMint(uint quantity)
1471     public
1472     onlyOwner
1473   {
1474     require(
1475       quantity > 0,
1476       "Invalid mint amount"
1477     );
1478     require(
1479       totalSupply() + quantity <= maxSupply,
1480       "Maximum supply exceeded"
1481     );
1482     _safeMint(msg.sender, quantity);
1483   }
1484 
1485   function withdraw()
1486     public
1487     onlyOwner
1488     nonReentrant
1489   {
1490     Address.sendValue(payable(msg.sender), address(this).balance);
1491   }
1492 
1493   function tokenURI(uint _tokenId)
1494     public
1495     view
1496     virtual
1497     override
1498     returns (string memory)
1499   {
1500     require(
1501       _exists(_tokenId),
1502       "ERC721Metadata: URI query for nonexistent token"
1503     );
1504     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1505   }
1506 
1507   function _baseURI()
1508     internal
1509     view
1510     virtual
1511     override
1512     returns (string memory)
1513   {
1514     return baseTokenURI;
1515   }
1516 
1517   function setIsPublicSaleActive(bool _isPublicSaleActive)
1518       external
1519       onlyOwner
1520   {
1521       isPublicSaleActive = _isPublicSaleActive;
1522   }
1523 
1524   function setNumFreeMints(uint256 _numfreemints)
1525       external
1526       onlyOwner
1527   {
1528       NUM_FREE_MINTS = _numfreemints;
1529   }
1530 
1531   function setSalePrice(uint256 _price)
1532       external
1533       onlyOwner
1534   {
1535       PUBLIC_SALE_PRICE = _price;
1536   }
1537 
1538   function setMaxLimitPerTransaction(uint256 _limit)
1539       external
1540       onlyOwner
1541   {
1542       MAX_MINTS_PER_TX = _limit;
1543   }
1544 
1545   function setFreeLimitPerWallet(uint256 _limit)
1546       external
1547       onlyOwner
1548   {
1549       MAX_FREE_PER_WALLET = _limit;
1550   }
1551 }