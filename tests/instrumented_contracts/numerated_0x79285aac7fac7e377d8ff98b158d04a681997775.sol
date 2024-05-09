1 /**                                                                                                   
2                       :^^^~~:^.                    
3                    !?~::::..^^~!^.                
4                  !J^           .^?7.              
5                .5!.        .    ..:7?:            
6               :Y:               ^!: .7?.          
7              ^5.       .         .    .?7         
8             ^5.  .                      ^Y:       
9          :!~^.                 .         :5^      
10       .~7~.                         .     .?~     
11     .7!:     .77.          :~:^7.           ?7    
12    !J.       .J7.          !GJ^.             ?~   
13   !J    .:~^^.    :?!!!~. ^J~             .  .5.  
14  .P. . .Y?!~!J7.  ~57!?Y !J.                  7?  
15  .P.   7P:::::5!   ..::.!J              .     .P  
16   ~Y:  ^P!^^:~P^        Y!                    .5. 
17    .?!. :77?77^         ~5.                   .5: 
18      :!?^   .            ^?7^..               .5. 
19        7!      .        .  .~!!7!.            ^Y  
20        5.    .                 ...        .!^ Y^  
21       .P..7^   .                        . .7.~J   
22        P. .:          :J :^           .     ~Y    
23        !Y:.  ....:^~~~75 ..        .     .:77     
24         :!~~~!~~^::.  .5:            .:~!!^.      
25                        :J^:::..::^^~~!^.          
26                          .:^^^^^^:.                                                   
27 */
28 
29 // SPDX-License-Identifier: MIT
30 
31 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
32 
33 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev Interface of the ERC20 standard as defined in the EIP.
39  */
40 interface IERC20 {
41     /**
42      * @dev Returns the amount of tokens in existence.
43      */
44     function totalSupply() external view returns (uint256);
45 
46     /**
47      * @dev Returns the amount of tokens owned by `account`.
48      */
49     function balanceOf(address account) external view returns (uint256);
50 
51     /**
52      * @dev Moves `amount` tokens from the caller's account to `to`.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * Emits a {Transfer} event.
57      */
58     function transfer(address to, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Returns the remaining number of tokens that `spender` will be
62      * allowed to spend on behalf of `owner` through {transferFrom}. This is
63      * zero by default.
64      *
65      * This value changes when {approve} or {transferFrom} are called.
66      */
67     function allowance(address owner, address spender) external view returns (uint256);
68 
69     /**
70      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * IMPORTANT: Beware that changing an allowance with this method brings the risk
75      * that someone may use both the old and the new allowance by unfortunate
76      * transaction ordering. One possible solution to mitigate this race
77      * condition is to first reduce the spender's allowance to 0 and set the
78      * desired value afterwards:
79      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
80      *
81      * Emits an {Approval} event.
82      */
83     function approve(address spender, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Moves `amount` tokens from `from` to `to` using the
87      * allowance mechanism. `amount` is then deducted from the caller's
88      * allowance.
89      *
90      * Returns a boolean value indicating whether the operation succeeded.
91      *
92      * Emits a {Transfer} event.
93      */
94     function transferFrom(
95         address from,
96         address to,
97         uint256 amount
98     ) external returns (bool);
99 
100     /**
101      * @dev Emitted when `value` tokens are moved from one account (`from`) to
102      * another (`to`).
103      *
104      * Note that `value` may be zero.
105      */
106     event Transfer(address indexed from, address indexed to, uint256 value);
107 
108     /**
109      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
110      * a call to {approve}. `value` is the new allowance.
111      */
112     event Approval(address indexed owner, address indexed spender, uint256 value);
113 }
114 
115 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
116 
117 
118 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
119 
120 pragma solidity ^0.8.0;
121 
122 /**
123  * @dev Contract module that helps prevent reentrant calls to a function.
124  *
125  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
126  * available, which can be applied to functions to make sure there are no nested
127  * (reentrant) calls to them.
128  *
129  * Note that because there is a single `nonReentrant` guard, functions marked as
130  * `nonReentrant` may not call one another. This can be worked around by making
131  * those functions `private`, and then adding `external` `nonReentrant` entry
132  * points to them.
133  *
134  * TIP: If you would like to learn more about reentrancy and alternative ways
135  * to protect against it, check out our blog post
136  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
137  */
138 abstract contract ReentrancyGuard {
139     // Booleans are more expensive than uint256 or any type that takes up a full
140     // word because each write operation emits an extra SLOAD to first read the
141     // slot's contents, replace the bits taken up by the boolean, and then write
142     // back. This is the compiler's defense against contract upgrades and
143     // pointer aliasing, and it cannot be disabled.
144 
145     // The values being non-zero value makes deployment a bit more expensive,
146     // but in exchange the refund on every call to nonReentrant will be lower in
147     // amount. Since refunds are capped to a percentage of the total
148     // transaction's gas, it is best to keep them low in cases like this one, to
149     // increase the likelihood of the full refund coming into effect.
150     uint256 private constant _NOT_ENTERED = 1;
151     uint256 private constant _ENTERED = 2;
152 
153     uint256 private _status;
154 
155     constructor() {
156         _status = _NOT_ENTERED;
157     }
158 
159     /**
160      * @dev Prevents a contract from calling itself, directly or indirectly.
161      * Calling a `nonReentrant` function from another `nonReentrant`
162      * function is not supported. It is possible to prevent this from happening
163      * by making the `nonReentrant` function external, and making it call a
164      * `private` function that does the actual work.
165      */
166     modifier nonReentrant() {
167         // On the first call to nonReentrant, _notEntered will be true
168         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
169 
170         // Any calls to nonReentrant after this point will fail
171         _status = _ENTERED;
172 
173         _;
174 
175         // By storing the original value once again, a refund is triggered (see
176         // https://eips.ethereum.org/EIPS/eip-2200)
177         _status = _NOT_ENTERED;
178     }
179 }
180 
181 // File: @openzeppelin/contracts/utils/Strings.sol
182 
183 
184 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
185 
186 pragma solidity ^0.8.0;
187 
188 /**
189  * @dev String operations.
190  */
191 library Strings {
192     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
193 
194     /**
195      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
196      */
197     function toString(uint256 value) internal pure returns (string memory) {
198         // Inspired by OraclizeAPI's implementation - MIT licence
199         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
200 
201         if (value == 0) {
202             return "0";
203         }
204         uint256 temp = value;
205         uint256 digits;
206         while (temp != 0) {
207             digits++;
208             temp /= 10;
209         }
210         bytes memory buffer = new bytes(digits);
211         while (value != 0) {
212             digits -= 1;
213             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
214             value /= 10;
215         }
216         return string(buffer);
217     }
218 
219     /**
220      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
221      */
222     function toHexString(uint256 value) internal pure returns (string memory) {
223         if (value == 0) {
224             return "0x00";
225         }
226         uint256 temp = value;
227         uint256 length = 0;
228         while (temp != 0) {
229             length++;
230             temp >>= 8;
231         }
232         return toHexString(value, length);
233     }
234 
235     /**
236      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
237      */
238     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
239         bytes memory buffer = new bytes(2 * length + 2);
240         buffer[0] = "0";
241         buffer[1] = "x";
242         for (uint256 i = 2 * length + 1; i > 1; --i) {
243             buffer[i] = _HEX_SYMBOLS[value & 0xf];
244             value >>= 4;
245         }
246         require(value == 0, "Strings: hex length insufficient");
247         return string(buffer);
248     }
249 }
250 
251 // File: @openzeppelin/contracts/utils/Context.sol
252 
253 
254 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
255 
256 pragma solidity ^0.8.0;
257 
258 /**
259  * @dev Provides information about the current execution context, including the
260  * sender of the transaction and its data. While these are generally available
261  * via msg.sender and msg.data, they should not be accessed in such a direct
262  * manner, since when dealing with meta-transactions the account sending and
263  * paying for execution may not be the actual sender (as far as an application
264  * is concerned).
265  *
266  * This contract is only required for intermediate, library-like contracts.
267  */
268 abstract contract Context {
269     function _msgSender() internal view virtual returns (address) {
270         return msg.sender;
271     }
272 
273     function _msgData() internal view virtual returns (bytes calldata) {
274         return msg.data;
275     }
276 }
277 
278 // File: @openzeppelin/contracts/access/Ownable.sol
279 
280 
281 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
282 
283 pragma solidity ^0.8.0;
284 
285 
286 /**
287  * @dev Contract module which provides a basic access control mechanism, where
288  * there is an account (an owner) that can be granted exclusive access to
289  * specific functions.
290  *
291  * By default, the owner account will be the one that deploys the contract. This
292  * can later be changed with {transferOwnership}.
293  *
294  * This module is used through inheritance. It will make available the modifier
295  * `onlyOwner`, which can be applied to your functions to restrict their use to
296  * the owner.
297  */
298 abstract contract Ownable is Context {
299     address private _owner;
300 
301     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
302 
303     /**
304      * @dev Initializes the contract setting the deployer as the initial owner.
305      */
306     constructor() {
307         _transferOwnership(_msgSender());
308     }
309 
310     /**
311      * @dev Returns the address of the current owner.
312      */
313     function owner() public view virtual returns (address) {
314         return _owner;
315     }
316 
317     /**
318      * @dev Throws if called by any account other than the owner.
319      */
320     modifier onlyOwner() {
321         require(owner() == _msgSender(), "Ownable: caller is not the owner");
322         _;
323     }
324 
325     /**
326      * @dev Leaves the contract without owner. It will not be possible to call
327      * `onlyOwner` functions anymore. Can only be called by the current owner.
328      *
329      * NOTE: Renouncing ownership will leave the contract without an owner,
330      * thereby removing any functionality that is only available to the owner.
331      */
332     function renounceOwnership() public virtual onlyOwner {
333         _transferOwnership(address(0));
334     }
335 
336     /**
337      * @dev Transfers ownership of the contract to a new account (`newOwner`).
338      * Can only be called by the current owner.
339      */
340     function transferOwnership(address newOwner) public virtual onlyOwner {
341         require(newOwner != address(0), "Ownable: new owner is the zero address");
342         _transferOwnership(newOwner);
343     }
344 
345     /**
346      * @dev Transfers ownership of the contract to a new account (`newOwner`).
347      * Internal function without access restriction.
348      */
349     function _transferOwnership(address newOwner) internal virtual {
350         address oldOwner = _owner;
351         _owner = newOwner;
352         emit OwnershipTransferred(oldOwner, newOwner);
353     }
354 }
355 
356 // File: @openzeppelin/contracts/utils/Address.sol
357 
358 
359 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
360 
361 pragma solidity ^0.8.1;
362 
363 /**
364  * @dev Collection of functions related to the address type
365  */
366 library Address {
367     /**
368      * @dev Returns true if `account` is a contract.
369      *
370      * [IMPORTANT]
371      * ====
372      * It is unsafe to assume that an address for which this function returns
373      * false is an externally-owned account (EOA) and not a contract.
374      *
375      * Among others, `isContract` will return false for the following
376      * types of addresses:
377      *
378      *  - an externally-owned account
379      *  - a contract in construction
380      *  - an address where a contract will be created
381      *  - an address where a contract lived, but was destroyed
382      * ====
383      *
384      * [IMPORTANT]
385      * ====
386      * You shouldn't rely on `isContract` to protect against flash loan attacks!
387      *
388      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
389      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
390      * constructor.
391      * ====
392      */
393     function isContract(address account) internal view returns (bool) {
394         // This method relies on extcodesize/address.code.length, which returns 0
395         // for contracts in construction, since the code is only stored at the end
396         // of the constructor execution.
397 
398         return account.code.length > 0;
399     }
400 
401     /**
402      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
403      * `recipient`, forwarding all available gas and reverting on errors.
404      *
405      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
406      * of certain opcodes, possibly making contracts go over the 2300 gas limit
407      * imposed by `transfer`, making them unable to receive funds via
408      * `transfer`. {sendValue} removes this limitation.
409      *
410      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
411      *
412      * IMPORTANT: because control is transferred to `recipient`, care must be
413      * taken to not create reentrancy vulnerabilities. Consider using
414      * {ReentrancyGuard} or the
415      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
416      */
417     function sendValue(address payable recipient, uint256 amount) internal {
418         require(address(this).balance >= amount, "Address: insufficient balance");
419 
420         (bool success, ) = recipient.call{value: amount}("");
421         require(success, "Address: unable to send value, recipient may have reverted");
422     }
423 
424     /**
425      * @dev Performs a Solidity function call using a low level `call`. A
426      * plain `call` is an unsafe replacement for a function call: use this
427      * function instead.
428      *
429      * If `target` reverts with a revert reason, it is bubbled up by this
430      * function (like regular Solidity function calls).
431      *
432      * Returns the raw returned data. To convert to the expected return value,
433      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
434      *
435      * Requirements:
436      *
437      * - `target` must be a contract.
438      * - calling `target` with `data` must not revert.
439      *
440      * _Available since v3.1._
441      */
442     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
443         return functionCall(target, data, "Address: low-level call failed");
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
448      * `errorMessage` as a fallback revert reason when `target` reverts.
449      *
450      * _Available since v3.1._
451      */
452     function functionCall(
453         address target,
454         bytes memory data,
455         string memory errorMessage
456     ) internal returns (bytes memory) {
457         return functionCallWithValue(target, data, 0, errorMessage);
458     }
459 
460     /**
461      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
462      * but also transferring `value` wei to `target`.
463      *
464      * Requirements:
465      *
466      * - the calling contract must have an ETH balance of at least `value`.
467      * - the called Solidity function must be `payable`.
468      *
469      * _Available since v3.1._
470      */
471     function functionCallWithValue(
472         address target,
473         bytes memory data,
474         uint256 value
475     ) internal returns (bytes memory) {
476         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
481      * with `errorMessage` as a fallback revert reason when `target` reverts.
482      *
483      * _Available since v3.1._
484      */
485     function functionCallWithValue(
486         address target,
487         bytes memory data,
488         uint256 value,
489         string memory errorMessage
490     ) internal returns (bytes memory) {
491         require(address(this).balance >= value, "Address: insufficient balance for call");
492         require(isContract(target), "Address: call to non-contract");
493 
494         (bool success, bytes memory returndata) = target.call{value: value}(data);
495         return verifyCallResult(success, returndata, errorMessage);
496     }
497 
498     /**
499      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
500      * but performing a static call.
501      *
502      * _Available since v3.3._
503      */
504     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
505         return functionStaticCall(target, data, "Address: low-level static call failed");
506     }
507 
508     /**
509      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
510      * but performing a static call.
511      *
512      * _Available since v3.3._
513      */
514     function functionStaticCall(
515         address target,
516         bytes memory data,
517         string memory errorMessage
518     ) internal view returns (bytes memory) {
519         require(isContract(target), "Address: static call to non-contract");
520 
521         (bool success, bytes memory returndata) = target.staticcall(data);
522         return verifyCallResult(success, returndata, errorMessage);
523     }
524 
525     /**
526      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
527      * but performing a delegate call.
528      *
529      * _Available since v3.4._
530      */
531     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
532         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
533     }
534 
535     /**
536      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
537      * but performing a delegate call.
538      *
539      * _Available since v3.4._
540      */
541     function functionDelegateCall(
542         address target,
543         bytes memory data,
544         string memory errorMessage
545     ) internal returns (bytes memory) {
546         require(isContract(target), "Address: delegate call to non-contract");
547 
548         (bool success, bytes memory returndata) = target.delegatecall(data);
549         return verifyCallResult(success, returndata, errorMessage);
550     }
551 
552     /**
553      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
554      * revert reason using the provided one.
555      *
556      * _Available since v4.3._
557      */
558     function verifyCallResult(
559         bool success,
560         bytes memory returndata,
561         string memory errorMessage
562     ) internal pure returns (bytes memory) {
563         if (success) {
564             return returndata;
565         } else {
566             // Look for revert reason and bubble it up if present
567             if (returndata.length > 0) {
568                 // The easiest way to bubble the revert reason is using memory via assembly
569 
570                 assembly {
571                     let returndata_size := mload(returndata)
572                     revert(add(32, returndata), returndata_size)
573                 }
574             } else {
575                 revert(errorMessage);
576             }
577         }
578     }
579 }
580 
581 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
582 
583 
584 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
585 
586 pragma solidity ^0.8.0;
587 
588 
589 
590 /**
591  * @title SafeERC20
592  * @dev Wrappers around ERC20 operations that throw on failure (when the token
593  * contract returns false). Tokens that return no value (and instead revert or
594  * throw on failure) are also supported, non-reverting calls are assumed to be
595  * successful.
596  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
597  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
598  */
599 library SafeERC20 {
600     using Address for address;
601 
602     function safeTransfer(
603         IERC20 token,
604         address to,
605         uint256 value
606     ) internal {
607         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
608     }
609 
610     function safeTransferFrom(
611         IERC20 token,
612         address from,
613         address to,
614         uint256 value
615     ) internal {
616         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
617     }
618 
619     /**
620      * @dev Deprecated. This function has issues similar to the ones found in
621      * {IERC20-approve}, and its usage is discouraged.
622      *
623      * Whenever possible, use {safeIncreaseAllowance} and
624      * {safeDecreaseAllowance} instead.
625      */
626     function safeApprove(
627         IERC20 token,
628         address spender,
629         uint256 value
630     ) internal {
631         // safeApprove should only be called when setting an initial allowance,
632         // or when resetting it to zero. To increase and decrease it, use
633         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
634         require(
635             (value == 0) || (token.allowance(address(this), spender) == 0),
636             "SafeERC20: approve from non-zero to non-zero allowance"
637         );
638         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
639     }
640 
641     function safeIncreaseAllowance(
642         IERC20 token,
643         address spender,
644         uint256 value
645     ) internal {
646         uint256 newAllowance = token.allowance(address(this), spender) + value;
647         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
648     }
649 
650     function safeDecreaseAllowance(
651         IERC20 token,
652         address spender,
653         uint256 value
654     ) internal {
655         unchecked {
656             uint256 oldAllowance = token.allowance(address(this), spender);
657             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
658             uint256 newAllowance = oldAllowance - value;
659             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
660         }
661     }
662 
663     /**
664      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
665      * on the return value: the return value is optional (but if data is returned, it must not be false).
666      * @param token The token targeted by the call.
667      * @param data The call data (encoded using abi.encode or one of its variants).
668      */
669     function _callOptionalReturn(IERC20 token, bytes memory data) private {
670         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
671         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
672         // the target address contains contract code and also asserts for success in the low-level call.
673 
674         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
675         if (returndata.length > 0) {
676             // Return data is optional
677             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
678         }
679     }
680 }
681 
682 
683 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
684 
685 
686 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
687 
688 pragma solidity ^0.8.0;
689 
690 /**
691  * @title ERC721 token receiver interface
692  * @dev Interface for any contract that wants to support safeTransfers
693  * from ERC721 asset contracts.
694  */
695 interface IERC721Receiver {
696     /**
697      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
698      * by `operator` from `from`, this function is called.
699      *
700      * It must return its Solidity selector to confirm the token transfer.
701      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
702      *
703      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
704      */
705     function onERC721Received(
706         address operator,
707         address from,
708         uint256 tokenId,
709         bytes calldata data
710     ) external returns (bytes4);
711 }
712 
713 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
714 
715 
716 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
717 
718 pragma solidity ^0.8.0;
719 
720 /**
721  * @dev Interface of the ERC165 standard, as defined in the
722  * https://eips.ethereum.org/EIPS/eip-165[EIP].
723  *
724  * Implementers can declare support of contract interfaces, which can then be
725  * queried by others ({ERC165Checker}).
726  *
727  * For an implementation, see {ERC165}.
728  */
729 interface IERC165 {
730     /**
731      * @dev Returns true if this contract implements the interface defined by
732      * `interfaceId`. See the corresponding
733      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
734      * to learn more about how these ids are created.
735      *
736      * This function call must use less than 30 000 gas.
737      */
738     function supportsInterface(bytes4 interfaceId) external view returns (bool);
739 }
740 
741 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
742 
743 
744 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
745 
746 pragma solidity ^0.8.0;
747 
748 
749 /**
750  * @dev Implementation of the {IERC165} interface.
751  *
752  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
753  * for the additional interface id that will be supported. For example:
754  *
755  * ```solidity
756  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
757  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
758  * }
759  * ```
760  *
761  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
762  */
763 abstract contract ERC165 is IERC165 {
764     /**
765      * @dev See {IERC165-supportsInterface}.
766      */
767     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
768         return interfaceId == type(IERC165).interfaceId;
769     }
770 }
771 
772 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
773 
774 
775 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
776 
777 pragma solidity ^0.8.0;
778 
779 
780 /**
781  * @dev Required interface of an ERC721 compliant contract.
782  */
783 interface IERC721 is IERC165 {
784     /**
785      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
786      */
787     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
788 
789     /**
790      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
791      */
792     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
793 
794     /**
795      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
796      */
797     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
798 
799     /**
800      * @dev Returns the number of tokens in ``owner``'s account.
801      */
802     function balanceOf(address owner) external view returns (uint256 balance);
803 
804     /**
805      * @dev Returns the owner of the `tokenId` token.
806      *
807      * Requirements:
808      *
809      * - `tokenId` must exist.
810      */
811     function ownerOf(uint256 tokenId) external view returns (address owner);
812 
813     /**
814      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
815      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
816      *
817      * Requirements:
818      *
819      * - `from` cannot be the zero address.
820      * - `to` cannot be the zero address.
821      * - `tokenId` token must exist and be owned by `from`.
822      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
823      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
824      *
825      * Emits a {Transfer} event.
826      */
827     function safeTransferFrom(
828         address from,
829         address to,
830         uint256 tokenId
831     ) external;
832 
833     /**
834      * @dev Transfers `tokenId` token from `from` to `to`.
835      *
836      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
837      *
838      * Requirements:
839      *
840      * - `from` cannot be the zero address.
841      * - `to` cannot be the zero address.
842      * - `tokenId` token must be owned by `from`.
843      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
844      *
845      * Emits a {Transfer} event.
846      */
847     function transferFrom(
848         address from,
849         address to,
850         uint256 tokenId
851     ) external;
852 
853     /**
854      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
855      * The approval is cleared when the token is transferred.
856      *
857      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
858      *
859      * Requirements:
860      *
861      * - The caller must own the token or be an approved operator.
862      * - `tokenId` must exist.
863      *
864      * Emits an {Approval} event.
865      */
866     function approve(address to, uint256 tokenId) external;
867 
868     /**
869      * @dev Returns the account approved for `tokenId` token.
870      *
871      * Requirements:
872      *
873      * - `tokenId` must exist.
874      */
875     function getApproved(uint256 tokenId) external view returns (address operator);
876 
877     /**
878      * @dev Approve or remove `operator` as an operator for the caller.
879      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
880      *
881      * Requirements:
882      *
883      * - The `operator` cannot be the caller.
884      *
885      * Emits an {ApprovalForAll} event.
886      */
887     function setApprovalForAll(address operator, bool _approved) external;
888 
889     /**
890      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
891      *
892      * See {setApprovalForAll}
893      */
894     function isApprovedForAll(address owner, address operator) external view returns (bool);
895 
896     /**
897      * @dev Safely transfers `tokenId` token from `from` to `to`.
898      *
899      * Requirements:
900      *
901      * - `from` cannot be the zero address.
902      * - `to` cannot be the zero address.
903      * - `tokenId` token must exist and be owned by `from`.
904      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
905      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
906      *
907      * Emits a {Transfer} event.
908      */
909     function safeTransferFrom(
910         address from,
911         address to,
912         uint256 tokenId,
913         bytes calldata data
914     ) external;
915 }
916 
917 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
918 
919 
920 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
921 
922 pragma solidity ^0.8.0;
923 
924 
925 /**
926  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
927  * @dev See https://eips.ethereum.org/EIPS/eip-721
928  */
929 interface IERC721Enumerable is IERC721 {
930     /**
931      * @dev Returns the total amount of tokens stored by the contract.
932      */
933     function totalSupply() external view returns (uint256);
934 
935     /**
936      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
937      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
938      */
939     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
940 
941     /**
942      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
943      * Use along with {totalSupply} to enumerate all tokens.
944      */
945     function tokenByIndex(uint256 index) external view returns (uint256);
946 }
947 
948 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
949 
950 
951 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
952 
953 pragma solidity ^0.8.0;
954 
955 
956 /**
957  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
958  * @dev See https://eips.ethereum.org/EIPS/eip-721
959  */
960 interface IERC721Metadata is IERC721 {
961     /**
962      * @dev Returns the token collection name.
963      */
964     function name() external view returns (string memory);
965 
966     /**
967      * @dev Returns the token collection symbol.
968      */
969     function symbol() external view returns (string memory);
970 
971     /**
972      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
973      */
974     function tokenURI(uint256 tokenId) external view returns (string memory);
975 }
976 
977 // File: contracts/TwistedToonz.sol
978 
979 
980 // Creator: Chiru Labs
981 
982 pragma solidity ^0.8.0;
983 
984 
985 
986 
987 
988 
989 
990 
991 
992 /**
993  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
994  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
995  *
996  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
997  *
998  * Does not support burning tokens to address(0).
999  *
1000  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
1001  */
1002 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1003     using Address for address;
1004     using Strings for uint256;
1005 
1006     struct TokenOwnership {
1007         address addr;
1008         uint64 startTimestamp;
1009     }
1010 
1011     struct AddressData {
1012         uint128 balance;
1013         uint128 numberMinted;
1014     }
1015 
1016     uint256 internal currentIndex;
1017 
1018     // Token name
1019     string private _name;
1020 
1021     // Token symbol
1022     string private _symbol;
1023 
1024     // Mapping from token ID to ownership details
1025     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1026     mapping(uint256 => TokenOwnership) internal _ownerships;
1027 
1028     // Mapping owner address to address data
1029     mapping(address => AddressData) private _addressData;
1030 
1031     // Mapping from token ID to approved address
1032     mapping(uint256 => address) private _tokenApprovals;
1033 
1034     // Mapping from owner to operator approvals
1035     mapping(address => mapping(address => bool)) private _operatorApprovals;
1036 
1037     constructor(string memory name_, string memory symbol_) {
1038         _name = name_;
1039         _symbol = symbol_;
1040     }
1041 
1042     /**
1043      * @dev See {IERC721Enumerable-totalSupply}.
1044      */
1045     function totalSupply() public view override returns (uint256) {
1046         return currentIndex;
1047     }
1048 
1049     /**
1050      * @dev See {IERC721Enumerable-tokenByIndex}.
1051      */
1052     function tokenByIndex(uint256 index) public view override returns (uint256) {
1053         require(index < totalSupply(), "ERC721A: global index out of bounds");
1054         return index;
1055     }
1056 
1057     /**
1058      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1059      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1060      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1061      */
1062     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1063         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1064         uint256 numMintedSoFar = totalSupply();
1065         uint256 tokenIdsIdx;
1066         address currOwnershipAddr;
1067 
1068         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1069         unchecked {
1070             for (uint256 i; i < numMintedSoFar; i++) {
1071                 TokenOwnership memory ownership = _ownerships[i];
1072                 if (ownership.addr != address(0)) {
1073                     currOwnershipAddr = ownership.addr;
1074                 }
1075                 if (currOwnershipAddr == owner) {
1076                     if (tokenIdsIdx == index) {
1077                         return i;
1078                     }
1079                     tokenIdsIdx++;
1080                 }
1081             }
1082         }
1083 
1084         revert("ERC721A: unable to get token of owner by index");
1085     }
1086 
1087     /**
1088      * @dev See {IERC165-supportsInterface}.
1089      */
1090     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1091         return
1092             interfaceId == type(IERC721).interfaceId ||
1093             interfaceId == type(IERC721Metadata).interfaceId ||
1094             interfaceId == type(IERC721Enumerable).interfaceId ||
1095             super.supportsInterface(interfaceId);
1096     }
1097 
1098     /**
1099      * @dev See {IERC721-balanceOf}.
1100      */
1101     function balanceOf(address owner) public view override returns (uint256) {
1102         require(owner != address(0), "ERC721A: balance query for the zero address");
1103         return uint256(_addressData[owner].balance);
1104     }
1105 
1106     function _numberMinted(address owner) internal view returns (uint256) {
1107         require(owner != address(0), "ERC721A: number minted query for the zero address");
1108         return uint256(_addressData[owner].numberMinted);
1109     }
1110 
1111     /**
1112      * Gas spent here starts off proportional to the maximum mint batch size.
1113      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1114      */
1115     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1116         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1117 
1118         unchecked {
1119             for (uint256 curr = tokenId; curr >= 0; curr--) {
1120                 TokenOwnership memory ownership = _ownerships[curr];
1121                 if (ownership.addr != address(0)) {
1122                     return ownership;
1123                 }
1124             }
1125         }
1126 
1127         revert("ERC721A: unable to determine the owner of token");
1128     }
1129 
1130     /**
1131      * @dev See {IERC721-ownerOf}.
1132      */
1133     function ownerOf(uint256 tokenId) public view override returns (address) {
1134         return ownershipOf(tokenId).addr;
1135     }
1136 
1137     /**
1138      * @dev See {IERC721Metadata-name}.
1139      */
1140     function name() public view virtual override returns (string memory) {
1141         return _name;
1142     }
1143 
1144     /**
1145      * @dev See {IERC721Metadata-symbol}.
1146      */
1147     function symbol() public view virtual override returns (string memory) {
1148         return _symbol;
1149     }
1150 
1151     /**
1152      * @dev See {IERC721Metadata-tokenURI}.
1153      */
1154     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1155         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1156 
1157         string memory baseURI = _baseURI();
1158         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1159     }
1160 
1161     /**
1162      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1163      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1164      * by default, can be overriden in child contracts.
1165      */
1166     function _baseURI() internal view virtual returns (string memory) {
1167         return "";
1168     }
1169 
1170     /**
1171      * @dev See {IERC721-approve}.
1172      */
1173     function approve(address to, uint256 tokenId) public override {
1174         address owner = ERC721A.ownerOf(tokenId);
1175         require(to != owner, "ERC721A: approval to current owner");
1176 
1177         require(
1178             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1179             "ERC721A: approve caller is not owner nor approved for all"
1180         );
1181 
1182         _approve(to, tokenId, owner);
1183     }
1184 
1185     /**
1186      * @dev See {IERC721-getApproved}.
1187      */
1188     function getApproved(uint256 tokenId) public view override returns (address) {
1189         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1190 
1191         return _tokenApprovals[tokenId];
1192     }
1193 
1194     /**
1195      * @dev See {IERC721-setApprovalForAll}.
1196      */
1197     function setApprovalForAll(address operator, bool approved) public override {
1198         require(operator != _msgSender(), "ERC721A: approve to caller");
1199 
1200         _operatorApprovals[_msgSender()][operator] = approved;
1201         emit ApprovalForAll(_msgSender(), operator, approved);
1202     }
1203 
1204     /**
1205      * @dev See {IERC721-isApprovedForAll}.
1206      */
1207     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1208         return _operatorApprovals[owner][operator];
1209     }
1210 
1211     /**
1212      * @dev See {IERC721-transferFrom}.
1213      */
1214     function transferFrom(
1215         address from,
1216         address to,
1217         uint256 tokenId
1218     ) public virtual override {
1219         _transfer(from, to, tokenId);
1220     }
1221 
1222     /**
1223      * @dev See {IERC721-safeTransferFrom}.
1224      */
1225     function safeTransferFrom(
1226         address from,
1227         address to,
1228         uint256 tokenId
1229     ) public virtual override {
1230         safeTransferFrom(from, to, tokenId, "");
1231     }
1232 
1233     /**
1234      * @dev See {IERC721-safeTransferFrom}.
1235      */
1236     function safeTransferFrom(
1237         address from,
1238         address to,
1239         uint256 tokenId,
1240         bytes memory _data
1241     ) public override {
1242         _transfer(from, to, tokenId);
1243         require(
1244             _checkOnERC721Received(from, to, tokenId, _data),
1245             "ERC721A: transfer to non ERC721Receiver implementer"
1246         );
1247     }
1248 
1249     /**
1250      * @dev Returns whether `tokenId` exists.
1251      *
1252      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1253      *
1254      * Tokens start existing when they are minted (`_mint`),
1255      */
1256     function _exists(uint256 tokenId) internal view returns (bool) {
1257         return tokenId < currentIndex;
1258     }
1259 
1260     function _safeMint(address to, uint256 quantity) internal {
1261         _safeMint(to, quantity, "");
1262     }
1263 
1264     /**
1265      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1266      *
1267      * Requirements:
1268      *
1269      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1270      * - `quantity` must be greater than 0.
1271      *
1272      * Emits a {Transfer} event.
1273      */
1274     function _safeMint(
1275         address to,
1276         uint256 quantity,
1277         bytes memory _data
1278     ) internal {
1279         _mint(to, quantity, _data, true);
1280     }
1281 
1282     /**
1283      * @dev Mints `quantity` tokens and transfers them to `to`.
1284      *
1285      * Requirements:
1286      *
1287      * - `to` cannot be the zero address.
1288      * - `quantity` must be greater than 0.
1289      *
1290      * Emits a {Transfer} event.
1291      */
1292     function _mint(
1293         address to,
1294         uint256 quantity,
1295         bytes memory _data,
1296         bool safe
1297     ) internal {
1298         uint256 startTokenId = currentIndex;
1299         require(to != address(0), "ERC721A: mint to the zero address");
1300         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1301 
1302         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1303 
1304         // Overflows are incredibly unrealistic.
1305         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1306         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1307         unchecked {
1308             _addressData[to].balance += uint128(quantity);
1309             _addressData[to].numberMinted += uint128(quantity);
1310 
1311             _ownerships[startTokenId].addr = to;
1312             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1313 
1314             uint256 updatedIndex = startTokenId;
1315 
1316             for (uint256 i; i < quantity; i++) {
1317                 emit Transfer(address(0), to, updatedIndex);
1318                 if (safe) {
1319                     require(
1320                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1321                         "ERC721A: transfer to non ERC721Receiver implementer"
1322                     );
1323                 }
1324 
1325                 updatedIndex++;
1326             }
1327 
1328             currentIndex = updatedIndex;
1329         }
1330 
1331         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1332     }
1333 
1334     /**
1335      * @dev Transfers `tokenId` from `from` to `to`.
1336      *
1337      * Requirements:
1338      *
1339      * - `to` cannot be the zero address.
1340      * - `tokenId` token must be owned by `from`.
1341      *
1342      * Emits a {Transfer} event.
1343      */
1344     function _transfer(
1345         address from,
1346         address to,
1347         uint256 tokenId
1348     ) private {
1349         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1350 
1351         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1352             getApproved(tokenId) == _msgSender() ||
1353             isApprovedForAll(prevOwnership.addr, _msgSender()));
1354 
1355         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1356 
1357         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1358         require(to != address(0), "ERC721A: transfer to the zero address");
1359 
1360         _beforeTokenTransfers(from, to, tokenId, 1);
1361 
1362         // Clear approvals from the previous owner
1363         _approve(address(0), tokenId, prevOwnership.addr);
1364 
1365         // Underflow of the sender's balance is impossible because we check for
1366         // ownership above and the recipient's balance can't realistically overflow.
1367         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1368         unchecked {
1369             _addressData[from].balance -= 1;
1370             _addressData[to].balance += 1;
1371 
1372             _ownerships[tokenId].addr = to;
1373             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1374 
1375             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1376             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1377             uint256 nextTokenId = tokenId + 1;
1378             if (_ownerships[nextTokenId].addr == address(0)) {
1379                 if (_exists(nextTokenId)) {
1380                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1381                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1382                 }
1383             }
1384         }
1385 
1386         emit Transfer(from, to, tokenId);
1387         _afterTokenTransfers(from, to, tokenId, 1);
1388     }
1389 
1390     /**
1391      * @dev Approve `to` to operate on `tokenId`
1392      *
1393      * Emits a {Approval} event.
1394      */
1395     function _approve(
1396         address to,
1397         uint256 tokenId,
1398         address owner
1399     ) private {
1400         _tokenApprovals[tokenId] = to;
1401         emit Approval(owner, to, tokenId);
1402     }
1403 
1404     /**
1405      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1406      * The call is not executed if the target address is not a contract.
1407      *
1408      * @param from address representing the previous owner of the given token ID
1409      * @param to target address that will receive the tokens
1410      * @param tokenId uint256 ID of the token to be transferred
1411      * @param _data bytes optional data to send along with the call
1412      * @return bool whether the call correctly returned the expected magic value
1413      */
1414     function _checkOnERC721Received(
1415         address from,
1416         address to,
1417         uint256 tokenId,
1418         bytes memory _data
1419     ) private returns (bool) {
1420         if (to.isContract()) {
1421             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1422                 return retval == IERC721Receiver(to).onERC721Received.selector;
1423             } catch (bytes memory reason) {
1424                 if (reason.length == 0) {
1425                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1426                 } else {
1427                     assembly {
1428                         revert(add(32, reason), mload(reason))
1429                     }
1430                 }
1431             }
1432         } else {
1433             return true;
1434         }
1435     }
1436 
1437     /**
1438      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1439      *
1440      * startTokenId - the first token id to be transferred
1441      * quantity - the amount to be transferred
1442      *
1443      * Calling conditions:
1444      *
1445      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1446      * transferred to `to`.
1447      * - When `from` is zero, `tokenId` will be minted for `to`.
1448      */
1449     function _beforeTokenTransfers(
1450         address from,
1451         address to,
1452         uint256 startTokenId,
1453         uint256 quantity
1454     ) internal virtual {}
1455 
1456     /**
1457      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1458      * minting.
1459      *
1460      * startTokenId - the first token id to be transferred
1461      * quantity - the amount to be transferred
1462      *
1463      * Calling conditions:
1464      *
1465      * - when `from` and `to` are both non-zero.
1466      * - `from` and `to` are never both zero.
1467      */
1468     function _afterTokenTransfers(
1469         address from,
1470         address to,
1471         uint256 startTokenId,
1472         uint256 quantity
1473     ) internal virtual {}
1474 }
1475 
1476 contract CloudyGirls is ERC721A, Ownable, ReentrancyGuard {
1477 
1478   string public        baseURI;
1479   uint public          price             = 0.005 ether;
1480   uint public          maxPerTx          = 20;
1481   uint public          totalFree         = 1111;
1482   uint public          maxSupply         = 2222;
1483   uint256 public        maxFreePerWallet = 3;
1484   bool public          mintEnabled;
1485   mapping(address => uint256) private _mintedFreeAmount;
1486 
1487   constructor() ERC721A("Cloudy Girls", "CloudyGirls"){
1488   }
1489 
1490   function mint(uint256 amount) external payable
1491   {
1492     uint cost = price;
1493     
1494     bool isFree = ((totalSupply() + amount < totalFree + 1) &&
1495             (_mintedFreeAmount[msg.sender] + amount <= maxFreePerWallet));
1496 
1497     if(isFree) {
1498       cost = 0;
1499     }
1500     require(mintEnabled, "Minting is not live yet, hold on");
1501     require(totalSupply() + amount < maxSupply + 1,"No more");
1502     require(msg.value == amount * cost,"Please send the exact amount");
1503     require(amount < maxPerTx + 1, "Max per TX reached");
1504     
1505     if (isFree) {
1506             _mintedFreeAmount[msg.sender] += amount;
1507         }
1508 
1509     _safeMint(msg.sender, amount);
1510   }
1511 
1512   function ownerBatchMint(uint256 amount) external onlyOwner
1513   {
1514     require(totalSupply() + amount < maxSupply + 1,"too many!");
1515 
1516     _safeMint(msg.sender, amount);
1517   }
1518 
1519   function toggleMinting() external onlyOwner {
1520       mintEnabled = !mintEnabled;
1521   }
1522 
1523   function numberMinted(address owner) public view returns (uint256) {
1524     return _numberMinted(owner);
1525   }
1526 
1527   function setBaseURI(string calldata baseURI_) external onlyOwner {
1528     baseURI = baseURI_;
1529   }
1530 
1531   function setPrice(uint256 price_) external onlyOwner {
1532       price = price_;
1533   }
1534 
1535   function setTotalFree(uint256 totalFree_) external onlyOwner {
1536       totalFree = totalFree_;
1537   }
1538 
1539   function setMaxPerTx(uint256 maxPerTx_) external onlyOwner {
1540       maxPerTx = maxPerTx_;
1541   }
1542 
1543   function _baseURI() internal view virtual override returns (string memory) {
1544     return baseURI;
1545   }
1546 
1547   function withdraw() external onlyOwner nonReentrant {
1548     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1549     require(success, "Transfer failed.");
1550   }
1551 
1552 }