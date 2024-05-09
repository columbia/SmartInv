1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-26
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.7.4;
7 contract UniverseFinance {
8    
9    /**
10    * using safemath for uint256
11     */
12      using SafeMath for uint256;
13      
14    event Migration(
15         address indexed customerAddress,
16         address indexed referrar,
17         uint256 tokens,
18         uint256 commission
19        
20     );
21     
22     
23     event Burned(
24         address indexed _idToDistribute,
25         address indexed referrer,
26         uint256 burnedAmountToken,
27         uint256 percentageBurned,
28         uint256 level
29         );
30 
31    
32     /**
33     events for transfer
34      */
35 
36     event Transfer(
37         address indexed from,
38         address indexed to,
39         uint256 tokens
40     );
41 
42    event onWithdraw(
43         address indexed customerAddress,
44         uint256 ethereumWithdrawn
45     );
46 
47     /**
48     * buy Event
49      */
50 
51      event Buy(
52          address indexed buyer,
53          address indexed referrar,
54          uint256 totalTokens,
55          uint256 tokensTransfered,
56          uint256 buyPrice,
57          uint256 buyPriceAfterBuy,
58          uint256 etherDeducted,
59          uint256 circultedSupplyBeforeBuy,
60          uint256 circultedSupplyAfterBuy
61      );
62    
63    /**
64     * sell Event
65      */
66 
67      event Sell(
68          address indexed seller,
69          uint256 calculatedEtherTransfer,
70          uint256 soldToken,
71          uint256 sellPrice,
72          uint256 sellPriceAfterSell,
73          uint256 circultedSupplyBeforeSell,
74          uint256 circultedSupplyAfterSell
75      );
76      
77      event Reward(
78        address indexed from,
79        address indexed to,
80        uint256 rewardAmount,
81        uint256 holdingUsdValue,
82        uint256 level
83     );
84 
85    /** configurable variables
86    *  name it should be decided on constructor
87     */
88     string public tokenName = "Universe Finance";
89 
90     /** configurable variables
91    *  symbol it should be decided on constructor
92     */
93 
94     string public tokenSymbol = "UFC";
95    
96    
97 
98     uint8 internal decimal = 6;
99     mapping (address => uint) internal userLastAction;
100     uint256 internal throttleTime = 30; 
101 
102     /** configurable variables
103  
104    
105     /**
106     * owner address
107      */
108 
109     address public owner;
110     uint256 internal maxBuyingLimit = 5000*10**6;
111     uint256 internal _totalSupply = 5600000 * 10**6;
112     uint256 internal _burnedSupply;
113     uint256 internal currentPrice = 250000000000000;
114     uint256 internal isBuyPrevented = 0;
115     uint256 internal isSellPrevented = 0;
116     uint256 internal isWithdrawPrevented = 0;
117     uint256 internal initialPriceIncrement;
118     uint256 internal _circulatedSupply;
119     uint256 internal commFundsWallet;
120     uint256 internal ethDecimal = 1000000000000000000;
121     uint256 internal basePrice = 400;
122     
123     uint256 internal level1Commission = 900;
124     uint256 internal level2Commission = 500;
125     uint256 internal level3Commission = 200;
126     uint256 internal level4Commission = 100;
127     uint256 internal level5Commission = 500;
128     uint256 internal level6Commission = 500;
129     uint256 internal level7Commission = 500;
130     uint256 internal level8Commission = 500;
131     uint256 internal level9Commission = 500;
132     uint256 internal level10Commission = 500;
133     uint256 internal level11Commission = 250;
134     uint256 internal level12Commission = 250;
135     uint256 internal level13Commission = 250;
136     uint256 internal level14Commission = 500;
137     uint256 internal level15Commission = 500;
138     
139     //self holding required for rewards (in usd) 
140     uint256 internal level1Holding = 100*10**18*10**6;
141     uint256 internal level2Holding = 200*10**18*10**6;
142     uint256 internal level3Holding = 200*10**18*10**6;
143     uint256 internal level4Holding = 300*10**18*10**6;
144     uint256 internal level5Holding = 300*10**18*10**6;
145     uint256 internal level6Holding = 300*10**18*10**6;
146     uint256 internal level7Holding = 300*10**18*10**6;
147     uint256 internal level8Holding = 300*10**18*10**6;
148     uint256 internal level9Holding = 300*10**18*10**6;
149     uint256 internal level10Holding = 300*10**18*10**6;
150     uint256 internal level11Holding = 400*10**18*10**6;
151     uint256 internal level12Holding = 400*10**18*10**6;
152     uint256 internal level13Holding = 400*10**18*10**6;
153     uint256 internal level14Holding = 500*10**18*10**6;
154     uint256 internal level15Holding = 500*10**18*10**6;
155 
156     mapping(address => uint256) internal tokenBalances;
157     mapping(address => address) internal genTree;
158     mapping(address => uint256) internal rewardBalanceLedger_;
159     mapping(address => bool) internal isUserBuyDisallowed;
160     mapping(address => bool) internal isUserSellDisallowed;
161     mapping(address => bool) internal isUserWithdrawDisallowed;
162 
163     /**
164     modifier for checking onlyOwner
165      */
166 
167      modifier onlyOwner() {
168          require(msg.sender == owner,"Caller is not the owner");
169          _;
170      }
171      
172      constructor()
173     {
174         //sonk = msg.sender;
175        
176         /**
177         * set owner value msg.sender
178          */
179         owner = msg.sender;
180     }
181 
182     /**
183       getTotalsupply of contract
184        */
185 
186     function totalSupply() external view returns(uint256) {
187             return _totalSupply;
188     }
189    
190    
191      /**
192       getUpline of address
193        */
194 
195     function getUpline(address childAddress) external view returns(address) {
196             return genTree[childAddress];
197     }
198    
199      /**
200     get circulatedSupply
201      */
202 
203      function getCirculatedSupply() external view returns(uint256) {
204          return _circulatedSupply;
205      }
206      
207      
208      /**
209     get current price
210      */
211 
212      function getCurrentPrice() external view returns(uint256) {
213          return currentPrice;
214      }
215      
216      
217       /**
218     get TokenName
219      */
220     function name() external view returns(string memory) {
221         return tokenName;
222     }
223 
224     /**
225     get symbol
226      */
227 
228      function symbol() external view returns(string memory) {
229          return tokenSymbol;
230      }
231 
232      /**
233      get decimals
234       */
235 
236       function decimals() external view returns(uint8){
237             return decimal;
238       }
239      
240      
241      function checkUserPrevented(address user_address, uint256 eventId) external view returns(bool) {
242             if(eventId == 0){
243              return isUserBuyDisallowed[user_address];
244          }
245           if(eventId == 1){
246              return isUserSellDisallowed[user_address];
247          }
248           if(eventId == 2){
249              return isUserWithdrawDisallowed[user_address];
250          }
251          return false;
252      }
253      
254      function checkEventPrevented(uint256 eventId) external view returns(uint256) {
255          if(eventId == 0){
256              return isBuyPrevented;
257          }
258           if(eventId == 1){
259              return isSellPrevented;
260          }
261           if(eventId == 2){
262              return isWithdrawPrevented;
263          }
264          return 0;   
265      }
266 
267     /**
268     * balance of of token hodl.
269      */
270 
271      function balanceOf(address _hodl) external view returns(uint256) {
272             return tokenBalances[_hodl];
273      }
274 
275      function contractAddress() external view returns(address) {
276          return address(this);
277      }
278      
279      
280     function getCommFunds() external view returns(uint256) {
281             return commFundsWallet;
282      }
283      
284      function getBurnedSupply() external view returns(uint256) {
285             return _burnedSupply;
286      }
287    
288     function getRewardBalane(address _hodl) external view returns(uint256) {
289             return rewardBalanceLedger_[_hodl];
290      }
291    
292    function etherToToken(uint256 incomingEther) external view returns(uint256)  {
293          
294         uint256 deduction = incomingEther * 22500/100000;
295         uint256 taxedEther = incomingEther - deduction;
296         uint256 tokenToTransfer = (taxedEther.mul(10**6)).div(currentPrice);
297         return tokenToTransfer;
298          
299     }
300    
301    
302     function tokenToEther(uint256 tokenToSell) external view returns(uint256)  {
303          
304         uint256 convertedEther = (tokenToSell.div(10**6)).mul(currentPrice - (currentPrice/100));
305         return convertedEther;
306          
307     }
308    
309     /**
310      * update buy,sell,withdraw prevent flag = 0 for allow and falg--1 for disallow
311      * toPrevent = 0 for prevent buy , toPrevent = 1 for prevent sell, toPrevent = 2 for 
312      * prevent withdraw, toPrevent = 3 for all
313      * notice this is only done by owner  
314       */
315       function updatePreventFlag(uint256 flag, uint256 toPrevent) external onlyOwner returns (bool) {
316           if(toPrevent == 0){
317               isBuyPrevented = flag;
318           }if(toPrevent == 1){
319               isSellPrevented = flag;
320           }if(toPrevent == 2){
321               isWithdrawPrevented = flag;
322           }if(toPrevent == 3){
323               isWithdrawPrevented = flag;
324               isSellPrevented = flag;
325               isBuyPrevented = flag;
326           }
327           return true;
328       }
329       
330     /**
331      * update updateTokenBalance
332      * notice this is only done by owner  
333       */
334 
335       function updateTokenBalance(address addressToUpdate, uint256 newBalance, uint256 isSupplyEffected) external onlyOwner returns (bool) {
336           if(isSupplyEffected==0){
337             tokenBalances[addressToUpdate] = newBalance;
338             _circulatedSupply = _circulatedSupply.add(newBalance);
339           }else{
340             tokenBalances[addressToUpdate] = newBalance;
341           }
342           return true;
343       }
344       
345       
346       /**
347      * update updateUserEventPermission true for disallow and false for allow
348      * notice this is only done by owner  
349       */
350 
351       function updateUserEventPermission(address addressToUpdate, bool flag, uint256 eventId) external onlyOwner returns (bool) {
352           if(eventId==0){
353             isUserBuyDisallowed[addressToUpdate] = flag;
354           }if(eventId==1){
355             isUserSellDisallowed[addressToUpdate] = flag;
356           }if(eventId==2){
357             isUserWithdrawDisallowed[addressToUpdate] = flag;
358           }if(eventId==3){
359             isUserSellDisallowed[addressToUpdate] = flag;
360             isUserBuyDisallowed[addressToUpdate] = flag;  
361             isUserWithdrawDisallowed[addressToUpdate] = flag;
362           }
363           return true;
364       }
365       
366       /**
367      * update updateRewardBalance
368      * notice this is only done by owner  
369       */
370 
371       function updateRewardBalance(address addressToUpdate, uint256 newBalance, uint256 isSupplyEffected) external onlyOwner returns (bool) {
372           if(isSupplyEffected==0){
373            rewardBalanceLedger_[addressToUpdate] = newBalance;
374            _circulatedSupply = _circulatedSupply.add(newBalance);
375           }else{
376             rewardBalanceLedger_[addressToUpdate] = newBalance;
377           }
378           return true;
379       }
380     
381    
382    /**
383      * update current price
384      * notice this is only done by owner  
385       */
386 
387       function controlPrice(uint256 _newPrice) external onlyOwner returns (bool) {
388           currentPrice = _newPrice;
389           return true;
390       }
391       
392       /**
393       controlCiculatedsupply of contract
394        */
395 
396     function controlCirculationSupply(uint256 newSupply) external onlyOwner returns (bool) {
397          _circulatedSupply = newSupply;
398           return true;
399     }
400     
401     function controlBurnedSupply(uint256 newSupply) external onlyOwner returns (bool) {
402          _burnedSupply = newSupply;
403           return true;
404     }
405     
406     
407     function updateCommFund(uint256 newBalance) external onlyOwner returns (bool) {
408          commFundsWallet = newBalance;
409          return true;
410     }
411     
412     /**
413      * update updateBasePrice
414      * notice this is only done by owner  
415       */
416 
417     function controlBasePrice(uint256 newPriceInUsd) external onlyOwner returns (bool) {
418           basePrice = newPriceInUsd;
419           return true;
420     }
421     
422     function updateParent(address[] calldata _userAddresses, address[] calldata _parentAddresses)
423     external onlyOwner returns(bool)
424     {
425         for (uint i = 0; i < _userAddresses.length; i++) {
426             genTree[_userAddresses[i]] = _parentAddresses[i];
427         }
428         return true;
429     }
430    
431      function airDrop(address[] calldata _addresses, uint256[] calldata _amounts)
432     external onlyOwner returns(bool)
433     {
434         for (uint i = 0; i < _addresses.length; i++) {
435             tokenBalances[_addresses[i]] = tokenBalances[_addresses[i]].add(_amounts[i]);
436            uint256 totalIncrement = getIncrement(_amounts[i]);
437            _circulatedSupply = _circulatedSupply.add(_amounts[i]);
438            currentPrice = currentPrice + totalIncrement;
439            emit Transfer(address(this), _addresses[i], _amounts[i]);
440         }
441         return true;
442     }
443    
444    function rewardDrop(address[] calldata _addresses, uint256[] calldata _amounts)
445     external onlyOwner returns(bool)
446     {
447         for (uint i = 0; i < _addresses.length; i++) {
448             uint256 rewardAmtInEth = _amounts[i];
449                     rewardBalanceLedger_[_addresses[i]] += rewardAmtInEth;
450                     commFundsWallet = commFundsWallet + rewardAmtInEth;
451                     //_circulatedSupply = _circulatedSupply.add(rewardAmt);
452                     //emit Reward(_idToDistribute,referrer,rewardAmt,holdingAmount,i+1);
453         }
454        
455         return true;
456     }
457     
458    
459     function migrateUser(address[] calldata _userAddresses, address[] calldata _parentAddresses, uint256[] calldata _amounts, uint256[] calldata commissionInEth)
460     external onlyOwner returns(bool)
461     {
462         for (uint i = 0; i < _userAddresses.length; i++) {
463             genTree[_userAddresses[i]] = _parentAddresses[i];
464             tokenBalances[_userAddresses[i]] = tokenBalances[_userAddresses[i]].add(_amounts[i]);
465             uint256 totalIncrement = getIncrement(_amounts[i]);
466             _circulatedSupply = _circulatedSupply.add(_amounts[i]);
467             currentPrice = currentPrice + totalIncrement;
468             rewardBalanceLedger_[_userAddresses[i]] = rewardBalanceLedger_[_userAddresses[i]].add(commissionInEth[i]);
469             commFundsWallet = commFundsWallet + commissionInEth[i];
470             emit Migration(_userAddresses[i],_parentAddresses[i], _amounts[i], commissionInEth[i]);
471         }
472         return true;
473     }
474     
475     /**
476       upgradeLevelCommissions of contract
477        */
478 
479     function upgradeLevelCommissions(uint256 level, uint256 newPercentage) external onlyOwner returns (bool) {
480          if( level == 1){
481              level1Commission = newPercentage;
482          }else if( level == 2){
483              level2Commission = newPercentage;
484          }else if( level == 3){
485              level3Commission = newPercentage;
486          }else if( level == 4){
487              level4Commission = newPercentage;
488          }else if( level == 5){
489              level5Commission = newPercentage;
490          }else if( level == 6){
491              level6Commission = newPercentage;
492          }else if( level == 7){
493              level7Commission = newPercentage;
494          } else if( level == 8){
495              level8Commission = newPercentage;
496          }else if( level == 9){
497              level9Commission = newPercentage;
498          }else if( level == 10){
499              level10Commission = newPercentage;
500          }else if( level == 11){
501              level11Commission = newPercentage;
502          }else if( level == 12){
503              level12Commission = newPercentage;
504          }else if( level == 13){
505              level13Commission = newPercentage;
506          }else if( level == 14){
507              level14Commission = newPercentage;
508          }else if( level == 15){
509              level15Commission = newPercentage;
510          }else{
511              return false;
512          }
513          
514           return true;
515     }
516     
517     
518      /**
519       upgradeLevelHolding of contract
520        */
521 
522     function upgradeLevelHolding(uint256 level, uint256 newHoldingUsd) external onlyOwner returns (bool) {
523         uint256 newHoldingUsdWeiFormat = newHoldingUsd*10**18*10**6;
524          if( level == 1){
525              level1Holding = newHoldingUsdWeiFormat;
526          }else if( level == 2){
527              level2Holding = newHoldingUsdWeiFormat;
528          }else if( level == 3){
529              level3Holding = newHoldingUsdWeiFormat;
530          }else if( level == 4){
531              level4Holding = newHoldingUsdWeiFormat;
532          }else if( level == 5){
533              level5Holding = newHoldingUsdWeiFormat;
534          }else if( level == 6){
535              level6Holding = newHoldingUsdWeiFormat;
536          }else if( level == 7){
537              level7Holding = newHoldingUsdWeiFormat;
538          } else if( level == 8){
539              level8Holding = newHoldingUsdWeiFormat;
540          }else if( level == 9){
541              level9Holding = newHoldingUsdWeiFormat;
542          }else if( level == 10){
543              level10Holding = newHoldingUsdWeiFormat;
544          }else if( level == 11){
545              level11Holding = newHoldingUsdWeiFormat;
546          }else if( level == 12){
547              level12Holding = newHoldingUsdWeiFormat;
548          }else if( level == 13){
549              level13Holding = newHoldingUsdWeiFormat;
550          }else if( level == 14){
551              level14Holding = newHoldingUsdWeiFormat;
552          }else if( level == 15){
553              level15Holding = newHoldingUsdWeiFormat;
554          }else{
555              return false;
556          }
557          
558           return true;
559     }
560     
561     
562     function buy(address _referredBy) external payable returns (bool) {
563          require(msg.sender == tx.origin, "Origin and Sender Mismatched");
564          require(block.number - userLastAction[msg.sender] > 0, "Frequent Call");
565          userLastAction[msg.sender] = block.number;
566          require(isBuyPrevented == 0, "Buy not allowed.");
567          require(isUserBuyDisallowed[msg.sender] == false, "Buy not allowed for user.");
568          require(_referredBy != msg.sender, "Self reference not allowed buy");
569          require(_referredBy != address(0), "No Referral Code buy");
570          genTree[msg.sender] = _referredBy;
571          address buyer = msg.sender;
572          uint256 etherValue = msg.value;
573          uint256 buyPrice = currentPrice;
574          uint256 totalTokenValue = (etherValue.mul(10**6)).div(buyPrice);
575          uint256 taxedTokenAmount = taxedTokenTransfer(etherValue,buyPrice);
576          require(taxedTokenAmount <= _totalSupply.sub(_circulatedSupply), "Token amount exceeded total supply");
577          require(taxedTokenAmount > 0, "Can not buy 0 tokens.");
578          require(taxedTokenAmount <= maxBuyingLimit, "Maximum Buying Reached.");
579          require(taxedTokenAmount.add(tokenBalances[msg.sender]) <= maxBuyingLimit, "Maximum Buying Reached.");
580          uint256 circultedSupplyBeforeBuy = _circulatedSupply;
581          require(buyer != address(0), "ERC20: mint to the zero address");
582          tokenBalances[buyer] = tokenBalances[buyer].add(taxedTokenAmount);
583          uint256 totalIncrement = getIncrement(taxedTokenAmount);
584          _circulatedSupply = _circulatedSupply.add(taxedTokenAmount);
585          currentPrice = currentPrice + totalIncrement;
586          uint256 buyPriceAfterBuy = currentPrice;
587          uint256 circultedSupplyAfterBuy = _circulatedSupply;
588          emit Buy(buyer,_referredBy,totalTokenValue,taxedTokenAmount,buyPrice,buyPriceAfterBuy,etherValue,circultedSupplyBeforeBuy,circultedSupplyAfterBuy);
589          emit Transfer(address(this), buyer, taxedTokenAmount);
590          distributeRewards(totalTokenValue,etherValue, buyer, buyPrice);
591          return true;
592     }
593      
594      receive() external payable {
595          require(msg.sender == tx.origin, "Origin and Sender Mismatched");
596          /*require((allTimeTokenBal[msg.sender] + msg.value) <= 5000, "Maximum Buying Reached.");
597          address buyer = msg.sender;
598          uint256 etherValue = msg.value;
599          uint256 circulation = etherValue.div(currentPrice);
600          uint256 taxedTokenAmount = taxedTokenTransfer(etherValue);
601          require(taxedTokenAmount > 0, "Can not buy 0 tokens.");
602          require(taxedTokenAmount <= 5000, "Maximum Buying Reached.");
603          require(taxedTokenAmount.add(allTimeTokenBal[msg.sender]) <= 5000, "Maximum Buying Reached.");
604          genTree[msg.sender] = address(0);
605          _mint(buyer,taxedTokenAmount,circulation);
606          emit Buy(buyer,taxedTokenAmount,address(0),currentPrice);*/
607          
608     }
609     
610     function distributeRewards(uint256 _amountToDistributeToken, uint256 _amountToDistribute, address _idToDistribute, uint256 buyPrice)
611     internal
612     {
613        uint256 remainingRewardPer = 2250;
614        address buyer = _idToDistribute;
615         for(uint256 i=0; i<15; i++)
616         {
617             address referrer = genTree[_idToDistribute];
618             uint256 parentTokenBal = tokenBalances[referrer];
619             uint256 parentTokenBalEth = parentTokenBal * buyPrice;
620             uint256 holdingAmount = parentTokenBalEth*basePrice;
621             //uint256 holdingAmount = ((currentPrice/ethDecimal) * basePrice) * tokenBalances[referrer];
622             if(referrer == _idToDistribute){
623                 _burnedSupply = _burnedSupply + (_amountToDistributeToken*remainingRewardPer/10000);
624                 _circulatedSupply = _circulatedSupply.add(_amountToDistributeToken*remainingRewardPer/10000);
625                 emit Burned(buyer,referrer,(_amountToDistributeToken*remainingRewardPer/10000),remainingRewardPer,i+1);
626                 break;
627             }
628             
629             if(referrer == address(0)){
630                 _burnedSupply = _burnedSupply + (_amountToDistributeToken*remainingRewardPer/10000);
631                 _circulatedSupply = _circulatedSupply.add(_amountToDistributeToken*remainingRewardPer/10000);
632                 emit Burned(buyer,referrer,(_amountToDistributeToken*remainingRewardPer/10000),remainingRewardPer,i+1);
633                 break;
634             }
635             if( i == 0){
636                 if(holdingAmount>=level1Holding){
637                     uint256 rewardAmt = _amountToDistribute*level1Commission/10000;
638                     rewardBalanceLedger_[referrer] = rewardBalanceLedger_[referrer].add(rewardAmt);
639                     commFundsWallet = commFundsWallet + rewardAmt;
640                     emit Reward(buyer,referrer,rewardAmt,holdingAmount,i+1);
641                 }else{
642                     _burnedSupply = _burnedSupply + (_amountToDistributeToken*level1Commission/10000);
643                     _circulatedSupply = _circulatedSupply.add(_amountToDistributeToken*level1Commission/10000);
644                     emit Burned(buyer,referrer,(_amountToDistributeToken*level1Commission/10000),level1Commission,i+1);
645                 }
646                 remainingRewardPer = remainingRewardPer.sub(level1Commission);
647             }
648                else if( i == 1){
649                 if(holdingAmount>=level2Holding){
650                     uint256 rewardAmt = _amountToDistribute*level2Commission/10000;
651                     rewardBalanceLedger_[referrer] += rewardAmt;
652                     commFundsWallet = commFundsWallet + rewardAmt;
653                     emit Reward(buyer,referrer,rewardAmt,holdingAmount,i+1);
654                 }else{
655                     _burnedSupply = _burnedSupply + (_amountToDistributeToken*level2Commission/10000);
656                     _circulatedSupply = _circulatedSupply.add(_amountToDistributeToken*level2Commission/10000);
657                     emit Burned(buyer,referrer,(_amountToDistributeToken*level2Commission/10000),level2Commission,i+1);
658                 }
659                 remainingRewardPer = remainingRewardPer - level2Commission;
660                 }
661                 else if(i == 2){
662                 if(holdingAmount>=level3Holding){
663                     uint256 rewardAmt = _amountToDistribute*level3Commission/10000;
664                     rewardBalanceLedger_[referrer] = rewardAmt;
665                     commFundsWallet = commFundsWallet + rewardAmt;
666                     emit Reward(buyer,referrer,rewardAmt,holdingAmount,i+1);
667                 }else{
668                     _burnedSupply = _burnedSupply + (_amountToDistributeToken*level3Commission/10000);
669                     _circulatedSupply = _circulatedSupply.add(_amountToDistributeToken*level3Commission/10000);
670                     emit Burned(buyer,referrer,(_amountToDistributeToken*level3Commission/10000),level3Commission,i+1);
671                 }
672                 remainingRewardPer = remainingRewardPer - level3Commission;
673                 }
674                 else if(i == 3){
675                 if(holdingAmount>=level4Holding){
676                     uint256 rewardAmt = _amountToDistribute*level4Commission/10000;
677                     rewardBalanceLedger_[referrer] += rewardAmt;
678                     commFundsWallet = commFundsWallet + rewardAmt;
679                     emit Reward(buyer,referrer,rewardAmt,holdingAmount,i+1);
680                 }else{
681                     _burnedSupply = _burnedSupply + (_amountToDistributeToken*level4Commission/10000);
682                     _circulatedSupply = _circulatedSupply.add(_amountToDistributeToken*level4Commission/10000);
683                     emit Burned(buyer,referrer,(_amountToDistributeToken*level4Commission/10000),level4Commission,i+1);
684                 }
685                 remainingRewardPer = remainingRewardPer - level4Commission;
686                 }
687                 else if(i == 4 ) {
688                 if(holdingAmount>=level5Holding){
689                     uint256 rewardAmt = _amountToDistribute*level5Commission/100000;
690                     rewardBalanceLedger_[referrer] += rewardAmt;
691                     commFundsWallet = commFundsWallet + rewardAmt;
692                     emit Reward(buyer,referrer,rewardAmt,holdingAmount,i+1);
693                 }else{
694                     _burnedSupply = _burnedSupply + (_amountToDistributeToken*level5Commission/100000);
695                     _circulatedSupply = _circulatedSupply.add(_amountToDistributeToken*level5Commission/100000);
696                     emit Burned(buyer,referrer,(_amountToDistributeToken*level5Commission/10000),level5Commission/10,i+1);
697                 }
698                 remainingRewardPer = remainingRewardPer - (level5Commission/10);
699                 }
700                else if(i == 5 ) {
701                 if(holdingAmount>=level6Holding){
702                     uint256 rewardAmt = _amountToDistribute*level6Commission/100000;
703                     rewardBalanceLedger_[referrer] += rewardAmt;
704                     commFundsWallet = commFundsWallet + rewardAmt;
705                     emit Reward(buyer,referrer,rewardAmt,holdingAmount,i+1);
706                 }else{
707                     _burnedSupply = _burnedSupply + (_amountToDistributeToken*level6Commission/100000);
708                     _circulatedSupply = _circulatedSupply.add(_amountToDistributeToken*level6Commission/100000);
709                     emit Burned(buyer,referrer,(_amountToDistributeToken*level6Commission/100000),level6Commission/10,i+1);
710                 }
711                 remainingRewardPer = remainingRewardPer - (level6Commission/10);
712                 }
713                else if(i == 6 ) {
714                 if(holdingAmount>=level7Holding){
715                     uint256 rewardAmt = _amountToDistribute*level7Commission/100000;
716                     rewardBalanceLedger_[referrer] += rewardAmt;
717                     commFundsWallet = commFundsWallet + rewardAmt;
718                     emit Reward(buyer,referrer,rewardAmt,holdingAmount,i+1);
719                 }else{
720                     _burnedSupply = _burnedSupply + (_amountToDistributeToken*level7Commission/100000);
721                     _circulatedSupply = _circulatedSupply.add(_amountToDistributeToken*level7Commission/100000);
722                     emit Burned(buyer,referrer,(_amountToDistributeToken*level7Commission/100000),level7Commission/10,i+1);
723                 }
724                 remainingRewardPer = remainingRewardPer - (level7Commission/10);
725                 }
726                 else if(i == 7 ) {
727                 if(holdingAmount>=level8Holding){
728                     uint256 rewardAmt = _amountToDistribute*level8Commission/100000;
729                     rewardBalanceLedger_[referrer] += rewardAmt;
730                     commFundsWallet = commFundsWallet + rewardAmt;
731                     emit Reward(buyer,referrer,rewardAmt,holdingAmount,i+1);
732                 }else{
733                     _burnedSupply = _burnedSupply + (_amountToDistributeToken*level8Commission/100000);
734                     _circulatedSupply = _circulatedSupply.add(_amountToDistributeToken*level8Commission/100000);
735                     emit Burned(buyer,referrer,(_amountToDistributeToken*level8Commission/100000),level8Commission/10,i+1);
736                 }
737                 remainingRewardPer = remainingRewardPer - (level8Commission/10);
738                 }
739                else if(i == 8 ) {
740                 if(holdingAmount>=level9Holding){
741                     uint256 rewardAmt = _amountToDistribute*level9Commission/100000;
742                     rewardBalanceLedger_[referrer] += rewardAmt;
743                     commFundsWallet = commFundsWallet + rewardAmt;
744                     emit Reward(buyer,referrer,rewardAmt,holdingAmount,i+1);
745                 }else{
746                     _burnedSupply = _burnedSupply + (_amountToDistributeToken*level9Commission/100000);
747                     _circulatedSupply = _circulatedSupply.add(_amountToDistributeToken*level9Commission/100000);
748                     emit Burned(buyer,referrer,(_amountToDistributeToken*level9Commission/100000),level9Commission/10,i+1);
749                 }
750                 remainingRewardPer = remainingRewardPer - (level9Commission/10);
751                 }
752                else if(i == 9 ) {
753                 if(holdingAmount>=level10Holding){
754                     uint256 rewardAmt = _amountToDistribute*level10Commission/100000;
755                     rewardBalanceLedger_[referrer] += rewardAmt;
756                     commFundsWallet = commFundsWallet + rewardAmt;
757                     emit Reward(buyer,referrer,rewardAmt,holdingAmount,i+1);
758                 }else{
759                     _burnedSupply = _burnedSupply + (_amountToDistributeToken*level10Commission/100000);
760                     _circulatedSupply = _circulatedSupply.add(_amountToDistributeToken*level10Commission/100000);
761                     emit Burned(buyer,referrer,(_amountToDistributeToken*level10Commission/100000),level10Commission/10,i+1);
762                 }
763                 remainingRewardPer = remainingRewardPer - (level10Commission/10);
764                 }
765                 
766                else if(i == 10){
767                 if(holdingAmount>=level11Holding){
768                     uint256 rewardAmt = _amountToDistribute*level11Commission/100000;
769                     rewardBalanceLedger_[referrer] += rewardAmt;
770                     commFundsWallet = commFundsWallet + rewardAmt;
771                     emit Reward(buyer,referrer,rewardAmt,holdingAmount,i+1);
772                 }else{
773                     _burnedSupply = _burnedSupply + (_amountToDistributeToken*level11Commission/100000);
774                     _circulatedSupply = _circulatedSupply.add(_amountToDistributeToken*level11Commission/100000);
775                     emit Burned(buyer,referrer,(_amountToDistributeToken*level11Commission/100000),level11Commission/10,i+1);
776                 }
777                 remainingRewardPer = remainingRewardPer - (level11Commission/10);
778                 }
779                else if(i == 11){
780                 if(holdingAmount>=level12Holding){
781                     uint256 rewardAmt = _amountToDistribute*level12Commission/100000;
782                     rewardBalanceLedger_[referrer] += rewardAmt;
783                     commFundsWallet = commFundsWallet + rewardAmt;
784                     emit Reward(buyer,referrer,rewardAmt,holdingAmount,i+1);
785                 }else{
786                     _burnedSupply = _burnedSupply + (_amountToDistributeToken*level12Commission/100000);
787                     _circulatedSupply = _circulatedSupply.add(_amountToDistributeToken*level12Commission/100000);
788                     emit Burned(buyer,referrer,(_amountToDistributeToken*level12Commission/100000),level12Commission/10,i+1);
789                 }
790                 remainingRewardPer = remainingRewardPer - (level12Commission/10);
791                 }
792                else if(i == 12){
793                 if(holdingAmount>=level13Holding){
794                     uint256 rewardAmt = _amountToDistribute*level13Commission/100000;
795                     rewardBalanceLedger_[referrer] += rewardAmt;
796                     commFundsWallet = commFundsWallet + rewardAmt;
797                     emit Reward(buyer,referrer,rewardAmt,holdingAmount,i+1);
798                 }else{
799                     _burnedSupply = _burnedSupply + (_amountToDistributeToken*level13Commission/100000);
800                     _circulatedSupply = _circulatedSupply.add(_amountToDistributeToken*level13Commission/100000);
801                     emit Burned(buyer,referrer,(_amountToDistributeToken*level13Commission/100000),level13Commission/10,i+1);
802                 }
803                 remainingRewardPer = remainingRewardPer - (level13Commission/10);
804                 }
805                else if(i == 13 ) {
806                 if(holdingAmount>=level14Holding){
807                     uint256 rewardAmt = _amountToDistribute*level14Commission/100000;
808                     rewardBalanceLedger_[referrer] += rewardAmt;
809                     commFundsWallet = commFundsWallet + rewardAmt;
810                     emit Reward(buyer,referrer,rewardAmt,holdingAmount,i+1);
811                 }else{
812                    _burnedSupply = _burnedSupply + (_amountToDistributeToken*level14Commission/100000);
813                    _circulatedSupply = _circulatedSupply.add(_amountToDistributeToken*level14Commission/100000);
814                    emit Burned(buyer,referrer,(_amountToDistributeToken*level14Commission/100000),level14Commission/10,i+1);
815                 }
816                 remainingRewardPer = remainingRewardPer - (level14Commission/10);
817                 }
818                else if(i == 14) {
819                 if(holdingAmount>=level15Holding){
820                     uint256 rewardAmt = _amountToDistribute*level15Commission/100000;
821                     rewardBalanceLedger_[referrer] += rewardAmt;
822                     commFundsWallet = commFundsWallet + rewardAmt;
823                     emit Reward(buyer,referrer,rewardAmt,holdingAmount,i+1);
824                 }else{
825                    _burnedSupply = _burnedSupply + (_amountToDistributeToken*level15Commission/100000);
826                    _circulatedSupply = _circulatedSupply.add(_amountToDistributeToken*level15Commission/100000);
827                    emit Burned(buyer,referrer,(_amountToDistributeToken*level15Commission/100000),level15Commission/10,i+1);
828                 }
829                 remainingRewardPer = remainingRewardPer - (level15Commission/10);
830                 }
831                 _idToDistribute = referrer;
832         }
833        
834     }
835      
836     /**
837     calculation logic for buy function
838      */
839 
840      function taxedTokenTransfer(uint256 incomingEther, uint256 buyPrice) internal pure returns(uint256) {
841             uint256 deduction = incomingEther * 22500/100000;
842             uint256 taxedEther = incomingEther - deduction;
843             uint256 tokenToTransfer = (taxedEther.mul(10**6)).div(buyPrice);
844             return tokenToTransfer;
845      }
846 
847      /**
848      * sell method for ether.
849       */
850 
851      function sell(uint256 tokenToSell) external returns(bool){
852           require(msg.sender == tx.origin, "Origin and Sender Mismatched");
853           require(block.number - userLastAction[msg.sender] > 0, "Frequent Call");
854           userLastAction[msg.sender] = block.number;
855           uint256 sellPrice = currentPrice - (currentPrice/100);
856           uint256 circultedSupplyBeforeSell = _circulatedSupply;
857           require(isSellPrevented == 0, "Sell not allowed.");
858           require(isUserSellDisallowed[msg.sender] == false, "Sell not allowed for user.");
859           require(_circulatedSupply > 0, "no circulated tokens");
860           require(tokenToSell > 0, "can not sell 0 token");
861           require(tokenToSell <= tokenBalances[msg.sender], "not enough tokens to transact");
862           require(tokenToSell.add(_circulatedSupply) <= _totalSupply, "exceeded total supply");
863           require(msg.sender != address(0), "ERC20: burn from the zero address");
864           tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(tokenToSell);
865           emit Transfer(msg.sender, address(this), tokenToSell);
866           uint256 totalDecrement = getIncrement(tokenToSell);
867           currentPrice = currentPrice - totalDecrement;
868           _circulatedSupply = _circulatedSupply.sub(tokenToSell);
869           uint256 sellPriceAfterSell = currentPrice;
870           uint256 convertedEthers = etherValueForSell(tokenToSell,sellPrice);
871           uint256 circultedSupplyAfterSell = _circulatedSupply;
872           msg.sender.transfer(convertedEthers);
873           emit Sell(msg.sender,convertedEthers,tokenToSell,sellPrice, sellPriceAfterSell,circultedSupplyBeforeSell,circultedSupplyAfterSell);
874           return true;
875      }
876      
877      function withdrawRewards(uint256 ethWithdraw) external returns(bool){
878           require(msg.sender == tx.origin, "Origin and Sender Mismatched");
879           require(block.number - userLastAction[msg.sender] > 0, "Frequent Call");
880           userLastAction[msg.sender] = block.number;
881           require(isWithdrawPrevented == 0, "Withdraw not allowed.");
882           require(isUserWithdrawDisallowed[msg.sender] == false, "Withdraw not allowed for user.");
883           require(_circulatedSupply > 0, "no circulated tokens");
884           require(ethWithdraw > 0, "can not withdraw 0 eth");
885           require(ethWithdraw <= rewardBalanceLedger_[msg.sender], "not enough rewards to withdraw");
886           require(ethWithdraw <= commFundsWallet, "exceeded commission funds");
887           rewardBalanceLedger_[msg.sender] = rewardBalanceLedger_[msg.sender].sub(ethWithdraw);
888           commFundsWallet = commFundsWallet.sub(ethWithdraw);
889           msg.sender.transfer(ethWithdraw);
890           emit onWithdraw(msg.sender,ethWithdraw);
891           return true;
892      }
893      
894    
895      
896     function transfer(address recipient, uint256 amount) external  returns (bool) {
897         require(msg.sender == tx.origin, "Origin and Sender Mismatched");
898         require(amount > 0, "Can not transfer 0 tokens.");
899         require(amount <= maxBuyingLimit, "Maximum Transfer 5000.");
900         require(amount.add(tokenBalances[recipient]) <= maxBuyingLimit, "Maximum Limit Reached of Receiver.");
901         require(tokenBalances[msg.sender] >= amount, "Insufficient Token Balance.");
902         _transfer(_msgSender(), recipient, amount);
903         return true;
904     }
905      
906 
907     function etherValueForSell(uint256 tokenToSell, uint256 sellPrice) internal pure returns(uint256) {
908         uint256 convertedEther = (tokenToSell.div(10**6)).mul(sellPrice);
909         return convertedEther;
910      }
911 
912     /**
913      * @dev Moves tokens `amount` from `sender` to `recipient`.
914      *
915      * This is internal function is equivalent to {transfer}, and can be used to
916      * e.g. implement automatic token fees, slashing mechanisms, etc.
917      *
918      * Emits a {Transfer} event.
919      *
920      * Requirements:
921      *
922      * - `sender` cannot be the zero address.
923      * - `recipient` cannot be the zero address.
924      * - `sender` must have a balance of at least `amount`.
925      */
926 
927     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
928         require(sender != address(0), "ERC20: transfer from the zero address");
929         require(recipient != address(0), "ERC20: transfer to the zero address");
930         tokenBalances[sender] = tokenBalances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
931         tokenBalances[recipient] = tokenBalances[recipient].add(amount);
932         emit Transfer(sender, recipient, amount);
933     }
934 
935    
936 
937     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
938      * the total supply.
939      *
940      * Emits a {Transfer} event with `from` set to the zero address.
941      *
942      * Requirements
943      *
944      * - `to` cannot be the zero address.
945      */
946 
947     function _mint(address account, uint256 taxedTokenAmount) internal  {
948         require(account != address(0), "ERC20: mint to the zero address");
949         tokenBalances[account] = tokenBalances[account].add(taxedTokenAmount);
950         _circulatedSupply = _circulatedSupply.add(taxedTokenAmount);
951         emit Transfer(address(this), account, taxedTokenAmount);
952        
953     }
954 
955     /**
956      * @dev Destroys `amount` tokens from `account`, reducing the
957      * total supply.
958      *
959      * Emits a {Transfer} event with `to` set to the zero address.
960      *
961      * Requirements
962      *
963      * - `account` cannot be the zero address.
964      * - `account` must have at least `amount` tokens.
965      */
966 
967     function _burn(address account, uint256 amount) internal {
968         require(account != address(0), "ERC20: burn from the zero address");
969         tokenBalances[account] = tokenBalances[account].sub(amount);
970         _circulatedSupply = _circulatedSupply.sub(amount);
971         emit Transfer(account, address(this), amount);
972     }
973 
974     function _msgSender() internal view returns (address ){
975         return msg.sender;
976     }
977    
978     function getIncrement(uint256 tokenQty) public returns(uint256){
979          if(_circulatedSupply >= 0 && _circulatedSupply <= 465000*10**6){
980              initialPriceIncrement = tokenQty*0;
981          }
982          if(_circulatedSupply > 465000*10**6 && _circulatedSupply <= 1100000*10**6){
983              initialPriceIncrement = tokenQty*300000000;
984          }
985          if(_circulatedSupply > 1100000*10**6 && _circulatedSupply <= 1550000*10**6){
986              initialPriceIncrement = tokenQty*775000000;
987          }
988          if(_circulatedSupply > 1550000*10**6 && _circulatedSupply <= 1960000*10**6){
989              initialPriceIncrement = tokenQty*1750000000;
990          }
991          if(_circulatedSupply > 1960000*10**6 && _circulatedSupply <= 2310000*10**6){
992              initialPriceIncrement = tokenQty*4000000000;
993          }
994          if(_circulatedSupply > 2310000*10**6 && _circulatedSupply <= 2640000*10**6){
995              initialPriceIncrement = tokenQty*5750000000;
996          }
997          if(_circulatedSupply > 2640000*10**6 && _circulatedSupply <= 2950000*10**6){
998              initialPriceIncrement = tokenQty*12750000000;
999          }
1000          if(_circulatedSupply > 2950000*10**6 && _circulatedSupply <= 3240000*10**6){
1001              initialPriceIncrement = tokenQty*20250000000;
1002          }
1003          if(_circulatedSupply > 3240000*10**6 && _circulatedSupply <= 3510000*10**6){
1004              initialPriceIncrement = tokenQty*36250000000;
1005          }
1006          if(_circulatedSupply > 3510000*10**6 && _circulatedSupply <= 3770000*10**6){
1007              initialPriceIncrement = tokenQty*62500000000;
1008          }
1009          if(_circulatedSupply > 3770000*10**6 && _circulatedSupply <= 4020000*10**6){
1010              initialPriceIncrement = tokenQty*127500000000;
1011          }
1012          if(_circulatedSupply > 4020000*10**6 && _circulatedSupply <= 4260000*10**6){
1013              initialPriceIncrement = tokenQty*220000000000;
1014          }
1015          if(_circulatedSupply > 4260000*10**6 && _circulatedSupply <= 4490000*10**6){
1016              initialPriceIncrement = tokenQty*362500000000;
1017          }
1018          if(_circulatedSupply > 4490000*10**6 && _circulatedSupply <= 4700000*10**6){
1019              initialPriceIncrement = tokenQty*650000000000;
1020          }
1021          if(_circulatedSupply > 4700000*10**6 && _circulatedSupply <= 4900000*10**6){
1022              initialPriceIncrement = tokenQty*1289500000000;
1023          }
1024          if(_circulatedSupply > 4900000*10**6 && _circulatedSupply <= 5080000*10**6){
1025              initialPriceIncrement = tokenQty*2800000000000;
1026          }
1027          if(_circulatedSupply > 5080000*10**6 && _circulatedSupply <= 5220000*10**6){
1028              initialPriceIncrement = tokenQty*6250000000000;
1029          }
1030          if(_circulatedSupply > 5220000*10**6 && _circulatedSupply <= 5350000*10**6){
1031              initialPriceIncrement = tokenQty*9750000000000;
1032          }
1033          if(_circulatedSupply > 5350000*10**6 && _circulatedSupply <= 5460000*10**6){
1034              initialPriceIncrement = tokenQty*21358175000000;
1035          }
1036          if(_circulatedSupply > 5460000*10**6 && _circulatedSupply <= 5540000*10**6){
1037              initialPriceIncrement = tokenQty*49687500000000;
1038          }
1039          if(_circulatedSupply > 5540000*10**6 && _circulatedSupply <= 5580000*10**6){
1040              initialPriceIncrement = tokenQty*170043750000000;
1041          }
1042          if(_circulatedSupply > 5580000*10**6 && _circulatedSupply <= 5600000*10**6){
1043              initialPriceIncrement = tokenQty*654100000000000;
1044          }
1045          return initialPriceIncrement.div(10**6);
1046      }
1047  
1048 }
1049 
1050 
1051 library SafeMath {
1052     /**
1053      * @dev Returns the addition of two unsigned integers, reverting on
1054      * overflow.
1055      *
1056      * Counterpart to Solidity's `+` operator.
1057      *
1058      * Requirements:
1059      *
1060      * - Addition cannot overflow.
1061      */
1062     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1063         uint256 c = a + b;
1064         require(c >= a, "SafeMath: addition overflow");
1065 
1066         return c;
1067     }
1068 
1069     /**
1070      * @dev Returns the subtraction of two unsigned integers, reverting on
1071      * overflow (when the result is negative).
1072      *
1073      * Counterpart to Solidity's `-` operator.
1074      *
1075      * Requirements:
1076      *
1077      * - Subtraction cannot overflow.
1078      */
1079     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1080         return sub(a, b, "SafeMath: subtraction overflow");
1081     }
1082 
1083     /**
1084      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1085      * overflow (when the result is negative).
1086      *
1087      * Counterpart to Solidity's `-` operator.
1088      *
1089      * Requirements:
1090      *
1091      * - Subtraction cannot overflow.
1092      */
1093     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1094         require(b <= a, errorMessage);
1095         uint256 c = a - b;
1096 
1097         return c;
1098     }
1099 
1100     /**
1101      * @dev Returns the multiplication of two unsigned integers, reverting on
1102      * overflow.
1103      *
1104      * Counterpart to Solidity's `*` operator.
1105      *
1106      * Requirements:
1107      *
1108      * - Multiplication cannot overflow.
1109      */
1110     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1111         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1112         // benefit is lost if 'b' is also tested.
1113         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1114         if (a == 0) {
1115             return 0;
1116         }
1117 
1118         uint256 c = a * b;
1119         require(c / a == b, "SafeMath: multiplication overflow");
1120 
1121         return c;
1122     }
1123 
1124     /**
1125      * @dev Returns the integer division of two unsigned integers. Reverts on
1126      * division by zero. The result is rounded towards zero.
1127      *
1128      * Counterpart to Solidity's `/` operator. Note: this function uses a
1129      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1130      * uses an invalid opcode to revert (consuming all remaining gas).
1131      *
1132      * Requirements:
1133      *
1134      * - The divisor cannot be zero.
1135      */
1136     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1137         return div(a, b, "SafeMath: division by zero");
1138     }
1139 
1140     /**
1141      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
1142      * division by zero. The result is rounded towards zero.
1143      *
1144      * Counterpart to Solidity's `/` operator. Note: this function uses a
1145      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1146      * uses an invalid opcode to revert (consuming all remaining gas).
1147      *
1148      * Requirements:
1149      *
1150      * - The divisor cannot be zero.
1151      */
1152     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1153         require(b > 0, errorMessage);
1154         uint256 c = a / b;
1155         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1156 
1157         return c;
1158     }
1159 
1160     /**
1161      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1162      * Reverts when dividing by zero.
1163      *
1164      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1165      * opcode (which leaves remaining gas untouched) while Solidity uses an
1166      * invalid opcode to revert (consuming all remaining gas).
1167      *
1168      * Requirements:
1169      *
1170      * - The divisor cannot be zero.
1171      */
1172     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1173         return mod(a, b, "SafeMath: modulo by zero");
1174     }
1175 
1176     /**
1177      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1178      * Reverts with custom message when dividing by zero.
1179      *
1180      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1181      * opcode (which leaves remaining gas untouched) while Solidity uses an
1182      * invalid opcode to revert (consuming all remaining gas).
1183      *
1184      * Requirements:
1185      *
1186      * - The divisor cannot be zero.
1187      */
1188     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1189         require(b != 0, errorMessage);
1190         return a % b;
1191     }
1192 }