1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
3 
4 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `to`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address to, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `from` to `to` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(
66         address from,
67         address to,
68         uint256 amount
69     ) external returns (bool);
70 
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
87 
88 
89 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 /**
94  * @dev Contract module that helps prevent reentrant calls to a function.
95  *
96  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
97  * available, which can be applied to functions to make sure there are no nested
98  * (reentrant) calls to them.
99  *
100  * Note that because there is a single `nonReentrant` guard, functions marked as
101  * `nonReentrant` may not call one another. This can be worked around by making
102  * those functions `private`, and then adding `external` `nonReentrant` entry
103  * points to them.
104  *
105  * TIP: If you would like to learn more about reentrancy and alternative ways
106  * to protect against it, check out our blog post
107  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
108  */
109 abstract contract ReentrancyGuard {
110     // Booleans are more expensive than uint256 or any type that takes up a full
111     // word because each write operation emits an extra SLOAD to first read the
112     // slot's contents, replace the bits taken up by the boolean, and then write
113     // back. This is the compiler's defense against contract upgrades and
114     // pointer aliasing, and it cannot be disabled.
115 
116     // The values being non-zero value makes deployment a bit more expensive,
117     // but in exchange the refund on every call to nonReentrant will be lower in
118     // amount. Since refunds are capped to a percentage of the total
119     // transaction's gas, it is best to keep them low in cases like this one, to
120     // increase the likelihood of the full refund coming into effect.
121     uint256 private constant _NOT_ENTERED = 1;
122     uint256 private constant _ENTERED = 2;
123 
124     uint256 private _status;
125 
126     constructor() {
127         _status = _NOT_ENTERED;
128     }
129 
130     /**
131      * @dev Prevents a contract from calling itself, directly or indirectly.
132      * Calling a `nonReentrant` function from another `nonReentrant`
133      * function is not supported. It is possible to prevent this from happening
134      * by making the `nonReentrant` function external, and making it call a
135      * `private` function that does the actual work.
136      */
137     modifier nonReentrant() {
138         // On the first call to nonReentrant, _notEntered will be true
139         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
140 
141         // Any calls to nonReentrant after this point will fail
142         _status = _ENTERED;
143 
144         _;
145 
146         // By storing the original value once again, a refund is triggered (see
147         // https://eips.ethereum.org/EIPS/eip-2200)
148         _status = _NOT_ENTERED;
149     }
150 }
151 
152 // File: @openzeppelin/contracts/utils/Strings.sol
153 
154 
155 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
156 
157 pragma solidity ^0.8.0;
158 
159 /**
160  * @dev String operations.
161  */
162 library Strings {
163     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
164 
165     /**
166      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
167      */
168     function toString(uint256 value) internal pure returns (string memory) {
169         // Inspired by OraclizeAPI's implementation - MIT licence
170         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
171 
172         if (value == 0) {
173             return "0";
174         }
175         uint256 temp = value;
176         uint256 digits;
177         while (temp != 0) {
178             digits++;
179             temp /= 10;
180         }
181         bytes memory buffer = new bytes(digits);
182         while (value != 0) {
183             digits -= 1;
184             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
185             value /= 10;
186         }
187         return string(buffer);
188     }
189 
190     /**
191      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
192      */
193     function toHexString(uint256 value) internal pure returns (string memory) {
194         if (value == 0) {
195             return "0x00";
196         }
197         uint256 temp = value;
198         uint256 length = 0;
199         while (temp != 0) {
200             length++;
201             temp >>= 8;
202         }
203         return toHexString(value, length);
204     }
205 
206     /**
207      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
208      */
209     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
210         bytes memory buffer = new bytes(2 * length + 2);
211         buffer[0] = "0";
212         buffer[1] = "x";
213         for (uint256 i = 2 * length + 1; i > 1; --i) {
214             buffer[i] = _HEX_SYMBOLS[value & 0xf];
215             value >>= 4;
216         }
217         require(value == 0, "Strings: hex length insufficient");
218         return string(buffer);
219     }
220 }
221 
222 // File: @openzeppelin/contracts/utils/Context.sol
223 
224 
225 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
226 
227 pragma solidity ^0.8.0;
228 
229 /**
230  * @dev Provides information about the current execution context, including the
231  * sender of the transaction and its data. While these are generally available
232  * via msg.sender and msg.data, they should not be accessed in such a direct
233  * manner, since when dealing with meta-transactions the account sending and
234  * paying for execution may not be the actual sender (as far as an application
235  * is concerned).
236  *
237  * This contract is only required for intermediate, library-like contracts.
238  */
239 abstract contract Context {
240     function _msgSender() internal view virtual returns (address) {
241         return msg.sender;
242     }
243 
244     function _msgData() internal view virtual returns (bytes calldata) {
245         return msg.data;
246     }
247 }
248 
249 // File: @openzeppelin/contracts/access/Ownable.sol
250 
251 
252 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
253 
254 pragma solidity ^0.8.0;
255 
256 
257 /**
258  * @dev Contract module which provides a basic access control mechanism, where
259  * there is an account (an owner) that can be granted exclusive access to
260  * specific functions.
261  *
262  * By default, the owner account will be the one that deploys the contract. This
263  * can later be changed with {transferOwnership}.
264  *
265  * This module is used through inheritance. It will make available the modifier
266  * `onlyOwner`, which can be applied to your functions to restrict their use to
267  * the owner.
268  */
269 abstract contract Ownable is Context {
270     address private _owner;
271 
272     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
273 
274     /**
275      * @dev Initializes the contract setting the deployer as the initial owner.
276      */
277     constructor() {
278         _transferOwnership(_msgSender());
279     }
280 
281     /**
282      * @dev Returns the address of the current owner.
283      */
284     function owner() public view virtual returns (address) {
285         return _owner;
286     }
287 
288     /**
289      * @dev Throws if called by any account other than the owner.
290      */
291     modifier onlyOwner() {
292         require(owner() == _msgSender(), "Ownable: caller is not the owner");
293         _;
294     }
295 
296     /**
297      * @dev Leaves the contract without owner. It will not be possible to call
298      * `onlyOwner` functions anymore. Can only be called by the current owner.
299      *
300      * NOTE: Renouncing ownership will leave the contract without an owner,
301      * thereby removing any functionality that is only available to the owner.
302      */
303     function renounceOwnership() public virtual onlyOwner {
304         _transferOwnership(address(0));
305     }
306 
307     /**
308      * @dev Transfers ownership of the contract to a new account (`newOwner`).
309      * Can only be called by the current owner.
310      */
311     function transferOwnership(address newOwner) public virtual onlyOwner {
312         require(newOwner != address(0), "Ownable: new owner is the zero address");
313         _transferOwnership(newOwner);
314     }
315 
316     /**
317      * @dev Transfers ownership of the contract to a new account (`newOwner`).
318      * Internal function without access restriction.
319      */
320     function _transferOwnership(address newOwner) internal virtual {
321         address oldOwner = _owner;
322         _owner = newOwner;
323         emit OwnershipTransferred(oldOwner, newOwner);
324     }
325 }
326 
327 // File: @openzeppelin/contracts/utils/Address.sol
328 
329 
330 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
331 
332 pragma solidity ^0.8.1;
333 
334 /**
335  * @dev Collection of functions related to the address type
336  */
337 library Address {
338     /**
339      * @dev Returns true if `account` is a contract.
340      *
341      * [IMPORTANT]
342      * ====
343      * It is unsafe to assume that an address for which this function returns
344      * false is an externally-owned account (EOA) and not a contract.
345      *
346      * Among others, `isContract` will return false for the following
347      * types of addresses:
348      *
349      *  - an externally-owned account
350      *  - a contract in construction
351      *  - an address where a contract will be created
352      *  - an address where a contract lived, but was destroyed
353      * ====
354      *
355      * [IMPORTANT]
356      * ====
357      * You shouldn't rely on `isContract` to protect against flash loan attacks!
358      *
359      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
360      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
361      * constructor.
362      * ====
363      */
364     function isContract(address account) internal view returns (bool) {
365         // This method relies on extcodesize/address.code.length, which returns 0
366         // for contracts in construction, since the code is only stored at the end
367         // of the constructor execution.
368 
369         return account.code.length > 0;
370     }
371 
372     /**
373      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
374      * `recipient`, forwarding all available gas and reverting on errors.
375      *
376      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
377      * of certain opcodes, possibly making contracts go over the 2300 gas limit
378      * imposed by `transfer`, making them unable to receive funds via
379      * `transfer`. {sendValue} removes this limitation.
380      *
381      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
382      *
383      * IMPORTANT: because control is transferred to `recipient`, care must be
384      * taken to not create reentrancy vulnerabilities. Consider using
385      * {ReentrancyGuard} or the
386      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
387      */
388     function sendValue(address payable recipient, uint256 amount) internal {
389         require(address(this).balance >= amount, "Address: insufficient balance");
390 
391         (bool success, ) = recipient.call{value: amount}("");
392         require(success, "Address: unable to send value, recipient may have reverted");
393     }
394 
395     /**
396      * @dev Performs a Solidity function call using a low level `call`. A
397      * plain `call` is an unsafe replacement for a function call: use this
398      * function instead.
399      *
400      * If `target` reverts with a revert reason, it is bubbled up by this
401      * function (like regular Solidity function calls).
402      *
403      * Returns the raw returned data. To convert to the expected return value,
404      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
405      *
406      * Requirements:
407      *
408      * - `target` must be a contract.
409      * - calling `target` with `data` must not revert.
410      *
411      * _Available since v3.1._
412      */
413     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
414         return functionCall(target, data, "Address: low-level call failed");
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
419      * `errorMessage` as a fallback revert reason when `target` reverts.
420      *
421      * _Available since v3.1._
422      */
423     function functionCall(
424         address target,
425         bytes memory data,
426         string memory errorMessage
427     ) internal returns (bytes memory) {
428         return functionCallWithValue(target, data, 0, errorMessage);
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
433      * but also transferring `value` wei to `target`.
434      *
435      * Requirements:
436      *
437      * - the calling contract must have an ETH balance of at least `value`.
438      * - the called Solidity function must be `payable`.
439      *
440      * _Available since v3.1._
441      */
442     function functionCallWithValue(
443         address target,
444         bytes memory data,
445         uint256 value
446     ) internal returns (bytes memory) {
447         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
452      * with `errorMessage` as a fallback revert reason when `target` reverts.
453      *
454      * _Available since v3.1._
455      */
456     function functionCallWithValue(
457         address target,
458         bytes memory data,
459         uint256 value,
460         string memory errorMessage
461     ) internal returns (bytes memory) {
462         require(address(this).balance >= value, "Address: insufficient balance for call");
463         require(isContract(target), "Address: call to non-contract");
464 
465         (bool success, bytes memory returndata) = target.call{value: value}(data);
466         return verifyCallResult(success, returndata, errorMessage);
467     }
468 
469     /**
470      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
471      * but performing a static call.
472      *
473      * _Available since v3.3._
474      */
475     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
476         return functionStaticCall(target, data, "Address: low-level static call failed");
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
481      * but performing a static call.
482      *
483      * _Available since v3.3._
484      */
485     function functionStaticCall(
486         address target,
487         bytes memory data,
488         string memory errorMessage
489     ) internal view returns (bytes memory) {
490         require(isContract(target), "Address: static call to non-contract");
491 
492         (bool success, bytes memory returndata) = target.staticcall(data);
493         return verifyCallResult(success, returndata, errorMessage);
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
498      * but performing a delegate call.
499      *
500      * _Available since v3.4._
501      */
502     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
503         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
504     }
505 
506     /**
507      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
508      * but performing a delegate call.
509      *
510      * _Available since v3.4._
511      */
512     function functionDelegateCall(
513         address target,
514         bytes memory data,
515         string memory errorMessage
516     ) internal returns (bytes memory) {
517         require(isContract(target), "Address: delegate call to non-contract");
518 
519         (bool success, bytes memory returndata) = target.delegatecall(data);
520         return verifyCallResult(success, returndata, errorMessage);
521     }
522 
523     /**
524      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
525      * revert reason using the provided one.
526      *
527      * _Available since v4.3._
528      */
529     function verifyCallResult(
530         bool success,
531         bytes memory returndata,
532         string memory errorMessage
533     ) internal pure returns (bytes memory) {
534         if (success) {
535             return returndata;
536         } else {
537             // Look for revert reason and bubble it up if present
538             if (returndata.length > 0) {
539                 // The easiest way to bubble the revert reason is using memory via assembly
540 
541                 assembly {
542                     let returndata_size := mload(returndata)
543                     revert(add(32, returndata), returndata_size)
544                 }
545             } else {
546                 revert(errorMessage);
547             }
548         }
549     }
550 }
551 
552 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
553 
554 
555 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
556 
557 pragma solidity ^0.8.0;
558 
559 
560 
561 /**
562  * @title SafeERC20
563  * @dev Wrappers around ERC20 operations that throw on failure (when the token
564  * contract returns false). Tokens that return no value (and instead revert or
565  * throw on failure) are also supported, non-reverting calls are assumed to be
566  * successful.
567  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
568  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
569  */
570 library SafeERC20 {
571     using Address for address;
572 
573     function safeTransfer(
574         IERC20 token,
575         address to,
576         uint256 value
577     ) internal {
578         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
579     }
580 
581     function safeTransferFrom(
582         IERC20 token,
583         address from,
584         address to,
585         uint256 value
586     ) internal {
587         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
588     }
589 
590     /**
591      * @dev Deprecated. This function has issues similar to the ones found in
592      * {IERC20-approve}, and its usage is discouraged.
593      *
594      * Whenever possible, use {safeIncreaseAllowance} and
595      * {safeDecreaseAllowance} instead.
596      */
597     function safeApprove(
598         IERC20 token,
599         address spender,
600         uint256 value
601     ) internal {
602         // safeApprove should only be called when setting an initial allowance,
603         // or when resetting it to zero. To increase and decrease it, use
604         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
605         require(
606             (value == 0) || (token.allowance(address(this), spender) == 0),
607             "SafeERC20: approve from non-zero to non-zero allowance"
608         );
609         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
610     }
611 
612     function safeIncreaseAllowance(
613         IERC20 token,
614         address spender,
615         uint256 value
616     ) internal {
617         uint256 newAllowance = token.allowance(address(this), spender) + value;
618         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
619     }
620 
621     function safeDecreaseAllowance(
622         IERC20 token,
623         address spender,
624         uint256 value
625     ) internal {
626         unchecked {
627             uint256 oldAllowance = token.allowance(address(this), spender);
628             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
629             uint256 newAllowance = oldAllowance - value;
630             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
631         }
632     }
633 
634     /**
635      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
636      * on the return value: the return value is optional (but if data is returned, it must not be false).
637      * @param token The token targeted by the call.
638      * @param data The call data (encoded using abi.encode or one of its variants).
639      */
640     function _callOptionalReturn(IERC20 token, bytes memory data) private {
641         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
642         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
643         // the target address contains contract code and also asserts for success in the low-level call.
644 
645         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
646         if (returndata.length > 0) {
647             // Return data is optional
648             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
649         }
650     }
651 }
652 
653 
654 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
655 
656 
657 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
658 
659 pragma solidity ^0.8.0;
660 
661 /**
662  * @title ERC721 token receiver interface
663  * @dev Interface for any contract that wants to support safeTransfers
664  * from ERC721 asset contracts.
665  */
666 interface IERC721Receiver {
667     /**
668      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
669      * by `operator` from `from`, this function is called.
670      *
671      * It must return its Solidity selector to confirm the token transfer.
672      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
673      *
674      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
675      */
676     function onERC721Received(
677         address operator,
678         address from,
679         uint256 tokenId,
680         bytes calldata data
681     ) external returns (bytes4);
682 }
683 
684 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
685 
686 
687 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
688 
689 pragma solidity ^0.8.0;
690 
691 /**
692  * @dev Interface of the ERC165 standard, as defined in the
693  * https://eips.ethereum.org/EIPS/eip-165[EIP].
694  *
695  * Implementers can declare support of contract interfaces, which can then be
696  * queried by others ({ERC165Checker}).
697  *
698  * For an implementation, see {ERC165}.
699  */
700 interface IERC165 {
701     /**
702      * @dev Returns true if this contract implements the interface defined by
703      * `interfaceId`. See the corresponding
704      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
705      * to learn more about how these ids are created.
706      *
707      * This function call must use less than 30 000 gas.
708      */
709     function supportsInterface(bytes4 interfaceId) external view returns (bool);
710 }
711 
712 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
713 
714 
715 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
716 
717 pragma solidity ^0.8.0;
718 
719 
720 /**
721  * @dev Implementation of the {IERC165} interface.
722  *
723  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
724  * for the additional interface id that will be supported. For example:
725  *
726  * ```solidity
727  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
728  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
729  * }
730  * ```
731  *
732  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
733  */
734 abstract contract ERC165 is IERC165 {
735     /**
736      * @dev See {IERC165-supportsInterface}.
737      */
738     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
739         return interfaceId == type(IERC165).interfaceId;
740     }
741 }
742 
743 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
744 
745 
746 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
747 
748 pragma solidity ^0.8.0;
749 
750 
751 /**
752  * @dev Required interface of an ERC721 compliant contract.
753  */
754 interface IERC721 is IERC165 {
755     /**
756      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
757      */
758     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
759 
760     /**
761      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
762      */
763     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
764 
765     /**
766      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
767      */
768     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
769 
770     /**
771      * @dev Returns the number of tokens in ``owner``'s account.
772      */
773     function balanceOf(address owner) external view returns (uint256 balance);
774 
775     /**
776      * @dev Returns the owner of the `tokenId` token.
777      *
778      * Requirements:
779      *
780      * - `tokenId` must exist.
781      */
782     function ownerOf(uint256 tokenId) external view returns (address owner);
783 
784     /**
785      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
786      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
787      *
788      * Requirements:
789      *
790      * - `from` cannot be the zero address.
791      * - `to` cannot be the zero address.
792      * - `tokenId` token must exist and be owned by `from`.
793      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
794      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
795      *
796      * Emits a {Transfer} event.
797      */
798     function safeTransferFrom(
799         address from,
800         address to,
801         uint256 tokenId
802     ) external;
803 
804     /**
805      * @dev Transfers `tokenId` token from `from` to `to`.
806      *
807      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
808      *
809      * Requirements:
810      *
811      * - `from` cannot be the zero address.
812      * - `to` cannot be the zero address.
813      * - `tokenId` token must be owned by `from`.
814      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
815      *
816      * Emits a {Transfer} event.
817      */
818     function transferFrom(
819         address from,
820         address to,
821         uint256 tokenId
822     ) external;
823 
824     /**
825      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
826      * The approval is cleared when the token is transferred.
827      *
828      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
829      *
830      * Requirements:
831      *
832      * - The caller must own the token or be an approved operator.
833      * - `tokenId` must exist.
834      *
835      * Emits an {Approval} event.
836      */
837     function approve(address to, uint256 tokenId) external;
838 
839     /**
840      * @dev Returns the account approved for `tokenId` token.
841      *
842      * Requirements:
843      *
844      * - `tokenId` must exist.
845      */
846     function getApproved(uint256 tokenId) external view returns (address operator);
847 
848     /**
849      * @dev Approve or remove `operator` as an operator for the caller.
850      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
851      *
852      * Requirements:
853      *
854      * - The `operator` cannot be the caller.
855      *
856      * Emits an {ApprovalForAll} event.
857      */
858     function setApprovalForAll(address operator, bool _approved) external;
859 
860     /**
861      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
862      *
863      * See {setApprovalForAll}
864      */
865     function isApprovedForAll(address owner, address operator) external view returns (bool);
866 
867     /**
868      * @dev Safely transfers `tokenId` token from `from` to `to`.
869      *
870      * Requirements:
871      *
872      * - `from` cannot be the zero address.
873      * - `to` cannot be the zero address.
874      * - `tokenId` token must exist and be owned by `from`.
875      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
876      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
877      *
878      * Emits a {Transfer} event.
879      */
880     function safeTransferFrom(
881         address from,
882         address to,
883         uint256 tokenId,
884         bytes calldata data
885     ) external;
886 }
887 
888 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
889 
890 
891 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
892 
893 pragma solidity ^0.8.0;
894 
895 
896 /**
897  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
898  * @dev See https://eips.ethereum.org/EIPS/eip-721
899  */
900 interface IERC721Enumerable is IERC721 {
901     /**
902      * @dev Returns the total amount of tokens stored by the contract.
903      */
904     function totalSupply() external view returns (uint256);
905 
906     /**
907      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
908      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
909      */
910     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
911 
912     /**
913      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
914      * Use along with {totalSupply} to enumerate all tokens.
915      */
916     function tokenByIndex(uint256 index) external view returns (uint256);
917 }
918 
919 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
920 
921 
922 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
923 
924 pragma solidity ^0.8.0;
925 
926 
927 /**
928  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
929  * @dev See https://eips.ethereum.org/EIPS/eip-721
930  */
931 interface IERC721Metadata is IERC721 {
932     /**
933      * @dev Returns the token collection name.
934      */
935     function name() external view returns (string memory);
936 
937     /**
938      * @dev Returns the token collection symbol.
939      */
940     function symbol() external view returns (string memory);
941 
942     /**
943      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
944      */
945     function tokenURI(uint256 tokenId) external view returns (string memory);
946 }
947 
948 // File: contracts/TwistedToonz.sol
949 
950 
951 // Creator: Chiru Labs
952 
953 pragma solidity ^0.8.0;
954 
955 
956 
957 
958 
959 
960 
961 
962 
963 /**
964  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
965  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
966  *
967  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
968  *
969  * Does not support burning tokens to address(0).
970  *
971  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
972  */
973 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
974     using Address for address;
975     using Strings for uint256;
976 
977     struct TokenOwnership {
978         address addr;
979         uint64 startTimestamp;
980     }
981 
982     struct AddressData {
983         uint128 balance;
984         uint128 numberMinted;
985     }
986 
987     uint256 internal currentIndex;
988 
989     // Token name
990     string private _name;
991 
992     // Token symbol
993     string private _symbol;
994 
995     // Mapping from token ID to ownership details
996     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
997     mapping(uint256 => TokenOwnership) internal _ownerships;
998 
999     // Mapping owner address to address data
1000     mapping(address => AddressData) private _addressData;
1001 
1002     // Mapping from token ID to approved address
1003     mapping(uint256 => address) private _tokenApprovals;
1004 
1005     // Mapping from owner to operator approvals
1006     mapping(address => mapping(address => bool)) private _operatorApprovals;
1007 
1008     constructor(string memory name_, string memory symbol_) {
1009         _name = name_;
1010         _symbol = symbol_;
1011     }
1012 
1013     /**
1014      * @dev See {IERC721Enumerable-totalSupply}.
1015      */
1016     function totalSupply() public view override returns (uint256) {
1017         return currentIndex;
1018     }
1019 
1020     /**
1021      * @dev See {IERC721Enumerable-tokenByIndex}.
1022      */
1023     function tokenByIndex(uint256 index) public view override returns (uint256) {
1024         require(index < totalSupply(), "ERC721A: global index out of bounds");
1025         return index;
1026     }
1027 
1028     /**
1029      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1030      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1031      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1032      */
1033     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1034         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1035         uint256 numMintedSoFar = totalSupply();
1036         uint256 tokenIdsIdx;
1037         address currOwnershipAddr;
1038 
1039         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1040         unchecked {
1041             for (uint256 i; i < numMintedSoFar; i++) {
1042                 TokenOwnership memory ownership = _ownerships[i];
1043                 if (ownership.addr != address(0)) {
1044                     currOwnershipAddr = ownership.addr;
1045                 }
1046                 if (currOwnershipAddr == owner) {
1047                     if (tokenIdsIdx == index) {
1048                         return i;
1049                     }
1050                     tokenIdsIdx++;
1051                 }
1052             }
1053         }
1054 
1055         revert("ERC721A: unable to get token of owner by index");
1056     }
1057 
1058     /**
1059      * @dev See {IERC165-supportsInterface}.
1060      */
1061     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1062         return
1063             interfaceId == type(IERC721).interfaceId ||
1064             interfaceId == type(IERC721Metadata).interfaceId ||
1065             interfaceId == type(IERC721Enumerable).interfaceId ||
1066             super.supportsInterface(interfaceId);
1067     }
1068 
1069     /**
1070      * @dev See {IERC721-balanceOf}.
1071      */
1072     function balanceOf(address owner) public view override returns (uint256) {
1073         require(owner != address(0), "ERC721A: balance query for the zero address");
1074         return uint256(_addressData[owner].balance);
1075     }
1076 
1077     function _numberMinted(address owner) internal view returns (uint256) {
1078         require(owner != address(0), "ERC721A: number minted query for the zero address");
1079         return uint256(_addressData[owner].numberMinted);
1080     }
1081 
1082     /**
1083      * Gas spent here starts off proportional to the maximum mint batch size.
1084      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1085      */
1086     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1087         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1088 
1089         unchecked {
1090             for (uint256 curr = tokenId; curr >= 0; curr--) {
1091                 TokenOwnership memory ownership = _ownerships[curr];
1092                 if (ownership.addr != address(0)) {
1093                     return ownership;
1094                 }
1095             }
1096         }
1097 
1098         revert("ERC721A: unable to determine the owner of token");
1099     }
1100 
1101     /**
1102      * @dev See {IERC721-ownerOf}.
1103      */
1104     function ownerOf(uint256 tokenId) public view override returns (address) {
1105         return ownershipOf(tokenId).addr;
1106     }
1107 
1108     /**
1109      * @dev See {IERC721Metadata-name}.
1110      */
1111     function name() public view virtual override returns (string memory) {
1112         return _name;
1113     }
1114 
1115     /**
1116      * @dev See {IERC721Metadata-symbol}.
1117      */
1118     function symbol() public view virtual override returns (string memory) {
1119         return _symbol;
1120     }
1121 
1122     /**
1123      * @dev See {IERC721Metadata-tokenURI}.
1124      */
1125     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1126         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1127 
1128         string memory baseURI = _baseURI();
1129         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1130     }
1131 
1132     /**
1133      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1134      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1135      * by default, can be overriden in child contracts.
1136      */
1137     function _baseURI() internal view virtual returns (string memory) {
1138         return "";
1139     }
1140 
1141     /**
1142      * @dev See {IERC721-approve}.
1143      */
1144     function approve(address to, uint256 tokenId) public override {
1145         address owner = ERC721A.ownerOf(tokenId);
1146         require(to != owner, "ERC721A: approval to current owner");
1147 
1148         require(
1149             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1150             "ERC721A: approve caller is not owner nor approved for all"
1151         );
1152 
1153         _approve(to, tokenId, owner);
1154     }
1155 
1156     /**
1157      * @dev See {IERC721-getApproved}.
1158      */
1159     function getApproved(uint256 tokenId) public view override returns (address) {
1160         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1161 
1162         return _tokenApprovals[tokenId];
1163     }
1164 
1165     /**
1166      * @dev See {IERC721-setApprovalForAll}.
1167      */
1168     function setApprovalForAll(address operator, bool approved) public override {
1169         require(operator != _msgSender(), "ERC721A: approve to caller");
1170 
1171         _operatorApprovals[_msgSender()][operator] = approved;
1172         emit ApprovalForAll(_msgSender(), operator, approved);
1173     }
1174 
1175     /**
1176      * @dev See {IERC721-isApprovedForAll}.
1177      */
1178     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1179         return _operatorApprovals[owner][operator];
1180     }
1181 
1182     /**
1183      * @dev See {IERC721-transferFrom}.
1184      */
1185     function transferFrom(
1186         address from,
1187         address to,
1188         uint256 tokenId
1189     ) public virtual override {
1190         _transfer(from, to, tokenId);
1191     }
1192 
1193     /**
1194      * @dev See {IERC721-safeTransferFrom}.
1195      */
1196     function safeTransferFrom(
1197         address from,
1198         address to,
1199         uint256 tokenId
1200     ) public virtual override {
1201         safeTransferFrom(from, to, tokenId, "");
1202     }
1203 
1204     /**
1205      * @dev See {IERC721-safeTransferFrom}.
1206      */
1207     function safeTransferFrom(
1208         address from,
1209         address to,
1210         uint256 tokenId,
1211         bytes memory _data
1212     ) public override {
1213         _transfer(from, to, tokenId);
1214         require(
1215             _checkOnERC721Received(from, to, tokenId, _data),
1216             "ERC721A: transfer to non ERC721Receiver implementer"
1217         );
1218     }
1219 
1220     /**
1221      * @dev Returns whether `tokenId` exists.
1222      *
1223      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1224      *
1225      * Tokens start existing when they are minted (`_mint`),
1226      */
1227     function _exists(uint256 tokenId) internal view returns (bool) {
1228         return tokenId < currentIndex;
1229     }
1230 
1231     function _safeMint(address to, uint256 quantity) internal {
1232         _safeMint(to, quantity, "");
1233     }
1234 
1235     /**
1236      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1237      *
1238      * Requirements:
1239      *
1240      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1241      * - `quantity` must be greater than 0.
1242      *
1243      * Emits a {Transfer} event.
1244      */
1245     function _safeMint(
1246         address to,
1247         uint256 quantity,
1248         bytes memory _data
1249     ) internal {
1250         _mint(to, quantity, _data, true);
1251     }
1252 
1253     /**
1254      * @dev Mints `quantity` tokens and transfers them to `to`.
1255      *
1256      * Requirements:
1257      *
1258      * - `to` cannot be the zero address.
1259      * - `quantity` must be greater than 0.
1260      *
1261      * Emits a {Transfer} event.
1262      */
1263     function _mint(
1264         address to,
1265         uint256 quantity,
1266         bytes memory _data,
1267         bool safe
1268     ) internal {
1269         uint256 startTokenId = currentIndex;
1270         require(to != address(0), "ERC721A: mint to the zero address");
1271         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1272 
1273         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1274 
1275         // Overflows are incredibly unrealistic.
1276         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1277         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1278         unchecked {
1279             _addressData[to].balance += uint128(quantity);
1280             _addressData[to].numberMinted += uint128(quantity);
1281 
1282             _ownerships[startTokenId].addr = to;
1283             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1284 
1285             uint256 updatedIndex = startTokenId;
1286 
1287             for (uint256 i; i < quantity; i++) {
1288                 emit Transfer(address(0), to, updatedIndex);
1289                 if (safe) {
1290                     require(
1291                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1292                         "ERC721A: transfer to non ERC721Receiver implementer"
1293                     );
1294                 }
1295 
1296                 updatedIndex++;
1297             }
1298 
1299             currentIndex = updatedIndex;
1300         }
1301 
1302         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1303     }
1304 
1305     /**
1306      * @dev Transfers `tokenId` from `from` to `to`.
1307      *
1308      * Requirements:
1309      *
1310      * - `to` cannot be the zero address.
1311      * - `tokenId` token must be owned by `from`.
1312      *
1313      * Emits a {Transfer} event.
1314      */
1315     function _transfer(
1316         address from,
1317         address to,
1318         uint256 tokenId
1319     ) private {
1320         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1321 
1322         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1323             getApproved(tokenId) == _msgSender() ||
1324             isApprovedForAll(prevOwnership.addr, _msgSender()));
1325 
1326         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1327 
1328         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1329         require(to != address(0), "ERC721A: transfer to the zero address");
1330 
1331         _beforeTokenTransfers(from, to, tokenId, 1);
1332 
1333         // Clear approvals from the previous owner
1334         _approve(address(0), tokenId, prevOwnership.addr);
1335 
1336         // Underflow of the sender's balance is impossible because we check for
1337         // ownership above and the recipient's balance can't realistically overflow.
1338         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1339         unchecked {
1340             _addressData[from].balance -= 1;
1341             _addressData[to].balance += 1;
1342 
1343             _ownerships[tokenId].addr = to;
1344             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1345 
1346             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1347             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1348             uint256 nextTokenId = tokenId + 1;
1349             if (_ownerships[nextTokenId].addr == address(0)) {
1350                 if (_exists(nextTokenId)) {
1351                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1352                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1353                 }
1354             }
1355         }
1356 
1357         emit Transfer(from, to, tokenId);
1358         _afterTokenTransfers(from, to, tokenId, 1);
1359     }
1360 
1361     /**
1362      * @dev Approve `to` to operate on `tokenId`
1363      *
1364      * Emits a {Approval} event.
1365      */
1366     function _approve(
1367         address to,
1368         uint256 tokenId,
1369         address owner
1370     ) private {
1371         _tokenApprovals[tokenId] = to;
1372         emit Approval(owner, to, tokenId);
1373     }
1374 
1375     /**
1376      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1377      * The call is not executed if the target address is not a contract.
1378      *
1379      * @param from address representing the previous owner of the given token ID
1380      * @param to target address that will receive the tokens
1381      * @param tokenId uint256 ID of the token to be transferred
1382      * @param _data bytes optional data to send along with the call
1383      * @return bool whether the call correctly returned the expected magic value
1384      */
1385     function _checkOnERC721Received(
1386         address from,
1387         address to,
1388         uint256 tokenId,
1389         bytes memory _data
1390     ) private returns (bool) {
1391         if (to.isContract()) {
1392             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1393                 return retval == IERC721Receiver(to).onERC721Received.selector;
1394             } catch (bytes memory reason) {
1395                 if (reason.length == 0) {
1396                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1397                 } else {
1398                     assembly {
1399                         revert(add(32, reason), mload(reason))
1400                     }
1401                 }
1402             }
1403         } else {
1404             return true;
1405         }
1406     }
1407 
1408     /**
1409      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1410      *
1411      * startTokenId - the first token id to be transferred
1412      * quantity - the amount to be transferred
1413      *
1414      * Calling conditions:
1415      *
1416      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1417      * transferred to `to`.
1418      * - When `from` is zero, `tokenId` will be minted for `to`.
1419      */
1420     function _beforeTokenTransfers(
1421         address from,
1422         address to,
1423         uint256 startTokenId,
1424         uint256 quantity
1425     ) internal virtual {}
1426 
1427     /**
1428      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1429      * minting.
1430      *
1431      * startTokenId - the first token id to be transferred
1432      * quantity - the amount to be transferred
1433      *
1434      * Calling conditions:
1435      *
1436      * - when `from` and `to` are both non-zero.
1437      * - `from` and `to` are never both zero.
1438      */
1439     function _afterTokenTransfers(
1440         address from,
1441         address to,
1442         uint256 startTokenId,
1443         uint256 quantity
1444     ) internal virtual {}
1445 }
1446 
1447 contract OffTheChain is ERC721A, Ownable, ReentrancyGuard {
1448 
1449   uint public   price = 0 ether;
1450   uint public   maxPerTx = 1;
1451   uint public   maxSupply = 210;
1452   uint public   maxPerWallet = 1;
1453   bool public   mintEnabled;
1454   uint public   nextOwnerToExplicitlySet;
1455   string public baseURI;
1456 
1457   constructor() ERC721A("OffTheChain", "OTC") {}
1458 
1459   function mint(uint256 qty_) external payable {
1460     require( qty_ < maxPerTx + 1, "Too Many per TX");
1461     require(msg.sender == tx.origin,"Mismatched origin!");
1462     require(msg.value == qty_ * price,"Please send the exact amount.");
1463     require(totalSupply() + qty_ < maxSupply + 1,"Not enough supply.");
1464     require(mintEnabled, "Not minting rn.");
1465     require(numberMinted(msg.sender) + qty_ < maxPerWallet + 1,"Too many per wallet.");
1466     _safeMint(msg.sender, qty_);
1467   }
1468   function reserve(uint256 amount) external onlyOwner {
1469     require(totalSupply() + amount < maxSupply + 1,"not enough supply, dev.");
1470     _safeMint(msg.sender, amount);
1471   }
1472 
1473   function toggleMinting() external onlyOwner {
1474       mintEnabled = !mintEnabled;
1475   }
1476   function numberMinted(address owner) public view returns (uint256) {
1477     return _numberMinted(owner);
1478   }
1479   function setBaseURI(string calldata baseURI_) external onlyOwner {
1480     baseURI = baseURI_;
1481   }
1482   function setPrice(uint256 price_) external onlyOwner {
1483       price = price_;
1484   }
1485   function setMaxPerTx(uint256 maxPerTx_) external onlyOwner {
1486       maxPerTx = maxPerTx_;
1487   }
1488   function setMaxPerWallet(uint256 maxPerWallet_) external onlyOwner {
1489       maxPerWallet = maxPerWallet_;
1490   }
1491   function setMaxSupply(uint256 maxSupply_) external onlyOwner {
1492       maxSupply = maxSupply_;
1493   }
1494   function _baseURI() internal view virtual override returns (string memory) {
1495     return baseURI;
1496   }
1497   function withdraw() external onlyOwner nonReentrant {
1498     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1499     require(success, "Transfer failed.");
1500   }
1501   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1502     _setOwnersExplicit(quantity);
1503   }
1504   function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1505     return ownershipOf(tokenId);
1506   }
1507   function _setOwnersExplicit(uint256 quantity) internal {
1508       require(quantity != 0, "quantity must be nonzero");
1509       require(currentIndex != 0, "no tokens minted yet");
1510       uint256 _nextOwnerToExplicitlySet = nextOwnerToExplicitlySet;
1511       require(_nextOwnerToExplicitlySet < currentIndex, "all ownerships have been set");
1512 
1513       // Index underflow is impossible.
1514       // Counter or index overflow is incredibly unrealistic.
1515       unchecked {
1516           uint256 endIndex = _nextOwnerToExplicitlySet + quantity - 1;
1517 
1518           // Set the end index to be the last token index
1519           if (endIndex + 1 > currentIndex) {
1520               endIndex = currentIndex - 1;
1521           }
1522 
1523           for (uint256 i = _nextOwnerToExplicitlySet; i <= endIndex; i++) {
1524               if (_ownerships[i].addr == address(0)) {
1525                   TokenOwnership memory ownership = ownershipOf(i);
1526                   _ownerships[i].addr = ownership.addr;
1527                   _ownerships[i].startTimestamp = ownership.startTimestamp;
1528               }
1529           }
1530 
1531           nextOwnerToExplicitlySet = endIndex + 1;
1532       }
1533   }
1534 }