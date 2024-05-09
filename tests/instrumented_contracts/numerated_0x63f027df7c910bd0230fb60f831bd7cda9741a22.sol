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
72     mapping(address => uint256) internal dividendBal;
73     
74     mapping(address => address) internal referralLevel1Address;
75     mapping(address => address) internal referralLevel2Address;
76     mapping(address => address) internal referralLevel3Address;
77     mapping(address => address) internal referralLevel4Address;
78     mapping(address => address) internal referralLevel5Address;
79     mapping(address => address) internal referralLevel6Address;
80     mapping(address => address) internal referralLevel7Address;
81     mapping(address => address) internal referralLevel8Address;
82     mapping(address => address) internal referralLevel9Address;
83     mapping(address => address) internal referralLevel10Address;
84     
85     mapping(address => int256) internal payoutsTo_;
86     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
87     uint256 internal tokenSupply_                           = 0;
88     uint256 internal developerBalance                       = 0;
89     uint256 internal profitPerShare_;
90     
91     // administrator list (see above on what they can do)
92     mapping(bytes32 => bool) public administrators;
93     bool public onlyAmbassadors = false;
94     
95     /*=================================
96     =            MODIFIERS            =
97     =================================*/
98     
99     // Only people with tokens
100     modifier onlybelievers () {
101         require(myTokens() > 0);
102         _;
103     }
104     
105     // Only people with profits
106     modifier onlyhodler() {
107         require(myDividends(true) > 0);
108         _;
109     }
110     
111     // Only admin
112     modifier onlyAdministrator(){
113         address _customerAddress = msg.sender;
114         require(administrators[keccak256(_customerAddress)]);
115         _;
116     }
117     
118     modifier antiEarlyWhale(uint256 _amountOfEthereum){
119         address _customerAddress = msg.sender;
120         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
121             require(
122                 // is the customer in the ambassador list?
123                 ambassadors_[_customerAddress] == true &&
124                 // does the customer purchase exceed the max ambassador quota?
125                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
126             );
127             // updated the accumulated quota    
128             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
129             _;
130         } else {
131             // in case the ether count drops low, the ambassador phase won't reinitiate
132             onlyAmbassadors = false;
133             _;    
134         }
135     }
136     
137     /*==============================
138     =            EVENTS            =
139     ==============================*/
140     
141     event onTokenPurchase(
142         address indexed customerAddress,
143         uint256 incomingEthereum,
144         uint256 tokensMinted,
145         address indexed referredBy
146     );
147     
148     event onTokenSell(
149         address indexed customerAddress,
150         uint256 tokensBurned,
151         uint256 ethereumEarned
152     );
153     
154     event onReinvestment(
155         address indexed customerAddress,
156         uint256 ethereumReinvested,
157         uint256 tokensMinted
158     );
159     
160     event onWithdraw(
161         address indexed customerAddress,
162         uint256 ethereumWithdrawn
163     );
164     
165     event Transfer(
166         address indexed from,
167         address indexed to,
168         uint256 tokens
169     );
170     
171     /*=======================================
172     =            PUBLIC FUNCTIONS            =
173     =======================================*/
174     /*
175     * -- APPLICATION ENTRY POINTS --  
176     */
177     function XcelDream() public {
178         // add administrators here
179         administrators[0x1c7e1ee4ebab752213b974d44db8e1663058edfc86410f1c3deb4e26b17d13d4] = true;
180         administrators[0x3a4f2b5f51038ac3477927ddb4625adaa1cbecd63aeaeb90f3456c6549c3de5a] = true;
181         ambassadors_[0x0000000000000000000000000000000000000000] = true;
182     }
183      
184     /**
185      * Converts all incoming Ethereum to tokens for the caller, and passes down the referral address (if any)
186      */
187     function migrateEth() public payable returns(uint256) {
188         return this.balance;
189     }
190     
191     function migrateTotalSupply(uint256 _tokenAmount) onlyAdministrator() public {
192         tokenSupply_                            = _tokenAmount;
193     }
194     
195     function migrateXDMDividendNReferralBalance(address _customerAddress, uint256 dividendBal_, uint256 referralBalanceM_, uint256 _tokenAmount, uint256 referralCountM_) onlyAdministrator() public {
196         address _customerAddressM = _customerAddress;
197         
198         dividendBal[_customerAddressM]          = dividendBal_;
199         
200         referralBalance_[_customerAddressM]     = referralBalanceM_;
201         
202         referralCount_[_customerAddressM]       = referralCountM_;
203         
204         tokenBalanceLedger_[_customerAddressM]  = _tokenAmount;
205         
206     }
207     
208     
209     function migrateTenLvlReferral(address _customerAddress,
210     address ref1, address ref2, address ref3, address ref4, address ref5,
211     address ref6, address ref7, address ref8, address ref9, address ref10) onlyAdministrator() public {
212         address _customerAddressM = _customerAddress;
213         
214         referralLevel1Address[_customerAddressM] = ref1;
215         referralLevel2Address[_customerAddressM] = ref2;
216         referralLevel3Address[_customerAddressM] = ref3;
217         referralLevel4Address[_customerAddressM] = ref4;
218         referralLevel5Address[_customerAddressM] = ref5;
219         referralLevel6Address[_customerAddressM] = ref6;
220         referralLevel7Address[_customerAddressM] = ref7;
221         referralLevel8Address[_customerAddressM] = ref8;
222         referralLevel9Address[_customerAddressM] = ref9;
223         referralLevel10Address[_customerAddressM] = ref10;
224         
225     }
226     
227     function migrateProfitPerShare(uint256 _amount) onlyAdministrator() public {
228         profitPerShare_                 = _amount;
229     }
230     
231     function migrateProfitPerShareShow() public view returns(uint256) {
232         return profitPerShare_;
233     }
234     
235     function migrateDeveloperFee(uint256 _amount) onlyAdministrator() public {
236         developerBalance                 = _amount;
237     }
238     
239     function migrateStakeBalanceNTime(address senderAddress, uint256 _amount, uint256 _time) onlyAdministrator() public {
240         stakeBalanceLedger_[senderAddress]                 = _amount;
241         stakingTime_[senderAddress]                 = _time;
242     }
243     
244     function migratePayoutsTo(address senderAddress, int256 _amount) onlyAdministrator() public {
245         payoutsTo_[senderAddress]                 = _amount;
246     }
247     
248     function migratePayoutsToShow(address senderAddress) public view returns(int256) {
249         return payoutsTo_[senderAddress];
250     }
251     
252     function migrateDownlineRef(address senderAddress, uint dataId, address refUserAddress, uint refLevel) onlyAdministrator() public {
253         RefUser[senderAddress][dataId].refUserAddress = refUserAddress;
254         RefUser[senderAddress][dataId].refLevel = refLevel;
255     }
256     
257     function buy(address _referredBy) public payable returns(uint256) {
258         purchaseTokens(msg.value, _referredBy);
259     }
260     
261     function() payable public {
262         purchaseTokens(msg.value, 0x0);
263     }
264     
265     /**
266      * Converts all of caller's dividends to tokens.
267      */
268     function reinvest() onlyhodler() public {
269         // fetch dividends
270         uint256 _dividends                  = myDividends(false); // retrieve ref. bonus later in the code
271         // pay out the dividends virtually
272         address _customerAddress            = msg.sender;
273         if(dividendBal[_customerAddress] > 0) {
274             if(dividendBal[_customerAddress] > _dividends) {
275                 payoutsTo_[_customerAddress]        +=  (int256) ((dividendBal[_customerAddress] - _dividends) * magnitude);
276             } else {
277                 payoutsTo_[_customerAddress]        +=  (int256) ((_dividends - dividendBal[_customerAddress]) * magnitude);
278             }
279         } else {
280             payoutsTo_[_customerAddress]        +=  (int256) (_dividends * magnitude);
281         }
282         // retrieve ref. bonus
283         _dividends                          += referralBalance_[_customerAddress];
284         dividendBal[_customerAddress]       = 0;
285         referralBalance_[_customerAddress]  = 0;
286         // dispatch a buy order with the virtualized "withdrawn dividends"
287         uint256 _tokens                     = purchaseTokens(_dividends, 0x0);
288         // fire event
289         onReinvestment(_customerAddress, _dividends, _tokens);
290     }
291     
292     /**
293      * Alias of sell() and withdraw().
294      */
295     function exit() public {
296         // get token count for caller & sell them all
297         address _customerAddress            = msg.sender;
298         uint256 _tokens                     = tokenBalanceLedger_[_customerAddress];
299         if(_tokens > 0) sell(_tokens);
300         withdraw();
301     }
302 
303     /**
304      * Withdraws all of the callers earnings.
305      */
306     function withdraw() onlyhodler() public {
307         // setup data
308         address _customerAddress            = msg.sender;
309         uint256 _dividends                  = myDividends(false); // get ref. bonus later in the code
310         // update dividend tracker
311         if(dividendBal[_customerAddress] > 0) {
312             if(dividendBal[_customerAddress] > _dividends) {
313                 payoutsTo_[_customerAddress]        +=  (int256) ((dividendBal[_customerAddress] - _dividends) * magnitude);
314             } else {
315                 payoutsTo_[_customerAddress]        +=  (int256) ((_dividends - dividendBal[_customerAddress]) * magnitude);
316             }
317         } else {
318             payoutsTo_[_customerAddress]        +=  (int256) (_dividends * magnitude);
319         }
320         // add ref. bonus
321         _dividends                          += referralBalance_[_customerAddress];
322         dividendBal[_customerAddress]       = 0;
323         referralBalance_[_customerAddress]  = 0;
324         // delivery service
325         _customerAddress.transfer(_dividends);
326         // fire event
327         onWithdraw(_customerAddress, _dividends);
328     }
329     
330     /**
331      * Liquifies tokens to ethereum.
332      */
333     function sell(uint256 _amountOfTokens) onlybelievers () public {
334         address _customerAddress            = msg.sender;
335         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
336         uint256 _tokens                     = _amountOfTokens;
337         uint256 _ethereum                   = tokensToEthereum_(_tokens);
338         uint256 _dividends                  = SafeMath.percent(_ethereum,dividendFee_,100,18);
339         uint256 _taxedEthereum              = SafeMath.sub(_ethereum, _dividends);
340         // burn the sold tokens
341         tokenSupply_                        = SafeMath.sub(tokenSupply_, _tokens);
342         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
343         // update dividends tracker
344         int256 _updatedPayouts              = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
345         payoutsTo_[_customerAddress]        -= _updatedPayouts;       
346         // dividing by zero is a bad idea
347         if (tokenSupply_ > 0) {
348             // update the amount of dividends per token
349             profitPerShare_                 = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
350         }
351         // fire event
352         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
353     }
354     
355     /**
356      * Transfer tokens from the caller to a new holder.
357      */
358     function transfer(address _toAddress, uint256 _amountOfTokens) onlybelievers () public returns(bool) {
359         address _customerAddress            = msg.sender;
360         // make sure we have the requested tokens
361         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
362         // withdraw all outstanding dividends first
363         if(myDividends(true) > 0) withdraw();
364         // liquify 10% of the tokens that are transfered
365         // these are dispersed to shareholders
366         uint256 _tokenFee                   = SafeMath.percent(_amountOfTokens,dividendFee_,100,18);
367         uint256 _taxedTokens                = SafeMath.sub(_amountOfTokens, _tokenFee);
368         uint256 _dividends                  = tokensToEthereum_(_tokenFee);
369         // burn the fee tokens
370         tokenSupply_                        = SafeMath.sub(tokenSupply_, _tokenFee);
371         // exchange tokens
372         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
373         tokenBalanceLedger_[_toAddress]     = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
374         // update dividend trackers
375         payoutsTo_[_customerAddress]        -= (int256) (profitPerShare_ * _amountOfTokens);
376         payoutsTo_[_toAddress]              += (int256) (profitPerShare_ * _taxedTokens);
377         // disperse dividends among holders
378         profitPerShare_                     = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
379         // fire event
380         Transfer(_customerAddress, _toAddress, _taxedTokens);
381         return true;
382     }
383     
384     
385     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
386     /**
387      * administrator can manually disable the ambassador phase.
388      */
389     function disableInitialStage() onlyAdministrator() public {
390         onlyAmbassadors                     = false;
391     }
392     
393     function changeStakePercent(uint8 stakePercent) onlyAdministrator() public {
394         stakePer_                           = stakePercent;
395     }
396     
397     function setAdministrator(bytes32 _identifier, bool _status) onlyAdministrator() public {
398         administrators[_identifier]         = _status;
399     }
400     
401     function setStakingRequirement(uint256 _amountOfTokens) onlyAdministrator() public {
402         stakingRequirement                  = _amountOfTokens;
403     }
404     
405     function setName(string _name) onlyAdministrator() public {
406         name                                = _name;
407     }
408     
409     function setSymbol(string _symbol) onlyAdministrator() public {
410         symbol                              = _symbol;
411     }
412     
413     function drainDeveloperFees(uint256 _withdrawAmount) external onlyAdministrator {
414         address _adminAddress   = msg.sender;
415         require(developerBalance >= _withdrawAmount);
416         _adminAddress.transfer(_withdrawAmount);
417         developerBalance        = SafeMath.sub(developerBalance, _withdrawAmount);
418     }
419     
420     /*----------  HELPERS AND CALCULATORS  ----------*/
421     /**
422      * Method to view the current Ethereum stored in the contract
423      * Example: totalEthereumBalance()
424      */
425     function totalEthereumBalance() public view returns(uint) {
426         return this.balance;
427     }
428     /**
429      * Retrieve the total developer fee balance.
430      */
431     function totalDeveloperBalance() public view returns(uint) {
432         return developerBalance;
433     }
434     /**
435      * Retrieve the total token supply.
436      */
437     function totalSupply() public view returns(uint256) {
438         return tokenSupply_;
439     }
440     
441     /**
442      * Retrieve the tokens owned by the caller.
443      */
444     function myTokens() public view returns(uint256) {
445         address _customerAddress            = msg.sender;
446         return balanceOf(_customerAddress);
447     }
448     
449     /**
450      * Retrieve the dividends owned by the caller.
451      */ 
452     function myDividends(bool _includeReferralBonus) public view returns(uint256) {
453         address _customerAddress            = msg.sender;
454         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
455     }
456     
457     /**
458      * Retrieve the token balance of any single address.
459      */
460     function balanceOf(address _customerAddress) view public returns(uint256) {
461         return tokenBalanceLedger_[_customerAddress];
462     }
463     
464     /**
465      * Retrieve the dividend balance of any single address.
466      */
467     function dividendsOf(address _customerAddress) view public returns(uint256) {
468         uint256 calculatedDividend = (uint256) ((int256)(profitPerShare_ * (tokenBalanceLedger_[_customerAddress] + stakeBalanceLedger_[_customerAddress])) - payoutsTo_[_customerAddress]) / magnitude;
469         uint256 finalBalance =  SafeMath.add(dividendBal[_customerAddress], calculatedDividend);
470         return finalBalance;
471     }
472     
473     /**
474      * Return the buy price of 1 individual token.
475      */
476     function sellPrice() public view returns(uint256) {
477         if(tokenSupply_ == 0){
478             return tokenPriceInitial_       - tokenPriceDecremental_;
479         } else {
480             uint256 _ethereum               = tokensToEthereum_(1e18);
481             uint256 _dividends              = SafeMath.percent(_ethereum,dividendFee_,100,18);
482             uint256 _taxedEthereum          = SafeMath.sub(_ethereum, _dividends);
483             return _taxedEthereum;
484         }
485     }
486     
487     /**
488      * Return the sell price of 1 individual token.
489      */
490     function buyPrice() public view returns(uint256) {
491         if(tokenSupply_ == 0){
492             return tokenPriceInitial_       + tokenPriceIncremental_;
493         } else {
494             uint256 _ethereum               = tokensToEthereum_(1e18);
495             uint256 untotalDeduct           = developerFee_ + referralPer_ + dividendFee_;
496             uint256 totalDeduct             = SafeMath.percent(_ethereum,untotalDeduct,100,18);
497             uint256 _taxedEthereum          = SafeMath.add(_ethereum, totalDeduct);
498             return _taxedEthereum;
499         }
500     }
501    
502     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns(uint256) {
503         uint256 untotalDeduct               = developerFee_ + referralPer_ + dividendFee_;
504         uint256 totalDeduct                 = SafeMath.percent(_ethereumToSpend,untotalDeduct,100,18);
505         uint256 _taxedEthereum              = SafeMath.sub(_ethereumToSpend, totalDeduct);
506         uint256 _amountOfTokens             = ethereumToTokens_(_taxedEthereum);
507         return _amountOfTokens;
508     }
509    
510     function calculateEthereumReceived(uint256 _tokensToSell) public view returns(uint256) {
511         require(_tokensToSell <= tokenSupply_);
512         uint256 _ethereum                   = tokensToEthereum_(_tokensToSell);
513         uint256 _dividends                  = SafeMath.percent(_ethereum,dividendFee_,100,18);
514         uint256 _taxedEthereum              = SafeMath.sub(_ethereum, _dividends);
515         return _taxedEthereum;
516     }
517     
518     function stakeTokens(uint256 _amountOfTokens) onlybelievers () public returns(bool){
519         address _customerAddress            = msg.sender;
520         // make sure we have the requested tokens
521         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
522         uint256 _amountOfTokensWith1Token   = SafeMath.sub(_amountOfTokens, 1e18);
523         stakingTime_[_customerAddress]      = now;
524         stakeBalanceLedger_[_customerAddress] = SafeMath.add(stakeBalanceLedger_[_customerAddress], _amountOfTokensWith1Token);
525         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokensWith1Token);
526     }
527     
528     // Add daily ROI
529     function stakeTokensBalance(address _customerAddress) public view returns(uint256){
530         uint256 timediff                    = SafeMath.sub(now, stakingTime_[_customerAddress]);
531         uint256 dayscount                   = SafeMath.div(timediff, 86400); //86400 Sec for 1 Day
532         uint256 roiPercent                  = SafeMath.mul(dayscount, stakePer_);
533         uint256 roiTokens                   = SafeMath.percent(stakeBalanceLedger_[_customerAddress],roiPercent,100,18);
534         uint256 finalBalance                = SafeMath.add(stakeBalanceLedger_[_customerAddress],roiTokens);
535         return finalBalance;
536     }
537     
538     function stakeTokensTime(address _customerAddress) public view returns(uint256){
539         return stakingTime_[_customerAddress];
540     }
541     
542     function releaseStake() onlybelievers () public returns(bool){
543         address _customerAddress            = msg.sender;
544         // make sure we have the requested tokens
545         require(!onlyAmbassadors && stakingTime_[_customerAddress] > 0);
546         uint256 _amountOfTokens             = stakeBalanceLedger_[_customerAddress];
547         uint256 timediff                    = SafeMath.sub(now, stakingTime_[_customerAddress]);
548         uint256 dayscount                   = SafeMath.div(timediff, 86400);
549         uint256 roiPercent                  = SafeMath.mul(dayscount, stakePer_);
550         uint256 roiTokens                   = SafeMath.percent(_amountOfTokens,roiPercent,100,18);
551         uint256 finalBalance                = SafeMath.add(_amountOfTokens,roiTokens);
552         
553         // add tokens to the pool
554         tokenSupply_                        = SafeMath.add(tokenSupply_, roiTokens);
555         // transfer tokens back
556         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], finalBalance);
557         stakeBalanceLedger_[_customerAddress] = 0;
558         stakingTime_[_customerAddress]      = 0;
559         
560     }
561     
562     /*==========================================
563     =            INTERNAL FUNCTIONS            =
564     ==========================================*/
565     
566     uint256 developerFee;
567     uint256 incETH;
568     address _refAddress; 
569     uint256 _referralBonus;
570     
571     uint256 bonusLv1;
572     uint256 bonusLv2;
573     uint256 bonusLv3;
574     uint256 bonusLv4;
575     uint256 bonusLv5;
576     uint256 bonusLv6;
577     uint256 bonusLv7;
578     uint256 bonusLv8;
579     uint256 bonusLv9;
580     uint256 bonusLv10;
581     
582     address chkLv2;
583     address chkLv3;
584     address chkLv4;
585     address chkLv5;
586     address chkLv6;
587     address chkLv7;
588     address chkLv8;
589     address chkLv9;
590     address chkLv10;
591     
592     struct RefUserDetail {
593         address refUserAddress;
594         uint256 refLevel;
595     }
596 
597     mapping(address => mapping (uint => RefUserDetail)) public RefUser;
598     mapping(address => uint256) public referralCount_;
599     
600     function getDownlineRef(address senderAddress, uint dataId) external view returns (address,uint) { 
601         return (RefUser[senderAddress][dataId].refUserAddress,RefUser[senderAddress][dataId].refLevel);
602     }
603     
604     function addDownlineRef(address senderAddress, address refUserAddress, uint refLevel) internal {
605         referralCount_[senderAddress]++;
606         uint dataId = referralCount_[senderAddress];
607         RefUser[senderAddress][dataId].refUserAddress = refUserAddress;
608         RefUser[senderAddress][dataId].refLevel = refLevel;
609     }
610 
611     function getref(address _customerAddress, uint _level) public view returns(address lv) {
612         if(_level == 1) {
613             lv = referralLevel1Address[_customerAddress];
614         } else if(_level == 2) {
615             lv = referralLevel2Address[_customerAddress];
616         } else if(_level == 3) {
617             lv = referralLevel3Address[_customerAddress];
618         } else if(_level == 4) {
619             lv = referralLevel4Address[_customerAddress];
620         } else if(_level == 5) {
621             lv = referralLevel5Address[_customerAddress];
622         } else if(_level == 6) {
623             lv = referralLevel6Address[_customerAddress];
624         } else if(_level == 7) {
625             lv = referralLevel7Address[_customerAddress];
626         } else if(_level == 8) {
627             lv = referralLevel8Address[_customerAddress];
628         } else if(_level == 9) {
629             lv = referralLevel9Address[_customerAddress];
630         } else if(_level == 10) {
631             lv = referralLevel10Address[_customerAddress];
632         } 
633         return lv;
634     }
635     
636     function distributeRefBonus(uint256 _incomingEthereum, address _referredBy, address _sender, bool _newReferral) internal {
637         address _customerAddress        = _sender;
638         uint256 remainingRefBonus       = _incomingEthereum;
639         _referralBonus                  = _incomingEthereum;
640         
641         bonusLv1                        = SafeMath.percent(_referralBonus,30,100,18);
642         bonusLv2                        = SafeMath.percent(_referralBonus,20,100,18);
643         bonusLv3                        = SafeMath.percent(_referralBonus,15,100,18);
644         bonusLv4                        = SafeMath.percent(_referralBonus,10,100,18);
645         bonusLv5                        = SafeMath.percent(_referralBonus,5,100,18);
646         bonusLv6                        = SafeMath.percent(_referralBonus,5,100,18);
647         bonusLv7                        = SafeMath.percent(_referralBonus,5,100,18);
648         bonusLv8                        = SafeMath.percent(_referralBonus,3,100,18);
649         bonusLv9                        = SafeMath.percent(_referralBonus,3,100,18);
650         bonusLv10                       = SafeMath.percent(_referralBonus,2,100,18);
651         
652         // Level 1
653         referralLevel1Address[_customerAddress]                     = _referredBy;
654         referralBalance_[referralLevel1Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel1Address[_customerAddress]], bonusLv1);
655         remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv1);
656         if(_newReferral == true) {
657             addDownlineRef(_referredBy, _customerAddress, 1);
658         }
659         
660         chkLv2                          = referralLevel1Address[_referredBy];
661         chkLv3                          = referralLevel2Address[_referredBy];
662         chkLv4                          = referralLevel3Address[_referredBy];
663         chkLv5                          = referralLevel4Address[_referredBy];
664         chkLv6                          = referralLevel5Address[_referredBy];
665         chkLv7                          = referralLevel6Address[_referredBy];
666         chkLv8                          = referralLevel7Address[_referredBy];
667         chkLv9                          = referralLevel8Address[_referredBy];
668         chkLv10                         = referralLevel9Address[_referredBy];
669         
670         // Level 2
671         if(chkLv2 != 0x0000000000000000000000000000000000000000) {
672             referralLevel2Address[_customerAddress]                     = referralLevel1Address[_referredBy];
673             referralBalance_[referralLevel2Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel2Address[_customerAddress]], bonusLv2);
674             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv2);
675             if(_newReferral == true) {
676                 addDownlineRef(referralLevel1Address[_referredBy], _customerAddress, 2);
677             }
678         }
679         
680         // Level 3
681         if(chkLv3 != 0x0000000000000000000000000000000000000000) {
682             referralLevel3Address[_customerAddress]                     = referralLevel2Address[_referredBy];
683             referralBalance_[referralLevel3Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel3Address[_customerAddress]], bonusLv3);
684             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv3);
685             if(_newReferral == true) {
686                 addDownlineRef(referralLevel2Address[_referredBy], _customerAddress, 3);
687             }
688         }
689         
690         // Level 4
691         if(chkLv4 != 0x0000000000000000000000000000000000000000) {
692             referralLevel4Address[_customerAddress]                     = referralLevel3Address[_referredBy];
693             referralBalance_[referralLevel4Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel4Address[_customerAddress]], bonusLv4);
694             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv4);
695             if(_newReferral == true) {
696                 addDownlineRef(referralLevel3Address[_referredBy], _customerAddress, 4);
697             }
698         }
699         
700         // Level 5
701         if(chkLv5 != 0x0000000000000000000000000000000000000000) {
702             referralLevel5Address[_customerAddress]                     = referralLevel4Address[_referredBy];
703             referralBalance_[referralLevel5Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel5Address[_customerAddress]], bonusLv5);
704             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv5);
705             if(_newReferral == true) {
706                 addDownlineRef(referralLevel4Address[_referredBy], _customerAddress, 5);
707             }
708         }
709         
710         // Level 6
711         if(chkLv6 != 0x0000000000000000000000000000000000000000) {
712             referralLevel6Address[_customerAddress]                     = referralLevel5Address[_referredBy];
713             referralBalance_[referralLevel6Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel6Address[_customerAddress]], bonusLv6);
714             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv6);
715             if(_newReferral == true) {
716                 addDownlineRef(referralLevel5Address[_referredBy], _customerAddress, 6);
717             }
718         }
719         
720         // Level 7
721         if(chkLv7 != 0x0000000000000000000000000000000000000000) {
722             referralLevel7Address[_customerAddress]                     = referralLevel6Address[_referredBy];
723             referralBalance_[referralLevel7Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel7Address[_customerAddress]], bonusLv7);
724             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv7);
725             if(_newReferral == true) {
726                 addDownlineRef(referralLevel6Address[_referredBy], _customerAddress, 7);
727             }
728         }
729         
730         // Level 8
731         if(chkLv8 != 0x0000000000000000000000000000000000000000) {
732             referralLevel8Address[_customerAddress]                     = referralLevel7Address[_referredBy];
733             referralBalance_[referralLevel8Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel8Address[_customerAddress]], bonusLv8);
734             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv8);
735             if(_newReferral == true) {
736                 addDownlineRef(referralLevel7Address[_referredBy], _customerAddress, 8);
737             }
738         }
739         
740         // Level 9
741         if(chkLv9 != 0x0000000000000000000000000000000000000000) {
742             referralLevel9Address[_customerAddress]                     = referralLevel8Address[_referredBy];
743             referralBalance_[referralLevel9Address[_customerAddress]]   = SafeMath.add(referralBalance_[referralLevel9Address[_customerAddress]], bonusLv9);
744             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv9);
745             if(_newReferral == true) {
746                 addDownlineRef(referralLevel8Address[_referredBy], _customerAddress, 9);
747             }
748         }
749         
750         // Level 10
751         if(chkLv10 != 0x0000000000000000000000000000000000000000) {
752             referralLevel10Address[_customerAddress]                    = referralLevel9Address[_referredBy];
753             referralBalance_[referralLevel10Address[_customerAddress]]  = SafeMath.add(referralBalance_[referralLevel10Address[_customerAddress]], bonusLv10);
754             remainingRefBonus                                           = SafeMath.sub(remainingRefBonus, bonusLv10);
755             if(_newReferral == true) {
756                 addDownlineRef(referralLevel9Address[_referredBy], _customerAddress, 10);
757             }
758         }
759         
760         developerBalance                    = SafeMath.add(developerBalance, remainingRefBonus);
761     }
762 
763     function distributeNewBonus(uint256 _incETH, uint256 _amountOfTokens, address _customerAddress, bool _adminTransfer) internal {
764         uint256 _newXDMbonus                = 0;
765         if(_incETH >= 10 ether && _incETH < 20 ether) {
766             _newXDMbonus                    = SafeMath.percent(_amountOfTokens,2,100,18);
767         }
768         if(_incETH >= 20 ether && _incETH < 50 ether) {
769             _newXDMbonus                    = SafeMath.percent(_amountOfTokens,3,100,18);
770         }
771         if(_incETH >= 50 ether && _incETH < 80 ether) {
772             _newXDMbonus                    = SafeMath.percent(_amountOfTokens,5,100,18);
773         }
774         if(_incETH >= 80 ether && _incETH < 100 ether) {
775             _newXDMbonus                    = SafeMath.percent(_amountOfTokens,7,100,18);
776         }
777         if(_incETH >= 100 ether && _incETH <= 1000 ether) {
778             _newXDMbonus                    = SafeMath.percent(_amountOfTokens,8,100,18);
779         }
780         
781         if(_adminTransfer == true) {
782             tokenBalanceLedger_[0x18bbBeBc5B7658c7aCAD57381084FA63F9fad590]    = SafeMath.add(tokenBalanceLedger_[0x18bbBeBc5B7658c7aCAD57381084FA63F9fad590], _newXDMbonus);
783         } else {
784             tokenBalanceLedger_[referralLevel1Address[_customerAddress]]    = SafeMath.add(tokenBalanceLedger_[referralLevel1Address[_customerAddress]], _newXDMbonus);
785         }
786         tokenSupply_                    = SafeMath.add(tokenSupply_, _newXDMbonus);
787     }
788     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) antiEarlyWhale(_incomingEthereum) internal returns(uint256) {
789         // data setup
790         address _customerAddress            = msg.sender;
791         incETH                              = _incomingEthereum;
792         
793         developerFee                        = SafeMath.percent(incETH,developerFee_,100,18);
794         developerBalance                    = SafeMath.add(developerBalance, developerFee);
795         
796         _referralBonus                      = SafeMath.percent(incETH,referralPer_,100,18);
797         
798         uint256 _dividends                  = SafeMath.percent(incETH,dividendFee_,100,18);
799         
800         uint256 untotalDeduct               = developerFee_ + referralPer_ + dividendFee_;
801         uint256 totalDeduct                 = SafeMath.percent(incETH,untotalDeduct,100,18);
802         
803         uint256 _taxedEthereum              = SafeMath.sub(incETH, totalDeduct);
804         uint256 _amountOfTokens             = ethereumToTokens_(_taxedEthereum);
805         uint256 _fee                        = _dividends * magnitude;
806         bool    _newReferral                = true;
807         
808         
809         if(referralLevel1Address[_customerAddress] != 0x0000000000000000000000000000000000000000) {
810             _referredBy                     = referralLevel1Address[_customerAddress];
811             _newReferral                    = false;
812         }
813         
814         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
815         // is the user referred by a link?
816         if(
817             // is this a referred purchase?
818             _referredBy != 0x0000000000000000000000000000000000000000 &&
819             // no cheating!
820             _referredBy != _customerAddress &&
821             tokenBalanceLedger_[_referredBy] >= stakingRequirement
822         ){
823             // wealth redistribution
824             distributeRefBonus(_referralBonus,_referredBy,_customerAddress,_newReferral);
825             if(incETH >= 10 ether && incETH <= 1000 ether) {
826                 distributeNewBonus(incETH,_amountOfTokens,_customerAddress,false);
827             }
828         } else {
829             // no ref purchase
830             // send referral bonus back to admin
831             developerBalance                = SafeMath.add(developerBalance, _referralBonus);
832             if(incETH >= 10 ether && incETH <= 1000 ether) {
833                 distributeNewBonus(incETH,_amountOfTokens,_customerAddress,true);
834             }
835         }
836         // we can't give people infinite ethereum
837         if(tokenSupply_ > 0){
838             // add tokens to the pool
839             tokenSupply_                    = SafeMath.add(tokenSupply_, _amountOfTokens);
840             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
841             profitPerShare_                 += (_dividends * magnitude / (tokenSupply_));
842             // calculate the amount of tokens the customer receives over his purchase 
843             _fee                            = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
844         } else {
845             // add tokens to the pool
846             tokenSupply_                    = _amountOfTokens;
847         }
848         // update circulating supply & the ledger address for the customer
849         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
850         int256 _updatedPayouts              = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
851         payoutsTo_[_customerAddress]        += _updatedPayouts;
852         // fire event
853         onTokenPurchase(_customerAddress, incETH, _amountOfTokens, _referredBy);
854         return _amountOfTokens;
855     }
856 
857     /**
858      * Calculate Token price based on an amount of incoming ethereum
859      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
860      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
861      */
862     function ethereumToTokens_(uint256 _ethereum) internal view returns(uint256) {
863         uint256 _tokenPriceInitial          = tokenPriceInitial_ * 1e18;
864         uint256 _tokensReceived             = 
865          (
866             (
867                 SafeMath.sub(
868                     (sqrt
869                         (
870                             (_tokenPriceInitial**2)
871                             +
872                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
873                             +
874                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
875                             +
876                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
877                         )
878                     ), _tokenPriceInitial
879                 )
880             )/(tokenPriceIncremental_)
881         )-(tokenSupply_)
882         ;
883 
884         return _tokensReceived;
885     }
886     
887     /**
888      * Calculate token sell value.
889      */
890      function tokensToEthereum_(uint256 _tokens) internal view returns(uint256) {
891         uint256 tokens_                     = (_tokens + 2e18);
892         uint256 _tokenSupply                = (tokenSupply_ + 2e18);
893         uint256 _etherReceived              =
894         (
895             SafeMath.sub(
896                 (
897                     (
898                         (
899                             tokenPriceInitial_ +(tokenPriceDecremental_ * (_tokenSupply/2e18))
900                         )-tokenPriceDecremental_
901                     )*(tokens_ - 2e18)
902                 ),(tokenPriceDecremental_*((tokens_**2-tokens_)/2e18))/2
903             )
904         /2e18);
905         return _etherReceived;
906     }
907     
908     function sqrt(uint x) internal pure returns (uint y) {
909         uint z = (x + 1) / 2;
910         y = x;
911         while (z < y) {
912             y = z;
913             z = (x / z + z) / 2;
914         }
915     }
916     
917 }