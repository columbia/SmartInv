1 /**
2 
3 
4 
5 ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
6 ─██████████████───██████████████─████████████████───██████████████─████████████──────██████████████─██████████████─██████████████─
7 ─██░░░░░░░░░░██───██░░░░░░░░░░██─██░░░░░░░░░░░░██───██░░░░░░░░░░██─██░░░░░░░░████────██░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─
8 ─██░░██████░░██───██░░██████░░██─██░░████████░░██───██░░██████████─██░░████░░░░██────██░░██████░░██─██░░██████░░██─██░░██████████─
9 ─██░░██──██░░██───██░░██──██░░██─██░░██────██░░██───██░░██─────────██░░██──██░░██────██░░██──██░░██─██░░██──██░░██─██░░██─────────
10 ─██░░██████░░████─██░░██──██░░██─██░░████████░░██───██░░██████████─██░░██──██░░██────██░░██████░░██─██░░██████░░██─██░░██████████─
11 ─██░░░░░░░░░░░░██─██░░██──██░░██─██░░░░░░░░░░░░██───██░░░░░░░░░░██─██░░██──██░░██────██░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─
12 ─██░░████████░░██─██░░██──██░░██─██░░██████░░████───██░░██████████─██░░██──██░░██────██░░██████░░██─██░░██████████─██░░██████████─
13 ─██░░██────██░░██─██░░██──██░░██─██░░██──██░░██─────██░░██─────────██░░██──██░░██────██░░██──██░░██─██░░██─────────██░░██─────────
14 ─██░░████████░░██─██░░██████░░██─██░░██──██░░██████─██░░██████████─██░░████░░░░██────██░░██──██░░██─██░░██─────────██░░██████████─
15 ─██░░░░░░░░░░░░██─██░░░░░░░░░░██─██░░██──██░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░████────██░░██──██░░██─██░░██─────────██░░░░░░░░░░██─
16 ─████████████████─██████████████─██████──██████████─██████████████─████████████──────██████──██████─██████─────────██████████████─
17 ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
18 ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
19 ─████████──████████─██████████████─██████████████─██████████████─██████████████────██████████████─██████─────────██████──██████─██████████████───
20 ─██░░░░██──██░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██────██░░░░░░░░░░██─██░░██─────────██░░██──██░░██─██░░░░░░░░░░██───
21 ─████░░██──██░░████─██░░██████░░██─██░░██████░░██─██████░░██████─██░░██████████────██░░██████████─██░░██─────────██░░██──██░░██─██░░██████░░██───
22 ───██░░░░██░░░░██───██░░██──██░░██─██░░██──██░░██─────██░░██─────██░░██────────────██░░██─────────██░░██─────────██░░██──██░░██─██░░██──██░░██───
23 ───████░░░░░░████───██░░██──██░░██─██░░██──██░░██─────██░░██─────██░░██████████────██░░██─────────██░░██─────────██░░██──██░░██─██░░██████░░████─
24 ─────████░░████─────██░░██──██░░██─██░░██──██░░██─────██░░██─────██░░░░░░░░░░██────██░░██─────────██░░██─────────██░░██──██░░██─██░░░░░░░░░░░░██─
25 ───────██░░██───────██░░██──██░░██─██░░██──██░░██─────██░░██─────██████████░░██────██░░██─────────██░░██─────────██░░██──██░░██─██░░████████░░██─
26 ───────██░░██───────██░░██──██░░██─██░░██──██░░██─────██░░██─────────────██░░██────██░░██─────────██░░██─────────██░░██──██░░██─██░░██────██░░██─
27 ───────██░░██───────██░░██████░░██─██░░██████░░██─────██░░██─────██████████░░██────██░░██████████─██░░██████████─██░░██████░░██─██░░████████░░██─
28 ───────██░░██───────██░░░░░░░░░░██─██░░░░░░░░░░██─────██░░██─────██░░░░░░░░░░██────██░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░░░██─
29 ───────██████───────██████████████─██████████████─────██████─────██████████████────██████████████─██████████████─██████████████─████████████████─
30 ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
31                                                                           
32 
33 */
34 
35 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
36 
37 // SPDX-License-Identifier: MIT
38 
39 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
40 
41 pragma solidity ^0.8.0;
42 
43 /**
44  * @dev Contract module that helps prevent reentrant calls to a function.
45  *
46  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
47  * available, which can be applied to functions to make sure there are no nested
48  * (reentrant) calls to them.
49  *
50  * Note that because there is a single `nonReentrant` guard, functions marked as
51  * `nonReentrant` may not call one another. This can be worked around by making
52  * those functions `private`, and then adding `external` `nonReentrant` entry
53  * points to them.
54  *
55  * TIP: If you would like to learn more about reentrancy and alternative ways
56  * to protect against it, check out our blog post
57  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
58  */
59 abstract contract ReentrancyGuard {
60     // Booleans are more expensive than uint256 or any type that takes up a full
61     // word because each write operation emits an extra SLOAD to first read the
62     // slot's contents, replace the bits taken up by the boolean, and then write
63     // back. This is the compiler's defense against contract upgrades and
64     // pointer aliasing, and it cannot be disabled.
65 
66     // The values being non-zero value makes deployment a bit more expensive,
67     // but in exchange the refund on every call to nonReentrant will be lower in
68     // amount. Since refunds are capped to a percentage of the total
69     // transaction's gas, it is best to keep them low in cases like this one, to
70     // increase the likelihood of the full refund coming into effect.
71     uint256 private constant _NOT_ENTERED = 1;
72     uint256 private constant _ENTERED = 2;
73 
74     uint256 private _status;
75 
76     constructor() {
77         _status = _NOT_ENTERED;
78     }
79 
80     /**
81      * @dev Prevents a contract from calling itself, directly or indirectly.
82      * Calling a `nonReentrant` function from another `nonReentrant`
83      * function is not supported. It is possible to prevent this from happening
84      * by making the `nonReentrant` function external, and making it call a
85      * `private` function that does the actual work.
86      */
87     modifier nonReentrant() {
88         // On the first call to nonReentrant, _notEntered will be true
89         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
90 
91         // Any calls to nonReentrant after this point will fail
92         _status = _ENTERED;
93 
94         _;
95 
96         // By storing the original value once again, a refund is triggered (see
97         // https://eips.ethereum.org/EIPS/eip-2200)
98         _status = _NOT_ENTERED;
99     }
100 }
101 
102 // File: @openzeppelin/contracts/utils/Strings.sol
103 
104 
105 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
106 
107 pragma solidity ^0.8.0;
108 
109 /**
110  * @dev String operations.
111  */
112 library Strings {
113     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
114 
115     /**
116      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
117      */
118     function toString(uint256 value) internal pure returns (string memory) {
119         // Inspired by OraclizeAPI's implementation - MIT licence
120         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
121 
122         if (value == 0) {
123             return "0";
124         }
125         uint256 temp = value;
126         uint256 digits;
127         while (temp != 0) {
128             digits++;
129             temp /= 10;
130         }
131         bytes memory buffer = new bytes(digits);
132         while (value != 0) {
133             digits -= 1;
134             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
135             value /= 10;
136         }
137         return string(buffer);
138     }
139 
140     /**
141      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
142      */
143     function toHexString(uint256 value) internal pure returns (string memory) {
144         if (value == 0) {
145             return "0x00";
146         }
147         uint256 temp = value;
148         uint256 length = 0;
149         while (temp != 0) {
150             length++;
151             temp >>= 8;
152         }
153         return toHexString(value, length);
154     }
155 
156     /**
157      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
158      */
159     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
160         bytes memory buffer = new bytes(2 * length + 2);
161         buffer[0] = "0";
162         buffer[1] = "x";
163         for (uint256 i = 2 * length + 1; i > 1; --i) {
164             buffer[i] = _HEX_SYMBOLS[value & 0xf];
165             value >>= 4;
166         }
167         require(value == 0, "Strings: hex length insufficient");
168         return string(buffer);
169     }
170 }
171 
172 // File: @openzeppelin/contracts/utils/Context.sol
173 
174 
175 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
176 
177 pragma solidity ^0.8.0;
178 
179 /**
180  * @dev Provides information about the current execution context, including the
181  * sender of the transaction and its data. While these are generally available
182  * via msg.sender and msg.data, they should not be accessed in such a direct
183  * manner, since when dealing with meta-transactions the account sending and
184  * paying for execution may not be the actual sender (as far as an application
185  * is concerned).
186  *
187  * This contract is only required for intermediate, library-like contracts.
188  */
189 abstract contract Context {
190     function _msgSender() internal view virtual returns (address) {
191         return msg.sender;
192     }
193 
194     function _msgData() internal view virtual returns (bytes calldata) {
195         return msg.data;
196     }
197 }
198 
199 // File: @openzeppelin/contracts/access/Ownable.sol
200 
201 
202 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
203 
204 pragma solidity ^0.8.0;
205 
206 
207 /**
208  * @dev Contract module which provides a basic access control mechanism, where
209  * there is an account (an owner) that can be granted exclusive access to
210  * specific functions.
211  *
212  * By default, the owner account will be the one that deploys the contract. This
213  * can later be changed with {transferOwnership}.
214  *
215  * This module is used through inheritance. It will make available the modifier
216  * `onlyOwner`, which can be applied to your functions to restrict their use to
217  * the owner.
218  */
219 abstract contract Ownable is Context {
220     address private _owner;
221 
222     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
223 
224     /**
225      * @dev Initializes the contract setting the deployer as the initial owner.
226      */
227     constructor() {
228         _transferOwnership(_msgSender());
229     }
230 
231     /**
232      * @dev Returns the address of the current owner.
233      */
234     function owner() public view virtual returns (address) {
235         return _owner;
236     }
237 
238     /**
239      * @dev Throws if called by any account other than the owner.
240      */
241     modifier onlyOwner() {
242         require(owner() == _msgSender(), "Ownable: caller is not the owner");
243         _;
244     }
245 
246     /**
247      * @dev Leaves the contract without owner. It will not be possible to call
248      * `onlyOwner` functions anymore. Can only be called by the current owner.
249      *
250      * NOTE: Renouncing ownership will leave the contract without an owner,
251      * thereby removing any functionality that is only available to the owner.
252      */
253     function renounceOwnership() public virtual onlyOwner {
254         _transferOwnership(address(0));
255     }
256 
257     /**
258      * @dev Transfers ownership of the contract to a new account (`newOwner`).
259      * Can only be called by the current owner.
260      */
261     function transferOwnership(address newOwner) public virtual onlyOwner {
262         require(newOwner != address(0), "Ownable: new owner is the zero address");
263         _transferOwnership(newOwner);
264     }
265 
266     /**
267      * @dev Transfers ownership of the contract to a new account (`newOwner`).
268      * Internal function without access restriction.
269      */
270     function _transferOwnership(address newOwner) internal virtual {
271         address oldOwner = _owner;
272         _owner = newOwner;
273         emit OwnershipTransferred(oldOwner, newOwner);
274     }
275 }
276 
277 // File: @openzeppelin/contracts/utils/Address.sol
278 
279 
280 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
281 
282 pragma solidity ^0.8.1;
283 
284 /**
285  * @dev Collection of functions related to the address type
286  */
287 library Address {
288     /**
289      * @dev Returns true if `account` is a contract.
290      *
291      * [IMPORTANT]
292      * ====
293      * It is unsafe to assume that an address for which this function returns
294      * false is an externally-owned account (EOA) and not a contract.
295      *
296      * Among others, `isContract` will return false for the following
297      * types of addresses:
298      *
299      *  - an externally-owned account
300      *  - a contract in construction
301      *  - an address where a contract will be created
302      *  - an address where a contract lived, but was destroyed
303      * ====
304      *
305      * [IMPORTANT]
306      * ====
307      * You shouldn't rely on `isContract` to protect against flash loan attacks!
308      *
309      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
310      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
311      * constructor.
312      * ====
313      */
314     function isContract(address account) internal view returns (bool) {
315         // This method relies on extcodesize/address.code.length, which returns 0
316         // for contracts in construction, since the code is only stored at the end
317         // of the constructor execution.
318 
319         return account.code.length > 0;
320     }
321 
322     /**
323      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
324      * `recipient`, forwarding all available gas and reverting on errors.
325      *
326      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
327      * of certain opcodes, possibly making contracts go over the 2300 gas limit
328      * imposed by `transfer`, making them unable to receive funds via
329      * `transfer`. {sendValue} removes this limitation.
330      *
331      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
332      *
333      * IMPORTANT: because control is transferred to `recipient`, care must be
334      * taken to not create reentrancy vulnerabilities. Consider using
335      * {ReentrancyGuard} or the
336      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
337      */
338     function sendValue(address payable recipient, uint256 amount) internal {
339         require(address(this).balance >= amount, "Address: insufficient balance");
340 
341         (bool success, ) = recipient.call{value: amount}("");
342         require(success, "Address: unable to send value, recipient may have reverted");
343     }
344 
345     /**
346      * @dev Performs a Solidity function call using a low level `call`. A
347      * plain `call` is an unsafe replacement for a function call: use this
348      * function instead.
349      *
350      * If `target` reverts with a revert reason, it is bubbled up by this
351      * function (like regular Solidity function calls).
352      *
353      * Returns the raw returned data. To convert to the expected return value,
354      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
355      *
356      * Requirements:
357      *
358      * - `target` must be a contract.
359      * - calling `target` with `data` must not revert.
360      *
361      * _Available since v3.1._
362      */
363     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
364         return functionCall(target, data, "Address: low-level call failed");
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
369      * `errorMessage` as a fallback revert reason when `target` reverts.
370      *
371      * _Available since v3.1._
372      */
373     function functionCall(
374         address target,
375         bytes memory data,
376         string memory errorMessage
377     ) internal returns (bytes memory) {
378         return functionCallWithValue(target, data, 0, errorMessage);
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
383      * but also transferring `value` wei to `target`.
384      *
385      * Requirements:
386      *
387      * - the calling contract must have an ETH balance of at least `value`.
388      * - the called Solidity function must be `payable`.
389      *
390      * _Available since v3.1._
391      */
392     function functionCallWithValue(
393         address target,
394         bytes memory data,
395         uint256 value
396     ) internal returns (bytes memory) {
397         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
402      * with `errorMessage` as a fallback revert reason when `target` reverts.
403      *
404      * _Available since v3.1._
405      */
406     function functionCallWithValue(
407         address target,
408         bytes memory data,
409         uint256 value,
410         string memory errorMessage
411     ) internal returns (bytes memory) {
412         require(address(this).balance >= value, "Address: insufficient balance for call");
413         require(isContract(target), "Address: call to non-contract");
414 
415         (bool success, bytes memory returndata) = target.call{value: value}(data);
416         return verifyCallResult(success, returndata, errorMessage);
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
421      * but performing a static call.
422      *
423      * _Available since v3.3._
424      */
425     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
426         return functionStaticCall(target, data, "Address: low-level static call failed");
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
431      * but performing a static call.
432      *
433      * _Available since v3.3._
434      */
435     function functionStaticCall(
436         address target,
437         bytes memory data,
438         string memory errorMessage
439     ) internal view returns (bytes memory) {
440         require(isContract(target), "Address: static call to non-contract");
441 
442         (bool success, bytes memory returndata) = target.staticcall(data);
443         return verifyCallResult(success, returndata, errorMessage);
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
448      * but performing a delegate call.
449      *
450      * _Available since v3.4._
451      */
452     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
453         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
458      * but performing a delegate call.
459      *
460      * _Available since v3.4._
461      */
462     function functionDelegateCall(
463         address target,
464         bytes memory data,
465         string memory errorMessage
466     ) internal returns (bytes memory) {
467         require(isContract(target), "Address: delegate call to non-contract");
468 
469         (bool success, bytes memory returndata) = target.delegatecall(data);
470         return verifyCallResult(success, returndata, errorMessage);
471     }
472 
473     /**
474      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
475      * revert reason using the provided one.
476      *
477      * _Available since v4.3._
478      */
479     function verifyCallResult(
480         bool success,
481         bytes memory returndata,
482         string memory errorMessage
483     ) internal pure returns (bytes memory) {
484         if (success) {
485             return returndata;
486         } else {
487             // Look for revert reason and bubble it up if present
488             if (returndata.length > 0) {
489                 // The easiest way to bubble the revert reason is using memory via assembly
490 
491                 assembly {
492                     let returndata_size := mload(returndata)
493                     revert(add(32, returndata), returndata_size)
494                 }
495             } else {
496                 revert(errorMessage);
497             }
498         }
499     }
500 }
501 
502 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
503 
504 
505 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
506 
507 pragma solidity ^0.8.0;
508 
509 /**
510  * @title ERC721 token receiver interface
511  * @dev Interface for any contract that wants to support safeTransfers
512  * from ERC721 asset contracts.
513  */
514 interface IERC721Receiver {
515     /**
516      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
517      * by `operator` from `from`, this function is called.
518      *
519      * It must return its Solidity selector to confirm the token transfer.
520      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
521      *
522      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
523      */
524     function onERC721Received(
525         address operator,
526         address from,
527         uint256 tokenId,
528         bytes calldata data
529     ) external returns (bytes4);
530 }
531 
532 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
533 
534 
535 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
536 
537 pragma solidity ^0.8.0;
538 
539 /**
540  * @dev Interface of the ERC165 standard, as defined in the
541  * https://eips.ethereum.org/EIPS/eip-165[EIP].
542  *
543  * Implementers can declare support of contract interfaces, which can then be
544  * queried by others ({ERC165Checker}).
545  *
546  * For an implementation, see {ERC165}.
547  */
548 interface IERC165 {
549     /**
550      * @dev Returns true if this contract implements the interface defined by
551      * `interfaceId`. See the corresponding
552      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
553      * to learn more about how these ids are created.
554      *
555      * This function call must use less than 30 000 gas.
556      */
557     function supportsInterface(bytes4 interfaceId) external view returns (bool);
558 }
559 
560 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
561 
562 
563 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
564 
565 pragma solidity ^0.8.0;
566 
567 
568 /**
569  * @dev Implementation of the {IERC165} interface.
570  *
571  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
572  * for the additional interface id that will be supported. For example:
573  *
574  * ```solidity
575  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
576  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
577  * }
578  * ```
579  *
580  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
581  */
582 abstract contract ERC165 is IERC165 {
583     /**
584      * @dev See {IERC165-supportsInterface}.
585      */
586     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
587         return interfaceId == type(IERC165).interfaceId;
588     }
589 }
590 
591 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
592 
593 
594 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
595 
596 pragma solidity ^0.8.0;
597 
598 
599 /**
600  * @dev Required interface of an ERC721 compliant contract.
601  */
602 interface IERC721 is IERC165 {
603     /**
604      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
605      */
606     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
607 
608     /**
609      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
610      */
611     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
612 
613     /**
614      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
615      */
616     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
617 
618     /**
619      * @dev Returns the number of tokens in ``owner``'s account.
620      */
621     function balanceOf(address owner) external view returns (uint256 balance);
622 
623     /**
624      * @dev Returns the owner of the `tokenId` token.
625      *
626      * Requirements:
627      *
628      * - `tokenId` must exist.
629      */
630     function ownerOf(uint256 tokenId) external view returns (address owner);
631 
632     /**
633      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
634      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
635      *
636      * Requirements:
637      *
638      * - `from` cannot be the zero address.
639      * - `to` cannot be the zero address.
640      * - `tokenId` token must exist and be owned by `from`.
641      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
642      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
643      *
644      * Emits a {Transfer} event.
645      */
646     function safeTransferFrom(
647         address from,
648         address to,
649         uint256 tokenId
650     ) external;
651 
652     /**
653      * @dev Transfers `tokenId` token from `from` to `to`.
654      *
655      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
656      *
657      * Requirements:
658      *
659      * - `from` cannot be the zero address.
660      * - `to` cannot be the zero address.
661      * - `tokenId` token must be owned by `from`.
662      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
663      *
664      * Emits a {Transfer} event.
665      */
666     function transferFrom(
667         address from,
668         address to,
669         uint256 tokenId
670     ) external;
671 
672     /**
673      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
674      * The approval is cleared when the token is transferred.
675      *
676      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
677      *
678      * Requirements:
679      *
680      * - The caller must own the token or be an approved operator.
681      * - `tokenId` must exist.
682      *
683      * Emits an {Approval} event.
684      */
685     function approve(address to, uint256 tokenId) external;
686 
687     /**
688      * @dev Returns the account approved for `tokenId` token.
689      *
690      * Requirements:
691      *
692      * - `tokenId` must exist.
693      */
694     function getApproved(uint256 tokenId) external view returns (address operator);
695 
696     /**
697      * @dev Approve or remove `operator` as an operator for the caller.
698      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
699      *
700      * Requirements:
701      *
702      * - The `operator` cannot be the caller.
703      *
704      * Emits an {ApprovalForAll} event.
705      */
706     function setApprovalForAll(address operator, bool _approved) external;
707 
708     /**
709      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
710      *
711      * See {setApprovalForAll}
712      */
713     function isApprovedForAll(address owner, address operator) external view returns (bool);
714 
715     /**
716      * @dev Safely transfers `tokenId` token from `from` to `to`.
717      *
718      * Requirements:
719      *
720      * - `from` cannot be the zero address.
721      * - `to` cannot be the zero address.
722      * - `tokenId` token must exist and be owned by `from`.
723      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
724      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
725      *
726      * Emits a {Transfer} event.
727      */
728     function safeTransferFrom(
729         address from,
730         address to,
731         uint256 tokenId,
732         bytes calldata data
733     ) external;
734 }
735 
736 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
737 
738 
739 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
740 
741 pragma solidity ^0.8.0;
742 
743 
744 /**
745  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
746  * @dev See https://eips.ethereum.org/EIPS/eip-721
747  */
748 interface IERC721Metadata is IERC721 {
749     /**
750      * @dev Returns the token collection name.
751      */
752     function name() external view returns (string memory);
753 
754     /**
755      * @dev Returns the token collection symbol.
756      */
757     function symbol() external view returns (string memory);
758 
759     /**
760      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
761      */
762     function tokenURI(uint256 tokenId) external view returns (string memory);
763 }
764 
765 // File: contracts/ERC721A.sol
766 
767 
768 // Creator: Chiru Labs
769 
770 pragma solidity ^0.8.4;
771 
772 
773 
774 
775 
776 
777 
778 
779 error ApprovalCallerNotOwnerNorApproved();
780 error ApprovalQueryForNonexistentToken();
781 error ApproveToCaller();
782 error ApprovalToCurrentOwner();
783 error BalanceQueryForZeroAddress();
784 error MintToZeroAddress();
785 error MintZeroQuantity();
786 error OwnerQueryForNonexistentToken();
787 error TransferCallerNotOwnerNorApproved();
788 error TransferFromIncorrectOwner();
789 error TransferToNonERC721ReceiverImplementer();
790 error TransferToZeroAddress();
791 error URIQueryForNonexistentToken();
792 
793 /**
794  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
795  * the Metadata extension. Built to optimize for lower gas during batch mints.
796  *
797  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
798  *
799  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
800  *
801  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
802  */
803 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
804     using Address for address;
805     using Strings for uint256;
806 
807     // Compiler will pack this into a single 256bit word.
808     struct TokenOwnership {
809         // The address of the owner.
810         address addr;
811         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
812         uint64 startTimestamp;
813         // Whether the token has been burned.
814         bool burned;
815     }
816 
817     // Compiler will pack this into a single 256bit word.
818     struct AddressData {
819         // Realistically, 2**64-1 is more than enough.
820         uint64 balance;
821         // Keeps track of mint count with minimal overhead for tokenomics.
822         uint64 numberMinted;
823         // Keeps track of burn count with minimal overhead for tokenomics.
824         uint64 numberBurned;
825         // For miscellaneous variable(s) pertaining to the address
826         // (e.g. number of whitelist mint slots used).
827         // If there are multiple variables, please pack them into a uint64.
828         uint64 aux;
829     }
830 
831     // The tokenId of the next token to be minted.
832     uint256 internal _currentIndex;
833 
834     // The number of tokens burned.
835     uint256 internal _burnCounter;
836 
837     // Token name
838     string private _name;
839 
840     // Token symbol
841     string private _symbol;
842 
843     // Mapping from token ID to ownership details
844     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
845     mapping(uint256 => TokenOwnership) internal _ownerships;
846 
847     // Mapping owner address to address data
848     mapping(address => AddressData) private _addressData;
849 
850     // Mapping from token ID to approved address
851     mapping(uint256 => address) private _tokenApprovals;
852 
853     // Mapping from owner to operator approvals
854     mapping(address => mapping(address => bool)) private _operatorApprovals;
855 
856     constructor(string memory name_, string memory symbol_) {
857         _name = name_;
858         _symbol = symbol_;
859         _currentIndex = _startTokenId();
860     }
861 
862     /**
863      * To change the starting tokenId, please override this function.
864      */
865     function _startTokenId() internal view virtual returns (uint256) {
866         return 1;
867     }
868 
869     /**
870      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
871      */
872     function totalSupply() public view returns (uint256) {
873         // Counter underflow is impossible as _burnCounter cannot be incremented
874         // more than _currentIndex - _startTokenId() times
875         unchecked {
876             return _currentIndex - _burnCounter - _startTokenId();
877         }
878     }
879 
880     /**
881      * Returns the total amount of tokens minted in the contract.
882      */
883     function _totalMinted() internal view returns (uint256) {
884         // Counter underflow is impossible as _currentIndex does not decrement,
885         // and it is initialized to _startTokenId()
886         unchecked {
887             return _currentIndex - _startTokenId();
888         }
889     }
890 
891     /**
892      * @dev See {IERC165-supportsInterface}.
893      */
894     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
895         return
896             interfaceId == type(IERC721).interfaceId ||
897             interfaceId == type(IERC721Metadata).interfaceId ||
898             super.supportsInterface(interfaceId);
899     }
900 
901     /**
902      * @dev See {IERC721-balanceOf}.
903      */
904     function balanceOf(address owner) public view override returns (uint256) {
905         if (owner == address(0)) revert BalanceQueryForZeroAddress();
906         return uint256(_addressData[owner].balance);
907     }
908 
909     /**
910      * Returns the number of tokens minted by `owner`.
911      */
912     function _numberMinted(address owner) internal view returns (uint256) {
913         return uint256(_addressData[owner].numberMinted);
914     }
915 
916     /**
917      * Returns the number of tokens burned by or on behalf of `owner`.
918      */
919     function _numberBurned(address owner) internal view returns (uint256) {
920         return uint256(_addressData[owner].numberBurned);
921     }
922 
923     /**
924      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
925      */
926     function _getAux(address owner) internal view returns (uint64) {
927         return _addressData[owner].aux;
928     }
929 
930     /**
931      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
932      * If there are multiple variables, please pack them into a uint64.
933      */
934     function _setAux(address owner, uint64 aux) internal {
935         _addressData[owner].aux = aux;
936     }
937 
938     /**
939      * Gas spent here starts off proportional to the maximum mint batch size.
940      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
941      */
942     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
943         uint256 curr = tokenId;
944 
945         unchecked {
946             if (_startTokenId() <= curr && curr < _currentIndex) {
947                 TokenOwnership memory ownership = _ownerships[curr];
948                 if (!ownership.burned) {
949                     if (ownership.addr != address(0)) {
950                         return ownership;
951                     }
952                     // Invariant:
953                     // There will always be an ownership that has an address and is not burned
954                     // before an ownership that does not have an address and is not burned.
955                     // Hence, curr will not underflow.
956                     while (true) {
957                         curr--;
958                         ownership = _ownerships[curr];
959                         if (ownership.addr != address(0)) {
960                             return ownership;
961                         }
962                     }
963                 }
964             }
965         }
966         revert OwnerQueryForNonexistentToken();
967     }
968 
969     /**
970      * @dev See {IERC721-ownerOf}.
971      */
972     function ownerOf(uint256 tokenId) public view override returns (address) {
973         return _ownershipOf(tokenId).addr;
974     }
975 
976     /**
977      * @dev See {IERC721Metadata-name}.
978      */
979     function name() public view virtual override returns (string memory) {
980         return _name;
981     }
982 
983     /**
984      * @dev See {IERC721Metadata-symbol}.
985      */
986     function symbol() public view virtual override returns (string memory) {
987         return _symbol;
988     }
989 
990     /**
991      * @dev See {IERC721Metadata-tokenURI}.
992      */
993     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
994         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
995 
996         string memory baseURI = _baseURI();
997         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
998     }
999 
1000     /**
1001      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1002      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1003      * by default, can be overriden in child contracts.
1004      */
1005     function _baseURI() internal view virtual returns (string memory) {
1006         return '';
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-approve}.
1011      */
1012     function approve(address to, uint256 tokenId) public override {
1013         address owner = ERC721A.ownerOf(tokenId);
1014         if (to == owner) revert ApprovalToCurrentOwner();
1015 
1016         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1017             revert ApprovalCallerNotOwnerNorApproved();
1018         }
1019 
1020         _approve(to, tokenId, owner);
1021     }
1022 
1023     /**
1024      * @dev See {IERC721-getApproved}.
1025      */
1026     function getApproved(uint256 tokenId) public view override returns (address) {
1027         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1028 
1029         return _tokenApprovals[tokenId];
1030     }
1031 
1032     /**
1033      * @dev See {IERC721-setApprovalForAll}.
1034      */
1035     function setApprovalForAll(address operator, bool approved) public virtual override {
1036         if (operator == _msgSender()) revert ApproveToCaller();
1037 
1038         _operatorApprovals[_msgSender()][operator] = approved;
1039         emit ApprovalForAll(_msgSender(), operator, approved);
1040     }
1041 
1042     /**
1043      * @dev See {IERC721-isApprovedForAll}.
1044      */
1045     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1046         return _operatorApprovals[owner][operator];
1047     }
1048 
1049     /**
1050      * @dev See {IERC721-transferFrom}.
1051      */
1052     function transferFrom(
1053         address from,
1054         address to,
1055         uint256 tokenId
1056     ) public virtual override {
1057         _transfer(from, to, tokenId);
1058     }
1059 
1060     /**
1061      * @dev See {IERC721-safeTransferFrom}.
1062      */
1063     function safeTransferFrom(
1064         address from,
1065         address to,
1066         uint256 tokenId
1067     ) public virtual override {
1068         safeTransferFrom(from, to, tokenId, '');
1069     }
1070 
1071     /**
1072      * @dev See {IERC721-safeTransferFrom}.
1073      */
1074     function safeTransferFrom(
1075         address from,
1076         address to,
1077         uint256 tokenId,
1078         bytes memory _data
1079     ) public virtual override {
1080         _transfer(from, to, tokenId);
1081         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1082             revert TransferToNonERC721ReceiverImplementer();
1083         }
1084     }
1085 
1086     /**
1087      * @dev Returns whether `tokenId` exists.
1088      *
1089      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1090      *
1091      * Tokens start existing when they are minted (`_mint`),
1092      */
1093     function _exists(uint256 tokenId) internal view returns (bool) {
1094         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1095     }
1096 
1097     /**
1098      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1099      */
1100     function _safeMint(address to, uint256 quantity) internal {
1101         _safeMint(to, quantity, '');
1102     }
1103 
1104     /**
1105      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1106      *
1107      * Requirements:
1108      *
1109      * - If `to` refers to a smart contract, it must implement 
1110      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1111      * - `quantity` must be greater than 0.
1112      *
1113      * Emits a {Transfer} event.
1114      */
1115     function _safeMint(
1116         address to,
1117         uint256 quantity,
1118         bytes memory _data
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
1139             if (to.isContract()) {
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
1159      * @dev Mints `quantity` tokens and transfers them to `to`.
1160      *
1161      * Requirements:
1162      *
1163      * - `to` cannot be the zero address.
1164      * - `quantity` must be greater than 0.
1165      *
1166      * Emits a {Transfer} event.
1167      */
1168     function _mint(address to, uint256 quantity) internal {
1169         uint256 startTokenId = _currentIndex;
1170         if (to == address(0)) revert MintToZeroAddress();
1171         if (quantity == 0) revert MintZeroQuantity();
1172 
1173         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1174 
1175         // Overflows are incredibly unrealistic.
1176         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1177         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1178         unchecked {
1179             _addressData[to].balance += uint64(quantity);
1180             _addressData[to].numberMinted += uint64(quantity);
1181 
1182             _ownerships[startTokenId].addr = to;
1183             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1184 
1185             uint256 updatedIndex = startTokenId;
1186             uint256 end = updatedIndex + quantity;
1187 
1188             do {
1189                 emit Transfer(address(0), to, updatedIndex++);
1190             } while (updatedIndex != end);
1191 
1192             _currentIndex = updatedIndex;
1193         }
1194         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1195     }
1196 
1197     /**
1198      * @dev Transfers `tokenId` from `from` to `to`.
1199      *
1200      * Requirements:
1201      *
1202      * - `to` cannot be the zero address.
1203      * - `tokenId` token must be owned by `from`.
1204      *
1205      * Emits a {Transfer} event.
1206      */
1207     function _transfer(
1208         address from,
1209         address to,
1210         uint256 tokenId
1211     ) private {
1212         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1213 
1214         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1215 
1216         bool isApprovedOrOwner = (_msgSender() == from ||
1217             isApprovedForAll(from, _msgSender()) ||
1218             getApproved(tokenId) == _msgSender());
1219 
1220         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1221         if (to == address(0)) revert TransferToZeroAddress();
1222 
1223         _beforeTokenTransfers(from, to, tokenId, 1);
1224 
1225         // Clear approvals from the previous owner
1226         _approve(address(0), tokenId, from);
1227 
1228         // Underflow of the sender's balance is impossible because we check for
1229         // ownership above and the recipient's balance can't realistically overflow.
1230         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1231         unchecked {
1232             _addressData[from].balance -= 1;
1233             _addressData[to].balance += 1;
1234 
1235             TokenOwnership storage currSlot = _ownerships[tokenId];
1236             currSlot.addr = to;
1237             currSlot.startTimestamp = uint64(block.timestamp);
1238 
1239             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1240             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1241             uint256 nextTokenId = tokenId + 1;
1242             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1243             if (nextSlot.addr == address(0)) {
1244                 // This will suffice for checking _exists(nextTokenId),
1245                 // as a burned slot cannot contain the zero address.
1246                 if (nextTokenId != _currentIndex) {
1247                     nextSlot.addr = from;
1248                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1249                 }
1250             }
1251         }
1252 
1253         emit Transfer(from, to, tokenId);
1254         _afterTokenTransfers(from, to, tokenId, 1);
1255     }
1256 
1257     /**
1258      * @dev Equivalent to `_burn(tokenId, false)`.
1259      */
1260     function _burn(uint256 tokenId) internal virtual {
1261         _burn(tokenId, false);
1262     }
1263 
1264     /**
1265      * @dev Destroys `tokenId`.
1266      * The approval is cleared when the token is burned.
1267      *
1268      * Requirements:
1269      *
1270      * - `tokenId` must exist.
1271      *
1272      * Emits a {Transfer} event.
1273      */
1274     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1275         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1276 
1277         address from = prevOwnership.addr;
1278 
1279         if (approvalCheck) {
1280             bool isApprovedOrOwner = (_msgSender() == from ||
1281                 isApprovedForAll(from, _msgSender()) ||
1282                 getApproved(tokenId) == _msgSender());
1283 
1284             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1285         }
1286 
1287         _beforeTokenTransfers(from, address(0), tokenId, 1);
1288 
1289         // Clear approvals from the previous owner
1290         _approve(address(0), tokenId, from);
1291 
1292         // Underflow of the sender's balance is impossible because we check for
1293         // ownership above and the recipient's balance can't realistically overflow.
1294         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1295         unchecked {
1296             AddressData storage addressData = _addressData[from];
1297             addressData.balance -= 1;
1298             addressData.numberBurned += 1;
1299 
1300             // Keep track of who burned the token, and the timestamp of burning.
1301             TokenOwnership storage currSlot = _ownerships[tokenId];
1302             currSlot.addr = from;
1303             currSlot.startTimestamp = uint64(block.timestamp);
1304             currSlot.burned = true;
1305 
1306             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1307             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1308             uint256 nextTokenId = tokenId + 1;
1309             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1310             if (nextSlot.addr == address(0)) {
1311                 // This will suffice for checking _exists(nextTokenId),
1312                 // as a burned slot cannot contain the zero address.
1313                 if (nextTokenId != _currentIndex) {
1314                     nextSlot.addr = from;
1315                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1316                 }
1317             }
1318         }
1319 
1320         emit Transfer(from, address(0), tokenId);
1321         _afterTokenTransfers(from, address(0), tokenId, 1);
1322 
1323         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1324         unchecked {
1325             _burnCounter++;
1326         }
1327     }
1328 
1329     /**
1330      * @dev Approve `to` to operate on `tokenId`
1331      *
1332      * Emits a {Approval} event.
1333      */
1334     function _approve(
1335         address to,
1336         uint256 tokenId,
1337         address owner
1338     ) private {
1339         _tokenApprovals[tokenId] = to;
1340         emit Approval(owner, to, tokenId);
1341     }
1342 
1343     /**
1344      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1345      *
1346      * @param from address representing the previous owner of the given token ID
1347      * @param to target address that will receive the tokens
1348      * @param tokenId uint256 ID of the token to be transferred
1349      * @param _data bytes optional data to send along with the call
1350      * @return bool whether the call correctly returned the expected magic value
1351      */
1352     function _checkContractOnERC721Received(
1353         address from,
1354         address to,
1355         uint256 tokenId,
1356         bytes memory _data
1357     ) private returns (bool) {
1358         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1359             return retval == IERC721Receiver(to).onERC721Received.selector;
1360         } catch (bytes memory reason) {
1361             if (reason.length == 0) {
1362                 revert TransferToNonERC721ReceiverImplementer();
1363             } else {
1364                 assembly {
1365                     revert(add(32, reason), mload(reason))
1366                 }
1367             }
1368         }
1369     }
1370 
1371     /**
1372      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1373      * And also called before burning one token.
1374      *
1375      * startTokenId - the first token id to be transferred
1376      * quantity - the amount to be transferred
1377      *
1378      * Calling conditions:
1379      *
1380      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1381      * transferred to `to`.
1382      * - When `from` is zero, `tokenId` will be minted for `to`.
1383      * - When `to` is zero, `tokenId` will be burned by `from`.
1384      * - `from` and `to` are never both zero.
1385      */
1386     function _beforeTokenTransfers(
1387         address from,
1388         address to,
1389         uint256 startTokenId,
1390         uint256 quantity
1391     ) internal virtual {}
1392 
1393     /**
1394      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1395      * minting.
1396      * And also called after one token has been burned.
1397      *
1398      * startTokenId - the first token id to be transferred
1399      * quantity - the amount to be transferred
1400      *
1401      * Calling conditions:
1402      *
1403      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1404      * transferred to `to`.
1405      * - When `from` is zero, `tokenId` has been minted for `to`.
1406      * - When `to` is zero, `tokenId` has been burned by `from`.
1407      * - `from` and `to` are never both zero.
1408      */
1409     function _afterTokenTransfers(
1410         address from,
1411         address to,
1412         uint256 startTokenId,
1413         uint256 quantity
1414     ) internal virtual {}
1415 }
1416 // File: contracts/BoredApeY00tsClub.sol
1417 
1418 
1419 
1420 pragma solidity ^0.8.0;
1421 
1422 
1423 
1424 
1425 
1426 contract BoredApeY00tsClub is ERC721A, Ownable, ReentrancyGuard {
1427   using Address for address;
1428   using Strings for uint;
1429 
1430 
1431   string  public  baseTokenURI = "ipfs://bafybeiamxsbjlggdv42zosp252aar7beimdkuhgehwv74tclbnd747rmgq/";
1432   uint256  public  maxSupply = 7777;
1433   uint256 public  MAX_MINTS_PER_TX = 20;
1434   uint256 public  PUBLIC_SALE_PRICE = 0.005 ether;
1435   uint256 public  NUM_FREE_MINTS = 3333;
1436   uint256 public  MAX_FREE_PER_WALLET = 1;
1437   uint256 public freeNFTAlreadyMinted = 0;
1438   bool public isPublicSaleActive = false;
1439 
1440   constructor(
1441 
1442   ) ERC721A("Bored Ape Y00ts Club", "BAY00C") {
1443 
1444   }
1445 
1446 
1447   function mint(uint256 numberOfTokens)
1448       external
1449       payable
1450   {
1451     require(isPublicSaleActive, "Public sale is not open");
1452     require(totalSupply() + numberOfTokens < maxSupply + 1, "No more");
1453 
1454     if(freeNFTAlreadyMinted + numberOfTokens > NUM_FREE_MINTS){
1455         require(
1456             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1457             "Incorrect ETH value sent"
1458         );
1459     } else {
1460         if (balanceOf(msg.sender) + numberOfTokens > MAX_FREE_PER_WALLET) {
1461         require(
1462             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
1463             "Incorrect ETH value sent"
1464         );
1465         require(
1466             numberOfTokens <= MAX_MINTS_PER_TX,
1467             "Max mints per transaction exceeded"
1468         );
1469         } else {
1470             require(
1471                 numberOfTokens <= MAX_FREE_PER_WALLET,
1472                 "Max mints per transaction exceeded"
1473             );
1474             freeNFTAlreadyMinted += numberOfTokens;
1475         }
1476     }
1477     _safeMint(msg.sender, numberOfTokens);
1478   }
1479 
1480   function setBaseURI(string memory baseURI)
1481     public
1482     onlyOwner
1483   {
1484     baseTokenURI = baseURI;
1485   }
1486 
1487   function treasuryMint(uint quantity)
1488     public
1489     onlyOwner
1490   {
1491     require(
1492       quantity > 0,
1493       "Invalid mint amount"
1494     );
1495     require(
1496       totalSupply() + quantity <= maxSupply,
1497       "Maximum supply exceeded"
1498     );
1499     _safeMint(msg.sender, quantity);
1500   }
1501 
1502   function withdraw()
1503     public
1504     onlyOwner
1505     nonReentrant
1506   {
1507     Address.sendValue(payable(msg.sender), address(this).balance);
1508   }
1509 
1510   function tokenURI(uint _tokenId)
1511     public
1512     view
1513     virtual
1514     override
1515     returns (string memory)
1516   {
1517     require(
1518       _exists(_tokenId),
1519       "ERC721Metadata: URI query for nonexistent token"
1520     );
1521     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
1522   }
1523 
1524   function _baseURI()
1525     internal
1526     view
1527     virtual
1528     override
1529     returns (string memory)
1530   {
1531     return baseTokenURI;
1532   }
1533 
1534   function setIsPublicSaleActive(bool _isPublicSaleActive)
1535       external
1536       onlyOwner
1537   {
1538       isPublicSaleActive = _isPublicSaleActive;
1539   }
1540 
1541   function setNumFreeMints(uint256 _numfreemints)
1542       external
1543       onlyOwner
1544   {
1545       NUM_FREE_MINTS = _numfreemints;
1546   }
1547 
1548   function setSalePrice(uint256 _price)
1549       external
1550       onlyOwner
1551   {
1552       PUBLIC_SALE_PRICE = _price;
1553   }
1554 
1555   function setMaxLimitPerTransaction(uint256 _limit)
1556       external
1557       onlyOwner
1558   {
1559       MAX_MINTS_PER_TX = _limit;
1560   }
1561 
1562   function setFreeLimitPerWallet(uint256 _limit)
1563       external
1564       onlyOwner
1565   {
1566       MAX_FREE_PER_WALLET = _limit;
1567   }
1568 }