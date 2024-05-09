1 // SPDX-License-Identifier: MIT
2 
3 // mintETH.wtf - #bRRRRR
4 
5 // Mint pRRRRRice: 0.007e (0.021e to mint 3)
6 
7 // Max Supply: 5000
8 
9 // Max peRRRRR tx: 3 
10 
11 // Max peRRRRR wallet at launch: 10 
12 
13 // We love to cameRRRRRas and pRRRRRinteRRRRRs.
14 
15 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
16 
17 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
18 
19 pragma solidity ^0.8.0;
20 
21 /**
22  * @dev Interface of the ERC20 standard as defined in the EIP.
23  */
24 interface IERC20 {
25     /**
26      * @dev Returns the amount of tokens in existence.
27      */
28     function totalSupply() external view returns (uint256);
29 
30     /**
31      * @dev Returns the amount of tokens owned by `account`.
32      */
33     function balanceOf(address account) external view returns (uint256);
34 
35     /**
36      * @dev Moves `amount` tokens from the caller's account to `to`.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * Emits a {Transfer} event.
41      */
42     function transfer(address to, uint256 amount) external returns (bool);
43 
44     /**
45      * @dev Returns the remaining number of tokens that `spender` will be
46      * allowed to spend on behalf of `owner` through {transferFrom}. This is
47      * zero by default.
48      *
49      * This value changes when {approve} or {transferFrom} are called.
50      */
51     function allowance(address owner, address spender) external view returns (uint256);
52 
53     /**
54      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * IMPORTANT: Beware that changing an allowance with this method brings the risk
59      * that someone may use both the old and the new allowance by unfortunate
60      * transaction ordering. One possible solution to mitigate this race
61      * condition is to first reduce the spender's allowance to 0 and set the
62      * desired value afterwards:
63      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
64      *
65      * Emits an {Approval} event.
66      */
67     function approve(address spender, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Moves `amount` tokens from `from` to `to` using the
71      * allowance mechanism. `amount` is then deducted from the caller's
72      * allowance.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * Emits a {Transfer} event.
77      */
78     function transferFrom(
79         address from,
80         address to,
81         uint256 amount
82     ) external returns (bool);
83 
84     /**
85      * @dev Emitted when `value` tokens are moved from one account (`from`) to
86      * another (`to`).
87      *
88      * Note that `value` may be zero.
89      */
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     /**
93      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
94      * a call to {approve}. `value` is the new allowance.
95      */
96     event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
100 
101 
102 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
103 
104 pragma solidity ^0.8.0;
105 
106 /**
107  * @dev Contract module that helps prevent reentrant calls to a function.
108  *
109  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
110  * available, which can be applied to functions to make sure there are no nested
111  * (reentrant) calls to them.
112  *
113  * Note that because there is a single `nonReentrant` guard, functions marked as
114  * `nonReentrant` may not call one another. This can be worked around by making
115  * those functions `private`, and then adding `external` `nonReentrant` entry
116  * points to them.
117  *
118  * TIP: If you would like to learn more about reentrancy and alternative ways
119  * to protect against it, check out our blog post
120  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
121  */
122 abstract contract ReentrancyGuard {
123     // Booleans are more expensive than uint256 or any type that takes up a full
124     // word because each write operation emits an extra SLOAD to first read the
125     // slot's contents, replace the bits taken up by the boolean, and then write
126     // back. This is the compiler's defense against contract upgrades and
127     // pointer aliasing, and it cannot be disabled.
128 
129     // The values being non-zero value makes deployment a bit more expensive,
130     // but in exchange the refund on every call to nonReentrant will be lower in
131     // amount. Since refunds are capped to a percentage of the total
132     // transaction's gas, it is best to keep them low in cases like this one, to
133     // increase the likelihood of the full refund coming into effect.
134     uint256 private constant _NOT_ENTERED = 1;
135     uint256 private constant _ENTERED = 2;
136 
137     uint256 private _status;
138 
139     constructor() {
140         _status = _NOT_ENTERED;
141     }
142 
143     /**
144      * @dev Prevents a contract from calling itself, directly or indirectly.
145      * Calling a `nonReentrant` function from another `nonReentrant`
146      * function is not supported. It is possible to prevent this from happening
147      * by making the `nonReentrant` function external, and making it call a
148      * `private` function that does the actual work.
149      */
150     modifier nonReentrant() {
151         // On the first call to nonReentrant, _notEntered will be true
152         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
153 
154         // Any calls to nonReentrant after this point will fail
155         _status = _ENTERED;
156 
157         _;
158 
159         // By storing the original value once again, a refund is triggered (see
160         // https://eips.ethereum.org/EIPS/eip-2200)
161         _status = _NOT_ENTERED;
162     }
163 }
164 
165 // File: @openzeppelin/contracts/utils/Strings.sol
166 
167 
168 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
169 
170 pragma solidity ^0.8.0;
171 
172 /**
173  * @dev String operations.
174  */
175 library Strings {
176     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
177 
178     /**
179      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
180      */
181     function toString(uint256 value) internal pure returns (string memory) {
182         // Inspired by OraclizeAPI's implementation - MIT licence
183         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
184 
185         if (value == 0) {
186             return "0";
187         }
188         uint256 temp = value;
189         uint256 digits;
190         while (temp != 0) {
191             digits++;
192             temp /= 10;
193         }
194         bytes memory buffer = new bytes(digits);
195         while (value != 0) {
196             digits -= 1;
197             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
198             value /= 10;
199         }
200         return string(buffer);
201     }
202 
203     /**
204      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
205      */
206     function toHexString(uint256 value) internal pure returns (string memory) {
207         if (value == 0) {
208             return "0x00";
209         }
210         uint256 temp = value;
211         uint256 length = 0;
212         while (temp != 0) {
213             length++;
214             temp >>= 8;
215         }
216         return toHexString(value, length);
217     }
218 
219     /**
220      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
221      */
222     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
223         bytes memory buffer = new bytes(2 * length + 2);
224         buffer[0] = "0";
225         buffer[1] = "x";
226         for (uint256 i = 2 * length + 1; i > 1; --i) {
227             buffer[i] = _HEX_SYMBOLS[value & 0xf];
228             value >>= 4;
229         }
230         require(value == 0, "Strings: hex length insufficient");
231         return string(buffer);
232     }
233 }
234 
235 // File: @openzeppelin/contracts/utils/Context.sol
236 
237 
238 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
239 
240 pragma solidity ^0.8.0;
241 
242 /**
243  * @dev Provides information about the current execution context, including the
244  * sender of the transaction and its data. While these are generally available
245  * via msg.sender and msg.data, they should not be accessed in such a direct
246  * manner, since when dealing with meta-transactions the account sending and
247  * paying for execution may not be the actual sender (as far as an application
248  * is concerned).
249  *
250  * This contract is only required for intermediate, library-like contracts.
251  */
252 abstract contract Context {
253     function _msgSender() internal view virtual returns (address) {
254         return msg.sender;
255     }
256 
257     function _msgData() internal view virtual returns (bytes calldata) {
258         return msg.data;
259     }
260 }
261 
262 // File: @openzeppelin/contracts/access/Ownable.sol
263 
264 
265 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
266 
267 pragma solidity ^0.8.0;
268 
269 
270 /**
271  * @dev Contract module which provides a basic access control mechanism, where
272  * there is an account (an owner) that can be granted exclusive access to
273  * specific functions.
274  *
275  * By default, the owner account will be the one that deploys the contract. This
276  * can later be changed with {transferOwnership}.
277  *
278  * This module is used through inheritance. It will make available the modifier
279  * `onlyOwner`, which can be applied to your functions to restrict their use to
280  * the owner.
281  */
282 abstract contract Ownable is Context {
283     address private _owner;
284 
285     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
286 
287     /**
288      * @dev Initializes the contract setting the deployer as the initial owner.
289      */
290     constructor() {
291         _transferOwnership(_msgSender());
292     }
293 
294     /**
295      * @dev Returns the address of the current owner.
296      */
297     function owner() public view virtual returns (address) {
298         return _owner;
299     }
300 
301     /**
302      * @dev Throws if called by any account other than the owner.
303      */
304     modifier onlyOwner() {
305         require(owner() == _msgSender(), "Ownable: caller is not the owner");
306         _;
307     }
308 
309     /**
310      * @dev Leaves the contract without owner. It will not be possible to call
311      * `onlyOwner` functions anymore. Can only be called by the current owner.
312      *
313      * NOTE: Renouncing ownership will leave the contract without an owner,
314      * thereby removing any functionality that is only available to the owner.
315      */
316     function renounceOwnership() public virtual onlyOwner {
317         _transferOwnership(address(0));
318     }
319 
320     /**
321      * @dev Transfers ownership of the contract to a new account (`newOwner`).
322      * Can only be called by the current owner.
323      */
324     function transferOwnership(address newOwner) public virtual onlyOwner {
325         require(newOwner != address(0), "Ownable: new owner is the zero address");
326         _transferOwnership(newOwner);
327     }
328 
329     /**
330      * @dev Transfers ownership of the contract to a new account (`newOwner`).
331      * Internal function without access restriction.
332      */
333     function _transferOwnership(address newOwner) internal virtual {
334         address oldOwner = _owner;
335         _owner = newOwner;
336         emit OwnershipTransferred(oldOwner, newOwner);
337     }
338 }
339 
340 // File: @openzeppelin/contracts/utils/Address.sol
341 
342 
343 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
344 
345 pragma solidity ^0.8.1;
346 
347 /**
348  * @dev Collection of functions related to the address type
349  */
350 library Address {
351     /**
352      * @dev Returns true if `account` is a contract.
353      *
354      * [IMPORTANT]
355      * ====
356      * It is unsafe to assume that an address for which this function returns
357      * false is an externally-owned account (EOA) and not a contract.
358      *
359      * Among others, `isContract` will return false for the following
360      * types of addresses:
361      *
362      *  - an externally-owned account
363      *  - a contract in construction
364      *  - an address where a contract will be created
365      *  - an address where a contract lived, but was destroyed
366      * ====
367      *
368      * [IMPORTANT]
369      * ====
370      * You shouldn't rely on `isContract` to protect against flash loan attacks!
371      *
372      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
373      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
374      * constructor.
375      * ====
376      */
377     function isContract(address account) internal view returns (bool) {
378         // This method relies on extcodesize/address.code.length, which returns 0
379         // for contracts in construction, since the code is only stored at the end
380         // of the constructor execution.
381 
382         return account.code.length > 0;
383     }
384 
385     /**
386      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
387      * `recipient`, forwarding all available gas and reverting on errors.
388      *
389      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
390      * of certain opcodes, possibly making contracts go over the 2300 gas limit
391      * imposed by `transfer`, making them unable to receive funds via
392      * `transfer`. {sendValue} removes this limitation.
393      *
394      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
395      *
396      * IMPORTANT: because control is transferred to `recipient`, care must be
397      * taken to not create reentrancy vulnerabilities. Consider using
398      * {ReentrancyGuard} or the
399      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
400      */
401     function sendValue(address payable recipient, uint256 amount) internal {
402         require(address(this).balance >= amount, "Address: insufficient balance");
403 
404         (bool success, ) = recipient.call{value: amount}("");
405         require(success, "Address: unable to send value, recipient may have reverted");
406     }
407 
408     /**
409      * @dev Performs a Solidity function call using a low level `call`. A
410      * plain `call` is an unsafe replacement for a function call: use this
411      * function instead.
412      *
413      * If `target` reverts with a revert reason, it is bubbled up by this
414      * function (like regular Solidity function calls).
415      *
416      * Returns the raw returned data. To convert to the expected return value,
417      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
418      *
419      * Requirements:
420      *
421      * - `target` must be a contract.
422      * - calling `target` with `data` must not revert.
423      *
424      * _Available since v3.1._
425      */
426     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
427         return functionCall(target, data, "Address: low-level call failed");
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
432      * `errorMessage` as a fallback revert reason when `target` reverts.
433      *
434      * _Available since v3.1._
435      */
436     function functionCall(
437         address target,
438         bytes memory data,
439         string memory errorMessage
440     ) internal returns (bytes memory) {
441         return functionCallWithValue(target, data, 0, errorMessage);
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
446      * but also transferring `value` wei to `target`.
447      *
448      * Requirements:
449      *
450      * - the calling contract must have an ETH balance of at least `value`.
451      * - the called Solidity function must be `payable`.
452      *
453      * _Available since v3.1._
454      */
455     function functionCallWithValue(
456         address target,
457         bytes memory data,
458         uint256 value
459     ) internal returns (bytes memory) {
460         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
461     }
462 
463     /**
464      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
465      * with `errorMessage` as a fallback revert reason when `target` reverts.
466      *
467      * _Available since v3.1._
468      */
469     function functionCallWithValue(
470         address target,
471         bytes memory data,
472         uint256 value,
473         string memory errorMessage
474     ) internal returns (bytes memory) {
475         require(address(this).balance >= value, "Address: insufficient balance for call");
476         require(isContract(target), "Address: call to non-contract");
477 
478         (bool success, bytes memory returndata) = target.call{value: value}(data);
479         return verifyCallResult(success, returndata, errorMessage);
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
484      * but performing a static call.
485      *
486      * _Available since v3.3._
487      */
488     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
489         return functionStaticCall(target, data, "Address: low-level static call failed");
490     }
491 
492     /**
493      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
494      * but performing a static call.
495      *
496      * _Available since v3.3._
497      */
498     function functionStaticCall(
499         address target,
500         bytes memory data,
501         string memory errorMessage
502     ) internal view returns (bytes memory) {
503         require(isContract(target), "Address: static call to non-contract");
504 
505         (bool success, bytes memory returndata) = target.staticcall(data);
506         return verifyCallResult(success, returndata, errorMessage);
507     }
508 
509     /**
510      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
511      * but performing a delegate call.
512      *
513      * _Available since v3.4._
514      */
515     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
516         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
517     }
518 
519     /**
520      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
521      * but performing a delegate call.
522      *
523      * _Available since v3.4._
524      */
525     function functionDelegateCall(
526         address target,
527         bytes memory data,
528         string memory errorMessage
529     ) internal returns (bytes memory) {
530         require(isContract(target), "Address: delegate call to non-contract");
531 
532         (bool success, bytes memory returndata) = target.delegatecall(data);
533         return verifyCallResult(success, returndata, errorMessage);
534     }
535 
536     /**
537      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
538      * revert reason using the provided one.
539      *
540      * _Available since v4.3._
541      */
542     function verifyCallResult(
543         bool success,
544         bytes memory returndata,
545         string memory errorMessage
546     ) internal pure returns (bytes memory) {
547         if (success) {
548             return returndata;
549         } else {
550             // Look for revert reason and bubble it up if present
551             if (returndata.length > 0) {
552                 // The easiest way to bubble the revert reason is using memory via assembly
553 
554                 assembly {
555                     let returndata_size := mload(returndata)
556                     revert(add(32, returndata), returndata_size)
557                 }
558             } else {
559                 revert(errorMessage);
560             }
561         }
562     }
563 }
564 
565 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
566 
567 
568 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
569 
570 pragma solidity ^0.8.0;
571 
572 
573 
574 /**
575  * @title SafeERC20
576  * @dev Wrappers around ERC20 operations that throw on failure (when the token
577  * contract returns false). Tokens that return no value (and instead revert or
578  * throw on failure) are also supported, non-reverting calls are assumed to be
579  * successful.
580  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
581  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
582  */
583 library SafeERC20 {
584     using Address for address;
585 
586     function safeTransfer(
587         IERC20 token,
588         address to,
589         uint256 value
590     ) internal {
591         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
592     }
593 
594     function safeTransferFrom(
595         IERC20 token,
596         address from,
597         address to,
598         uint256 value
599     ) internal {
600         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
601     }
602 
603     /**
604      * @dev Deprecated. This function has issues similar to the ones found in
605      * {IERC20-approve}, and its usage is discouraged.
606      *
607      * Whenever possible, use {safeIncreaseAllowance} and
608      * {safeDecreaseAllowance} instead.
609      */
610     function safeApprove(
611         IERC20 token,
612         address spender,
613         uint256 value
614     ) internal {
615         // safeApprove should only be called when setting an initial allowance,
616         // or when resetting it to zero. To increase and decrease it, use
617         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
618         require(
619             (value == 0) || (token.allowance(address(this), spender) == 0),
620             "SafeERC20: approve from non-zero to non-zero allowance"
621         );
622         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
623     }
624 
625     function safeIncreaseAllowance(
626         IERC20 token,
627         address spender,
628         uint256 value
629     ) internal {
630         uint256 newAllowance = token.allowance(address(this), spender) + value;
631         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
632     }
633 
634     function safeDecreaseAllowance(
635         IERC20 token,
636         address spender,
637         uint256 value
638     ) internal {
639         unchecked {
640             uint256 oldAllowance = token.allowance(address(this), spender);
641             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
642             uint256 newAllowance = oldAllowance - value;
643             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
644         }
645     }
646 
647     /**
648      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
649      * on the return value: the return value is optional (but if data is returned, it must not be false).
650      * @param token The token targeted by the call.
651      * @param data The call data (encoded using abi.encode or one of its variants).
652      */
653     function _callOptionalReturn(IERC20 token, bytes memory data) private {
654         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
655         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
656         // the target address contains contract code and also asserts for success in the low-level call.
657 
658         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
659         if (returndata.length > 0) {
660             // Return data is optional
661             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
662         }
663     }
664 }
665 
666 
667 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
668 
669 
670 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
671 
672 pragma solidity ^0.8.0;
673 
674 /**
675  * @title ERC721 token receiver interface
676  * @dev Interface for any contract that wants to support safeTransfers
677  * from ERC721 asset contracts.
678  */
679 interface IERC721Receiver {
680     /**
681      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
682      * by `operator` from `from`, this function is called.
683      *
684      * It must return its Solidity selector to confirm the token transfer.
685      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
686      *
687      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
688      */
689     function onERC721Received(
690         address operator,
691         address from,
692         uint256 tokenId,
693         bytes calldata data
694     ) external returns (bytes4);
695 }
696 
697 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
698 
699 
700 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
701 
702 pragma solidity ^0.8.0;
703 
704 /**
705  * @dev Interface of the ERC165 standard, as defined in the
706  * https://eips.ethereum.org/EIPS/eip-165[EIP].
707  *
708  * Implementers can declare support of contract interfaces, which can then be
709  * queried by others ({ERC165Checker}).
710  *
711  * For an implementation, see {ERC165}.
712  */
713 interface IERC165 {
714     /**
715      * @dev Returns true if this contract implements the interface defined by
716      * `interfaceId`. See the corresponding
717      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
718      * to learn more about how these ids are created.
719      *
720      * This function call must use less than 30 000 gas.
721      */
722     function supportsInterface(bytes4 interfaceId) external view returns (bool);
723 }
724 
725 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
726 
727 
728 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
729 
730 pragma solidity ^0.8.0;
731 
732 
733 /**
734  * @dev Implementation of the {IERC165} interface.
735  *
736  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
737  * for the additional interface id that will be supported. For example:
738  *
739  * ```solidity
740  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
741  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
742  * }
743  * ```
744  *
745  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
746  */
747 abstract contract ERC165 is IERC165 {
748     /**
749      * @dev See {IERC165-supportsInterface}.
750      */
751     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
752         return interfaceId == type(IERC165).interfaceId;
753     }
754 }
755 
756 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
757 
758 
759 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
760 
761 pragma solidity ^0.8.0;
762 
763 
764 /**
765  * @dev Required interface of an ERC721 compliant contract.
766  */
767 interface IERC721 is IERC165 {
768     /**
769      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
770      */
771     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
772 
773     /**
774      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
775      */
776     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
777 
778     /**
779      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
780      */
781     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
782 
783     /**
784      * @dev Returns the number of tokens in ``owner``'s account.
785      */
786     function balanceOf(address owner) external view returns (uint256 balance);
787 
788     /**
789      * @dev Returns the owner of the `tokenId` token.
790      *
791      * Requirements:
792      *
793      * - `tokenId` must exist.
794      */
795     function ownerOf(uint256 tokenId) external view returns (address owner);
796 
797     /**
798      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
799      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
800      *
801      * Requirements:
802      *
803      * - `from` cannot be the zero address.
804      * - `to` cannot be the zero address.
805      * - `tokenId` token must exist and be owned by `from`.
806      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
807      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
808      *
809      * Emits a {Transfer} event.
810      */
811     function safeTransferFrom(
812         address from,
813         address to,
814         uint256 tokenId
815     ) external;
816 
817     /**
818      * @dev Transfers `tokenId` token from `from` to `to`.
819      *
820      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
821      *
822      * Requirements:
823      *
824      * - `from` cannot be the zero address.
825      * - `to` cannot be the zero address.
826      * - `tokenId` token must be owned by `from`.
827      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
828      *
829      * Emits a {Transfer} event.
830      */
831     function transferFrom(
832         address from,
833         address to,
834         uint256 tokenId
835     ) external;
836 
837     /**
838      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
839      * The approval is cleared when the token is transferred.
840      *
841      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
842      *
843      * Requirements:
844      *
845      * - The caller must own the token or be an approved operator.
846      * - `tokenId` must exist.
847      *
848      * Emits an {Approval} event.
849      */
850     function approve(address to, uint256 tokenId) external;
851 
852     /**
853      * @dev Returns the account approved for `tokenId` token.
854      *
855      * Requirements:
856      *
857      * - `tokenId` must exist.
858      */
859     function getApproved(uint256 tokenId) external view returns (address operator);
860 
861     /**
862      * @dev Approve or remove `operator` as an operator for the caller.
863      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
864      *
865      * Requirements:
866      *
867      * - The `operator` cannot be the caller.
868      *
869      * Emits an {ApprovalForAll} event.
870      */
871     function setApprovalForAll(address operator, bool _approved) external;
872 
873     /**
874      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
875      *
876      * See {setApprovalForAll}
877      */
878     function isApprovedForAll(address owner, address operator) external view returns (bool);
879 
880     /**
881      * @dev Safely transfers `tokenId` token from `from` to `to`.
882      *
883      * Requirements:
884      *
885      * - `from` cannot be the zero address.
886      * - `to` cannot be the zero address.
887      * - `tokenId` token must exist and be owned by `from`.
888      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
889      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
890      *
891      * Emits a {Transfer} event.
892      */
893     function safeTransferFrom(
894         address from,
895         address to,
896         uint256 tokenId,
897         bytes calldata data
898     ) external;
899 }
900 
901 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
902 
903 
904 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
905 
906 pragma solidity ^0.8.0;
907 
908 
909 /**
910  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
911  * @dev See https://eips.ethereum.org/EIPS/eip-721
912  */
913 interface IERC721Enumerable is IERC721 {
914     /**
915      * @dev Returns the total amount of tokens stored by the contract.
916      */
917     function totalSupply() external view returns (uint256);
918 
919     /**
920      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
921      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
922      */
923     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
924 
925     /**
926      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
927      * Use along with {totalSupply} to enumerate all tokens.
928      */
929     function tokenByIndex(uint256 index) external view returns (uint256);
930 }
931 
932 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
933 
934 
935 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
936 
937 pragma solidity ^0.8.0;
938 
939 
940 /**
941  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
942  * @dev See https://eips.ethereum.org/EIPS/eip-721
943  */
944 interface IERC721Metadata is IERC721 {
945     /**
946      * @dev Returns the token collection name.
947      */
948     function name() external view returns (string memory);
949 
950     /**
951      * @dev Returns the token collection symbol.
952      */
953     function symbol() external view returns (string memory);
954 
955     /**
956      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
957      */
958     function tokenURI(uint256 tokenId) external view returns (string memory);
959 }
960 
961 
962 pragma solidity ^0.8.0;
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
1449 contract MintETH is ERC721A, Ownable, ReentrancyGuard {
1450 
1451   uint public nextOwnerToExplicitlySet;
1452   uint public price = 0.007 ether;
1453   uint public maxPerTx = 3;
1454   uint public maxSupply = 5000;
1455   uint public maxPerWallet = 10;
1456   bool public mintEnabled;
1457   string public baseURI;
1458 
1459   constructor() ERC721A("MintETH", "mETH") {}
1460   function mint(uint256 num) external payable {
1461     require( num < maxPerTx + 1, "exceeded max per tx");
1462     require(numberMinted(msg.sender) + num < maxPerWallet + 1,"max per wallet exceeded");
1463     require(msg.sender == tx.origin,"be u");
1464     require(msg.value == num * price,"wrong amount");
1465     require(totalSupply() + num < maxSupply + 1,"sold out");
1466     require(mintEnabled, "mint closed.");
1467     _safeMint(msg.sender, num);
1468   }
1469   function reserveMint(uint256 num) external onlyOwner {
1470     require(totalSupply() + num < maxSupply + 1,"not enough to reserve");
1471     _safeMint(msg.sender, num);
1472   }
1473   function setBaseURI(string calldata baseURI_) external onlyOwner {
1474     baseURI = baseURI_;
1475   }
1476   function toggleMint() external onlyOwner {
1477       mintEnabled = !mintEnabled;
1478   }
1479   function numberMinted(address owner) public view returns (uint256) {
1480     return _numberMinted(owner);
1481   }
1482   function setMintPrice(uint256 val) external onlyOwner {
1483       price = val;
1484   }
1485   function setMaxPerTx(uint256 maxPerTx_) external onlyOwner {
1486       maxPerTx = maxPerTx_;
1487   }
1488   function setMaxSupply(uint256 maxSupply_) external onlyOwner {
1489       maxSupply = maxSupply_;
1490   }
1491   function setMaxPerWallet(uint256 maxPerWallet_) external onlyOwner {
1492       maxPerWallet = maxPerWallet_;
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