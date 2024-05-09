1 // File: contracts/TrippiestApeTribe.sol
2 
3 
4 
5 /**
6  * @title TrippiestApeTribe contract
7 */
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
340 pragma solidity ^0.8.0;
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
956 
957 pragma solidity ^0.8.0;
958 
959 
960 /**
961  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
962  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
963  *
964  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
965  *
966  * Does not support burning tokens to address(0).
967  *
968  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
969  */
970 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
971     using Address for address;
972     using Strings for uint256;
973 
974     struct TokenOwnership {
975         address addr;
976         uint64 startTimestamp;
977     }
978 
979     struct AddressData {
980         uint128 balance;
981         uint128 numberMinted;
982     }
983 
984     uint256 internal currentIndex;
985 
986     // Token name
987     string private _name;
988 
989     // Token symbol
990     string private _symbol;
991 
992     // Mapping from token ID to ownership details
993     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
994     mapping(uint256 => TokenOwnership) internal _ownerships;
995 
996     // Mapping owner address to address data
997     mapping(address => AddressData) private _addressData;
998 
999     // Mapping from token ID to approved address
1000     mapping(uint256 => address) private _tokenApprovals;
1001 
1002     // Mapping from owner to operator approvals
1003     mapping(address => mapping(address => bool)) private _operatorApprovals;
1004 
1005     constructor(string memory name_, string memory symbol_) {
1006         _name = name_;
1007         _symbol = symbol_;
1008     }
1009 
1010     /**
1011      * @dev See {IERC721Enumerable-totalSupply}.
1012      */
1013     function totalSupply() public view override returns (uint256) {
1014         return currentIndex;
1015     }
1016 
1017     /**
1018      * @dev See {IERC721Enumerable-tokenByIndex}.
1019      */
1020     function tokenByIndex(uint256 index) public view override returns (uint256) {
1021         require(index < totalSupply(), "ERC721A: global index out of bounds");
1022         return index;
1023     }
1024 
1025     /**
1026      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1027      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1028      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1029      */
1030     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1031         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1032         uint256 numMintedSoFar = totalSupply();
1033         uint256 tokenIdsIdx;
1034         address currOwnershipAddr;
1035 
1036         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1037         unchecked {
1038             for (uint256 i; i < numMintedSoFar; i++) {
1039                 TokenOwnership memory ownership = _ownerships[i];
1040                 if (ownership.addr != address(0)) {
1041                     currOwnershipAddr = ownership.addr;
1042                 }
1043                 if (currOwnershipAddr == owner) {
1044                     if (tokenIdsIdx == index) {
1045                         return i;
1046                     }
1047                     tokenIdsIdx++;
1048                 }
1049             }
1050         }
1051 
1052         revert("ERC721A: unable to get token of owner by index");
1053     }
1054 
1055     /**
1056      * @dev See {IERC165-supportsInterface}.
1057      */
1058     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1059         return
1060             interfaceId == type(IERC721).interfaceId ||
1061             interfaceId == type(IERC721Metadata).interfaceId ||
1062             interfaceId == type(IERC721Enumerable).interfaceId ||
1063             super.supportsInterface(interfaceId);
1064     }
1065 
1066     /**
1067      * @dev See {IERC721-balanceOf}.
1068      */
1069     function balanceOf(address owner) public view override returns (uint256) {
1070         require(owner != address(0), "ERC721A: balance query for the zero address");
1071         return uint256(_addressData[owner].balance);
1072     }
1073 
1074     function _numberMinted(address owner) internal view returns (uint256) {
1075         require(owner != address(0), "ERC721A: number minted query for the zero address");
1076         return uint256(_addressData[owner].numberMinted);
1077     }
1078 
1079     /**
1080      * Gas spent here starts off proportional to the maximum mint batch size.
1081      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1082      */
1083     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1084         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1085 
1086         unchecked {
1087             for (uint256 curr = tokenId; curr >= 0; curr--) {
1088                 TokenOwnership memory ownership = _ownerships[curr];
1089                 if (ownership.addr != address(0)) {
1090                     return ownership;
1091                 }
1092             }
1093         }
1094 
1095         revert("ERC721A: unable to determine the owner of token");
1096     }
1097 
1098     /**
1099      * @dev See {IERC721-ownerOf}.
1100      */
1101     function ownerOf(uint256 tokenId) public view override returns (address) {
1102         return ownershipOf(tokenId).addr;
1103     }
1104 
1105     /**
1106      * @dev See {IERC721Metadata-name}.
1107      */
1108     function name() public view virtual override returns (string memory) {
1109         return _name;
1110     }
1111 
1112     /**
1113      * @dev See {IERC721Metadata-symbol}.
1114      */
1115     function symbol() public view virtual override returns (string memory) {
1116         return _symbol;
1117     }
1118 
1119     /**
1120      * @dev See {IERC721Metadata-tokenURI}.
1121      */
1122     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1123         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1124 
1125         string memory baseURI = _baseURI();
1126         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1127     }
1128 
1129     /**
1130      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1131      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1132      * by default, can be overriden in child contracts.
1133      */
1134     function _baseURI() internal view virtual returns (string memory) {
1135         return "";
1136     }
1137 
1138     /**
1139      * @dev See {IERC721-approve}.
1140      */
1141     function approve(address to, uint256 tokenId) public override {
1142         address owner = ERC721A.ownerOf(tokenId);
1143         require(to != owner, "ERC721A: approval to current owner");
1144 
1145         require(
1146             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1147             "ERC721A: approve caller is not owner nor approved for all"
1148         );
1149 
1150         _approve(to, tokenId, owner);
1151     }
1152 
1153     /**
1154      * @dev See {IERC721-getApproved}.
1155      */
1156     function getApproved(uint256 tokenId) public view override returns (address) {
1157         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1158 
1159         return _tokenApprovals[tokenId];
1160     }
1161 
1162     /**
1163      * @dev See {IERC721-setApprovalForAll}.
1164      */
1165     function setApprovalForAll(address operator, bool approved) public override {
1166         require(operator != _msgSender(), "ERC721A: approve to caller");
1167 
1168         _operatorApprovals[_msgSender()][operator] = approved;
1169         emit ApprovalForAll(_msgSender(), operator, approved);
1170     }
1171 
1172     /**
1173      * @dev See {IERC721-isApprovedForAll}.
1174      */
1175     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1176         return _operatorApprovals[owner][operator];
1177     }
1178 
1179     /**
1180      * @dev See {IERC721-transferFrom}.
1181      */
1182     function transferFrom(
1183         address from,
1184         address to,
1185         uint256 tokenId
1186     ) public virtual override {
1187         _transfer(from, to, tokenId);
1188     }
1189 
1190     /**
1191      * @dev See {IERC721-safeTransferFrom}.
1192      */
1193     function safeTransferFrom(
1194         address from,
1195         address to,
1196         uint256 tokenId
1197     ) public virtual override {
1198         safeTransferFrom(from, to, tokenId, "");
1199     }
1200 
1201     /**
1202      * @dev See {IERC721-safeTransferFrom}.
1203      */
1204     function safeTransferFrom(
1205         address from,
1206         address to,
1207         uint256 tokenId,
1208         bytes memory _data
1209     ) public override {
1210         _transfer(from, to, tokenId);
1211         require(
1212             _checkOnERC721Received(from, to, tokenId, _data),
1213             "ERC721A: transfer to non ERC721Receiver implementer"
1214         );
1215     }
1216 
1217     /**
1218      * @dev Returns whether `tokenId` exists.
1219      *
1220      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1221      *
1222      * Tokens start existing when they are minted (`_mint`),
1223      */
1224     function _exists(uint256 tokenId) internal view returns (bool) {
1225         return tokenId < currentIndex;
1226     }
1227 
1228     function _safeMint(address to, uint256 quantity) internal {
1229         _safeMint(to, quantity, "");
1230     }
1231 
1232     /**
1233      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1234      *
1235      * Requirements:
1236      *
1237      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1238      * - `quantity` must be greater than 0.
1239      *
1240      * Emits a {Transfer} event.
1241      */
1242     function _safeMint(
1243         address to,
1244         uint256 quantity,
1245         bytes memory _data
1246     ) internal {
1247         _mint(to, quantity, _data, true);
1248     }
1249 
1250     /**
1251      * @dev Mints `quantity` tokens and transfers them to `to`.
1252      *
1253      * Requirements:
1254      *
1255      * - `to` cannot be the zero address.
1256      * - `quantity` must be greater than 0.
1257      *
1258      * Emits a {Transfer} event.
1259      */
1260     function _mint(
1261         address to,
1262         uint256 quantity,
1263         bytes memory _data,
1264         bool safe
1265     ) internal {
1266         uint256 startTokenId = currentIndex;
1267         require(to != address(0), "ERC721A: mint to the zero address");
1268         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1269 
1270         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1271 
1272         // Overflows are incredibly unrealistic.
1273         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1274         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1275         unchecked {
1276             _addressData[to].balance += uint128(quantity);
1277             _addressData[to].numberMinted += uint128(quantity);
1278 
1279             _ownerships[startTokenId].addr = to;
1280             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1281 
1282             uint256 updatedIndex = startTokenId;
1283 
1284             for (uint256 i; i < quantity; i++) {
1285                 emit Transfer(address(0), to, updatedIndex);
1286                 if (safe) {
1287                     require(
1288                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1289                         "ERC721A: transfer to non ERC721Receiver implementer"
1290                     );
1291                 }
1292 
1293                 updatedIndex++;
1294             }
1295 
1296             currentIndex = updatedIndex;
1297         }
1298 
1299         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1300     }
1301 
1302     /**
1303      * @dev Transfers `tokenId` from `from` to `to`.
1304      *
1305      * Requirements:
1306      *
1307      * - `to` cannot be the zero address.
1308      * - `tokenId` token must be owned by `from`.
1309      *
1310      * Emits a {Transfer} event.
1311      */
1312     function _transfer(
1313         address from,
1314         address to,
1315         uint256 tokenId
1316     ) private {
1317         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1318 
1319         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1320             getApproved(tokenId) == _msgSender() ||
1321             isApprovedForAll(prevOwnership.addr, _msgSender()));
1322 
1323         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1324 
1325         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1326         require(to != address(0), "ERC721A: transfer to the zero address");
1327 
1328         _beforeTokenTransfers(from, to, tokenId, 1);
1329 
1330         // Clear approvals from the previous owner
1331         _approve(address(0), tokenId, prevOwnership.addr);
1332 
1333         // Underflow of the sender's balance is impossible because we check for
1334         // ownership above and the recipient's balance can't realistically overflow.
1335         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1336         unchecked {
1337             _addressData[from].balance -= 1;
1338             _addressData[to].balance += 1;
1339 
1340             _ownerships[tokenId].addr = to;
1341             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1342 
1343             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1344             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1345             uint256 nextTokenId = tokenId + 1;
1346             if (_ownerships[nextTokenId].addr == address(0)) {
1347                 if (_exists(nextTokenId)) {
1348                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1349                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1350                 }
1351             }
1352         }
1353 
1354         emit Transfer(from, to, tokenId);
1355         _afterTokenTransfers(from, to, tokenId, 1);
1356     }
1357 
1358     /**
1359      * @dev Approve `to` to operate on `tokenId`
1360      *
1361      * Emits a {Approval} event.
1362      */
1363     function _approve(
1364         address to,
1365         uint256 tokenId,
1366         address owner
1367     ) private {
1368         _tokenApprovals[tokenId] = to;
1369         emit Approval(owner, to, tokenId);
1370     }
1371 
1372     /**
1373      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1374      * The call is not executed if the target address is not a contract.
1375      *
1376      * @param from address representing the previous owner of the given token ID
1377      * @param to target address that will receive the tokens
1378      * @param tokenId uint256 ID of the token to be transferred
1379      * @param _data bytes optional data to send along with the call
1380      * @return bool whether the call correctly returned the expected magic value
1381      */
1382     function _checkOnERC721Received(
1383         address from,
1384         address to,
1385         uint256 tokenId,
1386         bytes memory _data
1387     ) private returns (bool) {
1388         if (to.isContract()) {
1389             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1390                 return retval == IERC721Receiver(to).onERC721Received.selector;
1391             } catch (bytes memory reason) {
1392                 if (reason.length == 0) {
1393                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1394                 } else {
1395                     assembly {
1396                         revert(add(32, reason), mload(reason))
1397                     }
1398                 }
1399             }
1400         } else {
1401             return true;
1402         }
1403     }
1404 
1405     /**
1406      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1407      *
1408      * startTokenId - the first token id to be transferred
1409      * quantity - the amount to be transferred
1410      *
1411      * Calling conditions:
1412      *
1413      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1414      * transferred to `to`.
1415      * - When `from` is zero, `tokenId` will be minted for `to`.
1416      */
1417     function _beforeTokenTransfers(
1418         address from,
1419         address to,
1420         uint256 startTokenId,
1421         uint256 quantity
1422     ) internal virtual {}
1423 
1424     /**
1425      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1426      * minting.
1427      *
1428      * startTokenId - the first token id to be transferred
1429      * quantity - the amount to be transferred
1430      *
1431      * Calling conditions:
1432      *
1433      * - when `from` and `to` are both non-zero.
1434      * - `from` and `to` are never both zero.
1435      */
1436     function _afterTokenTransfers(
1437         address from,
1438         address to,
1439         uint256 startTokenId,
1440         uint256 quantity
1441     ) internal virtual {}
1442 }
1443 
1444 contract TrippiestApeTribe is ERC721A, Ownable, ReentrancyGuard {
1445 
1446   string public        baseURI;
1447   uint public          price             = 0.0069 ether;
1448   uint public          maxPerTx          = 30;
1449   uint public          maxPerWallet      = 90;
1450   uint public          totalFree         = 1000;
1451   uint public          maxSupply         = 4444;
1452   uint public          nextOwnerToExplicitlySet;
1453   bool public          mintEnabled;
1454 
1455   constructor() ERC721A("TrippiestApeTribe", "TAT"){}
1456 
1457   function mint(uint256 amt) external payable
1458   {
1459     uint cost = price;
1460     if(totalSupply() + amt < totalFree + 1) {
1461       cost = 0;
1462     }
1463     require(msg.sender == tx.origin,"Be yourself, honey.");
1464     require(msg.value == amt * cost,"Please send the exact amount.");
1465     require(totalSupply() + amt < maxSupply + 1,"No more Apes available");
1466     require(mintEnabled, "Minting is not live yet.");
1467     require(numberMinted(msg.sender) + amt <= maxPerWallet,"Too many per wallet!");
1468     require( amt < maxPerTx + 1, "Max per TX reached.");
1469 
1470     _safeMint(msg.sender, amt);
1471   }
1472 
1473   function toggleMinting() external onlyOwner {
1474       mintEnabled = !mintEnabled;
1475   }
1476 
1477   function numberMinted(address owner) public view returns (uint256) {
1478     return _numberMinted(owner);
1479   }
1480 
1481   function setBaseURI(string calldata baseURI_) external onlyOwner {
1482     baseURI = baseURI_;
1483   }
1484 
1485   function setPrice(uint256 price_) external onlyOwner {
1486       price = price_;
1487   }
1488 
1489   function setTotalFree(uint256 totalFree_) external onlyOwner {
1490       totalFree = totalFree_;
1491   }
1492 
1493   function setMaxPerTx(uint256 maxPerTx_) external onlyOwner {
1494       maxPerTx = maxPerTx_;
1495   }
1496 
1497   function setMaxPerWallet(uint256 maxPerWallet_) external onlyOwner {
1498       maxPerWallet = maxPerWallet_;
1499   }
1500 
1501   function setmaxSupply(uint256 maxSupply_) external onlyOwner {
1502       maxSupply = maxSupply_;
1503   }
1504 
1505   function _baseURI() internal view virtual override returns (string memory) {
1506     return baseURI;
1507   }
1508 
1509   function withdraw() external onlyOwner nonReentrant {
1510     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1511     require(success, "Transfer failed.");
1512   }
1513 
1514   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1515     _setOwnersExplicit(quantity);
1516   }
1517 
1518   function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory)
1519   {
1520     return ownershipOf(tokenId);
1521   }
1522 
1523 
1524   /**
1525     * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1526     */
1527   function _setOwnersExplicit(uint256 quantity) internal {
1528       require(quantity != 0, "quantity must be nonzero");
1529       require(currentIndex != 0, "no tokens minted yet");
1530       uint256 _nextOwnerToExplicitlySet = nextOwnerToExplicitlySet;
1531       require(_nextOwnerToExplicitlySet < currentIndex, "all ownerships have been set");
1532 
1533       // Index underflow is impossible.
1534       // Counter or index overflow is incredibly unrealistic.
1535       unchecked {
1536           uint256 endIndex = _nextOwnerToExplicitlySet + quantity - 1;
1537 
1538           // Set the end index to be the last token index
1539           if (endIndex + 1 > currentIndex) {
1540               endIndex = currentIndex - 1;
1541           }
1542 
1543           for (uint256 i = _nextOwnerToExplicitlySet; i <= endIndex; i++) {
1544               if (_ownerships[i].addr == address(0)) {
1545                   TokenOwnership memory ownership = ownershipOf(i);
1546                   _ownerships[i].addr = ownership.addr;
1547                   _ownerships[i].startTimestamp = ownership.startTimestamp;
1548               }
1549           }
1550 
1551           nextOwnerToExplicitlySet = endIndex + 1;
1552       }
1553   }
1554 }