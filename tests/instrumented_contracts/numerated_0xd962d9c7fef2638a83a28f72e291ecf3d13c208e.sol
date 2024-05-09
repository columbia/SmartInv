1 pragma solidity 0.4.20;
2 
3  /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function percent(uint value,uint numerator, uint denominator, uint precision) internal pure  returns(uint quotient) {
9     uint _numerator  = numerator * 10 ** (precision+1);
10     uint _quotient =  ((_numerator / denominator) + 5) / 10;
11     return (value*_quotient/1000000000000000000);
12   }
13   
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return c;
28   }
29 
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   function add(uint256 a, uint256 b) internal pure returns (uint256) {
36     uint256 c = a + b;
37     assert(c >= a);
38     return c;
39   }
40 }
41 
42 contract TREASURE {
43     
44     /*=====================================
45     =       CONTRACT CONFIGURABLES        =
46     =====================================*/
47     
48     // Token Details
49     string public name                                      = "TREASURE";
50     string public symbol                                    = "TRS";
51     uint8 constant public decimals                          = 18;
52     uint256 constant internal tokenPriceInitial             = 0.000000001 ether;
53     
54     // Token Price Increment & Decrement By 1Gwei
55     uint256 constant internal tokenPriceIncDec              = 0.000000001 ether;
56     
57     // Proof of Stake (Default at 1 Token)
58     uint256 public stakingReq                               = 1e18;
59     uint256 constant internal magnitude                     = 2**64;
60     
61     // Dividend/Distribution Percentage
62     uint8 constant internal referralFeePercent              = 5;
63     uint8 constant internal dividendFeePercent              = 10;
64     uint8 constant internal tradingFundWalletFeePercent     = 10;
65     uint8 constant internal communityWalletFeePercent       = 10;
66     
67     /*================================
68     =            DATASETS            =
69     ================================*/
70     
71     // amount of shares for each address (scaled number)
72     mapping(address => uint256) internal tokenBalanceLedger_;
73     mapping(address => uint256) internal referralBalance_;
74     mapping(address => int256) internal payoutsTo_;
75     mapping(address => uint256) internal sellingWithdrawBalance_;
76     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
77     mapping(address => string) internal contractTokenHolderAddresses;
78 
79     uint256 internal tokenTotalSupply                       = 0;
80     uint256 internal calReferralPercentage                  = 0;
81     uint256 internal calDividendPercentage                  = 0;
82     uint256 internal calculatedPercentage                   = 0;
83     uint256 internal soldTokens                             = 0;
84     uint256 internal tempIncomingEther                      = 0;
85     uint256 internal tempProfitPerShare                     = 0;
86     uint256 internal tempIf                                 = 0;
87     uint256 internal tempCalculatedDividends                = 0;
88     uint256 internal tempReferall                           = 0;
89     uint256 internal tempSellingWithdraw                    = 0;
90     uint256 internal profitPerShare_;
91     
92     // When this is set to true, only ambassadors can purchase tokens
93     bool public onlyAmbassadors = false;
94     
95     // Community Wallet Address
96     address internal constant CommunityWalletAddr           = address(0xa6ac94e896fBB8A2c27692e20B301D54D954071E);
97     // Trading Fund Wallet Address
98     address internal constant TradingWalletAddr             = address(0x40E68DF89cAa6155812225F12907960608A0B9dd);  
99 
100     // Administrator of this contract                        
101     mapping(bytes32 => bool) public admin;
102     
103     /*=================================
104     =            MODIFIERS            =
105     =================================*/
106     
107     // Only people with tokens
108     modifier onlybelievers() {
109         require(myTokens() > 0);
110         _;
111     }
112     
113     // Only people with profits
114     modifier onlyhodler() {
115         require(myDividends(true) > 0);
116         _;
117     }
118     
119     // Only people with sold token
120     modifier onlySelingholder() {
121         require(sellingWithdrawBalance_[msg.sender] > 0);
122         _;
123     }
124      
125     // Admin can do following things:
126     //  1. Change the name of contract.
127     //  2. Change the name of token.
128     //  3. Change the PoS difficulty .
129     // Admin CANNOT do following things:
130     //  1. Take funds out from contract.
131     //  2. Disable withdrawals.
132     //  3. Kill the smart contract.
133     //  4. Change the price of tokens.
134     modifier onlyAdmin() {
135         address _adminAddress = msg.sender;
136         require(admin[keccak256(_adminAddress)]);
137         _;
138     }
139     
140     /*===========================================
141     =       ADMINISTRATOR ONLY FUNCTIONS        =
142     ===========================================*/
143     
144     // Admin can manually disable the ambassador phase
145     function disableInitialStage() onlyAdmin() public {
146         onlyAmbassadors = false;
147     }
148     
149     function setAdmin(bytes32 _identifier, bool _status) onlyAdmin() public {
150         admin[_identifier]      = _status;
151     }
152     
153     function setStakingReq(uint256 _tokensAmount) onlyAdmin() public {
154         stakingReq              = _tokensAmount;
155     }
156     
157     function setName(string _tokenName) onlyAdmin() public {
158         name                    = _tokenName;
159     }
160     
161     function setSymbol(string _tokenSymbol) onlyAdmin() public {
162         symbol                  = _tokenSymbol;
163     }
164     
165     /*==============================
166     =            EVENTS            =
167     ==============================*/
168     
169     event onTokenPurchase (
170         address indexed customerAddress,
171         uint256 incomingEthereum,
172         uint256 tokensMinted,
173         address indexed referredBy
174     );
175     
176     event onTokenSell (
177         address indexed customerAddress,
178         uint256 tokensBurned
179     );
180     
181     event onReinvestment (
182         address indexed customerAddress,
183         uint256 ethereumReinvested,
184         uint256 tokensMinted
185     );
186     
187     event onWithdraw (
188         address indexed customerAddress,
189         uint256 ethereumWithdrawn
190     );
191     
192     event onSellingWithdraw (
193         address indexed customerAddress,
194         uint256 ethereumWithdrawn
195     
196     );
197     
198     event Transfer (
199         address indexed from,
200         address indexed to,
201         uint256 tokens
202     );
203     
204     /*=======================================
205     =            PUBLIC FUNCTIONS            =
206     =======================================*/
207     
208     function TREASURE() public {
209         // Contract Admin
210         admin[0x7cfa1051b7130edfac6eb71d17a849847cf6b7e7ad0b33fad4e124841e5acfbc] = true;
211     }
212     
213     // Check contract Ethereum Balance
214     function totalEthereumBalance() public view returns(uint) {
215         return this.balance;
216     }
217     
218     // Check tokens total supply
219     function totalSupply() public view returns(uint256) {
220         return tokenTotalSupply;
221     }
222     
223     // Check token balance owned by the caller
224     function myTokens() public view returns(uint256) {
225         address ownerAddress = msg.sender;
226         return tokenBalanceLedger_[ownerAddress];
227     }
228     
229     // Check sold tokens
230     function getSoldTokens() public view returns(uint256) {
231         return soldTokens;
232     }
233     
234     // Check dividends owned by the caller
235     function myDividends(bool _includeReferralBonus) public view returns(uint256) {
236         address _customerAddress = msg.sender;
237         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
238     }
239     
240     // Check dividend balance of any single address
241     function dividendsOf(address _customerAddress) view public returns(uint256) {
242         return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
243     }
244     
245     // Check token balance of any address
246     function balanceOf(address ownerAddress) public view returns(uint256) {
247         return tokenBalanceLedger_[ownerAddress]; ///need to change
248     }
249     
250     // Check Selling Withdraw balance of address
251     function sellingWithdrawBalance() view public returns(uint256) {
252         address _customerAddress = msg.sender; 
253         uint256 _sellingWithdraw = (uint256) (sellingWithdrawBalance_[_customerAddress]) ; // Get all balances
254         return  _sellingWithdraw;
255     }
256     
257     // Get Buy Price of 1 individual token
258     function sellPrice() public view returns(uint256) {
259         if(tokenTotalSupply == 0){
260             return tokenPriceInitial - tokenPriceIncDec;
261         } else {
262             uint256 _ethereum = tokensToEthereum_(1e18);
263             return _ethereum - SafeMath.percent(_ethereum,15,100,18);
264         }
265     }
266     
267     // Get Sell Price of 1 individual token
268     function buyPrice() public view returns(uint256) {
269         if(tokenTotalSupply == 0){
270             return tokenPriceInitial;
271         } else {
272             uint256 _ethereum = tokensToEthereum_(1e18);
273             return _ethereum;
274         }
275     }
276     
277     // Converts all of caller's dividends to tokens
278     function reinvest() onlyhodler() public {
279         address _customerAddress = msg.sender;
280         // Get dividends
281         uint256 _dividends                  = myDividends(true); // Retrieve Ref. Bonus later in the code
282         // Calculate 10% for distribution 
283         uint256  TenPercentForDistribution  = SafeMath.percent(_dividends,10,100,18);
284         // Calculate 90% to reinvest into tokens
285         uint256  NinetyPercentToReinvest    = SafeMath.percent(_dividends,90,100,18);
286         // Dispatch a buy order with the calculatedPercentage 
287         uint256 _tokens                     = purchaseTokens(NinetyPercentToReinvest, 0x0);
288         // Empty their  all dividends beacuse we are reinvesting them
289         payoutsTo_[_customerAddress]        +=  (int256) (SafeMath.sub(_dividends, referralBalance_[_customerAddress]) * magnitude);
290         referralBalance_[_customerAddress]  = 0;
291         
292         // Distribute to all users as per holdings
293         profitPerShare_ = SafeMath.add(profitPerShare_, (TenPercentForDistribution * magnitude) / tokenTotalSupply);
294         
295         // Fire Event
296         onReinvestment(_customerAddress, _dividends, _tokens);
297     }
298     
299     // Alias of sell() & withdraw() function
300     function exit() public {
301         // Get token count for caller & sell them all
302         address _customerAddress            = msg.sender;
303         uint256 _tokens                     = tokenBalanceLedger_[_customerAddress];
304         if(_tokens > 0) sell(_tokens);
305     
306         withdraw();
307     }
308     
309     // Withdraw all of the callers earnings
310     function withdraw() onlyhodler() public {
311         address _customerAddress            = msg.sender;
312         // Calculate 20% of all Dividends and Transfer them to two communities
313         uint256 _dividends                  = myDividends(true); // get all dividends
314         // Calculate 10% for Trading Wallet
315         uint256 TenPercentForTradingWallet  = SafeMath.percent(_dividends,10,100,18);
316         // Calculate 10% for Community Wallet
317         uint256 TenPercentForCommunityWallet= SafeMath.percent(_dividends,10,100,18);
318 
319         // Update Dividend Tracker
320         payoutsTo_[_customerAddress]        +=  (int256) (SafeMath.sub(_dividends, referralBalance_[_customerAddress]) * magnitude);
321         referralBalance_[_customerAddress]  = 0;
322        
323         // Delivery Service
324         address(CommunityWalletAddr).transfer(TenPercentForCommunityWallet);
325         
326         // Delivery Service
327         address(TradingWalletAddr).transfer(TenPercentForTradingWallet);
328         
329         // Calculate 80% for transfering it to Customer Address
330         uint256 EightyPercentForCustomer    = SafeMath.percent(_dividends,80,100,18);
331 
332         // Delivery Service
333         address(_customerAddress).transfer(EightyPercentForCustomer);
334         
335         // Fire Event
336         onWithdraw(_customerAddress, _dividends);
337     }
338     
339     // Withdraw all sellingWithdraw of the callers earnings
340     function sellingWithdraw() onlySelingholder() public {
341         address customerAddress             = msg.sender;
342         uint256 _sellingWithdraw            = sellingWithdrawBalance_[customerAddress];
343         
344         // Empty all sellingWithdraw beacuse we are giving them ETHs
345         sellingWithdrawBalance_[customerAddress] = 0;
346 
347         // Delivery Service
348         address(customerAddress).transfer(_sellingWithdraw);
349         
350         // Fire Event
351         onSellingWithdraw(customerAddress, _sellingWithdraw);
352     }
353     
354     // Sell Tokens
355     // Remember there's a 10% fee for sell
356     function sell(uint256 _amountOfTokens) onlybelievers() public {
357         address customerAddress                 = msg.sender;
358         // Calculate 10% of tokens and distribute them 
359         require(_amountOfTokens <= tokenBalanceLedger_[customerAddress] && _amountOfTokens > 1e18);
360         
361         uint256 _tokens                         = SafeMath.sub(_amountOfTokens, 1e18);
362         uint256 _ethereum                       = tokensToEthereum_(_tokens);
363         // Calculate 10% for distribution 
364         uint256  TenPercentToDistribute         = SafeMath.percent(_ethereum,10,100,18);
365         // Calculate 90% for customer withdraw wallet
366         uint256  NinetyPercentToCustomer        = SafeMath.percent(_ethereum,90,100,18);
367         
368         // Burn Sold Tokens
369         tokenTotalSupply                        = SafeMath.sub(tokenTotalSupply, _tokens);
370         tokenBalanceLedger_[customerAddress]    = SafeMath.sub(tokenBalanceLedger_[customerAddress], _tokens);
371         
372         // Substract sold tokens from circulations of tokenTotalSupply
373         soldTokens                              = SafeMath.sub(soldTokens,_tokens);
374         
375         // Update sellingWithdrawBalance of customer 
376         sellingWithdrawBalance_[customerAddress] += NinetyPercentToCustomer;   
377         
378         // Update dividends tracker
379         int256 _updatedPayouts                  = (int256) (profitPerShare_ * _tokens + (TenPercentToDistribute * magnitude));
380         payoutsTo_[customerAddress]             -= _updatedPayouts; 
381         
382         // Distribute to all users as per holdings         
383         if (tokenTotalSupply > 0) {
384             // Update the amount of dividends per token
385             profitPerShare_ = SafeMath.add(profitPerShare_, (TenPercentToDistribute * magnitude) / tokenTotalSupply);
386         }
387       
388         // Fire Event
389         onTokenSell(customerAddress, _tokens);
390     }
391     
392     // Transfer tokens from the caller to a new holder
393     // Remember there's a 5% fee here for transfer
394     function transfer(address _toAddress, uint256 _amountOfTokens) onlybelievers() public returns(bool) {
395         address customerAddress                 = msg.sender;
396         // Make sure user have the requested tokens
397         
398         require(!onlyAmbassadors && _amountOfTokens <= tokenBalanceLedger_[customerAddress] && _amountOfTokens > 1e18);
399         
400         // Calculate 5% of total tokens
401         uint256  FivePercentOfTokens            = SafeMath.percent(_amountOfTokens,5,100,18);
402         // Calculate 95% of total tokens
403         uint256  NinetyFivePercentOfTokens      = SafeMath.percent(_amountOfTokens,95,100,18);
404         
405         // Burn the fee tokens
406         // Convert ETH to Tokens
407         tokenTotalSupply                        = SafeMath.sub(tokenTotalSupply,FivePercentOfTokens);
408         
409         // Substract 5% from community of tokens
410         soldTokens                              = SafeMath.sub(soldTokens, FivePercentOfTokens);
411 
412         // Exchange Tokens
413         tokenBalanceLedger_[customerAddress]    = SafeMath.sub(tokenBalanceLedger_[customerAddress], _amountOfTokens);
414         tokenBalanceLedger_[_toAddress]         = SafeMath.add(tokenBalanceLedger_[_toAddress], NinetyFivePercentOfTokens) ;
415         
416         // Calculate value of all token to transfer to ETH
417         uint256 FivePercentToDistribute         = tokensToEthereum_(FivePercentOfTokens);
418         
419         // Update dividend trackers
420         payoutsTo_[customerAddress]             -= (int256) (profitPerShare_ * _amountOfTokens);
421         payoutsTo_[_toAddress]                  += (int256) (profitPerShare_ * NinetyFivePercentOfTokens);
422         
423         // Distribute to all users as per holdings 
424         profitPerShare_                         = SafeMath.add(profitPerShare_, (FivePercentToDistribute * magnitude) / tokenTotalSupply);
425 
426         // Fire Event
427         Transfer(customerAddress, _toAddress, NinetyFivePercentOfTokens);
428         
429         return true;
430     }
431     
432     // Function to calculate actual value after Taxes
433     function calculateTokensReceived(uint256 _ethereumToSpend) public view returns(uint256) {
434         // Calculate 15% for distribution 
435         uint256  fifteen_percentToDistribute= SafeMath.percent(_ethereumToSpend,15,100,18);
436 
437         uint256 _dividends = SafeMath.sub(_ethereumToSpend, fifteen_percentToDistribute);
438         uint256 _amountOfTokens = ethereumToTokens_(_dividends);
439         
440         return _amountOfTokens;
441     }
442     
443     // Function to calculate received ETH
444     function calculateEthereumReceived(uint256 _tokensToSell) public view returns(uint256) {
445         require(_tokensToSell <= tokenTotalSupply);
446         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
447         // Calculate 10% for distribution 
448         uint256  ten_percentToDistribute= SafeMath.percent(_ethereum,10,100,18);
449         
450         uint256 _dividends = SafeMath.sub(_ethereum, ten_percentToDistribute);
451 
452         return _dividends;
453     }
454     
455     // Convert all incoming ETH to Tokens for the caller and pass down the referral address (if any)
456     function buy(address referredBy) public payable {
457         purchaseTokens(msg.value, referredBy);
458     }
459     
460     // Fallback function to handle ETH that was sent straight to the contract
461     // Unfortunately we cannot use a referral address this way.
462     function() payable public {
463         purchaseTokens(msg.value, 0x0);
464     }
465     
466     /*==========================================
467     =            INTERNAL FUNCTIONS            =
468     ==========================================*/
469     
470     function purchaseTokens(uint256 incomingEthereum, address referredBy) internal returns(uint256) {
471         // Datasets
472         address customerAddress     = msg.sender;
473         tempIncomingEther           = incomingEthereum;
474 
475         // Calculate Percentage for Referral (if any)
476         calReferralPercentage       = SafeMath.percent(incomingEthereum,referralFeePercent,100,18);
477         // Calculate Dividend
478         calDividendPercentage       = SafeMath.percent(incomingEthereum,dividendFeePercent,100,18);
479         // Calculate remaining amount
480         calculatedPercentage        = SafeMath.percent(incomingEthereum,85,100,18);
481         // Token will receive against the sent ETH
482         uint256 _amountOfTokens     = ethereumToTokens_(SafeMath.percent(incomingEthereum,85,100,18));  
483         uint256 _dividends          = 0;
484         uint256 minOneToken         = 1 * (10 ** decimals);
485         require(_amountOfTokens > minOneToken && (SafeMath.add(_amountOfTokens,tokenTotalSupply) > tokenTotalSupply));
486         
487         // If user referred by a Treasure Key
488         if(
489             // Is this a referred purchase?
490             referredBy  != 0x0000000000000000000000000000000000000000 &&
491             // No Cheating!!!!
492             referredBy  != customerAddress &&
493             // Does the referrer have at least X whole tokens?
494             tokenBalanceLedger_[referredBy] >= stakingReq
495         ) {
496             // Give 5 % to Referral User
497             referralBalance_[referredBy]    += SafeMath.percent(incomingEthereum,5,100,18);
498             _dividends              = calDividendPercentage;
499         } else {
500             // Add the referral bonus back to the global dividend
501             _dividends              = SafeMath.add(calDividendPercentage, calReferralPercentage);
502         }
503         
504         // We can't give people infinite ETH
505         if(tokenTotalSupply > 0) {
506             // Add tokens to the pool
507             tokenTotalSupply        = SafeMath.add(tokenTotalSupply, _amountOfTokens);
508             profitPerShare_         += (_dividends * magnitude / (tokenTotalSupply));
509         } else {
510             // Add tokens to the pool
511             tokenTotalSupply        = _amountOfTokens;
512         }
513         
514         // Update circulating supply & the ledger address for the customer
515         tokenBalanceLedger_[customerAddress] = SafeMath.add(tokenBalanceLedger_[customerAddress], _amountOfTokens);
516         
517         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them
518         int256 _updatedPayouts      = (int256) (profitPerShare_ * _amountOfTokens);
519         payoutsTo_[customerAddress] += _updatedPayouts;
520         
521         // Fire Event
522         onTokenPurchase(customerAddress, incomingEthereum, _amountOfTokens, referredBy);
523         
524         // Calculate sold tokens here
525         soldTokens += _amountOfTokens;
526         
527         return _amountOfTokens;
528 
529     }
530     
531     // Calculate token price based on an amount of incoming ETH
532     // It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
533     // Some conversions occurred to prevent decimal errors or underflows/overflows in solidity code.
534     function ethereumToTokens_(uint256 _ethereum) internal view returns(uint256) {
535         uint256 _tokenPriceInitial  = tokenPriceInitial * 1e18;
536         uint256 _tokensReceived     = 
537          (
538             (
539                 SafeMath.sub(
540                     (SqRt
541                         (
542                             (_tokenPriceInitial**2)
543                             +
544                             (2*(tokenPriceIncDec * 1e18)*(_ethereum * 1e18))
545                             +
546                             (((tokenPriceIncDec)**2)*(tokenTotalSupply**2))
547                             +
548                             (2*(tokenPriceIncDec)*_tokenPriceInitial*tokenTotalSupply)
549                         )
550                     ), _tokenPriceInitial
551                 )
552             )/(tokenPriceIncDec)
553         )-(tokenTotalSupply);
554         return _tokensReceived;
555     }
556     
557     // Calculate token sell value
558     // It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
559     // Some conversions occurred to prevent decimal errors or underflows/overflows in solidity code.
560     function tokensToEthereum_(uint256 _tokens) public view returns(uint256) {
561         uint256 tokens_         = (_tokens + 1e18);
562         uint256 _tokenSupply    = (tokenTotalSupply + 1e18);
563         uint256 _etherReceived  =
564         (
565             SafeMath.sub(
566                 (
567                     (
568                         (
569                             tokenPriceInitial + (tokenPriceIncDec * (_tokenSupply/1e18))
570                         )-tokenPriceIncDec
571                     )*(tokens_ - 1e18)
572                 ),(tokenPriceIncDec*((tokens_**2-tokens_)/1e18))/2
573             )/1e18);
574         return _etherReceived;
575     }
576     
577     // This is where all your gas goes
578     function SqRt(uint x) internal pure returns (uint y) {
579         uint z = (x + 1) / 2;
580         y = x;
581         while (z < y) {
582             y = z;
583             z = (x / z + z) / 2;
584         }
585     }
586     
587 }