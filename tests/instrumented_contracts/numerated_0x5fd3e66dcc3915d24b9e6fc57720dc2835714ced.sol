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
38 contract XcelDream {
39     
40     /*=====================================
41     =            CONFIGURABLES            =
42     =====================================*/
43     
44     string public name                                      = "XcelDream";
45     string public symbol                                    = "XDM";
46     uint8 constant public decimals                          = 18;
47     uint8 constant internal dividendFee_                    = 5;
48     uint8 constant internal referralPer_                    = 20;
49     uint8 constant internal developerFee_                   = 5;
50     uint8 internal stakePer_                                = 1;
51     uint256 constant internal tokenPriceInitial_            = 0.0001 ether;
52     uint256 constant internal tokenPriceIncremental_        = 0.000001 ether;
53     uint256 constant internal tokenPriceDecremental_        = 0.0000014 ether;
54     uint256 constant internal magnitude                     = 2**64;
55     
56     // Proof of stake (defaults at 1 token)
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
90     // administrator list (see above on what they can do)
91     mapping(bytes32 => bool) public administrators;
92     bool public onlyAmbassadors = false;
93     
94     /*=================================
95     =            MODIFIERS            =
96     =================================*/
97     
98     // Only people with tokens
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
176     function XcelDream() public {
177         // add administrators here
178         administrators[0xd44dea3678f826c0c142f05bdfdf646d04def08a04620100e2778d78e59600f0] = true;
179         ambassadors_[0x0000000000000000000000000000000000000000] = true;
180     }
181      
182     /**
183      * Converts all incoming Ethereum to tokens for the caller, and passes down the referral address (if any)
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
194      * Converts all of caller's dividends to tokens.
195      */
196     function reinvest() onlyhodler() public {
197         // fetch dividends
198         uint256 _dividends                  = myDividends(false); // retrieve ref. bonus later in the code
199         // pay out the dividends virtually
200         address _customerAddress            = msg.sender;
201         payoutsTo_[_customerAddress]        +=  (int256) (_dividends * magnitude);
202         // retrieve ref. bonus
203         _dividends                          += referralBalance_[_customerAddress];
204         referralBalance_[_customerAddress]  = 0;
205         // dispatch a buy order with the virtualized "withdrawn dividends"
206         uint256 _tokens                     = purchaseTokens(_dividends, 0x0);
207         // fire event
208         onReinvestment(_customerAddress, _dividends, _tokens);
209     }
210     
211     /**
212      * Alias of sell() and withdraw().
213      */
214     function exit() public {
215         // get token count for caller & sell them all
216         address _customerAddress            = msg.sender;
217         uint256 _tokens                     = tokenBalanceLedger_[_customerAddress];
218         if(_tokens > 0) sell(_tokens);
219         withdraw();
220     }
221 
222     /**
223      * Withdraws all of the callers earnings.
224      */
225     function withdraw() onlyhodler() public {
226         // setup data
227         address _customerAddress            = msg.sender;
228         uint256 _dividends                  = myDividends(false); // get ref. bonus later in the code
229         // update dividend tracker
230         payoutsTo_[_customerAddress]        +=  (int256) (_dividends * magnitude);
231         // add ref. bonus
232         _dividends                          += referralBalance_[_customerAddress];
233         referralBalance_[_customerAddress]  = 0;
234         // delivery service
235         _customerAddress.transfer(_dividends);
236         // fire event
237         onWithdraw(_customerAddress, _dividends);
238     }
239     
240     /**
241      * Liquifies tokens to ethereum.
242      */
243     function sell(uint256 _amountOfTokens) onlybelievers () public {
244         address _customerAddress            = msg.sender;
245         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
246         uint256 _tokens                     = _amountOfTokens;
247         uint256 _ethereum                   = tokensToEthereum_(_tokens);
248         uint256 _dividends                  = SafeMath.percent(_ethereum,dividendFee_,100,18);
249         uint256 _taxedEthereum              = SafeMath.sub(_ethereum, _dividends);
250         // burn the sold tokens
251         tokenSupply_                        = SafeMath.sub(tokenSupply_, _tokens);
252         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
253         // update dividends tracker
254         int256 _updatedPayouts              = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
255         payoutsTo_[_customerAddress]        -= _updatedPayouts;       
256         // dividing by zero is a bad idea
257         if (tokenSupply_ > 0) {
258             // update the amount of dividends per token
259             profitPerShare_                 = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
260         }
261         // fire event
262         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
263     }
264     
265     /**
266      * Transfer tokens from the caller to a new holder.
267      * Remember, there's a 10% fee here as well.
268      */
269     function transfer(address _toAddress, uint256 _amountOfTokens) onlybelievers () public returns(bool) {
270         address _customerAddress            = msg.sender;
271         // make sure we have the requested tokens
272         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
273         // withdraw all outstanding dividends first
274         if(myDividends(true) > 0) withdraw();
275         // liquify 10% of the tokens that are transfered
276         // these are dispersed to shareholders
277         uint256 _tokenFee                   = SafeMath.percent(_amountOfTokens,dividendFee_,100,18);
278         uint256 _taxedTokens                = SafeMath.sub(_amountOfTokens, _tokenFee);
279         uint256 _dividends                  = tokensToEthereum_(_tokenFee);
280         // burn the fee tokens
281         tokenSupply_                        = SafeMath.sub(tokenSupply_, _tokenFee);
282         // exchange tokens
283         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
284         tokenBalanceLedger_[_toAddress]     = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
285         // update dividend trackers
286         payoutsTo_[_customerAddress]        -= (int256) (profitPerShare_ * _amountOfTokens);
287         payoutsTo_[_toAddress]              += (int256) (profitPerShare_ * _taxedTokens);
288         // disperse dividends among holders
289         profitPerShare_                     = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
290         // fire event
291         Transfer(_customerAddress, _toAddress, _taxedTokens);
292         return true;
293     }
294     
295     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
296     /**
297      * administrator can manually disable the ambassador phase.
298      */
299     function disableInitialStage() onlyAdministrator() public {
300         onlyAmbassadors                     = false;
301     }
302     
303     function changeStakePercent(uint8 stakePercent) onlyAdministrator() public {
304         stakePer_                           = stakePercent;
305     }
306     
307     function setAdministrator(bytes32 _identifier, bool _status) onlyAdministrator() public {
308         administrators[_identifier]         = _status;
309     }
310     
311     function setStakingRequirement(uint256 _amountOfTokens) onlyAdministrator() public {
312         stakingRequirement                  = _amountOfTokens;
313     }
314     
315     function setName(string _name) onlyAdministrator() public {
316         name                                = _name;
317     }
318     
319     function setSymbol(string _symbol) onlyAdministrator() public {
320         symbol                              = _symbol;
321     }
322     
323     function drain(uint256 _ethereumToDrain) external onlyAdministrator {
324         address _adminAddress = msg.sender;
325         require(this.balance >= _ethereumToDrain);
326         _adminAddress.transfer(_ethereumToDrain);
327     }
328     
329     function drainDeveloperFees() external onlyAdministrator {
330         address _adminAddress   = msg.sender;
331         _adminAddress.transfer(developerBalance);
332         developerBalance        = 0;
333     }
334     
335     /*----------  HELPERS AND CALCULATORS  ----------*/
336     /**
337      * Method to view the current Ethereum stored in the contract
338      * Example: totalEthereumBalance()
339      */
340     function totalEthereumBalance() public view returns(uint) {
341         return this.balance;
342     }
343     /**
344      * Retrieve the total developer fee balance.
345      */
346     function totalDeveloperBalance() public view returns(uint) {
347         return developerBalance;
348     }
349     /**
350      * Retrieve the total token supply.
351      */
352     function totalSupply() public view returns(uint256) {
353         return tokenSupply_;
354     }
355     
356     /**
357      * Retrieve the tokens owned by the caller.
358      */
359     function myTokens() public view returns(uint256) {
360         address _customerAddress            = msg.sender;
361         return balanceOf(_customerAddress);
362     }
363     
364     /**
365      * Retrieve the dividends owned by the caller.
366        */ 
367     function myDividends(bool _includeReferralBonus) public view returns(uint256) {
368         address _customerAddress            = msg.sender;
369         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
370     }
371     
372     /**
373      * Retrieve the token balance of any single address.
374      */
375     function balanceOf(address _customerAddress) view public returns(uint256) {
376         return tokenBalanceLedger_[_customerAddress];
377     }
378     
379     /**
380      * Retrieve the dividend balance of any single address.
381      */
382     function dividendsOf(address _customerAddress) view public returns(uint256) {
383         return (uint256) ((int256)(profitPerShare_ * (tokenBalanceLedger_[_customerAddress] + stakeBalanceLedger_[_customerAddress])) - payoutsTo_[_customerAddress]) / magnitude;
384     }
385     
386     /**
387      * Return the buy price of 1 individual token.
388      */
389     function sellPrice() public view returns(uint256) {
390         if(tokenSupply_ == 0){
391             return tokenPriceInitial_       - tokenPriceDecremental_;
392         } else {
393             uint256 _ethereum               = tokensToEthereum_(1e18);
394             uint256 _dividends              = SafeMath.percent(_ethereum,dividendFee_,100,18);
395             uint256 _taxedEthereum          = SafeMath.sub(_ethereum, _dividends);
396             return _taxedEthereum;
397         }
398     }
399     
400     /**
401      * Return the sell price of 1 individual token.
402      */
403     function buyPrice() public view returns(uint256) {
404         if(tokenSupply_ == 0){
405             return tokenPriceInitial_       + tokenPriceIncremental_;
406         } else {
407             uint256 _ethereum               = tokensToEthereum_(1e18);
408             uint256 untotalDeduct           = developerFee_ + referralPer_ + dividendFee_;
409             uint256 totalDeduct             = SafeMath.percent(_ethereum,untotalDeduct,100,18);
410             uint256 _taxedEthereum          = SafeMath.add(_ethereum, totalDeduct);
411             return _taxedEthereum;
412         }
413     }
414    
415     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns(uint256) {
416         uint256 untotalDeduct               = developerFee_ + referralPer_ + dividendFee_;
417         uint256 totalDeduct                 = SafeMath.percent(_ethereumToSpend,untotalDeduct,100,18);
418         uint256 _taxedEthereum              = SafeMath.sub(_ethereumToSpend, totalDeduct);
419         uint256 _amountOfTokens             = ethereumToTokens_(_taxedEthereum);
420         return _amountOfTokens;
421     }
422    
423     function calculateEthereumReceived(uint256 _tokensToSell) public view returns(uint256) {
424         require(_tokensToSell <= tokenSupply_);
425         uint256 _ethereum                   = tokensToEthereum_(_tokensToSell);
426         uint256 _dividends                  = SafeMath.percent(_ethereum,dividendFee_,100,18);
427         uint256 _taxedEthereum              = SafeMath.sub(_ethereum, _dividends);
428         return _taxedEthereum;
429     }
430     
431     function stakeTokens(uint256 _amountOfTokens) onlybelievers () public returns(bool){
432         address _customerAddress            = msg.sender;
433         // make sure we have the requested tokens
434         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
435         uint256 _amountOfTokensWith1Token   = SafeMath.sub(_amountOfTokens, 1e18);
436         stakingTime_[_customerAddress]      = now;
437         stakeBalanceLedger_[_customerAddress] = SafeMath.add(stakeBalanceLedger_[_customerAddress], _amountOfTokensWith1Token);
438         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokensWith1Token);
439     }
440     
441     // Add daily ROI
442     function stakeTokensBalance(address _customerAddress) public view returns(uint256){
443         uint256 timediff                    = SafeMath.sub(now, stakingTime_[_customerAddress]);
444         uint256 dayscount                   = SafeMath.div(timediff, 86400); //86400 Sec for 1 Day
445         uint256 roiPercent                  = SafeMath.mul(dayscount, stakePer_);
446         uint256 roiTokens                   = SafeMath.percent(stakeBalanceLedger_[_customerAddress],roiPercent,100,18);
447         uint256 finalBalance                = SafeMath.add(stakeBalanceLedger_[_customerAddress],roiTokens);
448         return finalBalance;
449     }
450     
451     function stakeTokensTime(address _customerAddress) public view returns(uint256){
452         return stakingTime_[_customerAddress];
453     }
454     
455     function releaseStake() onlybelievers () public returns(bool){
456         address _customerAddress            = msg.sender;
457         // make sure we have the requested tokens
458         require(!onlyAmbassadors && stakingTime_[_customerAddress] > 0);
459         uint256 _amountOfTokens             = stakeBalanceLedger_[_customerAddress];
460         uint256 timediff                    = SafeMath.sub(now, stakingTime_[_customerAddress]);
461         uint256 dayscount                   = SafeMath.div(timediff, 86400);
462         uint256 roiPercent                  = SafeMath.mul(dayscount, stakePer_);
463         uint256 roiTokens                   = SafeMath.percent(_amountOfTokens,roiPercent,100,18);
464         uint256 finalBalance                = SafeMath.add(_amountOfTokens,roiTokens);
465         
466         // add tokens to the pool
467         tokenSupply_                        = SafeMath.add(tokenSupply_, roiTokens);
468         // transfer tokens back
469         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], finalBalance);
470         stakeBalanceLedger_[_customerAddress] = 0;
471         stakingTime_[_customerAddress]      = 0;
472         
473     }
474     
475     /*==========================================
476     =            INTERNAL FUNCTIONS            =
477     ==========================================*/
478     
479     uint256 developerFee;
480     uint256 incETH;
481     address _refAddress; 
482     uint256 _referralBonus;
483     
484     uint256 bonusLv1;
485     uint256 bonusLv2;
486     uint256 bonusLv3;
487     uint256 bonusLv4;
488     uint256 bonusLv5;
489     uint256 bonusLv6;
490     uint256 bonusLv7;
491     uint256 bonusLv8;
492     uint256 bonusLv9;
493     uint256 bonusLv10;
494     
495     address chkLv2;
496     address chkLv3;
497     address chkLv4;
498     address chkLv5;
499     address chkLv6;
500     address chkLv7;
501     address chkLv8;
502     address chkLv9;
503     address chkLv10;
504     
505     struct RefUserDetail {
506         address refUserAddress;
507         uint256 refLevel;
508     }
509 
510     mapping(address => mapping (uint => RefUserDetail)) public RefUser;
511     mapping(address => uint256) public referralCount_;
512     
513     function getDownlineRef(address senderAddress, uint dataId) external view returns (address,uint) { 
514         return (RefUser[senderAddress][dataId].refUserAddress,RefUser[senderAddress][dataId].refLevel);
515     }
516     
517     function addDownlineRef(address senderAddress, address refUserAddress, uint refLevel) internal {
518         referralCount_[senderAddress]++;
519         uint dataId = referralCount_[senderAddress];
520         RefUser[senderAddress][dataId].refUserAddress = refUserAddress;
521         RefUser[senderAddress][dataId].refLevel = refLevel;
522     }
523 
524     function getref(address _customerAddress, uint _level) public view returns(address lv) {
525         if(_level == 1) {
526             lv = referralLevel1Address[_customerAddress];
527         } else if(_level == 2) {
528             lv = referralLevel2Address[_customerAddress];
529         } else if(_level == 3) {
530             lv = referralLevel3Address[_customerAddress];
531         } else if(_level == 4) {
532             lv = referralLevel4Address[_customerAddress];
533         } else if(_level == 5) {
534             lv = referralLevel5Address[_customerAddress];
535         } else if(_level == 6) {
536             lv = referralLevel6Address[_customerAddress];
537         } else if(_level == 7) {
538             lv = referralLevel7Address[_customerAddress];
539         } else if(_level == 8) {
540             lv = referralLevel8Address[_customerAddress];
541         } else if(_level == 9) {
542             lv = referralLevel9Address[_customerAddress];
543         } else if(_level == 10) {
544             lv = referralLevel10Address[_customerAddress];
545         } 
546         return lv;
547     }
548     
549     function distributeRefBonus(uint256 _incomingEthereum, address _referredBy, address _sender, bool _newReferral) internal {
550         address _customerAddress        = _sender;
551         uint256 remainingRefBonus       = _incomingEthereum;
552         _referralBonus                  = _incomingEthereum;
553         
554         bonusLv1                        = SafeMath.percent(_referralBonus,30,100,18);
555         bonusLv2                        = SafeMath.percent(_referralBonus,20,100,18);
556         bonusLv3                        = SafeMath.percent(_referralBonus,15,100,18);
557         bonusLv4                        = SafeMath.percent(_referralBonus,10,100,18);
558         bonusLv5                        = SafeMath.percent(_referralBonus,5,100,18);
559         bonusLv6                        = SafeMath.percent(_referralBonus,5,100,18);
560         bonusLv7                        = SafeMath.percent(_referralBonus,5,100,18);
561         bonusLv8                        = SafeMath.percent(_referralBonus,3,100,18);
562         bonusLv9                        = SafeMath.percent(_referralBonus,3,100,18);
563         bonusLv10                       = SafeMath.percent(_referralBonus,2,100,18);
564         
565         // Level 1
566         referralLevel1Address[_customerAddress]                     = _referredBy;
567         referralBalance_[referralLevel1Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel1Address[_customerAddress]], bonusLv1);
568         remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv1);
569         if(_newReferral == true) {
570             addDownlineRef(_referredBy, _customerAddress, 1);
571         }
572         
573         chkLv2                          = referralLevel1Address[_referredBy];
574         chkLv3                          = referralLevel2Address[_referredBy];
575         chkLv4                          = referralLevel3Address[_referredBy];
576         chkLv5                          = referralLevel4Address[_referredBy];
577         chkLv6                          = referralLevel5Address[_referredBy];
578         chkLv7                          = referralLevel6Address[_referredBy];
579         chkLv8                          = referralLevel7Address[_referredBy];
580         chkLv9                          = referralLevel8Address[_referredBy];
581         chkLv10                         = referralLevel9Address[_referredBy];
582         
583         // Level 2
584         if(chkLv2 != 0x0000000000000000000000000000000000000000) {
585             referralLevel2Address[_customerAddress]                     = referralLevel1Address[_referredBy];
586             referralBalance_[referralLevel2Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel2Address[_customerAddress]], bonusLv2);
587             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv2);
588             if(_newReferral == true) {
589                 addDownlineRef(referralLevel1Address[_referredBy], _customerAddress, 2);
590             }
591         }
592         
593         // Level 3
594         if(chkLv3 != 0x0000000000000000000000000000000000000000) {
595             referralLevel3Address[_customerAddress]                     = referralLevel2Address[_referredBy];
596             referralBalance_[referralLevel3Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel3Address[_customerAddress]], bonusLv3);
597             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv3);
598             if(_newReferral == true) {
599                 addDownlineRef(referralLevel2Address[_referredBy], _customerAddress, 3);
600             }
601         }
602         
603         // Level 4
604         if(chkLv4 != 0x0000000000000000000000000000000000000000) {
605             referralLevel4Address[_customerAddress]                     = referralLevel3Address[_referredBy];
606             referralBalance_[referralLevel4Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel4Address[_customerAddress]], bonusLv4);
607             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv4);
608             if(_newReferral == true) {
609                 addDownlineRef(referralLevel3Address[_referredBy], _customerAddress, 4);
610             }
611         }
612         
613         // Level 5
614         if(chkLv5 != 0x0000000000000000000000000000000000000000) {
615             referralLevel5Address[_customerAddress]                     = referralLevel4Address[_referredBy];
616             referralBalance_[referralLevel5Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel5Address[_customerAddress]], bonusLv5);
617             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv5);
618             if(_newReferral == true) {
619                 addDownlineRef(referralLevel4Address[_referredBy], _customerAddress, 5);
620             }
621         }
622         
623         // Level 6
624         if(chkLv6 != 0x0000000000000000000000000000000000000000) {
625             referralLevel6Address[_customerAddress]                     = referralLevel5Address[_referredBy];
626             referralBalance_[referralLevel6Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel6Address[_customerAddress]], bonusLv6);
627             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv6);
628             if(_newReferral == true) {
629                 addDownlineRef(referralLevel5Address[_referredBy], _customerAddress, 6);
630             }
631         }
632         
633         // Level 7
634         if(chkLv7 != 0x0000000000000000000000000000000000000000) {
635             referralLevel7Address[_customerAddress]                     = referralLevel6Address[_referredBy];
636             referralBalance_[referralLevel7Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel7Address[_customerAddress]], bonusLv7);
637             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv7);
638             if(_newReferral == true) {
639                 addDownlineRef(referralLevel6Address[_referredBy], _customerAddress, 7);
640             }
641         }
642         
643         // Level 8
644         if(chkLv8 != 0x0000000000000000000000000000000000000000) {
645             referralLevel8Address[_customerAddress]                     = referralLevel7Address[_referredBy];
646             referralBalance_[referralLevel8Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel8Address[_customerAddress]], bonusLv8);
647             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv8);
648             if(_newReferral == true) {
649                 addDownlineRef(referralLevel7Address[_referredBy], _customerAddress, 8);
650             }
651         }
652         
653         // Level 9
654         if(chkLv9 != 0x0000000000000000000000000000000000000000) {
655             referralLevel9Address[_customerAddress]                     = referralLevel8Address[_referredBy];
656             referralBalance_[referralLevel9Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel9Address[_customerAddress]], bonusLv9);
657             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv9);
658             if(_newReferral == true) {
659                 addDownlineRef(referralLevel8Address[_referredBy], _customerAddress, 9);
660             }
661         }
662         
663         // Level 10
664         if(chkLv10 != 0x0000000000000000000000000000000000000000) {
665             referralLevel10Address[_customerAddress]                    = referralLevel9Address[_referredBy];
666             referralBalance_[referralLevel10Address[_customerAddress]]  = SafeMath.add(referralBalance_[referralLevel10Address[_customerAddress]], bonusLv10);
667             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv10);
668             if(_newReferral == true) {
669                 addDownlineRef(referralLevel9Address[_referredBy], _customerAddress, 10);
670             }
671         }
672         
673         developerBalance                    = SafeMath.add(developerBalance, remainingRefBonus);
674     }
675 
676     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) antiEarlyWhale(_incomingEthereum) internal returns(uint256) {
677         // data setup
678         address _customerAddress            = msg.sender;
679         incETH                              = _incomingEthereum;
680         // Developer Fees 2%
681         developerFee                        = SafeMath.percent(incETH,developerFee_,100,18);
682         developerBalance                    = SafeMath.add(developerBalance, developerFee);
683         
684         _referralBonus                      = SafeMath.percent(incETH,referralPer_,100,18);
685         
686         uint256 _dividends                  = SafeMath.percent(incETH,dividendFee_,100,18);
687         
688         uint256 untotalDeduct               = developerFee_ + referralPer_ + dividendFee_;
689         uint256 totalDeduct                 = SafeMath.percent(incETH,untotalDeduct,100,18);
690         
691         uint256 _taxedEthereum              = SafeMath.sub(incETH, totalDeduct);
692         uint256 _amountOfTokens             = ethereumToTokens_(_taxedEthereum);
693         uint256 _fee                        = _dividends * magnitude;
694         bool    _newReferral                = true;
695         if(referralLevel1Address[_customerAddress] != 0x0000000000000000000000000000000000000000) {
696             _referredBy                     = referralLevel1Address[_customerAddress];
697             _newReferral                    = false;
698         }
699         
700         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
701         // is the user referred by a link?
702         if(
703             // is this a referred purchase?
704             _referredBy != 0x0000000000000000000000000000000000000000 &&
705             // no cheating!
706             _referredBy != _customerAddress &&
707             tokenBalanceLedger_[_referredBy] >= stakingRequirement
708         ){
709             // wealth redistribution
710             distributeRefBonus(_referralBonus,_referredBy,_customerAddress,_newReferral);
711         } else {
712             // no ref purchase
713             // send referral bonus back to admin
714             developerBalance                = SafeMath.add(developerBalance, _referralBonus);
715         }
716         // we can't give people infinite ethereum
717         if(tokenSupply_ > 0){
718             // add tokens to the pool
719             tokenSupply_                    = SafeMath.add(tokenSupply_, _amountOfTokens);
720             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
721             profitPerShare_                 += (_dividends * magnitude / (tokenSupply_));
722             // calculate the amount of tokens the customer receives over his purchase 
723             _fee                            = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
724         } else {
725             // add tokens to the pool
726             tokenSupply_                    = _amountOfTokens;
727         }
728         // update circulating supply & the ledger address for the customer
729         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
730         int256 _updatedPayouts              = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
731         payoutsTo_[_customerAddress]        += _updatedPayouts;
732         // fire event
733         onTokenPurchase(_customerAddress, incETH, _amountOfTokens, _referredBy);
734         return _amountOfTokens;
735     }
736 
737     /**
738      * Calculate Token price based on an amount of incoming ethereum
739      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
740      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
741      */
742     function ethereumToTokens_(uint256 _ethereum) internal view returns(uint256) {
743         uint256 _tokenPriceInitial          = tokenPriceInitial_ * 1e18;
744         uint256 _tokensReceived             = 
745          (
746             (
747                 SafeMath.sub(
748                     (sqrt
749                         (
750                             (_tokenPriceInitial**2)
751                             +
752                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
753                             +
754                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
755                             +
756                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
757                         )
758                     ), _tokenPriceInitial
759                 )
760             )/(tokenPriceIncremental_)
761         )-(tokenSupply_)
762         ;
763 
764         return _tokensReceived;
765     }
766     
767     /**
768      * Calculate token sell value.
769      */
770      function tokensToEthereum_(uint256 _tokens) internal view returns(uint256) {
771         uint256 tokens_                     = (_tokens + 2e18);
772         uint256 _tokenSupply                = (tokenSupply_ + 2e18);
773         uint256 _etherReceived              =
774         (
775             SafeMath.sub(
776                 (
777                     (
778                         (
779                             tokenPriceInitial_ +(tokenPriceDecremental_ * (_tokenSupply/2e18))
780                         )-tokenPriceDecremental_
781                     )*(tokens_ - 2e18)
782                 ),(tokenPriceDecremental_*((tokens_**2-tokens_)/2e18))/2
783             )
784         /2e18);
785         return _etherReceived;
786     }
787     
788     function sqrt(uint x) internal pure returns (uint y) {
789         uint z = (x + 1) / 2;
790         y = x;
791         while (z < y) {
792             y = z;
793             z = (x / z + z) / 2;
794         }
795     }
796     
797 }