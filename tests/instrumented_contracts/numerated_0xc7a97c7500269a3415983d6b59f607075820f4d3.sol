1 // SPDX-License-Identifier: MIT
2 
3 // .______       __    __    _______   _______  _______ .______          _______.
4 // |   _  \     |  |  |  |  /  _____| /  _____||   ____||   _  \        /       |
5 // |  |_)  |    |  |  |  | |  |  __  |  |  __  |  |__   |  |_)  |      |   (----`
6 // |      /     |  |  |  | |  | |_ | |  | |_ | |   __|  |      /        \   \    
7 // |  |\  \----.|  `--'  | |  |__| | |  |__| | |  |____ |  |\  \----.----)   |   
8 // | _| `._____| \______/   \______|  \______| |_______|| _| `._____|_______/    
9                                                                               
10 
11 // @title Ruggers 
12 // @dev Extends ERC721A
13 
14 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
15 
16 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
17 
18 pragma solidity ^0.8.0;
19 
20 /**
21  * @dev Interface of the ERC20 standard as defined in the EIP.
22  */
23 interface IERC20 {
24     /**
25      * @dev Returns the amount of tokens in existence.
26      */
27     function totalSupply() external view returns (uint256);
28 
29     /**
30      * @dev Returns the amount of tokens owned by `account`.
31      */
32     function balanceOf(address account) external view returns (uint256);
33 
34     /**
35      * @dev Moves `amount` tokens from the caller's account to `to`.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * Emits a {Transfer} event.
40      */
41     function transfer(address to, uint256 amount) external returns (bool);
42 
43     /**
44      * @dev Returns the remaining number of tokens that `spender` will be
45      * allowed to spend on behalf of `owner` through {transferFrom}. This is
46      * zero by default.
47      *
48      * This value changes when {approve} or {transferFrom} are called.
49      */
50     function allowance(address owner, address spender)
51         external
52         view
53         returns (uint256);
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
98     event Approval(
99         address indexed owner,
100         address indexed spender,
101         uint256 value
102     );
103 }
104 
105 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
106 
107 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
108 
109 pragma solidity ^0.8.0;
110 
111 /**
112  * @dev Contract module that helps prevent reentrant calls to a function.
113  *
114  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
115  * available, which can be applied to functions to make sure there are no nested
116  * (reentrant) calls to them.
117  *
118  * Note that because there is a single `nonReentrant` guard, functions marked as
119  * `nonReentrant` may not call one another. This can be worked around by making
120  * those functions `private`, and then adding `external` `nonReentrant` entry
121  * points to them.
122  *
123  * TIP: If you would like to learn more about reentrancy and alternative ways
124  * to protect against it, check out our blog post
125  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
126  */
127 abstract contract ReentrancyGuard {
128     // Booleans are more expensive than uint256 or any type that takes up a full
129     // word because each write operation emits an extra SLOAD to first read the
130     // slot's contents, replace the bits taken up by the boolean, and then write
131     // back. This is the compiler's defense against contract upgrades and
132     // pointer aliasing, and it cannot be disabled.
133 
134     // The values being non-zero value makes deployment a bit more expensive,
135     // but in exchange the refund on every call to nonReentrant will be lower in
136     // amount. Since refunds are capped to a percentage of the total
137     // transaction's gas, it is best to keep them low in cases like this one, to
138     // increase the likelihood of the full refund coming into effect.
139     uint256 private constant _NOT_ENTERED = 1;
140     uint256 private constant _ENTERED = 2;
141 
142     uint256 private _status;
143 
144     constructor() {
145         _status = _NOT_ENTERED;
146     }
147 
148     /**
149      * @dev Prevents a contract from calling itself, directly or indirectly.
150      * Calling a `nonReentrant` function from another `nonReentrant`
151      * function is not supported. It is possible to prevent this from happening
152      * by making the `nonReentrant` function external, and making it call a
153      * `private` function that does the actual work.
154      */
155     modifier nonReentrant() {
156         // On the first call to nonReentrant, _notEntered will be true
157         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
158 
159         // Any calls to nonReentrant after this point will fail
160         _status = _ENTERED;
161 
162         _;
163 
164         // By storing the original value once again, a refund is triggered (see
165         // https://eips.ethereum.org/EIPS/eip-2200)
166         _status = _NOT_ENTERED;
167     }
168 }
169 
170 // File: @openzeppelin/contracts/utils/Strings.sol
171 
172 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
173 
174 pragma solidity ^0.8.0;
175 
176 /**
177  * @dev String operations.
178  */
179 library Strings {
180     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
181 
182     /**
183      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
184      */
185     function toString(uint256 value) internal pure returns (string memory) {
186         // Inspired by OraclizeAPI's implementation - MIT licence
187         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
188 
189         if (value == 0) {
190             return "0";
191         }
192         uint256 temp = value;
193         uint256 digits;
194         while (temp != 0) {
195             digits++;
196             temp /= 10;
197         }
198         bytes memory buffer = new bytes(digits);
199         while (value != 0) {
200             digits -= 1;
201             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
202             value /= 10;
203         }
204         return string(buffer);
205     }
206 
207     /**
208      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
209      */
210     function toHexString(uint256 value) internal pure returns (string memory) {
211         if (value == 0) {
212             return "0x00";
213         }
214         uint256 temp = value;
215         uint256 length = 0;
216         while (temp != 0) {
217             length++;
218             temp >>= 8;
219         }
220         return toHexString(value, length);
221     }
222 
223     /**
224      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
225      */
226     function toHexString(uint256 value, uint256 length)
227         internal
228         pure
229         returns (string memory)
230     {
231         bytes memory buffer = new bytes(2 * length + 2);
232         buffer[0] = "0";
233         buffer[1] = "x";
234         for (uint256 i = 2 * length + 1; i > 1; --i) {
235             buffer[i] = _HEX_SYMBOLS[value & 0xf];
236             value >>= 4;
237         }
238         require(value == 0, "Strings: hex length insufficient");
239         return string(buffer);
240     }
241 }
242 
243 // File: @openzeppelin/contracts/utils/Context.sol
244 
245 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
246 
247 pragma solidity ^0.8.0;
248 
249 /**
250  * @dev Provides information about the current execution context, including the
251  * sender of the transaction and its data. While these are generally available
252  * via msg.sender and msg.data, they should not be accessed in such a direct
253  * manner, since when dealing with meta-transactions the account sending and
254  * paying for execution may not be the actual sender (as far as an application
255  * is concerned).
256  *
257  * This contract is only required for intermediate, library-like contracts.
258  */
259 abstract contract Context {
260     function _msgSender() internal view virtual returns (address) {
261         return msg.sender;
262     }
263 
264     function _msgData() internal view virtual returns (bytes calldata) {
265         return msg.data;
266     }
267 }
268 
269 // File: @openzeppelin/contracts/access/Ownable.sol
270 
271 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
272 
273 pragma solidity ^0.8.0;
274 
275 /**
276  * @dev Contract module which provides a basic access control mechanism, where
277  * there is an account (an owner) that can be granted exclusive access to
278  * specific functions.
279  *
280  * By default, the owner account will be the one that deploys the contract. This
281  * can later be changed with {transferOwnership}.
282  *
283  * This module is used through inheritance. It will make available the modifier
284  * `onlyOwner`, which can be applied to your functions to restrict their use to
285  * the owner.
286  */
287 abstract contract Ownable is Context {
288     address private _owner;
289 
290     event OwnershipTransferred(
291         address indexed previousOwner,
292         address indexed newOwner
293     );
294 
295     /**
296      * @dev Initializes the contract setting the deployer as the initial owner.
297      */
298     constructor() {
299         _transferOwnership(_msgSender());
300     }
301 
302     /**
303      * @dev Returns the address of the current owner.
304      */
305     function owner() public view virtual returns (address) {
306         return _owner;
307     }
308 
309     /**
310      * @dev Throws if called by any account other than the owner.
311      */
312     modifier onlyOwner() {
313         require(owner() == _msgSender(), "Ownable: caller is not the owner");
314         _;
315     }
316 
317     /**
318      * @dev Leaves the contract without owner. It will not be possible to call
319      * `onlyOwner` functions anymore. Can only be called by the current owner.
320      *
321      * NOTE: Renouncing ownership will leave the contract without an owner,
322      * thereby removing any functionality that is only available to the owner.
323      */
324     function renounceOwnership() public virtual onlyOwner {
325         _transferOwnership(address(0));
326     }
327 
328     /**
329      * @dev Transfers ownership of the contract to a new account (`newOwner`).
330      * Can only be called by the current owner.
331      */
332     function transferOwnership(address newOwner) public virtual onlyOwner {
333         require(
334             newOwner != address(0),
335             "Ownable: new owner is the zero address"
336         );
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
353 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
354 
355 pragma solidity ^0.8.1;
356 
357 /**
358  * @dev Collection of functions related to the address type
359  */
360 library Address {
361     /**
362      * @dev Returns true if `account` is a contract.
363      *
364      * [IMPORTANT]
365      * ====
366      * It is unsafe to assume that an address for which this function returns
367      * false is an externally-owned account (EOA) and not a contract.
368      *
369      * Among others, `isContract` will return false for the following
370      * types of addresses:
371      *
372      *  - an externally-owned account
373      *  - a contract in construction
374      *  - an address where a contract will be created
375      *  - an address where a contract lived, but was destroyed
376      * ====
377      *
378      * [IMPORTANT]
379      * ====
380      * You shouldn't rely on `isContract` to protect against flash loan attacks!
381      *
382      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
383      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
384      * constructor.
385      * ====
386      */
387     function isContract(address account) internal view returns (bool) {
388         // This method relies on extcodesize/address.code.length, which returns 0
389         // for contracts in construction, since the code is only stored at the end
390         // of the constructor execution.
391 
392         return account.code.length > 0;
393     }
394 
395     /**
396      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
397      * `recipient`, forwarding all available gas and reverting on errors.
398      *
399      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
400      * of certain opcodes, possibly making contracts go over the 2300 gas limit
401      * imposed by `transfer`, making them unable to receive funds via
402      * `transfer`. {sendValue} removes this limitation.
403      *
404      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
405      *
406      * IMPORTANT: because control is transferred to `recipient`, care must be
407      * taken to not create reentrancy vulnerabilities. Consider using
408      * {ReentrancyGuard} or the
409      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
410      */
411     function sendValue(address payable recipient, uint256 amount) internal {
412         require(
413             address(this).balance >= amount,
414             "Address: insufficient balance"
415         );
416 
417         (bool success, ) = recipient.call{value: amount}("");
418         require(
419             success,
420             "Address: unable to send value, recipient may have reverted"
421         );
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
442     function functionCall(address target, bytes memory data)
443         internal
444         returns (bytes memory)
445     {
446         return functionCall(target, data, "Address: low-level call failed");
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
451      * `errorMessage` as a fallback revert reason when `target` reverts.
452      *
453      * _Available since v3.1._
454      */
455     function functionCall(
456         address target,
457         bytes memory data,
458         string memory errorMessage
459     ) internal returns (bytes memory) {
460         return functionCallWithValue(target, data, 0, errorMessage);
461     }
462 
463     /**
464      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
465      * but also transferring `value` wei to `target`.
466      *
467      * Requirements:
468      *
469      * - the calling contract must have an ETH balance of at least `value`.
470      * - the called Solidity function must be `payable`.
471      *
472      * _Available since v3.1._
473      */
474     function functionCallWithValue(
475         address target,
476         bytes memory data,
477         uint256 value
478     ) internal returns (bytes memory) {
479         return
480             functionCallWithValue(
481                 target,
482                 data,
483                 value,
484                 "Address: low-level call with value failed"
485             );
486     }
487 
488     /**
489      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
490      * with `errorMessage` as a fallback revert reason when `target` reverts.
491      *
492      * _Available since v3.1._
493      */
494     function functionCallWithValue(
495         address target,
496         bytes memory data,
497         uint256 value,
498         string memory errorMessage
499     ) internal returns (bytes memory) {
500         require(
501             address(this).balance >= value,
502             "Address: insufficient balance for call"
503         );
504         require(isContract(target), "Address: call to non-contract");
505 
506         (bool success, bytes memory returndata) = target.call{value: value}(
507             data
508         );
509         return verifyCallResult(success, returndata, errorMessage);
510     }
511 
512     /**
513      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
514      * but performing a static call.
515      *
516      * _Available since v3.3._
517      */
518     function functionStaticCall(address target, bytes memory data)
519         internal
520         view
521         returns (bytes memory)
522     {
523         return
524             functionStaticCall(
525                 target,
526                 data,
527                 "Address: low-level static call failed"
528             );
529     }
530 
531     /**
532      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
533      * but performing a static call.
534      *
535      * _Available since v3.3._
536      */
537     function functionStaticCall(
538         address target,
539         bytes memory data,
540         string memory errorMessage
541     ) internal view returns (bytes memory) {
542         require(isContract(target), "Address: static call to non-contract");
543 
544         (bool success, bytes memory returndata) = target.staticcall(data);
545         return verifyCallResult(success, returndata, errorMessage);
546     }
547 
548     /**
549      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
550      * but performing a delegate call.
551      *
552      * _Available since v3.4._
553      */
554     function functionDelegateCall(address target, bytes memory data)
555         internal
556         returns (bytes memory)
557     {
558         return
559             functionDelegateCall(
560                 target,
561                 data,
562                 "Address: low-level delegate call failed"
563             );
564     }
565 
566     /**
567      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
568      * but performing a delegate call.
569      *
570      * _Available since v3.4._
571      */
572     function functionDelegateCall(
573         address target,
574         bytes memory data,
575         string memory errorMessage
576     ) internal returns (bytes memory) {
577         require(isContract(target), "Address: delegate call to non-contract");
578 
579         (bool success, bytes memory returndata) = target.delegatecall(data);
580         return verifyCallResult(success, returndata, errorMessage);
581     }
582 
583     /**
584      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
585      * revert reason using the provided one.
586      *
587      * _Available since v4.3._
588      */
589     function verifyCallResult(
590         bool success,
591         bytes memory returndata,
592         string memory errorMessage
593     ) internal pure returns (bytes memory) {
594         if (success) {
595             return returndata;
596         } else {
597             // Look for revert reason and bubble it up if present
598             if (returndata.length > 0) {
599                 // The easiest way to bubble the revert reason is using memory via assembly
600 
601                 assembly {
602                     let returndata_size := mload(returndata)
603                     revert(add(32, returndata), returndata_size)
604                 }
605             } else {
606                 revert(errorMessage);
607             }
608         }
609     }
610 }
611 
612 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
613 
614 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
615 
616 pragma solidity ^0.8.0;
617 
618 /**
619  * @title SafeERC20
620  * @dev Wrappers around ERC20 operations that throw on failure (when the token
621  * contract returns false). Tokens that return no value (and instead revert or
622  * throw on failure) are also supported, non-reverting calls are assumed to be
623  * successful.
624  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
625  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
626  */
627 library SafeERC20 {
628     using Address for address;
629 
630     function safeTransfer(
631         IERC20 token,
632         address to,
633         uint256 value
634     ) internal {
635         _callOptionalReturn(
636             token,
637             abi.encodeWithSelector(token.transfer.selector, to, value)
638         );
639     }
640 
641     function safeTransferFrom(
642         IERC20 token,
643         address from,
644         address to,
645         uint256 value
646     ) internal {
647         _callOptionalReturn(
648             token,
649             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
650         );
651     }
652 
653     /**
654      * @dev Deprecated. This function has issues similar to the ones found in
655      * {IERC20-approve}, and its usage is discouraged.
656      *
657      * Whenever possible, use {safeIncreaseAllowance} and
658      * {safeDecreaseAllowance} instead.
659      */
660     function safeApprove(
661         IERC20 token,
662         address spender,
663         uint256 value
664     ) internal {
665         // safeApprove should only be called when setting an initial allowance,
666         // or when resetting it to zero. To increase and decrease it, use
667         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
668         require(
669             (value == 0) || (token.allowance(address(this), spender) == 0),
670             "SafeERC20: approve from non-zero to non-zero allowance"
671         );
672         _callOptionalReturn(
673             token,
674             abi.encodeWithSelector(token.approve.selector, spender, value)
675         );
676     }
677 
678     function safeIncreaseAllowance(
679         IERC20 token,
680         address spender,
681         uint256 value
682     ) internal {
683         uint256 newAllowance = token.allowance(address(this), spender) + value;
684         _callOptionalReturn(
685             token,
686             abi.encodeWithSelector(
687                 token.approve.selector,
688                 spender,
689                 newAllowance
690             )
691         );
692     }
693 
694     function safeDecreaseAllowance(
695         IERC20 token,
696         address spender,
697         uint256 value
698     ) internal {
699         unchecked {
700             uint256 oldAllowance = token.allowance(address(this), spender);
701             require(
702                 oldAllowance >= value,
703                 "SafeERC20: decreased allowance below zero"
704             );
705             uint256 newAllowance = oldAllowance - value;
706             _callOptionalReturn(
707                 token,
708                 abi.encodeWithSelector(
709                     token.approve.selector,
710                     spender,
711                     newAllowance
712                 )
713             );
714         }
715     }
716 
717     /**
718      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
719      * on the return value: the return value is optional (but if data is returned, it must not be false).
720      * @param token The token targeted by the call.
721      * @param data The call data (encoded using abi.encode or one of its variants).
722      */
723     function _callOptionalReturn(IERC20 token, bytes memory data) private {
724         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
725         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
726         // the target address contains contract code and also asserts for success in the low-level call.
727 
728         bytes memory returndata = address(token).functionCall(
729             data,
730             "SafeERC20: low-level call failed"
731         );
732         if (returndata.length > 0) {
733             // Return data is optional
734             require(
735                 abi.decode(returndata, (bool)),
736                 "SafeERC20: ERC20 operation did not succeed"
737             );
738         }
739     }
740 }
741 
742 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
743 
744 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
745 
746 pragma solidity ^0.8.0;
747 
748 /**
749  * @title ERC721 token receiver interface
750  * @dev Interface for any contract that wants to support safeTransfers
751  * from ERC721 asset contracts.
752  */
753 interface IERC721Receiver {
754     /**
755      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
756      * by `operator` from `from`, this function is called.
757      *
758      * It must return its Solidity selector to confirm the token transfer.
759      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
760      *
761      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
762      */
763     function onERC721Received(
764         address operator,
765         address from,
766         uint256 tokenId,
767         bytes calldata data
768     ) external returns (bytes4);
769 }
770 
771 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
772 
773 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
774 
775 pragma solidity ^0.8.0;
776 
777 /**
778  * @dev Interface of the ERC165 standard, as defined in the
779  * https://eips.ethereum.org/EIPS/eip-165[EIP].
780  *
781  * Implementers can declare support of contract interfaces, which can then be
782  * queried by others ({ERC165Checker}).
783  *
784  * For an implementation, see {ERC165}.
785  */
786 interface IERC165 {
787     /**
788      * @dev Returns true if this contract implements the interface defined by
789      * `interfaceId`. See the corresponding
790      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
791      * to learn more about how these ids are created.
792      *
793      * This function call must use less than 30 000 gas.
794      */
795     function supportsInterface(bytes4 interfaceId) external view returns (bool);
796 }
797 
798 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
799 
800 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
801 
802 pragma solidity ^0.8.0;
803 
804 /**
805  * @dev Implementation of the {IERC165} interface.
806  *
807  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
808  * for the additional interface id that will be supported. For example:
809  *
810  * ```solidity
811  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
812  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
813  * }
814  * ```
815  *
816  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
817  */
818 abstract contract ERC165 is IERC165 {
819     /**
820      * @dev See {IERC165-supportsInterface}.
821      */
822     function supportsInterface(bytes4 interfaceId)
823         public
824         view
825         virtual
826         override
827         returns (bool)
828     {
829         return interfaceId == type(IERC165).interfaceId;
830     }
831 }
832 
833 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
834 
835 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
836 
837 pragma solidity ^0.8.0;
838 
839 /**
840  * @dev Required interface of an ERC721 compliant contract.
841  */
842 interface IERC721 is IERC165 {
843     /**
844      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
845      */
846     event Transfer(
847         address indexed from,
848         address indexed to,
849         uint256 indexed tokenId
850     );
851 
852     /**
853      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
854      */
855     event Approval(
856         address indexed owner,
857         address indexed approved,
858         uint256 indexed tokenId
859     );
860 
861     /**
862      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
863      */
864     event ApprovalForAll(
865         address indexed owner,
866         address indexed operator,
867         bool approved
868     );
869 
870     /**
871      * @dev Returns the number of tokens in ``owner``'s account.
872      */
873     function balanceOf(address owner) external view returns (uint256 balance);
874 
875     /**
876      * @dev Returns the owner of the `tokenId` token.
877      *
878      * Requirements:
879      *
880      * - `tokenId` must exist.
881      */
882     function ownerOf(uint256 tokenId) external view returns (address owner);
883 
884     /**
885      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
886      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
887      *
888      * Requirements:
889      *
890      * - `from` cannot be the zero address.
891      * - `to` cannot be the zero address.
892      * - `tokenId` token must exist and be owned by `from`.
893      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
894      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
895      *
896      * Emits a {Transfer} event.
897      */
898     function safeTransferFrom(
899         address from,
900         address to,
901         uint256 tokenId
902     ) external;
903 
904     /**
905      * @dev Transfers `tokenId` token from `from` to `to`.
906      *
907      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
908      *
909      * Requirements:
910      *
911      * - `from` cannot be the zero address.
912      * - `to` cannot be the zero address.
913      * - `tokenId` token must be owned by `from`.
914      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
915      *
916      * Emits a {Transfer} event.
917      */
918     function transferFrom(
919         address from,
920         address to,
921         uint256 tokenId
922     ) external;
923 
924     /**
925      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
926      * The approval is cleared when the token is transferred.
927      *
928      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
929      *
930      * Requirements:
931      *
932      * - The caller must own the token or be an approved operator.
933      * - `tokenId` must exist.
934      *
935      * Emits an {Approval} event.
936      */
937     function approve(address to, uint256 tokenId) external;
938 
939     /**
940      * @dev Returns the account approved for `tokenId` token.
941      *
942      * Requirements:
943      *
944      * - `tokenId` must exist.
945      */
946     function getApproved(uint256 tokenId)
947         external
948         view
949         returns (address operator);
950 
951     /**
952      * @dev Approve or remove `operator` as an operator for the caller.
953      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
954      *
955      * Requirements:
956      *
957      * - The `operator` cannot be the caller.
958      *
959      * Emits an {ApprovalForAll} event.
960      */
961     function setApprovalForAll(address operator, bool _approved) external;
962 
963     /**
964      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
965      *
966      * See {setApprovalForAll}
967      */
968     function isApprovedForAll(address owner, address operator)
969         external
970         view
971         returns (bool);
972 
973     /**
974      * @dev Safely transfers `tokenId` token from `from` to `to`.
975      *
976      * Requirements:
977      *
978      * - `from` cannot be the zero address.
979      * - `to` cannot be the zero address.
980      * - `tokenId` token must exist and be owned by `from`.
981      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
982      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
983      *
984      * Emits a {Transfer} event.
985      */
986     function safeTransferFrom(
987         address from,
988         address to,
989         uint256 tokenId,
990         bytes calldata data
991     ) external;
992 }
993 
994 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
995 
996 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
997 
998 pragma solidity ^0.8.0;
999 
1000 /**
1001  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1002  * @dev See https://eips.ethereum.org/EIPS/eip-721
1003  */
1004 interface IERC721Enumerable is IERC721 {
1005     /**
1006      * @dev Returns the total amount of tokens stored by the contract.
1007      */
1008     function totalSupply() external view returns (uint256);
1009 
1010     /**
1011      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1012      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1013      */
1014     function tokenOfOwnerByIndex(address owner, uint256 index)
1015         external
1016         view
1017         returns (uint256);
1018 
1019     /**
1020      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1021      * Use along with {totalSupply} to enumerate all tokens.
1022      */
1023     function tokenByIndex(uint256 index) external view returns (uint256);
1024 }
1025 
1026 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1027 
1028 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1029 
1030 pragma solidity ^0.8.0;
1031 
1032 /**
1033  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1034  * @dev See https://eips.ethereum.org/EIPS/eip-721
1035  */
1036 interface IERC721Metadata is IERC721 {
1037     /**
1038      * @dev Returns the token collection name.
1039      */
1040     function name() external view returns (string memory);
1041 
1042     /**
1043      * @dev Returns the token collection symbol.
1044      */
1045     function symbol() external view returns (string memory);
1046 
1047     /**
1048      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1049      */
1050     function tokenURI(uint256 tokenId) external view returns (string memory);
1051 }
1052 
1053 // File: contracts/TwistedToonz.sol
1054 
1055 // Creator: Chiru Labs
1056 
1057 pragma solidity ^0.8.0;
1058 
1059 /**
1060  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1061  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1062  *
1063  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1064  *
1065  * Does not support burning tokens to address(0).
1066  *
1067  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
1068  */
1069 contract ERC721A is
1070     Context,
1071     ERC165,
1072     IERC721,
1073     IERC721Metadata,
1074     IERC721Enumerable
1075 {
1076     using Address for address;
1077     using Strings for uint256;
1078 
1079     struct TokenOwnership {
1080         address addr;
1081         uint64 startTimestamp;
1082     }
1083 
1084     struct AddressData {
1085         uint128 balance;
1086         uint128 numberMinted;
1087     }
1088 
1089     uint256 internal currentIndex;
1090 
1091     // Token name
1092     string private _name;
1093 
1094     // Token symbol
1095     string private _symbol;
1096 
1097     // Mapping from token ID to ownership details
1098     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1099     mapping(uint256 => TokenOwnership) internal _ownerships;
1100 
1101     // Mapping owner address to address data
1102     mapping(address => AddressData) private _addressData;
1103 
1104     // Mapping from token ID to approved address
1105     mapping(uint256 => address) private _tokenApprovals;
1106 
1107     // Mapping from owner to operator approvals
1108     mapping(address => mapping(address => bool)) private _operatorApprovals;
1109 
1110     constructor(string memory name_, string memory symbol_) {
1111         _name = name_;
1112         _symbol = symbol_;
1113     }
1114 
1115     /**
1116      * @dev See {IERC721Enumerable-totalSupply}.
1117      */
1118     function totalSupply() public view override returns (uint256) {
1119         return currentIndex;
1120     }
1121 
1122     /**
1123      * @dev See {IERC721Enumerable-tokenByIndex}.
1124      */
1125     function tokenByIndex(uint256 index)
1126         public
1127         view
1128         override
1129         returns (uint256)
1130     {
1131         require(index < totalSupply(), "ERC721A: global index out of bounds");
1132         return index;
1133     }
1134 
1135     /**
1136      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1137      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1138      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1139      */
1140     function tokenOfOwnerByIndex(address owner, uint256 index)
1141         public
1142         view
1143         override
1144         returns (uint256)
1145     {
1146         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1147         uint256 numMintedSoFar = totalSupply();
1148         uint256 tokenIdsIdx;
1149         address currOwnershipAddr;
1150 
1151         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1152         unchecked {
1153             for (uint256 i; i < numMintedSoFar; i++) {
1154                 TokenOwnership memory ownership = _ownerships[i];
1155                 if (ownership.addr != address(0)) {
1156                     currOwnershipAddr = ownership.addr;
1157                 }
1158                 if (currOwnershipAddr == owner) {
1159                     if (tokenIdsIdx == index) {
1160                         return i;
1161                     }
1162                     tokenIdsIdx++;
1163                 }
1164             }
1165         }
1166 
1167         revert("ERC721A: unable to get token of owner by index");
1168     }
1169 
1170     /**
1171      * @dev See {IERC165-supportsInterface}.
1172      */
1173     function supportsInterface(bytes4 interfaceId)
1174         public
1175         view
1176         virtual
1177         override(ERC165, IERC165)
1178         returns (bool)
1179     {
1180         return
1181             interfaceId == type(IERC721).interfaceId ||
1182             interfaceId == type(IERC721Metadata).interfaceId ||
1183             interfaceId == type(IERC721Enumerable).interfaceId ||
1184             super.supportsInterface(interfaceId);
1185     }
1186 
1187     /**
1188      * @dev See {IERC721-balanceOf}.
1189      */
1190     function balanceOf(address owner) public view override returns (uint256) {
1191         require(
1192             owner != address(0),
1193             "ERC721A: balance query for the zero address"
1194         );
1195         return uint256(_addressData[owner].balance);
1196     }
1197 
1198     function _numberMinted(address owner) internal view returns (uint256) {
1199         require(
1200             owner != address(0),
1201             "ERC721A: number minted query for the zero address"
1202         );
1203         return uint256(_addressData[owner].numberMinted);
1204     }
1205 
1206     /**
1207      * Gas spent here starts off proportional to the maximum mint batch size.
1208      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1209      */
1210     function ownershipOf(uint256 tokenId)
1211         internal
1212         view
1213         returns (TokenOwnership memory)
1214     {
1215         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1216 
1217         unchecked {
1218             for (uint256 curr = tokenId; curr >= 0; curr--) {
1219                 TokenOwnership memory ownership = _ownerships[curr];
1220                 if (ownership.addr != address(0)) {
1221                     return ownership;
1222                 }
1223             }
1224         }
1225 
1226         revert("ERC721A: unable to determine the owner of token");
1227     }
1228 
1229     /**
1230      * @dev See {IERC721-ownerOf}.
1231      */
1232     function ownerOf(uint256 tokenId) public view override returns (address) {
1233         return ownershipOf(tokenId).addr;
1234     }
1235 
1236     /**
1237      * @dev See {IERC721Metadata-name}.
1238      */
1239     function name() public view virtual override returns (string memory) {
1240         return _name;
1241     }
1242 
1243     /**
1244      * @dev See {IERC721Metadata-symbol}.
1245      */
1246     function symbol() public view virtual override returns (string memory) {
1247         return _symbol;
1248     }
1249 
1250     /**
1251      * @dev See {IERC721Metadata-tokenURI}.
1252      */
1253     function tokenURI(uint256 tokenId)
1254         public
1255         view
1256         virtual
1257         override
1258         returns (string memory)
1259     {
1260         require(
1261             _exists(tokenId),
1262             "ERC721Metadata: URI query for nonexistent token"
1263         );
1264 
1265         string memory baseURI = _baseURI();
1266         return
1267             bytes(baseURI).length != 0
1268                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1269                 : "";
1270     }
1271 
1272     /**
1273      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1274      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1275      * by default, can be overriden in child contracts.
1276      */
1277     function _baseURI() internal view virtual returns (string memory) {
1278         return "";
1279     }
1280 
1281     /**
1282      * @dev See {IERC721-approve}.
1283      */
1284     function approve(address to, uint256 tokenId) public override {
1285         address owner = ERC721A.ownerOf(tokenId);
1286         require(to != owner, "ERC721A: approval to current owner");
1287 
1288         require(
1289             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1290             "ERC721A: approve caller is not owner nor approved for all"
1291         );
1292 
1293         _approve(to, tokenId, owner);
1294     }
1295 
1296     /**
1297      * @dev See {IERC721-getApproved}.
1298      */
1299     function getApproved(uint256 tokenId)
1300         public
1301         view
1302         override
1303         returns (address)
1304     {
1305         require(
1306             _exists(tokenId),
1307             "ERC721A: approved query for nonexistent token"
1308         );
1309 
1310         return _tokenApprovals[tokenId];
1311     }
1312 
1313     /**
1314      * @dev See {IERC721-setApprovalForAll}.
1315      */
1316     function setApprovalForAll(address operator, bool approved)
1317         public
1318         override
1319     {
1320         require(operator != _msgSender(), "ERC721A: approve to caller");
1321 
1322         _operatorApprovals[_msgSender()][operator] = approved;
1323         emit ApprovalForAll(_msgSender(), operator, approved);
1324     }
1325 
1326     /**
1327      * @dev See {IERC721-isApprovedForAll}.
1328      */
1329     function isApprovedForAll(address owner, address operator)
1330         public
1331         view
1332         virtual
1333         override
1334         returns (bool)
1335     {
1336         return _operatorApprovals[owner][operator];
1337     }
1338 
1339     /**
1340      * @dev See {IERC721-transferFrom}.
1341      */
1342     function transferFrom(
1343         address from,
1344         address to,
1345         uint256 tokenId
1346     ) public virtual override {
1347         _transfer(from, to, tokenId);
1348     }
1349 
1350     /**
1351      * @dev See {IERC721-safeTransferFrom}.
1352      */
1353     function safeTransferFrom(
1354         address from,
1355         address to,
1356         uint256 tokenId
1357     ) public virtual override {
1358         safeTransferFrom(from, to, tokenId, "");
1359     }
1360 
1361     /**
1362      * @dev See {IERC721-safeTransferFrom}.
1363      */
1364     function safeTransferFrom(
1365         address from,
1366         address to,
1367         uint256 tokenId,
1368         bytes memory _data
1369     ) public override {
1370         _transfer(from, to, tokenId);
1371         require(
1372             _checkOnERC721Received(from, to, tokenId, _data),
1373             "ERC721A: transfer to non ERC721Receiver implementer"
1374         );
1375     }
1376 
1377     /**
1378      * @dev Returns whether `tokenId` exists.
1379      *
1380      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1381      *
1382      * Tokens start existing when they are minted (`_mint`),
1383      */
1384     function _exists(uint256 tokenId) internal view returns (bool) {
1385         return tokenId < currentIndex;
1386     }
1387 
1388     function _safeMint(address to, uint256 quantity) internal {
1389         _safeMint(to, quantity, "");
1390     }
1391 
1392     /**
1393      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1394      *
1395      * Requirements:
1396      *
1397      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1398      * - `quantity` must be greater than 0.
1399      *
1400      * Emits a {Transfer} event.
1401      */
1402     function _safeMint(
1403         address to,
1404         uint256 quantity,
1405         bytes memory _data
1406     ) internal {
1407         _mint(to, quantity, _data, true);
1408     }
1409 
1410     /**
1411      * @dev Mints `quantity` tokens and transfers them to `to`.
1412      *
1413      * Requirements:
1414      *
1415      * - `to` cannot be the zero address.
1416      * - `quantity` must be greater than 0.
1417      *
1418      * Emits a {Transfer} event.
1419      */
1420     function _mint(
1421         address to,
1422         uint256 quantity,
1423         bytes memory _data,
1424         bool safe
1425     ) internal {
1426         uint256 startTokenId = currentIndex;
1427         require(to != address(0), "ERC721A: mint to the zero address");
1428         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1429 
1430         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1431 
1432         // Overflows are incredibly unrealistic.
1433         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1434         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1435         unchecked {
1436             _addressData[to].balance += uint128(quantity);
1437             _addressData[to].numberMinted += uint128(quantity);
1438 
1439             _ownerships[startTokenId].addr = to;
1440             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1441 
1442             uint256 updatedIndex = startTokenId;
1443 
1444             for (uint256 i; i < quantity; i++) {
1445                 emit Transfer(address(0), to, updatedIndex);
1446                 if (safe) {
1447                     require(
1448                         _checkOnERC721Received(
1449                             address(0),
1450                             to,
1451                             updatedIndex,
1452                             _data
1453                         ),
1454                         "ERC721A: transfer to non ERC721Receiver implementer"
1455                     );
1456                 }
1457 
1458                 updatedIndex++;
1459             }
1460 
1461             currentIndex = updatedIndex;
1462         }
1463 
1464         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1465     }
1466 
1467     /**
1468      * @dev Transfers `tokenId` from `from` to `to`.
1469      *
1470      * Requirements:
1471      *
1472      * - `to` cannot be the zero address.
1473      * - `tokenId` token must be owned by `from`.
1474      *
1475      * Emits a {Transfer} event.
1476      */
1477     function _transfer(
1478         address from,
1479         address to,
1480         uint256 tokenId
1481     ) private {
1482         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1483 
1484         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1485             getApproved(tokenId) == _msgSender() ||
1486             isApprovedForAll(prevOwnership.addr, _msgSender()));
1487 
1488         require(
1489             isApprovedOrOwner,
1490             "ERC721A: transfer caller is not owner nor approved"
1491         );
1492 
1493         require(
1494             prevOwnership.addr == from,
1495             "ERC721A: transfer from incorrect owner"
1496         );
1497         require(to != address(0), "ERC721A: transfer to the zero address");
1498 
1499         _beforeTokenTransfers(from, to, tokenId, 1);
1500 
1501         // Clear approvals from the previous owner
1502         _approve(address(0), tokenId, prevOwnership.addr);
1503 
1504         // Underflow of the sender's balance is impossible because we check for
1505         // ownership above and the recipient's balance can't realistically overflow.
1506         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1507         unchecked {
1508             _addressData[from].balance -= 1;
1509             _addressData[to].balance += 1;
1510 
1511             _ownerships[tokenId].addr = to;
1512             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1513 
1514             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1515             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1516             uint256 nextTokenId = tokenId + 1;
1517             if (_ownerships[nextTokenId].addr == address(0)) {
1518                 if (_exists(nextTokenId)) {
1519                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1520                     _ownerships[nextTokenId].startTimestamp = prevOwnership
1521                         .startTimestamp;
1522                 }
1523             }
1524         }
1525 
1526         emit Transfer(from, to, tokenId);
1527         _afterTokenTransfers(from, to, tokenId, 1);
1528     }
1529 
1530     /**
1531      * @dev Approve `to` to operate on `tokenId`
1532      *
1533      * Emits a {Approval} event.
1534      */
1535     function _approve(
1536         address to,
1537         uint256 tokenId,
1538         address owner
1539     ) private {
1540         _tokenApprovals[tokenId] = to;
1541         emit Approval(owner, to, tokenId);
1542     }
1543 
1544     /**
1545      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1546      * The call is not executed if the target address is not a contract.
1547      *
1548      * @param from address representing the previous owner of the given token ID
1549      * @param to target address that will receive the tokens
1550      * @param tokenId uint256 ID of the token to be transferred
1551      * @param _data bytes optional data to send along with the call
1552      * @return bool whether the call correctly returned the expected magic value
1553      */
1554     function _checkOnERC721Received(
1555         address from,
1556         address to,
1557         uint256 tokenId,
1558         bytes memory _data
1559     ) private returns (bool) {
1560         if (to.isContract()) {
1561             try
1562                 IERC721Receiver(to).onERC721Received(
1563                     _msgSender(),
1564                     from,
1565                     tokenId,
1566                     _data
1567                 )
1568             returns (bytes4 retval) {
1569                 return retval == IERC721Receiver(to).onERC721Received.selector;
1570             } catch (bytes memory reason) {
1571                 if (reason.length == 0) {
1572                     revert(
1573                         "ERC721A: transfer to non ERC721Receiver implementer"
1574                     );
1575                 } else {
1576                     assembly {
1577                         revert(add(32, reason), mload(reason))
1578                     }
1579                 }
1580             }
1581         } else {
1582             return true;
1583         }
1584     }
1585 
1586     /**
1587      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1588      *
1589      * startTokenId - the first token id to be transferred
1590      * quantity - the amount to be transferred
1591      *
1592      * Calling conditions:
1593      *
1594      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1595      * transferred to `to`.
1596      * - When `from` is zero, `tokenId` will be minted for `to`.
1597      */
1598     function _beforeTokenTransfers(
1599         address from,
1600         address to,
1601         uint256 startTokenId,
1602         uint256 quantity
1603     ) internal virtual {}
1604 
1605     /**
1606      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1607      * minting.
1608      *
1609      * startTokenId - the first token id to be transferred
1610      * quantity - the amount to be transferred
1611      *
1612      * Calling conditions:
1613      *
1614      * - when `from` and `to` are both non-zero.
1615      * - `from` and `to` are never both zero.
1616      */
1617     function _afterTokenTransfers(
1618         address from,
1619         address to,
1620         uint256 startTokenId,
1621         uint256 quantity
1622     ) internal virtual {}
1623 }
1624 
1625 pragma solidity ^0.8.0;
1626 
1627 /**
1628  * @dev These functions deal with verification of Merkle Tree proofs.
1629  *
1630  * The proofs can be generated using the JavaScript library
1631  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1632  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1633  *
1634  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1635  *
1636  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1637  * hashing, or use a hash function other than keccak256 for hashing leaves.
1638  * This is because the concatenation of a sorted pair of internal nodes in
1639  * the merkle tree could be reinterpreted as a leaf value.
1640  */
1641 library MerkleProof {
1642     /**
1643      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1644      * defined by `root`. For this, a `proof` must be provided, containing
1645      * sibling hashes on the branch from the leaf to the root of the tree. Each
1646      * pair of leaves and each pair of pre-images are assumed to be sorted.
1647      */
1648     function verify(
1649         bytes32[] memory proof,
1650         bytes32 root,
1651         bytes32 leaf
1652     ) internal pure returns (bool) {
1653         return processProof(proof, leaf) == root;
1654     }
1655 
1656     /**
1657      * @dev Calldata version of {verify}
1658      *
1659      * _Available since v4.7._
1660      */
1661     function verifyCalldata(
1662         bytes32[] calldata proof,
1663         bytes32 root,
1664         bytes32 leaf
1665     ) internal pure returns (bool) {
1666         return processProofCalldata(proof, leaf) == root;
1667     }
1668 
1669     /**
1670      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1671      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1672      * hash matches the root of the tree. When processing the proof, the pairs
1673      * of leafs & pre-images are assumed to be sorted.
1674      *
1675      * _Available since v4.4._
1676      */
1677     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1678         bytes32 computedHash = leaf;
1679         for (uint256 i = 0; i < proof.length; i++) {
1680             computedHash = _hashPair(computedHash, proof[i]);
1681         }
1682         return computedHash;
1683     }
1684 
1685     /**
1686      * @dev Calldata version of {processProof}
1687      *
1688      * _Available since v4.7._
1689      */
1690     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1691         bytes32 computedHash = leaf;
1692         for (uint256 i = 0; i < proof.length; i++) {
1693             computedHash = _hashPair(computedHash, proof[i]);
1694         }
1695         return computedHash;
1696     }
1697 
1698     /**
1699      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1700      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1701      *
1702      * _Available since v4.7._
1703      */
1704     function multiProofVerify(
1705         bytes32[] memory proof,
1706         bool[] memory proofFlags,
1707         bytes32 root,
1708         bytes32[] memory leaves
1709     ) internal pure returns (bool) {
1710         return processMultiProof(proof, proofFlags, leaves) == root;
1711     }
1712 
1713     /**
1714      * @dev Calldata version of {multiProofVerify}
1715      *
1716      * _Available since v4.7._
1717      */
1718     function multiProofVerifyCalldata(
1719         bytes32[] calldata proof,
1720         bool[] calldata proofFlags,
1721         bytes32 root,
1722         bytes32[] memory leaves
1723     ) internal pure returns (bool) {
1724         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1725     }
1726 
1727     /**
1728      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1729      * consuming from one or the other at each step according to the instructions given by
1730      * `proofFlags`.
1731      *
1732      * _Available since v4.7._
1733      */
1734     function processMultiProof(
1735         bytes32[] memory proof,
1736         bool[] memory proofFlags,
1737         bytes32[] memory leaves
1738     ) internal pure returns (bytes32 merkleRoot) {
1739         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1740         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1741         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1742         // the merkle tree.
1743         uint256 leavesLen = leaves.length;
1744         uint256 totalHashes = proofFlags.length;
1745 
1746         // Check proof validity.
1747         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1748 
1749         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1750         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1751         bytes32[] memory hashes = new bytes32[](totalHashes);
1752         uint256 leafPos = 0;
1753         uint256 hashPos = 0;
1754         uint256 proofPos = 0;
1755         // At each step, we compute the next hash using two values:
1756         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1757         //   get the next hash.
1758         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1759         //   `proof` array.
1760         for (uint256 i = 0; i < totalHashes; i++) {
1761             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1762             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1763             hashes[i] = _hashPair(a, b);
1764         }
1765 
1766         if (totalHashes > 0) {
1767             return hashes[totalHashes - 1];
1768         } else if (leavesLen > 0) {
1769             return leaves[0];
1770         } else {
1771             return proof[0];
1772         }
1773     }
1774 
1775     /**
1776      * @dev Calldata version of {processMultiProof}
1777      *
1778      * _Available since v4.7._
1779      */
1780     function processMultiProofCalldata(
1781         bytes32[] calldata proof,
1782         bool[] calldata proofFlags,
1783         bytes32[] memory leaves
1784     ) internal pure returns (bytes32 merkleRoot) {
1785         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1786         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1787         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1788         // the merkle tree.
1789         uint256 leavesLen = leaves.length;
1790         uint256 totalHashes = proofFlags.length;
1791 
1792         // Check proof validity.
1793         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1794 
1795         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1796         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1797         bytes32[] memory hashes = new bytes32[](totalHashes);
1798         uint256 leafPos = 0;
1799         uint256 hashPos = 0;
1800         uint256 proofPos = 0;
1801         // At each step, we compute the next hash using two values:
1802         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1803         //   get the next hash.
1804         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1805         //   `proof` array.
1806         for (uint256 i = 0; i < totalHashes; i++) {
1807             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1808             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1809             hashes[i] = _hashPair(a, b);
1810         }
1811 
1812         if (totalHashes > 0) {
1813             return hashes[totalHashes - 1];
1814         } else if (leavesLen > 0) {
1815             return leaves[0];
1816         } else {
1817             return proof[0];
1818         }
1819     }
1820 
1821     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1822         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1823     }
1824 
1825     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1826         /// @solidity memory-safe-assembly
1827         assembly {
1828             mstore(0x00, a)
1829             mstore(0x20, b)
1830             value := keccak256(0x00, 0x40)
1831         }
1832     }
1833 }
1834 
1835 contract Ruggers is ERC721A, Ownable, ReentrancyGuard {
1836 
1837     uint256 public price = 0.005 ether;
1838     uint256 public maxPerTx = 2;
1839     uint256 public maxPerWallet = 2;
1840     uint256 public freeForPublic = 1444;
1841     uint256 public freePublicMinted = 0;
1842     uint256 public maxSupply = 6666;
1843     uint256 public maxSupplyForWL = 3000;
1844     uint256 public maxSupplyForPublic = 3666;
1845     bytes32 public merkleRoot = 0x0;
1846 
1847     bool public wlEnabled = false;
1848     bool public publicEnabled = false;
1849 
1850     string public baseURI;
1851 
1852     constructor() ERC721A("Ruggers", "RUG") {}
1853 
1854 
1855     function wlMint(bytes32[] calldata _merkleProof, uint256 amt)
1856         external
1857         payable
1858     {
1859         require(wlEnabled, "Minting is not live yet, hold on rugger.");
1860         require(totalSupply() + amt <= maxSupplyForWL, "No more ruggers for WL");
1861         require(amt <= maxPerTx, "Max per transaction reached.");
1862         require(numberMinted(msg.sender) + amt <= maxPerWallet, "Max per wallet reached.");
1863 
1864         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1865         require(
1866             MerkleProof.verify(_merkleProof, merkleRoot, leaf),
1867             "Invalid Merkle proof."
1868         );
1869 
1870         _safeMint(msg.sender, amt);
1871     }
1872 
1873     function publicMint(uint256 amt) external payable {
1874         uint256 cost = price;
1875 
1876         if (freePublicMinted + amt <= freeForPublic) {
1877             cost = 0;
1878         }
1879 
1880         require(freePublicMinted + amt <= maxSupplyForPublic, "No more ruggers for public sale");
1881         require(publicEnabled, "Minting is not live yet, hold on rugger.");
1882         require(msg.sender == tx.origin, "Be yourself, honey.");
1883         require(msg.value >= amt * cost, "Please send the exact amount.");
1884         require(amt <= maxPerTx, "Max per TX reached.");
1885         require(numberMinted(msg.sender) + amt <= maxPerWallet, "Max per wallet reached.");
1886         
1887         _safeMint(msg.sender, amt);
1888 
1889         freePublicMinted = freePublicMinted + amt;
1890     }
1891 
1892     function ownerBatchMint(uint256 amt) external onlyOwner {
1893         require(totalSupply() + amt < maxSupply + 1, "too many!");
1894 
1895         _safeMint(msg.sender, amt);
1896     }
1897 
1898     function toggleMinting() external onlyOwner {
1899         publicEnabled = !publicEnabled;
1900     }
1901 
1902     function toggleWLMinting() external onlyOwner {
1903         wlEnabled = !wlEnabled;
1904     }
1905 
1906     function numberMinted(address owner) public view returns (uint256) {
1907         return _numberMinted(owner);
1908     }
1909 
1910     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1911         merkleRoot = _merkleRoot;
1912     }
1913 
1914     function setBaseURI(string calldata baseURI_) external onlyOwner {
1915         baseURI = baseURI_;
1916     }
1917 
1918     function setPrice(uint256 price_) external onlyOwner {
1919         price = price_;
1920     }
1921 
1922     function setMaxSupply(uint256 maxSupply_) external onlyOwner {
1923         maxSupply = maxSupply_;
1924     }
1925 
1926     function setMaxSupplyForWL(uint256 maxSupplyForWL_) external onlyOwner {
1927         maxSupplyForWL = maxSupplyForWL_;
1928     }
1929 
1930     function setMaxSupplyForPublic(uint256 maxSupplyForPublic_) external onlyOwner {
1931         maxSupplyForPublic = maxSupplyForPublic_;
1932     }
1933 
1934     function setFreePublicMinted(uint256 freePublicMinted_) external onlyOwner {
1935         freePublicMinted = freePublicMinted_;
1936     }
1937 
1938     function setFreeForPublic(uint256 freeForPublic_) external onlyOwner {
1939         freeForPublic = freeForPublic_;
1940     }
1941 
1942     function setMaxPerTx(uint256 maxPerTx_) external onlyOwner {
1943         maxPerTx = maxPerTx_;
1944     }
1945 
1946     function _baseURI() internal view virtual override returns (string memory) {
1947         return baseURI;
1948     }
1949 
1950     function withdraw() external onlyOwner nonReentrant {
1951         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1952         require(success, "Transfer failed.");
1953     }
1954 }