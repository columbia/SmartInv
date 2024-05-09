1 pragma solidity 0.8.0;
2 
3 
4 // SPDX-License-Identifier: MIT
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
79 
80 /**
81  * @dev Collection of functions related to the address type
82  */
83 library Address {
84     /**
85      * @dev Returns true if `account` is a contract.
86      *
87      * [IMPORTANT]
88      * ====
89      * It is unsafe to assume that an address for which this function returns
90      * false is an externally-owned account (EOA) and not a contract.
91      *
92      * Among others, `isContract` will return false for the following
93      * types of addresses:
94      *
95      *  - an externally-owned account
96      *  - a contract in construction
97      *  - an address where a contract will be created
98      *  - an address where a contract lived, but was destroyed
99      * ====
100      */
101     function isContract(address account) internal view returns (bool) {
102         // This method relies on extcodesize, which returns 0 for contracts in
103         // construction, since the code is only stored at the end of the
104         // constructor execution.
105 
106         uint256 size;
107         // solhint-disable-next-line no-inline-assembly
108         assembly { size := extcodesize(account) }
109         return size > 0;
110     }
111 
112     /**
113      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
114      * `recipient`, forwarding all available gas and reverting on errors.
115      *
116      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
117      * of certain opcodes, possibly making contracts go over the 2300 gas limit
118      * imposed by `transfer`, making them unable to receive funds via
119      * `transfer`. {sendValue} removes this limitation.
120      *
121      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
122      *
123      * IMPORTANT: because control is transferred to `recipient`, care must be
124      * taken to not create reentrancy vulnerabilities. Consider using
125      * {ReentrancyGuard} or the
126      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
127      */
128     function sendValue(address payable recipient, uint256 amount) internal {
129         require(address(this).balance >= amount, "Address: insufficient balance");
130 
131         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
132         (bool success, ) = recipient.call{ value: amount }("");
133         require(success, "Address: unable to send value, recipient may have reverted");
134     }
135 
136     /**
137      * @dev Performs a Solidity function call using a low level `call`. A
138      * plain`call` is an unsafe replacement for a function call: use this
139      * function instead.
140      *
141      * If `target` reverts with a revert reason, it is bubbled up by this
142      * function (like regular Solidity function calls).
143      *
144      * Returns the raw returned data. To convert to the expected return value,
145      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
146      *
147      * Requirements:
148      *
149      * - `target` must be a contract.
150      * - calling `target` with `data` must not revert.
151      *
152      * _Available since v3.1._
153      */
154     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
155       return functionCall(target, data, "Address: low-level call failed");
156     }
157 
158     /**
159      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
160      * `errorMessage` as a fallback revert reason when `target` reverts.
161      *
162      * _Available since v3.1._
163      */
164     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
165         return functionCallWithValue(target, data, 0, errorMessage);
166     }
167 
168     /**
169      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
170      * but also transferring `value` wei to `target`.
171      *
172      * Requirements:
173      *
174      * - the calling contract must have an ETH balance of at least `value`.
175      * - the called Solidity function must be `payable`.
176      *
177      * _Available since v3.1._
178      */
179     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
180         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
185      * with `errorMessage` as a fallback revert reason when `target` reverts.
186      *
187      * _Available since v3.1._
188      */
189     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
190         require(address(this).balance >= value, "Address: insufficient balance for call");
191         require(isContract(target), "Address: call to non-contract");
192 
193         // solhint-disable-next-line avoid-low-level-calls
194         (bool success, bytes memory returndata) = target.call{ value: value }(data);
195         return _verifyCallResult(success, returndata, errorMessage);
196     }
197 
198     /**
199      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
200      * but performing a static call.
201      *
202      * _Available since v3.3._
203      */
204     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
205         return functionStaticCall(target, data, "Address: low-level static call failed");
206     }
207 
208     /**
209      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
210      * but performing a static call.
211      *
212      * _Available since v3.3._
213      */
214     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
215         require(isContract(target), "Address: static call to non-contract");
216 
217         // solhint-disable-next-line avoid-low-level-calls
218         (bool success, bytes memory returndata) = target.staticcall(data);
219         return _verifyCallResult(success, returndata, errorMessage);
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
224      * but performing a delegate call.
225      *
226      * _Available since v3.4._
227      */
228     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
229         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
230     }
231 
232     /**
233      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
234      * but performing a delegate call.
235      *
236      * _Available since v3.4._
237      */
238     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
239         require(isContract(target), "Address: delegate call to non-contract");
240 
241         // solhint-disable-next-line avoid-low-level-calls
242         (bool success, bytes memory returndata) = target.delegatecall(data);
243         return _verifyCallResult(success, returndata, errorMessage);
244     }
245 
246     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
247         if (success) {
248             return returndata;
249         } else {
250             // Look for revert reason and bubble it up if present
251             if (returndata.length > 0) {
252                 // The easiest way to bubble the revert reason is using memory via assembly
253 
254                 // solhint-disable-next-line no-inline-assembly
255                 assembly {
256                     let returndata_size := mload(returndata)
257                     revert(add(32, returndata), returndata_size)
258                 }
259             } else {
260                 revert(errorMessage);
261             }
262         }
263     }
264 }
265 
266 
267 /**
268  * @title SafeERC20
269  * @dev Wrappers around ERC20 operations that throw on failure (when the token
270  * contract returns false). Tokens that return no value (and instead revert or
271  * throw on failure) are also supported, non-reverting calls are assumed to be
272  * successful.
273  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
274  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
275  */
276 library SafeERC20 {
277     using Address for address;
278 
279     function safeTransfer(IERC20 token, address to, uint256 value) internal {
280         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
281     }
282 
283     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
284         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
285     }
286 
287     /**
288      * @dev Deprecated. This function has issues similar to the ones found in
289      * {IERC20-approve}, and its usage is discouraged.
290      *
291      * Whenever possible, use {safeIncreaseAllowance} and
292      * {safeDecreaseAllowance} instead.
293      */
294     function safeApprove(IERC20 token, address spender, uint256 value) internal {
295         // safeApprove should only be called when setting an initial allowance,
296         // or when resetting it to zero. To increase and decrease it, use
297         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
298         // solhint-disable-next-line max-line-length
299         require((value == 0) || (token.allowance(address(this), spender) == 0),
300             "SafeERC20: approve from non-zero to non-zero allowance"
301         );
302         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
303     }
304 
305     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
306         uint256 newAllowance = token.allowance(address(this), spender) + value;
307         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
308     }
309 
310     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
311         unchecked {
312             uint256 oldAllowance = token.allowance(address(this), spender);
313             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
314             uint256 newAllowance = oldAllowance - value;
315             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
316         }
317     }
318 
319     /**
320      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
321      * on the return value: the return value is optional (but if data is returned, it must not be false).
322      * @param token The token targeted by the call.
323      * @param data The call data (encoded using abi.encode or one of its variants).
324      */
325     function _callOptionalReturn(IERC20 token, bytes memory data) private {
326         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
327         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
328         // the target address contains contract code and also asserts for success in the low-level call.
329 
330         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
331         if (returndata.length > 0) { // Return data is optional
332             // solhint-disable-next-line max-line-length
333             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
334         }
335     }
336 }
337 
338 
339 /*
340  * @dev Provides information about the current execution context, including the
341  * sender of the transaction and its data. While these are generally available
342  * via msg.sender and msg.data, they should not be accessed in such a direct
343  * manner, since when dealing with meta-transactions the account sending and
344  * paying for execution may not be the actual sender (as far as an application
345  * is concerned).
346  *
347  * This contract is only required for intermediate, library-like contracts.
348  */
349 abstract contract Context {
350     function _msgSender() internal view virtual returns (address) {
351         return msg.sender;
352     }
353 
354     function _msgData() internal view virtual returns (bytes calldata) {
355         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
356         return msg.data;
357     }
358 }
359 
360 
361 /**
362  * @dev Contract module which provides a basic access control mechanism, where
363  * there is an account (an owner) that can be granted exclusive access to
364  * specific functions.
365  *
366  * By default, the owner account will be the one that deploys the contract. This
367  * can later be changed with {transferOwnership}.
368  *
369  * This module is used through inheritance. It will make available the modifier
370  * `onlyOwner`, which can be applied to your functions to restrict their use to
371  * the owner.
372  */
373 abstract contract Ownable is Context {
374     address private _owner;
375 
376     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
377 
378     /**
379      * @dev Initializes the contract setting the deployer as the initial owner.
380      */
381     constructor () {
382         address msgSender = _msgSender();
383         _owner = msgSender;
384         emit OwnershipTransferred(address(0), msgSender);
385     }
386 
387     /**
388      * @dev Returns the address of the current owner.
389      */
390     function owner() public view virtual returns (address) {
391         return _owner;
392     }
393 
394     /**
395      * @dev Throws if called by any account other than the owner.
396      */
397     modifier onlyOwner() {
398         require(owner() == _msgSender(), "Ownable: caller is not the owner");
399         _;
400     }
401 
402     /**
403      * @dev Leaves the contract without owner. It will not be possible to call
404      * `onlyOwner` functions anymore. Can only be called by the current owner.
405      *
406      * NOTE: Renouncing ownership will leave the contract without an owner,
407      * thereby removing any functionality that is only available to the owner.
408      */
409     function renounceOwnership() public virtual onlyOwner {
410         emit OwnershipTransferred(_owner, address(0));
411         _owner = address(0);
412     }
413 
414     /**
415      * @dev Transfers ownership of the contract to a new account (`newOwner`).
416      * Can only be called by the current owner.
417      */
418     function transferOwnership(address newOwner) public virtual onlyOwner {
419         require(newOwner != address(0), "Ownable: new owner is the zero address");
420         emit OwnershipTransferred(_owner, newOwner);
421         _owner = newOwner;
422     }
423 }
424 
425 
426 contract KumaMigrate {
427     using SafeERC20 for IERC20;
428 
429     address public v1_token;
430     address public v2_token;
431 
432     constructor(address token1, address token2) {
433         v1_token = token1;
434         v2_token = token2;
435     }
436 
437     function _migrate(address userAddress, uint256 amount) internal {
438         require(amount != 0, "Transfer amount must be greater than zero");
439 
440         IERC20(v1_token).safeTransferFrom(userAddress, address(0x000000000000000000000000000000000000dEaD), amount);
441         IERC20(v2_token).safeTransfer(msg.sender, amount);
442     }
443 
444     function migrate(uint256 amount) public {
445         _migrate(msg.sender, amount);
446     }
447 }