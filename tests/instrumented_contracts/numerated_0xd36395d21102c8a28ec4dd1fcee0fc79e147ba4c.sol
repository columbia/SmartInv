1 // SPDX-License-Identifier: MIT
2 
3 /*
4 
5 ▓█████▄  ▒█████   ██▓     ▒█████   ██▀███   ▒█████    ██████  ▄▄▄                     
6 ▒██▀ ██▌▒██▒  ██▒▓██▒    ▒██▒  ██▒▓██ ▒ ██▒▒██▒  ██▒▒██    ▒ ▒████▄                   
7 ░██   █▌▒██░  ██▒▒██░    ▒██░  ██▒▓██ ░▄█ ▒▒██░  ██▒░ ▓██▄   ▒██  ▀█▄                 
8 ░▓█▄   ▌▒██   ██░▒██░    ▒██   ██░▒██▀▀█▄  ▒██   ██░  ▒   ██▒░██▄▄▄▄██                
9 ░▒████▓ ░ ████▓▒░░██████▒░ ████▓▒░░██▓ ▒██▒░ ████▓▒░▒██████▒▒ ▓█   ▓██▒               
10  ▒▒▓  ▒ ░ ▒░▒░▒░ ░ ▒░▓  ░░ ▒░▒░▒░ ░ ▒▓ ░▒▓░░ ▒░▒░▒░ ▒ ▒▓▒ ▒ ░ ▒▒   ▓▒█░               
11  ░ ▒  ▒   ░ ▒ ▒░ ░ ░ ▒  ░  ░ ▒ ▒░   ░▒ ░ ▒░  ░ ▒ ▒░ ░ ░▒  ░ ░  ▒   ▒▒ ░               
12  ░ ░  ░ ░ ░ ░ ▒    ░ ░   ░ ░ ░ ▒    ░░   ░ ░ ░ ░ ▒  ░  ░  ░    ░   ▒                  
13    ░        ░ ░      ░  ░    ░ ░     ░         ░ ░        ░        ░  ░               
14  ░                                                                                    
15                                                                                                                                                                    
16                                                                                       
17  █     █░▓█████     ▄▄▄       ██▓     ██▓        ▄▄▄▄    ██▓    ▓█████ ▓█████ ▓█████▄ 
18 ▓█░ █ ░█░▓█   ▀    ▒████▄    ▓██▒    ▓██▒       ▓█████▄ ▓██▒    ▓█   ▀ ▓█   ▀ ▒██▀ ██▌
19 ▒█░ █ ░█ ▒███      ▒██  ▀█▄  ▒██░    ▒██░       ▒██▒ ▄██▒██░    ▒███   ▒███   ░██   █▌
20 ░█░ █ ░█ ▒▓█  ▄    ░██▄▄▄▄██ ▒██░    ▒██░       ▒██░█▀  ▒██░    ▒▓█  ▄ ▒▓█  ▄ ░▓█▄   ▌
21 ░░██▒██▓ ░▒████▒    ▓█   ▓██▒░██████▒░██████▒   ░▓█  ▀█▓░██████▒░▒████▒░▒████▒░▒████▓ 
22 ░ ▓░▒ ▒  ░░ ▒░ ░    ▒▒   ▓▒█░░ ▒░▓  ░░ ▒░▓  ░   ░▒▓███▀▒░ ▒░▓  ░░░ ▒░ ░░░ ▒░ ░ ▒▒▓  ▒ 
23   ▒ ░ ░   ░ ░  ░     ▒   ▒▒ ░░ ░ ▒  ░░ ░ ▒  ░   ▒░▒   ░ ░ ░ ▒  ░ ░ ░  ░ ░ ░  ░ ░ ▒  ▒ 
24   ░   ░     ░        ░   ▒     ░ ░     ░ ░       ░    ░   ░ ░      ░      ░    ░ ░  ░ 
25     ░       ░  ░         ░  ░    ░  ░    ░  ░    ░          ░  ░   ░  ░   ░  ░   ░    
26                                                       ░                        ░  
27 
28 */
29 
30 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
31 
32 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Contract module that helps prevent reentrant calls to a function.
38  *
39  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
40  * available, which can be applied to functions to make sure there are no nested
41  * (reentrant) calls to them.
42  *
43  * Note that because there is a single `nonReentrant` guard, functions marked as
44  * `nonReentrant` may not call one another. This can be worked around by making
45  * those functions `private`, and then adding `external` `nonReentrant` entry
46  * points to them.
47  *
48  * TIP: If you would like to learn more about reentrancy and alternative ways
49  * to protect against it, check out our blog post
50  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
51  */
52 abstract contract ReentrancyGuard {
53     // Booleans are more expensive than uint256 or any type that takes up a full
54     // word because each write operation emits an extra SLOAD to first read the
55     // slot's contents, replace the bits taken up by the boolean, and then write
56     // back. This is the compiler's defense against contract upgrades and
57     // pointer aliasing, and it cannot be disabled.
58 
59     // The values being non-zero value makes deployment a bit more expensive,
60     // but in exchange the refund on every call to nonReentrant will be lower in
61     // amount. Since refunds are capped to a percentage of the total
62     // transaction's gas, it is best to keep them low in cases like this one, to
63     // increase the likelihood of the full refund coming into effect.
64     uint256 private constant _NOT_ENTERED = 1;
65     uint256 private constant _ENTERED = 2;
66 
67     uint256 private _status;
68 
69     constructor() {
70         _status = _NOT_ENTERED;
71     }
72 
73     /**
74      * @dev Prevents a contract from calling itself, directly or indirectly.
75      * Calling a `nonReentrant` function from another `nonReentrant`
76      * function is not supported. It is possible to prevent this from happening
77      * by making the `nonReentrant` function external, and making it call a
78      * `private` function that does the actual work.
79      */
80     modifier nonReentrant() {
81         // On the first call to nonReentrant, _notEntered will be true
82         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
83 
84         // Any calls to nonReentrant after this point will fail
85         _status = _ENTERED;
86 
87         _;
88 
89         // By storing the original value once again, a refund is triggered (see
90         // https://eips.ethereum.org/EIPS/eip-2200)
91         _status = _NOT_ENTERED;
92     }
93 }
94 
95 // File: @openzeppelin/contracts/utils/Strings.sol
96 
97 
98 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
99 
100 pragma solidity ^0.8.0;
101 
102 /**
103  * @dev String operations.
104  */
105 library Strings {
106     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
107 
108     /**
109      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
110      */
111     function toString(uint256 value) internal pure returns (string memory) {
112         // Inspired by OraclizeAPI's implementation - MIT licence
113         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
114 
115         if (value == 0) {
116             return "0";
117         }
118         uint256 temp = value;
119         uint256 digits;
120         while (temp != 0) {
121             digits++;
122             temp /= 10;
123         }
124         bytes memory buffer = new bytes(digits);
125         while (value != 0) {
126             digits -= 1;
127             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
128             value /= 10;
129         }
130         return string(buffer);
131     }
132 
133     /**
134      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
135      */
136     function toHexString(uint256 value) internal pure returns (string memory) {
137         if (value == 0) {
138             return "0x00";
139         }
140         uint256 temp = value;
141         uint256 length = 0;
142         while (temp != 0) {
143             length++;
144             temp >>= 8;
145         }
146         return toHexString(value, length);
147     }
148 
149     /**
150      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
151      */
152     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
153         bytes memory buffer = new bytes(2 * length + 2);
154         buffer[0] = "0";
155         buffer[1] = "x";
156         for (uint256 i = 2 * length + 1; i > 1; --i) {
157             buffer[i] = _HEX_SYMBOLS[value & 0xf];
158             value >>= 4;
159         }
160         require(value == 0, "Strings: hex length insufficient");
161         return string(buffer);
162     }
163 }
164 
165 // File: @openzeppelin/contracts/utils/Context.sol
166 
167 
168 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
169 
170 pragma solidity ^0.8.0;
171 
172 /**
173  * @dev Provides information about the current execution context, including the
174  * sender of the transaction and its data. While these are generally available
175  * via msg.sender and msg.data, they should not be accessed in such a direct
176  * manner, since when dealing with meta-transactions the account sending and
177  * paying for execution may not be the actual sender (as far as an application
178  * is concerned).
179  *
180  * This contract is only required for intermediate, library-like contracts.
181  */
182 abstract contract Context {
183     function _msgSender() internal view virtual returns (address) {
184         return msg.sender;
185     }
186 
187     function _msgData() internal view virtual returns (bytes calldata) {
188         return msg.data;
189     }
190 }
191 
192 // File: @openzeppelin/contracts/access/Ownable.sol
193 
194 
195 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
196 
197 pragma solidity ^0.8.0;
198 
199 
200 /**
201  * @dev Contract module which provides a basic access control mechanism, where
202  * there is an account (an owner) that can be granted exclusive access to
203  * specific functions.
204  *
205  * By default, the owner account will be the one that deploys the contract. This
206  * can later be changed with {transferOwnership}.
207  *
208  * This module is used through inheritance. It will make available the modifier
209  * `onlyOwner`, which can be applied to your functions to restrict their use to
210  * the owner.
211  */
212 abstract contract Ownable is Context {
213     address private _owner;
214 
215     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
216 
217     /**
218      * @dev Initializes the contract setting the deployer as the initial owner.
219      */
220     constructor() {
221         _transferOwnership(_msgSender());
222     }
223 
224     /**
225      * @dev Returns the address of the current owner.
226      */
227     function owner() public view virtual returns (address) {
228         return _owner;
229     }
230 
231     /**
232      * @dev Throws if called by any account other than the owner.
233      */
234     modifier onlyOwner() {
235         require(owner() == _msgSender(), "Ownable: caller is not the owner");
236         _;
237     }
238 
239     /**
240      * @dev Leaves the contract without owner. It will not be possible to call
241      * `onlyOwner` functions anymore. Can only be called by the current owner.
242      *
243      * NOTE: Renouncing ownership will leave the contract without an owner,
244      * thereby removing any functionality that is only available to the owner.
245      */
246     function renounceOwnership() public virtual onlyOwner {
247         _transferOwnership(address(0));
248     }
249 
250     /**
251      * @dev Transfers ownership of the contract to a new account (`newOwner`).
252      * Can only be called by the current owner.
253      */
254     function transferOwnership(address newOwner) public virtual onlyOwner {
255         require(newOwner != address(0), "Ownable: new owner is the zero address");
256         _transferOwnership(newOwner);
257     }
258 
259     /**
260      * @dev Transfers ownership of the contract to a new account (`newOwner`).
261      * Internal function without access restriction.
262      */
263     function _transferOwnership(address newOwner) internal virtual {
264         address oldOwner = _owner;
265         _owner = newOwner;
266         emit OwnershipTransferred(oldOwner, newOwner);
267     }
268 }
269 
270 // File: @openzeppelin/contracts/utils/Address.sol
271 
272 
273 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
274 
275 pragma solidity ^0.8.1;
276 
277 /**
278  * @dev Collection of functions related to the address type
279  */
280 library Address {
281     /**
282      * @dev Returns true if `account` is a contract.
283      *
284      * [IMPORTANT]
285      * ====
286      * It is unsafe to assume that an address for which this function returns
287      * false is an externally-owned account (EOA) and not a contract.
288      *
289      * Among others, `isContract` will return false for the following
290      * types of addresses:
291      *
292      *  - an externally-owned account
293      *  - a contract in construction
294      *  - an address where a contract will be created
295      *  - an address where a contract lived, but was destroyed
296      * ====
297      *
298      * [IMPORTANT]
299      * ====
300      * You shouldn't rely on `isContract` to protect against flash loan attacks!
301      *
302      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
303      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
304      * constructor.
305      * ====
306      */
307     function isContract(address account) internal view returns (bool) {
308         // This method relies on extcodesize/address.code.length, which returns 0
309         // for contracts in construction, since the code is only stored at the end
310         // of the constructor execution.
311 
312         return account.code.length > 0;
313     }
314 
315     /**
316      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
317      * `recipient`, forwarding all available gas and reverting on errors.
318      *
319      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
320      * of certain opcodes, possibly making contracts go over the 2300 gas limit
321      * imposed by `transfer`, making them unable to receive funds via
322      * `transfer`. {sendValue} removes this limitation.
323      *
324      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
325      *
326      * IMPORTANT: because control is transferred to `recipient`, care must be
327      * taken to not create reentrancy vulnerabilities. Consider using
328      * {ReentrancyGuard} or the
329      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
330      */
331     function sendValue(address payable recipient, uint256 amount) internal {
332         require(address(this).balance >= amount, "Address: insufficient balance");
333 
334         (bool success, ) = recipient.call{value: amount}("");
335         require(success, "Address: unable to send value, recipient may have reverted");
336     }
337 
338     /**
339      * @dev Performs a Solidity function call using a low level `call`. A
340      * plain `call` is an unsafe replacement for a function call: use this
341      * function instead.
342      *
343      * If `target` reverts with a revert reason, it is bubbled up by this
344      * function (like regular Solidity function calls).
345      *
346      * Returns the raw returned data. To convert to the expected return value,
347      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
348      *
349      * Requirements:
350      *
351      * - `target` must be a contract.
352      * - calling `target` with `data` must not revert.
353      *
354      * _Available since v3.1._
355      */
356     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
357         return functionCall(target, data, "Address: low-level call failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
362      * `errorMessage` as a fallback revert reason when `target` reverts.
363      *
364      * _Available since v3.1._
365      */
366     function functionCall(
367         address target,
368         bytes memory data,
369         string memory errorMessage
370     ) internal returns (bytes memory) {
371         return functionCallWithValue(target, data, 0, errorMessage);
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
376      * but also transferring `value` wei to `target`.
377      *
378      * Requirements:
379      *
380      * - the calling contract must have an ETH balance of at least `value`.
381      * - the called Solidity function must be `payable`.
382      *
383      * _Available since v3.1._
384      */
385     function functionCallWithValue(
386         address target,
387         bytes memory data,
388         uint256 value
389     ) internal returns (bytes memory) {
390         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
395      * with `errorMessage` as a fallback revert reason when `target` reverts.
396      *
397      * _Available since v3.1._
398      */
399     function functionCallWithValue(
400         address target,
401         bytes memory data,
402         uint256 value,
403         string memory errorMessage
404     ) internal returns (bytes memory) {
405         require(address(this).balance >= value, "Address: insufficient balance for call");
406         require(isContract(target), "Address: call to non-contract");
407 
408         (bool success, bytes memory returndata) = target.call{value: value}(data);
409         return verifyCallResult(success, returndata, errorMessage);
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
414      * but performing a static call.
415      *
416      * _Available since v3.3._
417      */
418     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
419         return functionStaticCall(target, data, "Address: low-level static call failed");
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
424      * but performing a static call.
425      *
426      * _Available since v3.3._
427      */
428     function functionStaticCall(
429         address target,
430         bytes memory data,
431         string memory errorMessage
432     ) internal view returns (bytes memory) {
433         require(isContract(target), "Address: static call to non-contract");
434 
435         (bool success, bytes memory returndata) = target.staticcall(data);
436         return verifyCallResult(success, returndata, errorMessage);
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
441      * but performing a delegate call.
442      *
443      * _Available since v3.4._
444      */
445     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
446         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
451      * but performing a delegate call.
452      *
453      * _Available since v3.4._
454      */
455     function functionDelegateCall(
456         address target,
457         bytes memory data,
458         string memory errorMessage
459     ) internal returns (bytes memory) {
460         require(isContract(target), "Address: delegate call to non-contract");
461 
462         (bool success, bytes memory returndata) = target.delegatecall(data);
463         return verifyCallResult(success, returndata, errorMessage);
464     }
465 
466     /**
467      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
468      * revert reason using the provided one.
469      *
470      * _Available since v4.3._
471      */
472     function verifyCallResult(
473         bool success,
474         bytes memory returndata,
475         string memory errorMessage
476     ) internal pure returns (bytes memory) {
477         if (success) {
478             return returndata;
479         } else {
480             // Look for revert reason and bubble it up if present
481             if (returndata.length > 0) {
482                 // The easiest way to bubble the revert reason is using memory via assembly
483 
484                 assembly {
485                     let returndata_size := mload(returndata)
486                     revert(add(32, returndata), returndata_size)
487                 }
488             } else {
489                 revert(errorMessage);
490             }
491         }
492     }
493 }
494 
495 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
496 
497 
498 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
499 
500 pragma solidity ^0.8.0;
501 
502 /**
503  * @title ERC721 token receiver interface
504  * @dev Interface for any contract that wants to support safeTransfers
505  * from ERC721 asset contracts.
506  */
507 interface IERC721Receiver {
508     /**
509      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
510      * by `operator` from `from`, this function is called.
511      *
512      * It must return its Solidity selector to confirm the token transfer.
513      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
514      *
515      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
516      */
517     function onERC721Received(
518         address operator,
519         address from,
520         uint256 tokenId,
521         bytes calldata data
522     ) external returns (bytes4);
523 }
524 
525 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
526 
527 
528 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
529 
530 pragma solidity ^0.8.0;
531 
532 /**
533  * @dev Interface of the ERC165 standard, as defined in the
534  * https://eips.ethereum.org/EIPS/eip-165[EIP].
535  *
536  * Implementers can declare support of contract interfaces, which can then be
537  * queried by others ({ERC165Checker}).
538  *
539  * For an implementation, see {ERC165}.
540  */
541 interface IERC165 {
542     /**
543      * @dev Returns true if this contract implements the interface defined by
544      * `interfaceId`. See the corresponding
545      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
546      * to learn more about how these ids are created.
547      *
548      * This function call must use less than 30 000 gas.
549      */
550     function supportsInterface(bytes4 interfaceId) external view returns (bool);
551 }
552 
553 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
554 
555 
556 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
557 
558 pragma solidity ^0.8.0;
559 
560 
561 /**
562  * @dev Implementation of the {IERC165} interface.
563  *
564  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
565  * for the additional interface id that will be supported. For example:
566  *
567  * ```solidity
568  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
569  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
570  * }
571  * ```
572  *
573  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
574  */
575 abstract contract ERC165 is IERC165 {
576     /**
577      * @dev See {IERC165-supportsInterface}.
578      */
579     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
580         return interfaceId == type(IERC165).interfaceId;
581     }
582 }
583 
584 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
585 
586 
587 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
588 
589 pragma solidity ^0.8.0;
590 
591 
592 /**
593  * @dev Required interface of an ERC721 compliant contract.
594  */
595 interface IERC721 is IERC165 {
596     /**
597      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
598      */
599     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
600 
601     /**
602      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
603      */
604     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
605 
606     /**
607      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
608      */
609     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
610 
611     /**
612      * @dev Returns the number of tokens in ``owner``'s account.
613      */
614     function balanceOf(address owner) external view returns (uint256 balance);
615 
616     /**
617      * @dev Returns the owner of the `tokenId` token.
618      *
619      * Requirements:
620      *
621      * - `tokenId` must exist.
622      */
623     function ownerOf(uint256 tokenId) external view returns (address owner);
624 
625     /**
626      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
627      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
628      *
629      * Requirements:
630      *
631      * - `from` cannot be the zero address.
632      * - `to` cannot be the zero address.
633      * - `tokenId` token must exist and be owned by `from`.
634      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
635      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
636      *
637      * Emits a {Transfer} event.
638      */
639     function safeTransferFrom(
640         address from,
641         address to,
642         uint256 tokenId
643     ) external;
644 
645     /**
646      * @dev Transfers `tokenId` token from `from` to `to`.
647      *
648      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
649      *
650      * Requirements:
651      *
652      * - `from` cannot be the zero address.
653      * - `to` cannot be the zero address.
654      * - `tokenId` token must be owned by `from`.
655      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
656      *
657      * Emits a {Transfer} event.
658      */
659     function transferFrom(
660         address from,
661         address to,
662         uint256 tokenId
663     ) external;
664 
665     /**
666      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
667      * The approval is cleared when the token is transferred.
668      *
669      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
670      *
671      * Requirements:
672      *
673      * - The caller must own the token or be an approved operator.
674      * - `tokenId` must exist.
675      *
676      * Emits an {Approval} event.
677      */
678     function approve(address to, uint256 tokenId) external;
679 
680     /**
681      * @dev Returns the account approved for `tokenId` token.
682      *
683      * Requirements:
684      *
685      * - `tokenId` must exist.
686      */
687     function getApproved(uint256 tokenId) external view returns (address operator);
688 
689     /**
690      * @dev Approve or remove `operator` as an operator for the caller.
691      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
692      *
693      * Requirements:
694      *
695      * - The `operator` cannot be the caller.
696      *
697      * Emits an {ApprovalForAll} event.
698      */
699     function setApprovalForAll(address operator, bool _approved) external;
700 
701     /**
702      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
703      *
704      * See {setApprovalForAll}
705      */
706     function isApprovedForAll(address owner, address operator) external view returns (bool);
707 
708     /**
709      * @dev Safely transfers `tokenId` token from `from` to `to`.
710      *
711      * Requirements:
712      *
713      * - `from` cannot be the zero address.
714      * - `to` cannot be the zero address.
715      * - `tokenId` token must exist and be owned by `from`.
716      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
717      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
718      *
719      * Emits a {Transfer} event.
720      */
721     function safeTransferFrom(
722         address from,
723         address to,
724         uint256 tokenId,
725         bytes calldata data
726     ) external;
727 }
728 
729 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
730 
731 
732 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
733 
734 pragma solidity ^0.8.0;
735 
736 
737 /**
738  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
739  * @dev See https://eips.ethereum.org/EIPS/eip-721
740  */
741 interface IERC721Metadata is IERC721 {
742     /**
743      * @dev Returns the token collection name.
744      */
745     function name() external view returns (string memory);
746 
747     /**
748      * @dev Returns the token collection symbol.
749      */
750     function symbol() external view returns (string memory);
751 
752     /**
753      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
754      */
755     function tokenURI(uint256 tokenId) external view returns (string memory);
756 }
757 
758 // File: erc721a/contracts/ERC721A.sol
759 
760 
761 // Creator: Chiru Labs
762 
763 pragma solidity ^0.8.4;
764 
765 
766 
767 
768 
769 
770 
771 
772 error ApprovalCallerNotOwnerNorApproved();
773 error ApprovalQueryForNonexistentToken();
774 error ApproveToCaller();
775 error ApprovalToCurrentOwner();
776 error BalanceQueryForZeroAddress();
777 error MintToZeroAddress();
778 error MintZeroQuantity();
779 error OwnerQueryForNonexistentToken();
780 error TransferCallerNotOwnerNorApproved();
781 error TransferFromIncorrectOwner();
782 error TransferToNonERC721ReceiverImplementer();
783 error TransferToZeroAddress();
784 error URIQueryForNonexistentToken();
785 
786 /**
787  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
788  * the Metadata extension. Built to optimize for lower gas during batch mints.
789  *
790  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
791  *
792  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
793  *
794  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
795  */
796 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
797     using Address for address;
798     using Strings for uint256;
799 
800     // Compiler will pack this into a single 256bit word.
801     struct TokenOwnership {
802         // The address of the owner.
803         address addr;
804         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
805         uint64 startTimestamp;
806         // Whether the token has been burned.
807         bool burned;
808     }
809 
810     // Compiler will pack this into a single 256bit word.
811     struct AddressData {
812         // Realistically, 2**64-1 is more than enough.
813         uint64 balance;
814         // Keeps track of mint count with minimal overhead for tokenomics.
815         uint64 numberMinted;
816         // Keeps track of burn count with minimal overhead for tokenomics.
817         uint64 numberBurned;
818         // For miscellaneous variable(s) pertaining to the address
819         // (e.g. number of whitelist mint slots used).
820         // If there are multiple variables, please pack them into a uint64.
821         uint64 aux;
822     }
823 
824     // The tokenId of the next token to be minted.
825     uint256 internal _currentIndex;
826 
827     // The number of tokens burned.
828     uint256 internal _burnCounter;
829 
830     // Token name
831     string private _name;
832 
833     // Token symbol
834     string private _symbol;
835 
836     // Mapping from token ID to ownership details
837     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
838     mapping(uint256 => TokenOwnership) internal _ownerships;
839 
840     // Mapping owner address to address data
841     mapping(address => AddressData) private _addressData;
842 
843     // Mapping from token ID to approved address
844     mapping(uint256 => address) private _tokenApprovals;
845 
846     // Mapping from owner to operator approvals
847     mapping(address => mapping(address => bool)) private _operatorApprovals;
848 
849     constructor(string memory name_, string memory symbol_) {
850         _name = name_;
851         _symbol = symbol_;
852         _currentIndex = _startTokenId();
853     }
854 
855     /**
856      * To change the starting tokenId, please override this function.
857      */
858     function _startTokenId() internal view virtual returns (uint256) {
859         return 0;
860     }
861 
862     /**
863      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
864      */
865     function totalSupply() public view returns (uint256) {
866         // Counter underflow is impossible as _burnCounter cannot be incremented
867         // more than _currentIndex - _startTokenId() times
868         unchecked {
869             return _currentIndex - _burnCounter - _startTokenId();
870         }
871     }
872 
873     /**
874      * Returns the total amount of tokens minted in the contract.
875      */
876     function _totalMinted() internal view returns (uint256) {
877         // Counter underflow is impossible as _currentIndex does not decrement,
878         // and it is initialized to _startTokenId()
879         unchecked {
880             return _currentIndex - _startTokenId();
881         }
882     }
883 
884     /**
885      * @dev See {IERC165-supportsInterface}.
886      */
887     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
888         return
889             interfaceId == type(IERC721).interfaceId ||
890             interfaceId == type(IERC721Metadata).interfaceId ||
891             super.supportsInterface(interfaceId);
892     }
893 
894     /**
895      * @dev See {IERC721-balanceOf}.
896      */
897     function balanceOf(address owner) public view override returns (uint256) {
898         if (owner == address(0)) revert BalanceQueryForZeroAddress();
899         return uint256(_addressData[owner].balance);
900     }
901 
902     /**
903      * Returns the number of tokens minted by `owner`.
904      */
905     function _numberMinted(address owner) internal view returns (uint256) {
906         return uint256(_addressData[owner].numberMinted);
907     }
908 
909     /**
910      * Returns the number of tokens burned by or on behalf of `owner`.
911      */
912     function _numberBurned(address owner) internal view returns (uint256) {
913         return uint256(_addressData[owner].numberBurned);
914     }
915 
916     /**
917      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
918      */
919     function _getAux(address owner) internal view returns (uint64) {
920         return _addressData[owner].aux;
921     }
922 
923     /**
924      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
925      * If there are multiple variables, please pack them into a uint64.
926      */
927     function _setAux(address owner, uint64 aux) internal {
928         _addressData[owner].aux = aux;
929     }
930 
931     /**
932      * Gas spent here starts off proportional to the maximum mint batch size.
933      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
934      */
935     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
936         uint256 curr = tokenId;
937 
938         unchecked {
939             if (_startTokenId() <= curr && curr < _currentIndex) {
940                 TokenOwnership memory ownership = _ownerships[curr];
941                 if (!ownership.burned) {
942                     if (ownership.addr != address(0)) {
943                         return ownership;
944                     }
945                     // Invariant:
946                     // There will always be an ownership that has an address and is not burned
947                     // before an ownership that does not have an address and is not burned.
948                     // Hence, curr will not underflow.
949                     while (true) {
950                         curr--;
951                         ownership = _ownerships[curr];
952                         if (ownership.addr != address(0)) {
953                             return ownership;
954                         }
955                     }
956                 }
957             }
958         }
959         revert OwnerQueryForNonexistentToken();
960     }
961 
962     /**
963      * @dev See {IERC721-ownerOf}.
964      */
965     function ownerOf(uint256 tokenId) public view override returns (address) {
966         return _ownershipOf(tokenId).addr;
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
1028     function setApprovalForAll(address operator, bool approved) public virtual override {
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
1113     /**
1114      * @dev Mints `quantity` tokens and transfers them to `to`.
1115      *
1116      * Requirements:
1117      *
1118      * - `to` cannot be the zero address.
1119      * - `quantity` must be greater than 0.
1120      *
1121      * Emits a {Transfer} event.
1122      */
1123     function _mint(
1124         address to,
1125         uint256 quantity,
1126         bytes memory _data,
1127         bool safe
1128     ) internal {
1129         uint256 startTokenId = _currentIndex;
1130         if (to == address(0)) revert MintToZeroAddress();
1131         if (quantity == 0) revert MintZeroQuantity();
1132 
1133         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1134 
1135         // Overflows are incredibly unrealistic.
1136         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1137         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1138         unchecked {
1139             _addressData[to].balance += uint64(quantity);
1140             _addressData[to].numberMinted += uint64(quantity);
1141 
1142             _ownerships[startTokenId].addr = to;
1143             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1144 
1145             uint256 updatedIndex = startTokenId;
1146             uint256 end = updatedIndex + quantity;
1147 
1148             if (safe && to.isContract()) {
1149                 do {
1150                     emit Transfer(address(0), to, updatedIndex);
1151                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1152                         revert TransferToNonERC721ReceiverImplementer();
1153                     }
1154                 } while (updatedIndex != end);
1155                 // Reentrancy protection
1156                 if (_currentIndex != startTokenId) revert();
1157             } else {
1158                 do {
1159                     emit Transfer(address(0), to, updatedIndex++);
1160                 } while (updatedIndex != end);
1161             }
1162             _currentIndex = updatedIndex;
1163         }
1164         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1165     }
1166 
1167     /**
1168      * @dev Transfers `tokenId` from `from` to `to`.
1169      *
1170      * Requirements:
1171      *
1172      * - `to` cannot be the zero address.
1173      * - `tokenId` token must be owned by `from`.
1174      *
1175      * Emits a {Transfer} event.
1176      */
1177     function _transfer(
1178         address from,
1179         address to,
1180         uint256 tokenId
1181     ) private {
1182         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1183 
1184         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1185 
1186         bool isApprovedOrOwner = (_msgSender() == from ||
1187             isApprovedForAll(from, _msgSender()) ||
1188             getApproved(tokenId) == _msgSender());
1189 
1190         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1191         if (to == address(0)) revert TransferToZeroAddress();
1192 
1193         _beforeTokenTransfers(from, to, tokenId, 1);
1194 
1195         // Clear approvals from the previous owner
1196         _approve(address(0), tokenId, from);
1197 
1198         // Underflow of the sender's balance is impossible because we check for
1199         // ownership above and the recipient's balance can't realistically overflow.
1200         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1201         unchecked {
1202             _addressData[from].balance -= 1;
1203             _addressData[to].balance += 1;
1204 
1205             TokenOwnership storage currSlot = _ownerships[tokenId];
1206             currSlot.addr = to;
1207             currSlot.startTimestamp = uint64(block.timestamp);
1208 
1209             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1210             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1211             uint256 nextTokenId = tokenId + 1;
1212             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1213             if (nextSlot.addr == address(0)) {
1214                 // This will suffice for checking _exists(nextTokenId),
1215                 // as a burned slot cannot contain the zero address.
1216                 if (nextTokenId != _currentIndex) {
1217                     nextSlot.addr = from;
1218                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1219                 }
1220             }
1221         }
1222 
1223         emit Transfer(from, to, tokenId);
1224         _afterTokenTransfers(from, to, tokenId, 1);
1225     }
1226 
1227     /**
1228      * @dev This is equivalent to _burn(tokenId, false)
1229      */
1230     function _burn(uint256 tokenId) internal virtual {
1231         _burn(tokenId, false);
1232     }
1233 
1234     /**
1235      * @dev Destroys `tokenId`.
1236      * The approval is cleared when the token is burned.
1237      *
1238      * Requirements:
1239      *
1240      * - `tokenId` must exist.
1241      *
1242      * Emits a {Transfer} event.
1243      */
1244     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1245         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1246 
1247         address from = prevOwnership.addr;
1248 
1249         if (approvalCheck) {
1250             bool isApprovedOrOwner = (_msgSender() == from ||
1251                 isApprovedForAll(from, _msgSender()) ||
1252                 getApproved(tokenId) == _msgSender());
1253 
1254             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1255         }
1256 
1257         _beforeTokenTransfers(from, address(0), tokenId, 1);
1258 
1259         // Clear approvals from the previous owner
1260         _approve(address(0), tokenId, from);
1261 
1262         // Underflow of the sender's balance is impossible because we check for
1263         // ownership above and the recipient's balance can't realistically overflow.
1264         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1265         unchecked {
1266             AddressData storage addressData = _addressData[from];
1267             addressData.balance -= 1;
1268             addressData.numberBurned += 1;
1269 
1270             // Keep track of who burned the token, and the timestamp of burning.
1271             TokenOwnership storage currSlot = _ownerships[tokenId];
1272             currSlot.addr = from;
1273             currSlot.startTimestamp = uint64(block.timestamp);
1274             currSlot.burned = true;
1275 
1276             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1277             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1278             uint256 nextTokenId = tokenId + 1;
1279             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1280             if (nextSlot.addr == address(0)) {
1281                 // This will suffice for checking _exists(nextTokenId),
1282                 // as a burned slot cannot contain the zero address.
1283                 if (nextTokenId != _currentIndex) {
1284                     nextSlot.addr = from;
1285                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1286                 }
1287             }
1288         }
1289 
1290         emit Transfer(from, address(0), tokenId);
1291         _afterTokenTransfers(from, address(0), tokenId, 1);
1292 
1293         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1294         unchecked {
1295             _burnCounter++;
1296         }
1297     }
1298 
1299     /**
1300      * @dev Approve `to` to operate on `tokenId`
1301      *
1302      * Emits a {Approval} event.
1303      */
1304     function _approve(
1305         address to,
1306         uint256 tokenId,
1307         address owner
1308     ) private {
1309         _tokenApprovals[tokenId] = to;
1310         emit Approval(owner, to, tokenId);
1311     }
1312 
1313     /**
1314      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1315      *
1316      * @param from address representing the previous owner of the given token ID
1317      * @param to target address that will receive the tokens
1318      * @param tokenId uint256 ID of the token to be transferred
1319      * @param _data bytes optional data to send along with the call
1320      * @return bool whether the call correctly returned the expected magic value
1321      */
1322     function _checkContractOnERC721Received(
1323         address from,
1324         address to,
1325         uint256 tokenId,
1326         bytes memory _data
1327     ) private returns (bool) {
1328         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1329             return retval == IERC721Receiver(to).onERC721Received.selector;
1330         } catch (bytes memory reason) {
1331             if (reason.length == 0) {
1332                 revert TransferToNonERC721ReceiverImplementer();
1333             } else {
1334                 assembly {
1335                     revert(add(32, reason), mload(reason))
1336                 }
1337             }
1338         }
1339     }
1340 
1341     /**
1342      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1343      * And also called before burning one token.
1344      *
1345      * startTokenId - the first token id to be transferred
1346      * quantity - the amount to be transferred
1347      *
1348      * Calling conditions:
1349      *
1350      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1351      * transferred to `to`.
1352      * - When `from` is zero, `tokenId` will be minted for `to`.
1353      * - When `to` is zero, `tokenId` will be burned by `from`.
1354      * - `from` and `to` are never both zero.
1355      */
1356     function _beforeTokenTransfers(
1357         address from,
1358         address to,
1359         uint256 startTokenId,
1360         uint256 quantity
1361     ) internal virtual {}
1362 
1363     /**
1364      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1365      * minting.
1366      * And also called after one token has been burned.
1367      *
1368      * startTokenId - the first token id to be transferred
1369      * quantity - the amount to be transferred
1370      *
1371      * Calling conditions:
1372      *
1373      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1374      * transferred to `to`.
1375      * - When `from` is zero, `tokenId` has been minted for `to`.
1376      * - When `to` is zero, `tokenId` has been burned by `from`.
1377      * - `from` and `to` are never both zero.
1378      */
1379     function _afterTokenTransfers(
1380         address from,
1381         address to,
1382         uint256 startTokenId,
1383         uint256 quantity
1384     ) internal virtual {}
1385 }
1386 
1387 
1388 
1389 pragma solidity >=0.8.9 <0.9.0;
1390 
1391 
1392 contract Dolorosa is ERC721A, Ownable, ReentrancyGuard {
1393 
1394   using Strings for uint256;
1395 
1396   string public uriPrefix = '';
1397   string public uriSuffix = '.json';
1398   
1399   uint256 public cost;
1400   uint256 public maxSupply;
1401   uint256 public maxMintAmountPerWallet;
1402 
1403   bool public paused = true;
1404   bool public allowlistOver = false;
1405 
1406   mapping(address => uint256) private _walletMints;
1407 
1408   mapping(address => uint256) public allowlist;
1409 
1410   constructor(
1411     string memory _tokenName,
1412     string memory _tokenSymbol,
1413     uint256 _cost,
1414     uint256 _maxSupply,
1415     uint256 _maxMintAmountPerWallet,
1416     string memory _uriPrefix
1417   ) ERC721A(_tokenName, _tokenSymbol) {
1418     setCost(_cost);
1419     maxSupply = _maxSupply;
1420     setMaxMintAmountPerWallet(_maxMintAmountPerWallet);
1421     setUriPrefix(_uriPrefix);
1422     _safeMint(_msgSender(), 1);
1423   }
1424 
1425   modifier mintCompliance(uint256 _mintAmount) {
1426     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerWallet, "Invalid mint amount!");
1427     require(_walletMints[_msgSender()] + _mintAmount < maxMintAmountPerWallet + 1, "You have already minted");
1428     require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
1429     _;
1430   }
1431 
1432   modifier mintPriceCompliance(uint256 _mintAmount) {
1433     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1434     _;
1435   }
1436 
1437   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1438     require(!paused, "The contract is paused!");
1439     require(allowlistOver, "Allowlist not over yet!");
1440 
1441     _walletMints[_msgSender()] += _mintAmount;
1442     _safeMint(_msgSender(), _mintAmount);
1443   }
1444 
1445    function allowlistMint() external {
1446     require(!paused, "The contract is paused!");
1447     require(allowlist[msg.sender] > 0, "Not eligible for allowlist mint");
1448     require(totalSupply() + allowlist[msg.sender] <= maxSupply, "Max supply exceeded!");
1449     _safeMint(_msgSender(), allowlist[msg.sender]);
1450     allowlist[_msgSender()] = 0;
1451   }
1452 
1453   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1454     uint256 ownerTokenCount = balanceOf(_owner);
1455     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1456     uint256 currentTokenId = _startTokenId();
1457     uint256 ownedTokenIndex = 0;
1458     address latestOwnerAddress;
1459 
1460     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1461       TokenOwnership memory ownership = _ownerships[currentTokenId];
1462 
1463       if (!ownership.burned && ownership.addr != address(0)) {
1464         latestOwnerAddress = ownership.addr;
1465       }
1466 
1467       if (latestOwnerAddress == _owner) {
1468         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1469 
1470         ownedTokenIndex++;
1471       }
1472 
1473       currentTokenId++;
1474     }
1475 
1476     return ownedTokenIds;
1477   }
1478 
1479   function _startTokenId() internal view virtual override returns (uint256) {
1480     return 1;
1481   }
1482 
1483   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1484     require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1485 
1486     string memory currentBaseURI = _baseURI();
1487     return bytes(currentBaseURI).length > 0
1488         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1489         : '';
1490   }
1491 
1492   function setCost(uint256 _cost) public onlyOwner {
1493     cost = _cost;
1494   }
1495 
1496   function setMaxMintAmountPerWallet(uint256 _maxMintAmountPerWallet) public onlyOwner {
1497     maxMintAmountPerWallet = _maxMintAmountPerWallet;
1498   }
1499 
1500   function seedAllowlist(address[] memory addresses, uint256[] memory numSlots) public onlyOwner{
1501     require(addresses.length == numSlots.length, "addresses does not match numSlots length");
1502     for (uint256 i = 0; i < addresses.length; i++) {
1503       allowlist[addresses[i]] = numSlots[i];
1504     }
1505   }
1506 
1507   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1508     uriPrefix = _uriPrefix;
1509   }
1510 
1511   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1512     uriSuffix = _uriSuffix;
1513   }
1514 
1515   function setPaused(bool _state) public onlyOwner {
1516     paused = _state;
1517   }
1518 
1519   function setAllowlistOver(bool _state) public onlyOwner {
1520     allowlistOver = _state;
1521   }
1522 
1523 
1524   function withdraw() public onlyOwner nonReentrant {
1525 
1526     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1527     require(os);
1528   }
1529 
1530   function _baseURI() internal view virtual override returns (string memory) {
1531     return uriPrefix;
1532   }
1533 }