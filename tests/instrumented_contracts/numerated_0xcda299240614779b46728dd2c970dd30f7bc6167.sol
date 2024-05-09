1 // File: @openzeppelin/contracts/utils/Counters.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title Counters
10  * @author Matt Condon (@shrugs)
11  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
12  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
13  *
14  * Include with `using Counters for Counters.Counter;`
15  */
16 library Counters {
17     struct Counter {
18         // This variable should never be directly accessed by users of the library: interactions must be restricted to
19         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
20         // this feature: see https://github.com/ethereum/solidity/issues/4637
21         uint256 _value; // default: 0
22     }
23 
24     function current(Counter storage counter) internal view returns (uint256) {
25         return counter._value;
26     }
27 
28     function increment(Counter storage counter) internal {
29         unchecked {
30             counter._value += 1;
31         }
32     }
33 
34     function decrement(Counter storage counter) internal {
35         uint256 value = counter._value;
36         require(value > 0, "Counter: decrement overflow");
37         unchecked {
38             counter._value = value - 1;
39         }
40     }
41 
42     function reset(Counter storage counter) internal {
43         counter._value = 0;
44     }
45 }
46 
47 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
48 
49 
50 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev Interface of the ERC20 standard as defined in the EIP.
56  */
57 interface IERC20 {
58     /**
59      * @dev Returns the amount of tokens in existence.
60      */
61     function totalSupply() external view returns (uint256);
62 
63     /**
64      * @dev Returns the amount of tokens owned by `account`.
65      */
66     function balanceOf(address account) external view returns (uint256);
67 
68     /**
69      * @dev Moves `amount` tokens from the caller's account to `to`.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transfer(address to, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Returns the remaining number of tokens that `spender` will be
79      * allowed to spend on behalf of `owner` through {transferFrom}. This is
80      * zero by default.
81      *
82      * This value changes when {approve} or {transferFrom} are called.
83      */
84     function allowance(address owner, address spender) external view returns (uint256);
85 
86     /**
87      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * IMPORTANT: Beware that changing an allowance with this method brings the risk
92      * that someone may use both the old and the new allowance by unfortunate
93      * transaction ordering. One possible solution to mitigate this race
94      * condition is to first reduce the spender's allowance to 0 and set the
95      * desired value afterwards:
96      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
97      *
98      * Emits an {Approval} event.
99      */
100     function approve(address spender, uint256 amount) external returns (bool);
101 
102     /**
103      * @dev Moves `amount` tokens from `from` to `to` using the
104      * allowance mechanism. `amount` is then deducted from the caller's
105      * allowance.
106      *
107      * Returns a boolean value indicating whether the operation succeeded.
108      *
109      * Emits a {Transfer} event.
110      */
111     function transferFrom(
112         address from,
113         address to,
114         uint256 amount
115     ) external returns (bool);
116 
117     /**
118      * @dev Emitted when `value` tokens are moved from one account (`from`) to
119      * another (`to`).
120      *
121      * Note that `value` may be zero.
122      */
123     event Transfer(address indexed from, address indexed to, uint256 value);
124 
125     /**
126      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
127      * a call to {approve}. `value` is the new allowance.
128      */
129     event Approval(address indexed owner, address indexed spender, uint256 value);
130 }
131 
132 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
133 
134 
135 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
136 
137 pragma solidity ^0.8.0;
138 
139 /**
140  * @dev Contract module that helps prevent reentrant calls to a function.
141  *
142  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
143  * available, which can be applied to functions to make sure there are no nested
144  * (reentrant) calls to them.
145  *
146  * Note that because there is a single `nonReentrant` guard, functions marked as
147  * `nonReentrant` may not call one another. This can be worked around by making
148  * those functions `private`, and then adding `external` `nonReentrant` entry
149  * points to them.
150  *
151  * TIP: If you would like to learn more about reentrancy and alternative ways
152  * to protect against it, check out our blog post
153  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
154  */
155 abstract contract ReentrancyGuard {
156     // Booleans are more expensive than uint256 or any type that takes up a full
157     // word because each write operation emits an extra SLOAD to first read the
158     // slot's contents, replace the bits taken up by the boolean, and then write
159     // back. This is the compiler's defense against contract upgrades and
160     // pointer aliasing, and it cannot be disabled.
161 
162     // The values being non-zero value makes deployment a bit more expensive,
163     // but in exchange the refund on every call to nonReentrant will be lower in
164     // amount. Since refunds are capped to a percentage of the total
165     // transaction's gas, it is best to keep them low in cases like this one, to
166     // increase the likelihood of the full refund coming into effect.
167     uint256 private constant _NOT_ENTERED = 1;
168     uint256 private constant _ENTERED = 2;
169 
170     uint256 private _status;
171 
172     constructor() {
173         _status = _NOT_ENTERED;
174     }
175 
176     /**
177      * @dev Prevents a contract from calling itself, directly or indirectly.
178      * Calling a `nonReentrant` function from another `nonReentrant`
179      * function is not supported. It is possible to prevent this from happening
180      * by making the `nonReentrant` function external, and making it call a
181      * `private` function that does the actual work.
182      */
183     modifier nonReentrant() {
184         // On the first call to nonReentrant, _notEntered will be true
185         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
186 
187         // Any calls to nonReentrant after this point will fail
188         _status = _ENTERED;
189 
190         _;
191 
192         // By storing the original value once again, a refund is triggered (see
193         // https://eips.ethereum.org/EIPS/eip-2200)
194         _status = _NOT_ENTERED;
195     }
196 }
197 
198 // File: @openzeppelin/contracts/utils/Strings.sol
199 
200 
201 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
202 
203 pragma solidity ^0.8.0;
204 
205 /**
206  * @dev String operations.
207  */
208 library Strings {
209     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
210 
211     /**
212      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
213      */
214     function toString(uint256 value) internal pure returns (string memory) {
215         // Inspired by OraclizeAPI's implementation - MIT licence
216         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
217 
218         if (value == 0) {
219             return "0";
220         }
221         uint256 temp = value;
222         uint256 digits;
223         while (temp != 0) {
224             digits++;
225             temp /= 10;
226         }
227         bytes memory buffer = new bytes(digits);
228         while (value != 0) {
229             digits -= 1;
230             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
231             value /= 10;
232         }
233         return string(buffer);
234     }
235 
236     /**
237      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
238      */
239     function toHexString(uint256 value) internal pure returns (string memory) {
240         if (value == 0) {
241             return "0x00";
242         }
243         uint256 temp = value;
244         uint256 length = 0;
245         while (temp != 0) {
246             length++;
247             temp >>= 8;
248         }
249         return toHexString(value, length);
250     }
251 
252     /**
253      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
254      */
255     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
256         bytes memory buffer = new bytes(2 * length + 2);
257         buffer[0] = "0";
258         buffer[1] = "x";
259         for (uint256 i = 2 * length + 1; i > 1; --i) {
260             buffer[i] = _HEX_SYMBOLS[value & 0xf];
261             value >>= 4;
262         }
263         require(value == 0, "Strings: hex length insufficient");
264         return string(buffer);
265     }
266 }
267 
268 // File: @openzeppelin/contracts/utils/Context.sol
269 
270 
271 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
272 
273 pragma solidity ^0.8.0;
274 
275 /**
276  * @dev Provides information about the current execution context, including the
277  * sender of the transaction and its data. While these are generally available
278  * via msg.sender and msg.data, they should not be accessed in such a direct
279  * manner, since when dealing with meta-transactions the account sending and
280  * paying for execution may not be the actual sender (as far as an application
281  * is concerned).
282  *
283  * This contract is only required for intermediate, library-like contracts.
284  */
285 abstract contract Context {
286     function _msgSender() internal view virtual returns (address) {
287         return msg.sender;
288     }
289 
290     function _msgData() internal view virtual returns (bytes calldata) {
291         return msg.data;
292     }
293 }
294 
295 // File: @openzeppelin/contracts/security/Pausable.sol
296 
297 
298 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
299 
300 pragma solidity ^0.8.0;
301 
302 
303 /**
304  * @dev Contract module which allows children to implement an emergency stop
305  * mechanism that can be triggered by an authorized account.
306  *
307  * This module is used through inheritance. It will make available the
308  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
309  * the functions of your contract. Note that they will not be pausable by
310  * simply including this module, only once the modifiers are put in place.
311  */
312 abstract contract Pausable is Context {
313     /**
314      * @dev Emitted when the pause is triggered by `account`.
315      */
316     event Paused(address account);
317 
318     /**
319      * @dev Emitted when the pause is lifted by `account`.
320      */
321     event Unpaused(address account);
322 
323     bool private _paused;
324 
325     /**
326      * @dev Initializes the contract in unpaused state.
327      */
328     constructor() {
329         _paused = false;
330     }
331 
332     /**
333      * @dev Returns true if the contract is paused, and false otherwise.
334      */
335     function paused() public view virtual returns (bool) {
336         return _paused;
337     }
338 
339     /**
340      * @dev Modifier to make a function callable only when the contract is not paused.
341      *
342      * Requirements:
343      *
344      * - The contract must not be paused.
345      */
346     modifier whenNotPaused() {
347         require(!paused(), "Pausable: paused");
348         _;
349     }
350 
351     /**
352      * @dev Modifier to make a function callable only when the contract is paused.
353      *
354      * Requirements:
355      *
356      * - The contract must be paused.
357      */
358     modifier whenPaused() {
359         require(paused(), "Pausable: not paused");
360         _;
361     }
362 
363     /**
364      * @dev Triggers stopped state.
365      *
366      * Requirements:
367      *
368      * - The contract must not be paused.
369      */
370     function _pause() internal virtual whenNotPaused {
371         _paused = true;
372         emit Paused(_msgSender());
373     }
374 
375     /**
376      * @dev Returns to normal state.
377      *
378      * Requirements:
379      *
380      * - The contract must be paused.
381      */
382     function _unpause() internal virtual whenPaused {
383         _paused = false;
384         emit Unpaused(_msgSender());
385     }
386 }
387 
388 // File: @openzeppelin/contracts/access/Ownable.sol
389 
390 
391 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
392 
393 pragma solidity ^0.8.0;
394 
395 
396 /**
397  * @dev Contract module which provides a basic access control mechanism, where
398  * there is an account (an owner) that can be granted exclusive access to
399  * specific functions.
400  *
401  * By default, the owner account will be the one that deploys the contract. This
402  * can later be changed with {transferOwnership}.
403  *
404  * This module is used through inheritance. It will make available the modifier
405  * `onlyOwner`, which can be applied to your functions to restrict their use to
406  * the owner.
407  */
408 abstract contract Ownable is Context {
409     address private _owner;
410 
411     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
412 
413     /**
414      * @dev Initializes the contract setting the deployer as the initial owner.
415      */
416     constructor() {
417         _transferOwnership(_msgSender());
418     }
419 
420     /**
421      * @dev Returns the address of the current owner.
422      */
423     function owner() public view virtual returns (address) {
424         return _owner;
425     }
426 
427     /**
428      * @dev Throws if called by any account other than the owner.
429      */
430     modifier onlyOwner() {
431         require(owner() == _msgSender(), "Ownable: caller is not the owner");
432         _;
433     }
434 
435     /**
436      * @dev Leaves the contract without owner. It will not be possible to call
437      * `onlyOwner` functions anymore. Can only be called by the current owner.
438      *
439      * NOTE: Renouncing ownership will leave the contract without an owner,
440      * thereby removing any functionality that is only available to the owner.
441      */
442     function renounceOwnership() public virtual onlyOwner {
443         _transferOwnership(address(0));
444     }
445 
446     /**
447      * @dev Transfers ownership of the contract to a new account (`newOwner`).
448      * Can only be called by the current owner.
449      */
450     function transferOwnership(address newOwner) public virtual onlyOwner {
451         require(newOwner != address(0), "Ownable: new owner is the zero address");
452         _transferOwnership(newOwner);
453     }
454 
455     /**
456      * @dev Transfers ownership of the contract to a new account (`newOwner`).
457      * Internal function without access restriction.
458      */
459     function _transferOwnership(address newOwner) internal virtual {
460         address oldOwner = _owner;
461         _owner = newOwner;
462         emit OwnershipTransferred(oldOwner, newOwner);
463     }
464 }
465 
466 // File: @openzeppelin/contracts/utils/Address.sol
467 
468 
469 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
470 
471 pragma solidity ^0.8.1;
472 
473 /**
474  * @dev Collection of functions related to the address type
475  */
476 library Address {
477     /**
478      * @dev Returns true if `account` is a contract.
479      *
480      * [IMPORTANT]
481      * ====
482      * It is unsafe to assume that an address for which this function returns
483      * false is an externally-owned account (EOA) and not a contract.
484      *
485      * Among others, `isContract` will return false for the following
486      * types of addresses:
487      *
488      *  - an externally-owned account
489      *  - a contract in construction
490      *  - an address where a contract will be created
491      *  - an address where a contract lived, but was destroyed
492      * ====
493      *
494      * [IMPORTANT]
495      * ====
496      * You shouldn't rely on `isContract` to protect against flash loan attacks!
497      *
498      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
499      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
500      * constructor.
501      * ====
502      */
503     function isContract(address account) internal view returns (bool) {
504         // This method relies on extcodesize/address.code.length, which returns 0
505         // for contracts in construction, since the code is only stored at the end
506         // of the constructor execution.
507 
508         return account.code.length > 0;
509     }
510 
511     /**
512      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
513      * `recipient`, forwarding all available gas and reverting on errors.
514      *
515      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
516      * of certain opcodes, possibly making contracts go over the 2300 gas limit
517      * imposed by `transfer`, making them unable to receive funds via
518      * `transfer`. {sendValue} removes this limitation.
519      *
520      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
521      *
522      * IMPORTANT: because control is transferred to `recipient`, care must be
523      * taken to not create reentrancy vulnerabilities. Consider using
524      * {ReentrancyGuard} or the
525      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
526      */
527     function sendValue(address payable recipient, uint256 amount) internal {
528         require(address(this).balance >= amount, "Address: insufficient balance");
529 
530         (bool success, ) = recipient.call{value: amount}("");
531         require(success, "Address: unable to send value, recipient may have reverted");
532     }
533 
534     /**
535      * @dev Performs a Solidity function call using a low level `call`. A
536      * plain `call` is an unsafe replacement for a function call: use this
537      * function instead.
538      *
539      * If `target` reverts with a revert reason, it is bubbled up by this
540      * function (like regular Solidity function calls).
541      *
542      * Returns the raw returned data. To convert to the expected return value,
543      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
544      *
545      * Requirements:
546      *
547      * - `target` must be a contract.
548      * - calling `target` with `data` must not revert.
549      *
550      * _Available since v3.1._
551      */
552     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
553         return functionCall(target, data, "Address: low-level call failed");
554     }
555 
556     /**
557      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
558      * `errorMessage` as a fallback revert reason when `target` reverts.
559      *
560      * _Available since v3.1._
561      */
562     function functionCall(
563         address target,
564         bytes memory data,
565         string memory errorMessage
566     ) internal returns (bytes memory) {
567         return functionCallWithValue(target, data, 0, errorMessage);
568     }
569 
570     /**
571      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
572      * but also transferring `value` wei to `target`.
573      *
574      * Requirements:
575      *
576      * - the calling contract must have an ETH balance of at least `value`.
577      * - the called Solidity function must be `payable`.
578      *
579      * _Available since v3.1._
580      */
581     function functionCallWithValue(
582         address target,
583         bytes memory data,
584         uint256 value
585     ) internal returns (bytes memory) {
586         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
587     }
588 
589     /**
590      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
591      * with `errorMessage` as a fallback revert reason when `target` reverts.
592      *
593      * _Available since v3.1._
594      */
595     function functionCallWithValue(
596         address target,
597         bytes memory data,
598         uint256 value,
599         string memory errorMessage
600     ) internal returns (bytes memory) {
601         require(address(this).balance >= value, "Address: insufficient balance for call");
602         require(isContract(target), "Address: call to non-contract");
603 
604         (bool success, bytes memory returndata) = target.call{value: value}(data);
605         return verifyCallResult(success, returndata, errorMessage);
606     }
607 
608     /**
609      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
610      * but performing a static call.
611      *
612      * _Available since v3.3._
613      */
614     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
615         return functionStaticCall(target, data, "Address: low-level static call failed");
616     }
617 
618     /**
619      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
620      * but performing a static call.
621      *
622      * _Available since v3.3._
623      */
624     function functionStaticCall(
625         address target,
626         bytes memory data,
627         string memory errorMessage
628     ) internal view returns (bytes memory) {
629         require(isContract(target), "Address: static call to non-contract");
630 
631         (bool success, bytes memory returndata) = target.staticcall(data);
632         return verifyCallResult(success, returndata, errorMessage);
633     }
634 
635     /**
636      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
637      * but performing a delegate call.
638      *
639      * _Available since v3.4._
640      */
641     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
642         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
643     }
644 
645     /**
646      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
647      * but performing a delegate call.
648      *
649      * _Available since v3.4._
650      */
651     function functionDelegateCall(
652         address target,
653         bytes memory data,
654         string memory errorMessage
655     ) internal returns (bytes memory) {
656         require(isContract(target), "Address: delegate call to non-contract");
657 
658         (bool success, bytes memory returndata) = target.delegatecall(data);
659         return verifyCallResult(success, returndata, errorMessage);
660     }
661 
662     /**
663      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
664      * revert reason using the provided one.
665      *
666      * _Available since v4.3._
667      */
668     function verifyCallResult(
669         bool success,
670         bytes memory returndata,
671         string memory errorMessage
672     ) internal pure returns (bytes memory) {
673         if (success) {
674             return returndata;
675         } else {
676             // Look for revert reason and bubble it up if present
677             if (returndata.length > 0) {
678                 // The easiest way to bubble the revert reason is using memory via assembly
679 
680                 assembly {
681                     let returndata_size := mload(returndata)
682                     revert(add(32, returndata), returndata_size)
683                 }
684             } else {
685                 revert(errorMessage);
686             }
687         }
688     }
689 }
690 
691 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
692 
693 
694 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
695 
696 pragma solidity ^0.8.0;
697 
698 
699 
700 /**
701  * @title SafeERC20
702  * @dev Wrappers around ERC20 operations that throw on failure (when the token
703  * contract returns false). Tokens that return no value (and instead revert or
704  * throw on failure) are also supported, non-reverting calls are assumed to be
705  * successful.
706  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
707  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
708  */
709 library SafeERC20 {
710     using Address for address;
711 
712     function safeTransfer(
713         IERC20 token,
714         address to,
715         uint256 value
716     ) internal {
717         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
718     }
719 
720     function safeTransferFrom(
721         IERC20 token,
722         address from,
723         address to,
724         uint256 value
725     ) internal {
726         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
727     }
728 
729     /**
730      * @dev Deprecated. This function has issues similar to the ones found in
731      * {IERC20-approve}, and its usage is discouraged.
732      *
733      * Whenever possible, use {safeIncreaseAllowance} and
734      * {safeDecreaseAllowance} instead.
735      */
736     function safeApprove(
737         IERC20 token,
738         address spender,
739         uint256 value
740     ) internal {
741         // safeApprove should only be called when setting an initial allowance,
742         // or when resetting it to zero. To increase and decrease it, use
743         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
744         require(
745             (value == 0) || (token.allowance(address(this), spender) == 0),
746             "SafeERC20: approve from non-zero to non-zero allowance"
747         );
748         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
749     }
750 
751     function safeIncreaseAllowance(
752         IERC20 token,
753         address spender,
754         uint256 value
755     ) internal {
756         uint256 newAllowance = token.allowance(address(this), spender) + value;
757         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
758     }
759 
760     function safeDecreaseAllowance(
761         IERC20 token,
762         address spender,
763         uint256 value
764     ) internal {
765         unchecked {
766             uint256 oldAllowance = token.allowance(address(this), spender);
767             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
768             uint256 newAllowance = oldAllowance - value;
769             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
770         }
771     }
772 
773     /**
774      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
775      * on the return value: the return value is optional (but if data is returned, it must not be false).
776      * @param token The token targeted by the call.
777      * @param data The call data (encoded using abi.encode or one of its variants).
778      */
779     function _callOptionalReturn(IERC20 token, bytes memory data) private {
780         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
781         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
782         // the target address contains contract code and also asserts for success in the low-level call.
783 
784         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
785         if (returndata.length > 0) {
786             // Return data is optional
787             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
788         }
789     }
790 }
791 
792 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
793 
794 
795 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
796 
797 pragma solidity ^0.8.0;
798 
799 
800 
801 
802 /**
803  * @title PaymentSplitter
804  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
805  * that the Ether will be split in this way, since it is handled transparently by the contract.
806  *
807  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
808  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
809  * an amount proportional to the percentage of total shares they were assigned.
810  *
811  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
812  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
813  * function.
814  *
815  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
816  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
817  * to run tests before sending real value to this contract.
818  */
819 contract PaymentSplitter is Context {
820     event PayeeAdded(address account, uint256 shares);
821     event PaymentReleased(address to, uint256 amount);
822     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
823     event PaymentReceived(address from, uint256 amount);
824 
825     uint256 private _totalShares;
826     uint256 private _totalReleased;
827 
828     mapping(address => uint256) private _shares;
829     mapping(address => uint256) private _released;
830     address[] private _payees;
831 
832     mapping(IERC20 => uint256) private _erc20TotalReleased;
833     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
834 
835     /**
836      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
837      * the matching position in the `shares` array.
838      *
839      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
840      * duplicates in `payees`.
841      */
842     constructor(address[] memory payees, uint256[] memory shares_) payable {
843         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
844         require(payees.length > 0, "PaymentSplitter: no payees");
845 
846         for (uint256 i = 0; i < payees.length; i++) {
847             _addPayee(payees[i], shares_[i]);
848         }
849     }
850 
851     /**
852      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
853      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
854      * reliability of the events, and not the actual splitting of Ether.
855      *
856      * To learn more about this see the Solidity documentation for
857      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
858      * functions].
859      */
860     receive() external payable virtual {
861         emit PaymentReceived(_msgSender(), msg.value);
862     }
863 
864     /**
865      * @dev Getter for the total shares held by payees.
866      */
867     function totalShares() public view returns (uint256) {
868         return _totalShares;
869     }
870 
871     /**
872      * @dev Getter for the total amount of Ether already released.
873      */
874     function totalReleased() public view returns (uint256) {
875         return _totalReleased;
876     }
877 
878     /**
879      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
880      * contract.
881      */
882     function totalReleased(IERC20 token) public view returns (uint256) {
883         return _erc20TotalReleased[token];
884     }
885 
886     /**
887      * @dev Getter for the amount of shares held by an account.
888      */
889     function shares(address account) public view returns (uint256) {
890         return _shares[account];
891     }
892 
893     /**
894      * @dev Getter for the amount of Ether already released to a payee.
895      */
896     function released(address account) public view returns (uint256) {
897         return _released[account];
898     }
899 
900     /**
901      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
902      * IERC20 contract.
903      */
904     function released(IERC20 token, address account) public view returns (uint256) {
905         return _erc20Released[token][account];
906     }
907 
908     /**
909      * @dev Getter for the address of the payee number `index`.
910      */
911     function payee(uint256 index) public view returns (address) {
912         return _payees[index];
913     }
914 
915     /**
916      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
917      * total shares and their previous withdrawals.
918      */
919     function release(address payable account) public virtual {
920         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
921 
922         uint256 totalReceived = address(this).balance + totalReleased();
923         uint256 payment = _pendingPayment(account, totalReceived, released(account));
924 
925         require(payment != 0, "PaymentSplitter: account is not due payment");
926 
927         _released[account] += payment;
928         _totalReleased += payment;
929 
930         Address.sendValue(account, payment);
931         emit PaymentReleased(account, payment);
932     }
933 
934     /**
935      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
936      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
937      * contract.
938      */
939     function release(IERC20 token, address account) public virtual {
940         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
941 
942         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
943         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
944 
945         require(payment != 0, "PaymentSplitter: account is not due payment");
946 
947         _erc20Released[token][account] += payment;
948         _erc20TotalReleased[token] += payment;
949 
950         SafeERC20.safeTransfer(token, account, payment);
951         emit ERC20PaymentReleased(token, account, payment);
952     }
953 
954     /**
955      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
956      * already released amounts.
957      */
958     function _pendingPayment(
959         address account,
960         uint256 totalReceived,
961         uint256 alreadyReleased
962     ) private view returns (uint256) {
963         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
964     }
965 
966     /**
967      * @dev Add a new payee to the contract.
968      * @param account The address of the payee to add.
969      * @param shares_ The number of shares owned by the payee.
970      */
971     function _addPayee(address account, uint256 shares_) private {
972         require(account != address(0), "PaymentSplitter: account is the zero address");
973         require(shares_ > 0, "PaymentSplitter: shares are 0");
974         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
975 
976         _payees.push(account);
977         _shares[account] = shares_;
978         _totalShares = _totalShares + shares_;
979         emit PayeeAdded(account, shares_);
980     }
981 }
982 
983 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
984 
985 
986 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
987 
988 pragma solidity ^0.8.0;
989 
990 /**
991  * @title ERC721 token receiver interface
992  * @dev Interface for any contract that wants to support safeTransfers
993  * from ERC721 asset contracts.
994  */
995 interface IERC721Receiver {
996     /**
997      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
998      * by `operator` from `from`, this function is called.
999      *
1000      * It must return its Solidity selector to confirm the token transfer.
1001      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1002      *
1003      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1004      */
1005     function onERC721Received(
1006         address operator,
1007         address from,
1008         uint256 tokenId,
1009         bytes calldata data
1010     ) external returns (bytes4);
1011 }
1012 
1013 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1014 
1015 
1016 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1017 
1018 pragma solidity ^0.8.0;
1019 
1020 /**
1021  * @dev Interface of the ERC165 standard, as defined in the
1022  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1023  *
1024  * Implementers can declare support of contract interfaces, which can then be
1025  * queried by others ({ERC165Checker}).
1026  *
1027  * For an implementation, see {ERC165}.
1028  */
1029 interface IERC165 {
1030     /**
1031      * @dev Returns true if this contract implements the interface defined by
1032      * `interfaceId`. See the corresponding
1033      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1034      * to learn more about how these ids are created.
1035      *
1036      * This function call must use less than 30 000 gas.
1037      */
1038     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1039 }
1040 
1041 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1042 
1043 
1044 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1045 
1046 pragma solidity ^0.8.0;
1047 
1048 
1049 /**
1050  * @dev Implementation of the {IERC165} interface.
1051  *
1052  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1053  * for the additional interface id that will be supported. For example:
1054  *
1055  * ```solidity
1056  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1057  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1058  * }
1059  * ```
1060  *
1061  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1062  */
1063 abstract contract ERC165 is IERC165 {
1064     /**
1065      * @dev See {IERC165-supportsInterface}.
1066      */
1067     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1068         return interfaceId == type(IERC165).interfaceId;
1069     }
1070 }
1071 
1072 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1073 
1074 
1075 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
1076 
1077 pragma solidity ^0.8.0;
1078 
1079 
1080 /**
1081  * @dev Required interface of an ERC721 compliant contract.
1082  */
1083 interface IERC721 is IERC165 {
1084     /**
1085      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1086      */
1087     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1088 
1089     /**
1090      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1091      */
1092     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1093 
1094     /**
1095      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1096      */
1097     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1098 
1099     /**
1100      * @dev Returns the number of tokens in ``owner``'s account.
1101      */
1102     function balanceOf(address owner) external view returns (uint256 balance);
1103 
1104     /**
1105      * @dev Returns the owner of the `tokenId` token.
1106      *
1107      * Requirements:
1108      *
1109      * - `tokenId` must exist.
1110      */
1111     function ownerOf(uint256 tokenId) external view returns (address owner);
1112 
1113     /**
1114      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1115      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1116      *
1117      * Requirements:
1118      *
1119      * - `from` cannot be the zero address.
1120      * - `to` cannot be the zero address.
1121      * - `tokenId` token must exist and be owned by `from`.
1122      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1123      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1124      *
1125      * Emits a {Transfer} event.
1126      */
1127     function safeTransferFrom(
1128         address from,
1129         address to,
1130         uint256 tokenId
1131     ) external;
1132 
1133     /**
1134      * @dev Transfers `tokenId` token from `from` to `to`.
1135      *
1136      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1137      *
1138      * Requirements:
1139      *
1140      * - `from` cannot be the zero address.
1141      * - `to` cannot be the zero address.
1142      * - `tokenId` token must be owned by `from`.
1143      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1144      *
1145      * Emits a {Transfer} event.
1146      */
1147     function transferFrom(
1148         address from,
1149         address to,
1150         uint256 tokenId
1151     ) external;
1152 
1153     /**
1154      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1155      * The approval is cleared when the token is transferred.
1156      *
1157      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1158      *
1159      * Requirements:
1160      *
1161      * - The caller must own the token or be an approved operator.
1162      * - `tokenId` must exist.
1163      *
1164      * Emits an {Approval} event.
1165      */
1166     function approve(address to, uint256 tokenId) external;
1167 
1168     /**
1169      * @dev Returns the account approved for `tokenId` token.
1170      *
1171      * Requirements:
1172      *
1173      * - `tokenId` must exist.
1174      */
1175     function getApproved(uint256 tokenId) external view returns (address operator);
1176 
1177     /**
1178      * @dev Approve or remove `operator` as an operator for the caller.
1179      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1180      *
1181      * Requirements:
1182      *
1183      * - The `operator` cannot be the caller.
1184      *
1185      * Emits an {ApprovalForAll} event.
1186      */
1187     function setApprovalForAll(address operator, bool _approved) external;
1188 
1189     /**
1190      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1191      *
1192      * See {setApprovalForAll}
1193      */
1194     function isApprovedForAll(address owner, address operator) external view returns (bool);
1195 
1196     /**
1197      * @dev Safely transfers `tokenId` token from `from` to `to`.
1198      *
1199      * Requirements:
1200      *
1201      * - `from` cannot be the zero address.
1202      * - `to` cannot be the zero address.
1203      * - `tokenId` token must exist and be owned by `from`.
1204      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1205      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1206      *
1207      * Emits a {Transfer} event.
1208      */
1209     function safeTransferFrom(
1210         address from,
1211         address to,
1212         uint256 tokenId,
1213         bytes calldata data
1214     ) external;
1215 }
1216 
1217 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1218 
1219 
1220 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1221 
1222 pragma solidity ^0.8.0;
1223 
1224 
1225 /**
1226  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1227  * @dev See https://eips.ethereum.org/EIPS/eip-721
1228  */
1229 interface IERC721Enumerable is IERC721 {
1230     /**
1231      * @dev Returns the total amount of tokens stored by the contract.
1232      */
1233     function totalSupply() external view returns (uint256);
1234 
1235     /**
1236      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1237      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1238      */
1239     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1240 
1241     /**
1242      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1243      * Use along with {totalSupply} to enumerate all tokens.
1244      */
1245     function tokenByIndex(uint256 index) external view returns (uint256);
1246 }
1247 
1248 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1249 
1250 
1251 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1252 
1253 pragma solidity ^0.8.0;
1254 
1255 
1256 /**
1257  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1258  * @dev See https://eips.ethereum.org/EIPS/eip-721
1259  */
1260 interface IERC721Metadata is IERC721 {
1261     /**
1262      * @dev Returns the token collection name.
1263      */
1264     function name() external view returns (string memory);
1265 
1266     /**
1267      * @dev Returns the token collection symbol.
1268      */
1269     function symbol() external view returns (string memory);
1270 
1271     /**
1272      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1273      */
1274     function tokenURI(uint256 tokenId) external view returns (string memory);
1275 }
1276 
1277 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1278 
1279 
1280 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
1281 
1282 pragma solidity ^0.8.0;
1283 
1284 
1285 
1286 
1287 
1288 
1289 
1290 
1291 /**
1292  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1293  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1294  * {ERC721Enumerable}.
1295  */
1296 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1297     using Address for address;
1298     using Strings for uint256;
1299 
1300     // Token name
1301     string private _name;
1302 
1303     // Token symbol
1304     string private _symbol;
1305 
1306     // Mapping from token ID to owner address
1307     mapping(uint256 => address) private _owners;
1308 
1309     // Mapping owner address to token count
1310     mapping(address => uint256) private _balances;
1311 
1312     // Mapping from token ID to approved address
1313     mapping(uint256 => address) private _tokenApprovals;
1314 
1315     // Mapping from owner to operator approvals
1316     mapping(address => mapping(address => bool)) private _operatorApprovals;
1317 
1318     /**
1319      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1320      */
1321     constructor(string memory name_, string memory symbol_) {
1322         _name = name_;
1323         _symbol = symbol_;
1324     }
1325 
1326     /**
1327      * @dev See {IERC165-supportsInterface}.
1328      */
1329     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1330         return
1331             interfaceId == type(IERC721).interfaceId ||
1332             interfaceId == type(IERC721Metadata).interfaceId ||
1333             super.supportsInterface(interfaceId);
1334     }
1335 
1336     /**
1337      * @dev See {IERC721-balanceOf}.
1338      */
1339     function balanceOf(address owner) public view virtual override returns (uint256) {
1340         require(owner != address(0), "ERC721: balance query for the zero address");
1341         return _balances[owner];
1342     }
1343 
1344     /**
1345      * @dev See {IERC721-ownerOf}.
1346      */
1347     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1348         address owner = _owners[tokenId];
1349         require(owner != address(0), "ERC721: owner query for nonexistent token");
1350         return owner;
1351     }
1352 
1353     /**
1354      * @dev See {IERC721Metadata-name}.
1355      */
1356     function name() public view virtual override returns (string memory) {
1357         return _name;
1358     }
1359 
1360     /**
1361      * @dev See {IERC721Metadata-symbol}.
1362      */
1363     function symbol() public view virtual override returns (string memory) {
1364         return _symbol;
1365     }
1366 
1367     /**
1368      * @dev See {IERC721Metadata-tokenURI}.
1369      */
1370     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1371         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1372 
1373         string memory baseURI = _baseURI();
1374         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1375     }
1376 
1377     /**
1378      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1379      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1380      * by default, can be overriden in child contracts.
1381      */
1382     function _baseURI() internal view virtual returns (string memory) {
1383         return "";
1384     }
1385 
1386     /**
1387      * @dev See {IERC721-approve}.
1388      */
1389     function approve(address to, uint256 tokenId) public virtual override {
1390         address owner = ERC721.ownerOf(tokenId);
1391         require(to != owner, "ERC721: approval to current owner");
1392 
1393         require(
1394             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1395             "ERC721: approve caller is not owner nor approved for all"
1396         );
1397 
1398         _approve(to, tokenId);
1399     }
1400 
1401     /**
1402      * @dev See {IERC721-getApproved}.
1403      */
1404     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1405         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1406 
1407         return _tokenApprovals[tokenId];
1408     }
1409 
1410     /**
1411      * @dev See {IERC721-setApprovalForAll}.
1412      */
1413     function setApprovalForAll(address operator, bool approved) public virtual override {
1414         _setApprovalForAll(_msgSender(), operator, approved);
1415     }
1416 
1417     /**
1418      * @dev See {IERC721-isApprovedForAll}.
1419      */
1420     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1421         return _operatorApprovals[owner][operator];
1422     }
1423 
1424     /**
1425      * @dev See {IERC721-transferFrom}.
1426      */
1427     function transferFrom(
1428         address from,
1429         address to,
1430         uint256 tokenId
1431     ) public virtual override {
1432         //solhint-disable-next-line max-line-length
1433         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1434 
1435         _transfer(from, to, tokenId);
1436     }
1437 
1438     /**
1439      * @dev See {IERC721-safeTransferFrom}.
1440      */
1441     function safeTransferFrom(
1442         address from,
1443         address to,
1444         uint256 tokenId
1445     ) public virtual override {
1446         safeTransferFrom(from, to, tokenId, "");
1447     }
1448 
1449     /**
1450      * @dev See {IERC721-safeTransferFrom}.
1451      */
1452     function safeTransferFrom(
1453         address from,
1454         address to,
1455         uint256 tokenId,
1456         bytes memory _data
1457     ) public virtual override {
1458         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1459         _safeTransfer(from, to, tokenId, _data);
1460     }
1461 
1462     /**
1463      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1464      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1465      *
1466      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1467      *
1468      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1469      * implement alternative mechanisms to perform token transfer, such as signature-based.
1470      *
1471      * Requirements:
1472      *
1473      * - `from` cannot be the zero address.
1474      * - `to` cannot be the zero address.
1475      * - `tokenId` token must exist and be owned by `from`.
1476      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1477      *
1478      * Emits a {Transfer} event.
1479      */
1480     function _safeTransfer(
1481         address from,
1482         address to,
1483         uint256 tokenId,
1484         bytes memory _data
1485     ) internal virtual {
1486         _transfer(from, to, tokenId);
1487         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1488     }
1489 
1490     /**
1491      * @dev Returns whether `tokenId` exists.
1492      *
1493      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1494      *
1495      * Tokens start existing when they are minted (`_mint`),
1496      * and stop existing when they are burned (`_burn`).
1497      */
1498     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1499         return _owners[tokenId] != address(0);
1500     }
1501 
1502     /**
1503      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1504      *
1505      * Requirements:
1506      *
1507      * - `tokenId` must exist.
1508      */
1509     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1510         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1511         address owner = ERC721.ownerOf(tokenId);
1512         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1513     }
1514 
1515     /**
1516      * @dev Safely mints `tokenId` and transfers it to `to`.
1517      *
1518      * Requirements:
1519      *
1520      * - `tokenId` must not exist.
1521      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1522      *
1523      * Emits a {Transfer} event.
1524      */
1525     function _safeMint(address to, uint256 tokenId) internal virtual {
1526         _safeMint(to, tokenId, "");
1527     }
1528 
1529     /**
1530      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1531      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1532      */
1533     function _safeMint(
1534         address to,
1535         uint256 tokenId,
1536         bytes memory _data
1537     ) internal virtual {
1538         _mint(to, tokenId);
1539         require(
1540             _checkOnERC721Received(address(0), to, tokenId, _data),
1541             "ERC721: transfer to non ERC721Receiver implementer"
1542         );
1543     }
1544 
1545     /**
1546      * @dev Mints `tokenId` and transfers it to `to`.
1547      *
1548      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1549      *
1550      * Requirements:
1551      *
1552      * - `tokenId` must not exist.
1553      * - `to` cannot be the zero address.
1554      *
1555      * Emits a {Transfer} event.
1556      */
1557     function _mint(address to, uint256 tokenId) internal virtual {
1558         require(to != address(0), "ERC721: mint to the zero address");
1559         require(!_exists(tokenId), "ERC721: token already minted");
1560 
1561         _beforeTokenTransfer(address(0), to, tokenId);
1562 
1563         _balances[to] += 1;
1564         _owners[tokenId] = to;
1565 
1566         emit Transfer(address(0), to, tokenId);
1567 
1568         _afterTokenTransfer(address(0), to, tokenId);
1569     }
1570 
1571     /**
1572      * @dev Destroys `tokenId`.
1573      * The approval is cleared when the token is burned.
1574      *
1575      * Requirements:
1576      *
1577      * - `tokenId` must exist.
1578      *
1579      * Emits a {Transfer} event.
1580      */
1581     function _burn(uint256 tokenId) internal virtual {
1582         address owner = ERC721.ownerOf(tokenId);
1583 
1584         _beforeTokenTransfer(owner, address(0), tokenId);
1585 
1586         // Clear approvals
1587         _approve(address(0), tokenId);
1588 
1589         _balances[owner] -= 1;
1590         delete _owners[tokenId];
1591 
1592         emit Transfer(owner, address(0), tokenId);
1593 
1594         _afterTokenTransfer(owner, address(0), tokenId);
1595     }
1596 
1597     /**
1598      * @dev Transfers `tokenId` from `from` to `to`.
1599      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1600      *
1601      * Requirements:
1602      *
1603      * - `to` cannot be the zero address.
1604      * - `tokenId` token must be owned by `from`.
1605      *
1606      * Emits a {Transfer} event.
1607      */
1608     function _transfer(
1609         address from,
1610         address to,
1611         uint256 tokenId
1612     ) internal virtual {
1613         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1614         require(to != address(0), "ERC721: transfer to the zero address");
1615 
1616         _beforeTokenTransfer(from, to, tokenId);
1617 
1618         // Clear approvals from the previous owner
1619         _approve(address(0), tokenId);
1620 
1621         _balances[from] -= 1;
1622         _balances[to] += 1;
1623         _owners[tokenId] = to;
1624 
1625         emit Transfer(from, to, tokenId);
1626 
1627         _afterTokenTransfer(from, to, tokenId);
1628     }
1629 
1630     /**
1631      * @dev Approve `to` to operate on `tokenId`
1632      *
1633      * Emits a {Approval} event.
1634      */
1635     function _approve(address to, uint256 tokenId) internal virtual {
1636         _tokenApprovals[tokenId] = to;
1637         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1638     }
1639 
1640     /**
1641      * @dev Approve `operator` to operate on all of `owner` tokens
1642      *
1643      * Emits a {ApprovalForAll} event.
1644      */
1645     function _setApprovalForAll(
1646         address owner,
1647         address operator,
1648         bool approved
1649     ) internal virtual {
1650         require(owner != operator, "ERC721: approve to caller");
1651         _operatorApprovals[owner][operator] = approved;
1652         emit ApprovalForAll(owner, operator, approved);
1653     }
1654 
1655     /**
1656      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1657      * The call is not executed if the target address is not a contract.
1658      *
1659      * @param from address representing the previous owner of the given token ID
1660      * @param to target address that will receive the tokens
1661      * @param tokenId uint256 ID of the token to be transferred
1662      * @param _data bytes optional data to send along with the call
1663      * @return bool whether the call correctly returned the expected magic value
1664      */
1665     function _checkOnERC721Received(
1666         address from,
1667         address to,
1668         uint256 tokenId,
1669         bytes memory _data
1670     ) private returns (bool) {
1671         if (to.isContract()) {
1672             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1673                 return retval == IERC721Receiver.onERC721Received.selector;
1674             } catch (bytes memory reason) {
1675                 if (reason.length == 0) {
1676                     revert("ERC721: transfer to non ERC721Receiver implementer");
1677                 } else {
1678                     assembly {
1679                         revert(add(32, reason), mload(reason))
1680                     }
1681                 }
1682             }
1683         } else {
1684             return true;
1685         }
1686     }
1687 
1688     /**
1689      * @dev Hook that is called before any token transfer. This includes minting
1690      * and burning.
1691      *
1692      * Calling conditions:
1693      *
1694      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1695      * transferred to `to`.
1696      * - When `from` is zero, `tokenId` will be minted for `to`.
1697      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1698      * - `from` and `to` are never both zero.
1699      *
1700      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1701      */
1702     function _beforeTokenTransfer(
1703         address from,
1704         address to,
1705         uint256 tokenId
1706     ) internal virtual {}
1707 
1708     /**
1709      * @dev Hook that is called after any transfer of tokens. This includes
1710      * minting and burning.
1711      *
1712      * Calling conditions:
1713      *
1714      * - when `from` and `to` are both non-zero.
1715      * - `from` and `to` are never both zero.
1716      *
1717      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1718      */
1719     function _afterTokenTransfer(
1720         address from,
1721         address to,
1722         uint256 tokenId
1723     ) internal virtual {}
1724 }
1725 
1726 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1727 
1728 
1729 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1730 
1731 pragma solidity ^0.8.0;
1732 
1733 
1734 
1735 /**
1736  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1737  * enumerability of all the token ids in the contract as well as all token ids owned by each
1738  * account.
1739  */
1740 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1741     // Mapping from owner to list of owned token IDs
1742     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1743 
1744     // Mapping from token ID to index of the owner tokens list
1745     mapping(uint256 => uint256) private _ownedTokensIndex;
1746 
1747     // Array with all token ids, used for enumeration
1748     uint256[] private _allTokens;
1749 
1750     // Mapping from token id to position in the allTokens array
1751     mapping(uint256 => uint256) private _allTokensIndex;
1752 
1753     /**
1754      * @dev See {IERC165-supportsInterface}.
1755      */
1756     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1757         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1758     }
1759 
1760     /**
1761      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1762      */
1763     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1764         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1765         return _ownedTokens[owner][index];
1766     }
1767 
1768     /**
1769      * @dev See {IERC721Enumerable-totalSupply}.
1770      */
1771     function totalSupply() public view virtual override returns (uint256) {
1772         return _allTokens.length;
1773     }
1774 
1775     /**
1776      * @dev See {IERC721Enumerable-tokenByIndex}.
1777      */
1778     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1779         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1780         return _allTokens[index];
1781     }
1782 
1783     /**
1784      * @dev Hook that is called before any token transfer. This includes minting
1785      * and burning.
1786      *
1787      * Calling conditions:
1788      *
1789      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1790      * transferred to `to`.
1791      * - When `from` is zero, `tokenId` will be minted for `to`.
1792      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1793      * - `from` cannot be the zero address.
1794      * - `to` cannot be the zero address.
1795      *
1796      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1797      */
1798     function _beforeTokenTransfer(
1799         address from,
1800         address to,
1801         uint256 tokenId
1802     ) internal virtual override {
1803         super._beforeTokenTransfer(from, to, tokenId);
1804 
1805         if (from == address(0)) {
1806             _addTokenToAllTokensEnumeration(tokenId);
1807         } else if (from != to) {
1808             _removeTokenFromOwnerEnumeration(from, tokenId);
1809         }
1810         if (to == address(0)) {
1811             _removeTokenFromAllTokensEnumeration(tokenId);
1812         } else if (to != from) {
1813             _addTokenToOwnerEnumeration(to, tokenId);
1814         }
1815     }
1816 
1817     /**
1818      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1819      * @param to address representing the new owner of the given token ID
1820      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1821      */
1822     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1823         uint256 length = ERC721.balanceOf(to);
1824         _ownedTokens[to][length] = tokenId;
1825         _ownedTokensIndex[tokenId] = length;
1826     }
1827 
1828     /**
1829      * @dev Private function to add a token to this extension's token tracking data structures.
1830      * @param tokenId uint256 ID of the token to be added to the tokens list
1831      */
1832     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1833         _allTokensIndex[tokenId] = _allTokens.length;
1834         _allTokens.push(tokenId);
1835     }
1836 
1837     /**
1838      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1839      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1840      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1841      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1842      * @param from address representing the previous owner of the given token ID
1843      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1844      */
1845     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1846         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1847         // then delete the last slot (swap and pop).
1848 
1849         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1850         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1851 
1852         // When the token to delete is the last token, the swap operation is unnecessary
1853         if (tokenIndex != lastTokenIndex) {
1854             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1855 
1856             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1857             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1858         }
1859 
1860         // This also deletes the contents at the last position of the array
1861         delete _ownedTokensIndex[tokenId];
1862         delete _ownedTokens[from][lastTokenIndex];
1863     }
1864 
1865     /**
1866      * @dev Private function to remove a token from this extension's token tracking data structures.
1867      * This has O(1) time complexity, but alters the order of the _allTokens array.
1868      * @param tokenId uint256 ID of the token to be removed from the tokens list
1869      */
1870     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1871         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1872         // then delete the last slot (swap and pop).
1873 
1874         uint256 lastTokenIndex = _allTokens.length - 1;
1875         uint256 tokenIndex = _allTokensIndex[tokenId];
1876 
1877         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1878         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1879         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1880         uint256 lastTokenId = _allTokens[lastTokenIndex];
1881 
1882         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1883         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1884 
1885         // This also deletes the contents at the last position of the array
1886         delete _allTokensIndex[tokenId];
1887         _allTokens.pop();
1888     }
1889 }
1890 
1891 // File: contracts/SpaceKidsClub.sol
1892 
1893 
1894 pragma solidity ^0.8.7;
1895 
1896 
1897 
1898 
1899 
1900 
1901 
1902 
1903 /// @custom:security-contact security@spacekids.io
1904 contract SpaceKidsClub is
1905     ERC721,
1906     ERC721Enumerable,
1907     Pausable,
1908     Ownable,
1909     ReentrancyGuard,
1910     PaymentSplitter
1911 {
1912     using Counters for Counters.Counter;
1913     using Strings for uint256;
1914 
1915     //Max NFT supply
1916     uint256 public maxSupply = 3500;
1917     uint256 public preSaleSupply = 100;
1918     uint256 public whitelistSupply = preSaleSupply + 1000;
1919     
1920 
1921     //ID of the next NFT to mint
1922     Counters.Counter private nftIdCounter;
1923 
1924     //Maximum mint quantity
1925     uint256 public maxMintPresale = 5;
1926     uint256 public maxMintWhitelist = 5;
1927     uint256 public maxMintQuantity = 5;
1928 
1929     //The different prices
1930     uint256 public presalePrice = 0.08 ether;
1931     uint256 public whitelistPrice = 0.14 ether;
1932     uint256 public salePrice = 0.16 ether;
1933 
1934     //URI of the NFTs when revealed
1935     string public baseURI;
1936     //URI of the NFTs when not revealed
1937     string public unrevealedURI;
1938 
1939     //Are the NFTs revealed yet
1940     bool public revealed = false;
1941 
1942     //The statuses of the collection
1943     enum Status {
1944         Before,
1945         Presale,
1946         WhitelistSale,
1947         Sale,
1948         SoldOut,
1949         Reveal
1950     }
1951 
1952     Status public status = Status.Before;
1953 
1954     //Events
1955     event ChangeBaseURI(string _baseURI);
1956     event GiftMint(address indexed _recipient, uint256 _amount);
1957     event PresaleMint(address indexed _minter, uint256 _amount, uint256 _price);
1958     event WhitelistMint(
1959         address indexed _minter,
1960         uint256 _amount,
1961         uint256 _price
1962     );
1963     event SaleMint(address indexed _minter, uint256 _amount, uint256 _price);
1964     event StatusChange(Status _previousStatus, Status _newStatus);
1965     event PauseMint();
1966     event UnpauseMint();
1967     event Revealed(bool _revealed);
1968 
1969     //Owner of the smart contract
1970     address private _owner;
1971 
1972     //Keep a track of the number of tokens per address
1973     mapping(address => uint256) nftsPerWalletPresale;
1974     mapping(address => uint256) nftsPerWalletWhitelist;
1975     mapping(address => uint256) nftsPerWallet;
1976 
1977     //Addresses of all the members of the team
1978     address[] private _team = [0xc4b5909C3F4C6dA2fbeb9c73E9CA273f029Ba887];
1979 
1980     //Shares of all the members of the team
1981     uint256[] private _teamShares = [100];
1982 
1983     constructor(
1984         string memory _newBaseURI,
1985         string memory _unrevealedURI
1986     ) ERC721("SpaceKidsClub", "SKC") PaymentSplitter(_team, _teamShares) {
1987         baseURI = _newBaseURI;
1988         unrevealedURI = _unrevealedURI;
1989     }
1990 
1991     /**
1992      * @notice Pauses mint operations
1993      **/
1994     function pause() public onlyOwner {
1995         _pause();
1996         emit PauseMint();
1997     }
1998 
1999     /**
2000      * @notice Unpauses mint operations
2001      **/
2002     function unpause() public onlyOwner {
2003         _unpause();
2004         emit UnpauseMint();
2005     }
2006 
2007     /**
2008      * @notice Change the number of NFTs that an address can mint
2009      *
2010      * @param _maxMintAllowed The number of NFTs that an address can mint
2011      **/
2012     function changeMaxMint(uint256 _maxMintAllowed) external onlyOwner {
2013         maxMintQuantity = _maxMintAllowed;
2014     }
2015 
2016     /**
2017      * @notice Change the number of NFTs that an address can mint during presale
2018      *
2019      * @param _maxMintAllowed The number of NFTs that an address can mint
2020      **/
2021     function changeMaxMintPresale(uint256 _maxMintAllowed) external onlyOwner {
2022         maxMintPresale = _maxMintAllowed;
2023     }
2024 
2025     /**
2026      * @notice Change the number of NFTs that an address can mint during whitelist
2027      *
2028      * @param _maxMintAllowed The number of NFTs that an address can mint
2029      **/
2030     function changeMaxMintWhitelist(uint256 _maxMintAllowed) external onlyOwner {
2031         maxMintWhitelist = _maxMintAllowed;
2032     }
2033 
2034     /**
2035      * @notice Change the number of NFTs that can be minted
2036      *
2037      * @param _maxSupply The number of NFT that can me minted
2038      **/
2039     function changeMaxSupply(uint256 _maxSupply) external onlyOwner {
2040         maxSupply = _maxSupply;
2041     }
2042 
2043     /**
2044      * @notice Change the price of one NFT for the presale and whitelist sale
2045      *
2046      * @param _pricePresale The new price of one NFT for the presale and whitelist sale
2047      **/
2048     function changePricePresale(uint256 _pricePresale) external onlyOwner {
2049         presalePrice = _pricePresale;
2050     }
2051 
2052     /**
2053      * @notice Change the price of one NFT for the presale and whitelist sale
2054      *
2055      * @param _whitelistPrice The new price of one NFT for the presale and whitelist sale
2056      **/
2057     function changePriceWhitelist(uint256 _whitelistPrice) external onlyOwner {
2058         whitelistPrice = _whitelistPrice;
2059     }
2060 
2061     /**
2062      * @notice Change the price of one NFT for the sale
2063      *
2064      * @param _priceSale The new price of one NFT for the sale
2065      **/
2066     function changePriceSale(uint256 _priceSale) external onlyOwner {
2067         salePrice = _priceSale;
2068     }
2069 
2070     /**
2071      * @notice Change the base URI
2072      *
2073      * @param _newBaseURI The new base URI
2074      **/
2075     function setBaseUri(string memory _newBaseURI) external onlyOwner {
2076         baseURI = _newBaseURI;
2077         emit ChangeBaseURI(_newBaseURI);
2078     }
2079 
2080     /**
2081      * @notice Change the not revealed URI
2082      *
2083      * @param _unrevealedURI The new not revealed URI
2084      **/
2085     function setNotRevealURI(string memory _unrevealedURI) external onlyOwner {
2086         unrevealedURI = _unrevealedURI;
2087     }
2088 
2089     /**
2090      * @notice Allows to set the revealed variable to true
2091      **/
2092     function reveal() external onlyOwner {
2093         revealed = true;
2094         emit Revealed(true);
2095     }
2096 
2097     /**
2098      * @notice Return URI of the NFTs when revealed
2099      *
2100      * @return The URI of the NFTs when revealed
2101      **/
2102     function _baseURI() internal view override returns (string memory) {
2103         return baseURI;
2104     }
2105 
2106     /**
2107      * @notice Allows to change the status to Presale
2108      **/
2109     function setupPresale() external onlyOwner {
2110         require(
2111             status == Status.Before,
2112             "The collection is not in the right status to set up presale"
2113         );
2114         status = Status.Presale;
2115         emit StatusChange(Status.Before, status);
2116     }
2117 
2118     /**
2119      * @notice Allows to change the status to Whitelist
2120      **/
2121     function setupWhitelistPresale() external onlyOwner {
2122         require(
2123             status == Status.Presale,
2124             "The collection is not in the right status to set up whitelist sale"
2125         );
2126         status = Status.WhitelistSale;
2127         emit StatusChange(Status.Presale, status);
2128     }
2129 
2130     /**
2131      * @notice Allows to change the status to Sale
2132      **/
2133     function setupSale() external onlyOwner {
2134         require(
2135             status == Status.WhitelistSale,
2136             "The collection is not in the right status to set up sale"
2137         );
2138         status = Status.Sale;
2139         emit StatusChange(Status.WhitelistSale, status);
2140     }
2141 
2142     /**
2143      * @notice Allows to mint NFTs
2144      *
2145      * @param _amount The amount of NFT to mint
2146      **/
2147     function presaleMint(uint256 _amount)
2148         external
2149         payable
2150         whenNotPaused
2151         nonReentrant
2152     {
2153         //Number of NFT sold
2154         uint256 supply = totalSupply();
2155         //If Sale didn't start yet
2156         require(status == Status.Presale, "Sorry, sale has not started yet.");
2157         //Has user paid enough Ethers
2158         require(msg.value >= presalePrice * _amount, "Insufficent funds.");
2159         //The user can only mint max 5 NFTs
2160         require(
2161             _amount <= maxMintPresale,
2162             "You can't mint more tokens"
2163         );
2164         require(nftsPerWalletPresale[msg.sender] <= maxMintPresale, "You cannot mint more tokens.");
2165         //If the user try to mint any non-existent token
2166         require(
2167             supply + _amount <= preSaleSupply,
2168             "Sale is almost done and we don't have enough NFTs left."
2169         );
2170         //Add the ammount of NFTs minted by the user to the total he minted
2171         nftsPerWalletPresale[msg.sender] += _amount;
2172         //Minting all the account NFTs
2173         for (uint256 i = 0; i < _amount; i++) {
2174             _safeMint(msg.sender, nftIdCounter.current());
2175             nftIdCounter.increment();
2176         }
2177     }
2178 
2179     /**
2180      * @notice Allows to mint one NFT if whitelisted for presale
2181      *
2182      * @param _amount amount of NFTs to mint
2183      **/
2184     function whitelistMint(uint256 _amount)
2185         external
2186         payable
2187         whenNotPaused
2188         nonReentrant
2189     {
2190         //Number of NFT sold
2191         uint256 supply = totalSupply();
2192         //If Sale didn't start yet
2193         require(status == Status.WhitelistSale, "Sorry, sale has not started yet.");
2194         //Has user paid enough Ethers
2195         require(msg.value >= whitelistPrice * _amount, "Insufficent funds.");
2196         //The user can only mint max 5 NFTs
2197         require(
2198             _amount <= maxMintWhitelist,
2199             "You can't mint more tokens"
2200         );
2201         //If the user try to mint any non-existent token
2202         require(
2203             supply + _amount <= whitelistSupply,
2204             "Sale is almost done and we don't have enough NFTs left."
2205         );
2206         //Add the ammount of NFTs minted by the user to the total he minted
2207         nftsPerWalletWhitelist[msg.sender] += _amount;
2208         //Minting all the account NFTs
2209         for (uint256 i = 0; i < _amount; i++) {
2210             _safeMint(msg.sender, nftIdCounter.current());
2211             //Increment the Id of the next NFT to mint
2212             nftIdCounter.increment();
2213         }
2214     }
2215 
2216     /**
2217      * @notice Allows to mint NFTs
2218      *
2219      * @param _amount The ammount of NFTs the user wants to mint
2220      **/
2221     function saleMint(uint256 _amount)
2222         external
2223         payable
2224         whenNotPaused
2225         nonReentrant
2226     {
2227         //Number of NFT sold
2228         uint256 supply = totalSupply();
2229         //If everything has been bought
2230         require(status != Status.SoldOut, "Sorry, no NFTs left.");
2231         //If Sale didn't start yet
2232         require(status == Status.Sale, "Sorry, sale has not started yet.");
2233         //Has user paid enough Ethers
2234         require(msg.value >= salePrice * _amount, "Insufficent funds.");
2235         //The user can only mint max 5 NFTs
2236         require(
2237             _amount <= maxMintQuantity,
2238             "You can't mint more tokens"
2239         );
2240         //If the user try to mint any non-existent token
2241         require(
2242             supply + _amount <= maxSupply,
2243             "Sale is almost done and we don't have enough NFTs left."
2244         );
2245         //Add the ammount of NFTs minted by the user to the total he minted
2246         nftsPerWallet[msg.sender] += _amount;
2247         //If this account minted the last NFTs available
2248         if (supply + _amount == maxSupply) {
2249             status = Status.SoldOut;
2250         }
2251         //Minting all the account NFTs
2252         for (uint256 i = 0; i < _amount; i++) {
2253             _safeMint(msg.sender, nftIdCounter.current());
2254             nftIdCounter.increment();
2255         }
2256     }
2257 
2258     /**
2259      * @notice Allows to gift one NFT to an address
2260      *
2261      * @param _account The account of the new owner of one NFT
2262      **/
2263     function gift(address _account) external onlyOwner {
2264         _safeMint(_account, nftIdCounter.current());
2265         nftIdCounter.increment();
2266     }
2267 
2268     /**
2269      * @notice Allows to get the complete URI of a specific NFT by his ID
2270      *
2271      * @param _nftId The id of the NFT
2272      *
2273      * @return The token URI of the NFT which has _nftId Id
2274      **/
2275     function tokenURI(uint256 _nftId)
2276         public
2277         view
2278         override(ERC721)
2279         returns (string memory)
2280     {
2281         require(_exists(_nftId), "This NFT doesn't exist.");
2282         if (revealed == false) {
2283             return unrevealedURI;
2284         }
2285 
2286         string memory currentBaseURI = _baseURI();
2287         return
2288             bytes(currentBaseURI).length > 0
2289                 ? string(
2290                     abi.encodePacked(currentBaseURI, _nftId.toString(), ".json")
2291                 )
2292                 : "";
2293     }
2294 
2295     // The following functions are overrides required by Solidity.
2296 
2297     function _beforeTokenTransfer(
2298         address from,
2299         address to,
2300         uint256 tokenId
2301     ) internal override(ERC721, ERC721Enumerable) whenNotPaused {
2302         super._beforeTokenTransfer(from, to, tokenId);
2303     }
2304 
2305     function supportsInterface(bytes4 interfaceId)
2306         public
2307         view
2308         override(ERC721, ERC721Enumerable)
2309         returns (bool)
2310     {
2311         return super.supportsInterface(interfaceId);
2312     }
2313 }