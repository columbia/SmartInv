1 pragma solidity ^0.4.25;
2  
3  /*
4  Strong Hands Holders
5  */
6  contract StrongHands {
7      /*=================================
8      =            MODIFIERS            =
9      =================================*/
10      // only people with tokens
11      modifier onlyBagholders() {
12          require(myTokens() > 0);
13          _;
14      }
15      
16      // only people with profits
17      modifier onlyStronghands() {
18          require(myDividends(true) > 0);
19          _;
20      }
21      
22      // There are no admins set in constructor. This always reverts.
23      modifier onlyAdministrator(){
24          address _customerAddress = msg.sender;
25          require(administrators[keccak256(_customerAddress)]);
26          _;
27      }
28      
29      /*==============================
30      =            EVENTS            =
31      ==============================*/
32      event onTokenPurchase(
33          address indexed customerAddress,
34          uint256 incomingEthereum,
35          uint256 tokensMinted,
36          address indexed referredBy
37      );
38      
39      event onTokenSell(
40          address indexed customerAddress,
41          uint256 tokensBurned,
42          uint256 ethereumEarned
43      );
44      
45      event onReinvestment(
46          address indexed customerAddress,
47          uint256 ethereumReinvested,
48          uint256 tokensMinted
49      );
50      
51      event onWithdraw(
52          address indexed customerAddress,
53          uint256 ethereumWithdrawn
54      );
55      
56      // ERC20
57      event Transfer(
58          address indexed from,
59          address indexed to,
60          uint256 tokens
61      );
62      
63      
64      /*=====================================
65      =            CONFIGURABLES            =
66      =====================================*/
67      string public name = "StrongHands";
68      string public symbol = "STH";
69      uint8 constant public decimals = 18;
70      uint8 constant internal dividendFee_ = 10;
71      uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
72      uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
73      uint256 constant internal magnitude = 2**64;
74      
75      // masternodes for all.
76      uint256 public stakingRequirement = 1;
77      
78      // ambassador program
79      mapping(address => bool) internal ambassadors_;
80      uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
81      uint256 constant internal ambassadorQuota_ = 20 ether;
82      
83      
84      
85     /*================================
86      =            DATASETS            =
87      ================================*/
88      // amount of shares for each address (scaled number)
89      mapping(address => uint256) internal tokenBalanceLedger_;
90      mapping(address => uint256) internal referralBalance_;
91      mapping(address => int256) internal payoutsTo_;
92      mapping(address => uint256) internal ambassadorAccumulatedQuota_;
93      uint256 internal tokenSupply_ = 0;
94      uint256 internal profitPerShare_;
95      
96      // administrator list, always empty.
97      mapping(bytes32 => bool) public administrators;
98      
99      // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
100      bool public onlyAmbassadors = false;
101      
102  
103  
104      /*=======================================
105      =            PUBLIC FUNCTIONS            =
106      =======================================*/
107      /*
108      * -- APPLICATION ENTRY POINTS --  
109      */
110      function Metadollar()
111          public
112      {
113  
114      }
115      
116       
117      /**
118       * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
119       */
120      function buy(address _referredBy)
121          public
122          payable
123          returns(uint256)
124      {
125          purchaseTokens(msg.value, _referredBy);
126      }
127      
128      /**
129       * Fallback function to handle ethereum that was send straight to the contract
130       * Unfortunately we cannot use a referral address this way.
131       */
132      function()
133          payable
134          public
135      {
136          purchaseTokens(msg.value, 0x0);
137      }
138      
139      /**
140       * Converts all of caller's dividends to tokens.
141       */
142      function reinvest()
143          onlyStronghands()
144          public
145      {
146          // fetch dividends
147          uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
148          
149          // pay out the dividends virtually
150          address _customerAddress = msg.sender;
151          payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
152          
153          // retrieve ref. bonus
154          _dividends += referralBalance_[_customerAddress];
155          referralBalance_[_customerAddress] = 0;
156          
157          // dispatch a buy order with the virtualized "withdrawn dividends"
158          uint256 _tokens = purchaseTokens(_dividends, 0x0);
159          
160          // fire event
161          onReinvestment(_customerAddress, _dividends, _tokens);
162      }
163      
164      /**
165       * Alias of sell() and withdraw().
166       */
167      function exit()
168          public
169      {
170          // get token count for caller & sell them all
171          address _customerAddress = msg.sender;
172          uint256 _tokens = tokenBalanceLedger_[_customerAddress];
173          if(_tokens > 0) sell(_tokens);
174          
175          // lambo delivery service
176          withdraw();
177      }
178  
179      /**
180       * Withdraws all of the callers earnings.
181       */
182      function withdraw()
183          onlyStronghands()
184          public
185      {
186          // setup data
187          address _customerAddress = msg.sender;
188          uint256 _dividends = myDividends(false); // get ref. bonus later in the code
189          
190          // update dividend tracker
191          payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
192          
193          // add ref. bonus
194          _dividends += referralBalance_[_customerAddress];
195          referralBalance_[_customerAddress] = 0;
196          
197          // lambo delivery service
198          _customerAddress.transfer(_dividends);
199          
200          // fire event
201          onWithdraw(_customerAddress, _dividends);
202      }
203      
204      /**
205       * Liquifies tokens to ethereum.
206       */
207      function sell(uint256 _amountOfTokens)
208          onlyBagholders()
209          public
210      {
211          // setup data
212          address _customerAddress = msg.sender;
213          // russian hackers BTFO
214          require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
215          uint256 _tokens = _amountOfTokens;
216          uint256 _ethereum = tokensToEthereum_(_tokens);
217          uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
218          uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
219          
220          // burn the sold tokens
221          tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
222          tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
223          
224          // update dividends tracker
225          int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
226          payoutsTo_[_customerAddress] -= _updatedPayouts;       
227          
228          // dividing by zero is a bad idea
229          if (tokenSupply_ > 0) {
230              // update the amount of dividends per token
231              profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
232          }
233          
234          // fire event
235          onTokenSell(_customerAddress, _tokens, _taxedEthereum);
236      }
237      
238      
239      /* Transfer tokens from the caller to a new holder. * No fee! */
240     function transfer(address _toAddress, uint256 _amountOfTokens) onlyBagholders() public returns(bool) {
241         // setup
242         address _customerAddress = msg.sender;
243 
244         // make sure we have the requested tokens
245         // also disables transfers until ambassador phase is over
246         // ( we dont want whale premines )
247         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
248 
249         // withdraw all outstanding dividends first
250         if(myDividends(true) > 0) withdraw();
251 
252         // exchange tokens
253         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
254         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
255 
256         // update dividend trackers
257         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
258         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
259 
260         // fire event
261         Transfer(_customerAddress, _toAddress, _amountOfTokens);
262 
263         // ERC20
264         return true;
265 
266         
267      }
268      
269      // These do nothing and are only left in for ABI comaptibility reasons.
270      /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
271      /**
272       * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
273       */
274      function disableInitialStage()
275          onlyAdministrator()
276          public
277      {
278          return;
279      }
280      
281      /**
282       * Replace Admin.
283       */
284      function setAdministrator(bytes32 _identifier, bool _status)
285          onlyAdministrator()
286          public
287      {
288          return;
289      }
290      
291      /**
292       * Precautionary measures in case we need to adjust the masternode rate.
293       */
294      function setStakingRequirement(uint256 _amountOfTokens)
295          onlyAdministrator()
296          public
297      {
298          return;
299      }
300      
301      /**
302       * If we want to rebrand, we can.
303       */
304      function setName(string _name)
305          onlyAdministrator()
306          public
307      {
308          return;
309      }
310      
311      /**
312       * If we want to rebrand, we can.
313       */
314      function setSymbol(string _symbol)
315          onlyAdministrator()
316          public
317      {
318          return;
319      }
320  
321      
322      /*----------  HELPERS AND CALCULATORS  ----------*/
323      /**
324       * Method to view the current Ethereum stored in the contract
325       * Example: totalEthereumBalance()
326       */
327      function totalEthereumBalance()
328          public
329          view
330          returns(uint)
331      {
332          return this.balance;
333      }
334      
335      /**
336       * Retrieve the total token supply.
337       */
338      function totalSupply()
339          public
340          view
341          returns(uint256)
342      {
343          return tokenSupply_;
344      }
345      
346      /**
347       * Retrieve the tokens owned by the caller.
348       */
349      function myTokens()
350          public
351          view
352          returns(uint256)
353      {
354          address _customerAddress = msg.sender;
355          return balanceOf(_customerAddress);
356      }
357      
358      /**
359       * Retrieve the dividends owned by the caller.
360       * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
361       * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
362       * But in the internal calculations, we want them separate. 
363       */ 
364      function myDividends(bool _includeReferralBonus) 
365          public 
366          view 
367          returns(uint256)
368      {
369          address _customerAddress = msg.sender;
370          return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
371      }
372      
373      /**
374       * Retrieve the token balance of any single address.
375       */
376      function balanceOf(address _customerAddress)
377          view
378          public
379          returns(uint256)
380      {
381          return tokenBalanceLedger_[_customerAddress];
382      }
383      
384      /**
385       * Retrieve the dividend balance of any single address.
386       */
387      function dividendsOf(address _customerAddress)
388          view
389          public
390          returns(uint256)
391      {
392          return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
393      }
394      
395      /**
396       * Return the buy price of 1 individual token.
397       */
398      function sellPrice() 
399          public 
400          view 
401          returns(uint256)
402      {
403          // our calculation relies on the token supply, so we need supply. Doh.
404          if(tokenSupply_ == 0){
405              return tokenPriceInitial_ - tokenPriceIncremental_;
406          } else {
407              uint256 _ethereum = tokensToEthereum_(1e18);
408              uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
409              uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
410              return _taxedEthereum;
411          }
412      }
413      
414      /**
415       * Return the sell price of 1 individual token.
416       */
417      function buyPrice() 
418          public 
419          view 
420          returns(uint256)
421      {
422          // our calculation relies on the token supply, so we need supply. Doh.
423          if(tokenSupply_ == 0){
424              return tokenPriceInitial_ + tokenPriceIncremental_;
425          } else {
426              uint256 _ethereum = tokensToEthereum_(1e18);
427              uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
428              uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
429              return _taxedEthereum;
430          }
431      }
432      
433      /**
434       * Function for the frontend to dynamically retrieve the price scaling of buy orders.
435       */
436      function calculateTokensReceived(uint256 _ethereumToSpend) 
437          public 
438          view 
439          returns(uint256)
440      {
441          uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
442          uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
443          uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
444          
445          return _amountOfTokens;
446      }
447      
448      /**
449       * Function for the frontend to dynamically retrieve the price scaling of sell orders.
450       */
451      function calculateEthereumReceived(uint256 _tokensToSell) 
452          public 
453          view 
454          returns(uint256)
455      {
456          require(_tokensToSell <= tokenSupply_);
457          uint256 _ethereum = tokensToEthereum_(_tokensToSell);
458          uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
459          uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
460          return _taxedEthereum;
461      }
462      
463      
464      /*==========================================
465      =            INTERNAL FUNCTIONS            =
466      ==========================================*/
467      function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
468          internal
469          returns(uint256)
470      {
471          // data setup
472          address _customerAddress = msg.sender;
473          uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
474          uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
475          uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
476          uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
477          uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
478          uint256 _fee = _dividends * magnitude;
479   
480          // no point in continuing execution if OP is a poorfag russian hacker
481          // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
482          // (or hackers)
483          // and yes we know that the safemath function automatically rules out the "greater then" equasion.
484          require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
485          
486          // is the user referred by a masternode?
487          if(
488              // is this a referred purchase?
489              _referredBy != 0x0000000000000000000000000000000000000000 &&
490  
491              // no cheating!
492              _referredBy != _customerAddress &&
493              
494              // does the referrer have at least X whole tokens?
495              // i.e is the referrer a godly chad masternode
496              tokenBalanceLedger_[_referredBy] >= stakingRequirement
497          ){
498              // wealth redistribution
499              referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
500          } else {
501              // no ref purchase
502              // add the referral bonus back to the global dividends cake
503              _dividends = SafeMath.add(_dividends, _referralBonus);
504              _fee = _dividends * magnitude;
505          }
506          
507          // we can't give people infinite ethereum
508          if(tokenSupply_ > 0){
509              
510              // add tokens to the pool
511              tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
512   
513              // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
514              profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
515              
516              // calculate the amount of tokens the customer receives over his purchase 
517              _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
518          
519          } else {
520              // add tokens to the pool
521              tokenSupply_ = _amountOfTokens;
522          }
523          
524          // update circulating supply & the ledger address for the customer
525          tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
526          
527          // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
528          //really i know you think you do but you don't
529          int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
530          payoutsTo_[_customerAddress] += _updatedPayouts;
531          
532          // fire event
533          onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
534          
535          return _amountOfTokens;
536      }
537  
538      /**
539       * Calculate Token price based on an amount of incoming ethereum
540       * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
541       * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
542       */
543      function ethereumToTokens_(uint256 _ethereum)
544          internal
545          view
546          returns(uint256)
547      {
548          uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
549          uint256 _tokensReceived = 
550           (
551              (
552                  // underflow attempts BTFO
553                  SafeMath.sub(
554                      (sqrt
555                          (
556                              (_tokenPriceInitial**2)
557                              +
558                              (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
559                              +
560                              (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
561                              +
562                              (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
563                          )
564                      ), _tokenPriceInitial
565                  )
566              )/(tokenPriceIncremental_)
567          )-(tokenSupply_)
568          ;
569    
570          return _tokensReceived;
571      }
572      
573      /**
574       * Calculate token sell value.
575       * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
576       * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
577       */
578       function tokensToEthereum_(uint256 _tokens)
579          internal
580          view
581          returns(uint256)
582      {
583  
584          uint256 tokens_ = (_tokens + 1e18);
585          uint256 _tokenSupply = (tokenSupply_ + 1e18);
586          uint256 _etherReceived =
587          (
588              // underflow attempts BTFO
589              SafeMath.sub(
590                  (
591                      (
592                          (
593                              tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
594                          )-tokenPriceIncremental_
595                      )*(tokens_ - 1e18)
596                  ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
597              )
598          /1e18);
599          return _etherReceived;
600      }
601      
602      
603      //This is where all your gas goes, sorry
604      //Not sorry, you probably only paid 1 gwei
605      function sqrt(uint x) internal pure returns (uint y) {
606          uint z = (x + 1) / 2;
607          y = x;
608          while (z < y) {
609              y = z;
610              z = (x / z + z) / 2;
611          }
612      }
613  }
614  
615  /**
616   * @title SafeMath
617   * @dev Math operations with safety checks that throw on error
618   */
619  library SafeMath {
620  
621      /**
622      * @dev Multiplies two numbers, throws on overflow.
623      */
624      function mul(uint256 a, uint256 b) internal pure returns (uint256) {
625          if (a == 0) {
626              return 0;
627          }
628          uint256 c = a * b;
629          assert(c / a == b);
630          return c;
631      }
632  
633      /**
634      * @dev Integer division of two numbers, truncating the quotient.
635      */
636      function div(uint256 a, uint256 b) internal pure returns (uint256) {
637          // assert(b > 0); // Solidity automatically throws when dividing by 0
638          uint256 c = a / b;
639          // assert(a == b * c + a % b); // There is no case in which this doesn't hold
640          return c;
641      }
642  
643      /**
644      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
645      */
646      function sub(uint256 a, uint256 b) internal pure returns (uint256) {
647          assert(b <= a);
648          return a - b;
649      }
650  
651      /**
652      * @dev Adds two numbers, throws on overflow.
653      */
654      function add(uint256 a, uint256 b) internal pure returns (uint256) {
655          uint256 c = a + b;
656          assert(c >= a);
657          return c;
658      }
659  }