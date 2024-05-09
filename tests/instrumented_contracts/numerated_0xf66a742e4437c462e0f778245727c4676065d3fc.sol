1 pragma solidity ^0.4.24;
2 /***
3 * Team JUST presents..
4 * ============================================================== *
5 RRRRRRRRRRRRRRRRR   BBBBBBBBBBBBBBBBB   XXXXXXX       XXXXXXX
6 R::::::::::::::::R  B::::::::::::::::B  X:::::X       X:::::X
7 R::::::RRRRRR:::::R B::::::BBBBBB:::::B X:::::X       X:::::X
8 RR:::::R     R:::::RBB:::::B     B:::::BX::::::X     X::::::X
9   R::::R     R:::::R  B::::B     B:::::BXXX:::::X   X:::::XXX
10   R::::R     R:::::R  B::::B     B:::::B   X:::::X X:::::X   
11   R::::RRRRRR:::::R   B::::BBBBBB:::::B     X:::::X:::::X    
12   R:::::::::::::RR    B:::::::::::::BB       X:::::::::X     
13   R::::RRRRRR:::::R   B::::BBBBBB:::::B      X:::::::::X     
14   R::::R     R:::::R  B::::B     B:::::B    X:::::X:::::X    
15   R::::R     R:::::R  B::::B     B:::::B   X:::::X X:::::X   
16   R::::R     R:::::R  B::::B     B:::::BXXX:::::X   X:::::XXX
17 RR:::::R     R:::::RBB:::::BBBBBB::::::BX::::::X     X::::::X
18 R::::::R     R:::::RB:::::::::::::::::B X:::::X       X:::::X
19 R::::::R     R:::::RB::::::::::::::::B  X:::::X       X:::::X
20 RRRRRRRR     RRRRRRRBBBBBBBBBBBBBBBBB   XXXXXXX       XXXXXXX
21 * ============================================================== *
22 */
23 contract risebox {
24     string public name = "RiseBox";
25     string public symbol = "RBX";
26     uint8 constant public decimals = 0;
27     uint8 constant internal dividendFee_ = 10;
28 
29     uint256 constant ONEDAY = 86400;
30     uint256 public lastBuyTime;
31     address public lastBuyer;
32     bool public isEnd = false;
33 
34     mapping(address => uint256) internal tokenBalanceLedger_;
35     mapping(address => uint256) internal referralBalance_;
36     mapping(address => int256) internal payoutsTo_;
37     uint256 internal profitPerShare_ = 0;
38     address internal foundation;
39     
40     uint256 internal tokenSupply_ = 0;
41     uint256 constant internal tokenPriceInitial_ = 1e14;
42     uint256 constant internal tokenPriceIncremental_ = 15e6;
43 
44 
45     /*=================================
46     =            MODIFIERS            =
47     =================================*/
48     // only people with tokens
49     modifier onlyBagholders() {
50         require(myTokens() > 0);
51         _;
52     }
53     
54     // only people with profits
55     modifier onlyStronghands() {
56         require(myDividends(true) > 0);
57         _;
58     }
59 
60     // healthy longevity
61     modifier antiEarlyWhale(uint256 _amountOfEthereum){
62         uint256 _balance = address(this).balance;
63 
64         if(_balance <= 1000 ether) {
65             require(_amountOfEthereum <= 2 ether);
66             _;
67         } else {
68             _;
69         }
70     }
71     /*==============================
72     =            EVENTS            =
73     ==============================*/
74     event onTokenPurchase(
75         address indexed customerAddress,
76         uint256 incomingEthereum,
77         uint256 tokensMinted,
78         address indexed referredBy
79     );
80     
81     
82     event onReinvestment(
83         address indexed customerAddress,
84         uint256 ethereumReinvested,
85         uint256 tokensMinted
86     );
87     
88     event onWithdraw(
89         address indexed customerAddress,
90         uint256 ethereumWithdrawn
91     );
92     // ERC20
93     event Transfer(
94         address indexed from,
95         address indexed to,
96         uint256 tokens
97     );
98 
99     constructor () public {
100         foundation =  msg.sender;
101         lastBuyTime = now;
102     }
103 
104     function buy(address _referredBy) 
105         public 
106         payable 
107         returns(uint256)
108     {
109         assert(isEnd==false);
110 
111         if(breakDown()) {
112             return liquidate();
113         } else {
114             return purchaseTokens(msg.value, _referredBy);
115         }
116     }
117 
118     function()
119         payable
120         public
121     {
122         assert(isEnd==false);
123 
124         if(breakDown()) {
125             liquidate();
126         } else {
127             purchaseTokens(msg.value, 0x00);
128         }
129     }
130 
131     /**
132      * Converts all of caller's dividends to tokens.
133      */
134     function reinvest()
135         onlyStronghands() //针对有利润的客户
136         public
137     {
138         // fetch dividends
139         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
140         
141         // pay out the dividends virtually
142         address _customerAddress = msg.sender;
143         payoutsTo_[_customerAddress] +=  (int256) (_dividends);
144         
145         // retrieve ref. bonus
146         _dividends += referralBalance_[_customerAddress];
147         referralBalance_[_customerAddress] = 0;
148         
149         // dispatch a buy order with the virtualized "withdrawn dividends"
150         uint256 _tokens = purchaseTokens(_dividends, 0x00);
151         
152         // fire event
153         emit onReinvestment(_customerAddress, _dividends, _tokens);
154     }
155 
156 
157     /**
158      * Alias of sell() and withdraw().
159      */
160     function exit(address _targetAddress)
161         public
162     {
163         // get token count for caller & sell them all
164         address _customerAddress = msg.sender;
165         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
166         if(_tokens > 0) sell(_tokens);
167         
168         // lambo delivery service
169         withdraw(_targetAddress);
170     }
171 
172 
173     function sell(uint256 _amountOfTokens)
174         onlyBagholders()
175         internal
176     {
177         // setup data
178         address _customerAddress = msg.sender;
179         // russian hackers BTFO
180         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
181         
182         uint256 _tokens = _amountOfTokens;
183         uint256 _ethereum = tokensToEthereum_(_tokens);
184         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
185         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
186 
187         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
188         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
189 
190         // update dividends tracker
191         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum));
192         payoutsTo_[_customerAddress] -= _updatedPayouts;       
193         
194         payoutsTo_[foundation] -= (int256)(_dividends);
195     }
196 
197 
198 
199     /**
200      * 提取ETH
201      */
202     function withdraw(address _targetAddress)
203         onlyStronghands()
204         internal
205     {
206         // setup data
207         address _customerAddress = msg.sender;
208         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
209         
210         // update dividend tracker
211         payoutsTo_[_customerAddress] +=  (int256) (_dividends);
212         
213         // add ref. bonus
214         _dividends += referralBalance_[_customerAddress];
215         referralBalance_[_customerAddress] = 0;
216         
217         // anti whale
218         if(_dividends > address(this).balance/2) {
219             _dividends = address(this).balance / 2;
220         }
221 
222         _targetAddress.transfer(_dividends);
223 
224         // fire event
225         emit onWithdraw(_targetAddress, _dividends);       
226     }
227 
228     /**
229      * Transfer tokens from the caller to a new holder.
230      * Remember, there's a 10% fee here as well.
231      */
232     function transfer(address _toAddress, uint256 _amountOfTokens)
233         onlyBagholders()
234         public
235         returns(bool)
236     {
237         // setup
238         address _customerAddress = msg.sender;
239         
240         // make sure we have the requested tokens
241         // also disables transfers until ambassador phase is over
242         // ( we dont want whale premines )
243         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
244         
245         // withdraw all outstanding dividends first
246         if(myDividends(true) > 0) withdraw(msg.sender);
247         
248 
249         // exchange tokens
250         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
251         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
252         
253         // update dividend trackers
254         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
255         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
256         
257         
258         // fire event
259         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
260         
261         // ERC20
262         return true;
263        
264     }
265 
266     /*==========================================
267     =            INTERNAL FUNCTIONS            =
268     ==========================================*/
269     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
270         antiEarlyWhale(_incomingEthereum)
271         internal
272         returns(uint256)
273     {
274         address _customerAddress = msg.sender; 
275         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
276         uint256 _referralBonus = SafeMath.div(_undividedDividends, 2); 
277         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus); 
278         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends); 
279 
280         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
281         uint256 _fee = _dividends;
282 
283         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
284 
285         if(
286             // is this a referred purchase?
287             _referredBy != 0x0000000000000000000000000000000000000000 &&
288 
289             // no cheating!
290             _referredBy != _customerAddress
291         ) {
292             // wealth redistribution
293             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
294         } else if (
295             _referredBy != _customerAddress
296         ){
297             payoutsTo_[foundation] -= (int256)(_referralBonus);
298         } else {
299             referralBalance_[foundation] -= _referralBonus;
300         }
301 
302         // we can't give people infinite ethereum
303         if(tokenSupply_ > 0){
304             
305             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
306 
307             _fee = _amountOfTokens * (_dividends / tokenSupply_);
308          
309         } else {
310             // add tokens to the pool
311             tokenSupply_ = _amountOfTokens;
312         }
313 
314         profitPerShare_ += SafeMath.div(_dividends , tokenSupply_);
315 
316         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
317 
318         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
319         payoutsTo_[_customerAddress] += _updatedPayouts;
320 
321         lastBuyTime = now;
322         lastBuyer = msg.sender;
323         // fire event
324         emit onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
325         return _amountOfTokens;
326     }
327 
328 
329     // ETH for Token
330     function ethereumToTokens_(uint256 _ethereum)
331         internal
332         view
333         returns(uint256)
334     {
335         uint256 _tokensReceived = 0;
336         
337         if(_ethereum < (tokenPriceInitial_ + tokenPriceIncremental_*tokenSupply_)) {
338             return _tokensReceived;
339         }
340 
341         _tokensReceived = 
342          (
343             (
344                 // underflow attempts BTFO
345                 SafeMath.sub(
346                     (SafeMath.sqrt
347                         (
348                             (tokenPriceInitial_**2)
349                             +
350                             (2 * tokenPriceIncremental_ * _ethereum)
351                             +
352                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
353                             +
354                             (2*(tokenPriceIncremental_)*tokenPriceInitial_*tokenSupply_)
355                         )
356                     ), tokenPriceInitial_
357                 )
358             )/(tokenPriceIncremental_)
359         )-(tokenSupply_)
360         ;
361   
362         return _tokensReceived;
363     }
364 
365     // Token for eth
366     function tokensToEthereum_(uint256 _tokens)
367         internal
368         view
369         returns(uint256)
370     {
371         uint256 _etherReceived = 
372 
373         SafeMath.sub(
374             _tokens * (tokenPriceIncremental_ * tokenSupply_ +     tokenPriceInitial_) , 
375             (_tokens**2)*tokenPriceIncremental_/2
376         );
377 
378         return _etherReceived;
379     }
380 
381 
382     /**
383      * Retrieve the dividend balance of any single address.
384      */
385     function dividendsOf(address _customerAddress)
386         internal
387         view
388         returns(uint256)
389     {
390         int256 _dividend = (int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress];
391 
392         if(_dividend < 0) {
393             _dividend = 0;
394         }
395         return (uint256)(_dividend);
396     }
397 
398 
399     /**
400      * Retrieve the token balance of any single address.
401      */
402     function balanceOf(address _customerAddress)
403         internal
404         view
405         returns(uint256)
406     {
407         return tokenBalanceLedger_[_customerAddress];
408     }
409 
410     /**
411      * to check is game breakdown.
412      */
413     function breakDown() 
414         internal
415         returns(bool)
416     {
417         // is game ended
418         if (lastBuyTime + ONEDAY < now) {
419             isEnd = true;
420             return true;
421         } else {
422             return false;
423         }
424     }
425 
426     function liquidate()
427         internal
428         returns(uint256)
429     {
430         // you are late,so sorry
431         msg.sender.transfer(msg.value);
432 
433         // Ethereum in pool
434         uint256 _balance = address(this).balance;
435         // taxed
436         uint256 _taxedEthereum = _balance * 88 / 100;
437         // tax value
438         uint256 _tax = SafeMath.sub(_balance , _taxedEthereum);
439 
440         foundation.transfer(_tax);
441         lastBuyer.transfer(_taxedEthereum);
442 
443         return _taxedEthereum;
444     }
445 
446     /*----------  HELPERS AND CALCULATORS  ----------*/
447     /**
448      * Method to view the current Ethereum stored in the contract
449      * Example: totalEthereumBalance()
450      */
451     function totalEthereumBalance()
452         public
453         view
454         returns(uint)
455     {
456         return address(this).balance;
457     }
458     
459     /**
460      * Retrieve the total token supply.
461      */
462     function totalSupply()
463         public
464         view
465         returns(uint256)
466     {
467         return tokenSupply_;
468     }
469     
470     /**
471      * Retrieve the tokens owned by the caller.
472      */
473     function myTokens()
474         public
475         view
476         returns(uint256)
477     {
478         address _customerAddress = msg.sender;
479         return balanceOf(_customerAddress);
480     }
481    
482     /**
483      * Retrieve the dividends owned by the caller.
484      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
485      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
486      * But in the internal calculations, we want them separate. 
487      */ 
488     function myDividends(bool _includeReferralBonus) 
489         public 
490         view 
491         returns(uint256)
492     {
493         address _customerAddress = msg.sender;
494         return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
495     }
496     
497     /**
498      * Return the buy price of 1 individual token.
499      */
500     function sellPrice() 
501         public 
502         view 
503         returns(uint256)
504     {
505         // our calculation relies on the token supply, so we need supply. Doh.
506         if(tokenSupply_ == 0){
507             return tokenPriceInitial_ - tokenPriceIncremental_;
508         } else {
509             uint256 _ethereum = tokensToEthereum_(1);
510             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
511             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
512             return _taxedEthereum;
513         }
514     }
515     
516     /**
517      * Return the sell price of 1 individual token.
518      */
519     function buyPrice() 
520         public 
521         view 
522         returns(uint256)
523     {
524         // our calculation relies on the token supply, so we need supply. Doh.
525         if(tokenSupply_ == 0){
526             return tokenPriceInitial_ + tokenPriceIncremental_;
527         } else {
528             uint256 _ethereum = tokensToEthereum_(1);
529             uint256 _dividends = SafeMath.div(_ethereum, (dividendFee_-1)  );
530             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
531             return _taxedEthereum;
532         }
533     }
534     
535     /**
536      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
537      */
538     function calculateTokensReceived(uint256 _ethereumToSpend) 
539         public 
540         view 
541         returns(uint256)
542     {
543         // overflow check
544         require(_ethereumToSpend <= 1e32 , "number is too big");
545         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
546         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
547         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
548         return _amountOfTokens;
549     }
550     
551     /**
552      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
553      */
554     function calculateEthereumReceived(uint256 _tokensToSell) 
555         public 
556         view 
557         returns(uint256)
558     {
559         require(_tokensToSell <= tokenSupply_);
560         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
561         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
562         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
563         return _taxedEthereum;
564     }
565 
566 }
567 
568 
569 /**
570  * @title SafeMath v0.1.9
571  * @dev Math operations with safety checks that throw on error
572  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
573  * - added sqrt
574  * - added sq
575  * - added pwr 
576  * - changed asserts to requires with error log outputs
577  * - removed div, its useless
578  */
579 library SafeMath {
580     
581     /**
582     * @dev Multiplies two numbers, throws on overflow.
583     */
584     function mul(uint256 a, uint256 b) 
585         internal 
586         pure 
587         returns (uint256 c) 
588     {
589         if (a == 0) {
590             return 0;
591         }
592         c = a * b;
593         require(c / a == b, "SafeMath mul failed");
594         return c;
595     }
596 
597     /**
598     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
599     */
600     function div(uint256 a, uint256 b) internal pure returns (uint256) {
601       require(b > 0); // Solidity only automatically asserts when dividing by 0
602       uint256 c = a / b;
603       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
604 
605       return c;
606     }
607 
608     /**
609     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
610     */
611     function sub(uint256 a, uint256 b)
612         internal
613         pure
614         returns (uint256) 
615     {
616         require(b <= a, "SafeMath sub failed");
617         return a - b;
618     }
619 
620     /**
621     * @dev Adds two numbers, throws on overflow.
622     */
623     function add(uint256 a, uint256 b)
624         internal
625         pure
626         returns (uint256 c) 
627     {
628         c = a + b;
629         require(c >= a, "SafeMath add failed");
630         return c;
631     }
632 
633     /**
634      * @dev gives square root of given x.
635      */
636     function sqrt(uint256 x)
637         internal
638         pure
639         returns (uint256 y) 
640     {
641         uint256 z = ((add(x,1)) / 2);
642         y = x;
643         while (z < y) 
644         {
645             y = z;
646             z = ((add((x / z),z)) / 2);
647         }
648 
649         return y;
650     }
651 
652 }