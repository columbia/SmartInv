1 // SPDX-License-Identifier: MIT
2 
3 
4 /**
5              .,'
6                                    .'`.'
7                                   .' .'
8                       _.ood0Pp._ ,'  `.~ .q?00doo._
9                   .od10KAPESnmdb._. . _:db?ASPOOKY0bo.
10                 .?000Pd000DIGITALARTCOLLECTABLE0PP?0000
11               .d0000Pd0000P'  `?0Pd000b?0'  `?000b?0000b.
12              .d0000Pd0000?'     `?d000b?'     `?00b?0000b.                                          
13              d00000PNOROADMAP_NOUTILITY_NOPROMISES_b?0000b
14              ?00000b?0000b?0000b?b    dd00000Pd0000Pd0000P
15              `?0000b?0000b?0000b?0b  dPd00000Pd0000Pd000P'
16               `?0000b?0000b?0000b?0bd0Pd0000Pd0000Pd000P'
17                 `?000b?00bo.   `?P'  `?P'   .od0Pd000P'
18                   `~?00b?000bo._  .db.  _.od000Pd0P~'
19                       `~?0b?TRICKORTRAITMFERS00PdP~'
20 **/
21 
22 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
23 
24 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
25 
26 pragma solidity ^0.8.0;
27 
28 /**
29  * @dev Interface of the ERC20 standard as defined in the EIP.
30  */
31 interface IERC20 {
32     /**
33      * @dev Returns the amount of tokens in existence.
34      */
35     function totalSupply() external view returns (uint256);
36 
37     /**
38      * @dev Returns the amount of tokens owned by `account`.
39      */
40     function balanceOf(address account) external view returns (uint256);
41 
42     /**
43      * @dev Moves `amount` tokens from the caller's account to `to`.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * Emits a {Transfer} event.
48      */
49     function transfer(address to, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Returns the remaining number of tokens that `spender` will be
53      * allowed to spend on behalf of `owner` through {transferFrom}. This is
54      * zero by default.
55      *
56      * This value changes when {approve} or {transferFrom} are called.
57      */
58     function allowance(address owner, address spender) external view returns (uint256);
59 
60     /**
61      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * IMPORTANT: Beware that changing an allowance with this method brings the risk
66      * that someone may use both the old and the new allowance by unfortunate
67      * transaction ordering. One possible solution to mitigate this race
68      * condition is to first reduce the spender's allowance to 0 and set the
69      * desired value afterwards:
70      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
71      *
72      * Emits an {Approval} event.
73      */
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Moves `amount` tokens from `from` to `to` using the
78      * allowance mechanism. `amount` is then deducted from the caller's
79      * allowance.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transferFrom(
86         address from,
87         address to,
88         uint256 amount
89     ) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
107 
108 
109 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
110 
111 pragma solidity ^0.8.0;
112 
113 /**
114  * @dev Contract module that helps prevent reentrant calls to a function.
115  *
116  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
117  * available, which can be applied to functions to make sure there are no nested
118  * (reentrant) calls to them.
119  *
120  * Note that because there is a single `nonReentrant` guard, functions marked as
121  * `nonReentrant` may not call one another. This can be worked around by making
122  * those functions `private`, and then adding `external` `nonReentrant` entry
123  * points to them.
124  *
125  * TIP: If you would like to learn more about reentrancy and alternative ways
126  * to protect against it, check out our blog post
127  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
128  */
129 abstract contract ReentrancyGuard {
130     // Booleans are more expensive than uint256 or any type that takes up a full
131     // word because each write operation emits an extra SLOAD to first read the
132     // slot's contents, replace the bits taken up by the boolean, and then write
133     // back. This is the compiler's defense against contract upgrades and
134     // pointer aliasing, and it cannot be disabled.
135 
136     // The values being non-zero value makes deployment a bit more expensive,
137     // but in exchange the refund on every call to nonReentrant will be lower in
138     // amount. Since refunds are capped to a percentage of the total
139     // transaction's gas, it is best to keep them low in cases like this one, to
140     // increase the likelihood of the full refund coming into effect.
141     uint256 private constant _NOT_ENTERED = 1;
142     uint256 private constant _ENTERED = 2;
143 
144     uint256 private _status;
145 
146     constructor() {
147         _status = _NOT_ENTERED;
148     }
149 
150     /**
151      * @dev Prevents a contract from calling itself, directly or indirectly.
152      * Calling a `nonReentrant` function from another `nonReentrant`
153      * function is not supported. It is possible to prevent this from happening
154      * by making the `nonReentrant` function external, and making it call a
155      * `private` function that does the actual work.
156      */
157     modifier nonReentrant() {
158         // On the first call to nonReentrant, _notEntered will be true
159         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
160 
161         // Any calls to nonReentrant after this point will fail
162         _status = _ENTERED;
163 
164         _;
165 
166         // By storing the original value once again, a refund is triggered (see
167         // https://eips.ethereum.org/EIPS/eip-2200)
168         _status = _NOT_ENTERED;
169     }
170 }
171 
172 // File: @openzeppelin/contracts/utils/Strings.sol
173 
174 
175 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
176 
177 pragma solidity ^0.8.0;
178 
179 /**
180  * @dev String operations.
181  */
182 library Strings {
183     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
184 
185     /**
186      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
187      */
188     function toString(uint256 value) internal pure returns (string memory) {
189         // Inspired by OraclizeAPI's implementation - MIT licence
190         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
191 
192         if (value == 0) {
193             return "0";
194         }
195         uint256 temp = value;
196         uint256 digits;
197         while (temp != 0) {
198             digits++;
199             temp /= 10;
200         }
201         bytes memory buffer = new bytes(digits);
202         while (value != 0) {
203             digits -= 1;
204             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
205             value /= 10;
206         }
207         return string(buffer);
208     }
209 
210     /**
211      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
212      */
213     function toHexString(uint256 value) internal pure returns (string memory) {
214         if (value == 0) {
215             return "0x00";
216         }
217         uint256 temp = value;
218         uint256 length = 0;
219         while (temp != 0) {
220             length++;
221             temp >>= 8;
222         }
223         return toHexString(value, length);
224     }
225 
226     /**
227      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
228      */
229     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
230         bytes memory buffer = new bytes(2 * length + 2);
231         buffer[0] = "0";
232         buffer[1] = "x";
233         for (uint256 i = 2 * length + 1; i > 1; --i) {
234             buffer[i] = _HEX_SYMBOLS[value & 0xf];
235             value >>= 4;
236         }
237         require(value == 0, "Strings: hex length insufficient");
238         return string(buffer);
239     }
240 }
241 
242 // File: @openzeppelin/contracts/utils/Context.sol
243 
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
271 
272 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
273 
274 pragma solidity ^0.8.0;
275 
276 
277 /**
278  * @dev Contract module which provides a basic access control mechanism, where
279  * there is an account (an owner) that can be granted exclusive access to
280  * specific functions.
281  *
282  * By default, the owner account will be the one that deploys the contract. This
283  * can later be changed with {transferOwnership}.
284  *
285  * This module is used through inheritance. It will make available the modifier
286  * `onlyOwner`, which can be applied to your functions to restrict their use to
287  * the owner.
288  */
289 abstract contract Ownable is Context {
290     address private _owner;
291 
292     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
293 
294     /**
295      * @dev Initializes the contract setting the deployer as the initial owner.
296      */
297     constructor() {
298         _transferOwnership(_msgSender());
299     }
300 
301     /**
302      * @dev Returns the address of the current owner.
303      */
304     function owner() public view virtual returns (address) {
305         return _owner;
306     }
307 
308     /**
309      * @dev Throws if called by any account other than the owner.
310      */
311     modifier onlyOwner() {
312         require(owner() == _msgSender(), "Ownable: caller is not the owner");
313         _;
314     }
315 
316     /**
317      * @dev Leaves the contract without owner. It will not be possible to call
318      * `onlyOwner` functions anymore. Can only be called by the current owner.
319      *
320      * NOTE: Renouncing ownership will leave the contract without an owner,
321      * thereby removing any functionality that is only available to the owner.
322      */
323     function renounceOwnership() public virtual onlyOwner {
324         _transferOwnership(address(0));
325     }
326 
327     /**
328      * @dev Transfers ownership of the contract to a new account (`newOwner`).
329      * Can only be called by the current owner.
330      */
331     function transferOwnership(address newOwner) public virtual onlyOwner {
332         require(newOwner != address(0), "Ownable: new owner is the zero address");
333         _transferOwnership(newOwner);
334     }
335 
336     /**
337      * @dev Transfers ownership of the contract to a new account (`newOwner`).
338      * Internal function without access restriction.
339      */
340     function _transferOwnership(address newOwner) internal virtual {
341         address oldOwner = _owner;
342         _owner = newOwner;
343         emit OwnershipTransferred(oldOwner, newOwner);
344     }
345 }
346 
347 // File: @openzeppelin/contracts/utils/Address.sol
348 
349 
350 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
351 
352 pragma solidity ^0.8.1;
353 
354 /**
355  * @dev Collection of functions related to the address type
356  */
357 library Address {
358     /**
359      * @dev Returns true if `account` is a contract.
360      *
361      * [IMPORTANT]
362      * ====
363      * It is unsafe to assume that an address for which this function returns
364      * false is an externally-owned account (EOA) and not a contract.
365      *
366      * Among others, `isContract` will return false for the following
367      * types of addresses:
368      *
369      *  - an externally-owned account
370      *  - a contract in construction
371      *  - an address where a contract will be created
372      *  - an address where a contract lived, but was destroyed
373      * ====
374      *
375      * [IMPORTANT]
376      * ====
377      * You shouldn't rely on `isContract` to protect against flash loan attacks!
378      *
379      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
380      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
381      * constructor.
382      * ====
383      */
384     function isContract(address account) internal view returns (bool) {
385         // This method relies on extcodesize/address.code.length, which returns 0
386         // for contracts in construction, since the code is only stored at the end
387         // of the constructor execution.
388 
389         return account.code.length > 0;
390     }
391 
392     /**
393      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
394      * `recipient`, forwarding all available gas and reverting on errors.
395      *
396      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
397      * of certain opcodes, possibly making contracts go over the 2300 gas limit
398      * imposed by `transfer`, making them unable to receive funds via
399      * `transfer`. {sendValue} removes this limitation.
400      *
401      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
402      *
403      * IMPORTANT: because control is transferred to `recipient`, care must be
404      * taken to not create reentrancy vulnerabilities. Consider using
405      * {ReentrancyGuard} or the
406      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
407      */
408     function sendValue(address payable recipient, uint256 amount) internal {
409         require(address(this).balance >= amount, "Address: insufficient balance");
410 
411         (bool success, ) = recipient.call{value: amount}("");
412         require(success, "Address: unable to send value, recipient may have reverted");
413     }
414 
415     /**
416      * @dev Performs a Solidity function call using a low level `call`. A
417      * plain `call` is an unsafe replacement for a function call: use this
418      * function instead.
419      *
420      * If `target` reverts with a revert reason, it is bubbled up by this
421      * function (like regular Solidity function calls).
422      *
423      * Returns the raw returned data. To convert to the expected return value,
424      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
425      *
426      * Requirements:
427      *
428      * - `target` must be a contract.
429      * - calling `target` with `data` must not revert.
430      *
431      * _Available since v3.1._
432      */
433     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
434         return functionCall(target, data, "Address: low-level call failed");
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
439      * `errorMessage` as a fallback revert reason when `target` reverts.
440      *
441      * _Available since v3.1._
442      */
443     function functionCall(
444         address target,
445         bytes memory data,
446         string memory errorMessage
447     ) internal returns (bytes memory) {
448         return functionCallWithValue(target, data, 0, errorMessage);
449     }
450 
451     /**
452      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
453      * but also transferring `value` wei to `target`.
454      *
455      * Requirements:
456      *
457      * - the calling contract must have an ETH balance of at least `value`.
458      * - the called Solidity function must be `payable`.
459      *
460      * _Available since v3.1._
461      */
462     function functionCallWithValue(
463         address target,
464         bytes memory data,
465         uint256 value
466     ) internal returns (bytes memory) {
467         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
468     }
469 
470     /**
471      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
472      * with `errorMessage` as a fallback revert reason when `target` reverts.
473      *
474      * _Available since v3.1._
475      */
476     function functionCallWithValue(
477         address target,
478         bytes memory data,
479         uint256 value,
480         string memory errorMessage
481     ) internal returns (bytes memory) {
482         require(address(this).balance >= value, "Address: insufficient balance for call");
483         require(isContract(target), "Address: call to non-contract");
484 
485         (bool success, bytes memory returndata) = target.call{value: value}(data);
486         return verifyCallResult(success, returndata, errorMessage);
487     }
488 
489     /**
490      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
491      * but performing a static call.
492      *
493      * _Available since v3.3._
494      */
495     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
496         return functionStaticCall(target, data, "Address: low-level static call failed");
497     }
498 
499     /**
500      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
501      * but performing a static call.
502      *
503      * _Available since v3.3._
504      */
505     function functionStaticCall(
506         address target,
507         bytes memory data,
508         string memory errorMessage
509     ) internal view returns (bytes memory) {
510         require(isContract(target), "Address: static call to non-contract");
511 
512         (bool success, bytes memory returndata) = target.staticcall(data);
513         return verifyCallResult(success, returndata, errorMessage);
514     }
515 
516     /**
517      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
518      * but performing a delegate call.
519      *
520      * _Available since v3.4._
521      */
522     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
523         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
524     }
525 
526     /**
527      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
528      * but performing a delegate call.
529      *
530      * _Available since v3.4._
531      */
532     function functionDelegateCall(
533         address target,
534         bytes memory data,
535         string memory errorMessage
536     ) internal returns (bytes memory) {
537         require(isContract(target), "Address: delegate call to non-contract");
538 
539         (bool success, bytes memory returndata) = target.delegatecall(data);
540         return verifyCallResult(success, returndata, errorMessage);
541     }
542 
543     /**
544      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
545      * revert reason using the provided one.
546      *
547      * _Available since v4.3._
548      */
549     function verifyCallResult(
550         bool success,
551         bytes memory returndata,
552         string memory errorMessage
553     ) internal pure returns (bytes memory) {
554         if (success) {
555             return returndata;
556         } else {
557             // Look for revert reason and bubble it up if present
558             if (returndata.length > 0) {
559                 // The easiest way to bubble the revert reason is using memory via assembly
560 
561                 assembly {
562                     let returndata_size := mload(returndata)
563                     revert(add(32, returndata), returndata_size)
564                 }
565             } else {
566                 revert(errorMessage);
567             }
568         }
569     }
570 }
571 
572 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
573 
574 
575 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
576 
577 pragma solidity ^0.8.0;
578 
579 
580 
581 /**
582  * @title SafeERC20
583  * @dev Wrappers around ERC20 operations that throw on failure (when the token
584  * contract returns false). Tokens that return no value (and instead revert or
585  * throw on failure) are also supported, non-reverting calls are assumed to be
586  * successful.
587  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
588  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
589  */
590 library SafeERC20 {
591     using Address for address;
592 
593     function safeTransfer(
594         IERC20 token,
595         address to,
596         uint256 value
597     ) internal {
598         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
599     }
600 
601     function safeTransferFrom(
602         IERC20 token,
603         address from,
604         address to,
605         uint256 value
606     ) internal {
607         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
608     }
609 
610     /**
611      * @dev Deprecated. This function has issues similar to the ones found in
612      * {IERC20-approve}, and its usage is discouraged.
613      *
614      * Whenever possible, use {safeIncreaseAllowance} and
615      * {safeDecreaseAllowance} instead.
616      */
617     function safeApprove(
618         IERC20 token,
619         address spender,
620         uint256 value
621     ) internal {
622         // safeApprove should only be called when setting an initial allowance,
623         // or when resetting it to zero. To increase and decrease it, use
624         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
625         require(
626             (value == 0) || (token.allowance(address(this), spender) == 0),
627             "SafeERC20: approve from non-zero to non-zero allowance"
628         );
629         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
630     }
631 
632     function safeIncreaseAllowance(
633         IERC20 token,
634         address spender,
635         uint256 value
636     ) internal {
637         uint256 newAllowance = token.allowance(address(this), spender) + value;
638         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
639     }
640 
641     function safeDecreaseAllowance(
642         IERC20 token,
643         address spender,
644         uint256 value
645     ) internal {
646         unchecked {
647             uint256 oldAllowance = token.allowance(address(this), spender);
648             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
649             uint256 newAllowance = oldAllowance - value;
650             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
651         }
652     }
653 
654     /**
655      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
656      * on the return value: the return value is optional (but if data is returned, it must not be false).
657      * @param token The token targeted by the call.
658      * @param data The call data (encoded using abi.encode or one of its variants).
659      */
660     function _callOptionalReturn(IERC20 token, bytes memory data) private {
661         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
662         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
663         // the target address contains contract code and also asserts for success in the low-level call.
664 
665         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
666         if (returndata.length > 0) {
667             // Return data is optional
668             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
669         }
670     }
671 }
672 
673 
674 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
675 
676 
677 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
678 
679 pragma solidity ^0.8.0;
680 
681 /**
682  * @title ERC721 token receiver interface
683  * @dev Interface for any contract that wants to support safeTransfers
684  * from ERC721 asset contracts.
685  */
686 interface IERC721Receiver {
687     /**
688      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
689      * by `operator` from `from`, this function is called.
690      *
691      * It must return its Solidity selector to confirm the token transfer.
692      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
693      *
694      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
695      */
696     function onERC721Received(
697         address operator,
698         address from,
699         uint256 tokenId,
700         bytes calldata data
701     ) external returns (bytes4);
702 }
703 
704 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
705 
706 
707 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
708 
709 pragma solidity ^0.8.0;
710 
711 /**
712  * @dev Interface of the ERC165 standard, as defined in the
713  * https://eips.ethereum.org/EIPS/eip-165[EIP].
714  *
715  * Implementers can declare support of contract interfaces, which can then be
716  * queried by others ({ERC165Checker}).
717  *
718  * For an implementation, see {ERC165}.
719  */
720 interface IERC165 {
721     /**
722      * @dev Returns true if this contract implements the interface defined by
723      * `interfaceId`. See the corresponding
724      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
725      * to learn more about how these ids are created.
726      *
727      * This function call must use less than 30 000 gas.
728      */
729     function supportsInterface(bytes4 interfaceId) external view returns (bool);
730 }
731 
732 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
733 
734 
735 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
736 
737 pragma solidity ^0.8.0;
738 
739 
740 /**
741  * @dev Implementation of the {IERC165} interface.
742  *
743  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
744  * for the additional interface id that will be supported. For example:
745  *
746  * ```solidity
747  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
748  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
749  * }
750  * ```
751  *
752  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
753  */
754 abstract contract ERC165 is IERC165 {
755     /**
756      * @dev See {IERC165-supportsInterface}.
757      */
758     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
759         return interfaceId == type(IERC165).interfaceId;
760     }
761 }
762 
763 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
764 
765 
766 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
767 
768 pragma solidity ^0.8.0;
769 
770 
771 /**
772  * @dev Required interface of an ERC721 compliant contract.
773  */
774 interface IERC721 is IERC165 {
775     /**
776      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
777      */
778     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
779 
780     /**
781      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
782      */
783     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
784 
785     /**
786      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
787      */
788     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
789 
790     /**
791      * @dev Returns the number of tokens in ``owner``'s account.
792      */
793     function balanceOf(address owner) external view returns (uint256 balance);
794 
795     /**
796      * @dev Returns the owner of the `tokenId` token.
797      *
798      * Requirements:
799      *
800      * - `tokenId` must exist.
801      */
802     function ownerOf(uint256 tokenId) external view returns (address owner);
803 
804     /**
805      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
806      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
807      *
808      * Requirements:
809      *
810      * - `from` cannot be the zero address.
811      * - `to` cannot be the zero address.
812      * - `tokenId` token must exist and be owned by `from`.
813      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
814      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
815      *
816      * Emits a {Transfer} event.
817      */
818     function safeTransferFrom(
819         address from,
820         address to,
821         uint256 tokenId
822     ) external;
823 
824     /**
825      * @dev Transfers `tokenId` token from `from` to `to`.
826      *
827      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
828      *
829      * Requirements:
830      *
831      * - `from` cannot be the zero address.
832      * - `to` cannot be the zero address.
833      * - `tokenId` token must be owned by `from`.
834      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
835      *
836      * Emits a {Transfer} event.
837      */
838     function transferFrom(
839         address from,
840         address to,
841         uint256 tokenId
842     ) external;
843 
844     /**
845      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
846      * The approval is cleared when the token is transferred.
847      *
848      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
849      *
850      * Requirements:
851      *
852      * - The caller must own the token or be an approved operator.
853      * - `tokenId` must exist.
854      *
855      * Emits an {Approval} event.
856      */
857     function approve(address to, uint256 tokenId) external;
858 
859     /**
860      * @dev Returns the account approved for `tokenId` token.
861      *
862      * Requirements:
863      *
864      * - `tokenId` must exist.
865      */
866     function getApproved(uint256 tokenId) external view returns (address operator);
867 
868     /**
869      * @dev Approve or remove `operator` as an operator for the caller.
870      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
871      *
872      * Requirements:
873      *
874      * - The `operator` cannot be the caller.
875      *
876      * Emits an {ApprovalForAll} event.
877      */
878     function setApprovalForAll(address operator, bool _approved) external;
879 
880     /**
881      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
882      *
883      * See {setApprovalForAll}
884      */
885     function isApprovedForAll(address owner, address operator) external view returns (bool);
886 
887     /**
888      * @dev Safely transfers `tokenId` token from `from` to `to`.
889      *
890      * Requirements:
891      *
892      * - `from` cannot be the zero address.
893      * - `to` cannot be the zero address.
894      * - `tokenId` token must exist and be owned by `from`.
895      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
896      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
897      *
898      * Emits a {Transfer} event.
899      */
900     function safeTransferFrom(
901         address from,
902         address to,
903         uint256 tokenId,
904         bytes calldata data
905     ) external;
906 }
907 
908 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
909 
910 
911 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
912 
913 pragma solidity ^0.8.0;
914 
915 
916 /**
917  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
918  * @dev See https://eips.ethereum.org/EIPS/eip-721
919  */
920 interface IERC721Enumerable is IERC721 {
921     /**
922      * @dev Returns the total amount of tokens stored by the contract.
923      */
924     function totalSupply() external view returns (uint256);
925 
926     /**
927      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
928      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
929      */
930     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
931 
932     /**
933      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
934      * Use along with {totalSupply} to enumerate all tokens.
935      */
936     function tokenByIndex(uint256 index) external view returns (uint256);
937 }
938 
939 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
940 
941 
942 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
943 
944 pragma solidity ^0.8.0;
945 
946 
947 /**
948  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
949  * @dev See https://eips.ethereum.org/EIPS/eip-721
950  */
951 interface IERC721Metadata is IERC721 {
952     /**
953      * @dev Returns the token collection name.
954      */
955     function name() external view returns (string memory);
956 
957     /**
958      * @dev Returns the token collection symbol.
959      */
960     function symbol() external view returns (string memory);
961 
962     /**
963      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
964      */
965     function tokenURI(uint256 tokenId) external view returns (string memory);
966 }
967 
968 // File: contracts/TwistedToonz.sol
969 
970 
971 // Creator: Chiru Labs
972 
973 pragma solidity ^0.8.0;
974 
975 
976 
977 
978 
979 
980 
981 
982 
983 /**
984  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
985  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
986  *
987  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
988  *
989  * Does not support burning tokens to address(0).
990  *
991  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
992  */
993 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
994     using Address for address;
995     using Strings for uint256;
996 
997     struct TokenOwnership {
998         address addr;
999         uint64 startTimestamp;
1000     }
1001 
1002     struct AddressData {
1003         uint128 balance;
1004         uint128 numberMinted;
1005     }
1006 
1007     uint256 internal currentIndex;
1008 
1009     // Token name
1010     string private _name;
1011 
1012     // Token symbol
1013     string private _symbol;
1014 
1015     // Mapping from token ID to ownership details
1016     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1017     mapping(uint256 => TokenOwnership) internal _ownerships;
1018 
1019     // Mapping owner address to address data
1020     mapping(address => AddressData) private _addressData;
1021 
1022     // Mapping from token ID to approved address
1023     mapping(uint256 => address) private _tokenApprovals;
1024 
1025     // Mapping from owner to operator approvals
1026     mapping(address => mapping(address => bool)) private _operatorApprovals;
1027 
1028     constructor(string memory name_, string memory symbol_) {
1029         _name = name_;
1030         _symbol = symbol_;
1031     }
1032 
1033     /**
1034      * @dev See {IERC721Enumerable-totalSupply}.
1035      */
1036     function totalSupply() public view override returns (uint256) {
1037         return currentIndex;
1038     }
1039 
1040     /**
1041      * @dev See {IERC721Enumerable-tokenByIndex}.
1042      */
1043     function tokenByIndex(uint256 index) public view override returns (uint256) {
1044         require(index < totalSupply(), "ERC721A: global index out of bounds");
1045         return index;
1046     }
1047 
1048     /**
1049      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1050      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1051      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1052      */
1053     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1054         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1055         uint256 numMintedSoFar = totalSupply();
1056         uint256 tokenIdsIdx;
1057         address currOwnershipAddr;
1058 
1059         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1060         unchecked {
1061             for (uint256 i; i < numMintedSoFar; i++) {
1062                 TokenOwnership memory ownership = _ownerships[i];
1063                 if (ownership.addr != address(0)) {
1064                     currOwnershipAddr = ownership.addr;
1065                 }
1066                 if (currOwnershipAddr == owner) {
1067                     if (tokenIdsIdx == index) {
1068                         return i;
1069                     }
1070                     tokenIdsIdx++;
1071                 }
1072             }
1073         }
1074 
1075         revert("ERC721A: unable to get token of owner by index");
1076     }
1077 
1078     /**
1079      * @dev See {IERC165-supportsInterface}.
1080      */
1081     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1082         return
1083             interfaceId == type(IERC721).interfaceId ||
1084             interfaceId == type(IERC721Metadata).interfaceId ||
1085             interfaceId == type(IERC721Enumerable).interfaceId ||
1086             super.supportsInterface(interfaceId);
1087     }
1088 
1089     /**
1090      * @dev See {IERC721-balanceOf}.
1091      */
1092     function balanceOf(address owner) public view override returns (uint256) {
1093         require(owner != address(0), "ERC721A: balance query for the zero address");
1094         return uint256(_addressData[owner].balance);
1095     }
1096 
1097     function _numberMinted(address owner) internal view returns (uint256) {
1098         require(owner != address(0), "ERC721A: number minted query for the zero address");
1099         return uint256(_addressData[owner].numberMinted);
1100     }
1101 
1102     /**
1103      * Gas spent here starts off proportional to the maximum mint batch size.
1104      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1105      */
1106     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1107         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1108 
1109         unchecked {
1110             for (uint256 curr = tokenId; curr >= 0; curr--) {
1111                 TokenOwnership memory ownership = _ownerships[curr];
1112                 if (ownership.addr != address(0)) {
1113                     return ownership;
1114                 }
1115             }
1116         }
1117 
1118         revert("ERC721A: unable to determine the owner of token");
1119     }
1120 
1121     /**
1122      * @dev See {IERC721-ownerOf}.
1123      */
1124     function ownerOf(uint256 tokenId) public view override returns (address) {
1125         return ownershipOf(tokenId).addr;
1126     }
1127 
1128     /**
1129      * @dev See {IERC721Metadata-name}.
1130      */
1131     function name() public view virtual override returns (string memory) {
1132         return _name;
1133     }
1134 
1135     /**
1136      * @dev See {IERC721Metadata-symbol}.
1137      */
1138     function symbol() public view virtual override returns (string memory) {
1139         return _symbol;
1140     }
1141 
1142     /**
1143      * @dev See {IERC721Metadata-tokenURI}.
1144      */
1145     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1146         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1147 
1148         string memory baseURI = _baseURI();
1149         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1150     }
1151 
1152     /**
1153      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1154      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1155      * by default, can be overriden in child contracts.
1156      */
1157     function _baseURI() internal view virtual returns (string memory) {
1158         return "";
1159     }
1160 
1161     /**
1162      * @dev See {IERC721-approve}.
1163      */
1164     function approve(address to, uint256 tokenId) public override {
1165         address owner = ERC721A.ownerOf(tokenId);
1166         require(to != owner, "ERC721A: approval to current owner");
1167 
1168         require(
1169             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1170             "ERC721A: approve caller is not owner nor approved for all"
1171         );
1172 
1173         _approve(to, tokenId, owner);
1174     }
1175 
1176     /**
1177      * @dev See {IERC721-getApproved}.
1178      */
1179     function getApproved(uint256 tokenId) public view override returns (address) {
1180         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1181 
1182         return _tokenApprovals[tokenId];
1183     }
1184 
1185     /**
1186      * @dev See {IERC721-setApprovalForAll}.
1187      */
1188     function setApprovalForAll(address operator, bool approved) public override {
1189         require(operator != _msgSender(), "ERC721A: approve to caller");
1190 
1191         _operatorApprovals[_msgSender()][operator] = approved;
1192         emit ApprovalForAll(_msgSender(), operator, approved);
1193     }
1194 
1195     /**
1196      * @dev See {IERC721-isApprovedForAll}.
1197      */
1198     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1199         return _operatorApprovals[owner][operator];
1200     }
1201 
1202     /**
1203      * @dev See {IERC721-transferFrom}.
1204      */
1205     function transferFrom(
1206         address from,
1207         address to,
1208         uint256 tokenId
1209     ) public virtual override {
1210         _transfer(from, to, tokenId);
1211     }
1212 
1213     /**
1214      * @dev See {IERC721-safeTransferFrom}.
1215      */
1216     function safeTransferFrom(
1217         address from,
1218         address to,
1219         uint256 tokenId
1220     ) public virtual override {
1221         safeTransferFrom(from, to, tokenId, "");
1222     }
1223 
1224     /**
1225      * @dev See {IERC721-safeTransferFrom}.
1226      */
1227     function safeTransferFrom(
1228         address from,
1229         address to,
1230         uint256 tokenId,
1231         bytes memory _data
1232     ) public override {
1233         _transfer(from, to, tokenId);
1234         require(
1235             _checkOnERC721Received(from, to, tokenId, _data),
1236             "ERC721A: transfer to non ERC721Receiver implementer"
1237         );
1238     }
1239 
1240     /**
1241      * @dev Returns whether `tokenId` exists.
1242      *
1243      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1244      *
1245      * Tokens start existing when they are minted (`_mint`),
1246      */
1247     function _exists(uint256 tokenId) internal view returns (bool) {
1248         return tokenId < currentIndex;
1249     }
1250 
1251     function _safeMint(address to, uint256 quantity) internal {
1252         _safeMint(to, quantity, "");
1253     }
1254 
1255     /**
1256      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1257      *
1258      * Requirements:
1259      *
1260      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1261      * - `quantity` must be greater than 0.
1262      *
1263      * Emits a {Transfer} event.
1264      */
1265     function _safeMint(
1266         address to,
1267         uint256 quantity,
1268         bytes memory _data
1269     ) internal {
1270         _mint(to, quantity, _data, true);
1271     }
1272 
1273     /**
1274      * @dev Mints `quantity` tokens and transfers them to `to`.
1275      *
1276      * Requirements:
1277      *
1278      * - `to` cannot be the zero address.
1279      * - `quantity` must be greater than 0.
1280      *
1281      * Emits a {Transfer} event.
1282      */
1283     function _mint(
1284         address to,
1285         uint256 quantity,
1286         bytes memory _data,
1287         bool safe
1288     ) internal {
1289         uint256 startTokenId = currentIndex;
1290         require(to != address(0), "ERC721A: mint to the zero address");
1291         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1292 
1293         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1294 
1295         // Overflows are incredibly unrealistic.
1296         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1297         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1298         unchecked {
1299             _addressData[to].balance += uint128(quantity);
1300             _addressData[to].numberMinted += uint128(quantity);
1301 
1302             _ownerships[startTokenId].addr = to;
1303             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1304 
1305             uint256 updatedIndex = startTokenId;
1306 
1307             for (uint256 i; i < quantity; i++) {
1308                 emit Transfer(address(0), to, updatedIndex);
1309                 if (safe) {
1310                     require(
1311                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1312                         "ERC721A: transfer to non ERC721Receiver implementer"
1313                     );
1314                 }
1315 
1316                 updatedIndex++;
1317             }
1318 
1319             currentIndex = updatedIndex;
1320         }
1321 
1322         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1323     }
1324 
1325     /**
1326      * @dev Transfers `tokenId` from `from` to `to`.
1327      *
1328      * Requirements:
1329      *
1330      * - `to` cannot be the zero address.
1331      * - `tokenId` token must be owned by `from`.
1332      *
1333      * Emits a {Transfer} event.
1334      */
1335     function _transfer(
1336         address from,
1337         address to,
1338         uint256 tokenId
1339     ) private {
1340         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1341 
1342         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1343             getApproved(tokenId) == _msgSender() ||
1344             isApprovedForAll(prevOwnership.addr, _msgSender()));
1345 
1346         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1347 
1348         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1349         require(to != address(0), "ERC721A: transfer to the zero address");
1350 
1351         _beforeTokenTransfers(from, to, tokenId, 1);
1352 
1353         // Clear approvals from the previous owner
1354         _approve(address(0), tokenId, prevOwnership.addr);
1355 
1356         // Underflow of the sender's balance is impossible because we check for
1357         // ownership above and the recipient's balance can't realistically overflow.
1358         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1359         unchecked {
1360             _addressData[from].balance -= 1;
1361             _addressData[to].balance += 1;
1362 
1363             _ownerships[tokenId].addr = to;
1364             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1365 
1366             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1367             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1368             uint256 nextTokenId = tokenId + 1;
1369             if (_ownerships[nextTokenId].addr == address(0)) {
1370                 if (_exists(nextTokenId)) {
1371                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1372                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1373                 }
1374             }
1375         }
1376 
1377         emit Transfer(from, to, tokenId);
1378         _afterTokenTransfers(from, to, tokenId, 1);
1379     }
1380 
1381     /**
1382      * @dev Approve `to` to operate on `tokenId`
1383      *
1384      * Emits a {Approval} event.
1385      */
1386     function _approve(
1387         address to,
1388         uint256 tokenId,
1389         address owner
1390     ) private {
1391         _tokenApprovals[tokenId] = to;
1392         emit Approval(owner, to, tokenId);
1393     }
1394 
1395     /**
1396      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1397      * The call is not executed if the target address is not a contract.
1398      *
1399      * @param from address representing the previous owner of the given token ID
1400      * @param to target address that will receive the tokens
1401      * @param tokenId uint256 ID of the token to be transferred
1402      * @param _data bytes optional data to send along with the call
1403      * @return bool whether the call correctly returned the expected magic value
1404      */
1405     function _checkOnERC721Received(
1406         address from,
1407         address to,
1408         uint256 tokenId,
1409         bytes memory _data
1410     ) private returns (bool) {
1411         if (to.isContract()) {
1412             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1413                 return retval == IERC721Receiver(to).onERC721Received.selector;
1414             } catch (bytes memory reason) {
1415                 if (reason.length == 0) {
1416                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1417                 } else {
1418                     assembly {
1419                         revert(add(32, reason), mload(reason))
1420                     }
1421                 }
1422             }
1423         } else {
1424             return true;
1425         }
1426     }
1427 
1428     /**
1429      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1430      *
1431      * startTokenId - the first token id to be transferred
1432      * quantity - the amount to be transferred
1433      *
1434      * Calling conditions:
1435      *
1436      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1437      * transferred to `to`.
1438      * - When `from` is zero, `tokenId` will be minted for `to`.
1439      */
1440     function _beforeTokenTransfers(
1441         address from,
1442         address to,
1443         uint256 startTokenId,
1444         uint256 quantity
1445     ) internal virtual {}
1446 
1447     /**
1448      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1449      * minting.
1450      *
1451      * startTokenId - the first token id to be transferred
1452      * quantity - the amount to be transferred
1453      *
1454      * Calling conditions:
1455      *
1456      * - when `from` and `to` are both non-zero.
1457      * - `from` and `to` are never both zero.
1458      */
1459     function _afterTokenTransfers(
1460         address from,
1461         address to,
1462         uint256 startTokenId,
1463         uint256 quantity
1464     ) internal virtual {}
1465 }
1466 
1467 contract BoredRedditYachtClub is ERC721A, Ownable, ReentrancyGuard {
1468 
1469   uint public     nextOwnerToExplicitlySet;
1470   string public   baseURI;
1471   uint public     maxPerTx          = 30;
1472   uint public     maxPerWallet      = 90;
1473   uint public     maxSupply         = 10000;
1474   uint public     price             = 0.001 ether;
1475   bool public     mintEnabled;
1476 
1477   constructor() ERC721A("BoredRedditYachtClub", "BRYC"){}
1478 
1479   function reserve(uint256 amt) external onlyOwner{
1480     require(totalSupply() + amt < maxSupply + 1,"Not enough to reserve.");
1481     _safeMint(msg.sender, amt);
1482   }
1483 
1484   function mint(uint256 amt) external payable{
1485     require( amt < maxPerTx + 1, "Max per transaction exceeded.");
1486     require(msg.sender == tx.origin,"You are not the sender.");
1487     require(numberMinted(msg.sender) + amt <= maxPerWallet,"Wallet limit reached!");
1488     require(totalSupply() + amt < maxSupply + 1,"SOLD OUT!");
1489     require(msg.value == amt * price,"The amount is not correct.");
1490     require(mintEnabled, "No minting yet.");
1491     _safeMint(msg.sender, amt);
1492   }
1493 
1494   function setBaseURI(string calldata baseURI_) external onlyOwner {
1495     baseURI = baseURI_;
1496   }
1497 
1498   function setPrice(uint256 price_) external onlyOwner {
1499       price = price_;
1500   }
1501 
1502   function toggleMint() external onlyOwner {
1503       mintEnabled = !mintEnabled;
1504   }
1505 
1506   function setMaxPerTx(uint256 maxPerTx_) external onlyOwner {
1507       maxPerTx = maxPerTx_;
1508   }
1509 
1510   function setMaxPerWallet(uint256 maxPerWallet_) external onlyOwner {
1511       maxPerWallet = maxPerWallet_;
1512   }
1513 
1514   function setMaxSupply(uint256 maxSupply_) external onlyOwner {
1515       maxSupply = maxSupply_;
1516   }
1517 
1518   function _baseURI() internal view virtual override returns (string memory) {
1519     return baseURI;
1520   }
1521 
1522   function withdraw() external onlyOwner nonReentrant {
1523     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1524     require(success, "Transfer failed.");
1525   }
1526 
1527   function numberMinted(address owner) public view returns (uint256) {
1528     return _numberMinted(owner);
1529   }
1530 
1531   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1532     _setOwnersExplicit(quantity);
1533   }
1534 
1535   function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1536     return ownershipOf(tokenId);
1537   }
1538 
1539 
1540   /**
1541     * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1542     */
1543   function _setOwnersExplicit(uint256 quantity) internal {
1544       require(quantity != 0, "quantity must be nonzero");
1545       require(currentIndex != 0, "no tokens minted yet");
1546       uint256 _nextOwnerToExplicitlySet = nextOwnerToExplicitlySet;
1547       require(_nextOwnerToExplicitlySet < currentIndex, "all ownerships have been set");
1548 
1549       // Index underflow is impossible.
1550       // Counter or index overflow is incredibly unrealistic.
1551       unchecked {
1552           uint256 endIndex = _nextOwnerToExplicitlySet + quantity - 1;
1553 
1554           // Set the end index to be the last token index
1555           if (endIndex + 1 > currentIndex) {
1556               endIndex = currentIndex - 1;
1557           }
1558 
1559           for (uint256 i = _nextOwnerToExplicitlySet; i <= endIndex; i++) {
1560               if (_ownerships[i].addr == address(0)) {
1561                   TokenOwnership memory ownership = ownershipOf(i);
1562                   _ownerships[i].addr = ownership.addr;
1563                   _ownerships[i].startTimestamp = ownership.startTimestamp;
1564               }
1565           }
1566 
1567           nextOwnerToExplicitlySet = endIndex + 1;
1568       }
1569   }
1570 }