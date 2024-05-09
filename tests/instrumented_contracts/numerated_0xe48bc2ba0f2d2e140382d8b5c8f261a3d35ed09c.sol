1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-01
3 */
4 
5 /*
6  * Copyright (c) The Force Protocol Development Team
7  * Submitted for verification at Etherscan.io on 2019-09-17
8  */
9 
10 pragma solidity 0.5.13;
11 // pragma experimental ABIEncoderV2;
12 
13 contract ReentrancyGuard {
14     bool private _notEntered;
15 
16     constructor() internal {
17         // Storing an initial non-zero value makes deployment a bit more
18         // expensive, but in exchange the refund on every call to nonReentrant
19         // will be lower in amount. Since refunds are capped to a percetange of
20         // the total transaction's gas, it is best to keep them low in cases
21         // like this one, to increase the likelihood of the full refund coming
22         // into effect.
23         _notEntered = true;
24     }
25 
26     /**
27      * @dev Prevents a contract from calling itself, directly or indirectly.
28      * Calling a `nonReentrant` function from another `nonReentrant`
29      * function is not supported. It is possible to prevent this from happening
30      * by making the `nonReentrant` function external, and make it call a
31      * `private` function that does the actual work.
32      */
33     modifier nonReentrant() {
34         // On the first call to nonReentrant, _notEntered will be true
35         require(_notEntered, "ReentrancyGuard: reentrant call");
36 
37         // Any calls to nonReentrant after this point will fail
38         _notEntered = false;
39 
40         _;
41 
42         // By storing the original value once again, a refund is triggered (see
43         // https://eips.ethereum.org/EIPS/eip-2200)
44         _notEntered = true;
45     }
46 }
47 
48 /**
49  * Utility library of inline functions on addresses
50  */
51 library Address {
52     /**
53      * Returns whether the target address is a contract
54      * @dev This function will return false if invoked during the constructor of a contract,
55      * as the code is not actually created until after the constructor finishes.
56      * @param account address of the account to check
57      * @return whether the target address is a contract
58      */
59     function isContract(address account) internal view returns (bool) {
60         uint256 size;
61         // XXX Currently there is no better way to check if there is a contract in an address
62         // than to check the size of the code at that address.
63         // See https://ethereum.stackexchange.com/a/14016/36603
64         // for more details about how this works.
65         // TODO Check this again before the Serenity release, because all addresses will be
66         // contracts then.
67         // solhint-disable-next-line no-inline-assembly
68         assembly {
69             size := extcodesize(account)
70         }
71         return size != 0;
72     }
73 }
74 
75 /**
76  * @title SafeMath
77  * @dev Unsigned math operations with safety checks that revert on error.
78  */
79 library SafeMath {
80     /**
81      * @dev Multiplies two unsigned integers, reverts on overflow.
82      */
83     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
84         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
85         // benefit is lost if 'b' is also tested.
86         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
87         if (a == 0) {
88             return 0;
89         }
90 
91         uint256 c = a * b;
92         require(c / a == b, "uint mul overflow");
93 
94         return c;
95     }
96 
97     /**
98      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
99      */
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         // Solidity only automatically asserts when dividing by 0
102         require(b != 0, "uint div by zero");
103         uint256 c = a / b;
104         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
105 
106         return c;
107     }
108 
109     /**
110      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
111      */
112     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
113         require(b <= a, "uint sub overflow");
114         uint256 c = a - b;
115 
116         return c;
117     }
118 
119     /**
120      * @dev Adds two unsigned integers, reverts on overflow.
121      */
122     function add(uint256 a, uint256 b) internal pure returns (uint256) {
123         uint256 c = a + b;
124         require(c >= a, "uint add overflow");
125 
126         return c;
127     }
128 
129     /**
130      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
131      * reverts when dividing by zero.
132      */
133     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
134         require(b != 0, "uint mod by zero");
135         return a % b;
136     }
137 }
138 
139 /**
140  * @title ERC20 interface
141  * @dev see https://eips.ethereum.org/EIPS/eip-20
142  */
143 interface IERC20 {
144     function transfer(address to, uint256 value) external returns (bool);
145 
146     function approve(address spender, uint256 value) external returns (bool);
147 
148     function transferFrom(
149         address from,
150         address to,
151         uint256 value
152     ) external returns (bool);
153 
154     function totalSupply() external view returns (uint256);
155 
156     function balanceOf(address who) external view returns (uint256);
157 
158     function allowance(address owner, address spender)
159     external
160     view
161     returns (uint256);
162 
163     event Transfer(address indexed from, address indexed to, uint256 value);
164 
165     event Approval(
166         address indexed owner,
167         address indexed spender,
168         uint256 value
169     );
170 }
171 
172 /**
173  * @title SafeERC20
174  * @dev Wrappers around ERC20 operations that throw on failure (when the token
175  * contract returns false). Tokens that return no value (and instead revert or
176  * throw on failure) are also supported, non-reverting calls are assumed to be
177  * successful.
178  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
179  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
180  */
181 library SafeERC20 {
182     using SafeMath for uint256;
183     using Address for address;
184 
185     function safeTransfer(
186         IERC20 token,
187         address to,
188         uint256 value
189     ) internal {
190         callOptionalReturn(
191             token,
192             abi.encodeWithSelector(token.transfer.selector, to, value)
193         );
194     }
195 
196     function safeTransferFrom(
197         IERC20 token,
198         address from,
199         address to,
200         uint256 value
201     ) internal {
202         callOptionalReturn(
203             token,
204             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
205         );
206     }
207 
208     function safeApprove(
209         IERC20 token,
210         address spender,
211         uint256 value
212     ) internal {
213         // safeApprove should only be called when setting an initial allowance,
214         // or when resetting it to zero. To increase and decrease it, use
215         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
216         require((value == 0) || (token.allowance(address(this), spender) == 0));
217         callOptionalReturn(
218             token,
219             abi.encodeWithSelector(token.approve.selector, spender, value)
220         );
221     }
222 
223     function safeIncreaseAllowance(
224         IERC20 token,
225         address spender,
226         uint256 value
227     ) internal {
228         uint256 newAllowance = token.allowance(address(this), spender).add(
229             value
230         );
231         callOptionalReturn(
232             token,
233             abi.encodeWithSelector(
234                 token.approve.selector,
235                 spender,
236                 newAllowance
237             )
238         );
239     }
240 
241     function safeDecreaseAllowance(
242         IERC20 token,
243         address spender,
244         uint256 value
245     ) internal {
246         uint256 newAllowance = token.allowance(address(this), spender).sub(
247             value
248         );
249         callOptionalReturn(
250             token,
251             abi.encodeWithSelector(
252                 token.approve.selector,
253                 spender,
254                 newAllowance
255             )
256         );
257     }
258 
259     /**
260      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
261      * on the return value: the return value is optional (but if data is returned, it must not be false).
262      * @param token The token targeted by the call.
263      * @param data The call data (encoded using abi.encode or one of its variants).
264      */
265     function callOptionalReturn(IERC20 token, bytes memory data) private {
266         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
267         // we're implementing it ourselves.
268 
269         // A Solidity high level call has three parts:
270         //  1. The target address is checked to verify it contains contract code
271         //  2. The call itself is made, and success asserted
272         //  3. The return value is decoded, which in turn checks the size of the returned data.
273 
274         require(address(token).isContract());
275 
276         // solhint-disable-next-line avoid-low-level-calls
277         (bool success, bytes memory returndata) = address(token).call(data);
278         require(success);
279 
280         if (returndata.length > 0) {
281             // Return data is optional
282             require(abi.decode(returndata, (bool)));
283         }
284     }
285 }
286 
287 library addressMakePayable {
288     function makePayable(address x) internal pure returns (address payable) {
289         return address(uint160(x));
290     }
291 }
292 
293 contract IOracle {
294     function get(address token) external view returns (uint256, bool);
295 }
296 
297 contract IInterestRateModel {
298     function getLoanRate(int256 cash, int256 borrow)
299     external
300     view
301     returns (int256 y);
302 
303     function getDepositRate(int256 cash, int256 borrow)
304     external
305     view
306     returns (int256 y);
307 
308     function calculateBalance(
309         int256 principal,
310         int256 lastIndex,
311         int256 newIndex
312     ) external view returns (int256 y);
313 
314     function calculateInterestIndex(
315         int256 Index,
316         int256 r,
317         int256 t
318     ) external view returns (int256 y);
319 
320     function pert(
321         int256 principal,
322         int256 r,
323         int256 t
324     ) external view returns (int256 y);
325 
326     function getNewReserve(
327         int256 oldReserve,
328         int256 cash,
329         int256 borrow,
330         int256 blockDelta
331     ) external view returns (int256 y);
332 }
333 
334 contract PoolPawn is ReentrancyGuard {
335     using SafeERC20 for IERC20;
336     using SafeMath for uint256;
337     using addressMakePayable for address;
338 
339     uint public constant int_max = 57896044618658097711785492504343953926634992332820282019728792003956564819967;
340 
341     address public admin; //the admin address
342     address public proposedAdmin; //use pull over push pattern for admin
343 
344     // uint256 public constant interestRateDenomitor = 1e18;
345 
346     /**
347      * @notice Container for borrow balance information
348      * @member principal Total balance (with accrued interest), after applying the most recent balance-changing action
349      * @member interestIndex Global borrowIndex as of the most recent balance-changing action
350      */
351     // Balance struct
352     struct Balance {
353         uint256 principal;
354         uint256 interestIndex;
355         uint256 totalPnl; //total profit and loss
356     }
357 
358     struct Market {
359         uint256 accrualBlockNumber;
360         int256 supplyRate; //存款利率
361         int256 demondRate; //借款利率
362         IInterestRateModel irm;
363         uint256 totalSupply;
364         uint256 supplyIndex;
365         uint256 totalBorrows;
366         uint256 borrowIndex;
367         uint256 totalReserves; //系统盈利
368         uint256 minPledgeRate; //最小质押率
369         uint256 liquidationDiscount; //清算折扣
370         uint256 decimals; //币种的最小精度
371     }
372 
373     // Mappings of users' balance of each token
374     mapping(address => mapping(address => Balance))
375     public accountSupplySnapshot; //tokenContract->address(usr)->SupplySnapshot
376     mapping(address => mapping(address => Balance))
377     public accountBorrowSnapshot; //tokenContract->address(usr)->BorrowSnapshot
378 
379     struct LiquidateInfo {
380         address targetAccount; //被清算账户
381         address liquidator; //清算人
382         address assetCollatera; //抵押物token地址
383         address assetBorrow; //债务token地址
384         uint256 liquidateAmount; //清算额度，抵押物
385         uint256 targetAmount; //目标额度, 债务
386         uint256 timestamp;
387     }
388 
389     mapping(uint256 => LiquidateInfo) public liquidateInfoMap;
390     uint256 public liquidateIndexes;
391 
392     function setLiquidateInfoMap(
393         address _targetAccount,
394         address _liquidator,
395         address _assetCollatera,
396         address _assetBorrow,
397         uint256 x,
398         uint256 y
399     ) internal {
400         LiquidateInfo memory newStruct = LiquidateInfo(
401             _targetAccount,
402             _liquidator,
403             _assetCollatera,
404             _assetBorrow,
405             x,
406             y,
407             block.timestamp
408         );
409         // Update liquidation record
410         liquidateInfoMap[liquidateIndexes] = newStruct;
411         liquidateIndexes++;
412     }
413 
414     //user table
415     mapping(uint256 => address) public accounts;
416     mapping(address => uint256) public indexes;
417     uint256 public index = 1;
418 
419     // Add new user
420     function join(address who) internal {
421         if (indexes[who] == 0) {
422             accounts[index] = who;
423             indexes[who] = index;
424             ++index;
425         }
426     }
427 
428     event SupplyPawnLog(
429         address usr,
430         address t,
431         uint256 amount,
432         uint256 beg,
433         uint256 end
434     );
435     event WithdrawPawnLog(
436         address usr,
437         address t,
438         uint256 amount,
439         uint256 beg,
440         uint256 end
441     );
442     event BorrowPawnLog(
443         address usr,
444         address t,
445         uint256 amount,
446         uint256 beg,
447         uint256 end
448     );
449     event RepayFastBorrowLog(
450         address usr,
451         address t,
452         uint256 amount,
453         uint256 beg,
454         uint256 end
455     );
456     event LiquidateBorrowPawnLog(
457         address usr,
458         address tBorrow,
459         uint256 endBorrow,
460         address liquidator,
461         address tCol,
462         uint256 endCol
463     );
464     event WithdrawPawnEquityLog(
465         address t,
466         uint256 equityAvailableBefore,
467         uint256 amount,
468         address owner
469     );
470 
471     mapping(address => Market) public mkts; //tokenAddress->Market
472     address[] public collateralTokens; //抵押币种
473     IOracle public oracleInstance;
474 
475     uint256 public constant initialInterestIndex = 10**18;
476     uint256 public constant defaultOriginationFee = 0; // default is zero bps
477     uint256 public constant originationFee = 0;
478     uint256 public constant ONE_ETH = 1 ether;
479 
480     // 增加抵押币种
481     function addCollateralMarket(address asset) public onlyAdmin {
482         for (uint256 i = 0; i < collateralTokens.length; i++) {
483             if (collateralTokens[i] == asset) {
484                 return;
485             }
486         }
487         collateralTokens.push(asset);
488     }
489 
490     function getCollateralMarketsLength() external view returns (uint256) {
491         return collateralTokens.length;
492     }
493 
494     function setInterestRateModel(address t, address irm) public onlyAdmin {
495         mkts[t].irm = IInterestRateModel(irm);
496     }
497 
498     function setMinPledgeRate(address t, uint256 minPledgeRate)
499     external
500     onlyAdmin
501     {
502         mkts[t].minPledgeRate = minPledgeRate;
503     }
504 
505     function setLiquidationDiscount(address t, uint256 liquidationDiscount)
506     external
507     onlyAdmin
508     {
509         mkts[t].liquidationDiscount = liquidationDiscount;
510     }
511 
512     function initCollateralMarket(
513         address t,
514         address irm,
515         address oracle,
516         uint256 decimals
517     ) external onlyAdmin {
518         if (address(oracleInstance) == address(0)) {
519             setOracle(oracle);
520         }
521         Market memory m = mkts[t];
522         if (address(m.irm) == address(0)) {
523             setInterestRateModel(t, irm);
524         }
525 
526         addCollateralMarket(t);
527         if (m.supplyIndex == 0) {
528             m.supplyIndex = initialInterestIndex;
529         }
530 
531         if (m.borrowIndex == 0) {
532             m.borrowIndex = initialInterestIndex;
533         }
534 
535         if (m.decimals == 0) {
536             m.decimals = decimals;
537         }
538         mkts[t] = m;
539     }
540 
541     constructor() public {
542         admin = msg.sender;
543     }
544 
545     //Starting from Solidity 0.4.0, contracts without a fallback function automatically revert payments, making the code above redundant.
546     // function() external payable {
547     //   revert("fallback can't be payable");
548     // }
549 
550     modifier onlyAdmin() {
551         require(msg.sender == admin, "only admin can do this!");
552         _;
553     }
554 
555     function proposeNewAdmin(address admin_) external onlyAdmin {
556         proposedAdmin = admin_;
557     }
558 
559     function claimAdministration() external {
560         require(msg.sender == proposedAdmin, "Not proposed admin.");
561         admin = proposedAdmin;
562         proposedAdmin = address(0);
563     }
564 
565     // Set the initial timestamp of tokens
566     function setInitialTimestamp(address token) external onlyAdmin {
567         mkts[token].accrualBlockNumber = now;
568     }
569 
570     function setDecimals(address t, uint256 decimals) external onlyAdmin {
571         mkts[t].decimals = decimals;
572     }
573 
574     function setOracle(address oracle) public onlyAdmin {
575         oracleInstance = IOracle(oracle);
576     }
577 
578     modifier existOracle() {
579         require(address(oracleInstance) != address(0), "oracle not set");
580         _;
581     }
582 
583     // Get price of oracle
584     function fetchAssetPrice(address asset)
585     public
586     view
587     returns (uint256, bool)
588     {
589         require(address(oracleInstance) != address(0), "oracle not set");
590         return oracleInstance.get(asset);
591     }
592 
593     function valid_uint(uint r) internal view returns (int256) {
594         require(r <= int_max, "uint r is not valid");
595         return int256(r);
596     }
597 
598     // Get the price of assetAmount tokens
599     function getPriceForAssetAmount(address asset, uint256 assetAmount)
600     public
601     view
602     returns (uint256)
603     {
604         require(address(oracleInstance) != address(0), "oracle not set");
605         (uint256 price, bool ok) = fetchAssetPrice(asset);
606         require(ok && price != 0, "invalid token price");
607         return price.mul(assetAmount).div(10**mkts[asset].decimals);
608     }
609 
610     // Calc the token amount of usdValue
611     function getAssetAmountForValue(address t, uint256 usdValue)
612     public
613     view
614     returns (uint256)
615     {
616         require(address(oracleInstance) != address(0), "oracle not set");
617         (uint256 price, bool ok) = fetchAssetPrice(t);
618         require(ok && price != 0, "invalid token price");
619         return usdValue.mul(10**mkts[t].decimals).div(price);
620     }
621 
622     // Balance of "t" token of this contract
623     function getCash(address t) public view returns (uint256) {
624         // address(0) represents for eth
625         if (t == address(0)) {
626             return address(this).balance;
627         }
628         IERC20 token = IERC20(t);
629         return token.balanceOf(address(this));
630     }
631 
632     // Balance of "asset" token of the "from" account
633     function getBalanceOf(address asset, address from)
634     internal
635     view
636     returns (uint256)
637     {
638         // address(0) represents for eth
639         if (asset == address(0)) {
640             return address(from).balance;
641         }
642 
643         IERC20 token = IERC20(asset);
644 
645         return token.balanceOf(from);
646     }
647 
648     //  totalBorrows / totalSupply
649     function loanToDepositRatio(address asset) public view returns (uint256) {
650         uint256 loan = mkts[asset].totalBorrows;
651         uint256 deposit = mkts[asset].totalSupply;
652         // uint256 _1 = 1 ether;
653 
654         return loan.mul(ONE_ETH).div(deposit);
655     }
656 
657     //m:market, a:account
658     //i(n,m)=i(n-1,m)*(1+rm*t)
659     //return P*(i(n,m)/i(n-1,a))
660     // Calc the balance of the "t" token of "acc" account
661     function getSupplyBalance(address acc, address t)
662     public
663     view
664     returns (uint256)
665     {
666         Balance storage supplyBalance = accountSupplySnapshot[t][acc];
667 
668         int256 mSupplyIndex = mkts[t].irm.pert(
669             int256(mkts[t].supplyIndex),
670             mkts[t].supplyRate,
671             int256(now - mkts[t].accrualBlockNumber)
672         );
673 
674         uint256 userSupplyCurrent = uint256(
675             mkts[t].irm.calculateBalance(
676                 valid_uint(supplyBalance.principal),
677                 int256(supplyBalance.interestIndex),
678                 mSupplyIndex
679             )
680         );
681         return userSupplyCurrent;
682     }
683 
684     // Calc the actual USD value of "t" token of "who" account
685     function getSupplyBalanceInUSD(address who, address t)
686     public
687     view
688     returns (uint256)
689     {
690         return getPriceForAssetAmount(t, getSupplyBalance(who, t));
691     }
692 
693     // Calc the profit of "t" token of "acc" account
694     function getSupplyPnl(address acc, address t)
695     public
696     view
697     returns (uint256)
698     {
699         Balance storage supplyBalance = accountSupplySnapshot[t][acc];
700 
701         int256 mSupplyIndex = mkts[t].irm.pert(
702             int256(mkts[t].supplyIndex),
703             mkts[t].supplyRate,
704             int256(now - mkts[t].accrualBlockNumber)
705         );
706 
707         uint256 userSupplyCurrent = uint256(
708             mkts[t].irm.calculateBalance(
709                 valid_uint(supplyBalance.principal),
710                 int256(supplyBalance.interestIndex),
711                 mSupplyIndex
712             )
713         );
714 
715         if (userSupplyCurrent > supplyBalance.principal) {
716             return
717             supplyBalance.totalPnl.add(
718                 userSupplyCurrent.sub(supplyBalance.principal)
719             );
720         } else {
721             return supplyBalance.totalPnl;
722         }
723     }
724 
725     // Calc the profit of "t" token of "acc" account in USD value
726     function getSupplyPnlInUSD(address who, address t)
727     public
728     view
729     returns (uint256)
730     {
731         return getPriceForAssetAmount(t, getSupplyPnl(who, t));
732     }
733 
734     // Gets USD all token values of supply profit
735     function getTotalSupplyPnl(address who)
736     public
737     view
738     returns (uint256 sumPnl)
739     {
740         uint256 length = collateralTokens.length;
741 
742         for (uint256 i = 0; i < length; i++) {
743             uint256 pnl = getSupplyPnlInUSD(who, collateralTokens[i]);
744             sumPnl = sumPnl.add(pnl);
745         }
746     }
747 
748     //m:market, a:account
749     //i(n,m)=i(n-1,m)*(1+rm*t)
750     //return P*(i(n,m)/i(n-1,a))
751     function getBorrowBalance(address acc, address t)
752     public
753     view
754     returns (uint256)
755     {
756         Balance storage borrowBalance = accountBorrowSnapshot[t][acc];
757 
758         int256 mBorrowIndex = mkts[t].irm.pert(
759             int256(mkts[t].borrowIndex),
760             mkts[t].demondRate,
761             int256(now - mkts[t].accrualBlockNumber)
762         );
763 
764         uint256 userBorrowCurrent = uint256(
765             mkts[t].irm.calculateBalance(
766                 valid_uint(borrowBalance.principal),
767                 int256(borrowBalance.interestIndex),
768                 mBorrowIndex
769             )
770         );
771         return userBorrowCurrent;
772     }
773 
774     function getBorrowBalanceInUSD(address who, address t)
775     public
776     view
777     returns (uint256)
778     {
779         return getPriceForAssetAmount(t, getBorrowBalance(who, t));
780     }
781 
782     function getBorrowPnl(address acc, address t)
783     public
784     view
785     returns (uint256)
786     {
787         Balance storage borrowBalance = accountBorrowSnapshot[t][acc];
788 
789         int256 mBorrowIndex = mkts[t].irm.pert(
790             int256(mkts[t].borrowIndex),
791             mkts[t].demondRate,
792             int256(now - mkts[t].accrualBlockNumber)
793         );
794 
795         uint256 userBorrowCurrent = uint256(
796             mkts[t].irm.calculateBalance(
797                 valid_uint(borrowBalance.principal),
798                 int256(borrowBalance.interestIndex),
799                 mBorrowIndex
800             )
801         );
802 
803         return
804         borrowBalance.totalPnl.add(userBorrowCurrent).sub(
805             borrowBalance.principal
806         );
807     }
808 
809     function getBorrowPnlInUSD(address who, address t)
810     public
811     view
812     returns (uint256)
813     {
814         return getPriceForAssetAmount(t, getBorrowPnl(who, t));
815     }
816 
817     // Gets USD all token values of borrow lose
818     function getTotalBorrowPnl(address who)
819     public
820     view
821     returns (uint256 sumPnl)
822     {
823         uint256 length = collateralTokens.length;
824         // uint sumPnl = 0;
825 
826         for (uint256 i = 0; i < length; i++) {
827             uint256 pnl = getBorrowPnlInUSD(who, collateralTokens[i]);
828             sumPnl = sumPnl.add(pnl);
829         }
830         // return sumPnl;
831     }
832 
833     // BorrowBalance * collateral ratio
834     // collateral ratio always great than 1
835     function getBorrowBalanceLeverage(address who, address t)
836     public
837     view
838     returns (uint256)
839     {
840         return
841         getBorrowBalanceInUSD(who, t).mul(mkts[t].minPledgeRate).div(
842             ONE_ETH
843         );
844     }
845 
846     // Gets USD token values of supply and borrow balances
847     function calcAccountTokenValuesInternal(address who, address t)
848     public
849     view
850     returns (uint256, uint256)
851     {
852         return (getSupplyBalanceInUSD(who, t), getBorrowBalanceInUSD(who, t));
853     }
854 
855     // Gets USD token values of supply and borrow balances
856     function calcAccountTokenValuesLeverageInternal(address who, address t)
857     public
858     view
859     returns (uint256, uint256)
860     {
861         return (
862         getSupplyBalanceInUSD(who, t),
863         getBorrowBalanceLeverage(who, t)
864         );
865     }
866 
867     // Gets USD all token values of supply and borrow balances
868     function calcAccountAllTokenValuesLeverageInternal(address who)
869     public
870     view
871     returns (uint256 sumSupplies, uint256 sumBorrowLeverage)
872     {
873         uint256 length = collateralTokens.length;
874 
875         for (uint256 i = 0; i < length; i++) {
876             (
877             uint256 supplyValue,
878             uint256 borrowsLeverage
879             ) = calcAccountTokenValuesLeverageInternal(
880                 who,
881                 collateralTokens[i]
882             );
883             sumSupplies = sumSupplies.add(supplyValue);
884             sumBorrowLeverage = sumBorrowLeverage.add(borrowsLeverage);
885         }
886     }
887 
888     function calcAccountLiquidity(address who)
889     public
890     view
891     returns (uint256, uint256)
892     {
893         uint256 sumSupplies;
894         uint256 sumBorrowsLeverage; //sumBorrows* collateral ratio
895         (
896         sumSupplies,
897         sumBorrowsLeverage
898         ) = calcAccountAllTokenValuesLeverageInternal(who);
899         if (sumSupplies < sumBorrowsLeverage) {
900             return (0, sumBorrowsLeverage.sub(sumSupplies)); //不足
901         } else {
902             return (sumSupplies.sub(sumBorrowsLeverage), 0); //有余
903         }
904     }
905 
906     struct SupplyIR {
907         uint256 startingBalance;
908         uint256 newSupplyIndex;
909         uint256 userSupplyCurrent;
910         uint256 userSupplyUpdated;
911         uint256 newTotalSupply;
912         uint256 currentCash;
913         uint256 updatedCash;
914         uint256 newBorrowIndex;
915     }
916 
917     // deposit
918     function supplyPawn(address t, uint256 amount)
919     external
920     payable
921     nonReentrant
922     {
923         uint256 supplyAmount = amount;
924         // address(0) represents for eth
925         if (t == address(0)) {
926             require(amount == msg.value, "Eth value should be equal to amount");
927             supplyAmount = msg.value;
928         } else {
929             require(msg.value == 0, "Eth should not be provided");
930         }
931         SupplyIR memory tmp;
932         Market storage market = mkts[t];
933         Balance storage supplyBalance = accountSupplySnapshot[t][msg.sender];
934 
935         uint256 lastTimestamp = market.accrualBlockNumber;
936         uint256 blockDelta = now - lastTimestamp;
937 
938         // Calc the supplyIndex of supplyBalance
939         tmp.newSupplyIndex = uint256(
940             market.irm.pert(
941                 int256(market.supplyIndex),
942                 market.supplyRate,
943                 int256(blockDelta)
944             )
945         );
946         tmp.userSupplyCurrent = uint256(
947             market.irm.calculateBalance(
948                 valid_uint(accountSupplySnapshot[t][msg.sender].principal),
949                 int256(supplyBalance.interestIndex),
950                 int256(tmp.newSupplyIndex)
951             )
952         );
953         tmp.userSupplyUpdated = tmp.userSupplyCurrent.add(supplyAmount);
954         // Update supply of the market
955         tmp.newTotalSupply = market.totalSupply.add(tmp.userSupplyUpdated).sub(
956             supplyBalance.principal
957         );
958 
959         tmp.currentCash = getCash(t);
960         // address(0) represents for eth
961         // We support both ERC20 and ETH.
962         // Calc the new Balance of the contract if it's ERC20
963         // else(ETH) does nothing because the cash has been added(msg.value) when the contract is called
964         tmp.updatedCash = t != address(0)
965         ? tmp.currentCash.add(supplyAmount)
966         : tmp.currentCash;
967 
968         // Update supplyRate and demondRate
969         market.supplyRate = market.irm.getDepositRate(
970             valid_uint(tmp.updatedCash),
971             valid_uint(market.totalBorrows)
972         );
973         tmp.newBorrowIndex = uint256(
974             market.irm.pert(
975                 int256(market.borrowIndex),
976                 market.demondRate,
977                 int256(blockDelta)
978             )
979         );
980         market.demondRate = market.irm.getLoanRate(
981             valid_uint(tmp.updatedCash),
982             valid_uint(market.totalBorrows)
983         );
984 
985         market.borrowIndex = tmp.newBorrowIndex;
986         market.supplyIndex = tmp.newSupplyIndex;
987         market.totalSupply = tmp.newTotalSupply;
988         market.accrualBlockNumber = now;
989         // mkts[t] = market;
990         tmp.startingBalance = supplyBalance.principal;
991         supplyBalance.principal = tmp.userSupplyUpdated;
992         supplyBalance.interestIndex = tmp.newSupplyIndex;
993 
994         // Update total profit of user
995         if (tmp.userSupplyCurrent > tmp.startingBalance) {
996             supplyBalance.totalPnl = supplyBalance.totalPnl.add(
997                 tmp.userSupplyCurrent.sub(tmp.startingBalance)
998             );
999         }
1000 
1001         join(msg.sender);
1002 
1003         safeTransferFrom(
1004             t,
1005             msg.sender,
1006             address(this),
1007             address(this).makePayable(),
1008             supplyAmount,
1009             0
1010         );
1011 
1012         emit SupplyPawnLog(
1013             msg.sender,
1014             t,
1015             supplyAmount,
1016             tmp.startingBalance,
1017             tmp.userSupplyUpdated
1018         );
1019     }
1020 
1021     struct WithdrawIR {
1022         uint256 withdrawAmount;
1023         uint256 startingBalance;
1024         uint256 newSupplyIndex;
1025         uint256 userSupplyCurrent;
1026         uint256 userSupplyUpdated;
1027         uint256 newTotalSupply;
1028         uint256 currentCash;
1029         uint256 updatedCash;
1030         uint256 newBorrowIndex;
1031         uint256 accountLiquidity;
1032         uint256 accountShortfall;
1033         uint256 usdValueOfWithdrawal;
1034         uint256 withdrawCapacity;
1035     }
1036 
1037     // withdraw
1038     function withdrawPawn(address t, uint256 requestedAmount)
1039     external
1040     nonReentrant
1041     {
1042         Market storage market = mkts[t];
1043         Balance storage supplyBalance = accountSupplySnapshot[t][msg.sender];
1044 
1045         WithdrawIR memory tmp;
1046 
1047         uint256 lastTimestamp = mkts[t].accrualBlockNumber;
1048         uint256 blockDelta = now - lastTimestamp;
1049 
1050         // Judge if the user has ability to withdraw
1051         (tmp.accountLiquidity, tmp.accountShortfall) = calcAccountLiquidity(
1052             msg.sender
1053         );
1054         require(
1055             tmp.accountLiquidity != 0 && tmp.accountShortfall == 0,
1056             "can't withdraw, shortfall"
1057         );
1058         // Update the balance of the user
1059         tmp.newSupplyIndex = uint256(
1060             mkts[t].irm.pert(
1061                 int256(mkts[t].supplyIndex),
1062                 mkts[t].supplyRate,
1063                 int256(blockDelta)
1064             )
1065         );
1066         tmp.userSupplyCurrent = uint256(
1067             mkts[t].irm.calculateBalance(
1068                 valid_uint(supplyBalance.principal),
1069                 int256(supplyBalance.interestIndex),
1070                 int256(tmp.newSupplyIndex)
1071             )
1072         );
1073 
1074         // Get the balance of this contract
1075         tmp.currentCash = getCash(t);
1076         // uint(-1) represents the user want to withdraw all of his supplies of the "t" token
1077         if (requestedAmount == uint256(-1)) {
1078             // max withdraw amount = min(his account liquidity, his balance)
1079             tmp.withdrawCapacity = getAssetAmountForValue(
1080                 t,
1081                 tmp.accountLiquidity
1082             );
1083             tmp.withdrawAmount = min(
1084                 min(tmp.withdrawCapacity, tmp.userSupplyCurrent),
1085                 tmp.currentCash
1086             );
1087             // tmp.withdrawAmount = min(tmp.withdrawAmount, tmp.currentCash);
1088         } else {
1089             tmp.withdrawAmount = requestedAmount;
1090         }
1091 
1092         // Update balance of this contract
1093         tmp.updatedCash = tmp.currentCash.sub(tmp.withdrawAmount);
1094         tmp.userSupplyUpdated = tmp.userSupplyCurrent.sub(tmp.withdrawAmount);
1095 
1096         // Get the amount of token to withdraw
1097         tmp.usdValueOfWithdrawal = getPriceForAssetAmount(
1098             t,
1099             tmp.withdrawAmount
1100         );
1101         // require account liquidity is enough
1102         require(
1103             tmp.usdValueOfWithdrawal <= tmp.accountLiquidity,
1104             "account is short"
1105         );
1106 
1107         // Update totalSupply of the market
1108         tmp.newTotalSupply = market.totalSupply.add(tmp.userSupplyUpdated).sub(
1109             supplyBalance.principal
1110         );
1111 
1112         tmp.newSupplyIndex = uint256(
1113             mkts[t].irm.pert(
1114                 int256(mkts[t].supplyIndex),
1115                 mkts[t].supplyRate,
1116                 int256(blockDelta)
1117             )
1118         );
1119 
1120         // Update loan to deposit rate
1121         market.supplyRate = mkts[t].irm.getDepositRate(
1122             valid_uint(tmp.updatedCash),
1123             valid_uint(market.totalBorrows)
1124         );
1125         tmp.newBorrowIndex = uint256(
1126             mkts[t].irm.pert(
1127                 int256(mkts[t].borrowIndex),
1128                 mkts[t].demondRate,
1129                 int256(blockDelta)
1130             )
1131         );
1132         market.demondRate = mkts[t].irm.getLoanRate(
1133             valid_uint(tmp.updatedCash),
1134             valid_uint(market.totalBorrows)
1135         );
1136 
1137         market.accrualBlockNumber = now;
1138         market.totalSupply = tmp.newTotalSupply;
1139         market.supplyIndex = tmp.newSupplyIndex;
1140         market.borrowIndex = tmp.newBorrowIndex;
1141         // mkts[t] = market;
1142         tmp.startingBalance = supplyBalance.principal;
1143         supplyBalance.principal = tmp.userSupplyUpdated;
1144         supplyBalance.interestIndex = tmp.newSupplyIndex;
1145 
1146         safeTransferFrom(
1147             t,
1148             address(this).makePayable(),
1149             address(this),
1150             msg.sender,
1151             tmp.withdrawAmount,
1152             0
1153         );
1154 
1155         emit WithdrawPawnLog(
1156             msg.sender,
1157             t,
1158             tmp.withdrawAmount,
1159             tmp.startingBalance,
1160             tmp.userSupplyUpdated
1161         );
1162     }
1163 
1164     struct PayBorrowIR {
1165         uint256 newBorrowIndex;
1166         uint256 userBorrowCurrent;
1167         uint256 repayAmount;
1168         uint256 userBorrowUpdated;
1169         uint256 newTotalBorrows;
1170         uint256 currentCash;
1171         uint256 updatedCash;
1172         uint256 newSupplyIndex;
1173         uint256 startingBalance;
1174     }
1175 
1176     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1177         if (a < b) {
1178             return a;
1179         } else {
1180             return b;
1181         }
1182     }
1183 
1184     //`(1 + originationFee) * borrowAmount`
1185     function calcBorrowAmountWithFee(uint256 borrowAmount)
1186     public
1187     pure
1188     returns (uint256)
1189     {
1190         return borrowAmount.mul((ONE_ETH).add(originationFee)).div(ONE_ETH);
1191     }
1192 
1193     // supply value * min pledge rate
1194     function getPriceForAssetAmountMulCollatRatio(
1195         address t,
1196         uint256 assetAmount
1197     ) public view returns (uint256) {
1198         return
1199         getPriceForAssetAmount(t, assetAmount)
1200         .mul(mkts[t].minPledgeRate)
1201         .div(ONE_ETH);
1202     }
1203 
1204     struct BorrowIR {
1205         uint256 newBorrowIndex;
1206         uint256 userBorrowCurrent;
1207         uint256 borrowAmountWithFee;
1208         uint256 userBorrowUpdated;
1209         uint256 newTotalBorrows;
1210         uint256 currentCash;
1211         uint256 updatedCash;
1212         uint256 newSupplyIndex;
1213         uint256 startingBalance;
1214         uint256 accountLiquidity;
1215         uint256 accountShortfall;
1216         uint256 usdValueOfBorrowAmountWithFee;
1217     }
1218 
1219     // borrow
1220     function BorrowPawn(address t, uint256 amount) external nonReentrant {
1221         BorrowIR memory tmp;
1222         Market storage market = mkts[t];
1223         Balance storage borrowBalance = accountBorrowSnapshot[t][msg.sender];
1224 
1225         uint256 lastTimestamp = mkts[t].accrualBlockNumber;
1226         uint256 blockDelta = now - lastTimestamp;
1227 
1228         // Calc borrow index
1229         tmp.newBorrowIndex = uint256(
1230             mkts[t].irm.pert(
1231                 int256(mkts[t].borrowIndex),
1232                 mkts[t].demondRate,
1233                 int256(blockDelta)
1234             )
1235         );
1236         int256 lastIndex = int256(borrowBalance.interestIndex);
1237         tmp.userBorrowCurrent = uint256(
1238             mkts[t].irm.calculateBalance(
1239                 valid_uint(borrowBalance.principal),
1240                 lastIndex,
1241                 int256(tmp.newBorrowIndex)
1242             )
1243         );
1244         // add borrow fee
1245         tmp.borrowAmountWithFee = calcBorrowAmountWithFee(amount);
1246 
1247         tmp.userBorrowUpdated = tmp.userBorrowCurrent.add(
1248             tmp.borrowAmountWithFee
1249         );
1250         // Update market borrows
1251         tmp.newTotalBorrows = market
1252         .totalBorrows
1253         .add(tmp.userBorrowUpdated)
1254         .sub(borrowBalance.principal);
1255 
1256         // calc account liquidity
1257         (tmp.accountLiquidity, tmp.accountShortfall) = calcAccountLiquidity(
1258             msg.sender
1259         );
1260         require(
1261             tmp.accountLiquidity != 0 && tmp.accountShortfall == 0,
1262             "can't borrow, shortfall"
1263         );
1264 
1265         // require accountLiquitidy is enough
1266         tmp.usdValueOfBorrowAmountWithFee = getPriceForAssetAmountMulCollatRatio(
1267             t,
1268             tmp.borrowAmountWithFee
1269         );
1270         require(
1271             tmp.usdValueOfBorrowAmountWithFee <= tmp.accountLiquidity,
1272             "can't borrow, without enough value"
1273         );
1274 
1275         // Update the balance of this contract
1276         tmp.currentCash = getCash(t);
1277         tmp.updatedCash = tmp.currentCash.sub(amount);
1278 
1279         tmp.newSupplyIndex = uint256(
1280             mkts[t].irm.pert(
1281                 int256(mkts[t].supplyIndex),
1282                 mkts[t].supplyRate,
1283                 int256(blockDelta)
1284             )
1285         );
1286         market.supplyRate = mkts[t].irm.getDepositRate(
1287             valid_uint(tmp.updatedCash),
1288             valid_uint(tmp.newTotalBorrows)
1289         );
1290         market.demondRate = mkts[t].irm.getLoanRate(
1291             valid_uint(tmp.updatedCash),
1292             valid_uint(tmp.newTotalBorrows)
1293         );
1294 
1295         market.accrualBlockNumber = now;
1296         market.totalBorrows = tmp.newTotalBorrows;
1297         market.supplyIndex = tmp.newSupplyIndex;
1298         market.borrowIndex = tmp.newBorrowIndex;
1299         // mkts[t] = market;
1300         tmp.startingBalance = borrowBalance.principal;
1301         borrowBalance.principal = tmp.userBorrowUpdated;
1302         borrowBalance.interestIndex = tmp.newBorrowIndex;
1303 
1304         // 更新币种的借币总额
1305         // borrowBalance.totalPnl = borrowBalance.totalPnl.add(tmp.userBorrowCurrent.sub(tmp.startingBalance));
1306 
1307         safeTransferFrom(
1308             t,
1309             address(this).makePayable(),
1310             address(this),
1311             msg.sender,
1312             amount,
1313             0
1314         );
1315 
1316         emit BorrowPawnLog(
1317             msg.sender,
1318             t,
1319             amount,
1320             tmp.startingBalance,
1321             tmp.userBorrowUpdated
1322         );
1323         // return 0;
1324     }
1325 
1326     // repay
1327     function repayFastBorrow(address t, uint256 amount)
1328     external
1329     payable
1330     nonReentrant
1331     {
1332         PayBorrowIR memory tmp;
1333         Market storage market = mkts[t];
1334         Balance storage borrowBalance = accountBorrowSnapshot[t][msg.sender];
1335 
1336         uint256 lastTimestamp = mkts[t].accrualBlockNumber;
1337         uint256 blockDelta = now - lastTimestamp;
1338 
1339         // calc the new borrow index
1340         tmp.newBorrowIndex = uint256(
1341             mkts[t].irm.pert(
1342                 int256(mkts[t].borrowIndex),
1343                 mkts[t].demondRate,
1344                 int256(blockDelta)
1345             )
1346         );
1347 
1348         int256 lastIndex = int256(borrowBalance.interestIndex);
1349         tmp.userBorrowCurrent = uint256(
1350             mkts[t].irm.calculateBalance(
1351                 valid_uint(borrowBalance.principal),
1352                 lastIndex,
1353                 int256(tmp.newBorrowIndex)
1354             )
1355         );
1356 
1357         // uint(-1) represents the user want to repay all of his borrows of "t" token
1358         if (amount == uint256(-1)) {
1359             // that is the minimum of (his balance, his borrows)
1360             tmp.repayAmount = min(
1361                 getBalanceOf(t, msg.sender),
1362                 tmp.userBorrowCurrent
1363             );
1364             // address(0) represents for eth
1365             // if the user want to repay eth, he needs to repay a little more
1366             // because the exact amount will be calculated in the above
1367             // the extra eth will be returned in the safeTransferFrom
1368             if (t == address(0)) {
1369                 require(
1370                     msg.value > tmp.repayAmount,
1371                     "Eth value should be larger than repayAmount"
1372                 );
1373             }
1374         } else {
1375             tmp.repayAmount = amount;
1376             if (t == address(0)) {
1377                 require(
1378                     msg.value == tmp.repayAmount,
1379                     "Eth value should be equal to repayAmount"
1380                 );
1381             }
1382         }
1383 
1384         // calc the new borrows of user
1385         tmp.userBorrowUpdated = tmp.userBorrowCurrent.sub(tmp.repayAmount);
1386         // calc the new borrows of market
1387         tmp.newTotalBorrows = market
1388         .totalBorrows
1389         .add(tmp.userBorrowUpdated)
1390         .sub(borrowBalance.principal);
1391         tmp.currentCash = getCash(t);
1392         // address(0) represents for eth
1393         // just like the supplyPawn function, eth has been transfered.
1394         tmp.updatedCash = t != address(0)
1395         ? tmp.currentCash.add(tmp.repayAmount)
1396         : tmp.currentCash;
1397 
1398         tmp.newSupplyIndex = uint256(
1399             mkts[t].irm.pert(
1400                 int256(mkts[t].supplyIndex),
1401                 mkts[t].supplyRate,
1402                 int256(blockDelta)
1403             )
1404         );
1405         // update deposit and loan rate
1406         market.supplyRate = mkts[t].irm.getDepositRate(
1407             valid_uint(tmp.updatedCash),
1408             valid_uint(tmp.newTotalBorrows)
1409         );
1410         market.demondRate = mkts[t].irm.getLoanRate(
1411             valid_uint(tmp.updatedCash),
1412             valid_uint(tmp.newTotalBorrows)
1413         );
1414 
1415         market.accrualBlockNumber = now;
1416         market.totalBorrows = tmp.newTotalBorrows;
1417         market.supplyIndex = tmp.newSupplyIndex;
1418         market.borrowIndex = tmp.newBorrowIndex;
1419         // mkts[t] = market;
1420         tmp.startingBalance = borrowBalance.principal;
1421         borrowBalance.principal = tmp.userBorrowUpdated;
1422         borrowBalance.interestIndex = tmp.newBorrowIndex;
1423 
1424         safeTransferFrom(
1425             t,
1426             msg.sender,
1427             address(this),
1428             address(this).makePayable(),
1429             tmp.repayAmount,
1430             msg.value
1431         );
1432 
1433         emit RepayFastBorrowLog(
1434             msg.sender,
1435             t,
1436             tmp.repayAmount,
1437             tmp.startingBalance,
1438             tmp.userBorrowUpdated
1439         );
1440 
1441     }
1442 
1443     // shortfall/(price*(minPledgeRate-liquidationDiscount-1))
1444     // underwaterAsset is borrowAsset
1445     function calcDiscountedRepayToEvenAmount(
1446         address targetAccount,
1447         address underwaterAsset,
1448         uint256 underwaterAssetPrice
1449     ) public view returns (uint256) {
1450         (, uint256 shortfall) = calcAccountLiquidity(targetAccount);
1451         uint256 minPledgeRate = mkts[underwaterAsset].minPledgeRate;
1452         uint256 liquidationDiscount = mkts[underwaterAsset].liquidationDiscount;
1453         uint256 gap = minPledgeRate.sub(liquidationDiscount).sub(1 ether);
1454         return
1455         shortfall.mul(10**mkts[underwaterAsset].decimals).div(
1456             underwaterAssetPrice.mul(gap).div(ONE_ETH)
1457         ); //underwater asset amount
1458     }
1459 
1460     //[supplyCurrent / (1 + liquidationDiscount)] * (Oracle price for the collateral / Oracle price for the borrow)
1461     //[supplyCurrent * (Oracle price for the collateral)] / [ (1 + liquidationDiscount) * (Oracle price for the borrow) ]
1462     // amount of underwaterAsset to be repayed by liquidator, calculated by the amount of collateral asset
1463     function calcDiscountedBorrowDenominatedCollateral(
1464         address underwaterAsset,
1465         address collateralAsset,
1466         uint256 underwaterAssetPrice,
1467         uint256 collateralPrice,
1468         uint256 supplyCurrent_TargetCollateralAsset
1469     ) public view returns (uint256 res) {
1470         uint256 liquidationDiscount = mkts[underwaterAsset].liquidationDiscount;
1471         uint256 onePlusLiquidationDiscount = (ONE_ETH).add(liquidationDiscount);
1472         uint256 supplyCurrentTimesOracleCollateral
1473         = supplyCurrent_TargetCollateralAsset.mul(collateralPrice);
1474 
1475         res = supplyCurrentTimesOracleCollateral.div(
1476             onePlusLiquidationDiscount.mul(underwaterAssetPrice).div(ONE_ETH)
1477         ); //underwaterAsset amout
1478         res = res.mul(10**mkts[underwaterAsset].decimals);
1479         res = res.div(10**mkts[collateralAsset].decimals);
1480     }
1481 
1482     //closeBorrowAmount_TargetUnderwaterAsset * (1+liquidationDiscount) * priceBorrow/priceCollateral
1483     //underwaterAssetPrice * (1+liquidationDiscount) *closeBorrowAmount_TargetUnderwaterAsset) / collateralPrice
1484     //underwater is borrow
1485     // calc the amount of collateral asset bought by underwaterAsset(amount: closeBorrowAmount_TargetUnderwaterAsset)
1486     function calcAmountSeize(
1487         address underwaterAsset,
1488         address collateralAsset,
1489         uint256 underwaterAssetPrice,
1490         uint256 collateralPrice,
1491         uint256 closeBorrowAmount_TargetUnderwaterAsset
1492     ) public view returns (uint256 res) {
1493         uint256 liquidationDiscount = mkts[underwaterAsset].liquidationDiscount;
1494         uint256 onePlusLiquidationDiscount = (ONE_ETH).add(liquidationDiscount);
1495         res = underwaterAssetPrice.mul(onePlusLiquidationDiscount);
1496         res = res.mul(closeBorrowAmount_TargetUnderwaterAsset);
1497         res = res.div(collateralPrice);
1498         res = res.div(ONE_ETH);
1499         res = res.mul(10**mkts[collateralAsset].decimals);
1500         res = res.div(10**mkts[underwaterAsset].decimals);
1501     }
1502 
1503     struct LiquidateIR {
1504         // we need these addresses in the struct for use with `emitLiquidationEvent` to avoid `CompilerError: Stack too deep, try removing local variables.`
1505         address targetAccount;
1506         address assetBorrow;
1507         address liquidator;
1508         address assetCollateral;
1509         // borrow index and supply index are global to the asset, not specific to the user
1510         uint256 newBorrowIndex_UnderwaterAsset;
1511         uint256 newSupplyIndex_UnderwaterAsset;
1512         uint256 newBorrowIndex_CollateralAsset;
1513         uint256 newSupplyIndex_CollateralAsset;
1514         // the target borrow's full balance with accumulated interest
1515         uint256 currentBorrowBalance_TargetUnderwaterAsset;
1516         // currentBorrowBalance_TargetUnderwaterAsset minus whatever gets repaid as part of the liquidation
1517         uint256 updatedBorrowBalance_TargetUnderwaterAsset;
1518         uint256 newTotalBorrows_ProtocolUnderwaterAsset;
1519         uint256 startingBorrowBalance_TargetUnderwaterAsset;
1520         uint256 startingSupplyBalance_TargetCollateralAsset;
1521         uint256 startingSupplyBalance_LiquidatorCollateralAsset;
1522         uint256 currentSupplyBalance_TargetCollateralAsset;
1523         uint256 updatedSupplyBalance_TargetCollateralAsset;
1524         // If liquidator already has a balance of collateralAsset, we will accumulate
1525         // interest on it before transferring seized collateral from the borrower.
1526         uint256 currentSupplyBalance_LiquidatorCollateralAsset;
1527         // This will be the liquidator's accumulated balance of collateral asset before the liquidation (if any)
1528         // plus the amount seized from the borrower.
1529         uint256 updatedSupplyBalance_LiquidatorCollateralAsset;
1530         uint256 newTotalSupply_ProtocolCollateralAsset;
1531         uint256 currentCash_ProtocolUnderwaterAsset;
1532         uint256 updatedCash_ProtocolUnderwaterAsset;
1533         // cash does not change for collateral asset
1534 
1535         //mkts[t]
1536         uint256 newSupplyRateMantissa_ProtocolUnderwaterAsset;
1537         uint256 newBorrowRateMantissa_ProtocolUnderwaterAsset;
1538         // Why no variables for the interest rates for the collateral asset?
1539         // We don't need to calculate new rates for the collateral asset since neither cash nor borrows change
1540 
1541         uint256 discountedRepayToEvenAmount;
1542         //[supplyCurrent / (1 + liquidationDiscount)] * (Oracle price for the collateral / Oracle price for the borrow) (discountedBorrowDenominatedCollateral)
1543         uint256 discountedBorrowDenominatedCollateral;
1544         uint256 maxCloseableBorrowAmount_TargetUnderwaterAsset;
1545         uint256 closeBorrowAmount_TargetUnderwaterAsset;
1546         uint256 seizeSupplyAmount_TargetCollateralAsset;
1547         uint256 collateralPrice;
1548         uint256 underwaterAssetPrice;
1549     }
1550 
1551     // get the max amount to be liquidated
1552     function calcMaxLiquidateAmount(
1553         address targetAccount,
1554         address assetBorrow,
1555         address assetCollateral
1556     ) external view returns (uint256) {
1557         require(msg.sender != targetAccount, "can't self-liquidate");
1558         LiquidateIR memory tmp;
1559 
1560         uint256 blockDelta = now - mkts[assetBorrow].accrualBlockNumber;
1561 
1562         Market storage borrowMarket = mkts[assetBorrow];
1563         Market storage collateralMarket = mkts[assetCollateral];
1564 
1565         Balance storage borrowBalance_TargeUnderwaterAsset
1566         = accountBorrowSnapshot[assetBorrow][targetAccount];
1567 
1568 
1569         Balance storage supplyBalance_TargetCollateralAsset
1570         = accountSupplySnapshot[assetCollateral][targetAccount];
1571 
1572         tmp.newSupplyIndex_CollateralAsset = uint256(
1573             collateralMarket.irm.pert(
1574                 int256(collateralMarket.supplyIndex),
1575                 collateralMarket.supplyRate,
1576                 int256(blockDelta)
1577             )
1578         );
1579         tmp.newBorrowIndex_UnderwaterAsset = uint256(
1580             borrowMarket.irm.pert(
1581                 int256(borrowMarket.borrowIndex),
1582                 borrowMarket.demondRate,
1583                 int256(blockDelta)
1584             )
1585         );
1586         tmp.currentSupplyBalance_TargetCollateralAsset = uint256(
1587             collateralMarket.irm.calculateBalance(
1588                 valid_uint(supplyBalance_TargetCollateralAsset.principal),
1589                 int256(supplyBalance_TargetCollateralAsset.interestIndex),
1590                 int256(tmp.newSupplyIndex_CollateralAsset)
1591             )
1592         );
1593         tmp.currentBorrowBalance_TargetUnderwaterAsset = uint256(
1594             borrowMarket.irm.calculateBalance(
1595                 valid_uint(borrowBalance_TargeUnderwaterAsset.principal),
1596                 int256(borrowBalance_TargeUnderwaterAsset.interestIndex),
1597                 int256(tmp.newBorrowIndex_UnderwaterAsset)
1598             )
1599         );
1600 
1601         bool ok;
1602         (tmp.collateralPrice, ok) = fetchAssetPrice(assetCollateral);
1603         require(ok, "fail to get collateralPrice");
1604 
1605         (tmp.underwaterAssetPrice, ok) = fetchAssetPrice(assetBorrow);
1606         require(ok, "fail to get underwaterAssetPrice");
1607 
1608         tmp.discountedBorrowDenominatedCollateral = calcDiscountedBorrowDenominatedCollateral(
1609             assetBorrow,
1610             assetCollateral,
1611             tmp.underwaterAssetPrice,
1612             tmp.collateralPrice,
1613             tmp.currentSupplyBalance_TargetCollateralAsset
1614         );
1615         tmp.discountedRepayToEvenAmount = calcDiscountedRepayToEvenAmount(
1616             targetAccount,
1617             assetBorrow,
1618             tmp.underwaterAssetPrice
1619         );
1620         tmp.maxCloseableBorrowAmount_TargetUnderwaterAsset = min(
1621             tmp.currentBorrowBalance_TargetUnderwaterAsset,
1622             tmp.discountedBorrowDenominatedCollateral
1623         );
1624         tmp.maxCloseableBorrowAmount_TargetUnderwaterAsset = min(
1625             tmp.maxCloseableBorrowAmount_TargetUnderwaterAsset,
1626             tmp.discountedRepayToEvenAmount
1627         );
1628 
1629         return tmp.maxCloseableBorrowAmount_TargetUnderwaterAsset;
1630     }
1631 
1632     // liquidate
1633     function liquidateBorrowPawn(
1634         address targetAccount,
1635         address assetBorrow,
1636         address assetCollateral,
1637         uint256 requestedAmountClose
1638     ) external payable nonReentrant {
1639         require(msg.sender != targetAccount, "can't self-liquidate");
1640         LiquidateIR memory tmp;
1641         // Copy these addresses into the struct for use with `emitLiquidationEvent`
1642         // We'll use tmp.liquidator inside this function for clarity vs using msg.sender.
1643         tmp.targetAccount = targetAccount;
1644         tmp.assetBorrow = assetBorrow;
1645         tmp.liquidator = msg.sender;
1646         tmp.assetCollateral = assetCollateral;
1647 
1648         uint256 blockDelta = now - mkts[assetBorrow].accrualBlockNumber;
1649 
1650         Market storage borrowMarket = mkts[assetBorrow];
1651         Market storage collateralMarket = mkts[assetCollateral];
1652 
1653         // borrower's borrow balance and supply balance
1654         Balance storage borrowBalance_TargeUnderwaterAsset
1655         = accountBorrowSnapshot[assetBorrow][targetAccount];
1656 
1657         Balance storage supplyBalance_TargetCollateralAsset
1658         = accountSupplySnapshot[assetCollateral][targetAccount];
1659 
1660         // Liquidator might already hold some of the collateral asset
1661         Balance storage supplyBalance_LiquidatorCollateralAsset
1662         = accountSupplySnapshot[assetCollateral][tmp.liquidator];
1663 
1664         bool ok;
1665         (tmp.collateralPrice, ok) = fetchAssetPrice(assetCollateral);
1666         require(ok, "fail to get collateralPrice");
1667 
1668         (tmp.underwaterAssetPrice, ok) = fetchAssetPrice(assetBorrow);
1669         require(ok, "fail to get underwaterAssetPrice");
1670 
1671         // calc borrower's borrow balance with the newest interest
1672         tmp.newBorrowIndex_UnderwaterAsset = uint256(
1673             borrowMarket.irm.pert(
1674                 int256(borrowMarket.borrowIndex),
1675                 borrowMarket.demondRate,
1676                 int256(blockDelta)
1677             )
1678         );
1679         tmp.currentBorrowBalance_TargetUnderwaterAsset = uint256(
1680             borrowMarket.irm.calculateBalance(
1681                 valid_uint(borrowBalance_TargeUnderwaterAsset.principal),
1682                 int256(borrowBalance_TargeUnderwaterAsset.interestIndex),
1683                 int256(tmp.newBorrowIndex_UnderwaterAsset)
1684             )
1685         );
1686 
1687         // calc borrower's supply balance with the newest interest
1688         tmp.newSupplyIndex_CollateralAsset = uint256(
1689             collateralMarket.irm.pert(
1690                 int256(collateralMarket.supplyIndex),
1691                 collateralMarket.supplyRate,
1692                 int256(blockDelta)
1693             )
1694         );
1695         tmp.currentSupplyBalance_TargetCollateralAsset = uint256(
1696             collateralMarket.irm.calculateBalance(
1697                 valid_uint(supplyBalance_TargetCollateralAsset.principal),
1698                 int256(supplyBalance_TargetCollateralAsset.interestIndex),
1699                 int256(tmp.newSupplyIndex_CollateralAsset)
1700             )
1701         );
1702 
1703         // calc liquidator's balance of the collateral asset
1704         tmp.currentSupplyBalance_LiquidatorCollateralAsset = uint256(
1705             collateralMarket.irm.calculateBalance(
1706                 valid_uint(supplyBalance_LiquidatorCollateralAsset.principal),
1707                 int256(supplyBalance_LiquidatorCollateralAsset.interestIndex),
1708                 int256(tmp.newSupplyIndex_CollateralAsset)
1709             )
1710         );
1711 
1712         // update collateral asset of the market
1713         tmp.newTotalSupply_ProtocolCollateralAsset = collateralMarket
1714         .totalSupply
1715         .add(tmp.currentSupplyBalance_TargetCollateralAsset)
1716         .sub(supplyBalance_TargetCollateralAsset.principal);
1717         tmp.newTotalSupply_ProtocolCollateralAsset = tmp
1718         .newTotalSupply_ProtocolCollateralAsset
1719         .add(tmp.currentSupplyBalance_LiquidatorCollateralAsset)
1720         .sub(supplyBalance_LiquidatorCollateralAsset.principal);
1721 
1722         // calc the max amount to be liquidated
1723         tmp.discountedBorrowDenominatedCollateral = calcDiscountedBorrowDenominatedCollateral(
1724             assetBorrow,
1725             assetCollateral,
1726             tmp.underwaterAssetPrice,
1727             tmp.collateralPrice,
1728             tmp.currentSupplyBalance_TargetCollateralAsset
1729         );
1730         tmp.discountedRepayToEvenAmount = calcDiscountedRepayToEvenAmount(
1731             targetAccount,
1732             assetBorrow,
1733             tmp.underwaterAssetPrice
1734         );
1735         tmp.maxCloseableBorrowAmount_TargetUnderwaterAsset = min(
1736             min(
1737                 tmp.currentBorrowBalance_TargetUnderwaterAsset,
1738                 tmp.discountedBorrowDenominatedCollateral
1739             ),
1740             tmp.discountedRepayToEvenAmount
1741         );
1742 
1743         // uint(-1) represents the user want to liquidate all
1744         if (requestedAmountClose == uint256(-1)) {
1745             tmp.closeBorrowAmount_TargetUnderwaterAsset = tmp
1746             .maxCloseableBorrowAmount_TargetUnderwaterAsset;
1747         } else {
1748             tmp.closeBorrowAmount_TargetUnderwaterAsset = requestedAmountClose;
1749         }
1750         require(
1751             tmp.closeBorrowAmount_TargetUnderwaterAsset <=
1752             tmp.maxCloseableBorrowAmount_TargetUnderwaterAsset,
1753             "closeBorrowAmount > maxCloseableBorrowAmount err"
1754         );
1755         // address(0) represents for eth
1756         if (assetBorrow == address(0)) {
1757             // just the repay method, eth amount be transfered should be a litte more
1758             require(
1759                 msg.value >= tmp.closeBorrowAmount_TargetUnderwaterAsset,
1760                 "Not enough ETH"
1761             );
1762         } else {
1763             // user needs to have enough balance
1764             require(
1765                 getBalanceOf(assetBorrow, tmp.liquidator) >=
1766                 tmp.closeBorrowAmount_TargetUnderwaterAsset,
1767                 "insufficient balance"
1768             );
1769         }
1770 
1771         // 计算清算人实际清算得到的此质押币数量
1772         // The amount of collateral asset that liquidator can get
1773         tmp.seizeSupplyAmount_TargetCollateralAsset = calcAmountSeize(
1774             assetBorrow,
1775             assetCollateral,
1776             tmp.underwaterAssetPrice,
1777             tmp.collateralPrice,
1778             tmp.closeBorrowAmount_TargetUnderwaterAsset
1779         );
1780 
1781         // 被清算人借币余额减少
1782         // Update borrower's balance
1783         tmp.updatedBorrowBalance_TargetUnderwaterAsset = tmp
1784         .currentBorrowBalance_TargetUnderwaterAsset
1785         .sub(tmp.closeBorrowAmount_TargetUnderwaterAsset);
1786         // 更新借币市场总量
1787         // Update borrow market
1788         tmp.newTotalBorrows_ProtocolUnderwaterAsset = borrowMarket
1789         .totalBorrows
1790         .add(tmp.updatedBorrowBalance_TargetUnderwaterAsset)
1791         .sub(borrowBalance_TargeUnderwaterAsset.principal);
1792 
1793         tmp.currentCash_ProtocolUnderwaterAsset = getCash(assetBorrow);
1794         // address(0) represents for eth
1795         // eth has been transfered when called
1796         tmp.updatedCash_ProtocolUnderwaterAsset = assetBorrow != address(0)
1797         ? tmp.currentCash_ProtocolUnderwaterAsset.add(
1798             tmp.closeBorrowAmount_TargetUnderwaterAsset
1799         )
1800         : tmp.currentCash_ProtocolUnderwaterAsset;
1801 
1802         tmp.newSupplyIndex_UnderwaterAsset = uint256(
1803             borrowMarket.irm.pert(
1804                 int256(borrowMarket.supplyIndex),
1805                 borrowMarket.demondRate,
1806                 int256(blockDelta)
1807             )
1808         );
1809         borrowMarket.supplyRate = borrowMarket.irm.getDepositRate(
1810             int256(tmp.updatedCash_ProtocolUnderwaterAsset),
1811             int256(tmp.newTotalBorrows_ProtocolUnderwaterAsset)
1812         );
1813         borrowMarket.demondRate = borrowMarket.irm.getLoanRate(
1814             int256(tmp.updatedCash_ProtocolUnderwaterAsset),
1815             int256(tmp.newTotalBorrows_ProtocolUnderwaterAsset)
1816         );
1817         tmp.newBorrowIndex_CollateralAsset = uint256(
1818             collateralMarket.irm.pert(
1819                 int256(collateralMarket.supplyIndex),
1820                 collateralMarket.demondRate,
1821                 int256(blockDelta)
1822             )
1823         );
1824 
1825         // Update the balance of liquidator and borrower
1826         tmp.updatedSupplyBalance_TargetCollateralAsset = tmp
1827         .currentSupplyBalance_TargetCollateralAsset
1828         .sub(tmp.seizeSupplyAmount_TargetCollateralAsset);
1829         tmp.updatedSupplyBalance_LiquidatorCollateralAsset = tmp
1830         .currentSupplyBalance_LiquidatorCollateralAsset
1831         .add(tmp.seizeSupplyAmount_TargetCollateralAsset);
1832 
1833         borrowMarket.accrualBlockNumber = now;
1834         borrowMarket.totalBorrows = tmp.newTotalBorrows_ProtocolUnderwaterAsset;
1835         borrowMarket.supplyIndex = tmp.newSupplyIndex_UnderwaterAsset;
1836         borrowMarket.borrowIndex = tmp.newBorrowIndex_UnderwaterAsset;
1837         // mkts[assetBorrow] = borrowMarket;
1838         collateralMarket.accrualBlockNumber = now;
1839         collateralMarket.totalSupply = tmp
1840         .newTotalSupply_ProtocolCollateralAsset;
1841         collateralMarket.supplyIndex = tmp.newSupplyIndex_CollateralAsset;
1842         collateralMarket.borrowIndex = tmp.newBorrowIndex_CollateralAsset;
1843         // mkts[assetCollateral] = collateralMarket;
1844         tmp.startingBorrowBalance_TargetUnderwaterAsset = borrowBalance_TargeUnderwaterAsset
1845         .principal; // save for use in event
1846         borrowBalance_TargeUnderwaterAsset.principal = tmp
1847         .updatedBorrowBalance_TargetUnderwaterAsset;
1848         borrowBalance_TargeUnderwaterAsset.interestIndex = tmp
1849         .newBorrowIndex_UnderwaterAsset;
1850 
1851         tmp.startingSupplyBalance_TargetCollateralAsset = supplyBalance_TargetCollateralAsset
1852         .principal; // save for use in event
1853         supplyBalance_TargetCollateralAsset.principal = tmp
1854         .updatedSupplyBalance_TargetCollateralAsset;
1855         supplyBalance_TargetCollateralAsset.interestIndex = tmp
1856         .newSupplyIndex_CollateralAsset;
1857 
1858         tmp.startingSupplyBalance_LiquidatorCollateralAsset = supplyBalance_LiquidatorCollateralAsset
1859         .principal; // save for use in event
1860         supplyBalance_LiquidatorCollateralAsset.principal = tmp
1861         .updatedSupplyBalance_LiquidatorCollateralAsset;
1862         supplyBalance_LiquidatorCollateralAsset.interestIndex = tmp
1863         .newSupplyIndex_CollateralAsset;
1864 
1865         setLiquidateInfoMap(
1866             tmp.targetAccount,
1867             tmp.liquidator,
1868             tmp.assetCollateral,
1869             assetBorrow,
1870             tmp.seizeSupplyAmount_TargetCollateralAsset,
1871             tmp.closeBorrowAmount_TargetUnderwaterAsset
1872         );
1873 
1874         safeTransferFrom(
1875             assetBorrow,
1876             tmp.liquidator.makePayable(),
1877             address(this),
1878             address(this).makePayable(),
1879             tmp.closeBorrowAmount_TargetUnderwaterAsset,
1880             msg.value
1881         );
1882 
1883         emit LiquidateBorrowPawnLog(
1884             tmp.targetAccount,
1885             assetBorrow,
1886             tmp.updatedBorrowBalance_TargetUnderwaterAsset,
1887             tmp.liquidator,
1888             tmp.assetCollateral,
1889             tmp.updatedSupplyBalance_TargetCollateralAsset
1890         );
1891     }
1892 
1893     function safeTransferFrom(
1894         address token,
1895         address payable owner,
1896         address spender,
1897         address payable to,
1898         uint256 amount,
1899         uint256 msgValue
1900     ) internal {
1901         require(amount != 0, "invalid safeTransferFrom amount");
1902         if (owner != spender && token != address(0)) {
1903             // transfer in ERC20
1904             require(
1905                 IERC20(token).allowance(owner, spender) >= amount,
1906                 "Insufficient allowance"
1907             );
1908         }
1909         if (token != address(0)) {
1910             require(
1911                 IERC20(token).balanceOf(owner) >= amount,
1912                 "Insufficient balance"
1913             );
1914         } else if (owner == spender) {
1915             // eth， owner == spender represents for transfer out, requires enough balance
1916             require(owner.balance >= amount, "Insufficient eth balance");
1917         }
1918 
1919         if (owner != spender) {
1920             // transfer in
1921             if (token != address(0)) {
1922                 // transferFrom ERC20
1923                 IERC20(token).safeTransferFrom(owner, to, amount);
1924             } else if (msgValue != 0 && msgValue > amount) {
1925                 // return the extra eth to user
1926                 owner.transfer(msgValue.sub(amount));
1927             }
1928             // eth has been transfered when called using msg.value
1929         } else {
1930             // transfer out
1931             if (token != address(0)) {
1932                 // ERC20
1933                 IERC20(token).safeTransfer(to, amount);
1934             } else {
1935                 // 参数设置， msgValue 大于0，即还款或清算逻辑，实际还的钱大于需要还的钱，需要返回多余的钱
1936                 // msgValue 等于 0，借钱或取钱逻辑，直接转出 amount 数量的币
1937 
1938                 // msgValue greater than 0 represents for repay or liquidate,
1939                 // which means we should give back the extra eth to user
1940                 // msgValue equals to 0 represents for withdraw or borrow
1941                 // just take the wanted money
1942                 if (msgValue != 0 && msgValue > amount) {
1943                     to.transfer(msgValue.sub(amount));
1944                 } else {
1945                     to.transfer(amount);
1946                 }
1947             }
1948         }
1949     }
1950 
1951     // admin transfers profit out
1952     function withdrawPawnEquity(address t, uint256 amount)
1953     external
1954     nonReentrant
1955     onlyAdmin
1956     {
1957         uint256 cash = getCash(t);
1958         uint256 equity = cash.add(mkts[t].totalBorrows).sub(
1959             mkts[t].totalSupply
1960         );
1961         require(equity >= amount, "insufficient equity amount");
1962         safeTransferFrom(
1963             t,
1964             address(this).makePayable(),
1965             address(this),
1966             admin.makePayable(),
1967             amount,
1968             0
1969         );
1970         emit WithdrawPawnEquityLog(t, equity, amount, admin);
1971     }
1972 }