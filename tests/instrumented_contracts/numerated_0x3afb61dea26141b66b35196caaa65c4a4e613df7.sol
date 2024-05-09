1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.15;
3 
4 /**
5  * @dev Collection of functions related to the address type
6  */
7 library Address {
8     /**
9      * @dev Returns true if `account` is a contract.
10      *
11      * [IMPORTANT]
12      * ====
13      * It is unsafe to assume that an address for which this function returns
14      * false is an externally-owned account (EOA) and not a contract.
15      *
16      * Among others, `isContract` will return false for the following
17      * types of addresses:
18      *
19      *  - an externally-owned account
20      *  - a contract in construction
21      *  - an address where a contract will be created
22      *  - an address where a contract lived, but was destroyed
23      * ====
24      *
25      * [IMPORTANT]
26      * ====
27      * You shouldn't rely on `isContract` to protect against flash loan attacks!
28      *
29      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
30      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
31      * constructor.
32      * ====
33      */
34     function isContract(address account) internal view returns (bool) {
35         // This method relies on extcodesize/address.code.length, which returns 0
36         // for contracts in construction, since the code is only stored at the end
37         // of the constructor execution.
38 
39         return account.code.length > 0;
40     }
41 
42     /**
43      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
44      * `recipient`, forwarding all available gas and reverting on errors.
45      *
46      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
47      * of certain opcodes, possibly making contracts go over the 2300 gas limit
48      * imposed by `transfer`, making them unable to receive funds via
49      * `transfer`. {sendValue} removes this limitation.
50      *
51      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
52      *
53      * IMPORTANT: because control is transferred to `recipient`, care must be
54      * taken to not create reentrancy vulnerabilities. Consider using
55      * {ReentrancyGuard} or the
56      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
57      */
58     function sendValue(address payable recipient, uint256 amount) internal {
59         require(address(this).balance >= amount, "Address: insufficient balance");
60 
61         (bool success, ) = recipient.call{value: amount}("");
62         require(success, "Address: unable to send value, recipient may have reverted");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain `call` is an unsafe replacement for a function call: use this
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
84         return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(
94         address target,
95         bytes memory data,
96         string memory errorMessage
97     ) internal returns (bytes memory) {
98         return functionCallWithValue(target, data, 0, errorMessage);
99     }
100 
101     /**
102      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
103      * but also transferring `value` wei to `target`.
104      *
105      * Requirements:
106      *
107      * - the calling contract must have an ETH balance of at least `value`.
108      * - the called Solidity function must be `payable`.
109      *
110      * _Available since v3.1._
111      */
112     function functionCallWithValue(
113         address target,
114         bytes memory data,
115         uint256 value
116     ) internal returns (bytes memory) {
117         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
118     }
119 
120     /**
121      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
122      * with `errorMessage` as a fallback revert reason when `target` reverts.
123      *
124      * _Available since v3.1._
125      */
126     function functionCallWithValue(
127         address target,
128         bytes memory data,
129         uint256 value,
130         string memory errorMessage
131     ) internal returns (bytes memory) {
132         require(address(this).balance >= value, "Address: insufficient balance for call");
133         require(isContract(target), "Address: call to non-contract");
134 
135         (bool success, bytes memory returndata) = target.call{value: value}(data);
136         return verifyCallResult(success, returndata, errorMessage);
137     }
138 
139     /**
140      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
141      * but performing a static call.
142      *
143      * _Available since v3.3._
144      */
145     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
146         return functionStaticCall(target, data, "Address: low-level static call failed");
147     }
148 
149     /**
150      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
151      * but performing a static call.
152      *
153      * _Available since v3.3._
154      */
155     function functionStaticCall(
156         address target,
157         bytes memory data,
158         string memory errorMessage
159     ) internal view returns (bytes memory) {
160         require(isContract(target), "Address: static call to non-contract");
161 
162         (bool success, bytes memory returndata) = target.staticcall(data);
163         return verifyCallResult(success, returndata, errorMessage);
164     }
165 
166     /**
167      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
168      * but performing a delegate call.
169      *
170      * _Available since v3.4._
171      */
172     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
173         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
178      * but performing a delegate call.
179      *
180      * _Available since v3.4._
181      */
182     function functionDelegateCall(
183         address target,
184         bytes memory data,
185         string memory errorMessage
186     ) internal returns (bytes memory) {
187         require(isContract(target), "Address: delegate call to non-contract");
188 
189         (bool success, bytes memory returndata) = target.delegatecall(data);
190         return verifyCallResult(success, returndata, errorMessage);
191     }
192 
193     /**
194      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
195      * revert reason using the provided one.
196      *
197      * _Available since v4.3._
198      */
199     function verifyCallResult(
200         bool success,
201         bytes memory returndata,
202         string memory errorMessage
203     ) internal pure returns (bytes memory) {
204         if (success) {
205             return returndata;
206         } else {
207             // Look for revert reason and bubble it up if present
208             if (returndata.length > 0) {
209                 // The easiest way to bubble the revert reason is using memory via assembly
210                 /// @solidity memory-safe-assembly
211                 assembly {
212                     let returndata_size := mload(returndata)
213                     revert(add(32, returndata), returndata_size)
214                 }
215             } else {
216                 revert(errorMessage);
217             }
218         }
219     }
220 }
221 
222 /**
223  * @dev Interface of the ERC20 standard as defined in the EIP.
224  */
225 interface IERC20 {
226     /**
227      * @dev Emitted when `value` tokens are moved from one account (`from`) to
228      * another (`to`).
229      *
230      * Note that `value` may be zero.
231      */
232     event Transfer(address indexed from, address indexed to, uint256 value);
233 
234     /**
235      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
236      * a call to {approve}. `value` is the new allowance.
237      */
238     event Approval(address indexed owner, address indexed spender, uint256 value);
239 
240     /**
241      * @dev Returns the amount of tokens in existence.
242      */
243     function totalSupply() external view returns (uint256);
244 
245     /**
246      * @dev Returns the amount of tokens owned by `account`.
247      */
248     function balanceOf(address account) external view returns (uint256);
249 
250     /**
251      * @dev Moves `amount` tokens from the caller's account to `to`.
252      *
253      * Returns a boolean value indicating whether the operation succeeded.
254      *
255      * Emits a {Transfer} event.
256      */
257     function transfer(address to, uint256 amount) external returns (bool);
258 
259     /**
260      * @dev Returns the remaining number of tokens that `spender` will be
261      * allowed to spend on behalf of `owner` through {transferFrom}. This is
262      * zero by default.
263      *
264      * This value changes when {approve} or {transferFrom} are called.
265      */
266     function allowance(address owner, address spender) external view returns (uint256);
267 
268     /**
269      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
270      *
271      * Returns a boolean value indicating whether the operation succeeded.
272      *
273      * IMPORTANT: Beware that changing an allowance with this method brings the risk
274      * that someone may use both the old and the new allowance by unfortunate
275      * transaction ordering. One possible solution to mitigate this race
276      * condition is to first reduce the spender's allowance to 0 and set the
277      * desired value afterwards:
278      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
279      *
280      * Emits an {Approval} event.
281      */
282     function approve(address spender, uint256 amount) external returns (bool);
283 
284     /**
285      * @dev Moves `amount` tokens from `from` to `to` using the
286      * allowance mechanism. `amount` is then deducted from the caller's
287      * allowance.
288      *
289      * Returns a boolean value indicating whether the operation succeeded.
290      *
291      * Emits a {Transfer} event.
292      */
293     function transferFrom(
294         address from,
295         address to,
296         uint256 amount
297     ) external returns (bool);
298 }
299 
300 /**
301  * @dev Provides information about the current execution context, including the
302  * sender of the transaction and its data. While these are generally available
303  * via msg.sender and msg.data, they should not be accessed in such a direct
304  * manner, since when dealing with meta-transactions the account sending and
305  * paying for execution may not be the actual sender (as far as an application
306  * is concerned).
307  *
308  * This contract is only required for intermediate, library-like contracts.
309  */
310 abstract contract Context {
311     function _msgSender() internal view virtual returns (address) {
312         return msg.sender;
313     }
314 
315     function _msgData() internal view virtual returns (bytes calldata) {
316         return msg.data;
317     }
318 }
319 
320 /**
321  * @dev Contract module which provides a basic access control mechanism, where
322  * there is an account (an owner) that can be granted exclusive access to
323  * specific functions.
324  *
325  * By default, the owner account will be the one that deploys the contract. This
326  * can later be changed with {transferOwnership}.
327  *
328  * This module is used through inheritance. It will make available the modifier
329  * `onlyOwner`, which can be applied to your functions to restrict their use to
330  * the owner.
331  */
332 abstract contract Ownable is Context {
333     address private _owner;
334 
335     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
336 
337     /**
338      * @dev Initializes the contract setting the deployer as the initial owner.
339      */
340     constructor() {
341         _transferOwnership(_msgSender());
342     }
343 
344     /**
345      * @dev Throws if called by any account other than the owner.
346      */
347     modifier onlyOwner() {
348         _checkOwner();
349         _;
350     }
351 
352     /**
353      * @dev Returns the address of the current owner.
354      */
355     function owner() public view virtual returns (address) {
356         return _owner;
357     }
358 
359     /**
360      * @dev Throws if the sender is not the owner.
361      */
362     function _checkOwner() internal view virtual {
363         require(owner() == _msgSender(), "Ownable: caller is not the owner");
364     }
365 
366     /**
367      * @dev Leaves the contract without owner. It will not be possible to call
368      * `onlyOwner` functions anymore. Can only be called by the current owner.
369      *
370      * NOTE: Renouncing ownership will leave the contract without an owner,
371      * thereby removing any functionality that is only available to the owner.
372      */
373     function renounceOwnership() public virtual onlyOwner {
374         _transferOwnership(address(0));
375     }
376 
377     /**
378      * @dev Transfers ownership of the contract to a new account (`newOwner`).
379      * Can only be called by the current owner.
380      */
381     function transferOwnership(address newOwner) public virtual onlyOwner {
382         require(newOwner != address(0), "Ownable: new owner is the zero address");
383         _transferOwnership(newOwner);
384     }
385 
386     /**
387      * @dev Transfers ownership of the contract to a new account (`newOwner`).
388      * Internal function without access restriction.
389      */
390     function _transferOwnership(address newOwner) internal virtual {
391         address oldOwner = _owner;
392         _owner = newOwner;
393         emit OwnershipTransferred(oldOwner, newOwner);
394     }
395 }
396 
397 // File: contracts/CheddaSwap.sol
398 
399 /**
400  * @dev Contract module that helps prevent reentrant calls to a function.
401  *
402  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
403  * available, which can be applied to functions to make sure there are no nested
404  * (reentrant) calls to them.
405  *
406  * Note that because there is a single `nonReentrant` guard, functions marked as
407  * `nonReentrant` may not call one another. This can be worked around by making
408  * those functions `private`, and then adding `external` `nonReentrant` entry
409  * points to them.
410  *
411  * TIP: If you would like to learn more about reentrancy and alternative ways
412  * to protect against it, check out our blog post
413  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
414  */
415 abstract contract ReentrancyGuard {
416     // Booleans are more expensive than uint256 or any type that takes up a full
417     // word because each write operation emits an extra SLOAD to first read the
418     // slot's contents, replace the bits taken up by the boolean, and then write
419     // back. This is the compiler's defense against contract upgrades and
420     // pointer aliasing, and it cannot be disabled.
421 
422     // The values being non-zero value makes deployment a bit more expensive,
423     // but in exchange the refund on every call to nonReentrant will be lower in
424     // amount. Since refunds are capped to a percentage of the total
425     // transaction's gas, it is best to keep them low in cases like this one, to
426     // increase the likelihood of the full refund coming into effect.
427     uint256 private constant _NOT_ENTERED = 1;
428     uint256 private constant _ENTERED = 2;
429 
430     uint256 private _status;
431 
432     constructor() {
433         _status = _NOT_ENTERED;
434     }
435 
436     /**
437      * @dev Prevents a contract from calling itself, directly or indirectly.
438      * Calling a `nonReentrant` function from another `nonReentrant`
439      * function is not supported. It is possible to prevent this from happening
440      * by making the `nonReentrant` function external, and make it call a
441      * `private` function that does the actual work.
442      */
443     modifier nonReentrant() {
444         // On the first call to nonReentrant, _notEntered will be true
445         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
446 
447         // Any calls to nonReentrant after this point will fail
448         _status = _ENTERED;
449 
450         _;
451 
452         // By storing the original value once again, a refund is triggered (see
453         // https://eips.ethereum.org/EIPS/eip-2200)
454         _status = _NOT_ENTERED;
455     }
456 }
457 
458 
459 contract CheddaSwap is Context, ReentrancyGuard, Ownable {
460     using Address for address payable;
461     
462     event Swap(address indexed user, uint256 outAmount);
463     event PayeeTransferred(address indexed previousPayee, address indexed newPayee);
464 
465     IERC20 public token;
466 
467     IERC20 public ratTrapToken;
468 
469     uint256 public minRatTrapHolding;
470     uint256 public minCheddaToSwap = 15 * 10**18;
471     
472     bool public isSwapStarted;
473 
474     uint8 public swapRate = 1;
475     uint256 public swapRatio = 3000; // Chedda Reward rate is swapRate / swapRatio i.e. 1:3000
476     
477     // Total ETH Swapped
478     uint256 public totalSwapped;
479    
480     constructor (IERC20 _token, IERC20 _ratTrapToken) {
481         token = _token;
482         ratTrapToken = _ratTrapToken;
483     }
484 
485     /**
486      * @dev fallback function ***DO NOT OVERRIDE***
487      * Note that other contracts will transfer funds with a base gas stipend
488      * of 2300, which is not enough to call buyTokens. Consider calling
489      * buyTokens directly when purchasing tokens from a contract.
490      */
491     receive() external payable {
492     }
493 
494     function swap(IERC20 _token, uint256 weiAmount) public nonReentrant{
495         uint256 quota = address(this).balance;
496         require(_token == IERC20(token), "Can only swap chedda");
497         require(isSwapStarted == true, "CheddaSwap::Swap not started");
498         require(IERC20(token).balanceOf(msg.sender) > 0, "You don't have enough Chedda balance");
499         require(IERC20(ratTrapToken).balanceOf(msg.sender) >= minRatTrapHolding, "You don't have enough RatTrap balance");
500         require(weiAmount >= minCheddaToSwap, "Require minimum Chedda to swap");
501 
502         uint256 outAmount = weiAmount * swapRate / swapRatio;
503         require(quota >= outAmount, "Not enough ETH in the contract to swap");
504     
505         totalSwapped += outAmount;
506         quota -= outAmount;
507 
508         IERC20(token).transferFrom(msg.sender, address(0xdead), weiAmount);
509 
510         payable(msg.sender).transfer(outAmount);
511 
512         emit Swap(msg.sender, outAmount);
513     }
514     
515 
516     function startSwap() public onlyOwner returns (bool) {
517         isSwapStarted = true;
518         return true;
519     }
520 
521     function stopSwap() public onlyOwner returns (bool) {
522         isSwapStarted = false;
523         return true;
524     }
525     
526     function setSwapRate(uint8 newRate) public onlyOwner returns (uint8) {
527         swapRate = newRate;
528         return newRate;
529     }
530 
531     function setSwapRatio(uint256 newRatio) public onlyOwner returns (uint256) {
532         swapRatio = newRatio;
533         return newRatio;
534     }
535 
536     function updateMinHolding(uint256 newVal) external onlyOwner returns(uint256) {
537         minRatTrapHolding = newVal * 10**18;
538         return newVal;
539     }
540 
541     function updateMinCheddaToSwap(uint256 newVal) external onlyOwner returns(uint256) {
542         minCheddaToSwap = newVal * 10**18;
543         return newVal;
544     }
545 
546     function updateCheddaToken(address _token) external onlyOwner returns(address) {
547         token = IERC20(_token);
548 
549         return _token;
550     }
551 
552     function updateRatTrapToken(address _token) external onlyOwner returns(address) {
553         ratTrapToken = IERC20(_token);
554 
555         return _token;
556     }
557 
558    function recoverLostETH() public onlyOwner {
559         payable(owner()).sendValue (address(this).balance);
560     }
561 
562     function WithdrawOtherTokens(address _token, uint256 amount) public onlyOwner {
563         IERC20(_token).transfer(msg.sender, amount);
564     }
565 }