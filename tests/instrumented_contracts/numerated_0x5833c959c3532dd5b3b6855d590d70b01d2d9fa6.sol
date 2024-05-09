1 pragma solidity ^0.4.20;
2 /***
3  *    ______                                                         ____  __  
4  *   / ____/___  ____ ___  ____ ___  ____  ____ _      _____  ____ _/ / /_/ /_ 
5  *  / /   / __ \/ __ `__ \/ __ `__ \/ __ \/ __ \ | /| / / _ \/ __ `/ / __/ __ \
6  * / /___/ /_/ / / / / / / / / / / / /_/ / / / / |/ |/ /  __/ /_/ / / /_/ / / /
7  *  \____/\____/_/ /_/ /_/_/ /_/ /_/\____/_/ /_/|__/|__/\___/\__,_/_/\__/_/ /_/ 
8  *
9  *                                                                                                                                            
10  * v 1.1.0
11  * eWLTH - Commonwealth.gg deployed on ETH (based on contract @ ETC:0xDe6FB6a5adbe6415CDaF143F8d90Eb01883e42ac)
12  * Modifications: 
13  *   -> Ticker Name and Symbol 
14  *   -> dividendsOf Function
15  * 
16  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
17  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
18  * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE 
19  * OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
20  */
21 
22 contract Hourglass {
23     /*=================================
24     =            MODIFIERS            =
25     =================================*/
26     // only people with tokens
27     modifier onlyHolders() {
28         require(myTokens() > 0);
29         _;
30     }
31     
32     // only people with profits
33     modifier onlyStronghands() {
34         require(myDividends(true) > 0);
35         _;
36     }
37     
38     /*==============================
39     =            EVENTS            =
40     ==============================*/
41     event onTokenPurchase(
42         address indexed customerAddress,
43         uint256 incomingEthereum,
44         uint256 tokensMinted,
45         address indexed referredBy
46     );
47     
48     event onTokenSell(
49         address indexed customerAddress,
50         uint256 tokensBurned,
51         uint256 ethereumEarned
52     );
53     
54     event onReinvestment(
55         address indexed customerAddress,
56         uint256 ethereumReinvested,
57         uint256 tokensMinted
58     );
59     
60     event onWithdraw(
61         address indexed customerAddress,
62         uint256 ethereumWithdrawn
63     );
64     
65     // ERC20
66     event Transfer(
67         address indexed from,
68         address indexed to,
69         uint256 tokens
70     );
71     
72     
73     /*=====================================
74     =            CONFIGURABLES            =
75     =====================================*/
76     string public name = "ETH-Commonwealth-1.1.0";
77     string public symbol = "eWLTH";
78     uint8 constant public decimals = 18;
79     uint8 constant internal dividendFee_ = 10;
80     uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
81     uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
82     uint256 constant internal magnitude = 2**64;
83     
84    /*================================
85     =            DATASETS            =
86     ================================*/
87     // amount of shares for each address (scaled number)
88     mapping(address => uint256) internal tokenBalanceLedger_;
89     mapping(address => uint256) internal referralBalance_;
90     mapping(address => int256) internal payoutsTo_;
91     uint256 internal tokenSupply_ = 0;
92     uint256 internal profitPerShare_;
93     
94     /*=======================================
95     =            PUBLIC FUNCTIONS            =
96     =======================================*/
97     /*
98     * -- APPLICATION ENTRY POINTS --  
99     */
100     function Hourglass()
101         public
102     {
103     }
104     
105      
106     /**
107      * Converts all incoming ethereum to tokens for the caller, and passes down the referral addy (if any)
108      */
109     function buy(address _referredBy)
110         public
111         payable
112         returns(uint256)
113     {
114         purchaseTokens(msg.value, _referredBy);
115     }
116     
117     /**
118      * Fallback function to handle ethereum that was send straight to the contract
119      * Unfortunately we cannot use a referral address this way.
120      */
121     function()
122         payable
123         public
124     {
125         purchaseTokens(msg.value, 0x0);
126     }
127     
128     /**
129      * Converts all of caller's dividends to tokens.
130      */
131     function reinvest()
132         onlyStronghands()
133         public
134     {
135         // fetch dividends
136         uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code
137         
138         // pay out the dividends virtually
139         address _customerAddress = msg.sender;
140         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
141         
142         // retrieve ref. bonus
143         _dividends += referralBalance_[_customerAddress];
144         referralBalance_[_customerAddress] = 0;
145         
146         // dispatch a buy order with the virtualized "withdrawn dividends"
147         uint256 _tokens = purchaseTokens(_dividends, 0x0);
148         
149         // fire event
150         onReinvestment(_customerAddress, _dividends, _tokens);
151     }
152     
153     /**
154      * Alias of sell() and withdraw().
155      */
156     function exit()
157         public
158     {
159         // get token count for caller & sell them all
160         address _customerAddress = msg.sender;
161         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
162         if(_tokens > 0) sell(_tokens);
163         
164         // lambo delivery service
165         withdraw();
166     }
167 
168     /**
169      * Withdraws all of the callers earnings.
170      */
171     function withdraw()
172         onlyStronghands()
173         public
174     {
175         // setup data
176         address _customerAddress = msg.sender;
177         uint256 _dividends = myDividends(false); // get ref. bonus later in the code
178         
179         // update dividend tracker
180         payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);
181         
182         // add ref. bonus
183         _dividends += referralBalance_[_customerAddress];
184         referralBalance_[_customerAddress] = 0;
185         
186         // lambo delivery service
187         _customerAddress.transfer(_dividends);
188         
189         // fire event
190         onWithdraw(_customerAddress, _dividends);
191     }
192     
193     /**
194      * Liquifies tokens to ethereum.
195      */
196     function sell(uint256 _amountOfTokens)
197         onlyHolders()
198         public
199     {
200         // setup data
201         address _customerAddress = msg.sender;
202         // russian hackers BTFO
203         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
204         uint256 _tokens = _amountOfTokens;
205         uint256 _ethereum = tokensToEthereum_(_tokens);
206         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
207         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
208         
209         // burn the sold tokens
210         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
211         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
212         
213         // update dividends tracker
214         int256 _updatedPayouts = (int256) (profitPerShare_ * _tokens + (_taxedEthereum * magnitude));
215         payoutsTo_[_customerAddress] -= _updatedPayouts;       
216         
217         // dividing by zero is a bad idea
218         if (tokenSupply_ > 0) {
219             // update the amount of dividends per token
220             profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
221         }
222         
223         // fire event
224         onTokenSell(_customerAddress, _tokens, _taxedEthereum);
225     }
226     
227     
228     /**
229      * Transfer token to a different address. No fees.
230      */
231      function transfer(address _toAddress, uint256 _amountOfTokens) 
232         onlyHolders() 
233         public 
234         returns(bool) 
235     {
236         // cant send to 0 address
237         require(_toAddress != address(0));
238         // setup
239         address _customerAddress = msg.sender;
240 
241         // make sure we have the requested tokens
242         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
243 
244         // withdraw all outstanding dividends first
245         if(myDividends(true) > 0) withdraw();
246 
247         // exchange tokens
248         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
249         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
250 
251         // update dividend trackers
252         payoutsTo_[_customerAddress] -= (int256) (profitPerShare_ * _amountOfTokens);
253         payoutsTo_[_toAddress] += (int256) (profitPerShare_ * _amountOfTokens);
254 
255         // fire event
256         Transfer(_customerAddress, _toAddress, _amountOfTokens);
257 
258         // ERC20
259         return true;
260     }
261     
262     /*----------  HELPERS AND CALCULATORS  ----------*/
263     /**
264      * Method to view the current Ethereum stored in the contract
265      * Example: totalEthereumBalance()
266      */
267     function totalEthereumBalance()
268         public
269         view
270         returns(uint)
271     {
272         return this.balance;
273     }
274     
275     /**
276      * Retrieve the total token supply.
277      */
278     function totalSupply()
279         public
280         view
281         returns(uint256)
282     {
283         return tokenSupply_;
284     }
285     
286     /**
287      * Retrieve the tokens owned by the caller.
288      */
289     function myTokens()
290         public
291         view
292         returns(uint256)
293     {
294         address _customerAddress = msg.sender;
295         return balanceOf(_customerAddress);
296     }
297     
298     /**
299      * Retrieve the dividends owned by the caller.
300      * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
301      * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
302      * But in the internal calculations, we want them separate. 
303      */ 
304     function myDividends(bool _includeReferralBonus) 
305         public 
306         view 
307         returns(uint256)
308     {
309         address _customerAddress = msg.sender;
310         return dividendsOf(_customerAddress,_includeReferralBonus);
311     }
312     
313     /**
314      * Retrieve the token balance of any single address.
315      */
316     function balanceOf(address _customerAddress)
317         view
318         public
319         returns(uint256)
320     {
321         return tokenBalanceLedger_[_customerAddress];
322     }
323     
324     /**
325      * Retrieve the dividend balance of any single address.
326      */
327     function dividendsOf(address _customerAddress,bool _includeReferralBonus)
328         view
329         public
330         returns(uint256)
331     {
332         uint256 regularDividends = (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
333         if (_includeReferralBonus){
334             return regularDividends + referralBalance_[_customerAddress];
335         } else {
336             return regularDividends;
337         }
338     }
339     
340     /**
341      * Return the buy price of 1 individual token.
342      */
343     function sellPrice() 
344         public 
345         view 
346         returns(uint256)
347     {
348         // our calculation relies on the token supply, so we need supply. Doh.
349         if(tokenSupply_ == 0){
350             return tokenPriceInitial_ - tokenPriceIncremental_;
351         } else {
352             uint256 _ethereum = tokensToEthereum_(1e18);
353             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
354             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
355             return _taxedEthereum;
356         }
357     }
358     
359     /**
360      * Return the sell price of 1 individual token.
361      */
362     function buyPrice() 
363         public 
364         view 
365         returns(uint256)
366     {
367         // our calculation relies on the token supply, so we need supply. Doh.
368         if(tokenSupply_ == 0){
369             return tokenPriceInitial_ + tokenPriceIncremental_;
370         } else {
371             uint256 _ethereum = tokensToEthereum_(1e18);
372             uint256 _dividends = SafeMath.div(_ethereum, dividendFee_  );
373             uint256 _taxedEthereum = SafeMath.add(_ethereum, _dividends);
374             return _taxedEthereum;
375         }
376     }
377     
378     /**
379      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
380      */
381     function calculateTokensReceived(uint256 _ethereumToSpend) 
382         public 
383         view 
384         returns(uint256)
385     {
386         uint256 _dividends = SafeMath.div(_ethereumToSpend, dividendFee_);
387         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
388         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
389         
390         return _amountOfTokens;
391     }
392     
393     /**
394      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
395      */
396     function calculateEthereumReceived(uint256 _tokensToSell) 
397         public 
398         view 
399         returns(uint256)
400     {
401         require(_tokensToSell <= tokenSupply_);
402         uint256 _ethereum = tokensToEthereum_(_tokensToSell);
403         uint256 _dividends = SafeMath.div(_ethereum, dividendFee_);
404         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
405         return _taxedEthereum;
406     }
407     
408     
409     /*==========================================
410     =            INTERNAL FUNCTIONS            =
411     ==========================================*/
412     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
413         internal
414         returns(uint256)
415     {
416         // data setup
417         address _customerAddress = msg.sender;
418         uint256 _undividedDividends = SafeMath.div(_incomingEthereum, dividendFee_);
419         uint256 _referralBonus = SafeMath.div(_undividedDividends, 3);
420         uint256 _dividends = SafeMath.sub(_undividedDividends, _referralBonus);
421         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _undividedDividends);
422         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum);
423         uint256 _fee = _dividends * magnitude;
424  
425         // prevents overflow
426         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
427         
428         if(
429             // is this a referred purchase?
430             _referredBy != 0x0000000000000000000000000000000000000000
431         ){
432             // wealth redistribution
433             referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
434         } else {
435             // no ref purchase
436             // add the referral bonus back to the global dividends cake
437             _dividends = SafeMath.add(_dividends, _referralBonus);
438             _fee = _dividends * magnitude;
439         }
440         
441         // we can't give people infinite ethereum
442         if(tokenSupply_ > 0){
443             
444             // add tokens to the pool
445             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
446  
447             // take the amount of dividends gained through this transaction, and allocates them evenly to each participant
448             profitPerShare_ += (_dividends * magnitude / (tokenSupply_));
449             
450             // calculate the amount of tokens the customer receives over his purchase 
451             _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));
452         
453         } else {
454             // add tokens to the pool
455             tokenSupply_ = _amountOfTokens;
456         }
457         
458         // update circulating supply & the ledger address for the customer
459         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
460         
461         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
462         // really i know you think you do but you don't
463         int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
464         payoutsTo_[_customerAddress] += _updatedPayouts;
465         
466         // fire event
467         onTokenPurchase(_customerAddress, _incomingEthereum, _amountOfTokens, _referredBy);
468         
469         return _amountOfTokens;
470     }
471 
472     /**
473      * Calculate Token price based on an amount of incoming ethereum
474      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
475      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
476      */
477     function ethereumToTokens_(uint256 _ethereum)
478         internal
479         view
480         returns(uint256)
481     {
482         uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
483         uint256 _tokensReceived = 
484          (
485             (
486                 // underflow attempts BTFO
487                 SafeMath.sub(
488                     (sqrt
489                         (
490                             (_tokenPriceInitial**2)
491                             +
492                             (2*(tokenPriceIncremental_ * 1e18)*(_ethereum * 1e18))
493                             +
494                             (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
495                             +
496                             (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
497                         )
498                     ), _tokenPriceInitial
499                 )
500             )/(tokenPriceIncremental_)
501         )-(tokenSupply_)
502         ;
503   
504         return _tokensReceived;
505     }
506     
507     /**
508      * Calculate token sell value.
509      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
510      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
511      */
512      function tokensToEthereum_(uint256 _tokens)
513         internal
514         view
515         returns(uint256)
516     {
517 
518         uint256 tokens_ = (_tokens + 1e18);
519         uint256 _tokenSupply = (tokenSupply_ + 1e18);
520         uint256 _etherReceived =
521         (
522             // underflow attempts BTFO
523             SafeMath.sub(
524                 (
525                     (
526                         (
527                             tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
528                         )-tokenPriceIncremental_
529                     )*(tokens_ - 1e18)
530                 ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
531             )
532         /1e18);
533         return _etherReceived;
534     }
535     
536     
537     //This is where all your gas goes, sorry
538     //Not sorry, you probably only paid 1 gwei
539     function sqrt(uint x) internal pure returns (uint y) {
540         uint z = (x + 1) / 2;
541         y = x;
542         while (z < y) {
543             y = z;
544             z = (x / z + z) / 2;
545         }
546     }
547 }
548 
549 /**
550  * @title SafeMath
551  * @dev Math operations with safety checks that throw on error
552  */
553 library SafeMath {
554 
555     /**
556     * @dev Multiplies two numbers, throws on overflow.
557     */
558     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
559         if (a == 0) {
560             return 0;
561         }
562         uint256 c = a * b;
563         assert(c / a == b);
564         return c;
565     }
566 
567     /**
568     * @dev Integer division of two numbers, truncating the quotient.
569     */
570     function div(uint256 a, uint256 b) internal pure returns (uint256) {
571         // assert(b > 0); // Solidity automatically throws when dividing by 0
572         uint256 c = a / b;
573         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
574         return c;
575     }
576 
577     /**
578     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
579     */
580     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
581         assert(b <= a);
582         return a - b;
583     }
584 
585     /**
586     * @dev Adds two numbers, throws on overflow.
587     */
588     function add(uint256 a, uint256 b) internal pure returns (uint256) {
589         uint256 c = a + b;
590         assert(c >= a);
591         return c;
592     }
593 }