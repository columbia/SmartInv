1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 
4 // ⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛
5 //⠀⠀⠀⠀⠀⠀⣀⣀⡂⠀⠀⣀⣀⠀⠀⣀⣰⠄⠀⠀⣠⣦⡤⢴⣀⣀⣀⣀⡀⠀⡀⠀⠀⠀⢀⣀⡀⠀⠀⠀⠀⣀⣒⠤⢀⣀⣀⠀⠀⠀⣄⣀⡀⠀⣀⣀⣀⣀⣀⣀⡀⠀⠀⠀⠀
6 //⠀⠀⠀⠀⠀⠀⣿⣿⡇⠀⠀⣿⣿⠀⠀⣿⣿⠀⠀⣼⣿⡟⠀⢸⣿⣿⠿⢿⣿⣷⡔⠄⠀⠀⣸⣿⣧⠀⠀⠀⠀⣿⣿⠀⢸⣿⣿⡆⠀⠀⣿⣿⠀⠀⣿⣿⠿⠿⢿⠿⠇⠀⠀⠀⠀
7 //⠀⠀⠀⠀⠀⠀⣿⣿⡇⠀⠀⣿⣿⠀⠀⣿⣿⠀⣰⣿⡏⠀⠀⢸⣿⡇⠀⠀⢹⣿⡇⠀⠀⢠⣿⣿⣿⡄⠀⠀⠀⣿⣿⠀⢸⣿⣿⣿⡀⠀⣿⣿⠀⠀⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀
8 //⠀⠀⠀⠀⠀⠀⣿⣿⡇⠀⠀⣿⣿⠀⠀⣿⣿⣰⣿⡟⠀⠀⠀⢸⣿⡇⠀⠀⣸⣿⡇⠀⠀⣸⣿⠿⣿⣷⡄⠀⠀⣿⣿⠀⢸⣿⣿⣿⣷⠀⣿⣿⠀⠀⣿⣿⡀⢀⠀⣀⠀⠀⠀⠀⠀
9 //⠀⠀⠀⠀⠀⠀⣿⣿⡇⠀⠀⣿⣿⠀⠀⣿⣿⣿⣿⣷⡀⠀⠀⢸⣿⣿⣶⣿⣿⠟⠁⠀⢀⣿⣿⠀⢿⣿⡀⠀⠀⣿⣿⠀⢸⣿⣧⢹⣿⡆⣿⣿⠀⠀⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀
10 //⠀⠀⠀⠀⠀⠀⣿⣿⡇⠀⠀⣿⣿⠀⠀⣿⣿⡟⢹⣿⣧⠀⠀⢸⣿⡇⠀⣿⣿⡆⠀⠀⣰⣿⣯⣀⣸⣿⡇⠀⠀⣿⣿⠀⢸⣿⣿⠀⢿⣿⣿⣿⡄⠀⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀
11 //⠀⠀⠀⠀⠀⠀⣿⣿⡇⢀⣠⣿⣿⠀⠀⣿⣿⠀⠀⢿⣿⣇⠀⢸⣿⡇⠀⠈⣿⣿⠀⠀⣿⣿⠟⠻⠿⣿⣿⠀⢰⣿⣿⠀⢘⣿⣿⠀⠘⣿⣿⣿⡇⠀⣿⣿⠀⣄⣀⣀⠀⠀⠀⠀⠀
12 //⠀⠀⠀⠀⠀⠀⠹⣿⣿⣶⣿⣿⠏⠀⠀⣿⣿⠀⠀⠈⣿⣿⡄⢸⣿⡇⠀⠀⢹⣿⣇⢰⣿⡿⠀⠀⠀⣿⣿⡇⠸⣿⣿⠀⠸⣿⣿⠀⠀⢸⣿⣿⠀⠀⣿⣿⣷⣶⣶⣶⡇⠀⠀⠀⠀
13 //⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠋⠁⠀⠀⠀⠉⠛⠀⠀⠀⠈⠉⠉⠈⠉⠁⠀⠀⠈⠉⠉⠉⠉⠁⠀⠀⠀⠈⠉⠉⠀⠉⠉⠀⠀⠉⠉⠀⠀⠀⠉⠙⠀⠀⠉⠉⠉⠉⠉⠉⠁⠀⠀⠀⠀
14 // ⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛
15 
16 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
17 
18 pragma solidity ^0.8.0;
19 
20 /**
21  * @dev Contract module that helps prevent reentrant calls to a function.
22  *
23  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
24  * available, which can be applied to functions to make sure there are no nested
25  * (reentrant) calls to them.
26  *
27  * Note that because there is a single `nonReentrant` guard, functions marked as
28  * `nonReentrant` may not call one another. This can be worked around by making
29  * those functions `private`, and then adding `external` `nonReentrant` entry
30  * points to them.
31  *
32  * TIP: If you would like to learn more about reentrancy and alternative ways
33  * to protect against it, check out our blog post
34  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
35  */
36 abstract contract ReentrancyGuard {
37     // Booleans are more expensive than uint256 or any type that takes up a full
38     // word because each write operation emits an extra SLOAD to first read the
39     // slot's contents, replace the bits taken up by the boolean, and then write
40     // back. This is the compiler's defense against contract upgrades and
41     // pointer aliasing, and it cannot be disabled.
42 
43     // The values being non-zero value makes deployment a bit more expensive,
44     // but in exchange the refund on every call to nonReentrant will be lower in
45     // amount. Since refunds are capped to a percentage of the total
46     // transaction's gas, it is best to keep them low in cases like this one, to
47     // increase the likelihood of the full refund coming into effect.
48     uint256 private constant _NOT_ENTERED = 1;
49     uint256 private constant _ENTERED = 2;
50 
51     uint256 private _status;
52 
53     constructor() {
54         _status = _NOT_ENTERED;
55     }
56 
57     /**
58      * @dev Prevents a contract from calling itself, directly or indirectly.
59      * Calling a `nonReentrant` function from another `nonReentrant`
60      * function is not supported. It is possible to prevent this from happening
61      * by making the `nonReentrant` function external, and making it call a
62      * `private` function that does the actual work.
63      */
64     modifier nonReentrant() {
65         // On the first call to nonReentrant, _notEntered will be true
66         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
67 
68         // Any calls to nonReentrant after this point will fail
69         _status = _ENTERED;
70 
71         _;
72 
73         // By storing the original value once again, a refund is triggered (see
74         // https://eips.ethereum.org/EIPS/eip-2200)
75         _status = _NOT_ENTERED;
76     }
77 }
78 
79 // File: @openzeppelin/contracts/utils/Strings.sol
80 
81 
82 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
83 
84 pragma solidity ^0.8.0;
85 
86 /**
87  * @dev String operations.
88  */
89 library Strings {
90     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
91 
92     /**
93      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
94      */
95     function toString(uint256 value) internal pure returns (string memory) {
96         // Inspired by OraclizeAPI's implementation - MIT licence
97         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
98 
99         if (value == 0) {
100             return "0";
101         }
102         uint256 temp = value;
103         uint256 digits;
104         while (temp != 0) {
105             digits++;
106             temp /= 10;
107         }
108         bytes memory buffer = new bytes(digits);
109         while (value != 0) {
110             digits -= 1;
111             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
112             value /= 10;
113         }
114         return string(buffer);
115     }
116 
117     /**
118      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
119      */
120     function toHexString(uint256 value) internal pure returns (string memory) {
121         if (value == 0) {
122             return "0x00";
123         }
124         uint256 temp = value;
125         uint256 length = 0;
126         while (temp != 0) {
127             length++;
128             temp >>= 8;
129         }
130         return toHexString(value, length);
131     }
132 
133     /**
134      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
135      */
136     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
137         bytes memory buffer = new bytes(2 * length + 2);
138         buffer[0] = "0";
139         buffer[1] = "x";
140         for (uint256 i = 2 * length + 1; i > 1; --i) {
141             buffer[i] = _HEX_SYMBOLS[value & 0xf];
142             value >>= 4;
143         }
144         require(value == 0, "Strings: hex length insufficient");
145         return string(buffer);
146     }
147 }
148 
149 // File: @openzeppelin/contracts/utils/Context.sol
150 
151 
152 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
153 
154 pragma solidity ^0.8.0;
155 
156 /**
157  * @dev Provides information about the current execution context, including the
158  * sender of the transaction and its data. While these are generally available
159  * via msg.sender and msg.data, they should not be accessed in such a direct
160  * manner, since when dealing with meta-transactions the account sending and
161  * paying for execution may not be the actual sender (as far as an application
162  * is concerned).
163  *
164  * This contract is only required for intermediate, library-like contracts.
165  */
166 abstract contract Context {
167     function _msgSender() internal view virtual returns (address) {
168         return msg.sender;
169     }
170 
171     function _msgData() internal view virtual returns (bytes calldata) {
172         return msg.data;
173     }
174 }
175 
176 // File: @openzeppelin/contracts/access/Ownable.sol
177 
178 
179 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
180 
181 pragma solidity ^0.8.0;
182 
183 
184 /**
185  * @dev Contract module which provides a basic access control mechanism, where
186  * there is an account (an owner) that can be granted exclusive access to
187  * specific functions.
188  *
189  * By default, the owner account will be the one that deploys the contract. This
190  * can later be changed with {transferOwnership}.
191  *
192  * This module is used through inheritance. It will make available the modifier
193  * `onlyOwner`, which can be applied to your functions to restrict their use to
194  * the owner.
195  */
196 abstract contract Ownable is Context {
197     address private _owner;
198 
199     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
200 
201     /**
202      * @dev Initializes the contract setting the deployer as the initial owner.
203      */
204     constructor() {
205         _transferOwnership(_msgSender());
206     }
207 
208     /**
209      * @dev Returns the address of the current owner.
210      */
211     function owner() public view virtual returns (address) {
212         return _owner;
213     }
214 
215     /**
216      * @dev Throws if called by any account other than the owner.
217      */
218     modifier onlyOwner() {
219         require(owner() == _msgSender(), "Ownable: caller is not the owner");
220         _;
221     }
222 
223     /**
224      * @dev Leaves the contract without owner. It will not be possible to call
225      * `onlyOwner` functions anymore. Can only be called by the current owner.
226      *
227      * NOTE: Renouncing ownership will leave the contract without an owner,
228      * thereby removing any functionality that is only available to the owner.
229      */
230     function renounceOwnership() public virtual onlyOwner {
231         _transferOwnership(address(0));
232     }
233 
234     /**
235      * @dev Transfers ownership of the contract to a new account (`newOwner`).
236      * Can only be called by the current owner.
237      */
238     function transferOwnership(address newOwner) public virtual onlyOwner {
239         require(newOwner != address(0), "Ownable: new owner is the zero address");
240         _transferOwnership(newOwner);
241     }
242 
243     /**
244      * @dev Transfers ownership of the contract to a new account (`newOwner`).
245      * Internal function without access restriction.
246      */
247     function _transferOwnership(address newOwner) internal virtual {
248         address oldOwner = _owner;
249         _owner = newOwner;
250         emit OwnershipTransferred(oldOwner, newOwner);
251     }
252 }
253 
254 // File: @openzeppelin/contracts/utils/Address.sol
255 
256 
257 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
258 
259 pragma solidity ^0.8.1;
260 
261 /**
262  * @dev Collection of functions related to the address type
263  */
264 library Address {
265     /**
266      * @dev Returns true if `account` is a contract.
267      *
268      * [IMPORTANT]
269      * ====
270      * It is unsafe to assume that an address for which this function returns
271      * false is an externally-owned account (EOA) and not a contract.
272      *
273      * Among others, `isContract` will return false for the following
274      * types of addresses:
275      *
276      *  - an externally-owned account
277      *  - a contract in construction
278      *  - an address where a contract will be created
279      *  - an address where a contract lived, but was destroyed
280      * ====
281      *
282      * [IMPORTANT]
283      * ====
284      * You shouldn't rely on `isContract` to protect against flash loan attacks!
285      *
286      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
287      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
288      * constructor.
289      * ====
290      */
291     function isContract(address account) internal view returns (bool) {
292         // This method relies on extcodesize/address.code.length, which returns 0
293         // for contracts in construction, since the code is only stored at the end
294         // of the constructor execution.
295 
296         return account.code.length > 0;
297     }
298 
299     /**
300      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
301      * `recipient`, forwarding all available gas and reverting on errors.
302      *
303      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
304      * of certain opcodes, possibly making contracts go over the 2300 gas limit
305      * imposed by `transfer`, making them unable to receive funds via
306      * `transfer`. {sendValue} removes this limitation.
307      *
308      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
309      *
310      * IMPORTANT: because control is transferred to `recipient`, care must be
311      * taken to not create reentrancy vulnerabilities. Consider using
312      * {ReentrancyGuard} or the
313      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
314      */
315     function sendValue(address payable recipient, uint256 amount) internal {
316         require(address(this).balance >= amount, "Address: insufficient balance");
317 
318         (bool success, ) = recipient.call{value: amount}("");
319         require(success, "Address: unable to send value, recipient may have reverted");
320     }
321 
322     /**
323      * @dev Performs a Solidity function call using a low level `call`. A
324      * plain `call` is an unsafe replacement for a function call: use this
325      * function instead.
326      *
327      * If `target` reverts with a revert reason, it is bubbled up by this
328      * function (like regular Solidity function calls).
329      *
330      * Returns the raw returned data. To convert to the expected return value,
331      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
332      *
333      * Requirements:
334      *
335      * - `target` must be a contract.
336      * - calling `target` with `data` must not revert.
337      *
338      * _Available since v3.1._
339      */
340     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
341         return functionCall(target, data, "Address: low-level call failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
346      * `errorMessage` as a fallback revert reason when `target` reverts.
347      *
348      * _Available since v3.1._
349      */
350     function functionCall(
351         address target,
352         bytes memory data,
353         string memory errorMessage
354     ) internal returns (bytes memory) {
355         return functionCallWithValue(target, data, 0, errorMessage);
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
360      * but also transferring `value` wei to `target`.
361      *
362      * Requirements:
363      *
364      * - the calling contract must have an ETH balance of at least `value`.
365      * - the called Solidity function must be `payable`.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(
370         address target,
371         bytes memory data,
372         uint256 value
373     ) internal returns (bytes memory) {
374         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
379      * with `errorMessage` as a fallback revert reason when `target` reverts.
380      *
381      * _Available since v3.1._
382      */
383     function functionCallWithValue(
384         address target,
385         bytes memory data,
386         uint256 value,
387         string memory errorMessage
388     ) internal returns (bytes memory) {
389         require(address(this).balance >= value, "Address: insufficient balance for call");
390         require(isContract(target), "Address: call to non-contract");
391 
392         (bool success, bytes memory returndata) = target.call{value: value}(data);
393         return verifyCallResult(success, returndata, errorMessage);
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
398      * but performing a static call.
399      *
400      * _Available since v3.3._
401      */
402     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
403         return functionStaticCall(target, data, "Address: low-level static call failed");
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
408      * but performing a static call.
409      *
410      * _Available since v3.3._
411      */
412     function functionStaticCall(
413         address target,
414         bytes memory data,
415         string memory errorMessage
416     ) internal view returns (bytes memory) {
417         require(isContract(target), "Address: static call to non-contract");
418 
419         (bool success, bytes memory returndata) = target.staticcall(data);
420         return verifyCallResult(success, returndata, errorMessage);
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
425      * but performing a delegate call.
426      *
427      * _Available since v3.4._
428      */
429     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
430         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
435      * but performing a delegate call.
436      *
437      * _Available since v3.4._
438      */
439     function functionDelegateCall(
440         address target,
441         bytes memory data,
442         string memory errorMessage
443     ) internal returns (bytes memory) {
444         require(isContract(target), "Address: delegate call to non-contract");
445 
446         (bool success, bytes memory returndata) = target.delegatecall(data);
447         return verifyCallResult(success, returndata, errorMessage);
448     }
449 
450     /**
451      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
452      * revert reason using the provided one.
453      *
454      * _Available since v4.3._
455      */
456     function verifyCallResult(
457         bool success,
458         bytes memory returndata,
459         string memory errorMessage
460     ) internal pure returns (bytes memory) {
461         if (success) {
462             return returndata;
463         } else {
464             // Look for revert reason and bubble it up if present
465             if (returndata.length > 0) {
466                 // The easiest way to bubble the revert reason is using memory via assembly
467 
468                 assembly {
469                     let returndata_size := mload(returndata)
470                     revert(add(32, returndata), returndata_size)
471                 }
472             } else {
473                 revert(errorMessage);
474             }
475         }
476     }
477 }
478 
479 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
480 
481 
482 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
483 
484 pragma solidity ^0.8.0;
485 
486 /**
487  * @title ERC721 token receiver interface
488  * @dev Interface for any contract that wants to support safeTransfers
489  * from ERC721 asset contracts.
490  */
491 interface IERC721Receiver {
492     /**
493      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
494      * by `operator` from `from`, this function is called.
495      *
496      * It must return its Solidity selector to confirm the token transfer.
497      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
498      *
499      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
500      */
501     function onERC721Received(
502         address operator,
503         address from,
504         uint256 tokenId,
505         bytes calldata data
506     ) external returns (bytes4);
507 }
508 
509 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
510 
511 
512 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
513 
514 pragma solidity ^0.8.0;
515 
516 /**
517  * @dev Interface of the ERC165 standard, as defined in the
518  * https://eips.ethereum.org/EIPS/eip-165[EIP].
519  *
520  * Implementers can declare support of contract interfaces, which can then be
521  * queried by others ({ERC165Checker}).
522  *
523  * For an implementation, see {ERC165}.
524  */
525 interface IERC165 {
526     /**
527      * @dev Returns true if this contract implements the interface defined by
528      * `interfaceId`. See the corresponding
529      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
530      * to learn more about how these ids are created.
531      *
532      * This function call must use less than 30 000 gas.
533      */
534     function supportsInterface(bytes4 interfaceId) external view returns (bool);
535 }
536 
537 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
538 
539 
540 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
541 
542 pragma solidity ^0.8.0;
543 
544 
545 /**
546  * @dev Implementation of the {IERC165} interface.
547  *
548  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
549  * for the additional interface id that will be supported. For example:
550  *
551  * ```solidity
552  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
553  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
554  * }
555  * ```
556  *
557  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
558  */
559 abstract contract ERC165 is IERC165 {
560     /**
561      * @dev See {IERC165-supportsInterface}.
562      */
563     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
564         return interfaceId == type(IERC165).interfaceId;
565     }
566 }
567 
568 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
569 
570 
571 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
572 
573 pragma solidity ^0.8.0;
574 
575 
576 /**
577  * @dev Required interface of an ERC721 compliant contract.
578  */
579 interface IERC721 is IERC165 {
580     /**
581      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
582      */
583     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
584 
585     /**
586      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
587      */
588     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
589 
590     /**
591      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
592      */
593     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
594 
595     /**
596      * @dev Returns the number of tokens in ``owner``'s account.
597      */
598     function balanceOf(address owner) external view returns (uint256 balance);
599 
600     /**
601      * @dev Returns the owner of the `tokenId` token.
602      *
603      * Requirements:
604      *
605      * - `tokenId` must exist.
606      */
607     function ownerOf(uint256 tokenId) external view returns (address owner);
608 
609     /**
610      * @dev Safely transfers `tokenId` token from `from` to `to`.
611      *
612      * Requirements:
613      *
614      * - `from` cannot be the zero address.
615      * - `to` cannot be the zero address.
616      * - `tokenId` token must exist and be owned by `from`.
617      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
618      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
619      *
620      * Emits a {Transfer} event.
621      */
622     function safeTransferFrom(
623         address from,
624         address to,
625         uint256 tokenId,
626         bytes calldata data
627     ) external;
628 
629     /**
630      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
631      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
632      *
633      * Requirements:
634      *
635      * - `from` cannot be the zero address.
636      * - `to` cannot be the zero address.
637      * - `tokenId` token must exist and be owned by `from`.
638      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
639      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
640      *
641      * Emits a {Transfer} event.
642      */
643     function safeTransferFrom(
644         address from,
645         address to,
646         uint256 tokenId
647     ) external;
648 
649     /**
650      * @dev Transfers `tokenId` token from `from` to `to`.
651      *
652      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
653      *
654      * Requirements:
655      *
656      * - `from` cannot be the zero address.
657      * - `to` cannot be the zero address.
658      * - `tokenId` token must be owned by `from`.
659      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
660      *
661      * Emits a {Transfer} event.
662      */
663     function transferFrom(
664         address from,
665         address to,
666         uint256 tokenId
667     ) external;
668 
669     /**
670      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
671      * The approval is cleared when the token is transferred.
672      *
673      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
674      *
675      * Requirements:
676      *
677      * - The caller must own the token or be an approved operator.
678      * - `tokenId` must exist.
679      *
680      * Emits an {Approval} event.
681      */
682     function approve(address to, uint256 tokenId) external;
683 
684     /**
685      * @dev Approve or remove `operator` as an operator for the caller.
686      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
687      *
688      * Requirements:
689      *
690      * - The `operator` cannot be the caller.
691      *
692      * Emits an {ApprovalForAll} event.
693      */
694     function setApprovalForAll(address operator, bool _approved) external;
695 
696     /**
697      * @dev Returns the account approved for `tokenId` token.
698      *
699      * Requirements:
700      *
701      * - `tokenId` must exist.
702      */
703     function getApproved(uint256 tokenId) external view returns (address operator);
704 
705     /**
706      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
707      *
708      * See {setApprovalForAll}
709      */
710     function isApprovedForAll(address owner, address operator) external view returns (bool);
711 }
712 
713 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
714 
715 
716 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
717 
718 pragma solidity ^0.8.0;
719 
720 
721 /**
722  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
723  * @dev See https://eips.ethereum.org/EIPS/eip-721
724  */
725 interface IERC721Metadata is IERC721 {
726     /**
727      * @dev Returns the token collection name.
728      */
729     function name() external view returns (string memory);
730 
731     /**
732      * @dev Returns the token collection symbol.
733      */
734     function symbol() external view returns (string memory);
735 
736     /**
737      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
738      */
739     function tokenURI(uint256 tokenId) external view returns (string memory);
740 }
741 
742 // File: erc721a/contracts/IERC721A.sol
743 
744 
745 // ERC721A Contracts v3.3.0
746 // Creator: Chiru Labs
747 
748 pragma solidity ^0.8.4;
749 
750 
751 
752 /**
753  * @dev Interface of an ERC721A compliant contract.
754  */
755 interface IERC721A is IERC721, IERC721Metadata {
756     /**
757      * The caller must own the token or be an approved operator.
758      */
759     error ApprovalCallerNotOwnerNorApproved();
760 
761     /**
762      * The token does not exist.
763      */
764     error ApprovalQueryForNonexistentToken();
765 
766     /**
767      * The caller cannot approve to their own address.
768      */
769     error ApproveToCaller();
770 
771     /**
772      * The caller cannot approve to the current owner.
773      */
774     error ApprovalToCurrentOwner();
775 
776     /**
777      * Cannot query the balance for the zero address.
778      */
779     error BalanceQueryForZeroAddress();
780 
781     /**
782      * Cannot mint to the zero address.
783      */
784     error MintToZeroAddress();
785 
786     /**
787      * The quantity of tokens minted must be more than zero.
788      */
789     error MintZeroQuantity();
790 
791     /**
792      * The token does not exist.
793      */
794     error OwnerQueryForNonexistentToken();
795 
796     /**
797      * The caller must own the token or be an approved operator.
798      */
799     error TransferCallerNotOwnerNorApproved();
800 
801     /**
802      * The token must be owned by `from`.
803      */
804     error TransferFromIncorrectOwner();
805 
806     /**
807      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
808      */
809     error TransferToNonERC721ReceiverImplementer();
810 
811     /**
812      * Cannot transfer to the zero address.
813      */
814     error TransferToZeroAddress();
815 
816     /**
817      * The token does not exist.
818      */
819     error URIQueryForNonexistentToken();
820 
821     // Compiler will pack this into a single 256bit word.
822     struct TokenOwnership {
823         // The address of the owner.
824         address addr;
825         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
826         uint64 startTimestamp;
827         // Whether the token has been burned.
828         bool burned;
829     }
830 
831     // Compiler will pack this into a single 256bit word.
832     struct AddressData {
833         // Realistically, 2**64-1 is more than enough.
834         uint64 balance;
835         // Keeps track of mint count with minimal overhead for tokenomics.
836         uint64 numberMinted;
837         // Keeps track of burn count with minimal overhead for tokenomics.
838         uint64 numberBurned;
839         // For miscellaneous variable(s) pertaining to the address
840         // (e.g. number of whitelist mint slots used).
841         // If there are multiple variables, please pack them into a uint64.
842         uint64 aux;
843     }
844 
845     /**
846      * @dev Returns the total amount of tokens stored by the contract.
847      * 
848      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
849      */
850     function totalSupply() external view returns (uint256);
851 }
852 
853 // File: erc721a/contracts/ERC721A.sol
854 
855 
856 // ERC721A Contracts v3.3.0
857 // Creator: Chiru Labs
858 
859 pragma solidity ^0.8.4;
860 
861 
862 
863 
864 
865 
866 
867 /**
868  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
869  * the Metadata extension. Built to optimize for lower gas during batch mints.
870  *
871  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
872  *
873  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
874  *
875  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
876  */
877 contract ERC721A is Context, ERC165, IERC721A {
878     using Address for address;
879     using Strings for uint256;
880 
881     // The tokenId of the next token to be minted.
882     uint256 internal _currentIndex;
883 
884     // The number of tokens burned.
885     uint256 internal _burnCounter;
886 
887     // Token name
888     string private _name;
889 
890     // Token symbol
891     string private _symbol;
892 
893     // Mapping from token ID to ownership details
894     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
895     mapping(uint256 => TokenOwnership) internal _ownerships;
896 
897     // Mapping owner address to address data
898     mapping(address => AddressData) private _addressData;
899 
900     // Mapping from token ID to approved address
901     mapping(uint256 => address) private _tokenApprovals;
902 
903     // Mapping from owner to operator approvals
904     mapping(address => mapping(address => bool)) private _operatorApprovals;
905 
906     constructor(string memory name_, string memory symbol_) {
907         _name = name_;
908         _symbol = symbol_;
909         _currentIndex = _startTokenId();
910     }
911 
912     /**
913      * To change the starting tokenId, please override this function.
914      */
915     function _startTokenId() internal view virtual returns (uint256) {
916         return 0;
917     }
918 
919     /**
920      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
921      */
922     function totalSupply() public view override returns (uint256) {
923         // Counter underflow is impossible as _burnCounter cannot be incremented
924         // more than _currentIndex - _startTokenId() times
925         unchecked {
926             return _currentIndex - _burnCounter - _startTokenId();
927         }
928     }
929 
930     /**
931      * Returns the total amount of tokens minted in the contract.
932      */
933     function _totalMinted() internal view returns (uint256) {
934         // Counter underflow is impossible as _currentIndex does not decrement,
935         // and it is initialized to _startTokenId()
936         unchecked {
937             return _currentIndex - _startTokenId();
938         }
939     }
940 
941     /**
942      * @dev See {IERC165-supportsInterface}.
943      */
944     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
945         return
946             interfaceId == type(IERC721).interfaceId ||
947             interfaceId == type(IERC721Metadata).interfaceId ||
948             super.supportsInterface(interfaceId);
949     }
950 
951     /**
952      * @dev See {IERC721-balanceOf}.
953      */
954     function balanceOf(address owner) public view override returns (uint256) {
955         if (owner == address(0)) revert BalanceQueryForZeroAddress();
956         return uint256(_addressData[owner].balance);
957     }
958 
959     /**
960      * Returns the number of tokens minted by `owner`.
961      */
962     function _numberMinted(address owner) internal view returns (uint256) {
963         return uint256(_addressData[owner].numberMinted);
964     }
965 
966     /**
967      * Returns the number of tokens burned by or on behalf of `owner`.
968      */
969     function _numberBurned(address owner) internal view returns (uint256) {
970         return uint256(_addressData[owner].numberBurned);
971     }
972 
973     /**
974      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
975      */
976     function _getAux(address owner) internal view returns (uint64) {
977         return _addressData[owner].aux;
978     }
979 
980     /**
981      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
982      * If there are multiple variables, please pack them into a uint64.
983      */
984     function _setAux(address owner, uint64 aux) internal {
985         _addressData[owner].aux = aux;
986     }
987 
988     /**
989      * Gas spent here starts off proportional to the maximum mint batch size.
990      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
991      */
992     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
993         uint256 curr = tokenId;
994 
995         unchecked {
996             if (_startTokenId() <= curr) if (curr < _currentIndex) {
997                 TokenOwnership memory ownership = _ownerships[curr];
998                 if (!ownership.burned) {
999                     if (ownership.addr != address(0)) {
1000                         return ownership;
1001                     }
1002                     // Invariant:
1003                     // There will always be an ownership that has an address and is not burned
1004                     // before an ownership that does not have an address and is not burned.
1005                     // Hence, curr will not underflow.
1006                     while (true) {
1007                         curr--;
1008                         ownership = _ownerships[curr];
1009                         if (ownership.addr != address(0)) {
1010                             return ownership;
1011                         }
1012                     }
1013                 }
1014             }
1015         }
1016         revert OwnerQueryForNonexistentToken();
1017     }
1018 
1019     /**
1020      * @dev See {IERC721-ownerOf}.
1021      */
1022     function ownerOf(uint256 tokenId) public view override returns (address) {
1023         return _ownershipOf(tokenId).addr;
1024     }
1025 
1026     /**
1027      * @dev See {IERC721Metadata-name}.
1028      */
1029     function name() public view virtual override returns (string memory) {
1030         return _name;
1031     }
1032 
1033     /**
1034      * @dev See {IERC721Metadata-symbol}.
1035      */
1036     function symbol() public view virtual override returns (string memory) {
1037         return _symbol;
1038     }
1039 
1040     /**
1041      * @dev See {IERC721Metadata-tokenURI}.
1042      */
1043     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1044         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1045 
1046         string memory baseURI = _baseURI();
1047         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1048     }
1049 
1050     /**
1051      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1052      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1053      * by default, can be overriden in child contracts.
1054      */
1055     function _baseURI() internal view virtual returns (string memory) {
1056         return '';
1057     }
1058 
1059     /**
1060      * @dev See {IERC721-approve}.
1061      */
1062     function approve(address to, uint256 tokenId) public override {
1063         address owner = ERC721A.ownerOf(tokenId);
1064         if (to == owner) revert ApprovalToCurrentOwner();
1065 
1066         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
1067             revert ApprovalCallerNotOwnerNorApproved();
1068         }
1069 
1070         _approve(to, tokenId, owner);
1071     }
1072 
1073     /**
1074      * @dev See {IERC721-getApproved}.
1075      */
1076     function getApproved(uint256 tokenId) public view override returns (address) {
1077         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1078 
1079         return _tokenApprovals[tokenId];
1080     }
1081 
1082     /**
1083      * @dev See {IERC721-setApprovalForAll}.
1084      */
1085     function setApprovalForAll(address operator, bool approved) public virtual override {
1086         if (operator == _msgSender()) revert ApproveToCaller();
1087 
1088         _operatorApprovals[_msgSender()][operator] = approved;
1089         emit ApprovalForAll(_msgSender(), operator, approved);
1090     }
1091 
1092     /**
1093      * @dev See {IERC721-isApprovedForAll}.
1094      */
1095     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1096         return _operatorApprovals[owner][operator];
1097     }
1098 
1099     /**
1100      * @dev See {IERC721-transferFrom}.
1101      */
1102     function transferFrom(
1103         address from,
1104         address to,
1105         uint256 tokenId
1106     ) public virtual override {
1107         _transfer(from, to, tokenId);
1108     }
1109 
1110     /**
1111      * @dev See {IERC721-safeTransferFrom}.
1112      */
1113     function safeTransferFrom(
1114         address from,
1115         address to,
1116         uint256 tokenId
1117     ) public virtual override {
1118         safeTransferFrom(from, to, tokenId, '');
1119     }
1120 
1121     /**
1122      * @dev See {IERC721-safeTransferFrom}.
1123      */
1124     function safeTransferFrom(
1125         address from,
1126         address to,
1127         uint256 tokenId,
1128         bytes memory _data
1129     ) public virtual override {
1130         _transfer(from, to, tokenId);
1131         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1132             revert TransferToNonERC721ReceiverImplementer();
1133         }
1134     }
1135 
1136     /**
1137      * @dev Returns whether `tokenId` exists.
1138      *
1139      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1140      *
1141      * Tokens start existing when they are minted (`_mint`),
1142      */
1143     function _exists(uint256 tokenId) internal view returns (bool) {
1144         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1145     }
1146 
1147     /**
1148      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1149      */
1150     function _safeMint(address to, uint256 quantity) internal {
1151         _safeMint(to, quantity, '');
1152     }
1153 
1154     /**
1155      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1156      *
1157      * Requirements:
1158      *
1159      * - If `to` refers to a smart contract, it must implement
1160      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1161      * - `quantity` must be greater than 0.
1162      *
1163      * Emits a {Transfer} event.
1164      */
1165     function _safeMint(
1166         address to,
1167         uint256 quantity,
1168         bytes memory _data
1169     ) internal {
1170         uint256 startTokenId = _currentIndex;
1171         if (to == address(0)) revert MintToZeroAddress();
1172         if (quantity == 0) revert MintZeroQuantity();
1173 
1174         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1175 
1176         // Overflows are incredibly unrealistic.
1177         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1178         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1179         unchecked {
1180             _addressData[to].balance += uint64(quantity);
1181             _addressData[to].numberMinted += uint64(quantity);
1182 
1183             _ownerships[startTokenId].addr = to;
1184             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1185 
1186             uint256 updatedIndex = startTokenId;
1187             uint256 end = updatedIndex + quantity;
1188 
1189             if (to.isContract()) {
1190                 do {
1191                     emit Transfer(address(0), to, updatedIndex);
1192                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1193                         revert TransferToNonERC721ReceiverImplementer();
1194                     }
1195                 } while (updatedIndex < end);
1196                 // Reentrancy protection
1197                 if (_currentIndex != startTokenId) revert();
1198             } else {
1199                 do {
1200                     emit Transfer(address(0), to, updatedIndex++);
1201                 } while (updatedIndex < end);
1202             }
1203             _currentIndex = updatedIndex;
1204         }
1205         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1206     }
1207 
1208     /**
1209      * @dev Mints `quantity` tokens and transfers them to `to`.
1210      *
1211      * Requirements:
1212      *
1213      * - `to` cannot be the zero address.
1214      * - `quantity` must be greater than 0.
1215      *
1216      * Emits a {Transfer} event.
1217      */
1218     function _mint(address to, uint256 quantity) internal {
1219         uint256 startTokenId = _currentIndex;
1220         if (to == address(0)) revert MintToZeroAddress();
1221         if (quantity == 0) revert MintZeroQuantity();
1222 
1223         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1224 
1225         // Overflows are incredibly unrealistic.
1226         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1227         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1228         unchecked {
1229             _addressData[to].balance += uint64(quantity);
1230             _addressData[to].numberMinted += uint64(quantity);
1231 
1232             _ownerships[startTokenId].addr = to;
1233             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1234 
1235             uint256 updatedIndex = startTokenId;
1236             uint256 end = updatedIndex + quantity;
1237 
1238             do {
1239                 emit Transfer(address(0), to, updatedIndex++);
1240             } while (updatedIndex < end);
1241 
1242             _currentIndex = updatedIndex;
1243         }
1244         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1245     }
1246 
1247     /**
1248      * @dev Transfers `tokenId` from `from` to `to`.
1249      *
1250      * Requirements:
1251      *
1252      * - `to` cannot be the zero address.
1253      * - `tokenId` token must be owned by `from`.
1254      *
1255      * Emits a {Transfer} event.
1256      */
1257     function _transfer(
1258         address from,
1259         address to,
1260         uint256 tokenId
1261     ) private {
1262         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1263 
1264         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1265 
1266         bool isApprovedOrOwner = (_msgSender() == from ||
1267             isApprovedForAll(from, _msgSender()) ||
1268             getApproved(tokenId) == _msgSender());
1269 
1270         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1271         if (to == address(0)) revert TransferToZeroAddress();
1272 
1273         _beforeTokenTransfers(from, to, tokenId, 1);
1274 
1275         // Clear approvals from the previous owner
1276         _approve(address(0), tokenId, from);
1277 
1278         // Underflow of the sender's balance is impossible because we check for
1279         // ownership above and the recipient's balance can't realistically overflow.
1280         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1281         unchecked {
1282             _addressData[from].balance -= 1;
1283             _addressData[to].balance += 1;
1284 
1285             TokenOwnership storage currSlot = _ownerships[tokenId];
1286             currSlot.addr = to;
1287             currSlot.startTimestamp = uint64(block.timestamp);
1288 
1289             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
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
1303         emit Transfer(from, to, tokenId);
1304         _afterTokenTransfers(from, to, tokenId, 1);
1305     }
1306 
1307     /**
1308      * @dev Equivalent to `_burn(tokenId, false)`.
1309      */
1310     function _burn(uint256 tokenId) internal virtual {
1311         _burn(tokenId, false);
1312     }
1313 
1314     /**
1315      * @dev Destroys `tokenId`.
1316      * The approval is cleared when the token is burned.
1317      *
1318      * Requirements:
1319      *
1320      * - `tokenId` must exist.
1321      *
1322      * Emits a {Transfer} event.
1323      */
1324     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1325         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1326 
1327         address from = prevOwnership.addr;
1328 
1329         if (approvalCheck) {
1330             bool isApprovedOrOwner = (_msgSender() == from ||
1331                 isApprovedForAll(from, _msgSender()) ||
1332                 getApproved(tokenId) == _msgSender());
1333 
1334             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1335         }
1336 
1337         _beforeTokenTransfers(from, address(0), tokenId, 1);
1338 
1339         // Clear approvals from the previous owner
1340         _approve(address(0), tokenId, from);
1341 
1342         // Underflow of the sender's balance is impossible because we check for
1343         // ownership above and the recipient's balance can't realistically overflow.
1344         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1345         unchecked {
1346             AddressData storage addressData = _addressData[from];
1347             addressData.balance -= 1;
1348             addressData.numberBurned += 1;
1349 
1350             // Keep track of who burned the token, and the timestamp of burning.
1351             TokenOwnership storage currSlot = _ownerships[tokenId];
1352             currSlot.addr = from;
1353             currSlot.startTimestamp = uint64(block.timestamp);
1354             currSlot.burned = true;
1355 
1356             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1357             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1358             uint256 nextTokenId = tokenId + 1;
1359             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1360             if (nextSlot.addr == address(0)) {
1361                 // This will suffice for checking _exists(nextTokenId),
1362                 // as a burned slot cannot contain the zero address.
1363                 if (nextTokenId != _currentIndex) {
1364                     nextSlot.addr = from;
1365                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1366                 }
1367             }
1368         }
1369 
1370         emit Transfer(from, address(0), tokenId);
1371         _afterTokenTransfers(from, address(0), tokenId, 1);
1372 
1373         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1374         unchecked {
1375             _burnCounter++;
1376         }
1377     }
1378 
1379     /**
1380      * @dev Approve `to` to operate on `tokenId`
1381      *
1382      * Emits a {Approval} event.
1383      */
1384     function _approve(
1385         address to,
1386         uint256 tokenId,
1387         address owner
1388     ) private {
1389         _tokenApprovals[tokenId] = to;
1390         emit Approval(owner, to, tokenId);
1391     }
1392 
1393     /**
1394      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1395      *
1396      * @param from address representing the previous owner of the given token ID
1397      * @param to target address that will receive the tokens
1398      * @param tokenId uint256 ID of the token to be transferred
1399      * @param _data bytes optional data to send along with the call
1400      * @return bool whether the call correctly returned the expected magic value
1401      */
1402     function _checkContractOnERC721Received(
1403         address from,
1404         address to,
1405         uint256 tokenId,
1406         bytes memory _data
1407     ) private returns (bool) {
1408         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1409             return retval == IERC721Receiver(to).onERC721Received.selector;
1410         } catch (bytes memory reason) {
1411             if (reason.length == 0) {
1412                 revert TransferToNonERC721ReceiverImplementer();
1413             } else {
1414                 assembly {
1415                     revert(add(32, reason), mload(reason))
1416                 }
1417             }
1418         }
1419     }
1420 
1421     /**
1422      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1423      * And also called before burning one token.
1424      *
1425      * startTokenId - the first token id to be transferred
1426      * quantity - the amount to be transferred
1427      *
1428      * Calling conditions:
1429      *
1430      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1431      * transferred to `to`.
1432      * - When `from` is zero, `tokenId` will be minted for `to`.
1433      * - When `to` is zero, `tokenId` will be burned by `from`.
1434      * - `from` and `to` are never both zero.
1435      */
1436     function _beforeTokenTransfers(
1437         address from,
1438         address to,
1439         uint256 startTokenId,
1440         uint256 quantity
1441     ) internal virtual {}
1442 
1443     /**
1444      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1445      * minting.
1446      * And also called after one token has been burned.
1447      *
1448      * startTokenId - the first token id to be transferred
1449      * quantity - the amount to be transferred
1450      *
1451      * Calling conditions:
1452      *
1453      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1454      * transferred to `to`.
1455      * - When `from` is zero, `tokenId` has been minted for `to`.
1456      * - When `to` is zero, `tokenId` has been burned by `from`.
1457      * - `from` and `to` are never both zero.
1458      */
1459     function _afterTokenTransfers(
1460         address from,
1461         address to,
1462         uint256 startTokenId,
1463         uint256 quantity
1464     ) internal virtual {}
1465 }
1466 
1467 // File: contracts/4_MintingNowAPP.sol
1468 
1469 
1470 
1471 pragma solidity ^0.8.4;
1472 
1473 
1474 
1475 
1476 contract MintingNowAPP is ERC721A, Ownable, ReentrancyGuard {
1477     using Strings for uint256;
1478 
1479     uint256 public PRICE;
1480     uint256 public MAX_SUPPLY;
1481     string private BASE_URI;
1482     uint256 public FREE_MINT_LIMIT_PER_WALLET;
1483     uint256 public MAX_MINT_AMOUNT_PER_TX;
1484     bool public IS_SALE_ACTIVE;
1485     uint256 public FREE_MINT_IS_ALLOWED_UNTIL;
1486     bool public METADATA_FROZEN;
1487 
1488     mapping(address => uint256) private freeMintCountMap;
1489 
1490     constructor(
1491         uint256 price,
1492         uint256 maxSupply,
1493         string memory baseUri,
1494         uint256 freeMintAllowance,
1495         uint256 maxMintPerTx,
1496         bool isSaleActive,
1497         uint256 freeMintIsAllowedUntil
1498     ) ERC721A("MintingNowAPP", "PASS") {
1499         PRICE = price;
1500         MAX_SUPPLY = maxSupply;
1501         BASE_URI = baseUri;
1502         FREE_MINT_LIMIT_PER_WALLET = freeMintAllowance;
1503         MAX_MINT_AMOUNT_PER_TX = maxMintPerTx;
1504         IS_SALE_ACTIVE = isSaleActive;
1505         FREE_MINT_IS_ALLOWED_UNTIL = freeMintIsAllowedUntil;
1506     }
1507 
1508     /** FREE MINT **/
1509 
1510     function updateFreeMintCount(address minter, uint256 count) private {
1511         freeMintCountMap[minter] += count;
1512     }
1513 
1514     /** GETTERS **/
1515 
1516     function _baseURI() internal view virtual override returns (string memory) {
1517         return BASE_URI;
1518     }
1519 
1520     /** SETTERS **/
1521 
1522     function setPrice(uint256 customPrice) external onlyOwner {
1523         PRICE = customPrice;
1524     }
1525 
1526 
1527     function setBaseURI(string memory customBaseURI_) external onlyOwner {
1528         require(!METADATA_FROZEN, "Metadata frozen!");
1529         BASE_URI = customBaseURI_;
1530     }
1531 
1532     function setFreeMintAllowance(uint256 freeMintAllowance)
1533         external
1534         onlyOwner
1535     {
1536         FREE_MINT_LIMIT_PER_WALLET = freeMintAllowance;
1537     }
1538 
1539     function setMaxMintPerTx(uint256 maxMintPerTx) external onlyOwner {
1540         MAX_MINT_AMOUNT_PER_TX = maxMintPerTx;
1541     }
1542 
1543     function setSaleActive(bool saleIsActive) external onlyOwner {
1544         IS_SALE_ACTIVE = saleIsActive;
1545     }
1546 
1547     function setFreeMintAllowedUntil(uint256 freeMintIsAllowedUntil)
1548         external
1549         onlyOwner
1550     {
1551         FREE_MINT_IS_ALLOWED_UNTIL = freeMintIsAllowedUntil;
1552     }
1553 
1554     function freezeMetadata() external onlyOwner {
1555         METADATA_FROZEN = true;
1556     }
1557 
1558     /** MINT **/
1559 
1560     modifier mintCompliance(uint256 _mintAmount) {
1561         require(
1562             _mintAmount > 0 && _mintAmount <= MAX_MINT_AMOUNT_PER_TX,
1563             "Invalid mint amount!"
1564         );
1565         require(
1566             _currentIndex + _mintAmount <= MAX_SUPPLY,
1567             "Max supply exceeded!"
1568         );
1569         _;
1570     }
1571 
1572     function mint(uint256 _mintAmount)
1573         public
1574         payable
1575         mintCompliance(_mintAmount)
1576     {
1577         require(IS_SALE_ACTIVE, "Sale is not active!");
1578 
1579         uint256 price = PRICE * _mintAmount;
1580 
1581         if (_currentIndex < FREE_MINT_IS_ALLOWED_UNTIL) {
1582             uint256 remainingFreeMint = FREE_MINT_LIMIT_PER_WALLET -
1583                 freeMintCountMap[msg.sender];
1584             if (remainingFreeMint > 0) {
1585                 if (_mintAmount >= remainingFreeMint) {
1586                     price -= remainingFreeMint * PRICE;
1587                     updateFreeMintCount(msg.sender, remainingFreeMint);
1588                 } else {
1589                     price -= _mintAmount * PRICE;
1590                     updateFreeMintCount(msg.sender, _mintAmount);
1591                 }
1592             }
1593         }
1594 
1595         require(msg.value >= price, "Insufficient funds!");
1596 
1597         _safeMint(msg.sender, _mintAmount);
1598     }
1599 
1600     function mintOwner(address _to, uint256 _mintAmount)
1601         public
1602         mintCompliance(_mintAmount)
1603         onlyOwner
1604     {
1605         _safeMint(_to, _mintAmount);
1606     }
1607 
1608     /** PAYOUT **/
1609 
1610     function withdraw() public onlyOwner nonReentrant {
1611         uint256 balance = address(this).balance;
1612 
1613         Address.sendValue(
1614             payable(0x597C8a3551c496178135e076CC17f2f043F51EDE),
1615             balance
1616         );
1617     }
1618 }