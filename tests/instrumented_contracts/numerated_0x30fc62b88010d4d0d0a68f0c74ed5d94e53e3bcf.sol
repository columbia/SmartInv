1 // Sources flattened with hardhat v2.9.5 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.6.0
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC20 standard as defined in the EIP.
12  */
13 interface IERC20 {
14     /**
15      * @dev Emitted when `value` tokens are moved from one account (`from`) to
16      * another (`to`).
17      *
18      * Note that `value` may be zero.
19      */
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     /**
23      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
24      * a call to {approve}. `value` is the new allowance.
25      */
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 
28     /**
29      * @dev Returns the amount of tokens in existence.
30      */
31     function totalSupply() external view returns (uint256);
32 
33     /**
34      * @dev Returns the amount of tokens owned by `account`.
35      */
36     function balanceOf(address account) external view returns (uint256);
37 
38     /**
39      * @dev Moves `amount` tokens from the caller's account to `to`.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a {Transfer} event.
44      */
45     function transfer(address to, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * IMPORTANT: Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67      *
68      * Emits an {Approval} event.
69      */
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Moves `amount` tokens from `from` to `to` using the
74      * allowance mechanism. `amount` is then deducted from the caller's
75      * allowance.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transferFrom(
82         address from,
83         address to,
84         uint256 amount
85     ) external returns (bool);
86 }
87 
88 
89 // File @openzeppelin/contracts/utils/Address.sol@v4.6.0
90 
91 
92 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
93 
94 
95 
96 /**
97  * @dev Collection of functions related to the address type
98  */
99 library Address {
100     /**
101      * @dev Returns true if `account` is a contract.
102      *
103      * [IMPORTANT]
104      * ====
105      * It is unsafe to assume that an address for which this function returns
106      * false is an externally-owned account (EOA) and not a contract.
107      *
108      * Among others, `isContract` will return false for the following
109      * types of addresses:
110      *
111      *  - an externally-owned account
112      *  - a contract in construction
113      *  - an address where a contract will be created
114      *  - an address where a contract lived, but was destroyed
115      * ====
116      *
117      * [IMPORTANT]
118      * ====
119      * You shouldn't rely on `isContract` to protect against flash loan attacks!
120      *
121      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
122      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
123      * constructor.
124      * ====
125      */
126     function isContract(address account) internal view returns (bool) {
127         // This method relies on extcodesize/address.code.length, which returns 0
128         // for contracts in construction, since the code is only stored at the end
129         // of the constructor execution.
130 
131         return account.code.length > 0;
132     }
133 
134     /**
135      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
136      * `recipient`, forwarding all available gas and reverting on errors.
137      *
138      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
139      * of certain opcodes, possibly making contracts go over the 2300 gas limit
140      * imposed by `transfer`, making them unable to receive funds via
141      * `transfer`. {sendValue} removes this limitation.
142      *
143      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
144      *
145      * IMPORTANT: because control is transferred to `recipient`, care must be
146      * taken to not create reentrancy vulnerabilities. Consider using
147      * {ReentrancyGuard} or the
148      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
149      */
150     function sendValue(address payable recipient, uint256 amount) internal {
151         require(address(this).balance >= amount, "Address: insufficient balance");
152 
153         (bool success, ) = recipient.call{value: amount}("");
154         require(success, "Address: unable to send value, recipient may have reverted");
155     }
156 
157     /**
158      * @dev Performs a Solidity function call using a low level `call`. A
159      * plain `call` is an unsafe replacement for a function call: use this
160      * function instead.
161      *
162      * If `target` reverts with a revert reason, it is bubbled up by this
163      * function (like regular Solidity function calls).
164      *
165      * Returns the raw returned data. To convert to the expected return value,
166      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
167      *
168      * Requirements:
169      *
170      * - `target` must be a contract.
171      * - calling `target` with `data` must not revert.
172      *
173      * _Available since v3.1._
174      */
175     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
176         return functionCall(target, data, "Address: low-level call failed");
177     }
178 
179     /**
180      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
181      * `errorMessage` as a fallback revert reason when `target` reverts.
182      *
183      * _Available since v3.1._
184      */
185     function functionCall(
186         address target,
187         bytes memory data,
188         string memory errorMessage
189     ) internal returns (bytes memory) {
190         return functionCallWithValue(target, data, 0, errorMessage);
191     }
192 
193     /**
194      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
195      * but also transferring `value` wei to `target`.
196      *
197      * Requirements:
198      *
199      * - the calling contract must have an ETH balance of at least `value`.
200      * - the called Solidity function must be `payable`.
201      *
202      * _Available since v3.1._
203      */
204     function functionCallWithValue(
205         address target,
206         bytes memory data,
207         uint256 value
208     ) internal returns (bytes memory) {
209         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
210     }
211 
212     /**
213      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
214      * with `errorMessage` as a fallback revert reason when `target` reverts.
215      *
216      * _Available since v3.1._
217      */
218     function functionCallWithValue(
219         address target,
220         bytes memory data,
221         uint256 value,
222         string memory errorMessage
223     ) internal returns (bytes memory) {
224         require(address(this).balance >= value, "Address: insufficient balance for call");
225         require(isContract(target), "Address: call to non-contract");
226 
227         (bool success, bytes memory returndata) = target.call{value: value}(data);
228         return verifyCallResult(success, returndata, errorMessage);
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
233      * but performing a static call.
234      *
235      * _Available since v3.3._
236      */
237     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
238         return functionStaticCall(target, data, "Address: low-level static call failed");
239     }
240 
241     /**
242      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
243      * but performing a static call.
244      *
245      * _Available since v3.3._
246      */
247     function functionStaticCall(
248         address target,
249         bytes memory data,
250         string memory errorMessage
251     ) internal view returns (bytes memory) {
252         require(isContract(target), "Address: static call to non-contract");
253 
254         (bool success, bytes memory returndata) = target.staticcall(data);
255         return verifyCallResult(success, returndata, errorMessage);
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
260      * but performing a delegate call.
261      *
262      * _Available since v3.4._
263      */
264     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
265         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
270      * but performing a delegate call.
271      *
272      * _Available since v3.4._
273      */
274     function functionDelegateCall(
275         address target,
276         bytes memory data,
277         string memory errorMessage
278     ) internal returns (bytes memory) {
279         require(isContract(target), "Address: delegate call to non-contract");
280 
281         (bool success, bytes memory returndata) = target.delegatecall(data);
282         return verifyCallResult(success, returndata, errorMessage);
283     }
284 
285     /**
286      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
287      * revert reason using the provided one.
288      *
289      * _Available since v4.3._
290      */
291     function verifyCallResult(
292         bool success,
293         bytes memory returndata,
294         string memory errorMessage
295     ) internal pure returns (bytes memory) {
296         if (success) {
297             return returndata;
298         } else {
299             // Look for revert reason and bubble it up if present
300             if (returndata.length > 0) {
301                 // The easiest way to bubble the revert reason is using memory via assembly
302 
303                 assembly {
304                     let returndata_size := mload(returndata)
305                     revert(add(32, returndata), returndata_size)
306                 }
307             } else {
308                 revert(errorMessage);
309             }
310         }
311     }
312 }
313 
314 
315 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.6.0
316 
317 
318 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
319 
320 
321 
322 
323 /**
324  * @title SafeERC20
325  * @dev Wrappers around ERC20 operations that throw on failure (when the token
326  * contract returns false). Tokens that return no value (and instead revert or
327  * throw on failure) are also supported, non-reverting calls are assumed to be
328  * successful.
329  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
330  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
331  */
332 library SafeERC20 {
333     using Address for address;
334 
335     function safeTransfer(
336         IERC20 token,
337         address to,
338         uint256 value
339     ) internal {
340         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
341     }
342 
343     function safeTransferFrom(
344         IERC20 token,
345         address from,
346         address to,
347         uint256 value
348     ) internal {
349         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
350     }
351 
352     /**
353      * @dev Deprecated. This function has issues similar to the ones found in
354      * {IERC20-approve}, and its usage is discouraged.
355      *
356      * Whenever possible, use {safeIncreaseAllowance} and
357      * {safeDecreaseAllowance} instead.
358      */
359     function safeApprove(
360         IERC20 token,
361         address spender,
362         uint256 value
363     ) internal {
364         // safeApprove should only be called when setting an initial allowance,
365         // or when resetting it to zero. To increase and decrease it, use
366         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
367         require(
368             (value == 0) || (token.allowance(address(this), spender) == 0),
369             "SafeERC20: approve from non-zero to non-zero allowance"
370         );
371         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
372     }
373 
374     function safeIncreaseAllowance(
375         IERC20 token,
376         address spender,
377         uint256 value
378     ) internal {
379         uint256 newAllowance = token.allowance(address(this), spender) + value;
380         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
381     }
382 
383     function safeDecreaseAllowance(
384         IERC20 token,
385         address spender,
386         uint256 value
387     ) internal {
388         unchecked {
389             uint256 oldAllowance = token.allowance(address(this), spender);
390             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
391             uint256 newAllowance = oldAllowance - value;
392             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
393         }
394     }
395 
396     /**
397      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
398      * on the return value: the return value is optional (but if data is returned, it must not be false).
399      * @param token The token targeted by the call.
400      * @param data The call data (encoded using abi.encode or one of its variants).
401      */
402     function _callOptionalReturn(IERC20 token, bytes memory data) private {
403         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
404         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
405         // the target address contains contract code and also asserts for success in the low-level call.
406 
407         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
408         if (returndata.length > 0) {
409             // Return data is optional
410             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
411         }
412     }
413 }
414 
415 
416 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.6.0
417 
418 
419 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
420 
421 
422 
423 /**
424  * @dev Contract module that helps prevent reentrant calls to a function.
425  *
426  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
427  * available, which can be applied to functions to make sure there are no nested
428  * (reentrant) calls to them.
429  *
430  * Note that because there is a single `nonReentrant` guard, functions marked as
431  * `nonReentrant` may not call one another. This can be worked around by making
432  * those functions `private`, and then adding `external` `nonReentrant` entry
433  * points to them.
434  *
435  * TIP: If you would like to learn more about reentrancy and alternative ways
436  * to protect against it, check out our blog post
437  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
438  */
439 abstract contract ReentrancyGuard {
440     // Booleans are more expensive than uint256 or any type that takes up a full
441     // word because each write operation emits an extra SLOAD to first read the
442     // slot's contents, replace the bits taken up by the boolean, and then write
443     // back. This is the compiler's defense against contract upgrades and
444     // pointer aliasing, and it cannot be disabled.
445 
446     // The values being non-zero value makes deployment a bit more expensive,
447     // but in exchange the refund on every call to nonReentrant will be lower in
448     // amount. Since refunds are capped to a percentage of the total
449     // transaction's gas, it is best to keep them low in cases like this one, to
450     // increase the likelihood of the full refund coming into effect.
451     uint256 private constant _NOT_ENTERED = 1;
452     uint256 private constant _ENTERED = 2;
453 
454     uint256 private _status;
455 
456     constructor() {
457         _status = _NOT_ENTERED;
458     }
459 
460     /**
461      * @dev Prevents a contract from calling itself, directly or indirectly.
462      * Calling a `nonReentrant` function from another `nonReentrant`
463      * function is not supported. It is possible to prevent this from happening
464      * by making the `nonReentrant` function external, and making it call a
465      * `private` function that does the actual work.
466      */
467     modifier nonReentrant() {
468         // On the first call to nonReentrant, _notEntered will be true
469         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
470 
471         // Any calls to nonReentrant after this point will fail
472         _status = _ENTERED;
473 
474         _;
475 
476         // By storing the original value once again, a refund is triggered (see
477         // https://eips.ethereum.org/EIPS/eip-2200)
478         _status = _NOT_ENTERED;
479     }
480 }
481 
482 
483 // File contracts/utils/TokenSwap.sol
484 
485 
486 
487 
488 
489 
490 contract TokenSwap is ReentrancyGuard {
491     using SafeERC20 for IERC20;
492     address public immutable inTokenAddress;
493     address public immutable outTokenAddress;
494     address public immutable outTokenWallet;
495     address public immutable burnAddress;
496     uint256 public immutable exchangeRatio;
497 
498     event TokenSwapped(address indexed account, uint256 inAmount, uint256 outAmount);
499 
500     constructor(
501         address _inTokenAddress,
502         address _outTokenAddress,
503         address _outTokenWallet,
504         address _burnAddress,
505         uint256 _exchangeRatio
506     ) public {
507         inTokenAddress = _inTokenAddress;
508         outTokenAddress = _outTokenAddress;
509         outTokenWallet = _outTokenWallet;
510         burnAddress = _burnAddress;
511         exchangeRatio = _exchangeRatio;
512     }
513 
514     // @dev swap inToken to outToken with respected exchangeRatio
515     function tokenSwap(uint256 inAmount) public nonReentrant() {
516         require(inAmount > 0, "TokenSwap: inAmount cannot be zero");
517 
518         // Transfer the inToken from the caller to the burn address
519         IERC20(inTokenAddress).safeTransferFrom(
520             address(msg.sender),
521             burnAddress,
522             inAmount
523         );
524 
525         // Calculate the amount to send to the caller
526         uint256 outAmount = inAmount * exchangeRatio / 1e18;
527 
528         // Transfer the outToken from the wallet to the caller
529         IERC20(outTokenAddress).safeTransferFrom(
530             outTokenWallet,
531             address(msg.sender),
532             outAmount
533         );
534 
535         // Emit an event
536         emit TokenSwapped(msg.sender, inAmount, outAmount);
537     }
538 
539 }