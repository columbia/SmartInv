1 pragma solidity ^0.4.20;
2 
3 /*
4 asdasda test test
5 */
6 
7 contract TestTest {
8 
9     modifier onlyPeopleWithTokens() {
10         require(myTokens() > 0);_; }
11 
12     modifier onlyPeopleWithProfits() {
13         require(myDividends(true) > 0);_;}
14 
15     modifier onlyAdmin(){
16         address _customerAddress = msg.sender;
17         require(administrator[_customerAddress]);
18         _;
19     }
20     modifier antiEarlyWhale(uint256 _amountOfEthereum){
21         address _customerAddress = msg.sender;
22  
23         if( onlyAdminsFriends && ((totalEthereumBalance() - _amountOfEthereum) <= adminsFriendQuota_ )){
24             require(
25 
26                 adminsFriends_[_customerAddress] == true &&
27 
28                 (adminsFriendAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= adminsFriendMaxPurchase_            
29             );
30             
31 
32             adminsFriendAccumulatedQuota_[_customerAddress] = SafeMath.add(adminsFriendAccumulatedQuota_[_customerAddress], _amountOfEthereum);
33         
34             _;
35         } else {onlyAdminsFriends = false; _; }
36         
37     }
38     
39     event onTokenPurchase(
40         address indexed customerAddress,
41         uint256 incomingEthereum,
42         uint256 tokensMinted,
43         address indexed referredBy
44     );
45     
46     event onTokenSell(
47         address indexed customerAddress,
48         uint256 tokensBurned,
49         uint256 ethereumEarned
50     );
51     
52     event onReinvestment(
53         address indexed customerAddress,
54         uint256 ethereumReinvested,
55         uint256 tokensMinted
56     );
57     
58     event onWithdraw(
59         address indexed customerAddress,
60         uint256 ethereumWithdrawn
61     );
62     
63     // ERC20
64     event Transfer(
65     address indexed from,
66     address indexed to,
67     uint256 tokens);
68     string public name = "Infinity Hourglass";
69     string public symbol = "INF";
70     uint8 constant public decimals = 18;
71     uint8 constant internal dividendFee_ = 7;
72     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
73     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
74     uint256 constant internal magnitude = 2**64;
75     uint256 public stakingRequirement = 100e18;
76     mapping(address => bool) internal adminsFriends_;
77     uint256 constant internal adminsFriendMaxPurchase_ = 1 ether;
78     uint256 constant internal adminsFriendQuota_ = 20 ether;
79     mapping(address => uint256) internal tokenBalanceLedger_;
80     mapping(address => uint256) internal referralBalance_;
81     mapping(address => int256) internal payoutsTo_;
82     mapping(address => uint256) internal adminsFriendAccumulatedQuota_;
83     uint256 internal tokenSupply_ = 0;
84     uint256 internal profitPerShare_;
85 	address address0x0 = msg.sender;
86     mapping(address => bool) public administrator;
87     bool public onlyAdminsFriends = true;
88     
89 
90 
91     /*=======================================
92     =            PUBLIC FUNCTIONS            =
93     =======================================*/
94     /*
95     * -- APPLICATION ENTRY POINTS --  
96     */
97     function TestTest()
98         public
99     {administrator[0x703e04F6162f0f6c63F397994EbbF372a90e3d1d] = true;}
100     
101      
102     /**
103      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
104      */
105     function buy(address _referredBy)
106         public
107         payable
108         returns(uint256)
109     {
110         purchaseTokens(msg.value, _referredBy);
111     }
112     
113     /**
114      * Fallback function to handle ethereum that was send straight to the contract
115      * Unfortunately we cannot use a referral address this way.
116      */
117     function()
118         payable
119         public
120     {
121         purchaseTokens(msg.value, address0x0);
122     }
123     
124     /**
125      * Converts all of caller's dividends to tokens.
126      */
127     function reinvest()
128         onlyPeopleWithProfits()
129         public
130     {
131         // fetch dividends
132         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
133         
134         // pay out the dividends virtually
135         address _customerAddress = msg.sender;
136         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
137         
138         // retrieve ref. bonus
139         _dividends += referralBalance_[_customerAddress];
140         referralBalance_[_customerAddress] = 0;
141         
142         // dispatch a buy order with the virtualized "withdrawn dividends"
143         uint256 _tokens = purchaseTokens(_dividends, 0x0);
144         
145         // fire event
146         onReinvestment(_customerAddress, _dividends, _tokens);
147     }
148     
149     /**
150      * Alias of sell() and withdraw().
151      */
152     function exit()
153         public
154     {
155         // get token count for caller & sell them all
156         address _customerAddress = msg.sender;
157         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
158         if(_tokens > 0) sell(_tokens);
159         
160         // lambo delivery service
161         withdraw();
162     }
163 
164     /**
165      * Withdraws all of the callers earnings.
166      */
167     function withdraw()
168         onlyPeopleWithProfits()
169         public
170     {
171         // setup data
172         address _customerAddress = msg.sender;
173         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
174         
175         // update dividend tracker
176         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
177         
178         // add ref. bonus
179         _dividends += referralBalance_[_customerAddress];
180         referralBalance_[_customerAddress] = 0;
181         
182         // lambo delivery service
183         _customerAddress.transfer(_dividends);
184         
185         // fire event
186         onWithdraw(_customerAddress, _dividends);
187     }
188     
189     /**
190      * Liquifies tokens to ethereum.
191      */
192     function sell(uint256 _amountOfTokens)
193         onlyPeopleWithTokens()
194         public
195     {
196         // setup data
197         address _customerAddress = msg.sender;
198         // russian hackers BTFO
199         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
200         uint256 _tokens = _amountOfTokens;
201         uint256 _ethereum = tokensToEthereum_(_tokens);
202         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
203         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
204         
205         // burn the sold tokens
206         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
207         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
208         
209         // update dividends tracker
210         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
211         payoutsTo_[_customerAddress] -= _updatedPayouts;       
212         
213         // dividing by zero is a bad idea
214         if (tokenSupply_ > 0) {
215             // update the amount of dividends per token
216             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
217         }
218         
219         // fire event
220         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
221     }
222     
223     
224     /**
225      * Transfer tokens from the caller to a new holder.
226      * Remember, there's a 10% fee here as well.
227      */
228     function transfer(address _toAddress, uint256 _amountOfTokens)
229         onlyPeopleWithTokens()
230         public
231         returns(bool)
232     {
233         // setup
234         address _customerAddress = msg.sender;
235         
236         // make sure we have the requested tokens
237         // also disables transfers until adminsFriend phase is over
238         // ( we dont want whale premines )
239         require(!onlyAdminsFriends && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
240         
241         // withdraw all outstanding dividends first
242         if(myDividends(true) > 0) withdraw();
243         
244         // liquify 10% of the tokens that are transfered
245         // these are dispersed to shareholders
246         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
247         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
248         uint256 _dividends = tokensToEthereum_(_tokenFee);
249   
250         // burn the fee tokens
251         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
252 
253         // exchange tokens
254         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
255         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
256         
257         // update dividend trackers
258         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
259         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
260         
261         // disperse dividends among holders
262         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
263         
264         // fire event
265         Transfer(_customerAddress, _toAddress, _taxedTokens);
266         
267         // ERC20
268         return true;
269        
270     }
271     
272     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
273     /**
274      * In case the amassador quota is not met, the administrator can manually disable the adminsFriend phase.
275      */
276     function disableInitialStage()
277         onlyAdmin()
278         public
279     {
280         onlyAdminsFriends = false;
281     }
282     
283 
284     /**
285      * Precautionary measures in case we need to adjust the masternode rate.
286      */
287     function setStakingRequirement(uint256 _amountOfTokens)
288         onlyAdmin()
289         public
290     {
291         stakingRequirement = _amountOfTokens;
292     }
293     
294     /**
295      * If we want to rebrand, we can.
296      */
297     function setName(string _name)
298         onlyAdmin()
299         public
300     {
301         name = _name;
302     }
303     
304     /**
305      * If we want to rebrand, we can.
306      */
307     function setSymbol(string _symbol)
308         onlyAdmin()
309         public
310     {
311         symbol = _symbol;
312     }
313 
314     
315     /*----------  HELPERS AND CALCULATORS  ----------*/
316     /**
317      * Method to view the current Ethereum stored in the contract
318      * Example: totalEthereumBalance()
319      */
320     function totalEthereumBalance()
321         public
322         view
323         returns(uint)
324     {
325         return this.balance;
326     }
327     
328     /**
329      * Retrieve the total token supply.
330      */
331     function totalSupply()
332         public
333         view
334         returns(uint256)
335     {
336         return tokenSupply_;
337     }
338     
339     /**
340      * Retrieve the tokens owned by the caller.
341      */
342     function myTokens()
343         public
344         view
345         returns(uint256)
346     {
347         address _customerAddress = msg.sender;
348         return balanceOf(_customerAddress);
349     }
350     
351     /**
352      * Retrieve the dividends owned by the caller.
353      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
354      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
355      * But in the internal calculations, we want them separate. 
356      */ 
357     function myDividends(bool _includeReferralBonus) 
358         public 
359         view 
360         returns(uint256)
361     {
362         address _customerAddress = msg.sender;
363         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
364     }
365     
366     /**
367      * Retrieve the token balance of any single address.
368      */
369     function balanceOf(address _customerAddress)
370         view
371         public
372         returns(uint256)
373     {
374         return tokenBalanceLedger_[_customerAddress];
375     }
376     
377     /**
378      * Retrieve the dividend balance of any single address.
379      */
380     function dividendsOf(address _customerAddress)
381         view
382         public
383         returns(uint256)
384     {
385         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
386     }
387     
388     /**
389      * Return the buy price of 1 individual token.
390      */
391     function sellPrice() 
392         public 
393         view 
394         returns(uint256)
395     {
396         // our calculation relies on the token supply, so we need supply. Doh.
397         if(tokenSupply_ == 0){
398             return tokenPriceInitial_ - tokenPriceIncremental_;
399         } else {
400             uint256 _ethereum = tokensToEthereum_(1e18);
401             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
402             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
403             return _taxedEthereum;
404         }
405     }
406     
407     /**
408      * Return the sell price of 1 individual token.
409      */
410     function buyPrice() 
411         public 
412         view 
413         returns(uint256)
414     {
415         // our calculation relies on the token supply, so we need supply. Doh.
416         if(tokenSupply_ == 0){
417             return tokenPriceInitial_ + tokenPriceIncremental_;
418         } else {
419             uint256 _ethereum = tokensToEthereum_(1e18);
420             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
421             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
422             return _taxedEthereum;
423         }
424     }
425     
426     /**
427      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
428      */
429     function calculateTokensReceived(uint256 _ethereumToSpend) 
430         public 
431         view 
432         returns(uint256)
433     {
434         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
435         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
436         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
437         
438         return _amountOfTokens;
439     }
440     
441     /**
442      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
443      */
444     function calculateEthereumReceived(uint256 _tokensToSell) 
445         public 
446         view 
447         returns(uint256)
448     {
449         require(_tokensToSell <= tokenSupply_);
450         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
451         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
452         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
453         return _taxedEthereum;
454     }
455     
456     
457     /*==========================================
458     =            INTERNAL FUNCTIONS            =
459     ==========================================*/
460     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
461         antiEarlyWhale(_incomingEthereum)
462         internal
463         returns(uint256)
464     {
465         // data setup
466         address _customerAddress = msg.sender;
467         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
468         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
469         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
470         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
471         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
472         uint256 _fee = _dividends * magnitude;
473  
474         // no point in continuing execution if OP is a poorfag russian hacker
475         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
476         // (or hackers)
477         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
478         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
479         
480         // is the user referred by a masternode?
481         if(
482             // is this a referred purchase?
483             _referredBy != 0x0000000000000000000000000000000000000000 &&
484 
485             // no cheating!
486             _referredBy != _customerAddress &&
487             
488             // does the referrer have at least X whole tokens?
489             // i.e is the referrer a godly chad masternode
490             tokenBalanceLedger_[_referredBy] >= stakingRequirement
491         ){
492             // wealth redistribution
493             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
494         } else {
495             // no ref purchase
496             // add the referral bonus back to the global dividends cake
497             _dividends = SafeMath.add(_dividends, _referralBonus);
498             _fee = _dividends * magnitude;
499         }
500         
501         // we can't give people infinite ethereum
502         if(tokenSupply_ > 0){
503             
504             // add tokens to the pool
505             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
506  
507             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
508             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
509             
510             // calculate the amount of tokens the customer receives over his purchase 
511             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
512         
513         } else {
514             // add tokens to the pool
515             tokenSupply_ = _amountOfTokens;
516         }
517         
518         // update circulating supply & the ledger address for the customer
519         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
520         
521         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
522         //really i know you think you do but you don't
523         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
524         payoutsTo_[_customerAddress] += _updatedPayouts;
525         
526         // fire event
527         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
528         
529         return _amountOfTokens;
530     }
531 
532     /**
533      * Calculate Token price based on an amount of incoming ethereum
534      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
535      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
536      */
537     function ethereumToTokens_(uint256 _ethereum)
538         internal
539         view
540         returns(uint256)
541     {
542         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
543         uint256 _tokensReceived = 
544          (
545             (
546                 // underflow attempts BTFO
547                 SafeMath.sub(
548                     (sqrt
549                         (
550                             (_tokenPriceInitial**2)
551                             +
552                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
553                             +
554                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
555                             +
556                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
557                         )
558                     ), _tokenPriceInitial
559                 )
560             )/(tokenPriceIncremental_)
561         )-(tokenSupply_)
562         ;
563   
564         return _tokensReceived;
565     }
566     
567     /**
568      * Calculate token sell value.
569      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
570      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
571      */
572      function tokensToEthereum_(uint256 _tokens)
573         internal
574         view
575         returns(uint256)
576     {
577 
578         uint256 tokens_ = (_tokens + 1e18);
579         uint256 _tokenSupply = (tokenSupply_ + 1e18);
580         uint256 _etherReceived =
581         (
582             // underflow attempts BTFO
583             SafeMath.sub(
584                 (
585                     (
586                         (
587                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
588                         )-tokenPriceIncremental_
589                     )*(tokens_ - 1e18)
590                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
591             )
592         /1e18);
593         return _etherReceived;
594     }
595     
596     
597     //This is where all your gas goes, sorry
598     //Not sorry, you probably only paid 1 gwei
599     function sqrt(uint x) internal pure returns (uint y) {
600         uint z = (x + 1) / 2;
601         y = x;
602         while (z < y) {
603             y = z;
604             z = (x / z + z) / 2;
605         }
606     }
607 }
608 
609 /**
610  * @title SafeMath
611  * @dev Math operations with safety checks that throw on error
612  */
613 library SafeMath {
614 
615     /**
616     * @dev Multiplies two numbers, throws on overflow.
617     */
618     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
619         if (a == 0) {
620             return 0;
621         }
622         uint256 c = a * b;
623         assert(c / a == b);
624         return c;
625     }
626 
627     /**
628     * @dev Integer division of two numbers, truncating the quotient.
629     */
630     function div(uint256 a, uint256 b) internal pure returns (uint256) {
631         // assert(b > 0); // Solidity automatically throws when dividing by 0
632         uint256 c = a / b;
633         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
634         return c;
635     }
636 
637     /**
638     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
639     */
640     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
641         assert(b <= a);
642         return a - b;
643     }
644 
645     /**
646     * @dev Adds two numbers, throws on overflow.
647     */
648     function add(uint256 a, uint256 b) internal pure returns (uint256) {
649         uint256 c = a + b;
650         assert(c >= a);
651         return c;
652     }
653 }