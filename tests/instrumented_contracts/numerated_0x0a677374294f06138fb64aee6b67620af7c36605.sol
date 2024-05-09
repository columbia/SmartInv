1 // SPDX-License-Identifier: MIT
2 
3 /*
4          ___     _,.---._                              ,----.               
5   .-._ .'=.'\  ,-.' , -  `.    _.-.     _,..---._   ,-.--` , \  _,..---._   
6  /==/ \|==|  |/==/_,  ,  - \ .-,.'|   /==/,   -  \ |==|-  _.-`/==/,   -  \  
7  |==|,|  / - |==|   .=.     |==|, |   |==|   _   _\|==|   `.-.|==|   _   _\ 
8  |==|  \/  , |==|_ : ;=:  - |==|- |   |==|  .=.   /==/_ ,    /|==|  .=.   | 
9  |==|- ,   _ |==| , '='     |==|, |   |==|,|   | -|==|    .-' |==|,|   | -| 
10  |==| _ /\   |\==\ -    ,_ /|==|- `-._|==|  '='   /==|_  ,`-._|==|  '='   / 
11  /==/  / / , / '.='. -   .' /==/ - , ,/==|-,   _`//==/ ,     /|==|-,   _`/  
12  `--`./  `--`    `--`--''   `--`-----'`-.`.____.' `--`-----`` `-.`.____.'   
13                              ,----.   ,---.             ___    ,-,--.  
14   _,..---._   .-.,.---.   ,-.--` , \.--.'  \     .-._ .'=.'\ ,-.'-  _\ 
15 /==/,   -  \ /==/  `   \ |==|-  _.-`\==\-/\ \   /==/ \|==|  /==/_ ,_.' 
16 |==|   _   _\==|-, .=., ||==|   `.-./==/-|_\ |  |==|,|  / - \==\  \    
17 |==|  .=.   |==|   '='  /==/_ ,    /\==\,   - \ |==|  \/  , |\==\ -\   
18 |==|,|   | -|==|- ,   .'|==|    .-' /==/ -   ,| |==|- ,   _ |_\==\ ,\  
19 |==|  '='   /==|_  . ,'.|==|_  ,`-./==/-  /\ - \|==| _ /\   /==/\/ _ | 
20 |==|-,   _`//==/  /\ ,  )==/ ,     |==\ _.\=\.-'/==/  / / , |==\ - , / 
21 `-.`.____.' `--`-`--`--'`--`-----`` `--`        `--`./  `--` `--`---'  
22 
23 */
24 
25 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
26 
27 
28 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @dev Contract module that helps prevent reentrant calls to a function.
34  *
35  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
36  * available, which can be applied to functions to make sure there are no nested
37  * (reentrant) calls to them.
38  *
39  * Note that because there is a single `nonReentrant` guard, functions marked as
40  * `nonReentrant` may not call one another. This can be worked around by making
41  * those functions `private`, and then adding `external` `nonReentrant` entry
42  * points to them.
43  *
44  * TIP: If you would like to learn more about reentrancy and alternative ways
45  * to protect against it, check out our blog post
46  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
47  */
48 abstract contract ReentrancyGuard {
49     // Booleans are more expensive than uint256 or any type that takes up a full
50     // word because each write operation emits an extra SLOAD to first read the
51     // slot's contents, replace the bits taken up by the boolean, and then write
52     // back. This is the compiler's defense against contract upgrades and
53     // pointer aliasing, and it cannot be disabled.
54 
55     // The values being non-zero value makes deployment a bit more expensive,
56     // but in exchange the refund on every call to nonReentrant will be lower in
57     // amount. Since refunds are capped to a percentage of the total
58     // transaction's gas, it is best to keep them low in cases like this one, to
59     // increase the likelihood of the full refund coming into effect.
60     uint256 private constant _NOT_ENTERED = 1;
61     uint256 private constant _ENTERED = 2;
62 
63     uint256 private _status;
64 
65     constructor() {
66         _status = _NOT_ENTERED;
67     }
68 
69     /**
70      * @dev Prevents a contract from calling itself, directly or indirectly.
71      * Calling a `nonReentrant` function from another `nonReentrant`
72      * function is not supported. It is possible to prevent this from happening
73      * by making the `nonReentrant` function external, and making it call a
74      * `private` function that does the actual work.
75      */
76     modifier nonReentrant() {
77         // On the first call to nonReentrant, _notEntered will be true
78         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
79 
80         // Any calls to nonReentrant after this point will fail
81         _status = _ENTERED;
82 
83         _;
84 
85         // By storing the original value once again, a refund is triggered (see
86         // https://eips.ethereum.org/EIPS/eip-2200)
87         _status = _NOT_ENTERED;
88     }
89 }
90 
91 // File: @openzeppelin/contracts/utils/Strings.sol
92 
93 
94 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
95 
96 pragma solidity ^0.8.0;
97 
98 /**
99  * @dev String operations.
100  */
101 library Strings {
102     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
103 
104     /**
105      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
106      */
107     function toString(uint256 value) internal pure returns (string memory) {
108         // Inspired by OraclizeAPI's implementation - MIT licence
109         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
110 
111         if (value == 0) {
112             return "0";
113         }
114         uint256 temp = value;
115         uint256 digits;
116         while (temp != 0) {
117             digits++;
118             temp /= 10;
119         }
120         bytes memory buffer = new bytes(digits);
121         while (value != 0) {
122             digits -= 1;
123             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
124             value /= 10;
125         }
126         return string(buffer);
127     }
128 
129     /**
130      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
131      */
132     function toHexString(uint256 value) internal pure returns (string memory) {
133         if (value == 0) {
134             return "0x00";
135         }
136         uint256 temp = value;
137         uint256 length = 0;
138         while (temp != 0) {
139             length++;
140             temp >>= 8;
141         }
142         return toHexString(value, length);
143     }
144 
145     /**
146      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
147      */
148     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
149         bytes memory buffer = new bytes(2 * length + 2);
150         buffer[0] = "0";
151         buffer[1] = "x";
152         for (uint256 i = 2 * length + 1; i > 1; --i) {
153             buffer[i] = _HEX_SYMBOLS[value & 0xf];
154             value >>= 4;
155         }
156         require(value == 0, "Strings: hex length insufficient");
157         return string(buffer);
158     }
159 }
160 
161 // File: @openzeppelin/contracts/utils/Context.sol
162 
163 
164 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
165 
166 pragma solidity ^0.8.0;
167 
168 /**
169  * @dev Provides information about the current execution context, including the
170  * sender of the transaction and its data. While these are generally available
171  * via msg.sender and msg.data, they should not be accessed in such a direct
172  * manner, since when dealing with meta-transactions the account sending and
173  * paying for execution may not be the actual sender (as far as an application
174  * is concerned).
175  *
176  * This contract is only required for intermediate, library-like contracts.
177  */
178 abstract contract Context {
179     function _msgSender() internal view virtual returns (address) {
180         return msg.sender;
181     }
182 
183     function _msgData() internal view virtual returns (bytes calldata) {
184         return msg.data;
185     }
186 }
187 
188 // File: @openzeppelin/contracts/access/Ownable.sol
189 
190 
191 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
192 
193 pragma solidity ^0.8.0;
194 
195 
196 /**
197  * @dev Contract module which provides a basic access control mechanism, where
198  * there is an account (an owner) that can be granted exclusive access to
199  * specific functions.
200  *
201  * By default, the owner account will be the one that deploys the contract. This
202  * can later be changed with {transferOwnership}.
203  *
204  * This module is used through inheritance. It will make available the modifier
205  * `onlyOwner`, which can be applied to your functions to restrict their use to
206  * the owner.
207  */
208 abstract contract Ownable is Context {
209     address private _owner;
210 
211     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
212 
213     /**
214      * @dev Initializes the contract setting the deployer as the initial owner.
215      */
216     constructor() {
217         _transferOwnership(_msgSender());
218     }
219 
220     /**
221      * @dev Returns the address of the current owner.
222      */
223     function owner() public view virtual returns (address) {
224         return _owner;
225     }
226 
227     /**
228      * @dev Throws if called by any account other than the owner.
229      */
230     modifier onlyOwner() {
231         require(owner() == _msgSender(), "Ownable: caller is not the owner");
232         _;
233     }
234 
235     /**
236      * @dev Leaves the contract without owner. It will not be possible to call
237      * `onlyOwner` functions anymore. Can only be called by the current owner.
238      *
239      * NOTE: Renouncing ownership will leave the contract without an owner,
240      * thereby removing any functionality that is only available to the owner.
241      */
242     function renounceOwnership() public virtual onlyOwner {
243         _transferOwnership(address(0));
244     }
245 
246     /**
247      * @dev Transfers ownership of the contract to a new account (`newOwner`).
248      * Can only be called by the current owner.
249      */
250     function transferOwnership(address newOwner) public virtual onlyOwner {
251         require(newOwner != address(0), "Ownable: new owner is the zero address");
252         _transferOwnership(newOwner);
253     }
254 
255     /**
256      * @dev Transfers ownership of the contract to a new account (`newOwner`).
257      * Internal function without access restriction.
258      */
259     function _transferOwnership(address newOwner) internal virtual {
260         address oldOwner = _owner;
261         _owner = newOwner;
262         emit OwnershipTransferred(oldOwner, newOwner);
263     }
264 }
265 
266 // File: @openzeppelin/contracts/utils/Address.sol
267 
268 
269 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
270 
271 pragma solidity ^0.8.1;
272 
273 /**
274  * @dev Collection of functions related to the address type
275  */
276 library Address {
277     /**
278      * @dev Returns true if `account` is a contract.
279      *
280      * [IMPORTANT]
281      * ====
282      * It is unsafe to assume that an address for which this function returns
283      * false is an externally-owned account (EOA) and not a contract.
284      *
285      * Among others, `isContract` will return false for the following
286      * types of addresses:
287      *
288      *  - an externally-owned account
289      *  - a contract in construction
290      *  - an address where a contract will be created
291      *  - an address where a contract lived, but was destroyed
292      * ====
293      *
294      * [IMPORTANT]
295      * ====
296      * You shouldn't rely on `isContract` to protect against flash loan attacks!
297      *
298      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
299      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
300      * constructor.
301      * ====
302      */
303     function isContract(address account) internal view returns (bool) {
304         // This method relies on extcodesize/address.code.length, which returns 0
305         // for contracts in construction, since the code is only stored at the end
306         // of the constructor execution.
307 
308         return account.code.length > 0;
309     }
310 
311     /**
312      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
313      * `recipient`, forwarding all available gas and reverting on errors.
314      *
315      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
316      * of certain opcodes, possibly making contracts go over the 2300 gas limit
317      * imposed by `transfer`, making them unable to receive funds via
318      * `transfer`. {sendValue} removes this limitation.
319      *
320      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
321      *
322      * IMPORTANT: because control is transferred to `recipient`, care must be
323      * taken to not create reentrancy vulnerabilities. Consider using
324      * {ReentrancyGuard} or the
325      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
326      */
327     function sendValue(address payable recipient, uint256 amount) internal {
328         require(address(this).balance >= amount, "Address: insufficient balance");
329 
330         (bool success, ) = recipient.call{value: amount}("");
331         require(success, "Address: unable to send value, recipient may have reverted");
332     }
333 
334     /**
335      * @dev Performs a Solidity function call using a low level `call`. A
336      * plain `call` is an unsafe replacement for a function call: use this
337      * function instead.
338      *
339      * If `target` reverts with a revert reason, it is bubbled up by this
340      * function (like regular Solidity function calls).
341      *
342      * Returns the raw returned data. To convert to the expected return value,
343      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
344      *
345      * Requirements:
346      *
347      * - `target` must be a contract.
348      * - calling `target` with `data` must not revert.
349      *
350      * _Available since v3.1._
351      */
352     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
353         return functionCall(target, data, "Address: low-level call failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
358      * `errorMessage` as a fallback revert reason when `target` reverts.
359      *
360      * _Available since v3.1._
361      */
362     function functionCall(
363         address target,
364         bytes memory data,
365         string memory errorMessage
366     ) internal returns (bytes memory) {
367         return functionCallWithValue(target, data, 0, errorMessage);
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
372      * but also transferring `value` wei to `target`.
373      *
374      * Requirements:
375      *
376      * - the calling contract must have an ETH balance of at least `value`.
377      * - the called Solidity function must be `payable`.
378      *
379      * _Available since v3.1._
380      */
381     function functionCallWithValue(
382         address target,
383         bytes memory data,
384         uint256 value
385     ) internal returns (bytes memory) {
386         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
391      * with `errorMessage` as a fallback revert reason when `target` reverts.
392      *
393      * _Available since v3.1._
394      */
395     function functionCallWithValue(
396         address target,
397         bytes memory data,
398         uint256 value,
399         string memory errorMessage
400     ) internal returns (bytes memory) {
401         require(address(this).balance >= value, "Address: insufficient balance for call");
402         require(isContract(target), "Address: call to non-contract");
403 
404         (bool success, bytes memory returndata) = target.call{value: value}(data);
405         return verifyCallResult(success, returndata, errorMessage);
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
410      * but performing a static call.
411      *
412      * _Available since v3.3._
413      */
414     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
415         return functionStaticCall(target, data, "Address: low-level static call failed");
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
420      * but performing a static call.
421      *
422      * _Available since v3.3._
423      */
424     function functionStaticCall(
425         address target,
426         bytes memory data,
427         string memory errorMessage
428     ) internal view returns (bytes memory) {
429         require(isContract(target), "Address: static call to non-contract");
430 
431         (bool success, bytes memory returndata) = target.staticcall(data);
432         return verifyCallResult(success, returndata, errorMessage);
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
437      * but performing a delegate call.
438      *
439      * _Available since v3.4._
440      */
441     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
442         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
447      * but performing a delegate call.
448      *
449      * _Available since v3.4._
450      */
451     function functionDelegateCall(
452         address target,
453         bytes memory data,
454         string memory errorMessage
455     ) internal returns (bytes memory) {
456         require(isContract(target), "Address: delegate call to non-contract");
457 
458         (bool success, bytes memory returndata) = target.delegatecall(data);
459         return verifyCallResult(success, returndata, errorMessage);
460     }
461 
462     /**
463      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
464      * revert reason using the provided one.
465      *
466      * _Available since v4.3._
467      */
468     function verifyCallResult(
469         bool success,
470         bytes memory returndata,
471         string memory errorMessage
472     ) internal pure returns (bytes memory) {
473         if (success) {
474             return returndata;
475         } else {
476             // Look for revert reason and bubble it up if present
477             if (returndata.length > 0) {
478                 // The easiest way to bubble the revert reason is using memory via assembly
479 
480                 assembly {
481                     let returndata_size := mload(returndata)
482                     revert(add(32, returndata), returndata_size)
483                 }
484             } else {
485                 revert(errorMessage);
486             }
487         }
488     }
489 }
490 
491 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
492 
493 
494 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
495 
496 pragma solidity ^0.8.0;
497 
498 /**
499  * @title ERC721 token receiver interface
500  * @dev Interface for any contract that wants to support safeTransfers
501  * from ERC721 asset contracts.
502  */
503 interface IERC721Receiver {
504     /**
505      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
506      * by `operator` from `from`, this function is called.
507      *
508      * It must return its Solidity selector to confirm the token transfer.
509      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
510      *
511      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
512      */
513     function onERC721Received(
514         address operator,
515         address from,
516         uint256 tokenId,
517         bytes calldata data
518     ) external returns (bytes4);
519 }
520 
521 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
522 
523 
524 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
525 
526 pragma solidity ^0.8.0;
527 
528 /**
529  * @dev Interface of the ERC165 standard, as defined in the
530  * https://eips.ethereum.org/EIPS/eip-165[EIP].
531  *
532  * Implementers can declare support of contract interfaces, which can then be
533  * queried by others ({ERC165Checker}).
534  *
535  * For an implementation, see {ERC165}.
536  */
537 interface IERC165 {
538     /**
539      * @dev Returns true if this contract implements the interface defined by
540      * `interfaceId`. See the corresponding
541      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
542      * to learn more about how these ids are created.
543      *
544      * This function call must use less than 30 000 gas.
545      */
546     function supportsInterface(bytes4 interfaceId) external view returns (bool);
547 }
548 
549 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
550 
551 
552 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
553 
554 pragma solidity ^0.8.0;
555 
556 
557 /**
558  * @dev Implementation of the {IERC165} interface.
559  *
560  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
561  * for the additional interface id that will be supported. For example:
562  *
563  * ```solidity
564  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
565  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
566  * }
567  * ```
568  *
569  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
570  */
571 abstract contract ERC165 is IERC165 {
572     /**
573      * @dev See {IERC165-supportsInterface}.
574      */
575     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
576         return interfaceId == type(IERC165).interfaceId;
577     }
578 }
579 
580 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
581 
582 
583 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
584 
585 pragma solidity ^0.8.0;
586 
587 
588 /**
589  * @dev Required interface of an ERC721 compliant contract.
590  */
591 interface IERC721 is IERC165 {
592     /**
593      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
594      */
595     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
596 
597     /**
598      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
599      */
600     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
601 
602     /**
603      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
604      */
605     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
606 
607     /**
608      * @dev Returns the number of tokens in ``owner``'s account.
609      */
610     function balanceOf(address owner) external view returns (uint256 balance);
611 
612     /**
613      * @dev Returns the owner of the `tokenId` token.
614      *
615      * Requirements:
616      *
617      * - `tokenId` must exist.
618      */
619     function ownerOf(uint256 tokenId) external view returns (address owner);
620 
621     /**
622      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
623      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
624      *
625      * Requirements:
626      *
627      * - `from` cannot be the zero address.
628      * - `to` cannot be the zero address.
629      * - `tokenId` token must exist and be owned by `from`.
630      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
631      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
632      *
633      * Emits a {Transfer} event.
634      */
635     function safeTransferFrom(
636         address from,
637         address to,
638         uint256 tokenId
639     ) external;
640 
641     /**
642      * @dev Transfers `tokenId` token from `from` to `to`.
643      *
644      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
645      *
646      * Requirements:
647      *
648      * - `from` cannot be the zero address.
649      * - `to` cannot be the zero address.
650      * - `tokenId` token must be owned by `from`.
651      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
652      *
653      * Emits a {Transfer} event.
654      */
655     function transferFrom(
656         address from,
657         address to,
658         uint256 tokenId
659     ) external;
660 
661     /**
662      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
663      * The approval is cleared when the token is transferred.
664      *
665      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
666      *
667      * Requirements:
668      *
669      * - The caller must own the token or be an approved operator.
670      * - `tokenId` must exist.
671      *
672      * Emits an {Approval} event.
673      */
674     function approve(address to, uint256 tokenId) external;
675 
676     /**
677      * @dev Returns the account approved for `tokenId` token.
678      *
679      * Requirements:
680      *
681      * - `tokenId` must exist.
682      */
683     function getApproved(uint256 tokenId) external view returns (address operator);
684 
685     /**
686      * @dev Approve or remove `operator` as an operator for the caller.
687      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
688      *
689      * Requirements:
690      *
691      * - The `operator` cannot be the caller.
692      *
693      * Emits an {ApprovalForAll} event.
694      */
695     function setApprovalForAll(address operator, bool _approved) external;
696 
697     /**
698      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
699      *
700      * See {setApprovalForAll}
701      */
702     function isApprovedForAll(address owner, address operator) external view returns (bool);
703 
704     /**
705      * @dev Safely transfers `tokenId` token from `from` to `to`.
706      *
707      * Requirements:
708      *
709      * - `from` cannot be the zero address.
710      * - `to` cannot be the zero address.
711      * - `tokenId` token must exist and be owned by `from`.
712      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
713      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
714      *
715      * Emits a {Transfer} event.
716      */
717     function safeTransferFrom(
718         address from,
719         address to,
720         uint256 tokenId,
721         bytes calldata data
722     ) external;
723 }
724 
725 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
726 
727 
728 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
729 
730 pragma solidity ^0.8.0;
731 
732 
733 /**
734  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
735  * @dev See https://eips.ethereum.org/EIPS/eip-721
736  */
737 interface IERC721Metadata is IERC721 {
738     /**
739      * @dev Returns the token collection name.
740      */
741     function name() external view returns (string memory);
742 
743     /**
744      * @dev Returns the token collection symbol.
745      */
746     function symbol() external view returns (string memory);
747 
748     /**
749      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
750      */
751     function tokenURI(uint256 tokenId) external view returns (string memory);
752 }
753 
754 // File: erc721a/contracts/ERC721A.sol
755 
756 
757 // Creator: Chiru Labs
758 
759 pragma solidity ^0.8.4;
760 
761 
762 
763 
764 
765 
766 
767 
768 error ApprovalCallerNotOwnerNorApproved();
769 error ApprovalQueryForNonexistentToken();
770 error ApproveToCaller();
771 error ApprovalToCurrentOwner();
772 error BalanceQueryForZeroAddress();
773 error MintToZeroAddress();
774 error MintZeroQuantity();
775 error OwnerQueryForNonexistentToken();
776 error TransferCallerNotOwnerNorApproved();
777 error TransferFromIncorrectOwner();
778 error TransferToNonERC721ReceiverImplementer();
779 error TransferToZeroAddress();
780 error URIQueryForNonexistentToken();
781 
782 /**
783  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
784  * the Metadata extension. Built to optimize for lower gas during batch mints.
785  *
786  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
787  *
788  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
789  *
790  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
791  */
792 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
793     using Address for address;
794     using Strings for uint256;
795 
796     // Compiler will pack this into a single 256bit word.
797     struct TokenOwnership {
798         // The address of the owner.
799         address addr;
800         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
801         uint64 startTimestamp;
802         // Whether the token has been burned.
803         bool burned;
804     }
805 
806     // Compiler will pack this into a single 256bit word.
807     struct AddressData {
808         // Realistically, 2**64-1 is more than enough.
809         uint64 balance;
810         // Keeps track of mint count with minimal overhead for tokenomics.
811         uint64 numberMinted;
812         // Keeps track of burn count with minimal overhead for tokenomics.
813         uint64 numberBurned;
814         // For miscellaneous variable(s) pertaining to the address
815         // (e.g. number of whitelist mint slots used).
816         // If there are multiple variables, please pack them into a uint64.
817         uint64 aux;
818     }
819 
820     // The tokenId of the next token to be minted.
821     uint256 internal _currentIndex;
822 
823     // The number of tokens burned.
824     uint256 internal _burnCounter;
825 
826     // Token name
827     string private _name;
828 
829     // Token symbol
830     string private _symbol;
831 
832     // Mapping from token ID to ownership details
833     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
834     mapping(uint256 => TokenOwnership) internal _ownerships;
835 
836     // Mapping owner address to address data
837     mapping(address => AddressData) private _addressData;
838 
839     // Mapping from token ID to approved address
840     mapping(uint256 => address) private _tokenApprovals;
841 
842     // Mapping from owner to operator approvals
843     mapping(address => mapping(address => bool)) private _operatorApprovals;
844 
845     constructor(string memory name_, string memory symbol_) {
846         _name = name_;
847         _symbol = symbol_;
848         _currentIndex = _startTokenId();
849     }
850 
851     /**
852      * To change the starting tokenId, please override this function.
853      */
854     function _startTokenId() internal view virtual returns (uint256) {
855         return 0;
856     }
857 
858     /**
859      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
860      */
861     function totalSupply() public view returns (uint256) {
862         // Counter underflow is impossible as _burnCounter cannot be incremented
863         // more than _currentIndex - _startTokenId() times
864         unchecked {
865             return _currentIndex - _burnCounter - _startTokenId();
866         }
867     }
868 
869     /**
870      * Returns the total amount of tokens minted in the contract.
871      */
872     function _totalMinted() internal view returns (uint256) {
873         // Counter underflow is impossible as _currentIndex does not decrement,
874         // and it is initialized to _startTokenId()
875         unchecked {
876             return _currentIndex - _startTokenId();
877         }
878     }
879 
880     /**
881      * @dev See {IERC165-supportsInterface}.
882      */
883     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
884         return
885             interfaceId == type(IERC721).interfaceId ||
886             interfaceId == type(IERC721Metadata).interfaceId ||
887             super.supportsInterface(interfaceId);
888     }
889 
890     /**
891      * @dev See {IERC721-balanceOf}.
892      */
893     function balanceOf(address owner) public view override returns (uint256) {
894         if (owner == address(0)) revert BalanceQueryForZeroAddress();
895         return uint256(_addressData[owner].balance);
896     }
897 
898     /**
899      * Returns the number of tokens minted by `owner`.
900      */
901     function _numberMinted(address owner) internal view returns (uint256) {
902         return uint256(_addressData[owner].numberMinted);
903     }
904 
905     /**
906      * Returns the number of tokens burned by or on behalf of `owner`.
907      */
908     function _numberBurned(address owner) internal view returns (uint256) {
909         return uint256(_addressData[owner].numberBurned);
910     }
911 
912     /**
913      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
914      */
915     function _getAux(address owner) internal view returns (uint64) {
916         return _addressData[owner].aux;
917     }
918 
919     /**
920      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
921      * If there are multiple variables, please pack them into a uint64.
922      */
923     function _setAux(address owner, uint64 aux) internal {
924         _addressData[owner].aux = aux;
925     }
926 
927     /**
928      * Gas spent here starts off proportional to the maximum mint batch size.
929      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
930      */
931     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
932         uint256 curr = tokenId;
933 
934         unchecked {
935             if (_startTokenId() <= curr && curr < _currentIndex) {
936                 TokenOwnership memory ownership = _ownerships[curr];
937                 if (!ownership.burned) {
938                     if (ownership.addr != address(0)) {
939                         return ownership;
940                     }
941                     // Invariant:
942                     // There will always be an ownership that has an address and is not burned
943                     // before an ownership that does not have an address and is not burned.
944                     // Hence, curr will not underflow.
945                     while (true) {
946                         curr--;
947                         ownership = _ownerships[curr];
948                         if (ownership.addr != address(0)) {
949                             return ownership;
950                         }
951                     }
952                 }
953             }
954         }
955         revert OwnerQueryForNonexistentToken();
956     }
957 
958     /**
959      * @dev See {IERC721-ownerOf}.
960      */
961     function ownerOf(uint256 tokenId) public view override returns (address) {
962         return _ownershipOf(tokenId).addr;
963     }
964 
965     /**
966      * @dev See {IERC721Metadata-name}.
967      */
968     function name() public view virtual override returns (string memory) {
969         return _name;
970     }
971 
972     /**
973      * @dev See {IERC721Metadata-symbol}.
974      */
975     function symbol() public view virtual override returns (string memory) {
976         return _symbol;
977     }
978 
979     /**
980      * @dev See {IERC721Metadata-tokenURI}.
981      */
982     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
983         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
984 
985         string memory baseURI = _baseURI();
986         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
987     }
988 
989     /**
990      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
991      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
992      * by default, can be overriden in child contracts.
993      */
994     function _baseURI() internal view virtual returns (string memory) {
995         return '';
996     }
997 
998     /**
999      * @dev See {IERC721-approve}.
1000      */
1001     function approve(address to, uint256 tokenId) public override {
1002         address owner = ERC721A.ownerOf(tokenId);
1003         if (to == owner) revert ApprovalToCurrentOwner();
1004 
1005         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1006             revert ApprovalCallerNotOwnerNorApproved();
1007         }
1008 
1009         _approve(to, tokenId, owner);
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-getApproved}.
1014      */
1015     function getApproved(uint256 tokenId) public view override returns (address) {
1016         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1017 
1018         return _tokenApprovals[tokenId];
1019     }
1020 
1021     /**
1022      * @dev See {IERC721-setApprovalForAll}.
1023      */
1024     function setApprovalForAll(address operator, bool approved) public virtual override {
1025         if (operator == _msgSender()) revert ApproveToCaller();
1026 
1027         _operatorApprovals[_msgSender()][operator] = approved;
1028         emit ApprovalForAll(_msgSender(), operator, approved);
1029     }
1030 
1031     /**
1032      * @dev See {IERC721-isApprovedForAll}.
1033      */
1034     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1035         return _operatorApprovals[owner][operator];
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-transferFrom}.
1040      */
1041     function transferFrom(
1042         address from,
1043         address to,
1044         uint256 tokenId
1045     ) public virtual override {
1046         _transfer(from, to, tokenId);
1047     }
1048 
1049     /**
1050      * @dev See {IERC721-safeTransferFrom}.
1051      */
1052     function safeTransferFrom(
1053         address from,
1054         address to,
1055         uint256 tokenId
1056     ) public virtual override {
1057         safeTransferFrom(from, to, tokenId, '');
1058     }
1059 
1060     /**
1061      * @dev See {IERC721-safeTransferFrom}.
1062      */
1063     function safeTransferFrom(
1064         address from,
1065         address to,
1066         uint256 tokenId,
1067         bytes memory _data
1068     ) public virtual override {
1069         _transfer(from, to, tokenId);
1070         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1071             revert TransferToNonERC721ReceiverImplementer();
1072         }
1073     }
1074 
1075     /**
1076      * @dev Returns whether `tokenId` exists.
1077      *
1078      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1079      *
1080      * Tokens start existing when they are minted (`_mint`),
1081      */
1082     function _exists(uint256 tokenId) internal view returns (bool) {
1083         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1084             !_ownerships[tokenId].burned;
1085     }
1086 
1087     function _safeMint(address to, uint256 quantity) internal {
1088         _safeMint(to, quantity, '');
1089     }
1090 
1091     /**
1092      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1093      *
1094      * Requirements:
1095      *
1096      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1097      * - `quantity` must be greater than 0.
1098      *
1099      * Emits a {Transfer} event.
1100      */
1101     function _safeMint(
1102         address to,
1103         uint256 quantity,
1104         bytes memory _data
1105     ) internal {
1106         _mint(to, quantity, _data, true);
1107     }
1108 
1109     /**
1110      * @dev Mints `quantity` tokens and transfers them to `to`.
1111      *
1112      * Requirements:
1113      *
1114      * - `to` cannot be the zero address.
1115      * - `quantity` must be greater than 0.
1116      *
1117      * Emits a {Transfer} event.
1118      */
1119     function _mint(
1120         address to,
1121         uint256 quantity,
1122         bytes memory _data,
1123         bool safe
1124     ) internal {
1125         uint256 startTokenId = _currentIndex;
1126         if (to == address(0)) revert MintToZeroAddress();
1127         if (quantity == 0) revert MintZeroQuantity();
1128 
1129         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1130 
1131         // Overflows are incredibly unrealistic.
1132         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1133         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1134         unchecked {
1135             _addressData[to].balance += uint64(quantity);
1136             _addressData[to].numberMinted += uint64(quantity);
1137 
1138             _ownerships[startTokenId].addr = to;
1139             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1140 
1141             uint256 updatedIndex = startTokenId;
1142             uint256 end = updatedIndex + quantity;
1143 
1144             if (safe && to.isContract()) {
1145                 do {
1146                     emit Transfer(address(0), to, updatedIndex);
1147                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1148                         revert TransferToNonERC721ReceiverImplementer();
1149                     }
1150                 } while (updatedIndex != end);
1151                 // Reentrancy protection
1152                 if (_currentIndex != startTokenId) revert();
1153             } else {
1154                 do {
1155                     emit Transfer(address(0), to, updatedIndex++);
1156                 } while (updatedIndex != end);
1157             }
1158             _currentIndex = updatedIndex;
1159         }
1160         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1161     }
1162 
1163     /**
1164      * @dev Transfers `tokenId` from `from` to `to`.
1165      *
1166      * Requirements:
1167      *
1168      * - `to` cannot be the zero address.
1169      * - `tokenId` token must be owned by `from`.
1170      *
1171      * Emits a {Transfer} event.
1172      */
1173     function _transfer(
1174         address from,
1175         address to,
1176         uint256 tokenId
1177     ) private {
1178         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1179 
1180         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1181 
1182         bool isApprovedOrOwner = (_msgSender() == from ||
1183             isApprovedForAll(from, _msgSender()) ||
1184             getApproved(tokenId) == _msgSender());
1185 
1186         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1187         if (to == address(0)) revert TransferToZeroAddress();
1188 
1189         _beforeTokenTransfers(from, to, tokenId, 1);
1190 
1191         // Clear approvals from the previous owner
1192         _approve(address(0), tokenId, from);
1193 
1194         // Underflow of the sender's balance is impossible because we check for
1195         // ownership above and the recipient's balance can't realistically overflow.
1196         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1197         unchecked {
1198             _addressData[from].balance -= 1;
1199             _addressData[to].balance += 1;
1200 
1201             TokenOwnership storage currSlot = _ownerships[tokenId];
1202             currSlot.addr = to;
1203             currSlot.startTimestamp = uint64(block.timestamp);
1204 
1205             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1206             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1207             uint256 nextTokenId = tokenId + 1;
1208             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1209             if (nextSlot.addr == address(0)) {
1210                 // This will suffice for checking _exists(nextTokenId),
1211                 // as a burned slot cannot contain the zero address.
1212                 if (nextTokenId != _currentIndex) {
1213                     nextSlot.addr = from;
1214                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1215                 }
1216             }
1217         }
1218 
1219         emit Transfer(from, to, tokenId);
1220         _afterTokenTransfers(from, to, tokenId, 1);
1221     }
1222 
1223     /**
1224      * @dev This is equivalent to _burn(tokenId, false)
1225      */
1226     function _burn(uint256 tokenId) internal virtual {
1227         _burn(tokenId, false);
1228     }
1229 
1230     /**
1231      * @dev Destroys `tokenId`.
1232      * The approval is cleared when the token is burned.
1233      *
1234      * Requirements:
1235      *
1236      * - `tokenId` must exist.
1237      *
1238      * Emits a {Transfer} event.
1239      */
1240     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1241         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1242 
1243         address from = prevOwnership.addr;
1244 
1245         if (approvalCheck) {
1246             bool isApprovedOrOwner = (_msgSender() == from ||
1247                 isApprovedForAll(from, _msgSender()) ||
1248                 getApproved(tokenId) == _msgSender());
1249 
1250             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1251         }
1252 
1253         _beforeTokenTransfers(from, address(0), tokenId, 1);
1254 
1255         // Clear approvals from the previous owner
1256         _approve(address(0), tokenId, from);
1257 
1258         // Underflow of the sender's balance is impossible because we check for
1259         // ownership above and the recipient's balance can't realistically overflow.
1260         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1261         unchecked {
1262             AddressData storage addressData = _addressData[from];
1263             addressData.balance -= 1;
1264             addressData.numberBurned += 1;
1265 
1266             // Keep track of who burned the token, and the timestamp of burning.
1267             TokenOwnership storage currSlot = _ownerships[tokenId];
1268             currSlot.addr = from;
1269             currSlot.startTimestamp = uint64(block.timestamp);
1270             currSlot.burned = true;
1271 
1272             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1273             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1274             uint256 nextTokenId = tokenId + 1;
1275             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1276             if (nextSlot.addr == address(0)) {
1277                 // This will suffice for checking _exists(nextTokenId),
1278                 // as a burned slot cannot contain the zero address.
1279                 if (nextTokenId != _currentIndex) {
1280                     nextSlot.addr = from;
1281                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1282                 }
1283             }
1284         }
1285 
1286         emit Transfer(from, address(0), tokenId);
1287         _afterTokenTransfers(from, address(0), tokenId, 1);
1288 
1289         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1290         unchecked {
1291             _burnCounter++;
1292         }
1293     }
1294 
1295     /**
1296      * @dev Approve `to` to operate on `tokenId`
1297      *
1298      * Emits a {Approval} event.
1299      */
1300     function _approve(
1301         address to,
1302         uint256 tokenId,
1303         address owner
1304     ) private {
1305         _tokenApprovals[tokenId] = to;
1306         emit Approval(owner, to, tokenId);
1307     }
1308 
1309     /**
1310      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1311      *
1312      * @param from address representing the previous owner of the given token ID
1313      * @param to target address that will receive the tokens
1314      * @param tokenId uint256 ID of the token to be transferred
1315      * @param _data bytes optional data to send along with the call
1316      * @return bool whether the call correctly returned the expected magic value
1317      */
1318     function _checkContractOnERC721Received(
1319         address from,
1320         address to,
1321         uint256 tokenId,
1322         bytes memory _data
1323     ) private returns (bool) {
1324         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1325             return retval == IERC721Receiver(to).onERC721Received.selector;
1326         } catch (bytes memory reason) {
1327             if (reason.length == 0) {
1328                 revert TransferToNonERC721ReceiverImplementer();
1329             } else {
1330                 assembly {
1331                     revert(add(32, reason), mload(reason))
1332                 }
1333             }
1334         }
1335     }
1336 
1337     /**
1338      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1339      * And also called before burning one token.
1340      *
1341      * startTokenId - the first token id to be transferred
1342      * quantity - the amount to be transferred
1343      *
1344      * Calling conditions:
1345      *
1346      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1347      * transferred to `to`.
1348      * - When `from` is zero, `tokenId` will be minted for `to`.
1349      * - When `to` is zero, `tokenId` will be burned by `from`.
1350      * - `from` and `to` are never both zero.
1351      */
1352     function _beforeTokenTransfers(
1353         address from,
1354         address to,
1355         uint256 startTokenId,
1356         uint256 quantity
1357     ) internal virtual {}
1358 
1359     /**
1360      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1361      * minting.
1362      * And also called after one token has been burned.
1363      *
1364      * startTokenId - the first token id to be transferred
1365      * quantity - the amount to be transferred
1366      *
1367      * Calling conditions:
1368      *
1369      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1370      * transferred to `to`.
1371      * - When `from` is zero, `tokenId` has been minted for `to`.
1372      * - When `to` is zero, `tokenId` has been burned by `from`.
1373      * - `from` and `to` are never both zero.
1374      */
1375     function _afterTokenTransfers(
1376         address from,
1377         address to,
1378         uint256 startTokenId,
1379         uint256 quantity
1380     ) internal virtual {}
1381 }
1382 
1383 
1384 
1385 pragma solidity >=0.8.9 <0.9.0;
1386 
1387 
1388 contract MoldedDreams is ERC721A, Ownable, ReentrancyGuard {
1389 
1390   using Strings for uint256;
1391 
1392   string public uriPrefix = '';
1393   string public uriSuffix = '.json';
1394   
1395   uint256 public cost;
1396   uint256 public maxSupply;
1397   uint256 public maxMintAmountPerWallet;
1398 
1399   bool public paused = true;
1400 
1401   mapping(address => uint256) private _walletMints;
1402 
1403   constructor(
1404     string memory _tokenName,
1405     string memory _tokenSymbol,
1406     uint256 _cost,
1407     uint256 _maxSupply,
1408     uint256 _maxMintAmountPerWallet,
1409     string memory _uriPrefix
1410   ) ERC721A(_tokenName, _tokenSymbol) {
1411     setCost(_cost);
1412     maxSupply = _maxSupply;
1413     setMaxMintAmountPerWallet(_maxMintAmountPerWallet);
1414     setUriPrefix(_uriPrefix);
1415     _safeMint(_msgSender(), 1);
1416   }
1417 
1418   modifier mintCompliance(uint256 _mintAmount) {
1419     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerWallet, 'Invalid mint amount!');
1420     require(_walletMints[_msgSender()] + _mintAmount < maxMintAmountPerWallet + 1, 'You have already minted');
1421     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1422     _;
1423   }
1424 
1425   modifier mintPriceCompliance(uint256 _mintAmount) {
1426     require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1427     _;
1428   }
1429 
1430   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1431     require(!paused, 'The contract is paused!');
1432 
1433     _walletMints[_msgSender()] += _mintAmount;
1434     _safeMint(_msgSender(), _mintAmount);
1435   }
1436 
1437   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1438     uint256 ownerTokenCount = balanceOf(_owner);
1439     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1440     uint256 currentTokenId = _startTokenId();
1441     uint256 ownedTokenIndex = 0;
1442     address latestOwnerAddress;
1443 
1444     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1445       TokenOwnership memory ownership = _ownerships[currentTokenId];
1446 
1447       if (!ownership.burned && ownership.addr != address(0)) {
1448         latestOwnerAddress = ownership.addr;
1449       }
1450 
1451       if (latestOwnerAddress == _owner) {
1452         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1453 
1454         ownedTokenIndex++;
1455       }
1456 
1457       currentTokenId++;
1458     }
1459 
1460     return ownedTokenIds;
1461   }
1462 
1463   function _startTokenId() internal view virtual override returns (uint256) {
1464     return 1;
1465   }
1466 
1467   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1468     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1469 
1470     string memory currentBaseURI = _baseURI();
1471     return bytes(currentBaseURI).length > 0
1472         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1473         : '';
1474   }
1475 
1476   function setCost(uint256 _cost) public onlyOwner {
1477     cost = _cost;
1478   }
1479 
1480   function setMaxMintAmountPerWallet(uint256 _maxMintAmountPerWallet) public onlyOwner {
1481     maxMintAmountPerWallet = _maxMintAmountPerWallet;
1482   }
1483 
1484   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1485     uriPrefix = _uriPrefix;
1486   }
1487 
1488   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1489     uriSuffix = _uriSuffix;
1490   }
1491 
1492   function setPaused(bool _state) public onlyOwner {
1493     paused = _state;
1494   }
1495 
1496   function withdraw() public onlyOwner nonReentrant {
1497 
1498     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1499     require(os);
1500   }
1501 
1502   function _baseURI() internal view virtual override returns (string memory) {
1503     return uriPrefix;
1504   }
1505 }