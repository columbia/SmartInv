1 // File: @openzeppelin/contracts/utils/Counters.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @title Counters
9  * @author Matt Condon (@shrugs)
10  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
11  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
12  *
13  * Include with `using Counters for Counters.Counter;`
14  */
15 library Counters {
16     struct Counter {
17         // This variable should never be directly accessed by users of the library: interactions must be restricted to
18         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
19         // this feature: see https://github.com/ethereum/solidity/issues/4637
20         uint256 _value; // default: 0
21     }
22 
23     function current(Counter storage counter) internal view returns (uint256) {
24         return counter._value;
25     }
26 
27     function increment(Counter storage counter) internal {
28         unchecked {
29             counter._value += 1;
30         }
31     }
32 
33     function decrement(Counter storage counter) internal {
34         uint256 value = counter._value;
35         require(value > 0, "Counter: decrement overflow");
36         unchecked {
37             counter._value = value - 1;
38         }
39     }
40 }
41 
42 // File: @openzeppelin/contracts/utils/Context.sol
43 
44 
45 
46 pragma solidity ^0.8.0;
47 
48 /*
49  * @dev Provides information about the current execution context, including the
50  * sender of the transaction and its data. While these are generally available
51  * via msg.sender and msg.data, they should not be accessed in such a direct
52  * manner, since when dealing with meta-transactions the account sending and
53  * paying for execution may not be the actual sender (as far as an application
54  * is concerned).
55  *
56  * This contract is only required for intermediate, library-like contracts.
57  */
58 abstract contract Context {
59     function _msgSender() internal view virtual returns (address) {
60         return msg.sender;
61     }
62 
63     function _msgData() internal view virtual returns (bytes calldata) {
64         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
65         return msg.data;
66     }
67 }
68 
69 // File: @openzeppelin/contracts/access/Ownable.sol
70 
71 
72 
73 pragma solidity ^0.8.0;
74 
75 /**
76  * @dev Contract module which provides a basic access control mechanism, where
77  * there is an account (an owner) that can be granted exclusive access to
78  * specific functions.
79  *
80  * By default, the owner account will be the one that deploys the contract. This
81  * can later be changed with {transferOwnership}.
82  *
83  * This module is used through inheritance. It will make available the modifier
84  * `onlyOwner`, which can be applied to your functions to restrict their use to
85  * the owner.
86  */
87 abstract contract Ownable is Context {
88     address private _owner;
89 
90     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
91 
92     /**
93      * @dev Initializes the contract setting the deployer as the initial owner.
94      */
95     constructor () {
96         address msgSender = _msgSender();
97         _owner = msgSender;
98         emit OwnershipTransferred(address(0), msgSender);
99     }
100 
101     /**
102      * @dev Returns the address of the current owner.
103      */
104     function owner() public view virtual returns (address) {
105         return _owner;
106     }
107 
108     /**
109      * @dev Throws if called by any account other than the owner.
110      */
111     modifier onlyOwner() {
112         require(owner() == _msgSender(), "Ownable: caller is not the owner");
113         _;
114     }
115 
116     /**
117      * @dev Leaves the contract without owner. It will not be possible to call
118      * `onlyOwner` functions anymore. Can only be called by the current owner.
119      *
120      * NOTE: Renouncing ownership will leave the contract without an owner,
121      * thereby removing any functionality that is only available to the owner.
122      */
123     function renounceOwnership() public virtual onlyOwner {
124         emit OwnershipTransferred(_owner, address(0));
125         _owner = address(0);
126     }
127 
128     /**
129      * @dev Transfers ownership of the contract to a new account (`newOwner`).
130      * Can only be called by the current owner.
131      */
132     function transferOwnership(address newOwner) public virtual onlyOwner {
133         require(newOwner != address(0), "Ownable: new owner is the zero address");
134         emit OwnershipTransferred(_owner, newOwner);
135         _owner = newOwner;
136     }
137 }
138 
139 // File: @openzeppelin/contracts/utils/Address.sol
140 
141 pragma solidity ^0.8.0;
142 
143 /**
144  * @dev Collection of functions related to the address type
145  */
146 library Address {
147     /**
148      * @dev Returns true if `account` is a contract.
149      *
150      * [IMPORTANT]
151      * ====
152      * It is unsafe to assume that an address for which this function returns
153      * false is an externally-owned account (EOA) and not a contract.
154      *
155      * Among others, `isContract` will return false for the following
156      * types of addresses:
157      *
158      *  - an externally-owned account
159      *  - a contract in construction
160      *  - an address where a contract will be created
161      *  - an address where a contract lived, but was destroyed
162      * ====
163      */
164     function isContract(address account) internal view returns (bool) {
165         // This method relies on extcodesize, which returns 0 for contracts in
166         // construction, since the code is only stored at the end of the
167         // constructor execution.
168 
169         uint256 size;
170         // solhint-disable-next-line no-inline-assembly
171         assembly { size := extcodesize(account) }
172         return size > 0;
173     }
174 
175     /**
176      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
177      * `recipient`, forwarding all available gas and reverting on errors.
178      *
179      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
180      * of certain opcodes, possibly making contracts go over the 2300 gas limit
181      * imposed by `transfer`, making them unable to receive funds via
182      * `transfer`. {sendValue} removes this limitation.
183      *
184      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
185      *
186      * IMPORTANT: because control is transferred to `recipient`, care must be
187      * taken to not create reentrancy vulnerabilities. Consider using
188      * {ReentrancyGuard} or the
189      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
190      */
191     function sendValue(address payable recipient, uint256 amount) internal {
192         require(address(this).balance >= amount, "Address: insufficient balance");
193 
194         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
195         (bool success, ) = recipient.call{ value: amount }("");
196         require(success, "Address: unable to send value, recipient may have reverted");
197     }
198 
199     /**
200      * @dev Performs a Solidity function call using a low level `call`. A
201      * plain`call` is an unsafe replacement for a function call: use this
202      * function instead.
203      *
204      * If `target` reverts with a revert reason, it is bubbled up by this
205      * function (like regular Solidity function calls).
206      *
207      * Returns the raw returned data. To convert to the expected return value,
208      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
209      *
210      * Requirements:
211      *
212      * - `target` must be a contract.
213      * - calling `target` with `data` must not revert.
214      *
215      * _Available since v3.1._
216      */
217     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
218       return functionCall(target, data, "Address: low-level call failed");
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
223      * `errorMessage` as a fallback revert reason when `target` reverts.
224      *
225      * _Available since v3.1._
226      */
227     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
228         return functionCallWithValue(target, data, 0, errorMessage);
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
233      * but also transferring `value` wei to `target`.
234      *
235      * Requirements:
236      *
237      * - the calling contract must have an ETH balance of at least `value`.
238      * - the called Solidity function must be `payable`.
239      *
240      * _Available since v3.1._
241      */
242     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
243         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
244     }
245 
246     /**
247      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
248      * with `errorMessage` as a fallback revert reason when `target` reverts.
249      *
250      * _Available since v3.1._
251      */
252     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
253         require(address(this).balance >= value, "Address: insufficient balance for call");
254         require(isContract(target), "Address: call to non-contract");
255 
256         // solhint-disable-next-line avoid-low-level-calls
257         (bool success, bytes memory returndata) = target.call{ value: value }(data);
258         return _verifyCallResult(success, returndata, errorMessage);
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
263      * but performing a static call.
264      *
265      * _Available since v3.3._
266      */
267     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
268         return functionStaticCall(target, data, "Address: low-level static call failed");
269     }
270 
271     /**
272      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
273      * but performing a static call.
274      *
275      * _Available since v3.3._
276      */
277     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
278         require(isContract(target), "Address: static call to non-contract");
279 
280         // solhint-disable-next-line avoid-low-level-calls
281         (bool success, bytes memory returndata) = target.staticcall(data);
282         return _verifyCallResult(success, returndata, errorMessage);
283     }
284 
285     /**
286      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
287      * but performing a delegate call.
288      *
289      * _Available since v3.4._
290      */
291     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
292         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
297      * but performing a delegate call.
298      *
299      * _Available since v3.4._
300      */
301     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
302         require(isContract(target), "Address: delegate call to non-contract");
303 
304         // solhint-disable-next-line avoid-low-level-calls
305         (bool success, bytes memory returndata) = target.delegatecall(data);
306         return _verifyCallResult(success, returndata, errorMessage);
307     }
308 
309     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
310         if (success) {
311             return returndata;
312         } else {
313             // Look for revert reason and bubble it up if present
314             if (returndata.length > 0) {
315                 // The easiest way to bubble the revert reason is using memory via assembly
316 
317                 // solhint-disable-next-line no-inline-assembly
318                 assembly {
319                     let returndata_size := mload(returndata)
320                     revert(add(32, returndata), returndata_size)
321                 }
322             } else {
323                 revert(errorMessage);
324             }
325         }
326     }
327 }
328 
329 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
330 
331 
332 pragma solidity ^0.8.0;
333 
334 /**
335  * @dev Interface of the ERC20 standard as defined in the EIP.
336  */
337 interface IERC20 {
338     /**
339      * @dev Returns the amount of tokens in existence.
340      */
341     function totalSupply() external view returns (uint256);
342 
343     /**
344      * @dev Returns the amount of tokens owned by `account`.
345      */
346     function balanceOf(address account) external view returns (uint256);
347 
348     /**
349      * @dev Moves `amount` tokens from the caller's account to `recipient`.
350      *
351      * Returns a boolean value indicating whether the operation succeeded.
352      *
353      * Emits a {Transfer} event.
354      */
355     function transfer(address recipient, uint256 amount) external returns (bool);
356 
357     /**
358      * @dev Returns the remaining number of tokens that `spender` will be
359      * allowed to spend on behalf of `owner` through {transferFrom}. This is
360      * zero by default.
361      *
362      * This value changes when {approve} or {transferFrom} are called.
363      */
364     function allowance(address owner, address spender) external view returns (uint256);
365 
366     /**
367      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
368      *
369      * Returns a boolean value indicating whether the operation succeeded.
370      *
371      * IMPORTANT: Beware that changing an allowance with this method brings the risk
372      * that someone may use both the old and the new allowance by unfortunate
373      * transaction ordering. One possible solution to mitigate this race
374      * condition is to first reduce the spender's allowance to 0 and set the
375      * desired value afterwards:
376      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
377      *
378      * Emits an {Approval} event.
379      */
380     function approve(address spender, uint256 amount) external returns (bool);
381 
382     /**
383      * @dev Moves `amount` tokens from `sender` to `recipient` using the
384      * allowance mechanism. `amount` is then deducted from the caller's
385      * allowance.
386      *
387      * Returns a boolean value indicating whether the operation succeeded.
388      *
389      * Emits a {Transfer} event.
390      */
391     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
392 
393     /**
394      * @dev Emitted when `value` tokens are moved from one account (`from`) to
395      * another (`to`).
396      *
397      * Note that `value` may be zero.
398      */
399     event Transfer(address indexed from, address indexed to, uint256 value);
400 
401     /**
402      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
403      * a call to {approve}. `value` is the new allowance.
404      */
405     event Approval(address indexed owner, address indexed spender, uint256 value);
406 }
407 
408 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
409 
410 
411 pragma solidity ^0.8.0;
412 
413 
414 
415 /**
416  * @title SafeERC20
417  * @dev Wrappers around ERC20 operations that throw on failure (when the token
418  * contract returns false). Tokens that return no value (and instead revert or
419  * throw on failure) are also supported, non-reverting calls are assumed to be
420  * successful.
421  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
422  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
423  */
424 library SafeERC20 {
425     using Address for address;
426 
427     function safeTransfer(IERC20 token, address to, uint256 value) internal {
428         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
429     }
430 
431     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
432         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
433     }
434 
435     /**
436      * @dev Deprecated. This function has issues similar to the ones found in
437      * {IERC20-approve}, and its usage is discouraged.
438      *
439      * Whenever possible, use {safeIncreaseAllowance} and
440      * {safeDecreaseAllowance} instead.
441      */
442     function safeApprove(IERC20 token, address spender, uint256 value) internal {
443         // safeApprove should only be called when setting an initial allowance,
444         // or when resetting it to zero. To increase and decrease it, use
445         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
446         // solhint-disable-next-line max-line-length
447         require((value == 0) || (token.allowance(address(this), spender) == 0),
448             "SafeERC20: approve from non-zero to non-zero allowance"
449         );
450         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
451     }
452 
453     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
454         uint256 newAllowance = token.allowance(address(this), spender) + value;
455         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
456     }
457 
458     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
459         unchecked {
460             uint256 oldAllowance = token.allowance(address(this), spender);
461             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
462             uint256 newAllowance = oldAllowance - value;
463             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
464         }
465     }
466 
467     /**
468      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
469      * on the return value: the return value is optional (but if data is returned, it must not be false).
470      * @param token The token targeted by the call.
471      * @param data The call data (encoded using abi.encode or one of its variants).
472      */
473     function _callOptionalReturn(IERC20 token, bytes memory data) private {
474         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
475         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
476         // the target address contains contract code and also asserts for success in the low-level call.
477 
478         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
479         if (returndata.length > 0) { // Return data is optional
480             // solhint-disable-next-line max-line-length
481             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
482         }
483     }
484 }
485 
486 
487 
488 pragma solidity ^0.8.0;
489 
490 
491 //SPDX-License-Identifier: MIT
492 
493 contract ImpulseVENVesting is Ownable {
494     using SafeERC20 for IERC20;
495     using Counters for Counters.Counter;
496     
497     Counters.Counter public totalUsersClaimed;
498     IERC20 public token;
499     mapping(address => uint256) public userClaimable;
500     bool public isClaimable;
501     
502     constructor(IERC20 _token){
503         token = _token;
504     }
505     
506     function addBeneficiaryInfo(address[] memory _beneficiaries, uint256[] memory _amounts) external onlyOwner{
507         require(_beneficiaries.length == _amounts.length,"Array lengths do not match");
508     
509         for(uint i = 0; i < _beneficiaries.length; i++) {
510             userClaimable[_beneficiaries[i]] = _amounts[i];
511         }
512     }
513     
514     function claimAmount() external {
515         require(isClaimable, "Amount can't be claimed now");
516         uint256 claimableAmount = userClaimable[msg.sender];
517         require(claimableAmount > 0,"Nothing to claim");
518         
519         token.safeTransfer(msg.sender,claimableAmount);
520         userClaimable[msg.sender] = 0;
521         totalUsersClaimed.increment();
522     }
523     
524     function adminWithdraw(uint256 _amount) external onlyOwner {
525         token.safeTransfer(msg.sender,_amount);
526     } 
527     
528     function toggleIsClaimable() external onlyOwner {
529         isClaimable ? isClaimable = false : isClaimable = true;
530     } 
531     
532     function tokenBalance() external view returns (uint256) {
533         return token.balanceOf(address(this));
534     }
535 
536 }