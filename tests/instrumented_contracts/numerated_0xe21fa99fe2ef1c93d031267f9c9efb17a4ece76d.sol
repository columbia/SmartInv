1 // SPDX-License-Identifier: MIT
2 
3 // AI every day, by @3orovik (twitter)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `to`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address to, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `from` to `to` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(
65         address from,
66         address to,
67         uint256 amount
68     ) external returns (bool);
69 
70     /**
71      * @dev Emitted when `value` tokens are moved from one account (`from`) to
72      * another (`to`).
73      *
74      * Note that `value` may be zero.
75      */
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     /**
79      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
80      * a call to {approve}. `value` is the new allowance.
81      */
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
86 
87 
88 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
89 
90 pragma solidity ^0.8.0;
91 
92 /**
93  * @dev Contract module that helps prevent reentrant calls to a function.
94  *
95  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
96  * available, which can be applied to functions to make sure there are no nested
97  * (reentrant) calls to them.
98  *
99  * Note that because there is a single `nonReentrant` guard, functions marked as
100  * `nonReentrant` may not call one another. This can be worked around by making
101  * those functions `private`, and then adding `external` `nonReentrant` entry
102  * points to them.
103  *
104  * TIP: If you would like to learn more about reentrancy and alternative ways
105  * to protect against it, check out our blog post
106  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
107  */
108 abstract contract ReentrancyGuard {
109     // Booleans are more expensive than uint256 or any type that takes up a full
110     // word because each write operation emits an extra SLOAD to first read the
111     // slot's contents, replace the bits taken up by the boolean, and then write
112     // back. This is the compiler's defense against contract upgrades and
113     // pointer aliasing, and it cannot be disabled.
114 
115     // The values being non-zero value makes deployment a bit more expensive,
116     // but in exchange the refund on every call to nonReentrant will be lower in
117     // amount. Since refunds are capped to a percentage of the total
118     // transaction's gas, it is best to keep them low in cases like this one, to
119     // increase the likelihood of the full refund coming into effect.
120     uint256 private constant _NOT_ENTERED = 1;
121     uint256 private constant _ENTERED = 2;
122 
123     uint256 private _status;
124 
125     constructor() {
126         _status = _NOT_ENTERED;
127     }
128 
129     /**
130      * @dev Prevents a contract from calling itself, directly or indirectly.
131      * Calling a `nonReentrant` function from another `nonReentrant`
132      * function is not supported. It is possible to prevent this from happening
133      * by making the `nonReentrant` function external, and making it call a
134      * `private` function that does the actual work.
135      */
136     modifier nonReentrant() {
137         // On the first call to nonReentrant, _notEntered will be true
138         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
139 
140         // Any calls to nonReentrant after this point will fail
141         _status = _ENTERED;
142 
143         _;
144 
145         // By storing the original value once again, a refund is triggered (see
146         // https://eips.ethereum.org/EIPS/eip-2200)
147         _status = _NOT_ENTERED;
148     }
149 }
150 
151 // File: @openzeppelin/contracts/utils/Strings.sol
152 
153 
154 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
155 
156 pragma solidity ^0.8.0;
157 
158 /**
159  * @dev String operations.
160  */
161 library Strings {
162     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
163 
164     /**
165      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
166      */
167     function toString(uint256 value) internal pure returns (string memory) {
168         // Inspired by OraclizeAPI's implementation - MIT licence
169         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
170 
171         if (value == 0) {
172             return "0";
173         }
174         uint256 temp = value;
175         uint256 digits;
176         while (temp != 0) {
177             digits++;
178             temp /= 10;
179         }
180         bytes memory buffer = new bytes(digits);
181         while (value != 0) {
182             digits -= 1;
183             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
184             value /= 10;
185         }
186         return string(buffer);
187     }
188 
189     /**
190      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
191      */
192     function toHexString(uint256 value) internal pure returns (string memory) {
193         if (value == 0) {
194             return "0x00";
195         }
196         uint256 temp = value;
197         uint256 length = 0;
198         while (temp != 0) {
199             length++;
200             temp >>= 8;
201         }
202         return toHexString(value, length);
203     }
204 
205     /**
206      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
207      */
208     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
209         bytes memory buffer = new bytes(2 * length + 2);
210         buffer[0] = "0";
211         buffer[1] = "x";
212         for (uint256 i = 2 * length + 1; i > 1; --i) {
213             buffer[i] = _HEX_SYMBOLS[value & 0xf];
214             value >>= 4;
215         }
216         require(value == 0, "Strings: hex length insufficient");
217         return string(buffer);
218     }
219 }
220 
221 // File: @openzeppelin/contracts/utils/Context.sol
222 
223 
224 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
225 
226 pragma solidity ^0.8.0;
227 
228 /**
229  * @dev Provides information about the current execution context, including the
230  * sender of the transaction and its data. While these are generally available
231  * via msg.sender and msg.data, they should not be accessed in such a direct
232  * manner, since when dealing with meta-transactions the account sending and
233  * paying for execution may not be the actual sender (as far as an application
234  * is concerned).
235  *
236  * This contract is only required for intermediate, library-like contracts.
237  */
238 abstract contract Context {
239     function _msgSender() internal view virtual returns (address) {
240         return msg.sender;
241     }
242 
243     function _msgData() internal view virtual returns (bytes calldata) {
244         return msg.data;
245     }
246 }
247 
248 // File: @openzeppelin/contracts/access/Ownable.sol
249 
250 
251 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
252 
253 pragma solidity ^0.8.0;
254 
255 
256 /**
257  * @dev Contract module which provides a basic access control mechanism, where
258  * there is an account (an owner) that can be granted exclusive access to
259  * specific functions.
260  *
261  * By default, the owner account will be the one that deploys the contract. This
262  * can later be changed with {transferOwnership}.
263  *
264  * This module is used through inheritance. It will make available the modifier
265  * `onlyOwner`, which can be applied to your functions to restrict their use to
266  * the owner.
267  */
268 abstract contract Ownable is Context {
269     address private _owner;
270 
271     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
272 
273     /**
274      * @dev Initializes the contract setting the deployer as the initial owner.
275      */
276     constructor() {
277         _transferOwnership(_msgSender());
278     }
279 
280     /**
281      * @dev Returns the address of the current owner.
282      */
283     function owner() public view virtual returns (address) {
284         return _owner;
285     }
286 
287     /**
288      * @dev Throws if called by any account other than the owner.
289      */
290     modifier onlyOwner() {
291         require(owner() == _msgSender(), "Ownable: caller is not the owner");
292         _;
293     }
294 
295     /**
296      * @dev Leaves the contract without owner. It will not be possible to call
297      * `onlyOwner` functions anymore. Can only be called by the current owner.
298      *
299      * NOTE: Renouncing ownership will leave the contract without an owner,
300      * thereby removing any functionality that is only available to the owner.
301      */
302     function renounceOwnership() public virtual onlyOwner {
303         _transferOwnership(address(0));
304     }
305 
306     /**
307      * @dev Transfers ownership of the contract to a new account (`newOwner`).
308      * Can only be called by the current owner.
309      */
310     function transferOwnership(address newOwner) public virtual onlyOwner {
311         require(newOwner != address(0), "Ownable: new owner is the zero address");
312         _transferOwnership(newOwner);
313     }
314 
315     /**
316      * @dev Transfers ownership of the contract to a new account (`newOwner`).
317      * Internal function without access restriction.
318      */
319     function _transferOwnership(address newOwner) internal virtual {
320         address oldOwner = _owner;
321         _owner = newOwner;
322         emit OwnershipTransferred(oldOwner, newOwner);
323     }
324 }
325 
326 // File: @openzeppelin/contracts/utils/Address.sol
327 
328 
329 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
330 
331 pragma solidity ^0.8.1;
332 
333 /**
334  * @dev Collection of functions related to the address type
335  */
336 library Address {
337     /**
338      * @dev Returns true if `account` is a contract.
339      *
340      * [IMPORTANT]
341      * ====
342      * It is unsafe to assume that an address for which this function returns
343      * false is an externally-owned account (EOA) and not a contract.
344      *
345      * Among others, `isContract` will return false for the following
346      * types of addresses:
347      *
348      *  - an externally-owned account
349      *  - a contract in construction
350      *  - an address where a contract will be created
351      *  - an address where a contract lived, but was destroyed
352      * ====
353      *
354      * [IMPORTANT]
355      * ====
356      * You shouldn't rely on `isContract` to protect against flash loan attacks!
357      *
358      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
359      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
360      * constructor.
361      * ====
362      */
363     function isContract(address account) internal view returns (bool) {
364         // This method relies on extcodesize/address.code.length, which returns 0
365         // for contracts in construction, since the code is only stored at the end
366         // of the constructor execution.
367 
368         return account.code.length > 0;
369     }
370 
371     /**
372      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
373      * `recipient`, forwarding all available gas and reverting on errors.
374      *
375      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
376      * of certain opcodes, possibly making contracts go over the 2300 gas limit
377      * imposed by `transfer`, making them unable to receive funds via
378      * `transfer`. {sendValue} removes this limitation.
379      *
380      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
381      *
382      * IMPORTANT: because control is transferred to `recipient`, care must be
383      * taken to not create reentrancy vulnerabilities. Consider using
384      * {ReentrancyGuard} or the
385      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
386      */
387     function sendValue(address payable recipient, uint256 amount) internal {
388         require(address(this).balance >= amount, "Address: insufficient balance");
389 
390         (bool success, ) = recipient.call{value: amount}("");
391         require(success, "Address: unable to send value, recipient may have reverted");
392     }
393 
394     /**
395      * @dev Performs a Solidity function call using a low level `call`. A
396      * plain `call` is an unsafe replacement for a function call: use this
397      * function instead.
398      *
399      * If `target` reverts with a revert reason, it is bubbled up by this
400      * function (like regular Solidity function calls).
401      *
402      * Returns the raw returned data. To convert to the expected return value,
403      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
404      *
405      * Requirements:
406      *
407      * - `target` must be a contract.
408      * - calling `target` with `data` must not revert.
409      *
410      * _Available since v3.1._
411      */
412     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
413         return functionCall(target, data, "Address: low-level call failed");
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
418      * `errorMessage` as a fallback revert reason when `target` reverts.
419      *
420      * _Available since v3.1._
421      */
422     function functionCall(
423         address target,
424         bytes memory data,
425         string memory errorMessage
426     ) internal returns (bytes memory) {
427         return functionCallWithValue(target, data, 0, errorMessage);
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
432      * but also transferring `value` wei to `target`.
433      *
434      * Requirements:
435      *
436      * - the calling contract must have an ETH balance of at least `value`.
437      * - the called Solidity function must be `payable`.
438      *
439      * _Available since v3.1._
440      */
441     function functionCallWithValue(
442         address target,
443         bytes memory data,
444         uint256 value
445     ) internal returns (bytes memory) {
446         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
451      * with `errorMessage` as a fallback revert reason when `target` reverts.
452      *
453      * _Available since v3.1._
454      */
455     function functionCallWithValue(
456         address target,
457         bytes memory data,
458         uint256 value,
459         string memory errorMessage
460     ) internal returns (bytes memory) {
461         require(address(this).balance >= value, "Address: insufficient balance for call");
462         require(isContract(target), "Address: call to non-contract");
463 
464         (bool success, bytes memory returndata) = target.call{value: value}(data);
465         return verifyCallResult(success, returndata, errorMessage);
466     }
467 
468     /**
469      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
470      * but performing a static call.
471      *
472      * _Available since v3.3._
473      */
474     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
475         return functionStaticCall(target, data, "Address: low-level static call failed");
476     }
477 
478     /**
479      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
480      * but performing a static call.
481      *
482      * _Available since v3.3._
483      */
484     function functionStaticCall(
485         address target,
486         bytes memory data,
487         string memory errorMessage
488     ) internal view returns (bytes memory) {
489         require(isContract(target), "Address: static call to non-contract");
490 
491         (bool success, bytes memory returndata) = target.staticcall(data);
492         return verifyCallResult(success, returndata, errorMessage);
493     }
494 
495     /**
496      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
497      * but performing a delegate call.
498      *
499      * _Available since v3.4._
500      */
501     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
502         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
503     }
504 
505     /**
506      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
507      * but performing a delegate call.
508      *
509      * _Available since v3.4._
510      */
511     function functionDelegateCall(
512         address target,
513         bytes memory data,
514         string memory errorMessage
515     ) internal returns (bytes memory) {
516         require(isContract(target), "Address: delegate call to non-contract");
517 
518         (bool success, bytes memory returndata) = target.delegatecall(data);
519         return verifyCallResult(success, returndata, errorMessage);
520     }
521 
522     /**
523      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
524      * revert reason using the provided one.
525      *
526      * _Available since v4.3._
527      */
528     function verifyCallResult(
529         bool success,
530         bytes memory returndata,
531         string memory errorMessage
532     ) internal pure returns (bytes memory) {
533         if (success) {
534             return returndata;
535         } else {
536             // Look for revert reason and bubble it up if present
537             if (returndata.length > 0) {
538                 // The easiest way to bubble the revert reason is using memory via assembly
539 
540                 assembly {
541                     let returndata_size := mload(returndata)
542                     revert(add(32, returndata), returndata_size)
543                 }
544             } else {
545                 revert(errorMessage);
546             }
547         }
548     }
549 }
550 
551 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
552 
553 
554 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
555 
556 pragma solidity ^0.8.0;
557 
558 
559 
560 /**
561  * @title SafeERC20
562  * @dev Wrappers around ERC20 operations that throw on failure (when the token
563  * contract returns false). Tokens that return no value (and instead revert or
564  * throw on failure) are also supported, non-reverting calls are assumed to be
565  * successful.
566  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
567  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
568  */
569 library SafeERC20 {
570     using Address for address;
571 
572     function safeTransfer(
573         IERC20 token,
574         address to,
575         uint256 value
576     ) internal {
577         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
578     }
579 
580     function safeTransferFrom(
581         IERC20 token,
582         address from,
583         address to,
584         uint256 value
585     ) internal {
586         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
587     }
588 
589     /**
590      * @dev Deprecated. This function has issues similar to the ones found in
591      * {IERC20-approve}, and its usage is discouraged.
592      *
593      * Whenever possible, use {safeIncreaseAllowance} and
594      * {safeDecreaseAllowance} instead.
595      */
596     function safeApprove(
597         IERC20 token,
598         address spender,
599         uint256 value
600     ) internal {
601         // safeApprove should only be called when setting an initial allowance,
602         // or when resetting it to zero. To increase and decrease it, use
603         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
604         require(
605             (value == 0) || (token.allowance(address(this), spender) == 0),
606             "SafeERC20: approve from non-zero to non-zero allowance"
607         );
608         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
609     }
610 
611     function safeIncreaseAllowance(
612         IERC20 token,
613         address spender,
614         uint256 value
615     ) internal {
616         uint256 newAllowance = token.allowance(address(this), spender) + value;
617         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
618     }
619 
620     function safeDecreaseAllowance(
621         IERC20 token,
622         address spender,
623         uint256 value
624     ) internal {
625         unchecked {
626             uint256 oldAllowance = token.allowance(address(this), spender);
627             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
628             uint256 newAllowance = oldAllowance - value;
629             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
630         }
631     }
632 
633     /**
634      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
635      * on the return value: the return value is optional (but if data is returned, it must not be false).
636      * @param token The token targeted by the call.
637      * @param data The call data (encoded using abi.encode or one of its variants).
638      */
639     function _callOptionalReturn(IERC20 token, bytes memory data) private {
640         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
641         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
642         // the target address contains contract code and also asserts for success in the low-level call.
643 
644         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
645         if (returndata.length > 0) {
646             // Return data is optional
647             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
648         }
649     }
650 }
651 
652 
653 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
654 
655 
656 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
657 
658 pragma solidity ^0.8.0;
659 
660 /**
661  * @title ERC721 token receiver interface
662  * @dev Interface for any contract that wants to support safeTransfers
663  * from ERC721 asset contracts.
664  */
665 interface IERC721Receiver {
666     /**
667      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
668      * by `operator` from `from`, this function is called.
669      *
670      * It must return its Solidity selector to confirm the token transfer.
671      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
672      *
673      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
674      */
675     function onERC721Received(
676         address operator,
677         address from,
678         uint256 tokenId,
679         bytes calldata data
680     ) external returns (bytes4);
681 }
682 
683 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
684 
685 
686 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
687 
688 pragma solidity ^0.8.0;
689 
690 /**
691  * @dev Interface of the ERC165 standard, as defined in the
692  * https://eips.ethereum.org/EIPS/eip-165[EIP].
693  *
694  * Implementers can declare support of contract interfaces, which can then be
695  * queried by others ({ERC165Checker}).
696  *
697  * For an implementation, see {ERC165}.
698  */
699 interface IERC165 {
700     /**
701      * @dev Returns true if this contract implements the interface defined by
702      * `interfaceId`. See the corresponding
703      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
704      * to learn more about how these ids are created.
705      *
706      * This function call must use less than 30 000 gas.
707      */
708     function supportsInterface(bytes4 interfaceId) external view returns (bool);
709 }
710 
711 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
712 
713 
714 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
715 
716 pragma solidity ^0.8.0;
717 
718 
719 /**
720  * @dev Implementation of the {IERC165} interface.
721  *
722  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
723  * for the additional interface id that will be supported. For example:
724  *
725  * ```solidity
726  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
727  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
728  * }
729  * ```
730  *
731  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
732  */
733 abstract contract ERC165 is IERC165 {
734     /**
735      * @dev See {IERC165-supportsInterface}.
736      */
737     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
738         return interfaceId == type(IERC165).interfaceId;
739     }
740 }
741 
742 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
743 
744 
745 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
746 
747 pragma solidity ^0.8.0;
748 
749 
750 /**
751  * @dev Required interface of an ERC721 compliant contract.
752  */
753 interface IERC721 is IERC165 {
754     /**
755      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
756      */
757     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
758 
759     /**
760      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
761      */
762     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
763 
764     /**
765      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
766      */
767     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
768 
769     /**
770      * @dev Returns the number of tokens in ``owner``'s account.
771      */
772     function balanceOf(address owner) external view returns (uint256 balance);
773 
774     /**
775      * @dev Returns the owner of the `tokenId` token.
776      *
777      * Requirements:
778      *
779      * - `tokenId` must exist.
780      */
781     function ownerOf(uint256 tokenId) external view returns (address owner);
782 
783     /**
784      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
785      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
786      *
787      * Requirements:
788      *
789      * - `from` cannot be the zero address.
790      * - `to` cannot be the zero address.
791      * - `tokenId` token must exist and be owned by `from`.
792      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
793      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
794      *
795      * Emits a {Transfer} event.
796      */
797     function safeTransferFrom(
798         address from,
799         address to,
800         uint256 tokenId
801     ) external;
802 
803     /**
804      * @dev Transfers `tokenId` token from `from` to `to`.
805      *
806      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
807      *
808      * Requirements:
809      *
810      * - `from` cannot be the zero address.
811      * - `to` cannot be the zero address.
812      * - `tokenId` token must be owned by `from`.
813      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
814      *
815      * Emits a {Transfer} event.
816      */
817     function transferFrom(
818         address from,
819         address to,
820         uint256 tokenId
821     ) external;
822 
823     /**
824      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
825      * The approval is cleared when the token is transferred.
826      *
827      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
828      *
829      * Requirements:
830      *
831      * - The caller must own the token or be an approved operator.
832      * - `tokenId` must exist.
833      *
834      * Emits an {Approval} event.
835      */
836     function approve(address to, uint256 tokenId) external;
837 
838     /**
839      * @dev Returns the account approved for `tokenId` token.
840      *
841      * Requirements:
842      *
843      * - `tokenId` must exist.
844      */
845     function getApproved(uint256 tokenId) external view returns (address operator);
846 
847     /**
848      * @dev Approve or remove `operator` as an operator for the caller.
849      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
850      *
851      * Requirements:
852      *
853      * - The `operator` cannot be the caller.
854      *
855      * Emits an {ApprovalForAll} event.
856      */
857     function setApprovalForAll(address operator, bool _approved) external;
858 
859     /**
860      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
861      *
862      * See {setApprovalForAll}
863      */
864     function isApprovedForAll(address owner, address operator) external view returns (bool);
865 
866     /**
867      * @dev Safely transfers `tokenId` token from `from` to `to`.
868      *
869      * Requirements:
870      *
871      * - `from` cannot be the zero address.
872      * - `to` cannot be the zero address.
873      * - `tokenId` token must exist and be owned by `from`.
874      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
875      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
876      *
877      * Emits a {Transfer} event.
878      */
879     function safeTransferFrom(
880         address from,
881         address to,
882         uint256 tokenId,
883         bytes calldata data
884     ) external;
885 }
886 
887 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
888 
889 
890 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
891 
892 pragma solidity ^0.8.0;
893 
894 
895 /**
896  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
897  * @dev See https://eips.ethereum.org/EIPS/eip-721
898  */
899 interface IERC721Enumerable is IERC721 {
900     /**
901      * @dev Returns the total amount of tokens stored by the contract.
902      */
903     function totalSupply() external view returns (uint256);
904 
905     /**
906      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
907      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
908      */
909     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
910 
911     /**
912      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
913      * Use along with {totalSupply} to enumerate all tokens.
914      */
915     function tokenByIndex(uint256 index) external view returns (uint256);
916 }
917 
918 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
919 
920 
921 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
922 
923 pragma solidity ^0.8.0;
924 
925 
926 /**
927  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
928  * @dev See https://eips.ethereum.org/EIPS/eip-721
929  */
930 interface IERC721Metadata is IERC721 {
931     /**
932      * @dev Returns the token collection name.
933      */
934     function name() external view returns (string memory);
935 
936     /**
937      * @dev Returns the token collection symbol.
938      */
939     function symbol() external view returns (string memory);
940 
941     /**
942      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
943      */
944     function tokenURI(uint256 tokenId) external view returns (string memory);
945 }
946 
947 // File: contracts/TwistedToonz.sol
948 
949 
950 // Creator: Chiru Labs
951 
952 pragma solidity ^0.8.0;
953 
954 
955 
956 
957 
958 
959 
960 
961 
962 /**
963  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
964  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
965  *
966  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
967  *
968  * Does not support burning tokens to address(0).
969  *
970  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
971  */
972 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
973     using Address for address;
974     using Strings for uint256;
975 
976     struct TokenOwnership {
977         address addr;
978         uint64 startTimestamp;
979     }
980 
981     struct AddressData {
982         uint128 balance;
983         uint128 numberMinted;
984     }
985 
986     uint256 internal currentIndex;
987 
988     // Token name
989     string private _name;
990 
991     // Token symbol
992     string private _symbol;
993 
994     // Mapping from token ID to ownership details
995     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
996     mapping(uint256 => TokenOwnership) internal _ownerships;
997 
998     // Mapping owner address to address data
999     mapping(address => AddressData) private _addressData;
1000 
1001     // Mapping from token ID to approved address
1002     mapping(uint256 => address) private _tokenApprovals;
1003 
1004     // Mapping from owner to operator approvals
1005     mapping(address => mapping(address => bool)) private _operatorApprovals;
1006 
1007     constructor(string memory name_, string memory symbol_) {
1008         _name = name_;
1009         _symbol = symbol_;
1010     }
1011 
1012     /**
1013      * @dev See {IERC721Enumerable-totalSupply}.
1014      */
1015     function totalSupply() public view override returns (uint256) {
1016         return currentIndex;
1017     }
1018 
1019     /**
1020      * @dev See {IERC721Enumerable-tokenByIndex}.
1021      */
1022     function tokenByIndex(uint256 index) public view override returns (uint256) {
1023         require(index < totalSupply(), "ERC721A: global index out of bounds");
1024         return index;
1025     }
1026 
1027     /**
1028      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1029      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1030      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1031      */
1032     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1033         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1034         uint256 numMintedSoFar = totalSupply();
1035         uint256 tokenIdsIdx;
1036         address currOwnershipAddr;
1037 
1038         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1039         unchecked {
1040             for (uint256 i; i < numMintedSoFar; i++) {
1041                 TokenOwnership memory ownership = _ownerships[i];
1042                 if (ownership.addr != address(0)) {
1043                     currOwnershipAddr = ownership.addr;
1044                 }
1045                 if (currOwnershipAddr == owner) {
1046                     if (tokenIdsIdx == index) {
1047                         return i;
1048                     }
1049                     tokenIdsIdx++;
1050                 }
1051             }
1052         }
1053 
1054         revert("ERC721A: unable to get token of owner by index");
1055     }
1056 
1057     /**
1058      * @dev See {IERC165-supportsInterface}.
1059      */
1060     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1061         return
1062             interfaceId == type(IERC721).interfaceId ||
1063             interfaceId == type(IERC721Metadata).interfaceId ||
1064             interfaceId == type(IERC721Enumerable).interfaceId ||
1065             super.supportsInterface(interfaceId);
1066     }
1067 
1068     /**
1069      * @dev See {IERC721-balanceOf}.
1070      */
1071     function balanceOf(address owner) public view override returns (uint256) {
1072         require(owner != address(0), "ERC721A: balance query for the zero address");
1073         return uint256(_addressData[owner].balance);
1074     }
1075 
1076     function _numberMinted(address owner) internal view returns (uint256) {
1077         require(owner != address(0), "ERC721A: number minted query for the zero address");
1078         return uint256(_addressData[owner].numberMinted);
1079     }
1080 
1081     /**
1082      * Gas spent here starts off proportional to the maximum mint batch size.
1083      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1084      */
1085     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1086         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1087 
1088         unchecked {
1089             for (uint256 curr = tokenId; curr >= 0; curr--) {
1090                 TokenOwnership memory ownership = _ownerships[curr];
1091                 if (ownership.addr != address(0)) {
1092                     return ownership;
1093                 }
1094             }
1095         }
1096 
1097         revert("ERC721A: unable to determine the owner of token");
1098     }
1099 
1100     /**
1101      * @dev See {IERC721-ownerOf}.
1102      */
1103     function ownerOf(uint256 tokenId) public view override returns (address) {
1104         return ownershipOf(tokenId).addr;
1105     }
1106 
1107     /**
1108      * @dev See {IERC721Metadata-name}.
1109      */
1110     function name() public view virtual override returns (string memory) {
1111         return _name;
1112     }
1113 
1114     /**
1115      * @dev See {IERC721Metadata-symbol}.
1116      */
1117     function symbol() public view virtual override returns (string memory) {
1118         return _symbol;
1119     }
1120 
1121     /**
1122      * @dev See {IERC721Metadata-tokenURI}.
1123      */
1124     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1125         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1126 
1127         string memory baseURI = _baseURI();
1128         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1129     }
1130 
1131     /**
1132      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1133      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1134      * by default, can be overriden in child contracts.
1135      */
1136     function _baseURI() internal view virtual returns (string memory) {
1137         return "";
1138     }
1139 
1140     /**
1141      * @dev See {IERC721-approve}.
1142      */
1143     function approve(address to, uint256 tokenId) public override {
1144         address owner = ERC721A.ownerOf(tokenId);
1145         require(to != owner, "ERC721A: approval to current owner");
1146 
1147         require(
1148             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1149             "ERC721A: approve caller is not owner nor approved for all"
1150         );
1151 
1152         _approve(to, tokenId, owner);
1153     }
1154 
1155     /**
1156      * @dev See {IERC721-getApproved}.
1157      */
1158     function getApproved(uint256 tokenId) public view override returns (address) {
1159         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1160 
1161         return _tokenApprovals[tokenId];
1162     }
1163 
1164     /**
1165      * @dev See {IERC721-setApprovalForAll}.
1166      */
1167     function setApprovalForAll(address operator, bool approved) public override {
1168         require(operator != _msgSender(), "ERC721A: approve to caller");
1169 
1170         _operatorApprovals[_msgSender()][operator] = approved;
1171         emit ApprovalForAll(_msgSender(), operator, approved);
1172     }
1173 
1174     /**
1175      * @dev See {IERC721-isApprovedForAll}.
1176      */
1177     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1178         return _operatorApprovals[owner][operator];
1179     }
1180 
1181     /**
1182      * @dev See {IERC721-transferFrom}.
1183      */
1184     function transferFrom(
1185         address from,
1186         address to,
1187         uint256 tokenId
1188     ) public virtual override {
1189         _transfer(from, to, tokenId);
1190     }
1191 
1192     /**
1193      * @dev See {IERC721-safeTransferFrom}.
1194      */
1195     function safeTransferFrom(
1196         address from,
1197         address to,
1198         uint256 tokenId
1199     ) public virtual override {
1200         safeTransferFrom(from, to, tokenId, "");
1201     }
1202 
1203     /**
1204      * @dev See {IERC721-safeTransferFrom}.
1205      */
1206     function safeTransferFrom(
1207         address from,
1208         address to,
1209         uint256 tokenId,
1210         bytes memory _data
1211     ) public override {
1212         _transfer(from, to, tokenId);
1213         require(
1214             _checkOnERC721Received(from, to, tokenId, _data),
1215             "ERC721A: transfer to non ERC721Receiver implementer"
1216         );
1217     }
1218 
1219     /**
1220      * @dev Returns whether `tokenId` exists.
1221      *
1222      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1223      *
1224      * Tokens start existing when they are minted (`_mint`),
1225      */
1226     function _exists(uint256 tokenId) internal view returns (bool) {
1227         return tokenId < currentIndex;
1228     }
1229 
1230     function _safeMint(address to, uint256 quantity) internal {
1231         _safeMint(to, quantity, "");
1232     }
1233 
1234     /**
1235      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1236      *
1237      * Requirements:
1238      *
1239      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1240      * - `quantity` must be greater than 0.
1241      *
1242      * Emits a {Transfer} event.
1243      */
1244     function _safeMint(
1245         address to,
1246         uint256 quantity,
1247         bytes memory _data
1248     ) internal {
1249         _mint(to, quantity, _data, true);
1250     }
1251 
1252     /**
1253      * @dev Mints `quantity` tokens and transfers them to `to`.
1254      *
1255      * Requirements:
1256      *
1257      * - `to` cannot be the zero address.
1258      * - `quantity` must be greater than 0.
1259      *
1260      * Emits a {Transfer} event.
1261      */
1262     function _mint(
1263         address to,
1264         uint256 quantity,
1265         bytes memory _data,
1266         bool safe
1267     ) internal {
1268         uint256 startTokenId = currentIndex;
1269         require(to != address(0), "ERC721A: mint to the zero address");
1270         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1271 
1272         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1273 
1274         // Overflows are incredibly unrealistic.
1275         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1276         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1277         unchecked {
1278             _addressData[to].balance += uint128(quantity);
1279             _addressData[to].numberMinted += uint128(quantity);
1280 
1281             _ownerships[startTokenId].addr = to;
1282             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1283 
1284             uint256 updatedIndex = startTokenId;
1285 
1286             for (uint256 i; i < quantity; i++) {
1287                 emit Transfer(address(0), to, updatedIndex);
1288                 if (safe) {
1289                     require(
1290                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1291                         "ERC721A: transfer to non ERC721Receiver implementer"
1292                     );
1293                 }
1294 
1295                 updatedIndex++;
1296             }
1297 
1298             currentIndex = updatedIndex;
1299         }
1300 
1301         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1302     }
1303 
1304     /**
1305      * @dev Transfers `tokenId` from `from` to `to`.
1306      *
1307      * Requirements:
1308      *
1309      * - `to` cannot be the zero address.
1310      * - `tokenId` token must be owned by `from`.
1311      *
1312      * Emits a {Transfer} event.
1313      */
1314     function _transfer(
1315         address from,
1316         address to,
1317         uint256 tokenId
1318     ) private {
1319         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1320 
1321         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1322             getApproved(tokenId) == _msgSender() ||
1323             isApprovedForAll(prevOwnership.addr, _msgSender()));
1324 
1325         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1326 
1327         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1328         require(to != address(0), "ERC721A: transfer to the zero address");
1329 
1330         _beforeTokenTransfers(from, to, tokenId, 1);
1331 
1332         // Clear approvals from the previous owner
1333         _approve(address(0), tokenId, prevOwnership.addr);
1334 
1335         // Underflow of the sender's balance is impossible because we check for
1336         // ownership above and the recipient's balance can't realistically overflow.
1337         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1338         unchecked {
1339             _addressData[from].balance -= 1;
1340             _addressData[to].balance += 1;
1341 
1342             _ownerships[tokenId].addr = to;
1343             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1344 
1345             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1346             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1347             uint256 nextTokenId = tokenId + 1;
1348             if (_ownerships[nextTokenId].addr == address(0)) {
1349                 if (_exists(nextTokenId)) {
1350                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1351                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1352                 }
1353             }
1354         }
1355 
1356         emit Transfer(from, to, tokenId);
1357         _afterTokenTransfers(from, to, tokenId, 1);
1358     }
1359 
1360     /**
1361      * @dev Approve `to` to operate on `tokenId`
1362      *
1363      * Emits a {Approval} event.
1364      */
1365     function _approve(
1366         address to,
1367         uint256 tokenId,
1368         address owner
1369     ) private {
1370         _tokenApprovals[tokenId] = to;
1371         emit Approval(owner, to, tokenId);
1372     }
1373 
1374     /**
1375      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1376      * The call is not executed if the target address is not a contract.
1377      *
1378      * @param from address representing the previous owner of the given token ID
1379      * @param to target address that will receive the tokens
1380      * @param tokenId uint256 ID of the token to be transferred
1381      * @param _data bytes optional data to send along with the call
1382      * @return bool whether the call correctly returned the expected magic value
1383      */
1384     function _checkOnERC721Received(
1385         address from,
1386         address to,
1387         uint256 tokenId,
1388         bytes memory _data
1389     ) private returns (bool) {
1390         if (to.isContract()) {
1391             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1392                 return retval == IERC721Receiver(to).onERC721Received.selector;
1393             } catch (bytes memory reason) {
1394                 if (reason.length == 0) {
1395                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1396                 } else {
1397                     assembly {
1398                         revert(add(32, reason), mload(reason))
1399                     }
1400                 }
1401             }
1402         } else {
1403             return true;
1404         }
1405     }
1406 
1407     /**
1408      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1409      *
1410      * startTokenId - the first token id to be transferred
1411      * quantity - the amount to be transferred
1412      *
1413      * Calling conditions:
1414      *
1415      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1416      * transferred to `to`.
1417      * - When `from` is zero, `tokenId` will be minted for `to`.
1418      */
1419     function _beforeTokenTransfers(
1420         address from,
1421         address to,
1422         uint256 startTokenId,
1423         uint256 quantity
1424     ) internal virtual {}
1425 
1426     /**
1427      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1428      * minting.
1429      *
1430      * startTokenId - the first token id to be transferred
1431      * quantity - the amount to be transferred
1432      *
1433      * Calling conditions:
1434      *
1435      * - when `from` and `to` are both non-zero.
1436      * - `from` and `to` are never both zero.
1437      */
1438     function _afterTokenTransfers(
1439         address from,
1440         address to,
1441         uint256 startTokenId,
1442         uint256 quantity
1443     ) internal virtual {}
1444 }
1445 
1446 contract borovik is ERC721A, Ownable, ReentrancyGuard {
1447 
1448   uint public nextOwnerToExplicitlySet;
1449   string public baseURI;
1450 
1451   constructor() ERC721A("AI Every Day", "AIED") {}
1452   function reserveMint(uint256 num) external onlyOwner {
1453     _safeMint(msg.sender, num);
1454   }
1455   function setBaseURI(string calldata baseURI_) external onlyOwner {
1456     baseURI = baseURI_;
1457   }
1458   function _baseURI() internal view virtual override returns (string memory) {
1459     return baseURI;
1460   }
1461   function withdraw() external onlyOwner nonReentrant {
1462     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1463     require(success, "Transfer failed.");
1464   }
1465   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1466     _setOwnersExplicit(quantity);
1467   }
1468   function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1469     return ownershipOf(tokenId);
1470   }
1471   function _setOwnersExplicit(uint256 quantity) internal {
1472       require(quantity != 0, "quantity must be nonzero");
1473       require(currentIndex != 0, "no tokens minted yet");
1474       uint256 _nextOwnerToExplicitlySet = nextOwnerToExplicitlySet;
1475       require(_nextOwnerToExplicitlySet < currentIndex, "all ownerships have been set");
1476 
1477       // Index underflow is impossible.
1478       // Counter or index overflow is incredibly unrealistic.
1479       unchecked {
1480           uint256 endIndex = _nextOwnerToExplicitlySet + quantity - 1;
1481 
1482           // Set the end index to be the last token index
1483           if (endIndex + 1 > currentIndex) {
1484               endIndex = currentIndex - 1;
1485           }
1486 
1487           for (uint256 i = _nextOwnerToExplicitlySet; i <= endIndex; i++) {
1488               if (_ownerships[i].addr == address(0)) {
1489                   TokenOwnership memory ownership = ownershipOf(i);
1490                   _ownerships[i].addr = ownership.addr;
1491                   _ownerships[i].startTimestamp = ownership.startTimestamp;
1492               }
1493           }
1494 
1495           nextOwnerToExplicitlySet = endIndex + 1;
1496       }
1497   }
1498 }