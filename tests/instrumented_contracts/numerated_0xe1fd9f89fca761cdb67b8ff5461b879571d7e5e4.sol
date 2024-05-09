1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
4 
5 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
6 
7 // Thanks Azuki for 721A contract
8 
9 // MeOwMeoW Save My Life 
10 
11 pragma solidity ^0.8.0;
12 
13 
14 interface IERC20 {
15     /**
16      * @dev Returns the amount of tokens in existence.
17      */
18     function totalSupply() external view returns (uint256);
19 
20     /**
21      * @dev Returns the amount of tokens owned by `account`.
22      */
23     function balanceOf(address account) external view returns (uint256);
24 
25     /**
26      * @dev Moves `amount` tokens from the caller's account to `to`.
27      *
28      * Returns a boolean value indicating whether the operation succeeded.
29      *
30      * Emits a {Transfer} event.
31      */
32     function transfer(address to, uint256 amount) external returns (bool);
33 
34     /**
35      * @dev Returns the remaining number of tokens that `spender` will be
36      * allowed to spend on behalf of `owner` through {transferFrom}. This is
37      * zero by default.
38      *
39      * This value changes when {approve} or {transferFrom} are called.
40      */
41     function allowance(address owner, address spender) external view returns (uint256);
42 
43     /**
44      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * IMPORTANT: Beware that changing an allowance with this method brings the risk
49      * that someone may use both the old and the new allowance by unfortunate
50      * transaction ordering. One possible solution to mitigate this race
51      * condition is to first reduce the spender's allowance to 0 and set the
52      * desired value afterwards:
53      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
54      *
55      * Emits an {Approval} event.
56      */
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Moves `amount` tokens from `from` to `to` using the
61      * allowance mechanism. `amount` is then deducted from the caller's
62      * allowance.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a {Transfer} event.
67      */
68     function transferFrom(
69         address from,
70         address to,
71         uint256 amount
72     ) external returns (bool);
73 
74     /**
75      * @dev Emitted when `value` tokens are moved from one account (`from`) to
76      * another (`to`).
77      *
78      * Note that `value` may be zero.
79      */
80     event Transfer(address indexed from, address indexed to, uint256 value);
81 
82     /**
83      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
84      * a call to {approve}. `value` is the new allowance.
85      */
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
90 
91 
92 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
93 
94 pragma solidity ^0.8.0;
95 
96 /**
97  * @dev Contract module that helps prevent reentrant calls to a function.
98  *
99  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
100  * available, which can be applied to functions to make sure there are no nested
101  * (reentrant) calls to them.
102  *
103  * Note that because there is a single `nonReentrant` guard, functions marked as
104  * `nonReentrant` may not call one another. This can be worked around by making
105  * those functions `private`, and then adding `external` `nonReentrant` entry
106  * points to them.
107  *
108  * TIP: If you would like to learn more about reentrancy and alternative ways
109  * to protect against it, check out our blog post
110  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
111  */
112 abstract contract ReentrancyGuard {
113     // Booleans are more expensive than uint256 or any type that takes up a full
114     // word because each write operation emits an extra SLOAD to first read the
115     // slot's contents, replace the bits taken up by the boolean, and then write
116     // back. This is the compiler's defense against contract upgrades and
117     // pointer aliasing, and it cannot be disabled.
118 
119     // The values being non-zero value makes deployment a bit more expensive,
120     // but in exchange the refund on every call to nonReentrant will be lower in
121     // amount. Since refunds are capped to a percentage of the total
122     // transaction's gas, it is best to keep them low in cases like this one, to
123     // increase the likelihood of the full refund coming into effect.
124     uint256 private constant _NOT_ENTERED = 1;
125     uint256 private constant _ENTERED = 2;
126 
127     uint256 private _status;
128 
129     constructor() {
130         _status = _NOT_ENTERED;
131     }
132 
133     /**
134      * @dev Prevents a contract from calling itself, directly or indirectly.
135      * Calling a `nonReentrant` function from another `nonReentrant`
136      * function is not supported. It is possible to prevent this from happening
137      * by making the `nonReentrant` function external, and making it call a
138      * `private` function that does the actual work.
139      */
140     modifier nonReentrant() {
141         // On the first call to nonReentrant, _notEntered will be true
142         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
143 
144         // Any calls to nonReentrant after this point will fail
145         _status = _ENTERED;
146 
147         _;
148 
149         // By storing the original value once again, a refund is triggered (see
150         // https://eips.ethereum.org/EIPS/eip-2200)
151         _status = _NOT_ENTERED;
152     }
153 }
154 
155 // File: @openzeppelin/contracts/utils/Strings.sol
156 
157 
158 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
159 
160 pragma solidity ^0.8.0;
161 
162 /**
163  * @dev String operations.
164  */
165 library Strings {
166     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
167 
168     /**
169      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
170      */
171     function toString(uint256 value) internal pure returns (string memory) {
172         // Inspired by OraclizeAPI's implementation - MIT licence
173         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
174 
175         if (value == 0) {
176             return "0";
177         }
178         uint256 temp = value;
179         uint256 digits;
180         while (temp != 0) {
181             digits++;
182             temp /= 10;
183         }
184         bytes memory buffer = new bytes(digits);
185         while (value != 0) {
186             digits -= 1;
187             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
188             value /= 10;
189         }
190         return string(buffer);
191     }
192 
193     /**
194      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
195      */
196     function toHexString(uint256 value) internal pure returns (string memory) {
197         if (value == 0) {
198             return "0x00";
199         }
200         uint256 temp = value;
201         uint256 length = 0;
202         while (temp != 0) {
203             length++;
204             temp >>= 8;
205         }
206         return toHexString(value, length);
207     }
208 
209     /**
210      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
211      */
212     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
213         bytes memory buffer = new bytes(2 * length + 2);
214         buffer[0] = "0";
215         buffer[1] = "x";
216         for (uint256 i = 2 * length + 1; i > 1; --i) {
217             buffer[i] = _HEX_SYMBOLS[value & 0xf];
218             value >>= 4;
219         }
220         require(value == 0, "Strings: hex length insufficient");
221         return string(buffer);
222     }
223 }
224 
225 // File: @openzeppelin/contracts/utils/Context.sol
226 
227 
228 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
229 
230 pragma solidity ^0.8.0;
231 
232 /**
233  * @dev Provides information about the current execution context, including the
234  * sender of the transaction and its data. While these are generally available
235  * via msg.sender and msg.data, they should not be accessed in such a direct
236  * manner, since when dealing with meta-transactions the account sending and
237  * paying for execution may not be the actual sender (as far as an application
238  * is concerned).
239  *
240  * This contract is only required for intermediate, library-like contracts.
241  */
242 abstract contract Context {
243     function _msgSender() internal view virtual returns (address) {
244         return msg.sender;
245     }
246 
247     function _msgData() internal view virtual returns (bytes calldata) {
248         return msg.data;
249     }
250 }
251 
252 // File: @openzeppelin/contracts/access/Ownable.sol
253 
254 
255 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
256 
257 pragma solidity ^0.8.0;
258 
259 
260 /**
261  * @dev Contract module which provides a basic access control mechanism, where
262  * there is an account (an owner) that can be granted exclusive access to
263  * specific functions.
264  *
265  * By default, the owner account will be the one that deploys the contract. This
266  * can later be changed with {transferOwnership}.
267  *
268  * This module is used through inheritance. It will make available the modifier
269  * `onlyOwner`, which can be applied to your functions to restrict their use to
270  * the owner.
271  */
272 abstract contract Ownable is Context {
273     address private _owner;
274 
275     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
276 
277     /**
278      * @dev Initializes the contract setting the deployer as the initial owner.
279      */
280     constructor() {
281         _transferOwnership(_msgSender());
282     }
283 
284     /**
285      * @dev Returns the address of the current owner.
286      */
287     function owner() public view virtual returns (address) {
288         return _owner;
289     }
290 
291     /**
292      * @dev Throws if called by any account other than the owner.
293      */
294     modifier onlyOwner() {
295         require(owner() == _msgSender(), "Ownable: caller is not the owner");
296         _;
297     }
298 
299     /**
300      * @dev Leaves the contract without owner. It will not be possible to call
301      * `onlyOwner` functions anymore. Can only be called by the current owner.
302      *
303      * NOTE: Renouncing ownership will leave the contract without an owner,
304      * thereby removing any functionality that is only available to the owner.
305      */
306     function renounceOwnership() public virtual onlyOwner {
307         _transferOwnership(address(0));
308     }
309 
310     /**
311      * @dev Transfers ownership of the contract to a new account (`newOwner`).
312      * Can only be called by the current owner.
313      */
314     function transferOwnership(address newOwner) public virtual onlyOwner {
315         require(newOwner != address(0), "Ownable: new owner is the zero address");
316         _transferOwnership(newOwner);
317     }
318 
319     /**
320      * @dev Transfers ownership of the contract to a new account (`newOwner`).
321      * Internal function without access restriction.
322      */
323     function _transferOwnership(address newOwner) internal virtual {
324         address oldOwner = _owner;
325         _owner = newOwner;
326         emit OwnershipTransferred(oldOwner, newOwner);
327     }
328 }
329 
330 // File: @openzeppelin/contracts/utils/Address.sol
331 
332 
333 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
334 
335 pragma solidity ^0.8.1;
336 
337 /**
338  * @dev Collection of functions related to the address type
339  */
340 library Address {
341     /**
342      * @dev Returns true if `account` is a contract.
343      *
344      * [IMPORTANT]
345      * ====
346      * It is unsafe to assume that an address for which this function returns
347      * false is an externally-owned account (EOA) and not a contract.
348      *
349      * Among others, `isContract` will return false for the following
350      * types of addresses:
351      *
352      *  - an externally-owned account
353      *  - a contract in construction
354      *  - an address where a contract will be created
355      *  - an address where a contract lived, but was destroyed
356      * ====
357      *
358      * [IMPORTANT]
359      * ====
360      * You shouldn't rely on `isContract` to protect against flash loan attacks!
361      *
362      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
363      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
364      * constructor.
365      * ====
366      */
367     function isContract(address account) internal view returns (bool) {
368         // This method relies on extcodesize/address.code.length, which returns 0
369         // for contracts in construction, since the code is only stored at the end
370         // of the constructor execution.
371 
372         return account.code.length > 0;
373     }
374 
375     /**
376      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
377      * `recipient`, forwarding all available gas and reverting on errors.
378      *
379      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
380      * of certain opcodes, possibly making contracts go over the 2300 gas limit
381      * imposed by `transfer`, making them unable to receive funds via
382      * `transfer`. {sendValue} removes this limitation.
383      *
384      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
385      *
386      * IMPORTANT: because control is transferred to `recipient`, care must be
387      * taken to not create reentrancy vulnerabilities. Consider using
388      * {ReentrancyGuard} or the
389      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
390      */
391     function sendValue(address payable recipient, uint256 amount) internal {
392         require(address(this).balance >= amount, "Address: insufficient balance");
393 
394         (bool success, ) = recipient.call{value: amount}("");
395         require(success, "Address: unable to send value, recipient may have reverted");
396     }
397 
398     /**
399      * @dev Performs a Solidity function call using a low level `call`. A
400      * plain `call` is an unsafe replacement for a function call: use this
401      * function instead.
402      *
403      * If `target` reverts with a revert reason, it is bubbled up by this
404      * function (like regular Solidity function calls).
405      *
406      * Returns the raw returned data. To convert to the expected return value,
407      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
408      *
409      * Requirements:
410      *
411      * - `target` must be a contract.
412      * - calling `target` with `data` must not revert.
413      *
414      * _Available since v3.1._
415      */
416     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
417         return functionCall(target, data, "Address: low-level call failed");
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
422      * `errorMessage` as a fallback revert reason when `target` reverts.
423      *
424      * _Available since v3.1._
425      */
426     function functionCall(
427         address target,
428         bytes memory data,
429         string memory errorMessage
430     ) internal returns (bytes memory) {
431         return functionCallWithValue(target, data, 0, errorMessage);
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
436      * but also transferring `value` wei to `target`.
437      *
438      * Requirements:
439      *
440      * - the calling contract must have an ETH balance of at least `value`.
441      * - the called Solidity function must be `payable`.
442      *
443      * _Available since v3.1._
444      */
445     function functionCallWithValue(
446         address target,
447         bytes memory data,
448         uint256 value
449     ) internal returns (bytes memory) {
450         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
455      * with `errorMessage` as a fallback revert reason when `target` reverts.
456      *
457      * _Available since v3.1._
458      */
459     function functionCallWithValue(
460         address target,
461         bytes memory data,
462         uint256 value,
463         string memory errorMessage
464     ) internal returns (bytes memory) {
465         require(address(this).balance >= value, "Address: insufficient balance for call");
466         require(isContract(target), "Address: call to non-contract");
467 
468         (bool success, bytes memory returndata) = target.call{value: value}(data);
469         return verifyCallResult(success, returndata, errorMessage);
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
474      * but performing a static call.
475      *
476      * _Available since v3.3._
477      */
478     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
479         return functionStaticCall(target, data, "Address: low-level static call failed");
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
484      * but performing a static call.
485      *
486      * _Available since v3.3._
487      */
488     function functionStaticCall(
489         address target,
490         bytes memory data,
491         string memory errorMessage
492     ) internal view returns (bytes memory) {
493         require(isContract(target), "Address: static call to non-contract");
494 
495         (bool success, bytes memory returndata) = target.staticcall(data);
496         return verifyCallResult(success, returndata, errorMessage);
497     }
498 
499     /**
500      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
501      * but performing a delegate call.
502      *
503      * _Available since v3.4._
504      */
505     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
506         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
507     }
508 
509     /**
510      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
511      * but performing a delegate call.
512      *
513      * _Available since v3.4._
514      */
515     function functionDelegateCall(
516         address target,
517         bytes memory data,
518         string memory errorMessage
519     ) internal returns (bytes memory) {
520         require(isContract(target), "Address: delegate call to non-contract");
521 
522         (bool success, bytes memory returndata) = target.delegatecall(data);
523         return verifyCallResult(success, returndata, errorMessage);
524     }
525 
526     /**
527      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
528      * revert reason using the provided one.
529      *
530      * _Available since v4.3._
531      */
532     function verifyCallResult(
533         bool success,
534         bytes memory returndata,
535         string memory errorMessage
536     ) internal pure returns (bytes memory) {
537         if (success) {
538             return returndata;
539         } else {
540             // Look for revert reason and bubble it up if present
541             if (returndata.length > 0) {
542                 // The easiest way to bubble the revert reason is using memory via assembly
543 
544                 assembly {
545                     let returndata_size := mload(returndata)
546                     revert(add(32, returndata), returndata_size)
547                 }
548             } else {
549                 revert(errorMessage);
550             }
551         }
552     }
553 }
554 
555 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
556 
557 
558 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
559 
560 pragma solidity ^0.8.0;
561 
562 
563 
564 /**
565  * @title SafeERC20
566  * @dev Wrappers around ERC20 operations that throw on failure (when the token
567  * contract returns false). Tokens that return no value (and instead revert or
568  * throw on failure) are also supported, non-reverting calls are assumed to be
569  * successful.
570  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
571  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
572  */
573 library SafeERC20 {
574     using Address for address;
575 
576     function safeTransfer(
577         IERC20 token,
578         address to,
579         uint256 value
580     ) internal {
581         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
582     }
583 
584     function safeTransferFrom(
585         IERC20 token,
586         address from,
587         address to,
588         uint256 value
589     ) internal {
590         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
591     }
592 
593     /**
594      * @dev Deprecated. This function has issues similar to the ones found in
595      * {IERC20-approve}, and its usage is discouraged.
596      *
597      * Whenever possible, use {safeIncreaseAllowance} and
598      * {safeDecreaseAllowance} instead.
599      */
600     function safeApprove(
601         IERC20 token,
602         address spender,
603         uint256 value
604     ) internal {
605         // safeApprove should only be called when setting an initial allowance,
606         // or when resetting it to zero. To increase and decrease it, use
607         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
608         require(
609             (value == 0) || (token.allowance(address(this), spender) == 0),
610             "SafeERC20: approve from non-zero to non-zero allowance"
611         );
612         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
613     }
614 
615     function safeIncreaseAllowance(
616         IERC20 token,
617         address spender,
618         uint256 value
619     ) internal {
620         uint256 newAllowance = token.allowance(address(this), spender) + value;
621         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
622     }
623 
624     function safeDecreaseAllowance(
625         IERC20 token,
626         address spender,
627         uint256 value
628     ) internal {
629         unchecked {
630             uint256 oldAllowance = token.allowance(address(this), spender);
631             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
632             uint256 newAllowance = oldAllowance - value;
633             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
634         }
635     }
636 
637     /**
638      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
639      * on the return value: the return value is optional (but if data is returned, it must not be false).
640      * @param token The token targeted by the call.
641      * @param data The call data (encoded using abi.encode or one of its variants).
642      */
643     function _callOptionalReturn(IERC20 token, bytes memory data) private {
644         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
645         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
646         // the target address contains contract code and also asserts for success in the low-level call.
647 
648         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
649         if (returndata.length > 0) {
650             // Return data is optional
651             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
652         }
653     }
654 }
655 
656 
657 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
658 
659 
660 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
661 
662 pragma solidity ^0.8.0;
663 
664 /**
665  * @title ERC721 token receiver interface
666  * @dev Interface for any contract that wants to support safeTransfers
667  * from ERC721 asset contracts.
668  */
669 interface IERC721Receiver {
670     /**
671      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
672      * by `operator` from `from`, this function is called.
673      *
674      * It must return its Solidity selector to confirm the token transfer.
675      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
676      *
677      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
678      */
679     function onERC721Received(
680         address operator,
681         address from,
682         uint256 tokenId,
683         bytes calldata data
684     ) external returns (bytes4);
685 }
686 
687 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
688 
689 
690 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
691 
692 pragma solidity ^0.8.0;
693 
694 /**
695  * @dev Interface of the ERC165 standard, as defined in the
696  * https://eips.ethereum.org/EIPS/eip-165[EIP].
697  *
698  * Implementers can declare support of contract interfaces, which can then be
699  * queried by others ({ERC165Checker}).
700  *
701  * For an implementation, see {ERC165}.
702  */
703 interface IERC165 {
704     /**
705      * @dev Returns true if this contract implements the interface defined by
706      * `interfaceId`. See the corresponding
707      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
708      * to learn more about how these ids are created.
709      *
710      * This function call must use less than 30 000 gas.
711      */
712     function supportsInterface(bytes4 interfaceId) external view returns (bool);
713 }
714 
715 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
716 
717 
718 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
719 
720 pragma solidity ^0.8.0;
721 
722 
723 /**
724  * @dev Implementation of the {IERC165} interface.
725  *
726  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
727  * for the additional interface id that will be supported. For example:
728  *
729  * ```solidity
730  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
731  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
732  * }
733  * ```
734  *
735  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
736  */
737 abstract contract ERC165 is IERC165 {
738     /**
739      * @dev See {IERC165-supportsInterface}.
740      */
741     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
742         return interfaceId == type(IERC165).interfaceId;
743     }
744 }
745 
746 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
747 
748 
749 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
750 
751 pragma solidity ^0.8.0;
752 
753 
754 /**
755  * @dev Required interface of an ERC721 compliant contract.
756  */
757 interface IERC721 is IERC165 {
758     /**
759      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
760      */
761     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
762 
763     /**
764      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
765      */
766     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
767 
768     /**
769      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
770      */
771     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
772 
773     /**
774      * @dev Returns the number of tokens in ``owner``'s account.
775      */
776     function balanceOf(address owner) external view returns (uint256 balance);
777 
778     /**
779      * @dev Returns the owner of the `tokenId` token.
780      *
781      * Requirements:
782      *
783      * - `tokenId` must exist.
784      */
785     function ownerOf(uint256 tokenId) external view returns (address owner);
786 
787     /**
788      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
789      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
790      *
791      * Requirements:
792      *
793      * - `from` cannot be the zero address.
794      * - `to` cannot be the zero address.
795      * - `tokenId` token must exist and be owned by `from`.
796      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
797      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
798      *
799      * Emits a {Transfer} event.
800      */
801     function safeTransferFrom(
802         address from,
803         address to,
804         uint256 tokenId
805     ) external;
806 
807     /**
808      * @dev Transfers `tokenId` token from `from` to `to`.
809      *
810      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
811      *
812      * Requirements:
813      *
814      * - `from` cannot be the zero address.
815      * - `to` cannot be the zero address.
816      * - `tokenId` token must be owned by `from`.
817      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
818      *
819      * Emits a {Transfer} event.
820      */
821     function transferFrom(
822         address from,
823         address to,
824         uint256 tokenId
825     ) external;
826 
827     /**
828      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
829      * The approval is cleared when the token is transferred.
830      *
831      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
832      *
833      * Requirements:
834      *
835      * - The caller must own the token or be an approved operator.
836      * - `tokenId` must exist.
837      *
838      * Emits an {Approval} event.
839      */
840     function approve(address to, uint256 tokenId) external;
841 
842     /**
843      * @dev Returns the account approved for `tokenId` token.
844      *
845      * Requirements:
846      *
847      * - `tokenId` must exist.
848      */
849     function getApproved(uint256 tokenId) external view returns (address operator);
850 
851     /**
852      * @dev Approve or remove `operator` as an operator for the caller.
853      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
854      *
855      * Requirements:
856      *
857      * - The `operator` cannot be the caller.
858      *
859      * Emits an {ApprovalForAll} event.
860      */
861     function setApprovalForAll(address operator, bool _approved) external;
862 
863     /**
864      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
865      *
866      * See {setApprovalForAll}
867      */
868     function isApprovedForAll(address owner, address operator) external view returns (bool);
869 
870     /**
871      * @dev Safely transfers `tokenId` token from `from` to `to`.
872      *
873      * Requirements:
874      *
875      * - `from` cannot be the zero address.
876      * - `to` cannot be the zero address.
877      * - `tokenId` token must exist and be owned by `from`.
878      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
879      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
880      *
881      * Emits a {Transfer} event.
882      */
883     function safeTransferFrom(
884         address from,
885         address to,
886         uint256 tokenId,
887         bytes calldata data
888     ) external;
889 }
890 
891 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
892 
893 
894 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
895 
896 pragma solidity ^0.8.0;
897 
898 
899 /**
900  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
901  * @dev See https://eips.ethereum.org/EIPS/eip-721
902  */
903 interface IERC721Enumerable is IERC721 {
904     /**
905      * @dev Returns the total amount of tokens stored by the contract.
906      */
907     function totalSupply() external view returns (uint256);
908 
909     /**
910      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
911      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
912      */
913     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
914 
915     /**
916      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
917      * Use along with {totalSupply} to enumerate all tokens.
918      */
919     function tokenByIndex(uint256 index) external view returns (uint256);
920 }
921 
922 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
923 
924 
925 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
926 
927 pragma solidity ^0.8.0;
928 
929 
930 /**
931  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
932  * @dev See https://eips.ethereum.org/EIPS/eip-721
933  */
934 interface IERC721Metadata is IERC721 {
935     /**
936      * @dev Returns the token collection name.
937      */
938     function name() external view returns (string memory);
939 
940     /**
941      * @dev Returns the token collection symbol.
942      */
943     function symbol() external view returns (string memory);
944 
945     /**
946      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
947      */
948     function tokenURI(uint256 tokenId) external view returns (string memory);
949 }
950 
951 // File: contracts/TwistedToonz.sol
952 
953 
954 // Creator: Chiru Labs
955 
956 pragma solidity ^0.8.0;
957 
958 
959 
960 
961 
962 
963 
964 
965 
966 /**
967  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
968  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
969  *
970  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
971  *
972  * Does not support burning tokens to address(0).
973  *
974  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
975  */
976 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
977     using Address for address;
978     using Strings for uint256;
979 
980     struct TokenOwnership {
981         address addr;
982         uint64 startTimestamp;
983     }
984 
985     struct AddressData {
986         uint128 balance;
987         uint128 numberMinted;
988     }
989 
990     uint256 internal currentIndex;
991 
992     // Token name
993     string private _name;
994 
995     // Token symbol
996     string private _symbol;
997 
998     // Mapping from token ID to ownership details
999     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1000     mapping(uint256 => TokenOwnership) internal _ownerships;
1001 
1002     // Mapping owner address to address data
1003     mapping(address => AddressData) private _addressData;
1004 
1005     // Mapping from token ID to approved address
1006     mapping(uint256 => address) private _tokenApprovals;
1007 
1008     // Mapping from owner to operator approvals
1009     mapping(address => mapping(address => bool)) private _operatorApprovals;
1010 
1011     constructor(string memory name_, string memory symbol_) {
1012         _name = name_;
1013         _symbol = symbol_;
1014     }
1015 
1016     /**
1017      * @dev See {IERC721Enumerable-totalSupply}.
1018      */
1019     function totalSupply() public view override returns (uint256) {
1020         return currentIndex;
1021     }
1022 
1023     /**
1024      * @dev See {IERC721Enumerable-tokenByIndex}.
1025      */
1026     function tokenByIndex(uint256 index) public view override returns (uint256) {
1027         require(index < totalSupply(), "ERC721A: global index out of bounds");
1028         return index;
1029     }
1030 
1031     /**
1032      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1033      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1034      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1035      */
1036     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1037         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1038         uint256 numMintedSoFar = totalSupply();
1039         uint256 tokenIdsIdx;
1040         address currOwnershipAddr;
1041 
1042         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1043         unchecked {
1044             for (uint256 i; i < numMintedSoFar; i++) {
1045                 TokenOwnership memory ownership = _ownerships[i];
1046                 if (ownership.addr != address(0)) {
1047                     currOwnershipAddr = ownership.addr;
1048                 }
1049                 if (currOwnershipAddr == owner) {
1050                     if (tokenIdsIdx == index) {
1051                         return i;
1052                     }
1053                     tokenIdsIdx++;
1054                 }
1055             }
1056         }
1057 
1058         revert("ERC721A: unable to get token of owner by index");
1059     }
1060 
1061     /**
1062      * @dev See {IERC165-supportsInterface}.
1063      */
1064     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1065         return
1066             interfaceId == type(IERC721).interfaceId ||
1067             interfaceId == type(IERC721Metadata).interfaceId ||
1068             interfaceId == type(IERC721Enumerable).interfaceId ||
1069             super.supportsInterface(interfaceId);
1070     }
1071 
1072     /**
1073      * @dev See {IERC721-balanceOf}.
1074      */
1075     function balanceOf(address owner) public view override returns (uint256) {
1076         require(owner != address(0), "ERC721A: balance query for the zero address");
1077         return uint256(_addressData[owner].balance);
1078     }
1079 
1080     function _numberMinted(address owner) internal view returns (uint256) {
1081         require(owner != address(0), "ERC721A: number minted query for the zero address");
1082         return uint256(_addressData[owner].numberMinted);
1083     }
1084 
1085     /**
1086      * Gas spent here starts off proportional to the maximum mint batch size.
1087      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1088      */
1089     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1090         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1091 
1092         unchecked {
1093             for (uint256 curr = tokenId; curr >= 0; curr--) {
1094                 TokenOwnership memory ownership = _ownerships[curr];
1095                 if (ownership.addr != address(0)) {
1096                     return ownership;
1097                 }
1098             }
1099         }
1100 
1101         revert("ERC721A: unable to determine the owner of token");
1102     }
1103 
1104     /**
1105      * @dev See {IERC721-ownerOf}.
1106      */
1107     function ownerOf(uint256 tokenId) public view override returns (address) {
1108         return ownershipOf(tokenId).addr;
1109     }
1110 
1111     /**
1112      * @dev See {IERC721Metadata-name}.
1113      */
1114     function name() public view virtual override returns (string memory) {
1115         return _name;
1116     }
1117 
1118     /**
1119      * @dev See {IERC721Metadata-symbol}.
1120      */
1121     function symbol() public view virtual override returns (string memory) {
1122         return _symbol;
1123     }
1124 
1125     /**
1126      * @dev See {IERC721Metadata-tokenURI}.
1127      */
1128     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1129         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1130 
1131         string memory baseURI = _baseURI();
1132         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1133     }
1134 
1135     /**
1136      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1137      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1138      * by default, can be overriden in child contracts.
1139      */
1140     function _baseURI() internal view virtual returns (string memory) {
1141         return "";
1142     }
1143 
1144     /**
1145      * @dev See {IERC721-approve}.
1146      */
1147     function approve(address to, uint256 tokenId) public override {
1148         address owner = ERC721A.ownerOf(tokenId);
1149         require(to != owner, "ERC721A: approval to current owner");
1150 
1151         require(
1152             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1153             "ERC721A: approve caller is not owner nor approved for all"
1154         );
1155 
1156         _approve(to, tokenId, owner);
1157     }
1158 
1159     /**
1160      * @dev See {IERC721-getApproved}.
1161      */
1162     function getApproved(uint256 tokenId) public view override returns (address) {
1163         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1164 
1165         return _tokenApprovals[tokenId];
1166     }
1167 
1168     /**
1169      * @dev See {IERC721-setApprovalForAll}.
1170      */
1171     function setApprovalForAll(address operator, bool approved) public override {
1172         require(operator != _msgSender(), "ERC721A: approve to caller");
1173 
1174         _operatorApprovals[_msgSender()][operator] = approved;
1175         emit ApprovalForAll(_msgSender(), operator, approved);
1176     }
1177 
1178     /**
1179      * @dev See {IERC721-isApprovedForAll}.
1180      */
1181     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1182         return _operatorApprovals[owner][operator];
1183     }
1184 
1185     /**
1186      * @dev See {IERC721-transferFrom}.
1187      */
1188     function transferFrom(
1189         address from,
1190         address to,
1191         uint256 tokenId
1192     ) public virtual override {
1193         _transfer(from, to, tokenId);
1194     }
1195 
1196     /**
1197      * @dev See {IERC721-safeTransferFrom}.
1198      */
1199     function safeTransferFrom(
1200         address from,
1201         address to,
1202         uint256 tokenId
1203     ) public virtual override {
1204         safeTransferFrom(from, to, tokenId, "");
1205     }
1206 
1207     /**
1208      * @dev See {IERC721-safeTransferFrom}.
1209      */
1210     function safeTransferFrom(
1211         address from,
1212         address to,
1213         uint256 tokenId,
1214         bytes memory _data
1215     ) public override {
1216         _transfer(from, to, tokenId);
1217         require(
1218             _checkOnERC721Received(from, to, tokenId, _data),
1219             "ERC721A: transfer to non ERC721Receiver implementer"
1220         );
1221     }
1222 
1223     /**
1224      * @dev Returns whether `tokenId` exists.
1225      *
1226      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1227      *
1228      * Tokens start existing when they are minted (`_mint`),
1229      */
1230     function _exists(uint256 tokenId) internal view returns (bool) {
1231         return tokenId < currentIndex;
1232     }
1233 
1234     function _safeMint(address to, uint256 quantity) internal {
1235         _safeMint(to, quantity, "");
1236     }
1237 
1238     /**
1239      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1240      *
1241      * Requirements:
1242      *
1243      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1244      * - `quantity` must be greater than 0.
1245      *
1246      * Emits a {Transfer} event.
1247      */
1248     function _safeMint(
1249         address to,
1250         uint256 quantity,
1251         bytes memory _data
1252     ) internal {
1253         _mint(to, quantity, _data, true);
1254     }
1255 
1256     /**
1257      * @dev Mints `quantity` tokens and transfers them to `to`.
1258      *
1259      * Requirements:
1260      *
1261      * - `to` cannot be the zero address.
1262      * - `quantity` must be greater than 0.
1263      *
1264      * Emits a {Transfer} event.
1265      */
1266     function _mint(
1267         address to,
1268         uint256 quantity,
1269         bytes memory _data,
1270         bool safe
1271     ) internal {
1272         uint256 startTokenId = currentIndex;
1273         require(to != address(0), "ERC721A: mint to the zero address");
1274         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1275 
1276         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1277 
1278         // Overflows are incredibly unrealistic.
1279         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1280         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1281         unchecked {
1282             _addressData[to].balance += uint128(quantity);
1283             _addressData[to].numberMinted += uint128(quantity);
1284 
1285             _ownerships[startTokenId].addr = to;
1286             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1287 
1288             uint256 updatedIndex = startTokenId;
1289 
1290             for (uint256 i; i < quantity; i++) {
1291                 emit Transfer(address(0), to, updatedIndex);
1292                 if (safe) {
1293                     require(
1294                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1295                         "ERC721A: transfer to non ERC721Receiver implementer"
1296                     );
1297                 }
1298 
1299                 updatedIndex++;
1300             }
1301 
1302             currentIndex = updatedIndex;
1303         }
1304 
1305         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1306     }
1307 
1308     /**
1309      * @dev Transfers `tokenId` from `from` to `to`.
1310      *
1311      * Requirements:
1312      *
1313      * - `to` cannot be the zero address.
1314      * - `tokenId` token must be owned by `from`.
1315      *
1316      * Emits a {Transfer} event.
1317      */
1318     function _transfer(
1319         address from,
1320         address to,
1321         uint256 tokenId
1322     ) private {
1323         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1324 
1325         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1326             getApproved(tokenId) == _msgSender() ||
1327             isApprovedForAll(prevOwnership.addr, _msgSender()));
1328 
1329         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1330 
1331         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1332         require(to != address(0), "ERC721A: transfer to the zero address");
1333 
1334         _beforeTokenTransfers(from, to, tokenId, 1);
1335 
1336         // Clear approvals from the previous owner
1337         _approve(address(0), tokenId, prevOwnership.addr);
1338 
1339         // Underflow of the sender's balance is impossible because we check for
1340         // ownership above and the recipient's balance can't realistically overflow.
1341         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1342         unchecked {
1343             _addressData[from].balance -= 1;
1344             _addressData[to].balance += 1;
1345 
1346             _ownerships[tokenId].addr = to;
1347             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1348 
1349             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1350             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1351             uint256 nextTokenId = tokenId + 1;
1352             if (_ownerships[nextTokenId].addr == address(0)) {
1353                 if (_exists(nextTokenId)) {
1354                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1355                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1356                 }
1357             }
1358         }
1359 
1360         emit Transfer(from, to, tokenId);
1361         _afterTokenTransfers(from, to, tokenId, 1);
1362     }
1363 
1364     /**
1365      * @dev Approve `to` to operate on `tokenId`
1366      *
1367      * Emits a {Approval} event.
1368      */
1369     function _approve(
1370         address to,
1371         uint256 tokenId,
1372         address owner
1373     ) private {
1374         _tokenApprovals[tokenId] = to;
1375         emit Approval(owner, to, tokenId);
1376     }
1377 
1378     /**
1379      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1380      * The call is not executed if the target address is not a contract.
1381      *
1382      * @param from address representing the previous owner of the given token ID
1383      * @param to target address that will receive the tokens
1384      * @param tokenId uint256 ID of the token to be transferred
1385      * @param _data bytes optional data to send along with the call
1386      * @return bool whether the call correctly returned the expected magic value
1387      */
1388     function _checkOnERC721Received(
1389         address from,
1390         address to,
1391         uint256 tokenId,
1392         bytes memory _data
1393     ) private returns (bool) {
1394         if (to.isContract()) {
1395             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1396                 return retval == IERC721Receiver(to).onERC721Received.selector;
1397             } catch (bytes memory reason) {
1398                 if (reason.length == 0) {
1399                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1400                 } else {
1401                     assembly {
1402                         revert(add(32, reason), mload(reason))
1403                     }
1404                 }
1405             }
1406         } else {
1407             return true;
1408         }
1409     }
1410 
1411     /**
1412      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1413      *
1414      * startTokenId - the first token id to be transferred
1415      * quantity - the amount to be transferred
1416      *
1417      * Calling conditions:
1418      *
1419      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1420      * transferred to `to`.
1421      * - When `from` is zero, `tokenId` will be minted for `to`.
1422      */
1423     function _beforeTokenTransfers(
1424         address from,
1425         address to,
1426         uint256 startTokenId,
1427         uint256 quantity
1428     ) internal virtual {}
1429 
1430     /**
1431      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1432      * minting.
1433      *
1434      * startTokenId - the first token id to be transferred
1435      * quantity - the amount to be transferred
1436      *
1437      * Calling conditions:
1438      *
1439      * - when `from` and `to` are both non-zero.
1440      * - `from` and `to` are never both zero.
1441      */
1442     function _afterTokenTransfers(
1443         address from,
1444         address to,
1445         uint256 startTokenId,
1446         uint256 quantity
1447     ) internal virtual {}
1448 }
1449 
1450 //MeOwMeoW Save My Life 
1451 
1452 contract meowmeowsml is ERC721A, Ownable, ReentrancyGuard {
1453 
1454     uint public price = 0; //FREE MINT
1455     uint public maxPerTx = 2;
1456     uint public maxPerWallet = 2;
1457     uint public totalFree = 999;
1458     uint public maxSupply = 999;
1459     uint public nextOwnerToExplicitlySet;
1460     bool public mintEnabled;
1461     string public baseURI;
1462 
1463   constructor() ERC721A("MeOwMeoW Save My Life", "MMSML"){}
1464 
1465   function mint(uint256 count) external payable
1466   {
1467     uint cost = price;
1468     if(totalSupply() + count < totalFree + 1) {
1469       cost = 0;
1470     }
1471     require(msg.sender == tx.origin,"");
1472     require(msg.value == count * cost,"");
1473     require(totalSupply() + count < maxSupply + 1,"");
1474     require(mintEnabled, "");
1475     require(numberMinted(msg.sender) + count <= maxPerWallet,"");
1476     require( count < maxPerTx + 1, "");
1477 
1478     _safeMint(msg.sender, count);
1479   }
1480 
1481   function ownerBatchMint(uint256 count) external onlyOwner
1482   {
1483     require(totalSupply() + count < maxSupply + 1,"");
1484 
1485     _safeMint(msg.sender, count);
1486   }
1487 
1488   function enableMinting() external onlyOwner {
1489       mintEnabled = !mintEnabled;
1490   }
1491 
1492   function numberMinted(address owner) public view returns (uint256) {
1493     return _numberMinted(owner);
1494   }
1495 
1496   function setBaseURI(string calldata baseURI_) external onlyOwner {
1497     baseURI = baseURI_;
1498   }
1499 
1500   function setPrice(uint256 price_) external onlyOwner {
1501       price = price_;
1502   }
1503 
1504   function setTotalFree(uint256 totalFree_) external onlyOwner {
1505       totalFree = totalFree_;
1506   }
1507 
1508   function setMaxPerTx(uint256 maxPerTx_) external onlyOwner {
1509       maxPerTx = maxPerTx_;
1510   }
1511 
1512   function setMaxPerWallet(uint256 maxPerWallet_) external onlyOwner {
1513       maxPerWallet = maxPerWallet_;
1514   }
1515 
1516   function setmaxSupply(uint256 maxSupply_) external onlyOwner {
1517       maxSupply = maxSupply_;
1518   }
1519 
1520   function _baseURI() internal view virtual override returns (string memory) {
1521     return baseURI;
1522   }
1523 
1524   function withdraw() external onlyOwner nonReentrant {
1525     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1526     require(success, "Transfer failed.");
1527   }
1528 
1529   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1530     _setOwnersExplicit(quantity);
1531   }
1532 
1533   function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory)
1534   {
1535     return ownershipOf(tokenId);
1536   }
1537 
1538 
1539   /**
1540     * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1541     */
1542   function _setOwnersExplicit(uint256 quantity) internal {
1543       require(quantity != 0, "");
1544       require(currentIndex != 0, "");
1545       uint256 _nextOwnerToExplicitlySet = nextOwnerToExplicitlySet;
1546       require(_nextOwnerToExplicitlySet < currentIndex, "");
1547 
1548       // Index underflow is impossible.
1549       // Counter or index overflow is incredibly unrealistic.
1550       unchecked {
1551           uint256 endIndex = _nextOwnerToExplicitlySet + quantity - 1;
1552 
1553           // Set the end index to be the last token index
1554           if (endIndex + 1 > currentIndex) {
1555               endIndex = currentIndex - 1;
1556           }
1557 
1558           for (uint256 i = _nextOwnerToExplicitlySet; i <= endIndex; i++) {
1559               if (_ownerships[i].addr == address(0)) {
1560                   TokenOwnership memory ownership = ownershipOf(i);
1561                   _ownerships[i].addr = ownership.addr;
1562                   _ownerships[i].startTimestamp = ownership.startTimestamp;
1563               }
1564           }
1565 
1566           nextOwnerToExplicitlySet = endIndex + 1;
1567       }
1568   }
1569 }