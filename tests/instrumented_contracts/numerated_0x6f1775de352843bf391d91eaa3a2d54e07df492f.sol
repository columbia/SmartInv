1 //        _                                                       _                         
2 //       | |                                                     | |                        
3 //   ___ | | ____ _ _   _       _ __ ___   ___   ___  _ __       | |__   ___  __ _ _ __ ___ 
4 //  / _ \| |/ / _` | | | |     | '_ ` _ \ / _ \ / _ \| '_ \      | '_ \ / _ \/ _` | '__/ __|
5 // | (_) |   < (_| | |_| |     | | | | | | (_) | (_) | | | |     | |_) |  __/ (_| | |  \__ \
6 //  \___/|_|\_\__,_|\__, |     |_| |_| |_|\___/ \___/|_| |_|     |_.__/ \___|\__,_|_|  |___/
7 //                   __/ |                                                                  
8 //                  |___/    
9 //
10 // a free mint project <3
11 //
12 // SPDX-License-Identifier: MIT
13 
14 
15 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
16 
17 
18 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
19 
20 pragma solidity ^0.8.0;
21 
22 /**
23  * @dev Interface of the ERC20 standard as defined in the EIP.
24  */
25 interface IERC20 {
26     /**
27      * @dev Returns the amount of tokens in existence.
28      */
29     function totalSupply() external view returns (uint256);
30 
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `to`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address to, uint256 amount) external returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender) external view returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `from` to `to` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(
80         address from,
81         address to,
82         uint256 amount
83     ) external returns (bool);
84 
85     /**
86      * @dev Emitted when `value` tokens are moved from one account (`from`) to
87      * another (`to`).
88      *
89      * Note that `value` may be zero.
90      */
91     event Transfer(address indexed from, address indexed to, uint256 value);
92 
93     /**
94      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
95      * a call to {approve}. `value` is the new allowance.
96      */
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
101 
102 
103 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
104 
105 pragma solidity ^0.8.0;
106 
107 /**
108  * @dev Contract module that helps prevent reentrant calls to a function.
109  *
110  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
111  * available, which can be applied to functions to make sure there are no nested
112  * (reentrant) calls to them.
113  *
114  * Note that because there is a single `nonReentrant` guard, functions marked as
115  * `nonReentrant` may not call one another. This can be worked around by making
116  * those functions `private`, and then adding `external` `nonReentrant` entry
117  * points to them.
118  *
119  * TIP: If you would like to learn more about reentrancy and alternative ways
120  * to protect against it, check out our blog post
121  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
122  */
123 abstract contract ReentrancyGuard {
124     // Booleans are more expensive than uint256 or any type that takes up a full
125     // word because each write operation emits an extra SLOAD to first read the
126     // slot's contents, replace the bits taken up by the boolean, and then write
127     // back. This is the compiler's defense against contract upgrades and
128     // pointer aliasing, and it cannot be disabled.
129 
130     // The values being non-zero value makes deployment a bit more expensive,
131     // but in exchange the refund on every call to nonReentrant will be lower in
132     // amount. Since refunds are capped to a percentage of the total
133     // transaction's gas, it is best to keep them low in cases like this one, to
134     // increase the likelihood of the full refund coming into effect.
135     uint256 private constant _NOT_ENTERED = 1;
136     uint256 private constant _ENTERED = 2;
137 
138     uint256 private _status;
139 
140     constructor() {
141         _status = _NOT_ENTERED;
142     }
143 
144     /**
145      * @dev Prevents a contract from calling itself, directly or indirectly.
146      * Calling a `nonReentrant` function from another `nonReentrant`
147      * function is not supported. It is possible to prevent this from happening
148      * by making the `nonReentrant` function external, and making it call a
149      * `private` function that does the actual work.
150      */
151     modifier nonReentrant() {
152         // On the first call to nonReentrant, _notEntered will be true
153         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
154 
155         // Any calls to nonReentrant after this point will fail
156         _status = _ENTERED;
157 
158         _;
159 
160         // By storing the original value once again, a refund is triggered (see
161         // https://eips.ethereum.org/EIPS/eip-2200)
162         _status = _NOT_ENTERED;
163     }
164 }
165 
166 // File: @openzeppelin/contracts/utils/Strings.sol
167 
168 
169 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
170 
171 pragma solidity ^0.8.0;
172 
173 /**
174  * @dev String operations.
175  */
176 library Strings {
177     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
178 
179     /**
180      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
181      */
182     function toString(uint256 value) internal pure returns (string memory) {
183         // Inspired by OraclizeAPI's implementation - MIT licence
184         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
185 
186         if (value == 0) {
187             return "0";
188         }
189         uint256 temp = value;
190         uint256 digits;
191         while (temp != 0) {
192             digits++;
193             temp /= 10;
194         }
195         bytes memory buffer = new bytes(digits);
196         while (value != 0) {
197             digits -= 1;
198             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
199             value /= 10;
200         }
201         return string(buffer);
202     }
203 
204     /**
205      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
206      */
207     function toHexString(uint256 value) internal pure returns (string memory) {
208         if (value == 0) {
209             return "0x00";
210         }
211         uint256 temp = value;
212         uint256 length = 0;
213         while (temp != 0) {
214             length++;
215             temp >>= 8;
216         }
217         return toHexString(value, length);
218     }
219 
220     /**
221      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
222      */
223     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
224         bytes memory buffer = new bytes(2 * length + 2);
225         buffer[0] = "0";
226         buffer[1] = "x";
227         for (uint256 i = 2 * length + 1; i > 1; --i) {
228             buffer[i] = _HEX_SYMBOLS[value & 0xf];
229             value >>= 4;
230         }
231         require(value == 0, "Strings: hex length insufficient");
232         return string(buffer);
233     }
234 }
235 
236 // File: @openzeppelin/contracts/utils/Context.sol
237 
238 
239 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
240 
241 pragma solidity ^0.8.0;
242 
243 /**
244  * @dev Provides information about the current execution context, including the
245  * sender of the transaction and its data. While these are generally available
246  * via msg.sender and msg.data, they should not be accessed in such a direct
247  * manner, since when dealing with meta-transactions the account sending and
248  * paying for execution may not be the actual sender (as far as an application
249  * is concerned).
250  *
251  * This contract is only required for intermediate, library-like contracts.
252  */
253 abstract contract Context {
254     function _msgSender() internal view virtual returns (address) {
255         return msg.sender;
256     }
257 
258     function _msgData() internal view virtual returns (bytes calldata) {
259         return msg.data;
260     }
261 }
262 
263 // File: @openzeppelin/contracts/access/Ownable.sol
264 
265 
266 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
267 
268 pragma solidity ^0.8.0;
269 
270 
271 /**
272  * @dev Contract module which provides a basic access control mechanism, where
273  * there is an account (an owner) that can be granted exclusive access to
274  * specific functions.
275  *
276  * By default, the owner account will be the one that deploys the contract. This
277  * can later be changed with {transferOwnership}.
278  *
279  * This module is used through inheritance. It will make available the modifier
280  * `onlyOwner`, which can be applied to your functions to restrict their use to
281  * the owner.
282  */
283 abstract contract Ownable is Context {
284     address private _owner;
285 
286     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
287 
288     /**
289      * @dev Initializes the contract setting the deployer as the initial owner.
290      */
291     constructor() {
292         _transferOwnership(_msgSender());
293     }
294 
295     /**
296      * @dev Returns the address of the current owner.
297      */
298     function owner() public view virtual returns (address) {
299         return _owner;
300     }
301 
302     /**
303      * @dev Throws if called by any account other than the owner.
304      */
305     modifier onlyOwner() {
306         require(owner() == _msgSender(), "Ownable: caller is not the owner");
307         _;
308     }
309 
310     /**
311      * @dev Leaves the contract without owner. It will not be possible to call
312      * `onlyOwner` functions anymore. Can only be called by the current owner.
313      *
314      * NOTE: Renouncing ownership will leave the contract without an owner,
315      * thereby removing any functionality that is only available to the owner.
316      */
317     function renounceOwnership() public virtual onlyOwner {
318         _transferOwnership(address(0));
319     }
320 
321     /**
322      * @dev Transfers ownership of the contract to a new account (`newOwner`).
323      * Can only be called by the current owner.
324      */
325     function transferOwnership(address newOwner) public virtual onlyOwner {
326         require(newOwner != address(0), "Ownable: new owner is the zero address");
327         _transferOwnership(newOwner);
328     }
329 
330     /**
331      * @dev Transfers ownership of the contract to a new account (`newOwner`).
332      * Internal function without access restriction.
333      */
334     function _transferOwnership(address newOwner) internal virtual {
335         address oldOwner = _owner;
336         _owner = newOwner;
337         emit OwnershipTransferred(oldOwner, newOwner);
338     }
339 }
340 
341 // File: @openzeppelin/contracts/utils/Address.sol
342 
343 
344 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
345 
346 pragma solidity ^0.8.1;
347 
348 /**
349  * @dev Collection of functions related to the address type
350  */
351 library Address {
352     /**
353      * @dev Returns true if `account` is a contract.
354      *
355      * [IMPORTANT]
356      * ====
357      * It is unsafe to assume that an address for which this function returns
358      * false is an externally-owned account (EOA) and not a contract.
359      *
360      * Among others, `isContract` will return false for the following
361      * types of addresses:
362      *
363      *  - an externally-owned account
364      *  - a contract in construction
365      *  - an address where a contract will be created
366      *  - an address where a contract lived, but was destroyed
367      * ====
368      *
369      * [IMPORTANT]
370      * ====
371      * You shouldn't rely on `isContract` to protect against flash loan attacks!
372      *
373      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
374      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
375      * constructor.
376      * ====
377      */
378     function isContract(address account) internal view returns (bool) {
379         // This method relies on extcodesize/address.code.length, which returns 0
380         // for contracts in construction, since the code is only stored at the end
381         // of the constructor execution.
382 
383         return account.code.length > 0;
384     }
385 
386     /**
387      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
388      * `recipient`, forwarding all available gas and reverting on errors.
389      *
390      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
391      * of certain opcodes, possibly making contracts go over the 2300 gas limit
392      * imposed by `transfer`, making them unable to receive funds via
393      * `transfer`. {sendValue} removes this limitation.
394      *
395      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
396      *
397      * IMPORTANT: because control is transferred to `recipient`, care must be
398      * taken to not create reentrancy vulnerabilities. Consider using
399      * {ReentrancyGuard} or the
400      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
401      */
402     function sendValue(address payable recipient, uint256 amount) internal {
403         require(address(this).balance >= amount, "Address: insufficient balance");
404 
405         (bool success, ) = recipient.call{value: amount}("");
406         require(success, "Address: unable to send value, recipient may have reverted");
407     }
408 
409     /**
410      * @dev Performs a Solidity function call using a low level `call`. A
411      * plain `call` is an unsafe replacement for a function call: use this
412      * function instead.
413      *
414      * If `target` reverts with a revert reason, it is bubbled up by this
415      * function (like regular Solidity function calls).
416      *
417      * Returns the raw returned data. To convert to the expected return value,
418      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
419      *
420      * Requirements:
421      *
422      * - `target` must be a contract.
423      * - calling `target` with `data` must not revert.
424      *
425      * _Available since v3.1._
426      */
427     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
428         return functionCall(target, data, "Address: low-level call failed");
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
433      * `errorMessage` as a fallback revert reason when `target` reverts.
434      *
435      * _Available since v3.1._
436      */
437     function functionCall(
438         address target,
439         bytes memory data,
440         string memory errorMessage
441     ) internal returns (bytes memory) {
442         return functionCallWithValue(target, data, 0, errorMessage);
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
447      * but also transferring `value` wei to `target`.
448      *
449      * Requirements:
450      *
451      * - the calling contract must have an ETH balance of at least `value`.
452      * - the called Solidity function must be `payable`.
453      *
454      * _Available since v3.1._
455      */
456     function functionCallWithValue(
457         address target,
458         bytes memory data,
459         uint256 value
460     ) internal returns (bytes memory) {
461         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
462     }
463 
464     /**
465      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
466      * with `errorMessage` as a fallback revert reason when `target` reverts.
467      *
468      * _Available since v3.1._
469      */
470     function functionCallWithValue(
471         address target,
472         bytes memory data,
473         uint256 value,
474         string memory errorMessage
475     ) internal returns (bytes memory) {
476         require(address(this).balance >= value, "Address: insufficient balance for call");
477         require(isContract(target), "Address: call to non-contract");
478 
479         (bool success, bytes memory returndata) = target.call{value: value}(data);
480         return verifyCallResult(success, returndata, errorMessage);
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
485      * but performing a static call.
486      *
487      * _Available since v3.3._
488      */
489     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
490         return functionStaticCall(target, data, "Address: low-level static call failed");
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
495      * but performing a static call.
496      *
497      * _Available since v3.3._
498      */
499     function functionStaticCall(
500         address target,
501         bytes memory data,
502         string memory errorMessage
503     ) internal view returns (bytes memory) {
504         require(isContract(target), "Address: static call to non-contract");
505 
506         (bool success, bytes memory returndata) = target.staticcall(data);
507         return verifyCallResult(success, returndata, errorMessage);
508     }
509 
510     /**
511      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
512      * but performing a delegate call.
513      *
514      * _Available since v3.4._
515      */
516     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
517         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
522      * but performing a delegate call.
523      *
524      * _Available since v3.4._
525      */
526     function functionDelegateCall(
527         address target,
528         bytes memory data,
529         string memory errorMessage
530     ) internal returns (bytes memory) {
531         require(isContract(target), "Address: delegate call to non-contract");
532 
533         (bool success, bytes memory returndata) = target.delegatecall(data);
534         return verifyCallResult(success, returndata, errorMessage);
535     }
536 
537     /**
538      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
539      * revert reason using the provided one.
540      *
541      * _Available since v4.3._
542      */
543     function verifyCallResult(
544         bool success,
545         bytes memory returndata,
546         string memory errorMessage
547     ) internal pure returns (bytes memory) {
548         if (success) {
549             return returndata;
550         } else {
551             // Look for revert reason and bubble it up if present
552             if (returndata.length > 0) {
553                 // The easiest way to bubble the revert reason is using memory via assembly
554 
555                 assembly {
556                     let returndata_size := mload(returndata)
557                     revert(add(32, returndata), returndata_size)
558                 }
559             } else {
560                 revert(errorMessage);
561             }
562         }
563     }
564 }
565 
566 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
567 
568 
569 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
570 
571 pragma solidity ^0.8.0;
572 
573 
574 
575 /**
576  * @title SafeERC20
577  * @dev Wrappers around ERC20 operations that throw on failure (when the token
578  * contract returns false). Tokens that return no value (and instead revert or
579  * throw on failure) are also supported, non-reverting calls are assumed to be
580  * successful.
581  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
582  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
583  */
584 library SafeERC20 {
585     using Address for address;
586 
587     function safeTransfer(
588         IERC20 token,
589         address to,
590         uint256 value
591     ) internal {
592         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
593     }
594 
595     function safeTransferFrom(
596         IERC20 token,
597         address from,
598         address to,
599         uint256 value
600     ) internal {
601         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
602     }
603 
604     /**
605      * @dev Deprecated. This function has issues similar to the ones found in
606      * {IERC20-approve}, and its usage is discouraged.
607      *
608      * Whenever possible, use {safeIncreaseAllowance} and
609      * {safeDecreaseAllowance} instead.
610      */
611     function safeApprove(
612         IERC20 token,
613         address spender,
614         uint256 value
615     ) internal {
616         // safeApprove should only be called when setting an initial allowance,
617         // or when resetting it to zero. To increase and decrease it, use
618         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
619         require(
620             (value == 0) || (token.allowance(address(this), spender) == 0),
621             "SafeERC20: approve from non-zero to non-zero allowance"
622         );
623         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
624     }
625 
626     function safeIncreaseAllowance(
627         IERC20 token,
628         address spender,
629         uint256 value
630     ) internal {
631         uint256 newAllowance = token.allowance(address(this), spender) + value;
632         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
633     }
634 
635     function safeDecreaseAllowance(
636         IERC20 token,
637         address spender,
638         uint256 value
639     ) internal {
640         unchecked {
641             uint256 oldAllowance = token.allowance(address(this), spender);
642             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
643             uint256 newAllowance = oldAllowance - value;
644             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
645         }
646     }
647 
648     /**
649      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
650      * on the return value: the return value is optional (but if data is returned, it must not be false).
651      * @param token The token targeted by the call.
652      * @param data The call data (encoded using abi.encode or one of its variants).
653      */
654     function _callOptionalReturn(IERC20 token, bytes memory data) private {
655         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
656         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
657         // the target address contains contract code and also asserts for success in the low-level call.
658 
659         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
660         if (returndata.length > 0) {
661             // Return data is optional
662             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
663         }
664     }
665 }
666 
667 
668 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
669 
670 
671 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
672 
673 pragma solidity ^0.8.0;
674 
675 /**
676  * @title ERC721 token receiver interface
677  * @dev Interface for any contract that wants to support safeTransfers
678  * from ERC721 asset contracts.
679  */
680 interface IERC721Receiver {
681     /**
682      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
683      * by `operator` from `from`, this function is called.
684      *
685      * It must return its Solidity selector to confirm the token transfer.
686      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
687      *
688      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
689      */
690     function onERC721Received(
691         address operator,
692         address from,
693         uint256 tokenId,
694         bytes calldata data
695     ) external returns (bytes4);
696 }
697 
698 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
699 
700 
701 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
702 
703 pragma solidity ^0.8.0;
704 
705 /**
706  * @dev Interface of the ERC165 standard, as defined in the
707  * https://eips.ethereum.org/EIPS/eip-165[EIP].
708  *
709  * Implementers can declare support of contract interfaces, which can then be
710  * queried by others ({ERC165Checker}).
711  *
712  * For an implementation, see {ERC165}.
713  */
714 interface IERC165 {
715     /**
716      * @dev Returns true if this contract implements the interface defined by
717      * `interfaceId`. See the corresponding
718      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
719      * to learn more about how these ids are created.
720      *
721      * This function call must use less than 30 000 gas.
722      */
723     function supportsInterface(bytes4 interfaceId) external view returns (bool);
724 }
725 
726 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
727 
728 
729 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
730 
731 pragma solidity ^0.8.0;
732 
733 
734 /**
735  * @dev Implementation of the {IERC165} interface.
736  *
737  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
738  * for the additional interface id that will be supported. For example:
739  *
740  * ```solidity
741  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
742  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
743  * }
744  * ```
745  *
746  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
747  */
748 abstract contract ERC165 is IERC165 {
749     /**
750      * @dev See {IERC165-supportsInterface}.
751      */
752     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
753         return interfaceId == type(IERC165).interfaceId;
754     }
755 }
756 
757 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
758 
759 
760 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
761 
762 pragma solidity ^0.8.0;
763 
764 
765 /**
766  * @dev Required interface of an ERC721 compliant contract.
767  */
768 interface IERC721 is IERC165 {
769     /**
770      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
771      */
772     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
773 
774     /**
775      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
776      */
777     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
778 
779     /**
780      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
781      */
782     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
783 
784     /**
785      * @dev Returns the number of tokens in ``owner``'s account.
786      */
787     function balanceOf(address owner) external view returns (uint256 balance);
788 
789     /**
790      * @dev Returns the owner of the `tokenId` token.
791      *
792      * Requirements:
793      *
794      * - `tokenId` must exist.
795      */
796     function ownerOf(uint256 tokenId) external view returns (address owner);
797 
798     /**
799      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
800      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
801      *
802      * Requirements:
803      *
804      * - `from` cannot be the zero address.
805      * - `to` cannot be the zero address.
806      * - `tokenId` token must exist and be owned by `from`.
807      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
808      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
809      *
810      * Emits a {Transfer} event.
811      */
812     function safeTransferFrom(
813         address from,
814         address to,
815         uint256 tokenId
816     ) external;
817 
818     /**
819      * @dev Transfers `tokenId` token from `from` to `to`.
820      *
821      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
822      *
823      * Requirements:
824      *
825      * - `from` cannot be the zero address.
826      * - `to` cannot be the zero address.
827      * - `tokenId` token must be owned by `from`.
828      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
829      *
830      * Emits a {Transfer} event.
831      */
832     function transferFrom(
833         address from,
834         address to,
835         uint256 tokenId
836     ) external;
837 
838     /**
839      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
840      * The approval is cleared when the token is transferred.
841      *
842      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
843      *
844      * Requirements:
845      *
846      * - The caller must own the token or be an approved operator.
847      * - `tokenId` must exist.
848      *
849      * Emits an {Approval} event.
850      */
851     function approve(address to, uint256 tokenId) external;
852 
853     /**
854      * @dev Returns the account approved for `tokenId` token.
855      *
856      * Requirements:
857      *
858      * - `tokenId` must exist.
859      */
860     function getApproved(uint256 tokenId) external view returns (address operator);
861 
862     /**
863      * @dev Approve or remove `operator` as an operator for the caller.
864      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
865      *
866      * Requirements:
867      *
868      * - The `operator` cannot be the caller.
869      *
870      * Emits an {ApprovalForAll} event.
871      */
872     function setApprovalForAll(address operator, bool _approved) external;
873 
874     /**
875      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
876      *
877      * See {setApprovalForAll}
878      */
879     function isApprovedForAll(address owner, address operator) external view returns (bool);
880 
881     /**
882      * @dev Safely transfers `tokenId` token from `from` to `to`.
883      *
884      * Requirements:
885      *
886      * - `from` cannot be the zero address.
887      * - `to` cannot be the zero address.
888      * - `tokenId` token must exist and be owned by `from`.
889      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
890      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
891      *
892      * Emits a {Transfer} event.
893      */
894     function safeTransferFrom(
895         address from,
896         address to,
897         uint256 tokenId,
898         bytes calldata data
899     ) external;
900 }
901 
902 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
903 
904 
905 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
906 
907 pragma solidity ^0.8.0;
908 
909 
910 /**
911  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
912  * @dev See https://eips.ethereum.org/EIPS/eip-721
913  */
914 interface IERC721Enumerable is IERC721 {
915     /**
916      * @dev Returns the total amount of tokens stored by the contract.
917      */
918     function totalSupply() external view returns (uint256);
919 
920     /**
921      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
922      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
923      */
924     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
925 
926     /**
927      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
928      * Use along with {totalSupply} to enumerate all tokens.
929      */
930     function tokenByIndex(uint256 index) external view returns (uint256);
931 }
932 
933 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
934 
935 
936 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
937 
938 pragma solidity ^0.8.0;
939 
940 
941 /**
942  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
943  * @dev See https://eips.ethereum.org/EIPS/eip-721
944  */
945 interface IERC721Metadata is IERC721 {
946     /**
947      * @dev Returns the token collection name.
948      */
949     function name() external view returns (string memory);
950 
951     /**
952      * @dev Returns the token collection symbol.
953      */
954     function symbol() external view returns (string memory);
955 
956     /**
957      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
958      */
959     function tokenURI(uint256 tokenId) external view returns (string memory);
960 }
961 
962 // File: contracts/TwistedToonz.sol
963 
964 
965 // Creator: Chiru Labs
966 
967 pragma solidity ^0.8.0;
968 
969 
970 
971 
972 
973 
974 
975 
976 
977 /**
978  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
979  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
980  *
981  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
982  *
983  * Does not support burning tokens to address(0).
984  *
985  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
986  */
987 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
988     using Address for address;
989     using Strings for uint256;
990 
991     struct TokenOwnership {
992         address addr;
993         uint64 startTimestamp;
994     }
995 
996     struct AddressData {
997         uint128 balance;
998         uint128 numberMinted;
999     }
1000 
1001     uint256 internal currentIndex;
1002 
1003     // Token name
1004     string private _name;
1005 
1006     // Token symbol
1007     string private _symbol;
1008 
1009     // Mapping from token ID to ownership details
1010     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1011     mapping(uint256 => TokenOwnership) internal _ownerships;
1012 
1013     // Mapping owner address to address data
1014     mapping(address => AddressData) private _addressData;
1015 
1016     // Mapping from token ID to approved address
1017     mapping(uint256 => address) private _tokenApprovals;
1018 
1019     // Mapping from owner to operator approvals
1020     mapping(address => mapping(address => bool)) private _operatorApprovals;
1021 
1022     constructor(string memory name_, string memory symbol_) {
1023         _name = name_;
1024         _symbol = symbol_;
1025     }
1026 
1027     /**
1028      * @dev See {IERC721Enumerable-totalSupply}.
1029      */
1030     function totalSupply() public view override returns (uint256) {
1031         return currentIndex;
1032     }
1033 
1034     /**
1035      * @dev See {IERC721Enumerable-tokenByIndex}.
1036      */
1037     function tokenByIndex(uint256 index) public view override returns (uint256) {
1038         require(index < totalSupply(), "ERC721A: global index out of bounds");
1039         return index;
1040     }
1041 
1042     /**
1043      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1044      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1045      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1046      */
1047     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1048         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1049         uint256 numMintedSoFar = totalSupply();
1050         uint256 tokenIdsIdx;
1051         address currOwnershipAddr;
1052 
1053         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1054         unchecked {
1055             for (uint256 i; i < numMintedSoFar; i++) {
1056                 TokenOwnership memory ownership = _ownerships[i];
1057                 if (ownership.addr != address(0)) {
1058                     currOwnershipAddr = ownership.addr;
1059                 }
1060                 if (currOwnershipAddr == owner) {
1061                     if (tokenIdsIdx == index) {
1062                         return i;
1063                     }
1064                     tokenIdsIdx++;
1065                 }
1066             }
1067         }
1068 
1069         revert("ERC721A: unable to get token of owner by index");
1070     }
1071 
1072     /**
1073      * @dev See {IERC165-supportsInterface}.
1074      */
1075     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1076         return
1077             interfaceId == type(IERC721).interfaceId ||
1078             interfaceId == type(IERC721Metadata).interfaceId ||
1079             interfaceId == type(IERC721Enumerable).interfaceId ||
1080             super.supportsInterface(interfaceId);
1081     }
1082 
1083     /**
1084      * @dev See {IERC721-balanceOf}.
1085      */
1086     function balanceOf(address owner) public view override returns (uint256) {
1087         require(owner != address(0), "ERC721A: balance query for the zero address");
1088         return uint256(_addressData[owner].balance);
1089     }
1090 
1091     function _numberMinted(address owner) internal view returns (uint256) {
1092         require(owner != address(0), "ERC721A: number minted query for the zero address");
1093         return uint256(_addressData[owner].numberMinted);
1094     }
1095 
1096     /**
1097      * Gas spent here starts off proportional to the maximum mint batch size.
1098      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1099      */
1100     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1101         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1102 
1103         unchecked {
1104             for (uint256 curr = tokenId; curr >= 0; curr--) {
1105                 TokenOwnership memory ownership = _ownerships[curr];
1106                 if (ownership.addr != address(0)) {
1107                     return ownership;
1108                 }
1109             }
1110         }
1111 
1112         revert("ERC721A: unable to determine the owner of token");
1113     }
1114 
1115     /**
1116      * @dev See {IERC721-ownerOf}.
1117      */
1118     function ownerOf(uint256 tokenId) public view override returns (address) {
1119         return ownershipOf(tokenId).addr;
1120     }
1121 
1122     /**
1123      * @dev See {IERC721Metadata-name}.
1124      */
1125     function name() public view virtual override returns (string memory) {
1126         return _name;
1127     }
1128 
1129     /**
1130      * @dev See {IERC721Metadata-symbol}.
1131      */
1132     function symbol() public view virtual override returns (string memory) {
1133         return _symbol;
1134     }
1135 
1136     /**
1137      * @dev See {IERC721Metadata-tokenURI}.
1138      */
1139     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1140         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1141 
1142         string memory baseURI = _baseURI();
1143         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1144     }
1145 
1146     /**
1147      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1148      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1149      * by default, can be overriden in child contracts.
1150      */
1151     function _baseURI() internal view virtual returns (string memory) {
1152         return "";
1153     }
1154 
1155     /**
1156      * @dev See {IERC721-approve}.
1157      */
1158     function approve(address to, uint256 tokenId) public override {
1159         address owner = ERC721A.ownerOf(tokenId);
1160         require(to != owner, "ERC721A: approval to current owner");
1161 
1162         require(
1163             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1164             "ERC721A: approve caller is not owner nor approved for all"
1165         );
1166 
1167         _approve(to, tokenId, owner);
1168     }
1169 
1170     /**
1171      * @dev See {IERC721-getApproved}.
1172      */
1173     function getApproved(uint256 tokenId) public view override returns (address) {
1174         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1175 
1176         return _tokenApprovals[tokenId];
1177     }
1178 
1179     /**
1180      * @dev See {IERC721-setApprovalForAll}.
1181      */
1182     function setApprovalForAll(address operator, bool approved) public override {
1183         require(operator != _msgSender(), "ERC721A: approve to caller");
1184 
1185         _operatorApprovals[_msgSender()][operator] = approved;
1186         emit ApprovalForAll(_msgSender(), operator, approved);
1187     }
1188 
1189     /**
1190      * @dev See {IERC721-isApprovedForAll}.
1191      */
1192     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1193         return _operatorApprovals[owner][operator];
1194     }
1195 
1196     /**
1197      * @dev See {IERC721-transferFrom}.
1198      */
1199     function transferFrom(
1200         address from,
1201         address to,
1202         uint256 tokenId
1203     ) public virtual override {
1204         _transfer(from, to, tokenId);
1205     }
1206 
1207     /**
1208      * @dev See {IERC721-safeTransferFrom}.
1209      */
1210     function safeTransferFrom(
1211         address from,
1212         address to,
1213         uint256 tokenId
1214     ) public virtual override {
1215         safeTransferFrom(from, to, tokenId, "");
1216     }
1217 
1218     /**
1219      * @dev See {IERC721-safeTransferFrom}.
1220      */
1221     function safeTransferFrom(
1222         address from,
1223         address to,
1224         uint256 tokenId,
1225         bytes memory _data
1226     ) public override {
1227         _transfer(from, to, tokenId);
1228         require(
1229             _checkOnERC721Received(from, to, tokenId, _data),
1230             "ERC721A: transfer to non ERC721Receiver implementer"
1231         );
1232     }
1233 
1234     /**
1235      * @dev Returns whether `tokenId` exists.
1236      *
1237      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1238      *
1239      * Tokens start existing when they are minted (`_mint`),
1240      */
1241     function _exists(uint256 tokenId) internal view returns (bool) {
1242         return tokenId < currentIndex;
1243     }
1244 
1245     function _safeMint(address to, uint256 quantity) internal {
1246         _safeMint(to, quantity, "");
1247     }
1248 
1249     /**
1250      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1251      *
1252      * Requirements:
1253      *
1254      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1255      * - `quantity` must be greater than 0.
1256      *
1257      * Emits a {Transfer} event.
1258      */
1259     function _safeMint(
1260         address to,
1261         uint256 quantity,
1262         bytes memory _data
1263     ) internal {
1264         _mint(to, quantity, _data, true);
1265     }
1266 
1267     /**
1268      * @dev Mints `quantity` tokens and transfers them to `to`.
1269      *
1270      * Requirements:
1271      *
1272      * - `to` cannot be the zero address.
1273      * - `quantity` must be greater than 0.
1274      *
1275      * Emits a {Transfer} event.
1276      */
1277     function _mint(
1278         address to,
1279         uint256 quantity,
1280         bytes memory _data,
1281         bool safe
1282     ) internal {
1283         uint256 startTokenId = currentIndex;
1284         require(to != address(0), "ERC721A: mint to the zero address");
1285         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1286 
1287         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1288 
1289         // Overflows are incredibly unrealistic.
1290         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1291         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1292         unchecked {
1293             _addressData[to].balance += uint128(quantity);
1294             _addressData[to].numberMinted += uint128(quantity);
1295 
1296             _ownerships[startTokenId].addr = to;
1297             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1298 
1299             uint256 updatedIndex = startTokenId;
1300 
1301             for (uint256 i; i < quantity; i++) {
1302                 emit Transfer(address(0), to, updatedIndex);
1303                 if (safe) {
1304                     require(
1305                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1306                         "ERC721A: transfer to non ERC721Receiver implementer"
1307                     );
1308                 }
1309 
1310                 updatedIndex++;
1311             }
1312 
1313             currentIndex = updatedIndex;
1314         }
1315 
1316         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1317     }
1318 
1319     /**
1320      * @dev Transfers `tokenId` from `from` to `to`.
1321      *
1322      * Requirements:
1323      *
1324      * - `to` cannot be the zero address.
1325      * - `tokenId` token must be owned by `from`.
1326      *
1327      * Emits a {Transfer} event.
1328      */
1329     function _transfer(
1330         address from,
1331         address to,
1332         uint256 tokenId
1333     ) private {
1334         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1335 
1336         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1337             getApproved(tokenId) == _msgSender() ||
1338             isApprovedForAll(prevOwnership.addr, _msgSender()));
1339 
1340         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1341 
1342         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1343         require(to != address(0), "ERC721A: transfer to the zero address");
1344 
1345         _beforeTokenTransfers(from, to, tokenId, 1);
1346 
1347         // Clear approvals from the previous owner
1348         _approve(address(0), tokenId, prevOwnership.addr);
1349 
1350         // Underflow of the sender's balance is impossible because we check for
1351         // ownership above and the recipient's balance can't realistically overflow.
1352         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1353         unchecked {
1354             _addressData[from].balance -= 1;
1355             _addressData[to].balance += 1;
1356 
1357             _ownerships[tokenId].addr = to;
1358             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1359 
1360             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1361             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1362             uint256 nextTokenId = tokenId + 1;
1363             if (_ownerships[nextTokenId].addr == address(0)) {
1364                 if (_exists(nextTokenId)) {
1365                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1366                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1367                 }
1368             }
1369         }
1370 
1371         emit Transfer(from, to, tokenId);
1372         _afterTokenTransfers(from, to, tokenId, 1);
1373     }
1374 
1375     /**
1376      * @dev Approve `to` to operate on `tokenId`
1377      *
1378      * Emits a {Approval} event.
1379      */
1380     function _approve(
1381         address to,
1382         uint256 tokenId,
1383         address owner
1384     ) private {
1385         _tokenApprovals[tokenId] = to;
1386         emit Approval(owner, to, tokenId);
1387     }
1388 
1389     /**
1390      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1391      * The call is not executed if the target address is not a contract.
1392      *
1393      * @param from address representing the previous owner of the given token ID
1394      * @param to target address that will receive the tokens
1395      * @param tokenId uint256 ID of the token to be transferred
1396      * @param _data bytes optional data to send along with the call
1397      * @return bool whether the call correctly returned the expected magic value
1398      */
1399     function _checkOnERC721Received(
1400         address from,
1401         address to,
1402         uint256 tokenId,
1403         bytes memory _data
1404     ) private returns (bool) {
1405         if (to.isContract()) {
1406             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1407                 return retval == IERC721Receiver(to).onERC721Received.selector;
1408             } catch (bytes memory reason) {
1409                 if (reason.length == 0) {
1410                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1411                 } else {
1412                     assembly {
1413                         revert(add(32, reason), mload(reason))
1414                     }
1415                 }
1416             }
1417         } else {
1418             return true;
1419         }
1420     }
1421 
1422     /**
1423      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1424      *
1425      * startTokenId - the first token id to be transferred
1426      * quantity - the amount to be transferred
1427      *
1428      * Calling conditions:
1429      *
1430      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1431      * transferred to `to`.
1432      * - When `from` is zero, `tokenId` will be minted for `to`.
1433      */
1434     function _beforeTokenTransfers(
1435         address from,
1436         address to,
1437         uint256 startTokenId,
1438         uint256 quantity
1439     ) internal virtual {}
1440 
1441     /**
1442      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1443      * minting.
1444      *
1445      * startTokenId - the first token id to be transferred
1446      * quantity - the amount to be transferred
1447      *
1448      * Calling conditions:
1449      *
1450      * - when `from` and `to` are both non-zero.
1451      * - `from` and `to` are never both zero.
1452      */
1453     function _afterTokenTransfers(
1454         address from,
1455         address to,
1456         uint256 startTokenId,
1457         uint256 quantity
1458     ) internal virtual {}
1459 }
1460 
1461 contract OkayMoonBears is ERC721A, Ownable, ReentrancyGuard {
1462 
1463   string public        baseURI;
1464   uint public          price             = 0.000 ether;
1465   uint public          maxPerTx          = 1;
1466   uint public          maxPerWallet      = 1;
1467   uint public          totalFree         = 10000;
1468   uint public          maxSupply         = 10000;
1469   uint public          nextOwnerToExplicitlySet;
1470   bool public          mintEnabled;
1471 
1472   constructor() ERC721A("Okay Moon Bears", "OKMB"){}
1473 
1474   function mint(uint256 numberOfTokens) external payable
1475   {
1476     uint cost = price;
1477     if(totalSupply() + numberOfTokens < totalFree + 1) {
1478       cost = 0;
1479     }
1480     require(msg.sender == tx.origin,"who you trying to fool?");
1481     require(msg.value == numberOfTokens * cost,"incorrect amount sent");
1482     require(totalSupply() + numberOfTokens < maxSupply + 1,"sold out!");
1483     require(mintEnabled, "minting is not live");
1484     require(numberMinted(msg.sender) + numberOfTokens <= maxPerWallet,"don't be greedy! too many per wallet requested");
1485     require( numberOfTokens < maxPerTx + 1, "max per tx exceeded");
1486 
1487     _safeMint(msg.sender, numberOfTokens);
1488   }
1489 
1490   function ownerBatchMint(uint256 numberOfTokens) external onlyOwner
1491   {
1492     require(totalSupply() + numberOfTokens < maxSupply + 1,"too many!");
1493 
1494     _safeMint(msg.sender, numberOfTokens);
1495   }
1496 
1497   function toggleMinting() external onlyOwner {
1498       mintEnabled = !mintEnabled;
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