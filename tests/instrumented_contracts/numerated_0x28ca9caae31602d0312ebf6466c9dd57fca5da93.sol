1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 // File: @openzeppelin/contracts/utils/Address.sol
107 
108 
109 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
110 
111 pragma solidity ^0.8.1;
112 
113 /**
114  * @dev Collection of functions related to the address type
115  */
116 library Address {
117     /**
118      * @dev Returns true if `account` is a contract.
119      *
120      * [IMPORTANT]
121      * ====
122      * It is unsafe to assume that an address for which this function returns
123      * false is an externally-owned account (EOA) and not a contract.
124      *
125      * Among others, `isContract` will return false for the following
126      * types of addresses:
127      *
128      *  - an externally-owned account
129      *  - a contract in construction
130      *  - an address where a contract will be created
131      *  - an address where a contract lived, but was destroyed
132      * ====
133      *
134      * [IMPORTANT]
135      * ====
136      * You shouldn't rely on `isContract` to protect against flash loan attacks!
137      *
138      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
139      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
140      * constructor.
141      * ====
142      */
143     function isContract(address account) internal view returns (bool) {
144         // This method relies on extcodesize/address.code.length, which returns 0
145         // for contracts in construction, since the code is only stored at the end
146         // of the constructor execution.
147 
148         return account.code.length > 0;
149     }
150 
151     /**
152      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
153      * `recipient`, forwarding all available gas and reverting on errors.
154      *
155      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
156      * of certain opcodes, possibly making contracts go over the 2300 gas limit
157      * imposed by `transfer`, making them unable to receive funds via
158      * `transfer`. {sendValue} removes this limitation.
159      *
160      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
161      *
162      * IMPORTANT: because control is transferred to `recipient`, care must be
163      * taken to not create reentrancy vulnerabilities. Consider using
164      * {ReentrancyGuard} or the
165      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
166      */
167     function sendValue(address payable recipient, uint256 amount) internal {
168         require(address(this).balance >= amount, "Address: insufficient balance");
169 
170         (bool success, ) = recipient.call{value: amount}("");
171         require(success, "Address: unable to send value, recipient may have reverted");
172     }
173 
174     /**
175      * @dev Performs a Solidity function call using a low level `call`. A
176      * plain `call` is an unsafe replacement for a function call: use this
177      * function instead.
178      *
179      * If `target` reverts with a revert reason, it is bubbled up by this
180      * function (like regular Solidity function calls).
181      *
182      * Returns the raw returned data. To convert to the expected return value,
183      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
184      *
185      * Requirements:
186      *
187      * - `target` must be a contract.
188      * - calling `target` with `data` must not revert.
189      *
190      * _Available since v3.1._
191      */
192     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
193         return functionCall(target, data, "Address: low-level call failed");
194     }
195 
196     /**
197      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
198      * `errorMessage` as a fallback revert reason when `target` reverts.
199      *
200      * _Available since v3.1._
201      */
202     function functionCall(
203         address target,
204         bytes memory data,
205         string memory errorMessage
206     ) internal returns (bytes memory) {
207         return functionCallWithValue(target, data, 0, errorMessage);
208     }
209 
210     /**
211      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
212      * but also transferring `value` wei to `target`.
213      *
214      * Requirements:
215      *
216      * - the calling contract must have an ETH balance of at least `value`.
217      * - the called Solidity function must be `payable`.
218      *
219      * _Available since v3.1._
220      */
221     function functionCallWithValue(
222         address target,
223         bytes memory data,
224         uint256 value
225     ) internal returns (bytes memory) {
226         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
227     }
228 
229     /**
230      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
231      * with `errorMessage` as a fallback revert reason when `target` reverts.
232      *
233      * _Available since v3.1._
234      */
235     function functionCallWithValue(
236         address target,
237         bytes memory data,
238         uint256 value,
239         string memory errorMessage
240     ) internal returns (bytes memory) {
241         require(address(this).balance >= value, "Address: insufficient balance for call");
242         require(isContract(target), "Address: call to non-contract");
243 
244         (bool success, bytes memory returndata) = target.call{value: value}(data);
245         return verifyCallResult(success, returndata, errorMessage);
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
250      * but performing a static call.
251      *
252      * _Available since v3.3._
253      */
254     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
255         return functionStaticCall(target, data, "Address: low-level static call failed");
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
260      * but performing a static call.
261      *
262      * _Available since v3.3._
263      */
264     function functionStaticCall(
265         address target,
266         bytes memory data,
267         string memory errorMessage
268     ) internal view returns (bytes memory) {
269         require(isContract(target), "Address: static call to non-contract");
270 
271         (bool success, bytes memory returndata) = target.staticcall(data);
272         return verifyCallResult(success, returndata, errorMessage);
273     }
274 
275     /**
276      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
277      * but performing a delegate call.
278      *
279      * _Available since v3.4._
280      */
281     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
282         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
283     }
284 
285     /**
286      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
287      * but performing a delegate call.
288      *
289      * _Available since v3.4._
290      */
291     function functionDelegateCall(
292         address target,
293         bytes memory data,
294         string memory errorMessage
295     ) internal returns (bytes memory) {
296         require(isContract(target), "Address: delegate call to non-contract");
297 
298         (bool success, bytes memory returndata) = target.delegatecall(data);
299         return verifyCallResult(success, returndata, errorMessage);
300     }
301 
302     /**
303      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
304      * revert reason using the provided one.
305      *
306      * _Available since v4.3._
307      */
308     function verifyCallResult(
309         bool success,
310         bytes memory returndata,
311         string memory errorMessage
312     ) internal pure returns (bytes memory) {
313         if (success) {
314             return returndata;
315         } else {
316             // Look for revert reason and bubble it up if present
317             if (returndata.length > 0) {
318                 // The easiest way to bubble the revert reason is using memory via assembly
319 
320                 assembly {
321                     let returndata_size := mload(returndata)
322                     revert(add(32, returndata), returndata_size)
323                 }
324             } else {
325                 revert(errorMessage);
326             }
327         }
328     }
329 }
330 
331 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
332 
333 
334 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
335 
336 pragma solidity ^0.8.0;
337 
338 /**
339  * @dev Interface of the ERC20 standard as defined in the EIP.
340  */
341 interface IERC20 {
342     /**
343      * @dev Returns the amount of tokens in existence.
344      */
345     function totalSupply() external view returns (uint256);
346 
347     /**
348      * @dev Returns the amount of tokens owned by `account`.
349      */
350     function balanceOf(address account) external view returns (uint256);
351 
352     /**
353      * @dev Moves `amount` tokens from the caller's account to `to`.
354      *
355      * Returns a boolean value indicating whether the operation succeeded.
356      *
357      * Emits a {Transfer} event.
358      */
359     function transfer(address to, uint256 amount) external returns (bool);
360 
361     /**
362      * @dev Returns the remaining number of tokens that `spender` will be
363      * allowed to spend on behalf of `owner` through {transferFrom}. This is
364      * zero by default.
365      *
366      * This value changes when {approve} or {transferFrom} are called.
367      */
368     function allowance(address owner, address spender) external view returns (uint256);
369 
370     /**
371      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
372      *
373      * Returns a boolean value indicating whether the operation succeeded.
374      *
375      * IMPORTANT: Beware that changing an allowance with this method brings the risk
376      * that someone may use both the old and the new allowance by unfortunate
377      * transaction ordering. One possible solution to mitigate this race
378      * condition is to first reduce the spender's allowance to 0 and set the
379      * desired value afterwards:
380      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
381      *
382      * Emits an {Approval} event.
383      */
384     function approve(address spender, uint256 amount) external returns (bool);
385 
386     /**
387      * @dev Moves `amount` tokens from `from` to `to` using the
388      * allowance mechanism. `amount` is then deducted from the caller's
389      * allowance.
390      *
391      * Returns a boolean value indicating whether the operation succeeded.
392      *
393      * Emits a {Transfer} event.
394      */
395     function transferFrom(
396         address from,
397         address to,
398         uint256 amount
399     ) external returns (bool);
400 
401     /**
402      * @dev Emitted when `value` tokens are moved from one account (`from`) to
403      * another (`to`).
404      *
405      * Note that `value` may be zero.
406      */
407     event Transfer(address indexed from, address indexed to, uint256 value);
408 
409     /**
410      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
411      * a call to {approve}. `value` is the new allowance.
412      */
413     event Approval(address indexed owner, address indexed spender, uint256 value);
414 }
415 
416 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
417 
418 
419 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
420 
421 pragma solidity ^0.8.0;
422 
423 
424 
425 /**
426  * @title SafeERC20
427  * @dev Wrappers around ERC20 operations that throw on failure (when the token
428  * contract returns false). Tokens that return no value (and instead revert or
429  * throw on failure) are also supported, non-reverting calls are assumed to be
430  * successful.
431  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
432  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
433  */
434 library SafeERC20 {
435     using Address for address;
436 
437     function safeTransfer(
438         IERC20 token,
439         address to,
440         uint256 value
441     ) internal {
442         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
443     }
444 
445     function safeTransferFrom(
446         IERC20 token,
447         address from,
448         address to,
449         uint256 value
450     ) internal {
451         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
452     }
453 
454     /**
455      * @dev Deprecated. This function has issues similar to the ones found in
456      * {IERC20-approve}, and its usage is discouraged.
457      *
458      * Whenever possible, use {safeIncreaseAllowance} and
459      * {safeDecreaseAllowance} instead.
460      */
461     function safeApprove(
462         IERC20 token,
463         address spender,
464         uint256 value
465     ) internal {
466         // safeApprove should only be called when setting an initial allowance,
467         // or when resetting it to zero. To increase and decrease it, use
468         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
469         require(
470             (value == 0) || (token.allowance(address(this), spender) == 0),
471             "SafeERC20: approve from non-zero to non-zero allowance"
472         );
473         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
474     }
475 
476     function safeIncreaseAllowance(
477         IERC20 token,
478         address spender,
479         uint256 value
480     ) internal {
481         uint256 newAllowance = token.allowance(address(this), spender) + value;
482         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
483     }
484 
485     function safeDecreaseAllowance(
486         IERC20 token,
487         address spender,
488         uint256 value
489     ) internal {
490         unchecked {
491             uint256 oldAllowance = token.allowance(address(this), spender);
492             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
493             uint256 newAllowance = oldAllowance - value;
494             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
495         }
496     }
497 
498     /**
499      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
500      * on the return value: the return value is optional (but if data is returned, it must not be false).
501      * @param token The token targeted by the call.
502      * @param data The call data (encoded using abi.encode or one of its variants).
503      */
504     function _callOptionalReturn(IERC20 token, bytes memory data) private {
505         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
506         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
507         // the target address contains contract code and also asserts for success in the low-level call.
508 
509         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
510         if (returndata.length > 0) {
511             // Return data is optional
512             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
513         }
514     }
515 }
516 
517 // File: CHNReward.sol
518 
519 
520 
521 pragma solidity ^0.8.3;
522 
523 
524 
525 
526 interface CHNStakingInterface {
527     function claimRewardFromVault(address userAddress, uint256 pid) external returns (uint256);
528 }
529 
530 contract CHNReward is Ownable {
531     using SafeERC20 for IERC20;
532 
533     event Claim(address indexed user, uint256 indexed pid, uint256 reward);
534     event GrantDAO(address indexed user, uint256 amount);
535     event ChangeStaking(address indexed stake);
536 
537     IERC20 public rewardToken;
538     CHNStakingInterface public staking;
539 
540     constructor(IERC20 _rewardToken) Ownable() {
541         rewardToken = _rewardToken;
542     }
543 
544     function changeStakingAdderss(address _staking) public onlyOwner {
545         staking = CHNStakingInterface(_staking);
546         emit ChangeStaking(_staking);
547     }
548 
549     function claimReward(uint256 pid) public {
550         uint256 rewardAmount = staking.claimRewardFromVault(msg.sender, pid);
551         rewardToken.safeTransfer(address(msg.sender), rewardAmount);
552         emit Claim(msg.sender, pid, rewardAmount);
553     }
554 
555     function grantDAO(address user, uint256 amount) public onlyOwner {
556         rewardToken.safeTransfer(user, amount);
557         emit GrantDAO(user, amount);
558     }
559 }