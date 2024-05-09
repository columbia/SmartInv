1 pragma solidity ^0.4.25;
2 
3 /*
4 *
5 *  https://fairdapp.com/exchange/  https://fairdapp.com/exchange/   https://fairdapp.com/exchange/
6 *
7 *                _______     _       ______  _______ ______ ______  
8 *               (_______)   (_)     (______)(_______|_____ (_____ \ 
9 *                _____ _____ _  ____ _     _ _______ _____) )____) )
10 *               |  ___|____ | |/ ___) |   | |  ___  |  ____/  ____/ 
11 *               | |   / ___ | | |   | |__/ /| |   | | |    | |      
12 *               |_|   \_____|_|_|   |_____/ |_|   |_|_|    |_|      
13 *                                                                   
14 *                _______            _                               
15 *               (_______)          | |                              
16 *                _____   _   _ ____| |__  _____ ____   ____ _____   
17 *               |  ___) ( \ / ) ___)  _ \(____ |  _ \ / _  | ___ |  
18 *               | |_____ ) X ( (___| | | / ___ | | | ( (_| | ____|  
19 *               |_______|_/ \_)____)_| |_\_____|_| |_|\___ |_____)  
20 *                                                    (_____| 
21 *  Warning:
22 *     
23 *  This contract is intended to link DAPPs on the FairDAPP platform. 
24 *  All could be lost by sending anything to this contract address. 
25 *  All users are prohibited to interact with this contract if this 
26 *  contract is in conflict with user’s local regulations or laws.
27 *  
28 *  Original code by TEAM JUST
29 *  Original concept by Dr. Jochen Hoenicke
30 *  Modified by the FairDAPP community with more scalable and fairer settings. 
31 * 
32 */
33 
34 contract FairExchange {
35     
36     using NameFilter for string;
37     /*=================================
38     =            MODIFIERS            =
39     =================================*/
40     // only people with tokens
41     modifier onlyBagholders() {
42         require(myTokens() > 0);
43         _;
44     }
45     
46     // only people with profits
47     modifier onlyStronghands() {
48         require(myDividends(true) > 0);
49         _;
50     }
51     
52     // administrators can:
53     // -> change the name of the contract
54     // -> change the name of the token
55     // -> Allow contracts to use transfer functions
56     // they CANNOT:
57     // -> take funds
58     // -> disable withdrawals
59     // -> kill the contract
60     // -> change the price of tokens
61     modifier onlyAdministrator(){
62         address _customerAddress = msg.sender;
63         require(administrators[keccak256(abi.encodePacked(_customerAddress))]);
64         _;
65     }
66     
67     modifier buyVerify(uint256 _amountOfEthereum){
68         
69         if((totalEthereumBalance() - _amountOfEthereum) < whaleBalanceLimit)
70             require(tx.gasprice <= gaspriceMax);
71         
72         address _customerAddress = msg.sender;
73         if(onlyAmbassadors && now <= startTime)
74             require(ambassadors_[_customerAddress]);
75         else{
76             
77             if(onlyAmbassadors)
78                 onlyAmbassadors = false;
79                 
80             if((totalEthereumBalance() - _amountOfEthereum) < whaleBalanceLimit)
81                 require(_amountOfEthereum <= maxEarlyStake);
82         }
83         _;
84     }
85     
86     
87     /*==============================
88     =            EVENTS            =
89     ==============================*/
90     event onTokenPurchase(
91         address indexed customerAddress,
92         uint256 incomingEthereum,
93         uint256 tokensMinted,
94         address indexed referredBy
95     );
96     
97     event onTokenSell(
98         address indexed customerAddress,
99         uint256 tokensBurned,
100         uint256 ethereumEarned
101     );
102     
103     event onReinvestment(
104         address indexed customerAddress,
105         uint256 ethereumReinvested,
106         uint256 tokensMinted
107     );
108     
109     event onWithdraw(
110         address indexed customerAddress,
111         uint256 ethereumWithdrawn
112     );
113     
114     // ERC223
115     event Transfer(
116         address indexed from,
117         address indexed to,
118         uint256 tokens,
119         bytes data
120     );
121     
122     
123     /*=====================================
124     =            CONFIGURABLES            =
125     =====================================*/
126     string public name = "FairExchange";
127     string public symbol = "Fair";
128     uint8 constant public decimals = 18;
129     uint8 constant internal dividendFee_ = 10;
130     uint256 constant internal tokenPriceInitial_ = 0.0001 ether;
131     uint256 constant internal tokenPriceIncremental_ = 0.000000005 ether;
132     uint256 constant internal magnitude = 2**64;
133     
134     uint256 public gaspriceMax = 20000000000;
135     uint256 public startTime = 1539478800;
136     
137     /// @dev anti-early-whale
138     uint256 public maxEarlyStake = 2.5 ether;
139     uint256 public whaleBalanceLimit = 250 ether;
140 
141 
142     // private offering program
143     mapping(address => bool) internal ambassadors_;
144     
145     
146    /*================================
147     =            DATASETS            =
148     ================================*/
149     // amount of shares for each address (scaled number)
150     mapping(address => uint256) internal tokenBalanceLedger_;
151     mapping(address => uint256) internal referralBalance_;
152     mapping(address => int256) internal payoutsTo_;
153     
154     uint256 internal tokenSupply_ = 0;
155     uint256 internal profitPerShare_;
156     
157     // administrator list (see above on what they can do)
158     mapping(bytes32 => bool) public administrators;
159     
160     // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
161     bool public onlyAmbassadors = true;
162     
163     mapping (address => bytes32) public register;
164     mapping (bytes32 => address) public userName;
165     mapping (address => bool) public user;
166     
167 
168 
169     /*=======================================
170     =            PUBLIC FUNCTIONS            =
171     =======================================*/
172     /*
173     * -- APPLICATION ENTRY POINTS --  
174     */
175     constructor()
176         public
177     {
178         // add administrators here
179         administrators[0x851d084c805eabf5ec90588a0f5cade287038d80d52c510eefe81f320e97cdcc] = true;
180         
181         // add the ambassadors here.
182 		// max 113 ETH, 40% to developer, 60% to limited quota private sales
183         ambassadors_[0xbC817A495f0114755Da5305c5AA84fc5ca7ebaBd] = true;
184 
185     }
186     
187     function registered(string _userName)
188         public
189     {
190         address _customerAddress = msg.sender;
191         bytes32 _name = _userName.nameFilter();
192         
193         require (_customerAddress == tx.origin, "sender does not meet the rules");
194         require(_name != bytes32(0), "name cannot be empty");
195         require(userName[_name] == address(0), "this name has already been registered");
196         require(register[_customerAddress] == bytes32(0), "please do not repeat registration");
197         
198         userName[_name] = _customerAddress;
199         register[_customerAddress] = _name;
200         
201         if(!user[_customerAddress])
202             user[_customerAddress] = true;
203     }
204      
205     /**
206      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
207      */
208     function buy(address _referredBy)
209         buyVerify(msg.value)
210         public
211         payable
212         returns(uint256)
213     {
214         purchaseTokens(msg.value, _referredBy);
215     }
216     
217     /**
218      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
219      */
220     function buyXname(string _referredName)
221         buyVerify(msg.value)
222         public
223         payable
224         returns(uint256)
225     {
226         purchaseTokens(msg.value, userName[_referredName.nameFilter()]);
227     }
228     
229     /**
230      * Fallback function to handle ethereum that was send straight to the contract
231      * Unfortunately we cannot use a referral address this way.
232      */
233     function()
234         buyVerify(msg.value)
235         payable
236         public
237     {
238         purchaseTokens(msg.value, 0x0);
239     }
240     
241     /**
242      * Converts all of caller's dividends to tokens.
243      */
244     function reinvest()
245         onlyStronghands()
246         public
247     {
248         // fetch dividends
249         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
250         
251         // pay out the dividends virtually
252         address _customerAddress = msg.sender;
253         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
254         
255         // retrieve ref. bonus
256         _dividends += referralBalance_[_customerAddress];
257         referralBalance_[_customerAddress] = 0;
258         
259         // dispatch a buy order with the virtualized "withdrawn dividends"
260         uint256 _tokens = purchaseTokens(_dividends, 0x0);
261         
262         // fire event
263         emit onReinvestment(_customerAddress, _dividends, _tokens);
264     }
265     
266     /**
267      * Alias of sell() and withdraw().
268      */
269     function exit()
270         public
271     {
272         // get token count for caller & sell them all
273         address _customerAddress = msg.sender;
274         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
275         if(_tokens > 0) sell(_tokens);
276         
277         // lambo delivery service
278         withdraw();
279     }
280 
281     /**
282      * Withdraws all of the callers earnings.
283      */
284     function withdraw()
285         onlyStronghands()
286         public
287     {
288         // setup data
289         address _customerAddress = msg.sender;
290         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
291         
292         // update dividend tracker
293         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
294         
295         // add ref. bonus
296         _dividends += referralBalance_[_customerAddress];
297         referralBalance_[_customerAddress] = 0;
298         
299         // lambo delivery service
300         _customerAddress.transfer(_dividends);
301         
302         // fire event
303         emit onWithdraw(_customerAddress, _dividends);
304     }
305     
306     /**
307      * Liquifies tokens to ethereum.
308      */
309     function sell(uint256 _amountOfTokens)
310         onlyBagholders()
311         public
312     {
313         // setup data
314         address _customerAddress = msg.sender;
315         // russian hackers BTFO
316         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
317         uint256 _tokens = _amountOfTokens;
318         uint256 _ethereum = tokensToEthereum_(_tokens);
319         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
320         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
321         
322         // burn the sold tokens
323         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
324         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
325         
326         // update dividends tracker
327         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
328         payoutsTo_[_customerAddress] -= _updatedPayouts;       
329         
330         // dividing by zero is a bad idea
331         if (tokenSupply_ > 0) {
332             // update the amount of dividends per token
333             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
334         }
335         
336         // fire event
337         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum);
338     }
339     
340     
341     /**
342      * ERC20 Transfer
343      * Contract address is blocked from using the transfer function
344      * Contact us to approve contracts for transfer
345      * Contracts will not be a registered user by default
346      * All contracts will be approved unless the contract is malicious
347      */
348     function transfer(address _toAddress, uint256 _amountOfTokens)
349         onlyBagholders()
350         public
351         returns(bool)
352     {
353         // setup
354         address _customerAddress = msg.sender;
355         
356         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
357         require(user[_customerAddress] && user[_toAddress]);
358         
359         // withdraw all outstanding dividends first
360         if(myDividends(true) > 0) withdraw();
361 
362         // exchange tokens
363         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
364         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
365         
366         // update dividend trackers
367         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
368         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
369         
370         bytes memory _empty;
371         uint256 codeLength;
372         assembly {
373             codeLength := extcodesize(_toAddress)
374         }
375         if(codeLength > 0){
376             ERC223ReceivingContract receiver = ERC223ReceivingContract(_toAddress);
377             receiver.tokenFallback(_customerAddress, _amountOfTokens, _empty);
378         }
379         
380         // fire event
381         emit Transfer(_customerAddress, _toAddress, _amountOfTokens, _empty);
382         
383         // ERC20
384         return true;
385     }
386     
387     /**
388      * ERC223 Transfer
389      * Contract address is blocked from using the transfer function
390      * Contact us to approve contracts for transfer 
391      * Contracts will not be a registered user by default
392      * All contracts will be approved unless the contract is malicious
393      */
394     function transfer(address _toAddress, uint256 _amountOfTokens, bytes _data)
395         onlyBagholders()
396         public
397         returns(bool)
398     {
399         // setup
400         address _customerAddress = msg.sender;
401         
402         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
403         require(user[_customerAddress] && user[_toAddress]);
404         
405         // withdraw all outstanding dividends first
406         if(myDividends(true) > 0) withdraw();
407         
408         // exchange tokens
409         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
410         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
411         
412         // update dividend trackers
413         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
414         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
415         
416         uint256 codeLength;
417         assembly {
418             codeLength := extcodesize(_toAddress)
419         }
420         if(codeLength > 0){
421             ERC223ReceivingContract receiver = ERC223ReceivingContract(_toAddress);
422             receiver.tokenFallback(_customerAddress, _amountOfTokens, _data);
423         }
424         
425         // fire event
426         emit Transfer(_customerAddress, _toAddress, _amountOfTokens, _data);
427         
428         // ERC223
429         return true;  
430     }
431     
432     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
433     
434     /**
435      * In case one of us dies, we need to replace ourselves.
436      */
437     function setAdministrator(bytes32 _identifier, bool _status)
438         onlyAdministrator()
439         public
440     {
441         administrators[_identifier] = _status;
442     }
443     
444     /**
445      * If we want to rebrand, we can.
446      */
447     function setName(string _name)
448         onlyAdministrator()
449         public
450     {
451         name = _name;
452     }
453     
454     /**
455      * If we want to rebrand, we can.
456      */
457     function setSymbol(string _symbol)
458         onlyAdministrator()
459         public
460     {
461         symbol = _symbol;
462     }
463     
464     /**
465      * Change start time.
466      */
467     function setTimestamp(uint256 _timestamp)
468         onlyAdministrator()
469         public
470     {
471         require(now < 1541001600);
472         startTime = _timestamp;
473     }
474     
475     /**
476      * Manually add a user to contract for transfer.
477      */
478     function setUser(address[] _userAddress)
479         onlyAdministrator()
480         public
481     {
482         uint256 _length = _userAddress.length;
483         require(_length > 0);
484         
485         for(uint256 i = 0; i < _length; i++){
486             
487             if(!user[_userAddress[i]])
488                 user[_userAddress[i]] = true;
489         }
490     }
491 
492     
493     /*----------  HELPERS AND CALCULATORS  ----------*/
494     /**
495      * Method to view the current Ethereum stored in the contract
496      * Example: totalEthereumBalance()
497      */
498     function totalEthereumBalance()
499         public
500         view
501         returns(uint)
502     {
503         return address(this).balance;
504     }
505     
506     /**
507      * Retrieve the total token supply.
508      */
509     function totalSupply()
510         public
511         view
512         returns(uint256)
513     {
514         return tokenSupply_;
515     }
516     
517     /**
518      * Retrieve the tokens owned by the caller.
519      */
520     function myTokens()
521         public
522         view
523         returns(uint256)
524     {
525         address _customerAddress = msg.sender;
526         return balanceOf(_customerAddress);
527     }
528     
529     /**
530      * Retrieve the dividends owned by the caller.
531      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
532      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
533      * But in the internal calculations, we want them separate. 
534      */ 
535     function myDividends(bool _includeReferralBonus) 
536         public 
537         view 
538         returns(uint256)
539     {
540         address _customerAddress = msg.sender;
541         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
542     }
543     
544     /**
545      * Retrieve the token balance of any single address.
546      */
547     function balanceOf(address _customerAddress)
548         view
549         public
550         returns(uint256)
551     {
552         return tokenBalanceLedger_[_customerAddress];
553     }
554     
555     /**
556      * Retrieve the dividend balance of any single address.
557      */
558     function dividendsOf(address _customerAddress)
559         view
560         public
561         returns(uint256)
562     {
563         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
564     }
565     
566     /**
567      * Return the buy price of 1 individual token.
568      */
569     function sellPrice() 
570         public 
571         view 
572         returns(uint256)
573     {
574         // our calculation relies on the token supply, so we need supply. Doh.
575         if(tokenSupply_ == 0){
576             return tokenPriceInitial_ - tokenPriceIncremental_;
577         } else {
578             uint256 _ethereum = tokensToEthereum_(1e18);
579             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
580             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
581             return _taxedEthereum;
582         }
583     }
584     
585     /**
586      * Return the sell price of 1 individual token.
587      */
588     function buyPrice() 
589         public 
590         view 
591         returns(uint256)
592     {
593         // our calculation relies on the token supply, so we need supply. Doh.
594         if(tokenSupply_ == 0){
595             return tokenPriceInitial_ + tokenPriceIncremental_;
596         } else {
597             uint256 _ethereum = tokensToEthereum_(1e18);
598             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
599             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
600             return _taxedEthereum;
601         }
602     }
603     
604     /**
605      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
606      */
607     function calculateTokensReceived(uint256 _ethereumToSpend) 
608         public 
609         view 
610         returns(uint256)
611     {
612         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
613         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
614         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
615         
616         return _amountOfTokens;
617     }
618     
619     /**
620      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
621      */
622     function calculateEthereumReceived(uint256 _tokensToSell) 
623         public 
624         view 
625         returns(uint256)
626     {
627         require(_tokensToSell <= tokenSupply_);
628         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
629         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
630         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
631         return _taxedEthereum;
632     }
633     
634     
635     /*==========================================
636     =            INTERNAL FUNCTIONS            =
637     ==========================================*/
638     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
639         //antiEarlyWhale(_incomingEthereum)
640         internal
641         returns(uint256)
642     {
643         // data setup
644         address _customerAddress = msg.sender;
645         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
646         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
647         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
648         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
649         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
650         uint256 _fee = _dividends * magnitude;
651  
652         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
653         
654         // is the user referred by a masternode?
655         if(
656             _referredBy != 0x0000000000000000000000000000000000000000 &&
657 
658             _referredBy != _customerAddress &&
659         
660             register[_referredBy] != bytes32(0)
661         ){
662             // wealth redistribution
663             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
664         } else {
665             // no ref purchase
666             // add the referral bonus back to the global dividends cake
667             _dividends = SafeMath.add(_dividends, _referralBonus);
668             _fee = _dividends * magnitude;
669         }
670         
671         // we can't give people infinite ethereum
672         if(tokenSupply_ > 0){
673             
674             // add tokens to the pool
675             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
676  
677             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
678             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
679             
680             // calculate the amount of tokens the customer receives over his purchase 
681             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
682         
683         } else {
684             // add tokens to the pool
685             tokenSupply_ = _amountOfTokens;
686         }
687         
688         // update circulating supply & the ledger address for the customer
689         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
690         
691         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
692         //really i know you think you do but you don't
693         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
694         payoutsTo_[_customerAddress] += _updatedPayouts;
695         
696         if(_customerAddress == tx.origin && !user[_customerAddress])
697             user[_customerAddress] = true;
698     
699         // fire event
700         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
701         
702         return _amountOfTokens;
703     }
704 
705     /**
706      * Calculate Token price based on an amount of incoming ethereum
707      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
708      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
709      */
710     function ethereumToTokens_(uint256 _ethereum)
711         public
712         view
713         returns(uint256)
714     {
715         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
716         uint256 _tokensReceived = 
717          (
718             (
719                 // underflow attempts BTFO
720                 SafeMath.sub(
721                     (sqrt
722                         (
723                             (_tokenPriceInitial**2)
724                             +
725                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
726                             +
727                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
728                             +
729                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
730                         )
731                     ), _tokenPriceInitial
732                 )
733             )/(tokenPriceIncremental_)
734         )-(tokenSupply_)
735         ;
736   
737         return _tokensReceived;
738     }
739     
740     /**
741      * Calculate token sell value.
742      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
743      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
744      */
745      function tokensToEthereum_(uint256 _tokens)
746         internal
747         view
748         returns(uint256)
749     {
750 
751         uint256 tokens_ = (_tokens + 1e18);
752         uint256 _tokenSupply = (tokenSupply_ + 1e18);
753         uint256 _etherReceived =
754         (
755             // underflow attempts BTFO
756             SafeMath.sub(
757                 (
758                     (
759                         (
760                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
761                         )-tokenPriceIncremental_
762                     )*(tokens_ - 1e18)
763                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
764             )
765         /1e18);
766         return _etherReceived;
767     }
768     
769     function sqrt(uint x) internal pure returns (uint y) {
770         uint z = (x + 1) / 2;
771         y = x;
772         while (z < y) {
773             y = z;
774             z = (x / z + z) / 2;
775         }
776     }
777 }
778 
779 contract ERC223ReceivingContract {
780   function tokenFallback(address _from, uint256 _amountOfTokens, bytes _data) public returns (bool);
781 }
782 
783 /**
784  * @title SafeMath
785  * @dev Math operations with safety checks that throw on error
786  */
787 library SafeMath {
788 
789     /**
790     * @dev Multiplies two numbers, throws on overflow.
791     */
792     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
793         if (a == 0) {
794             return 0;
795         }
796         uint256 c = a * b;
797         assert(c / a == b);
798         return c;
799     }
800 
801     /**
802     * @dev Integer division of two numbers, truncating the quotient.
803     */
804     function div(uint256 a, uint256 b) internal pure returns (uint256) {
805         // assert(b > 0); // Solidity automatically throws when dividing by 0
806         uint256 c = a / b;
807         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
808         return c;
809     }
810 
811     /**
812     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
813     */
814     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
815         assert(b <= a);
816         return a - b;
817     }
818 
819     /**
820     * @dev Adds two numbers, throws on overflow.
821     */
822     function add(uint256 a, uint256 b) internal pure returns (uint256) {
823         uint256 c = a + b;
824         assert(c >= a);
825         return c;
826     }
827 }
828 
829 library NameFilter {
830     
831     function nameFilter(string _input)
832         internal
833         pure
834         returns(bytes32)
835     {
836         bytes memory _temp = bytes(_input);
837         uint256 _length = _temp.length;
838         
839         //sorry limited to 32 characters
840         require (_length <= 32 && _length > 3, "string must be between 4 and 32 characters");
841         // make sure first two characters are not 0x
842         if (_temp[0] == 0x30)
843         {
844             require(_temp[1] != 0x78, "string cannot start with 0x");
845             require(_temp[1] != 0x58, "string cannot start with 0X");
846         }
847         
848         for (uint256 i = 0; i < _length; i++)
849         {
850             require
851             (
852                 // OR uppercase A-Z
853                 (_temp[i] > 0x40 && _temp[i] < 0x5b) ||
854                 // OR lowercase a-z
855                 (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
856                 // or 0-9
857                 (_temp[i] > 0x2f && _temp[i] < 0x3a),
858                 "string contains invalid characters"
859             );
860         }
861         
862         bytes32 _ret;
863         assembly {
864             _ret := mload(add(_temp, 32))
865         }
866         return (_ret);
867     }
868 }