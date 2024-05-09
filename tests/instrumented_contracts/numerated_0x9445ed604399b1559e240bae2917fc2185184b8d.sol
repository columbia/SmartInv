1 // File: @openzeppelin/contracts/utils/Address.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
5 
6 pragma solidity ^0.8.1;
7 
8 /**
9  * @dev Collection of functions related to the address type
10  */
11 library Address {
12     /**
13      * @dev Returns true if `account` is a contract.
14      *
15      * [IMPORTANT]
16      * ====
17      * It is unsafe to assume that an address for which this function returns
18      * false is an externally-owned account (EOA) and not a contract.
19      *
20      * Among others, `isContract` will return false for the following
21      * types of addresses:
22      *
23      *  - an externally-owned account
24      *  - a contract in construction
25      *  - an address where a contract will be created
26      *  - an address where a contract lived, but was destroyed
27      * ====
28      *
29      * [IMPORTANT]
30      * ====
31      * You shouldn't rely on `isContract` to protect against flash loan attacks!
32      *
33      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
34      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
35      * constructor.
36      * ====
37      */
38     function isContract(address account) internal view returns (bool) {
39         // This method relies on extcodesize/address.code.length, which returns 0
40         // for contracts in construction, since the code is only stored at the end
41         // of the constructor execution.
42 
43         return account.code.length > 0;
44     }
45 
46     /**
47      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
48      * `recipient`, forwarding all available gas and reverting on errors.
49      *
50      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
51      * of certain opcodes, possibly making contracts go over the 2300 gas limit
52      * imposed by `transfer`, making them unable to receive funds via
53      * `transfer`. {sendValue} removes this limitation.
54      *
55      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
56      *
57      * IMPORTANT: because control is transferred to `recipient`, care must be
58      * taken to not create reentrancy vulnerabilities. Consider using
59      * {ReentrancyGuard} or the
60      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
61      */
62     function sendValue(address payable recipient, uint256 amount) internal {
63         require(address(this).balance >= amount, "Address: insufficient balance");
64 
65         (bool success, ) = recipient.call{value: amount}("");
66         require(success, "Address: unable to send value, recipient may have reverted");
67     }
68 
69     /**
70      * @dev Performs a Solidity function call using a low level `call`. A
71      * plain `call` is an unsafe replacement for a function call: use this
72      * function instead.
73      *
74      * If `target` reverts with a revert reason, it is bubbled up by this
75      * function (like regular Solidity function calls).
76      *
77      * Returns the raw returned data. To convert to the expected return value,
78      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
79      *
80      * Requirements:
81      *
82      * - `target` must be a contract.
83      * - calling `target` with `data` must not revert.
84      *
85      * _Available since v3.1._
86      */
87     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
88         return functionCall(target, data, "Address: low-level call failed");
89     }
90 
91     /**
92      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
93      * `errorMessage` as a fallback revert reason when `target` reverts.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(
98         address target,
99         bytes memory data,
100         string memory errorMessage
101     ) internal returns (bytes memory) {
102         return functionCallWithValue(target, data, 0, errorMessage);
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
107      * but also transferring `value` wei to `target`.
108      *
109      * Requirements:
110      *
111      * - the calling contract must have an ETH balance of at least `value`.
112      * - the called Solidity function must be `payable`.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(
117         address target,
118         bytes memory data,
119         uint256 value
120     ) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
126      * with `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value,
134         string memory errorMessage
135     ) internal returns (bytes memory) {
136         require(address(this).balance >= value, "Address: insufficient balance for call");
137         require(isContract(target), "Address: call to non-contract");
138 
139         (bool success, bytes memory returndata) = target.call{value: value}(data);
140         return verifyCallResult(success, returndata, errorMessage);
141     }
142 
143     /**
144      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
145      * but performing a static call.
146      *
147      * _Available since v3.3._
148      */
149     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
150         return functionStaticCall(target, data, "Address: low-level static call failed");
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
155      * but performing a static call.
156      *
157      * _Available since v3.3._
158      */
159     function functionStaticCall(
160         address target,
161         bytes memory data,
162         string memory errorMessage
163     ) internal view returns (bytes memory) {
164         require(isContract(target), "Address: static call to non-contract");
165 
166         (bool success, bytes memory returndata) = target.staticcall(data);
167         return verifyCallResult(success, returndata, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but performing a delegate call.
173      *
174      * _Available since v3.4._
175      */
176     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
177         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
182      * but performing a delegate call.
183      *
184      * _Available since v3.4._
185      */
186     function functionDelegateCall(
187         address target,
188         bytes memory data,
189         string memory errorMessage
190     ) internal returns (bytes memory) {
191         require(isContract(target), "Address: delegate call to non-contract");
192 
193         (bool success, bytes memory returndata) = target.delegatecall(data);
194         return verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     /**
198      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
199      * revert reason using the provided one.
200      *
201      * _Available since v4.3._
202      */
203     function verifyCallResult(
204         bool success,
205         bytes memory returndata,
206         string memory errorMessage
207     ) internal pure returns (bytes memory) {
208         if (success) {
209             return returndata;
210         } else {
211             // Look for revert reason and bubble it up if present
212             if (returndata.length > 0) {
213                 // The easiest way to bubble the revert reason is using memory via assembly
214 
215                 assembly {
216                     let returndata_size := mload(returndata)
217                     revert(add(32, returndata), returndata_size)
218                 }
219             } else {
220                 revert(errorMessage);
221             }
222         }
223     }
224 }
225 
226 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
227 
228 
229 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
230 
231 pragma solidity ^0.8.0;
232 
233 /**
234  * @dev Interface of the ERC20 standard as defined in the EIP.
235  */
236 interface IERC20 {
237     /**
238      * @dev Returns the amount of tokens in existence.
239      */
240     function totalSupply() external view returns (uint256);
241 
242     /**
243      * @dev Returns the amount of tokens owned by `account`.
244      */
245     function balanceOf(address account) external view returns (uint256);
246 
247     /**
248      * @dev Moves `amount` tokens from the caller's account to `to`.
249      *
250      * Returns a boolean value indicating whether the operation succeeded.
251      *
252      * Emits a {Transfer} event.
253      */
254     function transfer(address to, uint256 amount) external returns (bool);
255 
256     /**
257      * @dev Returns the remaining number of tokens that `spender` will be
258      * allowed to spend on behalf of `owner` through {transferFrom}. This is
259      * zero by default.
260      *
261      * This value changes when {approve} or {transferFrom} are called.
262      */
263     function allowance(address owner, address spender) external view returns (uint256);
264 
265     /**
266      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
267      *
268      * Returns a boolean value indicating whether the operation succeeded.
269      *
270      * IMPORTANT: Beware that changing an allowance with this method brings the risk
271      * that someone may use both the old and the new allowance by unfortunate
272      * transaction ordering. One possible solution to mitigate this race
273      * condition is to first reduce the spender's allowance to 0 and set the
274      * desired value afterwards:
275      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
276      *
277      * Emits an {Approval} event.
278      */
279     function approve(address spender, uint256 amount) external returns (bool);
280 
281     /**
282      * @dev Moves `amount` tokens from `from` to `to` using the
283      * allowance mechanism. `amount` is then deducted from the caller's
284      * allowance.
285      *
286      * Returns a boolean value indicating whether the operation succeeded.
287      *
288      * Emits a {Transfer} event.
289      */
290     function transferFrom(
291         address from,
292         address to,
293         uint256 amount
294     ) external returns (bool);
295 
296     /**
297      * @dev Emitted when `value` tokens are moved from one account (`from`) to
298      * another (`to`).
299      *
300      * Note that `value` may be zero.
301      */
302     event Transfer(address indexed from, address indexed to, uint256 value);
303 
304     /**
305      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
306      * a call to {approve}. `value` is the new allowance.
307      */
308     event Approval(address indexed owner, address indexed spender, uint256 value);
309 }
310 
311 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
312 
313 
314 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
315 
316 pragma solidity ^0.8.0;
317 
318 
319 
320 /**
321  * @title SafeERC20
322  * @dev Wrappers around ERC20 operations that throw on failure (when the token
323  * contract returns false). Tokens that return no value (and instead revert or
324  * throw on failure) are also supported, non-reverting calls are assumed to be
325  * successful.
326  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
327  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
328  */
329 library SafeERC20 {
330     using Address for address;
331 
332     function safeTransfer(
333         IERC20 token,
334         address to,
335         uint256 value
336     ) internal {
337         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
338     }
339 
340     function safeTransferFrom(
341         IERC20 token,
342         address from,
343         address to,
344         uint256 value
345     ) internal {
346         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
347     }
348 
349     /**
350      * @dev Deprecated. This function has issues similar to the ones found in
351      * {IERC20-approve}, and its usage is discouraged.
352      *
353      * Whenever possible, use {safeIncreaseAllowance} and
354      * {safeDecreaseAllowance} instead.
355      */
356     function safeApprove(
357         IERC20 token,
358         address spender,
359         uint256 value
360     ) internal {
361         // safeApprove should only be called when setting an initial allowance,
362         // or when resetting it to zero. To increase and decrease it, use
363         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
364         require(
365             (value == 0) || (token.allowance(address(this), spender) == 0),
366             "SafeERC20: approve from non-zero to non-zero allowance"
367         );
368         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
369     }
370 
371     function safeIncreaseAllowance(
372         IERC20 token,
373         address spender,
374         uint256 value
375     ) internal {
376         uint256 newAllowance = token.allowance(address(this), spender) + value;
377         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
378     }
379 
380     function safeDecreaseAllowance(
381         IERC20 token,
382         address spender,
383         uint256 value
384     ) internal {
385         unchecked {
386             uint256 oldAllowance = token.allowance(address(this), spender);
387             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
388             uint256 newAllowance = oldAllowance - value;
389             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
390         }
391     }
392 
393     /**
394      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
395      * on the return value: the return value is optional (but if data is returned, it must not be false).
396      * @param token The token targeted by the call.
397      * @param data The call data (encoded using abi.encode or one of its variants).
398      */
399     function _callOptionalReturn(IERC20 token, bytes memory data) private {
400         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
401         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
402         // the target address contains contract code and also asserts for success in the low-level call.
403 
404         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
405         if (returndata.length > 0) {
406             // Return data is optional
407             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
408         }
409     }
410 }
411 
412 // File: contracts/HeartCollector.sol
413 
414 
415 pragma solidity 0.8.10;
416 
417 
418 
419 contract HeartCollector{
420     address private  _owner;
421     address private  _operator;
422     IERC20 private   _contract;
423 
424     uint256 private _epochStart;
425     uint256 private _epochDuration;
426     uint256 private _maxAPE;
427     
428     mapping(address => uint) private _balances;
429 
430     event Deposit(address indexed _from, uint256 indexed _amount);
431     event Withdraw(address indexed _to, uint256 indexed _amount);
432 
433 
434     constructor(){
435         _owner=msg.sender;
436         _operator=msg.sender;
437 
438         _contract=IERC20(0x8FAc8031e079F409135766C7d5De29cf22EF897C);
439 
440         _epochStart=1646226000; //1 march 2022 13:00 UTC
441         _epochDuration=604800; //1 week
442         _maxAPE=3; //in percent
443 
444     }
445 
446     receive() payable external{
447     }
448 
449     function setEpochDuration(uint256 duration)public{
450         require(msg.sender == _owner, "Only owner can set the epoch start"); 
451         _epochDuration=duration;
452     }
453 
454     function setEpochStart()public{
455         require(msg.sender == _owner, "Only owner can set the epoch start"); 
456         _epochStart=block.timestamp;
457     }
458 
459     function currentEpoch() public view returns (uint256 epoch){
460         epoch=(block.timestamp-_epochStart)/_epochDuration;
461     }
462 
463     function setAPE(uint256 newAPE)public{
464         require(msg.sender == _owner, "Only owner can set a new APE"); 
465         _maxAPE=newAPE;
466     }
467     
468     function withdrawETH(address payable to, uint256 amount)public{
469         require(msg.sender == _owner, "Only owner can send ETH"); 
470         to.transfer(amount);
471     }
472 
473     function setOwner(address newOwner) public{
474         require(msg.sender == _owner, "Only owner can set a new owner"); 
475         _owner=newOwner;
476     }
477 
478     function setOperator(address newOperator) public{
479         require(msg.sender == _owner, "Only owner can set a new operator"); 
480         _operator=newOperator;
481     }
482 
483     function setContract(IERC20 contractAddress) public{
484         require(msg.sender == _owner, "Only owner can set a new contract"); 
485         _contract=contractAddress;
486     }
487         
488     function balanceOf(address owner) public view returns (uint256 amount) {
489         amount=_balances[owner];
490     }
491 
492     function collectorBalance() public view returns (uint256 balance){
493         balance = _contract.balanceOf(address(this));
494     }
495 
496 
497     function deposit(uint256 amount) public{
498         _contract.transferFrom(msg.sender,address(this),amount);
499         emit Deposit(msg.sender,amount);
500         _balances[msg.sender]+=amount;
501     }
502 
503 
504 
505     function withdraw(address to, uint256 amount) public{
506         require(msg.sender == _owner || msg.sender ==_operator, "Only owner or operator can withdraw funds"); 
507 
508         uint256 epochsElapsed=(block.timestamp-_epochStart)/_epochDuration;
509         uint256 maxWithdrawable=_balances[to]+(_balances[to]*epochsElapsed*_maxAPE)/100;
510 
511         require(amount<=maxWithdrawable,"The amount does not match the max reward calculations");
512 
513         uint256 balance = _contract.balanceOf(address(this));
514         require(amount <= balance, "Insufficient funds");
515 
516         if(amount>_balances[to]){
517             _balances[to]=0;
518         }else{
519             _balances[to]-=amount;
520         }
521 
522         _contract.transfer(to, amount);
523         emit Deposit(to,amount);
524 
525     }
526 
527     function forceWithdraw()public{
528         require(msg.sender == _owner, "Only owner can force withdraw"); 
529         uint256 balance=_contract.balanceOf(address(this));
530         _contract.transfer(_owner,balance);
531     } 
532 }