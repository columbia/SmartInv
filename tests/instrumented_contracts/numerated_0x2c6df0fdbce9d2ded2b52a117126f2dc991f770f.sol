1 // Sources flattened with hardhat v2.12.0 https://hardhat.org
2 
3 // File contracts/multicall.sol
4 
5 //  SPDX-License-Identifier: BUSL-1.1
6 pragma solidity 0.8.4;
7 
8 /// @title Multicall
9 /// @notice Enables calling multiple methods in a single call to the contract
10 abstract contract Multicall {
11     function multicall(bytes[] calldata data) external payable returns (bytes[] memory results) {
12         results = new bytes[](data.length);
13         for (uint256 i = 0; i < data.length; i++) {
14             (bool success, bytes memory result) = address(this).delegatecall(data[i]);
15 
16             if (!success) {
17                 // Next 5 lines from https://ethereum.stackexchange.com/a/83577
18                 if (result.length < 68) revert();
19                 assembly {
20                     result := add(result, 0x04)
21                 }
22                 revert(abi.decode(result, (string)));
23             }
24 
25             results[i] = result;
26         }
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.7.3
32 
33 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev Interface of the ERC20 standard as defined in the EIP.
39  */
40 interface IERC20 {
41     /**
42      * @dev Emitted when `value` tokens are moved from one account (`from`) to
43      * another (`to`).
44      *
45      * Note that `value` may be zero.
46      */
47     event Transfer(address indexed from, address indexed to, uint256 value);
48 
49     /**
50      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
51      * a call to {approve}. `value` is the new allowance.
52      */
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54 
55     /**
56      * @dev Returns the amount of tokens in existence.
57      */
58     function totalSupply() external view returns (uint256);
59 
60     /**
61      * @dev Returns the amount of tokens owned by `account`.
62      */
63     function balanceOf(address account) external view returns (uint256);
64 
65     /**
66      * @dev Moves `amount` tokens from the caller's account to `to`.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * Emits a {Transfer} event.
71      */
72     function transfer(address to, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Returns the remaining number of tokens that `spender` will be
76      * allowed to spend on behalf of `owner` through {transferFrom}. This is
77      * zero by default.
78      *
79      * This value changes when {approve} or {transferFrom} are called.
80      */
81     function allowance(address owner, address spender) external view returns (uint256);
82 
83     /**
84      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * IMPORTANT: Beware that changing an allowance with this method brings the risk
89      * that someone may use both the old and the new allowance by unfortunate
90      * transaction ordering. One possible solution to mitigate this race
91      * condition is to first reduce the spender's allowance to 0 and set the
92      * desired value afterwards:
93      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
94      *
95      * Emits an {Approval} event.
96      */
97     function approve(address spender, uint256 amount) external returns (bool);
98 
99     /**
100      * @dev Moves `amount` tokens from `from` to `to` using the
101      * allowance mechanism. `amount` is then deducted from the caller's
102      * allowance.
103      *
104      * Returns a boolean value indicating whether the operation succeeded.
105      *
106      * Emits a {Transfer} event.
107      */
108     function transferFrom(
109         address from,
110         address to,
111         uint256 amount
112     ) external returns (bool);
113 }
114 
115 
116 // File @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol@v4.7.3
117 
118 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
119 
120 pragma solidity ^0.8.0;
121 
122 /**
123  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
124  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
125  *
126  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
127  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
128  * need to send a transaction, and thus is not required to hold Ether at all.
129  */
130 interface IERC20Permit {
131     /**
132      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
133      * given ``owner``'s signed approval.
134      *
135      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
136      * ordering also apply here.
137      *
138      * Emits an {Approval} event.
139      *
140      * Requirements:
141      *
142      * - `spender` cannot be the zero address.
143      * - `deadline` must be a timestamp in the future.
144      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
145      * over the EIP712-formatted function arguments.
146      * - the signature must use ``owner``'s current nonce (see {nonces}).
147      *
148      * For more information on the signature format, see the
149      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
150      * section].
151      */
152     function permit(
153         address owner,
154         address spender,
155         uint256 value,
156         uint256 deadline,
157         uint8 v,
158         bytes32 r,
159         bytes32 s
160     ) external;
161 
162     /**
163      * @dev Returns the current nonce for `owner`. This value must be
164      * included whenever a signature is generated for {permit}.
165      *
166      * Every successful call to {permit} increases ``owner``'s nonce by one. This
167      * prevents a signature from being used multiple times.
168      */
169     function nonces(address owner) external view returns (uint256);
170 
171     /**
172      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
173      */
174     // solhint-disable-next-line func-name-mixedcase
175     function DOMAIN_SEPARATOR() external view returns (bytes32);
176 }
177 
178 
179 // File @openzeppelin/contracts/utils/Address.sol@v4.7.3
180 
181 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
182 
183 pragma solidity ^0.8.1;
184 
185 /**
186  * @dev Collection of functions related to the address type
187  */
188 library Address {
189     /**
190      * @dev Returns true if `account` is a contract.
191      *
192      * [IMPORTANT]
193      * ====
194      * It is unsafe to assume that an address for which this function returns
195      * false is an externally-owned account (EOA) and not a contract.
196      *
197      * Among others, `isContract` will return false for the following
198      * types of addresses:
199      *
200      *  - an externally-owned account
201      *  - a contract in construction
202      *  - an address where a contract will be created
203      *  - an address where a contract lived, but was destroyed
204      * ====
205      *
206      * [IMPORTANT]
207      * ====
208      * You shouldn't rely on `isContract` to protect against flash loan attacks!
209      *
210      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
211      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
212      * constructor.
213      * ====
214      */
215     function isContract(address account) internal view returns (bool) {
216         // This method relies on extcodesize/address.code.length, which returns 0
217         // for contracts in construction, since the code is only stored at the end
218         // of the constructor execution.
219 
220         return account.code.length > 0;
221     }
222 
223     /**
224      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
225      * `recipient`, forwarding all available gas and reverting on errors.
226      *
227      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
228      * of certain opcodes, possibly making contracts go over the 2300 gas limit
229      * imposed by `transfer`, making them unable to receive funds via
230      * `transfer`. {sendValue} removes this limitation.
231      *
232      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
233      *
234      * IMPORTANT: because control is transferred to `recipient`, care must be
235      * taken to not create reentrancy vulnerabilities. Consider using
236      * {ReentrancyGuard} or the
237      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
238      */
239     function sendValue(address payable recipient, uint256 amount) internal {
240         require(address(this).balance >= amount, "Address: insufficient balance");
241 
242         (bool success, ) = recipient.call{value: amount}("");
243         require(success, "Address: unable to send value, recipient may have reverted");
244     }
245 
246     /**
247      * @dev Performs a Solidity function call using a low level `call`. A
248      * plain `call` is an unsafe replacement for a function call: use this
249      * function instead.
250      *
251      * If `target` reverts with a revert reason, it is bubbled up by this
252      * function (like regular Solidity function calls).
253      *
254      * Returns the raw returned data. To convert to the expected return value,
255      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
256      *
257      * Requirements:
258      *
259      * - `target` must be a contract.
260      * - calling `target` with `data` must not revert.
261      *
262      * _Available since v3.1._
263      */
264     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
265         return functionCall(target, data, "Address: low-level call failed");
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
270      * `errorMessage` as a fallback revert reason when `target` reverts.
271      *
272      * _Available since v3.1._
273      */
274     function functionCall(
275         address target,
276         bytes memory data,
277         string memory errorMessage
278     ) internal returns (bytes memory) {
279         return functionCallWithValue(target, data, 0, errorMessage);
280     }
281 
282     /**
283      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
284      * but also transferring `value` wei to `target`.
285      *
286      * Requirements:
287      *
288      * - the calling contract must have an ETH balance of at least `value`.
289      * - the called Solidity function must be `payable`.
290      *
291      * _Available since v3.1._
292      */
293     function functionCallWithValue(
294         address target,
295         bytes memory data,
296         uint256 value
297     ) internal returns (bytes memory) {
298         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
303      * with `errorMessage` as a fallback revert reason when `target` reverts.
304      *
305      * _Available since v3.1._
306      */
307     function functionCallWithValue(
308         address target,
309         bytes memory data,
310         uint256 value,
311         string memory errorMessage
312     ) internal returns (bytes memory) {
313         require(address(this).balance >= value, "Address: insufficient balance for call");
314         require(isContract(target), "Address: call to non-contract");
315 
316         (bool success, bytes memory returndata) = target.call{value: value}(data);
317         return verifyCallResult(success, returndata, errorMessage);
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
322      * but performing a static call.
323      *
324      * _Available since v3.3._
325      */
326     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
327         return functionStaticCall(target, data, "Address: low-level static call failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
332      * but performing a static call.
333      *
334      * _Available since v3.3._
335      */
336     function functionStaticCall(
337         address target,
338         bytes memory data,
339         string memory errorMessage
340     ) internal view returns (bytes memory) {
341         require(isContract(target), "Address: static call to non-contract");
342 
343         (bool success, bytes memory returndata) = target.staticcall(data);
344         return verifyCallResult(success, returndata, errorMessage);
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
349      * but performing a delegate call.
350      *
351      * _Available since v3.4._
352      */
353     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
354         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
359      * but performing a delegate call.
360      *
361      * _Available since v3.4._
362      */
363     function functionDelegateCall(
364         address target,
365         bytes memory data,
366         string memory errorMessage
367     ) internal returns (bytes memory) {
368         require(isContract(target), "Address: delegate call to non-contract");
369 
370         (bool success, bytes memory returndata) = target.delegatecall(data);
371         return verifyCallResult(success, returndata, errorMessage);
372     }
373 
374     /**
375      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
376      * revert reason using the provided one.
377      *
378      * _Available since v4.3._
379      */
380     function verifyCallResult(
381         bool success,
382         bytes memory returndata,
383         string memory errorMessage
384     ) internal pure returns (bytes memory) {
385         if (success) {
386             return returndata;
387         } else {
388             // Look for revert reason and bubble it up if present
389             if (returndata.length > 0) {
390                 // The easiest way to bubble the revert reason is using memory via assembly
391                 /// @solidity memory-safe-assembly
392                 assembly {
393                     let returndata_size := mload(returndata)
394                     revert(add(32, returndata), returndata_size)
395                 }
396             } else {
397                 revert(errorMessage);
398             }
399         }
400     }
401 }
402 
403 
404 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.7.3
405 
406 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
407 
408 pragma solidity ^0.8.0;
409 
410 
411 
412 /**
413  * @title SafeERC20
414  * @dev Wrappers around ERC20 operations that throw on failure (when the token
415  * contract returns false). Tokens that return no value (and instead revert or
416  * throw on failure) are also supported, non-reverting calls are assumed to be
417  * successful.
418  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
419  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
420  */
421 library SafeERC20 {
422     using Address for address;
423 
424     function safeTransfer(
425         IERC20 token,
426         address to,
427         uint256 value
428     ) internal {
429         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
430     }
431 
432     function safeTransferFrom(
433         IERC20 token,
434         address from,
435         address to,
436         uint256 value
437     ) internal {
438         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
439     }
440 
441     /**
442      * @dev Deprecated. This function has issues similar to the ones found in
443      * {IERC20-approve}, and its usage is discouraged.
444      *
445      * Whenever possible, use {safeIncreaseAllowance} and
446      * {safeDecreaseAllowance} instead.
447      */
448     function safeApprove(
449         IERC20 token,
450         address spender,
451         uint256 value
452     ) internal {
453         // safeApprove should only be called when setting an initial allowance,
454         // or when resetting it to zero. To increase and decrease it, use
455         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
456         require(
457             (value == 0) || (token.allowance(address(this), spender) == 0),
458             "SafeERC20: approve from non-zero to non-zero allowance"
459         );
460         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
461     }
462 
463     function safeIncreaseAllowance(
464         IERC20 token,
465         address spender,
466         uint256 value
467     ) internal {
468         uint256 newAllowance = token.allowance(address(this), spender) + value;
469         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
470     }
471 
472     function safeDecreaseAllowance(
473         IERC20 token,
474         address spender,
475         uint256 value
476     ) internal {
477         unchecked {
478             uint256 oldAllowance = token.allowance(address(this), spender);
479             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
480             uint256 newAllowance = oldAllowance - value;
481             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
482         }
483     }
484 
485     function safePermit(
486         IERC20Permit token,
487         address owner,
488         address spender,
489         uint256 value,
490         uint256 deadline,
491         uint8 v,
492         bytes32 r,
493         bytes32 s
494     ) internal {
495         uint256 nonceBefore = token.nonces(owner);
496         token.permit(owner, spender, value, deadline, v, r, s);
497         uint256 nonceAfter = token.nonces(owner);
498         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
499     }
500 
501     /**
502      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
503      * on the return value: the return value is optional (but if data is returned, it must not be false).
504      * @param token The token targeted by the call.
505      * @param data The call data (encoded using abi.encode or one of its variants).
506      */
507     function _callOptionalReturn(IERC20 token, bytes memory data) private {
508         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
509         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
510         // the target address contains contract code and also asserts for success in the low-level call.
511 
512         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
513         if (returndata.length > 0) {
514             // Return data is optional
515             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
516         }
517     }
518 }
519 
520 
521 // File contracts/swapProxy/SwapProxy.sol
522 
523 pragma solidity ^0.8.4;
524 
525 
526 
527 interface IWETH {
528     function deposit() external payable;
529     function withdraw(uint256) external;
530     function balanceOf(address) external returns (uint256);
531 }
532 
533 interface IWrapToken {
534     function depositFrom(address from, address to, uint256 amount) external returns(uint256 actualAmount);
535     function withdraw(address to, uint256 amount) external returns(uint256 actualAmount);
536     function balanceOf(address) external returns (uint256);
537 }
538 
539 contract SwapProxy is Multicall {
540 
541     using SafeERC20 for IERC20;
542     receive() external payable {}
543 
544     address public pancakeV3;
545     address public pancakeV2;
546     address public uniswap;
547 
548     constructor(address _pancakeV2, address _pancakeV3, address _uniswap) {
549         pancakeV2 = _pancakeV2;
550         pancakeV3 = _pancakeV3;
551         uniswap = _uniswap;
552     }
553 
554     function safeTransferETH(address to, uint256 value) internal {
555         (bool success, ) = to.call{value: value}(new bytes(0));
556         require(success, 'STE');
557     }
558 
559     function depositWETH(address weth) external payable {
560         IWETH(weth).deposit{value: msg.value}();
561     }
562 
563     function unwrapWETH(address weth, address recipient) external {
564         uint256 all = IWETH(weth).balanceOf(address(this));
565         IWETH(weth).withdraw(all);
566         safeTransferETH(recipient, all);
567     }
568 
569     function refundETH() external payable {
570         if (address(this).balance > 0) safeTransferETH(msg.sender, address(this).balance);
571     }
572 
573     function depositWrapToken(address wrapToken, uint256 value) external {
574         IWrapToken(wrapToken).depositFrom(msg.sender, address(this), value);
575     }
576 
577     function withdrawWrapToken(address wrapToken, address recipient) external {
578         uint256 value = IWrapToken(wrapToken).balanceOf(address(this));
579         if (value > 0) {
580             IWrapToken(wrapToken).withdraw(recipient, value);
581         }
582     }
583 
584     function depositToken(address token, uint256 value) external {
585         IERC20(token).safeTransferFrom(msg.sender, address(this), value);
586     }
587     
588     function sweepToken(
589         address token,
590         address recipient
591     ) external {
592         uint256 all = IERC20(token).balanceOf(address(this));
593         if (all > 0) {
594             IERC20(token).safeTransfer(recipient, all);
595         }
596     }
597 
598     function approveToken(address token, address spender) external {
599         bool ok = IERC20(token).approve(spender, type(uint256).max);
600         require(ok, 'approve fail');
601     }
602 
603     function proxy(address targetContract, bytes calldata data, uint256 msgValue) external payable returns (bytes memory res){
604         require(targetContract != address(0), "TARGET IS ZERO!");
605         require(targetContract == pancakeV2 || targetContract == pancakeV3 || targetContract == uniswap, "TARGET ERROR");
606         require(address(this).balance >= msgValue, "ETH NOT ENOUGH!");
607         (bool success, bytes memory result) = targetContract.call{value: msgValue}(data);
608         
609         if (!success) {
610             // Next 5 lines from https://ethereum.stackexchange.com/a/83577
611             if (result.length < 68) revert();
612             assembly {
613                 result := add(result, 0x04)
614             }
615             revert(abi.decode(result, (string)));
616         }
617         return result;
618     }
619 
620 }