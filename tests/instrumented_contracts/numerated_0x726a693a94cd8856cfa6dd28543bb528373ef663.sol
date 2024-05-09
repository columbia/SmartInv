1 // SPDX-License-Identifier: MIT
2 
3 // rektgoblins
4 
5 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
6 
7 
8 //  .----------------.  .----------------.  .----------------.  .----------------. 
9 // | .--------------. || .--------------. || .--------------. || .--------------. |
10 // | |  _______     | || |  _________   | || |  ___  ____   | || |  _________   | |
11 // | | |_   __ \    | || | |_   ___  |  | || | |_  ||_  _|  | || | |  _   _  |  | |
12 // | |   | |__) |   | || |   | |_  \_|  | || |   | |_/ /    | || | |_/ | | \_|  | |
13 // | |   |  __ /    | || |   |  _|  _   | || |   |  __'.    | || |     | |      | |
14 // | |  _| |  \ \_  | || |  _| |___/ |  | || |  _| |  \ \_  | || |    _| |_     | |
15 // | | |____| |___| | || | |_________|  | || | |____||____| | || |   |_____|    | |
16 // | |              | || |              | || |              | || |              | |
17 // | '--------------' || '--------------' || '--------------' || '--------------' |
18 //  '----------------'  '----------------'  '----------------'  '----------------' 
19 
20 
21 
22 
23 
24 
25 
26 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
27 
28 pragma solidity ^0.8.0;
29 
30 /**
31  * @dev Interface of the ERC20 standard as defined in the EIP.
32  */
33 interface IERC20 {
34     /**
35      * @dev Returns the amount of tokens in existence.
36      */
37     function totalSupply() external view returns (uint256);
38 
39     /**
40      * @dev Returns the amount of tokens owned by `account`.
41      */
42     function balanceOf(address account) external view returns (uint256);
43 
44     /**
45      * @dev Moves `amount` tokens from the caller's account to `to`.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * Emits a {Transfer} event.
50      */
51     function transfer(address to, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Returns the remaining number of tokens that `spender` will be
55      * allowed to spend on behalf of `owner` through {transferFrom}. This is
56      * zero by default.
57      *
58      * This value changes when {approve} or {transferFrom} are called.
59      */
60     function allowance(address owner, address spender) external view returns (uint256);
61 
62     /**
63      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * IMPORTANT: Beware that changing an allowance with this method brings the risk
68      * that someone may use both the old and the new allowance by unfortunate
69      * transaction ordering. One possible solution to mitigate this race
70      * condition is to first reduce the spender's allowance to 0 and set the
71      * desired value afterwards:
72      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73      *
74      * Emits an {Approval} event.
75      */
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Moves `amount` tokens from `from` to `to` using the
80      * allowance mechanism. `amount` is then deducted from the caller's
81      * allowance.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transferFrom(
88         address from,
89         address to,
90         uint256 amount
91     ) external returns (bool);
92 
93     /**
94      * @dev Emitted when `value` tokens are moved from one account (`from`) to
95      * another (`to`).
96      *
97      * Note that `value` may be zero.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     /**
102      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103      * a call to {approve}. `value` is the new allowance.
104      */
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
109 
110 
111 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
112 
113 pragma solidity ^0.8.0;
114 
115 /**
116  * @dev Contract module that helps prevent reentrant calls to a function.
117  *
118  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
119  * available, which can be applied to functions to make sure there are no nested
120  * (reentrant) calls to them.
121  *
122  * Note that because there is a single `nonReentrant` guard, functions marked as
123  * `nonReentrant` may not call one another. This can be worked around by making
124  * those functions `private`, and then adding `external` `nonReentrant` entry
125  * points to them.
126  *
127  * TIP: If you would like to learn more about reentrancy and alternative ways
128  * to protect against it, check out our blog post
129  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
130  */
131 abstract contract ReentrancyGuard {
132     // Booleans are more expensive than uint256 or any type that takes up a full
133     // word because each write operation emits an extra SLOAD to first read the
134     // slot's contents, replace the bits taken up by the boolean, and then write
135     // back. This is the compiler's defense against contract upgrades and
136     // pointer aliasing, and it cannot be disabled.
137 
138     // The values being non-zero value makes deployment a bit more expensive,
139     // but in exchange the refund on every call to nonReentrant will be lower in
140     // amount. Since refunds are capped to a percentage of the total
141     // transaction's gas, it is best to keep them low in cases like this one, to
142     // increase the likelihood of the full refund coming into effect.
143     uint256 private constant _NOT_ENTERED = 1;
144     uint256 private constant _ENTERED = 2;
145 
146     uint256 private _status;
147 
148     constructor() {
149         _status = _NOT_ENTERED;
150     }
151 
152     /**
153      * @dev Prevents a contract from calling itself, directly or indirectly.
154      * Calling a `nonReentrant` function from another `nonReentrant`
155      * function is not supported. It is possible to prevent this from happening
156      * by making the `nonReentrant` function external, and making it call a
157      * `private` function that does the actual work.
158      */
159     modifier nonReentrant() {
160         // On the first call to nonReentrant, _notEntered will be true
161         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
162 
163         // Any calls to nonReentrant after this point will fail
164         _status = _ENTERED;
165 
166         _;
167 
168         // By storing the original value once again, a refund is triggered (see
169         // https://eips.ethereum.org/EIPS/eip-2200)
170         _status = _NOT_ENTERED;
171     }
172 }
173 
174 // File: @openzeppelin/contracts/utils/Strings.sol
175 
176 
177 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 /**
182  * @dev String operations.
183  */
184 library Strings {
185     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
186 
187     /**
188      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
189      */
190     function toString(uint256 value) internal pure returns (string memory) {
191         // Inspired by OraclizeAPI's implementation - MIT licence
192         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
193 
194         if (value == 0) {
195             return "0";
196         }
197         uint256 temp = value;
198         uint256 digits;
199         while (temp != 0) {
200             digits++;
201             temp /= 10;
202         }
203         bytes memory buffer = new bytes(digits);
204         while (value != 0) {
205             digits -= 1;
206             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
207             value /= 10;
208         }
209         return string(buffer);
210     }
211 
212     /**
213      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
214      */
215     function toHexString(uint256 value) internal pure returns (string memory) {
216         if (value == 0) {
217             return "0x00";
218         }
219         uint256 temp = value;
220         uint256 length = 0;
221         while (temp != 0) {
222             length++;
223             temp >>= 8;
224         }
225         return toHexString(value, length);
226     }
227 
228     /**
229      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
230      */
231     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
232         bytes memory buffer = new bytes(2 * length + 2);
233         buffer[0] = "0";
234         buffer[1] = "x";
235         for (uint256 i = 2 * length + 1; i > 1; --i) {
236             buffer[i] = _HEX_SYMBOLS[value & 0xf];
237             value >>= 4;
238         }
239         require(value == 0, "Strings: hex length insufficient");
240         return string(buffer);
241     }
242 }
243 
244 // File: @openzeppelin/contracts/utils/Context.sol
245 
246 
247 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
248 
249 pragma solidity ^0.8.0;
250 
251 /**
252  * @dev Provides information about the current execution context, including the
253  * sender of the transaction and its data. While these are generally available
254  * via msg.sender and msg.data, they should not be accessed in such a direct
255  * manner, since when dealing with meta-transactions the account sending and
256  * paying for execution may not be the actual sender (as far as an application
257  * is concerned).
258  *
259  * This contract is only required for intermediate, library-like contracts.
260  */
261 abstract contract Context {
262     function _msgSender() internal view virtual returns (address) {
263         return msg.sender;
264     }
265 
266     function _msgData() internal view virtual returns (bytes calldata) {
267         return msg.data;
268     }
269 }
270 
271 // File: @openzeppelin/contracts/access/Ownable.sol
272 
273 
274 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
275 
276 pragma solidity ^0.8.0;
277 
278 
279 /**
280  * @dev Contract module which provides a basic access control mechanism, where
281  * there is an account (an owner) that can be granted exclusive access to
282  * specific functions.
283  *
284  * By default, the owner account will be the one that deploys the contract. This
285  * can later be changed with {transferOwnership}.
286  *
287  * This module is used through inheritance. It will make available the modifier
288  * `onlyOwner`, which can be applied to your functions to restrict their use to
289  * the owner.
290  */
291 abstract contract Ownable is Context {
292     address private _owner;
293 
294     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
295 
296     /**
297      * @dev Initializes the contract setting the deployer as the initial owner.
298      */
299     constructor() {
300         _transferOwnership(_msgSender());
301     }
302 
303     /**
304      * @dev Returns the address of the current owner.
305      */
306     function owner() public view virtual returns (address) {
307         return _owner;
308     }
309 
310     /**
311      * @dev Throws if called by any account other than the owner.
312      */
313     modifier onlyOwner() {
314         require(owner() == _msgSender(), "Ownable: caller is not the owner");
315         _;
316     }
317 
318     /**
319      * @dev Leaves the contract without owner. It will not be possible to call
320      * `onlyOwner` functions anymore. Can only be called by the current owner.
321      *
322      * NOTE: Renouncing ownership will leave the contract without an owner,
323      * thereby removing any functionality that is only available to the owner.
324      */
325     function renounceOwnership() public virtual onlyOwner {
326         _transferOwnership(address(0));
327     }
328 
329     /**
330      * @dev Transfers ownership of the contract to a new account (`newOwner`).
331      * Can only be called by the current owner.
332      */
333     function transferOwnership(address newOwner) public virtual onlyOwner {
334         require(newOwner != address(0), "Ownable: new owner is the zero address");
335         _transferOwnership(newOwner);
336     }
337 
338     /**
339      * @dev Transfers ownership of the contract to a new account (`newOwner`).
340      * Internal function without access restriction.
341      */
342     function _transferOwnership(address newOwner) internal virtual {
343         address oldOwner = _owner;
344         _owner = newOwner;
345         emit OwnershipTransferred(oldOwner, newOwner);
346     }
347 }
348 
349 // File: @openzeppelin/contracts/utils/Address.sol
350 
351 
352 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
353 
354 pragma solidity ^0.8.1;
355 
356 /**
357  * @dev Collection of functions related to the address type
358  */
359 library Address {
360     /**
361      * @dev Returns true if `account` is a contract.
362      *
363      * [IMPORTANT]
364      * ====
365      * It is unsafe to assume that an address for which this function returns
366      * false is an externally-owned account (EOA) and not a contract.
367      *
368      * Among others, `isContract` will return false for the following
369      * types of addresses:
370      *
371      *  - an externally-owned account
372      *  - a contract in construction
373      *  - an address where a contract will be created
374      *  - an address where a contract lived, but was destroyed
375      * ====
376      *
377      * [IMPORTANT]
378      * ====
379      * You shouldn't rely on `isContract` to protect against flash loan attacks!
380      *
381      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
382      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
383      * constructor.
384      * ====
385      */
386     function isContract(address account) internal view returns (bool) {
387         // This method relies on extcodesize/address.code.length, which returns 0
388         // for contracts in construction, since the code is only stored at the end
389         // of the constructor execution.
390 
391         return account.code.length > 0;
392     }
393 
394     /**
395      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
396      * `recipient`, forwarding all available gas and reverting on errors.
397      *
398      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
399      * of certain opcodes, possibly making contracts go over the 2300 gas limit
400      * imposed by `transfer`, making them unable to receive funds via
401      * `transfer`. {sendValue} removes this limitation.
402      *
403      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
404      *
405      * IMPORTANT: because control is transferred to `recipient`, care must be
406      * taken to not create reentrancy vulnerabilities. Consider using
407      * {ReentrancyGuard} or the
408      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
409      */
410     function sendValue(address payable recipient, uint256 amount) internal {
411         require(address(this).balance >= amount, "Address: insufficient balance");
412 
413         (bool success, ) = recipient.call{value: amount}("");
414         require(success, "Address: unable to send value, recipient may have reverted");
415     }
416 
417     /**
418      * @dev Performs a Solidity function call using a low level `call`. A
419      * plain `call` is an unsafe replacement for a function call: use this
420      * function instead.
421      *
422      * If `target` reverts with a revert reason, it is bubbled up by this
423      * function (like regular Solidity function calls).
424      *
425      * Returns the raw returned data. To convert to the expected return value,
426      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
427      *
428      * Requirements:
429      *
430      * - `target` must be a contract.
431      * - calling `target` with `data` must not revert.
432      *
433      * _Available since v3.1._
434      */
435     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
436         return functionCall(target, data, "Address: low-level call failed");
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
441      * `errorMessage` as a fallback revert reason when `target` reverts.
442      *
443      * _Available since v3.1._
444      */
445     function functionCall(
446         address target,
447         bytes memory data,
448         string memory errorMessage
449     ) internal returns (bytes memory) {
450         return functionCallWithValue(target, data, 0, errorMessage);
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
455      * but also transferring `value` wei to `target`.
456      *
457      * Requirements:
458      *
459      * - the calling contract must have an ETH balance of at least `value`.
460      * - the called Solidity function must be `payable`.
461      *
462      * _Available since v3.1._
463      */
464     function functionCallWithValue(
465         address target,
466         bytes memory data,
467         uint256 value
468     ) internal returns (bytes memory) {
469         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
474      * with `errorMessage` as a fallback revert reason when `target` reverts.
475      *
476      * _Available since v3.1._
477      */
478     function functionCallWithValue(
479         address target,
480         bytes memory data,
481         uint256 value,
482         string memory errorMessage
483     ) internal returns (bytes memory) {
484         require(address(this).balance >= value, "Address: insufficient balance for call");
485         require(isContract(target), "Address: call to non-contract");
486 
487         (bool success, bytes memory returndata) = target.call{value: value}(data);
488         return verifyCallResult(success, returndata, errorMessage);
489     }
490 
491     /**
492      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
493      * but performing a static call.
494      *
495      * _Available since v3.3._
496      */
497     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
498         return functionStaticCall(target, data, "Address: low-level static call failed");
499     }
500 
501     /**
502      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
503      * but performing a static call.
504      *
505      * _Available since v3.3._
506      */
507     function functionStaticCall(
508         address target,
509         bytes memory data,
510         string memory errorMessage
511     ) internal view returns (bytes memory) {
512         require(isContract(target), "Address: static call to non-contract");
513 
514         (bool success, bytes memory returndata) = target.staticcall(data);
515         return verifyCallResult(success, returndata, errorMessage);
516     }
517 
518     /**
519      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
520      * but performing a delegate call.
521      *
522      * _Available since v3.4._
523      */
524     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
525         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
526     }
527 
528     /**
529      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
530      * but performing a delegate call.
531      *
532      * _Available since v3.4._
533      */
534     function functionDelegateCall(
535         address target,
536         bytes memory data,
537         string memory errorMessage
538     ) internal returns (bytes memory) {
539         require(isContract(target), "Address: delegate call to non-contract");
540 
541         (bool success, bytes memory returndata) = target.delegatecall(data);
542         return verifyCallResult(success, returndata, errorMessage);
543     }
544 
545     /**
546      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
547      * revert reason using the provided one.
548      *
549      * _Available since v4.3._
550      */
551     function verifyCallResult(
552         bool success,
553         bytes memory returndata,
554         string memory errorMessage
555     ) internal pure returns (bytes memory) {
556         if (success) {
557             return returndata;
558         } else {
559             // Look for revert reason and bubble it up if present
560             if (returndata.length > 0) {
561                 // The easiest way to bubble the revert reason is using memory via assembly
562 
563                 assembly {
564                     let returndata_size := mload(returndata)
565                     revert(add(32, returndata), returndata_size)
566                 }
567             } else {
568                 revert(errorMessage);
569             }
570         }
571     }
572 }
573 
574 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
575 
576 
577 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
578 
579 pragma solidity ^0.8.0;
580 
581 
582 
583 /**
584  * @title SafeERC20
585  * @dev Wrappers around ERC20 operations that throw on failure (when the token
586  * contract returns false). Tokens that return no value (and instead revert or
587  * throw on failure) are also supported, non-reverting calls are assumed to be
588  * successful.
589  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
590  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
591  */
592 library SafeERC20 {
593     using Address for address;
594 
595     function safeTransfer(
596         IERC20 token,
597         address to,
598         uint256 value
599     ) internal {
600         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
601     }
602 
603     function safeTransferFrom(
604         IERC20 token,
605         address from,
606         address to,
607         uint256 value
608     ) internal {
609         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
610     }
611 
612     /**
613      * @dev Deprecated. This function has issues similar to the ones found in
614      * {IERC20-approve}, and its usage is discouraged.
615      *
616      * Whenever possible, use {safeIncreaseAllowance} and
617      * {safeDecreaseAllowance} instead.
618      */
619     function safeApprove(
620         IERC20 token,
621         address spender,
622         uint256 value
623     ) internal {
624         // safeApprove should only be called when setting an initial allowance,
625         // or when resetting it to zero. To increase and decrease it, use
626         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
627         require(
628             (value == 0) || (token.allowance(address(this), spender) == 0),
629             "SafeERC20: approve from non-zero to non-zero allowance"
630         );
631         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
632     }
633 
634     function safeIncreaseAllowance(
635         IERC20 token,
636         address spender,
637         uint256 value
638     ) internal {
639         uint256 newAllowance = token.allowance(address(this), spender) + value;
640         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
641     }
642 
643     function safeDecreaseAllowance(
644         IERC20 token,
645         address spender,
646         uint256 value
647     ) internal {
648         unchecked {
649             uint256 oldAllowance = token.allowance(address(this), spender);
650             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
651             uint256 newAllowance = oldAllowance - value;
652             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
653         }
654     }
655 
656     /**
657      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
658      * on the return value: the return value is optional (but if data is returned, it must not be false).
659      * @param token The token targeted by the call.
660      * @param data The call data (encoded using abi.encode or one of its variants).
661      */
662     function _callOptionalReturn(IERC20 token, bytes memory data) private {
663         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
664         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
665         // the target address contains contract code and also asserts for success in the low-level call.
666 
667         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
668         if (returndata.length > 0) {
669             // Return data is optional
670             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
671         }
672     }
673 }
674 
675 
676 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
677 
678 
679 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
680 
681 pragma solidity ^0.8.0;
682 
683 /**
684  * @title ERC721 token receiver interface
685  * @dev Interface for any contract that wants to support safeTransfers
686  * from ERC721 asset contracts.
687  */
688 interface IERC721Receiver {
689     /**
690      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
691      * by `operator` from `from`, this function is called.
692      *
693      * It must return its Solidity selector to confirm the token transfer.
694      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
695      *
696      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
697      */
698     function onERC721Received(
699         address operator,
700         address from,
701         uint256 tokenId,
702         bytes calldata data
703     ) external returns (bytes4);
704 }
705 
706 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
707 
708 
709 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
710 
711 pragma solidity ^0.8.0;
712 
713 /**
714  * @dev Interface of the ERC165 standard, as defined in the
715  * https://eips.ethereum.org/EIPS/eip-165[EIP].
716  *
717  * Implementers can declare support of contract interfaces, which can then be
718  * queried by others ({ERC165Checker}).
719  *
720  * For an implementation, see {ERC165}.
721  */
722 interface IERC165 {
723     /**
724      * @dev Returns true if this contract implements the interface defined by
725      * `interfaceId`. See the corresponding
726      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
727      * to learn more about how these ids are created.
728      *
729      * This function call must use less than 30 000 gas.
730      */
731     function supportsInterface(bytes4 interfaceId) external view returns (bool);
732 }
733 
734 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
735 
736 
737 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
738 
739 pragma solidity ^0.8.0;
740 
741 
742 /**
743  * @dev Implementation of the {IERC165} interface.
744  *
745  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
746  * for the additional interface id that will be supported. For example:
747  *
748  * ```solidity
749  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
750  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
751  * }
752  * ```
753  *
754  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
755  */
756 abstract contract ERC165 is IERC165 {
757     /**
758      * @dev See {IERC165-supportsInterface}.
759      */
760     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
761         return interfaceId == type(IERC165).interfaceId;
762     }
763 }
764 
765 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
766 
767 
768 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
769 
770 pragma solidity ^0.8.0;
771 
772 
773 /**
774  * @dev Required interface of an ERC721 compliant contract.
775  */
776 interface IERC721 is IERC165 {
777     /**
778      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
779      */
780     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
781 
782     /**
783      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
784      */
785     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
786 
787     /**
788      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
789      */
790     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
791 
792     /**
793      * @dev Returns the number of tokens in ``owner``'s account.
794      */
795     function balanceOf(address owner) external view returns (uint256 balance);
796 
797     /**
798      * @dev Returns the owner of the `tokenId` token.
799      *
800      * Requirements:
801      *
802      * - `tokenId` must exist.
803      */
804     function ownerOf(uint256 tokenId) external view returns (address owner);
805 
806     /**
807      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
808      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
809      *
810      * Requirements:
811      *
812      * - `from` cannot be the zero address.
813      * - `to` cannot be the zero address.
814      * - `tokenId` token must exist and be owned by `from`.
815      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
816      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
817      *
818      * Emits a {Transfer} event.
819      */
820     function safeTransferFrom(
821         address from,
822         address to,
823         uint256 tokenId
824     ) external;
825 
826     /**
827      * @dev Transfers `tokenId` token from `from` to `to`.
828      *
829      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
830      *
831      * Requirements:
832      *
833      * - `from` cannot be the zero address.
834      * - `to` cannot be the zero address.
835      * - `tokenId` token must be owned by `from`.
836      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
837      *
838      * Emits a {Transfer} event.
839      */
840     function transferFrom(
841         address from,
842         address to,
843         uint256 tokenId
844     ) external;
845 
846     /**
847      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
848      * The approval is cleared when the token is transferred.
849      *
850      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
851      *
852      * Requirements:
853      *
854      * - The caller must own the token or be an approved operator.
855      * - `tokenId` must exist.
856      *
857      * Emits an {Approval} event.
858      */
859     function approve(address to, uint256 tokenId) external;
860 
861     /**
862      * @dev Returns the account approved for `tokenId` token.
863      *
864      * Requirements:
865      *
866      * - `tokenId` must exist.
867      */
868     function getApproved(uint256 tokenId) external view returns (address operator);
869 
870     /**
871      * @dev Approve or remove `operator` as an operator for the caller.
872      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
873      *
874      * Requirements:
875      *
876      * - The `operator` cannot be the caller.
877      *
878      * Emits an {ApprovalForAll} event.
879      */
880     function setApprovalForAll(address operator, bool _approved) external;
881 
882     /**
883      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
884      *
885      * See {setApprovalForAll}
886      */
887     function isApprovedForAll(address owner, address operator) external view returns (bool);
888 
889     /**
890      * @dev Safely transfers `tokenId` token from `from` to `to`.
891      *
892      * Requirements:
893      *
894      * - `from` cannot be the zero address.
895      * - `to` cannot be the zero address.
896      * - `tokenId` token must exist and be owned by `from`.
897      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
898      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
899      *
900      * Emits a {Transfer} event.
901      */
902     function safeTransferFrom(
903         address from,
904         address to,
905         uint256 tokenId,
906         bytes calldata data
907     ) external;
908 }
909 
910 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
911 
912 
913 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
914 
915 pragma solidity ^0.8.0;
916 
917 
918 /**
919  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
920  * @dev See https://eips.ethereum.org/EIPS/eip-721
921  */
922 interface IERC721Enumerable is IERC721 {
923     /**
924      * @dev Returns the total amount of tokens stored by the contract.
925      */
926     function totalSupply() external view returns (uint256);
927 
928     /**
929      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
930      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
931      */
932     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
933 
934     /**
935      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
936      * Use along with {totalSupply} to enumerate all tokens.
937      */
938     function tokenByIndex(uint256 index) external view returns (uint256);
939 }
940 
941 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
942 
943 
944 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
945 
946 pragma solidity ^0.8.0;
947 
948 
949 /**
950  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
951  * @dev See https://eips.ethereum.org/EIPS/eip-721
952  */
953 interface IERC721Metadata is IERC721 {
954     /**
955      * @dev Returns the token collection name.
956      */
957     function name() external view returns (string memory);
958 
959     /**
960      * @dev Returns the token collection symbol.
961      */
962     function symbol() external view returns (string memory);
963 
964     /**
965      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
966      */
967     function tokenURI(uint256 tokenId) external view returns (string memory);
968 }
969 
970 // File: contracts/TwistedToonz.sol
971 
972 
973 // Creator: Chiru Labs
974 
975 pragma solidity ^0.8.0;
976 
977 
978 
979 
980 
981 
982 
983 
984 
985 /**
986  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
987  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
988  *
989  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
990  *
991  * Does not support burning tokens to address(0).
992  *
993  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
994  */
995 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
996     using Address for address;
997     using Strings for uint256;
998 
999     struct TokenOwnership {
1000         address addr;
1001         uint64 startTimestamp;
1002     }
1003 
1004     struct AddressData {
1005         uint128 balance;
1006         uint128 numberMinted;
1007     }
1008 
1009     uint256 internal currentIndex;
1010 
1011     // Token name
1012     string private _name;
1013 
1014     // Token symbol
1015     string private _symbol;
1016 
1017     // Mapping from token ID to ownership details
1018     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1019     mapping(uint256 => TokenOwnership) internal _ownerships;
1020 
1021     // Mapping owner address to address data
1022     mapping(address => AddressData) private _addressData;
1023 
1024     // Mapping from token ID to approved address
1025     mapping(uint256 => address) private _tokenApprovals;
1026 
1027     // Mapping from owner to operator approvals
1028     mapping(address => mapping(address => bool)) private _operatorApprovals;
1029 
1030     constructor(string memory name_, string memory symbol_) {
1031         _name = name_;
1032         _symbol = symbol_;
1033     }
1034 
1035     /**
1036      * @dev See {IERC721Enumerable-totalSupply}.
1037      */
1038     function totalSupply() public view override returns (uint256) {
1039         return currentIndex;
1040     }
1041 
1042     /**
1043      * @dev See {IERC721Enumerable-tokenByIndex}.
1044      */
1045     function tokenByIndex(uint256 index) public view override returns (uint256) {
1046         require(index < totalSupply(), "ERC721A: global index out of bounds");
1047         return index;
1048     }
1049 
1050     /**
1051      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1052      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1053      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1054      */
1055     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1056         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1057         uint256 numMintedSoFar = totalSupply();
1058         uint256 tokenIdsIdx;
1059         address currOwnershipAddr;
1060 
1061         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1062         unchecked {
1063             for (uint256 i; i < numMintedSoFar; i++) {
1064                 TokenOwnership memory ownership = _ownerships[i];
1065                 if (ownership.addr != address(0)) {
1066                     currOwnershipAddr = ownership.addr;
1067                 }
1068                 if (currOwnershipAddr == owner) {
1069                     if (tokenIdsIdx == index) {
1070                         return i;
1071                     }
1072                     tokenIdsIdx++;
1073                 }
1074             }
1075         }
1076 
1077         revert("ERC721A: unable to get token of owner by index");
1078     }
1079 
1080     /**
1081      * @dev See {IERC165-supportsInterface}.
1082      */
1083     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1084         return
1085             interfaceId == type(IERC721).interfaceId ||
1086             interfaceId == type(IERC721Metadata).interfaceId ||
1087             interfaceId == type(IERC721Enumerable).interfaceId ||
1088             super.supportsInterface(interfaceId);
1089     }
1090 
1091     /**
1092      * @dev See {IERC721-balanceOf}.
1093      */
1094     function balanceOf(address owner) public view override returns (uint256) {
1095         require(owner != address(0), "ERC721A: balance query for the zero address");
1096         return uint256(_addressData[owner].balance);
1097     }
1098 
1099     function _numberMinted(address owner) internal view returns (uint256) {
1100         require(owner != address(0), "ERC721A: number minted query for the zero address");
1101         return uint256(_addressData[owner].numberMinted);
1102     }
1103 
1104     /**
1105      * Gas spent here starts off proportional to the maximum mint batch size.
1106      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1107      */
1108     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1109         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1110 
1111         unchecked {
1112             for (uint256 curr = tokenId; curr >= 0; curr--) {
1113                 TokenOwnership memory ownership = _ownerships[curr];
1114                 if (ownership.addr != address(0)) {
1115                     return ownership;
1116                 }
1117             }
1118         }
1119 
1120         revert("ERC721A: unable to determine the owner of token");
1121     }
1122 
1123     /**
1124      * @dev See {IERC721-ownerOf}.
1125      */
1126     function ownerOf(uint256 tokenId) public view override returns (address) {
1127         return ownershipOf(tokenId).addr;
1128     }
1129 
1130     /**
1131      * @dev See {IERC721Metadata-name}.
1132      */
1133     function name() public view virtual override returns (string memory) {
1134         return _name;
1135     }
1136 
1137     /**
1138      * @dev See {IERC721Metadata-symbol}.
1139      */
1140     function symbol() public view virtual override returns (string memory) {
1141         return _symbol;
1142     }
1143 
1144     /**
1145      * @dev See {IERC721Metadata-tokenURI}.
1146      */
1147     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1148         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1149 
1150         string memory baseURI = _baseURI();
1151         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1152     }
1153 
1154     /**
1155      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1156      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1157      * by default, can be overriden in child contracts.
1158      */
1159     function _baseURI() internal view virtual returns (string memory) {
1160         return "";
1161     }
1162 
1163     /**
1164      * @dev See {IERC721-approve}.
1165      */
1166     function approve(address to, uint256 tokenId) public override {
1167         address owner = ERC721A.ownerOf(tokenId);
1168         require(to != owner, "ERC721A: approval to current owner");
1169 
1170         require(
1171             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1172             "ERC721A: approve caller is not owner nor approved for all"
1173         );
1174 
1175         _approve(to, tokenId, owner);
1176     }
1177 
1178     /**
1179      * @dev See {IERC721-getApproved}.
1180      */
1181     function getApproved(uint256 tokenId) public view override returns (address) {
1182         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1183 
1184         return _tokenApprovals[tokenId];
1185     }
1186 
1187     /**
1188      * @dev See {IERC721-setApprovalForAll}.
1189      */
1190     function setApprovalForAll(address operator, bool approved) public override {
1191         require(operator != _msgSender(), "ERC721A: approve to caller");
1192 
1193         _operatorApprovals[_msgSender()][operator] = approved;
1194         emit ApprovalForAll(_msgSender(), operator, approved);
1195     }
1196 
1197     /**
1198      * @dev See {IERC721-isApprovedForAll}.
1199      */
1200     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1201         return _operatorApprovals[owner][operator];
1202     }
1203 
1204     /**
1205      * @dev See {IERC721-transferFrom}.
1206      */
1207     function transferFrom(
1208         address from,
1209         address to,
1210         uint256 tokenId
1211     ) public virtual override {
1212         _transfer(from, to, tokenId);
1213     }
1214 
1215     /**
1216      * @dev See {IERC721-safeTransferFrom}.
1217      */
1218     function safeTransferFrom(
1219         address from,
1220         address to,
1221         uint256 tokenId
1222     ) public virtual override {
1223         safeTransferFrom(from, to, tokenId, "");
1224     }
1225 
1226     /**
1227      * @dev See {IERC721-safeTransferFrom}.
1228      */
1229     function safeTransferFrom(
1230         address from,
1231         address to,
1232         uint256 tokenId,
1233         bytes memory _data
1234     ) public override {
1235         _transfer(from, to, tokenId);
1236         require(
1237             _checkOnERC721Received(from, to, tokenId, _data),
1238             "ERC721A: transfer to non ERC721Receiver implementer"
1239         );
1240     }
1241 
1242     /**
1243      * @dev Returns whether `tokenId` exists.
1244      *
1245      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1246      *
1247      * Tokens start existing when they are minted (`_mint`),
1248      */
1249     function _exists(uint256 tokenId) internal view returns (bool) {
1250         return tokenId < currentIndex;
1251     }
1252 
1253     function _safeMint(address to, uint256 quantity) internal {
1254         _safeMint(to, quantity, "");
1255     }
1256 
1257     /**
1258      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1259      *
1260      * Requirements:
1261      *
1262      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1263      * - `quantity` must be greater than 0.
1264      *
1265      * Emits a {Transfer} event.
1266      */
1267     function _safeMint(
1268         address to,
1269         uint256 quantity,
1270         bytes memory _data
1271     ) internal {
1272         _mint(to, quantity, _data, true);
1273     }
1274 
1275     /**
1276      * @dev Mints `quantity` tokens and transfers them to `to`.
1277      *
1278      * Requirements:
1279      *
1280      * - `to` cannot be the zero address.
1281      * - `quantity` must be greater than 0.
1282      *
1283      * Emits a {Transfer} event.
1284      */
1285     function _mint(
1286         address to,
1287         uint256 quantity,
1288         bytes memory _data,
1289         bool safe
1290     ) internal {
1291         uint256 startTokenId = currentIndex;
1292         require(to != address(0), "ERC721A: mint to the zero address");
1293         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1294 
1295         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1296 
1297         // Overflows are incredibly unrealistic.
1298         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1299         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1300         unchecked {
1301             _addressData[to].balance += uint128(quantity);
1302             _addressData[to].numberMinted += uint128(quantity);
1303 
1304             _ownerships[startTokenId].addr = to;
1305             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1306 
1307             uint256 updatedIndex = startTokenId;
1308 
1309             for (uint256 i; i < quantity; i++) {
1310                 emit Transfer(address(0), to, updatedIndex);
1311                 if (safe) {
1312                     require(
1313                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1314                         "ERC721A: transfer to non ERC721Receiver implementer"
1315                     );
1316                 }
1317 
1318                 updatedIndex++;
1319             }
1320 
1321             currentIndex = updatedIndex;
1322         }
1323 
1324         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1325     }
1326 
1327     /**
1328      * @dev Transfers `tokenId` from `from` to `to`.
1329      *
1330      * Requirements:
1331      *
1332      * - `to` cannot be the zero address.
1333      * - `tokenId` token must be owned by `from`.
1334      *
1335      * Emits a {Transfer} event.
1336      */
1337     function _transfer(
1338         address from,
1339         address to,
1340         uint256 tokenId
1341     ) private {
1342         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1343 
1344         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1345             getApproved(tokenId) == _msgSender() ||
1346             isApprovedForAll(prevOwnership.addr, _msgSender()));
1347 
1348         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1349 
1350         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1351         require(to != address(0), "ERC721A: transfer to the zero address");
1352 
1353         _beforeTokenTransfers(from, to, tokenId, 1);
1354 
1355         // Clear approvals from the previous owner
1356         _approve(address(0), tokenId, prevOwnership.addr);
1357 
1358         // Underflow of the sender's balance is impossible because we check for
1359         // ownership above and the recipient's balance can't realistically overflow.
1360         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1361         unchecked {
1362             _addressData[from].balance -= 1;
1363             _addressData[to].balance += 1;
1364 
1365             _ownerships[tokenId].addr = to;
1366             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1367 
1368             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1369             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1370             uint256 nextTokenId = tokenId + 1;
1371             if (_ownerships[nextTokenId].addr == address(0)) {
1372                 if (_exists(nextTokenId)) {
1373                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1374                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1375                 }
1376             }
1377         }
1378 
1379         emit Transfer(from, to, tokenId);
1380         _afterTokenTransfers(from, to, tokenId, 1);
1381     }
1382 
1383     /**
1384      * @dev Approve `to` to operate on `tokenId`
1385      *
1386      * Emits a {Approval} event.
1387      */
1388     function _approve(
1389         address to,
1390         uint256 tokenId,
1391         address owner
1392     ) private {
1393         _tokenApprovals[tokenId] = to;
1394         emit Approval(owner, to, tokenId);
1395     }
1396 
1397     /**
1398      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1399      * The call is not executed if the target address is not a contract.
1400      *
1401      * @param from address representing the previous owner of the given token ID
1402      * @param to target address that will receive the tokens
1403      * @param tokenId uint256 ID of the token to be transferred
1404      * @param _data bytes optional data to send along with the call
1405      * @return bool whether the call correctly returned the expected magic value
1406      */
1407     function _checkOnERC721Received(
1408         address from,
1409         address to,
1410         uint256 tokenId,
1411         bytes memory _data
1412     ) private returns (bool) {
1413         if (to.isContract()) {
1414             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1415                 return retval == IERC721Receiver(to).onERC721Received.selector;
1416             } catch (bytes memory reason) {
1417                 if (reason.length == 0) {
1418                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1419                 } else {
1420                     assembly {
1421                         revert(add(32, reason), mload(reason))
1422                     }
1423                 }
1424             }
1425         } else {
1426             return true;
1427         }
1428     }
1429 
1430     /**
1431      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1432      *
1433      * startTokenId - the first token id to be transferred
1434      * quantity - the amount to be transferred
1435      *
1436      * Calling conditions:
1437      *
1438      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1439      * transferred to `to`.
1440      * - When `from` is zero, `tokenId` will be minted for `to`.
1441      */
1442     function _beforeTokenTransfers(
1443         address from,
1444         address to,
1445         uint256 startTokenId,
1446         uint256 quantity
1447     ) internal virtual {}
1448 
1449     /**
1450      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1451      * minting.
1452      *
1453      * startTokenId - the first token id to be transferred
1454      * quantity - the amount to be transferred
1455      *
1456      * Calling conditions:
1457      *
1458      * - when `from` and `to` are both non-zero.
1459      * - `from` and `to` are never both zero.
1460      */
1461     function _afterTokenTransfers(
1462         address from,
1463         address to,
1464         uint256 startTokenId,
1465         uint256 quantity
1466     ) internal virtual {}
1467 }
1468 
1469 contract rektgoblins is ERC721A, Ownable, ReentrancyGuard {
1470 
1471   uint public nextOwnerToExplicitlySet;
1472   uint public price = 0.005 ether;
1473   uint public maxPerTx = 30;
1474   uint public maxSupply = 10000;
1475   uint public maxPerWallet = 90;
1476   bool public mintEnabled;
1477   string public baseURI;
1478 
1479   constructor() ERC721A("rektgoblins", "REKT") {}
1480   function mint(uint256 num) external payable {
1481     require( num < maxPerTx + 1, "exceeded max per tx");
1482     require(numberMinted(msg.sender) + num < maxPerWallet + 1,"max per wallet exceeded");
1483     require(msg.sender == tx.origin,"be u");
1484     require(msg.value == num * price,"wrong amount");
1485     require(totalSupply() + num < maxSupply + 1,"sold out");
1486     require(mintEnabled, "mint closed.");
1487     _safeMint(msg.sender, num);
1488   }
1489   function reserveMint(uint256 num) external onlyOwner {
1490     require(totalSupply() + num < maxSupply + 1,"not enough to reserve");
1491     _safeMint(msg.sender, num);
1492   }
1493   function setBaseURI(string calldata baseURI_) external onlyOwner {
1494     baseURI = baseURI_;
1495   }
1496   function toggleMint() external onlyOwner {
1497       mintEnabled = !mintEnabled;
1498   }
1499   function numberMinted(address owner) public view returns (uint256) {
1500     return _numberMinted(owner);
1501   }
1502   function setMintPrice(uint256 val) external onlyOwner {
1503       price = val;
1504   }
1505   function setMaxPerTx(uint256 maxPerTx_) external onlyOwner {
1506       maxPerTx = maxPerTx_;
1507   }
1508   function setMaxSupply(uint256 maxSupply_) external onlyOwner {
1509       maxSupply = maxSupply_;
1510   }
1511   function setMaxPerWallet(uint256 maxPerWallet_) external onlyOwner {
1512       maxPerWallet = maxPerWallet_;
1513   }
1514   function _baseURI() internal view virtual override returns (string memory) {
1515     return baseURI;
1516   }
1517   function withdraw() external onlyOwner nonReentrant {
1518     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1519     require(success, "Transfer failed.");
1520   }
1521   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1522     _setOwnersExplicit(quantity);
1523   }
1524   function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1525     return ownershipOf(tokenId);
1526   }
1527   function _setOwnersExplicit(uint256 quantity) internal {
1528       require(quantity != 0, "quantity must be nonzero");
1529       require(currentIndex != 0, "no tokens minted yet");
1530       uint256 _nextOwnerToExplicitlySet = nextOwnerToExplicitlySet;
1531       require(_nextOwnerToExplicitlySet < currentIndex, "all ownerships have been set");
1532 
1533       // Index underflow is impossible.
1534       // Counter or index overflow is incredibly unrealistic.
1535       unchecked {
1536           uint256 endIndex = _nextOwnerToExplicitlySet + quantity - 1;
1537 
1538           // Set the end index to be the last token index
1539           if (endIndex + 1 > currentIndex) {
1540               endIndex = currentIndex - 1;
1541           }
1542 
1543           for (uint256 i = _nextOwnerToExplicitlySet; i <= endIndex; i++) {
1544               if (_ownerships[i].addr == address(0)) {
1545                   TokenOwnership memory ownership = ownershipOf(i);
1546                   _ownerships[i].addr = ownership.addr;
1547                   _ownerships[i].startTimestamp = ownership.startTimestamp;
1548               }
1549           }
1550 
1551           nextOwnerToExplicitlySet = endIndex + 1;
1552       }
1553   }
1554 }