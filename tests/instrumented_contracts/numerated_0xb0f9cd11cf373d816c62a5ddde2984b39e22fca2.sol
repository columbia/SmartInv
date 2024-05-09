1 // SPDX-License-Identifier: GPL-3.0
2 
3 // File: default_workspace/IPinballerItem.sol
4 
5 pragma solidity ^0.8.12;
6 
7 interface IPinballerItem 
8 {
9     function mintForAddress(address _sender, uint _toBurn) external;
10 }
11 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
12 
13 
14 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @dev Contract module that helps prevent reentrant calls to a function.
20  *
21  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
22  * available, which can be applied to functions to make sure there are no nested
23  * (reentrant) calls to them.
24  *
25  * Note that because there is a single `nonReentrant` guard, functions marked as
26  * `nonReentrant` may not call one another. This can be worked around by making
27  * those functions `private`, and then adding `external` `nonReentrant` entry
28  * points to them.
29  *
30  * TIP: If you would like to learn more about reentrancy and alternative ways
31  * to protect against it, check out our blog post
32  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
33  */
34 abstract contract ReentrancyGuard {
35     // Booleans are more expensive than uint256 or any type that takes up a full
36     // word because each write operation emits an extra SLOAD to first read the
37     // slot's contents, replace the bits taken up by the boolean, and then write
38     // back. This is the compiler's defense against contract upgrades and
39     // pointer aliasing, and it cannot be disabled.
40 
41     // The values being non-zero value makes deployment a bit more expensive,
42     // but in exchange the refund on every call to nonReentrant will be lower in
43     // amount. Since refunds are capped to a percentage of the total
44     // transaction's gas, it is best to keep them low in cases like this one, to
45     // increase the likelihood of the full refund coming into effect.
46     uint256 private constant _NOT_ENTERED = 1;
47     uint256 private constant _ENTERED = 2;
48 
49     uint256 private _status;
50 
51     constructor() {
52         _status = _NOT_ENTERED;
53     }
54 
55     /**
56      * @dev Prevents a contract from calling itself, directly or indirectly.
57      * Calling a `nonReentrant` function from another `nonReentrant`
58      * function is not supported. It is possible to prevent this from happening
59      * by making the `nonReentrant` function external, and making it call a
60      * `private` function that does the actual work.
61      */
62     modifier nonReentrant() {
63         // On the first call to nonReentrant, _notEntered will be true
64         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
65 
66         // Any calls to nonReentrant after this point will fail
67         _status = _ENTERED;
68 
69         _;
70 
71         // By storing the original value once again, a refund is triggered (see
72         // https://eips.ethereum.org/EIPS/eip-2200)
73         _status = _NOT_ENTERED;
74     }
75 }
76 
77 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
78 
79 
80 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
81 
82 pragma solidity ^0.8.0;
83 
84 /**
85  * @dev Interface of the ERC20 standard as defined in the EIP.
86  */
87 interface IERC20 {
88     /**
89      * @dev Returns the amount of tokens in existence.
90      */
91     function totalSupply() external view returns (uint256);
92 
93     /**
94      * @dev Returns the amount of tokens owned by `account`.
95      */
96     function balanceOf(address account) external view returns (uint256);
97 
98     /**
99      * @dev Moves `amount` tokens from the caller's account to `to`.
100      *
101      * Returns a boolean value indicating whether the operation succeeded.
102      *
103      * Emits a {Transfer} event.
104      */
105     function transfer(address to, uint256 amount) external returns (bool);
106 
107     /**
108      * @dev Returns the remaining number of tokens that `spender` will be
109      * allowed to spend on behalf of `owner` through {transferFrom}. This is
110      * zero by default.
111      *
112      * This value changes when {approve} or {transferFrom} are called.
113      */
114     function allowance(address owner, address spender) external view returns (uint256);
115 
116     /**
117      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
118      *
119      * Returns a boolean value indicating whether the operation succeeded.
120      *
121      * IMPORTANT: Beware that changing an allowance with this method brings the risk
122      * that someone may use both the old and the new allowance by unfortunate
123      * transaction ordering. One possible solution to mitigate this race
124      * condition is to first reduce the spender's allowance to 0 and set the
125      * desired value afterwards:
126      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
127      *
128      * Emits an {Approval} event.
129      */
130     function approve(address spender, uint256 amount) external returns (bool);
131 
132     /**
133      * @dev Moves `amount` tokens from `from` to `to` using the
134      * allowance mechanism. `amount` is then deducted from the caller's
135      * allowance.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * Emits a {Transfer} event.
140      */
141     function transferFrom(
142         address from,
143         address to,
144         uint256 amount
145     ) external returns (bool);
146 
147     /**
148      * @dev Emitted when `value` tokens are moved from one account (`from`) to
149      * another (`to`).
150      *
151      * Note that `value` may be zero.
152      */
153     event Transfer(address indexed from, address indexed to, uint256 value);
154 
155     /**
156      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
157      * a call to {approve}. `value` is the new allowance.
158      */
159     event Approval(address indexed owner, address indexed spender, uint256 value);
160 }
161 
162 // File: @openzeppelin/contracts/utils/Counters.sol
163 
164 
165 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
166 
167 pragma solidity ^0.8.0;
168 
169 /**
170  * @title Counters
171  * @author Matt Condon (@shrugs)
172  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
173  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
174  *
175  * Include with `using Counters for Counters.Counter;`
176  */
177 library Counters {
178     struct Counter {
179         // This variable should never be directly accessed by users of the library: interactions must be restricted to
180         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
181         // this feature: see https://github.com/ethereum/solidity/issues/4637
182         uint256 _value; // default: 0
183     }
184 
185     function current(Counter storage counter) internal view returns (uint256) {
186         return counter._value;
187     }
188 
189     function increment(Counter storage counter) internal {
190         unchecked {
191             counter._value += 1;
192         }
193     }
194 
195     function decrement(Counter storage counter) internal {
196         uint256 value = counter._value;
197         require(value > 0, "Counter: decrement overflow");
198         unchecked {
199             counter._value = value - 1;
200         }
201     }
202 
203     function reset(Counter storage counter) internal {
204         counter._value = 0;
205     }
206 }
207 
208 // File: @openzeppelin/contracts/utils/Strings.sol
209 
210 
211 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
212 
213 pragma solidity ^0.8.0;
214 
215 /**
216  * @dev String operations.
217  */
218 library Strings {
219     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
220 
221     /**
222      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
223      */
224     function toString(uint256 value) internal pure returns (string memory) {
225         // Inspired by OraclizeAPI's implementation - MIT licence
226         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
227 
228         if (value == 0) {
229             return "0";
230         }
231         uint256 temp = value;
232         uint256 digits;
233         while (temp != 0) {
234             digits++;
235             temp /= 10;
236         }
237         bytes memory buffer = new bytes(digits);
238         while (value != 0) {
239             digits -= 1;
240             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
241             value /= 10;
242         }
243         return string(buffer);
244     }
245 
246     /**
247      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
248      */
249     function toHexString(uint256 value) internal pure returns (string memory) {
250         if (value == 0) {
251             return "0x00";
252         }
253         uint256 temp = value;
254         uint256 length = 0;
255         while (temp != 0) {
256             length++;
257             temp >>= 8;
258         }
259         return toHexString(value, length);
260     }
261 
262     /**
263      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
264      */
265     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
266         bytes memory buffer = new bytes(2 * length + 2);
267         buffer[0] = "0";
268         buffer[1] = "x";
269         for (uint256 i = 2 * length + 1; i > 1; --i) {
270             buffer[i] = _HEX_SYMBOLS[value & 0xf];
271             value >>= 4;
272         }
273         require(value == 0, "Strings: hex length insufficient");
274         return string(buffer);
275     }
276 }
277 
278 // File: @openzeppelin/contracts/utils/Context.sol
279 
280 
281 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
282 
283 pragma solidity ^0.8.0;
284 
285 /**
286  * @dev Provides information about the current execution context, including the
287  * sender of the transaction and its data. While these are generally available
288  * via msg.sender and msg.data, they should not be accessed in such a direct
289  * manner, since when dealing with meta-transactions the account sending and
290  * paying for execution may not be the actual sender (as far as an application
291  * is concerned).
292  *
293  * This contract is only required for intermediate, library-like contracts.
294  */
295 abstract contract Context {
296     function _msgSender() internal view virtual returns (address) {
297         return msg.sender;
298     }
299 
300     function _msgData() internal view virtual returns (bytes calldata) {
301         return msg.data;
302     }
303 }
304 
305 // File: @openzeppelin/contracts/security/Pausable.sol
306 
307 
308 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
309 
310 pragma solidity ^0.8.0;
311 
312 
313 /**
314  * @dev Contract module which allows children to implement an emergency stop
315  * mechanism that can be triggered by an authorized account.
316  *
317  * This module is used through inheritance. It will make available the
318  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
319  * the functions of your contract. Note that they will not be pausable by
320  * simply including this module, only once the modifiers are put in place.
321  */
322 abstract contract Pausable is Context {
323     /**
324      * @dev Emitted when the pause is triggered by `account`.
325      */
326     event Paused(address account);
327 
328     /**
329      * @dev Emitted when the pause is lifted by `account`.
330      */
331     event Unpaused(address account);
332 
333     bool private _paused;
334 
335     /**
336      * @dev Initializes the contract in unpaused state.
337      */
338     constructor() {
339         _paused = false;
340     }
341 
342     /**
343      * @dev Returns true if the contract is paused, and false otherwise.
344      */
345     function paused() public view virtual returns (bool) {
346         return _paused;
347     }
348 
349     /**
350      * @dev Modifier to make a function callable only when the contract is not paused.
351      *
352      * Requirements:
353      *
354      * - The contract must not be paused.
355      */
356     modifier whenNotPaused() {
357         require(!paused(), "Pausable: paused");
358         _;
359     }
360 
361     /**
362      * @dev Modifier to make a function callable only when the contract is paused.
363      *
364      * Requirements:
365      *
366      * - The contract must be paused.
367      */
368     modifier whenPaused() {
369         require(paused(), "Pausable: not paused");
370         _;
371     }
372 
373     /**
374      * @dev Triggers stopped state.
375      *
376      * Requirements:
377      *
378      * - The contract must not be paused.
379      */
380     function _pause() internal virtual whenNotPaused {
381         _paused = true;
382         emit Paused(_msgSender());
383     }
384 
385     /**
386      * @dev Returns to normal state.
387      *
388      * Requirements:
389      *
390      * - The contract must be paused.
391      */
392     function _unpause() internal virtual whenPaused {
393         _paused = false;
394         emit Unpaused(_msgSender());
395     }
396 }
397 
398 // File: @openzeppelin/contracts/access/Ownable.sol
399 
400 
401 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
402 
403 pragma solidity ^0.8.0;
404 
405 
406 /**
407  * @dev Contract module which provides a basic access control mechanism, where
408  * there is an account (an owner) that can be granted exclusive access to
409  * specific functions.
410  *
411  * By default, the owner account will be the one that deploys the contract. This
412  * can later be changed with {transferOwnership}.
413  *
414  * This module is used through inheritance. It will make available the modifier
415  * `onlyOwner`, which can be applied to your functions to restrict their use to
416  * the owner.
417  */
418 abstract contract Ownable is Context {
419     address private _owner;
420 
421     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
422 
423     /**
424      * @dev Initializes the contract setting the deployer as the initial owner.
425      */
426     constructor() {
427         _transferOwnership(_msgSender());
428     }
429 
430     /**
431      * @dev Returns the address of the current owner.
432      */
433     function owner() public view virtual returns (address) {
434         return _owner;
435     }
436 
437     /**
438      * @dev Throws if called by any account other than the owner.
439      */
440     modifier onlyOwner() {
441         require(owner() == _msgSender(), "Ownable: caller is not the owner");
442         _;
443     }
444 
445     /**
446      * @dev Leaves the contract without owner. It will not be possible to call
447      * `onlyOwner` functions anymore. Can only be called by the current owner.
448      *
449      * NOTE: Renouncing ownership will leave the contract without an owner,
450      * thereby removing any functionality that is only available to the owner.
451      */
452     function renounceOwnership() public virtual onlyOwner {
453         _transferOwnership(address(0));
454     }
455 
456     /**
457      * @dev Transfers ownership of the contract to a new account (`newOwner`).
458      * Can only be called by the current owner.
459      */
460     function transferOwnership(address newOwner) public virtual onlyOwner {
461         require(newOwner != address(0), "Ownable: new owner is the zero address");
462         _transferOwnership(newOwner);
463     }
464 
465     /**
466      * @dev Transfers ownership of the contract to a new account (`newOwner`).
467      * Internal function without access restriction.
468      */
469     function _transferOwnership(address newOwner) internal virtual {
470         address oldOwner = _owner;
471         _owner = newOwner;
472         emit OwnershipTransferred(oldOwner, newOwner);
473     }
474 }
475 
476 // File: @openzeppelin/contracts/utils/Address.sol
477 
478 
479 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
480 
481 pragma solidity ^0.8.1;
482 
483 /**
484  * @dev Collection of functions related to the address type
485  */
486 library Address {
487     /**
488      * @dev Returns true if `account` is a contract.
489      *
490      * [IMPORTANT]
491      * ====
492      * It is unsafe to assume that an address for which this function returns
493      * false is an externally-owned account (EOA) and not a contract.
494      *
495      * Among others, `isContract` will return false for the following
496      * types of addresses:
497      *
498      *  - an externally-owned account
499      *  - a contract in construction
500      *  - an address where a contract will be created
501      *  - an address where a contract lived, but was destroyed
502      * ====
503      *
504      * [IMPORTANT]
505      * ====
506      * You shouldn't rely on `isContract` to protect against flash loan attacks!
507      *
508      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
509      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
510      * constructor.
511      * ====
512      */
513     function isContract(address account) internal view returns (bool) {
514         // This method relies on extcodesize/address.code.length, which returns 0
515         // for contracts in construction, since the code is only stored at the end
516         // of the constructor execution.
517 
518         return account.code.length > 0;
519     }
520 
521     /**
522      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
523      * `recipient`, forwarding all available gas and reverting on errors.
524      *
525      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
526      * of certain opcodes, possibly making contracts go over the 2300 gas limit
527      * imposed by `transfer`, making them unable to receive funds via
528      * `transfer`. {sendValue} removes this limitation.
529      *
530      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
531      *
532      * IMPORTANT: because control is transferred to `recipient`, care must be
533      * taken to not create reentrancy vulnerabilities. Consider using
534      * {ReentrancyGuard} or the
535      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
536      */
537     function sendValue(address payable recipient, uint256 amount) internal {
538         require(address(this).balance >= amount, "Address: insufficient balance");
539 
540         (bool success, ) = recipient.call{value: amount}("");
541         require(success, "Address: unable to send value, recipient may have reverted");
542     }
543 
544     /**
545      * @dev Performs a Solidity function call using a low level `call`. A
546      * plain `call` is an unsafe replacement for a function call: use this
547      * function instead.
548      *
549      * If `target` reverts with a revert reason, it is bubbled up by this
550      * function (like regular Solidity function calls).
551      *
552      * Returns the raw returned data. To convert to the expected return value,
553      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
554      *
555      * Requirements:
556      *
557      * - `target` must be a contract.
558      * - calling `target` with `data` must not revert.
559      *
560      * _Available since v3.1._
561      */
562     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
563         return functionCall(target, data, "Address: low-level call failed");
564     }
565 
566     /**
567      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
568      * `errorMessage` as a fallback revert reason when `target` reverts.
569      *
570      * _Available since v3.1._
571      */
572     function functionCall(
573         address target,
574         bytes memory data,
575         string memory errorMessage
576     ) internal returns (bytes memory) {
577         return functionCallWithValue(target, data, 0, errorMessage);
578     }
579 
580     /**
581      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
582      * but also transferring `value` wei to `target`.
583      *
584      * Requirements:
585      *
586      * - the calling contract must have an ETH balance of at least `value`.
587      * - the called Solidity function must be `payable`.
588      *
589      * _Available since v3.1._
590      */
591     function functionCallWithValue(
592         address target,
593         bytes memory data,
594         uint256 value
595     ) internal returns (bytes memory) {
596         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
597     }
598 
599     /**
600      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
601      * with `errorMessage` as a fallback revert reason when `target` reverts.
602      *
603      * _Available since v3.1._
604      */
605     function functionCallWithValue(
606         address target,
607         bytes memory data,
608         uint256 value,
609         string memory errorMessage
610     ) internal returns (bytes memory) {
611         require(address(this).balance >= value, "Address: insufficient balance for call");
612         require(isContract(target), "Address: call to non-contract");
613 
614         (bool success, bytes memory returndata) = target.call{value: value}(data);
615         return verifyCallResult(success, returndata, errorMessage);
616     }
617 
618     /**
619      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
620      * but performing a static call.
621      *
622      * _Available since v3.3._
623      */
624     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
625         return functionStaticCall(target, data, "Address: low-level static call failed");
626     }
627 
628     /**
629      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
630      * but performing a static call.
631      *
632      * _Available since v3.3._
633      */
634     function functionStaticCall(
635         address target,
636         bytes memory data,
637         string memory errorMessage
638     ) internal view returns (bytes memory) {
639         require(isContract(target), "Address: static call to non-contract");
640 
641         (bool success, bytes memory returndata) = target.staticcall(data);
642         return verifyCallResult(success, returndata, errorMessage);
643     }
644 
645     /**
646      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
647      * but performing a delegate call.
648      *
649      * _Available since v3.4._
650      */
651     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
652         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
653     }
654 
655     /**
656      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
657      * but performing a delegate call.
658      *
659      * _Available since v3.4._
660      */
661     function functionDelegateCall(
662         address target,
663         bytes memory data,
664         string memory errorMessage
665     ) internal returns (bytes memory) {
666         require(isContract(target), "Address: delegate call to non-contract");
667 
668         (bool success, bytes memory returndata) = target.delegatecall(data);
669         return verifyCallResult(success, returndata, errorMessage);
670     }
671 
672     /**
673      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
674      * revert reason using the provided one.
675      *
676      * _Available since v4.3._
677      */
678     function verifyCallResult(
679         bool success,
680         bytes memory returndata,
681         string memory errorMessage
682     ) internal pure returns (bytes memory) {
683         if (success) {
684             return returndata;
685         } else {
686             // Look for revert reason and bubble it up if present
687             if (returndata.length > 0) {
688                 // The easiest way to bubble the revert reason is using memory via assembly
689 
690                 assembly {
691                     let returndata_size := mload(returndata)
692                     revert(add(32, returndata), returndata_size)
693                 }
694             } else {
695                 revert(errorMessage);
696             }
697         }
698     }
699 }
700 
701 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
702 
703 
704 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
705 
706 pragma solidity ^0.8.0;
707 
708 
709 
710 /**
711  * @title SafeERC20
712  * @dev Wrappers around ERC20 operations that throw on failure (when the token
713  * contract returns false). Tokens that return no value (and instead revert or
714  * throw on failure) are also supported, non-reverting calls are assumed to be
715  * successful.
716  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
717  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
718  */
719 library SafeERC20 {
720     using Address for address;
721 
722     function safeTransfer(
723         IERC20 token,
724         address to,
725         uint256 value
726     ) internal {
727         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
728     }
729 
730     function safeTransferFrom(
731         IERC20 token,
732         address from,
733         address to,
734         uint256 value
735     ) internal {
736         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
737     }
738 
739     /**
740      * @dev Deprecated. This function has issues similar to the ones found in
741      * {IERC20-approve}, and its usage is discouraged.
742      *
743      * Whenever possible, use {safeIncreaseAllowance} and
744      * {safeDecreaseAllowance} instead.
745      */
746     function safeApprove(
747         IERC20 token,
748         address spender,
749         uint256 value
750     ) internal {
751         // safeApprove should only be called when setting an initial allowance,
752         // or when resetting it to zero. To increase and decrease it, use
753         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
754         require(
755             (value == 0) || (token.allowance(address(this), spender) == 0),
756             "SafeERC20: approve from non-zero to non-zero allowance"
757         );
758         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
759     }
760 
761     function safeIncreaseAllowance(
762         IERC20 token,
763         address spender,
764         uint256 value
765     ) internal {
766         uint256 newAllowance = token.allowance(address(this), spender) + value;
767         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
768     }
769 
770     function safeDecreaseAllowance(
771         IERC20 token,
772         address spender,
773         uint256 value
774     ) internal {
775         unchecked {
776             uint256 oldAllowance = token.allowance(address(this), spender);
777             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
778             uint256 newAllowance = oldAllowance - value;
779             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
780         }
781     }
782 
783     /**
784      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
785      * on the return value: the return value is optional (but if data is returned, it must not be false).
786      * @param token The token targeted by the call.
787      * @param data The call data (encoded using abi.encode or one of its variants).
788      */
789     function _callOptionalReturn(IERC20 token, bytes memory data) private {
790         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
791         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
792         // the target address contains contract code and also asserts for success in the low-level call.
793 
794         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
795         if (returndata.length > 0) {
796             // Return data is optional
797             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
798         }
799     }
800 }
801 
802 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
803 
804 
805 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
806 
807 pragma solidity ^0.8.0;
808 
809 
810 
811 
812 /**
813  * @title PaymentSplitter
814  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
815  * that the Ether will be split in this way, since it is handled transparently by the contract.
816  *
817  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
818  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
819  * an amount proportional to the percentage of total shares they were assigned.
820  *
821  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
822  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
823  * function.
824  *
825  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
826  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
827  * to run tests before sending real value to this contract.
828  */
829 contract PaymentSplitter is Context {
830     event PayeeAdded(address account, uint256 shares);
831     event PaymentReleased(address to, uint256 amount);
832     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
833     event PaymentReceived(address from, uint256 amount);
834 
835     uint256 private _totalShares;
836     uint256 private _totalReleased;
837 
838     mapping(address => uint256) private _shares;
839     mapping(address => uint256) private _released;
840     address[] private _payees;
841 
842     mapping(IERC20 => uint256) private _erc20TotalReleased;
843     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
844 
845     /**
846      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
847      * the matching position in the `shares` array.
848      *
849      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
850      * duplicates in `payees`.
851      */
852     constructor(address[] memory payees, uint256[] memory shares_) payable {
853         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
854         require(payees.length > 0, "PaymentSplitter: no payees");
855 
856         for (uint256 i = 0; i < payees.length; i++) {
857             _addPayee(payees[i], shares_[i]);
858         }
859     }
860 
861     /**
862      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
863      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
864      * reliability of the events, and not the actual splitting of Ether.
865      *
866      * To learn more about this see the Solidity documentation for
867      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
868      * functions].
869      */
870     receive() external payable virtual {
871         emit PaymentReceived(_msgSender(), msg.value);
872     }
873 
874     /**
875      * @dev Getter for the total shares held by payees.
876      */
877     function totalShares() public view returns (uint256) {
878         return _totalShares;
879     }
880 
881     /**
882      * @dev Getter for the total amount of Ether already released.
883      */
884     function totalReleased() public view returns (uint256) {
885         return _totalReleased;
886     }
887 
888     /**
889      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
890      * contract.
891      */
892     function totalReleased(IERC20 token) public view returns (uint256) {
893         return _erc20TotalReleased[token];
894     }
895 
896     /**
897      * @dev Getter for the amount of shares held by an account.
898      */
899     function shares(address account) public view returns (uint256) {
900         return _shares[account];
901     }
902 
903     /**
904      * @dev Getter for the amount of Ether already released to a payee.
905      */
906     function released(address account) public view returns (uint256) {
907         return _released[account];
908     }
909 
910     /**
911      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
912      * IERC20 contract.
913      */
914     function released(IERC20 token, address account) public view returns (uint256) {
915         return _erc20Released[token][account];
916     }
917 
918     /**
919      * @dev Getter for the address of the payee number `index`.
920      */
921     function payee(uint256 index) public view returns (address) {
922         return _payees[index];
923     }
924 
925     /**
926      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
927      * total shares and their previous withdrawals.
928      */
929     function release(address payable account) public virtual {
930         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
931 
932         uint256 totalReceived = address(this).balance + totalReleased();
933         uint256 payment = _pendingPayment(account, totalReceived, released(account));
934 
935         require(payment != 0, "PaymentSplitter: account is not due payment");
936 
937         _released[account] += payment;
938         _totalReleased += payment;
939 
940         Address.sendValue(account, payment);
941         emit PaymentReleased(account, payment);
942     }
943 
944     /**
945      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
946      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
947      * contract.
948      */
949     function release(IERC20 token, address account) public virtual {
950         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
951 
952         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
953         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
954 
955         require(payment != 0, "PaymentSplitter: account is not due payment");
956 
957         _erc20Released[token][account] += payment;
958         _erc20TotalReleased[token] += payment;
959 
960         SafeERC20.safeTransfer(token, account, payment);
961         emit ERC20PaymentReleased(token, account, payment);
962     }
963 
964     /**
965      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
966      * already released amounts.
967      */
968     function _pendingPayment(
969         address account,
970         uint256 totalReceived,
971         uint256 alreadyReleased
972     ) private view returns (uint256) {
973         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
974     }
975 
976     /**
977      * @dev Add a new payee to the contract.
978      * @param account The address of the payee to add.
979      * @param shares_ The number of shares owned by the payee.
980      */
981     function _addPayee(address account, uint256 shares_) private {
982         require(account != address(0), "PaymentSplitter: account is the zero address");
983         require(shares_ > 0, "PaymentSplitter: shares are 0");
984         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
985 
986         _payees.push(account);
987         _shares[account] = shares_;
988         _totalShares = _totalShares + shares_;
989         emit PayeeAdded(account, shares_);
990     }
991 }
992 
993 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
994 
995 
996 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
997 
998 pragma solidity ^0.8.0;
999 
1000 /**
1001  * @title ERC721 token receiver interface
1002  * @dev Interface for any contract that wants to support safeTransfers
1003  * from ERC721 asset contracts.
1004  */
1005 interface IERC721Receiver {
1006     /**
1007      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1008      * by `operator` from `from`, this function is called.
1009      *
1010      * It must return its Solidity selector to confirm the token transfer.
1011      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1012      *
1013      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1014      */
1015     function onERC721Received(
1016         address operator,
1017         address from,
1018         uint256 tokenId,
1019         bytes calldata data
1020     ) external returns (bytes4);
1021 }
1022 
1023 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1024 
1025 
1026 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1027 
1028 pragma solidity ^0.8.0;
1029 
1030 /**
1031  * @dev Interface of the ERC165 standard, as defined in the
1032  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1033  *
1034  * Implementers can declare support of contract interfaces, which can then be
1035  * queried by others ({ERC165Checker}).
1036  *
1037  * For an implementation, see {ERC165}.
1038  */
1039 interface IERC165 {
1040     /**
1041      * @dev Returns true if this contract implements the interface defined by
1042      * `interfaceId`. See the corresponding
1043      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1044      * to learn more about how these ids are created.
1045      *
1046      * This function call must use less than 30 000 gas.
1047      */
1048     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1049 }
1050 
1051 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1052 
1053 
1054 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1055 
1056 pragma solidity ^0.8.0;
1057 
1058 
1059 /**
1060  * @dev Implementation of the {IERC165} interface.
1061  *
1062  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1063  * for the additional interface id that will be supported. For example:
1064  *
1065  * ```solidity
1066  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1067  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1068  * }
1069  * ```
1070  *
1071  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1072  */
1073 abstract contract ERC165 is IERC165 {
1074     /**
1075      * @dev See {IERC165-supportsInterface}.
1076      */
1077     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1078         return interfaceId == type(IERC165).interfaceId;
1079     }
1080 }
1081 
1082 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1083 
1084 
1085 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
1086 
1087 pragma solidity ^0.8.0;
1088 
1089 
1090 /**
1091  * @dev Required interface of an ERC721 compliant contract.
1092  */
1093 interface IERC721 is IERC165 {
1094     /**
1095      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1096      */
1097     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1098 
1099     /**
1100      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1101      */
1102     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1103 
1104     /**
1105      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1106      */
1107     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1108 
1109     /**
1110      * @dev Returns the number of tokens in ``owner``'s account.
1111      */
1112     function balanceOf(address owner) external view returns (uint256 balance);
1113 
1114     /**
1115      * @dev Returns the owner of the `tokenId` token.
1116      *
1117      * Requirements:
1118      *
1119      * - `tokenId` must exist.
1120      */
1121     function ownerOf(uint256 tokenId) external view returns (address owner);
1122 
1123     /**
1124      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1125      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1126      *
1127      * Requirements:
1128      *
1129      * - `from` cannot be the zero address.
1130      * - `to` cannot be the zero address.
1131      * - `tokenId` token must exist and be owned by `from`.
1132      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1133      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1134      *
1135      * Emits a {Transfer} event.
1136      */
1137     function safeTransferFrom(
1138         address from,
1139         address to,
1140         uint256 tokenId
1141     ) external;
1142 
1143     /**
1144      * @dev Transfers `tokenId` token from `from` to `to`.
1145      *
1146      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1147      *
1148      * Requirements:
1149      *
1150      * - `from` cannot be the zero address.
1151      * - `to` cannot be the zero address.
1152      * - `tokenId` token must be owned by `from`.
1153      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1154      *
1155      * Emits a {Transfer} event.
1156      */
1157     function transferFrom(
1158         address from,
1159         address to,
1160         uint256 tokenId
1161     ) external;
1162 
1163     /**
1164      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1165      * The approval is cleared when the token is transferred.
1166      *
1167      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1168      *
1169      * Requirements:
1170      *
1171      * - The caller must own the token or be an approved operator.
1172      * - `tokenId` must exist.
1173      *
1174      * Emits an {Approval} event.
1175      */
1176     function approve(address to, uint256 tokenId) external;
1177 
1178     /**
1179      * @dev Returns the account approved for `tokenId` token.
1180      *
1181      * Requirements:
1182      *
1183      * - `tokenId` must exist.
1184      */
1185     function getApproved(uint256 tokenId) external view returns (address operator);
1186 
1187     /**
1188      * @dev Approve or remove `operator` as an operator for the caller.
1189      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1190      *
1191      * Requirements:
1192      *
1193      * - The `operator` cannot be the caller.
1194      *
1195      * Emits an {ApprovalForAll} event.
1196      */
1197     function setApprovalForAll(address operator, bool _approved) external;
1198 
1199     /**
1200      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1201      *
1202      * See {setApprovalForAll}
1203      */
1204     function isApprovedForAll(address owner, address operator) external view returns (bool);
1205 
1206     /**
1207      * @dev Safely transfers `tokenId` token from `from` to `to`.
1208      *
1209      * Requirements:
1210      *
1211      * - `from` cannot be the zero address.
1212      * - `to` cannot be the zero address.
1213      * - `tokenId` token must exist and be owned by `from`.
1214      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1215      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1216      *
1217      * Emits a {Transfer} event.
1218      */
1219     function safeTransferFrom(
1220         address from,
1221         address to,
1222         uint256 tokenId,
1223         bytes calldata data
1224     ) external;
1225 }
1226 
1227 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1228 
1229 
1230 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1231 
1232 pragma solidity ^0.8.0;
1233 
1234 
1235 /**
1236  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1237  * @dev See https://eips.ethereum.org/EIPS/eip-721
1238  */
1239 interface IERC721Metadata is IERC721 {
1240     /**
1241      * @dev Returns the token collection name.
1242      */
1243     function name() external view returns (string memory);
1244 
1245     /**
1246      * @dev Returns the token collection symbol.
1247      */
1248     function symbol() external view returns (string memory);
1249 
1250     /**
1251      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1252      */
1253     function tokenURI(uint256 tokenId) external view returns (string memory);
1254 }
1255 
1256 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1257 
1258 
1259 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
1260 
1261 pragma solidity ^0.8.0;
1262 
1263 
1264 
1265 
1266 
1267 
1268 
1269 
1270 /**
1271  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1272  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1273  * {ERC721Enumerable}.
1274  */
1275 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1276     using Address for address;
1277     using Strings for uint256;
1278 
1279     // Token name
1280     string private _name;
1281 
1282     // Token symbol
1283     string private _symbol;
1284 
1285     // Mapping from token ID to owner address
1286     mapping(uint256 => address) private _owners;
1287 
1288     // Mapping owner address to token count
1289     mapping(address => uint256) private _balances;
1290 
1291     // Mapping from token ID to approved address
1292     mapping(uint256 => address) private _tokenApprovals;
1293 
1294     // Mapping from owner to operator approvals
1295     mapping(address => mapping(address => bool)) private _operatorApprovals;
1296 
1297     /**
1298      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1299      */
1300     constructor(string memory name_, string memory symbol_) {
1301         _name = name_;
1302         _symbol = symbol_;
1303     }
1304 
1305     /**
1306      * @dev See {IERC165-supportsInterface}.
1307      */
1308     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1309         return
1310             interfaceId == type(IERC721).interfaceId ||
1311             interfaceId == type(IERC721Metadata).interfaceId ||
1312             super.supportsInterface(interfaceId);
1313     }
1314 
1315     /**
1316      * @dev See {IERC721-balanceOf}.
1317      */
1318     function balanceOf(address owner) public view virtual override returns (uint256) {
1319         require(owner != address(0), "ERC721: balance query for the zero address");
1320         return _balances[owner];
1321     }
1322 
1323     /**
1324      * @dev See {IERC721-ownerOf}.
1325      */
1326     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1327         address owner = _owners[tokenId];
1328         require(owner != address(0), "ERC721: owner query for nonexistent token");
1329         return owner;
1330     }
1331 
1332     /**
1333      * @dev See {IERC721Metadata-name}.
1334      */
1335     function name() public view virtual override returns (string memory) {
1336         return _name;
1337     }
1338 
1339     /**
1340      * @dev See {IERC721Metadata-symbol}.
1341      */
1342     function symbol() public view virtual override returns (string memory) {
1343         return _symbol;
1344     }
1345 
1346     /**
1347      * @dev See {IERC721Metadata-tokenURI}.
1348      */
1349     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1350         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1351 
1352         string memory baseURI = _baseURI();
1353         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1354     }
1355 
1356     /**
1357      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1358      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1359      * by default, can be overriden in child contracts.
1360      */
1361     function _baseURI() internal view virtual returns (string memory) {
1362         return "";
1363     }
1364 
1365     /**
1366      * @dev See {IERC721-approve}.
1367      */
1368     function approve(address to, uint256 tokenId) public virtual override {
1369         address owner = ERC721.ownerOf(tokenId);
1370         require(to != owner, "ERC721: approval to current owner");
1371 
1372         require(
1373             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1374             "ERC721: approve caller is not owner nor approved for all"
1375         );
1376 
1377         _approve(to, tokenId);
1378     }
1379 
1380     /**
1381      * @dev See {IERC721-getApproved}.
1382      */
1383     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1384         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1385 
1386         return _tokenApprovals[tokenId];
1387     }
1388 
1389     /**
1390      * @dev See {IERC721-setApprovalForAll}.
1391      */
1392     function setApprovalForAll(address operator, bool approved) public virtual override {
1393         _setApprovalForAll(_msgSender(), operator, approved);
1394     }
1395 
1396     /**
1397      * @dev See {IERC721-isApprovedForAll}.
1398      */
1399     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1400         return _operatorApprovals[owner][operator];
1401     }
1402 
1403     /**
1404      * @dev See {IERC721-transferFrom}.
1405      */
1406     function transferFrom(
1407         address from,
1408         address to,
1409         uint256 tokenId
1410     ) public virtual override {
1411         //solhint-disable-next-line max-line-length
1412         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1413 
1414         _transfer(from, to, tokenId);
1415     }
1416 
1417     /**
1418      * @dev See {IERC721-safeTransferFrom}.
1419      */
1420     function safeTransferFrom(
1421         address from,
1422         address to,
1423         uint256 tokenId
1424     ) public virtual override {
1425         safeTransferFrom(from, to, tokenId, "");
1426     }
1427 
1428     /**
1429      * @dev See {IERC721-safeTransferFrom}.
1430      */
1431     function safeTransferFrom(
1432         address from,
1433         address to,
1434         uint256 tokenId,
1435         bytes memory _data
1436     ) public virtual override {
1437         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1438         _safeTransfer(from, to, tokenId, _data);
1439     }
1440 
1441     /**
1442      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1443      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1444      *
1445      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1446      *
1447      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1448      * implement alternative mechanisms to perform token transfer, such as signature-based.
1449      *
1450      * Requirements:
1451      *
1452      * - `from` cannot be the zero address.
1453      * - `to` cannot be the zero address.
1454      * - `tokenId` token must exist and be owned by `from`.
1455      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1456      *
1457      * Emits a {Transfer} event.
1458      */
1459     function _safeTransfer(
1460         address from,
1461         address to,
1462         uint256 tokenId,
1463         bytes memory _data
1464     ) internal virtual {
1465         _transfer(from, to, tokenId);
1466         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1467     }
1468 
1469     /**
1470      * @dev Returns whether `tokenId` exists.
1471      *
1472      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1473      *
1474      * Tokens start existing when they are minted (`_mint`),
1475      * and stop existing when they are burned (`_burn`).
1476      */
1477     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1478         return _owners[tokenId] != address(0);
1479     }
1480 
1481     /**
1482      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1483      *
1484      * Requirements:
1485      *
1486      * - `tokenId` must exist.
1487      */
1488     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1489         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1490         address owner = ERC721.ownerOf(tokenId);
1491         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1492     }
1493 
1494     /**
1495      * @dev Safely mints `tokenId` and transfers it to `to`.
1496      *
1497      * Requirements:
1498      *
1499      * - `tokenId` must not exist.
1500      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1501      *
1502      * Emits a {Transfer} event.
1503      */
1504     function _safeMint(address to, uint256 tokenId) internal virtual {
1505         _safeMint(to, tokenId, "");
1506     }
1507 
1508     /**
1509      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1510      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1511      */
1512     function _safeMint(
1513         address to,
1514         uint256 tokenId,
1515         bytes memory _data
1516     ) internal virtual {
1517         _mint(to, tokenId);
1518         require(
1519             _checkOnERC721Received(address(0), to, tokenId, _data),
1520             "ERC721: transfer to non ERC721Receiver implementer"
1521         );
1522     }
1523 
1524     /**
1525      * @dev Mints `tokenId` and transfers it to `to`.
1526      *
1527      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1528      *
1529      * Requirements:
1530      *
1531      * - `tokenId` must not exist.
1532      * - `to` cannot be the zero address.
1533      *
1534      * Emits a {Transfer} event.
1535      */
1536     function _mint(address to, uint256 tokenId) internal virtual {
1537         require(to != address(0), "ERC721: mint to the zero address");
1538         require(!_exists(tokenId), "ERC721: token already minted");
1539 
1540         _beforeTokenTransfer(address(0), to, tokenId);
1541 
1542         _balances[to] += 1;
1543         _owners[tokenId] = to;
1544 
1545         emit Transfer(address(0), to, tokenId);
1546 
1547         _afterTokenTransfer(address(0), to, tokenId);
1548     }
1549 
1550     /**
1551      * @dev Destroys `tokenId`.
1552      * The approval is cleared when the token is burned.
1553      *
1554      * Requirements:
1555      *
1556      * - `tokenId` must exist.
1557      *
1558      * Emits a {Transfer} event.
1559      */
1560     function _burn(uint256 tokenId) internal virtual {
1561         address owner = ERC721.ownerOf(tokenId);
1562 
1563         _beforeTokenTransfer(owner, address(0), tokenId);
1564 
1565         // Clear approvals
1566         _approve(address(0), tokenId);
1567 
1568         _balances[owner] -= 1;
1569         delete _owners[tokenId];
1570 
1571         emit Transfer(owner, address(0), tokenId);
1572 
1573         _afterTokenTransfer(owner, address(0), tokenId);
1574     }
1575 
1576     /**
1577      * @dev Transfers `tokenId` from `from` to `to`.
1578      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1579      *
1580      * Requirements:
1581      *
1582      * - `to` cannot be the zero address.
1583      * - `tokenId` token must be owned by `from`.
1584      *
1585      * Emits a {Transfer} event.
1586      */
1587     function _transfer(
1588         address from,
1589         address to,
1590         uint256 tokenId
1591     ) internal virtual {
1592         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1593         require(to != address(0), "ERC721: transfer to the zero address");
1594 
1595         _beforeTokenTransfer(from, to, tokenId);
1596 
1597         // Clear approvals from the previous owner
1598         _approve(address(0), tokenId);
1599 
1600         _balances[from] -= 1;
1601         _balances[to] += 1;
1602         _owners[tokenId] = to;
1603 
1604         emit Transfer(from, to, tokenId);
1605 
1606         _afterTokenTransfer(from, to, tokenId);
1607     }
1608 
1609     /**
1610      * @dev Approve `to` to operate on `tokenId`
1611      *
1612      * Emits a {Approval} event.
1613      */
1614     function _approve(address to, uint256 tokenId) internal virtual {
1615         _tokenApprovals[tokenId] = to;
1616         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1617     }
1618 
1619     /**
1620      * @dev Approve `operator` to operate on all of `owner` tokens
1621      *
1622      * Emits a {ApprovalForAll} event.
1623      */
1624     function _setApprovalForAll(
1625         address owner,
1626         address operator,
1627         bool approved
1628     ) internal virtual {
1629         require(owner != operator, "ERC721: approve to caller");
1630         _operatorApprovals[owner][operator] = approved;
1631         emit ApprovalForAll(owner, operator, approved);
1632     }
1633 
1634     /**
1635      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1636      * The call is not executed if the target address is not a contract.
1637      *
1638      * @param from address representing the previous owner of the given token ID
1639      * @param to target address that will receive the tokens
1640      * @param tokenId uint256 ID of the token to be transferred
1641      * @param _data bytes optional data to send along with the call
1642      * @return bool whether the call correctly returned the expected magic value
1643      */
1644     function _checkOnERC721Received(
1645         address from,
1646         address to,
1647         uint256 tokenId,
1648         bytes memory _data
1649     ) private returns (bool) {
1650         if (to.isContract()) {
1651             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1652                 return retval == IERC721Receiver.onERC721Received.selector;
1653             } catch (bytes memory reason) {
1654                 if (reason.length == 0) {
1655                     revert("ERC721: transfer to non ERC721Receiver implementer");
1656                 } else {
1657                     assembly {
1658                         revert(add(32, reason), mload(reason))
1659                     }
1660                 }
1661             }
1662         } else {
1663             return true;
1664         }
1665     }
1666 
1667     /**
1668      * @dev Hook that is called before any token transfer. This includes minting
1669      * and burning.
1670      *
1671      * Calling conditions:
1672      *
1673      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1674      * transferred to `to`.
1675      * - When `from` is zero, `tokenId` will be minted for `to`.
1676      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1677      * - `from` and `to` are never both zero.
1678      *
1679      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1680      */
1681     function _beforeTokenTransfer(
1682         address from,
1683         address to,
1684         uint256 tokenId
1685     ) internal virtual {}
1686 
1687     /**
1688      * @dev Hook that is called after any transfer of tokens. This includes
1689      * minting and burning.
1690      *
1691      * Calling conditions:
1692      *
1693      * - when `from` and `to` are both non-zero.
1694      * - `from` and `to` are never both zero.
1695      *
1696      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1697      */
1698     function _afterTokenTransfer(
1699         address from,
1700         address to,
1701         uint256 tokenId
1702     ) internal virtual {}
1703 }
1704 
1705 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1706 
1707 
1708 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Burnable.sol)
1709 
1710 pragma solidity ^0.8.0;
1711 
1712 
1713 
1714 /**
1715  * @title ERC721 Burnable Token
1716  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1717  */
1718 abstract contract ERC721Burnable is Context, ERC721 {
1719     /**
1720      * @dev Burns `tokenId`. See {ERC721-_burn}.
1721      *
1722      * Requirements:
1723      *
1724      * - The caller must own `tokenId` or be an approved operator.
1725      */
1726     function burn(uint256 tokenId) public virtual {
1727         //solhint-disable-next-line max-line-length
1728         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1729         _burn(tokenId);
1730     }
1731 }
1732 
1733 // File: default_workspace/PinballerComic1.sol
1734 
1735 
1736 pragma solidity ^0.8.12;
1737 
1738 
1739 /*     .__      ___.          .__  .__                
1740 ______ |__| ____\_ |__ _____  |  | |  |   ___________ 
1741 \____ \|  |/    \| __ \\__  \ |  | |  | _/ __ \_  __ \
1742 |  |_> >  |   |  \ \_\ \/ __ \|  |_|  |_\  ___/|  | \/
1743 |   __/|__|___|  /___  (____  /____/____/\___  >__|   
1744 |__|           \/    \/     \/               \/       */
1745 contract PinballerComic1 is ERC721Burnable, Ownable, Pausable, PaymentSplitter, ReentrancyGuard
1746 {
1747     uint256 public constant MAX_OWNER_MINT = 400;
1748     uint256 public constant MAX_SUPPLY = 10000;
1749 
1750     using Strings for uint256;
1751     using Counters for Counters.Counter;
1752 
1753     Counters.Counter private supply;
1754 
1755     string private metadataUri = "ipfs://QmNwKQmz4FCr7uzfQmWB3mmMNjSx74sWT5XDcFYFPavvcY";
1756   
1757     uint256 private cost = 0.042 ether;
1758     uint256 public maxMintAmountPerTx = 11;
1759     
1760     address public pinballerItemContractAddress = address(0);
1761 
1762     bool public burnPaused = true;
1763     bool public shouldMintPinItem = true;
1764     bool public metadataFrozen = false;
1765 
1766     uint256 public mintedByOwnerCount;
1767     
1768     event tokenBurned(address indexed sender, uint indexed tokenId);
1769 
1770     constructor(address[] memory _payees, uint256[] memory _shares, address[] memory _initMintReceivers, uint256[] memory _initMintCount) ERC721("Pinballer1", "PIN") PaymentSplitter(_payees, _shares)
1771     {
1772         require(_initMintReceivers.length == _initMintCount.length, "_initMintReceivers and _initMintCount have a different length.");
1773 
1774         _pause();
1775 
1776         for (uint i = 0; i < _initMintReceivers.length; i++) 
1777         {
1778             if (_initMintCount[i] == 0)
1779                 continue;
1780 
1781             mintForAddress(_initMintCount[i], _initMintReceivers[i]);
1782         }
1783     }
1784 
1785     modifier mintCompliance(uint256 _mintAmount) 
1786     {
1787         require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Mint amount too large");
1788         require(supply.current() + _mintAmount <= MAX_SUPPLY, "Max supply exceeded");
1789         _;
1790     }
1791     
1792     function totalSupply() external view returns (uint256) 
1793     {
1794         return supply.current();
1795     }
1796 
1797     function getMintPrice() external view returns (uint256)
1798     {
1799         return cost;
1800     }
1801 
1802     function getMaxSupply() external pure returns (uint256)
1803     {
1804         return MAX_SUPPLY;
1805     }
1806 
1807     function mint(uint256 _mintAmount) external payable mintCompliance(_mintAmount) whenNotPaused nonReentrant
1808     {
1809         require(msg.value >= cost * _mintAmount, "Insufficient funds");
1810 
1811         _mintLoop(msg.sender, _mintAmount);
1812     }
1813   
1814     function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner 
1815     {
1816         require(mintedByOwnerCount + _mintAmount <= MAX_OWNER_MINT, "Owner mint limit reached");
1817 
1818         mintedByOwnerCount = mintedByOwnerCount + _mintAmount;
1819 
1820         _mintLoop(_receiver, _mintAmount);
1821     }
1822 
1823     function tokenURI(uint256) public view virtual override returns (string memory)
1824     {
1825         //ignore _tokenId as we only have 1 metadata file
1826         return metadataUri;
1827     }
1828 
1829     function freezeMetadata() external onlyOwner
1830     {
1831         metadataFrozen = true;
1832     }
1833 
1834     function setCost(uint256 _cost) external onlyOwner
1835     {
1836         cost = _cost;
1837     }
1838 
1839     function setPaused(bool _newState) external onlyOwner
1840     {
1841         if (_newState == true)
1842         {
1843             _pause();
1844         }
1845         else
1846         {
1847             _unpause();
1848         }
1849     }
1850 
1851     function setBurnPaused(bool _newState) external onlyOwner
1852     {
1853         burnPaused = _newState;
1854     }
1855 
1856     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) external onlyOwner 
1857     {
1858         maxMintAmountPerTx = _maxMintAmountPerTx;
1859     }
1860 
1861     function setUri(string memory _uri) external onlyOwner 
1862     {
1863         require(metadataFrozen == false, "Metadata is frozen");
1864 
1865         metadataUri = _uri;
1866     }
1867 
1868     function setPinballerItemContractAddress(address _address) external onlyOwner 
1869     {
1870         pinballerItemContractAddress = _address;
1871     }
1872 
1873     function setShouldMintPinItem(bool _shouldMintPinItem) external onlyOwner
1874     {
1875         shouldMintPinItem = _shouldMintPinItem;
1876     }
1877 
1878     function _mintLoop(address _receiver, uint256 _mintAmount) internal
1879     {
1880         for (uint256 i = 0; i < _mintAmount; i++) 
1881         {
1882             supply.increment();
1883             _safeMint(_receiver, supply.current());
1884         }
1885     }
1886 
1887     function burn(uint256 tokenId) public virtual override 
1888     {
1889         require(burnPaused == false, "Burning is unavailable");
1890         require(_isApprovedOrOwner(msg.sender, tokenId), "Caller is not owner/approved");
1891 
1892         if (shouldMintPinItem)
1893         {
1894             require(pinballerItemContractAddress != address(0), "Item contract is undefined");
1895 
1896             //mint ERC721 token of another contract
1897             IPinballerItem(pinballerItemContractAddress).mintForAddress(msg.sender, tokenId);
1898         }
1899 
1900         super.burn(tokenId);
1901         emit tokenBurned(msg.sender, tokenId);
1902     }
1903 
1904     function distributeAll() external
1905     {
1906         for (uint256 i = 0; i < 4; i++) 
1907         {
1908             release(payable(payee(i)));
1909         }
1910     }
1911 
1912     function walletOfOwner(address _owner) external view returns (uint256[] memory)
1913     {
1914         uint256 ownerTokenCount = balanceOf(_owner);
1915         uint256[] memory tempOwnedTokenIds = new uint256[](ownerTokenCount);
1916         uint256 currentTokenId = 1;
1917         uint256 ownedTokenIndex = 0;
1918 
1919         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= MAX_SUPPLY) 
1920         {
1921             if (_exists(currentTokenId) == true)
1922             {
1923                 address currentTokenOwner = ownerOf(currentTokenId);
1924 
1925                 if (currentTokenOwner == _owner)
1926                 {
1927                     tempOwnedTokenIds[ownedTokenIndex] = currentTokenId;
1928                     ownedTokenIndex++;
1929                 }
1930             }
1931             
1932             currentTokenId++;
1933         }
1934 
1935         uint256[] memory ownedTokenIds = new uint256[](ownedTokenIndex);
1936         for (uint256 i = 0; i < ownedTokenIndex; i++) 
1937         {
1938             ownedTokenIds[i] = tempOwnedTokenIds[i];
1939         }
1940 
1941         return ownedTokenIds;
1942     }
1943 }