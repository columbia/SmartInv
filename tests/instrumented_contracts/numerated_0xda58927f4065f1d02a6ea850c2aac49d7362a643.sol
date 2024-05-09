1 ////////////////////////////////////////////////////////////////////////////////////////////////////////////
2 ////////////////////////////////////////////////////////////////////////////////////////////////////////////
3 ////////////////////////////////////////////////////////////////////////////////////////////////////////////
4 //////////////////////////////////////.////////////////////////////////.////////////////////////////////////
5 ///////////////////////////////////.@.//////////////////////////////////.@./////////////////////////////////
6 ////////////////////////////////.@@.//////////////////////////////////////.@@.//////////////////////////////
7 /////////////////////////////..@@@.////////////////////////////////////////.@@@..///////////////////////////
8 ///////////////////////////.@@@@@.//////////////////////////////////////////.@@@@@./////////////////////////
9 /////////////////////////.@@@@@@@////////////////////////////////////////////@@@@@@@.///////////////////////
10 ////////////////////////.@@@@@@@.////////////////////////////////////////////.@@@@@@@.//////////////////////
11 //////////////////..///.@@@@@@@@//////////////////////////////////////////////@@@@@@@@.///..////////////////
12 ////////////////.@@.//.@@@@@@@@@//////////////////////////////////////////////@@@@@@@@@.//.@@.//////////////
13 ///////////////@@@@.//@@@@@@@@@.//////////////////////////////////////////////.@@@@@@@@@//@@@@@/////////////
14 //////////////@@@@@@//@@@@@@@@@.//////////////////////////////////////////////.@@@@@@@@@//@@@@@@////////////
15 /////////////@@@@@@@./@@@@@@@@@@//////////////////////////////////////////////@@@@@@@@@./.@@@@@@@///////////
16 /////////////@@@@@@@@//@@@@@@@@@.////////////////////////////////////////////.@@@@@@@@@//@@@@@@@@///////////
17 /////////////@@@@@@@@.//.@@@@@@@@.//////////////////////////////////////////@@@@@@@@@.//.@@@@@@@@///////////
18 /////////////@@@@@@@@@///.@@@@@@@@@.////////.//////////////////////////////@@@@@@@@@.///@@@@@@@@@///////////
19 /////////////.@@@@@@@@@///..@@@@@@@.////////.@.///////////////////////////.@@@@@@@.////@@@@@@@@@.///////////
20 //////////////.@@@@@@@@@.////.@@@@///////////.@@.//////////////////////////.@@@@.////.@@@@@@@@@.////////////
21 //////////.////.@@@@@@@@@@./////./////////////.@@@@..////////////////////////./////.@@@@@@@@@@.///..////////
22 //////////@@.///.@@@@@@@@@@@.//////////////////.@@@@@@@@@@./////////////////////..@@@@@@@@@@.///.@@.////////
23 //////////@@@@.///.@@@@@@@@@@@@.////////////////.@@@@@@@@@@@..///////////////.@@@@@@@@@@@@@.//.@@@@.////////
24 //////////.@@@@@@.///.@@@@@@@@@@@.///////////////.@@@@@@@@@@@@./////////////.@@@@@@@@@@@.//.@@@@@@@.////////
25 //////////.@@@@@@@@.////.@@@@@@@@@.///////////////@@@@@@@@@...@////////////.@@@@@@@@@.//..@@@@@@@@@.////////
26 //////////.@@@@@@@@@@@..////..@@@@@@./////////////@@@@@@@@@ /////////////.@@@@@@..///..@@@@@@@@@@@./////////
27 ///////////.@@@@@@@@@@@@@@..//////.....///////////@@@@@@@@@.///////////...../////..@@@@@@@@@@@@@@@//////////
28 ////////////.@@@@@@@@@@@@@@@@@@....///////////////@@@@@@@@@.///////////////...@@@@@@@@@@@@@@@@@@@.//////////
29 /////////////.@@@@@@@@@@@@@@@@@@@@@@@@@@@..///////@@@@@@@@@@//////....@@@@@@@@@@@@@@@@@@@@@@@@@@.///////////
30 //////////////.@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.///.@@@@@@@@@@/////@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/////////////
31 ////////////////.@@@@@@@@@@@@@@@@@@@@@@@@@@@@@///@@@@@@@@@@@.///.@@@@@@@@@@@@@@@@@@@@@@@@@@@@.//////////////
32 //////////////////.@@@@@@@@@@@@@@@@@@@@@@@@@@@@/@@@@@@@@@@@@@./.@@@@@@@@@@@@@@@@@@@@@@@@@@@.////////////////
33 ////////////////////.@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@..//////////////////
34 //////////////////////..@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@./////////////////////
35 /////////////////////////..@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.////////////////////////
36 /////////////////////////////..@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@..///////////////////////////               
37 /////////////////////////////////..@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@..///////////////////////////////
38 //////////////////////////////////////...@@@@@@@@@@@@@@@@@@@@@@@@@@@@...////////////////////////////////////
39 //////////////////////////////////////////////...@@@@@@@@@@@@@@...//////////////////////////////////////////
40 //////////////////////////////////////////////////.@@@@@@@@@////////////////////////////////////////////////
41 ////////////////////////////////////////////////.@@@@@./@@@@@///////////////////////////////////////////////
42 ///////////////////////////////////////////////.@@@@@@///@@@@@./////////////////////////////////////////////
43 /////////////////////////////////////////////.@@@@@@@/.@./@@@@@@.///////////////////////////////////////////
44 ////////////////////////////////////////////@@@@@@@@/.@@@/.@@@@@@@./////////////////////////////////////////
45 ///////////////////////////////////////////.@@@@@@@//@@@@@//@@@@@@@.////////////////////////////////////////
46 ////////////////////////////////////////////.@@@@@./@@@@@@@/.@@@@@./////////////////////////////////////////
47 //////////////////////////////////////////////.@@./@@@@@@@@@/.@@.///////////////////////////////////////////
48 ///////////////////////////////////////////////../@@@@@@@@@@@/..////////////////////////////////////////////
49 /////////////////////////////////////////////////@@@@@@@@@@@@@//////////////////////////////////////////////
50 ////////////////////////////////////////////////@@@@@@@@@@@@@@@/////////////////////////////////////////////
51 ///////////////////////////////////////////////@@@@@@.///.@@@@@.////////////////////////////////////////////
52 //////////////////////////////////////////////.@@..//.@@..//..@@.///////////////////////////////////////////
53 /////////////////////////////////////////////..//////@@@@//////...//////////////////////////////////////////
54 ////////////////////////////////////////////////////////////////////////////////////////////////////////////
55 ////////////////////////////////////////////////////////////////////////////////////////////////////////////
56 /////////////_______///________//____////____//_______//______///////__///__////______////______////////////
57 /////////////@@_____|//@@@__@@@\/\@@@\  /@@@//|@@@____||@@@_  \/////|@@\ |@@|///  __  \//|@@@_@@\///////////
58 ////////////|@@|//__//|@@|  |@@|//\@@@\/@@@///|@@|__///|@@|_)  |////|@@@\|@@|/|@@|  |@@|/|@@|_)@@|//////////
59 ////////////|@@| |_@|/|@@|  |@@|///\@@@@@@////|@@@__|//|@@@@@@//////|@@.@`@@|/|@@|  |@@|/|@@@@@@////////////
60 ////////////|@@|__|@|/|@@`--'@@|////\@@@@/////|@@|____/|@@|\@@\----.|@@|\@@@|/|@@`--'@@|/|@@|\@@\----.//////
61 /////////////\______|//\______///////\__//////|_______|| _| `._____||__| \__|//\______///|@_| `._____|//////
62 ////////////////////////////////////////////////////////////////////////////////////////////////////////////
63 ////////////////////////////////////////////////////////////////////////////////////////////////////////////
64 ////////////////////////////////////////////////////////////////////////////////////////////////////////////
65 ////////////////////////////////////////////////////////////////////////////////////////////////////////////
66 
67 // SPDX-License-Identifier: MIT
68 // Author: Uni <3
69 // Intent: Rewards Loyalty Points to the LOYAL early adopters of Governor DAO.
70 // We Are One. We Are All.
71 
72 // File: browser/Address.sol
73 
74 pragma solidity >=0.6.2 <0.8.0;
75 
76 /**
77  * @dev Collection of functions related to the address type
78  */
79 library Address {
80     /**
81      * @dev Returns true if `account` is a contract.
82      *
83      * [IMPORTANT]
84      * ====
85      * It is unsafe to assume that an address for which this function returns
86      * false is an externally-owned account (EOA) and not a contract.
87      *
88      * Among others, `isContract` will return false for the following
89      * types of addresses:
90      *
91      *  - an externally-owned account
92      *  - a contract in construction
93      *  - an address where a contract will be created
94      *  - an address where a contract lived, but was destroyed
95      * ====
96      */
97     function isContract(address account) internal view returns (bool) {
98         // This method relies on extcodesize, which returns 0 for contracts in
99         // construction, since the code is only stored at the end of the
100         // constructor execution.
101 
102         uint256 size;
103         // solhint-disable-next-line no-inline-assembly
104         assembly { size := extcodesize(account) }
105         return size > 0;
106     }
107 
108     /**
109      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
110      * `recipient`, forwarding all available gas and reverting on errors.
111      *
112      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
113      * of certain opcodes, possibly making contracts go over the 2300 gas limit
114      * imposed by `transfer`, making them unable to receive funds via
115      * `transfer`. {sendValue} removes this limitation.
116      *
117      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
118      *
119      * IMPORTANT: because control is transferred to `recipient`, care must be
120      * taken to not create reentrancy vulnerabilities. Consider using
121      * {ReentrancyGuard} or the
122      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
123      */
124     function sendValue(address payable recipient, uint256 amount) internal {
125         require(address(this).balance >= amount, "Address: insufficient balance");
126 
127         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
128         (bool success, ) = recipient.call{ value: amount }("");
129         require(success, "Address: unable to send value, recipient may have reverted");
130     }
131 
132     /**
133      * @dev Performs a Solidity function call using a low level `call`. A
134      * plain`call` is an unsafe replacement for a function call: use this
135      * function instead.
136      *
137      * If `target` reverts with a revert reason, it is bubbled up by this
138      * function (like regular Solidity function calls).
139      *
140      * Returns the raw returned data. To convert to the expected return value,
141      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
142      *
143      * Requirements:
144      *
145      * - `target` must be a contract.
146      * - calling `target` with `data` must not revert.
147      *
148      * _Available since v3.1._
149      */
150     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
151       return functionCall(target, data, "Address: low-level call failed");
152     }
153 
154     /**
155      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
156      * `errorMessage` as a fallback revert reason when `target` reverts.
157      *
158      * _Available since v3.1._
159      */
160     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
161         return functionCallWithValue(target, data, 0, errorMessage);
162     }
163 
164     /**
165      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
166      * but also transferring `value` wei to `target`.
167      *
168      * Requirements:
169      *
170      * - the calling contract must have an ETH balance of at least `value`.
171      * - the called Solidity function must be `payable`.
172      *
173      * _Available since v3.1._
174      */
175     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
176         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
177     }
178 
179     /**
180      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
181      * with `errorMessage` as a fallback revert reason when `target` reverts.
182      *
183      * _Available since v3.1._
184      */
185     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
186         require(address(this).balance >= value, "Address: insufficient balance for call");
187         require(isContract(target), "Address: call to non-contract");
188 
189         // solhint-disable-next-line avoid-low-level-calls
190         (bool success, bytes memory returndata) = target.call{ value: value }(data);
191         return _verifyCallResult(success, returndata, errorMessage);
192     }
193 
194     /**
195      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
196      * but performing a static call.
197      *
198      * _Available since v3.3._
199      */
200     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
201         return functionStaticCall(target, data, "Address: low-level static call failed");
202     }
203 
204     /**
205      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
206      * but performing a static call.
207      *
208      * _Available since v3.3._
209      */
210     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
211         require(isContract(target), "Address: static call to non-contract");
212 
213         // solhint-disable-next-line avoid-low-level-calls
214         (bool success, bytes memory returndata) = target.staticcall(data);
215         return _verifyCallResult(success, returndata, errorMessage);
216     }
217 
218     /**
219      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
220      * but performing a delegate call.
221      *
222      * _Available since v3.3._
223      */
224     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
225         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
226     }
227 
228     /**
229      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
230      * but performing a delegate call.
231      *
232      * _Available since v3.3._
233      */
234     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
235         require(isContract(target), "Address: delegate call to non-contract");
236 
237         // solhint-disable-next-line avoid-low-level-calls
238         (bool success, bytes memory returndata) = target.delegatecall(data);
239         return _verifyCallResult(success, returndata, errorMessage);
240     }
241 
242     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
243         if (success) {
244             return returndata;
245         } else {
246             // Look for revert reason and bubble it up if present
247             if (returndata.length > 0) {
248                 // The easiest way to bubble the revert reason is using memory via assembly
249 
250                 // solhint-disable-next-line no-inline-assembly
251                 assembly {
252                     let returndata_size := mload(returndata)
253                     revert(add(32, returndata), returndata_size)
254                 }
255             } else {
256                 revert(errorMessage);
257             }
258         }
259     }
260 }
261 
262 // File: browser/SafeERC20.sol
263 
264 pragma solidity >=0.6.0 <0.8.0;
265 
266 
267 
268 
269 /**
270  * @title SafeERC20
271  * @dev Wrappers around ERC20 operations that throw on failure (when the token
272  * contract returns false). Tokens that return no value (and instead revert or
273  * throw on failure) are also supported, non-reverting calls are assumed to be
274  * successful.
275  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
276  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
277  */
278 library SafeERC20 {
279     using SafeMath for uint256;
280     using Address for address;
281 
282     function safeTransfer(IERC20 token, address to, uint256 value) internal {
283         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
284     }
285 
286     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
287         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
288     }
289 
290     /**
291      * @dev Deprecated. This function has issues similar to the ones found in
292      * {IERC20-approve}, and its usage is discouraged.
293      *
294      * Whenever possible, use {safeIncreaseAllowance} and
295      * {safeDecreaseAllowance} instead.
296      */
297     function safeApprove(IERC20 token, address spender, uint256 value) internal {
298         // safeApprove should only be called when setting an initial allowance,
299         // or when resetting it to zero. To increase and decrease it, use
300         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
301         // solhint-disable-next-line max-line-length
302         require((value == 0) || (token.allowance(address(this), spender) == 0),
303             "SafeERC20: approve from non-zero to non-zero allowance"
304         );
305         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
306     }
307 
308     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
309         uint256 newAllowance = token.allowance(address(this), spender).add(value);
310         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
311     }
312 
313     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
314         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
315         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
316     }
317 
318     /**
319      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
320      * on the return value: the return value is optional (but if data is returned, it must not be false).
321      * @param token The token targeted by the call.
322      * @param data The call data (encoded using abi.encode or one of its variants).
323      */
324     function _callOptionalReturn(IERC20 token, bytes memory data) private {
325         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
326         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
327         // the target address contains contract code and also asserts for success in the low-level call.
328 
329         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
330         if (returndata.length > 0) { // Return data is optional
331             // solhint-disable-next-line max-line-length
332             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
333         }
334     }
335 }
336 
337 // File: browser/ReentrancyGuard.sol
338 
339 pragma solidity >=0.6.0 <0.8.0;
340 
341 /**
342  * @dev Contract module that helps prevent reentrant calls to a function.
343  *
344  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
345  * available, which can be applied to functions to make sure there are no nested
346  * (reentrant) calls to them.
347  *
348  * Note that because there is a single `nonReentrant` guard, functions marked as
349  * `nonReentrant` may not call one another. This can be worked around by making
350  * those functions `private`, and then adding `external` `nonReentrant` entry
351  * points to them.
352  *
353  * TIP: If you would like to learn more about reentrancy and alternative ways
354  * to protect against it, check out our blog post
355  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
356  */
357 abstract contract ReentrancyGuard {
358     // Booleans are more expensive than uint256 or any type that takes up a full
359     // word because each write operation emits an extra SLOAD to first read the
360     // slot's contents, replace the bits taken up by the boolean, and then write
361     // back. This is the compiler's defense against contract upgrades and
362     // pointer aliasing, and it cannot be disabled.
363 
364     // The values being non-zero value makes deployment a bit more expensive,
365     // but in exchange the refund on every call to nonReentrant will be lower in
366     // amount. Since refunds are capped to a percentage of the total
367     // transaction's gas, it is best to keep them low in cases like this one, to
368     // increase the likelihood of the full refund coming into effect.
369     uint256 private constant _NOT_ENTERED = 1;
370     uint256 private constant _ENTERED = 2;
371 
372     uint256 private _status;
373 
374     constructor () {
375         _status = _NOT_ENTERED;
376     }
377 
378     /**
379      * @dev Prevents a contract from calling itself, directly or indirectly.
380      * Calling a `nonReentrant` function from another `nonReentrant`
381      * function is not supported. It is possible to prevent this from happening
382      * by making the `nonReentrant` function external, and make it call a
383      * `private` function that does the actual work.
384      */
385     modifier nonReentrant() {
386         // On the first call to nonReentrant, _notEntered will be true
387         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
388 
389         // Any calls to nonReentrant after this point will fail
390         _status = _ENTERED;
391 
392         _;
393 
394         // By storing the original value once again, a refund is triggered (see
395         // https://eips.ethereum.org/EIPS/eip-2200)
396         _status = _NOT_ENTERED;
397     }
398 }
399 // File: browser/Context.sol
400 
401 pragma solidity >=0.6.0 <0.8.0;
402 
403 /*
404  * @dev Provides information about the current execution context, including the
405  * sender of the transaction and its data. While these are generally available
406  * via msg.sender and msg.data, they should not be accessed in such a direct
407  * manner, since when dealing with GSN meta-transactions the account sending and
408  * paying for execution may not be the actual sender (as far as an application
409  * is concerned).
410  *
411  * This contract is only required for intermediate, library-like contracts.
412  */
413 abstract contract Context {
414     function _msgSender() internal view virtual returns (address payable) {
415         return msg.sender;
416     }
417 
418     function _msgData() internal view virtual returns (bytes memory) {
419         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
420         return msg.data;
421     }
422 }
423 
424 // File: browser/Ownable.sol
425 
426 pragma solidity >=0.6.0 <0.8.0;
427 
428 /**
429  * @dev Contract module which provides a basic access control mechanism, where
430  * there is an account (an owner) that can be granted exclusive access to
431  * specific functions.
432  *
433  * By default, the owner account will be the one that deploys the contract. This
434  * can later be changed with {transferOwnership}.
435  *
436  * This module is used through inheritance. It will make available the modifier
437  * `onlyOwner`, which can be applied to your functions to restrict their use to
438  * the owner.
439  */
440 abstract contract Ownable is Context {
441     address private _owner;
442 
443     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
444 
445     /**
446      * @dev Initializes the contract setting the deployer as the initial owner.
447      */
448     constructor () {
449         address msgSender = _msgSender();
450         _owner = msgSender;
451         emit OwnershipTransferred(address(0), msgSender);
452     }
453 
454     /**
455      * @dev Returns the address of the current owner.
456      */
457     function owner() public view returns (address) {
458         return _owner;
459     }
460 
461     /**
462      * @dev Throws if called by any account other than the owner.
463      */
464     modifier onlyOwner() {
465         require(_owner == _msgSender(), "Ownable: caller is not the owner");
466         _;
467     }
468 
469     /**
470      * @dev Leaves the contract without owner. It will not be possible to call
471      * `onlyOwner` functions anymore. Can only be called by the current owner.
472      *
473      * NOTE: Renouncing ownership will leave the contract without an owner,
474      * thereby removing any functionality that is only available to the owner.
475      */
476     function renounceOwnership() public virtual onlyOwner {
477         emit OwnershipTransferred(_owner, address(0));
478         _owner = address(0);
479     }
480 
481     /**
482      * @dev Transfers ownership of the contract to a new account (`newOwner`).
483      * Can only be called by the current owner.
484      */
485     function transferOwnership(address newOwner) public virtual onlyOwner {
486         require(newOwner != address(0), "Ownable: new owner is the zero address");
487         emit OwnershipTransferred(_owner, newOwner);
488         _owner = newOwner;
489     }
490 }
491 // File: browser/Pausable.sol
492 
493 pragma solidity >=0.6.0 <0.8.0;
494 
495 
496 /**
497  * @dev Contract module which allows children to implement an emergency stop
498  * mechanism that can be triggered by an authorized account.
499  *
500  * This module is used through inheritance. It will make available the
501  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
502  * the functions of your contract. Note that they will not be pausable by
503  * simply including this module, only once the modifiers are put in place.
504  */
505 abstract contract Pausable is Context {
506     /**
507      * @dev Emitted when the pause is triggered by `account`.
508      */
509     event Paused(address account);
510 
511     /**
512      * @dev Emitted when the pause is lifted by `account`.
513      */
514     event Unpaused(address account);
515 
516     bool private _paused;
517 
518     /**
519      * @dev Initializes the contract in unpaused state.
520      */
521     constructor () {
522         _paused = false;
523     }
524 
525     /**
526      * @dev Returns true if the contract is paused, and false otherwise.
527      */
528     function paused() public view returns (bool) {
529         return _paused;
530     }
531 
532     /**
533      * @dev Modifier to make a function callable only when the contract is not paused.
534      *
535      * Requirements:
536      *
537      * - The contract must not be paused.
538      */
539     modifier whenNotPaused() {
540         require(!_paused, "Pausable: paused");
541         _;
542     }
543 
544     /**
545      * @dev Modifier to make a function callable only when the contract is paused.
546      *
547      * Requirements:
548      *
549      * - The contract must be paused.
550      */
551     modifier whenPaused() {
552         require(_paused, "Pausable: not paused");
553         _;
554     }
555 
556     /**
557      * @dev Triggers stopped state.
558      *
559      * Requirements:
560      *
561      * - The contract must not be paused.
562      */
563     function _pause() internal virtual whenNotPaused {
564         _paused = true;
565         emit Paused(_msgSender());
566     }
567 
568     /**
569      * @dev Returns to normal state.
570      *
571      * Requirements:
572      *
573      * - The contract must be paused.
574      */
575     function _unpause() internal virtual whenPaused {
576         _paused = false;
577         emit Unpaused(_msgSender());
578     }
579 }
580 
581 // File: browser/IERC20.sol
582 
583 pragma solidity >=0.6.0 <0.8.0;
584 
585 /**
586  * @dev Interface of the ERC20 standard as defined in the EIP.
587  */
588 interface IERC20 {
589     /**
590      * @dev Returns the amount of tokens in existence.
591      */
592     function totalSupply() external view returns (uint256);
593 
594     /**
595      * @dev Returns the amount of tokens owned by `account`.
596      */
597     function balanceOf(address account) external view returns (uint256);
598 
599     /**
600      * @dev Moves `amount` tokens from the caller's account to `recipient`.
601      *
602      * Returns a boolean value indicating whether the operation succeeded.
603      *
604      * Emits a {Transfer} event.
605      */
606     function transfer(address recipient, uint256 amount) external returns (bool);
607 
608     /**
609      * @dev Returns the remaining number of tokens that `spender` will be
610      * allowed to spend on behalf of `owner` through {transferFrom}. This is
611      * zero by default.
612      *
613      * This value changes when {approve} or {transferFrom} are called.
614      */
615     function allowance(address owner, address spender) external view returns (uint256);
616 
617     /**
618      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
619      *
620      * Returns a boolean value indicating whether the operation succeeded.
621      *
622      * IMPORTANT: Beware that changing an allowance with this method brings the risk
623      * that someone may use both the old and the new allowance by unfortunate
624      * transaction ordering. One possible solution to mitigate this race
625      * condition is to first reduce the spender's allowance to 0 and set the
626      * desired value afterwards:
627      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
628      *
629      * Emits an {Approval} event.
630      */
631     function approve(address spender, uint256 amount) external returns (bool);
632 
633     /**
634      * @dev Moves `amount` tokens from `sender` to `recipient` using the
635      * allowance mechanism. `amount` is then deducted from the caller's
636      * allowance.
637      *
638      * Returns a boolean value indicating whether the operation succeeded.
639      *
640      * Emits a {Transfer} event.
641      */
642     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
643 
644     /**
645      * @dev Emitted when `value` tokens are moved from one account (`from`) to
646      * another (`to`).
647      *
648      * Note that `value` may be zero.
649      */
650     event Transfer(address indexed from, address indexed to, uint256 value);
651 
652     /**
653      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
654      * a call to {approve}. `value` is the new allowance.
655      */
656     event Approval(address indexed owner, address indexed spender, uint256 value);
657 }
658 
659 // File: browser/IStakedRewardsPool.sol
660 
661 pragma solidity ^0.7.0;
662 
663 
664 interface IStakedRewardsPool {
665 	/* Views */
666 
667 	function balanceOf(address account) external view returns (uint256);
668 
669 	function earned(address account) external view returns (uint256);
670 
671 	function rewardsToken() external view returns (IERC20);
672 
673 	function stakingToken() external view returns (IERC20);
674 
675 	function stakingTokenDecimals() external view returns (uint8);
676 
677 	function totalSupply() external view returns (uint256);
678 
679 	/* Mutators */
680 
681 	function exit() external;
682 
683 	function getReward() external;
684 
685 	function getRewardExact(uint256 amount) external;
686 
687 	function pause() external;
688 
689 	function recoverUnsupportedERC20(
690 		IERC20 token,
691 		address to,
692 		uint256 amount
693 	) external;
694 
695 	function stake(uint256 amount) external;
696 
697 	function unpause() external;
698 
699 	function updateReward() external;
700 
701 	function updateRewardFor(address account) external;
702 
703 	function withdraw(uint256 amount) external;
704 
705 	/* Events */
706 
707 	event RewardPaid(address indexed account, uint256 amount);
708 	event Staked(address indexed account, uint256 amount);
709 	event Withdrawn(address indexed account, uint256 amount);
710 	event Recovered(IERC20 token, address indexed to, uint256 amount);
711 }
712 
713 // File: browser/IStakedRewardsPoolTimedRate.sol
714 
715 pragma solidity ^0.7.0;
716 
717 
718 interface IStakedRewardsPoolTimedRate is IStakedRewardsPool {
719 	/* Views */
720 
721 	function accruedRewardPerToken() external view returns (uint256);
722 
723 	function hasEnded() external view returns (bool);
724 
725 	function hasStarted() external view returns (bool);
726 
727 	function lastTimeRewardApplicable() external view returns (uint256);
728 
729 	function periodDuration() external view returns (uint256);
730 
731 	function periodEndTime() external view returns (uint256);
732 
733 	function periodStartTime() external view returns (uint256);
734 
735 	function rewardRate() external view returns (uint256);
736 
737 	function timeRemainingInPeriod() external view returns (uint256);
738 
739 	/* Mutators */
740 
741 	function addToRewardsAllocation(uint256 amount) external;
742 
743 	function setNewPeriod(uint256 startTime, uint256 endTime) external;
744 
745 	/* Events */
746 
747 	event RewardAdded(uint256 amount);
748 	event NewPeriodSet(uint256 startTIme, uint256 endTime);
749 }
750 
751 // File: browser/SafeMath.sol
752 
753 pragma solidity >=0.6.0 <0.8.0;
754 
755 /**
756  * @dev Wrappers over Solidity's arithmetic operations with added overflow
757  * checks.
758  *
759  * Arithmetic operations in Solidity wrap on overflow. This can easily result
760  * in bugs, because programmers usually assume that an overflow raises an
761  * error, which is the standard behavior in high level programming languages.
762  * `SafeMath` restores this intuition by reverting the transaction when an
763  * operation overflows.
764  *
765  * Using this library instead of the unchecked operations eliminates an entire
766  * class of bugs, so it's recommended to use it always.
767  */
768 library SafeMath {
769     /**
770      * @dev Returns the addition of two unsigned integers, with an overflow flag.
771      */
772     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
773         uint256 c = a + b;
774         if (c < a) return (false, 0);
775         return (true, c);
776     }
777 
778     /**
779      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
780      */
781     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
782         if (b > a) return (false, 0);
783         return (true, a - b);
784     }
785 
786     /**
787      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
788      */
789     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
790         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
791         // benefit is lost if 'b' is also tested.
792         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
793         if (a == 0) return (true, 0);
794         uint256 c = a * b;
795         if (c / a != b) return (false, 0);
796         return (true, c);
797     }
798 
799     /**
800      * @dev Returns the division of two unsigned integers, with a division by zero flag.
801      */
802     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
803         if (b == 0) return (false, 0);
804         return (true, a / b);
805     }
806 
807     /**
808      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
809      */
810     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
811         if (b == 0) return (false, 0);
812         return (true, a % b);
813     }
814 
815     /**
816      * @dev Returns the addition of two unsigned integers, reverting on
817      * overflow.
818      *
819      * Counterpart to Solidity's `+` operator.
820      *
821      * Requirements:
822      *
823      * - Addition cannot overflow.
824      */
825     function add(uint256 a, uint256 b) internal pure returns (uint256) {
826         uint256 c = a + b;
827         require(c >= a, "SafeMath: addition overflow");
828         return c;
829     }
830 
831     /**
832      * @dev Returns the subtraction of two unsigned integers, reverting on
833      * overflow (when the result is negative).
834      *
835      * Counterpart to Solidity's `-` operator.
836      *
837      * Requirements:
838      *
839      * - Subtraction cannot overflow.
840      */
841     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
842         require(b <= a, "SafeMath: subtraction overflow");
843         return a - b;
844     }
845 
846     /**
847      * @dev Returns the multiplication of two unsigned integers, reverting on
848      * overflow.
849      *
850      * Counterpart to Solidity's `*` operator.
851      *
852      * Requirements:
853      *
854      * - Multiplication cannot overflow.
855      */
856     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
857         if (a == 0) return 0;
858         uint256 c = a * b;
859         require(c / a == b, "SafeMath: multiplication overflow");
860         return c;
861     }
862 
863     /**
864      * @dev Returns the integer division of two unsigned integers, reverting on
865      * division by zero. The result is rounded towards zero.
866      *
867      * Counterpart to Solidity's `/` operator. Note: this function uses a
868      * `revert` opcode (which leaves remaining gas untouched) while Solidity
869      * uses an invalid opcode to revert (consuming all remaining gas).
870      *
871      * Requirements:
872      *
873      * - The divisor cannot be zero.
874      */
875     function div(uint256 a, uint256 b) internal pure returns (uint256) {
876         require(b > 0, "SafeMath: division by zero");
877         return a / b;
878     }
879 
880     /**
881      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
882      * reverting when dividing by zero.
883      *
884      * Counterpart to Solidity's `%` operator. This function uses a `revert`
885      * opcode (which leaves remaining gas untouched) while Solidity uses an
886      * invalid opcode to revert (consuming all remaining gas).
887      *
888      * Requirements:
889      *
890      * - The divisor cannot be zero.
891      */
892     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
893         require(b > 0, "SafeMath: modulo by zero");
894         return a % b;
895     }
896 
897     /**
898      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
899      * overflow (when the result is negative).
900      *
901      * CAUTION: This function is deprecated because it requires allocating memory for the error
902      * message unnecessarily. For custom revert reasons use {trySub}.
903      *
904      * Counterpart to Solidity's `-` operator.
905      *
906      * Requirements:
907      *
908      * - Subtraction cannot overflow.
909      */
910     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
911         require(b <= a, errorMessage);
912         return a - b;
913     }
914 
915     /**
916      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
917      * division by zero. The result is rounded towards zero.
918      *
919      * CAUTION: This function is deprecated because it requires allocating memory for the error
920      * message unnecessarily. For custom revert reasons use {tryDiv}.
921      *
922      * Counterpart to Solidity's `/` operator. Note: this function uses a
923      * `revert` opcode (which leaves remaining gas untouched) while Solidity
924      * uses an invalid opcode to revert (consuming all remaining gas).
925      *
926      * Requirements:
927      *
928      * - The divisor cannot be zero.
929      */
930     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
931         require(b > 0, errorMessage);
932         return a / b;
933     }
934 
935     /**
936      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
937      * reverting with custom message when dividing by zero.
938      *
939      * CAUTION: This function is deprecated because it requires allocating memory for the error
940      * message unnecessarily. For custom revert reasons use {tryMod}.
941      *
942      * Counterpart to Solidity's `%` operator. This function uses a `revert`
943      * opcode (which leaves remaining gas untouched) while Solidity uses an
944      * invalid opcode to revert (consuming all remaining gas).
945      *
946      * Requirements:
947      *
948      * - The divisor cannot be zero.
949      */
950     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
951         require(b > 0, errorMessage);
952         return a % b;
953     }
954 }
955 
956 // File: browser/Math.sol
957 
958 pragma solidity >=0.6.0 <0.8.0;
959 
960 /**
961  * @dev Standard math utilities missing in the Solidity language.
962  */
963 library Math {
964     /**
965      * @dev Returns the largest of two numbers.
966      */
967     function max(uint256 a, uint256 b) internal pure returns (uint256) {
968         return a >= b ? a : b;
969     }
970 
971     /**
972      * @dev Returns the smallest of two numbers.
973      */
974     function min(uint256 a, uint256 b) internal pure returns (uint256) {
975         return a < b ? a : b;
976     }
977 
978     /**
979      * @dev Returns the average of two numbers. The result is rounded towards
980      * zero.
981      */
982     function average(uint256 a, uint256 b) internal pure returns (uint256) {
983         // (a + b) / 2 can overflow, so we distribute
984         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
985     }
986 }
987 
988 // File: browser/StakedRewardsPool.sol
989 
990 pragma solidity ^0.7.0;
991 
992 abstract contract StakedRewardsPool is Context,	ReentrancyGuard, Ownable, Pausable, IStakedRewardsPool {
993 	using SafeERC20 for IERC20;
994 	using SafeMath for uint256;
995 
996 	mapping(address => uint256) internal _rewards;
997 
998 	uint8 private _stakingTokenDecimals;
999 	IERC20 private _rewardsToken;
1000 	IERC20 private _stakingToken;
1001 	uint256 private _stakingTokenBase;
1002 
1003 	mapping(address => uint256) private _balances;
1004 	uint256 private _totalSupply;
1005 
1006 	constructor(IERC20 rewardsToken_, IERC20 stakingToken_, uint8 stakingTokenDecimals_) Ownable() {
1007 		// Prevent overflow, though 76 would create a safe but unusable contract
1008 		require(stakingTokenDecimals_ < 77, 'SR Pool: 76 decimals limit');
1009 		_rewardsToken = rewardsToken_;
1010 		_stakingToken = stakingToken_;
1011 		_stakingTokenDecimals = stakingTokenDecimals_;
1012 		_stakingTokenBase = 10**stakingTokenDecimals_;
1013 	}
1014 
1015 
1016 	/* Public Views */
1017 
1018 	function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
1019 
1020 	function earned(address account) public view virtual override returns (uint256);
1021 
1022 	function rewardsToken() public view override returns (IERC20) {	return _rewardsToken; }
1023 
1024 	function stakingToken() public view override returns (IERC20) {	return _stakingToken; }
1025 
1026 	function stakingTokenDecimals() public view override returns (uint8) { return _stakingTokenDecimals; }
1027 
1028 	function totalSupply() public view override returns (uint256) { return _totalSupply; }
1029 
1030 	/* Public Mutators */
1031 
1032 	function exit() public override nonReentrant { _exit();	}
1033 
1034 	function getReward() public override nonReentrant {	_getReward(); }
1035 
1036 	function getRewardExact(uint256 amount) public override nonReentrant { _getRewardExact(amount);	}
1037 
1038 	function pause() public override onlyOwner { _pause(); }
1039 
1040 	function recoverUnsupportedERC20(IERC20 token, address to, uint256 amount) public override onlyOwner { _recoverUnsupportedERC20(token, to, amount); }
1041 
1042 	function stake(uint256 amount) public override nonReentrant whenNotPaused {	_stakeFrom(_msgSender(), amount); }
1043 
1044 	function unpause() public override onlyOwner { _unpause(); }
1045 
1046 	function updateReward() public override nonReentrant { _updateRewardFor(_msgSender()); }
1047 
1048 	function updateRewardFor(address account) public override nonReentrant { _updateRewardFor(account); }
1049 
1050 	function withdraw(uint256 amount) public override nonReentrant { _withdraw(amount); }
1051 
1052 	function _getStakingTokenBase() internal view returns (uint256) { return _stakingTokenBase; }
1053 
1054 	/* Internal Mutators */
1055 
1056 	function _exit() internal virtual {
1057 		_withdraw(_balances[_msgSender()]);
1058 		_getReward();
1059 	}
1060 
1061 	function _getReward() internal virtual {
1062 		_updateRewardFor(_msgSender());
1063 		uint256 reward = _rewards[_msgSender()];
1064 		if (reward > 0) {
1065 			_rewards[_msgSender()] = 0;
1066 			_rewardsToken.safeTransfer(_msgSender(), reward); // consider transfer
1067 		
1068 			emit RewardPaid(_msgSender(), reward);
1069 		}
1070 	}
1071 
1072 	function _getRewardExact(uint256 amount) internal virtual {
1073 		_updateRewardFor(_msgSender());
1074 		uint256 reward = _rewards[_msgSender()];
1075 		require(amount <= reward, 'SR Pool: cannot redeem more rewards than earned');
1076 		
1077 		_rewards[_msgSender()] = reward.sub(amount);
1078 		_rewardsToken.safeTransfer(_msgSender(), amount); // consider transfer
1079 		
1080 		emit RewardPaid(_msgSender(), amount);
1081 	}
1082 
1083 	function _recoverUnsupportedERC20(IERC20 token, address to,	uint256 amount) internal virtual {
1084 		require(token != _stakingToken, 'StakedRewardsPool: cannot withdraw the staking token');
1085 		require(token != _rewardsToken, 'StakedRewardsPool: cannot withdraw the rewards token');
1086 		
1087 		token.safeTransfer(to, amount);
1088 		
1089 		emit Recovered(token, to, amount);
1090 	}
1091 
1092 	function _stakeFrom(address account, uint256 amount) internal virtual {
1093 		require(account != address(0), 'SR Pool: cannot stake from the zero address');
1094 		require(amount > 0, 'SR Pool: cannot stake zero');
1095 		
1096 		_updateRewardFor(account);
1097 		
1098 		_totalSupply = _totalSupply.add(amount);
1099 		_balances[account] = _balances[account].add(amount);
1100 		_stakingToken.safeTransferFrom(account, address(this), amount);
1101 		
1102 		emit Staked(account, amount);
1103 	}
1104 
1105 	function _updateRewardFor(address account) internal virtual;
1106 
1107 	function _withdraw(uint256 amount) internal virtual {
1108 		require(amount > 0, 'StakedRewardsPool: cannot withdraw zero');
1109 		
1110 		_updateRewardFor(_msgSender());
1111 		
1112 		_totalSupply = _totalSupply.sub(amount);
1113 		_balances[_msgSender()] = _balances[_msgSender()].sub(amount);
1114 		_stakingToken.safeTransfer(_msgSender(), amount);
1115 		_getReward();
1116 		
1117 		emit Withdrawn(_msgSender(), amount);
1118 	}
1119 }
1120 
1121 // File: browser/LoyaltyMine.sol
1122 
1123 pragma solidity ^0.7.0;
1124 
1125 // Accuracy in block.timestamp is not needed.
1126 // https://consensys.github.io/smart-contract-best-practices/recommendations/#the-15-second-rule
1127 /* solhint-disable not-rely-on-time */
1128 
1129 contract LoyaltyMine is StakedRewardsPool, IStakedRewardsPoolTimedRate {
1130 	using SafeMath for uint256;
1131 
1132 	uint256 private _accruedRewardPerToken;
1133 	mapping(address => uint256) private _accruedRewardPerTokenPaid;
1134 	uint256 private _lastUpdateTime;
1135 	uint256 private _periodEndTime;
1136 	uint256 private _periodStartTime;
1137 	uint256 private _rewardRate;
1138 
1139 	modifier whenStarted {
1140 		require(hasStarted(), 'SRPTR: current rewards distribution period has not yet begun');
1141 		_;
1142 	}
1143 
1144 	constructor(IERC20 rewardsToken, IERC20 stakingToken, uint8 stakingTokenDecimals, uint256 periodStartTime_, uint256 periodEndTime_)
1145 	StakedRewardsPool(rewardsToken, stakingToken, stakingTokenDecimals) {
1146 		_periodStartTime = periodStartTime_;
1147 		_periodEndTime = periodEndTime_;
1148 	}
1149 
1150 	// Represents the ratio of reward token to staking token accrued thus far
1151 	// multiplied by 10**stakingTokenDecimal (in event of a fraction).
1152 	function accruedRewardPerToken() public view override returns (uint256) {
1153 		uint256 totalSupply = totalSupply();
1154 		if (totalSupply == 0) {
1155 			return _accruedRewardPerToken;
1156 		}
1157 
1158 		uint256 lastUpdateTime = _lastUpdateTime;
1159 		uint256 lastTimeApplicable = lastTimeRewardApplicable();
1160 
1161 		// Allow staking at any time without earning undue rewards.
1162 		// The following is guaranteed if the next `if` is true:
1163 		// lastUpdateTime == previous _periodEndTime || lastUpdateTime == 0
1164 		if (_periodStartTime > lastUpdateTime) {
1165 			// Prevent underflow
1166 			if (_periodStartTime > lastTimeApplicable) {
1167 				return _accruedRewardPerToken;
1168 			}
1169 			lastUpdateTime = _periodStartTime;
1170 		}
1171 
1172 		uint256 dt = lastTimeApplicable.sub(lastUpdateTime);
1173 
1174 		if (dt == 0) {
1175 			return _accruedRewardPerToken;
1176 		}
1177 
1178 		uint256 accruedReward = _rewardRate.mul(dt);
1179 		return _accruedRewardPerToken.add(accruedReward.mul(_getStakingTokenBase()).div(totalSupply));
1180 	}
1181 
1182 	function earned(address account) public view override(IStakedRewardsPool, StakedRewardsPool) returns (uint256) {
1183 		// Divide by stakingTokenBase in accordance with accruedRewardPerToken()
1184 		return
1185 			balanceOf(account)
1186 				.mul(accruedRewardPerToken().sub(_accruedRewardPerTokenPaid[account]))
1187 				.div(_getStakingTokenBase())
1188 				.add(_rewards[account]);
1189 	}
1190 
1191 	function hasStarted() public view override returns (bool) {	return block.timestamp >= _periodStartTime; }
1192 
1193 	function hasEnded() public view override returns (bool) { return block.timestamp >= _periodEndTime;	}
1194 
1195 	function lastTimeRewardApplicable() public view override returns (uint256) {
1196 		// Returns 0 if we have never run a staking period, else most recent historical endTime.
1197 		if (!hasStarted()) {
1198 			return _lastUpdateTime;
1199 		}
1200 		return Math.min(block.timestamp, _periodEndTime);
1201 	}
1202 
1203 	function periodDuration() public view override returns (uint256) { return _periodEndTime.sub(_periodStartTime);	}
1204 
1205 	function periodEndTime() public view override returns (uint256) { return _periodEndTime; }
1206 
1207 	function periodStartTime() public view override returns (uint256) { return _periodStartTime; }
1208 
1209 	function rewardRate() public view override returns (uint256) { return _rewardRate; }
1210 
1211 	function timeRemainingInPeriod() public view override whenStarted returns (uint256)	{
1212 		if (hasEnded()) {
1213 			return 0;
1214 		}
1215 
1216 		return _periodEndTime.sub(block.timestamp);
1217 	}
1218 
1219 	/* Public Mutators */
1220 
1221 	function addToRewardsAllocation(uint256 amount)	public override nonReentrant onlyOwner {
1222 		_addToRewardsAllocation(amount);
1223 	}
1224 
1225 	function setNewPeriod(uint256 startTime, uint256 endTime) public override onlyOwner {
1226 		require(!hasStarted() || hasEnded(), 'SRPTR: cannot change an ongoing staking period');
1227 		require(endTime > startTime, 'SRPTR: ends before the fun begins');
1228 		// The lastTimeRewardApplicable() function would not allow rewards for a past period that was never initiated.
1229 		require(startTime > block.timestamp, 'SRPTR: startTime must be greater than the current block time');
1230 		// Ensure rewards are fully granted before changing the period.
1231 		_updateAccrual();
1232 
1233 		if (hasEnded()) {
1234 			// Reset reward rate if this a **new** period (not changing one)
1235 			// Note: you MUST addToRewardsAllocation again if you forgot to call
1236 			// this after the previous period ended but before adding rewards.
1237 			_rewardRate = 0;
1238 		} else {
1239 			// Update reward rate for new duration.
1240 			uint256 totalReward = _rewardRate.mul(periodDuration());
1241 			_rewardRate = totalReward.div(endTime.sub(startTime));
1242 		}
1243 
1244 		_periodStartTime = startTime;
1245 		_periodEndTime = endTime;
1246 
1247 		emit NewPeriodSet(startTime, endTime);
1248 	}
1249 
1250 	/* Internal Mutators */
1251 
1252 	// Ensure that the amount param is equal to the amount you've added to the contract, otherwise the funds will run out before _periodEndTime.
1253 	// If called during an ongoing staking period, then the amount will be allocated to the current staking period, otherwise the next period.
1254 	function _addToRewardsAllocation(uint256 amount) internal {
1255 		// TODO Require that amount <= available rewards (see below)
1256 		_updateAccrual();
1257 
1258 		// Update reward rate based on remaining time.
1259 		uint256 remainingTime;
1260 		if (!hasStarted() || hasEnded()) {
1261 			remainingTime = periodDuration();
1262 		} else {
1263 			remainingTime = timeRemainingInPeriod();
1264 		}
1265 
1266 		_rewardRate = _rewardRate.add(amount.div(remainingTime));
1267 
1268 		emit RewardAdded(amount);
1269 	}
1270 
1271 	function _updateAccrual() internal {
1272 		_accruedRewardPerToken = accruedRewardPerToken();
1273 		_lastUpdateTime = lastTimeRewardApplicable();
1274 	}
1275 
1276 	// This logic is needed for any interaction that may manipulate rewards.
1277 	function _updateRewardFor(address account) internal override {
1278 		_updateAccrual();
1279 		// Allocate accrued rewards.
1280 		_rewards[account] = earned(account);
1281 		// Remove ability to earn rewards on or before the current timestamp.
1282 		_accruedRewardPerTokenPaid[account] = _accruedRewardPerToken;
1283 	}
1284 }