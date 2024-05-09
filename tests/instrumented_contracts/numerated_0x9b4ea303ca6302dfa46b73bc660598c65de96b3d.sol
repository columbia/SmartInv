1 /**
2  * www.the8020.ch
3 */
4 
5 pragma solidity ^0.6.0;
6 
7    /*==================================================================================
8     =  The 80/20 is a Wealth Distribution system that is open for anyone to use.      =  
9     =  We created this application with hopes that it will provide a steady stream    =
10     =  of passive income for generations to come. The foundation that stands behind   =
11     =  this product would like you to live happy, free, and prosperous.               =
12     =  Stay tuned for more dApps from the GSG Global Marketing Group.                 =
13     =  #LuckyRico #LACGold #JCunn24 #BoHarvey #LennyBones #WealthWithPhelps 	      =
14     =  #ShahzainTariq >= developer of this smart contract		 				      =
15     ================================================================================*/
16 
17 interface IERC20 {
18     
19     function totalSupply() external view returns (uint256);
20 
21     function balanceOf(address account) external view returns (uint256);
22 
23     function transfer(address recipient, uint256 amount) external returns (bool);
24 
25     function allowance(address owner, address spender) external view returns (uint256);
26     
27     function approve(address spender, uint256 amount) external returns (bool);
28 
29     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 
33     event Approval(address indexed owner, address indexed spender, uint256 value);
34 }
35 
36 
37 contract auto_pool is IERC20{
38     
39     using SafeMath for uint256;
40     
41     /*=================================
42     =            MODIFIERS            =
43     =================================*/
44     // only people with tokens
45     modifier onlybelievers () {
46         require(myTokens() > 0);
47         _;
48     }
49     
50     // only people with profits
51     modifier onlyhodler() {
52         require(myDividends(true) > 0);
53         _;
54     }
55     
56  
57     
58     /*==============================
59     =            EVENTS            =
60     ==============================*/
61     event onTokenPurchase(
62         address indexed customerAddress,
63         uint256 incomingEthereum,
64         uint256 tokensMinted,
65         address indexed referredBy,
66         uint256 time,
67         uint256 totalTokens
68     );
69     
70     event onTokenSell(
71         address indexed customerAddress,
72         uint256 tokensBurned,
73         uint256 ethereumEarned,
74         uint256 time,
75         uint256 totalTokens
76     );
77     
78     event onReinvestment(
79         address indexed customerAddress,
80         uint256 ethereumReinvested,
81         uint256 tokensMinted
82     );
83     
84     event onWithdraw(
85         address indexed customerAddress,
86         uint256 ethereumWithdrawn
87     );
88     
89     event distrubuteBonusFund(
90         address,
91         uint256
92         );
93         
94     event amountDistributedToSponsor(
95         address,
96         address,
97         uint256
98         );
99     
100     // ERC20
101     event Transfer(
102         address indexed from,
103         address indexed to,
104         uint256 tokens,
105         uint256 time
106     );
107     
108     
109     /*=====================================
110     =            CONFIGURABLES            =
111     =====================================*/
112     string public name ;
113     string public symbol ;
114     uint8 public decimals ;
115     uint8 internal dividendFee_ ;
116     uint256 internal tokenPriceInitial_ ;
117     uint256 internal tokenPriceIncremental_ ;
118     uint256 internal magnitude;
119 
120     uint256 public tokenPool;
121     uint256 public loyaltyPool;
122     uint256 public developmentFund;
123     uint256 public sponsorsPaid;
124     uint256 public gsg_foundation;
125     address dev1;
126     address dev2;
127     address GSGO_Official_LoyaltyPlan;
128     uint256 public currentId;
129     uint256 public day;
130     uint256 public claimedLoyalty;
131     uint256 public totalDeposited;    
132     uint256 public totalWithdraw;
133   
134   
135     
136     
137    /*================================
138     =            DATASETS            =
139     ================================*/
140     // amount of shares for each address (scaled number)
141     mapping(address => uint256) public tokenBalanceLedger_;
142     mapping(address => uint256) public  referralBalance_;
143     mapping (address => mapping (address => uint256)) private _allowances;
144     mapping(address => int256) public payoutsTo_;
145     mapping(address => basicData) public users;
146     mapping(uint256 => address) public userList;
147     uint256 internal tokenSupply_ = 0;
148     uint256 internal profitPerShare_;
149     uint256 internal profitperLoyalty;
150     
151     //Users's data set
152     struct basicData{
153         bool isExist;
154         uint256 id;
155         uint256 referrerId;
156         address referrerAdd;
157     }
158 
159     /*=======================================
160     =            PUBLIC FUNCTIONS            =
161     =======================================*/
162     /*
163     * -- APPLICATION ENTRY POINTS --  
164     */
165     constructor() public{
166         name = "The-Eighty-Twenty";
167         symbol = "GS20";
168         decimals = 18;
169         dividendFee_ = 10;
170         tokenPriceInitial_ = 0.0000001 ether;
171         tokenPriceIncremental_ = 0.00000001 ether;
172         magnitude = 2**64;
173         // "This is the distribution contract for holders of the GSG-Official (GSGO) Token."
174         GSGO_Official_LoyaltyPlan = address(0x727395b95C90DEab2F220Ce42615d9dD0F44e187);
175         dev1 = address(0x88F2E544359525833f606FB6c63826E143132E7b);
176         dev2 = address(0x7cF196415CDD1eF08ca2358a8282D33Ba089B9f3);
177         currentId = 0;
178         day = now;
179     
180     }
181     
182      
183     /**
184      * Converts all incoming Ethereum to tokens for the caller, and passes down the referral address (if any)
185      */
186     function buy(address _referredAdd)
187         public  
188         payable
189         returns(uint256)
190     {
191         require(msg.value >= 0.1 ether, "ERROR: minimun 0.1 ethereum ");
192         require(_referredAdd != msg.sender,"ERROR: cannot become own ref");
193         
194         if(!users[msg.sender].isExist) register(msg.sender,_referredAdd);
195         
196         purchaseTokens(msg.value,_referredAdd);
197          
198         //Distributing Ethers
199         loyaltyPool += ((msg.value.mul(12)).div(100));
200         developmentFund += ((msg.value.mul(2)).div(100));
201         gsg_foundation += ((msg.value.mul(2)).div(100));
202         payable(GSGO_Official_LoyaltyPlan).transfer((msg.value.mul(2)).div(100));
203         payable(dev1).transfer((msg.value.mul(1)).div(100));
204         payable(dev2).transfer((msg.value.mul(1)).div(100));
205         totalDeposited += msg.value;
206 
207     }
208     
209     receive() external payable {
210          require(msg.value >= 0.1 ether, "ERROR: minimun 0.1 ethereum .");
211 
212      if(!users[msg.sender].isExist) register(msg.sender,address(0));
213 
214         purchaseTokens(msg.value,address(0));
215          
216         //Distributing Ethers
217         loyaltyPool += ((msg.value.mul(12)).div(100));
218         developmentFund += ( (msg.value.mul(2)).div(100));
219         gsg_foundation += ((msg.value.mul(2)).div(100));
220         payable(GSGO_Official_LoyaltyPlan).transfer((msg.value.mul(2)).div(100));
221         payable(dev1).transfer((msg.value.mul(1)).div(100));
222         payable(dev2).transfer((msg.value.mul(1)).div(100)); 
223     }
224     
225     fallback()
226         payable
227         external
228     {
229     require(msg.value >= 0.1 ether, "ERROR: minimun 0.1 ethereum .");
230 
231      if(!users[msg.sender].isExist) register(msg.sender,address(0));
232 
233         purchaseTokens(msg.value,address(0));
234          
235         //Distributing Ethers
236         loyaltyPool += ((msg.value.mul(12)).div(100));
237         developmentFund += ( (msg.value.mul(2)).div(100));
238         gsg_foundation += ((msg.value.mul(2)).div(100));
239         payable(GSGO_Official_LoyaltyPlan).transfer((msg.value.mul(2)).div(100));
240         payable(dev1).transfer((msg.value.mul(1)).div(100));
241         payable(dev2).transfer((msg.value.mul(1)).div(100));    }
242     
243     /**
244      * Converts all of caller's dividends to tokens.
245      */
246     function reinvest()
247         onlyhodler()
248         public
249     {
250         address _customerAddress = msg.sender;
251         // fetch dividends
252         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
253         
254         uint256 _loyaltyEth = loyaltyOf();
255         if(_loyaltyEth > 0 ether){
256             payable(address(_customerAddress)).transfer(_loyaltyEth);
257                 loyaltyPool -= _loyaltyEth;
258                 claimedLoyalty += _loyaltyEth;
259                 totalWithdraw += _loyaltyEth;
260         }       
261         
262         // pay out the dividends virtually
263         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
264 
265         
266         // retrieve ref. bonus
267         _dividends += referralBalance_[_customerAddress];
268         referralBalance_[_customerAddress] = 0;
269 
270         // dispatch a buy order with the virtualized "withdrawn dividends"
271         address refAdd = users[_customerAddress].referrerAdd;
272         // dispatch a buy order with the virtualized "withdrawn dividends"
273         uint256 _tokens = purchaseTokens(_dividends,refAdd);
274         loyaltyPool += ((_dividends.mul(12)).div(100));
275         developmentFund += ((_dividends.mul(2)).div(100));
276         gsg_foundation += ((_dividends.mul(2)).div(100));
277         payable(GSGO_Official_LoyaltyPlan).transfer((_dividends.mul(2)).div(100));
278         payable(dev1).transfer((_dividends.mul(1)).div(100));
279         payable(dev2).transfer((_dividends.mul(1)).div(100));
280         // fire event
281         emit onReinvestment(_customerAddress, _dividends, _tokens);
282     }
283     
284     /**
285      * Alias of sell() and withdraw().
286      */
287     function exit()
288         public
289     {
290         // get token count for caller & sell them all
291         address _customerAddress = msg.sender;
292         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
293         if(_tokens > 0) sell(_tokens);
294         
295         
296         withdraw();
297     }
298 
299     /**
300      * Withdraws all of the callers earnings.
301      */
302     function withdraw()
303         onlyhodler()
304         public
305     {
306         // setup data
307         address _customerAddress = msg.sender;
308         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
309         uint256 _loyaltyEth = loyaltyOf();
310 
311         // update dividend tracker
312         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
313         
314         if(_loyaltyEth > 0 ether) {
315             _dividends += _loyaltyEth;
316             loyaltyPool -= _loyaltyEth;
317             claimedLoyalty += _loyaltyEth;
318         }       
319         // add ref. bonus
320         _dividends += referralBalance_[_customerAddress];
321         referralBalance_[_customerAddress] = 0;
322         
323         totalWithdraw += _dividends;
324 
325         // delivery service
326         payable(address(_customerAddress)).transfer(_dividends);
327         
328         // fire event
329         emit onWithdraw(_customerAddress, _dividends);
330     }
331     
332     /**
333      * Liquifies tokens to ethereum.
334      */
335     function sell(uint256 _amountOfTokens)
336         onlybelievers ()
337         public
338     {
339       
340         address _customerAddress = msg.sender;
341        
342         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
343         //initializating values; 
344         uint256 _tokens = _amountOfTokens;
345         uint256 _ethereum = tokensToEthereum_(_tokens);
346         uint256 tax = (_ethereum.mul(5)).div(100);
347         loyaltyPool = SafeMath.add(loyaltyPool,tax);
348         uint256 _taxedEthereum = SafeMath.sub(_ethereum, tax);
349     
350         // burn the sold tokens
351         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
352         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
353         
354        //updates dividends tracker
355         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
356         payoutsTo_[_customerAddress] -= _updatedPayouts;       
357         payoutsTo_[_customerAddress] += (int256) (_taxedEthereum*magnitude);       
358      
359         totalWithdraw += _taxedEthereum; 
360    
361         //tranfer amout of ethers to user
362         payable(address(_customerAddress)).transfer(_taxedEthereum);
363         
364         if(_ethereum < tokenPool) {
365             tokenPool = SafeMath.sub(tokenPool, _ethereum);   
366         }
367         // fire event
368         emit onTokenSell(_customerAddress, _tokens, _taxedEthereum,now,tokenBalanceLedger_[_customerAddress]);
369     }
370     
371     
372     function approve(address spender, uint amount) public override returns (bool) {
373         _approve(msg.sender, spender, amount);
374         return true;
375     }
376     
377      function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
378         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
379         return true;
380     }
381     
382      function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
383         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
384         return true;
385     }
386     
387     /**
388      * Transfer tokens from the caller to a new holder.
389      * Remember, there's a 10% fee here as well.
390      */
391     function transfer(address _toAddress, uint256 _amountOfTokens)
392         onlybelievers ()
393         public
394         override
395         returns(bool)
396     {
397         // setup
398         address _customerAddress = msg.sender;
399         
400         // make sure we have the requested tokens
401      
402         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
403         
404         // exchange tokens
405         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
406         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
407         
408         // update dividend trackers
409         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
410         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
411         
412        // fire event
413         emit Transfer(_customerAddress, _toAddress, _amountOfTokens,now);
414         
415         // ERC20
416         return true;
417        
418     }
419     
420     function transferFrom(address sender, address _toAddress, uint _amountOfTokens) public override returns (bool) {
421         // setup
422         address _customerAddress = sender;
423         
424         // make sure we have the requested tokens
425      
426         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
427         
428         // exchange tokens
429         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
430         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
431         
432         // update dividend trackers
433         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
434         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
435         
436        // fire event
437         emit Transfer(_customerAddress, _toAddress, _amountOfTokens,now);
438         
439         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(_amountOfTokens, "ERC20: transfer amount exceeds allowance"));
440         return true;
441     }
442  
443     /*----------  HELPERS AND CALCULATORS  ----------*/
444     /**
445      * Method to view the current Ethereum stored in the contract
446      * Example: totalEthereumBalance()
447      */
448     function totalEthereumBalance()
449         public
450         view
451         returns(uint)
452     {
453         return address(this).balance;
454     }
455     
456     /**
457      * Retrieve the total token supply.
458      */
459     function totalSupply()
460         public
461         override
462         view
463         returns(uint256)
464     {
465         return tokenSupply_;
466     }
467     
468     /**
469      * Retrieve the tokens owned by the caller.
470      */
471     function myTokens()
472         public
473         view
474         returns(uint256)
475     {
476         address _customerAddress = msg.sender;
477         return balanceOf(_customerAddress);
478     }
479     
480     /**
481      * Retrieve the dividends owned by the caller.
482        */ 
483     function myDividends(bool _includeReferralBonus) 
484         public 
485         view 
486         returns(uint256)
487     {
488         address _customerAddress = msg.sender;
489         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
490     }
491     
492     /**
493      * Retrieve the token balance of any single address.
494      */
495     function balanceOf(address _customerAddress)
496         view
497         public
498         override
499         returns(uint256)
500     {
501         return tokenBalanceLedger_[_customerAddress];
502     }
503     
504     /**
505      * Retrieve the dividend balance of any single address.
506      */
507     function dividendsOf(address _customerAddress)
508         view
509         public
510         returns(uint256)
511     {
512         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
513     }
514     
515     /**
516      * Return the buy price of 1 individual token.
517      */
518     function sellPrice() 
519         public 
520         view 
521         returns(uint256)
522     {
523        
524         if(tokenSupply_ == 0){
525             return tokenPriceInitial_ - tokenPriceIncremental_;
526         } else {
527             uint256 _ethereum = tokensToEthereum_(1e18);
528             uint256 tax = (_ethereum.mul(5)).div(100);
529             uint256 _dividends = SafeMath.div(_ethereum, tax);
530             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
531             return _taxedEthereum;
532         }
533     }
534     
535     /**
536      * Return the sell price of 1 individual token.
537      */
538     function buyPrice() 
539         public 
540         view 
541         returns(uint256)
542     {
543         
544         if(tokenSupply_ == 0){
545             return tokenPriceInitial_ + tokenPriceIncremental_;
546         } else {
547             uint256 _ethereum = tokensToEthereum_(1e18);
548             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
549             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
550             return _taxedEthereum;
551         }
552     }
553     
554    
555     function calculateTokensReceived(uint256 _ethToSpend) 
556         public 
557         view 
558         returns(uint256)
559     {
560         uint256 _ethereumToSpend = (_ethToSpend.mul(64)).div(100);
561         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
562         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
563         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
564         
565         return _amountOfTokens;
566     }
567     
568     
569     function getReferrer() public view returns(address){
570         return users[msg.sender].referrerAdd;
571     }
572    
573     function calculateEthereumReceived(uint256 _tokensToSell) 
574         public 
575         view 
576         returns(uint256)
577     {
578         require(_tokensToSell <= tokenSupply_);
579         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
580         uint256 tax = (_ethereum.mul(5)).div(100);
581         uint256 _dividends = SafeMath.div(_ethereum, tax);
582         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
583         return _taxedEthereum;
584     }
585     
586     function allowance(address owner, address spender) public view virtual override returns (uint256) {
587         return _allowances[owner][spender];
588     }
589    
590     function loyaltyOf() public view returns(uint256){
591         address _customerAddress = msg.sender;
592         
593         // user should hold 2500 tokens for qualify for loyalty bonus;
594         if(tokenBalanceLedger_[_customerAddress] >= 2000*10**uint256(decimals)){
595             // return loyalty bonus users
596             return ((uint256) ((int256)((profitperLoyalty) * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude)*14/5;
597         }
598         else{
599             return 0;
600         }
601     }
602     
603     function userReferrer(address _address) public view returns(address){
604         return userList[users[_address].referrerId];
605     }
606  
607     
608     /*==========================================
609     =            INTERNAL FUNCTIONS            =
610     ==========================================*/
611     function purchaseTokens(uint256 _eth, address _referredBy)
612         internal
613         returns(uint256)
614     {
615         uint256 _incomingEthereum = (_eth.mul(64)).div(100);
616         // data setup
617         address _customerAddress = msg.sender;
618         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
619         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
620         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
621         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
622         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
623         uint256 _fee = _dividends * magnitude;
624         tokenPool += _taxedEthereum;
625 
626       
627         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
628        
629         // is the user referred by a karmalink?
630         if(
631             // is this a referred purchase?
632             _referredBy != 0x0000000000000000000000000000000000000000 &&
633 
634             // no cheating!
635             _referredBy != _customerAddress 
636             
637         ){
638             // wealth redistribution
639             
640             distributeToSponsor(_referredBy,_eth);
641             
642         } else {
643             // no ref purchase
644             // add the referral bonus back to the global dividends cake
645             _dividends = SafeMath.add(_dividends, _referralBonus);
646             _fee = _dividends * magnitude;
647         }
648         
649         // we can't give people infinite ethereum
650         if(tokenSupply_ > 0){
651             
652             // add tokens to the pool
653             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
654  
655             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
656             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
657             profitperLoyalty += ((_dividends) * magnitude / (tokenSupply_));
658 
659 
660             // calculate the amount of tokens the customer receives over his purchase 
661             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
662         
663         } else {
664             // add tokens to the pool
665             tokenSupply_ = _amountOfTokens;
666         }
667         
668         // update circulating supply & the ledger address for the customer
669         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
670         
671         //update dividends tracker
672         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
673         payoutsTo_[_customerAddress] += _updatedPayouts;
674             
675         // fire event
676         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy,now,tokenBalanceLedger_[_customerAddress]);
677         
678         return _amountOfTokens;
679     }
680 
681        
682     function _approve(address owner, address spender, uint256 amount) internal virtual {
683         require(owner != address(0), "ERC20: approve from the zero address");
684         require(spender != address(0), "ERC20: approve to the zero address");
685 
686          _allowances[owner][spender] = amount;
687         emit Approval(owner, spender, amount);
688     }
689 
690     /**
691      * Calculate Token price based on an amount of incoming ethereum
692      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
693      */
694     function ethereumToTokens_(uint256 _ethereum)
695         internal
696         view
697         returns(uint256)
698     {
699         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
700         uint256 _tokensReceived = 
701          (
702             (
703                 // underflow attempts BTFO
704                 SafeMath.sub(
705                     (sqrt
706                         (
707                             (_tokenPriceInitial**2)
708                             +
709                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
710                             +
711                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
712                             +
713                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
714                         )
715                     ), _tokenPriceInitial
716                 )
717             )/(tokenPriceIncremental_)
718         )-(tokenSupply_)
719         ;
720   
721         return _tokensReceived;
722     }
723     
724   
725     /**
726      * Calculate token sell value.
727           */
728      function tokensToEthereum_(uint256 _tokens)
729         internal
730         view
731         returns(uint256)
732     {
733 
734         uint256 tokens_ = (_tokens + 1e18);
735         uint256 _tokenSupply = (tokenSupply_ + 1e18);
736         uint256 _etherReceived =
737         (
738             // underflow attempts BTFO
739             SafeMath.sub(
740                 (
741                     (
742                         (
743                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
744                         )-tokenPriceIncremental_
745                     )*(tokens_ - 1e18)
746                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
747             )
748         /1e18);
749         return _etherReceived;
750     }
751     
752     
753     function register(address _sender, address _referredBy) internal {
754         
755         uint256 _id = users[_referredBy].id; 
756         
757         basicData memory UserStruct;
758         currentId++;
759         
760         //add users data
761         UserStruct = basicData({
762             isExist: true,
763             id: currentId,
764             referrerId: _id,
765             referrerAdd: _referredBy
766         });
767         
768 
769         userList[currentId] = _sender;
770         users[msg.sender] = UserStruct;
771     }
772     
773     function distributeToSponsor(address _address,uint256 _eth) internal {
774         uint256 _sp1 = (_eth.mul(10)).div(100);
775         uint256 _sp2 = (_eth.mul(7)).div(100);
776         uint256 _sp3 = (_eth.mul(3)).div(100);
777         
778         address add1 = _address;
779         address add2 = users[_address].referrerAdd;
780         address add3 = users[add2].referrerAdd;
781         
782         //add amount of ref bonus to referrer
783         referralBalance_[add1] +=  (_sp1);
784         
785         sponsorsPaid += _sp1;
786         //fire event on distributionToSponsor
787         emit amountDistributedToSponsor(msg.sender, add1,_sp1);
788         
789         //add amount of ref bonus to referrer
790         referralBalance_[add2] += (_sp2);
791         
792         sponsorsPaid += _sp2;
793         //fire event on distributionToSponsor
794         emit amountDistributedToSponsor(msg.sender, add2, _sp2);
795 
796         //add amount of ref bonus to referrer
797         referralBalance_[add3] +=  (_sp3);
798         
799         sponsorsPaid += _sp3;
800         //fire event on distributionToSponsor
801         emit amountDistributedToSponsor(msg.sender, add3, _sp3);
802     }
803     
804     
805     function sqrt(uint x) internal pure returns (uint y) {
806         uint z = (x + 1) / 2;
807         y = x;
808         while (z < y) {
809             y = z;
810             z = (x / z + z) / 2;
811         }
812     }
813 }
814 
815 /**
816  * @title SafeMath
817  * @dev Math operations with safety checks that throw on error
818  */
819 library SafeMath {
820     function add(uint a, uint b) internal pure returns (uint) {
821         uint c = a + b;
822         require(c >= a, "SafeMath: addition overflow");
823 
824         return c;
825     }
826     function sub(uint a, uint b) internal pure returns (uint) {
827         return sub(a, b, "SafeMath: subtraction overflow");
828     }
829     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
830         require(b <= a, errorMessage);
831         uint c = a - b;
832 
833         return c;
834     }
835     function mul(uint a, uint b) internal pure returns (uint) {
836         if (a == 0) {
837             return 0;
838         }
839 
840         uint c = a * b;
841         require(c / a == b, "SafeMath: multiplication overflow");
842 
843         return c;
844     }
845     function div(uint a, uint b) internal pure returns (uint) {
846         return div(a, b, "SafeMath: division by zero");
847     }
848     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
849         // Solidity only automatically asserts when dividing by 0
850         require(b > 0, errorMessage);
851         uint c = a / b;
852 
853         return c;
854     }
855 }