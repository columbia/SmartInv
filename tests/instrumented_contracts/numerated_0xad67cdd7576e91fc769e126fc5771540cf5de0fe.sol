1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC20 standard as defined in the EIP.
12  */
13 interface IERC20 {
14     /**
15      * @dev Returns the amount of tokens in existence.
16      */
17     function totalSupply() external view returns (uint256);
18 
19     /**
20      * @dev Returns the amount of tokens owned by `account`.
21      */
22     function balanceOf(address account) external view returns (uint256);
23 
24     /**
25      * @dev Moves `amount` tokens from the caller's account to `to`.
26      *
27      * Returns a boolean value indicating whether the operation succeeded.
28      *
29      * Emits a {Transfer} event.
30      */
31     function transfer(address to, uint256 amount) external returns (bool);
32 
33     /**
34      * @dev Returns the remaining number of tokens that `spender` will be
35      * allowed to spend on behalf of `owner` through {transferFrom}. This is
36      * zero by default.
37      *
38      * This value changes when {approve} or {transferFrom} are called.
39      */
40     function allowance(address owner, address spender) external view returns (uint256);
41 
42     /**
43      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * IMPORTANT: Beware that changing an allowance with this method brings the risk
48      * that someone may use both the old and the new allowance by unfortunate
49      * transaction ordering. One possible solution to mitigate this race
50      * condition is to first reduce the spender's allowance to 0 and set the
51      * desired value afterwards:
52      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53      *
54      * Emits an {Approval} event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `from` to `to` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(
68         address from,
69         address to,
70         uint256 amount
71     ) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to {approve}. `value` is the new allowance.
84      */
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
89 
90 
91 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
92 
93 pragma solidity ^0.8.0;
94 
95 /**
96  * @dev Contract module that helps prevent reentrant calls to a function.
97  *
98  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
99  * available, which can be applied to functions to make sure there are no nested
100  * (reentrant) calls to them.
101  *
102  * Note that because there is a single `nonReentrant` guard, functions marked as
103  * `nonReentrant` may not call one another. This can be worked around by making
104  * those functions `private`, and then adding `external` `nonReentrant` entry
105  * points to them.
106  *
107  * TIP: If you would like to learn more about reentrancy and alternative ways
108  * to protect against it, check out our blog post
109  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
110  */
111 abstract contract ReentrancyGuard {
112     // Booleans are more expensive than uint256 or any type that takes up a full
113     // word because each write operation emits an extra SLOAD to first read the
114     // slot's contents, replace the bits taken up by the boolean, and then write
115     // back. This is the compiler's defense against contract upgrades and
116     // pointer aliasing, and it cannot be disabled.
117 
118     // The values being non-zero value makes deployment a bit more expensive,
119     // but in exchange the refund on every call to nonReentrant will be lower in
120     // amount. Since refunds are capped to a percentage of the total
121     // transaction's gas, it is best to keep them low in cases like this one, to
122     // increase the likelihood of the full refund coming into effect.
123     uint256 private constant _NOT_ENTERED = 1;
124     uint256 private constant _ENTERED = 2;
125 
126     uint256 private _status;
127 
128     constructor() {
129         _status = _NOT_ENTERED;
130     }
131 
132     /**
133      * @dev Prevents a contract from calling itself, directly or indirectly.
134      * Calling a `nonReentrant` function from another `nonReentrant`
135      * function is not supported. It is possible to prevent this from happening
136      * by making the `nonReentrant` function external, and making it call a
137      * `private` function that does the actual work.
138      */
139     modifier nonReentrant() {
140         // On the first call to nonReentrant, _notEntered will be true
141         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
142 
143         // Any calls to nonReentrant after this point will fail
144         _status = _ENTERED;
145 
146         _;
147 
148         // By storing the original value once again, a refund is triggered (see
149         // https://eips.ethereum.org/EIPS/eip-2200)
150         _status = _NOT_ENTERED;
151     }
152 }
153 
154 // File: @openzeppelin/contracts/utils/Strings.sol
155 
156 
157 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
158 
159 pragma solidity ^0.8.0;
160 
161 /**
162  * @dev String operations.
163  */
164 library Strings {
165     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
166 
167     /**
168      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
169      */
170     function toString(uint256 value) internal pure returns (string memory) {
171         // Inspired by OraclizeAPI's implementation - MIT licence
172         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
173 
174         if (value == 0) {
175             return "0";
176         }
177         uint256 temp = value;
178         uint256 digits;
179         while (temp != 0) {
180             digits++;
181             temp /= 10;
182         }
183         bytes memory buffer = new bytes(digits);
184         while (value != 0) {
185             digits -= 1;
186             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
187             value /= 10;
188         }
189         return string(buffer);
190     }
191 
192     /**
193      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
194      */
195     function toHexString(uint256 value) internal pure returns (string memory) {
196         if (value == 0) {
197             return "0x00";
198         }
199         uint256 temp = value;
200         uint256 length = 0;
201         while (temp != 0) {
202             length++;
203             temp >>= 8;
204         }
205         return toHexString(value, length);
206     }
207 
208     /**
209      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
210      */
211     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
212         bytes memory buffer = new bytes(2 * length + 2);
213         buffer[0] = "0";
214         buffer[1] = "x";
215         for (uint256 i = 2 * length + 1; i > 1; --i) {
216             buffer[i] = _HEX_SYMBOLS[value & 0xf];
217             value >>= 4;
218         }
219         require(value == 0, "Strings: hex length insufficient");
220         return string(buffer);
221     }
222 }
223 
224 // File: @openzeppelin/contracts/utils/Context.sol
225 
226 
227 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
228 
229 pragma solidity ^0.8.0;
230 
231 /**
232  * @dev Provides information about the current execution context, including the
233  * sender of the transaction and its data. While these are generally available
234  * via msg.sender and msg.data, they should not be accessed in such a direct
235  * manner, since when dealing with meta-transactions the account sending and
236  * paying for execution may not be the actual sender (as far as an application
237  * is concerned).
238  *
239  * This contract is only required for intermediate, library-like contracts.
240  */
241 abstract contract Context {
242     function _msgSender() internal view virtual returns (address) {
243         return msg.sender;
244     }
245 
246     function _msgData() internal view virtual returns (bytes calldata) {
247         return msg.data;
248     }
249 }
250 
251 // File: @openzeppelin/contracts/access/Ownable.sol
252 
253 
254 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
255 
256 pragma solidity ^0.8.0;
257 
258 
259 /**
260  * @dev Contract module which provides a basic access control mechanism, where
261  * there is an account (an owner) that can be granted exclusive access to
262  * specific functions.
263  *
264  * By default, the owner account will be the one that deploys the contract. This
265  * can later be changed with {transferOwnership}.
266  *
267  * This module is used through inheritance. It will make available the modifier
268  * `onlyOwner`, which can be applied to your functions to restrict their use to
269  * the owner.
270  */
271 abstract contract Ownable is Context {
272     address private _owner;
273 
274     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
275 
276     /**
277      * @dev Initializes the contract setting the deployer as the initial owner.
278      */
279     constructor() {
280         _transferOwnership(_msgSender());
281     }
282 
283     /**
284      * @dev Returns the address of the current owner.
285      */
286     function owner() public view virtual returns (address) {
287         return _owner;
288     }
289 
290     /**
291      * @dev Throws if called by any account other than the owner.
292      */
293     modifier onlyOwner() {
294         require(owner() == _msgSender(), "Ownable: caller is not the owner");
295         _;
296     }
297 
298     /**
299      * @dev Leaves the contract without owner. It will not be possible to call
300      * `onlyOwner` functions anymore. Can only be called by the current owner.
301      *
302      * NOTE: Renouncing ownership will leave the contract without an owner,
303      * thereby removing any functionality that is only available to the owner.
304      */
305     function renounceOwnership() public virtual onlyOwner {
306         _transferOwnership(address(0));
307     }
308 
309     /**
310      * @dev Transfers ownership of the contract to a new account (`newOwner`).
311      * Can only be called by the current owner.
312      */
313     function transferOwnership(address newOwner) public virtual onlyOwner {
314         require(newOwner != address(0), "Ownable: new owner is the zero address");
315         _transferOwnership(newOwner);
316     }
317 
318     /**
319      * @dev Transfers ownership of the contract to a new account (`newOwner`).
320      * Internal function without access restriction.
321      */
322     function _transferOwnership(address newOwner) internal virtual {
323         address oldOwner = _owner;
324         _owner = newOwner;
325         emit OwnershipTransferred(oldOwner, newOwner);
326     }
327 }
328 
329 // File: @openzeppelin/contracts/utils/Address.sol
330 
331 
332 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
333 
334 pragma solidity ^0.8.1;
335 
336 /**
337  * @dev Collection of functions related to the address type
338  */
339 library Address {
340     /**
341      * @dev Returns true if `account` is a contract.
342      *
343      * [IMPORTANT]
344      * ====
345      * It is unsafe to assume that an address for which this function returns
346      * false is an externally-owned account (EOA) and not a contract.
347      *
348      * Among others, `isContract` will return false for the following
349      * types of addresses:
350      *
351      *  - an externally-owned account
352      *  - a contract in construction
353      *  - an address where a contract will be created
354      *  - an address where a contract lived, but was destroyed
355      * ====
356      *
357      * [IMPORTANT]
358      * ====
359      * You shouldn't rely on `isContract` to protect against flash loan attacks!
360      *
361      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
362      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
363      * constructor.
364      * ====
365      */
366     function isContract(address account) internal view returns (bool) {
367         // This method relies on extcodesize/address.code.length, which returns 0
368         // for contracts in construction, since the code is only stored at the end
369         // of the constructor execution.
370 
371         return account.code.length > 0;
372     }
373 
374     /**
375      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
376      * `recipient`, forwarding all available gas and reverting on errors.
377      *
378      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
379      * of certain opcodes, possibly making contracts go over the 2300 gas limit
380      * imposed by `transfer`, making them unable to receive funds via
381      * `transfer`. {sendValue} removes this limitation.
382      *
383      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
384      *
385      * IMPORTANT: because control is transferred to `recipient`, care must be
386      * taken to not create reentrancy vulnerabilities. Consider using
387      * {ReentrancyGuard} or the
388      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
389      */
390     function sendValue(address payable recipient, uint256 amount) internal {
391         require(address(this).balance >= amount, "Address: insufficient balance");
392 
393         (bool success, ) = recipient.call{value: amount}("");
394         require(success, "Address: unable to send value, recipient may have reverted");
395     }
396 
397     /**
398      * @dev Performs a Solidity function call using a low level `call`. A
399      * plain `call` is an unsafe replacement for a function call: use this
400      * function instead.
401      *
402      * If `target` reverts with a revert reason, it is bubbled up by this
403      * function (like regular Solidity function calls).
404      *
405      * Returns the raw returned data. To convert to the expected return value,
406      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
407      *
408      * Requirements:
409      *
410      * - `target` must be a contract.
411      * - calling `target` with `data` must not revert.
412      *
413      * _Available since v3.1._
414      */
415     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
416         return functionCall(target, data, "Address: low-level call failed");
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
421      * `errorMessage` as a fallback revert reason when `target` reverts.
422      *
423      * _Available since v3.1._
424      */
425     function functionCall(
426         address target,
427         bytes memory data,
428         string memory errorMessage
429     ) internal returns (bytes memory) {
430         return functionCallWithValue(target, data, 0, errorMessage);
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
435      * but also transferring `value` wei to `target`.
436      *
437      * Requirements:
438      *
439      * - the calling contract must have an ETH balance of at least `value`.
440      * - the called Solidity function must be `payable`.
441      *
442      * _Available since v3.1._
443      */
444     function functionCallWithValue(
445         address target,
446         bytes memory data,
447         uint256 value
448     ) internal returns (bytes memory) {
449         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
454      * with `errorMessage` as a fallback revert reason when `target` reverts.
455      *
456      * _Available since v3.1._
457      */
458     function functionCallWithValue(
459         address target,
460         bytes memory data,
461         uint256 value,
462         string memory errorMessage
463     ) internal returns (bytes memory) {
464         require(address(this).balance >= value, "Address: insufficient balance for call");
465         require(isContract(target), "Address: call to non-contract");
466 
467         (bool success, bytes memory returndata) = target.call{value: value}(data);
468         return verifyCallResult(success, returndata, errorMessage);
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
473      * but performing a static call.
474      *
475      * _Available since v3.3._
476      */
477     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
478         return functionStaticCall(target, data, "Address: low-level static call failed");
479     }
480 
481     /**
482      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
483      * but performing a static call.
484      *
485      * _Available since v3.3._
486      */
487     function functionStaticCall(
488         address target,
489         bytes memory data,
490         string memory errorMessage
491     ) internal view returns (bytes memory) {
492         require(isContract(target), "Address: static call to non-contract");
493 
494         (bool success, bytes memory returndata) = target.staticcall(data);
495         return verifyCallResult(success, returndata, errorMessage);
496     }
497 
498     /**
499      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
500      * but performing a delegate call.
501      *
502      * _Available since v3.4._
503      */
504     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
505         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
506     }
507 
508     /**
509      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
510      * but performing a delegate call.
511      *
512      * _Available since v3.4._
513      */
514     function functionDelegateCall(
515         address target,
516         bytes memory data,
517         string memory errorMessage
518     ) internal returns (bytes memory) {
519         require(isContract(target), "Address: delegate call to non-contract");
520 
521         (bool success, bytes memory returndata) = target.delegatecall(data);
522         return verifyCallResult(success, returndata, errorMessage);
523     }
524 
525     /**
526      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
527      * revert reason using the provided one.
528      *
529      * _Available since v4.3._
530      */
531     function verifyCallResult(
532         bool success,
533         bytes memory returndata,
534         string memory errorMessage
535     ) internal pure returns (bytes memory) {
536         if (success) {
537             return returndata;
538         } else {
539             // Look for revert reason and bubble it up if present
540             if (returndata.length > 0) {
541                 // The easiest way to bubble the revert reason is using memory via assembly
542 
543                 assembly {
544                     let returndata_size := mload(returndata)
545                     revert(add(32, returndata), returndata_size)
546                 }
547             } else {
548                 revert(errorMessage);
549             }
550         }
551     }
552 }
553 
554 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
555 
556 
557 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
558 
559 pragma solidity ^0.8.0;
560 
561 
562 
563 /**
564  * @title SafeERC20
565  * @dev Wrappers around ERC20 operations that throw on failure (when the token
566  * contract returns false). Tokens that return no value (and instead revert or
567  * throw on failure) are also supported, non-reverting calls are assumed to be
568  * successful.
569  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
570  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
571  */
572 library SafeERC20 {
573     using Address for address;
574 
575     function safeTransfer(
576         IERC20 token,
577         address to,
578         uint256 value
579     ) internal {
580         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
581     }
582 
583     function safeTransferFrom(
584         IERC20 token,
585         address from,
586         address to,
587         uint256 value
588     ) internal {
589         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
590     }
591 
592     /**
593      * @dev Deprecated. This function has issues similar to the ones found in
594      * {IERC20-approve}, and its usage is discouraged.
595      *
596      * Whenever possible, use {safeIncreaseAllowance} and
597      * {safeDecreaseAllowance} instead.
598      */
599     function safeApprove(
600         IERC20 token,
601         address spender,
602         uint256 value
603     ) internal {
604         // safeApprove should only be called when setting an initial allowance,
605         // or when resetting it to zero. To increase and decrease it, use
606         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
607         require(
608             (value == 0) || (token.allowance(address(this), spender) == 0),
609             "SafeERC20: approve from non-zero to non-zero allowance"
610         );
611         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
612     }
613 
614     function safeIncreaseAllowance(
615         IERC20 token,
616         address spender,
617         uint256 value
618     ) internal {
619         uint256 newAllowance = token.allowance(address(this), spender) + value;
620         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
621     }
622 
623     function safeDecreaseAllowance(
624         IERC20 token,
625         address spender,
626         uint256 value
627     ) internal {
628         unchecked {
629             uint256 oldAllowance = token.allowance(address(this), spender);
630             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
631             uint256 newAllowance = oldAllowance - value;
632             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
633         }
634     }
635 
636     /**
637      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
638      * on the return value: the return value is optional (but if data is returned, it must not be false).
639      * @param token The token targeted by the call.
640      * @param data The call data (encoded using abi.encode or one of its variants).
641      */
642     function _callOptionalReturn(IERC20 token, bytes memory data) private {
643         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
644         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
645         // the target address contains contract code and also asserts for success in the low-level call.
646 
647         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
648         if (returndata.length > 0) {
649             // Return data is optional
650             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
651         }
652     }
653 }
654 
655 
656 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
657 
658 
659 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
660 
661 pragma solidity ^0.8.0;
662 
663 /**
664  * @title ERC721 token receiver interface
665  * @dev Interface for any contract that wants to support safeTransfers
666  * from ERC721 asset contracts.
667  */
668 interface IERC721Receiver {
669     /**
670      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
671      * by `operator` from `from`, this function is called.
672      *
673      * It must return its Solidity selector to confirm the token transfer.
674      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
675      *
676      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
677      */
678     function onERC721Received(
679         address operator,
680         address from,
681         uint256 tokenId,
682         bytes calldata data
683     ) external returns (bytes4);
684 }
685 
686 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
687 
688 
689 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
690 
691 pragma solidity ^0.8.0;
692 
693 /**
694  * @dev Interface of the ERC165 standard, as defined in the
695  * https://eips.ethereum.org/EIPS/eip-165[EIP].
696  *
697  * Implementers can declare support of contract interfaces, which can then be
698  * queried by others ({ERC165Checker}).
699  *
700  * For an implementation, see {ERC165}.
701  */
702 interface IERC165 {
703     /**
704      * @dev Returns true if this contract implements the interface defined by
705      * `interfaceId`. See the corresponding
706      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
707      * to learn more about how these ids are created.
708      *
709      * This function call must use less than 30 000 gas.
710      */
711     function supportsInterface(bytes4 interfaceId) external view returns (bool);
712 }
713 
714 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
715 
716 
717 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
718 
719 pragma solidity ^0.8.0;
720 
721 
722 /**
723  * @dev Implementation of the {IERC165} interface.
724  *
725  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
726  * for the additional interface id that will be supported. For example:
727  *
728  * ```solidity
729  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
730  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
731  * }
732  * ```
733  *
734  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
735  */
736 abstract contract ERC165 is IERC165 {
737     /**
738      * @dev See {IERC165-supportsInterface}.
739      */
740     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
741         return interfaceId == type(IERC165).interfaceId;
742     }
743 }
744 
745 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
746 
747 
748 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
749 
750 pragma solidity ^0.8.0;
751 
752 
753 /**
754  * @dev Required interface of an ERC721 compliant contract.
755  */
756 interface IERC721 is IERC165 {
757     /**
758      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
759      */
760     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
761 
762     /**
763      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
764      */
765     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
766 
767     /**
768      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
769      */
770     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
771 
772     /**
773      * @dev Returns the number of tokens in ``owner``'s account.
774      */
775     function balanceOf(address owner) external view returns (uint256 balance);
776 
777     /**
778      * @dev Returns the owner of the `tokenId` token.
779      *
780      * Requirements:
781      *
782      * - `tokenId` must exist.
783      */
784     function ownerOf(uint256 tokenId) external view returns (address owner);
785 
786     /**
787      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
788      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
789      *
790      * Requirements:
791      *
792      * - `from` cannot be the zero address.
793      * - `to` cannot be the zero address.
794      * - `tokenId` token must exist and be owned by `from`.
795      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
796      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
797      *
798      * Emits a {Transfer} event.
799      */
800     function safeTransferFrom(
801         address from,
802         address to,
803         uint256 tokenId
804     ) external;
805 
806     /**
807      * @dev Transfers `tokenId` token from `from` to `to`.
808      *
809      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
810      *
811      * Requirements:
812      *
813      * - `from` cannot be the zero address.
814      * - `to` cannot be the zero address.
815      * - `tokenId` token must be owned by `from`.
816      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
817      *
818      * Emits a {Transfer} event.
819      */
820     function transferFrom(
821         address from,
822         address to,
823         uint256 tokenId
824     ) external;
825 
826     /**
827      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
828      * The approval is cleared when the token is transferred.
829      *
830      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
831      *
832      * Requirements:
833      *
834      * - The caller must own the token or be an approved operator.
835      * - `tokenId` must exist.
836      *
837      * Emits an {Approval} event.
838      */
839     function approve(address to, uint256 tokenId) external;
840 
841     /**
842      * @dev Returns the account approved for `tokenId` token.
843      *
844      * Requirements:
845      *
846      * - `tokenId` must exist.
847      */
848     function getApproved(uint256 tokenId) external view returns (address operator);
849 
850     /**
851      * @dev Approve or remove `operator` as an operator for the caller.
852      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
853      *
854      * Requirements:
855      *
856      * - The `operator` cannot be the caller.
857      *
858      * Emits an {ApprovalForAll} event.
859      */
860     function setApprovalForAll(address operator, bool _approved) external;
861 
862     /**
863      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
864      *
865      * See {setApprovalForAll}
866      */
867     function isApprovedForAll(address owner, address operator) external view returns (bool);
868 
869     /**
870      * @dev Safely transfers `tokenId` token from `from` to `to`.
871      *
872      * Requirements:
873      *
874      * - `from` cannot be the zero address.
875      * - `to` cannot be the zero address.
876      * - `tokenId` token must exist and be owned by `from`.
877      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
878      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
879      *
880      * Emits a {Transfer} event.
881      */
882     function safeTransferFrom(
883         address from,
884         address to,
885         uint256 tokenId,
886         bytes calldata data
887     ) external;
888 }
889 
890 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
891 
892 
893 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
894 
895 pragma solidity ^0.8.0;
896 
897 
898 /**
899  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
900  * @dev See https://eips.ethereum.org/EIPS/eip-721
901  */
902 interface IERC721Enumerable is IERC721 {
903     /**
904      * @dev Returns the total amount of tokens stored by the contract.
905      */
906     function totalSupply() external view returns (uint256);
907 
908     /**
909      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
910      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
911      */
912     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
913 
914     /**
915      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
916      * Use along with {totalSupply} to enumerate all tokens.
917      */
918     function tokenByIndex(uint256 index) external view returns (uint256);
919 }
920 
921 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
922 
923 
924 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
925 
926 pragma solidity ^0.8.0;
927 
928 
929 /**
930  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
931  * @dev See https://eips.ethereum.org/EIPS/eip-721
932  */
933 interface IERC721Metadata is IERC721 {
934     /**
935      * @dev Returns the token collection name.
936      */
937     function name() external view returns (string memory);
938 
939     /**
940      * @dev Returns the token collection symbol.
941      */
942     function symbol() external view returns (string memory);
943 
944     /**
945      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
946      */
947     function tokenURI(uint256 tokenId) external view returns (string memory);
948 }
949 
950 // File: contracts/TwistedToonz.sol
951 
952 
953 // Creator: Chiru Labs
954 
955 pragma solidity ^0.8.0;
956 
957 
958 
959 
960 
961 
962 
963 
964 
965 /**
966  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
967  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
968  *
969  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
970  *
971  * Does not support burning tokens to address(0).
972  *
973  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
974  */
975 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
976     using Address for address;
977     using Strings for uint256;
978 
979     struct TokenOwnership {
980         address addr;
981         uint64 startTimestamp;
982     }
983 
984     struct AddressData {
985         uint128 balance;
986         uint128 numberMinted;
987     }
988 
989     uint256 internal currentIndex;
990 
991     // Token name
992     string private _name;
993 
994     // Token symbol
995     string private _symbol;
996 
997     // Mapping from token ID to ownership details
998     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
999     mapping(uint256 => TokenOwnership) internal _ownerships;
1000 
1001     // Mapping owner address to address data
1002     mapping(address => AddressData) private _addressData;
1003 
1004     // Mapping from token ID to approved address
1005     mapping(uint256 => address) private _tokenApprovals;
1006 
1007     // Mapping from owner to operator approvals
1008     mapping(address => mapping(address => bool)) private _operatorApprovals;
1009 
1010     constructor(string memory name_, string memory symbol_) {
1011         _name = name_;
1012         _symbol = symbol_;
1013     }
1014 
1015     /**
1016      * @dev See {IERC721Enumerable-totalSupply}.
1017      */
1018     function totalSupply() public view override returns (uint256) {
1019         return currentIndex;
1020     }
1021 
1022     /**
1023      * @dev See {IERC721Enumerable-tokenByIndex}.
1024      */
1025     function tokenByIndex(uint256 index) public view override returns (uint256) {
1026         require(index < totalSupply(), "ERC721A: global index out of bounds");
1027         return index;
1028     }
1029 
1030     /**
1031      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1032      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1033      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1034      */
1035     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1036         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1037         uint256 numMintedSoFar = totalSupply();
1038         uint256 tokenIdsIdx;
1039         address currOwnershipAddr;
1040 
1041         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1042         unchecked {
1043             for (uint256 i; i < numMintedSoFar; i++) {
1044                 TokenOwnership memory ownership = _ownerships[i];
1045                 if (ownership.addr != address(0)) {
1046                     currOwnershipAddr = ownership.addr;
1047                 }
1048                 if (currOwnershipAddr == owner) {
1049                     if (tokenIdsIdx == index) {
1050                         return i;
1051                     }
1052                     tokenIdsIdx++;
1053                 }
1054             }
1055         }
1056 
1057         revert("ERC721A: unable to get token of owner by index");
1058     }
1059 
1060     /**
1061      * @dev See {IERC165-supportsInterface}.
1062      */
1063     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1064         return
1065             interfaceId == type(IERC721).interfaceId ||
1066             interfaceId == type(IERC721Metadata).interfaceId ||
1067             interfaceId == type(IERC721Enumerable).interfaceId ||
1068             super.supportsInterface(interfaceId);
1069     }
1070 
1071     /**
1072      * @dev See {IERC721-balanceOf}.
1073      */
1074     function balanceOf(address owner) public view override returns (uint256) {
1075         require(owner != address(0), "ERC721A: balance query for the zero address");
1076         return uint256(_addressData[owner].balance);
1077     }
1078 
1079     function _numberMinted(address owner) internal view returns (uint256) {
1080         require(owner != address(0), "ERC721A: number minted query for the zero address");
1081         return uint256(_addressData[owner].numberMinted);
1082     }
1083 
1084     /**
1085      * Gas spent here starts off proportional to the maximum mint batch size.
1086      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1087      */
1088     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1089         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1090 
1091         unchecked {
1092             for (uint256 curr = tokenId; curr >= 0; curr--) {
1093                 TokenOwnership memory ownership = _ownerships[curr];
1094                 if (ownership.addr != address(0)) {
1095                     return ownership;
1096                 }
1097             }
1098         }
1099 
1100         revert("ERC721A: unable to determine the owner of token");
1101     }
1102 
1103     /**
1104      * @dev See {IERC721-ownerOf}.
1105      */
1106     function ownerOf(uint256 tokenId) public view override returns (address) {
1107         return ownershipOf(tokenId).addr;
1108     }
1109 
1110     /**
1111      * @dev See {IERC721Metadata-name}.
1112      */
1113     function name() public view virtual override returns (string memory) {
1114         return _name;
1115     }
1116 
1117     /**
1118      * @dev See {IERC721Metadata-symbol}.
1119      */
1120     function symbol() public view virtual override returns (string memory) {
1121         return _symbol;
1122     }
1123 
1124     /**
1125      * @dev See {IERC721Metadata-tokenURI}.
1126      */
1127     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1128         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1129 
1130         string memory baseURI = _baseURI();
1131         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1132     }
1133 
1134     /**
1135      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1136      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1137      * by default, can be overriden in child contracts.
1138      */
1139     function _baseURI() internal view virtual returns (string memory) {
1140         return "";
1141     }
1142 
1143     /**
1144      * @dev See {IERC721-approve}.
1145      */
1146     function approve(address to, uint256 tokenId) public override {
1147         address owner = ERC721A.ownerOf(tokenId);
1148         require(to != owner, "ERC721A: approval to current owner");
1149 
1150         require(
1151             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1152             "ERC721A: approve caller is not owner nor approved for all"
1153         );
1154 
1155         _approve(to, tokenId, owner);
1156     }
1157 
1158     /**
1159      * @dev See {IERC721-getApproved}.
1160      */
1161     function getApproved(uint256 tokenId) public view override returns (address) {
1162         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1163 
1164         return _tokenApprovals[tokenId];
1165     }
1166 
1167     /**
1168      * @dev See {IERC721-setApprovalForAll}.
1169      */
1170     function setApprovalForAll(address operator, bool approved) public override {
1171         require(operator != _msgSender(), "ERC721A: approve to caller");
1172 
1173         _operatorApprovals[_msgSender()][operator] = approved;
1174         emit ApprovalForAll(_msgSender(), operator, approved);
1175     }
1176 
1177     /**
1178      * @dev See {IERC721-isApprovedForAll}.
1179      */
1180     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1181         return _operatorApprovals[owner][operator];
1182     }
1183 
1184     /**
1185      * @dev See {IERC721-transferFrom}.
1186      */
1187     function transferFrom(
1188         address from,
1189         address to,
1190         uint256 tokenId
1191     ) public virtual override {
1192         _transfer(from, to, tokenId);
1193     }
1194 
1195     /**
1196      * @dev See {IERC721-safeTransferFrom}.
1197      */
1198     function safeTransferFrom(
1199         address from,
1200         address to,
1201         uint256 tokenId
1202     ) public virtual override {
1203         safeTransferFrom(from, to, tokenId, "");
1204     }
1205 
1206     /**
1207      * @dev See {IERC721-safeTransferFrom}.
1208      */
1209     function safeTransferFrom(
1210         address from,
1211         address to,
1212         uint256 tokenId,
1213         bytes memory _data
1214     ) public override {
1215         _transfer(from, to, tokenId);
1216         require(
1217             _checkOnERC721Received(from, to, tokenId, _data),
1218             "ERC721A: transfer to non ERC721Receiver implementer"
1219         );
1220     }
1221 
1222     /**
1223      * @dev Returns whether `tokenId` exists.
1224      *
1225      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1226      *
1227      * Tokens start existing when they are minted (`_mint`),
1228      */
1229     function _exists(uint256 tokenId) internal view returns (bool) {
1230         return tokenId < currentIndex;
1231     }
1232 
1233     function _safeMint(address to, uint256 quantity) internal {
1234         _safeMint(to, quantity, "");
1235     }
1236 
1237     /**
1238      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1239      *
1240      * Requirements:
1241      *
1242      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1243      * - `quantity` must be greater than 0.
1244      *
1245      * Emits a {Transfer} event.
1246      */
1247     function _safeMint(
1248         address to,
1249         uint256 quantity,
1250         bytes memory _data
1251     ) internal {
1252         _mint(to, quantity, _data, true);
1253     }
1254 
1255     /**
1256      * @dev Mints `quantity` tokens and transfers them to `to`.
1257      *
1258      * Requirements:
1259      *
1260      * - `to` cannot be the zero address.
1261      * - `quantity` must be greater than 0.
1262      *
1263      * Emits a {Transfer} event.
1264      */
1265     function _mint(
1266         address to,
1267         uint256 quantity,
1268         bytes memory _data,
1269         bool safe
1270     ) internal {
1271         uint256 startTokenId = currentIndex;
1272         require(to != address(0), "ERC721A: mint to the zero address");
1273         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1274 
1275         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1276 
1277         // Overflows are incredibly unrealistic.
1278         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1279         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1280         unchecked {
1281             _addressData[to].balance += uint128(quantity);
1282             _addressData[to].numberMinted += uint128(quantity);
1283 
1284             _ownerships[startTokenId].addr = to;
1285             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1286 
1287             uint256 updatedIndex = startTokenId;
1288 
1289             for (uint256 i; i < quantity; i++) {
1290                 emit Transfer(address(0), to, updatedIndex);
1291                 if (safe) {
1292                     require(
1293                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1294                         "ERC721A: transfer to non ERC721Receiver implementer"
1295                     );
1296                 }
1297 
1298                 updatedIndex++;
1299             }
1300 
1301             currentIndex = updatedIndex;
1302         }
1303 
1304         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1305     }
1306 
1307     /**
1308      * @dev Transfers `tokenId` from `from` to `to`.
1309      *
1310      * Requirements:
1311      *
1312      * - `to` cannot be the zero address.
1313      * - `tokenId` token must be owned by `from`.
1314      *
1315      * Emits a {Transfer} event.
1316      */
1317     function _transfer(
1318         address from,
1319         address to,
1320         uint256 tokenId
1321     ) private {
1322         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1323 
1324         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1325             getApproved(tokenId) == _msgSender() ||
1326             isApprovedForAll(prevOwnership.addr, _msgSender()));
1327 
1328         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1329 
1330         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1331         require(to != address(0), "ERC721A: transfer to the zero address");
1332 
1333         _beforeTokenTransfers(from, to, tokenId, 1);
1334 
1335         // Clear approvals from the previous owner
1336         _approve(address(0), tokenId, prevOwnership.addr);
1337 
1338         // Underflow of the sender's balance is impossible because we check for
1339         // ownership above and the recipient's balance can't realistically overflow.
1340         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1341         unchecked {
1342             _addressData[from].balance -= 1;
1343             _addressData[to].balance += 1;
1344 
1345             _ownerships[tokenId].addr = to;
1346             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1347 
1348             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1349             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1350             uint256 nextTokenId = tokenId + 1;
1351             if (_ownerships[nextTokenId].addr == address(0)) {
1352                 if (_exists(nextTokenId)) {
1353                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1354                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1355                 }
1356             }
1357         }
1358 
1359         emit Transfer(from, to, tokenId);
1360         _afterTokenTransfers(from, to, tokenId, 1);
1361     }
1362 
1363     /**
1364      * @dev Approve `to` to operate on `tokenId`
1365      *
1366      * Emits a {Approval} event.
1367      */
1368     function _approve(
1369         address to,
1370         uint256 tokenId,
1371         address owner
1372     ) private {
1373         _tokenApprovals[tokenId] = to;
1374         emit Approval(owner, to, tokenId);
1375     }
1376 
1377     /**
1378      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1379      * The call is not executed if the target address is not a contract.
1380      *
1381      * @param from address representing the previous owner of the given token ID
1382      * @param to target address that will receive the tokens
1383      * @param tokenId uint256 ID of the token to be transferred
1384      * @param _data bytes optional data to send along with the call
1385      * @return bool whether the call correctly returned the expected magic value
1386      */
1387     function _checkOnERC721Received(
1388         address from,
1389         address to,
1390         uint256 tokenId,
1391         bytes memory _data
1392     ) private returns (bool) {
1393         if (to.isContract()) {
1394             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1395                 return retval == IERC721Receiver(to).onERC721Received.selector;
1396             } catch (bytes memory reason) {
1397                 if (reason.length == 0) {
1398                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1399                 } else {
1400                     assembly {
1401                         revert(add(32, reason), mload(reason))
1402                     }
1403                 }
1404             }
1405         } else {
1406             return true;
1407         }
1408     }
1409 
1410     /**
1411      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1412      *
1413      * startTokenId - the first token id to be transferred
1414      * quantity - the amount to be transferred
1415      *
1416      * Calling conditions:
1417      *
1418      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1419      * transferred to `to`.
1420      * - When `from` is zero, `tokenId` will be minted for `to`.
1421      */
1422     function _beforeTokenTransfers(
1423         address from,
1424         address to,
1425         uint256 startTokenId,
1426         uint256 quantity
1427     ) internal virtual {}
1428 
1429     /**
1430      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1431      * minting.
1432      *
1433      * startTokenId - the first token id to be transferred
1434      * quantity - the amount to be transferred
1435      *
1436      * Calling conditions:
1437      *
1438      * - when `from` and `to` are both non-zero.
1439      * - `from` and `to` are never both zero.
1440      */
1441     function _afterTokenTransfers(
1442         address from,
1443         address to,
1444         uint256 startTokenId,
1445         uint256 quantity
1446     ) internal virtual {}
1447 }
1448 
1449 contract Spacebirds is ERC721A, Ownable, ReentrancyGuard {
1450 
1451   uint public   nextOwnerToExplicitlySet;
1452 
1453   string public baseURI;
1454 
1455   uint public   maxSupply    = 1000; // 4 da culture
1456   uint public   price        = 0.008 ether;
1457   uint public   maxPerTx     = 5;
1458   uint public   maxPerWallet = 10;
1459   uint public   totalFree    = 0;
1460 
1461   bool public   mintEnabled;
1462 
1463   constructor() ERC721A("Spacebirds", "Spacebirds") {}
1464 
1465   function mintSpacebirds(uint256 amount) external payable {
1466     uint cost = price;
1467     if(totalSupply() + amount <= totalFree + 1) {
1468       cost = 0;
1469     }
1470     require(msg.sender == tx.origin,"new contract who dis?");
1471     require(msg.value == amount * cost,"exact amount required.");
1472     require(totalSupply() + amount < maxSupply + 1,"not that many Spacebirds");
1473     require(mintEnabled, "either you're too early or too late but no Spacebirds 4 u");
1474     require(numberMinted(msg.sender) + amount < maxPerWallet + 1,"u don't get that many Spacebirds");
1475     require( amount < maxPerTx + 1, "2 many Spacebirds at once!");
1476 
1477     _safeMint(msg.sender, amount);
1478   }
1479 
1480   function reserveSpacebirds(uint256 amount) external onlyOwner {
1481     require(totalSupply() + amount < maxSupply + 1,"not enough Spacebirds!");
1482     _safeMint(msg.sender, amount);
1483   }
1484 
1485   function toggleMinting() external onlyOwner {
1486       mintEnabled = !mintEnabled;
1487   }
1488 
1489   function numberMinted(address owner) public view returns (uint256) {
1490     return _numberMinted(owner);
1491   }
1492 
1493   function setBaseURI(string calldata baseURI_) external onlyOwner {
1494     baseURI = baseURI_;
1495   }
1496 
1497   function setPrice(uint256 price_) external onlyOwner {
1498       price = price_;
1499   }
1500 
1501   function setTotalFree(uint256 totalFree_) external onlyOwner {
1502       totalFree = totalFree_;
1503   }
1504 
1505   function setMaxPerTx(uint256 maxPerTx_) external onlyOwner {
1506       maxPerTx = maxPerTx_;
1507   }
1508 
1509   function setMaxPerWallet(uint256 maxPerWallet_) external onlyOwner {
1510       maxPerWallet = maxPerWallet_;
1511   }
1512 
1513   function setMaxSupply(uint256 maxSupply_) external onlyOwner {
1514       maxSupply = maxSupply_;
1515   }
1516 
1517   function _baseURI() internal view virtual override returns (string memory) {
1518     return baseURI;
1519   }
1520 
1521   function withdraw() external onlyOwner nonReentrant {
1522     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1523     require(success, "Transfer failed.");
1524   }
1525 
1526   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1527     _setOwnersExplicit(quantity);
1528   }
1529 
1530   function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1531     return ownershipOf(tokenId);
1532   }
1533 
1534   /**
1535     * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1536     */
1537   function _setOwnersExplicit(uint256 quantity) internal {
1538       require(quantity != 0, "quantity must be nonzero");
1539       require(currentIndex != 0, "no tokens minted yet");
1540       uint256 _nextOwnerToExplicitlySet = nextOwnerToExplicitlySet;
1541       require(_nextOwnerToExplicitlySet < currentIndex, "all ownerships have been set");
1542 
1543       // Index underflow is impossible.
1544       // Counter or index overflow is incredibly unrealistic.
1545       unchecked {
1546           uint256 endIndex = _nextOwnerToExplicitlySet + quantity - 1;
1547 
1548           // Set the end index to be the last token index
1549           if (endIndex + 1 > currentIndex) {
1550               endIndex = currentIndex - 1;
1551           }
1552 
1553           for (uint256 i = _nextOwnerToExplicitlySet; i <= endIndex; i++) {
1554               if (_ownerships[i].addr == address(0)) {
1555                   TokenOwnership memory ownership = ownershipOf(i);
1556                   _ownerships[i].addr = ownership.addr;
1557                   _ownerships[i].startTimestamp = ownership.startTimestamp;
1558               }
1559           }
1560 
1561           nextOwnerToExplicitlySet = endIndex + 1;
1562       }
1563   }
1564 }