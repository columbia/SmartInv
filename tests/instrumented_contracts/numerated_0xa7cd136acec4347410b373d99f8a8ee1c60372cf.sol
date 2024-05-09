1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity ^0.6.0;
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations with added overflow
6  * checks.
7  *
8  * Arithmetic operations in Solidity wrap on overflow. This can easily result
9  * in bugs, because programmers usually assume that an overflow raises an
10  * error, which is the standard behavior in high level programming languages.
11  * `SafeMath` restores this intuition by reverting the transaction when an
12  * operation overflows.
13  *
14  * Using this library instead of the unchecked operations eliminates an entire
15  * class of bugs, so it's recommended to use it always.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, reverting on
20      * overflow.
21      *
22      * Counterpart to Solidity's `+` operator.
23      *
24      * Requirements:
25      *
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      *
43      * - Subtraction cannot overflow.
44      */
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         return sub(a, b, "SafeMath: subtraction overflow");
47     }
48 
49     /**
50      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
51      * overflow (when the result is negative).
52      *
53      * Counterpart to Solidity's `-` operator.
54      *
55      * Requirements:
56      *
57      * - Subtraction cannot overflow.
58      */
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `*` operator.
71      *
72      * Requirements:
73      *
74      * - Multiplication cannot overflow.
75      */
76     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
78         // benefit is lost if 'b' is also tested.
79         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
80         if (a == 0) {
81             return 0;
82         }
83 
84         uint256 c = a * b;
85         require(c / a == b, "SafeMath: multiplication overflow");
86 
87         return c;
88     }
89 
90     /**
91      * @dev Returns the integer division of two unsigned integers. Reverts on
92      * division by zero. The result is rounded towards zero.
93      *
94      * Counterpart to Solidity's `/` operator. Note: this function uses a
95      * `revert` opcode (which leaves remaining gas untouched) while Solidity
96      * uses an invalid opcode to revert (consuming all remaining gas).
97      *
98      * Requirements:
99      *
100      * - The divisor cannot be zero.
101      */
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         return div(a, b, "SafeMath: division by zero");
104     }
105 
106     /**
107      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
108      * division by zero. The result is rounded towards zero.
109      *
110      * Counterpart to Solidity's `/` operator. Note: this function uses a
111      * `revert` opcode (which leaves remaining gas untouched) while Solidity
112      * uses an invalid opcode to revert (consuming all remaining gas).
113      *
114      * Requirements:
115      *
116      * - The divisor cannot be zero.
117      */
118     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      *
136      * - The divisor cannot be zero.
137      */
138     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
139         return mod(a, b, "SafeMath: modulo by zero");
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * Reverts with custom message when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
161 
162 
163 
164 pragma solidity ^0.6.0;
165 
166 /**
167  * @dev Interface of the ERC20 standard as defined in the EIP.
168  */
169 interface IERC20 {
170     /**
171      * @dev Returns the amount of tokens in existence.
172      */
173     function totalSupply() external view returns (uint256);
174 
175     /**
176      * @dev Returns the amount of tokens owned by `account`.
177      */
178     function balanceOf(address account) external view returns (uint256);
179 
180     /**
181      * @dev Moves `amount` tokens from the caller's account to `recipient`.
182      *
183      * Returns a boolean value indicating whether the operation succeeded.
184      *
185      * Emits a {Transfer} event.
186      */
187     function transfer(address recipient, uint256 amount) external returns (bool);
188 
189     /**
190      * @dev Returns the remaining number of tokens that `spender` will be
191      * allowed to spend on behalf of `owner` through {transferFrom}. This is
192      * zero by default.
193      *
194      * This value changes when {approve} or {transferFrom} are called.
195      */
196     function allowance(address owner, address spender) external view returns (uint256);
197 
198     /**
199      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
200      *
201      * Returns a boolean value indicating whether the operation succeeded.
202      *
203      * IMPORTANT: Beware that changing an allowance with this method brings the risk
204      * that someone may use both the old and the new allowance by unfortunate
205      * transaction ordering. One possible solution to mitigate this race
206      * condition is to first reduce the spender's allowance to 0 and set the
207      * desired value afterwards:
208      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
209      *
210      * Emits an {Approval} event.
211      */
212     function approve(address spender, uint256 amount) external returns (bool);
213 
214     /**
215      * @dev Moves `amount` tokens from `sender` to `recipient` using the
216      * allowance mechanism. `amount` is then deducted from the caller's
217      * allowance.
218      *
219      * Returns a boolean value indicating whether the operation succeeded.
220      *
221      * Emits a {Transfer} event.
222      */
223     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
224 
225     /**
226      * @dev Emitted when `value` tokens are moved from one account (`from`) to
227      * another (`to`).
228      *
229      * Note that `value` may be zero.
230      */
231     event Transfer(address indexed from, address indexed to, uint256 value);
232 
233     /**
234      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
235      * a call to {approve}. `value` is the new allowance.
236      */
237     event Approval(address indexed owner, address indexed spender, uint256 value);
238 }
239 
240 // File: @openzeppelin/contracts/utils/Address.sol
241 
242 
243 
244 pragma solidity ^0.6.2;
245 
246 /**
247  * @dev Collection of functions related to the address type
248  */
249 library Address {
250     /**
251      * @dev Returns true if `account` is a contract.
252      *
253      * [IMPORTANT]
254      * ====
255      * It is unsafe to assume that an address for which this function returns
256      * false is an externally-owned account (EOA) and not a contract.
257      *
258      * Among others, `isContract` will return false for the following
259      * types of addresses:
260      *
261      *  - an externally-owned account
262      *  - a contract in construction
263      *  - an address where a contract will be created
264      *  - an address where a contract lived, but was destroyed
265      * ====
266      */
267     function isContract(address account) internal view returns (bool) {
268         // This method relies in extcodesize, which returns 0 for contracts in
269         // construction, since the code is only stored at the end of the
270         // constructor execution.
271 
272         uint256 size;
273         // solhint-disable-next-line no-inline-assembly
274         assembly { size := extcodesize(account) }
275         return size > 0;
276     }
277 
278     /**
279      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
280      * `recipient`, forwarding all available gas and reverting on errors.
281      *
282      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
283      * of certain opcodes, possibly making contracts go over the 2300 gas limit
284      * imposed by `transfer`, making them unable to receive funds via
285      * `transfer`. {sendValue} removes this limitation.
286      *
287      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
288      *
289      * IMPORTANT: because control is transferred to `recipient`, care must be
290      * taken to not create reentrancy vulnerabilities. Consider using
291      * {ReentrancyGuard} or the
292      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
293      */
294     function sendValue(address payable recipient, uint256 amount) internal {
295         require(address(this).balance >= amount, "Address: insufficient balance");
296 
297         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
298         (bool success, ) = recipient.call{ value: amount }("");
299         require(success, "Address: unable to send value, recipient may have reverted");
300     }
301 
302     /**
303      * @dev Performs a Solidity function call using a low level `call`. A
304      * plain`call` is an unsafe replacement for a function call: use this
305      * function instead.
306      *
307      * If `target` reverts with a revert reason, it is bubbled up by this
308      * function (like regular Solidity function calls).
309      *
310      * Returns the raw returned data. To convert to the expected return value,
311      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
312      *
313      * Requirements:
314      *
315      * - `target` must be a contract.
316      * - calling `target` with `data` must not revert.
317      *
318      * _Available since v3.1._
319      */
320     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
321       return functionCall(target, data, "Address: low-level call failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
326      * `errorMessage` as a fallback revert reason when `target` reverts.
327      *
328      * _Available since v3.1._
329      */
330     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
331         return _functionCallWithValue(target, data, 0, errorMessage);
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
336      * but also transferring `value` wei to `target`.
337      *
338      * Requirements:
339      *
340      * - the calling contract must have an ETH balance of at least `value`.
341      * - the called Solidity function must be `payable`.
342      *
343      * _Available since v3.1._
344      */
345     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
346         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
351      * with `errorMessage` as a fallback revert reason when `target` reverts.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
356         require(address(this).balance >= value, "Address: insufficient balance for call");
357         return _functionCallWithValue(target, data, value, errorMessage);
358     }
359 
360     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
361         require(isContract(target), "Address: call to non-contract");
362 
363         // solhint-disable-next-line avoid-low-level-calls
364         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
365         if (success) {
366             return returndata;
367         } else {
368             // Look for revert reason and bubble it up if present
369             if (returndata.length > 0) {
370                 // The easiest way to bubble the revert reason is using memory via assembly
371 
372                 // solhint-disable-next-line no-inline-assembly
373                 assembly {
374                     let returndata_size := mload(returndata)
375                     revert(add(32, returndata), returndata_size)
376                 }
377             } else {
378                 revert(errorMessage);
379             }
380         }
381     }
382 }
383 
384 
385 pragma solidity ^0.6.0;
386 
387 /**
388  * @title SafeERC20
389  * @dev Wrappers around ERC20 operations that throw on failure (when the token
390  * contract returns false). Tokens that return no value (and instead revert or
391  * throw on failure) are also supported, non-reverting calls are assumed to be
392  * successful.
393  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
394  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
395  */
396 library SafeERC20 {
397     using SafeMath for uint256;
398     using Address for address;
399 
400     function safeTransfer(IERC20 token, address to, uint256 value) internal {
401         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
402     }
403 
404     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
405         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
406     }
407 
408     /**
409      * @dev Deprecated. This function has issues similar to the ones found in
410      * {IERC20-approve}, and its usage is discouraged.
411      *
412      * Whenever possible, use {safeIncreaseAllowance} and
413      * {safeDecreaseAllowance} instead.
414      */
415     function safeApprove(IERC20 token, address spender, uint256 value) internal {
416         // safeApprove should only be called when setting an initial allowance,
417         // or when resetting it to zero. To increase and decrease it, use
418         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
419         // solhint-disable-next-line max-line-length
420         require((value == 0) || (token.allowance(address(this), spender) == 0),
421             "SafeERC20: approve from non-zero to non-zero allowance"
422         );
423         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
424     }
425 
426     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
427         uint256 newAllowance = token.allowance(address(this), spender).add(value);
428         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
429     }
430 
431     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
432         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
433         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
434     }
435 
436     /**
437      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
438      * on the return value: the return value is optional (but if data is returned, it must not be false).
439      * @param token The token targeted by the call.
440      * @param data The call data (encoded using abi.encode or one of its variants).
441      */
442     function _callOptionalReturn(IERC20 token, bytes memory data) private {
443         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
444         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
445         // the target address contains contract code and also asserts for success in the low-level call.
446 
447         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
448         if (returndata.length > 0) { // Return data is optional
449             // solhint-disable-next-line max-line-length
450             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
451         }
452     }
453 }
454 
455 
456 pragma solidity ^0.6.2;
457 
458 interface Vault {
459     function token() external view returns (address);
460     function priceE18() external view returns (uint);
461     function deposit(uint) external;
462     function withdraw(uint) external;
463     function depositAll() external;
464     function withdrawAll() external;
465 }
466 
467 interface LockProxy {
468     function lock(address fromAssetHash, uint64 toChainId, bytes calldata toAddress, uint256 amount) external payable returns (bool);
469 }
470 
471 interface EthCrossChainManager {
472     function verifyHeaderAndExecuteTx(bytes calldata proof, bytes calldata rawHeader, bytes calldata headerProof, bytes calldata curRawHeader,bytes calldata headerSig) external returns (bool);
473 }
474 
475 contract LockProxyBridge {
476     using SafeERC20 for IERC20;
477     using Address for address;
478     using SafeMath for uint256;
479 
480     address public want;
481     address public xvault;
482     address public governance;
483     address public polyLockProxy;
484     address public polyCCMC;
485     uint64 public toChainId;
486 
487     constructor(address _want, address _xvault, address _lockproxy, address _ccmc, uint64 _toChainId) public {
488         want = _want;
489         xvault = _xvault;
490         governance = msg.sender;
491         polyLockProxy = _lockproxy;
492         polyCCMC = _ccmc;
493         toChainId = _toChainId;
494     }
495 
496     function setGovernance(address _governance) public {
497         require(msg.sender == governance, "!governance");
498         governance = _governance;
499     }
500 
501     // WETH -> VaultX -> XWETH -> Bridge -> PXWETH
502     // _toAddress need to be little endian and start with 0x fef: https://peterlinx.github.io/DataTransformationTools/
503     function lock(bytes memory _toAddress, uint256 _amount) public {
504         // need approve infinte amount from user then safe transfer from
505         IERC20(want).safeTransferFrom(msg.sender, address(this), _amount);
506         IERC20(want).safeApprove(xvault, _amount);
507         Vault(xvault).deposit(_amount);
508         // https://github.com/polynetwork/eth-contracts/blob/master/contracts/core/lock_proxy/LockProxy.sol#L64
509         IERC20(xvault).safeApprove(polyLockProxy, _amount);
510         // 4 -> neo mainnet 5 -> neo testnet
511         LockProxy(polyLockProxy).lock(xvault, toChainId, _toAddress, _amount);
512     }
513 
514     function unlock(bytes memory proof,
515                     bytes memory rawHeader,
516                     bytes memory headerProof,
517                     bytes memory curRawHeader,
518                     bytes memory headerSig) public {
519         // need approve infinte amount from user then safe transfer from
520         // https://github.com/polynetwork/eth-contracts/blob/master/contracts/core/cross_chain_manager/logic/EthCrossChainManager.sol#L127
521         EthCrossChainManager(polyCCMC).verifyHeaderAndExecuteTx(proof, rawHeader, headerProof, curRawHeader, headerSig);
522         uint _amount = IERC20(xvault).balanceOf(msg.sender);
523         IERC20(xvault).safeTransferFrom(msg.sender, address(this), _amount);
524 
525         uint _before = IERC20(want).balanceOf(address(this));
526         Vault(xvault).withdraw(_amount);
527         uint _after = IERC20(want).balanceOf(address(this));
528         _amount = _after.sub(_before);
529 
530         IERC20(want).safeTransfer(msg.sender, _amount);
531     }
532 
533     function pika(address _token, uint _amount) public {
534         require(msg.sender == governance, "!governance");
535         IERC20(_token).safeTransfer(governance, _amount);
536     }
537 }
538 
539 
540 pragma solidity ^0.6.2;
541 
542 
543 contract LockProxyBridgeWETH is LockProxyBridge {
544     constructor(address _xvault)
545         public
546         LockProxyBridge(
547             address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2), // WETH
548             _xvault, // 0x46b2e0224efb03d43eba88ab5a1995480e6a76b6 XWETH
549             address(0x250e76987d838a75310c34bf422ea9f1AC4Cc906), // Lock Proxy
550             address(0x14413419452Aaf089762A0c5e95eD2A13bBC488C),  // ECCM
551             14
552         )
553     {}
554 }
555 
556 
557 /*
558 contract LockProxyBridgeWBTC is LockProxyBridge {
559     constructor(address _xvault)
560         public
561         LockProxyBridge(
562             address(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599), // WBTC
563             _xvault, // 0xebd0e8988ac25a793dc27368f96a5a72e34efcd7 XWBTC
564             address(0x250e76987d838a75310c34bf422ea9f1AC4Cc906), // Lock Proxy
565             address(0x14413419452Aaf089762A0c5e95eD2A13bBC488C),  // ECCM
566             14
567         )
568     {}
569 }
570 */
571 
572 
573 /*
574 contract LockProxyBridgeUSDT is LockProxyBridge {
575     constructor(address _xvault)
576         public
577         LockProxyBridge(
578             address(0xdAC17F958D2ee523a2206206994597C13D831ec7), // USDT
579             _xvault, // 0xa93727e8661d4f82cfd50f7d8fd3f38ec8493b84 XUSDT
580             address(0x250e76987d838a75310c34bf422ea9f1AC4Cc906), // Lock Proxy
581             address(0x14413419452Aaf089762A0c5e95eD2A13bBC488C),  // ECCM
582             14
583         )
584     {}
585 }
586 */