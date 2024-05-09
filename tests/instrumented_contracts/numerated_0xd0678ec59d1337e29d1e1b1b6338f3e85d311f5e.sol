1 // File: contracts/intf/IERC20.sol
2 
3 // This is a file copied from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
4 
5 pragma solidity 0.6.9;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     function decimals() external view returns (uint8);
17 
18     function name() external view returns (string memory);
19 
20     function symbol() external view returns (string memory);
21 
22     /**
23      * @dev Returns the amount of tokens owned by `account`.
24      */
25     function balanceOf(address account) external view returns (uint256);
26 
27     /**
28      * @dev Moves `amount` tokens from the caller's account to `recipient`.
29      *
30      * Returns a boolean value indicating whether the operation succeeded.
31      *
32      * Emits a {Transfer} event.
33      */
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     /**
37      * @dev Returns the remaining number of tokens that `spender` will be
38      * allowed to spend on behalf of `owner` through {transferFrom}. This is
39      * zero by default.
40      *
41      * This value changes when {approve} or {transferFrom} are called.
42      */
43     function allowance(address owner, address spender) external view returns (uint256);
44 
45     /**
46      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * IMPORTANT: Beware that changing an allowance with this method brings the risk
51      * that someone may use both the old and the new allowance by unfortunate
52      * transaction ordering. One possible solution to mitigate this race
53      * condition is to first reduce the spender's allowance to 0 and set the
54      * desired value afterwards:
55      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
56      *
57      * Emits an {Approval} event.
58      */
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Moves `amount` tokens from `sender` to `recipient` using the
63      * allowance mechanism. `amount` is then deducted from the caller's
64      * allowance.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transferFrom(
71         address sender,
72         address recipient,
73         uint256 amount
74     ) external returns (bool);
75 }
76 
77 // File: contracts/lib/SafeMath.sol
78 
79 /**
80  * @title SafeMath
81  * @author DODO Breeder
82  *
83  * @notice Math operations with safety checks that revert on error
84  */
85 library SafeMath {
86     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
87         if (a == 0) {
88             return 0;
89         }
90 
91         uint256 c = a * b;
92         require(c / a == b, "MUL_ERROR");
93 
94         return c;
95     }
96 
97     function div(uint256 a, uint256 b) internal pure returns (uint256) {
98         require(b > 0, "DIVIDING_ERROR");
99         return a / b;
100     }
101 
102     function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
103         uint256 quotient = div(a, b);
104         uint256 remainder = a - quotient * b;
105         if (remainder > 0) {
106             return quotient + 1;
107         } else {
108             return quotient;
109         }
110     }
111 
112     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
113         require(b <= a, "SUB_ERROR");
114         return a - b;
115     }
116 
117     function add(uint256 a, uint256 b) internal pure returns (uint256) {
118         uint256 c = a + b;
119         require(c >= a, "ADD_ERROR");
120         return c;
121     }
122 
123     function sqrt(uint256 x) internal pure returns (uint256 y) {
124         uint256 z = x / 2 + 1;
125         y = x;
126         while (z < y) {
127             y = z;
128             z = (x / z + z) / 2;
129         }
130     }
131 }
132 
133 // File: contracts/lib/SafeERC20.sol
134 
135 
136 
137 /**
138  * @title SafeERC20
139  * @dev Wrappers around ERC20 operations that throw on failure (when the token
140  * contract returns false). Tokens that return no value (and instead revert or
141  * throw on failure) are also supported, non-reverting calls are assumed to be
142  * successful.
143  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
144  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
145  */
146 library SafeERC20 {
147     using SafeMath for uint256;
148 
149     function safeTransfer(
150         IERC20 token,
151         address to,
152         uint256 value
153     ) internal {
154         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
155     }
156 
157     function safeTransferFrom(
158         IERC20 token,
159         address from,
160         address to,
161         uint256 value
162     ) internal {
163         _callOptionalReturn(
164             token,
165             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
166         );
167     }
168 
169     function safeApprove(
170         IERC20 token,
171         address spender,
172         uint256 value
173     ) internal {
174         // safeApprove should only be called when setting an initial allowance,
175         // or when resetting it to zero. To increase and decrease it, use
176         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
177         // solhint-disable-next-line max-line-length
178         require(
179             (value == 0) || (token.allowance(address(this), spender) == 0),
180             "SafeERC20: approve from non-zero to non-zero allowance"
181         );
182         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
183     }
184 
185     /**
186      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
187      * on the return value: the return value is optional (but if data is returned, it must not be false).
188      * @param token The token targeted by the call.
189      * @param data The call data (encoded using abi.encode or one of its variants).
190      */
191     function _callOptionalReturn(IERC20 token, bytes memory data) private {
192         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
193         // we're implementing it ourselves.
194 
195         // A Solidity high level call has three parts:
196         //  1. The target address is checked to verify it contains contract code
197         //  2. The call itself is made, and success asserted
198         //  3. The return value is decoded, which in turn checks the size of the returned data.
199         // solhint-disable-next-line max-line-length
200 
201         // solhint-disable-next-line avoid-low-level-calls
202         (bool success, bytes memory returndata) = address(token).call(data);
203         require(success, "SafeERC20: low-level call failed");
204 
205         if (returndata.length > 0) {
206             // Return data is optional
207             // solhint-disable-next-line max-line-length
208             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
209         }
210     }
211 }
212 
213 // File: contracts/SmartRoute/lib/UniversalERC20.sol
214 
215 
216 
217 
218 library UniversalERC20 {
219     using SafeMath for uint256;
220     using SafeERC20 for IERC20;
221 
222     IERC20 private constant ETH_ADDRESS = IERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
223 
224     function universalTransfer(
225         IERC20 token,
226         address payable to,
227         uint256 amount
228     ) internal {
229         if (amount > 0) {
230             if (isETH(token)) {
231                 to.transfer(amount);
232             } else {
233                 token.safeTransfer(to, amount);
234             }
235         }
236     }
237 
238     function universalApproveMax(
239         IERC20 token,
240         address to,
241         uint256 amount
242     ) internal {
243         uint256 allowance = token.allowance(address(this), to);
244         if (allowance < amount) {
245             if (allowance > 0) {
246                 token.safeApprove(to, 0);
247             }
248             token.safeApprove(to, uint256(-1));
249         }
250     }
251 
252     function universalBalanceOf(IERC20 token, address who) internal view returns (uint256) {
253         if (isETH(token)) {
254             return who.balance;
255         } else {
256             return token.balanceOf(who);
257         }
258     }
259 
260     function tokenBalanceOf(IERC20 token, address who) internal view returns (uint256) {
261         return token.balanceOf(who);
262     }
263 
264     function isETH(IERC20 token) internal pure returns (bool) {
265         return token == ETH_ADDRESS;
266     }
267 }
268 
269 // File: contracts/SmartRoute/intf/IDODOV1.sol
270 
271 
272 interface IDODOV1 {
273     function init(
274         address owner,
275         address supervisor,
276         address maintainer,
277         address baseToken,
278         address quoteToken,
279         address oracle,
280         uint256 lpFeeRate,
281         uint256 mtFeeRate,
282         uint256 k,
283         uint256 gasPriceLimit
284     ) external;
285 
286     function transferOwnership(address newOwner) external;
287 
288     function claimOwnership() external;
289 
290     function sellBaseToken(
291         uint256 amount,
292         uint256 minReceiveQuote,
293         bytes calldata data
294     ) external returns (uint256);
295 
296     function buyBaseToken(
297         uint256 amount,
298         uint256 maxPayQuote,
299         bytes calldata data
300     ) external returns (uint256);
301 
302     function querySellBaseToken(uint256 amount) external view returns (uint256 receiveQuote);
303 
304     function queryBuyBaseToken(uint256 amount) external view returns (uint256 payQuote);
305 
306     function depositBaseTo(address to, uint256 amount) external returns (uint256);
307 
308     function withdrawBase(uint256 amount) external returns (uint256);
309 
310     function withdrawAllBase() external returns (uint256);
311 
312     function depositQuoteTo(address to, uint256 amount) external returns (uint256);
313 
314     function withdrawQuote(uint256 amount) external returns (uint256);
315 
316     function withdrawAllQuote() external returns (uint256);
317 
318     function _BASE_CAPITAL_TOKEN_() external returns (address);
319 
320     function _QUOTE_CAPITAL_TOKEN_() external returns (address);
321 
322     function _BASE_TOKEN_() external returns (address);
323 
324     function _QUOTE_TOKEN_() external returns (address);
325 
326     function _R_STATUS_() external view returns (uint8);
327 
328     function _QUOTE_BALANCE_() external view returns (uint256);
329 
330     function _BASE_BALANCE_() external view returns (uint256);
331 
332     function _K_() external view returns (uint256);
333 
334     function _MT_FEE_RATE_() external view returns (uint256);
335 
336     function _LP_FEE_RATE_() external view returns (uint256);
337 
338     function getExpectedTarget() external view returns (uint256 baseTarget, uint256 quoteTarget);
339 
340     function getOraclePrice() external view returns (uint256);
341 
342     function getMidPrice() external view returns (uint256 midPrice); 
343 }
344 
345 // File: contracts/lib/DecimalMath.sol
346 
347 
348 /**
349  * @title DecimalMath
350  * @author DODO Breeder
351  *
352  * @notice Functions for fixed point number with 18 decimals
353  */
354 library DecimalMath {
355     using SafeMath for uint256;
356 
357     uint256 internal constant ONE = 10**18;
358     uint256 internal constant ONE2 = 10**36;
359 
360     function mulFloor(uint256 target, uint256 d) internal pure returns (uint256) {
361         return target.mul(d) / (10**18);
362     }
363 
364     function mulCeil(uint256 target, uint256 d) internal pure returns (uint256) {
365         return target.mul(d).divCeil(10**18);
366     }
367 
368     function divFloor(uint256 target, uint256 d) internal pure returns (uint256) {
369         return target.mul(10**18).div(d);
370     }
371 
372     function divCeil(uint256 target, uint256 d) internal pure returns (uint256) {
373         return target.mul(10**18).divCeil(d);
374     }
375 
376     function reciprocalFloor(uint256 target) internal pure returns (uint256) {
377         return uint256(10**36).div(target);
378     }
379 
380     function reciprocalCeil(uint256 target) internal pure returns (uint256) {
381         return uint256(10**36).divCeil(target);
382     }
383 }
384 
385 // File: contracts/SmartRoute/helper/DODOSellHelper.sol
386 
387 /**
388  *Submitted for verification at Etherscan.io on 2020-10-10
389  */
390 
391 // File: contracts/intf/IDODO.sol
392 
393 
394 
395 // import {DODOMath} from "../lib/DODOMath.sol";
396 
397 interface IDODOSellHelper {
398     function querySellQuoteToken(address dodo, uint256 amount) external view returns (uint256);
399     
400     function querySellBaseToken(address dodo, uint256 amount) external view returns (uint256);
401 }
402 
403 // File: contracts/intf/IWETH.sol
404 
405 
406 
407 interface IWETH {
408     function totalSupply() external view returns (uint256);
409 
410     function balanceOf(address account) external view returns (uint256);
411 
412     function transfer(address recipient, uint256 amount) external returns (bool);
413 
414     function allowance(address owner, address spender) external view returns (uint256);
415 
416     function approve(address spender, uint256 amount) external returns (bool);
417 
418     function transferFrom(
419         address src,
420         address dst,
421         uint256 wad
422     ) external returns (bool);
423 
424     function deposit() external payable;
425 
426     function withdraw(uint256 wad) external;
427 }
428 
429 // File: contracts/SmartRoute/intf/IChi.sol
430 
431 
432 
433 interface IChi {
434     function freeUpTo(uint256 value) external returns (uint256);
435 }
436 
437 // File: contracts/SmartRoute/intf/IUni.sol
438 
439 
440 interface IUni {
441     function swapExactTokensForTokens(
442         uint amountIn,
443         uint amountOutMin,
444         address[] calldata path,
445         address to,
446         uint deadline
447     ) external returns (uint[] memory amounts);
448 }
449 
450 // File: contracts/intf/IDODOApprove.sol
451 
452 
453 interface IDODOApprove {
454     function claimTokens(address token,address who,address dest,uint256 amount) external;
455     function getDODOProxy() external view returns (address);
456 }
457 
458 // File: contracts/SmartRoute/intf/IDODOV1Proxy01.sol
459 
460 
461 interface IDODOV1Proxy01 {
462     function dodoSwapV1(
463         address fromToken,
464         address toToken,
465         uint256 fromTokenAmount,
466         uint256 minReturnAmount,
467         address[] memory dodoPairs,
468         uint8[] memory directions,
469         uint256 deadLine
470     ) external payable returns (uint256 returnAmount);
471 
472     function externalSwap(
473         address fromToken,
474         address toToken,
475         address approveTarget,
476         address to,
477         uint256 fromTokenAmount,
478         uint256 minReturnAmount,
479         bytes memory callDataConcat,
480         uint256 deadLine
481     ) external payable returns (uint256 returnAmount);
482 
483     function mixSwapV1(
484         address fromToken,
485         address toToken,
486         uint256 fromTokenAmount,
487         uint256 minReturnAmount,
488         address[] memory mixPairs,
489         uint8[] memory directions,
490         address[] memory portionPath,
491         uint256 deadLine
492     ) external payable returns (uint256 returnAmount);
493 }
494 
495 // File: contracts/lib/InitializableOwnable.sol
496 
497 
498 /**
499  * @title Ownable
500  * @author DODO Breeder
501  *
502  * @notice Ownership related functions
503  */
504 contract InitializableOwnable {
505     address public _OWNER_;
506     address public _NEW_OWNER_;
507     bool internal _INITIALIZED_;
508 
509     // ============ Events ============
510 
511     event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);
512 
513     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
514 
515     // ============ Modifiers ============
516 
517     modifier notInitialized() {
518         require(!_INITIALIZED_, "DODO_INITIALIZED");
519         _;
520     }
521 
522     modifier onlyOwner() {
523         require(msg.sender == _OWNER_, "NOT_OWNER");
524         _;
525     }
526 
527     // ============ Functions ============
528 
529     function initOwner(address newOwner) public notInitialized {
530         _INITIALIZED_ = true;
531         _OWNER_ = newOwner;
532     }
533 
534     function transferOwnership(address newOwner) public onlyOwner {
535         emit OwnershipTransferPrepared(_OWNER_, newOwner);
536         _NEW_OWNER_ = newOwner;
537     }
538 
539     function claimOwnership() public {
540         require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");
541         emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);
542         _OWNER_ = _NEW_OWNER_;
543         _NEW_OWNER_ = address(0);
544     }
545 }
546 
547 // File: contracts/SmartRoute/DODOV1Proxy01.sol
548 
549 
550 
551 
552 
553 
554 
555 
556 
557 
558 
559 
560 
561 
562 /**
563  * @title DODOV1Proxy01
564  * @author DODO Breeder
565  *
566  * @notice Entrance of trading in DODO platform
567  */
568 contract DODOV1Proxy01 is IDODOV1Proxy01, InitializableOwnable {
569     using SafeMath for uint256;
570     using UniversalERC20 for IERC20;
571 
572     // ============ Storage ============
573 
574     address constant _ETH_ADDRESS_ = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
575     address public immutable _DODO_APPROVE_;
576     address public immutable _DODO_SELL_HELPER_;
577     address public immutable _WETH_;
578     address public immutable _CHI_TOKEN_;
579     uint8 public _GAS_DODO_MAX_RETURN_ = 0;
580     uint8 public _GAS_EXTERNAL_RETURN_ = 0;
581     mapping (address => bool) public isWhiteListed;
582 
583     // ============ Events ============
584 
585     event OrderHistory(
586         address indexed fromToken,
587         address indexed toToken,
588         address indexed sender,
589         uint256 fromAmount,
590         uint256 returnAmount
591     );
592 
593     // ============ Modifiers ============
594 
595     modifier judgeExpired(uint256 deadLine) {
596         require(deadLine >= block.timestamp, "DODOV1Proxy01: EXPIRED");
597         _;
598     }
599 
600     constructor(
601         address dodoApporve,
602         address dodoSellHelper,
603         address weth,
604         address chiToken
605     ) public {
606         _DODO_APPROVE_ = dodoApporve;
607         _DODO_SELL_HELPER_ = dodoSellHelper;
608         _WETH_ = weth;
609         _CHI_TOKEN_ = chiToken;
610     }
611 
612     fallback() external payable {}
613 
614     receive() external payable {}
615 
616     function updateGasReturn(uint8 newDodoGasReturn, uint8 newExternalGasReturn) public onlyOwner {
617         _GAS_DODO_MAX_RETURN_ = newDodoGasReturn;
618         _GAS_EXTERNAL_RETURN_ = newExternalGasReturn;
619     }
620 
621     function addWhiteList (address contractAddr) public onlyOwner {
622         isWhiteListed[contractAddr] = true;
623     }
624 
625     function removeWhiteList (address contractAddr) public onlyOwner {
626         isWhiteListed[contractAddr] = false;
627     }
628 
629     function dodoSwapV1(
630         address fromToken,
631         address toToken,
632         uint256 fromTokenAmount,
633         uint256 minReturnAmount,
634         address[] memory dodoPairs,
635         uint8[] memory directions,
636         uint256 deadLine
637     ) external override payable judgeExpired(deadLine) returns (uint256 returnAmount) {
638         require(dodoPairs.length == directions.length, "DODOV1Proxy01: PARAMS_LENGTH_NOT_MATCH");
639         uint256 originGas = gasleft();
640 
641         if (fromToken != _ETH_ADDRESS_) {
642             IDODOApprove(_DODO_APPROVE_).claimTokens(
643                 fromToken,
644                 msg.sender,
645                 address(this),
646                 fromTokenAmount
647             );
648         } else {
649             require(msg.value == fromTokenAmount, "DODOV1Proxy01: ETH_AMOUNT_NOT_MATCH");
650             IWETH(_WETH_).deposit{value: fromTokenAmount}();
651         }
652 
653         for (uint8 i = 0; i < dodoPairs.length; i++) {
654             address curDodoPair = dodoPairs[i];
655             if (directions[i] == 0) {
656                 address curDodoBase = IDODOV1(curDodoPair)._BASE_TOKEN_();
657                 uint256 curAmountIn = IERC20(curDodoBase).balanceOf(address(this));
658                 IERC20(curDodoBase).universalApproveMax(curDodoPair, curAmountIn);
659                 IDODOV1(curDodoPair).sellBaseToken(curAmountIn, 0, "");
660             } else {
661                 address curDodoQuote = IDODOV1(curDodoPair)._QUOTE_TOKEN_();
662                 uint256 curAmountIn = IERC20(curDodoQuote).balanceOf(address(this));
663                 IERC20(curDodoQuote).universalApproveMax(curDodoPair, curAmountIn);
664                 uint256 canBuyBaseAmount = IDODOSellHelper(_DODO_SELL_HELPER_).querySellQuoteToken(
665                     curDodoPair,
666                     curAmountIn
667                 );
668                 IDODOV1(curDodoPair).buyBaseToken(canBuyBaseAmount, curAmountIn, "");
669             }
670         }
671 
672         if (toToken == _ETH_ADDRESS_) {
673             returnAmount = IWETH(_WETH_).balanceOf(address(this));
674             IWETH(_WETH_).withdraw(returnAmount);
675         } else {
676             returnAmount = IERC20(toToken).tokenBalanceOf(address(this));
677         }
678         
679         require(returnAmount >= minReturnAmount, "DODOV1Proxy01: Return amount is not enough");
680         IERC20(toToken).universalTransfer(msg.sender, returnAmount);
681         
682         emit OrderHistory(fromToken, toToken, msg.sender, fromTokenAmount, returnAmount);
683 
684         uint8 _gasDodoMaxReturn = _GAS_DODO_MAX_RETURN_;
685         if(_gasDodoMaxReturn > 0) {
686             uint256 calcGasTokenBurn = originGas.sub(gasleft()) / 65000;
687             uint256 gasTokenBurn = calcGasTokenBurn > _gasDodoMaxReturn ? _gasDodoMaxReturn : calcGasTokenBurn;
688             if(gasleft() > 27710 + gasTokenBurn * 6080)
689                 IChi(_CHI_TOKEN_).freeUpTo(gasTokenBurn);
690         }
691     }
692 
693     function externalSwap(
694         address fromToken,
695         address toToken,
696         address approveTarget,
697         address swapTarget,
698         uint256 fromTokenAmount,
699         uint256 minReturnAmount,
700         bytes memory callDataConcat,
701         uint256 deadLine
702     ) external override payable judgeExpired(deadLine) returns (uint256 returnAmount) {
703         address _fromToken = fromToken;
704         address _toToken = toToken;
705         
706         uint256 toTokenOriginBalance = IERC20(_toToken).universalBalanceOf(msg.sender);
707 
708         if (_fromToken != _ETH_ADDRESS_) {
709             IDODOApprove(_DODO_APPROVE_).claimTokens(
710                 _fromToken,
711                 msg.sender,
712                 address(this),
713                 fromTokenAmount
714             );
715             IERC20(_fromToken).universalApproveMax(approveTarget, fromTokenAmount);
716         }
717 
718         require(isWhiteListed[swapTarget], "DODOV1Proxy01: Not Whitelist Contract");
719         (bool success, ) = swapTarget.call{value: _fromToken == _ETH_ADDRESS_ ? msg.value : 0}(callDataConcat);
720 
721         require(success, "DODOV1Proxy01: External Swap execution Failed");
722 
723         IERC20(_fromToken).universalTransfer(
724             msg.sender,
725             IERC20(_fromToken).universalBalanceOf(address(this))
726         );
727 
728         IERC20(_toToken).universalTransfer(
729             msg.sender,
730             IERC20(_toToken).universalBalanceOf(address(this))
731         );
732         returnAmount = IERC20(_toToken).universalBalanceOf(msg.sender).sub(toTokenOriginBalance);
733         require(returnAmount >= minReturnAmount, "DODOV1Proxy01: Return amount is not enough");
734 
735         emit OrderHistory(_fromToken, _toToken, msg.sender, fromTokenAmount, returnAmount);
736         
737         uint8 _gasExternalReturn = _GAS_EXTERNAL_RETURN_;
738         if(_gasExternalReturn > 0) {
739             if(gasleft() > 27710 + _gasExternalReturn * 6080)
740                 IChi(_CHI_TOKEN_).freeUpTo(_gasExternalReturn);
741         }
742     }
743 
744 
745     function mixSwapV1(
746         address fromToken,
747         address toToken,
748         uint256 fromTokenAmount,
749         uint256 minReturnAmount,
750         address[] memory mixPairs,
751         uint8[] memory directions,
752         address[] memory portionPath,
753         uint256 deadLine
754     ) external override payable judgeExpired(deadLine) returns (uint256 returnAmount) {
755         require(mixPairs.length == directions.length, "DODOV1Proxy01: PARAMS_LENGTH_NOT_MATCH");
756         uint256 toTokenOriginBalance = IERC20(toToken).universalBalanceOf(msg.sender);
757 
758         if (fromToken != _ETH_ADDRESS_) {
759             IDODOApprove(_DODO_APPROVE_).claimTokens(
760                 fromToken,
761                 msg.sender,
762                 address(this),
763                 fromTokenAmount
764             );
765         } else {
766             require(msg.value == fromTokenAmount, "DODOV1Proxy01: ETH_AMOUNT_NOT_MATCH");
767             IWETH(_WETH_).deposit{value: fromTokenAmount}();
768         }
769 
770         for (uint8 i = 0; i < mixPairs.length; i++) {
771             address curPair = mixPairs[i];
772             if (directions[i] == 0) {
773                 address curDodoBase = IDODOV1(curPair)._BASE_TOKEN_();
774                 uint256 curAmountIn = IERC20(curDodoBase).balanceOf(address(this));
775                 IERC20(curDodoBase).universalApproveMax(curPair, curAmountIn);
776                 IDODOV1(curPair).sellBaseToken(curAmountIn, 0, "");
777             } else if(directions[i] == 1){
778                 address curDodoQuote = IDODOV1(curPair)._QUOTE_TOKEN_();
779                 uint256 curAmountIn = IERC20(curDodoQuote).balanceOf(address(this));
780                 IERC20(curDodoQuote).universalApproveMax(curPair, curAmountIn);
781                 uint256 canBuyBaseAmount = IDODOSellHelper(_DODO_SELL_HELPER_).querySellQuoteToken(
782                     curPair,
783                     curAmountIn
784                 );
785                 IDODOV1(curPair).buyBaseToken(canBuyBaseAmount, curAmountIn, "");
786             } else {
787                 uint256 curAmountIn = IERC20(portionPath[0]).balanceOf(address(this));
788                 IERC20(portionPath[0]).universalApproveMax(curPair, curAmountIn);
789                 IUni(curPair).swapExactTokensForTokens(curAmountIn,0,portionPath,address(this),deadLine);
790             }
791         }
792 
793         IERC20(fromToken).universalTransfer(
794             msg.sender,
795             IERC20(fromToken).universalBalanceOf(address(this))
796         );
797 
798         IERC20(toToken).universalTransfer(
799             msg.sender,
800             IERC20(toToken).universalBalanceOf(address(this))
801         );
802 
803         returnAmount = IERC20(toToken).universalBalanceOf(msg.sender).sub(toTokenOriginBalance);
804         require(returnAmount >= minReturnAmount, "DODOV1Proxy01: Return amount is not enough");
805 
806         emit OrderHistory(fromToken, toToken, msg.sender, fromTokenAmount, returnAmount);
807         
808         uint8 _gasExternalReturn = _GAS_EXTERNAL_RETURN_;
809         if(_gasExternalReturn > 0) {
810             if(gasleft() > 27710 + _gasExternalReturn * 6080)
811                 IChi(_CHI_TOKEN_).freeUpTo(_gasExternalReturn);
812         }
813     }
814 }