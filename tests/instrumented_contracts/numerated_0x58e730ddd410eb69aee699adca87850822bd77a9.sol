1 // SPDX-License-Identifier: MIT
2 
3 /**
4  * @title OkayMutantBears contract
5  * @dev Extends ERC721A - thanks azuki
6  */
7 
8 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
9 
10 
11 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
12 
13 pragma solidity ^0.8.0;
14 
15 /**
16  * @dev Interface of the ERC20 standard as defined in the EIP.
17  */
18 interface IERC20 {
19     /**
20      * @dev Returns the amount of tokens in existence.
21      */
22     function totalSupply() external view returns (uint256);
23 
24     /**
25      * @dev Returns the amount of tokens owned by `account`.
26      */
27     function balanceOf(address account) external view returns (uint256);
28 
29     /**
30      * @dev Moves `amount` tokens from the caller's account to `to`.
31      *
32      * Returns a boolean value indicating whether the operation succeeded.
33      *
34      * Emits a {Transfer} event.
35      */
36     function transfer(address to, uint256 amount) external returns (bool);
37 
38     /**
39      * @dev Returns the remaining number of tokens that `spender` will be
40      * allowed to spend on behalf of `owner` through {transferFrom}. This is
41      * zero by default.
42      *
43      * This value changes when {approve} or {transferFrom} are called.
44      */
45     function allowance(address owner, address spender) external view returns (uint256);
46 
47     /**
48      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * IMPORTANT: Beware that changing an allowance with this method brings the risk
53      * that someone may use both the old and the new allowance by unfortunate
54      * transaction ordering. One possible solution to mitigate this race
55      * condition is to first reduce the spender's allowance to 0 and set the
56      * desired value afterwards:
57      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
58      *
59      * Emits an {Approval} event.
60      */
61     function approve(address spender, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Moves `amount` tokens from `from` to `to` using the
65      * allowance mechanism. `amount` is then deducted from the caller's
66      * allowance.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * Emits a {Transfer} event.
71      */
72     function transferFrom(
73         address from,
74         address to,
75         uint256 amount
76     ) external returns (bool);
77 
78     /**
79      * @dev Emitted when `value` tokens are moved from one account (`from`) to
80      * another (`to`).
81      *
82      * Note that `value` may be zero.
83      */
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     /**
87      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
88      * a call to {approve}. `value` is the new allowance.
89      */
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
94 
95 
96 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
97 
98 pragma solidity ^0.8.0;
99 
100 /**
101  * @dev Contract module that helps prevent reentrant calls to a function.
102  *
103  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
104  * available, which can be applied to functions to make sure there are no nested
105  * (reentrant) calls to them.
106  *
107  * Note that because there is a single `nonReentrant` guard, functions marked as
108  * `nonReentrant` may not call one another. This can be worked around by making
109  * those functions `private`, and then adding `external` `nonReentrant` entry
110  * points to them.
111  *
112  * TIP: If you would like to learn more about reentrancy and alternative ways
113  * to protect against it, check out our blog post
114  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
115  */
116 abstract contract ReentrancyGuard {
117     // Booleans are more expensive than uint256 or any type that takes up a full
118     // word because each write operation emits an extra SLOAD to first read the
119     // slot's contents, replace the bits taken up by the boolean, and then write
120     // back. This is the compiler's defense against contract upgrades and
121     // pointer aliasing, and it cannot be disabled.
122 
123     // The values being non-zero value makes deployment a bit more expensive,
124     // but in exchange the refund on every call to nonReentrant will be lower in
125     // amount. Since refunds are capped to a percentage of the total
126     // transaction's gas, it is best to keep them low in cases like this one, to
127     // increase the likelihood of the full refund coming into effect.
128     uint256 private constant _NOT_ENTERED = 1;
129     uint256 private constant _ENTERED = 2;
130 
131     uint256 private _status;
132 
133     constructor() {
134         _status = _NOT_ENTERED;
135     }
136 
137     /**
138      * @dev Prevents a contract from calling itself, directly or indirectly.
139      * Calling a `nonReentrant` function from another `nonReentrant`
140      * function is not supported. It is possible to prevent this from happening
141      * by making the `nonReentrant` function external, and making it call a
142      * `private` function that does the actual work.
143      */
144     modifier nonReentrant() {
145         // On the first call to nonReentrant, _notEntered will be true
146         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
147 
148         // Any calls to nonReentrant after this point will fail
149         _status = _ENTERED;
150 
151         _;
152 
153         // By storing the original value once again, a refund is triggered (see
154         // https://eips.ethereum.org/EIPS/eip-2200)
155         _status = _NOT_ENTERED;
156     }
157 }
158 
159 // File: @openzeppelin/contracts/utils/Strings.sol
160 
161 
162 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
163 
164 pragma solidity ^0.8.0;
165 
166 /**
167  * @dev String operations.
168  */
169 library Strings {
170     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
171 
172     /**
173      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
174      */
175     function toString(uint256 value) internal pure returns (string memory) {
176         // Inspired by OraclizeAPI's implementation - MIT licence
177         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
178 
179         if (value == 0) {
180             return "0";
181         }
182         uint256 temp = value;
183         uint256 digits;
184         while (temp != 0) {
185             digits++;
186             temp /= 10;
187         }
188         bytes memory buffer = new bytes(digits);
189         while (value != 0) {
190             digits -= 1;
191             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
192             value /= 10;
193         }
194         return string(buffer);
195     }
196 
197     /**
198      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
199      */
200     function toHexString(uint256 value) internal pure returns (string memory) {
201         if (value == 0) {
202             return "0x00";
203         }
204         uint256 temp = value;
205         uint256 length = 0;
206         while (temp != 0) {
207             length++;
208             temp >>= 8;
209         }
210         return toHexString(value, length);
211     }
212 
213     /**
214      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
215      */
216     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
217         bytes memory buffer = new bytes(2 * length + 2);
218         buffer[0] = "0";
219         buffer[1] = "x";
220         for (uint256 i = 2 * length + 1; i > 1; --i) {
221             buffer[i] = _HEX_SYMBOLS[value & 0xf];
222             value >>= 4;
223         }
224         require(value == 0, "Strings: hex length insufficient");
225         return string(buffer);
226     }
227 }
228 
229 // File: @openzeppelin/contracts/utils/Context.sol
230 
231 
232 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
233 
234 pragma solidity ^0.8.0;
235 
236 /**
237  * @dev Provides information about the current execution context, including the
238  * sender of the transaction and its data. While these are generally available
239  * via msg.sender and msg.data, they should not be accessed in such a direct
240  * manner, since when dealing with meta-transactions the account sending and
241  * paying for execution may not be the actual sender (as far as an application
242  * is concerned).
243  *
244  * This contract is only required for intermediate, library-like contracts.
245  */
246 abstract contract Context {
247     function _msgSender() internal view virtual returns (address) {
248         return msg.sender;
249     }
250 
251     function _msgData() internal view virtual returns (bytes calldata) {
252         return msg.data;
253     }
254 }
255 
256 // File: @openzeppelin/contracts/access/Ownable.sol
257 
258 
259 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
260 
261 pragma solidity ^0.8.0;
262 
263 
264 /**
265  * @dev Contract module which provides a basic access control mechanism, where
266  * there is an account (an owner) that can be granted exclusive access to
267  * specific functions.
268  *
269  * By default, the owner account will be the one that deploys the contract. This
270  * can later be changed with {transferOwnership}.
271  *
272  * This module is used through inheritance. It will make available the modifier
273  * `onlyOwner`, which can be applied to your functions to restrict their use to
274  * the owner.
275  */
276 abstract contract Ownable is Context {
277     address private _owner;
278 
279     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
280 
281     /**
282      * @dev Initializes the contract setting the deployer as the initial owner.
283      */
284     constructor() {
285         _transferOwnership(_msgSender());
286     }
287 
288     /**
289      * @dev Returns the address of the current owner.
290      */
291     function owner() public view virtual returns (address) {
292         return _owner;
293     }
294 
295     /**
296      * @dev Throws if called by any account other than the owner.
297      */
298     modifier onlyOwner() {
299         require(owner() == _msgSender(), "Ownable: caller is not the owner");
300         _;
301     }
302 
303     /**
304      * @dev Leaves the contract without owner. It will not be possible to call
305      * `onlyOwner` functions anymore. Can only be called by the current owner.
306      *
307      * NOTE: Renouncing ownership will leave the contract without an owner,
308      * thereby removing any functionality that is only available to the owner.
309      */
310     function renounceOwnership() public virtual onlyOwner {
311         _transferOwnership(address(0));
312     }
313 
314     /**
315      * @dev Transfers ownership of the contract to a new account (`newOwner`).
316      * Can only be called by the current owner.
317      */
318     function transferOwnership(address newOwner) public virtual onlyOwner {
319         require(newOwner != address(0), "Ownable: new owner is the zero address");
320         _transferOwnership(newOwner);
321     }
322 
323     /**
324      * @dev Transfers ownership of the contract to a new account (`newOwner`).
325      * Internal function without access restriction.
326      */
327     function _transferOwnership(address newOwner) internal virtual {
328         address oldOwner = _owner;
329         _owner = newOwner;
330         emit OwnershipTransferred(oldOwner, newOwner);
331     }
332 }
333 
334 // File: @openzeppelin/contracts/utils/Address.sol
335 
336 
337 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
338 
339 pragma solidity ^0.8.1;
340 
341 /**
342  * @dev Collection of functions related to the address type
343  */
344 library Address {
345     /**
346      * @dev Returns true if `account` is a contract.
347      *
348      * [IMPORTANT]
349      * ====
350      * It is unsafe to assume that an address for which this function returns
351      * false is an externally-owned account (EOA) and not a contract.
352      *
353      * Among others, `isContract` will return false for the following
354      * types of addresses:
355      *
356      *  - an externally-owned account
357      *  - a contract in construction
358      *  - an address where a contract will be created
359      *  - an address where a contract lived, but was destroyed
360      * ====
361      *
362      * [IMPORTANT]
363      * ====
364      * You shouldn't rely on `isContract` to protect against flash loan attacks!
365      *
366      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
367      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
368      * constructor.
369      * ====
370      */
371     function isContract(address account) internal view returns (bool) {
372         // This method relies on extcodesize/address.code.length, which returns 0
373         // for contracts in construction, since the code is only stored at the end
374         // of the constructor execution.
375 
376         return account.code.length > 0;
377     }
378 
379     /**
380      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
381      * `recipient`, forwarding all available gas and reverting on errors.
382      *
383      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
384      * of certain opcodes, possibly making contracts go over the 2300 gas limit
385      * imposed by `transfer`, making them unable to receive funds via
386      * `transfer`. {sendValue} removes this limitation.
387      *
388      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
389      *
390      * IMPORTANT: because control is transferred to `recipient`, care must be
391      * taken to not create reentrancy vulnerabilities. Consider using
392      * {ReentrancyGuard} or the
393      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
394      */
395     function sendValue(address payable recipient, uint256 amount) internal {
396         require(address(this).balance >= amount, "Address: insufficient balance");
397 
398         (bool success, ) = recipient.call{value: amount}("");
399         require(success, "Address: unable to send value, recipient may have reverted");
400     }
401 
402     /**
403      * @dev Performs a Solidity function call using a low level `call`. A
404      * plain `call` is an unsafe replacement for a function call: use this
405      * function instead.
406      *
407      * If `target` reverts with a revert reason, it is bubbled up by this
408      * function (like regular Solidity function calls).
409      *
410      * Returns the raw returned data. To convert to the expected return value,
411      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
412      *
413      * Requirements:
414      *
415      * - `target` must be a contract.
416      * - calling `target` with `data` must not revert.
417      *
418      * _Available since v3.1._
419      */
420     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
421         return functionCall(target, data, "Address: low-level call failed");
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
426      * `errorMessage` as a fallback revert reason when `target` reverts.
427      *
428      * _Available since v3.1._
429      */
430     function functionCall(
431         address target,
432         bytes memory data,
433         string memory errorMessage
434     ) internal returns (bytes memory) {
435         return functionCallWithValue(target, data, 0, errorMessage);
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
440      * but also transferring `value` wei to `target`.
441      *
442      * Requirements:
443      *
444      * - the calling contract must have an ETH balance of at least `value`.
445      * - the called Solidity function must be `payable`.
446      *
447      * _Available since v3.1._
448      */
449     function functionCallWithValue(
450         address target,
451         bytes memory data,
452         uint256 value
453     ) internal returns (bytes memory) {
454         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
459      * with `errorMessage` as a fallback revert reason when `target` reverts.
460      *
461      * _Available since v3.1._
462      */
463     function functionCallWithValue(
464         address target,
465         bytes memory data,
466         uint256 value,
467         string memory errorMessage
468     ) internal returns (bytes memory) {
469         require(address(this).balance >= value, "Address: insufficient balance for call");
470         require(isContract(target), "Address: call to non-contract");
471 
472         (bool success, bytes memory returndata) = target.call{value: value}(data);
473         return verifyCallResult(success, returndata, errorMessage);
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
478      * but performing a static call.
479      *
480      * _Available since v3.3._
481      */
482     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
483         return functionStaticCall(target, data, "Address: low-level static call failed");
484     }
485 
486     /**
487      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
488      * but performing a static call.
489      *
490      * _Available since v3.3._
491      */
492     function functionStaticCall(
493         address target,
494         bytes memory data,
495         string memory errorMessage
496     ) internal view returns (bytes memory) {
497         require(isContract(target), "Address: static call to non-contract");
498 
499         (bool success, bytes memory returndata) = target.staticcall(data);
500         return verifyCallResult(success, returndata, errorMessage);
501     }
502 
503     /**
504      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
505      * but performing a delegate call.
506      *
507      * _Available since v3.4._
508      */
509     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
510         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
511     }
512 
513     /**
514      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
515      * but performing a delegate call.
516      *
517      * _Available since v3.4._
518      */
519     function functionDelegateCall(
520         address target,
521         bytes memory data,
522         string memory errorMessage
523     ) internal returns (bytes memory) {
524         require(isContract(target), "Address: delegate call to non-contract");
525 
526         (bool success, bytes memory returndata) = target.delegatecall(data);
527         return verifyCallResult(success, returndata, errorMessage);
528     }
529 
530     /**
531      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
532      * revert reason using the provided one.
533      *
534      * _Available since v4.3._
535      */
536     function verifyCallResult(
537         bool success,
538         bytes memory returndata,
539         string memory errorMessage
540     ) internal pure returns (bytes memory) {
541         if (success) {
542             return returndata;
543         } else {
544             // Look for revert reason and bubble it up if present
545             if (returndata.length > 0) {
546                 // The easiest way to bubble the revert reason is using memory via assembly
547 
548                 assembly {
549                     let returndata_size := mload(returndata)
550                     revert(add(32, returndata), returndata_size)
551                 }
552             } else {
553                 revert(errorMessage);
554             }
555         }
556     }
557 }
558 
559 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
560 
561 
562 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
563 
564 pragma solidity ^0.8.0;
565 
566 
567 
568 /**
569  * @title SafeERC20
570  * @dev Wrappers around ERC20 operations that throw on failure (when the token
571  * contract returns false). Tokens that return no value (and instead revert or
572  * throw on failure) are also supported, non-reverting calls are assumed to be
573  * successful.
574  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
575  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
576  */
577 library SafeERC20 {
578     using Address for address;
579 
580     function safeTransfer(
581         IERC20 token,
582         address to,
583         uint256 value
584     ) internal {
585         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
586     }
587 
588     function safeTransferFrom(
589         IERC20 token,
590         address from,
591         address to,
592         uint256 value
593     ) internal {
594         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
595     }
596 
597     /**
598      * @dev Deprecated. This function has issues similar to the ones found in
599      * {IERC20-approve}, and its usage is discouraged.
600      *
601      * Whenever possible, use {safeIncreaseAllowance} and
602      * {safeDecreaseAllowance} instead.
603      */
604     function safeApprove(
605         IERC20 token,
606         address spender,
607         uint256 value
608     ) internal {
609         // safeApprove should only be called when setting an initial allowance,
610         // or when resetting it to zero. To increase and decrease it, use
611         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
612         require(
613             (value == 0) || (token.allowance(address(this), spender) == 0),
614             "SafeERC20: approve from non-zero to non-zero allowance"
615         );
616         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
617     }
618 
619     function safeIncreaseAllowance(
620         IERC20 token,
621         address spender,
622         uint256 value
623     ) internal {
624         uint256 newAllowance = token.allowance(address(this), spender) + value;
625         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
626     }
627 
628     function safeDecreaseAllowance(
629         IERC20 token,
630         address spender,
631         uint256 value
632     ) internal {
633         unchecked {
634             uint256 oldAllowance = token.allowance(address(this), spender);
635             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
636             uint256 newAllowance = oldAllowance - value;
637             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
638         }
639     }
640 
641     /**
642      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
643      * on the return value: the return value is optional (but if data is returned, it must not be false).
644      * @param token The token targeted by the call.
645      * @param data The call data (encoded using abi.encode or one of its variants).
646      */
647     function _callOptionalReturn(IERC20 token, bytes memory data) private {
648         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
649         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
650         // the target address contains contract code and also asserts for success in the low-level call.
651 
652         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
653         if (returndata.length > 0) {
654             // Return data is optional
655             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
656         }
657     }
658 }
659 
660 
661 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
662 
663 
664 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
665 
666 pragma solidity ^0.8.0;
667 
668 /**
669  * @title ERC721 token receiver interface
670  * @dev Interface for any contract that wants to support safeTransfers
671  * from ERC721 asset contracts.
672  */
673 interface IERC721Receiver {
674     /**
675      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
676      * by `operator` from `from`, this function is called.
677      *
678      * It must return its Solidity selector to confirm the token transfer.
679      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
680      *
681      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
682      */
683     function onERC721Received(
684         address operator,
685         address from,
686         uint256 tokenId,
687         bytes calldata data
688     ) external returns (bytes4);
689 }
690 
691 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
692 
693 
694 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
695 
696 pragma solidity ^0.8.0;
697 
698 /**
699  * @dev Interface of the ERC165 standard, as defined in the
700  * https://eips.ethereum.org/EIPS/eip-165[EIP].
701  *
702  * Implementers can declare support of contract interfaces, which can then be
703  * queried by others ({ERC165Checker}).
704  *
705  * For an implementation, see {ERC165}.
706  */
707 interface IERC165 {
708     /**
709      * @dev Returns true if this contract implements the interface defined by
710      * `interfaceId`. See the corresponding
711      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
712      * to learn more about how these ids are created.
713      *
714      * This function call must use less than 30 000 gas.
715      */
716     function supportsInterface(bytes4 interfaceId) external view returns (bool);
717 }
718 
719 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
720 
721 
722 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
723 
724 pragma solidity ^0.8.0;
725 
726 
727 /**
728  * @dev Implementation of the {IERC165} interface.
729  *
730  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
731  * for the additional interface id that will be supported. For example:
732  *
733  * ```solidity
734  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
735  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
736  * }
737  * ```
738  *
739  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
740  */
741 abstract contract ERC165 is IERC165 {
742     /**
743      * @dev See {IERC165-supportsInterface}.
744      */
745     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
746         return interfaceId == type(IERC165).interfaceId;
747     }
748 }
749 
750 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
751 
752 
753 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
754 
755 pragma solidity ^0.8.0;
756 
757 
758 /**
759  * @dev Required interface of an ERC721 compliant contract.
760  */
761 interface IERC721 is IERC165 {
762     /**
763      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
764      */
765     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
766 
767     /**
768      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
769      */
770     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
771 
772     /**
773      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
774      */
775     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
776 
777     /**
778      * @dev Returns the number of tokens in ``owner``'s account.
779      */
780     function balanceOf(address owner) external view returns (uint256 balance);
781 
782     /**
783      * @dev Returns the owner of the `tokenId` token.
784      *
785      * Requirements:
786      *
787      * - `tokenId` must exist.
788      */
789     function ownerOf(uint256 tokenId) external view returns (address owner);
790 
791     /**
792      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
793      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
794      *
795      * Requirements:
796      *
797      * - `from` cannot be the zero address.
798      * - `to` cannot be the zero address.
799      * - `tokenId` token must exist and be owned by `from`.
800      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
801      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
802      *
803      * Emits a {Transfer} event.
804      */
805     function safeTransferFrom(
806         address from,
807         address to,
808         uint256 tokenId
809     ) external;
810 
811     /**
812      * @dev Transfers `tokenId` token from `from` to `to`.
813      *
814      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
815      *
816      * Requirements:
817      *
818      * - `from` cannot be the zero address.
819      * - `to` cannot be the zero address.
820      * - `tokenId` token must be owned by `from`.
821      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
822      *
823      * Emits a {Transfer} event.
824      */
825     function transferFrom(
826         address from,
827         address to,
828         uint256 tokenId
829     ) external;
830 
831     /**
832      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
833      * The approval is cleared when the token is transferred.
834      *
835      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
836      *
837      * Requirements:
838      *
839      * - The caller must own the token or be an approved operator.
840      * - `tokenId` must exist.
841      *
842      * Emits an {Approval} event.
843      */
844     function approve(address to, uint256 tokenId) external;
845 
846     /**
847      * @dev Returns the account approved for `tokenId` token.
848      *
849      * Requirements:
850      *
851      * - `tokenId` must exist.
852      */
853     function getApproved(uint256 tokenId) external view returns (address operator);
854 
855     /**
856      * @dev Approve or remove `operator` as an operator for the caller.
857      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
858      *
859      * Requirements:
860      *
861      * - The `operator` cannot be the caller.
862      *
863      * Emits an {ApprovalForAll} event.
864      */
865     function setApprovalForAll(address operator, bool _approved) external;
866 
867     /**
868      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
869      *
870      * See {setApprovalForAll}
871      */
872     function isApprovedForAll(address owner, address operator) external view returns (bool);
873 
874     /**
875      * @dev Safely transfers `tokenId` token from `from` to `to`.
876      *
877      * Requirements:
878      *
879      * - `from` cannot be the zero address.
880      * - `to` cannot be the zero address.
881      * - `tokenId` token must exist and be owned by `from`.
882      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
883      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
884      *
885      * Emits a {Transfer} event.
886      */
887     function safeTransferFrom(
888         address from,
889         address to,
890         uint256 tokenId,
891         bytes calldata data
892     ) external;
893 }
894 
895 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
896 
897 
898 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
899 
900 pragma solidity ^0.8.0;
901 
902 
903 /**
904  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
905  * @dev See https://eips.ethereum.org/EIPS/eip-721
906  */
907 interface IERC721Enumerable is IERC721 {
908     /**
909      * @dev Returns the total amount of tokens stored by the contract.
910      */
911     function totalSupply() external view returns (uint256);
912 
913     /**
914      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
915      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
916      */
917     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
918 
919     /**
920      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
921      * Use along with {totalSupply} to enumerate all tokens.
922      */
923     function tokenByIndex(uint256 index) external view returns (uint256);
924 }
925 
926 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
927 
928 
929 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
930 
931 pragma solidity ^0.8.0;
932 
933 
934 /**
935  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
936  * @dev See https://eips.ethereum.org/EIPS/eip-721
937  */
938 interface IERC721Metadata is IERC721 {
939     /**
940      * @dev Returns the token collection name.
941      */
942     function name() external view returns (string memory);
943 
944     /**
945      * @dev Returns the token collection symbol.
946      */
947     function symbol() external view returns (string memory);
948 
949     /**
950      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
951      */
952     function tokenURI(uint256 tokenId) external view returns (string memory);
953 }
954 
955 // File: contracts/TwistedToonz.sol
956 
957 
958 // Creator: Chiru Labs
959 
960 pragma solidity ^0.8.0;
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
1446 contract SurrealOkayBears is ERC721A, Ownable, ReentrancyGuard {
1447 
1448   string public        baseURI;
1449   uint public          price             = 0.0069 ether;
1450   uint public          maxPerTx          = 30;
1451   uint public          maxPerWallet      = 10;
1452   uint public          totalFree         = 1000;
1453   uint public          maxSupply         = 5000;
1454   uint public          nextOwnerToExplicitlySet;
1455   bool public          mintEnabled;
1456 
1457   constructor() ERC721A("SurrealOkayBears", "SOB"){}
1458 
1459   function mint(uint256 amt) external payable
1460   {
1461     uint cost = price;
1462     if(totalSupply() + amt < totalFree + 1) {
1463       cost = 0;
1464     }
1465     require(msg.sender == tx.origin,"Be yourself, honey.");
1466     require(msg.value == amt * cost,"Please send the exact amount.");
1467     require(totalSupply() + amt < maxSupply + 1,"No more bears");
1468     require(mintEnabled, "Minting is not live yet, hold on bear.");
1469     require(numberMinted(msg.sender) + amt <= maxPerWallet,"Too many per wallet!");
1470     require( amt < maxPerTx + 1, "Max per TX reached.");
1471 
1472     _safeMint(msg.sender, amt);
1473   }
1474 
1475   function ownerBatchMint(uint256 amt) external onlyOwner
1476   {
1477     require(totalSupply() + amt < maxSupply + 1,"too many!");
1478 
1479     _safeMint(msg.sender, amt);
1480   }
1481 
1482   function toggleMinting() external onlyOwner {
1483       mintEnabled = !mintEnabled;
1484   }
1485 
1486   function setMaxTokensPerWallet(uint8 _maxTokensPerWallet) external onlyOwner {
1487         maxPerWallet = _maxTokensPerWallet;
1488     }
1489 
1490     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1491     maxPerTx = _maxMintAmountPerTx;
1492   }
1493 
1494   function costCheck() public view returns (uint256 _cost) {
1495       if(totalSupply() < totalFree)
1496         return 0;
1497       else 
1498          return price;
1499   }
1500 
1501   function numberMinted(address owner) public view returns (uint256) {
1502     return _numberMinted(owner);
1503   }
1504 
1505   function setBaseURI(string calldata baseURI_) external onlyOwner {
1506     baseURI = baseURI_;
1507   }
1508 
1509   function setPrice(uint256 price_) external onlyOwner {
1510       price = price_;
1511   }
1512 
1513   function setTotalFree(uint256 totalFree_) external onlyOwner {
1514       totalFree = totalFree_;
1515   }
1516 
1517   function setMaxPerTx(uint256 maxPerTx_) external onlyOwner {
1518       maxPerTx = maxPerTx_;
1519   }
1520 
1521   function setMaxPerWallet(uint256 maxPerWallet_) external onlyOwner {
1522       maxPerWallet = maxPerWallet_;
1523   }
1524 
1525   function setmaxSupply(uint256 maxSupply_) external onlyOwner {
1526       maxSupply = maxSupply_;
1527   }
1528 
1529   function _baseURI() internal view virtual override returns (string memory) {
1530     return baseURI;
1531   }
1532 
1533   function withdraw() external onlyOwner nonReentrant {
1534     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1535     require(success, "Transfer failed.");
1536   }
1537 
1538   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1539     _setOwnersExplicit(quantity);
1540   }
1541 
1542   function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory)
1543   {
1544     return ownershipOf(tokenId);
1545   }
1546 
1547 
1548   /**
1549     * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1550     */
1551   function _setOwnersExplicit(uint256 quantity) internal {
1552       require(quantity != 0, "quantity must be nonzero");
1553       require(currentIndex != 0, "no tokens minted yet");
1554       uint256 _nextOwnerToExplicitlySet = nextOwnerToExplicitlySet;
1555       require(_nextOwnerToExplicitlySet < currentIndex, "all ownerships have been set");
1556 
1557       // Index underflow is impossible.
1558       // Counter or index overflow is incredibly unrealistic.
1559       unchecked {
1560           uint256 endIndex = _nextOwnerToExplicitlySet + quantity - 1;
1561 
1562           // Set the end index to be the last token index
1563           if (endIndex + 1 > currentIndex) {
1564               endIndex = currentIndex - 1;
1565           }
1566 
1567           for (uint256 i = _nextOwnerToExplicitlySet; i <= endIndex; i++) {
1568               if (_ownerships[i].addr == address(0)) {
1569                   TokenOwnership memory ownership = ownershipOf(i);
1570                   _ownerships[i].addr = ownership.addr;
1571                   _ownerships[i].startTimestamp = ownership.startTimestamp;
1572               }
1573           }
1574 
1575           nextOwnerToExplicitlySet = endIndex + 1;
1576       }
1577   }
1578 }