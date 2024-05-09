1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Contract module which provides a basic access control mechanism, where
7  * there is an account (an owner) that can be granted exclusive access to
8  * specific functions.
9  *
10  * By default, the owner account will be the one that deploys the contract. This
11  * can later be changed with {transferOwnership}.
12  *
13  * This module is used through inheritance. It will make available the modifier
14  * `onlyOwner`, which can be applied to your functions to restrict their use to
15  * the owner.
16  */
17 
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
28 abstract contract Ownable is Context {
29     address private _owner;
30 
31     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32 
33     /**
34      * @dev Initializes the contract setting the deployer as the initial owner.
35      */
36     constructor() {
37         _setOwner(_msgSender());
38     }
39 
40     /**
41      * @dev Returns the address of the current owner.
42      */
43     function owner() public view virtual returns (address) {
44         return _owner;
45     }
46 
47     /**
48      * @dev Throws if called by any account other than the owner.
49      */
50     modifier onlyOwner() {
51         require(owner() == _msgSender(), "Ownable: caller is not the owner");
52         _;
53     }
54 
55     /**
56      * @dev Leaves the contract without owner. It will not be possible to call
57      * `onlyOwner` functions anymore. Can only be called by the current owner.
58      *
59      * NOTE: Renouncing ownership will leave the contract without an owner,
60      * thereby removing any functionality that is only available to the owner.
61      */
62     function renounceOwnership() public virtual onlyOwner {
63         _setOwner(address(0));
64     }
65 
66     /**
67      * @dev Transfers ownership of the contract to a new account (`newOwner`).
68      * Can only be called by the current owner.
69      */
70     function transferOwnership(address newOwner) public virtual onlyOwner {
71         require(newOwner != address(0), "Ownable: new owner is the zero address");
72         _setOwner(newOwner);
73     }
74 
75     function _setOwner(address newOwner) private {
76         address oldOwner = _owner;
77         _owner = newOwner;
78         emit OwnershipTransferred(oldOwner, newOwner);
79     }
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
384 interface IPriceOracleGetter {
385   function getAssetPrice(address asset) external view returns (uint256);
386 }
387 
388 interface IERC20 {
389     /**
390      * @dev Returns the amount of tokens in existence.
391      */
392     function totalSupply() external view returns (uint256);
393 
394     /**
395      * @dev Returns the amount of tokens owned by `account`.
396      */
397     function balanceOf(address account) external view returns (uint256);
398 
399     /**
400      * @dev Moves `amount` tokens from the caller's account to `recipient`.
401      *
402      * Returns a boolean value indicating whether the operation succeeded.
403      *
404      * Emits a {Transfer} event.
405      */
406     function transfer(address recipient, uint256 amount) external returns (bool);
407 
408     /**
409      * @dev Returns the remaining number of tokens that `spender` will be
410      * allowed to spend on behalf of `owner` through {transferFrom}. This is
411      * zero by default.
412      *
413      * This value changes when {approve} or {transferFrom} are called.
414      */
415     function allowance(address owner, address spender) external view returns (uint256);
416 
417     /**
418      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
419      *
420      * Returns a boolean value indicating whether the operation succeeded.
421      *
422      * IMPORTANT: Beware that changing an allowance with this method brings the risk
423      * that someone may use both the old and the new allowance by unfortunate
424      * transaction ordering. One possible solution to mitigate this race
425      * condition is to first reduce the spender's allowance to 0 and set the
426      * desired value afterwards:
427      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
428      *
429      * Emits an {Approval} event.
430      */
431     function approve(address spender, uint256 amount) external returns (bool);
432 
433     /**
434      * @dev Moves `amount` tokens from `sender` to `recipient` using the
435      * allowance mechanism. `amount` is then deducted from the caller's
436      * allowance.
437      *
438      * Returns a boolean value indicating whether the operation succeeded.
439      *
440      * Emits a {Transfer} event.
441      */
442     function transferFrom(
443         address sender,
444         address recipient,
445         uint256 amount
446     ) external returns (bool);
447 
448     /**
449      * @dev Emitted when `value` tokens are moved from one account (`from`) to
450      * another (`to`).
451      *
452      * Note that `value` may be zero.
453      */
454     event Transfer(address indexed from, address indexed to, uint256 value);
455 
456     /**
457      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
458      * a call to {approve}. `value` is the new allowance.
459      */
460     event Approval(address indexed owner, address indexed spender, uint256 value);
461 }
462 
463 contract Escrow is Ownable {
464     using Address for address payable;
465     using SafeERC20 for IERC20;
466 
467     event BoughtOffline(address indexed recipient, uint256 indexed amount);
468     event ERC20Deposited(address indexed payee, address indexed token, uint256 indexed amount);
469     event ERC20Withdrawn(address indexed payee, address indexed token, uint256 indexed amount);
470     event Deposited(address indexed payee, uint256 indexed weiAmount);
471     event Withdrawn(address indexed payee, uint256 indexed weiAmount);
472     
473     mapping(address => bool) public whitelistedTokens;
474     mapping(address => uint256) public conversionRates;
475 
476     address public offlineSpender;
477     uint256 public pricePerUnitInUSD;
478     uint256 public lastRecordedPrice;
479     uint256 public minimumTicket;
480     uint256 public constant ONE = 10**18;
481     bool public paused;
482     
483     IERC20 public wbkn;
484     IPriceOracleGetter public ethUSDCFeed;
485 
486     modifier onlySpender {
487         require(msg.sender == offlineSpender, "Caller is not spender");
488         _;
489     }
490     
491     modifier whenNotPaused {
492         require(!paused, "Functionality is paused");
493         _;
494     }
495     
496     constructor(
497         address _wbkn,
498         address _offlineSpender,
499         uint256 _pricePerUnitInUsd,
500         uint256 _minimumTicket,
501         address _priceOracleGetter,
502         address[] memory _whitelistedTokens,
503         uint256[] memory _conversionRates
504     ) {
505         require(_whitelistedTokens.length == _conversionRates.length, "Lengths mismatch");
506         require(_wbkn != address(0), "Invalid WBKN address");
507 
508         pricePerUnitInUSD = _pricePerUnitInUsd;        
509         wbkn = IERC20(_wbkn);
510         minimumTicket = _minimumTicket;
511         offlineSpender = _offlineSpender;
512         ethUSDCFeed = IPriceOracleGetter(_priceOracleGetter);
513         lastRecordedPrice = ethUSDCFeed.getAssetPrice(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
514         
515         for(uint8 i = 0; i<_whitelistedTokens.length; i++) {
516             whitelistedTokens[_whitelistedTokens[i]] = true;
517             conversionRates[_whitelistedTokens[i]] =_conversionRates[i];
518         }
519     }
520     
521     function pause(bool _pause) public onlyOwner {
522         paused = _pause;
523     }
524     
525     function configERC20(address token, uint256 conversionRate) public onlyOwner {
526         if(conversionRate != 0) {
527             if(!whitelistedTokens[token]) whitelistedTokens[token] = true;
528         } else {
529             if(whitelistedTokens[token]) whitelistedTokens[token] = false;
530         }
531         
532         if(conversionRate != conversionRates[token]) conversionRates[token] = conversionRate;
533     }
534     
535     function configUSDPrice(uint256 newValue) public onlyOwner {
536         pricePerUnitInUSD = newValue;
537     }
538 
539     function configMinimumTicket(uint256 newValue) public onlyOwner {
540         minimumTicket = newValue;
541     }
542     
543     function buyOffline(uint256 amountBought, address recipient) public onlySpender {
544         require(amountBought <= wbkn.balanceOf(address(this)), "Amount exceeds contract's reserve");
545         require(amountBought >= minimumTicket, "Minimum ticket not satisfied");
546 
547         wbkn.safeTransfer(recipient, amountBought);
548         
549         emit BoughtOffline(recipient, amountBought);
550     }
551     
552     function buyWithERC20(address token, uint256 amount) public whenNotPaused {
553         require(whitelistedTokens[token], "This address is not whitelisted");
554         require(conversionRates[token] > 0, "Invalid conversion rate");
555         require(amount > 0, "Zero amount not allowed");
556         require(IERC20(token).allowance(msg.sender, address(this)) >= amount, "Contract has not enough allowance");
557         
558         uint256 amountBought = amount * conversionRates[token];
559         require(amountBought >= minimumTicket, "Minimum ticket not satisfied");
560         require(amountBought <= wbkn.balanceOf(address(this)), "Amount exceeds contract's reserve");
561         
562         IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
563         wbkn.safeTransfer(msg.sender, amountBought);
564 
565         emit ERC20Deposited(msg.sender, token, amount);
566     }
567 
568     function buyWithETH() public payable whenNotPaused {
569         uint256 amount = msg.value;
570         require(amount > 0, "Zero amount not allowed");
571 
572         lastRecordedPrice = ethUSDCFeed.getAssetPrice(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
573         
574         uint256 amountInUSD = amount*ONE / lastRecordedPrice;
575         uint256 amountBought = amountInUSD*ONE / pricePerUnitInUSD;
576 
577         require(amountBought >= minimumTicket, "Minimum ticket not satisfied");
578         require(amountBought <= wbkn.balanceOf(address(this)), "Amount exceeds contract's reserve");
579         
580         wbkn.safeTransfer(msg.sender, amountBought);
581         
582         emit Deposited(msg.sender, amountInUSD);
583     }
584 
585     function withdrawETH(address payable recipient) public onlyOwner {
586         emit Withdrawn(recipient, address(this).balance);
587         recipient.sendValue(address(this).balance);
588     }
589     
590     function withdrawERC20(address token, address recipient) public onlyOwner {
591 
592         IERC20(token).safeTransfer(recipient, IERC20(token).balanceOf(address(this)));
593 
594         emit ERC20Withdrawn(recipient, token, IERC20(token).balanceOf(address(this)));
595     }
596 }