1 // File: contracts/intf/IDODOApprove.sol
2 
3 /*
4 
5     Copyright 2021 DODO ZOO.
6     SPDX-License-Identifier: Apache-2.0
7 
8 */
9 
10 pragma solidity 0.6.9;
11 pragma experimental ABIEncoderV2;
12 
13 interface IDODOApprove {
14     function claimTokens(address token,address who,address dest,uint256 amount) external;
15     function getDODOProxy() external view returns (address);
16 }
17 
18 // File: contracts/lib/InitializableOwnable.sol
19 
20 /**
21  * @title Ownable
22  * @author DODO Breeder
23  *
24  * @notice Ownership related functions
25  */
26 contract InitializableOwnable {
27     address public _OWNER_;
28     address public _NEW_OWNER_;
29     bool internal _INITIALIZED_;
30 
31     // ============ Events ============
32 
33     event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);
34 
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37     // ============ Modifiers ============
38 
39     modifier notInitialized() {
40         require(!_INITIALIZED_, "DODO_INITIALIZED");
41         _;
42     }
43 
44     modifier onlyOwner() {
45         require(msg.sender == _OWNER_, "NOT_OWNER");
46         _;
47     }
48 
49     // ============ Functions ============
50 
51     function initOwner(address newOwner) public notInitialized {
52         _INITIALIZED_ = true;
53         _OWNER_ = newOwner;
54     }
55 
56     function transferOwnership(address newOwner) public onlyOwner {
57         emit OwnershipTransferPrepared(_OWNER_, newOwner);
58         _NEW_OWNER_ = newOwner;
59     }
60 
61     function claimOwnership() public {
62         require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");
63         emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);
64         _OWNER_ = _NEW_OWNER_;
65         _NEW_OWNER_ = address(0);
66     }
67 }
68 
69 // File: contracts/SmartRoute/DODOApproveProxy.sol
70 
71 interface IDODOApproveProxy {
72     function isAllowedProxy(address _proxy) external view returns (bool);
73     function claimTokens(address token,address who,address dest,uint256 amount) external;
74 }
75 
76 /**
77  * @title DODOApproveProxy
78  * @author DODO Breeder
79  *
80  * @notice Allow different version dodoproxy to claim from DODOApprove
81  */
82 contract DODOApproveProxy is InitializableOwnable {
83     
84     // ============ Storage ============
85     uint256 private constant _TIMELOCK_DURATION_ = 3 days;
86     mapping (address => bool) public _IS_ALLOWED_PROXY_;
87     uint256 public _TIMELOCK_;
88     address public _PENDING_ADD_DODO_PROXY_;
89     address public immutable _DODO_APPROVE_;
90 
91     // ============ Modifiers ============
92     modifier notLocked() {
93         require(
94             _TIMELOCK_ <= block.timestamp,
95             "SetProxy is timelocked"
96         );
97         _;
98     }
99 
100     constructor(address dodoApporve) public {
101         _DODO_APPROVE_ = dodoApporve;
102     }
103 
104     function init(address owner, address[] memory proxies) external {
105         initOwner(owner);
106         for(uint i = 0; i < proxies.length; i++) 
107             _IS_ALLOWED_PROXY_[proxies[i]] = true;
108     }
109 
110     function unlockAddProxy(address newDodoProxy) public onlyOwner {
111         _TIMELOCK_ = block.timestamp + _TIMELOCK_DURATION_;
112         _PENDING_ADD_DODO_PROXY_ = newDodoProxy;
113     }
114 
115     function lockAddProxy() public onlyOwner {
116        _PENDING_ADD_DODO_PROXY_ = address(0);
117        _TIMELOCK_ = 0;
118     }
119 
120 
121     function addDODOProxy() external onlyOwner notLocked() {
122         _IS_ALLOWED_PROXY_[_PENDING_ADD_DODO_PROXY_] = true;
123         lockAddProxy();
124     }
125 
126     function removeDODOProxy (address oldDodoProxy) public onlyOwner {
127         _IS_ALLOWED_PROXY_[oldDodoProxy] = false;
128     }
129     
130     function claimTokens(
131         address token,
132         address who,
133         address dest,
134         uint256 amount
135     ) external {
136         require(_IS_ALLOWED_PROXY_[msg.sender], "DODOApproveProxy:Access restricted");
137         IDODOApprove(_DODO_APPROVE_).claimTokens(
138             token,
139             who,
140             dest,
141             amount
142         );
143     }
144 
145     function isAllowedProxy(address _proxy) external view returns (bool) {
146         return _IS_ALLOWED_PROXY_[_proxy];
147     }
148 }
149 
150 // File: contracts/intf/IERC20.sol
151 
152 
153 /**
154  * @dev Interface of the ERC20 standard as defined in the EIP.
155  */
156 interface IERC20 {
157     /**
158      * @dev Returns the amount of tokens in existence.
159      */
160     function totalSupply() external view returns (uint256);
161 
162     function decimals() external view returns (uint8);
163 
164     function name() external view returns (string memory);
165 
166     function symbol() external view returns (string memory);
167 
168     /**
169      * @dev Returns the amount of tokens owned by `account`.
170      */
171     function balanceOf(address account) external view returns (uint256);
172 
173     /**
174      * @dev Moves `amount` tokens from the caller's account to `recipient`.
175      *
176      * Returns a boolean value indicating whether the operation succeeded.
177      *
178      * Emits a {Transfer} event.
179      */
180     function transfer(address recipient, uint256 amount) external returns (bool);
181 
182     /**
183      * @dev Returns the remaining number of tokens that `spender` will be
184      * allowed to spend on behalf of `owner` through {transferFrom}. This is
185      * zero by default.
186      *
187      * This value changes when {approve} or {transferFrom} are called.
188      */
189     function allowance(address owner, address spender) external view returns (uint256);
190 
191     /**
192      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
193      *
194      * Returns a boolean value indicating whether the operation succeeded.
195      *
196      * IMPORTANT: Beware that changing an allowance with this method brings the risk
197      * that someone may use both the old and the new allowance by unfortunate
198      * transaction ordering. One possible solution to mitigate this race
199      * condition is to first reduce the spender's allowance to 0 and set the
200      * desired value afterwards:
201      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
202      *
203      * Emits an {Approval} event.
204      */
205     function approve(address spender, uint256 amount) external returns (bool);
206 
207     /**
208      * @dev Moves `amount` tokens from `sender` to `recipient` using the
209      * allowance mechanism. `amount` is then deducted from the caller's
210      * allowance.
211      *
212      * Returns a boolean value indicating whether the operation succeeded.
213      *
214      * Emits a {Transfer} event.
215      */
216     function transferFrom(
217         address sender,
218         address recipient,
219         uint256 amount
220     ) external returns (bool);
221 }
222 
223 // File: contracts/intf/IWETH.sol
224 
225 
226 
227 interface IWETH {
228     function totalSupply() external view returns (uint256);
229 
230     function balanceOf(address account) external view returns (uint256);
231 
232     function transfer(address recipient, uint256 amount) external returns (bool);
233 
234     function allowance(address owner, address spender) external view returns (uint256);
235 
236     function approve(address spender, uint256 amount) external returns (bool);
237 
238     function transferFrom(
239         address src,
240         address dst,
241         uint256 wad
242     ) external returns (bool);
243 
244     function deposit() external payable;
245 
246     function withdraw(uint256 wad) external;
247 }
248 
249 // File: contracts/lib/SafeMath.sol
250 
251 
252 /**
253  * @title SafeMath
254  * @author DODO Breeder
255  *
256  * @notice Math operations with safety checks that revert on error
257  */
258 library SafeMath {
259     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
260         if (a == 0) {
261             return 0;
262         }
263 
264         uint256 c = a * b;
265         require(c / a == b, "MUL_ERROR");
266 
267         return c;
268     }
269 
270     function div(uint256 a, uint256 b) internal pure returns (uint256) {
271         require(b > 0, "DIVIDING_ERROR");
272         return a / b;
273     }
274 
275     function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
276         uint256 quotient = div(a, b);
277         uint256 remainder = a - quotient * b;
278         if (remainder > 0) {
279             return quotient + 1;
280         } else {
281             return quotient;
282         }
283     }
284 
285     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
286         require(b <= a, "SUB_ERROR");
287         return a - b;
288     }
289 
290     function add(uint256 a, uint256 b) internal pure returns (uint256) {
291         uint256 c = a + b;
292         require(c >= a, "ADD_ERROR");
293         return c;
294     }
295 
296     function sqrt(uint256 x) internal pure returns (uint256 y) {
297         uint256 z = x / 2 + 1;
298         y = x;
299         while (z < y) {
300             y = z;
301             z = (x / z + z) / 2;
302         }
303     }
304 }
305 
306 // File: contracts/lib/SafeERC20.sol
307 
308 /**
309  * @title SafeERC20
310  * @dev Wrappers around ERC20 operations that throw on failure (when the token
311  * contract returns false). Tokens that return no value (and instead revert or
312  * throw on failure) are also supported, non-reverting calls are assumed to be
313  * successful.
314  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
315  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
316  */
317 library SafeERC20 {
318     using SafeMath for uint256;
319 
320     function safeTransfer(
321         IERC20 token,
322         address to,
323         uint256 value
324     ) internal {
325         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
326     }
327 
328     function safeTransferFrom(
329         IERC20 token,
330         address from,
331         address to,
332         uint256 value
333     ) internal {
334         _callOptionalReturn(
335             token,
336             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
337         );
338     }
339 
340     function safeApprove(
341         IERC20 token,
342         address spender,
343         uint256 value
344     ) internal {
345         // safeApprove should only be called when setting an initial allowance,
346         // or when resetting it to zero. To increase and decrease it, use
347         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
348         // solhint-disable-next-line max-line-length
349         require(
350             (value == 0) || (token.allowance(address(this), spender) == 0),
351             "SafeERC20: approve from non-zero to non-zero allowance"
352         );
353         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
354     }
355 
356     /**
357      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
358      * on the return value: the return value is optional (but if data is returned, it must not be false).
359      * @param token The token targeted by the call.
360      * @param data The call data (encoded using abi.encode or one of its variants).
361      */
362     function _callOptionalReturn(IERC20 token, bytes memory data) private {
363         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
364         // we're implementing it ourselves.
365 
366         // A Solidity high level call has three parts:
367         //  1. The target address is checked to verify it contains contract code
368         //  2. The call itself is made, and success asserted
369         //  3. The return value is decoded, which in turn checks the size of the returned data.
370         // solhint-disable-next-line max-line-length
371 
372         // solhint-disable-next-line avoid-low-level-calls
373         (bool success, bytes memory returndata) = address(token).call(data);
374         require(success, "SafeERC20: low-level call failed");
375 
376         if (returndata.length > 0) {
377             // Return data is optional
378             // solhint-disable-next-line max-line-length
379             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
380         }
381     }
382 }
383 
384 // File: contracts/SmartRoute/lib/UniversalERC20.sol
385 
386 
387 
388 library UniversalERC20 {
389     using SafeMath for uint256;
390     using SafeERC20 for IERC20;
391 
392     IERC20 private constant ETH_ADDRESS = IERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
393 
394     function universalTransfer(
395         IERC20 token,
396         address payable to,
397         uint256 amount
398     ) internal {
399         if (amount > 0) {
400             if (isETH(token)) {
401                 to.transfer(amount);
402             } else {
403                 token.safeTransfer(to, amount);
404             }
405         }
406     }
407 
408     function universalApproveMax(
409         IERC20 token,
410         address to,
411         uint256 amount
412     ) internal {
413         uint256 allowance = token.allowance(address(this), to);
414         if (allowance < amount) {
415             if (allowance > 0) {
416                 token.safeApprove(to, 0);
417             }
418             token.safeApprove(to, uint256(-1));
419         }
420     }
421 
422     function universalBalanceOf(IERC20 token, address who) internal view returns (uint256) {
423         if (isETH(token)) {
424             return who.balance;
425         } else {
426             return token.balanceOf(who);
427         }
428     }
429 
430     function tokenBalanceOf(IERC20 token, address who) internal view returns (uint256) {
431         return token.balanceOf(who);
432     }
433 
434     function isETH(IERC20 token) internal pure returns (bool) {
435         return token == ETH_ADDRESS;
436     }
437 }
438 
439 // File: contracts/SmartRoute/intf/IDODOAdapter.sol
440 
441 
442 interface IDODOAdapter {
443     
444     function sellBase(address to, address pool, bytes memory data) external;
445 
446     function sellQuote(address to, address pool, bytes memory data) external;
447 }
448 
449 // File: contracts/SmartRoute/proxies/DODORouteProxy.sol
450 
451 
452 
453 
454 /**
455  * @title DODORouteProxy
456  * @author DODO Breeder
457  *
458  * @notice Entrance of Split trading in DODO platform
459  */
460 contract DODORouteProxy {
461     using SafeMath for uint256;
462     using UniversalERC20 for IERC20;
463 
464     // ============ Storage ============
465 
466     address constant _ETH_ADDRESS_ = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
467     address public immutable _WETH_;
468     address public immutable _DODO_APPROVE_PROXY_;
469 
470     struct PoolInfo {
471         uint256 direction;
472         uint256 poolEdition;
473         uint256 weight;
474         address pool;
475         address adapter;
476         bytes moreInfo;
477     }
478 
479     // ============ Events ============
480 
481      event OrderHistory(
482         address fromToken,
483         address toToken,
484         address sender,
485         uint256 fromAmount,
486         uint256 returnAmount
487     );
488 
489     // ============ Modifiers ============
490 
491     modifier judgeExpired(uint256 deadLine) {
492         require(deadLine >= block.timestamp, "DODORouteProxy: EXPIRED");
493         _;
494     }
495 
496     fallback() external payable {}
497 
498     receive() external payable {}
499 
500     constructor (
501         address payable weth,
502         address dodoApproveProxy
503     ) public {
504         _WETH_ = weth;
505         _DODO_APPROVE_PROXY_ = dodoApproveProxy;
506     }
507 
508     function mixSwap(
509         address fromToken,
510         address toToken,
511         uint256 fromTokenAmount,
512         uint256 minReturnAmount,
513         address[] memory mixAdapters,
514         address[] memory mixPairs,
515         address[] memory assetTo,
516         uint256 directions,
517         bytes[] memory moreInfos,
518         uint256 deadLine
519     ) external payable judgeExpired(deadLine) returns (uint256 returnAmount) {
520         require(mixPairs.length > 0, "DODORouteProxy: PAIRS_EMPTY");
521         require(mixPairs.length == mixAdapters.length, "DODORouteProxy: PAIR_ADAPTER_NOT_MATCH");
522         require(mixPairs.length == assetTo.length - 1, "DODORouteProxy: PAIR_ASSETTO_NOT_MATCH");
523         require(minReturnAmount > 0, "DODORouteProxy: RETURN_AMOUNT_ZERO");
524 
525         address _fromToken = fromToken;
526         address _toToken = toToken;
527         uint256 _fromTokenAmount = fromTokenAmount;
528         
529         uint256 toTokenOriginBalance = IERC20(_toToken).universalBalanceOf(msg.sender);
530         
531         _deposit(msg.sender, assetTo[0], _fromToken, _fromTokenAmount, _fromToken == _ETH_ADDRESS_);
532 
533         for (uint256 i = 0; i < mixPairs.length; i++) {
534             if (directions & 1 == 0) {
535                 IDODOAdapter(mixAdapters[i]).sellBase(assetTo[i + 1],mixPairs[i], moreInfos[i]);
536             } else {
537                 IDODOAdapter(mixAdapters[i]).sellQuote(assetTo[i + 1],mixPairs[i], moreInfos[i]);
538             }
539             directions = directions >> 1;
540         }
541 
542         if(_toToken == _ETH_ADDRESS_) {
543             returnAmount = IWETH(_WETH_).balanceOf(address(this));
544             IWETH(_WETH_).withdraw(returnAmount);
545             msg.sender.transfer(returnAmount);
546         }else {
547             returnAmount = IERC20(_toToken).tokenBalanceOf(msg.sender).sub(toTokenOriginBalance);
548         }
549 
550         require(returnAmount >= minReturnAmount, "DODORouteProxy: Return amount is not enough");
551 
552         emit OrderHistory(
553             _fromToken,
554             _toToken,
555             msg.sender,
556             _fromTokenAmount,
557             returnAmount
558         );
559     }
560 
561     function dodoMutliSwap(
562         uint256 fromTokenAmount,
563         uint256 minReturnAmount,
564         uint256[] memory totalWeight,
565         uint256[] memory splitNumber,
566         address[] memory midToken,
567         address[] memory assetFrom,
568         bytes[] memory sequence,
569         uint256 deadLine
570     ) external payable judgeExpired(deadLine) returns (uint256 returnAmount) {
571         require(assetFrom.length == splitNumber.length, 'DODORouteProxy: PAIR_ASSETTO_NOT_MATCH');        
572         require(minReturnAmount > 0, "DODORouteProxy: RETURN_AMOUNT_ZERO");
573         
574         uint256 _fromTokenAmount = fromTokenAmount;
575         address fromToken = midToken[0];
576         address toToken = midToken[midToken.length - 1];
577 
578         uint256 toTokenOriginBalance = IERC20(toToken).universalBalanceOf(msg.sender);
579         _deposit(msg.sender, assetFrom[0], fromToken, _fromTokenAmount, fromToken == _ETH_ADDRESS_);
580 
581         _multiSwap(totalWeight, midToken, splitNumber, sequence, assetFrom);
582     
583         if(toToken == _ETH_ADDRESS_) {
584             returnAmount = IWETH(_WETH_).balanceOf(address(this));
585             IWETH(_WETH_).withdraw(returnAmount);
586             msg.sender.transfer(returnAmount);
587         }else {
588             returnAmount = IERC20(toToken).tokenBalanceOf(msg.sender).sub(toTokenOriginBalance);
589         }
590 
591         require(returnAmount >= minReturnAmount, "DODORouteProxy: Return amount is not enough");
592     
593         emit OrderHistory(
594             fromToken,
595             toToken,
596             msg.sender,
597             _fromTokenAmount,
598             returnAmount
599         );    
600     }
601 
602     
603     //====================== internal =======================
604 
605     function _multiSwap(
606         uint256[] memory totalWeight,
607         address[] memory midToken,
608         uint256[] memory splitNumber,
609         bytes[] memory swapSequence,
610         address[] memory assetFrom
611     ) internal { 
612         for(uint256 i = 1; i < splitNumber.length; i++) { 
613             // define midtoken address, ETH -> WETH address
614             uint256 curTotalAmount = IERC20(midToken[i]).tokenBalanceOf(assetFrom[i-1]);
615             uint256 curTotalWeight = totalWeight[i-1];
616             
617             for(uint256 j = splitNumber[i-1]; j < splitNumber[i]; j++) {
618                 PoolInfo memory curPoolInfo;
619                 {
620                     (address pool, address adapter, uint256 mixPara, bytes memory moreInfo) = abi.decode(swapSequence[j], (address, address, uint256, bytes));
621                 
622                     curPoolInfo.direction = mixPara >> 17;
623                     curPoolInfo.weight = (0xffff & mixPara) >> 9;
624                     curPoolInfo.poolEdition = (0xff & mixPara);
625                     curPoolInfo.pool = pool;
626                     curPoolInfo.adapter = adapter;
627                     curPoolInfo.moreInfo = moreInfo;
628                 }
629 
630                 if(assetFrom[i-1] == address(this)) {
631                     uint256 curAmount = curTotalAmount.div(curTotalWeight).mul(curPoolInfo.weight);
632             
633                     if(curPoolInfo.poolEdition == 1) {   
634                         //For using transferFrom pool (like dodoV1, Curve)
635                         IERC20(midToken[i]).transfer(curPoolInfo.adapter, curAmount);
636                     } else {
637                         //For using transfer pool (like dodoV2)
638                         IERC20(midToken[i]).transfer(curPoolInfo.pool, curAmount);
639                     }
640                 }
641                 
642                 if(curPoolInfo.direction == 0) {
643                     IDODOAdapter(curPoolInfo.adapter).sellBase(assetFrom[i], curPoolInfo.pool, curPoolInfo.moreInfo);
644                 } else {
645                     IDODOAdapter(curPoolInfo.adapter).sellQuote(assetFrom[i], curPoolInfo.pool, curPoolInfo.moreInfo);
646                 }
647             }
648         }
649     }
650 
651     function _deposit(
652         address from,
653         address to,
654         address token,
655         uint256 amount,
656         bool isETH
657     ) internal {
658         if (isETH) {
659             if (amount > 0) {
660                 IWETH(_WETH_).deposit{value: amount}();
661                 if (to != address(this)) SafeERC20.safeTransfer(IERC20(_WETH_), to, amount);
662             }
663         } else {
664             IDODOApproveProxy(_DODO_APPROVE_PROXY_).claimTokens(token, from, to, amount);
665         }
666     }
667 }