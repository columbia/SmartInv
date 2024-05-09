1 pragma solidity ^0.4.24;
2 
3 
4 /* Smart Contract Security Audit by Callisto Network */
5  
6 /* Mizhen Boss represents the right of being a member of Mizhen community 
7  * Holders can use different tools and share profits in all the games developed by Mizhen team
8  * Total number of MZBoss is 21,000,000
9  * The price of MZBoss is constant at 0.005 ether
10  * Purchase fee is 15%, pay customers buy MZBoss, of which 10% is distributed to tokenholders, 5% is sent to community for further development.
11  * There is not selling fee
12  * The purchase fee is evenly distributed to the existing MZBoss holders
13  * All MZBoss holders will receive profit from different game pots
14  * Mizhen Team
15  */
16  
17 contract MZBoss {
18     /*=================================
19     =            MODIFIERS            =
20     =================================*/
21     // only people with tokens
22     modifier transferCheck(uint256 _amountOfTokens) {
23         address _customerAddress = msg.sender;
24         require((_amountOfTokens > 0) && (_amountOfTokens <= tokenBalanceLedger_[_customerAddress]));
25         _;
26     }
27     
28     // only people with profits
29     modifier onlyStronghands() {
30         address _customerAddress = msg.sender;
31         require(dividendsOf(_customerAddress) > 0);
32         _;
33     }
34     
35     // Check if the play has enough ETH to buy tokens
36     modifier enoughToreinvest() {
37         address _customerAddress = msg.sender;
38         uint256 priceForOne = (tokenPriceInitial_*100)/85;
39         require((dividendsOf(_customerAddress) >= priceForOne) && (_tokenLeft >= calculateTokensReceived(dividendsOf(_customerAddress))));
40         _; 
41     } 
42     
43     // administrators can:
44     // -> change the name of the contract
45     // -> change the name of the token
46     // they CANNOT:
47     // -> take funds
48     // -> disable withdrawals
49     // -> kill the contract
50     // -> change the price of tokens
51     modifier onlyAdministrator(){
52         address _customerAddress = msg.sender;
53         require(administrators[_customerAddress] == true);
54         _;
55     }
56     
57     // Check if the play has enough ETH to buy tokens
58     modifier enoughToBuytoken (){
59         uint256 _amountOfEthereum = msg.value;
60         uint256 priceForOne = (tokenPriceInitial_*100)/85;
61         require((_amountOfEthereum >= priceForOne) && (_tokenLeft >= calculateTokensReceived(_amountOfEthereum)));
62         _; 
63     } 
64     
65     /*==============================
66     =            EVENTS            =
67     ==============================*/
68     
69     event OnTokenPurchase(
70         address indexed customerAddress,
71         uint256 incomingEthereum,
72         uint256 tokensBought,
73         uint256 tokenSupplyUpdate,
74         uint256 tokenLeftUpdate
75     );
76     
77     event OnTokenSell(
78         address indexed customerAddress,
79         uint256 tokensSold,
80         uint256 ethereumEarned,
81         uint256 tokenSupplyUpdate,
82         uint256 tokenLeftUpdate
83     );
84     
85     event OnReinvestment(
86         address indexed customerAddress,
87         uint256 ethereumReinvested,
88         uint256 tokensBought,
89         uint256 tokenSupplyUpdate,
90         uint256 tokenLeftUpdate
91     );
92     
93     event OnWithdraw(
94         address indexed customerAddress,
95         uint256 ethereumWithdrawn
96     );
97     
98     
99     // distribution of profit from pot
100     event OnTotalProfitPot(
101         uint256 _totalProfitPot
102     );
103     
104     // ERC20
105     event Transfer(
106         address indexed from,
107         address indexed to,
108         uint256 tokens
109     );
110     
111     
112     /*=====================================
113     =            CONFIGURABLES            =
114     =====================================*/
115     string public name = "Mizhen";
116     string public symbol = "MZBoss";
117     uint256 constant public totalToken = 21000000e18; //total 21000000 MZBoss tokens 
118     uint8 constant public decimals = 18;
119     uint8 constant internal dividendFee_ = 10; // percentage of fee sent to token holders 
120     uint8 constant internal toCommunity_ = 5; // percentage of fee sent to community. 
121     uint256 constant internal tokenPriceInitial_ = 5e15; // the price is constant and does not change as the purchase increases.
122     uint256 constant internal magnitude = 1e18; // related to payoutsTo_, profitPershare_, profitPerSharePot_, profitPerShareNew_
123 
124     
125     // ambassador program
126     mapping(address => bool) internal ambassadors_;
127     uint256 constant internal ambassadorMaxPurchase_ = 1e19;
128     uint256 constant internal ambassadorQuota_ = 1e19;
129     
130     // exchange address, in the future customers can exchange MZBoss without the price limitation
131     mapping(address => bool) public exchangeAddress_;
132     
133    /*================================
134     =            DATASETS            =
135     ================================*/
136     // amount of shares for each address (scaled number)
137     mapping(address => uint256) public tokenBalanceLedger_;
138     mapping(address => int256) internal payoutsTo_;
139     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
140 
141     uint256 public tokenSupply_ = 0; // total sold tokens 
142     uint256 public _tokenLeft = 21000000e18;
143     uint256 public totalEthereumBalance1 = 0;
144     uint256 public profitPerShare_ = 0 ;
145 
146     uint256 public _totalProfitPot = 0;
147     address constant internal _communityAddress = 0x43e8587aCcE957629C9FD2185dD700dcDdE1dD1E;
148     
149     // administrator list (see above on what they can do)
150     mapping(address => bool) public administrators;
151     
152     // when this is set to true, only ambassadors can purchase tokens 
153     bool public onlyAmbassadors = true;
154 
155 
156     /*=======================================
157     =            PUBLIC FUNCTIONS            =
158     =======================================*/
159     /*
160     * -- APPLICATION ENTRY POINTS --  
161     */
162     constructor ()
163         public
164     
165     {
166         // add administrators here
167         administrators[0x6dAd1d9D24674bC9199237F93beb6E25b55Ec763] = true;
168 
169         // add the ambassadors here.
170         ambassadors_[0x64BFD8F0F51569AEbeBE6AD2a1418462bCBeD842] = true;
171     }
172     
173     function purchaseTokens()  
174         enoughToBuytoken ()
175         public
176         payable
177     {
178            address _customerAddress = msg.sender;
179            uint256 _amountOfEthereum = msg.value;
180         
181         // are we still in the ambassador phase? 
182         if( onlyAmbassadors && (SafeMath.sub(totalEthereumBalance(), _amountOfEthereum) < ambassadorQuota_ )){ 
183             require(
184                 // is the customer in the ambassador list? 
185                 (ambassadors_[_customerAddress] == true) &&
186                 
187                 // does the customer purchase exceed the max ambassador quota? 
188                 (SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum) <= ambassadorMaxPurchase_)
189             );
190             
191             // updated the accumulated quota    
192             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
193             
194             totalEthereumBalance1 = SafeMath.add(totalEthereumBalance1, _amountOfEthereum);
195             uint256 _amountOfTokens = ethereumToTokens_(_amountOfEthereum); 
196             
197             tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
198             
199             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens); 
200             
201             _tokenLeft = SafeMath.sub(totalToken, tokenSupply_); 
202             
203             emit OnTokenPurchase(_customerAddress, _amountOfEthereum, _amountOfTokens, tokenSupply_, _tokenLeft);
204          
205         } 
206         
207         else {
208             // in case the ether count drops low, the ambassador phase won't reinitiate
209             onlyAmbassadors = false;
210             
211             purchaseTokensAfter(_amountOfEthereum); 
212                 
213         }
214         
215     }
216     
217     /**
218      * profit distribution from game pot
219      */
220     function potDistribution()
221         public
222         payable
223     {
224         //
225         require(msg.value > 0);
226         uint256 _incomingEthereum = msg.value;
227         if(tokenSupply_ > 0){
228             
229             // profit per share 
230             uint256 profitPerSharePot_ = SafeMath.mul(_incomingEthereum, magnitude) / (tokenSupply_);
231             
232             // update profitPerShare_, adding profit from game pot
233             profitPerShare_ = SafeMath.add(profitPerShare_, profitPerSharePot_);
234             
235         } else {
236             // send to community
237             payoutsTo_[_communityAddress] -=  (int256) (_incomingEthereum);
238             
239         }
240         
241         //update _totalProfitPot
242         _totalProfitPot = SafeMath.add(_incomingEthereum, _totalProfitPot); 
243     }
244     
245     /**
246      * Converts all of caller's dividends to tokens.
247      */
248     function reinvest()
249         enoughToreinvest()
250         public
251     {
252         
253         // pay out the dividends virtually
254         address _customerAddress = msg.sender;
255         
256         // fetch dividends
257         uint256 _dividends = dividendsOf(_customerAddress); 
258         
259         uint256 priceForOne = (tokenPriceInitial_*100)/85;
260         
261         // minimum purchase 1 ether token
262         if (_dividends >= priceForOne) { 
263         
264         // dispatch a buy order with the virtualized "withdrawn dividends"
265         purchaseTokensAfter(_dividends);
266             
267         payoutsTo_[_customerAddress] +=  (int256) (_dividends);
268         
269         }
270         
271     }
272     
273     /**
274      * Withdraws all of the callers earnings.
275      */
276     function withdraw()
277         onlyStronghands()
278         public
279     {
280         // setup data
281         address _customerAddress = msg.sender;
282         uint256 _dividends = dividendsOf(_customerAddress); 
283         
284         // update dividend tracker, in order to calculate with payoutsTo which is int256, _dividends need to be casted to int256 first
285         payoutsTo_[_customerAddress] +=  (int256) (_dividends);
286 
287         
288         // send eth
289         _customerAddress.transfer(_dividends);
290         
291         // fire event
292         emit OnWithdraw(_customerAddress, _dividends);
293     }
294     
295     /**
296      * Liquifies tokens to ethereum.
297      */
298     function sell(uint256 _amountOfTokens)
299         public
300     {
301         // setup data
302         address _customerAddress = msg.sender;
303         uint256 _tokens = _amountOfTokens;
304         uint256 _ethereum = tokensToEthereum_(_tokens);
305         uint256 _taxedEthereum = SafeMath.sub(_ethereum, 0); // no fee when sell, but there is transaction fee included here
306         
307         require((tokenBalanceLedger_[_customerAddress] >= _amountOfTokens) && ( totalEthereumBalance1 >= _taxedEthereum ) && (_amountOfTokens > 0));
308         
309         // update the amount of the sold tokens
310         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
311         totalEthereumBalance1 = SafeMath.sub(totalEthereumBalance1, _taxedEthereum);
312         
313         // update dividends tracker
314         int256 _updatedPayouts = (int256) (SafeMath.add(SafeMath.mul(profitPerShare_, _tokens)/magnitude, _taxedEthereum));
315         payoutsTo_[_customerAddress] -= _updatedPayouts;       
316         
317         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
318         _tokenLeft = SafeMath.sub(totalToken, tokenSupply_);
319         
320         // fire event
321         emit OnTokenSell(_customerAddress, _tokens, _taxedEthereum, tokenSupply_, _tokenLeft);
322     }
323     
324     /**
325      * Transfer tokens from the caller to a new holder.
326      */
327     function transfer(uint256 _amountOfTokens, address _toAddress)
328         transferCheck(_amountOfTokens)
329         public
330         returns(bool)
331     {
332         // setup
333         address _customerAddress = msg.sender;
334 
335         // withdraw all outstanding dividends first
336         if(dividendsOf(_customerAddress) > 0) withdraw();
337 
338         // exchange tokens
339         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
340         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
341         
342         // update dividend trackers
343         payoutsTo_[_customerAddress] -= (int256) (SafeMath.mul(profitPerShare_ , _amountOfTokens)/magnitude);
344         payoutsTo_[_toAddress] += (int256) (SafeMath.mul(profitPerShare_ , _amountOfTokens)/magnitude);
345         
346         // fire event
347         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
348         
349         // ERC20
350         return true;
351        
352     }
353 
354     
355     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
356     /**
357      * In case we need to replace ourselves.
358      */
359     function setAdministrator(address _identifier, bool _status)
360         onlyAdministrator()
361         public
362     {
363         administrators[_identifier] = _status;
364     }
365     
366     /**
367      * If we want to rebrand, we can.
368      */
369     function setName(string _name)
370         onlyAdministrator()
371         public
372     {
373         name = _name;
374     }
375     
376     /**
377      * If we want to rebrand, we can.
378      */
379     function setSymbol(string _symbol)
380         onlyAdministrator()
381         public
382     {
383         symbol = _symbol;
384     }
385 
386     
387     /*----------  HELPERS AND CALCULATORS  ----------*/
388     /**
389      * Method to view the current Ethereum stored in the contract
390      * 
391      */
392     function totalEthereumBalance()
393         public
394         view
395         returns(uint)
396     {
397         return address(this).balance;
398     }
399     
400     /**
401      * Method to view the current sold tokens
402      * 
403      */
404     function tokenSupply()
405         public
406         view
407         returns(uint256)
408     {
409         return tokenSupply_;
410     }
411     
412     /**
413      * Retrieve the token balance of any single address.
414      */
415     function balanceOf(address _customerAddress)
416         public
417         view
418         returns(uint256)
419     {
420         return tokenBalanceLedger_[_customerAddress];
421     }
422     
423     /**
424      * Retrieve the payoutsTo_ of any single address.
425      */
426     function payoutsTo(address _customerAddress)
427         public
428         view
429         returns(int256)
430     {
431         return payoutsTo_[_customerAddress];
432     }
433     
434     /**
435      * Retrieve the tokens owned by the caller.
436      */
437     function myTokens()
438         public
439         view
440         returns(uint256)
441     {
442         address _customerAddress = msg.sender;
443         return balanceOf(_customerAddress);
444     }
445     
446     /**
447      * Retrieve the dividend balance of any single address.
448      */
449     function dividendsOf(address _customerAddress)
450         public 
451         view
452         returns(uint256)
453     {
454         
455         uint256 _TokensEther = tokenBalanceLedger_[_customerAddress];
456         
457         if ((int256(SafeMath.mul(profitPerShare_, _TokensEther)/magnitude) - payoutsTo_[_customerAddress]) > 0 )
458            return uint256(int256(SafeMath.mul(profitPerShare_, _TokensEther)/magnitude) - payoutsTo_[_customerAddress]);  
459         else 
460            return 0;
461     }
462 
463     
464     /**
465      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
466      */
467     function calculateTokensReceived(uint256 _ethereumToSpend) 
468         public 
469         pure 
470         returns(uint256)
471     {
472         uint256 _dividends = SafeMath.mul(_ethereumToSpend, dividendFee_) / 100;
473         uint256 _communityDistribution = SafeMath.mul(_ethereumToSpend, toCommunity_) / 100;
474         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, SafeMath.add(_communityDistribution,_dividends));
475         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
476         
477         return _amountOfTokens;
478     }
479     
480     /**
481      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
482      */
483     function calculateEthereumReceived(uint256 _tokensToSell) 
484         public 
485         pure 
486         returns(uint256)
487     {
488         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
489         uint256 _taxedEthereum = SafeMath.sub(_ethereum, 0); // transaction fee
490         return _taxedEthereum;
491     }
492     
493 
494     /*==========================================
495     =            INTERNAL FUNCTIONS            =
496     ==========================================*/
497     function purchaseTokensAfter(uint256 _incomingEthereum) 
498         private
499     {
500         // data setup
501         address _customerAddress = msg.sender;
502         
503         // distribution as dividend to token holders
504         uint256 _dividends = SafeMath.mul(_incomingEthereum, dividendFee_) / 100; 
505         
506         // sent to community address
507         uint256 _communityDistribution = SafeMath.mul(_incomingEthereum, toCommunity_) / 100;
508         
509         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, SafeMath.add(_communityDistribution, _dividends));
510         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum); 
511 
512         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
513         // minimum purchase 1 token
514         require((_amountOfTokens >= 1e18) && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_)); 
515 
516         
517         // profitPerShare calculation assuming the _dividends are only distributed to the holders before the new customer
518         // the tokenSupply_ here is the supply without considering the new customer's buying amount
519         
520         if (tokenSupply_ == 0){
521             
522             uint256 profitPerShareNew_ = 0;
523         }else{
524             
525             profitPerShareNew_ = SafeMath.mul(_dividends, magnitude) / (tokenSupply_); 
526         } 
527         
528         // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
529         profitPerShare_ = SafeMath.add(profitPerShare_, profitPerShareNew_); 
530         
531         // assumed total dividends considering the new customer's buying amount 
532         uint256 _dividendsAssumed = SafeMath.div(SafeMath.mul(profitPerShare_, _amountOfTokens), magnitude);
533             
534         // extra dividends in the assumed dividens, which does not exist 
535         // this part is considered as the existing payoutsTo_ to the new customer
536         uint256 _dividendsExtra = _dividendsAssumed;
537         
538         
539         // update the new customer's payoutsTo_; cast _dividendsExtra to int256 first because payoutsTo is int256
540         payoutsTo_[_customerAddress] += (int256) (_dividendsExtra);
541             
542         // add tokens to the pool, update the tokenSupply_
543         tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens); 
544             
545         _tokenLeft = SafeMath.sub(totalToken, tokenSupply_);
546         totalEthereumBalance1 = SafeMath.add(totalEthereumBalance1, _taxedEthereum);
547         
548         // send to community
549         _communityAddress.transfer(_communityDistribution);
550         
551         // update circulating supply & the ledger address for the customer
552         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
553         
554         // fire event
555         emit OnTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, tokenSupply_, _tokenLeft);
556     }
557 
558     /**
559      * Calculate Token price based on an amount of incoming ethereum
560      */
561     function ethereumToTokens_(uint256 _ethereum)
562         internal
563         pure
564         returns(uint256)
565     {
566         require (_ethereum > 0);
567         uint256 _tokenPriceInitial = tokenPriceInitial_;
568         
569         uint256 _tokensReceived = SafeMath.mul(_ethereum, magnitude) / _tokenPriceInitial;
570                     
571         return _tokensReceived;
572     }
573     
574     /**
575      * Calculate token sell value.
576      */
577      function tokensToEthereum_(uint256 _tokens)
578         internal
579         pure
580         returns(uint256)
581     {   
582         uint256 tokens_ = _tokens;
583         
584         uint256 _etherReceived = SafeMath.mul (tokenPriceInitial_, tokens_) / magnitude;
585             
586         return _etherReceived;
587     }
588     
589 }
590 
591 /**
592  * @title SafeMath
593  * @dev Math operations with safety checks that throw on error
594  */
595 library SafeMath {
596 
597     /**
598     * @dev Multiplies two numbers, throws on overflow.
599     */
600     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
601         if (a == 0) {
602             return 0;
603         }
604         uint256 c = a * b;
605         assert(c / a == b);
606         return c;
607     }
608 
609     /**
610     * @dev Integer division of two numbers, truncating the quotient.
611     */
612     function div(uint256 a, uint256 b) internal pure returns (uint256) {
613         // assert(b > 0); // Solidity automatically throws when dividing by 0
614         uint256 c = a / b;
615         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
616         return c;
617     }
618 
619     /**
620     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
621     */
622     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
623         assert(b <= a);
624         return a - b;
625     }
626 
627     /**
628     * @dev Adds two numbers, throws on overflow.
629     */
630     function add(uint256 a, uint256 b) internal pure returns (uint256) {
631         uint256 c = a + b;
632         assert(c >= a);
633         return c;
634     }
635 }