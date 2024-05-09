1 // SPDX-License-Identifier: MIT
2 
3 //  __        ___________  ____  ____  
4 //  \ \      / /__  /  _ \|  _ \/ ___| 
5 //   \ \ /\ / /  / /| |_) | | | \___ \ 
6 //    \ V  V /  / /_|  _ <| |_| |___) |
7 //     \_/\_/  /____|_| \_\____/|____/ 
8 
9 // Website: wzrds.wtf
10 // Twitter: https://twitter.com/WZRDSxyz
11 // Supply: 10,000 NFTs
12 // Total FREE: 5000
13 // Rest for 0.005 ETH
14 // Max 2 per tx during free mint and 5 during paid mint
15 
16 
17 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol                            
18 
19 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
20 
21 pragma solidity ^0.8.0;
22 
23 /**
24  * @dev Interface of the ERC20 standard as defined in the EIP.
25  */
26 interface IERC20 {
27     /**
28      * @dev Returns the amount of tokens in existence.
29      */
30     function totalSupply() external view returns (uint256);
31 
32     /**
33      * @dev Returns the amount of tokens owned by `account`.
34      */
35     function balanceOf(address account) external view returns (uint256);
36 
37     /**
38      * @dev Moves `amount` tokens from the caller's account to `to`.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * Emits a {Transfer} event.
43      */
44     function transfer(address to, uint256 amount) external returns (bool);
45 
46     /**
47      * @dev Returns the remaining number of tokens that `spender` will be
48      * allowed to spend on behalf of `owner` through {transferFrom}. This is
49      * zero by default.
50      *
51      * This value changes when {approve} or {transferFrom} are called.
52      */
53     function allowance(address owner, address spender) external view returns (uint256);
54 
55     /**
56      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * IMPORTANT: Beware that changing an allowance with this method brings the risk
61      * that someone may use both the old and the new allowance by unfortunate
62      * transaction ordering. One possible solution to mitigate this race
63      * condition is to first reduce the spender's allowance to 0 and set the
64      * desired value afterwards:
65      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
66      *
67      * Emits an {Approval} event.
68      */
69     function approve(address spender, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Moves `amount` tokens from `from` to `to` using the
73      * allowance mechanism. `amount` is then deducted from the caller's
74      * allowance.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * Emits a {Transfer} event.
79      */
80     function transferFrom(
81         address from,
82         address to,
83         uint256 amount
84     ) external returns (bool);
85 
86     /**
87      * @dev Emitted when `value` tokens are moved from one account (`from`) to
88      * another (`to`).
89      *
90      * Note that `value` may be zero.
91      */
92     event Transfer(address indexed from, address indexed to, uint256 value);
93 
94     /**
95      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
96      * a call to {approve}. `value` is the new allowance.
97      */
98     event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
102 
103 
104 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
105 
106 pragma solidity ^0.8.0;
107 
108 /**
109  * @dev Contract module that helps prevent reentrant calls to a function.
110  *
111  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
112  * available, which can be applied to functions to make sure there are no nested
113  * (reentrant) calls to them.
114  *
115  * Note that because there is a single `nonReentrant` guard, functions marked as
116  * `nonReentrant` may not call one another. This can be worked around by making
117  * those functions `private`, and then adding `external` `nonReentrant` entry
118  * points to them.
119  *
120  * TIP: If you would like to learn more about reentrancy and alternative ways
121  * to protect against it, check out our blog post
122  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
123  */
124 abstract contract ReentrancyGuard {
125     // Booleans are more expensive than uint256 or any type that takes up a full
126     // word because each write operation emits an extra SLOAD to first read the
127     // slot's contents, replace the bits taken up by the boolean, and then write
128     // back. This is the compiler's defense against contract upgrades and
129     // pointer aliasing, and it cannot be disabled.
130 
131     // The values being non-zero value makes deployment a bit more expensive,
132     // but in exchange the refund on every call to nonReentrant will be lower in
133     // amount. Since refunds are capped to a percentage of the total
134     // transaction's gas, it is best to keep them low in cases like this one, to
135     // increase the likelihood of the full refund coming into effect.
136     uint256 private constant _NOT_ENTERED = 1;
137     uint256 private constant _ENTERED = 2;
138 
139     uint256 private _status;
140 
141     constructor() {
142         _status = _NOT_ENTERED;
143     }
144 
145     /**
146      * @dev Prevents a contract from calling itself, directly or indirectly.
147      * Calling a `nonReentrant` function from another `nonReentrant`
148      * function is not supported. It is possible to prevent this from happening
149      * by making the `nonReentrant` function external, and making it call a
150      * `private` function that does the actual work.
151      */
152     modifier nonReentrant() {
153         // On the first call to nonReentrant, _notEntered will be true
154         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
155 
156         // Any calls to nonReentrant after this point will fail
157         _status = _ENTERED;
158 
159         _;
160 
161         // By storing the original value once again, a refund is triggered (see
162         // https://eips.ethereum.org/EIPS/eip-2200)
163         _status = _NOT_ENTERED;
164     }
165 }
166 
167 // File: @openzeppelin/contracts/utils/Strings.sol
168 
169 
170 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
171 
172 pragma solidity ^0.8.0;
173 
174 /**
175  * @dev String operations.
176  */
177 library Strings {
178     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
179 
180     /**
181      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
182      */
183     function toString(uint256 value) internal pure returns (string memory) {
184         // Inspired by OraclizeAPI's implementation - MIT licence
185         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
186 
187         if (value == 0) {
188             return "0";
189         }
190         uint256 temp = value;
191         uint256 digits;
192         while (temp != 0) {
193             digits++;
194             temp /= 10;
195         }
196         bytes memory buffer = new bytes(digits);
197         while (value != 0) {
198             digits -= 1;
199             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
200             value /= 10;
201         }
202         return string(buffer);
203     }
204 
205     /**
206      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
207      */
208     function toHexString(uint256 value) internal pure returns (string memory) {
209         if (value == 0) {
210             return "0x00";
211         }
212         uint256 temp = value;
213         uint256 length = 0;
214         while (temp != 0) {
215             length++;
216             temp >>= 8;
217         }
218         return toHexString(value, length);
219     }
220 
221     /**
222      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
223      */
224     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
225         bytes memory buffer = new bytes(2 * length + 2);
226         buffer[0] = "0";
227         buffer[1] = "x";
228         for (uint256 i = 2 * length + 1; i > 1; --i) {
229             buffer[i] = _HEX_SYMBOLS[value & 0xf];
230             value >>= 4;
231         }
232         require(value == 0, "Strings: hex length insufficient");
233         return string(buffer);
234     }
235 }
236 
237 // File: @openzeppelin/contracts/utils/Context.sol
238 
239 
240 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
241 
242 pragma solidity ^0.8.0;
243 
244 /**
245  * @dev Provides information about the current execution context, including the
246  * sender of the transaction and its data. While these are generally available
247  * via msg.sender and msg.data, they should not be accessed in such a direct
248  * manner, since when dealing with meta-transactions the account sending and
249  * paying for execution may not be the actual sender (as far as an application
250  * is concerned).
251  *
252  * This contract is only required for intermediate, library-like contracts.
253  */
254 abstract contract Context {
255     function _msgSender() internal view virtual returns (address) {
256         return msg.sender;
257     }
258 
259     function _msgData() internal view virtual returns (bytes calldata) {
260         return msg.data;
261     }
262 }
263 
264 // File: @openzeppelin/contracts/access/Ownable.sol
265 
266 
267 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
268 
269 pragma solidity ^0.8.0;
270 
271 
272 /**
273  * @dev Contract module which provides a basic access control mechanism, where
274  * there is an account (an owner) that can be granted exclusive access to
275  * specific functions.
276  *
277  * By default, the owner account will be the one that deploys the contract. This
278  * can later be changed with {transferOwnership}.
279  *
280  * This module is used through inheritance. It will make available the modifier
281  * `onlyOwner`, which can be applied to your functions to restrict their use to
282  * the owner.
283  */
284 abstract contract Ownable is Context {
285     address private _owner;
286 
287     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
288 
289     /**
290      * @dev Initializes the contract setting the deployer as the initial owner.
291      */
292     constructor() {
293         _transferOwnership(_msgSender());
294     }
295 
296     /**
297      * @dev Returns the address of the current owner.
298      */
299     function owner() public view virtual returns (address) {
300         return _owner;
301     }
302 
303     /**
304      * @dev Throws if called by any account other than the owner.
305      */
306     modifier onlyOwner() {
307         require(owner() == _msgSender(), "Ownable: caller is not the owner");
308         _;
309     }
310 
311     /**
312      * @dev Leaves the contract without owner. It will not be possible to call
313      * `onlyOwner` functions anymore. Can only be called by the current owner.
314      *
315      * NOTE: Renouncing ownership will leave the contract without an owner,
316      * thereby removing any functionality that is only available to the owner.
317      */
318     function renounceOwnership() public virtual onlyOwner {
319         _transferOwnership(address(0));
320     }
321 
322     /**
323      * @dev Transfers ownership of the contract to a new account (`newOwner`).
324      * Can only be called by the current owner.
325      */
326     function transferOwnership(address newOwner) public virtual onlyOwner {
327         require(newOwner != address(0), "Ownable: new owner is the zero address");
328         _transferOwnership(newOwner);
329     }
330 
331     /**
332      * @dev Transfers ownership of the contract to a new account (`newOwner`).
333      * Internal function without access restriction.
334      */
335     function _transferOwnership(address newOwner) internal virtual {
336         address oldOwner = _owner;
337         _owner = newOwner;
338         emit OwnershipTransferred(oldOwner, newOwner);
339     }
340 }
341 
342 // File: @openzeppelin/contracts/utils/Address.sol
343 
344 
345 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
346 
347 pragma solidity ^0.8.1;
348 
349 /**
350  * @dev Collection of functions related to the address type
351  */
352 library Address {
353     /**
354      * @dev Returns true if `account` is a contract.
355      *
356      * [IMPORTANT]
357      * ====
358      * It is unsafe to assume that an address for which this function returns
359      * false is an externally-owned account (EOA) and not a contract.
360      *
361      * Among others, `isContract` will return false for the following
362      * types of addresses:
363      *
364      *  - an externally-owned account
365      *  - a contract in construction
366      *  - an address where a contract will be created
367      *  - an address where a contract lived, but was destroyed
368      * ====
369      *
370      * [IMPORTANT]
371      * ====
372      * You shouldn't rely on `isContract` to protect against flash loan attacks!
373      *
374      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
375      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
376      * constructor.
377      * ====
378      */
379     function isContract(address account) internal view returns (bool) {
380         // This method relies on extcodesize/address.code.length, which returns 0
381         // for contracts in construction, since the code is only stored at the end
382         // of the constructor execution.
383 
384         return account.code.length > 0;
385     }
386 
387     /**
388      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
389      * `recipient`, forwarding all available gas and reverting on errors.
390      *
391      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
392      * of certain opcodes, possibly making contracts go over the 2300 gas limit
393      * imposed by `transfer`, making them unable to receive funds via
394      * `transfer`. {sendValue} removes this limitation.
395      *
396      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
397      *
398      * IMPORTANT: because control is transferred to `recipient`, care must be
399      * taken to not create reentrancy vulnerabilities. Consider using
400      * {ReentrancyGuard} or the
401      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
402      */
403     function sendValue(address payable recipient, uint256 amount) internal {
404         require(address(this).balance >= amount, "Address: insufficient balance");
405 
406         (bool success, ) = recipient.call{value: amount}("");
407         require(success, "Address: unable to send value, recipient may have reverted");
408     }
409 
410     /**
411      * @dev Performs a Solidity function call using a low level `call`. A
412      * plain `call` is an unsafe replacement for a function call: use this
413      * function instead.
414      *
415      * If `target` reverts with a revert reason, it is bubbled up by this
416      * function (like regular Solidity function calls).
417      *
418      * Returns the raw returned data. To convert to the expected return value,
419      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
420      *
421      * Requirements:
422      *
423      * - `target` must be a contract.
424      * - calling `target` with `data` must not revert.
425      *
426      * _Available since v3.1._
427      */
428     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
429         return functionCall(target, data, "Address: low-level call failed");
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
434      * `errorMessage` as a fallback revert reason when `target` reverts.
435      *
436      * _Available since v3.1._
437      */
438     function functionCall(
439         address target,
440         bytes memory data,
441         string memory errorMessage
442     ) internal returns (bytes memory) {
443         return functionCallWithValue(target, data, 0, errorMessage);
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
448      * but also transferring `value` wei to `target`.
449      *
450      * Requirements:
451      *
452      * - the calling contract must have an ETH balance of at least `value`.
453      * - the called Solidity function must be `payable`.
454      *
455      * _Available since v3.1._
456      */
457     function functionCallWithValue(
458         address target,
459         bytes memory data,
460         uint256 value
461     ) internal returns (bytes memory) {
462         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
463     }
464 
465     /**
466      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
467      * with `errorMessage` as a fallback revert reason when `target` reverts.
468      *
469      * _Available since v3.1._
470      */
471     function functionCallWithValue(
472         address target,
473         bytes memory data,
474         uint256 value,
475         string memory errorMessage
476     ) internal returns (bytes memory) {
477         require(address(this).balance >= value, "Address: insufficient balance for call");
478         require(isContract(target), "Address: call to non-contract");
479 
480         (bool success, bytes memory returndata) = target.call{value: value}(data);
481         return verifyCallResult(success, returndata, errorMessage);
482     }
483 
484     /**
485      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
486      * but performing a static call.
487      *
488      * _Available since v3.3._
489      */
490     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
491         return functionStaticCall(target, data, "Address: low-level static call failed");
492     }
493 
494     /**
495      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
496      * but performing a static call.
497      *
498      * _Available since v3.3._
499      */
500     function functionStaticCall(
501         address target,
502         bytes memory data,
503         string memory errorMessage
504     ) internal view returns (bytes memory) {
505         require(isContract(target), "Address: static call to non-contract");
506 
507         (bool success, bytes memory returndata) = target.staticcall(data);
508         return verifyCallResult(success, returndata, errorMessage);
509     }
510 
511     /**
512      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
513      * but performing a delegate call.
514      *
515      * _Available since v3.4._
516      */
517     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
518         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
519     }
520 
521     /**
522      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
523      * but performing a delegate call.
524      *
525      * _Available since v3.4._
526      */
527     function functionDelegateCall(
528         address target,
529         bytes memory data,
530         string memory errorMessage
531     ) internal returns (bytes memory) {
532         require(isContract(target), "Address: delegate call to non-contract");
533 
534         (bool success, bytes memory returndata) = target.delegatecall(data);
535         return verifyCallResult(success, returndata, errorMessage);
536     }
537 
538     /**
539      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
540      * revert reason using the provided one.
541      *
542      * _Available since v4.3._
543      */
544     function verifyCallResult(
545         bool success,
546         bytes memory returndata,
547         string memory errorMessage
548     ) internal pure returns (bytes memory) {
549         if (success) {
550             return returndata;
551         } else {
552             // Look for revert reason and bubble it up if present
553             if (returndata.length > 0) {
554                 // The easiest way to bubble the revert reason is using memory via assembly
555 
556                 assembly {
557                     let returndata_size := mload(returndata)
558                     revert(add(32, returndata), returndata_size)
559                 }
560             } else {
561                 revert(errorMessage);
562             }
563         }
564     }
565 }
566 
567 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
568 
569 
570 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
571 
572 pragma solidity ^0.8.0;
573 
574 
575 
576 /**
577  * @title SafeERC20
578  * @dev Wrappers around ERC20 operations that throw on failure (when the token
579  * contract returns false). Tokens that return no value (and instead revert or
580  * throw on failure) are also supported, non-reverting calls are assumed to be
581  * successful.
582  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
583  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
584  */
585 library SafeERC20 {
586     using Address for address;
587 
588     function safeTransfer(
589         IERC20 token,
590         address to,
591         uint256 value
592     ) internal {
593         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
594     }
595 
596     function safeTransferFrom(
597         IERC20 token,
598         address from,
599         address to,
600         uint256 value
601     ) internal {
602         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
603     }
604 
605     /**
606      * @dev Deprecated. This function has issues similar to the ones found in
607      * {IERC20-approve}, and its usage is discouraged.
608      *
609      * Whenever possible, use {safeIncreaseAllowance} and
610      * {safeDecreaseAllowance} instead.
611      */
612     function safeApprove(
613         IERC20 token,
614         address spender,
615         uint256 value
616     ) internal {
617         // safeApprove should only be called when setting an initial allowance,
618         // or when resetting it to zero. To increase and decrease it, use
619         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
620         require(
621             (value == 0) || (token.allowance(address(this), spender) == 0),
622             "SafeERC20: approve from non-zero to non-zero allowance"
623         );
624         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
625     }
626 
627     function safeIncreaseAllowance(
628         IERC20 token,
629         address spender,
630         uint256 value
631     ) internal {
632         uint256 newAllowance = token.allowance(address(this), spender) + value;
633         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
634     }
635 
636     function safeDecreaseAllowance(
637         IERC20 token,
638         address spender,
639         uint256 value
640     ) internal {
641         unchecked {
642             uint256 oldAllowance = token.allowance(address(this), spender);
643             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
644             uint256 newAllowance = oldAllowance - value;
645             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
646         }
647     }
648 
649     /**
650      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
651      * on the return value: the return value is optional (but if data is returned, it must not be false).
652      * @param token The token targeted by the call.
653      * @param data The call data (encoded using abi.encode or one of its variants).
654      */
655     function _callOptionalReturn(IERC20 token, bytes memory data) private {
656         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
657         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
658         // the target address contains contract code and also asserts for success in the low-level call.
659 
660         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
661         if (returndata.length > 0) {
662             // Return data is optional
663             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
664         }
665     }
666 }
667 
668 
669 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
670 
671 
672 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
673 
674 pragma solidity ^0.8.0;
675 
676 /**
677  * @title ERC721 token receiver interface
678  * @dev Interface for any contract that wants to support safeTransfers
679  * from ERC721 asset contracts.
680  */
681 interface IERC721Receiver {
682     /**
683      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
684      * by `operator` from `from`, this function is called.
685      *
686      * It must return its Solidity selector to confirm the token transfer.
687      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
688      *
689      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
690      */
691     function onERC721Received(
692         address operator,
693         address from,
694         uint256 tokenId,
695         bytes calldata data
696     ) external returns (bytes4);
697 }
698 
699 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
700 
701 
702 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
703 
704 pragma solidity ^0.8.0;
705 
706 /**
707  * @dev Interface of the ERC165 standard, as defined in the
708  * https://eips.ethereum.org/EIPS/eip-165[EIP].
709  *
710  * Implementers can declare support of contract interfaces, which can then be
711  * queried by others ({ERC165Checker}).
712  *
713  * For an implementation, see {ERC165}.
714  */
715 interface IERC165 {
716     /**
717      * @dev Returns true if this contract implements the interface defined by
718      * `interfaceId`. See the corresponding
719      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
720      * to learn more about how these ids are created.
721      *
722      * This function call must use less than 30 000 gas.
723      */
724     function supportsInterface(bytes4 interfaceId) external view returns (bool);
725 }
726 
727 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
728 
729 
730 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
731 
732 pragma solidity ^0.8.0;
733 
734 
735 /**
736  * @dev Implementation of the {IERC165} interface.
737  *
738  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
739  * for the additional interface id that will be supported. For example:
740  *
741  * ```solidity
742  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
743  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
744  * }
745  * ```
746  *
747  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
748  */
749 abstract contract ERC165 is IERC165 {
750     /**
751      * @dev See {IERC165-supportsInterface}.
752      */
753     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
754         return interfaceId == type(IERC165).interfaceId;
755     }
756 }
757 
758 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
759 
760 
761 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
762 
763 pragma solidity ^0.8.0;
764 
765 
766 /**
767  * @dev Required interface of an ERC721 compliant contract.
768  */
769 interface IERC721 is IERC165 {
770     /**
771      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
772      */
773     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
774 
775     /**
776      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
777      */
778     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
779 
780     /**
781      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
782      */
783     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
784 
785     /**
786      * @dev Returns the number of tokens in ``owner``'s account.
787      */
788     function balanceOf(address owner) external view returns (uint256 balance);
789 
790     /**
791      * @dev Returns the owner of the `tokenId` token.
792      *
793      * Requirements:
794      *
795      * - `tokenId` must exist.
796      */
797     function ownerOf(uint256 tokenId) external view returns (address owner);
798 
799     /**
800      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
801      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
802      *
803      * Requirements:
804      *
805      * - `from` cannot be the zero address.
806      * - `to` cannot be the zero address.
807      * - `tokenId` token must exist and be owned by `from`.
808      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
809      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
810      *
811      * Emits a {Transfer} event.
812      */
813     function safeTransferFrom(
814         address from,
815         address to,
816         uint256 tokenId
817     ) external;
818 
819     /**
820      * @dev Transfers `tokenId` token from `from` to `to`.
821      *
822      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
823      *
824      * Requirements:
825      *
826      * - `from` cannot be the zero address.
827      * - `to` cannot be the zero address.
828      * - `tokenId` token must be owned by `from`.
829      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
830      *
831      * Emits a {Transfer} event.
832      */
833     function transferFrom(
834         address from,
835         address to,
836         uint256 tokenId
837     ) external;
838 
839     /**
840      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
841      * The approval is cleared when the token is transferred.
842      *
843      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
844      *
845      * Requirements:
846      *
847      * - The caller must own the token or be an approved operator.
848      * - `tokenId` must exist.
849      *
850      * Emits an {Approval} event.
851      */
852     function approve(address to, uint256 tokenId) external;
853 
854     /**
855      * @dev Returns the account approved for `tokenId` token.
856      *
857      * Requirements:
858      *
859      * - `tokenId` must exist.
860      */
861     function getApproved(uint256 tokenId) external view returns (address operator);
862 
863     /**
864      * @dev Approve or remove `operator` as an operator for the caller.
865      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
866      *
867      * Requirements:
868      *
869      * - The `operator` cannot be the caller.
870      *
871      * Emits an {ApprovalForAll} event.
872      */
873     function setApprovalForAll(address operator, bool _approved) external;
874 
875     /**
876      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
877      *
878      * See {setApprovalForAll}
879      */
880     function isApprovedForAll(address owner, address operator) external view returns (bool);
881 
882     /**
883      * @dev Safely transfers `tokenId` token from `from` to `to`.
884      *
885      * Requirements:
886      *
887      * - `from` cannot be the zero address.
888      * - `to` cannot be the zero address.
889      * - `tokenId` token must exist and be owned by `from`.
890      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
891      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
892      *
893      * Emits a {Transfer} event.
894      */
895     function safeTransferFrom(
896         address from,
897         address to,
898         uint256 tokenId,
899         bytes calldata data
900     ) external;
901 }
902 
903 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
904 
905 
906 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
907 
908 pragma solidity ^0.8.0;
909 
910 
911 /**
912  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
913  * @dev See https://eips.ethereum.org/EIPS/eip-721
914  */
915 interface IERC721Enumerable is IERC721 {
916     /**
917      * @dev Returns the total amount of tokens stored by the contract.
918      */
919     function totalSupply() external view returns (uint256);
920 
921     /**
922      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
923      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
924      */
925     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
926 
927     /**
928      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
929      * Use along with {totalSupply} to enumerate all tokens.
930      */
931     function tokenByIndex(uint256 index) external view returns (uint256);
932 }
933 
934 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
935 
936 
937 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
938 
939 pragma solidity ^0.8.0;
940 
941 
942 /**
943  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
944  * @dev See https://eips.ethereum.org/EIPS/eip-721
945  */
946 interface IERC721Metadata is IERC721 {
947     /**
948      * @dev Returns the token collection name.
949      */
950     function name() external view returns (string memory);
951 
952     /**
953      * @dev Returns the token collection symbol.
954      */
955     function symbol() external view returns (string memory);
956 
957     /**
958      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
959      */
960     function tokenURI(uint256 tokenId) external view returns (string memory);
961 }
962 
963 // File: contracts/TwistedToonz.sol
964 
965 
966 // Creator: Chiru Labs
967 
968 pragma solidity ^0.8.0;
969 
970 
971 
972 
973 
974 
975 
976 
977 
978 /**
979  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
980  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
981  *
982  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
983  *
984  * Does not support burning tokens to address(0).
985  *
986  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
987  */
988 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
989     using Address for address;
990     using Strings for uint256;
991 
992     struct TokenOwnership {
993         address addr;
994         uint64 startTimestamp;
995     }
996 
997     struct AddressData {
998         uint128 balance;
999         uint128 numberMinted;
1000     }
1001 
1002     uint256 internal currentIndex;
1003 
1004     // Token name
1005     string private _name;
1006 
1007     // Token symbol
1008     string private _symbol;
1009 
1010     // Mapping from token ID to ownership details
1011     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1012     mapping(uint256 => TokenOwnership) internal _ownerships;
1013 
1014     // Mapping owner address to address data
1015     mapping(address => AddressData) private _addressData;
1016 
1017     // Mapping from token ID to approved address
1018     mapping(uint256 => address) private _tokenApprovals;
1019 
1020     // Mapping from owner to operator approvals
1021     mapping(address => mapping(address => bool)) private _operatorApprovals;
1022 
1023     constructor(string memory name_, string memory symbol_) {
1024         _name = name_;
1025         _symbol = symbol_;
1026     }
1027 
1028     /**
1029      * @dev See {IERC721Enumerable-totalSupply}.
1030      */
1031     function totalSupply() public view override returns (uint256) {
1032         return currentIndex;
1033     }
1034 
1035     /**
1036      * @dev See {IERC721Enumerable-tokenByIndex}.
1037      */
1038     function tokenByIndex(uint256 index) public view override returns (uint256) {
1039         require(index < totalSupply(), "ERC721A: global index out of bounds");
1040         return index;
1041     }
1042 
1043     /**
1044      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1045      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1046      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1047      */
1048     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1049         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1050         uint256 numMintedSoFar = totalSupply();
1051         uint256 tokenIdsIdx;
1052         address currOwnershipAddr;
1053 
1054         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1055         unchecked {
1056             for (uint256 i; i < numMintedSoFar; i++) {
1057                 TokenOwnership memory ownership = _ownerships[i];
1058                 if (ownership.addr != address(0)) {
1059                     currOwnershipAddr = ownership.addr;
1060                 }
1061                 if (currOwnershipAddr == owner) {
1062                     if (tokenIdsIdx == index) {
1063                         return i;
1064                     }
1065                     tokenIdsIdx++;
1066                 }
1067             }
1068         }
1069 
1070         revert("ERC721A: unable to get token of owner by index");
1071     }
1072 
1073     /**
1074      * @dev See {IERC165-supportsInterface}.
1075      */
1076     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1077         return
1078             interfaceId == type(IERC721).interfaceId ||
1079             interfaceId == type(IERC721Metadata).interfaceId ||
1080             interfaceId == type(IERC721Enumerable).interfaceId ||
1081             super.supportsInterface(interfaceId);
1082     }
1083 
1084     /**
1085      * @dev See {IERC721-balanceOf}.
1086      */
1087     function balanceOf(address owner) public view override returns (uint256) {
1088         require(owner != address(0), "ERC721A: balance query for the zero address");
1089         return uint256(_addressData[owner].balance);
1090     }
1091 
1092     function _numberMinted(address owner) internal view returns (uint256) {
1093         require(owner != address(0), "ERC721A: number minted query for the zero address");
1094         return uint256(_addressData[owner].numberMinted);
1095     }
1096 
1097     /**
1098      * Gas spent here starts off proportional to the maximum mint batch size.
1099      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1100      */
1101     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1102         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1103 
1104         unchecked {
1105             for (uint256 curr = tokenId; curr >= 0; curr--) {
1106                 TokenOwnership memory ownership = _ownerships[curr];
1107                 if (ownership.addr != address(0)) {
1108                     return ownership;
1109                 }
1110             }
1111         }
1112 
1113         revert("ERC721A: unable to determine the owner of token");
1114     }
1115 
1116     /**
1117      * @dev See {IERC721-ownerOf}.
1118      */
1119     function ownerOf(uint256 tokenId) public view override returns (address) {
1120         return ownershipOf(tokenId).addr;
1121     }
1122 
1123     /**
1124      * @dev See {IERC721Metadata-name}.
1125      */
1126     function name() public view virtual override returns (string memory) {
1127         return _name;
1128     }
1129 
1130     /**
1131      * @dev See {IERC721Metadata-symbol}.
1132      */
1133     function symbol() public view virtual override returns (string memory) {
1134         return _symbol;
1135     }
1136 
1137     /**
1138      * @dev See {IERC721Metadata-tokenURI}.
1139      */
1140     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1141         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1142 
1143         string memory baseURI = _baseURI();
1144         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1145     }
1146 
1147     /**
1148      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1149      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1150      * by default, can be overriden in child contracts.
1151      */
1152     function _baseURI() internal view virtual returns (string memory) {
1153         return "";
1154     }
1155 
1156     /**
1157      * @dev See {IERC721-approve}.
1158      */
1159     function approve(address to, uint256 tokenId) public override {
1160         address owner = ERC721A.ownerOf(tokenId);
1161         require(to != owner, "ERC721A: approval to current owner");
1162 
1163         require(
1164             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1165             "ERC721A: approve caller is not owner nor approved for all"
1166         );
1167 
1168         _approve(to, tokenId, owner);
1169     }
1170 
1171     /**
1172      * @dev See {IERC721-getApproved}.
1173      */
1174     function getApproved(uint256 tokenId) public view override returns (address) {
1175         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1176 
1177         return _tokenApprovals[tokenId];
1178     }
1179 
1180     /**
1181      * @dev See {IERC721-setApprovalForAll}.
1182      */
1183     function setApprovalForAll(address operator, bool approved) public override {
1184         require(operator != _msgSender(), "ERC721A: approve to caller");
1185 
1186         _operatorApprovals[_msgSender()][operator] = approved;
1187         emit ApprovalForAll(_msgSender(), operator, approved);
1188     }
1189 
1190     /**
1191      * @dev See {IERC721-isApprovedForAll}.
1192      */
1193     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1194         return _operatorApprovals[owner][operator];
1195     }
1196 
1197     /**
1198      * @dev See {IERC721-transferFrom}.
1199      */
1200     function transferFrom(
1201         address from,
1202         address to,
1203         uint256 tokenId
1204     ) public virtual override {
1205         _transfer(from, to, tokenId);
1206     }
1207 
1208     /**
1209      * @dev See {IERC721-safeTransferFrom}.
1210      */
1211     function safeTransferFrom(
1212         address from,
1213         address to,
1214         uint256 tokenId
1215     ) public virtual override {
1216         safeTransferFrom(from, to, tokenId, "");
1217     }
1218 
1219     /**
1220      * @dev See {IERC721-safeTransferFrom}.
1221      */
1222     function safeTransferFrom(
1223         address from,
1224         address to,
1225         uint256 tokenId,
1226         bytes memory _data
1227     ) public override {
1228         _transfer(from, to, tokenId);
1229         require(
1230             _checkOnERC721Received(from, to, tokenId, _data),
1231             "ERC721A: transfer to non ERC721Receiver implementer"
1232         );
1233     }
1234 
1235     /**
1236      * @dev Returns whether `tokenId` exists.
1237      *
1238      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1239      *
1240      * Tokens start existing when they are minted (`_mint`),
1241      */
1242     function _exists(uint256 tokenId) internal view returns (bool) {
1243         return tokenId < currentIndex;
1244     }
1245 
1246     function _safeMint(address to, uint256 quantity) internal {
1247         _safeMint(to, quantity, "");
1248     }
1249 
1250     /**
1251      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1252      *
1253      * Requirements:
1254      *
1255      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1256      * - `quantity` must be greater than 0.
1257      *
1258      * Emits a {Transfer} event.
1259      */
1260     function _safeMint(
1261         address to,
1262         uint256 quantity,
1263         bytes memory _data
1264     ) internal {
1265         _mint(to, quantity, _data, true);
1266     }
1267 
1268     /**
1269      * @dev Mints `quantity` tokens and transfers them to `to`.
1270      *
1271      * Requirements:
1272      *
1273      * - `to` cannot be the zero address.
1274      * - `quantity` must be greater than 0.
1275      *
1276      * Emits a {Transfer} event.
1277      */
1278     function _mint(
1279         address to,
1280         uint256 quantity,
1281         bytes memory _data,
1282         bool safe
1283     ) internal {
1284         uint256 startTokenId = currentIndex;
1285         require(to != address(0), "ERC721A: mint to the zero address");
1286         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1287 
1288         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1289 
1290         // Overflows are incredibly unrealistic.
1291         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1292         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1293         unchecked {
1294             _addressData[to].balance += uint128(quantity);
1295             _addressData[to].numberMinted += uint128(quantity);
1296 
1297             _ownerships[startTokenId].addr = to;
1298             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1299 
1300             uint256 updatedIndex = startTokenId;
1301 
1302             for (uint256 i; i < quantity; i++) {
1303                 emit Transfer(address(0), to, updatedIndex);
1304                 if (safe) {
1305                     require(
1306                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1307                         "ERC721A: transfer to non ERC721Receiver implementer"
1308                     );
1309                 }
1310 
1311                 updatedIndex++;
1312             }
1313 
1314             currentIndex = updatedIndex;
1315         }
1316 
1317         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1318     }
1319 
1320     /**
1321      * @dev Transfers `tokenId` from `from` to `to`.
1322      *
1323      * Requirements:
1324      *
1325      * - `to` cannot be the zero address.
1326      * - `tokenId` token must be owned by `from`.
1327      *
1328      * Emits a {Transfer} event.
1329      */
1330     function _transfer(
1331         address from,
1332         address to,
1333         uint256 tokenId
1334     ) private {
1335         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1336 
1337         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1338             getApproved(tokenId) == _msgSender() ||
1339             isApprovedForAll(prevOwnership.addr, _msgSender()));
1340 
1341         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1342 
1343         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1344         require(to != address(0), "ERC721A: transfer to the zero address");
1345 
1346         _beforeTokenTransfers(from, to, tokenId, 1);
1347 
1348         // Clear approvals from the previous owner
1349         _approve(address(0), tokenId, prevOwnership.addr);
1350 
1351         // Underflow of the sender's balance is impossible because we check for
1352         // ownership above and the recipient's balance can't realistically overflow.
1353         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1354         unchecked {
1355             _addressData[from].balance -= 1;
1356             _addressData[to].balance += 1;
1357 
1358             _ownerships[tokenId].addr = to;
1359             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1360 
1361             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1362             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1363             uint256 nextTokenId = tokenId + 1;
1364             if (_ownerships[nextTokenId].addr == address(0)) {
1365                 if (_exists(nextTokenId)) {
1366                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1367                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1368                 }
1369             }
1370         }
1371 
1372         emit Transfer(from, to, tokenId);
1373         _afterTokenTransfers(from, to, tokenId, 1);
1374     }
1375 
1376     /**
1377      * @dev Approve `to` to operate on `tokenId`
1378      *
1379      * Emits a {Approval} event.
1380      */
1381     function _approve(
1382         address to,
1383         uint256 tokenId,
1384         address owner
1385     ) private {
1386         _tokenApprovals[tokenId] = to;
1387         emit Approval(owner, to, tokenId);
1388     }
1389 
1390     /**
1391      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1392      * The call is not executed if the target address is not a contract.
1393      *
1394      * @param from address representing the previous owner of the given token ID
1395      * @param to target address that will receive the tokens
1396      * @param tokenId uint256 ID of the token to be transferred
1397      * @param _data bytes optional data to send along with the call
1398      * @return bool whether the call correctly returned the expected magic value
1399      */
1400     function _checkOnERC721Received(
1401         address from,
1402         address to,
1403         uint256 tokenId,
1404         bytes memory _data
1405     ) private returns (bool) {
1406         if (to.isContract()) {
1407             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1408                 return retval == IERC721Receiver(to).onERC721Received.selector;
1409             } catch (bytes memory reason) {
1410                 if (reason.length == 0) {
1411                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1412                 } else {
1413                     assembly {
1414                         revert(add(32, reason), mload(reason))
1415                     }
1416                 }
1417             }
1418         } else {
1419             return true;
1420         }
1421     }
1422 
1423     /**
1424      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1425      *
1426      * startTokenId - the first token id to be transferred
1427      * quantity - the amount to be transferred
1428      *
1429      * Calling conditions:
1430      *
1431      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1432      * transferred to `to`.
1433      * - When `from` is zero, `tokenId` will be minted for `to`.
1434      */
1435     function _beforeTokenTransfers(
1436         address from,
1437         address to,
1438         uint256 startTokenId,
1439         uint256 quantity
1440     ) internal virtual {}
1441 
1442     /**
1443      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1444      * minting.
1445      *
1446      * startTokenId - the first token id to be transferred
1447      * quantity - the amount to be transferred
1448      *
1449      * Calling conditions:
1450      *
1451      * - when `from` and `to` are both non-zero.
1452      * - `from` and `to` are never both zero.
1453      */
1454     function _afterTokenTransfers(
1455         address from,
1456         address to,
1457         uint256 startTokenId,
1458         uint256 quantity
1459     ) internal virtual {}
1460 }
1461 
1462 contract WZRDS is ERC721A, Ownable, ReentrancyGuard {
1463 
1464   uint public price = 0.005 ether;
1465   uint public maxPerTx = 5;
1466   uint public maxPerTxDuringFree = 2;
1467   uint public totalFree = 5000;
1468   uint public maxSupply = 10000;
1469   bool public mintEnabled;
1470    string public baseURI;
1471 
1472 
1473   constructor() ERC721A("WZRDS", "WZRDS"){
1474   }
1475 
1476   function mint(uint256 amount) external payable
1477   {
1478     uint cost = price;
1479 
1480     if(totalSupply() + amount < totalFree + 1) {
1481       cost = 0;
1482       require(amount < maxPerTxDuringFree + 1, "Max per TX reached");
1483     }
1484     require(mintEnabled, "Minting is not live yet, hold on WZRD");
1485     require(totalSupply() + amount < maxSupply + 1,"No more WZRDS");
1486     require(msg.value == amount * cost,"Please send the exact amount");
1487     require(amount < maxPerTx + 1, "Max per TX reached");
1488     
1489     _safeMint(msg.sender, amount);
1490   }
1491 
1492   function ownerBatchMint(uint256 amount) external onlyOwner
1493   {
1494     require(totalSupply() + amount < maxSupply + 1,"too many!");
1495 
1496     _safeMint(msg.sender, amount);
1497   }
1498 
1499   function toggleMinting() external onlyOwner {
1500       mintEnabled = !mintEnabled;
1501   }
1502 
1503   function numberMinted(address owner) public view returns (uint256) {
1504     return _numberMinted(owner);
1505   }
1506 
1507   function setBaseURI(string calldata baseURI_) external onlyOwner {
1508     baseURI = baseURI_;
1509   }
1510 
1511   function setPrice(uint256 price_) external onlyOwner {
1512       price = price_;
1513   }
1514 
1515   function setTotalFree(uint256 totalFree_) external onlyOwner {
1516       totalFree = totalFree_;
1517   }
1518 
1519   function setMaxPerTx(uint256 maxPerTx_) external onlyOwner {
1520       maxPerTx = maxPerTx_;
1521   }
1522 
1523   function _baseURI() internal view virtual override returns (string memory) {
1524     return baseURI;
1525   }
1526 
1527   function withdraw() external onlyOwner nonReentrant {
1528     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1529     require(success, "Transfer failed.");
1530   }
1531 
1532 }