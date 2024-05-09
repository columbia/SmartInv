1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 /**
80  * @dev Collection of functions related to the address type
81  */
82 library Address {
83     /**
84      * @dev Returns true if `account` is a contract.
85      *
86      * [IMPORTANT]
87      * ====
88      * It is unsafe to assume that an address for which this function returns
89      * false is an externally-owned account (EOA) and not a contract.
90      *
91      * Among others, `isContract` will return false for the following
92      * types of addresses:
93      *
94      *  - an externally-owned account
95      *  - a contract in construction
96      *  - an address where a contract will be created
97      *  - an address where a contract lived, but was destroyed
98      * ====
99      */
100     function isContract(address account) internal view returns (bool) {
101         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
102         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
103         // for accounts without code, i.e. `keccak256('')`
104         bytes32 codehash;
105         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
106         // solhint-disable-next-line no-inline-assembly
107         assembly { codehash := extcodehash(account) }
108         return (codehash != accountHash && codehash != 0x0);
109     }
110 
111     /**
112      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
113      * `recipient`, forwarding all available gas and reverting on errors.
114      *
115      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
116      * of certain opcodes, possibly making contracts go over the 2300 gas limit
117      * imposed by `transfer`, making them unable to receive funds via
118      * `transfer`. {sendValue} removes this limitation.
119      *
120      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
121      *
122      * IMPORTANT: because control is transferred to `recipient`, care must be
123      * taken to not create reentrancy vulnerabilities. Consider using
124      * {ReentrancyGuard} or the
125      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
126      */
127     function sendValue(address payable recipient, uint256 amount) internal {
128         require(address(this).balance >= amount, "Address: insufficient balance");
129 
130         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
131         (bool success, ) = recipient.call{ value: amount }("");
132         require(success, "Address: unable to send value, recipient may have reverted");
133     }
134 
135     /**
136      * @dev Performs a Solidity function call using a low level `call`. A
137      * plain`call` is an unsafe replacement for a function call: use this
138      * function instead.
139      *
140      * If `target` reverts with a revert reason, it is bubbled up by this
141      * function (like regular Solidity function calls).
142      *
143      * Returns the raw returned data. To convert to the expected return value,
144      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
145      *
146      * Requirements:
147      *
148      * - `target` must be a contract.
149      * - calling `target` with `data` must not revert.
150      *
151      * _Available since v3.1._
152      */
153     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
154       return functionCall(target, data, "Address: low-level call failed");
155     }
156 
157     /**
158      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
159      * `errorMessage` as a fallback revert reason when `target` reverts.
160      *
161      * _Available since v3.1._
162      */
163     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
164         return _functionCallWithValue(target, data, 0, errorMessage);
165     }
166 
167     /**
168      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
169      * but also transferring `value` wei to `target`.
170      *
171      * Requirements:
172      *
173      * - the calling contract must have an ETH balance of at least `value`.
174      * - the called Solidity function must be `payable`.
175      *
176      * _Available since v3.1._
177      */
178     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
179         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
184      * with `errorMessage` as a fallback revert reason when `target` reverts.
185      *
186      * _Available since v3.1._
187      */
188     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
189         require(address(this).balance >= value, "Address: insufficient balance for call");
190         return _functionCallWithValue(target, data, value, errorMessage);
191     }
192 
193     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
194         require(isContract(target), "Address: call to non-contract");
195 
196         // solhint-disable-next-line avoid-low-level-calls
197         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
198         if (success) {
199             return returndata;
200         } else {
201             // Look for revert reason and bubble it up if present
202             if (returndata.length > 0) {
203                 // The easiest way to bubble the revert reason is using memory via assembly
204 
205                 // solhint-disable-next-line no-inline-assembly
206                 assembly {
207                     let returndata_size := mload(returndata)
208                     revert(add(32, returndata), returndata_size)
209                 }
210             } else {
211                 revert(errorMessage);
212             }
213         }
214     }
215 }
216 
217 
218 /**
219  * @dev Wrappers over Solidity's arithmetic operations with added overflow
220  * checks.
221  *
222  * Arithmetic operations in Solidity wrap on overflow. This can easily result
223  * in bugs, because programmers usually assume that an overflow raises an
224  * error, which is the standard behavior in high level programming languages.
225  * `SafeMath` restores this intuition by reverting the transaction when an
226  * operation overflows.
227  *
228  * Using this library instead of the unchecked operations eliminates an entire
229  * class of bugs, so it's recommended to use it always.
230  */
231 library SafeMath {
232     /**
233      * @dev Returns the addition of two unsigned integers, reverting on
234      * overflow.
235      *
236      * Counterpart to Solidity's `+` operator.
237      *
238      * Requirements:
239      *
240      * - Addition cannot overflow.
241      */
242     function add(uint256 a, uint256 b) internal pure returns (uint256) {
243         uint256 c = a + b;
244         require(c >= a, "SafeMath: addition overflow");
245 
246         return c;
247     }
248 
249     /**
250      * @dev Returns the subtraction of two unsigned integers, reverting on
251      * overflow (when the result is negative).
252      *
253      * Counterpart to Solidity's `-` operator.
254      *
255      * Requirements:
256      *
257      * - Subtraction cannot overflow.
258      */
259     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
260         return sub(a, b, "SafeMath: subtraction overflow");
261     }
262 
263     /**
264      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
265      * overflow (when the result is negative).
266      *
267      * Counterpart to Solidity's `-` operator.
268      *
269      * Requirements:
270      *
271      * - Subtraction cannot overflow.
272      */
273     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
274         require(b <= a, errorMessage);
275         uint256 c = a - b;
276 
277         return c;
278     }
279 
280     /**
281      * @dev Returns the multiplication of two unsigned integers, reverting on
282      * overflow.
283      *
284      * Counterpart to Solidity's `*` operator.
285      *
286      * Requirements:
287      *
288      * - Multiplication cannot overflow.
289      */
290     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
291         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
292         // benefit is lost if 'b' is also tested.
293         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
294         if (a == 0) {
295             return 0;
296         }
297 
298         uint256 c = a * b;
299         require(c / a == b, "SafeMath: multiplication overflow");
300 
301         return c;
302     }
303 
304     /**
305      * @dev Returns the integer division of two unsigned integers. Reverts on
306      * division by zero. The result is rounded towards zero.
307      *
308      * Counterpart to Solidity's `/` operator. Note: this function uses a
309      * `revert` opcode (which leaves remaining gas untouched) while Solidity
310      * uses an invalid opcode to revert (consuming all remaining gas).
311      *
312      * Requirements:
313      *
314      * - The divisor cannot be zero.
315      */
316     function div(uint256 a, uint256 b) internal pure returns (uint256) {
317         return div(a, b, "SafeMath: division by zero");
318     }
319 
320     /**
321      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
322      * division by zero. The result is rounded towards zero.
323      *
324      * Counterpart to Solidity's `/` operator. Note: this function uses a
325      * `revert` opcode (which leaves remaining gas untouched) while Solidity
326      * uses an invalid opcode to revert (consuming all remaining gas).
327      *
328      * Requirements:
329      *
330      * - The divisor cannot be zero.
331      */
332     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
333         require(b > 0, errorMessage);
334         uint256 c = a / b;
335         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
336 
337         return c;
338     }
339 
340     /**
341      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
342      * Reverts when dividing by zero.
343      *
344      * Counterpart to Solidity's `%` operator. This function uses a `revert`
345      * opcode (which leaves remaining gas untouched) while Solidity uses an
346      * invalid opcode to revert (consuming all remaining gas).
347      *
348      * Requirements:
349      *
350      * - The divisor cannot be zero.
351      */
352     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
353         return mod(a, b, "SafeMath: modulo by zero");
354     }
355 
356     /**
357      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
358      * Reverts with custom message when dividing by zero.
359      *
360      * Counterpart to Solidity's `%` operator. This function uses a `revert`
361      * opcode (which leaves remaining gas untouched) while Solidity uses an
362      * invalid opcode to revert (consuming all remaining gas).
363      *
364      * Requirements:
365      *
366      * - The divisor cannot be zero.
367      */
368     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
369         require(b != 0, errorMessage);
370         return a % b;
371     }
372 }
373 
374 
375 /**
376  * @title SafeERC20
377  * @dev Wrappers around ERC20 operations that throw on failure (when the token
378  * contract returns false). Tokens that return no value (and instead revert or
379  * throw on failure) are also supported, non-reverting calls are assumed to be
380  * successful.
381  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
382  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
383  */
384 library SafeERC20 {
385     using SafeMath for uint256;
386     using Address for address;
387 
388     function safeTransfer(IERC20 token, address to, uint256 value) internal {
389         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
390     }
391 
392     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
393         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
394     }
395 
396     /**
397      * @dev Deprecated. This function has issues similar to the ones found in
398      * {IERC20-approve}, and its usage is discouraged.
399      *
400      * Whenever possible, use {safeIncreaseAllowance} and
401      * {safeDecreaseAllowance} instead.
402      */
403     function safeApprove(IERC20 token, address spender, uint256 value) internal {
404         // safeApprove should only be called when setting an initial allowance,
405         // or when resetting it to zero. To increase and decrease it, use
406         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
407         // solhint-disable-next-line max-line-length
408         require((value == 0) || (token.allowance(address(this), spender) == 0),
409             "SafeERC20: approve from non-zero to non-zero allowance"
410         );
411         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
412     }
413 
414     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
415         uint256 newAllowance = token.allowance(address(this), spender).add(value);
416         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
417     }
418 
419     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
420         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
421         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
422     }
423 
424     /**
425      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
426      * on the return value: the return value is optional (but if data is returned, it must not be false).
427      * @param token The token targeted by the call.
428      * @param data The call data (encoded using abi.encode or one of its variants).
429      */
430     function _callOptionalReturn(IERC20 token, bytes memory data) private {
431         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
432         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
433         // the target address contains contract code and also asserts for success in the low-level call.
434 
435         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
436         if (returndata.length > 0) { // Return data is optional
437             // solhint-disable-next-line max-line-length
438             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
439         }
440     }
441 }
442 
443 
444 contract MultiSend {
445     
446     using SafeERC20 for IERC20;
447     
448     address private owner;
449     constructor (address _owner) public {
450         owner = _owner;
451     }
452     
453     function sendMany(IERC20 token, address[] calldata addresses, uint256[] calldata amounts) external {
454         require(msg.sender == owner);
455         require(addresses.length == amounts.length);
456         for (uint i = 0; i < addresses.length; i++) {
457             token.safeTransfer(addresses[i], amounts[i]);
458         }
459         
460     }
461     
462     
463 }