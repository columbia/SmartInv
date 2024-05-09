1 pragma solidity 0.6.12;
2 
3 
4 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
5 /**
6  * @dev Interface of the ERC20 , add some function for gToken and cToken
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
77 
78 
79 }
80 
81 
82 library SafeMath {
83 
84     function add(uint256 a, uint256 b) internal pure returns (uint256) {
85         uint256 c = a + b;
86         require(c >= a, "SafeMath: addition overflow");
87 
88         return c;
89     }
90 
91     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
92         return sub(a, b, "SafeMath: subtraction overflow");
93     }
94 
95     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
96         require(b <= a, errorMessage);
97         uint256 c = a - b;
98 
99         return c;
100     }
101 
102     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
104         // benefit is lost if 'b' is also tested.
105         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
106         if (a == 0) {
107             return 0;
108         }
109 
110         uint256 c = a * b;
111         require(c / a == b, "SafeMath: multiplication overflow");
112 
113         return c;
114     }
115 
116     function div(uint256 a, uint256 b) internal pure returns (uint256) {
117         return div(a, b, "SafeMath: division by zero");
118     }
119 
120     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
121         require(b > 0, errorMessage);
122         uint256 c = a / b;
123         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
124 
125         return c;
126     }
127 
128     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
129         return mod(a, b, "SafeMath: modulo by zero");
130     }
131 
132    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
133         require(b != 0, errorMessage);
134         return a % b;
135     }
136 }
137 
138 
139 // File: @openzeppelin/contracts/utils/Address.sol
140 
141 
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
165         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
166         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
167         // for accounts without code, i.e. `keccak256('')`
168         bytes32 codehash;
169         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
170         // solhint-disable-next-line no-inline-assembly
171         assembly { codehash := extcodehash(account) }
172         return (codehash != accountHash && codehash != 0x0);
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
228         return _functionCallWithValue(target, data, 0, errorMessage);
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
254         return _functionCallWithValue(target, data, value, errorMessage);
255     }
256 
257     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
258         require(isContract(target), "Address: call to non-contract");
259 
260         // solhint-disable-next-line avoid-low-level-calls
261         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
262         if (success) {
263             return returndata;
264         } else {
265             // Look for revert reason and bubble it up if present
266             if (returndata.length > 0) {
267                 // The easiest way to bubble the revert reason is using memory via assembly
268 
269                 // solhint-disable-next-line no-inline-assembly
270                 assembly {
271                     let returndata_size := mload(returndata)
272                     revert(add(32, returndata), returndata_size)
273                 }
274             } else {
275                 revert(errorMessage);
276             }
277         }
278     }
279 }
280 
281 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
282 
283 
284 
285 
286 
287 
288 
289 /**
290  * @title SafeERC20
291  * @dev Wrappers around ERC20 operations that throw on failure (when the token
292  * contract returns false). Tokens that return no value (and instead revert or
293  * throw on failure) are also supported, non-reverting calls are assumed to be
294  * successful.
295  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
296  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
297  */
298 library SafeERC20 {
299     using SafeMath for uint256;
300     using Address for address;
301 
302     function safeTransfer(IERC20 token, address to, uint256 value) internal {
303         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
304     }
305 
306     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
307         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
308     }
309 
310     /**
311      * @dev Deprecated. This function has issues similar to the ones found in
312      * {IERC20-approve}, and its usage is discouraged.
313      *
314      * Whenever possible, use {safeIncreaseAllowance} and
315      * {safeDecreaseAllowance} instead.
316      */
317     function safeApprove(IERC20 token, address spender, uint256 value) internal {
318         // safeApprove should only be called when setting an initial allowance,
319         // or when resetting it to zero. To increase and decrease it, use
320         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
321         // solhint-disable-next-line max-line-length
322         require((value == 0) || (token.allowance(address(this), spender) == 0),
323             "SafeERC20: approve from non-zero to non-zero allowance"
324         );
325         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
326     }
327 
328     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
329         uint256 newAllowance = token.allowance(address(this), spender).add(value);
330         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
331     }
332 
333     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
334         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
335         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
336     }
337 
338     /**
339      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
340      * on the return value: the return value is optional (but if data is returned, it must not be false).
341      * @param token The token targeted by the call.
342      * @param data The call data (encoded using abi.encode or one of its variants).
343      */
344     function _callOptionalReturn(IERC20 token, bytes memory data) private {
345         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
346         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
347         // the target address contains contract code and also asserts for success in the low-level call.
348 
349         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
350         if (returndata.length > 0) { // Return data is optional
351             // solhint-disable-next-line max-line-length
352             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
353         }
354     }
355 }
356 
357 
358 
359 contract Ownable {
360     address public owner;
361     address public newowner;
362     address public admin;
363     address public dev;
364 
365     constructor() public {
366         owner = msg.sender;
367     }
368 
369     modifier onlyOwner {
370         require(msg.sender == owner);
371         _;
372     }
373 
374     modifier onlyNewOwner {
375         require(msg.sender == newowner);
376         _;
377     }
378     
379     function transferOwnership(address _newOwner) public onlyOwner {
380         newowner = _newOwner;
381     }
382     
383     function takeOwnership() public onlyNewOwner {
384         owner = newowner;
385     }    
386     
387     function setAdmin(address _admin) public onlyOwner {
388         admin = _admin;
389     }
390     
391     function setDev(address _dev) public onlyOwner {
392         dev = _dev;
393     }
394     
395     modifier onlyAdmin {
396         require(msg.sender == admin || msg.sender == owner);
397         _;
398     }
399 
400     modifier onlyDev {
401         require(msg.sender == dev || msg.sender == admin || msg.sender == owner);
402         _;
403     }    
404 }
405 
406 
407 contract PledgeDeposit is Ownable{
408 
409     using SafeMath for uint256;
410     using SafeERC20 for IERC20;
411 
412     
413     struct PoolInfo {
414         IERC20 token;
415         string symbol;
416     }
417 
418     struct DepositInfo {
419         uint256 userOrderId;
420         uint256 depositAmount;
421         uint256 pledgeAmount;
422         uint256 depositTime;
423         uint256 depositBlock;
424         uint256 expireBlock;
425     }
426     
427 
428     IERC20 public zild;
429 
430     /**
431      * @dev  Guard variable for re-entrancy checks
432      */
433     bool internal _notEntered;
434 
435     uint256 public minDepositBlock = 1;
436 
437  
438     PoolInfo[] public poolArray;
439 
440 
441     // poolId , user address, DepositInfo
442     mapping (uint256 => mapping (address => DepositInfo[])) public userDepositMap;
443 
444     mapping (address => uint256) public lastUserOrderIdMap;
445 
446     uint256 public pledgeBalance;    
447 
448     event NewPool(address addr, string symbol);
449 
450     event UpdateMinDepositBlock(uint256 dblock,address  who,uint256 time);
451 
452     event ZildBurnDeposit(address  userAddress,uint256 userOrderId, uint256 burnAmount);
453     event Deposit(address  userAddress,uint256 userOrderId, uint256 poolId,string symbol,uint256 depositId, uint256 depositAmount,uint256 pledgeAmount);
454     event Withdraw(address  userAddress,uint256 userOrderId, uint256 poolId,string symbol,uint256 depositId, uint256 depositAmount,uint256 pledgeAmount);
455     
456     constructor(address _zild,address _usdt) public {
457         zild = IERC20(_zild);
458 
459         // poolArray[0] :  ETH 
460         addPool(address(0),'ETH');  
461 
462         // poolArray[1] : ZILD  
463         addPool(_zild,'ZILD');  
464 
465         // poolArray[2] : USDT  
466         addPool(_usdt,'USDT');  
467 
468         _notEntered = true;
469   
470     }
471 
472         /*** Reentrancy Guard ***/
473 
474     /**
475      * Prevents a contract from calling itself, directly or indirectly.
476      */
477     modifier nonReentrant() {
478         require(_notEntered, "re-entered");
479         _notEntered = false;
480         _;
481         _notEntered = true; // get a gas-refund post-Istanbul
482     }
483     
484 
485     function addPool(address  _token, string memory _symbol) public onlyAdmin {
486         poolArray.push(PoolInfo({token: IERC20(_token),symbol: _symbol}));
487         emit NewPool(_token, _symbol);
488     }
489 
490     function poolLength() external view returns (uint256) {
491         return poolArray.length;
492     }
493 
494     function updateMinDepositBlock(uint256 _minDepositBlock) public onlyAdmin {
495         require(_minDepositBlock > 0,"Desposit: New deposit time must be greater than 0");
496         minDepositBlock = _minDepositBlock;
497         emit UpdateMinDepositBlock(minDepositBlock,msg.sender,now);
498     }
499       
500     function tokenDepositCount(address _user, uint256 _poolId)  view public returns(uint256) {
501         require(_poolId < poolArray.length, "invalid _poolId");
502         return userDepositMap[_poolId][_user].length;
503     }
504 
505     function burnDeposit(uint256 _userOrderId, uint256 _burnAmount) public{
506        require(_userOrderId > lastUserOrderIdMap[msg.sender], "_userOrderId should greater than lastUserOrderIdMap[msg.sender]");
507        
508        lastUserOrderIdMap[msg.sender]  = _userOrderId;
509        
510        zild.transferFrom(address(msg.sender), address(1024), _burnAmount);       
511   
512        emit ZildBurnDeposit(msg.sender, _userOrderId, _burnAmount);
513     }
514 
515     function deposit(uint256 _userOrderId, uint256 _poolId, uint256 _depositAmount,uint256 _pledgeAmount) public nonReentrant  payable{
516        require(_poolId < poolArray.length, "invalid _poolId");
517        require(_userOrderId > lastUserOrderIdMap[msg.sender], "_userOrderId should greater than lastUserOrderIdMap[msg.sender]");
518        
519        lastUserOrderIdMap[msg.sender]  = _userOrderId;
520        PoolInfo storage poolInfo = poolArray[_poolId];
521 
522        // ETH
523        if(_poolId == 0){
524             require(_depositAmount == msg.value, "invald  _depositAmount for ETH");
525             zild.safeTransferFrom(address(msg.sender), address(this), _pledgeAmount);
526        }
527        // ZILD
528        else if(_poolId == 1){
529             uint256 zildAmount = _pledgeAmount.add(_depositAmount);
530             zild.safeTransferFrom(address(msg.sender), address(this), zildAmount);
531        }
532        else{
533             zild.safeTransferFrom(address(msg.sender), address(this), _pledgeAmount);
534             poolInfo.token.safeTransferFrom(address(msg.sender), address(this), _depositAmount);
535        }
536 
537        pledgeBalance = pledgeBalance.add(_pledgeAmount);
538 
539        uint256 depositId = userDepositMap[_poolId][msg.sender].length;
540        userDepositMap[_poolId][msg.sender].push(
541             DepositInfo({
542                 userOrderId: _userOrderId,
543                 depositAmount: _depositAmount,
544                 pledgeAmount: _pledgeAmount,
545                 depositTime: now,
546                 depositBlock: block.number,
547                 expireBlock: block.number.add(minDepositBlock)
548             })
549         );
550     
551         emit Deposit(msg.sender, _userOrderId, _poolId, poolInfo.symbol, depositId, _depositAmount, _pledgeAmount);
552     }
553 
554     function getUserDepositInfo(address _user, uint256 _poolId,uint256 _depositId) public view returns (
555         uint256 _userOrderId, uint256 _depositAmount,uint256 _pledgeAmount,uint256 _depositTime,uint256 _depositBlock,uint256 _expireBlock) {
556         require(_poolId < poolArray.length, "invalid _poolId");
557         require(_depositId < userDepositMap[_poolId][_user].length, "invalid _depositId");
558 
559         DepositInfo memory depositInfo = userDepositMap[_poolId][_user][_depositId];
560         
561         _userOrderId = depositInfo.userOrderId;
562         _depositAmount = depositInfo.depositAmount;
563         _pledgeAmount = depositInfo.pledgeAmount;
564         _depositTime = depositInfo.depositTime;
565         _depositBlock = depositInfo.depositBlock;
566         _expireBlock = depositInfo.expireBlock;
567     }
568 
569     function withdraw(uint256 _poolId,uint256 _depositId) public nonReentrant {
570         require(_poolId < poolArray.length, "invalid _poolId");
571         require(_depositId < userDepositMap[_poolId][msg.sender].length, "invalid _depositId");
572 
573         PoolInfo storage poolInfo = poolArray[_poolId];
574         DepositInfo storage depositInfo = userDepositMap[_poolId][msg.sender][_depositId];
575 
576         require(block.number > depositInfo.expireBlock, "The withdrawal block has not arrived");
577         uint256 depositAmount =  depositInfo.depositAmount;
578         require( depositAmount > 0, "There is no deposit available!");
579 
580         uint256 pledgeAmount = depositInfo.pledgeAmount;
581 
582         pledgeBalance = pledgeBalance.sub(pledgeAmount);
583         depositInfo.depositAmount =  0;    
584         depositInfo.pledgeAmount = 0;
585 
586         // ETH
587         if(_poolId == 0) {
588             msg.sender.transfer(depositAmount);
589             zild.safeTransfer(msg.sender,pledgeAmount);
590         }
591         // ZILD
592         else if(_poolId == 1){
593             zild.safeTransfer(msg.sender, depositAmount.add(pledgeAmount));
594         }
595         else{
596             poolInfo.token.safeTransfer(msg.sender, depositAmount);
597             zild.safeTransfer(msg.sender,pledgeAmount);
598         }   
599       
600         emit Withdraw(msg.sender, depositInfo.userOrderId, _poolId, poolInfo.symbol, _depositId, depositAmount, pledgeAmount);
601       }
602 }