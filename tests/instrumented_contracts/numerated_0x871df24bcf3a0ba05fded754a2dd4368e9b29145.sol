1 pragma solidity ^0.4.24;
2 
3 
4 
5 contract SHT_Token 
6 {
7 
8     /*=================================
9     =            MODIFIERS            =
10     =================================*/
11     // only people with tokens
12     modifier onlyTokenHolders() 
13     {
14         require(myTokens() > 0);
15         _;
16     }
17     
18     // only people with profits
19     modifier onlyDividendPositive() 
20     {
21         require(myDividends() > 0);
22         _;
23     }
24 
25     // only owner
26     modifier onlyOwner() 
27     { 
28         require (address(msg.sender) == owner); 
29         _; 
30     }
31     
32     // only founders if contract not live
33     modifier onlyFoundersIfNotPublic() 
34     {
35         if(!openToThePublic)
36         {
37             require (founders[address(msg.sender)] == true);   
38         }
39         _;
40     }    
41 
42     /*==============================
43     =            EVENTS            =
44     ==============================*/
45     event onTokenPurchase(
46         address indexed customerAddress,
47         uint256 incomingEthereum,
48         uint256 tokensMinted
49     );
50     
51     event onTokenSell(
52         address indexed customerAddress,
53         uint256 tokensBurned,
54         uint256 ethereumEarned
55     );
56     
57     event onReinvestment(
58         address indexed customerAddress,
59         uint256 ethereumReinvested,
60         uint256 tokensMinted
61     );
62     
63     event onWithdraw(
64         address indexed customerAddress,
65         uint256 ethereumWithdrawn
66     );
67     
68     event lotteryPayout(
69         address customerAddress, 
70         uint256 lotterySupply
71     );
72     
73     event whaleDump(
74         uint256 amount
75     );
76     
77     // ERC20
78     event Transfer(
79         address indexed from,
80         address indexed to,
81         uint256 tokens
82     );
83     
84     
85     /*=====================================
86     =            CONFIGURABLES            =
87     =====================================*/
88     string public name = "SHT Token";
89     string public symbol = "SHT";
90     bool public openToThePublic = false;
91     address public owner;
92     address public dev;
93     uint8 constant public decimals = 18;
94     uint8 constant internal dividendFee = 10;  //11% (total.. breakdown is 5% tokenholders, 2.5% OB2, 1.5% whale, 1% lottery, 1% dev)
95     uint8 constant internal lotteryFee = 5; 
96     uint8 constant internal devFee = 5; 
97     uint8 constant internal ob2Fee = 2;  
98     uint256 constant internal tokenPrice = 400000000000000;  //0.0004 ether
99     uint256 constant internal magnitude = 2**64;
100     Onigiri2 private ob2; 
101    
102 
103     
104    /*================================
105     =            DATASETS            =
106     ================================*/
107     mapping(address => uint256) internal publicTokenLedger;
108     mapping(address => uint256) public   whaleLedger;
109     mapping(address => int256) internal payoutsTo_;
110     mapping(address => bool) internal founders;
111     address[] lotteryPlayers;
112     uint256 internal lotterySupply = 0;
113     uint256 internal tokenSupply = 0;
114     uint256 internal profitPerShare_;
115     
116     /*=======================================
117     =            PUBLIC FUNCTIONS            =
118     =======================================*/
119     /*
120     * -- APPLICATION ENTRY POINTS --  
121     */
122     constructor()
123         public
124     {
125         // no admin, but the owner of the contract is the address used for whale
126         owner = address(msg.sender);
127 
128         dev = address(0x7e474fe5Cfb720804860215f407111183cbc2f85); //some SHT Dev
129 
130         // add founders here... Founders don't get any special priveledges except being first in line at launch day
131         founders[0x013f3B8C9F1c4f2f28Fd9cc1E1CF3675Ae920c76] = true; //Nomo
132         founders[0xF57924672D6dBF0336c618fDa50E284E02715000] = true; //Bungalogic
133         founders[0xE4Cf94e5D30FB4406A2B139CD0e872a1C8012dEf] = true; //Ivan
134 
135         // link this contract to OB2 contract to send rewards
136         ob2 = Onigiri2(0xb8a68f9B8363AF79dEf5c5e11B12e8A258cE5be8); //MainNet
137     }
138     
139      
140     /**
141      * Converts all incoming ethereum to tokens for the caller, and passes down the referral address
142      */
143     function buy()
144         onlyFoundersIfNotPublic()
145         public
146         payable
147         returns(uint256)
148     {
149         require (msg.sender == tx.origin);
150          uint256 tokenAmount;
151 
152         tokenAmount = purchaseTokens(msg.value); //redirects to purchaseTokens so same functionality
153 
154         return tokenAmount;
155     }
156     
157     /**
158      * Fallback function to handle ethereum that was send straight to the contract
159      */
160     function()
161         payable
162         public
163     {
164        buy();
165     }
166     
167     /**
168      * Converts all of caller's dividends to tokens.
169      */
170     function reinvest()
171         onlyDividendPositive()
172         public
173     {   
174         require (msg.sender == tx.origin);
175         
176         // fetch dividends
177         uint256 dividends = myDividends(); 
178         
179         // pay out the dividends virtually
180         address customerAddress = msg.sender;
181         payoutsTo_[customerAddress] +=  int256(dividends * magnitude);
182         
183         // dispatch a buy order with the virtualized "withdrawn dividends"
184         uint256 _tokens = purchaseTokens(dividends);
185         
186         // fire event for logging 
187         emit onReinvestment(customerAddress, dividends, _tokens);
188     }
189     
190     /**
191      * Alias of sell() and withdraw().
192      */
193     function exit()
194         onlyTokenHolders()
195         public
196     {
197         require (msg.sender == tx.origin);
198         
199         // get token count for caller & sell them all
200         address customerAddress = address(msg.sender);
201         uint256 _tokens = publicTokenLedger[customerAddress];
202         
203         if(_tokens > 0) 
204         {
205             sell(_tokens);
206         }
207 
208         withdraw();
209     }
210 
211     /**
212      * Withdraws all of the callers earnings.
213      */
214     function withdraw()
215         onlyDividendPositive()
216         public
217     {
218         require (msg.sender == tx.origin);
219         
220         // setup data
221         address customerAddress = msg.sender;
222         uint256 dividends = myDividends(); 
223         
224         // update dividend tracker
225         payoutsTo_[customerAddress] +=  int256(dividends * magnitude);
226         
227         customerAddress.transfer(dividends);
228         
229         // fire event for logging 
230         emit onWithdraw(customerAddress, dividends);
231     }
232     
233     /**
234      * Liquifies tokens to ethereum.
235      */
236     function sell(uint256 _amountOfTokens)
237         onlyTokenHolders()
238         public
239     {
240         require (msg.sender == tx.origin);
241         require((_amountOfTokens <= publicTokenLedger[msg.sender]) && (_amountOfTokens > 0));
242 
243         uint256 _tokens = _amountOfTokens;
244         uint256 ethereum = tokensToEthereum_(_tokens);
245 
246         uint256 undividedDivs = SafeMath.div(ethereum, dividendFee);
247         
248         // from that 10%, divide for Community, Whale, Lottery, and OB2
249         uint256 communityDivs = SafeMath.div(undividedDivs, 2); //5%
250         uint256 ob2Divs = SafeMath.div(undividedDivs, 4); //2.5% 
251         uint256 lotteryDivs = SafeMath.div(undividedDivs, 10); // 1%
252         uint256 tip4Dev = lotteryDivs;
253         uint256 whaleDivs = SafeMath.sub(communityDivs, (ob2Divs + lotteryDivs));  // 1.5%
254 
255 
256         // let's deduct Whale, Lottery, and OB2 divs just to make sure our math is safe
257         uint256 dividends = SafeMath.sub(undividedDivs, (ob2Divs + lotteryDivs + whaleDivs));
258 
259         uint256 taxedEthereum = SafeMath.sub(ethereum, (undividedDivs + tip4Dev));
260 
261         //add divs to whale
262         whaleLedger[owner] += whaleDivs;
263         
264         //add tokens to the lotterySupply
265         lotterySupply += ethereumToTokens_(lotteryDivs);
266 
267         //send divs to OB2
268         ob2.fromGame.value(ob2Divs)();
269 
270         //send tip to Dev
271         dev.transfer(tip4Dev);
272         
273         // burn the sold tokens
274         tokenSupply -=  _tokens;
275         publicTokenLedger[msg.sender] -= _tokens;
276         
277         
278         // update dividends tracker
279         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (taxedEthereum * magnitude));
280         payoutsTo_[msg.sender] -= _updatedPayouts;  
281         
282         // dividing by zero is a bad idea
283         if (tokenSupply > 0) 
284         {
285             // update the amount of dividends per token
286             profitPerShare_ += ((dividends * magnitude) / tokenSupply);
287         }
288         
289         // fire event for logging 
290         emit onTokenSell(msg.sender, _tokens, taxedEthereum);
291     }
292     
293     
294     /**
295      * Transfer tokens from the caller to a new holder.
296      */
297     function transfer(address _toAddress, uint256 _amountOfTokens)
298         onlyTokenHolders()
299         public
300         returns(bool)
301     {
302         assert(_toAddress != owner);
303         
304         // make sure we have the requested tokens
305         require((_amountOfTokens <= publicTokenLedger[msg.sender]) && (_amountOfTokens > 0 ));
306             // exchange tokens
307         publicTokenLedger[msg.sender] -= _amountOfTokens;
308         publicTokenLedger[_toAddress] += _amountOfTokens; 
309         
310         // update dividend trackers
311         payoutsTo_[msg.sender] -= int256(profitPerShare_ * _amountOfTokens);
312         payoutsTo_[_toAddress] += int256(profitPerShare_ * _amountOfTokens); 
313             
314         // fire event for logging 
315         emit Transfer(msg.sender, _toAddress, _amountOfTokens); 
316 
317         return true;     
318     }
319     
320     /*----------  OWNER ONLY FUNCTIONS  ----------*/
321 
322     /**
323      * Want to prevent snipers from buying prior to launch
324      */
325     function goPublic() 
326         onlyOwner()
327         public 
328         returns(bool)
329 
330     {
331         openToThePublic = true;
332         return openToThePublic;
333     }
334     
335     
336     /*----------  HELPERS AND CALCULATORS  ----------*/
337     /**
338      * Method to view the current Ethereum stored in the contract
339      */
340     function totalEthereumBalance()
341         public
342         view
343         returns(uint)
344     {
345         return address(this).balance;
346     }
347     
348     /**
349      * Retrieve the total token supply.
350      */
351     function totalSupply()
352         public
353         view
354         returns(uint256)
355     {
356         return (tokenSupply + lotterySupply); //adds the tokens from ambassadors to the supply (but not to the dividends calculation which is based on the supply)
357     }
358     
359     /**
360      * Retrieve the tokens owned by the caller.
361      */
362     function myTokens()
363         public
364         view
365         returns(uint256)
366     {
367         return balanceOf(msg.sender);
368     }
369 
370     /**
371      * Retrieve the balance of the whale.
372      */
373     function whaleBalance()
374         public
375         view
376         returns(uint256)
377     {
378         return  whaleLedger[owner]; 
379     }
380 
381 
382     /**
383      * Retrieve the balance of the whale.
384      */
385     function lotteryBalance()
386         public
387         view
388         returns(uint256)
389     {
390         return  lotterySupply; 
391     }
392     
393     
394     /**
395      * Retrieve the dividends owned by the caller.
396      */ 
397     function myDividends() 
398         public 
399         view 
400         returns(uint256)
401     {
402         return dividendsOf(msg.sender);
403     }
404     
405     /**
406      * Retrieve the token balance of any single address.
407      */
408     function balanceOf(address customerAddress)
409         view
410         public
411         returns(uint256)
412     {
413         return publicTokenLedger[customerAddress];
414     }
415     
416     /**
417      * Retrieve the dividend balance of any single address.
418      */
419     function dividendsOf(address customerAddress)
420         view
421         public
422         returns(uint256)
423     {
424       return (uint256) ((int256)(profitPerShare_ * publicTokenLedger[customerAddress]) - payoutsTo_[customerAddress]) / magnitude;
425     }
426     
427     /**
428      * Return the buy and sell price of 1 individual token.
429      */
430     function buyAndSellPrice()
431     public
432     pure 
433     returns(uint256)
434     {
435         uint256 ethereum = tokenPrice;
436         uint256 dividends = SafeMath.div((ethereum * dividendFee ), 100);
437         uint256 taxedEthereum = SafeMath.sub(ethereum, dividends);
438         return taxedEthereum;
439     }
440     
441     /**
442      * Function for the frontend to dynamically retrieve the price of buy orders.
443      */
444     function calculateTokensReceived(uint256 ethereumToSpend) 
445         public 
446         pure 
447         returns(uint256)
448     {
449         require(ethereumToSpend >= tokenPrice);
450         uint256 dividends = SafeMath.div((ethereumToSpend * dividendFee), 100);
451         uint256 taxedEthereum = SafeMath.sub(ethereumToSpend, dividends);
452         uint256 amountOfTokens = ethereumToTokens_(taxedEthereum);
453         
454         return amountOfTokens;
455     }
456     
457     /**
458      * Function for the frontend to dynamically retrieve the price of sell orders.
459      */
460     function calculateEthereumReceived(uint256 tokensToSell) 
461         public 
462         view 
463         returns(uint256)
464     {
465         require(tokensToSell <= tokenSupply);
466         uint256 ethereum = tokensToEthereum_(tokensToSell);
467         uint256 dividends = SafeMath.div((ethereum * dividendFee ), 100);
468         uint256 taxedEthereum = SafeMath.sub(ethereum, dividends);
469         return taxedEthereum;
470     }
471     
472     
473     /*==========================================
474     =            INTERNAL FUNCTIONS            =
475     ==========================================*/
476     
477     function purchaseTokens(uint256 incomingEthereum)
478         internal
479         returns(uint256)
480     {
481         // take out 10% of incoming eth for divs
482         uint256 undividedDivs = SafeMath.div(incomingEthereum, dividendFee);
483         
484         // from that 10%, divide for Community, Whale, Lottery, and OB2
485         uint256 communityDivs = SafeMath.div(undividedDivs, 2); //5%
486         uint256 ob2Divs = SafeMath.div(undividedDivs, 4); //2.5% 
487         uint256 lotteryDivs = SafeMath.div(undividedDivs, 10); // 1%
488         uint256 tip4Dev = lotteryDivs;
489         uint256 whaleDivs = SafeMath.sub(communityDivs, (ob2Divs + lotteryDivs));  // 1.5%
490 
491         // let's deduct Whale, Lottery, devfee, and OB2 divs just to make sure our math is safe
492         uint256 dividends = SafeMath.sub(undividedDivs, (ob2Divs + lotteryDivs + whaleDivs));
493 
494         uint256 taxedEthereum = SafeMath.sub(incomingEthereum, (undividedDivs + tip4Dev));
495         uint256 amountOfTokens = ethereumToTokens_(taxedEthereum);
496 
497         //add divs to whale
498         whaleLedger[owner] += whaleDivs;
499         
500         //add tokens to the lotterySupply
501         lotterySupply += ethereumToTokens_(lotteryDivs);
502         
503         //add entry to lottery
504         lotteryPlayers.push(msg.sender);
505 
506         //send divs to OB2
507         ob2.fromGame.value(ob2Divs)();
508 
509         //tip the dev
510         dev.transfer(tip4Dev);
511        
512         uint256 fee = dividends * magnitude;
513  
514         require(amountOfTokens > 0 && (amountOfTokens + tokenSupply) > tokenSupply);
515 
516         uint256 payoutDividends = isWhalePaying();
517         
518         // we can't give people infinite ethereum
519         if(tokenSupply > 0)
520         {
521             // add tokens to the pool
522             tokenSupply += amountOfTokens;
523             
524              // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
525             profitPerShare_ += ((payoutDividends + dividends) * magnitude / (tokenSupply));
526             
527             // calculate the amount of tokens the customer receives over his purchase 
528             fee -= fee-(amountOfTokens * (dividends * magnitude / (tokenSupply)));
529         } else 
530         {
531             // add tokens to the pool
532             tokenSupply = amountOfTokens;
533             
534             //if there are zero tokens prior to this buy, and the whale is triggered, send dividends back to whale
535             if(whaleLedger[owner] == 0)
536             {
537                 whaleLedger[owner] = payoutDividends;
538             }
539         }
540 
541         // update circulating supply & the ledger address for the customer
542         publicTokenLedger[msg.sender] += amountOfTokens;
543         
544         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
545         int256 _updatedPayouts = int256((profitPerShare_ * amountOfTokens) - fee);
546         payoutsTo_[msg.sender] += _updatedPayouts;
547         
548      
549         // fire event for logging 
550         emit onTokenPurchase(msg.sender, incomingEthereum, amountOfTokens);
551         
552         return amountOfTokens;
553     }
554     
555     
556      /**
557      * Calculate token sell value.
558      * It's a simple algorithm. Hopefully, you don't need a whitepaper with it in scientific notation.
559      */
560     function isWhalePaying()
561     private
562     returns(uint256)
563     {
564         uint256 payoutDividends = 0;
565          // this is where we check for lottery winner
566         if(whaleLedger[owner] >= 1 ether)
567         {
568             if(lotteryPlayers.length > 0)
569             {
570                 uint256 winner = uint256(blockhash(block.number-1))%lotteryPlayers.length;
571                 
572                 publicTokenLedger[lotteryPlayers[winner]] += lotterySupply;
573                 emit lotteryPayout(lotteryPlayers[winner], lotterySupply);
574                 tokenSupply += lotterySupply;
575                 lotterySupply = 0;
576                 delete lotteryPlayers;
577                
578             }
579             //whale pays out everyone its divs
580             payoutDividends = whaleLedger[owner];
581             whaleLedger[owner] = 0;
582             emit whaleDump(payoutDividends);
583         }
584         return payoutDividends;
585     }
586 
587     /**
588      * Calculate Token price based on an amount of incoming ethereum
589      *It's a simple algorithm. Hopefully, you don't need a whitepaper with it in scientific notation.
590      */
591     function ethereumToTokens_(uint256 ethereum)
592         internal
593         pure
594         returns(uint256)
595     {
596         uint256 tokensReceived = ((ethereum / tokenPrice) * 1e18);
597                
598         return tokensReceived;
599     }
600     
601     /**
602      * Calculate token sell value.
603      * It's a simple algorithm. Hopefully, you don't need a whitepaper with it in scientific notation.
604      */
605      function tokensToEthereum_(uint256 coin)
606         internal
607         pure
608         returns(uint256)
609     {
610         uint256 ethReceived = tokenPrice * (SafeMath.div(coin, 1e18));
611         
612         return ethReceived;
613     }
614 }
615 
616 contract Onigiri2 
617 {
618     function fromGame() external payable;
619 }
620 
621 
622 /**
623  * @title SafeMath
624  * @dev Math operations with safety checks that throw on error
625  */
626 library SafeMath {
627     
628     /**
629     * @dev Integer division of two numbers, truncating the quotient.
630     */
631     function div(uint256 a, uint256 b) internal pure returns (uint256) {
632         // assert(b > 0); // Solidity automatically throws when dividing by 0
633         uint256 c = a / b;
634         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
635         return c;
636     }
637 
638     /**
639     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
640     */
641     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
642         assert(b <= a);
643         return a - b;
644     }
645 }