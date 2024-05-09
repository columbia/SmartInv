1 // SPDX-License-Identifier: MIT
2 /**
3  *
4 
5 
6 10E Actually Programmed
7 
8 
9 How? 
10 When the price is dropping in a 10 minute interval 
11 - royalties are set to 69% 
12 - all new listed nfts (floor) are burned in intervals
13 (Average sales in the 10 minute period < Average sales in the 10 previous minute period)
14 
15 When the price is increasing in a 10 minute interval
16 - royalties set back to 9%
17 - listed nfts will not be burned and sales can be sold like normal
18 - profits will be reinvested back into the burning
19 
20 Details:
21 
22 Supply: 888
23 Price: All Free
24 1 per person
25 
26 
27 */
28 
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @dev Interface of the ERC20 standard as defined in the EIP.
34  */
35 interface IERC20 {
36     /**
37      * @dev Returns the amount of tokens in existence.
38      */
39     function totalSupply() external view returns (uint256);
40 
41     /**
42      * @dev Returns the amount of tokens owned by `account`.
43      */
44     function balanceOf(address account) external view returns (uint256);
45 
46     /**
47      * @dev Moves `amount` tokens from the caller's account to `to`.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * Emits a {Transfer} event.
52      */
53     function transfer(address to, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Returns the remaining number of tokens that `spender` will be
57      * allowed to spend on behalf of `owner` through {transferFrom}. This is
58      * zero by default.
59      *
60      * This value changes when {approve} or {transferFrom} are called.
61      */
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     /**
65      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * IMPORTANT: Beware that changing an allowance with this method brings the risk
70      * that someone may use both the old and the new allowance by unfortunate
71      * transaction ordering. One possible solution to mitigate this race
72      * condition is to first reduce the spender's allowance to 0 and set the
73      * desired value afterwards:
74      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75      *
76      * Emits an {Approval} event.
77      */
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Moves `amount` tokens from `from` to `to` using the
82      * allowance mechanism. `amount` is then deducted from the caller's
83      * allowance.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transferFrom(
90         address from,
91         address to,
92         uint256 amount
93     ) external returns (bool);
94 
95     /**
96      * @dev Emitted when `value` tokens are moved from one account (`from`) to
97      * another (`to`).
98      *
99      * Note that `value` may be zero.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     /**
104      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
105      * a call to {approve}. `value` is the new allowance.
106      */
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
111 
112 
113 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
114 
115 pragma solidity ^0.8.0;
116 
117 /**
118  * @dev Contract module that helps prevent reentrant calls to a function.
119  *
120  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
121  * available, which can be applied to functions to make sure there are no nested
122  * (reentrant) calls to them.
123  *
124  * Note that because there is a single `nonReentrant` guard, functions marked as
125  * `nonReentrant` may not call one another. This can be worked around by making
126  * those functions `private`, and then adding `external` `nonReentrant` entry
127  * points to them.
128  *
129  * TIP: If you would like to learn more about reentrancy and alternative ways
130  * to protect against it, check out our blog post
131  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
132  */
133 abstract contract ReentrancyGuard {
134     // Booleans are more expensive than uint256 or any type that takes up a full
135     // word because each write operation emits an extra SLOAD to first read the
136     // slot's contents, replace the bits taken up by the boolean, and then write
137     // back. This is the compiler's defense against contract upgrades and
138     // pointer aliasing, and it cannot be disabled.
139 
140     // The values being non-zero value makes deployment a bit more expensive,
141     // but in exchange the refund on every call to nonReentrant will be lower in
142     // amount. Since refunds are capped to a percentage of the total
143     // transaction's gas, it is best to keep them low in cases like this one, to
144     // increase the likelihood of the full refund coming into effect.
145     uint256 private constant _NOT_ENTERED = 1;
146     uint256 private constant _ENTERED = 2;
147 
148     uint256 private _status;
149 
150     constructor() {
151         _status = _NOT_ENTERED;
152     }
153 
154     /**
155      * @dev Prevents a contract from calling itself, directly or indirectly.
156      * Calling a `nonReentrant` function from another `nonReentrant`
157      * function is not supported. It is possible to prevent this from happening
158      * by making the `nonReentrant` function external, and making it call a
159      * `private` function that does the actual work.
160      */
161     modifier nonReentrant() {
162         // On the first call to nonReentrant, _notEntered will be true
163         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
164 
165         // Any calls to nonReentrant after this point will fail
166         _status = _ENTERED;
167 
168         _;
169 
170         // By storing the original value once again, a refund is triggered (see
171         // https://eips.ethereum.org/EIPS/eip-2200)
172         _status = _NOT_ENTERED;
173     }
174 }
175 
176 // File: @openzeppelin/contracts/utils/Strings.sol
177 
178 
179 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
180 
181 pragma solidity ^0.8.0;
182 
183 /**
184  * @dev String operations.
185  */
186 library Strings {
187     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
188 
189     /**
190      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
191      */
192     function toString(uint256 value) internal pure returns (string memory) {
193         // Inspired by OraclizeAPI's implementation - MIT licence
194         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
195 
196         if (value == 0) {
197             return "0";
198         }
199         uint256 temp = value;
200         uint256 digits;
201         while (temp != 0) {
202             digits++;
203             temp /= 10;
204         }
205         bytes memory buffer = new bytes(digits);
206         while (value != 0) {
207             digits -= 1;
208             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
209             value /= 10;
210         }
211         return string(buffer);
212     }
213 
214     /**
215      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
216      */
217     function toHexString(uint256 value) internal pure returns (string memory) {
218         if (value == 0) {
219             return "0x00";
220         }
221         uint256 temp = value;
222         uint256 length = 0;
223         while (temp != 0) {
224             length++;
225             temp >>= 8;
226         }
227         return toHexString(value, length);
228     }
229 
230     /**
231      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
232      */
233     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
234         bytes memory buffer = new bytes(2 * length + 2);
235         buffer[0] = "0";
236         buffer[1] = "x";
237         for (uint256 i = 2 * length + 1; i > 1; --i) {
238             buffer[i] = _HEX_SYMBOLS[value & 0xf];
239             value >>= 4;
240         }
241         require(value == 0, "Strings: hex length insufficient");
242         return string(buffer);
243     }
244 }
245 
246 // File: @openzeppelin/contracts/utils/Context.sol
247 
248 
249 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
250 
251 pragma solidity ^0.8.0;
252 
253 /**
254  * @dev Provides information about the current execution context, including the
255  * sender of the transaction and its data. While these are generally available
256  * via msg.sender and msg.data, they should not be accessed in such a direct
257  * manner, since when dealing with meta-transactions the account sending and
258  * paying for execution may not be the actual sender (as far as an application
259  * is concerned).
260  *
261  * This contract is only required for intermediate, library-like contracts.
262  */
263 abstract contract Context {
264     function _msgSender() internal view virtual returns (address) {
265         return msg.sender;
266     }
267 
268     function _msgData() internal view virtual returns (bytes calldata) {
269         return msg.data;
270     }
271 }
272 
273 // File: @openzeppelin/contracts/access/Ownable.sol
274 
275 
276 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
277 
278 pragma solidity ^0.8.0;
279 
280 
281 /**
282  * @dev Contract module which provides a basic access control mechanism, where
283  * there is an account (an owner) that can be granted exclusive access to
284  * specific functions.
285  *
286  * By default, the owner account will be the one that deploys the contract. This
287  * can later be changed with {transferOwnership}.
288  *
289  * This module is used through inheritance. It will make available the modifier
290  * `onlyOwner`, which can be applied to your functions to restrict their use to
291  * the owner.
292  */
293 abstract contract Ownable is Context {
294     address private _owner;
295 
296     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
297 
298     /**
299      * @dev Initializes the contract setting the deployer as the initial owner.
300      */
301     constructor() {
302         _transferOwnership(_msgSender());
303     }
304 
305     /**
306      * @dev Returns the address of the current owner.
307      */
308     function owner() public view virtual returns (address) {
309         return _owner;
310     }
311 
312     /**
313      * @dev Throws if called by any account other than the owner.
314      */
315     modifier onlyOwner() {
316         require(owner() == _msgSender(), "Ownable: caller is not the owner");
317         _;
318     }
319 
320     /**
321      * @dev Leaves the contract without owner. It will not be possible to call
322      * `onlyOwner` functions anymore. Can only be called by the current owner.
323      *
324      * NOTE: Renouncing ownership will leave the contract without an owner,
325      * thereby removing any functionality that is only available to the owner.
326      */
327     function renounceOwnership() public virtual onlyOwner {
328         _transferOwnership(address(0));
329     }
330 
331     /**
332      * @dev Transfers ownership of the contract to a new account (`newOwner`).
333      * Can only be called by the current owner.
334      */
335     function transferOwnership(address newOwner) public virtual onlyOwner {
336         require(newOwner != address(0), "Ownable: new owner is the zero address");
337         _transferOwnership(newOwner);
338     }
339 
340     /**
341      * @dev Transfers ownership of the contract to a new account (`newOwner`).
342      * Internal function without access restriction.
343      */
344     function _transferOwnership(address newOwner) internal virtual {
345         address oldOwner = _owner;
346         _owner = newOwner;
347         emit OwnershipTransferred(oldOwner, newOwner);
348     }
349 }
350 
351 // File: @openzeppelin/contracts/utils/Address.sol
352 
353 
354 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
355 
356 pragma solidity ^0.8.1;
357 
358 /**
359  * @dev Collection of functions related to the address type
360  */
361 library Address {
362     /**
363      * @dev Returns true if `account` is a contract.
364      *
365      * [IMPORTANT]
366      * ====
367      * It is unsafe to assume that an address for which this function returns
368      * false is an externally-owned account (EOA) and not a contract.
369      *
370      * Among others, `isContract` will return false for the following
371      * types of addresses:
372      *
373      *  - an externally-owned account
374      *  - a contract in construction
375      *  - an address where a contract will be created
376      *  - an address where a contract lived, but was destroyed
377      * ====
378      *
379      * [IMPORTANT]
380      * ====
381      * You shouldn't rely on `isContract` to protect against flash loan attacks!
382      *
383      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
384      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
385      * constructor.
386      * ====
387      */
388     function isContract(address account) internal view returns (bool) {
389         // This method relies on extcodesize/address.code.length, which returns 0
390         // for contracts in construction, since the code is only stored at the end
391         // of the constructor execution.
392 
393         return account.code.length > 0;
394     }
395 
396     /**
397      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
398      * `recipient`, forwarding all available gas and reverting on errors.
399      *
400      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
401      * of certain opcodes, possibly making contracts go over the 2300 gas limit
402      * imposed by `transfer`, making them unable to receive funds via
403      * `transfer`. {sendValue} removes this limitation.
404      *
405      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
406      *
407      * IMPORTANT: because control is transferred to `recipient`, care must be
408      * taken to not create reentrancy vulnerabilities. Consider using
409      * {ReentrancyGuard} or the
410      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
411      */
412     function sendValue(address payable recipient, uint256 amount) internal {
413         require(address(this).balance >= amount, "Address: insufficient balance");
414 
415         (bool success, ) = recipient.call{value: amount}("");
416         require(success, "Address: unable to send value, recipient may have reverted");
417     }
418 
419     /**
420      * @dev Performs a Solidity function call using a low level `call`. A
421      * plain `call` is an unsafe replacement for a function call: use this
422      * function instead.
423      *
424      * If `target` reverts with a revert reason, it is bubbled up by this
425      * function (like regular Solidity function calls).
426      *
427      * Returns the raw returned data. To convert to the expected return value,
428      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
429      *
430      * Requirements:
431      *
432      * - `target` must be a contract.
433      * - calling `target` with `data` must not revert.
434      *
435      * _Available since v3.1._
436      */
437     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
438         return functionCall(target, data, "Address: low-level call failed");
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
443      * `errorMessage` as a fallback revert reason when `target` reverts.
444      *
445      * _Available since v3.1._
446      */
447     function functionCall(
448         address target,
449         bytes memory data,
450         string memory errorMessage
451     ) internal returns (bytes memory) {
452         return functionCallWithValue(target, data, 0, errorMessage);
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
457      * but also transferring `value` wei to `target`.
458      *
459      * Requirements:
460      *
461      * - the calling contract must have an ETH balance of at least `value`.
462      * - the called Solidity function must be `payable`.
463      *
464      * _Available since v3.1._
465      */
466     function functionCallWithValue(
467         address target,
468         bytes memory data,
469         uint256 value
470     ) internal returns (bytes memory) {
471         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
472     }
473 
474     /**
475      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
476      * with `errorMessage` as a fallback revert reason when `target` reverts.
477      *
478      * _Available since v3.1._
479      */
480     function functionCallWithValue(
481         address target,
482         bytes memory data,
483         uint256 value,
484         string memory errorMessage
485     ) internal returns (bytes memory) {
486         require(address(this).balance >= value, "Address: insufficient balance for call");
487         require(isContract(target), "Address: call to non-contract");
488 
489         (bool success, bytes memory returndata) = target.call{value: value}(data);
490         return verifyCallResult(success, returndata, errorMessage);
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
495      * but performing a static call.
496      *
497      * _Available since v3.3._
498      */
499     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
500         return functionStaticCall(target, data, "Address: low-level static call failed");
501     }
502 
503     /**
504      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
505      * but performing a static call.
506      *
507      * _Available since v3.3._
508      */
509     function functionStaticCall(
510         address target,
511         bytes memory data,
512         string memory errorMessage
513     ) internal view returns (bytes memory) {
514         require(isContract(target), "Address: static call to non-contract");
515 
516         (bool success, bytes memory returndata) = target.staticcall(data);
517         return verifyCallResult(success, returndata, errorMessage);
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
522      * but performing a delegate call.
523      *
524      * _Available since v3.4._
525      */
526     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
527         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
528     }
529 
530     /**
531      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
532      * but performing a delegate call.
533      *
534      * _Available since v3.4._
535      */
536     function functionDelegateCall(
537         address target,
538         bytes memory data,
539         string memory errorMessage
540     ) internal returns (bytes memory) {
541         require(isContract(target), "Address: delegate call to non-contract");
542 
543         (bool success, bytes memory returndata) = target.delegatecall(data);
544         return verifyCallResult(success, returndata, errorMessage);
545     }
546 
547     /**
548      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
549      * revert reason using the provided one.
550      *
551      * _Available since v4.3._
552      */
553     function verifyCallResult(
554         bool success,
555         bytes memory returndata,
556         string memory errorMessage
557     ) internal pure returns (bytes memory) {
558         if (success) {
559             return returndata;
560         } else {
561             // Look for revert reason and bubble it up if present
562             if (returndata.length > 0) {
563                 // The easiest way to bubble the revert reason is using memory via assembly
564 
565                 assembly {
566                     let returndata_size := mload(returndata)
567                     revert(add(32, returndata), returndata_size)
568                 }
569             } else {
570                 revert(errorMessage);
571             }
572         }
573     }
574 }
575 
576 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
577 
578 
579 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
580 
581 pragma solidity ^0.8.0;
582 
583 
584 
585 /**
586  * @title SafeERC20
587  * @dev Wrappers around ERC20 operations that throw on failure (when the token
588  * contract returns false). Tokens that return no value (and instead revert or
589  * throw on failure) are also supported, non-reverting calls are assumed to be
590  * successful.
591  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
592  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
593  */
594 library SafeERC20 {
595     using Address for address;
596 
597     function safeTransfer(
598         IERC20 token,
599         address to,
600         uint256 value
601     ) internal {
602         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
603     }
604 
605     function safeTransferFrom(
606         IERC20 token,
607         address from,
608         address to,
609         uint256 value
610     ) internal {
611         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
612     }
613 
614     /**
615      * @dev Deprecated. This function has issues similar to the ones found in
616      * {IERC20-approve}, and its usage is discouraged.
617      *
618      * Whenever possible, use {safeIncreaseAllowance} and
619      * {safeDecreaseAllowance} instead.
620      */
621     function safeApprove(
622         IERC20 token,
623         address spender,
624         uint256 value
625     ) internal {
626         // safeApprove should only be called when setting an initial allowance,
627         // or when resetting it to zero. To increase and decrease it, use
628         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
629         require(
630             (value == 0) || (token.allowance(address(this), spender) == 0),
631             "SafeERC20: approve from non-zero to non-zero allowance"
632         );
633         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
634     }
635 
636     function safeIncreaseAllowance(
637         IERC20 token,
638         address spender,
639         uint256 value
640     ) internal {
641         uint256 newAllowance = token.allowance(address(this), spender) + value;
642         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
643     }
644 
645     function safeDecreaseAllowance(
646         IERC20 token,
647         address spender,
648         uint256 value
649     ) internal {
650         unchecked {
651             uint256 oldAllowance = token.allowance(address(this), spender);
652             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
653             uint256 newAllowance = oldAllowance - value;
654             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
655         }
656     }
657 
658     /**
659      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
660      * on the return value: the return value is optional (but if data is returned, it must not be false).
661      * @param token The token targeted by the call.
662      * @param data The call data (encoded using abi.encode or one of its variants).
663      */
664     function _callOptionalReturn(IERC20 token, bytes memory data) private {
665         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
666         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
667         // the target address contains contract code and also asserts for success in the low-level call.
668 
669         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
670         if (returndata.length > 0) {
671             // Return data is optional
672             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
673         }
674     }
675 }
676 
677 
678 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
679 
680 
681 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
682 
683 pragma solidity ^0.8.0;
684 
685 /**
686  * @title ERC721 token receiver interface
687  * @dev Interface for any contract that wants to support safeTransfers
688  * from ERC721 asset contracts.
689  */
690 interface IERC721Receiver {
691     /**
692      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
693      * by `operator` from `from`, this function is called.
694      *
695      * It must return its Solidity selector to confirm the token transfer.
696      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
697      *
698      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
699      */
700     function onERC721Received(
701         address operator,
702         address from,
703         uint256 tokenId,
704         bytes calldata data
705     ) external returns (bytes4);
706 }
707 
708 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
709 
710 
711 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
712 
713 pragma solidity ^0.8.0;
714 
715 /**
716  * @dev Interface of the ERC165 standard, as defined in the
717  * https://eips.ethereum.org/EIPS/eip-165[EIP].
718  *
719  * Implementers can declare support of contract interfaces, which can then be
720  * queried by others ({ERC165Checker}).
721  *
722  * For an implementation, see {ERC165}.
723  */
724 interface IERC165 {
725     /**
726      * @dev Returns true if this contract implements the interface defined by
727      * `interfaceId`. See the corresponding
728      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
729      * to learn more about how these ids are created.
730      *
731      * This function call must use less than 30 000 gas.
732      */
733     function supportsInterface(bytes4 interfaceId) external view returns (bool);
734 }
735 
736 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
737 
738 
739 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
740 
741 pragma solidity ^0.8.0;
742 
743 
744 /**
745  * @dev Implementation of the {IERC165} interface.
746  *
747  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
748  * for the additional interface id that will be supported. For example:
749  *
750  * ```solidity
751  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
752  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
753  * }
754  * ```
755  *
756  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
757  */
758 abstract contract ERC165 is IERC165 {
759     /**
760      * @dev See {IERC165-supportsInterface}.
761      */
762     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
763         return interfaceId == type(IERC165).interfaceId;
764     }
765 }
766 
767 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
768 
769 
770 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
771 // OpenZeppelin Contracts v4.4.0 (utils/cryptography/ECDSA.sol)
772 
773 pragma solidity ^0.8.0;
774 
775 
776 /**
777  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
778  *
779  * These functions can be used to verify that a message was signed by the holder
780  * of the private keys of a given address.
781  */
782 library ECDSA {
783     enum RecoverError {
784         NoError,
785         InvalidSignature,
786         InvalidSignatureLength,
787         InvalidSignatureS,
788         InvalidSignatureV
789     }
790 
791     function _throwError(RecoverError error) private pure {
792         if (error == RecoverError.NoError) {
793             return; // no error: do nothing
794         } else if (error == RecoverError.InvalidSignature) {
795             revert("ECDSA: invalid signature");
796         } else if (error == RecoverError.InvalidSignatureLength) {
797             revert("ECDSA: invalid signature length");
798         } else if (error == RecoverError.InvalidSignatureS) {
799             revert("ECDSA: invalid signature 's' value");
800         } else if (error == RecoverError.InvalidSignatureV) {
801             revert("ECDSA: invalid signature 'v' value");
802         }
803     }
804 
805     /**
806      * @dev Returns the address that signed a hashed message (`hash`) with
807      * `signature` or error string. This address can then be used for verification purposes.
808      *
809      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
810      * this function rejects them by requiring the `s` value to be in the lower
811      * half order, and the `v` value to be either 27 or 28.
812      *
813      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
814      * verification to be secure: it is possible to craft signatures that
815      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
816      * this is by receiving a hash of the original message (which may otherwise
817      * be too long), and then calling {toEthSignedMessageHash} on it.
818      *
819      * Documentation for signature generation:
820      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
821      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
822      *
823      * _Available since v4.3._
824      */
825     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
826         // Check the signature length
827         // - case 65: r,s,v signature (standard)
828         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
829         if (signature.length == 65) {
830             bytes32 r;
831             bytes32 s;
832             uint8 v;
833             // ecrecover takes the signature parameters, and the only way to get them
834             // currently is to use assembly.
835             assembly {
836                 r := mload(add(signature, 0x20))
837                 s := mload(add(signature, 0x40))
838                 v := byte(0, mload(add(signature, 0x60)))
839             }
840             return tryRecover(hash, v, r, s);
841         } else if (signature.length == 64) {
842             bytes32 r;
843             bytes32 vs;
844             // ecrecover takes the signature parameters, and the only way to get them
845             // currently is to use assembly.
846             assembly {
847                 r := mload(add(signature, 0x20))
848                 vs := mload(add(signature, 0x40))
849             }
850             return tryRecover(hash, r, vs);
851         } else {
852             return (address(0), RecoverError.InvalidSignatureLength);
853         }
854     }
855 
856     /**
857      * @dev Returns the address that signed a hashed message (`hash`) with
858      * `signature`. This address can then be used for verification purposes.
859      *
860      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
861      * this function rejects them by requiring the `s` value to be in the lower
862      * half order, and the `v` value to be either 27 or 28.
863      *
864      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
865      * verification to be secure: it is possible to craft signatures that
866      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
867      * this is by receiving a hash of the original message (which may otherwise
868      * be too long), and then calling {toEthSignedMessageHash} on it.
869      */
870     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
871         (address recovered, RecoverError error) = tryRecover(hash, signature);
872         _throwError(error);
873         return recovered;
874     }
875 
876     /**
877      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
878      *
879      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
880      *
881      * _Available since v4.3._
882      */
883     function tryRecover(
884         bytes32 hash,
885         bytes32 r,
886         bytes32 vs
887     ) internal pure returns (address, RecoverError) {
888         bytes32 s;
889         uint8 v;
890         assembly {
891             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
892             v := add(shr(255, vs), 27)
893         }
894         return tryRecover(hash, v, r, s);
895     }
896 
897     /**
898      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
899      *
900      * _Available since v4.2._
901      */
902     function recover(
903         bytes32 hash,
904         bytes32 r,
905         bytes32 vs
906     ) internal pure returns (address) {
907         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
908         _throwError(error);
909         return recovered;
910     }
911 
912     /**
913      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
914      * `r` and `s` signature fields separately.
915      *
916      * _Available since v4.3._
917      */
918     function tryRecover(
919         bytes32 hash,
920         uint8 v,
921         bytes32 r,
922         bytes32 s
923     ) internal pure returns (address, RecoverError) {
924         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
925         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
926         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
927         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
928         //
929         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
930         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
931         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
932         // these malleable signatures as well.
933         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
934             return (address(0), RecoverError.InvalidSignatureS);
935         }
936         if (v != 27 && v != 28) {
937             return (address(0), RecoverError.InvalidSignatureV);
938         }
939 
940         // If the signature is valid (and not malleable), return the signer address
941         address signer = ecrecover(hash, v, r, s);
942         if (signer == address(0)) {
943             return (address(0), RecoverError.InvalidSignature);
944         }
945 
946         return (signer, RecoverError.NoError);
947     }
948 
949     /**
950      * @dev Overload of {ECDSA-recover} that receives the `v`,
951      * `r` and `s` signature fields separately.
952      */
953     function recover(
954         bytes32 hash,
955         uint8 v,
956         bytes32 r,
957         bytes32 s
958     ) internal pure returns (address) {
959         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
960         _throwError(error);
961         return recovered;
962     }
963 
964     /**
965      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
966      * produces hash corresponding to the one signed with the
967      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
968      * JSON-RPC method as part of EIP-191.
969      *
970      * See {recover}.
971      */
972     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
973         // 32 is the length in bytes of hash,
974         // enforced by the type signature above
975         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
976     }
977 
978     /**
979      * @dev Returns an Ethereum Signed Message, created from `s`. This
980      * produces hash corresponding to the one signed with the
981      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
982      * JSON-RPC method as part of EIP-191.
983      *
984      * See {recover}.
985      */
986     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
987         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
988     }
989 
990     /**
991      * @dev Returns an Ethereum Signed Typed Data, created from a
992      * `domainSeparator` and a `structHash`. This produces hash corresponding
993      * to the one signed with the
994      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
995      * JSON-RPC method as part of EIP-712.
996      *
997      * See {recover}.
998      */
999     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1000         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1001     }
1002 }
1003 
1004 pragma solidity ^0.8.0;
1005 
1006 
1007 /**
1008  * @dev Required interface of an ERC721 compliant contract.
1009  */
1010 interface IERC721 is IERC165 {
1011     /**
1012      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1013      */
1014     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1015 
1016     /**
1017      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1018      */
1019     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1020 
1021     /**
1022      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1023      */
1024     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1025 
1026     /**
1027      * @dev Returns the number of tokens in ``owner``'s account.
1028      */
1029     function balanceOf(address owner) external view returns (uint256 balance);
1030 
1031     /**
1032      * @dev Returns the owner of the `tokenId` token.
1033      *
1034      * Requirements:
1035      *
1036      * - `tokenId` must exist.
1037      */
1038     function ownerOf(uint256 tokenId) external view returns (address owner);
1039 
1040     /**
1041      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1042      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1043      *
1044      * Requirements:
1045      *
1046      * - `from` cannot be the zero address.
1047      * - `to` cannot be the zero address.
1048      * - `tokenId` token must exist and be owned by `from`.
1049      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1050      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1051      *
1052      * Emits a {Transfer} event.
1053      */
1054     function safeTransferFrom(
1055         address from,
1056         address to,
1057         uint256 tokenId
1058     ) external;
1059 
1060     /**
1061      * @dev Transfers `tokenId` token from `from` to `to`.
1062      *
1063      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1064      *
1065      * Requirements:
1066      *
1067      * - `from` cannot be the zero address.
1068      * - `to` cannot be the zero address.
1069      * - `tokenId` token must be owned by `from`.
1070      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1071      *
1072      * Emits a {Transfer} event.
1073      */
1074     function transferFrom(
1075         address from,
1076         address to,
1077         uint256 tokenId
1078     ) external;
1079 
1080     /**
1081      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1082      * The approval is cleared when the token is transferred.
1083      *
1084      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1085      *
1086      * Requirements:
1087      *
1088      * - The caller must own the token or be an approved operator.
1089      * - `tokenId` must exist.
1090      *
1091      * Emits an {Approval} event.
1092      */
1093     function approve(address to, uint256 tokenId) external;
1094 
1095     /**
1096      * @dev Returns the account approved for `tokenId` token.
1097      *
1098      * Requirements:
1099      *
1100      * - `tokenId` must exist.
1101      */
1102     function getApproved(uint256 tokenId) external view returns (address operator);
1103 
1104     /**
1105      * @dev Approve or remove `operator` as an operator for the caller.
1106      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1107      *
1108      * Requirements:
1109      *
1110      * - The `operator` cannot be the caller.
1111      *
1112      * Emits an {ApprovalForAll} event.
1113      */
1114     function setApprovalForAll(address operator, bool _approved) external;
1115 
1116     /**
1117      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1118      *
1119      * See {setApprovalForAll}
1120      */
1121     function isApprovedForAll(address owner, address operator) external view returns (bool);
1122 
1123     /**
1124      * @dev Safely transfers `tokenId` token from `from` to `to`.
1125      *
1126      * Requirements:
1127      *
1128      * - `from` cannot be the zero address.
1129      * - `to` cannot be the zero address.
1130      * - `tokenId` token must exist and be owned by `from`.
1131      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1132      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1133      *
1134      * Emits a {Transfer} event.
1135      */
1136     function safeTransferFrom(
1137         address from,
1138         address to,
1139         uint256 tokenId,
1140         bytes calldata data
1141     ) external;
1142 }
1143 // ERC721A Contracts v4.0.0
1144 // Creator: Chiru Labs
1145 
1146 pragma solidity ^0.8.4;
1147 
1148 /**
1149  * @dev Interface of an ERC721A compliant contract.
1150  */
1151 interface IERC721A {
1152     /**
1153      * The caller must own the token or be an approved operator.
1154      */
1155     error ApprovalCallerNotOwnerNorApproved();
1156 
1157     /**
1158      * The token does not exist.
1159      */
1160     error ApprovalQueryForNonexistentToken();
1161 
1162     /**
1163      * The caller cannot approve to their own address.
1164      */
1165     error ApproveToCaller();
1166 
1167     /**
1168      * The caller cannot approve to the current owner.
1169      */
1170     error ApprovalToCurrentOwner();
1171 
1172     /**
1173      * Cannot query the balance for the zero address.
1174      */
1175     error BalanceQueryForZeroAddress();
1176 
1177     /**
1178      * Cannot mint to the zero address.
1179      */
1180     error MintToZeroAddress();
1181 
1182     /**
1183      * The quantity of tokens minted must be more than zero.
1184      */
1185     error MintZeroQuantity();
1186 
1187     /**
1188      * The token does not exist.
1189      */
1190     error OwnerQueryForNonexistentToken();
1191 
1192     /**
1193      * The caller must own the token or be an approved operator.
1194      */
1195     error TransferCallerNotOwnerNorApproved();
1196 
1197     /**
1198      * The token must be owned by `from`.
1199      */
1200     error TransferFromIncorrectOwner();
1201 
1202     /**
1203      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
1204      */
1205     error TransferToNonERC721ReceiverImplementer();
1206 
1207     /**
1208      * Cannot transfer to the zero address.
1209      */
1210     error TransferToZeroAddress();
1211 
1212     /**
1213      * The token does not exist.
1214      */
1215     error URIQueryForNonexistentToken();
1216 
1217     struct TokenOwnership {
1218         // The address of the owner.
1219         address addr;
1220         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1221         uint64 startTimestamp;
1222         // Whether the token has been burned.
1223         bool burned;
1224     }
1225 
1226     /**
1227      * @dev Returns the total amount of tokens stored by the contract.
1228      *
1229      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
1230      */
1231     function totalSupply() external view returns (uint256);
1232 
1233     // ==============================
1234     //            IERC165
1235     // ==============================
1236 
1237     /**
1238      * @dev Returns true if this contract implements the interface defined by
1239      * `interfaceId`. See the corresponding
1240      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1241      * to learn more about how these ids are created.
1242      *
1243      * This function call must use less than 30 000 gas.
1244      */
1245     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1246 
1247     // ==============================
1248     //            IERC721
1249     // ==============================
1250 
1251     /**
1252      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1253      */
1254     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1255 
1256     /**
1257      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1258      */
1259     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1260 
1261     /**
1262      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1263      */
1264     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1265 
1266     /**
1267      * @dev Returns the number of tokens in ``owner``'s account.
1268      */
1269     function balanceOf(address owner) external view returns (uint256 balance);
1270 
1271     /**
1272      * @dev Returns the owner of the `tokenId` token.
1273      *
1274      * Requirements:
1275      *
1276      * - `tokenId` must exist.
1277      */
1278     function ownerOf(uint256 tokenId) external view returns (address owner);
1279 
1280     /**
1281      * @dev Safely transfers `tokenId` token from `from` to `to`.
1282      *
1283      * Requirements:
1284      *
1285      * - `from` cannot be the zero address.
1286      * - `to` cannot be the zero address.
1287      * - `tokenId` token must exist and be owned by `from`.
1288      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1289      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1290      *
1291      * Emits a {Transfer} event.
1292      */
1293     function safeTransferFrom(
1294         address from,
1295         address to,
1296         uint256 tokenId,
1297         bytes calldata data
1298     ) external;
1299 
1300     /**
1301      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1302      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1303      *
1304      * Requirements:
1305      *
1306      * - `from` cannot be the zero address.
1307      * - `to` cannot be the zero address.
1308      * - `tokenId` token must exist and be owned by `from`.
1309      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1310      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1311      *
1312      * Emits a {Transfer} event.
1313      */
1314     function safeTransferFrom(
1315         address from,
1316         address to,
1317         uint256 tokenId
1318     ) external;
1319 
1320     /**
1321      * @dev Transfers `tokenId` token from `from` to `to`.
1322      *
1323      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1324      *
1325      * Requirements:
1326      *
1327      * - `from` cannot be the zero address.
1328      * - `to` cannot be the zero address.
1329      * - `tokenId` token must be owned by `from`.
1330      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1331      *
1332      * Emits a {Transfer} event.
1333      */
1334     function transferFrom(
1335         address from,
1336         address to,
1337         uint256 tokenId
1338     ) external;
1339 
1340     /**
1341      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1342      * The approval is cleared when the token is transferred.
1343      *
1344      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1345      *
1346      * Requirements:
1347      *
1348      * - The caller must own the token or be an approved operator.
1349      * - `tokenId` must exist.
1350      *
1351      * Emits an {Approval} event.
1352      */
1353     function approve(address to, uint256 tokenId) external;
1354 
1355     /**
1356      * @dev Approve or remove `operator` as an operator for the caller.
1357      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1358      *
1359      * Requirements:
1360      *
1361      * - The `operator` cannot be the caller.
1362      *
1363      * Emits an {ApprovalForAll} event.
1364      */
1365     function setApprovalForAll(address operator, bool _approved) external;
1366 
1367     /**
1368      * @dev Returns the account approved for `tokenId` token.
1369      *
1370      * Requirements:
1371      *
1372      * - `tokenId` must exist.
1373      */
1374     function getApproved(uint256 tokenId) external view returns (address operator);
1375 
1376     /**
1377      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1378      *
1379      * See {setApprovalForAll}
1380      */
1381     function isApprovedForAll(address owner, address operator) external view returns (bool);
1382 
1383     // ==============================
1384     //        IERC721Metadata
1385     // ==============================
1386 
1387     /**
1388      * @dev Returns the token collection name.
1389      */
1390     function name() external view returns (string memory);
1391 
1392     /**
1393      * @dev Returns the token collection symbol.
1394      */
1395     function symbol() external view returns (string memory);
1396 
1397     /**
1398      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1399      */
1400     function tokenURI(uint256 tokenId) external view returns (string memory);
1401 }
1402 
1403 // ERC721A Contracts v4.0.0
1404 // Creator: Chiru Labs
1405 
1406 pragma solidity ^0.8.4;
1407 
1408 
1409 /**
1410  * @dev ERC721 token receiver interface.
1411  */
1412 interface ERC721A__IERC721Receiver {
1413     function onERC721Received(
1414         address operator,
1415         address from,
1416         uint256 tokenId,
1417         bytes calldata data
1418     ) external returns (bytes4);
1419 }
1420 
1421 /**
1422  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1423  * the Metadata extension. Built to optimize for lower gas during batch mints.
1424  *
1425  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1426  *
1427  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1428  *
1429  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1430  */
1431 contract ERC721A is IERC721A {
1432     // Mask of an entry in packed address data.
1433     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1434 
1435     // The bit position of `numberMinted` in packed address data.
1436     uint256 private constant BITPOS_NUMBER_MINTED = 64;
1437 
1438     // The bit position of `numberBurned` in packed address data.
1439     uint256 private constant BITPOS_NUMBER_BURNED = 128;
1440 
1441     // The bit position of `aux` in packed address data.
1442     uint256 private constant BITPOS_AUX = 192;
1443 
1444     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1445     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1446 
1447     // The bit position of `startTimestamp` in packed ownership.
1448     uint256 private constant BITPOS_START_TIMESTAMP = 160;
1449 
1450     // The bit mask of the `burned` bit in packed ownership.
1451     uint256 private constant BITMASK_BURNED = 1 << 224;
1452     
1453     // The bit position of the `nextInitialized` bit in packed ownership.
1454     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
1455 
1456     // The bit mask of the `nextInitialized` bit in packed ownership.
1457     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
1458 
1459     // The tokenId of the next token to be minted.
1460     uint256 private _currentIndex;
1461 
1462     // The number of tokens burned.
1463     uint256 private _burnCounter;
1464 
1465     // Token name
1466     string private _name;
1467 
1468     // Token symbol
1469     string private _symbol;
1470 
1471     // Mapping from token ID to ownership details
1472     // An empty struct value does not necessarily mean the token is unowned.
1473     // See `_packedOwnershipOf` implementation for details.
1474     //
1475     // Bits Layout:
1476     // - [0..159]   `addr`
1477     // - [160..223] `startTimestamp`
1478     // - [224]      `burned`
1479     // - [225]      `nextInitialized`
1480     mapping(uint256 => uint256) private _packedOwnerships;
1481 
1482     // Mapping owner address to address data.
1483     //
1484     // Bits Layout:
1485     // - [0..63]    `balance`
1486     // - [64..127]  `numberMinted`
1487     // - [128..191] `numberBurned`
1488     // - [192..255] `aux`
1489     mapping(address => uint256) private _packedAddressData;
1490 
1491     // Mapping from token ID to approved address.
1492     mapping(uint256 => address) private _tokenApprovals;
1493 
1494     // Mapping from owner to operator approvals
1495     mapping(address => mapping(address => bool)) private _operatorApprovals;
1496 
1497     constructor(string memory name_, string memory symbol_) {
1498         _name = name_;
1499         _symbol = symbol_;
1500         _currentIndex = _startTokenId();
1501     }
1502 
1503     /**
1504      * @dev Returns the starting token ID. 
1505      * To change the starting token ID, please override this function.
1506      */
1507     function _startTokenId() internal view virtual returns (uint256) {
1508         return 0;
1509     }
1510 
1511     /**
1512      * @dev Returns the next token ID to be minted.
1513      */
1514     function _nextTokenId() internal view returns (uint256) {
1515         return _currentIndex;
1516     }
1517 
1518     /**
1519      * @dev Returns the total number of tokens in existence.
1520      * Burned tokens will reduce the count. 
1521      * To get the total number of tokens minted, please see `_totalMinted`.
1522      */
1523     function totalSupply() public virtual view override returns (uint256) {
1524         // Counter underflow is impossible as _burnCounter cannot be incremented
1525         // more than `_currentIndex - _startTokenId()` times.
1526         unchecked {
1527             return _currentIndex - _burnCounter - _startTokenId();
1528         }
1529     }
1530 
1531     /**
1532      * @dev Returns the total amount of tokens minted in the contract.
1533      */
1534     function _totalMinted() internal view returns (uint256) {
1535         // Counter underflow is impossible as _currentIndex does not decrement,
1536         // and it is initialized to `_startTokenId()`
1537         unchecked {
1538             return _currentIndex - _startTokenId();
1539         }
1540     }
1541 
1542     /**
1543      * @dev Returns the total number of tokens burned.
1544      */
1545     function _totalBurned() internal view returns (uint256) {
1546         return _burnCounter;
1547     }
1548 
1549     /**
1550      * @dev See {IERC165-supportsInterface}.
1551      */
1552     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1553         // The interface IDs are constants representing the first 4 bytes of the XOR of
1554         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
1555         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
1556         return
1557             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1558             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1559             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1560     }
1561 
1562     /**
1563      * @dev See {IERC721-balanceOf}.
1564      */
1565     function balanceOf(address owner) public view override returns (uint256) {
1566         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1567         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
1568     }
1569 
1570     /**
1571      * Returns the number of tokens minted by `owner`.
1572      */
1573     function _numberMinted(address owner) internal view returns (uint256) {
1574         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
1575     }
1576 
1577     /**
1578      * Returns the number of tokens burned by or on behalf of `owner`.
1579      */
1580     function _numberBurned(address owner) internal view returns (uint256) {
1581         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
1582     }
1583 
1584     /**
1585      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1586      */
1587     function _getAux(address owner) internal view returns (uint64) {
1588         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
1589     }
1590 
1591     /**
1592      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1593      * If there are multiple variables, please pack them into a uint64.
1594      */
1595     function _setAux(address owner, uint64 aux) internal {
1596         uint256 packed = _packedAddressData[owner];
1597         uint256 auxCasted;
1598         assembly { // Cast aux without masking.
1599             auxCasted := aux
1600         }
1601         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
1602         _packedAddressData[owner] = packed;
1603     }
1604 
1605     /**
1606      * Returns the packed ownership data of `tokenId`.
1607      */
1608     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1609         uint256 curr = tokenId;
1610 
1611         unchecked {
1612             if (_startTokenId() <= curr)
1613                 if (curr < _currentIndex) {
1614                     uint256 packed = _packedOwnerships[curr];
1615                     // If not burned.
1616                     if (packed & BITMASK_BURNED == 0) {
1617                         // Invariant:
1618                         // There will always be an ownership that has an address and is not burned
1619                         // before an ownership that does not have an address and is not burned.
1620                         // Hence, curr will not underflow.
1621                         //
1622                         // We can directly compare the packed value.
1623                         // If the address is zero, packed is zero.
1624                         while (packed == 0) {
1625                             packed = _packedOwnerships[--curr];
1626                         }
1627                         return packed;
1628                     }
1629                 }
1630         }
1631         revert OwnerQueryForNonexistentToken();
1632     }
1633 
1634     /**
1635      * Returns the unpacked `TokenOwnership` struct from `packed`.
1636      */
1637     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1638         ownership.addr = address(uint160(packed));
1639         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1640         ownership.burned = packed & BITMASK_BURNED != 0;
1641     }
1642 
1643     /**
1644      * Returns the unpacked `TokenOwnership` struct at `index`.
1645      */
1646     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1647         return _unpackedOwnership(_packedOwnerships[index]);
1648     }
1649 
1650     /**
1651      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1652      */
1653     function _initializeOwnershipAt(uint256 index) internal {
1654         if (_packedOwnerships[index] == 0) {
1655             _packedOwnerships[index] = _packedOwnershipOf(index);
1656         }
1657     }
1658 
1659     /**
1660      * Gas spent here starts off proportional to the maximum mint batch size.
1661      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1662      */
1663     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1664         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1665     }
1666 
1667     /**
1668      * @dev See {IERC721-ownerOf}.
1669      */
1670     function ownerOf(uint256 tokenId) public view override returns (address) {
1671         return address(uint160(_packedOwnershipOf(tokenId)));
1672     }
1673 
1674     /**
1675      * @dev See {IERC721Metadata-name}.
1676      */
1677     function name() public view virtual override returns (string memory) {
1678         return _name;
1679     }
1680 
1681     /**
1682      * @dev See {IERC721Metadata-symbol}.
1683      */
1684     function symbol() public view virtual override returns (string memory) {
1685         return _symbol;
1686     }
1687 
1688     /**
1689      * @dev See {IERC721Metadata-tokenURI}.
1690      */
1691     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1692         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1693 
1694         string memory baseURI = _baseURI();
1695         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1696     }
1697 
1698     /**
1699      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1700      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1701      * by default, can be overriden in child contracts.
1702      */
1703     function _baseURI() internal view virtual returns (string memory) {
1704         return '';
1705     }
1706 
1707     /**
1708      * @dev Casts the address to uint256 without masking.
1709      */
1710     function _addressToUint256(address value) private pure returns (uint256 result) {
1711         assembly {
1712             result := value
1713         }
1714     }
1715 
1716     /**
1717      * @dev Casts the boolean to uint256 without branching.
1718      */
1719     function _boolToUint256(bool value) private pure returns (uint256 result) {
1720         assembly {
1721             result := value
1722         }
1723     }
1724 
1725     /**
1726      * @dev See {IERC721-approve}.
1727      */
1728     function approve(address to, uint256 tokenId) public override {
1729         address owner = address(uint160(_packedOwnershipOf(tokenId)));
1730         if (to == owner) revert ApprovalToCurrentOwner();
1731 
1732         if (_msgSenderERC721A() != owner)
1733             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1734                 revert ApprovalCallerNotOwnerNorApproved();
1735             }
1736 
1737         _tokenApprovals[tokenId] = to;
1738         emit Approval(owner, to, tokenId);
1739     }
1740 
1741     /**
1742      * @dev See {IERC721-getApproved}.
1743      */
1744     function getApproved(uint256 tokenId) public view override returns (address) {
1745         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1746 
1747         return _tokenApprovals[tokenId];
1748     }
1749 
1750     /**
1751      * @dev See {IERC721-setApprovalForAll}.
1752      */
1753     function setApprovalForAll(address operator, bool approved) public virtual override {
1754         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1755 
1756         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1757         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1758     }
1759 
1760     /**
1761      * @dev See {IERC721-isApprovedForAll}.
1762      */
1763     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1764         return _operatorApprovals[owner][operator];
1765     }
1766 
1767     /**
1768      * @dev See {IERC721-transferFrom}.
1769      */
1770     function transferFrom(
1771         address from,
1772         address to,
1773         uint256 tokenId
1774     ) public virtual override {
1775         _transfer(from, to, tokenId);
1776     }
1777 
1778     /**
1779      * @dev See {IERC721-safeTransferFrom}.
1780      */
1781     function safeTransferFrom(
1782         address from,
1783         address to,
1784         uint256 tokenId
1785     ) public virtual override {
1786         safeTransferFrom(from, to, tokenId, '');
1787     }
1788 
1789     /**
1790      * @dev See {IERC721-safeTransferFrom}.
1791      */
1792     function safeTransferFrom(
1793         address from,
1794         address to,
1795         uint256 tokenId,
1796         bytes memory _data
1797     ) public virtual override {
1798         _transfer(from, to, tokenId);
1799         if (to.code.length != 0)
1800             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1801                 revert TransferToNonERC721ReceiverImplementer();
1802             }
1803     }
1804 
1805     /**
1806      * @dev Returns whether `tokenId` exists.
1807      *
1808      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1809      *
1810      * Tokens start existing when they are minted (`_mint`),
1811      */
1812     function _exists(uint256 tokenId) internal view returns (bool) {
1813         return
1814             _startTokenId() <= tokenId &&
1815             tokenId < _currentIndex && // If within bounds,
1816             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1817     }
1818 
1819     /**
1820      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1821      */
1822     function _safeMint(address to, uint256 quantity) internal {
1823         _safeMint(to, quantity, '');
1824     }
1825 
1826     /**
1827      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1828      *
1829      * Requirements:
1830      *
1831      * - If `to` refers to a smart contract, it must implement
1832      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1833      * - `quantity` must be greater than 0.
1834      *
1835      * Emits a {Transfer} event.
1836      */
1837     function _safeMint(
1838         address to,
1839         uint256 quantity,
1840         bytes memory _data
1841     ) internal {
1842         uint256 startTokenId = _currentIndex;
1843         if (to == address(0)) revert MintToZeroAddress();
1844         if (quantity == 0) revert MintZeroQuantity();
1845 
1846         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1847 
1848         // Overflows are incredibly unrealistic.
1849         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1850         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1851         unchecked {
1852             // Updates:
1853             // - `balance += quantity`.
1854             // - `numberMinted += quantity`.
1855             //
1856             // We can directly add to the balance and number minted.
1857             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1858 
1859             // Updates:
1860             // - `address` to the owner.
1861             // - `startTimestamp` to the timestamp of minting.
1862             // - `burned` to `false`.
1863             // - `nextInitialized` to `quantity == 1`.
1864             _packedOwnerships[startTokenId] =
1865                 _addressToUint256(to) |
1866                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1867                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1868 
1869             uint256 updatedIndex = startTokenId;
1870             uint256 end = updatedIndex + quantity;
1871 
1872             if (to.code.length != 0) {
1873                 do {
1874                     emit Transfer(address(0), to, updatedIndex);
1875                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1876                         revert TransferToNonERC721ReceiverImplementer();
1877                     }
1878                 } while (updatedIndex < end);
1879                 // Reentrancy protection
1880                 if (_currentIndex != startTokenId) revert();
1881             } else {
1882                 do {
1883                     emit Transfer(address(0), to, updatedIndex++);
1884                 } while (updatedIndex < end);
1885             }
1886             _currentIndex = updatedIndex;
1887         }
1888         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1889     }
1890 
1891     /**
1892      * @dev Mints `quantity` tokens and transfers them to `to`.
1893      *
1894      * Requirements:
1895      *
1896      * - `to` cannot be the zero address.
1897      * - `quantity` must be greater than 0.
1898      *
1899      * Emits a {Transfer} event.
1900      */
1901     function _mint(address to, uint256 quantity) internal {
1902         uint256 startTokenId = _currentIndex;
1903         if (to == address(0)) revert MintToZeroAddress();
1904         if (quantity == 0) revert MintZeroQuantity();
1905 
1906         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1907 
1908         // Overflows are incredibly unrealistic.
1909         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1910         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1911         unchecked {
1912             // Updates:
1913             // - `balance += quantity`.
1914             // - `numberMinted += quantity`.
1915             //
1916             // We can directly add to the balance and number minted.
1917             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1918 
1919             // Updates:
1920             // - `address` to the owner.
1921             // - `startTimestamp` to the timestamp of minting.
1922             // - `burned` to `false`.
1923             // - `nextInitialized` to `quantity == 1`.
1924             _packedOwnerships[startTokenId] =
1925                 _addressToUint256(to) |
1926                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1927                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1928 
1929             uint256 updatedIndex = startTokenId;
1930             uint256 end = updatedIndex + quantity;
1931 
1932             do {
1933                 emit Transfer(address(0), to, updatedIndex++);
1934             } while (updatedIndex < end);
1935 
1936             _currentIndex = updatedIndex;
1937         }
1938         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1939     }
1940 
1941     /**
1942      * @dev Transfers `tokenId` from `from` to `to`.
1943      *
1944      * Requirements:
1945      *
1946      * - `to` cannot be the zero address.
1947      * - `tokenId` token must be owned by `from`.
1948      *
1949      * Emits a {Transfer} event.
1950      */
1951     function _transfer(
1952           address from,
1953           address to,
1954           uint256 tokenId
1955   ) internal {
1956         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1957 
1958         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1959 
1960         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1961             isApprovedForAll(from, _msgSenderERC721A()) ||
1962             getApproved(tokenId) == _msgSenderERC721A());
1963 
1964         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1965         if (to == address(0)) revert TransferToZeroAddress();
1966 
1967         _beforeTokenTransfers(from, to, tokenId, 1);
1968 
1969         // Clear approvals from the previous owner.
1970         delete _tokenApprovals[tokenId];
1971 
1972         // Underflow of the sender's balance is impossible because we check for
1973         // ownership above and the recipient's balance can't realistically overflow.
1974         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1975         unchecked {
1976             // We can directly increment and decrement the balances.
1977             --_packedAddressData[from]; // Updates: `balance -= 1`.
1978             ++_packedAddressData[to]; // Updates: `balance += 1`.
1979 
1980             // Updates:
1981             // - `address` to the next owner.
1982             // - `startTimestamp` to the timestamp of transfering.
1983             // - `burned` to `false`.
1984             // - `nextInitialized` to `true`.
1985             _packedOwnerships[tokenId] =
1986                 _addressToUint256(to) |
1987                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1988                 BITMASK_NEXT_INITIALIZED;
1989 
1990             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1991             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1992                 uint256 nextTokenId = tokenId + 1;
1993                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1994                 if (_packedOwnerships[nextTokenId] == 0) {
1995                     // If the next slot is within bounds.
1996                     if (nextTokenId != _currentIndex) {
1997                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1998                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1999                     }
2000                 }
2001             }
2002         }
2003 
2004         emit Transfer(from, to, tokenId);
2005         _afterTokenTransfers(from, to, tokenId, 1);
2006     }
2007 
2008     /**
2009      * @dev Equivalent to `_burn(tokenId, false)`.
2010      */
2011     function _burn(uint256 tokenId) internal virtual {
2012         _burn(tokenId, false);
2013     }
2014 
2015     /**
2016      * @dev Destroys `tokenId`.
2017      * The approval is cleared when the token is burned.
2018      *
2019      * Requirements:
2020      *
2021      * - `tokenId` must exist.
2022      *
2023      * Emits a {Transfer} event.
2024      */
2025     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2026         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2027 
2028         address from = address(uint160(prevOwnershipPacked));
2029 
2030         if (approvalCheck) {
2031             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
2032                 isApprovedForAll(from, _msgSenderERC721A()) ||
2033                 getApproved(tokenId) == _msgSenderERC721A());
2034 
2035             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2036         }
2037 
2038         _beforeTokenTransfers(from, address(0), tokenId, 1);
2039 
2040         // Clear approvals from the previous owner.
2041         delete _tokenApprovals[tokenId];
2042 
2043         // Underflow of the sender's balance is impossible because we check for
2044         // ownership above and the recipient's balance can't realistically overflow.
2045         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2046         unchecked {
2047             // Updates:
2048             // - `balance -= 1`.
2049             // - `numberBurned += 1`.
2050             //
2051             // We can directly decrement the balance, and increment the number burned.
2052             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
2053             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
2054 
2055             // Updates:
2056             // - `address` to the last owner.
2057             // - `startTimestamp` to the timestamp of burning.
2058             // - `burned` to `true`.
2059             // - `nextInitialized` to `true`.
2060             _packedOwnerships[tokenId] =
2061                 _addressToUint256(from) |
2062                 (block.timestamp << BITPOS_START_TIMESTAMP) |
2063                 BITMASK_BURNED | 
2064                 BITMASK_NEXT_INITIALIZED;
2065 
2066             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2067             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
2068                 uint256 nextTokenId = tokenId + 1;
2069                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2070                 if (_packedOwnerships[nextTokenId] == 0) {
2071                     // If the next slot is within bounds.
2072                     if (nextTokenId != _currentIndex) {
2073                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2074                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2075                     }
2076                 }
2077             }
2078         }
2079 
2080         emit Transfer(from, address(0), tokenId);
2081         _afterTokenTransfers(from, address(0), tokenId, 1);
2082 
2083         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2084         unchecked {
2085             _burnCounter++;
2086         }
2087     }
2088 
2089     /**
2090      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2091      *
2092      * @param from address representing the previous owner of the given token ID
2093      * @param to target address that will receive the tokens
2094      * @param tokenId uint256 ID of the token to be transferred
2095      * @param _data bytes optional data to send along with the call
2096      * @return bool whether the call correctly returned the expected magic value
2097      */
2098     function _checkContractOnERC721Received(
2099         address from,
2100         address to,
2101         uint256 tokenId,
2102         bytes memory _data
2103     ) private returns (bool) {
2104         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2105             bytes4 retval
2106         ) {
2107             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2108         } catch (bytes memory reason) {
2109             if (reason.length == 0) {
2110                 revert TransferToNonERC721ReceiverImplementer();
2111             } else {
2112                 assembly {
2113                     revert(add(32, reason), mload(reason))
2114                 }
2115             }
2116         }
2117     }
2118 
2119     /**
2120      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2121      * And also called before burning one token.
2122      *
2123      * startTokenId - the first token id to be transferred
2124      * quantity - the amount to be transferred
2125      *
2126      * Calling conditions:
2127      *
2128      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2129      * transferred to `to`.
2130      * - When `from` is zero, `tokenId` will be minted for `to`.
2131      * - When `to` is zero, `tokenId` will be burned by `from`.
2132      * - `from` and `to` are never both zero.
2133      */
2134     function _beforeTokenTransfers(
2135         address from,
2136         address to,
2137         uint256 startTokenId,
2138         uint256 quantity
2139     ) internal virtual {}
2140 
2141     /**
2142      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2143      * minting.
2144      * And also called after one token has been burned.
2145      *
2146      * startTokenId - the first token id to be transferred
2147      * quantity - the amount to be transferred
2148      *
2149      * Calling conditions:
2150      *
2151      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2152      * transferred to `to`.
2153      * - When `from` is zero, `tokenId` has been minted for `to`.
2154      * - When `to` is zero, `tokenId` has been burned by `from`.
2155      * - `from` and `to` are never both zero.
2156      */
2157     function _afterTokenTransfers(
2158         address from,
2159         address to,
2160         uint256 startTokenId,
2161         uint256 quantity
2162     ) internal virtual {}
2163 
2164     /**
2165      * @dev Returns the message sender (defaults to `msg.sender`).
2166      *
2167      * If you are writing GSN compatible contracts, you need to override this function.
2168      */
2169     function _msgSenderERC721A() internal view virtual returns (address) {
2170         return msg.sender;
2171     }
2172 
2173     /**
2174      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2175      */
2176     function _toString(uint256 value) internal pure returns (string memory ptr) {
2177         assembly {
2178             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
2179             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
2180             // We will need 1 32-byte word to store the length, 
2181             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
2182             ptr := add(mload(0x40), 128)
2183             // Update the free memory pointer to allocate.
2184             mstore(0x40, ptr)
2185 
2186             // Cache the end of the memory to calculate the length later.
2187             let end := ptr
2188 
2189             // We write the string from the rightmost digit to the leftmost digit.
2190             // The following is essentially a do-while loop that also handles the zero case.
2191             // Costs a bit more than early returning for the zero case,
2192             // but cheaper in terms of deployment and overall runtime costs.
2193             for { 
2194                 // Initialize and perform the first pass without check.
2195                 let temp := value
2196                 // Move the pointer 1 byte leftwards to point to an empty character slot.
2197                 ptr := sub(ptr, 1)
2198                 // Write the character to the pointer. 48 is the ASCII index of '0'.
2199                 mstore8(ptr, add(48, mod(temp, 10)))
2200                 temp := div(temp, 10)
2201             } temp { 
2202                 // Keep dividing `temp` until zero.
2203                 temp := div(temp, 10)
2204             } { // Body of the for loop.
2205                 ptr := sub(ptr, 1)
2206                 mstore8(ptr, add(48, mod(temp, 10)))
2207             }
2208             
2209             let length := sub(end, ptr)
2210             // Move the pointer 32 bytes leftwards to make room for the length.
2211             ptr := sub(ptr, 32)
2212             // Store the length.
2213             mstore(ptr, length)
2214         }
2215     }
2216 }
2217 
2218 pragma solidity ^0.8.0;
2219 
2220 /**
2221 
2222     string public baseURI = "ipfs://QmPfGGHecn7qNeEFyGfYHGjEb8WXbHJaUKcdDqtmesoB1D/";
2223     string public baseExtension = ".json";
2224 
2225   constructor() ERC721A("10E floor ACTUALLY programmed", "10EFLOOR"){
2226 
2227   }
2228 */
2229 pragma solidity ^0.8.0;
2230 
2231 
2232 contract TenEthProgrammed is ERC721A, Ownable, ReentrancyGuard{
2233     using ECDSA for bytes32;
2234 
2235     address signer;
2236     uint256 public totalClaimed;
2237     mapping(address => bool) public claimed;
2238     uint256 public constant MAX_SUPPLY = 999;
2239     uint public constant freeSupply = 900;
2240     string public baseExtension = ".json";
2241     string public baseUrl = "ipfs://QmcXhstKY6G644KQt16FobWK8JAbxTVyZC1h5xTQhyzEt6/";
2242     address public signer_ = 0xc75B6727CAF1847D5293Bf09508eb7D8c2889bE0;
2243 
2244     error HadClaimed();
2245     error OutofMaxSupply();
2246     error InvalidSignarure();
2247 
2248 
2249     constructor(
2250     ) ERC721A("10E Programmed", "10E") {
2251         _safeMint(msg.sender, 1);
2252         totalClaimed++;
2253     }
2254 
2255     function tokenURI(uint256 _tokenId)
2256     public
2257     view
2258     virtual
2259     override
2260     returns (string memory)
2261 
2262   {
2263     require(
2264       _exists(_tokenId),
2265       "ERC721Metadata: URI query for nonexistent token"
2266     );
2267 
2268     string memory currentBaseURI = _baseURI();
2269     return bytes(currentBaseURI).length > 0
2270         ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId) , baseExtension))
2271         : "";
2272   }
2273 
2274     function totalSupply() public view override returns (uint256) {
2275         unchecked {
2276             return super.totalSupply() - balanceOf(address(0xdead));
2277         }
2278     }
2279 
2280     function freeMint() external {
2281         if (claimed[msg.sender]) revert HadClaimed();
2282         if (!(totalClaimed < freeSupply)) revert HadClaimed();
2283         _safeMint(msg.sender, 1);
2284         claimed[msg.sender] = true;
2285         totalClaimed++;
2286     }
2287     function ownerBatchMint(uint256 amount) external onlyOwner
2288   {
2289       //Profits go to burning more 
2290     require(totalSupply() + amount <= MAX_SUPPLY ,"too many!");
2291 
2292     _safeMint(msg.sender, amount);
2293   }
2294 
2295 
2296     function burn(
2297         uint256 tokenId,
2298         uint8 v,
2299         bytes32 r,
2300         bytes32 s
2301     ) external {
2302         if (keccak256(abi.encodePacked(msg.sender, tokenId)).toEthSignedMessageHash().recover(v, r, s) != signer) {
2303             revert InvalidSignarure();
2304         }
2305         _burn(tokenId);
2306     }
2307 
2308     function _baseURI() internal view virtual override returns (string memory) {
2309         return baseUrl;
2310     }
2311 
2312     function batchBurn(uint256[] memory tokenids) external onlyOwner {
2313         uint256 len = tokenids.length;
2314         for (uint256 i; i < len; i++) {
2315             uint256 tokenid = tokenids[i];
2316             _burn(tokenid);
2317         }
2318     }
2319 
2320     function setBaseURI(string memory url) external onlyOwner {
2321         baseUrl = url;
2322     }
2323 }