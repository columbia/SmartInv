1 pragma solidity ^0.4.20;
2 
3 /*
4 * Team JUST presents..
5 * ====================================*
6 *  _____   ______          ___        *
7 * |  __ \ / __ \ \        / / |       *
8 * | |__) | |  | \ \  /\  / /| |       *
9 * |  ___/| |  | |\ \/  \/ / | |       *
10 * | |    | |__| | \  /\  /  | |____   *
11 * |_|     \____/   \/  \/   |______|  *
12 * ====================================*
13 * -> What?
14 * This source code is copy of Proof of Weak Hands (POWH3D)
15 * Only difference is that, you will receive 20% dividends.
16 * Call us copycats coz we love cats :)
17 */
18 
19 contract Hourglass {
20     /*=================================
21     =            MODIFIERS            =
22     =================================*/
23     // only people with tokens
24     modifier onlyBagholders() {
25         require(myTokens() > 0);
26         _;
27     }
28     
29     // only people with profits
30     modifier onlyStronghands() {
31         require(myDividends(true) > 0);
32         _;
33     }
34     
35     // administrators can:
36     // -> change the name of the contract
37     // -> change the name of the token
38     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
39     // they CANNOT:
40     // -> take funds
41     // -> disable withdrawals
42     // -> kill the contract
43     // -> change the price of tokens
44     modifier onlyAdministrator(){
45         address _customerAddress = msg.sender;
46         require(administrators[keccak256(_customerAddress)]);
47         _;
48     }
49     
50     
51     // ensures that the first tokens in the contract will be equally distributed
52     // meaning, no divine dump will be ever possible
53     // result: healthy longevity.
54     modifier antiEarlyWhale(uint256 _amountOfEthereum){
55         address _customerAddress = msg.sender;
56         
57         // are we still in the vulnerable phase?
58         // if so, enact anti early whale protocol 
59         if( onlyAmbassadors && ((totalEthereumBalance() - _amountOfEthereum) <= ambassadorQuota_ )){
60             require(
61                 // is the customer in the ambassador list?
62                 ambassadors_[_customerAddress] == true &&
63                 
64                 // does the customer purchase exceed the max ambassador quota?
65                 (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfEthereum) <= ambassadorMaxPurchase_
66                 
67             );
68             
69             // updated the accumulated quota    
70             ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfEthereum);
71         
72             // execute
73             _;
74         } else {
75             // in case the ether count drops low, the ambassador phase won't reinitiate
76             onlyAmbassadors = false;
77             _;    
78         }
79         
80     }
81     
82     
83     /*==============================
84     =            EVENTS            =
85     ==============================*/
86     event onTokenPurchase(
87         address indexed customerAddress,
88         uint256 incomingEthereum,
89         uint256 tokensMinted,
90         address indexed referredBy
91     );
92     
93     event onTokenSell(
94         address indexed customerAddress,
95         uint256 tokensBurned,
96         uint256 ethereumEarned
97     );
98     
99     event onReinvestment(
100         address indexed customerAddress,
101         uint256 ethereumReinvested,
102         uint256 tokensMinted
103     );
104     
105     event onWithdraw(
106         address indexed customerAddress,
107         uint256 ethereumWithdrawn
108     );
109     
110     // ERC20
111     event Transfer(
112         address indexed from,
113         address indexed to,
114         uint256 tokens
115     );
116     
117     
118     /*=====================================
119     =            CONFIGURABLES            =
120     =====================================*/
121     string public name = "POWL";
122     string public symbol = "POWL";
123     uint8 constant public decimals = 18;
124     uint8 constant internal dividendFee_ = 20;
125     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
126     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
127     uint256 constant internal magnitude = 2**64;
128     
129     // proof of stake (defaults at 100 tokens)
130     uint256 public stakingRequirement = 100e18;
131     
132     // ambassador program
133     mapping(address => bool) internal ambassadors_;
134     uint256 constant internal ambassadorMaxPurchase_ = 1 ether;
135     uint256 constant internal ambassadorQuota_ = 20 ether;
136     
137     
138     
139    /*================================
140     =            DATASETS            =
141     ================================*/
142     // amount of shares for each address (scaled number)
143     mapping(address => uint256) internal tokenBalanceLedger_;
144     mapping(address => uint256) internal referralBalance_;
145     mapping(address => int256) internal payoutsTo_;
146     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
147     uint256 internal tokenSupply_ = 0;
148     uint256 internal profitPerShare_;
149     
150     // administrator list (see above on what they can do)
151     mapping(bytes32 => bool) public administrators;
152     
153     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
154     bool public onlyAmbassadors = true;
155     
156 
157 
158     /*=======================================
159     =            PUBLIC FUNCTIONS            =
160     =======================================*/
161     /*
162     * -- APPLICATION ENTRY POINTS --  
163     */
164     function Hourglass()
165         public
166     {
167         // add administrators here
168         administrators[0x909b33773fe2c245e253e4d2403e3edd353517c30bc1a85b98d78b392e5fd2c1] = true;
169         
170         // add the ambassadors here.
171         // rackoo - lead solidity dev & lead web dev. 
172         ambassadors_[0xbe3569068562218c792cf25b98dbf1418aff2455] = true;
173         
174         // noncy - Aunt responsible for feeding us.
175         ambassadors_[0x17b88dc23dacf6a905356a342a0d88f055a52f07] = true;
176         
177         //tipso - ctrl+c and ctrl+v expert
178         ambassadors_[0xda335f08bec7d84018628c4c9e18c7ef076d8c30] = true;
179         
180         //powl chat - chat expert
181         ambassadors_[0x99d63938007553c3ec9ce032cd94c3655360c197] = true;
182         
183         //pipper - shiller
184         ambassadors_[0x3595072a72390aa733f9389d61e384b89122fff6] = true;
185         
186         //vai - Solidity newbie
187         ambassadors_[0x575850eb0bad2ef3d153d60b6e768c7648c4daeb] = true;
188         
189         //sudpe - Developer
190         ambassadors_[0x80622cb543e2ec10bf210756b0f5fa819a945409] = true; //ho
191         
192         
193         //private dudes
194         ambassadors_[0x8cba9adeb6db06980d9efa38ccf8c50ec1a44335] = true; //ml
195         ambassadors_[0x8c77aab3bf3b55786cb168223b66fbcac1add480] = true; //of
196         ambassadors_[0x54c7cd8969b8e64be047a9808e417e43e7336f00] = true; //kd
197         ambassadors_[0xe9d3a8cd1a7738c52ea1dc5705b4a3cc7132a227] = true; //rr
198         ambassadors_[0x6ca6ef7be51b9504fdcd98ef11908a41d9555dc9] = true; //ms
199         ambassadors_[0x1af7a66440af07e8c31526f5b921e480792f3c5f] = true; //ol
200         ambassadors_[0x798ce730e70f26624924011e1fac8a821d0ff0e7] = true; //we
201         ambassadors_[0x059d0f67c2d4c18b09c2b91ff13a4648a19d68a2] = true; //nb
202         ambassadors_[0x575850eb0bad2ef3d153d60b6e768c7648c4daeb] = true; //ho
203         ambassadors_[0xe3de1731a6d018e2dcd0ad233c870c4aac8e0d54] = true; //pm
204         ambassadors_[0x49b2bf937ca3f7029e2b1b1aa8445c8497da6464] = true; //tp
205         ambassadors_[0xc99868aaa529ebc4c2d7f6e97efc0d883ddbbeec] = true; //sr
206         ambassadors_[0x558d94edc943e0b4dd75001bc91750711e5c8239] = true; //lj
207         ambassadors_[0xd87dd0cd32e1076c52d87175da74a98ece6794a0] = true; //mh
208         ambassadors_[0xde24622f20c56cbf1a3ab75d078ebe42da7ed7b9] = true; //kb
209         ambassadors_[0x65d24fffaeb0b49a5bfbaf0ad7c180d61d012312] = true; //ta
210         
211         
212 
213     }
214     
215      
216     /**
217      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
218      */
219     function buy(address _referredBy)
220         public
221         payable
222         returns(uint256)
223     {
224         purchaseTokens(msg.value, _referredBy);
225     }
226     
227     /**
228      * Fallback function to handle ethereum that was send straight to the contract
229      * Unfortunately we cannot use a referral address this way.
230      */
231     function()
232         payable
233         public
234     {
235         purchaseTokens(msg.value, 0x0);
236     }
237     
238     /**
239      * Converts all of caller's dividends to tokens.
240      */
241     function reinvest()
242         onlyStronghands()
243         public
244     {
245         // fetch dividends
246         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
247         
248         // pay out the dividends virtually
249         address _customerAddress = msg.sender;
250         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
251         
252         // retrieve ref. bonus
253         _dividends += referralBalance_[_customerAddress];
254         referralBalance_[_customerAddress] = 0;
255         
256         // dispatch a buy order with the virtualized "withdrawn dividends"
257         uint256 _tokens = purchaseTokens(_dividends, 0x0);
258         
259         // fire event
260         onReinvestment(_customerAddress, _dividends, _tokens);
261     }
262     
263     /**
264      * Alias of sell() and withdraw().
265      */
266     function exit()
267         public
268     {
269         // get token count for caller & sell them all
270         address _customerAddress = msg.sender;
271         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
272         if(_tokens > 0) sell(_tokens);
273         
274         // lambo delivery service
275         withdraw();
276     }
277 
278     /**
279      * Withdraws all of the callers earnings.
280      */
281     function withdraw()
282         onlyStronghands()
283         public
284     {
285         // setup data
286         address _customerAddress = msg.sender;
287         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
288         
289         // update dividend tracker
290         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
291         
292         // add ref. bonus
293         _dividends += referralBalance_[_customerAddress];
294         referralBalance_[_customerAddress] = 0;
295         
296         // lambo delivery service
297         _customerAddress.transfer(_dividends);
298         
299         // fire event
300         onWithdraw(_customerAddress, _dividends);
301     }
302     
303     /**
304      * Liquifies tokens to ethereum.
305      */
306     function sell(uint256 _amountOfTokens)
307         onlyBagholders()
308         public
309     {
310         // setup data
311         address _customerAddress = msg.sender;
312         // russian hackers BTFO
313         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
314         uint256 _tokens = _amountOfTokens;
315         uint256 _ethereum = tokensToEthereum_(_tokens);
316         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
317         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
318         
319         // burn the sold tokens
320         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
321         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
322         
323         // update dividends tracker
324         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
325         payoutsTo_[_customerAddress] -= _updatedPayouts;       
326         
327         // dividing by zero is a bad idea
328         if (tokenSupply_ > 0) {
329             // update the amount of dividends per token
330             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
331         }
332         
333         // fire event
334         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
335     }
336     
337     
338     /**
339      * Transfer tokens from the caller to a new holder.
340      * Remember, there's a 10% fee here as well.
341      */
342     function transfer(address _toAddress, uint256 _amountOfTokens)
343         onlyBagholders()
344         public
345         returns(bool)
346     {
347         // setup
348         address _customerAddress = msg.sender;
349         
350         // make sure we have the requested tokens
351         // also disables transfers until ambassador phase is over
352         // ( we dont want whale premines )
353         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
354         
355         // withdraw all outstanding dividends first
356         if(myDividends(true) > 0) withdraw();
357         
358         // liquify 10% of the tokens that are transfered
359         // these are dispersed to shareholders
360         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
361         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
362         uint256 _dividends = tokensToEthereum_(_tokenFee);
363   
364         // burn the fee tokens
365         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
366 
367         // exchange tokens
368         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
369         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
370         
371         // update dividend trackers
372         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
373         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
374         
375         // disperse dividends among holders
376         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
377         
378         // fire event
379         Transfer(_customerAddress, _toAddress, _taxedTokens);
380         
381         // ERC20
382         return true;
383        
384     }
385     
386     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
387     /**
388      * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
389      */
390     function disableInitialStage()
391         onlyAdministrator()
392         public
393     {
394         onlyAmbassadors = false;
395     }
396     
397     /**
398      * In case one of us dies, we need to replace ourselves.
399      */
400     function setAdministrator(bytes32 _identifier, bool _status)
401         onlyAdministrator()
402         public
403     {
404         administrators[_identifier] = _status;
405     }
406     
407     /**
408      * Precautionary measures in case we need to adjust the masternode rate.
409      */
410     function setStakingRequirement(uint256 _amountOfTokens)
411         onlyAdministrator()
412         public
413     {
414         stakingRequirement = _amountOfTokens;
415     }
416     
417     /**
418      * If we want to rebrand, we can.
419      */
420     function setName(string _name)
421         onlyAdministrator()
422         public
423     {
424         name = _name;
425     }
426     
427     /**
428      * If we want to rebrand, we can.
429      */
430     function setSymbol(string _symbol)
431         onlyAdministrator()
432         public
433     {
434         symbol = _symbol;
435     }
436 
437     
438     /*----------  HELPERS AND CALCULATORS  ----------*/
439     /**
440      * Method to view the current Ethereum stored in the contract
441      * Example: totalEthereumBalance()
442      */
443     function totalEthereumBalance()
444         public
445         view
446         returns(uint)
447     {
448         return this.balance;
449     }
450     
451     /**
452      * Retrieve the total token supply.
453      */
454     function totalSupply()
455         public
456         view
457         returns(uint256)
458     {
459         return tokenSupply_;
460     }
461     
462     /**
463      * Retrieve the tokens owned by the caller.
464      */
465     function myTokens()
466         public
467         view
468         returns(uint256)
469     {
470         address _customerAddress = msg.sender;
471         return balanceOf(_customerAddress);
472     }
473     
474     /**
475      * Retrieve the dividends owned by the caller.
476      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
477      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
478      * But in the internal calculations, we want them separate. 
479      */ 
480     function myDividends(bool _includeReferralBonus) 
481         public 
482         view 
483         returns(uint256)
484     {
485         address _customerAddress = msg.sender;
486         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
487     }
488     
489     /**
490      * Retrieve the token balance of any single address.
491      */
492     function balanceOf(address _customerAddress)
493         view
494         public
495         returns(uint256)
496     {
497         return tokenBalanceLedger_[_customerAddress];
498     }
499     
500     /**
501      * Retrieve the dividend balance of any single address.
502      */
503     function dividendsOf(address _customerAddress)
504         view
505         public
506         returns(uint256)
507     {
508         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
509     }
510     
511     /**
512      * Return the buy price of 1 individual token.
513      */
514     function sellPrice() 
515         public 
516         view 
517         returns(uint256)
518     {
519         // our calculation relies on the token supply, so we need supply. Doh.
520         if(tokenSupply_ == 0){
521             return tokenPriceInitial_ - tokenPriceIncremental_;
522         } else {
523             uint256 _ethereum = tokensToEthereum_(1e18);
524             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
525             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
526             return _taxedEthereum;
527         }
528     }
529     
530     /**
531      * Return the sell price of 1 individual token.
532      */
533     function buyPrice() 
534         public 
535         view 
536         returns(uint256)
537     {
538         // our calculation relies on the token supply, so we need supply. Doh.
539         if(tokenSupply_ == 0){
540             return tokenPriceInitial_ + tokenPriceIncremental_;
541         } else {
542             uint256 _ethereum = tokensToEthereum_(1e18);
543             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
544             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
545             return _taxedEthereum;
546         }
547     }
548     
549     /**
550      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
551      */
552     function calculateTokensReceived(uint256 _ethereumToSpend) 
553         public 
554         view 
555         returns(uint256)
556     {
557         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
558         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
559         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
560         
561         return _amountOfTokens;
562     }
563     
564     /**
565      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
566      */
567     function calculateEthereumReceived(uint256 _tokensToSell) 
568         public 
569         view 
570         returns(uint256)
571     {
572         require(_tokensToSell <= tokenSupply_);
573         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
574         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
575         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
576         return _taxedEthereum;
577     }
578     
579     
580     /*==========================================
581     =            INTERNAL FUNCTIONS            =
582     ==========================================*/
583     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
584         antiEarlyWhale(_incomingEthereum)
585         internal
586         returns(uint256)
587     {
588         // data setup
589         address _customerAddress = msg.sender;
590         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
591         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
592         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
593         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
594         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
595         uint256 _fee = _dividends * magnitude;
596  
597         // no point in continuing execution if OP is a poorfag russian hacker
598         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
599         // (or hackers)
600         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
601         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
602         
603         // is the user referred by a masternode?
604         if(
605             // is this a referred purchase?
606             _referredBy != 0x0000000000000000000000000000000000000000 &&
607 
608             // no cheating!
609             _referredBy != _customerAddress &&
610             
611             // does the referrer have at least X whole tokens?
612             // i.e is the referrer a godly chad masternode
613             tokenBalanceLedger_[_referredBy] >= stakingRequirement
614         ){
615             // wealth redistribution
616             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
617         } else {
618             // no ref purchase
619             // add the referral bonus back to the global dividends cake
620             _dividends = SafeMath.add(_dividends, _referralBonus);
621             _fee = _dividends * magnitude;
622         }
623         
624         // we can't give people infinite ethereum
625         if(tokenSupply_ > 0){
626             
627             // add tokens to the pool
628             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
629  
630             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
631             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
632             
633             // calculate the amount of tokens the customer receives over his purchase 
634             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
635         
636         } else {
637             // add tokens to the pool
638             tokenSupply_ = _amountOfTokens;
639         }
640         
641         // update circulating supply & the ledger address for the customer
642         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
643         
644         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
645         //really i know you think you do but you don't
646         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
647         payoutsTo_[_customerAddress] += _updatedPayouts;
648         
649         // fire event
650         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
651         
652         return _amountOfTokens;
653     }
654 
655     /**
656      * Calculate Token price based on an amount of incoming ethereum
657      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
658      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
659      */
660     function ethereumToTokens_(uint256 _ethereum)
661         internal
662         view
663         returns(uint256)
664     {
665         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
666         uint256 _tokensReceived = 
667          (
668             (
669                 // underflow attempts BTFO
670                 SafeMath.sub(
671                     (sqrt
672                         (
673                             (_tokenPriceInitial**2)
674                             +
675                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
676                             +
677                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
678                             +
679                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
680                         )
681                     ), _tokenPriceInitial
682                 )
683             )/(tokenPriceIncremental_)
684         )-(tokenSupply_)
685         ;
686   
687         return _tokensReceived;
688     }
689     
690     /**
691      * Calculate token sell value.
692      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
693      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
694      */
695      function tokensToEthereum_(uint256 _tokens)
696         internal
697         view
698         returns(uint256)
699     {
700 
701         uint256 tokens_ = (_tokens + 1e18);
702         uint256 _tokenSupply = (tokenSupply_ + 1e18);
703         uint256 _etherReceived =
704         (
705             // underflow attempts BTFO
706             SafeMath.sub(
707                 (
708                     (
709                         (
710                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
711                         )-tokenPriceIncremental_
712                     )*(tokens_ - 1e18)
713                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
714             )
715         /1e18);
716         return _etherReceived;
717     }
718     
719     
720     //This is where all your gas goes, sorry
721     //Not sorry, you probably only paid 1 gwei
722     function sqrt(uint x) internal pure returns (uint y) {
723         uint z = (x + 1) / 2;
724         y = x;
725         while (z < y) {
726             y = z;
727             z = (x / z + z) / 2;
728         }
729     }
730 }
731 
732 /**
733  * @title SafeMath
734  * @dev Math operations with safety checks that throw on error
735  */
736 library SafeMath {
737 
738     /**
739     * @dev Multiplies two numbers, throws on overflow.
740     */
741     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
742         if (a == 0) {
743             return 0;
744         }
745         uint256 c = a * b;
746         assert(c / a == b);
747         return c;
748     }
749 
750     /**
751     * @dev Integer division of two numbers, truncating the quotient.
752     */
753     function div(uint256 a, uint256 b) internal pure returns (uint256) {
754         // assert(b > 0); // Solidity automatically throws when dividing by 0
755         uint256 c = a / b;
756         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
757         return c;
758     }
759 
760     /**
761     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
762     */
763     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
764         assert(b <= a);
765         return a - b;
766     }
767 
768     /**
769     * @dev Adds two numbers, throws on overflow.
770     */
771     function add(uint256 a, uint256 b) internal pure returns (uint256) {
772         uint256 c = a + b;
773         assert(c >= a);
774         return c;
775     }
776 }