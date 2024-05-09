1 // File: contracts/interfaces/IERC20Query.sol
2 
3 pragma solidity 0.6.4;
4 
5 interface IERC20Query {
6     /**
7      * @dev Returns the amount of tokens in existence.
8      */
9     function totalSupply() external view returns (uint256);
10 
11     /**
12      * @dev Returns the token decimals.
13      */
14     function decimals() external view returns (uint8);
15 
16     /**
17      * @dev Returns the token symbol.
18      */
19     function symbol() external view returns (string memory);
20 
21     /**
22     * @dev Returns the token name.
23     */
24     function name() external view returns (string memory);
25 
26     /**
27      * @dev Returns the amount of tokens owned by `account`.
28      */
29     function balanceOf(address account) external view returns (uint256);
30 }
31 
32 // File: openzeppelin-solidity/contracts/GSN/Context.sol
33 
34 // SPDX-License-Identifier: MIT
35 
36 pragma solidity >=0.6.0 <0.8.0;
37 
38 /*
39  * @dev Provides information about the current execution context, including the
40  * sender of the transaction and its data. While these are generally available
41  * via msg.sender and msg.data, they should not be accessed in such a direct
42  * manner, since when dealing with GSN meta-transactions the account sending and
43  * paying for execution may not be the actual sender (as far as an application
44  * is concerned).
45  *
46  * This contract is only required for intermediate, library-like contracts.
47  */
48 abstract contract Context {
49     function _msgSender() internal view virtual returns (address payable) {
50         return msg.sender;
51     }
52 
53     function _msgData() internal view virtual returns (bytes memory) {
54         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
55         return msg.data;
56     }
57 }
58 
59 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
60 
61 // SPDX-License-Identifier: MIT
62 
63 pragma solidity >=0.6.0 <0.8.0;
64 
65 /**
66  * @dev Interface of the ERC20 standard as defined in the EIP.
67  */
68 interface IERC20 {
69     /**
70      * @dev Returns the amount of tokens in existence.
71      */
72     function totalSupply() external view returns (uint256);
73 
74     /**
75      * @dev Returns the amount of tokens owned by `account`.
76      */
77     function balanceOf(address account) external view returns (uint256);
78 
79     /**
80      * @dev Moves `amount` tokens from the caller's account to `recipient`.
81      *
82      * Returns a boolean value indicating whether the operation succeeded.
83      *
84      * Emits a {Transfer} event.
85      */
86     function transfer(address recipient, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Returns the remaining number of tokens that `spender` will be
90      * allowed to spend on behalf of `owner` through {transferFrom}. This is
91      * zero by default.
92      *
93      * This value changes when {approve} or {transferFrom} are called.
94      */
95     function allowance(address owner, address spender) external view returns (uint256);
96 
97     /**
98      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
99      *
100      * Returns a boolean value indicating whether the operation succeeded.
101      *
102      * IMPORTANT: Beware that changing an allowance with this method brings the risk
103      * that someone may use both the old and the new allowance by unfortunate
104      * transaction ordering. One possible solution to mitigate this race
105      * condition is to first reduce the spender's allowance to 0 and set the
106      * desired value afterwards:
107      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
108      *
109      * Emits an {Approval} event.
110      */
111     function approve(address spender, uint256 amount) external returns (bool);
112 
113     /**
114      * @dev Moves `amount` tokens from `sender` to `recipient` using the
115      * allowance mechanism. `amount` is then deducted from the caller's
116      * allowance.
117      *
118      * Returns a boolean value indicating whether the operation succeeded.
119      *
120      * Emits a {Transfer} event.
121      */
122     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
123 
124     /**
125      * @dev Emitted when `value` tokens are moved from one account (`from`) to
126      * another (`to`).
127      *
128      * Note that `value` may be zero.
129      */
130     event Transfer(address indexed from, address indexed to, uint256 value);
131 
132     /**
133      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
134      * a call to {approve}. `value` is the new allowance.
135      */
136     event Approval(address indexed owner, address indexed spender, uint256 value);
137 }
138 
139 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
140 
141 // SPDX-License-Identifier: MIT
142 
143 pragma solidity >=0.6.0 <0.8.0;
144 
145 /**
146  * @dev Wrappers over Solidity's arithmetic operations with added overflow
147  * checks.
148  *
149  * Arithmetic operations in Solidity wrap on overflow. This can easily result
150  * in bugs, because programmers usually assume that an overflow raises an
151  * error, which is the standard behavior in high level programming languages.
152  * `SafeMath` restores this intuition by reverting the transaction when an
153  * operation overflows.
154  *
155  * Using this library instead of the unchecked operations eliminates an entire
156  * class of bugs, so it's recommended to use it always.
157  */
158 library SafeMath {
159     /**
160      * @dev Returns the addition of two unsigned integers, reverting on
161      * overflow.
162      *
163      * Counterpart to Solidity's `+` operator.
164      *
165      * Requirements:
166      *
167      * - Addition cannot overflow.
168      */
169     function add(uint256 a, uint256 b) internal pure returns (uint256) {
170         uint256 c = a + b;
171         require(c >= a, "SafeMath: addition overflow");
172 
173         return c;
174     }
175 
176     /**
177      * @dev Returns the subtraction of two unsigned integers, reverting on
178      * overflow (when the result is negative).
179      *
180      * Counterpart to Solidity's `-` operator.
181      *
182      * Requirements:
183      *
184      * - Subtraction cannot overflow.
185      */
186     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
187         return sub(a, b, "SafeMath: subtraction overflow");
188     }
189 
190     /**
191      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
192      * overflow (when the result is negative).
193      *
194      * Counterpart to Solidity's `-` operator.
195      *
196      * Requirements:
197      *
198      * - Subtraction cannot overflow.
199      */
200     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
201         require(b <= a, errorMessage);
202         uint256 c = a - b;
203 
204         return c;
205     }
206 
207     /**
208      * @dev Returns the multiplication of two unsigned integers, reverting on
209      * overflow.
210      *
211      * Counterpart to Solidity's `*` operator.
212      *
213      * Requirements:
214      *
215      * - Multiplication cannot overflow.
216      */
217     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
218         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
219         // benefit is lost if 'b' is also tested.
220         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
221         if (a == 0) {
222             return 0;
223         }
224 
225         uint256 c = a * b;
226         require(c / a == b, "SafeMath: multiplication overflow");
227 
228         return c;
229     }
230 
231     /**
232      * @dev Returns the integer division of two unsigned integers. Reverts on
233      * division by zero. The result is rounded towards zero.
234      *
235      * Counterpart to Solidity's `/` operator. Note: this function uses a
236      * `revert` opcode (which leaves remaining gas untouched) while Solidity
237      * uses an invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      *
241      * - The divisor cannot be zero.
242      */
243     function div(uint256 a, uint256 b) internal pure returns (uint256) {
244         return div(a, b, "SafeMath: division by zero");
245     }
246 
247     /**
248      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
249      * division by zero. The result is rounded towards zero.
250      *
251      * Counterpart to Solidity's `/` operator. Note: this function uses a
252      * `revert` opcode (which leaves remaining gas untouched) while Solidity
253      * uses an invalid opcode to revert (consuming all remaining gas).
254      *
255      * Requirements:
256      *
257      * - The divisor cannot be zero.
258      */
259     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
260         require(b > 0, errorMessage);
261         uint256 c = a / b;
262         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
263 
264         return c;
265     }
266 
267     /**
268      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
269      * Reverts when dividing by zero.
270      *
271      * Counterpart to Solidity's `%` operator. This function uses a `revert`
272      * opcode (which leaves remaining gas untouched) while Solidity uses an
273      * invalid opcode to revert (consuming all remaining gas).
274      *
275      * Requirements:
276      *
277      * - The divisor cannot be zero.
278      */
279     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
280         return mod(a, b, "SafeMath: modulo by zero");
281     }
282 
283     /**
284      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
285      * Reverts with custom message when dividing by zero.
286      *
287      * Counterpart to Solidity's `%` operator. This function uses a `revert`
288      * opcode (which leaves remaining gas untouched) while Solidity uses an
289      * invalid opcode to revert (consuming all remaining gas).
290      *
291      * Requirements:
292      *
293      * - The divisor cannot be zero.
294      */
295     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
296         require(b != 0, errorMessage);
297         return a % b;
298     }
299 }
300 
301 // File: openzeppelin-solidity/contracts/utils/Address.sol
302 
303 // SPDX-License-Identifier: MIT
304 
305 pragma solidity >=0.6.2 <0.8.0;
306 
307 /**
308  * @dev Collection of functions related to the address type
309  */
310 library Address {
311     /**
312      * @dev Returns true if `account` is a contract.
313      *
314      * [IMPORTANT]
315      * ====
316      * It is unsafe to assume that an address for which this function returns
317      * false is an externally-owned account (EOA) and not a contract.
318      *
319      * Among others, `isContract` will return false for the following
320      * types of addresses:
321      *
322      *  - an externally-owned account
323      *  - a contract in construction
324      *  - an address where a contract will be created
325      *  - an address where a contract lived, but was destroyed
326      * ====
327      */
328     function isContract(address account) internal view returns (bool) {
329         // This method relies on extcodesize, which returns 0 for contracts in
330         // construction, since the code is only stored at the end of the
331         // constructor execution.
332 
333         uint256 size;
334         // solhint-disable-next-line no-inline-assembly
335         assembly { size := extcodesize(account) }
336         return size > 0;
337     }
338 
339     /**
340      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
341      * `recipient`, forwarding all available gas and reverting on errors.
342      *
343      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
344      * of certain opcodes, possibly making contracts go over the 2300 gas limit
345      * imposed by `transfer`, making them unable to receive funds via
346      * `transfer`. {sendValue} removes this limitation.
347      *
348      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
349      *
350      * IMPORTANT: because control is transferred to `recipient`, care must be
351      * taken to not create reentrancy vulnerabilities. Consider using
352      * {ReentrancyGuard} or the
353      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
354      */
355     function sendValue(address payable recipient, uint256 amount) internal {
356         require(address(this).balance >= amount, "Address: insufficient balance");
357 
358         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
359         (bool success, ) = recipient.call{ value: amount }("");
360         require(success, "Address: unable to send value, recipient may have reverted");
361     }
362 
363     /**
364      * @dev Performs a Solidity function call using a low level `call`. A
365      * plain`call` is an unsafe replacement for a function call: use this
366      * function instead.
367      *
368      * If `target` reverts with a revert reason, it is bubbled up by this
369      * function (like regular Solidity function calls).
370      *
371      * Returns the raw returned data. To convert to the expected return value,
372      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
373      *
374      * Requirements:
375      *
376      * - `target` must be a contract.
377      * - calling `target` with `data` must not revert.
378      *
379      * _Available since v3.1._
380      */
381     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
382       return functionCall(target, data, "Address: low-level call failed");
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
387      * `errorMessage` as a fallback revert reason when `target` reverts.
388      *
389      * _Available since v3.1._
390      */
391     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
392         return functionCallWithValue(target, data, 0, errorMessage);
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
397      * but also transferring `value` wei to `target`.
398      *
399      * Requirements:
400      *
401      * - the calling contract must have an ETH balance of at least `value`.
402      * - the called Solidity function must be `payable`.
403      *
404      * _Available since v3.1._
405      */
406     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
407         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
412      * with `errorMessage` as a fallback revert reason when `target` reverts.
413      *
414      * _Available since v3.1._
415      */
416     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
417         require(address(this).balance >= value, "Address: insufficient balance for call");
418         require(isContract(target), "Address: call to non-contract");
419 
420         // solhint-disable-next-line avoid-low-level-calls
421         (bool success, bytes memory returndata) = target.call{ value: value }(data);
422         return _verifyCallResult(success, returndata, errorMessage);
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
427      * but performing a static call.
428      *
429      * _Available since v3.3._
430      */
431     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
432         return functionStaticCall(target, data, "Address: low-level static call failed");
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
437      * but performing a static call.
438      *
439      * _Available since v3.3._
440      */
441     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
442         require(isContract(target), "Address: static call to non-contract");
443 
444         // solhint-disable-next-line avoid-low-level-calls
445         (bool success, bytes memory returndata) = target.staticcall(data);
446         return _verifyCallResult(success, returndata, errorMessage);
447     }
448 
449     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
450         if (success) {
451             return returndata;
452         } else {
453             // Look for revert reason and bubble it up if present
454             if (returndata.length > 0) {
455                 // The easiest way to bubble the revert reason is using memory via assembly
456 
457                 // solhint-disable-next-line no-inline-assembly
458                 assembly {
459                     let returndata_size := mload(returndata)
460                     revert(add(32, returndata), returndata_size)
461                 }
462             } else {
463                 revert(errorMessage);
464             }
465         }
466     }
467 }
468 
469 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
470 
471 // SPDX-License-Identifier: MIT
472 
473 pragma solidity >=0.6.0 <0.8.0;
474 
475 
476 
477 
478 /**
479  * @title SafeERC20
480  * @dev Wrappers around ERC20 operations that throw on failure (when the token
481  * contract returns false). Tokens that return no value (and instead revert or
482  * throw on failure) are also supported, non-reverting calls are assumed to be
483  * successful.
484  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
485  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
486  */
487 library SafeERC20 {
488     using SafeMath for uint256;
489     using Address for address;
490 
491     function safeTransfer(IERC20 token, address to, uint256 value) internal {
492         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
493     }
494 
495     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
496         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
497     }
498 
499     /**
500      * @dev Deprecated. This function has issues similar to the ones found in
501      * {IERC20-approve}, and its usage is discouraged.
502      *
503      * Whenever possible, use {safeIncreaseAllowance} and
504      * {safeDecreaseAllowance} instead.
505      */
506     function safeApprove(IERC20 token, address spender, uint256 value) internal {
507         // safeApprove should only be called when setting an initial allowance,
508         // or when resetting it to zero. To increase and decrease it, use
509         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
510         // solhint-disable-next-line max-line-length
511         require((value == 0) || (token.allowance(address(this), spender) == 0),
512             "SafeERC20: approve from non-zero to non-zero allowance"
513         );
514         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
515     }
516 
517     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
518         uint256 newAllowance = token.allowance(address(this), spender).add(value);
519         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
520     }
521 
522     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
523         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
524         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
525     }
526 
527     /**
528      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
529      * on the return value: the return value is optional (but if data is returned, it must not be false).
530      * @param token The token targeted by the call.
531      * @param data The call data (encoded using abi.encode or one of its variants).
532      */
533     function _callOptionalReturn(IERC20 token, bytes memory data) private {
534         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
535         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
536         // the target address contains contract code and also asserts for success in the low-level call.
537 
538         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
539         if (returndata.length > 0) { // Return data is optional
540             // solhint-disable-next-line max-line-length
541             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
542         }
543     }
544 }
545 
546 // File: contracts/ETHSwapAgentImpl.sol
547 
548 pragma solidity 0.6.4;
549 
550 
551 
552 
553 contract ETHSwapAgentImpl is Context {
554 
555     using SafeERC20 for IERC20;
556 
557     mapping(address => bool) public registeredERC20;
558     mapping(bytes32 => bool) public filledBSCTx;
559     address payable public owner;
560     uint256 public swapFee;
561 
562     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
563     event SwapPairRegister(address indexed sponsor,address indexed erc20Addr, string name, string symbol, uint8 decimals);
564     event SwapStarted(address indexed erc20Addr, address indexed fromAddr, uint256 amount, uint256 feeAmount);
565     event SwapFilled(address indexed erc20Addr, bytes32 indexed bscTxHash, address indexed toAddress, uint256 amount);
566 
567     constructor(uint256 fee) public {
568         swapFee = fee;
569         owner = _msgSender();
570     }
571 
572     /**
573      * @dev Throws if called by any account other than the owner.
574      */
575     modifier onlyOwner() {
576         require(owner == _msgSender(), "Ownable: caller is not the owner");
577         _;
578     }
579 
580     modifier notContract() {
581         require(!isContract(msg.sender), "contract is not allowed to swap");
582         require(msg.sender == tx.origin, "no proxy contract is allowed");
583        _;
584     }
585 
586     function isContract(address addr) internal view returns (bool) {
587         uint size;
588         assembly { size := extcodesize(addr) }
589         return size > 0;
590     }
591 
592     /**
593         * @dev Leaves the contract without owner. It will not be possible to call
594         * `onlyOwner` functions anymore. Can only be called by the current owner.
595         *
596         * NOTE: Renouncing ownership will leave the contract without an owner,
597         * thereby removing any functionality that is only available to the owner.
598         */
599     function renounceOwnership() public onlyOwner {
600         emit OwnershipTransferred(owner, address(0));
601         owner = address(0);
602     }
603 
604     /**
605      * @dev Transfers ownership of the contract to a new account (`newOwner`).
606      * Can only be called by the current owner.
607      */
608     function transferOwnership(address payable newOwner) public onlyOwner {
609         require(newOwner != address(0), "Ownable: new owner is the zero address");
610         emit OwnershipTransferred(owner, newOwner);
611         owner = newOwner;
612     }
613 
614     /**
615      * @dev Returns set minimum swap fee from ERC20 to BEP20
616      */
617     function setSwapFee(uint256 fee) onlyOwner external {
618         swapFee = fee;
619     }
620 
621     function registerSwapPairToBSC(address erc20Addr) external returns (bool) {
622         require(!registeredERC20[erc20Addr], "already registered");
623 
624         string memory name = IERC20Query(erc20Addr).name();
625         string memory symbol = IERC20Query(erc20Addr).symbol();
626         uint8 decimals = IERC20Query(erc20Addr).decimals();
627 
628         require(bytes(name).length>0, "empty name");
629         require(bytes(symbol).length>0, "empty symbol");
630 
631         registeredERC20[erc20Addr] = true;
632 
633         emit SwapPairRegister(msg.sender, erc20Addr, name, symbol, decimals);
634         return true;
635     }
636 
637     function fillBSC2ETHSwap(bytes32 bscTxHash, address erc20Addr, address toAddress, uint256 amount) onlyOwner external returns (bool) {
638         require(!filledBSCTx[bscTxHash], "bsc tx filled already");
639         require(registeredERC20[erc20Addr], "not registered token");
640 
641         filledBSCTx[bscTxHash] = true;
642         IERC20(erc20Addr).safeTransfer(toAddress, amount);
643 
644         emit SwapFilled(erc20Addr, bscTxHash, toAddress, amount);
645         return true;
646     }
647 
648     function swapETH2BSC(address erc20Addr, uint256 amount) payable external notContract returns (bool) {
649         require(registeredERC20[erc20Addr], "not registered token");
650         require(msg.value == swapFee, "swap fee not equal");
651 
652         IERC20(erc20Addr).safeTransferFrom(msg.sender, address(this), amount);
653         if (msg.value != 0) {
654             owner.transfer(msg.value);
655         }
656 
657         emit SwapStarted(erc20Addr, msg.sender, amount, msg.value);
658         return true;
659     }
660 }