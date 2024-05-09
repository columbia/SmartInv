1 // SPDX-License-Identifier: MIT
2 
3 
4 //   _______ _    _ ______   ____          _____  ______  _____ 
5 //  |__   __| |  | |  ____| |  _ \   /\   |  __ \|  ____|/ ____|
6 //     | |  | |__| | |__    | |_) | /  \  | |__) | |__  | (___  
7 //     | |  |  __  |  __|   |  _ < / /\ \ |  ___/|  __|  \___ \ 
8 //     | |  | |  | | |____  | |_) / ____ \| |    | |____ ____) |
9 //     |_|  |_|  |_|______| |____/_/    \_\_|    |______|_____/ 
10                                                              
11                                                              
12 
13 // Supply: 2,222 NFTs
14 // Total FREE: 722
15 // Rest for 0.005 ETH
16 // Max 2 per tx 
17 
18 
19 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol                            
20 
21 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
22 
23 pragma solidity ^0.8.0;
24 
25 /**
26  * @dev Interface of the ERC20 standard as defined in the EIP.
27  */
28 interface IERC20 {
29     /**
30      * @dev Returns the amount of tokens in existence.
31      */
32     function totalSupply() external view returns (uint256);
33 
34     /**
35      * @dev Returns the amount of tokens owned by `account`.
36      */
37     function balanceOf(address account) external view returns (uint256);
38 
39     /**
40      * @dev Moves `amount` tokens from the caller's account to `to`.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * Emits a {Transfer} event.
45      */
46     function transfer(address to, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Returns the remaining number of tokens that `spender` will be
50      * allowed to spend on behalf of `owner` through {transferFrom}. This is
51      * zero by default.
52      *
53      * This value changes when {approve} or {transferFrom} are called.
54      */
55     function allowance(address owner, address spender) external view returns (uint256);
56 
57     /**
58      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * IMPORTANT: Beware that changing an allowance with this method brings the risk
63      * that someone may use both the old and the new allowance by unfortunate
64      * transaction ordering. One possible solution to mitigate this race
65      * condition is to first reduce the spender's allowance to 0 and set the
66      * desired value afterwards:
67      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
68      *
69      * Emits an {Approval} event.
70      */
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Moves `amount` tokens from `from` to `to` using the
75      * allowance mechanism. `amount` is then deducted from the caller's
76      * allowance.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * Emits a {Transfer} event.
81      */
82     function transferFrom(
83         address from,
84         address to,
85         uint256 amount
86     ) external returns (bool);
87 
88     /**
89      * @dev Emitted when `value` tokens are moved from one account (`from`) to
90      * another (`to`).
91      *
92      * Note that `value` may be zero.
93      */
94     event Transfer(address indexed from, address indexed to, uint256 value);
95 
96     /**
97      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
98      * a call to {approve}. `value` is the new allowance.
99      */
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
104 
105 
106 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
107 
108 pragma solidity ^0.8.0;
109 
110 /**
111  * @dev Contract module that helps prevent reentrant calls to a function.
112  *
113  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
114  * available, which can be applied to functions to make sure there are no nested
115  * (reentrant) calls to them.
116  *
117  * Note that because there is a single `nonReentrant` guard, functions marked as
118  * `nonReentrant` may not call one another. This can be worked around by making
119  * those functions `private`, and then adding `external` `nonReentrant` entry
120  * points to them.
121  *
122  * TIP: If you would like to learn more about reentrancy and alternative ways
123  * to protect against it, check out our blog post
124  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
125  */
126 abstract contract ReentrancyGuard {
127     // Booleans are more expensive than uint256 or any type that takes up a full
128     // word because each write operation emits an extra SLOAD to first read the
129     // slot's contents, replace the bits taken up by the boolean, and then write
130     // back. This is the compiler's defense against contract upgrades and
131     // pointer aliasing, and it cannot be disabled.
132 
133     // The values being non-zero value makes deployment a bit more expensive,
134     // but in exchange the refund on every call to nonReentrant will be lower in
135     // amount. Since refunds are capped to a percentage of the total
136     // transaction's gas, it is best to keep them low in cases like this one, to
137     // increase the likelihood of the full refund coming into effect.
138     uint256 private constant _NOT_ENTERED = 1;
139     uint256 private constant _ENTERED = 2;
140 
141     uint256 private _status;
142 
143     constructor() {
144         _status = _NOT_ENTERED;
145     }
146 
147     /**
148      * @dev Prevents a contract from calling itself, directly or indirectly.
149      * Calling a `nonReentrant` function from another `nonReentrant`
150      * function is not supported. It is possible to prevent this from happening
151      * by making the `nonReentrant` function external, and making it call a
152      * `private` function that does the actual work.
153      */
154     modifier nonReentrant() {
155         // On the first call to nonReentrant, _notEntered will be true
156         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
157 
158         // Any calls to nonReentrant after this point will fail
159         _status = _ENTERED;
160 
161         _;
162 
163         // By storing the original value once again, a refund is triggered (see
164         // https://eips.ethereum.org/EIPS/eip-2200)
165         _status = _NOT_ENTERED;
166     }
167 }
168 
169 // File: @openzeppelin/contracts/utils/Strings.sol
170 
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
226     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
227         bytes memory buffer = new bytes(2 * length + 2);
228         buffer[0] = "0";
229         buffer[1] = "x";
230         for (uint256 i = 2 * length + 1; i > 1; --i) {
231             buffer[i] = _HEX_SYMBOLS[value & 0xf];
232             value >>= 4;
233         }
234         require(value == 0, "Strings: hex length insufficient");
235         return string(buffer);
236     }
237 }
238 
239 // File: @openzeppelin/contracts/utils/Context.sol
240 
241 
242 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
243 
244 pragma solidity ^0.8.0;
245 
246 /**
247  * @dev Provides information about the current execution context, including the
248  * sender of the transaction and its data. While these are generally available
249  * via msg.sender and msg.data, they should not be accessed in such a direct
250  * manner, since when dealing with meta-transactions the account sending and
251  * paying for execution may not be the actual sender (as far as an application
252  * is concerned).
253  *
254  * This contract is only required for intermediate, library-like contracts.
255  */
256 abstract contract Context {
257     function _msgSender() internal view virtual returns (address) {
258         return msg.sender;
259     }
260 
261     function _msgData() internal view virtual returns (bytes calldata) {
262         return msg.data;
263     }
264 }
265 
266 // File: @openzeppelin/contracts/access/Ownable.sol
267 
268 
269 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
270 
271 pragma solidity ^0.8.0;
272 
273 
274 /**
275  * @dev Contract module which provides a basic access control mechanism, where
276  * there is an account (an owner) that can be granted exclusive access to
277  * specific functions.
278  *
279  * By default, the owner account will be the one that deploys the contract. This
280  * can later be changed with {transferOwnership}.
281  *
282  * This module is used through inheritance. It will make available the modifier
283  * `onlyOwner`, which can be applied to your functions to restrict their use to
284  * the owner.
285  */
286 abstract contract Ownable is Context {
287     address private _owner;
288 
289     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
290 
291     /**
292      * @dev Initializes the contract setting the deployer as the initial owner.
293      */
294     constructor() {
295         _transferOwnership(_msgSender());
296     }
297 
298     /**
299      * @dev Returns the address of the current owner.
300      */
301     function owner() public view virtual returns (address) {
302         return _owner;
303     }
304 
305     /**
306      * @dev Throws if called by any account other than the owner.
307      */
308     modifier onlyOwner() {
309         require(owner() == _msgSender(), "Ownable: caller is not the owner");
310         _;
311     }
312 
313     /**
314      * @dev Leaves the contract without owner. It will not be possible to call
315      * `onlyOwner` functions anymore. Can only be called by the current owner.
316      *
317      * NOTE: Renouncing ownership will leave the contract without an owner,
318      * thereby removing any functionality that is only available to the owner.
319      */
320     function renounceOwnership() public virtual onlyOwner {
321         _transferOwnership(address(0));
322     }
323 
324     /**
325      * @dev Transfers ownership of the contract to a new account (`newOwner`).
326      * Can only be called by the current owner.
327      */
328     function transferOwnership(address newOwner) public virtual onlyOwner {
329         require(newOwner != address(0), "Ownable: new owner is the zero address");
330         _transferOwnership(newOwner);
331     }
332 
333     /**
334      * @dev Transfers ownership of the contract to a new account (`newOwner`).
335      * Internal function without access restriction.
336      */
337     function _transferOwnership(address newOwner) internal virtual {
338         address oldOwner = _owner;
339         _owner = newOwner;
340         emit OwnershipTransferred(oldOwner, newOwner);
341     }
342 }
343 
344 // File: @openzeppelin/contracts/utils/Address.sol
345 
346 
347 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
348 
349 pragma solidity ^0.8.1;
350 
351 /**
352  * @dev Collection of functions related to the address type
353  */
354 library Address {
355     /**
356      * @dev Returns true if `account` is a contract.
357      *
358      * [IMPORTANT]
359      * ====
360      * It is unsafe to assume that an address for which this function returns
361      * false is an externally-owned account (EOA) and not a contract.
362      *
363      * Among others, `isContract` will return false for the following
364      * types of addresses:
365      *
366      *  - an externally-owned account
367      *  - a contract in construction
368      *  - an address where a contract will be created
369      *  - an address where a contract lived, but was destroyed
370      * ====
371      *
372      * [IMPORTANT]
373      * ====
374      * You shouldn't rely on `isContract` to protect against flash loan attacks!
375      *
376      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
377      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
378      * constructor.
379      * ====
380      */
381     function isContract(address account) internal view returns (bool) {
382         // This method relies on extcodesize/address.code.length, which returns 0
383         // for contracts in construction, since the code is only stored at the end
384         // of the constructor execution.
385 
386         return account.code.length > 0;
387     }
388 
389     /**
390      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
391      * `recipient`, forwarding all available gas and reverting on errors.
392      *
393      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
394      * of certain opcodes, possibly making contracts go over the 2300 gas limit
395      * imposed by `transfer`, making them unable to receive funds via
396      * `transfer`. {sendValue} removes this limitation.
397      *
398      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
399      *
400      * IMPORTANT: because control is transferred to `recipient`, care must be
401      * taken to not create reentrancy vulnerabilities. Consider using
402      * {ReentrancyGuard} or the
403      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
404      */
405     function sendValue(address payable recipient, uint256 amount) internal {
406         require(address(this).balance >= amount, "Address: insufficient balance");
407 
408         (bool success, ) = recipient.call{value: amount}("");
409         require(success, "Address: unable to send value, recipient may have reverted");
410     }
411 
412     /**
413      * @dev Performs a Solidity function call using a low level `call`. A
414      * plain `call` is an unsafe replacement for a function call: use this
415      * function instead.
416      *
417      * If `target` reverts with a revert reason, it is bubbled up by this
418      * function (like regular Solidity function calls).
419      *
420      * Returns the raw returned data. To convert to the expected return value,
421      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
422      *
423      * Requirements:
424      *
425      * - `target` must be a contract.
426      * - calling `target` with `data` must not revert.
427      *
428      * _Available since v3.1._
429      */
430     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
431         return functionCall(target, data, "Address: low-level call failed");
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
436      * `errorMessage` as a fallback revert reason when `target` reverts.
437      *
438      * _Available since v3.1._
439      */
440     function functionCall(
441         address target,
442         bytes memory data,
443         string memory errorMessage
444     ) internal returns (bytes memory) {
445         return functionCallWithValue(target, data, 0, errorMessage);
446     }
447 
448     /**
449      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
450      * but also transferring `value` wei to `target`.
451      *
452      * Requirements:
453      *
454      * - the calling contract must have an ETH balance of at least `value`.
455      * - the called Solidity function must be `payable`.
456      *
457      * _Available since v3.1._
458      */
459     function functionCallWithValue(
460         address target,
461         bytes memory data,
462         uint256 value
463     ) internal returns (bytes memory) {
464         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
465     }
466 
467     /**
468      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
469      * with `errorMessage` as a fallback revert reason when `target` reverts.
470      *
471      * _Available since v3.1._
472      */
473     function functionCallWithValue(
474         address target,
475         bytes memory data,
476         uint256 value,
477         string memory errorMessage
478     ) internal returns (bytes memory) {
479         require(address(this).balance >= value, "Address: insufficient balance for call");
480         require(isContract(target), "Address: call to non-contract");
481 
482         (bool success, bytes memory returndata) = target.call{value: value}(data);
483         return verifyCallResult(success, returndata, errorMessage);
484     }
485 
486     /**
487      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
488      * but performing a static call.
489      *
490      * _Available since v3.3._
491      */
492     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
493         return functionStaticCall(target, data, "Address: low-level static call failed");
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
498      * but performing a static call.
499      *
500      * _Available since v3.3._
501      */
502     function functionStaticCall(
503         address target,
504         bytes memory data,
505         string memory errorMessage
506     ) internal view returns (bytes memory) {
507         require(isContract(target), "Address: static call to non-contract");
508 
509         (bool success, bytes memory returndata) = target.staticcall(data);
510         return verifyCallResult(success, returndata, errorMessage);
511     }
512 
513     /**
514      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
515      * but performing a delegate call.
516      *
517      * _Available since v3.4._
518      */
519     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
520         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
521     }
522 
523     /**
524      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
525      * but performing a delegate call.
526      *
527      * _Available since v3.4._
528      */
529     function functionDelegateCall(
530         address target,
531         bytes memory data,
532         string memory errorMessage
533     ) internal returns (bytes memory) {
534         require(isContract(target), "Address: delegate call to non-contract");
535 
536         (bool success, bytes memory returndata) = target.delegatecall(data);
537         return verifyCallResult(success, returndata, errorMessage);
538     }
539 
540     /**
541      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
542      * revert reason using the provided one.
543      *
544      * _Available since v4.3._
545      */
546     function verifyCallResult(
547         bool success,
548         bytes memory returndata,
549         string memory errorMessage
550     ) internal pure returns (bytes memory) {
551         if (success) {
552             return returndata;
553         } else {
554             // Look for revert reason and bubble it up if present
555             if (returndata.length > 0) {
556                 // The easiest way to bubble the revert reason is using memory via assembly
557 
558                 assembly {
559                     let returndata_size := mload(returndata)
560                     revert(add(32, returndata), returndata_size)
561                 }
562             } else {
563                 revert(errorMessage);
564             }
565         }
566     }
567 }
568 
569 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
570 
571 
572 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
573 
574 pragma solidity ^0.8.0;
575 
576 
577 
578 /**
579  * @title SafeERC20
580  * @dev Wrappers around ERC20 operations that throw on failure (when the token
581  * contract returns false). Tokens that return no value (and instead revert or
582  * throw on failure) are also supported, non-reverting calls are assumed to be
583  * successful.
584  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
585  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
586  */
587 library SafeERC20 {
588     using Address for address;
589 
590     function safeTransfer(
591         IERC20 token,
592         address to,
593         uint256 value
594     ) internal {
595         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
596     }
597 
598     function safeTransferFrom(
599         IERC20 token,
600         address from,
601         address to,
602         uint256 value
603     ) internal {
604         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
605     }
606 
607     /**
608      * @dev Deprecated. This function has issues similar to the ones found in
609      * {IERC20-approve}, and its usage is discouraged.
610      *
611      * Whenever possible, use {safeIncreaseAllowance} and
612      * {safeDecreaseAllowance} instead.
613      */
614     function safeApprove(
615         IERC20 token,
616         address spender,
617         uint256 value
618     ) internal {
619         // safeApprove should only be called when setting an initial allowance,
620         // or when resetting it to zero. To increase and decrease it, use
621         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
622         require(
623             (value == 0) || (token.allowance(address(this), spender) == 0),
624             "SafeERC20: approve from non-zero to non-zero allowance"
625         );
626         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
627     }
628 
629     function safeIncreaseAllowance(
630         IERC20 token,
631         address spender,
632         uint256 value
633     ) internal {
634         uint256 newAllowance = token.allowance(address(this), spender) + value;
635         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
636     }
637 
638     function safeDecreaseAllowance(
639         IERC20 token,
640         address spender,
641         uint256 value
642     ) internal {
643         unchecked {
644             uint256 oldAllowance = token.allowance(address(this), spender);
645             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
646             uint256 newAllowance = oldAllowance - value;
647             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
648         }
649     }
650 
651     /**
652      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
653      * on the return value: the return value is optional (but if data is returned, it must not be false).
654      * @param token The token targeted by the call.
655      * @param data The call data (encoded using abi.encode or one of its variants).
656      */
657     function _callOptionalReturn(IERC20 token, bytes memory data) private {
658         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
659         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
660         // the target address contains contract code and also asserts for success in the low-level call.
661 
662         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
663         if (returndata.length > 0) {
664             // Return data is optional
665             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
666         }
667     }
668 }
669 
670 
671 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
672 
673 
674 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
675 
676 pragma solidity ^0.8.0;
677 
678 /**
679  * @title ERC721 token receiver interface
680  * @dev Interface for any contract that wants to support safeTransfers
681  * from ERC721 asset contracts.
682  */
683 interface IERC721Receiver {
684     /**
685      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
686      * by `operator` from `from`, this function is called.
687      *
688      * It must return its Solidity selector to confirm the token transfer.
689      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
690      *
691      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
692      */
693     function onERC721Received(
694         address operator,
695         address from,
696         uint256 tokenId,
697         bytes calldata data
698     ) external returns (bytes4);
699 }
700 
701 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
702 
703 
704 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
705 
706 pragma solidity ^0.8.0;
707 
708 /**
709  * @dev Interface of the ERC165 standard, as defined in the
710  * https://eips.ethereum.org/EIPS/eip-165[EIP].
711  *
712  * Implementers can declare support of contract interfaces, which can then be
713  * queried by others ({ERC165Checker}).
714  *
715  * For an implementation, see {ERC165}.
716  */
717 interface IERC165 {
718     /**
719      * @dev Returns true if this contract implements the interface defined by
720      * `interfaceId`. See the corresponding
721      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
722      * to learn more about how these ids are created.
723      *
724      * This function call must use less than 30 000 gas.
725      */
726     function supportsInterface(bytes4 interfaceId) external view returns (bool);
727 }
728 
729 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
730 
731 
732 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
733 
734 pragma solidity ^0.8.0;
735 
736 
737 /**
738  * @dev Implementation of the {IERC165} interface.
739  *
740  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
741  * for the additional interface id that will be supported. For example:
742  *
743  * ```solidity
744  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
745  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
746  * }
747  * ```
748  *
749  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
750  */
751 abstract contract ERC165 is IERC165 {
752     /**
753      * @dev See {IERC165-supportsInterface}.
754      */
755     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
756         return interfaceId == type(IERC165).interfaceId;
757     }
758 }
759 
760 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
761 
762 
763 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
764 
765 pragma solidity ^0.8.0;
766 
767 
768 /**
769  * @dev Required interface of an ERC721 compliant contract.
770  */
771 interface IERC721 is IERC165 {
772     /**
773      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
774      */
775     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
776 
777     /**
778      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
779      */
780     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
781 
782     /**
783      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
784      */
785     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
786 
787     /**
788      * @dev Returns the number of tokens in ``owner``'s account.
789      */
790     function balanceOf(address owner) external view returns (uint256 balance);
791 
792     /**
793      * @dev Returns the owner of the `tokenId` token.
794      *
795      * Requirements:
796      *
797      * - `tokenId` must exist.
798      */
799     function ownerOf(uint256 tokenId) external view returns (address owner);
800 
801     /**
802      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
803      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
804      *
805      * Requirements:
806      *
807      * - `from` cannot be the zero address.
808      * - `to` cannot be the zero address.
809      * - `tokenId` token must exist and be owned by `from`.
810      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
811      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
812      *
813      * Emits a {Transfer} event.
814      */
815     function safeTransferFrom(
816         address from,
817         address to,
818         uint256 tokenId
819     ) external;
820 
821     /**
822      * @dev Transfers `tokenId` token from `from` to `to`.
823      *
824      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
825      *
826      * Requirements:
827      *
828      * - `from` cannot be the zero address.
829      * - `to` cannot be the zero address.
830      * - `tokenId` token must be owned by `from`.
831      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
832      *
833      * Emits a {Transfer} event.
834      */
835     function transferFrom(
836         address from,
837         address to,
838         uint256 tokenId
839     ) external;
840 
841     /**
842      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
843      * The approval is cleared when the token is transferred.
844      *
845      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
846      *
847      * Requirements:
848      *
849      * - The caller must own the token or be an approved operator.
850      * - `tokenId` must exist.
851      *
852      * Emits an {Approval} event.
853      */
854     function approve(address to, uint256 tokenId) external;
855 
856     /**
857      * @dev Returns the account approved for `tokenId` token.
858      *
859      * Requirements:
860      *
861      * - `tokenId` must exist.
862      */
863     function getApproved(uint256 tokenId) external view returns (address operator);
864 
865     /**
866      * @dev Approve or remove `operator` as an operator for the caller.
867      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
868      *
869      * Requirements:
870      *
871      * - The `operator` cannot be the caller.
872      *
873      * Emits an {ApprovalForAll} event.
874      */
875     function setApprovalForAll(address operator, bool _approved) external;
876 
877     /**
878      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
879      *
880      * See {setApprovalForAll}
881      */
882     function isApprovedForAll(address owner, address operator) external view returns (bool);
883 
884     /**
885      * @dev Safely transfers `tokenId` token from `from` to `to`.
886      *
887      * Requirements:
888      *
889      * - `from` cannot be the zero address.
890      * - `to` cannot be the zero address.
891      * - `tokenId` token must exist and be owned by `from`.
892      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
893      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
894      *
895      * Emits a {Transfer} event.
896      */
897     function safeTransferFrom(
898         address from,
899         address to,
900         uint256 tokenId,
901         bytes calldata data
902     ) external;
903 }
904 
905 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
906 
907 
908 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
909 
910 pragma solidity ^0.8.0;
911 
912 
913 /**
914  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
915  * @dev See https://eips.ethereum.org/EIPS/eip-721
916  */
917 interface IERC721Enumerable is IERC721 {
918     /**
919      * @dev Returns the total amount of tokens stored by the contract.
920      */
921     function totalSupply() external view returns (uint256);
922 
923     /**
924      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
925      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
926      */
927     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
928 
929     /**
930      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
931      * Use along with {totalSupply} to enumerate all tokens.
932      */
933     function tokenByIndex(uint256 index) external view returns (uint256);
934 }
935 
936 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
937 
938 
939 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
940 
941 pragma solidity ^0.8.0;
942 
943 
944 /**
945  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
946  * @dev See https://eips.ethereum.org/EIPS/eip-721
947  */
948 interface IERC721Metadata is IERC721 {
949     /**
950      * @dev Returns the token collection name.
951      */
952     function name() external view returns (string memory);
953 
954     /**
955      * @dev Returns the token collection symbol.
956      */
957     function symbol() external view returns (string memory);
958 
959     /**
960      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
961      */
962     function tokenURI(uint256 tokenId) external view returns (string memory);
963 }
964 
965 // File: contracts/TwistedToonz.sol
966 
967 
968 // Creator: Chiru Labs
969 
970 pragma solidity ^0.8.0;
971 
972 
973 
974 
975 
976 
977 
978 
979 
980 /**
981  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
982  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
983  *
984  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
985  *
986  * Does not support burning tokens to address(0).
987  *
988  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
989  */
990 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
991     using Address for address;
992     using Strings for uint256;
993 
994     struct TokenOwnership {
995         address addr;
996         uint64 startTimestamp;
997     }
998 
999     struct AddressData {
1000         uint128 balance;
1001         uint128 numberMinted;
1002     }
1003 
1004     uint256 internal currentIndex;
1005 
1006     // Token name
1007     string private _name;
1008 
1009     // Token symbol
1010     string private _symbol;
1011 
1012     // Mapping from token ID to ownership details
1013     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1014     mapping(uint256 => TokenOwnership) internal _ownerships;
1015 
1016     // Mapping owner address to address data
1017     mapping(address => AddressData) private _addressData;
1018 
1019     // Mapping from token ID to approved address
1020     mapping(uint256 => address) private _tokenApprovals;
1021 
1022     // Mapping from owner to operator approvals
1023     mapping(address => mapping(address => bool)) private _operatorApprovals;
1024 
1025     constructor(string memory name_, string memory symbol_) {
1026         _name = name_;
1027         _symbol = symbol_;
1028     }
1029 
1030     /**
1031      * @dev See {IERC721Enumerable-totalSupply}.
1032      */
1033     function totalSupply() public view override returns (uint256) {
1034         return currentIndex;
1035     }
1036 
1037     /**
1038      * @dev See {IERC721Enumerable-tokenByIndex}.
1039      */
1040     function tokenByIndex(uint256 index) public view override returns (uint256) {
1041         require(index < totalSupply(), "ERC721A: global index out of bounds");
1042         return index;
1043     }
1044 
1045     /**
1046      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1047      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1048      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1049      */
1050     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1051         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1052         uint256 numMintedSoFar = totalSupply();
1053         uint256 tokenIdsIdx;
1054         address currOwnershipAddr;
1055 
1056         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1057         unchecked {
1058             for (uint256 i; i < numMintedSoFar; i++) {
1059                 TokenOwnership memory ownership = _ownerships[i];
1060                 if (ownership.addr != address(0)) {
1061                     currOwnershipAddr = ownership.addr;
1062                 }
1063                 if (currOwnershipAddr == owner) {
1064                     if (tokenIdsIdx == index) {
1065                         return i;
1066                     }
1067                     tokenIdsIdx++;
1068                 }
1069             }
1070         }
1071 
1072         revert("ERC721A: unable to get token of owner by index");
1073     }
1074 
1075     /**
1076      * @dev See {IERC165-supportsInterface}.
1077      */
1078     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1079         return
1080             interfaceId == type(IERC721).interfaceId ||
1081             interfaceId == type(IERC721Metadata).interfaceId ||
1082             interfaceId == type(IERC721Enumerable).interfaceId ||
1083             super.supportsInterface(interfaceId);
1084     }
1085 
1086     /**
1087      * @dev See {IERC721-balanceOf}.
1088      */
1089     function balanceOf(address owner) public view override returns (uint256) {
1090         require(owner != address(0), "ERC721A: balance query for the zero address");
1091         return uint256(_addressData[owner].balance);
1092     }
1093 
1094     function _numberMinted(address owner) internal view returns (uint256) {
1095         require(owner != address(0), "ERC721A: number minted query for the zero address");
1096         return uint256(_addressData[owner].numberMinted);
1097     }
1098 
1099     /**
1100      * Gas spent here starts off proportional to the maximum mint batch size.
1101      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1102      */
1103     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1104         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1105 
1106         unchecked {
1107             for (uint256 curr = tokenId; curr >= 0; curr--) {
1108                 TokenOwnership memory ownership = _ownerships[curr];
1109                 if (ownership.addr != address(0)) {
1110                     return ownership;
1111                 }
1112             }
1113         }
1114 
1115         revert("ERC721A: unable to determine the owner of token");
1116     }
1117 
1118     /**
1119      * @dev See {IERC721-ownerOf}.
1120      */
1121     function ownerOf(uint256 tokenId) public view override returns (address) {
1122         return ownershipOf(tokenId).addr;
1123     }
1124 
1125     /**
1126      * @dev See {IERC721Metadata-name}.
1127      */
1128     function name() public view virtual override returns (string memory) {
1129         return _name;
1130     }
1131 
1132     /**
1133      * @dev See {IERC721Metadata-symbol}.
1134      */
1135     function symbol() public view virtual override returns (string memory) {
1136         return _symbol;
1137     }
1138 
1139     /**
1140      * @dev See {IERC721Metadata-tokenURI}.
1141      */
1142     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1143         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1144 
1145         string memory baseURI = _baseURI();
1146         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1147     }
1148 
1149     /**
1150      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1151      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1152      * by default, can be overriden in child contracts.
1153      */
1154     function _baseURI() internal view virtual returns (string memory) {
1155         return "";
1156     }
1157 
1158     /**
1159      * @dev See {IERC721-approve}.
1160      */
1161     function approve(address to, uint256 tokenId) public override {
1162         address owner = ERC721A.ownerOf(tokenId);
1163         require(to != owner, "ERC721A: approval to current owner");
1164 
1165         require(
1166             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1167             "ERC721A: approve caller is not owner nor approved for all"
1168         );
1169 
1170         _approve(to, tokenId, owner);
1171     }
1172 
1173     /**
1174      * @dev See {IERC721-getApproved}.
1175      */
1176     function getApproved(uint256 tokenId) public view override returns (address) {
1177         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1178 
1179         return _tokenApprovals[tokenId];
1180     }
1181 
1182     /**
1183      * @dev See {IERC721-setApprovalForAll}.
1184      */
1185     function setApprovalForAll(address operator, bool approved) public override {
1186         require(operator != _msgSender(), "ERC721A: approve to caller");
1187 
1188         _operatorApprovals[_msgSender()][operator] = approved;
1189         emit ApprovalForAll(_msgSender(), operator, approved);
1190     }
1191 
1192     /**
1193      * @dev See {IERC721-isApprovedForAll}.
1194      */
1195     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1196         return _operatorApprovals[owner][operator];
1197     }
1198 
1199     /**
1200      * @dev See {IERC721-transferFrom}.
1201      */
1202     function transferFrom(
1203         address from,
1204         address to,
1205         uint256 tokenId
1206     ) public virtual override {
1207         _transfer(from, to, tokenId);
1208     }
1209 
1210     /**
1211      * @dev See {IERC721-safeTransferFrom}.
1212      */
1213     function safeTransferFrom(
1214         address from,
1215         address to,
1216         uint256 tokenId
1217     ) public virtual override {
1218         safeTransferFrom(from, to, tokenId, "");
1219     }
1220 
1221     /**
1222      * @dev See {IERC721-safeTransferFrom}.
1223      */
1224     function safeTransferFrom(
1225         address from,
1226         address to,
1227         uint256 tokenId,
1228         bytes memory _data
1229     ) public override {
1230         _transfer(from, to, tokenId);
1231         require(
1232             _checkOnERC721Received(from, to, tokenId, _data),
1233             "ERC721A: transfer to non ERC721Receiver implementer"
1234         );
1235     }
1236 
1237     /**
1238      * @dev Returns whether `tokenId` exists.
1239      *
1240      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1241      *
1242      * Tokens start existing when they are minted (`_mint`),
1243      */
1244     function _exists(uint256 tokenId) internal view returns (bool) {
1245         return tokenId < currentIndex;
1246     }
1247 
1248     function _safeMint(address to, uint256 quantity) internal {
1249         _safeMint(to, quantity, "");
1250     }
1251 
1252     /**
1253      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1254      *
1255      * Requirements:
1256      *
1257      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1258      * - `quantity` must be greater than 0.
1259      *
1260      * Emits a {Transfer} event.
1261      */
1262     function _safeMint(
1263         address to,
1264         uint256 quantity,
1265         bytes memory _data
1266     ) internal {
1267         _mint(to, quantity, _data, true);
1268     }
1269 
1270     /**
1271      * @dev Mints `quantity` tokens and transfers them to `to`.
1272      *
1273      * Requirements:
1274      *
1275      * - `to` cannot be the zero address.
1276      * - `quantity` must be greater than 0.
1277      *
1278      * Emits a {Transfer} event.
1279      */
1280     function _mint(
1281         address to,
1282         uint256 quantity,
1283         bytes memory _data,
1284         bool safe
1285     ) internal {
1286         uint256 startTokenId = currentIndex;
1287         require(to != address(0), "ERC721A: mint to the zero address");
1288         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1289 
1290         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1291 
1292         // Overflows are incredibly unrealistic.
1293         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1294         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1295         unchecked {
1296             _addressData[to].balance += uint128(quantity);
1297             _addressData[to].numberMinted += uint128(quantity);
1298 
1299             _ownerships[startTokenId].addr = to;
1300             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1301 
1302             uint256 updatedIndex = startTokenId;
1303 
1304             for (uint256 i; i < quantity; i++) {
1305                 emit Transfer(address(0), to, updatedIndex);
1306                 if (safe) {
1307                     require(
1308                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1309                         "ERC721A: transfer to non ERC721Receiver implementer"
1310                     );
1311                 }
1312 
1313                 updatedIndex++;
1314             }
1315 
1316             currentIndex = updatedIndex;
1317         }
1318 
1319         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1320     }
1321 
1322     /**
1323      * @dev Transfers `tokenId` from `from` to `to`.
1324      *
1325      * Requirements:
1326      *
1327      * - `to` cannot be the zero address.
1328      * - `tokenId` token must be owned by `from`.
1329      *
1330      * Emits a {Transfer} event.
1331      */
1332     function _transfer(
1333         address from,
1334         address to,
1335         uint256 tokenId
1336     ) private {
1337         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1338 
1339         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1340             getApproved(tokenId) == _msgSender() ||
1341             isApprovedForAll(prevOwnership.addr, _msgSender()));
1342 
1343         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1344 
1345         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1346         require(to != address(0), "ERC721A: transfer to the zero address");
1347 
1348         _beforeTokenTransfers(from, to, tokenId, 1);
1349 
1350         // Clear approvals from the previous owner
1351         _approve(address(0), tokenId, prevOwnership.addr);
1352 
1353         // Underflow of the sender's balance is impossible because we check for
1354         // ownership above and the recipient's balance can't realistically overflow.
1355         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1356         unchecked {
1357             _addressData[from].balance -= 1;
1358             _addressData[to].balance += 1;
1359 
1360             _ownerships[tokenId].addr = to;
1361             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1362 
1363             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1364             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1365             uint256 nextTokenId = tokenId + 1;
1366             if (_ownerships[nextTokenId].addr == address(0)) {
1367                 if (_exists(nextTokenId)) {
1368                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1369                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1370                 }
1371             }
1372         }
1373 
1374         emit Transfer(from, to, tokenId);
1375         _afterTokenTransfers(from, to, tokenId, 1);
1376     }
1377 
1378     /**
1379      * @dev Approve `to` to operate on `tokenId`
1380      *
1381      * Emits a {Approval} event.
1382      */
1383     function _approve(
1384         address to,
1385         uint256 tokenId,
1386         address owner
1387     ) private {
1388         _tokenApprovals[tokenId] = to;
1389         emit Approval(owner, to, tokenId);
1390     }
1391 
1392     /**
1393      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1394      * The call is not executed if the target address is not a contract.
1395      *
1396      * @param from address representing the previous owner of the given token ID
1397      * @param to target address that will receive the tokens
1398      * @param tokenId uint256 ID of the token to be transferred
1399      * @param _data bytes optional data to send along with the call
1400      * @return bool whether the call correctly returned the expected magic value
1401      */
1402     function _checkOnERC721Received(
1403         address from,
1404         address to,
1405         uint256 tokenId,
1406         bytes memory _data
1407     ) private returns (bool) {
1408         if (to.isContract()) {
1409             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1410                 return retval == IERC721Receiver(to).onERC721Received.selector;
1411             } catch (bytes memory reason) {
1412                 if (reason.length == 0) {
1413                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1414                 } else {
1415                     assembly {
1416                         revert(add(32, reason), mload(reason))
1417                     }
1418                 }
1419             }
1420         } else {
1421             return true;
1422         }
1423     }
1424 
1425     /**
1426      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1427      *
1428      * startTokenId - the first token id to be transferred
1429      * quantity - the amount to be transferred
1430      *
1431      * Calling conditions:
1432      *
1433      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1434      * transferred to `to`.
1435      * - When `from` is zero, `tokenId` will be minted for `to`.
1436      */
1437     function _beforeTokenTransfers(
1438         address from,
1439         address to,
1440         uint256 startTokenId,
1441         uint256 quantity
1442     ) internal virtual {}
1443 
1444     /**
1445      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1446      * minting.
1447      *
1448      * startTokenId - the first token id to be transferred
1449      * quantity - the amount to be transferred
1450      *
1451      * Calling conditions:
1452      *
1453      * - when `from` and `to` are both non-zero.
1454      * - `from` and `to` are never both zero.
1455      */
1456     function _afterTokenTransfers(
1457         address from,
1458         address to,
1459         uint256 startTokenId,
1460         uint256 quantity
1461     ) internal virtual {}
1462 }
1463 
1464 contract TheBapes is ERC721A, Ownable, ReentrancyGuard {
1465 
1466   
1467   uint public price = 0.005 ether;
1468   uint public maxPerTx = 2;
1469   uint public maxDuringFree = 2;
1470   uint public totalFree = 722;
1471   uint public maxSupply = 2222;
1472   bool public mintEnabled;
1473   string public baseURI;
1474 
1475 
1476   constructor() ERC721A("The Bapes", "BAPES"){
1477   }
1478 
1479   function mint(uint256 amount) external payable
1480   {
1481     uint cost = price;
1482 
1483     if(totalSupply() + amount < totalFree + 1) {
1484       require(numberMinted(msg.sender) + amount < maxDuringFree + 1);
1485       cost = 0;
1486     }
1487 
1488     require(mintEnabled, "Minting is not live yet, hold on bape");
1489     require(totalSupply() + amount < maxSupply + 1,"No more bapes");
1490     require(msg.value >= amount * cost,"Please send the exact amount");
1491     require(amount < maxPerTx + 1, "Max per TX reached");
1492     
1493     _safeMint(msg.sender, amount);
1494   }
1495 
1496   function ownerBatchMint(uint256 amount) external onlyOwner
1497   {
1498     require(totalSupply() + amount < maxSupply + 1,"too many!");
1499 
1500     _safeMint(msg.sender, amount);
1501   }
1502 
1503   function toggleMinting() external onlyOwner {
1504       mintEnabled = !mintEnabled;
1505   }
1506 
1507   function numberMinted(address owner) public view returns (uint256) {
1508     return _numberMinted(owner);
1509   }
1510 
1511   function setBaseURI(string calldata baseURI_) external onlyOwner {
1512     baseURI = baseURI_;
1513   }
1514 
1515   function setPrice(uint256 price_) external onlyOwner {
1516       price = price_;
1517   }
1518 
1519   function setTotalFree(uint256 totalFree_) external onlyOwner {
1520       totalFree = totalFree_;
1521   }
1522 
1523   function setMaxPerTx(uint256 maxPerTx_) external onlyOwner {
1524       maxPerTx = maxPerTx_;
1525   }
1526 
1527   function _baseURI() internal view virtual override returns (string memory) {
1528     return baseURI;
1529   }
1530 
1531   function withdraw() external onlyOwner nonReentrant {
1532     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1533     require(success, "Transfer failed.");
1534   }
1535 }