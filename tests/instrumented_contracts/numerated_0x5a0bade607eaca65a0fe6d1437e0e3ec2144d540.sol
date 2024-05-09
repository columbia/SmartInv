1 // SPDX-License-Identifier: AGPL-3.0
2 
3 pragma solidity 0.6.12;
4 
5 
6 
7 // Part: OpenZeppelin/openzeppelin-contracts@3.1.0/Address
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      */
30     function isContract(address account) internal view returns (bool) {
31         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
32         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
33         // for accounts without code, i.e. `keccak256('')`
34         bytes32 codehash;
35         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
36         // solhint-disable-next-line no-inline-assembly
37         assembly { codehash := extcodehash(account) }
38         return (codehash != accountHash && codehash != 0x0);
39     }
40 
41     /**
42      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
43      * `recipient`, forwarding all available gas and reverting on errors.
44      *
45      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
46      * of certain opcodes, possibly making contracts go over the 2300 gas limit
47      * imposed by `transfer`, making them unable to receive funds via
48      * `transfer`. {sendValue} removes this limitation.
49      *
50      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
51      *
52      * IMPORTANT: because control is transferred to `recipient`, care must be
53      * taken to not create reentrancy vulnerabilities. Consider using
54      * {ReentrancyGuard} or the
55      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
56      */
57     function sendValue(address payable recipient, uint256 amount) internal {
58         require(address(this).balance >= amount, "Address: insufficient balance");
59 
60         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
61         (bool success, ) = recipient.call{ value: amount }("");
62         require(success, "Address: unable to send value, recipient may have reverted");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain`call` is an unsafe replacement for a function call: use this
68      * function instead.
69      *
70      * If `target` reverts with a revert reason, it is bubbled up by this
71      * function (like regular Solidity function calls).
72      *
73      * Returns the raw returned data. To convert to the expected return value,
74      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
75      *
76      * Requirements:
77      *
78      * - `target` must be a contract.
79      * - calling `target` with `data` must not revert.
80      *
81      * _Available since v3.1._
82      */
83     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
84       return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
94         return _functionCallWithValue(target, data, 0, errorMessage);
95     }
96 
97     /**
98      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
99      * but also transferring `value` wei to `target`.
100      *
101      * Requirements:
102      *
103      * - the calling contract must have an ETH balance of at least `value`.
104      * - the called Solidity function must be `payable`.
105      *
106      * _Available since v3.1._
107      */
108     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
109         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
110     }
111 
112     /**
113      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
114      * with `errorMessage` as a fallback revert reason when `target` reverts.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
119         require(address(this).balance >= value, "Address: insufficient balance for call");
120         return _functionCallWithValue(target, data, value, errorMessage);
121     }
122 
123     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
124         require(isContract(target), "Address: call to non-contract");
125 
126         // solhint-disable-next-line avoid-low-level-calls
127         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
128         if (success) {
129             return returndata;
130         } else {
131             // Look for revert reason and bubble it up if present
132             if (returndata.length > 0) {
133                 // The easiest way to bubble the revert reason is using memory via assembly
134 
135                 // solhint-disable-next-line no-inline-assembly
136                 assembly {
137                     let returndata_size := mload(returndata)
138                     revert(add(32, returndata), returndata_size)
139                 }
140             } else {
141                 revert(errorMessage);
142             }
143         }
144     }
145 }
146 
147 // Part: OpenZeppelin/openzeppelin-contracts@3.1.0/IERC20
148 
149 /**
150  * @dev Interface of the ERC20 standard as defined in the EIP.
151  */
152 interface IERC20 {
153     /**
154      * @dev Returns the amount of tokens in existence.
155      */
156     function totalSupply() external view returns (uint256);
157 
158     /**
159      * @dev Returns the amount of tokens owned by `account`.
160      */
161     function balanceOf(address account) external view returns (uint256);
162 
163     /**
164      * @dev Moves `amount` tokens from the caller's account to `recipient`.
165      *
166      * Returns a boolean value indicating whether the operation succeeded.
167      *
168      * Emits a {Transfer} event.
169      */
170     function transfer(address recipient, uint256 amount) external returns (bool);
171 
172     /**
173      * @dev Returns the remaining number of tokens that `spender` will be
174      * allowed to spend on behalf of `owner` through {transferFrom}. This is
175      * zero by default.
176      *
177      * This value changes when {approve} or {transferFrom} are called.
178      */
179     function allowance(address owner, address spender) external view returns (uint256);
180 
181     /**
182      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
183      *
184      * Returns a boolean value indicating whether the operation succeeded.
185      *
186      * IMPORTANT: Beware that changing an allowance with this method brings the risk
187      * that someone may use both the old and the new allowance by unfortunate
188      * transaction ordering. One possible solution to mitigate this race
189      * condition is to first reduce the spender's allowance to 0 and set the
190      * desired value afterwards:
191      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
192      *
193      * Emits an {Approval} event.
194      */
195     function approve(address spender, uint256 amount) external returns (bool);
196 
197     /**
198      * @dev Moves `amount` tokens from `sender` to `recipient` using the
199      * allowance mechanism. `amount` is then deducted from the caller's
200      * allowance.
201      *
202      * Returns a boolean value indicating whether the operation succeeded.
203      *
204      * Emits a {Transfer} event.
205      */
206     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
207 
208     /**
209      * @dev Emitted when `value` tokens are moved from one account (`from`) to
210      * another (`to`).
211      *
212      * Note that `value` may be zero.
213      */
214     event Transfer(address indexed from, address indexed to, uint256 value);
215 
216     /**
217      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
218      * a call to {approve}. `value` is the new allowance.
219      */
220     event Approval(address indexed owner, address indexed spender, uint256 value);
221 }
222 
223 // Part: OpenZeppelin/openzeppelin-contracts@3.1.0/SafeMath
224 
225 /**
226  * @dev Wrappers over Solidity's arithmetic operations with added overflow
227  * checks.
228  *
229  * Arithmetic operations in Solidity wrap on overflow. This can easily result
230  * in bugs, because programmers usually assume that an overflow raises an
231  * error, which is the standard behavior in high level programming languages.
232  * `SafeMath` restores this intuition by reverting the transaction when an
233  * operation overflows.
234  *
235  * Using this library instead of the unchecked operations eliminates an entire
236  * class of bugs, so it's recommended to use it always.
237  */
238 library SafeMath {
239     /**
240      * @dev Returns the addition of two unsigned integers, reverting on
241      * overflow.
242      *
243      * Counterpart to Solidity's `+` operator.
244      *
245      * Requirements:
246      *
247      * - Addition cannot overflow.
248      */
249     function add(uint256 a, uint256 b) internal pure returns (uint256) {
250         uint256 c = a + b;
251         require(c >= a, "SafeMath: addition overflow");
252 
253         return c;
254     }
255 
256     /**
257      * @dev Returns the subtraction of two unsigned integers, reverting on
258      * overflow (when the result is negative).
259      *
260      * Counterpart to Solidity's `-` operator.
261      *
262      * Requirements:
263      *
264      * - Subtraction cannot overflow.
265      */
266     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
267         return sub(a, b, "SafeMath: subtraction overflow");
268     }
269 
270     /**
271      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
272      * overflow (when the result is negative).
273      *
274      * Counterpart to Solidity's `-` operator.
275      *
276      * Requirements:
277      *
278      * - Subtraction cannot overflow.
279      */
280     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
281         require(b <= a, errorMessage);
282         uint256 c = a - b;
283 
284         return c;
285     }
286 
287     /**
288      * @dev Returns the multiplication of two unsigned integers, reverting on
289      * overflow.
290      *
291      * Counterpart to Solidity's `*` operator.
292      *
293      * Requirements:
294      *
295      * - Multiplication cannot overflow.
296      */
297     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
298         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
299         // benefit is lost if 'b' is also tested.
300         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
301         if (a == 0) {
302             return 0;
303         }
304 
305         uint256 c = a * b;
306         require(c / a == b, "SafeMath: multiplication overflow");
307 
308         return c;
309     }
310 
311     /**
312      * @dev Returns the integer division of two unsigned integers. Reverts on
313      * division by zero. The result is rounded towards zero.
314      *
315      * Counterpart to Solidity's `/` operator. Note: this function uses a
316      * `revert` opcode (which leaves remaining gas untouched) while Solidity
317      * uses an invalid opcode to revert (consuming all remaining gas).
318      *
319      * Requirements:
320      *
321      * - The divisor cannot be zero.
322      */
323     function div(uint256 a, uint256 b) internal pure returns (uint256) {
324         return div(a, b, "SafeMath: division by zero");
325     }
326 
327     /**
328      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
329      * division by zero. The result is rounded towards zero.
330      *
331      * Counterpart to Solidity's `/` operator. Note: this function uses a
332      * `revert` opcode (which leaves remaining gas untouched) while Solidity
333      * uses an invalid opcode to revert (consuming all remaining gas).
334      *
335      * Requirements:
336      *
337      * - The divisor cannot be zero.
338      */
339     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
340         require(b > 0, errorMessage);
341         uint256 c = a / b;
342         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
343 
344         return c;
345     }
346 
347     /**
348      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
349      * Reverts when dividing by zero.
350      *
351      * Counterpart to Solidity's `%` operator. This function uses a `revert`
352      * opcode (which leaves remaining gas untouched) while Solidity uses an
353      * invalid opcode to revert (consuming all remaining gas).
354      *
355      * Requirements:
356      *
357      * - The divisor cannot be zero.
358      */
359     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
360         return mod(a, b, "SafeMath: modulo by zero");
361     }
362 
363     /**
364      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
365      * Reverts with custom message when dividing by zero.
366      *
367      * Counterpart to Solidity's `%` operator. This function uses a `revert`
368      * opcode (which leaves remaining gas untouched) while Solidity uses an
369      * invalid opcode to revert (consuming all remaining gas).
370      *
371      * Requirements:
372      *
373      * - The divisor cannot be zero.
374      */
375     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
376         require(b != 0, errorMessage);
377         return a % b;
378     }
379 }
380 
381 // Part: WETH
382 
383 interface WETH {
384     function deposit() external payable;
385 }
386 
387 // Part: IVaultAPI
388 
389 interface IVaultAPI is IERC20 {
390     function deposit(uint256 _amount, address recipient)
391         external
392         returns (uint256 shares);
393 
394     function withdraw(uint256 _shares) external;
395 
396     function token() external view returns (address);
397 
398     function permit(
399         address owner,
400         address spender,
401         uint256 value,
402         uint256 deadline,
403         bytes calldata signature
404     ) external returns (bool);
405 }
406 
407 // Part: OpenZeppelin/openzeppelin-contracts@3.1.0/SafeERC20
408 
409 /**
410  * @title SafeERC20
411  * @dev Wrappers around ERC20 operations that throw on failure (when the token
412  * contract returns false). Tokens that return no value (and instead revert or
413  * throw on failure) are also supported, non-reverting calls are assumed to be
414  * successful.
415  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
416  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
417  */
418 library SafeERC20 {
419     using SafeMath for uint256;
420     using Address for address;
421 
422     function safeTransfer(IERC20 token, address to, uint256 value) internal {
423         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
424     }
425 
426     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
427         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
428     }
429 
430     /**
431      * @dev Deprecated. This function has issues similar to the ones found in
432      * {IERC20-approve}, and its usage is discouraged.
433      *
434      * Whenever possible, use {safeIncreaseAllowance} and
435      * {safeDecreaseAllowance} instead.
436      */
437     function safeApprove(IERC20 token, address spender, uint256 value) internal {
438         // safeApprove should only be called when setting an initial allowance,
439         // or when resetting it to zero. To increase and decrease it, use
440         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
441         // solhint-disable-next-line max-line-length
442         require((value == 0) || (token.allowance(address(this), spender) == 0),
443             "SafeERC20: approve from non-zero to non-zero allowance"
444         );
445         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
446     }
447 
448     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
449         uint256 newAllowance = token.allowance(address(this), spender).add(value);
450         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
451     }
452 
453     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
454         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
455         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
456     }
457 
458     /**
459      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
460      * on the return value: the return value is optional (but if data is returned, it must not be false).
461      * @param token The token targeted by the call.
462      * @param data The call data (encoded using abi.encode or one of its variants).
463      */
464     function _callOptionalReturn(IERC20 token, bytes memory data) private {
465         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
466         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
467         // the target address contains contract code and also asserts for success in the low-level call.
468 
469         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
470         if (returndata.length > 0) { // Return data is optional
471             // solhint-disable-next-line max-line-length
472             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
473         }
474     }
475 }
476 
477 // File: ZapYvWETH.sol
478 
479 contract ZapYvWETH {
480     using SafeMath for uint256;
481     using SafeERC20 for IERC20;
482 
483     address public constant weth =
484         address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
485     address public constant yvWETH =
486         address(0xa9fE4601811213c340e850ea305481afF02f5b28);
487 
488     constructor() public {
489         // Setup approvals
490         IERC20(weth).safeApprove(yvWETH, uint256(-1));
491     }
492 
493     receive() external payable {
494         depositETH();
495     }
496 
497     function depositETH() public payable {
498         WETH(weth).deposit{value: msg.value}();
499         uint256 _amount = IERC20(weth).balanceOf(address(this));
500         IVaultAPI vault = IVaultAPI(yvWETH);
501 
502         IVaultAPI(vault).deposit(_amount, msg.sender);
503     }
504 }
