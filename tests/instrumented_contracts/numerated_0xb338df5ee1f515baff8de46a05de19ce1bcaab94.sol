1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
4 pragma solidity ^0.6.0;
5 
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: @openzeppelin/contracts/math/SafeMath.sol
81 
82 pragma solidity ^0.6.0;
83 
84 /**
85  * @dev Wrappers over Solidity's arithmetic operations with added overflow
86  * checks.
87  *
88  * Arithmetic operations in Solidity wrap on overflow. This can easily result
89  * in bugs, because programmers usually assume that an overflow raises an
90  * error, which is the standard behavior in high level programming languages.
91  * `SafeMath` restores this intuition by reverting the transaction when an
92  * operation overflows.
93  *
94  * Using this library instead of the unchecked operations eliminates an entire
95  * class of bugs, so it's recommended to use it always.
96  */
97 library SafeMath {
98     /**
99      * @dev Returns the addition of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `+` operator.
103      *
104      * Requirements:
105      *
106      * - Addition cannot overflow.
107      */
108     function add(uint256 a, uint256 b) internal pure returns (uint256) {
109         uint256 c = a + b;
110         require(c >= a, "SafeMath: addition overflow");
111 
112         return c;
113     }
114 
115     /**
116      * @dev Returns the subtraction of two unsigned integers, reverting on
117      * overflow (when the result is negative).
118      *
119      * Counterpart to Solidity's `-` operator.
120      *
121      * Requirements:
122      *
123      * - Subtraction cannot overflow.
124      */
125     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
126         return sub(a, b, "SafeMath: subtraction overflow");
127     }
128 
129     /**
130      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
131      * overflow (when the result is negative).
132      *
133      * Counterpart to Solidity's `-` operator.
134      *
135      * Requirements:
136      *
137      * - Subtraction cannot overflow.
138      */
139     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
140         require(b <= a, errorMessage);
141         uint256 c = a - b;
142 
143         return c;
144     }
145 
146     /**
147      * @dev Returns the multiplication of two unsigned integers, reverting on
148      * overflow.
149      *
150      * Counterpart to Solidity's `*` operator.
151      *
152      * Requirements:
153      *
154      * - Multiplication cannot overflow.
155      */
156     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
157         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
158         // benefit is lost if 'b' is also tested.
159         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
160         if (a == 0) {
161             return 0;
162         }
163 
164         uint256 c = a * b;
165         require(c / a == b, "SafeMath: multiplication overflow");
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the integer division of two unsigned integers. Reverts on
172      * division by zero. The result is rounded towards zero.
173      *
174      * Counterpart to Solidity's `/` operator. Note: this function uses a
175      * `revert` opcode (which leaves remaining gas untouched) while Solidity
176      * uses an invalid opcode to revert (consuming all remaining gas).
177      *
178      * Requirements:
179      *
180      * - The divisor cannot be zero.
181      */
182     function div(uint256 a, uint256 b) internal pure returns (uint256) {
183         return div(a, b, "SafeMath: division by zero");
184     }
185 
186     /**
187      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
188      * division by zero. The result is rounded towards zero.
189      *
190      * Counterpart to Solidity's `/` operator. Note: this function uses a
191      * `revert` opcode (which leaves remaining gas untouched) while Solidity
192      * uses an invalid opcode to revert (consuming all remaining gas).
193      *
194      * Requirements:
195      *
196      * - The divisor cannot be zero.
197      */
198     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
199         require(b > 0, errorMessage);
200         uint256 c = a / b;
201         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
202 
203         return c;
204     }
205 
206     /**
207      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
208      * Reverts when dividing by zero.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
219         return mod(a, b, "SafeMath: modulo by zero");
220     }
221 
222     /**
223      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
224      * Reverts with custom message when dividing by zero.
225      *
226      * Counterpart to Solidity's `%` operator. This function uses a `revert`
227      * opcode (which leaves remaining gas untouched) while Solidity uses an
228      * invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
235         require(b != 0, errorMessage);
236         return a % b;
237     }
238 }
239 
240 // File: @openzeppelin/contracts/utils/Address.sol
241 
242 
243 pragma solidity ^0.6.2;
244 
245 /**
246  * @dev Collection of functions related to the address type
247  */
248 library Address {
249     /**
250      * @dev Returns true if `account` is a contract.
251      *
252      * [IMPORTANT]
253      * ====
254      * It is unsafe to assume that an address for which this function returns
255      * false is an externally-owned account (EOA) and not a contract.
256      *
257      * Among others, `isContract` will return false for the following
258      * types of addresses:
259      *
260      *  - an externally-owned account
261      *  - a contract in construction
262      *  - an address where a contract will be created
263      *  - an address where a contract lived, but was destroyed
264      * ====
265      */
266     function isContract(address account) internal view returns (bool) {
267         // This method relies in extcodesize, which returns 0 for contracts in
268         // construction, since the code is only stored at the end of the
269         // constructor execution.
270 
271         uint256 size;
272         // solhint-disable-next-line no-inline-assembly
273         assembly { size := extcodesize(account) }
274         return size > 0;
275     }
276 
277     /**
278      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
279      * `recipient`, forwarding all available gas and reverting on errors.
280      *
281      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
282      * of certain opcodes, possibly making contracts go over the 2300 gas limit
283      * imposed by `transfer`, making them unable to receive funds via
284      * `transfer`. {sendValue} removes this limitation.
285      *
286      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
287      *
288      * IMPORTANT: because control is transferred to `recipient`, care must be
289      * taken to not create reentrancy vulnerabilities. Consider using
290      * {ReentrancyGuard} or the
291      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
292      */
293     function sendValue(address payable recipient, uint256 amount) internal {
294         require(address(this).balance >= amount, "Address: insufficient balance");
295 
296         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
297         (bool success, ) = recipient.call{ value: amount }("");
298         require(success, "Address: unable to send value, recipient may have reverted");
299     }
300 
301     /**
302      * @dev Performs a Solidity function call using a low level `call`. A
303      * plain`call` is an unsafe replacement for a function call: use this
304      * function instead.
305      *
306      * If `target` reverts with a revert reason, it is bubbled up by this
307      * function (like regular Solidity function calls).
308      *
309      * Returns the raw returned data. To convert to the expected return value,
310      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
311      *
312      * Requirements:
313      *
314      * - `target` must be a contract.
315      * - calling `target` with `data` must not revert.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
320       return functionCall(target, data, "Address: low-level call failed");
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
325      * `errorMessage` as a fallback revert reason when `target` reverts.
326      *
327      * _Available since v3.1._
328      */
329     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
330         return _functionCallWithValue(target, data, 0, errorMessage);
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
335      * but also transferring `value` wei to `target`.
336      *
337      * Requirements:
338      *
339      * - the calling contract must have an ETH balance of at least `value`.
340      * - the called Solidity function must be `payable`.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
345         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
350      * with `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
355         require(address(this).balance >= value, "Address: insufficient balance for call");
356         return _functionCallWithValue(target, data, value, errorMessage);
357     }
358 
359     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
360         require(isContract(target), "Address: call to non-contract");
361 
362         // solhint-disable-next-line avoid-low-level-calls
363         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
364         if (success) {
365             return returndata;
366         } else {
367             // Look for revert reason and bubble it up if present
368             if (returndata.length > 0) {
369                 // The easiest way to bubble the revert reason is using memory via assembly
370 
371                 // solhint-disable-next-line no-inline-assembly
372                 assembly {
373                     let returndata_size := mload(returndata)
374                     revert(add(32, returndata), returndata_size)
375                 }
376             } else {
377                 revert(errorMessage);
378             }
379         }
380     }
381 }
382 
383 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
384 
385 
386 pragma solidity ^0.6.0;
387 
388 
389 
390 
391 /**
392  * @title SafeERC20
393  * @dev Wrappers around ERC20 operations that throw on failure (when the token
394  * contract returns false). Tokens that return no value (and instead revert or
395  * throw on failure) are also supported, non-reverting calls are assumed to be
396  * successful.
397  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
398  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
399  */
400 library SafeERC20 {
401     using SafeMath for uint256;
402     using Address for address;
403 
404     function safeTransfer(IERC20 token, address to, uint256 value) internal {
405         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
406     }
407 
408     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
409         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
410     }
411 
412     /**
413      * @dev Deprecated. This function has issues similar to the ones found in
414      * {IERC20-approve}, and its usage is discouraged.
415      *
416      * Whenever possible, use {safeIncreaseAllowance} and
417      * {safeDecreaseAllowance} instead.
418      */
419     function safeApprove(IERC20 token, address spender, uint256 value) internal {
420         // safeApprove should only be called when setting an initial allowance,
421         // or when resetting it to zero. To increase and decrease it, use
422         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
423         // solhint-disable-next-line max-line-length
424         require((value == 0) || (token.allowance(address(this), spender) == 0),
425             "SafeERC20: approve from non-zero to non-zero allowance"
426         );
427         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
428     }
429 
430     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
431         uint256 newAllowance = token.allowance(address(this), spender).add(value);
432         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
433     }
434 
435     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
436         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
437         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
438     }
439 
440     /**
441      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
442      * on the return value: the return value is optional (but if data is returned, it must not be false).
443      * @param token The token targeted by the call.
444      * @param data The call data (encoded using abi.encode or one of its variants).
445      */
446     function _callOptionalReturn(IERC20 token, bytes memory data) private {
447         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
448         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
449         // the target address contains contract code and also asserts for success in the low-level call.
450 
451         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
452         if (returndata.length > 0) { // Return data is optional
453             // solhint-disable-next-line max-line-length
454             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
455         }
456     }
457 }
458 
459 // File: contracts/utils/ContractGuard.sol
460 
461 pragma solidity ^0.6.12;
462 
463 contract ContractGuard {
464     mapping(uint256 => mapping(address => bool)) private _status;
465 
466     function checkSameOriginReentranted() internal view returns (bool) {
467         return _status[block.number][tx.origin];
468     }
469 
470     function checkSameSenderReentranted() internal view returns (bool) {
471         return _status[block.number][msg.sender];
472     }
473 
474     modifier onlyOneBlock() {
475         require(
476             !checkSameOriginReentranted(),
477             'ContractGuard: one block, one function'
478         );
479         require(
480             !checkSameSenderReentranted(),
481             'ContractGuard: one block, one function'
482         );
483 
484         _;
485 
486         _status[block.number][tx.origin] = true;
487         _status[block.number][msg.sender] = true;
488     }
489 }
490 
491 // File: contracts/ShareExchange.sol
492 
493 pragma solidity ^0.6.0;
494 
495 
496 
497 
498 //Mint 350k Shares to this contract
499 contract ShareExchange is ContractGuard {
500     using SafeERC20 for IERC20;
501 
502     address public share_old;
503     address public share_new;
504 
505     constructor(address _share_old, address _share_new) public {
506         share_old = _share_old;
507         share_new = _share_new;
508     }
509 
510     function exchangeShares(uint256 amount)
511         external
512         onlyOneBlock
513     {
514         require(amount > 0, 'ShareExchange: amount must be > 0');
515 
516         //reverts if amount > sender's balance, so I don't need to check if amount <= sender's balance
517         IERC20(share_old).safeTransferFrom(msg.sender, address(this), amount);
518         //reverts if amount > the contract's balance, so I don't need to check if amount <= contract's balance
519         IERC20(share_new).safeTransfer(msg.sender, amount);
520 
521         emit ExchangedShares(msg.sender, amount);
522     }
523 
524     /* ========== VIEW FUNCTIONS ========== */
525 
526     function getBalance() public view returns (uint256) {
527         return IERC20(share_new).balanceOf(address(this));
528     }
529 
530     // CORE
531     event ExchangedShares(address indexed from, uint256 amount);
532 }