1 /**
2  //SPDX-License-Identifier: MIT
3  
4 */
5 
6 pragma solidity ^0.8.0;
7 
8 
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18     function balanceOf(address account) external view returns (uint256);
19     function transfer(address recipient, uint256 amount) external returns (bool);
20     function allowance(address owner, address spender) external view returns (uint256);
21     function approve(address spender, uint256 amount) external returns (bool);
22     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 interface IERC20Metadata is IERC20 {
28     /**
29      * @dev Returns the name of the token.
30      */
31     function name() external view returns (string memory);
32 
33     /**
34      * @dev Returns the symbol of the token.
35      */
36     function symbol() external view returns (string memory);
37 
38     /**
39      * @dev Returns the decimals places of the token.
40      */
41     function decimals() external view returns (uint8);
42 }
43 
44 library SafeMath {
45     function add(uint256 a, uint256 b) internal pure returns (uint256) {
46         uint256 c = a + b;
47         require(c >= a, "SafeMath: addition overflow");
48         return c;
49     }
50 
51     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52         return sub(a, b, "SafeMath: subtraction overflow");
53     }
54 
55     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b <= a, errorMessage);
57         uint256 c = a - b;
58         return c;
59     }
60 
61     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62         if (a == 0) {
63             return 0;
64         }
65         uint256 c = a * b;
66         require(c / a == b, "SafeMath: multiplication overflow");
67         return c;
68     }
69 
70     function div(uint256 a, uint256 b) internal pure returns (uint256) {
71         return div(a, b, "SafeMath: division by zero");
72     }
73 
74     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
75         require(b > 0, errorMessage);
76         uint256 c = a / b;
77         return c;
78     }
79 
80 }
81 
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
101         // This method relies on extcodesize, which returns 0 for contracts in
102         // construction, since the code is only stored at the end of the
103         // constructor execution.
104 
105         uint256 size;
106         assembly {
107             size := extcodesize(account)
108         }
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
131         (bool success, ) = recipient.call{value: amount}("");
132         require(success, "Address: unable to send value, recipient may have reverted");
133     }
134 
135     /**
136      * @dev Performs a Solidity function call using a low level `call`. A
137      * plain `call` is an unsafe replacement for a function call: use this
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
154         return functionCall(target, data, "Address: low-level call failed");
155     }
156 
157     /**
158      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
159      * `errorMessage` as a fallback revert reason when `target` reverts.
160      *
161      * _Available since v3.1._
162      */
163     function functionCall(
164         address target,
165         bytes memory data,
166         string memory errorMessage
167     ) internal returns (bytes memory) {
168         return functionCallWithValue(target, data, 0, errorMessage);
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
173      * but also transferring `value` wei to `target`.
174      *
175      * Requirements:
176      *
177      * - the calling contract must have an ETH balance of at least `value`.
178      * - the called Solidity function must be `payable`.
179      *
180      * _Available since v3.1._
181      */
182     function functionCallWithValue(
183         address target,
184         bytes memory data,
185         uint256 value
186     ) internal returns (bytes memory) {
187         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
188     }
189 
190     /**
191      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
192      * with `errorMessage` as a fallback revert reason when `target` reverts.
193      *
194      * _Available since v3.1._
195      */
196     function functionCallWithValue(
197         address target,
198         bytes memory data,
199         uint256 value,
200         string memory errorMessage
201     ) internal returns (bytes memory) {
202         require(address(this).balance >= value, "Address: insufficient balance for call");
203         require(isContract(target), "Address: call to non-contract");
204 
205         (bool success, bytes memory returndata) = target.call{value: value}(data);
206         return verifyCallResult(success, returndata, errorMessage);
207     }
208 
209     /**
210      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
211      * but performing a static call.
212      *
213      * _Available since v3.3._
214      */
215     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
216         return functionStaticCall(target, data, "Address: low-level static call failed");
217     }
218 
219     /**
220      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
221      * but performing a static call.
222      *
223      * _Available since v3.3._
224      */
225     function functionStaticCall(
226         address target,
227         bytes memory data,
228         string memory errorMessage
229     ) internal view returns (bytes memory) {
230         require(isContract(target), "Address: static call to non-contract");
231 
232         (bool success, bytes memory returndata) = target.staticcall(data);
233         return verifyCallResult(success, returndata, errorMessage);
234     }
235 
236     /**
237      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
238      * but performing a delegate call.
239      *
240      * _Available since v3.4._
241      */
242     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
243         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
244     }
245 
246     /**
247      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
248      * but performing a delegate call.
249      *
250      * _Available since v3.4._
251      */
252     function functionDelegateCall(
253         address target,
254         bytes memory data,
255         string memory errorMessage
256     ) internal returns (bytes memory) {
257         require(isContract(target), "Address: delegate call to non-contract");
258 
259         (bool success, bytes memory returndata) = target.delegatecall(data);
260         return verifyCallResult(success, returndata, errorMessage);
261     }
262 
263     /**
264      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
265      * revert reason using the provided one.
266      *
267      * _Available since v4.3._
268      */
269     function verifyCallResult(
270         bool success,
271         bytes memory returndata,
272         string memory errorMessage
273     ) internal pure returns (bytes memory) {
274         if (success) {
275             return returndata;
276         } else {
277             // Look for revert reason and bubble it up if present
278             if (returndata.length > 0) {
279                 // The easiest way to bubble the revert reason is using memory via assembly
280 
281                 assembly {
282                     let returndata_size := mload(returndata)
283                     revert(add(32, returndata), returndata_size)
284                 }
285             } else {
286                 revert(errorMessage);
287             }
288         }
289     }
290 }
291 
292 /**
293  * @title SafeERC20
294  * @dev Wrappers around ERC20 operations that throw on failure (when the token
295  * contract returns false). Tokens that return no value (and instead revert or
296  * throw on failure) are also supported, non-reverting calls are assumed to be
297  * successful.
298  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
299  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
300  */
301 library SafeERC20 {
302     using Address for address;
303 
304     function safeTransfer(
305         IERC20 token,
306         address to,
307         uint256 value
308     ) internal {
309         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
310     }
311 
312     function safeTransferFrom(
313         IERC20 token,
314         address from,
315         address to,
316         uint256 value
317     ) internal {
318         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
319     }
320 
321     /**
322      * @dev Deprecated. This function has issues similar to the ones found in
323      * {IERC20-approve}, and its usage is discouraged.
324      *
325      * Whenever possible, use {safeIncreaseAllowance} and
326      * {safeDecreaseAllowance} instead.
327      */
328     function safeApprove(
329         IERC20 token,
330         address spender,
331         uint256 value
332     ) internal {
333         // safeApprove should only be called when setting an initial allowance,
334         // or when resetting it to zero. To increase and decrease it, use
335         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
336         require(
337             (value == 0) || (token.allowance(address(this), spender) == 0),
338             "SafeERC20: approve from non-zero to non-zero allowance"
339         );
340         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
341     }
342 
343     function safeIncreaseAllowance(
344         IERC20 token,
345         address spender,
346         uint256 value
347     ) internal {
348         uint256 newAllowance = token.allowance(address(this), spender) + value;
349         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
350     }
351 
352     function safeDecreaseAllowance(
353         IERC20 token,
354         address spender,
355         uint256 value
356     ) internal {
357         unchecked {
358             uint256 oldAllowance = token.allowance(address(this), spender);
359             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
360             uint256 newAllowance = oldAllowance - value;
361             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
362         }
363     }
364 
365     /**
366      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
367      * on the return value: the return value is optional (but if data is returned, it must not be false).
368      * @param token The token targeted by the call.
369      * @param data The call data (encoded using abi.encode or one of its variants).
370      */
371     function _callOptionalReturn(IERC20 token, bytes memory data) private {
372         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
373         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
374         // the target address contains contract code and also asserts for success in the low-level call.
375 
376         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
377         if (returndata.length > 0) {
378             // Return data is optional
379             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
380         }
381     }
382 }
383 
384 
385 
386 /**
387  * @dev Contract module which provides a basic access control mechanism, where
388  * there is an account (an owner) that can be granted exclusive access to
389  * specific functions.
390  *
391  * By default, the owner account will be the one that deploys the contract. This
392  * can later be changed with {transferOwnership}.
393  *
394  * This module is used through inheritance. It will make available the modifier
395  * `onlyOwner`, which can be applied to your functions to restrict their use to
396  * the owner.
397  */
398 abstract contract Ownable is Context {
399     address private _owner;
400 
401     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
402 
403     /**
404      * @dev Initializes the contract setting the deployer as the initial owner.
405      */
406     constructor() {
407         _setOwner(_msgSender());
408     }
409 
410     /**
411      * @dev Returns the address of the current owner.
412      */
413     function owner() public view virtual returns (address) {
414         return _owner;
415     }
416 
417     /**
418      * @dev Throws if called by any account other than the owner.
419      */
420     modifier onlyOwner() {
421         require(owner() == _msgSender(), "Ownable: caller is not the owner");
422         _;
423     }
424 
425     /**
426      * @dev Leaves the contract without owner. It will not be possible to call
427      * `onlyOwner` functions anymore. Can only be called by the current owner.
428      *
429      * NOTE: Renouncing ownership will leave the contract without an owner,
430      * thereby removing any functionality that is only available to the owner.
431      */
432     function renounceOwnership() public virtual onlyOwner {
433         _setOwner(address(0));
434     }
435 
436     /**
437      * @dev Transfers ownership of the contract to a new account (`newOwner`).
438      * Can only be called by the current owner.
439      */
440     function transferOwnership(address newOwner) public virtual onlyOwner {
441         require(newOwner != address(0), "Ownable: new owner is the zero address");
442         _setOwner(newOwner);
443     }
444 
445     function _setOwner(address newOwner) private {
446         address oldOwner = _owner;
447         _owner = newOwner;
448         emit OwnershipTransferred(oldOwner, newOwner);
449     }
450 }
451 
452 /**
453  * @dev Contract module that helps prevent reentrant calls to a function.
454  *
455  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
456  * available, which can be applied to functions to make sure there are no nested
457  * (reentrant) calls to them.
458  *
459  * Note that because there is a single `nonReentrant` guard, functions marked as
460  * `nonReentrant` may not call one another. This can be worked around by making
461  * those functions `private`, and then adding `external` `nonReentrant` entry
462  * points to them.
463  *
464  * TIP: If you would like to learn more about reentrancy and alternative ways
465  * to protect against it, check out our blog post
466  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
467  */
468 abstract contract ReentrancyGuard {
469     // Booleans are more expensive than uint256 or any type that takes up a full
470     // word because each write operation emits an extra SLOAD to first read the
471     // slot's contents, replace the bits taken up by the boolean, and then write
472     // back. This is the compiler's defense against contract upgrades and
473     // pointer aliasing, and it cannot be disabled.
474 
475     // The values being non-zero value makes deployment a bit more expensive,
476     // but in exchange the refund on every call to nonReentrant will be lower in
477     // amount. Since refunds are capped to a percentage of the total
478     // transaction's gas, it is best to keep them low in cases like this one, to
479     // increase the likelihood of the full refund coming into effect.
480     uint256 private constant _NOT_ENTERED = 1;
481     uint256 private constant _ENTERED = 2;
482 
483     uint256 private _status;
484 
485     constructor() {
486         _status = _NOT_ENTERED;
487     }
488 
489     /**
490      * @dev Prevents a contract from calling itself, directly or indirectly.
491      * Calling a `nonReentrant` function from another `nonReentrant`
492      * function is not supported. It is possible to prevent this from happening
493      * by making the `nonReentrant` function external, and make it call a
494      * `private` function that does the actual work.
495      */
496     modifier nonReentrant() {
497         // On the first call to nonReentrant, _notEntered will be true
498         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
499 
500         // Any calls to nonReentrant after this point will fail
501         _status = _ENTERED;
502 
503         _;
504 
505         // By storing the original value once again, a refund is triggered (see
506         // https://eips.ethereum.org/EIPS/eip-2200)
507         _status = _NOT_ENTERED;
508     }
509 }
510 
511 
512 
513 interface BRAINToken {
514     
515     function excludeFromFees(address) external;
516     function includeInFees(address) external;
517     function changeMarketing(address payable) external;
518     function changeTreasury(address payable) external;
519     function setMaxTx(uint256) external;
520     function toggleMaxTx() external;
521     function setTax(uint256) external;
522     function toggleTax() external;
523     function addBots(address[] memory) external;
524     function removeBot(address) external;
525     function addMinter(address) external;
526     function removeMinter(address) external;
527     function mint(address, uint256) external;
528     function burn() external;
529     
530 }
531 
532 contract brainBridge is Ownable, ReentrancyGuard {
533     
534     using Address for address;
535     using SafeMath for uint256;
536     using SafeERC20 for IERC20;
537     
538     mapping(address => uint256) deposit;
539     mapping(address => uint256) newTokenAmount;
540     
541     uint256 rewardMultiplier;
542     BRAINToken newToken;
543     IERC20 oldToken;
544     bool open;
545     bool claimable;
546     
547     uint256 public totalBridged;
548     
549     constructor(address old, uint256 multiplier) {
550         
551         oldToken = IERC20(old);
552         rewardMultiplier = multiplier;
553         open = true;
554         claimable = false;
555     }
556     
557     function newTokens(address _addy) external view returns(uint256) {
558         
559         return (newTokenAmount[_addy]);
560     }
561     
562     function oldTokens(address _addy) external view returns(uint256) {
563         
564         return (deposit[_addy]);
565     }
566     
567     function changeMultiplier(uint256 _num) external onlyOwner {
568         
569         rewardMultiplier = _num;
570     }
571     
572     function setNewToken(address _token) external onlyOwner {
573         
574         newToken = BRAINToken(_token);
575         claimable = true;
576     }
577     
578     function toggleClaimable() external onlyOwner {
579         if(claimable == true) {
580             claimable = false;
581         } else {
582             claimable = true;
583         }
584     }
585     
586     function toggleOpen() external onlyOwner {
587         if(open == true) {
588             open = false;
589         } else {
590             open = true;
591         }
592     }
593     
594     function bridge() external nonReentrant {
595         require(open == true, "BRIDGE CLOSED");
596         deposit[msg.sender] += oldToken.balanceOf(msg.sender);
597         newTokenAmount[msg.sender] += (oldToken.balanceOf(msg.sender)).mul(rewardMultiplier).div(1000);
598         totalBridged += oldToken.balanceOf(msg.sender);
599         oldToken.safeTransferFrom(msg.sender, address(this), oldToken.balanceOf(msg.sender));
600         
601     }
602     
603     function claim() external nonReentrant {
604         require (claimable == true, "NOT CLAIMABLE");
605         require(newTokenAmount[msg.sender] > 0, "NO TOKENS");
606         newToken.mint(msg.sender, newTokenAmount[msg.sender]);
607         newTokenAmount[msg.sender] = 0;
608     }
609     
610     function withdrawTokens() external onlyOwner {
611         oldToken.safeTransfer(msg.sender, oldToken.balanceOf(address(this)));
612     }
613     
614     
615 }