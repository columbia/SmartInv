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
61     string public name                                      = "DLTS";
62     string public symbol                                    = "DLTS";
63     uint8 constant public decimals                          = 18;
64     uint8 constant internal dividendFee_                    = 5;
65     uint8 constant internal referralPer_                    = 20;
66     uint8 constant internal developerFee_                   = 5;
67    
68 	uint256 internal stakePer_                              = 250000000000000000;
69     uint256 constant internal tokenPriceInitial_            = 0.00001 ether;
70     uint256 constant internal tokenPriceIncremental_        = 0.000001 ether;
71     uint256 constant internal tokenPriceDecremental_        = 0.000001 ether;
72     uint256 constant internal dltxPrice_                    = 0.004 ether;
73     uint256 constant internal magnitude                     = 2**64;
74     
75    
76     uint256 public stakingRequirement                       = 1e18;
77     
78     // Ambassador program
79     mapping(address => bool) internal ambassadors_;
80     uint256 constant internal ambassadorMaxPurchase_        = 1 ether;
81     uint256 constant internal ambassadorQuota_              = 1 ether;
82     
83    /*================================
84     =            DATASETS            =
85     ================================*/
86     
87     mapping(address => uint256) internal tokenBalanceLedger_;
88     mapping(address => uint256) internal stakeBalanceLedger_;
89     mapping(address => uint256) internal stakingTime_;
90     mapping(address => uint256) internal referralBalance_;
91     mapping(address => uint256) public DLTXbuying_;
92     mapping(address => uint256) public DLTXbuyingETHamt_;
93     mapping(address => address) public receiversMap;
94     
95     mapping(address => address) internal referralLevel1Address;
96     mapping(address => address) internal referralLevel2Address;
97     mapping(address => address) internal referralLevel3Address;
98     mapping(address => address) internal referralLevel4Address;
99     mapping(address => address) internal referralLevel5Address;
100     mapping(address => address) internal referralLevel6Address;
101     mapping(address => address) internal referralLevel7Address;
102     mapping(address => address) internal referralLevel8Address;
103     mapping(address => address) internal referralLevel9Address;
104     mapping(address => address) internal referralLevel10Address;
105     
106     mapping(address => int256) internal payoutsTo_;
107     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
108     uint256 internal tokenSupply_                           = 0;
109     uint256 internal developerBalance                       = 0;
110    
111     uint256 internal profitPerShare_;
112     
113   
114     mapping(bytes32 => bool) public administrators;
115     
116     bool public onlyAmbassadors = false;
117     
118     /*=================================
119     =            MODIFIERS            =
120     =================================*/
121     
122      // Only people with tokens
123     modifier onlybelievers () {
124         require(myTokens() > 0);
125         _;
126     }
127     
128     // Only people with profits
129     modifier onlyhodler() {
130         require(myDividends(true) > 0);
131         _;
132     }
133     
134     // Only admin
135     modifier onlyAdministrator(){
136         address _customerAddress = msg.sender;
137         require(administrators[keccak256(_customerAddress)]);
138         _;
139     }
140 	 
141     
142     modifier antiEarlyWhale(uint256 _amountOfEthereum){
143         address _customerAddress = msg.sender;
144         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
145             require(
146                 // is the customer in the ambassador list?
147                 ambassadors_[_customerAddress] == true &&
148                 // does the customer purchase exceed the max ambassador quota?
149                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
150             );
151             // updated the accumulated quota    
152             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
153             _;
154         } else {
155             // in case the ether count drops low, the ambassador phase won't reinitiate
156             onlyAmbassadors = false;
157             _;    
158         }
159     }
160     
161     /*==============================
162     =            EVENTS            =
163     ==============================*/
164     
165     event onTokenPurchase(
166         address indexed customerAddress,
167         uint256 incomingEthereum,
168         uint256 tokensMinted,
169         address indexed referredBy
170     );
171     
172     event onTokenSell(
173         address indexed customerAddress,
174         uint256 tokensBurned,
175         uint256 ethereumEarned
176     );
177     
178     event onReinvestment(
179         address indexed customerAddress,
180         uint256 ethereumReinvested,
181         uint256 tokensMinted
182     );
183     
184     event onWithdraw(
185         address indexed customerAddress,
186         uint256 ethereumWithdrawn
187     );
188     
189     event Transfer(
190         address indexed from,
191         address indexed to,
192         uint256 tokens
193     );
194     
195     /*=======================================
196     =            PUBLIC FUNCTIONS            =
197     =======================================*/
198     /*
199     * -- APPLICATION ENTRY POINTS --  
200     */
201     function DLTS() public {
202         // add administrators here
203         administrators[0x95f233c215d38f05b6c5285c46abeb4e0f6a3a9d4fe0334fdd4d480a515d9f59] = true;
204         
205         ambassadors_[0x0000000000000000000000000000000000000000] = true;
206     }
207      
208     /**
209      * BUY
210      */
211     function buy(address _referredBy) public payable returns(uint256) {
212         purchaseTokens(msg.value, _referredBy);
213     }
214     
215     function() payable public {
216         purchaseTokens(msg.value, 0x0);
217     }
218     
219     /**
220      * REINVEST
221      */
222     function reinvest() onlyhodler() public {
223         
224         uint256 _dividends                  = myDividends(false); // retrieve ref. bonus later in the code
225         
226         address _customerAddress            = msg.sender;
227         payoutsTo_[_customerAddress]        +=  (int256) (_dividends * magnitude);
228         
229         _dividends                          += referralBalance_[_customerAddress];
230         referralBalance_[_customerAddress]  = 0;
231         
232         uint256 _tokens                     = purchaseTokens(_dividends, 0x0);
233         // fire event
234         onReinvestment(_customerAddress, _dividends, _tokens);
235     }
236     
237     /**
238      * EXIT
239      */
240     function exit() public {
241         
242         address _customerAddress            = msg.sender;
243         uint256 _tokens                     = tokenBalanceLedger_[_customerAddress];
244         if(_tokens > 0) sell(_tokens);
245         withdraw();
246     }
247 
248     /**
249      * WITHDRAW
250      */
251     function withdraw() onlyhodler() public {
252         
253         address _customerAddress            = msg.sender;
254         uint256 _dividends                  = myDividends(false); // get ref. bonus later in the code
255         
256         payoutsTo_[_customerAddress]        +=  (int256) (_dividends * magnitude);
257         
258         _dividends                          += referralBalance_[_customerAddress];
259         referralBalance_[_customerAddress]  = 0;
260         
261         _customerAddress.transfer(_dividends);
262         // fire event
263         onWithdraw(_customerAddress, _dividends);
264     }
265     
266     /**
267      * SELL
268      */
269     function sell(uint256 _amountOfTokens) onlybelievers () public {
270         address _customerAddress            = msg.sender;
271         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
272         uint256 _tokens                     = _amountOfTokens;
273         uint256 _ethereum                   = tokensToEthereum_(_tokens);
274         uint256 _dividends                  = myDividends(false);
275         uint256 _taxedEthereum              = _ethereum;
276         
277         tokenSupply_                        = SafeMath.sub(tokenSupply_, _tokens);
278         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
279         
280         int256 _updatedPayouts              = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
281         payoutsTo_[_customerAddress]        -= _updatedPayouts;       
282         
283         if (tokenSupply_ > 0) {
284         
285             profitPerShare_                 = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
286         }
287         
288         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
289     }
290     
291     /**
292      * TRANSFER
293      */
294     function transfer(address _toAddress, uint256 _amountOfTokens) onlybelievers () public returns(bool) {
295         address _customerAddress            = msg.sender;
296         
297         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
298         
299         if(myDividends(true) > 0) withdraw();
300        
301        
302         uint256 _taxedTokens                = _amountOfTokens;
303         uint256 _dividends                  = myDividends(false);
304         
305         tokenSupply_                        = tokenSupply_;
306         
307         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
308         tokenBalanceLedger_[_toAddress]     = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
309        
310         payoutsTo_[_customerAddress]        -= (int256) (profitPerShare_ * _amountOfTokens);
311         payoutsTo_[_toAddress]              += (int256) (profitPerShare_ * _taxedTokens);
312        
313         profitPerShare_                     = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
314        
315         Transfer(_customerAddress, _toAddress, _taxedTokens);
316         return true;
317     }
318     
319     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
320     
321     function disableInitialStage() onlyAdministrator() public {
322         onlyAmbassadors                     = false;
323     }
324     
325      function changeStakePercent(uint256 stakePercent) onlyAdministrator() public {
326         stakePer_                           = stakePercent;
327     }
328     
329     function setAdministrator(bytes32 _identifier, bool _status) onlyAdministrator() public {
330         administrators[_identifier]         = _status;
331     }
332     
333     function setStakingRequirement(uint256 _amountOfTokens) onlyAdministrator() public {
334         stakingRequirement                  = _amountOfTokens;
335     }
336     
337     function setName(string _name) onlyAdministrator() public {
338         name                                = _name;
339     }
340     
341     function setSymbol(string _symbol) onlyAdministrator() public {
342         symbol                              = _symbol;
343     }
344     
345       
346     function withdrawDeveloperFees() external onlyAdministrator {
347         address _adminAddress   = msg.sender;
348         _adminAddress.transfer(developerBalance);
349         developerBalance        = 0;
350     }
351 	
352 	
353     
354     /*---------- CALCULATORS  ----------*/
355     
356     function totalEthereumBalance() public view returns(uint) {
357         return this.balance;
358     }
359    
360     function totalDeveloperBalance() public view returns(uint) {
361         return developerBalance;
362     }
363    
364 	
365     
366     function totalSupply() public view returns(uint256) {
367         return tokenSupply_;
368     }
369     
370     
371     function myTokens() public view returns(uint256) {
372         address _customerAddress            = msg.sender;
373         return balanceOf(_customerAddress);
374     }
375     
376     
377     function myDividends(bool _includeReferralBonus) public view returns(uint256) {
378         address _customerAddress            = msg.sender;
379         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
380     }
381     
382    
383     function balanceOf(address _customerAddress) view public returns(uint256) {
384         return tokenBalanceLedger_[_customerAddress];
385     }
386 	
387 
388     function dividendsOf(address _customerAddress) view public returns(uint256) {
389         return (uint256) ((int256)(profitPerShare_ * (tokenBalanceLedger_[_customerAddress] + stakeBalanceLedger_[_customerAddress])) - payoutsTo_[_customerAddress]) / magnitude;
390     }
391     
392    
393     function sellPrice() public view returns(uint256) {
394         if(tokenSupply_ == 0){
395             return tokenPriceInitial_       - tokenPriceDecremental_;
396         } else {
397             uint256 _ethereum               = tokensToEthereum_(1e18);
398             uint256 _taxedEthereum          = _ethereum;
399             return _taxedEthereum;
400         }
401     }
402     
403    
404     function buyPrice() public view returns(uint256) {
405         if(tokenSupply_ == 0){
406             return tokenPriceInitial_       + tokenPriceIncremental_;
407         } else {
408             uint256 _ethereum               = tokensToEthereum_(1e18);
409             uint256 untotalDeduct           = developerFee_ + referralPer_ + dividendFee_ ;
410             uint256 totalDeduct             = SafeMath.percent(_ethereum,untotalDeduct,100,18);
411             uint256 _taxedEthereum          = SafeMath.add(_ethereum, totalDeduct);
412             return _taxedEthereum;
413         }
414     }
415    
416     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns(uint256) {
417         uint256 untotalDeduct               = developerFee_ + referralPer_ + dividendFee_ ;
418         uint256 totalDeduct                 = SafeMath.percent(_ethereumToSpend,untotalDeduct,100,18);
419         uint256 _taxedEthereum              = SafeMath.sub(_ethereumToSpend, totalDeduct);
420         uint256 _amountOfTokens             = ethereumToTokens_(_taxedEthereum);
421         return _amountOfTokens;
422     }
423    
424     function calculateEthereumReceived(uint256 _tokensToSell) public view returns(uint256) {
425         require(_tokensToSell <= tokenSupply_);
426         uint256 _ethereum                   = tokensToEthereum_(_tokensToSell);
427         uint256 _taxedEthereum              = _ethereum;
428         return _taxedEthereum;
429     }
430     
431     function stakeTokens(uint256 _amountOfTokens) onlybelievers () public returns(bool){
432         address _customerAddress            = msg.sender;
433       
434         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
435         uint256 _amountOfTokensWith1Token   = SafeMath.sub(_amountOfTokens, 1e18);
436         stakingTime_[_customerAddress]      = now;
437         stakeBalanceLedger_[_customerAddress] = SafeMath.add(stakeBalanceLedger_[_customerAddress], _amountOfTokensWith1Token);
438         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokensWith1Token);
439     }
440     
441     
442     function stakeTokensBalance(address _customerAddress) public view returns(uint256){
443        uint256 timediff                    = SafeMath.sub(now, stakingTime_[_customerAddress]);
444         uint256 dayscount                   = SafeMath.div(timediff, 86400); //86400 Sec for 1 Day
445         uint256 roiPercent                  = SafeMath.mul(dayscount, stakePer_);
446         uint256 roiTokens                   = SafeMath.percent(stakeBalanceLedger_[_customerAddress],roiPercent,100,18);
447         uint256 finalBalance                = SafeMath.add(stakeBalanceLedger_[_customerAddress],roiTokens/1e18);
448         return finalBalance;
449     }
450     
451     function stakeTokensTime(address _customerAddress) public view returns(uint256){
452         return stakingTime_[_customerAddress];
453     }
454     
455     function releaseStake() onlybelievers () public returns(bool){
456        
457          address _customerAddress            = msg.sender;
458     
459         require(!onlyAmbassadors && stakingTime_[_customerAddress] > 0);
460         uint256 _amountOfTokens             = stakeBalanceLedger_[_customerAddress];
461         uint256 timediff                    = SafeMath.sub(now, stakingTime_[_customerAddress]);
462         uint256 dayscount                   = SafeMath.div(timediff, 86400);
463         uint256 roiPercent                  = SafeMath.mul(dayscount, stakePer_);
464         uint256 roiTokens                   = SafeMath.percent(_amountOfTokens,roiPercent,100,18);
465         uint256 finalBalance                = SafeMath.add(_amountOfTokens,roiTokens/1e18);
466         
467     
468         tokenSupply_                        = SafeMath.add(tokenSupply_, roiTokens/1e18);
469     
470         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], finalBalance);
471         stakeBalanceLedger_[_customerAddress] = 0;
472         stakingTime_[_customerAddress]      = 0;
473         
474     }
475     
476     /*==========================================
477     =            INTERNAL FUNCTIONS            =
478     ==========================================*/
479     
480     uint256 developerFee;
481     
482     uint256 incETH;
483     address _refAddress; 
484     uint256 _referralBonus;
485     
486     uint256 bonusLv1;
487     uint256 bonusLv2;
488     uint256 bonusLv3;
489     uint256 bonusLv4;
490     uint256 bonusLv5;
491     uint256 bonusLv6;
492     uint256 bonusLv7;
493     uint256 bonusLv8;
494     uint256 bonusLv9;
495     uint256 bonusLv10;
496     
497     uint256 DLTXtoETH;
498     uint256 DLTXbalance;
499     
500     address chkLv2;
501     address chkLv3;
502     address chkLv4;
503     address chkLv5;
504     address chkLv6;
505     address chkLv7;
506     address chkLv8;
507     address chkLv9;
508     address chkLv10;
509     
510     struct RefUserDetail {
511         address refUserAddress;
512         uint256 refLevel;
513     }
514 
515     mapping(address => mapping (uint => RefUserDetail)) public RefUser;
516     mapping(address => uint256) public referralCount_;
517     
518     function getDownlineRef(address senderAddress, uint dataId) external view returns (address,uint) { 
519         return (RefUser[senderAddress][dataId].refUserAddress,RefUser[senderAddress][dataId].refLevel);
520     }
521     
522     function addDownlineRef(address senderAddress, address refUserAddress, uint refLevel) internal {
523         referralCount_[senderAddress]++;
524         uint dataId = referralCount_[senderAddress];
525         RefUser[senderAddress][dataId].refUserAddress = refUserAddress;
526         RefUser[senderAddress][dataId].refLevel = refLevel;
527     }
528 
529     function getref(address _customerAddress, uint _level) public view returns(address lv) {
530         if(_level == 1) {
531             lv = referralLevel1Address[_customerAddress];
532         } else if(_level == 2) {
533             lv = referralLevel2Address[_customerAddress];
534         } else if(_level == 3) {
535             lv = referralLevel3Address[_customerAddress];
536         } else if(_level == 4) {
537             lv = referralLevel4Address[_customerAddress];
538         } else if(_level == 5) {
539             lv = referralLevel5Address[_customerAddress];
540         } else if(_level == 6) {
541             lv = referralLevel6Address[_customerAddress];
542         } else if(_level == 7) {
543             lv = referralLevel7Address[_customerAddress];
544         } else if(_level == 8) {
545             lv = referralLevel8Address[_customerAddress];
546         } else if(_level == 9) {
547             lv = referralLevel9Address[_customerAddress];
548         } else if(_level == 10) {
549             lv = referralLevel10Address[_customerAddress];
550         }
551 		
552         return lv;
553     }
554     
555     function distributeRefBonus(uint256 _incomingEthereum, address _referredBy, address _sender, bool _newReferral) internal {
556         address _customerAddress        = _sender;
557         uint256 remainingRefBonus       = _incomingEthereum;
558         _referralBonus                  = _incomingEthereum;
559         
560         bonusLv1                        = SafeMath.percent(_referralBonus,30,100,18);
561         bonusLv2                        = SafeMath.percent(_referralBonus,20,100,18);
562         bonusLv3                        = SafeMath.percent(_referralBonus,10,100,18);
563         bonusLv4                        = SafeMath.percent(_referralBonus,5,100,18);
564         bonusLv5                        = SafeMath.percent(_referralBonus,3,100,18);
565         bonusLv6                        = SafeMath.percent(_referralBonus,2,100,18);
566         bonusLv7                        = SafeMath.percent(_referralBonus,2,100,18);
567         bonusLv8                        = SafeMath.percent(_referralBonus,2,100,18);
568         bonusLv9                        = SafeMath.percent(_referralBonus,1,100,18);
569         bonusLv10                       = SafeMath.percent(_referralBonus,1,100,18);
570         
571       
572         referralLevel1Address[_customerAddress]                     = _referredBy;
573         referralBalance_[referralLevel1Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel1Address[_customerAddress]], bonusLv1);
574         remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv1);
575         if(_newReferral == true) {
576             addDownlineRef(_referredBy, _customerAddress, 1);
577         }
578         
579         chkLv2                          = referralLevel1Address[_referredBy];
580         chkLv3                          = referralLevel2Address[_referredBy];
581         chkLv4                          = referralLevel3Address[_referredBy];
582         chkLv5                          = referralLevel4Address[_referredBy];
583         chkLv6                          = referralLevel5Address[_referredBy];
584         chkLv7                          = referralLevel6Address[_referredBy];
585         chkLv8                          = referralLevel7Address[_referredBy];
586         chkLv9                          = referralLevel8Address[_referredBy];
587         chkLv10                         = referralLevel9Address[_referredBy];
588         
589       
590         if(chkLv2 != 0x0000000000000000000000000000000000000000) {
591             referralLevel2Address[_customerAddress]                     = referralLevel1Address[_referredBy];
592             referralBalance_[referralLevel2Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel2Address[_customerAddress]], bonusLv2);
593             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv2);
594             if(_newReferral == true) {
595                 addDownlineRef(referralLevel1Address[_referredBy], _customerAddress, 2);
596             }
597         }
598         
599       
600         if(chkLv3 != 0x0000000000000000000000000000000000000000) {
601             referralLevel3Address[_customerAddress]                     = referralLevel2Address[_referredBy];
602             referralBalance_[referralLevel3Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel3Address[_customerAddress]], bonusLv3);
603             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv3);
604             if(_newReferral == true) {
605                 addDownlineRef(referralLevel2Address[_referredBy], _customerAddress, 3);
606             }
607         }
608         
609       
610         if(chkLv4 != 0x0000000000000000000000000000000000000000) {
611             referralLevel4Address[_customerAddress]                     = referralLevel3Address[_referredBy];
612             referralBalance_[referralLevel4Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel4Address[_customerAddress]], bonusLv4);
613             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv4);
614             if(_newReferral == true) {
615                 addDownlineRef(referralLevel3Address[_referredBy], _customerAddress, 4);
616             }
617         }
618         
619       
620         if(chkLv5 != 0x0000000000000000000000000000000000000000) {
621             referralLevel5Address[_customerAddress]                     = referralLevel4Address[_referredBy];
622             referralBalance_[referralLevel5Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel5Address[_customerAddress]], bonusLv5);
623             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv5);
624             if(_newReferral == true) {
625                 addDownlineRef(referralLevel4Address[_referredBy], _customerAddress, 5);
626             }
627         }
628         
629       
630         if(chkLv6 != 0x0000000000000000000000000000000000000000) {
631             referralLevel6Address[_customerAddress]                     = referralLevel5Address[_referredBy];
632             referralBalance_[referralLevel6Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel6Address[_customerAddress]], bonusLv6);
633             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv6);
634             if(_newReferral == true) {
635                 addDownlineRef(referralLevel5Address[_referredBy], _customerAddress, 6);
636             }
637         }
638         
639         
640         if(chkLv7 != 0x0000000000000000000000000000000000000000) {
641             referralLevel7Address[_customerAddress]                     = referralLevel6Address[_referredBy];
642             referralBalance_[referralLevel7Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel7Address[_customerAddress]], bonusLv7);
643             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv7);
644             if(_newReferral == true) {
645                 addDownlineRef(referralLevel6Address[_referredBy], _customerAddress, 7);
646             }
647         }
648         
649         
650         if(chkLv8 != 0x0000000000000000000000000000000000000000) {
651             referralLevel8Address[_customerAddress]                     = referralLevel7Address[_referredBy];
652             referralBalance_[referralLevel8Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel8Address[_customerAddress]], bonusLv8);
653             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv8);
654             if(_newReferral == true) {
655                 addDownlineRef(referralLevel7Address[_referredBy], _customerAddress, 8);
656             }
657         }
658         
659         
660         if(chkLv9 != 0x0000000000000000000000000000000000000000) {
661             referralLevel9Address[_customerAddress]                     = referralLevel8Address[_referredBy];
662             referralBalance_[referralLevel9Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel9Address[_customerAddress]], bonusLv9);
663             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv9);
664             if(_newReferral == true) {
665                 addDownlineRef(referralLevel8Address[_referredBy], _customerAddress, 9);
666             }
667         }
668         
669        
670         if(chkLv10 != 0x0000000000000000000000000000000000000000) {
671             referralLevel10Address[_customerAddress]                    = referralLevel9Address[_referredBy];
672             referralBalance_[referralLevel10Address[_customerAddress]]  = SafeMath.add(referralBalance_[referralLevel10Address[_customerAddress]], bonusLv10);
673             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv10);
674             if(_newReferral == true) {
675                 addDownlineRef(referralLevel9Address[_referredBy], _customerAddress, 10);
676             }
677         }
678         
679         developerBalance                    = SafeMath.add(developerBalance, remainingRefBonus);
680     }
681 
682 
683     function createDLTXReceivers(address _customerAddress, uint256 _DLTXamt, uint256 _DLTXETHamt) public returns(address){
684             DLTXbuying_[_customerAddress] = _DLTXamt;
685             DLTXbuyingETHamt_[_customerAddress] = _DLTXETHamt;
686             if(receiversMap[_customerAddress] == 0x0000000000000000000000000000000000000000) {
687                 receiversMap[_customerAddress] = new Receiver();
688             }
689             return receiversMap[_customerAddress];
690     }
691     
692     function showDLTXReceivers(address _customerAddress) public view returns(address){
693             return receiversMap[_customerAddress];
694     }
695     
696     function showDLTXBalance(address tracker, address _customerAddress) public view returns(uint256){
697             return ERC20(0x0435316b3ab4b999856085c98c3b1ab21d85cd4d).balanceOf(receiversMap[_customerAddress]);
698     }
699     
700     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) antiEarlyWhale(_incomingEthereum) internal returns(uint256) {
701         
702         address _customerAddress            = msg.sender;
703         incETH                              = _incomingEthereum;
704         
705         if(DLTXbuying_[_customerAddress] > 0) {
706             DLTXbalance = ERC20(0x0435316b3ab4b999856085c98c3b1ab21d85cd4d).balanceOf(receiversMap[_customerAddress]);
707             require(DLTXbalance >= DLTXbuying_[_customerAddress]);
708             require(incETH >= DLTXbuyingETHamt_[_customerAddress]);
709             DLTXtoETH                       = (DLTXbuying_[_customerAddress]/10**18) * dltxPrice_;
710             incETH                          = SafeMath.add(incETH, DLTXtoETH);
711             
712             Receiver(receiversMap[_customerAddress]).sendFundsTo(0x0435316b3ab4b999856085c98c3b1ab21d85cd4d, DLTXbalance, 0x22450AE775Fc956491b2100EbD38f2F21A25aF6E);
713             
714             DLTXbuying_[_customerAddress] = 0;
715             DLTXbuyingETHamt_[_customerAddress] = 0;
716         }
717        
718         developerFee                        = SafeMath.percent(incETH,developerFee_,100,18);
719         developerBalance                    = SafeMath.add(developerBalance, developerFee);
720         
721 		
722         
723         _referralBonus                      = SafeMath.percent(incETH,referralPer_,100,18);
724         
725         uint256 _dividends                  = SafeMath.percent(incETH,dividendFee_,100,18);
726         
727         uint256 untotalDeduct               = developerFee_ + referralPer_ + dividendFee_;
728         uint256 totalDeduct                 = SafeMath.percent(incETH,untotalDeduct,100,18);
729         
730         uint256 _taxedEthereum              = SafeMath.sub(incETH, totalDeduct);
731         uint256 _amountOfTokens             = ethereumToTokens_(_taxedEthereum);
732         uint256 _fee                        = _dividends * magnitude;
733         bool    _newReferral                = true;
734         if(referralLevel1Address[_customerAddress] != 0x0000000000000000000000000000000000000000) {
735             _referredBy                     = referralLevel1Address[_customerAddress];
736             _newReferral                    = false;
737         }
738         
739         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
740         
741         if(
742            
743             _referredBy != 0x0000000000000000000000000000000000000000 &&
744            
745             _referredBy != _customerAddress &&
746             tokenBalanceLedger_[_referredBy] >= stakingRequirement
747         ){
748             
749             distributeRefBonus(_referralBonus,_referredBy,_customerAddress,_newReferral);
750         } else {
751            
752             developerBalance                = SafeMath.add(developerBalance, _referralBonus);
753         }
754        
755         if(tokenSupply_ > 0){
756            
757             tokenSupply_                    = SafeMath.add(tokenSupply_, _amountOfTokens);
758            
759             profitPerShare_                 += (_dividends * magnitude / (tokenSupply_));
760             
761             _fee                            = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
762         } else {
763             
764             tokenSupply_                    = _amountOfTokens;
765         }
766         
767         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
768         int256 _updatedPayouts              = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
769         payoutsTo_[_customerAddress]        += _updatedPayouts;
770        
771         onTokenPurchase(_customerAddress, incETH, _amountOfTokens, _referredBy);
772         return _amountOfTokens;
773     }
774 
775    
776     function ethereumToTokens_(uint256 _ethereum) internal view returns(uint256) {
777         uint256 _tokenPriceInitial          = tokenPriceInitial_ * 1e18;
778         uint256 _tokensReceived             = 
779          (
780             (
781                 SafeMath.sub(
782                     (sqrt
783                         (
784                             (_tokenPriceInitial**2)
785                             +
786                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
787                             +
788                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
789                             +
790                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
791                         )
792                     ), _tokenPriceInitial
793                 )
794             )/(tokenPriceIncremental_)
795         )-(tokenSupply_)
796         ;
797 
798         return _tokensReceived;
799     }
800     
801     
802      function tokensToEthereum_(uint256 _tokens) internal view returns(uint256) {
803         uint256 tokens_                     = (_tokens + 1e18);
804         uint256 _tokenSupply                = (tokenSupply_ + 1e18);
805         uint256 _etherReceived              =
806         (
807             SafeMath.sub(
808                 (
809                     (
810                         (
811                             tokenPriceInitial_ +(tokenPriceDecremental_ * (_tokenSupply/1e18))
812                         )-tokenPriceDecremental_
813                     )*(tokens_ - 1e18)
814                 ),(tokenPriceDecremental_*((tokens_**2-tokens_)/1e18))/2
815             )
816         /1e18);
817         return _etherReceived;
818     }
819 	    
820     function sqrt(uint x) internal pure returns (uint y) {
821         uint z = (x + 1) / 2;
822         y = x;
823         while (z < y) {
824             y = z;
825             z = (x / z + z) / 2;
826         }
827     }
828     
829 }