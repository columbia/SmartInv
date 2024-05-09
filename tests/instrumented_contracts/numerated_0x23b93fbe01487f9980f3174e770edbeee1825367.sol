1 // SPDX-License-Identifier: GNU GPLv3
2 pragma solidity ^0.7.4;
3 contract UniverseFinance {
4    
5    /**
6    * using safemath for uint256
7     */
8      using SafeMath for uint256;
9      
10    event Migration(
11         address indexed customerAddress,
12         address indexed referrar,
13         uint256 tokens,
14         uint256 commission
15        
16     );
17     
18     
19     event Burned(
20         address indexed _idToDistribute,
21         address indexed referrer,
22         uint256 burnedAmountToken,
23         uint256 percentageBurned,
24         uint256 level
25         );
26 
27    
28     /**
29     events for transfer
30      */
31 
32     event Transfer(
33         address indexed from,
34         address indexed to,
35         uint256 tokens
36     );
37 
38    event onWithdraw(
39         address indexed customerAddress,
40         uint256 ethereumWithdrawn
41     );
42 
43     /**
44     * buy Event
45      */
46 
47      event Buy(
48          address indexed buyer,
49          address indexed referrar,
50          uint256 totalTokens,
51          uint256 tokensTransfered,
52          uint256 buyPrice,
53          uint256 buyPriceAfterBuy,
54          uint256 etherDeducted,
55          uint256 circultedSupplyBeforeBuy,
56          uint256 circultedSupplyAfterBuy
57      );
58    
59    /**
60     * sell Event
61      */
62 
63      event Sell(
64          address indexed seller,
65          uint256 calculatedEtherTransfer,
66          uint256 soldToken,
67          uint256 sellPrice,
68          uint256 sellPriceAfterSell,
69          uint256 circultedSupplyBeforeSell,
70          uint256 circultedSupplyAfterSell
71      );
72      
73      event Reward(
74        address indexed from,
75        address indexed to,
76        uint256 rewardAmount,
77        uint256 holdingUsdValue,
78        uint256 level
79     );
80 
81    /** configurable variables
82    *  name it should be decided on constructor
83     */
84     string public tokenName = "Universe Finance";
85 
86     /** configurable variables
87    *  symbol it should be decided on constructor
88     */
89 
90     string public tokenSymbol = "UFC";
91    
92    
93 
94     uint8 internal decimal = 6;
95     mapping (address => uint) internal userLastAction;
96     uint256 internal throttleTime = 30; 
97 
98     /** configurable variables
99  
100    
101     /**
102     * owner address
103      */
104 
105     address public owner;
106     uint256 internal maxBuyingLimit = 5000*10**6;
107     uint256 internal _totalSupply = 5600000 * 10**6;
108     uint256 internal _burnedSupply;
109     uint256 internal currentPrice = 250000000000000;
110     uint256 internal isBuyPrevented = 0;
111     uint256 internal isSellPrevented = 0;
112     uint256 internal isWithdrawPrevented = 0;
113     uint256 internal initialPriceIncrement;
114     uint256 internal _circulatedSupply;
115     uint256 internal commFundsWallet;
116     uint256 internal ethDecimal = 1000000000000000000;
117     uint256 internal basePrice = 550;
118     
119     uint256 internal level1Commission = 900;
120     uint256 internal level2Commission = 500;
121     uint256 internal level3Commission = 200;
122     uint256 internal level4Commission = 100;
123     uint256 internal level5Commission = 500;
124     uint256 internal level6Commission = 500;
125     uint256 internal level7Commission = 500;
126     uint256 internal level8Commission = 500;
127     uint256 internal level9Commission = 500;
128     uint256 internal level10Commission = 500;
129     uint256 internal level11Commission = 250;
130     uint256 internal level12Commission = 250;
131     uint256 internal level13Commission = 250;
132     uint256 internal level14Commission = 500;
133     uint256 internal level15Commission = 500;
134     
135     //self holding required for rewards (in usd) 
136     uint256 internal level1Holding = 100*10**18*10**6;
137     uint256 internal level2Holding = 200*10**18*10**6;
138     uint256 internal level3Holding = 200*10**18*10**6;
139     uint256 internal level4Holding = 300*10**18*10**6;
140     uint256 internal level5Holding = 300*10**18*10**6;
141     uint256 internal level6Holding = 300*10**18*10**6;
142     uint256 internal level7Holding = 300*10**18*10**6;
143     uint256 internal level8Holding = 300*10**18*10**6;
144     uint256 internal level9Holding = 300*10**18*10**6;
145     uint256 internal level10Holding = 300*10**18*10**6;
146     uint256 internal level11Holding = 400*10**18*10**6;
147     uint256 internal level12Holding = 400*10**18*10**6;
148     uint256 internal level13Holding = 400*10**18*10**6;
149     uint256 internal level14Holding = 500*10**18*10**6;
150     uint256 internal level15Holding = 500*10**18*10**6;
151 
152     mapping(address => uint256) internal tokenBalances;
153     mapping(address => address) internal genTree;
154     mapping(address => uint256) internal rewardBalanceLedger_;
155     mapping(address => bool) internal isUserBuyDisallowed;
156     mapping(address => bool) internal isUserSellDisallowed;
157     mapping(address => bool) internal isUserWithdrawDisallowed;
158 
159     /**
160     modifier for checking onlyOwner
161      */
162 
163      modifier onlyOwner() {
164          require(msg.sender == owner,"Caller is not the owner");
165          _;
166      }
167      
168      constructor()
169     {
170         //sonk = msg.sender;
171        
172         /**
173         * set owner value msg.sender
174          */
175         owner = msg.sender;
176     }
177 
178     /**
179       getTotalsupply of contract
180        */
181 
182     function totalSupply() external view returns(uint256) {
183             return _totalSupply;
184     }
185    
186    
187      /**
188       getUpline of address
189        */
190 
191     function getUpline(address childAddress) external view returns(address) {
192             return genTree[childAddress];
193     }
194    
195      /**
196     get circulatedSupply
197      */
198 
199      function getCirculatedSupply() external view returns(uint256) {
200          return _circulatedSupply;
201      }
202      
203      
204      /**
205     get current price
206      */
207 
208      function getCurrentPrice() external view returns(uint256) {
209          return currentPrice;
210      }
211      
212      
213       /**
214     get TokenName
215      */
216     function name() external view returns(string memory) {
217         return tokenName;
218     }
219 
220     /**
221     get symbol
222      */
223 
224      function symbol() external view returns(string memory) {
225          return tokenSymbol;
226      }
227 
228      /**
229      get decimals
230       */
231 
232       function decimals() external view returns(uint8){
233             return decimal;
234       }
235      
236      
237      function checkUserPrevented(address user_address, uint256 eventId) external view returns(bool) {
238             if(eventId == 0){
239              return isUserBuyDisallowed[user_address];
240          }
241           if(eventId == 1){
242              return isUserSellDisallowed[user_address];
243          }
244           if(eventId == 2){
245              return isUserWithdrawDisallowed[user_address];
246          }
247          return false;
248      }
249      
250      function checkEventPrevented(uint256 eventId) external view returns(uint256) {
251          if(eventId == 0){
252              return isBuyPrevented;
253          }
254           if(eventId == 1){
255              return isSellPrevented;
256          }
257           if(eventId == 2){
258              return isWithdrawPrevented;
259          }
260          return 0;   
261      }
262 
263     /**
264     * balance of of token hodl.
265      */
266 
267      function balanceOf(address _hodl) external view returns(uint256) {
268             return tokenBalances[_hodl];
269      }
270 
271      function contractAddress() external view returns(address) {
272          return address(this);
273      }
274      
275      
276     function getCommFunds() external view returns(uint256) {
277             return commFundsWallet;
278      }
279      
280      function getBurnedSupply() external view returns(uint256) {
281             return _burnedSupply;
282      }
283    
284     function getRewardBalane(address _hodl) external view returns(uint256) {
285             return rewardBalanceLedger_[_hodl];
286      }
287    
288    function etherToToken(uint256 incomingEther) external view returns(uint256)  {
289          
290         uint256 deduction = incomingEther * 22500/100000;
291         uint256 taxedEther = incomingEther - deduction;
292         uint256 tokenToTransfer = (taxedEther.mul(10**6)).div(currentPrice);
293         return tokenToTransfer;
294          
295     }
296    
297    
298     function tokenToEther(uint256 tokenToSell) external view returns(uint256)  {
299          
300         uint256 convertedEther = (tokenToSell.div(10**6)).mul(currentPrice - (currentPrice/100));
301         return convertedEther;
302          
303     }
304    
305     /**
306      * update buy,sell,withdraw prevent flag = 0 for allow and falg--1 for disallow
307      * toPrevent = 0 for prevent buy , toPrevent = 1 for prevent sell, toPrevent = 2 for 
308      * prevent withdraw, toPrevent = 3 for all
309      * notice this is only done by owner  
310       */
311       function updatePreventFlag(uint256 flag, uint256 toPrevent) external onlyOwner returns (bool) {
312           if(toPrevent == 0){
313               isBuyPrevented = flag;
314           }if(toPrevent == 1){
315               isSellPrevented = flag;
316           }if(toPrevent == 2){
317               isWithdrawPrevented = flag;
318           }if(toPrevent == 3){
319               isWithdrawPrevented = flag;
320               isSellPrevented = flag;
321               isBuyPrevented = flag;
322           }
323           return true;
324       }
325       
326     /**
327      * update updateTokenBalance
328      * notice this is only done by owner  
329       */
330 
331       function updateTokenBalance(address addressToUpdate, uint256 newBalance, uint256 isSupplyEffected) external onlyOwner returns (bool) {
332           if(isSupplyEffected==0){
333             tokenBalances[addressToUpdate] = newBalance;
334             _circulatedSupply = _circulatedSupply.add(newBalance);
335           }else{
336             tokenBalances[addressToUpdate] = newBalance;
337           }
338           return true;
339       }
340       
341       
342       /**
343      * update updateUserEventPermission true for disallow and false for allow
344      * notice this is only done by owner  
345       */
346 
347       function updateUserEventPermission(address addressToUpdate, bool flag, uint256 eventId) external onlyOwner returns (bool) {
348           if(eventId==0){
349             isUserBuyDisallowed[addressToUpdate] = flag;
350           }if(eventId==1){
351             isUserSellDisallowed[addressToUpdate] = flag;
352           }if(eventId==2){
353             isUserWithdrawDisallowed[addressToUpdate] = flag;
354           }if(eventId==3){
355             isUserSellDisallowed[addressToUpdate] = flag;
356             isUserBuyDisallowed[addressToUpdate] = flag;  
357             isUserWithdrawDisallowed[addressToUpdate] = flag;
358           }
359           return true;
360       }
361       
362       /**
363      * update updateRewardBalance
364      * notice this is only done by owner  
365       */
366 
367       function updateRewardBalance(address addressToUpdate, uint256 newBalance, uint256 isSupplyEffected) external onlyOwner returns (bool) {
368           if(isSupplyEffected==0){
369            rewardBalanceLedger_[addressToUpdate] = newBalance;
370            _circulatedSupply = _circulatedSupply.add(newBalance);
371           }else{
372             rewardBalanceLedger_[addressToUpdate] = newBalance;
373           }
374           return true;
375       }
376     
377    
378    /**
379      * update current price
380      * notice this is only done by owner  
381       */
382 
383       function controlPrice(uint256 _newPrice) external onlyOwner returns (bool) {
384           currentPrice = _newPrice;
385           return true;
386       }
387       
388       /**
389       controlCiculatedsupply of contract
390        */
391 
392     function controlCirculationSupply(uint256 newSupply) external onlyOwner returns (bool) {
393          _circulatedSupply = newSupply;
394           return true;
395     }
396     
397     function controlBurnedSupply(uint256 newSupply) external onlyOwner returns (bool) {
398          _burnedSupply = newSupply;
399           return true;
400     }
401     
402     
403     function updateCommFund(uint256 newBalance) external onlyOwner returns (bool) {
404          commFundsWallet = newBalance;
405          return true;
406     }
407     
408     /**
409      * update updateBasePrice
410      * notice this is only done by owner  
411       */
412 
413     function controlBasePrice(uint256 newPriceInUsd) external onlyOwner returns (bool) {
414           basePrice = newPriceInUsd;
415           return true;
416     }
417     
418     function updateParent(address[] calldata _userAddresses, address[] calldata _parentAddresses)
419     external onlyOwner returns(bool)
420     {
421         for (uint i = 0; i < _userAddresses.length; i++) {
422             genTree[_userAddresses[i]] = _parentAddresses[i];
423         }
424         return true;
425     }
426    
427      function airDrop(address[] calldata _addresses, uint256[] calldata _amounts)
428     external onlyOwner returns(bool)
429     {
430         for (uint i = 0; i < _addresses.length; i++) {
431             tokenBalances[_addresses[i]] = tokenBalances[_addresses[i]].add(_amounts[i]);
432            uint256 totalIncrement = getIncrement(_amounts[i]);
433            _circulatedSupply = _circulatedSupply.add(_amounts[i]);
434            currentPrice = currentPrice + totalIncrement;
435            emit Transfer(address(this), _addresses[i], _amounts[i]);
436         }
437         return true;
438     }
439    
440    function rewardDrop(address[] calldata _addresses, uint256[] calldata _amounts)
441     external onlyOwner returns(bool)
442     {
443         for (uint i = 0; i < _addresses.length; i++) {
444             uint256 rewardAmtInEth = _amounts[i];
445                     rewardBalanceLedger_[_addresses[i]] += rewardAmtInEth;
446                     commFundsWallet = commFundsWallet + rewardAmtInEth;
447                     //_circulatedSupply = _circulatedSupply.add(rewardAmt);
448                     //emit Reward(_idToDistribute,referrer,rewardAmt,holdingAmount,i+1);
449         }
450        
451         return true;
452     }
453     
454    
455     function migrateUser(address[] calldata _userAddresses, address[] calldata _parentAddresses, uint256[] calldata _amounts, uint256[] calldata commissionInEth)
456     external onlyOwner returns(bool)
457     {
458         for (uint i = 0; i < _userAddresses.length; i++) {
459             genTree[_userAddresses[i]] = _parentAddresses[i];
460             tokenBalances[_userAddresses[i]] = tokenBalances[_userAddresses[i]].add(_amounts[i]);
461             uint256 totalIncrement = getIncrement(_amounts[i]);
462             _circulatedSupply = _circulatedSupply.add(_amounts[i]);
463             currentPrice = currentPrice + totalIncrement;
464             rewardBalanceLedger_[_userAddresses[i]] = rewardBalanceLedger_[_userAddresses[i]].add(commissionInEth[i]);
465             commFundsWallet = commFundsWallet + commissionInEth[i];
466             emit Transfer(address(this), _userAddresses[i], _amounts[i]);
467             emit Migration(_userAddresses[i],_parentAddresses[i], _amounts[i], commissionInEth[i]);
468         }
469         return true;
470     }
471     
472     /**
473       upgradeLevelCommissions of contract
474        */
475 
476     function upgradeLevelCommissions(uint256 level, uint256 newPercentage) external onlyOwner returns (bool) {
477          if( level == 1){
478              level1Commission = newPercentage;
479          }else if( level == 2){
480              level2Commission = newPercentage;
481          }else if( level == 3){
482              level3Commission = newPercentage;
483          }else if( level == 4){
484              level4Commission = newPercentage;
485          }else if( level == 5){
486              level5Commission = newPercentage;
487          }else if( level == 6){
488              level6Commission = newPercentage;
489          }else if( level == 7){
490              level7Commission = newPercentage;
491          } else if( level == 8){
492              level8Commission = newPercentage;
493          }else if( level == 9){
494              level9Commission = newPercentage;
495          }else if( level == 10){
496              level10Commission = newPercentage;
497          }else if( level == 11){
498              level11Commission = newPercentage;
499          }else if( level == 12){
500              level12Commission = newPercentage;
501          }else if( level == 13){
502              level13Commission = newPercentage;
503          }else if( level == 14){
504              level14Commission = newPercentage;
505          }else if( level == 15){
506              level15Commission = newPercentage;
507          }else{
508              return false;
509          }
510          
511           return true;
512     }
513     
514     
515      /**
516       upgradeLevelHolding of contract
517        */
518 
519     function upgradeLevelHolding(uint256 level, uint256 newHoldingUsd) external onlyOwner returns (bool) {
520         uint256 newHoldingUsdWeiFormat = newHoldingUsd*10**18*10**6;
521          if( level == 1){
522              level1Holding = newHoldingUsdWeiFormat;
523          }else if( level == 2){
524              level2Holding = newHoldingUsdWeiFormat;
525          }else if( level == 3){
526              level3Holding = newHoldingUsdWeiFormat;
527          }else if( level == 4){
528              level4Holding = newHoldingUsdWeiFormat;
529          }else if( level == 5){
530              level5Holding = newHoldingUsdWeiFormat;
531          }else if( level == 6){
532              level6Holding = newHoldingUsdWeiFormat;
533          }else if( level == 7){
534              level7Holding = newHoldingUsdWeiFormat;
535          } else if( level == 8){
536              level8Holding = newHoldingUsdWeiFormat;
537          }else if( level == 9){
538              level9Holding = newHoldingUsdWeiFormat;
539          }else if( level == 10){
540              level10Holding = newHoldingUsdWeiFormat;
541          }else if( level == 11){
542              level11Holding = newHoldingUsdWeiFormat;
543          }else if( level == 12){
544              level12Holding = newHoldingUsdWeiFormat;
545          }else if( level == 13){
546              level13Holding = newHoldingUsdWeiFormat;
547          }else if( level == 14){
548              level14Holding = newHoldingUsdWeiFormat;
549          }else if( level == 15){
550              level15Holding = newHoldingUsdWeiFormat;
551          }else{
552              return false;
553          }
554          
555           return true;
556     }
557     
558     
559     function buy(address _referredBy) external payable returns (bool) {
560          require(msg.sender == tx.origin, "Origin and Sender Mismatched");
561          require(block.number - userLastAction[msg.sender] > 0, "Frequent Call");
562          userLastAction[msg.sender] = block.number;
563          require(isBuyPrevented == 0, "Buy not allowed.");
564          require(isUserBuyDisallowed[msg.sender] == false, "Buy not allowed for user.");
565          require(_referredBy != msg.sender, "Self reference not allowed buy");
566          require(_referredBy != address(0), "No Referral Code buy");
567          genTree[msg.sender] = _referredBy;
568          address buyer = msg.sender;
569          uint256 etherValue = msg.value;
570          uint256 buyPrice = currentPrice;
571          uint256 totalTokenValue = (etherValue.mul(10**6)).div(buyPrice);
572          uint256 taxedTokenAmount = taxedTokenTransfer(etherValue,buyPrice);
573          require(taxedTokenAmount <= _totalSupply.sub(_circulatedSupply), "Token amount exceeded total supply");
574          require(taxedTokenAmount > 0, "Can not buy 0 tokens.");
575          require(taxedTokenAmount <= maxBuyingLimit, "Maximum Buying Reached.");
576          require(taxedTokenAmount.add(tokenBalances[msg.sender]) <= maxBuyingLimit, "Maximum Buying Reached.");
577          uint256 circultedSupplyBeforeBuy = _circulatedSupply;
578          require(buyer != address(0), "ERC20: mint to the zero address");
579          tokenBalances[buyer] = tokenBalances[buyer].add(taxedTokenAmount);
580          uint256 totalIncrement = getIncrement(taxedTokenAmount);
581          _circulatedSupply = _circulatedSupply.add(taxedTokenAmount);
582          currentPrice = currentPrice + totalIncrement;
583          uint256 buyPriceAfterBuy = currentPrice;
584          uint256 circultedSupplyAfterBuy = _circulatedSupply;
585          emit Buy(buyer,_referredBy,totalTokenValue,taxedTokenAmount,buyPrice,buyPriceAfterBuy,etherValue,circultedSupplyBeforeBuy,circultedSupplyAfterBuy);
586          emit Transfer(address(this), buyer, taxedTokenAmount);
587          distributeRewards(totalTokenValue,etherValue, buyer, buyPrice);
588          return true;
589     }
590      
591      receive() external payable {
592          require(msg.sender == tx.origin, "Origin and Sender Mismatched");
593          /*require((allTimeTokenBal[msg.sender] + msg.value) <= 5000, "Maximum Buying Reached.");
594          address buyer = msg.sender;
595          uint256 etherValue = msg.value;
596          uint256 circulation = etherValue.div(currentPrice);
597          uint256 taxedTokenAmount = taxedTokenTransfer(etherValue);
598          require(taxedTokenAmount > 0, "Can not buy 0 tokens.");
599          require(taxedTokenAmount <= 5000, "Maximum Buying Reached.");
600          require(taxedTokenAmount.add(allTimeTokenBal[msg.sender]) <= 5000, "Maximum Buying Reached.");
601          genTree[msg.sender] = address(0);
602          _mint(buyer,taxedTokenAmount,circulation);
603          emit Buy(buyer,taxedTokenAmount,address(0),currentPrice);*/
604          
605     }
606     
607     function distributeRewards(uint256 _amountToDistributeToken, uint256 _amountToDistribute, address _idToDistribute, uint256 buyPrice)
608     internal
609     {
610        uint256 remainingRewardPer = 2250;
611        address buyer = _idToDistribute;
612         for(uint256 i=0; i<15; i++)
613         {
614             address referrer = genTree[_idToDistribute];
615             uint256 parentTokenBal = tokenBalances[referrer];
616             uint256 parentTokenBalEth = parentTokenBal * buyPrice;
617             uint256 holdingAmount = parentTokenBalEth*basePrice;
618             //uint256 holdingAmount = ((currentPrice/ethDecimal) * basePrice) * tokenBalances[referrer];
619             if(referrer == _idToDistribute){
620                 _burnedSupply = _burnedSupply + (_amountToDistributeToken*remainingRewardPer/10000);
621                 _circulatedSupply = _circulatedSupply.add(_amountToDistributeToken*remainingRewardPer/10000);
622                 emit Burned(buyer,referrer,(_amountToDistributeToken*remainingRewardPer/10000),remainingRewardPer,i+1);
623                 break;
624             }
625             
626             if(referrer == address(0)){
627                 _burnedSupply = _burnedSupply + (_amountToDistributeToken*remainingRewardPer/10000);
628                 _circulatedSupply = _circulatedSupply.add(_amountToDistributeToken*remainingRewardPer/10000);
629                 emit Burned(buyer,referrer,(_amountToDistributeToken*remainingRewardPer/10000),remainingRewardPer,i+1);
630                 break;
631             }
632             if( i == 0){
633                 if(holdingAmount>=level1Holding){
634                     uint256 rewardAmt = _amountToDistribute*level1Commission/10000;
635                     rewardBalanceLedger_[referrer] = rewardBalanceLedger_[referrer].add(rewardAmt);
636                     commFundsWallet = commFundsWallet + rewardAmt;
637                     emit Reward(buyer,referrer,rewardAmt,holdingAmount,i+1);
638                 }else{
639                     _burnedSupply = _burnedSupply + (_amountToDistributeToken*level1Commission/10000);
640                     _circulatedSupply = _circulatedSupply.add(_amountToDistributeToken*level1Commission/10000);
641                     emit Burned(buyer,referrer,(_amountToDistributeToken*level1Commission/10000),level1Commission,i+1);
642                 }
643                 remainingRewardPer = remainingRewardPer.sub(level1Commission);
644             }
645                else if( i == 1){
646                 if(holdingAmount>=level2Holding){
647                     uint256 rewardAmt = _amountToDistribute*level2Commission/10000;
648                     rewardBalanceLedger_[referrer] += rewardAmt;
649                     commFundsWallet = commFundsWallet + rewardAmt;
650                     emit Reward(buyer,referrer,rewardAmt,holdingAmount,i+1);
651                 }else{
652                     _burnedSupply = _burnedSupply + (_amountToDistributeToken*level2Commission/10000);
653                     _circulatedSupply = _circulatedSupply.add(_amountToDistributeToken*level2Commission/10000);
654                     emit Burned(buyer,referrer,(_amountToDistributeToken*level2Commission/10000),level2Commission,i+1);
655                 }
656                 remainingRewardPer = remainingRewardPer - level2Commission;
657                 }
658                 else if(i == 2){
659                 if(holdingAmount>=level3Holding){
660                     uint256 rewardAmt = _amountToDistribute*level3Commission/10000;
661                     rewardBalanceLedger_[referrer] += rewardAmt;
662                     commFundsWallet = commFundsWallet + rewardAmt;
663                     emit Reward(buyer,referrer,rewardAmt,holdingAmount,i+1);
664                 }else{
665                     _burnedSupply = _burnedSupply + (_amountToDistributeToken*level3Commission/10000);
666                     _circulatedSupply = _circulatedSupply.add(_amountToDistributeToken*level3Commission/10000);
667                     emit Burned(buyer,referrer,(_amountToDistributeToken*level3Commission/10000),level3Commission,i+1);
668                 }
669                 remainingRewardPer = remainingRewardPer - level3Commission;
670                 }
671                 else if(i == 3){
672                 if(holdingAmount>=level4Holding){
673                     uint256 rewardAmt = _amountToDistribute*level4Commission/10000;
674                     rewardBalanceLedger_[referrer] += rewardAmt;
675                     commFundsWallet = commFundsWallet + rewardAmt;
676                     emit Reward(buyer,referrer,rewardAmt,holdingAmount,i+1);
677                 }else{
678                     _burnedSupply = _burnedSupply + (_amountToDistributeToken*level4Commission/10000);
679                     _circulatedSupply = _circulatedSupply.add(_amountToDistributeToken*level4Commission/10000);
680                     emit Burned(buyer,referrer,(_amountToDistributeToken*level4Commission/10000),level4Commission,i+1);
681                 }
682                 remainingRewardPer = remainingRewardPer - level4Commission;
683                 }
684                 else if(i == 4 ) {
685                 if(holdingAmount>=level5Holding){
686                     uint256 rewardAmt = _amountToDistribute*level5Commission/100000;
687                     rewardBalanceLedger_[referrer] += rewardAmt;
688                     commFundsWallet = commFundsWallet + rewardAmt;
689                     emit Reward(buyer,referrer,rewardAmt,holdingAmount,i+1);
690                 }else{
691                     _burnedSupply = _burnedSupply + (_amountToDistributeToken*level5Commission/100000);
692                     _circulatedSupply = _circulatedSupply.add(_amountToDistributeToken*level5Commission/100000);
693                     emit Burned(buyer,referrer,(_amountToDistributeToken*level5Commission/10000),level5Commission/10,i+1);
694                 }
695                 remainingRewardPer = remainingRewardPer - (level5Commission/10);
696                 }
697                else if(i == 5 ) {
698                 if(holdingAmount>=level6Holding){
699                     uint256 rewardAmt = _amountToDistribute*level6Commission/100000;
700                     rewardBalanceLedger_[referrer] += rewardAmt;
701                     commFundsWallet = commFundsWallet + rewardAmt;
702                     emit Reward(buyer,referrer,rewardAmt,holdingAmount,i+1);
703                 }else{
704                     _burnedSupply = _burnedSupply + (_amountToDistributeToken*level6Commission/100000);
705                     _circulatedSupply = _circulatedSupply.add(_amountToDistributeToken*level6Commission/100000);
706                     emit Burned(buyer,referrer,(_amountToDistributeToken*level6Commission/100000),level6Commission/10,i+1);
707                 }
708                 remainingRewardPer = remainingRewardPer - (level6Commission/10);
709                 }
710                else if(i == 6 ) {
711                 if(holdingAmount>=level7Holding){
712                     uint256 rewardAmt = _amountToDistribute*level7Commission/100000;
713                     rewardBalanceLedger_[referrer] += rewardAmt;
714                     commFundsWallet = commFundsWallet + rewardAmt;
715                     emit Reward(buyer,referrer,rewardAmt,holdingAmount,i+1);
716                 }else{
717                     _burnedSupply = _burnedSupply + (_amountToDistributeToken*level7Commission/100000);
718                     _circulatedSupply = _circulatedSupply.add(_amountToDistributeToken*level7Commission/100000);
719                     emit Burned(buyer,referrer,(_amountToDistributeToken*level7Commission/100000),level7Commission/10,i+1);
720                 }
721                 remainingRewardPer = remainingRewardPer - (level7Commission/10);
722                 }
723                 else if(i == 7 ) {
724                 if(holdingAmount>=level8Holding){
725                     uint256 rewardAmt = _amountToDistribute*level8Commission/100000;
726                     rewardBalanceLedger_[referrer] += rewardAmt;
727                     commFundsWallet = commFundsWallet + rewardAmt;
728                     emit Reward(buyer,referrer,rewardAmt,holdingAmount,i+1);
729                 }else{
730                     _burnedSupply = _burnedSupply + (_amountToDistributeToken*level8Commission/100000);
731                     _circulatedSupply = _circulatedSupply.add(_amountToDistributeToken*level8Commission/100000);
732                     emit Burned(buyer,referrer,(_amountToDistributeToken*level8Commission/100000),level8Commission/10,i+1);
733                 }
734                 remainingRewardPer = remainingRewardPer - (level8Commission/10);
735                 }
736                else if(i == 8 ) {
737                 if(holdingAmount>=level9Holding){
738                     uint256 rewardAmt = _amountToDistribute*level9Commission/100000;
739                     rewardBalanceLedger_[referrer] += rewardAmt;
740                     commFundsWallet = commFundsWallet + rewardAmt;
741                     emit Reward(buyer,referrer,rewardAmt,holdingAmount,i+1);
742                 }else{
743                     _burnedSupply = _burnedSupply + (_amountToDistributeToken*level9Commission/100000);
744                     _circulatedSupply = _circulatedSupply.add(_amountToDistributeToken*level9Commission/100000);
745                     emit Burned(buyer,referrer,(_amountToDistributeToken*level9Commission/100000),level9Commission/10,i+1);
746                 }
747                 remainingRewardPer = remainingRewardPer - (level9Commission/10);
748                 }
749                else if(i == 9 ) {
750                 if(holdingAmount>=level10Holding){
751                     uint256 rewardAmt = _amountToDistribute*level10Commission/100000;
752                     rewardBalanceLedger_[referrer] += rewardAmt;
753                     commFundsWallet = commFundsWallet + rewardAmt;
754                     emit Reward(buyer,referrer,rewardAmt,holdingAmount,i+1);
755                 }else{
756                     _burnedSupply = _burnedSupply + (_amountToDistributeToken*level10Commission/100000);
757                     _circulatedSupply = _circulatedSupply.add(_amountToDistributeToken*level10Commission/100000);
758                     emit Burned(buyer,referrer,(_amountToDistributeToken*level10Commission/100000),level10Commission/10,i+1);
759                 }
760                 remainingRewardPer = remainingRewardPer - (level10Commission/10);
761                 }
762                 
763                else if(i == 10){
764                 if(holdingAmount>=level11Holding){
765                     uint256 rewardAmt = _amountToDistribute*level11Commission/100000;
766                     rewardBalanceLedger_[referrer] += rewardAmt;
767                     commFundsWallet = commFundsWallet + rewardAmt;
768                     emit Reward(buyer,referrer,rewardAmt,holdingAmount,i+1);
769                 }else{
770                     _burnedSupply = _burnedSupply + (_amountToDistributeToken*level11Commission/100000);
771                     _circulatedSupply = _circulatedSupply.add(_amountToDistributeToken*level11Commission/100000);
772                     emit Burned(buyer,referrer,(_amountToDistributeToken*level11Commission/100000),level11Commission/10,i+1);
773                 }
774                 remainingRewardPer = remainingRewardPer - (level11Commission/10);
775                 }
776                else if(i == 11){
777                 if(holdingAmount>=level12Holding){
778                     uint256 rewardAmt = _amountToDistribute*level12Commission/100000;
779                     rewardBalanceLedger_[referrer] += rewardAmt;
780                     commFundsWallet = commFundsWallet + rewardAmt;
781                     emit Reward(buyer,referrer,rewardAmt,holdingAmount,i+1);
782                 }else{
783                     _burnedSupply = _burnedSupply + (_amountToDistributeToken*level12Commission/100000);
784                     _circulatedSupply = _circulatedSupply.add(_amountToDistributeToken*level12Commission/100000);
785                     emit Burned(buyer,referrer,(_amountToDistributeToken*level12Commission/100000),level12Commission/10,i+1);
786                 }
787                 remainingRewardPer = remainingRewardPer - (level12Commission/10);
788                 }
789                else if(i == 12){
790                 if(holdingAmount>=level13Holding){
791                     uint256 rewardAmt = _amountToDistribute*level13Commission/100000;
792                     rewardBalanceLedger_[referrer] += rewardAmt;
793                     commFundsWallet = commFundsWallet + rewardAmt;
794                     emit Reward(buyer,referrer,rewardAmt,holdingAmount,i+1);
795                 }else{
796                     _burnedSupply = _burnedSupply + (_amountToDistributeToken*level13Commission/100000);
797                     _circulatedSupply = _circulatedSupply.add(_amountToDistributeToken*level13Commission/100000);
798                     emit Burned(buyer,referrer,(_amountToDistributeToken*level13Commission/100000),level13Commission/10,i+1);
799                 }
800                 remainingRewardPer = remainingRewardPer - (level13Commission/10);
801                 }
802                else if(i == 13 ) {
803                 if(holdingAmount>=level14Holding){
804                     uint256 rewardAmt = _amountToDistribute*level14Commission/100000;
805                     rewardBalanceLedger_[referrer] += rewardAmt;
806                     commFundsWallet = commFundsWallet + rewardAmt;
807                     emit Reward(buyer,referrer,rewardAmt,holdingAmount,i+1);
808                 }else{
809                    _burnedSupply = _burnedSupply + (_amountToDistributeToken*level14Commission/100000);
810                    _circulatedSupply = _circulatedSupply.add(_amountToDistributeToken*level14Commission/100000);
811                    emit Burned(buyer,referrer,(_amountToDistributeToken*level14Commission/100000),level14Commission/10,i+1);
812                 }
813                 remainingRewardPer = remainingRewardPer - (level14Commission/10);
814                 }
815                else if(i == 14) {
816                 if(holdingAmount>=level15Holding){
817                     uint256 rewardAmt = _amountToDistribute*level15Commission/100000;
818                     rewardBalanceLedger_[referrer] += rewardAmt;
819                     commFundsWallet = commFundsWallet + rewardAmt;
820                     emit Reward(buyer,referrer,rewardAmt,holdingAmount,i+1);
821                 }else{
822                    _burnedSupply = _burnedSupply + (_amountToDistributeToken*level15Commission/100000);
823                    _circulatedSupply = _circulatedSupply.add(_amountToDistributeToken*level15Commission/100000);
824                    emit Burned(buyer,referrer,(_amountToDistributeToken*level15Commission/100000),level15Commission/10,i+1);
825                 }
826                 remainingRewardPer = remainingRewardPer - (level15Commission/10);
827                 }
828                 _idToDistribute = referrer;
829         }
830        
831     }
832      
833     /**
834     calculation logic for buy function
835      */
836 
837      function taxedTokenTransfer(uint256 incomingEther, uint256 buyPrice) internal pure returns(uint256) {
838             uint256 deduction = incomingEther * 22500/100000;
839             uint256 taxedEther = incomingEther - deduction;
840             uint256 tokenToTransfer = (taxedEther.mul(10**6)).div(buyPrice);
841             return tokenToTransfer;
842      }
843 
844      /**
845      * sell method for ether.
846       */
847 
848      function sell(uint256 tokenToSell) external returns(bool){
849           require(msg.sender == tx.origin, "Origin and Sender Mismatched");
850           require(block.number - userLastAction[msg.sender] > 0, "Frequent Call");
851           userLastAction[msg.sender] = block.number;
852           uint256 sellPrice = currentPrice - (currentPrice/100);
853           uint256 circultedSupplyBeforeSell = _circulatedSupply;
854           require(isSellPrevented == 0, "Sell not allowed.");
855           require(isUserSellDisallowed[msg.sender] == false, "Sell not allowed for user.");
856           require(_circulatedSupply > 0, "no circulated tokens");
857           require(tokenToSell > 0, "can not sell 0 token");
858           require(tokenToSell <= tokenBalances[msg.sender], "not enough tokens to transact");
859           require(tokenToSell.add(_circulatedSupply) <= _totalSupply, "exceeded total supply");
860           require(msg.sender != address(0), "ERC20: burn from the zero address");
861           tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(tokenToSell);
862           emit Transfer(msg.sender, address(this), tokenToSell);
863           uint256 totalDecrement = getIncrement(tokenToSell);
864           currentPrice = currentPrice - totalDecrement;
865           _circulatedSupply = _circulatedSupply.sub(tokenToSell);
866           uint256 sellPriceAfterSell = currentPrice;
867           uint256 convertedEthers = etherValueForSell(tokenToSell,sellPrice);
868           uint256 circultedSupplyAfterSell = _circulatedSupply;
869           msg.sender.transfer(convertedEthers);
870           emit Sell(msg.sender,convertedEthers,tokenToSell,sellPrice, sellPriceAfterSell,circultedSupplyBeforeSell,circultedSupplyAfterSell);
871           return true;
872      }
873      
874      function withdrawRewards(uint256 ethWithdraw) external returns(bool){
875           require(msg.sender == tx.origin, "Origin and Sender Mismatched");
876           require(block.number - userLastAction[msg.sender] > 0, "Frequent Call");
877           userLastAction[msg.sender] = block.number;
878           require(isWithdrawPrevented == 0, "Withdraw not allowed.");
879           require(isUserWithdrawDisallowed[msg.sender] == false, "Withdraw not allowed for user.");
880           require(_circulatedSupply > 0, "no circulated tokens");
881           require(ethWithdraw > 0, "can not withdraw 0 eth");
882           require(ethWithdraw <= rewardBalanceLedger_[msg.sender], "not enough rewards to withdraw");
883           require(ethWithdraw <= commFundsWallet, "exceeded commission funds");
884           rewardBalanceLedger_[msg.sender] = rewardBalanceLedger_[msg.sender].sub(ethWithdraw);
885           commFundsWallet = commFundsWallet.sub(ethWithdraw);
886           msg.sender.transfer(ethWithdraw);
887           emit onWithdraw(msg.sender,ethWithdraw);
888           return true;
889      }
890      
891    
892      
893     function transfer(address recipient, uint256 amount) external  returns (bool) {
894         require(msg.sender == tx.origin, "Origin and Sender Mismatched");
895         require(amount > 0, "Can not transfer 0 tokens.");
896         require(amount <= maxBuyingLimit, "Maximum Transfer 5000.");
897         require(amount.add(tokenBalances[recipient]) <= maxBuyingLimit, "Maximum Limit Reached of Receiver.");
898         require(tokenBalances[msg.sender] >= amount, "Insufficient Token Balance.");
899         _transfer(_msgSender(), recipient, amount);
900         return true;
901     }
902      
903 
904     function etherValueForSell(uint256 tokenToSell, uint256 sellPrice) internal pure returns(uint256) {
905         uint256 convertedEther = (tokenToSell.div(10**6)).mul(sellPrice);
906         return convertedEther;
907      }
908 
909     /**
910      * @dev Moves tokens `amount` from `sender` to `recipient`.
911      *
912      * This is internal function is equivalent to {transfer}, and can be used to
913      * e.g. implement automatic token fees, slashing mechanisms, etc.
914      *
915      * Emits a {Transfer} event.
916      *
917      * Requirements:
918      *
919      * - `sender` cannot be the zero address.
920      * - `recipient` cannot be the zero address.
921      * - `sender` must have a balance of at least `amount`.
922      */
923 
924     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
925         require(sender != address(0), "ERC20: transfer from the zero address");
926         require(recipient != address(0), "ERC20: transfer to the zero address");
927         tokenBalances[sender] = tokenBalances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
928         tokenBalances[recipient] = tokenBalances[recipient].add(amount);
929         emit Transfer(sender, recipient, amount);
930     }
931 
932    
933 
934     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
935      * the total supply.
936      *
937      * Emits a {Transfer} event with `from` set to the zero address.
938      *
939      * Requirements
940      *
941      * - `to` cannot be the zero address.
942      */
943 
944     function _mint(address account, uint256 taxedTokenAmount) internal  {
945         require(account != address(0), "ERC20: mint to the zero address");
946         tokenBalances[account] = tokenBalances[account].add(taxedTokenAmount);
947         _circulatedSupply = _circulatedSupply.add(taxedTokenAmount);
948         emit Transfer(address(this), account, taxedTokenAmount);
949        
950     }
951 
952     /**
953      * @dev Destroys `amount` tokens from `account`, reducing the
954      * total supply.
955      *
956      * Emits a {Transfer} event with `to` set to the zero address.
957      *
958      * Requirements
959      *
960      * - `account` cannot be the zero address.
961      * - `account` must have at least `amount` tokens.
962      */
963 
964     function _burn(address account, uint256 amount) internal {
965         require(account != address(0), "ERC20: burn from the zero address");
966         tokenBalances[account] = tokenBalances[account].sub(amount);
967         _circulatedSupply = _circulatedSupply.sub(amount);
968         emit Transfer(account, address(this), amount);
969     }
970 
971     function _msgSender() internal view returns (address ){
972         return msg.sender;
973     }
974    
975     function getIncrement(uint256 tokenQty) public returns(uint256){
976          if(_circulatedSupply >= 0 && _circulatedSupply <= 465000*10**6){
977              initialPriceIncrement = tokenQty*0;
978          }
979          if(_circulatedSupply > 465000*10**6 && _circulatedSupply <= 1100000*10**6){
980              initialPriceIncrement = tokenQty*300000000;
981          }
982          if(_circulatedSupply > 1100000*10**6 && _circulatedSupply <= 1550000*10**6){
983              initialPriceIncrement = tokenQty*775000000;
984          }
985          if(_circulatedSupply > 1550000*10**6 && _circulatedSupply <= 1960000*10**6){
986              initialPriceIncrement = tokenQty*1750000000;
987          }
988          if(_circulatedSupply > 1960000*10**6 && _circulatedSupply <= 2310000*10**6){
989              initialPriceIncrement = tokenQty*4000000000;
990          }
991          if(_circulatedSupply > 2310000*10**6 && _circulatedSupply <= 2640000*10**6){
992              initialPriceIncrement = tokenQty*5750000000;
993          }
994          if(_circulatedSupply > 2640000*10**6 && _circulatedSupply <= 2950000*10**6){
995              initialPriceIncrement = tokenQty*12750000000;
996          }
997          if(_circulatedSupply > 2950000*10**6 && _circulatedSupply <= 3240000*10**6){
998              initialPriceIncrement = tokenQty*20250000000;
999          }
1000          if(_circulatedSupply > 3240000*10**6 && _circulatedSupply <= 3510000*10**6){
1001              initialPriceIncrement = tokenQty*36250000000;
1002          }
1003          if(_circulatedSupply > 3510000*10**6 && _circulatedSupply <= 3770000*10**6){
1004              initialPriceIncrement = tokenQty*62500000000;
1005          }
1006          if(_circulatedSupply > 3770000*10**6 && _circulatedSupply <= 4020000*10**6){
1007              initialPriceIncrement = tokenQty*127500000000;
1008          }
1009          if(_circulatedSupply > 4020000*10**6 && _circulatedSupply <= 4260000*10**6){
1010              initialPriceIncrement = tokenQty*220000000000;
1011          }
1012          if(_circulatedSupply > 4260000*10**6 && _circulatedSupply <= 4490000*10**6){
1013              initialPriceIncrement = tokenQty*362500000000;
1014          }
1015          if(_circulatedSupply > 4490000*10**6 && _circulatedSupply <= 4700000*10**6){
1016              initialPriceIncrement = tokenQty*650000000000;
1017          }
1018          if(_circulatedSupply > 4700000*10**6 && _circulatedSupply <= 4900000*10**6){
1019              initialPriceIncrement = tokenQty*1289500000000;
1020          }
1021          if(_circulatedSupply > 4900000*10**6 && _circulatedSupply <= 5080000*10**6){
1022              initialPriceIncrement = tokenQty*2800000000000;
1023          }
1024          if(_circulatedSupply > 5080000*10**6 && _circulatedSupply <= 5220000*10**6){
1025              initialPriceIncrement = tokenQty*6250000000000;
1026          }
1027          if(_circulatedSupply > 5220000*10**6 && _circulatedSupply <= 5350000*10**6){
1028              initialPriceIncrement = tokenQty*9750000000000;
1029          }
1030          if(_circulatedSupply > 5350000*10**6 && _circulatedSupply <= 5460000*10**6){
1031              initialPriceIncrement = tokenQty*21358175000000;
1032          }
1033          if(_circulatedSupply > 5460000*10**6 && _circulatedSupply <= 5540000*10**6){
1034              initialPriceIncrement = tokenQty*49687500000000;
1035          }
1036          if(_circulatedSupply > 5540000*10**6 && _circulatedSupply <= 5580000*10**6){
1037              initialPriceIncrement = tokenQty*170043750000000;
1038          }
1039          if(_circulatedSupply > 5580000*10**6 && _circulatedSupply <= 5600000*10**6){
1040              initialPriceIncrement = tokenQty*654100000000000;
1041          }
1042          return initialPriceIncrement.div(10**6);
1043      }
1044  
1045 }
1046 
1047 
1048 library SafeMath {
1049     /**
1050      * @dev Returns the addition of two unsigned integers, reverting on
1051      * overflow.
1052      *
1053      * Counterpart to Solidity's `+` operator.
1054      *
1055      * Requirements:
1056      *
1057      * - Addition cannot overflow.
1058      */
1059     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1060         uint256 c = a + b;
1061         require(c >= a, "SafeMath: addition overflow");
1062 
1063         return c;
1064     }
1065 
1066     /**
1067      * @dev Returns the subtraction of two unsigned integers, reverting on
1068      * overflow (when the result is negative).
1069      *
1070      * Counterpart to Solidity's `-` operator.
1071      *
1072      * Requirements:
1073      *
1074      * - Subtraction cannot overflow.
1075      */
1076     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1077         return sub(a, b, "SafeMath: subtraction overflow");
1078     }
1079 
1080     /**
1081      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1082      * overflow (when the result is negative).
1083      *
1084      * Counterpart to Solidity's `-` operator.
1085      *
1086      * Requirements:
1087      *
1088      * - Subtraction cannot overflow.
1089      */
1090     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1091         require(b <= a, errorMessage);
1092         uint256 c = a - b;
1093 
1094         return c;
1095     }
1096 
1097     /**
1098      * @dev Returns the multiplication of two unsigned integers, reverting on
1099      * overflow.
1100      *
1101      * Counterpart to Solidity's `*` operator.
1102      *
1103      * Requirements:
1104      *
1105      * - Multiplication cannot overflow.
1106      */
1107     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1108         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1109         // benefit is lost if 'b' is also tested.
1110         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1111         if (a == 0) {
1112             return 0;
1113         }
1114 
1115         uint256 c = a * b;
1116         require(c / a == b, "SafeMath: multiplication overflow");
1117 
1118         return c;
1119     }
1120 
1121     /**
1122      * @dev Returns the integer division of two unsigned integers. Reverts on
1123      * division by zero. The result is rounded towards zero.
1124      *
1125      * Counterpart to Solidity's `/` operator. Note: this function uses a
1126      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1127      * uses an invalid opcode to revert (consuming all remaining gas).
1128      *
1129      * Requirements:
1130      *
1131      * - The divisor cannot be zero.
1132      */
1133     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1134         return div(a, b, "SafeMath: division by zero");
1135     }
1136 
1137     /**
1138      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
1139      * division by zero. The result is rounded towards zero.
1140      *
1141      * Counterpart to Solidity's `/` operator. Note: this function uses a
1142      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1143      * uses an invalid opcode to revert (consuming all remaining gas).
1144      *
1145      * Requirements:
1146      *
1147      * - The divisor cannot be zero.
1148      */
1149     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1150         require(b > 0, errorMessage);
1151         uint256 c = a / b;
1152         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1153 
1154         return c;
1155     }
1156 
1157     /**
1158      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1159      * Reverts when dividing by zero.
1160      *
1161      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1162      * opcode (which leaves remaining gas untouched) while Solidity uses an
1163      * invalid opcode to revert (consuming all remaining gas).
1164      *
1165      * Requirements:
1166      *
1167      * - The divisor cannot be zero.
1168      */
1169     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1170         return mod(a, b, "SafeMath: modulo by zero");
1171     }
1172 
1173     /**
1174      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1175      * Reverts with custom message when dividing by zero.
1176      *
1177      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1178      * opcode (which leaves remaining gas untouched) while Solidity uses an
1179      * invalid opcode to revert (consuming all remaining gas).
1180      *
1181      * Requirements:
1182      *
1183      * - The divisor cannot be zero.
1184      */
1185     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1186         require(b != 0, errorMessage);
1187         return a % b;
1188     }
1189 }