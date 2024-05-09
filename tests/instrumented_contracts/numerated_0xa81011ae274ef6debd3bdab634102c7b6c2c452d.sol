1 // File: contracts/Payout.sol
2 
3 
4 pragma solidity ^0.8.7;
5 
6 
7 contract Payout {
8     address private owner;
9     address[] private spenders;
10 
11     modifier isOwner(){
12         require(msg.sender == owner, "For Owner only");
13         _;
14     }
15 
16     modifier isOwnerOrSpender(){
17         require(msg.sender == owner || isSpender(msg.sender), "For Owner or Spender only");
18         _;
19     }
20     
21     function isSpender(address item) internal view returns (bool) {
22         for (uint i=0; i<spenders.length; i++) {
23             if (spenders[i]==item){
24                 return true;
25             }
26         }
27         return false;
28     }
29 
30     constructor() {
31         owner = msg.sender;
32     }
33 
34     function setOwner(address newOwner) external isOwner {
35         owner = newOwner;
36     }
37 
38     function setSpenders(address[] calldata newSpenders) external isOwner {
39         spenders = newSpenders;
40     }
41 
42     function getOwner() external view returns (address) {
43         return owner;
44     }
45 
46     function getSpenders() external view returns (address[] memory) {
47         return spenders;
48     }
49 
50     function payoutERC20Batch(IERC20[] calldata tokens, address[] calldata recipients, uint[] calldata amounts) external isOwnerOrSpender {
51         require(tokens.length == amounts.length && amounts.length == recipients.length, "Different arguments length");
52         for (uint i=0; i<tokens.length; i++) {
53             SafeERC20.safeTransfer(tokens[i], recipients[i], amounts[i]);
54         }
55     }
56 
57     function payoutETHBatch(address payable[] calldata recipients, uint[] calldata amounts) external isOwnerOrSpender {
58         require(recipients.length == amounts.length, "Different arguments length");
59         for (uint i=0; i<recipients.length; i++) {
60             Address.sendValue(recipients[i], amounts[i]);
61         }
62     }
63     
64     receive() external payable {
65 
66     }
67 }
68 
69 // File: @openzeppelin/contracts/utils/Address.sol
70 
71 
72 
73 pragma solidity ^0.8.0;
74 
75 /**
76  * @dev Collection of functions related to the address type
77  */
78 library Address {
79     /**
80      * @dev Returns true if `account` is a contract.
81      *
82      * [IMPORTANT]
83      * ====
84      * It is unsafe to assume that an address for which this function returns
85      * false is an externally-owned account (EOA) and not a contract.
86      *
87      * Among others, `isContract` will return false for the following
88      * types of addresses:
89      *
90      *  - an externally-owned account
91      *  - a contract in construction
92      *  - an address where a contract will be created
93      *  - an address where a contract lived, but was destroyed
94      * ====
95      */
96     function isContract(address account) internal view returns (bool) {
97         // This method relies on extcodesize, which returns 0 for contracts in
98         // construction, since the code is only stored at the end of the
99         // constructor execution.
100 
101         uint256 size;
102         assembly {
103             size := extcodesize(account)
104         }
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
127         (bool success, ) = recipient.call{value: amount}("");
128         require(success, "Address: unable to send value, recipient may have reverted");
129     }
130 
131     /**
132      * @dev Performs a Solidity function call using a low level `call`. A
133      * plain `call` is an unsafe replacement for a function call: use this
134      * function instead.
135      *
136      * If `target` reverts with a revert reason, it is bubbled up by this
137      * function (like regular Solidity function calls).
138      *
139      * Returns the raw returned data. To convert to the expected return value,
140      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
141      *
142      * Requirements:
143      *
144      * - `target` must be a contract.
145      * - calling `target` with `data` must not revert.
146      *
147      * _Available since v3.1._
148      */
149     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
150         return functionCall(target, data, "Address: low-level call failed");
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
155      * `errorMessage` as a fallback revert reason when `target` reverts.
156      *
157      * _Available since v3.1._
158      */
159     function functionCall(
160         address target,
161         bytes memory data,
162         string memory errorMessage
163     ) internal returns (bytes memory) {
164         return functionCallWithValue(target, data, 0, errorMessage);
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
178     function functionCallWithValue(
179         address target,
180         bytes memory data,
181         uint256 value
182     ) internal returns (bytes memory) {
183         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
188      * with `errorMessage` as a fallback revert reason when `target` reverts.
189      *
190      * _Available since v3.1._
191      */
192     function functionCallWithValue(
193         address target,
194         bytes memory data,
195         uint256 value,
196         string memory errorMessage
197     ) internal returns (bytes memory) {
198         require(address(this).balance >= value, "Address: insufficient balance for call");
199         require(isContract(target), "Address: call to non-contract");
200 
201         (bool success, bytes memory returndata) = target.call{value: value}(data);
202         return verifyCallResult(success, returndata, errorMessage);
203     }
204 
205     /**
206      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
207      * but performing a static call.
208      *
209      * _Available since v3.3._
210      */
211     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
212         return functionStaticCall(target, data, "Address: low-level static call failed");
213     }
214 
215     /**
216      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
217      * but performing a static call.
218      *
219      * _Available since v3.3._
220      */
221     function functionStaticCall(
222         address target,
223         bytes memory data,
224         string memory errorMessage
225     ) internal view returns (bytes memory) {
226         require(isContract(target), "Address: static call to non-contract");
227 
228         (bool success, bytes memory returndata) = target.staticcall(data);
229         return verifyCallResult(success, returndata, errorMessage);
230     }
231 
232     /**
233      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
234      * but performing a delegate call.
235      *
236      * _Available since v3.4._
237      */
238     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
239         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
240     }
241 
242     /**
243      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
244      * but performing a delegate call.
245      *
246      * _Available since v3.4._
247      */
248     function functionDelegateCall(
249         address target,
250         bytes memory data,
251         string memory errorMessage
252     ) internal returns (bytes memory) {
253         require(isContract(target), "Address: delegate call to non-contract");
254 
255         (bool success, bytes memory returndata) = target.delegatecall(data);
256         return verifyCallResult(success, returndata, errorMessage);
257     }
258 
259     /**
260      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
261      * revert reason using the provided one.
262      *
263      * _Available since v4.3._
264      */
265     function verifyCallResult(
266         bool success,
267         bytes memory returndata,
268         string memory errorMessage
269     ) internal pure returns (bytes memory) {
270         if (success) {
271             return returndata;
272         } else {
273             // Look for revert reason and bubble it up if present
274             if (returndata.length > 0) {
275                 // The easiest way to bubble the revert reason is using memory via assembly
276 
277                 assembly {
278                     let returndata_size := mload(returndata)
279                     revert(add(32, returndata), returndata_size)
280                 }
281             } else {
282                 revert(errorMessage);
283             }
284         }
285     }
286 }
287 
288 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
289 
290 
291 
292 pragma solidity ^0.8.0;
293 
294 /**
295  * @dev Interface of the ERC20 standard as defined in the EIP.
296  */
297 interface IERC20 {
298     /**
299      * @dev Returns the amount of tokens in existence.
300      */
301     function totalSupply() external view returns (uint256);
302 
303     /**
304      * @dev Returns the amount of tokens owned by `account`.
305      */
306     function balanceOf(address account) external view returns (uint256);
307 
308     /**
309      * @dev Moves `amount` tokens from the caller's account to `recipient`.
310      *
311      * Returns a boolean value indicating whether the operation succeeded.
312      *
313      * Emits a {Transfer} event.
314      */
315     function transfer(address recipient, uint256 amount) external returns (bool);
316 
317     /**
318      * @dev Returns the remaining number of tokens that `spender` will be
319      * allowed to spend on behalf of `owner` through {transferFrom}. This is
320      * zero by default.
321      *
322      * This value changes when {approve} or {transferFrom} are called.
323      */
324     function allowance(address owner, address spender) external view returns (uint256);
325 
326     /**
327      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
328      *
329      * Returns a boolean value indicating whether the operation succeeded.
330      *
331      * IMPORTANT: Beware that changing an allowance with this method brings the risk
332      * that someone may use both the old and the new allowance by unfortunate
333      * transaction ordering. One possible solution to mitigate this race
334      * condition is to first reduce the spender's allowance to 0 and set the
335      * desired value afterwards:
336      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
337      *
338      * Emits an {Approval} event.
339      */
340     function approve(address spender, uint256 amount) external returns (bool);
341 
342     /**
343      * @dev Moves `amount` tokens from `sender` to `recipient` using the
344      * allowance mechanism. `amount` is then deducted from the caller's
345      * allowance.
346      *
347      * Returns a boolean value indicating whether the operation succeeded.
348      *
349      * Emits a {Transfer} event.
350      */
351     function transferFrom(
352         address sender,
353         address recipient,
354         uint256 amount
355     ) external returns (bool);
356 
357     /**
358      * @dev Emitted when `value` tokens are moved from one account (`from`) to
359      * another (`to`).
360      *
361      * Note that `value` may be zero.
362      */
363     event Transfer(address indexed from, address indexed to, uint256 value);
364 
365     /**
366      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
367      * a call to {approve}. `value` is the new allowance.
368      */
369     event Approval(address indexed owner, address indexed spender, uint256 value);
370 }
371 
372 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
373 
374 
375 
376 pragma solidity ^0.8.0;
377 
378 
379 
380 /**
381  * @title SafeERC20
382  * @dev Wrappers around ERC20 operations that throw on failure (when the token
383  * contract returns false). Tokens that return no value (and instead revert or
384  * throw on failure) are also supported, non-reverting calls are assumed to be
385  * successful.
386  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
387  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
388  */
389 library SafeERC20 {
390     using Address for address;
391 
392     function safeTransfer(
393         IERC20 token,
394         address to,
395         uint256 value
396     ) internal {
397         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
398     }
399 
400     function safeTransferFrom(
401         IERC20 token,
402         address from,
403         address to,
404         uint256 value
405     ) internal {
406         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
407     }
408 
409     /**
410      * @dev Deprecated. This function has issues similar to the ones found in
411      * {IERC20-approve}, and its usage is discouraged.
412      *
413      * Whenever possible, use {safeIncreaseAllowance} and
414      * {safeDecreaseAllowance} instead.
415      */
416     function safeApprove(
417         IERC20 token,
418         address spender,
419         uint256 value
420     ) internal {
421         // safeApprove should only be called when setting an initial allowance,
422         // or when resetting it to zero. To increase and decrease it, use
423         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
424         require(
425             (value == 0) || (token.allowance(address(this), spender) == 0),
426             "SafeERC20: approve from non-zero to non-zero allowance"
427         );
428         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
429     }
430 
431     function safeIncreaseAllowance(
432         IERC20 token,
433         address spender,
434         uint256 value
435     ) internal {
436         uint256 newAllowance = token.allowance(address(this), spender) + value;
437         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
438     }
439 
440     function safeDecreaseAllowance(
441         IERC20 token,
442         address spender,
443         uint256 value
444     ) internal {
445         unchecked {
446             uint256 oldAllowance = token.allowance(address(this), spender);
447             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
448             uint256 newAllowance = oldAllowance - value;
449             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
450         }
451     }
452 
453     /**
454      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
455      * on the return value: the return value is optional (but if data is returned, it must not be false).
456      * @param token The token targeted by the call.
457      * @param data The call data (encoded using abi.encode or one of its variants).
458      */
459     function _callOptionalReturn(IERC20 token, bytes memory data) private {
460         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
461         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
462         // the target address contains contract code and also asserts for success in the low-level call.
463 
464         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
465         if (returndata.length > 0) {
466             // Return data is optional
467             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
468         }
469     }
470 }