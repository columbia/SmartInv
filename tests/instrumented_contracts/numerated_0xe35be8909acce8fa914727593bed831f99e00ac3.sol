1 /**
2  *Submitted for verification at Etherscan.io on 2022-07-10
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
8 
9 
10 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev Interface of the ERC20 standard as defined in the EIP.
16  */
17 interface IERC20 {
18     /**
19      * @dev Returns the amount of tokens in existence.
20      */
21     function totalSupply() external view returns (uint256);
22 
23     /**
24      * @dev Returns the amount of tokens owned by `account`.
25      */
26     function balanceOf(address account) external view returns (uint256);
27 
28     /**
29      * @dev Moves `amount` tokens from the caller's account to `to`.
30      *
31      * Returns a boolean value indicating whether the operation succeeded.
32      *
33      * Emits a {Transfer} event.
34      */
35     function transfer(address to, uint256 amount) external returns (bool);
36 
37     /**
38      * @dev Returns the remaining number of tokens that `spender` will be
39      * allowed to spend on behalf of `owner` through {transferFrom}. This is
40      * zero by default.
41      *
42      * This value changes when {approve} or {transferFrom} are called.
43      */
44     function allowance(address owner, address spender) external view returns (uint256);
45 
46     /**
47      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * IMPORTANT: Beware that changing an allowance with this method brings the risk
52      * that someone may use both the old and the new allowance by unfortunate
53      * transaction ordering. One possible solution to mitigate this race
54      * condition is to first reduce the spender's allowance to 0 and set the
55      * desired value afterwards:
56      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
57      *
58      * Emits an {Approval} event.
59      */
60     function approve(address spender, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Moves `amount` tokens from `from` to `to` using the
64      * allowance mechanism. `amount` is then deducted from the caller's
65      * allowance.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * Emits a {Transfer} event.
70      */
71     function transferFrom(
72         address from,
73         address to,
74         uint256 amount
75     ) external returns (bool);
76 
77     /**
78      * @dev Emitted when `value` tokens are moved from one account (`from`) to
79      * another (`to`).
80      *
81      * Note that `value` may be zero.
82      */
83     event Transfer(address indexed from, address indexed to, uint256 value);
84 
85     /**
86      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
87      * a call to {approve}. `value` is the new allowance.
88      */
89     event Approval(address indexed owner, address indexed spender, uint256 value);
90 }
91 
92 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
93 
94 
95 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
96 
97 pragma solidity ^0.8.0;
98 
99 /**
100  * @dev Contract module that helps prevent reentrant calls to a function.
101  *
102  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
103  * available, which can be applied to functions to make sure there are no nested
104  * (reentrant) calls to them.
105  *
106  * Note that because there is a single `nonReentrant` guard, functions marked as
107  * `nonReentrant` may not call one another. This can be worked around by making
108  * those functions `private`, and then adding `external` `nonReentrant` entry
109  * points to them.
110  *
111  * TIP: If you would like to learn more about reentrancy and alternative ways
112  * to protect against it, check out our blog post
113  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
114  */
115 abstract contract ReentrancyGuard {
116     // Booleans are more expensive than uint256 or any type that takes up a full
117     // word because each write operation emits an extra SLOAD to first read the
118     // slot's contents, replace the bits taken up by the boolean, and then write
119     // back. This is the compiler's defense against contract upgrades and
120     // pointer aliasing, and it cannot be disabled.
121 
122     // The values being non-zero value makes deployment a bit more expensive,
123     // but in exchange the refund on every call to nonReentrant will be lower in
124     // amount. Since refunds are capped to a percentage of the total
125     // transaction's gas, it is best to keep them low in cases like this one, to
126     // increase the likelihood of the full refund coming into effect.
127     uint256 private constant _NOT_ENTERED = 1;
128     uint256 private constant _ENTERED = 2;
129 
130     uint256 private _status;
131 
132     constructor() {
133         _status = _NOT_ENTERED;
134     }
135 
136     /**
137      * @dev Prevents a contract from calling itself, directly or indirectly.
138      * Calling a `nonReentrant` function from another `nonReentrant`
139      * function is not supported. It is possible to prevent this from happening
140      * by making the `nonReentrant` function external, and making it call a
141      * `private` function that does the actual work.
142      */
143     modifier nonReentrant() {
144         // On the first call to nonReentrant, _notEntered will be true
145         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
146 
147         // Any calls to nonReentrant after this point will fail
148         _status = _ENTERED;
149 
150         _;
151 
152         // By storing the original value once again, a refund is triggered (see
153         // https://eips.ethereum.org/EIPS/eip-2200)
154         _status = _NOT_ENTERED;
155     }
156 }
157 
158 // File: @openzeppelin/contracts/utils/Strings.sol
159 
160 
161 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
162 
163 pragma solidity ^0.8.0;
164 
165 /**
166  * @dev String operations.
167  */
168 library Strings {
169     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
170 
171     /**
172      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
173      */
174     function toString(uint256 value) internal pure returns (string memory) {
175         // Inspired by OraclizeAPI's implementation - MIT licence
176         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
177 
178         if (value == 0) {
179             return "0";
180         }
181         uint256 temp = value;
182         uint256 digits;
183         while (temp != 0) {
184             digits++;
185             temp /= 10;
186         }
187         bytes memory buffer = new bytes(digits);
188         while (value != 0) {
189             digits -= 1;
190             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
191             value /= 10;
192         }
193         return string(buffer);
194     }
195 
196     /**
197      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
198      */
199     function toHexString(uint256 value) internal pure returns (string memory) {
200         if (value == 0) {
201             return "0x00";
202         }
203         uint256 temp = value;
204         uint256 length = 0;
205         while (temp != 0) {
206             length++;
207             temp >>= 8;
208         }
209         return toHexString(value, length);
210     }
211 
212     /**
213      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
214      */
215     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
216         bytes memory buffer = new bytes(2 * length + 2);
217         buffer[0] = "0";
218         buffer[1] = "x";
219         for (uint256 i = 2 * length + 1; i > 1; --i) {
220             buffer[i] = _HEX_SYMBOLS[value & 0xf];
221             value >>= 4;
222         }
223         require(value == 0, "Strings: hex length insufficient");
224         return string(buffer);
225     }
226 }
227 
228 // File: @openzeppelin/contracts/utils/Context.sol
229 
230 
231 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
232 
233 pragma solidity ^0.8.0;
234 
235 /**
236  * @dev Provides information about the current execution context, including the
237  * sender of the transaction and its data. While these are generally available
238  * via msg.sender and msg.data, they should not be accessed in such a direct
239  * manner, since when dealing with meta-transactions the account sending and
240  * paying for execution may not be the actual sender (as far as an application
241  * is concerned).
242  *
243  * This contract is only required for intermediate, library-like contracts.
244  */
245 abstract contract Context {
246     function _msgSender() internal view virtual returns (address) {
247         return msg.sender;
248     }
249 
250     function _msgData() internal view virtual returns (bytes calldata) {
251         return msg.data;
252     }
253 }
254 
255 // File: @openzeppelin/contracts/access/Ownable.sol
256 
257 
258 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
259 
260 pragma solidity ^0.8.0;
261 
262 
263 /**
264  * @dev Contract module which provides a basic access control mechanism, where
265  * there is an account (an owner) that can be granted exclusive access to
266  * specific functions.
267  *
268  * By default, the owner account will be the one that deploys the contract. This
269  * can later be changed with {transferOwnership}.
270  *
271  * This module is used through inheritance. It will make available the modifier
272  * `onlyOwner`, which can be applied to your functions to restrict their use to
273  * the owner.
274  */
275 abstract contract Ownable is Context {
276     address private _owner;
277 
278     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
279 
280     /**
281      * @dev Initializes the contract setting the deployer as the initial owner.
282      */
283     constructor() {
284         _transferOwnership(_msgSender());
285     }
286 
287     /**
288      * @dev Returns the address of the current owner.
289      */
290     function owner() public view virtual returns (address) {
291         return _owner;
292     }
293 
294     /**
295      * @dev Throws if called by any account other than the owner.
296      */
297     modifier onlyOwner() {
298         require(owner() == _msgSender(), "Ownable: caller is not the owner");
299         _;
300     }
301 
302     /**
303      * @dev Leaves the contract without owner. It will not be possible to call
304      * `onlyOwner` functions anymore. Can only be called by the current owner.
305      *
306      * NOTE: Renouncing ownership will leave the contract without an owner,
307      * thereby removing any functionality that is only available to the owner.
308      */
309     function renounceOwnership() public virtual onlyOwner {
310         _transferOwnership(address(0));
311     }
312 
313     /**
314      * @dev Transfers ownership of the contract to a new account (`newOwner`).
315      * Can only be called by the current owner.
316      */
317     function transferOwnership(address newOwner) public virtual onlyOwner {
318         require(newOwner != address(0), "Ownable: new owner is the zero address");
319         _transferOwnership(newOwner);
320     }
321 
322     /**
323      * @dev Transfers ownership of the contract to a new account (`newOwner`).
324      * Internal function without access restriction.
325      */
326     function _transferOwnership(address newOwner) internal virtual {
327         address oldOwner = _owner;
328         _owner = newOwner;
329         emit OwnershipTransferred(oldOwner, newOwner);
330     }
331 }
332 
333 // File: @openzeppelin/contracts/utils/Address.sol
334 
335 
336 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
337 
338 pragma solidity ^0.8.1;
339 
340 /**
341  * @dev Collection of functions related to the address type
342  */
343 library Address {
344     /**
345      * @dev Returns true if `account` is a contract.
346      *
347      * [IMPORTANT]
348      * ====
349      * It is unsafe to assume that an address for which this function returns
350      * false is an externally-owned account (EOA) and not a contract.
351      *
352      * Among others, `isContract` will return false for the following
353      * types of addresses:
354      *
355      *  - an externally-owned account
356      *  - a contract in construction
357      *  - an address where a contract will be created
358      *  - an address where a contract lived, but was destroyed
359      * ====
360      *
361      * [IMPORTANT]
362      * ====
363      * You shouldn't rely on `isContract` to protect against flash loan attacks!
364      *
365      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
366      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
367      * constructor.
368      * ====
369      */
370     function isContract(address account) internal view returns (bool) {
371         // This method relies on extcodesize/address.code.length, which returns 0
372         // for contracts in construction, since the code is only stored at the end
373         // of the constructor execution.
374 
375         return account.code.length > 0;
376     }
377 
378     /**
379      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
380      * `recipient`, forwarding all available gas and reverting on errors.
381      *
382      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
383      * of certain opcodes, possibly making contracts go over the 2300 gas limit
384      * imposed by `transfer`, making them unable to receive funds via
385      * `transfer`. {sendValue} removes this limitation.
386      *
387      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
388      *
389      * IMPORTANT: because control is transferred to `recipient`, care must be
390      * taken to not create reentrancy vulnerabilities. Consider using
391      * {ReentrancyGuard} or the
392      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
393      */
394     function sendValue(address payable recipient, uint256 amount) internal {
395         require(address(this).balance >= amount, "Address: insufficient balance");
396 
397         (bool success, ) = recipient.call{value: amount}("");
398         require(success, "Address: unable to send value, recipient may have reverted");
399     }
400 
401     /**
402      * @dev Performs a Solidity function call using a low level `call`. A
403      * plain `call` is an unsafe replacement for a function call: use this
404      * function instead.
405      *
406      * If `target` reverts with a revert reason, it is bubbled up by this
407      * function (like regular Solidity function calls).
408      *
409      * Returns the raw returned data. To convert to the expected return value,
410      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
411      *
412      * Requirements:
413      *
414      * - `target` must be a contract.
415      * - calling `target` with `data` must not revert.
416      *
417      * _Available since v3.1._
418      */
419     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
420         return functionCall(target, data, "Address: low-level call failed");
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
425      * `errorMessage` as a fallback revert reason when `target` reverts.
426      *
427      * _Available since v3.1._
428      */
429     function functionCall(
430         address target,
431         bytes memory data,
432         string memory errorMessage
433     ) internal returns (bytes memory) {
434         return functionCallWithValue(target, data, 0, errorMessage);
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
439      * but also transferring `value` wei to `target`.
440      *
441      * Requirements:
442      *
443      * - the calling contract must have an ETH balance of at least `value`.
444      * - the called Solidity function must be `payable`.
445      *
446      * _Available since v3.1._
447      */
448     function functionCallWithValue(
449         address target,
450         bytes memory data,
451         uint256 value
452     ) internal returns (bytes memory) {
453         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
458      * with `errorMessage` as a fallback revert reason when `target` reverts.
459      *
460      * _Available since v3.1._
461      */
462     function functionCallWithValue(
463         address target,
464         bytes memory data,
465         uint256 value,
466         string memory errorMessage
467     ) internal returns (bytes memory) {
468         require(address(this).balance >= value, "Address: insufficient balance for call");
469         require(isContract(target), "Address: call to non-contract");
470 
471         (bool success, bytes memory returndata) = target.call{value: value}(data);
472         return verifyCallResult(success, returndata, errorMessage);
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
477      * but performing a static call.
478      *
479      * _Available since v3.3._
480      */
481     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
482         return functionStaticCall(target, data, "Address: low-level static call failed");
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
487      * but performing a static call.
488      *
489      * _Available since v3.3._
490      */
491     function functionStaticCall(
492         address target,
493         bytes memory data,
494         string memory errorMessage
495     ) internal view returns (bytes memory) {
496         require(isContract(target), "Address: static call to non-contract");
497 
498         (bool success, bytes memory returndata) = target.staticcall(data);
499         return verifyCallResult(success, returndata, errorMessage);
500     }
501 
502     /**
503      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
504      * but performing a delegate call.
505      *
506      * _Available since v3.4._
507      */
508     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
509         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
510     }
511 
512     /**
513      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
514      * but performing a delegate call.
515      *
516      * _Available since v3.4._
517      */
518     function functionDelegateCall(
519         address target,
520         bytes memory data,
521         string memory errorMessage
522     ) internal returns (bytes memory) {
523         require(isContract(target), "Address: delegate call to non-contract");
524 
525         (bool success, bytes memory returndata) = target.delegatecall(data);
526         return verifyCallResult(success, returndata, errorMessage);
527     }
528 
529     /**
530      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
531      * revert reason using the provided one.
532      *
533      * _Available since v4.3._
534      */
535     function verifyCallResult(
536         bool success,
537         bytes memory returndata,
538         string memory errorMessage
539     ) internal pure returns (bytes memory) {
540         if (success) {
541             return returndata;
542         } else {
543             // Look for revert reason and bubble it up if present
544             if (returndata.length > 0) {
545                 // The easiest way to bubble the revert reason is using memory via assembly
546 
547                 assembly {
548                     let returndata_size := mload(returndata)
549                     revert(add(32, returndata), returndata_size)
550                 }
551             } else {
552                 revert(errorMessage);
553             }
554         }
555     }
556 }
557 
558 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
559 
560 
561 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
562 
563 pragma solidity ^0.8.0;
564 
565 
566 
567 /**
568  * @title SafeERC20
569  * @dev Wrappers around ERC20 operations that throw on failure (when the token
570  * contract returns false). Tokens that return no value (and instead revert or
571  * throw on failure) are also supported, non-reverting calls are assumed to be
572  * successful.
573  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
574  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
575  */
576 library SafeERC20 {
577     using Address for address;
578 
579     function safeTransfer(
580         IERC20 token,
581         address to,
582         uint256 value
583     ) internal {
584         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
585     }
586 
587     function safeTransferFrom(
588         IERC20 token,
589         address from,
590         address to,
591         uint256 value
592     ) internal {
593         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
594     }
595 
596     /**
597      * @dev Deprecated. This function has issues similar to the ones found in
598      * {IERC20-approve}, and its usage is discouraged.
599      *
600      * Whenever possible, use {safeIncreaseAllowance} and
601      * {safeDecreaseAllowance} instead.
602      */
603     function safeApprove(
604         IERC20 token,
605         address spender,
606         uint256 value
607     ) internal {
608         // safeApprove should only be called when setting an initial allowance,
609         // or when resetting it to zero. To increase and decrease it, use
610         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
611         require(
612             (value == 0) || (token.allowance(address(this), spender) == 0),
613             "SafeERC20: approve from non-zero to non-zero allowance"
614         );
615         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
616     }
617 
618     function safeIncreaseAllowance(
619         IERC20 token,
620         address spender,
621         uint256 value
622     ) internal {
623         uint256 newAllowance = token.allowance(address(this), spender) + value;
624         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
625     }
626 
627     function safeDecreaseAllowance(
628         IERC20 token,
629         address spender,
630         uint256 value
631     ) internal {
632         unchecked {
633             uint256 oldAllowance = token.allowance(address(this), spender);
634             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
635             uint256 newAllowance = oldAllowance - value;
636             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
637         }
638     }
639 
640     /**
641      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
642      * on the return value: the return value is optional (but if data is returned, it must not be false).
643      * @param token The token targeted by the call.
644      * @param data The call data (encoded using abi.encode or one of its variants).
645      */
646     function _callOptionalReturn(IERC20 token, bytes memory data) private {
647         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
648         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
649         // the target address contains contract code and also asserts for success in the low-level call.
650 
651         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
652         if (returndata.length > 0) {
653             // Return data is optional
654             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
655         }
656     }
657 }
658 
659 
660 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
661 
662 
663 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
664 
665 pragma solidity ^0.8.0;
666 
667 /**
668  * @title ERC721 token receiver interface
669  * @dev Interface for any contract that wants to support safeTransfers
670  * from ERC721 asset contracts.
671  */
672 interface IERC721Receiver {
673     /**
674      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
675      * by `operator` from `from`, this function is called.
676      *
677      * It must return its Solidity selector to confirm the token transfer.
678      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
679      *
680      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
681      */
682     function onERC721Received(
683         address operator,
684         address from,
685         uint256 tokenId,
686         bytes calldata data
687     ) external returns (bytes4);
688 }
689 
690 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
691 
692 
693 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
694 
695 pragma solidity ^0.8.0;
696 
697 /**
698  * @dev Interface of the ERC165 standard, as defined in the
699  * https://eips.ethereum.org/EIPS/eip-165[EIP].
700  *
701  * Implementers can declare support of contract interfaces, which can then be
702  * queried by others ({ERC165Checker}).
703  *
704  * For an implementation, see {ERC165}.
705  */
706 interface IERC165 {
707     /**
708      * @dev Returns true if this contract implements the interface defined by
709      * `interfaceId`. See the corresponding
710      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
711      * to learn more about how these ids are created.
712      *
713      * This function call must use less than 30 000 gas.
714      */
715     function supportsInterface(bytes4 interfaceId) external view returns (bool);
716 }
717 
718 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
719 
720 
721 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
722 
723 pragma solidity ^0.8.0;
724 
725 
726 /**
727  * @dev Implementation of the {IERC165} interface.
728  *
729  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
730  * for the additional interface id that will be supported. For example:
731  *
732  * ```solidity
733  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
734  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
735  * }
736  * ```
737  *
738  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
739  */
740 abstract contract ERC165 is IERC165 {
741     /**
742      * @dev See {IERC165-supportsInterface}.
743      */
744     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
745         return interfaceId == type(IERC165).interfaceId;
746     }
747 }
748 
749 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
750 
751 
752 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
753 
754 pragma solidity ^0.8.0;
755 
756 
757 /**
758  * @dev Required interface of an ERC721 compliant contract.
759  */
760 interface IERC721 is IERC165 {
761     /**
762      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
763      */
764     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
765 
766     /**
767      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
768      */
769     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
770 
771     /**
772      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
773      */
774     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
775 
776     /**
777      * @dev Returns the number of tokens in ``owner``'s account.
778      */
779     function balanceOf(address owner) external view returns (uint256 balance);
780 
781     /**
782      * @dev Returns the owner of the `tokenId` token.
783      *
784      * Requirements:
785      *
786      * - `tokenId` must exist.
787      */
788     function ownerOf(uint256 tokenId) external view returns (address owner);
789 
790     /**
791      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
792      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
793      *
794      * Requirements:
795      *
796      * - `from` cannot be the zero address.
797      * - `to` cannot be the zero address.
798      * - `tokenId` token must exist and be owned by `from`.
799      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
800      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
801      *
802      * Emits a {Transfer} event.
803      */
804     function safeTransferFrom(
805         address from,
806         address to,
807         uint256 tokenId
808     ) external;
809 
810     /**
811      * @dev Transfers `tokenId` token from `from` to `to`.
812      *
813      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
814      *
815      * Requirements:
816      *
817      * - `from` cannot be the zero address.
818      * - `to` cannot be the zero address.
819      * - `tokenId` token must be owned by `from`.
820      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
821      *
822      * Emits a {Transfer} event.
823      */
824     function transferFrom(
825         address from,
826         address to,
827         uint256 tokenId
828     ) external;
829 
830     /**
831      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
832      * The approval is cleared when the token is transferred.
833      *
834      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
835      *
836      * Requirements:
837      *
838      * - The caller must own the token or be an approved operator.
839      * - `tokenId` must exist.
840      *
841      * Emits an {Approval} event.
842      */
843     function approve(address to, uint256 tokenId) external;
844 
845     /**
846      * @dev Returns the account approved for `tokenId` token.
847      *
848      * Requirements:
849      *
850      * - `tokenId` must exist.
851      */
852     function getApproved(uint256 tokenId) external view returns (address operator);
853 
854     /**
855      * @dev Approve or remove `operator` as an operator for the caller.
856      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
857      *
858      * Requirements:
859      *
860      * - The `operator` cannot be the caller.
861      *
862      * Emits an {ApprovalForAll} event.
863      */
864     function setApprovalForAll(address operator, bool _approved) external;
865 
866     /**
867      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
868      *
869      * See {setApprovalForAll}
870      */
871     function isApprovedForAll(address owner, address operator) external view returns (bool);
872 
873     /**
874      * @dev Safely transfers `tokenId` token from `from` to `to`.
875      *
876      * Requirements:
877      *
878      * - `from` cannot be the zero address.
879      * - `to` cannot be the zero address.
880      * - `tokenId` token must exist and be owned by `from`.
881      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
882      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
883      *
884      * Emits a {Transfer} event.
885      */
886     function safeTransferFrom(
887         address from,
888         address to,
889         uint256 tokenId,
890         bytes calldata data
891     ) external;
892 }
893 
894 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
895 
896 
897 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
898 
899 pragma solidity ^0.8.0;
900 
901 
902 /**
903  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
904  * @dev See https://eips.ethereum.org/EIPS/eip-721
905  */
906 interface IERC721Enumerable is IERC721 {
907     /**
908      * @dev Returns the total amount of tokens stored by the contract.
909      */
910     function totalSupply() external view returns (uint256);
911 
912     /**
913      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
914      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
915      */
916     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
917 
918     /**
919      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
920      * Use along with {totalSupply} to enumerate all tokens.
921      */
922     function tokenByIndex(uint256 index) external view returns (uint256);
923 }
924 
925 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
926 
927 
928 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
929 
930 pragma solidity ^0.8.0;
931 
932 
933 /**
934  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
935  * @dev See https://eips.ethereum.org/EIPS/eip-721
936  */
937 interface IERC721Metadata is IERC721 {
938     /**
939      * @dev Returns the token collection name.
940      */
941     function name() external view returns (string memory);
942 
943     /**
944      * @dev Returns the token collection symbol.
945      */
946     function symbol() external view returns (string memory);
947 
948     /**
949      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
950      */
951     function tokenURI(uint256 tokenId) external view returns (string memory);
952 }
953 
954 // File: contracts/TwistedToonz.sol
955 
956 
957 // Creator: Chiru Labs
958 
959 pragma solidity ^0.8.0;
960 
961 
962 
963 
964 
965 
966 
967 
968 
969 /**
970  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
971  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
972  *
973  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
974  *
975  * Does not support burning tokens to address(0).
976  *
977  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
978  */
979 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
980     using Address for address;
981     using Strings for uint256;
982 
983     struct TokenOwnership {
984         address addr;
985         uint64 startTimestamp;
986     }
987 
988     struct AddressData {
989         uint128 balance;
990         uint128 numberMinted;
991     }
992 
993     uint256 internal currentIndex;
994 
995     // Token name
996     string private _name;
997 
998     // Token symbol
999     string private _symbol;
1000 
1001     // Mapping from token ID to ownership details
1002     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1003     mapping(uint256 => TokenOwnership) internal _ownerships;
1004 
1005     // Mapping owner address to address data
1006     mapping(address => AddressData) private _addressData;
1007 
1008     // Mapping from token ID to approved address
1009     mapping(uint256 => address) private _tokenApprovals;
1010 
1011     // Mapping from owner to operator approvals
1012     mapping(address => mapping(address => bool)) private _operatorApprovals;
1013 
1014     constructor(string memory name_, string memory symbol_) {
1015         _name = name_;
1016         _symbol = symbol_;
1017     }
1018 
1019     /**
1020      * @dev See {IERC721Enumerable-totalSupply}.
1021      */
1022     function totalSupply() public view override returns (uint256) {
1023         return currentIndex;
1024     }
1025 
1026     /**
1027      * @dev See {IERC721Enumerable-tokenByIndex}.
1028      */
1029     function tokenByIndex(uint256 index) public view override returns (uint256) {
1030         require(index < totalSupply(), "ERC721A: global index out of bounds");
1031         return index;
1032     }
1033 
1034     /**
1035      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1036      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1037      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1038      */
1039     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1040         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1041         uint256 numMintedSoFar = totalSupply();
1042         uint256 tokenIdsIdx;
1043         address currOwnershipAddr;
1044 
1045         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1046         unchecked {
1047             for (uint256 i; i < numMintedSoFar; i++) {
1048                 TokenOwnership memory ownership = _ownerships[i];
1049                 if (ownership.addr != address(0)) {
1050                     currOwnershipAddr = ownership.addr;
1051                 }
1052                 if (currOwnershipAddr == owner) {
1053                     if (tokenIdsIdx == index) {
1054                         return i;
1055                     }
1056                     tokenIdsIdx++;
1057                 }
1058             }
1059         }
1060 
1061         revert("ERC721A: unable to get token of owner by index");
1062     }
1063 
1064     /**
1065      * @dev See {IERC165-supportsInterface}.
1066      */
1067     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1068         return
1069             interfaceId == type(IERC721).interfaceId ||
1070             interfaceId == type(IERC721Metadata).interfaceId ||
1071             interfaceId == type(IERC721Enumerable).interfaceId ||
1072             super.supportsInterface(interfaceId);
1073     }
1074 
1075     /**
1076      * @dev See {IERC721-balanceOf}.
1077      */
1078     function balanceOf(address owner) public view override returns (uint256) {
1079         require(owner != address(0), "ERC721A: balance query for the zero address");
1080         return uint256(_addressData[owner].balance);
1081     }
1082 
1083     function _numberMinted(address owner) internal view returns (uint256) {
1084         require(owner != address(0), "ERC721A: number minted query for the zero address");
1085         return uint256(_addressData[owner].numberMinted);
1086     }
1087 
1088     /**
1089      * Gas spent here starts off proportional to the maximum mint batch size.
1090      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1091      */
1092     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1093         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1094 
1095         unchecked {
1096             for (uint256 curr = tokenId; curr >= 0; curr--) {
1097                 TokenOwnership memory ownership = _ownerships[curr];
1098                 if (ownership.addr != address(0)) {
1099                     return ownership;
1100                 }
1101             }
1102         }
1103 
1104         revert("ERC721A: unable to determine the owner of token");
1105     }
1106 
1107     /**
1108      * @dev See {IERC721-ownerOf}.
1109      */
1110     function ownerOf(uint256 tokenId) public view override returns (address) {
1111         return ownershipOf(tokenId).addr;
1112     }
1113 
1114     /**
1115      * @dev See {IERC721Metadata-name}.
1116      */
1117     function name() public view virtual override returns (string memory) {
1118         return _name;
1119     }
1120 
1121     /**
1122      * @dev See {IERC721Metadata-symbol}.
1123      */
1124     function symbol() public view virtual override returns (string memory) {
1125         return _symbol;
1126     }
1127 
1128     /**
1129      * @dev See {IERC721Metadata-tokenURI}.
1130      */
1131     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1132         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1133 
1134         string memory baseURI = _baseURI();
1135         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
1136 
1137     }
1138 
1139     /**
1140      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1141      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1142      * by default, can be overriden in child contracts.
1143      */
1144     function _baseURI() internal view virtual returns (string memory) {
1145         return "";
1146     }
1147 
1148     /**
1149      * @dev See {IERC721-approve}.
1150      */
1151     function approve(address to, uint256 tokenId) public override {
1152         address owner = ERC721A.ownerOf(tokenId);
1153         require(to != owner, "ERC721A: approval to current owner");
1154 
1155         require(
1156             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1157             "ERC721A: approve caller is not owner nor approved for all"
1158         );
1159 
1160         _approve(to, tokenId, owner);
1161     }
1162 
1163     /**
1164      * @dev See {IERC721-getApproved}.
1165      */
1166     function getApproved(uint256 tokenId) public view override returns (address) {
1167         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1168 
1169         return _tokenApprovals[tokenId];
1170     }
1171 
1172     /**
1173      * @dev See {IERC721-setApprovalForAll}.
1174      */
1175     function setApprovalForAll(address operator, bool approved) public override {
1176         require(operator != _msgSender(), "ERC721A: approve to caller");
1177 
1178         _operatorApprovals[_msgSender()][operator] = approved;
1179         emit ApprovalForAll(_msgSender(), operator, approved);
1180     }
1181 
1182     /**
1183      * @dev See {IERC721-isApprovedForAll}.
1184      */
1185     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1186         return _operatorApprovals[owner][operator];
1187     }
1188 
1189     /**
1190      * @dev See {IERC721-transferFrom}.
1191      */
1192     function transferFrom(
1193         address from,
1194         address to,
1195         uint256 tokenId
1196     ) public virtual override {
1197         _transfer(from, to, tokenId);
1198     }
1199 
1200     /**
1201      * @dev See {IERC721-safeTransferFrom}.
1202      */
1203     function safeTransferFrom(
1204         address from,
1205         address to,
1206         uint256 tokenId
1207     ) public virtual override {
1208         safeTransferFrom(from, to, tokenId, "");
1209     }
1210 
1211     /**
1212      * @dev See {IERC721-safeTransferFrom}.
1213      */
1214     function safeTransferFrom(
1215         address from,
1216         address to,
1217         uint256 tokenId,
1218         bytes memory _data
1219     ) public override {
1220         _transfer(from, to, tokenId);
1221         require(
1222             _checkOnERC721Received(from, to, tokenId, _data),
1223             "ERC721A: transfer to non ERC721Receiver implementer"
1224         );
1225     }
1226 
1227     /**
1228      * @dev Returns whether `tokenId` exists.
1229      *
1230      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1231      *
1232      * Tokens start existing when they are minted (`_mint`),
1233      */
1234     function _exists(uint256 tokenId) internal view returns (bool) {
1235         return tokenId < currentIndex;
1236     }
1237 
1238     function _safeMint(address to, uint256 quantity) internal {
1239         _safeMint(to, quantity, "");
1240     }
1241 
1242     /**
1243      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1244      *
1245      * Requirements:
1246      *
1247      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1248      * - `quantity` must be greater than 0.
1249      *
1250      * Emits a {Transfer} event.
1251      */
1252     function _safeMint(
1253         address to,
1254         uint256 quantity,
1255         bytes memory _data
1256     ) internal {
1257         _mint(to, quantity, _data, true);
1258     }
1259 
1260     /**
1261      * @dev Mints `quantity` tokens and transfers them to `to`.
1262      *
1263      * Requirements:
1264      *
1265      * - `to` cannot be the zero address.
1266      * - `quantity` must be greater than 0.
1267      *
1268      * Emits a {Transfer} event.
1269      */
1270     function _mint(
1271         address to,
1272         uint256 quantity,
1273         bytes memory _data,
1274         bool safe
1275     ) internal {
1276         uint256 startTokenId = currentIndex;
1277         require(to != address(0), "ERC721A: mint to the zero address");
1278         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1279 
1280         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1281 
1282         // Overflows are incredibly unrealistic.
1283         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1284         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1285         unchecked {
1286             _addressData[to].balance += uint128(quantity);
1287             _addressData[to].numberMinted += uint128(quantity);
1288 
1289             _ownerships[startTokenId].addr = to;
1290             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1291 
1292             uint256 updatedIndex = startTokenId;
1293 
1294             for (uint256 i; i < quantity; i++) {
1295                 emit Transfer(address(0), to, updatedIndex);
1296                 if (safe) {
1297                     require(
1298                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1299                         "ERC721A: transfer to non ERC721Receiver implementer"
1300                     );
1301                 }
1302 
1303                 updatedIndex++;
1304             }
1305 
1306             currentIndex = updatedIndex;
1307         }
1308 
1309         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1310     }
1311 
1312     /**
1313      * @dev Transfers `tokenId` from `from` to `to`.
1314      *
1315      * Requirements:
1316      *
1317      * - `to` cannot be the zero address.
1318      * - `tokenId` token must be owned by `from`.
1319      *
1320      * Emits a {Transfer} event.
1321      */
1322     function _transfer(
1323         address from,
1324         address to,
1325         uint256 tokenId
1326     ) private {
1327         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1328 
1329         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1330             getApproved(tokenId) == _msgSender() ||
1331             isApprovedForAll(prevOwnership.addr, _msgSender()));
1332 
1333         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1334 
1335         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1336         require(to != address(0), "ERC721A: transfer to the zero address");
1337 
1338         _beforeTokenTransfers(from, to, tokenId, 1);
1339 
1340         // Clear approvals from the previous owner
1341         _approve(address(0), tokenId, prevOwnership.addr);
1342 
1343         // Underflow of the sender's balance is impossible because we check for
1344         // ownership above and the recipient's balance can't realistically overflow.
1345         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1346         unchecked {
1347             _addressData[from].balance -= 1;
1348             _addressData[to].balance += 1;
1349 
1350             _ownerships[tokenId].addr = to;
1351             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1352 
1353             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1354             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1355             uint256 nextTokenId = tokenId + 1;
1356             if (_ownerships[nextTokenId].addr == address(0)) {
1357                 if (_exists(nextTokenId)) {
1358                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1359                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1360                 }
1361             }
1362         }
1363 
1364         emit Transfer(from, to, tokenId);
1365         _afterTokenTransfers(from, to, tokenId, 1);
1366     }
1367 
1368     /**
1369      * @dev Approve `to` to operate on `tokenId`
1370      *
1371      * Emits a {Approval} event.
1372      */
1373     function _approve(
1374         address to,
1375         uint256 tokenId,
1376         address owner
1377     ) private {
1378         _tokenApprovals[tokenId] = to;
1379         emit Approval(owner, to, tokenId);
1380     }
1381 
1382     /**
1383      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1384      * The call is not executed if the target address is not a contract.
1385      *
1386      * @param from address representing the previous owner of the given token ID
1387      * @param to target address that will receive the tokens
1388      * @param tokenId uint256 ID of the token to be transferred
1389      * @param _data bytes optional data to send along with the call
1390      * @return bool whether the call correctly returned the expected magic value
1391      */
1392     function _checkOnERC721Received(
1393         address from,
1394         address to,
1395         uint256 tokenId,
1396         bytes memory _data
1397     ) private returns (bool) {
1398         if (to.isContract()) {
1399             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1400                 return retval == IERC721Receiver(to).onERC721Received.selector;
1401             } catch (bytes memory reason) {
1402                 if (reason.length == 0) {
1403                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1404                 } else {
1405                     assembly {
1406                         revert(add(32, reason), mload(reason))
1407                     }
1408                 }
1409             }
1410         } else {
1411             return true;
1412         }
1413     }
1414 
1415     /**
1416      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1417      *
1418      * startTokenId - the first token id to be transferred
1419      * quantity - the amount to be transferred
1420      *
1421      * Calling conditions:
1422      *
1423      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1424      * transferred to `to`.
1425      * - When `from` is zero, `tokenId` will be minted for `to`.
1426      */
1427     function _beforeTokenTransfers(
1428         address from,
1429         address to,
1430         uint256 startTokenId,
1431         uint256 quantity
1432     ) internal virtual {}
1433 
1434     /**
1435      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1436      * minting.
1437      *
1438      * startTokenId - the first token id to be transferred
1439      * quantity - the amount to be transferred
1440      *
1441      * Calling conditions:
1442      *
1443      * - when `from` and `to` are both non-zero.
1444      * - `from` and `to` are never both zero.
1445      */
1446     function _afterTokenTransfers(
1447         address from,
1448         address to,
1449         uint256 startTokenId,
1450         uint256 quantity
1451     ) internal virtual {}
1452 }
1453 
1454 contract ScaryBloh is ERC721A, Ownable, ReentrancyGuard {
1455 
1456   string public baseURI = "https://bafybeieq3azatw46olnj7nam34cfxkerlio2pvkvgu7ttx5qzjasglxgfe.ipfs.nftstorage.link/";
1457   uint public price = 0.0 ether;
1458   uint public maxSupply = 2222;
1459   uint public freeSupply = 2222;
1460   uint public maxPerWallet = 2;
1461   bool public activated = false;
1462   constructor() ERC721A("Scary Bloh", "Scary Bloh"){}
1463 
1464   function Mint(uint256 amount) external payable
1465   {
1466     require(activated, "contract not activated yet");
1467     require(amount>0, "Amount has to be greater than 1");
1468     require(msg.sender == tx.origin, "Smart Contracts can't mint");
1469     require(totalSupply() + amount <= maxSupply,"Sold out");
1470     require(numberMinted(msg.sender) + amount <= maxPerWallet, "2 per wallet");
1471     uint cost = 0;
1472     if(totalSupply() + amount > freeSupply) cost = price*amount;
1473     require(msg.value >= cost, "free mint ended 1 Bloh = 0.009eth");
1474     _safeMint(msg.sender, amount);
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
1485   function activateMint() external onlyOwner {
1486     activated = true;
1487   }
1488 
1489   function _baseURI() internal view virtual override returns (string memory) {
1490     return baseURI;
1491   }
1492 
1493   function withdraw() external onlyOwner nonReentrant {
1494     (bool wallet, ) = payable(msg.sender).call{value: address(this).balance}("");
1495     require(wallet, "Failed");
1496 
1497   }
1498 
1499 }