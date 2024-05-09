1 pragma solidity ^0.4.24;
2 
3 // File: contracts/library/SafeMath.sol
4 
5 /**
6  * @title SafeMath v0.1.9
7  * @dev Math operations with safety checks that throw on error
8  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
9  * - added sqrt
10  * - added sq
11  * - added pwr 
12  * - changed asserts to requires with error log outputs
13  * - removed div, its useless
14  */
15 library SafeMath {
16     
17     /**
18     * @dev Multiplies two numbers, throws on overflow.
19     */
20     function mul(uint256 a, uint256 b) 
21         internal 
22         pure 
23         returns (uint256 c) 
24     {
25         if (a == 0) {
26             return 0;
27         }
28         c = a * b;
29         require(c / a == b, "SafeMath mul failed");
30         return c;
31     }
32 
33     /**
34     * @dev Integer division of two numbers, truncating the quotient.
35     */
36     function div(uint256 a, uint256 b) internal pure returns (uint256) {
37         // assert(b > 0); // Solidity automatically throws when dividing by 0
38         uint256 c = a / b;
39         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40         return c;
41     }
42     
43     /**
44     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45     */
46     function sub(uint256 a, uint256 b)
47         internal
48         pure
49         returns (uint256) 
50     {
51         require(b <= a, "SafeMath sub failed");
52         return a - b;
53     }
54 
55     /**
56     * @dev Adds two numbers, throws on overflow.
57     */
58     function add(uint256 a, uint256 b)
59         internal
60         pure
61         returns (uint256 c) 
62     {
63         c = a + b;
64         require(c >= a, "SafeMath add failed");
65         return c;
66     }
67     
68     /**
69      * @dev gives square root of given x.
70      */
71     function sqrt(uint256 x)
72         internal
73         pure
74         returns (uint256 y) 
75     {
76         uint256 z = ((add(x,1)) / 2);
77         y = x;
78         while (z < y) 
79         {
80             y = z;
81             z = ((add((x / z),z)) / 2);
82         }
83     }
84     
85     /**
86      * @dev gives square. multiplies x by x
87      */
88     function sq(uint256 x)
89         internal
90         pure
91         returns (uint256)
92     {
93         return (mul(x,x));
94     }
95     
96     /**
97      * @dev x to the power of y 
98      */
99     function pwr(uint256 x, uint256 y)
100         internal 
101         pure 
102         returns (uint256)
103     {
104         if (x==0)
105             return (0);
106         else if (y==0)
107             return (1);
108         else 
109         {
110             uint256 z = x;
111             for (uint256 i=1; i < y; i++)
112                 z = mul(z,x);
113             return (z);
114         }
115     }
116 }
117 
118 // File: contracts/Hourglass.sol
119 
120 /*
121         __                   __       __
122  .-----|  |--.---.-.--------|__.-----|  |--.
123  |  _  |    <|  _  |        |  |  _  |    <
124  |_____|__|__|___._|__|__|__|__|   __|__|__|
125                                |__|
126 */
127 
128 
129 contract Hourglass {
130     /*=================================
131     =            MODIFIERS            =
132     =================================*/
133     // only people with tokens
134     modifier onlyBagholders() {
135         require(myTokens() > 0);
136         _;
137     }
138     
139     // only people with profits
140     modifier onlyStronghands() {
141         require(myDividends(true) > 0);
142         _;
143     }
144     
145     // administrators can:
146     // -> change the name of the contract
147     // -> change the name of the token
148     // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
149     // they CANNOT:
150     // -> take funds
151     // -> disable withdrawals
152     // -> kill the contract
153     // -> change the price of tokens
154     modifier onlyAdministrator(){
155         //bytes32 name =  keccak256(msg.sender);
156         require(administrators[msg.sender], "must in administrators");
157         _;
158     }
159     
160     
161     modifier ceilingNotReached() {
162         require(okamiCurrentPurchase_ < okamiTotalPurchase_);
163         _;
164     }  
165 
166     modifier isActivated() {
167         require(activated == true, "its not ready yet"); 
168         _;
169     }
170 
171     modifier isInICO() {
172         require(inICO == true, "its not in ICO."); 
173         _;
174     }
175 
176     modifier isNotInICO() {
177         require(inICO == false, "its not in ICO."); 
178         _;
179     }
180 
181     /**
182      * @dev prevents contracts from interacting with 
183      */
184     modifier isHuman() {
185         address _addr = msg.sender;
186         require (_addr == tx.origin);
187         
188         uint256 _codeLength;
189         
190         assembly {_codeLength := extcodesize(_addr)}
191         require(_codeLength == 0, "sorry humans only");
192         _;
193     }
194 
195 
196     /*==============================
197     =            EVENTS            =
198     ==============================*/
199     event onTokenPurchase(
200         address indexed customerAddress,
201         uint256 incomingEthereum,
202         uint256 tokensMinted,
203         address indexed referredBy
204     );
205     
206     event onTokenSell(
207         address indexed customerAddress,
208         uint256 tokensBurned,
209         uint256 ethereumEarned
210     );
211     
212     event onReinvestment(
213         address indexed customerAddress,
214         uint256 ethereumReinvested,
215         uint256 tokensMinted
216     );
217     
218     event onWithdraw(
219         address indexed customerAddress,
220         uint256 ethereumWithdrawn
221     );
222     
223     // ERC20
224     event Transfer(
225         address indexed from,
226         address indexed to,
227         uint256 tokens
228     );
229     
230     
231     /*=====================================
232     =            CONFIGURABLES            =
233     =====================================*/
234     string public name = "OkamiPK";
235     string public symbol = "OPK";
236     uint8 constant public decimals = 18;
237     uint8 constant internal dividendFee_ = 10;
238     uint256 constant internal tokenPriceInitial_ =  0.0007 ether; //0.0000001 ether;
239     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
240     uint256 constant internal magnitude = 2**64;
241     uint256 constant public icoPrice_ = 0.002 ether; 
242     // proof of stake (defaults at 100 tokens)
243     uint256 public stakingRequirement = 100e18;
244     
245     // ambassador program
246 
247     //todo
248     uint256 constant public okamiMinPurchase_ = 5 ether;
249     uint256 constant public okamiMaxPurchase_ = 10 ether;
250     uint256 constant public okamiTotalPurchase_ = 500 ether;
251     
252     mapping(address => uint256) internal okamis_;
253     uint256 public okamiCurrentPurchase_ = 0;
254     
255     bool public inICO = false;
256     bool public activated = false;
257     
258    /*================================
259     =            DATASETS            =
260     ================================*/
261     // amount of shares for each address (scaled number)
262     //TODO: public->internal
263     mapping(address => uint256) public tokenBalanceLedger_;
264     mapping(address => uint256) public referralBalance_;
265     mapping(address => int256) public payoutsTo_;
266     uint256 internal tokenSupply_ = 0;
267     uint256 internal profitPerShare_;
268     
269     // administrator list (see above on what they can do)
270     mapping(address => bool) public administrators;
271     
272     // okami 
273     //TODO: public->internal
274     mapping(address => uint256) public okamiFunds_;
275 
276     /*=======================================
277     =            PUBLIC FUNCTIONS            =
278     =======================================*/
279     /*
280     * -- APPLICATION ENTRY POINTS --  
281     */
282     constructor()
283         public
284     {
285         // add administrators here
286         //TODO:
287         //administrators[0x00D8E8CCb4A29625D299798036825f3fa349f2b4] = true;
288         //
289         administrators[0x00A32C09c8962AEc444ABde1991469eD0a9ccAf7] = true;
290         administrators[0x00aBBff93b10Ece374B14abb70c4e588BA1F799F] = true;
291                     
292         //TODO: 
293         uint256 count = SafeMath.mul(SafeMath.div(10**18, icoPrice_), 10**18);
294 
295         tokenBalanceLedger_[0x0a3Ed0E874b4E0f7243937cD0545bFEcBa0f4548] = 50*count;
296         tokenSupply_ = SafeMath.add(tokenSupply_, 50*count);
297 
298         tokenBalanceLedger_[0x00c9d3bd82fEa0464DC284Ca870A76eE7386C63d] = 30*count;
299         tokenSupply_ = SafeMath.add(tokenSupply_, 30*count);
300 
301         tokenBalanceLedger_[0x00De30E1A0E82750ea1f96f6D27e112f5c8A352D] = 10*count;
302         tokenSupply_ = SafeMath.add(tokenSupply_, 10*count);
303 
304         tokenBalanceLedger_[0x0070349db8EF73DeF5A1Aa838B7d81FD0742867b] = 4*count;
305         tokenSupply_ = SafeMath.add(tokenSupply_, 4*count);
306 
307         //
308         tokenBalanceLedger_[0x26042eb2f06D419093313ae2486fb40167Ba349C] = 1*count;
309         tokenSupply_ = SafeMath.add(tokenSupply_, 1*count);
310         tokenBalanceLedger_[0x8d60d529c435e2A4c67FD233c49C3F174AfC72A8] = 1*count;
311         tokenSupply_ = SafeMath.add(tokenSupply_, 1*count);
312         tokenBalanceLedger_[0xF9f24b9a5FcFf3542Ae3361c394AD951a8C0B3e1] = 1*count;
313         tokenSupply_ = SafeMath.add(tokenSupply_, 1*count);
314         tokenBalanceLedger_[0x9ca974f2c49d68bd5958978e81151e6831290f57] = 1*count;
315         tokenSupply_ = SafeMath.add(tokenSupply_, 1*count);
316         tokenBalanceLedger_[0xf22978ed49631b68409a16afa8e123674115011e] = 1*count;
317         tokenSupply_ = SafeMath.add(tokenSupply_, 1*count);
318         tokenBalanceLedger_[0x00b22a1D6CFF93831Cf2842993eFBB2181ad78de] = 1*count;
319         tokenSupply_ = SafeMath.add(tokenSupply_, 1*count);
320 
321     }
322     
323     function activate()
324         onlyAdministrator()
325         public
326     {
327 
328         // can only be ran once
329         require(activated == false, "already activated");
330         
331         // activate the contract 
332         activated = true;
333         
334         inICO = true;
335     }
336 
337     function endICO()
338         onlyAdministrator()
339         public
340     {
341 
342         // can only be ran once
343         require(inICO == true, "must true before");
344         
345         inICO = false;
346         
347     }
348 
349 
350     /**
351      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
352      */
353     function buy(address _referredBy)
354         isActivated()
355         isHuman()
356         public
357         payable
358         returns(uint256)
359     {
360         if( inICO){
361             purchaseTokensInICO(msg.value, _referredBy);
362         }else{
363             purchaseTokens(msg.value, _referredBy);
364         }
365     }
366     
367     /**
368      * Fallback function to handle ethereum that was send straight to the contract
369      * Unfortunately we cannot use a referral address this way.
370      */
371     function()
372         isActivated()
373         isHuman()
374         payable
375         public
376     {
377         if( inICO){
378             purchaseTokensInICO(msg.value, 0x0);
379         }else{
380             purchaseTokens(msg.value, 0x0);
381         }
382     }
383     
384     /**
385      * Converts all of caller's dividends to tokens.
386      */
387     function reinvest()
388         onlyStronghands()
389         public
390     {
391         // fetch dividends
392         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
393         
394         // pay out the dividends virtually
395         address _customerAddress = msg.sender;
396         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
397         
398         // retrieve ref. bonus
399         _dividends += referralBalance_[_customerAddress];
400         referralBalance_[_customerAddress] = 0;
401         
402         // dispatch a buy order with the virtualized "withdrawn dividends"
403         uint256 _tokens = purchaseTokens(_dividends, 0x0);
404         
405         // fire event
406         emit onReinvestment(_customerAddress, _dividends, _tokens);
407     }
408     
409     /**
410      * Alias of sell() and withdraw().
411      */
412     function exit()
413         public
414     {
415         // ` token count for caller & sell them all
416         address _customerAddress = msg.sender;
417         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
418         if(_tokens > 0) sell(_tokens);
419         
420         // lambo delivery service
421         withdraw();
422     }
423 
424     /**
425      * Withdraws all of the callers earnings.
426      */
427     function withdraw()
428         onlyStronghands()
429         public
430     {
431         // setup data
432         address _customerAddress = msg.sender;
433         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
434         
435         // update dividend tracker
436         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
437         
438         // add ref. bonus
439         _dividends += referralBalance_[_customerAddress];
440         referralBalance_[_customerAddress] = 0;
441         
442         // lambo delivery service
443         _customerAddress.transfer(_dividends);
444         
445         // fire event
446         emit onWithdraw(_customerAddress, _dividends);
447     }
448     
449     /**
450      * Liquifies tokens to ethereum.
451      */
452     function sell(uint256 _amountOfTokens)
453         isNotInICO()
454         onlyBagholders()
455         public
456     {
457         // setup data
458         address _customerAddress = msg.sender;
459         // russian hackers BTFO
460         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
461         uint256 _tokens = _amountOfTokens;
462         uint256 _ethereum = tokensToEthereum_(_tokens);
463         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
464         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
465         
466         // burn the sold tokens
467         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
468         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
469         
470         // update dividends tracker
471         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
472         payoutsTo_[_customerAddress] -= _updatedPayouts;       
473         
474         // dividing by zero is a bad idea
475         if (tokenSupply_ > 0) {
476             // update the amount of dividends per token
477             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
478         }
479         
480         // fire event
481         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
482     }
483     
484     
485     /**
486      * Transfer tokens from the caller to a new holder.
487      * Remember, there's a 10% fee here as well.
488      */
489     function transfer(address _toAddress, uint256 _amountOfTokens)
490         isNotInICO()
491         onlyBagholders()
492         public
493         returns(bool)
494     {
495         // setup
496         address _customerAddress = msg.sender;
497         
498         // make sure we have the requested tokens
499         // also disables transfers until ico phase is over
500         // ( we dont want whale premines )
501         require(!inICO && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
502         
503         // withdraw all outstanding dividends first
504         if(myDividends(true) > 0) withdraw();
505         
506         // liquify 10% of the tokens that are transfered
507         // these are dispersed to shareholders
508         uint256 _tokenFee = SafeMath.div(_amountOfTokens, dividendFee_);
509         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
510         uint256 _dividends = tokensToEthereum_(_tokenFee);
511   
512         // burn the fee tokens
513         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokenFee);
514 
515         // exchange tokens
516         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
517         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
518         
519         // update dividend trackers
520         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
521         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _taxedTokens);
522         
523         // disperse dividends among holders
524         profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
525         
526         // fire event
527         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
528         
529         // ERC20
530         return true;
531        
532     }
533     
534 
535     /**
536      * In case one of us dies, we need to replace ourselves.
537      */
538     function setAdministrator(address _identifier, bool _status)
539         onlyAdministrator()
540         public
541     {
542         administrators[_identifier] = _status;
543     }
544     
545     /**
546      * Precautionary measures in case we need to adjust the masternode rate.
547      */
548     function setStakingRequirement(uint256 _amountOfTokens)
549         onlyAdministrator()
550         public
551     {
552         stakingRequirement = _amountOfTokens;
553     }
554     
555     /**
556      * If we want to rebrand, we can.
557      */
558     function setName(string _name)
559         onlyAdministrator()
560         public
561     {
562         name = _name;
563     }
564     
565     /**
566      * If we want to rebrand, we can.
567      */
568     function setSymbol(string _symbol)
569         onlyAdministrator()
570         public
571     {
572         symbol = _symbol;
573     }
574 
575     
576     /*----------  HELPERS AND CALCULATORS  ----------*/
577     /**
578      * Method to view the current Ethereum stored in the contract
579      * Example: totalEthereumBalance()
580      */
581     function totalEthereumBalance()
582         public
583         view
584         returns(uint)
585     {
586         return address(this).balance;
587     }
588     
589     /**
590      * Retrieve the total token supply.
591      */
592     function totalSupply()
593         public
594         view
595         returns(uint256)
596     {
597         return tokenSupply_;
598     }
599     
600     /**
601      * Retrieve the tokens owned by the caller.
602      */
603     function myTokens()
604         public
605         view
606         returns(uint256)
607     {
608         address _customerAddress = msg.sender;
609         return balanceOf(_customerAddress);
610     }
611     
612     /**
613      * Retrieve the dividends owned by the caller.
614      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
615      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
616      * But in the internal calculations, we want them separate. 
617      */ 
618     function myDividends(bool _includeReferralBonus) 
619         public 
620         view 
621         returns(uint256)
622     {
623         address _customerAddress = msg.sender;
624         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
625     }
626     
627     /**
628      * Retrieve the token balance of any single address.
629      */
630     function balanceOf(address _customerAddress)
631         view
632         public
633         returns(uint256)
634     {
635         return tokenBalanceLedger_[_customerAddress];
636     }
637     
638     /**
639      * Retrieve the dividend balance of any single address.
640      */
641     function dividendsOf(address _customerAddress)
642         view
643         public
644         returns(uint256)
645     {
646         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
647     }
648     
649     /**
650      * Return the buy price of 1 individual token.
651      */
652     function sellPrice() 
653         public 
654         view 
655         returns(uint256)
656     {
657         // our calculation relies on the token supply, so we need supply. Doh.
658         if(tokenSupply_ == 0){
659             return tokenPriceInitial_ - tokenPriceIncremental_;
660         } else {
661             uint256 _ethereum = tokensToEthereum_(1e18);
662             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
663             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
664             return _taxedEthereum;
665         }
666     }
667     
668     /**
669      * Return the sell price of 1 individual token.
670      */
671     function buyPrice() 
672         public 
673         view 
674         returns(uint256)
675     {
676         // our calculation relies on the token supply, so we need supply. Doh.
677         if(tokenSupply_ == 0){
678             return tokenPriceInitial_ + tokenPriceIncremental_;
679         } else {
680             uint256 _ethereum = tokensToEthereum_(1e18);
681             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
682             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
683             return _taxedEthereum;
684         }
685     }
686     
687     /**
688      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
689      */
690     function calculateTokensReceived(uint256 _ethereumToSpend) 
691         public 
692         view 
693         returns(uint256)
694     {
695         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
696         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
697         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
698         
699         return _amountOfTokens;
700     }
701     
702     /**
703      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
704      */
705     function calculateEthereumReceived(uint256 _tokensToSell) 
706         public 
707         view 
708         returns(uint256)
709     {
710         require(_tokensToSell <= tokenSupply_);
711         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
712         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
713         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
714         return _taxedEthereum;
715     }
716     
717     
718     function purchaseTokensInICO(uint256 _incomingEthereum, address _referredBy)
719         isInICO()
720         ceilingNotReached()
721         internal
722         returns(uint256)
723     {   
724         address _customerAddress = msg.sender;
725         uint256 _oldFundETH = okamiFunds_[_customerAddress];
726 
727         require(_incomingEthereum > 0, "no money");
728         require( (_oldFundETH >= okamiMinPurchase_) || _incomingEthereum >= okamiMinPurchase_, "min 5 eth");
729         require(SafeMath.add(_oldFundETH, _incomingEthereum) <= okamiMaxPurchase_, "max 10 eth");
730 
731         uint256 _newFundETH = _incomingEthereum;
732         if( SafeMath.add(_newFundETH, okamiCurrentPurchase_) > okamiTotalPurchase_){
733             _newFundETH = SafeMath.sub(okamiTotalPurchase_, okamiCurrentPurchase_);
734             msg.sender.transfer(SafeMath.sub(_incomingEthereum, _newFundETH));
735         }
736 
737         uint256 _amountOfTokens =  SafeMath.mul(SafeMath.div(_newFundETH, icoPrice_), 10**18);
738 
739         // add tokens to the pool
740         tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
741  
742         // update circulating supply & the ledger address for the customer
743         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
744         okamiFunds_[_customerAddress]  = SafeMath.add(okamiFunds_[_customerAddress], _newFundETH);
745         okamiCurrentPurchase_ = SafeMath.add(okamiCurrentPurchase_, _newFundETH);
746 
747         if( okamiCurrentPurchase_ >= okamiTotalPurchase_){
748             inICO = false;
749         }
750 
751         // fire event
752         emit onTokenPurchase(_customerAddress, _newFundETH, _amountOfTokens, _referredBy);
753         
754     }
755 
756 
757     /*==========================================
758     =            INTERNAL FUNCTIONS            =
759     ==========================================*/
760     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
761         isNotInICO()
762         internal
763         returns(uint256)
764     {
765         // data setup
766         address _customerAddress = msg.sender;
767         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
768         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
769         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
770         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
771         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
772         uint256 _fee = _dividends * magnitude;
773  
774         // no point in continuing execution if OP is a poorfag russian hacker
775         // prevents overflow in the case that the pyramid somehow magically starts being used by everyone in the world
776         // (or hackers)
777         // and yes we know that the safemath function automatically rules out the "greater then" equasion.
778         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
779         
780         // is the user referred by a masternode?
781         if(
782             // is this a referred purchase?
783             _referredBy != 0x0000000000000000000000000000000000000000 &&
784 
785             // no cheating!
786             _referredBy != _customerAddress &&
787             
788             // does the referrer have at least X whole tokens?
789             // i.e is the referrer a godly chad masternode
790             tokenBalanceLedger_[_referredBy] >= stakingRequirement
791         ){
792             // wealth redistribution
793             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
794         } else {
795             // no ref purchase
796             // add the referral bonus back to the global dividends cake
797             _dividends = SafeMath.add(_dividends, _referralBonus);
798             _fee = _dividends * magnitude;
799         }
800         
801         // we can't give people infinite ethereum
802         if(tokenSupply_ > 0){
803             
804             // add tokens to the pool
805             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
806  
807             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
808             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
809             
810             // calculate the amount of tokens the customer receives over his purchase 
811             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
812         
813         } else {
814             // add tokens to the pool
815             tokenSupply_ = _amountOfTokens;
816         }
817         
818         // update circulating supply & the ledger address for the customer
819         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
820         
821         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
822         //really i know you think you do but you don't
823         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
824         payoutsTo_[_customerAddress] += _updatedPayouts;
825         
826         // fire event
827         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
828         
829         return _amountOfTokens;
830     }
831 
832     /**
833      * Calculate Token price based on an amount of incoming ethereum
834      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
835      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
836      */
837     function ethereumToTokens_(uint256 _ethereum)
838         internal
839         view
840         returns(uint256)
841     {
842         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
843         uint256 _tokensReceived = 
844          (
845             (
846                 // underflow attempts BTFO
847                 SafeMath.sub(
848                     (sqrt
849                         (
850                             (_tokenPriceInitial**2)
851                             +
852                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
853                             +
854                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
855                             +
856                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
857                         )
858                     ), _tokenPriceInitial
859                 )
860             )/(tokenPriceIncremental_)
861         )-(tokenSupply_)
862         ;
863   
864         return _tokensReceived;
865     }
866     
867     /**
868      * Calculate token sell value.
869      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
870      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
871      */
872      function tokensToEthereum_(uint256 _tokens)
873         internal
874         view
875         returns(uint256)
876     {
877 
878         uint256 tokens_ = (_tokens + 1e18);
879         uint256 _tokenSupply = (tokenSupply_ + 1e18);
880         uint256 _etherReceived =
881         (
882             // underflow attempts BTFO
883             SafeMath.sub(
884                 (
885                     (
886                         (
887                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
888                         )-tokenPriceIncremental_
889                     )*(tokens_ - 1e18)
890                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
891             )
892         /1e18);
893         return _etherReceived;
894     }
895     
896     
897     //This is where all your gas goes, sorry
898     //Not sorry, you probably only paid 1 gwei
899     function sqrt(uint x) internal pure returns (uint y) {
900         uint z = (x + 1) / 2;
901         y = x;
902         while (z < y) {
903             y = z;
904             z = (x / z + z) / 2;
905         }
906     }
907 }