1 pragma solidity ^0.4.24;
2 
3 
4 
5 contract _8thereum {
6 
7 
8 
9     /*=================================
10     =            MODIFIERS            =
11     =================================*/
12     // only people with tokens
13     modifier onlyTokenHolders() 
14     {
15         require(myTokens() > 0);
16         _;
17     }
18     
19     // only people with profits
20     modifier onlyDividendPositive() 
21     {
22         require(myDividends(true) > 0);
23         _;
24     }
25 
26     // only owner
27     modifier onlyOwner() 
28     { 
29         require (address(msg.sender) == owner); 
30         _; 
31     }
32     
33     // only non-whales
34     modifier onlyNonOwner() 
35     { 
36         require (address(msg.sender) != owner); 
37         _; 
38     }
39     
40     modifier onlyFoundersIfNotPublic() 
41     {
42         if(!openToThePublic)
43         {
44             require (founders[address(msg.sender)] == true);   
45         }
46         _;
47     }    
48     
49     modifier onlyApprovedContracts()
50     {
51         if(!gameList[msg.sender])
52         {
53             require (msg.sender == tx.origin);
54         }
55         _;
56     }
57 
58     /*==============================
59     =            EVENTS            =
60     ==============================*/
61     event onTokenPurchase(
62         address indexed customerAddress,
63         uint256 incomingEthereum,
64         uint256 tokensMinted,
65         address indexed referredBy
66     );
67     
68     event onTokenSell(
69         address indexed customerAddress,
70         uint256 tokensBurned,
71         uint256 ethereumEarned
72     );
73     
74     event onReinvestment(
75         address indexed customerAddress,
76         uint256 ethereumReinvested,
77         uint256 tokensMinted
78     );
79     
80     event onWithdraw(
81         address indexed customerAddress,
82         uint256 ethereumWithdrawn
83     );
84     
85     event lotteryPayout(
86         address customerAddress, 
87         uint256 lotterySupply
88     );
89     
90     event whaleDump(
91         uint256 amount
92     );
93     
94     // ERC20
95     event Transfer(
96         address indexed from,
97         address indexed to,
98         uint256 tokens
99     );
100     
101     
102     /*=====================================
103     =            CONFIGURABLES            =
104     =====================================*/
105     string public name = "8thereum";
106     string public symbol = "BIT";
107     bool public openToThePublic = false;
108     address public owner;
109     uint8 constant public decimals = 18;
110     uint8 constant internal dividendFee = 15;
111     uint256 constant internal tokenPrice = 500000000000000;//0.0005 ether
112     uint256 constant internal magnitude = 2**64;
113     uint256 constant public referralLinkRequirement = 5e18;// 5 token minimum for referral link
114     
115    /*================================
116     =            DATASETS            =
117     ================================*/
118     mapping(address => bool) internal gameList;
119     mapping(address => uint256) internal publicTokenLedger;
120     mapping(address => uint256) public   whaleLedger;
121     mapping(address => uint256) public   gameLedger;
122     mapping(address => uint256) internal referralBalances;
123     mapping(address => int256) internal payoutsTo_;
124     mapping(address => mapping(address => uint256)) public gamePlayers;
125     mapping(address => bool) internal founders;
126     address[] lotteryPlayers;
127     uint256 internal lotterySupply = 0;
128     uint256 internal tokenSupply = 0;
129     uint256 internal gameSuppply = 0;
130     uint256 internal profitPerShare_;
131     
132     /*=======================================
133     =            PUBLIC FUNCTIONS            =
134     =======================================*/
135     /*
136     * -- APPLICATION ENTRY POINTS --  
137     */
138     constructor()
139         public
140     {
141         // no admin, but the owner of the contract is the address used for whale
142         owner = address(msg.sender);
143 
144         // add founders here... Founders don't get any special priveledges except being first in line at launch day
145         founders[owner] = true; //owner's address
146         founders[0x7e474fe5Cfb720804860215f407111183cbc2f85] = true; //KENNY
147         founders[0x5138240E96360ad64010C27eB0c685A8b2eDE4F2] = true; //crypt0b!t 
148         founders[0xAA7A7C2DECB180f68F11E975e6D92B5Dc06083A6] = true; //NumberOfThings 
149         founders[0x6DC622a04Fd13B6a1C3C5B229CA642b8e50e1e74] = true; //supermanlxvi
150         founders[0x41a21b264F9ebF6cF571D4543a5b3AB1c6bEd98C] = true; //Ravi
151     }
152     
153      
154     /**
155      * Converts all incoming ethereum to tokens for the caller, and passes down the referral address
156      */
157     function buy(address referredyBy)
158         onlyFoundersIfNotPublic()
159         public
160         payable
161         returns(uint256)
162     {
163         require (msg.sender == tx.origin);
164         excludeWhale(referredyBy); 
165     }
166     
167     /**
168      * Fallback function to handle ethereum that was send straight to the contract
169      */
170     function()
171         onlyFoundersIfNotPublic()
172         payable
173         public
174     {
175         require (msg.sender == tx.origin);
176         excludeWhale(0x0); 
177     }
178     
179     /**
180      * Converts all of caller's dividends to tokens.
181      */
182     function reinvest()
183         onlyDividendPositive()
184         onlyNonOwner()
185         public
186     {   
187         
188         require (msg.sender == tx.origin);
189         
190         // fetch dividends
191         uint256 dividends = myDividends(false); // retrieve ref. bonus later in the code
192         
193         // pay out the dividends virtually
194         address customerAddress = msg.sender;
195         payoutsTo_[customerAddress] +=  int256(SafeMath.mul(dividends, magnitude));
196         
197         // retrieve ref. bonus
198         dividends += referralBalances[customerAddress];
199         referralBalances[customerAddress] = 0;
200         
201         // dispatch a buy order with the virtualized "withdrawn dividends"
202         uint256 _tokens = purchaseTokens(dividends, 0x0);
203         
204         // fire event for logging 
205         emit onReinvestment(customerAddress, dividends, _tokens);
206     }
207     
208     /**
209      * Alias of sell() and withdraw().
210      */
211     function exit()
212         onlyNonOwner()
213         onlyTokenHolders()
214         public
215     {
216         require (msg.sender == tx.origin);
217         
218         // get token count for caller & sell them all
219         address customerAddress = address(msg.sender);
220         uint256 _tokens = publicTokenLedger[customerAddress];
221         
222         if(_tokens > 0) 
223         {
224             sell(_tokens);
225         }
226 
227         withdraw();
228     }
229 
230     /**
231      * Withdraws all of the callers earnings.
232      */
233     function withdraw()
234         onlyNonOwner()
235         onlyDividendPositive()
236         public
237     {
238         require (msg.sender == tx.origin);
239         
240         // setup data
241         address customerAddress = msg.sender;
242         uint256 dividends = myDividends(false); // get ref. bonus later in the code
243         
244         // update dividend tracker
245         payoutsTo_[customerAddress] +=  int256(SafeMath.mul(dividends, magnitude));
246         
247         // add ref. bonus
248         dividends += referralBalances[customerAddress];
249         referralBalances[customerAddress] = 0;
250         
251         customerAddress.transfer(dividends);
252         
253         // fire event for logging 
254         emit onWithdraw(customerAddress, dividends);
255     }
256     
257     /**
258      * Liquifies tokens to ethereum.
259      */
260     function sell(uint256 _amountOfTokens)
261         onlyNonOwner()
262         onlyTokenHolders()
263         public
264     {
265         require (msg.sender == tx.origin);
266         require((_amountOfTokens <= publicTokenLedger[msg.sender]) && (_amountOfTokens > 0));
267 
268         uint256 _tokens = _amountOfTokens;
269         uint256 ethereum = tokensToEthereum_(_tokens);
270         uint256 dividends = (ethereum * dividendFee) / 100;
271         uint256 taxedEthereum = SafeMath.sub(ethereum, dividends);
272         
273         //Take some divs for the lottery and whale
274         uint256 lotteryAndWhaleFee = dividends / 3;
275         dividends -= lotteryAndWhaleFee;
276         
277         //figure out the lotteryFee
278         uint256 lotteryFee = lotteryAndWhaleFee / 2;
279         //add tokens to the whale
280         uint256 whaleFee = lotteryAndWhaleFee - lotteryFee;
281         whaleLedger[owner] += whaleFee;
282         //add tokens to the lotterySupply
283         lotterySupply += ethereumToTokens_(lotteryFee);
284         // burn the sold tokens
285         tokenSupply -=  _tokens;
286         publicTokenLedger[msg.sender] -= _tokens;
287         
288         
289         // update dividends tracker
290         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (taxedEthereum * magnitude));
291         payoutsTo_[msg.sender] -= _updatedPayouts;  
292         
293         // dividing by zero is a bad idea
294         if (tokenSupply > 0) 
295         {
296             // update the amount of dividends per token
297             profitPerShare_ = SafeMath.add(profitPerShare_, (dividends * magnitude) / tokenSupply);
298         }
299         
300         // fire event for logging 
301         emit onTokenSell(msg.sender, _tokens, taxedEthereum);
302     }
303     
304     
305     /**
306      * Transfer tokens from the caller to a new holder.
307      */
308     function transfer(address _toAddress, uint256 _amountOfTokens)
309         onlyNonOwner()
310         onlyTokenHolders()
311         onlyApprovedContracts()
312         public
313         returns(bool)
314     {
315         assert(_toAddress != owner);
316         
317         // setup
318         if(gameList[msg.sender] == true) //If game is transferring tokens
319         {
320             require((_amountOfTokens <= gameLedger[msg.sender]) && (_amountOfTokens > 0 ));
321              // exchange tokens
322             gameLedger[msg.sender] -= _amountOfTokens;
323             gameSuppply -= _amountOfTokens;
324             publicTokenLedger[_toAddress] += _amountOfTokens; 
325             
326             // update dividend trackers
327             payoutsTo_[_toAddress] += int256(profitPerShare_ * _amountOfTokens); 
328         }
329         else if (gameList[_toAddress] == true) //If customer transferring tokens to game
330         {
331             // make sure we have the requested tokens
332             //each game should only cost one token to play
333             require((_amountOfTokens <= publicTokenLedger[msg.sender]) && (_amountOfTokens > 0 && (_amountOfTokens == 1e18)));
334              
335              // exchange tokens
336             publicTokenLedger[msg.sender] -=  _amountOfTokens;
337             gameLedger[_toAddress] += _amountOfTokens; 
338             gameSuppply += _amountOfTokens;
339             gamePlayers[_toAddress][msg.sender] += _amountOfTokens;
340             
341             // update dividend trackers
342             payoutsTo_[msg.sender] -= int256(profitPerShare_ * _amountOfTokens);
343         }
344         else{
345             // make sure we have the requested tokens
346             require((_amountOfTokens <= publicTokenLedger[msg.sender]) && (_amountOfTokens > 0 ));
347                 // exchange tokens
348             publicTokenLedger[msg.sender] -= _amountOfTokens;
349             publicTokenLedger[_toAddress] += _amountOfTokens; 
350             
351             // update dividend trackers
352             payoutsTo_[msg.sender] -= int256(profitPerShare_ * _amountOfTokens);
353             payoutsTo_[_toAddress] += int256(profitPerShare_ * _amountOfTokens); 
354             
355         }
356         
357         // fire event for logging 
358         emit Transfer(msg.sender, _toAddress, _amountOfTokens); 
359         
360         // ERC20
361         return true;
362        
363     }
364     
365     /*----------  OWNER ONLY FUNCTIONS  ----------*/
366 
367     /**
368      * future games can be added so they can't earn divs on their token balances
369      */
370     function setGames(address newGameAddress)
371     onlyOwner()
372     public
373     {
374         gameList[newGameAddress] = true;
375     }
376     
377     /**
378      * Want to prevent snipers from buying prior to launch
379      */
380     function goPublic() 
381         onlyOwner()
382         public 
383         returns(bool)
384 
385     {
386         openToThePublic = true;
387         return openToThePublic;
388     }
389     
390     
391     /*----------  HELPERS AND CALCULATORS  ----------*/
392     /**
393      * Method to view the current Ethereum stored in the contract
394      */
395     function totalEthereumBalance()
396         public
397         view
398         returns(uint)
399     {
400         return address(this).balance;
401     }
402     
403     /**
404      * Retrieve the total token supply.
405      */
406     function totalSupply()
407         public
408         view
409         returns(uint256)
410     {
411         return (tokenSupply + lotterySupply + gameSuppply); //adds the tokens from ambassadors to the supply (but not to the dividends calculation which is based on the supply)
412     }
413     
414     /**
415      * Retrieve the tokens owned by the caller.
416      */
417     function myTokens()
418         public
419         view
420         returns(uint256)
421     {
422         return balanceOf(msg.sender);
423     }
424     
425     /**
426      * Retrieve the dividends owned by the caller.
427      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
428      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
429      * But in the internal calculations, we want them separate. 
430      */ 
431     function myDividends(bool _includeReferralBonus) 
432         public 
433         view 
434         returns(uint256)
435     {
436         return _includeReferralBonus ? dividendsOf(msg.sender) + referralBalances[msg.sender] : dividendsOf(msg.sender) ;
437     }
438     
439     /**
440      * Retrieve the token balance of any single address.
441      */
442     function balanceOf(address customerAddress)
443         view
444         public
445         returns(uint256)
446     {
447         uint256 balance;
448 
449         if (customerAddress == owner) 
450         { 
451             // to show div balance of owner
452             balance = whaleLedger[customerAddress]; 
453         }
454         else if(gameList[customerAddress] == true) 
455         {
456             // games can still see their token balance
457             balance = gameLedger[customerAddress];
458         }
459         else 
460         {   
461             // to see token balance for anyone else
462             balance = publicTokenLedger[customerAddress];
463         }
464         return balance;
465     }
466     
467     /**
468      * Retrieve the dividend balance of any single address.
469      */
470     function dividendsOf(address customerAddress)
471         view
472         public
473         returns(uint256)
474     {
475       return (uint256) ((int256)(profitPerShare_ * publicTokenLedger[customerAddress]) - payoutsTo_[customerAddress]) / magnitude;
476     }
477     
478     /**
479      * Return the buy and sell price of 1 individual token.
480      */
481     function buyAndSellPrice()
482     public
483     pure 
484     returns(uint256)
485     {
486         uint256 ethereum = tokenPrice;
487         uint256 dividends = SafeMath.div(SafeMath.mul(ethereum, dividendFee ), 100);
488         uint256 taxedEthereum = SafeMath.sub(ethereum, dividends);
489         return taxedEthereum;
490     }
491     
492     /**
493      * Function for the frontend to dynamically retrieve the price of buy orders.
494      */
495     function calculateTokensReceived(uint256 ethereumToSpend) 
496         public 
497         pure 
498         returns(uint256)
499     {
500         require(ethereumToSpend >= tokenPrice);
501         uint256 dividends = SafeMath.div(SafeMath.mul(ethereumToSpend, dividendFee ), 100);
502         uint256 taxedEthereum = SafeMath.sub(ethereumToSpend, dividends);
503         uint256 amountOfTokens = ethereumToTokens_(taxedEthereum);
504         
505         return amountOfTokens;
506     }
507     
508     /**
509      * Function for the frontend to dynamically retrieve the price of sell orders.
510      */
511     function calculateEthereumReceived(uint256 tokensToSell) 
512         public 
513         view 
514         returns(uint256)
515     {
516         require(tokensToSell <= tokenSupply);
517         uint256 ethereum = tokensToEthereum_(tokensToSell);
518         uint256 dividends = SafeMath.div(SafeMath.mul(ethereum, dividendFee ), 100);
519         uint256 taxedEthereum = SafeMath.sub(ethereum, dividends);
520         return taxedEthereum;
521     }
522     
523     
524     /*==========================================
525     =            INTERNAL FUNCTIONS            =
526     ==========================================*/
527     
528     
529     function excludeWhale(address referredyBy) 
530         onlyNonOwner()
531         internal 
532         returns(uint256) 
533     { 
534         require (msg.sender == tx.origin);
535         uint256 tokenAmount;
536 
537         tokenAmount = purchaseTokens(msg.value, referredyBy); //redirects to purchaseTokens so same functionality
538 
539         if(gameList[msg.sender] == true)
540         {
541             tokenSupply = SafeMath.sub(tokenSupply, tokenAmount); // takes out game's tokens from the tokenSupply (important for redistribution)
542             publicTokenLedger[msg.sender] = SafeMath.sub(publicTokenLedger[msg.sender], tokenAmount); // takes out game's tokens from its ledger so it is "officially" holding 0 tokens. (=> doesn't receive dividends anymore)
543             gameLedger[msg.sender] += tokenAmount;    //it gets a special ledger so it can't sell its tokens
544             gameSuppply += tokenAmount; // we need this for a correct totalSupply() number later
545         }
546 
547         return tokenAmount;
548     }
549 
550 
551     function purchaseTokens(uint256 incomingEthereum, address referredyBy)
552         internal
553         returns(uint256)
554     {
555         require (msg.sender == tx.origin);
556         // data setup
557         uint256 undividedDivs = SafeMath.div(SafeMath.mul(incomingEthereum, dividendFee ), 100);
558         
559         //divide the divs
560         uint256 lotteryAndWhaleFee = undividedDivs / 3;
561         uint256 referralBonus = lotteryAndWhaleFee;
562         uint256 dividends = SafeMath.sub(undividedDivs, (referralBonus + lotteryAndWhaleFee));
563         uint256 taxedEthereum = incomingEthereum - undividedDivs;
564         uint256 amountOfTokens = ethereumToTokens_(taxedEthereum);
565         uint256 whaleFee = lotteryAndWhaleFee / 2;
566         //add divs to whale
567         whaleLedger[owner] += whaleFee;
568         
569         //add tokens to the lotterySupply
570         lotterySupply += ethereumToTokens_(lotteryAndWhaleFee - whaleFee);
571         
572         //add entry to lottery
573         lotteryPlayers.push(msg.sender);
574        
575         uint256 fee = dividends * magnitude;
576  
577         require(amountOfTokens > 0 && (amountOfTokens + tokenSupply) > tokenSupply);
578         
579         // is the user referred by a masternode?
580         if(
581             // is this a referred purchase?
582             referredyBy != 0x0000000000000000000000000000000000000000 &&
583 
584             // no cheating!
585             referredyBy != msg.sender && 
586             
587             //can't use games for referralBonus
588             gameList[referredyBy] == false  &&
589             
590             // does the referrer have at least 5 tokens?
591             publicTokenLedger[referredyBy] >= referralLinkRequirement
592         )
593         {
594             // wealth redistribution
595             referralBalances[referredyBy] += referralBonus;
596         } else
597         {
598             // no ref purchase
599             // add the referral bonus back
600             dividends += referralBonus;
601             fee = dividends * magnitude;
602         }
603 
604         uint256 payoutDividends = isWhalePaying();
605         
606         // we can't give people infinite ethereum
607         if(tokenSupply > 0)
608         {
609             // add tokens to the pool
610             tokenSupply += amountOfTokens;
611             
612              // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
613             profitPerShare_ += ((payoutDividends + dividends) * magnitude / (tokenSupply));
614             
615             // calculate the amount of tokens the customer receives over his purchase 
616             fee -= fee-(amountOfTokens * (dividends * magnitude / (tokenSupply)));
617         } else 
618         {
619             // add tokens to the pool
620             tokenSupply = amountOfTokens;
621             
622             //if there are zero tokens prior to this buy, and the whale is triggered, send dividends back to whale
623             if(whaleLedger[owner] == 0)
624             {
625                 whaleLedger[owner] = payoutDividends;
626             }
627         }
628 
629         // update circulating supply & the ledger address for the customer
630         publicTokenLedger[msg.sender] += amountOfTokens;
631         
632         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
633         // BUT, you still get the whale's divs from your purchase.... so, you still get SOMETHING.
634         int256 _updatedPayouts = int256((profitPerShare_ * amountOfTokens) - fee);
635         payoutsTo_[msg.sender] += _updatedPayouts;
636         
637      
638         // fire event for logging 
639         emit onTokenPurchase(msg.sender, incomingEthereum, amountOfTokens, referredyBy);
640         
641         return amountOfTokens;
642     }
643     
644     
645      /**
646      * Calculate token sell value.
647      * It's a simple algorithm. Hopefully, you don't need a whitepaper with it in scientific notation.
648      */
649     function isWhalePaying()
650     private
651     returns(uint256)
652     {
653         uint256 payoutDividends = 0;
654          // this is where we check for lottery winner
655         if(whaleLedger[owner] >= 1 ether)
656         {
657             if(lotteryPlayers.length > 0)
658             {
659                 uint256 winner = uint256(blockhash(block.number-1))%lotteryPlayers.length;
660                 
661                 publicTokenLedger[lotteryPlayers[winner]] += lotterySupply;
662                 emit lotteryPayout(lotteryPlayers[winner], lotterySupply);
663                 tokenSupply += lotterySupply;
664                 lotterySupply = 0;
665                 delete lotteryPlayers;
666                
667             }
668             //whale pays out everyone its divs
669             payoutDividends = whaleLedger[owner];
670             whaleLedger[owner] = 0;
671             emit whaleDump(payoutDividends);
672         }
673         return payoutDividends;
674     }
675 
676     /**
677      * Calculate Token price based on an amount of incoming ethereum
678      *It's a simple algorithm. Hopefully, you don't need a whitepaper with it in scientific notation.
679      */
680     function ethereumToTokens_(uint256 ethereum)
681         internal
682         pure
683         returns(uint256)
684     {
685         uint256 tokensReceived = ((ethereum / tokenPrice) * 1e18);
686                
687         return tokensReceived;
688     }
689     
690     /**
691      * Calculate token sell value.
692      * It's a simple algorithm. Hopefully, you don't need a whitepaper with it in scientific notation.
693      */
694      function tokensToEthereum_(uint256 coin)
695         internal
696         pure
697         returns(uint256)
698     {
699         uint256 ethReceived = tokenPrice * (SafeMath.div(coin, 1e18));
700         
701         return ethReceived;
702     }
703 }
704 
705 /**
706  * @title SafeMath
707  * @dev Math operations with safety checks that throw on error
708  */
709 library SafeMath {
710 
711     /**
712     * @dev Multiplies two numbers, throws on overflow.
713     */
714     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
715         if (a == 0) {
716             return 0;
717         }
718         uint256 c = a * b;
719         assert(c / a == b);
720         return c;
721     }
722     
723     /**
724     * @dev Integer division of two numbers, truncating the quotient.
725     */
726     function div(uint256 a, uint256 b) internal pure returns (uint256) {
727         // assert(b > 0); // Solidity automatically throws when dividing by 0
728         uint256 c = a / b;
729         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
730         return c;
731     }
732 
733     /**
734     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
735     */
736     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
737         assert(b <= a);
738         return a - b;
739     }
740     
741      /**
742     * @dev Adds two numbers, throws on overflow.
743     */
744     function add(uint256 a, uint256 b) internal pure returns (uint256) {
745         uint256 c = a + b;
746         assert(c >= a);
747         return c;
748     }
749 }