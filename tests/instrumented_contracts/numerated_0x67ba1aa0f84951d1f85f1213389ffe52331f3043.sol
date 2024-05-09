1 // SPDX-License-Identifier: MIT
2 
3 /**
4  * @title NotAptomingos contract
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
962 
963 
964 
965 
966 
967 
968 
969 
970 /**
971  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
972  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
973  *
974  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
975  *
976  * Does not support burning tokens to address(0).
977  *
978  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
979  */
980 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
981     using Address for address;
982     using Strings for uint256;
983 
984     struct TokenOwnership {
985         address addr;
986         uint64 startTimestamp;
987     }
988 
989     struct AddressData {
990         uint128 balance;
991         uint128 numberMinted;
992     }
993 
994     uint256 internal currentIndex;
995 
996     // Token name
997     string private _name;
998 
999     // Token symbol
1000     string private _symbol;
1001 
1002     // Mapping from token ID to ownership details
1003     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1004     mapping(uint256 => TokenOwnership) internal _ownerships;
1005 
1006     // Mapping owner address to address data
1007     mapping(address => AddressData) private _addressData;
1008 
1009     // Mapping from token ID to approved address
1010     mapping(uint256 => address) private _tokenApprovals;
1011 
1012     // Mapping from owner to operator approvals
1013     mapping(address => mapping(address => bool)) private _operatorApprovals;
1014 
1015     constructor(string memory name_, string memory symbol_) {
1016         _name = name_;
1017         _symbol = symbol_;
1018     }
1019 
1020     /**
1021      * @dev See {IERC721Enumerable-totalSupply}.
1022      */
1023     function totalSupply() public view override returns (uint256) {
1024         return currentIndex;
1025     }
1026 
1027     /**
1028      * @dev See {IERC721Enumerable-tokenByIndex}.
1029      */
1030     function tokenByIndex(uint256 index) public view override returns (uint256) {
1031         require(index < totalSupply(), "ERC721A: global index out of bounds");
1032         return index;
1033     }
1034 
1035     /**
1036      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1037      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1038      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1039      */
1040     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1041         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1042         uint256 numMintedSoFar = totalSupply();
1043         uint256 tokenIdsIdx;
1044         address currOwnershipAddr;
1045 
1046         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1047         unchecked {
1048             for (uint256 i; i < numMintedSoFar; i++) {
1049                 TokenOwnership memory ownership = _ownerships[i];
1050                 if (ownership.addr != address(0)) {
1051                     currOwnershipAddr = ownership.addr;
1052                 }
1053                 if (currOwnershipAddr == owner) {
1054                     if (tokenIdsIdx == index) {
1055                         return i;
1056                     }
1057                     tokenIdsIdx++;
1058                 }
1059             }
1060         }
1061 
1062         revert("ERC721A: unable to get token of owner by index");
1063     }
1064 
1065     /**
1066      * @dev See {IERC165-supportsInterface}.
1067      */
1068     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1069         return
1070             interfaceId == type(IERC721).interfaceId ||
1071             interfaceId == type(IERC721Metadata).interfaceId ||
1072             interfaceId == type(IERC721Enumerable).interfaceId ||
1073             super.supportsInterface(interfaceId);
1074     }
1075 
1076     /**
1077      * @dev See {IERC721-balanceOf}.
1078      */
1079     function balanceOf(address owner) public view override returns (uint256) {
1080         require(owner != address(0), "ERC721A: balance query for the zero address");
1081         return uint256(_addressData[owner].balance);
1082     }
1083 
1084     function _numberMinted(address owner) internal view returns (uint256) {
1085         require(owner != address(0), "ERC721A: number minted query for the zero address");
1086         return uint256(_addressData[owner].numberMinted);
1087     }
1088 
1089     /**
1090      * Gas spent here starts off proportional to the maximum mint batch size.
1091      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1092      */
1093     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1094         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1095 
1096         unchecked {
1097             for (uint256 curr = tokenId; curr >= 0; curr--) {
1098                 TokenOwnership memory ownership = _ownerships[curr];
1099                 if (ownership.addr != address(0)) {
1100                     return ownership;
1101                 }
1102             }
1103         }
1104 
1105         revert("ERC721A: unable to determine the owner of token");
1106     }
1107 
1108     /**
1109      * @dev See {IERC721-ownerOf}.
1110      */
1111     function ownerOf(uint256 tokenId) public view override returns (address) {
1112         return ownershipOf(tokenId).addr;
1113     }
1114 
1115     /**
1116      * @dev See {IERC721Metadata-name}.
1117      */
1118     function name() public view virtual override returns (string memory) {
1119         return _name;
1120     }
1121 
1122     /**
1123      * @dev See {IERC721Metadata-symbol}.
1124      */
1125     function symbol() public view virtual override returns (string memory) {
1126         return _symbol;
1127     }
1128 
1129     /**
1130      * @dev See {IERC721Metadata-tokenURI}.
1131      */
1132     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1133         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1134 
1135         string memory baseURI = _baseURI();
1136         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
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
1454 contract NotAptomingos is ERC721A, Ownable, ReentrancyGuard {
1455 
1456   string public        baseURI;
1457   uint public          price             = 0.001 ether;
1458   uint public          maxPerTx          = 10;
1459   uint public          maxFreePerWallet  = 2;
1460   uint public          totalFree         = 1212;
1461   uint public          maxSupply         = 1212;
1462   uint public          nextOwnerToExplicitlySet;
1463   bool public          mintEnabled;
1464 
1465   constructor() ERC721A("NotAptomingos", "NotAptomingo"){}
1466 
1467     modifier callerIsUser() {
1468         require(tx.origin == msg.sender, "The caller is another contract");
1469         _;
1470     }
1471 
1472    function freeMint(uint256 amt) external callerIsUser {
1473     require(mintEnabled, "Public sale has not begun yet");
1474     require(totalSupply() + amt <= totalFree, "Reached max free supply");
1475     require(amt <= 10, "can not mint this many free at a time");
1476     require(numberMinted(msg.sender) + amt <= maxFreePerWallet,"Too many free per wallet!");
1477     _safeMint(msg.sender, amt);
1478     }
1479 
1480   function mint(uint256 amt) external payable
1481   {
1482     uint cost = price;
1483     require(msg.sender == tx.origin,"The caller is another contract");
1484     require(msg.value >= amt * cost,"Please send the exact amount.");
1485     require(totalSupply() + amt < maxSupply + 1,"Reached max supply");
1486     require(mintEnabled, "Public sale has not begun yet");
1487     require( amt < maxPerTx + 1, "Max per TX reached.");
1488 
1489     _safeMint(msg.sender, amt);
1490   }
1491 
1492 
1493   function ownerMint(uint256 amt) external onlyOwner
1494   {
1495     require(totalSupply() + amt < maxSupply + 1,"too many!");
1496 
1497     _safeMint(msg.sender, amt);
1498   }
1499 
1500   function toggleMinting() external onlyOwner {
1501       mintEnabled = !mintEnabled;
1502   }
1503 
1504   function numberMinted(address owner) public view returns (uint256) {
1505     return _numberMinted(owner);
1506   }
1507 
1508   function setBaseURI(string calldata baseURI_) external onlyOwner {
1509     baseURI = baseURI_;
1510   }
1511 
1512   function setPrice(uint256 price_) external onlyOwner {
1513       price = price_;
1514   }
1515 
1516   function setTotalFree(uint256 totalFree_) external onlyOwner {
1517       totalFree = totalFree_;
1518   }
1519 
1520   function setMaxPerTx(uint256 maxPerTx_) external onlyOwner {
1521       maxPerTx = maxPerTx_;
1522   }
1523 
1524   function setMaxPerWallet(uint256 maxFreePerWallet_) external onlyOwner {
1525       maxFreePerWallet = maxFreePerWallet_;
1526   }
1527 
1528   function setmaxSupply(uint256 maxSupply_) external onlyOwner {
1529       maxSupply = maxSupply_;
1530   }
1531 
1532   function _baseURI() internal view virtual override returns (string memory) {
1533     return baseURI;
1534   }
1535 
1536   function withdraw() external onlyOwner nonReentrant {
1537     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1538     require(success, "Transfer failed.");
1539   }
1540 
1541   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1542     _setOwnersExplicit(quantity);
1543   }
1544 
1545   function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory)
1546   {
1547     return ownershipOf(tokenId);
1548   }
1549 
1550 
1551   /**
1552     * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1553     */
1554   function _setOwnersExplicit(uint256 quantity) internal {
1555       require(quantity != 0, "quantity must be nonzero");
1556       require(currentIndex != 0, "no tokens minted yet");
1557       uint256 _nextOwnerToExplicitlySet = nextOwnerToExplicitlySet;
1558       require(_nextOwnerToExplicitlySet < currentIndex, "all ownerships have been set");
1559 
1560       // Index underflow is impossible.
1561       // Counter or index overflow is incredibly unrealistic.
1562       unchecked {
1563           uint256 endIndex = _nextOwnerToExplicitlySet + quantity - 1;
1564 
1565           // Set the end index to be the last token index
1566           if (endIndex + 1 > currentIndex) {
1567               endIndex = currentIndex - 1;
1568           }
1569 
1570           for (uint256 i = _nextOwnerToExplicitlySet; i <= endIndex; i++) {
1571               if (_ownerships[i].addr == address(0)) {
1572                   TokenOwnership memory ownership = ownershipOf(i);
1573                   _ownerships[i].addr = ownership.addr;
1574                   _ownerships[i].startTimestamp = ownership.startTimestamp;
1575               }
1576           }
1577 
1578           nextOwnerToExplicitlySet = endIndex + 1;
1579       }
1580   }
1581 }