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
38 contract EtherStake {
39     
40     /*=====================================
41     =            CONFIGURABLES            =
42     =====================================*/
43     
44     string public name                                      = "EtherStake";
45     string public symbol                                    = "EST";
46     uint8 constant public decimals                          = 18;
47     uint8 constant internal dividendFee_                    = 5;
48     uint8 constant internal referralPer_                    = 20;
49     uint8 constant internal developerFee_                   = 5;
50     uint8 internal stakePer_                                = 1;
51     uint256 constant internal tokenPriceInitial_            = 0.000001 ether;
52     uint256 constant internal tokenPriceIncremental_        = 0.0000001 ether;
53     uint256 constant internal tokenPriceDecremental_        = 0.0000001 ether;
54     uint256 constant internal magnitude                     = 2**64;
55     
56    
57     uint256 public stakingRequirement                       = 1e18;
58     
59     // Ambassador program
60     mapping(address => bool) internal ambassadors_;
61     uint256 constant internal ambassadorMaxPurchase_        = 1 ether;
62     uint256 constant internal ambassadorQuota_              = 1 ether;
63     
64    /*================================
65     =            DATASETS            =
66     ================================*/
67     
68     mapping(address => uint256) internal tokenBalanceLedger_;
69     mapping(address => uint256) internal stakeBalanceLedger_;
70     mapping(address => uint256) internal stakingTime_;
71     mapping(address => uint256) internal referralBalance_;
72     
73     mapping(address => address) internal referralLevel1Address;
74     mapping(address => address) internal referralLevel2Address;
75     mapping(address => address) internal referralLevel3Address;
76     mapping(address => address) internal referralLevel4Address;
77     mapping(address => address) internal referralLevel5Address;
78     mapping(address => address) internal referralLevel6Address;
79     mapping(address => address) internal referralLevel7Address;
80     mapping(address => address) internal referralLevel8Address;
81     mapping(address => address) internal referralLevel9Address;
82     mapping(address => address) internal referralLevel10Address;
83     
84     mapping(address => int256) internal payoutsTo_;
85     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
86     uint256 internal tokenSupply_                           = 0;
87     uint256 internal developerBalance                       = 0;
88     uint256 internal profitPerShare_;
89     
90   
91     mapping(bytes32 => bool) public administrators;
92     bool public onlyAmbassadors = false;
93     
94     /*=================================
95     =            MODIFIERS            =
96     =================================*/
97     
98      // Only people with tokens
99     modifier onlybelievers () {
100         require(myTokens() > 0);
101         _;
102     }
103     
104     // Only people with profits
105     modifier onlyhodler() {
106         require(myDividends(true) > 0);
107         _;
108     }
109     
110     // Only admin
111     modifier onlyAdministrator(){
112         address _customerAddress = msg.sender;
113         require(administrators[keccak256(_customerAddress)]);
114         _;
115     }
116     
117     modifier antiEarlyWhale(uint256 _amountOfEthereum){
118         address _customerAddress = msg.sender;
119         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
120             require(
121                 // is the customer in the ambassador list?
122                 ambassadors_[_customerAddress] == true &&
123                 // does the customer purchase exceed the max ambassador quota?
124                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
125             );
126             // updated the accumulated quota    
127             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
128             _;
129         } else {
130             // in case the ether count drops low, the ambassador phase won't reinitiate
131             onlyAmbassadors = false;
132             _;    
133         }
134     }
135     
136     /*==============================
137     =            EVENTS            =
138     ==============================*/
139     
140     event onTokenPurchase(
141         address indexed customerAddress,
142         uint256 incomingEthereum,
143         uint256 tokensMinted,
144         address indexed referredBy
145     );
146     
147     event onTokenSell(
148         address indexed customerAddress,
149         uint256 tokensBurned,
150         uint256 ethereumEarned
151     );
152     
153     event onReinvestment(
154         address indexed customerAddress,
155         uint256 ethereumReinvested,
156         uint256 tokensMinted
157     );
158     
159     event onWithdraw(
160         address indexed customerAddress,
161         uint256 ethereumWithdrawn
162     );
163     
164     event Transfer(
165         address indexed from,
166         address indexed to,
167         uint256 tokens
168     );
169     
170     /*=======================================
171     =            PUBLIC FUNCTIONS            =
172     =======================================*/
173     /*
174     * -- APPLICATION ENTRY POINTS --  
175     */
176     function EtherStake() public {
177         // add administrators here
178         administrators[0x089e3a572868ae970476340e46d6945a8af57e4afa653bf80126615e7f2e2b8e] = true;
179         ambassadors_[0x0000000000000000000000000000000000000000] = true;
180     }
181      
182     /**
183      * BUY
184      */
185     function buy(address _referredBy) public payable returns(uint256) {
186         purchaseTokens(msg.value, _referredBy);
187     }
188     
189     function() payable public {
190         purchaseTokens(msg.value, 0x0);
191     }
192     
193     /**
194      * REINVEST
195      */
196     function reinvest() onlyhodler() public {
197         
198         uint256 _dividends                  = myDividends(false); // retrieve ref. bonus later in the code
199         
200         address _customerAddress            = msg.sender;
201         payoutsTo_[_customerAddress]        +=  (int256) (_dividends * magnitude);
202         
203         _dividends                          += referralBalance_[_customerAddress];
204         referralBalance_[_customerAddress]  = 0;
205         
206         uint256 _tokens                     = purchaseTokens(_dividends, 0x0);
207         // fire event
208         onReinvestment(_customerAddress, _dividends, _tokens);
209     }
210     
211     /**
212      * EXIT
213      */
214     function exit() public {
215         
216         address _customerAddress            = msg.sender;
217         uint256 _tokens                     = tokenBalanceLedger_[_customerAddress];
218         if(_tokens > 0) sell(_tokens);
219         withdraw();
220     }
221 
222     /**
223      * WITHDRAW
224      */
225     function withdraw() onlyhodler() public {
226         
227         address _customerAddress            = msg.sender;
228         uint256 _dividends                  = myDividends(false); // get ref. bonus later in the code
229         
230         payoutsTo_[_customerAddress]        +=  (int256) (_dividends * magnitude);
231         
232         _dividends                          += referralBalance_[_customerAddress];
233         referralBalance_[_customerAddress]  = 0;
234         
235         _customerAddress.transfer(_dividends);
236         // fire event
237         onWithdraw(_customerAddress, _dividends);
238     }
239     
240     /**
241      * SELL
242      */
243     function sell(uint256 _amountOfTokens) onlybelievers () public {
244         address _customerAddress            = msg.sender;
245         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
246         uint256 _tokens                     = _amountOfTokens;
247         uint256 _ethereum                   = tokensToEthereum_(_tokens);
248         uint256 _dividends                  = myDividends(false);
249         uint256 _taxedEthereum              = _ethereum;
250         
251         tokenSupply_                        = SafeMath.sub(tokenSupply_, _tokens);
252         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
253         
254         int256 _updatedPayouts              = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
255         payoutsTo_[_customerAddress]        -= _updatedPayouts;       
256         
257         if (tokenSupply_ > 0) {
258         
259             profitPerShare_                 = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
260         }
261         
262         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
263     }
264     
265     /**
266      * TRANSFER
267      */
268     function transfer(address _toAddress, uint256 _amountOfTokens) onlybelievers () public returns(bool) {
269         address _customerAddress            = msg.sender;
270         
271         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
272         
273         if(myDividends(true) > 0) withdraw();
274        
275        
276         uint256 _taxedTokens                = _amountOfTokens;
277         uint256 _dividends                  = myDividends(false);
278         
279         tokenSupply_                        = tokenSupply_;
280         
281         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
282         tokenBalanceLedger_[_toAddress]     = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
283        
284         payoutsTo_[_customerAddress]        -= (int256) (profitPerShare_ * _amountOfTokens);
285         payoutsTo_[_toAddress]              += (int256) (profitPerShare_ * _taxedTokens);
286        
287         profitPerShare_                     = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
288        
289         Transfer(_customerAddress, _toAddress, _taxedTokens);
290         return true;
291     }
292     
293     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
294     
295     function disableInitialStage() onlyAdministrator() public {
296         onlyAmbassadors                     = false;
297     }
298     
299     function changeStakePercent(uint8 stakePercent) onlyAdministrator() public {
300         stakePer_                           = stakePercent;
301     }
302     
303     function setAdministrator(bytes32 _identifier, bool _status) onlyAdministrator() public {
304         administrators[_identifier]         = _status;
305     }
306     
307     function setStakingRequirement(uint256 _amountOfTokens) onlyAdministrator() public {
308         stakingRequirement                  = _amountOfTokens;
309     }
310     
311     function setName(string _name) onlyAdministrator() public {
312         name                                = _name;
313     }
314     
315     function setSymbol(string _symbol) onlyAdministrator() public {
316         symbol                              = _symbol;
317     }
318     
319       
320     function withdrawDeveloperFees() external onlyAdministrator {
321         address _adminAddress   = msg.sender;
322         _adminAddress.transfer(developerBalance);
323         developerBalance        = 0;
324     }
325     
326     /*---------- CALCULATORS  ----------*/
327     
328     function totalEthereumBalance() public view returns(uint) {
329         return this.balance;
330     }
331    
332     function totalDeveloperBalance() public view returns(uint) {
333         return developerBalance;
334     }
335     
336     function totalSupply() public view returns(uint256) {
337         return tokenSupply_;
338     }
339     
340     
341     function myTokens() public view returns(uint256) {
342         address _customerAddress            = msg.sender;
343         return balanceOf(_customerAddress);
344     }
345     
346     
347     function myDividends(bool _includeReferralBonus) public view returns(uint256) {
348         address _customerAddress            = msg.sender;
349         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
350     }
351     
352    
353     function balanceOf(address _customerAddress) view public returns(uint256) {
354         return tokenBalanceLedger_[_customerAddress];
355     }
356     
357     
358     function dividendsOf(address _customerAddress) view public returns(uint256) {
359         return (uint256) ((int256)(profitPerShare_ * (tokenBalanceLedger_[_customerAddress] + stakeBalanceLedger_[_customerAddress])) - payoutsTo_[_customerAddress]) / magnitude;
360     }
361     
362    
363     function sellPrice() public view returns(uint256) {
364         if(tokenSupply_ == 0){
365             return tokenPriceInitial_       - tokenPriceDecremental_;
366         } else {
367             uint256 _ethereum               = tokensToEthereum_(1e18);
368             uint256 _taxedEthereum          = _ethereum;
369             return _taxedEthereum;
370         }
371     }
372     
373    
374     function buyPrice() public view returns(uint256) {
375         if(tokenSupply_ == 0){
376             return tokenPriceInitial_       + tokenPriceIncremental_;
377         } else {
378             uint256 _ethereum               = tokensToEthereum_(1e18);
379             uint256 untotalDeduct           = developerFee_ + referralPer_ + dividendFee_;
380             uint256 totalDeduct             = SafeMath.percent(_ethereum,untotalDeduct,100,18);
381             uint256 _taxedEthereum          = SafeMath.add(_ethereum, totalDeduct);
382             return _taxedEthereum;
383         }
384     }
385    
386     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns(uint256) {
387         uint256 untotalDeduct               = developerFee_ + referralPer_ + dividendFee_;
388         uint256 totalDeduct                 = SafeMath.percent(_ethereumToSpend,untotalDeduct,100,18);
389         uint256 _taxedEthereum              = SafeMath.sub(_ethereumToSpend, totalDeduct);
390         uint256 _amountOfTokens             = ethereumToTokens_(_taxedEthereum);
391         return _amountOfTokens;
392     }
393    
394     function calculateEthereumReceived(uint256 _tokensToSell) public view returns(uint256) {
395         require(_tokensToSell <= tokenSupply_);
396         uint256 _ethereum                   = tokensToEthereum_(_tokensToSell);
397         uint256 _taxedEthereum              = _ethereum;
398         return _taxedEthereum;
399     }
400     
401     function stakeTokens(uint256 _amountOfTokens) onlybelievers () public returns(bool){
402         address _customerAddress            = msg.sender;
403       
404         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
405         uint256 _amountOfTokensWith1Token   = SafeMath.sub(_amountOfTokens, 1e18);
406         stakingTime_[_customerAddress]      = now;
407         stakeBalanceLedger_[_customerAddress] = SafeMath.add(stakeBalanceLedger_[_customerAddress], _amountOfTokensWith1Token);
408         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokensWith1Token);
409     }
410     
411     
412     function stakeTokensBalance(address _customerAddress) public view returns(uint256){
413         uint256 timediff                    = SafeMath.sub(now, stakingTime_[_customerAddress]);
414         uint256 dayscount                   = SafeMath.div(timediff, 86400); //86400 Sec for 1 Day
415         uint256 roiPercent                  = SafeMath.mul(dayscount, stakePer_);
416         uint256 roiTokens                   = SafeMath.percent(stakeBalanceLedger_[_customerAddress],roiPercent,100,18);
417         uint256 finalBalance                = SafeMath.add(stakeBalanceLedger_[_customerAddress],roiTokens);
418         return finalBalance;
419     }
420     
421     function stakeTokensTime(address _customerAddress) public view returns(uint256){
422         return stakingTime_[_customerAddress];
423     }
424     
425     function releaseStake() onlybelievers () public returns(bool){
426         address _customerAddress            = msg.sender;
427     
428         require(!onlyAmbassadors && stakingTime_[_customerAddress] > 0);
429         uint256 _amountOfTokens             = stakeBalanceLedger_[_customerAddress];
430         uint256 timediff                    = SafeMath.sub(now, stakingTime_[_customerAddress]);
431         uint256 dayscount                   = SafeMath.div(timediff, 86400);
432         uint256 roiPercent                  = SafeMath.mul(dayscount, stakePer_);
433         uint256 roiTokens                   = SafeMath.percent(_amountOfTokens,roiPercent,100,18);
434         uint256 finalBalance                = SafeMath.add(_amountOfTokens,roiTokens);
435         
436     
437         tokenSupply_                        = SafeMath.add(tokenSupply_, roiTokens);
438     
439         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], finalBalance);
440         stakeBalanceLedger_[_customerAddress] = 0;
441         stakingTime_[_customerAddress]      = 0;
442         
443     }
444     
445     /*==========================================
446     =            INTERNAL FUNCTIONS            =
447     ==========================================*/
448     
449     uint256 developerFee;
450     uint256 incETH;
451     address _refAddress; 
452     uint256 _referralBonus;
453     
454     uint256 bonusLv1;
455     uint256 bonusLv2;
456     uint256 bonusLv3;
457     uint256 bonusLv4;
458     uint256 bonusLv5;
459     uint256 bonusLv6;
460     uint256 bonusLv7;
461     uint256 bonusLv8;
462     uint256 bonusLv9;
463     uint256 bonusLv10;
464     
465     address chkLv2;
466     address chkLv3;
467     address chkLv4;
468     address chkLv5;
469     address chkLv6;
470     address chkLv7;
471     address chkLv8;
472     address chkLv9;
473     address chkLv10;
474     
475     struct RefUserDetail {
476         address refUserAddress;
477         uint256 refLevel;
478     }
479 
480     mapping(address => mapping (uint => RefUserDetail)) public RefUser;
481     mapping(address => uint256) public referralCount_;
482     
483     function getDownlineRef(address senderAddress, uint dataId) external view returns (address,uint) { 
484         return (RefUser[senderAddress][dataId].refUserAddress,RefUser[senderAddress][dataId].refLevel);
485     }
486     
487     function addDownlineRef(address senderAddress, address refUserAddress, uint refLevel) internal {
488         referralCount_[senderAddress]++;
489         uint dataId = referralCount_[senderAddress];
490         RefUser[senderAddress][dataId].refUserAddress = refUserAddress;
491         RefUser[senderAddress][dataId].refLevel = refLevel;
492     }
493 
494     function getref(address _customerAddress, uint _level) public view returns(address lv) {
495         if(_level == 1) {
496             lv = referralLevel1Address[_customerAddress];
497         } else if(_level == 2) {
498             lv = referralLevel2Address[_customerAddress];
499         } else if(_level == 3) {
500             lv = referralLevel3Address[_customerAddress];
501         } else if(_level == 4) {
502             lv = referralLevel4Address[_customerAddress];
503         } else if(_level == 5) {
504             lv = referralLevel5Address[_customerAddress];
505         } else if(_level == 6) {
506             lv = referralLevel6Address[_customerAddress];
507         } else if(_level == 7) {
508             lv = referralLevel7Address[_customerAddress];
509         } else if(_level == 8) {
510             lv = referralLevel8Address[_customerAddress];
511         } else if(_level == 9) {
512             lv = referralLevel9Address[_customerAddress];
513         } else if(_level == 10) {
514             lv = referralLevel10Address[_customerAddress];
515         } 
516         return lv;
517     }
518     
519     function distributeRefBonus(uint256 _incomingEthereum, address _referredBy, address _sender, bool _newReferral) internal {
520         address _customerAddress        = _sender;
521         uint256 remainingRefBonus       = _incomingEthereum;
522         _referralBonus                  = _incomingEthereum;
523         
524         bonusLv1                        = SafeMath.percent(_referralBonus,35,100,18);
525         bonusLv2                        = SafeMath.percent(_referralBonus,25,100,18);
526         bonusLv3                        = SafeMath.percent(_referralBonus,10,100,18);
527         bonusLv4                        = SafeMath.percent(_referralBonus,5,100,18);
528         bonusLv5                        = SafeMath.percent(_referralBonus,3,100,18);
529         bonusLv6                        = SafeMath.percent(_referralBonus,2,100,18);
530         bonusLv7                        = SafeMath.percent(_referralBonus,2,100,18);
531         bonusLv8                        = SafeMath.percent(_referralBonus,2,100,18);
532         bonusLv9                        = SafeMath.percent(_referralBonus,1,100,18);
533         bonusLv10                       = SafeMath.percent(_referralBonus,1,100,18);
534         
535       
536         referralLevel1Address[_customerAddress]                     = _referredBy;
537         referralBalance_[referralLevel1Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel1Address[_customerAddress]], bonusLv1);
538         remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv1);
539         if(_newReferral == true) {
540             addDownlineRef(_referredBy, _customerAddress, 1);
541         }
542         
543         chkLv2                          = referralLevel1Address[_referredBy];
544         chkLv3                          = referralLevel2Address[_referredBy];
545         chkLv4                          = referralLevel3Address[_referredBy];
546         chkLv5                          = referralLevel4Address[_referredBy];
547         chkLv6                          = referralLevel5Address[_referredBy];
548         chkLv7                          = referralLevel6Address[_referredBy];
549         chkLv8                          = referralLevel7Address[_referredBy];
550         chkLv9                          = referralLevel8Address[_referredBy];
551         chkLv10                         = referralLevel9Address[_referredBy];
552         
553       
554         if(chkLv2 != 0x0000000000000000000000000000000000000000) {
555             referralLevel2Address[_customerAddress]                     = referralLevel1Address[_referredBy];
556             referralBalance_[referralLevel2Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel2Address[_customerAddress]], bonusLv2);
557             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv2);
558             if(_newReferral == true) {
559                 addDownlineRef(referralLevel1Address[_referredBy], _customerAddress, 2);
560             }
561         }
562         
563       
564         if(chkLv3 != 0x0000000000000000000000000000000000000000) {
565             referralLevel3Address[_customerAddress]                     = referralLevel2Address[_referredBy];
566             referralBalance_[referralLevel3Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel3Address[_customerAddress]], bonusLv3);
567             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv3);
568             if(_newReferral == true) {
569                 addDownlineRef(referralLevel2Address[_referredBy], _customerAddress, 3);
570             }
571         }
572         
573       
574         if(chkLv4 != 0x0000000000000000000000000000000000000000) {
575             referralLevel4Address[_customerAddress]                     = referralLevel3Address[_referredBy];
576             referralBalance_[referralLevel4Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel4Address[_customerAddress]], bonusLv4);
577             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv4);
578             if(_newReferral == true) {
579                 addDownlineRef(referralLevel3Address[_referredBy], _customerAddress, 4);
580             }
581         }
582         
583       
584         if(chkLv5 != 0x0000000000000000000000000000000000000000) {
585             referralLevel5Address[_customerAddress]                     = referralLevel4Address[_referredBy];
586             referralBalance_[referralLevel5Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel5Address[_customerAddress]], bonusLv5);
587             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv5);
588             if(_newReferral == true) {
589                 addDownlineRef(referralLevel4Address[_referredBy], _customerAddress, 5);
590             }
591         }
592         
593       
594         if(chkLv6 != 0x0000000000000000000000000000000000000000) {
595             referralLevel6Address[_customerAddress]                     = referralLevel5Address[_referredBy];
596             referralBalance_[referralLevel6Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel6Address[_customerAddress]], bonusLv6);
597             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv6);
598             if(_newReferral == true) {
599                 addDownlineRef(referralLevel5Address[_referredBy], _customerAddress, 6);
600             }
601         }
602         
603         
604         if(chkLv7 != 0x0000000000000000000000000000000000000000) {
605             referralLevel7Address[_customerAddress]                     = referralLevel6Address[_referredBy];
606             referralBalance_[referralLevel7Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel7Address[_customerAddress]], bonusLv7);
607             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv7);
608             if(_newReferral == true) {
609                 addDownlineRef(referralLevel6Address[_referredBy], _customerAddress, 7);
610             }
611         }
612         
613         
614         if(chkLv8 != 0x0000000000000000000000000000000000000000) {
615             referralLevel8Address[_customerAddress]                     = referralLevel7Address[_referredBy];
616             referralBalance_[referralLevel8Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel8Address[_customerAddress]], bonusLv8);
617             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv8);
618             if(_newReferral == true) {
619                 addDownlineRef(referralLevel7Address[_referredBy], _customerAddress, 8);
620             }
621         }
622         
623         
624         if(chkLv9 != 0x0000000000000000000000000000000000000000) {
625             referralLevel9Address[_customerAddress]                     = referralLevel8Address[_referredBy];
626             referralBalance_[referralLevel9Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel9Address[_customerAddress]], bonusLv9);
627             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv9);
628             if(_newReferral == true) {
629                 addDownlineRef(referralLevel8Address[_referredBy], _customerAddress, 9);
630             }
631         }
632         
633        
634         if(chkLv10 != 0x0000000000000000000000000000000000000000) {
635             referralLevel10Address[_customerAddress]                    = referralLevel9Address[_referredBy];
636             referralBalance_[referralLevel10Address[_customerAddress]]  = SafeMath.add(referralBalance_[referralLevel10Address[_customerAddress]], bonusLv10);
637             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv10);
638             if(_newReferral == true) {
639                 addDownlineRef(referralLevel9Address[_referredBy], _customerAddress, 10);
640             }
641         }
642         
643         developerBalance                    = SafeMath.add(developerBalance, remainingRefBonus);
644     }
645 
646     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) antiEarlyWhale(_incomingEthereum) internal returns(uint256) {
647         
648         address _customerAddress            = msg.sender;
649         incETH                              = _incomingEthereum;
650        
651         developerFee                        = SafeMath.percent(incETH,developerFee_,100,18);
652         developerBalance                    = SafeMath.add(developerBalance, developerFee);
653         
654         _referralBonus                      = SafeMath.percent(incETH,referralPer_,100,18);
655         
656         uint256 _dividends                  = SafeMath.percent(incETH,dividendFee_,100,18);
657         
658         uint256 untotalDeduct               = developerFee_ + referralPer_ + dividendFee_;
659         uint256 totalDeduct                 = SafeMath.percent(incETH,untotalDeduct,100,18);
660         
661         uint256 _taxedEthereum              = SafeMath.sub(incETH, totalDeduct);
662         uint256 _amountOfTokens             = ethereumToTokens_(_taxedEthereum);
663         uint256 _fee                        = _dividends * magnitude;
664         bool    _newReferral                = true;
665         if(referralLevel1Address[_customerAddress] != 0x0000000000000000000000000000000000000000) {
666             _referredBy                     = referralLevel1Address[_customerAddress];
667             _newReferral                    = false;
668         }
669         
670         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
671         
672         if(
673            
674             _referredBy != 0x0000000000000000000000000000000000000000 &&
675            
676             _referredBy != _customerAddress &&
677             tokenBalanceLedger_[_referredBy] >= stakingRequirement
678         ){
679             
680             distributeRefBonus(_referralBonus,_referredBy,_customerAddress,_newReferral);
681         } else {
682            
683             developerBalance                = SafeMath.add(developerBalance, _referralBonus);
684         }
685        
686         if(tokenSupply_ > 0){
687            
688             tokenSupply_                    = SafeMath.add(tokenSupply_, _amountOfTokens);
689            
690             profitPerShare_                 += (_dividends * magnitude / (tokenSupply_));
691             
692             _fee                            = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
693         } else {
694             
695             tokenSupply_                    = _amountOfTokens;
696         }
697         
698         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
699         int256 _updatedPayouts              = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
700         payoutsTo_[_customerAddress]        += _updatedPayouts;
701        
702         onTokenPurchase(_customerAddress, incETH, _amountOfTokens, _referredBy);
703         return _amountOfTokens;
704     }
705 
706    
707     function ethereumToTokens_(uint256 _ethereum) internal view returns(uint256) {
708         uint256 _tokenPriceInitial          = tokenPriceInitial_ * 1e18;
709         uint256 _tokensReceived             = 
710          (
711             (
712                 SafeMath.sub(
713                     (sqrt
714                         (
715                             (_tokenPriceInitial**2)
716                             +
717                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
718                             +
719                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
720                             +
721                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
722                         )
723                     ), _tokenPriceInitial
724                 )
725             )/(tokenPriceIncremental_)
726         )-(tokenSupply_)
727         ;
728 
729         return _tokensReceived;
730     }
731     
732     
733      function tokensToEthereum_(uint256 _tokens) internal view returns(uint256) {
734         uint256 tokens_                     = (_tokens + 1e18);
735         uint256 _tokenSupply                = (tokenSupply_ + 1e18);
736         uint256 _etherReceived              =
737         (
738             SafeMath.sub(
739                 (
740                     (
741                         (
742                             tokenPriceInitial_ +(tokenPriceDecremental_ * (_tokenSupply/1e18))
743                         )-tokenPriceDecremental_
744                     )*(tokens_ - 1e18)
745                 ),(tokenPriceDecremental_*((tokens_**2-tokens_)/1e18))/2
746             )
747         /1e18);
748         return _etherReceived;
749     }
750     
751     function sqrt(uint x) internal pure returns (uint y) {
752         uint z = (x + 1) / 2;
753         y = x;
754         while (z < y) {
755             y = z;
756             z = (x / z + z) / 2;
757         }
758     }
759     
760 }