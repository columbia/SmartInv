1 // File: @openzeppelin/upgrades/contracts/Initializable.sol
2 
3 pragma solidity >=0.4.24 <0.6.0;
4 
5 
6 /**
7  * @title Initializable
8  *
9  * @dev Helper contract to support initializer functions. To use it, replace
10  * the constructor with a function that has the `initializer` modifier.
11  * WARNING: Unlike constructors, initializer functions must be manually
12  * invoked. This applies both to deploying an Initializable contract, as well
13  * as extending an Initializable contract via inheritance.
14  * WARNING: When used with inheritance, manual care must be taken to not invoke
15  * a parent initializer twice, or ensure that all initializers are idempotent,
16  * because this is not dealt with automatically as with constructors.
17  */
18 contract Initializable {
19 
20   /**
21    * @dev Indicates that the contract has been initialized.
22    */
23   bool private initialized;
24 
25   /**
26    * @dev Indicates that the contract is in the process of being initialized.
27    */
28   bool private initializing;
29 
30   /**
31    * @dev Modifier to use in the initializer function of a contract.
32    */
33   modifier initializer() {
34     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
35 
36     bool isTopLevelCall = !initializing;
37     if (isTopLevelCall) {
38       initializing = true;
39       initialized = true;
40     }
41 
42     _;
43 
44     if (isTopLevelCall) {
45       initializing = false;
46     }
47   }
48 
49   /// @dev Returns true if and only if the function is running in the constructor
50   function isConstructor() private view returns (bool) {
51     // extcodesize checks the size of the code stored in an address, and
52     // address returns the current address. Since the code is still not
53     // deployed when running a constructor, any checks on its code size will
54     // yield zero, making it an effective way to detect if a contract is
55     // under construction or not.
56     uint256 cs;
57     assembly { cs := extcodesize(address) }
58     return cs == 0;
59   }
60 
61   // Reserved storage space to allow for layout changes in the future.
62   uint256[50] private ______gap;
63 }
64 
65 // File: @openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol
66 
67 pragma solidity ^0.5.0;
68 
69 /**
70  * @dev Wrappers over Solidity's arithmetic operations with added overflow
71  * checks.
72  *
73  * Arithmetic operations in Solidity wrap on overflow. This can easily result
74  * in bugs, because programmers usually assume that an overflow raises an
75  * error, which is the standard behavior in high level programming languages.
76  * `SafeMath` restores this intuition by reverting the transaction when an
77  * operation overflows.
78  *
79  * Using this library instead of the unchecked operations eliminates an entire
80  * class of bugs, so it's recommended to use it always.
81  */
82 library SafeMath {
83     /**
84      * @dev Returns the addition of two unsigned integers, reverting on
85      * overflow.
86      *
87      * Counterpart to Solidity's `+` operator.
88      *
89      * Requirements:
90      * - Addition cannot overflow.
91      */
92     function add(uint256 a, uint256 b) internal pure returns (uint256) {
93         uint256 c = a + b;
94         require(c >= a, "SafeMath: addition overflow");
95 
96         return c;
97     }
98 
99     /**
100      * @dev Returns the subtraction of two unsigned integers, reverting on
101      * overflow (when the result is negative).
102      *
103      * Counterpart to Solidity's `-` operator.
104      *
105      * Requirements:
106      * - Subtraction cannot overflow.
107      */
108     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109         return sub(a, b, "SafeMath: subtraction overflow");
110     }
111 
112     /**
113      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
114      * overflow (when the result is negative).
115      *
116      * Counterpart to Solidity's `-` operator.
117      *
118      * Requirements:
119      * - Subtraction cannot overflow.
120      *
121      * _Available since v2.4.0._
122      */
123     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
124         require(b <= a, errorMessage);
125         uint256 c = a - b;
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the multiplication of two unsigned integers, reverting on
132      * overflow.
133      *
134      * Counterpart to Solidity's `*` operator.
135      *
136      * Requirements:
137      * - Multiplication cannot overflow.
138      */
139     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
140         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
141         // benefit is lost if 'b' is also tested.
142         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
143         if (a == 0) {
144             return 0;
145         }
146 
147         uint256 c = a * b;
148         require(c / a == b, "SafeMath: multiplication overflow");
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the integer division of two unsigned integers. Reverts on
155      * division by zero. The result is rounded towards zero.
156      *
157      * Counterpart to Solidity's `/` operator. Note: this function uses a
158      * `revert` opcode (which leaves remaining gas untouched) while Solidity
159      * uses an invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      * - The divisor cannot be zero.
163      */
164     function div(uint256 a, uint256 b) internal pure returns (uint256) {
165         return div(a, b, "SafeMath: division by zero");
166     }
167 
168     /**
169      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
170      * division by zero. The result is rounded towards zero.
171      *
172      * Counterpart to Solidity's `/` operator. Note: this function uses a
173      * `revert` opcode (which leaves remaining gas untouched) while Solidity
174      * uses an invalid opcode to revert (consuming all remaining gas).
175      *
176      * Requirements:
177      * - The divisor cannot be zero.
178      *
179      * _Available since v2.4.0._
180      */
181     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
182         // Solidity only automatically asserts when dividing by 0
183         require(b > 0, errorMessage);
184         uint256 c = a / b;
185         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
186 
187         return c;
188     }
189 
190     /**
191      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
192      * Reverts when dividing by zero.
193      *
194      * Counterpart to Solidity's `%` operator. This function uses a `revert`
195      * opcode (which leaves remaining gas untouched) while Solidity uses an
196      * invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      * - The divisor cannot be zero.
200      */
201     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
202         return mod(a, b, "SafeMath: modulo by zero");
203     }
204 
205     /**
206      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207      * Reverts with custom message when dividing by zero.
208      *
209      * Counterpart to Solidity's `%` operator. This function uses a `revert`
210      * opcode (which leaves remaining gas untouched) while Solidity uses an
211      * invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      * - The divisor cannot be zero.
215      *
216      * _Available since v2.4.0._
217      */
218     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
219         require(b != 0, errorMessage);
220         return a % b;
221     }
222 }
223 
224 // File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/IERC20.sol
225 
226 pragma solidity ^0.5.0;
227 
228 /**
229  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
230  * the optional functions; to access them see {ERC20Detailed}.
231  */
232 interface IERC20 {
233     /**
234      * @dev Returns the amount of tokens in existence.
235      */
236     function totalSupply() external view returns (uint256);
237 
238     /**
239      * @dev Returns the amount of tokens owned by `account`.
240      */
241     function balanceOf(address account) external view returns (uint256);
242 
243     /**
244      * @dev Moves `amount` tokens from the caller's account to `recipient`.
245      *
246      * Returns a boolean value indicating whether the operation succeeded.
247      *
248      * Emits a {Transfer} event.
249      */
250     function transfer(address recipient, uint256 amount) external returns (bool);
251 
252     /**
253      * @dev Returns the remaining number of tokens that `spender` will be
254      * allowed to spend on behalf of `owner` through {transferFrom}. This is
255      * zero by default.
256      *
257      * This value changes when {approve} or {transferFrom} are called.
258      */
259     function allowance(address owner, address spender) external view returns (uint256);
260 
261     /**
262      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
263      *
264      * Returns a boolean value indicating whether the operation succeeded.
265      *
266      * IMPORTANT: Beware that changing an allowance with this method brings the risk
267      * that someone may use both the old and the new allowance by unfortunate
268      * transaction ordering. One possible solution to mitigate this race
269      * condition is to first reduce the spender's allowance to 0 and set the
270      * desired value afterwards:
271      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
272      *
273      * Emits an {Approval} event.
274      */
275     function approve(address spender, uint256 amount) external returns (bool);
276 
277     /**
278      * @dev Moves `amount` tokens from `sender` to `recipient` using the
279      * allowance mechanism. `amount` is then deducted from the caller's
280      * allowance.
281      *
282      * Returns a boolean value indicating whether the operation succeeded.
283      *
284      * Emits a {Transfer} event.
285      */
286     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
287 
288     /**
289      * @dev Emitted when `value` tokens are moved from one account (`from`) to
290      * another (`to`).
291      *
292      * Note that `value` may be zero.
293      */
294     event Transfer(address indexed from, address indexed to, uint256 value);
295 
296     /**
297      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
298      * a call to {approve}. `value` is the new allowance.
299      */
300     event Approval(address indexed owner, address indexed spender, uint256 value);
301 }
302 
303 // File: @openzeppelin/contracts-ethereum-package/contracts/utils/ReentrancyGuard.sol
304 
305 pragma solidity ^0.5.0;
306 
307 
308 /**
309  * @dev Contract module that helps prevent reentrant calls to a function.
310  *
311  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
312  * available, which can be applied to functions to make sure there are no nested
313  * (reentrant) calls to them.
314  *
315  * Note that because there is a single `nonReentrant` guard, functions marked as
316  * `nonReentrant` may not call one another. This can be worked around by making
317  * those functions `private`, and then adding `external` `nonReentrant` entry
318  * points to them.
319  */
320 contract ReentrancyGuard is Initializable {
321     // counter to allow mutex lock with only one SSTORE operation
322     uint256 private _guardCounter;
323 
324     function initialize() public initializer {
325         // The counter starts at one to prevent changing it from zero to a non-zero
326         // value, which is a more expensive operation.
327         _guardCounter = 1;
328     }
329 
330     /**
331      * @dev Prevents a contract from calling itself, directly or indirectly.
332      * Calling a `nonReentrant` function from another `nonReentrant`
333      * function is not supported. It is possible to prevent this from happening
334      * by making the `nonReentrant` function external, and make it call a
335      * `private` function that does the actual work.
336      */
337     modifier nonReentrant() {
338         _guardCounter += 1;
339         uint256 localCounter = _guardCounter;
340         _;
341         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
342     }
343 
344     uint256[50] private ______gap;
345 }
346 
347 // File: contracts/UpdatedZaps/WIP/UniSwapRemoveLiquidityGeneral_v1.sol
348 
349 // Copyright (C) 2019, 2020 dipeshsukhani, nodarjonashi, toshsharma, suhailg
350 
351 // This program is free software: you can redistribute it and/or modify
352 // it under the terms of the GNU Affero General Public License as published by
353 // the Free Software Foundation, either version 2 of the License, or
354 // (at your option) any later version.
355 //
356 // This program is distributed in the hope that it will be useful,
357 // but WITHOUT ANY WARRANTY; without even the implied warranty of
358 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
359 // GNU Affero General Public License for more details.
360 //
361 // Visit <https://www.gnu.org/licenses/>for a copy of the GNU Affero General Public License
362 
363 /**
364  * WARNING: This is an upgradable contract. Be careful not to disrupt
365  * the existing storage layout when making upgrades to the contract. In particular,
366  * existing fields should not be removed and should not have their types changed.
367  * The order of field declarations must not be changed, and new fields must be added
368  * below all existing declarations.
369  *
370  * The base contracts and the order in which they are declared must not be changed.
371  * New fields must not be added to base contracts (unless the base contract has
372  * reserved placeholder fields for this purpose).
373  *
374  * See https://docs.zeppelinos.org/docs/writing_contracts.html for more info.
375 */
376 
377 pragma solidity ^0.5.0;
378 
379 
380 
381 
382 
383 ///@author DeFiZap
384 ///@notice this contract implements one click conversion from Unipool liquidity tokens to ETH
385 
386 interface IuniswapFactory_UniSwapRemoveLiquityGeneral_v1 {
387     function getExchange(address token)
388         external
389         view
390         returns (address exchange);
391 }
392 
393 interface IuniswapExchange_UniSwapRemoveLiquityGeneral_v1 {
394     // for removing liquidity (returns ETH removed, ERC20 Removed)
395     function removeLiquidity(
396         uint256 amount,
397         uint256 min_eth,
398         uint256 min_tokens,
399         uint256 deadline
400     ) external returns (uint256, uint256);
401 
402     // to convert ERC20 to ETH and transfer
403     function getTokenToEthInputPrice(uint256 tokens_sold)
404         external
405         view
406         returns (uint256 eth_bought);
407     function tokenToEthTransferInput(
408         uint256 tokens_sold,
409         uint256 min_eth,
410         uint256 deadline,
411         address recipient
412     ) external returns (uint256 eth_bought);
413     /// -- optional
414     function tokenToEthSwapInput(
415         uint256 tokens_sold,
416         uint256 min_eth,
417         uint256 deadline
418     ) external returns (uint256 eth_bought);
419 
420     // to convert ETH to ERC20 and transfer
421     function getEthToTokenInputPrice(uint256 eth_sold)
422         external
423         view
424         returns (uint256 tokens_bought);
425     function ethToTokenTransferInput(
426         uint256 min_tokens,
427         uint256 deadline,
428         address recipient
429     ) external payable returns (uint256 tokens_bought);
430     /// -- optional
431     function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline)
432         external
433         payable
434         returns (uint256 tokens_bought);
435 
436     // converting ERC20 to ERC20 and transfer
437     function tokenToTokenTransferInput(
438         uint256 tokens_sold,
439         uint256 min_tokens_bought,
440         uint256 min_eth_bought,
441         uint256 deadline,
442         address recipient,
443         address token_addr
444     ) external returns (uint256 tokens_bought);
445 
446     // misc
447     function allowance(address _owner, address _spender)
448         external
449         view
450         returns (uint256);
451     function balanceOf(address _owner) external view returns (uint256);
452     function transfer(address _to, uint256 _value) external returns (bool);
453     function transferFrom(address from, address to, uint256 tokens)
454         external
455         returns (bool success);
456 
457 }
458 
459 contract UniSwapRemoveLiquityGeneral_v1 is Initializable, ReentrancyGuard {
460     using SafeMath for uint256;
461 
462     // state variables
463 
464     // - THESE MUST ALWAYS STAY IN THE SAME LAYOUT
465     bool private stopped;
466     address payable public owner;
467     IuniswapFactory_UniSwapRemoveLiquityGeneral_v1 public UniSwapFactoryAddress;
468     uint16 public goodwill;
469     address public dzgoodwillAddress;
470     mapping(address => uint256) private userBalance;
471     IERC20 public DaiTokenAddress;
472 
473     // events
474     event details(
475         IuniswapExchange_UniSwapRemoveLiquityGeneral_v1 indexed ExchangeAddress,
476         IERC20 TokenAdddress,
477         address _user,
478         uint256 LiqRed,
479         uint256 ethRec,
480         uint256 tokenRec,
481         string indexed func
482     );
483 
484     // circuit breaker modifiers
485     modifier stopInEmergency {
486         if (stopped) {
487             revert("Temporarily Paused");
488         } else {
489             _;
490         }
491     }
492     modifier onlyOwner() {
493         require(isOwner(), "you are not authorised to call this function");
494         _;
495     }
496 
497     function initialize(
498         address _UniSwapFactoryAddress,
499         uint16 _goodwill,
500         address _dzgoodwillAddress,
501         address _DaiTokenAddress
502     ) public initializer {
503         ReentrancyGuard.initialize();
504         stopped = false;
505         owner = msg.sender;
506         UniSwapFactoryAddress = IuniswapFactory_UniSwapRemoveLiquityGeneral_v1(
507             _UniSwapFactoryAddress
508         );
509         goodwill = _goodwill;
510         dzgoodwillAddress = _dzgoodwillAddress;
511         DaiTokenAddress = IERC20(_DaiTokenAddress);
512     }
513 
514     function set_new_UniSwapFactoryAddress(address _new_UniSwapFactoryAddress)
515         public
516         onlyOwner
517     {
518         UniSwapFactoryAddress = IuniswapFactory_UniSwapRemoveLiquityGeneral_v1(
519             _new_UniSwapFactoryAddress
520         );
521 
522     }
523 
524     function set_new_goodwill(uint16 _new_goodwill) public onlyOwner {
525         require(
526             _new_goodwill >= 0 && _new_goodwill <= 10000,
527             "GoodWill Value not allowed"
528         );
529         goodwill = _new_goodwill;
530 
531     }
532 
533     function set_new_dzgoodwillAddress(address _new_dzgoodwillAddress)
534         public
535         onlyOwner
536     {
537         dzgoodwillAddress = _new_dzgoodwillAddress;
538     }
539 
540     function LetsWithdraw_onlyETH(
541         address _TokenContractAddress,
542         uint256 LiquidityTokenSold
543     ) public payable stopInEmergency nonReentrant returns (bool) {
544         IuniswapExchange_UniSwapRemoveLiquityGeneral_v1 UniSwapExchangeContractAddress = IuniswapExchange_UniSwapRemoveLiquityGeneral_v1(
545             UniSwapFactoryAddress.getExchange(_TokenContractAddress)
546         );
547         uint256 maxtokensPermitted = UniSwapExchangeContractAddress.allowance(
548             msg.sender,
549             address(this)
550         );
551         require(
552             LiquidityTokenSold <= maxtokensPermitted,
553             "Permission to DeFiZap is less than requested"
554         );
555         uint256 goodwillPortion = SafeMath.div(
556             SafeMath.mul(LiquidityTokenSold, goodwill),
557             10000
558         );
559         require(
560             UniSwapExchangeContractAddress.transferFrom(
561                 msg.sender,
562                 address(this),
563                 SafeMath.sub(LiquidityTokenSold, goodwillPortion)
564             ),
565             "error2:defizap"
566         );
567         require(
568             UniSwapExchangeContractAddress.transferFrom(
569                 msg.sender,
570                 dzgoodwillAddress,
571                 goodwillPortion
572             ),
573             "error3:defizap"
574         );
575 
576         (uint256 ethReceived, uint256 erc20received) = UniSwapExchangeContractAddress
577             .removeLiquidity(
578             SafeMath.sub(LiquidityTokenSold, goodwillPortion),
579             1,
580             1,
581             SafeMath.add(now, 1800)
582         );
583 
584         uint256 eth_againstERC20 = UniSwapExchangeContractAddress
585             .getTokenToEthInputPrice(erc20received);
586         IERC20(_TokenContractAddress).approve(
587             address(UniSwapExchangeContractAddress),
588             erc20received
589         );
590         UniSwapExchangeContractAddress.tokenToEthTransferInput(
591             erc20received,
592             SafeMath.div(SafeMath.mul(eth_againstERC20, 98), 100),
593             SafeMath.add(now, 1800),
594             msg.sender
595         );
596         userBalance[msg.sender] = ethReceived;
597         require(send_out_eth(msg.sender), "issue in transfer ETH");
598         emit details(
599             UniSwapExchangeContractAddress,
600             IERC20(_TokenContractAddress),
601             msg.sender,
602             SafeMath.sub(LiquidityTokenSold, goodwillPortion),
603             ethReceived,
604             erc20received,
605             "onlyETH"
606         );
607         return true;
608     }
609 
610     function LetsWithdraw_onlyERC(
611         address _TokenContractAddress,
612         uint256 LiquidityTokenSold,
613         bool _returnInDai
614     ) public payable stopInEmergency nonReentrant returns (bool) {
615         IuniswapExchange_UniSwapRemoveLiquityGeneral_v1 UniSwapExchangeContractAddress = IuniswapExchange_UniSwapRemoveLiquityGeneral_v1(
616             UniSwapFactoryAddress.getExchange(_TokenContractAddress)
617         );
618         IuniswapExchange_UniSwapRemoveLiquityGeneral_v1 DAIUniSwapExchangeContractAddress = IuniswapExchange_UniSwapRemoveLiquityGeneral_v1(
619             UniSwapFactoryAddress.getExchange(address(DaiTokenAddress))
620         );
621         uint256 maxtokensPermitted = UniSwapExchangeContractAddress.allowance(
622             msg.sender,
623             address(this)
624         );
625         require(
626             LiquidityTokenSold <= maxtokensPermitted,
627             "Permission to DeFiZap is less than requested"
628         );
629         uint256 goodwillPortion = SafeMath.div(
630             SafeMath.mul(LiquidityTokenSold, goodwill),
631             10000
632         );
633         require(
634             UniSwapExchangeContractAddress.transferFrom(
635                 msg.sender,
636                 address(this),
637                 SafeMath.sub(LiquidityTokenSold, goodwillPortion)
638             ),
639             "error2:defizap"
640         );
641         require(
642             UniSwapExchangeContractAddress.transferFrom(
643                 msg.sender,
644                 dzgoodwillAddress,
645                 goodwillPortion
646             ),
647             "error3:defizap"
648         );
649         (uint256 ethReceived, uint256 erc20received) = UniSwapExchangeContractAddress
650             .removeLiquidity(
651             SafeMath.sub(LiquidityTokenSold, goodwillPortion),
652             1,
653             1,
654             SafeMath.add(now, 1800)
655         );
656         if (_returnInDai) {
657             require(
658                 _TokenContractAddress != address(DaiTokenAddress),
659                 "error5:defizap"
660             );
661             DAIUniSwapExchangeContractAddress.ethToTokenTransferInput.value(
662                 ethReceived
663             )(1, SafeMath.add(now, 1800), msg.sender);
664             IERC20(_TokenContractAddress).approve(
665                 address(UniSwapExchangeContractAddress),
666                 erc20received
667             );
668             UniSwapExchangeContractAddress.tokenToTokenTransferInput(
669                 erc20received,
670                 1,
671                 1,
672                 SafeMath.add(now, 1800),
673                 msg.sender,
674                 address(DaiTokenAddress)
675             );
676             emit details(
677                 UniSwapExchangeContractAddress,
678                 IERC20(_TokenContractAddress),
679                 msg.sender,
680                 SafeMath.sub(LiquidityTokenSold, goodwillPortion),
681                 ethReceived,
682                 erc20received,
683                 "onlyDAI"
684             );
685         } else {
686             UniSwapExchangeContractAddress.ethToTokenTransferInput.value(
687                 ethReceived
688             )(1, SafeMath.add(now, 1800), msg.sender);
689             IERC20(_TokenContractAddress).transfer(msg.sender, erc20received);
690             emit details(
691                 UniSwapExchangeContractAddress,
692                 IERC20(_TokenContractAddress),
693                 msg.sender,
694                 SafeMath.sub(LiquidityTokenSold, goodwillPortion),
695                 ethReceived,
696                 erc20received,
697                 "onlyERC"
698             );
699         }
700 
701         return true;
702     }
703 
704     function send_out_eth(address _towhomtosendtheETH) internal returns (bool) {
705         require(userBalance[_towhomtosendtheETH] > 0, "error4:DefiZap");
706         uint256 amount = userBalance[_towhomtosendtheETH];
707         userBalance[_towhomtosendtheETH] = 0;
708         (bool success, ) = _towhomtosendtheETH.call.value(amount)("");
709         require(success, "error5:DefiZap");
710         return true;
711     }
712 
713     // - fallback function let you / anyone send ETH to this wallet without the need to call any function
714     function() external payable {}
715 
716     // Should there be a need to withdraw any other ERC20 token
717     function withdrawERC20Token(IERC20 _targetContractAddress)
718         public
719         onlyOwner
720     {
721         uint256 OtherTokenBalance = _targetContractAddress.balanceOf(
722             address(this)
723         );
724         _targetContractAddress.transfer(owner, OtherTokenBalance);
725     }
726 
727     // - to Pause the contract
728     function toggleContractActive() public onlyOwner {
729         stopped = !stopped;
730     }
731 
732     // - to withdraw any ETH balance sitting in the contract
733     function withdraw() public onlyOwner {
734         owner.transfer(address(this).balance);
735     }
736 
737     // - to kill the contract
738     function destruct() public onlyOwner {
739         selfdestruct(owner);
740     }
741 
742     /**
743      * @return true if `msg.sender` is the owner of the contract.
744      */
745     function isOwner() public view returns (bool) {
746         return msg.sender == owner;
747     }
748 
749     /**
750      * @dev Transfers ownership of the contract to a new account (`newOwner`).
751      * Can only be called by the current owner.
752      */
753     function transferOwnership(address payable newOwner) public onlyOwner {
754         _transferOwnership(newOwner);
755     }
756 
757     /**
758      * @dev Transfers ownership of the contract to a new account (`newOwner`).
759      */
760     function _transferOwnership(address payable newOwner) internal {
761         require(
762             newOwner != address(0),
763             "Ownable: new owner is the zero address"
764         );
765         owner = newOwner;
766     }
767 
768 }