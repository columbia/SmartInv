1 /**
2  *Submitted for verification at Etherscan.io on 2022-05-21
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 // World Cup Apes YC
8 
9 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
10 
11 
12 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
13 
14 pragma solidity ^0.8.0;
15 
16 /**
17  * @dev Interface of the ERC20 standard as defined in the EIP.
18  */
19 interface IERC20 {
20     /**
21      * @dev Returns the amount of tokens in existence.
22      */
23     function totalSupply() external view returns (uint256);
24 
25     /**
26      * @dev Returns the amount of tokens owned by `account`.
27      */
28     function balanceOf(address account) external view returns (uint256);
29 
30     /**
31      * @dev Moves `amount` tokens from the caller's account to `to`.
32      *
33      * Returns a boolean value indicating whether the operation succeeded.
34      *
35      * Emits a {Transfer} event.
36      */
37     function transfer(address to, uint256 amount) external returns (bool);
38 
39     /**
40      * @dev Returns the remaining number of tokens that `spender` will be
41      * allowed to spend on behalf of `owner` through {transferFrom}. This is
42      * zero by default.
43      *
44      * This value changes when {approve} or {transferFrom} are called.
45      */
46     function allowance(address owner, address spender) external view returns (uint256);
47 
48     /**
49      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * IMPORTANT: Beware that changing an allowance with this method brings the risk
54      * that someone may use both the old and the new allowance by unfortunate
55      * transaction ordering. One possible solution to mitigate this race
56      * condition is to first reduce the spender's allowance to 0 and set the
57      * desired value afterwards:
58      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
59      *
60      * Emits an {Approval} event.
61      */
62     function approve(address spender, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Moves `amount` tokens from `from` to `to` using the
66      * allowance mechanism. `amount` is then deducted from the caller's
67      * allowance.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * Emits a {Transfer} event.
72      */
73     function transferFrom(
74         address from,
75         address to,
76         uint256 amount
77     ) external returns (bool);
78 
79     /**
80      * @dev Emitted when `value` tokens are moved from one account (`from`) to
81      * another (`to`).
82      *
83      * Note that `value` may be zero.
84      */
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     /**
88      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
89      * a call to {approve}. `value` is the new allowance.
90      */
91     event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
95 
96 
97 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
98 
99 pragma solidity ^0.8.0;
100 
101 /**
102  * @dev Contract module that helps prevent reentrant calls to a function.
103  *
104  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
105  * available, which can be applied to functions to make sure there are no nested
106  * (reentrant) calls to them.
107  *
108  * Note that because there is a single `nonReentrant` guard, functions marked as
109  * `nonReentrant` may not call one another. This can be worked around by making
110  * those functions `private`, and then adding `external` `nonReentrant` entry
111  * points to them.
112  *
113  * TIP: If you would like to learn more about reentrancy and alternative ways
114  * to protect against it, check out our blog post
115  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
116  */
117 abstract contract ReentrancyGuard {
118     // Booleans are more expensive than uint256 or any type that takes up a full
119     // word because each write operation emits an extra SLOAD to first read the
120     // slot's contents, replace the bits taken up by the boolean, and then write
121     // back. This is the compiler's defense against contract upgrades and
122     // pointer aliasing, and it cannot be disabled.
123 
124     // The values being non-zero value makes deployment a bit more expensive,
125     // but in exchange the refund on every call to nonReentrant will be lower in
126     // amount. Since refunds are capped to a percentage of the total
127     // transaction's gas, it is best to keep them low in cases like this one, to
128     // increase the likelihood of the full refund coming into effect.
129     uint256 private constant _NOT_ENTERED = 1;
130     uint256 private constant _ENTERED = 2;
131 
132     uint256 private _status;
133 
134     constructor() {
135         _status = _NOT_ENTERED;
136     }
137 
138     /**
139      * @dev Prevents a contract from calling itself, directly or indirectly.
140      * Calling a `nonReentrant` function from another `nonReentrant`
141      * function is not supported. It is possible to prevent this from happening
142      * by making the `nonReentrant` function external, and making it call a
143      * `private` function that does the actual work.
144      */
145     modifier nonReentrant() {
146         // On the first call to nonReentrant, _notEntered will be true
147         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
148 
149         // Any calls to nonReentrant after this point will fail
150         _status = _ENTERED;
151 
152         _;
153 
154         // By storing the original value once again, a refund is triggered (see
155         // https://eips.ethereum.org/EIPS/eip-2200)
156         _status = _NOT_ENTERED;
157     }
158 }
159 
160 // File: @openzeppelin/contracts/utils/Strings.sol
161 
162 
163 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
164 
165 pragma solidity ^0.8.0;
166 
167 /**
168  * @dev String operations.
169  */
170 library Strings {
171     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
172 
173     /**
174      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
175      */
176     function toString(uint256 value) internal pure returns (string memory) {
177         // Inspired by OraclizeAPI's implementation - MIT licence
178         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
179 
180         if (value == 0) {
181             return "0";
182         }
183         uint256 temp = value;
184         uint256 digits;
185         while (temp != 0) {
186             digits++;
187             temp /= 10;
188         }
189         bytes memory buffer = new bytes(digits);
190         while (value != 0) {
191             digits -= 1;
192             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
193             value /= 10;
194         }
195         return string(buffer);
196     }
197 
198     /**
199      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
200      */
201     function toHexString(uint256 value) internal pure returns (string memory) {
202         if (value == 0) {
203             return "0x00";
204         }
205         uint256 temp = value;
206         uint256 length = 0;
207         while (temp != 0) {
208             length++;
209             temp >>= 8;
210         }
211         return toHexString(value, length);
212     }
213 
214     /**
215      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
216      */
217     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
218         bytes memory buffer = new bytes(2 * length + 2);
219         buffer[0] = "0";
220         buffer[1] = "x";
221         for (uint256 i = 2 * length + 1; i > 1; --i) {
222             buffer[i] = _HEX_SYMBOLS[value & 0xf];
223             value >>= 4;
224         }
225         require(value == 0, "Strings: hex length insufficient");
226         return string(buffer);
227     }
228 }
229 
230 // File: @openzeppelin/contracts/utils/Context.sol
231 
232 
233 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
234 
235 pragma solidity ^0.8.0;
236 
237 /**
238  * @dev Provides information about the current execution context, including the
239  * sender of the transaction and its data. While these are generally available
240  * via msg.sender and msg.data, they should not be accessed in such a direct
241  * manner, since when dealing with meta-transactions the account sending and
242  * paying for execution may not be the actual sender (as far as an application
243  * is concerned).
244  *
245  * This contract is only required for intermediate, library-like contracts.
246  */
247 abstract contract Context {
248     function _msgSender() internal view virtual returns (address) {
249         return msg.sender;
250     }
251 
252     function _msgData() internal view virtual returns (bytes calldata) {
253         return msg.data;
254     }
255 }
256 
257 // File: @openzeppelin/contracts/access/Ownable.sol
258 
259 
260 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
261 
262 pragma solidity ^0.8.0;
263 
264 
265 /**
266  * @dev Contract module which provides a basic access control mechanism, where
267  * there is an account (an owner) that can be granted exclusive access to
268  * specific functions.
269  *
270  * By default, the owner account will be the one that deploys the contract. This
271  * can later be changed with {transferOwnership}.
272  *
273  * This module is used through inheritance. It will make available the modifier
274  * `onlyOwner`, which can be applied to your functions to restrict their use to
275  * the owner.
276  */
277 abstract contract Ownable is Context {
278     address private _owner;
279 
280     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
281 
282     /**
283      * @dev Initializes the contract setting the deployer as the initial owner.
284      */
285     constructor() {
286         _transferOwnership(_msgSender());
287     }
288 
289     /**
290      * @dev Returns the address of the current owner.
291      */
292     function owner() public view virtual returns (address) {
293         return _owner;
294     }
295 
296     /**
297      * @dev Throws if called by any account other than the owner.
298      */
299     modifier onlyOwner() {
300         require(owner() == _msgSender(), "Ownable: caller is not the owner");
301         _;
302     }
303 
304     /**
305      * @dev Leaves the contract without owner. It will not be possible to call
306      * `onlyOwner` functions anymore. Can only be called by the current owner.
307      *
308      * NOTE: Renouncing ownership will leave the contract without an owner,
309      * thereby removing any functionality that is only available to the owner.
310      */
311     function renounceOwnership() public virtual onlyOwner {
312         _transferOwnership(address(0));
313     }
314 
315     /**
316      * @dev Transfers ownership of the contract to a new account (`newOwner`).
317      * Can only be called by the current owner.
318      */
319     function transferOwnership(address newOwner) public virtual onlyOwner {
320         require(newOwner != address(0), "Ownable: new owner is the zero address");
321         _transferOwnership(newOwner);
322     }
323 
324     /**
325      * @dev Transfers ownership of the contract to a new account (`newOwner`).
326      * Internal function without access restriction.
327      */
328     function _transferOwnership(address newOwner) internal virtual {
329         address oldOwner = _owner;
330         _owner = newOwner;
331         emit OwnershipTransferred(oldOwner, newOwner);
332     }
333 }
334 
335 // File: @openzeppelin/contracts/utils/Address.sol
336 
337 
338 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
339 
340 pragma solidity ^0.8.1;
341 
342 /**
343  * @dev Collection of functions related to the address type
344  */
345 library Address {
346     /**
347      * @dev Returns true if `account` is a contract.
348      *
349      * [IMPORTANT]
350      * ====
351      * It is unsafe to assume that an address for which this function returns
352      * false is an externally-owned account (EOA) and not a contract.
353      *
354      * Among others, `isContract` will return false for the following
355      * types of addresses:
356      *
357      *  - an externally-owned account
358      *  - a contract in construction
359      *  - an address where a contract will be created
360      *  - an address where a contract lived, but was destroyed
361      * ====
362      *
363      * [IMPORTANT]
364      * ====
365      * You shouldn't rely on `isContract` to protect against flash loan attacks!
366      *
367      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
368      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
369      * constructor.
370      * ====
371      */
372     function isContract(address account) internal view returns (bool) {
373         // This method relies on extcodesize/address.code.length, which returns 0
374         // for contracts in construction, since the code is only stored at the end
375         // of the constructor execution.
376 
377         return account.code.length > 0;
378     }
379 
380     /**
381      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
382      * `recipient`, forwarding all available gas and reverting on errors.
383      *
384      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
385      * of certain opcodes, possibly making contracts go over the 2300 gas limit
386      * imposed by `transfer`, making them unable to receive funds via
387      * `transfer`. {sendValue} removes this limitation.
388      *
389      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
390      *
391      * IMPORTANT: because control is transferred to `recipient`, care must be
392      * taken to not create reentrancy vulnerabilities. Consider using
393      * {ReentrancyGuard} or the
394      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
395      */
396     function sendValue(address payable recipient, uint256 amount) internal {
397         require(address(this).balance >= amount, "Address: insufficient balance");
398 
399         (bool success, ) = recipient.call{value: amount}("");
400         require(success, "Address: unable to send value, recipient may have reverted");
401     }
402 
403     /**
404      * @dev Performs a Solidity function call using a low level `call`. A
405      * plain `call` is an unsafe replacement for a function call: use this
406      * function instead.
407      *
408      * If `target` reverts with a revert reason, it is bubbled up by this
409      * function (like regular Solidity function calls).
410      *
411      * Returns the raw returned data. To convert to the expected return value,
412      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
413      *
414      * Requirements:
415      *
416      * - `target` must be a contract.
417      * - calling `target` with `data` must not revert.
418      *
419      * _Available since v3.1._
420      */
421     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
422         return functionCall(target, data, "Address: low-level call failed");
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
427      * `errorMessage` as a fallback revert reason when `target` reverts.
428      *
429      * _Available since v3.1._
430      */
431     function functionCall(
432         address target,
433         bytes memory data,
434         string memory errorMessage
435     ) internal returns (bytes memory) {
436         return functionCallWithValue(target, data, 0, errorMessage);
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
441      * but also transferring `value` wei to `target`.
442      *
443      * Requirements:
444      *
445      * - the calling contract must have an ETH balance of at least `value`.
446      * - the called Solidity function must be `payable`.
447      *
448      * _Available since v3.1._
449      */
450     function functionCallWithValue(
451         address target,
452         bytes memory data,
453         uint256 value
454     ) internal returns (bytes memory) {
455         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
456     }
457 
458     /**
459      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
460      * with `errorMessage` as a fallback revert reason when `target` reverts.
461      *
462      * _Available since v3.1._
463      */
464     function functionCallWithValue(
465         address target,
466         bytes memory data,
467         uint256 value,
468         string memory errorMessage
469     ) internal returns (bytes memory) {
470         require(address(this).balance >= value, "Address: insufficient balance for call");
471         require(isContract(target), "Address: call to non-contract");
472 
473         (bool success, bytes memory returndata) = target.call{value: value}(data);
474         return verifyCallResult(success, returndata, errorMessage);
475     }
476 
477     /**
478      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
479      * but performing a static call.
480      *
481      * _Available since v3.3._
482      */
483     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
484         return functionStaticCall(target, data, "Address: low-level static call failed");
485     }
486 
487     /**
488      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
489      * but performing a static call.
490      *
491      * _Available since v3.3._
492      */
493     function functionStaticCall(
494         address target,
495         bytes memory data,
496         string memory errorMessage
497     ) internal view returns (bytes memory) {
498         require(isContract(target), "Address: static call to non-contract");
499 
500         (bool success, bytes memory returndata) = target.staticcall(data);
501         return verifyCallResult(success, returndata, errorMessage);
502     }
503 
504     /**
505      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
506      * but performing a delegate call.
507      *
508      * _Available since v3.4._
509      */
510     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
511         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
512     }
513 
514     /**
515      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
516      * but performing a delegate call.
517      *
518      * _Available since v3.4._
519      */
520     function functionDelegateCall(
521         address target,
522         bytes memory data,
523         string memory errorMessage
524     ) internal returns (bytes memory) {
525         require(isContract(target), "Address: delegate call to non-contract");
526 
527         (bool success, bytes memory returndata) = target.delegatecall(data);
528         return verifyCallResult(success, returndata, errorMessage);
529     }
530 
531     /**
532      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
533      * revert reason using the provided one.
534      *
535      * _Available since v4.3._
536      */
537     function verifyCallResult(
538         bool success,
539         bytes memory returndata,
540         string memory errorMessage
541     ) internal pure returns (bytes memory) {
542         if (success) {
543             return returndata;
544         } else {
545             // Look for revert reason and bubble it up if present
546             if (returndata.length > 0) {
547                 // The easiest way to bubble the revert reason is using memory via assembly
548 
549                 assembly {
550                     let returndata_size := mload(returndata)
551                     revert(add(32, returndata), returndata_size)
552                 }
553             } else {
554                 revert(errorMessage);
555             }
556         }
557     }
558 }
559 
560 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
561 
562 
563 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
564 
565 pragma solidity ^0.8.0;
566 
567 
568 
569 /**
570  * @title SafeERC20
571  * @dev Wrappers around ERC20 operations that throw on failure (when the token
572  * contract returns false). Tokens that return no value (and instead revert or
573  * throw on failure) are also supported, non-reverting calls are assumed to be
574  * successful.
575  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
576  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
577  */
578 library SafeERC20 {
579     using Address for address;
580 
581     function safeTransfer(
582         IERC20 token,
583         address to,
584         uint256 value
585     ) internal {
586         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
587     }
588 
589     function safeTransferFrom(
590         IERC20 token,
591         address from,
592         address to,
593         uint256 value
594     ) internal {
595         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
596     }
597 
598     /**
599      * @dev Deprecated. This function has issues similar to the ones found in
600      * {IERC20-approve}, and its usage is discouraged.
601      *
602      * Whenever possible, use {safeIncreaseAllowance} and
603      * {safeDecreaseAllowance} instead.
604      */
605     function safeApprove(
606         IERC20 token,
607         address spender,
608         uint256 value
609     ) internal {
610         // safeApprove should only be called when setting an initial allowance,
611         // or when resetting it to zero. To increase and decrease it, use
612         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
613         require(
614             (value == 0) || (token.allowance(address(this), spender) == 0),
615             "SafeERC20: approve from non-zero to non-zero allowance"
616         );
617         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
618     }
619 
620     function safeIncreaseAllowance(
621         IERC20 token,
622         address spender,
623         uint256 value
624     ) internal {
625         uint256 newAllowance = token.allowance(address(this), spender) + value;
626         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
627     }
628 
629     function safeDecreaseAllowance(
630         IERC20 token,
631         address spender,
632         uint256 value
633     ) internal {
634         unchecked {
635             uint256 oldAllowance = token.allowance(address(this), spender);
636             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
637             uint256 newAllowance = oldAllowance - value;
638             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
639         }
640     }
641 
642     /**
643      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
644      * on the return value: the return value is optional (but if data is returned, it must not be false).
645      * @param token The token targeted by the call.
646      * @param data The call data (encoded using abi.encode or one of its variants).
647      */
648     function _callOptionalReturn(IERC20 token, bytes memory data) private {
649         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
650         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
651         // the target address contains contract code and also asserts for success in the low-level call.
652 
653         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
654         if (returndata.length > 0) {
655             // Return data is optional
656             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
657         }
658     }
659 }
660 
661 
662 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
663 
664 
665 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
666 
667 pragma solidity ^0.8.0;
668 
669 /**
670  * @title ERC721 token receiver interface
671  * @dev Interface for any contract that wants to support safeTransfers
672  * from ERC721 asset contracts.
673  */
674 interface IERC721Receiver {
675     /**
676      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
677      * by `operator` from `from`, this function is called.
678      *
679      * It must return its Solidity selector to confirm the token transfer.
680      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
681      *
682      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
683      */
684     function onERC721Received(
685         address operator,
686         address from,
687         uint256 tokenId,
688         bytes calldata data
689     ) external returns (bytes4);
690 }
691 
692 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
693 
694 
695 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
696 
697 pragma solidity ^0.8.0;
698 
699 /**
700  * @dev Interface of the ERC165 standard, as defined in the
701  * https://eips.ethereum.org/EIPS/eip-165[EIP].
702  *
703  * Implementers can declare support of contract interfaces, which can then be
704  * queried by others ({ERC165Checker}).
705  *
706  * For an implementation, see {ERC165}.
707  */
708 interface IERC165 {
709     /**
710      * @dev Returns true if this contract implements the interface defined by
711      * `interfaceId`. See the corresponding
712      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
713      * to learn more about how these ids are created.
714      *
715      * This function call must use less than 30 000 gas.
716      */
717     function supportsInterface(bytes4 interfaceId) external view returns (bool);
718 }
719 
720 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
721 
722 
723 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
724 
725 pragma solidity ^0.8.0;
726 
727 
728 /**
729  * @dev Implementation of the {IERC165} interface.
730  *
731  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
732  * for the additional interface id that will be supported. For example:
733  *
734  * ```solidity
735  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
736  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
737  * }
738  * ```
739  *
740  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
741  */
742 abstract contract ERC165 is IERC165 {
743     /**
744      * @dev See {IERC165-supportsInterface}.
745      */
746     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
747         return interfaceId == type(IERC165).interfaceId;
748     }
749 }
750 
751 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
752 
753 
754 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
755 
756 pragma solidity ^0.8.0;
757 
758 
759 /**
760  * @dev Required interface of an ERC721 compliant contract.
761  */
762 interface IERC721 is IERC165 {
763     /**
764      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
765      */
766     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
767 
768     /**
769      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
770      */
771     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
772 
773     /**
774      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
775      */
776     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
777 
778     /**
779      * @dev Returns the number of tokens in ``owner``'s account.
780      */
781     function balanceOf(address owner) external view returns (uint256 balance);
782 
783     /**
784      * @dev Returns the owner of the `tokenId` token.
785      *
786      * Requirements:
787      *
788      * - `tokenId` must exist.
789      */
790     function ownerOf(uint256 tokenId) external view returns (address owner);
791 
792     /**
793      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
794      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
795      *
796      * Requirements:
797      *
798      * - `from` cannot be the zero address.
799      * - `to` cannot be the zero address.
800      * - `tokenId` token must exist and be owned by `from`.
801      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
802      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
803      *
804      * Emits a {Transfer} event.
805      */
806     function safeTransferFrom(
807         address from,
808         address to,
809         uint256 tokenId
810     ) external;
811 
812     /**
813      * @dev Transfers `tokenId` token from `from` to `to`.
814      *
815      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
816      *
817      * Requirements:
818      *
819      * - `from` cannot be the zero address.
820      * - `to` cannot be the zero address.
821      * - `tokenId` token must be owned by `from`.
822      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
823      *
824      * Emits a {Transfer} event.
825      */
826     function transferFrom(
827         address from,
828         address to,
829         uint256 tokenId
830     ) external;
831 
832     /**
833      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
834      * The approval is cleared when the token is transferred.
835      *
836      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
837      *
838      * Requirements:
839      *
840      * - The caller must own the token or be an approved operator.
841      * - `tokenId` must exist.
842      *
843      * Emits an {Approval} event.
844      */
845     function approve(address to, uint256 tokenId) external;
846 
847     /**
848      * @dev Returns the account approved for `tokenId` token.
849      *
850      * Requirements:
851      *
852      * - `tokenId` must exist.
853      */
854     function getApproved(uint256 tokenId) external view returns (address operator);
855 
856     /**
857      * @dev Approve or remove `operator` as an operator for the caller.
858      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
859      *
860      * Requirements:
861      *
862      * - The `operator` cannot be the caller.
863      *
864      * Emits an {ApprovalForAll} event.
865      */
866     function setApprovalForAll(address operator, bool _approved) external;
867 
868     /**
869      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
870      *
871      * See {setApprovalForAll}
872      */
873     function isApprovedForAll(address owner, address operator) external view returns (bool);
874 
875     /**
876      * @dev Safely transfers `tokenId` token from `from` to `to`.
877      *
878      * Requirements:
879      *
880      * - `from` cannot be the zero address.
881      * - `to` cannot be the zero address.
882      * - `tokenId` token must exist and be owned by `from`.
883      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
884      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
885      *
886      * Emits a {Transfer} event.
887      */
888     function safeTransferFrom(
889         address from,
890         address to,
891         uint256 tokenId,
892         bytes calldata data
893     ) external;
894 }
895 
896 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
897 
898 
899 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
900 
901 pragma solidity ^0.8.0;
902 
903 
904 /**
905  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
906  * @dev See https://eips.ethereum.org/EIPS/eip-721
907  */
908 interface IERC721Enumerable is IERC721 {
909     /**
910      * @dev Returns the total amount of tokens stored by the contract.
911      */
912     function totalSupply() external view returns (uint256);
913 
914     /**
915      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
916      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
917      */
918     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
919 
920     /**
921      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
922      * Use along with {totalSupply} to enumerate all tokens.
923      */
924     function tokenByIndex(uint256 index) external view returns (uint256);
925 }
926 
927 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
928 
929 
930 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
931 
932 pragma solidity ^0.8.0;
933 
934 
935 /**
936  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
937  * @dev See https://eips.ethereum.org/EIPS/eip-721
938  */
939 interface IERC721Metadata is IERC721 {
940     /**
941      * @dev Returns the token collection name.
942      */
943     function name() external view returns (string memory);
944 
945     /**
946      * @dev Returns the token collection symbol.
947      */
948     function symbol() external view returns (string memory);
949 
950     /**
951      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
952      */
953     function tokenURI(uint256 tokenId) external view returns (string memory);
954 }
955 
956 // File: contracts/TwistedToonz.sol
957 
958 
959 // Creator: Chiru Labs
960 
961 pragma solidity ^0.8.0;
962 
963 
964 
965 
966 
967 
968 
969 
970 
971 /**
972  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
973  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
974  *
975  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
976  *
977  * Does not support burning tokens to address(0).
978  *
979  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
980  */
981 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
982     using Address for address;
983     using Strings for uint256;
984 
985     struct TokenOwnership {
986         address addr;
987         uint64 startTimestamp;
988     }
989 
990     struct AddressData {
991         uint128 balance;
992         uint128 numberMinted;
993     }
994 
995     uint256 internal currentIndex;
996 
997     // Token name
998     string private _name;
999 
1000     // Token symbol
1001     string private _symbol;
1002 
1003     // Mapping from token ID to ownership details
1004     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1005     mapping(uint256 => TokenOwnership) internal _ownerships;
1006 
1007     // Mapping owner address to address data
1008     mapping(address => AddressData) private _addressData;
1009 
1010     // Mapping from token ID to approved address
1011     mapping(uint256 => address) private _tokenApprovals;
1012 
1013     // Mapping from owner to operator approvals
1014     mapping(address => mapping(address => bool)) private _operatorApprovals;
1015 
1016     constructor(string memory name_, string memory symbol_) {
1017         _name = name_;
1018         _symbol = symbol_;
1019     }
1020 
1021     /**
1022      * @dev See {IERC721Enumerable-totalSupply}.
1023      */
1024     function totalSupply() public view override returns (uint256) {
1025         return currentIndex;
1026     }
1027 
1028     /**
1029      * @dev See {IERC721Enumerable-tokenByIndex}.
1030      */
1031     function tokenByIndex(uint256 index) public view override returns (uint256) {
1032         require(index < totalSupply(), "ERC721A: global index out of bounds");
1033         return index;
1034     }
1035 
1036     /**
1037      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1038      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1039      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1040      */
1041     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1042         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1043         uint256 numMintedSoFar = totalSupply();
1044         uint256 tokenIdsIdx;
1045         address currOwnershipAddr;
1046 
1047         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1048         unchecked {
1049             for (uint256 i; i < numMintedSoFar; i++) {
1050                 TokenOwnership memory ownership = _ownerships[i];
1051                 if (ownership.addr != address(0)) {
1052                     currOwnershipAddr = ownership.addr;
1053                 }
1054                 if (currOwnershipAddr == owner) {
1055                     if (tokenIdsIdx == index) {
1056                         return i;
1057                     }
1058                     tokenIdsIdx++;
1059                 }
1060             }
1061         }
1062 
1063         revert("ERC721A: unable to get token of owner by index");
1064     }
1065 
1066     /**
1067      * @dev See {IERC165-supportsInterface}.
1068      */
1069     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1070         return
1071             interfaceId == type(IERC721).interfaceId ||
1072             interfaceId == type(IERC721Metadata).interfaceId ||
1073             interfaceId == type(IERC721Enumerable).interfaceId ||
1074             super.supportsInterface(interfaceId);
1075     }
1076 
1077     /**
1078      * @dev See {IERC721-balanceOf}.
1079      */
1080     function balanceOf(address owner) public view override returns (uint256) {
1081         require(owner != address(0), "ERC721A: balance query for the zero address");
1082         return uint256(_addressData[owner].balance);
1083     }
1084 
1085     function _numberMinted(address owner) internal view returns (uint256) {
1086         require(owner != address(0), "ERC721A: number minted query for the zero address");
1087         return uint256(_addressData[owner].numberMinted);
1088     }
1089 
1090     /**
1091      * Gas spent here starts off proportional to the maximum mint batch size.
1092      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1093      */
1094     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1095         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1096 
1097         unchecked {
1098             for (uint256 curr = tokenId; curr >= 0; curr--) {
1099                 TokenOwnership memory ownership = _ownerships[curr];
1100                 if (ownership.addr != address(0)) {
1101                     return ownership;
1102                 }
1103             }
1104         }
1105 
1106         revert("ERC721A: unable to determine the owner of token");
1107     }
1108 
1109     /**
1110      * @dev See {IERC721-ownerOf}.
1111      */
1112     function ownerOf(uint256 tokenId) public view override returns (address) {
1113         return ownershipOf(tokenId).addr;
1114     }
1115 
1116     /**
1117      * @dev See {IERC721Metadata-name}.
1118      */
1119     function name() public view virtual override returns (string memory) {
1120         return _name;
1121     }
1122 
1123     /**
1124      * @dev See {IERC721Metadata-symbol}.
1125      */
1126     function symbol() public view virtual override returns (string memory) {
1127         return _symbol;
1128     }
1129 
1130     /**
1131      * @dev See {IERC721Metadata-tokenURI}.
1132      */
1133     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1134         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1135 
1136         string memory baseURI = _baseURI();
1137         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1138     }
1139 
1140     /**
1141      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1142      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1143      * by default, can be overriden in child contracts.
1144      */
1145     function _baseURI() internal view virtual returns (string memory) {
1146         return "";
1147     }
1148 
1149     /**
1150      * @dev See {IERC721-approve}.
1151      */
1152     function approve(address to, uint256 tokenId) public override {
1153         address owner = ERC721A.ownerOf(tokenId);
1154         require(to != owner, "ERC721A: approval to current owner");
1155 
1156         require(
1157             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1158             "ERC721A: approve caller is not owner nor approved for all"
1159         );
1160 
1161         _approve(to, tokenId, owner);
1162     }
1163 
1164     /**
1165      * @dev See {IERC721-getApproved}.
1166      */
1167     function getApproved(uint256 tokenId) public view override returns (address) {
1168         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1169 
1170         return _tokenApprovals[tokenId];
1171     }
1172 
1173     /**
1174      * @dev See {IERC721-setApprovalForAll}.
1175      */
1176     function setApprovalForAll(address operator, bool approved) public override {
1177         require(operator != _msgSender(), "ERC721A: approve to caller");
1178 
1179         _operatorApprovals[_msgSender()][operator] = approved;
1180         emit ApprovalForAll(_msgSender(), operator, approved);
1181     }
1182 
1183     /**
1184      * @dev See {IERC721-isApprovedForAll}.
1185      */
1186     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1187         return _operatorApprovals[owner][operator];
1188     }
1189 
1190     /**
1191      * @dev See {IERC721-transferFrom}.
1192      */
1193     function transferFrom(
1194         address from,
1195         address to,
1196         uint256 tokenId
1197     ) public virtual override {
1198         _transfer(from, to, tokenId);
1199     }
1200 
1201     /**
1202      * @dev See {IERC721-safeTransferFrom}.
1203      */
1204     function safeTransferFrom(
1205         address from,
1206         address to,
1207         uint256 tokenId
1208     ) public virtual override {
1209         safeTransferFrom(from, to, tokenId, "");
1210     }
1211 
1212     /**
1213      * @dev See {IERC721-safeTransferFrom}.
1214      */
1215     function safeTransferFrom(
1216         address from,
1217         address to,
1218         uint256 tokenId,
1219         bytes memory _data
1220     ) public override {
1221         _transfer(from, to, tokenId);
1222         require(
1223             _checkOnERC721Received(from, to, tokenId, _data),
1224             "ERC721A: transfer to non ERC721Receiver implementer"
1225         );
1226     }
1227 
1228     /**
1229      * @dev Returns whether `tokenId` exists.
1230      *
1231      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1232      *
1233      * Tokens start existing when they are minted (`_mint`),
1234      */
1235     function _exists(uint256 tokenId) internal view returns (bool) {
1236         return tokenId < currentIndex;
1237     }
1238 
1239     function _safeMint(address to, uint256 quantity) internal {
1240         _safeMint(to, quantity, "");
1241     }
1242 
1243     /**
1244      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1245      *
1246      * Requirements:
1247      *
1248      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1249      * - `quantity` must be greater than 0.
1250      *
1251      * Emits a {Transfer} event.
1252      */
1253     function _safeMint(
1254         address to,
1255         uint256 quantity,
1256         bytes memory _data
1257     ) internal {
1258         _mint(to, quantity, _data, true);
1259     }
1260 
1261     /**
1262      * @dev Mints `quantity` tokens and transfers them to `to`.
1263      *
1264      * Requirements:
1265      *
1266      * - `to` cannot be the zero address.
1267      * - `quantity` must be greater than 0.
1268      *
1269      * Emits a {Transfer} event.
1270      */
1271     function _mint(
1272         address to,
1273         uint256 quantity,
1274         bytes memory _data,
1275         bool safe
1276     ) internal {
1277         uint256 startTokenId = currentIndex;
1278         require(to != address(0), "ERC721A: mint to the zero address");
1279         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1280 
1281         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1282 
1283         // Overflows are incredibly unrealistic.
1284         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1285         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1286         unchecked {
1287             _addressData[to].balance += uint128(quantity);
1288             _addressData[to].numberMinted += uint128(quantity);
1289 
1290             _ownerships[startTokenId].addr = to;
1291             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1292 
1293             uint256 updatedIndex = startTokenId;
1294 
1295             for (uint256 i; i < quantity; i++) {
1296                 emit Transfer(address(0), to, updatedIndex);
1297                 if (safe) {
1298                     require(
1299                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1300                         "ERC721A: transfer to non ERC721Receiver implementer"
1301                     );
1302                 }
1303 
1304                 updatedIndex++;
1305             }
1306 
1307             currentIndex = updatedIndex;
1308         }
1309 
1310         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1311     }
1312 
1313     /**
1314      * @dev Transfers `tokenId` from `from` to `to`.
1315      *
1316      * Requirements:
1317      *
1318      * - `to` cannot be the zero address.
1319      * - `tokenId` token must be owned by `from`.
1320      *
1321      * Emits a {Transfer} event.
1322      */
1323     function _transfer(
1324         address from,
1325         address to,
1326         uint256 tokenId
1327     ) private {
1328         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1329 
1330         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1331             getApproved(tokenId) == _msgSender() ||
1332             isApprovedForAll(prevOwnership.addr, _msgSender()));
1333 
1334         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1335 
1336         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1337         require(to != address(0), "ERC721A: transfer to the zero address");
1338 
1339         _beforeTokenTransfers(from, to, tokenId, 1);
1340 
1341         // Clear approvals from the previous owner
1342         _approve(address(0), tokenId, prevOwnership.addr);
1343 
1344         // Underflow of the sender's balance is impossible because we check for
1345         // ownership above and the recipient's balance can't realistically overflow.
1346         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1347         unchecked {
1348             _addressData[from].balance -= 1;
1349             _addressData[to].balance += 1;
1350 
1351             _ownerships[tokenId].addr = to;
1352             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1353 
1354             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1355             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1356             uint256 nextTokenId = tokenId + 1;
1357             if (_ownerships[nextTokenId].addr == address(0)) {
1358                 if (_exists(nextTokenId)) {
1359                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1360                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1361                 }
1362             }
1363         }
1364 
1365         emit Transfer(from, to, tokenId);
1366         _afterTokenTransfers(from, to, tokenId, 1);
1367     }
1368 
1369     /**
1370      * @dev Approve `to` to operate on `tokenId`
1371      *
1372      * Emits a {Approval} event.
1373      */
1374     function _approve(
1375         address to,
1376         uint256 tokenId,
1377         address owner
1378     ) private {
1379         _tokenApprovals[tokenId] = to;
1380         emit Approval(owner, to, tokenId);
1381     }
1382 
1383     /**
1384      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1385      * The call is not executed if the target address is not a contract.
1386      *
1387      * @param from address representing the previous owner of the given token ID
1388      * @param to target address that will receive the tokens
1389      * @param tokenId uint256 ID of the token to be transferred
1390      * @param _data bytes optional data to send along with the call
1391      * @return bool whether the call correctly returned the expected magic value
1392      */
1393     function _checkOnERC721Received(
1394         address from,
1395         address to,
1396         uint256 tokenId,
1397         bytes memory _data
1398     ) private returns (bool) {
1399         if (to.isContract()) {
1400             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1401                 return retval == IERC721Receiver(to).onERC721Received.selector;
1402             } catch (bytes memory reason) {
1403                 if (reason.length == 0) {
1404                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1405                 } else {
1406                     assembly {
1407                         revert(add(32, reason), mload(reason))
1408                     }
1409                 }
1410             }
1411         } else {
1412             return true;
1413         }
1414     }
1415 
1416     /**
1417      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1418      *
1419      * startTokenId - the first token id to be transferred
1420      * quantity - the amount to be transferred
1421      *
1422      * Calling conditions:
1423      *
1424      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1425      * transferred to `to`.
1426      * - When `from` is zero, `tokenId` will be minted for `to`.
1427      */
1428     function _beforeTokenTransfers(
1429         address from,
1430         address to,
1431         uint256 startTokenId,
1432         uint256 quantity
1433     ) internal virtual {}
1434 
1435     /**
1436      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1437      * minting.
1438      *
1439      * startTokenId - the first token id to be transferred
1440      * quantity - the amount to be transferred
1441      *
1442      * Calling conditions:
1443      *
1444      * - when `from` and `to` are both non-zero.
1445      * - `from` and `to` are never both zero.
1446      */
1447     function _afterTokenTransfers(
1448         address from,
1449         address to,
1450         uint256 startTokenId,
1451         uint256 quantity
1452     ) internal virtual {}
1453 }
1454 
1455 contract WorldCupApesYC is ERC721A, Ownable, ReentrancyGuard {
1456 
1457   string public        baseURI;
1458   uint public          price             = 0.003 ether;
1459   uint public          maxPerTx          = 1;
1460   uint public          maxPerWallet      = 10;
1461   uint public          totalFree         = 500;
1462   uint public          maxSupply         = 10000;
1463   uint public          nextOwnerToExplicitlySet;
1464   bool public          mintEnabled;
1465 
1466   constructor() ERC721A("World Cup Apes YC", "WCAYC"){}
1467 
1468   function mint(uint256 amt) external payable
1469   {
1470     uint cost = price;
1471     if(totalSupply() + amt < totalFree + 1) {
1472       cost = 0;
1473     }
1474 
1475     require(msg.value == amt * cost,"Please send the exact amount.");
1476     require(msg.sender == tx.origin,"Be yourself.");
1477     require(totalSupply() + amt < maxSupply + 1,"No more  World Cup Apes");
1478     require(mintEnabled, "Minting is not live yet, hold on World Cup Ape.");
1479     require(numberMinted(msg.sender) + amt <= maxPerWallet,"Too many per wallet!");
1480     require( amt < maxPerTx + 1, "Max per TX reached.");
1481 
1482     _safeMint(msg.sender, amt);
1483   }
1484 
1485   function ownerBatchMint(uint256 amt) external onlyOwner
1486   {
1487     require(totalSupply() + amt < maxSupply + 1,"too many!");
1488 
1489     _safeMint(msg.sender, amt);
1490   }
1491 
1492   function toggleMinting() external onlyOwner {
1493       mintEnabled = !mintEnabled;
1494   }
1495 
1496   function numberMinted(address owner) public view returns (uint256) {
1497     return _numberMinted(owner);
1498   }
1499 
1500   function setBaseURI(string calldata baseURI_) external onlyOwner {
1501     baseURI = baseURI_;
1502   }
1503 
1504   function setPrice(uint256 price_) external onlyOwner {
1505       price = price_;
1506   }
1507 
1508   function setTotalFree(uint256 totalFree_) external onlyOwner {
1509       totalFree = totalFree_;
1510   }
1511 
1512   function setMaxPerTx(uint256 maxPerTx_) external onlyOwner {
1513       maxPerTx = maxPerTx_;
1514   }
1515 
1516   function setMaxPerWallet(uint256 maxPerWallet_) external onlyOwner {
1517       maxPerWallet = maxPerWallet_;
1518   }
1519 
1520   function setmaxSupply(uint256 maxSupply_) external onlyOwner {
1521       maxSupply = maxSupply_;
1522   }
1523 
1524   function _baseURI() internal view virtual override returns (string memory) {
1525     return baseURI;
1526   }
1527 
1528   function withdraw() external onlyOwner nonReentrant {
1529     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1530     require(success, "Transfer failed.");
1531   }
1532 
1533   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1534     _setOwnersExplicit(quantity);
1535   }
1536 
1537   function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory)
1538   {
1539     return ownershipOf(tokenId);
1540   }
1541 
1542 
1543   /**
1544     * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1545     */
1546   function _setOwnersExplicit(uint256 quantity) internal {
1547       require(quantity != 0, "quantity must be nonzero");
1548       require(currentIndex != 0, "no tokens minted yet");
1549       uint256 _nextOwnerToExplicitlySet = nextOwnerToExplicitlySet;
1550       require(_nextOwnerToExplicitlySet < currentIndex, "all ownerships have been set");
1551 
1552       // Index underflow is impossible.
1553       // Counter or index overflow is incredibly unrealistic.
1554       unchecked {
1555           uint256 endIndex = _nextOwnerToExplicitlySet + quantity - 1;
1556 
1557           // Set the end index to be the last token index
1558           if (endIndex + 1 > currentIndex) {
1559               endIndex = currentIndex - 1;
1560           }
1561 
1562           for (uint256 i = _nextOwnerToExplicitlySet; i <= endIndex; i++) {
1563               if (_ownerships[i].addr == address(0)) {
1564                   TokenOwnership memory ownership = ownershipOf(i);
1565                   _ownerships[i].addr = ownership.addr;
1566                   _ownerships[i].startTimestamp = ownership.startTimestamp;
1567               }
1568           }
1569 
1570           nextOwnerToExplicitlySet = endIndex + 1;
1571       }
1572   }
1573 }