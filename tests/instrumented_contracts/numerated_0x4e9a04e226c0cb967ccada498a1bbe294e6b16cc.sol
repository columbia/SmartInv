1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 // ........................................................................................................................
6 // ........................................................................................................................
7 // ........................................................................................................................
8 // .......................................................   ..............................................................
9 // .................................................................   .........   ........................................
10 // ..............................................  ...............       ..................................................
11 // ...........................................        ..............   ....................................................
12 // ..............................................  .......................................  ...............................
13 // ..................................................(@@@@@@@@@@@@@@@@@@@@@@@@@@@@(....        ............................
14 // ................................................@@(         ,,,,,,,,,,/////////%@@.....  ...............................
15 // ................................................@@(       ,,,,,,,,,,,,,,///////%@@......................................
16 // ................................................@@@&&&&&&&//////////////%&&&&&&@@@......................................
17 // ..................................................(@@/////,,,,,,,,,,,,,,/////@@(........................................
18 // .....................................................@@#////*,,,,,,,,,////#@@,..........................................
19 // .......................................................%@@/////,,,,*////&@%.............................................
20 // ........................................,@@@@%...........,@@(/////////@@/...............................................
21 // ......................................(@@////#@@............&@@////%@@...........,@@@@%.................................
22 // ....................................@@%((##(((//@@(,,.........,@@@@(.........,,#@@##((#@@...............................
23 // ....................................@@%(#@@#((////%@@........................@@%(#@@#(#@@...............................
24 // ....................................@@%(#@@@@&((//#&&**,................,*/&&(/(#%@@#(#@@...............................
25 // ....................................@@%(#@@@@@%%/////@@(****************%&%((((&@@@@#(#@@...............................
26 // ....................................@@%(#@@@@@@@(((//%%%%%&&&&&%%&&&&&%%(/(##%%&@@&&%%%##...............................
27 // ....................................@@%(#@@@@@@@((//////////(((////(((((///((@@@@@((@@%.................................
28 // ....................................@@&##%%@@@@@//////////**(((((***//(((((((##%%%((@@%.................................
29 // ....................................@@%//((@@&##(((/////////***(((((((*******(((((((@@%.................................
30 // ....................................@@%((**///*******((////////****/((((/////****/@@**,.................................
31 // .................................*@@/****((((((((((((@@@@@@@(///////****&@@@@#((((@@,...................................
32 // .................................*@@((((/*******((%@@  %@@##@@&///////@@%#%@@@@%((//@@%.................................
33 // ...............................%@&((*****/////((@@(    %@@  &@@///////((. *@@. (@@//@@%.................................
34 // ...............................%@&**//////////((       %@@((@@@((//(((//((%@@.    //@@%.................................
35 // ...............................%@&////////////((((,    /((//@@@(((((((/////((     ////#@@...............................
36 // .............................@@#/////////((*,,,,((((((((((((((((((((((,,*//(((((((((//#@@...............................
37 // .............................@@#//////(((,,,,,,,,,/(((((((((,,,,,,,,,,,,,,*//((((((((((//@@#............................
38 // .............................@@%((((((/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,//((((((((((@@#............................
39 // .............................@@(******/((((*,,,,(((((,,,,,,,,,,,,@@@@@@@@@@@@,,*//((/////@@#............................
40 // ...............................%@&//((/,,,,,,,,,(((((,,,,,,,,,,,,%&@@@@@@@@&&,,*//(((((((@@#............................
41 // ...............................%@&****///((*,,,,,,,,,(((((,,,,,,,,,(&&@@&&#,,,,*//((//#@@...............................
42 // ...............................%@&((((/**,,,,,,,,,,,,,,/((((((((((((((&&#(/,,%&#((((((#@@...............................
43 // .............................@@#////((((((((((((,,,,,,,,,,&&&&&&&&&&&&&&&&&&&#((((((@@%.................................
44 // .............................@@#////(((((**//*,,,,,,,,,,,,,,,,*&&/*/((**#&#,,(((((//@@%.................................
45 // .............................@@%((//(((((**///**(((((((*,,,,,,*&&/*/((**#&%(((((((((@@%.................................
46 // ..........................(@@(((((//(((((**///(((((((,,,,,,,,,*%%///////#&%(((((////((#@@...............................
47 // ..........................(@@///////(((((**///**((/(((((((,,,,,,,%&&&&&&#((((/////((((#@@...............................
48 // ..........................(@@/////((((/**/////**/////,,,,,,,,,,,,,,,,,,,,,*((((((((((((//@@#............................
49 // ........................**#&&/////((((/**//***((((/////*,,**,,,,,,,,,,,,,**(((((((((/////&&#**..........................
50 // ........................@@%(((((((//**///**////////////***//,,,,,,,,,,,,/(((((((((//((///**#@@..........................
51 // ........................@@%/////////////*///(//////((**,,,,,,,,,,,,,,,,,**/(((((((//(((**//(%%##*.......................
52 // ........................@@%/////////**//////////(((//*****//,,,,,,,,,,,,//((((////((////////**@@/.......................
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
295 // File: @openzeppelin/contracts/access/Ownable.sol
296 
297 
298 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
299 
300 pragma solidity ^0.8.0;
301 
302 
303 /**
304  * @dev Contract module which provides a basic access control mechanism, where
305  * there is an account (an owner) that can be granted exclusive access to
306  * specific functions.
307  *
308  * By default, the owner account will be the one that deploys the contract. This
309  * can later be changed with {transferOwnership}.
310  *
311  * This module is used through inheritance. It will make available the modifier
312  * `onlyOwner`, which can be applied to your functions to restrict their use to
313  * the owner.
314  */
315 abstract contract Ownable is Context {
316     address private _owner;
317 
318     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
319 
320     /**
321      * @dev Initializes the contract setting the deployer as the initial owner.
322      */
323     constructor() {
324         _transferOwnership(_msgSender());
325     }
326 
327     /**
328      * @dev Returns the address of the current owner.
329      */
330     function owner() public view virtual returns (address) {
331         return _owner;
332     }
333 
334     /**
335      * @dev Throws if called by any account other than the owner.
336      */
337     modifier onlyOwner() {
338         require(owner() == _msgSender(), "Ownable: caller is not the owner");
339         _;
340     }
341 
342     /**
343      * @dev Leaves the contract without owner. It will not be possible to call
344      * `onlyOwner` functions anymore. Can only be called by the current owner.
345      *
346      * NOTE: Renouncing ownership will leave the contract without an owner,
347      * thereby removing any functionality that is only available to the owner.
348      */
349     function renounceOwnership() public virtual onlyOwner {
350         _transferOwnership(address(0));
351     }
352 
353     /**
354      * @dev Transfers ownership of the contract to a new account (`newOwner`).
355      * Can only be called by the current owner.
356      */
357     function transferOwnership(address newOwner) public virtual onlyOwner {
358         require(newOwner != address(0), "Ownable: new owner is the zero address");
359         _transferOwnership(newOwner);
360     }
361 
362     /**
363      * @dev Transfers ownership of the contract to a new account (`newOwner`).
364      * Internal function without access restriction.
365      */
366     function _transferOwnership(address newOwner) internal virtual {
367         address oldOwner = _owner;
368         _owner = newOwner;
369         emit OwnershipTransferred(oldOwner, newOwner);
370     }
371 }
372 
373 // File: @openzeppelin/contracts/utils/Address.sol
374 
375 
376 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
377 
378 pragma solidity ^0.8.1;
379 
380 /**
381  * @dev Collection of functions related to the address type
382  */
383 library Address {
384     /**
385      * @dev Returns true if `account` is a contract.
386      *
387      * [IMPORTANT]
388      * ====
389      * It is unsafe to assume that an address for which this function returns
390      * false is an externally-owned account (EOA) and not a contract.
391      *
392      * Among others, `isContract` will return false for the following
393      * types of addresses:
394      *
395      *  - an externally-owned account
396      *  - a contract in construction
397      *  - an address where a contract will be created
398      *  - an address where a contract lived, but was destroyed
399      * ====
400      *
401      * [IMPORTANT]
402      * ====
403      * You shouldn't rely on `isContract` to protect against flash loan attacks!
404      *
405      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
406      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
407      * constructor.
408      * ====
409      */
410     function isContract(address account) internal view returns (bool) {
411         // This method relies on extcodesize/address.code.length, which returns 0
412         // for contracts in construction, since the code is only stored at the end
413         // of the constructor execution.
414 
415         return account.code.length > 0;
416     }
417 
418     /**
419      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
420      * `recipient`, forwarding all available gas and reverting on errors.
421      *
422      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
423      * of certain opcodes, possibly making contracts go over the 2300 gas limit
424      * imposed by `transfer`, making them unable to receive funds via
425      * `transfer`. {sendValue} removes this limitation.
426      *
427      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
428      *
429      * IMPORTANT: because control is transferred to `recipient`, care must be
430      * taken to not create reentrancy vulnerabilities. Consider using
431      * {ReentrancyGuard} or the
432      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
433      */
434     function sendValue(address payable recipient, uint256 amount) internal {
435         require(address(this).balance >= amount, "Address: insufficient balance");
436 
437         (bool success, ) = recipient.call{value: amount}("");
438         require(success, "Address: unable to send value, recipient may have reverted");
439     }
440 
441     /**
442      * @dev Performs a Solidity function call using a low level `call`. A
443      * plain `call` is an unsafe replacement for a function call: use this
444      * function instead.
445      *
446      * If `target` reverts with a revert reason, it is bubbled up by this
447      * function (like regular Solidity function calls).
448      *
449      * Returns the raw returned data. To convert to the expected return value,
450      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
451      *
452      * Requirements:
453      *
454      * - `target` must be a contract.
455      * - calling `target` with `data` must not revert.
456      *
457      * _Available since v3.1._
458      */
459     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
460         return functionCall(target, data, "Address: low-level call failed");
461     }
462 
463     /**
464      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
465      * `errorMessage` as a fallback revert reason when `target` reverts.
466      *
467      * _Available since v3.1._
468      */
469     function functionCall(
470         address target,
471         bytes memory data,
472         string memory errorMessage
473     ) internal returns (bytes memory) {
474         return functionCallWithValue(target, data, 0, errorMessage);
475     }
476 
477     /**
478      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
479      * but also transferring `value` wei to `target`.
480      *
481      * Requirements:
482      *
483      * - the calling contract must have an ETH balance of at least `value`.
484      * - the called Solidity function must be `payable`.
485      *
486      * _Available since v3.1._
487      */
488     function functionCallWithValue(
489         address target,
490         bytes memory data,
491         uint256 value
492     ) internal returns (bytes memory) {
493         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
498      * with `errorMessage` as a fallback revert reason when `target` reverts.
499      *
500      * _Available since v3.1._
501      */
502     function functionCallWithValue(
503         address target,
504         bytes memory data,
505         uint256 value,
506         string memory errorMessage
507     ) internal returns (bytes memory) {
508         require(address(this).balance >= value, "Address: insufficient balance for call");
509         require(isContract(target), "Address: call to non-contract");
510 
511         (bool success, bytes memory returndata) = target.call{value: value}(data);
512         return verifyCallResult(success, returndata, errorMessage);
513     }
514 
515     /**
516      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
517      * but performing a static call.
518      *
519      * _Available since v3.3._
520      */
521     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
522         return functionStaticCall(target, data, "Address: low-level static call failed");
523     }
524 
525     /**
526      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
527      * but performing a static call.
528      *
529      * _Available since v3.3._
530      */
531     function functionStaticCall(
532         address target,
533         bytes memory data,
534         string memory errorMessage
535     ) internal view returns (bytes memory) {
536         require(isContract(target), "Address: static call to non-contract");
537 
538         (bool success, bytes memory returndata) = target.staticcall(data);
539         return verifyCallResult(success, returndata, errorMessage);
540     }
541 
542     /**
543      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
544      * but performing a delegate call.
545      *
546      * _Available since v3.4._
547      */
548     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
549         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
550     }
551 
552     /**
553      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
554      * but performing a delegate call.
555      *
556      * _Available since v3.4._
557      */
558     function functionDelegateCall(
559         address target,
560         bytes memory data,
561         string memory errorMessage
562     ) internal returns (bytes memory) {
563         require(isContract(target), "Address: delegate call to non-contract");
564 
565         (bool success, bytes memory returndata) = target.delegatecall(data);
566         return verifyCallResult(success, returndata, errorMessage);
567     }
568 
569     /**
570      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
571      * revert reason using the provided one.
572      *
573      * _Available since v4.3._
574      */
575     function verifyCallResult(
576         bool success,
577         bytes memory returndata,
578         string memory errorMessage
579     ) internal pure returns (bytes memory) {
580         if (success) {
581             return returndata;
582         } else {
583             // Look for revert reason and bubble it up if present
584             if (returndata.length > 0) {
585                 // The easiest way to bubble the revert reason is using memory via assembly
586 
587                 assembly {
588                     let returndata_size := mload(returndata)
589                     revert(add(32, returndata), returndata_size)
590                 }
591             } else {
592                 revert(errorMessage);
593             }
594         }
595     }
596 }
597 
598 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
599 
600 
601 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
602 
603 pragma solidity ^0.8.0;
604 
605 
606 
607 /**
608  * @title SafeERC20
609  * @dev Wrappers around ERC20 operations that throw on failure (when the token
610  * contract returns false). Tokens that return no value (and instead revert or
611  * throw on failure) are also supported, non-reverting calls are assumed to be
612  * successful.
613  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
614  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
615  */
616 library SafeERC20 {
617     using Address for address;
618 
619     function safeTransfer(
620         IERC20 token,
621         address to,
622         uint256 value
623     ) internal {
624         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
625     }
626 
627     function safeTransferFrom(
628         IERC20 token,
629         address from,
630         address to,
631         uint256 value
632     ) internal {
633         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
634     }
635 
636     /**
637      * @dev Deprecated. This function has issues similar to the ones found in
638      * {IERC20-approve}, and its usage is discouraged.
639      *
640      * Whenever possible, use {safeIncreaseAllowance} and
641      * {safeDecreaseAllowance} instead.
642      */
643     function safeApprove(
644         IERC20 token,
645         address spender,
646         uint256 value
647     ) internal {
648         // safeApprove should only be called when setting an initial allowance,
649         // or when resetting it to zero. To increase and decrease it, use
650         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
651         require(
652             (value == 0) || (token.allowance(address(this), spender) == 0),
653             "SafeERC20: approve from non-zero to non-zero allowance"
654         );
655         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
656     }
657 
658     function safeIncreaseAllowance(
659         IERC20 token,
660         address spender,
661         uint256 value
662     ) internal {
663         uint256 newAllowance = token.allowance(address(this), spender) + value;
664         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
665     }
666 
667     function safeDecreaseAllowance(
668         IERC20 token,
669         address spender,
670         uint256 value
671     ) internal {
672         unchecked {
673             uint256 oldAllowance = token.allowance(address(this), spender);
674             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
675             uint256 newAllowance = oldAllowance - value;
676             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
677         }
678     }
679 
680     /**
681      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
682      * on the return value: the return value is optional (but if data is returned, it must not be false).
683      * @param token The token targeted by the call.
684      * @param data The call data (encoded using abi.encode or one of its variants).
685      */
686     function _callOptionalReturn(IERC20 token, bytes memory data) private {
687         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
688         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
689         // the target address contains contract code and also asserts for success in the low-level call.
690 
691         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
692         if (returndata.length > 0) {
693             // Return data is optional
694             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
695         }
696     }
697 }
698 
699 
700 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
701 
702 
703 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
704 
705 pragma solidity ^0.8.0;
706 
707 /**
708  * @title ERC721 token receiver interface
709  * @dev Interface for any contract that wants to support safeTransfers
710  * from ERC721 asset contracts.
711  */
712 interface IERC721Receiver {
713     /**
714      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
715      * by `operator` from `from`, this function is called.
716      *
717      * It must return its Solidity selector to confirm the token transfer.
718      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
719      *
720      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
721      */
722     function onERC721Received(
723         address operator,
724         address from,
725         uint256 tokenId,
726         bytes calldata data
727     ) external returns (bytes4);
728 }
729 
730 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
731 
732 
733 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
734 
735 pragma solidity ^0.8.0;
736 
737 /**
738  * @dev Interface of the ERC165 standard, as defined in the
739  * https://eips.ethereum.org/EIPS/eip-165[EIP].
740  *
741  * Implementers can declare support of contract interfaces, which can then be
742  * queried by others ({ERC165Checker}).
743  *
744  * For an implementation, see {ERC165}.
745  */
746 interface IERC165 {
747     /**
748      * @dev Returns true if this contract implements the interface defined by
749      * `interfaceId`. See the corresponding
750      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
751      * to learn more about how these ids are created.
752      *
753      * This function call must use less than 30 000 gas.
754      */
755     function supportsInterface(bytes4 interfaceId) external view returns (bool);
756 }
757 
758 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
759 
760 
761 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
762 
763 pragma solidity ^0.8.0;
764 
765 
766 /**
767  * @dev Implementation of the {IERC165} interface.
768  *
769  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
770  * for the additional interface id that will be supported. For example:
771  *
772  * ```solidity
773  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
774  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
775  * }
776  * ```
777  *
778  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
779  */
780 abstract contract ERC165 is IERC165 {
781     /**
782      * @dev See {IERC165-supportsInterface}.
783      */
784     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
785         return interfaceId == type(IERC165).interfaceId;
786     }
787 }
788 
789 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
790 
791 
792 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
793 
794 pragma solidity ^0.8.0;
795 
796 
797 /**
798  * @dev Required interface of an ERC721 compliant contract.
799  */
800 interface IERC721 is IERC165 {
801     /**
802      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
803      */
804     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
805 
806     /**
807      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
808      */
809     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
810 
811     /**
812      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
813      */
814     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
815 
816     /**
817      * @dev Returns the number of tokens in ``owner``'s account.
818      */
819     function balanceOf(address owner) external view returns (uint256 balance);
820 
821     /**
822      * @dev Returns the owner of the `tokenId` token.
823      *
824      * Requirements:
825      *
826      * - `tokenId` must exist.
827      */
828     function ownerOf(uint256 tokenId) external view returns (address owner);
829 
830     /**
831      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
832      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
833      *
834      * Requirements:
835      *
836      * - `from` cannot be the zero address.
837      * - `to` cannot be the zero address.
838      * - `tokenId` token must exist and be owned by `from`.
839      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
840      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
841      *
842      * Emits a {Transfer} event.
843      */
844     function safeTransferFrom(
845         address from,
846         address to,
847         uint256 tokenId
848     ) external;
849 
850     /**
851      * @dev Transfers `tokenId` token from `from` to `to`.
852      *
853      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
854      *
855      * Requirements:
856      *
857      * - `from` cannot be the zero address.
858      * - `to` cannot be the zero address.
859      * - `tokenId` token must be owned by `from`.
860      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
861      *
862      * Emits a {Transfer} event.
863      */
864     function transferFrom(
865         address from,
866         address to,
867         uint256 tokenId
868     ) external;
869 
870     /**
871      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
872      * The approval is cleared when the token is transferred.
873      *
874      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
875      *
876      * Requirements:
877      *
878      * - The caller must own the token or be an approved operator.
879      * - `tokenId` must exist.
880      *
881      * Emits an {Approval} event.
882      */
883     function approve(address to, uint256 tokenId) external;
884 
885     /**
886      * @dev Returns the account approved for `tokenId` token.
887      *
888      * Requirements:
889      *
890      * - `tokenId` must exist.
891      */
892     function getApproved(uint256 tokenId) external view returns (address operator);
893 
894     /**
895      * @dev Approve or remove `operator` as an operator for the caller.
896      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
897      *
898      * Requirements:
899      *
900      * - The `operator` cannot be the caller.
901      *
902      * Emits an {ApprovalForAll} event.
903      */
904     function setApprovalForAll(address operator, bool _approved) external;
905 
906     /**
907      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
908      *
909      * See {setApprovalForAll}
910      */
911     function isApprovedForAll(address owner, address operator) external view returns (bool);
912 
913     /**
914      * @dev Safely transfers `tokenId` token from `from` to `to`.
915      *
916      * Requirements:
917      *
918      * - `from` cannot be the zero address.
919      * - `to` cannot be the zero address.
920      * - `tokenId` token must exist and be owned by `from`.
921      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
922      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
923      *
924      * Emits a {Transfer} event.
925      */
926     function safeTransferFrom(
927         address from,
928         address to,
929         uint256 tokenId,
930         bytes calldata data
931     ) external;
932 }
933 
934 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
935 
936 
937 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
938 
939 pragma solidity ^0.8.0;
940 
941 
942 /**
943  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
944  * @dev See https://eips.ethereum.org/EIPS/eip-721
945  */
946 interface IERC721Enumerable is IERC721 {
947     /**
948      * @dev Returns the total amount of tokens stored by the contract.
949      */
950     function totalSupply() external view returns (uint256);
951 
952     /**
953      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
954      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
955      */
956     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
957 
958     /**
959      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
960      * Use along with {totalSupply} to enumerate all tokens.
961      */
962     function tokenByIndex(uint256 index) external view returns (uint256);
963 }
964 
965 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
966 
967 
968 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
969 
970 pragma solidity ^0.8.0;
971 
972 
973 /**
974  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
975  * @dev See https://eips.ethereum.org/EIPS/eip-721
976  */
977 interface IERC721Metadata is IERC721 {
978     /**
979      * @dev Returns the token collection name.
980      */
981     function name() external view returns (string memory);
982 
983     /**
984      * @dev Returns the token collection symbol.
985      */
986     function symbol() external view returns (string memory);
987 
988     /**
989      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
990      */
991     function tokenURI(uint256 tokenId) external view returns (string memory);
992 }
993 
994 // File: contracts/TwistedToonz.sol
995 
996 
997 // Creator: Chiru Labs
998 
999 pragma solidity ^0.8.0;
1000 
1001 
1002 
1003 
1004 
1005 
1006 
1007 
1008 
1009 /**
1010  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1011  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1012  *
1013  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1014  *
1015  * Does not support burning tokens to address(0).
1016  *
1017  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
1018  */
1019 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1020     using Address for address;
1021     using Strings for uint256;
1022 
1023     struct TokenOwnership {
1024         address addr;
1025         uint64 startTimestamp;
1026     }
1027 
1028     struct AddressData {
1029         uint128 balance;
1030         uint128 numberMinted;
1031     }
1032 
1033     uint256 internal currentIndex;
1034 
1035     // Token name
1036     string private _name;
1037 
1038     // Token symbol
1039     string private _symbol;
1040 
1041     // Mapping from token ID to ownership details
1042     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1043     mapping(uint256 => TokenOwnership) internal _ownerships;
1044 
1045     // Mapping owner address to address data
1046     mapping(address => AddressData) private _addressData;
1047 
1048     // Mapping from token ID to approved address
1049     mapping(uint256 => address) private _tokenApprovals;
1050 
1051     // Mapping from owner to operator approvals
1052     mapping(address => mapping(address => bool)) private _operatorApprovals;
1053 
1054     constructor(string memory name_, string memory symbol_) {
1055         _name = name_;
1056         _symbol = symbol_;
1057     }
1058 
1059     /**
1060      * @dev See {IERC721Enumerable-totalSupply}.
1061      */
1062     function totalSupply() public view override returns (uint256) {
1063         return currentIndex;
1064     }
1065 
1066     /**
1067      * @dev See {IERC721Enumerable-tokenByIndex}.
1068      */
1069     function tokenByIndex(uint256 index) public view override returns (uint256) {
1070         require(index < totalSupply(), "ERC721A: global index out of bounds");
1071         return index;
1072     }
1073 
1074     /**
1075      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1076      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1077      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1078      */
1079     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1080         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1081         uint256 numMintedSoFar = totalSupply();
1082         uint256 tokenIdsIdx;
1083         address currOwnershipAddr;
1084 
1085         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1086         unchecked {
1087             for (uint256 i; i < numMintedSoFar; i++) {
1088                 TokenOwnership memory ownership = _ownerships[i];
1089                 if (ownership.addr != address(0)) {
1090                     currOwnershipAddr = ownership.addr;
1091                 }
1092                 if (currOwnershipAddr == owner) {
1093                     if (tokenIdsIdx == index) {
1094                         return i;
1095                     }
1096                     tokenIdsIdx++;
1097                 }
1098             }
1099         }
1100 
1101         revert("ERC721A: unable to get token of owner by index");
1102     }
1103 
1104     /**
1105      * @dev See {IERC165-supportsInterface}.
1106      */
1107     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1108         return
1109             interfaceId == type(IERC721).interfaceId ||
1110             interfaceId == type(IERC721Metadata).interfaceId ||
1111             interfaceId == type(IERC721Enumerable).interfaceId ||
1112             super.supportsInterface(interfaceId);
1113     }
1114 
1115     /**
1116      * @dev See {IERC721-balanceOf}.
1117      */
1118     function balanceOf(address owner) public view override returns (uint256) {
1119         require(owner != address(0), "ERC721A: balance query for the zero address");
1120         return uint256(_addressData[owner].balance);
1121     }
1122 
1123     function _numberMinted(address owner) internal view returns (uint256) {
1124         require(owner != address(0), "ERC721A: number minted query for the zero address");
1125         return uint256(_addressData[owner].numberMinted);
1126     }
1127 
1128     /**
1129      * Gas spent here starts off proportional to the maximum mint batch size.
1130      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1131      */
1132     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1133         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1134 
1135         unchecked {
1136             for (uint256 curr = tokenId; curr >= 0; curr--) {
1137                 TokenOwnership memory ownership = _ownerships[curr];
1138                 if (ownership.addr != address(0)) {
1139                     return ownership;
1140                 }
1141             }
1142         }
1143 
1144         revert("ERC721A: unable to determine the owner of token");
1145     }
1146 
1147     /**
1148      * @dev See {IERC721-ownerOf}.
1149      */
1150     function ownerOf(uint256 tokenId) public view override returns (address) {
1151         return ownershipOf(tokenId).addr;
1152     }
1153 
1154     /**
1155      * @dev See {IERC721Metadata-name}.
1156      */
1157     function name() public view virtual override returns (string memory) {
1158         return _name;
1159     }
1160 
1161     /**
1162      * @dev See {IERC721Metadata-symbol}.
1163      */
1164     function symbol() public view virtual override returns (string memory) {
1165         return _symbol;
1166     }
1167 
1168     /**
1169      * @dev See {IERC721Metadata-tokenURI}.
1170      */
1171     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1172         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1173 
1174         string memory baseURI = _baseURI();
1175         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1176     }
1177 
1178     /**
1179      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1180      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1181      * by default, can be overriden in child contracts.
1182      */
1183     function _baseURI() internal view virtual returns (string memory) {
1184         return "";
1185     }
1186 
1187     /**
1188      * @dev See {IERC721-approve}.
1189      */
1190     function approve(address to, uint256 tokenId) public override {
1191         address owner = ERC721A.ownerOf(tokenId);
1192         require(to != owner, "ERC721A: approval to current owner");
1193 
1194         require(
1195             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1196             "ERC721A: approve caller is not owner nor approved for all"
1197         );
1198 
1199         _approve(to, tokenId, owner);
1200     }
1201 
1202     /**
1203      * @dev See {IERC721-getApproved}.
1204      */
1205     function getApproved(uint256 tokenId) public view override returns (address) {
1206         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1207 
1208         return _tokenApprovals[tokenId];
1209     }
1210 
1211     /**
1212      * @dev See {IERC721-setApprovalForAll}.
1213      */
1214     function setApprovalForAll(address operator, bool approved) public override {
1215         require(operator != _msgSender(), "ERC721A: approve to caller");
1216 
1217         _operatorApprovals[_msgSender()][operator] = approved;
1218         emit ApprovalForAll(_msgSender(), operator, approved);
1219     }
1220 
1221     /**
1222      * @dev See {IERC721-isApprovedForAll}.
1223      */
1224     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1225         return _operatorApprovals[owner][operator];
1226     }
1227 
1228     /**
1229      * @dev See {IERC721-transferFrom}.
1230      */
1231     function transferFrom(
1232         address from,
1233         address to,
1234         uint256 tokenId
1235     ) public virtual override {
1236         _transfer(from, to, tokenId);
1237     }
1238 
1239     /**
1240      * @dev See {IERC721-safeTransferFrom}.
1241      */
1242     function safeTransferFrom(
1243         address from,
1244         address to,
1245         uint256 tokenId
1246     ) public virtual override {
1247         safeTransferFrom(from, to, tokenId, "");
1248     }
1249 
1250     /**
1251      * @dev See {IERC721-safeTransferFrom}.
1252      */
1253     function safeTransferFrom(
1254         address from,
1255         address to,
1256         uint256 tokenId,
1257         bytes memory _data
1258     ) public override {
1259         _transfer(from, to, tokenId);
1260         require(
1261             _checkOnERC721Received(from, to, tokenId, _data),
1262             "ERC721A: transfer to non ERC721Receiver implementer"
1263         );
1264     }
1265 
1266     /**
1267      * @dev Returns whether `tokenId` exists.
1268      *
1269      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1270      *
1271      * Tokens start existing when they are minted (`_mint`),
1272      */
1273     function _exists(uint256 tokenId) internal view returns (bool) {
1274         return tokenId < currentIndex;
1275     }
1276 
1277     function _safeMint(address to, uint256 quantity) internal {
1278         _safeMint(to, quantity, "");
1279     }
1280 
1281     /**
1282      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1283      *
1284      * Requirements:
1285      *
1286      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1287      * - `quantity` must be greater than 0.
1288      *
1289      * Emits a {Transfer} event.
1290      */
1291     function _safeMint(
1292         address to,
1293         uint256 quantity,
1294         bytes memory _data
1295     ) internal {
1296         _mint(to, quantity, _data, true);
1297     }
1298 
1299     /**
1300      * @dev Mints `quantity` tokens and transfers them to `to`.
1301      *
1302      * Requirements:
1303      *
1304      * - `to` cannot be the zero address.
1305      * - `quantity` must be greater than 0.
1306      *
1307      * Emits a {Transfer} event.
1308      */
1309     function _mint(
1310         address to,
1311         uint256 quantity,
1312         bytes memory _data,
1313         bool safe
1314     ) internal {
1315         uint256 startTokenId = currentIndex;
1316         require(to != address(0), "ERC721A: mint to the zero address");
1317         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1318 
1319         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1320 
1321         // Overflows are incredibly unrealistic.
1322         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1323         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1324         unchecked {
1325             _addressData[to].balance += uint128(quantity);
1326             _addressData[to].numberMinted += uint128(quantity);
1327 
1328             _ownerships[startTokenId].addr = to;
1329             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1330 
1331             uint256 updatedIndex = startTokenId;
1332 
1333             for (uint256 i; i < quantity; i++) {
1334                 emit Transfer(address(0), to, updatedIndex);
1335                 if (safe) {
1336                     require(
1337                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1338                         "ERC721A: transfer to non ERC721Receiver implementer"
1339                     );
1340                 }
1341 
1342                 updatedIndex++;
1343             }
1344 
1345             currentIndex = updatedIndex;
1346         }
1347 
1348         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1349     }
1350 
1351     /**
1352      * @dev Transfers `tokenId` from `from` to `to`.
1353      *
1354      * Requirements:
1355      *
1356      * - `to` cannot be the zero address.
1357      * - `tokenId` token must be owned by `from`.
1358      *
1359      * Emits a {Transfer} event.
1360      */
1361     function _transfer(
1362         address from,
1363         address to,
1364         uint256 tokenId
1365     ) private {
1366         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1367 
1368         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1369             getApproved(tokenId) == _msgSender() ||
1370             isApprovedForAll(prevOwnership.addr, _msgSender()));
1371 
1372         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1373 
1374         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1375         require(to != address(0), "ERC721A: transfer to the zero address");
1376 
1377         _beforeTokenTransfers(from, to, tokenId, 1);
1378 
1379         // Clear approvals from the previous owner
1380         _approve(address(0), tokenId, prevOwnership.addr);
1381 
1382         // Underflow of the sender's balance is impossible because we check for
1383         // ownership above and the recipient's balance can't realistically overflow.
1384         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1385         unchecked {
1386             _addressData[from].balance -= 1;
1387             _addressData[to].balance += 1;
1388 
1389             _ownerships[tokenId].addr = to;
1390             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1391 
1392             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1393             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1394             uint256 nextTokenId = tokenId + 1;
1395             if (_ownerships[nextTokenId].addr == address(0)) {
1396                 if (_exists(nextTokenId)) {
1397                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1398                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1399                 }
1400             }
1401         }
1402 
1403         emit Transfer(from, to, tokenId);
1404         _afterTokenTransfers(from, to, tokenId, 1);
1405     }
1406 
1407     /**
1408      * @dev Approve `to` to operate on `tokenId`
1409      *
1410      * Emits a {Approval} event.
1411      */
1412     function _approve(
1413         address to,
1414         uint256 tokenId,
1415         address owner
1416     ) private {
1417         _tokenApprovals[tokenId] = to;
1418         emit Approval(owner, to, tokenId);
1419     }
1420 
1421     /**
1422      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1423      * The call is not executed if the target address is not a contract.
1424      *
1425      * @param from address representing the previous owner of the given token ID
1426      * @param to target address that will receive the tokens
1427      * @param tokenId uint256 ID of the token to be transferred
1428      * @param _data bytes optional data to send along with the call
1429      * @return bool whether the call correctly returned the expected magic value
1430      */
1431     function _checkOnERC721Received(
1432         address from,
1433         address to,
1434         uint256 tokenId,
1435         bytes memory _data
1436     ) private returns (bool) {
1437         if (to.isContract()) {
1438             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1439                 return retval == IERC721Receiver(to).onERC721Received.selector;
1440             } catch (bytes memory reason) {
1441                 if (reason.length == 0) {
1442                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1443                 } else {
1444                     assembly {
1445                         revert(add(32, reason), mload(reason))
1446                     }
1447                 }
1448             }
1449         } else {
1450             return true;
1451         }
1452     }
1453 
1454     /**
1455      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1456      *
1457      * startTokenId - the first token id to be transferred
1458      * quantity - the amount to be transferred
1459      *
1460      * Calling conditions:
1461      *
1462      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1463      * transferred to `to`.
1464      * - When `from` is zero, `tokenId` will be minted for `to`.
1465      */
1466     function _beforeTokenTransfers(
1467         address from,
1468         address to,
1469         uint256 startTokenId,
1470         uint256 quantity
1471     ) internal virtual {}
1472 
1473     /**
1474      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1475      * minting.
1476      *
1477      * startTokenId - the first token id to be transferred
1478      * quantity - the amount to be transferred
1479      *
1480      * Calling conditions:
1481      *
1482      * - when `from` and `to` are both non-zero.
1483      * - `from` and `to` are never both zero.
1484      */
1485     function _afterTokenTransfers(
1486         address from,
1487         address to,
1488         uint256 startTokenId,
1489         uint256 quantity
1490     ) internal virtual {}
1491 }
1492 
1493 contract MutantMoonRunners is ERC721A, Ownable, ReentrancyGuard {
1494 
1495   string public        baseURI;
1496   uint public          totalFree         = 1000;
1497   uint public          maxSupply         = 5555;
1498   uint256 public       maxFreePerWallet  = 2;
1499   uint public          maxPerTx          = 20;
1500   uint public          price             = 0.005 ether;
1501   bool public          mintEnabled;
1502   mapping(address => uint256) private _mintedFreeAmount;
1503 
1504   constructor() ERC721A("Mutant MoonRunners", "MMOONR"){
1505   }
1506 
1507   function mint(uint256 amount) external payable
1508   {
1509     uint cost = price;
1510     
1511     bool isFree = ((totalSupply() + amount < totalFree + 1) &&
1512             (_mintedFreeAmount[msg.sender] + amount <= maxFreePerWallet));
1513 
1514     if(isFree) {
1515       cost = 0;
1516     }
1517     require(mintEnabled, "Minting is not live yet");
1518     require(totalSupply() + amount < maxSupply + 1,"No more supply");
1519     require(msg.value == amount * cost,"Please send the exact amount");
1520     require(amount < maxPerTx + 1, "Max per TX reached");
1521     
1522     if (isFree) {
1523             _mintedFreeAmount[msg.sender] += amount;
1524         }
1525 
1526     _safeMint(msg.sender, amount);
1527   }
1528 
1529   function ownerBatchMint(uint256 amount) external onlyOwner
1530   {
1531     require(totalSupply() + amount < maxSupply + 1,"too many!");
1532 
1533     _safeMint(msg.sender, amount);
1534   }
1535 
1536   function toggleMinting() external onlyOwner {
1537       mintEnabled = !mintEnabled;
1538   }
1539 
1540   function numberMinted(address owner) public view returns (uint256) {
1541     return _numberMinted(owner);
1542   }
1543 
1544   function setBaseURI(string calldata baseURI_) external onlyOwner {
1545     baseURI = baseURI_;
1546   }
1547 
1548   function setPrice(uint256 price_) external onlyOwner {
1549       price = price_;
1550   }
1551 
1552   function setTotalFree(uint256 totalFree_) external onlyOwner {
1553       totalFree = totalFree_;
1554   }
1555 
1556   function setMaxPerTx(uint256 maxPerTx_) external onlyOwner {
1557       maxPerTx = maxPerTx_;
1558   }
1559 
1560   function _baseURI() internal view virtual override returns (string memory) {
1561     return baseURI;
1562   }
1563 
1564   function withdraw() external onlyOwner nonReentrant {
1565     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1566     require(success, "Transfer failed.");
1567   }
1568 
1569 }